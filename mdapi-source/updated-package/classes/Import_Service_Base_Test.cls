@IsTest
public class Import_Service_Base_Test {
	
    // Class used for testing the abstract service base class that generates an exception
    private class Service_Test_Error extends Import_Service_Base{
        public override List<sObject> processRecord(Import_Message__c importMessage){
            throw new Import_Exceptions.RequestBody_Exception('Error');
        }        
    }
    
    // Test that the URL body is JSON and contains an array of records
    @IsTest
    static void execute_Invalid_Request_Test(){
        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueof('<xml>Invalid Message</xml>');
        RestContext.response = new RestResponse();
        // Test Validate message
        Import_JSON_Service jsonService = new Import_JSON_Service();
        RestResponse serviceResponse = jsonService.execute(RestContext.request, RestContext.response);
		
        System.assert(serviceResponse.statusCode == 500, 'Expected Status code 500. Actual ' + serviceResponse.statusCode);
        System.assert(serviceResponse.responseBody.toString().contains('Request body is not correct'), 'Expected error message: Request body is not correct. Actual ' + serviceResponse.responseBody.toString());
    }
    
    // Test that the URL body is JSON and contains an array of records and
    // that a record contains the 4 Message_* fields
    @IsTest
    static void execute_Invalid_Record_Test(){
        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueof('{"records": [{"Test": "Invalid Message"}]}'); 
        RestContext.response = new RestResponse();
        // Test Validate message
        Import_JSON_Service jsonService = new Import_JSON_Service();
        RestResponse serviceResponse = jsonService.execute(RestContext.request, RestContext.response);
		
        System.assert(serviceResponse.statusCode == 500, 'Expected Status code 500. Actual ' + serviceResponse.statusCode);
        System.assert(serviceResponse.responseBody.toString().contains('Request record is not correct'), 'Expected error message: Request record is not correct. Actual ' + serviceResponse.responseBody.toString());
    }

    // Test that an exception is thrown when an error happens when processing a
    // correct JSON record
    @IsTest
    static void execute_Invalid_Record_Exception_Test(){
        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueof(Import_ImportMessage_DataFactory_Test.apiBody(Import_Payload_DataFactory_Test.jsonPayload)); 
        RestContext.response = new RestResponse();
        // Save the data
        Service_Test_Error testService = new Service_Test_Error();
        RestResponse serviceResponse = testService.execute(RestContext.request, RestContext.response);
		
        System.assert(serviceResponse.statusCode == 500, 'Expected Status code 500. Actual ' + serviceResponse.statusCode);
        System.assert(serviceResponse.responseBody.toString().contains('"message":"Error"'), 'Expected error message to start with: Error. Actual ' + serviceResponse.responseBody.toString());
    }
    
    // Test that for a correct JSON record the data is beging saved in Salesforce
    // based on the mapping objects
    @IsTest
    static void execute_Save_Test(){
        Import_Mapping.currentMessageType = 'Test_Type';
        Import_Mapping.mappingObjectsMDT = Import_Metadata_DataFactory_JSON_Test.createLeadMappingObjectsAndFields();

        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueof(Import_ImportMessage_DataFactory_Test.apiBody(Import_Payload_DataFactory_Test.jsonPayload)); 
        RestContext.response = new RestResponse();
        // Save the data
        Import_JSON_Service jsonService = new Import_JSON_Service();
        RestResponse serviceResponse = jsonService.execute(RestContext.request, RestContext.response);

        System.assert(serviceResponse.statusCode == 200, 'Expected Status code 200. Actual ' + serviceResponse.statusCode);
        System.assert(serviceResponse.responseBody.toString().contains('CREATED'), 'Expected result should contain "CREATED". Actual ' + serviceResponse.responseBody.toString());
        System.assert(serviceResponse.responseBody.toString().contains('Lead'), 'Expected result should contain "Lead". Actual ' + serviceResponse.responseBody.toString());
        System.assert(serviceResponse.responseBody.toString().contains('CREATED'), 'Expected result should contain "CREATED". Actual ' + serviceResponse.responseBody.toString());
    	System.assert(serviceResponse.responseBody.toString().contains('Case'), 'Expected result should contain "Case". Actual ' + serviceResponse.responseBody.toString());
    }
}