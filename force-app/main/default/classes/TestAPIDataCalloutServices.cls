/************************************************************************ 
Author: Randolf Suplito
Date: 08/18/2022
Description: This test class is for APIDataCalloutServices and also for each object handler calling the APIDataCalloutServices
*************************************************************************/

@isTest(SeeAllData=false)
public class TestAPIDataCalloutServices {
    
    @testSetup
    static void setup(){
        
        //Classification
        Classification__c c = new Classification__c();
        c.Description__c = 'Select APE';
        insert c;
        
        //Issue Type
        Issue_Type__c it = new Issue_Type__c();
        it.Description__c = 'Complaints';
        insert it;
        
        //Reason
        Reason__c r = new Reason__c();
        r.Description__c = 'NPRM Product Contact';
        insert r;
        
        //Cause
        Cause__c cause = new Cause__c();
        cause.Description__c = 'NPRM Product Contact';
        insert cause;
        
        //Group
        Group__c g = new Group__c();
        g.Description__c = 'NPRM';  
        insert g;
        
        //Operating Company
        Operating_Company__c oc = new Operating_Company__c();
        oc.OperatingCompany__c = 'PMIP';
        oc.OpCo_Description__c = 'test';
        oc.Active__c = true;
        insert oc;
    }
    

    private class APIDataCalloutServicesMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('token')) {
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"token_type": "Bearer","expires_in": 3599,"ext_expires_in": 3599,"access_token": "tokenTest101"}');
                res.setStatusCode(200);
                req.setTimeout(120000);
                // RITM3167644 - 2024-08-25
                req.setClientCertificateName('FEED_API_2024_08_25');
                return res;
            } else if (req.getEndpoint().endsWith('MasterData')) {
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"code": 0,"message": "Staging to Final load Completed Successfully","controlId": 101,"stagingFailedObjects": "","finalFailedObjects": ""}');
                res.setStatusCode(200);
                req.setTimeout(120000);
                // RITM3167644 - 2024-08-25
                req.setClientCertificateName('FEED_API_2024_08_25');
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }
    
    static testmethod void testCustomerTypeAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Customer_Type__c testCustType = new Customer_Type__c();
        testCustType.CodeType__c = 'CUSTOMERS';
        testCustType.Customer_Type__c = 'W';
        testCustType.Description__c = 'WHOLESALER';
        testCustType.IsActive__c = true;
        insert testCustType;
        Test.stopTest();
    }
    
        static testmethod void testProductLineAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Product_Line__c testProdLine = new Product_Line__c();
        testProdLine.Code__c = 'IQOS3.0';
        testProdLine.IsActive__c = true;
        insert testProdLine;
        Test.stopTest();
    }
    
    
    
    static testmethod void testUserAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        List<User> userinfo = [SELECT Id, Name, CreatedDateTime__c FROM User WHERE Profile.Name = 'SSO System Admin'];
        userinfo[0].CommunityNickname = 'user0001';
        userinfo[0].EmployeeNumber = 'user0001';
        userinfo[0].Location__c = 'External';
        userinfo[0].PBX_ID__c = 'PBX001';
        update userinfo;
        Test.stopTest();
    }
    
    static testmethod void testStoreTypeAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Store_Type__c testStoreType = new Store_Type__c();
        testStoreType.Description__c = 'EMPLOYEE DISPENSING MACHINE';
        testStoreType.Display_Description__c = 'EMPLOYEE DISPENSING MACHINE';
        insert testStoreType;
        Test.stopTest();
    }


    static testmethod void testBrandHierarchyAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Operating_Company__c oc = [SELECT Id FROM Operating_Company__c LIMIT 1];
        Product_Line__c testProductLine = new Product_Line__c();
        testProductLine.Code__c = 'SNP';
        testProductLine.Name = 'SYNTHETIC NICOTINE POUCH';
        testProductLine.isActive__c = true;
        testProductLine.Op_Company__c = oc.Id;
        insert testProductLine;
        
        Brand__c testBrand = new Brand__c();
        testBrand.Code__c = '171222-01';
        testBrand.BrandCode__c = '171222-01';
        testBrand.Description__c = 'IQOS Brand 01';
        testBrand.Op_Company__c = oc.Id;
        testBrand.CRC_Operating_Company__c = 'PMIP';
        testBrand.Product_Line__c = testProductLine.Id;
        testBrand.IsActive__c = true;
        testBrand.Name = 'IQOS Brand 01';
        testBrand.USTDateType__c = 'Test USTDateType';
        testBrand.BrandFamily__c = 'Test BrandFamily';
        insert testBrand;
        
        Brand_Hierarchy__c testBH= new Brand_Hierarchy__c();
        testBH.UPC__c = '7310003211';
        testBH.Taste__c = 'Full Flavor';
        testBH.Length__c = '100s';
        testBH.Packaging__c = 'Soft Pack';
        testBH.Flavor__c = 'Menthol';
        testBH.Filter__c = 'Filtered';
        testBH.PaperType__c = 'Banded Paper Ny';
        testBH.Cut__c = 'Ready';
        testBH.Ust_Date_Type__c = 'SB';
        testBH.Pm_Brand_Code__c = 'G3222100000';
        testBH.Short_Cut__c = 'CLC-MT-FS';
        testBH.Brand_Sas_Code__c = 'TestBrandSasCode';
        testBH.Brand_MM_Code__c = 'TestBrandMMCode';
        testBH.Product_Desc__c = 'COPENHAGEN LONG CUT MINT FREE SAMPLE';
        testBH.Product_Type__c = 'SMOKELESS - DOMESTIC';
        testBH.Price_Category__c = 'TIER L';
        testBH.License_Group__c = 'USSTC';
        testBH.Brand_Status__c = 'ACTIVE';
        testBH.Brand_Classification__c = 'BRAND';
        testBH.Pack_Type__c = 'TestPack';
        testBH.Reporting_Brand_Family__c = 'COPENHAGEN';
        testBH.Reporting_Brand_Family__c = 'COPENHAGEN';
        testBH.Vantive_Id__c = 'testVan';
        testBH.Units_Per_Pack__c = 1;
        testBH.Pick_Up_Policy_Weeks__c = 20;
        testBH.Active__c = true;
        testBH.Brand_Code__c = testBrand.id;
        testBH.Product_Line_Code__c = testProductLine.id;
        insert testBH;
        Test.stopTest();
    }
    
    static testmethod void testIssueHierarchyAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Operating_Company__c oc = [SELECT Id FROM Operating_Company__c LIMIT 1];
        Product_Line__c testProductLine = new Product_Line__c();
        testProductLine.Code__c = 'SNP';
        testProductLine.Name = 'SYNTHETIC NICOTINE POUCH';
        testProductLine.isActive__c = true;
        testProductLine.Op_Company__c = oc.Id;
        insert testProductLine;
        
        Classification__c c = [SELECT Id FROM Classification__c LIMIT 1];
        Issue_Type__c it = [SELECT Id FROM Issue_Type__c LIMIT 1];
        Reason__c r = [SELECT Id FROM Reason__c LIMIT 1];
        Cause__c cause = [SELECT Id FROM Cause__c LIMIT 1];
        Group__c g = [SELECT Id FROM Group__c LIMIT 1];
        
        Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();
        testIH.Classification__c = c.Id;
        testIH.Product_Line__c = testProductLine.Id;
        testIH.Issue_Type__c = it.Id;
        testIH.Group__c = g.Id;
        testIH.Reason__c = r.Id;
        testIH.Cause__c = cause.Id;
        testIH.Cust_Cons_Flag__c = 'ALL';
        testIH.RptCategory__c = 'POUCH';
        testIH.Escalate_Flag__c = true;
        testIH.Issue_Association__c = 'testIA';
        testIH.Issue_Rollup__c = 'POUCH LEAKING';
        testIH.Factory_Controllable_Flag__c = true;
        testIH.Pqrb_Rtp_Category__c = 'PRODUCT';
        testIH.Visible__c = true;
        testIH.Select__c = false;
        testIH.Product_Return_Level__c = '1';
        testIH.Alert_Distribution__c = '0';
        testIH.Alcs_Investigation_Level__c = '0';
        testIH.Manf_Investigation_Level__c = '1';
        testIH.Threshold_With_Manf_Info__c = '99';
        testIH.Threshold_With_Prod_Desc_Only__c = '99';
        testIH.Survey_Requirements__c = 'testSurvey';
        testIH.CauseId__c = '1701252';
        testIH.Active__c = true;
        testIH.SUBJECT_CODE__c = 'SU001';
        testIH.SUBJECT_DESC__c = 'TestSUBDESC';
        insert testIH;
        Test.stopTest();
    }
    
    static testmethod void testSurveyConfigAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Answer__c testAnswer= new Answer__c();
        testAnswer.Answer__c = 'IQOS 3.0';
        testAnswer.Active__c = true;
        testAnswer.PMAnswerID__c = 20181002;
        insert testAnswer;
        
        Survey__c testSurvey = new Survey__c();
        testSurvey.Survey_Name__c = 'IQOS APE';
        testSurvey.Start_Date__c = Date.today();
        testSurvey.EndDate__c = Date.today();
        testSurvey.Priority__c = 1;
        testSurvey.Required__c = true;
        insert testSurvey;
        
        Question__c testQuestion1 = new Question__c();
        testQuestion1.Question__c = 'What was the device used and version?';
        testQuestion1.PMQuestionID__c = 30181001;
        testQuestion1.Active__c = true;
        testQuestion1.Type__c = 'Multiple Choice';
        testQuestion1.QuestionToCheck__c = 'Question to check 1';
        insert testQuestion1;
        
        Question__c testQuestion2 = new Question__c();
        testQuestion2.Question__c = 'Test Question 2';
        testQuestion2.PMQuestionID__c = 30181002;
        testQuestion2.Active__c = true;
        testQuestion2.Type__c = 'Multiple Choice';
        testQuestion1.QuestionToCheck__c = 'Question to check 2';
        insert testQuestion2;
        
        
        Survey_Configuration__c testSurveyConfig=new Survey_Configuration__c();
        testSurveyConfig.Survey__c=testSurvey.id;
        testSurveyConfig.QuestionFrom__c=testQuestion1.id;
        testSurveyConfig.Question_Sequence__c=16;
        testSurveyConfig.Question_Required__c = true;
        testSurveyConfig.Answer__c=testAnswer.id;
        testSurveyConfig.Answer_Sequence__c = 2;
        testSurveyConfig.CommentRequired__c = false;
        testSurveyConfig.QuestionTo__c=testQuestion2.id;
        insert testSurveyConfig;
        Test.stopTest();
    }
    
    static testmethod void testCounterFeitTCAPICallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        CounterfeitTraceCode__c testCounterFeit = new CounterfeitTraceCode__c();
        testCounterFeit.Type__c = 'Domestic';
        testCounterFeit.MFGBrand__c = 'ALPINE UKNTAR MENTHOL UKNLEN UKNPACK';
        testCounterFeit.Trace_Code__c = 'V315X91A5';
        testCounterFeit.Production_Date__c = date.Today().addDays(7);
        testCounterFeit.Source__c = 'test source';
        testCounterFeit.SourceCity__c = 'test sourcecity';
        testCounterFeit.SourceState__c = 'test sourcestate';
        testCounterFeit.SourceState__c = 'TS';
        testCounterFeit.SourceDateDetected__c = date.Today();
        testCounterFeit.Remarks__c = 'test remarks';
        testCounterFeit.IsActive__c =  true;
        insert testCounterFeit;
        Test.stopTest();
    }
    
    
    //RITM2618173 2023-03-13-23-00
    static testMethod void jsonAuthDTOTest() {
        Test.startTest();
        APIDataCalloutServices.jsonAuthDTO jsonAuthDTORec = new APIDataCalloutServices.jsonAuthDTO();
        jsonAuthDTORec.token_type = 'Bearer';
        jsonAuthDTORec.expires_in = 3599;
        jsonAuthDTORec.ext_expires_in = 3599;
        jsonAuthDTORec.access_token = 'tokenTest101';
        Test.stopTest();
    }
    
    //RITM2618173 2023-03-16-01-10
    static testMethod void responseDTOTest() {
        APIDataCalloutServices.responseDTO responseDTORec = new APIDataCalloutServices.responseDTO();
        responseDTORec.statusCode = '200';
        responseDTORec.code = 0;
        responseDTORec.message = 'Staging to Final load Completed Successfully';
        responseDTORec.controlId = 101;
        responseDTORec.stagingFailedObjects = '';
        responseDTORec.finalFailedObjects = '';
    }


}