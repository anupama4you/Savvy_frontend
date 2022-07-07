@isTest(SeeAllData=true)
private class TestApprovalSummaryTmpl {
	
	@isTest static void test_method_one() {
		Test_DataGeneratorHelper.createApplication();
		Test_DataGeneratorHelper.createPreviousEmployment();
		Test_DataGeneratorHelper.createAssets();

		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        YTD_Income__c o = new YTD_Income__c();
        o.Applicant_Type__c = YTDCalculatorExtension.APPTYPE_1;
        o.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert o;
        ApprovalSummaryTmplExtension ctr = new ApprovalSummaryTmplExtension(sc);
        ctr.getAssetDetail();
        ctr.getQuoting();

        ApplicationExtraDataHelper.addPlainData(Test_DataGeneratorHelper.tstApp.Id, 'name', 'Notes', 'obj', true, 'Lender');
		ApplicationExtraDataHelper.addPlainData(Test_DataGeneratorHelper.tstApp.Id, 'name', 'Notes', 'obj', true, 'Processing');
		ApplicationExtraDataHelper.upsertData(Test_DataGeneratorHelper.tstApp.Id, 'name', 'Asset Detail - LTV (Pre-approval)', new AssetDetailsDTO(), true);
		ApplicationExtraDataHelper.upsertData(Test_DataGeneratorHelper.tstApp.Id, 'name', 'Asset Detail - LTV (Amendment)', new AssetDetailsDTO(), true);
		ApplicationExtraDataHelper.upsertData(Test_DataGeneratorHelper.tstApp.Id, 'name', 'Asset Detail - LTV (Formal Approval)', new AssetDetailsDTO(), true);
		ctr = new ApprovalSummaryTmplExtension(sc);
        ctr.getAssetDetail();
        ctr.getQuoting();

        ctr.getPrevEmployApp1();
        ctr.getPrevEmployApp2();
        AppEmploymentList a = new AppEmploymentList();
        a.applicant = '1';
        Decimal b = ctr.otherAssetsTotal;
        ctr.getIncomesApp1();
        ctr.getIncomesApp2();
        ctr.getAssetLoanList();
        
        ctr.getYTDincomesApp1();
        ctr.getYTDincomesApp2();
        ctr.getYTDincomesApp1SecondJob();
        ctr.getYTDincomesApp2SecondJob();
	}
		
}