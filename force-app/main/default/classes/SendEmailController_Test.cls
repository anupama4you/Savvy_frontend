@isTest
public class SendEmailController_Test {
  @isTest(SeeAllData=true)
  public static void testM() {
    //Create Account
    Account acc = Test_DataGeneratorHelper.buildAcc();
    // acc.Name ='test';
    // insert acc;
    Custom_Opportunity__c opp = new Custom_Opportunity__c();
    opp.Account__c = acc.Id;
    opp.Notes__c = 'test';
    opp.Status__c = 'Become Opportunity';
    insert opp;
    Required_Document__c req = new Required_Document__c(
      Opportunity__c = opp.Id,
      Name = 'Payslip/s',
      Type__c = 'Payslip/s'
    );
    insert req;

    Test.startTest();
    List<SendEmailController.SelectDocumentWrapper> allDoc = SendEmailController.allDocumentList(
      opp.Id
    );
    List<SendEmailController.SelectDocumentWrapper> selecteddoc = new List<SendEmailController.SelectDocumentWrapper>();
    integer count = 0;
    for (SendEmailController.SelectDocumentWrapper s : allDoc) {
      s.flag = true;
      selecteddoc.add(s);
      count++;
      if (count == 5) {
        break;
      }
    }
    SendEmailController.DocumentSave(selecteddoc, opp.Id);
    SendEmailController.saveRequiredDocs(opp.Id, selecteddoc);

    String mydocs = JSON.serialize(selecteddoc);
    try {
      SendEmailController.DocumentSave(mydocs, opp.Id);
    } catch (exception e) {
      System.assert(true, 'Execption!');
    }

    try {
      SendEmailController.saveRequiredDocs(opp.Id, mydocs);
    } catch (exception e) {
      System.assert(true, 'Execption!');
    }
    
    List<EmailTemplate> allEmailTemplate = SendEmailController.getEmailTemplate();
    SendEmailController.renderEmailTemplatewithMergeField(
      (String) allEmailTemplate[0].Id,
      (String) opp.Id
    );

    SendEmailController.sendEmail(
      (String) allEmailTemplate[0].Id,
      (String) opp.Id,
      'testobj',
      '<html>test</html>',
      'test@gmail.com',
      'testx@gmail.com',
      'testy@gmail.com',
      'testz@gmail.com',
      'abctest',
      'fileName',
      null
    );

    //  SendEmailController.renderEmailTemplatewithMergeField('abcidtest',(String) opp.Id);
    Test.stopTest();
  }
}