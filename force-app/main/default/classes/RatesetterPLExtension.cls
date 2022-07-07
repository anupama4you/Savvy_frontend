public class RatesetterPLExtension {
	
	public Custom_Opportunity__c Opp;
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'PlentiPL';
    //-
    public RatesetterDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'RateSetter PL';
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-
    //Lelo                  Insurance                       2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String quoteIdSelected {get;set;}
    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    //-
    public Lenders__c lenderSettings {set;get;}

    public Boolean paramActive {set; get;}
    public String apiUser {get;set;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public LenderAPIResponse__c lenderAPIResp {get;set;}

    public RatesetterPLExtension(ApexPages.StandardController controller) {
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);

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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Loan amount cannot be Zero.'));
            r = false;
        } else {
        	if (dto.getRealtimeNaf() > 45000) {
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'NAF should not over come $45.000. Current value: $' + dto.getRealtimeNaf().format()));
        		// r = false;	
        	}
        }
        if (dto.applicationFee == null || dto.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        }
        if (dto.dof == null || dto.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if(dto.dof > dto.getMaxDof()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max DOF is 10% of the Loan Amount or $'+dto.getMaxDof().format()+'. Please adjust.'));
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
        //if (dto.term == null || dto.term == 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
        //    r = false;
        //} else {
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
        if(String.isBlank(dto.purposeType)){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Loan Purpose option'));
          r = false;
        }
        if('Other'.equals(dto.purposeType) && String.isBlank(dto.loanPurpose)) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,'The Loan Purpose needs to be inserted into the quoting tool'));
          r = false;
          // ApexPages.Severity sev = isApproval ? ApexPages.Severity.ERROR : ApexPages.Severity.WARNING;
          // r = isApproval ? false : r;
          // String msg = isApproval 
          //   ? 'The Loan Purpose needs to be inserted into the quoting tool' 
          //   : 'The Loan Purpose is neccessary for any approval';
          // ApexPages.addMessage(new ApexPages.Message(sev, msg));        
        }
        if('Other'.equals(dto.purposeType) && String.isNotBlank(dto.loanPurpose) && dto.loanPurpose.length() > 40) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING,'Loan Purpose is long, please include no more than 40 characters'));
          r = false;
        }
        //-
        //if (dto.riskFee == null || dto.riskFee == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Risk Fee cannot be Zero.'));
        //    if (r) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Calcution has been done.'));
        //    }
        //    //r = false;
        //}
        return r;
    }
    
    public PageReference calculate () {
    	this.feesCalc();
        if (!isValidationOk()) {
            return null;
        }
        this.calculateRepayments();
		return null;
    }
    
    public void reset() {
      lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
      dto = new RatesetterDTO();
      dto.init();
      dto.loanType = 'Purchase';
      dto.productLoanType = 'Consumer Loan';
      dto.loanTypeDetail = 'Unsecured';
      dto.additionalDetails = '';
      //Initial values
      dto.docFees = 0.0;
      //dto.monthlyFee = 0.0;
      dto.ppsr = 0.0;
      dto.applicationFee = 0.0;
      dto.dof = 990.0;
      // dto.maxDof = 2500.0;
      //dto.baseRate = 0.0;
      //dto.clientRate = 0.0;
      dto.term = 60;
      dto.paymentType = 'Arrears';
      dto.riskFee = 0.0;
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
      //-
      dto.loanPurpose = '';
      dto.purposeType = '';
      this.feesCalc();
      this.resetCalculationResult(); //Lelo       2017-07-25

      this.usersAPIOptions = PlentiAPIManager.getUserOptionsConnect();
      for (SelectOption so: this.usersAPIOptions) {
        if (so.getLabel().equals(this.Opp.Owner_Name__c)) {
          this.apiUser = so.getValue();
        }
      }
      if (this.Opp.Application__c != null) {
        dto.purposeType = PlentiAPIService.getPurpose(this.Opp.Application__r.Loan_For__c);
        System.debug('loan for => ' + this.Opp.Application__r.Loan_For__c + '|' + dto.loanPurpose);
      }
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'PLENTI PERSONAL LOAN CALCULATION';
        qDto.carPrice = String.valueOf(dto.carPrice);
        qDto.applicationFee = String.valueOf(dto.applicationFee);
        qDto.dof = String.valueOf(dto.dof);
        qDto.ppsr = String.valueOf(dto.ppsr);
        qDto.residualValue = String.valueOf(dto.residualValue);
        qDto.baseRate = '';
        if (dto.baseRate != null) {
        	qDto.baseRate = String.valueOf(dto.baseRate);
        }
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
        calcPdf.getParameters().put('cci', String.valueOf(0.00));
        calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        
        //-
        calcPdf.getParameters().put('carPrice', qDto.carPrice);
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('applicationFee', qDto.applicationFee);
        calcPdf.getParameters().put('dof', qDto.dof);
        calcPdf.getParameters().put('ppsr', '0.00');
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
        calcPdf.getParameters().put('loanTypeDetail', qDto.loanTypeDetail);
        calcPdf.getParameters().put('loanType', qDto.loanType);
        calcPdf.getParameters().put('productLoanType', qDto.productLoanType);
        
        calcPdf.getParameters().put('customerProfile', dto.additionalDetails);
        calcPdf.getParameters().put('riskFee', 
            (dto.riskFee != null)? String.valueOf(dto.riskFee.format()): '0.00');
        
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('tradeIn', qDto.tradeIn);
        calcPdf.getParameters().put('payoutOn', qDto.payoutOn);
        calcPdf.getParameters().put('netDeposit', qDto.netDeposit);
		    calcPdf.getParameters().put('loanPurpose', dto.loanPurpose);
        calcPdf.getParameters().put('purposeType', dto.purposeType);
        
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
        updateProduct.Loan_Type_Detail__c = dto.loanTypeDetail + ' | ' + dto.additionalDetails;

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
        // updateProduct.Equalisation_Fee_PPSR__c = dto.ppsr + dto.riskFee;
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

            if (sameQuoting) {
                //Specific values
                                
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.loanTypeDetail = d.Loan_Facility_Type__c;
        		    dto.additionalDetails = d.Customer_Profile__c;
                dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.monthlyFee = d.Monthly_Fee__c;
                // dto.riskFee = d.Risk_Fee__c;
                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;

                if (String.isNotBlank(d.Purpose_Type__c)) {
                  dto.purposeType = d.Purpose_Type__c;
                }
                dto.loanPurpose = d.Loan_Purpose__c;
                
                //Load calculations
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

                //Lelo              Insurance               2017-12-04
                //Insurance Quote Product loading
                if ('M'.equals(dto.insuranceInputMode) && d.App_Insurance_Quote__c != null) {
                    //this.adjustInsuranceProduct();
                    dto.insuranceInputMode = 'A';
                    System.debug('cleaning 1...');
                }
                //-
                // load Lender API
                this.lenderAPIResp = QuotingToolHelper.getLenderAPIResponse(d.LenderAPIResponse__c);
            }
            this.feesCalc();
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
        d.Insurance_MV_Type__c = dto.mvLevel;
        d.Insurance_MV_Retail_Price__c = dto.mv;
        d.Insurance_MV_Income__c = dto.mvIncome;
        d.Insurance_MV_Acceptance__c = dto.mvAcceptance;

        d.Insurance_GAP_Type__c = dto.gapLevel;
        d.Insurance_GAP_Retail_Price__c = dto.gap;
        d.Insurance_GAP_Income__c = dto.gapIncome;
        d.Insurance_GAP_Acceptance__c = dto.gapAcceptance;
        
        d.Insurance_TAI_Type__c = dto.taiLevel;
        d.Insurance_TAI_Retail_Price__c = dto.tai;
        d.Insurance_TAI_Income__c = dto.taiIncome;
        d.Insurance_TAI_Acceptance__c = dto.taiAcceptance;
		
        d.Insurance_LTI_Type__c = dto.ltiLevel;
        d.Insurance_LTI_Retail_Price__c = dto.lti;
        d.Insurance_LTI_Income__c = dto.ltiIncome;
        d.Insurance_LTI_Acceptance__c = dto.ltiAcceptance;
        
        d.Insurance_Warranty_Type__c = dto.warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = dto.warranty;
        d.Insurance_Warranty_Income__c = dto.warrantyIncome;
        d.Insurance_Warranty_Acceptance__c = dto.warrantyAcceptance;

        d.Insurance_NWC_Retail_Price__c = dto.nwc;
        d.Insurance_NWC_Income__c = dto.nwcIncome;
        d.Insurance_NWC_Plan__c = dto.nwcPlan;
        d.Insurance_NWC_Term__c = dto.nwcTerm;
        d.Insurance_NWC_Cost__c = dto.nwcCost;
        d.Insurance_NWC_Acceptance__c = dto.nwcAcceptance;
        // Lelo             Insurance           2018-02-26
        d.Insurance_AIC_Retail_Price__c = dto.cci;
        d.Insurance_AIC_Income__c = dto.cciIncome;
        d.Insurance_AIC_Acceptance__c = dto.cciAcceptance;
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
		    d.LTV__c = null;
        d.Payment__c = dto.paymentType;
        d.Loan_Facility_Type__c = dto.loanTypeDetail;
        d.Customer_Profile__c = dto.additionalDetails;
        d.Purpose_Type__c = dto.purposeType;
        d.Loan_Purpose__c = dto.loanPurpose;
        //d.Risk_Fee__c = dto.riskFee;
        //System.debug('Risk fee >> ' + dto.riskFee);
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

        //Clean fields
        d.PPSR__c = null;
        d.Base_Rate__c = null;
        d.Brokerage__c = null;
        //d.Risk_Fee__c = null;
        //d.Registration_Fee__c = null;
        d.Vehicle_Age__c = null;
        d.Adverse_Credit_File__c = null;
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
        param.amountBaseComm = dto.carPrice;
        //param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        //param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        param.clientRate = dto.clientRate;
        param.paymentType = dto.paymentType;
        param.term = dto.term;
        param.dof = dto.dof;
        param.monthlyFee = dto.monthlyFee;
        param.residualValue = dto.residualValue;
        
        
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
            dto.estimatedCommission = r.Estimated_Commission__c;
            dto.nafCalculated = r.NAF__c;
            dto.rental = r.Rental__c;
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

        //Protected
        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = dto.getTotalAmount(quotingType);
        //param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        //param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        
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
    public List<RateSetterPLDOF__c> getDOFRates() {
    	List<RateSetterPLDOF__c> r = RateSetterPLDOF__c.getAll().values();
    	r.sort();
    	return r;
    }

    public List<RateSetterPLAppfee__c> getAppFeeRates() {
    	List<RateSetterPLAppfee__c> r = RateSetterPLAppfee__c.getAll().values();
    	r.sort();
    	return r;
    }

    public List<RateSetterPLMonthlyFee__c> getMonthlyFeeRates() {
    	List<RateSetterPLMonthlyFee__c> r = RateSetterPLMonthlyFee__c.getAll().values();
    	r.sort();
    	return r;
    }

    public List<RateSetterPLRates__c> getRates() {
    	List<RateSetterPLRates__c> r = RateSetterPLRates__c.getAll().values();
    	r.sort();
    	return r;
    }

    public void feesCalc() {
    	//Application Fee
    	//dto.applicationFee = QuotingToolHelper.getRateSetterPLAppfee(dto.getBaseFees(), dto.term);
    	//if ('Secured'.equals(dto.loanTypeDetail)) {
    	//	dto.applicationFee += 100;
    	//}
    	//if ('Self Employed'.equals(dto.additionalDetails)) {
    	//	dto.applicationFee += 150;
    	//} else if ('Business Purpose'.equals(dto.additionalDetails)) {
    	//	dto.applicationFee += 250;
    	//}
    	//DOF
    	// dto.dof = QuotingToolHelper.getRateSetterPLDOF(dto.getBaseFees() + dto.applicationFee, dto.term);
    	//Monthly Fee
    	dto.monthlyFee = 0.0;
        // dto.monthlyFee = QuotingToolHelper.getRateSetterPLMonthlyfee(dto.getBaseFees(), dto.term);
        //System.debug(dto.dof + '|' + dto.monthlyFee + '|' + dto.applicationFee + '|' + dto.getBaseFees());
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

  public void sendApplicationTest (){
      if (!hasCalculationDone()) return;
      System.debug('>>>>> Response APPLICATION Pepper (Test)  -I  <<<<<< - ');
      try{
          PlentiAPIService appService = new PlentiAPIService();
          appService.requestApplicationTest(Opp.Id, apiUser);
      } catch(GenericException ex) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
      }
      System.debug('>>>>> Response APPLICATION Pepper  (test)-F  <<<<<< - ');
  }

  public void sendApplication (){
    if (!hasCalculationDone()) return;
    System.debug('>>>>> Response APPLICATION Pepper  -I  <<<<<< - ');
    try{
      PlentiAPIService appService = new PlentiAPIService();
      PlentiAPIManager apiManager = appService.requestApplication(Opp.Id, apiUser, true);
      this.lenderAPIResp = apiManager.lenderAPIResp;
      if (this.lenderAPIResp == null) {
        throw new GenericException('[Plenti API] there isn\'t any Lender API Response returned to Quoting tools.');
      }
      this.quoting.LenderAPIResponse__c = this.lenderAPIResp.Id;
      update this.quoting;
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.CONFIRM,
          'Application sent to Plenti! ID[' + apiManager.lenderAPIResp.Application_ID__c + ']'));
    }catch(GenericException ex){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    }
  }
  
  public Boolean getHasLenderApp() {
    return this.lenderAPIResp != null;
  }

  public List<SelectOption> getPurposeTypeOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('','--None--'));
    r.add(new SelectOption('DebtConsolidation','Debt Consolidation'));
    r.add(new SelectOption('Car','Car'));
    r.add(new SelectOption('Motorbike','Motorbike'));
    r.add(new SelectOption('Boat','Boat'));
    r.add(new SelectOption('Business','Business'));
    r.add(new SelectOption('FuneralExpenses','Funeral Expenses'));    
    r.add(new SelectOption('Investment','Investment'));
    r.add(new SelectOption('HomeImprovement','Home Improvement'));
    r.add(new SelectOption('Holiday','Holiday'));
    r.add(new SelectOption('MedicalDental','Medical Dental'));
    r.add(new SelectOption('MovingCosts','Moving Costs'));
    r.add(new SelectOption('PayBills','Pay Bills'));
    r.add(new SelectOption('PayoffLoan','Payoff Loan'));
    r.add(new SelectOption('ProfessionalServiceFees','Professional Service Fees'));
    r.add(new SelectOption('RentalBond','Rental Bond'));
    r.add(new SelectOption('Repairs','Repairs'));
    r.add(new SelectOption('SolarBattery','Solar Battery'));
    r.add(new SelectOption('Wedding','Wedding'));
    r.add(new SelectOption('Other','Other'));
    return r;
  }
}