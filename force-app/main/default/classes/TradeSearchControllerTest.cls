@isTest
public class TradeSearchControllerTest{
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
		
	}

//Validate TradeSearchController Constructor.
    static testMethod void validateTradeSearchControllerConstructor() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        /*Customer_type__c testCustType = TestDataSetup.createCustType('C1','CUSTOMER', true, 'WHOLESALER');
        insert testCustType;*/
		Customer_type__c testCustType = [Select Id from Customer_type__c where Description__c = 'WHOLESALER'];
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CustomerType__c = 'Wholesaler';
        testCont.CustomerType1__c = testCustType.id;
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        //Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        //insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
		
		ApexPages.currentPage().getParameters().put('custType1',testCustType.Id);
        Test.StartTest();
            TradeSearchController controller = new TradeSearchController(new ApexPages.StandardController(testCont));
			controller.TradeSearch();
        Test.StopTest();
    }
  
   static testMethod void validateTradeSearchControllerConstructor2() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
		Customer_type__c testCustType = [Select Id from Customer_type__c where Description__c = 'RESEARCH PANELIST'];
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CustomerType__c = 'RESEARCH PANELIST';
        testCont.CustomerType1__c = testCustType.id;
		testCont.Study_ID__c = null;
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        //Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        //insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
		
		ApexPages.currentPage().getParameters().put('custType1',testCustType.Id);
        Test.StartTest();
            TradeSearchController controller = new TradeSearchController(new ApexPages.StandardController(testCont));
			controller.TradeSearch();
        Test.StopTest();
    }
	
	static testMethod void validateTradeSearchControllerConstructor3() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
		Customer_type__c testCustType = [Select Id from Customer_type__c where Description__c = 'RESEARCH PANELIST'];
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.CustomerType__c = 'RESEARCH PANELIST';
        testCont.CustomerType1__c = testCustType.id;
		testCont.Study_ID__c = 'SI';
		testCont.Research_Location__c ='RL';
		testCont.CustomerID__c = '1234';
		testCont.Project_Flavor_Type__c = 'Mint';
		testCont.Research_Panelist_Name__c = 'RPN';
		testCont.Research_Company__c = 'RC';
		testCont.Blinding_Code__c = 'BC';
		testCont.Participant_ID__c = 'PI';
		testCont.Company_Name__c = 'cn';
		testCont.Retail_control__c = 'rc';
		testCont.DBA_Name__c = 'dba';
		testCont.Account_No__c = 'ac';
		testCont.Territory__c = 'te';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        //Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id);
        //insert testCase;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');
        tranId = new Cookie('tranId',testTM.id,null,-1,false);
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
		
		ApexPages.currentPage().getParameters().put('custType1',testCustType.Id);
        Test.StartTest();
            TradeSearchController controller = new TradeSearchController(new ApexPages.StandardController(testCont));
			controller.TradeSearch();
        Test.StopTest();
    }
     //Validate TradeContact method.
    static testMethod void validateTradeContact() {
        /*Customer_Type__c c = new Customer_Type__c(IsActive__c = true, Description__c='WHOLESALER', Customer_Type__c = 'WHOLESALER',CodeType__c  = 'CUSTOMERS');
        insert c;*/
		Customer_type__c c = [Select Id,Customer_Type__c from Customer_type__c where Description__c = 'WHOLESALER'];
        Customer_Type__c  c1 = new Customer_Type__c(    IsActive__c = true,Description__c='RETAILER', Customer_Type__c = 'RETAILER',CodeType__c  = 'CUSTOMERS');
        insert c1;
        Customer_Type__c c2 = new Customer_Type__c( IsActive__c = true, Description__c = 'FIELD SALES FORCE', Customer_Type__c = 'FIELD SALES FORCE',CodeType__c  = 'CUSTOMERS');
        insert c2;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Contact' and Name = 'Trade Customer'].Id;
        Contact testCont = new Contact();
        testCont.FirstName = 'Test';
        testCont.LastName = 'Trade';
        testCont.RecordTypeId = strRecordTypeId;
        testCont.Email = 'test@test.com';
        testCont.Zip_Code__c = '15220';
        testCont.Company_Name__c ='Test';
        testCont.Retail_control__c = '111';
        testCont.DBA_Name__c = 'Test';
        testCont.Account_No__c = '111';
        testCont.Territory__c = '111';
        testCont.CustomerType__c = 'test';
        testCont.CustomerType1__c = c.id;    
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','Trade',true);
        insert testOpCo;
        
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        testTM.Contact__c = testCont.Id;
        insert testTM;
        
        Cookie tranId = ApexPages.currentPage().getCookies().get('tranId');      
         tranId = new Cookie('tranId',testTM.id,null,-1,false);
         ApexPages.currentPage().setCookies(new Cookie[]{tranId});
        /* checking issueid should not be null*/
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().getParameters().put('phone','test');
        ApexPages.currentPage().getParameters().put('email','test');
        ApexPages.currentPage().getParameters().put('accountNo','test');
        ApexPages.currentPage().getParameters().put('retail','test');
        ApexPages.currentPage().getParameters().put('fSphone','test');
        ApexPages.currentPage().getParameters().put('territory','test');
        ApexPages.currentPage().getParameters().put('custType',c.Customer_Type__c); 
        ApexPages.currentPage().getParameters().put('custType1',c.id);
        ApexPages.currentPage().getParameters().put('comName','test');
        ApexPages.currentPage().getParameters().put('agentName','test');
        ApexPages.currentPage().getParameters().put('DBA','test');
        ApexPages.currentPage().getParameters().put('zip','15220');
        ApexPages.currentPage().getParameters().put('customerNumber','1234567890');
        Test.StartTest();
        
        TradeSearchController controller = new TradeSearchController(new ApexPages.StandardController(testCont));
        controller.getCustomerType();
        controller.onCTISearch();
        controller.Clear();
        controller.TradeSearch();
        controller.checkTradeContact();
        controller.RefreshTradeContact();
        controller.selectedCustomerTypeId = c.id;
        controller.conObj.Phone ='123';
        controller.conObj.CustomerType__c = 'WHOLESALER';
        controller.TradeSearch();
        Test.StopTest();
    }
    
         //Validate TradeContact method.
    static testMethod void validateTradeContact1() {
       /* Customer_Type__c c = new Customer_Type__c(IsActive__c = true, Description__c='WHOLESALER', Customer_Type__c = 'WHOLESALER',CodeType__c  = 'CUSTOMERS');
        insert c;*/
		Customer_type__c c = [Select Id from Customer_type__c where Description__c = 'WHOLESALER'];
        Customer_Type__c  c1 = new Customer_Type__c(    IsActive__c = true,Description__c='RETAILER', Customer_Type__c = 'RETAILER',CodeType__c  = 'CUSTOMERS');
        insert c1;
        Customer_Type__c c2 = new Customer_Type__c( IsActive__c = true, Description__c = 'FIELD SALES FORCE', Customer_Type__c = 'FIELD SALES FORCE',CodeType__c  = 'CUSTOMERS');
        insert c2;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Contact' and Name = 'Trade Customer'].Id;
        Contact testCont = new Contact();
        testCont.FirstName = 'Test';
        testCont.LastName = 'Trade';
        testCont.RecordTypeId = strRecordTypeId;
        testCont.Email = 'test@test.com';
        testCont.Zip_Code__c = '15220';
        testCont.Company_Name__c ='Test';
        testCont.Retail_control__c = '111';
        testCont.DBA_Name__c = 'Test';
        testCont.Account_No__c = '111';
        testCont.Territory__c = '111';
        testCont.CustomerType__c = 'test';
        testCont.CustomerType1__c = c.id;    
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','Trade',true);
        insert testOpCo;
        
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo,testTFN);
        insert testTM;
        Cookie tranId = new Cookie('tranId',testTM.id,null,-1,false);
        ApexPages.currentPage().getParameters().put('tranId',testTM.Id);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});        
        
        /* checking issueid should not be null*/
        Contact testCont1 = new Contact(RecordTypeId = strRecordTypeId);
        Test.StartTest();
        
        TradeSearchController controller = new TradeSearchController(new ApexPages.StandardController(testCont1));
        controller.getCustomerType();
        controller.selectedCustomerTypeId = '';
        controller.changeCustomerType();        
        controller.selectedCustomerTypeId = c.id;
        controller.changeCustomerType();        
        controller.conObj.Phone = '123';
        controller.TradeSearch();
        controller.selectedCustomerTypeId = c1.id;
        controller.changeCustomerType(); 
        controller.conObj.Phone = '123';
        controller.TradeSearch();
        controller.selectedCustomerTypeId = c2.id;
        controller.changeCustomerType(); 
        controller.conObj.Email = 'abc@abc.com';
        controller.TradeSearch();
        Test.StopTest();
    }
    
    
}