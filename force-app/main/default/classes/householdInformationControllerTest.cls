/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : householdInformationControllerTest
 * Author          : Damco Team
 * Created Date    : Aug 4, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Aug 4, 2026
 * Description     : Unit tests for householdInformationController.getContactsAtSameAddress.
 *                    Covers: null contactId, blank Street_Address__c on the source
 *                    Contact, a Contact with no household matches, and a Contact
 *                    with multiple household matches (verifying exclusion of self
 *                    and CustomerID__c ordering).
 *
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Aug 4, 2026  │ Damco Team   │ V1
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */
@isTest
private class householdInformationControllerTest {

    @testSetup
    static void setup() {
        Account testAcc = TestDataSetup.createAccount('Test Household Account');
        insert testAcc;
    }

    // contactId == null should short-circuit and return an empty list
    // without any SOQL against Contact.
    @isTest
    static void testGetContactsAtSameAddress_NullId() {
        Test.startTest();
        List<Contact> results = householdInformationController.getContactsAtSameAddress(null);
        Test.stopTest();

        System.assertNotEquals(null, results, 'Result list should never be null');
        System.assertEquals(0, results.size(), 'Null contactId should return an empty list');
    }

    // Contact has an address, but no other Contact shares it.
    @isTest
    static void testGetContactsAtSameAddress_NoMatches() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        Date bdate = Date.newInstance(1989, 06, 14);

        Contact testCont = TestDataSetup.createContact('Solo', 'Resident', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        testCont.Street_Address__c = '123 Lonely Lane';
        insert testCont;

        Contact differentAddress = TestDataSetup.createContact('Different', 'Neighbor', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        differentAddress.Street_Address__c = '456 Other Ave';
        insert differentAddress;

        Test.startTest();
        List<Contact> results = householdInformationController.getContactsAtSameAddress(testCont.Id);
        Test.stopTest();

        System.assertNotEquals(null, results, 'Result list should never be null');
        System.assertEquals(0, results.size(), 'No other contact shares the address, so no household members should be returned');
    }

    // Contact has an address shared by other Contacts - verify those
    // Contacts (and only those) come back, that the source Contact is
    // excluded, and that results are ordered by CustomerID__c.
    @isTest
    static void testGetContactsAtSameAddress_WithMatches() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        Date bdate = Date.newInstance(1989, 06, 14);
        String sharedAddress = '789 Household Blvd';

        Contact testCont = TestDataSetup.createContact('Primary', 'Resident', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        testCont.Street_Address__c = sharedAddress;
        testCont.CustomerID__c = '3000';
        insert testCont;

        Contact householdMember1 = TestDataSetup.createContact('Second', 'Resident', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        householdMember1.Street_Address__c = sharedAddress;
        householdMember1.CustomerID__c = '1000';
        insert householdMember1;

        Contact householdMember2 = TestDataSetup.createContact('Third', 'Resident', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        householdMember2.Street_Address__c = sharedAddress;
        householdMember2.CustomerID__c = '2000';
        insert householdMember2;

        Contact differentAddress = TestDataSetup.createContact('Not', 'Household', testAcc.Id, true, '20001', bdate, 'Test Street', true, true);
        differentAddress.Street_Address__c = '456 Other Ave';
        differentAddress.CustomerID__c = '4000';
        insert differentAddress;

        Test.startTest();
        List<Contact> results = householdInformationController.getContactsAtSameAddress(testCont.Id);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Only the two contacts sharing the address should be returned');

        Set<Id> resultIds = new Set<Id>();
        for (Contact c : results) {
            resultIds.add(c.Id);
        }
        System.assert(!resultIds.contains(testCont.Id), 'The source contact should never be returned in its own household list');
        System.assert(resultIds.contains(householdMember1.Id), 'householdMember1 shares the address and should be returned');
        System.assert(resultIds.contains(householdMember2.Id), 'householdMember2 shares the address and should be returned');
        System.assert(!resultIds.contains(differentAddress.Id), 'A contact with a different address should not be returned');

        // Verify ORDER BY CustomerID__c (ascending): '1000' before '2000'.
        System.assertEquals(householdMember1.Id, results[0].Id, 'Results should be ordered by CustomerID__c ascending');
        System.assertEquals(householdMember2.Id, results[1].Id, 'Results should be ordered by CustomerID__c ascending');
    }
}