@istest
public class quoteRacvCalcControllerTest {
    private final static String LENDER_QUOTING = 'Racv';
    private final static List<String> LENDER_SETTINGS = new List<String>{'LatitudeRatesv3__c'};
    @isTest static void main(){
        Application_Quoting__c app = buildAppQuote();
        Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
        QuoteController.QuotingDataParam param = QuoteControllerTest.buildQuotingDataParam(opp.Id,LENDER_QUOTING,LENDER_SETTINGS);
        Test.startTest();
        	QuoteController.AppQuotingWraper wrap = quoteRacvCalcController.getQuotingData(param);
        	List<Racv_Rates__c> racvRateList = quoteRacvCalcController.getRates();
        	Application_Quoting__c appquote = quoteRacvCalcController.save(wrap, 'APPROVAL');
        	quoteRacvCalcController.pdfHandler(appquote);
        	Product__c prod = quoteRacvCalcController.productHandler(appquote);
        test.stopTest();
    }
    
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