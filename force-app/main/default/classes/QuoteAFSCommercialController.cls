public with sharing class QuoteAFSCommercialController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        /*String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'GreenLightRates__c';

        Map<String, List<GreenLightRates__c>> rates = new Map<String, List<GreenLightRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;*/
        return r;
    }
}