@isTest
public class TestRequiredDocumentEditExtension
{
    public static testMethod void myUnitTest()
    {
        
        Test_DataGeneratorHelper.createOpportunity();
        Required_Document__c rd = new Required_Document__c();
        rd.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
           
        Attachment a = new Attachment();  
        a.Name = 'Test Attachment';          
        a.Body = blob.valueOf('Document for testing');               
        a.ParentId = Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        Attachment b = new Attachment();
        b.name = 'Test Attachment';
        b.body = blob.valueOf('Document for testing');
        b.parentId = Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert b;
  
        RequiredDocumentEditExtension ext = new RequiredDocumentEditExtension(new ApexPages.StandardController(rd));
        ext.getoppAttachmentOptions();       
        ext.strSelectedattachmentValue=a.id;
        ext.SaveOverride();
        ext.strSelectedattachmentValue='';
        ext.SaveOverride(); 
        delete a;
        ext.getoppAttachmentOptions(); 
        
        ext.File=blob.valueOf('Document for testing');
        ext.SaveOverride();
        
    }
}