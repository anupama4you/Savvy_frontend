public abstract class QuotingExtensionAbstract {

  public Custom_Opportunity__c Opp {get; set;}
  public Application_Quoting__c quoting {get; set;}
  public Application_InsuranceQuote__c quote { get; set; }
  public Map<String, Application_Quoting_Result__c> calResults;
  public String quotingName {set; get;}
  
  public Boolean presentationFinished {
    get {
      return (
        this.quote != null &&
        InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(
          this.quote.Customer_Choice_Status__c)
      );
    }
    set;
  }

  public Boolean isInsProdReadonly {
    get {
      return (
        this.quoting != null && this.quote != null && 
        String.isNotBlank(this.quote.Customer_Choice_Status__c)
      );
    }
    set;
  }

  public Boolean hasCustomerEmailSent {
    get {
      return (
        this.quoting != null &&
        this.quoting.Presentation_Email_Date__c != null
      );
    }
    set;
  }

  // Quote type
  public String loanType { get; set; }
  public List<SelectOption> loanTypeOptions { 
    get {
      return QuotingToolHelper.getLoanTypeOptions();
    }
    set; 
  }
  public String productLoanType { get; set; }
  public String productGoodsType { get; set; }
  public String productGoodsSubtype { get; set; }

  // Basic quote variables
  public Decimal carPrice { get; set; }
  public Decimal deposit { get; set; }
  public Decimal tradeIn { get; set; }
  public Decimal payoutOn { get; set; }
  public Decimal netDeposit { get; set; }
  public Decimal applicationFee { get; set; }
  public Decimal dof { get; set; }
  public Decimal maxDof { get; set; }
  public Decimal ppsr { get; set; }
  public Decimal residualValue { get; set; }
  public Decimal monthlyFee { get; set; }
  public Integer term { get; set; }

  public Decimal clientRate { get; set; }
  public Decimal baseRate { get; set; }
  public Decimal maxRate { get; set; }
  
  // finance calculator output
  public Decimal estimatedCommission { get; set; }
  public Decimal insuranceIncome { get; set; }
  public Decimal dofResult { get; set; }
  public Decimal totalCommission { get; set; }
  public Decimal totalCommissionGst { get; set; }

  public Decimal realtimeNaf { get; set; }
  public Decimal naf { get; set; }
  public Decimal rental { get; set; }
  public Decimal monthlyPayment { get; set; }
  public Decimal fortnightlyPayment { get; set; }
  public Decimal weeklyPayment { get; set; }

  public String clientTier { get; set; }
  public String paymentType { get; set; }
  public List<SelectOption> paymentTypes { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Arrears', 'Arrears'));
      r.add(new SelectOption('Advance', 'Advance'));
      return r;
    } 
    set; 
  }
  public String privateSales { get; set; }
  public List<SelectOption> yesNoOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Y', 'Yes'));
      r.add(new SelectOption('N', 'No'));
      return r;
    }
    set; 
  }
  public String loanPurpose { get; set; }

  // Insurance Variables
  public String mvLevel { get; set; }
  public Decimal mv { get; set; }
  public Decimal mvIncome { get; set; }
  public String mvAcceptance { get; set; }
  public Boolean mvEditActive {
    get {
      return (
        !isInsProdReadonly && 'U'.equals(this.mvAcceptance)
      );
    }
    set;
  }

  public String gapLevel { get; set; }
  public Decimal gap { get; set; }
  public Decimal gapIncome { get; set; }
  public String gapPayType { get; set; }    // Financed or PBM
  public String gapTerm {set;get;}
  public String gapAcceptance { get; set; }
  public Boolean gapEditActive {
    get {
      return (
        !isInsProdReadonly && 'U'.equals(this.gapAcceptance)
      );
    }
    set;
  }
  public List<SelectOption> gapPayTypeOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Financed', 'Financed'));
      r.add(new SelectOption('PBM', 'PBM'));
      return r;
    } 
    set; 
  }
  
  public String cciLevel {get;set;}
  public Decimal cci { get; set; }
  public Decimal cciIncome { get; set; }
  public String cciPayType { get; set; }
  public String cciTerm {set;get;}
  public String cciAcceptance { get; set; }
  public Boolean cciEditActive {
    get {
      return (
        !isInsProdReadonly && 'U'.equals(this.cciAcceptance)
      );
    }
    set;
  }
  public List<SelectOption> cciPayTypeOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Financed', 'Financed'));
      r.add(new SelectOption('PBM', 'PBM'));
      return r;
    } 
    set; 
  }
  public List<SelectOption> cciTermOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--')); 
      r.add(new SelectOption('12', '12'));
      r.add(new SelectOption('24', '24'));
      r.add(new SelectOption('36', '36'));
      return r;
    } 
    set; 
  }

  public String warrantyLevel { get; set; }
  public Decimal warranty { get; set; }
  public Decimal warrantyIncome { get; set; }
  public String warrantyPayType { get; set; }
  public String warrantyTerm {set;get;}
  public String warrantyAcceptance { get; set; }
  public Boolean warrantyEditActive {
    get {
      return (
        !isInsProdReadonly && 'U'.equals(this.warrantyAcceptance)
      );
    }
    set;
  }
  public List<SelectOption> warrantyPayTypeOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Financed', 'Financed'));
      r.add(new SelectOption('PBM', 'PBM'));
      return r;
    } 
    set; 
  }

  // Integrity
  public Decimal nwc { get; set; }
  public Decimal nwcIncome { get; set; }
  public String nwcPayType { get; set; }
  public String nwcPlan { get; set; }
  public String nwcTerm { get; set; }
  public Decimal nwcCost { get; set; }
  public String nwcAcceptance { get; set; }
  public Boolean nwcEditActive {
    get {
      return (
        !isInsProdReadonly && 'U'.equals(this.nwcAcceptance)
      );
    }
    set;
  }
  public List<SelectOption> nwcPayTypeOptions { 
    get {
      List<SelectOption> r = new List<SelectOption>();
      r.add(new SelectOption('', '--None--'));
      r.add(new SelectOption('Financed', 'Financed'));
      r.add(new SelectOption('PBM', 'PBM'));
      return r;
    } 
    set; 
  }

  public NWCCalc.Parameter nwcParam { get; set; }
  public String NWCMessage { get; set; }
  public String messageNWCWarning { get; set; }
  public Boolean isAssetCar { get; set; }
  public Boolean isAssetBoat { get; set; }
  public Boolean isCategoryType { get; set; }
  public Boolean isNWCValidationOk { get; set; }
  public Decimal priceCustomer = null;

  public List<SelectOption> NWCPlanOptions { get; set; }
  public List<SelectOption> NWCTermOptions { get; set; }
  public List<SelectOption> NWCTypePOptions { get; set; }
  // -
  
  public String twLevel { get; set; }
  public Decimal tw { get; set; }
  public Decimal twIncome { get; set; }
  public String twTerm {set;get;}
  public String twAcceptance { get; set; }

  public Lenders__c lenderSettings {set;get;}
  public Boolean isOnlyPayByTheMonth {
    get {
      return (
        this.lenderSettings != null &&
        InsuranceQuoteUtils.INS_ONLYPAYBYTHEMONTH.equals(this.lenderSettings.InsPayTypeOptions__c)
      );
    }
    set;
  }

  public QuotingExtensionAbstract quotingExt {
      get {
          return this;
      }
  }
  public Boolean openPreviewPresentation {set;get;}
  public Boolean skipIntegrityPayType {set; get;}
  public Boolean skipGAPPayType {set; get;}
  public Boolean skipVEIPayType {set; get;}
  public Boolean skipWarrantyPayType {set; get;}

  public QuotingExtensionAbstract() {
    System.debug('Creating QuotingExtension...');
    this.quoting = new Application_Quoting__c();
    
    this.gapPayType = null;
    this.cciPayType = null;
    this.warrantyPayType = null;
    this.nwcPayType = 'Financed';

  }
  public QuotingExtensionAbstract(ApexPages.StandardController controller) {
    this(controller, null);
  }

  public QuotingExtensionAbstract(
    ApexPages.StandardController controller, 
    Set<String> extraFields
  ) {
    this();
    System.debug('Creating QuotingExtensionAbstract controller...');
    Set<String> fields = new Set<String>{
      'First_Name__c', 
      'Last_Name__c',
      'Email_Address__c',
      'Application__c',
      'Application__r.Date_of_Birth_1__c',
      'Application__r.Marital_Status_1__c',
      'Application__r.No_of_Dependants_1__c',
      'Application__r.No_of_People__c',
      'Application__r.State__c',
      'Application__r.Type_of_Asset__c',
      'OwnerId'
    };
    if (extraFields != null && !extraFields.isEmpty()) {
      fields.addAll(extraFields);
    }
    if (!Test.isRunningTest()) controller.addFields(new List<String>(fields));
    
    this.Opp = (Custom_Opportunity__c) controller.getRecord();

  }

  public void resetQuote() {
    this.lenderSettings = QuotingCalculation.getLenderSettings(this.quotingName);
    this.loanType = loanTypeOptions.get(0).getValue();
    this.productLoanType = null;
    this.productGoodsType = null;
    this.productGoodsSubtype = null;

    this.carPrice = null;
    this.deposit = null;
    this.tradeIn = null;
    this.payoutOn = null;
    this.netDeposit = null;
    this.applicationFee = null;
    this.dof = null;
    this.maxDof = null;
    this.ppsr = null;
    this.residualValue = null;
    this.monthlyFee = null;
    this.term = null;

    this.clientRate = null;
    this.baseRate = null;
    this.maxRate = null;

    // other parameters
    this.clientTier = null;
    this.paymentType = null;
    this.privateSales = null;
    this.loanPurpose = null;
    
    this.quote = new Application_InsuranceQuote__c();

    // Results
    this.resetCalculationResult();

  }

  public void resetCalculationResult() {
    this.estimatedCommission = null;
    this.insuranceIncome = null;
    this.dofResult = null;
    this.totalCommission = null;
    this.totalCommissionGst = null;

    this.naf = null;
    this.rental = 0.00;
    this.monthlyPayment = null;
    this.fortnightlyPayment = null;
    this.weeklyPayment = null;

    this.calResults = new Map<String, Application_Quoting_Result__c>();
  }

  public void resetInsuranceAcceptance() {
    this.mvAcceptance = 'U';
    this.gapAcceptance = 'U';
    this.cciAcceptance = 'U';
    this.warrantyAcceptance = 'U';
    this.nwcAcceptance = 'U';
  }

  public void resetInsuranceProducts(Boolean skipQuoting) {

    if (!skipQuoting) {
      this.quoting.Insurance_MV_Options__c = null;
      this.quoting.Insurance_Shortfall_Options__c = null;
      this.quoting.Insurance_LPI_Options__c = null;
      this.quoting.Insurance_Warranty_Options__c = null;
    }

    this.mvLevel = null;
    this.mv = null;
    this.mvIncome = null;
    this.mvAcceptance = 'U';

    this.gapLevel = null;
    this.gap = null;
    this.gapIncome = null;
    this.gapPayType = this.isOnlyPayByTheMonth? 'PBM' : null;
    this.gapTerm = '12';
    this.gapAcceptance = 'U';

    this.cciLevel = null;
    this.cci = null;
    this.cciIncome = null;
    this.cciPayType = this.isOnlyPayByTheMonth? 'PBM' : null;
    this.cciTerm = null;
    this.cciAcceptance = 'U';

    this.warrantyLevel = null;
    this.warranty = null;
    this.warrantyIncome = null;
    this.warrantyPayType = this.isOnlyPayByTheMonth? 'PBM' : null;
    this.warrantyTerm = '12';
    this.warrantyAcceptance = 'U';

    this.twLevel = null;
    this.tw = null;
    this.twIncome = null;
    // this.twPayByMonth = this.isOnlyPayByTheMonth;
    this.twTerm = null;
    this.twAcceptance = 'U';

    this.nwc = null;
    this.nwcIncome = null;
    this.nwcPlan = null;
    this.nwcTerm = null;
    this.nwcCost = null;
    this.nwcPayType = 'Financed';
    this.nwcAcceptance = 'U';
    this.nwcParam = new NWCCalc.Parameter();
    this.skipIntegrityPayType = false;
    this.skipGAPPayType = false;
    this.skipVEIPayType = false;
    this.skipWarrantyPayType = false;
    this.reCreateQuote(skipQuoting);
  }

  // Standard calculations
  public void netDepositCalc() {
    this.netDeposit = 0;
    this.netDeposit += (this.deposit != null)? this.deposit : 0;
    this.netDeposit += (this.tradeIn != null)? this.tradeIn : 0;
    this.netDeposit -= (this.payoutOn != null)? this.payoutOn : 0;
  }

  public virtual void realtimeNafCalc() {
    this.netDepositCalc();
    this.realtimeNaf = 0;
    this.realtimeNaf += getTotalAmount(QuotingCalculation.CALC_QUOTING);
    this.realtimeNaf += getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
    this.calculateLPI();
  } //end of funcion

  public Decimal getRealtimeNafVal() {
    this.realtimeNafCalc();
    return this.realtimeNaf;
  }

  public Decimal getNetDepositVal() {
    this.netDepositCalc();
    return this.netDeposit;
  }

  public virtual Decimal getTotalAmount(String calcType) {
    this.netDepositCalc();
    Decimal r = 0.0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
      if (this.carPrice != null)
        r += this.carPrice +
          (this.carPrice * QuotingCalculation.getProtectedPercentaje(this.carPrice));
    } else {
      r += (this.carPrice != null)? this.carPrice : 0;
    }
    r += (this.applicationFee != null)? this.applicationFee : 0;
    r += (this.dof != null)? this.dof : 0;
    r += (this.ppsr != null)? this.ppsr : 0;
    r -= this.netDeposit;
    return r;
  }

  public Decimal getTotalInsuranceType(String calcType) {
    Decimal r = 0.0;
    if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
      // Shortfall / GAP
      if ('A'.equals(this.gapAcceptance) && 'Financed'.equals(this.gapPayType)) {
        r += (this.gap > 0)? this.gap : 0.0;
      }
      // Warranty
      if ('A'.equals(this.warrantyAcceptance) && 'Financed'.equals(this.warrantyPayType)) {
        r += (this.warranty > 0)? this.warranty : 0.0;
      }
      //NWC
      if ('A'.equals(this.nwcAcceptance) && 'Financed'.equals(this.nwcPayType)) {
        r += (this.nwc > 0)? this.nwc : 0.0;
      }
      // LPI
      if ('A'.equals(this.cciAcceptance) && 'Financed'.equals(this.cciPayType)) {
        r += (this.cci > 0)? this.cci : 0.0;
      }
      //-
    } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gap > 0)? this.gap : 0.0;
      // Warranty
      r += (this.warranty > 0)? this.warranty : 0.0;
      //NWC
      r += (this.nwc > 0)? this.nwc : 0.0;
      // LPI      
      r += (this.cci > 0)? this.cci : 0.0;
      //-
    } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gap > 0)? this.gap : 0.0;
      // Warranty
      r += (this.warranty > 0)? this.warranty : 0.0;
      //NWC
      r += (this.nwc > 0)? this.nwc : 0.0;
      //-
    } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gap > 0)? this.gap : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gap > 0)? this.gap : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
      // Warranty
      r += (this.warranty > 0)? this.warranty : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
      r += (this.nwc > 0)? this.nwc : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
      r += (this.cci > 0)? this.cci : 0.0;
    }
    return r;
  }

  public Decimal getTotalInsuranceIncomeType(String calcType) {
    Decimal r = 0.0;
    if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
      // Shortfall / GAP
      if ('A'.equals(this.gapAcceptance)) {
        r += (this.gapIncome > 0)? this.gapIncome : 0.0;
      }
      // Warranty
      if ('A'.equals(this.warrantyAcceptance)) {
        r += (this.warrantyIncome > 0)? this.warrantyIncome : 0.0;
      }
      //NWC
      if ('A'.equals(this.nwcAcceptance)) {
        r += (this.nwcIncome > 0)? this.nwcIncome : 0.0;
      }
      // LPI
      if ('A'.equals(this.cciAcceptance)) {
        r += (this.cciIncome > 0)? this.cciIncome : 0.0;
      }
      //-
    } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gapIncome > 0)? this.gapIncome : 0.0;
      // Warranty
      r += (this.warrantyIncome > 0)? this.warrantyIncome : 0.0;
      //NWC
      r += (this.nwcIncome > 0)? this.nwcIncome : 0.0;
      // LPI      
      r += (this.cciIncome > 0)? this.cciIncome : 0.0;
      //-
    } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gapIncome > 0)? this.gapIncome : 0.0;
      // Warranty
      r += (this.warrantyIncome > 0)? this.warrantyIncome : 0.0;
      //NWC
      r += (this.nwcIncome > 0)? this.nwcIncome : 0.0;
      //-
    } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gapIncome > 0)? this.gapIncome : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
      // Shortfall / GAP
      r += (this.gapIncome > 0)? this.gapIncome : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
      // Warranty
      r += (this.warrantyIncome > 0)? this.warrantyIncome : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
      r += (this.nwcIncome > 0)? this.nwcIncome : 0.0;
    } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
      r += (this.cciIncome > 0)? this.cciIncome : 0.0;
    }
    return r;
  }

  public Boolean getDisplayMVProduct() {
    return true;
    // return InsuranceQuoteUtils.displayMVProduct(this.quoting);
  }
  public Boolean getDisplayGAPProduct() {
    return true;
    // return InsuranceQuoteUtils.displayGAPProduct(this.quoting);
  }
  public Boolean getDisplayLPIProduct() {
    return true;
    // return InsuranceQuoteUtils.displayLPIProduct(this.quoting);
  }
  
  public Boolean getDisplayLPIProductLiberty() {
    return (
      getDisplayLPIProduct() && 
      InsuranceQuoteUtils.isLibertyInsProduct(this.quoting.Insurance_LPI_Options__c)
    );
  }

  public Boolean getDisplayEricWARRProduct() {
    return (
      this.quoting == null || 
      String.isBlank(this.quoting.Insurance_Warranty_Options__c) || 
      InsuranceQuoteUtils.INS_PROD_WARR_ERIC.equals(
        this.quoting.Insurance_Warranty_Options__c)
    );
  }
  public Boolean getDisplayIntegrityWARRProduct() {
    return (
      this.quoting != null && 
      InsuranceQuoteUtils.INS_PROD_WARR_INTE.equals(
        this.quoting.Insurance_Warranty_Options__c)
    );
  }
  public Boolean getDisplayTyWhProduct() {
    return true;
    // return InsuranceQuoteUtils.displayTyWhProduct(this.quoting);
  }

  public List<SelectOption> getMVOptions() {
    return InsuranceQuoteUtils.buildProductOptions(this.quoting.Insurance_MV_Options__c);
  }

  public List<SelectOption> getShortfallOptions() {
    return InsuranceQuoteUtils.buildProductOptions(this.quoting.Insurance_Shortfall_Options__c);
  }

  public List<SelectOption> getLPIOptions() {
    return InsuranceQuoteUtils.buildProductOptions(this.quoting.Insurance_LPI_Options__c);
  }

  public List<SelectOption> getWarrantyOptions() {
    return InsuranceQuoteUtils.buildProductOptions(this.quoting.Insurance_Warranty_Options__c);
  }

  // Product Calculated
  public Boolean getIsGAPCalculated() {
    return InsuranceQuoteUtils.isProductCalculated(this.quoting.Insurance_Shortfall_Options__c);
  }

  public Boolean getIsLPICalculated() {
    return InsuranceQuoteUtils.isProductCalculated(this.quoting.Insurance_LPI_Options__c);
  }

  // Insurance Payment
  private Decimal getInsurancePayment(Decimal premium, String term, String payType) {
    Decimal r = null;
    if (
      premium != null && 
      String.isNotBlank(term) && 
      term.isNumeric() &&
      'PBM'.equals(payType)
    ) {
      r = premium / Decimal.valueOf(term) * 12 / 52;
    }
    System.debug('premium: ' + premium + ' term: ' + term + ' payType: ==> ' + payType + ' ==> ' + r);
    return r;
  }

  public Decimal getMVPayment() {
    System.debug('getMVPayment...');
    return getInsurancePayment(this.mv, '12', 'PBM');
  }

  public Decimal getShortfallPayment() {
    System.debug('getGAPPayment...');
    return getInsurancePayment(this.gap, this.gapTerm, this.gapPayType);
  }

  public Decimal getLPIPayment() {
    System.debug('getLPIPayment...');
    String t = this.cciTerm;
    if (this.getDisplayLPIProductLiberty()) {
      t = this.term > 0? String.valueOf(this.term): null;
    }
    return getInsurancePayment(this.cci, t, this.cciPayType);
  }

  public Decimal getWARRPayment() {
    System.debug('getWARRPayment...');
    return getInsurancePayment(this.warranty, this.warrantyTerm, this.warrantyPayType);
  }

  public Decimal getNWCPayment() {
    System.debug('getNWCPayment...');
    return getInsurancePayment(this.nwc, this.nwcTerm, this.nwcPayType);
  }
  
  // Term options
  public List<SelectOption> getInsTermOptions() {
    return InsuranceQuoteUtils.buildTermOptions();
  }

  // Calculate GAP
  public void calculateGAP() {
    System.debug('calculateGAP...');
    if (this.getIsGAPCalculated()) {
      System.debug('state:    >>> ' + this.Opp.Application__r.State__c);
      Liberty_VEI_Setting__c a = QuotingToolHelper.getLibertyVEISetting(this.Opp.Application__r.State__c, this.gapLevel);
      //System.debug(this.Opp.Application__r.State__c + '|' + veiLevel + '|' + a);
      this.gap = 0.00;
      this.gapIncome = 0.00;
      if (a != null) {
        this.gap = a.Retail__c;
        this.gapIncome = a.Commission__c;
      }
    }
  }

  // Calculate LPI
  public void calculateLPI() {
    // TODO - recalculate LPI when NAF changes
    System.debug('calculateLPI...');
    if (this.getIsLPICalculated()) {
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Liberty');
      param.totalAmount = this.getLPITotalAmount();
      param.lpiLevel = cciLevel;
      param.state = this.Opp.Application__r.State__c;
      param.term = term;
      param.dateOfBirth = Opp.Application__r.Date_of_Birth_1__c;
      param.maritalStatus = Opp.Application__r.Marital_Status_1__c;
      param.noOfDependants = Opp.Application__r.No_of_Dependants_1__c;
      param.noOfPeople = Opp.Application__r.No_of_People__c;
      System.debug('param    >>>> '+JSON.serialize(param));
      try {
        QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
        cci = p.premium;
        cciIncome = p.income;
      } catch (Exception e) {
        ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,
              'LPI could not be calculate  [' +
              e.getMessage() +
              ']'
            )
          );
      }
    }
  }

  public Decimal getLPITotalAmount() {
    Decimal r = this.getTotalAmount(QuotingCalculation.CALC_QUOTING);
    if ('A'.equals(this.warrantyAcceptance) && 'Financed'.equals(this.warrantyPayType))  {
      //Eric Insurance
      r += this.warranty > 0? this.warranty : 0.00;
    } else if ('A'.equals(this.nwcAcceptance)) {
      //Manual Insurances
      r += this.nwc > 0? this.nwc : 0.00;
    }
    return r;
  }

  // Acceptance
  private String checkInsProductDecision(String desicion, String acceptance) {
    if (!QuotingToolHelper.allowInsuranceActions(true)) {
      return desicion;
    }
    return (acceptance.equals(desicion))? 'U' : acceptance;
  }

  public void acceptQuoteMV() {
    this.mvAcceptance = checkInsProductDecision(this.mvAcceptance, 'A');
  }

  public void declineQuoteMV() {
    this.mvAcceptance = checkInsProductDecision(this.mvAcceptance, 'D');
  }

  public void acceptQuoteGAP() {
    this.gapAcceptance = checkInsProductDecision(this.gapAcceptance, 'A');
    this.realtimeNafCalc();
  }

  public void declineQuoteGAP() {
    this.gapAcceptance = checkInsProductDecision(this.gapAcceptance, 'D');
    this.realtimeNafCalc();
  }

  public void acceptQuoteCCI() {
    this.cciAcceptance = checkInsProductDecision(this.cciAcceptance, 'A');
    this.realtimeNafCalc();
  }

  public void declineQuoteCCI() {
    this.cciAcceptance = checkInsProductDecision(this.cciAcceptance, 'D');
    this.realtimeNafCalc();
  }

  public void acceptQuoteWRR() {
    this.warrantyAcceptance = checkInsProductDecision(this.warrantyAcceptance, 'A');
    this.realtimeNafCalc();
  }

  public void declineQuoteWRR() {
    this.warrantyAcceptance = checkInsProductDecision(this.warrantyAcceptance, 'D');
    this.realtimeNafCalc();
  }

  public void acceptQuoteNWC() {
    // TODO - NWC validation
    this.nwcAcceptance = checkInsProductDecision(this.nwcAcceptance, 'A');
    this.realtimeNafCalc();
  }

  public void declineQuoteNWC() {
    this.nwcAcceptance = checkInsProductDecision(this.nwcAcceptance, 'D');
    this.realtimeNafCalc();
  }

  // Onchange insurance product type
  public void onChangeMV() {
    this.mvLevel = null;
    this.mv = null;
    this.mvIncome = null;
  }

  public void onChangeGAP() {
    this.gapLevel = null;
    this.gap = null;
    this.gapIncome = null;
    this.gapTerm = '12';
    if (InsuranceQuoteUtils.displayLibertyGAPProduct(this.quoting)) {
      this.gapTerm = '36';
    }
    this.gapPayType = null;
  }

  public void onChangeLPI() {
    this.cciLevel = null;
    this.cci = null;
    this.cciIncome = null;
    this.cciTerm = null;
    this.cciPayType = null;
  }

  public void onChangeWARR() {
    this.warrantyLevel = null;
    this.warranty = null;
    this.warrantyIncome = null;
    this.warrantyTerm = '12';
    this.warrantyPayType = null;

    this.nwc = null;
    this.nwcIncome = null;
    this.nwcParam = new NWCCalc.Parameter();
    this.loadNWCParameters();
    this.nwcTerm = null;
    this.nwcPayType = 'Financed';
  }


  // Integrity
  public void loadNWCParameters() {
    System.debug('loadNWCParameters...');
    this.NWCMessage = '';
    this.isAssetCar = false;
    this.isAssetBoat = false;
    //Warranty update - HJ - 03-12-2018 - I
    // this.nwcParam.isIntegrity = false;
    //Warranty update - HJ - 03-12-2018 - F
    //String asset = dto.productGoodsType;
    // this.nwcParam.assetType = getAssetTypeOpp();
    this.nwcParam.assetType = this.getAssetTypeOpp();
    
    // this.nwcParam.state = getStateOpp();
    this.nwcParam.state = (
      this.Opp != null &&
      this.Opp.Application__c != null &&
      String.isNotBlank(this.Opp.Application__r.State__c)
    )? this.Opp.Application__r.State__c : null;

    this.isCategoryType = false;
    if ('Car'.equalsIgnoreCase(this.nwcParam.assetType)) {
      this.isAssetCar = true;
      this.isCategoryType = true;
    }
    if ('Boat'.equalsIgnoreCase(this.nwcParam.assetType)) {
      this.isAssetBoat = true;
      this.isCategoryType = true;
    }
    if ('Truck'.equalsIgnoreCase(this.nwcParam.assetType)) {
      this.isCategoryType = true;
    }
    // if ('Integrity'.equalsIgnoreCase(this.nwcParam.type_p)) {
    //   this.nwcParam.isIntegrity = true;
    // }
    this.nwcParam.plan = this.nwcPlan;
    this.NWCTypePOptions = NWCCalc.NWCTypeOptions(this.nwcParam.assetType);
    // System.debug('NWCTypePOptions => ' + this.NWCTypePOptions.size());
    this.NWCPlanOptions = NWCCalc.NWCPlanOptions(
      this.nwcParam.assetType,
      this.nwcParam.type_p
    );
    this.NWCTermOptions = NWCCalc.NWCTermOptions(
      this.nwcParam.assetType,
      this.nwcParam.type_p
    );
    this.isNWCValidationOk = true;

    //NWC Warnings - I
    Id oppId = this.Opp != null? this.Opp.Id : null;
    Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(oppId);
    this.nwcParam.vehicleAgeYears = Utilities.getVehicleAgeYears(aad, this.Opp);
    if (aad != null && aad.Actual_KM__c != null) {
      this.nwcParam.actualKm = aad.Actual_KM__c;
    }

    //NWC Warnings - F
    // System.debug(JSON.serializePretty(this.nwcParam));
    this.calculateNWC();
  }

  public void calculateNWC() {
    System.debug('calculateNWC...');
    this.isNWCValidationOk = true;
    this.NWCMessage = '';
    this.nwcParam.plan = this.nwcPlan;
    this.nwcParam.term = this.nwcTerm;
    
    this.nwcParam.state = (
      this.Opp != null &&
      this.Opp.Application__c != null &&
      String.isNotBlank(this.Opp.Application__r.State__c)
    )? this.Opp.Application__r.State__c : null;

    System.debug(JSON.serializePretty(this.nwcParam));
    this.NWCPlanOptions = NWCCalc.NWCPlanOptions(
      this.nwcParam.assetType,
      this.nwcParam.type_p
    );
    System.debug('NWCPlanOptions => ' + this.NWCPlanOptions.size());
    //NWC Warnings - I
    this.checkNWCMessages(this.nwcParam);
    //NWC Warnings - F

    this.NWCTermOptions = NWCCalc.NWCTermOptions(
      this.nwcParam.assetType,
      this.nwcParam.type_p,
      this.nwcParam.plan
    );

    //Warranty update - HJ - 03-12-2018 - I
    // this.nwcParam.isIntegrity = false;
    // if ('Integrity'.equalsIgnoreCase(this.nwcParam.type_p)) {
    //   this.nwcParam.isIntegrity = false;
    //   if (
    //     !StringUtils.isNullOrEmpty(this.nwcParam.plan) &&
    //     !StringUtils.isNullOrEmpty(this.nwcParam.Term)
    //   ) {
    //     this.nwcParam.isIntegrity = true;
    //   }
    //   return;
    // }
    //Warranty update - HJ - 03-12-2018 - F

    if (this.nwcParam.isIntegrity || this.nwcParam.isManuallyNWCPrice) {
      return;
    }

    this.nwcIncome = 0;
    this.nwc = 0;

    if (
      !StringUtils.isNullOrEmpty(this.nwcParam.assetType) &&
      !StringUtils.isNullOrEmpty(this.nwcParam.plan) &&
      !StringUtils.isNullOrEmpty(this.nwcParam.term) &&
      !StringUtils.isNullOrEmpty(this.nwcParam.type_p)
    ) {
      /**
                if (isAssetCar && (StringUtils.isNullOrEmpty(nwcParam.awd4wd) || StringUtils.isNullOrEmpty(nwcParam.luxuryCar))){
                    //NWCMessage = 'Missing values';
                    //System.debug('Missing values: AWD4WD / LuxuryCar]');
                }else **/
      if (this.isAssetBoat && '----'.equalsIgnoreCase(this.nwcParam.type_p)) {
        //NWCMessage = 'Missing values';
        System.debug('Missing values: Engine]');
      } else if ('----'.equalsIgnoreCase(this.nwcParam.type_p)) {
        //NWCMessage = 'Missing values';
        System.debug('Missing values: Category]');
      } else {
        try {
          NWCCalc.Result r = NWCCalc.CalculateNWC(this.nwcParam);
          this.nwc = r.retailPrice;
          this.nwcIncome = r.commission;
          this.priceCustomer = this.nwc;
          //NWCMessage = 'OK-' + nwcParam.nwcPriceToCustomer;
        } catch (Exception ex) {
          this.NWCMessage = ex.getMessage();
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,
              'NWC Warranty: [' +
              this.NWCMessage +
              ']'
            )
          );
          System.debug('NWC Warranty: [' + this.NWCMessage + ']');
          this.isNWCValidationOk = false;
        }
      }
    } else {
      //NWCMessage = 'Missing values';
      System.debug('NWC Calculator: Missing values');
    }
  }

  public void checkManuallyNWCPrice() {
    // if (this.priceCustomer != null) {
    //   this.nwcParam.nwcPriceToCustomer = this.priceCustomer;
    // }
    // if (this.nwcParam.isManuallyNWCPrice) {
    //   Decimal priceCustomer = nwcParam.nwcPriceToCustomer;
    //   //Warranty update - HJ - 03-12-2018 - I
    //   if (priceCustomer == null) {
    //     this.nwcParam.isManuallyNWCPrice = false;
    //     return;
    //   }
    //   //Warranty update - HJ - 03-12-2018 - F
    //   Long iPart = (Long) priceCustomer;
    //   Decimal fPart = priceCustomer - iPart;
    //   if (fPart > 0) {
    //     this.nwcParam.nwcPriceToCustomer = NumberUtils.convertDecimalToScale(
    //       priceCustomer - 0.01,
    //       2
    //     );
    //   }
    // }
    // calculateNWC();
  }

  public void checkNWCMessages(NWCCalc.Parameter nwcParam) {
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'VechileYear: ' + nwcParam.vehicleAgeYears + ' ActualKm: ' + nwcParam.actualKm));
    System.debug(
      'checkNWCMessages: ' +
      nwcParam.plan +
      '|' +
      nwcParam.vehicleAgeYears +
      '|' +
      nwcParam.actualKm +
      '|' +
      nwcParam
    );
    this.messageNWCWarning = null;
    if (
      nwcParam == null ||
      nwcParam.plan == null ||
      nwcParam.vehicleAgeYears == null ||
      nwcParam.actualKm == null
    ) {
      return;
    }
    if (
      'Bronze'.equalsIgnoreCase(nwcParam.plan) &&
      nwcParam.vehicleAgeYears > 20 &&
      nwcParam.actualKm > 300000
    ) {
      this.messageNWCWarning =
        'Vehicles is up to 20 years and 300,000kms for this Category [' +
        nwcParam.plan +
        ']';
    } else if (
      'Silver'.equalsIgnoreCase(nwcParam.plan) &&
      nwcParam.vehicleAgeYears > 20 &&
      nwcParam.actualKm > 250000
    ) {
      this.messageNWCWarning =
        'Vehicles is up to 20 years and 250,000kms for this Category [' +
        nwcParam.plan +
        ']';
    } else if (
      'Gold'.equalsIgnoreCase(nwcParam.plan) &&
      nwcParam.vehicleAgeYears > 15 &&
      nwcParam.actualKm > 200000
    ) {
      this.messageNWCWarning =
        'Vehicles is up to 15 years and 200,000kms for this Category [' +
        nwcParam.plan +
        ']';
    } else if (
      'Platinum'.equalsIgnoreCase(nwcParam.plan) &&
      nwcParam.vehicleAgeYears > 10 &&
      nwcParam.actualKm > 150000
    ) {
      this.messageNWCWarning =
        'Vehicles is up to 10 years and 150,000kms for this Category [' +
        nwcParam.plan +
        ']';
    }
  }

  public void nationalWarrantyCalc() {
    this.nwcCost = QuotingToolHelper.getNationalWarrantyCost(
      this.nwcPlan,
      this.nwcTerm
    );
    //this.nwcIncome = 0.0;
    //if (this.nwc != null && this.nwcCost > 0 && (this.nwcIncome == null || this.nwcIncome==0)) {
    //    this.nwcIncome = this.nwc - this.nwcCost;
    //    if (this.nwcIncome < 0) {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty commission is below zero, please check the Retail Price.'));
    //    }
    //}
  }
  
  public String getAssetTypeOpp() {
    String r = '';
    if (
      this.Opp != null &&
      this.Opp.Application__c != null &&
      String.isNotBlank(this.Opp.Application__r.Type_of_Asset__c)
    ) {
      r = this.Opp.Application__r.Type_of_Asset__c;
    }
    return r;
  }

  public void updateQuotingData() {

    //Lender
    this.quoting.Name = this.quotingName;

    //Associate Application / Opportunity
    this.quoting.Application__c = this.Opp.Application__c;
    this.quoting.Opportunity__c = this.Opp.Id;

    // Reset Insurance data
    this.quoting.Insurance_MV_Type__c = null;
    this.quoting.Insurance_MV_Retail_Price__c = null;
    this.quoting.Insurance_MV_Income__c = null;
    this.quoting.Insurance_MV_Acceptance__c = 'U';

    this.quoting.Insurance_GAP_Type__c = null;
    this.quoting.Insurance_GAP_Retail_Price__c = null;
    this.quoting.Insurance_GAP_Income__c = null;
    this.quoting.Insurance_GAP_Acceptance__c = 'U';
    this.quoting.Insurance_GAP_Term__c = null;
    this.quoting.Insurance_GAP_PayType__c = null;

    this.quoting.Insurance_AIC_Type__c = null;
    this.quoting.Insurance_AIC_Retail_Price__c = null;
    this.quoting.Insurance_AIC_Income__c = null;
    this.quoting.Insurance_AIC_Acceptance__c = 'U';
    this.quoting.Insurance_AIC_Term__c = null;
    this.quoting.Insurance_AIC_PayType__c = null;

    this.quoting.Insurance_Warranty_Type__c = null;
    this.quoting.Insurance_Warranty_Retail_Price__c = null;
    this.quoting.Insurance_Warranty_Income__c = null;
    this.quoting.Insurance_Warranty_Acceptance__c = 'U';
    this.quoting.Insurance_Warranty_Term__c = null;
    this.quoting.Insurance_Warranty_PayType__c = null;

    this.quoting.Insurance_NWC_Retail_Price__c = null;
    this.quoting.Insurance_NWC_Income__c = null;
    this.quoting.Insurance_NWC_Plan__c = null;
    this.quoting.Insurance_NWC_Term__c = null;
    this.quoting.Insurance_NWC_Cost__c = null;
    this.quoting.Insurance_NWC_Acceptance__c = 'U';
    this.quoting.Insurance_NWC_PayType__c = null;

    this.quoting.Insurance_NWC_AWD4WD__c = null;
    this.quoting.Insurance_NWC_LuxuryCar__c = null;
    this.quoting.Insurance_NWC_TypeP__c = null;
    this.quoting.Insurance_NWC_Is_Manually_Value__c = false;
    
    // MV
    if (String.isNotBlank(this.quoting.Insurance_MV_Options__c)) {
      this.quoting.Insurance_MV_Type__c = this.mvLevel;
      this.quoting.Insurance_MV_Retail_Price__c = this.mv;
      this.quoting.Insurance_MV_Income__c = this.mvIncome;
      this.quoting.Insurance_MV_Acceptance__c = this.mvAcceptance;
    }
    
    // GAP
    if (String.isNotBlank(this.quoting.Insurance_Shortfall_Options__c)) {
      this.quoting.Insurance_GAP_Type__c = this.gapLevel;
      this.quoting.Insurance_GAP_Retail_Price__c = this.gap;
      this.quoting.Insurance_GAP_Income__c = this.gapIncome;
      this.quoting.Insurance_GAP_Acceptance__c = this.gapAcceptance;
      this.quoting.Insurance_GAP_PayType__c = this.gapPayType;
      this.quoting.Insurance_GAP_Term__c = this.gapTerm;
    }

    // LPI
    if (String.isNotBlank(this.quoting.Insurance_LPI_Options__c)) {
      this.quoting.Insurance_AIC_Type__c = this.cciLevel;
      this.quoting.Insurance_AIC_Retail_Price__c = this.cci;
      this.quoting.Insurance_AIC_Income__c = this.cciIncome;
      this.quoting.Insurance_AIC_Acceptance__c = this.cciAcceptance;
      this.quoting.Insurance_AIC_PayType__c = this.cciPayType;
      this.quoting.Insurance_AIC_Term__c = this.cciTerm;
      if (
        InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting) &&
        String.isBlank(this.quoting.Insurance_AIC_Term__c)
      ) {
        this.quoting.Insurance_AIC_Term__c = String.valueOf(this.term);
      }
    }

    // Warranty
    if (InsuranceQuoteUtils.INS_PROD_WARR_ERIC.equals(this.quoting.Insurance_Warranty_Options__c)) {
      this.quoting.Insurance_Warranty_Type__c = this.warrantyLevel;
      this.quoting.Insurance_Warranty_Retail_Price__c = this.warranty;
      this.quoting.Insurance_Warranty_Income__c = this.warrantyIncome;
      this.quoting.Insurance_Warranty_Acceptance__c = this.warrantyAcceptance;
      this.quoting.Insurance_Warranty_PayType__c = this.warrantyPayType;
      this.quoting.Insurance_Warranty_Term__c = this.warrantyTerm;
    }

    // NWC
    if (InsuranceQuoteUtils.INS_PROD_WARR_INTE.equals(this.quoting.Insurance_Warranty_Options__c)) {
      this.quoting.Insurance_NWC_Retail_Price__c = this.nwc;
      this.quoting.Insurance_NWC_Income__c = this.nwcIncome;
      this.quoting.Insurance_NWC_Plan__c = this.nwcPlan;
      this.quoting.Insurance_NWC_Term__c = this.nwcTerm;
      this.quoting.Insurance_NWC_Cost__c = this.nwcCost;
      this.quoting.Insurance_NWC_Acceptance__c = this.nwcAcceptance;
      this.quoting.Insurance_NWC_PayType__c = this.nwcPayType;

      this.quoting.Insurance_NWC_AWD4WD__c = this.nwcParam.awd4wd;
      this.quoting.Insurance_NWC_LuxuryCar__c = this.nwcParam.luxuryCar;
      this.quoting.Insurance_NWC_TypeP__c = this.nwcParam.type_p;
      this.quoting.Insurance_NWC_Is_Manually_Value__c = this.nwcParam.isManuallyNWCPrice;
    }

    // Basic details
    this.quoting.Loan_Type__c = this.loanType;
    this.quoting.Loan_Product__c = this.productLoanType;
    this.quoting.Vehicle_Price__c = this.carPrice;
    this.quoting.Deposit__c = this.deposit;
    this.quoting.Trade_In__c = this.tradeIn;
    this.quoting.Payout_On__c = this.payoutOn;

    this.quoting.Application_Fee__c = this.applicationFee;
    this.quoting.DOF__c = this.dof;
    this.quoting.PPSR__c = this.ppsr;
    this.quoting.Residual_Value__c = this.residualValue;

    this.quoting.Client_Rate__c = this.clientRate;
    this.quoting.Base_Rate__c = this.baseRate;
    this.quoting.Monthly_Fee__c = this.monthlyFee;

    //Loan Details
    this.quoting.Term__c = (term != null) ? Decimal.valueOf(term) : null;
    this.quoting.Payment__c = this.paymentType;
    this.quoting.Loan_Purpose__c = this.loanPurpose;
    
    //Data calculated - Commission
    this.quoting.Commission_Estimation__c = this.estimatedCommission;
    this.quoting.Commission_Insurance_Income__c = this.insuranceIncome;
    this.quoting.Commission_DOF__c = this.dofResult;
    this.quoting.Commission_Total_GST_Exc__c = this.totalCommission;
    //Data calculated - Repayment
    this.quoting.Rental__c = this.rental;
    this.quoting.Repayment_Monthly__c = this.monthlyPayment;
    this.quoting.Repayment_Fortnightly__c = this.fortnightlyPayment;
    this.quoting.Repayment_Weekly__c = this.weeklyPayment;
    this.quoting.NAF__c = this.naf;
    if (this.quote != null && this.quote.Id !=null) {
      update this.quote;
    }
  }

  public void loadQuotingInsuranceData() {
    System.debug('loadQuotingInsuranceData... ' + this.quoting.Insurance_MV_Options__c);
    this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(
      this.quoting.App_Insurance_Quote__c
    );
    // MV
    if (String.isNotBlank(this.quoting.Insurance_MV_Options__c)) {
      this.mvLevel = this.quoting.Insurance_MV_Type__c;
      this.mv = this.quoting.Insurance_MV_Retail_Price__c;
      this.mvIncome = this.quoting.Insurance_MV_Income__C;
      this.mvAcceptance = this.quoting.Insurance_MV_Acceptance__c;
    } else if (!'U'.equals(this.quoting.Insurance_MV_Acceptance__c)) {
      this.mvAcceptance = this.quoting.Insurance_MV_Acceptance__c;
    }
    
    // GAP
    if (String.isNotBlank(this.quoting.Insurance_Shortfall_Options__c)) {
      this.gapLevel = this.quoting.Insurance_GAP_Type__c;
      this.gap = this.quoting.Insurance_GAP_Retail_Price__c;
      this.gapIncome = this.quoting.Insurance_GAP_Income__c;
      this.gapAcceptance = this.quoting.Insurance_GAP_Acceptance__c;
      this.gapPayType = this.quoting.Insurance_GAP_PayType__c;
      if (String.isNotBlank(this.quoting.Insurance_GAP_Term__c)) {
        this.gapTerm = this.quoting.Insurance_GAP_Term__c;
      }
    } else if (!'U'.equals(this.quoting.Insurance_GAP_Acceptance__c)) {
      this.gapAcceptance = this.quoting.Insurance_GAP_Acceptance__c;
    }

    // LPI
    if (String.isNotBlank(this.quoting.Insurance_LPI_Options__c)) {
      this.cciLevel = this.quoting.Insurance_AIC_Type__c;
      this.cci = this.quoting.Insurance_AIC_Retail_Price__c;
      this.cciIncome = this.quoting.Insurance_AIC_Income__c;
      this.cciAcceptance = this.quoting.Insurance_AIC_Acceptance__c;
      this.cciPayType = this.quoting.Insurance_AIC_PayType__c;
      this.cciTerm = this.quoting.Insurance_AIC_Term__c;
    } else if (!'U'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
      this.cciAcceptance = this.quoting.Insurance_AIC_Acceptance__c;
    }
    
    // Warranty
    if (InsuranceQuoteUtils.INS_PROD_WARR_ERIC.equals(this.quoting.Insurance_Warranty_Options__c)) {
      this.warrantyLevel = this.quoting.Insurance_Warranty_Type__c;
      this.warranty = this.quoting.Insurance_Warranty_Retail_Price__c;
      this.warrantyIncome = this.quoting.Insurance_Warranty_Income__c;
      this.warrantyAcceptance = this.quoting.Insurance_Warranty_Acceptance__c;
      this.warrantyPayType = this.quoting.Insurance_Warranty_PayType__c;
      if (String.isNotBlank(this.quoting.Insurance_Warranty_Term__c)) {
        this.warrantyTerm = this.quoting.Insurance_Warranty_Term__c;
      }
    } else if (!'U'.equals(this.quoting.Insurance_Warranty_Acceptance__c)) {
      this.warrantyAcceptance = this.quoting.Insurance_Warranty_Acceptance__c;
    }

    // NWC
    if (InsuranceQuoteUtils.INS_PROD_WARR_INTE.equals(this.quoting.Insurance_Warranty_Options__c)) {
      this.nwc = this.quoting.Insurance_NWC_Retail_Price__c;
      this.nwcIncome = this.quoting.Insurance_NWC_Income__c;
      this.nwcPlan = this.quoting.Insurance_NWC_Plan__c;
      this.nwcTerm = this.quoting.Insurance_NWC_Term__c;
      this.nwcCost = this.quoting.Insurance_NWC_Cost__c;
      this.nwcAcceptance = this.quoting.Insurance_NWC_Acceptance__c;
      if (String.isNotBlank(this.quoting.Insurance_NWC_PayType__c)) {
        this.nwcPayType = this.quoting.Insurance_NWC_PayType__c;
      }

      this.nwcParam.awd4wd = this.quoting.Insurance_NWC_AWD4WD__c;
      this.nwcParam.luxuryCar = this.quoting.Insurance_NWC_LuxuryCar__c;
      this.nwcParam.type_p = this.quoting.Insurance_NWC_TypeP__c;
      this.nwcParam.isManuallyNWCPrice = this.quoting.Insurance_NWC_Is_Manually_Value__c;
      if (this.nwcParam.isManuallyNWCPrice) {
        this.nwcParam.nwcPriceToCustomer = this.nwc;
        this.priceCustomer = this.nwc;
      }
      System.debug('NWC priceCustomer => ' + this.priceCustomer);
    } else if (!'U'.equals(this.quoting.Insurance_NWC_Acceptance__c)) {
      this.nwcAcceptance = this.quoting.Insurance_NWC_Acceptance__c;
    }

    if (this.quote == null) {
      this.quote = new Application_InsuranceQuote__c();
    }
  }

  public void loadQuotingData() {
    System.debug('loadQuotingData...');
    // Basic details
    this.loanType = this.quoting.Loan_Type__c;
    this.productLoanType = this.quoting.Loan_Product__c;
    this.carPrice = this.quoting.Vehicle_Price__c;
    this.deposit = this.quoting.Deposit__c;
    this.tradeIn = this.quoting.Trade_In__c;
    this.payoutOn = this.quoting.Payout_On__c;

    this.applicationFee = this.quoting.Application_Fee__c;
    this.dof = this.quoting.DOF__c;
    this.ppsr = this.quoting.PPSR__c;
    this.residualValue = this.quoting.Residual_Value__c;

    if (this.quoting.Client_Rate__c != null) {
      this.clientRate = this.quoting.Client_Rate__c.setScale(2);
    }
    this.monthlyFee = this.quoting.Monthly_Fee__c;

    //Loan Details
    if (this.quoting.Term__c != null) {
      this.term = Integer.valueOf(this.quoting.Term__c);
    }
    
    this.paymentType = this.quoting.Payment__c;
    this.loanPurpose = this.quoting.Loan_Purpose__c;

    //Data calculated - Commission
    this.estimatedCommission = this.quoting.Commission_Estimation__c;
    this.insuranceIncome = this.quoting.Commission_Insurance_Income__c;
    this.dofResult = this.quoting.Commission_DOF__c;
    this.totalCommission = this.quoting.Commission_Total_GST_Exc__c;
    this.totalCommissionGst = this.quoting.Commission_Total_GST_Inc__c;
    
    //Data calculated - Repayment
    this.rental = this.quoting.Rental__c;
    this.monthlyPayment = this.quoting.Repayment_Monthly__c;
    this.fortnightlyPayment = this.quoting.Repayment_Fortnightly__c;
    this.weeklyPayment = this.quoting.Repayment_Weekly__c;
    this.naf = this.quoting.NAF__c;

    //Load calculations
    this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(this.quoting.Id);
  }

  // Validations
  public Boolean canPresentQuote() {
    return (
      (this.hasProductMV() || this.hasProductGAP() || this.hasProductLPI() 
      || this.hasProductWARR() || this.hasProductNWC()) &&
      this.isInsuranceValidationOK()
    );
  }

  public Boolean hasProductMV() {
    return String.isNotBlank(this.quoting.Insurance_MV_Options__c) 
      && String.isNotBlank(this.mvLevel) && this.mv > 0;
  }

  public Boolean hasProductGAP() {
    if (InsuranceQuoteUtils.isEricInsProduct(this.quoting.Insurance_Shortfall_Options__c)) {
      return String.isNotBlank(this.quoting.Insurance_Shortfall_Options__c) 
        && this.gap > 0;
    } else if (InsuranceQuoteUtils.isLibertyInsProduct(this.quoting.Insurance_Shortfall_Options__c)) {
      return String.isNotBlank(this.quoting.Insurance_Shortfall_Options__c) 
        && String.isNotBlank(this.gapLevel) && this.gap > 0;
    }
    return false;
  }

  public Boolean hasProductLPI() {
    return String.isNotBlank(this.quoting.Insurance_LPI_Options__c) 
      && String.isNotBlank(this.cciLevel) && this.cci > 0;
  }

  public Boolean hasProductWARR() {
    return (
      InsuranceQuoteUtils.INS_PROD_WARR_ERIC.equals(
        this.quoting.Insurance_Warranty_Options__c) 
      && String.isNotBlank(this.warrantyLevel) && this.warranty > 0
    );
  }

  public Boolean hasProductNWC() {
    return (
      InsuranceQuoteUtils.INS_PROD_WARR_INTE.equals(
        this.quoting.Insurance_Warranty_Options__c) 
      && this.nwc > 0
    );
  }

  public Boolean hasProductMVErrors() {
    return isInvalidInsuranceInfo(
      this.quoting.Insurance_MV_Options__c, 
      this.mvLevel, this.mv, this.mvIncome, 
      false, null, true, null, true);
  }

  public Boolean hasProductGAPErrors() {
    if (InsuranceQuoteUtils.displayLibertyGAPProduct(this.quoting)) {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_Shortfall_Options__c, 
        this.gapLevel, this.gap, this.gapIncome, false, 
        this.gapPayType, this.skipVEIPayType, this.gapTerm, true);
    } else if (
      String.isNotBlank(this.quoting.Insurance_Shortfall_Options__c) &&
      !InsuranceQuoteUtils.displayLibertyGAPProduct(this.quoting) &&
      this.quotingName.startsWithIgnoreCase('Liberty')
    ) {
      // Check Liberty lender
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR,'Only Liberty product is allowed for Shortfall'));
      return false;
    } else {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_Shortfall_Options__c, null,
        this.gap, this.gapIncome, true, this.gapPayType, 
        this.skipGAPPayType, this.gapTerm, false);
    }
  }

  public Boolean hasProductLPIErrors() {
    if (InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting)) {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_LPI_Options__c, 
        this.cciLevel, this.cci, this.cciIncome, false, 
        this.cciPayType, false, this.cciTerm, true);
    } else if (
      String.isNotBlank(this.quoting.Insurance_LPI_Options__c) &&
      !InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting) &&
      this.quotingName.startsWithIgnoreCase('Liberty')
    ) {
      // Check Liberty lender
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR,'Only Liberty product is allowed for Loan Protection'));
      return false;
    } else {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_LPI_Options__c, 
        this.cciLevel, this.cci, this.cciIncome, false, 
        this.cciPayType, false, this.cciTerm, false);
    }
  }

  public Boolean hasProductWARRErrors() {
    if (
      String.isNotBlank(this.quoting.Insurance_Warranty_Options__c) &&
      this.quoting.Insurance_Warranty_Options__c.contains('Eric')
    ) {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_Warranty_Options__c, this.warrantyLevel, 
        this.warranty, this.warrantyIncome, false, 
        this.warrantyPayType, this.skipWarrantyPayType, this.warrantyTerm, true);
    } else {
      return isInvalidInsuranceInfo(
        this.quoting.Insurance_Warranty_Options__c, this.nwcPlan,
        this.nwc, this.nwcIncome, false,  
        this.nwcPayType, this.skipIntegrityPayType, this.nwcTerm, false);
    }
  }
  
  // private Boolean isInvalidInsuranceInfo(
  //   String opt,
  //   Decimal price,
  //   Decimal comm
  // ) {
  //   return isInvalidInsuranceInfo(opt, null, price, comm, true);
  // }

  // private Boolean isInvalidInsuranceInfo(
  //   String opt,
  //   String level,
  //   Decimal price,
  //   Decimal comm
  // ) {
  //   return isInvalidInsuranceInfo(opt, level, price, comm, false);
  // }

  // private Boolean isInvalidInsuranceInfo(
  //   String opt,
  //   String level,
  //   Decimal price,
  //   Decimal comm,
  //   Boolean skipLevel
  // ) {
  //   return isInvalidInsuranceInfo(opt, level, price, comm, skipLevel, null, false, false);
  // }

  public Boolean isInvalidInsuranceInfo(
    String opt,
    String level,
    Decimal price,
    Decimal comm,
    Boolean skipLevel,
    String payType,
    Boolean skipPayType,
    String insTerm,
    Boolean skipTerm
  ) {
    System.debug(opt + '|' + level + '|' + price + '|' + comm + '|' + skipLevel + '|' + insTerm + '|' + payType + '|' + skipPayType + '|' + skipTerm);
    
    Boolean r = false;
    if (String.isNotBlank(opt)) {
      if (
        ((!skipLevel && String.isBlank(level)) || 
        !(price > 0) || !(comm > 0))
      ) {
        String errmsg = ', please complete the Product, Retail Price and Commission fields.';
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            opt + errmsg
          )
        );
        r = true;
      }
      // Validate terms
      if (!skipTerm && String.isBlank(insTerm)) {
        String errmsg = ', please select a term';
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            opt + errmsg
          )
        );
        r = true;
      }
      // Validate payment options
      if (!skipPayType && String.isBlank(payType)) {
        String errmsg = ', please select either Financed or PBM';
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            opt + errmsg
          )
        );
        r = true;
      }

      if (!skipPayType && !'PBM'.equals(payType) && this.isOnlyPayByTheMonth) {
        String errmsg = ', only PBM is allowed by ' + this.quotingName;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,opt + errmsg));
        r = true;
      }
    }
    return r;
  }
  
  public Boolean isInsuranceValidationOK() {
    System.debug('isInsuranceValidationOK...');
    Boolean r = true;
    // MV Insurance
    if (this.hasProductMVErrors()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.ERROR,
      //     this.quoting.Insurance_MV_Options__c + errmsg
      //   )
      // );
      r = false;
    }
    // Gap Insurance
    if (this.hasProductGAPErrors()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.ERROR,
      //     this.quoting.Insurance_Shortfall_Options__c + errmsg
      //   )
      // );
      r = false;
    } 
    
    // LPI Insurance
    if (this.hasProductLPIErrors()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.ERROR,
      //     this.quoting.Insurance_LPI_Options__c + errmsg
      //   )
      // );
      r = false;
    }
    
    // Warranty / NWC
    if (this.hasProductWARRErrors()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.ERROR,
      //     this.quoting.Insurance_Warranty_Options__c + errmsg
      //   )
      // );
      r = false;
    } 

    return r;
  }

  public Boolean insuranceProductSelected() {
    Boolean r = true;
    // Lelo                 2018-08-16
    // Accepted or declined validation
    // Motor Vehicle
    if (
      this.hasProductMV() &&
      (String.isBlank(this.mvAcceptance) || 'U'.equals(this.mvAcceptance))
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Motor Vehicle should be Accepted or Declined.'
        )
      );
      r = false;
    }
    // GAP / RTI
    if (
      this.hasProductGAP() && 
      (String.isBlank(this.gapAcceptance) || 'U'.equals(this.gapAcceptance))
      ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'GAP should be Accepted or Declined.'
        )
      );
      r = false;
    }
    
    if (
      this.hasProductLPI() && 
      (String.isBlank(this.cciAcceptance) || 'U'.equals(this.cciAcceptance))
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Repayment cover (Loan Protection) should be Accepted or Declined.'
        )
      );
      r = false;
    }
    // Warranty / NWC
    if (
      this.hasProductWARR() &&
      (String.isBlank(this.warrantyAcceptance) || 'U'.equals(this.warrantyAcceptance))
      ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Warranty - Insurance should be Accepted or Declined.'
        )
      );
      r = false;
    }
    if (
      this.hasProductNWC() &&
      (String.isBlank(this.nwcAcceptance) || 'U'.equals(this.nwcAcceptance))
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'NWC Warranty should be Accepted or Declined.'
        )
      );
      r = false;
    }
    return r;
  }

  public Product__c buildInsProduct(String insurer, String insType, Decimal premium, Decimal comm, String payType) {
    Id insRecTypeId = SOQLSingletonQueries.recs().recordTypes.get('Insurance');
    Product__c r = new Product__c();
    r.Opportunity_Name__c = this.Opp.Id;
    r.RecordTypeId = insRecTypeId;
    r.Insurance_Type__c = insType;
    r.Insurance_Policy_Amount__c = premium;
    r.Insurance_Commission__c = comm;
    r.Insurer__c = insurer;
    r.PayType__c = payType;
    return r;
  }

  public void saveInsuranceProducts() {
    System.debug('saveInsuranceProducts...');
    // Removing existing Insurance products
    QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
    List<Product__c> productList = new List<Product__c>();
    // then create the insurance products
    // Gap Insurance
    if ('A'.equals(this.gapAcceptance)) {
      System.debug('Creasting GAP product...');
      String insurer = 'AIC/Eric';
      String insType = 'Gap Insurance';
      if (InsuranceQuoteUtils.isLibertyInsProduct(this.quoting.Insurance_Shortfall_Options__c)) {
        insurer = 'Liberty Financial';
        insType = 'VEI';
      }      
      Product__c p = buildInsProduct(insurer, insType, this.gap, this.gapIncome, this.gapPayType);
      productList.add(p);
    }

    // Warranty Insurance
    if ('A'.equals(this.warrantyAcceptance)) {
      System.debug('Creasting Warranty product...');
      Product__c p = buildInsProduct(
        'AIC/Eric', 'Warranty', this.warranty, this.warrantyIncome, this.warrantyPayType);
      productList.add(p);
    }

    // MV Insurance
    if ('A'.equals(this.mvAcceptance)) {
      Product__c p = buildInsProduct(
        'Comprehensive', 'Full Comprehensive', this.mv, this.mvIncome, 'PBM');
      productList.add(p);
    }
    //Lelo      Insurnce        2018-02-26
    // CCI Insurance
    if ('A'.equals(this.cciAcceptance)) {
      System.debug('Creasting LPI product...');
      String insurer = 'AIC/Eric';
      String insType = 'CCI';
      if (InsuranceQuoteUtils.isLibertyInsProduct(this.quoting.Insurance_LPI_Options__c)) {
        insurer = 'Liberty Financial';
        insType = 'Loan Protection';
      }      
      Product__c p = buildInsProduct(insurer, insType, this.cci, this.cciIncome, this.cciPayType);
      productList.add(p);
    }
    // NWC Insurance
    if ('A'.equals(this.nwcAcceptance)) {
      System.debug('Creasting NWC product...');
      Product__c p = buildInsProduct(
        'Integrity', 'Warranty', this.nwc, this.nwcIncome, this.nwcPayType);
      productList.add(p);
    }
    System.debug('Adding ' + productList.size() + ' insurance product(s)');
    if (productList.size() > 0) {
      insert productList;
    }
    //-

  }

  public Boolean isQuotingCalculated() {
    Boolean r = false;
    if (hasValidQuotation()) {
      calculateQuote();
      r = this.rental > 0;
      if (!r) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before proceeding with your request.'));
      }
    }
    return r;
  }

  public void sendCustomerPresentation() {
    // Validate quote
    if (!this.isQuotingCalculated()) {
      return;
    }
    // Validate presentation
    if (!this.canPresentQuote()) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please verify the information in insurance products section before sending a presentation'));
      return;
    }
    // process email
    this.processEmailPresentation();
  }
  
  public void processEmailPresentation() {
    //Save calculations
    this.storeQuotingData();
    // reset acceptance
    InsuranceQuoteUtils.resetProductAcceptance(this.quoting, this.quote);
    this.resetInsuranceAcceptance();
    //Update presentation email date
    this.quoting.Presentation_Email_Date__c = Datetime.now();

    // if(this.quote.Id == null && this.Opp.Application__r.Type_of_Asset__c!=null){
    if(this.quote.Id == null){
      this.quote = InsuranceQuoteUtils.createDefaultInsuranceQuote(this.Opp, this.quoting);
      this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
      insert this.quote;
      InsuranceQuoteUtils.createDefaultMainDriver(this.Opp, this.quote);
    } else {
      this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
      this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
      update this.quote;
    }
    this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
    upsert this.quote;
    this.quoting.App_Insurance_Quote__c = this.quote.Id;
    if (!Test.isRunningTest()) {
      update this.quoting;
    }
    // Verify Default additional driver
    
    
    // Send the email
    try {
      EmailSender.sendCustomerInsurancePresentation(
        this.Opp,
        InsuranceQuoteUtils.getPresentationUrlCode(this.Opp.Application__c),
        InsuranceQuoteUtils.getPDSDocumentTypes(
          this.quoting,
          this.quote,
          getAssetTypeOpp()
        )
      );
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.CONFIRM,
          'Customer Insurance Presentation has just been sent.'
        )
      );
    } catch (EmailException e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
    }
  }

  public void previewCustomerPresentation() {
    System.debug('previewCustomerPresentation...');
    this.openPreviewPresentation = false;
    if (String.isBlank(this.opp.Application__c)) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
    } else {
      //Validations
      if (isQuotingCalculated() && canPresentQuote()) {
        System.debug('isQuotePresenting...');
        //Lelo                      2016-12-22
        //Save calculation
        if (!InsuranceQuoteUtils.isQuotePresenting(this.quote, false)) {
          //Save calculations
          this.storeQuotingData();
        }
        //-
        // String cpcode = CryptoUtils.encrypt(this.Opp.Application__c);
        // String cpcode2 = InsuranceQuoteUtils.getPresentationUrlCode(this.Opp.Application__c);
        // System.debug('Presentation CODE 1 => ' + cpcode);
        // System.debug('Presentation CODE 2 => ' + cpcode2);
        // PageReference P = Page.InsurancePresentation;
        // p.getParameters().put('P', cpcode);
        // P.setRedirect(true);
        // return P;
        this.openPreviewPresentation = true;
      }
    }
    System.debug('previewCustomerPresentation => preview displayed? ' + this.openPreviewPresentation);
  }

  public String getCustomerPresentationStatusStyle() {
    String r = 'presentationSent';
    if (
      this.quoting != null &&
      this.quoting.Presentation_Email_Date__c != null &&
      this.quote != null
    ) {
      if (
        InsuranceQuoteUtils.CUSCHOICE_DECIDING.equals(
          this.quote.Customer_Choice_Status__c
        ) ||
        InsuranceQuoteUtils.CUSCHOICE_DECLARING.equals(
          this.quote.Customer_Choice_Status__c
        ) ||
        InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE.equals(
          this.quote.Customer_Choice_Status__c
        ) ||
        InsuranceQuoteUtils.CUSCHOICE_FILLINFO.equals(
          this.quote.Customer_Choice_Status__c
        )
      ) {
        r = 'presentationProcess';
      } else if (
        InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(
          this.quote.Customer_Choice_Status__c
        )
      ) {
        r = 'presentationFinished';
      }
    }
    return r;
  }

  public List<Insurance_Failure_Reason__c> getInsuranceFailureReasons() {
    List<Insurance_Failure_Reason__c> r = new List<Insurance_Failure_Reason__c>();
    if (this.quote != null && this.quote.Id != null) {
      r = InsuranceQuoteUtils.getInsuranceFailureReasons(this.quote.Id);
    }
    return r;
  }

  public void reCreateQuote() {
    reCreateQuote(false);
  }

  public void reCreateQuote(Boolean skipQuoting) {
    // Reset sending presentation
    if (!skipQuoting) {
      this.quoting.Presentation_Email_Date__c = null;
      this.quoting.Insurance_Customer_Choice__c = null;
      this.quoting.Insurance_Choice_Date__c = null;
      this.quoting.Force_Calculation__c = false;
      this.quoting.Insurance_NWC_Qualifying__c = null;
      
      if (this.quote != null) {
        this.quote.Customer_Choice__c = null;
        this.quote.Customer_Choice_Date__c = null;
        this.quote.Customer_Choice_Status__c = null;
        this.quote.Customer_Choice_Details__c = null;
      }
    }

    // Reset insurance Acceptance
    this.resetInsuranceAcceptance();

  }

  public String getPresentationUrlCode() {
    return InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c);
  }

  public PageReference createPdf() {
    // pass parameters to the PDF page
    PageReference rpt = Page.UniversalCalculatorPdf;
    // pass universal variables
    rpt.getParameters().put('id', Opp.Id);
    if (this.lenderSettings != null) {
      String n = String.isNotBlank(this.lenderSettings.Label__c)? this.lenderSettings.Label__c : this.lenderSettings.Name;
      rpt.getParameters().put('lender', n.toUpperCase() + ' CALCULATION');
    }

    //Lelo          Insurance               2021-10-06
    // MV
    rpt.getParameters().put('mvLevel', null);
    rpt.getParameters().put('mv', String.valueOf(0.00));
    rpt.getParameters().put('mvIncome', String.valueOf(0.00));
    rpt.getParameters().put('mvPayType', null);
    if ('A'.equals(this.mvAcceptance)) {
      rpt.getParameters().put('mvLevel', mvLevel);
      rpt.getParameters().put('mv', String.valueOf(mv));
      rpt.getParameters().put('mvIncome', String.valueOf(mvIncome));
      rpt.getParameters().put('mvPayType', 'PBM');
    }
    // GAP - SHORTFALL
    rpt.getParameters().put('gapLevel', null);
    rpt.getParameters().put('gap', String.valueOf(0.00));
    rpt.getParameters().put('gapIncome', String.valueOf(0.00));
    if ('A'.equals(this.gapAcceptance)) {
      String a = this.quoting.Insurance_Shortfall_Options__c;
      a += String.isNotBlank(gapLevel)? ' [' + gapLevel + ']': '';
      rpt.getParameters().put('gapLevel', a);
      rpt.getParameters().put('gap', String.valueOf(gap));
      rpt.getParameters().put('gapIncome', String.valueOf(gapIncome));
      rpt.getParameters().put('gapPayType', this.gapPayType);
    }
    // Warranty
    rpt.getParameters().put('warrantyLevel', null);
    rpt.getParameters().put('warranty', String.valueOf(0.00));
    rpt.getParameters().put('warrantyIncome', String.valueOf(0.00));
    if ('A'.equals(this.warrantyAcceptance)) {
      rpt.getParameters().put('warrantyLevel', warrantyLevel);
      rpt.getParameters().put('warranty', String.valueOf(warranty));
      rpt.getParameters()
        .put('warrantyIncome', String.valueOf(warrantyIncome));
      rpt.getParameters().put('warrantyPayType', this.warrantyPayType);
    }
    // NWC - Integrity
    rpt.getParameters().put('nwcLevel', null);
    rpt.getParameters().put('nwc', String.valueOf(0.00));
    rpt.getParameters().put('nwcIncome', String.valueOf(0.00));
    if ('A'.equals(this.nwcAcceptance)) {
      rpt.getParameters().put('nwc', String.valueOf(nwc));
      rpt.getParameters().put('nwcIncome', String.valueOf(nwcIncome));
      rpt.getParameters().put('nwcPayType', this.nwcPayType);
      String nwcLevel = String.isNotBlank(nwcParam.type_p)? nwcParam.type_p : 'Integrity';
      rpt.getParameters().put('nwcLevel', nwcLevel);
      //NWC Calculator - HJ - 31-08-2018 - I
      String nwcAwd4wd = '';
      String nwcLuxuryCar = '';
      if (isAssetCar) {
        nwcAwd4wd = nwcParam.awd4wd;
        nwcLuxuryCar = nwcParam.luxuryCar;
      }
      String nwcEngine = '';
      String nwcType_p = nwcParam.type_p;
      if (isAssetBoat) {
        nwcEngine = nwcParam.type_p;
        nwcType_p = '';
      }
      String nwcIsManuallyNWCPrice = 'N';
      if (nwcParam.isManuallyNWCPrice) {
        nwcIsManuallyNWCPrice = 'Y';
      }
      rpt.getParameters().put('nwcAwd4wd', nwcAwd4wd);
      rpt.getParameters().put('nwcLuxuryCar', nwcLuxuryCar);
      rpt.getParameters().put('nwcType_p', nwcType_p);
      rpt.getParameters().put('nwcEngine', nwcEngine);
      rpt.getParameters()
        .put('nwcIsManuallyNWCPrice', nwcIsManuallyNWCPrice);
      rpt.getParameters().put('nwcTerm', nwcTerm);
      rpt.getParameters().put('nwcAssetType', nwcParam.assetType);
      rpt.getParameters().put('nwcState', nwcParam.state);
      rpt.getParameters().put('nwcPlan', nwcPlan);

      //NWC Calculator - HJ - 31-08-2018 - F
    }
    // LPI
    rpt.getParameters().put('cciLevel', null);
    rpt.getParameters().put('cci', String.valueOf(0.00));
    rpt.getParameters().put('cciIncome', String.valueOf(0.00));
    if ('A'.equals(this.cciAcceptance)) {
      rpt.getParameters().put('cciLevel', this.quoting.Insurance_LPI_Options__c + ' [' + cciLevel + ']');
      rpt.getParameters().put('cci', String.valueOf(cci));
      rpt.getParameters().put('cciIncome', String.valueOf(cciIncome));
      rpt.getParameters().put('cciPayType', this.cciPayType);
    }
    //-

    // Finance details
    rpt.getParameters().put('loanType', loanType);
    rpt.getParameters().put('productLoanType', productLoanType);
    rpt.getParameters().put('carPrice', String.valueOf(carPrice));
    if (deposit != null) {
      rpt.getParameters().put('deposit', String.valueOf(deposit));
    }
    if (tradeIn != null) {
      rpt.getParameters().put('tradeIn', String.valueOf(tradeIn));
    }
    if (payoutOn != null) {
      rpt.getParameters().put('payoutOn', String.valueOf(payoutOn));
    }
    rpt.getParameters().put('netDeposit', String.valueOf(netDeposit));

    rpt.getParameters().put('applicationFee', String.valueOf(applicationFee));
    rpt.getParameters().put('dof', String.valueOf(dof));
    rpt.getParameters().put('ppsr', String.valueOf(ppsr));
    rpt.getParameters().put('residualValue', String.valueOf(residualValue));
    rpt.getParameters().put('baseRate', String.valueOf(this.baseRate));
    rpt.getParameters().put('maxRate', String.valueOf(this.maxRate));
    Decimal cr = this.clientRate != null? this.clientRate.setScale(2) : 0.00;
    rpt.getParameters().put('clientRate', String.valueOf(cr));
    rpt.getParameters().put('term', String.valueOf(term));
    rpt.getParameters().put('paymentType', paymentType);
    
    rpt.getParameters().put('estimatedCommission', String.valueOf(estimatedCommission));
    rpt.getParameters().put('insuranceIncome', String.valueOf(insuranceIncome));
    rpt.getParameters().put('dofResult', String.valueOf(dofResult));
    rpt.getParameters().put('totalCommission', String.valueOf(totalCommission));
    rpt.getParameters().put('totalCommissionGst', String.valueOf(totalCommissionGst));
    rpt.getParameters().put('naf', String.valueOf(naf));
    rpt.getParameters().put('rental', String.valueOf(rental));
    rpt.getParameters().put('monthlyFee', String.valueOf(monthlyFee));
    rpt.getParameters().put('monthlyPayment', String.valueOf(monthlyPayment));
    rpt.getParameters().put('fortnightlyPayment', String.valueOf(fortnightlyPayment));
    rpt.getParameters().put('weeklyPayment', String.valueOf(weeklyPayment));

    return rpt;

  }

  public void savePdfInCloud(PageReference rpt, String prefixName) {
    
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
        this.Opp.Application__c,
        typeData,
        typeData,
        QuotingToolHelper.getApplicationQuoting(this.Opp.Application__c)
      );
    }
    if (isSaveInCloud) {
      QuotingToolHelper.attachPdfFile(this.Opp.Id, prefixName, rpt, isSaveInCloud);
    }
    if (isSaveInCloud && this.Opp.Application__c == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An application is required to generate a document for this quotation'));
    }
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation saved successfully.'));
  }

  // Abstract methods
  public abstract void calculateQuote(); 
  public abstract Boolean hasValidQuotation();
  public abstract void storeQuotingData(); 

}