@isTest(SeeAllData=true)
public class QuoteLibertyCalcControllerTest {
  
  private final static String LENDER_QUOTING = 'Liberty Drive';
  private final static List<String> LENDER_SETTINGS = new List<String>{
    'LatitudeRatesv3__c'
  };

  @isTest
  static void testSave() {
    Test.startTest();
    String approvalType = 'NONE';
    Map<String, Application_Quoting_Result__c> res = new Map<String, Application_Quoting_Result__c>();
    Application_Quoting__c appQuote = buildAppQuote();
    Application_Quoting_Result__c appQuoteResult = QuoteControllerTest.buildAppQuoteResult(
      appQuote.Id
    );
    res.put('commissions', appQuoteResult);
    QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
    param.data = appQuote;
    param.results = res;
    QuoteLibertyCalcController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuoteLibertyCalcController.save(param, approvalType);

    try {
      QuoteLibertyCalcController.save(null, approvalType);
    } catch (GenericException ex) {
    }

    test.stopTest();
  }

  @isTest
  static void testQuotingData() {
    Application_Quoting__c app = buildAppQuote();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    QuoteController.QuotingDataParam param = QuoteControllerTest.buildQuotingDataParam(
      opp.Id,
      LENDER_QUOTING,
      LENDER_SETTINGS
    );
    Test.startTest();
    QuoteLibertyCalcController.getQuotingData(param);
    test.stopTest();
  }

  // --------------------
  // Supporting functions
  // --------------------
  
  private static Application_Quoting__c buildAppQuote() {
    Application_Quoting__c q = QuoteControllerTest.buildAppQuoting();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(false);
    Application__c app = Test_DataGeneratorHelper.buildCarApp(false);

    q.Opportunity__c = opp.id;
    q.Application__c = app.id;
    q.Name = LENDER_QUOTING;

    q.PPSR__c = 8.0;
    q.Registration_Fee__c = 0.0;

    insert q;
    return q;
  }
}