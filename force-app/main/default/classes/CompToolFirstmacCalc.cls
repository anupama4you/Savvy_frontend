public class CompToolFirstmacCalc extends CompToolLenderCalcAbstract {

  public CompToolFirstmacCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.customerProfile = 'Standard';
    this.quoteParam.interestType = 'Variable';
    
    // - Prepare parameters
    this.quoteParam.residency = 
      'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    
    if ('Y'.equals(this.quoteParam.residency) && this.param.assetAge == 0) {
      this.quoteParam.loanTypeDetail = 'Prime Special Rate';
    } else if (this.param.assetAge <= 0) {
      this.quoteParam.loanTypeDetail = 'New and used < 5 years';
    } else if (this.param.assetAge <= 7) {
      this.quoteParam.loanTypeDetail = 'Used 6-7 years';
    } else {
      this.quoteParam.loanTypeDetail = 'Used 8-12 years';
    }
    
    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Interest Type: ' + this.quoteParam.interestType;
    return r;
  }
  
}