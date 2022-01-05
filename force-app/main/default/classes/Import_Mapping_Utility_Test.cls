@IsTest
public class Import_Mapping_Utility_Test {
    
    @IsTest
    static void convertToSalesforceFieldType_Test(){
        
        Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get('Lead');
        
        Mapping_Field__mdt fieldMapping = new Mapping_Field__mdt();
        fieldMapping.IntServ__Salesforce_Field__c = 'Company';
        Object value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, 'Test');
        System.assert(value instanceof String, 'Expected String');
        
        fieldMapping.IntServ__Salesforce_Field__c = 'HasOptedOutOfFax';
        value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, 'true');
        System.assert(value instanceof Boolean, 'Expected Boolean');
        
        fieldMapping.IntServ__Salesforce_Field__c = 'NumberOfEmployees';
        value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, '75');
        System.assert(value instanceof Integer, 'Expected Integer');
        
        fieldMapping.IntServ__Salesforce_Field__c = 'AnnualRevenue';
        value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, '1000000.50');
        System.assert(value instanceof Decimal, 'Expected Decimal');
	}
    
    // Test that an exception is thrown when an invalid salesforce field is converted
    @IsTest
    static void exception_Invalid_SalesforceField_Test(){
        boolean exceptionThrown = false;
        try {
            Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get('Lead');
        
            Mapping_Field__mdt fieldMapping = Import_Metadata_DataFactory_Utility_Test.createMappingField('DUMMY_PAYLOAD_FIELD', 'INVALID_SALESFORCE_FIELD', '', false);
            Object value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, '1000000.50');
        }
        catch (Exception e){
            exceptionThrown = true;
            System.assert(e.getMessage().startsWith('Error with field:'), 'Error message should start with "Error with field:". Actual ' + e.getMessage());
        }
        
        System.assert(exceptionThrown, 'Expection should have been thrown');
    }

    // Test that an exception is thrown when an invalid transofrmation classname is used    
    @IsTest
    static void exception_Invalid_Class_Test(){
        boolean exceptionThrown = false;
        try {
            Schema.SObjectType targetSalesforceObjectType = Schema.getGlobalDescribe().get('Lead');
        
            Mapping_Field__mdt fieldMapping = Import_Metadata_DataFactory_Utility_Test.createMappingField('DUMMY_PAYLOAD_FIELD', 'ID', 'INVALID_TRANSFORMATION_CLASS', false);
            Object value = Import_Mapping_Utility.convertToSalesforceFieldType(targetSalesforceObjectType, fieldMapping, '1000000.50');
        }
        catch (Exception e){
            exceptionThrown = true;
            System.assert(e.getMessage().startsWith('Error with field:'), 'Error message should start with "Error with field:". Actual ' + e.getMessage());
        }
        
        System.assert(exceptionThrown, 'Expection should have been thrown');
    }
}