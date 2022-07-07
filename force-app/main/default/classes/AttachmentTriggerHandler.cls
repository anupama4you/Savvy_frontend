public class AttachmentTriggerHandler extends TriggerOrderHandler{
    public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
    	List<Attachment> newList = (List<Attachment>)newRecords;
    	AttachmentService.uploadToCloud(newList);
    }
    
    public override void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
    	
    }
}