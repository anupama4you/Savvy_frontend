public with sharing class LatitudePersonalCalculatorExtension {
    
    public Custom_Opportunity__c Opp;
    
    //Lelo                  2016-09-02
    private String fileGlobalPrefix = 'LatitudePersonal';
    //-
    public LatitudeCalculatorDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    //Other things
    Map<String,id> RecordTypes {get;set;}
    public List <LatitudePersonalRates__c> rates {get;set;}
    
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'Latitude Personal Loan';
    //-
    private Lenders__c lenderSettings {set;get;}
    static final Decimal REGISTRATION_FEE = 3.40;
    public LatitudePersonalCalculatorExtension(ApexPages.StandardController controller) {
                
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        
        qh = new QuotingToolHelper();
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        reset();

        preLoadQuotingValues();         

    }
    
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'LATI'.equals(lender.info.Code__c)) {
                    dto.carPrice = lender.carPrice;
                    dto.deposit = lender.deposit;
                    dto.term = lender.term;
                    dto.loanTypeDetail = lender.productLoanType;
                    dto.baseRate = lender.baseRate;
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }
    
    public Boolean isValidationOk() {
        return isValidationOk(false);
    }
    public Boolean isValidationOk(Boolean isApproval) {
        Boolean r = true;
        ericLPICalculate();
        // validation before calculation
        if (dto.carPrice == null || dto.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Finance amount should not be Zero.'));
            r = false;
        }
        // if (dto.applicationFee == null || dto.applicationFee == 0.0) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee should not be Zero.'));
        //     r = false;
        // }
        if (dto.dof == null || dto.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF should not be Zero.'));
            r = false;
        } else if (dto.dof > dto.getMaxDof()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max DOF exceeded'));
        }
        if (dto.ppsr == null /*|| dto.ppsr == 0.0*/) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR should not be null.'));
            r = false;
        }
        if (dto.clientRate == null || dto.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate should not be Zero.'));
            r = false;
        } else if (dto.baseRate > dto.clientRate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The Base Rate is below than the Client Rate.'));
            //r = false;
        }
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }

        //Lelo              2017-09-19
        if (dto.residualValue > 0 && dto.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You should not have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
    	//-
    	// Loan Purpose validation
        if(String.isBlank(dto.loanPurpose)){
          ApexPages.Severity sev = isApproval ? ApexPages.Severity.ERROR : ApexPages.Severity.WARNING;
          r = isApproval ? false : r;
          String msg = isApproval 
            ? 'The Loan Purpose needs to be inserted into the quoting tool' 
            : 'The Loan Purpose is neccessary for any approval';
          ApexPages.addMessage(new ApexPages.Message(sev, msg));        
        }
        if (dto.ppsr == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR should not be zero.'));
        }
        if (dto.registrationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Registration/Research Fee should not be zero.'));
        }
        //-
        return r;
    }
    
    public void calculate () {
        if (!isValidationOk()) {
            return;
        }
        
        // determine the loan type - consumer or commercial
        Boolean type = false;
        if (dto.paymentType == 'Advance') {
            type = true;
        }
        
        // calculate the total Amount for the finance
        dto.nafCalculated = dto.getRealtimeNaf();
                
        // calculate the payment rate based on client rate, which is determined by consultants
        decimal realRate = dto.clientRate/100;
        decimal futureValue = FinancialUtilities.fv(realRate/12,12,1000);
        decimal rate = FinancialUtilities.rate(1000, 12, 0, futureValue, realRate/12, false);
        System.debug('The calculated rate is: ' + rate);
        
        // calculate the monthly payment based on client rate
        dto.rental = FinancialUtilities.pmt(dto.nafCalculated, rate, dto.term, dto.residualValue, type);
        dto.rental = dto.rental.setScale(2);
        System.debug('rental' + dto.rental + '|' + dto.nafCalculated + '|' + rate + '|' + dto.term + '|' + dto.residualValue + '|' + type);
        
        // calculate the estimated commission
        Decimal commissionRate = 2.25;
        // if ('AAA'.equals(dto.loanTypeDetail)) {
        //     commissionRate = 1.5;
        // }
        dto.estimatedCommission = commissionRate / 100 * dto.getRealtimeNaf();
        dto.estimatedCommission = dto.estimatedCommission.setScale(2);
        System.debug('estimatedCommission|'+ dto.estimatedCommission + '|' + commissionRate + '|' + dto.getRealtimeNaf() + '|' + dto.clientRate + '|' + dto.loanTypeDetail + '|' + rates.size());
        
        if (dto.estimatedCommission <= 0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
    }
    
    public void dofCalculate() {
        dto.dof = dto.getDofCalculated(null);
        //System.debug('dofCalculate >> ' + dto.dof);
    }
    
    public void reset () {
        dto = new LatitudeCalculatorDTO();
        dto.init();
        
        //Initial values
        dto.loanType = 'Purchase';
        dto.productLoanType = 'Consumer Loan';
        dto.loanTypeDetail = 'Diamond Plus';
        dto.docFees = 0.0;
        dto.monthlyFee = lenderSettings.Monthly_Fee__c;
        dto.ppsr = lenderSettings.PPSR__c;
        dto.applicationFee = lenderSettings.Application_Fee__c;
        // dto.dof = lenderSettings.DOF__c;
        dto.baseRate = 0.0;
        dto.clientRate = 0.0;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        dto.vehicleGroup = '1';
        dto.awd = 'N';
        dto.turbo = 'N';
        dto.diesel = 'N';
        dto.registrationFee = 3.40;
        dto.loanPurpose = '';
        
        rates = LatitudePersonalRates__c.getAll().values();
        rates.sort();
        
        dto.loanTypeDetail = rates.get(0).Risk_Grade__c;
        dto.securedUnsecured = 'Secured';
        latitudeRecommendedRate();
    }
    
    public List<SelectOption> getRiskGradeOptions() {
        List<SelectOption> r = new List<SelectOption>();
        for (LatitudePersonalRates__c a: rates) {
            r.add(new SelectOption(a.Risk_Grade__c, a.Risk_Grade__c));
        }
        return r;
    }
    
    public void latitudeRecommendedRate() {
        for (LatitudePersonalRates__c a: rates) {
            if (dto.loanTypeDetail.equals(a.Risk_Grade__c)) {
                if('Secured'.equals(dto.securedUnsecured)) {
                    dto.baseRate = a.Secured__c;
                } else {
                    dto.baseRate = a.Unsecured__c;
                }
            }
        }
        if('Secured'.equals(dto.securedUnsecured)){
            dto.ppsr = lenderSettings.PPSR__c;
            dto.registrationFee = REGISTRATION_FEE;
        }else if('Unsecured'.equals(dto.securedUnsecured)){
            dto.ppsr = 0.00;
            dto.registrationFee = 0.00;
        }
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'LATITUDE PERSONAL LOAN CALCULATION';
        qDto.state = dto.state;
        qDto.vehicleGroup = dto.vehicleGroup;
        qDto.awd = dto.awd;
        qDto.turbo = dto.turbo;
        qDto.diesel = dto.diesel;
        qDto.gapLevel = dto.gapLevel;
        qDto.gap = String.valueOf(dto.gap);
        qDto.gapIncome = String.valueOf(dto.gapIncome);
        qDto.nwc = String.valueOf(dto.nwc);
        qDto.nwcIncome = String.valueOf(dto.nwcIncome);
        qDto.warrantyLevel = dto.warrantyLevel;
        qDto.warranty = String.valueOf(dto.warranty);
        qDto.warrantyIncome = String.valueOf(dto.warrantyIncome);
        qDto.ltiLevel = dto.ltiLevel;
        qDto.lti = String.valueOf(dto.lti);
        qDto.ltiIncome = String.valueOf(dto.ltiIncome);
        qDto.truckGapLevel = dto.truckGapLevel;
        qDto.truckGap = String.valueOf(dto.truckGap);
        qDto.truckGapIncome = String.valueOf(dto.truckGapIncome);
        qDto.taiLevel = dto.taiLevel;
        qDto.tai = String.valueOf(dto.tai);
        qDto.taiIncome = String.valueOf(dto.taiIncome);
        qDto.mvLevel = dto.mvLevel;
        qDto.mv = String.valueOf(dto.mv);
        qDto.mvIncome = String.valueOf(dto.mvIncome);
        //dto.cciLevel = String.valueOf(cciLevel);
        qDto.cci = String.valueOf(dto.cci);
        qDto.cciIncome = String.valueOf(dto.cciIncome);
        qDto.carPrice = String.valueOf(dto.carPrice);
        
        qDto.applicationFee = String.valueOf(dto.applicationFee);
        qDto.dof = String.valueOf(dto.dof);
        qDto.ppsr = String.valueOf(dto.ppsr);
        qDto.residualValue = String.valueOf(dto.residualValue);
        qDto.baseRate = String.valueOf(dto.baseRate);
        qDto.clientRate = String.valueOf(dto.clientRate);
        qDto.term = String.valueOf(dto.term);
        qDto.paymentType = dto.paymentType;
        qDto.estimatedCommission = String.valueOf(dto.estimatedCommission);
        qDto.insuranceIncome = String.valueOf(dto.getInsuranceIncome());
        qDto.dofResult = String.valueOf(dto.getDofResult());
        qDto.totalCommission = String.valueOf(dto.getTotalCommission());
        qDto.totalCommissionGst = String.valueOf(dto.getTotalCommissionGst());
        qDto.naf = String.valueOf(dto.nafCalculated);
        qDto.rental = String.valueOf(dto.rental);
        qDto.monthlyFee = String.valueOf(dto.monthlyFee);
        qDto.monthlyPayment = String.valueOf(dto.getMonthlyPayment());
        qDto.fortnightlyPayment = String.valueOf(dto.getFortnightlyPayment());
        qDto.weeklyPayment = String.valueOf(dto.getWeeklyPayment());
        //Latitude
        qDto.registrationFee = String.valueOf(dto.registrationFee);
        
        qDto.loanTypeDetail = dto.loanTypeDetail;

        qDto.loanType = dto.loanType;
        qDto.productLoanType = dto.productLoanType;
        
        if (dto.deposit != null) {
            qDto.deposit = String.valueOf(dto.deposit);
        }
        if (dto.tradeIn != null) {
            qDto.tradeIn = String.valueOf(dto.tradeIn);
        }
        if (dto.payoutOn != null) {
            qDto.payoutOn = String.valueOf(dto.payoutOn);
        }
        qDto.netDeposit = String.valueOf(dto.getNetDeposit());
        if(String.isNotBlank(dto.loanPurpose)){
            qDto.loanPurpose = dto.loanPurpose;
        }
        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id',Opp.Id);
        calcPdf.getParameters().put('lender', qDto.lender);
        calcPdf.getParameters().put('state', qDto.state);
        calcPdf.getParameters().put('vehicleGroup', qDto.vehicleGroup);
        calcPdf.getParameters().put('awd', qDto.awd);
        calcPdf.getParameters().put('turbo', qDto.turbo);
        calcPdf.getParameters().put('diesel', qDto.diesel);
        calcPdf.getParameters().put('gapLevel', qDto.gapLevel);
        calcPdf.getParameters().put('gap', qDto.gap);
        calcPdf.getParameters().put('gapIncome', qDto.gapIncome);
        calcPdf.getParameters().put('nwc', qDto.nwc);
        calcPdf.getParameters().put('nwcIncome', qDto.nwcIncome);
        calcPdf.getParameters().put('warrantyLevel', qDto.warrantyLevel);
        calcPdf.getParameters().put('warranty', qDto.warranty);
        calcPdf.getParameters().put('warrantyIncome', qDto.warrantyIncome);
        calcPdf.getParameters().put('ltiLevel', qDto.ltiLevel);
        calcPdf.getParameters().put('lti', qDto.lti);
        calcPdf.getParameters().put('ltiIncome', qDto.ltiIncome);
        calcPdf.getParameters().put('truckGapLevel', qDto.truckGapLevel);
        calcPdf.getParameters().put('truckGap', qDto.truckGap);
        calcPdf.getParameters().put('truckGapIncome', qDto.truckGapIncome);
        calcPdf.getParameters().put('taiLevel', qDto.taiLevel);
        calcPdf.getParameters().put('tai', qDto.tai);
        calcPdf.getParameters().put('taiIncome', qDto.taiIncome);
        calcPdf.getParameters().put('mvLevel', qDto.mvLevel);
        calcPdf.getParameters().put('mv', qDto.mv);
        calcPdf.getParameters().put('mvIncome', qDto.mvIncome);
        //calcPdf.getParameters().put('cciLevel', cciLevel);
        calcPdf.getParameters().put('cci', qDto.cci);
        calcPdf.getParameters().put('cciIncome', qDto.cciIncome);
        calcPdf.getParameters().put('carPrice', qDto.carPrice);
        
        calcPdf.getParameters().put('applicationFee', qDto.applicationFee);
        calcPdf.getParameters().put('dof', qDto.dof);
        calcPdf.getParameters().put('ppsr', qDto.ppsr);
        calcPdf.getParameters().put('residualValue', qDto.residualValue);
        calcPdf.getParameters().put('baseRate', qDto.baseRate);
        calcPdf.getParameters().put('clientRate', qDto.clientRate);
        calcPdf.getParameters().put('term', qDto.term);
        calcPdf.getParameters().put('paymentType', qDto.paymentType);
        calcPdf.getParameters().put('estimatedCommission', qDto.estimatedCommission);
        calcPdf.getParameters().put('insuranceIncome', qDto.insuranceIncome);
        calcPdf.getParameters().put('dofResult', qDto.dofResult);
        calcPdf.getParameters().put('totalCommission', qDto.totalCommission);
        calcPdf.getParameters().put('totalCommissionGst', qDto.totalCommissionGst);
        calcPdf.getParameters().put('naf', qDto.naf);
        calcPdf.getParameters().put('rental', qDto.rental);
        calcPdf.getParameters().put('monthlyFee', qDto.monthlyFee);
        calcPdf.getParameters().put('monthlyPayment', qDto.monthlyPayment);
        calcPdf.getParameters().put('fortnightlyPayment', qDto.fortnightlyPayment);
        calcPdf.getParameters().put('weeklyPayment', qDto.weeklyPayment);
        //pass variables about the product info
        
        calcPdf.getParameters().put('registrationFee', qDto.registrationFee);
        
        calcPdf.getParameters().put('loanTypeDetail', qDto.loanTypeDetail);
        calcPdf.getParameters().put('loanType', qDto.loanType);
        calcPdf.getParameters().put('productLoanType', qDto.productLoanType);
        
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('tradeIn', qDto.tradeIn);
        calcPdf.getParameters().put('payoutOn', qDto.payoutOn);
        calcPdf.getParameters().put('netDeposit', qDto.netDeposit);

        calcPdf.getParameters().put('customerProfile', dto.securedUnsecured);
        calcPdf.getParameters().put('clientRate', String.valueOf(dto.clientRate));
        calcPdf.getParameters().put('loanPurpose', qDto.loanPurpose);
        
        Boolean isSaveInCloud = false;
        if (prefixName.contains('APPROVAL')) {
            isSaveInCloud = true;
            String typeData = 'Quoting Calculation';
            if (prefixName.contains('AMENDMENT')) {
               typeData = 'Quoting Calculation (Amendment)';
            } else if (prefixName.contains('FORMAL_APPROVAL')) {
               typeData = 'Quoting Calculation (Formal Approval)';
            }
            ApplicationExtraDataHelper.upsertData(
                    Opp.Application__c, typeData, typeData, 
                    QuotingToolHelper.getApplicationQuoting(Opp.Application__c));
        }
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, calcPdf, isSaveInCloud);
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation saved successfully.'));
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk(true)) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity should not be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Storing quoting data
        saveQuotingParameters();

        //Lelo                                  2016-07-26
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = LENDER_QUOTING;
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = dto.loanType;
        updateProduct.Loan_Product__c = dto.productLoanType;
        updateProduct.Loan_Type_Detail__c = dto.loanTypeDetail;

        //updateProduct.Loan_Type__c = dto.loanTypeDetail;
        updateProduct.Loan_Term__c = dto.term;
        if (dto.residualValue == null || dto.residualValue == 0) {
            updateProduct.Balloon_Residual_Requested__c = 0;
        } else {
            updateProduct.Balloon_Residual_Requested__c = dto.residualValue;
        }
        updateProduct.Client_Rate__c = dto.clientRate;
        updateProduct.Payments__c = dto.getMonthlyPayment();
        updateProduct.Cost_of_Goods__c = dto.carPrice;
        if (dto.getNetDeposit() == null) {
            updateProduct.Deposit__c = 0;
        } else {
            updateProduct.Deposit__c = dto.getNetDeposit();
        }
        updateProduct.DOF__c = dto.dof;
        
        if (dto.estimatedCommission == null) {
            updateProduct.Brokerage__c = 0;
        } else {
            updateProduct.Brokerage__c = dto.estimatedCommission;
        }
        updateProduct.Lender_App_Fee__c = dto.applicationFee;
        updateProduct.Equalisation_Fee_PPSR__c = dto.ppsr + dto.registrationFee;
        
        //Lelo                      2016-07-26
        upsert updateProduct;
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        //-

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null;
    } // end of function
    
    
    //Lelo                                  2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
        if (!hasCalculationDone()) {
            return null;
        }
        saveQuotingParameters();
        return savePdf(fileGlobalPrefix);
    }
    
    public PageReference savePreApproval() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
    }
    //-
    
    //Lelo                                  2016-12-22
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (d != null) {
            System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Vehicle Details
            dto.state = d.Vehicle_Detail_State__c;
            dto.vehicleGroup = d.Vehicle_Detail_Group__c;
            dto.awd = d.Vehicle_Detail_AWD__c;
            dto.turbo = d.Vehicle_Detail_Turbo__c;
            dto.diesel = d.Vehicle_Detail_Diesel__c;
            //Insurance Product
            dto.gapLevel = d.Insurance_GAP_Type__c;
            dto.gap = d.Insurance_GAP_Retail_Price__c;
            dto.gapIncome = d.Insurance_GAP_Income__c;
            dto.warrantyLevel  = d.Insurance_Warranty_Type__c;
            dto.warranty = d.Insurance_Warranty_Retail_Price__c;
            dto.warrantyIncome = d.Insurance_Warranty_Income__c;
            dto.ltiLevel = d.Insurance_LTI_Type__c;
            dto.lti = d.Insurance_LTI_Retail_Price__c;
            dto.ltiIncome = d.Insurance_LTI_Income__c;
            dto.truckGapLevel = d.Insurance_Truck_GAP_Type__c;
            dto.truckGap = d.Insurance_Truck_GAP_Retail_Price__c;
            dto.truckGapIncome = d.Insurance_Truck_GAP_Income__c;
            dto.taiLevel = d.Insurance_TAI_Type__c;
            dto.tai = d.Insurance_TAI_Retail_Price__c;
            dto.taiIncome = d.Insurance_TAI_Income__c;
            dto.mvLevel = d.Insurance_MV_Type__c;
            dto.mv = d.Insurance_MV_Retail_Price__c;
            dto.mvIncome = d.Insurance_MV_Income__c;
            dto.cci = d.Insurance_AIC_Retail_Price__c;
            dto.cciIncome = d.Insurance_AIC_Income__c;
            dto.nwc = d.Insurance_NWC_Retail_Price__c;
            dto.nwcIncome = d.Insurance_NWC_Income__c;
            //Finance Details
            //Commons values
            dto.loanType = d.Loan_Type__c;
            dto.productLoanType = d.Loan_Product__c;
            dto.carPrice = d.Vehicle_Price__c;
            dto.deposit = d.Deposit__c;
            dto.tradeIn = d.Trade_In__c;
            dto.payoutOn = d.Payout_On__c;
            dto.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                dto.term = Integer.valueOf(d.Term__c);
            }

            if (LENDER_QUOTING.equals(d.Name)) {
                //Specific values
                dto.securedUnsecured = d.Category_Type__c;
                //d.Recommended_Rate__c = String.valueOf(dto.recommendedRate);
                
                dto.baseRate = d.Base_Rate__c;
                if (dto.baseRate != null) {
                    dto.baseRate = dto.baseRate.setScale(2);
                }
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }

                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.loanTypeDetail = d.Loan_Facility_Type__c;
                dto.monthlyFee = d.Monthly_Fee__c;
				dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.ppsr = d.PPSR__c;    
                dto.registrationFee = d.Registration_Fee__c;
                                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;
                dto.loanPurpose = d.Loan_Purpose__c;
                latitudeRecommendedRate();
            }
        }
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);
        Application_Quoting__c d = new Application_Quoting__c();
        Application_Quoting__c s = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (s != null) {
            System.debug('Setting the Quoting Id... for app >> ' + this.Opp.Application__c);
            d.Id = s.Id; 
        }
        //Associate Application / Opportunity
        d.Application__c = this.Opp.Application__c;
        d.Opportunity__c = this.Opp.Id;
        //Lender
        d.Name = LENDER_QUOTING;
        //Vehicle Details
        d.Vehicle_Detail_State__c = dto.state;
        d.Vehicle_Detail_Group__c = dto.vehicleGroup;
        d.Vehicle_Detail_AWD__c = dto.awd;
        d.Vehicle_Detail_Turbo__c = dto.turbo;
        d.Vehicle_Detail_Diesel__c = dto.diesel;
        //Insurance product
        d.Insurance_GAP_Type__c = dto.gapLevel;
        d.Insurance_GAP_Retail_Price__c = dto.gap;
        d.Insurance_GAP_Income__c = dto.gapIncome;
        d.Insurance_Warranty_Type__c = dto.warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = dto.warranty;
        d.Insurance_Warranty_Income__c = dto.warrantyIncome;
        d.Insurance_LTI_Type__c = dto.ltiLevel;
        d.Insurance_LTI_Retail_Price__c = dto.lti;
        d.Insurance_LTI_Income__c = dto.ltiIncome;
        d.Insurance_Truck_GAP_Type__c = dto.truckGapLevel;
        d.Insurance_Truck_GAP_Retail_Price__c = dto.truckGap;
        d.Insurance_Truck_GAP_Income__c = dto.truckGapIncome;
        d.Insurance_TAI_Type__c = dto.taiLevel;
        d.Insurance_TAI_Retail_Price__c = dto.tai;
        d.Insurance_TAI_Income__c = dto.taiIncome;
        d.Insurance_MV_Type__c = dto.mvLevel;
        d.Insurance_MV_Retail_Price__c = dto.mv;
        d.Insurance_MV_Income__c = dto.mvIncome;
        d.Insurance_AIC_Retail_Price__c = dto.cci;
        d.Insurance_AIC_Income__c = dto.cciIncome;
        d.Insurance_NWC_Retail_Price__c = dto.nwc;
        d.Insurance_NWC_Income__c = dto.nwcIncome;
         //Finance Details
        d.Loan_Type__c = dto.loanType;
        d.Loan_Product__c = dto.productLoanType;
        d.Loan_Facility_Type__c = dto.loanTypeDetail;

        d.Vehicle_Price__c = dto.carPrice;
        d.Deposit__c = dto.deposit;
        d.Trade_In__c = dto.tradeIn;
        d.Payout_On__c = dto.payoutOn;
        
        d.Application_Fee__c = dto.applicationFee;
        d.DOF__c = dto.dof;
        d.PPSR__c = dto.ppsr;
        d.Registration_Fee__c = dto.registrationFee;
        d.Residual_Value__c = dto.residualValue;
        
        //Loan Details
        if (dto.term != null) {
            d.Term__c = Decimal.valueOf(dto.term);
        }
        
        d.Category_Type__c = dto.securedUnsecured;
        d.Client_Rate__c =dto.clientRate;
        d.Base_Rate__c = dto.baseRate;

        d.Monthly_Fee__c = dto.monthlyFee;
        d.Payment__c = dto.paymentType;

        //Data calculated - Commission
        d.Commission_Estimation__c = dto.estimatedCommission;
        d.Commission_Insurance_Income__c = dto.getInsuranceIncome();
        d.Commission_DOF__c = dto.getDofResult();
        d.Commission_Total_GST_Exc__c = dto.getTotalCommission();
        //Data calculated - Repayment
        d.Rental__c = dto.rental;
        d.Repayment_Monthly__c = dto.getMonthlyPayment();
        d.Repayment_Fortnightly__c = dto.getFortnightlyPayment();
        d.Repayment_Weekly__c = dto.getWeeklyPayment();
        d.NAF__c = dto.nafCalculated;
		d.Loan_Purpose__c = dto.loanPurpose;
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);
    }
    //-      
    
    //Lelo                      2017-07-21
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidationOk();
        if (r) {
            calculate();
            if (dto.rental != null && dto.rental > 0) {
                r = true;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before proceeding with your request.'));
                r = false;
            }
        }
        return r;
    }

    public void sendCustomerEmail1() {
        System.debug('sendCustomerEmail1...');
        if (hasCalculationDone()) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone()) {
            try {
                Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
                EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
                System.debug('Quoting: ' + JSON.serializePretty(q));
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
    }
    //-
    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 12/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        for (String value : dto.cciLevels) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = dto.cciLevel;
        parameters.term = MATH.round(dto.getTermYears());
        parameters.initialAmount = dto.getRealtimeNaf();
        if ('A'.equals(dto.cciAcceptance))  {
            parameters.initialAmount -= dto.cci;
        }
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        
        if(results != null){
            dto.cci = results.premium;
	        dto.cciIncome = results.commission;
        }else{
            dto.cci = 0.00;
	        dto.cciIncome = 0.00;
        }
    }   

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}