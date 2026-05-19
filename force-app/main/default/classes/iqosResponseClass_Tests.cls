/*
*   @Author: Gian Carlo Cutchon
*   @Date: 2/14/2018
*   @Apex Name: iqosResponseClass_Tests
*   @Description: This test class for IQOSResponseClass.
*
*/
@isTest
private class iqosResponseClass_Tests {

    static testMethod void iqosResponse_Test() {
        
        test.startTest();
            IQOSResponseClass.jsonWrapper_Auth a = new  IQOSResponseClass.jsonWrapper_Auth();
            a.token_type = 'test';
            a.expires_in = '1';
            a.ext_expires_in = '2';
            a.expires_on = '3';
            a.not_before = '4';
            a.resource = '5';
            a.access_token = 'test';
        test.stopTest();
        
    }
}