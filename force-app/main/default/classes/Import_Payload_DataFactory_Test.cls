@IsTest
public class Import_Payload_DataFactory_Test {
	public static string jsonPayload = 
        '{' + 
            '"LeadFirstName": "Clark",' + 
        	'"LeadLastName": "Kent",' + 
        	'"LeadCompany": "DC Comics",' + 
        	'"Transferred": "2000-05-02",' + 
        	'"LastUpdated": "2012-05-02T12:00:00",' + 
            '"LastUpdated2": "2012-05-03 12:00:00",' + 
        	'"Do_Not_Call_Me": true,' + 
        	'"NumberOf_Employees": 75,' + 
        	'"Revenue": "1000000.50",' + 
        	'"Industries": [{"value": "Apparel"}],' + 
            '"Owner": {"name": "Jason", "LastUpdated": "2012-05-02T12:00:00", "LastUpdated2": "2012-05-03 12:00:00"},' + 
        	'"cases": [{"casenumber": "10", "Origin": "TOCONVERT"}, ' + 
                      '{"casenumber": "11", "Origin": "TOCONVERT"}]' + 
        '}';
    
    public static string xmlPayload = 
        '<message> ' + 
        '	<name>Clark</name> ' + 
        '	<lastname>Kent</lastname> ' + 
        '	<NumberOf_Employees>75</NumberOf_Employees> ' + 
		'   <Industries>' + 
		'   	<Value>Apparel</Value>' + 
		'   </Industries>' +         
        '   <cases> ' + 
        '   	<case> ' + 
        '   		<caseNumber>123</caseNumber>' + 
		'   		<Products>' +  
		'       		<Product>' +  
		'        			<ProductId>1</ProductId>' +         
		'        		</Product>' +  
		'   		</Products>' +  
		'   	</case>' +  
        '   	<case> ' + 
        '   		<caseNumber>123</caseNumber>' + 
		'   		<Products>' +  
		'       		<Product>' +  
		'        			<ProductId>2</ProductId>' +         
		'        		</Product>' +  
		'   		</Products>' +  
		'   	</case>' + 
        '   </cases> ' + 
        '</message>';
}