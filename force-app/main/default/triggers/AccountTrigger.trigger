trigger AccountTrigger on Account (after insert, after update, before insert, before update) {
    TriggerManager.invoke(AccountTriggerHandler.class);
}