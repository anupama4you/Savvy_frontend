@isTest(SeeAllData=true)
public class QuotePlentiControllerTest {
  
  private final static String LENDER_QUOTING = 'RateSetter';
  private final static List<String> LENDER_SETTINGS = new List<String>{
    'RateSetterRate__c'
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
    QuotePlentiController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuotePlentiController.save(param, approvalType);

    try {
      QuotePlentiController.save(null, approvalType);
    } catch (GenericException ex) {
    }

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

    q.Loan_Facility_Type__c = 'Prime Plus';

    insert q;
    return q;
  }
}