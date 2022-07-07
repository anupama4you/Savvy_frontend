@isTest
public class RequiredDocTriggerTest {
  
  @isTest static void testCase() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    List<Required_Document__c> rds = new List<Required_Document__c>();
    Required_Document__c rd = new Required_Document__c(
      Name = '1',
      Opportunity__c = o.Id,
      Type__c = 'Payout Letter'
    );
    rds.add(rd);
    
    rd = new Required_Document__c(
      Name = '1',
      Opportunity__c = o.Id,
      Type__c = 'Payout Letter'
    );
    rds.add(rd);

    insert rds;
    Test.startTest();
    delete rds[0];
    delete rds[1];
    Test.stopTest();
  }

}