@IsTest
public class Import_JSON_Service_Test {
    
    // Test the processing of a JSON message
	@IsTest
    static void processRecord_Test(){
        // Get the mappings for the message type
        Import_Mapping.currentMessageType = 'TestType';
        Import_Mapping.mappingObjectsMDT = Import_TestMetadataFactory.createLeadMappingObjectsAndFields_JSON();
        List<Import_Message__c> importMessages = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.jsonPayload);
        
        Import_JSON_Service jsonImportService = new Import_JSON_Service();
        List<sObject> objectsToSave = jsonImportService.processRecord(importMessages[0]);
        
        System.assert(objectsToSave.size() == 5, 'Expected 5 object to save. Actual ' + objectsToSave.size());
        System.assert(objectsToSave[0].getSObjectType() == Schema.Lead.getSObjectType(), 'Expected Lead object. Actual ' + objectsToSave[0].getSObjectType());
        System.assert(objectsToSave[0].get('FirstName') == 'Clark', 'Expected FirstName = Clark. Actual ' + objectsToSave[0].get('FirstName'));
        System.assert(objectsToSave[0].get('LastName') == 'Kent', 'Expected LastName = Kent. Actual ' + objectsToSave[0].get('LastName'));
        System.assert(objectsToSave[0].get('DoNotCall') == true, 'Expected DoNotCall = true. Actual ' + objectsToSave[0].get('DoNotCall'));
        System.assert(objectsToSave[0].get('NumberOfEmployees') == 75, 'Expected NumberOfEmployees = 75. Actual ' + objectsToSave[0].get('NumberOfEmployees'));
        System.assert(objectsToSave[0].get('AnnualRevenue') == 1000000.50, 'Expected AnnualRevenue = 1000000.50. Actual ' + objectsToSave[0].get('AnnualRevenue'));

        System.assert(objectsToSave[1].getSObjectType() == Schema.Case.getSObjectType(), 'Expected Case object. Actual ' + objectsToSave[1].getSObjectType());
        System.assert(objectsToSave[1].get('Subject') == '10', 'Expected Subject = 10. Actual ' + objectsToSave[1].get('Subject'));
        System.assert(objectsToSave[1].get('Origin') == 'Email', 'Expected Origin = Email. Actual ' + objectsToSave[1].get('Origin'));

        System.assert(objectsToSave[2].getSObjectType() == Schema.Case.getSObjectType(), 'Expected Case object. Actual ' + objectsToSave[1].getSObjectType());
        System.assert(objectsToSave[2].get('Subject') == '11', 'Expected Subject = 11. Actual ' + objectsToSave[1].get('Subject'));
        System.assert(objectsToSave[2].get('Origin') == 'Email', 'Expected Origin = Email. Actual ' + objectsToSave[1].get('Origin'));

        System.assert(objectsToSave[3].getSObjectType() == Schema.Event.getSObjectType(), 'Expected Event object. Actual ' + objectsToSave[2].getSObjectType());
      
        System.assert(objectsToSave[4].getSObjectType() == Schema.Opportunity.getSObjectType(), 'Expected Opportunity object. Actual ' + objectsToSave[3].getSObjectType());
    }

    // Test the processing of an xml message through a JSON service throws an exception
	@IsTest
    static void processRecord_Not_JSON_Exception_Test(){
        List<Import_Message__c> importMessages = Import_TestMessageDataFactory.create_ImportObject(Import_TestPayloadDataFactory.xmlPayload);
        
        Import_JSON_Service jsonImportService = new Import_JSON_Service();
        boolean exceptionThrown = false;
        try {
            jsonImportService.processRecord(importMessages[0]);
        }
        catch (Exception e){
            exceptionThrown = true;
            System.assert(e.getTypeName() == 'System.JSONException', 'Excpetion should be "System.JSONException". Actual ' + e.getTypeName());
        }
        System.Assert(exceptionThrown, 'Exception should be thrown');
    }    
}