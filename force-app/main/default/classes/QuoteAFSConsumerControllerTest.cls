@isTest
private class QuoteAFSConsumerControllerTest {
   @testSetup static void setup() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.createOpportunity();
        
        AFSRateV2__c setting = new AFSRateV2__c();
        setting.Name = 'A';
        setting.Asset_Type__c = 'Boats / Personal Watercraft';
        setting.Comm__c = 4.00;
        setting.Plan__c = 'Non-Property Owner - Other';
        setting.Base_Rate__c = 11.47;
        setting.Rate__c = 13.47;
        setting.Risk_Grade__c = '>= $35k';
        setting.Condition__c = 'New/Demo';
        insert setting;
    }
    
    private static QuotingCalculation.CalcParam getParams(){
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.vehiclePrice = 500000.00;
        param.netDeposit = 50000.00;
        param.brokeragePer = 8;
        param.lender = 'AFS Consumer';
        param.hasMaxRate = true;
        param.vehicleYear = '2022';
        param.clientTier = 'Gold';
        param.assetAge = 'New - 6 years old';
        param.clientRate = 12.00;
        param.term = 60;
        param.residualValue = 100;
        param.gst = 'Not Registered';
        return param;
    }
    
    @isTest static void getQuotingTestMethod() {
        QuoteController.QuotingDataParam param = new QuoteController.QuotingDataParam();
        List<String> fields = new List<String>();
        fields.add('Loan_Type__c');
        fields.add('Loan_Product__c');
        param.oppId = [SELECT Id FROM Custom_Opportunity__c LIMIT 1 ].Id;
        param.fields = fields;
        param.rateSettings = new List<string>{'AFSRateV2__cs'};
        test.startTest();
        QuoteController.AppQuotingWraper res = QuoteAFSConsumerController.getQuotingData(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getAppsTestMethod() {
        
        Id oppId = [SELECT Id FROM Custom_Opportunity__c LIMIT 1 ].Id;
        test.startTest();
        Map<String, String> res = QuoteAFSConsumerController.getApplications(oppId);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void calcRepaymentsTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        param.commRate = QuotingCalculation.getAFSRateCommission(param);
        test.startTest();
        Application_Quoting_Result__c res = QuoteAFSConsumerController.calculateRepayments(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
     @isTest static void getRatesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Map<String, Decimal> res = QuoteAFSConsumerController.getBaseRates(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }

}