public with sharing class QuoteWisrVLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        String rateObjName = param.rateSettings.get(0);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        r.settings = QuotingCalculation.getLenderSettings(WisrVLCalcExtension.LENDER_QUOTING);
        return r;
    }

    public static List<WisrVL_Rates__c> getRates() {
        List<WisrVL_Rates__c> r = [
            SELECT
                Id,
                Profile__c,
                Credit_Score_Start__c,
                Credit_Score_End__c,
                Rate_1__c,
                Rate_2__c,
                Rate_3__c,
                Rate_4__c,
                Comparison_Rate__c
            FROM WisrVL_Rates__c
            ORDER BY Profile__c DESC, Credit_Score_Start__c DESC
        ];
        return r;
    }
}