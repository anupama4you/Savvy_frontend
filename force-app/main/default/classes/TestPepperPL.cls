@isTest(SeeAllData=true)
public with sharing class TestPepperPL {
    @isTest static void testCalculator() {
        Test_DataGeneratorHelper.createApplication();
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.MoneyPlace;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperPLExtension ctr = new PepperPLExtension(sc);
        
        ctr.calculate();
        ctr.dto.dof = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        
        // test for baseRateCalc() and calculateValidation()
        ctr.reset();
        ctr.dto.carPrice = 20000.00;
        ctr.dto.term = 60;
        ctr.dto.clientRate = 10;
        ctr.calculate();

        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.saveQuoting();
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
		
        ctr.dto.getRealtimeNaf();
                
        ctr = new PepperPLExtension(sc);

	}
}