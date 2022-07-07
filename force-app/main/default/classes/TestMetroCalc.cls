@isTest(SeeAllData=true)
private class TestMetroCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.MetroCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        MetroCalculatorExtension ctr = new MetroCalculatorExtension(sc);

        ctr.calculate();
        ctr.applicationFee = null;
        ctr.dof = null;
        ctr.ppsr = null;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.carPrice = 50000.00;
        ctr.deposit = 2000.00;
        ctr.ppsr = 10.00;
        ctr.residualValue = 10000.00;
        ctr.clientRate = 23.00;
        // test for baseRateCalc() and calculateValidation()
        ctr.carPrice = 60000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.carPrice = 15000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.carPrice = 5000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.productLoanType = 'Heavy Commercial Vehicles';
        
        ctr.carPrice = 20000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.carPrice = 10000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.productLoanType = 'Wheeled Plant & Equipment';
        ctr.carPrice = 20000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.privateSales = 'Y';
        ctr.saleBacksPurchased = 'Y';
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.carPrice = 10000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        
        ctr.carPrice = 4000.00;
        ctr.brokeragePercentage = 5;
        ctr.term = 60;
        ctr.carAge = 10;
        ctr.calculate();
        ctr.term = 48;
        ctr.brokeragePercentage = 6;
        ctr.calculate();
        ctr.term = 36;
        ctr.brokeragePercentage = 7;
        ctr.calculate();
        ctr.term = 24;
        ctr.brokeragePercentage = 8;
        ctr.calculate();
        ctr.brokeragePercentage = 9;
        ctr.calculate();
        ctr.brokeragePercentage = 8;
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.clientRate = 1.00;
        ctr.calculate();

        ctr.reset();

        ctr.carPrice = 15000.00;
        ctr.brokeragePercentage = 3;

        ctr.calculate();

        System.debug('rental: ' + ctr.rental);

        ctr.saveQuoting();
        
        // Insurance
        ctr.saveAmendment();
        ctr.saveFormalApproval();

        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Metro';
        update Test_DataGeneratorHelper.quote;
        
        ctr = new MetroCalculatorExtension(sc);

        
        ctr.getSelectLoanTypeOptions();
        ctr.getPassengerAndCommercialRates();
        ctr.getHeavyCommercialRates();
        ctr.getWhelledPlantEquipmentRates();
        ctr.getLenderQuoting();

        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.getLenderFeesTable();
        ctr.changePlanOption();
        ctr.getSelectPlanOptions();

        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','METRO CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsMetro();
               
        test.stopTest();
	}
    	
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.MetroCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        MetroCalculatorExtension ctr = new MetroCalculatorExtension(sc);
        
        ctr.reset();
        
        //ctr.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.carPrice = 25000.00;
        ctr.brokeragePercentage = 3.0;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        ctr.saveQuoting();
        ctr.getIsBrokerPartnerUser();
        ctr.hasValidQuotation();
        ctr.calculateQuote();
        ctr.storeQuotingData();

        ctr = new MetroCalculatorExtension(sc);

    }

}