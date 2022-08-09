public class CompToolGrowAssetCalc extends CompToolLenderCalcAbstract {

  public CompToolGrowAssetCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    if ('Car'.equals(this.param.assetType)) {
      this.quoteParam.assetType = 'Tier 1 - Cars';
    } else if ('Truck'.equals(this.param.assetType)) {
      this.quoteParam.assetType = 'Tier 2 - Trucks yellow goods';
    } else {
      this.quoteParam.assetType = 'Tier 3 - Specialised';
    }
    
    this.quoteParam.customerProfile = 
      'Property Owner'.equals(this.param.residentialStatus)? 'Y' : 'N';
    
    this.quoteParam.ltv = '100';
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    
    this.quoteParam.equifaxScore = this.param.getCreditScoreValue();
   
    this.quoteParam.assetAge = String.valueOf(this.param.assetAge);
    this.quoteParam.condition = this.param.assetAge > 0 ? 'Used' : 'New';
    
    this.setBrokerageValue();

    this.quoteParam.paymentType = 'Advance';
    this.quoteParam.abnLength = this.param.getAbnLengthValue() >= 2? '> 24 months' : '> 12 months';

    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.abnLength = this.param.customValue1;
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
    r.details = 'ABN length ' + this.quoteParam.abnLength;
    // Custom Options
    r.customValue1 = this.quoteParam.abnLength;
    r.customLabel1 = 'ABN length';
    r.customValue1Options = new List<String>{
      '> 12 months', '> 24 months'
    };
    return r;
  }
  
}