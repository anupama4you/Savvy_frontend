@isTest(SeeAllData=true)
public class TestSelfcoCalc {
    @isTest static void testValidations() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference Selfco = Page.Selfco;
        Selfco.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Selfco);
        SelfcoExtension ctr = new SelfcoExtension(sc);
        
        ctr.reset();
        ctr.validate();
        ctr.brokeragePercentage = 9;
        ctr.realtimeNaf = 25000;
        ctr.validate();


        ctr.validate();
        
        ctr.getIsBrokerPartnerUser();
        
    }
    @isTest static void testLoadQuotingParameters(){
        test.startTest();
        System.debug('tesFullProductSelected...');
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        LenderQuotingWrapperDTO lender = new LenderQuotingWrapperDTO();
        lender.carPrice = 20000;
        lender.deposit = 2000;
        lender.term = 36;
        lender.productLoanType = 'Purchase';
        lender.productGoodsType = 'Motor Vehicle';
        lender.productGoodsSubType = 'Cars';
        lender.loanFrequency = 'Monthly';
        lender.vehicleYear  = '2017';
        lender.privateSales = 'No';
        lender.customerProfile = 'No';
        lender.brokerageBase = 2;
        lender.dofBase = 2;
        lender.info = new Lenders__c();
        lender.info.Code__c = 'SELF';
        lender.ltv = '2';
        Test_DataGeneratorHelper.tstOpportunity.Pre_Quoting_Object__c = JSON.serialize(lender);
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.Selfco;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcRef.getParameters().put('preloadQuting','1');
        Test.setCurrentPageReference(calcRef);
        SelfcoExtension ctr = new SelfcoExtension(sc);
        
        ctr.mvAcceptance = 'A';
        ctr.gapAcceptance = 'A';
        ctr.taiAcceptance = 'A';
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        ctr.isAssetBoat = true;
        ctr.tradeIn = 2;
        ctr.payoutOn = 2;
        ctr.assetAge = '1';
        ctr.savePreApproval();
    }
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.Selfco;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        SelfcoExtension ctr = new SelfcoExtension(sc);
        
        ctr.reset();
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.changeGoodsType();
        ctr.productGoodsSubType = ctr.productGoodsSubTypes.get(1).getValue();
        ctr.carPrice = 25000.00;
        ctr.carAge = 1;
        ctr.privateSales = 'N';
        ctr.term = 12;
        
        ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
        ctr.ltv = 0;
        ctr.brokeragePercentage = 2;
        ctr.equifaxScore = 700;
        ctr.abnLength = '> 2 years';
        ctr.gstLength = '> 2 years';
        ctr.assetAge = '1';
        ctr.baseRateCalc();       
        ctr.baseRate = 20;
        ctr.calculate();
        
        
        //System.assert(ctr.rental > 0);JOY

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
    
    @isTest static void testCalculatorA() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference Selfco = Page.Selfco;
        Selfco.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Selfco);
        SelfcoExtension ctr = new SelfcoExtension(sc);
        
        ctr.reset();
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.changeGoodsType();
        ctr.productGoodsSubType = ctr.productGoodsSubTypes.get(1).getValue();
        ctr.carPrice = 2500000.00;
        ctr.carAge = 1;
        ctr.privateSales = 'N';
        ctr.term = 60;
        ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
        ctr.ltv = 0;
        ctr.brokeragePercentage = 2;
        ctr.equifaxScore = 700;
        ctr.abnLength = '> 2 years';
        ctr.gstLength = '> 2 years';
        ctr.assetAge = '1';
        ctr.baseRateCalc(); 
        ctr.calculate();
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.residualValue = 10.00;
        ctr.clientRate = 15.00;
        ctr.term = 60;
        ctr.equifaxScore = 700;
        ctr.abnLength = '> 2 years';
        ctr.gstLength = '> 2 years';
        ctr.validate();
        ctr.clientRate = 7.00;
        ctr.term = 60;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
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
        ctr.reset();
        ctr.baseRate = 20;
        ctr.equifaxScore = 700;
        ctr.abnLength = '> 2 years';
        ctr.gstLength = '> 2 years';
        ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
        ctr.changeGoodsType();
        ctr.productGoodsSubType = ctr.productGoodsSubTypes.get(1).getValue();
        ctr.carPrice = 25000.00;
        ctr.carAge = 1;
        ctr.privateSales = 'N';
        ctr.term = 60;
        ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
        ctr.ltv = 0;
        ctr.brokeragePercentage = 2;
        ctr.baseRateCalc();       
        ctr.calculate();
        //System.assert(ctr.rental > 0);

      
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

        ctr.sendPresentationStep1();
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

        ctr.privateSales = 'Y';
        ctr.applicationFeefCalc();
        ctr.privateSales = 'N';
        ctr.applicationFeefCalc();
        ctr.mcqUser = 'eee';

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
    }
    
    @isTest static void testCalculatorB() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        Test_DataGeneratorHelper.quoting.Base_Rate__c = 1;
        update Test_DataGeneratorHelper.quoting;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference Selfco = Page.Selfco;
        Selfco.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Selfco);
        SelfcoExtension ctr = new SelfcoExtension(sc);

        ctr = new SelfcoExtension(sc);
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.brokeragePercentage = 2;
        ctr.equifaxScore = 700;
        ctr.abnLength = '> 2 years';
        ctr.gstLength = '> 2 years';
        ctr.assetAge = '1';
        
        ctr.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        ctr.acceptQuoteGAP();
        ctr.taiAcceptance = 'A';
        ctr.acceptQuoteTAS();
        //ctr.ltiAcceptance = 'A';
        //ctr.acceptQuoteLTI();
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.acceptQuoteWRR();
        ctr.saveQuoting();  
		ctr.savePreApproval();
        
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
        //ctr.declineQuoteLTI();

        ctr.warrantyAcceptance = 'D';
        //ctr.declineQuoteLTI();

        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.mv = 100;
        ctr.hasQuotingInsProducts();

        ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
        ctr.importQuote();
        ctr.getRateList();

        ctr.changeLoanProduct();
        ctr.changeGoodsType();

        ctr.getOptions();
        ctr.macquarieQuoteRestart();
        ctr.getCciLevelSelect();
    }

}