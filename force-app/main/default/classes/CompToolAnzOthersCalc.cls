public class CompToolAnzOthersCalc extends CompToolLenderCalcAbstract {

  public CompToolAnzOthersCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.goodsType = 'Trucks'.equals(this.param.assetType) 
      ? 'chattel' : 'equipment';
    Integer years = 'chattel'.equals(this.quoteParam.goodsType)
      ? 3 : 1;
    this.quoteParam.vehiclesProfile = this.param.assetAge <= years
      ? 'New' : 'Used';
    this.quoteParam.paymentType = 'Advance';
    
    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }

    // - get base rates
    this.baseRateCalc(null); 

    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100 * 0.9319;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    
    if (this.quoteParam.baseRate > 0) {
      this.quoteParam.clientRate = this.quoteParam.baseRate + 2;
    }

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Brokerage: ' + this.quoteParam.brokeragePer.format() + '%';
    return r;
  }
  
}