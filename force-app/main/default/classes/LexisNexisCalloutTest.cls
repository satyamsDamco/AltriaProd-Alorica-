/*
Test Class for LexisNexisCallout and LexisNexisServices
Note: LexisNexisCallout builds its own stub response when Test.isRunningTest() is true,
selected by the request body: contains '123' -> empty body, contains '9876' -> FAIL body,
otherwise -> Pass body. The stub response has no HTTP status, so every call returns 'Error'.
*/
@isTest
private class LexisNexisCalloutTest {

    private static LexisNexisClasses.AgeVerificationRequest buildRequest(String zip){
        LexisNexisClasses.AgeVerificationRequest req = new LexisNexisClasses.AgeVerificationRequest();
        req.Prefix = 'Mr';
        req.FirstName = 'John';
        req.MiddleName = 'A';
        req.LastName = 'Doe';
        req.Suffix = 'Jr';
        req.DOBYear = '1980';
        req.DOBMonth = '05';
        req.DOBDay = '15';
        req.AddressLine1 = 'Main Street';
        req.AddressLine2 = 'Apt 4';
        req.City = 'Richmond';
        req.State = 'VA';
        req.Zip = zip;
        return req;
    }

    @testSetup
    static void setupData(){
        List<LexisNexis_Integration__c> settings = new List<LexisNexis_Integration__c>{
            new LexisNexis_Integration__c(
                Name = 'PMUSA',
                EndPointURL__c = 'https://lexisnexis.example.com',
                Account_Number__c = 'ACCT',
                User_Id__c = 'user',
                Password__c = 'pass',
                Workflow_Name__c = 'CRC_NEW',
                RequestTimeOut__c = null
            ),
            new LexisNexis_Integration__c(
                Name = 'USSTC',
                EndPointURL__c = 'https://lexisnexis.example.com',
                Account_Number__c = 'ACCT',
                User_Id__c = 'user',
                Password__c = 'pass',
                Workflow_Name__c = 'CRC_NEW',
                RequestTimeOut__c = 30
            )
        };
        insert settings;
    }

    // All request fields populated, default stub response
    @isTest
    static void testAgeVerificationAllFields(){
        Test.startTest();
        LexisNexisCallout callout = new LexisNexisCallout('Age Verification', 'USSTC');
        LexisNexisClasses.AgeVerificationResponse res = callout.AgeVerificationRequest(buildRequest('23219'));
        Test.stopTest();

   
    }

    // All request fields blank; unknown company falls back to PMUSA settings
    @isTest
    static void testAgeVerificationBlankFields(){
        LexisNexisClasses.AgeVerificationRequest req = new LexisNexisClasses.AgeVerificationRequest();
        req.Prefix = '';
        req.FirstName = '';
        req.MiddleName = '';
        req.LastName = '';
        req.Suffix = '';
        req.DOBYear = '';
        req.DOBMonth = '';
        req.DOBDay = '';
        req.AddressLine1 = '';
        req.AddressLine2 = '';
        req.City = '';
        req.State = '';
        req.Zip = '';

        Test.startTest();
        LexisNexisCallout callout = new LexisNexisCallout('Age Verification', 'UNKNOWN_COMPANY');
        LexisNexisClasses.AgeVerificationResponse res = callout.AgeVerificationRequest(req);
        Test.stopTest();

    }

    // Request containing '9876' gets the FAIL stub response
    @isTest
    static void testAgeVerificationFailStub(){
        Test.startTest();
        LexisNexisCallout callout = new LexisNexisCallout('Age Verification', 'PMUSA');
        LexisNexisClasses.AgeVerificationResponse res = callout.AgeVerificationRequest(buildRequest('98765'));
        Test.stopTest();

       
    }

    // Request containing '123' gets the empty stub response
    @isTest
    static void testAgeVerificationEmptyStub(){
        Test.startTest();
        LexisNexisCallout callout = new LexisNexisCallout('Age Verification', 'PMUSA');
        LexisNexisClasses.AgeVerificationResponse res = callout.AgeVerificationRequest(buildRequest('12345'));
        Test.stopTest();

      
    }

    // Setters, logging helpers and truncation
    @isTest
    static void testHelperMethods(){
        LexisNexisCallout callout = new LexisNexisCallout('Age Verification', 'USSTC');
        callout.transaction(null);
        callout.formName('Consumer Age verification');
        callout.customerCCN('CCN001');
        callout.customerUpdate(null);

        callout.log('First message');
        callout.log('Second message');
       
        callout.log(new LexisNexisCallout.LexisNexisCalloutException('Test exception'));
        
        // Payloads longer than the field size are truncated
        String longText = 'x'.repeat(140000);
        callout.logRequest(longText);
        callout.logResponse(longText);
        System.assert(callout.log.Request__c.contains('Request JSON is truncated'));
        System.assert(callout.log.Response__c.contains('Response JSON is truncated'));

        callout.logRequest('short');
        callout.logResponse('short');
        
    }

    // LexisNexisServices: CCN and customer populated, log record inserted
    @isTest
    static void testServicesWithCustomer(){
        Contact con = new Contact(
            FirstName = 'Lexis',
            LastName = 'NexisTest',
            Street_Address__c = 'Main Street',
            Zip_Code__c = '23219',
            Birthdate1__c = Date.newInstance(1980, 5, 15)
        );
        insert con;

        Test.startTest();
        LexisNexisClasses.AgeVerificationResponse res = LexisNexisServices.AgeVerificationRequest(
            buildRequest('23219'), null, 'Consumer Age verification', 'USSTC', 'CCN001', con.Id);
        Test.stopTest();

       
        IntegrationLog__c log = [SELECT CustomerCCN__c, Consumer_Trade_Customer__c, FormName__c
                                 FROM IntegrationLog__c LIMIT 1];
        
    }

    // LexisNexisServices: exception during the callout is caught and logged
    @isTest
    static void testServicesException(){
        Test.startTest();
        LexisNexisClasses.AgeVerificationResponse res = LexisNexisServices.AgeVerificationRequest(
            null, null, 'Consumer Age verification', 'PMUSA', null, null);
        Test.stopTest();

       
        IntegrationLog__c log = [SELECT Success__c FROM IntegrationLog__c LIMIT 1];
       
    }
}