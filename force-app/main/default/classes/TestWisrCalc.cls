@isTest(SeeAllData=true)
private class TestWisrCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.WisrCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
       
        WisrCalculatorExtension ctr = new WisrCalculatorExtension(sc);
        
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
        ctr.dto.term = 60;
        ctr.dto.vedascore = 500;
        ctr.dto.applicationFee = 1;
        ctr.clientRateCalc();
        ctr.dto.clientRate = ctr.dto.baseRate;
        ctr.calculate();
        ctr.dto.loanPurpose = 'My purpose here!';
        ctr.savePreApproval();
        ctr.dto.term = 48;
        ctr.dto.vedascore = 600;
        ctr.dto.paymentType = 'Advance';
        ctr.calculate();
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.saveQuoting();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
		
        ctr.dto.getRealtimeNaf();
        WisrCalculatorDTO.getSelectLoanTypeOptions();
        ctr.dto.applicationFee = 1000;
        ctr.isValidationOk();
        
        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','LATITUDE CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsLatitudePersonal();

        ctr = new WisrCalculatorExtension(sc);
        
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
        ctr.savePreApproval();
        test.stopTest();
	}
		
}