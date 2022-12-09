public with sharing class WisrVLCalcExtension  extends QuotingExtension {
  
  //Lelo					2016-09-02
  private String fileGlobalPrefix = 'WisrVL';
  //-
public QuotingToolHelper qh { get; set; }
  //Lelo                                      2016-12-20
  public static final String LENDER_QUOTING = 'Wisr VL';
  //-

  // Lender variables
  public Integer vehicleYear { get; set; }
  public String profile { get; set; }
  public Integer creditscore { get; set; }
  public Decimal privateSaleFee { get; set; }
  public Integer lvr { get; set; }
  public Decimal maxAppFee { get; set; }
  public Boolean dofManualInput { get; set; }
  public Boolean appFeeManualInput { get; set; }

  public WisrVLCalcExtension(ApexPages.StandardController controller) {
    super(controller);

    qh = new QuotingToolHelper();

    this.quotingName = LENDER_QUOTING;
    this.reset();

    preLoadQuotingValues();

    //NWC Calculator - HJ - 12-07-2018 - I
    loadNWCParameters();
    //NWC Calculator - HJ - 12-07-2018 - F
  }

  private void preLoadQuotingValues() {
    loadQuotingParametersSaved();
  }

  public Boolean isValidationOk() {
    Boolean r = true;
    this.baseRateCalc();
    // validation before calculation
    if (this.carPrice == null || this.carPrice == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Price cannot be Zero.'
        )
      );
      r = false;
    } else {
      // Decimal vp = this.carPrice - this.getNetDepositVal();
      Decimal vp = this.realtimeNaf;
      if (vp < 5000 || vp > 80000) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'Loan amount should be between $5,000 and $80,000.'
          )
        );
      }
    }

    if (this.applicationFee == null || this.applicationFee == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Application Fee should not be Zero.'
        )
      );
      r = false;
    } else if (this.maxAppFee > 0 && this.applicationFee < this.maxAppFee) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Application Fee below maximum available.'
        )
      );
    } else if (this.maxAppFee > 0 && this.applicationFee > this.maxAppFee) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Application Fee above maximum available'
        )
      );
    }
    if (this.dof == null || this.dof == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'DOF should not be Zero.'
        )
      );
      r = false;
    } else if (this.maxDof > 0 && this.dof < this.maxDof) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF below maximum available.'));
    } else if (this.maxDof > 0 && this.dof > this.maxDof) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'DOF above maximum available.'
        )
      );
    }

    if (this.clientRate == null || this.clientRate == 0.0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate should not be Zero.'));
      r = false;
    } else if (this.clientRate < this.baseRate) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate should not be below of base rate: ' + this.baseRate + '%'));
      r = false;
    } else if (this.clientRate > this.maxRate && this.baseRate > 0.0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate should not be above of max rate: ' + this.maxRate + '%'));
      r = false;
    }
    if (this.term == null || this.term == 0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please choose an appropriate term.'
        )
      );
      r = false;
    } else {
      if (this.term == 84 && this.creditscore < 640) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            '7 year terms only for scores >= 640'
          )
        );
      }
      // Integer years = Date.today().year() - this.vehicleYear;
      // years += (this.term / 12);
      // if (years > 15) {
      //   ApexPages.addMessage(
      //     new ApexPages.Message(
      //       ApexPages.Severity.ERROR,
      //       'Vehicle over 15 years at end of the loan term, (current ' + years + ' yrs)'
      //     )
      //   );
      //   r = false;
      // }
      // if (this.term == 84 && this.vehicleYear < Date.today().year()-4) {
      //   ApexPages.addMessage(
      //     new ApexPages.Message(
      //       ApexPages.Severity.ERROR,
      //       'Max term 5 years for cars > 4 years old'
      //     )
      //   );
      //   r = false;
      // }
    }
    if (this.getRealtimeNafVal() < 5000) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Min NAF should be $5,000.'
        )
      );
      r = false;
    }
    if (this.getRealtimeNafVal() > 80000) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'Max NAF with WISR $80,000'
        )
      );
    }
    if (this.creditscore == null || this.creditscore < 450) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Credit score should be >= 450'
        )
      );
      r = false;
    }

    if (this.vehicleYear == null || this.vehicleYear == 0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year is required'
        )
      );
      r = false;
    } else {
      Integer a =
        Date.today().year() -
        this.vehicleYear +
        this.getTermYears().intValue();
      if (a > 15) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Vehicle can not be older than 15 years at term end, (current ' +
            a +
            ' years)'
          )
        );
        r = false;
      }
    }
    if (this.lvr == null || this.lvr == 0) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, 'LVR is required')
      );
      r = false;
    } else if (this.lvr > 150) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Max LVR should be 150%'
        )
      );
      r = false;
    }

    if (!isInsuranceValidationOK()) {
      r = false;
    }

    return r;
  }

  public void calculate() {
    if (isValidationOk()) {
      this.calculateRepayments();
    }
  }

  public void reset() {
    this.resetQuote();
    this.loanType = 'Purchase';
    this.productLoanType = 'Consumer Loan';
    //Initial values
    this.monthlyFee = lenderSettings.Monthly_Fee__c;
    this.ppsr = lenderSettings.PPSR__c;
    this.privateSaleFee = lenderSettings.Private_Sale_Fee__c;
    this.dof = null;
    
    this.term = 60;
    this.creditscore = null;
    this.paymentType = 'Arrears';
    this.vehicleYear = null;
    this.lvr = null;
    this.dofManualInput = false;
    this.appFeeManualInput = false;

    this.resetInsuranceProducts(false);

    this.baseRateCalc();
    this.resetCalculationResult(); //Lelo       2017-07-25
    this.calculateFees();

  }

  private PageReference savePdf(String prefixName) {
    // pass parameters to the PDF page
    PageReference calcPdf = this.createPdf();
    // pass universal variables
    calcPdf.getParameters().put('lender', 'WISR CAR LOAN CALCULATION');

    // Lender parameters
    calcPdf.getParameters().put('privateSales', this.privateSales);
    calcPdf.getParameters().put('registrationFee', '0.00');
    if ('Y'.equals(this.privateSales)) {
      calcPdf.getParameters()
        .put('registrationFee', this.privateSaleFee.format());
    }
    calcPdf.getParameters().put('lvr', String.valueOf(this.lvr));
    calcPdf.getParameters().put('residualValue', '0.00');
    calcPdf.getParameters().put('vehicleYear', String.valueOf(this.vehicleYear));
    calcPdf.getParameters().put('customerProfile', this.profile);
    calcPdf.getParameters().put('creditScore', String.valueOf(this.creditScore));

    savePdfInCloud(calcPdf, prefixName);
    return null;
  } // end of function

  private PageReference saveProduct(String prefixName) {
    //Recalculate
    if (!isValidationOk()) {
      return null;
    }
    calculate();

    if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
      return null;
    }

    isValidAssetDetails();
    // this function will update the product no matter what the existing data stored in Product
    // If there isn't product existing, it will create a new product
    // The current mechanism is that opportunity cannot be created without product
    // so far only override the product, later we may not require product and use this function to create the product

    //Storing quoting data
    saveQuotingParameters();

    //Lelo 									2016-07-26
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
          Quoting_Source__c,
          Loan_Type_Detail__c,
          Loan_Product__c
        FROM Product__c
        WHERE id = :Opp.Loan_Product__c
      ];
    }
    //-

    updateProduct.Loan_Purpose__c = 'Personal Use';
    updateProduct.Lender__c = 'Wisr';
    updateProduct.Quoting_Source__c = LENDER_QUOTING;
    updateProduct.Repayment_Regularity__c = 'Monthly';

    updateProduct.Loan_Type__c = this.loanType;
    updateProduct.Loan_Product__c = this.productLoanType;

    updateProduct.Loan_Term__c = this.term > 0? this.term : 0;
    updateProduct.Balloon_Residual_Requested__c = 0.00;
    updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
    updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
    updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
    updateProduct.Deposit__c = this.netDeposit;
    updateProduct.DOF__c = this.dof > 0? this.dof : 0.00;
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

  //Lelo									2016-07-26
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

  //Lelo                                  2016-12-22
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
      this.loanType = d.Loan_Type__c;
      this.productLoanType = d.Loan_Product__c;
      this.carPrice = d.Vehicle_Price__c;
      this.deposit = d.Deposit__c;
      this.tradeIn = d.Trade_In__c;
      this.payoutOn = d.Payout_On__c;
      this.residualValue = 0.0;
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
        if (
          String.isNotBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()
        ) {
          this.vehicleYear = Integer.valueOf(d.Vehicle_Age__c);
        }
        if (
          String.isNotBlank(d.Credit_Score__c) && d.Credit_Score__c.isNumeric()
        ) {
          this.creditscore = Integer.valueOf(d.Credit_Score__c);
        }
        this.profile = d.Customer_Profile__c;
        if (String.isNotBlank(d.LTV__c) && d.LTV__c.isNumeric()) {
          this.lvr = Integer.valueOf(d.LTV__c);
        }
        this.privateSales = d.Private_Sales__c;
        this.appFeeManualInput = d.App_Fee_Manual_Input__c;
        this.dofManualInput = d.DOF_Manual_Input__c;

        this.baseRateCalc();

      }
      //realtimeNafCalc();
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
    }
    this.baseRateCalc();
    this.calculateFees();
    if (sameQuoting) {
      try {
        this.calculateRepayments();
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
    Application_Quoting__c d = new Application_Quoting__c();
    if (this.quoting != null) {
      this.updateQuotingData();
      d = this.quoting;
    }

    //Loan Details
    d.Payment__c = this.paymentType;
    d.Vehicle_Age__c = String.valueOf(this.vehicleYear);
    d.Credit_Score__c = null;
    if (this.creditscore != null) {
      d.Credit_Score__c = String.valueof(this.creditscore);
    }
    d.Customer_Profile__c = this.profile;
    d.LTV__c = null;
    if (this.lvr != null) {
      d.LTV__c = String.valueOf(this.lvr);
    }
    d.Private_Sales__c = this.privateSales;
    d.Registration_Fee__c = null;
    if ('Y'.equals(this.privateSales)) {
      d.Registration_Fee__c = this.privateSaleFee;
    }
    d.App_Fee_Manual_Input__c = this.appFeeManualInput;
    d.DOF_Manual_Input__c = this.dofManualInput;

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

  //Lelo                      2017-07-24
  private void calculateRepayments() {
    //Reset results
    this.resetCalculationResult();
    this.baseRateCalc();

    //FULL CALCULATION
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      LENDER_QUOTING
    );
    String quotingType = QuotingCalculation.CALC_QUOTING;
    param.totalAmount = this.getTotalAmount(quotingType);
    param.totalInsurance = this.getTotalInsuranceType(quotingType);
    param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(quotingType);
    param.baseRate = this.baseRate;
    param.maxRate = this.maxRate;
    param.clientRate = this.clientRate;
    param.paymentType = this.paymentType;
    param.term = this.term;
    param.dof = this.dof;
    param.monthlyFee = this.monthlyFee;
    param.residualValue = this.residualValue;
    param.commRate = 4.0;
    if (this.creditscore >= 850 || this.term == 36) {
      param.commRate = 3.0;
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
    param.totalAmount = this.getTotalAmount(QuotingCalculation.CALC_SIMPLE);
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

    for (String key : calcTypes) {
      param.totalAmount = this.getTotalAmount(quotingType);
      param.totalInsurance = this.getTotalInsuranceType(key);
      param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
      System.debug(
        key +
        '|' +
        param.totalAmount +
        '|' +
        param.totalInsurance +
        '|' +
        param.totalInsuranceIncome +
        '|' +
        param.amountBasePmt +
        '|' +
        param.amountBaseComm
      );
      r = QuotingCalculation.calculate(param);
      if (r != null) {
        r.Result_Type__c = key;
      }
      calResults.put(key, r);
    }

  }

  public void baseRateCalc() {
    this.baseRateCalc(QuotingCalculation.CALC_QUOTING);
  }

  private void baseRateCalc(String calcType) {
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      LENDER_QUOTING
    );
    param.vehicleYear = String.valueOf(this.vehicleYear);
    param.customerProfile = this.profile;
    param.vedascore = this.creditscore;
    param.term = this.term;
    if (this.lvr != null) {
      param.ltv = String.valueOf(this.lvr);
    }
    this.baseRate = QuotingCalculation.getBaseRate(param);
    this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
  }

  public List<WisrVL_Rates__c> getRates() {
    List<WisrVL_Rates__c> r = [
      SELECT
        Id,
        Profile__c,
        Credit_Score_Start__c,
        Credit_Score_End__c,
        Rate_1__c,
        Rate_2__c,
        Rate_3__c,
        Rate_4__c,
        Comparison_Rate__c
      FROM WisrVL_Rates__c
      ORDER BY Profile__c DESC, Credit_Score_Start__c DESC
    ];
    return r;
  }

  public List<SelectOption> getVehicleYearOptions() {
    return QuotingToolHelper.getVehicleYears(12);
  }

  public List<SelectOption> getProfileOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    List<AggregateResult> d = [
      SELECT Profile__c
      FROM WisrVL_Rates__c
      GROUP BY Profile__c
      ORDER BY Profile__c DESC
    ];
    for (AggregateResult a : d) {
      r.add(
        new SelectOption(
          (String) a.get('Profile__c'),
          (String) a.get('Profile__c')
        )
      );
    }
    return r;
  }

  public void isValidAssetDetails() {
    Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(
      this.Opp.Id
    );
    if (aad != null) {
      // Year
      if (aad.Year__c != null && this.vehicleYear != null) {
        Integer aadYear = aad.Year__c.intValue();
        if (aadYear != this.vehicleYear) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING,
              'Vehicle Year does not match with the Vehicle Year in Asset Details / Application form page.'
            )
          );
        }
      }
      // LTV
      if (aad.LVR__c != null) {
        if (this.lvr != aad.LVR__c.intValue()) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING,
              'Warning LVR does not match Asset details - amend to obtain correct rate, Asset Details - LTV (' +
              aad.LVR__c +
              '%)'
            )
          );
        }
      }
    }
  }

  public void calculateFees(boolean processAppFee, boolean processDof) {
    Decimal tmpMaxAppFee = this.maxAppFee;
    Decimal tmpMaxDof = this.maxDof;
    this.maxAppFee = 0.0;
    this.maxDof = QuotingCalculation.getWisrVLMaxDOF(this.getBaseAmountForDOF());
    this.maxAppFee = QuotingCalculation.getWisrVLMaxAppFee(this.getRealtimeNafVal());

    // this.maxDof = 0.0;
    // if (this.getBaseAmountForDOF() >= 50000) {
    //   this.maxDof = 1990.0;
    // } else if (this.getBaseAmountForDOF() >= 40000) {
    //   this.maxDof = 1500.0;
    // } else if (this.getBaseAmountForDOF() >= 30000) {
    //   this.maxDof = 1250.0;
    // } else if (this.getBaseAmountForDOF() >= 20000) {
    //   this.maxDof = 990.0;
    // } else if (this.getBaseAmountForDOF() >= 10000) {
    //   this.maxDof = 900.0;
    // } else if (this.getBaseAmountForDOF() >= 7500) {
    //   this.maxDof = 750.0;
    // } else if (this.getBaseAmountForDOF() >= 5000) {
    //   this.maxDof = 500.0;
    // }
    
    // if (this.getRealtimeNafVal() < 10000) {
    //   this.maxAppFee = 495.0;
    // } else if (this.getRealtimeNafVal() < 20000) {
    //   this.maxAppFee = 520.0;
    // } else if (this.getRealtimeNafVal() < 25000) {
    //   this.maxAppFee = 555.0;
    // } else if (this.getRealtimeNafVal() < 30000) {
    //   this.maxAppFee = 575.0;
    // } else if (this.getRealtimeNafVal() < 35000) {
    //   this.maxAppFee = 630.0;
    // } else if (this.getRealtimeNafVal() < 40000) {
    //   this.maxAppFee = 735.0;
    // } else if (this.getRealtimeNafVal() < 45000) {
    //   this.maxAppFee = 840.0;
    // } else if (this.getRealtimeNafVal() < 50000) {
    //   this.maxAppFee = 945.0;
    // } else {
    //   this.maxAppFee = 990.0;
    // }


    if (processAppFee && !this.appFeeManualInput) {
      this.applicationFee = this.maxAppFee;
    }
    if (processDof && !this.dofManualInput) {
      this.dof = this.maxDof;
    }
  }

  public void calculateFees() {
    calculateFees(true, true);
  }

  public void appFeeOnChange() {
    if (this.applicationFee == 0) {
      this.appFeeManualInput = false;
    } else {
      this.appFeeManualInput = true;
    }
    calculateFees(true, false);
  }

  public void dofOnChange() {
    System.debug('dofOnChange >> ' + this.dof + ' [' + this.dofManualInput + ']');
    if (this.dof == null || this.dof == 0) {
      this.dofManualInput = false;
    } else {
      this.dofManualInput = true;
    }
    calculateFees(false, true);
  }

  public List<SelectOption> getClientRateoptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    Set<Decimal> vals = getClientRateValues();
    if (this.baseRate > 0 && vals.size() > 0) {
      for (Decimal v : vals) {
        // r.add(new SelectOption(String.valueOf(v), v.setScale(2).format()));
        r.add(new SelectOption(String.valueOf(v), String.valueOf(v)));
      }
    }
    return r;
  }

  public Set<Decimal> getClientRateValues() {
    Set<Decimal> vals = new Set<Decimal>();
    if (this.baseRate > 0) {
      for (Decimal i = this.baseRate; i <= this.maxRate;) {
        vals.add(i);
        i += 0.25;
      }
    }
    return vals;
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

  public override Decimal getTotalAmount(String calcType) {
    Decimal r = super.getTotalAmount(calcType);
    r += (
      ('Y'.equals(this.privateSales) || 'Refinance'.equals(this.loanType)) && (this.privateSaleFee > 0.00)
    ) ? this.privateSaleFee : 0.00;    
    return r;
  }

  public Decimal getBaseAmountForDOF() {
    Decimal r = 0.0;
    r += (this.carPrice != null? this.carPrice : 0);
    r -= getNetDepositVal();
    return r;
  }
  
  public Decimal getTermYears() {
    return (
      (this.term == null) ? 0.00 : this.term / 12
    );
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