public class PepperCommExtension extends QuotingExtension {
  
  //Lelo                  2016-07-26
  private String fileGlobalPrefix = 'Pepper_COMM';
  
  // addtional loan information
  public List<SelectOption> productLoanTypes { get; set; }
  public List<SelectOption> productGoodsTypes { get; set; }

  //Lelo                                      2016-12-20
  public static final String LENDER_QUOTING = 'Pepper Commercial';
  //-
  //Pepper API - HJ - I
  public PepperApplicationService ppAppService;
  public PepperAPIManager ppAPIManager { get; set; }
  public String pepperAPI_AppNumber { get; set; }
  public String pepperAPI_ResponseContent { get; set; }
  public String pepperAPI_lastResponseApp { get; set; }
  public List<SelectOption> usersAPIOptions { get; set; }
  public String apiUser { get; set; }
  public Boolean paramActive { get; set; }
  //Pepper API - HJ - F

  // variables only for Pepper
  public String vehicleAge { get; set; }
  public Boolean submitRequest { get; set; }

  public PepperCommExtension(ApexPages.StandardController controller) {
    super(controller);
    //Pepper API - HJ - I
    String active = System.currentPageReference().getParameters().get('active');
    paramActive = !StringUtils.isNullOrEmpty(active);
    //Pepper API - HJ - F

    productGoodsTypes = new List<SelectOption>();
    productGoodsTypes.add(new SelectOption('', '--None--'));
    productGoodsTypes.add(new SelectOption('Car', 'Car'));
    productGoodsTypes.add(new SelectOption('Caravan', 'Caravan'));
    productGoodsTypes.add(
      new SelectOption('Wheels & Tracks', 'Wheels & Tracks')
    );
    //productGoodsTypes.add(new SelectOption('Other', 'Other'));
    productGoodsTypes.add(new SelectOption('Other-Primary Assets', 'Other-Primary Assets'));
    productGoodsTypes.add(new SelectOption('Other-Secondary & Tertiary Assets', 'Other-Secondary & Tertiary Assets'));
    loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
    productLoanTypes = QuotingToolHelper.getLoanProductOptionsCommercial();
    //-

    this.quotingName = LENDER_QUOTING;
    this.reset();

    List<Lender_Login__c> listL = [
      SELECT Owner.Name, User_Name__c
      FROM Lender_Login__c
      WHERE Lender__c = 'Pepper' AND Owner.isActive = TRUE
      ORDER BY Owner.Name
    ];

    for (Lender_Login__c l : listL) {
      if (l.Owner.Name.equals(Opp.Owner.Name)) {
        apiUser = l.User_Name__c;
      }
    }
    preLoadQuotingValues();
    //Pepper API - HJ - I
    ppAPIManager = new PepperAPIManager();
    usersAPIOptions = PepperAPIManager.getUserOptionsConnect();
    //apiUser = this.Opp.Owner_Email__c;
    //Pepper API - HJ - F

    //NWC Calculator - HJ - 12-07-2018 - I
    loadNWCParameters();
    //NWC Calculator - HJ - 12-07-2018 - F
  }

  private void preLoadQuotingValues() {
    //Get parameters
    String paramTmp = System.currentPageReference()
      .getParameters()
      .get('preloadQuting');
    if ('1'.equals(paramTmp)) {
      // List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
      // System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
      // try {
      //     LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
      //         oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
      //     if (lender != null && lender.info != null && 'PEMV'.equals(lender.info.Code__c)) {
      //         this.carPrice = lender.carPrice;
      //         this.deposit = lender.deposit;
      //         this.term = lender.term;
      //         this.productGoodsType = lender.productGoodsType;
      //         if (String.isNotBlank(lender.productLoanType)) {
      //             if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
      //                 this.productLoanType = 'Chattel Mortgage-Full-Doc';
      //             } else if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('low')) {
      //                 this.productLoanType = 'Chattel Mortgage-Low-Doc';
      //             }
      //         }
      //         this.privateSales = lender.privateSales;
      //         if (lender.clientTier != null) {
      //             this.clientTier = lender.clientTier;
      //         }
      //         if (lender.vehicleYear != null) {
      //             this.vehicleAge = lender.vehicleYear;
      //         }
      //         //Lelo                          2017-11-16
      //         this.clientRate = lender.clientRate;
      //         this.dof = lender.dofBase;
      //         this.applicationFee = lender.appFeeVal;
      //         this.baseRateCalc();
      //         //
      //     }
      // } catch (Exception e) {
      //     System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
      // }
    } else {
      loadQuotingParametersSaved();
    }
    //Lelo              Insurance           2017-12-04
    nationalWarrantyCalc();
    //this.getTotalInsurance();
    //-
  }

  public void applicationFeefCalc() {
    if ('Y'.equals(privateSales)) {
      applicationFee = lenderSettings.Application_Fee_Private__c;
    } else {
      applicationFee = lenderSettings.Application_Fee__c;
    }
    realtimeNafCalc();
  }

  private Boolean isValidationOk() {
    Boolean r = true;

    // validation before calculation
    if (clientRate == null || clientRate == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Client Rate cannot be Zero.'
        )
      );
      r = false;
    } else if (clientRate > this.maxRate) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Client Rate cannot exceed the max rate: ' +
          this.maxRate +
          '%'
        )
      );
      r = false;
    } else if (clientRate < this.baseRate) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Client Rate is below Base Rate.'
        )
      );
    }
    if (String.isBlank(productGoodsType)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select a value for Goods Type'
        )
      );
      r = false;
    }

    if (String.isBlank(vehicleAge)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select a value for Asset Age'
        )
      );
      r = false;
    }

    if (term == null || term == 0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please choose an appropriate term.'
        )
      );
      r = false;
    }

    if (clientTier == null || clientTier == '') {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please choose a tier for the client.'
        )
      );
      r = false;
    }

    if (!isInsuranceValidationOK()) {
      r = false;
    }

    //Lelo              2017-09-19
    if (residualValue > 0 && term > 60) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'You cannot have a balloon or residual payment when the loan term is > 5 years.'
        )
      );
      r = false;
    }
    if (
      residualValue > 0 &&
      !('New'.equals(vehicleAge) || 'Used 0-5 years'.equals(vehicleAge))
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Residuals may not be available for assets > 5 years old'
        )
      );
    }
    if (
      'Caravan'.equals(this.productGoodsType) &&
      'Y'.equals(this.privateSales) &&
      this.realtimeNaf > 100000.0
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Normally max NAF of $100,000 for Private sale assets - refer to Pepper'
        )
      );
    }
    if (
      'Caravan'.equals(this.productGoodsType) && 'C'.equals(this.clientTier)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Leisure assets not normally available for C risk grade'
        )
      );
    }
    //NWC Calculator - HJ - 06-08-2018 - I
    if (!isNWCValidationOk) {
      r = false;
    }
    if (String.isBlank(privateSales)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select a value for Private Sales'
        )
      );
      r = false;
    } else if ('Y'.equals(privateSales)) {
      if (realtimeNaf > 75000) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'Private sales max. NAF should be $75K'
          )
        );
      }
    }
    //
    //NWC Calculator - HJ - 06-08-2018 - F
    /*
    if ('Refinance'.equals(loanType) && String.isBlank(loanPurpose)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please put a Loan Purpose for this quote. Why is your customer looking at refinancing?'
        )
      );
      r = false;
    }
    */
    if('C'.equals(this.clientTier) && Opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Pepper cannot split expenses with Tier C'));
    }

    return r;
  }

  public void calculate() {
    this.baseRateCalc();
    realtimeNafCalc();
    if (isValidationOk()) {
      this.calculateRepayments(true);

      if (estimatedCommission <= 0) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'The commission is below zero. Please make adjustment to make sure commission is above zero.'
          )
        );
      }
    }
  } // end of function

  public void reset() {
    this.resetQuote();
    this.resetInsuranceProducts(false);

    this.loanType = loanTypeOptions.get(0).getValue();
    this.productLoanType = productLoanTypes.get(0).getValue();
    this.productGoodsType = productGoodsTypes.get(1).getValue();
    
    this.applicationFee = lenderSettings.Application_Fee__c;
    this.dof = lenderSettings.DOF__c;
    this.ppsr = lenderSettings.PPSR__c; //Lelo              2016-09-20      //Original value: 6.80 --> 8.9 (2017-12-29) + 3.4
    this.monthlyFee = lenderSettings.Monthly_Fee__c;
    
    this.term = 60;
    this.clientTier = 'A';
    this.vehicleAge = null;
    this.paymentType = 'Arrears';
    this.privateSales = 'N';
    
    this.realtimeNafCalc();
    this.baseRateCalc();
    this.resetCalculationResult(); //Lelo       2017-07-25
  } // end of function

  private PageReference savePdf(String prefixName) {
    // pass parameters to the PDF page
    PageReference calcPdf = this.createPdf();
    
    calcPdf.getParameters().put('clientTier', clientTier);
    calcPdf.getParameters().put('vehicleAge', this.vehicleAge);
    calcPdf.getParameters().put('privateSales', privateSales);
    calcPdf.getParameters().put('productGoodsType', productGoodsType);
    
    savePdfInCloud(calcPdf, prefixName);

    return null;
  } // end of function

  private PageReference saveProduct(String prefixName) {
    //Recalculate
    if (!isValidationOk()) {
      return null;
    }
    calculate();
    // validate calculation
    if (rental == null || rental == 0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please calculate before sending to approval.'
        )
      );
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

    if (!validateVehicleAgeWithYear() && !Test.isRunningTest()) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Age does not match with the Vehicle Year in Asset Details page.'
        )
      );
      return null;
    }

    //Lelo                                  2016-07-26
    savePdf(prefixName);
    Product__c updateProduct = null;
    if (Opp.Loan_Product__c == null) {
      // first create a finance product
      updateProduct = new Product__c(
        RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
        Opportunity_Name__c = this.Opp.Id
      );
    } else {
      // first update the finance product
      updateProduct = [
        SELECT
          id,
          Loan_Purpose__c,
          Quoting_Source__c,
          Lender__c,
          Repayment_Regularity__c,
          Loan_Type__c,
          Loan_Term__c,
          Balloon_Residual_Requested__c,
          Client_Rate__c,
          Payments__c,
          Cost_of_Goods__c,
          Deposit__c,
          Brokerage__c,
          Lender_App_Fee__c,
          Equalisation_Fee_PPSR__c,
          DOF__c,
          Loan_Type_Detail__c,
          Loan_Product__c
        FROM Product__c
        WHERE id = :Opp.Loan_Product__c
      ];
    }
    //-
    updateProduct.Loan_Purpose__c = 'Business Use';

    updateProduct.Lender__c = 'Pepper';
    updateProduct.Quoting_Source__c = LENDER_QUOTING;
    updateProduct.Repayment_Regularity__c = 'Monthly';

    updateProduct.Loan_Type__c = loanType;
    updateProduct.Loan_Product__c = productLoanType;
    updateProduct.Loan_Type_Detail__c = 'Client Tier ' + clientTier;
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

    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.Severity.CONFIRM,
        'Product updated successfully.'
      )
    );
    return null;
  } // end of function

  //Lelo                                  2016-07-26
  public PageReference saveQuoting() {
    //Recalculate
    if (
      hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)
    ) {
      this.saveQuotingParameters();
      // this.savePdf(fileGlobalPrefix);
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
    if (
      InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)
    ) {
      if (insuranceProductSelected()) {
        this.quoting.Force_Calculation__c = false;
        return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
      }
    }
    return null;
  }
  //-

  private void loadQuotingParametersSaved() {
    System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
    Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(
      this.Opp.Id,
      this.Opp.Application__c
    );
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
      loanType = d.Loan_Type__c;
      productLoanType = d.Loan_Product__c;
      carPrice = d.Vehicle_Price__c;
      deposit = d.Deposit__c;
      tradeIn = d.Trade_In__c;
      payoutOn = d.Payout_On__c;
      netDepositCalc();
      residualValue = d.Residual_Value__c;
      if (d.Term__c != null) {
        term = Integer.valueOf(d.Term__c);
      }

      if (sameQuoting) {
        this.loadQuotingInsuranceData();
        this.loadQuotingData();
        //Specific values
        productGoodsType = d.Goods_type__c;
        //Loan Details
        clientTier = d.Client_Tier__c;
        privateSales = d.Private_Sales__c;
        if (String.isNotBlank(d.Vehicle_Age__c)) {
          this.vehicleAge = d.Vehicle_Age__c;
        }
        
        //-
        //Pepper API - HJ - I
        pepperAPI_AppNumber = d.PepperAPI_Application_Id__c;
        pepperAPI_ResponseContent = d.PepperAPI_Response_Message__c;
        pepperAPI_lastResponseApp = d.PepperAPI_Last_Response_App__c;
        //Pepper API - HJ - F
        List<LenderAPIResponse__c> l = [
          SELECT Application_ID__c, Lender_Login__c
          FROM LenderAPIResponse__c
          WHERE
            Application_ID__c != NULL
            AND Application_ID__c = :d.PepperAPI_Application_Id__c
        ];

        if (!l.isEmpty()) {
          apiUser = l.get(0).Lender_Login__c;
        }
      }

      if (!sameQuoting) {
        d.PepperAPI_Application_Id__c = null;
        d.PepperAPI_Response_Message__c = null;
        d.PepperAPI_Last_Response_App__c = null;
      }
    }
    this.baseRateCalc();
    this.realtimeNafCalc();
    this.realtimeNafCalc(); //Yes, leave this twice
    if (sameQuoting) {
      try {
        this.calculateRepayments(true);
      } catch (Exception e) {
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Error re-calculating repayments.'
        );
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Error reported: ' + e.getMessage()
        );
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Error cause: ' + e.getCause()
        );
      }
    }
    
  }

  private void saveQuotingParameters() {
    System.debug('Saving Quoting...' + LENDER_QUOTING);

    //NWC Warning - I
    if (
      nwcParam != null &&
      nwcParam.vehicleAgeYears != null &&
      nwcParam.vehicleAgeYears > 20
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'No car more than 20 years old can be covered. VechileYear: ' +
          nwcParam.vehicleAgeYears
        )
      );
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
    d.Client_Tier__c = clientTier;
    d.Private_Sales__c = privateSales;
    d.Vehicle_Age__c = this.vehicleAge;
    
    //Save the record
    QuotingToolHelper.saveApplicationQuoting(d);

    //Save calculations
    QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

  }
  
  public String getLenderQuoting() {
    return LENDER_QUOTING;
  }

  //Lelo                      2017-07-21
  public Boolean hasCalculationDone() {
    Boolean r = false;
    //Recalculate
    r = isValidationOk();
    if (r) {
      calculate();
      if (rental != null && rental > 0) {
        r = true;
      } else {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please calculate before proceeding with your request.'
          )
        );
        r = false;
      }
    }
    return r;
  }

  public void sendCustomerEmail1() {
    System.debug('sendCustomerEmail1...');
    if (
      hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)
    ) {
      saveQuotingParameters();
    }
  }

  public void sendCustomerEmail2() {
    System.debug('sendCustomerEmail2...');
    if (
      hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)
    ) {
      try {
        Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(
          this.Opp.Id,
          this.Opp.Application__c
        );
        EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(
          this.Opp,
          q
        );
        EmailSender.sendQuotingEmailToCustomer(param);
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.INFO,
            'Your email has been sent it.'
          )
        );
      } catch (EmailException e) {
        System.debug('Error: ' + e.getMessage());
        ApexPages.addMessage(
          new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())
        );
      }
    }
  }
  //-

  private void calculateRepayments(Boolean includeInsurance) {
    //Reset results
    this.resetCalculationResult();
    //FULL CALCULATION
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      LENDER_QUOTING
    );
    String quotingType = QuotingCalculation.CALC_QUOTING;
    param.totalAmount = getTotalAmount(quotingType);
    param.totalInsurance = getTotalInsuranceType(quotingType);
    param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
    param.clientRate = clientRate;
    param.baseRate = this.baseRate;
    param.paymentType = paymentType;
    param.term = term;
    param.dof = dof;
    param.monthlyFee = monthlyFee;
    //param.docFees = docFees;
    param.residualValue = residualValue;
    param.clientTier = this.clientTier;
    param.productLoanType = this.productLoanType;
    param.vehicleYear = this.vehicleAge;
    param.goodsType = this.productGoodsType;
    param.privateSales = this.privateSales;
    param.customerProfile = 'COMMERCIAL';
    if ('Other-Primary Assets'.equals(productGoodsType)) {
      param.customerProfile = 'OTHER - Primary';
    } else if ('Other-Secondary & Tertiary Assets'.equals(productGoodsType)) {
      param.customerProfile = 'OTHER - 2nd & 3rd';
    }
    System.debug(
      quotingType +
      '|' +
      param.totalAmount +
      '|' +
      param.totalInsurance +
      '|' +
      param.totalInsuranceIncome
    );

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

    for (String key : calcTypes) {
      param.totalInsurance = this.getTotalInsuranceType(key);
      param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
      r = QuotingCalculation.calculate(param);
      if (r != null) {
        r.Result_Type__c = key;
      }
      calResults.put(key, r);
    }   

  }

  //Pepper API - HJ - I
  public void pepperApplicationTest() {
    if (!hasCalculationDone())
      return;
    System.debug('>>>>> Response APPLICATION Pepper (Test)  -I  <<<<<< - ');
    try {
      ppAppService = new PepperApplicationService();
      ppAppService.requestApplicationTest(
        ppAPIManager,
        Opp,
        apiUser,
        PepperAPIManager.Pepper_MV
      );
    } catch (GenericException ex) {
      ppAPIManager.isError = true;
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())
      );
    }
    System.debug('>>>>> Response APPLICATION Pepper  (test)-F  <<<<<< - ');
  }

  public void pepperApplication() {
    if (!hasCalculationDone())
      return;
    System.debug('>>>>> Response APPLICATION Pepper  -I  <<<<<< - ');
    System.debug(apiUser);
    try {
      ppAppService = new PepperApplicationService();
      ppAppService.requestApplication(
        ppAPIManager,
        Opp,
        apiUser,
        PepperAPIManager.Pepper_MV
      );
    } catch (GenericException ex) {
      ppAPIManager.isError = true;
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())
      );
      return;
    }
    // System.debug('ppAPIManager => ' + JSON.serializePretty(ppAPIManager));
    if (ppAPIManager.isError && 200 != ppAPIManager.responseStatus) {
      showErrorsPepperAPI();
    } else if (ppAPIManager.pepperAppResponseDTO != null) {
      pepperAPI_AppNumber = ppAPIManager.pepperAppResponseDTO.application.applicationNo;
      pepperAPI_ResponseContent = ppAPIManager.pepperAppResponseDTO.requestId;
      pepperAPI_lastResponseApp = ppAPIManager.pepperAppResponseDTO.lastResponseApplication;
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.INFO,
          'Application number:   ' + pepperAPI_AppNumber
        )
      );
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.INFO,
          'Request Id:   ' + pepperAPI_ResponseContent
        )
      );
      saveAPIInformation();
    }
    System.debug('>>>>> Response APPLICATION Pepper  -F  <<<<<< - ');
    PepperAPIManager.saveLenderAPIResponse(this.ppAPIManager, this.Opp.Id, LENDER_QUOTING, apiUser);
  }
  /*
  public void saveLenderAPIResponse() {
    if (
      this.ppAPIManager != null &&
      String.isNotBlank(this.ppAPIManager.responseMessage)
    ) {
      LenderAPIResponse__c lar = new LenderAPIResponse__c();
      lar.Name = LENDER_QUOTING;
      lar.Opportunity__c = this.Opp.Id;
      lar.Request__c = this.ppAPIManager.reqBody;
      lar.Response__c = this.ppAPIManager.responseMessage;
      lar.Status__c = this.ppAPIManager.responseStatus;
      lar.Provider__c = 'Pepper';
      lar.Service__c = 'consumer';
      lar.Quoting_Source__c = LENDER_QUOTING;
      if (
        this.ppAPIManager.pepperAppResponseDTO != null &&
        this.ppAPIManager.pepperAppResponseDTO.application != null &&
        this.ppAPIManager.pepperAppResponseDTO.application.applicationNo != null
      ) {
        lar.Application_ID__c = this.ppAPIManager.pepperAppResponseDTO.application.applicationNo;
        lar.Name += ' [' + lar.Application_ID__c + ']';
        lar.Lender_Login__c = apiUser;
      } else {
        lar.Name += ' [FAIL-' + DateUtils.getTimeForFileName() + ']';
      }

      insert lar;

      if (
        this.ppAPIManager.pepperAppResponseDTO != null &&
        this.ppAPIManager.pepperAppResponseDTO.application != null &&
        this.ppAPIManager.pepperAppResponseDTO.application.applicationNo != null
      ) {
        saveLenderAPIResponseFile();
      }
    }
  }
  */
  private void showErrorsPepperAPI() {
    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.Severity.WARNING,
        'Savvy message: ' +
        ppAPIManager.message +
        '. Please check all the data.'
      )
    );
    String sError = '';
    System.debug(sError);
    String responseMessage = StringUtils.validateNull(
      ppAPIManager.responseMessage
    );
    String[] errors = responseMessage.split('-');
    if (ppAPIManager.isError == null) {
      sError =
        'Status: [' +
        ppAPIManager.responseStatus +
        ']- Message: [' +
        StringUtils.validateNull(ppAPIManager.message) +
        ']- Response Message: [' +
        responseMessage +
        ']';
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.WARNING, sError)
      );
    } else {
      sError =
        'Status: [' +
        ppAPIManager.responseStatus +
        ']- Message: [' +
        StringUtils.validateNull(ppAPIManager.message) +
        ']- Response Message: [' +
        responseMessage +
        ']';
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, sError)
      );
    }

    /*for (String e : errors) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e));
    }*/
    if (ppAPIManager.pepperAppResponseDTO.reasonsForSubmissionFailure != null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        '**Errors list**'));
      for (PepperApplicationResponseDTO.ReasonsForSubmissionFailure r : 
        ppAPIManager.pepperAppResponseDTO.reasonsForSubmissionFailure) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
          r.applicationSection+' '+r.errorMessage+' '+r.errorContext));
      }
    }
  }

  private void saveAPIInformation() {
    this.quoting.PepperAPI_Application_Id__c = pepperAPI_AppNumber;
    this.quoting.PepperAPI_Response_Message__c = pepperAPI_ResponseContent;
    this.quoting.PepperAPI_Last_Response_App__c = pepperAPI_lastResponseApp;
    update this.quoting;
  }
  //Pepper API - HJ - F

  // Leandro                  2018-10-11
  public void baseRateCalc() {
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      LENDER_QUOTING
    );
    param.productLoanType = this.productLoanType;
    param.term = this.term;
    param.customerProfile = 'COMMERCIAL';
    if ('Other-Primary Assets'.equals(productGoodsType)) {
      param.customerProfile = 'OTHER - Primary';
    } else if ('Other-Secondary & Tertiary Assets'.equals(productGoodsType)) {
      param.customerProfile = 'OTHER - 2nd & 3rd';
    }
    param.clientTier = this.clientTier;
    param.vehicleYear = this.vehicleAge;
    param.goodsType = this.productGoodsType;
    param.privateSales = this.privateSales;
    // System.debug(JSON.serializePretty(param));
    this.baseRate = QuotingCalculation.getBaseRate(param);
    this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
    System.debug(baseRate);
  }

  public boolean validateVehicleAgeWithYear() {
    Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(
      this.Opp.Id
    );
    if (aad != null) {
      Integer differenceYear;
      if (aad.Year__c != null) {
        differenceYear = Date.Today().year() - Integer.valueOf(aad.Year__c);
        if ('used'.equalsIgnoreCase(aad.Condition__c)) {
          if (
            'Used 0-5 years'.equals(vehicleAge) &&
            differenceYear >= 0 &&
            differenceYear <= 5
          ) {
            return true;
          } else if (
            'Used 6+ years'.equals(vehicleAge) &&
            differenceYear >= 6
          ) {
            return true;
          }
        } else if (
          'new'.equalsIgnoreCase(aad.Condition__c) ||
          'demo'.equalsIgnoreCase(aad.Condition__c)
        ) {
          if (
            'New'.equals(vehicleAge) &&
            differenceYear >= 0 &&
            differenceYear <= 3
          ) {
            return true;
          }
        }
      }
    }
    return false;
  }

  public List<SelectOption> getTierOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    r.add(new SelectOption('A', 'A'));
    r.add(new SelectOption('B', 'B'));
    r.add(new SelectOption('C', 'C'));

    return r;
  }

  public List<SelectOption> getAssetAgeOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    r.add(new SelectOption('New', 'New'));
    r.add(new SelectOption('Used 0-5 years', 'Used 0-5 years'));
    r.add(new SelectOption('Used 6+ years', 'Used 6+ years'));
    return r;
  }

  public void sendFiles() {
    System.debug(pepperAPI_AppNumber);
    System.debug(apiUser);
     if (String.isNotBlank(pepperAPI_AppNumber) && String.isNotBlank(apiUser)) {
       ppAppService = new PepperApplicationService();
       this.ppAPIManager.pepperAppResponseDTO = new PepperApplicationResponseDTO();
       ppAppService.uploadDocumentsToPepper(
         this.ppAPIManager,
         Opp.Id,
         this.quoting.PepperAPI_Application_Id__c,
         true,
         apiUser
       );
       List<LenderAPIResponse__c> lenderList = [
         SELECT Id, Application_ID__c
         FROM LenderAPIResponse__c
         WHERE Application_ID__c = :this.quoting.PepperAPI_Application_Id__c
       ];
      
       LenderAPIResponse__c lender;

       if (!lenderList.isEmpty()) {
         lender = lenderList.get(0);
         PepperAPIManager.saveLenderAPIResponseFiles(lender.Id, this.ppAPIManager);
       }
     } else if (String.isBlank(apiUser)) {
       ApexPages.addMessage(
         new ApexPages.Message(
           ApexPages.Severity.ERROR,
           'Missing Pepper user. Please select one.'
         )
       );
     }
  }
  /*
  public void saveLenderAPIResponseFile() {
    List<LenderAPIResponse__c> lenderList = [
      SELECT Id, Application_ID__c
      FROM LenderAPIResponse__c
      WHERE Application_ID__c = :this.quoting.PepperAPI_Application_Id__c
    ];

    LenderAPIResponse__c lender;

    if (!lenderList.isEmpty()) {
      lender = lenderList.get(0);
    }

    if (ppAPIManager.pepperAppResponseDTO.docs != null) {
      for (LenderAPIResponse__c l : ppAPIManager.pepperAppResponseDTO.docs) {
        l.LenderAPIResponse__c = lender.Id;
        l.Provider__c = 'Pepper';
        l.Service__c = 'supportingDocuments';
      }

      if (!ppAPIManager.pepperAppResponseDTO.docs.isEmpty()) {
        insert ppAPIManager.pepperAppResponseDTO.docs;
      }
    }
  }
  */
  public void sendApplication() {
    System.debug(apiUser);
    if (submitRequest) {
      try {
        pepperApplication();
      } catch (GenericException e) {
        ApexPages.addMessage(
          new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())
        );
      }
    } else {
      isValidationOk();
      if (rental == null || rental == 0) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please calculate before sending to approval.'
          )
        );
      }
    }
  }

  public void save() {
    submitRequest = false;
    if (isValidationOk()) {
      calculate();
      // validate calculation
      if (rental > 0) {
        //saveQuotingParameters();
        saveProduct(fileGlobalPrefix);
        submitRequest = true;
      }
    }
  }

  public List<PepperRate__c> getPepperRates(String product) {
    return [
      SELECT Tier__c, Rate0__c, Rate1__c, Rate2__c, Rate3__c
      FROM PepperRate__c
      WHERE Product__c = :product
      ORDER BY Name
    ];
  }

  public List<PepperRate__c> getCommercial() {
    return getPepperRates('COMMERCIAL');
  }

  public List<PepperRate__c> getOther2nd3rd() {
    return getPepperRates('OTHER - 2nd & 3rd');
  }

  public List<PepperRate__c> getPrimary() {
    return getPepperRates('OTHER - Primary');
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