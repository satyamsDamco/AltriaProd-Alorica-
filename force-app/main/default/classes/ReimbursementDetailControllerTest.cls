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
Test Class for Reimbursement Detail Controller
06/29/2016 Infogain – Created.
*/

@isTest
private class ReimbursementDetailControllerTest {
    
    //Validate updateStatus method if Age Verified
    static testMethod void validateReimbursementDetailController1() {
        
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
        ApexPages.currentPage().getParameters().put('Id',tempReimb.Id); 
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
            ReimbursementDetailController controller = new ReimbursementDetailController(new ApexPages.StandardController(tempReimb));
            controller.updateStatus();
        Test.stopTest();
        
           
    }
    
    //Validate updateStatus method if Age Not Verified
    static testMethod void validateReimbursementDetailController2() {
        
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
        ApexPages.currentPage().getParameters().put('issueId',testCase.id);
        ApexPages.currentPage().getParameters().put('Id',tempReimb.Id); 
        ReimbursementEditController obj = new ReimbursementEditController(new ApexPages.StandardController(tempReimb));
        obj.submit();
           
        Test.startTest();
            ReimbursementDetailController controller = new ReimbursementDetailController(new ApexPages.StandardController(tempReimb));
            controller.updateStatus();
        	//Added 5/5/2020
            controller.assignValue();
        Test.stopTest();
		//Assertions
        System.AssertEquals(False,controller.isCorrespondenceReq);
        System.AssertEquals(true,controller.showReimbAddtl);
    }	
}