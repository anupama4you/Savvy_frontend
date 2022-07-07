@isTest(seeAlldata=true)
private class TestPerformanceReport {
	
	@isTest static void testInsuranceReport() {
		test.startTest();
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Insurance';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;
		InsurancePerformanceReportController rpt = new InsurancePerformanceReportController();
		rpt.getReportName();
		rpt.getYearOptions();
	}
	
	@isTest static void testHomeReport() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Home Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;
		// Set page
		PageReference pageRef = Page.HomePerformanceReport;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		HomePerformanceReportController rpt = new HomePerformanceReportController();		
		rpt.getReportName();
		rpt.getYearOptions();
	}

	@isTest static void testSalesReport() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;

		// Set page
		PageReference pageRef = Page.SalesPerformanceReport;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		SalesPerformanceReportController rpt = new SalesPerformanceReportController();
		rpt.getReportName();
		rpt.getYearOptions();

		// Test using a group as an owner
		Group g = [SELECT Id, Name, Type FROM Group WHERE Name like 'Sales%' AND Type = 'Queue' LIMIT 1];
		if (g != null) {
			opp.OwnerId = g.Id;
			update opp;
			rpt = new SalesPerformanceReportController();
		}
	}

	@isTest static void testSalesReportForFinancial() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;

		// Set page
		PageReference pageRef = Page.SalesPerformanceReport;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		SalesPerformanceReportController rpt = new SalesPerformanceReportController();
		rpt.getReportName();
		rpt.getYearOptions();

		//Custom ranges
		rpt.param.customRange = 'Last Financial Qtr';
		rpt.executeReport();
		rpt.param.customRange = 'Current Financial Qtr';
		rpt.executeReport();
	}

	@isTest static void testSalesReportForYears() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;

		// Set page
		PageReference pageRef = Page.SalesPerformanceReport;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		SalesPerformanceReportController rpt = new SalesPerformanceReportController();
		rpt.getReportName();
		rpt.getYearOptions();

		//Custom ranges
		rpt.param.customRange = 'Calendar YTD';
		rpt.executeReport();
		rpt.param.customRange = 'Financial YTD';
		rpt.executeReport();
	}


	@isTest static void testSales3Report() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;

		// Set page
		PageReference pageRef = Page.SalesPerformanceReport3;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		SalesPerformanceReport3Controller rpt = new SalesPerformanceReport3Controller();
		rpt.getReportName();
		rpt.getYearOptions();

		// Test using a group as an owner
		Group g = [SELECT Id, Name, Type FROM Group WHERE Name like 'Sales%' AND Type = 'Queue' LIMIT 1];
		if (g != null) {
			opp.OwnerId = g.Id;
			update opp;
			rpt = new SalesPerformanceReport3Controller();
		}
		rpt.getCustomRangeOptions();
	}

	@isTest static void testGenericReport() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;
		// Set page
		PageReference pageRef = Page.SalesPerformanceReport;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		ApexPages.currentPage().getParameters().put('RPT', '0');
		PerformanceReportController rpt = new PerformanceReportController();
		rpt.getReportName();
		rpt.getYearOptions();
		rpt.pollReport();
		rpt.getPollerTime();
		rpt.getIsCurrentPeriod();

		//Pre-Approved opp
		opp.Status__c = 'Pre-Approved';
		opp.Date_Closed_or_Settled__c = null;
		update opp;
		rpt = new PerformanceReportController();
		rpt.executeReport();

		// Null parameter
		rpt.param = null;
		rpt.getIsCurrentPeriod();
	}

	@isTest static void testHelper() {
		PerformanceReportHelper.Record r = new PerformanceReportHelper.Record();
		r.budget = 10000;
		r.totalOpps = 20000;
		r.getBudgetConvertion();
		r.getOppConvertion();
		r.totalLoanSales = 10;
		r.totalComp = 5;
		System.assert(r.getCompConvertion() > 0);
		r.totalInsurance = 8;
		System.assert(r.getInsuranceConvertion() > 0);
		r.totalPreApprals = 20;
		r.totalPreAppVd = 10;
		System.assert(r.getPreAppVDConvertion() > 0);
		r.commission = 20;
		r.totalPipeline = 10;
		System.assert(r.getCalcProjection() > 0);

        
		PerformanceReportHelper.Parameter p = new PerformanceReportHelper.Parameter();
		Datetime dummyDate = null;
		p.isDateInPeriod(dummyDate);
        
		PerformanceReportResult res = new PerformanceReportResult();
		res.totalOpps = 120;
		res.totalLoanSales = 23;
		System.assert(res.getOppConvertion() > 0);
		res.totalLoanSales = 10;
		res.totalComp = 5;
		System.assert(res.getCompConvertion() > 0);
		res.totalInsurance = 8;
		System.assert(res.getInsuranceConvertion() > 0);
		res.commission  = 150.0;
		res.budget = 300.0;
		System.assert(res.getBudgetConvertion() > 0);
		res.getCalcProjection();
		res.totalPreApprals = 20;
		res.totalPreAppVd = 10;
		System.assert(res.getPreAppVDConvertion() > 0);
		res.reportType = PerformanceReportHelper.SALES_REPORT;
		System.assert(res.getIsSalesReport());
		res.reportType = PerformanceReportHelper.HOME_REPORT;
		System.assert(!res.getIsSalesReport());
		res.reportType = PerformanceReportHelper.SALES_3_INS_REPORT ;
		System.assert(res.getIsInsSalesReport());
		res.reportType = PerformanceReportHelper.HOME_REPORT;
		System.assert(!res.getIsInsSalesReport());


		// Comparing objects
		List<PerformanceReportHelper.Record> rList = new List<PerformanceReportHelper.Record>();
		PerformanceReportHelper.Record a = new PerformanceReportHelper.Record();
		PerformanceReportHelper.Record b = new PerformanceReportHelper.Record();
		rList.add(a);
		rList.add(b);
		// Sort null values
		rList.sort();
		
		// State
		// Sort case 1
		a.state = 'a';
		b.state = null;
		rList.sort();
		// Sort case 2
		a.state = null;
		b.state = 'a';
		rList.sort();
		// Sort case 3
		a.state = 'a';
		b.state = 'b';
		rList.sort();
		// Sort case 3
		a.state = 'a';
		b.state = 'a';
		rList.sort();

		// Owners' names
		// Sort case 1
		a.ownerName = 'a';
		rList.sort();
		// Sort case 2
		a.ownerName = null;
		b.ownerName = 'a';
		rList.sort();
		// Sort case 3
		a.ownerName = 'a';
		b.ownerName = 'b';
		rList.sort();
		// Sort case 3
		a.ownerName = 'a';
		b.ownerName = 'b';
		rList.sort();

		//Poller times
		p = null;
		PerformanceReportHelper.getPollerTime(p);
		p = new PerformanceReportHelper.Parameter();
		PerformanceReportHelper.getPollerTime(p);
		p.reportType = PerformanceReportHelper.SALES_REPORT;
		PerformanceReportHelper.getPollerTime(p);
		p.reportType = PerformanceReportHelper.INSURANCE_REPORT;
		PerformanceReportHelper.getPollerTime(p);
		p.reportType = PerformanceReportHelper.HOME_REPORT;
		PerformanceReportHelper.getPollerTime(p);
		p.reportType = 1000;
		PerformanceReportHelper.getPollerTime(p);
        PerformanceReportHelper.getCustomRangeOptions();
	}

	@isTest static void testInsSales3Report() {
		test.startTest();
		// Prepare data
		Test_DataGeneratorHelper.createOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Lead__c lead = Test_DataGeneratorHelper.tstLead;
		// Adjust Lead
		lead.Loan_Type__c = 'Car Loan';
		update lead;
		// Adjust Opp
		opp.Status__c = 'Settled';
		opp.Date_Closed_or_Settled__c = Datetime.now();
		opp.Date_Pre_Approved__c = Date.today();
		update opp;

		// Set page
		PageReference pageRef = Page.InsurancePerformanceReport3;
		Test.setCurrentPage(pageRef);

		// Add parameters to page URL
		InsurancePerformanceReport3Controller rpt = new InsurancePerformanceReport3Controller();
		rpt.getReportName();
		rpt.getYearOptions();

		// Test using a group as an owner
		Group g = [SELECT Id, Name, Type FROM Group WHERE Name like 'Sales%' AND Type = 'Queue' LIMIT 1];
		if (g != null) {
			opp.OwnerId = g.Id;
			update opp;
			rpt = new InsurancePerformanceReport3Controller();
		}
		rpt.getCustomRangeOptions();
	}

  @isTest static void testBrokerReport() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
		Test.startTest();
    System.runAs(pu) {
      // Prepare data
      Test_DataGeneratorHelper.createOpportunity();
      Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
      Lead__c lead = Test_DataGeneratorHelper.tstLead;
      // Adjust Lead
      lead.Loan_Type__c = 'Car Loan';
      update lead;
      // Adjust Opp
      opp.Status__c = 'Settled';
      opp.Date_Closed_or_Settled__c = Datetime.now();
      opp.Date_Pre_Approved__c = Date.today();
      update opp;

      // Set page
      PageReference pageRef = Page.BrokerPerformanceReport;
      Test.setCurrentPage(pageRef);

      // Add parameters to page URL
      BrokerPerformanceReportController rpt = new BrokerPerformanceReportController();
      rpt.getReportName();
    }

    Test.stopTest();
	}

}