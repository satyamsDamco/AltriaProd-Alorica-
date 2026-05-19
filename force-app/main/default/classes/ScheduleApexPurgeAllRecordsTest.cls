@isTest
private class ScheduleApexPurgeAllRecordsTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2099';
    static testMethod void validateScheduleApexPurgeAllRecordsWithSetting(){
        
        TestDataSetup.createPurgingMonth(1);
        Account testAcc = TestDataSetup.createAccount('TestAccount');
        insert testAcc;
        Date bdate = Date.newInstance(1973, 08, 01);
        Contact testCont = TestDataSetup.createContact('Dave', 'Mindy', testAcc.id, true, '14219', bdate, '123 Street', true, true);
        testCont.Email = 'test123@test.com';
        testCont.City__c = 'HAYWARD';
        testCont.State__c = 'CA';
        testCont.Title = 'Mr';
        insert testcont;
        Contact testCont1 = TestDataSetup.createContact('Test', 'Mindy', testAcc.id, true, '14219', bdate, '123 Street', true, true);
        testCont1.Email = 'test123@test.com';
        testCont1.City__c = 'HAYWARD';
        testCont1.State__c = 'CA';
        testCont1.Title = 'Mr';
        insert testcont1;
        Datetime dateVal = Datetime.now().addyears(-3);
        Test.setCreatedDate(testCont.Id, dateVal );
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL1 = TestDataSetup.createPL('MST6','testCode1', testOpCo);
        insert testPL1;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL1, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL1, testOpCo);
        insert testBrand;       
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL1,'testVan');
        insert testBH;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Transaction_Management_History__c tm = new Transaction_Management_History__c(Transaction_Management__c = testTM.id, Service_Group_Code__c ='Consumer', Service_Request_Code__c = 'CREATECUST');
        insert  tm;
        DocumentType__c doc = TestDataSetup.createDoc('Test', 'Outbound','Test', 'Test', 'Test', testOpCo, 'Test');
        insert doc;    
        Correspondence_Fulfilment__c cf =  new Correspondence_Fulfilment__c(Contact__c = testcont.id, DocType__c = doc.id);
        insert cf;
        
        Case testCase = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        insert testCase;
                 
        Case caseData = [Select id, caseNumber__c from case where id = :testCase.id];
        
        Store_type__c st = TestDataSetup.createStoreType('Test', 'Test');
        insert st;
        
        Store__c store  = TestDataSetup.createStore('test', st);
        store.Issue__c =   testCase.id;
        insert store;
        Attachment_Detail__c att = new Attachment_Detail__c(Issue__c = testCase.id);
        insert att;
        Reimbursement__c r = new Reimbursement__c(Issue__c = testCase.id);
        insert r;
        Answer__c ans = new Answer__c(Answer__c = 'test');
        insert ans;
        Survey__c sur = new Survey__c(Survey_Name__c = 'test');
        insert sur;
        Question__c qq = new Question__c(Question__c = 'test', Type__c = 'Comment');
        insert qq;
        Survey_Issue__c si = new Survey_Issue__c(Answer__c = ans.id, Issue__c = testCase.id, Question__c = qq.id, Survey__c = sur.id, Transaction__c = testTM.id);
        insert si;
        Issue_Adjustment__c issueAd = new Issue_Adjustment__c(Action_Type__c='U', IssueNumber__c = caseData.CaseNumber__c, Request_ID__c = '1', Row_ID__c= '1', Adjustment_Code__c = 'DC', Adjustment_Type__c=' Date Code');
        insert  issueAd;
        IntegrationLog__c  i = new IntegrationLog__c(Callout__c='Address Verification', Type__c='Melissa');
        insert i;
        Test.setCreatedDate(testCase.Id, dateVal );
        Test.startTest();
            String jobId = System.schedule('ScheduleApexPurgeAllRecordsTest',CRON_EXP,new ScheduleApexPurgeAllRecords());
        Test.stopTest();
    }
    static testMethod void validateScheduleApexPurgeAllRecordsWithoutSetting(){
        Test.startTest();
            String jobId = System.schedule('ScheduleApexPurgeAllRecordsTest',CRON_EXP,new ScheduleApexPurgeAllRecords());
        Test.stopTest();
    }
}