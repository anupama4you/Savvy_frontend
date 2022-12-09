public class CompToolMorrisCalc extends CompToolLenderCalcAbstract {

  public CompToolMorrisCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.totalAmount = this.getTotalAmount();

    this.setBrokerageValue();

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