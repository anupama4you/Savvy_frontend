public class CompToolGreenLightCalc extends CompToolLenderCalcAbstract {

  public CompToolGreenLightCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.ltv = '>90-100%';
    
    // - Prepare parameters
    if ('Excellent'.equals(param.creditHistory)) {
      this.quoteParam.clientTier = 'Platinum';
    } else if (param.creditHistory.containsIgnoreCase('Defaults')) {
      this.quoteParam.clientTier = 'Bronze';
    } else {
      this.quoteParam.clientTier = 'Gold';
    }
    this.quoteParam.totalAmount = this.getTotalAmount();

    this.quoteParam.assetType = 'Motorbike'.equals(this.param.assetType) ? 'Motorcycle' : this.param.assetType;
    this.quoteParam.vehicleYear = String.valueOf(param.getAssetYear());

    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';

    // - get base rates
    this.baseRateCalc(null);

    this.quoteParam.amountBaseComm = param.getNetVehiclePrice();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.clientTier;
    return r;
  }

  public override void baseRateCalc(Decimal clientRateFactor) {
    this.quoteParam.baseRate = 0.00;
    this.quoteParam.maxRate = 0.00;
    GreenLightRates__c rate = QuotingCalculation.getRateGreenLight(this.quoteParam);
    if (rate != null) {
      this.quoteParam.baseRate = rate.Base_Rate__c;
      this.quoteParam.maxRate = rate.Max_Rate__c;
      this.quoteParam.brokeragePer = rate.Brokerage_Max__c;
    }

    if (this.quoteParam.baseRate > 0.00 && clientRateFactor > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.baseRate + clientRateFactor;
    } else if (this.quoteParam.maxRate > 0.00) {
      this.quoteParam.clientRate = this.quoteParam.maxRate;
    } else {
      this.quoteParam.clientRate = this.quoteParam.baseRate;
    }

  }
  
}