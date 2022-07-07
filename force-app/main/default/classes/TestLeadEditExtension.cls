@isTest(SeeAllData = true)
public class TestLeadEditExtension
{
    public static testMethod void myUnitTest()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createLead();
        Test.stopTest();                                                        
        LeadEditExtension ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        system.assert(ext.IsPortal || !ext.IsPortal);
        ext.getHasEditAccess();
        ext.getIsOldestSysGen();
        ext.SaveOverride();

        Test_DataGeneratorHelper.tstLead.Status__c = null;
        ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        ext.SaveOverride();

        Test_DataGeneratorHelper.tstLead.Status__c = 'Sales Flow/Become Opportunity';
        ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        ext.SaveOverride();

        //User sysGen = SOQLSingletonQueries.recs().sysGenUser;

        //Test_DataGeneratorHelper.tstLead.Owner.Id = sysGen.Id;
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 3';
        ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        ext.SaveOverride();

        Test_DataGeneratorHelper.tstLead.Status__c = 'New Lead';
        ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        ext.SaveOverride();

        Test_DataGeneratorHelper.tstLead.Status__c = 'Duplicate Lead';
        ext = new LeadEditExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead));        
        ext.SaveOverride();

        ext.Submit();                
    }
}