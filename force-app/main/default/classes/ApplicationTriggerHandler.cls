public class ApplicationTriggerHandler extends TriggerOrderHandler {
    public override void onBeforeInsert(List<sObject> newRecords) {
      // Partner portal
      PartnerCommunityController.dataCheckerApplications((List<Application__c>) newRecords);
      //---------------
    	ApplicationService.changeFieldValues((List<Application__c>) newRecords);
    	ApplicationService.updateRelatedAccount((List<Application__c>) newRecords);
    }
    
    public override void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
        System.debug('onBeforeUpdate...');
        ApplicationService.changeFieldValues((List<Application__c>) newRecords);
    }

    public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
    	//ApplicationService.insertOrUpdateLeadsAndUpdateOpportunity((List<Application__c>) newRecords);  PROCESS REPLACED BY linkApplication
        ApplicationService.linkApplication((List<Application__c>) newRecords);
    }
    
    /*
    public override void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
        System.debug('onAfterUpdate...');
    	// ApplicationService.opportunityUpdate((List<Application__c>) newRecords, (Map<Id, Application__c>) oldRecordsMap);
    }
    */
}