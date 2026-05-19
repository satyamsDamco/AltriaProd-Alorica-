@isTest(SeeAllData=true)
private class EndCallControllerTest{

//validate EndCallController constructor method.

    static testMethod void validateEndCallControllerConstructor() {
 
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
            EndCallController controller = new EndCallController(new ApexPages.StandardController(testCont));
        Test.StopTest();
    }
    
    //validate EndCallValidationMessage,customSave method.
     static testMethod void validateEndCallValidationMessage() {
 
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
        //ApexPages.currentPage().getCookies().put('tranId',''+testTM.Id);
        Test.StartTest();
            EndCallController controller = new EndCallController(new ApexPages.StandardController(testCont));
         controller.EndCallValidationMessage(testTM.Id);
         controller.customSave();
        Test.StopTest();
    }
    
   
}