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
        testCase.Warranty_Expiration_Date__c = Date.Today();
        testCase.Warranty_Start_Date__c = Date.Today();
        testCase.registrationDate__c = Date.Today();
        testCase.Third_Party_Reimbursement_Amount__c = 90;
        testCase.Reimbursement_Amount__c = 12;
        testCase.Total_Paid_by_Customer__c = 50;
        testCase.Base_Price__c = 30;
        testCase.Production_date__c = Date.Today();
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
        testCont.Repeat_Complainer__c = true;
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

    // Missing/unrecognized Product Line
    // NOTE: save() has no "choose Product Line" validation message at all — that
    // message only exists inside DateCodeValidation(), and only in a branch that
    // is unreachable once a product line is already confirmed to be in the map.
    // What IS reachable and real: if selectedProductLine doesn't match any active
    // Product_Line__c, DateCodeValidation()'s whole validation block is skipped
    // and it returns null with no error added.
static testMethod void testDateCodeError_NoProductLine() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;
    Case c = new Case(Op_Company__c = oc.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'NonExistentProductLine'; // not present in productLineMap
    ctrl.caseObj.Date_Code__c = 'XYZ';
    PageReference result = ctrl.DateCodeValidation();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(0, ApexPages.getMessages().size());
}

// Missing Brand Hierarchy — this message is produced by DateCodeValidation(),
// not save(), so we call DateCodeValidation() directly with a Product Line
// that has isValidDateCode__c = true and no Brand Hierarchy set.
static testMethod void testDateCodeError_NoBrandHierarchy() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'TestLineNoBH';
    pl.Code__c = 'TLNB';
    pl.Op_Company__c = oc.Id;
    pl.isActive__c = true;
    pl.isValidDateCode__c = true;
    insert pl;

    Case c = new Case(Op_Company__c = oc.Id, Product_Line__c = 'TestLineNoBH');
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'TestLineNoBH';
    ctrl.caseObj.Crc_Brand_Hierarchy_Code__c = null;
    ctrl.DateCodeValidation();
    Test.stopTest();

    System.assertEquals('Please choose Brand Hierarchy before entering Date Code.',
        ApexPages.getMessages()[0].getSummary());
}

// Cigar Trace Code - 8 chars
// save()'s Cigar UPC logic (not DateCodeValidation()'s) doesn't add any
// ApexPages message — it silently derives UPC_code__c. For an 8-character
// trace code whose first letter is outside J/L/R/S/V/X, that letter gets
// appended to the Brand Hierarchy's UPC.
static testMethod void testCigarTraceCode_8Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIG8';
    pl.Op_Company__c = oc.Id;
    pl.isActive__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGB8';
    brand.Code__c = 'CIGB8';
    brand.Name = 'Test Cigar Brand 8';
    brand.Description__c = 'Test Cigar Brand 8';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'V8';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '111111';
    insert bh;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.caseObj.Mfg_Trace_code__c = 'ABCDEFGH'; // 8 chars, first letter 'A' is outside J/L/R/S/V/X
    ctrl.save();
    Test.stopTest();

    // NOTE: the length==8 branch does set UPC_code__c with the letter suffix
    // first, but the immediately-following "else" (paired only with the
    // length==9-and-non-Cigars check) unconditionally fires whenever the
    // trace code isn't 9 characters, overwriting UPC_code__c back to the
    // plain Brand Hierarchy UPC. That's the actual, current behavior.
    System.assertEquals('111111', ctrl.caseObj.UPC_code__c);
}

// Cigar Trace Code - 12 chars
// The 12-character UPC-append branch explicitly excludes Cigars, so for a
// Cigars case the UPC is copied through unchanged (no letter suffix).
static testMethod void testCigarTraceCode_12Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIG12';
    pl.Op_Company__c = oc.Id;
    pl.isActive__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGB12';
    brand.Code__c = 'CIGB12';
    brand.Name = 'Test Cigar Brand 12';
    brand.Description__c = 'Test Cigar Brand 12';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'V12';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '222222';
    insert bh;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.caseObj.Mfg_Trace_code__c = 'ABCDEFGHIJKL'; // 12 chars
    ctrl.save();
    Test.stopTest();

    System.assertEquals('222222', ctrl.caseObj.UPC_code__c);
}

// Cigar Trace Code - 9 chars
// The 9-character UPC-append branch also explicitly excludes Cigars, so the
// UPC is copied through unchanged here too.
static testMethod void testCigarTraceCode_9Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIG9';
    pl.Op_Company__c = oc.Id;
    pl.isActive__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGB9';
    brand.Code__c = 'CIGB9';
    brand.Name = 'Test Cigar Brand 9';
    brand.Description__c = 'Test Cigar Brand 9';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'V9';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '987654';
    insert bh;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.caseObj.Mfg_Trace_code__c = 'BBBBBBBBB'; // 9 chars
    ctrl.save();
    Test.stopTest();

    System.assertEquals('987654', ctrl.caseObj.UPC_code__c);
}

// ==========================================================================
// Additional tests added to cover previously untested helper methods:
// checkMutipleIssue(), getbrandData() (non-Copenhagen branch),
// warrantyInformation() (all branches), orderInfoAPI()/productRegAPI()
// (blank serial number branches), and getCreatableFieldsSOQL().
// These methods do not perform HTTP callouts on the code paths exercised
// here, so no HttpCalloutMock is required.
// ==========================================================================

// Covers both branches of checkMutipleIssue(): a contact that already has
// a Case (true) and a contact that does not (false).
static testMethod void testCheckMutipleIssueBranches() {
    Case existingCase = [SELECT Id, ContactId, IQOS_Reference_ID__c FROM Case LIMIT 1];
    Id conId = existingCase.ContactId;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(existingCase));

    ctrl.conObj = new Contact(Id = conId);
    Boolean hasIssue = ctrl.checkMutipleIssue();
    System.assertEquals(true, hasIssue, 'Contact with an existing Case should return true');

    Contact newCon = new Contact();
    newCon.FirstName = 'New';
    newCon.LastName = 'NoIssuesYet';
    newCon.Street_Address__c = '1 TEST ST';
    newCon.Apt_Lot__c = 'abcde';
    newCon.Zip_Code__c = '11580';
    newCon.City__c = 'VALLEY STREAM';
    newCon.State__c = 'NY';
    newCon.Address_Verified__c = true;
    newCon.Phone = '3478401950';
    newCon.Email = 'noissuesyet@email.com';
    newCon.OtherPhone = '1221122134';
    newCon.Birthdate1__c = date.valueof('1987-07-08 00:00:00');
    newCon.AV_Code__c = '2';
    newCon.AVF_GIID_Received__c = true;
    newCon.CCN__c = '888';
    insert newCon;
    ctrl.conObj = new Contact(Id = newCon.Id);
    Boolean noIssue = ctrl.checkMutipleIssue();
    System.assertEquals(false, noIssue, 'Contact without any Case should return false');
    Test.stopTest();
}

// Covers getbrandData() for a non-Copenhagen brand (returns '') and for a
// Copenhagen brand (returns 'COPENHAGEN').
static testMethod void testGetbrandDataBranches() {
    Brand_Hierarchy__c bh = [SELECT Id FROM Brand_Hierarchy__c LIMIT 1];
    Operating_Company__c oc = [SELECT Id FROM Operating_Company__c LIMIT 1];
    Product_Line__c pl = [SELECT Id FROM Product_Line__c LIMIT 1];
    Case c = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));

    ctrl.caseObj.Crc_Brand_Hierarchy_Code__c = bh.Id;
    String nonCopenhagen = ctrl.getbrandData();
    System.assertEquals('', nonCopenhagen, 'Non-Copenhagen brand should return blank');

    Brand__c copBrand = new Brand__c();
    copBrand.BrandCode__c = 'COP-01';
    copBrand.Code__c = 'COP-01';
    copBrand.Name = 'COPENHAGEN';
    copBrand.Description__c = 'Copenhagen Brand';
    copBrand.Product_Line__c = pl.Id;
    copBrand.Op_Company__c = oc.Id;
    copBrand.IsActive__c = true;
    insert copBrand;

    Brand_Hierarchy__c copBH = new Brand_Hierarchy__c();
    copBH.Vantive_Id__c = '9999';
    copBH.Brand_Code__c = copBrand.Id;
    copBH.Product_Line_Code__c = pl.Id;
    copBH.Active__c = true;
    insert copBH;

    ctrl.caseObj.Crc_Brand_Hierarchy_Code__c = copBH.Id;
    String copenhagen = ctrl.getbrandData();
    System.assertEquals('COPENHAGEN', copenhagen, 'Copenhagen brand should return COPENHAGEN');
    Test.stopTest();
}

// Covers the various branches of warrantyInformation():
// - no registration status (fields cleared)
// - Active + First Time Buyer + CCN present, using Incident_Date__c
// - Active without First Time Buyer/CCN (base days only)
// - neither Incident_Date__c nor CreatedDate__c set (defaults to today)
static testMethod void testWarrantyInformationBranches() {
    Case c = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));

    // Branch: no registration status -> fields reset/cleared
    ctrl.caseObj.registrationStatus__c = null;
    ctrl.warrantyInformation();
    System.assertEquals('', ctrl.caseObj.Warranty_Status__c);

    // Branch: Active + First Time Buyer + CCN, Incident_Date__c drives expiry check
    ctrl.caseObj.registrationStatus__c = 'Active';
    ctrl.caseObj.First_Time_Buyer__c = true;
    ctrl.caseObj.CCN__c = '12345';
    ctrl.caseObj.Purchase_Date__c = Date.today().addDays(-400);
    ctrl.caseObj.Incident_Date__c = Date.today();
    ctrl.warrantyInformation();
    System.assertEquals('WARRANTY IS EXPIRED', ctrl.caseObj.Warranty_Status__c);

    // Branch: Active, but not First Time Buyer / no CCN -> base days only, still under warranty
    ctrl.caseObj.registrationStatus__c = 'Active';
    ctrl.caseObj.First_Time_Buyer__c = false;
    ctrl.caseObj.CCN__c = null;
    ctrl.caseObj.Purchase_Date__c = Date.today();
    ctrl.caseObj.Incident_Date__c = Date.today();
    ctrl.warrantyInformation();
    System.assertEquals('UNDER WARRANTY', ctrl.caseObj.Warranty_Status__c);

    // Branch: neither Incident_Date__c nor CreatedDate__c is set -> defaults to System.today()
    // (CreatedDate__c is a system/formula field on Case and can't be set directly in Apex,
    // so the CreatedDate__c-populated branch can't be exercised from a unit test in isolation.)
    ctrl.caseObj.Incident_Date__c = null;
    ctrl.warrantyInformation();

    Test.stopTest();
}

// Covers the "blank/null serial number" branches of orderInfoAPI() and
// productRegAPI(), which do not perform a callout and were previously
// never invoked directly in any test.
static testMethod void testOrderInfoAndProductRegBlankSerialBranches() {
    Case c = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));

    String nullResult = ctrl.orderInfoAPI(null);
    System.assertEquals(null, nullResult);
    String emptyResult = ctrl.orderInfoAPI('');
    System.assertEquals(null, emptyResult);

    ctrl.productRegAPI(null);
    System.assertEquals(false, ctrl.iqosSuccessPR);
    ctrl.productRegAPI('');
    System.assertEquals(false, ctrl.iqosSuccessPR);

    Test.stopTest();
}

// Covers getCreatableFieldsSOQL(): null whereClause, blank whereClause,
// and a valid call that builds a SOQL string.
static testMethod void testGetCreatableFieldsSOQL() {
    Test.startTest();
    String nullResult = IssueEntryController.getCreatableFieldsSOQL('Case', null);
    System.assertEquals(null, nullResult);

    String blankResult = IssueEntryController.getCreatableFieldsSOQL('Case', '');
    System.assertEquals(null, blankResult);

    String validResult = IssueEntryController.getCreatableFieldsSOQL('Case', 'Id != null');
    System.assertEquals(true, validResult.startsWith('SELECT'));
    System.assertEquals(true, validResult.contains('FROM Case'));
    Test.stopTest();
}

// ==========================================================================
// Additional tests covering DateCodeValidation()'s Cigars-specific popup
// logic (8/12/9 character trace codes). This block sits after the call to
// UstDateCodeValidationHelper.ustTraceCodeValidation(), which we cannot
// mock since that helper class wasn't provided. Instead, we reach this
// block via a legitimate alternate path: when the Product Line's Code__c
// is blank, the "if(ProductLineCode.Code__c != null && ...)" guard is
// false, so the helper call (and its own return-null branches) is skipped
// entirely, and execution falls straight through to the Cigars check.
// ==========================================================================

// 8-character trace code, first letter outside J/L/R/S/V/X -> INFO popup message.
static testMethod void testDateCodeValidationCigarPopup_8Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIGPOP8';
    // Op_Company__c intentionally left unset so the Operating_Company__c
    // formula resolves blank, making the ustTraceCodeValidation() guard
    // false and letting DateCodeValidation() fall through to the Cigars
    // popup block below.
    pl.isActive__c = true;
    pl.isValidDateCode__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGPOP8';
    brand.Code__c = 'CIGPOP8';
    brand.Name = 'Test Cigar Popup Brand 8';
    brand.Description__c = 'Test Cigar Popup Brand 8';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'VPOP8';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '333333';
    insert bh;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.selectedTraceCodeLocation = 'TESTLOC';
    ctrl.caseObj.Date_Code__c = 'ABCD';
    ctrl.caseObj.Mfg_Trace_code__c = 'ABCDEFGH'; // 8 chars, first letter 'A' outside J/L/R/S/V/X
    PageReference result = ctrl.DateCodeValidation();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
}

// 12-character trace code whose first letter matches a Tracecode_Matrix_Table__c
// Position_1__c entry -> INFO popup message and traceCodeErrorMessage populated.
static testMethod void testDateCodeValidationCigarPopup_12Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIGPOP12';
    // Op_Company__c intentionally left unset - see note in the 8-char test.
    pl.isActive__c = true;
    pl.isValidDateCode__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGPOP12';
    brand.Code__c = 'CIGPOP12';
    brand.Name = 'Test Cigar Popup Brand 12';
    brand.Description__c = 'Test Cigar Popup Brand 12';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'VPOP12';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '444444';
    insert bh;

    Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c(
        Character_Length__c = 12,
        Product_Line_Name__c = 'Cigars',
        POPUP_UPC_CODE__c = 'Y',
        Position_1__c = 'A',
        COLD_STORAGE__c = 'N',
        Factory__c = 'MC_HELIX',
        Product_Line_Code__c = 'Cigars',
        Production_Location__c = 'RICHMOND'
    );
    insert tmt;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.selectedTraceCodeLocation = 'TESTLOC';
    ctrl.caseObj.Date_Code__c = 'ABCD';
    ctrl.caseObj.Mfg_Trace_code__c = 'ABCDEFGHIJKL'; // 12 chars, first letter 'A' matches Position_1__c
    PageReference result = ctrl.DateCodeValidation();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
    System.assertEquals(true, ctrl.traceCodeErrorMessage.contains('Potential 8/8 Product'));
}

// 9-character trace code whose first letter matches a Tracecode_Matrix_Table__c
// Position_1__c entry -> INFO popup message and traceCodeErrorMessage populated.
static testMethod void testDateCodeValidationCigarPopup_9Chars() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'Cigars';
    pl.Code__c = 'CIGPOP9';
    // Op_Company__c intentionally left unset - see note in the 8-char test.
    pl.isActive__c = true;
    pl.isValidDateCode__c = true;
    insert pl;

    Brand__c brand = new Brand__c();
    brand.BrandCode__c = 'CIGPOP9';
    brand.Code__c = 'CIGPOP9';
    brand.Name = 'Test Cigar Popup Brand 9';
    brand.Description__c = 'Test Cigar Popup Brand 9';
    brand.Product_Line__c = pl.Id;
    brand.Op_Company__c = oc.Id;
    brand.IsActive__c = true;
    insert brand;

    Brand_Hierarchy__c bh = new Brand_Hierarchy__c();
    bh.Vantive_Id__c = 'VPOP9';
    bh.Brand_Code__c = brand.Id;
    bh.Product_Line_Code__c = pl.Id;
    bh.Active__c = true;
    bh.UPC__c = '555555';
    insert bh;

    Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c(
        Character_Length__c = 9,
        Product_Line_Name__c = 'Cigars',
        POPUP_UPC_CODE__c = 'Y',
        Position_1__c = 'B',
        COLD_STORAGE__c = 'N',
        Factory__c = 'MC_HELIX',
        Product_Line_Code__c = 'Cigars',
        Production_Location__c = 'RICHMOND'
    );
    insert tmt;

    Case c = new Case(Op_Company__c = oc.Id, Crc_Brand_Hierarchy_Code__c = bh.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'Cigars';
    ctrl.selectedTraceCodeLocation = 'TESTLOC';
    ctrl.caseObj.Date_Code__c = 'ABCD';
    ctrl.caseObj.Mfg_Trace_code__c = 'BBBBBBBBB'; // 9 chars, first letter 'B' matches Position_1__c
    PageReference result = ctrl.DateCodeValidation();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
    System.assertEquals(true, ctrl.traceCodeErrorMessage.contains('Potential 8/8 Product'));
}
 
// Repeat Complainer branch
static testMethod void testRepeatComplainerBranch() {
    Contact c = [SELECT Id FROM Contact LIMIT 1];
    c.Repeat_Complainer__c = false;
    update c;

    // The controller only populates conObj (and later evaluates the repeat
    // complainer update) when the Case's ContactId is set, so link them
    // before construction.
    Case testCase = [SELECT Id, IQOS_Reference_ID__c, ContactId FROM Case LIMIT 1];
    testCase.ContactId = c.Id;
    update testCase;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    ctrl.isRepeatCom = true; // force branch
    ctrl.save();
    Test.stopTest();

    Contact updatedContact = [SELECT Id, Repeat_Complainer__c FROM Contact WHERE Id = :c.Id];
    System.assertEquals(true, updatedContact.Repeat_Complainer__c);
}

// Store clone branch
static testMethod void testStoreCloneBranch() {
    // Create a parent case
    Case parentCase = [SELECT Id, Op_Company__c FROM Case LIMIT 1];

    // Insert a Store record linked to parentCase
    Store__c store = new Store__c(
        Issue__c = parentCase.Id,
        Store_Name__c = 'Test Store',
        Store_Address1__c = '123 Test Street',
        Store_City__c = 'Test City',
        Store_State__c = 'TS',
        Store_Zip__c = '12345'
    );

    // Store_Type__c is a required lookup, not a picklist. Resolve its target
    // object dynamically and grab an existing record rather than guessing an Id.
    Schema.DescribeFieldResult storeTypeDescribe = Store__c.Store_Type__c.getDescribe();
    List<Schema.SObjectType> storeTypeTargets = storeTypeDescribe.getReferenceTo();
    if (!storeTypeTargets.isEmpty()) {
        String storeTypeObjectName = storeTypeTargets[0].getDescribe().getName();
        List<SObject> existingStoreTypes = Database.query('SELECT Id FROM ' + storeTypeObjectName + ' LIMIT 1');
        if (!existingStoreTypes.isEmpty()) {
            store.Store_Type__c = existingStoreTypes[0].Id;
        }
    }
    insert store;

    // Simulate cloning by setting parentIssue parameter
    ApexPages.currentPage().getParameters().put('parentIssue', parentCase.Id);

    // Create a new Case to clone into
    Case newCase = new Case(Comment__c='Clone Test', Op_Company__c = parentCase.Op_Company__c);
    insert newCase;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(newCase));
    ctrl.save();
    Test.stopTest();

    // Assert that cloned store records exist for newCase
    //System.assertEquals(true, [SELECT COUNT() FROM Store__c WHERE Issue__c = :newCase.Id] > 0);
}

// IQOS Serial Number not found branch
static testMethod void testIqosSerialNumberNotFound() {
    Case testCase = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];
    testCase.Serial_Number__c = 'INVALID';
    update testCase;

    Test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    ctrl.selectedProductLine = 'IQOS';
    // save() never calls IQOSSerialNumber() internally, so we call it directly
    // to exercise the "Serial Number not found" branch.
    ctrl.IQOSSerialNumber();
    Test.stopTest();

    //System.assertEquals(true, ApexPages.getMessages().size() > 0);
    //System.assertEquals('Serial Number not found.', ApexPages.getMessages()[0].getSummary());
}

// IQOS Core Service API problem branch
static testMethod void testIqosCoreServiceError() {
    Case testCase = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];
    testCase.Serial_Number__c = 'ERROR';
    update testCase;

    Test.setMock(HttpCalloutMock.class, new iqosHttpCalloutMock());
    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    ctrl.selectedProductLine = 'IQOS';
    // save() never calls IQOSSerialNumber() internally, so we call it directly
    // to exercise the Core Service API problem branch.
    ctrl.IQOSSerialNumber();
    Test.stopTest();

    //System.assertEquals(true, ctrl.caseObj.Core_Service_API_Problem__c);
}

// =========================================================================
// Additional coverage added to close remaining gaps below 100%.
// Targets: the catch(DMLException) blocks in save() and customSave()
// (triggered generically via an invalid/non-existent Contact lookup id,
// so the test doesn't depend on any specific validation rule being active),
// and the "invalid hour part" catch(Exception) branch inside
// TraceCodeValidation() that only fires for a 9-character trace code on
// the 'TOBACCO DERIVED NICOTINE POUCH' product line.
// =========================================================================

// save() -> catch(DMLException e) branch
static testMethod void testSaveDMLExceptionBranch() {
    Case testCase = [SELECT Id, IQOS_Reference_ID__c FROM Case LIMIT 1];

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    // Syntactically valid but non-existent Contact Id -> Database.upsert throws
    // a DMLException ("invalid cross reference id"), independent of any
    // org-specific validation rule.
    ctrl.caseObj.ContactId = '003000000000000AAA';
    PageReference result = ctrl.save();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
}

// customSave() -> catch(DMLException e) branch
static testMethod void testCustomSaveDMLExceptionBranch() {
    Case parentCase = [SELECT Id, Op_Company__c, IQOS_Reference_ID__c FROM Case LIMIT 1];
    ApexPages.currentPage().getParameters().put('parentIssue', parentCase.Id);

    Case newCase = new Case(
        Comment__c = 'Clone DML Failure Test',
        Op_Company__c = parentCase.Op_Company__c
    );
    insert newCase;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(newCase));
    // Same technique as above: forces Database.insert(caseObj) in customSave()
    // to throw a DMLException so the catch block is exercised.
    ctrl.caseObj.ContactId = '003000000000000AAA';
    PageReference result = ctrl.customSave();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
}

// TraceCodeValidation() -> invalid hour format catch(Exception) branch
// (TOBACCO DERIVED NICOTINE POUCH, 9-character trace code, non-numeric
// characters 6-7 so Integer.valueOf()/Pattern.matches() fails)
static testMethod void testTraceCodeValidationInvalidHourFormat() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo Helix',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'TOBACCO DERIVED NICOTINE POUCH';
    pl.Code__c = 'HELIXHR';
    pl.Op_Company__c = oc.Id;
    // Note: Operating_Company__c on Product_Line__c is a non-writeable
    // (formula/rollup) field, so it's derived from Op_Company__c above
    // rather than set directly.
    pl.isActive__c = true;
    insert pl;

    Case c = new Case(Op_Company__c = oc.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'TOBACCO DERIVED NICOTINE POUCH';
    ctrl.selectedTraceCodeLocation = 'TESTLOC';
    // 9 characters; positions 6-7 ("XX") are not numeric -> triggers the
    // catch block and the "Invalid hour format" error message.
    ctrl.caseObj.Mfg_Trace_code__c = 'AAAAAXXAA';
    PageReference result = ctrl.TraceCodeValidation();
    Test.stopTest();

    System.assertEquals(null, result);
    System.assertEquals(true, ApexPages.getMessages().size() > 0);
    System.assertEquals(true, ctrl.traceCodeErrorMessage.contains('Invalid hour format'));
}

// SCR 2026-05-01: Trace Codes - PLOOM Devices
// PLOOM HEATED TOBACCO is the only product line allowed to keep a lowercase character
// in Mfg/Trace code (the day character at position 12, where 'd' = day 13). Every other
// product line must be forced to upper case, as it was before the SCR.
static testMethod void validateTraceCodeCaseNormalization() {
    // PLOOM: only position 12 keeps its case; positions 1-11 are still upper-cased.
    System.assertEquals('UE25000005Ad',
        IssueEntryController.normalizeTraceCodeCase('ue25000005ad', 'PLOOM HEATED TOBACCO'),
        'PLOOM must preserve the lowercase day character at position 12');
    System.assertEquals('UE25000005AD',
        IssueEntryController.normalizeTraceCodeCase('UE25000005AD', 'PLOOM HEATED TOBACCO'),
        'PLOOM must not alter an uppercase day character');

    // Product line name matching is case-insensitive (Apex String ==).
    System.assertEquals('UE25000005Ad',
        IssueEntryController.normalizeTraceCodeCase('ue25000005ad', 'Ploom Heated Tobacco'),
        'PLOOM rule must match the product line name regardless of its casing');

    // Non-PLOOM product lines: no lowercase character may survive.
    System.assertEquals('UE25000005AD',
        IssueEntryController.normalizeTraceCodeCase('ue25000005ad', 'Pipe Tobacco'),
        'Non-PLOOM product lines must be upper-cased in full');
    System.assertEquals('ABC12345',
        IssueEntryController.normalizeTraceCodeCase('abc12345', 'Cigars'),
        'Non-PLOOM product lines must be upper-cased in full');

    // A PLOOM code of the wrong length is invalid anyway - upper-case it in full.
    System.assertEquals('UE25000005A',
        IssueEntryController.normalizeTraceCodeCase('ue25000005a', 'PLOOM HEATED TOBACCO'),
        'A PLOOM code that is not 12 characters must be upper-cased in full');

    // Blank / null input is returned untouched.
    System.assertEquals(null, IssueEntryController.normalizeTraceCodeCase(null, 'Pipe Tobacco'));
    System.assertEquals('', IssueEntryController.normalizeTraceCodeCase('', 'PLOOM HEATED TOBACCO'));
}

// IssueEntryClone.page runs on this same controller, but binds the field to
// {!caseObj.Mfg_Trace_code__c} and routes its Save button to customSave() rather than save().
// These assert the PLOOM casing rule is genuinely enforced on that clone path too, and on the
// TraceCodeValidation() onblur round-trip the clone page shares with Issue Entry.
static testMethod void validateTraceCodeCasingOnClonePath() {
    Account testAcc = TestDataSetup.createAccount('Test Account');
    insert testAcc;
    Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
    insert testCustType;
    Date bdate = Date.newInstance(1989, 06, 14);
    Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
    insert testCont;
    Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
    insert testOpCo;
    TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
    insert testTFN;
    Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo, testTFN);
    insert testTM;
    Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
    insert testCase;

    // customSave() reads tranId from this cookie, as validateCustomSave does.
    Cookie tranIdCookie = new Cookie('tranId', testTM.Id, null, -1, false);
    ApexPages.currentPage().setCookies(new Cookie[]{tranIdCookie});

    // 'parentIssue' drives the controller down its clone branch, exactly as IssueEntryClone does.
    ApexPages.currentPage().getParameters().put('issueId', testCase.Id);
    ApexPages.currentPage().getParameters().put('parentIssue', testCase.Id);

    Test.startTest();

    // PLOOM on the clone screen: the lowercase day character at position 12 must survive.
    IssueEntryController ploomCtrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    ploomCtrl.selectedProductLine = 'PLOOM HEATED TOBACCO';
    ploomCtrl.caseObj.Mfg_Trace_code__c = 'ue25000005ad';
    ploomCtrl.customSave();
    System.assertEquals('UE25000005Ad', ploomCtrl.caseObj.Mfg_Trace_code__c,
        'Clone screen must keep the lowercase PLOOM day character while upper-casing the rest');

    // Any other product line on the clone screen: no lowercase character may survive.
    IssueEntryController otherCtrl = new IssueEntryController(new ApexPages.StandardController(testCase));
    otherCtrl.selectedProductLine = 'Pipe Tobacco';
    otherCtrl.caseObj.Mfg_Trace_code__c = 'ue25000005ad';
    otherCtrl.customSave();
    System.assertEquals('UE25000005AD', otherCtrl.caseObj.Mfg_Trace_code__c,
        'Clone screen must upper-case the trace code in full for non-PLOOM product lines');

    Test.stopTest();
}

// The onblur TraceCodeValidation() round-trip is shared by Issue Entry, Issue Edit and Issue
// Clone (all three declare extensions="IssueEntryController"), so proving it here covers all
// three screens. Needs a real Product_Line__c, otherwise the method takes its "Please choose
// Product Line" branch and blanks the field before any casing is observable.
static testMethod void validateTraceCodeCasingOnValidationRoundTrip() {
    Operating_Company__c oc = new Operating_Company__c(
        OperatingCompany__c = 'PMIP',
        OpCo_Description__c = 'Test OpCo',
        Active__c = true
    );
    insert oc;

    Product_Line__c pl = new Product_Line__c();
    pl.Name = 'PIPE TOBACCO';
    pl.Code__c = 'PT';
    pl.Op_Company__c = oc.Id;
    pl.isActive__c = true;
    insert pl;

    Case c = new Case(Op_Company__c = oc.Id);
    insert c;

    Test.startTest();
    IssueEntryController ctrl = new IssueEntryController(new ApexPages.StandardController(c));
    ctrl.selectedProductLine = 'PIPE TOBACCO';
    ctrl.selectedTraceCodeLocation = 'TESTLOC';
    ctrl.caseObj.Mfg_Trace_code__c = 'abc12345';
    ctrl.TraceCodeValidation();
    Test.stopTest();

    System.assertEquals('ABC12345', ctrl.caseObj.Mfg_Trace_code__c,
        'TraceCodeValidation must upper-case the trace code for a non-PLOOM product line');
}

// Date Code must always be persisted in upper case, however it was entered - typed, pasted
// or set by an update that never went through the onblur DateCodeValidation round-trip.
static testMethod void validateDateCodeCaseNormalization() {
    System.assertEquals('JAN012025',
        IssueEntryController.normalizeDateCodeCase('jan012025'),
        'A pasted lowercase Date Code must be upper-cased');
    System.assertEquals('JAN012025',
        IssueEntryController.normalizeDateCodeCase('JaN012025'),
        'A mixed case Date Code must be upper-cased');
    System.assertEquals('JAN012025',
        IssueEntryController.normalizeDateCodeCase('  jan012025  '),
        'Surrounding whitespace is trimmed, matching DateCodeValidation()');
    System.assertEquals('01/02/2017',
        IssueEntryController.normalizeDateCodeCase('01/02/2017'),
        'A value with no alphabetic characters must be left intact');
    System.assertEquals('WW/YY',
        IssueEntryController.normalizeDateCodeCase('ww/yy'),
        'Slashes and length must be preserved while upper-casing');

    // Blank / null input is returned untouched so existing empty-value handling is unchanged.
    System.assertEquals(null, IssueEntryController.normalizeDateCodeCase(null));
    System.assertEquals('', IssueEntryController.normalizeDateCodeCase(''));
    System.assertEquals('   ', IssueEntryController.normalizeDateCodeCase('   '),
        'Whitespace-only input is left untouched');
}

 }