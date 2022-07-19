public class CompToolWisrPLCalc extends CompToolLenderCalcAbstract {

  private Decimal applicationFee = 0.00;

  public CompToolWisrPLCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    if ('Good'.equals(param.creditHistory)) {
      this.quoteParam.vedascore = 750;
    } else {
      this.quoteParam.vedascore = 399;
    }
    this.quoteParam.term = param.term;
    
    // - get base rates
    this.baseRateCalc(null);

    this.quoteParam.amountBaseComm = this.param.price;

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    // r.details = 'Interest Type: ' + this.quoteParam.interestType;
    return r;
  }
  
}