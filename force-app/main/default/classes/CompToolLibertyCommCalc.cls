public class CompToolLibertyCommCalc extends CompToolLenderCalcAbstract {

  public CompToolLibertyCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Prepare parameters
    this.quoteParam.productLoanType = 'Commercial';
    
    // Client Tier
    if ('Property Owner'.equals(this.param.residentialStatus)) {
      if ('Excellent'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'AAA';
      } else if ('600'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'AA';
      } else if ('524'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'A';
      } else if ('400'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'B';
      }
    } else {
      if (
        'Excellent'.equals(param.creditHistory) ||
        '600'.equals(param.creditHistory)
      ) {
        this.quoteParam.clientTier = 'A';
      } else if ('524'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'B';
      } else if ('400'.equals(param.creditHistory)) {
        this.quoteParam.clientTier = 'C';
      }      
    }
    if (
      param.creditHistory.containsIgnoreCase('Defaults')
    ) {
      this.quoteParam.clientTier = 'C';
    }
    // Asset age
    if (param.assetAge == 0) {
      this.quoteParam.vehicleYear = 'New';
    } else if (param.assetAge <= 4) {
      this.quoteParam.vehicleYear = '0-4 years';
    } else if (param.assetAge <= 9) {
      this.quoteParam.vehicleYear = '5-9 years';
    } else {
      this.quoteParam.vehicleYear = '10+ years';
    }

    this.quoteParam.residualValue = this.param.residual;

    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Risk Grade ' + this.quoteParam.clientTier;
    return r;
  }
  
}