@isTest(SeeAllData=true)
private class TestPepperComm {
  private static String endPointApplication = PepperAPIManager.getParameterService(
    PepperAPIManager.PEPPER_SERVICE_ENDPOINT
  );

  @isTest
  static void testCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();

    Test_DataGeneratorHelper.createAssetDetailLTV();

    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    // Pepper MV Calculator
    PageReference PepperComm = Page.PepperComm;
    // PageReference PepperComm = Page.ClonCalc;
    PepperComm.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(PepperComm);

    PepperCommExtension ctr = new PepperCommExtension(sc);
    //ClonCalcExtension ctr = new ClonCalcExtension(sc);
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.residualValue = 10000.00;
    ctr.clientRate = 7.00;
    ctr.clientTier = 'A';

    ctr.realtimeNafCalc();
    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
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

    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    ctr.privateSales = 'Y';
    ctr.applicationFeefCalc();
    ctr.privateSales = 'N';
    ctr.applicationFeefCalc();

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr = new PepperCommExtension(sc);
    ctr.carPrice = 150000.00;
    ctr.clientRate = 1;
    ctr.baseRate = 10;
    ctr.productGoodsType = null;
    ctr.clientTier = null;
    ctr.residualValue = 20000;
    ctr.term = 84;
    ctr.privateSales = null;
    ctr.calculate();
    ctr.productGoodsType = 'Caravan';
    ctr.privateSales = 'Y';
    ctr.clientTier = 'C';
    ctr.calculate();
    ctr.loanType = 'Refinance';
    ctr.loanPurpose = null;
    ctr.calculate();

  }

  @isTest
  static void testInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.PepperComm;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.reset();

    //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 25000.00;
    ctr.vehicleAge = ctr.getAssetAgeOptions().get(1).getValue();
    ctr.baseRateCalc();
    ctr.clientRate = ctr.maxRate;
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

    ctr.getCommercial();
    ctr.getOther2nd3rd();
    ctr.getPrimary();
  }

  @isTest
  static void testCalculatorWithUsedCarYear0_5() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();

    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.asset.Condition__c = 'used';
    Test_DataGeneratorHelper.asset.Year__c = 2017;
    update Test_DataGeneratorHelper.asset;

    Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
    update Test_DataGeneratorHelper.tstOpportunity;

    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    // Pepper MV Calculator
    PageReference PepperComm = Page.PepperComm;
    PepperComm.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(PepperComm);

    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.vehicleAge = 'Used 0-5 years';
    ctr.validateVehicleAgeWithYear();
  }

  @isTest
  static void testCalculatorWithUsedCarYear6_9() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();

    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.asset.Condition__c = 'used';
    Test_DataGeneratorHelper.asset.Year__c = 2011;
    update Test_DataGeneratorHelper.asset;

    Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
    update Test_DataGeneratorHelper.tstOpportunity;

    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    // Pepper MV Calculator
    PageReference PepperComm = Page.PepperComm;
    PepperComm.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(PepperComm);

    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.vehicleAge = 'Used 6-9 years';
    ctr.validateVehicleAgeWithYear();
  }

  @isTest
  static void testCalculatorWithUsedCarYear10Plus() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();

    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.asset.Condition__c = 'used';
    Test_DataGeneratorHelper.asset.Year__c = 2007;
    update Test_DataGeneratorHelper.asset;

    Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
    update Test_DataGeneratorHelper.tstOpportunity;

    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Pepper MV Calculator
    PageReference PepperComm = Page.PepperComm;
    PepperComm.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(PepperComm);

    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.vehicleAge = 'Used 10+ years';
    ctr.validateVehicleAgeWithYear();
  }

  @isTest
  static void testCalculatorAssetDetailNull() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();

    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Pepper MV Calculator
    PageReference PepperComm = Page.PepperComm;
    PepperComm.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(PepperComm);

    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.vehicleAge = 'Used 11+ years';
    ctr.validateVehicleAgeWithYear();
  }

  @isTest
  static void testOtherCodes() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.PepperComm;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.reset();

    //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 25000.00;
    ctr.vehicleAge = ctr.getAssetAgeOptions().get(1).getValue();
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate;
    ctr.calculate();
    ctr.save();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);
    ctr.savePreApproval();

    ctr.pepperApplicationTest();
    ctr.pepperApplication();

    ctr.getIsBrokerPartnerUser();
    ctr.getTierOptions();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }

  @isTest
  static void testPepperAPI() {
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
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    Test_DataGeneratorHelper.quoting.Name = 'Pepper Commercial';
    Test_DataGeneratorHelper.quoting.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
    Test_DataGeneratorHelper.quote.Financier_Name__c = 'Pepper Commercial';
    update Test_DataGeneratorHelper.quote;
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.PepperComm;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PepperCommExtension ctr = new PepperCommExtension(sc);
    ctr.productGoodsType = 'Other-Primary Assets';
    ctr.baseRateCalc();
    ctr.reset();

    //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.productGoodsType = 'Other-Primary Assets';
    ctr.carPrice = 25000.00;
    ctr.vehicleAge = ctr.getAssetAgeOptions().get(1).getValue();
    ctr.baseRateCalc();
    ctr.clientRate = ctr.maxRate;
    ctr.submitRequest = false;
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);
    ctr.productGoodsType = 'Other-Secondary & Tertiary Assets';
    ctr.baseRateCalc();
    ctr.sendApplication();
    ctr.calculate();
    MultiRequestMock requestMocks = new MultiRequestMock();

    SingleRequestMock fakeRes = getQuickMockRequest(
      '{"application": {"applicationNo": "P-20190503004400"},"requestId": "d21f9a70-48e4-11e8-bf5f-024abd6c08ae"}',
      200
    );
    requestMocks.addRequestMock(
      endPointApplication + '/applications/commercial',
      fakeRes
    );
    fakeRes = getQuickMockRequest(
      '{"applicationId": "AD-1002502","responseMessage": "Document uploaded successfully","requestId": "aba58620-11fa-11eb-b1fa-025fad8dc2b8"}',
      200
    );
    requestMocks.addRequestMock(
      endPointApplication + '/applications/supportingDocuments',
      fakeRes
    );
    Test.setMock(HttpCalloutMock.class, requestMocks);

    Cloud_Documents__c doc = new Cloud_Documents__c();
    doc.Document_Type__c = 'Drivers License (Front & Back)';
    doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
    doc.Send_To_Lender__c = true;
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

  @isTest
  static void testPepperAPI2() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    Test_DataGeneratorHelper.quoting.Name = 'Pepper Commercial';
    Test_DataGeneratorHelper.quoting.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.asset.Condition__c = 'used';
    Test_DataGeneratorHelper.asset.Year__c = 2007;
    update Test_DataGeneratorHelper.asset;
    Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = Test_DataGeneratorHelper.asset.Id;
    update Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.PepperComm;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PepperCommExtension ctr = new PepperCommExtension(sc);

    ctr.reset();

    //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 25000.00;
    ctr.vehicleAge = 'New';
    ctr.calculate();
    ctr.clientRate = ctr.baseRate;
    MultiRequestMock requestMocks = new MultiRequestMock();

    SingleRequestMock fakeRes = getQuickMockRequest(
      '{"errorCode": "INVALID_APPLICATION","errorMessage": "Error validating JSON. Error: - Missing required field \'product\'","requestId": "12975b60-48e5-11e8-bf5f-024abd6c08ae"}',
      400
    );
    requestMocks.addRequestMock(
      endPointApplication + '/applications/commercial',
      fakeRes
    );
    fakeRes = getQuickMockRequest(
      '{"errorCode": "INVALID_APPLICATION","errorMessage": "Error validating JSON. Error: - Missing required field \'product\'","requestId": "12975b60-48e5-11e8-bf5f-024abd6c08ae"}',
      400
    );
    requestMocks.addRequestMock(
      endPointApplication + '/applications/supportingDocuments',
      fakeRes
    );
    Test.setMock(HttpCalloutMock.class, requestMocks);

    Cloud_Documents__c doc = new Cloud_Documents__c();
    doc.Document_Type__c = 'Drivers License (Front & Back)';
    doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
    doc.Send_To_Lender__c = true;
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

  private static SingleRequestMock getQuickMockRequest(
    String body,
    Integer code
  ) {
    SingleRequestMock r = new SingleRequestMock(code, 'Complete', body, null);
    return r;
  }
}