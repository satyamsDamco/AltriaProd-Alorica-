/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/*
test class of issue entry page
07/18/2016 Infogain – Created.

@Version 2.0: Added @testSetup and IQOS Test method as part of the IQOS Project
@Date: 2-14-2018
@Author: Gian Carlo Cutchon
*/

@isTest(SeeAllData=false)
private class IssueEntryControllerTest{
    @testSetup
    static void setup(){
        List<Product_Line__c> plList = new List<Product_Line__c> ();
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
        plList.add(pl);
        
        Product_Line__c pl2 = new Product_Line__c();
        pl2.Name = 'Heated Tobacco';
        pl2.Code__c = 'EC';
        pl2.Op_Company__c = oc.Id;
        pl2.isActive__c = true;
        plList.add(pl2);
        
        insert plList;
        
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
        insert newCase;
        
        //Variable Data 
        List<Variable_Data__c> vdList = new List<Variable_Data__c>();
        
        Variable_Data__c vd1 = new Variable_Data__c();
        vd1.Variable_Name__c = 'Warranty Base Days';
        vd1.Variable_Number__c = 90;
        vdList.add(vd1);
        Variable_Data__c vd2 = new Variable_Data__c();
        vd2.Variable_Name__c = 'Warranty Extended Days';
        vd2.Variable_Number__c = 90;
        vdList.add(vd2);
        insert vdList;
       
    }
    // Testing constructor of IssueEntryControllerTest controller
    static testMethod void validateIssueEntryController() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Email = 'test123@test.com';
        testCont.City__c = 'ARLINGTON';
        testCont.State__c = 'NY';
        testCont.Title = 'Mr';
        testCont.Zip_Code__c = '12603';
        testCont.Country__c = 'United States';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL1 = TestDataSetup.createPL('MST6','testCode1', testOpCo);
        insert testPL1;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL1, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL1, testOpCo);
        insert testBrand;       
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL1,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.DateCodeColdStorage__c = 'XYZ';
        testCase.Trace_Code_Location__c = 'CAN';
        testCase.Mfg_Trace_code__c = 'fbb41749m';
        testCase.Production_date__c = date.newinstance(2014,08,03);
        testCase.MasterId__c = null;
        //insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
            customerRecType = new Cookie('customerRecType','Trade',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        ApexPages.currentPage().getParameters().put('Fname',testCont.FirstName);
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);
        Test.startTest();
            IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'MST6';
         controller.iqosSuccessOI = false;
          PageReference pgref = controller.save();
        Test.stopTest();
        //system.assertEquals(true,(controller.productLineList).size() > 0);
    }
    
    static testMethod void validateAllParameterInit() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL2 = TestDataSetup.createPL('MST7','testCode2', testOpCo);
        insert testPL2;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL2, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL2, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL2,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('Fname',testCase.Id); 
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'MST7';
         controller.allParameterInit();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
       //system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
       // system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    
    
    // Testing save method of IssueEntryControllerTest controller
    static testMethod void validateSave() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('MST9','testCode3', testOpCo);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Product_Line_Code__c = testPL.id;
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'MST9';
         controller.productLineListData();
          controller.iqosSuccessOI = false;
         PageReference pgref1 = controller.save();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        //system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, testCase.Filter__c);
    }
    
   
    static testMethod void validateGetBrandData() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL4 = TestDataSetup.createPL('MST1','testCode4', testOpCo);
        insert testPL4;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL4, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL4,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Crc_Brand_Hierarchy_Code__c = testBh.id;
        insert testCase;
        PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+testCase.Id);
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'MST1';
        controller.getbrandData();
        System.assertEquals(pagereftest.getUrl(),controller.Cancel().getUrl());
        Test.stopTest();     
    }
    
    /* Testing Cancel method for if condition of IssueEntryController */
    static testMethod void validateCancel() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+testCase.Id);
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        PageReference pgref2 = controller.Cancel();
        System.assertEquals(pagereftest.getUrl(),controller.Cancel().getUrl());
        Test.stopTest();     
    }
    
    
    // Testing Cancel method for else condition of IssueEntryControllerTest controller
    static testMethod void validateCustomCancel() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
         Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        PageReference pagereftest = new PageReference('/500');
         Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put(testCase.Id,'issueId'); 
        ApexPages.currentPage().getParameters().put(testCase.Id,'parentIssue');
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        PageReference pageref = controller.customCancel();
        Test.stopTest();
    }
    
    // Testing customSave method for if condition of IssueEntryControllerTest controller
    static testMethod void validateCustomSave() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
         Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Store_Type__c testStoretype = TestDataSetup.createStoreType('ST10','Other1');
        insert testStoretype;
        Store__c testStore = TestDataSetup.createStore('WallMart',testStoretype);
        testStore.Issue__c = testCase.id;
        insert testStore;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id); 
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        PageReference pageref = controller.customSave();
        PageReference pagereftest = new PageReference('/apex/Issue_Detail?id='+testCase.Id);
        Test.stopTest();
        //system.assertEquals(pagereftest.getUrl(),pageref.getUrl());
    }
    
     
    // Testing resetHierarchy method of IssueEntryControllerTest controller
    static testMethod void validateResetHierarchy() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.resetHierarchy();
        Test.stopTest();
        system.assertEquals(controller.caseObj.Issue_Hierarchy_Code__c,controller.caseObj.Crc_Brand_Hierarchy_Code__c);
    }
           
    // Testing customSave method for else condition of IssueEntryControllerTest controller
    static testMethod void validatecustomSave1() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('MST2','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'MST2';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    
    static testMethod void validateCancelRedirect() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        PageReference pgref5 = controller.cancelRedirect();
        Test.stopTest();
        system.assertEquals(controller.caseObj.Issue_Hierarchy_Code__c,controller.caseObj.Crc_Brand_Hierarchy_Code__c);
    }
    
    static testMethod void validateGetTraceCodeLocation() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL5 = TestDataSetup.createPL('MST11','testCode5', testOpCo);
        insert testPL5;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('dob',string.valueof(bdate));
        ApexPages.currentPage().getParameters().put('country','United States');
        ApexPages.currentPage().getParameters().put('phone','9898989898');
        ApexPages.currentPage().getParameters().put('comName','test Comp');
        ApexPages.currentPage().getParameters().put('agentName','test Agent');
        ApexPages.currentPage().getParameters().put('DBA','test DBA');
        ApexPages.currentPage().getParameters().put('accountNo','test AccountNo');
        ApexPages.currentPage().getParameters().put('retail','test Retail');
        ApexPages.currentPage().getParameters().put('fSphone','9898989898');
        ApexPages.currentPage().getParameters().put('territory','test Territory');
        ApexPages.currentPage().getParameters().put('custType','Consumer');
        ApexPages.currentPage().getParameters().put('custType1','Consumer1');
        ApexPages.currentPage().getParameters().put('Addr1','123 str');

        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'MST11';
        List<SelectOption> Slist = controller.getTraceCodeLocation();
        Test.stopTest();
        system.assertEquals(controller.caseObj.Issue_Hierarchy_Code__c,controller.caseObj.Crc_Brand_Hierarchy_Code__c);
    }
    static testMethod void validateTraceCodeValidation() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        PageReference pgref3 = controller.TraceCodeValidation();
        Test.stopTest();
        system.assertEquals(controller.caseObj.Issue_Hierarchy_Code__c,controller.caseObj.Crc_Brand_Hierarchy_Code__c);
    }
    static testMethod void validateDateCodeValidation() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL6 = TestDataSetup.createPL('MST4','testCode6', testOpCo);
        testPL6.isValidDateCode__c = true;
        insert testPL6;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL6, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL6, testOpCo);
        insert testBrand; 
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL6,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Product_Line__c = testPL6.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Trace_Code_Location__c='PAC';
        testCase.Date_Code__c='n349x1x52';
        testCase.Mfg_Trace_code__c='n349x1x52';
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'MST4';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        Test.stopTest();
    }
    
    //11-21-2017: Increasing test coverage
    static testMethod void validateSave1() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        //Product_Line__c testPL = TestDataSetup.createPL('E-Cigarette','EC', testOpCo);
        //insert testPL;
        Product_Line__c testPL = [Select Id, Code__c, Name from Product_Line__c where Code__c = 'EC' Limit 1];
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Product_Line_Code__c = testPL.id;
        testCase.Date_Code__c = '01/02/2017';
        testCase.Product_Line__c = 'E-Cigarette';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'E-Cigarette';
         controller.productLineListData();
          controller.iqosSuccessOI = false;
         controller.save();
         //PageReference pgref1 = controller.save();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        //system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, testCase.Filter__c);
        system.assertEquals('01/02/2017', testCase.Date_Code__c);
    }
            
    //2-14-2018: IQOS Test Class method
    static testMethod void IQOSSerialNumber_Test() {

            test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
            case caseTest = [Select Serial_Number__c from Case limit 1];
            caseTest.Serial_Number__c = 'TNZNNJ01P64PCW';
            update caseTest;
            
            test.startTest();
            PageReference pageRef = Page.IssueEntryPage;
            test.setCurrentPage(pageRef);
            
            ApexPages.standardController controller = new ApexPages.standardController(caseTest);
            
            IssueEntryController con = new IssueEntryController(controller);
            
            con.IQOSSerialNumber();
            con.updateIQOSData();

        test.stopTest();
    }
    
    static testMethod void IQOSSerialNumber_Test2() {

            test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
            case caseTest = [Select Serial_Number__c from Case limit 1];
            caseTest.Serial_Number__c = 'QGLLG12WBXSR2T';
            update caseTest;
            
            test.startTest();
            PageReference pageRef = Page.IssueEntryPage;
            test.setCurrentPage(pageRef);
            
            ApexPages.standardController controller = new ApexPages.standardController(caseTest);
            
            IssueEntryController con = new IssueEntryController(controller);
            con.IQOSSerialNumber();

        test.stopTest();
    }
    
    static testMethod void IQOSSerialNumber_Test3() {

            test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
            case caseTest = [Select Serial_Number__c from Case limit 1];
            caseTest.Serial_Number__c = 'MJN5BZKRW1MY';
            update caseTest;
            
            test.startTest();
            PageReference pageRef = Page.IssueEntryPage;
            test.setCurrentPage(pageRef);
            
            ApexPages.standardController controller = new ApexPages.standardController(caseTest);
            
            IssueEntryController con = new IssueEntryController(controller);
            con.IQOSSerialNumber();

        test.stopTest();
    }
    // end of IQOS Test method -------------------------------------
	
    
    //09-25-2019 Jannel Increasing Test Coverage
    
    static testMethod void validateTraceCodeValidation2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Cigars','GP', testOpCo);
        insert testPL;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'testVan');
        insert testBH;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;   
        testCase.Product_Line__c = testPL.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        Test.StartTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'Cigars';
        controller.selectedTraceCodeLocation = 'PAC';
        testCase.Mfg_Trace_code__c = 'A035Z9151722';
        PageReference pgref3 = controller.TraceCodeValidation();
        System.assertEquals(null,pgref3);
        testCase.Mfg_Trace_code__c = 'A200X88P5';
        PageReference pgref4 = controller.TraceCodeValidation();
        System.assertEquals(null,pgref3);
        testCase.Mfg_Trace_code__c = 'A200X8P5';
        PageReference pgref5 = controller.TraceCodeValidation();
        System.assertEquals(null,pgref3);
        Test.stopTest();
        
    }
    
    static testMethod void validateSave2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
      	Product_Line__c testPL = TestDataSetup.createPL('TestCigars','GP', testOpCo);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH(null, null, '5 - Pack',null, 'Plastic', null, null,'12345', testBrand, testPL,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Product_Line_Code__c = testPL.id;
        testCase.Date_Code__c = '2/4/2019';
        testCase.Product_Line__c = testPL.Name;
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'E-Cigarrettes';
         controller.productLineListData();
         controller.iqosSuccessOI = false;
         testCase.Mfg_Trace_code__c = 'A243Z78P4';
         controller.save();
         testCase.Mfg_Trace_code__c = 'X243Z78P4';
         controller.save();
         testCase.Mfg_Trace_code__c = 'A243Z8P4';
         controller.save();
         testCase.Mfg_Trace_code__c = 'V243Z8P4';
         controller.save();
         testCase.Mfg_Trace_code__c = 'A035Z9151722';
         controller.save();
         testCase.Mfg_Trace_code__c = 'X035Z9151722';
         controller.save();
        //PageReference pgref1 = controller.save();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        //system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, testCase.Filter__c);
        system.assertEquals('2/4/2019', testCase.Date_Code__c);
    }
    
    static testMethod void validateSave3() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
      	Product_Line__c testPL = TestDataSetup.createPL('E-Cigarette','GP', testOpCo);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH(null, null, '5 - Pack',null, 'Plastic', null, null,'12345', testBrand, testPL,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Product_Line_Code__c = testPL.id;
        testCase.Product_Line__c = testPL.Name;
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
         controller.selectedProductLine = 'E-Cigarette';
         controller.productLineListData();
         controller.iqosSuccessOI = false;
         testCase.Date_Code__c = 'nx353nan';
         testCase.Mfg_Trace_code__c = 'A243Z78P4';
         controller.save();
         testCase.Date_Code__c = '02/04/2013';
         testCase.Mfg_Trace_code__c = 'X243Z78P4';
         controller.save();
         testCase.Date_Code__c = '01/04/2013';
         testCase.Mfg_Trace_code__c = 'X243Z78P4';
         controller.save();
         testCase.Date_Code__c = '02-04-2019';
         testCase.Mfg_Trace_code__c = 'X243Z78P4';
         controller.save();
         testCase.Date_Code__c = '02/04/2019';
         testCase.Mfg_Trace_code__c = 'X243Z78P4';
         controller.save();
         testcase.Reimbursed_Or_Replaced_Indicator__c = 'To be reimbursed by Alorica';
         testcase.Reimbursement_Amount__c = 1;
         controller.save(); 
        //PageReference pgref1 = controller.save();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        //system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, testCase.Filter__c);
        system.assertEquals('02/04/2019', testCase.Date_Code__c);
    }
    
    //09-25-2019: Increasing test coverage
    static testMethod void validatecustomSave2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('MST2','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Service_Code_Mapping__c testSG = TestDataSetup.createSerCode('CRC', 'TestSG');
        insert testSG;
        Transaction_Management_History__c testTMH = TestDataSetup.createTMHis(testSG.Service_Group_Code__c ,testTM,'UPDATEISSUE');
        insert testTMH;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'A200X88P5';
        testCase.NMI_Transaction_ID__c = '01189a0';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'E-Cigarette';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    //09-25-2019: Increasing test coverage    
    static testMethod void validatecustomSave3() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('MST2','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Service_Code_Mapping__c testSG = TestDataSetup.createSerCode('CRC', 'TestSG');
        insert testSG;
        Transaction_Management_History__c testTMH = TestDataSetup.createTMHis(testSG.Service_Group_Code__c ,testTM,'UPDATEISSUE');
        insert testTMH;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'X200X88P5';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'E-Cigarette';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    
    //09-25-2019: Increasing test coverage
    static testMethod void validatecustomSave4() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('MST2','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'A200X88P';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'Cigars';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    //09-25-2019: Increasing test coverage    
    static testMethod void validatecustomSave5() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('Cigars','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'V200X88P';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'Cigars';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    
    //09-25-2019: Increasing test coverage
    static testMethod void validatecustomSave6() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('E-Cigarette','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'A035Z9151722';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        testCase.NMI_Transaction_ID__c = 'test123';
        controller.selectedProductLine = 'E-Cigarette';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    }
    //09-25-2019: Increasing test coverage    
    static testMethod void validatecustomSave7() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = 'test123';
        testCont.Apt_Lot__c = 'testapt';
        testCont.City__c = 'testcity';
        testCont.Country__c = 'United States';
        testCont.State__c = 'Test State';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL5 = TestDataSetup.createPL('E-Cigarette','testCode5', testOpCo);
        insert testPL5;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL5, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL5, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL5,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Date__c = Date.Today();
        testCase.Production_date__c = date.valueof('2017-01-31 00:00:00');
        testCase.Mfg_Trace_code__c = 'X035Z9151722';
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('parentIssue',testCase.Id);  
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'E-Cigarette';
        controller.selectedTraceCodeLocation = 'TestLocation';
        controller.customSave();
        Test.stopTest();
        Issue_Hierarchy__c issuehObj = [Select Id,Product_Line__r.name From Issue_Hierarchy__c Where Id =: testIH.id limit 1];
        system.assertEquals(issuehObj.Product_Line__r.name, controller.caseObj.Product_Line__c);
        system.assertEquals(testBH.Filter__c, controller.caseObj.Filter__c);
    } 
     static testMethod void validateDateCodeValidation2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL6 = TestDataSetup.createPL('MST','testCode6', testOpCo);
        testPL6.isValidDateCode__c = true;
        insert testPL6;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL6, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL6, testOpCo);
        insert testBrand; 
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL6,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Product_Line__c = testPL6.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Trace_Code_Location__c='PAC';
        testCase.Date_Code__c='02/04/2917';
        testCase.Mfg_Trace_code__c='X035Z9151722';
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'MST';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        Test.stopTest();
    }
    static testMethod void validateDateCodeValidation3() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL6 = TestDataSetup.createPL('E-Cigarette','testCode6', testOpCo);
        testPL6.isValidDateCode__c = true;
        insert testPL6;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL6, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL6, testOpCo);
        insert testBrand; 
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL6,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Product_Line__c = testPL6.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Trace_Code_Location__c='PAC';
        testCase.Mfg_Trace_code__c='X035Z9151722';
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        testCase.Date_Code__c='02/04/2917';
        controller.selectedProductLine = 'E-Cigarette';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        testCase.Date_Code__c='02/04/2013';
        controller.selectedProductLine = 'E-Cigarette';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        testCase.Date_Code__c='01-04-2017';
        controller.selectedProductLine = 'E-Cigarette';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        testCase.Date_Code__c='01/04/20137';
        controller.selectedProductLine = 'E-Cigarette';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
         testCase.Date_Code__c='01/04/2013';
        controller.selectedProductLine = 'E-Cigarette';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        Test.stopTest();
    }
    static testMethod void validateDateCodeValidation4() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL6 = TestDataSetup.createPL('Pouch','testCode6', testOpCo);
        testPL6.isValidDateCode__c = true;
        insert testPL6;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL6, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL6, testOpCo);
        insert testBrand; 
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL6,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Product_Line__c = testPL6.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.Trace_Code_Location__c='PAC';
        testCase.Date_Code__c='02/04/2917';
        testCase.Mfg_Trace_code__c='X035Z9151722';
        insert testCase;
        Test.startTest();
        IssueEntryController controller = new IssueEntryController(new ApexPages.StandardController(testCase));
        controller.selectedProductLine = 'Pouch';
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        controller.selectedTraceCodeLocation = null;
        controller.DateCodeValidation();
        controller.TraceCodeValidation();
        Test.stopTest();
    }
 }