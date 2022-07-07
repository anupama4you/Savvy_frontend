@isTest
public class TestPreApprovalAuthorisationList {
    
    @isTest static void testPreApprAuthListExtension() {
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        ApprovalTools.submittForApproval(
            ApprovalTools.PREAPPROVAL_AUTHPROCESS_DEFINITION, o.Id, 'Test comment', false);
        Test.startTest();
        PreApprovalAuthorisationListExtension c = new PreApprovalAuthorisationListExtension();
        c.refresh();
        c.hideMessages();
        c.openApproval();
        c.oppIdSel = o.Id;
        c.openApproval();
        Test.stopTest();
    }

    @isTest static void testPreApprAuthPipeLineRpt() {
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Status__c = 'Pre-Approved';
        o.Preapproval_Auth_Date__c = Datetime.now();
        update o;

        Test.startTest();
        PreApprovalAuthorisationReportExtension c = new PreApprovalAuthorisationReportExtension();
        c.refresh();
        c.hideMessages();
        c.getAuthorisationData();
        c.getOtherProcessesData();
        c.getApprovalDataKeys();
        Test.stopTest();
    }

    @isTest static void testPreApprAuthPipeLineRpt2() {
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Status__c = 'Pre-Approved';
        o.Preapproval_Auth_Date__c = Datetime.now();
        update o;

        Test.startTest();
        PreApprovalAuthorisationReport2Extension c = new PreApprovalAuthorisationReport2Extension();
        c.refresh();
        c.hideMessages();
        // Detailed
        c.getDetailedDataKeys();
        c.getSections();
        c.openApproval();
        c.oppIdSel = o.Id;
        c.openApproval();
        c.runFullReportAction();
        Test.stopTest();
    }

    @isTest static void testPreApprAuthPipeLineRptDetailParams() {
        Test_DataGeneratorHelper.createLead();
        Lead__c a = Test_DataGeneratorHelper.tstLead;
        a.Loan_Type__c = 'Car Loan';
        update a;
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Test_DataGeneratorHelper.createProduct();
        Product__c p = Test_DataGeneratorHelper.tstFinanceProduct;
        p.Lender__c = 'My Lender';
        update p;

        o.Status__c = 'Pre-Approved';
        o.Preapproval_Auth_Date__c = Datetime.now();
        o.Lead__c = a.Id;
        o.Loan_Product__c = p.Id;
        update o;
        
        
        PageReference pageRef = Page.PreApprovalAuthorisationRptDet;
        Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('SECTION','Pre-Approvals');
        pageRef.getParameters().put('STATUS','Pre-Approved');
        Test.startTest();
        PreApprovalAuthorisationRptDetController c = new PreApprovalAuthorisationRptDetController();
        c.refresh();
        c.params.ownership = getCurrentUser().Name;
        c.params.lender = 'o';
        c.params.loanType = a.Loan_Type__c;
        c.getOwnerOptions();
        c.getLenderOptions();
        c.getLoanTypeOptions();
        c.hideMessages();
        c.status = 'Settled';
        c.search();
        c.status = 'Settlement Rejected';
        c.params.lender = p.Lender__c;
        c.search();
        Test.stopTest();
    }

    @isTest static void testPreApprAuthPipeLineRptDetailNoParams() {
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Status__c = 'Pre-Approved';
        o.Preapproval_Auth_Date__c = Datetime.now();
        update o;
        
        Test.startTest();
        PreApprovalAuthorisationRptDetController c = new PreApprovalAuthorisationRptDetController();
        c.refresh();
        c.openApproval();
        c.oppIdSel = o.Id;
        c.openApproval();
        c.backToPipeline();
        Test.stopTest();
    }

    @isTest static void testPreApprovalAuthorisationHelper() {
        Test_DataGeneratorHelper.createOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Status__c = 'Pre-Approved';
        o.Preapproval_Auth_Date__c = Datetime.now();
        update o;
        
        Test.startTest();
        System.assertEquals(PreApprovalAuthorisationHelper.AUTHORISATION_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Pre-approval Authorisation Approved'));
        System.assertEquals(PreApprovalAuthorisationHelper.SETTLEMENT_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Documents Sent'));
        System.assertEquals(PreApprovalAuthorisationHelper.PREAPPROVAL_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Submitted for Pre-Approval'));
        System.assertEquals(PreApprovalAuthorisationHelper.AMENDMENT_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Submitted for Amendment'));
        System.assertEquals(PreApprovalAuthorisationHelper.FORMALAPPROVAL_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Submitted for Formal Approval'));
        System.assertEquals(PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION, 
            PreApprovalAuthorisationHelper.getSection('Awaiting Paperwork'));
        
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.AUTHORISATION_SECTION).size()>0);
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.SETTLEMENT_SECTION).size()>0);
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.FORMALAPPROVAL_SECTION).size()>0);
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.AMENDMENT_SECTION).size()>0);
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.PREAPPROVAL_SECTION).size()>0);
        System.assert(PreApprovalAuthorisationHelper.getSectionStatuses(PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION).size()==0);

        System.assert(PreApprovalAuthorisationHelper.excludedStatuses().size()>0);

        Test.stopTest();
    }

    public static User getCurrentUser() {
        return [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
    }
}