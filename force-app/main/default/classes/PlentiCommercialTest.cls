@isTest(SeeAllData=true)
public class PlentiCommercialTest {

  @isTest
  static void testCarLoanCalc1() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.reloadOpportunity();
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

    ctr.calculate();
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.loanTypeDetail = null;
    ctr.calculate();
    ctr.getMaxAppFee();
    ctr.privateSales = 'N';
    ctr.getMaxAppFee();
    ctr.reset();

    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.customerProfile = ctr.getProfileOptions().get(1).getValue();
    ctr.clientTier = ctr.getTierOptions().get(1).getValue();
    ctr.assetCondition = 'new';
    ctr.vehicleYear = ctr.getBuildDatedOptions().get(1).getValue();
    ctr.applicationFee = 300;
    ctr.dof = 300;
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;

    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;

    ctr.warrantyLevel = 'Platinum - 24 months';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100;

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
    ctr.nwcParam.isManuallyNWCPrice = false;
    //ctr.nwcParam.nwcPriceToCustomer = 14000;
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcPlan = 'A';
    ctr.nwcTerm = '12';
    ctr.nwcParam.state = 'SA';
    //NWCCalculator HJ - F - 12-07-2018

    // test for baseRateCalc() and calculateValidation()
    ctr.greenCar = 'N';
    ctr.brokeragePercentage = 1;
    ctr.calculate();
    // System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);
    ctr.saveQuoting();
    ctr.manualRate = 2;
    ctr.savePreApproval();

    // Insurance
    ctr.saveAmendment();
    //ctr.saveFormalApproval();

    ctr.calculate();
    ctr.saveQuoting();
    ctr.saveAmendment();
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
    ctr.getAssetTypeOptions();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
    ctr.customerProfile = 'Non Property Owner';
    ctr.abn = '> 1 yr / Unreg > 1 yr';
    ctr.realtimeNaf = 50000;
    ctr.clientTier = 'Tier 1';
    ctr.isValidationOk();
    ctr.abn = '> 2 years';
    ctr.clientTier = 'Tier 3';
    ctr.isValidationOk();
    ctr.abn = '> 2 yrs / >1 year';
    ctr.isValidationOk();
    ctr.clientRate = 1;
	  ctr.baseRate = 1;
    ctr.realtimeNaf = 110000;
    ctr.privateSales = 'Y';
    ctr.isValidationOk();
  }

  @isTest
  static void testCarLoanCalc2() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;

    Test.startTest();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    // Finance One
    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);

    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

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

    ctr.warrantyAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.mv = 100;
    ctr.getCustomerPresentationStatusStyle();

    ctr.getInsuranceFailureReasons();
    //-

    ctr.nwcAcceptance = 'A';
    String[] details = new List<String>{
      QuotingCalculation.CALC_QUOTING,
      QuotingCalculation.PRO_FULLY,
      QuotingCalculation.PRO_STANDARD,
      QuotingCalculation.PRO_BASIC,
      InsuranceQuoteUtils.INS_PROD_MV,
      InsuranceQuoteUtils.INS_PROD_GAP,
      InsuranceQuoteUtils.INS_PROD_TAI,
      InsuranceQuoteUtils.INS_PROD_LTI,
      InsuranceQuoteUtils.INS_PROD_WARR,
      InsuranceQuoteUtils.INS_PROD_NWC,
      InsuranceQuoteUtils.INS_PROD_CCI
    };
    for (String a : details) {
      ctr.getTotalInsuranceType(a);
      ctr.getTotalInsuranceIncomeType(a);
    }
    ctr.getRates();

    ctr.Opp.Application__r.No_of_People__c = 2;
    ctr.initValidation();
    Test_DataGeneratorHelper.quoting.Green_Car__c = 'N';
    Test_DataGeneratorHelper.quoting.Name = 'RateSetter';
    update Test_DataGeneratorHelper.quoting;
		ctr = new PlentiCommercialExtension(sc);
  }

  @isTest
  static void testInsuranceProductSelected() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
    update Test_DataGeneratorHelper.tstApp;
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.customerProfile = ctr.getProfileOptions().get(1).getValue();
    ctr.clientTier = ctr.getTierOptions().get(1).getValue();
    ctr.assetCondition = 'new';
    ctr.vehicleYear = ctr.getBuildDatedOptions().get(1).getValue();
    ctr.applicationFee = 300;
    ctr.dof = 300;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    ctr.greenCar = 'N';
    ctr.brokeragePercentage = 1;
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
  }

  //This is is because a term in 84 months and a Client tier in Tier 3, must print a error.
  @isTest
  public static void testTermClientTier() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.reloadOpportunity();
    test.startTest();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

    ctr.calculate();
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.productLoanType = 'New';
    ctr.carPrice = 5000000000.00;
    ctr.deposit = 20000000.00;
    ctr.ppsr = 1000000000.00;
    ctr.residualValue = 10000.00;
    ctr.clientRate = 23.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 100000000.00;
    ctr.gapIncome = 500.00;

    ctr.warrantyLevel = 'Platinum - 24 months';
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
    ctr.nwcParam.isManuallyNWCPrice = false;
    //ctr.nwcParam.nwcPriceToCustomer = 14000;
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcPlan = 'A';
    ctr.nwcTerm = '12';
    ctr.nwcParam.state = 'SA';
    //NWCCalculator HJ - F - 12-07-2018

    // test for baseRateCalc() and calculateValidation()
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 200000000.00;
    ctr.term = 84;
    ctr.clientTier = 'Tier 3';
    ctr.vehicleYear = '0 - 3 years';
    ctr.privateSales = 'Y';
    ctr.applicationFee = 300000;
    ctr.dof = 300000;
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    System.debug('Start calculation >>>>>>>>>>>>>>>>>>>>>>>>>>');
    ctr.calculate();
    System.debug('End calculation >>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  }

  @istest
  static void testPrivateSales() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
    update Test_DataGeneratorHelper.tstApp;
    Test_DataGeneratorHelper.reloadOpportunity();
    test.startTest();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

    ctr.calculate();
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.productLoanType = 'New';
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.clientRate = 23.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;

    ctr.warrantyLevel = 'Platinum - 24 months';
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
    ctr.nwcParam.isManuallyNWCPrice = false;
    //ctr.nwcParam.nwcPriceToCustomer = 14000;
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcPlan = 'A';
    ctr.nwcTerm = '12';
    ctr.nwcParam.state = 'SA';
    //NWCCalculator HJ - F - 12-07-2018

    // test for baseRateCalc() and calculateValidation()
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.clientTier = 'Tier 1';
    ctr.vehicleYear = '0 - 3 years';
    ctr.applicationFee = 300;
    ctr.dof = 300;
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.nwcAcceptance = 'A';
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    System.debug('Start calculation >>>>>>>>>>>>>>>>>>>>>>>>>>');
    ctr.calculate();
    System.debug('End calculation >>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    ctr.saveQuoting();

    ctr.cciAcceptance = 'A';
    ctr.savePreApproval();
  }

  @isTest
  static void testAPIservice() {
    String endpoint = PlentiAPIManager.getParameterService(
      PlentiAPIManager.PLENTI_SERVICE_ENDPOINT
    );
    MultiRequestMock requestMocks = new MultiRequestMock();
    SingleRequestMock fakeRes = getQuickMockRequest(
      PlentiConstants.STATUS_OK,
      '{"Id":"49cb9e6f-9c4f-42ca-9bd3-bb5aa0d27147","Errors":{},' +
      '"IsCompleted":false,"Type":0,"_links":[{"Rel":"",' +
      '"Href":"/application/49cb9e6f-9c4f-42ca-9bd3-bb5aa0d27147"}]}'
    );
    requestMocks.addRequestMock(endpoint, fakeRes);
    requestMocks.addRequestMock(endpoint, fakeRes);
    Test.setMock(HttpCalloutMock.class, fakeRes);

    Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    buildQuoting(o.Id);

    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(o);

    PageReference calcRef = Page.PlentiCommercial;
    calcRef.getParameters().put('id', o.Id);
    Test.setCurrentPageReference(calcRef);
    PlentiCommercialExtension ctr = new PlentiCommercialExtension(sc);

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.customerProfile = ctr.getProfileOptions().get(1).getValue();
    ctr.clientTier = ctr.getTierOptions().get(1).getValue();
    ctr.assetCondition = 'new';
    ctr.vehicleYear = ctr.getBuildDatedOptions().get(1).getValue();
    ctr.applicationFee = 300;
    ctr.dof = 300;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    ctr.greenCar = 'N';
    ctr.brokeragePercentage = 1;
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);

    ctr.apiUser = UserInfo.getUserId();
    ctr.sendApplicationTest();
    ctr.sendApplication();
    ctr.assetCondition = 'used';
    ctr.vehicleYear = '2012';
    ctr.term = 84;
    ctr.isValidationOk();
  }

  private static void buildQuoting(Id oppId) {
    Application_Quoting__c q = new Application_Quoting__c();
    q.Name = PlentiCommercialExtension.LENDER_QUOTING;
    q.Opportunity__c = oppId;
    q.Residual_Value__c = 2000;
    q.DOF__c = 990;
    q.Term__c = 5;
    q.Loan_Type__c = 'Purchase';
    q.Private_Sales__c = 'Y';
    q.Vehicle_Price__c = 23000;
    q.Deposit__c = 2500;
    insert q;
  }

  private static SingleRequestMock getQuickMockRequest(
    Integer statusCode,
    String body
  ) {
    SingleRequestMock r = new SingleRequestMock(
      statusCode,
      'Complete',
      body,
      null
    );
    return r;
  }
}