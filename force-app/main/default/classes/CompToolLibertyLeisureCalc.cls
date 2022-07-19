public class CompToolLibertyLeisureCalc extends CompToolLenderCalcAbstract {

  public CompToolLibertyLeisureCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Prepare parameters
    this.quoteParam.productLoanType = 'Consumer Loan';
    this.quoteParam.goodsType = this.param.assetType;
    
    // Client Tier
    if ('Property Owner'.equals(param.residentialStatus)) {
      this.quoteParam.clientTier = 'AAA';
    } else if('Renting'.equals(param.residentialStatus)){
      this.quoteParam.clientTier = 'AA'; 
    } else {
      this.quoteParam.clientTier = 'C';
    }

    if (param.creditHistory.containsIgnoreCase('Issues')) {
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

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.clientTier = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Risk Grade ' + this.quoteParam.clientTier;

    // Custom Options
    r.customValue1 = this.quoteParam.clientTier;
    r.customLabel1 = 'Risk Grade';
    r.customValue1Options = new List<String>{
      'AAA', 'AA', 'A+'
    };

    return r;
  }
  
}