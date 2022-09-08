@isTest
private class QuoteFirstmacControllerTest {
    @testSetup static void setup() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.createOpportunity();
    }
    
    private static QuotingCalculation.CalcParam getParams(){
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.vehiclePrice = 500000.00;
        param.netDeposit = 50000.00;
        param.lender = 'Firstmac';
        param.hasMaxRate = true;
        param.vehicleYear = '2022';
        return param;
    }

    @isTest static void getQuotingTestMethod() {
        QuoteController.QuotingDataParam param = new QuoteController.QuotingDataParam();
        List<String> fields = new List<String>();
        fields.add('Loan_Type__c');
        fields.add('Loan_Product__c');
        param.oppId = [SELECT Id FROM Custom_Opportunity__c LIMIT 1 ].Id;
        param.fields = fields;
        param.rateSettings = new List<String>{'FirstmacRate__c'};
        test.startTest();
        QuoteController.AppQuotingWraper res = QuoteFirstmacController.getQuotingData(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }

    @isTest static void getBaseRatesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Map<String, Decimal> res = QuoteFirstmacController.getBaseRates(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
}