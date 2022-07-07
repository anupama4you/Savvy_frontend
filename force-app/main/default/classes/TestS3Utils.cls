@isTest
public class TestS3Utils {
    
  @isTest(SeeAllData=true) static void testSaveFileOrFail() {
    Test.startTest();
    S3Utils.saveFileOrFail('bucket', 'objectName', 'content', 'fileType');
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testCreateAuthHeader() {
    Test.startTest();
    S3Utils.createAuthHeader('PUT', 'bucket', 'filename', 'formattedDateString', 'fileType');
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testSignedURL() {
    Cloud_Documents__c doc = buildCloudDocuments();
    Test.startTest();
    Id myId = null;
    S3Utils.getSignedURL(myId);
    S3Utils.getSignedURL(doc.Id);
    S3Utils.getSignedURL('bucketName', 'my objectName');
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testCleanFileName() {
    Test.startTest();
    S3Utils.cleanFileName('MY-FILE-NUMBER');
    S3Utils.cleanFileName(null);
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testRenameS3Filename() {
    Test.startTest();
    S3Utils.renameS3Filename('MY-FILE-NUMBER', true, 20);
    S3Utils.renameS3Filename(null, null, null);
    S3Utils.renameS3Filename('123456789012345678901234567890.txt', true, 20);
    S3Utils.renameS3Filename('123456789012345678901234567890.txt', false, 10);
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testDeleteFile() {
    Cloud_Documents__c doc = buildCloudDocuments();
    Test.startTest();
    S3Utils.deleteFile(doc);
    S3Utils.deleteCloudDocument(new List<Cloud_Documents__c>{ doc });
    Test.stopTest();
  }

  @isTest(SeeAllData=true) static void testContentType() {
    Test.startTest();
    Map<String, String> files = new Map<String, String>();
    files.put('application/pdf','abc.pdf');
    files.put('application/msword','abc.doc');
    files.put('application/msword','abc.dot');
    files.put('application/vnd.openxmlformats-officedocument.wordprocessingml.document','abc.docx');
    files.put('image/png','abc.png');
    files.put('image/gif','abc.gif');
    files.put('image/jpeg','abc.jpg');
    files.put('image/jpeg','abc.jpeg');
    files.put('image/pjpeg','abc.pjpeg');

    for (String k: files.keySet()) {
      System.assert(k.equals(S3Utils.getContentType(files.get(k))), 'wrong content type for ' + files.get(k));
    }
    Test.stopTest();
  }

  private static Cloud_Documents__c buildCloudDocuments() {
    Test_DataGeneratorHelper.createOpportunity(); 
    Cloud_Documents__c c = new Cloud_Documents__c();
    c.Name = 'Doc name';
    c.Bucket_Name__c = 'bucket';
    c.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
    c.Access_Level__c = 'private';
    c.File_Name__c = 'fileName';
    c.Folder_Id__c = 's3FileObject';
    insert c;
    return c;
  }

  public static void createAmazonS3ParametersService() {
    List<Parameters_Service__c> d = new List<Parameters_Service__c>();
    Parameters_Service__c p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_ACCESS_KEY;
    p.value__c = 'KEYXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_SECRET_KEY;
    p.value__c = 'SECRETXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_BUCKET;
    p.value__c = 'BUCKETXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_APPBUCKET;
    p.value__c = 'APPBUCKETXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_APPFOLDER;
    p.value__c = 'APPFOLDERXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_PARTNERBUCKET;
    p.value__c = 'PARTNERBUCKETXXXXXXXX';
    d.add(p);
    p = new Parameters_Service__c();
    p.Name = S3Utils.PARAM_PARTNERFOLDER;
    p.value__c = 'PARTNERFOLDERXXXXXXXX';
    d.add(p);
    insert d;
  }

}