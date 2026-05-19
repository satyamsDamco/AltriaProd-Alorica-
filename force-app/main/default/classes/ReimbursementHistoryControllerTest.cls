@isTest
public class ReimbursementHistoryControllerTest {
    
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
    }
    
    static testmethod void reimbursementHistory(){
        
        Contact c = new Contact();
        c = [SELECT Zip_Code__c, Street_Address__c FROM Contact LIMIT 1];
        
        Reimbursement__c ri = new Reimbursement__c();
        ri = [SELECT Zip_Code__c, Street_Address__c FROM Reimbursement__c WHERE Zip_Code__c = '1234'];

        ApexPages.currentPage().getParameters().put('contactId',c.Id);
        Test.startTest();
        	ReimbursementHistoryController reimbHist = new ReimbursementHistoryController(new ApexPages.StandardController(ri));
        Test.stopTest();
        
    }
    
}