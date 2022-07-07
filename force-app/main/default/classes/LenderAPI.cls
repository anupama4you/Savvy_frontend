public class LenderAPI {
  public static APIResponse invokeApi(Id oppId) {
    return invokeApi(oppId, UserInfo.getUserId());
    // return invokeApi_Fake(oppId, UserInfo.getUserId());
  }

  /*
  public static APIResponse invokeApi_Fake(Id oppId, Id userId) {
    APIResponse res = new APIResponse();
    res.response = [
      SELECT
        Name,
        Opportunity__c,
        Request__c,
        Response__c,
        Status__c,
        Provider__c,
        Service__c,
        Quoting_Source__c,
        Application_ID__c,
        Lender_Login__c,
        Id
      FROM LenderAPIResponse__c
      WHERE Id = 'a2T1y000000IY4dEAG'
    ];
    res.errors.add(
      '[App_PRE_APPROVAL__a011y000002lxwAAAQ_20211028172804.pdf]: The Application is currently locked in Solana. Please retry again in a moment'
    );
    res.errors.add(
      '[App_PRE_APPROVAL__a011y000002lxwAAAQ_20211028162802.pdf]: The Application is currently locked in Solana. Please retry again in a moment'
    );
    res.errors.add(
      '[App_PRE_APPROVAL__a011y000002lxwAAAQ_20211028163834.pdf]: The Application is currently locked in Solana. Please retry again in a moment'
    );
    res.warnings.add(
      'There are some errors upploading documents, please try to send them again in Quoting Tools.'
    );
    res.docs = [
      SELECT
        Name,
        Opportunity__c,
        Request__c,
        Response__c,
        Status__c,
        Provider__c,
        Service__c,
        Quoting_Source__c,
        Application_ID__c,
        Lender_Login__c,
        Id,
        Cloud_Document__c,
        Message__c,
        DocumentUUID__c,
        LenderAPIResponse__c
      FROM LenderAPIResponse__c
      WHERE
        id IN ('a2T1y000000IY4eEAG', 'a2T1y000000IY4fEAG', 'a2T1y000000IY4gEAG')
    ];
    res.status = res.response != null && res.response.Status__c == 200? '0' : '1';
    // res.status = res.errors.isEmpty() ? '0' : '1';
    
    return res;
  }
  */

  public static APIResponse invokeApi(Id oppId, Id userId) {
    APIResponse res = new APIResponse();
    res.status = '1';
    // ------------------------
    // Opportunity ID validation
    if (String.isBlank(oppId)) {
      res.errors.add('Opportunity ID not provided');
      return res;
    }
    // -------------------------------
    // Validate API support validation
    Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(
      oppId,
      null
    );
    if (q == null) {
      res.errors.add('Quoting calculation not found');
      return res;
    }

    Lenders__c lenderSets = QuotingCalculation.getLenderSettings(q.Name);
    if (lenderSets == null) {
      res.errors.add(
        'Lender Settings for <b>' +
        q.Name +
        '</b> not found'
      );
      return res;
    }

    String lenderLabel = (lenderSets != null &&
      String.isNotBlank(lenderSets.Label__c))
      ? lenderSets.Label__c : q.Name;
    if (!hasQuotingToolAPISupport(q.Name)) {
      res.errors.add(
        'API support for <b>' +
        lenderLabel +
        '</b> not found supported'
      );
      return res;
    }

    // ----------------------------------
    // Validate current user API settings
    Id partnerId = null;
    if (
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      !SOQLSingletonQueries.recs().isFranchised
    ) {
      // Check main account settings
      Contact c = SOQLSingletonQueries.recs().myContact;
      partnerId = c != null ? c.AccountId : null;
      if (!hasPartnerAPISetting(partnerId, lenderSets.API_Provider__c)) {
        res.errors.add('API Settings for <b>' + lenderLabel + '</b> not found');
        return res;
      }
    }

    // Check opportunity owner settings (Lender logins)
    Lender_Login__c lenderLogin = null;
    if (lenderSets.Broker_Login_Required__c) {
      System.debug(
        'userId [' +
        userId +
        '] lenderSets.API_Broker_Provider__c [' +
        lenderSets.API_Broker_Provider__c +
        ']'
      );
        lenderLogin = getLenderLogin(
        userId,
        lenderSets.API_Broker_Provider__c
      );
      if (lenderLogin == null) {
        res.errors.add(
          'Your lender credentials for <b>' +
          lenderSets.API_Broker_Provider__c +
          '</b> were not found'
        );
        return res;
      }
    }

    // ------------------
    // API implementation
    // ------------------
    if (
      'Pepper MV'.equals(q.Name) ||
      'Pepper Leisure'.equals(q.Name) ||
      'Pepper Commercial'.equals(q.Name)
    ) {
      res = invokePepperAPI(oppId, q, lenderLogin.User_Name__c);
    } else if ('RateSetter'.equals(q.Name) || 'RateSetter PL'.equals(q.Name)) {
      res = invokePlentiAPI(oppId, q, 'RateSetter PL'.equals(q.Name));
    } else if (
      'Finance One'.equals(q.Name) || 'Finance One Commercial'.equals(q.Name)
    ) {
      res = invokeFinanceOneAPI(oppId, lenderLogin.User_Name__c);
    } else if ('Latitude'.equals(q.Name)) {
      res = invokeLatitudeAPI(oppId, lenderLogin.User_Name__c);
    } else if ('Money3'.equals(q.Name)) {
      res = invokeMoney3API(oppId, q, lenderLogin.User_Name__c);
    }
    // ------------------
    // res.status = String.isBlank(res.status) && !res.errors.isEmpty() ? '0' : '1';

    System.debug('result => ' + JSON.serializePretty(res));
    System.debug('Final errors => ' + res.errors.size());

    return res;
  }
  // **************
  // Helper methods
  // **************
  public static Boolean hasQuotingToolAPISupport(String quotingName) {
    Set<String> apis = new Set<String>{
      'Pepper MV',
      'Pepper Leisure',
      'RateSetter',
      'RateSetter PL',
      'Finance One',
      'Finance One Commercial',
      'Latitude',
      'Money3'
    };
    return String.isNotBlank(quotingName) && apis.contains(quotingName);
  }

  public static Boolean hasPartnerAPISetting(Id accountId, String provider) {
    System.debug(
      'hasPartnerAPISetting => accountId [' +
      accountId +
      '] provider [' +
      provider +
      ']'
    );
    List<Partner_API_Setting__c> d = null;
    if (String.isNotBlank(accountId) && String.isNotBlank(provider)) {
      d = [
        SELECT Id
        FROM Partner_API_Setting__c
        WHERE Account__c = :accountId AND Provider__c = :provider
      ];
      System.debug('result => ' + d.isEmpty());
    }
    return d != null && !d.isEmpty();
  }

  public static Lender_Login__c getLenderLogin(Id userId, String lender) {
    System.debug(
      'getLenderLogin => userId [' +
      userId +
      '] lender [' +
      lender +
      ']'
    );
    Lender_Login__c r = null;
    if (String.isNotBlank(userId) || String.isNotBlank(lender)) {
      List<Lender_Login__c> d = [
        SELECT Id, User_Name__c
        FROM Lender_Login__c
        WHERE OwnerId = :userId AND Lender__c = :lender
        ORDER BY LastModifiedDate DESC
        LIMIT 1
      ];
      r = !d.isEmpty() ? d.get(0) : null;
    }
    return r;
  }

  public static Custom_Opportunity__c getOpp(Id oppId, List<String> fields) {
    String sql =
      'Select ' +
      buildFields(fields) +
      ' From Custom_Opportunity__c ';
    sql += 'Where Id = :oppId ';
    List<Custom_Opportunity__c> d = Database.query(sql);
    return !d.isEmpty() ? d.get(0) : null;
  }

  public static String buildFields(List<String> fields) {
    String r = '';
    if (fields != null && !fields.isEmpty()) {
      for (String a : fields) {
        if (String.isNotBlank(r)) {
          r += ',';
        }
        r += a;
      }
    }
    return r;
  }

  // ***************
  // Parameter Class
  // ***************
  public class APIResponse extends GenericResponse {
    @AuraEnabled
    public LenderAPIResponse__c response { get; set; }
    @AuraEnabled
    public List<LenderAPIResponse__c> docs { get; set; }

    public APIResponse() {
      super();
      this.response = null;
      this.docs = null;
    }
  }

  public virtual class GenericResponse {
    @AuraEnabled
    public String status { get; set; }
    @AuraEnabled
    public Set<String> errors { get; set; }
    @AuraEnabled
    public Set<String> warnings { get; set; }

    public GenericResponse() {
      this.status = null;
      this.errors = new Set<String>();
      this.warnings = new Set<String>();
    }
  }

  // *******************
  // API Implementations
  // *******************
  // Pepper API Implementation
  public static APIResponse invokePepperAPI(
    Id oppId,
    Application_Quoting__c quoting,
    String apiUser
  ) {
    APIResponse res = new APIResponse();
    // Preparing parameters
    Custom_Opportunity__c opp = new Custom_Opportunity__c(Id = oppId);
    PepperAPIManager mgr = new PepperAPIManager();
    PepperApplicationService srv = new PepperApplicationService();

    // Invoke the service
    try {
      mgr = srv.requestApplication(mgr, opp, apiUser, 'N/A');
      System.debug('mgr.isError => ' + mgr.isError);
      res.status = mgr.isError ? '1' : '0';
      if (mgr.hasErrorMessages()) {
        res.errors = mgr.getErrorMessages();
      }
      if (mgr.isError) {
        if (String.isNotBlank(mgr.message)) {
          res.errors.add(mgr.message);
        }
      } else {
        // Update quoting tools
        quoting.PepperAPI_Application_Id__c = mgr.pepperAppResponseDTO.application.applicationNo;
        quoting.PepperAPI_Response_Message__c = mgr.pepperAppResponseDTO.requestId;
        quoting.PepperAPI_Last_Response_App__c = mgr.pepperAppResponseDTO.lastResponseApplication;
        update quoting;
      }
      if (mgr.hasWarningsMessages()) {
        res.warnings = mgr.getWarningMessages();
      }
    } catch (GenericException e) {
      res.errors.add(e.getMessage());
    }

    // Create Lender API Response
    res.response = PepperAPIManager.saveLenderAPIResponse(
      mgr,
      oppId,
      quoting.Name,
      apiUser
    );
    // Documents
    if (
      mgr.pepperAppResponseDTO != null && 
      mgr.pepperAppResponseDTO.docs != null
    ) {
      res.docs = mgr.pepperAppResponseDTO.docs;
    }
    return res;
  }

  // Plenti API Implementation
  public static APIResponse invokePlentiAPI(
    Id oppId,
    Application_Quoting__c quoting,
    Boolean isPLoan
  ) {
    APIResponse res = new APIResponse();
    res.status = '1';
    // Preparing parameters
    PlentiAPIService srv = new PlentiAPIService();
    try {
      PlentiAPIManager mgr = srv.requestApplication(oppId, null, isPLoan);
      if (mgr.lenderAPIResp == null) {
        res.errors.add(
          '[Plenti API] there isn\'t any Lender API Response returned to Quoting tools.'
        );
      } else {
        res.response = mgr.lenderAPIResp;
        quoting.LenderAPIResponse__c = res.response.Id;
        update quoting;
        res.status = '0';
        res.response.Request__c = null;
      }
      if (mgr.hasErrorMessages()) {
        res.errors.addAll(mgr.getErrorMessages());
      }
    } catch (GenericException e) {
      res.errors.add(e.getMessage());
    }
    return res;
  }

  // Finance One
  public static APIResponse invokeFinanceOneAPI(Id oppId, String apiUser) {
    APIResponse res = new APIResponse();
    res.status = '1';
    // Preparing parameters
    try {
      FinanceOneAPIManager mgr = FinanceOneRestWS.submitApplication(oppId, null, apiUser);
      res.response = mgr.lenderRes;
      if (mgr.hasErrorMessages()) {
        res.errors = mgr.getErrorMessages();
      }
      res.status = res.errors.isEmpty()? '0' : '1';
    } catch (GenericException e) {
      res.errors.add(e.getMessage());
    }
    return res;
  }

  // Latitude
  public static APIResponse invokeLatitudeAPI(Id oppId, String apiUser) {
    APIResponse res = new APIResponse();
    res.status = '1';
    // Preparing parameters
    LatitudeAPIService l = new LatitudeAPIService();
    try {
      Custom_Opportunity__c opp = getOpp(
        oppId,
        new List<String>{
          'Name',
          'Application__c',
          'Application_AssetDetail__c',
          'Application_AssetDetail__r.Variant__c'
        }
      );
      res.response = l.requestApplication(opp, apiUser);
      res.status = l.hasErrorMessages()? '1' : '0';
      if (l.hasErrorMessages()) {
        res.errors = l.getErrorMessages();
      }
    } catch (GenericException e) {
      res.errors.add(e.getMessage());
    }
    return res;
  }

  // Money3
  public static APIResponse invokeMoney3API(
    Id oppId,
    Application_Quoting__c quoting,
    String apiUser
  ) {
    APIResponse res = new APIResponse();
    res.status = '1';
    // Preparing parameters
    Money3APIManager mgr = new Money3APIManager();
    try {
      Money3APIService srv = new Money3APIService();
      
      srv.requestApplication(mgr, oppId, apiUser, false);

      // Update quoting tools
      quoting.Money3_Broker_Reference_Id__c = mgr.responseDto.brokerReferenceLoanId;
      quoting.Money3_Loan_Id__c = mgr.responseDto.loanId;
      quoting.Money3_Last_Response_App__c = mgr.responseDto.lastResponseApplication;
      update quoting;
      res.status = '0';
    } catch (GenericException e) {
      res.errors.add(e.getMessage());
    }

    res.response = Money3APIManager.saveLenderAPIResponse(
      oppId,
      mgr,
      quoting.Name,
      apiUser
    );

    return res;
  }

}