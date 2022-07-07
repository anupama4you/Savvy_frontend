@isTest(SeeAllData=true)
private class TestMoney3Calc extends TestAPILenders{
	private static String endPointApplication = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_ENDPOINT);
    private static String documentEndpoint = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_DOCUMENT_ENDPOINT);
	@isTest static void testCalculator() {
		test.startTest();
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Finance One
        PageReference calcRef = Page.Money3Calculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        Money3CalculatorExtension ctr = new Money3CalculatorExtension(sc);
        
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
        ctr = new Money3CalculatorExtension(sc);
        
        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','MONEY3 CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsMoney3();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(endPointApplication, 'Money3APILoan_Response');
        multimock.setStaticResource(documentEndpoint, 'Money3APIDocument_Response');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json'); 
        Test.setMock(HttpCalloutMock.class, multimock);
        ctr.money3Application();
        test.stopTest();
	}
    
    @isTest static void testInsuranceProductSelected() {
        test.startTest();
       
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        PageReference calcRef = Page.Money3Calculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        Money3CalculatorExtension ctr = new Money3CalculatorExtension(sc);
        
        ctr.reset();
        
        ctr.profile = 'Asset Finance';
        ctr.grading = 'Platinum';
        ctr.carPrice = 25000.00;
        ctr.clientRate = 20.00;
        ctr.baseRate = ctr.clientRate;
        ctr.term = 36;
        ctr.riskFee = ctr.getLoanAmount();
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
        Test_DataGeneratorHelper.quoting.Name = 'Money3';
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Money3';
        update Test_DataGeneratorHelper.quote;
        ctr = new Money3CalculatorExtension(sc);
        
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
       
    @isTest static void testInsuranceProductSelected2() {
        
        Test_DataGeneratorHelper.createOpportunity();
        
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"id": "081dcdaf-0cf8-44ae-a085-0bc72d1082ea","file": "driver-license.png","documentType": "Driver\'s License","note": "Only has P plate","byteSize": 14787,"createdAt": "2017-03-19T13:38:02+11:00"}', 201);
        requestMocks.addRequestMock(documentEndpoint, fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
                
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        PageReference calcRef = Page.Money3Calculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        Money3CalculatorExtension ctr = new Money3CalculatorExtension(sc);
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        test.startTest();
        ctr.money3API_BrokerReferenceId = '2617480a-6319-3c53-90e0-061969443def';
        ctr.sendFiles();
        ctr.money3API_BrokerReferenceId = null;
        ctr.money3APIMgr = new Money3APIManager();
        ctr.money3APIMgr.responseDto = new Money3APIResponseDTO();
        ctr.money3APIMgr.responseDto.loanId = 1;
        ctr.saveLenderAPIResponseFile();
        test.stopTest();
    }
    
    @isTest static void testInsuranceProductSelected3() {
               
        Test_DataGeneratorHelper.createApplication();
        
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        
        Test_DataGeneratorHelper.tstApp.Status__c = 'F';
        update Test_DataGeneratorHelper.tstApp;
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"loanId": 456765,"brokerReferenceLoanId": "12345678","broker": "Johnny Money","submissionStatus": "Application Received","note": "If you haven\'t already, please upload the required documents so that Money3 can assess this loan.","additionalDetails": [{"field": "Address Renting Contact","message": "Renting Contact detials shoul dbe provided when applicant is renting"}],"createdAt": "2017-03-19T13:38:02+11:00"}', 200);
        requestMocks.addRequestMock(endPointApplication, fakeRes);
        fakeRes = getQuickMockRequest('{"id": "081dcdaf-0cf8-44ae-a085-0bc72d1082ea","file": "driver-license.png","documentType": "Driver\'s License","note": "Only has P plate","byteSize": 14787,"createdAt": "2017-03-19T13:38:02+11:00"}', 201);
        requestMocks.addRequestMock(documentEndpoint, fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        Lender_Login__c userLogin = new Lender_Login__c();
        userLogin.Lender__c = 'Money3';
        userLogin.User_Name__c = '1234';
        insert userLogin;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        PageReference calcRef = Page.Money3Calculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        Money3CalculatorExtension ctr = new Money3CalculatorExtension(sc);
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
        test.stopTest();
    }
    
    private static SingleRequestMock getQuickMockRequest(String body, Integer code) {
        SingleRequestMock r = new SingleRequestMock(
            code, 'Complete', body, null
        );
        return r;
    }
}