public class FirstmacCalculatorExtension extends QuotingExtension {
  //Lelo					2016-09-02
  private String fileGlobalPrefix = 'Firstmac';
  //-

  public QuotingToolHelper qh { get; set; }

  //Lelo                                      2016-12-20
  public static final String LENDER_QUOTING = 'Firstmac';
  //-

  // Lender variables
  public String loanTypeDetail { get; set; }
  // public Decimal brokeragePercentage { get; set; }
  //public String greenCar { get; set; }
  public String homebuyer { get; set; }
  public String category { get; set; }
  public String vehicleYear { get; set; }
  public String interestType { get; set; }

  public static List<String> LOAN_TYPE_OPTIONS = new List<String>{
    'New Green Car',
    'New / Demo',
    'Used < 3 years',
    'Used 4-5 years',
    'Used 6-7 years',
    'Used 8-12 years'
  };

  public static List<String> INTEREST_TYPE_OPTIONS = new List<String>{
    'Fixed',
    'Variable'
  };
  
  public FirstmacCalculatorExtension(ApexPages.StandardController controller) {
    super(
      controller, 
      new Set<String>{
        'Goods_Description__c'
      }
    );
    
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
          'FMAC'.equals(lender.info.Code__c)
        ) {
          this.carPrice = lender.carPrice;
          this.deposit = lender.deposit;
          this.term = lender.term;
          //Lelo                          2017-11-16
          // this.brokeragePercentage = lender.brokerageBase;
          this.loanType = lender.loanType;
          this.loanTypeDetail = lender.loanTypeDetail;
          this.dof = lender.dofBase;
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
    this.baseRateCalc();
    // validation before calculation
    if (this.carPrice == null || this.carPrice == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Car Price cannot be Zero.'
        )
      );
      r = false;
    }
    if (this.applicationFee == null || this.applicationFee == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Application Fee cannot be Zero.'
        )
      );
      r = false;
    }
    if (this.dof == null || this.dof == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, 'DOF cannot be Zero.')
      );
      r = false;
    }
    if (this.clientRate == null || this.clientRate == 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Client Rate cannot be Zero.'
        )
      );
      r = false;
    } else if (this.clientRate < this.baseRate) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Client rate should not be below of base rate: ' +
          this.baseRate +
          '%'
        )
      );
      r = false;
    } else if (this.clientRate > this.maxRate && this.baseRate > 0.0) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Client rate should not be above of max rate: ' +
          this.maxRate +
          '%'
        )
      );
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

    if (String.isBlank(this.category)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select an option for category'
        )
      );
      r = false;
    }

    if (String.isBlank(this.loanTypeDetail)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select an option for Loan Type (Rate Detail)'
        )
      );
      r = false;
    }

    if (residualValue < 0) {
      ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Residual value should be greater than or equal to zero'
          )
        );
        r = false;
    } else {
      if (String.isBlank(interestType)) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please select an option for Interest Type'
          )
        );
        r = false;
      } else if('Variable'.equals(interestType) && residualValue > 0) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Error: Balloon payments not available on variable rate loans'
          )
        );
        r = false;
      }
    }

    if (String.isBlank(this.vehicleYear)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please select an option for Vehicle Year'
        )
      );
      r = false;
    }

    if (!isInsuranceValidationOK()) {
      r = false;
    }
    // //Lelo              2017-09-19
    // if (this.residualValue > 0 && this.term > 60) {
    //   ApexPages.addMessage(
    //     new ApexPages.Message(
    //       ApexPages.Severity.ERROR,
    //       'You cannot have a balloon or residual payment when the loan term is > 5 years.'
    //     )
    //   );
    //   r = false;
    // }
    // Calculate vehicle age
    Integer vy = String.isNotBlank(this.vehicleYear)? Integer.valueOf(this.vehicleYear) : 0;
    Integer cy = Date.today().year();
    Integer va = cy - vy;

    if (this.residualValue > 0 && vy > 0 && 'Fixed'.equals(interestType)) {
      Decimal resPer = this.residualValue / this.carPrice * 100.0;
      Decimal comp = 0.0;

      Boolean isNewUsed = false;
      /*
      if (Opp.Application_AssetDetail__c != null) {
        if (Opp.Application_AssetDetail__r.Condition__c == 'new' 
          || Opp.Application_AssetDetail__r.Condition__c == 'demo'
        ) {
          isNewUsed = true;
        }
      */  
      if (vy == Date.today().year() || vy == Date.today().year() - 1) {
        isNewUsed = true;
      }

      if (
        'New Green Car'.equals(this.loanTypeDetail) ||
        'New / Demo'.equals(this.loanTypeDetail)
      ) {
        //if ('New/Demo'.equals(this.loanTypeDetail) || 'New - 2yrs'.equals(this.loanTypeDetail)) {
        if (this.term == 36) {
          comp = 50.0;
        } else if (this.term == 48) {
          comp = 40.0;
        } else {
          comp = 30.0;
        }
      } else if (
        (
          'Used < 3 years'.equals(this.loanTypeDetail) ||
          'Used 4 - 5 years'.equals(this.loanTypeDetail)
        ) &&
        Date.today().year() - vy <= 4
      ) {
        if (this.term == 36) {
          comp = 40.0;
        } else if (this.term == 48) {
          comp = 30.0;
        } else {
          comp = 20.0;
        }
      } else {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'Maximum balloon is only available for cars less than 4 years'
          )
        );
      }
      if (resPer > comp && comp > 0) {
        comp = this.carPrice * comp / 100.0;
        comp = comp.setScale(2);
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Maximum balloon or residual value should be $' + comp.format()
          )
        );
        r = false;
      }
      //}
    }
    /*
    if (
      'Y'.equals(this.greenCar) &&
      !'New and used < 5 years'.equals(this.loanTypeDetail)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Green Car discount only apply for New cars.'
        )
      );
      r = false;
    }
    */
    // Edge validations
    if (
      'Edge'.equals(this.category) && 
      LOAN_TYPE_OPTIONS.get(LOAN_TYPE_OPTIONS.size()-1).equals(this.loanTypeDetail)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Edge maximum age is 7 years'
        )
      );
      r = false;
    }
    if (
      'Edge'.equals(this.category) && 
      String.isNotBlank(this.vehicleYear) &&
      va > 7
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Edge maximum age is 7 years'
        )
      );
      r = false;
    }

    if (va <= 7 && this.realtimeNaf > 100000) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          '$100,000 maximum NAF for Cars <= 7 years. Max NAF exceeded for age of car'
        )
      );
      r = false;
    }

    if (va > 7 && this.realtimeNaf > 50000) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          '$50,000 maximum NAF for Cars +8 years. Max NAF exceeded for age of car'
        )
      );
      r = false;
    }

    Integer ty = this.term > 0? this.term/12 : 0;
    if ((va + ty) > 15) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'The maximum age of car at term end is 15 years'
        )
      );
    }

    if (('New Green Car'.equals(this.loanTypeDetail) || 
    'New / Demo'.equals(this.loanTypeDetail)) && va >= 1) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          /*
          'Vehicle Year for ' +
          this.loanTypeDetail +
          ' should be ' + cy
          */
          'Error: '+loanTypeDetail+' only available on '+cy+' model cars'
        )
      );
      r = false;
    } else if (
      'Used < 3 years'.equals(this.loanTypeDetail) &&
      va > 3
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year for ' +
          this.loanTypeDetail +
          ' should be between ' + (cy-3) + ' and ' + cy
        )
      );
      r = false;
    } else if (
      'Used 4-5 years'.equals(this.loanTypeDetail) &&
      (va < 4 || va > 5)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year for ' +
          this.loanTypeDetail +
          ' should be between ' + (cy-5) + ' and ' + (cy-4)
        )
      );
      r = false;
    } else if (
      'Used 6-7 years'.equals(this.loanTypeDetail) &&
      (va < 6 || va > 7)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year for ' +
          this.loanTypeDetail +
          ' should be between ' + (cy-7) + ' and ' + (cy-6)
        )
      );
      r = false;
    } else if (
      'Used 8-12 years'.equals(this.loanTypeDetail) &&
      (va < 8 || va > 12) &&
      'Standard'.equals(this.category)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year for ' +
          this.loanTypeDetail +
          ' should be between ' + (cy-12) + ' and ' + (cy-8)
        )
      );
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
    this.applicationFee = lenderSettings.Application_Fee__c;
    this.dof = lenderSettings.DOF__c;
    // this.brokeragePercentage = lenderSettings.Max_Brokerage__c;
    this.baseRate = 0.0;
    this.maxRate = 0.0;
    this.clientRate = null;
    this.term = 60;
    this.paymentType = 'Arrears';
    this.category = null;
    this.homebuyer = 'N';
    this.loanTypeDetail = null;
    //this.greenCar = 'N';
    this.vehicleYear = null;
    //-
    this.resetInsuranceProducts(false);
    this.baseRateCalc();
    this.resetCalculationResult(); //Lelo       2017-07-25
  }

  private PageReference savePdf(String prefixName) {
    // pass parameters to the PDF page
    PageReference calcPdf = this.createPdf();
    // pass universal variables
    calcPdf.getParameters().put('lender', 'FIRSTMAC CALCULATION');

    // Lender parameters
    calcPdf.getParameters().put('customerProfile', this.category);
    calcPdf.getParameters().put('loanTypeDetail', this.loanTypeDetail);
    calcPdf.getParameters().put('residency', this.homebuyer);
    calcPdf.getParameters().put('vehicleYear', this.vehicleYear);
    calcPdf.getParameters().put('interestType', interestType);
    //calcPdf.getParameters().put('greenCar', this.greenCar);
    // calcPdf.getParameters()
    //   .put('brokeragePercentage', String.valueOf(this.brokeragePercentage));

    savePdfInCloud(calcPdf, prefixName);
    return null;
  } // end of function

  private PageReference saveProduct(String prefixName) {
    // validate calculation
    if (!isValidationOk()) {
      return null;
    }

    if (!prefixName.contains('AMENDMENT') && 'Variable'.equals(interestType)) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Please ensure your customer understands this is a variable rate loan'));
    }
    //Recalculate
    calculate();    
    if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
      return null;
    }

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
    updateProduct.Lender__c = LENDER_QUOTING;
    updateProduct.Quoting_Source__c = LENDER_QUOTING;
    updateProduct.Repayment_Regularity__c = 'Monthly';

    updateProduct.Loan_Type__c = this.loanType;
    updateProduct.Loan_Product__c = this.productLoanType;
    updateProduct.Loan_Type_Detail__c = this.loanTypeDetail;

    updateProduct.Loan_Term__c = term > 0 ? term : 0;
    updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
    updateProduct.Client_Rate__c = this.clientRate > 0 ? this.clientRate : 0.00;
    updateProduct.Payments__c = this.monthlyPayment > 0 ? this.monthlyPayment  : 0.00;
    updateProduct.Cost_of_Goods__c = this.carPrice > 0 ? this.carPrice : 0.00;
    updateProduct.Deposit__c = this.netDeposit;
    updateProduct.DOF__c = dof > 0 ? dof : 0.00;
    updateProduct.Brokerage__c = this.estimatedCommission > 0 ? this.estimatedCommission : 0.00;
    updateProduct.Lender_App_Fee__c = this.applicationFee > 0 ? this.applicationFee : 0.00;
    updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0 ? this.ppsr : 0.00;

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
    this.quoting = (d != null) ? d : new Application_Quoting__c();
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
        //Specific values
        this.loadQuotingInsuranceData();
        this.loadQuotingData();
        if (d.Client_Rate__c != null) {
          this.clientRate = d.Client_Rate__c.setScale(2);
        }
        //Loan Details
        this.paymentType = d.Payment__c;
        this.loanTypeDetail = d.Loan_Facility_Type__c;
        // if ('Private Sale'.equals(d.Loan_Facility_Type__c)) {
        //   this.loanTypeDetail = 'Refinance';
        // }
        if (
          String.isNotBlank(d.Vehicle_Age__c) && 
          d.Vehicle_Age__c.isNumeric() &&
          d.Vehicle_Age__c.length() > 2
        ) {
          this.vehicleYear =d.Vehicle_Age__c;
        }
        if (String.isNotBlank(d.Residency__c)) {
          this.homebuyer = d.Residency__c;
        }
        interestType = d.Customer_Profile__c;
        //if (String.isNotBlank(d.Green_Car__c)) {
          //this.greenCar = d.Green_Car__c;
        //}
        if ('Y'.equals(d.Green_Car__c)) {
          loanTypeDetail = 'New Green Car';
        }
        this.category = d.Category_Type__c;
        // this.brokeragePercentage = d.Brokerage__c;
        // if (this.brokeragePercentage == null) {
        //   this.brokeragePercentage = lenderSettings.Max_Brokerage__c;
        // }
      }
    }
    this.baseRateCalc();
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
    d.Category_Type__c = this.category;
    d.Loan_Facility_Type__c = this.loanTypeDetail;
    d.Payment__c = this.paymentType;
    d.Vehicle_Age__c = this.vehicleYear;
    // d.Brokerage__c = this.brokeragePercentage;
    d.Residency__c = this.homebuyer;
    d.Green_Car__c = null;
    d.Customer_Profile__c = interestType;
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
    System.debug(this.baseRate);
    System.debug(param.baseRate);
    // param.brokeragePer = this.brokeragePercentage;
    // param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(quotingType);
    // param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);

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
    param.totalAmount = this.getTotalAmount(QuotingCalculation.CALC_SIMPLE);
    param.totalInsurance = 0;
    param.totalInsuranceIncome = 0;
    // param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(
    //   QuotingCalculation.CALC_SIMPLE
    // );
    // param.amountBaseComm = this.getBaseAmountPmtCalc(
    //   QuotingCalculation.CALC_SIMPLE
    // );

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

    for (String key : calcTypes) {
      param.totalAmount = this.getTotalAmount(quotingType);
      param.totalInsurance = this.getTotalInsuranceType(key);
      param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
      // param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(key);
      // param.amountBaseComm = this.getBaseAmountPmtCalc(key);
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
    
    // param.loanType = this.loanType;
    param.customerProfile = this.category;
    param.residency = this.homebuyer;
    param.loanTypeDetail = this.loanTypeDetail;
    //param.greenCar = this.greenCar;
    param.interestType = interestType;
    this.baseRate = QuotingCalculation.getBaseRate(param);
    this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
  }

  public List<FirstmacRate__c> getRates() {
    List<FirstmacRate__c> r = FirstmacRate__c.getAll().values();
    r.sort();
    return r;
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

  public Decimal getBaseAmountPmtCalc(String calcType) {
    Decimal r = 0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
      if (carPrice != null)
        r +=
          carPrice +
          (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
    } else {
      if (carPrice != null)
        r += carPrice;
    }
    r -= getNetDepositVal();
    return r;
  }

  // public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
  //   Decimal r = getRealtimeNafVal();
  //   if (brokeragePercentage != null && brokeragePercentage != 0) {
  //     r += ((getBaseAmountPmtCalc(calcType) * brokeragePercentage / 100));
  //   }
  //   return r;
  // }

  public static List<SelectOption> getSelectLoanTypeOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    for (String k : LOAN_TYPE_OPTIONS) {
      r.add(new SelectOption(k, k));
    }
    return r;
  }

  public static List<SelectOption> getSelectInterestTypeOptions() {
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('', '--None--'));
    for (String k : INTEREST_TYPE_OPTIONS) {
      r.add(new SelectOption(k, k));
    }
    return r;
  }

  public List<SelectOption> getVehicleYearOptions() {
    return QuotingToolHelper.getVehicleYears(12, false);
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