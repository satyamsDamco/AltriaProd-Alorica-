@isTest
public with sharing class EmailMessageTest 
{
	public  static date date1;
	
    public static testmethod void TestEmailMessageInsert()
    {
    	Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        list<Case> lstCase = new list<Case>();
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        lstCase.add(testCase);
        testCase.Incident_Date__c=date1;   
        Case caseobj2=TestDataSetup.createTestCase(testAcc,105.3,testCont.Id, testTM.Id,testOpCo.id);
        lstCase.add(caseobj2);
        insert lstCase;
        //---------------------------
        
        //---------------------------
    	
    	EmailMessage[] newEmail = new EmailMessage[0];
    	
    	newEmail.add(new EmailMessage(FromAddress = 'oldwen.adriano@alorica.com',
		FromName = 'Oldwen',
		ToAddress = 'oldwen.adriano@alorica.com',
		Subject = 'Email Subject',
		TextBody = 'No body',
		HtmlBody = 'Hello',
		ParentId = caseobj2.Id));   // (newCase and newTask are the newly created case and task from earlier code)
		
		//ParentId = caseobj2.Id, 
		//ActivityId = newTask[0].Id));   // (newCase and newTask are the newly created case and task from earlier code)
		 
		
		insert newEmail;
    }
}