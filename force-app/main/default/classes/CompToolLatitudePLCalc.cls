public class CompToolLatitudePLCalc extends CompToolLenderCalcAbstract {

  public CompToolLatitudePLCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    if (
      'Property Owner'.equals(this.param.residentialStatus) && 
      'Good'.equals(param.creditHistory)
    ) {
      this.quoteParam.loanTypeDetail = 'AAA';
      this.quoteParam.customerProfile = 'Secured';
    } else if (
      'Renting'.equals(this.param.residentialStatus) && 
      'Good'.equals(param.creditHistory)
    ) {
      this.quoteParam.loanTypeDetail = 'AA';
      this.quoteParam.customerProfile = 'Secured';
    } else if (
      param.employmentType.containsIgnoreCase('casual') ||
      !param.creditHistory.containsIgnoreCase('Issues')
    ) {
      this.quoteParam.loanTypeDetail = 'A';
      this.quoteParam.customerProfile = 'Unsecured';
    } else {
      this.quoteParam.loanTypeDetail = 'C';
      this.quoteParam.customerProfile = 'Unsecured';
    }
    
    // Custom Value 1
    // if (String.isNotBlank(this.param.customValue1)) {
    //   this.quoteParam.clientTier = this.param.customValue1;
    // }

    // - get base rates
    this.baseRateCalc(null);

    // - Client rate
    this.quoteParam.clientRate = this.quoteParam.baseRate + this.lenderSettings.Client_Rate_Factor__c;

    this.quoteParam.commRate = this.lenderSettings.Commission_Rate__c;
    this.quoteParam.totalAmount = this.getTotalAmount();
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail + ' / ' + this.quoteParam.customerProfile;

    // Custom Options
    // r.customValue1 = this.quoteParam.clientTier;
    // r.customLabel1 = 'Tier';
    // r.customValue1Options = new List<String>{
    //   'A', 'B', 'C'
    // };

    return r;
  }
  
  public override Decimal getTotalAmount() {
    Decimal r = super.getTotalAmount();
    r += this.lenderSettings.Registration_Fee__c > 0? this.lenderSettings.Registration_Fee__c : 0.00;
    return r;
  }

}