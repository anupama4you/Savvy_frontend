@RestResource (urlMapping='/PPSR/certificate/*')
global with sharing class PPSRServiceRestManager extends APIServiceManager{

    public static String TYPE_VIN = 'VIN';
    public static String TYPE_CHASSIS_NUMBER = 'ChassisNumber';
    public static String TYPE_MOTOR_VEHICLE_MANUFACTURERS_NUMBER = 'MotorVehicleManufacturersNumber';
 
    @HttpPost
    global static PPSRRestCertificateResponse sendRecoveredCertificate (String oppId, String searchCertificateNumber, String searchCertificateFileName, String searchCertificateFile, String message){
        saveCertificate (oppId, searchCertificateNumber, searchCertificateFileName, searchCertificateFile, message);
        PPSRRestCertificateResponse response = new PPSRRestCertificateResponse();
        response.statusCode = '0';
        return response;
    }
    
    private static void saveCertificate(String oppId, String searchCertificateNumber, String searchCertificateFileName, String searchCertificateFile, String message){
        String emailAddress = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_Email_Address);
        List<String> addressToSend = emailAddress.split(';');
        Custom_Opportunity__c opp = [Select o.id, o.Application_AssetDetail__r.Search_Certificate_Number__c, o.Name, o.Owner_Name__c, o.Application_AssetDetail__r.PPSR_Proxy_Message__c, o.Owner_Email__c FROM Custom_Opportunity__c as o where id =: oppId];
        Application_Asset_Detail__c aad = opp.Application_AssetDetail__r;
        aad.Search_Certificate_Number__c = searchCertificateNumber;
        aad.PPSR_Proxy_Last_Update__c = System.now();
        aad.PPSR_Proxy_Message__c = message;
        if (!StringUtils.isNullOrEmpty(searchCertificateFile)){
            CloudRequiredDocument d = new CloudRequiredDocument('PPSR Form completed – Private');
            d.blobFile = EncodingUtil.base64Decode(searchCertificateFile);
            d.contentType = 'application/pdf';
            String f = searchCertificateFileName;
            f = f.replace('.pdf', '_' + DateUtils.getTimeForFileName() + '.pdf');
            d.docName = f;
            d.fileName = f;
            d.oppId = oppId;
            CloudDocsHelper.saveToS3(d);
            System.debug('CloudDocument finished');
            EmailSender.sendEmailPPSRNotification(opp, addressToSend);
        }else{
            System.debug('.:::::::::::::: - 1 - Error');
            addressToSend.add('hernan.i@savvy.com.au');
            EmailSender.sendEmailPPSRNotificationError (opp, 'Not retreive certificate.', 'Not exists any certificate for this Opp. Please contact to administrator.<br/>' + aad.PPSR_Proxy_Message__c, addressToSend);
        } 
        update aad;
    }
    
    public static void requestPPSR (Custom_Opportunity__c opp, String serialNumber, String typeSearchSerialNumber){
        if (StringUtils.isNullOrEmpty(serialNumber)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'VIN Number is required.'));
            return;
        }
        Application_Asset_Detail__c aad = opp.Application_AssetDetail__r;
        if (aad == null){
            Custom_Opportunity__c opp1 = [Select o.id, o.Application_AssetDetail__r.Search_Certificate_Number__c, o.Name, o.Owner_Name__c, o.Application_AssetDetail__r.PPSR_Proxy_Message__c, o.Owner_Email__c FROM Custom_Opportunity__c as o where id =: opp.Id];
            aad = opp1.Application_AssetDetail__r;
            if (aad == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Check the Asset Detail before send the request.'));
                return;
            }
        }
        String endPoint = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_ENDPOINT);
        String username = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_USERNAME);
        String password = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_PASSWORD);
        String environment = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_Environment);
        String emailAddress = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_Email_Address);
        String endPointProxy = PPSRServiceManager.getParameterService(PPSRServiceManager.PPSR_SERVICE_PROXY_Endpoint);
        
        ConnectionRESTWs conn;
        PPSRProxyRequest proxyRequest = new PPSRProxyRequest();
        proxyRequest.typeSearchSerialNumber = typeSearchSerialNumber;
        proxyRequest.serialNumber = serialNumber;
        proxyRequest.soapEndpointUrl = endPoint;
        proxyRequest.environment = environment;
        proxyRequest.userName = username;
        proxyRequest.password = password;
        proxyRequest.nonce = EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
        proxyRequest.created = String.valueOf(System.now());
        proxyRequest.emailAddress = emailAddress;
        proxyRequest.oppId = opp.Id;
        
        String body = proxyRequest.serialize(true); 
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Body: [' + body + ']'));
        System.debug('Body: [' + body + ']');
        conn = new ConnectionRESTWs(endPointProxy, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
        
        Map<String, String> requestHeader = new Map<String, String>();
        String message = 'The PPSR Certificate has been requested. No.' + serialNumber;
        HttpResponse resp;
        try{
            resp = conn.connectionServiceHttpResponse(requestHeader, body);
            if (resp != null){
                PPSRProxyResponse proxyResp = parseCreatePPSRCertificateReponse (resp.getBody());
                aad.PPSR_Proxy_Id__c = StringUtils.convertToString(proxyResp.idTransaction);
                aad.PPSR_Proxy_Last_Update__c = System.now();
                aad.PPSR_Proxy_Message__c = message;
                update aad;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                return;
            }else{
                message = 'Error connecting with PPSR proxy.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
            }
        }catch (GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
            message = ex.getMessage();
            System.debug(ex.getMessage());
        }
        List<String> addressToSend = emailAddress.split(';');
        addressToSend.add('hernan.i@savvy.com.au');
        EmailSender.sendEmailPPSRNotificationError (opp, message, body, addressToSend);
        
    }
    
    public static PPSRProxyResponse parseCreatePPSRCertificateReponse (String jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            return (PPSRProxyResponse) parser.readValueAs(PPSRProxyResponse.class);
        }catch (Exception ex){
            String msg = '@Error parse object *parseCreatePPSRCertificateReponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new GenericException(msg, ex);
        }
        
    }

    /**
    private static void sendEmailPPSRNotification(Custom_Opportunity__c opp){
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        toAddresses.add('hernan.i@savvy.com.au');
        EmailTemplate emailTmpl = getEmailTemplate('PPSR_Response_Certificate');
        
        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name );
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.OwnerFullName}',opp.Owner_Name__c )
                 .replace('{!Custom_Opportunity__c.Name}',opp.Name ).replace('{!Custom_Opportunity__c.Id}',opp.Id )
                            .replace('{!MessageName}',opp.Application_AssetDetail__r.PPSR_Proxy_Message__c );
        //Opp Id
        email.setWhatId(opp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        System.debug('The sending email result is: ' + r);
        
    }
    
    private static void sendEmailPPSRNotificationError(Custom_Opportunity__c opp, String messageError, String messageBody){
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        toAddresses.add('hernan.i@savvy.com.au');
        EmailTemplate emailTmpl = getEmailTemplate('PPSR_Error_Proxy_Certificate');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name );
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}',opp.Name ).replace('{!Custom_Opportunity__c.Id}',opp.Id )
                           .replace('{!MessageError}', messageError).replace('{!MessageBody}', messageBody);
        //Opp Id
        email.setWhatId(opp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        System.debug('The sending email result is: ' + r);
    }
    **/

}