public class CompToolCarStartCalc extends CompToolLenderCalcAbstract {

  public CompToolCarStartCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.loanTypeDetail = 'Mid-Prime Finance Only';
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }
    
    // - get base rates
    this.baseRateCalc(null);    
    
    CarStartFinanceRate__c rateSel = QuotingCalculation.getCarStartFinance(this.quoteParam);
    if(rateSel != null){
      this.quoteParam.dof = rateSel.Dof__c > 0.00? rateSel.Dof__c : 0.00;
      this.quoteParam.applicationFee = rateSel.App_Fee__c > 0.00 ? rateSel.App_Fee__c : 0.00;
      this.quoteParam.riskFee = rateSel.Risk_Fee__c > 0.00 ? rateSel.Risk_Fee__c : 0.00;
    }

    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.amountBaseComm = 500.00;
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Type: ' + this.quoteParam.loanTypeDetail;

    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Type of Finance';
    r.customValue1Options = this.getTypeOfFinance();
    
    return r;
  }
  
  public List<String> getTypeOfFinance() {
    List<String> r = new List<String> ();
    List<CarStartFinanceRate__c> d = [
      SELECT Type_of_Finance__c FROM CarStartFinanceRate__c
      ORDER BY Name
    ];
    
    if (!d.isEmpty()) {
      for (CarStartFinanceRate__c c: d) {
        r.add(c.Type_of_Finance__c);
      }
    }
    return r;
  }

}