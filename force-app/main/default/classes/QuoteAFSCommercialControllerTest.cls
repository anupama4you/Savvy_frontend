@isTest
private class QuoteAFSCommercialControllerTest {
    @testSetup static void setup() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.createOpportunity();
        
        AFS_Commercial_Rates__c setting = new AFS_Commercial_Rates__c();
        setting.Name = 'a';
        setting.Comm_07_Years__c  = 0.50;
        setting.Comm_8_Years__c  = 0.50;
        setting.Rate__c   = 7.70;
        setting.Rate_2__c   = 10.95;
        insert setting;
    }
    
    private static QuotingCalculation.CalcParam getParams(){
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.vehiclePrice = 500000.00;
        param.netDeposit = 50000.00;
        param.brokeragePer = 8;
        param.lender = 'AFS Commercial';
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
        test.startTest();
        QuoteController.AppQuotingWraper res = QuoteAFSCommercialController.getQuotingData(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void calcRepaymentsTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        param.commRate = QuoteAFSCommercialController.getCommissionRate(param);
        test.startTest();
        Application_Quoting_Result__c res = QuoteAFSCommercialController.calculateRepayments(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getRatesTestMethod() {
        test.startTest();
        Map<String, List<QuoteAFSCommercialController.AfsRate>> res = QuoteAFSCommercialController.getRates();
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getAFSRatesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        List<QuoteAFSCommercialController.AfsRate> res = QuoteAFSCommercialController.getAFSRates(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
}