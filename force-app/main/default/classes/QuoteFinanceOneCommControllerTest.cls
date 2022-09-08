@isTest
private class QuoteFinanceOneCommControllerTest {
    @testSetup static void setup() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.createOpportunity();
        
        FinanceOneRates__c setting = new FinanceOneRates__c();
        setting.Name = 'a';
        setting.Application_Fee__c = 595.00;
        setting.Base_Rate__c = 12.00;
        setting.Max_Rate__c = 14.00;
        setting.Max_Term__c = 84;
        setting.Minimum_Amount__c = 8000;
        setting.Product__c = 'Platinum';
        setting.Product_Base_Rate__c = 'Platinum secured loan';
        setting.Term__c = '36 to 84 Months';
        insert setting;
        
        List<Product_Goods_Subtypes__c> pgsList = new List<Product_Goods_Subtypes__c>();
        pgsList.add(getProductGoodSubType('PGS1', 'Motor Vehicle', 'Hatch', 'hatch'));
        pgsList.add(getProductGoodSubType('PGS2', 'Motorbike', 'Cruiser', 'cruiser'));
        pgsList.add(getProductGoodSubType('PGS3', 'Watercraft', 'Fishing', 'fishing'));
        pgsList.add(getProductGoodSubType('PGS4', 'Recreational Asset', 'Trailer', 'trailer'));
        insert pgsList;
    }
    
    private static Product_Goods_Subtypes__c getProductGoodSubType(string name, string pgsType, string descrip, string value){
        Product_Goods_Subtypes__c pgs = new Product_Goods_Subtypes__c();
        pgs.Name = name;
        pgs.Type__c = pgsType;
        pgs.Value__c = value;
        pgs.Description__c = descrip;
        return pgs;
    }
    
    private static QuotingCalculation.CalcParam getParams(){
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.vehiclePrice = 500000.00;
        param.netDeposit = 50000.00;
        param.loanTypeDetail = 'Gold';
        param.brokeragePer = 8;
        param.lender = 'Finance One Commercial';
        param.hasMaxRate = true;
        param.vehicleYear = '2022';
        param.clientTier = 'Gold';
        param.assetAge = 'New - 6 years old';
        param.clientRate = 12.00;
        param.term = 60;
        param.residualValue = 100;
        param.gst = 'Not Registered';
        return param;
    }
    
    @isTest static void getQuotingTestMethod() {
        QuoteController.QuotingDataParam param = new QuoteController.QuotingDataParam();
        List<String> fields = new List<String>();
        fields.add('Loan_Type__c');
        fields.add('Loan_Product__c');
        param.oppId = [SELECT Id FROM Custom_Opportunity__c LIMIT 1 ].Id;
        param.fields = fields;
        param.rateSettings = new List<string>{'FinanceOneRates__c'};
        test.startTest();
        QuoteController.AppQuotingWraper res = QuoteFinanceOneCommController.getQuotingData(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getGSTTestMethod() {
        List<string> goodsSubTypes = new List<string>{'Motor Vehicle', 'Motorbike', 'Watercraft', 'Recreational Asset'};
        test.startTest();
        Map<String,List<QuoteWrapper.Picklist>> res = QuoteFinanceOneCommController.getGoodsSubTypes(goodsSubTypes);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getRatesTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Map<String, Decimal> res = QuoteFinanceOneCommController.getBaseRates(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getRiskFeeCalcTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Decimal res = QuoteFinanceOneCommController.getRiskFeeCalc(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getDofCalcTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        Map<String, Decimal> res = QuoteFinanceOneCommController.getDofCalcu(param, false);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getFORateTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        test.startTest();
        List<FinanceOneRates__c> res = QuoteFinanceOneCommController.getFinanceOneRate(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void calcRepaymentsTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        param.nafCommission = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        test.startTest();
        Application_Quoting_Result__c res = QuoteFinanceOneCommController.calculateRepayments(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
    
    @isTest static void getAppFeeTestMethod() {
        QuotingCalculation.CalcParam param = getParams();
        param.totalAmount = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        test.startTest();
        Decimal res = QuoteFinanceOneCommController.getApplicationFeeCalc(param);
        system.assertEquals(TRUE, res != null);
        test.stopTest();  
    }
}