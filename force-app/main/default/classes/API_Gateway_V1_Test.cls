@IsTest
public class API_Gateway_V1_Test {
    
    // Test the response of a valid route
    @IsTest
    static void send_Valid_HTTPMethod_Request_Test(){
    	// Create a POST request that can be handled 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        req.requestURI = '/apigateway/v1/import';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
    	API_ServiceFactory.apiRoutings = Import_TestMetadataFactory.createTestRoutes();
        IAPI_Service importService = (IAPI_Service) API_ServiceFactory.createService(RestContext.request);
        API_Gateway_V1.importService = importService;
        API_Gateway_V1.handleRequest();
        Test.stopTest();

        System.assert(RestContext.response.statusCode != 500, 'Excepted statusCode not 500. Actual ' + RestContext.response.statusCode);
    }
    
    // Test the response of an invalid route
    @IsTest
    static void send_Invalid_Route_Request_Test(){        
        // Create a POST request for a route that is invalid 
        Test.startTest();
        RestRequest req = new RestRequest(); 
        req.requestURI = '/wrongroute';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
    	API_Gateway_V1.handleRequest();
        Test.stopTest();
        
        System.assert(RestContext.response.statusCode == 500, 'Excepted statusCode 500. Actual ' + RestContext.response.statusCode);
        System.assert(RestContext.response.responseBody.toString() == 'Route not found', 'Expected "Route not found". Actual ' + RestContext.response.responseBody.toString());
    }
}