@isTest(SeeAllData=true)
public class TestFleetReferralExtension {
    
    public static testMethod void fleetReferralTest () {
    	test.startTest();
        Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
        
        PageReference pageRef = Page.FleetReferral;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        FleetReferralExtension myPageCon = new FleetReferralExtension(sc);
        myPageCon.validate();
        myPageCon.sendVDForApproval ();
        
        Test_DataGeneratorHelper.sleep(2000);
        //Test_DataGeneratorHelper.createVDWorksheet();
        Test_DataGeneratorHelper.reloadOpportunity();
        System.debug('Recalling the process...');
        ApprovalTools.recallProcess(Test_DataGeneratorHelper.tstOpportunity.VD_Worksheet__c,'bla bla bla...');
        Test_DataGeneratorHelper.reloadOpportunity();
        sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        myPageCon = new FleetReferralExtension(sc);
        //myPageCon.validate();
        myPageCon.sendVDForApproval ();
        myPageCon.getCustomerAdrress();
    }

    public static testMethod void newCarDemoTest () {
        test.startTest();
        Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
        
        PageReference pageRef = Page.VDNewDemo;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        VDNewDemoExtension myPageCon = new VDNewDemoExtension(sc);
        
        myPageCon.sendVDForApproval ();
        
        Test_DataGeneratorHelper.sleep(2000);
        //Test_DataGeneratorHelper.createVDWorksheet();
        Test_DataGeneratorHelper.reloadOpportunity();
        System.debug('Recalling the process...');
        ApprovalTools.recallProcess(Test_DataGeneratorHelper.tstOpportunity.VD_Worksheet__c,'bla bla bla...');
        Test_DataGeneratorHelper.reloadOpportunity();
        sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        myPageCon = new VDNewDemoExtension(sc);
        myPageCon.validate();
        myPageCon.sendVDForApproval ();
        myPageCon.getCustomerAdrress();
    }

}