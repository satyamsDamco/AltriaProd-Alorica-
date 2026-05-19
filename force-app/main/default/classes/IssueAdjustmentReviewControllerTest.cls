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
test class of issue review page
11/07/2016 Infogain – Created.
*/
@isTest
public class IssueAdjustmentReviewControllerTest {
     
    // Testing constructor and checkMultipleReimbursements method when there is no reimbursement record created for the Issue
    // of IssueReviewDetailControllerTest controller
    static testMethod void validateIssueAdjustmentReviewController() {
        
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
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('pageSize','25');
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('ReviewType','test2');
        Test.startTest();
            IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    
    // of IssueReviewDetailControllerTest controller
    static testMethod void validateSetSortDirection() {
        
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
        Reimbursement__c testReimb = TestDataSetup.createReimbursement(testCase, 12);
        insert testReimb;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        Test.startTest();
            IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
          controller.setSortDirection('value');
            Test.stopTest();
    }
    
  
    // Testing Store method of IssueReviewDetailControllerTest controller
    static testMethod void validateNext() {
        
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
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id);
        Test.startTest();
            IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
        controller.next();
        Test.stopTest();
    } 
   
    // Testing edit method of IssueReviewDetailControllerTest controller
   static testMethod void validatePrevious() {
       
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
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
        IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
        controller.previous();
        Test.stopTest();
    }
    
     static testMethod void validateGetSortDirection() {
         
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
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
        IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
        string str = controller.getSortDirection();
        Test.stopTest();
    }
    static testMethod void validateCoViewData() {
        
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
        testCase.ContactId = testCont.Id;
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
        IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
        Pagereference pgRef = controller.ViewData();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    } 
    
    // Testing custom clone method of IssueReviewDetailControllerTest controller
    static testMethod void validateGetIssueReviewList() {
        
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
        testCase.IsReviewed__c = False;
        insert testCase;
        Reimbursement__c testReimb = TestDataSetup.createReimbursement(testCase, 12);
        testReimb.isReviewed__c = False;
        insert testReimb;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ; 
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        storeTest.Issue__c = testCase.Id;
        storeTest.isReviewed__c = False;
        insert storeTest;
        Question__c testQuest = TestDataSetup.createQuestion('Test Question', '1234','testType');
        insert testQuest;
        Answer__c testAns = TestDataSetup.createAnswer('Answer', '1234');
        insert testAns;
        Survey__c testSurvey = TestDataSetup.createSurvey('Test Survey');
        insert testSurvey;
        Survey_Issue__c testSurvIssue = TestDataSetup.createSurveyIssue(testAns, testQuest, testSurvey, testCase);
        testSurvIssue.isReviewed__c = False;
        testSurvIssue.Transaction__c = testTM.id;
        insert testSurvIssue;
        /*Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;*/
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
           List<Issue_Adjustment__c> Issuelist = controller.getIssueReviewList();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    }
     static testMethod void validateGetReviewList() {     
         
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
        testCase.IsReviewed__c = False;
        insert testCase;
        Reimbursement__c testReimb = TestDataSetup.createReimbursement(testCase, 12);
        testReimb.isReviewed__c = False;
        insert testReimb;
        Store_type__c storeTypeTest = TestDataSetup.createStoreType('ST10','Other');
        insert storeTypeTest ; 
        Store__c storeTest = TestDataSetup.createStore('WallMart',storeTypeTest);
        storeTest.Issue__c = testCase.Id;
        storeTest.isReviewed__c = False;
        insert storeTest;
        Question__c testQuest = TestDataSetup.createQuestion('Test Question', '1234','testType');
        insert testQuest;
        Answer__c testAns = TestDataSetup.createAnswer('Answer', '1234');
        insert testAns;
        Survey__c testSurvey = TestDataSetup.createSurvey('Test Survey');
        insert testSurvey;
        Survey_Issue__c testSurvIssue = TestDataSetup.createSurveyIssue(testAns, testQuest, testSurvey, testCase);
        testSurvIssue.isReviewed__c = False;
        testSurvIssue.Transaction__c = testTM.id;
        insert testSurvIssue;
        /*Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;*/
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueAdjustmentReviewController controller = new IssueAdjustmentReviewController(new ApexPages.StandardController(testCase));
           List<SelectOption> Issuelist1 = controller.getReviewList();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    }
}