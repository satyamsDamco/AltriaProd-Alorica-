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
Test Class for Brand Hierarchy Controller
07/19/2016 Infogain – Created.
*/

@isTest
private class BrandHierarchyControllerTest {
    
    /*Validate Constructor, brandListData method, and else condition of productLineListData*/
    static testMethod void validateBrandHierarchyController1() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL1', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand', 'Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id); 
        
        Test.startTest();
        BrandHierarchyController obj=  new BrandHierarchyController(new ApexPages.StandardController(testBH));
        Test.stopTest();
        //Assertions
        system.assertEquals(testBH.Id, obj.brandHierId);
    }
    
    //Validate ProductLineListData method if condition
    static testMethod void validateProductLineListData() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL2', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand', 'Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id);
        ApexPages.currentPage().getParameters().put('productlineName',testPL.Name); 
        
        Test.startTest();
        BrandHierarchyController obj=  new BrandHierarchyController(new ApexPages.StandardController(testBH));
        obj.productLineListData();
        Test.stopTest();
          //Assertions
        system.assertEquals(testPL.Name, obj.selectedProductLine);
    }
    
    //Validate Fill Brand Hierarchy method
    static testMethod void validateFillBrandHierarchy() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL2', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand', 'Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id); 
        
        Test.startTest();
            BrandHierarchyController obj=  new BrandHierarchyController(new ApexPages.StandardController(testBH));
            obj.fillBrandHierarchy();
        Test.stopTest();
    }
    
    //Validate else condition of BrandHierData method
    static testMethod void validateBrandHierDataListElse() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL4', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand', 'Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id);
        ApexPages.currentPage().getParameters().put('brand',testBrand.Name);
        
        Test.startTest();
        List<Brand_Hierarchy__c> brandHierDataLst = BrandHierarchyController.brandHierDataList(null, 'Test Product Line', testBrand.Name, 'Filtered', 'Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Banded Paper Ny', '12345', 'Ready', 'upcSearch');
        Test.stopTest();
          //Assertions
        system.assertEquals(testBrand.id, brandHierDataLst[0].Brand_Code__c);
    }
    
    //Validate if condition of BrandHierData method
    static testMethod void validateBrandHierDataListIf() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('Test Product Line', 'Test PL5', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand', 'Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Filtered', 'Banded Paper Ny', 'Ready', '12345', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id);
        ApexPages.currentPage().getParameters().put('brand',testBrand.Name);
        
        Test.startTest();
        List<Brand_Hierarchy__c> brandHierDataLst = BrandHierarchyController.brandHierDataList(testBH.Id, 'Test Product Line', testBrand.Name, 'Filtered', 'Full Flavor', '100s', 'Soft Pack', 'Menthol', 'Banded Paper Ny', '12345', 'Ready', 'upcSearch');
        Test.stopTest();
          //Assertions
        system.assertEquals(testBrand.id, brandHierDataLst[0].Brand_Code__c);    
    }    
    //Validate Reset method
    static testMethod void validateReset() {
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        Product_Line__c testPL = TestDataSetup.createPL('', 'Test PL6', testOpCo);
        insert testPL;
        Brand__c testBrand = TestDataSetup.createBrand('Test Brand','Test Code', testPL, testOpCo);
        insert testBrand;
        Brand_Hierarchy__c testBH = TestDataSetup.createBH('', '', '', '', '', '', '', '', testBrand, testPL, '12345');
        insert testBH;
        ApexPages.currentPage().getParameters().put('brandHierId',testBH.Id); 
        
        Test.startTest();
        BrandHierarchyController obj=  new BrandHierarchyController(new ApexPages.StandardController(testBH));
        obj.reset();
        Test.stopTest();
          //Assertions
        system.assertEquals(false,obj.showTable);
    }
}