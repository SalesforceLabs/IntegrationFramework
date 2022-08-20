@IsTest
public class Import_Mapping_Test {

    // Test that an exception is thrown when no mappings are found
    // The test is looking for mapping objects with the type: 'Test_Type' 
    // because of the Test_Type in the import message but no mapping records are created
    //@IsTest
    static void no_Mappings_Test(){
        // Create an import message
        List<Import_Message__c> importMessages = Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.xmlPayload);
        boolean exceptionThrown = false;
        try{
            // Get the mappings for the message type
            importMessages[0].Message_Type__c = 'TYPE_DOES_NOT_EXIST';
            Import_Mapping.getMappings(importMessages[0]);
        }
        catch (Exception e){
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'Exception should be thrown');
    }
    
    // Test that the mapping data is returned
    @IsTest
    static void return_Mappings_Test(){
        // Create the mapping data in memory as records cannot be created during a unit test
        Import_Mapping.mappingObjectsMDT = Import_Metadata_DataFactory_XML_Test.createLeadMappingObjectsAndFields();
        // Prevent querying mapping objects and use the provided mapping objects
        Import_Mapping.currentMessageType = 'Test_Type'; 
            
        // Create an import message
        List<Import_Message__c> importMessages = Import_ImportMessage_DataFactory_Test.create_ImportObject(Import_Payload_DataFactory_Test.xmlPayload);
        boolean exceptionThrown = false;
        try{
            // Get the mappings for the message type
            List<Mapping_Object__mdt> objectMappings = Import_Mapping.getMappings(importMessages[0]);
            System.assert(objectMappings.size() == 2, '2 mapping object should be returned. Actual ' + objectMappings.size());
        }
        catch (Exception e){
            exceptionThrown = true;
        }
        
        System.assert(!exceptionThrown, 'No Exception should be thrown');        
    }
}