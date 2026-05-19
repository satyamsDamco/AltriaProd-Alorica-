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
Test Class for AgeMappingHandler Controller
08/31/2016 Infogain – Created.
*/
      @isTest
       public class AgeMappingHandlerTest{ 
       //Validate  deActiveMapping method   
       public static testmethod void TestdeActiveMapping(){
        list<Age_Mapping__c> lstAgeMapping = new list<Age_Mapping__c>();
        // insert some records
        Age_Mapping__c ageMappingObj1 = TestDataSetup.createAgeMapping('NY', 18, '14219', true);
        lstAgeMapping.add(ageMappingObj1);
        Age_Mapping__c ageMappingObj2 = TestDataSetup.createAgeMapping('NY', 23, '12345', true);
        lstAgeMapping.add(ageMappingObj2);
        Age_Mapping__c ageMappingObj3 = TestDataSetup.createAgeMapping('NY', 18, '23456', true);
        lstAgeMapping.add(ageMappingObj3);
        insert lstAgeMapping;
        ageMappingObj1.Age__c = 21;
        //checking if condition where zip code is null
        ageMappingObj1.Zip__c = null;
        update ageMappingObj1;
    }
}