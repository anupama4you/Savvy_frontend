@isTest(SeeAllData=true)
private class TestAFSCalc {
  static AfsCalculatorExtension headConsumerCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.AfsCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    //calcRef.getParameters().put('preloadQuting','1');

    Test.setCurrentPageReference(calcRef);
    AfsCalculatorExtension ctr = new AfsCalculatorExtension(sc);

    ApexPages.currentPage().getParameters().put('LENDER_QUOTING', 'YTD');

    ctr.calculate();
    ctr.assetType = null;
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.assetType = 'Car';
    ctr.productLoanType = 'Consumer Loan';
    ctr.assetCondition = 'New/Demo';
    ctr.carPrice = 50000.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.registrationFee = 3.4;
    ctr.clientRate = 5.00;

    // test for baseRateCalc() and calculateValidation()
    ctr.assetType = 'Car';
    ctr.assetCondition = 'Used';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.residency = 'Renting';
    ctr.carAge = ctr.getAssetAgeOptions().get(2).getValue();
    ctr.lvr = 100;
    ctr.bankrupt = 'N';
    ctr.payDayEnquiries = 'Over 6 months ago';
    ctr.hasImports = 'N';
    ctr.odometer = '<200,000';
    ctr.privateSales = 'N';
    ctr.casual = 'N';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate;
    ctr.calculate();
    System.assert(ctr.rental > 0, 'Rental not calculated!');
    ctr.savePreApproval();

    ctr.assetType = 'Car';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 72;
    ctr.residency = 'Renting';
    ctr.bankrupt = 'N';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();
    System.assert(ctr.rental > 0, 'Rental not calculated!');

    ctr.getLoanProductOptions();
    ctr.getIsBrokerPartnerUser();

    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
    // ctr.getCommissionRate();
    ctr.assetType = 'Bikes / Scooters';
    ctr.isValidationOk();
    return ctr;
  }

  @isTest
  static void saveConsumerCalculator() {
    AfsCalculatorExtension ctr = headConsumerCalculator();
    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.calculate();

    // Insurance
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    // Other methods
    ctr.getAssetTypeFromApplication();
    ctr.Opp.Application__r.Type_of_Asset__c = 'Boat';
    ctr.getAssetTypeFromApplication();

    ctr.resetCarAge();
    ctr.getOdometerOptions();
    ctr.assetType = 'Car';
    ctr.assetCondition = 'New/Demo';
    ctr.residency = 'Property Owner';
    ctr.getAssetAgeOptions();
    ctr.assetCondition = 'Used';
    ctr.getAssetAgeOptions();
    ctr.residency = 'Non-Property Owner';
    ctr.getAssetAgeOptions();
    ctr.productLoanType = 'Consumer Loan';
    // ctr.carAge = '0-3 years';
    ctr.carAge = ctr.getAssetAgeOptions().get(2).getValue();
    ctr.casual = 'N';
    ctr.bankrupt = 'N';
    ctr.hasImports = 'N';
    ctr.odometer = '<200,000';
    ctr.carPrice = 1;
    ctr.applicationFee = 1;
    ctr.dof = 1;
    ctr.clientRate = 14;
    ctr.term = 12;
    ctr.saveFormalApproval();
  }

  @isTest
  static void testConsummerCalculation() {
    AfsCalculatorExtension ctr = headConsumerCalculator();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr = new AfsCalculatorExtension(sc);

    ctr.assetType = 'Car';
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
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018

    ctr.nationalWarrantyCalc();
  }

  @isTest
  static void testConsumerCalculator() {
    AfsCalculatorExtension ctr = headConsumerCalculator();

    ctr.getPresentationUrlCode();
    ctr.getInsuranceFailureReasons();
    ctr.getCustomerPresentationStatusStyle();

    ctr.getLenderQuoting();
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.calculateNWC();
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018
  }

  @isTest
  static void fullRates() {
    AfsCalculatorExtension ctr = headConsumerCalculator();
    ctr.getFullRatesPropertyOwners();
    ctr.getFullRatesRenting();
    ctr.getFullRatesOthers();
  }

  static AfsCommercialCalculatorExtension headCommercialCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.AfsCommercialCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    AfsCommercialCalculatorExtension ctr = new AfsCommercialCalculatorExtension(
      sc
    );

    ctr.calculate();
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.clientRate = null;
    ctr.residency = null;
    ctr.calculate();
    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 50000.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.registrationFee = 3.4;
    ctr.clientRate = 8;
    ctr.residency = 'Property Owner';

    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;

    ctr.mvLevel = 'AIC/Eric';
    ctr.mv = 500.00;
    ctr.mvIncome = 250.00;
    ctr.cci = 600.00;
    ctr.cciIncome = 300.00;
    ctr.nwc = 700.00;
    ctr.nwcIncome = 350.00;

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
    //NWCCalculator HJ - F - 12-07-2018

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
    //NWCCalculator HJ - F - 12-07-2018

    // test for baseRateCalc() and calculateValidation()
    ctr.carPrice = 60000.00;
    ctr.term = 60;
    //ctr.productLoanType = '0-7 years';
    ctr.clientRate = 8;
    ctr.paymentType = 'Advance';
    ctr.calculate();
    ctr.carPrice = 100000.00;
    ctr.residency = 'Home Buyer';
	  ctr.isValidationOk();
	  ctr.residency = 'Non-Home Buyer';
	  ctr.isValidationOk();
	  ctr.quoting.GST__c = 'Not Registered';
	  ctr.isValidationOk();
    return ctr;
  }

  @isTest
  static void declineQuoteCommercialCalculator() {
    AfsCommercialCalculatorExtension ctr = headCommercialCalculator();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr = new AfsCommercialCalculatorExtension(sc);

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

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteWRR();
  }

  @isTest
  static void testCommercialCalculator() {
    AfsCommercialCalculatorExtension ctr = headCommercialCalculator();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    ctr.getPresentationUrlCode();
    ctr.getInsuranceFailureReasons();
    ctr.getCustomerPresentationStatusStyle();

    ctr.getLenderQuoting();
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }

  @isTest
  static void testConsumerInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.AfsCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    AfsCalculatorExtension ctr = new AfsCalculatorExtension(sc);

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.assetType = 'Car';
    ctr.assetCondition = 'Used';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    // ctr.clientTier = 'Gold Club';
    // ctr.riskGrade = 'GC-3';
    ctr.residency = 'Renting';
    ctr.carAge = ctr.getAssetAgeOptions().get(2).getValue();
    System.debug('@@ctr.carAge: ' + ctr.carAge);
    ctr.lvr = 100;
    ctr.bankrupt = 'N';
    ctr.payDayEnquiries = 'Over 6 months ago';
    ctr.hasImports = 'N';
    ctr.odometer = '<200,000';
    ctr.privateSales = 'N';
    ctr.casual = 'N';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate;
    ctr.calculate();
    System.assert(ctr.rental > 0, 'Rental not calculated!');
    ctr.saveQuoting();

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
  static void testCommercialInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.AfsCommercialCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    AfsCommercialCalculatorExtension ctr = new AfsCommercialCalculatorExtension(
      sc
    );

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 60000.00;
    ctr.term = 60;
    ctr.clientRate = 10;
    ctr.residency = 'Property Owner';
    ctr.quoting.GST__c = 'Registered';
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);
    ctr.saveQuoting();
    ctr.saveAmendment();

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
    ctr.saveFormalApproval();

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
    ctr.saveFormalApproval();

    ctr.getIsBrokerPartnerUser();
    ctr.getSelectCarAgeOptions();
  }
}