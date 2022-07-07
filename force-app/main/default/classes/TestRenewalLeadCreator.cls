@isTest
public class TestRenewalLeadCreator
{
    public static testMethod void myUnitTest()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Settled';
        Test_DataGeneratorHelper.tstOpportunity.Date_Closed_or_Settled__c = date.today();
        test.stopTest();
        
        RenewalLeadCreator.Create();
        
        
    }
}