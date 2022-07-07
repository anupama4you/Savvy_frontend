public class ApplicationQuotingTriggerHandler extends TriggerOrderHandler{
    
	public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
		System.debug('ApplicationQuotingTriggerHandler.onAfterInsert... ');
	}
	
	public override void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
		ApplicationQuotingService.authorizationChecker((List<Application_Quoting__c>) newRecords, (Map<Id, Application_Quoting__c>) oldRecordsMap);
	}
	
	public override void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
		System.debug('ApplicationQuotingTriggerHandler.onAfterDelete... ');
	}

	public override void onBeforeInsert(List<sObject> newRecords) {
		System.debug('ApplicationQuotingTriggerHandler.onBeforeInsert... ');
	}
}