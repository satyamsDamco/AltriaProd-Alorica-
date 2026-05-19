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
public class IssueReviewDetailControllerTest {

    // Testing constructor and checkMultipleReimbursements method when there is no reimbursement record created for the Issue
    // of IssueReviewDetailControllerTest controller
    static testMethod void validateIssueReviewDetailControllerNoReimbursement() {
        
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','cn');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    
    // Testing constructor and checkMultipleReimbursements method when there is a reimbursement record created for the Issue
    // of IssueReviewDetailControllerTest controller
    static testMethod void validateIssueReviewDetailController() {
        
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
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    
    // Testing custom clone method of IssueReviewDetailControllerTest controller
    static testMethod void validateSetReview() {
        
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
        Transaction_Management_History__c testTMHis= TestDataSetup.createTMHis('CRC', testTM, 'endcall');
        insert testTMHis;
        Service_Code_Mapping__c testSerCode= TestDataSetup.createSerCode('APPROVALS','ISSUE_APPROVED');
        insert testSerCode;
        ApexPages.currentPage().getParameters().put('id',testCase.Id); 
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
            controller.setReview();
        Test.stopTest();
        //system.assertEquals(testCase.purchase_price__c,1200);
    }
    static testMethod void sortExpression_bc(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','bc');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_pl(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','pl');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_re(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','re');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_cs(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','cs');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_contn(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','contn');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_cl(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','cl');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    static testMethod void sortExpression_ca(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','ca');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    
    
    static testMethod void validateGenerateLineValue(){
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
        testCase.IsReviewed__c = true;
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id); 
        ApexPages.currentPage().getParameters().put('sortDirection','asc');
        ApexPages.currentPage().getParameters().put('sortExpression','contn');
        Test.startTest();
            IssueReviewDetailController controller = new IssueReviewDetailController(new ApexPages.StandardController(testCase));
        	testCase.DateCodeUnit__c = 'L';
        	testCase.Mfg_Trace_code__c = 'H025L1434';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'U';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'J';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'N';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'P';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'E';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeRptFactory__c = 'MC_USSTC';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeRptFactory__c = 'PMIP';
        	controller.generateLineValue(testCase);
        	testCase.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        	testCase.DateCodeUnit__c = 'U';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'J';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'N';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'P';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'E';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeUnit__c = 'XXX';
        	controller.generateLineValue(testCase);
        	testCase.DateCodeRptFactory__c = 'MC_JMC';
        	testCase.Mfg_Trace_code__c = '999999999';
        	testCase.DateCodeUnit__c = 'K';
        	controller.generateLineValue(testCase);
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('K');
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('G');
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('T');
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('Y');
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('Z');
        	controller.generateLineValueDateCodeRptFactoryMCUSSTC('XXX');
        
        	
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('A');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('B');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('C');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('E');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('H');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('I');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('L');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('M');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('N');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('P');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('R');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('S');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('V');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('2');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitNumber('XXX');
        
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('E');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('H');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('I');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('L');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('N');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('S');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('V');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('2');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('3');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('4');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('5');
        	controller.generateLineValueDateCodeRptFactoryNSDateCodeUnitAlpha('XXX');
        
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('A');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('B');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('G');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('I');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('J');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('K');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('M');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('O');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('P');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Y');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('R');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('W');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('X');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Z');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('XXX');
        
        
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('E');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('F');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('G');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('J');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('K');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('M');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('0');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('W');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('X');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('Y');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('Z');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('XXX');
        
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('A');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('B');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('G');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('I');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('J');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('K');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('M');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('O');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('P');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Y');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('R');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('W');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('X');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Z');
        	controller.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('XXX');
        
        	controller.checkIsAlpha('A');
        	controller.checkIsNumber('5');

        Test.stopTest();
    }
}