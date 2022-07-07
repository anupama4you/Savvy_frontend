public class CompToolLibertyCalc extends CompToolLenderCalcAbstract {

  public CompToolLibertyCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Prepare parameters
    this.quoteParam.productLoanType = 'Consumer Loan';
    
    // Client Tier
    if ('Property Owner'.equals(param.residentialStatus)) {
      this.quoteParam.clientTier = 'AAA';
    } else if('Renting Real Estate'.equals(param.residentialStatus)){
      this.quoteParam.clientTier = 'AA'; 
    } else if('Renting Other'.equals(param.residentialStatus)){
      this.quoteParam.clientTier = 'A';
    }else{
      this.quoteParam.clientTier = 'C';
    }

    if (
      '400'.equals(param.creditHistory) ||
      param.creditHistory.containsIgnoreCase('Defaults')
    ) {
      this.quoteParam.clientTier = 'C';
    }
    
    if (param.assetAge == 0) {
      this.quoteParam.vehicleYear = 'New';
    } else if (param.assetAge <= 4) {
      this.quoteParam.vehicleYear = '0-4 years';
    } else if (param.assetAge <= 9) {
      this.quoteParam.vehicleYear = '5-9 years';
    } else {
      this.quoteParam.vehicleYear = '10+ years';
    }
    
    this.quoteParam.residualValue = param.residual;

    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Risk Grade ' + this.quoteParam.clientTier;
    return r;
  }
  
}