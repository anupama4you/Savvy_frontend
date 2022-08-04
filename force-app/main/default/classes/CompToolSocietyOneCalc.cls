public class CompToolSocietyOneCalc extends CompToolLenderCalcAbstract {

  public CompToolSocietyOneCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    this.quoteParam.customerProfile = 'Secured';
    this.quoteParam.clientTier = 'Tier 1';
    this.quoteParam.term = this.param.term;

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.clientTier = this.param.customValue1;
    }
    
    // - get base rates
    this.baseRateCalc(null);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Tier ' + this.quoteParam.clientTier;

    // Custom Options
    r.customValue1 = this.quoteParam.clientTier;
    r.customLabel1 = 'Tier';
    r.customValue1Options = new List<String>{
      'Tier 1', 'Tier 2', 'Tier 3', 'Tier 4'
    };

    return r;
  }
  
}