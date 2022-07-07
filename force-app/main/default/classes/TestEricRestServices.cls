@isTest
private class TestEricRestServices {
	
	private static final String REST_QUOTE_ID = '310cb918-4b7e-4f50-8a84-d5b5da802063';

	@isTest static void testDTOs() {
		test.startTest();
		EricDTOs a = new EricDTOs();
		
		EricDTOs.Settings settings = new EricDTOs.Settings();
		settings.dealerId = 'A';
        settings.dealerName = 'A';
        settings.baseEndpoint = 'A';
        settings.pwd = 'A';
        settings.userId = 'A';
        settings.username = 'A';

        EricDTOs.Token token = new EricDTOs.Token();
        token.accessToken = '';
        token.tokenExpiresAfter = Datetime.now();
        token.generated = Datetime.now();
        token.result = 0;
        token.error = null;
        token.validationErrors = null;

        EricDTOs.QuoteDetails quoteDetails = new EricDTOs.QuoteDetails();
        quoteDetails.GeneralDetails = null;
        quoteDetails.FinancialDetails = null;
        quoteDetails.InsuredDetails = null;
        quoteDetails.VehicleDetails = null;
        quoteDetails.ItemDetails = null;

        EricDTOs.GeneralDetails generalDetails = new EricDTOs.GeneralDetails();
        generalDetails.CoverStartDate = null;
        generalDetails.CustomerNumber = null;
        generalDetails.FmoCustomerNumber = null;
        generalDetails.StampDutyState = null;
        generalDetails.PurchaseDate = null;
        generalDetails.PurchasePrice = null;
        generalDetails.EmploymentQuestions = null;

        EricDTOs.EmploymentQuestions employmentQuestions = new EricDTOs.EmploymentQuestions();
        employmentQuestions.ContinuouslyEmployed = false;
        employmentQuestions.CurrentlyEmployed = false;
        employmentQuestions.SelfEmployed = false;

        EricDTOs.FinancialDetails financialDetails = new EricDTOs.FinancialDetails();
        financialDetails.AmountFinanced = 0;
        financialDetails.BalloonAmount = null;
        financialDetails.FinanceTerm = null;
        financialDetails.FinanceType = null;
        financialDetails.FinancierId = null;
        financialDetails.FinancierName = null;
        financialDetails.FinancierContractReference = null;

        EricDTOs.Gender gender = new EricDTOs.Gender();
        gender = new EricDTOs.Gender('M');

        EricDTOs.InsuredMedicalHistory insuredMedicalHistory = new EricDTOs.InsuredMedicalHistory();
        //insuredMedicalHistory.HasBeenHospitalised = false;
        //insuredMedicalHistory.HasLongTermMedicalCondition = false;
        //insuredMedicalHistory.IsTakingRegularMedication = false;
        //insuredMedicalHistory.IsUnderCurrentMedicalTreatment = false;
        insuredMedicalHistory.AcknowledgmentOfExclusion = false;

        EricDTOs.Insured insured = new EricDTOs.Insured();
        // Person
        insured.Title = null;
        insured.FirstName = null;
        insured.Surname = null;
        insured.FullName = null;
        insured.Gender = null;
        insured.DateOfBirth = null;
        // Driver
        insured.Accidents = null;
        insured.IsHoldingInternationalLicence = null;
        insured.LicenseEndorsements = null;
        insured.LicenseNumber = null;
        insured.MotoringOffences = null;
        insured.RelationshipToInsured = null;
        insured.YearFirstLicensed = null;
        insured.YearSinceLastAccident = null;
        // Insured
        insured.Abn = null;
        insured.BusinessName = null;
        insured.Email = null;
        insured.InputTaxCredit = null;
        insured.InsuredMedicalHistory = null;
        insured.IsBusinessUse = null;
        insured.Mobile = null;
        insured.Occupation = null;
        insured.OccupationCode = null;
        insured.Phone1 = null;
        insured.PostalAddress1 = null;
        insured.PostalAddress2 = null;
        insured.PostCode = null;
        insured.RegisteredForGst = null;
        insured.State = null;
        insured.Suburb = null;
        insured.WorkPhone = null;

        EricDTOs.InsuredDetails insuredDetails = new EricDTOs.InsuredDetails();
        insuredDetails.MainInsured = null;
        insuredDetails.SecondInsured = null;
        insuredDetails.AdditionalDrivers = null;

        insuredDetails.MainInsured = insured.extracBusinessDetails();
        insuredDetails.MainInsured.resetBusinessDetails();


        EricDTOs.VehicleDetails vehicleDetails = new EricDTOs.VehicleDetails();
        vehicleDetails.RedbookCode = null;
        vehicleDetails.RegistrationMark = null;
        vehicleDetails.RegistrationState = null;
        vehicleDetails.VehicleCondition = null;
        vehicleDetails.VehicleType = null;
        vehicleDetails.VehicleUsage = null;
        vehicleDetails.Vin = null;
        vehicleDetails.EngineNumber = null;
        vehicleDetails.Odometer = null;

        EricDTOs.GapItemDetail gapItemDetail = new EricDTOs.GapItemDetail();
        gapItemDetail.CoverType = null;
        gapItemDetail.Insurer = null;
        gapItemDetail.InsuranceExpiry = null;
        gapItemDetail.IncludePremiumInFinance = null;
        gapItemDetail.InsuranceNewForOldInPlace = null;

        EricDTOs.TaiItemDetail taiItemDetail = new EricDTOs.TaiItemDetail();
        taiItemDetail.CoverType = null;
        taiItemDetail.DealerPolicyReference = null;
        taiItemDetail.Insurer = null;
        taiItemDetail.InsuranceExpiry = null;
        taiItemDetail.IncludePremiumInFinance = null;

        EricDTOs.LtiItemDetail ltiItemDetail = new EricDTOs.LtiItemDetail();
        ltiItemDetail.CoverType = null;
        ltiItemDetail.DealerPolicyReference = null;
        ltiItemDetail.Insurer = null;
        ltiItemDetail.InsuranceExpiry = null;
        ltiItemDetail.IncludePremiumInFinance = null;
        ltiItemDetail.IsFinanceLoan = null;
        ltiItemDetail.IncludeMaintenanceCostsForPab = null;
        
        EricDTOs.CciItemDetail cciItemDetail = new EricDTOs.CciItemDetail();
        cciItemDetail.BalloonAmount = null;
        
        EricDTOs.MotorItemDetail motorItemDetail = new EricDTOs.MotorItemDetail();
        motorItemDetail.CoverType = null;
        motorItemDetail.VehicleLocationPostcode = null;
        motorItemDetail.VehicleLocationSuburb = null;
        motorItemDetail.VehicleLocationState = null;
        motorItemDetail.HasCriminalConviction = null;
        motorItemDetail.CriminalConvictionDetails = null;
        motorItemDetail.HadInsuranceRefused = null;
        motorItemDetail.InsuranceRefusedDetails = null;
        motorItemDetail.RatingProtectionRequired = null;
        motorItemDetail.WindscreenProtectionRequired = null;
        motorItemDetail.NominatedBasicExcess = null;
        motorItemDetail.NominatedAmountCovered = null;

        EricDTOs.WarItemDetail warItemDetail = new EricDTOs.WarItemDetail();
        warItemDetail.CoverType = null;
        warItemDetail.DealerPolicyReference = null;
        warItemDetail.DateFirstRegistered = null;
        warItemDetail.IsVehicleUnderStatutoryWarranty = null;
        warItemDetail.StatutoryWarrantyEndDate = null;
        warItemDetail.IncludePremiumInFinance = null;

        EricDTOs.ItemDetails itemDetails = new EricDTOs.ItemDetails();
        itemDetails.MotorItemDetails = null;
        itemDetails.GapItemDetails = null;
        itemDetails.TaiItemDetails = null;
        itemDetails.LtiItemDetails = null;
        itemDetails.WarItemDetails = null;

        EricDTOs.MotoringOffence motoringOffence = new EricDTOs.MotoringOffence();
        motoringOffence.IncidentDate= null;
        motoringOffence.IncidentDetails = null;
        motoringOffence.DemeritPoints = null;

        EricDTOs.Accident accident = new EricDTOs.Accident();
        accident.IncidentDate = null;
        accident.IncidentDetails = null;
        accident.AtFault = null;
        accident.InsurerName = null;
        accident.LossAmount = null;
        accident.TheftOrMaliciousDamage = null;

        EricDTOs.LicenseEndorsement licenseEndorsement = new EricDTOs.LicenseEndorsement();
        licenseEndorsement.IncidentDate = null;
        licenseEndorsement.IncidentDetails = null;
        licenseEndorsement.SuspensionPeriodInMonths = null;

        EricDTOs.QuoteDetailResponse quoteDetailResponse = new EricDTOs.QuoteDetailResponse();
        quoteDetailResponse.QuoteId = null;
        quoteDetailResponse.Generated = null;
        quoteDetailResponse.Result = null;
        quoteDetailResponse.Error = null;
        quoteDetailResponse.ValidationErrors = null;

        EricDTOs.LodgementResponse lodgementResponse = new EricDTOs.LodgementResponse();
        lodgementResponse.QuoteId = null;
        lodgementResponse.QuoteGroupIdentifier = null;
        lodgementResponse.Details = null;
        lodgementResponse.Generated = null;
        lodgementResponse.Result = null;
        lodgementResponse.Error = null;
        lodgementResponse.ValidationErrors = null;

        EricDTOs.LodgementDetailResponse lodgementDetailResponse = new EricDTOs.LodgementDetailResponse();
        lodgementDetailResponse.ProductCode = null;
        lodgementDetailResponse.CoverType = null;
        lodgementDetailResponse.PolicyNumber = null;

        EricDTOs.Message message = new EricDTOs.Message();
        message.toString();
        message = new EricDTOs.Message('message');
        message.toString();
        message = new EricDTOs.Message('code', 'message');
        message.toString();

        EricDTOs.QuoteResponse quoteResponse = new EricDTOs.QuoteResponse();
        quoteResponse.QuoteId = null;
        quoteResponse.QuotedGroups = null;
        quoteResponse.VehicleDetails = null;
        quoteResponse.QuoteStatus = null;
        quoteResponse.Generated = null;
        quoteResponse.Result = null;
        quoteResponse.Error = null;
        quoteResponse.ValidationErrors = null;

        EricDTOs.QuotedGroup quotedGroup = new EricDTOs.QuotedGroup();
        quotedGroup.GroupId = null;
        quotedGroup.Name = null;
        quotedGroup.QuotationReferenceNumber = null;
        quotedGroup.CoverStartDate = null;
        quotedGroup.WarrantyCoverStartDate = null;
        quotedGroup.IsReferralRequired = null;
        quotedGroup.AssessmentRulings = null;
        quotedGroup.Items = null;
        quotedGroup.PaymentOptions = null;
        quotedGroup.FinanceDetails = null;
        quotedGroup.IsValid = null;

        EricDTOs.QuoteItem quoteItem = new EricDTOs.QuoteItem();
        quoteItem.AmountCovered = null;
        quoteItem.AmountCoveredMaximum = null;
        quoteItem.AmountCoveredMinimum = null;
        quoteItem.BasicExcess = null;
        quoteItem.BasicExcessOptions = null;
        quoteItem.ImposedExcess = null;
        quoteItem.SystemImposedExcess = null;
        quoteItem.QuotationGenerated = null;
        quoteItem.CostExGst = null;
        quoteItem.Gst = null;
        quoteItem.EstablishmentFee = null;
        quoteItem.Premium = null;
        quoteItem.StampDuty = null;
        quoteItem.CoverTerm = null;
        quoteItem.PaymentOptions = null;
        quoteItem.Product = null;
        quoteItem.CoverType = null;

        EricDTOs.QuotePaymentOption quotePaymentOption = new EricDTOs.QuotePaymentOption();
        quotePaymentOption.Code = null;
        quotePaymentOption.Description = null;
        quotePaymentOption.Payable = null;
        quotePaymentOption.InstalmentAmount = null;
        quotePaymentOption.NumberOfInstalments = null;

        EricDTOs.QuoteVehicleDetails quoteVehicleDetails = new EricDTOs.QuoteVehicleDetails();
        quoteVehicleDetails.Make = null;
        quoteVehicleDetails.Model = null;
        quoteVehicleDetails.BadgeDescription = null;
        quoteVehicleDetails.BuildYear = Date.today().year();
        quoteVehicleDetails.toString();

        EricDTOs.QuoteFinanceDetails quoteFinanceDetails = new EricDTOs.QuoteFinanceDetails();
        quoteFinanceDetails.OriginalFinanceAmount = null;
        quoteFinanceDetails.NewFinanceAmount = null;

        EricDTOs.AssessmentRuling assessmentRuling = new EricDTOs.AssessmentRuling();
        assessmentRuling.ReferToOffice = null;
        assessmentRuling.AutomaticDecline = null;
        assessmentRuling.Comment = null;
        assessmentRuling.ImposedExcess = null;

        EricDTOs.BeginQuote beginQuote = new EricDTOs.BeginQuote();
        beginQuote.DealerId = null;
        beginQuote.UserId = null;
        beginQuote.QuoteGroups = null;

        EricDTOs.QuoteGroup quoteGroup = new EricDTOs.QuoteGroup();
        quoteGroup.GroupId = null;
        quoteGroup.Name = null;
        quoteGroup.Items = null;

        EricDTOs.Item item = new EricDTOs.Item();
        item.Product = null;
        item.CoverType = null;

        EricDTOs.CannotQuoteItem cannotQuoteItem = new EricDTOs.CannotQuoteItem();
        cannotQuoteItem.CoverType = null;
        cannotQuoteItem.Product = null;
        cannotQuoteItem.GroupId = null;
        cannotQuoteItem.Description = null;

        EricDTOs.AcceptedQuoteGroup acceptedQuoteGroup = new EricDTOs.AcceptedQuoteGroup();
        acceptedQuoteGroup.Name = null;
        acceptedQuoteGroup.GroupId = null;

        EricDTOs.BeginQuoteResponse beginQuoteResponse = new EricDTOs.BeginQuoteResponse();
        beginQuoteResponse.QuoteId = null;
        beginQuoteResponse.CannotQuoteAllItems = null;
        beginQuoteResponse.CannotQuoteItems = null;
        beginQuoteResponse.AcceptedQuoteGroups = null;
        beginQuoteResponse.QuoteStatus = null;
        beginQuoteResponse.Generated = null;
        beginQuoteResponse.Result = null;
        beginQuoteResponse.Error = null;
        beginQuoteResponse.ValidationErrors = null;

        EricDTOs.ErrorMessage errorMessage = new EricDTOs.ErrorMessage();
        errorMessage.OccurredAt = null;
        errorMessage.Code = null;
        errorMessage.Description = null;
        errorMessage.toMessage();

        EricDTOs.PreLodgement preLodgement = new EricDTOs.PreLodgement();
        preLodgement.QuoteIdentifier = null;
        preLodgement.QuoteGroupIdentifier = null;
        preLodgement.QuoteReferenceNumber = null;
        preLodgement.PreLodgeAll = null;
        preLodgement.PreLodgementItems = null;
        preLodgement.SharedPaymentDetails = null;

        EricDTOs.PreLodgementItem preLodgementItem = new EricDTOs.PreLodgementItem();
        preLodgementItem.CoverType = null;
        preLodgementItem.PaymentDetails = null;
        preLodgementItem.HasValidDetails = null;

        EricDTOs.PaymentDetail paymentDetail = new EricDTOs.PaymentDetail();
        paymentDetail.BankAccountDetails = null;
        paymentDetail.CardDetails = null;
        paymentDetail.HasValidDetails = null;
        paymentDetail.PaymentMethod = null;

        EricDTOs.BankAccountDetail bankAccountDetail = new EricDTOs.BankAccountDetail();
        bankAccountDetail.AccountHolderName = null;
        bankAccountDetail.AccountNumber = null;
        bankAccountDetail.Bsb = null;
        bankAccountDetail.IsValid = null;

        EricDTOs.CardDetail cardDetail = new EricDTOs.CardDetail();
        cardDetail.CardholderName = null;
        cardDetail.CardNumber = null;
        cardDetail.Expiry = null;
        cardDetail.VerificationCode = null;
        cardDetail.IsValid = null;

        EricDTOs.CardExpiry cardExpiry = new EricDTOs.CardExpiry();
        cardExpiry.Year = null;
        cardExpiry.Month = null;

        EricDTOs.ResponseDTO responseDTO = new EricDTOs.ResponseDTO();
        responseDTO.beginQuoteResponse = null;
        responseDTO.addDetailsResponse = null;
        responseDTO.quoteResponse = null;
        responseDTO.lodgementResponse = null;
        responseDTO.customMessages = null;
        // Empty fields
        responseDTO.getQuoteId();
        responseDTO.hasErrors();
        responseDTO.getAllMessages();
        
        responseDTO.beginQuoteResponse = new EricDTOs.BeginQuoteResponse();
        responseDTO.getQuoteId();

        responseDTO.beginQuoteResponse = null;
        responseDTO.addDetailsResponse = new EricDTOs.QuoteDetailResponse();
        responseDTO.getQuoteId();

        responseDTO.addDetailsResponse = null;
        responseDTO.quoteResponse = new EricDTOs.QuoteResponse();
        responseDTO.getQuoteId();

        // adding error messages
        responseDTO = new EricDTOs.ResponseDTO();
		responseDTO.addErrorMessage('message');
		responseDTO.addErrorMessage('code', 'message');
		responseDTO.addWarningMessage('message');
		responseDTO.addWarningMessage('code', 'message');
		responseDTO.addInfoMessage('message');
		responseDTO.addInfoMessage('code', 'message');
		responseDTO.addSuccessMessage('message');
		responseDTO.addSuccessMessage('code', 'message');
		responseDTO.hasErrors();
		responseDTO.getAllMessages();

		// has errors
		responseDTO = new EricDTOs.ResponseDTO();
		responseDTO.beginQuoteResponse = new EricDTOs.BeginQuoteResponse();
		responseDTO.beginQuoteResponse.Error = new EricDTOs.ErrorMessage();
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		responseDTO.beginQuoteResponse.Error = null;
		responseDTO.beginQuoteResponse.ValidationErrors = new List<EricDTOs.Message>();
		responseDTO.beginQuoteResponse.ValidationErrors.add(new EricDTOs.Message());
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		
		responseDTO = new EricDTOs.ResponseDTO();
		responseDTO.addDetailsResponse = new EricDTOs.QuoteDetailResponse();
		responseDTO.addDetailsResponse.Error = new EricDTOs.ErrorMessage();
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		responseDTO.addDetailsResponse.Error = null;
		responseDTO.addDetailsResponse.ValidationErrors = new List<EricDTOs.Message>();
		responseDTO.addDetailsResponse.ValidationErrors.add(new EricDTOs.Message());
		responseDTO.hasErrors();
		responseDTO.getAllMessages();

		responseDTO = new EricDTOs.ResponseDTO();
		responseDTO.quoteResponse = new EricDTOs.QuoteResponse();
		responseDTO.quoteResponse.Error = new EricDTOs.ErrorMessage();
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		responseDTO.quoteResponse.Error = null;
		responseDTO.quoteResponse.ValidationErrors = new List<EricDTOs.Message>();
		responseDTO.quoteResponse.ValidationErrors.add(new EricDTOs.Message());
		responseDTO.hasErrors();
		responseDTO.getAllMessages();

		responseDTO = new EricDTOs.ResponseDTO();
		responseDTO.lodgementResponse = new EricDTOs.LodgementResponse();
		responseDTO.lodgementResponse.Error = new EricDTOs.ErrorMessage();
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		responseDTO.lodgementResponse.Error = null;
        responseDTO.lodgementResponse.ValidationErrors = new List<EricDTOs.Message>();
		responseDTO.lodgementResponse.ValidationErrors.add(new EricDTOs.Message());
		responseDTO.hasErrors();
		responseDTO.getAllMessages();

        responseDTO = new EricDTOs.ResponseDTO();
        responseDTO.preLodgementResponse = new EricDTOs.LodgementResponse();
        responseDTO.preLodgementResponse.ValidationErrors = new List<EricDTOs.Message>();
		responseDTO.preLodgementResponse.ValidationErrors.add(new EricDTOs.Message());
		responseDTO.hasErrors();
		responseDTO.getAllMessages();
		test.stopTest();
	}

	@isTest static void testEricServiceGetToken() {
		initEricSettings();
		SingleRequestMock fakeRes = getMockTokenRequest();
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		EricDTOs.Token token = EricServices.getToken();
		System.assertNotEquals(null, token);
		token = EricServices.getToken(true);
		System.assertNotEquals(null, token);
		Test.stopTest();
	}

	@isTest static void testEricServiceGetTestPost() {
		initEricSettings();
		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest('"Post OK, value: "');
		requestMocks.addRequestMock(baseEndpoint + '/api/Test/Post', fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);

		Test.startTest();
		EricServices.getTestPost();
		Test.stopTest();
	}

	@isTest static void testInsuranceGetQuoteMainDriverExeption() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupBasicData();
		Test.startTest();
		try {
			InsuranceQuoteRestWS.getQuote(param);
		} catch (InsuranceServiceException e) {
			System.assert(e.getMessage().contains('There is not a main driver'));
		}
		Test.stopTest();	
	}

	@isTest static void testInsuranceGetQuote() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupQuoteData();
		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest(getBeginQuoteSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/BeginQuote', fakeRes);

		fakeRes = getQuickMockRequest(getQuoteAddDetailsSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/QuoteAddDetails/'+REST_QUOTE_ID, fakeRes);

		fakeRes = getQuickMockRequest(getQuoteSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/GetQuote/'+REST_QUOTE_ID, fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        Test.startTest();
			InsuranceQuoteRestWS.getQuote(param);
		Test.stopTest();
    }
    
    @isTest static void testInsuranceGetQuote2() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupQuoteData();
		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest(getBeginQuoteSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/BeginQuote', fakeRes);

		fakeRes = getQuickMockRequest(getQuoteAddDetailsSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/QuoteAddDetails/'+REST_QUOTE_ID, fakeRes);

		fakeRes = getQuickMockRequest(getQuoteSuccessResponse2());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/GetQuote/'+REST_QUOTE_ID, fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);
        param.processType = InsuranceQuoteUtils.PROCESS_FINALQUOTE;
        param.isMVPresenting(); 
        Test.startTest();
			InsuranceQuoteRestWS.getQuote(param);
		Test.stopTest();
    }
    
	@isTest static void testInsuranceGetQuoteFinal() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupFinalQuoteData();
		param.processType = InsuranceQuoteUtils.PROCESS_FINALQUOTE;

		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest(getBeginQuoteSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/BeginQuote', fakeRes);

		fakeRes = getQuickMockRequest(getQuoteAddDetailsSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/QuoteAddDetails/'+REST_QUOTE_ID, fakeRes);

		fakeRes = getQuickMockRequest(getQuoteSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Quote/GetQuote/'+REST_QUOTE_ID, fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);

		Test.startTest();
		InsuranceQuoteRestWS.getQuote(param);
		Test.stopTest();	
	}

	@isTest static void testInsuranceBuyPolicy() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupBuyPolicyData();
		param.processType = InsuranceQuoteUtils.PROCESS_BUYPOLICY;

		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest(getPreLodgeSuccessResponse());
		requestMocks.addRequestMock(baseEndpoint + '/api/Lodgement/PreLodge', fakeRes);

        fakeRes = getQuickMockRequest(getPreLodgeSuccessResponse());
        requestMocks.addRequestMock(baseEndpoint + '/api/Lodgement/Lodge', fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);

		Test.startTest();
		InsuranceQuoteRestWS.preLodgeQuote(param);
        Test.stopTest();
    }
    
    @isTest static void testInsuranceBuyPolicy2() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupBuyPolicyData();
		param.processType = InsuranceQuoteUtils.PROCESS_BUYPOLICY;

		MultiRequestMock requestMocks = new MultiRequestMock();
		
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		
		fakeRes = getQuickMockRequest(getPreLodgeSuccessResponse2());
		requestMocks.addRequestMock(baseEndpoint + '/api/Lodgement/PreLodge', fakeRes);

        fakeRes = getQuickMockRequest(getPreLodgeSuccessResponse2());
        requestMocks.addRequestMock(baseEndpoint + '/api/Lodgement/Lodge', fakeRes);

        Test.setMock(HttpCalloutMock.class, requestMocks);

		Test.startTest();
		InsuranceQuoteRestWS.preLodgeQuote(param);
        Test.stopTest();
    }

	@isTest static void testInsurancePolicyDocuments() {
		initEricSettings();
		InsuranceQuoteRestWS.QuoteParam param = setupPolicyDocumentData();

		MultiRequestMock requestMocks = new MultiRequestMock();
		String baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		String username = InsuranceQuoteUtils.getRestUsername();
		String pwd = InsuranceQuoteUtils.getRestPwd();

		SingleRequestMock fakeRes = getMockTokenRequest();
		requestMocks.addRequestMock(baseEndpoint + '/api/token?username='+username+'&password='+pwd, fakeRes);
		// Policy responses
		List<Insurance_Quote_Policy__c> policyList = InsuranceQuoteUtils.getPolicies(param.quote.Id);
		for (Insurance_Quote_Policy__c pd: policyList){
			fakeRes = getQuickMockRequest('{policy: "'+pd.Policy_Number__c+'"}');
			requestMocks.addRequestMock(baseEndpoint + '/api/Documentation/GetPolicySchedule?policyNumber='+pd.Policy_Number__c, fakeRes);
		}
		Test.setMock(HttpCalloutMock.class, requestMocks);

		Test.startTest();
		// Load policies
		for (Insurance_Quote_Policy__c p: policyList) {
			HTTPResponse response = InsuranceQuoteRestWS.getPolicyDocument(p.Policy_Number__c);
			System.assertNotEquals(null, response);
		}
		Test.stopTest();
    }

    @isTest static void testExeptionClasses() {
        Test.startTest();
        InsuranceServiceException e = new InsuranceServiceException();
        System.assert(!e.hasMultipleMessages());
        e = new InsuranceServiceException(new Set<String>{'Error message'});
        System.assert(e.hasMultipleMessages());
        Test.stopTest();   
    }

	private static InsuranceQuoteRestWS.QuoteParam setupBasicData () {
		Test_DataGeneratorHelper.createQuoting();
		Test_DataGeneratorHelper.createQuote();
		Test_DataGeneratorHelper.createAssetDetailLTV();
		Test_DataGeneratorHelper.reloadOpportunity();
		InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
		param.opp = Test_DataGeneratorHelper.tstOpportunity;
		param.quote = Test_DataGeneratorHelper.quote;
        param.quoting = Test_DataGeneratorHelper.quoting;
        param.quote.LPI__c = 'CRDU';
        param.quote.LPI_Acceptance__c = 'A';
        param.quoting.Insurance_AIC_Retail_Price__c = 1000.00;
        param.opp.Application_AssetDetail__r.Engine_No__c = '1';
        param.quote.Odometer__c = 1000;
        param.quote.NCB_Protection__c = true;
        param.quote.Windscreen_Protection__c = true;
        param.quote.MV_Standard_Excess__c = 1000.00;
        param.quote.MV_Amount_Covered__c = 1000.00;
        param.quoting.Residual_Value__c = 1000.00;
        return param;
	}

	private static InsuranceQuoteRestWS.QuoteParam setupQuoteData () {
		InsuranceQuoteRestWS.QuoteParam param = setupBasicData();
		Test_DataGeneratorHelper.createQuoteMainDriver();
		Test_DataGeneratorHelper.createQuoteAdditionalDriver();
		Test_DataGeneratorHelper.createQuoteAnnotations();
		// Quote details
		param.quote.Vehicle_Purchase_Price__c = 15000;
		param.quote.Vehicle_Location_State__c = 'SA';
		param.quote.Vehicle_Location_Postcode__c = 5067;
		param.quote.Vehicle_Location_Suburb__c = 'Norwood';
		// Products
		param.quote.Motor_Vehicle__c = getMVProduct();
        param.quote.Gap__c = getGAPProduct();
        param.quote.LTI_BRI__c = getLTIProduct();
        param.quote.Warranty_Insurance__c = getWARRProduct();
        param.quote.LPI__c = getLPIProduct();
        param.quote.Total_assist_RTI__c = getRTIProduct();
		// Finalcial details
		param.quote.Amount_Financed__c = param.quote.Vehicle_Purchase_Price__c + 2500;
		param.quoting.Residual_Value__c = 0;
		param.quote.Finance_Term__c = 60;
		param.quote.Financier_Id__c = '00123456';
		param.opp.Application__r.Application_Type__c = 'Personal';
		// Insured Details
		param.quote.Vehicle_Usage__c = 'Private';
		param.quote.Has_Additional_Driver__c = true;
		param.quote.Has_Accident_History__c = true;
		param.quote.Has_Licence_Santioned__c = true;
		param.quote.Has_Motoring_Offences__c = true;
		return param;
	}

	private static InsuranceQuoteRestWS.QuoteParam setupFinalQuoteData () {
		InsuranceQuoteRestWS.QuoteParam param = setupQuoteData();
		// Accepting Products
		param.quote.MV_Acceptance__c = 'A';
		param.quote.GAP_Acceptance__c = 'A';
		param.quote.LTI_Acceptance__c = 'A';
		param.quote.WRR_Acceptance__c = 'A';
        param.quote.TAS_Acceptance__c = 'A';
		// Vehicle details
		param.quote.Vehicle_Been_Registered__c = true;
		param.opp.Application_AssetDetail__r.Rego__c = 'XCV123';
		param.opp.Application_AssetDetail__r.Rego_State__c = 'SA';
		param.opp.Application_AssetDetail__r.VIN__c = 'VIN1254875';

		return param;
	}

	private static InsuranceQuoteRestWS.QuoteParam setupBuyPolicyData() {
		InsuranceQuoteRestWS.QuoteParam param = setupFinalQuoteData();
		// Payment methods
		param.quote.MV_Payment_Method__c = 'PREMFUND12BA';
		param.quote.GAP_Payment_Method__c = 'FINANCECOMPANY';
		param.quote.LTI_Payment_Method__c = 'FINANCECOMPANY';
		param.quote.WRR_Payment_Method__c = 'FINANCECOMPANY';
        param.quote.LPI_Payment_Method__c = 'CREDITCARD';
		// Create payment method
		Application_Payment_Method__c p = new Application_Payment_Method__c();
		p.Account_Number__c = '123456';
		p.Application__c = param.opp.Application__c;
		p.BSB_Number__c = '65432100';
		p.Method__c = 'BA';
		p.Holder_Name__c = param.opp.Name;
		insert p;
        Application_Payment_Method__c p2 = new Application_Payment_Method__c();
		p2.Credit_Card_Number__c = '1111111111111111';
		p2.Application__c = param.opp.Application__c;
		p2.Verification_Code__c = '111';
		p2.Method__c = 'CC';
		p2.Holder_Name__c = param.opp.Name;
        p2.Expiry_Month__c = '01';
        p2.Expiry_Year__c = '2025';
		insert p2;
		param.quote.MV_Payment_Detail__c = p.Id;
        param.quote.LPI_Payment_Detail__c = p2.Id;
		param.paymentMethods = new List <InsuranceQuoteUtils.PaymentMethodDTO>();
		param.paymentMethods.add(new InsuranceQuoteUtils.PaymentMethodDTO(1, p));
        param.paymentMethods.add(new InsuranceQuoteUtils.PaymentMethodDTO(1, p2));
		return param;
	}

	private static InsuranceQuoteRestWS.QuoteParam setupPolicyDocumentData() {
		InsuranceQuoteRestWS.QuoteParam param = setupBuyPolicyData();
		EricDTOs.LodgementResponse res = (EricDTOs.LodgementResponse)JSON.deserialize(
			getPreLodgeSuccessResponse(), EricDTOs.LodgementResponse.class);
		if (res.Details != null) {
            List<Insurance_Quote_Policy__c> d = new List<Insurance_Quote_Policy__c>();
            for (EricDTOs.LodgementDetailResponse a: res.Details) {
                Insurance_Quote_Policy__c p = new Insurance_Quote_Policy__c();
                p.Application_Insurance_Quote__c = param.quote.Id;
                p.Policy_Number__c = a.PolicyNumber;
                p.Cover_Type__c = a.CoverType;
                p.Product_Code__c = a.ProductCode;
                d.add(p);
            }
            if (!d.isEmpty()) {
                insert d;
            }
        }
		return param;
	}
	
	private static String getMVProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.Motor_Vehicle__c.getDescribe());
	}

	private static String getGAPProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.Gap__c.getDescribe());
	}

	private static String getLTIProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.LTI_BRI__c.getDescribe());
	}

	private static String getWARRProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.Warranty_Insurance__c.getDescribe());
	}

	private static String getRTIProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.Total_assist_RTI__c.getDescribe());
	}
    
    private static String getLPIProduct() {
      	return getInsuranceProduct(
      		Application_InsuranceQuote__c.LPI__c.getDescribe());
	}

	private static String getInsuranceProduct(Schema.DescribeFieldResult fieldRes) {
		String r = null;
		if (fieldRes != null) {
	      	List<Schema.PicklistEntry> ple = fieldRes.getPicklistValues();
	      	if (!ple.isEmpty()) {
	      		r = ple.get(0).getValue();
	      	}
	    }
      	return r;
	}

	private static SingleRequestMock getMockTokenRequest() {
		SingleRequestMock r = getQuickMockRequest(
				'{"AccessToken": "FMP4VGA8", "TokenExpiresAfter": "2019-05-16T12:20:24.7219097Z",' + 
				' "Generated": "2019-05-16T06:20:24.7219097Z", "Result": 0,' +
				' "Error": null, "ValidationErrors": null}');
		return r;
	}

	private static SingleRequestMock getQuickMockRequest(String body) {
		SingleRequestMock r = new SingleRequestMock(
				200, 'Complete', body, null
			);
		return r;
	}

	// Eric Rest Service Responses
	private static String getBeginQuoteSuccessResponse() {
		String r = '{"QuoteId":"'+REST_QUOTE_ID+'","CannotQuoteAllItems":false,"CannotQuoteItems":null,'+
		           '"AcceptedQuoteGroups":[{"Name":"Savvy Finance + Insurance","GroupId":"7181bc10-7b1e-4512-b39b-fe0c9d4a3c48"}],'+
		           '"QuoteStatus":0,"Generated":"2019-05-17T01:05:59.8747901Z","Result":0,"Error":null,"ValidationErrors":null}';
		return r;
	}

	private static String getQuoteAddDetailsSuccessResponse() {
		String r = '{"QuoteId":"'+REST_QUOTE_ID+'","Generated":"2019-05-17T01:15:13.7113743Z",'+
				   '"Result":0,"Error":null,"ValidationErrors":null}';
		return r;
	}

	private static String getQuoteSuccessResponse() {
		String r = '{"QuoteId":"'+REST_QUOTE_ID+'","QuotedGroups":[{"GroupId":"7181bc10-7b1e-4512-b39b-fe0c9d4a3c48",'+
		           '"Name":"Savvy Finance + Insurance","QuotationReferenceNumber":"Q15915791","CoverStartDate":"2019-05-17T00:00:00",'+
		           '"WarrantyCoverStartDate":"2019-08-15T00:00:00","IsReferralRequired":false,"AssessmentRulings":null,'+
		           '"Items":[{"AmountCovered":30950,"AmountCoveredMaximum":34100,"AmountCoveredMinimum":21665,"BasicExcess":450,'+
		           '"BasicExcessOptions":[450,650,850,1050],"ImposedExcess":0,"SystemImposedExcess":0,"NetPremiumAmount":null,'+
		           '"CommissionAmount":null,"QuotationGenerated":true,"CostExGst":836.28,"Gst":119.4685,"EstablishmentFee":0,'+
		           '"Premium":1458.71,"StampDuty":144.5568,"CoverTerm":12,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1458.71,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1458.71,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1458.71,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":1633.7551999999999999999999994,"InstalmentAmount":136.14626666666666666666666662,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":1633.7551999999999999999999994,'+
		           '"InstalmentAmount":136.14626666666666666666666662,"NumberOfInstalments":12}],"Product":"Motor vehicle",'+
		           '"ProductCode":"MOT","CoverType":"MVCMP"},{"NominatedBenefitsLevel":null,"MaxShortfallBenefit":null,"TopupBenefit":null,'+
		           '"CoverBenefitOptions":null,"QuotationGenerated":true,"CostExGst":1042.64,"Gst":130.3301,"EstablishmentFee":0,'+
		           '"Premium":1591.33,"StampDuty":157.6994,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1591.33,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1591.33,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1591.33,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":1782.2895999999999999999999994,"InstalmentAmount":148.52413333333333333333333328,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":1782.2895999999999999999999994,'+
		           '"InstalmentAmount":148.52413333333333333333333328,"NumberOfInstalments":12}],"Product":"GAP","ProductCode":"GAP",'+
		           '"CoverType":"SWNGAP01"},{"QuotationGenerated":true,"CostExGst":1583.47,"Gst":197.9337,"EstablishmentFee":0,'+
		           '"Premium":2416.77,"StampDuty":239.4997,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":2416.77,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":2416.77,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":2416.77,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null}],"Product":"LTI","ProductCode":"LTI","CoverType":"SWNPLT"},'+
		           '{"Loadings":["Turbo"],"QuotationGenerated":true,"CostExGst":1191.75,"Gst":148.9689,"EstablishmentFee":0,'+
		           '"Premium":1818.91,"StampDuty":180.2523,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1818.91,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1818.91,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1818.91,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":2037.1791999999999999999999992,"InstalmentAmount":169.76493333333333333333333327,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":2037.1791999999999999999999992,'+
		           '"InstalmentAmount":169.76493333333333333333333327,"NumberOfInstalments":12}],"Product":"Warranty - Insurance",'+
		           '"ProductCode":"WAR","CoverType":"MVW5SA36"}, {"SystemImposedExcess": null,"StampDuty": 152.2726,"QuotationGenerated": true,'+
                   '"Product": "Loan Protection","Premium": 2532.77,"PaymentOptions": [{"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Credit Card","Code": "CREDITCARD"}, {"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Dealer Cheque","Code": "DEALERCHEQUE"}, {"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Finance Company","Code": "FINANCECOMPANY"}],"ImposedExcess": null,"Gst": 216.4089,'+
                   '"EstablishmentFee": 0.0,"CoverType": "CRDU","CoverTerm": 60,"CostExGst": 2532.77,"BasicExcessOptions": null,"BasicExcess": null,'+
                   '"AmountCoveredMinimum": null,"AmountCoveredMaximum": null,"AmountCovered": null},{"SystemImposedExcess": null,"StampDuty": 38.9072,'+
                   '"QuotationGenerated": true,"Product": "Total assist/RTI","Premium": 471.21,"PaymentOptions": [{"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Credit Card","Code": "CREDITCARD"}, {"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Dealer Cheque","Code": "DEALERCHEQUE"}, {"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Finance Company","Code": "FINANCECOMPANY"}, {"Payable": 527.7552,"NumberOfInstalments": 12,'+
                   '"InstalmentAmount": 43.9796,"Description": "Monthly - Bank account","Code": "PREMFUND12BA"}, {"Payable": 527.7552,"NumberOfInstalments": 12,'+
                   '"InstalmentAmount": 43.9796,"Description": "Monthly - Credit Card","Code": "PREMFUND12CC"}],"ImposedExcess": null,"Gst": 39.3003,"EstablishmentFee": 0.0,'+
                   '"CoverType": "SWNRTI03","CoverTerm": 36,"CostExGst": 314.4,"BasicExcessOptions": null,"BasicExcess": null,"AmountCoveredMinimum": null,'+
                   '"AmountCoveredMaximum": null,"AmountCovered": null}],'+
                   '"PaymentOptions":[{"Code":"CREDITCARD","Description":"Full - Credit Card"},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque"},{"Code":"FINANCECOMPANY",'+
		           '"Description":"Full - Finance Company"}],"FinanceDetails":{"OriginalFinanceAmount":37238,"NewFinanceAmount":39056.91},'+
		           '"IsValid":true}],"VehicleDetails":{"Make":"AUDI","Model":"A3 S tronic SEDAN 4cyl 1.4 Intercooled Turbo",'+
		           '"BadgeDescription":"S tronic","BuildYear":2017},"QuoteStatus":2,"Generated":"2019-05-17T01:21:07.7770096Z",'+
		           '"Result":0,"Error":null,"ValidationErrors":null}';
		return r;
	}
    
    private static String getQuoteSuccessResponse2() {
		String r = '{"QuoteId":"'+REST_QUOTE_ID+'","QuotedGroups":[{"GroupId":"7181bc10-7b1e-4512-b39b-fe0c9d4a3c48",'+
		           '"Name":"Savvy Finance + Insurance","QuotationReferenceNumber":"Q15915791","CoverStartDate":"2019-05-17T00:00:00",'+
		           '"WarrantyCoverStartDate":"2019-08-15T00:00:00","IsReferralRequired":false,"AssessmentRulings":null,'+
		           '"Items":[{"AmountCovered":30950,"AmountCoveredMaximum":34100,"AmountCoveredMinimum":21665,"BasicExcess":450,'+
		           '"BasicExcessOptions":[450,650,850,1050],"ImposedExcess":0,"SystemImposedExcess":0,"NetPremiumAmount":null,'+
		           '"CommissionAmount":null,"QuotationGenerated":true,"CostExGst":836.28,"Gst":119.4685,"EstablishmentFee":0,'+
		           '"Premium":1458.71,"StampDuty":144.5568,"CoverTerm":12,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1458.71,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1458.71,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1458.71,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":1633.7551999999999999999999994,"InstalmentAmount":136.14626666666666666666666662,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":1633.7551999999999999999999994,'+
		           '"InstalmentAmount":136.14626666666666666666666662,"NumberOfInstalments":12}],"Product":"Motor vehicle",'+
		           '"ProductCode":"MOT","CoverType":"MVCMP"},{"NominatedBenefitsLevel":null,"MaxShortfallBenefit":null,"TopupBenefit":null,'+
		           '"CoverBenefitOptions":null,"QuotationGenerated":true,"CostExGst":1042.64,"Gst":130.3301,"EstablishmentFee":0,'+
		           '"Premium":1591.33,"StampDuty":157.6994,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1591.33,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1591.33,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1591.33,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":1782.2895999999999999999999994,"InstalmentAmount":148.52413333333333333333333328,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":1782.2895999999999999999999994,'+
		           '"InstalmentAmount":148.52413333333333333333333328,"NumberOfInstalments":12}],"Product":"GAP","ProductCode":"GAP",'+
		           '"CoverType":"SWNGAP01"},{"QuotationGenerated":true,"CostExGst":1583.47,"Gst":197.9337,"EstablishmentFee":0,'+
		           '"Premium":2416.77,"StampDuty":239.4997,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":2416.77,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":2416.77,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":2416.77,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null}],"Product":"LTI","ProductCode":"LTI","CoverType":"SWNPLT"},'+
		           '{"Loadings":["Turbo"],"QuotationGenerated":true,"CostExGst":1191.75,"Gst":148.9689,"EstablishmentFee":0,'+
		           '"Premium":1818.91,"StampDuty":180.2523,"CoverTerm":60,"PaymentOptions":[{"Code":"CREDITCARD",'+
		           '"Description":"Full - Credit Card","Payable":1818.91,"InstalmentAmount":null,"NumberOfInstalments":null},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque","Payable":1818.91,"InstalmentAmount":null,'+
		           '"NumberOfInstalments":null},{"Code":"FINANCECOMPANY","Description":"Full - Finance Company","Payable":1818.91,'+
		           '"InstalmentAmount":null,"NumberOfInstalments":null},{"Code":"PREMFUND12BA","Description":"Monthly - Bank account",'+
		           '"Payable":2037.1791999999999999999999992,"InstalmentAmount":169.76493333333333333333333327,"NumberOfInstalments":12},'+
		           '{"Code":"PREMFUND12CC","Description":"Monthly - Credit Card","Payable":2037.1791999999999999999999992,'+
		           '"InstalmentAmount":169.76493333333333333333333327,"NumberOfInstalments":12}],"Product":"Warranty - Insurance",'+
		           '"ProductCode":"WAR","CoverType":"MVW5SA36"}, {"SystemImposedExcess": null,"StampDuty": 152.2726,"QuotationGenerated": true,'+
                   '"Product": "Loan Protection","Premium": 2532.77,"PaymentOptions": [{"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Credit Card","Code": "CREDITCARD"}, {"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Dealer Cheque","Code": "DEALERCHEQUE"}, {"Payable": 2532.77,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Finance Company","Code": "FINANCECOMPANY"}],"ImposedExcess": null,"Gst": 216.4089,'+
                   '"EstablishmentFee": 0.0,"CoverType": "CRDU","CoverTerm": 60,"CostExGst": 2532.77,"BasicExcessOptions": null,"BasicExcess": null,'+
                   '"AmountCoveredMinimum": null,"AmountCoveredMaximum": null,"AmountCovered": null},{"SystemImposedExcess": null,"StampDuty": 38.9072,'+
                   '"QuotationGenerated": true,"Product": "Total assist/RTI","Premium": 471.21,"PaymentOptions": [{"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Credit Card","Code": "CREDITCARD"}, {"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Dealer Cheque","Code": "DEALERCHEQUE"}, {"Payable": 471.21,"NumberOfInstalments": null,'+
                   '"InstalmentAmount": null,"Description": "Full - Finance Company","Code": "FINANCECOMPANY"}, {"Payable": 527.7552,"NumberOfInstalments": 12,'+
                   '"InstalmentAmount": 43.9796,"Description": "Monthly - Bank account","Code": "PREMFUND12BA"}, {"Payable": 527.7552,"NumberOfInstalments": 12,'+
                   '"InstalmentAmount": 43.9796,"Description": "Monthly - Credit Card","Code": "PREMFUND12CC"}],"ImposedExcess": null,"Gst": 39.3003,"EstablishmentFee": 0.0,'+
                   '"CoverType": "SWNRTI03","CoverTerm": 36,"CostExGst": 314.4,"BasicExcessOptions": null,"BasicExcess": null,"AmountCoveredMinimum": null,'+
                   '"AmountCoveredMaximum": null,"AmountCovered": null}],'+
                   '"PaymentOptions":[{"Code":"CREDITCARD","Description":"Full - Credit Card"},'+
		           '{"Code":"DEALERCHEQUE","Description":"Full - Dealer Cheque"},{"Code":"FINANCECOMPANY",'+
		           '"Description":"Full - Finance Company"}],"FinanceDetails":{"OriginalFinanceAmount":37238,"NewFinanceAmount":39056.91},'+
		           '"IsValid":true}],"VehicleDetails":{"Make":"AUDI","Model":"A3 S tronic SEDAN 4cyl 1.4 Intercooled Turbo",'+
		           '"BadgeDescription":"S tronic","BuildYear":2017},"QuoteStatus":2,"Generated":"2019-05-17T01:21:07.7770096Z",'+
		           '"Result":0,"Error":{"OccurredAt": "2020-06-30T06:35:28.539Z",'+
                   '"Description": "Driver: Lav rai year first licensed value is invalid for the specified date of birth.  Please submit a valid year first licensed value for this driver.",'+
			       '"Code": "IDE18"},"ValidationErrors":null}';
		return r;
	}

	private static String getPreLodgeSuccessResponse() {
		return '{"QuoteId":"310cb918-4b7e-4f50-8a84-d5b5da802063","QuoteGroupIdentifier":"7181bc10-7b1e-4512-b39b-fe0c9d4a3c48",'+
		       '"Details":[{"ProductCode":"MOT","CoverType":"MVCMP","PolicyNumber":"MOTFOA141668877M"},{"ProductCode":"GAP",'+
		       '"CoverType":"SWNGAP01","PolicyNumber":"GAPFOA121668878F"},{"ProductCode":"LTI","CoverType":"SWNPLT",'+
		       '"PolicyNumber":"LTIFOA191668879A"},{"ProductCode":"WAR","CoverType":"W5STARA60","PolicyNumber":"WARFOA201668880A"}],'+
		       '"Generated":"2019-05-17T05:32:06.0718552Z","Result":0,"Error":null,"ValidationErrors":null}';
	}
    
    private static String getPreLodgeSuccessResponse2() {
		return '{"QuoteId":"310cb918-4b7e-4f50-8a84-d5b5da802063","QuoteGroupIdentifier":"7181bc10-7b1e-4512-b39b-fe0c9d4a3c48",'+
		       '"Details":[{"ProductCode":"MOT","CoverType":"MVCMP","PolicyNumber":"MOTFOA141668877M"},{"ProductCode":"GAP",'+
		       '"CoverType":"SWNGAP01","PolicyNumber":"GAPFOA121668878F"},{"ProductCode":"LTI","CoverType":"SWNPLT",'+
		       '"PolicyNumber":"LTIFOA191668879A"},{"ProductCode":"WAR","CoverType":"W5STARA60","PolicyNumber":"WARFOA201668880A"}],'+
		       '"Generated":"2019-05-17T05:32:06.0718552Z","Result":0,"Error": {"OccurredAt": "2020-06-30T06:35:28.539Z",'+
			   '"Description": "Driver: Lav rai year first licensed value is invalid for the specified date of birth.  Please submit a valid year first licensed value for this driver.",'+
			   '"Code": "MPP12"},"ValidationErrors":null}';
	}

	private static void initEricSettings() {
		List<Eric_Setting__c> settings = new List<Eric_Setting__c>();
		Eric_Setting__c a = new Eric_Setting__c();
		a.Name = 'API Key';
		a.Param__c = 'API_KEY';
		a.Value__c = '1CFEC356';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'Policy Downloading URL';
		a.Param__c = 'POLICY_DOWNLOAD_URL';
		a.Value__c = 'https://prodtest.avea.com.au:2001';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST Dealer ID';
		a.Param__c = 'REST_DEALER_ID';
		a.Value__c = '7181bc10-7b1e-4512-b39b-fe0c9d4a3c48';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST Dealer Name';
		a.Param__c = 'REST_DEALER_NAME';
		a.Value__c = 'Savvy Finance + Insurance';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST Endpoint';
		a.Param__c = 'REST_END_POINT';
		a.Value__c = 'https://middlewaresit.ericinsurance.com.au:8088';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST_PWD';
		a.Param__c = 'REST_PWD';
		a.Value__c = 'g7fUa7Q2zx123456';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST User ID';
		a.Param__c = 'REST_USER_ID';
		a.Value__c = '068BCFF7-9009-4B66-8B7C-FFD55F5B844D';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'REST username';
		a.Param__c = 'REST_USERNAME';
		a.Value__c = 'savvydev';
		settings.add(a);

		a = new Eric_Setting__c();
		a.Name = 'Service end point URL';
		a.Param__c = 'END_POINT';
		a.Value__c = 'https://prodtest.avea.com.au:2001';
		settings.add(a);

		insert settings;
	}
}