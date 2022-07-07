@isTest
public class OpportunityTriggerHandlerTest {
  
  @isTest
  static void testTrigger() {
    Test.startTest();
    Account acc = Test_DataGeneratorHelper.buildAcc();
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    List<Custom_Opportunity__c> opps = new List<Custom_Opportunity__c>{o};
    Map<Id, Custom_Opportunity__c> oppsMap = new Map<Id, Custom_Opportunity__c>();
    oppsMap.put(o.Id, o);

    // Insert methods
    OpportunityTriggerHandler tgr = new OpportunityTriggerHandler();
    tgr.onBeforeInsert(opps);
    tgr.onAfterInsert(opps, oppsMap);

    // Update methods
    o.Status__c = 'Application Forms Received';
    update o;
    Test.stopTest();
  }

}