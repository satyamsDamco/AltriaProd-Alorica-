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
@isTest
private class ConsumerDetailControllerTest {


    // Test Method to cover ConsumerDetailController's Constructor.
    static testMethod void ConsumerDetailConstructor() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1973, 08, 01);
        Contact testCont = TestDataSetup.createContact('John','Cope',testAcc.Id,true,'94544',bdate,'511 SYCAMORE AVE', true, true);
        testCont.Email = 'test123@test.com';
        testCont.City__c = 'HAYWARD';
        testCont.State__c = 'CA';
        testCont.Title = 'Mr';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','PMUSA',true);
        insert testOpCo;
        TFN__c testTFN = TestDataSetup.createTFN(true, '1800', 45, testOpCo);
        insert testTFN;
        Transaction_Management__c testTM= TestDataSetup.createTM(testOpCo, testTFN);
        insert testTM;
        ApexPages.currentPage().getParameters().put('from','Search');
        ApexPages.currentPage().getParameters().put('Lname',testCont.LastName);
        ApexPages.currentPage().getParameters().put('Title',testCont.Title);
        ApexPages.currentPage().getParameters().put('Addr1',testCont.Apt_Lot__c);
        ApexPages.currentPage().getParameters().put('add',testCont.Street_Address__c);
        ApexPages.currentPage().getParameters().put('City',testCont.City__c);
        ApexPages.currentPage().getParameters().put('State',testCont.State__c);
        ApexPages.currentPage().getParameters().put('dob',testCont.Birthdate__c);
        ApexPages.currentPage().getParameters().put('zip',testCont.Zip_Code__c);
        ApexPages.currentPage().getParameters().put('CCN',testCont.CCN__c);
        ApexPages.currentPage().getParameters().put('strAVCode',testCont.AV_Code__c);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);
        ApexPages.currentPage().getParameters().put('country',testCont.Country__c);
        ApexPages.currentPage().getParameters().put('phone',testCont.Phone);
        ApexPages.currentPage().getParameters().put('tranid', testTM.Id);
        ApexPages.currentPage().getParameters().put('Fname',testCont.Id);
        ApexPages.currentPage().getParameters().put('email',testCont.Email);

        // NOTE: the controller reads the cookie using the lowercase key
        // 'tranid', so the cookie name here must match exactly (case
        // sensitive) in order for the `counter != null` / currentTran
        // assignment branch inside the constructor to actually execute.
        Cookie tranId = new Cookie('tranid', testTM.id, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{tranId});

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        Test.stopTest();

        // Confirms the cookie branch was exercised and currentTran was populated.
        System.assertEquals(testTM.Id, controller.currentTran);
    }

    // Test method to cover the constructor's "no tranid cookie present" path,
    // i.e. the counter == null branch (currentTran left unset).
    static testMethod void validateConstructorNoCookie() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        Test.stopTest();

        System.assertEquals(null, controller.currentTran);
    }

    // Test method to cover getCurrCountry method - country populated (not
    // null/None/Label.Country) branch, so isAgeVerificationReq becomes false
    // and the nested CustomerType__c check is short-circuited.
    static testMethod void validateCurrentCountry() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = 'India';
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.getCurrCountry();
        Test.stopTest();
        System.assertEquals(false, controller.isAgeVerificationReq);
    }

    // Test method to cover the branch where Country__c is null (so
    // isAgeVerificationReq starts true) AND CustomerType__c equals
    // Label.CustomerType, meaning isAgeVerificationReq should stay true.
    static testMethod void validateCurrentCountryNullMatchingCustomerType() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = null;
        testCont.CustomerType__c = Label.CustomerType;
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.getCurrCountry();
        Test.stopTest();

        System.assertEquals(true, controller.isAgeVerificationReq);
    }

    // Test method to cover the branch where Country__c is null (so
    // isAgeVerificationReq starts true) AND CustomerType__c does NOT equal
    // Label.CustomerType, so isAgeVerificationReq flips to false.
    static testMethod void validateCurrentCountryNullDifferentCustomerType() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Country__c = null;
        // Pick a short value guaranteed to differ from Label.CustomerType,
        // while staying under the field's 20-character limit.
        testCont.CustomerType__c = (Label.CustomerType == 'Trade') ? 'Consumer' : 'Trade';
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.getCurrCountry();
        Test.stopTest();

        System.assertEquals(false, controller.isAgeVerificationReq);
    }

    //Test Method to cover editConsumer method - conObj.id != null branch.
    static testMethod void validateEditConsumer() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
         Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            PageReference pg = controller.editConsumer();
        Test.stopTest();
        System.assertNotEquals(null, pg);
    }

    // Test method to cover editConsumer's null-id branch. We build the
    // controller from an inserted contact (so the constructor's queries have
    // a valid Id to work with), then clear conObj.Id before calling
    // editConsumer() to exercise the "else return null" path.
    static testMethod void validateEditConsumerNullId() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.conObj = new Contact();
            PageReference pg = controller.editConsumer();
        Test.stopTest();

        System.assertEquals(null, pg);
    }

    //Test method to cover refreshpage method - conObj.id != null branch.
    static testMethod void validateRefreshPage() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc ;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo= TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;
        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            PageReference pg = controller.refreshpage();
        Test.stopTest();
        System.assertNotEquals(null, pg);
    }

    // Test method to cover refreshpage's null-id branch.
    static testMethod void validateRefreshPageNullId() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            controller.conObj = new Contact();
            PageReference pg = controller.refreshpage();
        Test.stopTest();

        System.assertEquals(null, pg);
    }

    // Test method to cover getChatHistory() "return null" branch (no
    // MessagingSession records exist for the contact). Building a populated
    // MessagingSession in a unit test requires Embedded Service / Messaging
    // channel setup that isn't reliably creatable via DML in a test context,
    // so this covers the empty-list branch, which is the reachable one here.
    static testMethod void validateGetChatHistoryEmpty() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));

        Test.startTest();
            // Call as a bare statement rather than assigning to a
            // List<MessagingSession> variable - this org doesn't have the
            // MessagingSession type resolvable for new compiles (Digital
            // Engagement/Messaging not enabled), so declaring that type here
            // fails even though the already-compiled controller can still
            // reference it. This still exercises the method body/SOQL and
            // the "empty list" branch for coverage purposes.
            controller.getChatHistory();
        Test.stopTest();
    }

    // Test method to cover the sorting related methods: sortExpression setter
    // (both the "same column clicked" and "different column clicked" branches),
    // setSortDirection(), getcases(), and the ViewData() branch where sortExp
    // has already been set (i.e. is not null).
    static testMethod void validateSortingMethods() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));

            // First call: sortExp is currently 'CaseNumber__c' (set by the constructor's
            // toggleSort()/ViewData() call), so setting it again exercises the
            // "same column" (value == sortExp) toggle branch.
            controller.sortExpression = 'CaseNumber__c';
            System.assertEquals('DESC', controller.getSortDirection());

            // Setting a different column exercises the "different column" branch.
            controller.sortExpression = 'Brandcode__c';
            System.assertEquals('ASC', controller.getSortDirection());

            controller.setSortDirection('DESC');
            System.assertEquals('DESC', controller.getSortDirection());

            // ViewData() runs again here with sortExp already populated, covering
            // the "else" branch where sortExp is not null.
            controller.ViewData();
            System.assertNotEquals(null, controller.getcases());
        Test.stopTest();
    }

    // Test method to cover the "true" branch of checkReimbHist(), where matching
    // Reimbursement__c records exist for the consumer.
    static testMethod void validateCheckReimbHistTrue() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Case testCase = new Case();
        testCase.ContactId = testCont.Id;
        testCase.Op_Company__c = testOpCo.Id;
        insert testCase;

        Reimbursement__c reimb = new Reimbursement__c();
        reimb.Consumer__c = testCont.Id;
        reimb.Zip_Code__c = testCont.Zip_Code__c;
        reimb.Street_Address__c = testCont.Street_Address__c;
        reimb.Issue__c = testCase.Id;
        insert reimb;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            Boolean result = controller.checkReimbHist();
            System.assertEquals(true, result);
        Test.stopTest();
    }

    // Test method to cover the "false" branch of checkReimbHist(), where no
    // Reimbursement__c records match either by Consumer__c or by
    // Zip_Code__c/Street_Address__c.
    static testMethod void validateCheckReimbHistFalse() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'99999',bdate,'No Match Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            Boolean result = controller.checkReimbHist();
            System.assertEquals(false, result);
        Test.stopTest();
    }

    // Test method to cover the isHotZip page parameter branch (getHZ != null)
    // in the constructor.
    static testMethod void validateIsHotZipParameter() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        ApexPages.currentPage().getParameters().put('isHotZip', 'true');

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            System.assertEquals(true, controller.isHotZip);
        Test.stopTest();
    }

    // Test method to cover the constructor's "no isHotZip parameter" branch
    // (getHZ == null), so isHotZip defaults to false.
    static testMethod void validateIsHotZipParameterAbsent() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        insert testCont;
        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
        Test.stopTest();

        System.assertEquals(false, controller.isHotZip);
    }

    // Test method to cover gethouseholdMemberDetail() populating the
    // householdMembers list with matching, active contacts at the same address.
    static testMethod void validateHouseholdMembers() {
        Account testAcc = TestDataSetup.createAccount('Test Account');
        insert testAcc;
        Date bdate = Date.newInstance(1989, 06, 14);
        Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        testCont.Active__c = true;
        testCont.DoNotUse__c = false;
        insert testCont;

        Contact householdMember = TestDataSetup.createContact('Family Fname','Family Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
        householdMember.Active__c = true;
        householdMember.DoNotUse__c = false;
        insert householdMember;

        Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
        insert testOpCo;

        Test.startTest();
            ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
            System.assertNotEquals(null, controller.householdMembers);
        Test.stopTest();
    }

    // Test method to cover the Customershow = false branch, which skips
    // isHotZip/isReimbHist/household member logic for non-Consumer record types.
    static testMethod void validateNonConsumerRecordType() {
        Id nonConsumerRecordTypeId;
        Map<String, Schema.RecordTypeInfo> rtByName = Schema.SObjectType.Contact.getRecordTypeInfosByName();
        for (String rtName : rtByName.keySet()) {
            Schema.RecordTypeInfo rtInfo = rtByName.get(rtName);
            if (rtName != 'Consumer' && rtName != 'Master' && rtInfo.getRecordTypeId() != null) {
                nonConsumerRecordTypeId = rtInfo.getRecordTypeId();
                break;
            }
        }

        // Only run the assertions if the org actually has a second active
        // Contact record type available.
        if (nonConsumerRecordTypeId != null) {
            Account testAcc = TestDataSetup.createAccount('Test Account');
            insert testAcc;
            Date bdate = Date.newInstance(1989, 06, 14);
            Contact testCont = TestDataSetup.createContact('Test Fname','Test Lname',testAcc.Id,true,'20001',bdate,'Test Street', true, true);
            testCont.RecordTypeId = nonConsumerRecordTypeId;
            insert testCont;
            Operating_Company__c testOpCo = TestDataSetup.createOpCo('Telephone', 'Phone USST','Inbound','  PMUSA',true);
            insert testOpCo;

            Test.startTest();
                ConsumerDetailController controller = new ConsumerDetailController(new ApexPages.StandardController(testCont));
                System.assertEquals(false, controller.Customershow);
            Test.stopTest();
        }
    }

}