@IsTest
public class Import_TestMessageDataFactory {

    // Create the body that can be added to an API call
    public static string apiBody(string payload) {
        // Check if the payload is JSON
        boolean isJSONValid = true; 
        try {
            // Check if the URL body is JSON
            JSON.deserializeUntyped(payload);
        } 
        catch (Exception e) {
            isJSONValid = false;
        }
        // If the payload is JSON escape the " character. This is needed
        // because the payload field is treated as a string so that it can 
        // conatin multiple formats
        if (isJSONValid){
            payload = payload.replace('"', '\\"');
        }
        
    	string urlBody = 
            '{"records":' +
            '  [{' +
            '    "Message_Payload__c":"' + payload + '",' +
            '    "Message_Source_Id__c":"fdeab5f5-75f1-4875-b0d8-b193e4ebf330",' +
            '    "Message_Source_System__c":"System1",' +
            '    "Message_Type__c":"TestType"' +
            '  }]' +
            '}';       
        return urlBody;
    }
   
    // Create basic import objects
    public static List<Import_Message__c> create_ImportObject(string payload){
        
        List<Import_Message__c> importMessages = new List<Import_Message__c>();        
        Import_Message__c importMessage = new Import_Message__c();
        importMessage.Message_Payload__c = payload;
        importMessage.Message_Source_Id__c = 'fdeab5f5-75f1-4875-b0d8-b193e4ebf330';
        importMessage.Message_Source_System__c = 'System1';
        importMessage.Message_Type__c = 'TestType';
        importMessages.add(importMessage);
        insert importMessages;
        
        return importMessages;
    }
}