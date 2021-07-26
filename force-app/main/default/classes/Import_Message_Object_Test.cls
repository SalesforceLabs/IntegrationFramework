@IsTest
public class Import_Message_Object_Test {
    
    // Test that the formula field shows the correct status based 
    // on the log files linked to the object
	@IsTest
    static void last_Import_Successful_Test() {
        // Setup test data
        List<Import_Message__c> importObjects = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        Import_TestLogMessageDataFactory.create_one_ImportLogObject(importObjects, true);
        
        // Get the import objects to get the correct value for the formula fields
        importObjects = [SELECT Id, IntServ__Last_Import_Successful__c FROM Import_Message__c];
        System.assert(importObjects[0].IntServ__Last_Import_Successful__c == true, 'Import status should be true. Actual ' + importObjects[0].IntServ__Last_Import_Successful__c);
    }
    
    // Test that the formula field shows the correct status based 
    // on the log files linked to the object
	@IsTest
    static void last_Import_Unsuccessful_Test() {
        // Setup test data
        List<Import_Message__c> importObjects = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        Import_TestLogMessageDataFactory.create_one_ImportLogObject(importObjects, false);
        
        // Get the import objects to get the correct value for the formula fields
        importObjects = [SELECT Id, IntServ__Last_Import_Successful__c FROM Import_Message__c];
        System.assert(importObjects[0].IntServ__Last_Import_Successful__c == false, 'Import status should be true. Actual ' + importObjects[0].IntServ__Last_Import_Successful__c);
    }
    
    // Test that the formula field shows the correct status based 
    // when the import object has multiple log files. Latest one successful other one unsuccseful.
	@IsTest
    static void multiple_with_last_Import_Successful_Test() {
        // Setup test data
        List<Import_Message__c> importObjects = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        Import_TestLogMessageDataFactory.create_two_ImportLogObject(importObjects, true);
        
        // Get the import objects to get the correct value for the formula fields
        importObjects = [SELECT Id, IntServ__Last_Import_Successful__c FROM Import_Message__c];
        System.assert(importObjects[0].IntServ__Last_Import_Successful__c == true, 'Import status should be true. Actual ' + importObjects[0].IntServ__Last_Import_Successful__c);
    }
    
        // Test that the formula field shows the correct status based 
    // on the log files linked to the object
	@IsTest
    static void multiple_with_last_Import_Unsuccessful_Test() {
        // Setup test data
        List<Import_Message__c> importObjects = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        Import_TestLogMessageDataFactory.create_two_ImportLogObject(importObjects, false);
        
        // Get the import objects to get the correct value for the formula fields
        importObjects = [SELECT Id, IntServ__Last_Import_Successful__c FROM Import_Message__c];
        System.assert(importObjects[0].IntServ__Last_Import_Successful__c == false, 'Import status should be true. Actual ' + importObjects[0].IntServ__Last_Import_Successful__c);
    }
}