@Istest
public class Import_LogMessage_DataFactory_Test {
    
    // Create one log message for each import object
    // All log fields will get the status: logFileStatus
    public static List<Import_Log__c> create_one_ImportLogObject(List<Import_Message__c> importObjects, boolean logFileStatus) {

        List<Import_Log__c> importLogObjects = new List<Import_Log__c>();
        for (Import_Message__c importObject : importObjects) {
            Import_Log__c importLogObject = new Import_Log__c();
            importLogObject.Import_Message__c = importObject.Id;
            importLogObject.Import_Started_DateTime__c = DateTime.now().addMinutes(-2);
            importLogObject.Import_Finished_DateTime__c = DateTime.now().addMinutes(-1);
            importLogObject.Import_Log__c = 'Done';
            importLogObject.Import_Is_Successful__c = logFileStatus;
            importLogObjects.add(importLogObject);
        }
        insert importLogObjects;
        
        return importLogObjects;
    }
    
    // Create two log message for each import object
    // The parameter latestLogFileStatus indicates the status of the latest log file. 
    // The second log file will get the opposite status
    public static List<Import_Log__c> create_two_ImportLogObject(List<Import_Message__c> importObjects, boolean latestLogFileStatus) {
            
        List<Import_Log__c> importLogObjects = new List<Import_Log__c>();
        for (Import_Message__c importObject : importObjects) {
            Import_Log__c importLogObject = new Import_Log__c();
            importLogObject.Import_Message__c = importObject.Id;
            importLogObject.Import_Started_DateTime__c = DateTime.now().addMinutes(-4);
            importLogObject.Import_Finished_DateTime__c = DateTime.now().addMinutes(-3);
            importLogObject.Import_Log__c = 'Done';
            importLogObject.Import_Is_Successful__c = !latestLogFileStatus;
            importLogObjects.add(importLogObject);

            importLogObject = new Import_Log__c();
            importLogObject.Import_Message__c = importObject.Id;
            importLogObject.Import_Started_DateTime__c = DateTime.now().addMinutes(-2);
            importLogObject.Import_Finished_DateTime__c = DateTime.now().addMinutes(-1);
            importLogObject.Import_Log__c = 'Done';
            importLogObject.Import_Is_Successful__c = latestLogFileStatus;
            importLogObjects.add(importLogObject);
        }
        insert importLogObjects;
        
        return importLogObjects;
    } 
}