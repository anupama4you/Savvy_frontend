public class CompToolAnzCommCalc extends CompToolLenderCalcAbstract {

  public CompToolAnzCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.ltv = '100' ;
    this.quoteParam.term = this.param.term;

    if ('Property Owner'.equals(this.param.residentialStatus)) {
      this.quoteParam.customerProfile = this.param.assetAge <= 2
        ? 'Property Owner - New Car' : 'Property Owner - Old Car';
    } else {
      this.quoteParam.customerProfile = this.param.assetAge <= 2
        ? 'Non Property Owner - New Car' : 'Non Property Owner - Old Car';
    }
    this.quoteParam.adverseCredit = this.param.creditHistory.containsIgnoreCase('Issues') 
      ? 'Y' : 'N';

    // - get base rates
    this.baseRateCalc(null); 
    
    if (this.quoteParam.baseRate > 0) {
      this.quoteParam.clientRate = this.quoteParam.baseRate + 2;
    }

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}