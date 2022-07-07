public class CompToolMacquarieCommercialCalc extends CompToolLenderCalcAbstract {

  public CompToolMacquarieCommercialCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.ltv = '100';
    this.quoteParam.customerProfile = 'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    this.quoteParam.term = this.param.term;
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    this.quoteParam.totalAmount = this.getTotalAmount();
    if ('Car'.equals(this.param.assetType)) {
      this.quoteParam.goodsType = 'MOTOV';
    } else if (
      'Motorbike'.equals(this.param.assetType) ||
      'boat'.equals(this.param.assetType) ||
      'Caravan'.equals(this.param.assetType)
    ) {
      this.quoteParam.goodsType = 'LIFES';
    } else {
      this.quoteParam.goodsSubType = 'PLANT';
    }
    
    Integer y = Date.today().year();
    Integer vyFactor = this.param.assetAge > 4? 4 : this.param.assetAge;
    this.quoteParam.vehicleYear = String.valueOf(y - vyFactor);

    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }
    this.quoteParam.productLoanType = 'Commercial';
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