@isTest
private class QuoteGreenLightControllerTest {
    @testSetup static void setup() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.createOpportunity();
    }
    
    private static QuotingCalculation.CalcParam getParams(){
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.vehiclePrice = 500000.00;
        param.netDeposit = 50000.00;
        param.brokeragePer = 8;
        param.lender = 'Green Light';
        param.hasMaxRate = true;
        param.vehicleYear = '2022';
        param.clientTier = 'Gold';
        return param;
    }

    @isTest static void getQuotingTestMethod() {
        QuoteController.QuotingDataParam param = new QuoteController.QuotingDataParam();
        List<String> fields = new List<String>();
        fields.add('Loan_Type__c');
        fields.add('Loan_Product__c');
        param.oppId = [SELECT Id FROM Custom_Opportunity__c LIMIT 1 ].Id;
        param.fields = fields;
        param.rateSettings = new List<String>{'GreenLightRates__c'};
        test.startTest();
        QuoteController.AppQuotingWraper res = QuoteGreenLightController.getQuotingData(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getFeesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        QuoteGreenLightController.lenderSettingsWrapper lender = new QuoteGreenLightController.lenderSettingsWrapper();
        lender.applicationFee = 500;
        lender.dof = 400;
        test.startTest();
        Map<String, Decimal> res = QuoteGreenLightController.getFees(param, lender, false);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getBaseRatesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Map<String, Decimal> res = QuoteGreenLightController.getBaseRates(param, false);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void calcRepaymentsTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        param.amountBaseComm = QuoteGreenLightController.getNafValidation(QuotingCalculation.CALC_QUOTING, param, true);
        test.startTest();
        Application_Quoting_Result__c res = QuoteGreenLightController.calculateRepayments(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getGreenlightTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        List<GreenLightRates__c> res = QuoteGreenLightController.getGreenlight(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }


  private final static String LENDER_QUOTING = 'Green Light';
  
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
    QuoteGreenLightController.save(param, approvalType);
    approvalType = 'PRE-APPROVAL';
    QuoteGreenLightController.save(param, approvalType);

    try {
      QuoteGreenLightController.save(null, approvalType);
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