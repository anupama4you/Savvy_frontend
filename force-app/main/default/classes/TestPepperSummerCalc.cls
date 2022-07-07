@isTest(SeeAllData=true)
private class TestPepperSummerCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.PepperSummer;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
            PepperSummerExtension ctr = new    PepperSummerExtension(sc);
        
        ctr.calculate();
        ctr.dto.applicationFee = null;
        ctr.dto.dof = null;
        ctr.dto.ppsr = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.dto.productGoodsType = 'Marine';
        ctr.dto.carPrice = 50000.00;
        ctr.dto.deposit = 2000.00;
        ctr.dto.ppsr = 10.00;
        ctr.dto.residualValue = 1000.00;
        //ctr.dto.registrationFee = 3.4;
        ctr.dto.clientRate = 9.00;
        
        ctr.dto.gapLevel = 'Premier Cover 1';
        ctr.dto.gap = 1000.00;
        ctr.dto.gapIncome = 500.00;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        ctr.warrantyCalc();
        ctr.dto.vehicleGroup = '';
        ctr.warrantyCalc();
        ctr.dto.vehicleGroup = '4';
        ctr.warrantyCalc();
        ctr.dto.state = 'WA';
        ctr.dto.warrantyLevel = 'Platinum - 24 months';
        ctr.dto.vehicleGroup = '2';
        ctr.warrantyCalc();
        ctr.dto.vehicleGroup = '3';
        ctr.warrantyCalc();
        ctr.dto.awd = 'Y';
        ctr.dto.turbo = 'Y';
        ctr.dto.diesel = 'Y';
        ctr.warrantyCalc();
        ctr.dto.state = '';
        ctr.warrantyCalc();
        ctr.dto.state = 'ACT';
        ctr.warrantyCalc();
        ctr.dto.state = 'NSW';
        ctr.warrantyCalc();
        ctr.dto.state = 'NT';
        ctr.warrantyCalc();
        ctr.dto.state = 'VIC';
        ctr.warrantyCalc();
        ctr.dto.state = 'TAS';
        ctr.warrantyCalc();
        ctr.dto.state = 'QLD';
        ctr.warrantyCalc();
        ctr.dto.vehicleGroup = '1';
        ctr.dto.awd = 'N';
        ctr.dto.turbo = 'N';
        ctr.dto.diesel = 'N';
        
        ctr.dto.state = 'SA';
        ctr.dto.warrantyLevel = 'Platinum - 12 months';
        ctr.warrantyCalc();
        ctr.dto.ltiLevel = 'Platinum Cover 1';
        ctr.dto.lti = 200.00;
        ctr.dto.ltiIncome = 100.00;
        ctr.dto.truckGapLevel = 'Cover 1';
        ctr.dto.truckGap = 300.00;
        ctr.dto.truckGapIncome = 150.00;
        ctr.dto.taiLevel = 'TAI Cover 1 ($5,000)';
        ctr.dto.tai = 400.00;
        ctr.dto.taiIncome = 200.00;
        ctr.dto.mvLevel = 'AIC/Eric';
        ctr.dto.mv = 500.00;
        ctr.dto.mvIncome = 250.00;
        ctr.dto.cci = 600.00;
        ctr.dto.cciIncome = 300.00;
        ctr.dto.nwc = 700.00;
        ctr.dto.nwcIncome = 350.00;
        
        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.nwcParam.awd4wd = 'No';
        ctr.nwcParam.luxuryCar = 'Yes';
        ctr.nwcParam.type_p = 'NWC';
        ctr.nwcParam.isManuallyNWCPrice = false;
        //ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.dto.nwcPlan = 'A';
        ctr.dto.nwcTerm = '12';
        ctr.nwcParam.state = 'SA';
        //NWCCalculator HJ - F - 12-07-2018
        
        // test for baseRateCalc() and calculateValidation()
        ctr.dto.carPrice = 60000.00;
        ctr.dto.term = 60;
        ctr.calculate();
        
        
        ctr.dto.productGoodsType = 'Caravan';
        
        ctr.dto.carPrice = 20000.00;
        ctr.dto.term = 60;
        ctr.dto.clientRate = 10;
        ctr.calculate();
        
        
        ctr.savePreApproval();
        ctr.dto.paymentType = 'Advance';
        ctr.calculate();
        ctr.saveQuoting();
        
        // Insurance
        ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        ctr.acceptQuoteGAP();
        ctr.acceptQuoteTAS();
        ctr.acceptQuoteLTI();
        ctr.acceptQuoteCCI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        
        ctr.calculate();
        ctr.saveQuoting();
        ctr.saveAmendment();

        ctr.declineQuoteMV();
        ctr.declineQuoteGAP();
        ctr.declineQuoteTAS();
        ctr.declineQuoteLTI();
        ctr.declineQuoteCCI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();
        ctr.sendPresentationStep1();
        ctr.sendPresentationStep2();
        // ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.isValidPresentation();
        ctr.getPresentationUrlCode();

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

        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new PepperSummerExtension(sc);

        ctr.dto.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        ctr.dto.gapAcceptance = 'A';
        ctr.acceptQuoteGAP();
        ctr.dto.taiAcceptance = 'A';
        ctr.acceptQuoteTAS();
        ctr.dto.ltiAcceptance = 'A';
        ctr.acceptQuoteLTI();
        ctr.dto.cciAcceptance = 'A';
        ctr.acceptQuoteCCI();
        ctr.dto.warrantyAcceptance = 'A';
        ctr.acceptQuoteWRR();
        
        ctr.dto.nwc = 100;
        ctr.acceptQuoteNWC();
        ctr.dto.nwcPlan = 'A';
        ctr.acceptQuoteNWC();
        ctr.dto.nwcIncome = 100;
        ctr.acceptQuoteNWC();
        ctr.dto.nwcAcceptance = 'A';
        
        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.nwcParam.awd4wd = 'No';
        ctr.nwcParam.luxuryCar = 'Yes';
        ctr.nwcParam.type_p = 'NWC';
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.dto.nwcPlan = 'A';
        ctr.dto.nwcTerm = '12';
        ctr.nwcParam.state = 'SA'; 
         ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
        ctr.acceptQuoteNWC();
        ctr.nationalWarrantyCalc();

        ctr.dto.mvAcceptance = 'D';
        ctr.declineQuoteMV();

        ctr.dto.gapAcceptance = 'D';
        ctr.declineQuoteGAP();

        ctr.dto.taiAcceptance = 'D';
        ctr.declineQuoteTAS();

        ctr.dto.ltiAcceptance = 'D';
        ctr.declineQuoteLTI();

        ctr.dto.cciAcceptance = 'D';
        ctr.declineQuoteCCI();

        ctr.dto.warrantyAcceptance = 'D';
        ctr.declineQuoteLTI();

        ctr.dto.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.dto.mv = 100;
        ctr.hasQuotingInsProducts();

        ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
        ctr.importQuote();
        ctr.getDisplayCCIInsurance();
        //-
        
        PepperCalculatorDTO.getSelectGoodsTypeSummerOptions();
        
        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','PEPPER SUMMER CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsLatitude();
        test.stopTest();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperSummer;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperSummerExtension ctr = new PepperSummerExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.dto.productGoodsType = 'Caravan';
        ctr.dto.carPrice = 20000.00;
        ctr.dto.term = 60;
        ctr.dto.clientRate = 10;
        ctr.calculate();
        System.debug('rental: ' + ctr.dto.rental);
        System.assert(ctr.dto.rental > 0);

        // no insurance products means TRUE
        System.assert(ctr.insuranceProductSelected());
        // GAP
        ctr.dto.gapLevel = 'GAP';
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.gapAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // RTI
        ctr.dto.gapLevel = null;
        ctr.dto.gapAcceptance = null;
        ctr.dto.taiLevel = 'RTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.taiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // LTI
        ctr.dto.ltiLevel = 'LTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.ltiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // lpi - cci
        ctr.dto.ltiLevel = null;
        ctr.dto.ltiAcceptance = null;
        ctr.dto.cci = 15000;
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.cciAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // Warranty
        ctr.dto.warrantyLevel = 'LTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.warrantyAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // NWC
        ctr.dto.warrantyLevel = null;
        ctr.dto.warrantyAcceptance = null;
        ctr.dto.nwc = 15000;
        System.assert(!ctr.insuranceProductSelected());
        ctr.dto.nwcAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

    }	
}