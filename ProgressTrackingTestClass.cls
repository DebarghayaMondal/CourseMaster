@isTest
private class UpdateProgressTrackingSchedulerTest {

    @isTest
    static void testUpdateProgressTracking() {
        // Create test Course record
        Course__c testCourse = new Course__c(
            Name = 'Test Course',
            Course_Fee__c = 100,
            Start_Date__c = Date.today().addDays(-10), 
            End_Date__c = Date.today().addDays(10),
            Course_Code__c = '103', 
            Status__c = 'Active'
        );
        insert testCourse;

        // Create test Student record
        Student__c testStudent = new Student__c(
            Name = 'Test Student',
            Date_of_Birth__c = Date.today().addYears(-20),
            Email__c = 'teststudent@example.com',
            Phone_Number__c = '123-456-7890'
        );
        insert testStudent;

        // Create test Enrollment record
        Enrollment__c enrollment = new Enrollment__c(
            Course__c = testCourse.Id,
            Student__c = testStudent.Id,
            Enrollment_Date__c = Date.today().addDays(-5),
            Status__c = 'Enrolled', 
            Payment_Verification__c = 'Pending'
        );
        insert enrollment;

        // Schedule the update
        Test.startTest();
        String jobId = System.schedule('Test Update Progress Tracking Job', '0 0 0 * * ?', new UpdateProgressTrackingScheduler());
        Test.stopTest();

        // Verify that the Progress Tracking record is created/updated
        List<Progress_Tracking__c> progressTrackings = [SELECT Id, Completion_Percentage__c, Course__c, Student__c 
                                                         FROM Progress_Tracking__c 
                                                         WHERE Course__c = :testCourse.Id AND Student__c = :testStudent.Id];

        // Verify the result
        System.assertEquals(1, progressTrackings.size(), 'There should be at least one progress tracking record.');
    }
}