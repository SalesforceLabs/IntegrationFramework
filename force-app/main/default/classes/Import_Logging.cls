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
        
        if (saveResults.size() > 0){
            // Loop through the upsert results
            for(Integer index = 0, size = saveResults.size(); index < size; index++) {  
                string objectType = String.valueOf(recordsToSave[index].getSObjectType());
                Id recordId = saveResults[index].getId();
                string resultMessage = 'object: ' + objectType + ' Id: ' + recordId; 
                // Find the save record
                if(saveResults[index].isSuccess()) {
                    if(saveResults[index].isCreated()) {
                        results.add('Created ' + resultMessage);
                    } else {
                        results.add('Updated ' + resultMessage);
                    }
                }
                else {
                    // Operation failed, so get all errors
                    for(Database.Error err : saveResults[index].getErrors()) {
	                	errors.add('Error for: "' + resultMessage + '", Error for field: ' + err.getFields() + ', Error message: "' + err.getMessage() + '".');   
                    }
                }
            }
            
			importLogObject.Import_Is_Successful__c = (errors.size() == 0) ? true : false;    
            string resultMessage = String.join(results, '\n') + String.join(errors, '\n');
            importLogObject.Import_Log__c += resultMessage;
        }
    }
}