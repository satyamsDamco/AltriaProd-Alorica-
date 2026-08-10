/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : householdInformationController
 * Author          : Damco Team
 * Created Date    : Aug 4, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Aug 4, 2026
 * Description     : Returns other Contacts that share the same mailing address
 *                    as the Contact currently being viewed.
 *
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Aug 4, 2026  │ Damco Team   │ V1
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public with sharing class householdInformationController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsAtSameAddress(Id contactId) {
        if (contactId == null) {
            return new List<Contact>();
        }

        Contact currentContact = [
            SELECT Id, Street_Address__c
            FROM Contact
            WHERE Id = :contactId
            WITH USER_MODE
            LIMIT 1
        ];

        // Require a street value before matching, to avoid returning
        // every Contact with a blank address.
        if (String.isBlank(currentContact.Street_Address__c)) {
            return new List<Contact>();
        }

        return [
            SELECT Id, Name, Birthdate1__c, CustomerID__c, Street_Address__c,
                   City__c, State__c, Zip_Code__c, Phone, Email
            FROM Contact
            WHERE Id != :contactId
              AND Street_Address__c = :currentContact.Street_Address__c
            WITH USER_MODE
            ORDER BY CustomerID__c
            LIMIT 200
        ];
    }
}