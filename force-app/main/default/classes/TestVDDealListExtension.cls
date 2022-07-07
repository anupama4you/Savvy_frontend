@isTest
public class TestVDDealListExtension {
    public static testMethod void myUnitTest() {
        PageReference pageRef = Page.VDDealList;
        Test.setCurrentPageReference(pageRef);
        
        VDDealListExtension controller = new VDDealListExtension ();
    }
}