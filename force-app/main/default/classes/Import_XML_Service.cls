public with sharing class Import_XML_Service extends Import_Service_Base {
    
    private XPath xmlUtiltiy;
    
    // Import an XML file
    @TestVisible
    private List<sObject> processRecord(Import_Message__c importMessage){
        // Load the XML payload into the XML utility
        xmlUtiltiy = new XPath(importMessage.Message_Payload__c);
        // Get all mappings for the import message and process the XML for each mapping object
        List<sObject> targetObjectsToSave = new List<sObject>();
        for (Mapping_Object__mdt mappingObject : Import_Mapping.getMappings(importMessage)){
            // Get all objects from the XML based on the payload node.
            // The specified root node can be 1 object or a collection of objects  
            Dom.XmlNode[] xmlValues = xmlUtiltiy.find(mappingObject.Message_Payload_Node__c);
            // Transform each object based on the mapping objects 
            for (Dom.XmlNode xmlNode : xmlValues){
                sObject objectToSave = mapXMLToObject(mappingObject, xmlNode);
                // If fields on the object where updated
                if (objectToSave != null){
                    targetObjectsToSave.add(objectToSave);
                }
            }            
        }
        
        return targetObjectsToSave;
    }
    
    // Based on the mapping objects and fields, create a Salesforce object based on the import message payload
    private sObject mapXMLToObject(Mapping_Object__mdt mappingObject, Dom.XmlNode xmlNode) {

        Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get(mappingObject.Salesforce_Object__c);
        sObject targetSalesforceObjectInstance = targetSalesforceObjectType.newSObject();

        // Loop through all the mappings for the target object
        for(Mapping_Field__mdt fieldMapping : mappingObject.Mapping_Fields__r){
            Dom.XmlNode[] nodes = xmlUtiltiy.find(xmlNode, fieldMapping.Message_Payload_Node__c);
            // Only 1 or none should be found. Otherwise goto the next node
            if (nodes.size() != 1){ 
                continue;
            }
            
            Object value = getValue(fieldMapping, nodes, targetSalesforceObjectType);
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
    private Object getValue(Mapping_Field__mdt fieldMapping, Dom.XmlNode[] nodes, Schema.SObjectType targetSalesforceObjectType){
        Object value;
        // If not a collection then transform the single field
        if (!fieldMapping.IntServ__Is_Collection__c){
            string xmlValue = xmlUtiltiy.getText(nodes[0], fieldMapping.Message_Payload_Node__c);    
            // Convert the value to the correct type
            value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, xmlValue);
        }
        else { // the node contains a list of value
            String collectionValues = '';  
            // Get all value elements from the node               
            for (Dom.XmlNode xmlValueNode : nodes[0].getChildren()){
                if (xmlValueNode.getName() == 'Value'){
                    collectionValues += String.isNotBlank(collectionValues) ? ';' : '';
                    collectionValues += xmlValueNode.getText();                                
                }
            }
            value = collectionValues;
        }
        return value;
    }
}