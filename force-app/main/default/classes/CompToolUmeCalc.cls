public class CompToolUmeCalc extends CompToolLenderCalcAbstract {

  public CompToolUmeCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    this.quoteParam.dof = this.param.getNetVehiclePrice() * 0.11;
    if (this.quoteParam.dof > this.lenderSettings.Max_DOF__c) {
      this.quoteParam.dof = this.lenderSettings.Max_DOF__c;
    }

    // - get base rates
    this.quoteParam.baseRate = this.lenderSettings.Default_Base_Rate__c;
    this.quoteParam.clientRate = this.quoteParam.baseRate;
    
    this.quoteParam.totalAmount = this.getTotalAmount();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}