@isTest(SeeAllData=true)
private class TestGreenLightCalc {
  @isTest
  static void testBudgetVehicleLendersFees() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.GreenLightCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    GreenLightCalculatorExtension ctr = new GreenLightCalculatorExtension(sc);

    ctr.clientTierAux = 'Budget Vehicle';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 50000.00;
    ctr.deposit = 300.00;
    ctr.tradeIn = 600.00;
    ctr.payoutOn = 2000.00;
    ctr.lvrSel = ctr.getLVROptions().get(1).getValue();

    ctr.calculateBadgedVehicleLendersFees();
    ctr.calcFees();
    ctr.getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_PROTECTED);
    ctr.getBaseAmountPmtInclBrokerageCalc(null);
    ctr.getBaseAmountPmtCalc(null);
    ctr.getIsBrokerPartnerUser();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
    ctr.getMaxAppFeeVal();
    ctr.getMaxAppFeeVal();
    ctr.clientTier();
  }

  @isTest
  static void testCalculator() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.GreenLightCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    GreenLightCalculatorExtension ctr = new GreenLightCalculatorExtension(sc);

    ctr.calculate();
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 50000.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.clientRate = 23.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.lvrSel = ctr.getLVROptions().get(1).getValue();

    // test for baseRateCalc() and calculateValidation()
    ctr.carPrice = 20000.00;
    ctr.brokeragePercentage = 3;
    ctr.term = 60;
    ctr.clientTier = 'Bronze';
    ctr.baseRate = 19.58;
    ctr.calculate();

    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.calculate();
    ctr.clientRate = 1.00;
    ctr.calculate();
    ctr.saveQuoting();

    // Insurance
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.calculate();
    ctr.saveQuoting();
    ctr.saveAmendment();

    ctr.declineQuoteMV();
    ctr.declineQuoteGAP();
    ctr.declineQuoteCCI();
    ctr.declineQuoteWRR();
    ctr.declineQuoteNWC();
    ctr.getPresentationUrlCode();
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
    ctr = new GreenLightCalculatorExtension(sc);

    ctr.getYears();
    ctr.getInsuranceFailureReasons();
    ctr.getCustomerPresentationStatusStyle();

    ctr.getSelectTierOptions();

    ctr = new GreenLightCalculatorExtension(sc);

    // Calculator PDF
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('lender', 'GREEN LIGHT CALCULATION');
    Test.setCurrentPageReference(calcPdf);
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    calcPdfCon.getIsMetro();
    test.stopTest();
  }

  @isTest
  static void testCalculator2() {
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.GreenLightCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
    Test_DataGeneratorHelper.quote.Financier_Name__c = 'Green Light';
    update Test_DataGeneratorHelper.quote;
    GreenLightCalculatorExtension ctr = new GreenLightCalculatorExtension(sc);
    ctr.saveQuoting();
  }

  @isTest
  static void testInsuranceProductSelected() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.GreenLightCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    GreenLightCalculatorExtension ctr = new GreenLightCalculatorExtension(sc);

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 25000.00;
    ctr.deposit = 0.00;
    ctr.ppsr = 50.00;
    ctr.residualValue = 0.00;
    ctr.brokeragePercentage = 3;
    ctr.term = 60;
    ctr.clientTier = 'Platinum';
    ctr.lvrSel = ctr.getLVROptions().get(1).getValue();
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

    ctr.assetType = 'Motorcycle';

    ctr.calculate();
  }
}