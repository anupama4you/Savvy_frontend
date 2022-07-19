public class CompToolNowFinanceCalc extends CompToolLenderCalcAbstract {

  public CompToolNowFinanceCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.loanTypeDetail = 
      'Property Owner'.equals(this.param.residentialStatus)
      ? 'Secured' : 'Unsecured';
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }
    
    // - get base rates
    this.baseRateCalc(null);

    // - Client rate
    this.quoteParam.clientRate = this.quoteParam.baseRate + this.lenderSettings.Client_Rate_Factor__c;

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Security: ' + this.quoteParam.loanTypeDetail;

    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Security';
    r.customValue1Options = new List<String>{
      'Secured', 'Unsecured'
    };

    return r;
  }
  
}