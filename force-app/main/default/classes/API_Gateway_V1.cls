@RestResource(urlMapping = '/v1/*')
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
    global static void handleGet() {
        handleRequest();
    }

    @HttpPut
    global static void handlePut() {
        handleRequest();
    }    

    @HttpPost
    global static void handlePost() {
        handleRequest();
    }
    
    @HttpDelete
    global static void handleDelete() {
        handleRequest();
    }
    
	// Process the rerquest
    private static void handleRequest() {
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