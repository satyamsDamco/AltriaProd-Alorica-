public class TestDataSetup{
    
    public static Case testCase;
    public static Case testIssue;
    public static Reimbursement__c testReimb;
    public static Account testAcc;
    public static Contact testConc;
    public static Store__c testSto;
    public static Store_type__c testStoty;
    public static Store_List__c testStoLst;
    //public static Transaction_Management__c testTM;
    //public static Operating_Company__c testOpCo;
    public static Classification__c testClsfy;
    public static Product_Line__c testPL;
    public static Issue_Type__c testIT;
    public static Group__c testGroup;
    public static Cause__c testCause;
    public static Reason__c testRsn;
    public static Brand__c testBrand;
    public static Issue_Hierarchy__c testIH;
    public static Brand_Hierarchy__c testBH;
    public static Age_Mapping__c testagemap;
    public static LexisNexisClasses lexisNexis;
    //public static TFN__c testTFN;
    public static Attachment attachment;
    public static DocumentType__c testDoc;
    public static Correspondence_Fulfilment__c testCor;
    public static Customer_Type__c testCustType;
    public static Question__c testQuest;
    public static Answer__c testAns;
    public static Survey__c testSurvey;
    public static Survey_Issue__c testSurvIssue;
    public static Issue_Adjustment__c testIssueAdjust;
    public static Attachment_Detail__c attachmentDet;
    public static Survey_Configuration__c surveyConfig;
    
    //creating Survey Configuration record
    public static Survey_Configuration__c createSurveyConfig(Survey__c sur,Question__c quest,Answer__c ans, Question__c quest1) {
        surveyConfig=new Survey_Configuration__c();
        surveyConfig.Answer__c=ans.id;
        surveyConfig.Survey__c=sur.id;
        surveyConfig.QuestionFrom__c=quest.id;
        surveyConfig.QuestionTo__c=quest1.id;
        surveyConfig.Active__c=true;
        return surveyConfig;
    }
    
    // creating attachment record
    public static Attachment createAttachment (string description, string name,id ParentId, blob body)  {
      attachment=new Attachment();
      attachment.description=description;
      attachment.name=name;
      attachment.ParentId=ParentId;
      attachment.Body=Body;
      //attachment.filename=filename;
      return attachment;
     }
    // creating Attachment detail record
    public static Attachment_Detail__c createAttachmentDet(String describe, String name, Case issue, String attach){
      attachmentDet=new Attachment_Detail__c();
      attachmentDet.Description__c = describe;
      attachmentDet.File_Name__c = name;
      attachmentDet.Issue__c = issue.id;
      attachmentDet.AttachmentId__c = attach;
      return attachmentDet;
     }
    // creating AgeMapping record
     public static Age_Mapping__c createAgeMapping(string name, integer age, string zip, boolean active)
     {
         testagemap=new Age_Mapping__c ();
         testagemap.Name=name;
         testagemap.Age__c=age;
         testagemap.Zip__c=zip;
         testagemap.Active__c = active;
         return testagemap;
     }
     // creating  Account record
    public static Account createAccount(string accName){
        testAcc = new Account();
        testAcc.Name = accName;
        return testAcc;
    }
     // creating TestCase record
    
    public static Case createTestCase(Account acc, Decimal price,Id contactId, Id masterId,Id op){
        testCase = new Case();
        testCase.Account = acc;
        testCase.Purchase_Price__c = price; 
        testCase.ContactId = contactId;
        testCase.Masterid__c = masterId;
        testCase.Op_Company__c = op;
        return testCase;
    }
    
    //Creating TestCase record with IH & BH
    public static Case createTestIssue(Account acc, Decimal price,Id contactId, Id masterId,Id op,Brand_Hierarchy__c bh ,Issue_Hierarchy__c ih,Product_Line__c pl){
        testIssue = new Case();
        testIssue.Account = acc;
        testIssue.Purchase_Price__c = price; 
        testIssue.ContactId = contactId;
        testIssue.MasterId__c = masterId;
        testIssue.Op_Company__c = op;
        testIssue.Crc_Brand_Hierarchy_Code__c=bh.Id;
        testIssue.Issue_Hierarchy_Code__c=ih.Id;
        testIssue.Product_Line_Code__c=pl.Id;
        testIssue.Comment__c='test';
        
        return testIssue;
    }
    // creating Reimbursement record
    public static Reimbursement__c createReimbursement(Case testCase1, decimal checkPrice){
        testReimb = new Reimbursement__c();
        testReimb.Issue__c = testCase1.id;
        testReimb.Cheque_Amount__c = checkPrice;
        testReimb.Status__c='Age Not Verified';
        for (Schema.PicklistEntry pe :
     Reimbursement__c.Reimbursement_Type__c
        .getDescribe()
        .getPicklistValues()) {

    if (pe.isActive()) {
        testReimb.Reimbursement_Type__c = pe.getValue();
        break;
    }
}
        return testReimb;
    }
    // creating Contact record
    public static Contact createContact(string name, Id acc,boolean ageverified){
        testConc = new Contact();
        testConc.AccountId = acc;
        testConc.LastName = name;
        testConc.AVF_GIID_Received__c = ageverified;
        
        return testConc;
    }
    //Creating Customer type record
    public static Customer_Type__c createCustType(string custType, String codeType, boolean active, String Descrp){
        testCustType = new Customer_Type__c();
        testCustType.Customer_Type__c = custType;
        testCustType.CodeType__c = codeType;
        testCustType.IsActive__c = active;
        testCustType.Description__c = Descrp;
        return testCustType;
    }
    // creating Contact record
    public static Contact createContact(string fname, string lname, Id acc,boolean ageverified,string Zip,Date birthday, String streetAddr, boolean addrVerified, boolean verifyAddr){//, String mobPhone, String phone, String otherPhone, String streetAddr, String country){
        testConc = new Contact();
        testConc.AccountId = acc;
        testConc.FirstName = fname;
        testConc.LastName = lname;
        testConc.AVF_GIID_Received__c = ageverified;
        testConc.Zip_Code__c= Zip;
        testConc.Birthdate1__c = birthday;
        testConc.Address_Verified__c = addrVerified;
        testConc.Verify_Address__c = verifyAddr;
        testConc.Street_Address__c = streetAddr;
        /*testConc.MobilePhone = mobPhone;
        testConc.Phone = phone;
        testConc.OtherPhone = otherPhone;
        testConc.Country__c = country;*/
        return testConc;
    }
    
    public static Contact createContact1(string fname, string lname, Id acc,boolean ageverified,string Zip,Date birthday, String streetAddr, boolean addrVerified, boolean verifyAddr){//, String mobPhone, String phone, String otherPhone, String streetAddr, String country){
        testConc = new Contact();
        testConc.AccountId = acc;
        testConc.FirstName = fname;
        testConc.LastName = lname;
        testConc.AVF_GIID_Received__c = ageverified;
        testConc.Zip_Code__c= Zip;
        testConc.Birthdate1__c = birthday;
        testConc.Address_Verified__c = addrVerified;
        testConc.Verify_Address__c = verifyAddr;
        testConc.Street_Address__c = streetAddr;
        /*testConc.MobilePhone = mobPhone;
        testConc.Phone = phone;
        testConc.OtherPhone = otherPhone;
        testConc.Country__c = country;*/
        return testConc;
    }
    // creating StoreList record
     public static Store_List__c createStoreList(string strlistname){
        testStoLst= new Store_List__c ();
        testStoLst.Name= strlistname;
        return testStoLst;
    }
     // creating StoreType record
    public static Store_type__c createStoreType(string strcode, string strdes){
        testStoty = new Store_type__c();
        //testStoty.Name= strcode;
        testStoty.Description__c= strdes;
        return testStoty;
    }
     // creating Store record
    public static Store__c createStore(string strname, Store_type__c strtype){
        testSto = new Store__c();
        testSto.Store_Type__c= strtype.Id;
        testSto.Store_Name__c= strname;
        return testSto;
    }
     // creating operatingcompany record
    public static Operating_Company__c createOpCo(string channel, string description, string direction, string opCo, boolean trade){
        Operating_Company__c testOpCo= new Operating_Company__c();
        testOpCo.OperatingCompany__c = opCo;
        testOpCo.OpCo_Description__c = opCo;
        testOpCo.Active__c = true;
        //testOpCo.Default_TFN__c = tfn.id;
        return testOpCo;
    }
    // creating TFN record
    public static TFN__c createTFN(boolean active, String tfnumber, Integer dnis, Operating_Company__c opCo){
        TFN__c testTFN= new TFN__c();
        testTFN.Operating_Company__c = opCo.id;
        testTFN.Toll_Free_Number__c = tfnumber;
        testTFN.DNIS__c = String.valueOf(dnis);
        return testTFN;
    }
    // creating Transaction Management record
     public static Transaction_Management__c  createTM(Operating_Company__c opCo, TFN__c tfn){
        Transaction_Management__c testTM= new Transaction_Management__c();
        testTM.Operating_Company__c = opCo.Id;
        testTM.TFN__c = tfn.id;
        return testTM;
    }
    
    // creating Transaction Management History record
     public static Transaction_Management_History__c  createTMHis(String serGrpCode, Transaction_Management__c tM, String serReqCode){
        Transaction_Management_History__c testTMHis= new Transaction_Management_History__c();
        testTMHis.Service_Group_Code__c = serGrpCode;
        testTMHis.Transaction_Management__c = tM.Id;
        testTMHis.Service_Request_Code__c = serReqCode;
        return testTMHis;
    }
    
    public static Service_Code_Mapping__c createSerCode(String serGrpCode, string serName){
        Service_Code_Mapping__c  testSerCode= new Service_Code_Mapping__c();
        testSerCode.Service_Group_Code__c = serGrpCode;
        testSerCode.Name = serName;
        return testSerCode;
    }
    
    
    // creating Classification  record
    public static Classification__c  createClassify(String describe){
        testClsfy= new Classification__c();
        testClsfy.Description__c = describe;
        return testClsfy;
    }
    // creating Product Line  record
    public static Product_Line__c  createPL(String plName, string plCode, Operating_Company__c opCo){
        testPL= new Product_Line__c();
        testPL.Name = plName;
        testPL.Code__c = plCode;
        testPL.isActive__c = true;
        testPL.isValidDateCode__c = true;
        testPL.Op_Company__c = opCo.id;
        testPL.Trace_Code_Location__c =  'CAN';
         System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>     \n\n\n' + testPL);
        return testPL;
    }
    // creating Issue Type record
    public static Issue_Type__c  createIT(String describe){
        testIT= new Issue_Type__c();
        testIT.Description__c = describe;
        return testIT;
    }
    // creating Group record
    public static Group__c  createGroup(String describe){
        testGroup= new Group__c();
        testGroup.Description__c = describe;
        return testGroup;
    }
    // creating Cause record
    public static Cause__c  createCause(String describe){
        testCause= new Cause__c();
        testCause.Description__c = describe;
        return testCause;
    }
    // creating Reason record
    public static Reason__c  createReason(String describe){
        testRsn= new Reason__c();
        testRsn.Description__c = describe;
        return testRsn;
    }
    // creating  IssueHierarchy record
    public static Issue_Hierarchy__c  createIH(Classification__c clsfy, Product_Line__c prdctLine, Issue_Type__c issueType, Group__c grp, Cause__c cause, Reason__c reason, boolean actvFlag){
        testIH= new Issue_Hierarchy__c();
        testIH.Classification__c = clsfy.id;
        testIH.Product_Line__c = prdctLine.id;
        testIH.Issue_Type__c = issueType.id;
        testIH.Group__c = grp.id;
        testIH.Cause__c = cause.id;
        testIH.Reason__c = reason.id;
        testIH.Active__c = actvFlag;
        return testIH;
    }
     // creating Brand record
    public static Brand__c  createBrand(String description, String code, Product_Line__c pl, Operating_Company__c opCo){
        testBrand= new Brand__c();
        testBrand.Description__c = description;
        testBrand.BrandCode__c = code;
        testBrand.Product_Line__c = pl.id;
        testBrand.Op_Company__c = opCo.id;
        return testBrand;
    }
    // creating  Brand Hierarchy record
    public static Brand_Hierarchy__c  createBH(String taste, String length, String packaging, String flavor, String filter, String papertype, String cut, String upc, Brand__c brand, Product_Line__c prdctLine, String vantive){
        testBH= new Brand_Hierarchy__c();
        testBH.Taste__c = taste;
        testBH.Length__c = length;
        testBH.Packaging__c = packaging;
        testBH.Flavor__c = flavor;
        testBH.Filter__c = filter;
        testBH.PaperType__c = papertype;
        testBH.Cut__c = cut;
        testBH.Brand_Code__c = brand.id;
        testBH.Product_Line_Code__c = prdctLine.id;
        testBH.UPC__c = upc;
        testBH.Vantive_Id__c = vantive;
        return testBH;
    }
    
    //BH for ustDAteCodeValidationHelper
    public static Brand_Hierarchy__c  createBHUST(String ustDatetype, Brand__c brand, Product_Line__c prdctLine, String vantive){
        testBH= new Brand_Hierarchy__c();
        testBH.Ust_Date_Type__c=ustDatetype;
        testBH.Brand_Code__c = brand.id;
        testBH.Product_Line_Code__c = prdctLine.id;
        testBH.Vantive_Id__c = vantive;
        return testBH;
    }
    // creating  Trace code record
    public static Case createTraceCode(Account acc, Decimal price,Id contactId,String traceCodeLoc, String codeLength, String mfgCode, Date prodDate, String dateCodeProdDate, String dateCodeLocation, String dateCodeShift, String dateCodeUnit, String dateCodeColdStorage, String dateCodeRptBay, String dateCodeRptFactory, String dateCodeMilitaryTime, id op){
        testCase = new Case();
        testCase.Account = acc;
        testCase.Purchase_Price__c = price; 
        testCase.ContactId = contactId;
        testCase.Trace_Code_Location__c = traceCodeLoc;
        testCase.Length_Code__c = codeLength;
        testCase.Mfg_Trace_code__c = mfgCode;
        testCase.DateCodeProductionDate__c = dateCodeProdDate;
        testCase.DateCodeLocation__c = dateCodeLocation;
        testCase.DateCodeShift__c = dateCodeShift;
        testCase.DateCodeUnit__c = dateCodeUnit;
        testCase.DateCodeColdStorage__c = dateCodeColdStorage;
        testCase.DateCodeRptBay__c = dateCodeRptBay;
        testCase.DateCodeRptFactory__c = dateCodeRptFactory;
        testCase.DateCodeMilitaryTime__c = dateCodeMilitaryTime;
        testCase.Op_Company__c  = op;
        return testCase;
    }
    //Create Document Type record
    public static DocumentType__c createDoc(String descr, String type, String category, String code, String name, Operating_Company__c opco, string Pkgcode){
        testDoc= new DocumentType__c();
        testDoc.Description__c = descr;
        testDoc.DocTyp__c = type;
        testDoc.Document_Category__c = category;
        testDoc.DocumentTypeCode__c = code;
        testDoc.FileName__c = name;
        testDoc.Op_Company__c = opCo.id;
        testDoc.PkgCode__c = Pkgcode;
        return testDoc;
    }
    
    //Create Correspondence record
    public static Correspondence_Fulfilment__c createCor(String letter, Date letterDate, Brand__c brand){
        testCor= new Correspondence_Fulfilment__c();
        testCor.Letter_head__c = letter;
        testCor.LetterDate__c = letterDate;
        testCor.Brand_Corres__c = brand.id;
        return testCor;
    }
    
    //Create Question record
    public static Question__c createQuestion(String question, String questId, string ty){
        testQuest= new Question__c();
        testQuest.Question__c = question;
        testQuest.Type__c = ty;
        //testQuest.Name = questId;
        return testQuest;
    }
    
    public static Question__c createQuestion2(String question,string qtype,Boolean yn){
        testQuest= new Question__c();
        testQuest.Question__c = question;
        testQuest.Type__c = qtype;
        testQuest.Active__c=yn;
        //testQuest.Name = questId;
        return testQuest;
    }
    
    //Create Answer record
    public static Answer__c createAnswer(String answer, String ansId){
    testAns= new Answer__c();
    //testAns.Name = ansID;
    testAns.Answer__c = answer;
    return testAns;
    }
    
    //Create Survey record
    public static Survey__c createSurvey(String name){
    testSurvey = new Survey__c();
    testSurvey.Survey_Name__c = name;
    return testSurvey;
    }
    
    //Create Survey Issue record
    public static Survey_Issue__c createSurveyIssue(Answer__c answer, Question__c question, Survey__c survey, Case issue){
    testSurvIssue = new Survey_Issue__c();
    testSurvIssue.Issue__c = issue.Id;
    testSurvIssue.Answer__c = answer.id;
    testSurvIssue.Question__c = question.id;
    testSurvIssue.Survey__c = survey.Id;
    return testSurvIssue;
    }
    
    public static Issue_Adjustment__c createIssueAdjust(String issueNumber, Boolean reviewed, String comment, String status, String Row, String reqId,String adjustType,String adjustCode, String oldVal,String newVal, String actionTy,String adjustInst){
        testIssueAdjust = new Issue_Adjustment__c();
        testIssueAdjust.IssueNumber__c = issueNumber;
        testIssueAdjust.isReviewed__c = reviewed;
        testIssueAdjust.Comment__c = comment;
        testIssueAdjust.Status__c = status;
        testIssueAdjust.Row_ID__c = Row;
        testIssueAdjust.request_id__c = reqId;
        testIssueAdjust.Adjustment_Type__c = adjustType;
        testIssueAdjust.Adjustment_Code__c = adjustCode;
        testIssueAdjust.Old_Value__c = oldVal;
        testIssueAdjust.New_Value__c = newVal;
        testIssueAdjust.Action_Type__C = actionTy;
        testIssueAdjust.Adjustment_Instructions__c = adjustInst;
        return testIssueAdjust;
    }
    
    public static PurgingMonth__c createPurgingMonth(integer count){
        PurgingMonth__c settings = PurgingMonth__c.getOrgDefaults();
        settings.Month_Count__c = count;
        upsert settings PurgingMonth__c.Id;
        return settings;
    }    
   
    
}