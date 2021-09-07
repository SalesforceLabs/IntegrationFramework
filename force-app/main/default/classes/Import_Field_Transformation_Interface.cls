// Add this interface to a class and mention the transfromation class
// on the custom metadata record Mapping_Field__mdt.Transformation_Classname__c	
public interface Import_Field_Transformation_Interface {
    // When importing of a message it might be needed to transform 
    // the import message value to a Salesforce value. 
    // For example: transform country code DE to Germany. 
	Object transformValue(Object value);
}