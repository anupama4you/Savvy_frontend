@isTest(SeeAllData=true)
public class TestViewCloudDocumentController {
  
  @isTest
  static void testPreviewLink() {
    Cloud_Documents__c c = buildCloudDocuments();
    PageReference pageRef = Page.ViewCloudDocument;
    Test.setCurrentPageReference(pageRef);

    Test.startTest();
    // Testing no paramters
    ViewCloudDocumentController ctr = new ViewCloudDocumentController();
    ctr.init();

    // pssing Id paramter
    ApexPages.currentPage().getParameters().put('id',c.Id);
    ctr = new ViewCloudDocumentController();
    ctr.init();

    Test.stopTest();
  }

  private static Cloud_Documents__c buildCloudDocuments() {
    Test_DataGeneratorHelper.createOpportunity(); 
    Cloud_Documents__c c = new Cloud_Documents__c();
    c.Name = 'Doc name';
    c.Bucket_Name__c = 'my-bucket';
    c.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
    c.Access_Level__c = 'private';
    c.File_Name__c = 'fileName';
    c.Folder_Id__c = 'my-directory/my-file.pdf';
    insert c;
    return c;
  }
}