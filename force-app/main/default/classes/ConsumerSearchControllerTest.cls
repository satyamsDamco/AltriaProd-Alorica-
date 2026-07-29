/*
test class of Consumer Search
08/02/2016 Infogain – Created.
*/
@isTest(SeeAllData=true)
private class ConsumerSearchControllerTest{
     // validate constructor
    static testMethod void validateConsumerSearchConstructor() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('hideIsssue',testCase.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','1234567890');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','1234567890');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
       ApexPages.currentPage().getParameters().put('country','1234567890');
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Test.StopTest();
    }
    
    //Test method to cover Init method.
    static testMethod void validateInit() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('hideIsssue',testCase.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','1234567890');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','1234567890');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
       ApexPages.currentPage().getParameters().put('country','1234567890'); 
        
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.init();
        Test.StopTest();
    }
    
     //Test method to cover getfullsearchList method.
    static testMethod void validateGetfullsearchList() {
           
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.City__c = 'testCity';
         testCont.State__c = 'testState';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        StatusCodeFullSearch__c s =  new StatusCodeFullSearch__c(Name = '071',Status__c = 'test');
        insert s;
        AdminAlertEmail__c em = new AdminAlertEmail__c(Name = 'test', AdminEmail__c= 'test@test.com');
        insert em;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);        
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
         controller.Search();
        controller.getfullsearchList();
        controller.conObj.Country__c = 'India';
        controller.getCityState();
        controller.conObj.Country__c = 'United States';
        controller.conObj.Zip_Code__c = '15221';
        controller.getCityState();
        controller.conObj.Zip_Code__c = '00000';
        controller.getCityState();
        controller.Search();
        controller.conObj.Zip_Code__c = '15221';
        controller.conObj.LastName = 'te';
        controller.Search();
        controller.conObj.LastName = 'test';
        controller.conObj.CCN__c = '12';
        controller.Search();
        controller.conObj.CCN__c = '';
        controller.conObj.Phone = '122222';
        controller.Search();
        controller.Clear(); 
        controller.conObj.FirstName = 'Test Fname';
        controller.conObj.LastName = 'Test Lname';
        controller.conObj.Zip_Code__c = '20001';
        controller.Search();
        Test.StopTest();
    }
    
     //Test method to cover getfullsearchList method.
    static testMethod void validateGetfullsearchList1() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.City__c = 'testCity';
         testCont.State__c = 'testState';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        StatusCodeFullSearch__c s =  new StatusCodeFullSearch__c(Name = '071',Status__c = 'test');
        insert s;
        AdminAlertEmail__c em = new AdminAlertEmail__c(Name = 'test', AdminEmail__c= 'test@test.com');
        insert em;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
         tranId = new Cookie('tranId',testTM.id,null,-1,false);        
        Test.StartTest();
        Contact testCont1 = new Contact();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont1));
        controller.conObj.LastName = 'Test Lname';
        controller.conObj.Zip_Code__c = '20001';
        controller.conObj.Birthdate1__c = Date.valueOf('1998-10-28');
        controller.Search();
        controller.conObj.FirstName = 'Test Fname';
        controller.Search();
        Test.StopTest();
    }
    
    
    
       // validate Clear method
     static testMethod void validateClear() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().getParameters().put('hideIsssue',testCase.Id);
        Test.StartTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Clear();
        Test.StopTest();
    }
    
    // validate GetCityState method
    static testMethod void validateGetCityState() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'Canada';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
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
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.getCityState();
        Test.stopTest();
    }
    // validate GetCityState method else condition 
     static testMethod void validateGetCityStateElse() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
         Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
          tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        //MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
        //zipLookup = MelissaServices.ZipLookupServiceRequest(testCont.Zip_Code__c,testTM.Id,'Consumer Search');
        //zipLookup.ErrorString = 'Test Error';
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.FormName = 'Search';
        controller.getCityState();
        Test.stopTest();
    }
    // validate Search method
     static testMethod void validateSearch() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.ccn__c = '123'; 
        testCont.Phone = '1234567890';
        testCont.Email = 'test@test.com';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
          tranId = new Cookie('tranId',testTM.id,null,-1,false);
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','1234567890');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','1234567890');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
       ApexPages.currentPage().getParameters().put('country','1234567890');
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        Test.stopTest();
    }
    
    // validate Search method in negative scenario
	static testMethod void validateSearchNegative() {
          
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.ccn__c = '123'; 
        testCont.Phone = '1234567890';
        testCont.Email = 'test@test.com';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
		Test.startTest();
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','00000');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','test@test.com');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
		ApexPages.currentPage().getParameters().put('country','United States');
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        ApexPages.currentPage().getParameters().put('zip','94544');
        ApexPages.currentPage().getParameters().put('country','United States');
        ApexPages.currentPage().getParameters().put('Lname','a');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        testCont.ccn__c = '12';
        ApexPages.currentPage().getParameters().put('Lname','Lastname');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        
        testCont.ccn__c = '123';
        ApexPages.currentPage().getParameters().put('phone','123456789');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        
        ApexPages.currentPage().getParameters().put('phone','1234567890');
        ApexPages.currentPage().getParameters().put('email','test_test.com');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        
        /*
        ApexPages.currentPage().getParameters().put('email','test@test.com');
        //testCont.Phone = '';
        //testCont.LastName = '';
        testCont.Email = 'test@test.com';
        testCont.CustomerID__c = '';
        testCont.ccn__c = '';
        update testCont;
        ApexPages.currentPage().getParameters().put('email','');
        ApexPages.currentPage().getParameters().put('phone','');
        ApexPages.currentPage().getParameters().put('Lname','');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.issueid = '';
        controller.tranSelectedValue = '';
        controller.iqosid = '';
        controller.Search();
        */
        
        ApexPages.currentPage().getParameters().put('email','test@test.com');
        testCont.Country__c = Label.Country;
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        
        testCont.Country__c = 'Philippines';
        ApexPages.currentPage().getParameters().put('country','Philippines');
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        
        testCont.Country__c = Label.Country;
        ApexPages.currentPage().getParameters().put('country',Label.Country);
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.issueid = testCase.Id;
        controller.Search();
        
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.issueid = testCase.CaseNumber__c;
        controller.Search();
        
        testCase.IQOS_Reference_ID__c = '12';
        update testCase;
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.iqosid = '12';
        controller.Search();
        
        controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.iqosid = '';
        controller.tranSelectedValue = 'testTM.Name';
        controller.Search();
        
        Test.stopTest();
    }
    // validate SearchNullData method
    static testMethod void validateSearchNullData() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.FirstName= '1234566';
        testCont.Street_Address__c = '125';
        testCont.Country__c = 'India';
        //insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.Search();
        Test.stopTest();
    }
     
    // validate AgeVerifyZipMap method
    static testMethod void validateAgeVerifyZipMap() {
         
       Account testAcc = TestDataSetup.createAccount('Test Account');
       insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.ageVerifyZipMap();
        Test.stopTest();
    }
    // validate AgeVerifyZipMap method else condition 
    static testMethod void validateAgeVerifyZipMapElse() {
         
         Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
         Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.ageVerifyZipMap();
        Test.stopTest();
    }
    // validate CheckContact method
    static testMethod void validateCheckContact() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Contact  con = [select id from Contact where id =: testCont.Id limit 1];
        system.debug('-----con------'+con);
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = con.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
          tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','1234567890');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','1234567890');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
       ApexPages.currentPage().getParameters().put('country','1234567890');
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.checkContact();
        Test.stopTest();
    }
    
    // validate CCNLookup method
    static testMethod void validateCCNLookup() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        ConsumerSearchController.CCNLookup('3239771',''+testTM.id);
        ConsumerSearchController.CCNLookup('484186471',testTM.id);
        ConsumerSearchController.CCNLookup('9876',''+testTM.id);
        ConsumerSearchController.CCNLookup('0000',''+testTM.id);
        Test.stopTest();
    }
     // validate CCNLookup method
    static testMethod void validateCCNLookupSearch() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        ApexPages.currentPage().getParameters().put('CCNNumberId','1234567890');
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.CCNLookupSearch();
        Test.stopTest();
    }
    
    static testMethod void validateRefreshContact() {
         
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Contact  con = [select id from Contact where id =: testCont.Id limit 1];
        system.debug('-----con------'+con);
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = con.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        
          tranId = new Cookie('tranId',testTM.id,null,-1,false);
        
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('issueid',testCase.Id);
         ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        ApexPages.currentPage().getParameters().put('Fname','1234567890');
        ApexPages.currentPage().getParameters().put('Lname','1234567890');
        ApexPages.currentPage().getParameters().put('Addr1','1234567890');
        ApexPages.currentPage().getParameters().put('zip','1234567890');
        ApexPages.currentPage().getParameters().put('city','1234567890');
        ApexPages.currentPage().getParameters().put('state','1234567890');
        ApexPages.currentPage().getParameters().put('dob','11/22/1988');
        ApexPages.currentPage().getParameters().put('email','1234567890');
        ApexPages.currentPage().getParameters().put('phone','1234567890');
       ApexPages.currentPage().getParameters().put('country','United States');
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.RefreshContact();
        controller.Search();
        AcxiomClasses.OpCoQualification aaTest = new AcxiomClasses.OpCoQualification();
        List<AcxiomClasses.OpCoQualification> qIList = new List<AcxiomClasses.OpCoQualification>();
        qIList.add(aaTest);
        AcxiomClasses.QualificationData QAD = new AcxiomClasses.QualificationData();
        QAD.OpCoQualification = qIList;
        
        AcxiomClasses.ContactInfo testcontact = new AcxiomClasses.ContactInfo();
        List<AcxiomClasses.ContactInfo> clist = new List<AcxiomClasses.ContactInfo>();
        clist.add(testcontact);
        AcxiomClasses.AddressType ad = new AcxiomClasses.AddressType();
        ad.ContactInfo = clist;
        
        List<AcxiomClasses.AddressType> adList = new List<AcxiomClasses.AddressType>();
        adList.add(ad);
        
        
        AcxiomClasses.ChannelLevel cl = new AcxiomClasses.ChannelLevel();
        cl.AddressType = adList;
        
        List<AcxiomClasses.ChannelLevel> clSt = new List<AcxiomClasses.ChannelLevel>();
        clSt.add(cl);
        
        AcxiomClasses.Channel cc = new AcxiomClasses.Channel();
        cc.ChannelLevel = clSt;
        
        List<AcxiomClasses.Channel> ccList = new List<AcxiomClasses.Channel>();
        ccList.add(cc);
        
        AcxiomClasses.ChannelData ccData = new AcxiomClasses.ChannelData();
        ccData.Channel = ccList;
        
        AcxiomClasses.Individual inData = new  AcxiomClasses.Individual();
        inData.PID = '1234';
        
        List<AcxiomClasses.AuthenticationData> ad1 = new List<AcxiomClasses.AuthenticationData>();
        
        AcxiomClasses.ConsumerFullSearchResponse fullSrch = new AcxiomClasses.ConsumerFullSearchResponse();
        fullSrch.QualificationData = QAD;
        fullSrch.ChannelData = ccData;
        fullSrch.AuthenticationData = ad1;
        
        AcxiomClasses.CCNLookupResponse cnnSrch = new AcxiomClasses.CCNLookupResponse();
        cnnSrch.QualificationData = QAD;
        cnnSrch.ChannelData = ccData;
		cnnSrch.Individual = inData;
        
        Test.stopTest();
    }

    // ------------------------------------------------------------------
    // NEW TESTS ADDED TO INCREASE COVERAGE
    // ------------------------------------------------------------------

    // Covers the constructor's "tranid via URL parameter" branch (the
    // ELSE of the cookie check) and, because tranid is non-null, also
    // covers the tranObj query, customerRecordTypeHelper call, and the
    // customerNumber handling block (Phone/Country__c assignment +
    // in-constructor call to Search()) - none of which were previously
    // exercised because no existing test set a matching 'tranid' cookie
    // or URL parameter with the exact key the controller reads.
    static testMethod void validateConstructorTranidUrlParamWithCustomerNumber() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        // Set the URL parameter using the exact key the controller reads ('tranid').
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        System.assertEquals(testTM.Id, controller.tranObj.Id, 'tranObj should be populated when tranid is present');
        Test.stopTest();
    }

    // Covers the same tranid != null block, but WITHOUT the customerNumber
    // parameter, so the inner customerNumber if-block is skipped, exercising
    // the false branch of that condition.
    static testMethod void validateConstructorTranidUrlParamNoCustomerNumber() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        System.assertEquals(testTM.Id, controller.tranObj.Id, 'tranObj should still be populated when tranid is present, even without customerNumber');
        Test.stopTest();
    }

    // Covers the init() branches that were never exercised:
    // - dob containing '-' (ISO/dash format instead of slash format)
    // - Addr2 parameter
    static testMethod void validateInitDashFormatDobAndAddr2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;

        ApexPages.currentPage().getParameters().put('Fname','Jane');
        ApexPages.currentPage().getParameters().put('Lname','Doe');
        ApexPages.currentPage().getParameters().put('Addr1','100 Main St');
        ApexPages.currentPage().getParameters().put('Addr2','Apt 200');
        ApexPages.currentPage().getParameters().put('dob','1988-11-22T00:00:00.000Z');
        ApexPages.currentPage().getParameters().put('zip','47714');
        ApexPages.currentPage().getParameters().put('city','Washington');
        ApexPages.currentPage().getParameters().put('state','DC');
        ApexPages.currentPage().getParameters().put('email','jane.doe@test.com');
        ApexPages.currentPage().getParameters().put('country','United States');

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.init();
        System.assertEquals('Apt 200', controller.conObj.Street_Address__c, 'Addr2 should overwrite Street_Address__c');
        System.assertEquals(Date.newInstance(1988,11,22), controller.conObj.Birthdate1__c, 'Dash-format DOB should be parsed correctly');
        Test.stopTest();
    }

    // Direct unit test of the escapeMetaCharacters() helper, covering the
    // branch where meta characters ARE present in the input string.
    static testMethod void validateEscapeMetaCharacters() {
        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(new Contact()));
        String result = controller.escapeMetaCharacters('Te$t (Name) [123]-Co&Co');
        System.assert(result.contains('\\$'), 'Special character $ should be escaped');
        System.assert(result.contains('\\('), 'Special character ( should be escaped');

        // Also cover the branch where NO meta characters are present.
        String plainResult = controller.escapeMetaCharacters('PlainText');
        System.assertEquals('PlainText', plainResult, 'Plain text without meta characters should be unchanged');
        Test.stopTest();
    }

    // Covers the Search() branch that builds the SOQL/SOSL query using
    // conObj.CustomerID__c, which was never populated in any existing test.
    static testMethod void validateSearchByCustomerId() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.conObj.CustomerID__c = 'CUST-TEST-12345';
        controller.Search();
        Test.stopTest();
    }

    // Covers the Search() branch where tranSelectedValue matches an actual
    // Transaction_Management__c Name and that record has a linked Contact
    // (ConsumerId / ConName gets populated from the transaction lookup).
    static testMethod void validateSearchByTranSelectedValueMatch() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        Transaction_Management__c reQueriedTM = [SELECT Id, Name, Contact__c FROM Transaction_Management__c WHERE Id = :testTM.Id];

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.tranSelectedValue = reQueriedTM.Name;
        controller.Search();
        Test.stopTest();
    }

    // Covers the "isPrimarySearchOnly" true branch inside Search(): when a
    // primary field (Phone, in this case) is used but no matching record is
    // found, the controller should go straight to the "No record found"
    // message instead of the "Please enter FN, LN, DOB..." extended-search
    // prompt.
    static testMethod void validateSearchPrimaryOnlyNoResultsFound() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        controller.conObj.Country__c = 'United States';
        controller.conObj.FirstName = null;
        controller.conObj.LastName = null;
        controller.conObj.Street_Address__c = null;
        controller.conObj.Zip_Code__c = null;
        controller.conObj.Birthdate1__c = null;
        controller.conObj.Phone = '9999999999';
        controller.Search();
        Test.stopTest();
    }

    // Covers the getCityState() path where Country__c == Label.Country but
    // Zip_Code__c is blank, so the zip-lookup callout block is skipped
    // entirely (only city/state get reset to blank).
    static testMethod void validateGetCityStateBlankZip() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        testCont.Country__c = 'United States';
        testCont.City__c = 'Huntsville';
        testCont.State__c = 'MI';
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        // Clear the zip only on the in-memory conObj (not on the inserted
        // record) so getCityState() takes the "blank zip" skip-branch
        // without tripping any required-field/validation rule on insert.
        controller.conObj.Zip_Code__c = null;
        controller.getCityState();
        System.assertEquals('', controller.conObj.city__c, 'City should be blank when zip lookup is skipped');
        Test.stopTest();
    }

    // ------------------------------------------------------------------
    // NEW TESTS: checkContact() branches
    // ------------------------------------------------------------------
    // None of the existing tests actually get tranid resolved at
    // construction time (the cookie in prior tests is named 'tranId' with
    // a capital I, but the controller reads the lowercase 'tranid'), so
    // tranObj stayed null in every prior checkContact()/RefreshContact()
    // test and only the "tranObj is null" debug branch ever ran. These
    // three tests use the correct lowercase URL parameter key to reach
    // the three real branches inside checkContact().

    // Covers checkContact()'s ELSE branch: tranObj.Contact__c is already
    // populated at query time, so checkContact = true immediately with
    // no requery needed.
    static testMethod void validateCheckContactDirectMatch() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Boolean result = controller.checkContact();
        System.assert(result, 'checkContact should return true when tranObj.Contact__c is already populated');
        Test.stopTest();
    }

    // Covers checkContact()'s requery branch where tranObj.Contact__c is
    // null at query time, but a fresh SOQL requery inside checkContact()
    // finds it has since been populated.
    static testMethod void validateCheckContactRequeryFindsContact() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        // Insert WITHOUT Contact__c so the controller's initial query sees it as null.
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        System.assertEquals(null, controller.tranObj.Contact__c, 'Sanity check: Contact__c should be null right after construction');

        // Update the underlying record directly (not through controller.tranObj)
        // so checkContact()'s requery picks up the new value.
        testTM.Contact__c = testCont.Id;
        update testTM;

        Boolean result = controller.checkContact();
        System.assert(result, 'checkContact should return true after requery finds Contact__c populated');
        Test.stopTest();
    }

    // Covers checkContact()'s requery branch where the requery still finds
    // Contact__c null (the if-body inside the requery block is skipped,
    // exercising the false side of that condition).
    static testMethod void validateCheckContactRequeryStillNull() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'47714',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM = TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        insert testCase;

        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);

        Test.startTest();
        ConsumerSearchController controller = new ConsumerSearchController(new ApexPages.StandardController(testCont));
        Boolean result = controller.checkContact();
        System.assert(!result, 'checkContact should return false when requery still finds Contact__c null');
        Test.stopTest();
    }
    }