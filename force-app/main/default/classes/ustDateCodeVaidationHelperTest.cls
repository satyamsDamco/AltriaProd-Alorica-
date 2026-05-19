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
  Test Class for ustDateCodeVaidationHelper Controller
  11/28/2016 Infogain – Created.
   */

@isTest
public class ustDateCodeVaidationHelperTest {
    
    //Validate ustTraceCodeValidation with product line "EV".
    private static testMethod void dateCodeFieldTestEV() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('SB', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation with product line "TP".
    private static testMethod void dateCodeFieldTestTP() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('MD', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="GFU".
    private static testMethod void dateCodeFieldTestGFU() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('GFU', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="CD".
    private static testMethod void dateCodeFieldTestCD() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('CD', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="WB".
    private static testMethod void dateCodeFieldTestWB() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('WB', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="SN".
    private static testMethod void dateCodeFieldTestSN() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('SN', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="''".
    private static testMethod void dateCodeFieldTestN() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }
    
    //Validate ustTraceCodeValidation Where product line "TP" and Brand_Hierarchy__c="//".
    private static testMethod void dateCodeFieldTestType() {
        
        string productLineCode='TP';
        string dateCode='fbb42323j';
        string oprCompany='USST';
        string traceCodeLocation='CAN';
        string brandHierarchyId='a0655000002KhdtAAC';
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCO);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','12345',testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH=TestDataSetup.createBHUST('//', testBrand, testPL,'123');
        insert testBH;
        
        Test.startTest();
        UstDateCodeValidationHelper ustObj=new UstDateCodeValidationHelper();
        ustObj.ustTraceCodeValidation(productLineCode,dateCode,oprCompany,traceCodeLocation,testbh.id);
        Test.stopTest();
    }

}