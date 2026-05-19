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
test class of issue survey list
11/07/2016 Infogain – Created.
*/
@isTest
public class IssueSurveyListControllerTest {

//Validate IssueSurveyListController Constructor.
    static testMethod void validateIssueSurveyListConstructor() {
        
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
        ApexPages.currentPage().getParameters().put('Id',testCase.Id); 
        Test.startTest();
            IssueSurveyListController controller = new IssueSurveyListController(new ApexPages.StandardController(testCase));
        Test.stopTest();
    }
    
    //Validate IssueSurveyListController Constructor.
    static testMethod void validateIssueSurveyListConstructor1() {
        
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
        ApexPages.currentPage().getParameters().put('id',testCase.Id);
        Test.startTest();
            IssueSurveyListController controller = new IssueSurveyListController();
        Test.stopTest();
    }
    
    //Validate previous,next, Cancel method.
    static testMethod void validateIssueReviewGetIssueReviewList() {
        
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
        Question__c testQuest = TestDataSetup.createQuestion('Test Question', '1234','testType');
        insert testQuest;
        Answer__c testAns = TestDataSetup.createAnswer('Answer', '1234');
        insert testAns;
        Survey__c testSurvey = TestDataSetup.createSurvey('Test Survey');
        insert testSurvey;
        Survey_Issue__c testSurvIssue = TestDataSetup.createSurveyIssue(testAns, testQuest, testSurvey, testCase);
        //testSurvIssue.isReviewed__c = False;
        testSurvIssue.Transaction__c = testTM.id;
        insert testSurvIssue;
        ApexPages.currentPage().getParameters().put('pagesize','25');
        ApexPages.currentPage().getParameters().put('Id',testCase.Id); 
        Test.startTest();
            IssueSurveyListController controller = new IssueSurveyListController(new ApexPages.StandardController(testCase));
            controller.previous();
            controller.next();
            List<Survey_Issue__c> sissue = controller.getIssueSurvyeList();
            controller.cancel();
        Test.stopTest();
    }
}