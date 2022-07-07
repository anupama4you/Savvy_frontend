public without sharing class QuotePepperMVController {
  
  @AuraEnabled
  public static QuoteController.AppQuotingWraper getQuotingData(
    QuoteController.QuotingDataParam param
  ) {
    QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

    // Lender settings
    // Rate Settings
    String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
      ? param.rateSettings.get(0) : 'PepperRate__c';
    
    Map<String, List<PepperRate__c>> rates = new Map<String, List<PepperRate__c>>();
    rates.put(rateObjName, getRates());
    r.rateSettings = rates;

    return r;
  }

  public static List<PepperRate__c> getRates() {
    return [
      SELECT 
        Id, Product__c, Tier__c, Rate0__c, 
        Rate1__c, Rate2__c, Rate3__c
      FROM PepperRate__c
      WHERE Product__c IN ('MV', 'CARAVAN')
      ORDER BY Product__c DESC, Name
    ];
  }

}