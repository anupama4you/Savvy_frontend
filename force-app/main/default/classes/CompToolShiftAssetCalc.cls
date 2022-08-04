public class CompToolShiftAssetCalc extends CompToolLenderCalcAbstract {

  public CompToolShiftAssetCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.assetType  = 'Primary Assets';
    this.quoteParam.paymentType = 'Advance';
    
    if (this.param.assetAge <= 4) {
      this.quoteParam.assetAge = 'New to 4 years';
    } else if (this.param.assetAge <= 10) {
      this.quoteParam.assetAge = '5 - 10 years';
    } else {
      if (this.param.getAssetYearsAfterTerm() >= 20) {
        this.quoteParam.assetAge = '20+ years (age and term)';
      } else {
        this.quoteParam.assetAge = '11+ years';
      }
    }
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';

    if ('Refinance'.equals(this.param.purchaseType)) {
      this.quoteParam.loanType = 'Refinance';
    }

    this.quoteParam.customerProfile = 'Property Owner'.equals(param.residentialStatus)
      ? 'Y' : 'N';
    
    this.setBrokerageValue();
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.assetType = this.param.customValue1;
    }

    // - get base rates
    this.baseRateCalc(null);   
    
    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    this.quoteParam.amountBaseComm = this.getNetLoanAmount();
    
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.assetType;
    // Custom Options
    r.customValue1 = this.quoteParam.assetType;
    r.customLabel1 = 'Asset type';
    r.customValue1Options = new List<String>{
      'Primary Assets', 'Secondary Assets', 'Tertiary assets', 'Fitout Finance'
    };
    return r;
  }
  
}