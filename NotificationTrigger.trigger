trigger NotificationTrigger on Enrollment__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        NotificationTriggerHandler.handleAfterInsertOrUpdate(Trigger.new);
    }
}