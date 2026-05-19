@isTest
private class createOACIssueTest {
    
     @testSetup
    static void setup(){
        //Contact
        contact con = new contact();
        con.firstname = 'MIKAELA';
        con.lastName = 'CUTCHON';
        con.Street_Address__c ='52 SUNSET RD';
        con.Apt_Lot__c = 'abcde';
        con.Zip_Code__c = '11580';
        con.City__c = 'VALLEY STREAM';
        con.State__c = 'NY';
        con.Address_Verified__c = true;
        con.Phone = '3478401950';
        con.Email = 'tes2t@email.com';
        con.OtherPhone = '1221122134';
        con.Birthdate1__c =  date.valueof('1987-07-08 00:00:00');
        con.AV_Code__c = '2';
        con.AVF_GIID_Received__c =  true;
        con.CCN__c = '999';
        insert con;
        
        //Operating Company
        Operating_Company__c oc = new Operating_Company__c();
        oc.OperatingCompany__c = 'PMIP';
        oc.OpCo_Description__c = 'test';
        oc.Active__c = true;
        insert oc;
        
        //TFIN
        TFN__c tfn = new TFN__c();
        tfn.DNIS__c = '48528';
        tfn.Operating_Company__c = oc.Id;
        tfn.Toll_Free_Number__c = '8006175337';
        tfn.Active__c = true;
        insert tfn;
        
        oc.Default_TFN__c = tfn.Id;
        update oc;
        
        //Product Line
        Product_Line__c pl = new Product_Line__c();
        pl.Name = 'Heated Tobacco';
        pl.Code__c = 'IQ';
        pl.Op_Company__c = oc.Id;
        pl.isActive__c = true;
        insert pl;
        
        //Brand
        Brand__c b = new Brand__c();
        b.BrandCode__c = '171222-01';
        b.Code__c = '171222-01';
        b.Name = 'IQOS Brand 01';
        b.Description__c = 'IQOS Brand 01';
        b.Product_Line__c = pl.Id;
        b.Op_Company__c = oc.Id;
        b.IsActive__c = true;
        insert b;
        
        //Brand Hierarchy
        Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
        bh.Vantive_Id__c = '5731';
        bh.Brand_Code__c = b.Id;
        bh.Product_Line_Code__c = pl.Id;
        bh.Active__c = true;
        insert bh;
        
        //Classification
        Classification__c c = new Classification__c();
        c.Description__c = 'Select APE';
        insert c;
        
        //Issue Type
        Issue_Type__c it = new Issue_Type__c();
        it.Description__c = 'Complaints';
        insert it;
        
        //Reason
        Reason__c r = new Reason__c();
        r.Description__c = 'NPRM Product Contact';
        insert r;
        
        //Cause
        Cause__c cause = new Cause__c();
        cause.Description__c = 'NPRM Product Contact';
        insert cause;
        
        //Group
        Group__c g = new Group__c();
        g.Description__c = 'NPRM';  
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
        ct.Description__c = 'CONSUMER';
        insert ct;
        
        //Store Type
        Store_Type__c st = new Store_Type__c();
        st.Description__c = 'IQOS Store';
        st.isActive__c = true;
        insert st;
        
        //Added: 5/18
        //Warranty 
        Variable_Data__c vb = new Variable_Data__c();
        vb.Variable_Name__c =  'Warranty Base Days';
        vb.Variable_Number__c = 999;
        insert vb;
    }
       
    @isTest 
    static void doPostTest() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        Contact con = [Select Id from Contact limit 1];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = con.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        String JSONMsg = '{"ContactInfo":{"firstName" : "MIKAELA","lastName" : "CUTCHON","suffix" : "","prefix" : "","addressLine1" :"52 SUNSET RD","addressLine2" : "abcde","zip" : "11580","city" : "VALLEY STREAM","state" : "NY","addressVerified" : true,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1221122134","dob" :  "1987-07-08 00:00:00","avCode" : "2","ageVerified" :  true,"ccn" : "999"},"IssueInfo":[{"BrandHierarchy" :'  + '"'+bh.Name+ '"' + ',"IssueHierarchy" : '+'"'+ih.Name+'"'+',"AgentID" : "NF123","Comment" : "Test Record","ComplaintSource" : "Test","ReferenceID" : "123456780","PurchasePrice" : 20.50,"ReimbursedOrRepIndicator" : "Reimbursed by GMR","ThirdPartyRA" : 2,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" : "2017-10-05 00:00:00","PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "1234567"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
           List<createOACIssue.jsonWrapper_Response> results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
     
    @isTest 
    static void doPostTest_1() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        String JSONMsg = '{"ContactInfo":{"firstName" : "MIKAELA","lastName" : "CUTCHON","suffix" : "","prefix" : "","addressLine1" :"52 SUNSET RD","addressLine2" : "abcde","zip" : "11580","city" : "VALLEY STREAM","state" : "NY","addressVerified" : true,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1221122134","dob" :  "1987-07-08 00:00:00","avCode" : "2","ageVerified" :  true,"ccn" : "111"},"IssueInfo":[{"BrandHierarchy" :'  + '"'+bh.Name+ '"' + ',"IssueHierarchy" : '+'"'+ih.Name+'"'+',"AgentID" : "NF123","Comment" : "Test Record","ComplaintSource" : "Test","ReferenceID" : "123456780","PurchasePrice" : null,"ReimbursedOrRepIndicator" : "Reimbursed by GMR","ThirdPartyRA" : 2,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" :null ,"PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "1234567"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
            List<createOACIssue.jsonWrapper_Response>  results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
     
     @isTest 
    static void doPostTest_2() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        Contact con = [Select Id, CCN__c from Contact limit 1];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = con.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        //system.assertequals(con.CCN__c, null);
        String JSONMsg = '{"ContactInfo":{"firstName" : "MIKAELA","lastName" : "CUTCHON","suffix" : "","prefix" : "","addressLine1" :"52 SUNSET RD","addressLine2" : "abcde","zip" : "11580","city" : "VALLEY STREAM","state" : "NY","addressVerified" : true,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1221122134","dob" :  "1987-07-08 00:00:00","avCode" : "2","ageVerified" :  true,"ccn" : ""},"IssueInfo":[{"BrandHierarchy" :'  + '"'+bh.Name+ '"' + ',"IssueHierarchy" : '+'"'+ih.Name+'"'+',"AgentID" : "NF123","Comment" : "Test Record","ComplaintSource" : "Test","ReferenceID" : "123456780","PurchasePrice" : 20.50,"ReimbursedOrRepIndicator" : "Reimbursed by GMR","ThirdPartyRA" : 2,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" : "2017-10-05 00:00:00","PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "MJN5BZKRW1MY"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
           List<createOACIssue.jsonWrapper_Response> results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
     
     @isTest //Validation Error
    static void doPostTest_3() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        Contact con = [Select Id, CCN__c from Contact limit 1];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = con.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        //system.assertequals(con.CCN__c, null);
        String JSONMsg = '{"ContactInfo":{"firstName" : "MIKAELA","lastName" : "CUTCHON","suffix" : "","prefix" : "","addressLine1" :"52 SUNSET RD","addressLine2" : "abcde","zip" : "11580","city" : "VALLEY STREAM","state" : "NY","addressVerified" : true,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1234567890","dob" :  "1987-07-08 00:00:00","avCode" : "2","ageVerified" :  true,"ccn" : ""},"IssueInfo":[{"BrandHierarchy" :'  + '"'+bh.Name+ '"' + ',"IssueHierarchy" : '+'"'+ih.Name+'"'+',"AgentID" : "NF123","Comment" : "Test Record","ComplaintSource" : "Test","ReferenceID" : "123456780","PurchasePrice" : 20.50,"ReimbursedOrRepIndicator" : "Reimbursed by GMR","ThirdPartyRA" : 2,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" : "2017-10-05 00:00:00","PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "QGLLG12WBXSR2T"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
           List<createOACIssue.jsonWrapper_Response>  results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
     
    @isTest //Mandatory fields Error
    static void doPostTest_4() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        Contact con = [Select Id, CCN__c from Contact limit 1];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = con.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        //system.assertequals(con.CCN__c, null);
        String JSONMsg = '{"ContactInfo":{"firstName" : "","lastName" : "","suffix" : "","prefix" : "","addressLine1" :"","addressLine2" : "abcde","zip" : "","city" : "","state" : "","addressVerified" : null,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1221122134","dob" :  "","avCode" : "","ageVerified" :  null,"ccn" : "999"},"IssueInfo":[{"BrandHierarchy" : "","IssueHierarchy" : "","AgentID" : "","Comment" : "","ComplaintSource" : "","ReferenceID" : "","PurchasePrice" : null,"ReimbursedOrRepIndicator" : "","ThirdPartyRA" : null,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" : "2017-10-05 00:00:00","PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "TNZNNJ01P64PCW"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
           List<createOACIssue.jsonWrapper_Response> results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
    
    //Increase coverage: 5/18/2021
    @isTest 
    static void doPostTest_5() {
        test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
        Brand_Hierarchy__c bh = [Select Name from Brand_Hierarchy__c limit 1];
        Issue_Hierarchy__c ih = [Select Name from Issue_Hierarchy__c Limit 1];
        
        String JSONMsg = '{"ContactInfo":{"firstName" : "JANNEL","lastName" : "DACAYO","suffix" : "","prefix" : "","addressLine1" :"52 SUNSET RD","addressLine2" : "abcde","zip" : "11580","city" : "VALLEY STREAM","state" : "NY","addressVerified" : true,"telephone" : "3478401950","mobilePhone" : "","emailAddress" : "tes2t@email.com","alternateTelephone" : "1221122134","dob" :  "1987-07-08 00:00:00","avCode" : "2","ageVerified" :  true,"ccn" : "999"},"IssueInfo":[{"BrandHierarchy" :'  + '"'+bh.Name+ '"' + ',"IssueHierarchy" : '+'"'+ih.Name+'"'+',"AgentID" : "NF123","Comment" : "Test Record","ComplaintSource" : "Test","ReferenceID" : "123456780","PurchasePrice" : 20.50,"ReimbursedOrRepIndicator" : "Reimbursed by GMR","ThirdPartyRA" : 2,"AffectedType" : "Case","AffectedQuantity" : 1,"ConsumerMentions" : "Recall","ExpectedType" : "Kit","ExpectedQuantity" : 5,"InboundTracking" : "123456","IncidentDate" : "2017-10-10 00:00:00","OutboundTracking" : "12345","ProductRetReqforReimbursement" : true,"PurchaseDate" : "2017-10-05 00:00:00","PurchaseType" : "Kit","PurchaseQuantity" : 10,"ReimbursementAmount" : 10.00,"SerialNumber" : "1234567"}],"StoreInfo":{"StoreType" : "IQOS Store","StoreName" : "Test IQOS","StoreAddress1" : "Florida","StoreAddress2" : "Test Florida 2","StoreCity" : "","StoreState" : "","storezip" : "1234","storecomments" : "test"}}';
         
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OACComplaintAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        
        Test.startTest();
            List<createOACIssue.jsonWrapper_Response>  results = createOACIssue.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
        
     } 
   

}