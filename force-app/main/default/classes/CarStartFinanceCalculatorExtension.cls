public class CarStartFinanceCalculatorExtension extends QuotingExtension {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'CarStart';
    public QuotingToolHelper qh {set;get;}
    public static final String LENDER_QUOTING = 'CarStart';
    public CarStartFinanceRate__c rateSel {set;get;}

    // Lender variables
    public String loanTypeDetail {set;get;}
    public Decimal riskFee {get;set;}
    public Decimal riskFeeMax {get;set;}
    public Decimal commission {get;set;}
    public Decimal applicationFeeMax {get;set;}
    
    public CarStartFinanceCalculatorExtension(ApexPages.StandardController controller) {
        super(controller);
        
        qh = new QuotingToolHelper();
        
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        
        this.quotingName = LENDER_QUOTING;
        this.reset();

        preLoadQuotingValues();
        
        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
		        
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
                if (lender != null && lender.info != null && LENDER_QUOTING.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
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
        this.realtimeNafCalc();
        Boolean r = true;
        System.debug('1) r >> ' + r);
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        
        if (String.isBlank(this.loanTypeDetail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Type of Finance.'));
            r = false;
        }else{
            if (this.applicationFee > this.applicationFeeMax) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee should not be greater than $'+this.applicationFeeMax+'.'));
            }
            if (this.monthlyFee != rateSel.Monthly_Fee__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Monthly Fee should be $'+rateSel.Monthly_Fee__c+'.'));
            }
            if(this.commission > 500){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Bonus Comission should not be greater than $500.00')); 
            }
            if('Mid-Prime Finance Only'.equals(this.loanTypeDetail)){		
                if (this.clientRate < this.baseRate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate should not be below of base rate: '+this.baseRate+'%.'));
                    r = false;
                }
                if(this.dof != 0.0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF should be Zero')); 
                }
            }else{
                if(this.clientRate < this.baseRate || this.clientRate > this.maxRate){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client rate should be between '+this.baseRate+'% and '+this.maxRate+'%.'));
                }
                
                if(this.dof < rateSel.Dof__c || this.dof > rateSel.Dof_Max__c){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF should be between $'+rateSel.Dof__c+' and $'+rateSel.Dof_Max__c+'.'));
                }
                
                if('Sub-Prime Finance Only'.equals(this.loanTypeDetail) || 'Sub-Prime Lite (pensioners) Finance Only'.equals(this.loanTypeDetail)){
                    if (this.riskFee < rateSel.Risk_Fee__c|| this.riskFee > rateSel.Risk_Fee_Max__c) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should be between $'+rateSel.Risk_Fee__c+' and $'+rateSel.Risk_Fee_Max__c));
                    }
                }
                if(this.term == 60){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term should be 36 or 48'));
                    r = false;
                }
            }
            
            if (this.realtimeNaf < rateSel.Min_Loan__c || this.realtimeNaf > rateSel.Max_Loan__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan amount should be between $'+rateSel.Min_Loan__c+' and $'+rateSel.Max_Loan__c));
            }
            
            if (this.applicationFee < 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee should not be below Zero.'));
                r = false;
            }
            
            if (this.commission < 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Bonus Comission should not be below Zero.'));
                r = false;
            }
            
            if('Sub-Prime Vend & Lend'.equals(this.loanTypeDetail) || 'Sub-Prime Lite (pensioners) Vend & Lend'.equals(this.loanTypeDetail) || 'Mid-Prime Finance Only'.equals(this.loanTypeDetail)){	
                if(this.riskFee != 0.0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should be Zero')); 
                }
            }
        }
        
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        
        if(String.isBlank(this.loanPurpose)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan Purpose could be neccessary'));        
        }
        //-
        return r;
    }
    
    public void calculate () {
      if (isValidationOk()) {
        this.calculateRepayments();
      }
    }
    
    public void reset() {
      this.resetQuote();
      this.resetInsuranceProducts(false);
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.loanTypeDetail = '';
        //Initial values
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        //this.applicationFee = lenderSettings.Application_Fee__c;
        this.term = 60;
        this.paymentType = 'Arrears';
        this.riskFee = null;
        
     	  this.loanPurpose = '';   
        baseRateCalc();

        this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'CAR START FINANCE CALCULATION');
        
        //pass variables about the product info
        calcPdf.getParameters().put('loanTypeDetail', this.loanTypeDetail);
        calcPdf.getParameters().put('loanPurpose', this.loanPurpose);
        calcPdf.getParameters().put('riskFee', this.riskFee > 0? this.riskFee.format() : '0.00');
        calcPdf.getParameters().put('commission', this.commission.format());
        calcPdf.getParameters().put('maxRate', String.valueOf(this.maxRate));
        
        savePdfInCloud(calcPdf, prefixName);
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (this.rental == null || this.rental <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
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
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
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
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = this.loanTypeDetail;
        updateProduct.Loan_Term__c = this.term > 0? this.term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = this.dof > 0? this.dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        updateProduct.Lender_App_Fee__c = this.applicationFee > 0? this.applicationFee : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c += this.riskFee > 0? this.riskFee : 0.00;
        
        //Lelo                      2016-07-26
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }

        // Save accepted insurances
        this.saveInsuranceProducts();
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    
    //Lelo									2016-07-26
    public PageReference saveQuoting() {
        
        //Recalculate
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            this.saveQuotingParameters();
            this.savePdf(fileGlobalPrefix);
        }
        return null;
    }
 	
    public PageReference savePreApproval() {
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
            }
        }
        return null;
    }
    //-
    
    //Lelo                                  2016-12-22
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = (d != null)? d : new Application_Quoting__c();
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

            //Finance Details
            //Commons values
            this.loanType = d.Loan_Type__c;
            this.productLoanType = d.Loan_Product__c;
            this.carPrice = d.Vehicle_Price__c;
            this.deposit = d.Deposit__c;
            this.tradeIn = d.Trade_In__c;
            this.payoutOn = d.Payout_On__c;
            this.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                this.term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                this.loadQuotingInsuranceData();
                this.loadQuotingData();
                //Specific values
                this.riskFee = d.Risk_Fee__c;                
                
                //Loan Details
                this.paymentType = d.Payment__c;
                this.loanTypeDetail = d.Loan_Facility_Type__c;
                this.commission = d.Bonus_Commission__c;
                
                this.loanPurpose = d.Loan_Purpose__c; 
            }
            baseRateCalc();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        }
        if (sameQuoting) {
            try {
                this.calculateRepayments();
            } catch (Exception e) {
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error re-calculating repayments.');
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error reported: ' + e.getMessage());
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error cause: ' + e.getCause());
            }
        }
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);

        //NWC Warning - I
        if (nwcParam != null && nwcParam.vehicleAgeYears != null && nwcParam.vehicleAgeYears > 20){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No car more than 20 years old can be covered. VechileYear: ' + nwcParam.vehicleAgeYears));
            return;
        }
        //NWC Warning - F

        Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
          this.updateQuotingData();
          d = this.quoting; 
        }
        
         //Finance Details
        d.Risk_Fee__c = this.riskFee;    
        d.Loan_Facility_Type__c = this.loanTypeDetail;
        //Loan Details
        d.Loan_Purpose__c = this.loanPurpose;
        d.Bonus_Commission__c = this.commission;
        
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

    }
    //-   
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }
    
    public Boolean hasCalculationDone() {
        
        Boolean r = false;
        //Recalculate
        r = isValidationOk();
        if (r) {
            calculate();
            if (this.rental != null && this.rental > 0) {
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
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
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
        param.totalAmount = this.getTotalAmount(quotingType);
        param.totalInsurance = this.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(quotingType);
        param.clientRate = this.clientRate;
        param.paymentType = this.paymentType;
        param.term = this.term;
        param.dof = this.dof;
        param.monthlyFee = this.monthlyFee;
        param.residualValue = this.residualValue;
        param.amountBaseComm = this.commission;
        
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
          this.estimatedCommission = r.Estimated_Commission__c;
          this.dofResult = r.DOF__c;
          this.insuranceIncome = r.Insurance_Income__c;
          this.totalCommission = r.Total_Commission__c;
          this.totalCommissionGst = r.Total_Commission_Gst__c;

          this.naf = r.NAF__c;
          this.rental = r.Rental__c;
          this.monthlyPayment = r.Monthly_Payment__c;
          this.fortnightlyPayment = r.Fortnightly_Payment__c;
          this.weeklyPayment = r.Weekly_Payment__c;
          r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

        //Lelo          Insurenace          2017-12-04
        //Simple
        param.lender = LENDER_QUOTING;
        param.totalInsurance = 0;
        param.totalInsuranceIncome = 0;
        
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = QuotingCalculation.CALC_SIMPLE;   
        }
        calResults.put(QuotingCalculation.CALC_SIMPLE, r);

        List<String> calcTypes = new List<String>();
        //Insurance one by one
        //MV
        if (this.mv != null && this.mv > 0) {
            calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
        }
        //WARR
        if (this.warranty != null && this.warranty > 0) {
            calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
        }
        //NWC
        if (this.nwc != null && this.nwc > 0) {
            calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
        }
        //CCI
        //Lelo          Insurance           2018-02-26
        if (this.cci != null && this.cci > 0) {
            calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
        }
        //-
                    
        for (String key: calcTypes) {
            param.totalAmount = this.getTotalAmount(quotingType);
            param.totalInsurance = this.getTotalInsuranceType(key);
            param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
            r = QuotingCalculation.calculate(param);
            if (r != null) {
                r.Result_Type__c = key;   
            }
            calResults.put(key, r);                
        }

    }

    public void baseRateCalc() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.loanTypeDetail = this.loanTypeDetail;
        this.baseRate = QuotingCalculation.getBaseRate(param);
        this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
        rateSel = QuotingCalculation.getCarStartFinance(param);
        if(rateSel != null){
            this.maxDof = rateSel.Dof_Max__c;
            this.applicationFeeMax = rateSel.App_Fee__c;
            this.riskFeeMax = rateSel.Risk_Fee_Max__c;
            //this.commissionMax = rateSel.Standard_Commission_Max__c;
        }
    }
    
    public List<SelectOption> getTypeOfFinance() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption('','--None--'));
        List<CarStartFinanceRate__c> d = [
            SELECT Rate__c, Rate_Max__c, App_Fee__c, Dof__c, Dof_Max__c, Max_Loan__c, Min_Loan__c, Monthly_Fee__c,
            Risk_Fee__c, Risk_Fee_Max__c, Standard_Commission__c, Standard_Commission_Max__c,
            Type_of_Finance__c FROM CarStartFinanceRate__c];
        
        if (!d.isEmpty()) {
            for (CarStartFinanceRate__c c: d) {
                r.add(new SelectOption (c.Type_of_Finance__c, c.Type_of_Finance__c));
            }
        }
        return r;
    }
    
    public List<CarStartFinanceRate__c> getProducts() {
        return [SELECT Rate__c, Rate_Max__c, App_Fee__c, Dof__c, Dof_Max__c, Max_Loan__c, Min_Loan__c, Monthly_Fee__c,
                Risk_Fee__c, Risk_Fee_Max__c, Standard_Commission__c, Standard_Commission_Max__c,
                Type_of_Finance__c FROM CarStartFinanceRate__c];
    }

  public override Decimal getTotalAmount(String calcType) {
    Decimal r = super.getTotalAmount(calcType);
    r += (riskFee != null)? riskFee : 0;    
    return r;
  }


  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

  // Abstract methods implementation
  public override Boolean hasValidQuotation() {
    System.debug(this.quotingName + ' overriding hasValidQuotation...');
    return this.isValidationOk();
  }

  public override void calculateQuote() {
    System.debug(this.quotingName + ' overriding calculateQuote...');
    this.calculate();
  }

  public override void storeQuotingData() {
    System.debug(this.quotingName + ' overriding storeQuotingData...');
    this.saveQuotingParameters();
  }
}