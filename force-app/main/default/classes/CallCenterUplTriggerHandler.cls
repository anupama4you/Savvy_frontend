public class CallCenterUplTriggerHandler extends TriggerOrderHandler {
    
    public override void onAfterInsert (List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
        CallCenterUpl_Service.createCallTaskReference ((List<Call_Center_Upl__c>) newRecords);
    }

}