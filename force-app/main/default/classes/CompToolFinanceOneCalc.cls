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
    
    // - get base rates
    this.baseRateCalc(null);    

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail;
    return r;
  }
  
}