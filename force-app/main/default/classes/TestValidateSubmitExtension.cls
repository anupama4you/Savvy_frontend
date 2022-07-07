@isTest
public class TestValidateSubmitExtension
{
    public static testMethod void myUnitTest()
    {

        test.startTest();
        Test_DataGeneratorHelper.createOpportunity();
        test.stopTest();
        Required_Document__c rd = new Required_Document__c();
        rd.Opportunity__c = Test_DataGeneratorHelper.TstOpportunity.Id;
        insert rd;
        Test_DataGeneratorHelper.tstOpportunity.Insurance_Cover__c ='yes';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        ValidateSubmitExtension ext = new ValidateSubmitExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
        ext.Validate2();
        
        //ext.MissingDocs.clear();
        //ext.MissingOppFields.clear();
        //ext.MissingProductFields.clear();
        //ext.MissingChecklist.clear();
        //ext.Validate2();
    }
}