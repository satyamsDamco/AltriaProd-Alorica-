/*
*   @Author: Ariel Tribunal
*   @Date: 7/29/2019
*   @Apex Name: ChatConsumerSearchControllerTest
*   @Description: Test class for ChatConsumerSearchController coverage
*
*/
@isTest
public class ChatConsumerSearchControllerTest{
    
    static TestMethod void TestredirectCustomerSearch(){
        // Setup Data
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN= TestDataSetup.createTFN(True,'0001',1,testOpCo);
        insert testTFN;
        testOpCo.Default_TFN__c = testTFN.Id;
        update testOpCo;
        
        Test.startTest();
        PageReference ActPgref = ChatConsumerSearchController.redirectCustomerSearch();
        Test.stopTest();
        // Validate return PageReference
        PageReference ExpPgref = new pagereference('/apex/ConsumerSearch');
        system.assertNotEquals(ExpPgref, ActPgref);
    }
    
}