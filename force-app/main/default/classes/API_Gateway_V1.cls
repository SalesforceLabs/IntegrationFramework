@RestResource(urlMapping = '/apigateway/v1/*')
global with sharing class API_Gateway_V1 {
    
    // Based on the request URL, get the routing record
    // From the routing record inject the class that will be used for process the message
    @testVisible 
    private static IAPI_Service importService{ 
        get{ 
            if(importService == NULL){ 
				importService = (IAPI_Service) API_ServiceFactory.createService(RestContext.request);
            } 
            return importService; 
		} 
		set; 
	}    
    
    @HttpGet
    @HttpPut
    @HttpPost
    @HttpDelete
    global static void handleRequest() {
        try {
            RestContext.response = importService.execute(RestContext.request, RestContext.response); 
        } 
        catch (Exception apiException) {
            // An error occured
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf(apiException.getMessage());
        }
    }
}