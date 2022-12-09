public without sharing class QuoteProspaController {
    public class Wrapper {
        @AuraEnabled
        public Application_Quoting__c data { set; get; }

        @AuraEnabled
        public Decimal brokerageInc { set; get; }

        @AuraEnabled
        public Decimal brokerageExc { set; get; }

    }

    @AuraEnabled
    public static Wrapper getQuotingData(QuoteController.QuotingDataParam param) {
        Wrapper r = new Wrapper();
        QuoteController.AppQuotingWraper aw = QuoteController.getQuotingData(param);
        r.data = aw.data;
        List<Custom_Opportunity__c> c = [SELECT Id, Loan_Product__r.Brokerage_GST_Inc__c
                                         FROM Custom_Opportunity__c
                                         WHERE id = :param.oppId];
        if ( c != null ) {
            r.brokerageInc = c.get(0).Loan_Product__r.Brokerage_GST_Inc__c;
        }
        return r;
    }

    @AuraEnabled
    public static Application_Quoting__c save(Wrapper param, String approvalType) {
        Application_Quoting__c aq = null;
        try {
            aq = saveQuoting(param);
            Product__c p = null;
            p = productHandler(param.data);
            saveProduct(param, p);
        } catch ( Exception ex ) {
            throw new GenericException(ex.getMessage());
        }
        return aq;
    }

    private static Application_Quoting__c saveQuoting(Wrapper param) {
        if ( param.data.Id != null ) {
            update param.data;
        } else {
            insert param.data;
        }
        List<Application_Quoting__c> apps = [Select id, Name, Opportunity__c, Commission_Total_GST_Exc__c, 
                                                    Commission_Total_GST_Inc__c, NAF__c
                                             From Application_Quoting__c
                                             Where Opportunity__c = :param.data.Opportunity__c];
        return apps.get(0);
    }

    private static void saveProduct(Wrapper param, Product__c p) {
        try {
            Custom_Opportunity__c opp = QuoteController.getOpportunityById(param.data.Opportunity__c);
            if ( p.Id == null ) {
                insert p;
                opp.Loan_Product__c = p.Id;
                update opp;
            } else {
                update p;
            }
            QuotingToolHelper.removePreviousInsurances(param.data.Opportunity__c);
        } catch ( Exception ex ) {
            throw new GenericException(ex.getMessage());
        }
    }

    private static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Business Use';
        p.Lender__c = 'Prospa';
        p.Quoting_Source__c = quote.Name;
        p.Loan_Type__c = 'Business Loan';
        p.Loan_Product__c = 'Business Loan';
        p.Brokerage__c = quote.Commission_Total_GST_Exc__c;
        p.Loan_Type_Detail__c = null;
        p.Loan_Term__c = 36;
        p.Balloon_Residual_Requested__c = 0.00;
        p.Client_Rate__c = 0.00;
        p.Repayment_Regularity__c = null;
        p.Loan_Number__c = null;
        p.Cost_of_Goods__c = 0.00;
        p.DOF__c	 = 0.00;
        p.Lender_App_Fee__c = 0.00;
        p.Deposit__c = 0.00;
        p.Equalisation_Fee_PPSR__c = 0.00;
        p.Payments__c = 0.00;

        return p;
    }

}