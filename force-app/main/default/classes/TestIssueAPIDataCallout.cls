/************************************************************************ 
Author: Randolf Suplito
Date: 09/16/2022
Description: Test class for IssueAPIDataCallout class
*************************************************************************/

@isTest(SeeAllData=false)
public class TestIssueAPIDataCallout {
    
    @testSetup
    static void setup(){

        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        insert testAcc;
        
        Contact testConc = new Contact();
        testConc.AccountId = testAcc.Id;
        testConc.FirstName = 'Test Fname';
        testConc.LastName = 'Test Lname';
        testConc.AVF_GIID_Received__c = true;
        testConc.Zip_Code__c= '20001';
        testConc.Birthdate1__c = Date.newInstance(1989, 06, 14);
        testConc.Address_Verified__c = true;
        testConc.Verify_Address__c = true;
        testConc.Street_Address__c = 'Test Street';
        testConc.Apt_Lot__c = '76C';
        testConc.City__c = 'MCKEESPORT';
        testConc.State__c = 'PA';
        testConc.Active__c = true;
        insert testConc;
        
        Operating_Company__c testOpCo= new Operating_Company__c();
        testOpCo.OperatingCompany__c = 'PMUSA';
        testOpCo.OpCo_Description__c = 'PMUSA';
        testOpCo.Active__c = true;
        insert testOpCo;
        
        TFN__c testTFN= new TFN__c();
        testTFN.Operating_Company__c = testOpCo.id;
        testTFN.Toll_Free_Number__c = '1800';
        testTFN.DNIS__c = String.valueOf(45);
        insert testTFN;
        
        Transaction_Management__c testTM= new Transaction_Management__c();
        testTM.Operating_Company__c = testOpCo.Id;
        testTM.TFN__c = testTFN.id;
        insert testTM;
        
        Transaction_Management_History__c testTMH = new Transaction_Management_History__c();
        testTMH.Service_Group_Code__c = 'Consumer';
        testTMH.Service_Request_Code__c = 'CCNLOOKUP';
        insert testTMH;
        
        Classification__c c = new Classification__c();
        c.Description__c = 'Test Classification';
        insert c;
        
        Issue_Type__c it = new Issue_Type__c();
        it.Description__c = 'Test Issue type';
        insert it;
        
        Reason__c r = new Reason__c();
        r.Description__c = 'Test Reason';
        insert r;
        
        Product_Line__c pl = new Product_Line__c();
        pl.Name = 'Cigarettes';
        pl.Code__c = 'AS';
        pl.Op_Company__c = testOpCo.Id;
        pl.isActive__c = true;
        insert pl;
        
        Cause__c cause = new Cause__c();
        cause.Description__c = 'Test Cause';
        insert cause;
        
        Group__c g = new Group__c();
        g.Description__c = 'Test Group';  
        insert g;
        
        Issue_Hierarchy__c testIH = new Issue_Hierarchy__c();
        testIH.Classification__c = c.Id;
        testIH.Issue_Type__c = it.Id;
        testIH.Reason__c = r.Id;
        testIH.Product_Line__c = pl.iD;
        testIH.Cause__c = cause.Id;
        testIH.Group__c = g.Id;
        testIH.Active__c = true;
        insert testIH;
        
        Brand__c b = new Brand__c();
        b.BrandCode__c = '171222-01';
        b.Code__c = '171222-01';
        b.Name = 'IQOS Brand 01';
        b.Description__c = 'IQOS Brand 01';
        b.Product_Line__c = pl.Id;
        b.Op_Company__c = testOpCo.Id;
        b.IsActive__c = true;
        insert b;
        
        Brand_Hierarchy__c testBH = new Brand_Hierarchy__c();
        testBH.Vantive_Id__c = '5731';
        testBH.Brand_Code__c = b.Id;
        testBH.Product_Line_Code__c = pl.Id;
        testBH.Short_Cut__c = '1570';
        testBH.Active__c = true;
        insert testBH;
        
        Case testCase = new Case();
        testCase.Account = testAcc;
        testCase.Purchase_Price__c = 1200; 
        testCase.ContactId = testConc.Id;
        testCase.Masterid__c = testTM.Id;
        testCase.Transaction__c = testTM.Id;
        testCase.Transaction_Management_History__c = testTMH.Id;
        testCase.Op_Company__c = testOpCo.Id;
        testCase.Issue_Hierarchy_Code__c = testIH.Id;
        testCase.Crc_Brand_Hierarchy_Code__c = testBH.Id;
        testCase.PLCode__c = 'AS';
        testCase.UPC_code__c = '281572';
        testCase.Taste__c = 'Lights';
        testCase.Length_Code__c = '100s';
        testCase.Packaging__c = 'Soft Pack';
        testCase.Flavor__c = 'Menthol';
        testCase.Filter__c = 'Filtered';
        testCase.Paper_Type__c = 'Non Banded Paper';
        testCase.Cut__c = 'Test Cut';
        testCase.Suspected_Counterfiet__c = false;
        testCase.Purchase_Type__c = 'Pack';
        testCase.Purchase_Date__c = Date.newInstance(2022, 09, 14);
        testCase.Incident_Date__c = Date.newInstance(2022, 09, 14);
        testCase.Expected_Type__c = 'Pack';
        testCase.Affected_Type__c = 'Pack';
        testCase.Mfg_Trace_code__c = 'V123X13B5';
        testCase.Production_date__c = Date.newInstance(2021, 05, 03);
        testCase.Primary_Crc_Issue_Detail_Id__c = 'Test Primary_Crc_Issue_Detail_Id__c';
        testCase.DateCodeProductionDate__c = '5/3/2021';
        testCase.DateCodeLocation__c = 'Virginia';
        testCase.DateCodeShift__c = 'X';
        testCase.DateCodeUnit__c = '3B5';
        testCase.DateCodeColdStorage__c = 'N';
        testCase.DateCodeRptBay__c = '3';
        testCase.DateCodeRptFactory__c = 'MC';
        testCase.DateCodeMilitaryTime__c = 'Test DCMT';
        testCase.ValidTraceCode__c = true;
        testCase.Date_Code__c = 'Test DC';
        testCase.Date_Type__c = 'Test DT';
        testCase.Date__c = Date.newInstance(2022, 09, 15);
        testCase.ValidUstdateCode__c = false;
        testCase.Suspected_Tampering__c = false;
        testCase.Related_Issue__c = '03258793';
        testCase.Machine_Code__c = 'Test MC';
        testCase.ContactType__c = 'ISSUE ENTRY';
        testCase.ThirdPartyContacted__c = false;
        testCase.Inventory_Depleted__c = false;
        testCase.Trace_Code_Location__c = 'PAC';
        testCase.Caller_Name__c = 'Test CN';
        testCase.Supplier_Name__c = 'Test SN';
        testCase.Consumer_Return__c = false;
        testCase.CommentFeed__c = 'Test Comment';
        testCase.UpdateReasonFeed__c = 'Test URF';
        testCase.ConsumerReturnNotesFeed__c = 'Test CRNF';
        testCase.Consumer_Mentions__c = 'Switching to a competitor';
        testCase.Purchase_Price__c = 10;
        testCase.PurchaseQty__c = 1;
        testCase.ExpectedQty__c = 0;
        testCase.AffectedQty__c = 1;
        testCase.AffectedQty__c = 1;
        testCase.Overage__c = 'Test OA';
        testCase.Overage__c = 'Test OA';
        testCase.Product_Line__c = 'Cigarettes';
        testCase.Channel_Contact__c = 'Telephone Inbound';
        testCase.ProdrReturnReq__c = false;
        testCase.Outbound_Tracking__c = 'Test OT';
        testCase.Inbound_Tracking__c = 'Test IT';
        testCase.NMI_Transaction_ID__c = 'Test NMITI';
        testCase.IQOS_Reference_ID__c = 'Test IQOSRI';
        testCase.Serial_Number__c = 'Test SN';
        testCase.Warranty_Start_Date__c = Date.newInstance(2022, 09, 15);
        testCase.Warranty_Expiration_Date__c = Date.newInstance(2023, 09, 15);
        testCase.Warranty_Status__c = 'Test WS';
        testCase.CEA_Agent_ID__c = 'Test CEAAI';
        testCase.Complaint_Source__c = 'Alorica';
        testCase.Test_Issue__c = false;
        testCase.CounterfeitCodeLookup__c = '0';
        testCase.Line__c = 'B5';
        testCase.UCID__c = testConc.CustomerId__c;
        insert testCase;
        
        Store_type__c testStoty = new Store_type__c();
        testStoty.Description__c= 'Other';
        insert testStoty;
        
        Store__c testSto = new Store__c();
        testSto.Store_Type__c= testStoty.Id;
        testSto.Store_Name__c= 'WallMart';
        testSto.Issue__c = testCase.Id;
        testSto.Store_Address1__c = '1710 TRIMBLE AVENUE';
        testSto.Store_Address2__c = '32ND STREET';
        testSto.Store_City__c = 'MCKEESPORT';
        testSto.Store_State__c = 'PA';
        testSto.Store_Zip__c = '15133';
        testSto.Store_Comment__c = 'Test Store';
        insert testSto;
        
        Answer__c testAns= new Answer__c();
        testAns.Answer__c = 'Answer';
        insert testAns;
        
        Question__c testQuest= new Question__c();
        testQuest.Question__c = 'Test Question';
        testQuest.Type__c = 'TestType';
        insert testQuest;
        
        Survey__c testSurvey = new Survey__c();
        testSurvey.Survey_Name__c = 'Test Survey';
        testSurvey.EndDate__c = Date.today();
        testSurvey.SurveyIssueHierRequirements__c = 'APE';
        testSurvey.Section__c = true;
        insert testSurvey;
        
        List<Survey_Issue__c> surveyIssueList = new List<Survey_Issue__c>();
        
        Survey_Issue__c testSurvIssue1 = new Survey_Issue__c();
        testSurvIssue1.Issue__c = testCase.Id;
        testSurvIssue1.Answer__c = testAns.id;
        testSurvIssue1.Question__c = testQuest.id;
        testSurvIssue1.Survey__c = testSurvey.Id;
        testSurvIssue1.Transaction__c = testTM.Id;
        testSurvIssue1.Comment__c = 'Test Comment 1';
        testSurvIssue1.Question_Sequence__c = 1;
        testSurvIssue1.Answer_Sequence__c = 1;
        surveyIssueList.add(testSurvIssue1);
        
        Survey_Issue__c testSurvIssue2 = new Survey_Issue__c();
        testSurvIssue2.Issue__c = testCase.Id;
        testSurvIssue2.Answer__c = testAns.id;
        testSurvIssue2.Question__c = testQuest.id;
        testSurvIssue2.Survey__c = testSurvey.Id;
        testSurvIssue2.Transaction__c = testTM.Id;
        testSurvIssue2.Comment__c = 'Test Comment 2';
        testSurvIssue2.Question_Sequence__c = 1;
        testSurvIssue2.Answer_Sequence__c = 1;
        surveyIssueList.add(testSurvIssue2);
        
        insert surveyIssueList;
        
        Reimbursement__c testReimb = new Reimbursement__c();
        testReimb.Issue__c = testCase.Id;
        testReimb.Consumer__c = testConc.Id;
        testReimb.TransactionId__c = testTM.Id;
        testReimb.Transaction_Management_History__c = testTMH.Id;
        testReimb.BrandCode__c = '04';
        testReimb.Coupon_Qty__c = '0';
        testReimb.Cheque_Amount__c = 4852.0;
        testReimb.PackageCode__c = 'CHKPAM';
        testReimb.Reimbursement_Type__c = 'Plastic';
        testReimb.FulfillDate__c = Date.newInstance(2022, 09, 16);
        testReimb.ReshipDate__c = Date.newInstance(2022, 09, 20);
        testReimb.ExtractDate__c = Date.newInstance(2022, 09, 16);
        testReimb.Status__c = 'Age Not Verified';
        insert testReimb;
        
        Attachment_Detail__c testAttDetail = new Attachment_Detail__c();
        testAttDetail.Issue__c = testCase.Id;
        testAttDetail.Description__c = 'Product Photo_2';
        testAttDetail.File_Type__c = 'jpg';
        insert testAttDetail;
    }
    
    private class APIDataCalloutServicesMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('token')) {
                HTTPResponse res = new HTTPResponse();
               	res.setHeader('Content-Type', 'application/json');
                res.setBody('{"token_type": "Bearer","expires_in": 3599,"ext_expires_in": 3599,"access_token": "tokenTest101"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('MasterData')) {
                HTTPResponse res = new HTTPResponse();
               	res.setHeader('Content-Type', 'application/json');
                res.setBody('{"code": 0,"message": "Staging to Final load Completed Successfully","controlId": 101,"stagingFailedObjects": "","finalFailedObjects": ""}');
                res.setStatusCode(200);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }
    
    static testmethod void testCreateCallout() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APIDataCalloutServicesMock());
        
        Case caseRec = [SELECT Id, IsReviewed__c FROM Case];
        caseRec.IsReviewed__c = true;
        update caseRec;
        Test.stopTest();

    }
}