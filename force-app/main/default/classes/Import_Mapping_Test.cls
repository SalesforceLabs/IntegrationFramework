@IsTest
public class Import_Mapping_Test {

    // Test that an exception is thrown when no mappings are found
    // The test is looking for mapping objects with the type: 'TestType' 
    // because of the TestType in the import message
    @IsTest
    static void no_Mappings_Test(){
        // Create an import message
        List<Import_Message__c> importMessages = Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.xmlPayload);
        boolean exceptionThrown = false;
        try{
            // Get the mappings for the message type
            Import_Mapping.getMappings(importMessages[0]);
        }
        catch (Exception e){
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'Exception should be thrown');
    }
    
    @IsTest
    static void return_Mappings_Test(){
        // Create an import message
        List<Import_Message__c> importMessages = Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.xmlPayload);
        boolean exceptionThrown = false;
        try{
            // Get the mappings for the message type
            Import_Mapping.currentMessageType = 'Test_Type';
            Import_Mapping.mappingObjectsMDT = Import_Metadata_DataFactory_JSON_Test.createLeadMappingObjectsAndFields();
            List<Mapping_Object__mdt> objectMappings = Import_Mapping.getMappings(importMessages[0]);
            System.assert(objectMappings.size() == 4, '4 mapping object should be returned. Actual ' + objectMappings.size());
        }
        catch (Exception e){
            exceptionThrown = true;
        }
        
        System.assert(!exceptionThrown, 'No Exception should be thrown');        
    }
}