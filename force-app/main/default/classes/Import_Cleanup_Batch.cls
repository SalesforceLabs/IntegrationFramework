public with sharing class Import_Cleanup_Batch implements Database.Batchable<sObject>, Schedulable {
    
    // Get all records that need to be deleted that are older then 4 weeks
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id ' +
            'FROM IntServ__Import_Message__c  ' +
            'WHERE CreatedDate < LAST_N_Weeks:4'
        );
    }
    
    // Delete the import messages that
    public void execute(Database.BatchableContext bc, List<IntServ__Import_Message__c> records){
        // If the running user is allowed to delete IntServ__Import_Message__c records
        if (Schema.sObjectType.IntServ__Import_Message__c.isDeletable()) {
        	delete records;
        }
    }
    
    // Reschedule the batch to run again next sunday
    public void finish(Database.BatchableContext batchableContext){
        // Prevent unit tests from scheduling the job to prevent error "Job already exists"
        if (!Test.isRunningTest()){
            String cronSchedule = '0 0 21 ? * SUN';
            system.schedule('Import_Cleanup_Batch', cronSchedule, new Import_Cleanup_Batch());                    
        }
    }
    
    // When the schedule fires the batch is started 
    public void execute(SchedulableContext schedulableContext) {
    	database.executebatch(new Import_Cleanup_Batch());            
   	}
}