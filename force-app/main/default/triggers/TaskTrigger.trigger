trigger TaskTrigger on Task (after insert) {
    TriggerManager.invoke(TaskTriggerHandler.class);
}