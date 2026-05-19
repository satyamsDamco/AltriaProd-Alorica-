@isTest
public class HotZipControllerTest {
    
    @testSetup
    static void dataSetup(){
        //Contact
        Contact con = new Contact();
        con.firstname = 'fname1';
        con.lastName = 'lname1';
        con.Street_Address__c ='test address';
        con.Zip_Code__c = '1234';
        con.City__c = 'test city';
        con.State__c = 'TS';
        con.Address_Verified__c = true;
        con.Phone = '1234567890';
        con.Email = 'test@email.com';
        con.OtherPhone = '0987654321';
        con.Birthdate1__c =  date.valueof('1990-02-08 00:00:00');
        con.AV_Code__c = '2';
        con.AVF_GIID_Received__c =  true;
        con.CCN__c = '999';
        insert con;
        
        //Hot Zip
        Hot_Zip__c hz = new Hot_Zip__c();
        hz.Zip_Code__c = '1234';
        hz.Active__c = true;
        insert hz;
    }
    
    static testmethod void hotZip(){
        
        Contact c = new Contact();
        c = [SELECT Zip_code__c FROM Contact LIMIT 1];
                    
        Hot_Zip__c hz = new Hot_Zip__c();
        hz.Zip_code__c = '1234';
        
        ApexPages.currentPage().getParameters().put('zipCode',c.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('contactId',c.Id);
        Test.startTest();
        	HotZipController hotZipC = new HotZipController(new ApexPages.StandardController(hz));
        Test.stopTest();
    }
	
}