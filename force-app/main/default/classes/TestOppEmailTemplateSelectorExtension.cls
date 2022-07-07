@isTest(SeeAllData=true)
public class TestOppEmailTemplateSelectorExtension {
    public static testMethod void myUnitTest(){
        Test_DataGeneratorHelper.createOpportunity();
        
        PageReference pageRef = Page.OppEmailTemplateSelector;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppEmailTemplateSelectorExtension myPageCon = new OppEmailTemplateSelectorExtension(sc);
        
        for (EmailTemplate t : [
            select Id,Name 
            from EmailTemplate
            where Folder.Name = 'Opp Manual Emails' Order By Name ASC LIMIT 1
        ]) {
            myPageCon.selectedTemplateId = t.Id;
        }
        
        List<String> selectDocuments= myPageCon.getselectedDocuments();
        myPageCon.setselectedDocuments(selectDocuments);
        
        myPageCon.sendEmail();
    }
}