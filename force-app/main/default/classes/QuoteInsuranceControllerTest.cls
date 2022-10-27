@isTest(SeeAllData=true)
public class QuoteInsuranceControllerTest {

  private final static String LENDER_QUOTING = 'Pepper MV';

  
  @isTest
  static void testLoadData() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Test.startTest();
    QuoteInsuranceController.loadData(opp.Id);
    try {
      QuoteInsuranceController.loadData(null);
    } catch (GenericException e) { }
    Test.stopTest();
  }

  @isTest
  static void testPresentationStatus() {
    Application_Quoting__c q = buildAppQuote();
    Application_InsuranceQuote__c iq = buildAppInsuranceQuote();
    q.App_Insurance_Quote__c = iq.Id;
    update q;

    Test.startTest();
    
    // Without status
    QuoteInsuranceController.getPresentationStatus(q.Id);
    // With status
    iq.Customer_Choice_Status__c = 'SENT';
    update iq ;

    QuoteInsuranceController.getPresentationStatus(q.Id);
    
    // Null parameter
    QuoteInsuranceController.getPresentationStatus(null);

    Test.stopTest();
  }

  @isTest
  static void testGAPCalculation() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

    Test.startTest();
    
    // Liberty
    QuoteInsuranceController.calculateGAP(opp.Id, 'Option 1 $20K');
    QuoteInsuranceController.calculateGAP(opp.Id, 'Option 2 $15K');
    QuoteInsuranceController.calculateGAP(opp.Id, 'Option 3 $7.5K');
    // wrong option value
    QuoteInsuranceController.calculateGAP(opp.Id, 'Any option');
    
    // Null parameter
    QuoteInsuranceController.calculateGAP(opp.Id, null);
    QuoteInsuranceController.calculateGAP(null, null);

    Test.stopTest();
  }

  @isTest
  static void testLPICalculation() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application_Quoting__c q = buildAppQuote();

    Test.startTest();
    
    // Liberty
    QuoteInsuranceController.calculateLPI(opp.Id, 12, 'Disability', q, true, 1000.00);
    QuoteInsuranceController.calculateLPI(opp.Id, 12, 'Disability', q, false, null);
    // wrong option value
    QuoteInsuranceController.calculateLPI(opp.Id, 120, 'abcdefg', null, true, 1000.00);
    
    // Null parameter
    QuoteInsuranceController.calculateLPI(null, null, null, null, null, null);

    Test.stopTest();
  }

  @isTest
  static void testNWCCalculation() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application_Quoting__c q = buildAppQuote();

    Test.startTest();
    
    // Integrity
    QuoteInsuranceController.calculateNWC('Integrity Absolute', '12', 'Level 4 - (3)', q);
    
    // Null parameter
    try {
      QuoteInsuranceController.calculateNWC(null, null, null, null);
    } catch (AuraHandledException e) {}

    Test.stopTest();
  }
  
  // --------------------
  // Supporting functions
  // --------------------
  private static Application_Quoting__c buildAppQuote() {
    Application_Quoting__c q = QuoteControllerTest.buildAppQuoting();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(false);
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);

    // App Quoting
    q.Opportunity__c = opp.id;
    q.Application__c = app.id;
    q.Name = LENDER_QUOTING;

    insert q;
    return q;
  }

  private static Application_InsuranceQuote__c buildAppInsuranceQuote() {
    Application_Quoting__c q = QuoteControllerTest.buildAppQuoting();
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);

    // Insurance quote
    Application_InsuranceQuote__c iq = new Application_InsuranceQuote__c();
    iq.Application__c = app.Id;
		iq.Name = LENDER_QUOTING;
    insert iq;
    return iq;
  }





}