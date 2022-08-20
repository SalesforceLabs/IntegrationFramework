public with sharing class API_Response {
    
    // Create the JSON response for an unhandled exception
    public void createUnhandledExcpetionResponse(string errorMessage) {
        response.success = false;
        response.status = 'ERROR';
        ErrorObject errorObject = new ErrorObject();
        errorObject.message = errorMessage;
        response.errors.add(errorObject);
        response.errorsize = response.errors.size();        
    }
    
    // Response JSON object
    
	public ResponseObject response = new ResponseObject();
    
    public class ResponseObject {
        public boolean success;
        public string status;
        public integer resultsize = 0;
        public List<ResultObject> results = new List<ResultObject>();
        public integer errorsize = 0;
        public List<ErrorObject> errors = new List<ErrorObject>();
    }
    
    public class ResultObject {
        public string salesforceobjecttype;
        public string id;
        public string operation;
    }
    
    public class ErrorObject {
        public string salesforceobjecttype;
        public string id;
        public string message;
    }
}