@isTest(SeeAllData=true)
private class TestMacquarieConsumerCalc {
  @isTest
  static void testCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Macquarie Consumer Calculator
    PageReference MacquarieConsumer = Page.MacquarieConsumer;
    MacquarieConsumer.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(MacquarieConsumer);
    MacquarieConsumerExtension ctr = new MacquarieConsumerExtension(sc);
    ctr.reset();
    ctr = new MacquarieConsumerExtension(sc);
    fillQuoteController(ctr);
    ctr.baseRateCalc();

    // ctr.term = 60;
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);

    ctr.clientRateValidate();
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

    // test for baseRateCalc ()
    ctr.brokeragePercentage = 4;
    ctr.term = 0;
    ctr.baseRateCalc();
    ctr.brokeragePercentage = 5;
    ctr.term = 24;
    ctr.baseRateCalc();
    ctr.brokeragePercentage = 6;
    ctr.carPrice = -1000.00;
    ctr.baseRateCalc();
    ctr.brokeragePercentage = 7;
    ctr.carPrice = 60000.00;
    ctr.baseRateCalc();
    ctr.brokeragePercentage = 8;
    ctr.carPrice = 250000.00;
    ctr.baseRateCalc();
    ctr.term = 72;
    ctr.carPrice = 50000.00;
    ctr.baseRateCalc();
    ctr.carPrice = -1000.00;
    ctr.baseRateCalc();
    ctr.carPrice = 60000.00;
    ctr.baseRateCalc();
    ctr.carPrice = 250000.00;
    ctr.baseRateCalc();
    ctr.term = 60;
    ctr.carPrice = -1000.00;
    ctr.baseRateCalc();
    ctr.carPrice = 60000.00;
    ctr.baseRateCalc();
    ctr.carPrice = 250000.00;
    ctr.baseRateCalc();

    ctr.carPrice = 50000.00;
    ctr.motorCycles = 'Y';
    ctr.caravanCampervans = 'Y';
    ctr.privateSales = 'Y';
    ctr.baseRateCalc();
    ctr.motorCycles = 'N';
    ctr.privateSales = 'N';
    ctr.caravanCampervans = 'N';
    ctr.baseRateCalc();
    ctr.realtimeNafCalc();
    ctr.calculate();
    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.validation();

    // ctr.reset();
    // fillQuoteController(ctr);
    // ctr.baseRateCalc();
    ctr.calculate();
    // System.assert(ctr.rental > 0);

    ctr.saveQuoting();

    // - Insurance Quote Test
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    ctr.privateSales = 'Y';
    ctr.applicationFeefCalc();
    ctr.privateSales = 'N';
    ctr.applicationFeefCalc();

    ctr.getCustomerPresentationStatusStyle();
    ctr.changeLoanProduct();
    ctr.changeGoodsType();
    ctr.getOptions();
    ctr.macquarieQuote();
    ctr.getRateList();
    ctr.getLenderQuoting();
    ctr.getIsBrokerPartnerUser();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    //ctr = new PepperCalculatorMVExtension(sc);
    ctr = new MacquarieConsumerExtension(sc);
  }

  @isTest
  static void testInsuranceProductSelected() {
    System.debug('testInsuranceProductSelected...');
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.MacquarieConsumer;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    MacquarieConsumerExtension ctr = new MacquarieConsumerExtension(sc);

    ctr.reset();
    fillQuoteController(ctr);
    ctr.baseRateCalc();
    ctr.estimateBrokerage();
    ctr.calculate();
    //System.debug('rental: ' + ctr.rental + '|' + ctr.clientRate + '|' + ctr.baseRate + '|' + ctr.brokeragePercentage + '|' + ctr.manufactureYear);
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
  }

  @isTest
  static void testFullProductSelected() {
    test.startTest();
    System.debug('tesFullProductSelected...');
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.MacquarieConsumer;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    MacquarieConsumerExtension ctr = new MacquarieConsumerExtension(sc);

    ctr.reset();
    fillQuoteController(ctr);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);

    ctr.mvLevel = 'MV';
    ctr.mv = 1000;
    ctr.mvIncome = 100;
    ctr.mvAcceptance = 'A';

    ctr.gapLevel = 'GAP';
    ctr.gap = 1000;
    ctr.gapIncome = 100;
    ctr.gapAcceptance = 'A';

    ctr.warrantyLevel = 'warranty';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100;
    ctr.warrantyAcceptance = 'A';

    ctr.savePreApproval();

    ctr = new MacquarieConsumerExtension(sc);

    ctr.reset();
    fillQuoteController(ctr);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);
    // ctr.carPrice = 25000.00;
    // ctr.motorCycles = 'N';
    // ctr.caravanCampervans ='N';
    // ctr.privateSales = 'N';
    // ctr.baseRateCalc();

    ctr.gapLevel = null;
    ctr.gap = null;
    ctr.gapIncome = null;
    ctr.gapAcceptance = null;

    ctr.warrantyLevel = null;
    ctr.warranty = null;
    ctr.warrantyIncome = null;
    ctr.warrantyAcceptance = null;

    ctr.cciLevel = 'CCI';
    ctr.cci = 1000;
    ctr.cciIncome = 100;
    ctr.cciAcceptance = 'A';

    ctr.nwc = 1000;
    ctr.nwcIncome = 100;
    ctr.nwcAcceptance = 'A';
    ctr.isAssetCar = true;

    ctr.savePreApproval();
  }

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
    lender.productGoodsType = 'Motor Vehicle';
    lender.productGoodsSubType = 'Cars';
    lender.loanFrequency = 'Monthly';
    lender.vehicleYear = '2017';
    lender.privateSales = 'No';
    lender.customerProfile = 'No';
    lender.brokerageBase = 2;
    lender.dofBase = 2;
    lender.info = new Lenders__c();
    lender.info.Code__c = 'MCON';
    lender.ltv = '2';
    Test_DataGeneratorHelper.tstOpportunity.Pre_Quoting_Object__c = JSON.serialize(
      lender
    );
    update Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.MacquarieConsumer;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcRef.getParameters().put('preloadQuting', '1');
    Test.setCurrentPageReference(calcRef);
    MacquarieConsumerExtension ctr = new MacquarieConsumerExtension(sc);
  }

  private static void fillQuoteController(MacquarieConsumerExtension ctr) {
    ctr.productGoodsType = 'MOTOV';
    ctr.assetYearOption();
    ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
    ctr.carPrice = 25000.00;
    ctr.motorCycles = 'N';
    ctr.caravanCampervans = 'N';
    ctr.privateSales = 'N';
    ctr.baseRateCalc();
    ctr.term = 60;
  }
}