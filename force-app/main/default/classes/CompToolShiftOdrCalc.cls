public class CompToolShiftOdrCalc extends CompToolLenderCalcAbstract {

  public CompToolShiftOdrCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.paymentType = 'Advance';
    
    this.setBrokerageValue();
    
    // - get base rates
    this.quoteParam.baseRate = this.lenderSettings.Default_Base_Rate__c;
    
    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    this.quoteParam.amountBaseComm = this.getNetLoanAmount();
    
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}