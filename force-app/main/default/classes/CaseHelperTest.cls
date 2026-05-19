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
 Test Class for CaseHelper Controller
  09/02/2016 Infogain – Created.
 */

  @isTest
   public class CaseHelperTest{
    public  static date date1;
    // vaidate calculateOverage method
    public static testmethod void TestcalculateOverage(){  
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
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'123');
        testBH.Pick_Up_Policy_Weeks__c = 5;
        insert testBH;
        
        caseobj2.Crc_Brand_Hierarchy_Code__c = testBH.id;
        caseobj2.Incident_Date__c = date.today();
        caseobj2.Date__c = date.today();
        caseobj2.Date_Code__c = 'Mar122016';
        caseobj2.Date_Type__c = 'CD';
        
        update caseobj2;
        testCase.Date__c = date.today();
        testCase.Date_Code__c = 'Mar122016';
        testCase.Date_Type__c = 'SB';
        
        update testCase;
        
    }
       
    // test setFieldValues method for line field
    public static testmethod void setFieldValuesLineTest(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
		
        Contact testCont = TestDataSetup.createContact('Test Fname','DOE',testAcc.Id,true,'15122',bdate,'Test Street', true, true);
        testCont.CustomerType__c='CONSUMER';
        insert testCont;
		
		
        Contact testCont2 = TestDataSetup.createContact('Test Fname','DOE',testAcc.Id,true,'15122',bdate,'Test Street', true, true);
        testCont2.CustomerType__c='RESEARCH PANELIST';
        insert testCont2;
		
        list<Case> lstCase = new list<Case>();
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        testIH.Factory_Controllable_Flag__c = false;
        insert testIH;
        
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'123');
        testBH.Pick_Up_Policy_Weeks__c = 5;
        testBH.Short_Cut__c = '1234';
        insert testBH;
        
        Test.startTest();
        List<Case> testInsertList = new List<Case>();
        
        //Test Case 1
        Case testCase1 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase1.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase1.DateCodeUnit__c = 'U';
        testCase1.Issue_Hierarchy_Code__c = testIH.Id;
        testCase1.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase1);

        //Test Case 2
        Case testCase2 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase2.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase2.DateCodeUnit__c = 'J';
        testCase2.Issue_Hierarchy_Code__c = testIH.Id;
        testCase2.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase2);
        
        //Test Case 3
        Case testCase3 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase3.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase3.DateCodeUnit__c = 'N';
        testCase3.Issue_Hierarchy_Code__c = testIH.Id;
        testCase3.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase3);
        
        //Test Case 4
        Case testCase4 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase4.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase4.DateCodeUnit__c = 'O';
        testCase4.Issue_Hierarchy_Code__c = testIH.Id;
        testCase4.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase4);
		
		
        //Test Case 5
        Case testCase5 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase5.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase5.DateCodeUnit__c = 'P';
        testCase5.Issue_Hierarchy_Code__c = testIH.Id;
        testCase5.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase5);
		
        //Test Case 6
        Case testCase6 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase6.Product_Line__c = 'TOBACCO DERIVED NICOTINE POUCH';
        testCase6.DateCodeUnit__c = 'E';
        testCase6.Issue_Hierarchy_Code__c = testIH.Id;
        testCase6.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase6);
        
        insert testInsertList;
    }
       
    // test setFieldValues method for line field
    public static testmethod void setFieldValuesLineTest2(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','DOE',testAcc.Id,true,'15122',bdate,'Test Street', true, true);
        testCont.CustomerType__c='CONSUMER';
        insert testCont;
        list<Case> lstCase = new list<Case>();
        
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMIP',true);
        insert testOpCo;
        Operating_Company__c testOpCo2= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo2;
        
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        TFN__c testTFN2 = TestDataSetup.createTFN(true, '1800', 45, testOpCo2);
        insert testTFN2;
        
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        Transaction_Management__c testTM2= TestDataSetup.createTM(testOpCo2, testTFN2);
        insert testTM2;
        
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        testIH.Factory_Controllable_Flag__c = false;
        insert testIH;
        
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'123');
        testBH.Pick_Up_Policy_Weeks__c = 5;
        testBH.Short_Cut__c = '1234';
        insert testBH;
        
        Test.startTest();
        List<Case> testInsertList = new List<Case>();
        
        //Test Case 1
        Case testCase1 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase1.Product_Line__c = 'Cigarettes';
        testCase1.DateCodeUnit__c = '3B5';
        testCase1.Issue_Hierarchy_Code__c = testIH.Id;
        testCase1.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase1);
        
        //Test Case 2
        Case testCase2 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase2.Product_Line__c = 'Cigarettes';
        testCase2.DateCodeUnit__c = '305';
        testCase2.Issue_Hierarchy_Code__c = testIH.Id;
        testCase2.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase2);
        
        //Test Case 3
        Case testCase3 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase3.Product_Line__c = 'Test Product';
        testCase3.DateCodeUnit__c = '305';
        testCase3.Issue_Hierarchy_Code__c = testIH.Id;
        testCase3.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase3);
        
        //Test Case 4
        Case testCase4 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase4.Product_Line__c = 'Test Product';
        testCase4.DateCodeUnit__c = 'K';
        testCase4.DateCodeRptFactory__c = 'MC_USSTC';
        testCase4.Issue_Hierarchy_Code__c = testIH.Id;
        testCase4.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase4);
        
        //Test Case 5
        Case testCase5 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase5.Product_Line__c = 'Test Product';
        testCase5.DateCodeUnit__c = 'G';
        testCase5.DateCodeRptFactory__c = 'MC_USSTC';
        testCase5.Issue_Hierarchy_Code__c = testIH.Id;
        testCase5.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase5);
        
        //Test Case 6
        Case testCase6 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase6.Product_Line__c = 'Test Product';
        testCase6.DateCodeUnit__c = 'T';
        testCase6.DateCodeRptFactory__c = 'MC_USSTC';
        testCase6.Issue_Hierarchy_Code__c = testIH.Id;
        testCase6.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase6);
        
        //Test Case 7
        Case testCase7 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase7.Product_Line__c = 'Test Product';
        testCase7.DateCodeUnit__c = 'Y';
        testCase7.DateCodeRptFactory__c = 'MC_USSTC';
        testCase7.Issue_Hierarchy_Code__c = testIH.Id;
        testCase7.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase7);
        
        //Test Case 8
        Case testCase8 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase8.Product_Line__c = 'Test Product';
        testCase8.DateCodeUnit__c = 'Z';
        testCase8.DateCodeRptFactory__c = 'MC_USSTC';
        testCase8.Issue_Hierarchy_Code__c = testIH.Id;
        testCase8.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase8);
        
        //Test Case 9
        Case testCase9 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM2.Id,testOpCo2.id);
        testCase9.Product_Line__c = 'Test Product';
        testCase9.DateCodeUnit__c = 'X';
        testCase9.DateCodeRptFactory__c = 'MC_USSTC';
        testCase9.Issue_Hierarchy_Code__c = testIH.Id;
        testCase9.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase9);
        
        insert testInsertList;
        
        Test.stopTest();
    }
       
    // test setFieldValues method for line field
    public static testmethod void setFieldValuesLineTest3(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','DOE',testAcc.Id,true,'15122',bdate,'Test Street', true, true);
        testCont.CustomerType__c='CONSUMER';
        insert testCont;
        list<Case> lstCase = new list<Case>();
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        testIH.Factory_Controllable_Flag__c = false;
        insert testIH;
        
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'123');
        testBH.Pick_Up_Policy_Weeks__c = 5;
        testBH.Short_Cut__c = '1234';
        insert testBH;
        
        Test.startTest();
        List<Case> testInsertList = new List<Case>();
        
        //Test Case 1
        Case testCase1 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase1.Product_Line__c = 'Test Product Line';
        testCase1.DateCodeUnit__c = '3B5';
        testCase1.Mfg_Trace_code__c = 'V123X13B5';
        testCase1.DateCodeRptFactory__c = 'MC_JMC';
        testCase1.Issue_Hierarchy_Code__c = testIH.Id;
        testCase1.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase1);
        
        //Test Case 2
        Case testCase2 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase2.Product_Line__c = 'Test Product Line';
        testCase2.DateCodeUnit__c = '3B5';
        testCase2.Mfg_Trace_code__c = 'V123XN3B';
        testCase2.DateCodeRptFactory__c = 'NS';
        testCase2.Issue_Hierarchy_Code__c = testIH.Id;
        testCase2.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase2);
        
        //Test Case 3
        Case testCase3 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase3.Product_Line__c = 'Test Product Line';
        testCase3.DateCodeUnit__c = '3B5';
        testCase3.Mfg_Trace_code__c = 'V123XS3B';
        testCase3.DateCodeRptFactory__c = 'NS';
        testCase3.Issue_Hierarchy_Code__c = testIH.Id;
        testCase3.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase3);
        
        //Test Case 4
        Case testCase4 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase4.Product_Line__c = 'Test Product Line';
        testCase4.DateCodeUnit__c = '3B5';
        testCase4.Mfg_Trace_code__c = 'V123XH3B';
        testCase4.DateCodeRptFactory__c = 'NS';
        testCase4.Issue_Hierarchy_Code__c = testIH.Id;
        testCase4.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase4);
        
        //Test Case 5
        Case testCase5 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase5.Product_Line__c = 'Test Product Line';
        testCase5.DateCodeUnit__c = '3B5';
        testCase5.Mfg_Trace_code__c = 'V123XI3B';
        testCase5.DateCodeRptFactory__c = 'NS';
        testCase5.Issue_Hierarchy_Code__c = testIH.Id;
        testCase5.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase5);
        
        //Test Case 6
        Case testCase6 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase6.Product_Line__c = 'Test Product Line';
        testCase6.DateCodeUnit__c = '3B5';
        testCase6.Mfg_Trace_code__c = 'V123XV3B';
        testCase6.DateCodeRptFactory__c = 'NS';
        testCase6.Issue_Hierarchy_Code__c = testIH.Id;
        testCase6.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase6);
        
        //Test Case 7
        Case testCase7 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase7.Product_Line__c = 'Test Product Line';
        testCase7.DateCodeUnit__c = '3B5';
        testCase7.Mfg_Trace_code__c = 'V123XL3B';
        testCase7.DateCodeRptFactory__c = 'NS';
        testCase7.Issue_Hierarchy_Code__c = testIH.Id;
        testCase7.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase7);
        
        //Test Case 8
        Case testCase8 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase8.Product_Line__c = 'Test Product Line';
        testCase8.DateCodeUnit__c = '3B5';
        testCase8.Mfg_Trace_code__c = 'V123XE3B';
        testCase8.DateCodeRptFactory__c = 'NS';
        testCase8.Issue_Hierarchy_Code__c = testIH.Id;
        testCase8.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase8);
        
        //Test Case 9
        Case testCase9 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase9.Product_Line__c = 'Test Product Line';
        testCase9.DateCodeUnit__c = '3B5';
        testCase9.Mfg_Trace_code__c = 'V123XA3B';
        testCase9.DateCodeRptFactory__c = 'NS';
        testCase9.Issue_Hierarchy_Code__c = testIH.Id;
        testCase9.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase9);
        
        //Test Case 10
        Case testCase10 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase10.Product_Line__c = 'Test Product Line';
        testCase10.DateCodeUnit__c = '3B5';
        testCase10.Mfg_Trace_code__c = 'V123XB3B';
        testCase10.DateCodeRptFactory__c = 'NS';
        testCase10.Issue_Hierarchy_Code__c = testIH.Id;
        testCase10.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase10);
        
        //Test Case 11
        Case testCase11 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase11.Product_Line__c = 'Test Product Line';
        testCase11.DateCodeUnit__c = '3B5';
        testCase11.Mfg_Trace_code__c = 'V123XR3B';
        testCase11.DateCodeRptFactory__c = 'NS';
        testCase11.Issue_Hierarchy_Code__c = testIH.Id;
        testCase11.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase11);
        
        //Test Case 12
        Case testCase12 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase12.Product_Line__c = 'Test Product Line';
        testCase12.DateCodeUnit__c = '3B5';
        testCase12.Mfg_Trace_code__c = 'V123XC3B';
        testCase12.DateCodeRptFactory__c = 'NS';
        testCase12.Issue_Hierarchy_Code__c = testIH.Id;
        testCase12.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase12);
        
        //Test Case 13
        Case testCase13 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase13.Product_Line__c = 'Test Product Line';
        testCase13.DateCodeUnit__c = '3B5';
        testCase13.Mfg_Trace_code__c = 'V123XM3B';
        testCase13.DateCodeRptFactory__c = 'NS';
        testCase13.Issue_Hierarchy_Code__c = testIH.Id;
        testCase13.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase13);
        
        //Test Case 14
        Case testCase14 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase14.Product_Line__c = 'Test Product Line';
        testCase14.DateCodeUnit__c = '3B5';
        testCase14.Mfg_Trace_code__c = 'V123XP3B';
        testCase14.DateCodeRptFactory__c = 'NS';
        testCase14.Issue_Hierarchy_Code__c = testIH.Id;
        testCase14.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase14);
        
        //Test Case 15
        Case testCase15 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase15.Product_Line__c = 'Test Product Line';
        testCase15.DateCodeUnit__c = '3B5';
        testCase15.Mfg_Trace_code__c = 'V123X03B';
        testCase15.DateCodeRptFactory__c = 'NS';
        testCase15.Issue_Hierarchy_Code__c = testIH.Id;
        testCase15.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase15);
        
		
		
        
        //Test Case 17
        Case testCase17 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase17.Product_Line__c = 'Test Product Line';
        testCase17.DateCodeUnit__c = '3B5';
        testCase17.Mfg_Trace_code__c = 'V123XN3B';
        testCase17.DateCodeRptFactory__c = 'FP';
        testCase17.Issue_Hierarchy_Code__c = testIH.Id;
        testCase17.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase17);
        
        //Test Case 18
        Case testCase18 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase18.Product_Line__c = 'Test Product Line';
        testCase18.DateCodeUnit__c = '3B5';
        testCase18.Mfg_Trace_code__c = 'V123XS3B';
        testCase18.DateCodeRptFactory__c = 'FP';
        testCase18.Issue_Hierarchy_Code__c = testIH.Id;
        testCase18.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase18);
        
        //Test Case 19
        Case testCase19 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase19.Product_Line__c = 'Test Product Line';
        testCase19.DateCodeUnit__c = '3B5';
        testCase19.Mfg_Trace_code__c = 'V123XH3B';
        testCase19.DateCodeRptFactory__c = 'FP';
        testCase19.Issue_Hierarchy_Code__c = testIH.Id;
        testCase19.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase19);
        
        //Test Case 20
        Case testCase20 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase20.Product_Line__c = 'Test Product Line';
        testCase20.DateCodeUnit__c = '3B5';
        testCase20.Mfg_Trace_code__c = 'V123XI3B';
        testCase20.DateCodeRptFactory__c = 'FP';
        testCase20.Issue_Hierarchy_Code__c = testIH.Id;
        testCase20.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase20);
        
        //Test Case 21
        Case testCase21 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase21.Product_Line__c = 'Test Product Line';
        testCase21.DateCodeUnit__c = '3B5';
        testCase21.Mfg_Trace_code__c = 'V123XV3B';
        testCase21.DateCodeRptFactory__c = 'FP';
        testCase21.Issue_Hierarchy_Code__c = testIH.Id;
        testCase21.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase21);
        
        //Test Case 22
        Case testCase22 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase22.Product_Line__c = 'Test Product Line';
        testCase22.DateCodeUnit__c = '3B5';
        testCase22.Mfg_Trace_code__c = 'V123XL3B';
        testCase22.DateCodeRptFactory__c = 'FP';
        testCase22.Issue_Hierarchy_Code__c = testIH.Id;
        testCase22.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase22);
        
        //Test Case 23
        Case testCase23 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase23.Product_Line__c = 'Test Product Line';
        testCase23.DateCodeUnit__c = '3B5';
        testCase23.Mfg_Trace_code__c = 'V123XE3B';
        testCase23.DateCodeRptFactory__c = 'FP';
        testCase23.Issue_Hierarchy_Code__c = testIH.Id;
        testCase23.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase23);
        
		
        insert testInsertList;
        
        Test.stopTest();
    }
       
    // test setFieldValues method for line field
    public static testmethod void setFieldValuesLineTest4(){
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','DOE',testAcc.Id,true,'15122',bdate,'Test Street', true, true);
        testCont.CustomerType__c='CONSUMER';
        insert testCont;
        list<Case> lstCase = new list<Case>();
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        
        Classification__c testClsfy = TestDataSetup.createClassify('Test Classification');
        insert testClsfy;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Issue_Type__c testIT = TestDataSetup.createIT('Test Cause');
        insert testIT;
        Group__c testGroup = TestDataSetup.createGroup('Test Group');
        insert testGroup;
        Cause__c testCause = TestDataSetup.createCause('Test Cause');
        insert testCause;
        Reason__c testReason = TestDataSetup.createReason('Test Reason');
        insert testReason;
        Issue_Hierarchy__c testIH = TestDataSetup.createIH(testClsfy, testPL, testIT, testGroup, testCause, testReason, true);
        testIH.Factory_Controllable_Flag__c = false;
        insert testIH;
        
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready','12345', testBrand, testPL,'123');
        testBH.Pick_Up_Policy_Weeks__c = 5;
        testBH.Short_Cut__c = '1234';
        insert testBH;
        
        Test.startTest();
        List<Case> testInsertList = new List<Case>();
        
        //Test Case 1
        Case testCase1 = TestDataSetup.createTestCase(testAcc, 1200, testCont.Id, testTM.Id,testOpCo.id);
        testCase1.Product_Line__c = 'Test Product Line';
        testCase1.DateCodeUnit__c = '3B5';
        testCase1.Mfg_Trace_code__c = 'V123XN3B5';
        testCase1.DateCodeRptFactory__c = 'NS';
        testCase1.Issue_Hierarchy_Code__c = testIH.Id;
        testCase1.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testInsertList.add(testCase1);
        
        insert testInsertList;
        
        Test.stopTest();
    }
       
       
       public static testmethod void setFieldValuesLineTest5(){
           
        Test.startTest();
       		CaseHelper chObject = new CaseHelper();
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('E');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('F');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('G');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('J');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('K');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('M');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('0');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('W');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('X');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('Y');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('Z');
            chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitNumber('XXX');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('A');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('B');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('G');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('J');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('K');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('M');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('O');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('P');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Y');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('R');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('W');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('X');
           	chObject.generateLineValueDateCodeRptFactoryFPDateCodeUnitAlpha('Z');
	
        Test.stopTest();
       }
}