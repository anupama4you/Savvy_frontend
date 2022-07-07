trigger RequiredDocTrigger on Required_Document__c (after delete) {
  TriggerManager.invoke(RequiredDocTriggerHandler.class);
}