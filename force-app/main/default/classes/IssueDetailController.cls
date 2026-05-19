/*
Issue detail page controller class.
07/18/2016 Infogain – Created.
*/

public class IssueDetailController {
    // Global declaration of variables
    private Id issueId;
    public Id tranId {get;set;}
    public Case caseObj {get;set;}
    public boolean isReimbursed{get;set;}
    private ApexPages.StandardController standardController;
    public boolean isUpdateReasonVisible{get;set;}
    public boolean isAgeVerified{get;set;}
    public string isSurveyApplicable {get;set;}
    id contactid;
    public String tranName {get;set;}
    public String custName {get;set;} 
    public string custId{get;set;}
    public string country{get;set;}
    public string customertype{get;set;}
    public string customerRecType{get;set;}
    public List<Attachment> attachList{get;set;} 
    public Integer PageSize  {get;set;}
    public id currentTran {get;set;}
    public List<Survey_Issue__c> IssueSurvyeList{get;set;} 
    public boolean isRepeatCom{get;set;}
    public String parameters{get;set;}
    public string selectedStatus {get; set;}
    public boolean hasSurvey{get;set;}
    public List<Survey_Issue__c> issueSurveyList2{get;set;}
    public boolean iqosTrue{get;set;}
    public string masterId{get;set;}
    public boolean isStoreEmpty {get;set;} // 10/30/19 JD: RITM0052177 
    
    public string customer_firstname {get;set;}
    public  string customer_lastname {get;set;}
    public  string customer_state {get;set;}
    public  string customer_city {get;set;}
    public string customer_zipcode {get;set;}
    public  string customer_email {get;set;}
    public  string customer_address {get; set;}
    public  string customer_brand {get; set;}
    public string customer_casenumber{get;set;}
    public string  conID{get;set;}


    //public static String apiresult='';
    
    
    
    // Constructor
    public IssueDetailController(ApexPages.StandardController controller) {
        
        this.standardController = controller;
        this.caseObj = (Case)controller.getRecord();           
        parameters =  '';
        hasSurvey = false;
        issueId =  this.caseObj.id;  
        IssueSurvyeList = new List<Survey_Issue__c>();
        custName  = '';
        custId = '';
        masterId='';
        Case cValue = new Case();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        issueSurveyList2 = [SELECT FeedSend__c,isActive__c,isReviewed__c,Issue__c FROM Survey_Issue__c WHERE Issue__c =: issueId];
        if(issueSurveyList2.size() > 0){
            hasSurvey = true;
        }
        if(counter != null) {
            currentTran = counter.getValue();                
        }
        
        counter = ApexPages.currentPage().getCookies().get('customerRecType');
        if(counter != null) {
            customerRecType = counter.getValue();
            
        }
        
        if(caseObj.Original_Serial_Number__c != null && caseObj.Original_Serial_Number__c != ''){
            caseObj.Original_Serial_Number__c.toUpperCase();
        }
        
        if(this.caseObj.id != null){
            cValue =  [Select id,CaseNumber, Status, Transaction__c, Survey__c, Transaction__r.Name,ContactId, Contact.Name,contact.Zip_Code__c,contact.State__c,contact.Country__c,
                       contact.Birthdate, CreatedDate , CreatedDate__c,  LastModifiedDate__c, Contact.CustomerID__c,Contact.AVF_GIID_Received__c, Contact.CustomerType__c,Contact.RecordType.Name, Operating_Company__c,MasterId__c,Original_Serial_Number__c 
                       ,Contact.FirstName,Contact.LastName,Contact.City__c,Contact.Email,Contact.Street_Address__c,Brandcode__c
                       from Case where id =: caseObj.id];
            //System.debug('Test value'+cValue.CaseNumber);
            selectedStatus = cValue.Status;
            customertype = cValue.Contact.CustomerType__c;
            if(cValue.Original_Serial_Number__c != null && cValue.Original_Serial_Number__c != ''){
                cValue.Original_Serial_Number__c.toUpperCase();
            }
            if(cValue.MasterId__c != null ){
                masterID = cValue.MasterId__c;
                
            }               
            
            if(cValue.Transaction__c != null ){
                tranId = cValue.Transaction__c;
                tranName = cValue.Transaction__r.Name;  
            }
            
            if(cValue.ContactId != null){
                custName = cValue.Contact.Name;
                custId = cValue.Contact.CustomerID__c;
                country=cValue.Contact.Country__c;    
                isAgeVerified = cValue.Contact.AVF_GIID_Received__c;
                
                customer_firstname = cValue.Contact.FirstName;
                customer_lastname = cValue.Contact.LastName;
                customer_state = cValue.Contact.State__c;
                customer_city = cValue.Contact.City__c;
                customer_zipcode = cValue.Contact.Zip_Code__c;
                customer_email = cValue.Contact.Email;
                customer_address = cValue.Contact.Street_Address__c;
                customer_brand = cValue.Brandcode__c;
                customer_casenumber = cValue.ID;
                conID = cValue.ContactId;
            }else{
                isAgeVerified = false;                   
            }
            
            if(cValue.Survey__c != null){
                isSurveyApplicable = cValue.Survey__c;
            }
            
            // <--- 10/30/19 JD: RITM0052177
            for(Store__c st : [SELECT Name FROM Store__c WHERE Issue__c =: cValue.Id]){
                if(st.Name != null){
                    isStoreEmpty = true;
                }
            }
            // ---> 10/30/19 JD: RITM0052177
        }
        isReimbursed = checkMultipleReimbursements();
        
        
        if(caseObj.Update_Reason__c!=null && caseObj.Update_Reason__c!=''){
            isUpdateReasonVisible = true;
        }else{
            isUpdateReasonVisible =false;
        }
        
        //IQOS ---------------------------
        if(caseObj.Product_Line__c != null && caseObj.Product_Line__c != ''){
            Product_Line__c pl = [Select Id, Operating_Company__c, Name from Product_Line__c where Name =: caseObj.Product_Line__c limit 1];
            if(pl.Operating_Company__c != null && pl.Operating_Company__c != ''){
                if(pl.Operating_Company__c == 'PMIP'){
                    iqosTrue = true;
                }
                else{
                    iqosTrue = false;
                }
            }
        }
        //IQOS ---------------------------
        
        attachmentList();
        IssueSurveyData();
        allParameterInit();
    }
    
    public void allParameterInit(){
        
        if(ApexPages.currentPage().getParameters().get('Fname') != null && ApexPages.currentPage().getParameters().get('Fname') != '')
            parameters = parameters + '&fname='+ApexPages.currentPage().getParameters().get('Fname');            
        
        if(ApexPages.currentPage().getParameters().get('Lname') != null && ApexPages.currentPage().getParameters().get('Lname') != '')   
            parameters = parameters +    '&lname='+ApexPages.currentPage().getParameters().get('Lname');
        
        if(ApexPages.currentPage().getParameters().get('dob') != null && ApexPages.currentPage().getParameters().get('dob') != '')
            parameters = parameters +    '&dob='+ ApexPages.currentPage().getParameters().get('dob');
        
        if(ApexPages.currentPage().getParameters().get('Addr1') != null && ApexPages.currentPage().getParameters().get('Addr1') != '')
            parameters = parameters +    '&addr1='+ApexPages.currentPage().getParameters().get('Addr1');
        
        if(ApexPages.currentPage().getParameters().get('City') != null && ApexPages.currentPage().getParameters().get('City') != '')
            parameters = parameters +    '&city='+ApexPages.currentPage().getParameters().get('City');
        
        if(ApexPages.currentPage().getParameters().get('State') != null && ApexPages.currentPage().getParameters().get('State') != '')
            parameters = parameters +    '&state='+ApexPages.currentPage().getParameters().get('State');
        
        if(ApexPages.currentPage().getParameters().get('zip') != null && ApexPages.currentPage().getParameters().get('zip') != '')
            parameters = parameters +    '&zip=' + ApexPages.currentPage().getParameters().get('zip');
        
        if(ApexPages.currentPage().getParameters().get('email') != null && ApexPages.currentPage().getParameters().get('email') != '')
            parameters = parameters +    '&email='+ApexPages.currentPage().getParameters().get('email');
        
        if(ApexPages.currentPage().getParameters().get('country') != null && ApexPages.currentPage().getParameters().get('country') != '')
            parameters = parameters +    '&country='+ApexPages.currentPage().getParameters().get('country');        
        
        if(ApexPages.currentPage().getParameters().get('phone') != null && ApexPages.currentPage().getParameters().get('phone') != '')
            parameters = parameters +    '&phone='+ ApexPages.currentPage().getParameters().get('phone');
        
        if(ApexPages.currentPage().getParameters().get('comName') != null && ApexPages.currentPage().getParameters().get('comName') != '')
            parameters = parameters +    '&comName='+ApexPages.currentPage().getParameters().get('comName'); 
        
        if(ApexPages.currentPage().getParameters().get('agentName') != null && ApexPages.currentPage().getParameters().get('agentName') != '')
            parameters = parameters +    '&agentName='+ApexPages.currentPage().getParameters().get('agentName'); 
        
        if(ApexPages.currentPage().getParameters().get('DBA') != null && ApexPages.currentPage().getParameters().get('DBA') != '')
            parameters = parameters +    '&DBA='+ApexPages.currentPage().getParameters().get('DBA'); 
        
        if(ApexPages.currentPage().getParameters().get('accountNo') != null && ApexPages.currentPage().getParameters().get('accountNo') != '')
            parameters = parameters +    '&accountNo='+ApexPages.currentPage().getParameters().get('accountNo'); 
        
        if(ApexPages.currentPage().getParameters().get('retail') != null && ApexPages.currentPage().getParameters().get('retail') != '')
            parameters = parameters +    '&retail='+ApexPages.currentPage().getParameters().get('retail'); 
        
        if(ApexPages.currentPage().getParameters().get('fSphone') != null && ApexPages.currentPage().getParameters().get('fSphone') != '')
            parameters = parameters +    '&fSphone='+ApexPages.currentPage().getParameters().get('fSphone'); 
        
        if(ApexPages.currentPage().getParameters().get('territory') != null && ApexPages.currentPage().getParameters().get('territory') != '')
            parameters = parameters +    '&territory='+ApexPages.currentPage().getParameters().get('territory'); 
        
        if(ApexPages.currentPage().getParameters().get('custType') != null && ApexPages.currentPage().getParameters().get('custType') != '')
            parameters = parameters +    '&custType='+ApexPages.currentPage().getParameters().get('custType');
        
        if(ApexPages.currentPage().getParameters().get('custType1') != null && ApexPages.currentPage().getParameters().get('custType1') != ''){
            parameters = parameters +    '&custType1='+ApexPages.currentPage().getParameters().get('custType1');
        } 
    }
    
    
    // Method for validation to avoid more than one reimbursement on same issue
    public boolean checkMultipleReimbursements(){
        Case currIssue = [Select Id, Reimbursement_Count__c From Case Where Id =: caseObj.id limit 1];
        
        if(currIssue != null && currIssue.Reimbursement_Count__c > 0)
        {
            return true;
        }  
        return false;
    }
    
    // Button event to create new store from current issue
    public PageReference store()
    {
        issueId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = new PageReference('/apex/StoreEditPage?IssueId='+ issueId);
        return pg;
    }
    
    // Button event to create new reimbursement from current issue    
    public Pagereference reimbursementNew()
    {
        issueId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = new PageReference('/apex/ReimbursementEdit?issueId='+ issueId);
        return pg;
    }
    
    // Button event to edit current issue
    public PageReference edit()
    {
        PageReference pg = new Pagereference('/apex/IssueEntryPage?id='+issueId);
        return pg;
    }
    
    
    //Method to get the creatable fields of a object and create a dynamic soql query.
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
        if (whereClause == null || whereClause == ''){ return null; }
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null)
        {
            for (Schema.SObjectField ft : fMap.values())
            { 
                // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable() && fd.getName() != 'Update_Reason__c')
                { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty())
        {
            for (string s:selectFields)
            {
                selects += s + ',';
            }
            if (selects.endsWith(','))
            {
                selects = selects.substring(0,selects.lastIndexOf(','));
            }
            
        }
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
    }
    
    // Button event to create clone of current issue
    public PageReference customClone()
    {
        PageReference pgRef;
        Id cloneIssueId = ApexPages.currentPage().getParameters().get('id');
        String soql = getCreatableFieldsSOQL('case','id=: cloneIssueId');
        Case issueOld = (Case)Database.query(soql);
        Case issueNew = issueOld.clone(false, true);
        insert issueNew;
        if(contactid !=  null && contactid != ''){
            pgRef = new Pagereference('/apex/IssueEntryClone?id='+issueNew.id+'&parentIssue='+cloneIssueId+'&contid='+contactid );
        }else{
            pgRef = new Pagereference('/apex/IssueEntryClone?id='+issueNew.id+'&parentIssue='+cloneIssueId);
        }
        
        return pgRef;
    }
    
    public Pagereference attachmentList(){           
        
        attachList=[select id,name,CreatedDate,LastModifiedDate,description from Attachment where ParentId=:caseObj.id];
        
        return null;
    }
    
    public Pagereference  IssueSurveyData() {        
        
        IssueSurvyeList = new List<Survey_Issue__c>( [SELECT id, Comment__c, Survey_Name__c, QuestionText__c ,AnswerText__c 
                                                      FROM Survey_Issue__c 
                                                      Where isActive__c = true
                                                      and Issue__c =:caseObj.id 
                                                      order by createddate asc limit 5] );
        
        return null;
    } 
    //----------------------------------------------
    //----------------------------------------------
    public List<SelectOption> getStatusOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Email Pending','Email Pending'));
        
        options.add(new SelectOption('New','New'));
        
        return options;         
    }
    //----------------------------------------------
    //----------------------------------------------
    public Pagereference UpdateStatus()
    {
        String strStatus = selectedStatus;
        
        Case workCase = [Select Id, Status from Case Where Id =: caseObj.id];
        
        workCase.Status = strStatus;
        
        update workCase;
        
        return null;
    }
    //----------------------------------------------
    //----------------------------------------------
    public Pagereference ConsumerDetails(){
        system.debug('Inside the consumerdetails method');
        Case cValue = new Case();
        system.debug('-----caseObj.id----'+caseObj.id);
        if(caseObj.id != null){
            cValue =  [SELECT AffectedQtyFeed__c,AffectedQty__c,Affected_Type__c,AssetId,Brandcode__c,BrandID__c,Brand_Hierarchy_Code__c,
                       BusinessHoursId,Caller_Name__c,Call_Keywords__c,CaseNumber,CaseNumber__c,CauseCode__c,Causetxt__c,
                       CcExp__c,CcNum__c,CcSecCode__c,ClassificationCode__c,Classificationtxt__c,ClosedDate,
                       Comments__c,Comment__c,CommunityId,Contact.AVF_GIID_Received__c,
                       Consumer_Mentions__c,Consumer_Return__c,ContactChannel__c,ContactId,ContactType__c,Contact_Apt_Lot__c,
                       Contact_CCN_Number__c,Contact_City__c,Contact_Country__c,Contact_DOB__c,Contact_State__c,
                       Contact_Street_Address__c,Contact_Zip_Code__c,Crc_Brand_Hierarchy_Code__c,CreatedById,CreatedByName__c,
                       CreatedDate,CreatedDate__c,CreatorFullPhotoUrl,CreatorName,CreatorSmallPhotoUrl,Cut__c,
                       DateCodeColdStorage__c,DateCodeLocation__c,DateCodeMilitaryTime__c,DateCodeProductionDateFeed__c,
                       DateCodeProductionDate__c,DateCodeRptBay__c,DateCodeRptFactory__c,DateCodeShift__c,DateCodeUnit__c,
                       Date_Code__c,Date_Type__c,Date__c,DNUA_Date__c,EmailAlertId__c,EmailGenDate__c,EmailgenFlag__c,
                       EntitlementId,ExpectedQtyFeed__c,ExpectedQty__c,Expected_Type__c,ExpReturnTotalCost__c,Exp_Date__c,
                       FeedSend__c,Filter__c,Flavor__c,GroupCodeID__c,Group_Code__c,HasCommentsUnreadByOwner,
                       HasSelfServiceComments,Id,Inbound_Tracking__c,IncidentDateFeed__c,Incident_Date__c,Inventory_Depleted__c,
                       IsClosed,IsClosedOnCreate,IsDeleted,IsEscalated,IsReviewed__c,IsSelfServiceClosed,IsStopped,
                       IssueHierarchyCode__c,IssueTypecode__c,IssueURL__c,Issue_Date__c,Issue_Hierarchy_Code__c,
                       Issue_Hierarchy_Name__c,Issue_Type__c,IsVisibleInSelfService,LastModifiedById,LastModifiedByName__c,
                       LastModifiedDate,LastModifiedDate__c,LastReferencedDate,LastViewedDate,Length_Code__c,Machine_Code__c,
                       MajorSymptomFeed__c,Major_Symptom__c,Mfg_Trace_code__c,MilestoneStatus,Operating_Company__c,
                       Outbound_Tracking__c,Overage__c,OwnerId,Packaging__c,Paper_Type__c,ParentId,
                       PLCode__c,Primary_Crc_Issue_Detail_Id__c,ProdrReturnReq__c,ProductAge__c,ProductCode2__c,
                       ProductId,ProductionDateFeed__c,Production_date__c,Product_Line_Code__c,
                       Product_Line__c,PurchaseDateFeed__c,PurchaseQtyFeed__c,PurchaseQty__c,Purchase_Date__c,
                       Purchase_Price__c,Purchase_Type__c,QuestionId,Reason,ReasonCode__c,Reasontxt__c,
                       RecommendedUsageBasedOnAge__c,Reimbchk__c,ReimbursedFlagFeed__c,Reimbursed_Flag__c,Reimbursement_Count__c,
                       Related_Issue__c,ReshipDate__c,ReshipFlag__c,ReshipReason__c,ReturnReimbursementRequest__c,
                       SlaExitDate,SlaStartDate,SourceId,SpUstDateCode__c,Status,StickerInfo__c,StopStartDate,
                       StoreAddr1_Feed__c,StoreAddr2__c,StoreCity__c,StoreComments__c,StoreName__c,StoreState__c,StoreTypeCode__c,
                       StoreZip4__c,StoreZip__c,SuppliedCompany,SuppliedEmail,SuppliedName,SuppliedPhone,Supplier_Name__c,
                       SurveyHiddenReason__c,Survey_Cancel_Comments__c,Survey_Cancel_Reason__c,Survey__c,Suspected_Counterfiet__c,
                       Suspected_Tampering__c,SystemModstamp,Taste__c,TenantId__c,ThirdPartyContactedFeed__c,ThirdPartyContacted__c,
                       TMH_ID__c,Trace_Code_Location__c,Transacation_Id__c,Transaction_Management_History__c,MasterId__c,
                       Transaction__c,TxCategory__c,TxType__c,Type,UPC_code__c,UpdateFromFeed__c,Update_Reason__c,UstDateCodeType__c,
                       UstDateCode__c,UstDate__c,ValidTraceCodeFeed__c,ValidTraceCode__c,ValidUstDateCodeFeed__c,ValidUstdateCode__c,
                       YearMonthModule__c,Transaction__r.Name,Contact.Name,Contact.Country__c,Contact.CustomerID__c,Contact.Email,Contact.FirstName,
                       Contact.CustomerType__c,Contact.LastName FROM Case Where id =: caseObj.id];
            if(cValue.Transaction__c != null ){
                tranId = cValue.Transaction__c;
                tranName = cValue.Transaction__r.Name;  
            }
            System.debug('test cValue.Survey__c '+cValue.Survey__c);
            if(cValue.Survey__c != null){
                isSurveyApplicable = cValue.Survey__c;
            }
            
            if(cValue.ContactId != null){
                custName = cValue.Contact.Name;
                custId = cValue.Contact.CustomerID__c;
                country=cValue.Contact.Country__c;
                customertype =  cValue.Contact.CustomerType__c;
                customer_firstname = cValue.Contact.FirstName;
                customer_lastname = cValue.Contact.LastName;
                customer_casenumber = cValue.ID;
                conID = cValue.ContactId;


                if(caseObj.ContactId == null)
                    caseObj.ContactId = cValue.ContactId;
                isAgeVerified = cValue.Contact.AVF_GIID_Received__c;
                
                
            }else{
                isAgeVerified = false;
            }
            
        }
        if(!isReimbursed)   
            isReimbursed = checkMultipleReimbursements();  
        PageReference p = new Apexpages.Standardcontroller(cValue).view();
        p.setRedirect(true);    
        return p; 
    }
    /**
* Method Name: ResendSurvey()
* Description: This method use to resend the survey if there are one or more surveys already taken for the issue and it the issue is approved, this will * set back the FeedSend field to false
* @authoor: Gian Carlo Cutchon
* createdDate: 11/9/2017
**/
    public void ResendSurvey(){
        List<Survey_Issue__c> issueSurveyList = [SELECT FeedSend__c,isActive__c,isReviewed__c,Issue__c FROM Survey_Issue__c WHERE Issue__c =: issueId AND isActive__c = true /*AND isReviewed__c = true*/];
        List<Survey_Issue__c> issueSurveyListToUpdate = new List<Survey_Issue__c>();
        if(issueSurveyList.size() > 0){
            for(Survey_Issue__c issueSurvey : issueSurveyList){
                if(/*issueSurvey.FeedSend__c == false &&*/ caseObj.ExtractFromFeed__c == true){
                    issueSurvey.FeedSend__c = true;
                    issueSurvey.isReviewed__c = true;
                    issueSurveyListToUpdate.add(issueSurvey);
                }
            }
        }
        if(issueSurveyListToUpdate.size() > 0){
            update issueSurveyListToUpdate;
        }
    }
    
    //Method to get the Associated Chat History
    public List<LiveChatTranscript> getChatHistory(){
        List<LiveChatTranscript> listChatHist = new List<LiveChatTranscript>();
        listChatHist = [
            Select Chat_ID__c, CreatedDate, CreatedBy.Name, WaitTime, StartTime, EndTime, LastModifiedDate, LastModifiedBy.Name 
            From LiveChatTranscript 
            Where CaseId =:caseObj.id 
            order by Id desc
        ];
        if(listChatHist.isEmpty()){
            return null;
        }
        return listChatHist;
    }
    
    public void submitVF()
    {
        System.debug('Method called');		
        	eSign_API_credentials__mdt esign = [SELECT Id, Label, Username__c,API_Endpoint__c, Password__c FROM eSign_API_credentials__mdt limit 1];
        
        String endPointURL= esign.API_Endpoint__c +'/service/api/rest/authorize';
        string bdy = '{ "Username" : "'+ esign.Username__c +'", "Password" : "'+ esign.Password__c +'"}';
                    System.debug('body'+bdy);

          
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endPointURL);
        request.setMethod('POST');
        request.setBody(bdy);          
        
        HttpResponse response = http.send(request);  
        
        System.debug('responseBody: '+response.getBody());
        
        System.debug('JSON'+Json.deserializeUntyped(response.getBody()));
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        String token = '';
        if(response.getStatusCode() == 200){
            token = (String)results.get('Token');
        }
        
        System.debug('Token ==><=='+token);
        if(token != null)
        {
            //call method documentlist
            
            documentList(token);
            
        }
        
    }
    
    // @future(callout = true)
    public void documentList(String token)
    {

          eSign_API_credentials__mdt esign = [SELECT Id, Label, API_Endpoint__c,Username__c,BusinessGUID__c,DocumentGUID__c, Password__c FROM eSign_API_credentials__mdt limit 1];
        System.debug('token documentlist--->'+token );
        
        System.debug('custId--->'+custId);
        System.debug('customer_firstname--->'+customer_firstname);
        System.debug('customer_lastname--->'+customer_lastname);
        System.debug('customer_city--->'+customer_city);
        System.debug('customer_state--->'+customer_state);
        System.debug('customer_email--->'+customer_email);
        System.debug('customer_address--->'+customer_address);
        System.debug('customer_zipcode--->'+customer_zipcode);
        System.debug('customer_brand--->'+customer_brand);
        System.debug('customer_casenumber'+customer_casenumber);
        System.debug('conID'+conID);

        //converting data to JSON from class
        Documents d = new Documents();
        d.DocumentGUID =esign.DocumentGUID__c;
        d.Password = esign.Password__c;
        
        Fields f = new Fields();
        f.Name = customer_brand;
        f.Value ='DocumentBusinessName';
        
        Fields f1 = new Fields();
        f1.Name = customer_firstname;
        f1.Value ='CustomerFirstName';
        
        Fields f2 = new Fields();
        f2.Name = customer_lastname;
        f2.Value ='CustomerLastName';
        
        Fields f3 = new Fields();
        f3.Name = customer_address;
        f3.Value ='CustomerAddress1';
        
        Fields f4 = new Fields();
        f4.Name = customer_address;
        f4.Value ='CustomerAddress1';

        Fields f5 = new Fields();
        f5.Name = '';
        f5.Value ='CustomerAddress2';
        
        Fields f6 = new Fields();
        f6.Name = customer_city;
        f6.Value ='CustomerCity';
        
        Fields f7 = new Fields();
        f7.Name = customer_state;
        f7.Value ='CustomerState';
        
        Fields f8 = new Fields();
        f8.Name = customer_zipcode;
        f8.Value ='CustomerZip';
        
        
        Details det = new Details();
        det.AccountNumber = custId;
        det.BusinessGUID =esign.BusinessGUID__c;
        det.Email =customer_email;
        
        det.Fields = new List<Fields>{f,f1,f2,f3,f4,f5,f6,f7,f8};
        det.Documents = new List<Documents>{d};
            
       	Root r = new Root();  
        r.Details = det;
        
        System.debug('json new'+JSON.serialize(r));
        String str =JSON.serialize(r); 
        
        //callout url
        String endPointURL= esign.API_Endpoint__c +'/service/api/rest/DocumentRequest';
        
        //String body = '{"Details": { "AccountNumber":"' +custId + '", "BusinessGUID": "'+esign.BusinessGUID__c+'", "Email": "' +customer_email + '", "Documents": [  {  "DocumentGUID": "'+esign.DocumentGUID__c+'",  "Password": "'+esign.Password__c+'"   }  ],  "Fields": [ {  "Name" : "{DocumentBusinessName}", "Value":"'+customer_brand+'" },  {  "Name":"{CustomerFirstName}", "Value": "' +customer_firstname + '" }, {  "Name":"{CustomerLastName}",  "Value":"' +customer_lastname + '"  }, { "Name":"{CustomerAddress1}",  "Value":"' +customer_address + '"  },  {"Name":"{CustomerAddress2}",  "Value":"" },  {  "Name":"{CustomerCity}",  "Value":"'+customer_city+'"   },  { "Name":"{CustomerState}", "Value":"'+customer_state+'"  }, {  "Name":"{CustomerZip}",    "Value":"'+customer_zipcode+'" } ] }}';
        
        String body = str;
        System.debug('JSON Data'+body);
        Httprequest req = new HttpRequest();
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', token);
        req.setEndpoint(endPointURL);
        req.setMethod('POST');
        req.setBody(body);          
        
        HttpResponse response = http.send(req);  
        System.debug('new getStatusCode: '+response.getStatusCode());
        
        System.debug('new responseBody: '+response.getBody());
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        System.debug('results'+results.get('Success'));
        
        if(response.getStatusCode() != 200)
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was an error in sending the Online Age Verification Email. Please review the Consumer Information and attempt again. If problem persists, send a Manual Verification Form and notify your Team Manager.'));

        }
        
        if(results.get('Success') == true){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm, 'Online Age Verification Email Sent.'));
            
           	Transaction_Management_History__c trans_mgmt_history = new Transaction_Management_History__c();
            trans_mgmt_history.Service_Request_Code__c ='ONLINE_VF_SENT';
            trans_mgmt_history.Issue__c = customer_casenumber;
            trans_mgmt_history.First_Name__c= customer_firstname;
            trans_mgmt_history.Last_Name__c = customer_lastname ;
            trans_mgmt_history.Service_Group_Code__c= 'CRCAGEVERIFYRQ';
            trans_mgmt_history.Customer__c = conID;
            //trans_mgmt_history.Customer_Id__c = custId;
            insert trans_mgmt_history;
        }
        
        else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'There was an error in sending the Online Age Verification Email. Please review the Consumer Information and attempt again. If problem persists, send a Manual Verification Form and notify your Team Manager.'));
            
        }
    }
    
    public class Root{
        
        public Details Details;

    }

    public class Details 
    {
        public String AccountNumber;	
        public String BusinessGUID;
        public String Email;	
        public Documents[] Documents;
        public Fields[] Fields;
    }
    public class Documents {
        public String DocumentGUID;	
        public String Password;	
    }
    public class Fields {
        public String Name;	
        public String Value;	
    }
    
    
    
    
}