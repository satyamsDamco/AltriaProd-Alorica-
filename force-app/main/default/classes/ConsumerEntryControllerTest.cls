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
test class of Consumer Entry
08/03/2016 Infogain – Created.
*/


  @isTest()
  private class ConsumerEntryControllerTest{
      
       @testSetup
    static void setup(){
        List<Customer_Type__c> ctList = new List<Customer_Type__c>();
        Customer_Type__c testCustType = new Customer_Type__c();
        testCustType.Customer_Type__c = 'W';
        testCustType.CodeType__c = 'CUSTOMERS';
        testCustType.IsActive__c = true;
        testCustType.Description__c = 'WHOLESALER';
        ctList.add(testCustType);
        
        Customer_Type__c rCustType = new Customer_Type__c();
        rCustType.Customer_Type__c = 'RP';
        rCustType.CodeType__c = 'CUSTOMERS';
        rCustType.IsActive__c = true;
        rCustType.Description__c = 'RESEARCH PANELIST';
        ctList.add(rCustType);
        
        insert ctList;
        
        //JD: RITM0441447
        Service_Code_Mapping__c scm = new Service_Code_Mapping__c();
        scm.Name = 'UPDATECUST';
        scm.Service_Group_Code__c = 'CUSTOMERS';
        insert scm;
        
        Service_Code_Mapping__c scm2 = new Service_Code_Mapping__c();
        scm2.Name = 'EMAIL_ADDRESS_UPDATE';
        scm2.Service_Group_Code__c = 'Consumers';
        insert scm2;
        
        Service_Code_Mapping__c scm3 = new Service_Code_Mapping__c();
        scm3.Name = 'EMAIL_CONFIRMED_UPDATE';
        scm3.Service_Group_Code__c = 'Consumers';
        insert scm3;
        //JD: RITM0441447 - end
    }
  //  Validate Constructor
   static testMethod void validateConsumerEntryController()
    {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Email = 'test123@test.com';
        testCont.AV_Code__c = 'Verified';
        testCont.Company_Name__c = 'XYZ';
        testCont.DBA_Name__c = 'DBATest';
        testCont.Account_No__c = '12345';
        testCont.Retail_control__c = '34567';
        testCont.Phone = '1234567890';
        testCont.Territory__c = 'xyz';
        testCont.CustomerType__c = 'c';
        testCont.Birthdate1__c = Date.valueOf('1990-01-01');
        //testCont.CustomerType1__c = 'c';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
         ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
         ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
         ApexPages.currentPage().getParameters().put('email',testCont.Email);
         ApexPages.currentPage().getParameters().put('dob',String.valueOf(testCont.Birthdate1__c));
        ApexPages.currentPage().getParameters().put('avcode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('comname',testCont.Company_Name__c);
        ApexPages.currentPage().getParameters().put('agentname',testCont.Company_Name__c);
        ApexPages.currentPage().getParameters().put('DBA',testCont.DBA_Name__c);
        ApexPages.currentPage().getParameters().put('accountNo',testCont.Account_No__c);
        ApexPages.currentPage().getParameters().put('retail',testCont.Retail_control__c);
        ApexPages.currentPage().getParameters().put('fSphone',testCont.Phone);
        ApexPages.currentPage().getParameters().put('territory',testCont.Territory__c);
        Customer_Type__c testCustType = TestDataSetup.createCustType('C', 'CONSUMER', true, 'Test Description');
         insert testCustType;
        ApexPages.currentPage().getParameters().put('custType',testCustType.Customer_Type__c);
        ApexPages.currentPage().getParameters().put('custType1',testCustType.id);
        Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.init();
         controller.cancelRedirect();
         Test.stopTest();
        // System.assertEquals('Fname', controller.conObj.FirstName );
     }
     
     static testMethod void validateConsumerEntryController2()
    {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Customer_Type__c testCustType = [Select Id, Customer_Type__c ,Description__c from Customer_Type__c where Description__c = 'RESEARCH PANELIST'];
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Email = 'test123@test.com';
        testCont.AV_Code__c = 'Verified';
        testCont.Company_Name__c = 'XYZ';
        testCont.DBA_Name__c = 'DBATest';
        testCont.Account_No__c = '12345';
        testCont.Retail_control__c = '34567';
        testCont.Phone = '1234567890';
        testCont.Territory__c = 'xyz';
        testCont.CustomerType__c = 'RESEARCH PANELIST';
        testCont.CustomerType1__c = testCustType.id;
        testCont.Study_ID__c = 'si';
        testCont.Research_Location__c ='RL|';
        testCont.CustomerID__c = '1234';
        testCont.Project_Flavor_Type__c = 'Mint|';
        testCont.Research_Panelist_Name__c = 'RPN|';
        testCont.Research_Company__c = 'RC|';
        testCont.Blinding_Code__c = 'BC|';
        testCont.Participant_ID__c = 'PI|   assd';
        testCont.Research_Panelist_Notes__c = 'rpnotes|';
        testCont.Research_Panelist_Address__c = 'rpa|';
        testCont.Participation_Date__c = 'pd|';
        testCont.Salutation = 'Mr.';
        insert testCont;
        
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
         ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
         ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
         ApexPages.currentPage().getParameters().put('email',testCont.Email);
         ApexPages.currentPage().getParameters().put('dob',String.valueOf(testCont.Birthdate1__c));
        ApexPages.currentPage().getParameters().put('avcode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('comname',testCont.Company_Name__c);
        ApexPages.currentPage().getParameters().put('agentname',testCont.Company_Name__c);
        ApexPages.currentPage().getParameters().put('DBA',testCont.DBA_Name__c);
        ApexPages.currentPage().getParameters().put('accountNo',testCont.Account_No__c);
        ApexPages.currentPage().getParameters().put('retail',testCont.Retail_control__c);
        ApexPages.currentPage().getParameters().put('fSphone',testCont.Phone);
        ApexPages.currentPage().getParameters().put('territory',testCont.Territory__c);
        
        ApexPages.currentPage().getParameters().put('studyID',testCont.Study_ID__c);
        ApexPages.currentPage().getParameters().put('partID',testCont.Participant_ID__c);
        ApexPages.currentPage().getParameters().put('blindCode',testCont.Blinding_Code__c);
        ApexPages.currentPage().getParameters().put('resCom',testCont.Research_Company__c);
        ApexPages.currentPage().getParameters().put('resLoc',testCont.Research_Location__c);
        ApexPages.currentPage().getParameters().put('proFlavType',testCont.Project_Flavor_Type__c);
        ApexPages.currentPage().getParameters().put('rName',testCont.Research_Panelist_Name__c);
        
        
        ApexPages.currentPage().getParameters().put('custType',testCustType.Description__c);
        ApexPages.currentPage().getParameters().put('custType1',testCustType.id);
        Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.init();
         controller.cancelRedirect();
         controller.Customershow = false;
         controller.save();
         Test.stopTest();
        // System.assertEquals('Fname', controller.conObj.FirstName );
     }
      
     // validate Getcitystate method
     static testMethod void validateGetcitystate() 
     {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'35801',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        //System.assertEquals(testTM.Id, controller.testTM.id );
      }
      
      static testMethod void validatechangeCustomerType() 
     {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Customer_Type__c testCustType = TestDataSetup.createCustType('Consumer', 'CONSUMERS', true, 'Test Description');
        insert testCustType;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'35801',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.CustomerType1__c = testCustType.id;
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.changeCustomerType();
        Test.stopTest();
        //System.assertEquals(testTM.Id, controller.testTM.id );
      }
      
	static testMethod void validatechangeCustomerTypeNegative()
    {
		Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Customer_Type__c testCustType = TestDataSetup.createCustType('Consumer', 'CONSUMERS', true, 'CONSUMER');
        insert testCustType;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'35801',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.CustomerType1__c = testCustType.id;
        testCont.CustomerType__c = 'CONSUMER';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.changeCustomerType();
        
        controller.selectedCustomerTypeId = 'a0E360000inValidId';
        controller.changeCustomerType();
        
        controller.selectedCustomerTypeId = '';
        controller.changeCustomerType();
        
        Contact testContNull = new Contact();
        testContNull.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        controller = new ConsumerEntryController(new ApexPages.StandardController(testContNull));
        controller.getCustomerType();
        
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        controller.init();
        
        Test.stopTest();
        
      }
      
      static testMethod void validatechangeCustomerTypeinContact() 
     {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Customer_Type__c testCustType = TestDataSetup.createCustType('Consumer', 'CONSUMERS', true, 'Test Description');
        insert testCustType;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'35801',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        //testCont.CustomerType1__c = testCustType.id;
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.changeCustomerType();
        Test.stopTest();
        //System.assertEquals(testTM.Id, controller.testTM.id );
      }
      
       // validate Getcitystate method
      static testMethod void validateGetcitystate1()
       {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         testCont.Country__c = 'United States';
        testCont.City__c = 'Grand Rapids';
        testCont.State__c = 'Michigan';
           insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         Contact caseObj = [Select Id,FirstName  From Contact Where Id =: testCont.id limit 1];
          //System.assertEquals('Fname', testCont.FirstName );
         
       }
        // validate Getcitystate method
     static testMethod void validateGetcitystate2() 
      {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Lname',testCont.Id);
        Test.startTest();
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.getcitystate();
        Test.stopTest();
         //System.assertEquals('Lname', controller.conObj.LastName );
     }
      // validate Getcitystate method
      static testMethod void validateGetcitystate3() 
      {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Title',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        //System.assertEquals('Title', controller.conObj.Title );
        
      }
       // validate Getcitystate method
       static testMethod void validateGetcitystate4() 
       {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('Addr1',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          //System.assertEquals('Addr1', controller.conObj.OtherAddress);
        
         
        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate5() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('add',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('add', controller.conObj.Address );
        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate6() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('City',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('City', controller.conObj.City__c );

        }
         // validate Getcitystate method
        static testMethod void validateGetcitystate7()
         {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('State',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('State', controller.conObj.State__c );

         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate8() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          //System.assertEquals('dob', controller.conObj.Birthdate__c );
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate9() 
        {
          Account testAcc = TestDataSetup.createAccount('Test Account');
          insert testAcc ;
          Date bdate = Date.newInstance(1989, 06, 14);
          Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
          insert testCont;
          Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('phone',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
        Test.stopTest();
         //System.assertEquals('phone', controller.conObj.Phone );
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate10() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('CCN',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
          //System.assertEquals('CCN', controller.conObj.CCN__c);
         }
          // validate Getcitystate method
        static testMethod void validateGetcitystate11()
         {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('strAVCode',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('strAVCode', controller.conObj.AV_Code__c);
         }
          // validate Getcitystate method
       static testMethod void validateGetcitystate12()
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         ApexPages.currentPage().getParameters().put('email',testCont.Id);
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getcitystate();
         Test.stopTest();
         //System.assertEquals('email', controller.conObj.Email);
        }
         // validate Getcitystate method
       static testMethod void validateGetcitystate13() 
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('country',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        //System.assertEquals('country', controller.conObj.Country__c);
        }
         // validate Getcitystate method
      static testMethod void validateGetcitystate14()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        ApexPages.currentPage().getParameters().put('Zip',testCont.Id);
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getcitystate();
        Test.stopTest();
        //System.assertEquals('Zip', controller.conObj.Zip_Code__c);
        }
       // validate GetaddressverifiedUS method
       static testMethod void validateGetaddressverifiedUS()
        {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Grand Rapids';
        testCont.State__c = 'Michigan';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.getaddressverified();
        Test.stopTest();
        //System.assertEquals('PMUSA', controller.testOpCo.OperatingCompany__c);
        }
       // validate Getaddressverified method 
       static testMethod void validateGetaddressverified() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         Test.startTest();
         ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
         controller.getaddressverified();
         Test.stopTest();
          //System.assertEquals('PMUSA', controller.testOpCo.OperatingCompany__c);
        }
        // validate Getglobaladdverify method
       static testMethod void validateGetglobaladdverify() 
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        //controller.getglobaladdverify();
        Test.stopTest();
        }
        // validate SaveNoContact method
       static testMethod void validateSaveNoContact() 
        {
         Account testAcc = TestDataSetup.createAccount('Test Account');
         insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
         Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
         //insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
         TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
         insert testTFN;
         Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
         testTM.Contact__c = testCont.id;
         insert testTM;
         Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
         testCase.Transaction__c = testTM.Id;
         insert testCase;
         ApexPages.currentPage().getParameters().put('from','Search');
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
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.save();
        Test.stopTest();
       }
      // validate Save method
      static testMethod void validateSave()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20011',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.Zip_Code__c = '15220';
        testCont.State__c = 'PA';
        testCont.City__c = 'Pittsburgh';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
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
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.conObj.Zip_Code__c = '00000';
            controller.getcitystate();
            controller.conObj.Zip_Code__c = '15229';
            controller.getcitystate();
            controller.conObj.Zip_Code__c = '15221';
            controller.getcitystate();
           controller.conObj.Zip_Code__c = '99999';
            controller.getcitystate();
            controller.save();
           MelissaClasses.AddressInnerClass inner1 = new MelissaClasses.AddressInnerClass();
           MelissaClasses.AddressOuterClass outer1= new MelissaClasses.AddressOuterClass();
           List<MelissaClasses.AddressOuterClass> outerList= new List<MelissaClasses.AddressOuterClass>();
           MelissaClasses.zipLookupResponse zip = new MelissaClasses.zipLookupResponse();
           zip.ErrorString = '';
           zip.ResultCode =  '0';
           outer1.Address = inner1;
           outerList.add(outer1);
           zip.Results = outerList;
           MelissaClasses.consumerAddressRequest addtress = new MelissaClasses.consumerAddressRequest();
           MelissaClasses.consumerAddressResponse cons= new MelissaClasses.consumerAddressResponse();
           List<MelissaClasses.consumerAddressResponse> consList = new List<MelissaClasses.consumerAddressResponse>();
           consList.add(cons);
           MelissaClasses.consumerData cData = new MelissaClasses.consumerData();
           cData.Records = consList;
           MelissaClasses.consumerAddressInnerResponse innerRe = new MelissaClasses.consumerAddressInnerResponse('','');
           List<MelissaClasses.consumerAddressInnerResponse> a = new List<MelissaClasses.consumerAddressInnerResponse>();
           a.add(innerRe);
           MelissaClasses.consumerFullAddressInnerResponse res = new MelissaClasses.consumerFullAddressInnerResponse(cons,a,'test');
           res.consumerAddressInner = a;
           res.consumerAddress = cons;
           
           AcxiomServices.getAccessToken(); 
        Test.stopTest();
       }
      
      static testMethod void validateAssignContactTransaction()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20011',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
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
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.fromPage = 'search';
            controller.assignContactTransaction();
        Test.stopTest();
       }
      
     // validate SaveNoAddrVerify method
     static testMethod void validateSaveNoAddrVerify()
      {
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
       Date bdate = Date.newInstance(1989, 06, 14);
       Contact testCont = TestDataSetup.createContact('Trade','Customer',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CustomerType__c='CONSUMERS';
          testCont.AV_Code__c='1';
          testCont.Birthdate__c='1989-09-23';
          //insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
          Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
        testCase.Transaction__c = testTM.Id;
          testCase.ContactId=testCont.id;
          insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        ApexPages.currentPage().getParameters().put('dob','2016-11-10T11:36:54.000+0000');  
        ApexPages.currentPage().getParameters().put('Customershow','false');
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
            tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        Test.startTest();
        ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
        controller.save();
        Test.stopTest();
       }
	  
      //JD: 6/16/2020
      static testmethod void validateEmailVerification()
      {
          Account testAcc = TestDataSetup.createAccount('Test Account');
          insert testAcc ;
          Date bdate = Date.newInstance(1989, 06, 14);
          Contact testCont = TestDataSetup.createContact('Trade','Customer',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
          testCont.CustomerType__c='CONSUMERS';
          testCont.AV_Code__c='1';
          testCont.Birthdate__c='1989-09-23';
          insert testCont;
          Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
          insert testOpCo;
          TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
          insert testTFN;
          Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
          testTM.Contact__c = testCont.Id;
          insert testTM;
          Case testCase = TestDataSetup.createTestCase(testAcc, 1200, null, testTM.Id,testOpCo.id);
          testCase.Transaction__c = testTM.Id;
          testCase.ContactId=testCont.id;
          insert testCase;
          Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
          tranId = new Cookie('tranId',testTM.id,null,-1,false);
          ApexPages.currentPage().setCookies(new Cookie[]{tranId});
          Test.startTest();
              ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
              controller.save();
          	  testCont.Email = 'test@email.com';
          	  testCont.Email_Verified__c = false;
          	  update testCont;
          	  controller.save();
          	  ConsumerEntryController controller2 = new ConsumerEntryController(new ApexPages.StandardController(testCont));
          	  testCont.Email_Verified__c = true;
          	  update testCont;
          	  controller2.save();
          	  controller2.emailVerified = true;
          	  testCont.Email_Verified__c = false;
          	  update testCont;
          	  controller2.save();
          	  testCont.Email = ''; 
          	  update testCont;
              controller2.save();
          Test.stopTest();
       }
      //JD: 2020-12-01
      static testMethod void validateSave2()
       {
        Account testAcc = TestDataSetup.createAccount('Test Account2');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname2','Test Lname2',testAcc.Id,true,'20011',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.Zip_Code__c = '15220';
        testCont.State__c = 'PA';
        testCont.City__c = 'Pittsburgh';
        testCont.CustomerType__c = 'Consumer';
        testCont.AVF_GIID_Received__c = false;
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Transaction__c = testTM.Id;
        insert testCase;
        ApexPages.currentPage().getParameters().put('from','Search');
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
            ConsumerEntryController controller = new ConsumerEntryController(new ApexPages.StandardController(testCont));
            controller.save();
            testCont.AVF_GIID_Received__c = true;
            controller.save();
            testCont.Birthdate1__c = Date.valueOf('1900-01-01');
           	controller.save();
        Test.stopTest();
       }
  }