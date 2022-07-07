public class BOQCalculatorExtension extends QuotingExtension {
    private String fileGlobalPrefix = 'BOQ';
    public QuotingToolHelper qh {set;get;}
	  
    public static final String LENDER_QUOTING = 'BOQ';
    
    // Select options
    public List <SelectOption> boqRatesSelect {set; get;}
    // Ratees
    public Map<String, List<BOQRate__c>> boqRatesMap {set; get;} 
    private Map<String, List<BoqRate>> rates = null;
    public List<BOQRate__c> fullRates {get;set;}
    public List<BOQRate__c> fullRatesV2 {get;set;}

    // Lender variables
    public String carAge {set;get;}
    public String residency {get;set;}
    public String assetCondition {get;set;}

    public BOQCalculatorExtension(ApexPages.StandardController controller) {
        super(controller);
        
        qh = new QuotingToolHelper();
        boqRatesSelect = new List <SelectOption> ();
		boqRatesSelect.add(new SelectOption ('', '--None--'));        
        boqRatesMap = new Map<String, List<BOQRate__c>>();
        this.quotingName = LENDER_QUOTING;
        this.reset();
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
                if (lender != null && lender.info != null && 'BOQ'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.clientTier = lender.clientTier/*+ ' ('+lender.riskGrade+')'*/;
                    this.clientRate = lender.clientRate;
                    this.productGoodsType = lender.productGoodsType;
                    this.carAge = lender.vehicleYear;
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
        if(''.equals(this.carAge) || this.carAge == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age is required.'));
            r = false;
        }
        // validation before calculation
        
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > 990) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be more than $990.'));
            r = false;
        }
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        if (this.assetCondition == null || ''.equals(this.assetCondition)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Asset Condition can\'t be null.'));
            r = false;
        }

        if (!isInsuranceValidationOK()) {
            r = false;   
        }

        if (getSkipInsurances()) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You are not required to add any insurance (Net Deposit above 40% of Asset Price)'));
        }
		
        if (this.residualValue > 0 && this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        
        if (String.isBlank(this.productGoodsType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an Asset Type.'));
            r = false;
        }

        if (String.isBlank(this.privateSales)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value for Private Sales'));
          r = false;
        } else {
          if ('Y'.equals(this.privateSales) && !'Caravans'.equals(this.productGoodsType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Private sales only available for Caravans'));
            r = false;
          } else if ('Y'.equals(this.privateSales) && !'Platinum Plus'.equals(this.clientTier) && !'Platinum'.equals(this.clientTier)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Private sale caravans for Platinum Plus and Platinum risk grades'));
            r = false;
          }
          if ('Y'.equals(this.privateSales) && 'Caravans'.equals(this.productGoodsType) && this.realtimeNaf > 65000.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'10% deposit required when NAF exceeds $65,000'));
          }
        }

        Integer termToYears = 0;
        Integer carAge = 0;
        if (this.term != null && this.term > 0) {
        	termToYears = this.term/12;
        }
        
        if(this.carAge!=null){
          carAge = Integer.valueOf(this.carAge);
        }

        Integer totalYears = termToYears + carAge;
        if (('Caravans'.equals(this.productGoodsType) || 'Marine'.equals(this.productGoodsType)) && totalYears > 15) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Caravans maximum age at end of term is 15 years.'));
        }
        if ('Campertrailer'.equals(this.productGoodsType) && totalYears > 7) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Camper trailer maximum age at end of term is 7 years.'));
        }
        if ('Motorhome'.equals(this.productGoodsType) && totalYears > 10) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Motorhome maximum age at end of term is 10 years.'));
        }

        if('New'.equals(this.assetCondition) && this.realtimeNaf < 1500){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Amount Finaced must be greater than $1,500.'));
            r = false;
        }
        if('Used'.equals(this.assetCondition) && this.realtimeNaf < 4000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Amount Finaced must be greater than $4,000.'));
            r = false;
        }
        if('Platinum Plus'.equals(this.clientTier) && this.realtimeNaf > 200000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Amount Finaced must be less than $200,000.'));
        }
        if('Platinum'.equals(this.clientTier) && this.realtimeNaf > 80000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Amount Finaced must be less than $80,000.'));
        }
        if('Gold'.equals(this.clientTier) && this.realtimeNaf > 50000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Amount Finaced must be less than $50,000.'));
            r = false;
        }
        if(('Platinum'.equals(this.clientTier) || 'Platinum Plus'.equals(this.clientTier)) && this.term > 84){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term must be less than 84.'));
            r = false;
        }
        if('Gold'.equals(this.clientTier) && this.term > 60){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term must be less than 60.'));
            r = false;
        }
        if('New'.equals(this.assetCondition) && (carAge + termToYears) > 2){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'New car must be less than 2 years.'));
        }
        if('Campertrailer'.equals(this.productGoodsType) && (carAge + termToYears) > 7){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Asset age must be less than 7 years. Refer BOQ'));
        }
        if('Motorhome'.equals(this.productGoodsType) && (carAge + termToYears) > 10 ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Asset age must be less than 10 years. Refer BOQ'));
        }
        if('Motorbike'.equals(this.productGoodsType) && (carAge + termToYears) > 10 ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Asset age must be less than 10 years. Refer BOQ'));
        }
        if('Motorbike'.equals(this.productGoodsType) && (carAge + termToYears) > 12 ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max age of motorcycles 12 years at term end'));
            r = false;
        }
        if(('Marine'.equals(this.productGoodsType) || 'Caravans'.equals(this.productGoodsType)) && '15+'.equals(this.carAge)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Asset age must be less than 15 years. Refer BOQ'));
        }
        if('Used'.equals(this.assetCondition) && 'Gold'.equals(this.clientTier) && get10percentNAF() > this.deposit){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Deposit must be 10% of Asset Price.'));
        }
        if('Used'.equals(this.assetCondition) && ('Platinum Plus'.equals(this.clientTier) || 'Platinum'.equals(this.clientTier)) && this.deposit > 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'It\'s not necessary a Deposit.'));
        }
        if(!'Owner'.equals(this.residency) && 'Platinum Plus'.equals(this.clientTier)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Only property owners can be Platinum Plus.'));
        }
        return r;
    }
    
    public void calculate () {
      this.clientRateCalc();
      if (isValidationOk()) {
        this.calculateRepayments();        
        if (this.estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
      }
    }
    
    public void reset() {
      this.resetQuote();      
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.carAge = '0';
        this.assetCondition = 'New';
        this.productGoodsType = 'Marine';
        this.residency = 'Owner';
        this.clientTier = 'Platinum Plus';
        this.paymentType = 'Arrears';
        this.term = 24;
        
        fullRates = BOQRate__c.getAll().values();
        fullRates.sort();
        rates = new Map<String, List<BoqRate>>();
		
        fullRatesV2 = BOQRate__c.getAll().values();
        fullRatesV2.sort();
        
        List<BoqRate> r1 = new List<BoqRate>();
        List<BoqRate> r2 = new List<BoqRate>();
        List<BoqRate> r3 = new List<BoqRate>();
        List<BoqRate> r4 = new List<BoqRate>();
        List<BoqRate> r5 = new List<BoqRate>();
        List<BoqRate> r6 = new List<BoqRate>();

        for (BOQRate__c a : fullRates) {
            if (a.CustomerInterestRate__c != null && a.BaseCommisionRate__c != null) {
                r1.add(new BoqRate(a.CustomerInterestRate__c, a.BaseCommisionRate__c));
            }
            if (a.CustomerInterestRate__c != null && a.BaseCommisionRate__c != null) {
                r2.add(new BoqRate(a.CustomerInterestRate__c, a.BaseCommisionRate__c));
            }
            if (a.CustomerInterestRate__c != null && a.BaseCommisionRate__c != null) {
                r3.add(new BoqRate(a.CustomerInterestRate__c, a.BaseCommisionRate__c));
            }
        }

        rates.put('Platinum Plus', r1);
        rates.put('Platinum', r2);
        rates.put('Gold', r3);
        
        this.resetInsuranceProducts(false);

        this.LoanRates();
    }
    
    public Decimal getCommissionRate() {
        Decimal r = 0.0;
        if (this.baseRate > 0) {
            List<BoqRate> rts = rates.get(this.clientTier);
            for (BoqRate a : rts) {
                if (this.baseRate >= a.rate) {
                    r = a.comm;
                }
            }
        }
        return r;
    }
    
    class BoqRate {
        Decimal rate {set;get;}
        Decimal comm {set;get;}

        public BoqRate(Decimal rate, Decimal comm) {
            this.rate = rate;
            this.comm = comm;
        }
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'BANK OF QUEENSLAND CALCULATION');
      
        calcPdf.getParameters().put('clientTier', this.clientTier);
        calcPdf.getParameters().put('carAge', this.carAge);
        calcPdf.getParameters().put('privateSales', this.privateSales);
        calcPdf.getParameters().put('goodsType', this.productGoodsType);
        calcPdf.getParameters().put('residency', this.residency);
        calcPdf.getParameters().put('vehicleCondition', this.assetCondition);
        
        savePdfInCloud(calcPdf, prefixName);
        
        return null;
    }
    
    private PageReference saveProduct (String prefixName) {
        
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        
        if (this.rental == null || this.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        saveQuotingParameters();
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
              Opportunity_Name__c = this.Opp.Id);
        } else {
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = 'Bank Of Queensland';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = 'Client Tier ' + this.clientTier;
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
        
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }

        // Save accepted insurances
        this.saveInsuranceProducts();
        //-
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    }
    
    public PageReference saveQuoting() {
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
        if (getSkipInsurances() || InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (getSkipInsurances() || insuranceProductSelected()) {
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
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');
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
              this.clientTier = d.Client_Tier__c;
              this.residency = d.Residency__c;
              this.assetCondition = d.Vehicle_Condition__c;    
              this.clientRateCalc();
              this.carAge = d.Vehicle_Age__c;
              this.privateSales = d.Private_Sales__c;
              System.debug('d.Manual_Max_Rate__c: ' + d.Manual_Max_Rate__c);
              if (String.isNotBlank(d.Goods_type__c)) {
                  this.productGoodsType = d.Goods_type__c;
              }
            }
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
        this.LoanRatesByClientTier();
        
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);
		
		Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
          this.updateQuotingData();
          d = this.quoting; 
        }
        
        d.Residency__c = this.residency;
        d.Vehicle_Condition__c = this.assetCondition;
        d.Client_Tier__c = this.clientTier;
        d.Vehicle_Age__c = this.carAge;
        d.Private_Sales__c = this.privateSales;
        d.Monthly_Fee__c = this.monthlyFee;
        d.Goods_type__c = this.productGoodsType;
        

        QuotingToolHelper.saveApplicationQuoting(d);

        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
		
    }
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }

    public Boolean hasCalculationDone() {
        Boolean r = false;
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
    
    private void calculateRepayments() {
		this.resetCalculationResult();
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
      param.vehiclePrice = this.getVehiclePrice();

      List<BOQRate__c> rates = boqRatesMap.get(this.clientTier);
      param.commRate = 0.00;
      if(rates != null && this.clientRate != null){
          for(BOQRate__c y : rates){
              if(this.baseRate == y.CustomerInterestRate__c){
                  param.commRate = y.BaseCommisionRate__c;
              }
          }
      }
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

      param.lender = LENDER_QUOTING;
      param.totalInsurance = 0;
      param.totalInsuranceIncome = 0;
      
      r = QuotingCalculation.calculate(param);
      if (r != null) {
          r.Result_Type__c = QuotingCalculation.CALC_SIMPLE;   
      }
      calResults.put(QuotingCalculation.CALC_SIMPLE, r);
  
      List<String> calcTypes = new List<String>();
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
      //Lelo          Insurance           2018-02-26
      if (this.cci != null && this.cci > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
      }
      
      for (String key: calcTypes) {
        param.totalAmount = this.getTotalAmount(key);
        param.totalInsurance = this.getTotalInsuranceType(key);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = key;   
        }
        calResults.put(key, r);                
      }
		
    }
    
    public Decimal get10percentNAF(){
        return this.carPrice*0.1;
    }
    
    public List<BOQRate__c>  getFullRatesPlatinumPlus(){
        return boqRatesMap.get('Platinum Plus');
    }
    
    public List<BOQRate__c>  getFullRatesPlatinum(){
        return boqRatesMap.get('Platinum');
    }
    
    public List<BOQRate__c>  getFullRatesGold(){
        return boqRatesMap.get('Gold');
    }
    
    public PageReference  LoanRatesByClientTier(){
        if(boqRatesMap != null){
            List<BOQRate__c> boqRates = boqRatesMap.get(this.clientTier);
            
            if(boqRates != null){
                boqRatesSelect = null;
                boqRatesSelect = new List <SelectOption> ();
                boqRatesSelect.add(new SelectOption ('', '--None--'));
                for(BOQRate__c y : boqRates){
                    boqRatesSelect.add(new SelectOption (String.valueOf(y.CustomerInterestRate__c), String.valueOf(y.CustomerInterestRate__c)));    
                }    
            }
        }
        return null;
    }
    
    public void LoanRates(){
        List<BOQRate__c> RatesAux = new List<BOQRate__c>();
        List<BOQRate__c> Rates = [Select CustomerInterestRate__c, BaseCommisionRate__c, ClientTier__c 
                                  From BOQRate__c
                                  Order by ClientTier__c DESC, CustomerInterestRate__c];
        if(Rates != null){
            String clientTier = Rates.get(0).ClientTier__c;
            for(BOQRate__c y : Rates){
                if(clientTier.equals(y.ClientTier__c)){
                    RatesAux.add(y);
                }else{
                    boqRatesMap.put(clientTier, RatesAux);
                    RatesAux = null;
                    RatesAux = new List<BOQRate__c>();
                    clientTier = y.ClientTier__c;
                    RatesAux.add(y);
                }
            }
            boqRatesMap.put(clientTier, RatesAux);
        }
    }
    
    public List <SelectOption> getBOQAssetType() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Marine', 'Marine'));
        r.add(new SelectOption ('Caravans', 'Caravans'));
        r.add(new SelectOption ('Motorhome', 'Motorhome'));
        r.add(new SelectOption ('Campertrailer', 'Campertrailer'));
        return r;
    }
    
    public List <SelectOption> getBOQAssetAge() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        for(integer i = 0; i <=14;i++){
        	r.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
        }
        r.add(new SelectOption ('15', '15+'));
        return r;
    }
    
    public List <SelectOption> getBOQTerm() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        for(integer i = 24; i <=84;i=i+12){
        	r.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
        }
        return r;
    }
    
    public List <SelectOption> getBOQAssetCondition() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('New', 'New'));
        r.add(new SelectOption ('Used', 'Used'));
        return r;
    }
    
    public List <SelectOption> getBOQResidencyStatus() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Owner', 'Owner'));
        r.add(new SelectOption ('Buyer', 'Buyer'));
        r.add(new SelectOption ('Renter', 'Renter'));
        r.add(new SelectOption ('Boarder', 'Boarder'));
        r.add(new SelectOption ('Living with Parents', 'Living with Parents'));
        return r;
    }
    
    public List <SelectOption> getBOQClientTier() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Platinum Plus', 'Platinum Plus'));
        r.add(new SelectOption ('Platinum', 'Platinum'));
        r.add(new SelectOption ('Gold', 'Gold'));
        return r;
    }
    
    public List<SelectOption> getLoanCreditScoreOptions(){
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('700+', '700+'));
        r.add(new SelectOption ('600-659', '600-699'));
        r.add(new SelectOption ('500-599', '500-599'));
        r.add(new SelectOption ('400-499', '400-499'));
        r.add(new SelectOption ('300-399', '300-399'));
        r.add(new SelectOption ('<300', '<300'));
        return r;
    }

    public void clientRateCalc() {
        this.clientRate = this.baseRate;
        if ('Used'.equals(this.assetCondition) && this.clientRate != null) {
            this.clientRate += 1.0;
        }
    }

    public Boolean getSkipInsurances() {
        Boolean r = false;
        if (this.getNetDepositPercentage() >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
            r = true;
        }
        return r;
    }

    public Decimal getNetDepositPercentage() {
      Decimal r = 0;
      if (carPrice != null && carPrice > 0) r = (this.getNetDepositVal()/carPrice)*100;
      return r;
    }

    public Decimal getVehiclePrice() {
      Decimal r = 0.0;
      if (carPrice != null) r += carPrice;
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