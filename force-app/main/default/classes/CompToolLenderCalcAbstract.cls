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
    this.quoteParam.baseRate = QuotingCalculation.getBaseRate(this.quoteParam);
    this.quoteParam.maxRate = QuotingCalculation.getMaximunBaseRate(this.quoteParam);
    if (this.quoteParam.baseRate > 0.00 && clientRateFactor > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.baseRate + clientRateFactor;
    } else if (this.quoteParam.maxRate > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.maxRate;
    } else {
      this.quoteParam.clientRate = this.quoteParam.baseRate;
    }
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
    // } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    // }    
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
    public Integer creditScore { get; set; }
    @AuraEnabled
    public String verifiableSavings { get; set; }
    @AuraEnabled
    public String ltv { get; set; }

    // Lelo                 2018-05-29
    // public Integer applicantAge {set;get;}
    // public Decimal annualIncome {set;get;}
    // public String tier {set;get;}
    // public String riskGrade {set; get;}
    // public String customerProfile {set; get;}

    public FilterParams() {
      //Temp
      this.assetType = 'Car';
      this.loanType = 'Consumer Loan';
      this.employmentType = 'Full-Time';
      this.purchaseType = 'Dealer';
      this.creditHistory = 'Clean History';
      this.residentialStatus = 'Property Owner';
      //
      // this.assetCondition = 'New';
      this.assetAge = 0;
      this.term = 60;
      this.price = null;
      this.deposit = null;
      this.residual = null;

      this.ltv = '90-99';
      this.creditScore = 750;
      this.jobsLast3Years = 0;
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
  }

}