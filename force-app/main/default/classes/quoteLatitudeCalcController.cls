public with sharing class quoteLatitudeCalcController {
 
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
        ? param.rateSettings.get(0) : 'LatitudeRatesv3__c';
          
        Map<String, List<LatitudeRatesv3__c>> rates = new Map<String, List<LatitudeRatesv3__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;

        return r;
    }

    private static List<LatitudeRatesv3__c> getRates() {
        List<LatitudeRatesv3__c> d = LatitudeRatesv3__c.getAll().values();
        d.sort();
        return d;
    }

}