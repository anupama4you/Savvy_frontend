public class CompToolPlentiCommCalc extends CompToolLenderCalcAbstract {

  public CompToolPlentiCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.assetType  = this.param.assetType;
    this.quoteParam.vehicleYear = String.valueOf(this.param.getAssetYear());
    this.quoteParam.customerProfile = 'Property Owner'.equals(this.param.residentialStatus) 
      ? 'Property Owner' : 'Non Property Owner';
    this.quoteParam.clientTier = 'Property Owner'.equals(this.quoteParam.customerProfile) 
      ? 'Tier 1' : 'Tier 2';
    this.quoteParam.condition = this.param.assetAge == 0? 'new' : 'used';
    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }

    // - get base rates
    this.baseRateCalc(null);   
    
    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    this.quoteParam.amountBaseComm = this.getNetLoanAmount();
    RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(this.quoteParam);
    if (rate != null) {
      this.quoteParam.commRate = rate.Overs__c;
    }

    // this.quoteParam.amountBaseComm = param.getNetVehiclePrice();
    // RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(this.quoteParam);
    // if (rate != null) {
    //   this.quoteParam.commRate = rate.Overs__c;
    // }

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.clientTier;
    return r;
  }
  
}