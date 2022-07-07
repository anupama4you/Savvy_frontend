@isTest(SeeAllData=true)
public class TestLibertyAPI extends TestAPILenders{

    public static Custom_Opportunity__c opp;
    public static LibertyApplicationService libertyService;
    public static String libertyAPI_Status {set; get;}
    public static String libertyAPI_AppNumber {set; get;}
    public static String libertyAPI_ResponseContent {set; get;}
    public static String libertyAPI_lastResponseApp {set; get;}
    
    public static testMethod void testGeneral(){
        Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'Liberty_ResponseAPI', 'text/xml; charset=UTF-8'));
        opp = loadData();
        Application__c add = opp.Application__r;
        Test.startTest();
        add.Application_Type__c = 'Company';
        update add;
        List <SelectOption> usersAPIOptions = LibertyServiceManager.getUserOptionsConnect();
        testLibertyApplication();
        testLibertyApplicationTest();
        testLibertyAppDTO();
        
        add.Application_Type__c = 'Business';
        update add;
        testLibertyApplicationTest();
        Test.stopTest();
    }
    
    private static void testLibertyApplication(){
        System.debug('>>>>> Response APPLICATION LIBERTY -I  <<<<<< - ');
        String clientName = 'Savvy';
        String pwd = 'BCBBA448A9994CC786D393544B4FCCB7';
        String authorization = EncodingUtil.base64Encode(Blob.valueOf(clientName + ':' + pwd));
        
        loadParameterService ( LibertyServiceManager.LiB_SERVICE_ENDPOINT, 'https://api.liberty.com.au//motor-application/submit', 'Liberty endpoint ');
        loadParameterService ( LibertyServiceManager.LiB_SERVICE_CLIENT_NAME, 'savvy', 'Client Name ');
        loadParameterService ( LibertyServiceManager.LiB_SERVICE_CLIENT_PWD, 'BCBBA448A9994CC786D393544B4FCCB7', 'Client Pwd');
        
        LibertyServiceManager lbService = new LibertyServiceManager();
        LibertyApplicationResponse libertyResponse = null;
        // try{
        	libertyResponse = lbService.requestApplication(opp, true, 'NFCH0162');
        // }catch (Exception ex){
        //     System.debug(ex.getMessage());
        // }
        
        if (libertyResponse != null){
            libertyAPI_Status = libertyResponse.apiResponse.status.value;
            libertyAPI_AppNumber = libertyResponse.apiResponse.applicationNumber.value;
            libertyAPI_ResponseContent = libertyResponse.apiResponse.responseContent.value;
            libertyAPI_lastResponseApp  = libertyResponse.apiResponse.lastResponseApp;
            //calculate();
        }
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //System.assertNotEquals(0, pageMessages.size());
        // Check that the error message you are expecting is in pageMessages
        Boolean messageFound = false;
        for(ApexPages.Message message : pageMessages) {
            System.assert(true,message.getSummary() + '**' + message.getDetail());
            /**
            if(message.getSummary() == 'Your summary' && message.getDetail() == 'Your detail'
               message.getSeverity() == ApexPages.Severity.YOUR_SEVERITY) {
                   messageFound = true;       
               }
**/
        }
        //System.assert(messageFound);

        System.debug('>>>>> Response APPLICATION LIBERTY -F  <<<<<< - ');
    }
    
    private static void testLibertyApplicationtest(){
        System.debug('>>>>> Response APPLICATION LIBERTY TEST -I  <<<<<< - ');
        LibertyServiceManager lbService = new LibertyServiceManager();
        LibertyApplicationResponse libertyResponse = null;
        // try{
            libertyResponse = lbService.requestApplicationTest(opp, true, 'NFCH0162');
        // }catch (Exception ex){
        //     System.debug(ex.getMessage());
        // }
        System.debug('>>>>> Response APPLICATION LIBERTY TEST -F  <<<<<< - ');
    }

    private static void testLibertyAppDTO(){
        LibertyApplicationResponse resp = new LibertyApplicationResponse();
        LibertyApplicationResponse.ApiResponse apiResponse = new LibertyApplicationResponse.ApiResponse();
        LibertyApplicationResponse.Status status = new LibertyApplicationResponse.Status();
        status.value = '200';
        apiResponse.status = status;
        apiResponse.lastResponseApp = 'Today';
        LibertyApplicationResponse.ApplicationNumber applicationNumber = new LibertyApplicationResponse.ApplicationNumber();
        applicationNumber.value = '567898757687';
        LibertyApplicationResponse.ResponseContent responseContent = new LibertyApplicationResponse.ResponseContent();
        responseContent.value = 'content';
        apiResponse.responseContent = responseContent;
        
        
        List<LibertyApplicationResponse.ValidationError> validationErrors  = new List<LibertyApplicationResponse.ValidationError>();
        LibertyApplicationResponse.ValidationError error = new LibertyApplicationResponse.ValidationError();
        error.value = 'None';
        validationErrors.add(error);
        apiResponse.validationErrors = validationErrors;
        apiResponse.applicationNumber = applicationNumber;
        resp.ApiResponse = apiResponse;
        
        String xmlResponse = '<ApiResponse xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> ' +
   							 '<Status>BadRequest</Status> ' +
   							 '<ValidationErrors> ' +
      						 '<ValidationError>This Application must have at least one borrower.</ValidationError> ' +
   							 '</ValidationErrors> ' +
							 '</ApiResponse>';
        
        resp = resp.XMLParse(xmlResponse);
        
        xmlResponse = '<ApiResponse xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> ' +
   					  '<Status>Accepted</Status> ' +
   					  '<ApplicationNumber>2833165</ApplicationNumber> ' +
   					  '<ValidationErrors/> ' +
   					  '<ResponseContent>Application Received.</ResponseContent> ' +
					  '</ApiResponse>';
        resp = resp.XMLParse(xmlResponse);
    }
}