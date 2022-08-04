public class CompToolLenderResult {

  @AuraEnabled 
  public String details {set;get;}
  @AuraEnabled 
  public Decimal baseRate {set;get;}
  @AuraEnabled 
  public Decimal maxRate {set;get;}
  @AuraEnabled
  public Decimal clientRate {set;get;}
  @AuraEnabled
  public Decimal monthlyFee {set;get;}
  @AuraEnabled
  public Decimal surplus {set;get;}
  @AuraEnabled
  public Decimal lenderFees {set;get;}

  @AuraEnabled 
  public String customLabel1 {set;get;}
  @AuraEnabled 
  public String customValue1 {set;get;}
  @AuraEnabled 
  public String customLabel2 {set;get;}
  @AuraEnabled 
  public String customValue2 {set;get;}
  @AuraEnabled 
  public List<String> customValue1Options {set;get;}
  @AuraEnabled 
  public List<String> customValue2Options {set;get;}

  // Quoting
  @AuraEnabled
  public Decimal commission {
    get {
      return this.quote != null? this.quote.Estimated_Commission__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal dof {
    get {
      return this.quote != null? this.quote.DOF__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal monthlyPayment {
    get {
      return this.quote != null? this.quote.Monthly_Payment__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal naf {
    get {
      return this.quote != null? this.quote.NAF__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal rental {
    get {
      return this.quote != null? this.quote.Rental__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal fortnightlyPayment {
    get {
      return this.quote != null? this.quote.Fortnightly_Payment__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal totalCommission {
    get {
      return this.quote != null? this.quote.Total_Commission__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal totalCommissionGst {
    get {
      return this.quote != null? this.quote.Total_Commission_Gst__c : 0.00;
    }
  }
  @AuraEnabled
  public Decimal weeklyPayment {
    get {
      return this.quote != null? this.quote.Weekly_Payment__c : 0.00;
    }
  }

  public Application_Quoting_Result__c quote {set;get;}

  public CompToolLenderResult() {
    this.baseRate = 0.00;
    this.maxRate = 0.00;
    this.clientRate = 0.00;
    this.monthlyFee = 0.00;
    this.surplus = 0.00;
    this.lenderFees = 0.00;
    // Quoting result
    this.quote = new Application_Quoting_Result__c();
    this.quote.Estimated_Commission__c = 0.00;
    this.quote.DOF__c = 0.00;
    this.quote.Monthly_Payment__c = 0.00;
    this.quote.NAF__c = 0.00;
    this.quote.Rental__c = 0.00;
    this.quote.Payment_Calc_Type__c = 'DF';
    this.quote.Result_Type__c = 'Q';
    this.quote.recalculateFormulas();
  }

}