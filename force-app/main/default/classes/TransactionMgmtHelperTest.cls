/*
Created By : Jannel Dacayo
Created Date : 6/16/2020
Description: Test class for TransactionMgmtHelper
*/

@isTest
public class TransactionMgmtHelperTest {
    
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
        
        //Operation Company
        Operating_Company__c oc = new Operating_Company__c();
        oc.OperatingCompany__c = 'JMC';
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
        ri.Zip_Code__c = '1234';
        ri.Street_Address__c = 'test address';
        ri.Issue__c = cs.Id;
        insert ri;
     	
        //Transaction Management History
        Transaction_Management_History__c tmh = new Transaction_Management_History__c();
        tmh.Service_Group_Code__c = 'Consumer';
        tmh.Service_Request_Code__c = 'CCNLOOKUP';
        insert tmh;
        Transaction_Management_History__c tmh2 = new Transaction_Management_History__c();
        tmh2.Service_Group_Code__c = 'APPROVALS';
        tmh2.Service_Request_Code__c = 'ISSUE_APPROVED';
        insert tmh2;
        
        //Insert Custom settings
	    Service_Code_Mapping__c scm = new Service_Code_Mapping__c();
        scm.Name = 'CCNLOOKUP';
        scm.Service_Group_Code__c = 'Consumer';
        insert scm;
        Service_Code_Mapping__c scm2 = new Service_Code_Mapping__c();
        scm2.Name = 'ISSUE_APPROVED';
        scm2.Service_Group_Code__c = 'APPROVALS';
        insert scm2;
        
        Service_Code_Mapping__c scm3 = new Service_Code_Mapping__c();
        scm3.Name = 'UPDATECUST';
        scm3.Service_Group_Code__c = 'CUSTOMERS';
        insert scm3;
        
        Service_Code_Mapping__c scm4 = new Service_Code_Mapping__c();
        scm4.Name = 'ENDCALL';
        scm4.Service_Group_Code__c = 'CRC';
        insert scm4;
        
        Service_Code_Mapping__c scm5 = new Service_Code_Mapping__c();
        scm5.Name = 'CREATE_SURVEY';
        scm5.Service_Group_Code__c = 'Survey';
        insert scm5;
        
        //Transaction Management
        Transaction_Management__c tranObj = new Transaction_Management__c();
        tranObj.Operating_Company__c = [SELECT id FROM Operating_Company__c LIMIT 1].id;
        tranObj.TFN__c = [SELECT id FROM TFN__c LIMIT 1].id;
        tranObj.Contact__c = [SELECT Id FROM Contact LIMIT 1].id;
        insert tranObj;
        
        Survey__c testSurvey = new Survey__c();
        testSurvey.Survey_Name__c = 'Test';
        insert testSurvey;
    }

    static testmethod void TestAll(){
        Transaction_Management__c tranObj = new Transaction_Management__c();
        tranObj.Operating_Company__c = [SELECT id FROM Operating_Company__c LIMIT 1].id;
        tranObj.TFN__c = [SELECT id FROM TFN__c LIMIT 1].id;
        tranObj.Contact__c = [SELECT Id FROM Contact LIMIT 1].id;
        insert tranObj;
        
        Cookie tranId = new Cookie('tranId',tranObj.id,null,-1,false);
		ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        
        TransactionMgmtHelper tmth = new TransactionMgmtHelper();
        tmth.createTransactionMgmtHistoryRecord('CCNLOOKUP',String.valueOf(tranObj.Id));
        
        Case c = new Case();
        c = [SELECT id FROM Case LIMIT 1];
        tmth.createTransactionMgmtHistoryRecord('ISSUE_APPROVED',String.valueOf(c.Id));
        
		tmth.createTransactionMgmtHistoryRecord('CREATE_SURVEY',String.valueOf(c.Id));        
        
        Contact con = new Contact();
        con = [SELECT id FROM Contact LIMIT 1];
        Transaction_Management__c tranObj2 = new Transaction_Management__c(); 
        tranObj2.Operating_Company__c = [SELECT id FROM Operating_Company__c LIMIT 1].id;
        tranObj2.TFN__c = [SELECT id FROM TFN__c LIMIT 1].id;
        tranObj2.Contact__c = con.id;
        tranObj2.Comments__c = 'Email address was confirmed';
        insert tranObj2;
        
        Cookie tranId2 = new Cookie('tranId',tranObj2.id,null,-1,false);
		ApexPages.currentPage().setCookies(new Cookie[]{tranId2});
        
       	tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(con.Id));
        tranObj2.Comments__c = 'Email Confirmed was cleared';
        update tranObj2;
        tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(con.Id));
        tranObj2.Comments__c = 'Email was cleared';
        update tranObj2;
        tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(con.Id));
        
        Reimbursement__c r = new Reimbursement__c();
        r = [SELECT id FROM  Reimbursement__c LIMIT 1];
        tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(r.Id));
        
        Correspondence_Fulfilment__c cf = new Correspondence_Fulfilment__c();
        cf.Contact__c = con.Id;
        insert cf;
        tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(cf.Id));
        
        Survey_Issue__c si = new Survey_Issue__c();
        si.Survey__c = [SELECT id FROM Survey__c LIMIT 1].id;
        si.Issue__c = c.id;
        si.Transaction__c = tranObj.id;
        insert si;
        tmth.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(si.Id));
        
        tmth.createTransactionMgmtHistoryRecord('ENDCALL',String.valueOf(c.Id));
    }
}