@isTest
private class TestFollowingUpReportController {
	
	@isTest static void testReportDay0() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		// Creating activity details
		Task t = getMockCallTask(o.Id);
        t = new Task();
        t.WhatId = o.Id;
        t.TaskSubtype = 'Email';
        t.Status = 'Completed';
        insert t;
        mockSMSHistory(o.Id);
        c = new FollowingUpReportController();
        c.getData();
        System.assert(!c.getData().isEmpty());
        c.getData().get(0).getNotCallOpps();
        c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
        c.hideDetails();
        c.getDetailReportKeys();
        c.getReportKeys();
        List<FollowingUpReportController.DataReport> lst = new List<FollowingUpReportController.DataReport>();
        FollowingUpReportController.DataReport dp = new FollowingUpReportController.DataReport();
        dp.ownerName = null;
        lst.add(dp);
        dp = new FollowingUpReportController.DataReport();
        dp.ownerName = 'b';
        lst.add(dp);
        dp = new FollowingUpReportController.DataReport();
        dp.ownerName = 'a';
        lst.add(dp);
        dp = new FollowingUpReportController.DataReport();
        dp.ownerName = null;
        lst.add(dp);
        lst.sort();
        Test.stopTest();
	}

	@isTest static void testReportDay1() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Task t = getMockCallTask(o.Id);
        Test.setCreatedDate(t.Id, Datetime.now().addHours(-36));
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
		Test.stopTest();	
	}

	@isTest static void testReportDay2() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Task t = getMockCallTask(o.Id);
        Test.setCreatedDate(t.Id, Datetime.now().addHours(-50));
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
		Test.stopTest();	
	}

	@isTest static void testReportDay3() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Task t = getMockCallTask(o.Id);
        Test.setCreatedDate(t.Id, Datetime.now().addHours(-500));
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
		Test.stopTest();	
	}

	@isTest static void testClosedOppsReport() {
		System.debug('>>>>>>testClosedOppsReport');
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		o.Status__c = 'Closed Opportunity';
		o.Date_Closed_or_Settled__c = Datetime.now();
		o.Reason_for_Closure__c = 'Could not beat quote';
		update o;
		Task t = getMockCallTask(o.Id);
        Test.setCreatedDate(t.Id, Datetime.now().addHours(-36));
		PageReference pageRef = Page.FollowingUpReport;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('PROFILE', FollowingUpReportController.CLOSED_OPPS_PROFILE);
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
        c.getTeamOptions();
        c.nextPage();
        c.previousPage();
        c.lastPage();
        c.firstPage();
		Test.stopTest();	
	}

	@isTest static void testPrepareNotification() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Task t = getMockCallTask(o.Id);
        Test.setCreatedDate(t.Id, Datetime.now().addHours(-50));
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		c.ownerSelected = c.getData().get(0).ownerId;
        c.showDetails();
        c.prepareNotification();
        c.catSelected = FollowingUpReportController.getCategory(2);
        c.unselectAllCategory();
        c.selectAllCategory();
        c.oppSelected = o.Id;
        c.remOppNotification();
        c.addOppNotification();
        c.notification.Notes__c = null;
        c.sendNotification();
        c.notification.Notes__c = 'My notes';
        c.sendNotification();
        c.getTotalSelectedOpps();
        c.cancelNotification();
		Test.stopTest();	
	}

	@isTest static void testProfilesMethods() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Task t = getMockCallTask(o.Id);
		Test.startTest();
		FollowingUpReportController c = new FollowingUpReportController();
		o.Status__c = 'Application Forms Received';
		update o;
		c = new FollowingUpReportController();
		c.loadClosedOppsProfile();
		c.getReportTitle();
		c.loadFollowUpProfile();
		c.getReportTitle();
		c.loadGeneralProfile();
		
		Test.stopTest();	
	}

	@isTest static void testReportDetail() {
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		// Create a notification
		FollowingUp_Report__c frpt = new FollowingUp_Report__c();
		frpt.Notes__c = 'My notes';
		frpt.Status__c = 'Unread';
		frpt.User__c = UserInfo.getUserId();
		insert frpt;
		FollowingUp_Report_Detail__c frptd = new FollowingUp_Report_Detail__c();
		frptd.FollowingUp_Report__c = frpt.Id;
		frptd.Custom_Opportunity__c = o.Id;
		insert frptd;
		// Creating activity details
		Task t = getMockCallTask(o.Id);
        t = new Task();
        t.WhatId = o.Id;
        t.TaskSubtype = 'Email';
        t.Status = 'Completed';
        insert t;
        mockSMSHistory(o.Id);
		Test.startTest();
		o.Status__c = 'Application Forms Received';
		update o;
		FollowingUpReportDetailController c = new FollowingUpReportDetailController();
		c.getHasNotes();
		c.initReport();
		c.getDetailReportKeys();
		c.getNotifications();
		c.selectReport();
		// Respond report
		c.displayResponse();
		c.isResponding = true;
		c.response.Body = 'My Notes';
		c.respondReport();
		c.getHasNotes();
        Test.stopTest();
	}

	private static Task getMockCallTask(Id oppId) {
		Task t = new Task();
        t.WhatId = oppId;
        t.Subject = 'Voice call on 4/9/2019 - 9:58:09 AM';
        t.CallDurationInSeconds = 21;
        t.TaskSubtype = 'Call';
        t.Status = 'Completed';
        insert t;
        return t;
	}

	private static void mockSMSHistory(Id oppId) {
		smagicinteract__smsMagic__c t = new smagicinteract__smsMagic__c();
		t.Custom_Opportunity__c = oppId;
		t.smagicinteract__external_field__c = String.valueOf(Datetime.now().time());
		t.smagicinteract__PhoneNumber__c = '0415123123';
		t.smagicinteract__SMSText__c  = 'Test message';
		t.smagicinteract__SenderId__c  = UserInfo.getUserId();
		insert t;
	}

	@isTest static void testDetailReportIterator() {
		Test.startTest();
		List<FollowingUpReportController.DetailReport> baseList = new List<FollowingUpReportController.DetailReport>();
		for (Integer i=1;i<=100;i++) {
			baseList.add(new FollowingUpReportController.DetailReport());
		}
		DetailReportIterator dri = new DetailReportIterator(baseList);
		dri.hasNext();
		dri.next();
		dri.getHasPrevious();
		dri.previous();
		dri.last();
		dri.first();
		dri.getFullSize();
		dri.getCurrentPage();
		dri.getTotalPages();
		Test.stopTest();
	}
}