@isTest
private class TestApplicationIncomeService {
	
	@isTest static void testChangeFieldValues() {
		Test_DataGeneratorHelper.createApplication();
		Application__c app = Test_DataGeneratorHelper.tstAPP;
		Test.startTest();
		Application_Income__c ai = new Application_Income__c();
		ai.Application__c = app.Id;
		ai.Applicant__c = '1';
		ai.Detail__c = 'Any detail';
		ai.Frequency__c = null;
		ai.Income__c = 7500.0;
		ai.Type__c = 'Family Part A &amp; B';
		ApplicationIncomeService.changeFieldValues(new List<Application_Income__c>{ai});
		Test.stopTest();
	}
	
	@isTest static void testTrigger() {
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		List<Application__c> d = [Select Id, Name From Application__c limit 1];
		Application_Income__c ai = new Application_Income__c();
		ai.Application__c = d.get(0).Id;
		ai.Applicant__c = '1';
		ai.Detail__c = 'Any detail';
		ai.Frequency__c = 'Weekly';
		ai.Income__c = 7500.0;
		ai.Type__c = 'Family Part A &amp; B';
		insert ai;
		Test.stopTest();
	}
	
	@isTest static void testTriggerHandler() {
		Test.startTest();
		ApplicationIncomeTriggerHandler a = new ApplicationIncomeTriggerHandler();
		a.onBeforeInsert(new List<Application_Income__c>{new Application_Income__c()});
		Test.stopTest();
	}
	
}