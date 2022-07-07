@isTest
public class TestLeadAccountLookupController
{
    public static testMethod void myUnitTest()
    {
        //TestData data = new TestData();
        
        Test.setCurrentPage(Page.LeadAccountLookup);
        ApexPages.currentPage().getParameters().put('dob', '01/01/2013');
        ApexPages.CurrentPage().getParameters().put('srch', 'Test*'); 
        
        LeadAccountLookupController ctrl = new LeadAccountLookupController();
        ctrl.SearchTerm = '';
        ctrl.SearchGo();
        ctrl.ClickNew();
        
        ctrl.FirstName = 'Test';
        ctrl.LastName = 'Test';
        ctrl.NewAccount.PersonOtherStreet = 'Test';
        ctrl.NewAccount.PersonOtherCity = 'Test';
        ctrl.NewAccount.PersonOtherState = 'Test';
        ctrl.NewAccount.PersonOtherPostalCode = 'Test';
        
        ctrl.SaveAccount();
    }
}