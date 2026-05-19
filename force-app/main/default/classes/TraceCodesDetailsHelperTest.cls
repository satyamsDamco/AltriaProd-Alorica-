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
  Test Class for TraceCodesDetailHelper Controller
  11/25/2016 Infogain – Created.
   */

@isTest

public class TraceCodesDetailsHelperTest {
    
    //Testing constructor of TraceCodesDetailsHelper controller
   private static testMethod void getAllTraceCodeValuesTest() {
        string ProductLineCode='EV';
        string TraceCodeObj='078';
        string OpCompany='KIT';
        string TraceCodeLocation='3';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    //testing method getAllTraceCodeValues for product line GP
    private static testMethod void getAllTraceCodeValuesTestGP() {
        string ProductLineCode='GP';
        string TraceCodeObj='02cb3bc';
        string OpCompany='JMC';
        string TraceCodeLocation='PAC';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    ///testing method getAllTraceCodeValues for product line PT
    private static testMethod void getAllTraceCodeValuesTestPT() {
        string ProductLineCode='PT';
        string TraceCodeObj='EAHAASG';
        string OpCompany='JMC';
        string TraceCodeLocation='CAS';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    ///testing method getAllTraceCodeValues for product line NC
    private static testMethod void getAllTraceCodeValuesTestNC() {
        string ProductLineCode='NC';
        string TraceCodeObj='085229YI';
        string OpCompany='JMC';
        string TraceCodeLocation='CAS';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    ///testing method getAllTraceCodeValues for product line PT without Tracecode
    private static testMethod void getAllTraceCodeValuesTestPTNoTrace() {
        string ProductLineCode='PT';
        string TraceCodeObj='';
        string OpCompany='JMC';
        string TraceCodeLocation='CAS';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }

    ///testing method getAllTraceCodeValues for product line GP without Tracecode
    private static testMethod void getAllTraceCodeValuesTestGPNoTrace() {
        string ProductLineCode='GP';
        string TraceCodeObj='';
        string OpCompany='JMC';
        string TraceCodeLocation='CAS';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    //09-25-2019 Jannel Full coverage except catch trigger
    ///testing method getAllTraceCodeValues for product line AS without Tracecode
    private static testMethod void getAllTraceCodeValuesTestASNoTrace() {
        string ProductLineCode='AS';
        string TraceCodeObj='';
        string OpCompany='JMC';
        string TraceCodeLocation='CAS';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    ///testing method getAllTraceCodeValues for product line AS With No Location
    private static testMethod void getAllTraceCodeValuesTestASNoLocation() {
        string ProductLineCode='AS';
        string TraceCodeObj='';
        string OpCompany='JMC';
        string TraceCodeLocation='';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
    
    //testing method getAllTraceCodeValues for product line GP with 9-char
    private static testMethod void getAllTraceCodeValuesTestGP9() {
        string ProductLineCode='GP';
        string TraceCodeObj='A002X0012';
        string OpCompany='JMC';
        string TraceCodeLocation='PAC';
        string UstDateCodeType='';
        string UstDateCode='';
    
        Test.startTest();
        TraceCodesDetailsHelper controller=new TraceCodesDetailsHelper();
        controller.getAllTraceCodeValues(ProductLineCode,TraceCodeObj,OpCompany,TraceCodeLocation,UstDateCodeType,UstDateCode,null);
        Test.stopTest();
    }
}