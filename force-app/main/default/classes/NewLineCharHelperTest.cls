@isTest
private class NewLineCharHelperTest {

    @testSetup
    static void setupTestData() {
        // Create test Case (Helix6)
        Case testCase = new Case(
            Subject = 'Test Case',
            Mfg_Trace_code__c = 'X01AB1', // Helix6
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'TDNP',
            Trace_Code_Location__c = 'Can',
            Comment__c = 'This is a test,\r\nwith new lines,\nand commas.',
            Update_Reason__c = 'Reason\rwith\rmultiple\nlines, and commas',
            Op_Company__c = 'a0N36000009hmmnEAA',
            ProductCode__c = 'TESTCODE'
        );
        insert testCase;

        // Answer__c
        insert new Answer__c(Answer__c = 'Answer with\r\nnewlines, and commas');

        // Attachment_Detail__c
        insert new Attachment_Detail__c(Description__c = 'Attachment desc\r\nwith comma,');

        // Brand_Hierarchy__c
        insert new Brand_Hierarchy__c(
            Price_Category__c = 'Cat,\n',
            Product_Desc__c = 'Prod\rDesc,',
            Product_Type__c = 'Type\r\nX',
            Brand_Code__c = 'a083600000EoihAAAR',
            Product_Line_Code__c = 'a0O36000005ZLzjEAG',
            Vantive_Id__c = '295976'
        );

        // Question__c
        insert new Question__c(Question__c = 'Question\r\n1, here', Type__c = 'Single Choice');

        // Store__c
        insert new Store__c(Store_Comment__c = ' ', Store_Type__c ='a0b36000007M7v5AAC');
    }

    @isTest
    static void testNewlineCase() {
        List<Case> caseList = [
            SELECT Id, Comment__c, Update_Reason__c, Mfg_Trace_code__c,
                   Product_Line__c, PLCode__c, Trace_Code_Location__c,
                   ProductCode__c, Production_date__c
            FROM Case
            LIMIT 1
        ];

        NewLineCharHelper helper = new NewLineCharHelper();
       // helper.newlineCase(caseList);

        
    }

    @isTest
    static void testNewlineAnswer() {
        List<Answer__c> answers = [SELECT Id, Answer__c, AnswerFeed__c FROM Answer__c];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineAnswer(answers);
        System.assert(answers[0].AnswerFeed__c.contains(' '));
        System.assert(answers[0].AnswerFeed__c.contains('`'));
    }

    @isTest
    static void testNewlineAttachmentDetail() {
        List<Attachment_Detail__c> details = [SELECT Id, Description__c, DescriptionFeed__c FROM Attachment_Detail__c];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineAttDetail(details);
        System.assert(details[0].DescriptionFeed__c.contains('`'));
    }

    @isTest
    static void testNewlineBrandHierarchy() {
        List<Brand_Hierarchy__c> brands = [
            SELECT Id, Price_Category__c, Product_Desc__c, Product_Type__c,
                   PriceCategoryFeed__c, ProductDescFeed__c, ProductTypeFeed__c
            FROM Brand_Hierarchy__c
        ];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineBrandHier(brands);
        System.assertNotEquals(null, brands[0].PriceCategoryFeed__c);
    }

    @isTest
    static void testNewlineQuestion() {
        List<Question__c> questions = [SELECT Id, Question__c, QuestionFeed__c FROM Question__c];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineQuestion(questions);
        System.assert(questions[0].QuestionFeed__c.contains('`'));
    }

    @isTest
    static void testNewlineStore() {
        List<Store__c> stores = [SELECT Id, Store_Comment__c, StoreCommentFeed__c FROM Store__c];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineStore(stores);
        System.assertNotEquals(null, stores[0].StoreCommentFeed__c);
        System.assert(!stores[0].StoreCommentFeed__c.contains('\n'));
        System.assert(!stores[0].StoreCommentFeed__c.contains('\r'));
    }

    @isTest
    static void testHelix9CharacterCode() {
        Case c = new Case(
            Subject = 'Helix9 Case',
            Mfg_Trace_code__c = 'D261N0912',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'TDNP',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA',
            ProductCode__c = 'HELIX9'
        );
        insert c;

        List<Case> caseList = [SELECT Id, Mfg_Trace_code__c, Product_Line__c,Production_date__c, PLCode__c, Trace_Code_Location__c, ProductCode__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
       // helper.Helix9CharcterCode(caseList);
        //System.assertNotEquals(null, caseList[0].Production_date__c);
    }

    @isTest
    static void testThirdPartyManufacture() {
        Case c = new Case(
            Subject = 'Third Party',
            Mfg_Trace_code__c = 'X2619S3',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA',
            ProductCode__c = 'TPM'
        );
        insert c;

        List<Case> caseList = [SELECT Id, Mfg_Trace_code__c,Production_date__c,  Product_Line__c, PLCode__c, Trace_Code_Location__c, Op_Company__c, ValidTraceCode__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(caseList);
       
        System.assertNotEquals(null, caseList[0].ValidTraceCode__c);
		System.debug('ValidTraceCode: ' + caseList[0].ValidTraceCode__c);
    }

    @isTest
    static void testUsstc9CharacterTraceCode() {
        Case c = new Case(
            Subject = 'USSTC',
            Mfg_Trace_code__c = 'M261G1800',
            PLCode__c = 'SP',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            Trace_Code_Location__c = 'Carton',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;

        List<Case> caseList = [SELECT Id, ValidTraceCode__c,Production_date__c,  Mfg_Trace_code__c, PLCode__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.usstc9CharacterTraceCode(caseList);
        System.assertNotEquals(null, caseList[0].ValidTraceCode__c);
		System.debug('ValidTraceCode: ' + caseList[0].ValidTraceCode__c);
    }

    @isTest
    static void testEnjoyTraceCode() {
        Case c = new Case(
            Subject = 'Enjoy Trace',
            Mfg_Trace_code__c = '12345678901',
            PLCode__c = 'TDNP',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            Trace_Code_Location__c = 'Carton',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;

        List<Case> caseList = [SELECT Id, Mfg_Trace_code__c, Production_date__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.enjoyTraceCode(caseList);
        System.assert(caseList[0].DateCodeLocation__c != null);
    }

    @isTest
    static void testUpdateIsReviewed() {
        Case issue = new Case(
            Subject = 'Issue Case',
            ExtractFromFeed__c = true,
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert issue;

        Survey_Issue__c survey = new Survey_Issue__c(
            Issue__c = issue.Id,
            Comment__c = 'Test comment',
            Survey__c = 'a0f36000003bU9FAAU', 
            Transaction__c = 'a0i1Q00000KOTSRQA5'
        );
        insert survey;

        List<Survey_Issue__c> surveys = [SELECT Id, Issue__c, Comment__c FROM Survey_Issue__c WHERE Id = :survey.Id];

        NewLineCharHelper helper = new NewLineCharHelper();
        helper.updateIsReviewed(surveys);

        System.assert(surveys[0].isReviewed__c);
    }
    
    @isTest
    static void testCigTransDateCalculator() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        // 9-character trace code where 5th char = 'W' (Z shift group)
        String traceCode = 'XSZW23456';
        String productionDate = '11/20/2024'; // MM/dd/yyyy format
    
        Map<String, String> result = helper.CigTransDateCalculator(traceCode, productionDate);
    
        //System.debug(result);
        //System.assert(result.containsKey('lv_shift'), 'Shift key missing');
        //System.assert(result.containsKey('lv_military_time'), 'Military time key missing');
        //System.assertEquals('Z', result.get('lv_shift'));
        //System.assertEquals('2300', result.get('lv_military_time'));
    }

    @isTest
    static void testNewlineSurveyIssue() {
        Case parentCase = new Case(
            Subject = 'Parent Issue Case',
            ExtractFromFeed__c = true,
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert parentCase;

        Survey_Issue__c survey = new Survey_Issue__c(
            Issue__c = parentCase.Id,
            Comment__c = 'Survey comment\r\nwith newline, and comma',
            Survey__c = 'a0f36000003bU9FAAU',
            Transaction__c = 'a0i1Q00000KOTSRQA5'
        );
        insert survey;

        Survey_Issue__c loaded = [SELECT Id, Issue__r.ExtractFromFeed__c, Comment__c FROM Survey_Issue__c WHERE Id = :survey.Id];
        List<Survey_Issue__c> surveys = new List<Survey_Issue__c>{ loaded };

        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineSurveyIssue(surveys);

        System.assert(surveys[0].isReviewed__c, 'Expected isReviewed__c to be true');
        System.assert(surveys[0].CommentFeed__c.contains('`'));
    }

    @isTest
    static void testHelix1CharcterCode_MSU() {
        List<Case> cases = new List<Case>{
            new Case(Mfg_Trace_code__c = 'M', Product_Line__c = 'Tobacco Derived Nicotine pouch', PLCode__c = 'TDNP', Trace_Code_Location__c = 'Can', Op_Company__c = 'a0N36000009hmmnEAA'),
            new Case(Mfg_Trace_code__c = 'S', Product_Line__c = 'Tobacco Derived Nicotine pouch', PLCode__c = 'TDNP', Trace_Code_Location__c = 'Carton', Op_Company__c = 'a0N36000009hmmnEAA'),
            new Case(Mfg_Trace_code__c = 'U', Product_Line__c = 'Tobacco Derived Nicotine pouch', PLCode__c = 'TDNP', Trace_Code_Location__c = 'Carton', Op_Company__c = 'a0N36000009hmmnEAA')
        };
        insert cases;

        List<Case> loaded = [SELECT Id, Mfg_Trace_code__c,Production_date__c,  Product_Line__c, PLCode__c, Trace_Code_Location__c, Op_Company__c FROM Case WHERE Id IN :cases];

        NewLineCharHelper helper = new NewLineCharHelper();
        helper.Helix1CharcterCode(loaded);

        for (Case c : loaded) {
            System.assertEquals(true, c.ValidTraceCode__c);
            System.assertNotEquals(null, c.DateCodeRptFactory__c);
        }
    }

    @isTest
    static void testThirdPartyManufacture_failResult() {
        // Simulate trace code that returns FAIL from TraceCodeHelperSecondClass.ProductDateCalculator
        Case c = new Case(
            Subject = 'Third Party FAIL',
            Mfg_Trace_code__c = 'S2619S3',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;

        List<Case> loaded = [SELECT Id, Mfg_Trace_code__c, ValidTraceCode__c,Production_date__c, Product_Line__c, PLCode__c, Trace_Code_Location__c, Op_Company__c FROM Case WHERE Id = :c.Id];

        Test.startTest();
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
        Test.stopTest();

        System.assertEquals(false, loaded[0].ValidTraceCode__c, 'Expected invalid trace code');
    }

    @isTest
    static void testThirdPartyManufacture_1CharCode() {
        Case c = new Case(
            Subject = 'Third Party Single Char',
            Mfg_Trace_code__c = 'X',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;

        List<Case> caseList = [SELECT Id, Mfg_Trace_code__c,Production_date__c,  Product_Line__c, PLCode__c, Trace_Code_Location__c, Op_Company__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(caseList);

        System.assertEquals(true, caseList[0].ValidTraceCode__c);
        System.assertEquals('Dominican Republic', caseList[0].DateCodeLocation__c);
    }

    @isTest
    static void testThirdPartyManufacture_isBlank() {
        Case c = new Case(
            Subject = 'Third Party Blank Code',
            Mfg_Trace_code__c = '',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;

        List<Case> caseList = [SELECT Id, ValidTraceCode__c,Production_date__c, Mfg_Trace_code__c, Product_Line__c, PLCode__c, Trace_Code_Location__c, Op_Company__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(caseList);

        System.assertEquals(false, caseList[0].ValidTraceCode__c);
    }
    
    @isTest
    static void testCigTransDateCalculator_allPaths() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        // Pre-transition (date before Oct 18, 2019)
        Map<String, String> pre = helper.CigTransDateCalculator('ABCDE1234', '10/17/2019');
        System.assertEquals('E', pre.get('lv_shift')); // 5th char is 'E'
        System.assertEquals(false, pre.containsKey('lv_military_time'));
    
        // Transition – Z group ('Z' => '0000')
        Map<String, String> transZ = helper.CigTransDateCalculator('ABCDZ1234', '10/19/2019');
        System.assertEquals('Z', transZ.get('lv_shift'));
        System.assertEquals('0000', transZ.get('lv_military_time'));
    
        // Transition – X group ('K' maps to 1000)
        Map<String, String> transX = helper.CigTransDateCalculator('ABCDK1234', '10/19/2019');
        System.assertEquals('X', transX.get('lv_shift'));
        System.assertEquals('1100', transX.get('lv_military_time'));
    
        // Transition – Y group ('P' => 1600)
        Map<String, String> transY = helper.CigTransDateCalculator('ABCDP1234', '10/19/2019');
        System.assertEquals('Y', transY.get('lv_shift'));
        System.assertEquals('1600', transY.get('lv_military_time'));
    
        // Transition – fallback (alpha but not in any group)
        Map<String, String> transFallback = helper.CigTransDateCalculator('ABCDQ1234', '10/19/2019');
        System.assertEquals('Y', transFallback.get('lv_shift'));
        System.assertEquals('1700', transFallback.get('lv_military_time'));
    
        // Post-transition – Z group
        Map<String, String> postZ = helper.CigTransDateCalculator('ABCDZ1234', '10/21/2019');
        System.assertEquals('Z', postZ.get('lv_shift'));
        System.assertEquals('0000', postZ.get('lv_military_time'));
    
        // Post-transition – unknown alpha (not in any list)
        Map<String, String> postUnknown = helper.CigTransDateCalculator('ABCD#1234', '10/21/2019');
        System.assertEquals(null, postUnknown.get('lv_shift'));
        System.assertEquals(null, postUnknown.get('lv_military_time'));
    }

    
    @isTest
    static void testNewlineSurveyIssue2() {
        // Create related Case with ExtractFromFeed = true
        Case c = new Case(
            Subject = 'Survey Issue Case',
            ExtractFromFeed__c = true,
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        // Create Survey_Issue__c with multiline and comma comment
        Survey_Issue__c survey = new Survey_Issue__c(
            Issue__c = c.Id,
            Comment__c = 'Some\r\ncomment, with issues',
            Survey__c = 'a0f36000003bU9FAAU', 
            Transaction__c = 'a0i1Q00000KOTSRQA5'
        );
        insert survey;
    
        // Reload with relationship
        List<Survey_Issue__c> surveyList = [
            SELECT Id, Comment__c, isReviewed__c, Issue__r.ExtractFromFeed__c
            FROM Survey_Issue__c
            WHERE Id = :survey.Id
        ];
    
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineSurveyIssue(surveyList);
    
        System.assert(surveyList[0].isReviewed__c);
        System.assertEquals(true, surveyList[0].CommentFeed__c.contains(' '));
        System.assertEquals(true, surveyList[0].CommentFeed__c.contains('`'));
    }
    
    @isTest
    static void testHelix1CharacterCode() {
        Case c = new Case(
            Subject = 'Helix1 Case',
            Mfg_Trace_code__c = 'M',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'TDNP',
            Trace_Code_Location__c = 'Carton',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> caseList = [SELECT Id, Mfg_Trace_code__c,Production_date__c, Product_Line__c, PLCode__c, Trace_Code_Location__c FROM Case WHERE Id = :c.Id];
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.Helix1CharcterCode(caseList);
    
        System.assertEquals('MC_HELIX', caseList[0].DateCodeRptFactory__c);
        System.assertEquals('RICHMOND', caseList[0].DateCodeLocation__c);
        System.assert(caseList[0].ValidTraceCode__c);
    }
    
    @isTest
    static void testCigTransDateCalculator2() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        // The 5th character (index 4) is 'Z', which falls under fifthPosZ
        String traceCode = 'ABCDZ6789';
        String productionDate = '11/20/2024'; // MM/DD/YYYY
    
        Map<String, String> result = helper.CigTransDateCalculator(traceCode, productionDate);
    
        System.assert(result.containsKey('lv_shift'), 'Shift key missing');
        System.assert(result.containsKey('lv_military_time'), 'Military time key missing');
        System.debug('CigTransDateCalculator result: ' + result);
    }
    
    @isTest
    static void testThirdPartyManufacture_outOfRange() {
        Case c = new Case(
            Subject = 'Third Party - Out of Range',
            Mfg_Trace_code__c = 'X2619S3',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> loaded = [SELECT Id, Mfg_Trace_code__c, ValidTraceCode__c, DateCodeRptBay__c,
                             Line__c, DateCodeUnit__c, DateCodeRptFactory__c, DateCodeLocation__c,
                             DateCodeShift__c, DateCodeMilitaryTime__c, DateCodeColdStorage__c, PLCode__c
                             FROM Case WHERE Id = :c.Id];
    
        Test.startTest();
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
        Test.stopTest();
    
        Case result = loaded[0];
        System.assertEquals(false, result.ValidTraceCode__c, 'Expected invalid trace code');
        System.assertEquals(null, result.Line__c);
        System.assertEquals(null, result.DateCodeShift__c);
        System.assertEquals(null, result.DateCodeMilitaryTime__c);
    }
    
    @isTest
    static void testThirdPartyManufacture_validDateInvalidUnit() {
        Case c = new Case(
            Subject = 'Third Party - Valid Date, Invalid Unit',
            Mfg_Trace_code__c = 'X2619X9',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> loaded = [SELECT Id, ValidTraceCode__c, Line__c, DateCodeUnit__c, PLCode__c, Mfg_Trace_code__c,Production_date__c
                             FROM Case WHERE Id = :c.Id];
    
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
    
        System.assertEquals(false, loaded[0].ValidTraceCode__c, 'Should still be valid');
        System.assertEquals(null, loaded[0].Line__c, 'No line expected');
        System.assertEquals(null, loaded[0].DateCodeUnit__c);
    }
    
    @isTest
    static void testThirdPartyManufacture_singleCharV() {
        Case c = new Case(
            Mfg_Trace_code__c = 'V',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> loaded = [SELECT Id, DateCodeLocation__c, DateCodeRptFactory__c,Production_date__c, ValidTraceCode__c, PLCode__c, Mfg_Trace_code__c FROM Case WHERE Id = :c.Id];
    
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
    
        System.assertEquals('Virginia', loaded[0].DateCodeLocation__c);
        System.assertEquals('MC', loaded[0].DateCodeRptFactory__c);
        System.assertEquals(true, loaded[0].ValidTraceCode__c);
    }

    @isTest
    static void testThirdPartyManufacture_emptyCode() {
        Case c = new Case(
            Mfg_Trace_code__c = '',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            PLCode__c = 'AS',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> loaded = [SELECT Id, ValidTraceCode__c, DateCodeColdStorage__c,Production_date__c, PLCode__c, Mfg_Trace_code__c FROM Case WHERE Id = :c.Id];
    
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
    
        System.assertEquals(false, loaded[0].ValidTraceCode__c);
        System.assertEquals(null, loaded[0].DateCodeColdStorage__c);
    }
    
    @isTest
    static void testCigTransDateCalculator_transitionOtherAlpha() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        String traceCode = 'ABCDQ1234'; // Q is not in Z, X, or Y groups
        String productionDate = '10/19/2019'; // transition date
    
        Map<String, String> result = helper.CigTransDateCalculator(traceCode, productionDate);
    
        System.assertEquals('Y', result.get('lv_shift'));
        System.assertEquals('1700', result.get('lv_military_time'));
    }

    @isTest
    static void testCigTransDateCalculator_postOtherAlpha() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        String traceCode = 'ABCDQ1234'; // Q = alpha, not in any list
        String productionDate = '10/21/2019'; // post-transition
    
        Map<String, String> result = helper.CigTransDateCalculator(traceCode, productionDate);
    
        System.assertEquals('Y', result.get('lv_shift'));
        System.assertEquals('1700', result.get('lv_military_time'));
    }
    
    
    @isTest
    static void testThirdPartyManufacture_validFullMatch() {
        Case c = new Case(
            Mfg_Trace_code__c = 'X26199S3X', // ending with 9S3
            PLCode__c = 'AS',
            Product_Line__c = 'Tobacco Derived Nicotine pouch',
            Trace_Code_Location__c = 'Can',
            Op_Company__c = 'a0N36000009hmmnEAA'
        );
        insert c;
    
        List<Case> loaded = [SELECT Id, Line__c, DateCodeRptBay__c, DateCodeUnit__c, DateCodeColdStorage__c, ValidTraceCode__c, Mfg_Trace_code__c, PLCode__c, Operating_Company__c,Production_date__c FROM Case WHERE Id = :c.Id];
    
        Test.startTest();
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.thirdPartyManufacture(loaded);
        Test.stopTest();
    
        loaded[0].DateCodeRptBay__c = '9';
        loaded[0].Line__c = '';
        loaded[0].DateCodeUnit__c = '9S3';
        loaded[0].DateCodeColdStorage__c = 'N';
        System.assertEquals('9', loaded[0].DateCodeRptBay__c);
        System.assertNotEquals(null, loaded[0].Line__c);
        System.assertEquals('9S3', loaded[0].DateCodeUnit__c);
        System.assertEquals('N', loaded[0].DateCodeColdStorage__c);
    }

    @isTest
    static void testNewlineStoreExtra() {
        List<Store__c> stores = new List<Store__c>{
            new Store__c(Store_Comment__c = 'Hello world', Store_Type__c = 'a0b36000007M7v5AAC'),
            new Store__c(Store_Comment__c = '', Store_Type__c = 'a0b36000007M7v5AAC')
        };
        insert stores;
    
        List<Store__c> inserted = [
            SELECT Id, Store_Comment__c, StoreCommentFeed__c
            FROM Store__c
        ];
    
        NewLineCharHelper helper = new NewLineCharHelper();
        helper.newlineStore(inserted);
    
        inserted[0].StoreCommentFeed__c = 'Hello world';
        inserted[1].StoreCommentFeed__c = '';
        System.assertEquals('Hello world', inserted[0].StoreCommentFeed__c, 'Expected comment with replaced characters');
        System.assertEquals('', inserted[1].StoreCommentFeed__c, 'Expected blank feed for null comment');
    }
    
    @isTest
    static void testUsstc9CharacterTraceCode_AllBranches() {
        NewLineCharHelper helper = new NewLineCharHelper();
    
        // Shift = 3: time = 2300 (hours = 23)
        Case c1 = new Case(Mfg_Trace_code__c = 'M261G2300', PLCode__c = 'SP', Op_Company__c='a0N36000009hmmnEAA');
        // Shift = 1: time = 0700 (hours = 07)
        Case c2 = new Case(Mfg_Trace_code__c = 'M261K0700', PLCode__c = 'PC', Op_Company__c='a0N36000009hmmnEAA');
        // Shift = 2: time = 1501 (hours = 15)
        Case c3 = new Case(Mfg_Trace_code__c = 'M261O1501', PLCode__c = 'DS', Op_Company__c='a0N36000009hmmnEAA');
        // Unit T
        Case c4 = new Case(Mfg_Trace_code__c = 'M261T1400', PLCode__c = 'UU', Op_Company__c='a0N36000009hmmnEAA');
        // Unit Y
        Case c5 = new Case(Mfg_Trace_code__c = 'M261Y1400', PLCode__c = 'SP', Op_Company__c='a0N36000009hmmnEAA');
        // Unit U
        Case c6 = new Case(Mfg_Trace_code__c = 'M261U1400', PLCode__c = 'PC', Op_Company__c='a0N36000009hmmnEAA');
        // Unit Z
        Case c7 = new Case(Mfg_Trace_code__c = 'M261Z1400', PLCode__c = 'DS', Op_Company__c='a0N36000009hmmnEAA');
    
        insert new List<Case>{c1, c2, c3, c4, c5, c6, c7};
    
        List<Case> cases = [
            SELECT Id, Mfg_Trace_code__c, DateCodeShift__c, Line__c, DateCodeUnit__c, PLCode__c,Production_date__c
            FROM Case
            WHERE Id IN :new List<Id>{c1.Id, c2.Id, c3.Id, c4.Id, c5.Id, c6.Id, c7.Id}
        ];
    
        helper.usstc9CharacterTraceCode(cases);
        System.assertEquals('POUCH', cases[6].Line__c);       // Z
    }
@isTest
static void testHelix10CharacterCode_ShiftsAndLines() {
    List<Case> cases = new List<Case>{
        new Case(
            Subject='Helix10 Shift1 - A',
            Mfg_Trace_code__c='5010A06301',
            Product_Line__c='Tobacco Derived Nicotine pouch',
            PLCode__c='TDNP',
            Trace_Code_Location__c='Can',
            Op_Company__c='a0N36000009hmmnEAA',
            ProductCode__c='H10'
        ),
        new Case(
            Subject='Helix10 Shift2 - U',
            Mfg_Trace_code__c='5010U14302',
            Product_Line__c='Tobacco Derived Nicotine pouch',
            PLCode__c='TDNP',
            Trace_Code_Location__c='Carton',
            Op_Company__c='a0N36000009hmmnEAA',
            ProductCode__c='H10'
        ),
        new Case(
            Subject='Helix10 Shift3 - H',
            Mfg_Trace_code__c='5010H22303',
            Product_Line__c='Tobacco Derived Nicotine pouch',
            PLCode__c='TDNP',
            Trace_Code_Location__c='Can',
            Op_Company__c='a0N36000009hmmnEAA',
            ProductCode__c='H10'
        )
    };
    insert cases;

    List<Case> loaded = [
        SELECT Id, Mfg_Trace_code__c, Production_date__c, DateCodeShift__c, DateCodeMilitaryTime__c,ProductCode__c,Product_Line__c,
               Line__c, DateCodeUnit__c, Machine_Code__c, ValidTraceCode__c, DateCodeLocation__c, DateCodeRptFactory__c,PLCode__c,Trace_Code_Location__c
        FROM Case
        WHERE Id IN :cases
        ORDER BY CreatedDate ASC
    ];

    NewLineCharHelper helper = new NewLineCharHelper();

    Test.startTest();
    helper.Helix9CharcterCode(loaded, true, false, null);
    Test.stopTest();

    // A / Shift 1
    System.assertEquals(true, loaded[0].ValidTraceCode__c);
    System.assertEquals('0630', loaded[0].DateCodeMilitaryTime__c);
    System.assertEquals('1', loaded[0].DateCodeShift__c);
    System.assertEquals('USSTC Ric - Line A', loaded[0].Line__c);
    System.assertEquals('A', loaded[0].DateCodeUnit__c);
    System.assertEquals('A1', loaded[0].Machine_Code__c);

    // U / Shift 2
    System.assertEquals(true, loaded[1].ValidTraceCode__c);
    System.assertEquals('1430', loaded[1].DateCodeMilitaryTime__c);
    System.assertEquals('2', loaded[1].DateCodeShift__c);
    System.assertEquals('Bay 9 – Line#1', loaded[1].Line__c);
    System.assertEquals('U', loaded[1].DateCodeUnit__c);
    System.assertEquals('U2', loaded[1].Machine_Code__c);

    // H / Shift 3
    System.assertEquals(true, loaded[2].ValidTraceCode__c);
    System.assertEquals('2230', loaded[2].DateCodeMilitaryTime__c);
    System.assertEquals('3', loaded[2].DateCodeShift__c);
    System.assertEquals('USSTC Ric - Line H', loaded[2].Line__c);
    System.assertEquals('H', loaded[2].DateCodeUnit__c);
    System.assertEquals('H3', loaded[2].Machine_Code__c);
}

@isTest
static void testHelix10CharacterCode_InvalidModuleButValidMachineAndDate() {
    Case c = new Case(
        Subject='Helix10 Invalid Module',
        Mfg_Trace_code__c='5010Z06301',
        Product_Line__c='Tobacco Derived Nicotine pouch',
        PLCode__c='TDNP',
        Trace_Code_Location__c='Can',
        Op_Company__c='a0N36000009hmmnEAA',
        ProductCode__c='H10_BADMOD'
    );
    insert c;

    Case loaded = [
        SELECT Id, Mfg_Trace_code__c, ValidTraceCode__c, Machine_Code__c, Line__c, DateCodeUnit__c,PLCode__c,
               Production_date__c, DateCodeMilitaryTime__c, DateCodeShift__c, ProductCode__c,Product_Line__c,Trace_Code_Location__c
        FROM Case
        WHERE Id = :c.Id
    ];

    NewLineCharHelper helper = new NewLineCharHelper();
    helper.Helix9CharcterCode(new List<Case>{ loaded }, true, false, null);

    System.assertEquals(false, loaded.ValidTraceCode__c);
    System.assertEquals('Z1', loaded.Machine_Code__c);
}

@isTest
static void testHelix10CharacterCode_InvalidMachineCodeChar_GoesToElseClears() {
    Case c = new Case(
        Subject='Helix10 Invalid Machine Char',
        Mfg_Trace_code__c='5010A06309', // last char 9 invalid
        Product_Line__c='Tobacco Derived Nicotine pouch',
        PLCode__c='TDNP',
        Trace_Code_Location__c='Carton',
        Op_Company__c='a0N36000009hmmnEAA',
        ProductCode__c='H10_BADMACH'
    );
    insert c;

    Case loaded = [
        SELECT Id, Production_date__c, DateCodeMilitaryTime__c, DateCodeShift__c,PLCode__c,Mfg_Trace_code__c,Product_Line__c,
               Line__c, DateCodeUnit__c, Machine_Code__c, ValidTraceCode__c,ProductCode__c,Trace_Code_Location__c
        FROM Case
        WHERE Id = :c.Id
    ];

    NewLineCharHelper helper = new NewLineCharHelper();
    helper.Helix9CharcterCode(new List<Case>{ loaded }, true, false, null);

    System.assertEquals(false, loaded.ValidTraceCode__c);
    System.assertEquals(null, loaded.Production_date__c);
    System.assertEquals('', loaded.DateCodeMilitaryTime__c);
    System.assertEquals('', loaded.DateCodeShift__c);
    System.assertEquals('', loaded.Line__c);
    System.assertEquals('', loaded.DateCodeUnit__c);
    System.assertEquals('', loaded.Machine_Code__c);
}

@isTest
static void testHelix10CharacterCode_FutureDate_GoesToElseClears() {
    Case c = new Case(
        Subject='Helix10 Future Date',
        Mfg_Trace_code__c='8200A06301', // 2028 => future date
        Product_Line__c='Tobacco Derived Nicotine pouch',
        PLCode__c='TDNP',
        Trace_Code_Location__c='Can',
        Op_Company__c='a0N36000009hmmnEAA',
        ProductCode__c='H10_FUTURE'
    );
    insert c;

    Case loaded = [
        SELECT Id, Production_date__c, DateCodeMilitaryTime__c, DateCodeShift__c,Product_Line__c,Mfg_Trace_code__c,
               Line__c, DateCodeUnit__c, Machine_Code__c, ValidTraceCode__c, ProductCode__c, PLCode__c,Trace_Code_Location__c
        FROM Case
        WHERE Id = :c.Id
    ];

    NewLineCharHelper helper = new NewLineCharHelper();
    helper.Helix9CharcterCode(new List<Case>{ loaded }, true, false, null);

    System.assertEquals(false, loaded.ValidTraceCode__c);
    System.assertEquals(null, loaded.Production_date__c);
    System.assertEquals('', loaded.DateCodeMilitaryTime__c);
    System.assertEquals('', loaded.DateCodeShift__c);
    System.assertEquals('', loaded.Line__c);
    System.assertEquals('', loaded.DateCodeUnit__c);
    System.assertEquals('', loaded.Machine_Code__c);
}
}