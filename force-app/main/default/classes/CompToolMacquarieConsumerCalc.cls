public class CompToolMacquarieConsumerCalc extends CompToolLenderCalcAbstract {

  public CompToolMacquarieConsumerCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.ltv = '100';
    this.quoteParam.customerProfile = 'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    this.quoteParam.term = param.term;
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    this.quoteParam.totalAmount = param.getNetVehiclePrice();
    this.quoteParam.goodsType = 'Car'.equals(this.param.assetType)? 'MOTOV' : 'LIFES';
    // this.quoteParam.goodsSubType = productGoodsSubType;
    Integer y = Date.today().year();
    Integer vyFactor = this.param.assetAge > 4? 4 : this.param.assetAge;
    this.quoteParam.vehicleYear = String.valueOf(y - vyFactor);
    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }
    this.quoteParam.productLoanType = 'Consumer Loan';
    
    // - get base rates
    this.baseRateCalc(null);

    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getNetLoanAmount() * this.quoteParam.brokeragePer / 100;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}