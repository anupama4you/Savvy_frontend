@isTest(SeeAllData=true)
private class TestANZOthersCalc {
	
	@isTest static void testCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // ANZ Others Calculator
        PageReference ANZOthers = Page.EsandaOthers;
        ANZOthers.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(ANZOthers);
        EsandaOthersExtension ctr = new EsandaOthersExtension(sc);
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.residualValue = 10000.00;
        ctr.brokeragePercentage = 4;
        ctr.baseRate = 4.00;
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
        
        // test for recommendedRateCalc()
        ctr.recommendedRateCalc();
        ctr.vehiclesProfile = 'New';
        ctr.recommendedRateCalc();
        ctr.vehiclesProfile = 'Used';
        ctr.recommendedRateCalc();
        ctr.goodsType = 'equipment';
        ctr.recommendedRateCalc();
        ctr.vehiclesProfile = 'New';
        ctr.recommendedRateCalc();
        ctr.vehiclesProfile = 'Used';
        ctr.recommendedRateCalc();
        ctr.goodsType = 'chattel';
        ctr.vehiclesProfile = 'New';
        ctr.recommendedRateCalc();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.goodsType = 'chattel';
        ctr.vehiclesProfile = 'New';
        ctr.saveQuoting();
        ctr.vehiclesProfile = 'Used';
        ctr.saveQuoting();
        ctr.goodsType = 'equipment';
        ctr.vehiclesProfile = 'New';
        ctr.saveQuoting();
        ctr.vehiclesProfile = 'Used';
        ctr.saveQuoting();
        ctr.reset();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.clientRate = 1.00;
        ctr.baseRate = 1.00;
        ctr.term = 0;
        ctr.calculate();
        ctr.saveQuoting();

        ctr.getProtectecResult();
        ctr.getChattelRates();
        ctr.getEquipmentRates();
	}
	
}