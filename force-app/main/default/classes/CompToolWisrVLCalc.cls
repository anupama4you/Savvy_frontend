public class CompToolWisrVLCalc extends CompToolLenderCalcAbstract {

  private Decimal applicationFee = 0.00;

  public CompToolWisrVLCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    // - Constant parameters
    this.quoteParam.ltv = '100';
    
    // - Prepare parameters
    this.quoteParam.vehicleYear = String.valueOf(param.getAssetYear());
    if ('Property Owner'.equals(param.residentialStatus)) {
      this.quoteParam.customerProfile = 'Home owner';
    } else {
      this.quoteParam.customerProfile = 'Renter, Boarder, Living at home with parents';
    }

    this.quoteParam.vedascore = this.param.getCreditScoreValue();
    // if ('Good'.equals(param.creditHistory)) {
    //   this.quoteParam.vedascore = 750;
    // } else {
    //   this.quoteParam.vedascore = 399;
    // }
    this.quoteParam.term = param.term;

    this.quoteParam.commRate = 4.0;
    if (this.quoteParam.vedascore >= 850 || this.quoteParam.term == 36) {
      this.quoteParam.commRate = 3.0;
    }
    
    // - get base rates
    this.baseRateCalc(null);

    this.quoteParam.dof = QuotingCalculation.getWisrVLMaxDOF(param.getNetVehiclePrice());
    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.applicationFee = QuotingCalculation.getWisrVLMaxAppFee(this.quoteParam.totalAmount);
    this.quoteParam.totalAmount = this.getTotalAmount();


    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    // r.details = 'Interest Type: ' + this.quoteParam.interestType;
    return r;
  }
  
  // public override Decimal getTotalAmount() {
  //   System.debug('Calculating total amount (override)...');
  //   Decimal r = 0.00;
  //   if (this.param != null) {
  //     r += this.param.price > 0? this.param.price : 0.00;
  //     r -= this.param.deposit > 0? this.param.deposit : 0.00;
  //   }
  //   r += this.applicationFee > 0? this.applicationFee : 0.00;    
  //   r += this.quoteParam.dof > 0? this.quoteParam.dof : 0.00;    
  //   return r;
  // }

}