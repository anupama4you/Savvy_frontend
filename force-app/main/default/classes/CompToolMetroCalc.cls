public class CompToolMetroCalc extends CompToolLenderCalcAbstract {

  public CompToolMetroCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.loanTypeDetail = 'Truck'.equals(this.param.assetType) 
      ? 'Heavy Commercial Vehicles' : 'Passenger and Commercial Vehicles';

    this.quoteParam.clientTier = 'Option 1';
    MetroPlanOption__c plan = QuotingCalculation.getMetroPlanOptions().get(this.quoteParam.clientTier);
    if (plan != null) {
      this.quoteParam.applicationFee = plan.Application_Fee__c;
      this.quoteParam.dof = plan.DOF__c;
    }
    
    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.term = this.param.term;
    this.quoteParam.carAge = this.param.assetAge;
    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    this.quoteParam.saleBacksPurchased = 'N';
    this.quoteParam.condition = this.param.assetAge > 0? 'Used' : 'New/Demo';
    this.quoteParam.greenCar = 'N';
    
    // - get base rates
    this.baseRateCalc(null);    

    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100 * 1.025;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Plan Options: ' + this.quoteParam.clientTier;
    return r;
  }
  
}