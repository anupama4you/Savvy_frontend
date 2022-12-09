public class CompToolApfCalc extends CompToolLenderCalcAbstract {

  public CompToolApfCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    this.quoteParam.applicationFee = this.getNetLoanAmount() * 0.10;
    if (this.quoteParam.applicationFee > lenderSettings.Application_Fee__c) {
      this.quoteParam.applicationFee = lenderSettings.Application_Fee__c;
    }

    this.quoteParam.dof = this.getNetLoanAmount() * 0.10;
    if (this.quoteParam.dof > lenderSettings.Max_DOF__c) {
      this.quoteParam.dof = lenderSettings.Max_DOF__c;
    }

    this.quoteParam.totalAmount = this.getTotalAmount();


    // - get base rates
    this.quoteParam.baseRate = this.lenderSettings.Default_Base_Rate__c;
    this.quoteParam.clientRate = this.quoteParam.baseRate;

    this.quoteParam.amountBaseComm = 0.00;

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}