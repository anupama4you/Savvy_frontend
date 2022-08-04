public class CompToolAffordableCalc extends CompToolLenderCalcAbstract {

  public CompToolAffordableCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.vehicleYear = String.valueOf(this.param.getAssetYear());
    
    this.quoteParam.creditScore = '0 - 499'.equals(this.param.creditScore) 
      ? '400-499' : '500+';
    this.quoteParam.creditScore = param.creditHistory.containsIgnoreCase('Issues') 
      ? '300-399' : this.quoteParam.creditScore;
    
    // - get base rates
    this.baseRateCalc(null);    

    // Commission rate
    this.quoteParam.amountBaseComm = this.getNetLoanAmount();
    ACLUpfrontLoanFees__c rate = QuotingCalculation.getAffordableFees(this.quoteParam.clientRate);
    if (rate != null) {
      this.quoteParam.commRate = rate.Comm__c;
    }        
    
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    
    return r;
  }
  
}