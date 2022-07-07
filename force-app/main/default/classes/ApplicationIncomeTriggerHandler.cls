public class ApplicationIncomeTriggerHandler extends TriggerOrderHandler {
	public override void onBeforeInsert(List<sObject> newRecords) {
		ApplicationIncomeService.changeFieldValues((List<Application_Income__c>)newRecords);
		//System.debug('onBeforeInsert...');
	}
	//public override void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, 
	//	                                Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
 //   	System.debug('onBeforeUpdate...');   
 //   }

 //   public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
 //   	System.debug('onAfterInsert...');
 //   }
    
 //   public override void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, 
 //   	                               Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
 //   	System.debug('onAfterUpdate...');
 //   }
}