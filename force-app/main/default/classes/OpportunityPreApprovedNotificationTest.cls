@isTest(SeeAllData=true)
public class OpportunityPreApprovedNotificationTest {
  public static Map<String, id> RecordTypes;
  public OpportunityPreApprovedNotificationTest() {
  }

  public static void recordTypes() {
    RecordTypes = new Map<String, Id>();
    for (RecordType rt : [SELECT Id, Name FROM RecordType]) {
      RecordTypes.put(rt.Name, rt.Id);
    }
  }

  @isTest
  static void testNotify() {
    recordTypes();
    Account a = new Account(
      RecordTypeId = recordTypes.get('Person Account'),
      FirstName = 'f',
      LastName = 'l'
    );
    insert a;

    Custom_Opportunity__c o = new Custom_Opportunity__c(
      Name = 'n',
      Status__c = 's',
      First_Name__c = 'f',
      Last_Name__c = 'l',
      Mobile_Number__c = '1',
      Email_Address__c = 'e@e.com',
      Account__c = a.Id
    );

    insert o;

    // Custom_Opportunity__c opp = [
    //   SELECT
    //     Name,
    //     First_Name__c,
    //     Owner_Name__c,
    //     Owner_Phone__c,
    //     Owner_Mobile__c,
    //     Owner_Email__c,
    //     Email_Address__c
    //   FROM Custom_Opportunity__c
    //   WHERE Id = :o.Id
    // ];

    // OpportunityPreApprovedNotification.notify(
    //   new List<Custom_Opportunity__c>{ opp }
    // );
    // Task t = new Task(
    //   WhatId = o.Id,
    //   Subject = 'Email: Pre-approved loan - Savvy'
    // );

    // insert t;
    // OpportunityPreApprovedNotification.notify(
    //   new List<Custom_Opportunity__c>{ opp }
    // );

    CustomerPreApprovedNotificationProcess.notify(new List<Id>{ o.Id });
    LibertyPreApprovedNotificationProcess.notify(new List<Id>{ o.Id });
  }
}