@isTest
public class CloudDocsHelperTest {
  
  @isTest
  static void t1() {
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    CloudRequiredDocument a = new CloudRequiredDocument('Partner Evidence of Income');
    CloudDocsHelper.saveToS3(a);
    CloudDocsHelper.saveToCloud(a);
    CloudDocsHelper.saveToCloudVD(a);

    String dc = 'Spouse Information';
    CloudDocsHelper.deleteCloudDocument(opp.Id, 'Spouse Information');

    Blob b = Blob.valueOf('Hi!');
    CloudDocsHelper.uploadFile(
      opp.Id,
      dc,
      't1',
      b,
      'application/pdf',
      'pdf',
      false
    );

    CloudDocsHelper.isFileNameUploaded(opp.Id, dc);
    CloudDocsHelper.uploadFileFromUrl(opp.Id, null);
    CloudDocsHelper.uploadFileFromUrl(opp.Id, 'http://www.abc.com');
    String s3Url = 'https://savvy-testing.s3.ap-southeast-2.amazonaws.com/test-app-docs/a/abc.pdf';
    CloudDocsHelper.uploadFileFromUrl(opp.Id, s3Url);
    CloudDocsHelper.uploadFileFromUrl(opp.Id, s3Url, dc);
    CloudDocsHelper.uploadFileFromUrl(opp.Id, s3Url, dc, 'new-file-name');

    CloudDocsHelper.fileDownLoad(opp.Id, s3Url);

    CloudDocsHelper.getSignedURL(s3Url);

    List<String> tmp = new List<String>{
      'Drivers Licence Front',
      'Drivers Licence Front and Back',
      'Drivers Licence Back',
      'Applicant 2 Drivers Licence Front',
      'Applicant 2 Drivers Licence Front and Back',
      'Applicant 2 Drivers Licence Back',
      'Applicant 2 Payslip 1',
      'Applicant 2 Payslip 2',
      'Other Doc type :)'
    };
    for (String x: tmp) {
      CloudDocsHelper.documentTypeSupport(x);
    }
    CloudDocsHelper.documentTypeSupport(null);

    CloudDocsHelper.isS3AmazonUrlLink(s3Url);
    CloudDocsHelper.getUrlBucket(s3Url);

    Cloud_Documents__c cd = new Cloud_Documents__c();
    cd.Bucket_Name__c = 'savvy-testing';
    cd.Folder_Id__c = 'test-app-docs/a/abc.pdf';
    CloudDocsHelper.fileDownLoad(cd);

    CloudDocsHelper.createDocument(
      opp.Id, 'savvy-testing', 'test-app-docs/a/abc.pdf', 'abc.pdf', dc
    );

    Test.stopTest();
  }
}