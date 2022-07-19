public class CompToolMoney3Calc extends CompToolLenderCalcAbstract {

  private Decimal riskFeeTotal = 0.00;

  public CompToolMoney3Calc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.hasImports = 'N';
    
    // - Prepare parameters

    this.quoteParam.riskGrade = String.valueOf(param.getAssetYear());
    if ('Good'.equals(param.creditHistory)) {
      this.quoteParam.riskGrade = 'Platinum';
    } else {
      this.quoteParam.riskGrade = 'Bronze';
    }

    // Risk fee
    this.quoteParam.customerProfile = 'Personal'.equals(param.assetType) 
      ? 'Personal Finance' : 'Asset Finance';
    this.quoteParam.totalAmount = param.getNetVehiclePrice();
    this.quoteParam.dof = QuotingCalculation.getMoney3maxDof(this.quoteParam);
    this.quoteParam.riskFeeBase = param.getNetVehiclePrice();
    this.riskFeeTotal = QuotingCalculation.getMoney3RiskFee(this.quoteParam);
    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.amountBaseComm = param.getNetVehiclePrice();

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.riskGrade = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);   
    
    this.quoteParam.amountBaseComm = param.getNetVehiclePrice();
    RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(this.quoteParam);
    if (rate != null) {
      this.quoteParam.commRate = rate.Overs__c;
    }

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.riskGrade;

    // Custom Options
    r.customValue1 = this.quoteParam.riskGrade;
    r.customLabel1 = 'Customer Grading';
    r.customValue1Options = this.getCustomerGrading(this.quoteParam.customerProfile);

    return r;
  }

  public override Decimal getTotalAmount() {
    System.debug('Calculating total amount (override)...');
    Decimal r = super.getTotalAmount();
    r += this.riskFeeTotal > 0? this.riskFeeTotal : 0.00;
    System.debug('@@Total amount (override): ' + r);
    return r;
  }
  
  public List<String> getCustomerGrading(String profile) {
    List<String> r = new List<String>{
      'Platinum', 'Gold', 'Silver', 'Bronze'
    };
    r.add('Asset Finance'.equals(profile)? 'Micro Motor' : 'Mini PL');
    return r;
  }

}