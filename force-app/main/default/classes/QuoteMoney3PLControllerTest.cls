@isTest(SeeAllData=true)
private class QuoteMoney3PLControllerTest {

  private final static String LENDER_QUOTING = 'Money3 PL';

  private final static List<String> LENDER_SETTINGS = new List<String>{
    'Money3PL'
  };

    @isTest static void testProfileOnChangeAction(){
        test.startTest();
        Map<String, Application_Quoting_Result__c> res = new Map<String, Application_Quoting_Result__c>();
        Application_Quoting__c appQuote = generateAppQuote();
        Application_Quoting_Result__c appQuoteResult = generateAppQuoteResult(appQuote.Id);
        res.put('commissions', appQuoteResult);
        QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
        param.data = appQuote;
        param.results = res;
        Decimal riskFeeBase = calculateRiskFeeBase(appQuote);
        QuoteMoney3PLController.profileOnChangeAction(param, riskFeeBase);
        test.stopTest();
    }
    @isTest static void testSave(){
        test.startTest();
        String approvalType = 'NONE';
        Map<String, Application_Quoting_Result__c> res = new Map<String, Application_Quoting_Result__c>();
        Application_Quoting__c appQuote = generateAppQuote();
        Application_Quoting_Result__c appQuoteResult = generateAppQuoteResult(appQuote.Id);
        res.put('commissions', appQuoteResult);
        QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
        param.data = appQuote;
        param.results = res;
        QuoteMoney3PLController.save(param, approvalType);
        approvalType = 'PRE-APPROVAL';
        QuoteMoney3PLController.save(param, approvalType);
        test.stopTest();
    }

  @isTest
  static void testQuotingData() {
    Application_Quoting__c app = generateAppQuote();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    QuoteController.QuotingDataParam param = QuoteControllerTest.buildQuotingDataParam(
      opp.Id,
      LENDER_QUOTING,
      LENDER_SETTINGS
    );
    Test.startTest();
    QuoteMoney3PLController.getQuotingData(param);
    test.stopTest();
  }
    
    private static Decimal calculateRiskFeeBase(Application_Quoting__c appQuote) {
        Decimal riskFeeBase = 0;
        riskFeeBase += ((appQuote.Vehicle_Price__c != null?appQuote.Vehicle_Price__c:0)- appQuote.Deposit__c - appQuote.Payout_On__c);
        return riskFeeBase;
    }

    private static Application_Quoting_Result__c generateAppQuoteResult(Id appQuoteId){
        Application_Quoting_Result__c appQuoteRes = new Application_Quoting_Result__c(); 
        appQuoteRes.Application_Quoting__c = appQuoteId;
        appQuoteRes.Estimated_Commission__c = 0;
        appQuoteRes.Insurance_Income__c = 0;
        appQuoteRes.DOF__c = 1100.0;
        appQuoteRes.NAF__c = 11611.0;
        appQuoteRes.Rental__c = 244.86;
        appQuoteRes.Monthly_Payment__c = 272.86;

        return appQuoteRes;
    }

    private static Application_Quoting__c generateAppQuote(){
        Application_Quoting__c appQuote = new Application_Quoting__c(); 
        Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(false);
        Application__c app = Test_DataGeneratorHelper.buildCarApp(false);
        
        appQuote.Opportunity__c = opp.id;
        appQuote.Application__c = app.id;
        appQuote.Name = 'Money3';
        appQuote.Vehicle_Price__c = 12000.0;
        appQuote.Application_Fee__c = 995.0;
        appQuote.DOF__c = 990.0;
        appQuote.Residual_Value__c = 10000.0;
        appQuote.Client_Rate__c = 22;
        appQuote.Base_Rate__c = 22;
        appQuote.Term__c = 36;
        appQuote.Trade_In__c = 1000;
        appQuote.Goods_type__c = 'Car';
        appQuote.Deposit__c = 2100;
        appQuote.Monthly_Fee__c = 28;
        appQuote.Payment__c = 'Arrears';
        appQuote.Customer_Profile__c = 'Personal Finance';
        appQuote.Risk_Fee__c = 0;
        appQuote.Payout_On__c = 500;
        appQuote.Category_Type__c = 'Gold';
        appQuote.Commission_Estimation__c = 0;
        appQuote.Commission_Insurance_Income__c = 0;
        appQuote.Commission_DOF__c = 1100.0;
        appQuote.Commission_Total_GST_Exc__c = 1210.0;
        appQuote.NAF__c = 11611.0;
        appQuote.Rental__c = 244.86;
        appQuote.Repayment_Monthly__c = 272.86;
        appQuote.Repayment_Fortnightly__c = 125.94;
        appQuote.Repayment_Weekly__c = 62.97;
        appQuote.Loan_Type__c = 'Purchase';
        appQuote.Loan_Product__c = 'Consumer Loan';
        appQuote.Loan_Purpose__c = 'haha';

        insert appQuote;
        return appQuote;
    }
}