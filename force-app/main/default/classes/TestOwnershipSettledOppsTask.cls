@isTest
public with sharing class TestOwnershipSettledOppsTask {
    @isTest static void testExecute() {
        // lead
        String sufix = String.valueOf(Datetime.now().millisecond());

        Custom_Opportunity__c o = new Custom_Opportunity__c(
            Name = 'Victor Eleven',
            Status__c = 'Unresolved Opportunity',
            Date_Closed_or_Settled__c = Datetime.now(),
            First_Name__c = 'Victor', 
			Last_Name__c = 'Eleven',
            Mobile_Number__c = '0477000' + sufix,
			Email_Address__c = sufix + 'v15@test.com'
        );
        insert o;

        Test.StartTest();
        Id jobId = System.schedule(
            'Testing task...', '0 0 0 3 9 ? 2022',
            new OwnershipSettledOppsTask());
        Test.stopTest();
    }
}