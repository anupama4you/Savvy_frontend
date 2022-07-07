trigger ApplicationTrigger on Application__c (after insert, after update, before insert) {
    TriggerManager.invoke(ApplicationTriggerHandler.class);
}