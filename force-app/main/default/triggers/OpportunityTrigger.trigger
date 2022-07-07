trigger OpportunityTrigger on Custom_Opportunity__c (after insert, after update, before insert, before update) {
    TriggerManager.invoke(OpportunityTriggerHandler.class);
}