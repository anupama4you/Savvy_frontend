@isTest
public class Portal_Lead_AttemptControllerTest {
  static testMethod void getisAttempTest() {
    User user1 = Test_DataGeneratorHelper.buildPartnerUser();
    System.runAs(user1) {
      //Create Lead
      Lead__c lead1 = new Lead__c();
      lead1.Finance_Amount__c = 100;
      lead1.First_Name__c = 'Test';
      lead1.Last_Name__c = 'LeadName';
      insert lead1;

      //Call class methods
      Portal_Lead_AttemptController className = new Portal_Lead_AttemptController();
      className.LeadVal = lead1;
      Boolean returnVal1 = className.getisAttemp1();
      Boolean returnVal2 = className.getisAttemp2();
      Boolean returnVal3 = className.getisAttemp3();
      Boolean returnVal4 = className.getisAttemp4();
      Boolean returnVal5 = className.getisAttemp5();
      User returnUserVar = className.getUserVar();
      Contact returnContactVar = className.getContactVar();
      Account returnAccountVar = className.getAccountVar();
    }
  }
}