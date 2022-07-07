public class LeadTriggerHandler extends TriggerOrderHandler {

	public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
		System.debug('LeadTriggerHandler.onAfterInsert... ' + newRecords.size());	
		LeadService.queueActiveLeadOnInsert((List<Lead__c>)newRecords);
		// SHOULD BE THE LAST METHOD
		LeadService.callCenterService((List<Lead__c>)newRecords, false);
		// --------------------------
	}
	
	//public override void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
	//	LeadService.unresolveLeadOnUpdate((List<Lead__c>) newRecords, (Map<Id, Lead__c>) oldRecordsMap);
	//}

	public override void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
		LeadService.queueActiveLeadOnUpdate((List<Lead__c>) newRecords, (Map<Id, Lead__c>) oldRecordsMap);
		LeadService.setStatusOnTaskAndAccount((List<Lead__c>) newRecords, (Map<Id, Lead__c>) oldRecordsMap);
		LeadService.setApplicationOwnerAndAccount((List<Lead__c>) newRecords, (Map<Id, Lead__c>) oldRecordsMap);
		LeadService.leadSharing((List<Lead__c>) newRecords);
		// LeadService.completeCCLeads((List<Lead__c>) newRecords);
	}
	
	public override void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
		LeadService.queueActiveLeadOnDelete((List<Lead__c>)oldRecords);
	} 

	public override void onBeforeInsert(List<sObject> newRecords) {
		System.debug('LeadTriggerHandler.onBeforeInsert... ' + newRecords.size());
    // Partner portal 
    PartnerCommunityController.dataCheckerLeads((List<Lead__c>)newRecords);
    //---------------
		LeadService.dataChecker((List<Lead__c>)newRecords);
		LeadService.checkDuplicates((List<Lead__c>)newRecords);
		LeadService.suggestAnOwner((List<Lead__c>)newRecords);
		LeadService.bucketChecker((List<Lead__c>)newRecords);
		LeadService.assosiateCampaign((List<Lead__c>)newRecords);
		//LeadService.checkAccountCreation((List<Lead__c>)newRecords);
	}
}