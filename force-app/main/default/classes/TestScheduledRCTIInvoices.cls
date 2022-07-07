@isTest
public class TestScheduledRCTIInvoices 
{
    public static testMethod void myUnitTest()
    {
        Test.startTest();                      
        
        String sched = '0 0 18 * * ? 2099';
        
        // Schedule the test job
        String jobId = System.schedule('TestScheduledRCTIInvoices', sched, new ScheduledRCTIInvoices());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT id, 
                                 CronExpression, 
                                 TimesTriggered, 
                                 NextFireTime 
                          FROM   CronTrigger 
                          WHERE  id = :jobId];
                          
        // Verify the expressions are the same
        System.assertEquals(sched, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2099-01-01 18:00:00', String.valueOf(ct.NextFireTime));      
        
        Test.stopTest();           
    }
}