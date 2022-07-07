/**
 * @description       : Test class for BOQCommercialCalculatorTest
 * @author            : Girish PfsaveProduct
 * @group             : TestClass
 **/
@isTest(SeeAllData=true)
private class BOQCommercialCalculatorTest {
    @isTest
    static void testCalculatorA() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(
            Test_DataGeneratorHelper.tstOpportunity
        );

        // Macquarie Commercial Calculator
        PageReference boqCommercial = Page.BOQCommercial;
        boqCommercial.getParameters().put('ppsr', '12000');

        boqCommercial.getParameters()
            .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(boqCommercial);
        BOQCommercialExtension ctr = new BOQCommercialExtension(sc);
        ctr.ppsr = 8000;
        ctr.productLoanType = 'Commercial Loan';
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.carPrice = 12000.00;
        ctr.deposit = 2233.00;
        ctr.loanFrequency = 'Monthly';
        ctr.manufactureYear = 'New';
        ctr.privateSales = 'N';
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        // ctr.realtimeNaf=
        system.debug('ctr.productGoodsType****' + ctr.productGoodsType);
        ctr.baseRateCalc();
        ctr.calculate();

        ctr.residualValue = 10000.00;
        ctr.clientRate = 4.00;
        ctr.term = 24;
        ctr.propertyOwner = 'Y';
        ctr.validate();
        ctr.clientRate = 4.75;
        ctr.term = 60;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        // ctr.realtimeNaf=
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

        // test for baseRateCalc ()
        // ctr.reset();
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.privateSales = 'N';
        ctr.term = 60;
        ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
        ctr.brokeragePercentage = 2;
        ctr.baseRateCalc();
        ctr.calculate();
        // System.assert(ctr.rental > 0);

        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        //Insuracnes
        ctr.mvLevel = 'MV';
        ctr.mv = 1500;
        ctr.mvIncome = 150;

        ctr.gapLevel = 'MV';
        ctr.gap = 700;
        ctr.gapIncome = 150;

        ctr.ltiLevel = 'MV';
        ctr.lti = 600;
        ctr.ltiIncome = 150;

        ctr.warrantyLevel = 'MV';
        ctr.warranty = 1500;
        ctr.warranty = 150;

        ctr.taiLevel = 'MV';
        ctr.tai = 1500;
        ctr.taiIncome = 150;

        ctr.nwc = 1500;
        ctr.nwcIncome = 150;

        ctr.tradeIn = 0;
        ctr.payoutOn = 0;

        ctr.cci = 1200;
        ctr.cciIncome = 200;

        ctr.mvAcceptance = 'A';
        ctr.gapAcceptance = 'A';
        ctr.taiAcceptance = 'A';
        ctr.ltiAcceptance = 'A';
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';

        ctr.calculate();
        ctr.saveQuoting();

        // - Insurance Quote Test
        // ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        ctr.acceptQuoteGAP();
        ctr.acceptQuoteTAS();
        //ctr.acceptQuoteLTI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        ctr.acceptQuoteCCI();

        ctr.savePreApproval();

        ctr.declineQuoteMV();
        ctr.declineQuoteGAP();
        ctr.declineQuoteTAS();
        //ctr.declineQuoteLTI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();
        ctr.declineQuoteCCI();
        ctr.calculate();
        ctr.sendPresentationStep1();
        ctr.calculate();
        ctr.sendPresentationStep2();
        // ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.isValidPresentation();
        ctr.getPresentationUrlCode();

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
        ctr.getDisplayCCIInsurance();

        ctr.getQuoteNumberOptions();
        ctr.importQuote();
        ctr.getHasUserMessages();
        ctr.getDisplayNwcInsurance();
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        ctr.getProtectecResult();

        // ctr.privateSales = 'Y';
        ctr.applicationFeefCalc();
        ctr.privateSales = 'N';
        ctr.applicationFeefCalc();
        ctr.mcqUser = 'eee';

        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
    }
    @isTest
    static void testCalculatorAA() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(
            Test_DataGeneratorHelper.tstOpportunity
        );

        // Macquarie Commercial Calculator
        PageReference boqCommercial = Page.BOQCommercial;
        boqCommercial.getParameters().put('ppsr', '6');

        boqCommercial.getParameters()
            .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(boqCommercial);
        BOQCommercialExtension ctr = new BOQCommercialExtension(sc);
        ctr.ppsr = 6;
        ctr.term = 24;
        ctr.deposit = 2233.00;
        ctr.productLoanType = 'Commercial Loan';
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.carPrice = 12000.00;
        ctr.deposit = 2233.00;
        ctr.loanFrequency = 'Monthly';
        ctr.manufactureYear = 'New';
        ctr.monthlyFee = 7.5;
        ctr.paymentType = 'Advance';
        ctr.privateSales = 'N';
        // ctr.calculate();
        // ctr.customerProfile = 'Ys';
        // ctr.brokerageBase = 2;
        // ctr.dof = 2;
        // ctr.baseRate=4.75;
        // ctr.clientRate=4.75;
        system.debug('ctr.productGoodsType****' + ctr.productGoodsType);
        ctr.baseRateCalc();
        ctr.calculate();
        // ctr.updateQuoteRecord();
        ctr.savePreApproval();
        ctr.reset();
        Test.stopTest();
    }

    // @isTest
    // static void testCalculatorB() {
    //     Test_DataGeneratorHelper.createApplication();
    //     Test_DataGeneratorHelper.reloadOpportunity();
    //     Test_DataGeneratorHelper.createQuote();
    //     Test_DataGeneratorHelper.createQuoting();
    //     Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    //     update Test_DataGeneratorHelper.quoting;
    //     test.startTest();
    //     ApexPages.StandardController sc = new ApexPages.StandardController(
    //         Test_DataGeneratorHelper.tstOpportunity
    //     );

    //     // Macquarie Commercial Calculator
    //     PageReference BOQCommercial = Page.BOQCommercial;
    //     BOQCommercial.getParameters()
    //         .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    //     Test.setCurrentPageReference(BOQCommercial);
    //     BOQCommercialExtension ctr = new BOQCommercialExtension(sc);

    //     ctr = new BOQCommercialExtension(sc);
    //     ctr.productLoanType = 'Consumer Loan';
    //     ctr.productGoodsType = 'Earthmoving';

    //     ctr.mvAcceptance = 'A';
    //     ctr.acceptQuoteMV();
    //     ctr.gapAcceptance = 'A';
    //     ctr.acceptQuoteGAP();
    //     ctr.taiAcceptance = 'A';
    //     ctr.acceptQuoteTAS();
    //     //ctr.ltiAcceptance = 'A';
    //     //ctr.acceptQuoteLTI();
    //     ctr.warrantyAcceptance = 'A';
    //     ctr.nwcAcceptance = 'A';
    //     ctr.acceptQuoteWRR();
    //     ctr.saveQuoting();
    //     ctr.savePreApproval();

    //     ctr.nwc = 100;
    //     ctr.nwcPlan = null;
    //     ctr.nwcIncome = null;
    //     ctr.acceptQuoteNWC();
    //     ctr.nwcPlan = 'A';
    //     ctr.acceptQuoteNWC();
    //     ctr.nwcIncome = 100;
    //     ctr.acceptQuoteNWC();
    //     ctr.nwcAcceptance = 'A';
    //     //NWCCalculator HJ - I - 12-07-2018 - Car
    //     ctr.nwcParam.awd4wd = 'No';
    //     ctr.nwcParam.luxuryCar = 'Yes';
    //     ctr.nwcParam.type_p = 'NWC';
    //     ctr.nwcParam.isManuallyNWCPrice = false;
    //     //ctr.nwcParam.nwcPriceToCustomer = 14000;
    //     ctr.nwcParam.assetType = 'Car';
    //     ctr.nwcPlan = 'A';
    //     ctr.nwcTerm = '12';
    //     ctr.nwcParam.state = 'SA';
    //     ctr.checkManuallyNWCPrice();
    //     ctr.calculateNWC();
    //     //NWCCalculator HJ - F - 12-07-2018
    //     ctr.acceptQuoteNWC();
    //     ctr.acceptQuoteNWC();
    //     ctr.nationalWarrantyCalc();

    //     ctr.mvAcceptance = 'D';
    //     ctr.declineQuoteMV();

    //     ctr.gapAcceptance = 'D';
    //     ctr.declineQuoteGAP();

    //     ctr.taiAcceptance = 'D';
    //     ctr.declineQuoteTAS();

    //     ctr.ltiAcceptance = 'D';
    //     //ctr.declineQuoteLTI();

    //     ctr.warrantyAcceptance = 'D';
    //     //ctr.declineQuoteLTI();

    //     ctr.nwcAcceptance = 'D';
    //     ctr.declineQuoteWRR();

    //     ctr.mv = 100;
    //     ctr.hasQuotingInsProducts();

    //     ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
    //     ctr.importQuote();

    //     ctr.changeLoanProduct();

    //     ctr.getOptions();
    //     ctr.getCciLevelSelect();
    // }

    // @isTest
    // static void testInsuranceProductSelected() {
    //     test.startTest();
    //     Test_DataGeneratorHelper.createApplication();
    //     ApexPages.StandardController sc = new ApexPages.StandardController(
    //         Test_DataGeneratorHelper.tstOpportunity
    //     );

    //     PageReference calcRef = Page.BOQCommercial;
    //     calcRef.getParameters()
    //         .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    //     Test.setCurrentPageReference(calcRef);
    //     BOQCommercialExtension ctr = new BOQCommercialExtension(sc);

    //     ctr.reset();
    //     ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
    //     ctr.carPrice = 25000.00;
    //     ctr.carAge = 1;
    //     ctr.privateSales = 'N';
    //     ctr.term = 60;
    //     ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
    //     ctr.brokeragePercentage = 2;
    //     ctr.baseRateCalc();
    //     ctr.calculate();
    //     // System.assert(ctr.rental > 0);

    //     // no insurance products means TRUE
    //     // System.assert(ctr.insuranceProductSelected());
    //     // Motor Vehicle
    //     ctr.mvLevel = 'MV';
    //     // System.assert(!ctr.insuranceProductSelected());
    //     ctr.mvAcceptance = 'A';
    //     // System.assert(ctr.insuranceProductSelected());
    //     // GAP
    //     ctr.gapLevel = 'GAP';
    //     // System.assert(!ctr.insuranceProductSelected());
    //     ctr.gapAcceptance = 'A';
    //     // System.assert(ctr.insuranceProductSelected());
    //     // RTI
    //     ctr.gapLevel = null;
    //     ctr.gapAcceptance = null;
    //     ctr.taiLevel = 'RTI';
    //     // System.assert(!ctr.insuranceProductSelected());
    //     ctr.taiAcceptance = 'A';
    //     // System.assert(ctr.insuranceProductSelected());
    //     // LTI
    //     // Warranty
    //     ctr.warrantyLevel = 'LTI';
    //     // System.assert(!ctr.insuranceProductSelected());
    //     ctr.warrantyAcceptance = 'A';
    //     // System.assert(ctr.insuranceProductSelected());
    //     // NWC
    //     ctr.warrantyLevel = null;
    //     ctr.warrantyAcceptance = null;
    //     ctr.nwc = 15000;
    //     // System.assert(!ctr.insuranceProductSelected());
    //     ctr.nwcAcceptance = 'A';
    //     // System.assert(ctr.insuranceProductSelected());
    // }

    @isTest
    static void testLoadQuotingParameters() {
        test.startTest();
        System.debug('tesFullProductSelected...');
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        LenderQuotingWrapperDTO lender = new LenderQuotingWrapperDTO();
        lender.carPrice = 20000;
        lender.deposit = 2000;
        lender.term = 36;
        lender.productLoanType = 'Purchase';
        lender.productGoodsType = 'Earthmoving';
        lender.loanFrequency = 'Monthly';
        lender.vehicleYear = 'New';
        lender.vehicleYear = 'New';
        lender.privateSales = 'N';
        // lender.propertyOwner = 'N';
        lender.customerProfile = 'Ys';
        lender.brokerageBase = 2;
        lender.dofBase = 2;
        lender.info = new Lenders__c();
        lender.info.Code__c = 'MCOM';
        lender.ltv = '2';
        Test_DataGeneratorHelper.tstOpportunity.Pre_Quoting_Object__c = JSON.serialize(
            lender
        );
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.StandardController sc = new ApexPages.StandardController(
            Test_DataGeneratorHelper.tstOpportunity
        );

        PageReference calcRef = Page.BOQCommercial;
        calcRef.getParameters()
            .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
        calcRef.getParameters().put('preloadQuting', '1');
        Test.setCurrentPageReference(calcRef);
        BOQCommercialExtension ctr = new BOQCommercialExtension(sc);
        ctr.propertyOwner = 'Y';
        ctr.mvAcceptance = 'A';
        //ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        //ctr.acceptQuoteGAP();
        ctr.taiAcceptance = 'A';
        //ctr.acceptQuoteTAS();
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        ctr.tradeIn = 2;
        ctr.payoutOn = 2;
        ctr.savePreApproval();

        Test_DataGeneratorHelper.applicationQuotingBOQ(false);
        calcRef.getParameters().put('preloadQuting', '2');
        Test.setCurrentPageReference(calcRef);
        ctr = new BOQCommercialExtension(sc);
        ctr.propertyOwner = 'Y';
        ctr.mvAcceptance = 'A';
        //ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        //ctr.acceptQuoteGAP();
        ctr.taiAcceptance = 'A';
        //ctr.acceptQuoteTAS();
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        ctr.tradeIn = 2;
        ctr.payoutOn = 2;
        ctr.savePreApproval();
    }
}