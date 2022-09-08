public abstract class CompToolLenderCalcAbstract implements CompToolLenderCalc {
  
  public Calculator__c calc;
  public FilterParams param;
  public Lenders__c lenderSettings;
  public QuotingCalculation.CalcParam quoteParam;

  public Decimal applicationFee {set;get;}
  
  private CompToolLenderCalcAbstract() {}

  public CompToolLenderCalcAbstract(Calculator__c calc, FilterParams param) {
    THIS();
    System.debug('CompToolLenderCalcAbstract...');
    this.calc = calc;
    this.param = param;
    this.init();
  }

  public abstract CompToolLenderResult calculate();

  public void init() {
    System.debug('init...');
    this.reset();
    if (this.calc != null) {
      this.lenderSettings = Lenders__c.getInstance(this.calc.Name);
      if (this.lenderSettings != null) {
        // this.quoteParam.lender = this.calc.Name;
        this.quoteParam.lender = this.lenderSettings.Lender__c;
        // Default values
        this.quoteParam.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.quoteParam.applicationFee = this.lenderSettings.Application_Fee__c;
        this.quoteParam.dof = lenderSettings.DOF__c;
      }
    }
    if (this.param != null) {
      this.quoteParam.term = this.param.term;
      this.quoteParam.privateSales = param.getPrivateSales();
      this.quoteParam.residualValue = param.residual;
    }
    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.paymentType = 'Arreas';
    System.debug('this.param: ' + JSON.serializePretty(this.param));
  }

  public void reset() {
    System.debug('resetting...');
    this.quoteParam = new QuotingCalculation.CalcParam(
      this.calc != null && String.isNotBlank(this.calc.Name)
      ? this.calc.Name
      : 'no-lender'
    );
  }

  public virtual Decimal getTotalAmount() {
    System.debug('Calculating total amount...');
    Decimal r = this.getNetLoanAmount();
    // Fees
    if (this.lenderSettings != null) {
      // Default fees
      r += this.lenderSettings.PPSR__c > 0? this.lenderSettings.PPSR__c : 0.00;
    }
    if (this.quoteParam != null) {
      r += this.quoteParam.applicationFee > 0? this.quoteParam.applicationFee : 0.00;
      r += this.quoteParam.dof > 0? this.quoteParam.dof : 0.00;
      r += this.quoteParam.riskFee > 0? this.quoteParam.riskFee : 0.00;
    }
    return r;
  }

  public virtual Decimal getNetLoanAmount() {
    System.debug('Calculating total amount...');
    Decimal r = 0.00;
    if (this.param != null) {
      r += this.param.price > 0? this.param.price : 0.00;
      r -= this.param.deposit > 0? this.param.deposit : 0.00;
    }
    return r;
  }

  public virtual void baseRateCalc(Decimal clientRateFactor) {
    System.debug('calculating base rates...');
    System.debug('@@baseratecalc:' + JSON.serializePretty(this.quoteParam));
    this.quoteParam.baseRate = QuotingCalculation.getBaseRate(this.quoteParam);
    this.quoteParam.maxRate = QuotingCalculation.getMaximunBaseRate(this.quoteParam);
    if (this.quoteParam.baseRate > 0.00 && clientRateFactor > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.baseRate + clientRateFactor;
    } else if (this.quoteParam.maxRate > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.maxRate;
    } else {
      this.quoteParam.clientRate = this.quoteParam.baseRate;
    }

    if ('Personal'.equals(this.param.loanType)) {
      // Client Rate Factor
      if (this.quoteParam.baseRate > 0.00 && this.param.clientRateFactor >= 0.00) {
        this.quoteParam.clientRate = this.quoteParam.baseRate + this.param.clientRateFactor;
        this.quoteParam.clientRate = this.quoteParam.clientRate < this.quoteParam.baseRate
          ? this.quoteParam.baseRate : this.quoteParam.clientRate;
      }
    }
  }

  public virtual Decimal getLenderFees() {
    Decimal r = this.quoteParam.applicationFee > 0? this.quoteParam.applicationFee : 0.00;
    r += this.quoteParam.riskFee > 0? this.quoteParam.riskFee : 0.00;
    return r;
  }

  public CompToolLenderResult calculateRepayments() {
    System.debug('calculating repayments...');
    System.debug('@@param:' + JSON.serializePretty(this.param));
    System.debug('@@calculating:' + JSON.serializePretty(this.quoteParam));
    CompToolLenderResult r = new CompToolLenderResult();
    // try {
      // Rates
      r.baseRate = this.quoteParam.baseRate;
      r.maxRate = this.quoteParam.maxRate;
      r.clientRate = this.quoteParam.clientRate;
      r.monthlyFee = this.quoteParam.monthlyFee;

      System.debug('@@calculateRepayments: ' + JSON.serializePretty(this.quoteParam));

      // Calculation
      Application_Quoting_Result__c q = QuotingCalculation.calculate(this.quoteParam);
      q.recalculateFormulas();
      r.quote = q;
      r.lenderFees = this.getLenderFees();
    // } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    // }    
    return r;
  }

  public void setBrokerageValue() {
    setBrokerageValue(false);
  }

  public void setBrokerageValue(Boolean onlyDefaultValue) {
    this.quoteParam.brokeragePer = 0.00;
    System.debug('@@lenderSettings: ' + JSON.serializePretty(this.lenderSettings));
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }
    // if (
    //   !onlyDefaultValue &&
    //   this.quoteParam.brokeragePer > 0.00 && 
    //   this.param.clientRateFactor >= 0.00
    // ) {
    //   Decimal p = (this.param.clientRateFactor/2.00);
    //   this.quoteParam.brokeragePer = this.quoteParam.brokeragePer * p;
    //   this.quoteParam.brokeragePer = this.quoteParam.brokeragePer.setScale(2);
    //   this.quoteParam.brokeragePer = this.quoteParam.brokeragePer < 0? 0.00 : this.quoteParam.brokeragePer;
    // }
  }

  public String getBusinessAssetCategory() {
    String r = 'P';
    if (
      'Equipment'.equals(this.param.assetType) ||
      'Medical'.equals(this.param.assetType) ||
      'Printing'.equals(this.param.assetType)
    ) {
      r = 'S';
    } else if (
      'Gym Equipment'.equals(this.param.assetType) ||
      'Information IT'.equals(this.param.assetType) ||
      'Office Furniture'.equals(this.param.assetType) ||
      'Software'.equals(this.param.assetType) ||
      'Solar'.equals(this.param.assetType) ||
      'Telephony'.equals(this.param.assetType)
    ) {
      r = 'T';
    }
    return r;
  }

  //Inner class
  public class FilterParams {
    @AuraEnabled
    public String assetType { get; set; }
    @AuraEnabled
    public String loanType { get; set; }
    @AuraEnabled
    public String employmentType { get; set; }
    @AuraEnabled
    public String purchaseType { get; set; }
    @AuraEnabled
    public String creditHistory { get; set; }
    @AuraEnabled
    public String residentialStatus { get; set; }

    @AuraEnabled
    public String assetCondition { get; set; }
    @AuraEnabled
    public Integer assetAge { get; set; }
    @AuraEnabled
    public Integer term { get; set; }
    @AuraEnabled
    public Decimal price { get; set; }
    @AuraEnabled
    public Decimal deposit { get; set; }
    @AuraEnabled
    public Decimal residual { get; set; }

    // public String sortBy {set;get;}
    // public Boolean recalculating {set;get;}
    // public Decimal targetCommission {set;get;}
    // public Decimal estimateCommission {set;get;}
    // public Decimal dofValue {set;get;}

    //Brokerage %
    // public Decimal rateValue {set;get;}

    // Lelo                 2018-05-29
    @AuraEnabled
    public String hasPayday { get; set; }
    @AuraEnabled
    public String hasVerifiableCredit { get; set; }
    @AuraEnabled
    public Integer jobsLast3Years { get; set; }
    @AuraEnabled
    public String hasEnquiries { get; set; }
    @AuraEnabled
    public String creditScore { get; set; }
    @AuraEnabled
    public Integer realCreditScore { get; set; }
    @AuraEnabled
    public String verifiableSavings { get; set; }
    @AuraEnabled
    public String ltv { get; set; }
    @AuraEnabled 
    public String customValue1 {set;get;}
    @AuraEnabled 
    public String customValue2 {set;get;}
    @AuraEnabled
    public Decimal customClientRate { get; set; }
    @AuraEnabled
    public Decimal customDof { get; set; }
    @AuraEnabled
    public Decimal clientRateFactor { get; set; }
    @AuraEnabled
    public String abnLength { get; set; }
    @AuraEnabled
    public String gstRegistered { get; set; }
    @AuraEnabled
    public String paydays { get; set; }

    // Lelo                 2018-05-29
    // public Integer applicantAge {set;get;}
    // public Decimal annualIncome {set;get;}
    // public String tier {set;get;}
    // public String riskGrade {set; get;}
    // public String customerProfile {set; get;}
    public FilterParams() {
      this(true);
    }

    public FilterParams(Boolean setDefaults) {
      if (setDefaults) {
        //Temp
        this.assetType = 'Car';
        this.loanType = 'Personal';
        this.employmentType = 'Full-Time';
        this.purchaseType = 'Dealer';
        this.creditHistory = 'Good';
        this.residentialStatus = 'Property Owner';
        //
        // this.assetCondition = 'New';
        this.assetAge = 0;
        this.term = 60;
        this.price = null;
        this.deposit = 0.00;
        this.residual = 0.00;

        // this.ltv = '90-99';
        // this.creditScore = 750;
        // this.jobsLast3Years = 0;
      }
    }

    public String getPrivateSales() {
      String r = 'N';
      if ('Private'.equals(purchaseType)) {
        r = 'Y';
      }
      return r;
    }

    public Decimal getNetVehiclePrice() {
      Decimal r = 0.0;
      if (this.price != null) {
        r = this.price;
      }
      if (this.deposit != null) {
        r -= this.deposit;
      }
      return r;
    }

    public Integer getAssetYear() {
      return Date.today().year() - (this.assetAge > 0 ? this.assetAge : 0);
    }

    public Integer getAssetYearsAfterTerm() {
      Integer a = this.term > 0? this.term / 12 : 0;
      return this.assetAge + a;
    }

    public Integer getAbnLengthValue() {
      Integer r = 0;
      if (
        String.isNotBlank(this.abnLength) &&
        this.abnLength.isNumeric()
      ) {
        r = Integer.valueOf(this.abnLength);
      }
      return r;
    }

    public Integer getCreditScoreValue() {
      Integer r = 0;
      if (this.realCreditScore > 0) {
        r = this.realCreditScore;
      } else if (String.isNotBlank(this.creditScore)) {
        if ('0 - 499'.equals(this.creditScore)) {
          r = 499;
        } else {
          String[] v = this.creditScore.remove(' ').split('-');
          r = Integer.valueOf(v[0]);
        }
      }
      return r;
    }

    public Integer getPaydaysValue() {
      Integer r = 0;
      if (String.isNotBlank(this.paydays) && this.paydays.isNumeric()) {
        r = Integer.valueOf(this.paydays);
      }
      return r;
    }

  }

}