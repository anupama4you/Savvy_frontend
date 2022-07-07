@isTest
private class TestTrgInsuranceQuoteA {
	
	@isTest static void testprocessNotification() {
		test.startTest();
		Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        update quoting;

		quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_DECIDING;
		update quote;
		quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
		update quote;
	}

}