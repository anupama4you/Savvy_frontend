public class ACLCalculatorExtension extends QuotingExtension {

    private String fileGlobalPrefix = 'Affordable';
    public QuotingToolHelper qh {set;get;}  
    public static final String LENDER_QUOTING = 'Affordable';
    
    public Map<Decimal, ACLUpfrontLoanFees__c> aclUpfrontLoanFeesMap {set; get;} 
    public List<ACLUpfrontLoanFees__c> aclUpfrontLoanFees {set; get;}
    public List<ACL_Interest_Rate__c> aclInterestRates {set; get;}
    public Map<String, ACL_Interest_Rate__c> aclRatesMap {set; get;}
    public Boolean sameQuoting {set; get;}
    public string documentid {get;set;}

    // Lender variables
    public String creditScore {set; get;}
    public String year {set; get;}
    public Decimal maxApplicationFee {get;set;}
    public String repayment {set; get;}
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}
    public String commType {get;set;}
    public Decimal commPayable {get;set;}
    public Decimal calcBonus {set; get;}
    
    public ACLCalculatorExtension(ApexPages.StandardController controller){
        super(controller);
        
        qh = new QuotingToolHelper();
        
        this.quotingName = LENDER_QUOTING;
        this.reset();
        
        preLoadQuotingValues();
        
        documentid = '/servlet/servlet.FileDownload?file=';
        List<Document> d = [Select Id From Document where DeveloperName = 'ACL_Commission'];
        if(!d.isEmpty()){
            documentid += d.get(0).id;
        }

        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
    }
    
    private void preLoadQuotingValues() {
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }
    }
    
    public Boolean isValidationOk() {
        Boolean r = true;
        this.calcRiskFee();
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Price cannot be Zero.'));
            r = false;
        }
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        } else if (this.applicationFee > this.maxApplicationFee) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max Application Fee exceed.'));
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > this.maxDof) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max. DOF exceed.'));
            // r = false;
        }
        if ((this.riskFee == null || this.riskFee == 0.0) && this.clientRate >= 10.00) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should be entered.'));
            // r = false;
        } else if (this.riskFeeTotal > 0 && this.riskFee < this.riskFeeTotal) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk fee is below that the calculated fee $' + this.riskFeeTotal.format()));       
        }
        if(this.riskFeeTotal > 0 && this.riskFee > this.riskFeeTotal){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk fee should not be greater than Risk fee calculated $' + this.riskFeeTotal.format()));       
        } else if (this.clientRate < 10 && this.riskFee > this.riskFeeTotal) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Not Risk fee calculated for client rates below 9.99%'));
        }

        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate can not be Zero.'));
            r = false;
        } else if(this.clientRate > this.maxRate || this.clientRate < this.baseRate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please check interest rate - out of the range'));
        }
        System.debug('Max: ' + this.maxRate + ' | Min: ' + this.baseRate + ' | Current: ' +  this.clientRate);
        /*if (String.isBlank(this.clientTier)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Client Tier.'));
          r = false;
        }*/
        if(String.isBlank(this.creditScore)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an option for Credit Score.'));
        	r = false;
        }
        /*} else if (String.isNotBlank(this.clientTier)) {
          Integer cs = Integer.valueOf(this.creditScore);
          if ('Premium'.equals(this.clientTier) && cs < 600) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Credit Score should be +600 for Premium.'));
        	  r = false;
          }
          if ('Classic'.equals(this.clientTier) && cs < 500) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Credit Score should be +500 for Classic.'));
        	  r = false;
          }
        }*/
        if(String.isBlank(this.year)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select an appropriated value for Year.'));
        	// r = false;
        }
        // if (this.tradeIn == null) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Trade In is null.'));
        //     r = false;
        // }
        // if (this.deposit == null) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Deposit is null.'));
        //     r = false;
        // }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (String.isNotBlank(this.year) && this.year.isNumeric()) {
            // validate vehicle age
            Integer y = math.abs(Date.today().year() - Integer.valueOf(this.year)) + this.getLoandTermInYears();
            if (y > 20) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The age of car combined with the term should not exceed 20 years'));
                // r = false;
            }
        }
        if ('Manual'.equals(this.commType) && (this.commPayable == null || this.commPayable == 0.00)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission should not be zero, please adjust your Commision Payable amount'));
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        if(this.getRealTimeNafVal() < 7000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan should be equal or more than $7,000'));
            // r = false;
        }
        checkCreditScoreMaxLendValid();
        return r;
    }
    
    public void calculate () {
      this.realtimeNafCalc();
      if (isValidationOk()) {
        this.calculateRepayments();
      }
    }
    
    public void reset() {
      this.resetQuote();
      this.resetInsuranceProducts(false);

        this.LoanInterestRate();
        this.LoanUpfrontLoanFees();
      
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';    
        //this.clientTier = '';
        this.creditScore = null;
        this.repayment = null;
        this.commType = 'Calculated';
        this.commPayable = null;
        this.calcBonus = 0.00;
        this.term = null;
        this.year = null;
        this.maxApplicationFee = null;
        
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.dof = lenderSettings.DOF__c;
        this.maxDof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.paymentType = 'Arrears';
        
        this.resetCalculationResult();
        calcRiskFee();
    }
    
    private PageReference savePdf (String prefixName) {
      // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'AFFORDABLE CAR LOAN CALCULATION');
        // Lender parameter
        calcPdf.getParameters().put('aclCreditScore', this.creditScore);
        calcPdf.getParameters().put('vehicleYear', this.year);
        calcPdf.getParameters().put('repayment', this.repayment);
        if (this.riskFee != null) {
            calcPdf.getParameters().put('riskFee', this.riskFee.format());
        }
        calcPdf.getParameters().put('calcBonus', String.valueOf(this.calcBonus));
        //calcPdf.getParameters().put('clientTier', this.clientTier);
        calcPdf.getParameters().put('commissionType', this.commType);
        
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
        
        saveQuotingParameters();
        
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
              Opportunity_Name__c = this.Opp.Id);
        }else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = 'Affordable';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        //updateProduct.Loan_Type_Detail__c = 'Client Tier ' + this.clientTier;
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
        
    }
    
    public PageReference saveQuoting() {
        //Recalculate
        if (hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
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
        System.debug('Asstet TYpe: ' + this.Opp.Application__r.Type_of_Asset__c);
        if ('Personal'.equals(this.Opp.Application__r.Type_of_Asset__c)) {
            if (this.quoting != null) this.quoting.Force_Calculation__c = false;
            return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
        } else if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
            }
        }
        return null;
    }
    
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        this.quoting = (d != null)? d : new Application_Quoting__c();
        sameQuoting = false;
        
        if (d != null) {
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }
            
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
                this.paymentType = d.Payment__c;
                //this.clientTier = d.Client_Tier__c;
                this.riskFee = d.Risk_Fee__c;
                if (d.Client_Rate__c != null) {
                    this.clientRate = d.Client_Rate__c.setScale(2);
                }
                this.creditScore = d.Credit_Score__c;
                this.year = d.Vehicle_Age__c;            
                this.commType = d.Commission_Type__c;
                this.commPayable = null;
                if ('Manual'.equals(this.commType)) {
                  this.commPayable = this.estimatedCommission;
                }
                this.repayment = d.Loan_Frequency__c;
            }
        }
        this.calcRiskFee();
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
        
        //-
        //Finance Details
        
        d.Risk_Fee__c = this.riskFee;
        
        //Loan Details
        
        d.Commission_Type__c = this.commType;
        //d.Client_Tier__c = this.clientTier;
        d.Credit_Score__c = this.creditScore;
        d.Vehicle_Age__c = this.year;       
        d.Bonus_Commission__c = this.calcBonus;
        d.Loan_Frequency__c = this.repayment;
        
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);
        
        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
    }
    
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
        if (hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
                saveQuotingParameters();
            }
    }
    
    public void sendCustomerEmail2() {
      if (hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
        try {
            Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
            if (q != null) {
              EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
              if (!Test.isRunningTest()) {
                EmailSender.sendQuotingEmailToCustomer(param);
              }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
      }
    }
    
    private void calculateRepayments() {
        this.resetCalculationResult();
        //Quote
        //this.baseRate = this.clientRate;
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
        param.vehiclePrice = this.carPrice;
        //param.amountBaseComm = this.getLoanAmount() + this.getTotalInsuranceType(quotingType);
        param.amountBaseComm = this.getLoanAmount();
        ACLUpfrontLoanFees__c rate = QuotingCalculation.getAffordableFees(param.clientRate);
        if (rate != null) {
          param.commRate = rate.Comm__c;
        }        
        param.commBonus = this.calcBonus;
        param.commType = this.commType;
        param.commPayable = this.commPayable;

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
        //GAP
        if (this.gap != null && this.gap > 0) {
            calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
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
    
    public List<SelectOption> getLoanRepaymentOptions(){
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Weekly', 'Weekly'));
        r.add(new SelectOption ('Fortnightly', 'Fortnightly'));
        return r;
    }
    
    public List<SelectOption> getLoanTermOptions(){
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('24', '24'));
        r.add(new SelectOption ('36', '36'));
        r.add(new SelectOption ('48', '48'));
        r.add(new SelectOption ('60', '60'));
        return r;
    }
    
    public List<ACLUpfrontLoanFees__c>  getListUpfrontLoanFees(){
        return aclUpfrontLoanFees;
    }
    
    public void LoanUpfrontLoanFees(){
        aclUpfrontLoanFeesMap = new Map<Decimal, ACLUpfrontLoanFees__c>();
        aclUpfrontLoanFees = [
          Select Min_Interest_Rate__c, Max_Interest_Rate__c, Establishment_Fee__c, 
                 Risk_Fee_Interest_Rate_Of_NAF__c, Max_Lend__c, Comm__c
          From ACLUpfrontLoanFees__c
          Order by Min_Interest_Rate__c DESC
        ];
        if(aclUpfrontLoanFees != null){
            for(ACLUpfrontLoanFees__c y : aclUpfrontLoanFees){
                aclUpfrontLoanFeesMap.put(y.Min_Interest_Rate__c, y);
            }
        }
    }
        
    public void LoanInterestRate(){
        aclRatesMap = new Map<String, ACL_Interest_Rate__c>();
        aclInterestRates = [Select Credit_Score__c, Max_Lend__c, Base_Interest_Rate__c, Best_Interest_Rate__c, Comparison_Rate__c 
                            From ACL_Interest_Rate__c
                            Order by Max_Lend__c DESC];
        if(aclInterestRates != null){
            for(ACL_Interest_Rate__c y : aclInterestRates){
                aclRatesMap.put(y.Credit_Score__c, y);
            }
        }
    }
    
    public List <SelectOption> getYearsSelect(){
        List <SelectOption> r = new List <SelectOption>();
        Integer yActual = Date.today().year();
        Integer z = 20;
        r.add(new SelectOption('','--None--'));
        for (Integer y=yActual; y > (yActual - z);y--) {
            r.add(new SelectOption(String.valueOf(y),String.valueOf(y)));
        }
        return r;
    }
    
    public Decimal getNAF(){
        Decimal r = 0.0;
        if (this.carPrice != null && this.carPrice > 0.0) r += this.carPrice;
        if (this.dof != null && this.dof > 0.0) r += this.dof;
        r -= this.getNetDepositVal();
        r += this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
    	return r; 
    }
    
    public void calcRiskFee() {
        System.debug('Calculating risk fees...');
        // if (String.isNotBlank(this.creditScore) && aclRatesMap != null && !aclRatesMap.isEmpty() &&
            System.debug('Searching rates for ' + this.creditScore + '...');
            // ACL_Interest_Rate__c y = aclRatesMap.get(this.creditScore);
            Decimal myRate = this.clientRate;
            baseRateCalc();
            if (myRate == null || myRate == 0.0) {
                myRate = this.maxRate;
            }
          if (aclUpfrontLoanFees != null && !aclUpfrontLoanFees.isEmpty()) {
            System.debug('Assigning fees... [' + myRate + ']');
            ACLUpfrontLoanFees__c x = QuotingCalculation.getAffordableFees(myRate);
            if (x != null) {
              if (x.Establishment_Fee__c > 0 && x.Establishment_Fee__c != this.maxApplicationFee) {
                this.maxApplicationFee = x.Establishment_Fee__c;
                System.debug('App fee: ' + this.applicationFee);
                if (this.applicationFee == null || this.applicationFee == 0) {
                  this.applicationFee = this.maxApplicationFee;
                }
              }
              this.riskFeeTotal = ((myRate/100 * x.Risk_Fee_Interest_Rate_Of_NAF__c/100) * getLoandTermInYears() * getNAF()).setScale(2);
            }
         }
    }
    
    public Integer getLoandTermInYears(){
        if (this.term != null && this.term > 0) {
            return this.term/12;
        }
        return 0;
    }
    
    public void checkCreditScoreMaxLendValid(){
        Decimal myRate = this.clientRate;
        if (myRate == null || myRate == 0.0) {
            myRate = this.maxRate;
        }
        ACLUpfrontLoanFees__c x = QuotingCalculation.getAffordableFees(myRate);
        if (x != null) {
          if (this.getRealtimeNafVal() > x.Max_Lend__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan Amount should not be more than $'+x.Max_Lend__c.setScale(0).format()+' according with the client rate figure'));
          }
        }
    }

    public void resetCommissionPayable() {
      if ('Manual'.equals(this.commType)) {
        this.commPayable = null;
      }
    }
/*    
    public List<SelectOption> getClientTierOptions() {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('','--None--'));
      for (String k: QuotingCalculation.getBasicRateProfiles(LENDER_QUOTING)) {
        r.add(new SelectOption(k,k));
      }
      return r;
    }
*/
    public void baseRateCalc() {
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      //param.clientTier = this.clientTier;
      param.vehicleYear = this.year;
      param.creditScore = this.creditScore;
      this.baseRate = QuotingCalculation.getBaseRate(param);
      this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
    }

    public List<BasicLenderRates__c>  getListInterestRate(){
        return QuotingCalculation.listBasicRates(LENDER_QUOTING);
    }

    public override Decimal getTotalAmount(String calcType) {
      Decimal r = super.getTotalAmount(calcType);
      r += (riskFee != null) ? riskFee : 0.00;
      return r;
    }
    
    public Decimal getLoanAmount() {
      Decimal r = 0.0;
      if (this.carPrice != null) r += this.carPrice;
      r -= getNetDepositVal();
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