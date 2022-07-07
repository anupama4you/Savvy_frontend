trigger AttachmentTrigger on Attachment (after insert, before delete) {
    TriggerManager.invoke(AttachmentTriggerHandler.class);
}