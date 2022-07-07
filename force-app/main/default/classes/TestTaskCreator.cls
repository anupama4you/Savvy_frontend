@isTest
public class TestTaskCreator
{
    public static testMethod void myUnitTest()
    {                
        test.StartTest(); 
        Test_DataGeneratorHelper.createLead();
        TaskCreator.CreateTask(UserInfo.getUserId(), Test_DataGeneratorHelper.tstLead.Id, 'Test', 'Test', 1, 'Normal', 1);
        test.StopTest();
    }    
}