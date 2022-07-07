@isTest 
public class FileUploadControllerTest {
    static testMethod void FileUploadControllerMethod() {
        Account ac = Test_DataGeneratorHelper.buildAcc();   
        
        PageReference testPage = Page.FileUpload; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(ac);     
        FileUploadController ext = new FileUploadController(sc);         
        
        ext.currentRecordId = ac.Id;
        ext.Document = null;
        ext.Document.Name = 'TestDoc123';
        ext.upload();
        
        List<Account> al = [Select Name from Account where Id = :ac.Id LIMIT 1];
        System.assertEquals(1, al.size());
    }
}