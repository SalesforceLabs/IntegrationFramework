@IsTest
public class Import_Metadata_DataFactory_Utility_Test {
    
    // Create an in memory custom metadata with a child relationship  
    public static Mapping_Object__mdt connectChildrenToParent(Mapping_Object__mdt parent, List<Mapping_Field__mdt> children){
        String parentJson = JSON.serialize(parent); 
        String childrenJson = '"IntServ__Mapping_Fields__r" : {' +
            '"totalSize" : ' + children.size() + ',' +
            '"done" : true,' + 
            '"records" : ' + JSON.serialize(children) +
            '}';
        parentJson = parentJson.substring(0, parentJson.length()-1) + ',' + childrenJson + '}';
        return (Mapping_Object__mdt) JSON.deserialize(parentJson, Mapping_Object__mdt.class);
    }

    // Create an in memory custom metadata object mapping
    public static Mapping_Object__mdt createMappingObject(string messagePayloadNode, string salesforceExternalIdField, string salesforceObject){
        Mapping_Object__mdt mappingObject = new Mapping_Object__mdt();
        mappingObject.Active__c = true;
        mappingObject.Message_Payload_Node__c = messagePayloadNode;
        mappingObject.Message_Type__c = 'Test_Type';
        mappingObject.Salesforce_External_Id_Field__c = salesforceExternalIdField;
        mappingObject.Salesforce_Object__c = salesforceObject;
        return mappingObject;
    }

    // Create an in memory custom metadata field mapping
    public static Mapping_Field__mdt createMappingField(string messagePayloadNode, string salesforceField, 
                                                        string transformationClassName, boolean isCollection){
        Mapping_Field__mdt mappingField = new Mapping_Field__mdt();
        mappingField.Active__c = true;
        mappingField.Message_Payload_Node__c = messagePayloadNode;
        mappingField.Salesforce_Field__c = salesforceField;
        mappingField.Transformation_Classname__c = transformationClassName;
        mappingField.Is_Collection__c = isCollection;
        return mappingField;
    }
}