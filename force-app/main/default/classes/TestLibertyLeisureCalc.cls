@isTest(SeeAllData=true)
private class TestLibertyLeisureCalc {
  
  @isTest
  static void testInsuranceProdGeneralMethods() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LibertyLeisure;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);

    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Caravan';
    ctr.carPrice = 30000.00;
    ctr.deposit = 150.00;
    ctr.residualValue = 0.00;
    ctr.term = 60;
    ctr.ltv = 100;
    ctr.creditScore = '600';
    ctr.enquiries = '0';
    ctr.paymentType = 'Arrears';
    ctr.propertyOwner = 'Y';
    ctr.vehicleAge = 'New';
    System.debug('Testing testInsuranceProductSelected....');
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();

    System.debug(
      'rental: ' +
      ctr.rental +
      '|clientRate: ' +
      ctr.clientRate +
      '|baseRate: ' +
      ctr.baseRate
    );
    System.assert(ctr.rental > 0);

    // no insurance products means TRUE
    System.assert(ctr.insuranceProductSelected());
    
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

    ctr.getIsBrokerPartnerUser();

    // isValidationOK - method
    ctr.reset();
    ctr.clientTier = null;
    // 1 - run
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.carPrice = 0.00;
    ctr.applicationFee = null;
    ctr.term = 0;
    ctr.vehicleAge = null;
    ctr.ltv = null;
    ctr.calculate();
    // 2 - run
    ctr.baseRate = 10;
    ctr.clientRate = ctr.baseRate - 1;
    ctr.creditScore = 'XXXX';
    ctr.enquiries = 'XXXX';
    ctr.term = 90;
    ctr.ltv = 180;
    ctr.calculate();
    // 3 - run
    ctr.clientTier = 'AAA';
    ctr.productLoanType = 'Consumer Loan';
    ctr.creditScore = null;
    ctr.enquiries = null;
    ctr.propertyOwner = 'N';
    ctr.calculate();
    // 3 - run
    ctr.creditScore = 'XXXX';
    ctr.enquiries = 'XXXX';
    ctr.calculate();
    // 5 - run
    ctr.clientTier = 'A+';
    ctr.residualValue = 2000;
    ctr.calculate();    
  }

  @isTest
  static void testSendPresentation() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createAssetDetailLTV();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LibertyLeisure;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);

    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);

    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 30000.00;
    ctr.creditScore = '600';
    ctr.enquiries = '0';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();
  }

  @isTest
  static void testInsuranceProdOptions() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.reloadOpportunity();

    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Liberty Drive
    PageReference pref= Page.LibertyLeisure;
    pref.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(pref);
    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);

    ctr = new LibertyLeisureExt(sc);

    ctr.mvAcceptance = 'A';
    ctr.acceptQuoteMV();
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

    ctr.warrantyAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteNWC();

    ctr.nwc = 100;

    ctr.getLPIOptions();
  }

  @isTest
  static void testLibertyServiceManagerAPI() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LibertyLeisure;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);
    ctr.libertyApplicationTest();
    ctr.libertyApplication();
  }

  @isTest
  static void testPreApproval() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.createQuote();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LibertyLeisure;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcRef.getParameters().put('preloadQuting', '1');
    Test.setCurrentPageReference(calcRef);
    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);

    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 30000.00;
    ctr.deposit = 150.00;
    ctr.residualValue = 0.00;
    ctr.term = 12;
    ctr.ltv = 100;
    ctr.creditScore = '600';
    ctr.enquiries = '0';
    ctr.paymentType = 'Arrears';
    ctr.propertyOwner = 'Y';
    
    ctr.vehicleAge = 'New';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();
    System.debug(
      'rental: ' +
      ctr.rental +
      '|clientRate: ' +
      ctr.clientRate +
      '|baseRate: ' +
      ctr.baseRate
    );
    System.assert(ctr.rental > 0);

    Application_Asset_Detail__c aad = Test_DataGeneratorHelper.asset;
    aad.Year__c = 2016;
    aad.Condition__c = 'new';
    update aad;
    ctr.maxRate = ctr.clientRate - 2;
    ctr.baseRate = 7;
    ctr.clientRate = 15;
    ctr.applicationFee = 1495;
    ctr.term = 12;
    ctr.clientTier = 'AAA';
    ctr.netDeposit = 3000;
    ctr.residualValue = 6600;
    ctr.realtimeNaf = 5000;
    ctr.rateType = 'Star';
    ctr.maxRate = ctr.clientRate + 15;

    Test_DataGeneratorHelper.quote.MV_Acceptance__c = 'A';

    Test.startTest();
    ctr.savePreApproval();
    ctr.getCustomerPresentationStatusStyle();
    ctr.getRates();
    ctr.saveQuoting();
    Test.stopTest();
  }

  @isTest
  static void testFormalApproval() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    Application__c app = Test_DataGeneratorHelper.tstApp;

    Test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.LibertyLeisure;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LibertyLeisureExt ctr = new LibertyLeisureExt(sc);

    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Caravan';
    ctr.carPrice = 30000.00;
    ctr.deposit = 150.00;
    ctr.residualValue = 0.00;
    ctr.term = 60;
    ctr.ltv = 100;
    ctr.creditScore = '600';
    ctr.enquiries = '0';
    ctr.paymentType = 'Arrears';
    ctr.propertyOwner = 'Y';
    
    ctr.vehicleAge = 'New';
    System.debug('Testing testDriveInsuranceProductSelected....');
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();

    System.debug(
      'rental: ' +
      ctr.rental +
      '|clientRate: ' +
      ctr.clientRate +
      '|baseRate: ' +
      ctr.baseRate
    );
    System.assert(ctr.rental > 0);

    ctr.saveAmendment();

    // no insurance products means TRUE
    System.assert(ctr.insuranceProductSelected());

    // Preare record for validations
    ctr.quoting.Application__c = app.Id;
    ctr.quoting.Presentation_Email_Date__c = Datetime.now();
    ctr.quoting.Insurance_Customer_Choice__c = 'PF';
    ctr.quoting.Presentation_Email_Date__c = Datetime.now();
    ctr.quoting.Insurance_Choice_Date__c = Datetime.now();
    ctr.quote.Customer_Choice__c = 'PF';
    ctr.quote.Customer_Choice_Status__c = 'FINI';

    // Warranty
    ctr.warrantyAcceptance = 'A';
    ctr.warrantyLevel = 'My Warranty';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100;

    // Motor Vehicle
    ctr.mvAcceptance = 'A';
    ctr.mvLevel = 'MV';
    ctr.mv = 1000;
    ctr.mvIncome = 100;

    ctr.nwcAcceptance = 'A';
    ctr.nwc = 1000;
    ctr.nwcIncome = 100;

    ctr.saveFormalApproval();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }

}