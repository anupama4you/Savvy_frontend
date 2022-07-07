@isTest(SeeAllData=true)
private class TestANZConsumerCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
             
        // ANZ Consumer Calculator
        PageReference ANZConsumer = Page.EsandaCalculator;
        ANZConsumer.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(ANZConsumer);
        EsandaCalculatorExtension ctr = new EsandaCalculatorExtension(sc);
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.vehicleAge = '0';
        ctr.carPrice = 50000.00;
        ctr.deposit = 2000.00;
        ctr.residualValue = 1000.00;
        ctr.applicationFee = 350.00;
        ctr.dof = 770.00;
        ctr.ppsr = 6.80;
        ctr.monthlyFee = 5;
        
        // test for baseRateCalc()
        ctr.ltv = '';
        ctr.baseRateCalc();
        ctr.ltv = 'OG';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.ltv = '80';
        ctr.customerProfile = '';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.ltv = '130';
        ctr.customerProfile = '';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.ltv = '150';
        ctr.customerProfile = '';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - New Car';
        ctr.baseRateCalc();
        ctr.customerProfile = 'Non Property Owner - Old Car';
        ctr.baseRateCalc();
        ctr.adverseCredit = 'Y';
        ctr.baseRateCalc();
        ctr.term = 72;
        ctr.baseRateCalc();
        ctr.adverseCredit = 'N';
        ctr.baseRateCalc();
        ctr.term = 60;
        
        ctr.ltv = '80';
        ctr.customerProfile = 'Property Owner - New Car';
        ctr.clientRate = 5.00;
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

        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.validation();
        ctr.calculate();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.reset();
        ctr.baseRateCalc();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.calculate();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.term = 60;
        ctr.calculate();
        ctr.saveQuoting();

        ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        ctr.acceptQuoteGAP();
        ctr.acceptQuoteTAS();
        ctr.acceptQuoteLTI();
        ctr.acceptQuoteCCI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        
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

        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new EsandaCalculatorExtension(sc);

        ctr.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        ctr.acceptQuoteGAP();
        ctr.taiAcceptance = 'A';
        ctr.acceptQuoteTAS();
        ctr.ltiAcceptance = 'A';
        ctr.acceptQuoteLTI();
        ctr.cciAcceptance = 'A';
        ctr.acceptQuoteCCI();
        ctr.warrantyAcceptance = 'A';
        ctr.acceptQuoteWRR();
        
        ctr.nwc = 100;
        ctr.acceptQuoteNWC();
        ctr.nwcPlan = 'A';
        ctr.acceptQuoteNWC();
        ctr.nwcIncome = 100;
        ctr.acceptQuoteNWC();
        ctr.nwcAcceptance = 'A';
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

        ctr.cciAcceptance = 'D';
        ctr.declineQuoteCCI();

        ctr.warrantyAcceptance = 'D';
        ctr.declineQuoteLTI();

        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.mv = 100;
        ctr.hasQuotingInsProducts();

        ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
        ctr.importQuote();

        ctr.getDisplayCCIInsurance();

	}
}