public class CompToolAzoraCalc extends CompToolLenderCalcAbstract {

  public CompToolAzoraCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    Integer cs = this.param.getCreditScoreValue();

    
    if (cs >= 832) {
      this.quoteParam.loanTypeDetail = '832 - 1200';
    } else if (cs >= 725) {
      this.quoteParam.loanTypeDetail = '725 - 832';
    } else if (cs >= 621) {
      this.quoteParam.loanTypeDetail = '621 - 725';
    } else if (cs >= 509) {
      this.quoteParam.loanTypeDetail = '509 - 621';
    } else if (cs >= 400) {
      this.quoteParam.loanTypeDetail = '400 - 509';
    } else {
      this.quoteParam.loanTypeDetail = '0 - 400';
    }
    
    // Custom Value 1
    if (String.isNotBlank(this.param.customValue1)) {
      this.quoteParam.loanTypeDetail = this.param.customValue1;
    }
    
    // - get base rates
    this.baseRateCalc(null);
    this.quoteParam.clientRate = this.quoteParam.baseRate;
    
    Azora_Rates__c rateSel = QuotingCalculation.getAzora(this.quoteParam);
    if(rateSel != null){
      System.debug('@@rateSel: ' + JSON.serializePretty(rateSel));
      this.quoteParam.riskFee = rateSel.Risk_Fee__c > 0.00 ? rateSel.Risk_Fee__c : 0.00;
    }

    this.quoteParam.totalAmount = this.getTotalAmount();
    this.quoteParam.nafCommission = this.param.getNetVehiclePrice();

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = 'Type: ' + this.quoteParam.loanTypeDetail;

    // Custom Options
    r.customValue1 = this.quoteParam.loanTypeDetail;
    r.customLabel1 = 'Credit Score';
    r.customValue1Options = this.getCreditScoreOptions();
    
    return r;
  }
  
  public List<String> getCreditScoreOptions() {
    List<String> r = new List<String> ();
    List<Azora_Rates__c> d = [
      SELECT Credit_Score__c FROM Azora_Rates__c
      ORDER BY Name
    ];
    
    if (!d.isEmpty()) {
      for (Azora_Rates__c c: d) {
        r.add(c.Credit_Score__c);
      }
    }
    return r;
  }

}