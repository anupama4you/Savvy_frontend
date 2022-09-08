@isTest(SeeAllData=true)
private class TestLatitudeCalc {
  @isTest
  static void testCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_1__c = 'Yes';
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_2__c = 'Yes';
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.LatitudeCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LatitudeCalculatorExtension ctr = new LatitudeCalculatorExtension(sc);

    ctr.calculate();
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.carPrice = 50000.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.registrationFee = 3.4;
    ctr.clientRate = 6.00;

    ctr.term = 60;
    ctr.calculate();

    ctr.reset();
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.loanTypeDetail = 'Diamond Plus';
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.dofCalculate();
    ctr.dof = ctr.maxDof;
    ctr.vehCon = 'NEW';
    ctr.calculate();
    System.assert(
      ctr.rental > 0,
      'Rental not calculated [' +
      ctr.clientRate +
      '|' +
      ctr.baseRate +
      '|' +
      ctr.maxRate +
      '|' +
      ctr.applicationFee +
      '|' +
      ctr.dof +
      '|' +
      ctr.ppsr +
      '|' +
      ctr.term +
      '|' +
      ctr.carAge +
      '|' +
      ctr.vehicleType +
      '|' +
      ctr.residualValue +
      ']'
    );

    ctr.loanTypeDetail = 'Diamond';
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    ctr.loanTypeDetail = 'Shapphire';
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    ctr.loanTypeDetail = 'Ruby';
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    ctr.loanTypeDetail = 'Emerald';
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();

    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.calculate();

    // Insurance
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.acceptQuoteMV();
    ctr.acceptQuoteGAP();
    ctr.acceptQuoteCCI();
    ctr.acceptQuoteWRR();
    ctr.acceptQuoteNWC();

    LatitudeCalculatorExtension.getSelectLoanTypeOptions();
    ctr.getIsFixedRate();

    LatitudeCalculatorExtension.TRow x = new LatitudeCalculatorExtension.TRow();
    x.rate4 = 0.00;
    x.comm4 = 0.00;
    x.getVarRate1();
    x.getVarRate2();
    x.getVarRate3();
    x.getVarRate4();

  }

  @isTest
  static void testCalculatorP2() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_1__c = 'Yes';
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_2__c = 'Yes';
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.LatitudeCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LatitudeCalculatorExtension ctr = new LatitudeCalculatorExtension(sc);

    ctr.reset();

    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.loanTypeDetail = 'Diamond Plus';
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.dofCalculate();
    ctr.dof = ctr.maxDof;
    ctr.vehCon = 'NEW';
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);

    ctr.acceptQuoteNWC();
    ctr.nationalWarrantyCalc();

    ctr.mvAcceptance = 'D';
    ctr.declineQuoteMV();

    ctr.gapAcceptance = 'D';
    ctr.declineQuoteGAP();

    ctr.cciAcceptance = 'D';
    ctr.declineQuoteCCI();

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.getLenderQuoting();

    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    LatitudeCalculatorDTO.getSelectLoanTypeOptions();

    LatitudeCalculatorExtension.TRow r = new LatitudeCalculatorExtension.TRow();
    r.rate1 = 0.0;
    r.comm1 = 0.0;
    r.rate2 = 0.0;
    r.comm2 = 0.0;
    r.rate3 = 0.0;
    r.comm3 = 0.0;

    ctr.getDiamondPlusRates();
    ctr.getDiamondRates();
    ctr.getSapphireRates();
    ctr.getRubyRates();
    ctr.getEmeraldRates();

    // Calculator PDF
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('lender', 'LATITUDE CALCULATION');
    Test.setCurrentPageReference(calcPdf);
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    calcPdfCon.getIsLatitude();

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    Test_DataGeneratorHelper.quoting.Name = 'Latitude';
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
    Test_DataGeneratorHelper.quote.Financier_Name__c = 'Latitude';
    update Test_DataGeneratorHelper.quote;
    ctr = new LatitudeCalculatorExtension(sc);
    test.stopTest();
  }

  @isTest
  static void testInsuranceProductSelected() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_1__c = 'Yes';
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_2__c = 'Yes';
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.createQuoting();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LatitudeCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LatitudeCalculatorExtension ctr = new LatitudeCalculatorExtension(sc);

    ctr.reset();
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.loanTypeDetail = 'Diamond Plus';
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.dofCalculate();
    ctr.dof = ctr.maxDof;
    ctr.vehCon = 'NEW';
    ctr.calculate();
    System.debug('rental: ' + ctr.rental + ' >> ' + ctr.category);
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

    ctr.calculate();
    System.debug('rental: ' + ctr.rental + ' >> ' + ctr.category);
    System.assert(
      ctr.rental > 0,
      'Invalid rental - accepting insurance products'
    );

    ctr.saveAmendment();
    ctr.getPresentationUrlCode();
    ctr.getCustomerPresentationStatusStyle();
    ctr.getInsuranceFailureReasons();
  }

  @isTest
  static void testAcceptingInsuranceProduct() {
    test.startTest();

    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_1__c = 'Yes';
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_2__c = 'Yes';
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.createQuoting();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LatitudeCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LatitudeCalculatorExtension ctr = new LatitudeCalculatorExtension(sc);

    ctr.reset();
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.loanTypeDetail = 'Diamond Plus';
    ctr.vehicleType = ctr.getVehicleTypes().get(1).getValue();
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.baseRateCacl();
    ctr.clientRate = ctr.maxRate;
    ctr.dofCalculate();
    ctr.dof = ctr.maxDof;
    ctr.vehCon = 'NEW';
    ctr.calculate();
    System.debug('rental: ' + ctr.rental + ' >> ' + ctr.category);
    System.assert(ctr.rental > 0);

    // Motor Vehicle
    ctr.mvLevel = 'MV';
    ctr.mv = 1500;
    ctr.mvIncome = 500;

    // GAP
    ctr.gapLevel = 'GAP';
    ctr.gap = 1300;
    ctr.gapIncome = 1300;

    // Warranty
    ctr.warrantyLevel = 'WRR';
    ctr.warranty = 1100;
    ctr.warrantyIncome = 100;

    ctr.calculate();
    System.debug('rental: ' + ctr.rental + ' >> ' + ctr.category);
    System.assert(
      ctr.rental > 0,
      'Invalid rental - accepting insurance products'
    );

    ctr.saveAmendment();

    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_1__c = 'Yes';
    Test_DataGeneratorHelper.tstApp.Do_you_have_drivers_licence_2__c = 'Yes';
    update Test_DataGeneratorHelper.tstApp;
    sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    LenderAPIResponse__c l = new LenderAPIResponse__c();
    l.Application_ID__c = '1';
    l.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
    insert l;
    ctr = new LatitudeCalculatorExtension(sc);
    ctr.save();
    ctr.sendApplication();
    ctr.vehicleType = ctr.getVehicleTypes().get(6).getValue();
    ctr.baseRateCacl();
    ctr.submitRequest = false;
    ctr.rental = 0;
    ctr.sendApplication();

    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }
}