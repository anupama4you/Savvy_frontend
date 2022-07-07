public class CompToolPepperLeisureCalc extends CompToolLenderCalcAbstract {

  public CompToolPepperLeisureCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Prepare parameters
    this.quoteParam.productLoanType = 'Consumer Loan';
    this.quoteParam.term = param.term;
    this.quoteParam.customerProfile = 'MV';
    if ('Caravan'.equals(param.assetType)) {
      this.quoteParam.customerProfile = 'CARAVAN';
    }

    // Client Tier
    if (
      'Property Owner'.equals(param.residentialStatus) &&
      'Excellent'.equals(param.creditHistory) &&
      !param.employmentType.containsIgnoreCase('casual') &&
      !param.employmentType.containsIgnoreCase('Part-Time')
    ) {
      this.quoteParam.clientTier = 'A';
    } else {
      this.quoteParam.clientTier = 'B';
      if (
        param.employmentType.containsIgnoreCase('casual') ||
        param.creditHistory.containsIgnoreCase('Defaults') ||
        param.creditHistory.containsIgnoreCase('400')
      ) {
        this.quoteParam.clientTier = 'C';
      }
    }
    
    if (param.assetAge == 0) {
      this.quoteParam.vehicleYear = 'New';
    } else if (param.assetAge <= 5) {
      this.quoteParam.vehicleYear = 'Used 0-5 years';
    } else if (param.assetAge <= 9) {
      this.quoteParam.vehicleYear = 'Used 6-9 years';
    } else {
      this.quoteParam.vehicleYear = 'Used 10+ years';
    }
    
    this.quoteParam.goodsType = param.assetType;
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    
    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Tier ' + this.quoteParam.clientTier;
    return r;
  }
  
}