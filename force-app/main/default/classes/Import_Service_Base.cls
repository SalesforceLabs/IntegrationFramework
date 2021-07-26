public abstract class Import_Service_Base implements IAPI_Service {
    
    public RestResponse execute(RestRequest request, RestResponse response){
        
        List<Import_Log__c> importLogs = new List<Import_Log__c>();
        Import_Logging importLog;
        Import_Message__c importMessage;
            
        try {
            // Validate the URL body
            validateRequestBody(request);
            
        	// Get all import messages from the request body
        	// The request body in JSON can contain an array of import messages under "records"    
            Map<String, Object> urlRequestBody = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            
            List<Object> arrayJSONRecords = (List<Object>) urlRequestBody.get('records');
			// Loop through all the records in the requestbody
            for (Object importMessageJSON : arrayJSONRecords) {
                // Change the import message from JSON to a MAP
                Map<String, Object> importMessageMap = (Map<String, Object>)importMessageJSON;
                // Validate that the import message contains the required fields
                validateRequestRecord(importMessageMap);
                
                // Create the import message object
                importMessage = new Import_Message__c();
                importMessage.Message_Payload__c = (string) importMessageMap.get('Message_Payload__c');
                importMessage.Message_Source_Id__c = (string) importMessageMap.get('Message_Source_Id__c');
                importMessage.Message_Source_System__c = (string) importMessageMap.get('Message_Source_System__c');
                importMessage.Message_Type__c = (string) importMessageMap.get('Message_Type__c');
                insert importMessage;
                
                // Process the import record and return the log message with the result
                List<sObject> objectsToSave = processRecord(importMessage);
                // Save the objects that were created for this import message
            	Database.UpsertResult[] saveResults = saveObjects(objectsToSave, importMessage);
                
                // Log the result
                importLog = new Import_logging(importMessage);
                importLog.logSuccess(saveResults, objectsToSave);
                importLogs.add(importLog.importLogObject);
            }
            
            // Return the result        
            response.statusCode = 200;
            response.responseBody = Blob.valueOf(importLog.importLogObject.Import_Log__c);            
        }
        catch(Exception e){
            // Log the exception but only if an import message was created.
            // Import Log has a master-detail with Import Message
            if (importMessage != null && importMessage.Id != null){
                importLog = new Import_logging(importMessage);
                importLog.logError(e);
                importLogs.add(importLog.importLogObject);                
            }
            
            System.debug('INT: ' + e.getMessage());
            System.debug('INT: ' + e.getStackTraceString()); 

            response.statusCode = 500;
            response.responseBody = Blob.valueOf(e.getMessage());            
        }
        finally {
            // Save the log files
            // Example why finally: URL body contains 10 records. 8 records where saved correctly.
            // 9th record caused an undhandled exception. The logging for these 8 successful
            // records needs to be saved.
            insert importLogs;
        }
        
        return response;
    }
    
    // Throw an exception when the url body is not correct
    private static void validateRequestBody(RestRequest request){
        string urlRequestBody = RestContext.request.requestBody.toString();
        
        boolean isJSONValid = true; 
        try {
            // Check if the URL body is JSON
            JSON.deserializeUntyped(urlRequestBody);
        } 
        catch (Exception e) {
            isJSONValid = false;
        }  
        
        if (!isJSONValid && !urlRequestBody.contains('records')){
        	throw new Import_Exceptions.RequestBody_Exception('Request body is not correct');
        }
    }
    
    // Throw an exception when a record does not contain the required fields
    private static void validateRequestRecord(Map<String, Object> requestBody){
        if (!(requestBody.containsKey('Message_Source_System__c') && 
              requestBody.containsKey('Message_Type__c') &&
              requestBody.containsKey('Message_Source_Id__c') &&
              requestBody.containsKey('Message_Type__c'))){
            throw new Import_Exceptions.RequestBody_Exception('Request record is not correct');
        }
    }
    
    // This method does the actual processing of the message
    private abstract List<sObject> processRecord(Import_Message__c importMessage);

    // Save the mapping objects in the database.
    private Database.UpsertResult[] saveObjects(List<sObject> recordsToSave, Import_Message__c importMessage){
        
        // Get all maping objects that are active and that are for the same
        // message type as the import message
        List<Mapping_Object__mdt> mappingObjects = Import_Mapping.getMappings(importMessage);
        Database.UpsertResult[] saveResults = new List<Database.UpsertResult>();
        // Loop through mapping objects
        for (Mapping_Object__mdt mappingObject : mappingObjects) {
            List<sObject> subsetRecordsToSave = new List<sObject>();
            // Get all Salesforce objects to save for the mapping object
            // Database.Upsert can only save one object type.
        	// Group one object type so that ot can be saved.
            for (sObject recordToSave : recordsToSave){
                string objectType = String.valueOf(recordToSave.getSObjectType());
                if (objectType == mappingObject.Salesforce_Object__c){
                    subsetRecordsToSave.add(recordToSave);
                }                
            }
            
            // If there are records to save
            If (subsetRecordsToSave.size() > 0) {
                // Save the subset of objects
	        	Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{mappingObject.Salesforce_Object__c});
    	    	Schema.SObjectField externalField = descResult[0].fields.getMap().get(mappingObject.Salesforce_External_Id_Field__c);
                Database.UpsertResult[] objectSaveResult = Database.Upsert(subsetRecordsToSave, externalField, false); 
                saveResults.addAll(objectSaveResult);
            }
        }
          
        return saveResults;            
    }
}