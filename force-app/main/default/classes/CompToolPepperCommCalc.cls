public class CompToolPepperCommCalc extends CompToolLenderCalcAbstract {

  public CompToolPepperCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Prepare parameters
    this.quoteParam.productLoanType = 'Business';
    this.quoteParam.term = this.param.term;
    this.quoteParam.customerProfile = 'COMMERCIAL';
    
    if (
      'Car'.equals(this.param.assetType) ||
      'Caravan'.equals(this.param.assetType)
    ) {
      this.quoteParam.goodsType = this.param.assetType;
    } else {
      this.quoteParam.goodsType = 'Wheels & Tracks';
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
    
    // Asset age
    if (param.assetAge == 0) {
      this.quoteParam.vehicleYear = 'New';
    } else if (param.assetAge <= 5) {
      this.quoteParam.vehicleYear = 'Used 0-5 years';
    } else {
      this.quoteParam.vehicleYear = 'Used 6+ years';
    }
    
    this.quoteParam.privateSales = 'Private'.equals(this.param.purchaseType)? 'Y' : 'N';
    
    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Tier ' + this.quoteParam.clientTier;
    return r;
  }
  
}