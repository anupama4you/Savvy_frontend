public class CompToolFinanceOneCommCalc extends CompToolLenderCalcAbstract {

  public CompToolFinanceOneCommCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.productLoanType = 'Commercial';
    this.quoteParam.loanTypeDetail = 'Platinum';
    
    // - Prepare parameters
    
    this.quoteParam.totalAmount = param.getNetVehiclePrice();
    this.quoteParam.dof = QuotingCalculation.getFinanceOneDofCalc(this.quoteParam);
    this.quoteParam.nafCommission = param.getNetVehiclePrice();

    this.quoteParam.totalAmount = this.getTotalAmount();    
    this.quoteParam.totalAmount += QuotingCalculation.getFinanceOneRiskFeeCalc(this.quoteParam);
    
    this.quoteParam.brokeragePer = 0.00;
    if (this.lenderSettings != null && this.lenderSettings.Brokerage_Base__c > 0.00) {
      this.quoteParam.brokeragePer = this.lenderSettings.Brokerage_Base__c;
    }

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);    

    // - get client rate
    this.quoteParam.clientRate = this.quoteParam.baseRate;
    if(this.quoteParam.brokeragePer > 4){
      this.quoteParam.clientRate = this.quoteParam.baseRate + this.quoteParam.brokeragePer - 4;
    }


    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail;
    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Loan Type (Detail)';
    r.customValue1Options = new List<String>{
      'Platinum', 'Gold', 'Silver'
    };
    return r;
  }
  
}