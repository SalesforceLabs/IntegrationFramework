public class Import_XML_Service extends Import_Service_Base {
    
    // Import an XML file
    @TestVisible
    private List<sObject> processRecord(Import_Message__c importMessage){
        // Load the XML payload into the XML utility
        XPath xmlUtiltiy = new XPath(importMessage.Message_Payload__c);
        // Get all mappings for the import message and process the XML for each mapping object
        List<sObject> targetObjectsToSave = new List<sObject>();
        for (Mapping_Object__mdt mappingObject : Import_Mapping.getMappings(importMessage)){
            // Get all objects from the xml based on the payload node.
            // Normally 1 object is returned but with /cases/* an array of cases is returned
            Dom.XmlNode[] xmlValues = xmlUtiltiy.find(mappingObject.Message_Payload_Node__c);
            // Transform each object based on the mapping objects 
            for (Dom.XmlNode xmlNode : xmlValues){
                sObject objectToSave = mapXMLToObject(mappingObject, xmlUtiltiy, xmlNode);
                // If fields on the object where updated
                if (objectToSave != null){
                    targetObjectsToSave.add(objectToSave);
                }
            }            
        }
        
        return targetObjectsToSave;
    }
    
    // Based on the mapping objects and fields, create a Salesforce object based on the import message payload
    private sObject mapXMLToObject(Mapping_Object__mdt mappingObject, XPath xmlUtiltiy, Dom.XmlNode xmlNode) {

        Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get(mappingObject.Salesforce_Object__c);
        sObject targetSalesforceObjectInstance = targetSalesforceObjectType.newSObject();

        // Loop through all the mappings for the target object
        for(Mapping_Field__mdt fieldMapping : mappingObject.Mapping_Fields__r){
            Dom.XmlNode[] nodes = xmlUtiltiy.find(xmlNode, fieldMapping.Message_Payload_Node__c);
            // If a node was found (only 1 or none should be found)
            if (nodes.size() > 0){  
            	string xmlValue = xmlUtiltiy.getText(xmlNode, fieldMapping.Message_Payload_Node__c);    
				// Convert the value to the correct type
            	Object typedValue = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, xmlValue);
                targetSalesforceObjectInstance.put(fieldMapping.Salesforce_Field__c, typedValue); 
            }
                
            // Is_Collection__c 
            // Transformation_Classname__c 
        }
        
        // If no field have changed on the object Then return null
        if (targetSalesforceObjectInstance == targetSalesforceObjectType.newSObject()){
            return null;
        }
        
        return targetSalesforceObjectInstance;
    }
}