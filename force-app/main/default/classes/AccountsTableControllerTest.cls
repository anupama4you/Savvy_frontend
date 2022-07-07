@isTest
public class AccountsTableControllerTest {
  
  @isTest
  static void myTest() {

    Test.startTest();
    AccountsTableController.getRecords();
    try {
      Account a = new Account();
      AccountsTableController.updateRecords(JSON.serialize(new List<Account>{a}));
    } catch (AuraHandledException e) {}
    AccountsTableController.getPicklistValues('Custom_Opportunity__c', 'Status__c');
    Test.stopTest();
  }

}