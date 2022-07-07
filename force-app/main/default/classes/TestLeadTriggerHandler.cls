@isTest(SeeAllData=true)
public class TestLeadTriggerHandler {

	@isTest static void testCase() {
		ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
		Test.startTest();
		
		Lead__c a = new Lead__c(First_Name__c = 'Testdsf', 
			            Last_Name__c = 'Testsdf', 
			            Finance_Amount__c = 123, 
			            Email_Address__c = 'test2@test.com', 
			            Status__c = 'New Lead',
			            Mobile_Number__c = '0401234567');
		insert a;

		a.Status__c = 'Attempted Contact 1';
		update a;

		//a.Status__c = 'Unresolved Lead';
		//update a;

		Test_DataGeneratorHelper.createApplication();
		a.Application__c = Test_DataGeneratorHelper.tstApp.Id;
		update a;
		List<Lead__c> lst = new List<Lead__c>();
		lst.add(a);
		LeadService.checkAccountCreation(lst);

		a = new Lead__c(First_Name__c = 'Testdsf', 
			            Last_Name__c = 'Testsdf', 
			            Finance_Amount__c = 123, 
			            Email_Address__c = 'test2@test.com', 
			            Status__c = 'New Lead',
			            Mobile_Number__c = '0401234567');
		insert a;

		delete a;
		Test.stopTest();
	}

	@isTest static void testLoanTypeFormApp() {
		System.assert(null == LeadService.getLoanTypeFormApp(null));
		System.assert('Car Loan'.equals(LeadService.getLoanTypeFormApp('Car')));
		System.assert('Personal Loan'.equals(LeadService.getLoanTypeFormApp('Personal')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Bike')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Boat')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Caravan')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('JetSki')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Aircraft')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Equipment')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Truck')));
		System.assert('Home Loan'.equals(LeadService.getLoanTypeFormApp('Home')));
		System.assert('Any value'.equals(LeadService.getLoanTypeFormApp('Any value')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Caravan Finance')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Bike Finance')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('RV/Motorhome')));
		System.assert('Leisure Loan'.equals(LeadService.getLoanTypeFormApp('Boat Finance')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Commercial Utilities and Van')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Aircraft Finance')));
		System.assert('Commercial Loan'.equals(LeadService.getLoanTypeFormApp('Truck Loan')));

		System.assert('Car Loan'.equals(LeadService.getValidLoanType('Car')));
    System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Bike')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Boat')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Caravan')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('JetSki')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Aircraft')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Equipment')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Truck')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Caravan Finance')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Bike Finance')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('RV/Motorhome')));
		System.assert('Leisure Loan'.equals(LeadService.getValidLoanType('Boat Finance')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Commercial Utilities and Van')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Aircraft Finance')));
		System.assert('Commercial Loan'.equals(LeadService.getValidLoanType('Truck Loan')));


	}

	@isTest static void testHomeLoanBuckets() {
		// Preparing new leads
		List<Lead__c> leads = new List<Lead__c>();
		Lead__c a = makeLead('Home Loan','Excellent',8250000.0,'Full Time',null);
		leads.add(a);
		insert leads;

		Test.startTest();
		leads = new List<Lead__c>();
		a = makeLead('Home Loan','Excellent',8250000.0,'Full Time',null);
		leads.add(a);
		a = makeLead('Home Loan','Excellent',8250000.0,'Full Time',null);
		leads.add(a);
		a = makeLead('Home Loan','Excellent',8250000.0,'Full Time',null);
		leads.add(a);
		LeadService.bucketChecker(leads);
		Test.stopTest();
	}

	/*
	@isTest static void testCheckCallCenters() {
		test.startTest();
		List<Lead__c> leads = new List<Lead__c>();
		Lead__c a = makeLead('Home Loan','Excellent',250000.0,'Full Time',null);
		leads.add(a);
		// insert leads;
		LeadService.checkCallCenterSent(lst, null);
	}
	*/

	@isTest static void testCheckDuplicates() {
		ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
		List<Lead__c> d = [
			SELECT Mobile_Number__c, Loan_type__c FROM Lead__c WHERE Employment_Status__c != 'Unemployed' ORDER BY CreatedDate DESC LIMIT 1
		];
		String phone = '0415151515';
		String loanType = 'Home Loan';
		if (!d.isEmpty()) {
			phone = d.get(0).Mobile_Number__c;
			loanType = d.get(0).Loan_type__c;
		}
		test.startTest();
		Lead__c a = new Lead__c(
			First_Name__c = 'Victor', 
			Last_Name__c = 'Fiveteen', 
			Finance_Amount__c = 250000, 
			Mobile_Number__c = phone,
			Email_Address__c = 'v1515151515@test.com', 
			Status__c = 'New Lead',
			Loan_type__c = loanType,
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
		insert a;

		a = new Lead__c(
			First_Name__c = 'Victor', 
			Last_Name__c = 'Test', 
			Finance_Amount__c = 250000, 
			Mobile_Number__c = phone,
			Email_Address__c = 'v1515151515@test.com', 
			Status__c = 'New Lead',
			Loan_type__c = loanType,
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
		insert a;
		LeadService.checkDuplicates(new List<Lead__c>{a});
		System.assert(
			'Closed Lead'.equals(a.Status__c) && 
			'Wrong Number or Details'.equals(a.Reason_for_closure__c), 
			'Lead should be evaluated as a Closed Lead / Wrong Number or Details');
	}

	@isTest static void testDataCheker() {
		Test.startTest();
		List<Lead__c> leads = new List<Lead__c>();
		Lead__c a = makeLead('Car Loan','Poor',25000.0,'Full Time',null);
		leads.add(a);
		a = makeLead('Personal Loan','Poor',5000.0,'Full Time',null);
		leads.add(a);
		a = makeLead('Bad Credit Car Loan','Poor',5000.0,'Full Time','Car');
		leads.add(a);
		a = makeLead('Other','Average',5000.0,'Full Time','Other');
		leads.add(a);
		LeadService.dataChecker(leads);
		Test.stopTest();
	}

	@isTest static void testBucketCheker() {
		Lead__c extLead = makeLead('Car Loan','Excellent',20000.0,'Full Time',null);
		extLead.External_Lead__c = true;
		insert extLead;
		Test.startTest();
		List<Lead__c> leads = new List<Lead__c>();
		List<String> tmpLst = new List<String>();
		// Unemployed
		Lead__c a = makeLead('Car Loan','Poor',25000.0,'Unemployed',null);
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Unemployed', a.Bucket_Type__c);
		// Insurance
		leads.clear();
		a = makeLead('Insurance','Excellent',5000.0,'Full Time',null);
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Insurance', a.Bucket_Type__c);
    // Studen Visa
		leads.clear();
		a = makeLead('Personal Loan','Excellent',5000.0,'Full Time',null);
    a.Residential_Status__c = 'Student VISA';
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Visa Exceptions', a.Bucket_Type__c);
		// Personal Loan
		leads.clear();
		a = makeLead('Personal Loan','Excellent',10000.0,'Full Time','Personal');
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('8k PL', a.Bucket_Type__c);
		// Money 3 - Personal Loans
		tmpLst.clear();
		tmpLst.add('Average');
		tmpLst.add('Poor');
		tmpLst.add('Not sure');
		for (String v: tmpLst) {
			leads.clear();
			a = makeLead('Personal Loan',v,10000.0,'Full Time','Personal');
			leads.add(a);
			LeadService.bucketChecker(leads);
			System.assertEquals('Money3', a.Bucket_Type__c);
		}
		// Money 3 - Excellent
		leads.clear();
		a = makeLead('Personal Loan','Excellent',4500.0,'Full Time','Personal');
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Money3', a.Bucket_Type__c);
		// Money 3 - Centrelink - Family Tax Benefits/Other
		leads.clear();
		a = makeLead('Personal Loan','Excellent',7000.0,'Centrelink - Family Tax Benefits/Other','Personal');
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Money3', a.Bucket_Type__c);
		// Money 3 - Car Loan
		leads.clear();
		a = makeLead('Car Loan','Excellent',4500.0,'Full Time','Car');
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Money3', a.Bucket_Type__c);
		// Sales - Commercial Loans
		leads.clear();
		a = makeLead('Commercial Loan','Excellent',30000.0,'Full Time','Personal');
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Sales', a.Bucket_Type__c);
		// Sales - Bad Credit Car Loans
		leads.clear();
		a = makeLead('Bad Credit Car Loan','Average',10000.0,'Full Time',null);
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Sales', a.Bucket_Type__c);
		// Sales - Car Loans
		leads.clear();
		a = makeLead('Car Loan','Excellent',20000.0,'Full Time',null);
		leads.add(a);
		LeadService.bucketChecker(leads);
		System.assertEquals('Sales', a.Bucket_Type__c);
		// External lead
		System.debug('extLead => ' + extLead.Id + '|' + extLead.Mobile_Number__c + '|' + extLead.Email_Address__c);
		Lead__c x = LeadService.getRecentExternalLead(
			extLead.Mobile_Number__c, extLead.Email_Address__c
		);
		// System.assert(x != null, 'External lead not found');
		Test.stopTest();
	}

	@isTest static void sendToCallCenter() {
		System.debug('.');
		System.debug('Testing sendtoCallCenter...');
		System.debug('.');
		ipSCAPESettings__c s = [SELECT Automatic_Mode__c FROM ipSCAPESettings__c];
		s.Automatic_Mode__c = false;
		update s;
		s = ipSCAPESettings__c.getInstance();
		// Preparing new leads
		List<Lead__c> leads = new List<Lead__c>();
		Lead__c a = makeLead('Car Loan','Poor',250000.0,'Full Time',null);
		leads.add(a);
		a = makeLead('Personal Loan','Poor',250000.0,'Full Time','Car');
		leads.add(a);

		insert leads;
		// Preparing a mock request
		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = s.endpoint__c;
		SingleRequestMock fakeRes = null;
		for (Integer i=0; i < leads.size()-1;i++) {
			fakeRes = getQuickMockRequest('{"resultCode":"success","result":{"leadId":126,"isDialling":1}}');
			requestMocks.addRequestMock(baseEndpoint + '/api/latest/lead/createlead', fakeRes);	
		}
    Test.setMock(HttpCalloutMock.class, requestMocks);		
		Test.startTest();
		LeadService.sendToCallCenter(2);
		Test.stopTest();
		System.debug('Testing sendtoCallCenter End.');
	}

  @isTest static void testDistributeLeads() {
		Test.startTest();
    System.debug('Testing testDistributeLeads...');
    // Check system properties
    List<String> parameters = new List<String>{
      LeadService.EXT_LEAD_SETTING_ACTIVE,
      LeadService.EXT_LEAD_SETTING_PERCENTAGE,
      LeadService.EXT_LEAD_SETTING_STARTING_TIME
    };
    Parameters_Service__c param = null;
    for (String p: parameters) {
      param = Parameters_Service__c.getInstance(p);
      System.assert(param != null, 'Parameter ['+p+'] not found in Parameters Service');
    }
    // Set parameters
    param = Parameters_Service__c.getInstance(LeadService.EXT_LEAD_SETTING_ACTIVE);
    param.value__c = 'ON';
    update param;
    param = Parameters_Service__c.getInstance(LeadService.EXT_LEAD_SETTING_PERCENTAGE);
    param.value__c = '99';
    update param;
    param = Parameters_Service__c.getInstance(LeadService.EXT_LEAD_SETTING_STARTING_TIME);
    param.Datetime_Value__c = Datetime.now();
    update param;
    // Check External Lead Settings
    Id baRecId = SOQLSingletonQueries.recs().recordTypes.get('Broker Partner');
    System.assert(baRecId != null, 'Record Type: [Broker Partner] not found in Accounts');
    // Create Business Accounts 
    List<Account> accList = new List<Account>();
    Integer ran = Integer.valueof((Math.random() * 10000));
    Account acc = new Account(RecordTypeId = baRecId, Name = ('Broker ' + ran), Phone = ('051000' + ran));
    accList.add(acc);
    ran = Integer.valueof((Math.random() * 10000));
    acc = new Account(RecordTypeId = baRecId, Name = ('Broker ' + ran), Phone = ('051000' + ran));
    accList.add(acc);
    insert accList;
    // Remove any existing setting
    delete [SELECT Account__c, Weight__c, Limit__c FROM External_Lead_Setting__c WHERE Active__c = true];
    // Create External Lead Settings
    List<External_Lead_Setting__c> elsList = new List<External_Lead_Setting__c>();
    for (Account a: accList) {
      External_Lead_Setting__c els = new External_Lead_Setting__c();
      els.Account__c = a.Id;
      els.Weight__c = 50;
      els.Active__c = true;
      els.Limit__c = elsList.size() + 1;
      els.Loan_Type__c = 'Car Loan';
      els.Max_Daily__c = 0;
      els.Limit_Rotation__c = 'Daily';
      els.Bad_Credit_Limit__c = 10.00;
      els.Credit_History_Leads__c = 'Excellent;Average';
      elsList.add(els);
    }
    insert elsList;
    
    // Distribute
    Lead__c a = makeLead('Car Loan','Excellent',25000.0,'Employed',null);
    insert a;
    LeadService.distributeLead(a);
    a = makeLead('Car Loan','Excellent',25000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Personal Loan','Excellent',12000.0,'Employed',null);
    a.Bucket_Type__c = '8k PL';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    a = makeLead('Leisure Loan','Average',20000.0,'Employed',null);
    a.Bucket_Type__c = 'Sales';
    insert a;
    LeadService.distributeLead(a);

    LeadService.Distributor dis = new LeadService.Distributor(0.00, 0.00, 0.00);
    
		Test.stopTest();
		System.debug('Testing testDistributeLeads End.');
  }

  @isTest static void testLeadShareService() {
		Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
		Lead__c a = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    insert a;
    o.Lead__c = a.Id;
    update o;
    Test.startTest();
		Set<Id> lst = new Set<Id>();
		lst.add(a.Id);
		LeadShareService.createShares(lst);
		LeadShareService.deleteShares(lst);

    a = makeLead('Personal Loan','Excellent',15000.0,'Employed',null);
    insert a;

    o = Test_DataGeneratorHelper.buildOpp(true);
    Group settlementGrp = [Select Id from Group where type='Queue' and DeveloperName='Settlement_Officers'];
    o.OwnerId = settlementGrp.Id;
    o.Lead__c = a.Id;
    System.assert(!String.valueOf(settlementGrp.Id).startsWith('005'), 'Owner should not be an user');
    update o;

    lst = new Set<Id>();
		lst.add(a.Id);    
    
    SOQLSingletonQueries.recs().opportunitiesByLeadIds = null;
    LeadShareService.createShares(lst);

    Test.stopTest();
	}

  @isTest static void setApplicationOwnerAndAccountTest() {
    // App
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    // Account
    Account acc = Test_DataGeneratorHelper.buildAcc();
    // Leads
    Lead__c leadA = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    leadA.Application__c = app.Id;
    leadA.Account__c = acc.Id;
    insert leadA;
    Lead__c leadB = makeLead('Leisure Loan','Excellent',20000.0,'Employed',null);
    leadB.Id = leadA.Id;
    Map<Id, Lead__c> oldMap = new Map<Id, Lead__c>();
    oldMap.put(leadB.Id, leadB);
    Test.startTest();
    LeadService.setApplicationOwnerAndAccount(
      new List<Lead__c>{leadA}, oldMap
    );
    Test.stopTest();
  }

	private static Lead__c makeLead(
		String loanType, String creditHistory, Decimal financeAmount, 
		String employmentStatus, String loanFor) {
		String sufix = String.valueOf(Datetime.now().millisecond());
		Lead__c a = new Lead__c(
			First_Name__c = 'Victor', 
			Last_Name__c = 'Fiveteen', 
			Finance_Amount__c = financeAmount, 
			Mobile_Number__c = '0477000' + sufix,
			Email_Address__c = sufix + 'v15@test.com', 
			Status__c = 'New Lead',
			Loan_type__c = loanType,
			Loan_For__c = loanFor,
			Credit_History__c = creditHistory,
			Employment_Status__c = employmentStatus);
		return a;
	}

	private static SingleRequestMock getQuickMockRequest(String body) {
		SingleRequestMock r = new SingleRequestMock(
				200, 'Complete', body, null
			);
		return r;
	}

	private static SingleRequestMock getMockCallCenterLeadRequest() {
		SingleRequestMock r = getQuickMockRequest(
				'{"AccessToken": "FMP4VGA8", "TokenExpiresAfter": "2019-05-16T12:20:24.7219097Z",' + 
				' "Generated": "2019-05-16T06:20:24.7219097Z", "Result": 0,' +
				' "Error": null, "ValidationErrors": null}');
		return r;
	}
}