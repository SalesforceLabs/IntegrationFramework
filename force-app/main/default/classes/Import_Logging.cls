public with sharing class Import_Logging {

    public Import_Log__c importLogObject;

    // Constructor
    public Import_Logging(Import_Message__c importMessage){
        importLogObject = new Import_Log__c();
        importLogObject.Import_Started_DateTime__c = datetime.now();
        importLogObject.Import_Is_Successful__c = false;
        importLogObject.Import_Log__c = '';
        importLogObject.Import_Message__c = importMessage.Id;
    }
        
    // Log success when no unexpected excpetions occured
    // Although the overall processing did not throw an exception
    // the Import_Is_Successful__c might still be false if not all
    // objects were saved successfully
    public void logSuccess(Database.UpsertResult[] saveResults, list<sObject> recordsToSave){
		logSaveResult(saveResults, recordsToSave);
        importLogObject.Import_Finished_DateTime__c = datetime.now();        
    }

	// Log failure when an unexpected excpetion occured
    public void logError(Exception e){
        // Create the response JSON
        API_Response errorResponse = new API_Response();
        errorResponse.createUnhandledExcpetionResponse(e.getMessage());
        
        importLogObject.Import_Log__c += JSON.serialize(errorResponse) + '\n';
        importLogObject.Import_Log__c += e.getStackTraceString() + '\n';
        importLogObject.Import_Is_Successful__c = false;
        importLogObject.Import_Finished_DateTime__c = datetime.now();
    }    
    
    // Loop through the upsert results and save the messages
    private void logSaveResult(Database.UpsertResult[] saveResults, list<sObject> recordsToSave){
        // Create the response JSON
        API_Response apiRepsonse = new API_Response();
        
        if (saveResults.size() == 0){
            apiRepsonse.response.status = 'NOCHANGES';
            importLogObject.Import_Log__c = JSON.serialize(apiRepsonse);
            return;
        }
        
        // Loop through the upsert results
        for(Integer index = 0; index < saveResults.size(); index++) {  
          	API_Response.ResultObject resultObject = getObjectMessage(saveResults[index], recordsToSave[index]);
            // Find the save record
            if(saveResults[index].isSuccess()) {
                apiRepsonse.response.results.add(resultObject);
            }
            else {
                // Operation failed, so get all errors
                API_Response.ErrorObject errorObject = getErrorMessages(saveResults[index], recordsToSave[index]);
                apiRepsonse.response.errors.add(errorObject);
                apiRepsonse.response.errorsize = apiRepsonse.response.errors.size();   
            }
        }
        
        importLogObject.Import_Is_Successful__c = (apiRepsonse.response.errorsize == 0) ? true : false;    
        importLogObject.Import_Log__c += JSON.serialize(apiRepsonse);
    }
    
    // Create the error messages
    private API_Response.ErrorObject getErrorMessages(Database.UpsertResult saveResult, sObject saveObject){
        // Operation failed, so get all errors
        API_Response.ErrorObject errorObject = new API_Response.ErrorObject();
        errorObject.salesforceobjecttype = String.valueOf(saveObject.getSObjectType());
        errorObject.id = saveResult.getId();
        
        List<String> errors = new List<String>();
        // Operation failed, so get all errors
        for(Database.Error err : saveResult.getErrors()) {
            errors.add('", Error for field: ' + err.getFields() + ', Error message: "' + err.getMessage() + '".');   
        }
        errorObject.message = String.join(errors, ' ');
		return errorObject;        
    }
    
    // Create the success massage
    private API_Response.ResultObject getObjectMessage(Database.UpsertResult saveResult, sObject saveObject){
        API_Response.ResultObject resulObject = new API_Response.ResultObject();
        resulObject.salesforceobjecttype = String.valueOf(saveObject.getSObjectType());
        resulObject.id = saveResult.getId();
        if(saveResult.isCreated()) {
            resulObject.operation = 'CREATED';
        } else {
            resulObject.operation = 'UPDATED';
        }    
        return resulObject;
    }
}