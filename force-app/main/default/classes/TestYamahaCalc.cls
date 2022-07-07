@isTest(SeeAllData=true)
private class TestYamahaCalc {
	
	@isTest static void testMotorcycleCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.YamahaMotorcyclesCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaMotorcyclesCalculatorExtension ctr = new YamahaMotorcyclesCalculatorExtension(sc);
        
        ctr.calculate();
        ctr.dto.applicationFee = null;
        ctr.dto.dof = null;
        ctr.dto.ppsr = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.dto.productLoanType = 'Consumer Loan';
        ctr.dto.loanTypeDetail = 'Prime Plus';
        ctr.dto.carPrice = 50000.00;
        ctr.dto.deposit = 20000.00;
        ctr.dto.ppsr = 10.00;
        ctr.dto.residualValue = 10000.00;
        ctr.dto.clientRate = 23.00;
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
        ctr.dto.lti = 2000.00;
        ctr.dto.ltiIncome = 1000.00;
        ctr.dto.truckGapLevel = 'Cover 1';
        ctr.dto.truckGap = 3000.00;
        ctr.dto.truckGapIncome = 1500.00;
        ctr.dto.taiLevel = 'TAI Cover 1 ($5,000)';
        ctr.dto.tai = 4000.00;
        ctr.dto.taiIncome = 2000.00;
        ctr.dto.mvLevel = 'AIC/Eric';
        ctr.dto.mv = 5000.00;
        ctr.dto.mvIncome = 2500.00;
        ctr.dto.cci = 6000.00;
        ctr.dto.cciIncome = 3000.00;
        ctr.dto.nwc = 7000.00;
        ctr.dto.nwcIncome = 3500.00;
        
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
        ctr.dto.carPrice = 25000.00;
        ctr.baseRateCalc();
        ctr.dto.clientRate = ctr.dto.baseRate + 0.5;
        ctr.dto.term = 60;
        ctr.calculate();
        
        ctr.savePreApproval();
        ctr.dto.paymentType = 'Advance';
        ctr.calculate();
        ctr.dto.clientRate = 1.00;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.dto.clientRate = ctr.dto.baseRate + 1;
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
        ctr.sendPresentationStep3();
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
        ctr.getHasCustomerEmailSent();

        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new YamahaMotorcyclesCalculatorExtension(sc);

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
        ctr.getCciLevelSelect();
        ctr.getCustomerPresentationStatusStyle();

        //-

        ctr.dto.getSelectLoanTypeMarineOptions();
        YamahaCalculatorDTO.getSelectCustomerProfileOptions();
        
	}	

    @isTest static void testMotorcycleInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.YamahaMotorcyclesCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaMotorcyclesCalculatorExtension ctr = new YamahaMotorcyclesCalculatorExtension(sc);
        
        ctr.reset();
        
        ctr.dto.loanTypeDetail = 'Prime Plus';
        ctr.dto.carPrice = 25000.00;
        ctr.dto.deposit = 0.00;
        ctr.dto.ppsr = 50.00;
        ctr.dto.residualValue = 0.00;
        ctr.dto.term = 60;
        ctr.baseRateCalc();
        ctr.dto.clientRate = ctr.dto.baseRate + 0.5;
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

	@isTest static void testWaterCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.YamahaWaterCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaWaterCalculatorExtension ctr = new YamahaWaterCalculatorExtension(sc);
        
        ctr.calculate();
        ctr.dto.applicationFee = null;
        ctr.dto.dof = null;
        ctr.dto.ppsr = null;
        ctr.dto.baseRate = null;
        ctr.dto.clientRate = null;
        ctr.dto.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.dto.productLoanType = 'Consumer Loan';
        ctr.dto.loanTypeDetail = 'Prime Plus';
        ctr.dto.carPrice = 50000.00;
        ctr.dto.deposit = 20000.00;
        ctr.dto.ppsr = 10.00;
        ctr.dto.residualValue = 10000.00;
        ctr.dto.clientRate = 23.00;
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
        ctr.dto.lti = 2000.00;
        ctr.dto.ltiIncome = 1000.00;
        ctr.dto.truckGapLevel = 'Cover 1';
        ctr.dto.truckGap = 3000.00;
        ctr.dto.truckGapIncome = 1500.00;
        ctr.dto.taiLevel = 'TAI Cover 1 ($5,000)';
        ctr.dto.tai = 4000.00;
        ctr.dto.taiIncome = 2000.00;
        ctr.dto.mvLevel = 'AIC/Eric';
        ctr.dto.mv = 5000.00;
        ctr.dto.mvIncome = 2500.00;
        ctr.dto.cci = 6000.00;
        ctr.dto.cciIncome = 3000.00;
        ctr.dto.nwc = 7000.00;
        ctr.dto.nwcIncome = 3500.00;
        
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
        ctr.dto.carPrice = 25000.00;
        ctr.baseRateCalc();
        ctr.dto.clientRate = ctr.dto.baseRate + 0.5;
        ctr.dto.term = 60;
        ctr.calculate();
        
        ctr.savePreApproval();
        ctr.dto.paymentType = 'Advance';
        ctr.calculate();
        ctr.dto.clientRate = 1.00;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.dto.clientRate = ctr.dto.baseRate + 1;
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
        ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.isValidPresentation();
        ctr.getPresentationUrlCode();
        ctr.getHasCustomerEmailSent();

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
        ctr = new YamahaWaterCalculatorExtension(sc);

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
        ctr.getCciLevelSelect();
        ctr.getCustomerPresentationStatusStyle();
        //-

        ctr.dto.getSelectLoanTypeMarineOptions();
        YamahaCalculatorDTO.getSelectCustomerProfileOptions();
        
	}	

    @isTest static void testWaterInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.YamahaWaterCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaWaterCalculatorExtension ctr = new YamahaWaterCalculatorExtension(sc);
        
        ctr.reset();
        
        ctr.dto.loanTypeDetail = 'Prime Plus';
        ctr.dto.carPrice = 25000.00;
        ctr.dto.deposit = 0.00;
        ctr.dto.ppsr = 50.00;
        ctr.dto.residualValue = 0.00;
        ctr.dto.term = 60;
        ctr.baseRateCalc();
        ctr.dto.clientRate = ctr.dto.baseRate + 0.5;
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