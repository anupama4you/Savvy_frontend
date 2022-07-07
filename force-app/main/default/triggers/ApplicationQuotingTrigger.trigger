trigger ApplicationQuotingTrigger on Application_Quoting__c (before insert, after insert, after update, after delete) {
	TriggerManager.invoke(ApplicationQuotingTriggerHandler.class);
}