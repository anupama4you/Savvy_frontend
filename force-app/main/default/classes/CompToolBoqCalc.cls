public class CompToolBoqCalc extends CompToolLenderCalcAbstract {

  public CompToolBoqCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.clientTier = 'Platinum Plus';
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.clientTier = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);

    this.quoteParam.commRate = QuotingCalculation.getBOQCommRate(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Risk Grade: ' + this.quoteParam.clientTier;
    // Custom Options
    r.customValue1 = this.quoteParam.clientTier;
    r.customLabel1 = 'Risk Grade';
    r.customValue1Options = new List<String>{
      'Platinum Plus', 'Platinum', 'Gold'
    };
    return r;
  }
  
}