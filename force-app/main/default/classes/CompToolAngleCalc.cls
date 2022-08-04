public class CompToolAngleCalc extends CompToolLenderCalcAbstract {

  public CompToolAngleCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.assetType = 'MV & Primary';
    this.quoteParam.assetAge = String.valueOf(this.param.assetAge);
    this.quoteParam.endOfTerm = this.param.getAssetYearsAfterTerm();
    this.quoteParam.abnLength = 'ABN 2+';

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.assetType = this.param.customValue1;
    }

    this.quoteParam.customerProfile = 
      'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    if ('Y'.equals(this.quoteParam.privateSales)) {
      this.quoteParam.applicationFee = this.lenderSettings.Application_Fee_Private__c;
    }
    this.quoteParam.totalAmount = this.getTotalAmount();

    this.setBrokerageValue();

    // - get base rates
    this.baseRateCalc(null); 

    // - get client rate
    this.quoteParam.amountBaseComm = this.getTotalAmount(); 
    this.quoteParam.amountBasePmt = this.getTotalAmount();
    this.quoteParam.amountBasePmt += this.getTotalAmount() * this.quoteParam.brokeragePer / 100 * 0.9319;
    this.quoteParam.clientRate = QuotingCalculation.getClientRateCalculation(this.quoteParam);

    
    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Asset type: ' + this.quoteParam.assetType;
    // Custom Options
    r.customValue1 = this.quoteParam.assetType;
    r.customLabel1 = 'Asset type';
    r.customValue1Options = new List<String>{
      'MV & Primary', 'Secondary', 'Tertiary'
    };
    return r;
  }
  
}