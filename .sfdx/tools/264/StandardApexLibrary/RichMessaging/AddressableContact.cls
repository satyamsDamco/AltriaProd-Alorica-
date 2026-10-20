/**
 * Represents an addressable contact.
 */
global class AddressableContact {
    /**
     * The contactâ€™s email address.
     * String
     */
    @InvocableVariable
    global String emailAddress;
    /**
     * The contactâ€™s surname.
     * String
     */
    @InvocableVariable
    global String familyName;
    /**
     * The contactâ€™s first name.
     * String
     */
    @InvocableVariable
    global String givenName;
    /**
     * The contactâ€™s phone number.
     * String
     */
    @InvocableVariable
    global String phoneNumber;
    /**
     * The phonetic spelling of the contactâ€™s surname.
     * String
     */
    @InvocableVariable
    global String phoneticFamilyName;
    /**
     * The phonetic spelling of the contactâ€™s first name.
     * String
     */
    @InvocableVariable
    global String phoneticGivenName;
    /**
     * The contactâ€™s postal address.
     * RichMessaging.PostalAddress
     */
    @InvocableVariable
    global RichMessaging.PostalAddress postalAddress;

    /**
     * Creates a new instance of the RichMessaging.AddressableContact class.
     */
    global AddressableContact(String givenName, String phoneticGivenName, String familyName, String phoneticFamilyName, String emailAddress, String phoneNumber, RichMessaging.PostalAddress postalAddress) { }

    global virtual Boolean equals(Object o) { return false; }

    global virtual Integer hashCode() { return 0; }

    global override virtual String toString() { return null; }
}