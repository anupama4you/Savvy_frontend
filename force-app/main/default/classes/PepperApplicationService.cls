public class PepperApplicationService {

  private PepperAPIManager ppManager;
  String endPointApplication;
  String consumerKey;
  String clientId;
  String clientSecret;
  Integer merchantId;
      
  Date dt = Date.newInstance(2008, 1, 1);
  
  Integer scaleDecimal = 2;
  
  
  public PepperApplicationService (){
      loadSettings();
  }

  public PepperApplicationService (PepperAPIManager ppManager){
    this();
    this.ppManager = ppManager;
  }
  
  private void loadSettings(){
    endPointApplication = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_ENDPOINT);
    clientId = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_CLIENT_ID);
    clientSecret = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_CLIENT_SECRET);
    if (String.isNotBlank(clientId)) {
      String mId = PepperAPIManager.getParameterService(PepperAPIManager.PEPPER_SERVICE_MERCHANT_ID);
      if (mId.isNumeric()) {
        merchantId = Integer.valueOf(mId);
      } else {
        System.debug(LoggingLevel.Error, 'Merchand Id must be a number, please check it out in API Settings. Current value [' + mId + ']');
        throw new GenericException('Merchand Id must be a number, please check it out in API Settings. Current value [' + mId + ']');
      }
    }
  }
  
  public void requestApplicationTest(PepperAPIManager ppManager, Custom_Opportunity__c opp, String user, String page){
      if (this.ppManager == null) {
          this.ppManager = ppManager;
      }
      PepperApplicationRequestDTO app = getPepperApplication(opp, user, page);
      String body = serializeJsonApp(app);
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Body: [' + body + ']'));
  }

  public PepperAPIManager requestApplication(PepperAPIManager ppManager, Custom_Opportunity__c opp, String user, String page){
    System.debug('requestApplication...');
    if (this.ppManager == null) {
      System.debug('local ppManager is null');
      this.ppManager = ppManager;
    }

    if(
      submitRequest(opp.Id, null, false)
    ){

      Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(opp.Id, null);	
      quotingNull(quoting);

      String endPoint = 'consumer';

      if ('Pepper Commercial'.equals(quoting.Name)) {
        endPoint = 'commercial';
      }

      ConnectionRESTWs.param p = prepareRequest('/applications/'+endPoint, ConnectionRESTWs.POST);
      PepperApplicationRequestDTO app = getPepperApplication(opp, user, page);
      p.body = serializeJsonApp(app);
      this.ppManager.reqBody = p.body;
      this.ppManager.addInfoMessage('Body: [' + p.body + ']');
      
      HttpResponse res;
      try{
        res = ConnectionRESTWs.invoke(p);
      }catch (GenericException ex) {
        this.ppManager.addErrorMessage(ex.getMessage());
      }

      this.ppManager.processHttpResponse(res);
      if (!this.ppManager.isError) {
        System.debug('Debug Pepper Application:::********************************************************** - F');
        if(ppManager.responseStatus == PepperConstants.STATUS_OK && ppManager.pepperAppResponseDTO.application.applicationNo != null){
            uploadDocumentsToPepper(ppManager, opp.Id, ppManager.pepperAppResponseDTO.application.applicationNo, false, user);
        }
      } else {
        this.ppManager.addErrorMessage(this.ppManager.message);
      }

      // validateResponse (res);
      // try{
      //   System.debug('@ *Pepper Application*. -[' + this.ppManager.responseMessage + ']');
      //   this.ppManager.parseCreateApplicationResponse(this.ppManager.responseMessage);
      // }catch (GenericException ex) {
      //   this.ppManager.isError = true;
      //   this.ppManager.message = ex.getMessage();
      //   throw new GenericException ('[Pepper Application]' + this.ppManager.message, ex);
      // }       
      
    } else {
      ppManager.isError = true;
    }
    return this.ppManager;
  }
  
  // private void validateResponse (HttpResponse resp){
  //   ppManager.processHttpResponse(resp);

  //   ppManager.isError = false;
  //   ppManager.message = '@!Ok';
  //   if (resp != null) {
  //     ppManager.responseStatus = resp.getStatusCode();
  //     ppManager.responseMessage = resp.getBody();
  //     if (ppManager.responseStatus != MacquarieConstants.STATUS_OK){
  //       ppManager.isError = true;
  //       ppManager.message = '[' + ppManager.responseMessage + ']';
  //       if (ppManager.responseStatus == 401) {
  //         ppManager.message = '[Pepper API] Unauthorised. Either the provided username and password combination is invalid, or the user is not allowed to access the content provided by the requested URL';
  //       } else if (ppManager.responseStatus == 401) {
  //         ppManager.message = '[Pepper API] Unauthorised. Either the provided username and password combination is invalid, or the user is not allowed to access the content provided by the requested URL';
  //       }
  //     }
  //   } else {
  //     ppManager.isError = true;
  //     ppManager.message = '@Please, check response service';
  //   }
  //   System.debug('@validateResponse: -[' + ppManager.message + ']');
  // }
  
  public PepperApplicationRequestDTO getPepperApplication(Custom_Opportunity__c opp, String user, String page){
      if (StringUtils.isNullOrEmpty(user)){
          throw new GenericException ('Missing Pepper user. Please select one.');
      }
      PepperApplicationRequestDTO pepperApp = new PepperApplicationRequestDTO();
      Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(opp.Id, null);
      quotingNull(quoting);

      Boolean pepperCommercial = false;
      opp = PepperAPIManager.getCustomOpportunityForApplication(opp);
      Application__c add = opp.Application__r;
      
      if ('Pepper Commercial'.equals(quoting.Name)) {
        pepperCommercial = true;
        if (((String.isNotBlank(add.Trust_Name__c) && add.No_of_Directors__c > 0 
        && 'Partnership'.equals(add.Business_Structure_2__c)) || 
          'Partnership'.equals(add.Business_Structure__c)) && 
            add.No_of_People__c == 2) {

          if ('No'.equals(add.Applicant_2_living_in_the_same_address__c)) {
            if ('Own Outright'.equals(add.Current_Residence_Status_2__c) || 
              'Mortgage'.equals(add.Current_Residence_Status_2__c)) {
              residentialPropertyPartnership(add.Id, 'Current Address Applicant 2', 
                'Please add the residential property of the applicant 2 or select the category of the residential property of the applicant 2');
            }
          } else {
            if ('Own Outright'.equals(add.Current_Residence_Status_1__c) || 
              'Mortgage'.equals(add.Current_Residence_Status_1__c)) {
              residentialPropertyPartnership(add.Id, 
                'Current Address Both Applicants', 
                  'Please select the category of the residential property of the applicants');
            }
          }
        }

        if (String.isNotBlank(add.Trust_Name__c) && add.No_of_Directors__c > 0 && 
        String.isNotBlank(add.Business_ABN_2__c) && String.isBlank(
          add.Business_Structure_2__c)) {
          throw new GenericException (
            'Please select an option of business structure of applicant 1');
        }
      }

      // 
      pepperApp.loanWriter = 'salesforce.dev@savvy.com.au'.equals(user)? 'QuantumSavvy.User1' : user;
      pepperApp.merchant = merchantId;
      pepperApp.riskTier = quoting.Client_Tier__c;
      pepperApp.supplierType = this.getSupplierType(quoting.Loan_Type__c, quoting.Private_Sales__c);
      pepperApp.brokerDeclaration = true;
      pepperApp.brokersReference = 'OPPID:' + opp.Id;
      pepperApp.messageToCreditAnalyst = PepperAPIManager.getLenderComments(add.Id);
      
      // Primary Applicant details
      if (pepperCommercial) {
        pepperApp.primaryApplicant = getPrimaryApplicant(opp, add, quoting, pepperCommercial);
        
        if (quoting.Loan_Product__c.contains('Full-Doc')) {
          pepperApp.applicationType = 'FullDoc';
        } else {
          pepperApp.applicationType = 'FastTrack';
        }
        
        pepperApp.privacyFlag = true;
        pepperApp.submissionRequired = true;
        // assets
        pepperApp.assets = buildAssets(opp, quoting, add, pepperCommercial);
        pepperApp.additionalApplicants = getAdditionalApplicants(opp, add, quoting, pepperCommercial);
      } else {
        pepperApp.primaryIndividualApplicant = getPrimaryApplicant(opp, add, quoting, pepperCommercial);
        // Serviceability
        pepperApp.serviceability = buildServiceability(opp, add);
        pepperApp.assets = buildAssets(opp, quoting, add, pepperCommercial);

        if (add.No_of_People__c == 2) {
          pepperApp.additionalIndividualApplicant = getAdditionalApplicant(
            opp, add, quoting, pepperCommercial);
        }
      }   

      // Finance Details
      pepperApp.financialDetails = getFinancialDetails(quoting);

      // Payment details
      // pepperApp.paymentDetails = getPaymentDetails ( add.Accountant_Name__c, add.Business_ACN__c, add.Business_ABN__c);

      // insurances
      pepperApp.insurances = getAppInsurances (quoting);
      
      return pepperApp;
  }
  
  private PepperApplicationRequestDTO.PrimaryApplicant getPrimaryApplicant(Custom_Opportunity__c opp, Application__c add, Application_Quoting__c quoting, Boolean pepperCommercial){
    PepperApplicationRequestDTO.PrimaryApplicant primaryApp = new PepperApplicationRequestDTO.PrimaryApplicant();
      
    if (pepperCommercial) {
      primaryApp.applicantId = '1';
      primaryApp.applicantType = 'Entity';
      if ('Business'.equals(add.Application_Type__c)) {
        primaryApp.abn = add.Business_ABN__c.replaceAll('[^0-9]', '');
        if (String.isNotBlank(add.Business_ACN__c)) {
          primaryApp.acn = add.Business_ACN__c.replaceAll('[^0-9]', '');
        }
        primaryApp.industry = 'OTHER SERVICES';
        primaryApp.mainBusinessActivity = add.Nature_of_Business__c;
        primaryApp.addresses = tradingAddress(primaryApp.addresses, add);
        primaryApp.addresses.tradingAddress.addressId = '1';
        /*
        primaryApp.authorisedSignatoryDetails = new 
          PepperApplicationRequestDTO.AuthorisedSignatoryDetails();
        primaryApp.authorisedSignatoryDetails.title = 'Other';
        primaryApp.authorisedSignatoryDetails.firstName = add.First_Name__c;
        primaryApp.authorisedSignatoryDetails.lastName = add.Last_Name__c;
        */
      }
    } else {
      primaryApp.title = StringUtils.validateNull(add.Title_1__c);
      primaryApp.firstName = add.First_Name__c;
      primaryApp.middleName = add.Middle_Name__c;
      primaryApp.lastName = add.Last_Name__c;
      primaryApp.dateOfBirth = formatDate(add.Date_of_Birth_1__c);

      primaryApp.gender = getGender(add.Gender_1__c);
      primaryApp.maritalStatus = getMaritalStatusValue(add.Marital_Status_1__c);
      primaryApp.numberOfDependants = 0;
      if (add.No_of_Dependants_1__c != null) {
        primaryApp.numberOfDependants = add.No_of_Dependants_1__c.intValue();
      }
      primaryApp.residencyStatus = getApplicantResidency(add.Current_Residential_Status_1__c);
      primaryApp.email = add.Email_Address__c;
      primaryApp.mobile = StringUtils.removeAllCharacters(add.Mobile_Number__c);
      if (StringUtils.isNullOrEmpty(primaryApp.mobile)){
        primaryApp.homePhone = StringUtils.removeAllCharacters(add.Home_Phone__c);
        if (StringUtils.isNullOrEmpty(primaryApp.homePhone)){
          primaryApp.workPhone = StringUtils.removeAllCharacters(add.Work_Phone__c);
        }
      }
      primaryApp.privacyFlag  = true;
      
      primaryApp.isForeignCitizen = false;
      if (!'Australian Citizen'.equals(add.Current_Residential_Status_1__c)) {
        primaryApp.isForeignCitizen = true;
        if (String.isNotBlank(add.Actual_Nationality_1__c)) {
          primaryApp.country = add.Actual_Nationality_1__c;
        }
      }
      
      primaryApp.driversLicence = getDriversLicence(add.Drivers_License_1__c, DateUtils.convertToDate(add.Expiry_Date_1__c) , add.Driver_Licence_State_Issue_1__c);
      
      primaryApp.addresses = getAddressesPrimaryApp(opp, add, pepperCommercial
        , '0', 0);
      
      primaryApp.employments = getEmployments_Applicant_1(opp, add);
      
      // primaryApp.references = getReferences(opp, add);
      primaryApp.applicantNCCP = buildApplicantNCCP(quoting);
    }
                                          
    return primaryApp;
  }
  
  private PepperApplicationRequestDTO.AdditionalApplicant getAdditionalApplicant(Custom_Opportunity__c opp, Application__c add, Application_Quoting__c quoting, Boolean pepperCommercial){
    PepperApplicationRequestDTO.AdditionalApplicant additionalApp = new PepperApplicationRequestDTO.AdditionalApplicant();
    
    additionalAppAddresses(additionalApp, opp, add, pepperCommercial, '2', 3);
     
    additionalApp.title = StringUtils.validateNull(add.Title_2__c);
    additionalApp.firstName = add.First_Name_2__c;
    additionalApp.middleName = add.Middle_Name_2__c;
    additionalApp.lastName = add.Last_Name_2__c;
    additionalApp.dateOfBirth = formatDate(add.Date_of_Birth_2__c);
    additionalApp.gender = getGender(add.Gender_2__c);
    additionalApp.maritalStatus = getMaritalStatusValue(add.Marital_Status_2__c);
    additionalApp.numberOfDependants = 0;
    if (add.No_of_Dependants_2__c != null) {
      additionalApp.numberOfDependants = add.No_of_Dependants_2__c.intValue();
    }
    additionalApp.residencyStatus = getApplicantResidency(add.Current_Residential_Status_2__c);
            
    additionalApp.email = add.Email_Address_2__c;
    additionalApp.mobile = StringUtils.removeAllCharacters(add.Mobile_Number_2__c);
    if (StringUtils.isNullOrEmpty(additionalApp.mobile)){
      additionalApp.homePhone = StringUtils.removeAllCharacters(add.Home_Phone_2__c);
      if (StringUtils.isNullOrEmpty(additionalApp.homePhone)){
        additionalApp.workPhone = StringUtils.removeAllCharacters(add.Work_Phone_2__c);
      }
    }
    additionalApp.privacyFlag  = true;
    additionalApp.isForeignCitizen = false;
    if (!'Australian Citizen'.equals(add.Current_Residential_Status_2__c)) {
      additionalApp.isForeignCitizen = true;
      if (String.isNotBlank(add.Actual_Nationality_2__c)) {
        additionalApp.country = add.Actual_Nationality_2__c;
      }
    }
            
    additionalApp.driversLicence = getDriversLicence(add.Drivers_License_2__c, DateUtils.convertToDate(add.Expiry_Date_2__c) , add.Driver_Licence_State_Issue_2__c);
    additionalApp.applicantNCCP = buildApplicantNCCP(quoting);
    additionalApp.employments = getEmployments_Applicant_2 (opp, add);
      
    return additionalApp;
  }

  private List<PepperApplicationRequestDTO.AdditionalApplicant> 
  getAdditionalApplicants(Custom_Opportunity__c opp, Application__c add, 
    Application_Quoting__c quoting, Boolean pepperCommercial){
  List<PepperApplicationRequestDTO.AdditionalApplicant> additionalApplicants = 
    new List<PepperApplicationRequestDTO.AdditionalApplicant>();
  PepperApplicationRequestDTO.AdditionalApplicant additionalApp;
  
  if (String.isNotBlank(add.Trust_Name__c)) {
    
    if (add.No_of_Directors__c > 0) {
      additionalApp = new PepperApplicationRequestDTO.AdditionalApplicant();
      additionalApp.relationshipType = 'Trustee';
      additionalApp.applicantType = 'Entity';
      additionalApp.organisationDetails = new 
        PepperApplicationRequestDTO.OrganisationDetails();
      additionalApp.organisationDetails.mainBusinessActivity = 
        add.Nature_of_Business_2__c;
      additionalApp.organisationDetails.abn = add.Business_ABN_2__c.replaceAll(
        '[^0-9]', '');
      additionalApp.organisationDetails.industry = 'OTHER SERVICES';
      /*
      additionalApp.organisationDetails.authorisedSignatoryDetails = new 
        PepperApplicationRequestDTO.AuthorisedSignatoryDetails();
      additionalApp.organisationDetails.authorisedSignatoryDetails.title = 'Other';
      additionalApp.organisationDetails.authorisedSignatoryDetails.firstName = add.First_Name__c;
      additionalApp.organisationDetails.authorisedSignatoryDetails.lastName = add.Last_Name__c;
      */
      additionalApp.addresses = new 
        PepperApplicationRequestDTO.ApplicantAddresses();
      additionalApp.addresses.tradingAddress = new 
        PepperApplicationRequestDTO.Address();
      additionalApp.addresses.tradingAddress.format = 'Standard';
      additionalApp.addresses.tradingAddress.registeredAddressSameAsTrading = 
        true;
      additionalApp.addresses.tradingAddress.postalAddressSameAsTrading = true;
      additionalApp.addresses.tradingAddress.countryCode = 
        PepperConstants.COUNTRYCODE;
      additionalApp.addresses.tradingAddress.addressId = '2';
      additionalApp.addresses.tradingAddress.streetName = add.Street_Address__c;
      additionalApp.addresses.tradingAddress.unitNumber = add.Unit_Number__c;
      additionalApp.addresses.tradingAddress.streetNumber = add.Street_Number__c;
      additionalApp.addresses.tradingAddress.streetType = 
        LatitudeUtils.getLabelPicklistField(
          Application__c.Street_Type__c.getDescribe(), add.Street_Type__c);
      additionalApp.addresses.tradingAddress.suburb = add.Suburb__c;
      additionalApp.addresses.tradingAddress.state = add.State__c;
      additionalApp.addresses.tradingAddress.postcode = add.Postcode__c;
      additionalApp.applicantId = '2';
      additionalApp.relatedApplicants = new List<String>();
      additionalApp.relatedApplicants.add('1');
  
      // Other assets
      //additionalApp.applicantAssets = buildOtherAssets(add, false, false);
  
      // Liabilities
      //additionalApp.liabilities = buildLiabilities(add, false, false);
      additionalApplicants.add(additionalApp);

																					 

      additionalApp = getAdditionalApp('3', '2', add, opp, pepperCommercial, '3'
        , 4, 'Partnership'.equals(add.Business_Structure_2__c) ? true : false);
      additionalApplicants.add(additionalApp);

      if ('Partner'.equals(additionalApp.relationshipType) && 
        add.No_of_People__c == 2) {
        additionalApp = getPartner(additionalApp, '4', '2', add, opp, 
          pepperCommercial);
        additionalApplicants.add(additionalApp);
      }
    } else {
      additionalApp = getAdditionalApp('2', '1', add, opp, pepperCommercial, '2' 
        ,3, false);
      additionalApp.relationshipType = 'Trustee';
      additionalApplicants.add(additionalApp);
    }
  }else{
    additionalApp = getAdditionalApp('2', '1', add, opp, pepperCommercial, '2', 
      3, 'Partnership'.equals(add.Business_Structure_2__c) ? true : false);
    additionalApplicants.add(additionalApp);

    if ('Partner'.equals(additionalApp.relationshipType) && add.No_of_People__c 
      == 2) {
      additionalApp = getPartner(additionalApp, '3', '1', add, opp, 
        pepperCommercial);
      additionalApplicants.add(additionalApp);
    }
  }

  return additionalApplicants;
}
  
  private PepperApplicationRequestDTO.ApplicantAddresses 
    getAddressesPrimaryApp(Custom_Opportunity__c opp, Application__c app, 
      Boolean pepperCommercial, String id, Integer pos){
      PepperApplicationRequestDTO.ApplicantAddresses r = new PepperApplicationRequestDTO.ApplicantAddresses();
      r.currentAddress = new PepperApplicationRequestDTO.Address();
      r.previousAddress = new List<PepperApplicationRequestDTO.Address>();

      // Current address
      Date movedIn = DateUtils.convertToDate(app.Date_Moved_in_1__c);
      r.currentAddress = getAddress(
            app.Street_Number__c, app.Street_Address__c, app.Unit_Number__c, 
            app.Street_Type__c, app.Suburb__c, app.State__c, app.Postcode__c, PepperConstants.COUNTRYCODE, 
            'Current', movedIn, System.today(), app.Current_Residence_Status_1__c, true, null, null, null, false);
      Integer months = null;
      if (movedIn != null){
          Integer movedInYears = DateUtils.getHowManyYears(movedIn, System.today());
          Integer movedInMonths = DateUtils.getHowManyMonths(movedIn, System.today());
          months = (movedInYears * 12) + movedInMonths;
      }
      if (months != null && months < 24) {
        Date previousMovedIn = null;
        // 1) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_1__c)) {
          previousMovedIn = DateUtils.convertToDate(app.Date_From_1__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_1__c, app.Previous_Street_Address_1__c, app.Previous_Unit_Number_1__c, 
                         app.Previous_Street_Type_1__c, app.Previous_Suburb_1__c, app.Previous_State_1__c, app.Previous_Postcode_1__c, 
                         app.Previous_Country_1__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1__c, false, 
                         app.Previous_Street_Address_2nd_1__c, app.Previous_Overseas_City_1__c, app.Previous_Overseas_State_1__c, false));
          movedIn = previousMovedIn;
        }
        // 2) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_1b__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_1b__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_1b__c, app.Previous_Street_Address_1b__c, app.Previous_Unit_Number_1b__c, 
                         app.Previous_Street_Type_1b__c, app.Previous_Suburb_1b__c, app.Previous_State_1b__c, app.Previous_Postcode_1b__c, 
                         app.Previous_Country_1b__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1b__c, false,
                         app.Previous_Street_Address_2nd_1b__c, app.Previous_Overseas_City_1b__c, app.Previous_Overseas_State_1b__c, false));
          movedIn = previousMovedIn;
        }
        // 3) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_1c__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_1c__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_1c__c, app.Previous_Street_Address_1c__c, app.Previous_Unit_Number_1c__c, 
                         app.Previous_Street_Type_1c__c, app.Previous_Suburb_1c__c, app.Previous_State_1c__c, app.Previous_Postcode_1c__c, 
                         app.Previous_Country_1c__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1c__c, false, 
                         app.Previous_Street_Address_2nd_1c__c, app.Previous_Overseas_City_1c__c, app.Previous_Overseas_State_1c__c, false));
          movedIn = previousMovedIn;
        }
        // 4) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_1d__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_1d__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_1d__c, app.Previous_Street_Address_1d__c, app.Previous_Unit_Number_1d__c, 
                         app.Previous_Street_Type_1d__c, app.Previous_Suburb_1d__c, app.Previous_State_1d__c, app.Previous_Postcode_1d__c, 
                         app.Previous_Country_1d__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1d__c, false, 
                         app.Previous_Street_Address_2nd_1d__c, app.Previous_Overseas_City_1d__c, app.Previous_Overseas_State_1d__c, false));
          movedIn = previousMovedIn;
        }
        // 5) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_1e__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_1e__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_1e__c, app.Previous_Street_Address_1e__c, app.Previous_Unit_Number_1e__c, 
                         app.Previous_Street_Type_1e__c, app.Previous_Suburb_1e__c, app.Previous_State_1e__c, app.Previous_Postcode_1e__c, app.Previous_Country_1e__c, 
                         'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1e__c, false,
                         app.Previous_Street_Address_2nd_1e__c, app.Previous_Overseas_City_1e__c, app.Previous_Overseas_State_1e__c, false));
          movedIn = previousMovedIn;
        }
        
      }

      addressId(r, pepperCommercial, id, pos);

      return r;
  }

  private PepperApplicationRequestDTO.ApplicantAddresses 
    getAddressesAdditionalApp(Custom_Opportunity__c opp, Application__c app, 
      Boolean pepperCommercial, String id, Integer pos){
      PepperApplicationRequestDTO.ApplicantAddresses r = new PepperApplicationRequestDTO.ApplicantAddresses();
      r.currentAddress = new PepperApplicationRequestDTO.Address();
      r.previousAddress = new List<PepperApplicationRequestDTO.Address>();

      // Current address
      Date movedIn = DateUtils.convertToDate(app.Date_Moved_in_2__c);
      r.currentAddress = getAddress(
            app.Street_Number_2__c, app.Street_Address_2__c, app.Unit_Number_2__c, 
            app.Street_Type_2__c, app.Suburb_2__c, app.State_2__c, app.Postcode_2__c, PepperConstants.COUNTRYCODE, 
            'Current', movedIn, System.today(), app.Current_Residence_Status_2__c, true, null, null, null, false);
      Integer months = null;
      if (movedIn != null){
          Integer movedInYears = DateUtils.getHowManyYears(movedIn, System.today());
          Integer movedInMonths = DateUtils.getHowManyMonths(movedIn, System.today());
          months = (movedInYears * 12) + movedInMonths;
      }
      if (months != null && months < 24) {
        Date previousMovedIn = null;
        // 1) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_2__c)) {
          previousMovedIn = DateUtils.convertToDate(app.Date_From_2__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_2__c, app.Previous_Street_Address_2__c, app.Previous_Unit_Number_2__c, 
                         app.Previous_Street_Type_2__c, app.Previous_Suburb_2__c, app.Previous_State_2__c, app.Previous_Postcode_2__c, 
                         app.Previous_Country_2__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_1__c, false, 
                         app.Previous_Street_Address_2nd_2__c, app.Previous_Overseas_City_2__c, app.Previous_Overseas_State_2__c, false));
          movedIn = previousMovedIn;
        }
        // 2) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_2b__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_2b__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_2b__c, app.Previous_Street_Address_2b__c, app.Previous_Unit_Number_2b__c, 
                         app.Previous_Street_Type_2b__c, app.Previous_Suburb_2b__c, app.Previous_State_2b__c, app.Previous_Postcode_2b__c, 
                         app.Previous_Country_2b__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_2b__c, false,
                         app.Previous_Street_Address_2nd_2b__c, app.Previous_Overseas_City_2b__c, app.Previous_Overseas_State_2b__c, false));
          movedIn = previousMovedIn;
        }
        // 3) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_2c__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_2c__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_2c__c, app.Previous_Street_Address_2c__c, app.Previous_Unit_Number_2c__c, 
                         app.Previous_Street_Type_2c__c, app.Previous_Suburb_2c__c, app.Previous_State_1c__c, app.Previous_Postcode_2c__c, 
                         app.Previous_Country_2c__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_2c__c, false, 
                         app.Previous_Street_Address_2nd_2c__c, app.Previous_Overseas_City_2c__c, app.Previous_Overseas_State_2c__c, false));
          movedIn = previousMovedIn;
        }
        // 4) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_2d__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_2d__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_2d__c, app.Previous_Street_Address_2d__c, app.Previous_Unit_Number_2d__c, 
                         app.Previous_Street_Type_2d__c, app.Previous_Suburb_2d__c, app.Previous_State_2d__c, app.Previous_Postcode_2d__c, 
                         app.Previous_Country_2d__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_2d__c, false, 
                         app.Previous_Street_Address_2nd_2d__c, app.Previous_Overseas_City_2d__c, app.Previous_Overseas_State_2d__c, false));
          movedIn = previousMovedIn;
        }
        // 5) Previous Address
        if (!StringUtils.isNullOrEmpty(app.Previous_Street_Address_2e__c)){
          previousMovedIn = DateUtils.convertToDate(app.Date_From_2e__c);
          r.previousAddress.add(
              getAddress(app.Previous_Street_Number_2e__c, app.Previous_Street_Address_2e__c, app.Previous_Unit_Number_2e__c, 
                         app.Previous_Street_Type_2e__c, app.Previous_Suburb_2e__c, app.Previous_State_2e__c, app.Previous_Postcode_2e__c, 
                         app.Previous_Country_2e__c, 'Previous', previousMovedIn, movedIn,  app.Previous_Residence_Status_2e__c, false,
                         app.Previous_Street_Address_2nd_2e__c, app.Previous_Overseas_City_2e__c, app.Previous_Overseas_State_2e__c, false));
          movedIn = previousMovedIn;
        }
      }

      addressId(r, pepperCommercial, id, pos);
      
      return r;
  }
  
  private PepperApplicationRequestDTO.DriversLicence getDriversLicence(String number_m, Date expiry, String state){
      if (String.isNotBlank(number_m)) {
        PepperApplicationRequestDTO.DriversLicence r = new PepperApplicationRequestDTO.DriversLicence();
        r.number_m = number_m; //replace number_m by number
        r.expiry = DateUtils.convertToString(expiry, DateUtils.YYYY_MM_DD) ;
        r.state = state;
        return r;
      }
      return null;
  }
      
  private PepperApplicationRequestDTO.Address getAddress(
        String streetNumber, String streetName, String unitNumber, String streetType, String suburb,
        String state, String sPostcode, String countryCode, String type_m, Date movedIn, Date movedOut, 
        String residentialStatus, Boolean isAppAddress, String addressLine2, String overseasCity, String overseasState, Boolean skipTimeAtAddress){
      
    PepperApplicationRequestDTO.Address address = new PepperApplicationRequestDTO.Address();
    if (!skipTimeAtAddress) {
      address.timeAtAddressInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (movedIn, movedOut));
    }
    if (isAppAddress) {
      address.mailingAsResidential = true;
    }
    if (!StringUtils.isNullOrEmpty(residentialStatus)){
      address.residentialStatus = Utilities.salesforceValueToMessageCode_Description(residentialStatus, Utilities.Pepper_RESIDENTIAL_STATUS);
    }
    address.format = PepperConstants.ADDRESS_FORMAT_NONSTANDARD;
    if (PepperConstants.COUNTRYCODE.equals(countryCode)) {
      // Australian address
      // address.format = PepperConstants.ADDRESS_FORMAT_STANDARD;
      String unitNum = StringUtils.validateNull(unitNumber);
      if (String.isNotBlank(unitNum)) {
        address.unitNumber = unitNum;
      }
      address.streetNumber = streetNumber;
      address.streetName = streetName;
      address.streetType = streetType;

      String r = '';
      if (String.isNotBlank(address.unitNumber)) {
        r += address.unitNumber + '/';
      }
      if (String.isNotBlank(address.streetNumber)) {
        r += address.streetNumber + ' ';
      }
      r += address.streetName;
      r += ' ' + address.streetType;
      address.addressLine1 = r;
      // Clean 
      address.unitNumber = null;
      address.streetNumber = null;
      address.streetName = null;
      address.streetType = null;
      
      address.suburb = suburb;
      address.state = state;
    } else {
      // Overseas address
      // address.format = PepperConstants.ADDRESS_FORMAT_NONSTANDARD;
      address.addressLine1 = streetName;
      if (String.isNotBlank(addressLine2)) {
        address.addressLine2 = addressLine2;
      }
      address.suburb = overseasCity;
      address.state = PepperConstants.ADDRESS_INT_STATE;
    }
    address.postcode = sPostcode;
    address.countryCode = countryCode;
    address.fullAddress = getFullAddress(address);
    
    return address;
  }

  private List<PepperApplicationRequestDTO.Employment> getEmployments_Applicant_1(Custom_Opportunity__c opp, Application__c app){
      List<PepperApplicationRequestDTO.Employment> r = new List<PepperApplicationRequestDTO.Employment>();
      PepperApplicationRequestDTO.Employment emp = new PepperApplicationRequestDTO.Employment();
      //Current Employment
      emp.status = PepperConstants.EMPLOYMENT_STATUS_CURRENT;
      // emp.occupation = sf doesn't have a list, it is free input text
      Date startJob = DateUtils.convertToDate(app.Date_Started_1__c);
      Date endJob = System.today();
      
      emp.timeAtEmploymentInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (startJob, endJob));
      emp.type_m = Utilities.salesforceValueToMessageCode_Description(app.Mode_of_Employment_1__c, Utilities.Pepper_EMPLOYMENT_TYPE);
      // Employer details
      emp.employer = buildEmploymentEmployer(app.Reference_Name_1__c, app.Current_Employer_Name_1__c, app.Current_Employer_Phone_1__c, app.Employer_ABN_1__c);
      emp.employer.address = getAddress(
        app.Current_Work_Street_Number_1__c, app.Current_Work_Address_1__c, app.Current_Work_Unit_Number_1__c, 
        app.Current_Work_Street_Type_1__c, app.Current_Work_Suburb_1__c, app.Current_Work_State_1__c, 
        app.Current_Work_Postcode_1__c, PepperConstants.COUNTRYCODE, 
        'Current', startJob , System.today(), null, false, null, null, null, true
      );

      r.add(emp);
      
      //Previous Employment
      if (PepperConstants.COUNTRYCODE.equals(app.Previous_Work_Country_1__c) && 
         String.isNotBlank(app.Previous_Mode_of_Employment_1__c)){

        emp = new PepperApplicationRequestDTO.Employment();
        //Current Employment
        emp.status = PepperConstants.EMPLOYMENT_STATUS_PREVIOUS;
        // emp.occupation = sf doesn't have a list, it is free input text
        startJob = DateUtils.convertToDate(app.Start_Date_1__c);
        endJob = DateUtils.convertToDate(app.Finish_Date_1__c);
        emp.timeAtEmploymentInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (startJob, endJob));
        emp.type_m = Utilities.salesforceValueToMessageCode_Description(app.Previous_Mode_of_Employment_1__c, Utilities.Pepper_EMPLOYMENT_TYPE);
        // Employer details
        emp.employer = buildEmploymentEmployer(app.Previous_Reference_Name_1__c, app.Previous_Employer_Name_1__c, app.Previous_Employer_Phone_1__c, null);
        emp.employer.address = getAddress(
          app.Previous_Work_Street_Number_1__c, app.Previous_Work_Address_1__c, app.Previous_Work_Unit_Number_1__c, 
          app.Previous_Work_Street_Type_1__c, app.Previous_Work_Suburb_1__c, app.Previous_Work_State_1__c, 
          app.Previous_Work_Postcode_1__c, app.Previous_Work_Country_1__c, 
          'Previous', startJob , endJob, null, false, null, null, null, true
        );

        r.add(emp);
      }

      // Check for other previous employments
      List<Application_Employment__c> employments = this.ppManager.getApplicantEmployments(app.Id, '1');
      System.debug('Total other emplyments >> ' + employments.size());
      for (Application_Employment__c e: employments) {
        PepperApplicationRequestDTO.Employment tmp = buildPepperEmployment(e, 'Previous');
        if (tmp != null) {
          tmp.status = PepperConstants.EMPLOYMENT_STATUS_PREVIOUS;
          r.add(tmp);
        }
      }
      return r;
  }

  private List<PepperApplicationRequestDTO.Employment> getEmployments_Applicant_2(Custom_Opportunity__c opp, Application__c app){
    List<PepperApplicationRequestDTO.Employment> r = new List<PepperApplicationRequestDTO.Employment>();
      PepperApplicationRequestDTO.Employment emp = new PepperApplicationRequestDTO.Employment();
      //Current Employment
      emp.status = PepperConstants.EMPLOYMENT_STATUS_CURRENT;
      // emp.occupation = sf doesn't have a list, it is free input text
      Date startJob = DateUtils.convertToDate(app.Date_Started_2__c);
      Date endJob = System.today();
      emp.timeAtEmploymentInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (startJob, endJob));
      emp.type_m = Utilities.salesforceValueToMessageCode_Description(app.Mode_of_Employment_2__c, Utilities.Pepper_EMPLOYMENT_TYPE);
      // Employer details
      emp.employer = buildEmploymentEmployer(app.Reference_Name_2__c, app.Current_Employer_Name_2__c, app.Current_Employer_Phone_2__c, null);
      emp.employer.address = getAddress(
        app.Current_Work_Street_Number_2__c, app.Current_Work_Address_2__c, app.Current_Work_Unit_Number_2__c, 
        app.Current_Work_Street_Type_2__c, app.Current_Work_Suburb_2__c, app.Current_Work_State_2__c, 
        app.Current_Work_Postcode_2__c, PepperConstants.COUNTRYCODE, 
        'Current', startJob , System.today(), null, false, null, null, null, true
      );

      r.add(emp);
      
      //Previous Employment
      if (PepperConstants.COUNTRYCODE.equals(app.Previous_Work_Country_2__c) && 
         String.isNotBlank(app.Previous_Mode_of_Employment_2__c)){

        emp = new PepperApplicationRequestDTO.Employment();
        //Current Employment
        emp.status = PepperConstants.EMPLOYMENT_STATUS_PREVIOUS;
        // emp.occupation = sf doesn't have a list, it is free input text
        startJob = DateUtils.convertToDate(app.Start_Date_2__c);
        endJob = DateUtils.convertToDate(app.Finish_Date_2__c);
        emp.timeAtEmploymentInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (startJob, endJob));
        emp.type_m = Utilities.salesforceValueToMessageCode_Description(app.Previous_Mode_of_Employment_2__c, Utilities.Pepper_EMPLOYMENT_TYPE);
        // Employer details
        emp.employer = buildEmploymentEmployer(app.Previous_Reference_Name_2__c, app.Previous_Employer_Name_2__c, app.Previous_Employer_Phone_2__c, null);
        emp.employer.address = getAddress(
          app.Previous_Work_Street_Number_2__c, app.Previous_Work_Address_2__c, app.Previous_Work_Unit_Number_2__c, 
          app.Previous_Work_Street_Type_2__c, app.Previous_Work_Suburb_2__c, app.Previous_Work_State_2__c, 
          app.Previous_Work_Postcode_2__c, app.Previous_Work_Country_2__c, 
          'Previous', startJob , endJob, null, false, null, null, null, true
        );

        r.add(emp);
      }

      // Check for other previous employments
      List<Application_Employment__c> employments = this.ppManager.getApplicantEmployments(app.Id, '2');
      for (Application_Employment__c e: employments) {
        PepperApplicationRequestDTO.Employment tmp = buildPepperEmployment(e, 'Previous');
        if (tmp != null) {
          tmp.status = PepperConstants.EMPLOYMENT_STATUS_PREVIOUS;
          r.add(tmp);
        }
      }
      return r;
  }
  
  private PepperApplicationRequestDTO.Employer buildEmploymentEmployer(String contactName, String name, String phone, String ABN) {
      PepperApplicationRequestDTO.Employer r = new PepperApplicationRequestDTO.Employer();
      r.contactName = contactName;
      r.name = name;
      if (String.isNotBlank(phone)) {
        r.phone = StringUtils.removeAllCharacters(phone);
        if (phone.startsWith('04')) {
          r.mobile = r.phone;
          r.phone = null;
        }
      }
      r.ABN = ABN;
      return r;
  }
  
  private PepperApplicationRequestDTO.ApplicantNCCP buildApplicantNCCP (Application_Quoting__c quoting){
    PepperApplicationRequestDTO.ApplicantNCCP r = new PepperApplicationRequestDTO.ApplicantNCCP();

    r.whatIsThePurposeOfThisApplication = 'Purchase the asset';
    if ('Refinance'.equals(quoting.Loan_Type__c)) {
      r.whatIsThePurposeOfThisApplication = 'Refinance loan on the asset';

      r.whyAreYouLookingAtRefinancing = 'Other';
      r.detailedReasonForRefinancing = quoting.Loan_Purpose__c;
    }
    if (this.ppManager.hasAcceptedInsurances(quoting)) {
      r.whatIsThePurposeOfThisApplication += ' plus finance insurances';
    }

    r.whyDoesThisLoanTermSuitYourRequirements = 'Other';
    r.whyDoesThisLoanTermSuitYourRequirementsDetails = 'No specifics';

    r.whatAreYouLookingForInYourLoan = new List<String>{'Service'};
    r.anyForeseeableChangesImpactingLoanRepayment = false;
    r.typeOfChangeExpected = null;    // N/A
    r.howApplicantIntendToDoLoanRepaymentAfterChange = null; // N/A

    r.increaseInLoanAmountForFinancingCostOfInsurance = true;

    r.balloonPaymentAtTheEndOfTheLoan = false;
    if (quoting.Residual_Value__c > 0) {
      r.balloonPaymentAtTheEndOfTheLoan = true;
      r.whatToDoWithBalloonPaymentAtTheEndOfTheLoanTerm = 'Trade in for a new vehicle';
    }

    r.isApplicantPlanningToRetireBeforeLoanCompletion = false;
    r.howTheApplicantProposeToRepayTheLoan.response = 'Other';
    r.howTheApplicantProposeToRepayTheLoan.details = 'With Income Generated';

    return r;
  }
  
  private List<PepperApplicationRequestDTO.Asset> buildAssets(
              Custom_Opportunity__c opp, Application_Quoting__c quoting, Application__c app, Boolean pepperCommercial){
      List<PepperApplicationRequestDTO.Asset> r = new List<PepperApplicationRequestDTO.Asset>();
      PepperApplicationRequestDTO.Asset asset = new PepperApplicationRequestDTO.Asset();
      Application_Asset_Detail__c ad = opp.Application_AssetDetail__r;
      asset.category = getAssetCategoryValue(quoting.Goods_type__c);
      asset.type_m = getAssetTypeValue(quoting.Goods_type__c, app.Type_of_Asset__c);
      asset.class_m = getAssetClassValue(ad.Condition__c);
      if ('Car'.equals(ad.Type__c)) {
        Glass_Variant__c v = GlassServicesHelper.getVariantByCode(ad.Variant__c);
        if (v != null)  {
          asset.nvic = v.NVIC__c;
          if (v.Average_Kms__c > 0) {
            asset.odometer = v.Average_Kms__c.intValue() * 1000;
          }
        }
      } else {
        asset.make = ad.Make__c;
        asset.model = ad.Model__c;
        asset.variant = ad.Variant__c;
        asset.odometer = 0;
      }
      if (!pepperCommercial) {
        asset.additionalAsset = 'None';
      }
      if ('Motorbike'.equals(quoting.Goods_type__c) && String.isNotBlank(quoting.Goods_sub_type__c)) {
        asset.bikeType = quoting.Goods_sub_type__c;
      }
      asset.yearOfManufacture = ad.Year__c.intValue();
      asset.colour = ad.Colour__c;
      if ('Marine'.equals(ad.Type__c)) {
        asset.hin = ad.VIN__c;
      } else {
        asset.vin = ad.VIN__c;
      }
      if (ad.Actual_KM__c > 0) {
        asset.odometer = ad.Actual_KM__c.intValue();
      }
      asset.engineNumber = ad.Engine_No__c;
      asset.registrationNumber = ad.Rego__c;
      if (String.isNotBlank(ad.Rego_State__c)) {
        asset.registrationState = ad.Rego_State__c;
      } else {
        asset.registrationState = app.State__c;
      }
      // Quoting details
      asset.assetCost = quoting.Vehicle_Price__c;
      asset.deposit = quoting.Deposit__c;
      asset.tradeIn.value = quoting.Trade_In__c;
      asset.tradeIn.payoutAmount = quoting.Payout_On__c;
      asset.balloonAmount = 0.0;
      if (quoting.Residual_Value__c != null) {
        asset.balloonAmount = quoting.Residual_Value__c;
      }

      r.add(asset);
      return r;
  }
  
  private PepperApplicationRequestDTO.FinancialDetails getFinancialDetails (Application_Quoting__c quoting){
      PepperApplicationRequestDTO.FinancialDetails r = new PepperApplicationRequestDTO.FinancialDetails();
      r.loanTermInMonths = String.valueOf(quoting.Term__c);
      r.establishmentFee = quoting.Application_Fee__c;
      r.paymentFrequency = 'Monthly';
      r.establishmentFeeOccurrence = 'Financed';
      r.originationFee = NumberUtils.convertDecimalToScale(quoting.DOF__c, scaleDecimal);
      r.paymentMode = quoting.Payment__c;
      r.interestRate =  NumberUtils.convertDecimalToScale(quoting.Client_Rate__c, scaleDecimal);
      return r;
  }
  
  private List<PepperApplicationRequestDTO.Insurance> getAppInsurances(Application_Quoting__c quoting) {
    List<PepperApplicationRequestDTO.Insurance> r = new List<PepperApplicationRequestDTO.Insurance>();
    if ('A'.equals(quoting.Insurance_GAP_Acceptance__c) && 'Financed'.equals(quoting.Insurance_GAP_PayType__c)) {
      r.add(buildInsurance('GI', quoting.Insurance_GAP_Retail_Price__c, quoting.Insurance_GAP_Term__c));
    } else if ('A'.equals(quoting.Insurance_TAI_Acceptance__c)) {
      r.add(buildInsurance('GI', quoting.Insurance_TAI_Retail_Price__c, null));
    }
    if ('A'.equals(quoting.Insurance_LTI_Acceptance__c)) {
      r.add(buildInsurance('CCI', quoting.Insurance_LTI_Retail_Price__c, null));
    } else if ('A'.equals(quoting.Insurance_AIC_Acceptance__c) && 'Financed'.equals(quoting.Insurance_AIC_PayType__c)) {
      r.add(buildInsurance('Pepper Commercial'.equals(quoting.Name)?'BCI':'CCI', quoting.Insurance_AIC_Retail_Price__c, quoting.Insurance_AIC_Term__c));
    }
    if ('A'.equals(quoting.Insurance_Warranty_Acceptance__c) && 'Financed'.equals(quoting.Insurance_Warranty_PayType__c)) {
      r.add(buildInsurance('EMW', quoting.Insurance_Warranty_Retail_Price__c, quoting.Insurance_Warranty_Term__c));
    } else if ('A'.equals(quoting.Insurance_NWC_Acceptance__c)) {
      r.add(buildInsurance('EMW', quoting.Insurance_NWC_Retail_Price__c, quoting.Insurance_NWC_Term__c));
    }
    return (r.isEmpty() ? null : r);
  }

  private PepperApplicationRequestDTO.Insurance buildInsurance(String type_m, Decimal premiumAmount, String termInMonths) {
    PepperApplicationRequestDTO.Insurance r = new PepperApplicationRequestDTO.Insurance();
    r.type_m = type_m; //replace type_m by type
    r.premiumAmount = premiumAmount.setScale(2);
    if (termInMonths != null) {
      r.termInMonths = Integer.valueOf(termInMonths);
    }
    return r;
  }
  /*
  private PepperApplicationRequestDTO.PaymentDetails getPaymentDetails (String accountName, String accountNumber, String bsb){
    if (!StringUtils.isNullOrEmpty(accountName) && !StringUtils.isNullOrEmpty(accountNumber)){
      PepperApplicationRequestDTO.PaymentDetails paymentDetails = new PepperApplicationRequestDTO.PaymentDetails();
      paymentDetails.accountName = accountName;
      paymentDetails.accountNumber = accountNumber;
      paymentDetails.bsb = bsb;
      return paymentDetails;
    }
    return null;
   }
  */
  private String getGender (String gender){
      if (gender != null && gender.equalsIgnoreCase('Female')){
          return 'F';
      }else if (gender != null && gender.equalsIgnoreCase('Male')){
          return 'M';
      }
      return gender;
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description put default values to a new request including authentication
  * @param endPointCall last part of the api that complement the apiendpoint parameter
  * @param method type of request, POST/GET/PUT
  * @return parameters to invoke a service
  */
  private ConnectionRESTWs.Param prepareRequest(String endPointCall, String method) {
      ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();        
      p.endpoint = endPointApplication + endPointCall;
      p.method = method;
      p.contentType = ConnectionRESTWs.CONTENT_TYPE_JSON;
      p.setCredentials(clientId, clientSecret);
      System.debug('clientId => ' + clientId);
      System.debug('clientSecret => ' + clientSecret);
      System.debug('ConnectionRESTWs.Param => ' + JSON.serializePretty(p));
      return p;
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description put default values to a new request including authentication
  * @param loanTypeValue loan type from quoting tool, e.g. Purshase, Refinance, etc
  * @param privateSalesValue Yes (Y) or No (N) value
  * @param method type of request, POST/GET/PUT
  * @return parameters to invoke a service
  */
  public String getSupplierType(String loanTypeValue, String privateSalesValue) {
    if ('Refinance'.equals(loanTypeValue)) {
      return 'Refinance';
    }
    if ('N'.equals(privateSalesValue)) {
      return 'AssetSupplier';
    }
    return 'PrivateSale';
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description replace custom field names to a proper ones according with the API specification
  * @param app application object
  * @return a JSON string
  */
  public String serializeJsonApp(PepperApplicationRequestDTO app) {
    String r = app.serialize(true);
    // Replacements
    r = r.replaceAll('type_m', 'type');
    r = r.replaceAll('number_m', 'number');
    r = r.replaceAll('class_m', 'class');
    r = r.replaceAll('limit_m', 'limit');
    return r;
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description format a date using yyyy-MM-dd pattern
  * @param date date to be formated
  * @return date in format yyyy-MM-dd
  */
  public String formatDate(String mydate) {
    return DateUtils.convertToDateToFormat(mydate, DateUtils.YYYY_MM_DD);
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description build a full address from an Address object
  * @param address object that contains address details
  * @return a formatted full address depending if it is from Australia or overseas
  */
  public String getFullAddress(PepperApplicationRequestDTO.Address address) {
    String r = null;
    if (address != null) {
      if (PepperConstants.ADDRESS_FORMAT_STANDARD.equals(address.format)) {
        r = '';
        if (String.isNotBlank(address.unitNumber)) {
          r += address.unitNumber + '/';
        }
        if (String.isNotBlank(address.streetNumber)) {
          r += address.streetNumber + ' ';
        }
        r += address.streetName;
        r += ' ' + address.streetType;
      } else if (PepperConstants.ADDRESS_FORMAT_NONSTANDARD.equals(address.format)) {
        r = address.addressLine1;
        if (String.isNotBlank(address.addressLine2)) {
          r += ', ' + address.addressLine2;
        }
      }
      if (String.isNotBlank(address.suburb)) {
        r += ', ' + address.suburb;
      }
      if (String.isNotBlank(address.state)) {
        r += ' ' + address.state;
      }
      if (String.isNotBlank(address.postcode)) {
        r += ' ' + address.postcode;
      }
    }
    return r;
  }

  /*******************************************************************************************************
  * @author Lelo
  * @description convert an Application employment object to a Pepper employment object
  * @param employ salesforce employment object
  * @param addressType type of address, 'Current' or 'Previous'
  * @return new Pepper employment object
  */
  public PepperApplicationRequestDTO.Employment buildPepperEmployment(Application_Employment__c employ, String addressType) {
    PepperApplicationRequestDTO.Employment emp = null;
    if (employ != null && PepperConstants.COUNTRYCODE.equals(employ.Country__c) && 
        String.isNotBlank(employ.Employment_Type__c)) {
        emp = new PepperApplicationRequestDTO.Employment();
        //Current Employment
        // emp.occupation = sf doesn't have a list, it is free input text
        Date startJob = employ.Start_Date__c;
        Date endJob = employ.Finish_Date__c;
        emp.timeAtEmploymentInMonths = NumberUtils.convertToInteger(DateUtils.getTotalTimeInMonths (startJob, endJob));
        emp.type_m = Utilities.salesforceValueToMessageCode_Description(employ.Employment_Type__c, Utilities.Pepper_EMPLOYMENT_TYPE);
        // Employer details
        emp.employer = buildEmploymentEmployer(employ.Contact_Name__c, employ.Employer_Name__c, employ.Phone__c, null);
        emp.employer.address = getAddress(
          employ.Street_Number__c, employ.Work_Address__c, employ.Unit_Number__c, 
          employ.Street_Type__c, employ.Suburb__c, employ.State__c, 
          employ.Postcode__c, employ.Country__c, 
          addressType, startJob , endJob, null, false, null, null, null, true
        );
    }
    return emp;
  }

  public PepperApplicationRequestDTO.Serviceability buildServiceability(Custom_Opportunity__c opp, Application__c app) {
    PepperApplicationRequestDTO.Serviceability r = new PepperApplicationRequestDTO.Serviceability();

    // Incomes
    r.income = buildIncomes(opp, app);

    // Other assets
    r.applicantAssets = buildOtherAssets(app, false, false);

    // Liabilities
    r.liabilities = buildLiabilities(app, false, false);

    // Basic Expenses
    r.basicExpenses = buildBasicExpenses(app);

    // Other Expenses
    r.otherExpenses = buildOtherExpenses(app);

    return r;
  }

  public List<PepperApplicationRequestDTO.Expense> buildBasicExpenses (Application__c app) {
    List<PepperApplicationRequestDTO.Expense> r = new List<PepperApplicationRequestDTO.Expense>();
    PepperApplicationRequestDTO.Expense x = null;
    // Basic
    Decimal amount = NumberUtils.convertToDecimal(app.Basic_Living_Expenses_Per_Month__c, false);
    if (amount > 0) {
      if (amount < 200) {
        throw new GenericException('Basic Living Expenses per Month is too low $' + amount.format() + ', please fix it in Application Form.');
      }

      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_BASIC;
      x.amount = amount - 100;
      r.add(x);

      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_CLOTHING;
      x.amount = 50;
      r.add(x);

      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_UTILITIES;
      x.amount = 50;
      r.add(x);

    }
    // Entertainment
    amount = NumberUtils.convertToDecimal(app.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
    if (amount > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_ENTERTAINMENT;
      x.amount = amount;
      r.add(x);
    }
    // Travel
    amount = NumberUtils.convertToDecimal(app.Travel_Transport_Expenses_per_Month__c, false);
    if (amount > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_TRAVEL;
      x.amount = amount;
      r.add(x);
    }
    // Fees
    amount = NumberUtils.convertToDecimal(app.Childcare_Child_Maintenance_Per_Month__c, false);
    if (amount > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_FEES;
      x.amount = amount;
      r.add(x);
    }

    // Other - Insurance Expenses per Month
    amount = NumberUtils.convertToDecimal(app.Insurance_Expenses_per_Month__c, false);
    if (amount > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_VEHICLEINSURANCE;
      x.amount = amount;
      r.add(x);
    }

    return r;
  }

  public List<PepperApplicationRequestDTO.Expense> buildOtherExpenses (Application__c app) {
    List<PepperApplicationRequestDTO.Expense> r = new List<PepperApplicationRequestDTO.Expense>();
    PepperApplicationRequestDTO.Expense x = null;
    // Housing - Rental/Boarding
    if (app.Rent_per_month_1__c > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_HOUSING;
      x.amount = Utilities.getMonthlyValue(app.Residential_Payment_Frequency_1__c, app.Rent_per_month_1__c, 2);
      r.add(x);
    } else if (app.Board_per_Month_1__c > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_HOUSING;
      x.amount = Utilities.getMonthlyValue(app.Residential_Payment_Frequency_1__c, app.Board_per_Month_1__c, 2);
      r.add(x);
    }

    // Other Expenses per Month
    Decimal amount = NumberUtils.convertToDecimal(app.Other_Expenses_per_Month__c, false);
    if (amount > 0) {
      x = new PepperApplicationRequestDTO.Expense();
      x.type_m = PepperConstants.EXPENSE_OTHER;
      x.description = String.isNotBlank(app.Income_Type_Expenses__c)? app.Income_Type_Expenses__c : 'Other Expense';
      x.amount = amount;
      r.add(x);
    }

    return r;
  }
  
  public List<PepperApplicationRequestDTO.Liability> buildLiabilities (
    Application__c app, Boolean residentialPropertySecondPartner, Boolean 
      partner1) {
    List<PepperApplicationRequestDTO.Liability> r = new List<
      PepperApplicationRequestDTO.Liability>();
    List<Application_Other_Asset__c> otherAssets = 
      ApplicationService.getApplicationOtherAssets(app.Id);
    PepperApplicationRequestDTO.Liability x = null;
    // Property Asset, Vehicle Asset
    for (Application_Other_Asset__c a: otherAssets) {
      if ('Y'.equals(a.Has_Loan__c)) {
        x = new PepperApplicationRequestDTO.Liability();
        x.owner = PepperConstants.OWNER_PRIMARY;
        if ('Property Asset'.equals(a.RecordType.Name)) {
          x.type_m = PepperConstants.LIABILITY_MORTGAGE;
          x.limit_m = a.Amount_Owing__c;
        } else if ('Vehicle Asset'.equals(a.RecordType.Name)) {
          x.type_m = PepperConstants.LIABILITY_ASSET;
        }
        x.financier = a.Lender__c;
        x.outstandingAmount = a.Amount_Owing__c;
        x.expenseAmount = a.Monthly_Payment__c;
        x.liabilityId = a.Id;
        if (residentialPropertySecondPartner && 'Property Asset'.equals(
        a.RecordType.Name)) {
          if ('Current Address Applicant 2'.equals(a.Category__c)) {
            r.add(x);
            break;
          }
        } else if (partner1) {
          if (!'Current Address Applicant 2'.equals(a.Category__c)) {
            r.add(x);
          }
        } else {
          r.add(x);
        }
      }
    }

    // Other Loans
    List<Application_Loan__c> loans = ppManager.getAppLoans(app.Id);
    for (Application_Loan__c a: loans) {
      x = new PepperApplicationRequestDTO.Liability();
      x.owner = PepperConstants.OWNER_PRIMARY;
      x.description = a.Type__c;
      if ('Other'.equals(a.Type__c)) {
        x.type_m = PepperConstants.LIABILITY_OTHER;
        x.description = a.Type__c + ' loan';
      } else {
        x.type_m = PepperConstants.LIABILITY_PL;
      }
      x.financier = a.Lender__c;
      x.outstandingAmount = a.Amount_Owing__c;
      x.expenseAmount = a.Payment__c * 
        OppApplicationServCalculatorUtils.getFrecuencyFactor(a.Frequency__c, 
          PepperConstants.MONTHLY);
      x.expenseAmount = x.expenseAmount.setScale(2);
      x.liabilityId = a.Id;
      if (!residentialPropertySecondPartner) {
        r.add(x);
      }
    }

    // Credit Card
    List<Application_Credit_Card__c> ccards = ppManager.getAppCreditCards(app.Id);
    for (Application_Credit_Card__c a: ccards) {
      x = new PepperApplicationRequestDTO.Liability();
      x.owner = PepperConstants.OWNER_PRIMARY;
      // x.description = a.Type__c;
      x.type_m = PepperConstants.LIABILITY_CREDITCARD;
      x.financier = a.Issuer__c;
      x.outstandingAmount = a.Amount_Owing__c;
      x.expenseAmount = a.Monthly_Payment__c;
      x.limit_m = a.Limit__c;
      x.liabilityId = a.Id;
      if (!residentialPropertySecondPartner) {
        r.add(x);
      }
    }

    return r;
  }

  public List<PepperApplicationRequestDTO.ApplicantAsset> 
    buildOtherAssets (Application__c app, Boolean 
      residentialPropertySecondPartner, Boolean 
      partner1) {
    List<PepperApplicationRequestDTO.ApplicantAsset> r = new List<
      PepperApplicationRequestDTO.ApplicantAsset>();
    List<Application_Other_Asset__c> otherAssets = 
      ApplicationService.getApplicationOtherAssets(app.Id);
    PepperApplicationRequestDTO.ApplicantAsset pa = null;
    // Other Asset, Property Asset, Vehicle Asset
    for (Application_Other_Asset__c a: otherAssets) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.description = '';
      if ('Property Asset'.equals(a.RecordType.Name)) {
        pa.type_m = 'Residential Property';
      } else if ('Vehicle Asset'.equals(a.RecordType.Name)) {
        pa.type_m = 'Other';
        pa.description = 'Vehicle plates/desc: ';
      } else {
        pa.type_m = 'Other';
      }
      pa.value = a.Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      pa.description += a.Description__c;
      pa.applicantAssetId = a.Id;
      if (residentialPropertySecondPartner && 'Property Asset'.equals(
        a.RecordType.Name)) {
        if ('Current Address Both Applicants'.equals(a.Category__c)) {
          pa.applicantAssetId = a.Id + '-2';
          r.add(pa);
          break;
        } else if ('Current Address Applicant 2'.equals(a.Category__c)) {
          r.add(pa);
          break;
        }
      } else if (partner1) {
        if (!'Current Address Applicant 2'.equals(a.Category__c)) {
          r.add(pa);
        }
      } else {
        r.add(pa);
      }
    }

    Integer numberOtherAssets = 0;

    if (!r.isEmpty()) {
      numberOtherAssets = r.size();
    }

    // Savings
    if (app.Bank_Value__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Savings';
      pa.value = app.Bank_Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      pa.description = app.Bank_Name__c;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }

    // Superannuation
    if (app.Super_Value_How_Much__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Superannuation';
      pa.value = app.Super_Value_How_Much__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }

    // Home Contents
    if (app.Furniture_Value__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Home Contents';
      pa.value = app.Furniture_Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }      

    if (!r.isEmpty()) {
      for (Integer i = 1; i <= r.size() - numberOtherAssets; i++) {
        r.get(i + numberOtherAssets - 1).applicantAssetId = String.valueOf(i);
      }
    }

    return r;
  }

  public List<PepperApplicationRequestDTO.ApplicantAsset> buildOtherAssets (Application__c app, Boolean residentialPropertySecondPartner) {
    List<PepperApplicationRequestDTO.ApplicantAsset> r = new List<PepperApplicationRequestDTO.ApplicantAsset>();
    List<Application_Other_Asset__c> otherAssets = ApplicationService.getApplicationOtherAssets(app.Id);
    PepperApplicationRequestDTO.ApplicantAsset pa = null;
    // Other Asset, Property Asset, Vehicle Asset
    for (Application_Other_Asset__c a: otherAssets) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.description = '';
      if ('Property Asset'.equals(a.RecordType.Name)) {
        pa.type_m = 'Residential Property';
      } else if ('Vehicle Asset'.equals(a.RecordType.Name)) {
        pa.type_m = 'Other';
        pa.description = 'Vehicle plates/desc: ';
      } else {
        pa.type_m = 'Other';
      }
      pa.value = a.Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      pa.description += a.Description__c;
      pa.applicantAssetId = a.Id;
      if (residentialPropertySecondPartner && 'Property Asset'.equals(
        a.RecordType.Name)) {
        if ('Current Address Both Applicants'.equals(a.Category__c)) {
          pa.applicantAssetId = a.Id + '-2';
          r.add(pa);
          break;
        } else if ('Current Address Applicant 2'.equals(a.Category__c)) {
          r.add(pa);
          break;
        }
      } else {
        r.add(pa);
      }
    }

    Integer numberOtherAssets = 0;

    if (!r.isEmpty()) {
      numberOtherAssets = r.size();
    }

    // Savings
    if (app.Bank_Value__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Savings';
      pa.value = app.Bank_Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      pa.description = app.Bank_Name__c;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }

    // Superannuation
    if (app.Super_Value_How_Much__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Superannuation';
      pa.value = app.Super_Value_How_Much__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }

    // Home Contents
    if (app.Furniture_Value__c > 0) {
      pa = new PepperApplicationRequestDTO.ApplicantAsset();
      pa.type_m = 'Home Contents';
      pa.value = app.Furniture_Value__c;
      pa.owner = PepperConstants.OWNER_PRIMARY;
      if (!residentialPropertySecondPartner) {
        r.add(pa);
      }
    }      

    if (!r.isEmpty()) {
      for (Integer i = 1; i <= r.size() - numberOtherAssets; i++) {
        r.get(i + numberOtherAssets - 1).applicantAssetId = String.valueOf(i);
      }
    }

    return r;
  }

  public List<PepperApplicationRequestDTO.Income> buildIncomes(Custom_Opportunity__c opp, Application__c app) {
    List<PepperApplicationRequestDTO.Income> r = new List<PepperApplicationRequestDTO.Income>();
    PepperApplicationRequestDTO.Income inc = new PepperApplicationRequestDTO.Income();
    // Salary
    inc.type_m = 'Salary';
    inc.owner = PepperConstants.OWNER_PRIMARY;
    if (opp.ApplicationServicing__c != null && opp.ApplicationServicing__r.Income_1__c > 0) {
      inc.amount = opp.ApplicationServicing__r.Income_1__c;
    } else {
      if (app.Net_Income_1__c > 0)  {
        inc.amount = app.Net_Income_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Payment_Frequency_1__c, inc.frequency);
      }
    }
    inc.amount = inc.amount != null? inc.amount.setScale(2) : 0.00;
    inc.incomeId = '1';
    r.add(inc);

    // Other Incomes
    Map<String, List<Application_Income__c>> otherIncomes = this.ppManager.getAppIncomes(app.Id);
    if (otherIncomes.containsKey('1')) {
      for (Application_Income__c i: otherIncomes.get('1')) {
        String t = Utilities.salesforceValueToMessageCode_Code(i.Type__c, Utilities.Pepper_INCOME_TYPES);
        r.add(buildIncome(PepperConstants.OWNER_PRIMARY, t, i.Monthly_Income__c, 
          (String.isNotBlank(i.Detail__c)? i.Detail__c: null), i.Type__c, i.id));
      }
    }

    // Applicant 2
    if (app.No_of_People__c == 2) {
      inc = new PepperApplicationRequestDTO.Income();
      // Salary
      inc.type_m = 'Salary';
      inc.owner = PepperConstants.OWNER_COBORROWER;
      if (opp.ApplicationServicing__c != null && opp.ApplicationServicing__r.Income_2__c > 0) {
        inc.amount = opp.ApplicationServicing__r.Income_2__c;
      } else {
        if (app.Net_Income_2__c > 0) {
          inc.amount = app.Net_Income_2__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Payment_Frequency_2__c, inc.frequency);
        }
      }
      inc.amount = inc.amount != null? inc.amount.setScale(2) : 0.00;
      inc.incomeId = '2';
      r.add(inc);
      
      // Other Incomes
      if (otherIncomes.containsKey('2')) {
        for (Application_Income__c i: otherIncomes.get('2')) {
          String t = Utilities.salesforceValueToMessageCode_Code(i.Type__c, Utilities.Pepper_INCOME_TYPES);
            r.add(buildIncome(PepperConstants.OWNER_COBORROWER, t, i.Monthly_Income__c, 
              (String.isNotBlank(i.Detail__c)? i.Detail__c: null), i.Type__c, i.Id));
        }
      }

    }
    return r;
  }

  public PepperApplicationRequestDTO.Income buildIncome(
              String owner, String type_m, Decimal amount, String description, String sfType, ID id) {
    PepperApplicationRequestDTO.Income r = new PepperApplicationRequestDTO.Income();
    r.owner = owner;
    r.type_m = type_m;
    r.amount = amount.setScale(2);
    if ('Centrelink'.equals(type_m) || 'Rental'.equals(type_m)) {
      r.description = sfType;
    } else {
      r.description = description;
    }
    r.incomeId = id;
    return r;
  }


  /*******************************************************************************************************
  * @author Lelo
  * @description put default values to a new request including authentication
  * @param loanTypeValue loan type from quoting tool, e.g. Purshase, Refinance, etc
  * @param privateSalesValue Yes (Y) or No (N) value
  * @param method type of request, POST/GET/PUT
  * @return parameters to invoke a service
  */
  public String getApplicantResidency(String residencyStatus) {
    String r = 'Other';
    if ('Australian Citizen'.equals(residencyStatus)) {
      r = 'Citizen';
    } else if ('PR VISA'.equals(residencyStatus)) {
      return 'PR';
    }
    return r;
  }

  public String getAssetClassValue(String condition) {
    if ('new'.equalsIgnoreCase(condition)) {
      return 'New';
    } else if ('demo'.equalsIgnoreCase(condition)) {
      return 'Demo';
    }
    return 'Used';
  }

  public String getAssetTypeValue(String assetType, String appAssetType) {
    if ('Car'.equals(assetType)) {
      return 'MOTORVEHICLE';
    } else if ('Motorbike'.equals(assetType)) {
      return 'MOTORBIKE';
    } else if ('Boat'.equals(assetType)) {
      if ('JetSki'.equals(appAssetType)) {
        return 'PERSONAL WATERCRAFT';
      }
      return 'BOAT';
    } else if ('Caravan'.equals(assetType)) {
      return 'CARAVAN';
    }
    return 'N/D';
  }

  public String getAssetCategoryValue(String assetType) {
    if ('Car'.equals(assetType)) {
      return 'MOTORVEHICLE';
    } else if ('Motorbike'.equals(assetType)) {
      return 'MOTORBIKE';
    } else if ('Boat'.equals(assetType)) {
      return 'MARINE';
    } else if ('Caravan'.equals(assetType)) {
      return 'CARAVAN';
    } else if ('Other'.equals(assetType)) {
      return 'OTHER GOODS';
    }
    return 'N/D';
  }

  public String getMaritalStatusValue(String maritalStatus) {
    if ('Defacto'.equals(maritalStatus)) {
      return 'De Facto';
    }
    return StringUtils.validateNull(maritalStatus);
  }

  public PepperAPIManager uploadDocumentsToPepper(PepperAPIManager ppManager, String oppId, String applicationId, Boolean files, String user) {
      if (this.ppManager == null) {
        this.ppManager = ppManager;
      }
      // List<Cloud_Documents__c> documents = [SELECT Document_Type__c, File_Name__c from Cloud_Documents__c where 
      //                                                        Custom_Opportunity__c=:oppId and (Document_Type__c='Driver\'s License' or Document_Type__c='Payslip/s' or 
      //                                                        Document_Type__c='Applicant 1 Second Job Payslip')];
      
      List<Cloud_Documents__c> documents = [
          SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
          Custom_Opportunity__c=:oppId and Send_To_Lender__c = true];
      // applicant 2 docs
      List<String> dcs = new List<String>{
        'Applicant 2 - Drivers License - Front',
        'Applicant 2 - Drivers License - Back',
        'Applicant 2 - Payslip 1',
        'Applicant 2 - Payslip 2',
        'Applicant 2 Second Job Payslip',
        'Applicant 2 Payslips',
        'Applicant 2 Drivers License',
        'Applicant 2 Payslip 1'
      };
      if(PepperAPIManager.isTwoApplicants(oppId)){
          List<Cloud_Documents__c> documentsApp2 = [SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
                                                    Custom_Opportunity__c=:oppId and Document_Type__c in :dcs and Send_To_Lender__c = true];
          if(documentsApp2 != null && documentsApp2.size() > 0){
              documents.addAll(documentsApp2);
          }
      }
      
      if(documents.isEmpty()){
        System.debug('There is not documents to upload, display error');
        this.ppManager.addErrorMessage('There is not any document to send, please mark what documents should go to Pepper');
      }
      System.debug('Total documents to upload: ' + documents.size() + '|' + this.ppManager.messages.size());
      if(submitRequest(oppId, applicationId, files)){
          if(files && !documents.isEmpty()){
              documents = files(oppId, applicationId, documents);   
          }
          
          List<LenderAPIResponse__c> docs = new List<LenderAPIResponse__c>();
          for (Cloud_Documents__c d : documents) {
              Blob file;
              
              String form64 = '';
              String loanWriter = 'salesforce.dev@savvy.com.au'.equals(user)? 'QuantumSavvy.User1' : user;
              
              form64 += FinanceOneFile.append('metadata','{"applicationId":"'+applicationId+'","loanWriter":"'+loanWriter+'","merchant":'+merchantId+'}');
                              
              if (!Test.isRunningTest()) {
                  file = CloudDocsHelper.fileDownLoad(d);
              }else{
                  file = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAmEAAAAwMNAAAAAAAAAAAAAAAAFhfI6PAYKCk2R2ZnaoaJmKn4/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AJ1euwWNClEi8WE6TqSxg6S0dsdR2joB5Hcmdd6ywCJo7EzLu2WARGQDAf/Z=');
              }
              try{
                System.debug('Uploading file => ' + d.File_Name__c + ' | ' + d.Id);
                blob formBlob= FinanceOneFile.makeBlobWithFile('document',file,d.File_Name__c,form64, false, FinanceOneUtils.getContentType(d.File_Name__c));
                
                HttpRequest httpRequest = new HttpRequest();
                httpRequest.setBodyAsBlob(formBlob);
                
                String body = httpRequest.getBody();
                formBlob= FinanceOneFile.makeBlobWithFile('document',file,d.File_Name__c,form64, true, FinanceOneUtils.getContentType(d.File_Name__c));
                httpRequest.setBodyAsBlob(formBlob);
                string contentLength = string.valueOf(formBlob.size());
                string contentType = FinanceOneFile.GetContentType();
                                    
                httpRequest.setEndpoint(endPointApplication+'/applications/supportingDocuments');
                httpRequest.setHeader('Connection', 'keep-alive');
                httpRequest.setHeader('Content-Length', contentLength);
                httpRequest.setHeader('Content-Type', contentType);
                httpRequest.setMethod('PUT');
                httpRequest.setTimeout(120000);
                httpRequest.setHeader(PepperConstants.AUTHORIZATION, 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret)));
                httpRequest.setHeader(PepperConstants.ACCEPT, ConnectionRESTWs.CONTENT_TYPE_JSON);
                
                Http http = new Http();
                HttpResponse response;
                
                response = http.send(httpRequest);
                LenderAPIResponse__c l = new LenderAPIResponse__c();
                l.Cloud_Document__c = d.Id;
                l.Opportunity__c = oppId;
                System.debug(response.getBody());
                if(response.getStatusCode() == 200){
                  PepperApplicationResponseDTO dto = (PepperApplicationResponseDTO)JSON.deserialize(response.getBody(), PepperApplicationResponseDTO.class);                                                
                  l.DocumentUUID__c = dto.requestId;
                  l.Request__c = body;
                  l.Response__c = response.getBody();
                  l.Status__c = response.getStatusCode();
                  l.Message__c = dto.errorMessage;
                  l.Name = 'Pepper ['+applicationId+'-DOC]';
                  this.ppManager.addConfirmMessage(d.File_Name__c+' has been sent');
                } else {
                  l.Request__c = body;
                  l.Status__c = response.getStatusCode();
                  l.Name = 'Pepper [FAIL-'+applicationId+'-DOC]';
                  
                  if(String.isNotBlank(response.getBody())){
                    System.debug('Storing error response...');
                    System.debug('Initial messages => ' + this.ppManager.messages.size());
                    l.Response__c = response.getBody();
                    try {
                      PepperApplicationResponseDTO dto = (PepperApplicationResponseDTO)JSON.deserialize(
                        response.getBody(), 
                        PepperApplicationResponseDTO.class
                      );
                      l.Message__c = dto.errorMessage;
                      if(dto.requestId != null){
                        l.DocumentUUID__c = dto.requestId;
                      }
                      this.ppManager.addErrorMessage('['+d.File_Name__c+']: ' + dto.errorMessage);
                    } catch (Exception e) {
                      this.ppManager.addErrorMessage('['+d.File_Name__c+']: ' + e.getMessage());
                    }
                    System.debug('Final messages => ' + this.ppManager.messages.size());
                  }else if(response.getStatusCode() == 429){
                    this.ppManager.addErrorMessage('['+d.File_Name__c+']: Too many requests');
                  }else if(response.getStatusCode() == 503){
                    this.ppManager.addErrorMessage('['+d.File_Name__c+']: Service Unavailable (down time or outages)');
                  }						
                }
                docs.add(l);
              } catch (Exception ex) {
                this.ppManager.addWarningMessage('[ File: ' + d.File_Name__c + '] ' + ex.getMessage() + ' ['+d.Id+']');
              }
          }
          if (!docs.isEmpty() && this.ppManager.hasErrorMessages()) {
            String m = 'There';
            m += this.ppManager.getErrorMessages().size() > 1 
              ? ' are some errors' : ' is an error';
            m += ' upploading documents, please try to send them again in Quoting Tools.';
            this.ppManager.addWarningMessage(m);
          }
          ppManager.pepperAppResponseDTO.docs = docs;
      }
      return ppManager;
  }
  
  public List<Cloud_Documents__c> files(Id oppId, String applicationId, List<Cloud_Documents__c> documents){
      List<Cloud_Documents__c> docs = new List<Cloud_Documents__c>();
      List<LenderAPIResponse__c> lenderList = [
          SELECT Id, Application_ID__c from LenderAPIResponse__c where 
          Application_ID__c=:applicationId];
      
      LenderAPIResponse__c lender;
      
      List<LenderAPIResponse__c> files = new List<LenderAPIResponse__c>();
      
      if(!lenderList.isEmpty()){
          lender =  lenderList.get(0);
      }
      
      List<LenderAPIResponse__c> filesSended;
      
      if(lender != null){
          filesSended = [
              SELECT Cloud_Document__c from LenderAPIResponse__c where 
              LenderAPIResponse__c=:lender.Id and	Status__c=200];
      }
      
      Set<Id> docIds = new Set<Id>();
      
      if(filesSended != null){
          for (LenderAPIResponse__c l : filesSended) {
              docIds.add(l.Cloud_Document__c);
          }
      }
      
      for (Cloud_Documents__c d : documents) {
          if(!docIds.contains(d.Id)){
              docs.add(d);  
          }			
      }
      
      return docs;
  }
  
  public Boolean submitRequest(String oppId, String applicationId, Boolean files){
      Boolean submitRequest = true;
      List<Cloud_Documents__c> documents = [
          SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
          Custom_Opportunity__c=:oppId and Send_To_Lender__c = true and (Document_Type__c=null or Document_Type__c='')];
              
      if(files && !documents.isEmpty()){
          documents = files(oppId, applicationId, documents);
      }
      
      for (Cloud_Documents__c d : documents) {
          this.ppManager.addErrorMessage('Document type of the file '+d.File_Name__c+' is not selected');
          submitRequest = false;
      }

      Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(oppId, null);
      quotingNull(quoting);

      if('Other'.equals(quoting.Goods_type__c)){
        this.ppManager.addErrorMessage('Other goods applications are not implemented in salesforce yet');
        submitRequest = false;
      }
      
      return submitRequest;
  }

public void addressId(PepperApplicationRequestDTO.ApplicantAddresses r, 
Boolean pepperCommercial, String id, Integer pos) {
  r.currentAddress.addressId = '1';
  Integer i = 0;
  Integer position = 2;

  if (pepperCommercial) {
    r.currentAddress.addressId = id;
    position = pos;
  }

  while (i < r.previousAddress.size()) {
    r.previousAddress.get(i).addressId = String.valueOf(i + position);
    i++;
  }
}

public void additionalAppAddresses(
  PepperApplicationRequestDTO.AdditionalApplicant additionalApp, 
    Custom_Opportunity__c opp, Application__c add, Boolean pepperCommercial, 
      String id, Integer pos) {
  if ('Yes'.equalsIgnoreCase(
      Opp.Application__r.Applicant_2_living_in_the_same_address__c)){
    additionalApp.addresses = getAddressesPrimaryApp(opp, add, 
      pepperCommercial, id, pos);

    if (!pepperCommercial) {
      PepperApplicationRequestDTO.Address ca = 
        additionalApp.addresses.currentAddress;
      additionalApp.addresses.currentAddress = new 
        PepperApplicationRequestDTO.Address();
      additionalApp.addresses.currentAddress.mailingAsResidential = 
        ca.mailingAsResidential;
      additionalApp.addresses.currentAddress.timeAtAddressInMonths = 
        ca.timeAtAddressInMonths;
      additionalApp.addresses.currentAddress.residentialStatus = 
        ca.residentialStatus;
      additionalApp.addresses.currentAddress.addressId = id;
    }
  }else{
    additionalApp.addresses = getAddressesAdditionalApp(opp, add, 
      pepperCommercial, id, pos);
  }
}

public void quotingNull(Application_Quoting__c quoting) {
  if (quoting == null) {
    throw new GenericException (
      'Please make sure to save a quote before sending to PepperAPI.');
  }
}

public void personalDetails(PepperApplicationRequestDTO.AdditionalApplicant 
  additionalApp, Application__c add, Boolean secondPartner) {
  additionalApp.personalDetails = new 
    PepperApplicationRequestDTO.GeneralApplicant();
  if (secondPartner) {
    additionalApp.personalDetails.title = StringUtils.validateNull(
      add.Title_1__c);
    additionalApp.personalDetails.firstName = add.First_Name__c;
    additionalApp.personalDetails.middleName = add.Middle_Name__c;
    additionalApp.personalDetails.lastName = add.Last_Name__c;
    additionalApp.personalDetails.dateOfBirth = formatDate(
      add.Date_of_Birth_1__c);
    additionalApp.personalDetails.mobile = StringUtils.removeAllCharacters(
      add.Mobile_Number__c);
    if (StringUtils.isNullOrEmpty(additionalApp.personalDetails.mobile)){
      additionalApp.personalDetails.homePhone = 
        StringUtils.removeAllCharacters(add.Home_Phone__c);
      if (StringUtils.isNullOrEmpty(additionalApp.personalDetails.homePhone)){
        additionalApp.personalDetails.workPhone = 
          StringUtils.removeAllCharacters(add.Work_Phone__c);
      }
    }
    additionalApp.personalDetails.email = add.Email_Address__c;
    additionalApp.personalDetails.gender = getGender(add.Gender_1__c);
    additionalApp.personalDetails.maritalStatus = getMaritalStatusValue(
      add.Marital_Status_1__c);
    additionalApp.personalDetails.numberOfDependants = 0;
    if (add.No_of_Dependants_1__c != null) {
      additionalApp.personalDetails.numberOfDependants = 
        add.No_of_Dependants_1__c.intValue();
    }
    additionalApp.personalDetails.residencyStatus = getApplicantResidency(
      add.Current_Residential_Status_1__c);
    additionalApp.personalDetails.country = add.Actual_Nationality_1__c;
    additionalApp.personalDetails.driversLicence = getDriversLicence(
      add.Drivers_License_1__c, DateUtils.convertToDate(add.Expiry_Date_1__c), 
        add.Driver_Licence_State_Issue_1__c);
  } else {
    additionalApp.personalDetails.title = StringUtils.validateNull(
      add.Title_2__c);
    additionalApp.personalDetails.firstName = add.First_Name_2__c;
    additionalApp.personalDetails.middleName = add.Middle_Name_2__c;
    additionalApp.personalDetails.lastName = add.Last_Name_2__c;
    additionalApp.personalDetails.dateOfBirth = formatDate(
      add.Date_of_Birth_2__c);
    additionalApp.personalDetails.mobile = StringUtils.removeAllCharacters(
      add.Mobile_Number_2__c);
    if (StringUtils.isNullOrEmpty(additionalApp.personalDetails.mobile)){
      additionalApp.personalDetails.homePhone = 
        StringUtils.removeAllCharacters(add.Home_Phone_2__c);
      if (StringUtils.isNullOrEmpty(additionalApp.personalDetails.homePhone)){
        additionalApp.personalDetails.workPhone = 
          StringUtils.removeAllCharacters(add.Work_Phone_2__c);
      }
    }
    additionalApp.personalDetails.email = add.Email_Address_2__c;
    additionalApp.personalDetails.gender = getGender(add.Gender_2__c);
    additionalApp.personalDetails.maritalStatus = getMaritalStatusValue(
      add.Marital_Status_2__c);
    additionalApp.personalDetails.numberOfDependants = 0;
    if (add.No_of_Dependants_2__c != null) {
      additionalApp.personalDetails.numberOfDependants = 
        add.No_of_Dependants_2__c.intValue();
    }
    additionalApp.personalDetails.residencyStatus = getApplicantResidency(
      add.Current_Residential_Status_2__c);
    additionalApp.personalDetails.country = add.Actual_Nationality_2__c;
    additionalApp.personalDetails.driversLicence = getDriversLicence(
      add.Drivers_License_2__c, DateUtils.convertToDate(add.Expiry_Date_2__c) , add.Driver_Licence_State_Issue_2__c);
  }
}

public PepperApplicationRequestDTO.ApplicantAddresses tradingAddress(PepperApplicationRequestDTO.ApplicantAddresses addresses, Application__c add) {
  addresses = new PepperApplicationRequestDTO.ApplicantAddresses();
      
  List<Application_Employment__c> tradingAddress = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                   Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                   Work_Address__c, Phone__c,
                                                   Unit_Number__c, Street_Number__c, Street_Type__c,
                                                   Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                   Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                   FROM Application_Employment__c WHERE Application__c =: add.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
  
  addresses.tradingAddress = new PepperApplicationRequestDTO.Address();
  addresses.tradingAddress.format = 'Standard';
  addresses.tradingAddress.registeredAddressSameAsTrading = true;
  addresses.tradingAddress.postalAddressSameAsTrading = true;
  addresses.tradingAddress.streetName = add.Trading_Address__c;
  if (!tradingAddress.isEmpty()) {
    addresses.tradingAddress.unitNumber = tradingAddress.get(0).Unit_Number__c;
    addresses.tradingAddress.streetNumber = tradingAddress.get(0).Street_Number__c;
    addresses.tradingAddress.streetType = LatitudeUtils.getLabelPicklistField(Application_Employment__c.Street_Type__c.getDescribe(), tradingAddress.get(0).Street_Type__c);
    addresses.tradingAddress.suburb = tradingAddress.get(0).Suburb__c;
    addresses.tradingAddress.state = tradingAddress.get(0).State__c;
    addresses.tradingAddress.postcode = tradingAddress.get(0).Postcode__c;
    addresses.tradingAddress.countryCode = tradingAddress.get(0).Country__c;
  }

  return addresses;												 
  
}

public PepperApplicationRequestDTO.AdditionalApplicant getAdditionalApp(String 
  applicantId, String relatedApplicant, Application__c app, 
    Custom_Opportunity__c opp, Boolean pepperCommercial, String id, Integer pos, 
      Boolean partner1) {
  PepperApplicationRequestDTO.AdditionalApplicant additionalApp = new 
    PepperApplicationRequestDTO.AdditionalApplicant();
  additionalApp.applicantId = applicantId;
  additionalApp.applicantType = 'Individual';
  additionalApp.relatedApplicants = new List<String>();
  additionalApp.relatedApplicants.add(relatedApplicant);
  // Other assets
  additionalApp.applicantAssets = buildOtherAssets(app, false, partner1);
        
  // Liabilities
  additionalApp.liabilities = buildLiabilities(app, false, partner1);
  personalDetails(additionalApp, app, true);
  additionalApp.addresses = getAddressesPrimaryApp(opp, app, pepperCommercial, 
    id, pos);
  
  additionalApp.relationshipType = getRelationshipType(String.isNotBlank(
    app.Trust_Name__c) ? app.Business_Structure_2__c : app.Business_Structure__c);

  return additionalApp;
}

public PepperApplicationRequestDTO.AdditionalApplicant getPartner(
  PepperApplicationRequestDTO.AdditionalApplicant additionalApplicant, String 
    applicantId, String relatedApplicant, Application__c app, 
      Custom_Opportunity__c opp, Boolean pepperCommercial) {
  Integer pos = additionalApplicant.addresses.previousAddress.size() + 
    Integer.valueOf(applicantId);
  PepperApplicationRequestDTO.AdditionalApplicant additionalApp = new 
    PepperApplicationRequestDTO.AdditionalApplicant();
    additionalApp.applicantId = applicantId;
    additionalApp.applicantType = 'Individual';
    personalDetails(additionalApp, app, false);
    additionalAppAddresses(additionalApp, opp, app, pepperCommercial, 
      applicantId, pos);
    additionalApp.relatedApplicants = new List<String>();
    additionalApp.relatedApplicants.add(relatedApplicant);
    if ('Owner'.equals(
      additionalApplicant.addresses.currentAddress.residentialStatus) || 
        'Buyer'.equals(
          additionalApplicant.addresses.currentAddress.residentialStatus)) {
      additionalApp.applicantAssets = buildOtherAssets(app , true, false);
      additionalApp.liabilities = buildLiabilities(app, true, false);
    }
    additionalApp.relationshipType = 'Partner';
  return additionalApp;
}

  public String getRelationshipType(String businessStructure) {
    if ('Individual or Sole Trader'.equals(businessStructure)) {
      return 'Proprietor';
    } else if ('Partnership'.equals(businessStructure)) {
      return 'Partner';
    } else {
      return 'Guarantor';
    }
  }

  public void residentialPropertyPartnership(Id appId, String category, String 
    message) {
    Boolean residentialProperty = true;
			  
    for (Application_Other_Asset__c a: 
      ApplicationService.getApplicationOtherAssets(appId)) {
      if (category.equals(a.Category__c)) {
          residentialProperty = false;
          break;
      }
    }

    if (residentialProperty) {
      throw new GenericException (message);
    }
  }
}