public class CompToolBoqCommCalc extends CompToolLenderCalcAbstract {

  public CompToolBoqCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.vehicleYear = this.param.assetAge == 0?  'New' : 'Used';
    
    if (
      'Cars'.equals(param.assetType) ||
      'Trucks'.equals(param.assetType) ||
      'Vans'.equals(param.assetType) ||
      'Buses'.equals(param.assetType)
    ) {
      this.quoteParam.goodsType = 'Cars/Trucks';
    } else if ('Yellow Goods'.equals(param.assetType)) {
      this.quoteParam.goodsType = 'Construction';
    } else {
      this.quoteParam.goodsType = 'Industrial Plant and Equipment';
    }

    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }
    this.quoteParam.paymentType = 'Advance';

    // - get base rates
    this.baseRateCalc(null);

    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}