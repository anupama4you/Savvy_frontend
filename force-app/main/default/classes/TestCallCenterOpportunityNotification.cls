@isTest
public class TestCallCenterOpportunityNotification {
    
    @isTest static void testNotify() {
        String sufix = String.valueOf(Datetime.now().millisecond());
        Lead__c a = new Lead__c(
			First_Name__c = 'Victor', 
			Last_Name__c = 'Fiveteen', 
			Finance_Amount__c = 15000.0, 
			Mobile_Number__c = '0477000' + sufix,
			Email_Address__c = sufix + 'v15@test.com', 
			Status__c = 'New Lead',
			Loan_type__c = 'Car Loan',
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time',
            CC_Campaign_ID__c = 10,
            CC_Lead_ID__c = 999);
        insert a;

        Custom_Opportunity__c o = new Custom_Opportunity__c(
            Name = a.Name,
            Status__c = 'Become Opportunity',
            First_Name__c = a.First_Name__c,
            Last_Name__c = a.Last_Name__c,
            Mobile_Number__c = a.Mobile_Number__c,
            Email_Address__c = a.Email_Address__c
        );
        insert o;

        Test.StartTest();
        CallCenterOpportunityNotification.notify(new List<Custom_Opportunity__c>{o});
        Test.stopTest();
    }
}