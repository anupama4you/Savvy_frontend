@isTest(SeeAllData=true)
private class TestInsuranceQuoteWS {
	
	@isTest static void testQuote() {
		
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		Test_DataGeneratorHelper.reloadOpportunity();
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		quote.Vehicle_Location_Postcode__c = 5000;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Total_assist_RTI__c = 'SWNRTI01';
		quote.Warranty_Insurance__c = 'MVW5SA36';
		quote.Odometer__c = 125000;
		quote.Vehicle_Been_Registered__c = true;
		quote.Has_Additional_Driver__c = true;
		quote.Has_Motoring_Offences__c = true;
		quote.Has_Licence_Santioned__c = true;
		quote.Has_Accident_History__c = true;
		quote.Other_Info_Question_1__c = true;
		quote.Other_Info_Details_1__c = 'Details';
		quote.Other_Info_Question_2__c = true;
		quote.Other_Info_Details_2__c = 'Details';

		update quote;

		InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = quote;
		param.quoting = Test_DataGeneratorHelper.quoting;

		Test.startTest();
		Test.setMock(WebServiceMock.class, new servicesFastrComAuQuotationMockImpl());

		InsuranceQuoteWS.getQuote(param);

		InsuranceQuoteWS.getDate(10, 10, 2017);

	}

	@isTest static void testQuoteFakeResponse() {
		
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		Test_DataGeneratorHelper.reloadOpportunity();
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		quote.Vehicle_Location_Postcode__c = 5000;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Total_assist_RTI__c = 'SWNRTI01';
		quote.Warranty_Insurance__c = 'MVW5SA36';
		quote.Odometer__c = 125000;
		quote.Vehicle_Been_Registered__c = true;
		quote.Has_Additional_Driver__c = true;
		quote.Has_Motoring_Offences__c = true;
		quote.Has_Licence_Santioned__c = true;
		quote.Has_Accident_History__c = true;
		quote.Other_Info_Question_1__c = true;
		quote.Other_Info_Details_1__c = 'Details';
		quote.Other_Info_Question_2__c = true;
		quote.Other_Info_Details_2__c = 'Details';

		update quote;

		InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = quote;
		param.quoting = Test_DataGeneratorHelper.quoting;

		Test.startTest();
		Test.setMock(WebServiceMock.class, new servicesFastrComAuQuotationMockImpl2());

		InsuranceQuoteWS.getQuote(param);

		InsuranceQuoteWS.getDate(10, 10, 2017);

	}

	@isTest static void testFinalQuote() {
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		Test_DataGeneratorHelper.reloadOpportunity();
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		quote.Vehicle_Location_Postcode__c = 5000;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Total_assist_RTI__c = 'SWNRTI01';
		quote.Warranty_Insurance__c = 'MVW5SA36';
		quote.Odometer__c = 125000;
		quote.Vehicle_Been_Registered__c = true;
		quote.Has_Additional_Driver__c = true;
		quote.Has_Motoring_Offences__c = true;
		quote.Has_Licence_Santioned__c = true;
		quote.Has_Accident_History__c = true;
		quote.Other_Info_Question_1__c = true;
		quote.Other_Info_Details_1__c = 'Details';
		quote.Other_Info_Question_2__c = true;
		quote.Other_Info_Details_2__c = 'Details';

		quote.MV_Acceptance__c = 'A';
		quote.GAP_Acceptance__c = 'A';
		quote.TAS_Acceptance__c = 'A';
		quote.LTI_Acceptance__c = 'A';
		quote.WRR_Acceptance__c = 'A';

		update quote;

		InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = quote;
		param.quoting = Test_DataGeneratorHelper.quoting;

		Test.startTest();
		Test.setMock(WebServiceMock.class, new servicesFastrComAuQuotationMockImpl());

		InsuranceQuoteWS.getFinalQuote(param);
	}
	
	@isTest static void testPresentingQuote() {
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		Test_DataGeneratorHelper.reloadOpportunity();
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		quote.Vehicle_Location_Postcode__c = 5000;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Total_assist_RTI__c = 'SWNRTI01';
		quote.Warranty_Insurance__c = 'MVW5SA36';
		quote.Odometer__c = 125000;
		quote.Vehicle_Been_Registered__c = true;
		quote.Has_Additional_Driver__c = true;
		quote.Has_Motoring_Offences__c = true;
		quote.Has_Licence_Santioned__c = true;
		quote.Has_Accident_History__c = true;
		quote.Other_Info_Question_1__c = true;
		quote.Other_Info_Details_1__c = 'Details';
		quote.Other_Info_Question_2__c = true;
		quote.Other_Info_Details_2__c = 'Details';

		quote.MV_Acceptance__c = 'A';
		quote.GAP_Acceptance__c = 'A';
		quote.TAS_Acceptance__c = 'A';
		quote.LTI_Acceptance__c = 'A';
		quote.WRR_Acceptance__c = 'A';

		update quote;

		InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = quote;
		param.quoting = Test_DataGeneratorHelper.quoting;
		param.isPresenting = true;

		Test.startTest();
		Test.setMock(WebServiceMock.class, new servicesFastrComAuQuotationMockImpl());
		InsuranceQuoteWS.getPresentingQuote(param);
	}

	@isTest static void testBuyPolicy() {
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		Test_DataGeneratorHelper.reloadOpportunity();
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;

		//Payment methods
		List<Application_Payment_Method__c> methodList = new List<Application_Payment_Method__c>();
		Application_Payment_Method__c p = new Application_Payment_Method__c();
		p.Application__c = Test_DataGeneratorHelper.tstApp.Id;
		p.Method__c = 'BA';
		p.Holder_Name__c = 'My Name';
		p.Account_Number__c = '123456';
		p.BSB_Number__c = '015010';
		methodList.add(p);

		p = new Application_Payment_Method__c();
		p.Application__c = Test_DataGeneratorHelper.tstApp.Id;
		p.Method__c = 'CC';
		p.Holder_Name__c = 'My Name';
		p.Credit_Card_Number__c = '1234567890123456';
		p.Verification_Code__c = '123';
		p.Expiry_Month__c = '01';
		p.Expiry_Year__c = String.valueOf(Date.today().year() + 3);
		methodList.add(p);

		insert methodList;


		quote.Vehicle_Location_Postcode__c = 5000;
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP01';
		quote.LTI_BRI__c = 'SWNPLT';
		quote.Total_assist_RTI__c = 'SWNRTI01';
		quote.Warranty_Insurance__c = 'MVW5SA36';
		quote.Odometer__c = 125000;
		quote.Vehicle_Been_Registered__c = true;
		quote.Has_Additional_Driver__c = true;
		quote.Has_Motoring_Offences__c = true;
		quote.Has_Licence_Santioned__c = true;
		quote.Has_Accident_History__c = true;
		quote.Other_Info_Question_1__c = true;
		quote.Other_Info_Details_1__c = 'Details';
		quote.Other_Info_Question_2__c = true;
		quote.Other_Info_Details_2__c = 'Details';

		quote.MV_Acceptance__c = 'A';
		quote.GAP_Acceptance__c = 'A';
		quote.TAS_Acceptance__c = 'A';
		quote.LTI_Acceptance__c = 'A';
		quote.WRR_Acceptance__c = 'A';

		quote.Quotation_Number__c = 'Q12345678';
		quote.GAP_Payment_Method__c = 'CREDITCARD';
		quote.GAP_Payment_Detail__c = methodList.get(1).Id;
		quote.LTI_Payment_Method__c = 'PREMFUND12BA';
		quote.LTI_Payment_Detail__c = methodList.get(0).Id;
		quote.TAS_Payment_Method__c = 'FINANCECOMPANY';
		quote.MV_Payment_Method__c = 'FINANCECOMPANY';
		quote.WRR_Payment_Method__c = 'FINANCECOMPANY';

		update quote;

		List<InsuranceQuoteUtils.PaymentMethodDTO> methodDTOList = new List<InsuranceQuoteUtils.PaymentMethodDTO>();
		methodDTOList.add(new InsuranceQuoteUtils.PaymentMethodDTO(1, methodList.get(0)));
		methodDTOList.add(new InsuranceQuoteUtils.PaymentMethodDTO(2, methodList.get(1)));

		InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = quote;
		param.quoting = Test_DataGeneratorHelper.quoting;
		param.paymentMethods = methodDTOList;

		Test.startTest();
		Test.setMock(WebServiceMock.class, new servicesFastrComAuPaymentMockImpl());

		InsuranceQuoteWS.buyPolicy(param);

	}		
}