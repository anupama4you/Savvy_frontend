public class LibertyServiceManager extends APIServiceManager{
    
    String endPointLiberty;
    String authorization;
    public LibertyApplicationResponse libertyApplicationResponse {set; get;}
    
    public static final String LiB_SERVICE_ENDPOINT = 'Liberty_Service_Endpoint';
    public static final String LiB_SERVICE_CLIENT_NAME = 'Liberty_Service_Client_Name';
    public static final String LiB_SERVICE_CLIENT_PWD = 'Liberty_Service_Client_Pwd';
    public static final String LENDER_LIBERTY = 'Liberty';
    
    public LibertyServiceManager(){
      clean();
      loadSettings();
    }
    
    // public LibertyServiceManager(String endPointLiberty, String authorization){
    //     //-> Production: https://api.liberty.com.au/MotorDataService/Submit
    //     //-> Sandbox: https://api.liberty.com.au/motor-application/submit 
    //     this.endPointLiberty = endPointLiberty;
    //     this.authorization = authorization;
    // }
    
    private void loadSettings(){
      List<Parameters_Service__c> params;
      params = Parameters_Service__c.getAll().values();
      //endPointLiberty = Parameters_Service__c.getValues('Liberty_Service_Endpoint').value__c;
      endPointLiberty = getParameterService(LiB_SERVICE_ENDPOINT);
      //String clientName = Parameters_Service__c.getValues('Liberty_Service_Client_Name').value__c;
      //String pwd = Parameters_Service__c.getValues('Liberty_Service_Client_Pwd').value__c;
      String clientName = getParameterService(LiB_SERVICE_CLIENT_NAME);
      String pwd = getParameterService(LiB_SERVICE_CLIENT_PWD);
      authorization = EncodingUtil.base64Encode(Blob.valueOf(clientName + ':' + pwd));
    }
    
    private Map<String, String> getHeadersServiceWithAuthorized(){
      Map<String, String> requestHeader = new Map<String, String>();
      requestHeader.put(
        ConnectionRESTWs.CONTENT_TYPE_HEADER , 
        ConnectionRESTWs.CONTENT_TYPE_XML
      );
      requestHeader.put(
        'Authorization' , 
        'Basic ' + authorization
      );
      return requestHeader;
    }
    
    private void validateResponse (HttpResponse resp, String body){
        if (resp != null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, resp.getBody()));
            String xml = resp.getBody();
            libertyApplicationResponse = new LibertyApplicationResponse().XMLParse (xml);
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, body));
    }

    public LibertyApplicationResponse requestApplication (
      Custom_Opportunity__c opp, 
      Boolean isConsumerLoan, 
      String user
    ){
        System.debug('Debug liberty App:::********************************************************** - I');
        ConnectionRESTWs conn;
        LibertyApplicationService appLiberty = new LibertyApplicationService();
        String body = appLiberty.requestApplication(
          opp, 
          isConsumerLoan, user
        );
        conn = new ConnectionRESTWs(
          endPointLiberty, 
          ConnectionRESTWs.POST, 
          ConnectionRESTWs.CONTENT_TYPE_XML
        );
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.INFO, 
            conn.method +'-' + conn.content_type + '-' + conn.endpoint
          )
        );	
        
        HttpResponse resp;
        try {
          resp = conn.connectionServiceHttpResponse(
            getHeadersServiceWithAuthorized(), 
            body
          );
        }catch (GenericException ex){
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING, 
              ex.getMessage()
              )
            );
        }
        validateResponse (resp, body);
        if (libertyApplicationResponse != null){
            String st = libertyApplicationResponse.apiResponse.status.value;
            if (st.equalsIgnoreCase('Accepted')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status: ' + st));
                String appNumber = libertyApplicationResponse.apiResponse.applicationNumber.value;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'ApplicationNumber: ' + appNumber));
                libertyApplicationResponse.apiResponse.lastResponseApp =DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
            }else if (libertyApplicationResponse.apiResponse.validationErrors != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Status: ' + st));
                for ( integer i = 0; i < libertyApplicationResponse.apiResponse.validationErrors.size(); i++){
                    LibertyApplicationResponse.ValidationError v = libertyApplicationResponse.apiResponse.validationErrors.get(i);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Validate error ('+i+') : ' + v.value));
                }
                return null;
            }
        }
        System.debug('Debug liberty App:::********************************************************** - F');
        return libertyApplicationResponse;
    }
    
  public LibertyApplicationResponse requestApplicationTest (
    Custom_Opportunity__c opp, 
    Boolean isConsumerLoan, 
    String user
  ){
    System.debug('Debug liberty App (Test):::********************************************************** - I');
    LibertyApplicationService appLiberty = new LibertyApplicationService();
    String body = appLiberty.requestApplication(
      opp, 
      isConsumerLoan, 
      user
    );
    ApexPages.addMessage(
      new ApexPages.Message(
        ApexPages.Severity.INFO, 
        body
      )
    );	
    System.debug('Debug liberty App (Test):::********************************************************** - F');
    return libertyApplicationResponse;
  }
    
  public static List <SelectOption> getUserOptionsConnect(){
    List <SelectOption> usersOptions = new List <SelectOption> ();
    usersOptions.add(new SelectOption ('', 'None'));
    Set<Id> userIds = SOQLSingletonQueries.getGroupMembers('Sales Consultants');
    List<Lender_Login__c> lendersLogin = [
      SELECT 
        Id, 
        User_Name__c, 
        Owner.Name, 
        Consumer_Key__c 
      FROM Lender_Login__c 
      WHERE Lender__c = :LENDER_LIBERTY 
      AND User_Name__c <> '' 
      AND OwnerId in :userIds
      ORDER BY Owner.Name
    ];
    for (Lender_Login__c u : lendersLogin){
      usersOptions.add(new SelectOption (u.User_Name__c,u.User_Name__c + '-' + u.Owner.Name));
    }
    usersOptions.add(new SelectOption ('NFCH0513','NFCH0513-Alister Clare'));
    usersOptions.add(new SelectOption ('NFCH0880','Armando Cerquozzi'));
    return usersOptions;
  }
}