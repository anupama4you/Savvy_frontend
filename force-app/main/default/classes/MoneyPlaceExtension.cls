public with sharing class MoneyPlaceExtension {
	public Custom_Opportunity__c Opp;
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'MoneyPlace';
    //-
    
    //public WisrCalculatorDTO dto {set;get;}
    public Money3CalculatorDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Money Place';
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-
    //Lelo     Insurance                2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    //-
    public Lenders__c lenderSettings {set;get;}

    public MoneyPlaceExtension(ApexPages.StandardController controller) {
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
        } else {
        	//if (dto.getBaseCommission(QuotingCalculation.CALC_QUOTING) > 50000) {
        	//	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price - Deposit should not over come $50.000. Current value: $' + dto.getBaseCommission(QuotingCalculation.CALC_QUOTING).format()));
        	//	r = false;	
        	//}
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
        //if (dto.ltv == null || dto.ltv <= 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LVR(%) should be filled.'));
        //    r = false;
        //}
        //if (dto.ppsr == null || dto.ppsr == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
        //    r = false;
        //}
        //if (dto.baseRate == null || dto.baseRate == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
        //    r = false;
        //}
        if (dto.clientRate == null || dto.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } 
        //if (dto.baseRate != null && dto.clientRate < dto.baseRate) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client Rate below base rate.'));
        //}
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } 
        //else {
        //	if (dto.term != 36 && dto.term != 60) {
        //		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term should be 36 or 60 months.'));
        //    	r = false;
        //	}
        //}
        
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
    
    public PageReference reset () {
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        dto = new Money3CalculatorDTO();
        dto.init();
        dto.loanType = 'Purchase';
        dto.productLoanType = 'Consumer Loan';
        //dto.ltv = 100;
        //Initial values
        dto.docFees = 0.0;
        dto.monthlyFee = 0.0;
        //dto.ppsr = 6.80;
        dto.applicationFee = 0.0;
        dto.dof = getMaxDOF();
        //dto.baseRate = 0.0;
        //dto.clientRate = 0.0;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        //dto.vehicleGroup = '1';
        //dto.awd = 'N';
        //dto.turbo = 'N';
        //dto.diesel = 'N';
        
        //Insurance Products
        //Lelo          Insurance           2017-12-04
        dto.insuranceInputMode = 'A';
        
        dto.mvAcceptance = 'U';
        dto.gapAcceptance = 'U';
        dto.taiAcceptance = 'U';
        dto.ltiAcceptance = 'U';
        dto.warrantyAcceptance = 'U';
        dto.nwcAcceptance = 'U';
        dto.cciAcceptance = 'U';
        dto.loanPurpose = '';
        //-
        
        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'MONEY PLACE CALCULATION';
        //qDto.state = dto.state;
        //qDto.vehicleGroup = dto.vehicleGroup;
        //qDto.awd = dto.awd;
        //qDto.turbo = dto.turbo;
        //qDto.diesel = dto.diesel;

        //qDto.gapLevel = dto.gapLevel;
        //qDto.gap = String.valueOf(dto.gap);
        //qDto.gapIncome = String.valueOf(dto.gapIncome);
        //qDto.nwc = String.valueOf(dto.nwc);
        //qDto.nwcIncome = String.valueOf(dto.nwcIncome);
        //qDto.warrantyLevel = dto.warrantyLevel;
        //qDto.warranty = String.valueOf(dto.warranty);
        //qDto.warrantyIncome = String.valueOf(dto.warrantyIncome);
        //qDto.ltiLevel = dto.ltiLevel;
        //qDto.lti = String.valueOf(dto.lti);
        //qDto.ltiIncome = String.valueOf(dto.ltiIncome);
        //qDto.truckGapLevel = dto.truckGapLevel;
        //qDto.truckGap = String.valueOf(dto.truckGap);
        //qDto.truckGapIncome = String.valueOf(dto.truckGapIncome);
        //qDto.taiLevel = dto.taiLevel;
        //qDto.tai = String.valueOf(dto.tai);
        //qDto.taiIncome = String.valueOf(dto.taiIncome);
        //qDto.mvLevel = dto.mvLevel;
        //qDto.mv = String.valueOf(dto.mv);
        //qDto.mvIncome = String.valueOf(dto.mvIncome);
        ////dto.cciLevel = String.valueOf(cciLevel);
        //qDto.cci = String.valueOf(dto.cci);
        //qDto.cciIncome = String.valueOf(dto.cciIncome);
        
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
        //Money3 Consumer
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
        if('A'.equals(dto.cciAcceptance)){
            calcPdf.getParameters().put('cciLevel', dto.cciLevel);
        	calcPdf.getParameters().put('cci', String.valueOf(dto.cci));
        	calcPdf.getParameters().put('cciIncome', String.valueOf(dto.cciIncome));
        }else{
            calcPdf.getParameters().put('cciLevel', null);
        	calcPdf.getParameters().put('cci', String.valueOf(0.00));
        	calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        }
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
        //if (dto.ltv != null) {
        //	calcPdf.getParameters().put('ltv', String.valueOf(dto.ltv));
        //}
        //if (dto.vedascore != null) {
        //	calcPdf.getParameters().put('vehicleAge', String.valueOf(dto.vedascore));
        //}
        
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
        updateProduct.Equalisation_Fee_PPSR__c = dto.ppsr;
        
        //Lelo                      2016-07-26
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        //Yohan VillaLeal      Insurnce        2018-08-01
        // CCI Insurance
        if (('A'.equals(dto.cciAcceptance)) || (dto.cci != null && dto.cci > 0)) {    
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'CCI';
            newInsurance.Insurance_Policy_Amount__c = dto.cci;
            if (dto.cciIncome == null || dto.cciIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'CCI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.cciIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Yohan VillaLeal                    2018-08-01
            insert newInsurance;
            //productList.add(newInsurance);
            //-
        }
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

            if (String.isBlank(d.Insurance_Input_Mode__c)) {
                dto.insuranceInputMode = 'M';
            } else {
                dto.insuranceInputMode = d.Insurance_Input_Mode__c;
            }            
            //--
            //Finance Details
            //Commons values
            dto.loanType = d.Loan_Type__c;
            dto.productLoanType = d.Loan_Product__c;
            dto.carPrice = d.Vehicle_Price__c;
            //dto.deposit = d.Deposit__c;
            //dto.tradeIn = d.Trade_In__c;
            //dto.payoutOn = d.Payout_On__c;
            dto.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                dto.term = Integer.valueOf(d.Term__c);
            }

            // dto.cciLevel = d.Insurance_AIC_Type__c;
            // dto.cci = d.Insurance_AIC_Retail_Price__c;
            // dto.cciIncome = d.Insurance_AIC_Income__c;
            // dto.cciAcceptance = d.Insurance_AIC_Acceptance__c;
            // dto.InsuranceIncome = d.Commission_Insurance_Income__c;
            if (sameQuoting) {
                //Specific values
                                
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.loanTypeDetail = d.Loan_Facility_Type__c;
                dto.loanPurpose = d.Loan_Purpose__c;
                dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.monthlyFee = d.Monthly_Fee__c;

          //      if (String.isNotBlank(d.LTV__c) && d.LTV__c.isNumeric()) {
		        //	dto.ltv = Integer.valueOf(d.LTV__c);
		        //} else {
		        //	dto.ltv = null;
		        //}
		        //if (d.Vedascore__c != null) {
          //      	dto.vedascore = d.Vedascore__c.intValue();
          //      }
                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;
                
                
                //Load calculations
                if(dto.cciAcceptance!='A' && dto.cciAcceptance!='D'){
                	this.ericLPICalculate();
            	}
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

                //Lelo              Insurance               2017-12-04
                //Insurance Quote Product loading
                if ('M'.equals(dto.insuranceInputMode) && d.App_Insurance_Quote__c != null) {
                    //this.adjustInsuranceProduct();
                    dto.insuranceInputMode = 'A';
                    System.debug('cleaning 1...');
                }
                //-
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
        d.Deposit__c = dto.deposit;
        d.Trade_In__c = dto.tradeIn;
        d.Payout_On__c = dto.payoutOn;
        
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
        if(dto.cciAcceptance!='A' && dto.cciAcceptance!='D'){
            ericLPICalculate();
        }
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

    //-
    public List<Direct_Money_Rate__c> getRates() {
    	List<Direct_Money_Rate__c> d = Direct_Money_Rate__c.getAll().values();
    	d.sort();
        List<Direct_Money_Rate__c> r = new List<Direct_Money_Rate__c>();
        for (Direct_Money_Rate__c a : d) {
            if ('>= 90'.equals(a.LVR__c)) {
                r.add(a);
            }
        }
    	return r;
    }

    public List<Wisr_Fee_Rate__c> getFeeRates() {
        List<Wisr_Fee_Rate__c> r = Wisr_Fee_Rate__c.getAll().values();
        r.sort();
        return r;
    }

    public Decimal getMaxDOF() {
      Decimal r = 0.00;
      Decimal v = this.dto.getBaseCommission(QuotingCalculation.CALC_QUOTING);
      if (v < 20000) {
        r = v * 0.1;
        r = r > lenderSettings.Max_DOF__c? lenderSettings.Max_DOF__c : r; 
      } else if (v < 40000) {
        r = 1690.00;
      } else {
        r = 1990.00;
      }
      return r.setScale(2);
    }
    
    //Yohan VillaLeal  >>>>   27/07/2018
    public Boolean getDisplayCCIInsurance() {
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(dto.ltiLevel)) {
                r  = true;
            }
        }
        return r;
    }
    
    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 27/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption ('', '-- None --'));
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
        if ('A'.equals(dto.cciAcceptance) && dto.cci != null)  {
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
    
    public void acceptQuoteCCI() {
        // if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (dto.cci == null || dto.cci == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The CCI - AIC/Eric Retail Price cannot be zero, please check the Retail Price.'));       
        } else {
            if ('A'.equals(dto.cciAcceptance)) {
                dto.cciAcceptance = 'U';    
            } else {
                dto.cciAcceptance = 'A';    
            }
        }
    }
    
    public void declineQuoteCCI() {
        // if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.cciAcceptance)) {
            dto.cciAcceptance = 'U';    
        } else {
            dto.cciAcceptance = 'D';    
        }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

    public void onChangeLoanAmount() {
      dto.dof = getMaxDOF();
    }
}