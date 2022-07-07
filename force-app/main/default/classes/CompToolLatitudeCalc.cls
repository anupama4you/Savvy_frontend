public class CompToolLatitudeCalc extends CompToolLenderCalcAbstract {

  public CompToolLatitudeCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    
    // - Prepare parameters
    if ('Car'.equals(param.assetType) || 'Motorbike'.equals(param.assetType)) {
      this.quoteParam.goodsType = 'Car/Motorbike';
    } else {
      this.quoteParam.goodsType = 'Boats, Personal Watercraft, Caravans, Camper Trailers, Motorhomes';
    }
    if (
      'Property Owner'.equals(this.param.residentialStatus) && 
      'Excellent'.equals(param.creditHistory)
    ) {
      this.quoteParam.loanTypeDetail = 'Diamond Plus';
    } else if (
      'Renting Real Estate'.equals(this.param.residentialStatus) && 
      'Excellent'.equals(param.creditHistory)
    ) {
      this.quoteParam.loanTypeDetail = 'Diamond';
    } else if (
      param.employmentType.containsIgnoreCase('casual') ||
      !param.creditHistory.containsIgnoreCase('Defaults') ||
      !param.creditHistory.containsIgnoreCase('400')
    ) {
      this.quoteParam.loanTypeDetail = 'Sapphire';
    } else {
      this.quoteParam.loanTypeDetail = 'Emerald';
    }
    this.quoteParam.carAge = param.assetAge;

    // - get base rates
    this.baseRateCalc(null);

    // Commission rate - client rate is required
    this.quoteParam.commRate = QuotingCalculation.getLatitudeRateCommission(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail;
    return r;
  }
  
}