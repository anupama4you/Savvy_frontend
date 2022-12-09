public class RateSetterCalculatorExtension extends QuotingExtension {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'Plenti';
    //-
    public QuotingToolHelper qh {set;get;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'RateSetter';
    //-
    public Boolean paramActive {set; get;}
    public String apiUser {get;set;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public LenderAPIResponse__c lenderAPIResp {get;set;}
    
    // Lender variables
    public String customerProfile {get;set;}
    public String loanTypeDetail {set;get;}
    public String vehicleYear {set;get;}
    public String assetType {set;get;}
    public String assetCondition {set;get;}
    public String leaseAgreement {set;get;}
    public String greenCar {set;get;}

    public RateSetterCalculatorExtension(ApexPages.StandardController controller) {
      super(controller);
      
      String active = System.currentPageReference().getParameters().get('active');
      paramActive = !StringUtils.isNullOrEmpty(active);

      qh = new QuotingToolHelper();
      
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
                if (lender != null && lender.info != null && 'RSET'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.vehicleYear = lender.vehicleYear;
                    this.clientTier = lender.clientTier;
                    this.dof = lender.dofBase;
                    this.loanType = lender.purchaseType;
                    //
                    this.baseRateCalc();
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }
    
    public Boolean isValidationOk() {
        Boolean r = true;
        // Checking for join apps
        if (this.Opp.Application__c != null && this.Opp.Application__r.No_of_People__c != null && 2 == this.Opp.Application__r.No_of_People__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Joined applications are not allowed by Plenti'));
            // r = false;
        }
        if(this.realtimeNaf < 5000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Minimum loan amount should be $10,000'));
            r = false;
        }
        if(this.realtimeNaf >= 100000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max Lend should be equal or less than $100.000'));
            // r = false;
        }
        // System.debug('1) r >> ' + r);
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        } 
        // System.debug('2) r >> ' + r);
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        } else if (this.applicationFee < this.getMaxAppFee()) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee below suggested value. $' + this.getMaxAppFee().format()));
        } else if (this.applicationFee > this.getMaxAppFee()) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee over suggested value. $' + this.getMaxAppFee().format()));
        }
        // System.debug('3) r >> ' + r);
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > 2500) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max DOF allowed is $2,500'));
            r = false;
        }
        if (this.baseRate == null || this.baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate could not be estimated, please check Profile, Client Tier and Vehicle Build Date values.'));
            r = false;
        }
        // System.debug('4) r >> ' + r);
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else if (this.clientRate < this.baseRate ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client rate should not be below of base rate: ' + this.baseRate + '%'));
            // r = false;
        } else if (this.clientRate > (this.baseRate + 2) && this.baseRate > 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate should not be above of max rate: ' + (this.baseRate + 2) + '%'));
            r = false;
        }
        if (String.isBlank(this.customerProfile)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Profile option.'));
            r = false;
        }
        if (String.isBlank(this.clientTier)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Client Tier option.'));
            r = false;
        }
        if (String.isBlank(this.assetCondition)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Vehicle Condition option.'));
          r = false;
        } else {
          if (String.isNotBlank(this.vehicleYear)) {
            Integer a = Integer.valueOf(this.vehicleYear);
            a = Datetime.now().year() - a;

            if ('new'.equals(this.assetCondition) && a > 1 && 'Car'.equals(this.assetType)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Build Date should be <= 12 months for New vehicles [Car].'));
              r = false;
            } else if ('new'.equals(this.assetCondition) && a > 2 && 'Caravan'.equals(this.assetType)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Build Date should be <= 12 months for New vehicles [Caravan].'));
              r = false;
            } else if ('demo'.equals(this.assetCondition) && a > 2) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Build Date should be <= 24 months for Demo vehicles.'));
              r = false;
            } else if (a + term/12 > 15 && 'Car'.equals(this.assetType)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cars cannot be older than 15 years old at term end'));
              r = false;
            }
          }
        }
        if (String.isBlank(this.vehicleYear)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Vehicle Build Date year.'));
            r = false;
        }

        // System.debug('5) r >> ' + r);
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        // System.debug('6) r >> ' + r);
        //Lelo              2020-09-04
        if (this.residualValue > 0) {
            if ('Tier 3'.equals(this.clientTier)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Balloon or residual payment is not allowed with this lender.'));
              r = false;
            } else if (String.isNotBlank(this.vehicleYear) && this.vehicleYear.isNumeric()) {
              Integer yrs = Date.today().year() - Integer.valueOf(this.vehicleYear);
              if (yrs >= 6) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Balloon or residual not allowed. Cars must be less than six years old at start of loan (5 years old or less)'));
              }
              yrs = MATH.round(this.term/12);
              Decimal maxDep = 50;
              if (yrs >= 5) {
                maxDep = 35;
              }
              if (this.residualValue > (this.getFinanceAmount(QuotingCalculation.CALC_QUOTING) * (maxDep/100.0))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Balloon or residual exceeded, ' + yrs + ' years term max ' + maxDep + '% of the car price (less deposit or trade in)'));
              }
            }
        }
        if ('Caravan'.equals(this.assetType) && !'Property Owner'.equals(this.customerProfile)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Must be a property owner to qualify for Caravan assets'));
            r = false;
        }
        if ('Caravan'.equals(this.assetType) && !'new'.equals(this.assetCondition)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Caravan assets is only available for new vehicles, please check Vehicle Condition.'));
            r = false;
        }
        if ('Caravan'.equals(this.assetType) && !'N'.equals(this.privateSales)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Caravan assets not available for Private Sales'));
            r = false;
        }

        if ('Car'.equals(this.assetType) && String.isBlank(this.leaseAgreement)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value for Lease Agreement'));
          r = false;
        }
        
        if (String.isBlank(this.greenCar)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Green car option'));
          r = false;
        }
        // System.debug('7) r >> ' + r); 
        return r;
    }
    
  public void calculate() {
    this.realtimeNafCalc();
    this.baseRateCalc();
    if (isValidationOk()) {
        this.calculateRepayments();
    }
  }
    
  public void reset() {
    
    this.resetQuote();

    this.loanType = 'Purchase';
    this.productLoanType = 'Consumer Loan';
    this.assetType = 'Car';
    this.assetCondition = null;
    this.customerProfile = null;
    this.vehicleYear = null;

    //Initial values
    this.monthlyFee = lenderSettings.Monthly_Fee__c;
    this.ppsr = lenderSettings.PPSR__c;
    this.applicationFee = lenderSettings.Application_Fee__c;
    this.dof = lenderSettings.DOF__c;
    this.term = 60;
    this.leaseAgreement = null;
    this.privateSales = 'N';
    
    this.resetInsuranceProducts(false);

    this.realtimeNafCalc();
    baseRateCalc();
    this.resetCalculationResult(); //Lelo       2017-07-25

    // this.usersAPIOptions = new List <SelectOption>();
    this.usersAPIOptions = PlentiAPIManager.getUserOptionsConnect();
    for (SelectOption so: this.usersAPIOptions) {
      if (so.getLabel().equals(this.Opp.Owner_Name__c)) {
        this.apiUser = so.getValue();
      }
    }
    this.greenCar = '';
  }
    
    private PageReference savePdf (String prefixName) {
      // pass parameters to the PDF page
      PageReference calcPdf = this.createPdf();
      
      // Lender parameters
      calcPdf.getParameters().put('clientTier', this.clientTier);
      calcPdf.getParameters().put('vehicleAge', this.vehicleYear);
      calcPdf.getParameters().put('customerProfile', this.customerProfile);
      calcPdf.getParameters().put('goodsType', this.assetType);
      calcPdf.getParameters().put('vehicleCondition', this.assetCondition);
      calcPdf.getParameters().put('leaseAgreement', this.leaseAgreement);
      calcPdf.getParameters().put('privateSales', this.privateSales);
      calcPdf.getParameters().put('greenCar', this.greenCar);
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

        this.isLeaseAgreementRequired(false);
        
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
        updateProduct.Lender__c = 'Plenti';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = this.clientTier + ' | ' + this.vehicleYear;
        updateProduct.Loan_Term__c = term > 0? term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = dof > 0? dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        updateProduct.Lender_App_Fee__c = this.applicationFee > 0? this.applicationFee : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        
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
            this.isLeaseAgreementRequired(false);
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
      this.resetInsuranceProducts(true);
      
      //Finance Details - Commons values
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
        if (d.Client_Rate__c != null) {
            this.clientRate = d.Client_Rate__c.setScale(2);
        }

        //Loan Details
        this.paymentType = d.Payment__c;
        if (String.isNotBlank(d.Client_Tier__c)) {
          this.clientTier = d.Client_Tier__c;
        }
        if (String.isNotBlank(d.Vehicle_Age__c)) {
          this.vehicleYear = d.Vehicle_Age__c;
        }
        if (String.isNotBlank(d.Customer_Profile__c)) {
          this.customerProfile = d.Customer_Profile__c;
        }
        if (String.isNotBlank(d.Goods_type__c)) {
          this.assetType = d.Goods_type__c;
        }
        if (String.isNotBlank(d.Vehicle_Condition__c)) {
          this.assetCondition = d.Vehicle_Condition__c;
        }
        if (String.isNotBlank(d.Private_Sales__c)) {
          this.privateSales = d.Private_Sales__c;
        }
        
        if (String.isNotBlank(d.Green_Car__c)) {
          this.greenCar = d.Green_Car__c;
        }

        this.leaseAgreement = d.Lease_Agreement__c;
        
        // load Lender API
        this.lenderAPIResp = QuotingToolHelper.getLenderAPIResponse(d.LenderAPIResponse__c);
      }
      baseRateCalc();
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
      Application_Quoting__c d = new Application_Quoting__c();
      if (this.quoting != null) {
        this.updateQuotingData();
        d = this.quoting; 
      }
      
      //Loan Details
      d.Goods_type__c = this.assetType;
      if (this.term != null) {
        d.Term__c = Decimal.valueOf(this.term);
      }
      d.Payment__c = this.paymentType;
      d.Client_Tier__c = this.clientTier;
      d.Vehicle_Age__c = this.vehicleYear;
      d.Vehicle_Condition__c = this.assetCondition;
      d.Customer_Profile__c = this.customerProfile;
      d.Lease_Agreement__c = this.leaseAgreement;
      d.Private_Sales__c = this.privateSales;
      d.Green_Car__c = this.greenCar;
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
        param.baseRate = this.baseRate;
        param.clientRate = this.clientRate;
        param.paymentType = this.paymentType;
        param.term = this.term;
        param.dof = this.dof;
        param.monthlyFee = this.monthlyFee;
        param.residualValue = this.residualValue;
        // param.residualValue = 0.00;

        param.customerProfile = this.customerProfile;
        param.clientTier = this.clientTier;
        param.vehicleYear = this.vehicleYear;

        param.commRate = 0.0;
        param.amountBaseComm = this.getFinanceAmount(quotingType);
        RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(param);
        if (rate != null) {
            param.commRate = rate.Overs__c;
        }
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
          estimatedCommission = r.Estimated_Commission__c;
          dofResult = r.DOF__c;
          insuranceIncome = r.Insurance_Income__c;
          totalCommission = r.Total_Commission__c;
          totalCommissionGst = r.Total_Commission_Gst__c;

          naf = r.NAF__c;
          rental = r.Rental__c;
          monthlyPayment = r.Monthly_Payment__c;
          fortnightlyPayment = r.Fortnightly_Payment__c;
          weeklyPayment = r.Weekly_Payment__c;
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

        //Insurance
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

    public List<RateSetterRate__c> getRates() {
      return [SELECT Profile__c, Tier__c, Overs__c, Min_Equifax_Score__c, 
                     Rate0__c, Rate1__c, Rate2__c, Rate3__c, Rate4__c
              FROM RateSetterRate__c WHERE Profile__c != null AND Loan_Product__c = 'Consumer' ORDER BY Name];
    }

    public void baseRateCalc() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        // param.term = this.term;
        param.assetType = this.assetType;
        param.hasImports = this.leaseAgreement;
        param.clientTier = this.clientTier;
        param.vehicleYear = this.vehicleYear;
        param.customerProfile = this.customerProfile;
        param.condition = this.assetCondition;
        param.greenCar = this.greenCar;
        param.term = this.term;
        System.debug('params => ' + param.clientTier + '|' + param.vehicleYear + '|' + param.customerProfile + '|' + param.condition);
        this.baseRate = QuotingCalculation.getBaseRate(param);
        this.maxRate = this.baseRate > 0? this.baseRate + 2: 0.00;
    }
    
    public void initValidation() {
        if (this.Opp.Application__c != null && this.Opp.Application__r.No_of_People__c != null && 2 == this.Opp.Application__r.No_of_People__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Joined applications are not allowed by Plenti'));
        }
    }
    
    public Decimal getMaxAppFee() {
        Decimal r = lenderSettings.Application_Fee__c;
        if ('Y'.equals(this.privateSales)) {
            r = lenderSettings.Application_Fee_Private__c;
        }
        return r;
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

    public List<SelectOption> getAssetTypeOptions() {
      List<SelectOption> r = new List<SelectOption>();
      // r.add(new SelectOption('','--None--'));
      r.add(new SelectOption('Car','Car'));
      r.add(new SelectOption('Caravan','Caravan'));
      return r;
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
        PlentiAPIManager apiManager = appService.requestApplication(Opp.Id, apiUser);
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

  public Boolean isLeaseAgreementRequired(Boolean isApproval) {
    Boolean r = false;
    if ('Car'.equals(this.assetType) && 'Y'.equals(this.leaseAgreement)) {
      List<String> docs = new List<String>{'Rental/Lease Agreement'};
      docs = PreApprovalValidatorHelper.validateDocumentsUploaded(this.Opp.Id, docs);
      if (!docs.isEmpty()) {
        ApexPages.Severity sev = isApproval ? ApexPages.Severity.ERROR : ApexPages.Severity.WARNING;
        r = isApproval ? true : r;
        String msg = 'Lease agreement must be provided to Plenti';
        ApexPages.addMessage(new ApexPages.Message(sev, msg));
      }
    }
    return r;
  }

  public Decimal getFinanceAmount(String calcType) {
    this.netDepositCalc();
    Decimal r = 0.0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
    } else {
        if (carPrice != null) r += carPrice;
    }
    r -= netDeposit;
    return r;
  }

  public List<SelectOption> getBuildDatedOptions() {
      Integer a = 12;
      return QuotingToolHelper.getVehicleYears(a);
  }

  public List<SelectOption> getTierOptions() {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('','--None--'));
      r.add(new SelectOption('Tier 1','Tier 1'));
      r.add(new SelectOption('Tier 2','Tier 2'));
      r.add(new SelectOption('Tier 3','Tier 3'));
      return r;
  }

  public List<SelectOption> getProfileOptions() {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('','--None--'));
      r.add(new SelectOption('Property Owner','Property Owner'));
      r.add(new SelectOption('Non Property Owner','Non Property Owner'));
      return r;
  }

  public Decimal getMaxRate() {
      if (this.baseRate > 0) {
          return this.baseRate + 2;
      }
      return 0.0;
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