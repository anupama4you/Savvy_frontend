@isTest(SeeAllData=true)
private class TestPepperMVCalc {
    private static String endPointApplication = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_ENDPOINT);	
	
    @isTest static void testCalculator() {
		    test.startTest();
        Test_DataGeneratorHelper.createApplication();
        
        Test_DataGeneratorHelper.createAssetDetailLTV();
        
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Pepper MV Calculator
        PageReference PepperMV = Page.PepperCalculatorMV;
        // PageReference PepperMV = Page.ClonCalc;
        PepperMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperMV);

        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        //ClonCalcExtension ctr = new ClonCalcExtension(sc);

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
        
        ctr.warrantyLevel = 'Platinum - 24 months';

        ctr.warrantyLevel = 'Platinum - 12 months';
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
        ctr.calculate();
        ctr.clientRate = 13.00;
        ctr.calculate();
        ctr.clientTier = 'C';
        ctr.clientRate = 20.00;
        ctr.calculate();
        ctr.clientRate = 10.00;
        ctr.calculate();
        ctr.clientTier = 'A';
        ctr.clientRate = 12.00;
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
        ctr.acceptQuoteCCI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        ctr.declineQuoteMV();
        ctr.declineQuoteGAP();
        ctr.declineQuoteCCI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();
        ctr.getPresentationUrlCode();
        ctr.getInsuranceFailureReasons();
        ctr.getCustomerPresentationStatusStyle();

        ctr.getLenderQuoting();

        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();

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
        ctr = new PepperCalculatorMVExtension(sc);

        ctr.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        ctr.gapAcceptance = 'A';
        ctr.acceptQuoteGAP();
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
        ctr.nationalWarrantyCalc();

        ctr.mvAcceptance = 'D';
        ctr.declineQuoteMV();

        ctr.gapAcceptance = 'D';
        ctr.declineQuoteGAP();

        ctr.cciAcceptance = 'D';
        ctr.declineQuoteCCI();

        ctr.warrantyAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteNWC();

        ctr.mv = 100;
        
        Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Pepper MV';
        update Test_DataGeneratorHelper.quote;
        ctr = new PepperCalculatorMVExtension(sc);
        
        ctr.getIsBrokerPartnerUser();

        ctr.getTierOptions();

	}
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperCalculatorMV;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productGoodsType = 'Caravan';
        ctr.carPrice = 250000.00;
        ctr.clientRate = ctr.baseRate;
        ctr.privateSales = 'Y';
        ctr.calculate();
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

        ctr.getPepperRates();

    }		
    
   	@isTest static void testCalculatorWithUsedCarYear0_5() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.asset.Condition__c = 'used';
        Test_DataGeneratorHelper.asset.Year__c = 2017;
        update Test_DataGeneratorHelper.asset;
        
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Pepper MV Calculator
        PageReference PepperMV = Page.PepperCalculatorMV;
        PepperMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperMV);

        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);

        ctr.vehicleAge = 'Used 0-5 years';
        ctr.validateVehicleAgeWithYear();
	}
    
    @isTest static void testCalculatorWithUsedCarYear6_9() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        

        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.asset.Condition__c = 'used';
        Test_DataGeneratorHelper.asset.Year__c = 2011;
        update Test_DataGeneratorHelper.asset;
        
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Pepper MV Calculator
        PageReference PepperMV = Page.PepperCalculatorMV;
        PepperMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperMV);

        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);

        ctr.vehicleAge = 'Used 6-9 years';
        ctr.validateVehicleAgeWithYear();
    }
    
   	@isTest static void testCalculatorWithUsedCarYear10Plus() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.asset.Condition__c = 'used';
        Test_DataGeneratorHelper.asset.Year__c = 2007;
        update Test_DataGeneratorHelper.asset;
        
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Pepper MV Calculator
        PageReference PepperMV = Page.PepperCalculatorMV;
        PepperMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperMV);

        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);

        ctr.vehicleAge = 'Used 10+ years';
        ctr.validateVehicleAgeWithYear();
	}
    
    
    @isTest static void testCalculatorAssetDetailNull() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        
        Test_DataGeneratorHelper.reloadOpportunity();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Pepper MV Calculator
        PageReference PepperMV = Page.PepperCalculatorMV;
        PepperMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(PepperMV);

        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"application": {"applicationNo": "P-20190503004400"},"requestId": "d21f9a70-48e4-11e8-bf5f-024abd6c08ae"}', 200);
        requestMocks.addRequestMock(endPointApplication+'/applications/consumer', fakeRes);
        fakeRes = getQuickMockRequest('{"applicationId": "AD-1002502","responseMessage": "Document uploaded successfully","requestId": "aba58620-11fa-11eb-b1fa-025fad8dc2b8"}', 200);
        requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
		ctr.apiUser = '1234';
        ctr.submitRequest = true;
        ctr.sendApplication();
        ctr.submitRequest = false;
        ctr.sendApplication();
        ctr.vehicleAge = 'Used 11+ years';
        ctr.validateVehicleAgeWithYear();
	}

    @isTest static void testPepperAPI() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperCalculatorMV;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 25000.00;
        ctr.clientRate = ctr.baseRate;
        ctr.calculate();
        ctr.save();
        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        ctr.pepperApplicationTest();
        ctr.pepperApplication();

    }


@isTest static void testPepperAPI2() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.asset.Condition__c = 'used';
        Test_DataGeneratorHelper.asset.Year__c = 2007;
        update Test_DataGeneratorHelper.asset;
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperCalculatorMV;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 25000.00;
        ctr.clientRate = ctr.baseRate;
        ctr.calculate();
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"application": {"applicationNo": "P-20190503004400"},"requestId": "d21f9a70-48e4-11e8-bf5f-024abd6c08ae"}', 200);
        requestMocks.addRequestMock(endPointApplication+'/applications/consumer', fakeRes);
        fakeRes = getQuickMockRequest('{"applicationId": "AD-1002502","responseMessage": "Document uploaded successfully","requestId": "aba58620-11fa-11eb-b1fa-025fad8dc2b8"}', 200);
        requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        test.startTest();
		ctr.apiUser = '1234';
        ctr.submitRequest = true;
        ctr.sendApplication();
        ctr.submitRequest = false;
        ctr.sendApplication();
        ctr.sendFiles();
        ctr.apiUser = '';
        ctr.sendFiles();
        test.stopTest();
    }

    @isTest static void testPepperAPI3() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.asset.Condition__c = 'used';
        Test_DataGeneratorHelper.asset.Year__c = 2007;
        update Test_DataGeneratorHelper.asset;
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.PepperCalculatorMV;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        PepperCalculatorMVExtension ctr = new PepperCalculatorMVExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 25000.00;
        ctr.clientRate = ctr.baseRate;
        ctr.calculate();
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"errorCode": "INVALID_APPLICATION","errorMessage": "Error validating JSON. Error: - Missing required field \'product\'","requestId": "12975b60-48e5-11e8-bf5f-024abd6c08ae"}', 400);
        requestMocks.addRequestMock(endPointApplication+'/applications/consumer', fakeRes);
        fakeRes = getQuickMockRequest('{"errorCode": "INVALID_APPLICATION","errorMessage": "Error validating JSON. Error: - Missing required field \'product\'","requestId": "12975b60-48e5-11e8-bf5f-024abd6c08ae"}', 400);
        requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        test.startTest();
		ctr.apiUser = '1234';
        ctr.submitRequest = true;
        ctr.sendApplication();
        ctr.submitRequest = false;
        ctr.sendApplication();
        ctr.sendFiles();
        ctr.apiUser = '';
        ctr.sendFiles();
        test.stopTest();
    }

    private static SingleRequestMock getQuickMockRequest(String body, Integer code) {
        SingleRequestMock r = new SingleRequestMock(
            code, 'Complete', body, null
        );
        return r;
    }
}