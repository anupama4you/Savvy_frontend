public class PepperAPIManager extends APIServiceManager{
    
    public static final String Pepper_MV = 'MV';
    public static final String Pepper_Leisure = 'LS';
    public static final String Pepper_5Oh = '5O';
    public static final String Pepper_Summer = 'SM';
    
    public static final String PEPPER_SERVICE_ENDPOINT = 'Pepper_Service_Endpoint';
    public static final String PEPPER_SERVICE_CLIENT_ID= 'Pepper_Service_Client_ID';
    public static final String PEPPER_SERVICE_CLIENT_SECRET= 'Pepper_Service_Client_Secret';
    public static final String PEPPER_SERVICE_MERCHANT_ID = 'Pepper_Service_Merchant_ID';
    
    public static final String LENDER_PEPPER = 'Pepper';    
    public PepperApplicationResponseDTO pepperAppResponseDTO {set; get;}
    
    public PepperApplicationResponseDTO parseCreateApplicationResponse (String jsonString){
      try{
        JSONParser parser = JSON.createParser(jsonString);
        this.pepperAppResponseDTO = (PepperApplicationResponseDTO) parser.readValueAs(PepperApplicationResponseDTO.class);
        this.pepperAppResponseDTO.lastResponseApplication = DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
        return pepperAppResponseDTO;
      }catch (Exception ex){
        this.pepperAppResponseDTO = null;
        String msg = '@Error parse object *createApplicationResponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
        System.debug(msg);
        throw new GenericException(msg, ex);
      }
    }

    public static List <SelectOption> getUserOptionsConnect(){
        List <SelectOption> usersOptions = new List <SelectOption> ();
        usersOptions.add(new SelectOption ('', 'None'));
        //usersOptions.add(new SelectOption ('ewu','ewu'));
        //usersOptions.add(new SelectOption ('aclare','aclare'));
        
        
        // List<Lender_Login__c> lendersLogin = [SELECT Id, User_Name__c, Owner.Name, Consumer_Key__c, Owner.Email 
        //                                       FROM Lender_Login__c where Lender__c = :LENDER_PEPPER 
        //                                       and Owner.isActive = true ORDER BY Owner.Name];
        List<Lender_Login__c> lendersLogin = APIServiceManager.listLenderLogins(LENDER_PEPPER);

        for (Lender_Login__c u : lendersLogin){
          usersOptions.add(new SelectOption (u.User_Name__c, u.Owner.Name));
          // if (SOQLSingletonQueries.recs().isBrokerPartnerUser) {
          //   usersOptions.add(new SelectOption (u.User_Name__c, u.Owner.Name));
          // } else {
          //   // usersOptions.add(new SelectOption (u.Owner.Email, u.Owner.Name + ' [' + u.User_Name__c + ']'));
          //   usersOptions.add(new SelectOption (u.User_Name__c, u.Owner.Name));
          // }
        }
        // usersOptions.add(new SelectOption ('armando.l@savvy.com.au','Armando Cerquozzi'));
		    // usersOptions.add(new SelectOption ('QuantumSavvy.User1','Test User 1'));
        return usersOptions;
    }
        
    // public static String getProductNumber(String privateSales){
    //     if ('Y'.equals(privateSales)) {
    //         return '131';
    //     }
    //     return '130';
    // }
     
    public static Boolean isTwoApplicants(Id oppId){
        Custom_Opportunity__c c = [SELECT Id, Application__c, Application__r.No_of_People__c from Custom_Opportunity__c where Id=: oppId];
        if(c!= null && c.Application__c != null && c.Application__r.No_of_People__c == 2){
            return true;
        } else {
            return false;
        }
    }

  public static LenderAPIResponse__c saveLenderAPIResponse(PepperAPIManager mgr, Id oppId, String quotingName, String apiUser) {
    LenderAPIResponse__c lar = null;
    Boolean resOK = false;
    System.debug(mgr);
    System.debug(mgr.responseMessage);
    if (
      mgr != null &&
      String.isNotBlank(mgr.responseMessage)
    ) {
      lar = new LenderAPIResponse__c();
      lar.Name = quotingName;
      lar.Opportunity__c = oppId;
      lar.Request__c = mgr.reqBody;
      lar.Response__c = mgr.responseMessage;
      lar.Status__c = mgr.responseStatus;
      lar.Provider__c = 'Pepper';
      lar.Service__c = 'consumer';
      if ('Pepper Commercial'.equals(quotingName)) {
        lar.Service__c = 'commercial';
      }
      lar.Quoting_Source__c = quotingName;
      if (
        mgr.pepperAppResponseDTO != null &&
        mgr.pepperAppResponseDTO.application != null &&
        mgr.pepperAppResponseDTO.application.applicationNo != null
      ) {
        lar.Application_ID__c = mgr.pepperAppResponseDTO.application.applicationNo;
        lar.Name += ' [' + lar.Application_ID__c + ']';
        lar.Lender_Login__c = apiUser;
        resOK = true;
      } else {
        lar.Name += ' [FAIL-' + DateUtils.getTimeForFileName() + ']';
      }

      insert lar;

      if (resOK) {
        saveLenderAPIResponseFiles(lar.Id, mgr);
      }
    }
    return lar;
  }

  public static void saveLenderAPIResponseFiles(Id apiResponseId, PepperAPIManager mgr) {
    if (
      String.isNotBlank(apiResponseId) &&
      mgr != null &&
      mgr.pepperAppResponseDTO.docs != null && 
      !mgr.pepperAppResponseDTO.docs.isEmpty()
    ) {
      for (LenderAPIResponse__c l : mgr.pepperAppResponseDTO.docs) {
        l.LenderAPIResponse__c = apiResponseId;
        l.Provider__c = 'Pepper';
        l.Service__c = 'supportingDocuments';
      }
      insert mgr.pepperAppResponseDTO.docs;
    }
  }

  public void processHttpResponse(HttpResponse resp) {
    System.debug('processHttpResponse...');
    this.isError = true;
    this.message = null;
    if (resp == null) {
      this.message = 'Response not received';
    } else {
      this.responseStatus = resp.getStatusCode();
      this.responseMessage = resp.getBody();
      // Parse the response body
      try {
        this.parseCreateApplicationResponse(resp.getBody());
      } catch (GenericException e) {
        this.message = e.getMessage();
        return;
      }
      System.debug('Validating status code...');
      // Validate response codes
      switch on resp.getStatusCode() {
        when 200, 201 {
          this.isError = false;
        }
        when 400 {
          this.message = (
            this.pepperAppResponseDTO != null &&
            String.isNotBlank(this.pepperAppResponseDTO.errorMessage)
          ) ? this.pepperAppResponseDTO.errorMessage 
            : 'Bad Request - This can mean that a required field or parameter has not been provided correctly, the value supplied is invalid or the combination of provided fields is invalid';
        }
        when 401 {
          this.message = 'Unauthorised. Either the provided username and password combination is invalid, or the user is not allowed to access the content provided by the requested URL';
        }
        when 500 {
          this.message = 'System Backend error - This can mean that unexpected backend system error response received from Insurers system.';
        }
        when 503 {
          this.message = 'Service Unavailable (down time or outages) - This can mean that the requested service is currently unavailable or unable to handle the request due to a temporary overload or scheduled maintenance.';
        }
        when else {
          this.message = '[' + resp.getStatusCode() + '] Undefined error';
        }
      }
      if (String.isNotBlank(this.message)) {
        this.message = '[API Service] ' + this.message;
      }
      System.debug('message => ' + this.message);
    }
  }

}