@isTest(SeeAllData=true)
private class KrispCalcExtensionTest extends TestAPILenders{

	@isTest static void testCalculator() {
		test.startTest();
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Finance One
        PageReference calcRef = Page.KrispCalc;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        KrispCalcExtension ctr = new KrispCalcExtension(sc);
        
        ctr.calculate();
        ctr.applicationFee = null;
        ctr.dof = null;
        ctr.ppsr = null;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.profile = 'Asset Finance';
        ctr.grading = 'Platinum';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.ppsr = 10.00;
        ctr.residualValue = 10000.00;
        ctr.clientRate = 23.00;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
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
        
        // test for baseRateCalc() and calculateValidation()
        ctr.reset();
        ctr.profile = 'Asset Finance';
        ctr.grading = 'Platinum';
        ctr.carPrice = 25000.00;
        ctr.clientRate = 20.00;
        ctr.baseRate = ctr.clientRate;
        ctr.term = 60;
        ctr.riskFee = ctr.getLoanAmount();
        ctr.calculate();
        System.debug('rental A: ' + ctr.rental);
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.saveQuoting();
        
        // Insurance
        ctr.mvLevel = 'Comprehensive';
        ctr.mv = 5000.00;
        ctr.mvIncome = 2500.00;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        ctr.warrantyLevel = 'Platinum - 12 months';
        ctr.warranty = 2000.00;
        ctr.warrantyIncome = 1000.00;
        ctr.calculate();
        System.debug('rental B: ' + ctr.rental);
        ctr.saveAmendment();
        ctr.getPresentationUrlCode();

        ctr.saveFormalApproval();
        
        ctr.getLenderQuoting();
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

        ctr.hasValidQuotation();
        ctr.calculateQuote();
        ctr.storeQuotingData();
        
        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
       
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new KrispCalcExtension(sc);
        
        test.stopTest();
	}
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
       
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        PageReference calcRef = Page.KrispCalc;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        KrispCalcExtension ctr = new KrispCalcExtension(sc);
        
        ctr.reset();
        
        ctr.profile = 'Asset Finance';
        ctr.grading = 'Platinum';
        ctr.carPrice = 25000.00;
        ctr.clientRate = 20.00;
        ctr.baseRate = ctr.clientRate;
        ctr.term = 36;
        ctr.applicationFeeCalc();
        ctr.calculate();
        ctr.save();
        
        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        // no insurance products means TRUE
        System.assert(ctr.insuranceProductSelected());
        // Motor Vehicle
        ctr.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
        ctr.mvLevel = 'MV';
        ctr.mv = 1000.0;
        ctr.mvIncome = 100.0;
        System.assert(!ctr.insuranceProductSelected());
        ctr.mvAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // GAP
        ctr.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
        ctr.gapLevel = 'GAP';
        ctr.gap = 1000;
        ctr.gapIncome = 100;
        ctr.gapTerm = String.valueOf(ctr.term);
        System.assert(!ctr.insuranceProductSelected());
        ctr.gapAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // Warranty
        ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
        ctr.warrantyLevel = 'Warrlevel';
        ctr.warranty = 1000;
        ctr.warrantyIncome = 100.0;
        ctr.warrantyTerm = String.valueOf(ctr.term);
        System.assert(!ctr.insuranceProductSelected());
        ctr.warrantyAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

        // lpi - cci
        System.debug('LPI tests...');
        ctr.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
        ctr.cciLevel = 'LPI Level';
        ctr.cci = 15000;
        ctr.cciIncome = 100;
        ctr.cciTerm = String.valueOf(ctr.term);
        System.assert(!ctr.insuranceProductSelected());
        ctr.cciAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

        ctr.savePreApproval();

        // NWC
        ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
        ctr.warrantyAcceptance = null;
        ctr.warrantyLevel = null;
        ctr.warranty = null;
        ctr.warrantyIncome = null;
        ctr.nwc = 15000;

        System.assert(!ctr.insuranceProductSelected());
        ctr.nwcAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

        ctr.checkManuallyNWCPrice();
        // NWC
        ctr.nwcPlan = 'Bronze';
        ctr.nwcTerm = '36';
        ctr.nwcParam.assetType = 'Car';
        ctr.nwcParam.type_p = 'Safeguard';
        ctr.nwcParam.vehicleAgeYears = 30;
        ctr.nwcParam.actualKm = 400000;
        ctr.calculateNWC();
        ctr.nwcPlan = 'Silver';
        ctr.calculateNWC();
        ctr.nwcPlan = 'Gold';
        ctr.calculateNWC();
        ctr.nwcPlan = 'Platinum';
        ctr.calculateNWC();
        ctr.nwcPlan = 'A';
        ctr.nwcParam.type_p = 'Integrity';
        ctr.calculateNWC();

        ctr.priceCustomer = 1000.20;
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.nwcParam.nwcPriceToCustomer = null;
        ctr.checkManuallyNWCPrice();
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.nwcParam.nwcPriceToCustomer = 1200;
        ctr.checkManuallyNWCPrice();
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.priceCustomer = null;
        ctr.checkManuallyNWCPrice();
        ctr.nwcAcceptance = 'A';
        ctr.nwcParam.type_p = 'Other';
        ctr.nwc = 1000.0;
        ctr.nwcIncome = 100.0;
        ctr.isNWCValidationOk = true;

        ctr.savePreApproval();
        
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        Test_DataGeneratorHelper.quoting.Name = 'Krisp';
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Krisp';
        update Test_DataGeneratorHelper.quote;
        ctr = new KrispCalcExtension(sc);
        
        ctr.applicationFee = 1000;
        ctr.lenderSettings.Application_Fee__c = 10000;
        ctr.dof = 1000;
        ctr.riskFee = 100000;
        ctr.clientRate = 100000;
        ctr.profile = 'Asset Finance';
        ctr.carPrice = 25000.00;
        ctr.grading = 'Platinum';
        ctr.term = 36;
        ctr.monthlyFee = 1;
        ctr.quote.MV_Acceptance__c = 'A';
        
        ctr.deposit = 1;
        ctr.tradeIn = 1;
        ctr.payoutOn = 1;
        ctr.mvAcceptance = 'A';
        ctr.gapAcceptance = 'A';
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        ctr.saveQuoting();
        ctr.mvAcceptance = 'D';
        ctr.gapAcceptance = 'D';
        ctr.warrantyAcceptance = 'D';
        ctr.nwcAcceptance = 'D';
        ctr.cciAcceptance = 'D';
        ctr.saveQuoting();
        ctr.grading = 'Micro Motor';
        ctr.isValidationOk();
        ctr.profile = 'Personal Finance';
        ctr.grading = 'Mini PL';
        ctr.isValidationOk();
        ctr.grading = 'Platinum';
        ctr.isValidationOk();
        ctr.term = 24;
        ctr.isValidationOk();
        ctr.term = 48;
        ctr.isValidationOk();
        ctr.applicationFee = 10000;
        ctr.lenderSettings.Application_Fee__c = 1000;
        ctr.isValidationOk();
        ctr.residualValue = 1;
        ctr.term = 72;
        ctr.isValidationOk();
    }
    
    private static SingleRequestMock getQuickMockRequest(String body, Integer code) {
        SingleRequestMock r = new SingleRequestMock(
            code, 'Complete', body, null
        );
        return r;
    }
}