@IsTest
public class Import_XML_Service_Test {

    // Test the processing of an XML message
	@IsTest
    static void processRecord_Test(){
        // Get the mappings for the message type
        Import_Mapping.currentMessageType = 'TestType';
        Import_Mapping.mappingObjectsMDT = Import_TestMetadataFactory.createLeadMappingObjectsAndFields_XML();
        List<Import_Message__c> importMessages = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        
        Import_XML_Service xmlImportService = new Import_XML_Service();
        List<sObject> objectsToSave = xmlImportService.processRecord(importMessages[0]);
        
        System.assert(objectsToSave.size() == 3, 'Expected 3 objects to save. Actual ' + objectsToSave.size());
        System.assert(objectsToSave[0].getSObjectType() == Schema.Lead.getSObjectType(), 'Expected Lead object to save. Actual ' + objectsToSave[0].getSObjectType());
        System.assert(objectsToSave[1].getSObjectType() == Schema.Case.getSObjectType(), 'Expected Case object to save. Actual ' + objectsToSave[1].getSObjectType());
        System.assert(objectsToSave[2].getSObjectType() == Schema.Case.getSObjectType(), 'Expected Case object to save. Actual ' + objectsToSave[1].getSObjectType());
    }

    // Test the processing of a JSON message through a XML service throws an exception
	@IsTest
    static void processRecord_Exception_Test(){
        List<Import_Message__c> importMessages = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.jsonPayload);
        
        Import_XML_Service xmlImportService = new Import_XML_Service();
        boolean exceptionThrown = false;
        try {
            xmlImportService.processRecord(importMessages[0]);
        }
        catch (Exception e){
            exceptionThrown = true;
            System.assert(e.getTypeName() == 'System.XMLException', 'Excpetion should be "System.XMLException". Actual ' + e.getTypeName());
        }
        System.Assert(exceptionThrown, 'Exception should be thrown');
    }
}