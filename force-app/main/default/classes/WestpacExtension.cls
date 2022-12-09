public class WestpacExtension extends QuotingExtension {
    
    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'Westpac';
    public static final String LENDER_QUOTING = 'Westpac';
    public static Decimal MAX_BROKERAGE = 3.0;
    //-

    // Lender variables
    public String propertyOwner {get;set;}
    public String manufactureYear {get;set;}
    public List <SelectOption> manufactureYearOptions {get;set;}    
    public Decimal brokeragePercentage {get;set;}
    public String loanFrequency {set; get;}
    public String selectedTypeValue {set; get;}
    public Decimal residualValuePercentage {set; get;}
    public Boolean isResidualValuePercentage {set; get;}
    public String productGoodsType {get;set;}
    
    // addtional loan information
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    public List <Selectoption> loanFrequencies {set; get;}

    public WestpacExtension (ApexPages.StandardController controller) {
        super(controller);
        
        //Lelo              2016-12-22
        loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        productLoanTypes = getLoanProductOptions();
        
        loadLoanFrequency();
        selectedTypeValue = 'Percentage';

        this.quotingName = LENDER_QUOTING;
        this.reset();
        this.assetYearOption();
        this.realtimeNaf = applicationFee + dof + ppsr;
        this.brokeragePercentage = MAX_BROKERAGE;
        
        this.resetCalculationResult(); //Lelo       2017-07-25

        preLoadQuotingValues();
        
        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
        
    } // end of constructor
    
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {

        } else {
            loadQuotingParametersSaved();
        }

    }

    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtCalc(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        r += this.getTotalInsuranceType(calcType);
        if (netDeposit != null) r -= netDeposit;
        return r;
    }
    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        Decimal r = getRealtimeNaf(calcType);
        if (brokeragePercentage != null && brokeragePercentage != 0) {
          r += (r * brokeragePercentage/100);
        }
        return r;
    }
    
    public override void realtimeNafCalc() {
      netDepositCalc();
      realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
      this.calculateLPI();
	  } //end of funcion
    
    //Lelo              2017-07-26
    public Decimal getRealtimeNaf(String calcType) {
        Decimal r = 0.0;
        netDepositCalc();
        if (carPrice != null) {
          if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
              r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
          } else {
              r += carPrice;
          }
          if (selectedTypeValue == 'Percentage') {
            residualValue = ((carPrice - netDeposit) * residualValuePercentage) / 100;
          }
        }
        r += (this.applicationFee != null)? this.applicationFee : 0;
        // r += (this.dof != null)? this.dof : 0;
        r += (this.ppsr != null)? this.ppsr : 0;
        r -= this.netDeposit;
        r += this.getTotalInsuranceType(calcType);

        return r;
    }
    
    public Boolean isValidCalculate () {
        Boolean r = true;
        if (realtimeNaf < 10000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Financed Amount cannot be less than $10,000.'));
            r = false;
        }
        // validation before calculation
        if (clientRate == null || clientRate <= 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }

        if (baseRate <= 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate should be greater than zero'));
            r = false;
        }

        if (term == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a term'));
            r = false;
        }
        if (String.isBlank(manufactureYear)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an Asset Year option.'));
            r = false;
        }
        if (String.isBlank(privateSales)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a Private Sale option.'));
            r = false;
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        if (brokeragePercentage > MAX_BROKERAGE) {
          ApexPages.addMessage(
            new ApexPages.Message(ApexPages.Severity.WARNING,
              'Warning: Standard brokerage is 3%. For max 4% refer to lender'));
        }
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }

        if ('Novated Lease'.equals(productLoanType)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
            'Warning: Residuals must adhere to ATO guidelines. Check you have the correct residual'));
        }

        if (applicationFee > lenderSettings.Application_Fee__c) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max Application Fee exceed.'));
          r = false;
        }

        if (applicationFee < dof) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee should not be below the DOF'));
          r = false;
        }

        if (residualValue < 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            'Residual value should be greater than or equal to zero'));
          r = false;
        }
        return r;
    }
    
    public void calculate () {
        baseRateCalc();        
        if (isValidCalculate()) {
          this.calculateRepayments(); 
          if (estimatedCommission <= 0) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
          }
        }
    } // end of function
    
    public void reset () {
      this.resetQuote();
        this.loanType = this.loanTypeOptions.get(0).getValue();
        this.productLoanType = this.productLoanTypes.get(0).getValue();
        this.productGoodsTypes = getProductGoodsTypeOptions();
        this.loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
        this.productGoodsType = productGoodsTypes.get(0).getValue();
        this.carPrice = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;        
        this.residualValuePercentage = 0.00;
        this.selectedTypeValue = 'Value';
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.term = 60;
        this.propertyOwner = 'N';
        this.brokeragePercentage = MAX_BROKERAGE;
        this.paymentType = 'Advance';
        this.productGoodsType = '';
        this.loanFrequency = '';
        resetResidualValues();

        this.resetInsuranceProducts(false);

        this.assetYearOption();
        this.realtimeNafCalc();
        this.resetCalculationResult(); //Lelo       2017-07-25
    } // end of function
    
    private PageReference savePdf (String prefixName) {
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'WESTPAC CALCULATION');
        
        // Lender parameters
        calcPdf.getParameters().put('selectedTypeValue', selectedTypeValue);
        calcPdf.getParameters().put('residualValuePercentage', String.valueOf(residualValuePercentage));
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(brokeragePercentage));
        calcPdf.getParameters().put('privateSales', privateSales);
        calcPdf.getParameters().put('customerProfile', propertyOwner);
        calcPdf.getParameters().put('carAge', manufactureYear);
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('loanFrequency', loanFrequency);
        
        savePdfInCloud(calcPdf, prefixName);
        return null;
    } // end of function
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidCalculate()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending for approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        if (this.Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create or assoiciate an Application Forma before saving for any approval process.'));
            return null;   
        }

        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Lelo          Insurance           2018-02-20
        //Storing quoting data
        saveQuotingParameters();
        //-
        
        //Lelo                                  2016-07-26
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
              Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
            
        updateProduct.Loan_Purpose__c = 'Business Use';
        updateProduct.Lender__c = 'Westpac';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        
        updateProduct.Loan_Term__c = term > 0? term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = dof > 0? dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        updateProduct.Lender_App_Fee__c = this.applicationFee > 0? this.applicationFee - updateProduct.DOF__c: 0.00;
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        
        //Lelo                      2018-02-20
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
    
    //Lelo                                  2016-07-26
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
      return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
    }
    
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = (d != null)? d : new Application_Quoting__c();
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');
            
            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }
            
            //Finance Details
            //Commons values
            loanType = d.Loan_Type__c;
            productLoanType = d.Loan_Product__c;
            carPrice = d.Vehicle_Price__c;
            deposit = d.Deposit__c;
            tradeIn = d.Trade_In__c;
            payoutOn = d.Payout_On__c;
            netDepositCalc();
            residualValue = d.Residual_Value__c;
            
            if (sameQuoting) {
              this.loadQuotingInsuranceData();
              this.loadQuotingData();

              residualValuePercentage = d.Residual_Value_Percentage__c;
              if (d.Residual_Value_Percentage__c != null && d.Residual_Value_Percentage__c != 0){
                  selectedTypeValue = 'Percentage';
              } else {
                  selectedTypeValue = 'Value';
              }
                productGoodsType = d.Goods_type__c;
                
                if (String.isNotBlank(productLoanType)) {
                    loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
                }
                loanFrequency = d.Loan_Frequency__c;
                brokeragePercentage = d.Brokerage__c;
                privateSales = d.Private_Sales__c;
                paymentType = d.Payment__c;

                if (String.isNotBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()) {
                    manufactureYear = d.Vehicle_Age__c;
                }
                propertyOwner = d.Customer_Profile__c;
                baseRate = d.Base_Rate__c.setScale(2);
                baseRateCalc();
            }
            realtimeNafCalc();
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
        d.Goods_type__c = productGoodsType;
        d.Loan_Frequency__c = loanFrequency;
        d.Residual_Value_Percentage__c = null;
        if (selectedTypeValue == 'Percentage'){
            d.Residual_Value_Percentage__c = residualValuePercentage;
        }
        d.Brokerage__c = brokeragePercentage;

        //Loan Details
        d.Payment__c = paymentType;
        d.Private_Sales__c = privateSales;
        d.Vehicle_Age__c = manufactureYear;
        d.Customer_Profile__c = propertyOwner;
        
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

    }
    //-      
    
    public void changeLoanProduct(){
        productGoodsTypes = getProductGoodsTypeOptions();
        productGoodsType = productGoodsTypes.get(0).getValue();
        baseRateCalc();
        loadLoanFrequency();
    }

    public void loadLoanFrequency(){
        loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
        loanFrequency = loanFrequencies.get(0).getValue();
    }
    
    public void resetResidualValues(){
        residualValue = 0.0;
        residualValuePercentage = 0.0;
        isResidualValuePercentage = false;
        if (selectedTypeValue == 'Percentage'){
            isResidualValuePercentage = true;
        }
    }
    
    public List <SelectOption> getOptions(){
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('Percentage', 'Percentage'));
        r.add(new SelectOption ('Value', 'Value'));
        return r;
    }

    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }
        
    //Lelo                      2017-07-21
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidCalculate();
        if (r) {
            calculate();
            if (rental != null && rental > 0) {
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
    //-
    
    private void calculateRepayments() {
      //Reset results
      this.resetCalculationResult();
      //FULL CALCULATION
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      String quotingType = QuotingCalculation.CALC_QUOTING;
      param.totalAmount = getTotalAmount(quotingType);
      param.totalInsurance = getTotalInsuranceType(quotingType);
      param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
      //param.clientRate = clientRate;
      param.baseRate = baseRate;
      param.paymentType = paymentType;
      param.term = term;
      param.dof = dof;
      if (residualValue > 0) {
        param.term--;
      }
      param.monthlyFee = monthlyFee;
      param.residualValue = residualValue;

      param.brokeragePer = brokeragePercentage;
      param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(quotingType);
      param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);

      System.debug(quotingType + '|' + param.amountBasePmt + '|' + param.amountBaseComm + '|' + param.getNaf());

      Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
      if (r != null) {
        estimatedCommission = r.Estimated_Commission__c;
        dofResult = r.DOF__c;
        insuranceIncome = r.Insurance_Income__c;
        totalCommission = r.Total_Commission__c;
        totalCommissionGst = r.Total_Commission_Gst__c;

        naf = r.NAF__c;
        rental = r.Rental__c;
        monthlyPayment= r.Monthly_Payment__c;
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

      List<String> calcTypes = new List<String>();
      //Insurance one by one
      //MV
      if (mv != null && mv > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
      }
      //GAP
      if (gap != null && gap > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
      }
      //WARR
      if (warranty != null && warranty > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
      }
      //NWC
      if (nwc != null && nwc > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
      }
      //CCI
      //Lelo          Insurance           2018-02-26
      if (cci != null && cci > 0) {
          calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
      }
      //-
      
      for (String key: calcTypes) {
        param.totalAmount = getTotalAmount(key);
        param.totalInsurance = this.getTotalInsuranceType(key);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(key);
        param.amountBaseComm = this.getBaseAmountPmtCalc(key);
        System.debug('INSURA >> ' + key + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.amountBasePmt + '|' + param.amountBaseComm);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = key;   
        }
        calResults.put(key, r);                
      }

    }

    //Yohan VillaLeal    08/11/2018
    public void assetYearOption(){
      manufactureYearOptions = new List <SelectOption> ();
      manufactureYearOptions.add(new SelectOption ('', '--None--'));    
      Integer y = Date.today().year();

      for(Integer i = y;i >= y - 4;i--) {
        manufactureYearOptions.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
      }
      SelectOption myOp = manufactureYearOptions.get(manufactureYearOptions.size()-1);
      myOp.setLabel(myOp.getValue() + ' or older');

      this.manufactureYear = manufactureYearOptions.get(0).getValue();
    }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
  
  // Abstract methods implementation
  public override Boolean hasValidQuotation() {
    System.debug(this.quotingName + ' overriding hasValidQuotation...');
    return this.isValidCalculate();
  }

  public override void calculateQuote() {
    System.debug(this.quotingName + ' overriding calculateQuote...');
    this.calculate();
  }

  public override void storeQuotingData() {
    System.debug(this.quotingName + ' overriding storeQuotingData...');
    this.saveQuotingParameters();
  }

  public List<SelectOption> getLoanProductOptions() {
    List<SelectOption> r = new List<SelectOption> ();
    r.add(new SelectOption ('Chattel Mortgage-Full-Doc', 
      'Chattel Mortgage-Full-Doc'));
    r.add(new SelectOption ('Chattel Mortgage-Low-Doc', 
      'Chattel Mortgage-Low-Doc'));
    r.add(new SelectOption ('Finance Lease', 'Finance Lease'));
    r.add(new SelectOption ('Novated Lease', 'Novated Lease'));
    return r;
  }

  public List<SelectOption> getProductGoodsTypeOptions() {
    List<SelectOption> r = new List<SelectOption> ();
    r.add(new SelectOption ('Motor vehicle and transport', 
      'Motor vehicle and transport'));
    r.add(new SelectOption ('Agricultural', 'Agricultural'));
    r.add(new SelectOption ('Yellow goods', 'Yellow goods'));
    r.add(new SelectOption ('Other', 'Other'));
    return r;
  }

  public void baseRateCalc() {

    Decimal originalRate = 0.00;
    //Lelo                              2016-08-25
    realtimeNafCalc();
    Decimal financeAmount = realtimeNaf;
    //-
    
    if (brokeragePercentage > MAX_BROKERAGE) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than ' + MAX_BROKERAGE.format() + '%'));
    }

    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
    param.term = term;
    param.baseRate = baseRate;
    param.totalAmount = financeAmount;
    if (brokeragePercentage != null) {
        param.amountBasePmt = getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_QUOTING);
    }
    param.paymentType = paymentType;
    param.residualValue = this.residualValue;
    clientRate = QuotingCalculation.getClientRateCalculation(param);
  }

  override public Decimal getTotalAmount(String quotingType) {
    Decimal r = super.getTotalAmount(quotingType);
    return r - (this.dof > 0? this.dof : 0.0);
  }
}