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
test class of Reimbursement Edit Controller
07/18/2016 Infogain – Created.
*/

@isTest 
private class ReimbursementEditControllerTest {

    // Testing constructor of ReimbursementEditControllerTestClass controller
    static testMethod void validateValidationBeforeReimbursement() { 
                  
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852.0);
       insert tempReimb;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.validationBeforeReimbursement();
       Test.stopTest();
       system.assertEquals(null,controller.reimId);

    }
   // Testing validationBeforeReimbursement method of ReimbursementEditControllerTestClass controller
   static testMethod void validateReimbursementEditController2() {
      
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852.0);
       insert tempReimb;     
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       ApexPages.currentPage().getParameters().put('id',tempReimb.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.validationBeforeReimbursement();
       Test.stopTest();
       system.assertEquals(null,controller.reimId);

    }
        // Testing submit method of if condition ReimbursementEditControllerTestClass controller
    static testMethod void validateSubmitMethodAgeVerified() {
        
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852.0);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.submit();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
    
    
    //Testing submit method of else condition ReimbursementEditControllerTestClass controller
    static testMethod void validateSubmitMethodReimb() {
    
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        
        
        Reason__c testreason= TestDataSetup.createReason('test desc');
        insert testreason;
        Cause__c testCause= TestDataSetup.createCause('Test Desc');
        insert testCause;
        Group__c testGroup= TestDataSetup.createGroup('Test Desc');
        insert testGroup;
        Issue_Type__c testIT= TestDataSetup.createIT('Test Desc');
        insert testIT;
        Product_Line__c testPL= TestDataSetup.createPL('PL Name','PL Code', testOpCo);
        insert testPL;
        Classification__c testClassify = TestDataSetup.createClassify('Test Desc');
        insert testClassify;
        
        Issue_Hierarchy__c testIH= TestDataSetup.createIH(testClassify, testPL, testIT, testGroup, testCause,testreason, true);
        insert testIH;
        
        Brand__c testBrand= TestDataSetup.createBrand('Test Desc', 'Test Code', testPL, testOpCo);
        insert testBrand;
        
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        
        Case testCase = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id,testBH,testIH,testPL);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, -1);
       
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
        
        controller.submit();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
    

        // Testing submit method of else condition ReimbursementEditControllerTestClass controller
    static testMethod void validateSubmitMethodAgeNotVerified() {
        
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.submit();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
        // Testing submit method of validation condition ReimbursementEditControllerTestClass controller
   static testMethod void validateSubmitMethodCheckAmount() {
   
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Id id=ApexPages.currentPage().getParameters().put('id',tempReimb.Id);
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.submit();
       Test.stopTest();
       System.AssertEquals(null,Id);
    }
    
     static testMethod void validateCheckAmount() {
     
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,false,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Service_Code_Mapping__c s = TestDataSetup.createSerCode('CRC', 'CREATE_REIMB');
        insert s;
         Service_Code_Mapping__c s1 = TestDataSetup.createSerCode('Correspondence', 'CORSP_OUTBOUND');
        insert s1;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        DocumentType__c d = TestDataSetup.createDoc('test', 'Outbound', 'test', 'test', 'test', testOpCo, 'test');
        d.isActive__c = true;
        d.isReimbursement__c = true;
        insert d;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
        Cookie cookie = new Cookie('tranid', testTM.id, null, -1, false);
       ApexPages.currentPage().setCookies(new Cookie[]{cookie});
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.reimbursement.Cheque_Amount__c = 2;   
       controller.submit();
       testCont.AVF_GIID_Received__c = true;
       update testCont;  
       Test.stopTest();
    }   
         // Testing cancel method of if condition ReimbursementEditControllerTestClass controller
    static testMethod void validateCancelMethod() {
    
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('Id',tempReimb.Id); 
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.cancel();
       Test.stopTest();
       System.AssertEquals(tempReimb.Id,controller.reimId);
      
    }
         // Testing cancel method of else condition ReimbursementEditControllerTestClass controller
   static testMethod void validateCancelMethodelse() {
       
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       PageReference pageref = controller.cancel();
       controller.cancel();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
          // Testing cancel method of elseif condition ReimbursementEditControllerTestClass controller
    static testMethod void validateCancelMethodelseElseif() {
       
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.cancel();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
    static testMethod void validateCancelRedirect() {
        
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
       insert testCont;
       Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
       Reimbursement__c tempReimb = new Reimbursement__c();
       tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
       insert tempReimb;
       ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
       Test.startTest();
       ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
       controller.CancelRedirect();
       Test.stopTest();
       System.AssertEquals(null,controller.reimId);
    }
    
    static testMethod void assignValue() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Reimbursement__c tempReimb = new Reimbursement__c();
        tempReimb = TestDataSetup.createReimbursement(testCase, 4852);
        insert tempReimb;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        Test.startTest();
        ReimbursementEditController controller = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
        controller.assignValue();
        Test.stopTest();
        System.AssertEquals(true,controller.showReimbAddtl);
    }
}