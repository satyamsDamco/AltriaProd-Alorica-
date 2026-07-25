/*
*********************************************************
Apex Class Name    : AllProcessBuildersTest
Created Date       : April 27, 2026
@description       : This class is used for testing all the process builders that have been migrated to Lightning Flows.
@author            : Vivekanand Kedar
Modification Log:
Ver   Date         Author                               Modification
1.0   27-04-2026   Vivekanand Kedar                     Initial Version
*********************************************************
*/
@IsTest
public with sharing class AllProcessBuildersTest {

    /**********************************************
    Test Data Setup (runs once for all tests)
    **********************************************/
    @TestSetup
    static void setupTestData() {

        //1. Process Builder: Reset the Survey Issue Feed Flag Flow Test Data

        Survey__c survey = new Survey__c(Survey_Name__c = 'Test Survey');
        insert survey;

        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing');
        insert opcompany;

        TFN__c tfn = new TFN__c(DNIS__c = 'Test DNIS', Toll_Free_Number__c = '8877665544', Operating_Company__c = opcompany.ID);
        insert tfn;

        Transaction_Management__c txnMgmt = new Transaction_Management__c(TFN__c = tfn.Id, Operating_Company__c = opcompany.Id);
        insert txnMgmt;

        Case caseobj = new Case(Op_Company__c = opcompany.ID, Purchase_Price__c = 4500, Origin = 'Email');
        insert caseobj;

        List<Survey_Issue__c> records = new List<Survey_Issue__c>();

        // Record 1 : UpdateFromFeed = true
        records.add(new Survey_Issue__c(
            Question_Sequence__c = 100,
            FeedSend__c = true,
            UpdateFromFeed__c = true,
            Survey__c = survey.Id,
            Transaction__c = txnMgmt.Id,
            Issue__c = caseobj.Id
        ));

        // Record 2 : UpdateFromFeed = false
        records.add(new Survey_Issue__c(
            Question_Sequence__c = 200,
            FeedSend__c = false,
            UpdateFromFeed__c = false,
            Survey__c = survey.Id,
            Transaction__c = txnMgmt.Id,
            Issue__c = caseobj.Id
        ));

        // Record 3 : Null values
        records.add(new Survey_Issue__c(
            Question_Sequence__c = 300,
            Survey__c = survey.Id,
            Transaction__c = txnMgmt.Id,
            Issue__c = caseobj.Id
        ));

        insert records;

        //2. Process Builder: Reset the Survey Configuration Feed Flag Flow Test Data

        List<Survey_Configuration__c> scRecords =
        new List<Survey_Configuration__c>();

        // Record 1 : UpdateFromFeed = true
        scRecords.add(new Survey_Configuration__c(
            Question_Sequence__c = 100,
            Survey__c = survey.Id,
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        scRecords.add(new Survey_Configuration__c(
            Question_Sequence__c = 200,
            Survey__c = survey.Id,
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : Null
        scRecords.add(new Survey_Configuration__c(
            Question_Sequence__c = 300,
            Survey__c = survey.Id
        ));

        insert scRecords;

        //3. Process Builder: Reset the Survey Feed Flag Flow Test Data

        List<Survey__c> surveyRecords = new List<Survey__c>();

        // Record 1 : UpdateFromFeed = true
        surveyRecords.add(new Survey__c(
            Survey_Name__c = 'Survey Feed True',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        surveyRecords.add(new Survey__c(
            Survey_Name__c = 'Survey Feed False',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : Null values
        surveyRecords.add(new Survey__c(
            Survey_Name__c = 'Survey Null'
        ));

        insert surveyRecords;

        //4. Process Builder: Reset the Store Type Flag Flow Test Data

        List<Store_Type__c> storetypeRecords = new List<Store_Type__c>();

        // Scenario 1 : UpdateFromFeed = true
        storetypeRecords.add(new Store_Type__c(
            Description__c = 'Store Reset',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Scenario 2 : UpdateFromFeed = false
        storetypeRecords.add(new Store_Type__c(
            Description__c = 'Store Default',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Scenario 3 : Null values
        storetypeRecords.add(new Store_Type__c(
            Description__c = 'Store Null'
        ));

        insert storetypeRecords;

        //5. Process Builder: Reset the Store Feed Flag Flow Test Data

        List<Store__c> stores = new List<Store__c>();

        // Record 1 -> UpdateFromFeed = true
        stores.add(new Store__c(
            Store_Name__c = 'Store True',
            Store_Type__c = storetypeRecords[0].Id,
            UpdateFromFeed__c = true
        ));

        // Record 2 -> UpdateFromFeed = false
        stores.add(new Store__c(
            Store_Name__c = 'Store False',
            Store_Type__c = storetypeRecords[0].Id,
            UpdateFromFeed__c = false
        ));

        // Record 3 -> Null checkbox behaves false
        stores.add(new Store__c(
            Store_Name__c = 'Store Null',
            Store_Type__c = storetypeRecords[0].Id
        ));

        insert stores;

        //6. Process Builder: Reset the Issue Type Feed flag Flow Test Data

        List<Issue_Type__c> issuetypeRecords = new List<Issue_Type__c>{

            // Path 1 : UpdateFromFeed = true
            new Issue_Type__c(
                Description__c = 'Issue True',
                UpdateFromFeed__c = true
            ),

            // Path 2 : UpdateFromFeed = false
            new Issue_Type__c(
                Description__c = 'Issue False',
                UpdateFromFeed__c = false
            ),

            // Path 3 : Null checkbox behaves false
            new Issue_Type__c(
                Description__c = 'Issue Null'
            )
        };

        insert issuetypeRecords;

        //7. Process Builder: Reset the Issue Hierarchy Feed flag Flow Test Data

        Classification__c classobj = new Classification__c(Description__c = 'Test Classification');
        insert classobj;

        Product_Line__c prodlineObj = new Product_Line__c(Code__c = 'PL0001', Name = 'Test Product Line');
        insert prodlineObj;

        Cause__c causeObj = new Cause__c(Description__c = 'Test Cause');
        insert causeObj;

        Group__c groupObj = new Group__c(Description__c = 'Test Group');
        insert groupObj;

        Reason__c reasonObj = new Reason__c(Description__c = 'Test Reason');
        insert reasonObj;

        List<Issue_Hierarchy__c> issuehierarchyRecords = new List<Issue_Hierarchy__c>{

            // Path 1 : UpdateFromFeed = true
            new Issue_Hierarchy__c(
                Alert_Distribution__c = 'Hierarchy True',
                UpdateFromFeed__c = true,
                Classification__c = classobj.ID,
                Issue_Type__c = issuetypeRecords[0].ID,
                Reason__c = reasonObj.ID,
                Product_Line__c = prodlineObj.ID,
                Cause__c = causeObj.ID,
                Group__c = groupObj.ID
            ),

            // Path 2 : UpdateFromFeed = false
            new Issue_Hierarchy__c(
                Alert_Distribution__c = 'Hierarchy False',
                UpdateFromFeed__c = false,
                Classification__c = classobj.ID,
                Issue_Type__c = issuetypeRecords[0].ID,
                Reason__c = reasonObj.ID,
                Product_Line__c = prodlineObj.ID,
                Cause__c = causeObj.ID,
                Group__c = groupObj.ID
            ),

            // Path 3 : Null checkbox behaves false
            new Issue_Hierarchy__c(
                Alert_Distribution__c = 'Hierarchy Null',
                Classification__c = classobj.ID,
                Issue_Type__c = issuetypeRecords[0].ID,
                Reason__c = reasonObj.ID,
                Product_Line__c = prodlineObj.ID,
                Cause__c = causeObj.ID,
                Group__c = groupObj.ID
            )
        };

        insert issuehierarchyRecords;

        //8. Process Builder: Reset the Issue Adjustment Feed Flag Flow Test Data

        List<Issue_Adjustment__c> issueAdjRecords = new List<Issue_Adjustment__c>();

        // Record 1 : UpdateFromFeed = true
        issueAdjRecords.add(new Issue_Adjustment__c(
            Adjustment_Type__c = 'Brand Hierarchy',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        issueAdjRecords.add(new Issue_Adjustment__c(
            Adjustment_Type__c = 'Consumer Notes',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : UpdateFromFeed = null
        issueAdjRecords.add(new Issue_Adjustment__c(
            Adjustment_Type__c = 'Date Code'
        ));

        insert issueAdjRecords;

        //9. Process Builder: Reset the Case Feed flag Flow Test Data

        List<Case> caseRecords = new List<Case>();

        // TRUE path
        caseRecords.add(new Case(
            Subject = 'Case True',
            Origin = 'Phone',
            Status = 'New',
            Comment__c = 'Test Case',
            Op_Company__c = opcompany.ID,
            Purchase_Price__c = 4500,
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // FALSE path
        caseRecords.add(new Case(
            Subject = 'Case False',
            Origin = 'Phone',
            Status = 'New',
            Comment__c = 'Test Case1',
            Op_Company__c = opcompany.ID,
            Purchase_Price__c = 4500,
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // NULL path
        caseRecords.add(new Case(
            Subject = 'Case Null',
            Origin = 'Phone',
            Status = 'New',
            Comment__c = 'Test Case2',
            Op_Company__c = opcompany.ID,
            Purchase_Price__c = 4500
        ));

        insert caseRecords;

        //10. Process Builder: Reset the Customer Type Feed flag Flow Test Data
        
        List<Customer_Type__c> custtypeRecords = new List<Customer_Type__c>();

        // Record 1 : UpdateFromFeed = true
        custtypeRecords.add(new Customer_Type__c(
            Customer_Type__c = 'CT Feed True',
            Description__c = 'Test CT1',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        custtypeRecords.add(new Customer_Type__c(
            Customer_Type__c = 'CT Feed False',
            Description__c = 'Test CT2',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : Null scenario
        custtypeRecords.add(new Customer_Type__c(
            Customer_Type__c = 'CT Feed Null',
            Description__c = 'Test CT3'
        ));

        insert custtypeRecords;

        //11. Process Builder: Reset the Correspondence & Fulfilment Feed Flag Flow Test Data

        List<Correspondence_Fulfilment__c> corrfulRecords =
            new List<Correspondence_Fulfilment__c>();

        // Record 1 : UpdateFromFeed = true
        corrfulRecords.add(new Correspondence_Fulfilment__c(
            Letter_head__c = 'CF Feed True',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        corrfulRecords.add(new Correspondence_Fulfilment__c(
            Letter_head__c = 'CF Feed False',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : Null scenario
        corrfulRecords.add(new Correspondence_Fulfilment__c(
            Letter_head__c = 'CF Feed Null'
        ));

        insert corrfulRecords;

        //12. Process Builder: Reset the Contact Feed Flag Flow Test Data

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        List<Contact> contactRecords = new List<Contact>();

        // Record 1 : UpdateFromFeed = true
        contactRecords.add(new Contact(
            FirstName = 'Contact 1',
            LastName = 'Test One',
            AccountId = acc.ID,
            Street_Address__c = 'Test Add1',
            Company_Name__c = 'Company1',
            DBA_Name__c = 'Test1',
            Phone = '9988776655',
            Zip_Code__c = '413307',
            StatusMessage__c = 'Feed True',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        ));

        // Record 2 : UpdateFromFeed = false
        contactRecords.add(new Contact(
            FirstName = 'Contact 2', 
            LastName = 'Test Two', 
            AccountId = acc.ID, 
            Street_Address__c = 'Test Add1', 
            Company_Name__c = 'Company2', 
            DBA_Name__c = 'Test2', 
            Phone = '9988776655',
            Zip_Code__c = '413307',
            StatusMessage__c = 'Feed False',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        // Record 3 : Null scenario
        contactRecords.add(new Contact(
            FirstName = 'Contact 3', 
            LastName = 'Test Three', 
            AccountId = acc.ID, 
            Street_Address__c = 'Test Add3', 
            Company_Name__c = 'Company3', 
            DBA_Name__c = 'Test3', 
            Phone = '9988776655',
            Zip_Code__c = '413307',
            StatusMessage__c = 'Feed Null',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        ));

        insert contactRecords;

        //14. Process Builder: Reset the Question Feed Flag Flow Test Data

        List<Question__c> questions = new List<Question__c>();

        // Record where UpdateFromFeed__c = true
        questions.add(new Question__c(
            Question__c = 'Question True',
            QuestionToCheck__c = 'Question True',
            UpdateFromFeed__c = true,
            Type__c = 'Comment'
        ));

        // Record where UpdateFromFeed__c = false
        questions.add(new Question__c(
            Question__c = 'Question False',
            QuestionToCheck__c = 'Question False',
            UpdateFromFeed__c = false,
            Type__c = 'Comment'
        ));

        insert questions;

        //15. Process Builder: Reset the Product Line Feed Flag Flow Test Data
        List<Product_Line__c> productLineRecords = new List<Product_Line__c>();

        // Record where UpdateFromFeed__c = true
        productLineRecords.add(new Product_Line__c(
            Name = 'PL True',
            Code__c = '100',
            UpdateFromFeed__c = true
        ));

        // Record where UpdateFromFeed__c = false
        productLineRecords.add(new Product_Line__c(
            Name = 'PL False',
            Code__c = '200',
            UpdateFromFeed__c = false
        ));

        insert productLineRecords;

        //16. Process Builder: Reset the Document Type Feed flag Flow Test Data

        List<DocumentType__c> doctypeRecords = new List<DocumentType__c>();
        
        //Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing1');
        //insert opcompany;

        // Record where UpdateFromFeed__c = true
        doctypeRecords.add(new DocumentType__c(
            Description__c = 'DT True',
            PkgCode__c = '100',
            DocTyp__c = 'Inbound',
            Op_Company__c = opcompany.ID,
            UpdateFromFeed__c = true
        ));

        // Record where UpdateFromFeed__c = false
        doctypeRecords.add(new DocumentType__c(
            Description__c = 'DT False',
            PkgCode__c = '200',
            DocTyp__c = 'Outbound',
            Op_Company__c = opcompany.ID,
            UpdateFromFeed__c = false
        ));

        insert doctypeRecords;

        //17. Process Builder: Reset the CounterfeitTraceCode Feed Flag Flow Test Data

        List<CounterfeitTraceCode__c> counttraceRecords = new List<CounterfeitTraceCode__c>();

        // Record where UpdateFromFeed__c = true
        counttraceRecords.add(new CounterfeitTraceCode__c(
            Brand__c = 'CTC True',
            Trace_Code__c = '100',
            Production_Date__c = Date.today(),
            UpdateFromFeed__c = true
        ));

        // Record where UpdateFromFeed__c = false
        counttraceRecords.add(new CounterfeitTraceCode__c(
            Brand__c = 'CTC False',
            Trace_Code__c = '200',
            Production_Date__c = Date.today(),
            UpdateFromFeed__c = false
        ));

        insert counttraceRecords;

        //18. Process Builder: Reset the Brand Hierarchy Feed Flag Flow Test Data

        Product_Line__c pl = new Product_Line__c(Name = 'Test PL', Code__c = '500', UpdateFromFeed__c = false);
        insert pl;
        //Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing1');
        //insert opcompany;
        Brand__c brand = new Brand__c(BrandCode__c = '1000', Name = 'Test Brand', Description__c = 'Testing Brand', Op_Company__c = opcompany.ID, Product_Line__c = pl.ID);
        insert brand;

        List<Brand_Hierarchy__c> brandhierRecords = new List<Brand_Hierarchy__c>();

        // TRUE case
        brandhierRecords.add(new Brand_Hierarchy__c(
            Short_Cut__c = 'BH True',
            Vantive_Id__c = '100',
            Brand_Code__c = brand.ID,
            Product_Line_Code__c = pl.ID,
            UpdateFromFeed__c = true
        ));

        // FALSE case
        brandhierRecords.add(new Brand_Hierarchy__c(
            Short_Cut__c = 'BH False',
            Vantive_Id__c = '100',
            Brand_Code__c = brand.ID,
            Product_Line_Code__c = pl.ID,
            UpdateFromFeed__c = false
        ));

        insert brandhierRecords;

        //19. Process Builder: Reset the Brand Feed Flag Flow Test Data

        //Product_Line__c pl = new Product_Line__c(Name = 'Test PL', Code__c = '500', UpdateFromFeed__c = false);
        //insert pl;
        //Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing1');
        //insert opcompany;
        
        List<Brand__c> brandRecords = new List<Brand__c>();

        // TRUE case
        brandRecords.add(new Brand__c(
            BrandCode__c = '1000', 
            Name = 'Brand True', 
            Description__c = 'Testing Brand1', 
            Op_Company__c = opcompany.ID, 
            Product_Line__c = pl.ID,
            UpdateFromFeed__c = true
        ));

        // FALSE case
        brandRecords.add(new Brand__c(
            BrandCode__c = '1000',
            Description__c = 'Testing Brand2', 
            Op_Company__c = opcompany.ID, 
            Product_Line__c = pl.ID,
            Name = 'Brand False',
            UpdateFromFeed__c = false
        ));

        insert brandRecords;

        //20. Process Builder: Reset the Answer Feed flag Flow Test Data

        List<Answer__c> answerRecords = new List<Answer__c>();

        // TRUE case
        answerRecords.add(new Answer__c(
            Answer__c = 'Answer True',
            PMAnswerID__c = 1000,
            UpdateFromFeed__c = true
        ));

        // FALSE case
        answerRecords.add(new Answer__c(
            Answer__c = 'Answer False',
            PMAnswerID__c = 2000,
            UpdateFromFeed__c = false
        ));

        insert answerRecords;
        
        //21. Process Builder: Reset the Reimbursement Feed Flag Flow Test Data

        //Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing');
        //insert opcompany;

        //Case caseobj = new Case(Op_Company__c = opcompany.ID, Purchase_Price__c = 4500, Origin = 'Email');
        //insert caseobj;

        List<Reimbursement__c> reimbRecords = new List<Reimbursement__c>();

        // TRUE case
        reimbRecords.add(new Reimbursement__c(
            Altria_File_Name__c = 'Reimb True',
            Issue__c = caseobj.Id,
            Cheque_Amount__c = 500,
            UpdateFromFeed__c = true
        ));

        // FALSE case
        reimbRecords.add(new Reimbursement__c(
            Altria_File_Name__c = 'Reimb False',
            Issue__c = caseobj.Id,
            Cheque_Amount__c = 500,
            UpdateFromFeed__c = false
        ));

        insert reimbRecords;

    }


    //13. Process Builder: Reset the User Feed flag Flow Test Data
    // Utility method to create a test user
    private static User createTestUser(Boolean updateFromFeedFlag) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser' + System.currentTimeMillis() + '@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            UpdateFromFeed__c = updateFromFeedFlag
        );

        return u;
    }

    //1. Process Builder: Reset the Survey Issue Feed Flag Flow

    @IsTest
    static void testResetFeedFlags() {

        Survey_Issue__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Issue__c
            WHERE Question_Sequence__c = 100
            LIMIT 1
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should be reset to false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to false'
        );
    }

    @IsTest
    static void testUpdateFeedSendTrue() {

        Survey_Issue__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Issue__c
            WHERE Question_Sequence__c = 200
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c remains false'
        );
    }

    @IsTest
    static void testNullScenario() {

        Survey_Issue__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Issue__c
            WHERE Question_Sequence__c = 300
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should default to true'
        );
    }

    @IsTest
    static void testUpdateScenario() {

        Survey__c survey = new Survey__c(Survey_Name__c = 'Test Survey1');
        insert survey;
        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing1');
        insert opcompany;
        TFN__c tfn = new TFN__c(DNIS__c = 'Test DNIS1', Toll_Free_Number__c = '6677889944', Operating_Company__c = opcompany.ID);
        insert tfn;
        Transaction_Management__c txnMgmt = new Transaction_Management__c(TFN__c = tfn.Id, Operating_Company__c = opcompany.Id);
        insert txnMgmt;
        Case caseobj = new Case(Op_Company__c = opcompany.ID, Purchase_Price__c = 4500, Origin = 'Email');
        insert caseobj;

        Survey_Issue__c rec = new Survey_Issue__c(
            Question_Sequence__c = 400,
            FeedSend__c = false,
            UpdateFromFeed__c = false,
            Survey__c = survey.Id,
            Transaction__c = txnMgmt.Id,
            Issue__c = caseobj.Id
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Issue__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testBulkInsert() {

        Survey__c survey = new Survey__c(Survey_Name__c = 'Test Survey2');
        insert survey;
        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing2');
        insert opcompany;
        TFN__c tfn = new TFN__c(DNIS__c = 'Test DNIS2', Toll_Free_Number__c = '7788334455', Operating_Company__c = opcompany.ID);
        insert tfn;
        Transaction_Management__c txnMgmt = new Transaction_Management__c(TFN__c = tfn.Id, Operating_Company__c = opcompany.Id);
        insert txnMgmt;
        Case caseobj = new Case(Op_Company__c = opcompany.ID, Purchase_Price__c = 4500, Origin = 'Email');
        insert caseobj;

        List<Survey_Issue__c> records = new List<Survey_Issue__c>();

        for (Integer i = 0; i < 200; i++) {

            records.add(new Survey_Issue__c(
                Question_Sequence__c = 500 + i,
                UpdateFromFeed__c = false,
                Survey__c = survey.Id,
                Transaction__c = txnMgmt.Id,
                Issue__c = caseobj.Id
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Survey_Issue__c> inserted = [
            SELECT FeedSend__c
            FROM Survey_Issue__c
            WHERE Id IN :records
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All records should insert'
        );

        for (Survey_Issue__c rec : inserted) {

            System.assertEquals(
                true,
                rec.FeedSend__c,
                'FeedSend__c should be true for all records'
            );
        }
    }

    //2. Process Builder: Reset the Survey Configuration Feed Flag Flow

    @IsTest
    static void testSurveyConfigResetFlags() {

        Survey_Configuration__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Configuration__c
            WHERE Question_Sequence__c = 100
            LIMIT 1
        ];

        // If Flow Active
        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testSurveyConfigFeedSendTrue() {

        Survey_Configuration__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Configuration__c
            WHERE Question_Sequence__c = 200
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testSurveyConfigNullScenario() {

        Survey_Configuration__c rec = [
            SELECT FeedSend__c
            FROM Survey_Configuration__c
            WHERE Question_Sequence__c = 300
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
    }

    @IsTest
    static void testSurveyConfigUpdateScenario() {

        Survey_Configuration__c rec =
            new Survey_Configuration__c(
                Question_Sequence__c = 400,
                FeedSend__c = false,
                UpdateFromFeed__c = false
            );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey_Configuration__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testSurveyConfigBulkInsert() {

        List<Survey_Configuration__c> records =
            new List<Survey_Configuration__c>();

        for (Integer i = 0; i < 200; i++) {

            records.add(new Survey_Configuration__c(
                Question_Sequence__c = 500 + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Survey_Configuration__c> inserted = [
            SELECT FeedSend__c
            FROM Survey_Configuration__c
            WHERE Id IN :records
        ];

        System.assertEquals(200, inserted.size());

        for (Survey_Configuration__c rec : inserted) {

            System.assertEquals(true, rec.FeedSend__c);
        }
    }

    //3. Process Builder: Reset the Survey Feed Flag Flow
    
    @IsTest
    static void testSurveyResetFlags() {

        Survey__c rec = new Survey__c(
            Survey_Name__c = 'Survey Feed True 1',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        );

        Test.startTest();
        insert rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend should reset false');
        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed should reset false');
    }

    @IsTest
    static void testSurveyFeedSendTrue() {

        Survey__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey__c
            WHERE Survey_Name__c = 'Survey Feed False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testSurveyNullScenario() {

        Survey__c rec = [
            SELECT FeedSend__c
            FROM Survey__c
            WHERE Survey_Name__c = 'Survey Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
    }

   @IsTest
    static void testSurveyUpdateScenario() {

        Survey__c rec = new Survey__c(
            Survey_Name__c = 'Update Survey',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        );

        insert rec;

        rec = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM Survey__c
            WHERE Id = :rec.Id
        ];

        // default branch after insert
        System.assertEquals(true, rec.FeedSend__c);

        rec.UpdateFromFeed__c = true;
        rec.FeedSend__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Survey__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend should reset false after update');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed should reset false after update');
    }

    @IsTest
    static void testSurveyBulkInsert() {

        List<Survey__c> records = new List<Survey__c>();

        for (Integer i = 0; i < 200; i++) {

            records.add(new Survey__c(
                Survey_Name__c = 'Bulk Survey ' + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Survey__c> inserted = [
            SELECT FeedSend__c
            FROM Survey__c
            WHERE Id IN :records
        ];

        System.assertEquals(200, inserted.size());

        for (Survey__c rec : inserted) {

            System.assertEquals(true, rec.FeedSend__c);
        }
    }

    //4. Process Builder: Reset the Store Type Flag Flow

    @IsTest
    static void testStoreTypeResetFlags() {

        Store_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Store_Type__c
            WHERE Description__c = 'Store Reset'
            LIMIT 1
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should reset to false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should reset to false'
        );
    }

    @IsTest
    static void testStoreTypeDefaultBranch() {

        Store_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Store_Type__c
            WHERE Description__c = 'Store Default'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain false'
        );
    }

    @IsTest
    static void testStoreTypeNullScenario() {

        Store_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Store_Type__c
            WHERE Description__c = 'Store Null'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should default to true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain null'
        );
    }

    @IsTest
    static void testStoreTypeUpdateScenario() {

        Store_Type__c rec = new Store_Type__c(
            Description__c = 'Store Update',
            UpdateFromFeed__c = false
        );

        insert rec;

        rec = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM Store_Type__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'After insert FeedSend__c should be true'
        );

        rec.UpdateFromFeed__c = true;
        rec.FeedSend__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Store_Type__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should reset to false after update'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should reset to false after update'
        );
    }

    @IsTest
    static void testStoreTypeBulkInsert() {

        List<Store_Type__c> bulkList = new List<Store_Type__c>();

        for (Integer i = 0; i < 200; i++) {

            bulkList.add(new Store_Type__c(
                Description__c = 'Bulk Store ' + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Store_Type__c> inserted = [
            SELECT FeedSend__c
            FROM Store_Type__c
            WHERE Id IN :bulkList
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All records should be inserted'
        );

        for (Store_Type__c rec : inserted) {

            System.assertEquals(
                true,
                rec.FeedSend__c,
                'FeedSend__c should be true for all records'
            );
        }
    }

    //5. Process Builder: Reset the Store Feed Flag Flow

    @IsTest
    static void testResetFlagsWhenTrue() {

        Store__c rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Store__c
            WHERE Store_Name__c = 'Store True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertNotEquals(null, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testFeedSendTrueWhenFalse() {

        Store__c rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Store__c
            WHERE Store_Name__c = 'Store False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertNotEquals(null, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testStoreNullScenario() {

        Store__c rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c
            FROM Store__c
            WHERE Store_Name__c = 'Store Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testStoreUpdateScenario() {

        Store_Type__c storeType = new Store_Type__c(
            Description__c = 'Store Reset 1',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        );
        insert storeType;

        Store__c rec = new Store__c(
            Store_Name__c = 'Update Store',
            Store_Type__c = storeType.Id,
            UpdateFromFeed__c = false
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Store__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertNotEquals(null, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testStoreBulkInsert() {

        Store_Type__c storeType = new Store_Type__c(
            Description__c = 'Store Reset 2',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        );
        insert storeType;

        List<Store__c> stores = new List<Store__c>();

        for(Integer i=0; i<200; i++) {
            stores.add(new Store__c(
                Store_Name__c = 'Bulk Store ' + i,
                Store_Type__c = storeType.Id,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert stores;
        Test.stopTest();

        List<Store__c> inserted = [
            SELECT FeedSend__c,
                   FeedLastModifiedDate__c
            FROM Store__c
            WHERE Id IN :stores
        ];

        System.assertEquals(200, inserted.size());

        for(Store__c rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
            System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        }
    }

    //6. Process Builder: Reset the Issue Type Feed flag Flow

    @IsTest
    static void testITResetFlagsWhenTrue() {

        Issue_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Type__c
            WHERE Description__c = 'Issue True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testITFeedSendTrueWhenFalse() {

        Issue_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Type__c
            WHERE Description__c = 'Issue False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testITNullScenario() {

        Issue_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Type__c
            WHERE Description__c = 'Issue Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testITUpdateScenario() {

        Issue_Type__c rec = new Issue_Type__c(
            Description__c = 'Update Issue',
            UpdateFromFeed__c = false
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Type__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testITBulkInsert() {

        List<Issue_Type__c> bulkList = new List<Issue_Type__c>();

        for(Integer i = 0; i < 200; i++) {

            bulkList.add(new Issue_Type__c(
                Description__c = 'Bulk Issue ' + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Issue_Type__c> inserted = [
            SELECT FeedSend__c
            FROM Issue_Type__c
            WHERE Id IN :bulkList
        ];

        System.assertEquals(200, inserted.size());

        for(Issue_Type__c rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
        }
    }

    //7. Process Builder: Reset the Issue Hierarchy Feed flag Flow

    @IsTest
    static void testIssueHierResetFlagsWhenTrue() {

        Issue_Hierarchy__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Hierarchy__c
            WHERE Alert_Distribution__c = 'Hierarchy True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueHierFeedSendTrueWhenFalse() {

        Issue_Hierarchy__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Hierarchy__c
            WHERE Alert_Distribution__c = 'Hierarchy False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueHierNullScenario() {

        Issue_Hierarchy__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Hierarchy__c
            WHERE Alert_Distribution__c = 'Hierarchy Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueHierUpdateScenario() {

        Classification__c classobj = new Classification__c(Description__c = 'Test Classification');
        insert classobj;

        Product_Line__c prodlineObj = new Product_Line__c(Code__c = 'PL0002', Name = 'Test Product Line2');
        insert prodlineObj;

        Cause__c causeObj = new Cause__c(Description__c = 'Test Cause');
        insert causeObj;

        Group__c groupObj = new Group__c(Description__c = 'Test Group');
        insert groupObj;

        Reason__c reasonObj = new Reason__c(Description__c = 'Test Reason');
        insert reasonObj;

        Issue_Type__c issuetypeObj = new Issue_Type__c(Description__c = 'Issue Null');
        insert issuetypeObj;

        Issue_Hierarchy__c rec = new Issue_Hierarchy__c(
            Alert_Distribution__c = 'Update Hierarchy',
            UpdateFromFeed__c = false,
            Classification__c = classobj.ID,
            Issue_Type__c = issuetypeObj.ID,
            Reason__c = reasonObj.ID,
            Product_Line__c = prodlineObj.ID,
            Cause__c = causeObj.ID,
            Group__c = groupObj.ID
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Hierarchy__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueHierBulkInsert() {

        Classification__c classobj = new Classification__c(Description__c = 'Test Classification');
        insert classobj;

        Product_Line__c prodlineObj = new Product_Line__c(Code__c = 'PL0003', Name = 'Test Product Line3');
        insert prodlineObj;

        Cause__c causeObj = new Cause__c(Description__c = 'Test Cause');
        insert causeObj;

        Group__c groupObj = new Group__c(Description__c = 'Test Group');
        insert groupObj;

        Reason__c reasonObj = new Reason__c(Description__c = 'Test Reason');
        insert reasonObj;

        Issue_Type__c issuetypeObj = new Issue_Type__c(Description__c = 'Issue Null');
        insert issuetypeObj;

        List<Issue_Hierarchy__c> bulkList =
            new List<Issue_Hierarchy__c>();

        for(Integer i = 0; i < 200; i++) {

            bulkList.add(new Issue_Hierarchy__c(
                Alert_Distribution__c = 'Bulk Hierarchy ' + i,
                UpdateFromFeed__c = false,
                Classification__c = classobj.ID,
                Issue_Type__c = issuetypeObj.ID,
                Reason__c = reasonObj.ID,
                Product_Line__c = prodlineObj.ID,
                Cause__c = causeObj.ID,
                Group__c = groupObj.ID
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Issue_Hierarchy__c> inserted = [
            SELECT FeedSend__c
            FROM Issue_Hierarchy__c
            WHERE Id IN :bulkList
        ];

        System.assertEquals(200, inserted.size());

        for(Issue_Hierarchy__c rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
        }
    }

    //8. Process Builder: Reset the Issue Adjustment Feed Flag Flow
    
    @IsTest
    static void testIssueAdjResetFlags() {

        Issue_Adjustment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Adjustment__c
            WHERE Adjustment_Type__c = 'Brand Hierarchy'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueAdjFeedSendTrueWhenFalse() {

        Issue_Adjustment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Adjustment__c
            WHERE Adjustment_Type__c = 'Consumer Notes'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueAdjFeedSendTrueWhenNull() {

        Issue_Adjustment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Adjustment__c
            WHERE Adjustment_Type__c = 'Date Code'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueAdjUpdateScenario() {

        Issue_Adjustment__c rec = new Issue_Adjustment__c(
            Adjustment_Type__c = 'Issue Hierarchy',
            UpdateFromFeed__c = false
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Issue_Adjustment__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testIssueAdjBulkInsert() {

        List<Issue_Adjustment__c> records =
            new List<Issue_Adjustment__c>();

        for(Integer i = 0; i < 200; i++) {

            records.add(new Issue_Adjustment__c(
                Adjustment_Type__c = 'Review',
                IssueNumber__c = 'Test' + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Issue_Adjustment__c> inserted = [
            SELECT FeedSend__c
            FROM Issue_Adjustment__c
            WHERE Id IN :records
        ];

        System.assertEquals(200, inserted.size());

        for(Issue_Adjustment__c rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
        }
    }

    //9. Process Builder: Reset the Case Feed flag Flow

    @IsTest
    static void testIssueResetFlagsWhenTrue() {

        Id currentUserId = UserInfo.getUserId();

        Case rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Case
            WHERE Subject = 'Case True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertEquals(currentUserId, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testIssueFeedSendTrueWhenFalse() {

        Id currentUserId = UserInfo.getUserId();

        Case rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Case
            WHERE Subject = 'Case False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertEquals(currentUserId, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testIssueFeedSendTrueWhenNull() {

        Id currentUserId = UserInfo.getUserId();

        Case rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Case
            WHERE Subject = 'Case Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertEquals(currentUserId, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testIssueUpdateScenario() {

        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing');
        insert opcompany;

        Id currentUserId = UserInfo.getUserId();

        Case rec = new Case(
            Subject = 'Case Update',
            Origin = 'Phone',
            Status = 'New',
            Comment__c = 'Test Case2',
            UpdateFromFeed__c = false,
            Op_Company__c = opcompany.ID,
            Purchase_Price__c = 4500
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Case
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
        System.assertEquals(currentUserId, rec.Feed_Last_Modified_By__c);
    }

    @IsTest
    static void testIssueBulkInsert() {

        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing');
        insert opcompany;

        Id currentUserId = UserInfo.getUserId();

        List<Case> records = new List<Case>();

        for(Integer i = 0; i < 200; i++) {

            records.add(new Case(
                Subject = 'Bulk Case ' + i,
                Origin = 'Phone',
                Status = 'New',
                Comment__c = 'Test Case2',
                UpdateFromFeed__c = false,
                Op_Company__c = opcompany.ID,
                Purchase_Price__c = 4500
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Case> inserted = [
            SELECT FeedSend__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Case
            WHERE Id IN :records
        ];

        System.assertEquals(200, inserted.size());

        for(Case rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
            System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
            System.assertEquals(currentUserId, rec.Feed_Last_Modified_By__c);
        }
    }

    //10. Process Builder: Reset the Customer Type Feed flag Flow

    @IsTest
    static void testResetFlagsCustTypeUpdateFromFeedTrue() {

        Customer_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Customer_Type__c
            WHERE Customer_Type__c = 'CT Feed True'
            LIMIT 1
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should be false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be false'
        );
    }

    @IsTest
    static void testFeedSendTrueCustTypeUpdateFromFeedFalse() {

        Customer_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Customer_Type__c
            WHERE Customer_Type__c = 'CT Feed False'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain false'
        );
    }

    @IsTest
    static void testCustTypeNullScenario() {

        Customer_Type__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Customer_Type__c
            WHERE Customer_Type__c = 'CT Feed Null'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain null'
        );
    }

    @IsTest
    static void testCustTypeUpdateScenario() {

        Customer_Type__c rec = new Customer_Type__c(
            Customer_Type__c = 'CT Update Test 5',
            Description__c = 'Test CT6',
            FeedSend__c = true,
            UpdateFromFeed__c = true
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Customer_Type__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should reset to false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should reset to false'
        );
    }

    @IsTest
    static void testCustTypeBulkInsert() {

        List<Customer_Type__c> records = new List<Customer_Type__c>();

        for(Integer i = 0; i < 200; i++) {

            records.add(new Customer_Type__c(
                Customer_Type__c = 'Bulk CT ' + i,
                Description__c = 'Test CT 3',
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Customer_Type__c> inserted = [
            SELECT FeedSend__c
            FROM Customer_Type__c
            WHERE Id IN :records
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All records should insert'
        );

        for(Customer_Type__c rec : inserted) {

            System.assertEquals(
                true,
                rec.FeedSend__c,
                'FeedSend__c should be true'
            );
        }
    }

    //11. Process Builder: Reset the Correspondence & Fulfilment Feed Flag Flow

    @IsTest
    static void testResetFlagsCorrFulUpdateFromFeedTrue() {

        Correspondence_Fulfilment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Correspondence_Fulfilment__c
            WHERE Letter_head__c = 'CF Feed True'
            LIMIT 1
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should be false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be false'
        );
    }

    @IsTest
    static void testFeedSendTrueCorrFulUpdateFromFeedFalse() {

        Correspondence_Fulfilment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Correspondence_Fulfilment__c
            WHERE Letter_head__c = 'CF Feed False'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain false'
        );
    }

    @IsTest
    static void testCorrfulNullScenario() {

        Correspondence_Fulfilment__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Correspondence_Fulfilment__c
            WHERE Letter_head__c = 'CF Feed Null'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            rec.FeedSend__c,
            'FeedSend__c should be true'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should remain null'
        );
    }

    @IsTest
    static void testCorrfulUpdateScenario() {

        Correspondence_Fulfilment__c rec =
            new Correspondence_Fulfilment__c(
                Letter_head__c = 'CF Update Test'
            );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Correspondence_Fulfilment__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(
            false,
            rec.FeedSend__c,
            'FeedSend__c should reset to false'
        );

        System.assertEquals(
            false,
            rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should reset to false'
        );
    }

    @IsTest
    static void testCorrfulBulkInsert() {

        List<Correspondence_Fulfilment__c> records =
            new List<Correspondence_Fulfilment__c>();

        for(Integer i = 0; i < 200; i++) {

            records.add(new Correspondence_Fulfilment__c(
                Letter_head__c = 'Bulk CF ' + i,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Correspondence_Fulfilment__c> inserted = [
            SELECT FeedSend__c
            FROM Correspondence_Fulfilment__c
            WHERE Id IN :records
        ];

        System.assertEquals(
            200,
            inserted.size(),
            'All records should insert'
        );

        for(Correspondence_Fulfilment__c rec : inserted) {

            System.assertEquals(
                true,
                rec.FeedSend__c,
                'FeedSend__c should be true'
            );
        }
    }

    //12. Process Builder: Reset the Contact Feed Flag Flow

    @IsTest
    static void testResetFlagsContactUpdateFromFeedTrue() {

        Contact rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   Last_Modified_By__c,
                   Last_Modified_DateTime__c
            FROM Contact
            WHERE StatusMessage__c = 'Feed True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.Last_Modified_By__c);
        System.assertNotEquals(null, rec.Last_Modified_DateTime__c);
    }

    @IsTest
    static void testFeedSendTrueContactUpdateFromFeedFalse() {

        Contact rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   Last_Modified_By__c,
                   Last_Modified_DateTime__c
            FROM Contact
            WHERE StatusMessage__c = 'Feed False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.Last_Modified_By__c);
        System.assertNotEquals(null, rec.Last_Modified_DateTime__c);
    }

    @IsTest
    static void testContactNullScenario() {

        Contact rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c
            FROM Contact
            WHERE StatusMessage__c = 'Feed Null'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
    }

    @IsTest
    static void testContactUpdateScenario() {

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        Contact rec = new Contact(
            FirstName = 'Contact', 
            LastName = 'Feed Null', 
            AccountId = acc.ID, 
            Street_Address__c = 'Test Add3', 
            Company_Name__c = 'Company3', 
            DBA_Name__c = 'Test3', 
            Phone = '9988776655',
            Zip_Code__c = '413307',
            CustomerID__c = 'Feed Null',
            FeedSend__c = false,
            UpdateFromFeed__c = false
        );

        insert rec;

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   Last_Modified_By__c,
                   Last_Modified_DateTime__c
            FROM Contact
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, rec.FeedSend__c);
        System.assertEquals(false, rec.UpdateFromFeed__c);
        System.assertNotEquals(null, rec.Last_Modified_By__c);
        System.assertNotEquals(null, rec.Last_Modified_DateTime__c);
    }

    @IsTest
    static void testContactBulkInsert() {

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

        List<Contact> records = new List<Contact>();

        for(Integer i = 0; i < 200; i++) {

            records.add(new Contact(
                FirstName = 'Contact', 
                LastName = 'Bulk Contact ' + i,
                AccountId = acc.ID, 
                Street_Address__c = 'Test Add' + i, 
                Company_Name__c = 'Company3'+ i,
                DBA_Name__c = 'Test'+ i, 
                Phone = '998877665'+ i,
                Zip_Code__c = '413307',
                CustomerID__c = 'Feed Null',
                FeedSend__c = false,
                UpdateFromFeed__c = false
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        List<Contact> inserted = [
            SELECT FeedSend__c
            FROM Contact
            WHERE Id IN :records
        ];

        System.assertEquals(200, inserted.size());

        for(Contact rec : inserted) {
            System.assertEquals(true, rec.FeedSend__c);
        }
    }
    
    //13. Process Builder: Reset the User Feed flag Flow

    @isTest
    static void test_When_UpdateFromFeed_True() {

        User u = createTestUser(true);

        Test.startTest();
        insert u;
        Test.stopTest();

        // Re-query to validate Flow changes
        User updatedUser = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM User
            WHERE Id = :u.Id
        ];

        System.assertEquals(false, updatedUser.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, updatedUser.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_When_UpdateFromFeed_False() {

        User u = createTestUser(false);

        Test.startTest();
        insert u;
        Test.stopTest();

        User updatedUser = [
            SELECT FeedSend__c
            FROM User
            WHERE Id = :u.Id
        ];

        System.assertEquals(true, updatedUser.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_Update_Scenario() {

        User u = createTestUser(false);
        insert u;

        // Now update flag to TRUE
        u.UpdateFromFeed__c = true;

        Test.startTest();
        update u;
        Test.stopTest();

        User updatedUser = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM User
            WHERE Id = :u.Id
        ];

        System.assertEquals(false, updatedUser.FeedSend__c);
        System.assertEquals(false, updatedUser.UpdateFromFeed__c);
    }

    //14. Process Builder: Reset the Question Feed Flag Flow

    @isTest
    static void test_Question_UpdateFromFeed_True() {

        Question__c q = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM Question__c
            WHERE QuestionToCheck__c = 'Question True'
            LIMIT 1
        ];

        System.assertEquals(false, q.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, q.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_Question_UpdateFromFeed_False() {

        Question__c q = [
            SELECT Id, FeedSend__c
            FROM Question__c
            WHERE QuestionToCheck__c = 'Question False'
            LIMIT 1
        ];

        System.assertEquals(true, q.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_Question_Scenario() {
        
        Question__c q = [
            SELECT Id, UpdateFromFeed__c
            FROM Question__c
            WHERE QuestionToCheck__c = 'Question False'
            LIMIT 1
        ];

        q.UpdateFromFeed__c = true;

        Test.startTest();
        update q;
        Test.stopTest();

        Question__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Question__c
            WHERE Id = :q.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_QuestionBulk_Insert() {

        List<Question__c> bulkList = new List<Question__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Question__c(
                Question__c = 'Bulk Question ' + i,
                QuestionToCheck__c = 'Question True',
                UpdateFromFeed__c = true,
                Type__c = 'Comment'
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Question__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Question__c
            WHERE Question__c LIKE 'Bulk Question%'
        ];

        for (Question__c q : results) {
            if (q.FeedSend__c == false) {
                System.assertEquals(false, q.UpdateFromFeed__c);
            }
        }
    }
    
    //15. Process Builder: Reset the Product Line Feed Flag Flow
    
    @isTest
    static void test_ProdLine_UpdateFromFeed_True() {

        Product_Line__c rec = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM Product_Line__c
            WHERE Name = 'PL True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_ProdLine_UpdateFromFeed_False() {

        Product_Line__c rec = [
            SELECT Id, FeedSend__c
            FROM Product_Line__c
            WHERE Name = 'PL False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_ProdLine_Update_Scenario() {

        Product_Line__c rec = [
            SELECT Id, UpdateFromFeed__c
            FROM Product_Line__c
            WHERE Name = 'PL False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        Product_Line__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Product_Line__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_ProdLine_Bulk_Insert() {

        List<Product_Line__c> bulkList = new List<Product_Line__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Product_Line__c(
                Name = 'Bulk PL ' + i,
                Code__c = '200'+ i,
                UpdateFromFeed__c = TRUE
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Product_Line__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Product_Line__c
            WHERE Name LIKE 'Bulk PL%'
        ];

        for (Product_Line__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

    //16. Process Builder: Reset the Document Type Feed flag Flow

     @isTest
    static void test_DocType_UpdateFromFeed_True() {

        DocumentType__c rec = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM DocumentType__c
            WHERE Description__c = 'DT True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_DocType_UpdateFromFeed_False() {

        DocumentType__c rec = [
            SELECT Id, FeedSend__c
            FROM DocumentType__c
            WHERE Description__c = 'DT False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_DocType_Update_Scenario() {

        DocumentType__c rec = [
            SELECT Id, UpdateFromFeed__c
            FROM DocumentType__c
            WHERE Description__c = 'DT False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        DocumentType__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM DocumentType__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_DocType_Bulk_Insert() {

        List<DocumentType__c> bulkList = new List<DocumentType__c>();
        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing1');
        insert opcompany;

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new DocumentType__c(
                Description__c = 'DT True' + i,
                PkgCode__c = '100' + i,
                DocTyp__c = 'Outbound',
                Op_Company__c = opcompany.ID,
                UpdateFromFeed__c = true
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<DocumentType__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM DocumentType__c
            WHERE Description__c LIKE 'Bulk DT%'
        ];

        for (DocumentType__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

    //17. Process Builder: Reset the CounterfeitTraceCode Feed Flag Flow

    @isTest
    static void test_CountTrace_UpdateFromFeed_True() {

        CounterfeitTraceCode__c rec = [
            SELECT Id, FeedSend__c, UpdateFromFeed__c
            FROM CounterfeitTraceCode__c
            WHERE Brand__c = 'CTC True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_CountTrace_UpdateFromFeed_False() {

        CounterfeitTraceCode__c rec = [
            SELECT Id, FeedSend__c
            FROM CounterfeitTraceCode__c
            WHERE Brand__c = 'CTC False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_CountTrace_Update_Scenario() {

        CounterfeitTraceCode__c rec = [
            SELECT Id, UpdateFromFeed__c
            FROM CounterfeitTraceCode__c
            WHERE Brand__c = 'CTC False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        CounterfeitTraceCode__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM CounterfeitTraceCode__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_CountTrace_Bulk_Insert() {

        List<CounterfeitTraceCode__c> bulkList = new List<CounterfeitTraceCode__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new CounterfeitTraceCode__c(
                Brand__c = 'Bulk CTC ' + i,
                Trace_Code__c = '100',
                Production_Date__c = Date.today(),
                UpdateFromFeed__c = TRUE
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<CounterfeitTraceCode__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM CounterfeitTraceCode__c
            WHERE Name LIKE 'Bulk CTC%'
        ];

        for (CounterfeitTraceCode__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

    //18. Process Builder: Reset the Brand Hierarchy Feed Flag Flow
    
    @isTest
    static void test_BrandHier_UpdateFromFeed_True() {

        Brand_Hierarchy__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand_Hierarchy__c
            WHERE Short_Cut__c = 'BH True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_BrandHier_UpdateFromFeed_False() {

        Brand_Hierarchy__c rec = [
            SELECT FeedSend__c
            FROM Brand_Hierarchy__c
            WHERE Short_Cut__c = 'BH False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_BrandHier_Update_Scenario() {

        Brand_Hierarchy__c rec = [
            SELECT Id
            FROM Brand_Hierarchy__c
            WHERE Short_Cut__c = 'BH False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        Brand_Hierarchy__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand_Hierarchy__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_BrandHier_Bulk_Insert() {

        List<Brand_Hierarchy__c> bulkList = new List<Brand_Hierarchy__c>();

        Product_Line__c pl = new Product_Line__c(Name = 'Test PL 1', Code__c = '600', UpdateFromFeed__c = false);
        insert pl;
        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing7');
        insert opcompany;
        Brand__c brand = new Brand__c(BrandCode__c = '1000', Name = 'Test Brand 1', Description__c = 'Testing Brand 3', Op_Company__c = opcompany.ID, Product_Line__c = pl.ID);
        insert brand;

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Brand_Hierarchy__c(
                Short_Cut__c = 'BH True',
                Vantive_Id__c = '100',
                Brand_Code__c = brand.ID,
                Product_Line_Code__c = pl.ID,
                UpdateFromFeed__c = true
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Brand_Hierarchy__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand_Hierarchy__c
            WHERE Name LIKE 'Bulk BH%'
        ];

        for (Brand_Hierarchy__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

    //19. Process Builder: Reset the Brand Feed Flag Flow

    @isTest
    static void test_Brand_UpdateFromFeed_True() {

        Brand__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand__c
            WHERE Name = 'Brand True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_Brand_UpdateFromFeed_False() {

        Brand__c rec = [
            SELECT FeedSend__c
            FROM Brand__c
            WHERE Name = 'Brand False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_Brand_Update_Scenario() {

        Brand__c rec = [
            SELECT Id
            FROM Brand__c
            WHERE Name = 'Brand False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        Brand__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_Brand_Bulk_Insert() {

        Product_Line__c pl = new Product_Line__c(Name = 'Test PL 1', Code__c = '800', UpdateFromFeed__c = false);
        insert pl;
        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing7');
        insert opcompany;
        
        List<Brand__c> bulkList = new List<Brand__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Brand__c(
                BrandCode__c = '1000' + i, 
                Name = 'Brand True' + i, 
                Description__c = 'Testing Brand ' + i, 
                Op_Company__c = opcompany.ID, 
                Product_Line__c = pl.ID,
                UpdateFromFeed__c = true
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Brand__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Brand__c
            WHERE Name LIKE 'Bulk Brand%'
        ];

        for (Brand__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

    //20. Process Builder: Reset the Answer Feed flag Flow

    @isTest
    static void test_Answer_UpdateFromFeed_True() {
        
        Answer__c rec = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Answer__c
            WHERE PMAnswerID__c = 1000
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');
    }

    @isTest
    static void test_Answer_UpdateFromFeed_False() {

        Answer__c rec = [
            SELECT FeedSend__c
            FROM Answer__c
            WHERE PMAnswerID__c = 2000
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');
    }

    @isTest
    static void test_Answer_Update_Scenario() {

        Answer__c rec = [
            SELECT Id
            FROM Answer__c
            WHERE PMAnswerID__c = 2000
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        Answer__c updated = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Answer__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
    }

    @isTest
    static void test_Answer_Bulk_Insert() {
            
        List<Answer__c> bulkList = new List<Answer__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Answer__c(
                Answer__c = 'Bulk Answer ' + i,
                PMAnswerID__c = 3000 + i,
                UpdateFromFeed__c = true
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Answer__c> results = [
            SELECT FeedSend__c, UpdateFromFeed__c
            FROM Answer__c
            WHERE PMAnswerID__c > 3000
        ];

        for (Answer__c rec : results) {
            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }
    
    //21. Process Builder: Reset the Reimbursement Feed Flag Flow

    @isTest
    static void test_Reimb_UpdateFromFeed_True() {

        Reimbursement__c rec = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Reimbursement__c
            WHERE Altria_File_Name__c = 'Reimb True'
            LIMIT 1
        ];

        System.assertEquals(false, rec.FeedSend__c,
            'FeedSend__c should be FALSE when UpdateFromFeed__c is TRUE');

        System.assertEquals(false, rec.UpdateFromFeed__c,
            'UpdateFromFeed__c should be reset to FALSE');

        System.assertNotEquals(null, rec.FeedLastModifiedDate__c,
            'FeedLastModifiedDate__c should be populated');

        System.assertEquals(UserInfo.getUserId(), rec.Feed_Last_Modified_By__c,
            'Feed_Last_Modified_By__c should be current user');
    }

    @isTest
    static void test_Reimb_UpdateFromFeed_False() {

        Reimbursement__c rec = [
            SELECT FeedSend__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Reimbursement__c
            WHERE Altria_File_Name__c = 'Reimb False'
            LIMIT 1
        ];

        System.assertEquals(true, rec.FeedSend__c,
            'FeedSend__c should be TRUE when UpdateFromFeed__c is FALSE');

        System.assertNotEquals(null, rec.FeedLastModifiedDate__c,
            'FeedLastModifiedDate__c should be populated');

        System.assertEquals(UserInfo.getUserId(), rec.Feed_Last_Modified_By__c);
    }

    @isTest
    static void test_Reimb_Update_Scenario() {

        Reimbursement__c rec = [
            SELECT Id
            FROM Reimbursement__c
            WHERE Altria_File_Name__c = 'Reimb False'
            LIMIT 1
        ];

        rec.UpdateFromFeed__c = true;

        Test.startTest();
        update rec;
        Test.stopTest();

        Reimbursement__c updated = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Reimbursement__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals(false, updated.FeedSend__c);
        System.assertEquals(false, updated.UpdateFromFeed__c);
        System.assertNotEquals(null, updated.FeedLastModifiedDate__c);
        System.assertEquals(UserInfo.getUserId(), updated.Feed_Last_Modified_By__c);
    }

    @isTest
    static void test_Reimb_Bulk_Insert() {

        Operating_Company__c opcompany = new Operating_Company__c(OperatingCompany__c = 'JMC', Active__c = TRUE, OpCo_Description__c = 'Testing');
        insert opcompany;

        Case caseobj = new Case(Op_Company__c = opcompany.ID, Purchase_Price__c = 4500, Origin = 'Email');
        insert caseobj;

        List<Reimbursement__c> bulkList = new List<Reimbursement__c>();

        for (Integer i = 0; i < 50; i++) {
            bulkList.add(new Reimbursement__c(
                Altria_File_Name__c = 'Reimb True' + i,
                Issue__c = caseobj.Id,
                Cheque_Amount__c = 500,
                UpdateFromFeed__c = true
            ));
        }

        Test.startTest();
        insert bulkList;
        Test.stopTest();

        List<Reimbursement__c> results = [
            SELECT FeedSend__c,
                   UpdateFromFeed__c,
                   FeedLastModifiedDate__c,
                   Feed_Last_Modified_By__c
            FROM Reimbursement__c
            WHERE Name LIKE 'Bulk Reimb%'
        ];

        for (Reimbursement__c rec : results) {

            // Audit fields must always be populated
            System.assertNotEquals(null, rec.FeedLastModifiedDate__c);
            System.assertEquals(UserInfo.getUserId(), rec.Feed_Last_Modified_By__c);

            if (rec.FeedSend__c == false) {
                System.assertEquals(false, rec.UpdateFromFeed__c);
            }
        }
    }

}