/************************************************************************ 
Author: Randolf Suplito
Date: 07/21/2022
Description: Test class for IssueAdjustmentManager class
*************************************************************************/

@isTest(SeeAllData=false)
public class IssueAdjustmentManagerTest {
	
    static List<Case> caseRec = new List<Case>();
        
    @testSetup
    static void setup(){
        //Contact
        contact con = new contact();
        con.firstname = 'RECARDO';
        con.lastName = 'DALISAY';
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
        ih.Product_Line__c = pl.Id;
        ih.Cause__c = cause.Id;
        ih.Group__c = g.Id;
        ih.Active__c = true;
        insert ih;
		
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
		
		//Case
        Case newCase = new Case();
        newCase.Issue_Hierarchy_Code__c = ih.Id;
        newCase.Crc_Brand_Hierarchy_Code__c = bh.Id;
        newCase.ContactID = con.Id;
        newCase.Purchase_Price__c = 1;
        newCase.Comment__c = 'test';
        newCase.Op_Company__c = oc.id;
        newCase.Product_Line__c = pl.id;
        newCase.Incident_Date__c = system.today();
        newCase.DateCodeColdStorage__c = 'N';
        insert newCase;
    }
    
    public static void getAllRecords() {
        caseRec = [SELECT Id, CaseNumber__c FROM Case LIMIT 1];
    }
    
    static testmethod void doPostSuccessTest() {
        getAllRecords();
        
        String caseNo = caseRec[0].CaseNumber__c;
        String JSONPayload = '{"IssueAdjustment":[{"Request_ID":"0001","Row_ID":"00001","IssueID":"'+caseNo+'","Adjustment_Type":"Cold Storage","Adjustment_Code": "ITCS","Adjustment_Instructions":"New value for Cold Storage for 03258789","Old_Value": "","New_Value":"Y","Action_Type": "U","Force":"0"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IssueAdjustmentAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONPayload);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
           List<IssueAdjustmentManager.responseDTO> results = IssueAdjustmentManager.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
    }
    
    static testmethod void doPostFailTest() {
        getAllRecords();
        
        String caseNo = caseRec[0].CaseNumber__c;
        String JSONPayload = '{"IssueAdjustment":[{"Request_ID":"0001","Row_ID":"00001","IssueID":"'+caseNo+'","Adjustment_Type":"Cold Storage","Adjustment_Code": "ITSC","Adjustment_Instructions":"New value for Cold Storage for 03258789","Old_Value": "","New_Value":"Y","Action_Type": "U","Force":"0"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IssueAdjustmentAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONPayload);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
           List<IssueAdjustmentManager.responseDTO> results = IssueAdjustmentManager.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
    }
    
    static testmethod void doPostNoRequestIdTest() {
        getAllRecords();
        
        String caseNo = caseRec[0].CaseNumber__c;
        String JSONPayload = '{"IssueAdjustment":[{"Request_ID":"","Row_ID":"00001","IssueID":"'+caseNo+'","Adjustment_Type":"Cold Storage","Adjustment_Code": "ITCS","Adjustment_Instructions":"New value for Cold Storage for 03258789","Old_Value": "","New_Value":"Y","Action_Type": "U","Force":"0"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IssueAdjustmentAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONPayload);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
           List<IssueAdjustmentManager.responseDTO> results = IssueAdjustmentManager.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
    }
    
    static testmethod void doPostNoExistingCaseTest() {
        getAllRecords();
        
        String caseNo = caseRec[0].CaseNumber__c;
        String JSONPayload = '{"IssueAdjustment":[{"Request_ID":"","Row_ID":"00001","IssueID":"0001","Adjustment_Type":"Cold Storage","Adjustment_Code": "ITCS","Adjustment_Instructions":"New value for Cold Storage for 03258789","Old_Value": "","New_Value":"Y","Action_Type": "U","Force":"0"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IssueAdjustmentAPI/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONPayload);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
           List<IssueAdjustmentManager.responseDTO> results = IssueAdjustmentManager.doPost();
           system.debug('req ---->' +req);
           system.debug('res ---->' +res);
        Test.StopTest(); 
    }
}