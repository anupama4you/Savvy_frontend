@isTest(SeeAllData=true)
private class TestLeadRedirection {
	
	@isTest static void testYesRedirect() {
		Test_DataGeneratorHelper.createLead();

		Business_Parameters__c p = BusinessParamHelper.getParameterObj(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE);
		if (p != null) {
			p.Text_Value__c = 'Y';
			update p;
		}

		PageReference pageRef = Page.LeadView;
		pageRef.getParameters().put('id', Test_DataGeneratorHelper.tstLead.Id);
		Test.setCurrentPageReference(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead);
        LeadRedirectionExtension ctr = new LeadRedirectionExtension(sc);
        ctr.redirectProcess();
	}

	@isTest static void testNoRedirect() {
		Test_DataGeneratorHelper.createLead();

		Business_Parameters__c p = BusinessParamHelper.getParameterObj(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE);
		if (p != null) {
			p.Text_Value__c = 'N';
			update p;
		}

		PageReference pageRef = Page.LeadView;
		pageRef.getParameters().put('id', Test_DataGeneratorHelper.tstLead.Id);
		Test.setCurrentPageReference(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead);
        LeadRedirectionExtension ctr = new LeadRedirectionExtension(sc);
        ctr.redirectProcess();
	}
		
}