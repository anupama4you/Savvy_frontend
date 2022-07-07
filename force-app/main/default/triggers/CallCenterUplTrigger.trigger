trigger CallCenterUplTrigger on Call_Center_Upl__c (after insert) {
    TriggerManager.invoke(CallCenterUplTriggerHandler.class);
}