@isTest(SeeAllData=true)
public class QuoteGroupAndGeneralCalcControllerTest {
  
  private final static String LENDER_QUOTING = 'Group and General';
  private final static List<String> LENDER_SETTINGS = new List<String>{
    'gagRateList1', 'gagRateList2', 'gagRateList3', 
    'gagRateList4', 'gagRateList5', 'gagRateList6'
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
    QuoteGroupAndGeneralCalcController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuoteGroupAndGeneralCalcController.save(param, approvalType);

    try {
      QuoteGroupAndGeneralCalcController.save(null, approvalType);
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
    QuoteGroupAndGeneralCalcController.getQuotingData(param);
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