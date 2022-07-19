public with sharing class quoteLatitudePLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
        ? param.rateSettings.get(0) : 'LatitudePersonalRates__c';
        
        Map<String, List<LatitudePersonalRates__c>> rates = new Map<String, List<LatitudePersonalRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;

        return r;
    }

    public static List<LatitudePersonalRates__c> getRates() {
        List <LatitudePersonalRates__c> rates = LatitudePersonalRates__c.getAll().values();
        rates.sort();
        return rates;
    }

}