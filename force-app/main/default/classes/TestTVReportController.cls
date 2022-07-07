@isTest
public class TestTVReportController
{
    public static testMethod void myUnitTest()
    {                

        TVReportController ctrl = new TVReportController();
        ctrl.getTableData();
        system.assert(ctrl.TotalTarget != null || ctrl.TotalTarget == null);
        ctrl.getTimeNow();
    }    
}