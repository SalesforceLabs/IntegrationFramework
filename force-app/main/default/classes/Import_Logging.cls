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
        importLogObject.Import_Log__c += 'Error: \n';
        importLogObject.Import_Log__c += e.getMessage() + '\n';
        importLogObject.Import_Log__c += e.getStackTraceString() + '\n';
        importLogObject.Import_Is_Successful__c = false;
        importLogObject.Import_Finished_DateTime__c = datetime.now();
    }    
    
    // Loop through the upsert results and save the messages
    private void logSaveResult(Database.UpsertResult[] saveResults, list<sObject> recordsToSave){
    	List<String> results = new List<String>();
    	List<String> errors = new List<String>();
        
        if (saveResults.size() == 0){
            return;
        }
        
        // Loop through the upsert results
        for(Integer index = 0; index < saveResults.size(); index++) {  
            string objectMessage = getObjectMessage(saveResults[index], recordsToSave[index]);
            // Find the save record
            if(saveResults[index].isSuccess()) {
                results.add(objectMessage);
            }
            else {
                // Operation failed, so get all errors
                string errorMessage = 'Error for: "' + objectMessage + '' + getErrorMessages(saveResults[index]);
                errors.add(errorMessage);
            }
        }
        
        importLogObject.Import_Is_Successful__c = (errors.size() == 0) ? true : false;    
        string resultMessage = String.join(results, '\n') + String.join(errors, '\n');
        importLogObject.Import_Log__c += resultMessage;
    }
    
    // Create the error messages
    private String getErrorMessages(Database.UpsertResult saveResult){
        List<String> errors = new List<String>();
        // Operation failed, so get all errors
        for(Database.Error err : saveResult.getErrors()) {
            errors.add('", Error for field: ' + err.getFields() + ', Error message: "' + err.getMessage() + '".');   
        }
		return String.join(errors, ' ');        
    }
    
    // Create the success massage
    private string getObjectMessage(Database.UpsertResult saveResult, sObject saveObject){
        string objectType = String.valueOf(saveObject.getSObjectType());
        Id recordId = saveResult.getId();
        string objectMessage = 'object: ' + objectType + ' Id: ' + recordId; 
        
        string resultMessage; 
        if(saveResult.isCreated()) {
            resultMessage = 'Created ' + objectMessage;
        } else {
            resultMessage = 'Updated ' + objectMessage;
        }    
        return resultMessage;
    }
}