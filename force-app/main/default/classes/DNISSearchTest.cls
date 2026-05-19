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
@isTest
private class DNISSearchTest{
   // Validate Constructor
   static testMethod void validateDNISSearch() {
       
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
         insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
       testTFN.Operating_Company__c = testOpCo.Id;
        insert testTFN;
       testOpCo.Default_TFN__c = testTFN.id;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
       Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        Cookie customerRecType = ApexPages.currentPage().getCookies().get('customerRecType');
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        customerRecType = new Cookie('customerRecType','Trade',null,-1,false);        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
       ApexPages.currentPage().setCookies(new Cookie[]{customerRecType});
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        controller.search();
        Test.stopTest();
        
    }
    
     // Validate Search method else condition
    static testMethod void validateSearchElse() {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('testOpCo',testOpCo.Id);
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        controller.search();
        Test.stopTest();
    }
    // Validate GetopCompanyList method
     static testMethod void validateGetopCompanyList() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        controller.getopCompanyList();
        Test.stopTest();
    }
     // Validate GetopCompanyList method else condition
    static testMethod void validateGetopCompanyListElse() {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
        // ApexPages.currentPage().getParameters().put('testOpCo',testOpCo.Id);
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        controller.getopCompanyList();
        Test.stopTest();
    }
   
     // Validate SearchList method
    static testMethod void validateSearchList() {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id, testOpCo.id);
        insert testCase;
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        controller.getopCompanyList();
        Test.stopTest();
    }
    
    // Validate searchOnLoad,getopCompanyList,opCompany,Search  method
    static testMethod void validateSearchOnLoad() {
       
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'PMUSA','Inbound','PMUSA',true);
        insert testOpCo;
        Operating_Company__c testOpCo1= TestDataSetup.createOpCo('Telephone', 'Trade','Inbound','Trade',true);
        insert testOpCo1;
        
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        testTFN.Active__c = True;
        insert testTFN;
        
        TFN__c testTFN1 = TestDataSetup.createTFN(true, '18001', 456, testOpCo);
        testTFN1.Active__c = True;
        insert testTFN1;
        
        
        testOpCo.Default_TFN__c = testTFN.id;
        update testOpCo;
        
        testOpCo1.Default_TFN__c = testTFN1.id;
        update testOpCo1;
        
        ApexPages.currentPage().getParameters().put('called','45');
        ApexPages.currentPage().getParameters().put('remotenumber','1234567654');
        ApexPages.currentPage().getParameters().put('ucid','5655');
        Test.startTest();
        DNISSearchController controller = new DNISSearchController();
        
        controller.searchOnLoad();
        controller.getopCompanyList();
        controller.opCompany = testOpCo.id;
        controller.search();
        controller.opCompany = testOpCo1.id;
        controller.search();
        Test.stopTest();
    }
    }