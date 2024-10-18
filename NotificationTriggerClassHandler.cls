public class NotificationTriggerHandler {
    public static void handleAfterInsertOrUpdate(List<Enrollment__c> enrollments) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Enrollment__c enrollment : enrollments) {
            // Check if the enrollment status is completed
            if (enrollment.Status__c == 'Completed') {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String studentEmail = enrollment.Student__r.Email__c;
                
                // Set email properties
                email.setToAddresses(new String[] { studentEmail });
                email.setSubject('Course Completed: ' + enrollment.Course__r.Name);
                email.setPlainTextBody('Congratulations! You have completed the course: ' + enrollment.Course__r.Name);

                emails.add(email);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}