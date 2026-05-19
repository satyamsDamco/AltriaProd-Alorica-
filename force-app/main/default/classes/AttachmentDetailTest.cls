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
Test Class for AttachmentDetail Controller
09/08/2016 Infogain – Created.
*/

@isTest
public class AttachmentDetailTest
 {
    // validate editPage method
    public static testmethod void editPageTest(){
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
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
         ApexPages.currentPage().getParameters().put('Id',attachment.Id);
         Test.startTest();
         AttachmentDetail controller=new AttachmentDetail(new ApexPages.StandardController(attachment));
         controller.editPage();
         Test.stopTest();
         //Assertions
         system.assertEquals(attachment.Name,'test name');
     }
     
     // Validate  AttachmentDetail method
     public static testmethod void AttachmentDetailTest()
      {
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
         //ApexPages.StandardController sc = new ApexPages.standardController(attachment);
         Test.startTest();
         AttachmentDetail controller=new AttachmentDetail(new ApexPages.StandardController(attachment));
         //controller.AttachmentDetail();
          Test.stopTest();
          //Assertions
          system.assertEquals(attachment.Description,'Test description');
         
       }
  }