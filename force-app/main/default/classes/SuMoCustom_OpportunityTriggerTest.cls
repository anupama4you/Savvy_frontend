@isTest
public with sharing class SuMoCustom_OpportunityTriggerTest {
  private static testmethod void executeRewardingTest () {
    /*
    success.SuMoObjectSettings.getInstance().add('Custom_Opportunity__c');
    success.TestData.loadCustomSettingData();
    User testUser = success.TestData.Users.player;
    Profile[] profiles = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    Profile testProfile;
    if (profiles.size() > 0) testProfile = profiles[0];
    else {
	   profiles = [SELECT Id FROM Profile WHERE Name LIKE '%admin%' LIMIT 1];
      if (profiles.size() > 0) testProfile = profiles[0];
      else testProfile = [SELECT Id FROM Profile LIMIT 1][0];
    }
    system.runAs(new User(Id = UserInfo.getUserId())) {
      update new User(Id = UserInfo.getUserId(), success__SuMo_User__c = TRUE);
      insert testUser;
    }
    success__Achievement__c ach = new success__Achievement__c (Name = 'testAchievement',
								success__Action__c = 'Created',
								success__Object__c = 'Custom_Opportunity__c',
								success__Recipient__c = 'CreatedById',
								success__Experience_Formula__c = '42',
								RecordTypeID = success.TestData.RecordTypeMap.get('One_Off').Id,
								success__Reward_Message__c = 'Hurra!');
	insert ach;
	success__Team__c competition = new success__Team__c(Name = 'testCompetition',
								success__Start_Date_Time__c = DateTime.now().addDays(-1));
	insert competition;
	insert new success__Team_Member__c(success__User__c = userInfo.getUserId(),
										success__Team__c = competition.id,
										success__Role_Name__c = 'Participant');
	insert new success__Team_Achievement__c(success__Achievement__c = ach.id
,										success__Team__c =competition.id);
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {      //Create a Custom_Opportunity__c record
      Custom_Opportunity__c mainRecord = new Custom_Opportunity__c(
      );
      insert mainRecord;

    }
    Test.stopTest();
    System.assertEquals(1, [SELECT count() FROM success__Reward__c WHERE success__User__c = :UserInfo.getUserId()]);
*/
  }
}