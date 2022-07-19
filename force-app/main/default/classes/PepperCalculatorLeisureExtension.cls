public class PepperCalculatorLeisureExtension extends QuotingExtension {
  
  //Lelo                  2016-07-26
  private String fileGlobalPrefix = 'Pepper_Leisure';
  //-
  
  public List<SelectOption> tierTypes { get; set; }
  
  // rates references
  public List<PepperLeisure__c> leisureValues { get; set; }
  public List<PepperLeisure__c> tierAValues { get; set; }
  public List<PepperLeisure__c> tierBValues { get; set; }
  public List<PepperLeisure__c> tierCValues { get; set; }

  // variables to show rate reference horizontall
  public List<String> tableValues { get; set; }
  public List<RowWrapper> rowWrappersA { get; set; }
  public List<RowWrapper> rowWrappersB { get; set; }
  public List<RowWrapper> rowWrappersC { get; set; }

  // addtional loan information
  public List<SelectOption> productLoanTypes { get; set; }
  public List<SelectOption> productGoodsTypes { get; set; }

  //Lelo                                      2016-12-20
  public static final String LENDER_QUOTING = 'Pepper Leisure';
  
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

  public Integer vehicleAgeYear = null;
  
  // Leandro                      2018-10-11
  public String vehicleAge { get; set; }
  
  
  public Boolean submitRequest { get; set; }

  public PepperCalculatorLeisureExtension(ApexPages.StandardController controller) {
    super(controller);
    //Pepper API - HJ - I
    String active = System.currentPageReference().getParameters().get('active');
    paramActive = !StringUtils.isNullOrEmpty(active);
    //Pepper API - HJ - F

    //NWC Calculator - HJ - 12-07-2018 - I
    nwcParam = new NWCCalc.Parameter();
    //NWC Calculator - HJ - 12-07-2018 - F

    Map<String, PepperLeisure__c> pepperLeisureValues = PepperLeisure__c.getAll();
    leisureValues = pepperLeisureValues.values();
    leisureValues.sort();
    tierAValues = new List<PepperLeisure__c>();
    tierBValues = new List<PepperLeisure__c>();
    tierCValues = new List<PepperLeisure__c>();
    for (PepperLeisure__c value : leisureValues) {
      if (value.Tier__c == 'A') {
        tierAValues.add(value);
      } else if (value.Tier__c == 'B') {
        tierBValues.add(value);
      } else if (value.Tier__c == 'C') {
        tierCValues.add(value);
      }
    }

    tableValues = new List<String>();
    tableValues.add('Rates');
    tableValues.add('Comms');
    rowWrappersA = new List<RowWrapper>();
    // create a row for each field - there are 2 of these, rates and comms
    for (Integer idx = 0; idx < 2; idx++) {
      rowWrappersA.add(new RowWrapper());
    }
    // iterate the accounts and populate the rows
    for (Integer idx = 0; idx < tierAValues.size(); idx++) {
      rowWrappersA[0].addValue(tierAValues[idx].Rates__c);
      rowWrappersA[1].addValue(tierAValues[idx].Comms__c);
    }
    rowWrappersB = new List<RowWrapper>();
    // create a row for each field - there are 2 of these, rates and comms
    for (Integer idx = 0; idx < 2; idx++) {
      rowWrappersB.add(new RowWrapper());
    }
    // iterate the accounts and populate the rows
    for (Integer idx = 0; idx < tierAValues.size(); idx++) {
      rowWrappersB[0].addValue(tierBValues[idx].Rates__c);
      rowWrappersB[1].addValue(tierBValues[idx].Comms__c);
    }
    rowWrappersC = new List<RowWrapper>();
    // create a row for each field - there are 2 of these, rates and comms
    for (Integer idx = 0; idx < 2; idx++) {
      rowWrappersC.add(new RowWrapper());
    }
    // iterate the accounts and populate the rows
    for (Integer idx = 0; idx < tierAValues.size(); idx++) {
      rowWrappersC[0].addValue(tierCValues[idx].Rates__c);
      rowWrappersC[1].addValue(tierCValues[idx].Comms__c);
    }


    tierTypes = new List<SelectOption>();
    tierTypes.add(new SelectOption('', '--None--'));
    tierTypes.add(new SelectOption('A', 'A'));
    tierTypes.add(new SelectOption('B', 'B'));
    tierTypes.add(new SelectOption('C', 'C'));

    this.productGoodsTypes = new List<SelectOption>();
    productGoodsTypes.add(new SelectOption('', '--None--'));
    productGoodsTypes.add(new SelectOption('Motorbike', 'Motorbike'));
    productGoodsTypes.add(new SelectOption('Boat', 'Boat'));
    productGoodsTypes.add(new SelectOption('Other', 'Other'));

    this.loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
    this.productLoanTypes = QuotingToolHelper.getLoanProductOptionsConsumer();

    this.quotingName = LENDER_QUOTING;
    this.reset();

    //-
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
      List<Custom_Opportunity__c> oppList = [
        SELECT Pre_Quoting_Object__c
        FROM Custom_Opportunity__c
        WHERE ID = :this.Opp.Id
      ];
      System.debug(
        'Preloading values from comparison engine >> ' +
        oppList[0].Pre_Quoting_Object__c
      );
      try {
        LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO) JSON.deserializeStrict(
          oppList[0].Pre_Quoting_Object__c,
          LenderQuotingWrapperDTO.class
        );
        if (
          lender != null &&
          lender.info != null &&
          'PELE'.equals(lender.info.Code__c)
        ) {
          this.carPrice = lender.carPrice;
          this.deposit = lender.deposit;
          this.term = lender.term;
          this.productGoodsType = lender.productGoodsType;
          if (String.isNotBlank(lender.productLoanType)) {
            if (
              lender.productLoanType.containsIgnoreCase('Chattel') &&
              lender.productLoanType.containsIgnoreCase('full')
            ) {
              this.productLoanType = 'Chattel Mortgage-Full-Doc';
            } else if (
              lender.productLoanType.containsIgnoreCase('Chattel') &&
              lender.productLoanType.containsIgnoreCase('low')
            ) {
              this.productLoanType = 'Chattel Mortgage-Low-Doc';
            }
          }
          if (lender.clientTier != null) {
            this.clientTier = lender.clientTier;
          }
          if (lender.vehicleYear != null) {
            this.vehicleAge = lender.vehicleYear;
          }
          //Lelo                          2017-11-16
          this.clientRate = lender.clientRate;
          this.dof = lender.dofBase;
          this.privateSales = lender.privateSales;
          this.baseRateCalc();
          //
        }
      } catch (Exception e) {
        System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
      }
    } else {
      loadQuotingParametersSaved();
    }
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
          'Difference between client Rate and Max Rate cannot be more than 2%, current value: ' +
          Math.abs(this.maxRate - clientRate) +
          '%'
        )
      );
      //r = false;
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
    if (
      'Motorbike'.equals(this.productGoodsType) &&
      String.isBlank(this.productGoodsSubtype)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select a Goods Subtype option'
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

    Decimal maxNaf = 50000;
    if (!'C'.equals(clientTier)) {
      maxNaf = 100000;
    }
    if (
      'Boat'.equals(this.productGoodsType) &&
      'Y'.equals(this.privateSales) &&
      this.realtimeNaf > maxNaf
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Normally max NAF of $'+maxNaf+' for Private sale assets - refer to Pepper'
        )
      );
    }
    
    if (('Boat'.equals(this.productGoodsType) || ('Motorbike'.equals(this.productGoodsType) && ('Off-Road'.equals(productGoodsSubtype) || 'ATV'.equals(productGoodsSubtype))))&& 'C'.equals(this.clientTier)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Error: Leisure (except road bikes) not allowed for Tier C'
        )
      );
      r = false;
    }
    //Yohan Villa                         2019-08-06
    if ('Y'.equals(privateSales)) {
      if (realtimeNaf > maxNaf) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'Private sales max. NAF should be $'+maxNaf
          )
        );
      }
    }
    //

    //NWC Calculator - HJ - 06-08-2018 - I
    if (!isNWCValidationOk) {
      r = false;
    }
    //NWC Calculator - HJ - 06-08-2018 - F

    if ('Refinance'.equals(loanType) && String.isBlank(loanPurpose)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please put a Loan Purpose for this quote. Why is your customer looking at refinancing?'
        )
      );
      r = false;
    }

    if('C'.equals(this.clientTier) && Opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Pepper cannot split expenses with Tier C'));
    }
    return r;
  }

  public PageReference calculate() {
    this.baseRateCalc();
    realtimeNafCalc();
    if (!isValidationOk()) {
      return null;
    }

    this.calculateRepayments();

    if (estimatedCommission <= 0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'The commission is below zero. Please make adjustment to make sure commission is above zero.'
        )
      );
    }
    return null;
  } // end of function

  public void reset() {

    this.resetQuote();

    this.loanType = loanTypeOptions.get(0).getValue();
    this.productGoodsType = productGoodsTypes.get(0).getValue();
    this.productLoanType = productLoanTypes.get(0).getValue();

    this.applicationFee = lenderSettings.Application_Fee__c;
    System.debug('@@this.applicationFee: ' + this.applicationFee);
    this.dof = lenderSettings.DOF__c;
    this.ppsr = lenderSettings.PPSR__c; //Lelo              2016-09-20      //Original value: 6.80 --> 8.9 (2017-12-29) + 3.4
    this.monthlyFee = lenderSettings.Monthly_Fee__c;

    this.netDepositCalc();
    this.term = 60;
    this.clientTier = 'A';
    this.vehicleAge = 'New';
    this.paymentType = 'Arrears';

    this.resetInsuranceProducts(false);
    //-

    this.baseRateCalc();
    this.resetCalculationResult(); //Lelo       2017-07-25
  } // end of function

  private PageReference savePdf(String prefixName) {
    // pass parameters to the PDF page
    PageReference calcPdf = this.createPdf();
    // pass universal variables
    calcPdf.getParameters().put('lender', 'PEPPER LEISURE CALCULATION');

    // Lender parameters
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

    if (!validateVehicleAgeWithYear() && !Test.isRunningTest()) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age does not match with the Vehicle Year in Asset Details page.'));
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

    if (productLoanType == 'Consumer Loan') {
      updateProduct.Loan_Purpose__c = 'Personal Use';
    } else {
      updateProduct.Loan_Purpose__c = 'Business Use';
    }

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
    if (monthlyPayment == null || monthlyPayment == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Payment is not updated as the calculator does not contain relevant info.'));
    }
    if (estimatedCommission == null || estimatedCommission == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission is not updated as the calculator does not contain relevant info.'));
    }
    
    if (applicationFee == null || applicationFee == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee is not updated as the calculator does not contain relevant info.'));
    }
    
    if (ppsr == null || ppsr == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
    }

    //Lelo                      2016-07-26
    if (updateProduct.Id == null) {
      insert updateProduct;
      Opp.Loan_Product__c = updateProduct.Id;
      update this.Opp;
    } else {
      update updateProduct;
    }
    //-

    // Save accepted insurances
    this.saveInsuranceProducts();

    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
    return null;
  } // end of function

  //Lelo                                  2016-07-26
  public PageReference saveQuoting() {
    //Recalculate
    if (
      hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)
    ) {
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
      //--
      this.resetInsuranceProducts(true);

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

        this.productGoodsType = d.Goods_type__c;
        this.productGoodsSubtype = d.Goods_sub_type__c;
        this.loanPurpose = d.Loan_Purpose__c;
        
        //Loan Details
        paymentType = d.Payment__c;
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
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
      if (!sameQuoting) {
        d.PepperAPI_Application_Id__c = null;
        d.PepperAPI_Response_Message__c = null;
        d.PepperAPI_Last_Response_App__c = null;
      }
    }
    this.baseRateCalc();
    this.realtimeNafCalc();
    this.realtimeNafCalc(); // to recaulculate naf including ericLPI
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
    d.Goods_sub_type__c = this.productGoodsSubtype;
    
    //Loan Details
    d.Client_Tier__c = clientTier;
    d.Private_Sales__c = privateSales;
    d.Payment__c = paymentType;
    d.Vehicle_Age__c = this.vehicleAge;
    d.Loan_Purpose__c = this.loanPurpose;

    //Save the record
    QuotingToolHelper.saveApplicationQuoting(d);

    //Save calculations
    QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
  }
  //-

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

  private void calculateRepayments() {
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
    param.baseRate = baseRate;
    param.paymentType = paymentType;
    param.term = term;
    param.dof = dof;
    param.monthlyFee = monthlyFee;
    //param.docFees = docFees;
    param.residualValue = residualValue;
    param.clientTier = this.clientTier;
    param.productLoanType = this.productLoanType;
    param.customerProfile = 'LEISURE';

    if (!'Consumer Loan'.equals(this.productLoanType)) {
      param.commRate = QuotingCalculation.getPepperCommercialCommission(param);
    }

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
    //if (includeInsurance) {
    List<String> calcTypes = new List<String>();
    
    //Insurance one by one
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

    //}
    //-

    //Protected
    quotingType = QuotingCalculation.CALC_PROTECTED;
    param.totalAmount = getTotalAmount(quotingType);
    param.totalInsurance = getTotalInsuranceType(quotingType);
    param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
    System.debug(
      quotingType +
      '|' +
      param.totalAmount +
      '|' +
      param.totalInsurance +
      '|' +
      param.totalInsuranceIncome
    );
    r = QuotingCalculation.calculate(param);
    if (r != null) {
      r.Result_Type__c = quotingType;
    }
    calResults.put(quotingType, r);
  }

  private Application_Quoting_Result__c getCalcResult(String calcType) {
    Application_Quoting_Result__c r = null;
    if (this.calResults != null) {
      r = this.calResults.get(calcType);
    }
    return r;
  }

  public Application_Quoting_Result__c getProtectecResult() {
    return getCalcResult(QuotingCalculation.CALC_PROTECTED);
  }

  //-

  private Boolean hasQuoteValidationOK() {
    Boolean r = true;
    //check for an application
    if (this.opp.Application__c == null) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please link/create an application before quoting.'
        )
      );
      r = false;
    } else {
      if (!'F'.equals(this.opp.Application__r.Status__c)) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please the linked application should be finished.'
          )
        );
        r = false;
      }
    }
    if (this.opp.Application_AssetDetail__c == null) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please save a Asset Detail - LTV before quoting.'
        )
      );
      r = false;
    }
    return r;
  }
  
  //-
  public Boolean getHasCustomerEmailSent() {
    Boolean r = false;
    if (
      this.quoting != null &&
      this.quoting.Presentation_Email_Date__c != null
    ) {
      r = true;
    }
    return r;
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
        PepperAPIManager.Pepper_Leisure
      );
    } catch (GenericException ex) {
      ppAPIManager.isError = true;
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())
      );
      return;
    }
    System.debug('>>>>> Response APPLICATION Pepper  (test)-F  <<<<<< - ');
  }

  public void pepperApplication() {
    if (!hasCalculationDone())
      return;
    System.debug('>>>>> Response APPLICATION Pepper  -I  <<<<<< - ');
    try {
      ppAppService = new PepperApplicationService();
      ppAppService.requestApplication(
        ppAPIManager,
        Opp,
        apiUser,
        PepperAPIManager.Pepper_Leisure
      );
    } catch (GenericException ex) {
      ppAPIManager.isError = true;
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())
      );
    }
    
    if (ppAPIManager.isError && 200 != ppAPIManager.responseStatus) {
      showErrorsPepperAPI();
    } else {
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
        new ApexPages.Message(ApexPages.Severity.WARNING, sError)
      );
    }
    ApexPages.addMessage(
      new ApexPages.Message(ApexPages.Severity.WARNING, '**Errors list**')
    );
    for (String e : errors) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.WARNING, e)
      );
    }
  }

  private void saveAPIInformation() {
    this.quoting.PepperAPI_Application_Id__c = pepperAPI_AppNumber;
    this.quoting.PepperAPI_Response_Message__c = pepperAPI_ResponseContent;
    this.quoting.PepperAPI_Last_Response_App__c = pepperAPI_lastResponseApp;
    update this.quoting;
  }
  //Pepper API - HJ - F

  public void baseRateCalc() {
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      LENDER_QUOTING
    );
    param.productLoanType = this.productLoanType;
    param.customerProfile = 'LEISURE';
    param.clientTier = this.clientTier;
    param.vehicleYear = this.vehicleAge;
    param.term = this.term;
    this.baseRate = QuotingCalculation.getBaseRate(param);
    this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
  }

  public List<PepperRate__c> getPepperRates() {
    return [
      SELECT Tier__c, Rate0__c, Rate1__c, Rate2__c, Rate3__c
      FROM PepperRate__c
      WHERE Product__c = 'LEISURE'
      ORDER BY Name
    ];
  }

  public boolean validateVehicleAgeWithYear() {
    //Custom_Opportunity__c idAppAssetDetails = getIdApplicationAssetDetail(opp);
    //Application_Asset_Detail__c aad = getApplicationAssetDetail(idAppAssetDetails);
    Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(
      this.Opp.Id
    );
    Integer differenceYear;
    if (aad != null) {
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
            'Used 6-9 years'.equals(vehicleAge) &&
            differenceYear >= 6 &&
            differenceYear <= 9
          ) {
            return true;
          } else if (
            'Used 10+ years'.equals(vehicleAge) && differenceYear >= 10
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
            differenceYear <= 2
          ) {
            return true;
          }
        }
      }
    }
    return false;
  }

  public List<SelectOption> getProductGoodsSubtypeOptions() {
    System.debug('Selected productGoodsType: ' + this.productGoodsType);
    List<SelectOption> r = new List<SelectOption>();
    if ('Motorbike'.equals(this.productGoodsType)) {
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('On-Road', 'On-Road'));
      r.add(new SelectOption('Off-Road', 'Off-Road'));
      r.add(new SelectOption('ATV', 'ATV'));
    } else {
      r.add(new SelectOption('', '--N/A--'));
    }
    return r;
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

  public void sendFiles() {
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