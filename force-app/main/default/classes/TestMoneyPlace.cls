@isTest(SeeAllData=true)
private class TestMoneyPlace {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.MoneyPlace;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        MoneyPlaceExtension ctr = new MoneyPlaceExtension(sc);
        
        ctr.calculate();
        ctr.dto.dof = null;
        ctr.dto.ppsr = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        
        // test for baseRateCalc() and calculateValidation()
        ctr.reset();
        ctr.dto.carPrice = 20000.00;
        ctr.dto.dof = ctr.getMaxDOF();
        ctr.dto.applicationFee = 500.00;
        ctr.dto.term = 60;
        ctr.dto.clientRate = 10;
        ctr.calculate();
        
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.saveQuoting();
        ctr.dto.loanPurpose = 'l';
        ctr.saveAmendment();
        ctr.saveFormalApproval();
		
        ctr.dto.getRealtimeNaf();
        
        ctr = new MoneyPlaceExtension(sc);

        ctr.dto.cciAcceptance = 'A';
        ctr.dto.cciLevel = 'Disability/Unemployment';
        ctr.dto.ltiLevel = '';
        ctr.getCciLevelSelect();
        ctr.getDisplayCCIInsurance();
        ctr.ericLPICalculate();
        ctr.dto.cci = null;
        ctr.acceptQuoteCCI();
        ctr.declineQuoteCCI();
        ctr.calculate();
        ctr.saveQuoting();
        ctr.dto.loanPurpose = 'l';
        ctr.savePreApproval();
        ctr.onChangeLoanAmount();
        test.stopTest();
	}
	
}