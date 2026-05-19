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
Test Class for Store Detail Controller
06/29/2016 Infogain – Created.
*/

@isTest
    private class StoreDetailControllerTest 
    {
     static testMethod void validateStoreDetailController1() {
        
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;

        Test.startTest();
        StoreDetailController obj=  new StoreDetailController();
        Test.stopTest();
    }

    //Validate Constructor
     static testMethod void validateStoreDetailController2()
      {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ; 
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
    Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
    insert testCase;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ; 
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        insert storeTest; 
        ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
        Test.startTest(); 
        StoreDetailController obj=  new StoreDetailController(new ApexPages.StandardController(storeTest));
        Test.stopTest();
       
    }
    
  
    //Validate Edit Store method
    static testMethod void validateEditStore()
     {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
    Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
    insert testCase;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ;
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        insert storeTest;
        ApexPages.currentPage().getParameters().put('IssueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('Id',storeTest.Id); 
        Test.startTest();
        StoreDetailController obj=  new StoreDetailController(new ApexPages.StandardController(storeTest));
        PageReference editRef = obj.editStore();
        Test.stopTest();
       
        PageReference pageRef = new PageReference('/apex/StoreEditPage?id='+storeTest.Id);
       
        //Assertions
        System.AssertEquals(pageRef.getUrl(),editRef.getUrl());
    }
    
    //Validate Edit Store method for Validation Check
    static testMethod void validateEditStoreValidationChk() 
    {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
     Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
    Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
    insert testCase;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ;
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        insert storeTest;
        ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
        Test.startTest();
        StoreDetailController obj=  new StoreDetailController(new ApexPages.StandardController(storeTest));
        obj.editStore();
        Test.stopTest();
       
        //Assertions
        System.AssertEquals(null,obj.editStore());
    }
    
    //Validate Cancel Store method If Issue Id is Null
    static testMethod void validateCancelStoreIfNull() 
    {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
     Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
    Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
    insert testCase;
        //insert testCase;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ;
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        insert storeTest;
        ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
        Test.startTest();
        StoreDetailController obj=  new StoreDetailController(new ApexPages.StandardController(storeTest));
        PageReference cancelRef = obj.CancelStore();
        Test.stopTest();
        PageReference pageRef = new PageReference('/a00/o');
        //Assertions
        System.AssertEquals(pageRef.getUrl(),cancelRef.getUrl());
    }
    
    //Validate Cancel Store method If Issue Id is not Null
    static testMethod void validateCancelStoreElse()
     {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
      Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
    Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
    insert testCase;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ;
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        storeTest.Issue__c = testCase.Id;
        insert storeTest;
        ApexPages.currentPage().getParameters().put('IssueId',testCase.Id);
        ApexPages.currentPage().getParameters().put('Id',storeTest.Id);
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+testCase.Id); 
        Test.startTest();
        StoreDetailController obj=  new StoreDetailController(new ApexPages.StandardController(storeTest));
        PageReference cancelRef = obj.CancelStore();
        Test.stopTest();
       
        //Assertions
        System.AssertEquals(pageRef.getUrl(),cancelRef.getUrl());
    }
    
}