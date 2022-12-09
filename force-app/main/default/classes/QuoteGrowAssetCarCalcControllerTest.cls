@isTest(SeeAllData=true)
public class QuoteGrowAssetCarCalcControllerTest {
  
  private final static String LENDER_QUOTING = 'Grow Asset';
  private final static List<String> LENDER_SETTINGS = new List<String>{
    'gacTier1', 'gacTier2', 'gacTier3', 'gacAdd'
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
    QuoteGrowAssetCarCalcController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuoteGrowAssetCarCalcController.save(param, approvalType);

    try {
      QuoteGrowAssetCarCalcController.save(null, approvalType);
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
    QuoteGrowAssetCarCalcController.getQuotingData(param);
    // QuotingCalculation.CalcParam p = new QuotingCalculation.CalcParam(LENDER_QUOTING);
    // QuoteGrowAssetCarCalcController.getBaseRates(P);
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