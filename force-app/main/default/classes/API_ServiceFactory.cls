public class API_ServiceFactory {
    
    private static final string baseUrlMapping = '/apigateway/v1/';
    
    @testVisible 
    private static List<API_Routing__mdt> apiRoutings{
        get{ 
            if(apiRoutings == NULL){ 
                apiRoutings = [SELECT API_URL__c, Service_Classname__c, Http_Method__c 
                              FROM API_Routing__mdt 
                              WHERE Active__c = true]; 
            } 
            return apiRoutings; 
		} 
		set; 
	} 
    
    // Create the service that will process the message that is send to a specif endpoint
    public static IAPI_Service createService(RestRequest request) {          
        // Check for all active routings if the URL exsists
        for(API_Routing__mdt route : apiRoutings) {
            if (route.Http_Method__c == request.httpMethod &&
                route.API_URL__c == request.requestURI) {
                return (IAPI_Service) Type.forName(route.Service_Classname__c).newInstance();
            }
        } 

        throw new Import_Exceptions.API_Exception('Route not found');
    }
}