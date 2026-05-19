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
test class of issue review page
11/07/2016 Infogain – Created.
*/
@isTest
public class IssueAdjustmentHelperTest {
    
    //  IssueAdjustmentHelper controller
    static testMethod void validateIssueAdjustmentHelper() {
        
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','USST',true);
        insert testOpCo;
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL11 = TestDataSetup.createPL('MST16','SP', testOpCo);
        testPL11.isActive__c = true;
        insert testPL11; 
        Product_Line__c testPL12 = TestDataSetup.createPL('E-Cigarette','E-Cigarette', testOpCo);
        testPL12.isActive__c = true;
        insert testPL12; 
        Product_Line__c testPL13 = TestDataSetup.createPL('TOBACCO DERIVED NICOTINE POUCH','TDNP', testOpCo);
        testPL13.isActive__c = true;
        insert testPL13; 
        Product_Line__c testPL14 = TestDataSetup.createPL('Cigarettes','Cigarettes', testOpCo);
        testPL14.isActive__c = true;
        insert testPL14;
        
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL11, testIT, testGroup, testCause, testReason, true);
        insert testIH;
        Issue_Hierarchy__c testIH1 = TestDataSetup.createIH(testClsfy, testPL11, testIT, testGroup, testCause, testReason, true);
        insert testIH1;
        Issue_Hierarchy__c currIH = [Select Id, Name From Issue_Hierarchy__c Where Id =:testIH1.Id Limit 1];
        string currIHName = currIH.name;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL11, testOpCo);
        insert testBrand;       
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL11,'testVan');
        insert testBH;
        Brand_Hierarchy__c testBH1 = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345',testBrand, testPL11,'testVan');
        insert testBH1;
        Brand_Hierarchy__c currBH = [Select Id, Name From Brand_Hierarchy__c Where Id =:testBH1.Id Limit 1];
        string currBHName = currBH.name;
        
        list<Case> lstCaseIns = new list<Case>();
        Case testCase = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11); 
        lstCaseIns.add(testCase);
        Case testCase1 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase1);
        Case testCase2 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase2);
        Case testCase3 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase3);
        Case testCase4 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase4);
        Case testCase5 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase5);
        Case testCase6 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase6);
        Case testCase7 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase7);
        Case testCase8 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase8);
        Case testCase9 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase9);
        Case testCase10 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase10);
        Case testCase11 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase11);
        Case testCase12 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase12);
        Case testCase13 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase13);
        Case testCase14 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        testCase14.Trace_Code_Location__c = 'CAN';
        lstCaseIns.add(testCase14);
        Case testCase15 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        testCase15.Trace_Code_Location__c = 'CAN';
        lstCaseIns.add(testCase15);
        Case testCase16 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase16);
        Case testCase17 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase17);
        Case testCase18 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase18);
        Case testCase19 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase19);
        Case testCase20 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase20);
        Case testCase21 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        lstCaseIns.add(testCase21);
        Case testCase22 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL11);
        testCase22.Product_Line_Code__c = testPL11.Id;
        lstCaseIns.add(testCase22);
        Case testCase23 = TestDataSetup.createTestIssue(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id, testBH, currIH,  testPL12);
        testCase23.Product_Line_Code__c = testPL12.Id;
        lstCaseIns.add(testCase23);
        
        Case testCase24 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c = testPL12.Id,
                                   	Mfg_Trace_code__c = '22225260233',Comment__c = 'test'
        );
        lstCaseIns.add(testCase24);
        Case testCase25 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c = testPL12.Id,
                                   	Mfg_Trace_code__c = '2AbCA2456B',Comment__c = 'test',DateCodeRptFactory__c='NS'
        );
        lstCaseIns.add(testCase25);
        Case testCase26 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c = testPL12.Id,
                                   	Mfg_Trace_code__c = 'AAbCA2456B',Comment__c = 'test',DateCodeRptFactory__c='NS'
        );
        lstCaseIns.add(testCase26);
        Case testCase27 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c = testPL12.Id,
                                   	Mfg_Trace_code__c = 'AAbCA2456B',Comment__c = 'test',DateCodeRptFactory__c='FP'
        );
        lstCaseIns.add(testCase27);
        Case testCase28 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c = testPL12.Id,
                                   	Mfg_Trace_code__c = '2AbCA2456B',Comment__c = 'test',DateCodeRptFactory__c='FP',Date_Code__c='01/14/2019'
        );
        lstCaseIns.add(testCase28);
        
        Case testCase29 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c =testPL13.ID,
                                   	Mfg_Trace_code__c = 'WA0011',Comment__c = 'test',DateCodeRptFactory__c='HELSINGBORG',DateCodeUnit__c = 'U'
        );
        lstCaseIns.add(testCase29);
        
         Case testCase30 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c =testPL13.Id,
                                   	Mfg_Trace_code__c = 'WA0011',Comment__c = 'test',DateCodeRptFactory__c='MC_USSTC',DateCodeUnit__c = 'K'
        );
        lstCaseIns.add(testCase30);
        
        Case testCase31 = new Case(Account = testAcc,Purchase_Price__c = 1200,
            						ContactId = testCont.Id,MasterId__c = testTM.Id,Op_Company__c = testOpCo.Id,Crc_Brand_Hierarchy_Code__c = testBH.Id,Issue_Hierarchy_Code__c = currIH.Id,Product_Line_Code__c =testPL14.Id,
                                   	Mfg_Trace_code__c = 'WA0011',Comment__c = 'test',DateCodeRptFactory__c='MC_USSTC',DateCodeUnit__c = '0'
        );
        lstCaseIns.add(testCase31);

        
        insert lstCaseIns;
        list<id> lstCaseIds = new list<id>();
        for(Case c:lstCaseIns){
            lstCaseIds.add(c.Id);           
        }
        List <Issue_Adjustment__c> IssueAdjust = new List<Issue_Adjustment__c>();
        list<Case> currIssue = [Select Id, CaseNumber__c From Case Where Id in: lstCaseIds];
        if(currIssue != null && currIssue.size() > 0){
       
        Issue_Adjustment__c issueAd = TestDataSetup.createIssueAdjust(currIssue[0].CaseNumber__c, true, 'comment',' new','11','41','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd);
        Issue_Adjustment__c issueAd1 = TestDataSetup.createIssueAdjust(currIssue[1].CaseNumber__c, true, 'comment',' new','','41','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd1);
        Issue_Adjustment__c issueAd2 = TestDataSetup.createIssueAdjust(currIssue[2].CaseNumber__c, true, 'comment',' new','11','','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd2);
        Issue_Adjustment__c issueAd3 = TestDataSetup.createIssueAdjust(currIssue[3].CaseNumber__c, true, 'comment',' Fail','11','41','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd3);
        Issue_Adjustment__c issueAd4 = TestDataSetup.createIssueAdjust( null, true, 'comment',' Fail','11','41','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd4);
        Issue_Adjustment__c issueAd5 = TestDataSetup.createIssueAdjust(currIssue[4].CaseNumber__c, true, 'comment',' new','11','41','Review','R','','','R','Testing review');
        IssueAdjust.add(issueAd5);
        Issue_Adjustment__c issueAd6 = TestDataSetup.createIssueAdjust(currIssue[5].CaseNumber__c, true, 'comment',' new','11','41','Review','R','','','T','Testing review');
        IssueAdjust.add(issueAd6);
        Issue_Adjustment__c issueAd7 = TestDataSetup.createIssueAdjust(currIssue[6].CaseNumber__c, true, 'comment',' new','11','41','Review','C','','','U','Testing review');
        IssueAdjust.add(issueAd7);
        Issue_Adjustment__c issueAd8 = TestDataSetup.createIssueAdjust(currIssue[7].CaseNumber__c, true, 'comment','new','11','41','Review','ST','','','U','Testing review');
        IssueAdjust.add(issueAd8);
        Issue_Adjustment__c issueAd9 = TestDataSetup.createIssueAdjust(currIssue[8].CaseNumber__c, true, 'comment','new','11','41','Review','ST','','New Value','U','Testing review');
        IssueAdjust.add(issueAd9);
        Issue_Adjustment__c issueAd10 = TestDataSetup.createIssueAdjust(currIssue[9].CaseNumber__c, true, 'comment','new','11','41','Review','BH','','New Value','U','Testing review');
        IssueAdjust.add(issueAd10);
        Issue_Adjustment__c issueAd11 = TestDataSetup.createIssueAdjust(currIssue[10].CaseNumber__c, true, 'comment','new','11','41','Review','IH','','New Value','U','Testing review');
        IssueAdjust.add(issueAd11);
        Issue_Adjustment__c issueAd12 = TestDataSetup.createIssueAdjust(currIssue[11].CaseNumber__c, true, 'comment','new','11','41','Review','BH','',currBHName,'U','Testing review');
        IssueAdjust.add(issueAd12);
        Issue_Adjustment__c issueAd13 = TestDataSetup.createIssueAdjust(currIssue[12].CaseNumber__c, true, 'comment','new','11','41','Review','IH','',currIHName,'U','Testing review');
        IssueAdjust.add(issueAd13);
        Issue_Adjustment__c issueAd14 = TestDataSetup.createIssueAdjust(currIssue[13].CaseNumber__c, true, 'comment','new','11','41','Review','TC','','new value','U','Testing review');
        IssueAdjust.add(issueAd14);
        Issue_Adjustment__c issueAd15 = TestDataSetup.createIssueAdjust(currIssue[14].CaseNumber__c, true, 'comment','new','11','41','Review','TC','','new value','U','Testing review');
        IssueAdjust.add(issueAd15);
        Issue_Adjustment__c issueAd16 = TestDataSetup.createIssueAdjust(currIssue[15].CaseNumber__c, true, 'comment','new','11','41','Review','DC','','new value','U','Testing review');
        IssueAdjust.add(issueAd16);
        Issue_Adjustment__c issueAd141 = TestDataSetup.createIssueAdjust(currIssue[13].CaseNumber__c, true, 'comment','new','11','41','Review','DC','','new value','U','Testing review');
        IssueAdjust.add(issueAd141);
        Issue_Adjustment__c issueAd151 = TestDataSetup.createIssueAdjust(currIssue[14].CaseNumber__c, true, 'comment','new','11','41','Review','DC','','new value','U','Testing review');
        IssueAdjust.add(issueAd151);    
        Issue_Adjustment__c issueAd17 = TestDataSetup.createIssueAdjust(currIssue[16].CaseNumber__c, true, 'comment','new','11','41','Review','CN','','new value','U','Testing review');
        IssueAdjust.add(issueAd17);
        Issue_Adjustment__c issueAd18 = TestDataSetup.createIssueAdjust(currIssue[17].CaseNumber__c, true, 'comment','new','11','41','Review','RID','','123456','U','Testing review');
        IssueAdjust.add(issueAd18);
        Issue_Adjustment__c issueAd118 = TestDataSetup.createIssueAdjust(currIssue[17].CaseNumber__c, true, 'comment','new','11','41','Review','RID','','sasasa','U','Testing review');
        IssueAdjust.add(issueAd118);
            
        Issue_Adjustment__c issueAd19 = TestDataSetup.createIssueAdjust(currIssue[18].CaseNumber__c, true, 'comment','new','11','41','Review','SCF','','0','U','Testing review');
        IssueAdjust.add(issueAd19);
        Issue_Adjustment__c issueAd20 = TestDataSetup.createIssueAdjust(currIssue[19].CaseNumber__c, true, 'comment','new','11','41','Review','SCF','','1','U','Testing review');
        IssueAdjust.add(issueAd20);
        
        Issue_Adjustment__c issueAd191 = TestDataSetup.createIssueAdjust(currIssue[18].CaseNumber__c, true, 'comment','new','11','41','Review','SCF','','a','U','Testing review');
        IssueAdjust.add(issueAd191);
            
        Issue_Adjustment__c issueAd21 = TestDataSetup.createIssueAdjust(currIssue[20].CaseNumber__c, true, 'comment','new','11','41','Review','ST','','0','U','Testing review');
        IssueAdjust.add(issueAd21);
        Issue_Adjustment__c issueAd22 = TestDataSetup.createIssueAdjust(currIssue[21].CaseNumber__c, true, 'comment','new','11','41','Review','ST','','1','U','Testing review');
        IssueAdjust.add(issueAd22);
        
        Issue_Adjustment__c issueAd221 = TestDataSetup.createIssueAdjust(currIssue[21].CaseNumber__c, true, 'comment','new','11','41','Review','ST','','s','U','Testing review');
        IssueAdjust.add(issueAd221);
            
        Issue_Adjustment__c issueAd23 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Trace Code','TC','','V288X35B1','U','Testing review');
        IssueAdjust.add(issueAd23);
            
        Issue_Adjustment__c issueAd24 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Valid Trace Code','ITVT','','Y','U','Testing review');
        IssueAdjust.add(issueAd24);
            
        Issue_Adjustment__c issueAd25 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Valid Trace Code','ITVT','','Yes','U','Testing review');
        IssueAdjust.add(issueAd25);
            
        Issue_Adjustment__c issueAd26 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Valid Trace Code','ITPD','','7/25/2022','U','Testing review');
        IssueAdjust.add(issueAd26);
            
        Issue_Adjustment__c issueAd27 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Valid Trace Code','ITM','','3B5','U','Testing review');
        IssueAdjust.add(issueAd27);
            
        Issue_Adjustment__c issueAd28 = TestDataSetup.createIssueAdjust(currIssue[22].CaseNumber__c, true, 'comment','new','11','41','Counterfeit Code Lookup','CCL','','Yes','U','Testing review');
        IssueAdjust.add(issueAd28);
            
        Issue_Adjustment__c issueAd29 = TestDataSetup.createIssueAdjust(currIssue[23].CaseNumber__c, true, 'comment','new','11','41','Trace Code','TC','','02323251102','U','Testing review');
        IssueAdjust.add(issueAd29);

        Issue_Adjustment__c issueAd30 = TestDataSetup.createIssueAdjust(currIssue[24].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','NJOY Trace Code 25641022592 sample.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd30);
            
        Issue_Adjustment__c issueAd31 = TestDataSetup.createIssueAdjust(currIssue[25].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd31);
          
        Issue_Adjustment__c issueAd32 = TestDataSetup.createIssueAdjust(currIssue[26].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd32);
            
        Issue_Adjustment__c issueAd33 = TestDataSetup.createIssueAdjust(currIssue[27].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd33);
            
        Issue_Adjustment__c issueAd34 = TestDataSetup.createIssueAdjust(currIssue[28].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd34);
            
        Issue_Adjustment__c issueAd35 = TestDataSetup.createIssueAdjust(currIssue[29].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd35);
            
        Issue_Adjustment__c issueAd36 = TestDataSetup.createIssueAdjust(currIssue[30].CaseNumber__c, true, 'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd36);
        
        Issue_Adjustment__c issueAd37 = TestDataSetup.createIssueAdjust(currIssue[28].CaseNumber__c, true, 'comment','new','11','41','Trace Code','TC','2AbCB2456B','2AbCA2456B','U','Testing review');
        IssueAdjust.add(issueAd37);  
        
        Issue_Adjustment__c issueAd38 = TestDataSetup.createIssueAdjust(currIssue[28].CaseNumber__c, true, 'comment','new','11','41','Date Code','DC','01/14/2019','01/14/2020','U','Testing review');
        IssueAdjust.add(issueAd38); 
        
        Issue_Adjustment__c issueAd39 = TestDataSetup.createIssueAdjust(currIssue[31].CaseNumber__c, true,'comment','new','11','41','Consumer Notes','CN','','Testingle.#Resend#','U','Testing review');
        IssueAdjust.add(issueAd39);

        insert IssueAdjust;
        }
        
        

        Test.startTest();
        IssueAdjustmentHelper controller = new IssueAdjustmentHelper();
        controller.updateIssueData(IssueAdjust);
        Test.stopTest();
    }
    
    

}