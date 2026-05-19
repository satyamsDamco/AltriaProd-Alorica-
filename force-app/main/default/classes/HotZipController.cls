public class HotZipController {
    
    public Hot_Zip__c hz {get;set;}
    public Contact conObj {get;set;}
    
    public HotZipController(ApexPages.StandardController stdController)
    {
        String zipCode;
        String contactId;
        System.debug('Page: ' + ApexPages.currentPage());
		zipCode = ApexPages.currentPage().getParameters().get('zipCode');      
        contactId = ApexPages.currentPage().getParameters().get('contactId');
        
        if(zipCode != null){
            for(Hot_Zip__c h : [SELECT Zip_Code_Documentation__c FROM Hot_Zip__c 
                                WHERE Zip_Code__c =: zipCode AND Active__c = true])
            {
                hz = h;
            }
        }
        
        if(contactId != null){
            for(Contact c : [SELECT FirstName, LastName, Street_Address__c, 
                             Apt_Lot__c, Zip_Code__c, State__c, Phone, OtherPhone
                             FROM Contact WHERE  Id =: contactId]){
                conObj = c;
            }
        }
    }
}