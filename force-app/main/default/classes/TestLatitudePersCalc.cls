@isTest(SeeAllData=true)
private class TestLatitudePersCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.LatitudePersonalCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LatitudePersonalCalculatorExtension ctr = new LatitudePersonalCalculatorExtension(sc);
        
        ctr.calculate();
        ctr.saveQuoting();
        ctr.dto.applicationFee = null;
        ctr.dto.dof = null;
        ctr.dto.ppsr = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.dto.loanTypeDetail = 'AAA';
        ctr.dto.carPrice = 60000.00;
        ctr.dto.deposit = 2000.00;
        ctr.dto.ppsr = 10.00;
        ctr.dto.residualValue = 0.00;
        ctr.dto.registrationFee = 3.4;
        ctr.dto.term = 60;
        ctr.latitudeRecommendedRate();
        ctr.dto.clientRate = ctr.dto.baseRate + 1;
        ctr.dofCalculate();
        ctr.calculate();
        //System.assert(ctr.dto.rental > 0, new ApexPages.Message(ApexPages.Severity.INFO, 'Rental could not be calculated :(')));
        System.assert(ctr.dto.rental > 0, 'Rental could not be calculated :(');
        ctr.saveQuoting();
        ctr = new LatitudePersonalCalculatorExtension(sc);
        ctr.calculate();
        //System.assert(ctr.dto.rental > 0, new ApexPages.Message(ApexPages.Severity.INFO, 'Rental could not be calculated :(')));
        System.assert(ctr.dto.rental > 0, 'Rental could not be calculated after loading :(');
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        ctr.dto.paymentType = 'Advance';
        ctr.calculate();
        
        ctr.getRiskGradeOptions();
        ctr.dofCalculate();
        ctr.dto.securedUnsecured = 'Unsecured';
        ctr.latitudeRecommendedRate();

        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.getCciLevelSelect();

        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','LATITUDE CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsLatitudePersonal();

        ctr = new LatitudePersonalCalculatorExtension(sc);

        test.stopTest();
	}
		
}