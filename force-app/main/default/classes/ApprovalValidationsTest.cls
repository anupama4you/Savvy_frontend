@isTest(SeeAllData=true)
public class ApprovalValidationsTest {
  @isTest
  static void testBasicApprovalValidations() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    // nulll parameter
    ApprovalValidations.validatePreApproval(null);
    // valid id
    ApprovalValidations.validatePreApproval(o.Id);
    // invalid id
    delete o;
    ApprovalValidations.validatePreApproval(o.Id);
    Test.stopTest();
  }

  @isTest
  static void testPreApproval() {
    ObjWrap data = buildBaseData();
    Test.startTest();

    ApprovalValidations.validatePreApproval(data.opp.Id);

    // Self-employed (Servicinf calculation)
    data.serv.Is_Self_Employed__c = true;
    data.serv.Is_Splitting_Expenses__c = true;
    data.app.Application_Type__c = 'Business';
    data.app.Business_Structure__c = 'Individual or Sole Trader';
    data.app.No_of_People__c = 2;
    data.quoting.Loan_Product__c = 'Chattel Mortgage-Low-Doc';
    update data.serv;
    update data.app;
    update data.quoting;
    ApprovalValidations.validatePreApproval(data.opp.Id);
    // Amendment
    ApprovalValidations.validateAmendment(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testFormalApproval() {
    ObjWrap data = buildBaseData();
    data.serv.Is_Self_Employed__c = true;
    data.serv.Is_Splitting_Expenses__c = true;
    data.app.Application_Type__c = 'Business';
    data.app.Business_Structure__c = 'Individual or Sole Trader';
    data.app.No_of_People__c = 2;
    data.quoting.Loan_Product__c = 'Chattel Mortgage-Low-Doc';
    update data.serv;
    update data.app;
    update data.quoting;
    Test.startTest();
    ApprovalValidations.validateFormalApproval(data.opp.Id);
    Test.stopTest();
  }

  @isTest
  static void testSettlement() {
    ObjWrap data = buildBaseData();
    // Finance One
    // Application
    data.app.Mode_of_Employment_1__c = 'Casual';
    update data.app;
    // Quoting tools
    data.quoting.Name = FinanceOneExtension.LENDER_QUOTING;
    data.quoting.Loan_Type__c = 'Refinance';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Refinance';
    data.prod.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    // Asset detail
    AssetDetailsDTO assetDto = new AssetDetailsDTO();
    ApplicationExtraDataHelper.upsertData(
      data.app.Id,
      'Asset Detail ' + data.quoting.Name,
      'Asset Detail - LTV (Pre-approval)',
      assetDto
    );
    // Opportunity
    data.opp.Purchase_Type__c = 'Private';
    update data.opp;

    Test.startTest();
    ApprovalValidations.validateSettlement(data.opp.Id);
    Test.stopTest();
  }

  @isTest
  static void testManualSettlement() {
    ObjWrap data = buildBaseData();
    // Finance One
    // Application
    data.app.Mode_of_Employment_1__c = 'Casual';
    update data.app;
    // Quoting tools
    data.quoting.Name = FinanceOneExtension.LENDER_QUOTING;
    data.quoting.Loan_Type__c = 'Refinance';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Refinance';
    data.prod.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    // Asset detail
    AssetDetailsDTO assetDto = new AssetDetailsDTO();
    ApplicationExtraDataHelper.upsertData(
      data.app.Id,
      'Asset Detail ' + data.quoting.Name,
      'Asset Detail - LTV (Pre-approval)',
      assetDto
    );
    // Opportunity
    data.opp.Purchase_Type__c = 'Private';
    update data.opp;

    Test.startTest();
    ApprovalValidations.validateManualSettlement(data.opp.Id);
    Test.stopTest();
  }

  @isTest
  static void testApprovalLiberty() {
    ObjWrap data = buildBaseData();
    // Quoting tools
    data.quoting.Name = LibertyDriveExtension.LENDER_QUOTING;
    data.quoting.LTV__c = '110';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Purchase';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    // Asset
    data.asset.LVR__c = 100;
    update data.asset;

    AssetDetailsDTO assetDto = new AssetDetailsDTO();
    ApplicationExtraDataHelper.upsertData(
      data.app.Id,
      'Asset Detail ' + data.quoting.Name,
      'Asset Detail - LTV (Pre-approval)',
      assetDto
    );

    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testApprovalMacquarieCon() {
    ObjWrap data = buildBaseData();
    // Quoting tools
    data.quoting.Name = MacquarieConsumerExtension.LENDER_QUOTING;
    update data.quoting;
    // Product
    data.prod.Lender__c = 'Macquarie Leasing';
    data.prod.Loan_Type__c = 'Purchase';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testApprovalMoney3Part1() {
    ObjWrap data = buildBaseData();
    // App
    data.app.Type_of_Asset__c = 'Equipment';
    update data.app;
    // Quoting tools
    data.quoting.Name = Money3CalculatorExtension.LENDER_QUOTING;
    data.quoting.Customer_Profile__c = 'Asset Finance';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Purchase';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    // Money 3 not Asset Finance
    // App
    data.app.Type_of_Asset__c = 'Car';
    update data.app;
    // Quoting
    data.quoting.Customer_Profile__c = 'Personal Finance';
    update data.quoting;

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testApprovalMoney3Part2() {
    ObjWrap data = buildBaseData();
    // App
    data.app.Type_of_Asset__c = 'Car';
    update data.app;
    // Quoting tools
    data.quoting.Name = Money3CalculatorExtension.LENDER_QUOTING;
    data.quoting.Customer_Profile__c = 'Personal Finance';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Purchase';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    // Opportunity
    data.opp.Purchase_Type__c = 'Private';
    update data.opp;
    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    data.opp.Purchase_Type__c = 'Private Sale - Verimoto';
    update data.opp;
    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testApprovalMoney3Part3() {
    ObjWrap data = buildBaseData();
    // App
    data.app.Type_of_Asset__c = 'Car';
    update data.app;
    // Quoting tools
    data.quoting.Name = Money3CalculatorExtension.LENDER_QUOTING;
    data.quoting.Customer_Profile__c = 'Personal Finance';
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Refinance';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    // Opportunity
    data.opp.Purchase_Type__c = 'Private Sale - Verimoto';
    update data.opp;
    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    data.opp.Purchase_Type__c = 'Dealer';
    update data.opp;
    ApprovalValidations.validateFormalApproval(data.opp.Id);

    data.opp.Purchase_Type__c = 'Sale and Leaseback';
    update data.opp;
    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  @isTest
  static void testApprovalAFS() {
    ObjWrap data = buildBaseData();
    // Quoting tools
    data.quoting.Name = AfsCalculatorExtension.LENDER_QUOTING;
    update data.quoting;
    // Product
    data.prod.Lender__c = data.quoting.Name;
    data.prod.Loan_Type__c = 'Purchase';
    data.prod.Loan_Product__c = 'Consumer Loan';
    data.prod.Quoting_Source__c = data.quoting.Name;
    update data.prod;
    Test.startTest();

    ApprovalValidations.validateFormalApproval(data.opp.Id);

    Test.stopTest();
  }

  public class ObjWrap {
    Custom_Opportunity__c opp;
    Application__c app;
    Application_Quoting__c quoting;
    Application_InsuranceQuote__c quote;
    Product__c prod;
    Application_Asset_Detail__c asset;
    Application_Servicing__c serv;
  }

  private static ObjWrap buildBaseData() {
    ObjWrap r = new ObjWrap();
    r.app = Test_DataGeneratorHelper.buildCarApp(true);
    r.opp = Test_DataGeneratorHelper.tstOpportunity;
    Test_DataGeneratorHelper.createQuoting();
    r.quoting = Test_DataGeneratorHelper.quoting;
    r.quoting.Name = 'Pepper MV';
    r.quoting.Loan_Type__c = 'Purchase';
    Test_DataGeneratorHelper.createProduct();
    r.prod = Test_DataGeneratorHelper.tstFinanceProduct;
    r.prod.Lender__c = 'Pepper';
    r.prod.Quoting_Source__c = 'Pepper MV';
    update r.prod;
    Test_DataGeneratorHelper.createAssetDetailLTV();
    r.asset = Test_DataGeneratorHelper.asset;
    // Application_Servicing__c
    r.serv = new Application_Servicing__c();
    r.serv.Lender_Code__c = 'HEM';
    insert r.serv;
    r.opp.ApplicationServicing__c = r.serv.Id;
    update r.opp;
    // Second job
    Test_DataGeneratorHelper.createSecondJob(r.app.Id, '2');
    Test_DataGeneratorHelper.createSecondJob(r.app.Id, '1');

    return r;
  }
}