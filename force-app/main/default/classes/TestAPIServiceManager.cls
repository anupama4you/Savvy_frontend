@isTest(SeeAllData=true)
public class TestAPIServiceManager {
  static testMethod void testEmptyPartnerAPISettings() {
    User pu = buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      try {
        APIServiceManager.getPartnerAPISetting(null);
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting('any-lender');
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_LENDER_PEPPER
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_LENDER_FINANCEONE
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_LENDER_MONEY3
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_LENDER_LATITUDE
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_LENDER_PLENTI
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_INSURER_ERIC
        );
      } catch (GenericException e) {
      }
      try {
        APIServiceManager.getPartnerAPISetting(
          APIServiceManager.API_PROVIDER_EQUIFAX
        );
      } catch (GenericException e) {
      }
    }
    Test.stopTest();
  }

  static testMethod void testPartnerAPISettings() {
    User pu = buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      Test_DataGeneratorHelper.createPartnerAPISettings();
      
      Set<String> params = new Set<String>();
      // Pepper      
      params.add(PepperAPIManager.PEPPER_SERVICE_ENDPOINT);
      params.add(PepperAPIManager.PEPPER_SERVICE_CLIENT_ID);
      params.add(PepperAPIManager.PEPPER_SERVICE_CLIENT_SECRET);
      params.add(PepperAPIManager.PEPPER_SERVICE_MERCHANT_ID);
      // Finance One
      params.add(FinanceOneServices.PARAM_ENDPOINT1);
      params.add(FinanceOneServices.PARAM_ENDPOINT2);
      params.add(FinanceOneServices.PARAM_TOKEN);
      // Money3
      params.add(Money3APIManager.MONEY3_SERVICE_TOKEN);
      params.add(Money3APIManager.MONEY3_SERVICE_ENDPOINT);
      params.add(Money3APIManager.MONEY3_SERVICE_DOCUMENT_ENDPOINT);
      // Equifax
      // params.add(VedaEnquiryExtension.PARAM_SERVICE_ENDPOINT);
      // params.add(VedaEnquiryExtension.PARAM_REPORT_ENDPOINT);
      // params.add(VedaEnquiryExtension.PARAM_USERNAME);
      // params.add(VedaEnquiryExtension.PARAM_PASSWORD);
      // params.add(VedaEnquiryExtension.PARAM_DEFAULT_LIMIT);
      // params.add(VedaEnquiryExtension.PARAM_SECOND_LIMIT);

      params.add('Equifax_Service_Endpoint');
      params.add('Equifax_Report_Endpoint');
      params.add('Equifax_Username');
      params.add('Equifax_Password');
      params.add('Equifax_Default_Limit');
      params.add('Equifax_Second_Limit');
      
      for (String p : params) {
        APIServiceManager.getParameterService(p);
      }
      APIServiceManager.listLenderLogins('Pepper');
    }
    Test.stopTest();
  }

  static testMethod void testLoadingData() {
    // Prepare data
    Test_DataGeneratorHelper.buildCarApp(true);
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.reloadOpportunity();

    Id appId = Test_DataGeneratorHelper.tstApp.Id;
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
    //-
    Test.startTest();
    PepperAPIManager api = new PepperAPIManager();
    api.isError = false;
    api.message = null;
    api.responseStatus = null;
    api.responseMessage = null;
    api.reqBody = null;

    APIServiceManager.getCustomOpportunityForApplication(opp);
    // Employment
    APIServiceManager.loadPreviousEmployments(opp);
    api.getApplicantEmployments(appId, '1');
    api.getApplicantEmployments(appId, '2');
    // Second Job
    api.getApplicantSecondJob(appId, '1');
    api.getApplicantSecondJob(appId, '2');

    // Addresses
    APIServiceManager.loadAddressFinanceDetails(opp);

    // Incomes
    api.getAppIncomes(appId);

    // Loans
    api.getAppLoans(appId);

    // Credit Cards
    api.getAppCreditCards(appId);

    // Lender Logins
    APIServiceManager.listLenderLogins('Pepper');

    // Quotings
    api.hasAcceptedInsurances(quoting);

    // Lender comments
    APIServiceManager.getLenderComments(appId);

    // Get User
    APIServiceManager.getUserById(UserInfo.getUserId());

    Test.stopTest();
  }

  static testMethod void testAPIResponse() {
    Test.startTest();
    APIServiceManager.APIResponse res = new APIServiceManager.APIResponse();
    res.lenderResponse = new LenderAPIResponse__c();
    res.addMessage(ApexPages.Severity.ERROR, 'my error message');
    PepperAPIManager m = new PepperAPIManager();
    m.addConfirmMessage('confirm message');
    m.addErrorMessage('error message');
    m.addFatalMessage('fatal message');
    m.addInfoMessage('info message');
    m.addWarningMessage('warning message');
    m.getErrorMessages();
    m.getWarningMessages();
    m.hasErrorMessages();
    m.hasWarningsMessages();
    Test.stopTest();
  }

  private static User buildPartnerUser() {
    Id recType = SOQLSingletonQueries.recs()
      .recordTypes.get('Business Account');
    String username = 'newone-123456789@noemail.com';
    UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'Director' Limit 1];
    // User sysAdminUser = [Select Id, Name from User where Id = :UserInfo.getUserId()];
    User adminUser = [Select Id, UserRoleId From User Where Name='Savvy Admin' Limit 1];
    adminUser.UserRoleId  = userrole.Id;
    update adminUser;
    System.runAs(adminUser) {
      Account a = new Account(
        Name = 'Test Business Account',
        RecordTypeId = recType
      );
      insert a;
      Contact c = new Contact(LastName = 'Montoya');
      c.AccountId = a.Id;
      insert c;
      
      Profile p = [SELECT Id FROM Profile WHERE Name = 'Broker Community User'];
      User u = new User(
        alias = 'test123',
        email = 'test123@noemail.com',
        emailencodingkey = 'UTF-8',
        lastname = 'Testing',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US',
        profileid = p.Id,
        country = 'United States',
        IsActive = true,
        contactId = c.Id,
        timezonesidkey = 'America/Los_Angeles',
        username = username,
        communityNickname = c.LastName + '_' + Math.random()
      );
      insert u;
    }
    User u = [SELECT id FROM user WHERE username = :username LIMIT 1];
    return u;
  }

  private static void generateAppDetails(Id appId) {
    // Employment
    List<Application_Employment__c> empList = new List<Application_Employment__c>();
    Application_Employment__c e = new Application_Employment__c();
    e.Application__c = appId;
    e.Applicant__c = '1';
    e.Contact_Name__c = 'One Name';
    e.Employment_Type__c = 'Full Time';
    e.Start_Date__c = Date.today();

    empList.add(e);
    insert(empList);
    // Incomes

    // Loans

    // Credit Cards

  }
}