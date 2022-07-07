@isTest(seeAllData=false)
private class TestTrgTaskAfterI {
	
	@isTest static void testDispositions() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;

		List<String> dispList = new List<String>();
		dispList.add('Appsent');
		dispList.add('Awatingp');
		dispList.add('Declined');
		dispList.add('Followup');
		dispList.add('Qsent');
		dispList.add('Settled');
		dispList.add('AdminCal');
		dispList.add('CCTM');
		dispList.add('CNBQ');
		dispList.add('SDFFR');

		for (String s :  dispList) {
			createTask(o.Id, s);
		}
	}
	
	private static void createTask(Id oppId, String calloutcome) {		
		Task t = new Task();
		t.OwnerId = UserInfo.getUserId();
		t.WhatId = oppId;
		t.Subject = 'Demo task lelo >> ' + System.currentTimeMillis();
		t.Description = 'Client Changed their Mind';
		t.Status = 'Completed';
		t.Priority = 'Normal';
		t.CallDurationInSeconds = 65;
		t.Call_Outcome__c = calloutcome;
		t.CallDisposition = 'DISPOSED';
		insert t;
	}
	
}