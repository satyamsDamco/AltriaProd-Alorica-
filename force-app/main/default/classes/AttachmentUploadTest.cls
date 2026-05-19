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
  Test Class for AttachmentUpload Controller
  09/13/2016 Infogain – Created.
   */

@isTest
public class AttachmentUploadTest
{
    // validate updateAttachment method 
    public static testmethod void updateAttachmentTest(){
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
        
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;
        Attachment_Detail__c testAttDet = TestDataSetup.createAttachmentDet('Test Describe', 'Test File', testCase, attachment.id);
        testAttDet.IsActive__c = True;
        insert testAttDet;
        ApexPages.currentPage().getParameters().put('id',attachment.Id);
        //ApexPages.currentPage().getParameters().put('Comment: Max. 500 character are allowed.',attachment.Id);
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.updateAttachment();
        Test.stopTest();
        //Assertions
        system.assertEquals(attachment.Name,'test name');
    }
    
    // validate cancelButton method
     public static testmethod void cancelButtonTest(){
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
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        insert attachment;
        ApexPages.currentPage().getParameters().put('Id',attachment.Id);
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.cancelButton();
        Test.stopTest();
        //Assertions
        system.assertEquals(attachment.Name,'test name');
    }
    // validate upload method
    public static testmethod void uploadTest(){  
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
        Blob blobValue = EncodingUtil.convertFromHex('4A4B4C');
        Attachment  attachment= TestDataSetup.createAttachment ('Test description', 'test name', testCase.id, blobValue);
        //insert attachment;
        ApexPages.currentPage().getParameters().put('issueId',testCase.Id);
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:testCase.id];
        //System.assertEquals(1, attachments.size());
        Test.startTest();
        AttachmentUpload controller=new AttachmentUpload (new ApexPages.StandardController(attachment));
        controller.upload();
        //RITM0734680 - Limit Upload Size to 5MB 
        Attachment  attachment2= TestDataSetup.createAttachment ('Test description', 'Test Size', testCase.id, blobValue);
        AttachmentUpload controller2=new AttachmentUpload (new ApexPages.StandardController(attachment2));
        controller2.upload();
        //JD - 10/22/2020 : Increasing test coverage
        Attachment  attachment3= new Attachment();
        AttachmentUpload controller3=new AttachmentUpload (new ApexPages.StandardController(attachment3));
        controller3.upload();
        Attachment  attachment4= TestDataSetup.createAttachment (null, 'Test Size', testCase.id, blobValue);
        AttachmentUpload controller4=new AttachmentUpload (new ApexPages.StandardController(attachment4));
        controller4.upload();
        Test.stopTest();
        //Assertions 
        
    }
}