public class VedaEnquiryExtension {

  private static final String XML_SCORE_APPLY_XSD = 'http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd';
  public static final String PARAM_SERVICE_ENDPOINT = 'Equifax_Service_Endpoint';
  public static final String PARAM_REPORT_ENDPOINT = 'Equifax_Report_Endpoint';
  public static final String PARAM_USERNAME = 'Equifax_Username';
  public static final String PARAM_PASSWORD = 'Equifax_Password';
  public static final String PARAM_DEFAULT_LIMIT = 'Equifax_Default_Limit';
  public static final String PARAM_SECOND_LIMIT = 'Equifax_Second_Limit';

  private static String servEndpointVal;
  private static String repEndpointVal;
  private static String usernameVal;
  private static String passwordVal;
  private static String defaulLimittVal;
  private static String secondLimitVal;

  static {
    try {
      servEndpointVal = APIServiceManager.getParameterService(PARAM_SERVICE_ENDPOINT);
      repEndpointVal = APIServiceManager.getParameterService(PARAM_REPORT_ENDPOINT);
      usernameVal = APIServiceManager.getParameterService(PARAM_USERNAME);
      passwordVal = APIServiceManager.getParameterService(PARAM_PASSWORD);
      defaulLimittVal = APIServiceManager.getParameterService(PARAM_DEFAULT_LIMIT);
      secondLimitVal = APIServiceManager.getParameterService(PARAM_SECOND_LIMIT);
    } catch (GenericException e) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          e.getMessage()
        )
      );
    }
  }

  private static final Integer TIMEOUT_REQUEST = 60000;

  public String selectedProductDataLevel { get; set; }
  public String selectedPermissionType { get; set; }
  public String clientRef { get; set; }
  public String titleStr { get; set; }
  public String fname { get; set; }
  public String lname { get; set; }
  public String oname { get; set; }
  public String cUnitNum { get; set; }
  //	public String Unit_Number__c{get;set;}
  public String cStreetNum { get; set; }
  public String cStreetName { get; set; }
  public String cStreetType { get; set; }
  public String cSuburb { get; set; }
  public String cState { get; set; }
  public String cPostCode { get; set; }
  public String cCountryCode { get; set; }

  public String pUnitNum { get; set; }
  public String pStreetNum { get; set; }
  public String pStreetName { get; set; }
  public String pStreetType { get; set; }
  public String pSuburb { get; set; }
  public String pState { get; set; }
  public String pPostCode { get; set; }
  public String pCountryCode { get; set; }

  public String uAddress { get; set; }
  public String genderCode { get; set; }
  public Date dateOfBirth { get; set; }
  public String cEmployer { get; set; }
  public String atCode { get; set; }
  public Decimal enquiryAmt { get; set; }
  public String currencyCode { get; set; }
  public Boolean isCR { get; set; }
  public String relationshipCode { get; set; }
  public String enquiryCR { get; set; }
  public String dLicense { get; set; }
  public Id parentId { get; set; }

  //Lelo              2017-06-26
  public Integer currentTally { get; set; }
  public Boolean isProcessOK = false;
  public Map<ApexPages.severity, List<String>> userMgs;
  public Integer vedaLimit { get; set; }
  //Lelo              2019-06-05
  public String enquiryID { get; set; }
  //-

  // public List<Opportunity_veda__c> kk = [select Idopvd__c, clicks__c from Opportunity_veda__c where Idopvd__c =: UserInfo.getUserId()];
  public Custom_Opportunity__c oppty { get; set; }
  //Jesus Mora 2019-11-28 start
  // public Veda_Settings__c vs { get; set; }   
  public String sfReq1 {set;get;}
  public String eqRes1 {set;get;}
  public String sfReq2 {set;get;}
  public String eqRes2 {set;get;}
  public Boolean displayServiceInfo {set;get;}

  //Jesus Mora 2019-11-28 end
  public VedaEnquiryExtension(ApexPages.StandardController ctrl) {
    this.oppty = (Custom_Opportunity__c) ctrl.getRecord();
    this.parentId = oppty.Id;
    this.oppty = [
      SELECT
        Name,
        Application__c,
        Application__r.No_of_People__c,
        Application__r.Email_Address_2__c,
        Application__r.Email_Address__c,
        Email_Address__c
      FROM Custom_Opportunity__c
      WHERE Id = :parentId
    ];
    clientRef = String.valueOf(parentId).substring(0, 15);
    // String uname = UserInfo.getName();
    // clientRef = uname.length() > 15 ? uname.substring(0, 15) : uname;
    enquiryCR = String.valueOf(parentId).substring(0, 15);
    ////
    // vs = Veda_Settings__c.getInstance();
    //
    //
    if (oppty.Application__c == null) {
      ApexPages.addmessage(
        new ApexPages.message(
          ApexPages.severity.WARNING,
          'No Related Application specified for this Opportunity.'
        )
      );
    } else {
      Application__c appl = [
        SELECT
          Id,
          Title_1__c,
          First_Name__c,
          Middle_Name__c,
          Last_Name__c,
          Drivers_License_1__c,
          Date_of_Birth_1__c,
          Current_Employer_Name_1__c,
          Gender_1__c,
          Unit_Number__c,
          Unit_Number_2__c,
          Street_Address__c,
          Street_Address_2__c,
          Street_Number__c,
          Street_Number_2__c,
          Street_Type__c,
          Street_Type_2__c,
          Suburb__c,
          Suburb_2__c,
          State__c,
          State_2__c,
          Postcode__c,
          Postcode_2__c,
          Country__c,
          Country_2__c,
          Finance_Amount__c
        FROM Application__c
        WHERE Id = :oppty.Application__c
      ];
      if (String.isNotBlank(appl.Title_1__c)) {
        titleStr = appl.Title_1__c.toUpperCase();
      }
      fname = appl.First_Name__c;
      lname = appl.Last_Name__c;
      oname = appl.Middle_Name__c;
      cUnitNum = appl.Unit_Number__c;
      dLicense = appl.Drivers_License_1__c;
      cStreetNum = appl.Street_Number__c;
      cStreetType = appl.Street_Type__c;
      cSuburb = appl.Suburb__c;
      cState = appl.State__c;
      cPostCode = appl.Postcode__c;
      cStreetName = appl.Street_Address__c;
      cCountryCode = appl.Country__c;
      pUnitNum = appl.Unit_Number_2__c;
      pStreetNum = appl.Street_Number_2__c;
      pStreetName = appl.Street_Address_2__c;
      pStreetType = appl.Street_Type_2__c;
      pSuburb = appl.Suburb_2__c;
      pState = appl.State_2__c;
      pPostCode = appl.Postcode_2__c;
      pCountryCode = appl.Country_2__c;
      enquiryAmt = appl.Finance_Amount__c;
      if (String.isNotBlank(appl.Date_of_Birth_1__c)) {
        List<String> dateStr = appl.Date_of_Birth_1__c.split('/');
        try {
          dateOfBirth = Date.valueOf(
            dateStr.get(2) +
            '-' +
            dateStr.get(1) +
            '-' +
            dateStr.get(0)
          );
        } catch (Exception e) {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR, 
              'D.O.B. has an invalid format in Application Form "' + 
              appl.Date_of_Birth_1__c + '", please use "dd/mm/yyyy format"'));
        }
      }
      cEmployer = appl.Current_Employer_Name_1__c;
      genderCode = appl.Gender_1__c;

      System.debug(LoggingLevel.INFO, 'servEndpointVal => ' + servEndpointVal);
      System.debug(LoggingLevel.INFO, 'repEndpointVal => ' + repEndpointVal);
      System.debug(LoggingLevel.INFO, 'usernameVal => ' + usernameVal);
      System.debug(LoggingLevel.INFO, 'passwordVal => ' + passwordVal);
      System.debug(LoggingLevel.INFO, 'defaulLimittVal => ' + defaulLimittVal);
      System.debug(LoggingLevel.INFO, 'secondLimitVal => ' + secondLimitVal);

      // this.vedaLimit = Integer.valueOf(vs.Default_Limit__c);
      
      try {
        this.vedaLimit = Integer.valueOf(defaulLimittVal);
        if (SOQLSingletonQueries.isSalesConsultant3()) {
          this.vedaLimit = Integer.valueOf(secondLimitVal);
        }
      } catch (Exception e) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Maximum number of enquires could not be loaded. (' + e.getMessage() + ')'
          )
        );
      }
      
      System.debug('Veda limit: ' + this.vedaLimit);
    }

    //Lelo          2017-06-26
    list<Opportunity_veda__c> kk = [
      SELECT Idopvd__c, clicks__c
      FROM Opportunity_veda__c
      WHERE Idopvd__c = :UserInfo.getUserId()
    ];
    if (!kk.isEmpty()) {
      currentTally = Integer.valueOf(kk.get(0).clicks__c);
    } else {
      currentTally = 0;
    }
    if (String.isBlank(pCountryCode)) {
      pCountryCode = 'AUS';
    }
    if (String.isBlank(cCountryCode)) {
      cCountryCode = 'AUS';
    }
    //-

    String dsiParam = System.currentPageReference().getParameters().get('display-service-info');
    this.displayServiceInfo = false;
    if (String.isNotBlank(dsiParam)) {
      this.displayServiceInfo = true;
    }

  }

  public List<SelectOption> getCurrencyOptions() {
    List<SelectOption> currencyOptions = new List<SelectOption>();
    currencyOptions.add(new SelectOption('AUD', 'AUD'));
    currencyOptions.add(new SelectOption('USD', 'USD'));

    return currencyOptions;
  }

  public List<SelectOption> getTitleOptions() {
    List<SelectOption> titleOptions = new List<SelectOption>();
    titleOptions.add(new SelectOption('', '--None--'));
    titleOptions.add(new SelectOption('MR', 'Mr'));
    titleOptions.add(new SelectOption('MRS', 'Mrs'));
    titleOptions.add(new SelectOption('MS', 'Ms'));
    return titleOptions;
  }

  public List<SelectOption> getPdlOptions() {
    List<SelectOption> pdlOptions = new List<SelectOption>();
    pdlOptions.add(new SelectOption('C', 'Comprehensive'));
    pdlOptions.add(new SelectOption('P', 'Partial'));
    pdlOptions.add(new SelectOption('N', 'Negative'));

    return pdlOptions;
  }

  public List<SelectOption> getAtOptions() {
    List<SelectOption> atOptions = new List<SelectOption>();
    atOptions.add(new SelectOption('AL', 'Auto Loan'));
    atOptions.add(new SelectOption('CC', 'Continuing Credit Contract'));
    atOptions.add(new SelectOption('CA', 'Charge Card'));
    atOptions.add(new SelectOption('OD', 'Overdraft'));
    atOptions.add(new SelectOption('PF', 'Personal Loan (fixed term)'));
    atOptions.add(new SelectOption('PR', 'Personal Loan (revolving)'));
    atOptions.add(new SelectOption('RE', 'Equipment Hire or Rental'));
    atOptions.add(new SelectOption('RM', 'Real Property Mortgage'));
    atOptions.add(new SelectOption('TC', 'Telecommunications Services'));
    atOptions.add(new SelectOption('UA', 'Utilities'));
    atOptions.add(new SelectOption('AO', 'All Other Account Types'));
    return atOptions;
  }

  public List<SelectOption> getGenderOptions() {
    List<SelectOption> genderOptions = new List<SelectOption>();
    genderOptions.add(new SelectOption('M', 'Male'));
    genderOptions.add(new SelectOption('F', 'Female'));
    genderOptions.add(new SelectOption('U', 'Unknown'));

    return genderOptions;
  }

  public List<SelectOption> getPtcOptions() {
    List<SelectOption> ptcOptions = new List<SelectOption>();
    //ptcOptions.add(new SelectOption('X', 'Consumer'));
    ptcOptions.add(new SelectOption('XY', 'Consumer+Commercial'));
    ptcOptions.add(new SelectOption('YX', 'Commercial+Consumer'));
    //ptcOptions.add(new SelectOption('Y', 'Commercial'));

    return ptcOptions;
  }

  public List<SelectOption> getStateOptions() {
    List<SelectOption> stateOptions = new List<SelectOption>();
    stateOptions.add(new SelectOption('', '--Select a State--'));
    stateOptions.add(new SelectOption('ACT', 'Australian Capital Territory'));
    stateOptions.add(new SelectOption('NSW', 'New South Wales'));
    stateOptions.add(new SelectOption('NT', 'Northern Territory'));
    stateOptions.add(new SelectOption('N', 'New Zealand'));
    stateOptions.add(
      new SelectOption(
        'OS',
        'Overseas (except Other States or Territories of Australia or New Zealand)'
      )
    );
    stateOptions.add(
      new SelectOption(
        'OTH',
        'Other State or Territory of Australia (Norfolk Island, Australian Antarctic Territory, ...)'
      )
    );
    stateOptions.add(new SelectOption('QLD', 'Queensland'));
    stateOptions.add(new SelectOption('SA', 'South Australia'));
    stateOptions.add(new SelectOption('TAS', 'Tasmania'));
    stateOptions.add(new SelectOption('VIC', 'Victoria'));
    stateOptions.add(new SelectOption('WA', 'Western Australia'));
    return stateOptions;
  }

  public List<SelectOption> getStOptions() {
    return UtilitiesList.getStreetTypeOptions();
  }

  public List<SelectOption> getCountryOptions() {
    return UtilitiesList.getCountryOptions();
  }

  public List<SelectOption> getRelationshipOptions() {
    List<SelectOption> relationshipOptions = new List<SelectOption>();
    relationshipOptions.add(
      new SelectOption('1', 'Principal’s Account (sole)')
    );
    relationshipOptions.add(
      new SelectOption('2', 'Principal’s Account (joint)')
    );
    relationshipOptions.add(new SelectOption('3', 'Guarantor'));
    relationshipOptions.add(new SelectOption('4', 'Director'));

    return relationshipOptions;
  }

  //Lelo                  2017-06-26
  public Boolean isValidationOK() {
    Boolean r = true;
    // Validate settings
    if (String.isBlank(servEndpointVal) ||
        String.isBlank(repEndpointVal) ||
        String.isBlank(usernameVal) ||
        String.isBlank(passwordVal)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'API Settings not found for Equifax'
        )
      );
      r = false;
    }
    if (!hasESignLiveCompleted()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.WARNING,
      //     'There is not any completed E-Consent in the Opportunity Transaction section, please be sure that all applicants have signed a consent before proceeding with a credit file assessment.'
      //   )
      // );
      if (!hasDocsUploaded()) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Privacy consent not completed. Enquiry cannot proceed.'
          )
        );
        r = false;
      }
    } else {
      if (currentTally >= this.vedaLimit) {
        ApexPages.addmessage(
          new ApexPages.message(
            ApexPages.severity.ERROR,
            'The User only can update ' +
            this.vedaLimit +
            ' times Enquiries'
          )
        );
        r = false;
      } else {
        if (this.dateOfBirth == null) {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Date of Birth.'
            )
          );
          r = false;
        }
        if (dLicense.length() > 9) {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Driver\'s License number should not be more than 10 characters.'
            )
          );
          //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'buu '+ UserInfo.getUserId()));
          r = false;
        }
        if (this.cStreetNum == null || this.cStreetNum == '') {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Current Address Street Number.'
            )
          );
          r = false;
        }
        if (this.cStreetName == null || this.cStreetName == '') {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Current Address Street Name.'
            )
          );
          r = false;
        }
        if (this.cSuburb == null || this.cSuburb == '') {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Current Address Suburb.'
            )
          );
          r = false;
        }
        if (this.cStreetType == null || this.cStreetType == '') {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Current Address Street Type.'
            )
          );
          r = false;
        }
        if (this.cState == null || this.cState == '') {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.ERROR,
              'Please specify Current Address State.'
            )
          );
          r = false;
        }
      }
    }
    return r;
  }
  //-

  //shgg 26/06/17

  public PageReference VedaClick() {
    Decimal prue = 0;
    if (isValidationOK()) {
      if (isProcessOK) {
        List<Opportunity_veda__c> ovLst = [
          SELECT Idopvd__c, clicks__c
          FROM Opportunity_veda__c
          WHERE Idopvd__c = :UserInfo.getUserId()
        ];
        if (ovLst.isEmpty()) {
          Opportunity_veda__c regg = new Opportunity_veda__c();
          regg.Idopvd__c = UserInfo.getUserId();
          regg.clicks__c = 1;
          regg.Name = oppty.Application__c;
          insert regg;
        } else {
          Opportunity_veda__c ov = ovLst.get(0);
          prue = ov.clicks__c;
          prue++;
          ov.clicks__c = prue;
          update ov;
        }
      }
    }
    //DISPLAY MESSAGES
    if (userMgs != null) {
      for (ApexPages.severity k : userMgs.keySet()) {
        for (String msg : userMgs.get(k)) {
          ApexPages.addmessage(new ApexPages.message(k, msg));
        }
      }
    }
    List<LenderAPIResponse__c> d = new List<LenderAPIResponse__c>();
    if (String.isNotBlank(this.sfReq1)) {
      d.add(buildAPIResponse(1, this.sfReq1, this.eqRes1));
    }
    if (String.isNotBlank(this.sfReq2)) {
      d.add(buildAPIResponse(2, this.sfReq2, this.eqRes2));
    }
    if (!d.isEmpty()) {
      insert d;
    }

    return null;
  }

  public LenderAPIResponse__c buildAPIResponse(Integer reqNum, String req, String res) {
    LenderAPIResponse__c lar = new LenderAPIResponse__c();
    lar.Name = 'Equifax (req#'+reqNum+') ' + this.oppty.Name;
    lar.Provider__c = 'Equifax';
    if (lar.Name.length() > 80) {
      lar.Name = lar.Name.substring(0, 80);
    }
    lar.Opportunity__c = this.parentId;
    lar.Request__c = req;
    if (lar.Request__c.length() > 131072) {
      lar.Request__c = lar.Request__c.substring(0, 131072);
    }
    if (String.isNotBlank(res)) {
      lar.Response__c = res;
      if (lar.Response__c.length() > 131072) {
        lar.Response__c = lar.Request__c.substring(0, 131072);
      }
    }
    return lar;
  }

  private void resetUserMessages() {
    userMgs = new Map<ApexPages.severity, List<String>>();
    userMgs.put(ApexPages.Severity.ERROR, new List<String>());
    userMgs.put(ApexPages.Severity.INFO, new List<String>());
  }

  private void putUserMessage(ApexPages.severity msgType, String message) {
    List<String> lst = userMgs.get(msgType);
    if (lst != null) {
      lst.add(message);
    }
  }

  public PageReference submitEnquiry() {
    //list<Opportunity_veda__c> kk = [select Idopvd__c, clicks__c from Opportunity_veda__c where Idopvd__c =: UserInfo.getUserId()];
    System.debug('submitEnquiry...');
    isProcessOK = false;
    this.sfReq1 = null;
    this.eqRes1 = null;
    this.sfReq2 = null;
    this.eqRes2 = null;
    resetUserMessages();

    if (!isValidationOK()) {
      return null;
    }

    if (this.enquiryAmt == null || this.enquiryAmt == 0) {
      this.enquiryAmt = 0;
    }
    Long enquiryAmtLong = enquiryAmt.longValue();

    /*if(this.uAddress == null || this.uAddress == ''){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please specify Previous Address'));
return null;
}*/

    String includeOname = '';
    if (oname != null && oname != '') {
      includeOname =
        '<vsa:other-given-name>' +
        oname +
        '</vsa:other-given-name>';
    }

    String previousAddress = '';
    if (String.isNotBlank(pSuburb)) {
      previousAddress =
        '<vsa:address type="P">' +
        '<vsa:unit-number>' +
        pUnitNum +
        '</vsa:unit-number>' +
        '<vsa:street-number>' +
        pStreetNum +
        '</vsa:street-number>' +
        '<vsa:street-name>' +
        pStreetName +
        '</vsa:street-name>' +
        '<vsa:street-type>' +
        pStreetType +
        '</vsa:street-type>' +
        '<vsa:suburb>' +
        pSuburb +
        '</vsa:suburb>' +
        '<vsa:state>' +
        pState +
        '</vsa:state>' +
        '<vsa:postcode>' +
        pPostCode +
        '</vsa:postcode>' +
        '<vsa:country-code>' +
        pCountryCode +
        '</vsa:country-code></vsa:address>';
    }

    String dobYear = String.valueOf(dateOfBirth.year());
    String dobMonth = dateOfBirth.month() > 9
      ? String.valueOf(this.dateOfBirth.month())
      : '0' + String.valueOf(this.dateOfBirth.month());
    String dobDay = dateOfBirth.day() > 9
      ? String.valueOf(this.dateOfBirth.day())
      : '0' + String.valueOf(this.dateOfBirth.day());
    String reqStr =
      '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:vsa="http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd">' +
      '<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">      <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
      '<wsse:UsernameToken><wsse:Username>' +
      usernameVal + // vs.Username__c
      '</wsse:Username>' +
      '<wsse:Password>' +
      passwordVal + // vs.Password__c
      '</wsse:Password></wsse:UsernameToken>' +
      '</wsse:Security><wsa:To>http://vedaxml.com/sys2/vedascore-apply-v2-0</wsa:To><wsa:Action>http://vedaxml.com/vedascore-apply/EnquiryRequest</wsa:Action></soapenv:Header>' +
      '<soapenv:Body><vsa:request>' +
      '<vsa:enquiry-header><vsa:client-reference>' +
      clientRef +
      '</vsa:client-reference>' +
      '<vsa:permission-type-code>' +
      selectedPermissionType +
      '</vsa:permission-type-code>' +
      '<vsa:product-data-level-code>' +
      selectedProductDataLevel +
      '</vsa:product-data-level-code>' +
      '<vsa:requested-scores><vsa:scorecard-id>VSA_2.0_XY_CR</vsa:scorecard-id>' +
      '<vsa:scorecard-id>VS_1.1_XY_NR</vsa:scorecard-id></vsa:requested-scores>' +
      '</vsa:enquiry-header>' +
      '<vsa:enquiry-data><vsa:individual><vsa:current-name><vsa:title>' +
      titleStr +
      '</vsa:title>' +
      '<vsa:family-name>' +
      lname +
      '</vsa:family-name>' +
      '<vsa:first-given-name>' +
      fname +
      '</vsa:first-given-name>' +
      includeOname +
      '</vsa:current-name><vsa:addresses><vsa:address type="C">' +
      '<vsa:unit-number>' +
      cUnitNum +
      '</vsa:unit-number>' +
      '<vsa:street-number>' +
      cStreetNum +
      '</vsa:street-number>' +
      '<vsa:street-name>' +
      cStreetName +
      '</vsa:street-name>' +
      '<vsa:street-type>' +
      cStreetType +
      '</vsa:street-type>' +
      '<vsa:suburb>' +
      cSuburb +
      '</vsa:suburb>' +
      '<vsa:state>' +
      cState +
      '</vsa:state>' +
      '<vsa:postcode>' +
      cPostCode +
      '</vsa:postcode>' +
      '<vsa:country-code>' +
      cCountryCode +
      '</vsa:country-code></vsa:address>' +
      previousAddress +
      '</vsa:addresses>' +
      '<vsa:drivers-licence><vsa:number>' +
      dLicense +
      '</vsa:number></vsa:drivers-licence>' +
      '<vsa:gender-code>' +
      genderCode +
      '</vsa:gender-code>' +
      '<vsa:date-of-birth>' +
      dobYear +
      '-' +
      dobMonth +
      '-' +
      dobDay +
      '</vsa:date-of-birth>' +
      '<vsa:employment><vsa:employer type="C"><vsa:name>' +
      cEmployer +
      '</vsa:name></vsa:employer></vsa:employment></vsa:individual>' +
      '<vsa:enquiry><vsa:account-type-code>' +
      atCode +
      '</vsa:account-type-code>' +
      '<vsa:enquiry-amount currency-code="' +
      currencyCode +
      '">' +
      enquiryAmtLong +
      '</vsa:enquiry-amount>' +
      '<vsa:is-credit-review>' +
      this.isCR +
      '</vsa:is-credit-review>' +
      '<vsa:relationship-code>' +
      relationshipCode +
      '</vsa:relationship-code>' +
      '<vsa:enquiry-client-reference>' +
      enquiryCR +
      '</vsa:enquiry-client-reference></vsa:enquiry></vsa:enquiry-data></vsa:request></soapenv:Body></soapenv:Envelope>';

    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    req.setEndpoint(servEndpointVal);
    req.setBody(reqStr);
    this.sfReq1 = reqStr;
    System.debug('@@TEST REQUEST:' + reqStr);
    req.setMethod('POST');
    req.setHeader('content-type', 'text/xml');
    // res.setHeader('content-type', 'text/xml');
    req.setTimeout(TIMEOUT_REQUEST);
    res = http.send(req);
    this.eqRes1 = res.getBody();
    Dom.Document doc = res.getBodyDocument();
    dom.XmlNode xroot = doc.getRootElement();
    try {
      System.debug('@@TEST RESPONSE:' + res.getBody());
      doc = res.getBodyDocument();
      xroot = doc.getRootElement();
    } catch (Exception e) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (doc,xroot)'
      );
      return null;
    }
    dom.XmlNode header = xroot.getChildElement(
      'Header',
      'http://schemas.xmlsoap.org/soap/envelope/'
    );
    if (header == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (header)'
      );
      return null;
    }
    
    dom.XmlNode bodyNode = xroot.getChildElement(
      'Body',
      'http://schemas.xmlsoap.org/soap/envelope/'
    );
    if (bodyNode == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (bodyNode)'
      );
      return null;
    }
    dom.XmlNode resp = bodyNode.getChildElement(
      'response',
      XML_SCORE_APPLY_XSD
    );
    if (resp == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system. (res)'
      );
      return null;
    }

    dom.XmlNode prodHeader = resp.getChildElement(
      'product-header',
      XML_SCORE_APPLY_XSD
    );
    dom.XmlNode enquiryId = prodHeader.getChildElement(
      'enquiry-id',
      XML_SCORE_APPLY_XSD
    );

    if (
      resp.getChildElement(
        'general-messages',
        XML_SCORE_APPLY_XSD
      ) != null
    ) {
      dom.XmlNode generalMessages = resp.getChildElement(
        'general-messages',
        XML_SCORE_APPLY_XSD
      );

      //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, generalMessages.getChildElement('message', XML_SCORE_APPLY_XSD).getText()));
      putUserMessage(
        ApexPages.Severity.ERROR,
        generalMessages.getChildElement(
            'message',
            XML_SCORE_APPLY_XSD
          )
          .getText()
      );
      return null;
    }

    if (
      resp.getChildElement(
        'errors',
        XML_SCORE_APPLY_XSD
      ) != null
    ) {
      dom.XmlNode errors = resp.getChildElement(
        'errors',
        XML_SCORE_APPLY_XSD
      );
      dom.XmlNode error = errors.getChildElement(
        'error',
        XML_SCORE_APPLY_XSD
      );
      //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, error.getChildElement('detail', XML_SCORE_APPLY_XSD).getText()));
      putUserMessage(
        ApexPages.Severity.ERROR,
        error.getChildElement(
            'detail',
            XML_SCORE_APPLY_XSD
          )
          .getText()
      );
      return null;
    }

    // ResponseHeader rh = new ResponseHeader();
    // rh.messageId = '<b>Enquiry Id:</b> ' + enquiryId.getText();
    // rh.relatesTo =
    //   '<b>Relates To:</b> ' +
    //   header.getChildElement(
    //       'RelatesTo',
    //       'http://www.w3.org/2005/08/addressing'
    //     )
    //     .getText();
    // rh.hTo =
    //   '<b>To:</b> ' +
    //   header.getChildElement('To', 'http://www.w3.org/2005/08/addressing')
    //     .getText();
    // rh.hFrom =
    //   '<b>From Address:</b> ' +
    //   header.getChildElement('From', 'http://www.w3.org/2005/08/addressing')
    //     .getChildElement('Address', 'http://www.w3.org/2005/08/addressing')
    //     .getText();
    // rh.action =
    //   '<b>Action:</b> ' +
    //   header.getChildElement('Action', 'http://www.w3.org/2005/08/addressing')
    //     .getText();

    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'PDF File Uploaded.'));
    //putUserMessage(ApexPages.Severity.INFO, 'PDF File Uploaded.');
    /*ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, rh.relatesTo));
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, rh.hTo));
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, rh.hFrom));
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, rh.action));
*/
    this.eqRes1 = '{enquiry-id:"'+enquiryId.getText()+'"}';
    String reqStr2 =
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>' +
      usernameVal + // vs.Username__c +
      '</wsse:Username><wsse:Password>' +
      passwordVal + // vs.Password__c +
      '</wsse:Password></wsse:UsernameToken></wsse:Security><wsa:Action>http://vedaxml.com/previousEnquiry/ServiceRequest</wsa:Action></soapenv:Header><env:Body xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><prev:request xmlns:prev="http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd"><prev:enquiryId>' +
      enquiryId.getText() +
      '</prev:enquiryId><prev:contentType>application/pdf</prev:contentType></prev:request></env:Body></soapenv:Envelope>';
    HttpRequest req2 = new HttpRequest();
    HttpResponse res2 = new HttpResponse();
    Http http2 = new Http();
    String endpoint2 = repEndpointVal; // vs.report_endpointURL__c;
    req2.setEndpoint(endpoint2);
    req2.setBody(reqStr2);
    req2.setMethod('POST');
    req2.setHeader('content-type', 'text/xml');
    req2.setTimeout(TIMEOUT_REQUEST);
    System.debug('@@ request report:' + reqStr2);
    this.sfReq2 = reqStr2;
    res2 = http2.send(req2);
    Dom.Document doc2 = null;
    dom.XmlNode xroot2 = null;
    try {
      this.eqRes2 = res2.getBody();
      System.debug('@@ response report:' + this.eqRes2);
      
      doc2 = res2.getBodyDocument();
      xroot2 = doc2.getRootElement();
    } catch (Exception e) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (doc,xroot)'
      );
      return null;
    }
    dom.XmlNode bodyNode2 = xroot2.getChildElement(
      'Body',
      'http://schemas.xmlsoap.org/soap/envelope/'
    );
    if (bodyNode2 == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (bodyNode2)'
      );
      return null;
    }
    dom.XmlNode resp2 = bodyNode2.getChildElement(
      'response',
      'http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd'
    );
    if (resp2 == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (resp2)'
      );
      return null;
    }
    dom.XmlNode binaryData = resp2.getChildElement(
      'binaryData',
      'http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd'
    );
    if (binaryData == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (binaryData)'
      );
      return null;
    }

    this.eqRes2 = '{message:"binary data received!"}';

    Blob body;
    // System.debug('@@binaryData.getText():' + binaryData.getText());
    body = EncodingUtil.base64Decode(binaryData.getText());
    Attachment attach = new Attachment();
    attach.ParentId = this.parentId;
    attach.Body = body;
    attach.ContentType = 'application/pdf';
    attach.IsPrivate = false;
    attach.Name = fname + ' ' + lname + ' - EquifaxScore Apply.pdf';
    insert attach;

    putUserMessage(ApexPages.Severity.INFO, 'PDF File received.');

    this.eqRes2 = '{message:"binary data received and attachment created ['+attach.Id+']!"}';

    isProcessOK = true;

    return null;
  }

  public class ResponseHeader {
    String messageId;
    String relatesTo;
    String hTo;
    String hFrom;
    String action;
  }

  public void validateVedaForm() {
    if (!hasESignLiveCompleted()) {
      // ApexPages.addMessage(
      //   new ApexPages.Message(
      //     ApexPages.Severity.WARNING,
      //     'There is not any completed E-Consent in the Opportunity Transaction section, please be sure that all applicants have signed a consent before proceeding with a credit file assessment.'
      //   )
      // );
      if (!hasDocsUploaded()) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Privacy consent not completed. Enquiry cannot proceed.'
          )
        );
      }
    }
  }

  private Boolean hasESignLiveCompleted() {
    /*
     * Boolean r = false;
     * String sql = 'SELECT Id, ESL__Status__c FROM ESL__Package__c ' +
     * 'WHERE eSignLive_Opportunity_Lookup__c = :parentId ' +
     * 'AND ESL__Status__c = \'Completed\'';
     * List<SObject> d = Database.query(sql);
     * // List<ESL__Package__c> d = [SELECT Id, ESL__Status__c FROM ESL__Package__c
     * //                          WHERE eSignLive_Opportunity_Lookup__c = :this.parentId
     * //                          AND ESL__Status__c = 'Completed'];
     * if (!d.isEmpty()) {
     * r = true;
     * }
     * return r;
     */
    Integer numPeople = 1;
    if (oppty.Application__r.No_of_People__c != null) {
      numPeople = oppty.Application__r.No_of_People__c.intValue();
    }

    Set<Id> eslPackIds = new Set<Id>();
    Boolean isApplic1Ok = false;
    Boolean isApplic2Ok = false;
    List<ESL__Package__c> eslPacks = null;
    eslPacks = [
      SELECT Id
      FROM ESL__Package__c
      WHERE
        eSignLive_Opportunity_Lookup__c = :oppty.Id
        AND (ESL__Status__c = 'Completed' OR 
        ESL__Signer_Status__c = 'All Recipients have signed.')
    ];
    if (!eslPacks.isEmpty()) {
      for (ESL__Package__c x : eslPacks) {
        eslPackIds.add(x.Id);
      }
      List<ESL__Package_Signer__c> elsPackSigns = [
        SELECT Id, ESL__Email__c
        FROM ESL__Package_Signer__c
        WHERE ESL__Package__c IN :eslPackIds
      ];
      if (!elsPackSigns.isEmpty()) {
        for (ESL__Package_Signer__c y : elsPackSigns) {
          if (
            oppty.Application__r.Email_Address__c.equals(y.ESL__Email__c) ||
            oppty.Email_Address__c.equals(y.ESL__Email__c)
          ) {
            isApplic1Ok = true;
          }
          if (
            numPeople == 2 &&
            oppty.Application__r.Email_Address_2__c.equals(y.ESL__Email__c)
          ) {
            isApplic2Ok = true;
          }
        }
        if (numPeople == 2) {
          if (isApplic1Ok && isApplic2Ok) {
            return true;
          }
          if (!isApplic2Ok) {
            ApexPages.addmessage(
              new ApexPages.message(
                ApexPages.severity.WARNING,
                'The 2nd  applicant\'n email [' +
                oppty.Application__r.Email_Address_2__c +
                '] couldn\'t be found in any e-consent transaction.'
              )
            );
          }
        } else {
          if (isApplic1Ok) {
            return true;
          }
        }
        if (!isApplic1Ok) {
          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.severity.WARNING,
              'The 1st applicant\'n email [' +
              oppty.Application__r.Email_Address__c +
              '] couldn\'t be found in any e-consent transaction.'
            )
          );
        }
      }
    }
    /*}
     }*/
    return false;
  }

  private Boolean hasDocsUploaded() {
    return PreApprovalValidatorHelper.hasSavvyConsentUploaded(oppty);
  }

  public void downloadFile() {
    this.resetUserMessages();

    //String u = vs.Username__c;
    //String p = vs.Password__c;

    // String u = 'SFLR4zfxXr';
    // String p = 'CCPo28Pr99';

    String reqStr2 =
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' +
      '<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">' +
      '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
      '<wsse:UsernameToken><wsse:Username>' +
      usernameVal +
      '</wsse:Username><wsse:Password>' +
      passwordVal +
      '</wsse:Password></wsse:UsernameToken></wsse:Security>' +
      '<wsa:Action>http://vedaxml.com/previousEnquiry/ServiceRequest</wsa:Action></soapenv:Header>' +
      '<env:Body xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">' +
      '<prev:request xmlns:prev="http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd">' +
      '<prev:enquiryId>' +
      this.enquiryId +
      '</prev:enquiryId><prev:contentType>application/pdf</prev:contentType>' +
      '</prev:request></env:Body></soapenv:Envelope>';
    HttpRequest req2 = new HttpRequest();
    HttpResponse res2 = new HttpResponse();
    Http http2 = new Http();

    // String endpoint2 = vs.report_endpointURL__c;
    String endpoint2 = 'https://vedaxml.com/sys2/previous-enquiry-v1';

    System.debug('@@ endpoint:' + endpoint2);
    req2.setEndpoint(endpoint2);
    req2.setBody(reqStr2);
    req2.setMethod('POST');
    req2.setHeader('content-type', 'text/xml');
    req2.setTimeout(TIMEOUT_REQUEST);
    System.debug('@@ request report:' + reqStr2);
    res2 = http2.send(req2);
    Dom.Document doc2 = null;
    dom.XmlNode xroot2 = null;
    try {
      System.debug('@@ response report:' + res2.getBody());
      doc2 = res2.getBodyDocument();
      xroot2 = doc2.getRootElement();
    } catch (Exception e) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (doc,xroot)'
      );
      return;
    }
    dom.XmlNode bodyNode2 = xroot2.getChildElement(
      'Body',
      'http://schemas.xmlsoap.org/soap/envelope/'
    );
    if (bodyNode2 == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (bodyNode2)'
      );
      return;
    }
    dom.XmlNode resp2 = bodyNode2.getChildElement(
      'response',
      'http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd'
    );
    if (resp2 == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (resp2)'
      );
      return;
    }
    dom.XmlNode binaryData = resp2.getChildElement(
      'binaryData',
      'http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd'
    );
    if (binaryData == null) {
      putUserMessage(
        ApexPages.Severity.ERROR,
        'Please try again. No response obtained from provider system.  (binaryData)'
      );
      return;
    }

    Blob body;
    System.debug('@@binaryData.getText():' + binaryData.getText());
    body = EncodingUtil.base64Decode(binaryData.getText());
    Attachment attach = new Attachment();
    attach.ParentId = this.parentId;
    attach.Body = body;
    attach.ContentType = 'application/pdf';
    attach.IsPrivate = false;
    attach.Name = fname + ' ' + lname + ' - EquifaxScore Apply.pdf';
    insert attach;

    putUserMessage(ApexPages.Severity.INFO, 'PDF File received.');
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
}