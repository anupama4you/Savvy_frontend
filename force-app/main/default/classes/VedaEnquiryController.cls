public without sharing class VedaEnquiryController {
    private static final String XML_SCORE_APPLY_XSD = 'http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd';
    public static final String PARAM_SERVICE_ENDPOINT = 'Equifax_Service_Endpoint';
    public static final String PARAM_REPORT_ENDPOINT = 'Equifax_Report_Endpoint';
    public static final String PARAM_USERNAME = 'Equifax_Username';
    public static final String PARAM_PASSWORD = 'Equifax_Password';
    public static final String PARAM_DEFAULT_LIMIT = 'Equifax_Default_Limit';
    public static final String PARAM_SECOND_LIMIT = 'Equifax_Second_Limit';


    private static final Integer TIMEOUT_REQUEST = 60000;
    
    @testVisible
    private static String servEndpointVal;
    @testVisible
    private static String repEndpointVal;
    @testVisible
    private static String usernameVal;
    @testVisible
    private static String passwordVal;
    @testVisible
    private static String defaulLimittVal;
    @testVisible
    private static String secondLimitVal;
    @AuraEnabled 
    public static VedaEnquiryWrapper fetchInitialData(Id recordId, Map<String,String> pageQueryParamMap){
        try{
            VedaEnquiryWrapper vedalWrapper = new  VedaEnquiryWrapper();
            VedaEnquiryController.formVedalWrapper(vedalWrapper,recordId,pageQueryParamMap );
            return vedalWrapper;    
        }catch(Exception excp){
            throw new CustomException(excp.getMessage());
        }

    }

    @AuraEnabled 
    public static VedaEnquiryWrapper submitEnquiry(VedaEnquiryWrapper vedalWrapper){
        try{
            vedalWrapper.warningList = new List<String>();
            vedalWrapper.errorList = new List<String>();
            vedalWrapper.infoList = new List<String>();
            vedalWrapper.sfReq1 = null;
            vedalWrapper.eqRes1 = null;
            vedalWrapper.sfReq2 = null;
            vedalWrapper.eqRes2 = null;
            if (vedalWrapper.enquiryAmt == null || vedalWrapper.enquiryAmt == 0) {
                vedalWrapper.enquiryAmt = 0;
            }
             if (!isValidationOK(vedalWrapper)) {
                    return vedalWrapper;
            }
            processRequest(vedalWrapper);
            return vedalWrapper;

        }catch(Exception excp){
            throw new CustomException(excp.getMessage());
        }
    }

    @testVisible
    private static Boolean isValidationOK(VedaEnquiryWrapper vedalWrapper){
        vedalWrapper.warningList = new List<String>();
        vedalWrapper.errorList = new List<String>();
        Boolean r = true;
        try{
            servEndpointVal = APIServiceManager.getParameterService(PARAM_SERVICE_ENDPOINT);
            repEndpointVal = APIServiceManager.getParameterService(PARAM_REPORT_ENDPOINT);
            usernameVal = APIServiceManager.getParameterService(PARAM_USERNAME);
            passwordVal = APIServiceManager.getParameterService(PARAM_PASSWORD);
        }catch(Exception excp){
            System.debug('Unable to initiate API Settings');

        }
        if (String.isBlank(servEndpointVal) || String.isBlank(repEndpointVal) || String.isBlank(usernameVal) || String.isBlank(passwordVal)) {
                vedalWrapper.errorList.add('API Settings not found for Equifax');   
                r = false;
        }
        if (!hasESignLiveCompleted(vedalWrapper.oppty, vedalWrapper)) {
            // vedalWrapper.warningList.add(
            //     'There is not any completed E-Consent in the Opportunity Transaction section, please be sure that all applicants have signed a consent before proceeding with a credit file assessment.'
            //     );
            if (!hasDocsUploaded(vedalWrapper.oppty, vedalWrapper)) {
                    vedalWrapper.errorList.add(
                        'Privacy consent not completed. Enquiry cannot proceed.'
                    );
                    r = false;
            }
        }else {
                r = validateVedaWrapper(vedalWrapper);
                   
            }
            return r;
        }
    
    @AuraEnabled
    public static void  vedaClick(VedaEnquiryWrapper vedalWrapper) {
        Decimal prue = 0;
        if (isValidationOK(vedalWrapper)) {
            if (vedalWrapper.isProcessOK) {
                List<Opportunity_veda__c> ovLst = [ SELECT Idopvd__c, clicks__c FROM Opportunity_veda__c WHERE Idopvd__c = :UserInfo.getUserId()];
                if (ovLst.isEmpty()) {
                Opportunity_veda__c regg = new Opportunity_veda__c();
                regg.Idopvd__c = UserInfo.getUserId();
                regg.clicks__c = 1;
                regg.Name = vedalWrapper.oppty.Application__c;
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
        List<LenderAPIResponse__c> d = new List<LenderAPIResponse__c>();
        if (String.isNotBlank(vedalWrapper.sfReq1)) {
        d.add(buildAPIResponse(1, vedalWrapper.sfReq1, vedalWrapper.eqRes1, vedalWrapper));
        }
        if (String.isNotBlank(vedalWrapper.sfReq2)) {
        d.add(buildAPIResponse(2, vedalWrapper.sfReq2, vedalWrapper.eqRes2, vedalWrapper));
        }
        if (!d.isEmpty()) {
        insert d;
        }
  }
  @testVisible
  private static LenderAPIResponse__c buildAPIResponse(Integer reqNum, String req, String res, VedaEnquiryWrapper vedalWrapper) {
        LenderAPIResponse__c lar = new LenderAPIResponse__c();
        lar.Name = 'Equifax (req#'+reqNum+') ' + vedalWrapper.oppty.Name;
        lar.Provider__c = 'Equifax';
        if (lar.Name.length() > 80) {
            lar.Name = lar.Name.substring(0, 80);
        }
        lar.Opportunity__c = vedalWrapper.parentId;
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

    @testVisible 
    private static void formVedalWrapper(VedaEnquiryWrapper vedalWrapper, Id recordId, Map<String,String> pageQueryParamMap){
        List<String> warningList = new List<String>();
        List<String> errorList = new List<String>();
        vedalWrapper.parentId = recordId;
        vedalWrapper.oppty = [SELECT Name, Application__c, Application__r.No_of_People__c, Application__r.Email_Address_2__c, Application__r.Email_Address__c, Email_Address__c FROM Custom_Opportunity__c WHERE Id = :recordId];
        // String uname = UserInfo.getName();
        // vedalWrapper.clientRef = uname.length() > 15 ? uname.substring(0, 15) : uname;
        vedalWrapper.clientRef = String.valueOf(vedalWrapper.parentId).substring(0, 15);
        vedalWrapper.enquiryCR = String.valueOf(vedalWrapper.parentId).substring(0, 15);
        if(vedalWrapper.oppty.Application__c == null){
            warningList.add('No Related Application specified for this Opportunity.');
        }else{
            Application__c appl = [ SELECT Id, Title_1__c, First_Name__c, Middle_Name__c, Last_Name__c,Drivers_License_1__c, Date_of_Birth_1__c, Current_Employer_Name_1__c, Gender_1__c, Unit_Number__c, Unit_Number_2__c, Street_Address__c, Street_Address_2__c, Street_Number__c,
                                    Street_Number_2__c, Street_Type__c,Street_Type_2__c, Suburb__c,Suburb_2__c,State__c,State_2__c,Postcode__c,Postcode_2__c,Country__c,Country_2__c,Finance_Amount__c FROM Application__c WHERE Id =: vedalWrapper.oppty.Application__c ];
            if (String.isNotBlank(appl.Title_1__c)) {
                vedalWrapper.titleStr = appl.Title_1__c.toUpperCase();
            }
            vedalWrapper.fname = cleanValue(appl.First_Name__c);
            vedalWrapper.lname = cleanValue(appl.Last_Name__c);
            vedalWrapper.oname = cleanValue(appl.Middle_Name__c);
            vedalWrapper.cUnitNum = cleanValue(appl.Unit_Number__c);
            vedalWrapper.dLicense = cleanValue(appl.Drivers_License_1__c);
            vedalWrapper.cStreetNum = cleanValue(appl.Street_Number__c);
            vedalWrapper.cStreetType = cleanValue(appl.Street_Type__c);
            vedalWrapper.cSuburb = cleanValue(appl.Suburb__c);
            vedalWrapper.cState = cleanValue(appl.State__c);
            vedalWrapper.cPostCode = cleanValue(appl.Postcode__c);
            vedalWrapper.cStreetName = cleanValue(appl.Street_Address__c);
            vedalWrapper.cCountryCode = cleanValue(appl.Country__c);
            vedalWrapper.pUnitNum = cleanValue(appl.Unit_Number_2__c);
            vedalWrapper.pStreetNum = cleanValue(appl.Street_Number_2__c);
            vedalWrapper.pStreetName = cleanValue(appl.Street_Address_2__c);
            vedalWrapper.pStreetType = cleanValue(appl.Street_Type_2__c);
            vedalWrapper.pSuburb = cleanValue(appl.Suburb_2__c);
            vedalWrapper.pState = cleanValue(appl.State_2__c);
            vedalWrapper.pPostCode = cleanValue(appl.Postcode_2__c);
            vedalWrapper.pCountryCode = cleanValue(appl.Country_2__c);
            vedalWrapper.enquiryAmt = appl.Finance_Amount__c;
            if (String.isNotBlank(appl.Date_of_Birth_1__c)) {
                List<String> dateStr = appl.Date_of_Birth_1__c.split('/');
                try {
                    vedalWrapper.dateOfBirth = Date.valueOf(
                        dateStr.get(2) +
                        '-' +
                        dateStr.get(1) +
                        '-' +
                        dateStr.get(0)
                    );
                } catch (Exception e) {
                    errorList.add('D.O.B. has an invalid format in Application Form "' + 
                        appl.Date_of_Birth_1__c + '", please use "dd/mm/yyyy format"');
                }
            }
            vedalWrapper.cEmployer = cleanValue(appl.Current_Employer_Name_1__c);
            vedalWrapper.genderCode = appl.Gender_1__c;
            try{
                VedaEnquiryController.defaulLimittVal = APIServiceManager.getParameterService(VedaEnquiryController.PARAM_DEFAULT_LIMIT);
                VedaEnquiryController.secondLimitVal = APIServiceManager.getParameterService(VedaEnquiryController.PARAM_SECOND_LIMIT);
            }catch(Exception excp){
                errorList.add(excp.getMessage());
            }
            try {
                vedalWrapper.vedaLimit = Integer.valueOf(defaulLimittVal);
                if (SOQLSingletonQueries.isSalesConsultant3()) {
                vedalWrapper.vedaLimit = Integer.valueOf(secondLimitVal);
                }
            }catch (Exception e) {
                 errorList.add('Maximum number of enquires could not be loaded. (' + e.getMessage() + ')');
        
            }
             try {
                vedalWrapper.vedaLimit = Integer.valueOf(defaulLimittVal);
                if (SOQLSingletonQueries.isSalesConsultant3()) {
                    vedalWrapper.vedaLimit = Integer.valueOf(secondLimitVal);
                }
            } catch (Exception e) {
                errorList.add('Maximum number of enquires could not be loaded. (' + e.getMessage() + ')');
            }
        }
        list<Opportunity_veda__c> kk = [ SELECT Idopvd__c, clicks__c FROM Opportunity_veda__c WHERE Idopvd__c = :UserInfo.getUserId()];
        if (!kk.isEmpty()) {
            vedalWrapper.currentTally = Integer.valueOf(kk[0].clicks__c);
        } else {
            vedalWrapper.currentTally = 0;
        }
        if (String.isBlank(vedalWrapper.pCountryCode)) {
            vedalWrapper.pCountryCode = 'AUS';
        }
        if (String.isBlank(vedalWrapper.cCountryCode)) {
            vedalWrapper.cCountryCode = 'AUS';
        }
    //-

        String dsiParam = pageQueryParamMap.get('display-service-info');
        vedalWrapper.displayServiceInfo = false;
        if (String.isNotBlank(dsiParam)) {
        vedalWrapper.displayServiceInfo = true;
        }
        vedalWrapper.warningList = warningList;
        vedalWrapper.errorList = errorList;
        validateVedaForm(vedalWrapper.oppty, vedalWrapper);


    }
    @testVisible 
    private static void validateVedaForm(Custom_Opportunity__c oppty, VedaEnquiryWrapper vedalWrapper){
        if (!hasESignLiveCompleted(oppty, vedalWrapper)) {
            // vedalWrapper.warningList.add(
            // 'There is not any completed E-Consent in the Opportunity Transaction section, please be sure that all applicants have signed a consent before proceeding with a credit file assessment.'
            // );
      
            if (!hasDocsUploaded(oppty, vedalWrapper)) {
                vedalWrapper.errorList.add('Privacy consent not completed. Enquiry cannot proceed.');  
            }
        }
    }

     @testVisible
     private static Boolean hasESignLiveCompleted(Custom_Opportunity__c oppty, VedaEnquiryWrapper vedalWrapper) {
    Integer numPeople = 1;
    if (oppty.Application__r.No_of_People__c != null) {
      numPeople = oppty.Application__r.No_of_People__c.intValue();
    }

    // E-SignLive adds an extra recipient by default.
    numPeople = numPeople + 1;
    /*List<ESL__Package__c> eslPackage = [Select Id
From ESL__Package__c 
Where eSignLive_Opportunity_Lookup__c = :oppty.Id
And ESL__Total_Number_Of_Signers__c = :numPeople
And ESL__Status__c = 'Completed'
];
if(!eslPackage.isEmpty()){
return true;
}else{
if(oppty.Application__r.No_of_People__c.intValue() == 2){*/
    Set<Id> eslPackIds = new Set<Id>();
    Boolean isApplic1Ok = false;
    Boolean isApplic2Ok = false;
    List<ESL__Package__c> eslPacks = null;
    eslPacks = [
      SELECT Id
      FROM ESL__Package__c
      WHERE
        eSignLive_Opportunity_Lookup__c = :oppty.Id
        //And ESL__Total_Number_Of_Signers__c >= :numPeople
        AND ESL__Status__c = 'Completed'
    ];
    /*
        if(eslPacks.isEmpty()){
            if(oppty.Application__r.No_of_People__c.intValue() == 2){
                eslPacks = [Select Id From ESL__Package__c 
                            Where eSignLive_Opportunity_Lookup__c = :oppty.Id 
                            And ESL__Total_Number_Of_Signers__c = 2 
                            And ESL__Status__c = 'Completed'];	
            }
        }*/
    if (!eslPacks.isEmpty()) {
      for (ESL__Package__c x : eslPacks) {
        eslPackIds.add(x.Id);
      }
      List<ESL__Package_Signer__c> elsPackSigns = [SELECT Id, ESL__Email__c FROM ESL__Package_Signer__c WHERE ESL__Package__c IN :eslPackIds];
      if (!elsPackSigns.isEmpty()) {
        for (ESL__Package_Signer__c y : elsPackSigns) {
          if (
            oppty.Application__r.Email_Address__c.equals(y.ESL__Email__c) ||
            oppty.Email_Address__c.equals(y.ESL__Email__c)
          ) {
            isApplic1Ok = true;
          }
          if (oppty.Application__r.No_of_People__c.intValue() == 2) {
            if (
              oppty.Application__r.Email_Address_2__c.equals(y.ESL__Email__c)
            ) {
              isApplic2Ok = true;
            }
          }
        }
        if (oppty.Application__r.No_of_People__c.intValue() == 2) {
          if (isApplic1Ok && isApplic2Ok) {
            return true;
          }
          if (!isApplic2Ok) {
            vedalWrapper.warningList.add('The 2nd  applicant\'n email [' +oppty.Application__r.Email_Address_2__c +'] couldn\'t be found in any e-consent transaction.');
            
          }
        } else {
          if (isApplic1Ok) {
            return true;
          }
        }
        if (!isApplic1Ok) {
          vedalWrapper.warningList.add('The 1st applicant\'n email [' +oppty.Application__r.Email_Address__c +'] couldn\'t be found in any e-consent transaction.');
       
        }
      }
    }
    /*}
     }*/
    return false;
  }

@testVisible
  private static Boolean hasDocsUploaded(Custom_Opportunity__c oppty, VedaEnquiryWrapper vedalWrapper) {
      return hasSavvyConsentUploaded(oppty, vedalWrapper);
  }
  @testVisible
  private static Boolean hasSavvyConsentUploaded(Custom_Opportunity__c opp, VedaEnquiryWrapper vedalWrapper){
        List<Cloud_Documents__c> savvyConsentDocs = [
            Select Id From Cloud_Documents__c 
            Where Custom_Opportunity__c = :opp.id 
            And Document_Type__c like '%Consent%'];
        
        if(!savvyConsentDocs.isEmpty()){
            if(savvyConsentDocs.size() < opp.Application__r.No_of_People__c){
            	vedalWrapper.warningList.add('There are two applicants in this deal, but there is only one Consent in Cloud Documents section. Please be sure that all applicants have signed a consent before proceeding with a credit file assessment.');    
            }
            return true;
        }
        return false;
    }

    @testVisible
    private static Boolean validateVedaWrapper(VedaEnquiryWrapper vedalWrapper){
        Boolean r = true;
         if (vedalWrapper.currentTally >= vedalWrapper.vedaLimit) {
                            vedalWrapper.errorList.add(
                                'The User only can update ' +
                                vedalWrapper.vedaLimit +
                                ' times Enquiries'
                            );                        
                            r = false;
                    }else {
                        if (vedalWrapper.dateOfBirth == null) {
                                vedalWrapper.errorList.add(
                                    'Please specify Date of Birth.'
                                    );     
                                r = false;
                        }
                        if (vedalWrapper.dLicense.length() > 9) {
                            vedalWrapper.errorList.add(
                                'Driver\'s License number should not be more than 10 characters.'
                                );
                            //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'buu '+ UserInfo.getUserId()));
                            r = false;
                        }
                        if (vedalWrapper.cStreetNum == null || vedalWrapper.cStreetNum == '') {
                            vedalWrapper.errorList.add(
                                'Please specify Current Address Street Number.'
                                );
                            
                            r = false;
                        }
                        if (vedalWrapper.cStreetName == null || vedalWrapper.cStreetName == '') {
                            vedalWrapper.errorList.add(
                                'Please specify Current Address Street Name.'
                                );
                            r = false;
                        }
                        if (vedalWrapper.cStreetType == null || vedalWrapper.cStreetType == '') {
                            vedalWrapper.errorList.add(
                                'Please specify Current Address Street Type.'
                                );
                            
                            r = false;
                        }
                        if (vedalWrapper.cState == null || vedalWrapper.cState == '') {
                            vedalWrapper.errorList.add(
                                'Please specify Current Address State.'
                                );
                            r = false;
                        }
                    }
        return r;
    }
    @testVisible
    private static String formPreviousAddressXML(VedaEnquiryWrapper vedalWrapper){
        String previousAddress = 
        '<vsa:address type="P">' +
                '<vsa:unit-number>' +
                vedalWrapper.pUnitNum +
                '</vsa:unit-number>' +
                '<vsa:street-number>' +
                vedalWrapper.pStreetNum +
                '</vsa:street-number>' +
                '<vsa:street-name>' +
                vedalWrapper.pStreetName +
                '</vsa:street-name>' +
                '<vsa:street-type>' +
                vedalWrapper.pStreetType +
                '</vsa:street-type>' +
                '<vsa:suburb>' +
                vedalWrapper.pSuburb +
                '</vsa:suburb>' +
                '<vsa:state>' +
                vedalWrapper.pState +
                '</vsa:state>' +
                '<vsa:postcode>' +
                vedalWrapper.pPostCode +
                '</vsa:postcode>' +
                '<vsa:country-code>' +
                vedalWrapper.pCountryCode +
                '</vsa:country-code></vsa:address>';
        return previousAddress;
    }

    @testVisible 
    private static String formXMLRequest(VedaEnquiryWrapper vedalWrapper, String dobYear, String dobMonth, String dobDay, String previousAddress, String includeOname, Long enquiryAmtLong){
        String xmlRequest = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:vsa="http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd">' +
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
                vedalWrapper.clientRef +
                '</vsa:client-reference>' +
                '<vsa:permission-type-code>' +
                vedalWrapper.selectedPermissionType +
                '</vsa:permission-type-code>' +
                '<vsa:product-data-level-code>' +
                vedalWrapper.selectedProductDataLevel +
                '</vsa:product-data-level-code>' +
                '<vsa:requested-scores><vsa:scorecard-id>VSA_2.0_XY_CR</vsa:scorecard-id>' +
                '<vsa:scorecard-id>VS_1.1_XY_NR</vsa:scorecard-id></vsa:requested-scores>' +
                '</vsa:enquiry-header>' +
                '<vsa:enquiry-data><vsa:individual><vsa:current-name><vsa:title>' +
                vedalWrapper.titleStr +
                '</vsa:title>' +
                '<vsa:family-name>' +
                vedalWrapper.lname +
                '</vsa:family-name>' +
                '<vsa:first-given-name>' +
                vedalWrapper.fname +
                '</vsa:first-given-name>' +
                includeOname +
                '</vsa:current-name><vsa:addresses><vsa:address type="C">' +
                '<vsa:unit-number>' +
                vedalWrapper.cUnitNum +
                '</vsa:unit-number>' +
                '<vsa:street-number>' +
                vedalWrapper.cStreetNum +
                '</vsa:street-number>' +
                '<vsa:street-name>' +
                vedalWrapper.cStreetName +
                '</vsa:street-name>' +
                '<vsa:street-type>' +
                vedalWrapper.cStreetType +
                '</vsa:street-type>' +
                '<vsa:suburb>' +
                vedalWrapper.cSuburb +
                '</vsa:suburb>' +
                '<vsa:state>' +
                vedalWrapper.cState +
                '</vsa:state>' +
                '<vsa:postcode>' +
                vedalWrapper.cPostCode +
                '</vsa:postcode>' +
                '<vsa:country-code>' +
                vedalWrapper.cCountryCode +
                '</vsa:country-code></vsa:address>' +
                previousAddress +
                '</vsa:addresses>' +
                '<vsa:drivers-licence><vsa:number>' +
                vedalWrapper.dLicense +
                '</vsa:number></vsa:drivers-licence>' +
                '<vsa:gender-code>' +
                vedalWrapper.genderCode +
                '</vsa:gender-code>' +
                '<vsa:date-of-birth>' +
                dobYear +
                '-' +
                dobMonth +
                '-' +
                dobDay +
                '</vsa:date-of-birth>' +
                '<vsa:employment><vsa:employer type="C"><vsa:name>' +
                vedalWrapper.cEmployer +
                '</vsa:name></vsa:employer></vsa:employment></vsa:individual>' +
                '<vsa:enquiry><vsa:account-type-code>' +
                vedalWrapper.atCode +
                '</vsa:account-type-code>' +
                '<vsa:enquiry-amount currency-code="' +
                vedalWrapper.currencyCode +
                '">' +
                enquiryAmtLong +
                '</vsa:enquiry-amount>' +
                '<vsa:is-credit-review>' +
                vedalWrapper.isCR +
                '</vsa:is-credit-review>' +
                '<vsa:relationship-code>' +
                vedalWrapper.relationshipCode +
                '</vsa:relationship-code>' +
                '<vsa:enquiry-client-reference>' +
                vedalWrapper.enquiryCR +
                '</vsa:enquiry-client-reference></vsa:enquiry></vsa:enquiry-data></vsa:request></soapenv:Body></soapenv:Envelope>';
            return xmlRequest;
    }
    @testVisible 
    private static void creatAttachment(VedaEnquiryWrapper vedalWrapper, Blob body){
        List<String> infoList = new List<String>();
        Attachment attach = new Attachment();
        attach.ParentId = vedalWrapper.parentId;
        attach.Body = body;
        attach.ContentType = 'application/pdf';
        attach.IsPrivate = false;
        attach.Name = vedalWrapper.fname + ' ' + vedalWrapper.lname + ' - EquifaxScore Apply.pdf';
        insert attach;
        infoList.add('PDF File received.');
        vedalWrapper.infoList = infoList;
        vedalWrapper.eqRes2 = '{message:"binary data received and attachment created ['+attach.Id+']!"}';
        vedalWrapper.isProcessOK = true;   
    }

    @testVisible 
    private static VedaEnquiryWrapper sendRequests(VedaEnquiryWrapper vedalWrapper,String  reqStr){
        HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                req.setEndpoint(servEndpointVal);
                req.setBody(reqStr);
                vedalWrapper.sfReq1 = reqStr;
                System.debug('@@TEST REQUEST:' + reqStr);
                req.setMethod('POST');
                req.setHeader('content-type', 'text/xml');
                // res.setHeader('content-type', 'text/xml');
                req.setTimeout(TIMEOUT_REQUEST);
                res = http.send(req);
                vedalWrapper.eqRes1 =  res.getBody();
                Dom.Document doc = res.getBodyDocument();
                dom.XmlNode xroot = doc.getRootElement();
                try {
                    System.debug('@@TEST RESPONSE:' + res.getBody());
                    doc = res.getBodyDocument();
                    xroot = doc.getRootElement();
                } catch (Exception e) {
                    vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (doc,xroot)');
                    return vedalWrapper;
                }
                dom.XmlNode header = xroot.getChildElement('Header','http://schemas.xmlsoap.org/soap/envelope/');
                if (header == null) {   
                    vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (header)');
                    return vedalWrapper;
                }
                 dom.XmlNode bodyNode = xroot.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                if (bodyNode == null) {
                    vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (bodyNode)');
                    return vedalWrapper;
                }
                dom.XmlNode resp = bodyNode.getChildElement('response',XML_SCORE_APPLY_XSD);
                if (resp == null) {
                    vedalWrapper.errorList.add('Please try again. No response obtained from provider system. (res)');
                    return vedalWrapper;
                }
                dom.XmlNode prodHeader = resp.getChildElement('product-header',XML_SCORE_APPLY_XSD);
                dom.XmlNode enquiryId = prodHeader.getChildElement('enquiry-id',XML_SCORE_APPLY_XSD);
                if (resp.getChildElement('general-messages',XML_SCORE_APPLY_XSD) != null) {
                    dom.XmlNode generalMessages = resp.getChildElement('general-messages',XML_SCORE_APPLY_XSD);

                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, generalMessages.getChildElement('message', XML_SCORE_APPLY_XSD).getText()));
                    vedalWrapper.errorList.add(generalMessages.getChildElement('message',XML_SCORE_APPLY_XSD).getText());
                    return vedalWrapper;
                }

                if ( resp.getChildElement('errors',XML_SCORE_APPLY_XSD) != null) {
                    dom.XmlNode errors = resp.getChildElement('errors',XML_SCORE_APPLY_XSD);
                    dom.XmlNode error = errors.getChildElement('error',XML_SCORE_APPLY_XSD);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, error.getChildElement('detail', XML_SCORE_APPLY_XSD).getText()));
                   vedalWrapper.errorList.add(error.getChildElement('detail',XML_SCORE_APPLY_XSD).getText());
                    return vedalWrapper;
                }
                vedalWrapper.eqRes1 = '{enquiry-id:"'+enquiryId.getText()+'"}';
                sendRequestTwo(vedalWrapper, enquiryId);
                return vedalWrapper;
    }

@testVisible 
    private static VedaEnquiryWrapper sendRequestTwo(VedaEnquiryWrapper vedalWrapper, dom.XmlNode enquiryId ){
        String reqStr2 = Test.isRunningTest()? 'ReqString':'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>' + usernameVal + '</wsse:Username><wsse:Password>' + passwordVal + '</wsse:Password></wsse:UsernameToken></wsse:Security><wsa:Action>http://vedaxml.com/previousEnquiry/ServiceRequest</wsa:Action></soapenv:Header><env:Body xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><prev:request xmlns:prev="http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd"><prev:enquiryId>' + enquiryId.getText() +'</prev:enquiryId><prev:contentType>application/pdf</prev:contentType></prev:request></env:Body></soapenv:Envelope>';
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
                vedalWrapper.sfReq2 = reqStr2;
                res2 = http2.send(req2);
                Dom.Document doc2 = null;
                dom.XmlNode xroot2 = null;
                try {
                vedalWrapper.eqRes2 = res2.getBody();
                System.debug('@@ response report:' + vedalWrapper.eqRes2);
                
                doc2 = res2.getBodyDocument();
                xroot2 = doc2.getRootElement();
                } catch (Exception e) {
                vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (doc,xroot)');
                return vedalWrapper;
                }
                dom.XmlNode bodyNode2 = xroot2.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                if (bodyNode2 == null) {
                vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (bodyNode2)');
                return vedalWrapper;
                }
                dom.XmlNode resp2 = bodyNode2.getChildElement('response','http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd');
                if (resp2 == null) {
                vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (resp2)');
                return vedalWrapper;
                }
                dom.XmlNode binaryData = resp2.getChildElement('binaryData','http://vedaxml.com/vxml2/previous-enquiry-v1-0.xsd');
                if (binaryData == null) {
                vedalWrapper.errorList.add('Please try again. No response obtained from provider system.  (binaryData)');
                return vedalWrapper;
                }

                vedalWrapper.eqRes2 = '{message:"binary data received!"}';
                Blob body;
                // System.debug('@@binaryData.getText():' + binaryData.getText());
                body = EncodingUtil.base64Decode(binaryData.getText());
                creatAttachment(vedalWrapper, body);
                return vedalWrapper;
    }

    @testVisible
    private static void processRequest(VedaEnquiryWrapper vedalWrapper){
        Long enquiryAmtLong = vedalWrapper.enquiryAmt.longValue();
            String includeOname = '';
            if (vedalWrapper.oname != null && vedalWrapper.oname != '') {
                includeOname =
                '<vsa:other-given-name>' +
                vedalWrapper.oname +
                '</vsa:other-given-name>';
            }
            String previousAddress = '';
            if (String.isNotBlank(vedalWrapper.pSuburb)) {
                previousAddress = formPreviousAddressXML(vedalWrapper);
                
            }
            String dobYear = String.valueOf(vedalWrapper.dateOfBirth.year());
            String dobMonth = vedalWrapper.dateOfBirth.month() > 9 ? String.valueOf(vedalWrapper.dateOfBirth.month()): '0' + String.valueOf(vedalWrapper.dateOfBirth.month());
            String dobDay = vedalWrapper.dateOfBirth.day() > 9 ? String.valueOf(vedalWrapper.dateOfBirth.day()) : '0' + String.valueOf(vedalWrapper.dateOfBirth.day());
            String reqStr = formXMLRequest(vedalWrapper, dobYear, dobMonth, dobDay, previousAddress, includeOname, enquiryAmtLong);
            sendRequests(vedalWrapper, reqStr);  
    }
    
  public static String cleanValue(String value) {
    return String.isNotBlank(value)? value : '';
  }

}