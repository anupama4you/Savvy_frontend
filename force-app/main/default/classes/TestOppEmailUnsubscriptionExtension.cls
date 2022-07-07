@isTest
private class TestOppEmailUnsubscriptionExtension {
	
	@isTest static void test_method_one() {
		test.startTest();
		PageReference pRef = Page.OppEmailUnsubscription;
		Test.setCurrentPageReference(pRef);

		OppEmailUnsubscriptionExtension ctrl = new OppEmailUnsubscriptionExtension();

        pRef = Page.OppEmailUnsubscription;
		pRef.getParameters().put('P', 'XXXXXXX');
        Test.setCurrentPageReference(pRef);
        //Controller
        ctrl = new OppEmailUnsubscriptionExtension();
        ctrl.unsubscribeEmail();

        Test_DataGeneratorHelper.createOpportunity();
        pRef = Page.OppEmailUnsubscription;
		pRef.getParameters().put('P', Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pRef);
        //Controller
        ctrl = new OppEmailUnsubscriptionExtension();
        ctrl.unsubscribeEmail();

	}
		
}