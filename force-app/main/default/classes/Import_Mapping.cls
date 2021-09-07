public class Import_Mapping {

    @TestVisible
    private static List<Mapping_Object__mdt> mappingObjectsMDT;
    @TestVisible
    private static string currentMessageType;
    
    // Get the mapping objects and related mapping fields
	public static List<Mapping_Object__mdt> getMappings(Import_Message__c importMessage){ 
        
        // If the mappings for the current import message type are not loaded 
        // Then retrieve the mappings for the message type
        if (currentMessageType != importMessage.Message_Type__c){
            currentMessageType = importMessage.Message_Type__c;        
			mappingObjectsMDT = 
                [SELECT
                    Message_Payload_Node__c,
                    Salesforce_Object__c,
                    Salesforce_External_Id_Field__c,
                    (SELECT Message_Payload_Node__c, Salesforce_Field__c, 
                       Is_Collection__c, Transformation_Classname__c
                    FROM Mapping_Fields__r
                    WHERE Active__c = true)
                 FROM 
                    Mapping_Object__mdt 
                 WHERE 
                    Active__c = true AND
                    Message_Type__c = :importMessage.Message_Type__c
                 Order By
                 	Salesforce_Object__c];
        } 
        
        // Throw error if no mapping records are found
        if (mappingObjectsMDT.size() == 0){
            throw new Import_Exceptions.Mapping_Exception('No mapping records found');             
        }

        return mappingObjectsMDT;
    } 
}