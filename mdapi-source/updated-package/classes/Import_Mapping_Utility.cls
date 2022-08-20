public with sharing class Import_Mapping_Utility {
        
    // Convert a node from the payload field to the correct Salesforce field type
    public static Object convertToSalesforceFieldType(Schema.SObjectType targetSalesforceObjectType, Mapping_Field__mdt fieldMapping, Object value){
        Object convertedValue;
        try {
            Schema.DisplayType fieldType = targetSalesforceObjectType.getDescribe().fields.getMap().get(fieldMapping.Salesforce_Field__c).getDescribe().getType();
            switch on fieldType {
                WHEN BOOLEAN {
                    convertedValue = Boolean.valueOf(value);                    
                }
                when COMBOBOX { 
                	convertedValue = value.toString(); 
                }
                when CURRENCY { 
                	convertedValue = Decimal.valueOf(value.toString()); 
                }
                when DATETIME {
                    DateTime valueDateTime;
                    if (value != null){
                        valueDateTime = (DateTime) JSON.deserialize(value.toString(), DateTime.class);
                    }
                    convertedValue = valueDateTime;
                }
                when DATE {
                    Date valueDate;
                    if (value != null){
                        valueDate = (Date) JSON.deserialize(value.toString(), Date.class);
                    }
                    convertedValue = valueDate;                     
                }
                when DOUBLE { 
                	convertedValue = Double.valueOf(value);                   
                }
                when INTEGER {
                	convertedValue = Integer.valueOf(value);                   
                }
                when LONG { 
                    convertedValue = Long.valueOf(value.toString());
                }
                when PERCENT {
                    convertedValue = Decimal.valueOf(value.toString());
                }
                when PICKLIST {
                    convertedValue = value.toString();
                }
                when STRING {
                    convertedValue = string.valueOf(value);
                }
                when TIME {
                    String[] timeParts = value.toString().split(':');
                    Integer hours = Integer.valueOf(timeParts[0]);
                    Integer minutes = Integer.valueOf(timeParts[1]);
                    convertedValue = Time.newInstance(hours, minutes, 0, 0);
                }
                when else {
                    throw new Import_Exceptions.Mapping_Exception('No type conversion found for ' + fieldType);
                }
            }
            
            // If a transformation class is specified than transform the field
            if (!String.isBlank(fieldMapping.Transformation_Classname__c)){
                Import_Field_Transformation_Interface transformationClass = (Import_Field_Transformation_Interface) Type.forName(fieldMapping.Transformation_Classname__c).newInstance();
                convertedValue = transformationClass.transformValue(convertedValue);
            }
            
            return convertedValue;
        }
        catch(Exception e){
            throw new Import_Exceptions.Mapping_Exception(
                'Error with field: ' + fieldMapping.Message_Payload_Node__c + 
                ' to ' + fieldMapping.Salesforce_Field__c + ' ' + e.getMessage() + 
                ' ' + e.getStackTraceString());
        }
    }
}