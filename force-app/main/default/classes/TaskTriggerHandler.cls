public class TaskTriggerHandler extends TriggerOrderHandler{
    
    public override void onAfterInsert (List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
        Task_Service.updateOpportunityByCallTask ((List<Task>) newRecords);
    }
}