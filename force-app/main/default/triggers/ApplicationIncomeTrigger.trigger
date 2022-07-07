trigger ApplicationIncomeTrigger on Application_Income__c (before insert) {
	//System.debug('ApplicationIncomeTrigger..');
	TriggerManager.invoke(ApplicationIncomeTriggerHandler.class);
	//ApplicationIncomeService.changeFieldValues(Trigger.New);
}