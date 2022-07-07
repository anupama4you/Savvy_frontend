@isTest
public with sharing class PartnerCommunityApprovalsTest {
  @isTest
  static void testMethods() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test_DataGeneratorHelper.createQuoting('Pepper MV');
    Test.startTest();
    PartnerCommunityApprovals.preApprovalValidation(o.Id);
    PartnerCommunityApprovals.formalApprovalValidation(o.Id);
    PartnerCommunityApprovals.settlementValidation(o.Id);
    PartnerCommunityApprovals.getLenderSettings(o.Id);
    PartnerCommunityApprovals.processApi(o.Id);
    Test.stopTest();
  }
  @isTest(SeeAllData=true)
  static void testPreApprovalSubmission() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    Test.startTest();
    // No applicable process
    PartnerCommunityApprovals.submitApproval(
      o.Id,
      PartnerCommunityApprovals.PRE_APPROVAL_TYPE,
      'Lender comments here!',
      'Broker Support comments here!'
    );
    // Submission
    o.Status__c = 'Application Forms Received';
    update o;
    PartnerCommunityApprovals.submitApproval(
      o.Id,
      PartnerCommunityApprovals.PRE_APPROVAL_TYPE,
      'Lender comments here!',
      'Broker Support comments here!'
    );
    // Already submitted
    PartnerCommunityApprovals.submitApproval(
      o.Id,
      PartnerCommunityApprovals.PRE_APPROVAL_TYPE,
      'Lender comments here!',
      'Broker Support comments here!'
    );

    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void testOtherApprovalSubmissions() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    o.Status__c = 'Pre-Approved';
    update o;
    Test.startTest();
    // Formal Approval
    PartnerCommunityApprovals.submitApproval(
      o.Id,
      PartnerCommunityApprovals.FORMAL_APPROVAL_TYPE,
      'Lender comments here!',
      'Broker Support comments here!'
    );
    // Settlement
    o.Status__c = 'Formal Approved';
    update o;
    PartnerCommunityApprovals.submitApproval(
      o.Id,
      PartnerCommunityApprovals.SETTLED_TYPE,
      'Lender comments here!',
      'Broker Support comments here!'
    );
    Test.stopTest();
  }

  @isTest(SeeAllData=true)
  static void testManualSubmission() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    Test.startTest();
    // Pre-approval
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      PartnerCommunityApprovals.PRE_APPROVAL_TYPE,
      false
    );
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      PartnerCommunityApprovals.PRE_APPROVAL_TYPE,
      true
    );
    // Formal Approval
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      PartnerCommunityApprovals.FORMAL_APPROVAL_TYPE,
      false
    );
    // null opp
    PartnerCommunityApprovals.manualSubmission(
      null,
      null,
      null
    );
    // null status
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      null,
      true
    );
    // Wrong approval process
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      'WRONG APPROVAL',
      true
    );
    // Invalid opportunity
    delete o;
    PartnerCommunityApprovals.manualSubmission(
      o.Id,
      PartnerCommunityApprovals.FORMAL_APPROVAL_TYPE,
      false
    );

    Test.stopTest();
  }
}