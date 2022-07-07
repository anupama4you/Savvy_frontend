@isTest(SeeAllData=true)
private class InsuranceQuoteUtilsTest {
	
	@isTest static void testGeneral() {
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createQuoting();
		Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
		Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
		Id appId = Test_DataGeneratorHelper.tstApp.Id;
		Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
		Test_DataGeneratorHelper.createQuote();
		Id quoteId = quote.Id;
		Id newQuoteId = Test_DataGeneratorHelper.quote.Id;
		Id quotingId = quoting.Id;
		
		Id typeId = null;

		InsuranceQuoteUtils.getLatestApplicationInsuranceQuotes(appId, 1);
		InsuranceQuoteUtils.getMostRecentApplicationInsuranceQuote(appId);
		InsuranceQuoteUtils.getApplicationInsuranceQuoteById(quoteId);
		InsuranceQuoteUtils.getApplicationInsuranceQuoteReceived(appId);
		InsuranceQuoteUtils.getApplicationInsuranceQuotesByAppId(appId);
		InsuranceQuoteUtils.getApplicationInsuranceQuotePrepared(appId);
		InsuranceQuoteUtils.setObsoletePreviousQuotes(appId);

		InsuranceQuoteUtils.getQuoteAddtionalDrivers(quoteId);
		InsuranceQuoteUtils.getApplicationAddtionalDrivers(appId);

		InsuranceQuoteUtils.getUsage(null);
		InsuranceQuoteUtils.getUsage('Personal');
		InsuranceQuoteUtils.getUsageInteger(null);
		InsuranceQuoteUtils.getUsageInteger('Personal');
		
		InsuranceQuoteUtils.isCurrentlyEmployed(null);
		InsuranceQuoteUtils.isCurrentlyEmployed('Employed');

		InsuranceQuoteUtils.isFullTimeOrPartTime(null);
		InsuranceQuoteUtils.isFullTimeOrPartTime('Full Time');

		InsuranceQuoteUtils.isFullTimeOrPartTime('Casual', '01/06/2016');

		InsuranceQuoteUtils.isEmployed6Months(null);
		InsuranceQuoteUtils.isEmployed6Months('01/06/2017');
		InsuranceQuoteUtils.isEmployed6Months('01/06/2016');

		InsuranceQuoteUtils.convertToDate(null);
		InsuranceQuoteUtils.convertToDate('DD/MM/YYYY');
		InsuranceQuoteUtils.convertToDate('14/06/2017');


		InsuranceQuoteUtils.getVehicleCondition(null);
		InsuranceQuoteUtils.getVehicleCondition('new');
		InsuranceQuoteUtils.getVehicleCondition('used');



		InsuranceQuoteUtils.getGender(null);
		InsuranceQuoteUtils.getGender('M');
		InsuranceQuoteUtils.getGender('F');

		InsuranceQuoteUtils.getVehicleType(null);
		InsuranceQuoteUtils.getVehicleType('car');
		InsuranceQuoteUtils.getVehicleType('motorcycle');
		InsuranceQuoteUtils.getVehicleType('caravan');
		InsuranceQuoteUtils.getVehicleType('marine');

		InsuranceQuoteUtils.getFinancierId(null);
		InsuranceQuoteUtils.getFinancierId('xxxx');
		InsuranceQuoteUtils.getFinancierId('ANZ Consumer');

		InsuranceQuoteUtils.convertToDateX(Date.today());
		InsuranceQuoteUtils.convertToDateX('');
		InsuranceQuoteUtils.convertToDateX('14/06/2017');

		InsuranceQuoteUtils.getCommissionPercentage(null);
		InsuranceQuoteUtils.getCommissionPercentage('XXXX');
		InsuranceQuoteUtils.getCommissionPercentage('MVCMP');

		InsuranceQuoteUtils.getProductName(null);
		InsuranceQuoteUtils.getProductName('null');
		InsuranceQuoteUtils.getProductName('MVCMP');


		InsuranceQuoteUtils.getInsuranceCommission(null);
		InsuranceQuoteUtils.getInsuranceCommission('null');
		InsuranceQuoteUtils.getInsuranceCommission('MVCMP');

		InsuranceQuoteUtils.getDetailedVehicleType(null);
		InsuranceQuoteUtils.getDetailedVehicleType('car');
		InsuranceQuoteUtils.getDetailedVehicleType('motorcycle');

		InsuranceQuoteUtils.getFinancierType(null);
		InsuranceQuoteUtils.getFinancierType('Personal');
		InsuranceQuoteUtils.getFinancierType('Business');

        InsuranceQuoteUtils.goToQuotingTool(oppId, 'xxxx');

		Map<String, Id> rtMap = InsuranceQuoteUtils.getRecordTypes();

		InsuranceQuoteUtils.associateMainDriverToQuote(null, null);
		InsuranceQuoteUtils.associateMainDriverToQuote(quoteId, newQuoteId);

		InsuranceQuoteUtils.getMainDriver(null);
		InsuranceQuoteUtils.getMainDriver(quoteId);

		InsuranceQuoteUtils.getAllAdditionalDrivers(null);
		InsuranceQuoteUtils.getAllAdditionalDrivers(quoteId);

		InsuranceQuoteUtils.getAdditionalDriversObj(null);
		InsuranceQuoteUtils.getAdditionalDriversObj(quoteId);

		InsuranceQuoteUtils.getInsuranceQuoteAnnotations(null);
		InsuranceQuoteUtils.getInsuranceQuoteAnnotations(quoteId);

		InsuranceQuoteUtils.getPaymentMethods(null);
		InsuranceQuoteUtils.getPaymentMethods(quoteId);

		InsuranceQuoteUtils.getPaymentDetailType(null);
		InsuranceQuoteUtils.getPaymentDetailType('CREDITCARD');
		InsuranceQuoteUtils.getPaymentDetailType('PREMFUND12BA');

		InsuranceQuoteUtils.importQuoteInQuotingTool(null, null);
		quote.Motor_Vehicle__c = 'MVCMP';
		quote.Gap__c = 'SWNGAP02';
		quote.Total_assist_RTI__c = 'SWNRTI02';
		quote.LTI_BRI__c = 'SWNPRE';
		quote.Warranty_Insurance__c = 'MVW5SA36';
        quote.LPI__c = 'CRDU';
        
        update quote;
        
		InsuranceQuoteUtils.importQuoteInQuotingTool(quoteId, oppId);

		InsuranceQuoteUtils.refreshQuotingProductPremiums(InsuranceQuoteUtils.INS_PROD_MV, quote, quoting);
		InsuranceQuoteUtils.refreshQuotingProductPremiums(InsuranceQuoteUtils.INS_PROD_LTI, quote, quoting);

		// InsuranceQuoteUtils.updateInsProductAcceptance(null, '', '', null);
		InsuranceQuoteUtils.updateInsProductAcceptance(oppId, 'A', 'XXXX', null);			//WRONG ID
		InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'A', QuotingCalculation.PRO_FULLY, null);
		InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'A', QuotingCalculation.PRO_STANDARD, null);
		InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'A', QuotingCalculation.PRO_BASIC, null);
		List<String> custProds = new List<String>();
		custProds.add(InsuranceQuoteUtils.INS_PROD_MV);
		custProds.add(InsuranceQuoteUtils.INS_PROD_GAP);
		custProds.add(InsuranceQuoteUtils.INS_PROD_TAI);
		custProds.add(InsuranceQuoteUtils.INS_PROD_LTI);
		custProds.add(InsuranceQuoteUtils.INS_PROD_WARR);
		custProds.add(InsuranceQuoteUtils.INS_PROD_NWC);
        custProds.add(InsuranceQuoteUtils.INS_PROD_CCI);
		InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'A', QuotingCalculation.PRO_CUSTOM, custProds);
		
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', QuotingCalculation.PRO_FULLY);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', QuotingCalculation.PRO_STANDARD);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', QuotingCalculation.PRO_BASIC);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_MV);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_GAP);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_TAI);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_LTI);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_WARR);
		//InsuranceQuoteUtils.updateInsProductAcceptance(quotingId, 'U', InsuranceQuoteUtils.INS_PROD_NWC);
		
		InsuranceQuoteUtils.getPresentationUrlCode(appId);

		typeId = rtMap.get(InsuranceQuoteUtils.MAIN_DRIVER_TYPE);
		InsuranceQuoteUtils.AddtionalDriver xa = new InsuranceQuoteUtils.AddtionalDriver(typeId);
		xa = new InsuranceQuoteUtils.AddtionalDriver(0, typeId);
		xa = new InsuranceQuoteUtils.AddtionalDriver(0, new Application_Additional_Driver__c());

		typeId = rtMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
		InsuranceQuoteUtils.QuoteAnnotationDTO xq = new InsuranceQuoteUtils.QuoteAnnotationDTO(typeId);
		xq = new InsuranceQuoteUtils.QuoteAnnotationDTO(0, typeId);
		xq = new InsuranceQuoteUtils.QuoteAnnotationDTO(0, new Insurance_Quote_Annotation__c());

		InsuranceQuoteUtils.PaymentMethodDTO xp = new InsuranceQuoteUtils.PaymentMethodDTO(0);
		xp = new InsuranceQuoteUtils.PaymentMethodDTO(0, new Application_Payment_Method__c());

		InsuranceQuoteUtils.ProductDTO xr = new InsuranceQuoteUtils.ProductDTO(0, 'xxxx');
		
		//Eric Settings
		String r = InsuranceQuoteUtils.getAPIKey();
		System.assert(String.isNotBlank(r));
		r = InsuranceQuoteUtils.getEndPoint();
		System.assert(String.isNotBlank(r));
		


		//Constants
		String c = InsuranceQuoteUtils.MAIN_DRIVER_TYPE;
		c = InsuranceQuoteUtils.ADDITIONAL_DRIVER_TYPE;

		c = InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE;
		c = InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE;
		c = InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE;

		c = InsuranceQuoteUtils.CREDIT_CARD_METHOD;
		c = InsuranceQuoteUtils.BANK_ACCOUNT_METHOD;

		c = InsuranceQuoteUtils.INS_PROD_MV;
		c = InsuranceQuoteUtils.INS_PROD_GAP;
		c = InsuranceQuoteUtils.INS_PROD_TAI;
		c = InsuranceQuoteUtils.INS_PROD_LTI;
		c = InsuranceQuoteUtils.INS_PROD_WARR;
		c = InsuranceQuoteUtils.INS_PROD_NWC;


		// isAnyInsuranceProductAccepted
		Application_InsuranceQuote__c q = new Application_InsuranceQuote__c ();
		q.Motor_Vehicle__c = 'MVCMP';
		q.Gap__c = 'SWNGAP01';
		q.LTI_BRI__c = 'SWNECO';
		q.Total_assist_RTI__c = 'SWNRTI03';
		q.Warranty_Insurance__c = 'MVW5SA36';
		q.MV_Acceptance__c = 'A';
		
		q.MV_Acceptance__c = 'U';
		q.GAP_Acceptance__c = 'A';
		
		q.GAP_Acceptance__c = 'U';
		q.LTI_Acceptance__c = 'A';
		
		q.LTI_Acceptance__c = 'U';
		q.TAS_Acceptance__c = 'A';
		
		q.TAS_Acceptance__c = 'U';
		q.WRR_Acceptance__c = 'A';
		
		Test_DataGeneratorHelper.createQuoteAnnotations();
		InsuranceQuoteUtils.getInsuranceQuoteAnnotationsMap(quoteId);

		InsuranceQuoteUtils.getLabelQuoteStatus('P');
		InsuranceQuoteUtils.getLabelCustomerChoiceStatus(InsuranceQuoteUtils.CUSCHOICE_FINISHED);

		// Test inner class
		InsuranceQuoteUtils.QuoteAnnotation  qa = new InsuranceQuoteUtils.QuoteAnnotation();
		qa.recId  = null;
		qa.driverId = quoteId;
		qa.details = 'details';
		qa.day = 3;
		qa.month = 3;
		qa.year = Date.today().year() - 3;
		qa.points = 2;
		qa.insurer = 'insurer';
		qa.amount = 1500;
		qa.driverFault = 'Y';
		qa.vehicleAffected = 'Y';
		qa.order = 0;

		InsuranceQuoteUtils.makeQuoteAnnotation(qa.getAnnotationObj());

		InsuranceQuoteUtils.getPolicyDownloadURL();

		InsuranceQuoteUtils.getOpportunityForInsuranceQuote(oppId);
		InsuranceQuoteUtils.getCurrentQuoteFigures(quote);
		InsuranceQuoteUtils.getInsuranceFailureReasons(quote.Id);

		InsuranceQuoteUtils.isFormalApprovalValidated(null, null);
		InsuranceQuoteUtils.isFormalApprovalValidated(quoting, quote);
		InsuranceQuoteUtils.isFormalApprovalValidated(quoting, null);

		quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
		InsuranceQuoteUtils.createAcknowledgementForm(quote, quoting);
		quoting.Presentation_Email_Date__c = Datetime.now();
		InsuranceQuoteUtils.isFormalApprovalValidated(quoting, quote);
		quoting.Insurance_Customer_Choice__c = 'PF';
		quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE;
		InsuranceQuoteUtils.isFormalApprovalValidated(quoting, quote);

		InsuranceQuoteUtils.deleteFailureReasons(quote.Id);

		// Lelo 			2019-12-04
		InsuranceQuoteUtils.getRestDeailerId();
		InsuranceQuoteUtils.getRestDeailerName();
		InsuranceQuoteUtils.getRestEndPoint();
		InsuranceQuoteUtils.getRestPwd();
		InsuranceQuoteUtils.getRestUserId();
		InsuranceQuoteUtils.getRestUsername();

		InsuranceQuoteUtils.isQuotePresenting(null);
		InsuranceQuoteUtils.isQuotePresenting(quote);
		InsuranceQuoteUtils.getPolicies(quote.Id);
		InsuranceQuoteUtils.validateLendersNotLPIorLTI('Macquarie Consumer');
    InsuranceQuoteUtils.validateLendersNotLPIorLTI('Money3');
    InsuranceQuoteUtils.isSelfEmployed('Self Employed');
    quoting.Insurance_AIC_Acceptance__c = 'A';
    InsuranceQuoteUtils.recalculateQuoteAcceptance(quote, quoting, true);
    InsuranceQuoteUtils.resetProductAcceptance(quoting, quote);
    InsuranceQuoteUtils.refreshQuotingProductPremiums(InsuranceQuoteUtils.INS_PROD_CCI, quote, quoting);
    InsuranceQuoteUtils.createDefaultInsuranceQuote(Test_DataGeneratorHelper.tstOpportunity, quoting);
    InsuranceQuoteUtils.declineHealthProducts(quoting, quote);
    InsuranceQuoteUtils.deleteQuotePolicies(quoteId);
    InsuranceQuoteUtils.createDefaultMainDriver(Test_DataGeneratorHelper.tstOpportunity, quote);
    InsuranceQuoteUtils.assigMVAcceptanceToDecline('Suncorp', 'A', quote);
	}
	
	@isTest static void testResetAcceptance() {
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
		update Test_DataGeneratorHelper.quoting;
		InsuranceQuoteUtils.resetProductAcceptance(Test_DataGeneratorHelper.quoting.Id);

		InsuranceQuoteUtils.finishCustomerQuote(Test_DataGeneratorHelper.quoting.Id, false);

		InsuranceQuoteUtils.finishCustomerQuote(Test_DataGeneratorHelper.quoting.Id, true);

	}	

  @isTest static void testPDSDocumentTypes() {
		Application_Quoting__c quoting = new Application_Quoting__c();
		Application_InsuranceQuote__c quote = new Application_InsuranceQuote__c();
		quoting.Name = 'AFS';

		// Testing MV
		quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
		Set<String> r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		// GAP
		quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
    quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		
		// Warranty 5
    quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
		quoting.Insurance_Warranty_Type__c = '5 Star xxxx';
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		// Warranty 4
		quoting.Insurance_Warranty_Type__c = '4 Star xxxx';
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		
		// LPI
		quoting.Name = 'Pepper';
		quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
		System.assert(!r.isEmpty());
		
		// Integrity
		quoting.Insurance_NWC_Retail_Price__c = 1200.0;
		quoting.Insurance_NWC_TypeP__c = 'Integrity';
		Set<String> assets = new Set<String>{'Car','Boat','Bike','JetSki','Truck'};
		for (String a: assets) {
			r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, a);
			System.assert(!r.isEmpty());
		}
	}

	// @isTest static void testPDSDocumentTypesOld() {
	// 	Application_Quoting__c quoting = new Application_Quoting__c();
	// 	Application_InsuranceQuote__c quote = new Application_InsuranceQuote__c();
	// 	quoting.Name = 'AFS';
	// 	// Testing MV
	// 	quote.Motor_Vehicle__c = 'MVCMP';
	// 	Set<String> r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	// Suncorp
	// 	quoting.Insurance_MV_Type__c = 'Suncorp';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quote.Motor_Vehicle__c = null;
	// 	quoting.Insurance_MV_Type__c = null;
	// 	// GAP
	// 	quote.Gap__c = 'SWNGAP01';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quote.Gap__c = null;
	// 	// RTI
	// 	quote.Total_assist_RTI__c = 'SWNRTI03';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quote.Total_assist_RTI__c = null;
	// 	// LTI
	// 	quote.LTI_BRI__c = 'SWNPLT';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quote.LTI_BRI__c = null;
	// 	// Warranty 5
	// 	quote.Warranty_Insurance__c = 'MVW5SA36';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	// Warranty 4
	// 	quote.Warranty_Insurance__c = 'MVW4SA36';
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quote.Warranty_Insurance__c = null;

	// 	// LPI
	// 	quoting.Name = 'Pepper';
	// 	quoting.Insurance_AIC_Retail_Price__c = 1200.0;
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Car');
	// 	System.assert(!r.isEmpty());
	// 	quoting.Name = 'AFS';
	// 	quoting.Insurance_AIC_Retail_Price__c = null;

	// 	// Integrity
	// 	quoting.Insurance_NWC_Retail_Price__c = 1200.0;
	// 	quoting.Insurance_NWC_TypeP__c = 'Integrity';
	// 	Set<String> assets = new Set<String>{'Car','Boat','Bike','JetSki','Truck'};
	// 	for (String a: assets) {
	// 		r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, a);
	// 		System.assert(!r.isEmpty());
	// 	}
	// 	r = InsuranceQuoteUtils.getPDSDocumentTypes(quoting, quote, 'Caravan');
	// 	System.assert(r.isEmpty());
	// 	quoting.Insurance_NWC_Retail_Price__c = null;
	// 	quoting.Insurance_NWC_TypeP__c = null;

	// }

}