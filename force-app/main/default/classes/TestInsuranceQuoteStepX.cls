@isTest(SeeAllData=true)
private class TestInsuranceQuoteStepX {
	
	@isTest static void testStep1() {
		
		initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.Name = 'BOQ';
        update Test_DataGeneratorHelper.quoting;
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
        PageReference pageRef = Page.InsuranceQuoteStep1;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep1Extension ctr = new InsuranceQuoteStep1Extension(sc);
        ctr.displayLTIProduct = true;
        ctr.nextAction();

        ctr.goToQuotingTool();

        Test_DataGeneratorHelper.createAssetDetailLTV();
        Application__c app = Test_DataGeneratorHelper.tstApp;
        app.Status__c = 'F';
        update app;
        Test_DataGeneratorHelper.reloadOpportunity();
		opp = Test_DataGeneratorHelper.tstOpportunity;
		sc = new ApexPages.StandardController(opp);
        ctr = new InsuranceQuoteStep1Extension(sc);        
        
        ctr.nextAction();

        ctr.quote.Gap__c = 'SWNGAP01';
		ctr.quote.LTI_BRI__c = 'SWNPLT';
		ctr.quote.Warranty_Insurance__c = 'MVW5SA12';
		ctr.quote.Motor_Vehicle__c = 'MVCMP';
        ctr.quote.LPI__c = 'CRDU';
		ctr.quote.Vehicle_Been_Registered__c = true;
		ctr.o.Application_AssetDetail__r.VIN__c = null;
		ctr.o.Application_AssetDetail__r.Rego__c = null;
		ctr.o.Application_AssetDetail__r.Rego_State__c = null;
        ctr.displayLTIProduct = true;
		ctr.nextAction();

		ctr.o.Application_AssetDetail__r.VIN__c = '123456';
		ctr.o.Application_AssetDetail__r.Rego__c = 'SDE456';
		ctr.nextAction();

		ctr.o.Application_AssetDetail__r.Rego_State__c = 'SA';
		ctr.nextAction();

		ctr.quote.Status__c = 'Q';
		ctr.nextAction();

		sc = new ApexPages.StandardController(opp);
        ctr = new InsuranceQuoteStep1Extension(sc);

        ctr.initialValidation();

        ctr.quoting.Name = 'Pepper Leisure';
        update ctr.quoting;
        ctr = new InsuranceQuoteStep1Extension(sc);

        ctr.quoting.Name = 'Liberty Drive';
        update ctr.quoting;
        ctr = new InsuranceQuoteStep1Extension(sc);

        ctr.quoting.Name = EsandaCalculatorExtension.LENDER_QUOTING;
        update ctr.quoting;
        ctr = new InsuranceQuoteStep1Extension(sc);
        
        ctr.quote.Gap__c = 'SWNGAP01';
        ctr.displayLTIProduct = true;
		ctr.nextAction();
        
        ctr.quoting.Name = 'Macquarie Consumer';
        update ctr.quoting;
        ctr = new InsuranceQuoteStep1Extension(sc);
        ctr.getDisabledLPI();
        
        ctr.quoting.Name = 'CarStart';
        update ctr.quoting;
        ctr = new InsuranceQuoteStep1Extension(sc);
	}
	
    @isTest static void testStep2IsValidForSubmission(){
        initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.reloadOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;

		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Warranty_Insurance__c = 'MVW5SA12';
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Redbook_Key__c = 'AUVAUDI2017AEBE';
		quote.Has_Additional_Driver__c = true;
        quote.Is_Vehicle_Commercial_Usage__c = true;
        update quote;

		PageReference pageRef = Page.InsuranceQuoteStep2;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep2Extension ctr = new InsuranceQuoteStep2Extension(sc);
		
        ctr = new InsuranceQuoteStep2Extension(sc);
        ctr.getIsSelfEmployed();
        ctr.removeLPI();
        ctr.getDisplayLTIProduct();
        ctr.getDisplayLPIProduct();
        ctr.mainDriver.Gender__c = null;
        ctr.mainDriver.Year_First_Licence__c = null;
        ctr.mainDriver.Date_of_Birth__c = null;
        ctr.mainDriver.Title__c = null;
        ctr.o.Application_AssetDetail__r.Actual_KM__c = null;
        ctr.o.Application__r.Mode_of_Employment_1__c = 'Employed';
		ctr.o.Application__r.Mobile_Number__c = '23456';
        ctr.o.Application_AssetDetail__r.Redbook_Key__c = 'AUVAUDI2017AEBE';
        ctr.invokeWS();
        ctr.invokeRestWS();
        ctr.activateAddDriver();
        ctr.addDriver();
        ctr.invokeWS();
        ctr.invokeRestWS();
    }
    
    @isTest static void testStep2InvokeWS(){
        initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.reloadOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;

		quote.LTI_BRI__c = null;
		quote.Motor_Vehicle__c = null;
		quote.Has_Additional_Driver__c = false;
        quote.Warranty_Insurance__c = null;
        update quote;
        
		PageReference pageRef = Page.InsuranceQuoteStep2;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep2Extension ctr = new InsuranceQuoteStep2Extension(sc);
		
        ctr = new InsuranceQuoteStep2Extension(sc);
        //ctr.driverSelected = 3;
        ctr.o.Application__r.Date_Started_1__c = '2019-07-12';
        ctr.o.Application__r.Start_Date_1__c = '2019-07-13';
        ctr.o.Application__r.Finish_Date_1__c = '2019-09-12';
        
        ctr.nextAction();
        ctr.invokeWS();
        ctr.invokeRestWS();
        ctr.previousAction();
        ctr.getIsApplicantEmployed();
        ctr.getIsApplicantFullTimeOrPartTime();
        ctr.getIsEmployed6Months();
        ctr.activateAddDriver();
        ctr.addDriver();
        ctr.removeDriver();
        ctr.getRedbookFamilyOptions();
        ctr.loadRedbookVehicles();
        ctr.loadRedbookBadges();
        ctr.getRedbookBadgeOptions();
        ctr.removeMV();
        ctr.removeRTI();
        ctr.goToQuotingTool();
    }
    
    @isTest static void testStep2NextAction(){
		initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.reloadOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;

		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Warranty_Insurance__c = 'MVW5SA12';
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Redbook_Key__c = 'AUVAUDI2017AEBE';
		quote.Has_Additional_Driver__c = true;
        quote.Is_Vehicle_Commercial_Usage__c = true;
        update quote;
		
        quoting.Vehicle_Price__c = 22000;
        update quoting;
            
		PageReference pageRef = Page.InsuranceQuoteStep2;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep2Extension ctr = new InsuranceQuoteStep2Extension(sc);
		
        ctr = new InsuranceQuoteStep2Extension(sc);
        ctr.o.Application_AssetDetail__r.Redbook_Key__c = 'AUVAUDI2017AEBE';
        ctr.o.Application_AssetDetail__r.Type__c = 'Motorcycle';
        ctr.o.Application_AssetDetail__r.Make__c = 'AUD';
        ctr.o.Application_AssetDetail__r.Year__c = 2017;
        ctr.nextAction();
    }
    
    /*
    @isTest static void testStep2QuoteNull(){
        initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.reloadOpportunity();
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        
		PageReference pageRef = Page.InsuranceQuoteStep2;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep2Extension ctr = new InsuranceQuoteStep2Extension(sc);
		
        ctr = new InsuranceQuoteStep2Extension(sc);
        ctr.driverSelected = 1;
        ctr.activateAddDriver();
        ctr.addDriver();
        ctr.removeDriver();

		System.ListException: List index out of bounds: 0
		Class.InsuranceQuoteStep2Extension.removeDriver: line 463, column 1
		Class.TestInsuranceQuoteStepX.testStep2QuoteNull: line 180, column 1
    }
	*/
	@isTest static void testStep3() {
		initDataGenerator();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.quote.Status__c = 'Q';
		update Test_DataGeneratorHelper.quote;
		Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

		PageReference pageRef = Page.InsuranceQuoteStep3;
		pageRef.getParameters().put('id', opp.Id);
		Test.setCurrentPageReference(pageRef);

		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        InsuranceQuoteStep3Extension ctr = new InsuranceQuoteStep3Extension(sc);

        ctr.goToEditCoverTypes();
        ctr.goToEditCoverInformation();
        ctr.goToQuotingTool();
        ctr.importQuote();
        ctr.applyMV();

        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.MV_Premium__c = 900;
		quote.MV_GST__c = quote.MV_Premium__c * 0.1;
		quote.MV_Commission_Percentage__c = 20;
		quote.MV_Establishment_Fee__c = 44;

		quote.MV_Amount_Covered__c = 30000;
		quote.MV_Amount_Covered_Min__c = 20000;
		quote.MV_Amount_Covered_Max__c = 40000;
		quote.MV_Standard_Excess__c = 600;
		quote.MV_Basic_Excess_Options__c = '[600,800,900,1000]';

		quote.MV_Acceptance__c = 'U';
		update quote;
		quoting.App_Insurance_Quote__c = quote.Id;
		update quoting;
		ctr = new InsuranceQuoteStep3Extension(sc);

		ctr.applyMV();
		ctr.getExcessOptions();
		ctr.getMinAmountCovered();
		ctr.getMaxAmountCovered();
		ctr.getVehicleMake();
		// ctr.getVehicleModel();
		// ctr.getVehicleVariant();

		quote.MV_Amount_Covered__c = 10000;
		ctr.applyMV();
		ctr.applyRestMV();
	}	
	
	private static void initDataGenerator() {
		Test_DataGeneratorHelper.createApplication();
	}
}