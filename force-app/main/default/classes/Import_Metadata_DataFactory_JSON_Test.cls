@IsTest
public class Import_Metadata_DataFactory_JSON_Test {
    
    public class ConvertCaseOrigin implements Import_Field_Transformation_Interface {
        public Object transformValue(Object value) {
            string returnValue;
            if (value == 'TOCONVERT'){
                returnValue = 'Email';
            }
            return returnValue;
        }
    }
    
    // Create a mapping object that does not link to a Salesforce field
    public static List<Mapping_Object__mdt> createExcpetionMappingObjectsAndFields_InvalidPayloadField(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('', 'Id', 'Lead');
        // Create the lead fields mapping objects        
        List<Mapping_Field__mdt> mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('xxx', 'xxx', '', false));
        // Join the parent and the children
        mappingObject = Import_Metadata_DataFactory_Utility_Test.connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }
    
    // Create a mapping object that does have field mappings
    public static List<Mapping_Object__mdt> createExcpetionMappingObjectsAndFields_NoFields(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('', 'Id', 'Lead');
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }
        
    // Create Lead mapping object and fields custom metadata in memory for testing
    // This mapping is linked to the payload: Import_TestPayloadDataFactory.jsonPayload
    public static List<Mapping_Object__mdt> createLeadMappingObjectsAndFields(){
        List<Mapping_Object__mdt> mappingObjects = new List<Mapping_Object__mdt>();

        // Create mapping for lead object
        Mapping_Object__mdt mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('', 'Id', 'Lead');
        // Create the lead fields mapping objects        
        List<Mapping_Field__mdt> mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('LeadFirstName', 'FirstName', '', false));
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('LeadLastName', 'LastName', '', false));
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('LeadCompany', 'Company', '', false));
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('Do_Not_Call_Me', 'DoNotCall', '', false));
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('NumberOf_Employees', 'NumberOfEmployees', '', false));        
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('Revenue', 'AnnualRevenue', '', false)); 
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('Industries', 'Industry', '', true));
        // Join the parent and the children
        mappingObject = Import_Metadata_DataFactory_Utility_Test.connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('cases', 'Id', 'Case');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('casenumber', 'Subject', '', false));
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('Origin', 'Origin', 'Import_Metadata_DataFactory_JSON_Test.ConvertCaseOrigin', false));
        // Join the parent and the children
        mappingObject = Import_Metadata_DataFactory_Utility_Test.connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('Owner', 'Id', 'Event');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('name', 'Subject', '', false));
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('LastUpdated', 'StartDateTime', '', false));
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('LastUpdated2', 'EndDateTime', '', false));
        // Join the parent and the children
        mappingObject = Import_Metadata_DataFactory_Utility_Test.connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);

        // Create mapping for lead object
        mappingObject = Import_Metadata_DataFactory_Utility_Test.createMappingObject('', 'Id', 'Opportunity');
        // Create the lead fields mapping objects        
        mappingFields = new List<Mapping_Field__mdt>();
        mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('NumberOf_Employees', 'TotalOpportunityQuantity', '', false));
		mappingFields.add(Import_Metadata_DataFactory_Utility_Test.createMappingField('Transferred', 'CloseDate', '', false));
        // Join the parent and the children
        mappingObject = Import_Metadata_DataFactory_Utility_Test.connectChildrenToParent(mappingObject, mappingFields);
        mappingObjects.add(mappingObject);
        
        return mappingObjects;
    }
}