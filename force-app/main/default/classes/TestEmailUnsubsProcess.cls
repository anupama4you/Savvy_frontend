@isTest
private class TestEmailUnsubsProcess {
	
	@isTest static void test_method_one() {

		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;

		Customer_Unsubscription__c cu = new Customer_Unsubscription__c();
		cu.Name = o.Name;
		cu.ID__c = o.Id;
		cu.Object_Type__c = 'OPP';
		cu.Status__c = 'R';
		insert cu;

		EmailUnsubscriptionProcess e = new EmailUnsubscriptionProcess();
		e.execute(null);
		e.execute(null);
		

	}
		
}