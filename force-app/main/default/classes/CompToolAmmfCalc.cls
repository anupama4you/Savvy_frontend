public class CompToolAmmfCalc extends CompToolLenderCalcAbstract {

  public CompToolAmmfCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.loanTypeDetail = 'Prime Plus';
    this.quoteParam.customerProfile = this.param.assetAge == 0
      ? 'New' : 'Used';
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    this.quoteParam.totalAmount = this.getTotalAmount();
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);    

    // Commission rate
    this.quoteParam.commRate = QuotingCalculation.getYamahaCommission(this.quoteParam);


    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Profile: ' + this.quoteParam.loanTypeDetail;
    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Profile';
    r.customValue1Options = new List<String>{
      'Prime Plus', 'Prime', 'Standard', 'Limited'
    };
    return r;
  }
  
}