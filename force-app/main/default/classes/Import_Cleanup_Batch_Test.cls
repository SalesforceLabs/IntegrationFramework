@IsTest
public class Import_Cleanup_Batch_Test {
	
    @TestSetup
    public static void setup(){
        // Create import records
        Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.jsonPayload);
    } 
    
    @IsTest
    public static void runBatchJobNoChanges_Test(){
        List<IntServ__Import_Message__c> importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 1, 'Expected 1. Actual ' + importRecords.size());
        
        Test.startTest();
        database.executebatch(new Import_Cleanup_Batch());
        Test.stopTest();
        
        // No records should have been deleted
        importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 1, 'Expected 1. Actual ' + importRecords.size());
    }

    @IsTest
    public static void runBatchJobChanges_Test(){
        // Set the created date of the import records back so they will be executed by the batch
        List<IntServ__Import_Message__c> importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 1, 'Expected 1. Actual ' + importRecords.size());
        Test.setCreatedDate(importRecords[0].Id, Date.today().addMonths(-2));
        update importRecords;
        
        Test.startTest();
        database.executebatch(new Import_Cleanup_Batch());
        Test.stopTest();
        
        // All import records should have been deleted
        importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 0, 'Expected 0. Actual ' + importRecords.size());
    }
    
    @IsTest
    public static void rescheduleBatchJob_Test(){
        Test.startTest();
        database.executebatch(new Import_Cleanup_Batch());
       
        // Check that the batch job is scheduled
        System.assertEquals(1, [SELECT COUNT()
                                FROM AsyncApexJob
                                WHERE ApexClassId IN (SELECT Id FROM ApexClass 
                                                      WHERE NamespacePrefix = 'IntServ' AND Name = 'Import_Cleanup_Batch')],
                            'Batch job should be scheduled');
   
     	Test.stopTest(); 
    }
    
    @IsTest
    public static void run_ScheduleBatchJob_Test(){
        // Set the created date of the import records back so they will be executed by the batch
        List<IntServ__Import_Message__c> importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 1, 'Expected 1. Actual ' + importRecords.size());
        Test.setCreatedDate(importRecords[0].Id, Date.today().addMonths(-2));
        update importRecords;
        
		Test.StartTest();
		String cronSchedule = '0 0 21 ? * SUN';
        Import_Cleanup_Batch cleanupBatch = new Import_Cleanup_Batch();
        String jobId = system.schedule('TEST Run Schedule', cronSchedule, cleanupBatch); 

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :jobId];
        
        // Verify the scheduled time is correct
        System.assertEquals(cronSchedule, ct.CronExpression, 'Scheduled time is not ' + cronSchedule);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered, 'Schedule did not run');
        
        // Start the schedule execute (not started automaticly by stopTest)
        cleanupBatch.execute(null);
        
        Test.stopTest(); 

        // All import records should have been deleted
        importRecords = [SELECT Id FROM IntServ__Import_Message__c];
        System.assert(importRecords.size() == 0, 'Expected 0. Actual ' + importRecords.size());
    }
}