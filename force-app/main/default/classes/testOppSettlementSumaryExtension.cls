@isTest
public class testOppSettlementSumaryExtension {
    @isTest(SeeAllData=true) static void test1(){
        		
        OppSettlementSumaryExtension oss = new OppSettlementSumaryExtension();
        oss.calculateSummary();
        oss.getMyInternalSettlement();
        oss.getMyDocumentsReceived();
        oss.getMyDocumentsSend();
        oss.getMySenttoLenderforSettlement();
        oss.getMyAwaitingFurtherInformation();
        oss.getMyRejectedByLender();
        oss.getMyConsultant();
        oss.getMyClient();
        oss.getMyLender();
        oss.getAllInternalSettlement();
        oss.getAllDocumentsReceived();
        oss.getAllDocumentsSend();
        oss.getAllSenttoLenderforSettlement();
        oss.getAllAwaitingFurtherInformation();
        oss.getAllRejectedByLender();
        oss.getAllConsultant();
        oss.getAllClient();
        oss.getAllLender();
        
    }
    
    @isTest(SeeAllData=true) static void test2(){
        Test.setCurrentPageReference(new PageReference('Page.OppSettlementSumaryExtension'));
		System.currentPageReference().getParameters().put('approvalType', 'CONSULTANT');		
        OppSettlementSumaryExtension oss = new OppSettlementSumaryExtension();
        oss.getMyOpportunitiesSubmitedList();
        oss.getOtherOpportunitiesSubmitedList();
        oss.getMyOpportunitiesSentList();
        oss.getOtherOpportunitiesSentList();
        String testr = oss.getApprovalTypeLabel();
        System.assertEquals('Settlement Officer Approval Consultant List', testr);
        
    }
    
    @isTest(SeeAllData=true) static void test3(){
        Test.setCurrentPageReference(new PageReference('Page.OppSettlementSumaryExtension'));
		System.currentPageReference().getParameters().put('approvalType', 'CLIENT');		
        OppSettlementSumaryExtension oss = new OppSettlementSumaryExtension();
        oss.getMyOpportunitiesSubmitedList();
        oss.getOtherOpportunitiesSubmitedList();
        oss.getMyOpportunitiesSentList();
        oss.getOtherOpportunitiesSentList();
        String testr = oss.getApprovalTypeLabel();
        System.assertEquals('Settlement Officer Approval Client List', testr);
        
    }
    
    @isTest(SeeAllData=true) static void test4(){
        Test.setCurrentPageReference(new PageReference('Page.OppSettlementSumaryExtension'));
		System.currentPageReference().getParameters().put('approvalType', 'LENDER');		
        OppSettlementSumaryExtension oss = new OppSettlementSumaryExtension();
        oss.getMyOpportunitiesSubmitedList();
        oss.getOtherOpportunitiesSubmitedList();
        oss.getMyOpportunitiesSentList();
        oss.getOtherOpportunitiesSentList();
        String testr = oss.getApprovalTypeLabel();
        System.assertEquals('Settlement Officer Approval Lender List', testr);
        
    }
    
    
    @isTest(SeeAllData=true) static void test5(){
        Test_DataGeneratorHelper.createApplication();
        Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
        Test.setCurrentPageReference(new PageReference('Page.OppApprovalSettlementDetail'));
		System.currentPageReference().getParameters().put('id', oppId);
		OppApprovalSettlementDetailExtension asd = new OppApprovalSettlementDetailExtension();
        asd.getAllApprovalHistory();
        asd.noteText='test';
        asd.approveProcess();
        
    }
    
    @isTest(SeeAllData=true) static void test6(){
        Test_DataGeneratorHelper.createApplication();
        Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
        Test.setCurrentPageReference(new PageReference('Page.OppApprovalSettlementDetail'));
		System.currentPageReference().getParameters().put('id', oppId);
		OppApprovalSettlementDetailExtension asd = new OppApprovalSettlementDetailExtension();
        asd.getAllApprovalHistory();
        asd.noteText='test';
        asd.rejectProcess();
        
    }
    @isTest(SeeAllData=true) static void test7(){
        Test_DataGeneratorHelper.createApplication();
        Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
        Test.setCurrentPageReference(new PageReference('Page.OppApprovalSettlementDetail'));
		System.currentPageReference().getParameters().put('id', oppId);
		OppApprovalSettlementDetailExtension asd = new OppApprovalSettlementDetailExtension();
        asd.getAllApprovalHistory();
        asd.noteText='test';
        asd.cancelProcess();
        
    }
    
    @isTest(SeeAllData=true) static void test8(){
        Test_DataGeneratorHelper.createApplication();
        Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
        Test.setCurrentPageReference(new PageReference('Page.OppApprovalSettlementDetail'));
		System.currentPageReference().getParameters().put('id', oppId);
		OppApprovalSettlementDetailExtension asd = new OppApprovalSettlementDetailExtension();
        
        asd.NameNextStatus='Next Step ';
        asd.opp.Status__c='Documents Sent';
        asd.getNameNextStatus();
        System.assertEquals('Next Step Documents Received', asd.NameNextStatus);
        
        asd.NameNextStatus='Next Step ';
        asd.opp.Status__c='Awaiting Further Information';
        asd.getNameNextStatus();
        System.assertEquals('Next Step Sent to Lender for Settlement', asd.NameNextStatus);
        
        asd.NameNextStatus='Next Step ';
        asd.opp.Status__c='Sent to Lender for Settlement';
        asd.getNameNextStatus();
        System.assertEquals('Settled', asd.NameNextStatus);
        
        asd.NameNextStatus='Next Step ';
        asd.opp.Status__c='Rejected By Lender';
        asd.getNameNextStatus();
        System.assertEquals('Settled', asd.NameNextStatus);
        
        asd.opp.Status__c='Documents Received';
        asd.showNextStatus=false;
        asd.getNextStatus();
        System.assertEquals(true, asd.showNextStatus);
        
    }
    
    @isTest(SeeAllData=true) static void test9(){
        Test_DataGeneratorHelper.createApplication();
        Id oppId = Test_DataGeneratorHelper.tstOpportunity.Id;
        Test.setCurrentPageReference(new PageReference('Page.OppApprovalSettlementDetail'));
		System.currentPageReference().getParameters().put('id', oppId);
		OppApprovalSettlementDetailExtension asd = new OppApprovalSettlementDetailExtension();
        asd.getAllApprovalHistory();
        asd.noteText='test';
        asd.approveProcessRBL();
        
    }
    
}