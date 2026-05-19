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
Test Class for ConsumerAgeVerificationController
07/19/2016 Infogain – Created.
*/
@isTest
public class ConsumerAgeVerificationControllerTest {
    // validate getcitystate method
    public static testmethod void getcitystateTest(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Zip_Code__c='12345';
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        /* If this is the first time the user is accessing the page, 
           create a new cookie with name 'counter', an initial value of '1', 
           path 'null', maxAge '-1', and isSecure 'false'. */
        
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        /* If this isn't the first time the user is accessing the page
           create a new cookie, incrementing the value of the original count by 1
           Set the new cookie for the page*/
        
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('City',testCont.Id);
        Test.startTest();
            ConsumerAgeVerificationController controller=new ConsumerAgeVerificationController(new ApexPages.StandardController(testCont));
            controller.getcitystate();
        Test.stopTest();
        system.assertEquals(testCont.FirstName, 'Test Fname');
           }  
    
    // validate zip code for getcitystate method
    public static testmethod void getcitystateTest1(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Zip_Code__c='12345';
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        /* If this is the first time the user is accessing the page, 
           create a new cookie with name 'counter', an initial value of '1', 
           path 'null', maxAge '-1', and isSecure 'false'.*/ 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        /* If this isn't the first time the user is accessing the page
           create a new cookie, incrementing the value of the original count by 1
           Set the new cookie for the page*/
        
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('zipLookup',testCont.Id);
        
        Test.startTest();
        ConsumerAgeVerificationController controller=new ConsumerAgeVerificationController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
          system.assertEquals(testCont.LastName,'Test Lname');
    }
    
    //Comments - TBD
    public static testmethod void getcitystateTest2(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'ABC',bdate,'Test Street', true, true);
        testCont.Zip_Code__c='12345';
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        /* If this is the first time the user is accessing the page, 
           create a new cookie with name 'counter', an initial value of '1', 
           path 'null', maxAge '-1', and isSecure 'false'.*/
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        /* If this isn't the first time the user is accessing the page
           create a new cookie, incrementing the value of the original count by 1
           Set the new cookie for the page. */
           
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('zipcode',testCont.Id);
        Test.startTest();
        ConsumerAgeVerificationController controller=new ConsumerAgeVerificationController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        system.assertEquals(testCont.LastName,'Test Lname');
    }
    
    // validate reset method
    public static testmethod void resetTest(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Test.startTest();
            ConsumerAgeVerificationController controller=new ConsumerAgeVerificationController(new ApexPages.StandardController(testCont));
            controller.reset();
        Test.stopTest();
        system.assertEquals(testCont.FirstName, 'Test Fname');
     }
          
     // validate ageVerify method
     public static testmethod void ageVerifyTest()
     {
        test.setMock(HttpCalloutMock.class, new lexisNexisHttpCalloutMock());   
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CCN__c = '1234';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Transaction_Management_History__c testTMHis= TestDataSetup.createTMHis('CRC', testTM, 'endcall');
        insert testTMHis;
         list<Service_Code_Mapping__c> lstSerCode = new  list<Service_Code_Mapping__c>();
        Service_Code_Mapping__c testSerCode= TestDataSetup.createSerCode('CRCAGEVERIFYRQ','AGE_VERIFICATION_REQUEST');
        lstSerCode.add(testSerCode);
        Service_Code_Mapping__c testSerCode1= TestDataSetup.createSerCode('CRC','AGE_VERIFY');
         lstSerCode.add(testSerCode1);
        insert lstSerCode;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         
        LexisNexis_Integration__c lx = new LexisNexis_Integration__c();
        lx.EndPointURL__c = 'test.com';
        lx.Password__c = 'test123';
        lx.User_Id__c = 'TTest';
        lx.Workflow_Name__c = 'NewWW';
        lx.Name = 'PMUSA';
        
        insert lx;
        
                        
    
        /* If this is the first time the user is accessing the page, 
           create a new cookie with name 'counter', an initial value of '1', 
           path 'null', maxAge '-1', and isSecure 'false'. */
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
            

        /* If this isn't the first time the user is accessing the page
           create a new cookie, incrementing the value of the original count by 1
           Set the new cookie for the page*/
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        Test.startTest();
            ConsumerAgeVerificationController controller=new ConsumerAgeVerificationController(new ApexPages.StandardController(testCont));
            controller.ageVerify();
        Test.stopTest();
        system.assertEquals(testCont.AVF_GIID_Received__c, true);
    }          
}