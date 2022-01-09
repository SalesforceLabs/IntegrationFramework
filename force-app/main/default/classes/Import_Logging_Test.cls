@istest
public class Import_Logging_Test {

    // Test a success log message 
    @istest
    public static void logSuccess_Test(){
        // Setup test data
        List<Account> recordsToSave = new List<Account>();
        recordsToSave.add(new Account(name = 'TEST'));
        List<Database.UpsertResult> saveResults = Database.Upsert(recordsToSave, Account.Id, false);
        
        Import_Logging importLog = createBasicLogMessage();
        importLog.logSuccess(saveResults, recordsToSave);
        System.assert(importLog.importLogObject.Import_Is_Successful__c == true, 'Successful should be true. Actual ' + importLog.importLogObject.Import_Is_Successful__c);
        System.assert(importLog.importLogObject.Import_Finished_DateTime__c != null, 'Finished date should not be null. Actual ' + importLog.importLogObject.Import_Finished_DateTime__c);
        System.assert(importLog.importLogObject.Import_Message__c != null, 'Log should be linked to an import message. Actual ' + importLog.importLogObject.Import_Message__c);
    }
    
    // Test a error log message
    @istest
    public static void logError_Test(){
        // Setup test data
        List<Account> recordsToSave = new List<Account>();
        recordsToSave.add(new Account(name = 'TEST'));
        Database.Upsert(recordsToSave, Account.Id, false);
        Import_Exceptions.API_Exception importAPIException = new Import_Exceptions.API_Exception('TEST');

        Import_Logging importLog = createBasicLogMessage();
        importLog.logError(importAPIException);
        System.assert(importLog.importLogObject.Import_Is_Successful__c == false, 'Successful should be false. Actual ' + importLog.importLogObject.Import_Is_Successful__c);
        System.assert(importLog.importLogObject.Import_Finished_DateTime__c != null, 'Finished should not be null. Actual ' + importLog.importLogObject.Import_Finished_DateTime__c);
        System.assert(importLog.importLogObject.Import_Log__c.contains('TEST'), 'message should contain TEST. Actual ' + importLog.importLogObject.Import_Log__c);
        System.assert(importLog.importLogObject.Import_Message__c != null, 'Log should be linked to an import message. Actual ' + importLog.importLogObject.Import_Message__c);
    }
    
    // Test that UpsertResult logs correctly 
    @istest 
    public static void logSaveResult_Test(){
        // Setup test data
        List<Account> recordsToSave = new List<Account>();
        recordsToSave.add(new Account(name = 'TEST'));
		
		// Test insert account
        List<Database.UpsertResult> saveResults = Database.Upsert(recordsToSave, Account.Id, false);
        Import_Logging importLog = createBasicLogMessage();
        importLog.logSuccess(saveResults, recordsToSave);
        System.assert(importLog.importLogObject.Import_Is_Successful__c == true, 'Successful should be true. Actual ' + importLog.importLogObject.Import_Is_Successful__c);
        System.assert(importLog.importLogObject.Import_Log__c.contains('Created'), 'message should contain Created. Actual ' + importLog.importLogObject.Import_Log__c);
        System.assert(!importLog.importLogObject.Import_Log__c.contains('Error'), 'message should not contain Error. Actual ' + importLog.importLogObject.Import_Log__c);

        // Test update account
        Account updateAccount = [SELECT Id, Name FROM Account LIMIT 1];
        updateAccount.name = 'TEST2';
        recordsToSave = new List<Account>();
        recordsToSave.add(updateAccount);
        saveResults = Database.Upsert(recordsToSave, Account.Id, false);
        importLog.logSuccess(saveResults, recordsToSave);
        System.assert(importLog.importLogObject.Import_Is_Successful__c == true, 'Successful should be true. Actual ' + importLog.importLogObject.Import_Is_Successful__c);
        System.assert(importLog.importLogObject.Import_Log__c.contains('Updated'), 'message should contain Created. Actual ' + importLog.importLogObject.Import_Log__c);
        System.assert(!importLog.importLogObject.Import_Log__c.contains('Error'), 'message should not contain Error. Actual ' + importLog.importLogObject.Import_Log__c);

		// Test Error
        updateAccount = [SELECT Id, Name FROM Account LIMIT 1];
        updateAccount.name = null;
        recordsToSave = new List<Account>();
        recordsToSave.add(updateAccount);
        saveResults = Database.Upsert(recordsToSave, Account.Id, false);
        importLog.logSuccess(saveResults, recordsToSave);
        System.assert(importLog.importLogObject.Import_Is_Successful__c == false, 'Successful should be false. Actual ' + importLog.importLogObject.Import_Is_Successful__c);
        System.assert(importLog.importLogObject.Import_Log__c.contains('Error'), 'message should contain Error. Actual ' + importLog.importLogObject.Import_Log__c);
    }
    
    // Create a basic log message
    private static Import_Logging createBasicLogMessage(){
        List<Import_Message__c> importMessages = Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.xmlPayload);
        return new Import_Logging(importMessages[0]);
    }
}