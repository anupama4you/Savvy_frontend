public class CompToolFinanceOneCalc extends CompToolLenderCalcAbstract {

  public CompToolFinanceOneCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.productLoanType = 'Consumer Loan';
    this.quoteParam.loanTypeDetail = 'Gold';
    
    // - Prepare parameters
    
    this.quoteParam.totalAmount = param.getNetVehiclePrice();
    this.quoteParam.dof = QuotingCalculation.getFinanceOneDofCalc(this.quoteParam);
    this.quoteParam.nafCommission = param.getNetVehiclePrice();

    this.quoteParam.totalAmount = this.getTotalAmount();    
    this.quoteParam.totalAmount += QuotingCalculation.getFinanceOneRiskFeeCalc(this.quoteParam);
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail;
    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Loan Type (Detail)';
    r.customValue1Options = new List<String>{
      'Platinum', 'Gold', 'Silver', 'Bronze', 'Economy'
    };
    return r;
  }
  
}