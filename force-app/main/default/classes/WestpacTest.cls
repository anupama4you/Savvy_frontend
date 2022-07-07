@isTest(SeeAllData=true)
private class WestpacTest {
  @isTest
  static void testCalculatorA() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Macquarie Commercial Calculator
    PageReference Westpac = Page.Westpac;
    Westpac.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(Westpac);
    WestpacExtension ctr = new WestpacExtension(sc);

    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.residualValue = 10000.00;
    ctr.clientRate = 15.00;
    ctr.term = 72;
    // ctr.validate();
    ctr.clientRate = 7.00;
    ctr.term = 60;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;

    // test for baseRateCalc ()
    ctr.reset();
    ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
    ctr.carPrice = 25000.00;
    ctr.privateSales = 'N';
    ctr.term = 60;
    ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
    ctr.brokeragePercentage = 4;
    ctr.residualValue = 1;
    ctr.baseRate = 1;
    ctr.baseRateCalc();
    ctr.calculate();
    System.assert(ctr.rental > 0);
    ctr.saveQuoting();
    ctr.realtimeNafCalc();
    ctr.calculate();
    ctr.savePreApproval();

    // - Insurance Quote Test
    // ctr.saveAmendment();
    ctr.saveFormalApproval();
    ctr.getLenderQuoting();
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.calculateNWC();
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr.term = null;
    ctr.residualValue = -1;
    ctr.isValidCalculate();
  }

  @isTest
  static void testCalculatorB() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Macquarie Commercial Calculator
    PageReference Westpac = Page.Westpac;
    Westpac.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(Westpac);
    WestpacExtension ctr = new WestpacExtension(sc);

    ctr = new WestpacExtension(sc);
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Car';

    ctr.mvAcceptance = 'A';
    ctr.acceptQuoteMV();
    ctr.gapAcceptance = 'A';
    ctr.acceptQuoteGAP();
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

    ctr.warrantyAcceptance = 'D';
    //ctr.declineQuoteLTI();

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.changeLoanProduct();

    ctr.getOptions();

    ctr.getIsBrokerPartnerUser();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }

  @isTest
  static void testInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.Westpac;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    WestpacExtension ctr = new WestpacExtension(sc);

    ctr.reset();
    ctr.productGoodsType = ctr.productGoodsTypes.get(1).getValue();
    ctr.carPrice = 25000.00;
    ctr.privateSales = 'N';
    ctr.term = 60;
    ctr.manufactureYear = ctr.manufactureYearOptions.get(1).getValue();
    ctr.brokeragePercentage = 2;
    ctr.baseRate = 1;
    ctr.baseRateCalc();
    ctr.calculate();
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
    ctr.saveAmendment();
    ctr.residualValue = 0;
    ctr.term = 1;
    ctr.isValidCalculate();
    ctr.residualValue = 1;
    ctr.productLoanType = 'Novated Lease';
    ctr.applicationFee = 500;
    ctr.isValidCalculate();
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
    lender.loanFrequency = 'Monthly';
    lender.vehicleYear = '2017';
    lender.privateSales = 'No';
    lender.customerProfile = 'No';
    lender.brokerageBase = 2;
    lender.info = new Lenders__c();
    lender.info.Code__c = 'WEST';
    lender.ltv = '2';
    Test_DataGeneratorHelper.tstOpportunity.Pre_Quoting_Object__c = JSON.serialize(
      lender
    );
    update Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.Westpac;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcRef.getParameters().put('preloadQuting', '1');
    Test.setCurrentPageReference(calcRef);
    WestpacExtension ctr = new WestpacExtension(sc);

    //ctr.acceptQuoteTAS();
    ctr.warrantyAcceptance = 'A';
    ctr.nwcAcceptance = 'A';
    ctr.cciAcceptance = 'A';
    ctr.isAssetBoat = true;
    ctr.tradeIn = 2;
    ctr.payoutOn = 2;
    ctr.savePreApproval();
  }
}