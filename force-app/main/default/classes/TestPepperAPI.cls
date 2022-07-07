@isTest(SeeAllData=true)
public class TestPepperAPI extends TestAPILenders {
    private static String endPointApplication = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_ENDPOINT);
    public static Custom_Opportunity__c opp;

    public static testMethod void testGeneral() {
        opp = loadData();
        Application__c add = opp.Application__r;
        add.Application_Type__c = 'Personal';
        update add;
        Test.startTest();
        testPepperAPIManager();
        loadParameterService ( 'Pepper_Service_Endpoint', 'https://api-test.pepper.com.au/demo/v1/assetfinance/applications', 'Pepper endpoint ');
        testAPIPepper();
        testAPIPepperTest();
        testPepperDTO();
        testPepperResponseDTO();
        // Type values
        testPepperTypeValues();
        Application_Quoting__c quoting = new Application_Quoting__c();
        quoting.Opportunity__c = opp.Id;
        quoting.Name = 'Pepper Commercial';
        quoting.Loan_Product__c = 'Chattel Mortgage-Low-Doc';
        quoting.Insurance_NWC_Acceptance__c = 'A';
        quoting.Insurance_NWC_Retail_Price__c = 1;
        quoting.Insurance_NWC_Term__c = '1';
        insert quoting;
        add.Application_Type__c = 'Business';
        add.Business_ABN__c = '11111111111';
        update add;
        Application_Employment__c e = new Application_Employment__c();
        e.Unit_Number__c = '1';
        e.Application__c = add.Id;
        e.Address_Type__c = Utilities.ADDRESS_TYPE_FINANCE;
        insert e;
        testAPIPepper();
        add.Business_Structure__c = 'Individual or Sole Trader';
        update add;
        testAPIPepper();
        add.Trust_Name__c = 't';
        add.No_of_Directors__c = 0;
        update add;
        testAPIPepper();
        Test.stopTest();
    }
    
    private static void testPepperAPIManager(){
        PepperAPIManager p = new PepperAPIManager();
        List <SelectOption> usersAPIOptions = PepperAPIManager.getUserOptionsConnect();

        PepperApplicationResponseDTO res = new PepperApplicationResponseDTO();
        res.errorcode = '';
        String resJson = JSON.serialize(res);
        p.parseCreateApplicationResponse(resJson);
    }

    private static void testAPIPepper(){
        
        PepperApplicationService ppAppService = new PepperApplicationService();
    	PepperAPIManager ppAPIManager = new PepperAPIManager();
        
        try{
            ppAppService.requestApplication(ppAPIManager, opp, 'Hizquierdo', PepperAPIManager.Pepper_5Oh);
        }catch(GenericException ex){
            ppAPIManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return;
        }
        
        if (ppAPIManager.isError && 201 != ppAPIManager.responseStatus){
            //showErrorsPepperAPI();
        }else{
            String pepperAPI_AppNumber = ppAPIManager.pepperAppResponseDTO.application.applicationNo;
            String pepperAPI_ResponseContent = ppAPIManager.pepperAppResponseDTO.requestId;
            String pepperAPI_lastResponseApp = ppAPIManager.pepperAppResponseDTO.lastResponseApplication;
            System.debug('Application number:   ' + pepperAPI_AppNumber);
            System.debug('Request Id:   ' + pepperAPI_ResponseContent);
        }
    }

    @isTest static void testAPIPepper2(){
        
      PepperApplicationService ppAppService = new PepperApplicationService();
      PepperAPIManager ppAPIManager = new PepperAPIManager();
      MultiRequestMock requestMocks = new MultiRequestMock();
       
      SingleRequestMock fakeRes = getQuickMockRequest('{"errorCode": "INVALID_APPLICATION","errorMessage": "Error validating JSON. Error: - Missing required field \'product\'","requestId": "12975b60-48e5-11e8-bf5f-024abd6c08ae"}', 400);
      requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
      fakeRes = getQuickMockRequest('{"errorCode": "0001","errorMessage": "Failed Policy Validation","requestId": "ABC-123"}', 400);
      requestMocks.addRequestMock(endPointApplication+'/applications/consumer', fakeRes);
      Test.setMock(HttpCalloutMock.class, requestMocks);
      opp = loadData();
      
      Cloud_Documents__c doc = new Cloud_Documents__c();
      doc.Document_Type__c='Drivers License (Front & Back)';
      doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
      doc.Send_To_Lender__c=true;
      insert doc;
      doc = new Cloud_Documents__c();
      doc.Document_Type__c='Applicant 2 Drivers License';
      doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
      doc.Send_To_Lender__c=true;
      insert doc;
      
      test.startTest();
      ppAppService.requestApplication(ppAPIManager, opp, '1', PepperAPIManager.Pepper_MV);
      PepperAPIManager.saveLenderAPIResponse(ppAPIManager, opp.Id, 'Pepper Commercial', '1');
      test.stopTest();
   }

  @isTest static void testAPIPepper3(){
        
    PepperApplicationService ppAppService = new PepperApplicationService();
    PepperAPIManager ppAPIManager = new PepperAPIManager();
  
    MultiRequestMock requestMocks = new MultiRequestMock();
     
    SingleRequestMock fakeRes = getQuickMockRequest('{"application": {"applicationNo": "P-20190503004400"},"requestId": "d21f9a70-48e4-11e8-bf5f-024abd6c08ae"}', 200);
    requestMocks.addRequestMock(endPointApplication+'/applications/consumer', fakeRes);
    fakeRes = getQuickMockRequest('{"applicationId": "AD-1002502","responseMessage": "Document uploaded successfully","requestId": "aba58620-11fa-11eb-b1fa-025fad8dc2b8"}', 200);
    requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
    Test.setMock(HttpCalloutMock.class, requestMocks);
    opp = loadData();
    
    Cloud_Documents__c doc = new Cloud_Documents__c();
    doc.Document_Type__c='Drivers License (Front & Back)';
    doc.Custom_Opportunity__c = opp.Id;
    doc.Send_To_Lender__c=true;
    insert doc;
  
    test.startTest();
    ppAppService.requestApplication(ppAPIManager, opp, '1', PepperAPIManager.Pepper_MV);
    PepperAPIManager.saveLenderAPIResponse(ppAPIManager, opp.Id, 'Pepper Commercial', '1');
    test.stopTest();
 }

@isTest static void testAPIPepper4(){
        
  PepperApplicationService ppAppService = new PepperApplicationService();
  PepperAPIManager ppAPIManager = new PepperAPIManager();
  ppAPIManager.pepperAppResponseDTO = new PepperApplicationResponseDTO();
  MultiRequestMock requestMocks = new MultiRequestMock();
   
  SingleRequestMock fakeRes = getQuickMockRequest('', 429);
  requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
  Test.setMock(HttpCalloutMock.class, requestMocks);
  Test_DataGeneratorHelper.createApplication();

  Cloud_Documents__c doc = new Cloud_Documents__c();
  doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
  doc.Send_To_Lender__c=true;
  doc.Document_Type__c='Drivers License (Front & Back)';
  insert doc;

  Application_Quoting__c quoting = new Application_Quoting__c();
  quoting.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
	insert quoting;

  test.startTest();
  ppAppService.uploadDocumentsToPepper(ppAPIManager, Test_DataGeneratorHelper.tstOpportunity.Id, '1', true, '1');
  test.stopTest();
}

@isTest static void testAPIPepper5(){
        
  PepperApplicationService ppAppService = new PepperApplicationService();
  PepperAPIManager ppAPIManager = new PepperAPIManager();
  ppAPIManager.pepperAppResponseDTO = new PepperApplicationResponseDTO();
  MultiRequestMock requestMocks = new MultiRequestMock();
   
  SingleRequestMock fakeRes = getQuickMockRequest('', 503);
  requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
  Test.setMock(HttpCalloutMock.class, requestMocks);
  Test_DataGeneratorHelper.createApplication();

  Cloud_Documents__c doc = new Cloud_Documents__c();
  doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
  doc.Send_To_Lender__c=true;
  doc.Document_Type__c='Drivers License (Front & Back)';
  insert doc;

  Application_Quoting__c quoting = new Application_Quoting__c();
  quoting.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
	insert quoting;

  test.startTest();
  ppAppService.uploadDocumentsToPepper(ppAPIManager, Test_DataGeneratorHelper.tstOpportunity.Id, '1', true, '1');
  test.stopTest();
}

@isTest static void testAPIPepper6(){
        
  PepperApplicationService ppAppService = new PepperApplicationService();
  PepperAPIManager ppAPIManager = new PepperAPIManager();
  ppAPIManager.pepperAppResponseDTO = new PepperApplicationResponseDTO();
  MultiRequestMock requestMocks = new MultiRequestMock();
   
  SingleRequestMock fakeRes = getQuickMockRequest('', 503);
  requestMocks.addRequestMock(endPointApplication+'/applications/supportingDocuments', fakeRes);
  Test.setMock(HttpCalloutMock.class, requestMocks);
  Test_DataGeneratorHelper.createApplication();

  Cloud_Documents__c doc = new Cloud_Documents__c();
  doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
  doc.Send_To_Lender__c=true;
  doc.Document_Type__c='Drivers License (Front & Back)';
  insert doc;

  Application_Quoting__c quoting = new Application_Quoting__c();
  quoting.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
	insert quoting;

  test.startTest();
  ppAppService.uploadDocumentsToPepper(ppAPIManager, Test_DataGeneratorHelper.tstOpportunity.Id, '1', true, '1');
  test.stopTest();
}

@isTest static void testAPIPepper7(){
  PepperApplicationService ppAppService = new PepperApplicationService();
  PepperAPIManager ppAPIManager = new PepperAPIManager();
  ppAPIManager.pepperAppResponseDTO = new PepperApplicationResponseDTO();
  Test_DataGeneratorHelper.createOpportunity();
  Application_Quoting__c quoting = new Application_Quoting__c();
  quoting.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
	insert quoting;

  ppAppService.uploadDocumentsToPepper(ppAPIManager, Test_DataGeneratorHelper.tstOpportunity.Id, '1', true, '1');

  Cloud_Documents__c doc = new Cloud_Documents__c();
  doc.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
  doc.Send_To_Lender__c=true;

  insert doc;

  ppAppService.uploadDocumentsToPepper(ppAPIManager, Test_DataGeneratorHelper.tstOpportunity.Id, '1', true, '1');
  quoting.Goods_type__c = 'Other';
	update quoting;
  ppAppService.submitRequest(Test_DataGeneratorHelper.tstOpportunity.Id, null, false);
}

    private static void testAPIPepperTest(){
        PepperApplicationService ppAppService = new PepperApplicationService();
    	PepperAPIManager ppAPIManager = new PepperAPIManager();
        
        try{
            ppAppService.requestApplicationTest(ppAPIManager, opp, 'Hizquierdo', PepperAPIManager.Pepper_MV);
        }catch(GenericException ex){
            ppAPIManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return;
        }
    }
    
    private static void testPepperDTO(){
        PepperApplicationRequestDTO p = new PepperApplicationRequestDTO();
        p.loanWriter = '';
        p.merchant = 0;
        p.riskTier = '';
        p.supplierType = '';
        p.brokerDeclaration = false;
        p.brokersReference = '';
        p.messageToCreditAnalyst = '';

        p.primaryIndividualApplicant = new PepperApplicationRequestDTO.PrimaryApplicant();
        p.primaryIndividualApplicant.jointIncomeDeclaration = new PepperApplicationRequestDTO.JointIncomeDeclaration();
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerEmailAddress = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerFirstName = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerLastName = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerMobileNumber = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerIncomeFrequency = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerMiddleName = '';
        p.primaryIndividualApplicant.jointIncomeDeclaration.partnerIncome = 0.0;
        p.primaryIndividualApplicant.middleName = '';

        p.primaryIndividualApplicant.passport = new PepperApplicationRequestDTO.Passport();
        p.primaryIndividualApplicant.passport.number_m = '';
        p.primaryIndividualApplicant.passport.country = '';
        p.primaryIndividualApplicant.passport.expiry = '';

        p.primaryIndividualApplicant.employments = new List<PepperApplicationRequestDTO.Employment>();
        PepperApplicationRequestDTO.Employment emp = new PepperApplicationRequestDTO.Employment();
        emp.status = '';
        emp.occupation = '';
        emp.timeAtEmploymentInMonths = 0;
        emp.type_m = '';
        emp.employer = new PepperApplicationRequestDTO.Employer();
        emp.employer.name = '';
        emp.employer.contactName = '';
        emp.employer.address = new PepperApplicationRequestDTO.Address();
        emp.employer.address.addressLine1 = '';
        emp.employer.address.postcode = '';
        emp.employer.address.format = '';
        emp.employer.address.unitNumber = '';
        emp.employer.address.state = '';
        emp.employer.address.streetName = '';
        emp.employer.address.suburb = '';
        emp.employer.address.countryCode = '';
        emp.employer.address.streetDirection = '';
        emp.employer.address.streetNumber = '';
        emp.employer.address.streetType = '';
        emp.employer.address.level = '';
        emp.employer.address.addressLine2 = '';
        emp.employer.address.fullAddress = '';
        emp.employer.address.propertyName = '';
        emp.employer.address.timeAtAddressInMonths = 0;
        emp.employer.address.mailingAsResidential = false;
        emp.employer.address.residentialStatus = '';
        
        emp.employer.industry = '';
        emp.employer.ABN = '';
        emp.employer.mobile = '';
        emp.employer.phone = '';

        p.primaryIndividualApplicant.employments.add(emp);

        p.primaryIndividualApplicant.dateOfBirth = '';
        p.primaryIndividualApplicant.privacyFlag = false;
        p.primaryIndividualApplicant.lastName = '';
        p.primaryIndividualApplicant.numberOfDependants = 0;
        p.primaryIndividualApplicant.otherName = new PepperApplicationRequestDTO.OtherName();
        p.primaryIndividualApplicant.otherName.firstName = '';
        p.primaryIndividualApplicant.otherName.middleName = '';
        p.primaryIndividualApplicant.otherName.lastName = '';

        p.primaryIndividualApplicant.title = '';
        p.primaryIndividualApplicant.firstName = '';
        p.primaryIndividualApplicant.homePhone = '';
        p.primaryIndividualApplicant.country = '';
        p.primaryIndividualApplicant.email = '';
        p.primaryIndividualApplicant.workPhone = '';
        p.primaryIndividualApplicant.residencyStatus = '';
        p.primaryIndividualApplicant.applicantNCCP = new PepperApplicationRequestDTO.ApplicantNCCP();
        p.primaryIndividualApplicant.applicantNCCP.whatIsThePurposeOfThisApplication = '';
        p.primaryIndividualApplicant.applicantNCCP.whyDoesThisLoanTermSuitYourRequirements = '';
        p.primaryIndividualApplicant.applicantNCCP.whyDoesThisLoanTermSuitYourRequirementsDetails = '';
        p.primaryIndividualApplicant.applicantNCCP.whatAreYouLookingForInYourLoan = new List<String>{''};
        p.primaryIndividualApplicant.applicantNCCP.anyForeseeableChangesImpactingLoanRepayment = false;
        p.primaryIndividualApplicant.applicantNCCP.typeOfChangeExpected = '';
        p.primaryIndividualApplicant.applicantNCCP.howApplicantIntendToDoLoanRepaymentAfterChange = '';
        p.primaryIndividualApplicant.applicantNCCP.increaseInLoanAmountForFinancingCostOfInsurance = false;
        p.primaryIndividualApplicant.applicantNCCP.balloonPaymentAtTheEndOfTheLoan = false;
        p.primaryIndividualApplicant.applicantNCCP.whatToDoWithBalloonPaymentAtTheEndOfTheLoanTerm = '';
        p.primaryIndividualApplicant.applicantNCCP.whyAreYouLookingAtRefinancing = '';
        p.primaryIndividualApplicant.applicantNCCP.detailedReasonForRefinancing = '';
        p.primaryIndividualApplicant.applicantNCCP.isApplicantPlanningToRetireBeforeLoanCompletion = false;
        p.primaryIndividualApplicant.applicantNCCP.howTheApplicantProposeToRepayTheLoan = new PepperApplicationRequestDTO.ApplicantProposeToRepay();
        p.primaryIndividualApplicant.applicantNCCP.howTheApplicantProposeToRepayTheLoan.response = '';
        p.primaryIndividualApplicant.applicantNCCP.howTheApplicantProposeToRepayTheLoan.details = '';

        p.primaryIndividualApplicant.mobile = '';
        p.primaryIndividualApplicant.isForeignCitizen = false;
        p.primaryIndividualApplicant.addresses = new PepperApplicationRequestDTO.ApplicantAddresses();
        p.primaryIndividualApplicant.addresses.currentAddress = new PepperApplicationRequestDTO.Address();
        p.primaryIndividualApplicant.addresses.previousAddress = new List<PepperApplicationRequestDTO.Address>();

        p.primaryIndividualApplicant.gender = '';
        p.primaryIndividualApplicant.maritalStatus = '';
        p.primaryIndividualApplicant.driversLicence = new PepperApplicationRequestDTO.DriversLicence();
        p.primaryIndividualApplicant.driversLicence.number_m = '';
        p.primaryIndividualApplicant.driversLicence.cardNumber = '';
        p.primaryIndividualApplicant.driversLicence.expiry = '';
        p.primaryIndividualApplicant.driversLicence.state = '';

        p.additionalIndividualApplicant = new PepperApplicationRequestDTO.AdditionalApplicant();
        p.additionalIndividualApplicant.relationshipWithprimaryIndividualApplicant = '';
        
        p.serviceability = new PepperApplicationRequestDTO.Serviceability();
        p.serviceability.income = new List<PepperApplicationRequestDTO.Income>();
        p.serviceability.applicantAssets = new List<PepperApplicationRequestDTO.ApplicantAsset>();
        p.serviceability.liabilities = new List<PepperApplicationRequestDTO.Liability>();
        p.serviceability.basicExpenses = new List<PepperApplicationRequestDTO.Expense>();
        p.serviceability.otherExpenses = new List<PepperApplicationRequestDTO.Expense>();

        p.financialDetails = new PepperApplicationRequestDTO.FinancialDetails();

        p.assets = new List<PepperApplicationRequestDTO.Asset>();

        p.insurances = new List<PepperApplicationRequestDTO.Insurance>();

        p.paymentDetails = new PepperApplicationRequestDTO.PaymentDetails();


        PepperApplicationRequestDTO.Income income = new PepperApplicationRequestDTO.Income();
        income.type_m = '';
        income.owner = '';
        income.amount = 0.0;
        income.frequency = '';
        income.description = '';
        
        PepperApplicationRequestDTO.ApplicantAsset appAsset = new PepperApplicationRequestDTO.ApplicantAsset();
        appAsset.type_m = '';
        appAsset.value = 0.0;
        appAsset.description = '';
        appAsset.owner = '';

        PepperApplicationRequestDTO.Liability liability = new PepperApplicationRequestDTO.Liability();
        liability.type_m = '';
        liability.owner = '';
        liability.financier = '';
        liability.limit_m = 0.0;
        liability.outstandingAmount = 0.0;
        liability.description = '';
        liability.expenseFrequency = '';
        liability.expenseAmount = 0.0;

        PepperApplicationRequestDTO.Expense expense = new PepperApplicationRequestDTO.Expense();
        expense.type_m = '';
        expense.amount = 0.0;
        expense.frequency = '';
        expense.description = '';

        PepperApplicationRequestDTO.Insurance insurance = new PepperApplicationRequestDTO.Insurance();
        insurance.termInMonths = 0;
        insurance.premiumAmount = 0.0;
        insurance.policyNumber = '';
        insurance.startDate = '';
        insurance.insurerId = 0;
        insurance.type_m = '';

        PepperApplicationRequestDTO.PaymentDetails paymentDet = new PepperApplicationRequestDTO.PaymentDetails();
        paymentDet.accountName = '';
        paymentDet.accountNumber = '';
        paymentDet.bsb = '';
        
        PepperApplicationRequestDTO.Asset asset = new PepperApplicationRequestDTO.Asset();
        asset.nvic = '';
        asset.rbKey = '';
        asset.model = '';
        asset.colour = '';
        asset.registrationState = '';
        asset.balloonAmount = 0.0;
        asset.make = '';
        asset.hin = '';
        asset.bikeType = '';
        asset.complianceDate = '';
        asset.odometer = 0;
        asset.engineNumber = '';
        asset.vin = '';
        asset.assetCost = 0.0;
        asset.registrationNumber = '';
        asset.class_m = '';
        asset.variant = '';
        asset.yearOfManufacture = 0;
        asset.deposit = 0.0;
        asset.additionalAsset = '';
        asset.type_m = '';
        asset.hours = '';
        asset.description = '';
        asset.tradeIn = new PepperApplicationRequestDTO.TradeIn();
        asset.tradeIn.value = 0.0;
        asset.tradeIn.payoutAmount = 0.0;

        asset.additionalAssetDetails = new List<PepperApplicationRequestDTO.AdditionalAssetDetails>();
        PepperApplicationRequestDTO.AdditionalAssetDetails aa = new PepperApplicationRequestDTO.AdditionalAssetDetails();
        aa.subType = '';
        aa.class_m = '';
        aa.rbKey = '';
        aa.make = '';
        aa.model = '';
        aa.yearOfManufacture = 0;
        aa.vin = '';
        aa.registrationNumber = '';
        aa.engineNumber = '';
        aa.serialNumber = '';
        aa.registrationState = '';
        aa.description = '';
        asset.additionalAssetDetails.add(aa);
    }

    private static void testPepperResponseDTO(){
        PepperApplicationResponseDTO r = new PepperApplicationResponseDTO();
        r.errorCode = '';
        r.errorMessage = '';
        r.requestId = '';
        r.lastResponseApplication = '';
        r.application = new PepperApplicationResponseDTO.Application();
        r.application.applicationNo = '';
        r.reasonsForSubmissionFailure = null;
        PepperApplicationResponseDTO.ReasonsForSubmissionFailure 
          reasonsForSubmissionFailure = new 
            PepperApplicationResponseDTO.ReasonsForSubmissionFailure();
        reasonsForSubmissionFailure.applicationSection = '';
        reasonsForSubmissionFailure.errorMessage = '';
        reasonsForSubmissionFailure.errorContext = '';
    }

    private static void testPepperTypeValues(){
        PepperAPIManager manager = new PepperAPIManager();
        PepperApplicationService service = new PepperApplicationService(manager);
        // Applicant resicency
        System.assertEquals('Citizen', service.getApplicantResidency('Australian Citizen'));
        System.assertEquals('PR', service.getApplicantResidency('PR VISA'));
        System.assertEquals('Other', service.getApplicantResidency('Working VISA'));
        System.assertEquals('Other', service.getApplicantResidency('Student VISA'));
        System.assertEquals('Other', service.getApplicantResidency(null));

        // Asset Class
        System.assertEquals('New', service.getAssetClassValue('new'));
        System.assertEquals('Demo', service.getAssetClassValue('demo'));
        System.assertEquals('Used', service.getAssetClassValue('used'));
        System.assertEquals('Used', service.getAssetClassValue('xxxx'));
        System.assertEquals('Used', service.getAssetClassValue(null));

        // Asset Type
        System.assertEquals('MOTORVEHICLE', service.getAssetTypeValue('Car', null));
        System.assertEquals('MOTORBIKE', service.getAssetTypeValue('Motorbike', null));
        System.assertEquals('BOAT', service.getAssetTypeValue('Boat', null));
        System.assertEquals('PERSONAL WATERCRAFT', service.getAssetTypeValue('Boat', 'JetSki'));
        System.assertEquals('CARAVAN', service.getAssetTypeValue('Caravan', null));
        System.assertEquals('N/D', service.getAssetTypeValue('xxxxx', null));
        System.assertEquals('N/D', service.getAssetTypeValue(null, null));

        // Asset Category
        System.assertEquals('MOTORVEHICLE', service.getAssetCategoryValue('Car'));
        System.assertEquals('MOTORBIKE', service.getAssetCategoryValue('Motorbike'));
        System.assertEquals('MARINE', service.getAssetCategoryValue('Boat'));
        System.assertEquals('CARAVAN', service.getAssetCategoryValue('Caravan'));
        System.assertEquals('N/D', service.getAssetCategoryValue('XXXX'));
        System.assertEquals('N/D', service.getAssetCategoryValue(null));
    }

    public static testMethod void testGetPepperApplication() {

      Custom_Opportunity__c o = buildFullOpportunity();
      String user = 'myPepperUser';

      Test.startTest();
      PepperAPIManager manager = new PepperAPIManager();
      PepperApplicationService service = new PepperApplicationService();
      service.requestApplicationTest(manager, o, user, 'PepperPage');
      Application_Quoting__c quoting = new Application_Quoting__c();
      quoting.Opportunity__c = o.Id;
      quoting.Name = 'Pepper Commercial';
      quoting.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
      quoting.Insurance_GAP_Acceptance__c = 'A';
      quoting.Insurance_GAP_PayType__c = 'Financed';
      quoting.Insurance_GAP_Retail_Price__c = 1;
      quoting.Insurance_GAP_Term__c = '1';
      quoting.Insurance_AIC_Acceptance__c = 'A';
      quoting.Insurance_AIC_PayType__c = 'Financed';
      quoting.Insurance_AIC_Retail_Price__c = 1;
      quoting.Insurance_AIC_Term__c = '1';
      quoting.Insurance_Warranty_Acceptance__c = 'A';
      quoting.Insurance_Warranty_PayType__c = 'Financed';
      quoting.Insurance_Warranty_Retail_Price__c = 1;
      quoting.Insurance_Warranty_Term__c = '1';
      insert quoting;
      service.requestApplicationTest(manager, o, user, 'PepperPage');
      opp = loadData();
      quoting.Opportunity__c = opp.Id;
      update quoting;
      Application__c add = opp.Application__r;
      add.Application_Type__c = 'Business';		
	    add.Business_ABN_2__c = '11111111111';
      add.Current_Residence_Status_2__c = 'Own Outright';
      add.No_of_People__c = 2;
      add.Business_Structure__c = 'Partnership';
      add.Business_ABN__c = '11111111111';
      add.Business_ACN__c = '111111111';
      add.Applicant_2_living_in_the_same_address__c = 'Yes';
      update add;
      testAPIPepper();
      Application_Other_Asset__c a = makeOtherAsset(
        ApplicationService.PROPERTY_ASSET_TYPE);
      a.Application__c = add.Id;
      a.Category__c = 'Current Address Both Applicants';
      insert a;
      Application_Employment__c e = new Application_Employment__c();
      e.Unit_Number__c = '1';
      e.Application__c = add.Id;
      e.Address_Type__c = Utilities.ADDRESS_TYPE_FINANCE;
      insert e;
      testAPIPepper();
      add.Applicant_2_living_in_the_same_address__c = 'No';
      testAPIPepper();
      a = makeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);
      a.Application__c = add.Id;
      a.Category__c = 'Current Address Applicant 2';
      insert a;
      add.Trust_Name__c = 't';
      add.No_of_Directors__c = 1;
      update add;
      testAPIPepper();
      add.Business_Structure_2__c = 'Partnership';
      update add;
      testAPIPepper();
      Test.stopTest();
    }

    public static testMethod void testAPIServiceManager() {

      Custom_Opportunity__c o = buildFullOpportunity();
      String user = 'myPepperUser';

      Test.startTest();
      PepperAPIManager manager = new PepperAPIManager();

      List<SelectOption> uList = PepperAPIManager.getUserOptionsConnect();

      manager.clean();

      APIServiceManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_ENDPOINT);
      APIServiceManager.getLenderComments(o.Application__c);

      Custom_Opportunity__c opp = APIServiceManager.getCustomOpportunityForApplication(o);
      APIServiceManager.loadPreviousEmployments(opp);
      APIServiceManager.loadAddressFinanceDetails(opp);

      manager.getApplicantEmployments(o.Application__c, '1');
      manager.getApplicantEmployments(o.Application__c, '2');

      manager.getApplicantSecondJob(o.Application__c, '1');
      manager.getApplicantSecondJob(o.Application__c, '2');

      manager.getAppIncomes(o.Application__c);
      manager.getAppLoans(o.Application__c);
      manager.getAppCreditCards(o.Application__c);
      
      Test.stopTest();
    }

    private static Custom_Opportunity__c buildFullOpportunity() {
      Test_DataGeneratorHelper.createAccount();
      Account acc = Test_DataGeneratorHelper.tstAccount;
      Custom_Opportunity__c o = new Custom_Opportunity__c(Account__c = acc.Id
                , OwnerId = UserInfo.getUserId()
                , Status__c = 'Quote Sent'
                , First_Name__c = 'Test', Last_Name__c = 'Test', Mobile_Number__c = '0460000000'
                , Email_Address__c = 'test@savvy.com.au'
                );
      insert o;

      Application__c a = new Application__c();
      // Loan Details
      a.Type_of_Asset__c = 'Car';
      a.Purchase_Price__c = 25000.0;
      a.Finance_Amount__c = 23500.0;
      a.Length_of_Term__c = 5;
      a.Preferred_Repayment__c = 350.0;
      a.Repayment_Regularity__c = 'Month';
      a.No_of_People__c = 2;
      a.Application_Type__c = 'Personal';

      // Client details
      a.Title_1__c = 'Mr';
      a.First_Name__c = 'Test';
      a.Middle_Name__c = 'Test';
      a.Last_Name__c = 'Test';
      a.Date_of_Birth_1__c = '17/02/1980';
      a.Gender_1__c = 'M';
      a.Marital_Status_1__c = 'Married';
      a.No_of_Dependants_1__c = 2;
      a.Current_Residential_Status_1__c = 'Australian Citizen';
      a.Email_Address__c = 'test@savvy.com.au';
      a.Mobile_Number__c = '0460000000';
      a.Home_Phone__c = '0460000124';
      a.Work_Phone__c = '0460000125';
      a.Actual_Nationality_1__c = 'AUS';
      a.Drivers_License_1__c = '1234567890';
      a.Expiry_Date_1__c = '21/12/2030';
      a.Driver_Licence_State_Issue_1__c = 'SA';
      
      // Client Current Address
      a.Date_Moved_in_1__c = System.today().format();
      a.Unit_Number__c = '1';
      a.Street_Number__c = '145';
      a.Street_Address__c = 'Hutt';
      a.Street_Type__c = 'ST';
      a.Suburb__c = 'Adelaide';
      a.State__c = 'SA';
      a.Postcode__c = '5000';
      a.Current_Residence_Status_1__c = 'Renting(Agent)';
      a.Rent_per_month_1__c = 200.0;
      a.Residential_Payment_Frequency_1__c = 'Weekly';
      
      // Previous Address 1
      a.Date_From_1__c = '12/04/2019';
      a.Previous_Unit_Number_1__c = '2';
      a.Previous_Street_Number_1__c = '170';
      a.Previous_Street_Address_1__c = 'Angus';
      a.Previous_Street_Type_1__c = 'ST';
      a.Previous_Suburb_1__c = 'Adelaide';
      a.Previous_State_1__c = 'SA';
      a.Previous_Postcode_1__c = '5000';
      a.Previous_Country_1__c = 'AUS';
      a.Previous_Residence_Status_1__c = 'Own Outright';
      a.Previous_Street_Address_2nd_1__c = '';
      a.Previous_Overseas_City_1__c = '';
      a.Previous_Overseas_State_1__c = '';

      // Previous Address 1b
      a.Date_From_1b__c = '12/04/2018';
      a.Previous_Unit_Number_1b__c = '2';
      a.Previous_Street_Number_1b__c = '170';
      a.Previous_Street_Address_1b__c = 'Angus';
      a.Previous_Street_Type_1b__c = 'ST';
      a.Previous_Suburb_1b__c = 'Adelaide';
      a.Previous_State_1b__c = 'SA';
      a.Previous_Postcode_1b__c = '5000';
      a.Previous_Country_1b__c = 'AUS';
      a.Previous_Residence_Status_1b__c = 'Own Outright';
      a.Previous_Street_Address_2nd_1b__c = '';
      a.Previous_Overseas_City_1b__c = '';
      a.Previous_Overseas_State_1b__c = '';

      // Previous Address 1c
      a.Date_From_1c__c = '12/04/2017';
      a.Previous_Unit_Number_1c__c = '2';
      a.Previous_Street_Number_1c__c = '170';
      a.Previous_Street_Address_1c__c = 'Angus';
      a.Previous_Street_Type_1c__c = 'ST';
      a.Previous_Suburb_1c__c = 'Adelaide';
      a.Previous_State_1c__c = 'SA';
      a.Previous_Postcode_1c__c = '5000';
      a.Previous_Country_1c__c = 'AUS';
      a.Previous_Residence_Status_1c__c = 'Own Outright';
      a.Previous_Street_Address_2nd_1c__c = '';
      a.Previous_Overseas_City_1c__c = '';
      a.Previous_Overseas_State_1c__c = '';

      // Previous Address 1d
      a.Date_From_1d__c = '12/04/2016';
      a.Previous_Unit_Number_1d__c = '2';
      a.Previous_Street_Number_1d__c = '170';
      a.Previous_Street_Address_1d__c = 'Angus';
      a.Previous_Street_Type_1d__c = 'ST';
      a.Previous_Suburb_1d__c = 'Adelaide';
      a.Previous_State_1d__c = 'SA';
      a.Previous_Postcode_1d__c = '5000';
      a.Previous_Country_1d__c = 'AUS';
      a.Previous_Residence_Status_1d__c = 'Own Outright';
      a.Previous_Street_Address_2nd_1d__c = '';
      a.Previous_Overseas_City_1d__c = '';
      a.Previous_Overseas_State_1d__c = '';

      // Previous Address 1e
      a.Date_From_1e__c = '12/04/2015';
      a.Previous_Unit_Number_1e__c = '';
      a.Previous_Street_Number_1e__c = '';
      a.Previous_Street_Address_1e__c = '12 Aruba ST';
      a.Previous_Street_Type_1e__c = 'ST';
      a.Previous_Suburb_1e__c = 'Adelaide';
      a.Previous_State_1e__c = 'SA';
      a.Previous_Postcode_1e__c = '5000';
      a.Previous_Country_1e__c = 'ABW';
      a.Previous_Residence_Status_1e__c = 'Own Outright';
      a.Previous_Street_Address_2nd_1e__c = 'L34';
      a.Previous_Overseas_City_1e__c = 'Aruba';
      a.Previous_Overseas_State_1e__c = 'Aruba';

      // Employment
      a.Date_Started_1__c = '01/01/2021';
      a.Mode_of_Employment_1__c = 'Full Time';
      a.Reference_Name_1__c = 'Test';
      a.Current_Employer_Name_1__c = 'Savvy';
      a.Current_Employer_Phone_1__c = '0400456456';
      a.Employer_ABN_1__c = '125245854';
      a.Current_Work_Unit_Number_1__c = '2';
      a.Current_Work_Street_Number_1__c = '4';
      a.Current_Work_Address_1__c = 'The Parade';
      a.Current_Work_Street_Type_1__c = 'ST';
      a.Current_Work_Suburb_1__c = 'Norwood';
      a.Current_Work_State_1__c = 'SA';
      a.Current_Work_Postcode_1__c = '5067';
      a.Net_Income_1__c = 5000.0;
      a.Payment_Frequency_1__c = 'Monthly';

      // Previous employment
      a.Previous_Work_Country_1__c = 'AUS';
      a.Previous_Mode_of_Employment_1__c = 'Part Time';
      a.Start_Date_1__c = '01/01/2020';
      a.Finish_Date_1__c = '31/12/2020';
      a.Previous_Reference_Name_1__c = 'Test';
      a.Previous_Employer_Name_1__c = 'Savvy 2';
      a.Previous_Employer_Phone_1__c = '0400123123';
      a.Previous_Work_Unit_Number_1__c = '10';
      a.Previous_Work_Street_Number_1__c = '3';
      a.Previous_Work_Address_1__c = 'Hutt';
      a.Previous_Work_Street_Type_1__c = 'ST';
      a.Previous_Work_Suburb_1__c = 'Ademailde';
      a.Previous_Work_State_1__c = 'SA';
      a.Previous_Work_Postcode_1__c = '5000';

      // Applicant 2
      // Client details
      a.Title_2__c = 'Mrs';
      a.First_Name_2__c = 'Test';
      a.Middle_Name_2__c = 'Test';
      a.Last_Name_2__c = 'Test';
      a.Date_of_Birth_2__c = '17/02/1980';
      a.Gender_2__c = 'F';
      a.Marital_Status_2__c = 'Married';
      a.No_of_Dependants_2__c = 2;
      a.Current_Residential_Status_2__c = 'Australian Citizen';
      a.Email_Address_2__c = 'test@savvy.com.au';
      a.Mobile_Number_2__c = '0460000000';
      a.Home_Phone_2__c = '0460000124';
      a.Work_Phone_2__c = '0460000125';
      a.Actual_Nationality_2__c = 'AUS';
      // a.Drivers_License_2__c = '1234567890';
      // a.Expiry_Date_2__c = '21/12/2030';
      // a.Driver_Licence_State_Issue_2__c = 'SA';
      
      // Client Current Address
      a.Date_Moved_in_2__c = System.today().format();
      a.Unit_Number_2__c = '1';
      a.Street_Number_2__c = '145';
      a.Street_Address_2__c = 'Hutt';
      a.Street_Type_2__c = 'ST';
      a.Suburb_2__c = 'Adelaide';
      a.State_2__c = 'SA';
      a.Postcode_2__c = '5000';
      a.Current_Residence_Status_2__c = 'Renting(Agent)';
      
      // Previous Address 2
      a.Date_From_2__c = '12/04/2019';
      a.Previous_Unit_Number_2__c = '2';
      a.Previous_Street_Number_2__c = '170';
      a.Previous_Street_Address_2__c = 'Angus';
      a.Previous_Street_Type_2__c = 'ST';
      a.Previous_Suburb_2__c = 'Adelaide';
      a.Previous_State_2__c = 'SA';
      a.Previous_Postcode_2__c = '5000';
      a.Previous_Country_2__c = 'AUS';
      a.Previous_Residence_Status_2__c = 'Own Outright';
      a.Previous_Street_Address_2nd_2__c = '';
      a.Previous_Overseas_City_2__c = '';
      a.Previous_Overseas_State_2__c = '';

      // Previous Address 2b
      a.Date_From_2b__c = '12/04/2018';
      a.Previous_Unit_Number_2b__c = '2';
      a.Previous_Street_Number_2b__c = '170';
      a.Previous_Street_Address_2b__c = 'Angus';
      a.Previous_Street_Type_2b__c = 'ST';
      a.Previous_Suburb_2b__c = 'Adelaide';
      a.Previous_State_2b__c = 'SA';
      a.Previous_Postcode_2b__c = '5000';
      a.Previous_Country_2b__c = 'AUS';
      a.Previous_Residence_Status_2b__c = 'Own Outright';
      a.Previous_Street_Address_2nd_2b__c = '';
      a.Previous_Overseas_City_2b__c = '';
      a.Previous_Overseas_State_2b__c = '';

      // Previous Address 2c
      a.Date_From_2c__c = '12/04/2017';
      a.Previous_Unit_Number_2c__c = '2';
      a.Previous_Street_Number_2c__c = '170';
      a.Previous_Street_Address_2c__c = 'Angus';
      a.Previous_Street_Type_2c__c = 'ST';
      a.Previous_Suburb_2c__c = 'Adelaide';
      a.Previous_State_2c__c = 'SA';
      a.Previous_Postcode_2c__c = '5000';
      a.Previous_Country_2c__c = 'AUS';
      a.Previous_Residence_Status_2c__c = 'Own Outright';
      a.Previous_Street_Address_2nd_2c__c = '';
      a.Previous_Overseas_City_2c__c = '';
      a.Previous_Overseas_State_2c__c = '';

      // Previous Address 2d
      a.Date_From_2d__c = '12/04/2016';
      a.Previous_Unit_Number_2d__c = '2';
      a.Previous_Street_Number_2d__c = '170';
      a.Previous_Street_Address_2d__c = 'Angus';
      a.Previous_Street_Type_2d__c = 'ST';
      a.Previous_Suburb_2d__c = 'Adelaide';
      a.Previous_State_2d__c = 'SA';
      a.Previous_Postcode_2d__c = '5000';
      a.Previous_Country_2d__c = 'AUS';
      a.Previous_Residence_Status_2d__c = 'Own Outright';
      a.Previous_Street_Address_2nd_2d__c = '';
      a.Previous_Overseas_City_2d__c = '';
      a.Previous_Overseas_State_2d__c = '';

      // Previous Address 2e
      a.Date_From_2e__c = '12/04/2015';
      a.Previous_Unit_Number_2e__c = '';
      a.Previous_Street_Number_2e__c = '';
      a.Previous_Street_Address_2e__c = '12 Aruba ST';
      a.Previous_Street_Type_2e__c = 'ST';
      a.Previous_Suburb_2e__c = 'Adelaide';
      a.Previous_State_2e__c = 'SA';
      a.Previous_Postcode_2e__c = '5000';
      a.Previous_Country_2e__c = 'ABW';
      a.Previous_Residence_Status_2e__c = 'Own Outright';
      a.Previous_Street_Address_2nd_2e__c = 'L34';
      a.Previous_Overseas_City_2e__c = 'Aruba';
      a.Previous_Overseas_State_2e__c = 'Aruba';

      // Employment
      a.Date_Started_2__c = '01/01/2021';
      a.Mode_of_Employment_2__c = 'Full Time';
      a.Reference_Name_2__c = 'Test';
      a.Current_Employer_Name_2__c = 'Savvy';
      a.Current_Employer_Phone_2__c = '0400456456';
      a.Current_Work_Unit_Number_2__c = '2';
      a.Current_Work_Street_Number_2__c = '4';
      a.Current_Work_Address_2__c = 'The Parade';
      a.Current_Work_Street_Type_2__c = 'ST';
      a.Current_Work_Suburb_2__c = 'Norwood';
      a.Current_Work_State_2__c = 'SA';
      a.Current_Work_Postcode_2__c = '5067';

      // Previous employment
      a.Previous_Work_Country_2__c = 'AUS';
      a.Previous_Mode_of_Employment_2__c = 'Part Time';
      a.Start_Date_2__c = '01/01/2020';
      a.Finish_Date_2__c = '31/12/2020';
      a.Previous_Reference_Name_2__c = 'Test';
      a.Previous_Employer_Name_2__c = 'Savvy 2';
      a.Previous_Employer_Phone_2__c = '0400123123';
      a.Previous_Work_Unit_Number_2__c = '10';
      a.Previous_Work_Street_Number_2__c = '3';
      a.Previous_Work_Address_2__c = 'Hutt';
      a.Previous_Work_Street_Type_2__c = 'ST';
      a.Previous_Work_Suburb_2__c = 'Ademailde';
      a.Previous_Work_State_2__c = 'SA';
      a.Previous_Work_Postcode_2__c = '5000';
      a.Net_Income_2__c = 5000.0;
      a.Payment_Frequency_2__c = 'Monthly';

      // Savings
      a.Bank_Value__c = 1500.0;
      a.Bank_Name__c = 'Bank Savvings';
      a.Super_Value_How_Much__c = 15000.0;
      a.Furniture_Value__c = 35000.0;
      
      // Living expenses
      a.Basic_Living_Expenses_Per_Month__c = '1000';
      a.Mobile_Phone_Internet_Pay_TV_per_Month__c = '200';
      a.Travel_Transport_Expenses_per_Month__c = '300';
      a.Childcare_Child_Maintenance_Per_Month__c = '400';
      a.Insurance_Expenses_per_Month__c = '500';
      a.Other_Expenses_per_Month__c = '600';
      a.Income_Type_Expenses__c = 'Other expenses';
      a.Applicant_2_living_in_the_same_address__c = 'Yes';      

      insert a;

      // Other Employments
      Application_Employment__c othEmp = new Application_Employment__c();
			othEmp.Application__c = a.Id;
      othEmp.Type__c = 'Previous Job';
			othEmp.Applicant__c = '1';
			othEmp.Country__c = 'AUS';
      othEmp.Unit_Number__c = '1';
      othEmp.Street_Number__c = '12';
      othEmp.Work_Address__c = 'PreviousADD_12';
      othEmp.Street_Type__c = 'ST';
      othEmp.Suburb__c = 'Enfield';
      othEmp.Postcode__c = '5012';
      othEmp.Employment_Type__c = 'Casual';
      othEmp.Start_Date__c = DateUtils.convertToDate('01/01/2019');
      othEmp.Finish_Date__c = DateUtils.convertToDate('31/12/2019');
			insert othEmp;

      othEmp = new Application_Employment__c();
			othEmp.Application__c = a.Id;
      othEmp.Type__c = 'Previous Job';
			othEmp.Applicant__c = '2';
			othEmp.Country__c = 'AUS';
      othEmp.Unit_Number__c = '1';
      othEmp.Street_Number__c = '12';
      othEmp.Work_Address__c = 'PreviousADD_12';
      othEmp.Street_Type__c = 'ST';
      othEmp.Suburb__c = 'Enfield';
      othEmp.Postcode__c = '5012';
      othEmp.Employment_Type__c = 'Casual';
      othEmp.Start_Date__c = DateUtils.convertToDate('01/01/2019');
      othEmp.Finish_Date__c = DateUtils.convertToDate('31/12/2019');
			insert othEmp;

      // Incomes
      List<Application_Income__c> incList = new List<Application_Income__c>();
      Application_Income__c ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Family Part A & B';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Child Support';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Rental Income';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Trust Income';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Parenting Payment Single';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '1';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Maintenance';
      incList.add(ai);

      // Incomes for Applicant #2
      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '2';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Trust Income';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '2';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Parenting Payment Single';
      incList.add(ai);

      ai = new Application_Income__c();
      ai.Application__c = a.Id;
      ai.Applicant__c = '2';
      ai.Detail__c = 'Any detail';
      ai.Frequency__c = 'Weekly';
      ai.Income__c = 7500.0;
      ai.Type__c = 'Maintenance';
      incList.add(ai);

      insert incList;

      // Property assets
      List<Application_Other_Asset__c> othAssetsList = new List<Application_Other_Asset__c>();
      Application_Other_Asset__c oa = makeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);

      oa = makeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);
      oa.Application__c = a.Id;
      oa.Has_Loan__c = 'Y';
      oa.Lender__c = 'Nab';
      oa.Amount_Owing__c = 5000.0;
      oa.Payment__c = 350.0;
      oa.Frequency__c = 'Weekly';
      othAssetsList.add(oa);


      // Vehicle assets
      oa = makeOtherAsset(ApplicationService.VEHICLE_ASSET_TYPE);
      oa.Application__c = a.Id;
      oa.Has_Loan__c = 'Y';
      oa.Lender__c = 'Nab';
      oa.Amount_Owing__c = 5000.0;
      oa.Payment__c = 350.0;
      oa.Frequency__c = 'Weekly';
      othAssetsList.add(oa);

      // Other Assets
      oa = makeOtherAsset(ApplicationService.OTHER_ASSET_TYPE);
      oa.Application__c = a.Id;
      othAssetsList.add(oa);
      insert othAssetsList;

      // Other Loans
      List<Application_Loan__c> loaList = new List<Application_Loan__c>();
      Application_Loan__c l = null;
      for (String tp: new List<String>{
        'Debt/Default Arrangements', 'Line of Credit', 'Payday Loan', 'Personal Loan', 'Other'}) {
        l = new Application_Loan__c();
        l.Type__c = tp;
        l.Amount_Owing__c = 1;
        l.Lender__c = 'l';
        l.Payment__c = 1;
        l.Application__c = a.Id;
        loaList.add(l);
      }
      insert loaList;

      // Crdit Cards
      List<Application_Credit_Card__c> ccList = new List<Application_Credit_Card__c>();
      Application_Credit_Card__c cc = null;
      for (String issuer: new List<String>{
        'BANK 1', 'BANK 2', 'BANK 3'}) {
        cc = new Application_Credit_Card__c();
        cc.Amount_Owing__c = 1;
        cc.Issuer__c = 'i';
        cc.Limit__c = 1;
        cc.Application__c = a.Id;
        ccList.add(cc);
        }
        insert ccList;

      // Asset detail
      Application_Asset_Detail__c asset = new Application_Asset_Detail__c(
        Type__c = 'Car', Condition__c = 'new', Lender__c = 'ANZ', Type_Loan__c = 'Consumer', Make__c = 'AUD', 
        Variant__c = 'AUDA1-SI1610TV32016A', Model__c = 'AUD001', Rego__c = 'xxxx1025', Rego_State__c = 'SA', 
        VIN__c = 'WDD2050422F071012', Actual_KM__c = 45000, Year__c = 2016, Fees__c = 1, Series__c='s',
              Redbook_Key__c='r'
      );
      insert asset;

      // Servicing
      
      // Update Opportunity
      o.Application__c = a.Id;
      o.Application_AssetDetail__c = asset.Id;
      update o;

      // Application Quoting
      Application_Quoting__c quoting = new Application_Quoting__c();
      quoting.Application__c = a.Id;
      quoting.Opportunity__c = o.Id;
      quoting.Name = 'Pepper MV';
      quoting.Insurance_GAP_Acceptance__c = 'A';
      quoting.Insurance_GAP_Retail_Price__c = 1000.0;
      quoting.Insurance_LTI_Acceptance__c = 'A';
      quoting.Insurance_LTI_Retail_Price__c = 900.0;
      quoting.Insurance_Warranty_Acceptance__c = 'A';
      quoting.Insurance_Warranty_Retail_Price__c = 800.0;
      insert quoting;

      return o;
    }

    private static Application_Other_Asset__c makeOtherAsset(String recordType) {
        Id recordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(recordType);
        Application_Other_Asset__c r = new Application_Other_Asset__c();
        r.RecordTypeId = recordTypeId;
        r.Has_Loan__c = 'N';
        r.Description__c = 'X';
        r.Value__c = 10000;
        return r;
    }

    private static SingleRequestMock getQuickMockRequest(String body, Integer code) {
      SingleRequestMock r = new SingleRequestMock(
          code, 'Complete', body, null
      );
      return r;
    }
}