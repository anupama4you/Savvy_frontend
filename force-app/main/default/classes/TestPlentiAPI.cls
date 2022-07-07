@isTest(SeeAllData=true)
public class TestPlentiAPI {
  
  @isTest static void testReqAppTest() {
    Test_DataGeneratorHelper.buildCarApp(true);
    Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
    
    Test.startTest();
    PlentiAPIService api = new PlentiAPIService();

    // User info
    try {
      api.getPlentiApplication(oppId, null);
      System.assert(false, 'User validation missed');
    } catch (GenericException e) {}

    // quoting calculation
    try {
      api.getPlentiApplication(oppId, UserInfo.getUserId());
      System.assert(false, 'Quoting validation missed');
    } catch (GenericException e) {}

    // Create quoting tools
    buildQuoting(oppId);

    // Full Application
    api.requestApplicationTest(oppId, UserInfo.getUserId());
    Test.stopTest();
  }

  @isTest static void testReqApp() {
    String endpoint = PlentiAPIManager.getParameterService(PlentiAPIManager.PLENTI_SERVICE_ENDPOINT);
    endpoint += PlentiAPIManager.ENDPOINT_AUTO; 
    MultiRequestMock requestMocks = new MultiRequestMock();
    SingleRequestMock fakeRes = getQuickMockRequest(
      PlentiConstants.STATUS_OK,
      '{"Id":"49cb9e6f-9c4f-42ca-9bd3-bb5aa0d27147","Errors":{},' +
      '"IsCompleted":false,"Type":0,"_links":[{"Rel":"",'+
      '"Href":"/application/49cb9e6f-9c4f-42ca-9bd3-bb5aa0d27147"}]}');
		requestMocks.addRequestMock(endpoint, fakeRes);
    Test.setMock(HttpCalloutMock.class, fakeRes);

    Test_DataGeneratorHelper.buildCarApp(true);
    Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
    // Create quoting tools
    buildQuoting(oppId);

    Test.startTest();
    PlentiAPIService api = new PlentiAPIService();

    // Full Application
    PlentiAPIManager mgr = api.requestApplication(oppId, UserInfo.getUserId());
    Test.stopTest();
  }

  @isTest static void testReqAppFail() {
    String endpoint = PlentiAPIManager.getParameterService(PlentiAPIManager.PLENTI_SERVICE_ENDPOINT);
    endpoint += PlentiAPIManager.ENDPOINT_AUTO;
    MultiRequestMock requestMocks = new MultiRequestMock();
    SingleRequestMock fakeRes = getQuickMockRequest(
      400,
      '{"Id":"00000000-0000-0000-0000-000000000000",'+
      '"Errors":{"$.loan.term":"This field is required","$.loan.deposit":"This field is required",'+
      '"$.loan.purchasedPrice":"This field is required","$.finances.income":"Your annual gross income is required",'+
      '"$.housing.monthlyRent":"Invalid value","$.income.netIncome":"This field is required",'+
      '"$.income.other[0].type":"This field is required","$.income.other[0].amount":"This field is required",'+
      '"$.income.other[0]":"Other income item invalid","$.income.other[1].type":"This field is required",'+
      '"$.income.other[1].amount":"This field is required","$.income.other[1]":"Other income item invalid",'+
      '"$.income.other[2].type":"This field is required","$.income.other[2].amount":"This field is required",'+
      '"$.income.other[2]":"Other income item invalid","$.income.other[3].type":"This field is required",'+
      '"$.income.other[3].amount":"This field is required","$.income.other[3].frequency":"This field is required",'+
      '"$.income.other[3]":"Other income item invalid","$.income.other[4].type":"This field is required",'+
      '"$.income.other[4].amount":"This field is required","$.income.other[4]":"Other income item invalid",'+
      '"$.income.other[5].amount":"This field is required","$.income.other[5]":"Other income item invalid",'+
      '"$.debts[0].balance":"This field is required","$.debts[0]":"Debt item contains an error",'+
      '"$.debts[1].balance":"This field is required","$.debts[1].claimedMonthlyRepayment":"This field is required",'+
      '"$.debts[1].claimedLoanAmount":"This field is required","$.debts[1]":"Debt item contains an error",'+
      '"$.debts[2].balance":"This field is required","$.debts[2].claimedMonthlyRepayment":"This field is required",'+
      '"$.debts[2].claimedLoanAmount":"This field is required","$.debts[2]":"Debt item contains an error",'+
      '"$.debts[3].balance":"This field is required","$.debts[3].limit":"This field is required",'+
      '"$.debts[3]":"Debt item contains an error","$.debts[4].balance":"This field is required",'+
      '"$.debts[4].limit":"This field is required","$.debts[4]":"Debt item contains an error",'+
      '"$.debts[5].balance":"This field is required","$.debts[5].limit":"This field is required",'+
      '"$.debts[5]":"Debt item contains an error"},"IsCompleted":false,"Type":0,'+
      '"_links":[{"Rel":"","Href":"/application/00000000-0000-0000-0000-000000000000"}]}');
		requestMocks.addRequestMock(endpoint, fakeRes);
    Test.setMock(HttpCalloutMock.class, fakeRes);

    Test_DataGeneratorHelper.buildCarApp(true);
    Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
    // Create quoting tools
    buildQuoting(oppId);

    Test.startTest();
    PlentiAPIService api = new PlentiAPIService();

    // Full Application
    try {
      PlentiAPIManager mgr = api.requestApplication(oppId, UserInfo.getUserId());
    } catch (GenericException e) {
      System.assert('[Plenti Application] process failed.'.equals(e.getMessage()), 'Response incorrect.');
    }
    Test.stopTest();
  }

  @isTest static void testOtherMethods() {
    Test.startTest();
    PlentiAPIService api = new PlentiAPIService();
    Set<String> tmp = new Set<String>{
      null, 'Boarding', 'Own Outright', 'Renting(Private)',
      'Renting(Agent)', 'Mortgage', 'Parents/Relative',
      'Any-value'
    };
    for (String t : tmp) {
      api.getResidentialStatus(t);
    }

    tmp = new Set<String>{
      null, 'Full Time', 'Full-Time', 'Part Time',
      'Part-Time', 'Self Employed', 'Casual', 'Contract',
      'Any-value'
    };
    for (String t : tmp) {
      api.getEmploymentStatus(t);
    }

    tmp = new Set<String>{
      null, 'Australian Citizen', 'PR VISA', 'Working VISA', 
      'Student VISA',
      'Any-value'
    };
    for (String t : tmp) {
      api.getResidency(t);
    }

    api.getIncomeFrequency('Yearly');

    // Loan Purpose
    tmp = new Set<String>{
      null, 'Loan/Debt Consolidation', 'Car', 'Motorbike', 
      'Boat', 'Other', 'Holiday', 'Wedding',
      'Any-value'
    };
    for (String t : tmp) {
      PlentiAPIService.getPurpose(t);
    }

    // API manager
    PlentiAPIManager mgr = new PlentiAPIManager();
    PlentiAPIManager.getUserOptionsConnect();
    
    PlentiAPIManager.PlentiResponseWrapper dto = new PlentiAPIManager.PlentiResponseWrapper();
    dto.Id = null;
    dto.Errors = null;
    dto.IsCompleted = null;
    dto.lastResponseApplication = null;
    dto.hasError();

    // PlentiAPIRequestWrapper
    PlentiAPIRequestWrapper w = new PlentiAPIRequestWrapper();
    w.DefinitionName = null;
    w.application = new PlentiAPIRequestWrapper.Application();
    
    w.application.applicant = new PlentiAPIRequestWrapper.Applicant();
    w.application.applicant.firstName = null;
    w.application.applicant.middleName = null;
    w.application.applicant.lastName = null;
    w.application.applicant.dateOfBirth = new PlentiAPIRequestWrapper.DateOfBirth();
    w.application.applicant.dateOfBirth.isoString = null;
    w.application.applicant.maritalStatus = null;
    w.application.applicant.residency = null;

    w.application.contact = new PlentiAPIRequestWrapper.Contact();
    w.application.contact.mobileNumber = null;
    w.application.contact.email = null;

    w.application.finances = new PlentiAPIRequestWrapper.Finances();
    w.application.finances.employment = null;
    w.application.finances.income = null;
    w.application.finances.numberOfDependants = null;

    w.application.address = new PlentiAPIRequestWrapper.Address();
    w.application.address.residentialAddress = new PlentiAPIRequestWrapper.AddressWrapper();
    w.application.address.residentialAddress.unitNumber = null;
    w.application.address.residentialAddress.streetNumber = null;
    w.application.address.residentialAddress.street = null;
    w.application.address.residentialAddress.suburb = null;
    w.application.address.residentialAddress.postCode = null;
    w.application.address.residentialAddress.state = null;
    w.application.address.residentialAddress.yearsAtAddress = null;
    w.application.address.previousAddress = null;

    w.application.expenses = new PlentiAPIRequestWrapper.Expenses();
    w.application.expenses.netLivingExpenses = null;
    w.application.expenses.netLivingExpensesFrequency = null;
    w.application.expenses.forseeRepaymentAbilityChange = null;
    w.application.expenses.foodAndGroceries = null;
    w.application.expenses.utilities = null;
    w.application.expenses.phoneAndInternet = null;
    w.application.expenses.transport = null;
    w.application.expenses.others = new PlentiAPIRequestWrapper.ExpenseWrapper();
    w.application.expenses.others.amount = null;
    w.application.expenses.others.frequency = null;

    w.application.housing = new PlentiAPIRequestWrapper.Housing();
    w.application.housing.ownershipStatus = null;
    w.application.housing.propertyValue = null;
    w.application.housing.monthlyMortgage = null;
    w.application.housing.mortgageBalance = null;
    w.application.housing.monthlyRent = null;

    w.application.income = new PlentiAPIRequestWrapper.Income();
    w.application.income.payslipStartDate = null;
    w.application.income.payslipEndDate = null;
    w.application.income.payslipPayPeriodNetIncome = null;
    w.application.income.hasYTDDetail = null;
    w.application.income.employmentStartDate = null;
    w.application.income.netYTD = null;
    w.application.income.netIncome = null;
    w.application.income.netIncomeFrequency = null;
    w.application.income.spouseNetIncome = null;
    w.application.income.spouseNetIncomeFrequency = null;
    w.application.income.hasOtherIncome = null;
    w.application.income.other = new List<PlentiAPIRequestWrapper.OtherIncome>();
    PlentiAPIRequestWrapper.OtherIncome oi = new PlentiAPIRequestWrapper.OtherIncome();
    oi.type = null;
    oi.amount = null;
    oi.frequency = null;
    w.application.income.other.add(oi);

    w.application.employment = new List<PlentiAPIRequestWrapper.Employment>();
    PlentiAPIRequestWrapper.Employment e = new PlentiAPIRequestWrapper.Employment();
    e.type = null;
    e.employer = null;
    e.industry = null;
    e.occupation = null;
    e.years = null;
    e.months = null;
    e.isCurrent = null;
    w.application.employment.add(e);
    
    w.application.bank = new PlentiAPIRequestWrapper.Bank();
    w.application.bank.accountNumber = null;
    w.application.bank.accountName = null;
    w.application.bank.bsb = null;

    w.application.broker = new PlentiAPIRequestWrapper.Broker();
    w.application.broker.brokerEmail = null;
    w.application.broker.brokerMobile = null;
    w.application.broker.brokerageAmount = null;
    w.application.broker.rateDiscount = null;

    w.application.debts = new List<PlentiAPIRequestWrapper.Debt>();
    PlentiAPIRequestWrapper.Debt d = new PlentiAPIRequestWrapper.Debt();
    d.type = '';
    d.balance = '';
    d.claimedMonthlyRepayment = '';
    d.payoffFullEveryMonth = false;
    d.limit_m = '';
    d.claimedLoanAmount = '';
    w.application.debts.add(d);

    w.application.loan = new PlentiAPIRequestWrapper.Loan();
    w.application.loan.term = '';
    w.application.loan.financeType = '';
    w.application.loan.saleType = '';
    w.application.loan.deposit = '';
    w.application.loan.addon = '';
    w.application.loan.purchasedPrice = '';
    w.application.loan.vehicleCondition = '';
    w.application.loan.modelYear = Date.today().year();
    
    w.application.termsAndConditions = new PlentiAPIRequestWrapper.TermsAndConditions();
    w.application.termsAndConditions.privacyAgreement = true;
    w.application.termsAndConditions.creditReportingAgreement = true;
    w.application.termsAndConditions.creditGuideConfirmation = true;
    w.application.termsAndConditions.balloonPaymentConsentConfirmation = true;

    w.application.borrowerMetaInfo = new PlentiAPIRequestWrapper.BorrowerMetaInfo();
    w.application.borrowerMetaInfo.sourceFromApi = false;

    w.application.balloonPayment = new PlentiAPIRequestWrapper.BalloonPayment();
    w.application.balloonPayment.enableBalloonPayment = false;
    w.application.balloonPayment.balloonPaymentAmount = '';
    w.application.balloonPayment.balloonPaymentPercentage = 5;
    w.application.balloonPayment.customerReason = '';
    w.application.balloonPayment.customerReasonExplanation = '';
    w.application.balloonPayment.customerPaidMethodWhenLoanDue = '';

    Test.stopTest();
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

  private static SingleRequestMock getQuickMockRequest(Integer statusCode, String body) {
		SingleRequestMock r = new SingleRequestMock(
				statusCode, 'Complete', body, null
			);
		return r;
	}

}