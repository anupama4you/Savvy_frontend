public class AccountTriggerHandler extends TriggerOrderHandler{
    public override void onBeforeInsert(List<sObject> newRecords) {
    	//System.debug('onBeforeInsert...');
    // Partner accounts
    PartnerCommunityController.dataCheckerAccounts((List<Account>) newRecords);
    //-----------------
		AccountService.checkAccEmailMobileDuplicate((List<Account>) newRecords);
		AccountService.setDefaultOwnership((List<Account>) newRecords);
	}

	public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
		//System.debug('onAfterInsert...');
		AccountService.accountSharing((List<Account>) newRecords);
	}
	
	public override void onBeforeUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<Id, sObject> oldRecordsMap, Map<Id, sObject> newRecordsMap) {
		//System.debug('onBeforeUpdate...');
		AccountService.checkAccEmailMobileDuplicate((List<Account>) newRecords, (Map<Id, Account>) oldRecordsMap);
		AccountService.setDefaultOwnership((List<Account>) newRecords);
	}
	
	public override void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) {
		//System.debug('onBeforeUpdate...');
		//AccountService.setLeadAndApplicationOwner((List<Account>) newRecords, (Map<Id, Account>) oldRecordsMap);
		AccountService.accountSharing((List<Account>) newRecords);
		
	}
}