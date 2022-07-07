@isTest(SeeAllData=true)
public class TestVDAllocation {
    
    public static testMethod void myUnitTest() {
        Test.startTest();
        Id SalesId = VDAllocation.allocateSales();
        Id SettlementsId = VDAllocation.allocateSettlements();
        VDAllocation.isActiveVDSalesUser(SalesId);
        VDAllocation.isActiveVDSalesUser(SettlementsId);
        Test.stopTest();
    }
}