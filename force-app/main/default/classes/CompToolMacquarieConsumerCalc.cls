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
    this.quoteParam.totalAmount = this.param.getNetVehiclePrice();
    this.quoteParam.goodsType = 'Car'.equals(this.param.assetType)? 'MOTOV' : 'LIFES';
    // this.quoteParam.goodsSubType = productGoodsSubType;
    Integer y = Date.today().year();
    Integer vyFactor = this.param.assetAge > 4? 4 : this.param.assetAge;
    this.quoteParam.vehicleYear = String.valueOf(y - vyFactor);
    
    // Brokerage Percentage
    this.setBrokerageValue(true);

    this.quoteParam.productLoanType = 'Consumer Loan';
    
    // - get base rates
    this.baseRateCalc(null);

    // - get client rate
    this.quoteParam.clientRate = this.quoteParam.baseRate;
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getNetLoanAmount() * this.quoteParam.brokeragePer / 100;
//     this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    this.quoteParam.totalAmount = this.getTotalAmount();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    // r.details = 'Brokerage: ' + this.quoteParam.brokeragePer + '%';
    return r;
  }
  
}