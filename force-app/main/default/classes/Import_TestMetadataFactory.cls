@IsTest
public class Import_TestMetadataFactory {
    
    public class ConvertCaseOrigin implements Import_Field_Transformation_Interface {
        public Object transformValue(Object value) {
            string returnValue;
            if (value == 'TOCONVERT'){
                returnValue = 'Email';
            }
            return returnValue;
        }
    }
    
    // Create routing custom metadata in memory for testing
    public static List<API_Routing__mdt> createTestRoutes(){
    	List<API_Routing__mdt> routings = new List<API_Routing__mdt>();
        routings.add(new API_Routing__mdt(Active__c=true, API_URL__c='/apigateway/v1/import',Http_Method__c='POST', Service_Classname__c='Import_Service_Stub'));
        return routings;
    }
    
    // Create a mapping object that does not link to a Salesforce field
    public static List<Mapping_Object__mdt> createExcpetionMappingObjectsAndFields(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = createMappingObject('', 'Id', 'Lead');
        // Create the lead fields mapping objects        
        List<Mapping_Field__mdt> mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(createMappingField('xxx', 'xxx', ''));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }
        
    // Create Lead mapping object and fields custom metadata in memory for testing
    // This mapping is linked to the payload: Import_TestPayloadDataFactory.jsonPayload
    public static List<Mapping_Object__mdt> createLeadMappingObjectsAndFields_JSON(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = createMappingObject('', 'Id', 'Lead');
        // Create the lead fields mapping objects        
        List<Mapping_Field__mdt> mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(createMappingField('LeadFirstName', 'FirstName', ''));
		mappingFields.add(createMappingField('LeadLastName', 'LastName', ''));
        mappingFields.add(createMappingField('LeadCompany', 'Company', ''));
		mappingFields.add(createMappingField('Do_Not_Call_Me', 'DoNotCall', ''));
		mappingFields.add(createMappingField('NumberOf_Employees', 'NumberOfEmployees', ''));        
        mappingFields.add(createMappingField('Revenue', 'AnnualRevenue', '')); 
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = createMappingObject('cases', 'Id', 'Case');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(createMappingField('casenumber', 'Subject', ''));
        mappingFields.add(createMappingField('Origin', 'Origin', 'Import_TestMetadataFactory.ConvertCaseOrigin'));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = createMappingObject('Owner', 'Id', 'Event');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
        mappingFields.add(createMappingField('name', 'Subject', ''));
		mappingFields.add(createMappingField('LastUpdated', 'StartDateTime', ''));
        mappingFields.add(createMappingField('LastUpdated2', 'EndDateTime', ''));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = createMappingObject('', 'Id', 'Opportunity');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
        mappingFields.add(createMappingField('NumberOf_Employees', 'TotalOpportunityQuantity', ''));
		mappingFields.add(createMappingField('Transferred', 'CloseDate', ''));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }

    // Create Lead mapping object and fields custom metadata in memory for testing
    // This mapping is linked to the payload: Import_TestPayloadDataFactory.xmlPayload
    public static List<Mapping_Object__mdt> createLeadMappingObjectsAndFields_XML(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = createMappingObject('/message', 'Id', 'Lead');
        // Create the lead fields mapping objects        
        List<Mapping_Field__mdt> mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(createMappingField('Name', 'FirstName', ''));
		mappingFields.add(createMappingField('lastname', 'LastName', ''));
        mappingFields.add(createMappingField('Name', 'Company', ''));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = createMappingObject('/message/cases/*', 'Id', 'Case');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(createMappingField('caseNumber', 'Subject', ''));
        mappingFields.add(createMappingField('Origin', 'Origin', 'Import_TestMetadataFactory.ConvertCaseOrigin'));
        // Join the parent and the children
        mappingObject = connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }

    // Create an in memory custom metadata witha child relationship  
    private static Mapping_Object__mdt connectChildrenToParent(Mapping_Object__mdt parent, List<Mapping_Field__mdt> children){
        String parentJson = JSON.serialize(parent); 
        String childrenJson = '"IntServ__Mapping_Fields__r" : {' +
            '"totalSize" : ' + children.size() + ',' +
            '"done" : true,' + 
            '"records" : ' + JSON.serialize(children) +
            '}';
        parentJson = parentJson.substring(0, parentJson.length()-1) + ',' + childrenJson + '}';
    
        return (Mapping_Object__mdt) JSON.deserialize(parentJson, Mapping_Object__mdt.class);
    }

    private static Mapping_Object__mdt createMappingObject(string messagePayloadNode, string salesforceExternalIdField, string salesforceObject){
        Mapping_Object__mdt mappingObject = new Mapping_Object__mdt();
        mappingObject.Active__c = true;
        mappingObject.Message_Payload_Node__c = messagePayloadNode;
        mappingObject.Message_Type__c = 'TestType';
        mappingObject.Salesforce_External_Id_Field__c = salesforceExternalIdField;
        mappingObject.Salesforce_Object__c = salesforceObject;
        return mappingObject;
    }

    private static Mapping_Field__mdt createMappingField(string messagePayloadNode, string salesforceField, string transformationClassName){
        Mapping_Field__mdt mappingField = new Mapping_Field__mdt();
        mappingField.Active__c = true;
        mappingField.Message_Payload_Node__c = messagePayloadNode;
        mappingField.Salesforce_Field__c = salesforceField;
        mappingField.Transformation_Classname__c = transformationClassName;
        return mappingField;
    }
}