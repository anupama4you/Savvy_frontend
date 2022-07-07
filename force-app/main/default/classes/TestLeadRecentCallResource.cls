@isTest
private class TestLeadRecentCallResource {
	
	@isTest static void testData() {
		RestRequest req = new RestRequest();
		req.params.put('tcall','5');
		RestContext.request = req;
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		//Create a lead
		Lead__c a = new Lead__c(
			First_Name__c = 'Testdsf', 
			Last_Name__c = 'Testsdf', 
			Finance_Amount__c = 123, 
			Email_Address__c = 'test2@test.com', 
			Status__c = 'New Lead',
			Is_Call_Center__c = true,
			OwnerId = UserInfo.getUserId());
		insert a;
		//Create a task
		Task newTask = new Task();
        newTask.OwnerId = UserInfo.getUserId();
        newTask.WhatId = a.Id;
        newTask.Subject = 'Voice call from ANI [0400000000] on bla, bla, bla';
        newTask.TaskSubtype = 'Task';
        newTask.Status = 'Completed';
        newTask.IsReminderSet = false;
        insert newTask;
        // Task for an opportunity
        newTask = new Task();
        newTask.OwnerId = UserInfo.getUserId();
        newTask.WhatId = o.Id;
        newTask.Subject = 'Voice call from ANI [0400000000] on bla, bla, bla';
        newTask.TaskSubtype = 'Task';
        newTask.Status = 'Completed';
        newTask.IsReminderSet = false;
        insert newTask;
		test.startTest();
		LeadRecentCallResource.getData();
		test.stopTest();
	}
	
}