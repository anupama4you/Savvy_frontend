@isTest(SeeAllData=true)
public class TestPPSRCertificateRest extends TestAPILenders{

    private static String endPoint = '/services/apexrest/PPSR/certificate/';
    private static String searchCertificateFile = 'uyfakgsdahdjahdklajsdhalsdhalkdhalkjdhakljdas';
    private static String searchCertificateFileName = 'test.pdf';
    private static String searchCertificateNumber = '12345';
    private static String message = '';
    
    public static Custom_Opportunity__c opp;
    
    public static testMethod void testSendCertificate(){
        getStaticResourceMultiMock();
        opp = loadData();
        /**createEmailTemplate('PPSR_Response_Certificate', 
                            '<table border="0" cellpadding="5" width="550" cellspacing="5" height="400" ><tr valign="top" height="400" ><td tEditID="c1r1" style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;" aEditID="c1r1" locked="0" ><![CDATA[<div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Dear&nbsp;<span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">{!Custom_Opportunity__c.OwnerFullName},</span></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;"><br></span></div><div style=""><span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">The PPSR Certificate process for&nbsp;</span><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;">{!Custom_Opportunity__c.Name}&nbsp; has finished.</span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;">Please check the Opportunity</span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><br></span></font></div><div style=""><div><b>Opp Name</b>:&nbsp;<i>{!Custom_Opportunity__c.Name}</i></div><div><b>Opp Id</b>:&nbsp; &nbsp; &nbsp; &nbsp;<i>{!Custom_Opportunity__c.Id}</i></div></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><b><br></b></span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><b>Message</b>: {!MessageName}</span></font></div><div style=""><br></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><br></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">Kind Regards,</p><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;"><b>Approval Team</b></p><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">Phone: {!User.Phone}&nbsp;<font color="red">+&nbsp;</font>Fax: 1300 978 066&nbsp;<font color="red">+</font>&nbsp;Local: 1300 974 066&nbsp;<font color="red">+&nbsp;</font>Mobile: {!User.MobilePhone}<br>Adelaide Office: Level 1, 145 The Parade, Norwood SA 5067<br>Sydney Office: Unit D4, 3-29 Birnie Avenue, Lidcombe, NSW 2141<br>Email:{!User.Email}&nbsp;<font color="red">+&nbsp;</font>Web: www.savvy.com.au</p><img src="http://www.savvy.com.au/sites/default/files/savy_logo.png" alt="Home" style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px; width: 150px;"></div>]]></td></tr></table>', 
                            '{!Custom_Opportunity__c.Name}', 
                            'PPSR Response Certificate',
                            'text');
        createEmailTemplate('PPSR_Error_Proxy_Certificate', 
                            '<table border="0" cellpadding="5" width="550" cellspacing="5" height="400" ><tr valign="top" height="400" ><td tEditID="c1r1" style=" background-color:#FFFFFF; color:#000000; bEditID:r3st1; bLabel:main; font-size:12pt; font-family:arial;" aEditID="c1r1" locked="0" ><![CDATA[<div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Dear&nbsp;<span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">{!Custom_Opportunity__c.OwnerFullName},</span></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;"><br></span></div><div style=""><span style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">The PPSR Certificate process for&nbsp;</span><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;">{!Custom_Opportunity__c.Name}&nbsp; has finished.</span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;">Please check the Opportunity</span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><br></span></font></div><div style=""><div><b>Opp Name</b>:&nbsp;<i>{!Custom_Opportunity__c.Name}</i></div><div><b>Opp Id</b>:&nbsp; &nbsp; &nbsp; &nbsp;<i>{!Custom_Opportunity__c.Id}</i></div></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><b><br></b></span></font></div><div style=""><font color="#232323" face="Calibri, Helvetica, Arial, sans-serif"><span style="font-size: 14px;"><b>Message</b>: {!MessageName}</span></font></div><div style=""><br></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><br></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">Kind Regards,</p><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;"><b>Approval Team</b></p><p style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px;">Phone: {!User.Phone}&nbsp;<font color="red">+&nbsp;</font>Fax: 1300 978 066&nbsp;<font color="red">+</font>&nbsp;Local: 1300 974 066&nbsp;<font color="red">+&nbsp;</font>Mobile: {!User.MobilePhone}<br>Adelaide Office: Level 1, 145 The Parade, Norwood SA 5067<br>Sydney Office: Unit D4, 3-29 Birnie Avenue, Lidcombe, NSW 2141<br>Email:{!User.Email}&nbsp;<font color="red">+&nbsp;</font>Web: www.savvy.com.au</p><img src="http://www.savvy.com.au/sites/default/files/savy_logo.png" alt="Home" style="color: rgb(35, 35, 35); font-family: Calibri, Helvetica, Arial, sans-serif; font-size: 14px; width: 150px;"></div>]]></td></tr></table>', 
                            '{!Custom_Opportunity__c.Name}', 
                            'PPSR Error Proxy Certificate',
                           'text'); **/
        
        String oppId = opp.Id;
        String body = '{"oppId" : "' + oppId +'", "searchCertificateNumber" : " ' + searchCertificateNumber +'", "searchCertificateFileName" : "' + searchCertificateFileName +'", "searchCertificateFile" : " ' + searchCertificateFile + '"}';
        /**
        ConnectionRESTWs conn;
        HttpResponse resp;
        conn = new ConnectionRESTWs(URL.getSalesforceBaseUrl().getHost() + endPoint, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON); 
        Test.startTest();
        try{
            resp = conn.connectionServiceHttpResponse(null, body);
        }catch (GenericException ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
            throw new GenericException (ex.getMessage());
        }**/
        
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().getHost() + endPoint;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        
		PPSRRestCertificateResponse r = PPSRServiceRestManager.sendRecoveredCertificate (oppId, searchCertificateNumber, searchCertificateFileName, searchCertificateFile, message);
        Application_Asset_Detail__c aad = Opp.Application_AssetDetail__r;
        String serialNumber = aad.VIN__c;
        //opp.Owner_Email__c = 'hernan.i@savvy.com.co';
        PPSRServiceRestManager.requestPPSR(opp, serialNumber, PPSRServiceRestManager.TYPE_VIN);
        PPSRServiceRestManager.requestPPSR(opp, null, PPSRServiceRestManager.TYPE_VIN);
        opp.Application_AssetDetail__r = null;
        PPSRServiceRestManager.requestPPSR(opp, serialNumber, PPSRServiceRestManager.TYPE_VIN);
        String json = '{"status": 0,"message": "Transaction started successfully!","idTransaction": 40}';
        PPSRServiceRestManager.parseCreatePPSRCertificateReponse (json);
        json = '{"stat": 0,"messe": "Transaction started successfully!","idTraaction": 40}';
        PPSRServiceRestManager.parseCreatePPSRCertificateReponse (json);
        Test.stopTest();
    }
    
    private static void getStaticResourceMultiMock(){
        Integer responseCode = 200;
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('http://52.63.188.79:8091/savvy/ppsr/certificate', 'PPSR_Proxy_Server_Response');
        multimock.setHeader('Content-Lenght', '254735');
        //multimock.setStatusCode(responseCode);
		//multimock.setHeader(ConnectionRESTWs.CONTENT_TYPE_HEADER , 'application/json; charset=UTF-8');
        //multimock.setHeader('Cache-Control', 'private');
        //multimock.setHeader('Connection', 'Kepp-Alive');
        //multimock.setHeader('#status#', 'HHTP/1.1 500 Internal server');
        //multimock.setHeader('Date', ''+ System.now());
		Test.setMock(HttpCalloutMock.class, multimock);  
    }
}