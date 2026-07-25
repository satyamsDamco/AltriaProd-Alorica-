/*
*********************************************************
Apex Class Name    : AllWorkflowRulesTest
Created Date       : April 23, 2026
@description       : This class is used for testing all the workflow rules that have been migrated to Lightning Flows.
@author            : Vivekanand Kedar
Modification Log:
Ver   Date         Author                               Modification
1.0   23-04-2026   Vivekanand Kedar                     Initial Version
*********************************************************
*/
@IsTest
public with sharing class AllWorkflowRulesTest {

    /**********************************************
    Test Data Setup (runs once for all tests)
    **********************************************/
    @TestSetup
    static void setupTestData() {

        //1. Workflow Rule: Update File Type Test Data
        List<Attachment_Detail__c> attdetailsRecords = new List<Attachment_Detail__c>{
            new Attachment_Detail__c(File_Name__c = 'document.pdf'),
            new Attachment_Detail__c(File_Name__c = 'report.final.v1.xlsx'),
            new Attachment_Detail__c(), // Null File_Name__c
            new Attachment_Detail__c(File_Name__c = '.gitignore')
        };
        insert attdetailsRecords;

        //2. Workflow Rule: Store Created Date Test Data
        Store_Type__c storetype = new Store_Type__c();
        storetype.Description__c = 'Testing';
        insert storetype;

        List<Store__c> stores = new List<Store__c>{
            new Store__c(Store_Type__c = storetype.Id),
            new Store__c(Store_Type__c = storetype.Id)
        };
        insert stores;

        //3. Workflow Rule: Reimb Create Date field Test Data

        Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'JMC';
        opcompany.Active__c = TRUE;
        opcompany.OpCo_Description__c = 'Testing';
        
        insert opcompany;

        Case caseobj = new Case();
        caseobj.Op_Company__c = opcompany.ID;
        caseobj.Purchase_Price__c = 4500;
        caseobj.Origin = 'Email';
        insert caseobj;

        insert new Reimbursement__c(Issue__c=caseobj.ID, Cheque_Amount__c=500);

        //4. Workflow Rule: Case Auto Number Update Test Data
        List<Case> cases = new List<Case>{
            new Case(Subject = 'Test 1', Status = 'New', Origin = 'Phone', Op_Company__c = opcompany.ID, Purchase_Price__c = 500),
            new Case(Subject = 'Test 2', Status = 'New', Origin = 'Email', Op_Company__c = opcompany.ID, Purchase_Price__c = 600)
        };
        insert cases;

        //5. Workflow Rule: Contact Auto Number Update Test Data

        Account acc = new Account(Name='Test Account');
        insert acc;

        insert new List<Contact>{
            new Contact(FirstName = 'Contact', LastName = 'Test One', AccountId = acc.ID, Street_Address__c = 'Test Add1', 
            Company_Name__c = 'Company1', DBA_Name__c = 'Test1', Phone = '9988776655' ,Zip_Code__c = '413307'),
             new Contact(FirstName = 'Contact', LastName = 'Test Two', AccountId = acc.ID, Street_Address__c = 'Test Add2', 
            Company_Name__c = 'Company2', DBA_Name__c = 'Test2', Phone = '9988776655' ,Zip_Code__c = '412115')
        };

        //6. Workflow Rule: DOB Feed Format Test Data

        List<Contact> contacts = new List<Contact>();

        // Record 1 : Valid DOB
        contacts.add(new Contact(
            AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'Valid DOB',
            Street_Address__c = 'Pune',
            Zip_Code__c = '413307',
            Company_Name__c = 'Achieva1',
            DBA_Name__c = 'Vivek',
            Phone = '9768656705',
            Birthdate__c = '1990-05-15',
            Birthdate1__c = Date.newInstance(1990,5,15),
            Customer_Detail_ID__c = 'CD001'
        ));

        // Record 2 : No DOB
        contacts.add(new Contact(
            AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'No DOB',
            Street_Address__c = 'Pune',
            Zip_Code__c = '413307',
            Company_Name__c = 'Achieva2',
            DBA_Name__c = 'Vivek',
            Phone = '9768656705',
            Customer_Detail_ID__c = 'CD002'
        ));

        // Record 3 : No Customer Detail ID
        contacts.add(new Contact(
            AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'No Customer Detail',
            Street_Address__c = 'Pune',
            Zip_Code__c = '413307',
            Company_Name__c = 'Achieva3',
            DBA_Name__c = 'Vivek',
            Phone = '9768656705',
            Birthdate__c = '1985-10-10'
        ));

        insert contacts;

        //7. Workflow Rule: Update DocumentOpCompany Test Data

        /*Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'JMC';
        insert opcompany;*/

        // Create DocType record
        DocumentType__c docType1 = new DocumentType__c(
            Op_Company__c = opcompany.Id,
            Description__c = 'Test',
            DocTyp__c = 'Inbound',
            PkgCode__c = 'AAA1'
        );
        DocumentType__c docType2 = new DocumentType__c(
            Op_Company__c = opcompany.Id,
            Description__c = 'Test1',
            DocTyp__c = 'Outbound',
            PkgCode__c = 'AAA2'
        );

        insert new List<DocumentType__c>{ docType1, docType2 };

        // Create Correspondence Fulfilment records
        List<Correspondence_Fulfilment__c> cfRecords =
            new List<Correspondence_Fulfilment__c>();

        cfRecords.add(new Correspondence_Fulfilment__c(
            DocType__c = docType1.Id
        ));
        cfRecords.add(new Correspondence_Fulfilment__c(
            DocType__c = docType2.Id
        ));
        cfRecords.add(new Correspondence_Fulfilment__c(
            // No DocType lookup
        ));

        insert cfRecords;

    }

    //1. Workflow Rule: Update File Type

    @IsTest
    static void testFileTypeExtraction_NormalCase() {
        Attachment_Detail__c rec = [
            SELECT File_Type__c
            FROM Attachment_Detail__c
            WHERE File_Name__c = 'document.pdf'
            LIMIT 1
        ];

        System.assertEquals('pdf', rec.File_Type__c,
            'File type should be extracted as pdf');
    }

    @IsTest
    static void testFileTypeExtraction_MultipleDots() {
        Attachment_Detail__c rec = [
            SELECT File_Type__c
            FROM Attachment_Detail__c
            WHERE File_Name__c = 'report.final.v1.xlsx'
            LIMIT 1
        ];

        System.assertEquals('final.v1.xlsx', rec.File_Type__c,
            'Flow should extract everything after first dot');
    }

    @IsTest
    static void testNullFileName() {
        Attachment_Detail__c rec = [
            SELECT File_Type__c
            FROM Attachment_Detail__c
            WHERE File_Name__c = NULL
            LIMIT 1
        ];

        System.assertEquals(null, rec.File_Type__c,
            'File_Type__c should remain null when File_Name__c is null');
    }

    @IsTest
    static void testFileNameWithLeadingDot() {
        Attachment_Detail__c rec = [
            SELECT File_Type__c
            FROM Attachment_Detail__c
            WHERE File_Name__c = '.gitignore'
            LIMIT 1
        ];

        System.assertEquals('gitignore', rec.File_Type__c,
            'Should correctly handle filenames starting with dot');
    }

    @IsTest
    static void testBulkFileNameInsert() {
        List<Attachment_Detail__c> records = new List<Attachment_Detail__c>();

        for (Integer i = 0; i < 200; i++) {
            records.add(new Attachment_Detail__c(
                File_Name__c = 'file' + i + '.txt'
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Attachment_Detail__c> insertedRecords = [
            SELECT File_Type__c
            FROM Attachment_Detail__c
            WHERE File_Name__c LIKE 'file%.txt'
        ];

        System.assertEquals(200, insertedRecords.size(),
            'All 200 records should be inserted');

        for (Attachment_Detail__c rec : insertedRecords) {
            System.assertEquals('txt', rec.File_Type__c,
                'All records should have txt as file type');
        }
    }

    //2. Workflow Rule: Store Created Date

    @IsTest
    static void testFeedCreatedDateIsSet() {
        List<Store__c> stores = [
            SELECT FeedCreatedDate__c
            FROM Store__c
        ];

        for (Store__c s : stores) {
            System.assertNotEquals(null, s.FeedCreatedDate__c,
                'FeedCreatedDate__c should be populated on insert');
        }
    }

    @IsTest
    static void testFeedCreatedDateAccuracy() {
        Datetime beforeInsert = System.now();

        Store_Type__c storetype = new Store_Type__c();
        storetype.Description__c = 'Testing1';
        insert storetype;
        Store__c s = new Store__c(Store_Type__c = storetype.Id);

        Test.startTest();
        insert s;
        Test.stopTest();

        Datetime afterInsert = System.now();

        s = [
            SELECT FeedCreatedDate__c
            FROM Store__c
            WHERE Id = :s.Id
        ];

        System.assertNotEquals(null, s.FeedCreatedDate__c,
        'FeedCreatedDate__c should be populated');

        // Allow small time difference (e.g., 5 seconds)
        Long diff = Math.abs(System.now().getTime() - s.FeedCreatedDate__c.getTime());

        System.assert(diff < 5000,'FeedCreatedDate__c should be close to current time');
    }

    @IsTest
    static void testBulkFeedCreatedDateInsert() {
        List<Store__c> stores = new List<Store__c>();
        Store_Type__c storetype = new Store_Type__c();
        storetype.Description__c = 'Testing2';
        insert storetype;

        for (Integer i = 0; i < 200; i++) {
            stores.add(new Store__c(Store_Type__c = storetype.Id));
        }

        Test.startTest();
        insert stores;
        Test.stopTest();

        List<Store__c> insertedStores = [
            SELECT FeedCreatedDate__c
            FROM Store__c
            WHERE Id IN :stores
        ];

        System.assertEquals(200, insertedStores.size(),
            'All records should be inserted');

        for (Store__c s : insertedStores) {
            System.assertNotEquals(null, s.FeedCreatedDate__c,
                'FeedCreatedDate__c should be populated for all records');
        }
    }

    //3. Workflow Rule: Reimb Create Date field

    @IsTest
    static void testReimbCreateDateIsSet() {

        Reimbursement__c r = [
            SELECT FeedCreatedDate__c
            FROM Reimbursement__c
            LIMIT 1
        ];

        System.assertNotEquals(null, r.FeedCreatedDate__c,
            'FeedCreatedDate__c should be populated');
    }

    @IsTest
    static void testReimbCreateDateAccuracy() {

        Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'PMIP';
        opcompany.Active__c = TRUE;
        opcompany.OpCo_Description__c = 'Testing1';
        
        insert opcompany;

        Case caseobj = new Case();
        caseobj.Op_Company__c = opcompany.ID;
        caseobj.Purchase_Price__c = 800;
        caseobj.Origin = 'Web';
        insert caseobj;

        Test.startTest();
        Reimbursement__c r = new Reimbursement__c(Issue__c=caseobj.ID, Cheque_Amount__c=400);
        insert r;
        Test.stopTest();

        r = [
            SELECT FeedCreatedDate__c
            FROM Reimbursement__c
            WHERE Id = :r.Id
        ];

        System.assertNotEquals(null, r.FeedCreatedDate__c,
            'FeedCreatedDate__c should be populated');

        // Allow tolerance (5 seconds)
        Long diff = Math.abs(System.now().getTime() - r.FeedCreatedDate__c.getTime());

        System.assert(diff < 5000,
            'FeedCreatedDate__c should be close to current datetime');
    }

    @IsTest
    static void testBulkReimbCreateDateInsert() {

        Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'USST';
        opcompany.Active__c = TRUE;
        opcompany.OpCo_Description__c = 'Testing2';
        
        insert opcompany;

        Case caseobj = new Case();
        caseobj.Op_Company__c = opcompany.ID;
        caseobj.Purchase_Price__c = 100;
        caseobj.Origin = 'Web';
        insert caseobj;

        List<Reimbursement__c> recs = new List<Reimbursement__c>();

        for (Integer i = 0; i < 200; i++) {
            recs.add(new Reimbursement__c(Issue__c=caseobj.ID, Cheque_Amount__c=300));
        }

        Test.startTest();
        insert recs;
        Test.stopTest();

        List<Reimbursement__c> inserted = [
            SELECT FeedCreatedDate__c
            FROM Reimbursement__c
            WHERE Id IN :recs
        ];

        System.assertEquals(200, inserted.size(),
            'All records should be inserted');

        for (Reimbursement__c r : inserted) {
            System.assertNotEquals(null, r.FeedCreatedDate__c,
                'FeedCreatedDate__c should be populated for all records');
        }
    }

    //4. Workflow Rule: Case Auto Number Update
    
    @IsTest
    static void testCaseFieldUpdates() {

        List<Case> cases = [
            SELECT CaseNumber, CaseNumber__c, CreatedDate, FeedCreatedDate__c
            FROM Case
        ];

        for (Case c : cases) {

            // CaseNumber copy check
            System.assertNotEquals(null, c.CaseNumber,
                'CaseNumber should be generated');

            System.assertEquals(c.CaseNumber, c.CaseNumber__c,
                'CaseNumber__c should match CaseNumber');

            // CreatedDate mapping check
            System.assertEquals(
                c.CreatedDate.getTime(),
                c.FeedCreatedDate__c.getTime(),
                'FeedCreatedDate__c should match CreatedDate'
            );
        }
    }

    @IsTest
    static void testCaseSingleInsert() {

        Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'JMC';
        opcompany.Active__c = TRUE;
        opcompany.OpCo_Description__c = 'Testing1';
        insert opcompany;

        Case c = new Case(
            Subject = 'Single Test',
            Status = 'New',
            Origin = 'Web',
            Op_Company__c = opcompany.ID,
            Purchase_Price__c = 600
        );

        Test.startTest();
        insert c;
        Test.stopTest();

        c = [
            SELECT CaseNumber, CaseNumber__c, CreatedDate, FeedCreatedDate__c
            FROM Case
            WHERE Id = :c.Id
        ];

        System.assertEquals(c.CaseNumber, c.CaseNumber__c);
        System.assertEquals(
            c.CreatedDate.getTime(),
            c.FeedCreatedDate__c.getTime()
        );
    }

    @IsTest
    static void testCaseBulkInsert() {

        Operating_Company__c opcompany = new Operating_Company__c();
        opcompany.OperatingCompany__c = 'JMC';
        opcompany.Active__c = TRUE;
        opcompany.OpCo_Description__c = 'Testing2';
        insert opcompany;

        List<Case> cases = new List<Case>();

        for (Integer i = 0; i < 200; i++) {
            cases.add(new Case(
                Subject = 'Bulk ' + i,
                Status = 'New',
                Origin = 'Phone',
                Op_Company__c = opcompany.ID,
                Purchase_Price__c = 500 + i
            ));
        }

        Test.startTest();
        insert cases;
        Test.stopTest();

        List<Case> insertedCases = [
            SELECT CaseNumber, CaseNumber__c, CreatedDate, FeedCreatedDate__c
            FROM Case
            WHERE Id IN :cases
        ];

        System.assertEquals(200, insertedCases.size(),
            'All records should be inserted');

        for (Case c : insertedCases) {
            System.assertEquals(c.CaseNumber, c.CaseNumber__c);
            System.assertEquals(
                c.CreatedDate.getTime(),
                c.FeedCreatedDate__c.getTime()
            );
        }
    }

    //5. Workflow Rule: Contact Auto Number Update

    @IsTest
    static void testContactFieldMappings() {

        List<Contact> contacts = [
            SELECT 
                CustomerID__c,
                Customer_Id_Auto_Number__c,
                Customer_Detail_ID__c,
                Customer_Detail_Id_Auto_Number__c,
                CreatedDate,
                FeedCreatedDate__c
            FROM Contact
        ];

        for (Contact c : contacts) {

            // Validate auto-number copy
            System.assertEquals(
                c.Customer_Id_Auto_Number__c,
                c.CustomerID__c,
                'CustomerID__c should match source auto-number'
            );

            System.assertEquals(
                c.Customer_Detail_Id_Auto_Number__c,
                c.Customer_Detail_ID__c,
                'Customer_Detail_ID__c should match source auto-number'
            );

            // Validate CreatedDate mapping
            System.assertNotEquals(null, c.FeedCreatedDate__c);

            System.assertEquals(
                c.CreatedDate.getTime(),
                c.FeedCreatedDate__c.getTime(),
                'FeedCreatedDate__c should match CreatedDate'
            );
        }
    }

    @IsTest
    static void testSingleContactInsert() {

        Account acc = new Account(Name='Test Account');

        Contact c = new Contact(FirstName = 'Single Test', LastName = 'Test One', AccountId = acc.ID, Street_Address__c = 'Test Add1', 
            Company_Name__c = 'Company1', DBA_Name__c = 'Test1', Phone = '9988776655' ,Zip_Code__c = '413307');

        Test.startTest();
        insert c;
        Test.stopTest();

        c = [
            SELECT 
                CustomerID__c,
                Customer_Id_Auto_Number__c,
                Customer_Detail_ID__c,
                Customer_Detail_Id_Auto_Number__c,
                CreatedDate,
                FeedCreatedDate__c
            FROM Contact
            WHERE Id = :c.Id
        ];

        System.assertEquals(c.Customer_Id_Auto_Number__c, c.CustomerID__c);
        System.assertEquals(c.Customer_Detail_Id_Auto_Number__c, c.Customer_Detail_ID__c);

        System.assertEquals(
            c.CreatedDate.getTime(),
            c.FeedCreatedDate__c.getTime()
        );
    }

    @IsTest
    static void testBulkContactInsert() {

        Account acc = new Account(Name='Test Account');

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'Bulk Test', LastName = 'Test'+i, AccountId = acc.ID, Street_Address__c = 'Test Add1', 
            Company_Name__c = 'Company1', DBA_Name__c = 'Test1', Phone = '9988776655' ,Zip_Code__c = '413307'));
        }

        Test.startTest();
        insert contacts;
        Test.stopTest();

        List<Contact> inserted = [
            SELECT 
                CustomerID__c,
                Customer_Id_Auto_Number__c,
                Customer_Detail_ID__c,
                Customer_Detail_Id_Auto_Number__c,
                CreatedDate,
                FeedCreatedDate__c
            FROM Contact
            WHERE Id IN :contacts
        ];

        System.assertEquals(200, inserted.size());

        for (Contact c : inserted) {
            System.assertEquals(c.Customer_Id_Auto_Number__c, c.CustomerID__c);
            System.assertEquals(c.Customer_Detail_Id_Auto_Number__c, c.Customer_Detail_ID__c);

            System.assertEquals(
                c.CreatedDate.getTime(),
                c.FeedCreatedDate__c.getTime()
            );
        }
    }

    //6. Workflow Rule: DOB Feed Format

    @IsTest
    static void testDOBFormatting() {

        Contact c = [
            SELECT DOB_Feed__c, Birthdate__c
            FROM Contact
            WHERE Company_Name__c = 'Achieva1'
            LIMIT 1
        ];

        System.assertNotEquals(
            null,
            c.DOB_Feed__c,
            'DOB_Feed__c should be populated'
        );

        System.assert(
            c.DOB_Feed__c.startsWith('05/15/'),
            'DOB format should start with MM/DD/'
        );
    }

    @IsTest
    static void testDOBNull() {

        Contact c = [
            SELECT DOB_Feed__c
            FROM Contact
            WHERE Company_Name__c = 'Achieva2'
            LIMIT 1
        ];

        System.assert(
            c.DOB_Feed__c == null || c.DOB_Feed__c == '',
            'DOB_Feed__c should be blank when Birthdate__c is null'
        );
    }

    @IsTest
    static void testDOBEntryCondition() {

        Contact c = [
            SELECT DOB_Feed__c
            FROM Contact
            WHERE Company_Name__c = 'Achieva3'
            LIMIT 1
        ];

        System.assertEquals(
            null,
            c.DOB_Feed__c,
            'Flow should not run when Customer_Detail_ID__c is null'
        );
    }

    @IsTest
    static void testDOBUpdateScenario() {

        Account acc = new Account(Name = 'Update Account');
        insert acc;

        Contact c = new Contact(
            AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'Update Test',
            Street_Address__c = 'Pune',
            Zip_Code__c = '413307',
            Company_Name__c = 'UpdateCompany',
            DBA_Name__c = 'Vivek',
            Phone = '9768656705',
            Customer_Detail_ID__c = 'CD999'
        );

        insert c;

        c.Birthdate__c = '2000-01-01';
        c.Birthdate1__c = Date.valueOf('2000-01-01');

        Test.startTest();
        update c;
        Test.stopTest();

        c = [
            SELECT DOB_Feed__c
            FROM Contact
            WHERE Id = :c.Id
        ];

        System.assertNotEquals(
            null,
            c.DOB_Feed__c,
            'DOB_Feed__c should populate after update'
        );
    }

    @IsTest
    static void testDOBBulkInsert() {

        Account acc = new Account(Name = 'Bulk Account');
        insert acc;

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 200; i++) {

            contacts.add(new Contact(
                AccountId = acc.Id,
                FirstName = 'Bulk',
                LastName = 'Contact ' + i,
                Street_Address__c = 'Pune',
                Zip_Code__c = '413307',
                Company_Name__c = 'BulkCompany' + i,
                DBA_Name__c = 'Vivek',
                Phone = '9768656705',
                Birthdate__c = '1995-01-01',
                Birthdate1__c = Date.valueOf('2000-01-01'),
                Customer_Detail_ID__c = 'CD' + i
            ));
        }

        Test.startTest();
        insert contacts;
        Test.stopTest();

        List<Contact> inserted = [
            SELECT Id, DOB_Feed__c
            FROM Contact
            WHERE Id IN :contacts
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All records should be inserted'
        );

        for (Contact c : inserted) {
            System.assertNotEquals(
                null,
                c.DOB_Feed__c,
                'DOB_Feed__c should be populated'
            );
        }
    }

    //7. Workflow Rule: Update DocumentOpCompany

    @IsTest
    static void testDocumentOpCompanyUpdate_Record1() {

        Correspondence_Fulfilment__c rec = [
            SELECT DocumentOpCompany__c
            FROM Correspondence_Fulfilment__c
            WHERE DocType__r.Description__c = 'Test'
            LIMIT 1
        ];

        System.assertEquals(
            'JMC',
            rec.DocumentOpCompany__c,
            'Should populate Operating Company from DocType'
        );
    }

    @IsTest
    static void testDocumentOpCompanyUpdate_Record2() {

        Correspondence_Fulfilment__c rec = [
            SELECT DocumentOpCompany__c
            FROM Correspondence_Fulfilment__c
            WHERE DocType__r.Description__c = 'Test1'
            LIMIT 1
        ];

        System.assertEquals(
            'JMC',
            rec.DocumentOpCompany__c,
            'Should populate second Operating Company value'
        );
    }

    @IsTest
    static void testNoDocType() {

        Correspondence_Fulfilment__c rec = [
            SELECT DocumentOpCompany__c
            FROM Correspondence_Fulfilment__c
            WHERE DocType__c = null
            LIMIT 1
        ];

        System.assertEquals(
            null,
            rec.DocumentOpCompany__c,
            'Should remain null when DocType__c is blank'
        );
    }

    @IsTest
    static void testBulkInsert() {
        
        DocumentType__c dt = [
            SELECT Id, Operating_Company__c
            FROM DocumentType__c
            WHERE Op_Company__r.OperatingCompany__c = 'JMC'
            LIMIT 1
        ];

        List<Correspondence_Fulfilment__c> bulkList =
            new List<Correspondence_Fulfilment__c>();

        for (Integer i = 0; i < 200; i++) {

            bulkList.add(new Correspondence_Fulfilment__c(
                DocType__c = dt.Id
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Correspondence_Fulfilment__c> inserted = [
            SELECT DocumentOpCompany__c
            FROM Correspondence_Fulfilment__c
            WHERE Id IN :bulkList
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All bulk records should insert'
        );

        for (Correspondence_Fulfilment__c rec : inserted) {

            System.assertEquals(
                'JMC',
                rec.DocumentOpCompany__c,
                'All records should populate lookup value'
            );
        }
    }

}