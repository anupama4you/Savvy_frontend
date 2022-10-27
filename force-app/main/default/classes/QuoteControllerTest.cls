@isTest
public class QuoteControllerTest {
  @isTest
  static void innerClasses() {
    Test.startTest();
    //
    QuoteController.AppQuotingWraper quoObj = new QuoteController.AppQuotingWraper();
    quoObj.data = null;
    quoObj.insurance = null;
    quoObj.results = null;
    quoObj.settings = null;
    quoObj.rateSettings = null;
    quoObj.additionalProcess = null;
    quoObj.calcResults = null;
    quoObj.apiResponses = null;
    quoObj.opp = null;
    quoObj.rawInsuranceParam = null;

    QuoteController.QuotingDataParam quoDataObj = new QuoteController.QuotingDataParam();
    quoDataObj.oppId = null;
    quoDataObj.calcName = null;
    quoDataObj.fields = null;
    quoDataObj.rateSettings = null;

    QuoteController.QuotingResultWraper resultObj = new QuoteController.QuotingResultWraper();
    resultObj.commissions = null;
    resultObj.calResults = null;

    QuoteController.InsuranceParam insObj = buildInsuranceParam();

    Set<String> calcTypes = new Set<String>{
      QuotingCalculation.CALC_QUOTING,
      InsuranceQuoteUtils.INS_PROD_GAP,
      InsuranceQuoteUtils.INS_PROD_WARR,
      InsuranceQuoteUtils.INS_PROD_NWC,
      InsuranceQuoteUtils.INS_PROD_CCI
    };
    for (String ct : calcTypes) {
      insObj.getTotalInsuranceType(ct);
      insObj.getTotalInsuranceIncomeType(ct);
    }

    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void loadData() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    QuoteController.QuotingDataParam quoDataObj = new QuoteController.QuotingDataParam();
    QuoteController.AppQuotingWraper quoObj = null;
    try {
      quoObj = QuoteController.getQuotingData(quoDataObj);
    } catch (GenericException e) {
    }
    quoDataObj.oppId = o.Id;
    quoDataObj.calcName = 'Pepper MV';
    quoDataObj.fields = new List<String>{
      'Loan_Type__c',
      'Loan_Product__c',
      'Goods_type__c',
      'Vehicle_Price__c'
    };

    quoObj = QuoteController.getQuotingData(quoDataObj);

    QuoteController.loadRateSettings(new List<String>{ 'PepperRate__c' });

    // API responses
    QuoteController.getMostRecentApiResponses(o.Id, 'Pepper', 'Pepper MV');

    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void calcBaseRate() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      'Pepper MV'
    );
    QuoteController.getBaseRates(param);
    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void calcRepyaments() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
      'Pepper MV'
    );
    QuoteController.calculateRepayments(param);

    // Insurances
    QuoteController.InsuranceParam insObj = buildInsuranceParam();
    QuoteController.calculateAllRepayments(param, insObj);
    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void saveData() {
    QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
    param.data = buildAppQuoting();
    Test.startTest();
    QuoteController.saveQuoting(param);
    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void savePdf() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
    param.data = buildAppQuoting();
    param.data.Opportunity__c = opp.Id;
    insert param.data;

    Test.startTest();
    PageReference pdf = QuoteController.createPdf(param.data);
    QuoteController.savePdf('APPROVAL', pdf, param);
    QuoteController.savePdf('AMENDMENT', pdf, param);
    QuoteController.savePdf('FORMAL', pdf, param);
    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void saveQuote() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
    param.data = buildAppQuoting();
    param.data.Opportunity__c = opp.Id;
    insert param.data;

    param.rawInsuranceParam = buildInsuranceParam();
    param.rawInsuranceParam.lastAction = 'RE-CREATE';

    Test.startTest();
    QuoteController.sendQuote(param);

    // Send presentation
    param.additionalProcess = new List<String> {'SEND'};
    param.insurance = InsuranceQuoteUtils.createDefaultInsuranceQuote(opp, param.data);
    QuoteController.sendQuote(param);

    // Insurance quote
    QuoteController.getInsuranceQuote(param.data.Id);

    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void saveProducts() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    QuoteController.AppQuotingWraper param = new QuoteController.AppQuotingWraper();
    param.data = buildAppQuoting();
    param.data.Opportunity__c = opp.Id;
    insert param.data;

    Product__c p = buildProduct(param.data);

    Test.startTest();

    Product__c tmp = QuoteController.getProduct(opp.Id);

    QuoteController.saveProduct(param, p);

    p = QuoteController.getProduct(opp.Id);

    QuoteController.saveProduct(param, p);

    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void getOpps() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    
    Test.startTest();

    QuoteController.getOpportunityById(opp.Id);
    QuoteController.getOpportunityById(null);

    QuoteController.getOpportunity(opp.Id, new List<String>{
        'ApplicationServicing__c',
        'ApplicationServicing__r.Is_Splitting_Expenses__c'
      });
    try {
      QuoteController.getOpportunity(opp.Id, new List<String>{
          'NONEXISTINGFIELD__c'
        });
    } catch (Exception e) {}
    QuoteController.getOpportunity(null, null);

    Test.stopTest();
  }



  // --------------------
  // Supporting functions
  // --------------------
  
  public static QuoteController.InsuranceParam buildInsuranceParam() {
    QuoteController.InsuranceParam insObj = new QuoteController.InsuranceParam();
    insObj.mvType = null;
    insObj.mvProduct = null;
    insObj.mvRetailPrice = 1000.00;
    insObj.mvCommission = 100.00;
    insObj.mvPayment = null;
    insObj.mvTerm = null;
    insObj.mvPBM = 'PBM';
    insObj.mvAcceptance = null;
    insObj.shortfallType = null;
    insObj.shortfallProduct = null;
    insObj.shortfallRetailPrice = 1000.00;
    insObj.shortfallCommission = 100.00;
    insObj.shortfallPayment = null;
    insObj.shortfallTerm = null;
    insObj.shortfallPBM = 'Financed';
    insObj.shortfallAcceptance = null;
    insObj.LPIType = null;
    insObj.LPIProduct = null;
    insObj.LPIRetailPrice = 1000.00;
    insObj.LPICommission = 100.00;
    insObj.LPIPayment = null;
    insObj.LPITerm = null;
    insObj.LPIPBM = 'Financed';
    insObj.LPIAcceptance = null;
    insObj.warrantyType = null;
    insObj.warrantyProduct = null;
    insObj.warrantyRetailPrice = 1000.00;
    insObj.warrantyCommission = 100.00;
    insObj.warrantyPayment = null;
    insObj.warrantyTerm = null;
    insObj.warrantyPBM = 'Financed';
    insObj.warrantyAcceptance = null;
    insObj.ismvAccept = true;
    insObj.isshortfallAccept = true;
    insObj.iswarrantyAccept = true;
    insObj.isLPIAccept = true;
    insObj.lastAction = null;

    insObj.integrity = new QuoteController.IntegrityParam();
    insObj.integrity.type = null;
    insObj.integrity.term = null;
    insObj.integrity.category = null;

    return insObj;
  }

  public static Application_Quoting__c buildAppQuoting() {
    Application_Quoting__c q = new Application_Quoting__c();
    q.Name = 'Pepper MV';
    // MV - Insurance
    q.Insurance_MV_Acceptance__c = 'A';
    q.Insurance_MV_Type__c = 'C';
    q.Insurance_MV_Options__c = 'Eric MV';
    q.Insurance_MV_Retail_Price__c = 1000.00;
    q.Insurance_MV_Income__c = 100.00;
    // GAP - Insurance
    q.Insurance_GAP_Acceptance__c = 'A';
    q.Insurance_Shortfall_Options__c = 'Eric EPI';
    q.Insurance_GAP_Type__c = 'Option 1';
    q.Insurance_GAP_Retail_Price__c = 1000.00;
    q.Insurance_GAP_Income__c = 100.00;
    q.Insurance_GAP_PayType__c = 'Financed';
    // LPI - Insurance
    q.Insurance_AIC_Acceptance__c = 'A';
    q.Insurance_LPI_Options__c = 'Eric FPI';
    q.Insurance_AIC_Type__c = 'Option 1';
    q.Insurance_AIC_Retail_Price__c = 1000.00;
    q.Insurance_AIC_Income__c = 100.00;
    q.Insurance_AIC_PayType__c = 'Financed';
    // Warranty - Insurance
    q.Insurance_Warranty_Acceptance__c = 'A';
    q.Insurance_Warranty_Type__c = 'Option 1';
    q.Insurance_Warranty_Retail_Price__c = 1000.00;
    q.Insurance_Warranty_Income__c = 100.00;
    q.Insurance_Warranty_PayType__c = 'Financed';
    // Integrity - Insurance
    q.Insurance_NWC_Acceptance__c = 'A';
    q.Insurance_NWC_TypeP__c = 'Absolute';
    q.Insurance_NWC_Plan__c = 'Plan 1';
    q.Insurance_AIC_Type__c = 'Option 1';
    q.Insurance_NWC_Retail_Price__c = 1000.00;
    q.Insurance_NWC_Income__c = 100.00;
    q.Insurance_NWC_PayType__c = 'Financed';
    q.Insurance_NWC_Is_Manually_Value__c = true;
    q.Insurance_NWC_Term__c = '12';

    // Basic details
    q.Loan_Type__c = 'Purchase';
    q.Loan_Product__c = 'Consumer Loan';
    q.Vehicle_Price__c = 50000.00;
    q.Deposit__c = 4000.00;
    q.Trade_In__c = 3000.00;
    q.Payout_On__c = 2000.00;
    q.Application_Fee__c = 500.00;
    q.DOF__c = 990.00;
    q.PPSR__c = 8.90;
    q.Residual_Value__c = 0.00;
    q.Base_Rate__c = 8.55;
    q.Manual_Max_Rate__c = 10.55;
    q.Client_Rate__c = 9.55;
    q.Term__c = 60;
    q.Payment__c = 'Arrears';
    q.Monthly_Fee__c = 5.00;

    // Commissions
    q.Commission_Estimation__c = 456.78;
    q.Commission_Insurance_Income__c = 500.00;
    q.Commission_DOF__c = 900.00;
    q.Commission_Total_GST_Exc__c = 1500.00;
    q.NAF__c = 47500.00;
    q.Rental__c = 258.36;
    q.Repayment_Monthly__c = 400.00;
    q.Repayment_Fortnightly__c = 200.00;
    q.Repayment_Weekly__c = 100.00;

    return q;
  }

  public static Product__c buildProduct(Application_Quoting__c quote) {
    Id recId = SOQLSingletonQueries.recs().recordTypes.get('Finance');
    Product__c p = new Product__c(
      RecordTypeId = recId,
      Opportunity_Name__c = quote.Opportunity__c
    );
    p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan'
      ? 'Personal Use'
      : 'Business Use';
    p.Lender__c = 'Pepper';
    p.Quoting_Source__c = quote.Name;
    p.Repayment_Regularity__c = 'Monthly';
    p.Loan_Type__c = quote.Loan_Type__c;
    p.Loan_Product__c = quote.Loan_Product__c;
    p.Loan_Type_Detail__c = 'Client Tier ' + quote.Client_Tier__c;
    p.Loan_Term__c = quote.Term__c;
    p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null ||
      quote.Residual_Value__c == 0
      ? 0
      : quote.Residual_Value__c;
    p.Client_Rate__c = quote.Client_Rate__c;
    p.Payments__c = quote.Repayment_Monthly__c > 0
      ? quote.Repayment_Monthly__c
      : 0.00;
    p.Cost_of_Goods__c = quote.Vehicle_Price__c;
    p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c;
    p.DOF__c = quote.DOF__c;
    p.Brokerage__c = quote.Commission_Estimation__c == null
      ? 0
      : quote.Commission_Estimation__c;
    p.Lender_App_Fee__c = quote.Application_Fee__c;
    p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
    return p;
  }

  public static Application_Quoting_Result__c buildAppQuoteResult(
    Id appQuoteId
  ) {
    Application_Quoting_Result__c qr = new Application_Quoting_Result__c();
    qr.Application_Quoting__c = appQuoteId;
    qr.Estimated_Commission__c = 0;
    qr.Insurance_Income__c = 0;
    qr.DOF__c = 1100.0;
    qr.NAF__c = 11611.0;
    qr.Rental__c = 244.86;
    qr.Monthly_Payment__c = 272.86;
    return qr;
  }

  public static QuoteController.QuotingDataParam buildQuotingDataParam(
    Id oppId, String calcName, List<String> rateSettings
  ) {
    QuoteController.QuotingDataParam p = new QuoteController.QuotingDataParam();
    p.oppId = oppId;
    p.calcName = calcName;
    p.fields = new List<String>{
      'Loan_Type__c', 'Loan_Product__c', 'Vehicle_Price__c', 'Deposit__c',
      'Net_Deposit__c', 'Trade_In__c', 'Payout_On__c', 'Application_Fee__c',
      'DOF__c', 'Client_Rate__c', 'Term__c', 'Monthly_Fee__c'
    };
    p.rateSettings = rateSettings;
    return p;
  }
}