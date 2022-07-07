@isTest
public class TestIpSCAPEServices {
    
    @isTest static void testDTOs() {
        Test.startTest();
        
        // Results
        ipSCAPEDTOs.LoginResult lrs = new ipSCAPEDTOs.LoginResult();
        lrs.resultCode = 'success';
        lrs.result = new ipSCAPEDTOs.LoginDTO();
        lrs.result.orgId = 'X';
        lrs.result.userId = 0;
        lrs.result.username = 'X';
        lrs.result.client = 'X';
        lrs.result.numOfFailedLoginAttempts = 1;
        lrs.result.lastLoginDt = 'X';
        
        // Error fields
        lrs = new ipSCAPEDTOs.LoginResult();
        lrs.resultCode = 'error';
        lrs.errorCode = 'X';
        lrs.errorDescription = 'X';
        lrs.interactionId = 'X';
        lrs.errorDetails = new List<ipSCAPEDTOs.ErrorDetail>();
        ipSCAPEDTOs.ErrorDetail errdet = new ipSCAPEDTOs.ErrorDetail();
        lrs.errorDetails.add(errdet);
        errdet.name = 'X';
        errdet.description = 'X';
        errdet.debuggingInfo = 'X';

        ipSCAPEDTOs.UserListResult ulrs = new ipSCAPEDTOs.UserListResult();
        ulrs.resultCode = 'success';
        ulrs.result = new ipSCAPEDTOs.UserListDTO();
        ulrs.result.pageNo = 1;
        ulrs.result.inPage = 1;
        ulrs.result.perPage = 1;
        ulrs.result.previousPage = 1;
        ulrs.result.nextPage = 'X';
        ulrs.result.data = new List<ipSCAPEDTOs.UserDTO>();

        ipSCAPEDTOs.CreateLeadResult clrs = new ipSCAPEDTOs.CreateLeadResult();
        clrs.resultCode = 'success';
        clrs.result = new ipSCAPEDTOs.LeadResultDTO();
        clrs.result.leadId = 1;
        clrs.result.isDialling = 1;

        ipSCAPEDTOs.ActivityListResult alrs = new ipSCAPEDTOs.ActivityListResult();
        alrs.resultCode = 'success';
        alrs.result = new ipSCAPEDTOs.ActivityListResultDTO();

        ipSCAPEDTOs.CallListResult callrs = new ipSCAPEDTOs.CallListResult();
        callrs.resultCode = 'success';
        callrs.result = new ipSCAPEDTOs.CallListResultDTO();

        // DTOs
        ipSCAPEDTOs.UserDTO udto = new ipSCAPEDTOs.UserDTO();
        udto.userId = 1;
        udto.userTimezone = 'X';
        udto.firstName = 'X';
        udto.lastName = 'X';
        udto.username = 'X';
        udto.isLoggedIn = true;
        udto.userType = 'X';
        udto.displayName = 'X';
        udto.receiveTransferInPauseEnabled = false;
        udto.availableForTransfer = false;
        
        ipSCAPEDTOs.ActivityListResultDTO aldto = new ipSCAPEDTOs.ActivityListResultDTO();
        aldto.data = new List<ipSCAPEDTOs.ActivityDTO>();

        ipSCAPEDTOs.ActivityDTO activityDto = new ipSCAPEDTOs.ActivityDTO();
        activityDto.activityId = 0;
        activityDto.parentActivityId = 0;
        activityDto.campaignId = 0;
        activityDto.campaignTitle = 'X';
        activityDto.leadId = 0;
        activityDto.activitySource = 'X';
        activityDto.activityStart = 'X';
        activityDto.activityEnd = 'X';
        activityDto.activityResultTimestamp = 'X';
        activityDto.activityAnsweredTimestamp = 'X';
        activityDto.queueEntryTimestamp = 'X';
        activityDto.activityDestination = 'X';
        activityDto.activityType = 'X';
        activityDto.resultType = 'X';
        activityDto.secondsInQueue = 0;
        activityDto.callDirection = 'X';
        activityDto.dialSeconds = 0;
        activityDto.voicerecordingId = 0;
        activityDto.customData = 'X';
        activityDto.customText = 'X';
        activityDto.activityStatus = 'X';
        activityDto.sourceType = 'X';
        activityDto.isTransferred = 0;
        activityDto.talkSeconds = 0;
        activityDto.recordingSeconds = 0;
        activityDto.totalSeconds = 0;
        activityDto.agentId = 0;
        activityDto.interactionId = 0;
        activityDto.surveyInitiated = 0;
        activityDto.surveyWorkflowName = 'X';
        activityDto.surveyWorkflowTimestamp = 'X';
        activityDto.mediaType = 'X';

        ipSCAPEDTOs.CallListResultDTO cldto = new ipSCAPEDTOs.CallListResultDTO();
        cldto.data = new List<ipSCAPEDTOs.CallDTO>();

        ipSCAPEDTOs.CallDTO callDto = new ipSCAPEDTOs.CallDTO();
        callDto.activityId = 0;
        callDto.parentActivityId = 0;
        callDto.interactionId = 0;
        callDto.startTimestamp = 'X';
        callDto.endTimestamp = 'X';
        callDto.duration = 0;
        callDto.talkSeconds = 0;
        callDto.campaignId = 0;
        callDto.campaignTitle = 'X';
        callDto.wrapCode = 'X';
        callDto.wrapId = 0;
        callDto.agentId = 0;
        callDto.agentName = 'X';
        callDto.leadId = 0;
        callDto.callerNumber = 'X';
        callDto.calledNumber = 'X';
        callDto.activityStatus = 'X';
        callDto.isTransferred = false;
        callDto.isEncrypted = false;
        callDto.isDeleted = false;
        callDto.deletedTimestamp = 'X';
        callDto.deletedBy = 'X';
        callDto.deletionReason = 'X';

        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testCampaignSettings() {

        Lead__c lead = new Lead__c();
        List<String> lts = new List<String>();
        ipSCAPESettings__c ips = ipSCAPESettings__c.getInstance();
        ipSCAPECampaignSettings__c s = null;
        if ('v1'.equals(ips.Campaign_Version__c)) {
          // MONEY 3 - Campaing Settings
          lead.Bucket_Type__c = 'Money3';
          lts.add('Personal Loan');
          lts.add('Car Loan');
          lts.add('Bad Credit Car Loan');
          lts.add('Commercial Loan');
          lts.add('Leisure Loan');
          for (String lt: lts) {
              lead.Loan_Type__c = lt;
              s = ipSCAPEService.getCampaignSetting(lead);
              System.assertEquals('MONEY3', s.Name);
          }
          // Personal Loans- Campaing Settings
          lead.Bucket_Type__c = '8k PL';
          lead.Loan_Type__c = 'Personal Loan';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('PL', s.Name);
          // Commercial Loans- Campaing Settings
          lead.Bucket_Type__c = 'Sales';
          lead.Loan_Type__c = 'Commercial Loan';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('COMMERCIAL', s.Name);
          // Car Loans- Campaing Settings
          lead.Bucket_Type__c = 'Sales';
          lead.Loan_Type__c = 'Car Loan';
          lead.State__c = 'NSW';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL1', s.Name);
          lead.State__c = 'ACT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL1', s.Name);
          lead.State__c = 'QLD';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL2', s.Name);
          lead.State__c = 'SA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL3', s.Name);
          lead.State__c = 'NT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL3', s.Name);
          lead.State__c = 'VIC';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL4', s.Name);
          lead.State__c = 'TAS';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL4', s.Name);
          lead.State__c = 'WA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('CARL5', s.Name);
          // Bad Credit Car Loans- Campaing Settings
          lead.Bucket_Type__c = 'Sales';
          lead.Loan_Type__c = 'Bad Credit Car Loan';
          lead.State__c = 'NSW';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL1', s.Name);
          lead.State__c = 'NSW';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL1', s.Name);
          lead.State__c = 'ACT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL1', s.Name);
          lead.State__c = 'QLD';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL2', s.Name);
          lead.State__c = 'SA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL3', s.Name);
          lead.State__c = 'NT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL3', s.Name);
          lead.State__c = 'VIC';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL4', s.Name);
          lead.State__c = 'TAS';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL4', s.Name);
          lead.State__c = 'WA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('BCCL5', s.Name);
          // Leisure Loans- Campaing Settings
          lead.Bucket_Type__c = 'Sales';
          lead.Loan_Type__c = 'Leisure Loan';
          lead.State__c = 'NSW';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL1', s.Name);
          lead.State__c = 'NSW';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL1', s.Name);
          lead.State__c = 'ACT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL1', s.Name);
          lead.State__c = 'QLD';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL2', s.Name);
          lead.State__c = 'SA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL3', s.Name);
          lead.State__c = 'NT';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL3', s.Name);
          lead.State__c = 'VIC';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL4', s.Name);
          lead.State__c = 'TAS';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL4', s.Name);
          lead.State__c = 'WA';
          s = ipSCAPEService.getCampaignSetting(lead);
          System.assertEquals('LEISUREL5', s.Name);
          // DEFAULT Settings
          s = ipSCAPEService.getDefaultIpSCAPECampaignSetting();
          System.assertEquals('DEFAULT', s.Name);
        } else if ('v2.2021.2.1'.equals(ips.Campaign_Version__c)) {
          // TODO - define test code for the abobe version
        }
        
        // Campaign Loan Types
        System.assertEquals('Leisure Loan', ipSCAPEService.campaignLoanType('Caravan Finance'));
        System.assertEquals('Leisure Loan', ipSCAPEService.campaignLoanType('Boat Finance'));
        System.assertEquals('Leisure Loan', ipSCAPEService.campaignLoanType('Bike Finance'));
        System.assertEquals('Commercial Loan', ipSCAPEService.campaignLoanType('Truck Loan'));
        System.assertEquals('Commercial Loan', ipSCAPEService.campaignLoanType('Hire Purchase'));
        System.assertEquals('Commercial Loan', ipSCAPEService.campaignLoanType('Aircraft Finance'));
        
    }

    @isTest(SeeAllData=true) static void testLogin() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":{"orgId":54008,"client":"Default","userId":1003,'+
            '"username":"cti","numOfFailedLoginAttempts":0,"lastFailedLoginAttemptsDt":"0000-00-00 00:00:00",'+
            '"lastLoginDt":"2019-08-26 02:10:05"}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/user/login', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
        ipSCAPEDTOs.LoginResult r = ipSCAPEService.login();
        System.assertEquals('success', r.resultCode);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testPing() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest('{"resultCode":"success","result":{}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/ping', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
        ipSCAPEDTOs.BasicResult r = ipSCAPEService.ping();
        System.assertEquals('success', r.resultCode);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testReadOrgDetails() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest('{"resultCode":"success","result":{}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/organisation/readorgdetails', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
        ipSCAPEService.readOrgDetails();
        // System.assertEquals('success', r.resultCode);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testReadUserList() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest('{"resultCode":"success","result":{}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/user/readuserslist', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
        ipSCAPEDTOs.UserListResult r = ipSCAPEService.readUserList();
        System.assertEquals('success', r.resultCode);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testSendLead() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest('{"resultCode":"success","result":{"leadId":126,"isDialling":1}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/lead/createlead', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
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
            CC_List_ID__c = 101,
            State__c = 'SA');
        Integer r = ipSCAPEService.sendLead(a);
        System.assert(r > 0);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testScheduleLoginChecker() {
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":{"orgId":54008,"client":"Default","userId":1003,'+
            '"username":"cti","numOfFailedLoginAttempts":0,"lastFailedLoginAttemptsDt":"0000-00-00 00:00:00",'+
            '"lastLoginDt":"2019-08-26 02:10:05"}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/user/login', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        Test.startTest();
        Id jobId = System.schedule(
            'testBasicScheduledApex', CRON_EXP,
            new CallCenterLoginChecker());
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id = :jobId];

         // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testBatchSender() {
        ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Mark_In_Call_Center__c = true;
		update s;
        s = ipSCAPESettings__c.getInstance();
        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest('{"resultCode":"success","result":{"leadId":126,"isDialling":1}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/lead/createlead', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        // lead
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
            CC_List_ID__c = 101);
        insert a;

        Test.StartTest();
        Id batchprocessid = Database.executeBatch(new CallCenterBatchSender(a.Id));
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testCheckCalls() {
        ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
        s = ipSCAPESettings__c.getInstance();

        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":{"pageNo":1,"inPage":1,"perPage":1000,"previousPage":null,"nextPage":null,'+
            '"data":[{"activityId":999999999,"parentActivityId":null,"interactionId":48,"startTimestamp":"2019-09-06 15:32:43",'+
            '"endTimestamp":"2019-09-06 15:32:57","duration":13,"talkSeconds":14,"campaignId":1,"campaignTitle":"Agent DID",'+
            '"wrapCode":"Client changed their mind","wrapId":24,"agentId":1005,"agentName":"Bruce Barner","leadId":999,'+
            '"callerNumber":"615240285792","calledNumber":"61870892321","activityStatus":"Answered","isTransferred":false,'+
            '"isEncrypted":false,"isDeleted":false,"deletedTimestamp":null,"deletedBy":null,"deletionReason":null}]}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/campaign/readcallslist', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        // lead
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
            Email_Address__c = a.Email_Address__c,
            Lead__c = a.Id
        );
        insert o;    

        // a.CC_Lead_ID__c

        Test.StartTest();
        ipSCAPEService.checkCalls(10);
        // Reader Call parameters
        ipSCAPEService.ReadCallParam p = new ipSCAPEService.ReadCallParam();
        p.activityId = 'X';
        p.agentId = 'X';
        p.callType = 'X';
        p.calledNumber = 'X';
        p.callerNumber = 'X';
        p.campaignId = 'X';
        p.campaignTitle = 'X';
        p.fromTimestamp = 'X';
        p.interactionId = 'X';
        p.pageNo = 'X';
        p.perPage = 'X';
        p.sortField = 'X';
        p.sortOrder = 'X';
        p.toTimestamp = 'X';
        p.wrapCode = 'X';
        System.assert(p.getParams().size() > 0);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testCallCenterCallCheckerTask() {
        ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
        s = ipSCAPESettings__c.getInstance();

        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":{"pageNo":1,"inPage":1,"perPage":1000,"previousPage":null,"nextPage":null,'+
            '"data":[{"activityId":999999999,"parentActivityId":null,"interactionId":48,"startTimestamp":"2019-09-06 15:32:43",'+
            '"endTimestamp":"2019-09-06 15:32:57","duration":13,"talkSeconds":14,"campaignId":1,"campaignTitle":"Agent DID",'+
            '"wrapCode":"Client changed their mind","wrapId":24,"agentId":1005,"agentName":"Bruce Barner","leadId":999,'+
            '"callerNumber":"615240285792","calledNumber":"61870892321","activityStatus":"Answered","isTransferred":false,'+
            '"isEncrypted":false,"isDeleted":false,"deletedTimestamp":null,"deletedBy":null,"deletionReason":null}]}}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/campaign/readcallslist', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        // lead
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
            Email_Address__c = a.Email_Address__c,
            Lead__c = a.Id
        );
        insert o;

        Test.StartTest();
        Id jobId = System.schedule(
            'Testing task...', '0 0 0 3 9 ? 2022',
            new CallCenterCallCheckerTask(1));
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testCompleteLead() {
        ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
        s = ipSCAPESettings__c.getInstance();

        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":"success"}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/lead/updateleaddetails', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        // lead
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

        Test.StartTest();
        ipSCAPEService.completeLead(a.Id);
        Test.stopTest();
    }

    @isTest(SeeAllData=true) static void testCallCenterCompleteCCLeads() {
        ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
        s = ipSCAPESettings__c.getInstance();

        // Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = getQuickMockRequest(
            '{"resultCode":"success","result":"success"}');
		requestMocks.addRequestMock(baseEndpoint + '/api/latest/lead/updateleaddetails?isComplete=1&leadId=999', fakeRes);
        Test.setMock(HttpCalloutMock.class, fakeRes);
        // lead
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
        a.OwnerId = UserInfo.getUserId();
        a.Status__c = 'Sales Flow/Become Opportunity';
        update a;

        Test.StartTest();
        Id jobId = System.schedule(
            'Testing task...', '0 0 0 3 9 ? 2022',
            new CallCenterCompleteCCLeads());
        Test.stopTest();
    }

    private static SingleRequestMock getQuickMockRequest(String body) {
		SingleRequestMock r = new SingleRequestMock(
				200, 'Complete', body, null
			);
		return r;
	}

  @isTest static void testGetNewState() {
      Test.StartTest();
      System.assert('NSW/ACT'.equals(ipSCAPEService.getNewState('NSW')));
      System.assert('NSW/ACT'.equals(ipSCAPEService.getNewState('ACT')));
      System.assert('SA/NT'.equals(ipSCAPEService.getNewState('SA')));
      System.assert('SA/NT'.equals(ipSCAPEService.getNewState('NT')));
      System.assert('VIC/TAS'.equals(ipSCAPEService.getNewState('VIC')));
      System.assert('VIC/TAS'.equals(ipSCAPEService.getNewState('TAS')));
      System.assert('QLD'.equals(ipSCAPEService.getNewState('QLD')));
      System.assert('WA'.equals(ipSCAPEService.getNewState('WA')));
      Test.stopTest();
  }

}