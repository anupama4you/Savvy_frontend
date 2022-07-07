@isTest(SeeAllData=true)
public class RatesetterPLExtensionTest {
  @isTest
  static void testPersonalLoanCalc() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.RatesetterPL;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    RatesetterPLExtension ctr = new RatesetterPLExtension(sc);

    ctr.calculate();
    ctr.dto.dof = null;
    ctr.dto.ppsr = null;
    ctr.dto.baseRate = null;
    ctr.dto.clientRate = null;
    ctr.dto.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.dto.loanTypeDetail = 'AAA';
    ctr.dto.carPrice = 50000.00;
    ctr.dto.deposit = 2000.00;
    ctr.dto.applicationFee = 500;
    ctr.dto.dof = 990;
    ctr.dto.ppsr = 10.00;
    ctr.dto.residualValue = 10000.00;
    ctr.dto.baseRate = 12;
    ctr.dto.clientRate = 16;

    ctr.dto.gapLevel = 'Premier Cover 1';
    ctr.dto.gap = 1000.00;
    ctr.dto.gapIncome = 500.00;

    ctr.dto.vehicleGroup = '';
    ctr.dto.vehicleGroup = '4';
    ctr.dto.state = 'WA';
    ctr.dto.warrantyLevel = 'Platinum - 24 months';
    ctr.dto.vehicleGroup = '2';
    ctr.dto.vehicleGroup = '3';
    ctr.dto.awd = 'Y';
    ctr.dto.turbo = 'Y';
    ctr.dto.diesel = 'Y';
    ctr.dto.state = '';
    ctr.dto.state = 'ACT';
    ctr.dto.state = 'NSW';
    ctr.dto.state = 'NT';
    ctr.dto.state = 'VIC';
    ctr.dto.state = 'TAS';
    ctr.dto.state = 'QLD';
    ctr.dto.vehicleGroup = '1';
    ctr.dto.awd = 'N';
    ctr.dto.turbo = 'N';
    ctr.dto.diesel = 'N';

    ctr.dto.state = 'SA';
    ctr.dto.warrantyLevel = 'Platinum - 12 months';
    ctr.dto.ltiLevel = 'Platinum Cover 1';
    ctr.dto.lti = 200.00;
    ctr.dto.ltiIncome = 100.00;
    ctr.dto.truckGapLevel = 'Cover 1';
    ctr.dto.truckGap = 300.00;
    ctr.dto.truckGapIncome = 150.00;
    ctr.dto.taiLevel = 'TAI Cover 1 ($5,000)';
    ctr.dto.tai = 400.00;
    ctr.dto.taiIncome = 200.00;
    ctr.dto.mvLevel = 'AIC/Eric';
    ctr.dto.mv = 500.00;
    ctr.dto.mvIncome = 250.00;
    ctr.dto.cci = 600.00;
    ctr.dto.cciIncome = 300.00;
    ctr.dto.nwc = 700.00;
    ctr.dto.nwcIncome = 350.00;

    // test for baseRateCalc() and calculateValidation()
    ctr.reset();
    ctr.dto.purposeType = ctr.getPurposeTypeOptions().get(4).getValue();
    ctr.dto.carPrice = 12000.00;
    ctr.dto.applicationFee = 500;
    ctr.dto.term = 60;
    //ctr.dto.loanTypeDetail = 'Unsecured';
    ctr.feesCalc();
    ctr.dto.clientRate = 10;
    ctr.calculate();
    System.assert(ctr.dto.rental > 0);

    ctr.savePreApproval();
    ctr.dto.term = 48;
    ctr.dto.insuranceInputMode = 'M';

    ctr.dto.loanTypeDetail = 'Secured';
    ctr.dto.paymentType = 'Advance';
    ctr.calculate();

    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    ctr.dto.nwcAcceptance = 'A';
    ctr.saveQuoting();
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.dto.getRealtimeNaf();

    ctr.getDOFRates();
    ctr.getAppFeeRates();
    ctr.getMonthlyFeeRates();
    ctr.getRates();

    ctr.getHasLenderApp();
    ctr.getIsBrokerPartnerUser();

    // Calculator PDF
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('lender', 'LATITUDE CALCULATION');
    Test.setCurrentPageReference(calcPdf);
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    calcPdfCon.getIsLatitudePersonal();

    //ctr = new RatesetterPLExtension(sc);
    test.stopTest();
  }

  @isTest
  static void testAPIservicePL() {
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

    PageReference calcRef = Page.RateSetterCalculator;
    calcRef.getParameters().put('id', o.Id);
    Test.setCurrentPageReference(calcRef);
    RateSetterPLExtension ctr = new RateSetterPLExtension(sc);

    ctr.reset();
    ctr.dto.purposeType = ctr.getPurposeTypeOptions().get(4).getValue();
    ctr.dto.carPrice = 12000.00;
    ctr.dto.applicationFee = 500;
    ctr.dto.term = 60;
    //ctr.dto.loanTypeDetail = 'Unsecured';
    ctr.feesCalc();
    ctr.dto.clientRate = 10;
    ctr.calculate();
    System.debug('rental: ' + ctr.dto.rental);
    System.assert(ctr.dto.rental > 0);

    ctr.apiUser = UserInfo.getUserId();
    ctr.sendApplicationTest();
    ctr.sendApplication();
  }

  private static void buildQuoting(Id oppId) {
    Application_Quoting__c q = new Application_Quoting__c();
    q.Name = RateSetterCalculatorExtension.LENDER_QUOTING;
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