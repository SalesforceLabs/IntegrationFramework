@IsTest
public class API_ServiceFactory_Test {
    
    // Test the response of a valid route
    @IsTest
    static void send_Valid_HTTPMethod_Request_Test(){
        RestRequest request = new RestRequest(); 
        request.requestURI = '/IntServ/v1/import';
        request.httpMethod = 'POST';
        
        boolean exceptionThrown = false;
        try {
            API_ServiceFactory.apiRoutings = API_Route_Metadata_DataFactory_Test.createTestRoutes();
        	API_ServiceFactory.createService(request);
        }
        catch (Import_Exceptions.API_Exception apiException){
            exceptionThrown = true;
        }        
        System.assert(!exceptionThrown, 'Excepted should not be thrown');
    }
    
    // Test the response of an invalid route
    @IsTest
    static void send_Invalid_Route_Request_Test(){        
        RestRequest request = new RestRequest(); 
        request.requestURI = '/wrongroute';
        request.httpMethod = 'POST';
        
        boolean exceptionThrown = false;
        try {
            API_ServiceFactory.apiRoutings = API_Route_Metadata_DataFactory_Test.createTestRoutes();
         	API_ServiceFactory.createService(request); 
        }
        catch (Import_Exceptions.API_Exception apiException){
            exceptionThrown = true;
        	System.assert(apiException.getMessage() == 'Route not found', 'Expected "Route not found". Actual ' + apiException.getMessage());   
        }
        System.assert(exceptionThrown, 'Excepted should be thrown');
    }
}