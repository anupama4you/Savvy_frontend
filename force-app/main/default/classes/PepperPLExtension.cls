public with sharing class PepperPLExtension {
    public Custom_Opportunity__c Opp;
    
    private String fileGlobalPrefix = 'PepperPL';
        
    public PepperPLDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}
    public static final String LENDER_QUOTING = 'Pepper PL';
    private Map<String, Application_Quoting_Result__c> calResults;
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    
    private Lenders__c lenderSettings {set;get;}

    // TODO: remove code
    public Boolean isEquifaxActive {set;get;}
    public LenderAPIResponse__c equifaxRequest {set;get;}
    public String equifaxResponse {set;get;}
    public String equifaxDocType {set;get;}
    public String equifaxRequestBody {set;get;}
    // --

    public PepperPLExtension(ApexPages.StandardController controller) {
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
        
        reset();

        preLoadQuotingValues();
        
        
        String param = System.currentPageReference().getParameters().get('EQUIFAX');
        this.isEquifaxActive = String.isNotBlank(param);
        if (this.isEquifaxActive) {
          this.loadEquifaxData();
        }
        param = System.currentPageReference().getParameters().get('EQUIFAX');
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
                if (lender != null && lender.info != null && 'MON3'.equals(lender.info.Code__c)) {
                    dto.carPrice = lender.carPrice;
                    dto.deposit = lender.deposit;
                    dto.term = lender.term;
                    //Lelo                          2017-11-16
                    dto.clientRate = lender.clientRate;
                    dto.dof = lender.dofBase;
                    //
                    
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
        // validation before calculation
        if (dto.carPrice == null || dto.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Loan Amount cannot be Zero.'));
            r = false;
        }
        if (dto.getRealtimeNaf() < 5000.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Loan amount should not be less than $5.000'));
            r = false;	
        }
        if (dto.getRealtimeNaf() > 40000.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan amount should not be more than $40.000'));
            // r = false;
        }
        if (dto.applicationFee == null || dto.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        }
        if (dto.dof == null || dto.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (dto.dof > this.getMaxDOF()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max DOF exceed. Max value $' + this.getMaxDOF()));
            r = false;
        }
        if (dto.clientRate == null || dto.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } 
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } 
        //Lelo              2017-09-19
        if (dto.residualValue > 0 && dto.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        // Loan Purpose validation
        if(String.isBlank(dto.loanPurpose)){
          ApexPages.Severity sev = isApproval ? ApexPages.Severity.ERROR : ApexPages.Severity.WARNING;
          r = isApproval ? false : r;
          String msg = isApproval 
            ? 'The Loan Purpose needs to be inserted into the quoting tool' 
            : 'The Loan Purpose is neccessary for any approval';
          ApexPages.addMessage(new ApexPages.Message(sev, msg));        
        }
        //-
        return r;
    }
    
    public PageReference calculate () {
        if (!isValidationOk()) {
            return null;
        }
        this.calculateRepayments();
        return null;
    }
    
    public void reset () {
        this.lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        dto = new PepperPLDTO();
        dto.init();
        dto.loanType = 'Purchase';
        dto.productLoanType = 'Consumer Loan';
        dto.monthlyFee = lenderSettings.Monthly_Fee__c;
        dto.applicationFee = lenderSettings.Application_Fee__c;
        dto.dof = lenderSettings.DOF__c;
        dto.clientRate = null;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        dto.loanPurpose = '';
        //-
        
        this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'PEPPER PL CALCULATION';
        
        qDto.carPrice = String.valueOf(dto.carPrice);
        
        qDto.applicationFee = String.valueOf(dto.applicationFee);
        qDto.dof = String.valueOf(dto.dof);
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

        qDto.loanType = dto.loanType;
        qDto.productLoanType = dto.productLoanType;
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
        calcPdf.getParameters().put('mvLevel', null);
        calcPdf.getParameters().put('mv', String.valueOf(0.00));
        calcPdf.getParameters().put('mvIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('gapLevel', null);
        calcPdf.getParameters().put('gap', String.valueOf(0.00));
        calcPdf.getParameters().put('gapIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('taiLevel', null);
        calcPdf.getParameters().put('tai', String.valueOf(0.00));
        calcPdf.getParameters().put('taiIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('ltiLevel', null);
        calcPdf.getParameters().put('lti', String.valueOf(0.00));
        calcPdf.getParameters().put('ltiIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('warrantyLevel', null);
        calcPdf.getParameters().put('warranty', String.valueOf(0.00));
        calcPdf.getParameters().put('warrantyIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('nwc', String.valueOf(0.00));
        calcPdf.getParameters().put('nwcIncome', String.valueOf(0.00));
        calcPdf.getParameters().put('cciLevel', null);
        calcPdf.getParameters().put('cci', String.valueOf(0.00));
        calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        //-
        calcPdf.getParameters().put('carPrice', qDto.carPrice);
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('applicationFee', qDto.applicationFee);
        calcPdf.getParameters().put('dof', qDto.dof);
        calcPdf.getParameters().put('ppsr', '0.00');
        calcPdf.getParameters().put('residualValue', qDto.residualValue);
        //calcPdf.getParameters().put('baseRate', qDto.baseRate);
        calcPdf.getParameters().put('baseRate', '----');
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
        calcPdf.getParameters().put('loanTypeDetail', qDto.loanTypeDetail);
        calcPdf.getParameters().put('loanType', qDto.loanType);
        calcPdf.getParameters().put('productLoanType', qDto.productLoanType);
        
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('tradeIn', qDto.tradeIn);
        calcPdf.getParameters().put('payoutOn', qDto.payoutOn);
        calcPdf.getParameters().put('netDeposit', qDto.netDeposit);
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
        if (dto.rental == null || dto.rental <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Storing quoting data
        saveQuotingParameters();

        //Lelo 									2016-07-26
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
        updateProduct.Lender__c = 'Pepper';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = dto.loanType;
        updateProduct.Loan_Product__c = dto.productLoanType;

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
        updateProduct.Deposit__c = 0;
        updateProduct.DOF__c = dto.dof;
        
        if (dto.estimatedCommission == null) {
            updateProduct.Brokerage__c = 0;
        } else {
            updateProduct.Brokerage__c = dto.estimatedCommission;
        }
        updateProduct.Lender_App_Fee__c = dto.applicationFee;
        updateProduct.Equalisation_Fee_PPSR__c = 0.0;
        
        //Lelo                      2016-07-26
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    
    //Lelo									2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
        if (!hasCalculationDone()) {
            return null;
        }
        this.saveQuotingParameters();
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
        // Lelo             Insurance           2017-12-04
        this.quoting = d;
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }

            //--
            //Finance Details
            //Commons values
            dto.loanType = d.Loan_Type__c;
            dto.productLoanType = d.Loan_Product__c;
            dto.carPrice = d.Vehicle_Price__c;
            
            dto.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                dto.term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                //Specific values
                                
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.loanPurpose = d.Loan_Purpose__c;
                dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.monthlyFee = d.Monthly_Fee__c;
                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;
               
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

            }
            //realtimeNafCalc();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        }
        //Lelo              Insurance           2017-12-04
        if (this.quote == null) {
            this.quote = new Application_InsuranceQuote__c();
        } 
        //-
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
                
        //Lelo              Insurance           2017-12-04
        //Insurance product
        d.Insurance_MV_Type__c = null;
        d.Insurance_MV_Retail_Price__c = null;
        d.Insurance_MV_Income__c = null;
        d.Insurance_MV_Acceptance__c = null;

        d.Insurance_GAP_Type__c = null;
        d.Insurance_GAP_Retail_Price__c = null;
        d.Insurance_GAP_Income__c = null;
        d.Insurance_GAP_Acceptance__c = null;
        
        d.Insurance_TAI_Type__c = null;
        d.Insurance_TAI_Retail_Price__c = null;
        d.Insurance_TAI_Income__c = null;
        d.Insurance_TAI_Acceptance__c = null;

        d.Insurance_LTI_Type__c = null;
        d.Insurance_LTI_Retail_Price__c = null;
        d.Insurance_LTI_Income__c = null;
        d.Insurance_LTI_Acceptance__c = null;
        
        d.Insurance_Warranty_Type__c = null;
        d.Insurance_Warranty_Retail_Price__c = null;
        d.Insurance_Warranty_Income__c = null;
        d.Insurance_Warranty_Acceptance__c = null;

        d.Insurance_NWC_Retail_Price__c = null;
        d.Insurance_NWC_Income__c = null;
        d.Insurance_NWC_Plan__c = null;
        d.Insurance_NWC_Term__c = null;
        d.Insurance_NWC_Cost__c = null;
        d.Insurance_NWC_Acceptance__c = null;
        // Lelo             Insurance           2018-02-26
        d.Insurance_AIC_Type__c = null;
        d.Insurance_AIC_Retail_Price__c = null;
        d.Insurance_AIC_Income__c = null;
        d.Insurance_AIC_Acceptance__c = null;
        //-
            //Finance Details
        d.Loan_Type__c = dto.loanType;
        d.Loan_Product__c = dto.productLoanType;
        
        d.Vehicle_Price__c = dto.carPrice;
        d.Deposit__c = 0.0;
        d.Trade_In__c = 0.0;
        d.Payout_On__c = 0.0;
        
        d.Application_Fee__c = dto.applicationFee;
        d.DOF__c = dto.dof;
        
        d.Residual_Value__c = dto.residualValue;
        
        d.Client_Rate__c = dto.clientRate;
        d.Monthly_Fee__c = dto.monthlyFee;

        //Loan Details
        if (dto.term != null) {
            d.Term__c = Decimal.valueOf(dto.term);
        }
        //if (dto.ltv != null) {
        //	d.LTV__c = String.valueOf(dto.ltv);
        //} else {
        //	d.LTV__c = null;
        //}
        d.Payment__c = dto.paymentType;
        //d.Vedascore__c = dto.vedascore;

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
        d.NAF__c = dto.getRealtimeNaf();

        //Clean fields
        d.PPSR__c = null;
        d.Base_Rate__c = null;
        d.Brokerage__c = null;
        d.Loan_Facility_Type__c = null;
        d.Risk_Fee__c = null;
        d.Registration_Fee__c = null;
        d.Vehicle_Age__c = null;
        d.Adverse_Credit_File__c = null;
        d.Customer_Profile__c = null;
        d.Is_MotorCycles__c = null;
        d.Is_Caravans__c = null;
        d.Client_Tier__c = null;
        d.Rate_Options__c = null;
        d.Goods_sub_type__c = null;
        //Vehicle Details
        d.Vehicle_Detail_State__c = null;
        d.Vehicle_Detail_Group__c = null;
        d.Vehicle_Detail_AWD__c = null;
        d.Vehicle_Detail_Turbo__c = null;
        d.Vehicle_Detail_Diesel__c = null;
        d.Loan_Purpose__c = dto.loanPurpose;
        
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

        //Lelo                  Insurance               2017-12-04
        this.quoting = d;
        //--
        //save Insurance quote
        if (this.quote != null && this.quote.Id != null) {
            update this.quote;
        }
    }
    //-   
    
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
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
    }
    

    //Lelo                      2017-07-24   
    private void calculateRepayments() {
        //Reset results
        this.resetCalculationResult();
        //Quote
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        String quotingType = QuotingCalculation.CALC_QUOTING;
        param.totalAmount = dto.getTotalAmount(quotingType);
        param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        param.clientRate = dto.clientRate;
        param.paymentType = dto.paymentType;
        param.term = dto.term;
        param.dof = dto.dof;
        param.monthlyFee = dto.monthlyFee;
        param.residualValue = dto.residualValue;
        param.amountBaseComm = dto.getBaseCommission(quotingType);
        //param.amountBaseComm = param.getNaf();
        
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
            dto.estimatedCommission = r.Estimated_Commission__c;
            dto.nafCalculated = r.NAF__c;
            // dto.insuranceIncome = dto.getInsuranceIncome();
            dto.rental = r.Rental__c;
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

        //Protected
        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = dto.getTotalAmount(quotingType);
        param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        param.amountBaseComm = dto.getBaseCommission(quotingType);
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);
    }

    //Lelo                              2017-07-25
    private void resetCalculationResult() {
        dto.init();
        calResults = new Map<String, Application_Quoting_Result__c>();
    }

    public Decimal getMaxDOF() {
      return QuotingToolHelper.getNowFinanceMaxDOF(dto.getRealtimeNaf());
        // Decimal r = 550;
        // if (dto.getRealtimeNaf() >= 8000 && dto.getRealtimeNaf() < 10000) {
        //     r = 880;
        // } else if (dto.getRealtimeNaf() > 10000) {
        //     r = lenderSettings.DOF__c;
        // }
        // return r;
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    
    // TODO: remove below code
    // Lelo
    public void loadEquifaxData() {
      List<LenderAPIResponse__c> d = [
        SELECT Id, Response__c
        FROM LenderAPIResponse__c
        WHERE Opportunity__c = :this.opp.Id
        AND Name like 'Equifax (req#1)%'
        ORDER BY LastModifiedDate DESC
        LIMIT 1
      ];
      this.equifaxRequest = d.isEmpty()? new LenderAPIResponse__c() : d.get(0);
    }

    public void getEquifaxReport() {
      this.equifaxResponse = null;
      System.debug('@@equifaxDocType: ' + equifaxDocType);
      if (this.equifaxRequest != null && String.isNotBlank(this.equifaxRequest.Response__c)) {
        String x = this.equifaxRequest.Response__c;
        x = x.remove('"').remove('{').remove('}');
        String[] y = x.split(':');
        this.getEquifaxResponse(y.size() > 1? y[1] : null);
      } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Equifax response not found'));
      }
    }

    public void getEquifaxResponse(String enquiryId) {
      if (String.isBlank(enquiryId)) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'enquiryId not found'));
      }

      String usernameVal = APIServiceManager.getParameterService(VedaEnquiryExtension.PARAM_USERNAME);
      String passwordVal = APIServiceManager.getParameterService(VedaEnquiryExtension.PARAM_PASSWORD);

      String reqStr2 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">';
      reqStr2 += '<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">';
      reqStr2 += '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">';
      reqStr2 += '<wsse:UsernameToken><wsse:Username>' + usernameVal + '</wsse:Username>';
      reqStr2 += '<wsse:Password>' + passwordVal + '</wsse:Password></wsse:UsernameToken>';
      reqStr2 += '</wsse:Security><wsa:Action>http://vedaxml.com/previousEnquiry/ServiceRequest</wsa:Action></soapenv:Header>';
      reqStr2 += '<env:Body xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">';
      reqStr2 += '<prev:request xmlns:prev="http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd">';
      reqStr2 += '<prev:enquiryId>' + enquiryId + '</prev:enquiryId>';
      if (String.isNotBlank(this.equifaxDocType)) {
        reqStr2 += this.equifaxDocType;
        // reqStr2 += '<prev:contentType>application/pdf</prev:contentType>';
      }
      // reqStr2 += '<prev:contentType>text/xml</prev:contentType>';
      reqStr2 += '</prev:request></env:Body></soapenv:Envelope>';

      this.invokeEquifaxService(reqStr2);
      
    }

    public void getEquifaxRequest() {
      this.equifaxResponse = null;
      // this.invokeEquifaxService(this.equifaxRequestBody);

      Dom.Document doc = new DOM.Document();
      doc.load(this.equifaxRequestBody);
      Dom.XmlNode node = doc.getRootElement();
      // node = node.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
      // node = node.getChildElements().get(0);

      Integer score = EquifaxAPIService.getCreditScore(node);
      this.equifaxResponse = '{ creditScore: ' + score + '}';
      EquifaxAPIService.updateCreditScore(this.opp.Id, score);
    }

    public void invokeEquifaxService(String request) {
      if (String.isBlank(request)) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'request body not found'));
      }

      String repEndpointVal = APIServiceManager.getParameterService(VedaEnquiryExtension.PARAM_REPORT_ENDPOINT);
      String usernameVal = APIServiceManager.getParameterService(VedaEnquiryExtension.PARAM_USERNAME);
      String passwordVal = APIServiceManager.getParameterService(VedaEnquiryExtension.PARAM_PASSWORD);

      HttpRequest req2 = new HttpRequest();
      Http http2 = new Http();
      req2.setEndpoint(repEndpointVal);
      req2.setBody(request);
      req2.setMethod('POST');
      req2.setHeader('content-type', 'text/xml');
      req2.setTimeout(60000);
      HttpResponse res2 = Test.isRunningTest()? new HttpResponse() : http2.send(req2);
      this.equifaxResponse = res2.getBody();
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Service executed!'));
      
    }

}