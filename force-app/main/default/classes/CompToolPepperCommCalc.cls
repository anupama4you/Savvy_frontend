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
      'Good'.equals(param.creditHistory) &&
      !param.employmentType.containsIgnoreCase('casual') &&
      !param.employmentType.containsIgnoreCase('Part-Time')
    ) {
      this.quoteParam.clientTier = 'A';
    } else {
      this.quoteParam.clientTier = 'B';
      if (
        param.employmentType.containsIgnoreCase('casual') ||
        param.creditHistory.containsIgnoreCase('Issues')
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
      'A', 'B', 'C'
    };
    
    return r;
  }
  
}