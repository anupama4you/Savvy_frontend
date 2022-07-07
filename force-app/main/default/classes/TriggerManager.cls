/*
 *	@author Andre Calimlim
 *	@description Manager to define trigger handler interface and dispatch trigger actions
 */
public class TriggerManager {
    @TestVisible
    private static Set<Type> bypassedHandlers = new Set<Type>();
    
    /*
	 *	@author Andre Calimlim
	 *	@description Manages execution of 'black list' trigger handlers during apex transaction
	 *	@param type handler to determine the class e.g ContactTriggerHandler class
	 */
    public static void bypass(Type handler) {
        bypassedHandlers.add(handler);
    }

    public static void clearBypass(Type handler) {
        bypassedHandlers.remove(handler);
    }

    public static Boolean isBypassed(Type handler) {
        return bypassedHandlers.contains(handler);
    }

    public static void clearAllBypasses() {
        bypassedHandlers.clear();
    }
    
    /*
	 *	@author Andre Calimlim
	 *	@description Invoke given trigger handler 
     *               Usage: in trigger code call like  TriggerManager.invoke(ContactTriggerHandler.class);
	 *	@param type handler to determine the class e.g ContactTriggerHandler class
	 */
    public static void invoke(Type type) {
        Trigger_Settings__c setup = Trigger_Settings__c.getInstance();
        if (setup != null && setup.Skip_All_Triggers__c) return;
        
        if(bypassedHandlers.contains(type)) return;
        
        Object handler = type.newInstance();
        if (handler instanceof ITriggerHandler) {
            if (setup != null && setup.Skip_Triggers__c) {
                Trigger_Handlers__c skipHandler = Trigger_Handlers__c.getInstance(type.toString());
                
                if (skipHandler != null) return;
            }
            
            ((ITriggerHandler) handler).invoke();
        }
        else {
            system.debug(LoggingLevel.ERROR, type + ' type doesn\'t extend TriggerHandler interface');
            throw new ExceptionsBundle.UnsupportedTriggerHandlerException('Custom Trigger Handler must extend TriggerHandler abstract class');
        }        
    }
    
    /*
	 *	@author Andre Calimlim
	 *	@description Provides common inteface for trigger handler
	 */
    public interface ITriggerHandler {
        void onBeforeInsert(List<sObject> newRecords);
    
        void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap);
        
        void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap);
        
        void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap);
        
        void onAfterUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap);
        
        void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap);
        
        void onAfterUndelete(List<sObject> newRecords, Map<ID, sObject> newRecordsMap);
        
        void invoke();
    }
}