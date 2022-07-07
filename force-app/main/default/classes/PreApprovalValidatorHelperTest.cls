@isTest(SeeAllData=true)
public class PreApprovalValidatorHelperTest {
    
  @isTest
  static void testDocValidations() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    List<String> docs = new List<String>{
      'Drivers License (Front & Back)',
      'Payslip/s',
      'Tax Invoice/COS/ Rego Papers',
      'Insurance Policies'
    };
    List<String> existingDocs = new List<String>{
      'Drivers License (Front & Back)',
      'Payslip/s',
      'Warranty Policy Document'
    };
    Test_DataGeneratorHelper.buildCloudDocuments(o.Id, existingDocs);
    Test.startTest();
    // nulll parameter
    PreApprovalValidatorHelper.validateDocumentsUploaded(null, null);
    PreApprovalValidatorHelper.validateDocumentsUploaded(o.Id, null);
    // valid id
    PreApprovalValidatorHelper.validateDocumentsUploaded(o.Id, docs);
    // invalid id
    delete o;
    PreApprovalValidatorHelper.validateDocumentsUploaded(o.Id, docs);
    Test.stopTest();
  }

  @isTest
  static void testOtherValidations() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    // No policy documents
    PreApprovalValidatorHelper.hasAnyPolicyDocument(o.Id);
    
    // No savvy consent yet.
    PreApprovalValidatorHelper.hasSavvyConsentUploaded(o);

    String docType = 'Consent';
    PreApprovalValidatorHelper.validateADocumentUploaded(o.Id, docType);
    Test_DataGeneratorHelper.buildCloudDocuments(o.Id, new List<String>{docType});
    PreApprovalValidatorHelper.validateADocumentUploaded(o.Id, docType);
    
    PreApprovalValidatorHelper.getProductList(null, null);
    PreApprovalValidatorHelper.getProductList(o.Id, null);
    PreApprovalValidatorHelper.getProductList(o.Id, 'Finance');

    PreApprovalValidatorHelper.validatePreliminaryAssessmentSurplus(o);
    
    PreApprovalValidatorHelper.isInsuranceProducts(o.Id);

    PreApprovalValidatorHelper.isESignLivePackageCompleted(o.Id);

    PreApprovalValidatorHelper.hasSavvyConsentUploaded(o);

    PreApprovalValidatorHelper.hasDocumentsToLender(o.Id);

    PreApprovalValidatorHelper.hasBankStatements(o.Id);

    PreApprovalValidatorHelper.getFinanceProduct(o.Id);

    Test.stopTest();
  }

}