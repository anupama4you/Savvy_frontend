@isTest(SeeAllData=true)
public class ValidateSubmitApprovalTest {
  @isTest
  static void testPreApprovalValidation() {
    // Application
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

    Test.startTest();

    PageReference pf = Page.ValidatePreApprovalSubmit;
    pf.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pf);
    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    ValidatePreApprovalSubmitExtension ctr = new ValidatePreApprovalSubmitExtension(
      sc
    );
    ctr.validateApproval();
    ctr.getWarningMessages();

    // Submission
    ctr.noteTextLender = 'lender notes';
    ctr.noteText = 'Processing notes';
    ctr.submit();

    String currentProcess = ApprovalTools.checkRecordForApprovalProcess(opp.Id);
    System.debug('Current process => ' + currentProcess);
    System.assert(
      String.isNotBlank(currentProcess),
      'Not active approval process'
    );

    // Submission - exceptions
    ctr.submit();

    // Validating fully isValidForm method
    ctr = new ValidatePreApprovalSubmitExtension(sc);
    // Initial submission
    ctr.submit();
    // second submission
    ctr.opp.Application__c = null;
    ctr.preApprovalAuth = true;
    ctr.submit();

    Test.stopTest();
  }

  @isTest
  static void testAmendmentValidation() {
    // Application
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    opp.Status__c = 'Pre-Approved';
    update opp;

    Test.startTest();

    PageReference pf = Page.ValidateAmendmentSubmit;
    pf.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pf);
    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    ValidateAmendmentSubmitExtension ctr = new ValidateAmendmentSubmitExtension(
      sc
    );
    ctr.validateApproval();
    ctr.getWarningMessages();

    // Submission
    ctr.noteTextLender = 'lender notes';
    ctr.noteText = 'Processing notes';
    ctr.submit();

    String currentProcess = ApprovalTools.checkRecordForApprovalProcess(opp.Id);
    System.debug('Current process => ' + currentProcess);
    System.assert(
      String.isNotBlank(currentProcess),
      'Not active approval process'
    );

    // Submission - exceptions
    ctr.submit();

    // Validating fully isValidForm method
    ctr = new ValidateAmendmentSubmitExtension(sc);
    // Initial submission
    ctr.submit();
    // second submission
    ctr.opp.Application__c = null;
    ctr.submit();

    Test.stopTest();
  }

  @isTest
  static void testFormalApprovalValidation() {
    // Application
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

    Test.startTest();

    PageReference pf = Page.ValidateFormalApprovalSubmit;
    pf.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pf);
    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    ValidateFormalApprovalSubmitExtencion ctr = new ValidateFormalApprovalSubmitExtencion(
      sc
    );
    ctr.validateApproval();
    ctr.getWarningMessages();

    ctr.getQuotingMessages();
    ctr.getIsQuotingMessages();

    // Submission
    ctr.opp.Status__c = 'Pre-Approved';
    ctr.noteTextLender = 'lender notes';
    ctr.noteText = 'Processing notes';
    ctr.opp.Notes_to_Settlement_Officer__c = 'Settlement notes';
    ctr.submit();

    String currentProcess = ApprovalTools.checkRecordForApprovalProcess(opp.Id);
    System.debug('Current process => ' + currentProcess);
    System.assert(
      String.isNotBlank(currentProcess),
      'Not active approval process'
    );

    // Submission - exceptions
    ctr.submit();

    // Validating fully isValidForm method
    ctr = new ValidateFormalApprovalSubmitExtencion(sc);
    // Initial submission
    ctr.submit();
    // second submission
    ctr.opp.Application__c = null;
    ctr.opp.Notes_to_Settlement_Officer__c = null;
    ctr.submit();

    Test.stopTest();
  }

  @isTest
  static void testSettlementValidation() {
    // Application
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

    Test.startTest();

    PageReference pf = Page.ValidateSubmit;
    pf.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pf);
    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    ValidateSubmitExtension ctr = new ValidateSubmitExtension(
      sc
    );

    ctr.Validate2();

    // Submission
    ctr.opp.Status__c = 'Formal Approved';
    ctr.opp.Notes_to_Settlement_Officer__c = 'Settlement notes';
    ctr.submit();

    String currentProcess = ApprovalTools.checkRecordForApprovalProcess(opp.Id);
    System.debug('Current process => ' + currentProcess);
    System.assert(
      String.isNotBlank(currentProcess),
      'Not active approval process'
    );

    // Submission - exceptions
    ctr.submit();

    // // Validating fully isValidForm method
    // ctr = new ValidateSubmitExtension(sc);
    // // Initial submission
    // ctr.submitForApproval(opp.Id);
    // // second submission
    // ctr.opp.Application__c = null;
    // ctr.opp.Notes_to_Settlement_Officer__c = null;
    // ctr.submit();

    Test.stopTest();
  }

}