trigger LeadTrigger on Lead__c (before insert, after insert, after update, after delete) {
    TriggerManager.invoke(LeadTriggerHandler.class);
}