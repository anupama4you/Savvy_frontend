public class S3Utils {
  private static final Integer DAY_MINS = 1440;
  public static final String PARAM_ACCESS_KEY = 'AmazonS3AccessKey';
  public static final String PARAM_SECRET_KEY = 'AmazonS3SecretKey';
  public static final String PARAM_BUCKET = 'AmazonS3DefaultBucket';
  public static final String PARAM_APPBUCKET = 'AmazonS3AppDocBucket';
  public static final String PARAM_APPFOLDER = 'AmazonS3AppDocFolder';
  public static final String PARAM_PARTNERBUCKET = 'AmazonS3PartnerBucket';
  public static final String PARAM_PARTNERFOLDER = 'AmazonS3PartnerFolder';

  public static String s3AccessKey;
  public static String s3SecretKey;
  public static String s3DefaultBucket;

  static {
    s3AccessKey = Parameters_Service__c.getInstance(PARAM_ACCESS_KEY) != null
      ? Parameters_Service__c.getInstance(PARAM_ACCESS_KEY).value__c
      : '';
    s3SecretKey = Parameters_Service__c.getInstance(PARAM_SECRET_KEY) != null
      ? Parameters_Service__c.getInstance(PARAM_SECRET_KEY).value__c
      : '';
    s3DefaultBucket = Parameters_Service__c.getInstance(PARAM_BUCKET) != null
      ? Parameters_Service__c.getInstance(PARAM_BUCKET).value__c
      : '';
  }

  public static boolean saveFileOrFail(
    String bucket,
    String objectName,
    String content,
    String fileType
  ) {
    Blob base64Content = EncodingUtil.base64Decode(
      EncodingUtil.urlDecode(content, 'UTF-8')
    );
    return saveFileOrFail(bucket, objectName, base64Content, fileType);
  }

  public static boolean saveFileOrFail(
    String bucket,
    String objectName,
    Blob base64Content,
    String fileType
  ) {
    // Settings & Parameters
    String fileName = cleanUrl(objectName.trim());
    String formattedDateString = Datetime.now()
      .format('EEE, dd MMM yyyy HH:mm:ss z', 'America/Denver');
    String method = 'PUT';
    String endpoint = 'https://' + bucket + '.s3.amazonaws.com/' + fileName;

    System.debug('saveFileOrFail parameters...');
    System.debug('bucket: ' + bucket);
    System.debug('objectName: ' + objectName);
    System.debug('fileName: ' + fileName);
    System.debug('ContentSize: ' + base64Content.size());
    System.debug('fileType: ' + fileType);

    // Prepare request
    HttpRequest req = new HttpRequest();
    req.setMethod(method);
    req.setEndpoint(endpoint);
    req.setHeader('Host', bucket + '.s3.amazonaws.com');
    req.setHeader('Access-Control-Allow-Origin', '*');
    req.setHeader('Content-Length', String.valueOf(base64Content.size()));
    req.setHeader('Content-Encoding', 'UTF-8');
    req.setHeader('Connection', 'keep-alive');
    req.setHeader('Content-Type', fileType);
    req.setHeader('Date', formattedDateString);
    req.setHeader(
      'Authorization',
      createAuthHeader(method, bucket, fileName, formattedDateString, fileType)
    );

    req.setBodyAsBlob(base64Content);
    if (!Test.isRunningTest()) {
      Http http = new Http();
      HTTPResponse res = http.send(req);
      System.debug(
        'MYDEBUG: ' +
        objectName +
        ' RESPONSE STRING: ' +
        res.toString()
      );
      if (res.getStatusCode() != 200) {
        throw new GenericException(String.ValueOF(res.getBody()));
      }
    }

    return true;
  }

  public static string createAuthHeader(
    String method,
    String bucket,
    String filename,
    String formattedDateString,
    String fileType
  ) {
    String stringToSign = method + '\n\n';
    if (String.isNotBlank(fileType)) {
      stringToSign += fileType + '\n';
    }
    stringToSign += formattedDateString + '\n/' + bucket + '/' + filename;
    String key = String.isNotBlank(s3SecretKey)? s3SecretKey : '12345';
    Blob mac = Crypto.generateMac(
      'HMACSHA1',
      blob.valueof(stringToSign),
      blob.valueof(key)
    );
    return 'AWS' + ' ' + s3AccessKey + ':' + EncodingUtil.base64Encode(mac);
  }

  public static String getSignedURL(Id cloudDocId) {
    if (cloudDocId != null) {
      List<Cloud_Documents__c> rec = [
        SELECT Bucket_Name__c, Folder_Id__c
        FROM Cloud_Documents__c
        WHERE Id = :cloudDocId
      ];
      if (!rec.isEmpty()) {
        Cloud_Documents__c cd = rec.get(0);
        return S3Utils.getSignedURL(cd.Bucket_Name__c, cd.Folder_Id__c);
      }
    }
    return null;
  }

  public static String getSignedURL(String bucketName, String objectName) {
    return getSignedURL(bucketName, objectName, 10);
  }

  public static String getSignedURL(
    String bucketName,
    String objectName,
    Integer mins
  ) {
    String r = null;
    if (String.isNotBlank(bucketName) && String.isNotBlank(objectName)) {
      String filename = cleanUrl(objectName);
      System.debug('objectName: ' + objectName);
      System.debug('filename  : ' + filename);
      Datetime now = DateTime.now();
      Datetime expireson = now.AddSeconds(60 * mins); // Lifespan of the link
      Long expires = expireson.getTime() / 1000;

      String stringtosign =
        'GET\n\n\n' +
        expires +
        '\n/' +
        bucketName +
        '/' +
        filename;
      String signingKey = EncodingUtil.base64Encode(Blob.valueOf(s3SecretKey));
      Blob mac = Crypto.generateMac(
        'HMacSHA1',
        blob.valueof(stringtosign),
        blob.valueof(s3SecretKey)
      );
      String signed = EncodingUtil.base64Encode(mac);
      String codedsigned = EncodingUtil.urlEncode(signed, 'UTF-8');
      r =
        'https://' +
        bucketName +
        '.s3.amazonaws.com/' +
        filename +
        '?AWSAccessKeyId=' +
        s3AccessKey +
        '&Expires=' +
        expires +
        '&Signature=' +
        codedsigned;
    }
    return r;
  }

  public static void deleteFile(Cloud_Documents__c doc) {
    if (doc != null) {
      deleteS3File(doc.Bucket_Name__c, doc.Folder_Id__c);
    }
  }

  @future(callout=true)
  public static void deleteS3File(String bucket, String objectName) {
    try {
      S3.AmazonS3 as3 = new S3.AmazonS3(s3AccessKey, s3SecretKey);
      Datetime now = Datetime.now();
      S3.Status res = as3.DeleteObject(
        bucket,
        objectName,
        as3.key,
        now,
        as3.signature('DeleteObject', now),
        as3.secret
      );
    } catch (System.CalloutException callout) {
      System.debug('CALLOUT EXCEPTION: ' + callout);
      // ApexPages.addMessages(callout);
    } catch (Exception ex) {
      System.debug(ex);
      // ApexPages.addMessages(ex);
    }
  }

  @InvocableMethod(
    label='Delete a document from amazon S3'
    description='Method to connect and delete a cloud document in amazon S3'
  )
  public static void deleteCloudDocument(List<Cloud_Documents__c> docs) {
    // System.debug('Deleteling from Amazon S3...');
    if (docs != null) {
      for (Cloud_Documents__c d : docs) {
        // System.debug('Amazon doc: ' + d.Bucket_Name__c + '/' + d.Folder_Id__c);
        deleteS3File(d.Bucket_Name__c, d.Folder_Id__c);
      }
    }
    // System.debug('Process completed!');
  }

  public static String cleanFileName(String fileName) {
    if (String.isNotBlank(fileName)) {
      String r = fileName.replace('\'', ' ');
      r = r.replace('`', ' ');
      r = r.replace('´', ' ');
      r = r.replace('’', ' ');
      r = r.replace('~', ' ');
      r = r.replace('%', '');
      r = r.replace('$', '');
      r = r.replace('<', '');
      r = r.replace('>', '');
      r = r.replace(':', '');
      r = r.replace('*', '');
      r = r.replace('?', '');
      r = r.replace('|', '');
      r = r.replace('+', '_');
      r = r.replace(' ', '_'); // Non-breaking space, UTF-8: %C2%A0
      return r;
      // return r.replaceAll('[\\\\:*?\"<>|\'%~$#]`’', '');
    }
    return null;
  }

  public static String cleanUrl(String url) {
    String r = url;
    if (String.isNotBlank(url)) {
      r = EncodingUtil.urlEncode(url, 'UTF-8');
      r = r.replace('%2F', '/');
      // r = r.replace('#', '%23');
      // r = r.replace('+', '%2B');
      // r = r.replace(' ','%20');
    }
    return r;
  }

  public static String renameS3Filename(
    String fileName,
    Boolean addMillisecs,
    Integer maxLength
  ) {
    String r = String.isNotBlank(fileName) ? fileName.trim() : null;
    if (String.isNotBlank(r)) {
      if (!addMillisecs && r.length() <= maxLength) {
        return r;
      }

      String ext = extractFileExtension(r);
      String sufix = '';
      if (addMillisecs) {
        sufix = '-' + String.valueOf(Datetime.now().getTime());
      }

      Integer endFileSize = sufix.length() + ext.length();
      String newName = '';
      if ((r.length() + sufix.length()) > maxLength) {
        // Adjust file name
        newName = r.mid(0, maxLength - endFileSize);
      } else {
        newName = r.mid(0, (r.length() - ext.length()));
      }
      r = newName + sufix + ext;
    }
    return r;
  }

  public static String extractFileExtension(String fileName) {
    String r = String.isNotBlank(fileName) ? fileName.trim() : '';
    if (String.isNotBlank(r)) {
      String[] d = r.split('\\.');
      if (d.size() > 1) {
        r = '.' + d.get(d.size() - 1);
      } else {
        r = '';
      }
    }
    return r;
  }

  public static String getContentType(String file) {
    String r = null;
    String ext = null;
    if(file != null){
      String[] e = file.split('\\.');
      ext = e.get(e.size()-1);
    }
    if (ext != null) {
      if ('pdf'.equalsIgnoreCase(ext)) {
        r = 'application/pdf';
      }
      if (
        'doc'.equalsIgnoreCase(ext) ||
        'dot'.equalsIgnoreCase(ext)
      ) {
        r = 'application/msword';
      }
      if ('docx'.equalsIgnoreCase(ext)) {
        r = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      }
      if ('png'.equalsIgnoreCase(ext)) {
        r = 'image/png';
      }
      if ('gif'.equalsIgnoreCase(ext)) {
        r = 'image/gif';
      }
      if (
        'jpeg'.equalsIgnoreCase(ext) ||
        'jpg'.equalsIgnoreCase(ext)
      ) {
        r = 'image/jpeg';
      }
      if ('pjpeg'.equalsIgnoreCase(ext)) {
        r = 'image/pjpeg';
      }
    }
    return r;
  }
}