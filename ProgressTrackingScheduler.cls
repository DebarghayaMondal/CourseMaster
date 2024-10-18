global class UpdateProgressTrackingScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        updateProgressTracking();
    }
    public void updateProgressTracking(){
        List<Progress_Tracking__c> progressToUpdate = new List<Progress_Tracking__c>();
        
        // Fetch all enrollments
        List<Enrollment__c> enrollments = [SELECT Id,Student__c, Enrollment_Date__c, Course__r.Course_Duration__c FROM Enrollment__c];
        
        for (Enrollment__c enrollment : enrollments) {
            if (enrollment.Enrollment_Date__c != null && enrollment.Course__r.Course_Duration__c != null) {
                Integer daysPassed = Date.today().daysBetween(enrollment.Enrollment_Date__c);
                Decimal totalDuration = enrollment.Course__r.Course_Duration__c;
                Decimal completionPercentage;
                // Calculate completion percentage
                if (daysPassed>totalDuration){
                    completionPercentage = 100;
                }
                else if (Date.today()<enrollment.Enrollment_Date__c){
                    completionPercentage = 0;
                }
                else{
                	completionPercentage = (daysPassed / totalDuration) * 100;                    
                }
                
                // Prepare the progress tracking record to update
                Progress_Tracking__c progressTracking = new Progress_Tracking__c();
                progressTracking.Course__c = enrollment.Course__c;
                progressTracking.Student__c = enrollment.Student__c;
                progressTracking.Completion_Percentage__c = completionPercentage.setScale(2, RoundingMode.HALF_UP);
                progressTracking.Last_Updated__c = System.now();

                progressToUpdate.add(progressTracking);
            }
        }

        // Update progress tracking records
        if (!progressToUpdate.isEmpty()) {
            insert progressToUpdate;
        }
    }
}