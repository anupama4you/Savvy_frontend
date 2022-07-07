@isTest
private class TestLeadScreenPopControlller {
	
	@isTest static void testCase1() {
		Test_DataGeneratorHelper.createOpportunity();


		PageReference pageRef = Page.LeadScreenPop;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
		pageRef.getParameters().put('ani',Test_DataGeneratorHelper.tstOpportunity.Id);
		pageRef.getParameters().put('dnis',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        LeadScreenPopControlller controller = new LeadScreenPopControlller();

        //ANI - Lead
        pageRef = Page.LeadScreenPop;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('ani', Test_DataGeneratorHelper.tstLead.Id);
        controller = new LeadScreenPopControlller();
        //ANI - Opportunity
        pageRef = Page.LeadScreenPop;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('ani', Test_DataGeneratorHelper.tstOpportunity.Id);
        controller = new LeadScreenPopControlller();
        //ANI - Account
        pageRef = Page.LeadScreenPop;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('ani', Test_DataGeneratorHelper.tstAccount.Id);
        controller = new LeadScreenPopControlller();
        //ANI - wrong id
        pageRef = Page.LeadScreenPop;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('ani', 'sending a wrong ID');
        controller = new LeadScreenPopControlller();

        //Other methods
        controller.getParameters();
	}
	
}