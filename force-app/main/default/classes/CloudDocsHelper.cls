public class CloudDocsHelper {
  
    private static String bucketname = 'bucketname';
    private static String key = 'key';
    private static String secret = 'secret';
    private static String region = '';
    private static String method = 'PUT';
    public static String savvyBucketName = 'bucketname';           //Lelo      2017-10-10          //Lelo      2017-10-19

    static {
      key = S3Utils.s3AccessKey;
      secret = S3Utils.s3SecretKey;
      bucketname = S3Utils.s3DefaultBucket;
      Parameters_Service__c p = Parameters_Service__c.getInstance(S3Utils.PARAM_APPBUCKET);
      savvyBucketName = p != null? p.value__c : savvyBucketName;
    }
    
    public static void saveToS3(CloudRequiredDocument doc){
      saveToS3(
          doc.blobFile,
            doc.docName,
            doc.fileName,
            doc.contentType,
            doc.oppId,
            doc.documentType,
            doc.accessLevel,
            doc.isVDType
        );
    }
    
    public static void saveToCloud(CloudRequiredDocument doc){
        saveToCloud(
            doc.blobFile,
            doc.docName,
            doc.fileName,
            doc.contentType,
            doc.oppId,
            doc.documentType,
            doc.accessLevel,
            doc.isVDType
        );
    }
    
    public static void saveToCloudVD(CloudRequiredDocument doc){
        // saveToCloudVD(
        //     doc.binaryPDF,
        //     doc.docName,
        //     doc.fileName,
        //     doc.contentType,
        //     doc.VDOppId,
        //     doc.documentType,
        //     doc.accessLevel,
        //     doc.isVDType,
        //     doc.VDQuotationDealerId,
        //     doc.VDOppName,
        //     doc.VDQuotationVehicleOfferId
        // );
    }

    //method to use the S3 webservice and save pdf file
    @future(callout=true)
    private static void saveToS3(Blob binaryPDF, String docName, String fileName, String contentType, 
                                 String oppId, String documentType, String accessLevel, Boolean isVDType){
        saveToCloud(binaryPDF, docName, fileName, contentType, oppId, documentType, accessLevel, isVDType);
    }

    private static void saveToCloud(Blob binaryPDF, String docName, String fileName, String contentType, 
                                    String oppId, String documentType, String accessLevel, Boolean isVDType){
      if (binaryPDF != null) {
        String oppName = getOpportunityName(oppId);
        // String fullFileNameUp = 'a0e-custom_opportunity__c/' + EncodingUtil.urlEncode(oppName,'UTF-8') + '-' + oppId + '/' + fileName.replace(' ', '+');
        String fullFileNameUp = 'a0e-custom_opportunity__c/' + S3Utils.cleanFileName(oppName) + '-' + oppId + '/' + S3Utils.cleanFileName(fileName);
        try {
          fullFileNameUp = S3Utils.renameS3Filename(fullFileNameUp, false, 255);
          S3Utils.saveFileOrFail(bucketname, fullFileNameUp, binaryPDF, contentType);
          createDocument(oppId, bucketname, fullFileNameUp, S3Utils.cleanFileName(fileName), documentType, isVDType);
        } catch (Exception e) {
          System.debug('MYDEBUG: AWS Service Callout Exception on ' + fileName);
          System.debug('MYDEBUG: ERROR: ' + e.getMessage());
        }
      } else {
        System.debug('MYDEBUG: ' + fileName + ' no binary data was found it');
      }
    }
    
    
    //create authorization header for Amazon S3 REST API
    // private static string createAuthHeader(String contentType,String filename,String formattedDateString){
    //     string auth;
    //     String stringToSign = CloudDocsHelper.method+'\n\n' + contentType + '\n' + 
    //                           formattedDateString+'\n/'+ CloudDocsHelper.bucketname +'/'+ 
    //                           filename;
    //     Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(CloudDocsHelper.secret));
    //     String sig = EncodingUtil.base64Encode(mac);
    //     auth = 'AWS' + ' ' + CloudDocsHelper.key + ':' + sig;
    //     return auth;
    // }
    
    private static String getOpportunityName(String oppId) {
      String r = '';
      if (String.isNotBlank(oppId)) {
        List<Custom_Opportunity__c> o = [
          Select Name From Custom_Opportunity__c Where Id = :oppId
        ];
        r = !o.isEmpty()? o.get(0).Name : r;
      }
      return r;
    }
    
    public static void deleteCloudDocument(String oppId, String documentType) {
      List<Cloud_Documents__c> docs = 
                  [Select id From Cloud_Documents__c 
                    Where Custom_Opportunity__c = :oppId And Document_Type__c = :documentType];
      if (!docs.isEmpty()) {
          delete docs;
      }
    }
    
    //Lelo      2016-11-15
    public static void uploadFile(String oppId, String docType, String prefixName, Blob body, String contentType, String extensionFile, Boolean isVDType) {
        String fileName = prefixName + '_' + oppId + '_' + getDateTimeExtensionFileName() + '.' + extensionFile;
        CloudRequiredDocument d = new CloudRequiredDocument(docType);
        d.blobFile = body;
        d.contentType = contentType;
        d.docName = fileName;
        d.fileName = fileName;
        d.oppId = oppId;
        d.isVDType = isVDType;
        saveToS3(d);
    }

    private static String getDateTimeExtensionFileName() {
        return Datetime.now().format('yyyyMMddHHmmss');
    }
    //-

    public static Boolean isFileNameUploaded(Id oppId, String fileName) {
        Boolean r = false;
        if (oppId != null && String.isNotBlank(fileName)) {
            List<Cloud_Documents__c> docs = 
                    [Select id From Cloud_Documents__c 
                     Where Custom_Opportunity__c = :oppId And File_Name__c = :fileName];
            r = docs != null && !docs.isEmpty();
        }
        return r;
    }
    
    public static void uploadFileFromUrl(Id objId, String url) {
        uploadFileFromUrl(objId, url, null);
    }
    
    public static void uploadFileFromUrl(Id objId, String url, String docType) {
        uploadFileFromUrl(objId, url, docType, null);
    }

    public static void uploadFileFromUrl(Id objId, String url, String docType, String newFileName) {
        if (objId == null || String.isBlank(url)) {
            System.debug('uploadFileFromUrl >> null params ' + objId + '|' + url);
            return;
        }
        String fileName = newFileName;
        if (String.isBlank(fileName)) {
            fileName = getFileName(url);
        }
        if (isS3AmazonUrlLink(url)) {
            String bckt = getUrlBucket(url);
            createDocument(objId, bckt, getS3FilePath(bckt, url), fileName, documentTypeSupport(docType));
        } else {
          //Validations
          
          HttpRequest req = new HttpRequest();
          req.setEndpoint(url);
          req.setMethod('GET');

          Http http = new Http();
          if (!Test.IsRunningTest()){
            HTTPResponse res = http.send(req);
            //System.debug(res.getBody());
            System.debug('Status >> ' + res.getStatusCode() + ' | ' + res.getStatus());
            System.debug('File Name >> ' + fileName);
            if (res.getStatusCode() == 200) {
                CloudRequiredDocument d = new CloudRequiredDocument(null);
                d.blobFile = res.getBodyAsBlob();
                d.contentType = res.getHeader('Content-Type');
                d.docName = fileName;
                d.fileName = fileName;
                if (docType != null){
                    d.documentType = documentTypeSupport(docType);
                }
                d.oppId = objId;
                saveToS3(d);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, fileName + ' file document has been uploaded.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, fileName + ' document has not been found it.'));
            }
          }
        }

    }

    public static String getFileName(String url) {
        if (url == null) {
            return null;
        }
        Integer pos = url.lastIndexOf('/');
        String name = url.substring(pos+1);
        //return name.replace('+',' ').replace('%20',' ');
        return EncodingUtil.urlDecode(name,'UTF-8');

    }
    
    //Lelo              2017-10-10
    public static String getS3FilePath(String bucket, String url) {
        if (url == null) {
            return null;
        }
        String[] a = url.split('\\/');
        // String baseUrl = bucket + '.s3.amazonaws.com';
        String baseUrl = a[2];
        Integer pos = url.lastIndexOf(baseUrl);
        String filePath = url.substring(pos + baseUrl.length() + 1);
        //return filePath.replace('+',' ').replace('%20',' ');
        return EncodingUtil.urlDecode(filePath,'UTF-8');
    }
    //-
    
    public static Blob fileDownLoad(String oppId, String fileName){
      String contentType= 'application/pdf';
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      String formattedDateString = Datetime.now().format('EEE, dd MMM yyyy HH:mm:ss z','America/Denver');
      req.setHeader('Date', formattedDateString);
      String oppName = getOpportunityName(oppId);
      String fullFileNameUp = 'a0e-custom_opportunity__c/' + EncodingUtil.urlEncode(oppName,'UTF-8') + '-' + oppId + '/' + fileName;
      fullFileNameUp = fullFileNameUp.replace(' ', '+');
      req.setHeader('Authorization',createAuthHeaderDownload(fullFileNameUp ,formattedDateString ));
      Set<String> getParams = new Set<String> {
          'prefix=' + EncodingUtil.urlEncode(filename+'/','UTF-8'),
          'delimiter=' + EncodingUtil.urlEncode('/', 'UTF-8')
      };
      String endpointBase = 'https://' + bucketname + '.s3.amazonaws.com/' + fullFileNameUp;
      req.setEndpoint(endpointBase + '?' + 'prefix=' + EncodingUtil.urlEncode(fullFileNameUp+'/','UTF-8')+'&delimiter=' + EncodingUtil.urlEncode('/', 'UTF-8'));
      String stringToSign = 'GET\n\n\n' +
          contentType + '\n' +
          formattedDateString + '\n' +
          '/' + bucketname + '/' + bucketname + '/' + fullFileNameUp;
  
      Http http = new Http();
      if (!Test.IsRunningTest()){
        HTTPResponse res = http.send(req);
        System.debug(res);
        if (res != null) {
          return res.getBodyAsBlob();
        }
      }
      return null;
    }
    
    //create authorization header for Amazon S3 REST API
    private static string createAuthHeaderDownload(String filename,String formattedDateString){
      return S3Utils.createAuthHeader('GET', CloudDocsHelper.bucketname, filename, formattedDateString, null);
        // string auth;
        // String stringToSign = 'GET'+'\n\n\n'+formattedDateString+'\n/'+ CloudDocsHelper.bucketname +'/'+filename;
        // Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(CloudDocsHelper.secret));
        // String sig = EncodingUtil.base64Encode(mac);
        // auth = 'AWS' + ' ' + CloudDocsHelper.key + ':' + sig;
        // return auth;
    }
    
    //Lelo          2017-10-11
    public static String getSignedURL(String s3Url) {
        String r = s3Url;
        //String filename = EncodingUtil.urlEncode(s3Url.replace('+', ' '), 'UTF-8');
        
        if (String.isNotBlank(s3Url) && s3Url.containsIgnoreCase('amazon')) {

            //String filename = EncodingUtil.urlEncode(getS3FilePath(s3Url), 'UTF-8');
            
            //System.debug('s3Url >> ' + s3Url);
            //System.debug('getS3FilePath(s3Url) >> ' + getS3FilePath(s3Url));
            //System.debug('filename >> ' + filename);
            String bktName = null;
            if (String.isNotBlank(bucketname) && s3Url.containsIgnoreCase(bucketname)) {
                bktName = bucketname;
            } else {
              String[] a = s3Url.split('\\.');
              bktName = a[0].replace('https://', '');
            }
            String filename = getS3FilePath(bktName, s3Url);
            if (String.isNotBlank(bktName)) {

                Datetime now = DateTime.now();
                Datetime expireson = now.AddSeconds(600); // Lifespan of the link
                Long Lexpires = expireson.getTime()/1000;
                
                if (filename.contains(' ')) {
                    filename = filename.replace(' ','%20');
                }

                String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bktName+'/'+filename;
                System.debug('redirectToS3Key stringstosign: ' + stringtosign);
                
                String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
                System.debug('signingKey >> ' + signingKey);
                String sec = Test.isRunningTest()? '12345' : secret;
                Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(sec)); 
                String signed= EncodingUtil.base64Encode(mac);     
                System.debug('signed >> ' + signed);
                String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
                System.debug('codedsigned >> ' + codedsigned);
                r = 'https://'+bktName+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+key+
                                      '&Expires='+Lexpires+'&Signature='+codedsigned;
            }
        }
        return r;        
    }

    public static String documentTypeSupport(String docType){
      if (String.isBlank(docType) || docType.containsIgnoreCase('AllInOne')){
        return null;
      }
      // Applicant 1
      if (
        'Drivers Licence Front'.equals(docType) ||
        'Drivers Licence Front and Back'.equals(docType)
      ) {
        return 'Drivers License - Front';
      } else if ('Drivers Licence Back'.equals(docType)) {
        return 'Drivers License - Back';
      }
      // Applicant 2
      if (
        'Applicant 2 Drivers Licence Front'.equals(docType) ||
        'Applicant 2 Drivers Licence Front and Back'.equals(docType)
      ) {
        return 'Applicant 2 - Drivers License - Front';
      } else if ('Applicant 2 Drivers Licence Back'.equals(docType)) {
        return 'Applicant 2 - Drivers License - Back';
      } else if ('Applicant 2 Payslip 1'.equals(docType)) {
        return 'Applicant 2 - Payslip 1';
      } else if ('Applicant 2 Payslip 2'.equals(docType)) {
        return 'Applicant 2 - Payslip 2';
      }
      return docType;
    }

    public static Boolean isS3AmazonUrlLink(String url) {
        Boolean r = false;
        String bk = getUrlBucket(url);
        if (String.isNotBlank(url) && 
            url.containsIgnoreCase('amazon') && 
            String.isNotBlank(bk) && url.containsIgnoreCase(bk)) {
            r  = true;
        }
        return r;
    }
    
    public static String getUrlBucket(String url) {
      String r = '';
      if (String.isNotBlank(url)) {
        String[] a = url.split('\\/');
        if (a.size() > 3) {
          a = a[2].split('\\.');
          if (a.size() > 1) {
            r = a[0];
          }
        }
      }
      return r;
    }
    
    public static Blob fileDownLoad(Cloud_Documents__c d){
        
      HttpRequest req = new HttpRequest();
      
      req.setMethod('GET');
      // System.debug(CloudDocsHelper.getSignedURL(CloudDocsHelper.getURL(d.Bucket_Name__c, d.Folder_Id__c)));
      req.setEndpoint(CloudDocsHelper.getSignedURL(CloudDocsHelper.getURL(d.Bucket_Name__c, d.Folder_Id__c)));
      
      Http http = new Http();
      HTTPResponse res;
      try{
        if (!Test.IsRunningTest()){
          res = http.send(req);
          if (res != null) {
            return res.getBodyAsBlob();
          }
        }
      }catch(CalloutException e){
        System.debug('CloudDocsHelper.fileDownLoad => ' + e.getMessage());
        if (Apexpages.currentPage() != null) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'File can not be sent due to its size exceeds SF limit ['+d.File_Name__c+'] ('+d.Document_Type__c+')'));  
        }  
      }
      return null;
    }
    
    public static String getURL(String bucketName, String folderId) {
        return 'https://'+bucketName+'.s3.amazonaws.com/'+folderId;
    }


  // Lelo         2021-05-05
  public static Cloud_Documents__c createDocument(Id oppId, String bucket, String s3FileObject, String fileName, String docType) {
    return createDocument(oppId, bucket, s3FileObject, fileName, docType, false);
  }

  public static Cloud_Documents__c createDocument(Id oppId, String bucket, String s3FileObject, String fileName, String docType, Boolean isVD) {
    Cloud_Documents__c c = new Cloud_Documents__c();
    // if (fileName.length() > 80) {
    //     c.Name = fileName.substring(0, 80);
    // } else {
    //     c.Name = fileName;
    // }
    c.Name = S3Utils.renameS3Filename(fileName, false, 80);
    c.Bucket_Name__c = bucket;
    if (isVD) {
      c.VD_Opportunity_Document__c = oppId;
    } else {
      c.Custom_Opportunity__c = oppId;
    }
    if (String.isNotBlank(docType)) {
      c.Document_Type__c = docType;
    }
    c.Access_Level__c = 'private';
    c.File_Name__c = fileName;
    c.Folder_Id__c = s3FileObject;
    insert c;
    return c;
  }
}