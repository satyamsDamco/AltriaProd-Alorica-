/*
Created by: Jannel Dacayo
Created Date: 9/9/2020
*/
@isTest
public class IVRReimbursementAPITest {
    
    @testSetup
    static void setup(){
        //Contact
        Contact con = new contact();
        con.firstname = 'BRUCE';
        con.lastName = 'WAYNE';
        con.Street_Address__c ='10725 CYPRESS LAKE TERRACE';
        con.Apt_Lot__c = 'abcde';
        con.Zip_Code__c = '33498';
        con.City__c = 'BOCA RATON';
        con.State__c = 'FL';
        con.Address_Verified__c = true;
        con.Phone = '1234567890';
        con.Email = 'test@email.com';
        con.Birthdate1__c =  date.valueof('2000-09-28 00:00:00');
        con.AV_Code__c = '2';
        con.AVF_GIID_Received__c =  true;
        con.CCN__c = '999';
        insert con;
        
        Contact con2 = new contact();
        con2.firstname = 'ROBIN';
        con2.lastName = 'HOOD';
        con2.Street_Address__c ='10725 CYPRESS LAKE TERRACE';
        con2.Apt_Lot__c = 'abcde';
        con2.Zip_Code__c = '33498';
        con2.City__c = 'BOCA RATON';
        con2.State__c = 'FL';
        con2.Address_Verified__c = true;
        con2.Phone = '1234567890';
        con2.Email = 'test2@email.com';
        con2.Birthdate1__c =  date.valueof('2010-09-28 00:00:00');
        con2.AV_Code__c = '2';
        con2.AVF_GIID_Received__c =  true;
        con2.CCN__c = '999';
        insert con2;
        
        Contact con3 = new contact();
        con3.firstname = 'NoAge';
        con3.lastName = 'WAYNE';
        con3.Street_Address__c ='10725 CYPRESS LAKE TERRACE';
        con3.Apt_Lot__c = 'abcdefg';
        con3.Zip_Code__c = '33498';
        con3.City__c = 'BOCA RATON';
        con3.State__c = 'FL';
        con3.Address_Verified__c = true;
        con3.Phone = '1234567890';
        con3.Email = 'test3@email.com';
        con3.Birthdate1__c =  date.valueof('1990-09-28 00:00:00');
        con3.AV_Code__c = '2';
        con3.AVF_GIID_Received__c =  false;
        con3.CCN__c = '999';
        insert con3;
        
        Contact con4 = new contact();
        con4.firstname = 'DUP';
        con4.lastName = 'WAYNE';
        con4.Street_Address__c ='10725 CYPRESS LAKE TERRACE';
        con4.Apt_Lot__c = 'abcde';
        con4.Zip_Code__c = '33498';
        con4.City__c = 'BOCA RATON';
        con4.State__c = 'FL';
        con4.Address_Verified__c = true;
        con4.Phone = '1234567890';
        con4.Email = 'test3@email.com';
        con4.Birthdate1__c =  date.valueof('2010-09-28 00:00:00');
        con4.AV_Code__c = '2';
        con4.AVF_GIID_Received__c =  true;
        con4.CCN__c = '999';
        insert con4;
        
        //Operation Company
        Operating_Company__c oc = new Operating_Company__c();
        oc.OperatingCompany__c = 'PMUSA';
        oc.OpCo_Description__c = 'test';
        oc.Active__c = true;
        insert oc;
        
        //TFN
        TFN__c tfn = new TFN__c();
        tfn.DNIS__c = '99999';
        tfn.Operating_Company__c = oc.Id;
        tfn.Toll_Free_Number__c = '0000000000';
        tfn.Active__c = true;
        insert tfn;
        
        oc.Default_TFN__c = tfn.Id;
        update oc;

        //Product Line
        List<Product_Line__c> plList = new List<Product_Line__c> ();
        Product_Line__c pl = new Product_Line__c();
        pl.Name = 'Cigars';
        pl.Code__c = 'GP';
        pl.Op_Company__c = oc.Id;
        pl.isActive__c = true;
        plList.add(pl);
             insert plList;
        
        //Brand
        Brand__c b = new Brand__c();
        b.BrandCode__c = '282828-28';
        b.Code__c = '282828-28';
        b.Name = 'Test Brand Name';
        b.Description__c = 'Test';
        b.Product_Line__c = pl.Id;
        b.Op_Company__c = oc.Id;
        b.IsActive__c = true;
        insert b;
        
        //Brand Hierarchy
        Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
        bh.Vantive_Id__c = '1234';
        bh.Brand_Code__c = b.Id;
        bh.Product_Line_Code__c = pl.Id;
        bh.Active__c = true;
        insert bh;
        
        //Classification
        Classification__c c = new Classification__c();
        c.Description__c = 'Test Classification';
        insert c;
        
        //Issue Type
        Issue_Type__c it = new Issue_Type__c();
        it.Description__c = 'Test Issue type';
        insert it;
        
        //Reason
        Reason__c r = new Reason__c();
        r.Description__c = 'Test Reason';
        insert r;
        
        //Cause
        Cause__c cause = new Cause__c();
        cause.Description__c = 'Test Cause';
        insert cause;
        
        //Group
        Group__c g = new Group__c();
        g.Description__c = 'Test Group';  
        insert g;
        
        //Issue Hierarchy
        Issue_Hierarchy__c ih = new Issue_Hierarchy__c();
        ih.Classification__c = c.Id;
        ih.Issue_Type__c = it.Id;
        ih.Reason__c = r.Id;
        ih.Product_Line__c = pl.iD;
        ih.Cause__c = cause.Id;
        ih.Group__c = g.Id;
        ih.Active__c = true;
        insert ih;
        
        //Customer Type
  	    Customer_Type__c ct = new Customer_Type__c();
        ct.IsActive__c = true;
        ct.Description__c = 'Test customer';
        insert ct;
        
        //Store Type
        Store_Type__c st = new Store_Type__c();
        st.Description__c = 'Test Store';
        st.isActive__c = true;
        insert st;
        
        //Case
        Case cs = new Case();
        cs.Issue_Hierarchy_Code__c = ih.Id;
        cs.Crc_Brand_Hierarchy_Code__c = bh.Id;
        cs.ContactID = con.Id;
        cs.Purchase_Price__c = 1;
        cs.Comment__c = 'test';
        cs.Op_Company__c = oc.id;
        cs.Product_Line__c = pl.id;
        cs.Incident_Date__c = system.today();
        insert cs;
        
        Reimbursement__c ri = new Reimbursement__c();
        ri.Zip_Code__c = '33498';
        ri.Street_Address__c = '10725 CYPRESS LAKE TERRACE';
        ri.Issue__c = cs.Id;
        ri.Consumer__c = con.Id;
        ri.Ship_Date__c = Date.valueOf('2020-10-18');
        ri.Card_Number__c = 'XXXXXXXXXXXX0999';
        ri.Cheque_Amount__c = 18.00;
        insert ri;
        
        Reimbursement__c ri3= new Reimbursement__c();
        ri3.Zip_Code__c = '33498';
        ri3.Street_Address__c = '10725 CYPRESS LAKE TERRACE';
        ri3.Issue__c = cs.Id;
        ri3.Consumer__c = con4.Id;
        ri3.Card_Number__c = 'XXXXXXXXXXXX0999';
        ri.Cheque_Amount__c = 29.00;
        insert ri3;
    }
    
    //For 300 Status Code
    static testmethod void doPosttest1(){
		
		Contact c = new Contact();
        c = [SELECT id FROM Contact ORDER BY id ASC LIMIT 1];
        System.debug(c);
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = c.id;
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "2000-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //For 301 - Status Code
    static testmethod void doPosttest2(){
		
		Contact c = new Contact();
        c = [SELECT id FROM Contact ORDER BY id DESC LIMIT 1];
        System.debug(c);
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = c.id;
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "2010-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //For 900 - Error Code
    static testmethod void doPosttest3(){
		
		Contact c = new Contact();
        c = [SELECT id FROM Contact ORDER BY id DESC LIMIT 1];
        System.debug(c);
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = c.id;
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "2010-09-288","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //302 - Multiple Consumers
     static testmethod void doPosttest4(){
		
		List<Contact> c = new List<Contact>();
        c = [SELECT id FROM Contact ORDER BY id DESC];
        System.debug(c);
        
        Id [] fixedSearchResults= new Id[2];
        Integer i = 0;
        for(Contact con: c){
            if(i == 0)fixedSearchResults[0] = con.id; 
            if(i == 1)fixedSearchResults[1] = con.id; 
            i++;
        }
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "2010-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //302 - No Consumer Found
    static testmethod void doPosttest5(){
   
 		String JSONfile = '{"dob": "1980-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //For 302 - No Reimbursement Found
    static testmethod void doPosttest6(){
		
        Id [] fixedSearchResults= new Id[1];
        for(Contact c: [SELECT Id, AVF_GIID_Received__c FROM Contact ORDER BY Id DESC LIMIT 3])
        {
            fixedSearchResults[0] = c.id;	
        }
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "1990-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
    
    //For 302 - Age Not Verified
    static testmethod void doPosttest7(){
		
        Id [] fixedSearchResults= new Id[1];
        for(Contact c: [SELECT Id, AVF_GIID_Received__c FROM Contact ORDER BY Id DESC LIMIT 2])
        {
            fixedSearchResults[0] = c.id;	
        }
        Test.setFixedSearchResults(fixedSearchResults);
		        
 		String JSONfile = '{"dob": "1990-09-28","zip": "33498"}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IVRReimbursementAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONfile);
        
        RestContext.request = req;
        RestContext.response= res; 
        
        Test.startTest();
        	IVRReimbursementAPI.doPost();
        	System.debug('Request: ' + req);
        	System.debug('Response: ' + res);
        Test.stopTest();
        
    }
}