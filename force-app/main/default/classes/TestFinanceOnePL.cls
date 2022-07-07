@isTest(SeeAllData=true)
private class TestFinanceOnePL {
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.FinanceOnePL;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        FinanceOnePLExtension ctr = new FinanceOnePLExtension(sc);
        
        ctr.reset();
        ctr.calculate();

        ctr.category = 'Secured';
        ctr.carPrice = 15000.00;
        ctr.term = 36;
        ctr.riskFeeCalc();
        ctr.riskFee = ctr.riskFeeTotal;
        ctr.baseRateCalc();
        ctr.calculate();
        System.assert(ctr.rental > 0);

        ctr.saveQuoting();

        ctr = new FinanceOnePLExtension(sc);
        ctr.category = 'Secured';
        ctr.carPrice = 15000.00;
        ctr.term = 36;
        ctr.riskFeeCalc();
        ctr.riskFee = ctr.riskFeeTotal;
        ctr.baseRateCalc();
        ctr.calculate();
        System.assert(ctr.rental > 0);

        // Other methods
        ctr.calculateValidation();
        ctr.applicationFeeCalc();
        ctr.getLenderQuoting();
        ctr.getSimpleResult();
        ctr.getProtectecResult();
        ctr.getHasUserMessages();
        
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        
        ctr.getLoanTypes();
        ctr.getTermYears();
        ctr.getFinanceOneConsumerRates();
        ctr.autoCreateInsuranceQuote();

    }

    @isTest static void testOtherMethods() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.FinanceOnePL;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        FinanceOnePLExtension ctr = new FinanceOnePLExtension(sc);
        
        ctr.reset();
        ctr.calculate();

        ctr.category = 'Secured';
        ctr.carPrice = 15000.00;
        ctr.term = 36;
        ctr.riskFeeCalc();
        ctr.riskFee = ctr.riskFeeTotal;
        ctr.baseRateCalc();
        ctr.calculate();
        System.assert(ctr.rental > 0);

        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        // no insurance products means TRUE
        System.assert(ctr.insuranceProductSelected());
        // lpi - cci
        ctr.cciLevel = 'Disability';
        ctr.cci = 15000;
        System.assert(!ctr.insuranceProductSelected());
        // ctr.cciAcceptance = 'A';
        ctr.acceptQuoteCCI();
        System.assert(ctr.insuranceProductSelected());
        
        ctr.savePreApproval();
        ctr.sendPresentationStep1();
        ctr.sendPresentationStep2();
        ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.declineQuoteCCI();

        ctr.getHasCustomerEmailSent();
        ctr.getCustomerPresentationStatusStyle();
        ctr.getCciLevelSelect();
    }
}