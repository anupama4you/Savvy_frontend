@isTest(SeeAllData=true)
public class TestQuotingToolHelper {
	
    public static testMethod void generalTest() {
     	
        Custom_Opportunity__c opp = new Custom_Opportunity__c();
        opp.Name = 'T';
        insert opp;
        
        String oppId = opp.Id;
        Blob body = Blob.valueOf('testing functionality');
        
        
		System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('Servicing_Cal'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('YTD_'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('AssetDetails_'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('App_PRE_APPROVAL'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('PreliminaryAssessment'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('PRE_APPROVAL'));
        System.debug(QuotingToolHelper.getDocumentTypeFromPrefixName('FORMAL_APPROVAL'));
        
        QuotingToolHelper.removePreviousInsurances(oppId);
        
        QuotingToolHelper.attachPdfFile(oppId, 'prefixName', body, false);
        
        Test.startTest();
        QuotingToolHelper.attachPdfFile(oppId, 'PreliminaryAssessment', body, true);
        QuotingToolHelper.attachFile(oppId, 'PreliminaryAssessment', body, 'plain/txt', true);
        QuotingToolHelper.attachFile(oppId, 'App_PRE_APPROVAL', body, 'plain/txt', false);
        QuotingToolHelper.attachFile(oppId, 'LeadServicingCal_XXX', body, 'plain/txt', false);
        Test.stopTest();
        /*
        Test.startTest();
        QuotingToolHelper.attachFile(oppId, QuotingToolHelper.getDocumentTypeFromPrefixName('App_PRE_APPROVAL'), body, 'plain/txt', true);
        Test.stopTest();
        Test.startTest();
        QuotingToolHelper.attachFile(oppId, 'prefixName', body, 'plain/txt', false);
        Test.stopTest();
        */
        
		QuotingToolHelper.getSelectStateOptionsOptions();
        QuotingToolHelper.getSelectYesNoOptions();
        QuotingToolHelper.getSelectVehicleGroupTypeOptions();
        QuotingToolHelper.getSelectGabLevelOptions();
        QuotingToolHelper.getSelectWarrantyLevelOptions();
        QuotingToolHelper.getSelectLtiLevelOptions();
        QuotingToolHelper.getSelectTruckGapLevelOptions();
        QuotingToolHelper.getSelectTaiLevelOptions();
        QuotingToolHelper.getSelectMvLevelOptions();
        QuotingToolHelper.getSelectProductLoanLevelOptions();
        QuotingToolHelper.getSelectPaymentTypeOptions();
        
        QuotingToolHelper.getLoanTypeOptions();
        QuotingToolHelper.getLoanProductOptions();
        
        QuotingToolHelper.getApplicationQuoting(oppId);
        
        
        
        CloudDocsHelper.deleteCloudDocument(oppId, 'documentType');
        

        QuotingToolHelper.getLoanFrequenciesOptions('Chattel');
        QuotingToolHelper.getLoanFrequenciesOptions('ChattelXXX');

        QuotingToolHelper.getProductGoodsTypeOptions('Consumer');        
        QuotingToolHelper.getProductGoodsTypeOptions('ConsumerXXX');

        QuotingToolHelper.getLoanProductOptionsConsumer();
        QuotingToolHelper.getLoanProductOptionsCommercial();

        QuotingToolHelper.getProductGoodsSubTypeOptions('Consumer','Car');

        QuotingToolHelper.getNationalWarrantyCost('A', '12');


        //Preparing data
        Test_DataGeneratorHelper.createQuoting();
        Id quotingId = Test_DataGeneratorHelper.quoting.Id;

        Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
        quoting.Application__c = Test_DataGeneratorHelper.tstApp.Id; 
        QuotingToolHelper.saveApplicationQuoting(quoting);
        QuotingToolHelper.getApplicationQuotingIdByAppId(Test_DataGeneratorHelper.tstApp.Id);
        
        QuotingToolHelper.validateInsuranceProduct(null);
        QuotingToolHelper.validateInsuranceProduct('Pepper MV');
        QuotingToolHelper.getLibertyLPIOptions('SA');
        QuotingToolHelper.getLibertyLPIMap('SA');
        QuotingToolHelper.getLibertyLPISetting('SA', 'Life Only');
        QuotingToolHelper.getStateStampDuty('SA');

        QuotingToolHelper.getLibertyVEISetting('SA', 'Option 1');

        //RateSetter 
        List<Integer> terms = new List<Integer>();
        terms.add(6);
        terms.add(9);
        terms.add(12);
        terms.add(18);
        terms.add(24);
        terms.add(36);
        terms.add(48);
        terms.add(36);
        terms.add(60);
        for (Integer a : terms) {
            QuotingToolHelper.getRateSetterPLMonthlyfee(20000.0, a);
            QuotingToolHelper.getRateSetterPLDOF(20000.0, a);
            QuotingToolHelper.getRateSetterPLAppfee(20000.0, a);
        }
        //
        
        //Now Finance
        QuotingToolHelper.getNowFinanceMaxDOF(20000);

        QuotingToolHelper.getMonthlyRepayment(oppId);

        //
        QuotingToolHelper.getFinanceOneConsumerOptions();
        QuotingToolHelper.getFinanceOneCommercialOptions();

        QuotingToolHelper.isForcedCalculation(oppId);

        QuotingToolHelper.getVehicleYears(20);

        //
        QuotingToolHelper.getPartnerUrlCalc(oppId, 'Opp Name', 'calc-page');
        QuotingToolHelper.getLoanTypeOptionsNoLease();
    }
    
    @isTest
	static void updateProduct() {
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
        	//QuotingToolHelper.updateProduct(Test_DataGeneratorHelper.tstOpportunity, 'Prospa', 0.0);
        	QuotingToolHelper.updateProduct(Test_DataGeneratorHelper.tstOpportunity);
        Test.stopTest();
	}
}