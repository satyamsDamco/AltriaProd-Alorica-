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
test class of Store Edit Controller
07/18/2016 Infogain – Created.
*/

@isTest
private class StoreEditControllerTest {
    static testMethod void validateStoreEditController1() {
    
    // Testing constructor of StoreEditControllerTest controller
    Store_List__c  strList = TestDataSetup.createStoreList('Test Store Name');
    insert strList;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
   Test.startTest();
   StoreEditController obj=  new StoreEditController();
   Test.stopTest();
   system.assertEquals(true,obj.customStoreNameList.size() > 0);
}
static testMethod void validateStoreEditController2() {

    // Testing constructor of StoreEditControllerTest controller
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
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   Test.stopTest();
   system.assertEquals(storeTest.Store_Type__c,obj.selectedStoreType);
   system.assertEquals(obj.issueId,null);
}
     // Testing getStoreType method of StoreEditControllerTest controller
   static testMethod void validategetStoreType() {
   
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
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.getStoreType();
   Test.stopTest();
    system.assertEquals(storeTest.Store_Type__c,obj.selectedStoreType);
   system.assertEquals(obj.issueId,null);
}
       // Testing submitStore method of StoreEditControllerTest controller
    static testMethod void validatesubmitStore() {
    
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
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.submitStore();
   Test.stopTest(); 
    system.assertEquals(obj.selectedStoreType,storeTest.Store_Type__c);
}
        // Testing saveNew method of StoreEditControllerTest controller
     static testMethod void validatesaveNew() {
     
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
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.saveNew();
   Test.stopTest();
   system.assertEquals(null,obj.selectedStoreType);
   system.assertEquals(null,obj.issueId);
}
      // Testing startTest method of StoreEditControllerTest controller
    static testMethod void validatePageMessage() {
    
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
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Test Message'));        
   Test.startTest();
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.saveNew();
   Test.stopTest();
   } 
       // Testing saveNew method of StoreEditControllerTest controller
   static testMethod void validatesaveNew2() {
   
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
   Store__c storeTest = TestDataSetup.createStore('IssueId',storeTypeTest);
   ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
   Test.startTest();
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.saveNew();
   Test.stopTest();
      system.assertEquals(obj.selectedStoreType,null);

}
    
     static testMethod void validateCancelRedirect() {
     
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
   Store__c storeTest = TestDataSetup.createStore('IssueId',storeTypeTest);
   ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
   Test.startTest();
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.CancelRedirect();
   Test.stopTest();
      system.assertEquals(obj.selectedStoreType,null);

}
    
    static testMethod void validateGetCityState() {
    
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
   Store__c storeTest = TestDataSetup.createStore('IssueId',storeTypeTest);
        storeTest.Store_Zip__c = '123456';
        insert storeTest;
   ApexPages.currentPage().getParameters().put('IssueId',testCase.Id); 
   Test.startTest();
   StoreEditController obj=  new StoreEditController(new ApexPages.StandardController(storeTest));
   obj.getCityState();
   Test.stopTest();
   

}
}