public abstract class TriggerOrderHandler extends TriggerHandler {
 
    @TestVisible
    enum CTX {  
                IS_BEFORE_UPDATE, 
                IS_BEFORE_INSERT, 
                IS_AFTER_UPDATE, 
                IS_AFTER_INSERT, 
                IS_BEFORE_DELETE,
                IS_AFTER_DELETE,
                IS_AFTER_UNDELETE
             }
    
    public static final Map<CTX, Boolean> ALREADY_EXECUTED = new Map<CTX, Boolean> {
        CTX.IS_BEFORE_UPDATE => false,
        CTX.IS_BEFORE_INSERT => false,
        CTX.IS_AFTER_UPDATE => false,
        CTX.IS_AFTER_INSERT => false,
        CTX.IS_BEFORE_DELETE => false,
        CTX.IS_AFTER_DELETE => false
    }; 
    
    private virtual void invoke(List<SObject> newRecords,
                               List<SObject> oldRecords,
                               Map<ID, sObject> newRecordsMap,
                               Map<ID, sObject> oldRecordsMap,
                               boolean isBefore,
                               boolean isAfter,
                               boolean isInsert,
                               boolean isUpdate,
                               boolean isDelete,
                               boolean isUndelete) {
        if(isBefore) {
            if(isInsert && !ALREADY_EXECUTED.get(CTX.IS_BEFORE_INSERT) ) {
                
                ALREADY_EXECUTED.put(CTX.IS_BEFORE_INSERT, true);
                
                onBeforeInsert(newRecords);
                    
            }
            else if(isUpdate && !ALREADY_EXECUTED.get(CTX.IS_BEFORE_UPDATE) ) {
                
                ALREADY_EXECUTED.put(CTX.IS_BEFORE_UPDATE, true);
                
                onBeforeUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
                
            }
            else if(isDelete && !ALREADY_EXECUTED.get(CTX.IS_BEFORE_DELETE) ) {
                
                ALREADY_EXECUTED.put(CTX.IS_BEFORE_DELETE, true);
                
                onBeforeDelete(oldRecords, oldRecordsMap);
                
            }
        }
        else if(isAfter) {
            if(isInsert && !ALREADY_EXECUTED.get(CTX.IS_AFTER_INSERT)) {
                
                ALREADY_EXECUTED.put(CTX.IS_AFTER_INSERT, true);
                
                onAfterInsert(newRecords, newRecordsMap);
                
            }
            else if(isUpdate && !ALREADY_EXECUTED.get(CTX.IS_AFTER_UPDATE)) {
                
                ALREADY_EXECUTED.put(CTX.IS_AFTER_UPDATE, true);
                
                onAfterUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
                
            }
            else if(isDelete && !ALREADY_EXECUTED.get(CTX.IS_AFTER_DELETE) ) {
                
                ALREADY_EXECUTED.put(CTX.IS_AFTER_DELETE, true);
                
                onAfterDelete(oldRecords, oldRecordsMap);
            }
            else if(isUndelete && !ALREADY_EXECUTED.get(CTX.IS_AFTER_UNDELETE)) {
                
                ALREADY_EXECUTED.put(CTX.IS_AFTER_UNDELETE, true);
                
                onAfterUndelete(newRecords, newRecordsMap);
            }
        }
    }
}