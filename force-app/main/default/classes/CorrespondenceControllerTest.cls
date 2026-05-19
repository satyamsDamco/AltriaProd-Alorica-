@isTest
public class CorrespondenceControllerTest {


    //Validate Constructor.
    static testMethod void validateConstructor() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        testDoc.isTrade__c = True;
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.Id;
        testCor.DocType__c = testDoc.Id;
        testCor.MasterId__c = '12345';
        testCor.isReimbursement__c = True;
        insert testCor;
        Cookie tranId = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('customerRecType','Consumer',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
        Test.stopTest();
        
    }
    
   //Test method to cover validateConstructorNoCorrespondence.
    static testMethod void validateConstructorNoCorrespondence() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL2', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        testDoc.isTrade__c = True;
        testDoc.IsActive__c = True;
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        //insert testCor;
        /* checking issueid should not be null*/
        Cookie tranId = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('customerRecType','trade',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
        Test.stopTest();
        
    }
    
    //Test method to cover CancelRedirect method.
    static testMethod void validateCancelRedirect() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL3', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        testDoc.isTrade__c = false;
        testDoc.isReimbursement__c = false;
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.id;
        testCor.DocType__c = testDoc.Id;
        testCor.isReimbursement__c = True;
        insert testCor;
        /* checking issueid should not be null*/
        Cookie tranId = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('customerRecType','Consumer',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         Pagereference pgRef = controller.CancelRedirect();
        Test.stopTest();
    }
    
    //Test method to cover Clear method.
    static testMethod void validateClear() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL4', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.id;
        testCor.DocType__c = testDoc.Id;
        insert testCor;
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         customerRecType = new Cookie('customerRecType','Trade',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        PageReference pageRef = Page.CorrespondencePage;
        Test.setCurrentPage(pageRef);
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         Pagereference pgRef = controller.Clear();
        Test.stopTest();
        
    }
    
    //Test method to cover SaveRecord method.
    static testMethod void validateSaveRecord() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL5', testOpCo);
        insert testPL;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        insert testDoc;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        DocumentType__c doc = [select id,Op_Company__c
                                    from DocumentType__c 
                                    where id=: testDoc.Id Limit 1];
        testBrand.Op_Company__c = doc.Op_Company__c;
        testBrand.IsCorrespondence__c = True;
        system.debug('Test doc Opr: '+testDoc.Operating_Company__c+' Test Brand Opr: '+testBrand.Op_Company__c);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.Id;
        testCor.DocType__c = testDoc.Id;
        testCor.Brand_Corres__c  = testBrand.Id;
        testCor.BCode__c = 'test Brand';
        //insert testCor;
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         customerRecType = new Cookie('customerRecType','Consumer',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         controller.SaveRecord();
        Test.stopTest();
    } 
    
    
    //Test method to cover SaveRecord method for trade.
    static testMethod void validateSaveRecordTrade() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL5', testOpCo);
        insert testPL;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        insert testDoc;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        DocumentType__c doc = [select id,Op_Company__c
                                    from DocumentType__c 
                                    where id=: testDoc.Id Limit 1];
        testBrand.Op_Company__c = doc.Op_Company__c;
        testBrand.IsCorrespondence__c = True;
        insert testBrand;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.Id;
        testCor.DocType__c = testDoc.Id;
        testCor.Brand_Corres__c  = testBrand.Id;
        testCor.BCode__c = 'test Brand';
        insert testCor;
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         customerRecType = new Cookie('customerRecType','Trade',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         controller.SaveRecord();
        Test.stopTest();
    }
    
    
    //Test method to cover code coverage for SaveRecord.
    static testMethod void validateSaveRecordDocumentShowMaster() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL6', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        testDoc.showMasterField__c = True;
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.Id;
        testCor.DocType__c = testDoc.Id;
        insert testCor;
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         customerRecType = new Cookie('customerRecType','Consumer',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         controller.SaveRecord();
        Test.stopTest();
    }
    
    //Test method to cover code coverage for brandList method.
    static testMethod void validateBrandList() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMERS', True, 'test');
        insert testCustType;
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL7', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        //insert testCase;
        DocumentType__c testDoc = TestDataSetup.createDoc('Description', 'Outbound', 'Test Category', 'TestCode', 'FileTest', testOpCo, '123456');
        testDoc.showMasterField__c = True;
        insert testDoc;
        Correspondence_Fulfilment__c testCor = TestDataSetup.createCor('Test Letter', bdate, testBrand);
        testCor.Contact__c = testCont.Id;
        testCor.DocType__c = testDoc.Id;
        insert testCor;
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         customerRecType = new Cookie('customerRecType','trade',null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
         CorrespondenceController controller = new CorrespondenceController(new ApexPages.StandardController(testCor));
         controller.brandList();
        Test.stopTest();
    }
}