public without sharing class QuoteWisrPLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        String rateObjName1 = param.rateSettings.get(0);
        String rateObjName2 = param.rateSettings.get(1);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName1, getRates());
        rates.put(rateObjName2, getFees());
        r.rateSettings = rates;
        r.settings = QuotingCalculation.getLenderSettings(WisrCalculatorExtension.LENDER_QUOTING);
        return r;
    }

    public static List<Direct_Money_Rate__c> getRates() {
        List<Direct_Money_Rate__c> d = Direct_Money_Rate__c.getAll().values();
        d.sort();
        List<Direct_Money_Rate__c> r = new List<Direct_Money_Rate__c>();
        for (Direct_Money_Rate__c a : d) {
            if ('>= 90'.equals(a.LVR__c)) {
                r.add(a);
            }
        }
        return r;
    }

    public static List<Wisr_Fee_Rate__c> getFees() {
        List<Wisr_Fee_Rate__c> r = Wisr_Fee_Rate__c.getAll().values();
        r.sort();
        return r;
    }
}