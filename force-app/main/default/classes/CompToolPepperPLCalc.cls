public class CompToolPepperPLCalc extends CompToolLenderCalcAbstract {

  public CompToolPepperPLCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    
    // - get base rates
    this.quoteParam.baseRate = this.lenderSettings.Default_Base_Rate__c;
    this.quoteParam.clientRate = this.lenderSettings.Default_Base_Rate__c;

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}