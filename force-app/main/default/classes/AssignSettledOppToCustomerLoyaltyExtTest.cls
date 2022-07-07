/**
 * @author Andre Calimlim - Accenture
 * @description Test class for AssignSettledOppToCustomerLoyaltyExtTest class
 *				Test executed:setOpportunitiesToCustomerLoyalty, setFailOwnerChangeNoOpportunity
 *				
 */
@isTest
public with sharing class AssignSettledOppToCustomerLoyaltyExtTest {
	static testMethod void setOpportunitiesToCustomerLoyalty() {
		Test_DataGeneratorHelper.createOpportunity();
		Test.startTest();
		System.assertEquals(UserInfo.getUserId(), Test_DataGeneratorHelper.tstOpportunity.OwnerId);
		Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Settled';
		Test_DataGeneratorHelper.tstOpportunity.Date_Closed_or_Settled__c = DateTime.now();
		update Test_DataGeneratorHelper.tstOpportunity;
		System.debug('TEST!!1:' + Test_DataGeneratorHelper.tstOpportunity);
		Test.setCurrentPageReference(new PageReference('Page.AssignSettledOppToCustomerLoyalty'));
		System.currentPageReference().getParameters().put('id', UserInfo.getUserId());
		AssignSettledOppToCustomerLoyaltyExt ext = new AssignSettledOppToCustomerLoyaltyExt();
		ext.setOpportunities();
		
		Test.stopTest();
		
		Group groupId = [select Id from Group where DeveloperName = 'Customer_Loyalty' and Type = 'Queue'];
		System.assertEquals(groupId.Id, [Select OwnerId from Custom_Opportunity__c where Id =: Test_DataGeneratorHelper.tstOpportunity.Id].OwnerId);
	}
	
	static testMethod void setFailOwnerChangeNoOpportunity() {
		Test.startTest();
		
		Test.setCurrentPageReference(new PageReference('Page.AssignSettledOppToCustomerLoyalty'));
		System.currentPageReference().getParameters().put('id', UserInfo.getUserId());
		AssignSettledOppToCustomerLoyaltyExt ext = new AssignSettledOppToCustomerLoyaltyExt();
		ext.setOpportunities();
		
		Test.stopTest();
		System.assertEquals(0, [Select Id, OwnerId from Custom_Opportunity__c].size());
	}
	
	static testMethod void setFailOwnerChangeExceptionOccurred(){
		Test_DataGeneratorHelper.createOpportunity();
		Group groupId = [select Id, Name from Group where DeveloperName = 'Customer_Loyalty' and Type = 'Queue'];
		groupId.Name='Customer Loyalty Change';
		update groupId;
		Test.startTest();
		System.assertEquals(UserInfo.getUserId(), Test_DataGeneratorHelper.tstOpportunity.OwnerId);
		Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Settled';
		Test_DataGeneratorHelper.tstOpportunity.Date_Closed_or_Settled__c = DateTime.now();
		update Test_DataGeneratorHelper.tstOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.AssignSettledOppToCustomerLoyalty'));
		System.currentPageReference().getParameters().put('id', UserInfo.getUserId());
		AssignSettledOppToCustomerLoyaltyExt ext = new AssignSettledOppToCustomerLoyaltyExt();
		ext.setOpportunities();
		
		Test.stopTest();
		
		System.assertEquals(UserInfo.getUserId(), Test_DataGeneratorHelper.tstOpportunity.OwnerId);
		
	}
}