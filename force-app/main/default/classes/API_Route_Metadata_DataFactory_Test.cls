@IsTest
public class API_Route_Metadata_DataFactory_Test {

    // Create routing custom metadata in memory for testing
    public static List<API_Routing__mdt> createTestRoutes(){
    	List<API_Routing__mdt> routings = new List<API_Routing__mdt>();
        routings.add(new API_Routing__mdt(Active__c=true, API_URL__c='/IntServ/v1/import',Http_Method__c='POST', Service_Classname__c='Import_Service_Stub'));
        routings.add(new API_Routing__mdt(Active__c=true, API_URL__c='/IntServ/v1/import',Http_Method__c='GET', Service_Classname__c='Import_Service_Stub'));
        routings.add(new API_Routing__mdt(Active__c=true, API_URL__c='/IntServ/v1/import',Http_Method__c='PUT', Service_Classname__c='Import_Service_Stub'));
        routings.add(new API_Routing__mdt(Active__c=true, API_URL__c='/IntServ/v1/import',Http_Method__c='DELETE', Service_Classname__c='Import_Service_Stub'));
        return routings;
    }
}