public class CompToolMoneyPlaceCalc extends CompToolLenderCalcAbstract {

  public CompToolMoneyPlaceCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    
    // - get base rates
    this.quoteParam.baseRate = this.lenderSettings.Default_Base_Rate__c;
    this.quoteParam.clientRate = this.lenderSettings.Default_Base_Rate__c;

    // DOF 
    this.quoteParam.amountBasePmt = this.getNetLoanAmount();
    this.quoteParam.dof = QuotingCalculation.getMoneyPlaceMaxDOF(this.quoteParam);
    this.quoteParam.totalAmount = this.getTotalAmount();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  


}