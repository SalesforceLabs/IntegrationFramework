public class Import_JSON_Service extends Import_Service_Base {
    
    // Import a JSON file
    @TestVisible
    private List<sObject> processRecord(Import_Message__c importMessage){
        // Convert the import message JSON payload into an object
        Object mainJSONObject = JSON.deserializeUntyped(importMessage.Message_Payload__c);
        // Get all mappings for the import message and process the JSON for each mapping object
        List<sObject> targetObjectsToSave = new List<sObject>();
        for (Mapping_Object__mdt mappingObject : Import_Mapping.getMappings(importMessage)){
            // Get all objects from the JSON based on the payload node.
            // Normally 1 object is returned but with root.cases an array of cases is returned  
            List<Object> jsonObjects = find(mainJSONObject, mappingObject.Message_Payload_Node__c);
            // Transform each object based on the mapping objects
            for (Object jsonObject : jsonObjects){
                sObject objectToSave = mapJSONToObject(mappingObject, (Map<String, Object>)jsonObject);
                // If fields on the object where updated
                if (objectToSave != null){
                    targetObjectsToSave.add(objectToSave);
                }
            }
        }
        
        return targetObjectsToSave;
    }
    
    // Based on the mapping objects and fields, create a Salesforce object based on the import message payload
    private static sObject mapJSONToObject(Mapping_Object__mdt mappingObject, Map<String, Object> jsonObject){
        // Create the target Salesforce object
        Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get(mappingObject.Salesforce_Object__c);
		Schema.DescribeSObjectResult targetObjectDescription = targetSalesforceObjectType.getDescribe();
        sObject targetSalesforceObjectInstance = targetSalesforceObjectType.newSObject();

        // Loop through all the field mappings
        for(Mapping_Field__mdt fieldMapping : mappingObject.Mapping_Fields__r){
            Object value = jsonObject.get(fieldMapping.Message_Payload_Node__c);
			// Convert the value to the correct type
			Object typedValue = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, value);
            targetSalesforceObjectInstance.put(fieldMapping.Salesforce_Field__c, typedValue); 
        
            // Is_Collection__c 
        	// Transformation_Classname__c 
        }    
        
        // If no field have changed on the object Then return null
        if (targetSalesforceObjectInstance == targetSalesforceObjectType.newSObject()){
            return null;
        }

        return targetSalesforceObjectInstance;
    }

    // Get the object node from the main JSON object and
    // return the found object or a list of objects
    private List<Object> find(Object mainJSONObject, String rootNode){
        List<Object> objectsToReturn = new List<Object>();
        Object foundJSONObject = ((Map<String, Object>)mainJSONObject).get(rootNode);
		// If the mapping object node was not found retrun the main node as an object or a list of objects
        if (foundJSONObject == null){
            foundJSONObject = mainJSONObject;
        }

        // Map the mapping node to an object or list
        // Example: Mapping object node = cases,  JSON is {"name":"Jason"}
        // Returned: {"name":"Jason"}
        // Example: Mapping object node = cases,  JSON is {"name":"Jason", "cases": [{"name":"Jason"}]}
        // Returned: [{"name":"Jason"}]        
        if (foundJSONObject instanceof List<Object>) {
            objectsToReturn = (List<Object>) foundJSONObject;
        }
        else {
            objectsToReturn.add(foundJSONObject);
        }            
                
        return objectsToReturn;
    }
}