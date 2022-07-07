@isTest(SeeAllData=true)
public class TestCalculaterHomePageController {
  public static testMethod void unitTest() {
    //Insert object
    Custom_Opportunity__c opp = new Custom_Opportunity__c();
    opp.Name = 'Testing';
    opp.Preapproval_Auth_Date__c = date.today();
    insert opp;

    Test.startTest();
    CalculaterHomePageController.redirectLinkWrapper wrapTest = new CalculaterHomePageController.redirectLinkWrapper();
    //Invoke method
    wrapTest = CalculaterHomePageController.callCalculater(opp.Id);
    Test.stopTest();
  }

  @isTest static void unitTestBrokerUser() {
    
    User pu = Test_DataGeneratorHelper.buildPartnerUser();

    Test.startTest();
    
    System.runAs(pu) {
      Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(true);
      CalculaterHomePageController.redirectLinkWrapper wrapTest = new CalculaterHomePageController.redirectLinkWrapper();
      //Invoke method
      wrapTest = CalculaterHomePageController.callCalculater(opp.Id);
    }
    Test.stopTest();
  }

}