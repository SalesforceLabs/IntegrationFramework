@IsTest
public class Import_Service_Stub implements IAPI_Service {
    
    public RestResponse execute(RestRequest request, RestResponse response){        
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('TEST STUB RESULT');
        
        return response;
    }
}