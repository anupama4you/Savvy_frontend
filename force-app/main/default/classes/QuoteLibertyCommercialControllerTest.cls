@isTest(SeeAllData=true)
public with sharing class QuoteLibertyCommercialControllerTest {
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
        QuoteLibertyCommercialController.save(param, approvalType);
        approvalType = 'PRE-APPROVAL';
        QuoteLibertyCommercialController.save(param, approvalType);
        test.stopTest();
    }

    private static Application_Quoting_Result__c generateAppQuoteResult(Id appQuoteId){
        Application_Quoting_Result__c appQuoteRes = new Application_Quoting_Result__c(); 
        appQuoteRes.Application_Quoting__c = appQuoteId;
        appQuoteRes.Estimated_Commission__c = 302.54;
        appQuoteRes.Insurance_Income__c = 0;
        appQuoteRes.DOF__c = 1318.18;
        appQuoteRes.NAF__c = 11093.0;
        appQuoteRes.Rental__c = 115.34;
        appQuoteRes.Monthly_Payment__c = 125.34;

        return appQuoteRes;
    }

    private static Application_Quoting__c generateAppQuote(){
        Application_Quoting__c appQuote = new Application_Quoting__c(); 
        Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(false);
        Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
        
        appQuote.Opportunity__c = opp.id;
        appQuote.Application__c = app.id;
        appQuote.Name = 'Liberty Commercial';
        appQuote.Vehicle_Price__c = 12345.0;
        appQuote.Application_Fee__c = 1000.0;
        appQuote.DOF__c = 1450.0;
        appQuote.Residual_Value__c = 12000.0;
        appQuote.Client_Rate__c = 10.99;
        appQuote.Term__c = 60;
        appQuote.Monthly_Fee__c = 10;
        appQuote.Payment__c = 'Arrears';
        appQuote.LTV__c = '5';
        appQuote.Payout_On__c = 2000;
        appQuote.Credit_Score__c = '750+';
        appQuote.Residual_Value__c = 10000;
        appQuote.ABN__c = '>24 mths';
        appQuote.Vehicle_Age__c = 'New';
        appQuote.Goods_type__c = 'Car/Light commercial';
        appQuote.Trade_In__c = 1000;
        appQuote.Vehicles_Profile__c = '2022';
        appQuote.Application_Fee__c = 1995;
        appQuote.Customer_Profile__c = 'N';
        appQuote.Deposit__c = 4000;
        appQuote.PPSR__c = 8;
        appQuote.Client_Tier__c = 'A';
        appQuote.Base_Rate__c = 7.99;
        appQuote.GST__c = '>24 mths';

        appQuote.Commission_Estimation__c = 302.54;
        appQuote.Commission_Insurance_Income__c = 0;
        appQuote.Commission_DOF__c = 1318.18;
        appQuote.Commission_Total_GST_Exc__c = 1620.72;
        appQuote.NAF__c = 11093.0;
        appQuote.Rental__c = 115.34;
        appQuote.Repayment_Monthly__c = 125.34;
        appQuote.Repayment_Fortnightly__c = 62.67;
        appQuote.Repayment_Weekly__c = 31.34;
        appQuote.Loan_Type__c = 'Purchase';
        appQuote.Loan_Product__c = 'Chattel Mortgage-Full-Doc';

        insert appQuote;
        return appQuote;
    }
}