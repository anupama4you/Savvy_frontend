@isTest(SeeAllData=true)
private class TestPepper5OhCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Pepper Seasonal Calculator
        PageReference PepperSeasonal = Page.PepperCalculatorSeasonal;
        PepperSeasonal.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperSeasonal);
        PepperCalculatorSeasonalExtension ctr = new PepperCalculatorSeasonalExtension(sc);
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.residualValue = 10000.00;
        ctr.clientRate = 7.00;
        ctr.clientTier = 'A';
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '4';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.state = 'WA';
        ctr.warrantyLevel = 'Platinum - 24 months';
        ctr.vehicleGroup = '2';
        ctr.warrantyPriceCalc();
        ctr.vehicleGroup = '3';
        ctr.warrantyPriceCalc();
        ctr.awd = 'Y';
        ctr.turbo = 'Y';
        ctr.diesel = 'Y';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.state = '';
        ctr.warrantyIncomeCalc();
        ctr.state = 'ACT';
        ctr.warrantyIncomeCalc();
        ctr.state = 'NSW';
        ctr.warrantyIncomeCalc();
        ctr.state = 'NT';
        ctr.warrantyIncomeCalc();
        ctr.state = 'VIC';
        ctr.warrantyIncomeCalc();
        ctr.state = 'TAS';
        ctr.warrantyIncomeCalc();
        ctr.state = 'QLD';
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '1';
        ctr.awd = 'N';
        ctr.turbo = 'N';
        ctr.diesel = 'N';
        
        ctr.state = 'SA';
        ctr.warrantyLevel = 'Platinum - 12 months';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.ltiLevel = 'Platinum Cover 1';
        ctr.lti = 2000.00;
        ctr.ltiIncome = 1000.00;
        ctr.truckGapLevel = 'Cover 1';
        ctr.truckGap = 3000.00;
        ctr.truckGapIncome = 1500.00;
        ctr.taiLevel = 'TAI Cover 1 ($5,000)';
        ctr.tai = 4000.00;
        ctr.taiIncome = 2000.00;
        ctr.mvLevel = 'AIC/Eric';
        ctr.mv = 5000.00;
        ctr.mvIncome = 2500.00;
        ctr.cci = 6000.00;
        ctr.cciIncome = 3000.00;
        ctr.nwc = 7000.00;
        ctr.nwcIncome = 3500.00;
        
        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.nwcParam.awd4wd = 'No';
        ctr.nwcParam.luxuryCar = 'Yes';
        ctr.nwcParam.type_p = 'NWC';
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.nwcPlan = 'A';
        ctr.nwcTerm = '12';
        ctr.nwcParam.state = 'SA';
        //NWCCalculator HJ - F - 12-07-2018
        
        ctr.realtimeNafCalc();
        ctr.clientTier = 'B';
        ctr.clientRate = 8.00;
        ctr.calculate();
        ctr.clientRate = 14.00;
        ctr.calculate();
        ctr.clientTier = 'A';
        ctr.clientRate = 13.00;
        ctr.calculate();
        ctr.clientRate = 7.00;
        ctr.calculate();
        ctr.term = 20;
        ctr.calculate();
        ctr.term = 28;
        ctr.calculate();
        ctr.term = 40;
        ctr.calculate();
        ctr.term = 50;
        ctr.calculate();
        ctr.term = 60;
        ctr.calculate();
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.reset();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.clientRate = 1.00;
        ctr.term = 0;
        ctr.calculate();
        ctr.saveQuoting();  

        ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        ctr.acceptQuoteGAP();
        ctr.acceptQuoteTAS();
        ctr.acceptQuoteLTI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        ctr.declineQuoteMV();
        ctr.declineQuoteGAP();
        ctr.declineQuoteTAS();
        ctr.declineQuoteLTI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();
        ctr.sendPresentationStep1();
        ctr.sendPresentationStep2();
        ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.isValidPresentation();
        ctr.getPresentationUrlCode();
        ctr.getCciLevelSelect();
        ctr.getHasCustomerEmailSent();
        ctr.getCustomerPresentationStatusStyle();
        ctr.getInsuranceFailureReasons();
        ctr.createQuote();

        ctr.buyPolicy();
        ctr.isAnInsuranceProductAccepted();
        ctr.getLenderQuoting();
        ctr.getSimpleResult();
        ctr.getProFullyResult();
        ctr.getProStandardResult();
        ctr.getProBasicResult();


        ctr.getQuoteNumberOptions();
        ctr.importQuote();
        ctr.getHasUserMessages();
        ctr.getDisplayNwcInsurance();
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        ctr.getProtectecResult();

        ctr.commsCalc();
        ctr.privateSales = 'Y';
        ctr.applicationFeefCalc();
        ctr.privateSales = 'N';
        ctr.applicationFeefCalc();

        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018

        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        //ctr = new PepperCalculatorMVExtension(sc);
        ctr = new PepperCalculatorSeasonalExtension(sc);

        ctr.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        ctr.acceptQuoteGAP();
        ctr.taiAcceptance = 'A';
        ctr.acceptQuoteTAS();
        ctr.ltiAcceptance = 'A';
        ctr.acceptQuoteLTI();
        ctr.warrantyAcceptance = 'A';
        ctr.acceptQuoteWRR();
        ctr.saveQuoting();  

        ctr.nwc = 100;
        ctr.nwcPlan = null;
        ctr.nwcIncome = null;
        ctr.acceptQuoteNWC();
        ctr.nwcPlan = 'A';
        ctr.acceptQuoteNWC();
        ctr.nwcIncome = 100;
        ctr.acceptQuoteNWC();
        ctr.nwcAcceptance = 'A';
        
        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.nwcParam.awd4wd = 'No';
        ctr.nwcParam.luxuryCar = 'Yes';
        ctr.nwcParam.type_p = 'NWC';
        ctr.nwcParam.isManuallyNWCPrice = false;
        //ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.nwcPlan = 'A';
        ctr.nwcTerm = '12';
        ctr.nwcParam.state = 'SA'; 
         ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
        ctr.acceptQuoteNWC();
        ctr.acceptQuoteNWC();
        ctr.nationalWarrantyCalc();

        ctr.mvAcceptance = 'D';
        ctr.declineQuoteMV();

        ctr.gapAcceptance = 'D';
        ctr.declineQuoteGAP();

        ctr.taiAcceptance = 'D';
        ctr.declineQuoteTAS();

        ctr.ltiAcceptance = 'D';
        ctr.declineQuoteLTI();

        ctr.warrantyAcceptance = 'D';
        ctr.declineQuoteLTI();

        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.mv = 100;
        ctr.hasQuotingInsProducts();

        ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
        ctr.importQuote();
	}
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperCalculatorSeasonal;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperCalculatorSeasonalExtension ctr = new PepperCalculatorSeasonalExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 25000.00;
        ctr.clientRate = 8.00;
        ctr.clientTier = 'A';
        ctr.term = 60;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        // no insurance products means TRUE
        System.assert(ctr.insuranceProductSelected());
        // Motor Vehicle
        ctr.mvLevel = 'MV';
        System.assert(!ctr.insuranceProductSelected());
        ctr.mvAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // GAP
        ctr.gapLevel = 'GAP';
        System.assert(!ctr.insuranceProductSelected());
        ctr.gapAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // RTI
        ctr.gapLevel = null;
        ctr.gapAcceptance = null;
        ctr.taiLevel = 'RTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.taiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // LTI
        ctr.ltiLevel = 'LTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.ltiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // lpi - cci
        ctr.ltiLevel = null;
        ctr.ltiAcceptance = null;
        ctr.cci = 15000;
        System.assert(!ctr.insuranceProductSelected());
        ctr.cciAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // Warranty
        ctr.warrantyLevel = 'LTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.warrantyAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // NWC
        ctr.warrantyLevel = null;
        ctr.warrantyAcceptance = null;
        ctr.nwc = 15000;
        System.assert(!ctr.insuranceProductSelected());
        ctr.nwcAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

    }	
}