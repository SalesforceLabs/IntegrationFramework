public with sharing class Import_JSON_Service extends Import_Service_Base {
    
    // Import a JSON file
    @TestVisible
    private List<sObject> processRecord(Import_Message__c importMessage){
        // Convert the import message JSON payload into an object
        Object mainJSONObject = JSON.deserializeUntyped(importMessage.Message_Payload__c);
        // Get all mappings for the import message and process the JSON for each mapping object
        List<sObject> targetObjectsToSave = new List<sObject>();
        for (Mapping_Object__mdt mappingObject : Import_Mapping.getMappings(importMessage)){
            // Get all objects from the JSON based on the payload node.
            // The specified root node can be 1 object or a collection of objects  
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
    private sObject mapJSONToObject(Mapping_Object__mdt mappingObject, Map<String, Object> jsonObject){
        // Create the target Salesforce object
        Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get(mappingObject.Salesforce_Object__c);
		sObject targetSalesforceObjectInstance = targetSalesforceObjectType.newSObject();

        // Loop through all the field mappings
        for(Mapping_Field__mdt fieldMapping : mappingObject.Mapping_Fields__r){
            Object jsonValue = jsonObject.get(fieldMapping.Message_Payload_Node__c);
            // if the key is not found, the map returns null that value does not need to be converted
            if (jsonValue == null){
                continue;
            }
            
            Object value = getValue(fieldMapping, jsonValue, targetSalesforceObjectType);
            targetSalesforceObjectInstance.put(fieldMapping.Salesforce_Field__c, value);                             
        }    
        
        // If nothing has been updated on the object then return null 
        // so that the unchanged object is not added to the list of objects that will be saved.
        if (targetSalesforceObjectInstance == targetSalesforceObjectType.newSObject()){
           	return null;
        }

        return targetSalesforceObjectInstance;
    }
    
    // Get the value from the node
    // If the node is a colltion of values then concatenate the values
    private Object getValue(Mapping_Field__mdt fieldMapping, Object jsonValue, Schema.SObjectType targetSalesforceObjectType){
		Object value;
        // If not a collection then transform the single field
        if (!fieldMapping.IntServ__Is_Collection__c){
            // Convert the value to the correct type
            value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, jsonValue);
        }
        else { // the node contains a list of value
            String collectionValues = '';  
            List<Object> valueObjects = (List<Object>)jsonValue;
            // Get all value elements
            for (Object valueObject : valueObjects){
                Map<String, Object> valueObjectMap = (Map<String, Object>)valueObject;
                
                Object typedValue = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, valueObjectMap.get('value'));
                collectionValues += (collectionValues != '') ? ';' : '';
                collectionValues += typedValue;                                
            }
            value = collectionValues;
        }
		return value;
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