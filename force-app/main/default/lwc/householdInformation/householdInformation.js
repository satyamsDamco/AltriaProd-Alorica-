import { LightningElement, api, wire } from 'lwc';
import getContactsAtSameAddress from '@salesforce/apex/householdInformationController.getContactsAtSameAddress';

const COLUMNS = [
    {
        label: 'Name',
        fieldName: 'contactUrl',
        type: 'url',
        typeAttributes: { label: { fieldName: 'Name' }, target: '_self' },
        wrapText: true
    },
    { label: 'DOB', fieldName: 'Birthdate1__c', type: 'date-local' },
    { label: 'Customer ID', fieldName: 'CustomerID__c' },
    { label: 'Street Address / Address1', fieldName: 'Street_Address__c', wrapText: true },
    { label: 'City / Locality', fieldName: 'City__c' },
    { label: 'State / Province', fieldName: 'State__c' },
    { label: 'Zip Code / Postal code', fieldName: 'Zip_Code__c' }
];

export default class HouseholdInformation extends LightningElement {
    @api recordId; // automatically bound to current Contact Id on the record page

    cardTitle = 'Household Information';
    columns = COLUMNS;
    contacts = [];
    error;
    isLoading = true;

    @wire(getContactsAtSameAddress, { contactId: '$recordId' })
    wiredContacts({ data, error }) {
        this.isLoading = false;
        if (data) {
            this.contacts = data.map((c) => ({ ...c, contactUrl: '/' + c.Id }));
            this.error = undefined;
        } else if (error) {
            this.error = this.reduceError(error);
            this.contacts = [];
        }
    }

    get hasContacts() {
        return this.contacts && this.contacts.length > 0;
    }

    get showEmptyState() {
        return !this.isLoading && !this.error && !this.hasContacts;
    }

    reduceError(error) {
        if (error && error.body && error.body.message) {
            return error.body.message;
        }
        return 'An unknown error occurred while loading household members.';
    }
}