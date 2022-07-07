@isTest(SeeAllData=true)
public class TestMacquarieAPI {
    
    public static Custom_Opportunity__c opp;
    public static Decimal totalInsurance;
    
    public static McqQuoteResponseDTO respQuote;
    public static McqCreditApplicationResponseDTO respApp;
    
    public static String consumer_key = '6c9-70354c2b63ee';
    
    
    public static String bodyAuth = '{"access_token": "6dhAx3eoaNfyo4JagQaER9lVAGt0","token_type": "BearerToken","expires_in": "3599","scope": "leasing","state": ""}';
    
    public static String xml = '<savvy><test1>Hi</test1></savvy>';
    
    public static testMethod void TestAuthentication(){
        TestResponseMock_MacLeasePartner fakeAuth;
        MacquarieManager mcManager =  new MacquarieManager(); 
    	MacLeasePartnerService mcService = new MacLeasePartnerService();
        bodyAuth = '{"access_token": "Bp4JLb0x1lATdeyqNKbmdVoH2xfH","token_type": "BearerToken","expires_in": "3599","scope": "leasing","state": ""}';
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, null,null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        Test.startTest();
        try{
            mcService.authentication(mcManager,consumer_key);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        mcManager.parseAuthentication(bodyAuth).serialize();
        Test.stopTest();
    }
    
    public static testMethod void testGeneral() {
        TestResponseMock_MacLeasePartner fakeAuth;
        MacquarieManager mcManager =  new MacquarieManager(); 
    	MacLeasePartnerService mcService = new MacLeasePartnerService();
        loadData();
        mcManager.mcqAuthentication = null;
        Test.startTest();
        
        
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, respApp.serialize(true),null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
            mcService.requestCreateApplication(mcManager, opp, totalInsurance, true,consumer_key);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        
        System.debug('[Quote consumer]>> ' + mcManager.message + '. [Error] >> ' + mcManager.isError);

        Test.stopTest();
    }
    
    public static void loadData(){
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.applicationQuoting(true);
        totalInsurance = 2500;
        opp = getCustomOpportunity(Test_DataGeneratorHelper.tstOpportunity.Id);
        System.debug('-------------------->> ' + opp);
        
        respQuote = new McqQuoteResponseDTO();
    	respQuote.gross_payment = 258.58;
        respQuote.payment_frequency = 'MONTHLY';
        respQuote.customer_rate = 7.05;
        respQuote.message = 'QUOTE_CALCULATED_SUCCESSFULLY';
        respQuote.lastResponseQuote = '10/05/2017';
        
        respApp = new McqCreditApplicationResponseDTO();
        respApp.application_id = 'EAN9899796';
        respApp.message = 'QUOTE_CALCULATED_SUCCESSFULLY';
        
           
    }
    
    public static void updateData(){
        opp.Application__r.No_of_People__c = 2;
        opp.Application__r.Business_Structure__c = 'Personal';
        opp.Application__r.Application_Type__c = 'Personal';
        opp.Id = Test_DataGeneratorHelper.tstOpportunity.Id;
        update opp;
    }
    
    public static testMethod void testGeneralMacquarieService() {
        loadData();
        Test.startTest();
        TestResponseMock_MacLeasePartner fakeAuth;
        MacquarieManager mcManager =  new MacquarieManager(); 
    	MacLeasePartnerService mcService = new MacLeasePartnerService();
        
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, respQuote.serialize(true),null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
        	mcService.requestQuote(mcManager, opp, totalInsurance, true,consumer_key);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        System.debug('[Quote consumer]>> ' + mcManager.message + '. [Error] >> ' + mcManager.isError);
        
            
        updateData();
        // Test Consumer Application        
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, respApp.serialize(true),null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
            mcService.requestCreateApplication(mcManager, opp, totalInsurance, true, consumer_key);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        
        System.debug('[Quote consumer]>> ' + mcManager.message + '. [Error] >> ' + mcManager.isError);
        
        /**
        //Test Commercial Quote
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, respQuote.serialize(true),null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
        	mcService.requestQuote(mcManager, opp, totalInsurance, false);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        System.debug('[Quote commercial]>> ' + mcManager.message + '. [Error] >> ' + mcManager.isError);
        **/
        
        //Test Commercial Application
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', bodyAuth, respApp.serialize(true),null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
        	mcService.requestCreateApplication(mcManager, opp, totalInsurance, false, consumer_key);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        System.debug('[Application commercial]>> ' + mcManager.message + '. [Error] >> ' + mcManager.isError);
        
        if (mcManager.mcqAuthentication != null){
            mcManager.mcqAuthentication.toString();
            mcManager.mcqAuthentication.serialize();
        }
        if (mcManager.mcqError != null){
            mcManager.mcqError.toString();
            mcManager.mcqError.serialize();
        }
        if (mcManager.mcqQuoteResponse != null){
            mcManager.mcqQuoteResponse.toString();
            mcManager.mcqQuoteResponse.serialize();
        }
        if (mcManager.mcqCreditAppResponse != null){
            mcManager.mcqCreditAppResponse.toString();
            mcManager.mcqCreditAppResponse.serialize();
        }
        
        /**
        McqDocumentUploadRequestDTO doc = new McqDocumentUploadRequestDTO();
        doc.application_id = 'ADN';
        doc.filename= 'Filename';
        doc.document_class= 'doc';
        doc.file_content= 'sdftgseg5dsg465sd4fg6sd4g';
        doc.author= 's';
        doc.description= 'Desc';
        doc.comments= 'Comment';
        doc.toString();
        doc.serialize();
        **/
        McqErrorResponse error = new McqErrorResponse();
        error.error= 'testError';
        error.code= 'testError';
        error.message= 'testError';
        error.user= 'testError';
        error.reason= 'testError';
        error.entity_id= 'testError';
        error.entity= 'testError';
        
        McqErrorResponse.ErrorsValidationData data = new McqErrorResponse.ErrorsValidationData();
        data.code= 'testError';
        data.getDescription();
        data.message= 'testError';
        error.errors = new List<McqErrorResponse.ErrorsValidationData>();
        error.errors.add(data);
        error.toString();
        error.serialize();
        /**
        //Test with errors
        fakeAuth = new TestResponseMock_MacLeasePartner(200,'Ok', 'bodyAuth', 'respQuote.serialize(true)',null);
        Test.setMock(HttpCalloutMock.class, fakeAuth);
        try{
            mcManager.mcqAuthentication = null;
        	mcService.requestQuote(mcManager, opp, totalInsurance, true);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
        
      
        try{
        	mcService.requestDocumentUpload(mcManager, opp, 'http://', false);
        }catch (Exception ex){
            System.debug(ex.getMessage());
        }
		**/
                
        Test.stopTest();
    }
    
   
    private static Custom_Opportunity__c getCustomOpportunity (String idOpp){
        List<Custom_Opportunity__c> r = null;
        if (idOpp != null) {
            r = [Select id, Application__r.id
                        from Custom_Opportunity__c  as o where id =: idOpp];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    private static testMethod void testObjects(){
        Test.startTest();
        
        MacquarieManager mcManager = new MacquarieManager();
        try{
            mcManager.parseCreateApplicationResponse(xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        try{
            mcManager.parseQuoteResponse(xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        try{
             mcManager.parseAuthentication(xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        try{
             mcManager.parseErrorResponse(xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        
        McqAuthenticationDTO auth = new McqAuthenticationDTO();
        auth.access_token= 'test';
        auth.token_type= 'test';
        auth.expires_in= 20;
        auth.scope= 'test';
        auth.state= 'test';
        auth.serialize();
        Test.stopTest();
    }
    
    private static testMethod void testConnection(){
        Test.startTest();
        HttpResponse resp = null;
        Map<String, String> requestQuery = new Map<String, String>();
        requestQuery.put('scope', 'scope');
        requestQuery.put('grant_type', 'grant_type');
        
        Map<String, String> requestHeader = new Map<String, String>();
        requestQuery.put('grant_type', 'grant_type');
        
        requestHeader.put(MacquarieConstants.AUTHORIZATION, 'authorizationHeader');
        ConnectionRESTWs conn = new ConnectionRESTWs('endPointAuthentication', ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
        try{
             resp = conn.connectionServiceHttpResponse(requestHeader, requestQuery, xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        
        try{
             resp = conn.connectionServiceHttpResponse(requestHeader, xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        
        try{
             STring v = conn.connectionServiceBody(requestHeader, xml);
        }catch (Exception ex){
            ex.getStackTraceString();
        }
        Test.stopTest();
    }
    
}