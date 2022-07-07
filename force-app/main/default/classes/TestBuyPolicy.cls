@isTest(SeeAllData=true)
private class TestBuyPolicy {
	
	@isTest static void finalRequest() {
		test.startTest();
		//Records
		Test_DataGeneratorHelper.createApplication();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.reloadOpportunity();
		Test_DataGeneratorHelper.createQuote();
		Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quote.Status__c = 'Q';
        update quote;
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = quote.Id;
        update Test_DataGeneratorHelper.quoting;
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Additional_Driver__c mainDriver = Test_DataGeneratorHelper.mainDriver;


        List<Insurance_Quote_Annotation__c> qAnns = new List<Insurance_Quote_Annotation__c>();
        Insurance_Quote_Annotation__c qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
        qa.Driver__c = mainDriver.Id;
        qa.Insurance_Quote__c = quote.Id;
        qa.Date__c = Date.today();
        qAnns.add(qa);
        qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
        qa.Driver__c = mainDriver.Id;
        qa.Insurance_Quote__c = quote.Id;
        qa.Date__c = Date.today();
        qAnns.add(qa);
        qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
        qa.Driver__c = mainDriver.Id;
        qa.Insurance_Quote__c = quote.Id;
        qa.Date__c = Date.today();
        qAnns.add(qa);

        insert qAnns;


		//- Initial test
		//View
		PageReference pRef = Page.InsuranceBuyPolicyStep1;
		pRef.getParameters().put('id', o.Id);
        Test.setCurrentPageReference(pRef);
        //Controller
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        InsuranceBuyPolicyStep1Extension ctrl = new InsuranceBuyPolicyStep1Extension(sc);
        
        ctrl.getStepNumber();
        ctrl.getSectionName();
        ctrl.goToQuotingTool();
        

        ctrl.o.Application__r.Unit_Number__c = '123';
        ctrl.o.Application__r.Street_Type__c = 'AVE';
        ctrl.o.Application__r.Current_Work_Unit_Number_1__c = '123';
        ctrl.o.Application__r.Current_Work_Street_Type_1__c = 'BVD';
        ctrl.o.Application__r.Current_Work_Suburb_1__c = 'BVD';
        ctrl.o.Application__r.Current_Work_State_1__c = 'SA';
        ctrl.o.Application__r.Current_Work_Postcode_1__c = '5000';
        ctrl.copyResidentialAddress();
        ctrl.copyWorkingAddress();
        
        ctrl.removeMotoringOffence();
        ctrl.removeLicenceSanctioned();
        ctrl.removeAccidentHistory();

        ctrl.removePaymentMethod();
        ctrl.addPaymentMethod();
        ctrl.savePaymentMethod();

        ctrl.getMVPaymentMethodOptions();
        ctrl.getGapPaymentMethodOptions();
        ctrl.getTasPaymentMethodOptions();
        ctrl.getLtiPaymentMethodOptions();
        ctrl.getLpiPaymentMethodOptions();
        ctrl.getWrrPaymentMethodOptions();

        ctrl.getRequireMVPaymentDetail();
        ctrl.getRequireGAPPaymentDetail();
        ctrl.getRequireTASPaymentDetail();
        ctrl.getRequireLTIPaymentDetail();
        ctrl.getRequireLPIPaymentDetail();
        ctrl.getRequireWRRPaymentDetail();

        ctrl.getCredidCardYearOptions();

        ctrl.performFullAssessment();
        

        //Step 1
        ctrl.nextAction();	
        ctrl.quote.Cover_Start_Date__c = Date.today().addDays(-10);
        ctrl.quote.WRR_Acceptance__c = 'A';
        //update quote;
        ctrl.nextAction();	
        ctrl.quote.Cover_Start_Date__c = Date.today().addDays(10);
        ctrl.quote.Vehicle_Under_Warranty__c = 'Y';
        //update quote;
		ctrl.nextAction();	
		ctrl.quote.Vehicle_Warranty_End_Date__c = Date.today().addDays(-10);
        //update quote;
		ctrl.nextAction();	
		ctrl.quote.Vehicle_Warranty_End_Date__c = Date.today().addDays(10);
		ctrl.nextAction();	
		
		ctrl.setStepNumber(2);
		ctrl.mainDriver.Health_Info_Question_1__c = 'Y';
		ctrl.nextAction();	
		ctrl.setStepNumber(2);
		ctrl.mainDriver.Health_Full_Details__c = 'XXXXXXXXX';
		ctrl.nextAction();
		ctrl.setStepNumber(2);
		ctrl.mainDriver.First_Name__c = null;
		ctrl.mainDriver.Last_Name__c = null;
		ctrl.mainDriver.Registered_for_GST__c = true;
		ctrl.mainDriver.Address_Line_1__c = null;
		ctrl.mainDriver.Health_Info_Question_1__c = null;
		ctrl.nextAction();
		ctrl.mainDriver.First_Name__c = 'xxx';
		ctrl.mainDriver.Last_Name__c = 'xxx';
		ctrl.mainDriver.Registered_for_GST__c = false;
		ctrl.mainDriver.Address_Line_1__c = 'xxxxx';
		ctrl.mainDriver.Health_Info_Question_1__c = 'Y';


		ctrl.setStepNumber(3);
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		//Aditional Drivers
		Application_Additional_Driver__c addDriver = new Application_Additional_Driver__c();
		addDriver.Application__c = quote.Application__c;
		insert addDriver;
		ctrl.additionalDrivers.add(new InsuranceQuoteUtils.AddtionalDriver(1, addDriver));
		ctrl.quote.Has_Additional_Driver__c = true;
		ctrl.getDriverOptions();
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		ctrl.quote.Has_Motoring_Offences__c = true;
		ctrl.quote.Has_Licence_Santioned__c = true;
		ctrl.quote.Has_Accident_History__c = true;
		ctrl.motoringOffences.clear();
		ctrl.licenceSantioned.clear();
		ctrl.accidentHistory.clear();
		ctrl.activateMotoringOffence();
        ctrl.activateLicenceSanctioned();
        ctrl.activateAccidentHistory();
        ctrl.addMotoringOffence();
        ctrl.addLicenceSanctioned();
        ctrl.addAccidentHistory();
        ctrl.motoringOffences.clear();
		ctrl.licenceSantioned.clear();
		ctrl.accidentHistory.clear();
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		ctrl.loadQuoteAnnotations();
		//Blank
		qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
        ctrl.motoringOffences.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(2, qa));
        qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
        ctrl.licenceSantioned.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(2, qa));
        qa = new Insurance_Quote_Annotation__c();
        qa.RecordTypeId = Test_DataGeneratorHelper.getRecordTypes(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
        ctrl.accidentHistory.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(2, qa));
        ctrl.quote.Other_Info_Question_1__c = true;
        ctrl.quote.Other_Info_Question_2__c = true;
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		//Removing Annotations
		ctrl.quoteAnnotationSelected = 1;
		ctrl.removeMotoringOffence();
		ctrl.removeLicenceSanctioned();
		ctrl.removeAccidentHistory();
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		//All good to save stept3 3
		ctrl.mainDriver.Driver_Licence__c = '12345';
		ctrl.quote.Has_Additional_Driver__c = true;
		for (InsuranceQuoteUtils.AddtionalDriver a : ctrl.additionalDrivers) {
			a.data.First_Name__c = 'aaaa';
			a.data.Last_Name__c = 'aaaa';
			a.data.Driver_Licence__c = '123';
		}
		for (InsuranceQuoteUtils.QuoteAnnotationDTO a : ctrl.motoringOffences) {
			a.data.Driver__c = ctrl.mainDriver.Id;
			a.data.Date__c = Date.today();
			a.data.Detail__c = 'xxxxx';
			a.data.Number__c = 123;
		}
		for (InsuranceQuoteUtils.QuoteAnnotationDTO a : ctrl.licenceSantioned) {
			a.data.Driver__c = ctrl.mainDriver.Id;
			a.data.Date__c = Date.today();
			a.data.Detail__c = 'xxxxx';
			a.data.Number__c = 123;
		}
		for (InsuranceQuoteUtils.QuoteAnnotationDTO a : ctrl.accidentHistory) {
			a.data.Driver__c = ctrl.mainDriver.Id;
			a.data.Date__c = Date.today();
			a.data.Detail__c = 'xxxxx';
			a.data.Amount__c = 123;
			a.data.Is_Driver_Fault__c = 'Y';
			a.data.Was_Vehicle_Affected__c = 'Y';
		}
		ctrl.quote.Other_Info_Details_1__c = 'xxxx';
		ctrl.quote.Other_Info_Details_2__c = 'xxxx';
		ctrl.nextAction();
		ctrl.setStepNumber(3);
		ctrl.quote.Has_Motoring_Offences__c = false;
		ctrl.quote.Has_Licence_Santioned__c = false;
		ctrl.quote.Has_Accident_History__c = false;
		ctrl.quoteAnnotationSelected = 1;
		ctrl.removeMotoringOffence();
		ctrl.removeLicenceSanctioned();
		ctrl.removeAccidentHistory();
		ctrl.nextAction();
		ctrl.saveAction();



		ctrl.setStepNumber(4);
		ctrl.nextAction();
		ctrl.setStepNumber(4);
		ctrl.quote.Has_Existing_Damage__c = true;
		ctrl.quote.Existing_Damage_Details__c = null;
		ctrl.nextAction();
		ctrl.quote.Existing_Damage_Details__c = 'XXXXXXXX';

		ctrl.setStepNumber(5);
		ctrl.nextAction();	
		ctrl.setStepNumber(5);
		//Acceptance
		ctrl.quote.MV_Acceptance__c = 'A';
		ctrl.quote.GAP_Acceptance__c = 'A';
		ctrl.quote.TAS_Acceptance__c = 'A';
		ctrl.quote.LTI_Acceptance__c = 'A';
        ctrl.quote.LPI_Acceptance__c = 'A';
		ctrl.quote.WRR_Acceptance__c = 'A';
		//Payment Method Blank
		ctrl.quote.MV_Payment_Method__c = null;
		ctrl.quote.GAP_Payment_Method__c = null;
		ctrl.quote.TAS_Payment_Method__c = null;
		ctrl.quote.LTI_Payment_Method__c = null;
        ctrl.quote.LPI_Payment_Method__c = null;
		ctrl.quote.WRR_Payment_Method__c = null;
		//
		ctrl.nextAction();	
		ctrl.setStepNumber(5);
		ctrl.quote.MV_Payment_Method__c = 'CREDITCARD';
		ctrl.quote.GAP_Payment_Method__c = 'CREDITCARD';
		ctrl.quote.TAS_Payment_Method__c = 'CREDITCARD';
		ctrl.quote.LTI_Payment_Method__c = 'CREDITCARD';
        ctrl.quote.LPI_Payment_Method__c = 'CREDITCARD';
		ctrl.quote.WRR_Payment_Method__c = 'CREDITCARD';
		ctrl.nextAction();	
		ctrl.setStepNumber(5);
		ctrl.quote.LTI_Payment_Method__c = 'PREMFUND12CC';
        ctrl.quote.LPI_Payment_Method__c = 'PREMFUND12CC';
		ctrl.nextAction();	

		//Payment Methods
		ctrl.paymentMethods.clear();
		ctrl.isPaymentMethodValid(null);
		ctrl.savePaymentMethod();

		ctrl.addPaymentMethod();
		InsuranceQuoteUtils.PaymentMethodDTO pm = ctrl.paymentMethods.get(0);
		ctrl.isPaymentMethodValid(pm);
		pm.data.Method__c = InsuranceQuoteUtils.CREDIT_CARD_METHOD;
		ctrl.isPaymentMethodValid(pm);
		pm.data.Method__c = InsuranceQuoteUtils.BANK_ACCOUNT_METHOD;
		ctrl.isPaymentMethodValid(pm);
		ctrl.quote.MV_Payment_Method__c = 'CREDITCARD';
		ctrl.getMVPaymentMethodOptions();
		
		pm.data.Method__c = InsuranceQuoteUtils.BANK_ACCOUNT_METHOD;
		pm.data.BSB_Number__c = '1010101';
		pm.data.Account_Number__c = '1010101';
		pm.data.Holder_Name__c = 'holder name';
		ctrl.paymentSelected = 1;
		ctrl.savePaymentMethod();
		ctrl.addPaymentMethod();
		
		ctrl.quote.MV_Payment_Method__c = 'PREMFUND12BA';
		ctrl.getMVPaymentMethodOptions();

		ctrl.quote.MV_Payment_Detail__c = pm.data.Id;
		ctrl.quote.GAP_Payment_Detail__c = pm.data.Id;
		ctrl.quote.TAS_Payment_Detail__c = pm.data.Id;
		ctrl.quote.LTI_Payment_Detail__c = pm.data.Id;
        ctrl.quote.LPI_Payment_Detail__c = pm.data.Id;
		ctrl.quote.WRR_Payment_Detail__c = pm.data.Id;
		ctrl.paymentSelected = 1;
		ctrl.removePaymentMethod();

        //Extra
        ctrl.saveAction();
        //ctrl.previousAction();

        ctrl.invokeWS();

        //- Sending STPE Parameter
		//View
		pRef = Page.InsuranceBuyPolicyStep1;
		pRef.getParameters().put('id', o.Id);
		pRef.getParameters().put('STEP', '20');
        Test.setCurrentPageReference(pRef);
        //Controller
        sc = new ApexPages.StandardController(o);
        ctrl = new InsuranceBuyPolicyStep1Extension(sc);

        ctrl.setStepNumber(1);
        ctrl.getSectionName();
        ctrl.setStepNumber(2);
        ctrl.getSectionName();
        ctrl.setStepNumber(3);
        ctrl.getSectionName();
        ctrl.setStepNumber(4);
        ctrl.getSectionName();
        ctrl.setStepNumber(5);
        ctrl.getSectionName();
        ctrl.setStepNumber(6);
        ctrl.getSectionName();

        ctrl.previousAction();

        // Lelo 		2018-02-16
        ctrl.buyPolicy();
        ctrl.invokePaymentWS();

        ctrl.downloadMvPolicyDocument();
        ctrl.downloadGapPolicyDocument();
        ctrl.downloadLtiPolicyDocument();
        ctrl.downloadLpiPolicyDocument();
        ctrl.downloadWarrantyPolicyDocument();
        ctrl.downloadRtiPolicyDocument();

        ctrl.getGapPolicy();
        ctrl.getLtiPolicy();
        ctrl.getLpiPolicy();
        ctrl.getRtiPolicy();
        ctrl.getMvPolicy();
        ctrl.getWarrPolicy();

        ctrl.getQuoteStatus();

	}
	
	
}