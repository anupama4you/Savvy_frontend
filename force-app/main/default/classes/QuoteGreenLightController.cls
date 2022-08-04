public without sharing class QuoteGreenLightController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
      system.debug('==> getQuotingData param '+ param);  
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        system.debug('==> getQuotingData return value1 '+ r);
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'GreenLightRates__c';

        Map<String, List<GreenLightRates__c>> rates = new Map<String, List<GreenLightRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        system.debug('==> getQuotingData return value2 '+ r);
        return r;
    }

    public static List<GreenLightRates__c> getRates() {
        List<GreenLightRates__c> r = new List<GreenLightRates__c>();
        List<GreenLightRates__c> rates = GreenLightRates__c.getAll().values();
        r.sort();
        for (GreenLightRates__c g: rates) {
          if (String.isBlank(g.LVR__C)) {
            r.add(g);
          }
        }
        return r;
    }
}