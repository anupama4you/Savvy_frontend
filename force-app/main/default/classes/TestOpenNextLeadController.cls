@isTest(SeeAllData=true)
public class TestOpenNextLeadController
{
    public static testMethod void testGeneralLeads() {

        Test.StartTest();
        
        Id sysGenUsrId = [select id, name from User where name='System Generated' limit 1].id;
        Test_DataGeneratorHelper.createLead();
        //Test_DataGeneratorHelper.tstLead.Employment_Status__c = 'Unresolved Lead';
        Test_DataGeneratorHelper.tstLead.Employment_Status__c = 'New Lead';
        Test_DataGeneratorHelper.tstLead.ownerId = sysGenUsrId;
        update Test_DataGeneratorHelper.tstLead;
        
        Test.StopTest();
        OpenNextLeadController ctrl = new OpenNextLeadController();
        ctrl.NextLeadURL();
        ctrl.ReturnHome();
        ctrl.getHasLeadSelected();

        ctrl.leadSel = null;
        ctrl.getHasLeadSelected();

        // BCCL
        ctrl.nextBCCLLead();
        // Money 3
        ctrl.nextMoney3Lead();
    }

    public static testMethod void testHomeLeads() {

        Test.StartTest();
        
        Id sysGenUsrId = [select id, name from User where name='System Generated' limit 1].id;
        Test_DataGeneratorHelper.createHomeLead();
        Test_DataGeneratorHelper.tstLead.Employment_Status__c = 'Full Time';
        Test_DataGeneratorHelper.tstLead.Status__c = 'New Lead';
        Test_DataGeneratorHelper.tstLead.ownerId = sysGenUsrId;
        update Test_DataGeneratorHelper.tstLead;
        
        Test.StopTest();
        OpenNextOppController ctrl = new OpenNextOppController();
        ctrl.NextLeadURL();
        ctrl.ReturnHome();
        ctrl.getHasLeadSelected();

        ctrl.leadSel = null;
        ctrl.getHasLeadSelected();
    }

}