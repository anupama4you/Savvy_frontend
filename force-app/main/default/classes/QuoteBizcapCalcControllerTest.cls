@isTest(SeeAllData=true)
public class QuoteBizcapCalcControllerTest {
  
  private final static String LENDER_QUOTING = 'Bizcap';
  private final static List<String> LENDER_SETTINGS = new List<String>{
    'Bizcap'
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
    QuoteBizcapCalcController.Wrapper param = new QuoteBizcapCalcController.Wrapper();
    param.data = appQuote;
    param.brokerageInc = 1000.00;
    param.brokerageExc = 1100.00;
    QuoteBizcapCalcController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuoteBizcapCalcController.save(param, approvalType);

    try {
      QuoteBizcapCalcController.save(null, approvalType);
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
    QuoteBizcapCalcController.getQuotingData(param);
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

    insert q;
    return q;
  }
}