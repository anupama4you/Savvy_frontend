public without sharing class QuotePepperCommController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() ? param.rateSettings.get(0) : 'PepperRate__c';
        Map<String, List<PepperRate__c>> rates = new Map<String, List<PepperRate__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    private static List<PepperRate__c> getRates() {
        List<PepperRate__c> res = [SELECT Tier__c, Rate0__c, Rate1__c, Rate2__c, 
                                          Rate3__c
                                   FROM PepperRate__c
                                   WHERE Product__c = 'LEISURE'
                                   ORDER BY Name];
        System.debug(res);
        return res;
    }

}