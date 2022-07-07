public with sharing class ANZInterviewGuideExtension {
  Custom_Opportunity__c o {set;get;}
  public Application_Quoting__c q {set;get;}
  public Boolean assetPersUse {set;get;}
  public Boolean assetBusiUse {set;get;}
  public Boolean assetNew {set;get;}
  public Boolean assetUsed {set;get;}
  public Boolean trueValue {set;get;}
  public Boolean falseValue {set;get;}
  public Boolean depositYes {set;get;}
  public Boolean depositNo {set;get;}
  public Boolean tradeInYes {set;get;}
  public Boolean tradeInNo {set;get;}
  public Boolean payoutYes {set;get;}
  public Boolean payoutNo {set;get;}
  public Boolean balanceYes {set;get;}
  public Boolean balanceNo {set;get;}
  public Boolean balloonYes {set;get;}
  public Boolean balloonNo {set;get;}
  public Boolean insuranceYes {set;get;}
  public Boolean insuranceNo {set;get;}
  public Boolean showDocument {set;get;}
  public ANZInterviewGuideExtension(ApexPages.StandardController ctrl) {
    o = (Custom_Opportunity__c)ctrl.getRecord ();
    //Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(o.Application__c, 'Quoting Calculation (Formal Approval)');
    //if (a != null) {
      //q = (Application_Quoting__c)JSON.deserialize(a.Data__c, Application_Quoting__c.class);
      q = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
      if (q != null) {
        if (q.Name.contains('ANZ')) {
          showDocument = true;
        } else {
          q = null;
        }
      }
    //}
    loadData();
  }
  private void loadData() {
    //Global
    trueValue = true;
    //Opportunity Data
    assetNew = 'New'.equals(o.New_Used__c);
    assetUsed = 'Used'.equals(o.New_Used__c);
    if (q != null) {
        assetPersUse = false;
        assetBusiUse = false;
        if ('Consumer Loan'.equals(q.Loan_Product__c)) {
          assetPersUse = true;
        } else if (q.Loan_Product__c.contains('Chattel') || q.Loan_Product__c.contains('Lease')) {
          assetBusiUse = true;
        }
        System.debug(assetPersUse + '|' + assetBusiUse + '|' + q.Loan_Product__c);
        if (q.Deposit__c > 0) {
            depositYes = true;
        } else {
            depositNo = true;
        }
        if (q.Trade_In__c > 0) {
            tradeInYes = true;
        } else {
            tradeInNo = true;
        }
        if (q.Payout_On__c > 0) {
            payoutYes = true;
        } else {
            payoutNo = true;
        }
        if (q.Trade_In__c != null && q.Payout_On__c != null && (q.Trade_In__c - q.Payout_On__c) < 0) {
            balanceYes = true;
        } else {
            balanceNo = true;
        }
        if (q.Residual_Value__c > 0) {
            balloonYes = true;
        } else {
            balloonNo = true;
        }
        if (getTotalOtherInsurances() > 0 || q.Insurance_MV_Retail_Price__c > 0) {
            insuranceYes = true;
        } else {
            insuranceNo = true;
        }
    }
  }
  public Decimal getTotalOtherInsurances() {
    Decimal r = 0.0;
    if (q != null) {
        if (q.Insurance_GAP_Retail_Price__c != null) r += q.Insurance_GAP_Retail_Price__c;
        if (q.Insurance_Warranty_Retail_Price__c != null) r += q.Insurance_Warranty_Retail_Price__c;
        if (q.Insurance_LTI_Retail_Price__c != null) r += q.Insurance_LTI_Retail_Price__c;
        if (q.Insurance_Truck_GAP_Retail_Price__c != null) r += q.Insurance_Truck_GAP_Retail_Price__c;
        if (q.Insurance_TAI_Retail_Price__c != null) r += q.Insurance_TAI_Retail_Price__c;
        if (q.Insurance_AIC_Retail_Price__c != null) r += q.Insurance_AIC_Retail_Price__c;
        if (q.Insurance_NWC_Retail_Price__c != null) r += q.Insurance_NWC_Retail_Price__c;
    }
    return r;
  }
  public void saveRecord() {}
}