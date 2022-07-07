@isTest
public class CloudDocGeneratorBatchTest {
  
  @isTest 
  static void testPreApprovalDoc() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.StartTest();
    CloudDocGeneratorBatch.createBatch(o.Id, CloudDocGeneratorBatch.APP_PREAPPROVAL_DOC, 1);
    Test.stopTest();
  }

  @isTest 
  static void testDofInvociDoc() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.StartTest();
    CloudDocGeneratorBatch.createBatch(o.Id, CloudDocGeneratorBatch.DOF_INVOICE_DOC, 1);
    Test.stopTest();
  }

  @isTest 
  static void testVDReferralDoc() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.StartTest();
    CloudDocGeneratorBatch.createBatch(o.Id, CloudDocGeneratorBatch.VD_FLEETREFERRAL, 1);
    Test.stopTest();
  }

}