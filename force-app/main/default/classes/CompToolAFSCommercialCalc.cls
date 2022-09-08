public class CompToolAFSCommercialCalc extends CompToolLenderCalcAbstract {

  public CompToolAFSCommercialCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.gstLength = (
      String.isNotBlank(this.param.gstRegistered) &&
      !'N'.equals(this.param.gstRegistered)
    ) ? 'Registered' : 'Not Registered';
    
    this.quoteParam.residency = 'Property Owner'.equals(param.residentialStatus)
      ? 'Home Buyer' : 'Non-Home Buyer';
    
    this.quoteParam.productLoanType = 'Chattel Mortgage-Full-Doc';

    // - Prepare parameters
    this.quoteParam.assetAge = param.assetAge <= 6
      ? 'New - 6 years old' : 'Used 7 years+';
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.gstLength = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);

    // - Client rate
    this.quoteParam.clientRate = this.quoteParam.baseRate + this.lenderSettings.Client_Rate_Factor__c;


    this.quoteParam.commRate = QuotingCalculation.getAFSCommercialCommission(this.quoteParam);

    this.quoteParam.totalAmount = this.getTotalAmount();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'GST: ' + this.quoteParam.gstLength;

    // Custom Options
    r.customValue1 = this.quoteParam.gstLength;
    r.customLabel1 = 'GST';
    r.customValue1Options = new List<String>{
      'Registered', 'Not Registered'
    };

    return r;
  }

  public override Decimal getTotalAmount() { 
    Decimal r = super.getTotalAmount();
    r += this.lenderSettings.Registration_Fee__c > 0? this.lenderSettings.Registration_Fee__c : 0.00;
    return r;
  }
  
}