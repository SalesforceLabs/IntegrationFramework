global with sharing class Import_Cleanup_Batch implements Database.Batchable<sObject>, Schedulable {
    
    // Get all records that need to be deleted that are older then 4 weeks
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id ' +
            'FROM IntServ__Import_Message__c  ' +
            'WHERE CreatedDate < LAST_N_Weeks:4'
        );
    }
    
    // Delete the import messages that
    global void execute(Database.BatchableContext bc, List<IntServ__Import_Message__c> records){
        delete records;
    }
    
    // Reschedule the batch to run again next sunday
    global void finish(Database.BatchableContext bc){
        Import_Cleanup_Batch batch = new Import_Cleanup_Batch();
		String cronSchedule = '0 0 21 ? * SUN';
    }
    
    // When the schedule fires the batch is started 
    global void execute(SchedulableContext SC) {
    	database.executebatch(new Import_Cleanup_Batch());            
   	}
}