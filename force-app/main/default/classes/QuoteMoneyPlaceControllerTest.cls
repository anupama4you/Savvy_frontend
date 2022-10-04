@isTest(SeeAllData=true)
private class QuoteMoneyPlaceControllerTest {
    Test_DataGeneratorHelper testDataGenerator = new Test_DataGeneratorHelper();

    @isTest static void testSave(){
        test.startTest();
        String approvalType = 'NONE';
        Map<String, Application_Quoting_Result__c> res = new Map<String, Application_Quoting_Result__c>();
        Application_Quoting__c appQuote = generateAppQuote();
        Application_Quoting_Result__c appQuoteResult = generateAppQuoteResult(appQuote.Id);
        res.put('commissions', appQuoteResult);
        QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
        param.data = appQuote;
        param.results = res;
        QuoteMoneyPlaceController.save(param, approvalType);
        approvalType = 'PRE-APPROVAL';
        QuoteMoneyPlaceController.save(param, approvalType);
        test.stopTest();
    }

    private static Application_Quoting_Result__c generateAppQuoteResult(Id appQuoteId){
        Application_Quoting_Result__c appQuoteRes = new Application_Quoting_Result__c(); 
        appQuoteRes.Application_Quoting__c = appQuoteId;
        appQuoteRes.Estimated_Commission__c = 0;
        appQuoteRes.Insurance_Income__c = 0;
        appQuoteRes.DOF__c = 900.0;
        appQuoteRes.NAF__c = 14335.0;
        appQuoteRes.Rental__c = 121.79;
        appQuoteRes.Monthly_Payment__c = 221.79;

        return appQuoteRes;
    }

    private static Application_Quoting__c generateAppQuote(){
        Application_Quoting__c appQuote = new Application_Quoting__c(); 
        Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(false);
        Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
        
        appQuote.Opportunity__c = opp.id;
        appQuote.Application__c = app.id;
        appQuote.Name = 'Money Place';
        appQuote.Vehicle_Price__c = 12345.0;
        appQuote.Application_Fee__c = 1000.0;
        appQuote.DOF__c = 990.0;
        appQuote.Residual_Value__c = 12000.0;
        appQuote.Client_Rate__c = 7.5;
        appQuote.Term__c = 60;
        appQuote.Monthly_Fee__c = 100;
        appQuote.Payment__c = 'Arrears';

        appQuote.Commission_Estimation__c = 0;
        appQuote.Commission_Insurance_Income__c = 0;
        appQuote.Commission_DOF__c = 900.0;
        appQuote.Commission_Total_GST_Exc__c = 900.0;
        appQuote.NAF__c = 14335.0;
        appQuote.Rental__c = 121.79;
        appQuote.Repayment_Monthly__c = 221.79;
        appQuote.Repayment_Fortnightly__c = 102.36;
        appQuote.Repayment_Weekly__c = 51.18;
        appQuote.Loan_Type__c = 'Purchase';
        appQuote.Loan_Product__c = 'Consumer Loan';
        appQuote.Loan_Purpose__c = 'haha';

        insert appQuote;
        return appQuote;
    }

}