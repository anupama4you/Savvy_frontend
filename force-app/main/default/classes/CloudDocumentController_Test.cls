@isTest
public class CloudDocumentController_Test {
    
    @isTest Public static void testDocument(){
        Cloud_Documents__c cloudDoc = buildCloudDocuments();
        CloudDocumentController.getRecords(cloudDoc.Custom_Opportunity__c);
        CloudDocumentController.getPicklistValues('Cloud_Documents__c', 'Document_Type__c');
        CloudDocumentController.getYesNoPicklistValues('Cloud_Documents__c', 'SendToLender__c');
        
        CloudDocumentController.signCloudDocument(null);
        
        try{
        	CloudDocumentController.updateRecords( JSON.serialize(cloudDoc)); 
        }Catch(Exception e){} 
        
        CloudDocumentController.deleteCloudDoc ((String)cloudDoc.Id);
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