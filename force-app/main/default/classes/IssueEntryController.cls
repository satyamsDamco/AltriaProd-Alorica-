/* Created By: Infogain Pvt. Ltd.
   Created Date: 7/4/2016
   Purpose: Issue New/Edit Page Controller
*/
 public class IssueEntryController {
  //Global declaration of variables
    public Case caseObj{get;set;}
    public contact conObj {get;set;}
    public Boolean tradeCustomershow{get;set;}     
    public ApexPages.StandardController standController{get;set;}
    public string selectedProductLine {get; set;}    
    public List<SelectOption> productLineList {get; set;}    
    public boolean isUpdateReasonEntry{get;set;}
    public boolean isUpdateReasonClone{get;set;}
    public string brand{get;set;}
    public string selectedTraceCodeLocation{get;set;}
    public string productionDate {get;set;}
    public string customerRecType{get;set;}
    public string dateCodeDate {get;set;}
    public string traceCodeErrorMessage {get;set;}
    public boolean traceCodeError {get;set;}
    public string dateCodeError {get;set;}
    public string productLineId {get;set;}
    public boolean isRepeatCom{get;set;} 
    public boolean renderNMI{get;set;}
    public boolean iqosTrue{get;set;}
    public boolean iqosSuccess{get;set;}
    public boolean iqosSuccessPR{get;set;}
    public boolean iqosSuccessOI{get;set;}
    public string masterID{get;set;}
    public string iqosRegDate {get;set;}
    public string iqosTPC {get;set;}
     public string iqosBP {get;set;}
     
    public string iqosTPRA {get;set;}
    public string iqosRA {get;set;}
    public string iqosWSD {get;set;}
    public string iqosWED {get;set;}
    
    @TestVisible private Id cloneIssueId;
    private Id tranId;
    private Id contactId;
    private Map<String,Product_Line__c> productLineMap; 
    private  List<IntegrationLog__c> ILList = new List<IntegrationLog__c>();
    private id oldIssueHierarchy;
    private String parameters = '';
    private String heirarchyBrand = '';
    private String heirarchyIssue = '';
    private string iqosDate = '';
    private string iqosShift = '';
    private string iqosModule = '';
    private string iqosFactory = '';
    private string iqosDateCodeLocation = '';
    private string iqosDateCodeMilitaryTime = '';
    private string newIQOSSerielNum = '';
    private string originalIQOSSerielNum = '';
    private string iqosCCN = '';
    private string iqosRegistrationDate = '';
    private string iqosRegistrationStatus = '';
    private string iqosOrder = '';
    
    private date iqosPurchaseDate;
    private decimal iqosTPCustomer;
    private boolean iqosFTBuyer = false;
    private decimal iqosBasePrice;
     
    public Boolean controllerLoaded { get; set; }
     
    /* Display all the fields on page and lookup for operating company */
    public IssueEntryController (ApexPages.StandardController controller) 
    {   
        
        controllerLoaded = true;
        System.debug('✅ IssueEntryController has been initialized');
        
        isUpdateReasonEntry=false;
        isUpdateReasonClone=false;
        traceCodeError = false;
        traceCodeErrorMessage = '';
        masterID ='';
        caseObj = new Case();
        isRepeatCom = false;
        this.standController = controller;        
        
        this.caseObj = (Case)controller.getRecord(); 
       
        System.debug('test this.caseObj '+this.caseObj);
        tradeCustomershow = false;
        conObj  = new Contact();
        productLineMap  = new Map<String,Product_Line__c>();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        
        if(counter != null) 
        {
            tranid = counter.getValue();
        }

        
        contactId = ApexPages.currentPage().getParameters().get('contid');
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        if(cloneIssueId != null){
            String soql = getCreatableFieldsSOQL('case','id=: cloneIssueId');
            Case issueOld = (Case)Database.query(soql);
            System.debug('test this.caseObj '+this.caseObj);
            System.debug('test issueOld '+issueOld);
            this.caseObj =  issueOld.clone(false, true);
            //this.caseObj = (Case)controller.getRecord(); 
            this.caseObj.Survey_Cancel_Comments__c = '';
            System.debug('test contactId '+contactId);
            if(contactId == null && this.caseObj.Contactid != null){
                contactId = this.caseObj.Contactid;
                System.debug('test contactId 1 '+contactId);
            }
            
            selectedTraceCodeLocation = caseObj.Trace_Code_Location__c; 
            system.debug('---caseObj.Production_date__c----------'+caseObj.Production_date__c);
            if(caseObj.Production_date__c != null){
                productionDate = caseObj.Production_date__c.format();
            }
            
            if(caseObj.Date__c  != null){
                dateCodeDate = caseObj.Date__c.format();
            }
            //IQOS Section
            if(caseObj.Third_Party_Reimbursement_Amount__c != null){
                iqosTPRA  = caseObj.Third_Party_Reimbursement_Amount__c.format();
            }
            if(caseObj.Reimbursement_Amount__c != null){
                iqosRA  = caseObj.Reimbursement_Amount__c.format();
            }
            if(caseObj.Warranty_Expiration_Date__c != null){
                iqosWED  = caseObj.Warranty_Expiration_Date__c.format();
            }
            if(caseObj.Warranty_Start_Date__c != null){
                iqosWSD  = caseObj.Warranty_Start_Date__c.format();
            }
            if(caseObj.registrationDate__c != null){
                iqosRegDate  = caseObj.registrationDate__c.format();
            }
            if(caseObj.Total_Paid_by_Customer__c != null){
                iqosTPC  = caseObj.Total_Paid_by_Customer__c.format();
            }
            if(caseObj.Base_Price__c != null){
                iqosBP  = caseObj.Base_Price__c.format();
            }
            //End IQOS
        
        }
        
        if(this.caseObj.IQOS_Reference_ID__c == '' || this.caseObj.IQOS_Reference_ID__c == null){
            this.caseObj.complaint_source__c = 'Alorica';
        }
        
        if(caseObj.id != null){
            Case cvalue = [select Contactid,Transaction__c,Production_date__c,Date__c,Trace_Code_Location__c,Survey__c,Issue_Hierarchy_Code__c,MasterId__c,registrationDate__c,Total_Paid_by_Customer__c,Base_Price__c,Third_Party_Reimbursement_Amount__c,Reimbursement_Amount__c,Warranty_Expiration_Date__c,Warranty_Start_Date__c  from Case where id =:caseObj.id];
        
            if(cvalue.Third_Party_Reimbursement_Amount__c != null){
                iqosTPRA  = cvalue.Third_Party_Reimbursement_Amount__c.format();
            }
            if(cvalue.Reimbursement_Amount__c != null){
                iqosRA  = cvalue.Reimbursement_Amount__c.format();
            }
            if(cvalue.Warranty_Expiration_Date__c != null){
                iqosWED  = cvalue.Warranty_Expiration_Date__c.format();
            }
            if(cvalue.Warranty_Start_Date__c != null){
                iqosWSD  = cvalue.Warranty_Start_Date__c.format();
            }
            if(cvalue.registrationDate__c != null){
                iqosRegDate  = cvalue.registrationDate__c.format();
            }
            if(cvalue.Total_Paid_by_Customer__c != null){
                iqosTPC  = cvalue.Total_Paid_by_Customer__c.format();
            }
            if(cvalue.Base_Price__c != null){
                iqosBP  = cvalue.Base_Price__c.format();
            }
            if(cvalue.MasterId__c != null) {
                masterID = cvalue.MasterId__c;
            }
            if(cvalue.Production_date__c != null) 
                productionDate = cvalue.Production_date__c.format();
            if(cvalue.Issue_Hierarchy_Code__c != null)    
                oldIssueHierarchy = cvalue.Issue_Hierarchy_Code__c;    

            caseObj.Survey__c = cvalue.Survey__c;      
            if(cvalue.Date__c != null)    
                dateCodeDate  =  cvalue.Date__c.format();
            if(cvalue.Trace_Code_Location__c != null && cvalue.Trace_Code_Location__c != '')    
                selectedTraceCodeLocation = cvalue.Trace_Code_Location__c;

            if(cvalue.contactId != null){
                conObj = [select id, CustomerID__c, Repeat_Complainer__c, Repeat_Complainer_Date__c,BirthDate__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerConsumer__c from Contact where id = :cvalue.contactId  ];
            }
            isUpdateReasonEntry=true;
            caseObj.Transaction__c=tranId;            
        }else{   
            caseObj.Transaction__c=tranId;
            List<Transaction_Management__c> tranObj = new List<Transaction_Management__c>([Select Id,Name From Transaction_Management__c Where id =: tranId limit 1]);
            if(!tranObj.isEmpty() && tranObj.size() >0 && (caseObj.MasterId__c == null || caseObj.MasterId__c.trim() == '')){
                caseObj.MasterId__c = tranObj[0].Name;
            }
        }  
        
        if(contactId != null  && (caseObj.contactId == null || cloneIssueId != null)){
            caseObj.contactId = contactId;            
            conObj = [select id, CustomerID__c, BirthDate__c, Repeat_Complainer__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerConsumer__c from Contact where id = :contactId];
           
            if(conObj.BirthDate__c != null && conObj.BirthDate__c != '')
                caseObj.Contact_DOB__c = conObj.BirthDate__c;
                
            if(conObj.CCN__c != null && conObj.CCN__c != '')    
                caseObj.Contact_CCN_Number__c = conObj.CCN__c; 
            
            if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != ''){ 
                caseObj.Contact_Apt_Lot__c = conObj.Apt_Lot__c;
            }   
                        
            if(conObj.Street_Address__c != null && conObj.Street_Address__c != ''){
                caseObj.Contact_Street_Address__c = conObj.Street_Address__c;                    
            }
            
            if(conObj.City__c!= null && conObj.City__c != ''){
                caseObj.Contact_City__c = conObj.City__c;                    
            }
            
            if(conObj.State__c != null && conObj.State__c!= ''){
                caseObj.Contact_State__c = conObj.State__c;                    
            }
            
            if(conObj.Country__c != null && conObj.Country__c != ''){
                caseObj.Contact_Country__c = conObj.Country__c;                    
            }
            
            if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c != ''){
                caseObj.Contact_Zip_Code__c = conObj.Zip_Code__c ;                   
            }
        }       
        Cookie counter1 = ApexPages.currentPage().getCookies().get('customerRecType');
           if(counter1 != null) {
                customerRecType = counter1.getValue();
               system.debug('----customerRecType----'+customerRecType);
           }
        productLineListData();
        
        if(caseObj.id == null && conObj.id != null){
            if(!conObj.Repeat_Complainer__c){
                isRepeatCom = checkMutipleIssue();
            }else{
                isRepeatCom = true;
            }
        }
        allParameterInit();
        
        //==================================
        if(caseObj.id!=null)
        {
           Case issue = [Select Id,Product_Line__c From Case Where Id =: caseObj.id limit 1];
           selectedProductLine=issue.Product_Line__c; 
           
           system.debug('-----selectedProductLine-----'+selectedProductLine);
        }
        else
        {
            if(cloneIssueId != null)
            {
                selectedProductLine=caseObj.Product_Line__c; 
            }
        }
        //-------------------------
        renderNMI = false;
        iqosTrue = false;
        iqosSuccess = false;
        iqosSuccessPR = false;
        iqosSuccessOI = false;
        
        renderNMIFunction();
        //==================================
    }
    
     //Method to initialise page parameters
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
    
     //Check whether consumer is Repeat Complainer or not
     public boolean checkMutipleIssue(){
        list<Case> issueOnCurrCon = [Select Id, Contactid From Case Where Contactid =: conObj.id limit 1];
        if(issueOnCurrCon != null && issueOnCurrCon.size() > 0)
        {
            return true;
        }  
        return false;
    }
    
    //Get brand name. 
    public String getbrandData()
    {
        Brand_Hierarchy__c brandhirObj=new Brand_Hierarchy__c();
        if(caseObj.Crc_Brand_Hierarchy_Code__c!=null)
        { 
            brandhirObj = [select id, Brand_Code__r.Name
                         FROM Brand_Hierarchy__c 
                         WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            if(brandhirObj.Brand_Code__r.Name=='COPENHAGEN')
            {
                brand=brandhirObj.Brand_Code__r.Name;
            }else{
                brand='';
            }   
        }
        return brand;
    }
    
    //Triggered event to render NMI Transaction ID
    public PageReference renderNMIFunction()
    {
        try
        {
            if(productLineMap.ContainsKey(selectedProductLine))
            {
               Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
               
                if(ProductLineCode.Operating_Company__c == 'NUMARK')
                {
                    renderNMI = true;
                }
                else
                {
                    renderNMI = false;
                }
                // IQOS------------------------------------
                if(ProductLineCode.Operating_Company__c == 'PMIP')
                {
                    iqosTrue = true;
                }
                else
                {
                    iqosTrue = false;
                }
                // IQOS------------------------------------
            }
            
            return null;
        }
        catch(exception e)
        {
            return null;
        }
        return null;
    }
    
    // Button event to Save and Update the current issue
    public PageReference save() {
        List<Survey_Issue__c> oldSurveyIssue = new List<Survey_Issue__c>();
        Transaction_Management__c tranObj = new Transaction_Management__c();
        try {
            
            if(tranId != null ){
             
                tranObj = [Select Id, Contact__c From Transaction_Management__c Where id =: tranId limit 1];
           }
            
            if(caseObj.Contactid == null && tranObj != null && tranObj.Contact__c != null){
                caseObj.Contactid = tranObj.Contact__c;
                Contact conObj = [select id, CustomerID__c, BirthDate__c, Repeat_Complainer__c, CCN__c,Apt_Lot__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name,CustomerConsumer__c from Contact where id = :tranObj.Contact__c];
           
                if(conObj.BirthDate__c != null && conObj.BirthDate__c != '')
                    caseObj.Contact_DOB__c = conObj.BirthDate__c;
                    
                if(conObj.CCN__c != null && conObj.CCN__c != '')    
                    caseObj.Contact_CCN_Number__c = conObj.CCN__c; 
                
                if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != ''){
                    caseObj.Contact_Apt_Lot__c = conObj.Apt_Lot__c;
                }   
                            
                if(conObj.Street_Address__c != null && conObj.Street_Address__c != ''){
                    caseObj.Contact_Street_Address__c = conObj.Street_Address__c;                    
                }
                
                if(conObj.City__c!= null && conObj.City__c != ''){
                    caseObj.Contact_City__c = conObj.City__c;                    
                }
                
                if(conObj.State__c != null && conObj.State__c!= ''){
                    caseObj.Contact_State__c = conObj.State__c;                    
                }
                
                if(conObj.Country__c != null && conObj.Country__c != ''){
                    caseObj.Contact_Country__c = conObj.Country__c;                    
                }
                
                if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c != ''){
                    caseObj.Contact_Zip_Code__c = conObj.Zip_Code__c ;                   
                }
            }
            //11-21-2017 ggcutchon: SCR 17-05-12 NuMark Date Code – Handling of Invalids
            if(selectedProductLine=='E-Cigarette' || selectedProductLine=='Green Smoke E-Vapor'){
                if(caseObj.Date_Code__c != null && caseObj.Date_Code__c != ''){
                    if(caseObj.Date_Code__c.length() == 10){ // 01/02/2017 
                        String frstTwo = caseObj.Date_Code__c.substring(0,2);
                        String slashOne = caseObj.Date_Code__c.substring(2,3);
                        String secTwo = caseObj.Date_Code__c.substring(3,5);
                        String slashTwo = caseObj.Date_Code__c.substring(5,6);
                        String lastFour = caseObj.Date_Code__c.substring(6,10);
                        if((frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) >= 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31) && (lastFour.isNumeric() && integer.valueof(lastFour) > 2013) && slashOne == '/' && slashTwo =='/'){
                            system.debug('ggcutchon date code --->' +frstTwo + slashOne + secTwo + slashTwo + lastFour);
                            caseObj.ValidUstdateCode__c = true;
                        }
                         else if((lastFour.isNumeric() && integer.valueof(lastFour) == 2013) && (frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) == 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31 && integer.valueof(secTwo) >01)){
                            caseObj.ValidUstdateCode__c = true;
                        }

                        else if((lastFour.isNumeric() && integer.valueof(lastFour) == 2013) && (frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) > 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31 && integer.valueof(secTwo) >= 01)){
                            caseObj.ValidUstdateCode__c = true;
                        }
                        else{
                            dateCodeError = 'NuMark Date Codes must be entered in MM/DD/YYYY format and must be > 01/01/2013.';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            return null;
                        }
                        caseObj.Date__c = date.valueof(lastFour + '-' + frstTwo + '-' + secTwo);
                    }
                    else{
                        dateCodeError = 'NuMark Date Codes must be entered in MM/DD/YYYY format and must be > 01/01/2013.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                        return null;
                    }
                }
            }
            //-------------------------------------------------------------------------
            //IQOS Reimbursement Amount: If Reimbursed or Replaced Indicator field is “To be reimbursed by Alorica” is present, then Reimbursement Amount must be > 0 
            if(caseObj.Reimbursed_Or_Replaced_Indicator__c != null && caseObj.Reimbursed_Or_Replaced_Indicator__c != '' && caseObj.Reimbursed_Or_Replaced_Indicator__c == 'To be reimbursed by Alorica' ){
                if(caseObj.Reimbursement_Amount__c < 1){
                    dateCodeError = 'Reimbursement Amount must be > 0.';
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                    return null;
                }
            }
            //-------------------------------------------------------------------------

            if(productLineMap.ContainsKey(selectedProductLine)){
               Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
               caseObj.Product_Line_Code__c  =ProductLineCode.id;
               caseObj.Op_Company__c = ProductLineCode.Op_Company__c; 
            }
            Issue_Hierarchy__c issuehObj= new Issue_Hierarchy__c(); 
            System.debug('caseObj.Issue_Hierarchy_Code__c'+caseObj.Issue_Hierarchy_Code__c);
            if(caseObj != null && caseObj.Issue_Hierarchy_Code__c!=null && !String.isBlank(caseObj.Issue_Hierarchy_Code__c) ){
                issuehObj = [select id,Issue_Type__r.Description__c,Product_Line__r.Name,Group__r.Description__c,Reason__r.Description__c,Cause__r.Description__c,
                             Classification__r.Description__c, Product_Line__c 
                             FROM Issue_Hierarchy__c 
                             WHERE id=:caseObj.Issue_Hierarchy_Code__c];
                 
                 heirarchyIssue = issuehObj.Product_Line__c;
                 
                caseObj.Product_Line__c=issuehObj.Product_Line__r.Name;
                caseObj.Issue_Type__c=issuehObj.Issue_Type__r.Description__c;
                caseObj.Reasontxt__c=issuehObj.Reason__r.Description__c;
                caseObj.Causetxt__c=issuehObj.Cause__r.Description__c;
                caseObj.Group_Code__c=issuehObj.Group__r.Description__c;
                caseObj.Classificationtxt__c=issuehObj.Classification__r.Description__c;
                
                 if(oldIssueHierarchy != caseObj.Issue_Hierarchy_Code__c){
                     oldSurveyIssue = new List<Survey_Issue__c>([Select id,isActive__c 
                                                                              From Survey_Issue__c 
                                                                              Where isActive__c =  true
                                                                              and Issue__c =: caseObj.id 
                                                                              ]);
                  
                     if(!oldSurveyIssue.isEmpty() && oldSurveyIssue.size() >0){
                         for(Survey_Issue__c surObj : oldSurveyIssue){
                             surObj.isActive__c = false;
                         }                     
                     }
                     
                     caseObj.Survey__c = null;
                 }
                
                 if(caseObj.id == null){
                     caseObj.ContactType__c = 'ISSUE ENTRY';
                     issueSurveyRequired survey = new issueSurveyRequired();
                
                     Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);                     
                     
                     if(surApplicable){
                         caseObj.Survey__c = 'Required';
                     }else{
                         caseObj.Survey__c = 'Not Applicable';
                     }
                 }                
                 else{
                     caseObj.ContactType__c = 'ISSUE UPDATE';
                     if(caseObj.Survey__c == null || (caseObj.Survey__c != null && caseObj.Survey__c != 'Completed' && caseObj.Survey__c != 'Incomplete')){
                         issueSurveyRequired survey = new issueSurveyRequired();
                
                         Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);                     
                         
                         if(surApplicable){
                             caseObj.Survey__c = 'Required';
                         }else{
                             caseObj.Survey__c = 'Not Applicable';
                         }
                     } 
                 }                
                 
            }
            Brand_Hierarchy__c brandhObj= new Brand_Hierarchy__c();
            if(caseObj.Crc_Brand_Hierarchy_Code__c!=null && caseObj != null && !String.isBlank(caseObj.Crc_Brand_Hierarchy_Code__c))
            { 
                brandhObj = [select id, UPC__c,Taste__c,Packaging__c,Cut__c,Filter__c,Brand_Code__r.Name,Length__c,Flavor__c,PaperType__c, Product_Line_Code__c
                            FROM Brand_Hierarchy__c WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            
                heirarchyBrand = brandhObj.Product_Line_Code__c;
                //********************************************
                //UPC Save
                //********************************************
                string workTraceCode = '';
                string positionOneOfTraceCode = '';
                
                if(this.caseObj.Mfg_Trace_code__c != null)
                {
                    workTraceCode = caseObj.Mfg_Trace_code__c;
                    positionOneOfTraceCode = workTraceCode.substring(0,1);
                }
                
                //RITM2548147 - 2019-10-10 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                if(workTraceCode.length() == 8){ //RITM2548147 - Separate 8 and 12 characters
                        //Check for the Yes values for Pop up and message the user if found
                        string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                        
                        if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                        {
                            caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                        }   
                        else
                        {
                            caseObj.UPC_code__c=brandhObj.UPC__c;
                        }               
                 }
                if(workTraceCode.length() == 12 && selectedProductLine != 'Cigars') //RITM2548147 - Separate 8 and 12 characters and exclude Cigars 12 character on UPC append
                {
                    //Check for the Yes values for Pop up and message the user if found
                    string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                    
                    if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                    {
                        caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                    }   
                    else
                    {
                        caseObj.UPC_code__c=brandhObj.UPC__c;
                    }               
                }
                if(workTraceCode.length() == 9  && selectedProductLine != 'Cigars') //RITM2548147 - Exclude Cigars 12 character on UPC append
                {
                 string pc = positionOneOfTraceCode;
                 if(pc != 'I' && pc != 'J' && pc != 'L' && pc != 'O' && pc != 'P' && pc != 'Q' && pc != 'S' && pc != 'U' && pc != 'W'&& pc != 'X' && pc != 'Y' && pc != 'Z' && pc != 'R' && pc != 'V'){
                        caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                 }
                 else
                 {
                        caseObj.UPC_code__c=brandhObj.UPC__c;
                 } 
                 }
                else
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c;
                }
                
                
                caseObj.Filter__c=brandhObj.Filter__c;
                caseObj.Taste__c=brandhObj.Taste__c;
                caseObj.Packaging__c=brandhObj.Packaging__c;
                caseObj.Brandcode__c=brandhObj.Brand_Code__r.Name;
                caseObj.Length_Code__c=brandhObj.Length__c;
                caseObj.Flavor__c=brandhObj.Flavor__c;
                caseObj.Paper_Type__c=brandhObj.PaperType__c;
                caseObj.Cut__c=brandhObj.Cut__c;    
            }
            // 11/6/2018, gcutchon RITM2187703: SCR 18-10-25 2018 Complaints NMI Transaction ID Edit
            if(caseObj.NMI_Transaction_ID__c != null && !caseObj.NMI_Transaction_ID__c.isNumeric()){
                dateCodeError = 'NMI Transaction ID must contain numbers only or be blank.  If 2 Reference IDs are provided only enter the first one.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                return null;
            }
            //-------------------------------------------------------------------------
            // INC0037261 - Added checking before running updateTraceCodeData function to avoid clearing of field values 
            // Note: Tracecode is always empty whenever Serial number has value
            System.debug('Serial Number is: ' + caseObj.Serial_Number__c);
            if(caseObj.Serial_Number__c == null || caseObj.Serial_Number__c == ''){
                updateTraceCodeData();    
            }// INC0037261 -- End
            updateIQOSData();
            system.debug('ILList ----> ' +ILList);
            if(ILList.size() > 0){
                insert ILList;
            }
            //IQOS Manufacturing Information 
            //isRepeatCom = checkMultipleIssue();
            
            //Right before the update to the case object check to ensure that the Product Line associated with the Issue Hierarchy matches the Product Line for the Brand Hierarchy
            if(heirarchyBrand != heirarchyIssue)
            {
                String errCheckMsg = 'You have entered an Issue Hierarchy for one Product Line and a Brand Hierarchy for a different Product line.  Please ensure that the Brand Hierarchy and Issue Hierarchy are for the same Product Line.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errCheckMsg));
                return null;    
            } 
            //Start: RITM0846391
            //Set Production Location and Factory defaults for the product
            if(selectedProductLine == 'TOBACCO DERIVED NICOTINE POUCH'){
                if(caseObj.DateCodeLocation__c == '' || caseObj.DateCodeLocation__c == null)
                {caseObj.DateCodeLocation__c = 'RICHMOND';}
                if(caseObj.DateCodeRptFactory__c == '' || caseObj.DateCodeRptFactory__c == null)
                {caseObj.DateCodeRptFactory__c = 'MC_HELIX';}
            }
            //End: RITM0846391
            
            //Start: RITM2248628
            if(!String.isBlank(conObj.CustomerConsumer__c)) {
                if(caseObj.Confirmed_Counterfeit__c == true || (caseObj.Suspected_Counterfiet__c == true && caseObj.Test_Issue__c == false && ConstantClass.CUSTOMERORCONSUMER_CONS.equalsIgnoreCase(conObj.CustomerConsumer__c))) {
                    caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_ONE;
                } else if(caseObj.Test_Issue__c == true) {
                    caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_TWO;
                } else {
                    caseObj.CounterfeitCodeLookup__c = ConstantClass.COUNTERFEITCODE_ZERO;
                }
            }
            //End: RITM2248628
            
            caseObj.IsReviewed__c = false;
            Database.UpsertResult upsRst = Database.upsert(caseObj);
            if(upsRst.isSuccess())
            {
                if(!oldSurveyIssue.isEmpty() && oldSurveyIssue.size() >0)
                    update oldSurveyIssue; 
                    
                TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                
                if(upsRst.isCreated()){
                    mgmtHelper.createTransactionMgmtHistoryRecord('CREATEISSUE',String.valueOf(upsRst.getId()));
                }else{
                    mgmtHelper.createTransactionMgmtHistoryRecord('UPDATEISSUE',String.valueOf(upsRst.getId()));
                }
                if(conObj.id != null && isRepeatCom == true && !conObj.Repeat_Complainer__c){
                    conObj.Repeat_Complainer__c = true;
                    if(conObj.Repeat_Complainer_Date__c == null){
                        conObj.Repeat_Complainer_Date__c = System.today();
                    }
                    update conObj;
                }
            }  
            

            PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id+parameters );
            pageRef.setRedirect(true);
            return  pageRef ;
        }
        catch(DMLException e){// Validation rule PurchaseQty_and_Affected_Qty and PurchaseQty_and_Exp_Qty will be effective
            String errMsg = e.getMessage();
            ApexPages.addMessages(e);
            return null;
        }
    } 
    
    //Method to update the trace code information
    private void updateTraceCodeData(){
        if(productLineMap.ContainsKey(selectedProductLine)){
            Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
            caseObj.PLCode__c = ProductLineCode.Code__c;
            
            String ProductLineCode1 = '';
            if(ProductLineCode.Code__c != null){
                ProductLineCode1 = ProductLineCode.Code__c;
            }
            
            String TraceCodeObj = '';   
            if(caseObj.Mfg_Trace_code__c != null && caseObj.Mfg_Trace_code__c != ''){
                TraceCodeObj = caseObj.Mfg_Trace_code__c;
            }else{
                caseObj.Production_date__c  = null;        
                caseObj.ValidTraceCode__c = false;
            }            
            
            String TraceCodeLocation = '';
            if(selectedTraceCodeLocation  != null){
                TraceCodeLocation = selectedTraceCodeLocation;
                caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
            }
            
            String OpCompany = '';
            if(ProductLineCode.Operating_Company__c != null){
                OpCompany = ProductLineCode.Operating_Company__c;
            }                
            
            String UstDateCodeType = '';
            if(caseObj.Date_Type__c != null){
                UstDateCodeType= caseObj.Date_Type__c;
            }
            
            String UstDateCode = '';            
            if(caseObj.Date_Code__c != null && caseObj.Date_Code__c != ''){
                UstDateCode= caseObj.Date_Code__c;
            }else{
                caseObj.Date_Type__c = '';
                caseObj.Date__c = null;
                caseObj.ValidUstdateCode__c = false;
            }   
            
            String ProductionDate = '';
            if(caseObj.Production_date__c != null)
                ProductionDate = caseObj.Production_date__c.format();
                
            
            TraceCodesDetailsHelper traceCodeHelpObj = new TraceCodesDetailsHelper();
            TraceCodesDetailsHelper.TraceCodeClass TraceCodeClassObj = new TraceCodesDetailsHelper.TraceCodeClass();
            
            try{
                System.debug('testing data '+ProductLineCode1 +' ,'+  TraceCodeObj +' ,'+ OpCompany +' ,'+  TraceCodeLocation +' ,'+ 
                                                                        UstDateCodeType +' ,'+ UstDateCode  +' ,'+ 
                                                                        ProductionDate);
                                                                        
                TraceCodeClassObj = traceCodeHelpObj.getAllTraceCodeValues(ProductLineCode1, TraceCodeObj,OpCompany, TraceCodeLocation, 
                                                                        UstDateCodeType,UstDateCode, caseObj);
                if(ProductLineCode1 == 'EV' && TraceCodeObj.length() != 7){    
                    caseObj.Production_date__c = null;
                }                                                        
                system.debug('test TraceCodeClassObj'+TraceCodeClassObj );                                                       
                caseObj.DateCodeProductionDate__c = TraceCodeClassObj.DateCodeProductionDate; 
                caseObj.DateCodeLocation__c = TraceCodeClassObj.DateCodeLocation;
                if(TraceCodeClassObj.DateCodeShift != null && TraceCodeClassObj.DateCodeShift.isAlphanumeric()){
                    caseObj.DateCodeShift__c = TraceCodeClassObj.DateCodeShift;
                }
                else 
                {
                    caseObj.DateCodeShift__c = ''; //reset if null affected by RITM0266931
                }
                //if(ProductLineCode1 != 'EC' && TraceCodeObj.length() != 7){
                    caseObj.DateCodeUnit__c = TraceCodeClassObj.DateCodeUnit;
                //}
                caseObj.DateCodeColdStorage__c = TraceCodeClassObj.DateCodeColdStorage;
                caseObj.DateCodeRptBay__c = TraceCodeClassObj.DateCodeRptBay;
                caseObj.DateCodeRptFactory__c = TraceCodeClassObj.DateCodeRptFactory;
                caseObj.DateCodeMilitaryTime__c = TraceCodeClassObj.DateCodeMilitaryTime;
                caseObj.SpUstDateCode__c = TraceCodeClassObj.SpUstDateCode;
                
            } catch(exception e){
        
            }  
        }
      
        system.debug('test caseObj '+caseObj);
    
    } 
     
    // Replace the Cancel button on IssueEntry page to redirect the page.     
    public PageReference Cancel()
     {
        PageReference pageRef;
        if(caseObj.Id !=null) {
            pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
        }else{
            pageRef = new PageReference('/500');
        }
        return pageRef;
    }   
    
    // Replace the Cancel button on IssueClone page to redirect the page.
    public PageReference customCancel() {
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        delete caseObj;
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+cloneIssueId);
        return pageRef;
        
    }  
    
    //Product line list.
    public void productLineListData(){
        productLineList = new List<SelectOption>(); 
        productLineMap = new Map<String,Product_Line__c>(); 
        selectedProductLine =  '0';
        productLineList.add(new SelectOption('0', '--Select Product Line--',false)); 
        
        List<Product_Line__c> productLineObj = new List<Product_Line__c>([Select id, Name,code__c,Trace_Code_Location__c, Op_Company__c, Operating_Company__c,isValidDateCode__c from Product_Line__c  where isActive__c = true order by Name asc]);  
           for(Product_Line__c pl :productLineObj){
            productLineList.add(new SelectOption(pl.name, pl.name));            
            productLineMap.put(pl.name,pl);
        }     
        if(caseObj.id!=null)
        {
           Case issue = [Select Id,Product_Line__c From Case Where Id =: caseObj.id limit 1];
           selectedProductLine=issue.Product_Line__c; 
           
           system.debug('-----selectedProductLine-----'+selectedProductLine);
        }
        else
        {
            if(cloneIssueId != null)
            {
                selectedProductLine=caseObj.Product_Line__c; 
            }
        }
    }
 
    // Save method for cloning current issue. Here it is saving some existing informations of current issue.
    public PageReference customSave()
    {
    try{
        cloneIssueId = ApexPages.currentPage().getParameters().get('parentIssue');
        
        if(productLineMap.ContainsKey(selectedProductLine)){
           Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
           caseObj.Product_Line_Code__c  =ProductLineCode.id;
           caseObj.Op_Company__c = ProductLineCode.Op_Company__c;
        }
            
        Issue_Hierarchy__c issuehObj= new Issue_Hierarchy__c(); // Capturing Issue Hierarchy related data on clone issue
        if(caseObj.Issue_Hierarchy_Code__c!=null){
            issuehObj = [select id, Product_Line_Code__c, Issue_Type__r.Description__c,Product_Line__r.Name,Group__r.Description__c,Reason__r.Description__c,Cause__r.Description__c,
                             Classification__r.Description__c 
                             FROM Issue_Hierarchy__c 
                             WHERE id=:caseObj.Issue_Hierarchy_Code__c];
                             
            heirarchyIssue = issuehObj.Product_Line__c;
                             
                             
            caseObj.Product_Line__c=issuehObj.Product_Line__r.Name;
            caseObj.Issue_Type__c=issuehObj.Issue_Type__r.Description__c;
            caseObj.Reasontxt__c=issuehObj.Reason__r.Description__c;
            caseObj.Causetxt__c=issuehObj.Cause__r.Description__c;
            caseObj.Group_Code__c=issuehObj.Group__r.Description__c;
            caseObj.Classificationtxt__c=issuehObj.Classification__r.Description__c;
            issueSurveyRequired survey = new issueSurveyRequired();
        
             Boolean surApplicable = survey.surveyRequired(caseObj.Issue_Hierarchy_Code__c);
             
             if(surApplicable){
                 caseObj.Survey__c = 'Required';
             }else{
                 caseObj.Survey__c = 'Not Applicable';
             }
        }
            
        Brand_Hierarchy__c brandhObj= new Brand_Hierarchy__c();  // Capturing Brand Hierarchy related data on clone issue
        if(caseObj.Crc_Brand_Hierarchy_Code__c!=null)
        { 
            brandhObj = [select id, Product_Line_Code__c, UPC__c,Taste__c,Cut__c,Packaging__c,Filter__c,Brand_Code__r.Name,Length__c,Flavor__c,PaperType__c
                         FROM Brand_Hierarchy__c 
                         WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
            
            
            heirarchyBrand = brandhObj.Product_Line_Code__c;
            //********************************************
            //UPC Save
            //********************************************
            string workTraceCode = '';
            string positionOneOfTraceCode = '';
            
            if(this.caseObj.Mfg_Trace_code__c != null)
            {
                workTraceCode = caseObj.Mfg_Trace_code__c;
                positionOneOfTraceCode = workTraceCode.substring(0,1);
            }
            
            //RITM2548147 - 2019-10-10 - SCR 19-07-26 2019 Cigar v.05 - Jannel
            if(workTraceCode.length() == 8){ //RITM2548147 - Separate 8 and 12 characters
                //Check for the Yes values for Pop up and message the user if found
                string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                
                if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                }   
                else
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c;
                }               
            }
            if(workTraceCode.length() == 12 && selectedProductLine != 'Cigars') //RITM2548147 - Separate 8 and 12 characters and exclude Cigars 12 character on UPC append
            {
                //Check for the Yes values for Pop up and message the user if found
                string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                
                if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                }   
                else
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c;
                }               
            }
            if(workTraceCode.length() == 9  && selectedProductLine != 'Cigars') //RITM2548147 - Exclude Cigars 12 character on UPC append
            {
                string pc = positionOneOfTraceCode;
                if(pc != 'I' && pc != 'J' && pc != 'L' && pc != 'O' && pc != 'P' && pc != 'Q' && pc != 'S' && pc != 'U' && pc != 'W'&& pc != 'X' && pc != 'Y' && pc != 'Z' && pc != 'R' && pc != 'V'){
                    caseObj.UPC_code__c=brandhObj.UPC__c + pc;  
                }
                else
                {
                    caseObj.UPC_code__c=brandhObj.UPC__c;
                } 
            }
            else
            {
                caseObj.UPC_code__c=brandhObj.UPC__c;
            }
            

            caseObj.Filter__c=brandhObj.Filter__c;
            caseObj.Taste__c=brandhObj.Taste__c;
            caseObj.Packaging__c=brandhObj.Packaging__c;
            caseObj.Brandcode__c=brandhObj.Brand_Code__r.Name;
            caseObj.Length_Code__c=brandhObj.Length__c;
            caseObj.Flavor__c=brandhObj.Flavor__c;
            caseObj.Paper_Type__c=brandhObj.PaperType__c;
            caseObj.Cut__c=brandhObj.Cut__c;
                
        }
        
        // 11/6/2018, gcutchon RITM2187703: SCR 18-10-25 2018 Complaints NMI Transaction ID Edit
        if(caseObj.NMI_Transaction_ID__c != null && !caseObj.NMI_Transaction_ID__c.isNumeric()){
            dateCodeError = 'NMI Transaction ID must contain numbers only or be blank.  If 2 Reference IDs are provided only enter the first one.';
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
            return null;
        }
        //-------------------------------------------------------------------------
        // INC0037261 - Added checking before running updateTraceCodeData function to avoid clearing of field values 
        // Note: Tracecode is always empty whenever Serial number has value
        System.debug('Serial Number is: ' + caseObj.Serial_Number__c); 
        if(caseObj.Serial_Number__c == null || caseObj.Serial_Number__c == ''){ 
            updateTraceCodeData();    
        } // INC0037261 -- End
        caseObj.ContactType__c = 'ISSUE ENTRY';
        caseObj.IsReviewed__c = false;
        
        //Right before the update to the case object check to ensure that the Product Line associated with the Issue Hierarchy matches the Product Line for the Brand Hierarchy
        if(heirarchyBrand != heirarchyIssue)
        {
            String errCheckMsg = 'You have entered an Issue Hierarchy for one Product Line and a Brand Hierarchy for a different Product line.  Please ensure that the Brand Hierarchy and Issue Hierarchy are for the same Product Line.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errCheckMsg));
            return null;    
        }
        
        //Start: RITM0846391
        //Set Production Location and Factory defaults for the product
        if(selectedProductLine == 'TOBACCO DERIVED NICOTINE POUCH'){
            if(caseObj.DateCodeLocation__c == '' || caseObj.DateCodeLocation__c == null)
            {caseObj.DateCodeLocation__c = 'RICHMOND';}
            if(caseObj.DateCodeRptFactory__c == '' || caseObj.DateCodeRptFactory__c == null)
            {caseObj.DateCodeRptFactory__c = 'MC_HELIX';}
        }
        //End: RITM0846391
        
        //Added by Sachin Shah
        //Start
        //Set Production Location and Factory defaults for the product - Synthetic Nicotine Pouch 
        
         if(selectedProductLine == 'SYNTHETIC NICOTINE POUCH'){
            if(caseObj.DateCodeLocation__c == '' || caseObj.DateCodeLocation__c == null)
            {caseObj.DateCodeLocation__c = 'RICHMOND';}
            if(caseObj.DateCodeRptFactory__c == '' || caseObj.DateCodeRptFactory__c == null)
            {caseObj.DateCodeRptFactory__c = 'D PILOT';}
        }
        
        //end here
        //Added by Affirma - Sachin Shah
        //RITM1898013 ==> Start
        
        //Set Production Location and Factory defaults for the product - Tobacco Derived Nicotine Spray 
        if(selectedProductLine == 'Tobacco-Derived Nicotine Product'){
            if(caseObj.DateCodeLocation__c == '' || caseObj.DateCodeLocation__c == null)
            {caseObj.DateCodeLocation__c = 'RICHMOND';}
            if(caseObj.DateCodeRptFactory__c == '' || caseObj.DateCodeRptFactory__c == null)
            {caseObj.DateCodeRptFactory__c = 'USSTP – DPP_Ion';}
        }
       
        
       //RITM1898013 <== End
         System.debug('caseObj.DateCodeLocation__c'+caseObj.DateCodeLocation__c);
        System.Debug('caseObj.DateCodeRptFactory__c'+caseObj.DateCodeRptFactory__c);
      
        Database.SaveResult insRst = Database.insert(caseObj);
        if(insRst.isSuccess()){
            System.debug('tranId==>'+tranId);
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            Transaction_Management__c tranObj = [Select Id, Contact__c From Transaction_Management__c Where id =: tranId limit 1];
            mgmtHelper.createTransactionMgmtHistoryRecord('CREATEISSUE',String.valueOf(insRst.getId()));
            if(conObj.id != null && isRepeatCom == true && !conObj.Repeat_Complainer__c){
                conObj.Repeat_Complainer__c = true;
                system.debug('--463---'+conObj.Repeat_Complainer_Date__c);
                if(conObj.Repeat_Complainer_Date__c == null){
                    conObj.Repeat_Complainer_Date__c = System.today();
                }
                update conObj;
            }
        }
        list<Store__c> lstStoreClone = new list<Store__c>(); // Capturing store related data on clone issue
        list<Store__c> lstStore = [Select Transaction_Management__c, Store_Zip__c, Store_Type__c, Store_State__c, Store_Comment__c, Store_City__c, Store_Address2__c, Store_Address1__c, 
                                   Name, Issue__c,Store_Name__c,Id From Store__c Where Issue__c =: cloneIssueId];
        for(Store__c store : lstStore){
            Store__c newStore = new Store__c();
            newStore = store.clone(false, true);
            newStore.Issue__c = caseObj.id;
            newStore.Transaction_Management__c = tranId;
            newStore.isReviewed__c = false;
            if(caseObj.Issue_Type__c != null && caseObj.Issue_Type__c == 'Complaints' && (store.Store_Name__c == null || store.Store_Name__c.trim() == '')){
                newStore.Store_Name__c = 'UNKNOWN';
            }
            lstStoreClone.add(newStore);
        }
        
        if(lstStoreClone != null && lstStoreClone.size() > 0){
            insert lstStoreClone;
        }
            
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id+parameters );
        return pageRef;
        }
        catch(DMLException e){// Validation rule PurchaseQty_and_Affected_Qty and PurchaseQty_and_Exp_Qty will be effective
            String errMsg = e.getMessage();
            ApexPages.addMessages(e);   
            return null;
        }
    }
    
    //Method to perform date code validation
    public PageReference DateCodeValidation()
    {
        caseObj.Date_Type__c = '';
        caseObj.Date__c = null;
        dateCodeDate = '';
        caseObj.ValidUstdateCode__c  = false;
        dateCodeError = '';
        Product_Line__c ProductLineCode;
        
        if(productLineMap.ContainsKey(selectedProductLine))
        {
            ProductLineCode = productLineMap.get(selectedProductLine);
        }
        
        //=============================================================================
        //=============================================================================
        if(ProductLineCode != null && ProductLineCode.isValidDateCode__c)
        {            
            caseObj.Date_Type__c = '';
            caseObj.Date__c = null;
            dateCodeDate = '';
            String BH = caseObj.Crc_Brand_Hierarchy_Code__c;
            
            if(BH != null && BH != '')
            {                
                if(caseObj.Date_Code__c == null ||  caseObj.Date_Code__c == '')
                {
                    return null;
                }
                caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
                caseObj.Date_Code__c = caseObj.Date_Code__c.trim().toUpperCase();
                if(caseObj.Trace_Code_Location__c == null || caseObj.Trace_Code_Location__c == ''){
                    dateCodeError = 'Please choose Trace Code Location before entering Date Code.';
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                    caseObj.Date_Code__c = '';
                    return null;
                }
                
                if(caseObj.Date_Code__c != null && caseObj.Date_Code__c != ''){
                    Integer lengthDateCode  = caseObj.Date_Code__c.trim().length();
                    if(selectedProductLine =='MST'){
                        //Date code format wwyy,mmmddyyyy,mmmddyyyy                        
                        if(lengthDateCode != 4 && lengthDateCode != 9){
                            dateCodeError = 'Please enter correct Date Code format ww/yy or mmmddyyyy';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            return null;
                        }
                    
                    }else if(selectedProductLine=='Pouch' || selectedProductLine=='USSTC Snus'){
                        //Date code format mmmddyyyy
                        if(lengthDateCode != 9){
                            dateCodeError = 'Please enter correct Date Code format mmmddyyyy';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            return null;
                        }
                    
                    }/*else if(selectedProductLine=='Green Smoke E-Vapor'){
                        //Date code format ddmmmyyyy
                        if(lengthDateCode != 9){
                            dateCodeError = 'Please enter correct Date Code format ddmmmyyyy';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            return null;
                        }
                    }else if(selectedProductLine=='E-Cigarette'){
                        //Date code format mmddyyyy
                        if(lengthDateCode != 8){
                            dateCodeError = 'Please enter correct Date Code format mmddyyyy';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            return null;
                        }
                    }    */ 
                    //11-21-2017 ggcutchon: SCR 17-05-12 NuMark Date Code – Handling of Invalids
                    else if(selectedProductLine=='E-Cigarette' || selectedProductLine=='Green Smoke E-Vapor'){
                        if(caseObj.Date_Code__c != null ){
                            if(caseObj.Date_Code__c.length() == 10){ // 01/02/2017 
                                String frstTwo = caseObj.Date_Code__c.substring(0,2);
                                String slashOne = caseObj.Date_Code__c.substring(2,3);
                                String secTwo = caseObj.Date_Code__c.substring(3,5);
                                String slashTwo = caseObj.Date_Code__c.substring(5,6);
                                String lastFour = caseObj.Date_Code__c.substring(6,10);
                                if((frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) >= 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31) && (lastFour.isNumeric() && integer.valueof(lastFour) > 2013) && slashOne == '/' && slashTwo =='/'){
                                    system.debug('ggcutchon date code --->' +frstTwo + slashOne + secTwo + slashTwo + lastFour);
                                    caseObj.ValidUstdateCode__c = true;
                                }
                                 else if((lastFour.isNumeric() && integer.valueof(lastFour) == 2013) && (frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) == 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31 && integer.valueof(secTwo) >01)){
                                    caseObj.ValidUstdateCode__c = true;
                                }

                                else if((lastFour.isNumeric() && integer.valueof(lastFour) == 2013) && (frstTwo.isNumeric() && integer.valueof(frstTwo) <= 12 && integer.valueof(frstTwo) > 01) && (secTwo.isNumeric() && integer.valueof(secTwo) <= 31 && integer.valueof(secTwo) >= 01)){
                                    caseObj.ValidUstdateCode__c = true;
                                }                                   
                                else{
                                    dateCodeError = 'NuMark Date Codes must be entered in MM/DD/YYYY format and must be > 01/01/2013.';
                                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                                    return null;
                                }
                            }
                            else{
                                dateCodeError = 'NuMark Date Codes must be entered in MM/DD/YYYY format and must be > 01/01/2013.';
                                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                                return null;
                            }
                        }
                    }
                    //-------------------------------------------------------------------------
                }
                
                            
                if(productLineMap.ContainsKey(selectedProductLine)){
                    ProductLineCode = productLineMap.get(selectedProductLine);                
                    
                    if(ProductLineCode.Code__c != null && ProductLineCode.Operating_Company__c != null){                         
                        caseObj.PLCode__c = ProductLineCode.Code__c;             
                        UstDateCodeValidationHelper.ustTraceCode traceCodeObj = new UstDateCodeValidationHelper.ustTraceCode();
                        
                        UstDateCodeValidationHelper  ustHelper = new UstDateCodeValidationHelper();
                        traceCodeObj = ustHelper.ustTraceCodeValidation(ProductLineCode.Code__c,caseObj.Date_Code__c,ProductLineCode.Operating_Company__c, caseObj.Trace_Code_Location__c, caseObj.Crc_Brand_Hierarchy_Code__c);
                        if(traceCodeObj.ProductionDate != null && traceCodeObj.ProductionDate !='' && traceCodeObj.ProductionDate != 'fail'){
                            caseObj.Date__c =  date.parse(traceCodeObj.ProductionDate);
                            //caseObj.Date__c =  caseObj.Production_date__c;
                            dateCodeDate = traceCodeObj.ProductionDate;                                
                           
                            caseObj.ValidUstdateCode__c = true;
                            if(traceCodeObj.FinalUstTraceCode != null && traceCodeObj.FinalUstTraceCode != ''){
                                caseObj.Date_Type__c =  traceCodeObj.FinalUstTraceCode;
                            }
                       }else{
                            dateCodeError = 'You have entered an invalid Date Code';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                            
                            return null;                         
                        }        
                    }
                
                }else{
                    dateCodeError = 'Please choose Product Line before entering Date Code.';            
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError ));
                    caseObj.Date_Code__c = '';
                    return null;            
                }            
            }
            else
            {
                dateCodeError = 'Please choose Brand Hierarchy before entering Date Code.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, dateCodeError));
                caseObj.Date_Code__c = '';
                return null;
            }
                                                
            if(selectedProductLine=='Cigars')
            {
                //RITM2548147 - 2019-10-10 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                //Get UPC code
                Brand_Hierarchy__c brandH = new Brand_Hierarchy__c();
                brandH = [SELECT UPC__c FROM Brand_Hierarchy__c WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
                
                //********************************************
                //UPC POP UP
                //********************************************
                string workTraceCode = caseObj.Mfg_Trace_code__c;
                string positionOneOfTraceCode = workTraceCode.substring(0,1);
                
                //RITM2548147 - 2019-10-10 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                
                if(workTraceCode.length() == 8) //RITM2548147 - Separate 8 and 12 Char 
                {
                    //Check for the Yes values for Pop up and message the user if found
                    string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                    
                    
                    if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                    {
                        string workMessage = ProductLineCode.Operating_Company__c + ' Cigars --- The UPC will be  changed, adding the first character of the trace code as the last character of the UPC.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                                                
                        return null;    
                    }                   
                                    
                } 
                if(workTraceCode.length() == 12) //RITM2548147 - Separate 8 and 12 Char
                {
                    //Check for the Yes values for Pop up and message the user if found
                    string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                    
                     //RITM2548147 - Get list of valid Position 1 char on table
                    List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                    tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                                WHERE Character_Length__c =: workTraceCode.length() 
                                AND Product_Line_Name__c =: selectedProductLine
                                AND POPUP_UPC_CODE__c = 'Y'];
                    
                    List<String> lString = new List<String>();
                    
                    for (Tracecode_Matrix_Table__c st : tmt){
                        lString.add(st.Position_1__c);
                    }
                    
                    if(lString.contains(pc)) //RITM2548147 - Updated Pop up message
                    {
                        if(brandH.UPC__c != null){
                        string workMessage = 'Please add the following to the Issue Comment:  Potential 8/8 Product, the UPC is '+ brandH.UPC__c + ' and the first letter of the trace code is '+pc+'.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                        traceCodeErrorMessage = workMessage;
                        }                      
                        return null;    
                    }  
                    
                } 
                if(workTraceCode.length() == 9){
                    string pc = positionOneOfTraceCode;
                    
                     //RITM2548147 - Get list of valid Position 1 char on table
                    List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                    tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                                WHERE Character_Length__c =: workTraceCode.length() 
                                AND Product_Line_Name__c =: selectedProductLine
                                AND POPUP_UPC_CODE__c = 'Y'];
                    
                    List<String> lString = new List<String>();
                    
                    for (Tracecode_Matrix_Table__c st : tmt){
                        lString.add(st.Position_1__c);
                    }
                    
                    if(lString.contains(pc)) //RITM2548147 - Updated Pop up message
                    {
                        if(brandH.UPC__c != null){
                        string workMessage = 'Please add the following to the Issue Comment:  Potential 8/8 Product, the UPC is '+ brandH.UPC__c +' and the first letter of the trace code is '+pc+'.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                        traceCodeErrorMessage = workMessage;
                        }                       
                        return null;    
                    }  
                }
            }
        }
        //=============================================================================
        //=============================================================================
        
        return null;
    }
    
    //Method to perform the trace code validation
    public PageReference TraceCodeValidation()
    {    
        caseObj.Production_date__c  = null;        
        traceCodeErrorMessage = '';
        productLineId = '';
        traceCodeError = false;
        productionDate = null;
        caseObj.ValidTraceCode__c = false;
        
        caseObj.Suspected_Counterfiet__c = false;
        system.debug('tracecode caseObj ---> '+ caseObj);        
        if(caseObj.Mfg_Trace_code__c == null || caseObj.Mfg_Trace_code__c ==  '')
        {
            caseObj.Production_date__c = null;
            productionDate = '';
            return null;
        }  
        
        caseObj.Mfg_Trace_code__c = caseObj.Mfg_Trace_code__c.toUpperCase();
        caseObj.Trace_Code_Location__c =  selectedTraceCodeLocation;
        
        if((caseObj.Mfg_Trace_code__c != null && caseObj.Mfg_Trace_code__c !=  '') && caseObj.Trace_Code_Location__c == null || caseObj.Trace_Code_Location__c == '')
        {
            traceCodeErrorMessage = 'Please choose Trace Code  Location before entering Trace code.'; 
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
            caseObj.Mfg_Trace_code__c = '';
            
            return null;
        }
        
        if(productLineMap.ContainsKey(selectedProductLine))
        {
                Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
                
                if(ProductLineCode != null)
                {
                    caseObj.PLCode__c = ProductLineCode.Code__c;
                    Boolean counterFeit  = TraceCodeHelper.checkCounterfeitTraceCode(caseObj.Mfg_Trace_code__c);
                    
                    if(counterFeit)
                    {
                        caseObj.Suspected_Counterfiet__c = true;
                        traceCodeErrorMessage = 'Suspected Counterfeit. Please request product return and check Suspected Counterfeit box.'; 
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
                    }
                    else
                    {
                         caseObj.Suspected_Counterfiet__c = false;
                    }
                
                TraceCodeHelper traceHelper = new TraceCodeHelper();
                System.debug('code'+ProductLineCode.Code__c +'==1=='+ caseObj.Mfg_Trace_code__c +'==2==' +ProductLineCode.Operating_Company__c + '==3==' +caseObj.Trace_Code_Location__c + '==4==' +caseObj);
                String productionDate1 = traceHelper.traceCodeValidation(ProductLineCode.Code__c,caseObj.Mfg_Trace_code__c,ProductLineCode.Operating_Company__c, caseObj.Trace_Code_Location__c, caseObj);
                System.debug('debug 1'+productionDate1);
                System.debug('pd date '+productionDate);
                    
                if(productionDate1 != null &&  productionDate1 !=  '' && productionDate1 != 'fail')
                {
                    productionDate1 = productionDate1.replace('null','');
                    productionDate = productionDate1;

                    if(caseObj.Suspected_Counterfiet__c)
                    {
                        if(productionDate1 != null && productionDate1 !=  '')
                        {
                            caseObj.Production_date__c = date.parse(productionDate1);
                        }
                    }
                    else
                    {
                        if(productionDate1 != 'NODATE'){
                            caseObj.Production_date__c = date.parse(productionDate1);
                        }
                        caseObj.ValidTraceCode__c = true;
                    }
                    
                    ApexPages.getMessages().clear();
                }
                else
                {
                    if(!caseObj.Suspected_Counterfiet__c){
                        productLineId = ProductLineCode.id;
                        System.debug('test message ==>'+caseObj.Suspected_Counterfiet__c);
                        System.debug('test message ==><=='+productLineId);

                        traceCodeErrorMessage = 'You have entered an invalid trace code. Please validate it before proceeding'; 
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, traceCodeErrorMessage ));
                        traceCodeError = true;
                    }
                }
                    
                //RITM3521882
                string traceCodeToValidate = caseObj.Mfg_Trace_code__c;
                
                // Hour validation only applicable to HELIX product line (TOBACCO DERIVED NICOTINE POUCH)
                if(traceCodeToValidate.length() == 9 && selectedProductLine == 'TOBACCO DERIVED NICOTINE POUCH') {
                
                    // Validate hour part (characters 6 and 7) are numeric and within 00–23
                    try {
                        String hourPart = traceCodeToValidate.substring(5, 7); // positions 6 and 7
                        System.debug('Validating hour part: ' + hourPart);
                
                        // Check if it's exactly 2 digits
                        if (!Pattern.matches('\\d{2}', hourPart)) {
                            throw new IllegalArgumentException('Hour part is not numeric.');
                        }
                
                        Integer hourVal = Integer.valueOf(hourPart);
                        if (hourVal < 0 || hourVal > 23) {
                            throw new IllegalArgumentException('Hour out of range.');
                        }
                    } catch (Exception e) {
                        traceCodeErrorMessage = '❌ Invalid hour format in Trace Code. Characters 6 and 7 must be numeric between 00 and 23.';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, traceCodeErrorMessage));
                        System.debug('Hour format validation failed: ' + e.getMessage());
                        return null;
                    }
                }
                
                
            }     
            
            //===============================
            if(selectedProductLine=='Cigars')
            {
                //RITM2548147 - 2019-10-10 - SCR 19-07-26 2019 Cigar v.05 - Jannel
                //Get UPC code
                Brand_Hierarchy__c brandH = new Brand_Hierarchy__c();
                brandH = [SELECT UPC__c FROM Brand_Hierarchy__c WHERE id=:caseObj.Crc_Brand_Hierarchy_Code__c];
                
                //********************************************
                //UPC POP UP
                //********************************************
                string workTraceCode = caseObj.Mfg_Trace_code__c;
                string positionOneOfTraceCode = workTraceCode.substring(0,1);
                
               
                if(workTraceCode.length() == 8) //RITM2548147 - Separate 8 and 12 Char 
                {
                    //Check for the Yes values for Pop up and message the user if found
                    string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                    
                    
                    if(pc != 'J' && pc != 'L' && pc != 'R' && pc != 'S' && pc != 'V' && pc != 'X')
                    {
                        string workMessage = ProductLineCode.Operating_Company__c + ' Cigars --- The UPC will be  changed, adding the first character of the trace code as the last character of the UPC.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                                                
                        return null;    
                    }                   
                                    
                } 
                if(workTraceCode.length() == 12) //RITM2548147 - Separate 8 and 12 Char
                {
                    //Check for the Yes values for Pop up and message the user if found
                    string pc = positionOneOfTraceCode; //make the variable name smaller and easier to work with
                    
                     //RITM2548147 - Get list of valid Position 1 char on table
                    List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                    tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                                WHERE Character_Length__c =: workTraceCode.length() 
                                AND Product_Line_Name__c =: selectedProductLine
                                AND POPUP_UPC_CODE__c = 'Y'];
                    
                    List<String> lString = new List<String>();
                    
                    for (Tracecode_Matrix_Table__c st : tmt){
                        lString.add(st.Position_1__c);
                    }
                    
                    if(lString.contains(pc)) //RITM2548147 - Updated Pop up message
                    {
                        if (brandH.UPC__c != null){
                        string workMessage = 'Please add the following to the Issue Comment:  Potential 8/8 Product, the UPC is '+ brandH.UPC__c +' and the first letter of the trace code is '+pc+'.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                        traceCodeErrorMessage = workMessage;                        
                        }
                        return null;    
                            
                    }  
                    
                } 
                if(workTraceCode.length() == 9){
                    string pc = positionOneOfTraceCode;
                    
                     //RITM2548147 - Get list of valid Position 1 char on table
                    List<Tracecode_Matrix_Table__c> tmt = new List<Tracecode_Matrix_Table__c>();
                        
                    tmt = [SELECT Position_1__c FROM Tracecode_Matrix_Table__c 
                                WHERE Character_Length__c =: workTraceCode.length() 
                                AND Product_Line_Name__c =: selectedProductLine
                                AND POPUP_UPC_CODE__c = 'Y'];
                    
                    List<String> lString = new List<String>();
                    
                    for (Tracecode_Matrix_Table__c st : tmt){
                        lString.add(st.Position_1__c);
                    }
                    
                    if(lString.contains(pc)) //RITM2548147 - Updated Pop up message
                    {
                        if (brandH.UPC__c != null){
                        string workMessage = 'Please add the following to the Issue Comment:  Potential 8/8 Product, the UPC is '+ brandH.UPC__c + ' and the first letter of the trace code is '+pc+'.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, workMessage));
                        traceCodeErrorMessage = workMessage; 
                        }
                        return null;    
                    }  
                }               
            }
                       
         }else{            
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please choose Product Line before entering Date Code.'));
            caseObj.Mfg_Trace_code__c = '';
            caseObj.Production_date__c = null;
            traceCodeErrorMessage  = '';
            return null;            
        }  
        //11-20-2017 ggcutchon: SCR 17-05-06 Recall Trace Codes for Franklin Park: If the user enters a “recall trace code” in the Mfg./Trace Code field, then the system will display “The trace code entered is a USST Recall Trace Code.” 
        date date1 = date.valueof('2016-10-27 00:00:00');
        date date2 = date.valueof('2017-01-31 00:00:00');
        System.debug('gccutchon  dateProd '+ caseObj.Production_date__c );
        if(selectedProductLine == 'MST' || selectedProductLine == 'Dry Snuff' || selectedProductLine == 'Pouch' || selectedProductLine == 'USSTC Snus' ){
            if(caseObj.Production_date__c >= date1 && caseObj.Production_date__c <= date2){
                string msg= 'The trace code entered is a USST Recall Trace Code.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                return null;
            }
        }
        //------------------------------    
        return null;
    }
    
    //Method to get the trace code location based on the product line selected
    public List<SelectOption> getTraceCodeLocation(){
    
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        if(productLineMap.ContainsKey(selectedProductLine)){
            Product_Line__c ProductLineCode = productLineMap.get(selectedProductLine);
            System.debug('trace code Location'+ProductLineCode);
            if(ProductLineCode.Trace_Code_Location__c != null && ProductLineCode.Trace_Code_Location__c != ''){
                String[] locations = ProductLineCode.Trace_Code_Location__c.split(';');
                locations.sort();
                if(!locations.isEmpty() && locations.size() >0){
                    for(integer i=0; i< locations.size()  ;i++){
                        options.add(new SelectOption(locations[i],locations[i]));
                    }
                }
                  
            }                
        }        
        return options;
    }
    
    // Reset blank if there is no Issue Hierarchy Code and Brand Hierarchy Code
    public PageReference resetHierarchy(){
        caseObj.Issue_Hierarchy_Code__c = null;
        caseObj.Crc_Brand_Hierarchy_Code__c = null;
        selectedTraceCodeLocation = '';
        caseObj.Suspected_Tampering__c = false; 
        caseObj.Machine_Code__c = null;
        caseObj.Exp_Date__c = null;
        caseObj.DNUA_Date__c = null;
        
        caseObj.Production_date__c  = null;
        productionDate = null;
        caseObj.ValidTraceCode__c = false;
        caseObj.Mfg_Trace_code__c = null;
        caseObj.Date_Code__c = null;
        caseObj.Date_Type__c = '';
        caseObj.Date__c = null;
        dateCodeDate = '';
        caseObj.ValidUstdateCode__c  = false;
        dateCodeError = '';
        
        return null;
    }
    
    //Method to redirect if the cancel button is clicked.
    public PageReference cancelRedirect(){   
        PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+caseObj.Id);
        pageRef.setRedirect(true);
        return pageRef;             
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
        system.debug('selects ---->' + selects);
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
    }
    
    //Invoking IQOS Callout: Check the serial number in Core Services.
    public PageReference IQOSSerialNumber(){  
        Map<String,String> iqosSerialNum = new Map<String,String>();
        //Kit Mapping
        IQOSResponseClass.jsonWrapper_KM jsonRes;
        //Manufacturing Information
        IQOSResponseClass.jsonWrapper_MI jsonResMI;
        IQOSCallout ic = new IQOSCallout(); 
        String militaryTime;
        String hh;
        String mm;
        system.debug('IQOSSerialNumber caseObj ---> '+ caseObj); 
        if(caseObj.Serial_Number__c != null && caseObj.Serial_Number__c != ''){
           caseObj.Serial_Number__c = caseObj.Serial_Number__c.toUpperCase();
           caseObj.Original_Serial_Number__c = caseObj.Serial_Number__c;
            // Kit Mapping
            jsonRes = ic.csKitMappingCallout(caseObj.Serial_Number__c); 
            if(jsonRes != null){
                if(jsonRes.value.size() > 0){
                    createIL(null,jsonRes,null,null,caseObj.Serial_Number__c);
                    for(integer x = 0 ; x < jsonRes.value.size(); x++ ){
                        if(jsonRes.value[x].PackagingLevel.Id == 12){
                            iqosSerialNum.put(jsonRes.value[x].InputItemCode,jsonRes.value[x].ItemCode);
                        }
                    }           

                    if(iqosSerialNum.containskey(caseObj.Serial_Number__c) && iqosSerialNum.get(caseObj.Serial_Number__c) != null && iqosSerialNum.get(caseObj.Serial_Number__c) != ''){
                        // Manufacturing Info: Serial number have kit mapping.
                        jsonResMI = ic.csManufacturingCallout(iqosSerialNum.get(caseObj.Serial_Number__c)); 
                        if(jsonResMI != null){
                            if(jsonResMI.value.size() > 0){ 
                                iqosSuccess = true;
                                caseObj.Production_date__c = date.valueof(jsonResMI.value[0].ProductionDateTime);
                                productionDate = string.valueof(caseObj.Production_date__c);
                                iqosDate = productionDate;
                                iqosShift = jsonResMI.value[0].Shift;
                                iqosModule = jsonResMI.value[0].ProductionLine.Code;
                                iqosFactory = jsonResMI.value[0].ProductionLine.Factory.Code; //INC0035953 - Changed extracted value from Name to Code
                                iqosDateCodeLocation = jsonResMI.value[0].ProductionLine.Factory.CityRomanized;
                                
                                militaryTime = jsonResMI.value[0].ProductionDateTime;
                                hh = militaryTime.substring(11,13);
                                mm = militaryTime.substring(14,16);
                                iqosDateCodeMilitaryTime = hh + mm;
                                
                                newIQOSSerielNum = iqosSerialNum.get(caseObj.Serial_Number__c);
                                originalIQOSSerielNum = caseObj.Serial_Number__c;
                                caseObj.Serial_Number__c = newIQOSSerielNum;
                                iqosOrder = orderInfoAPI(caseObj.Serial_Number__c);
                                productRegAPI(caseObj.Serial_Number__c);
                                createIL(jsonResMI,null,null,null,caseObj.Serial_Number__c);
                                if(iqosOrder == 'success'){
                                    warrantyInformation();
                                }
                            }
                        }else {
                            caseObj.Core_Service_API_Problem__c = true;
                            String msg = 'Internal Server Error on Core Services Manufacturing Information. Please contact a Supervisor.';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                            return null;
                        }
                    }   
                    
                    else{
                         // Manufacturing Info: packaging level 12 but serial number doesn't have kit mapping.
                        jsonResMI = ic.csManufacturingCallout(caseObj.Serial_Number__c);
                        if(jsonResMI != null){
                            if(jsonResMI.value.size() > 0){ 
                           
                                iqosSuccess = true;
                                caseObj.Production_date__c = date.valueof(jsonResMI.value[0].ProductionDateTime);
                                productionDate = string.valueof(caseObj.Production_date__c);
                                iqosDate = productionDate;
                                iqosShift = jsonResMI.value[0].Shift;
                                iqosModule = jsonResMI.value[0].ProductionLine.Code;
                                iqosFactory = jsonResMI.value[0].ProductionLine.Factory.Code; //INC0035953 - Changed extracted value from Name to Code
                                iqosDateCodeLocation = jsonResMI.value[0].ProductionLine.Factory.CityRomanized;
                                
                                militaryTime = jsonResMI.value[0].ProductionDateTime;
                                hh = militaryTime.substring(11,13);
                                mm = militaryTime.substring(14,16);
                                iqosDateCodeMilitaryTime = hh + mm;
                                
                                newIQOSSerielNum = caseObj.Serial_Number__c;
                                originalIQOSSerielNum = caseObj.Serial_Number__c;
                                iqosOrder = orderInfoAPI(caseObj.Serial_Number__c);
                                productRegAPI(caseObj.Serial_Number__c);
                                createIL(jsonResMI,null,null,null,caseObj.Serial_Number__c);
                                if(iqosOrder == 'success'){
                                    warrantyInformation();
                                }
                            }
                            else{
                                iqosSuccess = false;
                            }
                        }else {
                            caseObj.Core_Service_API_Problem__c = true;
                            String msg = 'Internal Server Error on Core Services Manufacturing Information. Please contact a Supervisor.';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                            return null;
                        }
                    }
                }else{
                    // Manufacturing Info: If serial number doesn't have kit mapping.
                    jsonResMI = ic.csManufacturingCallout(caseObj.Serial_Number__c); 
                    if(jsonResMI != null){
                        if(jsonResMI.value.size() > 0){
                            
                            iqosSuccess = true;
                            caseObj.Production_date__c = date.valueof(jsonResMI.value[0].ProductionDateTime);
                            productionDate = string.valueof(caseObj.Production_date__c);
                            iqosDate = productionDate;
                            iqosShift = jsonResMI.value[0].Shift;
                            iqosModule = jsonResMI.value[0].ProductionLine.Code;
                            iqosFactory = jsonResMI.value[0].ProductionLine.Factory.Code; //INC0035953 - Changed extracted value from Name to Code
                            iqosDateCodeLocation = jsonResMI.value[0].ProductionLine.Factory.CityRomanized;
                            
                            militaryTime = jsonResMI.value[0].ProductionDateTime;
                            hh = militaryTime.substring(11,13);
                            mm = militaryTime.substring(14,16);
                            iqosDateCodeMilitaryTime = hh + mm;
                            
                            newIQOSSerielNum = caseObj.Serial_Number__c;
                            originalIQOSSerielNum = caseObj.Serial_Number__c;
                            iqosOrder = orderInfoAPI(caseObj.Serial_Number__c);
                            productRegAPI(caseObj.Serial_Number__c);
                            createIL(jsonResMI,null,null,null,caseObj.Serial_Number__c);
                            if(iqosOrder == 'success'){
                                warrantyInformation();
                            }
                        }
                        else{
                            iqosSuccess = false;
                            system.debug('---- inside else apex message-----');
                            String msg = 'Serial Number not found.';
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                            iqosOrder = orderInfoAPI(caseObj.Serial_Number__c);
                            productRegAPI(caseObj.Serial_Number__c);
                            //createIL(jsonResMI,null,null,null,caseObj.Serial_Number__c);
                            if(iqosOrder == 'success'){
                                warrantyInformation();
                            }
                            return null;
                        }
                    }else {
                        caseObj.Core_Service_API_Problem__c = true;
                        String msg = 'Internal Server Error on Core Services Manufacturing Information. Please contact a Supervisor.';
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                        return null;
                    }

                }
                //warrantyInformation();
            }else {
                caseObj.Core_Service_API_Problem__c = true;
                String msg = 'Internal Server Error on Core Services Kit Mapping. Please contact a Supervisor.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                return null;
            }
        }
            
        else{
            caseObj.Original_Serial_Number__c = '';
            iqosOrder = orderInfoAPI(caseObj.Serial_Number__c);
            productRegAPI(caseObj.Serial_Number__c);
            warrantyInformation();

        }
    
        if(iqosSuccess && iqosSuccessPR && iqosSuccessOI && jsonRes != null){
            caseObj.Core_Service_API_Problem__c = false;
        }
        return null;
    }
    //IQOS Updating case fields.
    @TestVisible
    private void updateIQOSData(){
        //caseObj.Complaint_Source__c = 'Alorica';
        //IQOS Manufacturing Information 
        system.debug('iqosSuccess --->' + iqosSuccess);
        if(iqosSuccess){
            string fChar;
            if(integer.valueof(iqosDate.substring(5,7)) < 10){
                fChar = iqosDate.substring(6,7);
            }
            else{
                fChar = iqosDate.substring(5,7);
            }
            String cDate = fChar + '/' + iqosDate.substring(8,10) + '/' + iqosDate.substring(0,4);
            caseObj.Production_date__c = date.valueOf(iqosDate);
            caseObj.DateCodeProductionDate__c = cDate;
            caseObj.DateCodeShift__c = iqosShift;
            caseObj.DateCodeUnit__c = iqosModule;
            caseObj.DateCodeRptFactory__c = iqosFactory;
            caseObj.DateCodeLocation__c = iqosDateCodeLocation;         
            caseObj.DateCodeMilitaryTime__c = iqosDateCodeMilitaryTime;     
            caseObj.Serial_Number__c = newIQOSSerielNum;
            caseObj.Original_Serial_Number__c = originalIQOSSerielNum;
        }
        //------------------------------------
        system.debug('iqosSuccessPR --->' + iqosSuccessPR);
        if(iqosSuccessPR){
            caseObj.registrationDate__c = date.valueOf(iqosRegDate);
            caseObj.registrationStatus__c = iqosRegistrationStatus;
            caseObj.CCN__c = iqosCCN;
        }
        system.debug('iqosSuccessOI --->' + iqosSuccessOI);
        if(iqosSuccessOI){
            caseObj.Purchase_Date__c = iqosPurchaseDate;
            caseObj.Total_Paid_by_Customer__c = decimal.valueof(iqosTPC);
            caseObj.First_Time_Buyer__c = iqosFTBuyer;
            caseObj.Base_Price__c = decimal.valueof(iqosBP);    
            if(decimal.valueof(iqosTPC) == 0){
                caseObj.Purchase_Price__c = decimal.valueof(iqosBP);
            }
            else{
                caseObj.Purchase_Price__c = decimal.valueof(iqosTPC);
            }
        }
    }
    //Creation of Integration Log
    public void createIL(IQOSResponseClass.jsonWrapper_MI  reqMI, IQOSResponseClass.jsonWrapper_KM reqKM, IQOSResponseClass.jsonWrapper_PR reqPR, List<IQOSResponseClass.jsonWrapper_OI> reqOI, String serialNum){
        IntegrationLog__c IL = new IntegrationLog__c();
        jsonWrapper_Response_Message RM = new jsonWrapper_Response_Message();
        //Kit Mapping
        if(reqKM != null){
            if(reqKM.value.size() > 0){
                IL.Callout__c = 'Device to Kit - Core Services';
                IL.FormName__c = 'Issues IQOS';
                IL.Response__c = JSON.Serialize(reqKM);
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                //IL.Request__c = Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/'+reqKM.value[0].InputItemCode;
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/'+serialNum;
                ILList.add(IL); 
            }
        }
        //Manufacturing Information
        if(reqMI != null){
            if(reqMI.value.size() > 0){
                IL.Callout__c = 'Manufacturing - Core Services';
                IL.FormName__c = 'Issues IQOS';
                IL.Response__c = JSON.Serialize(reqMI);
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                //IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosproductinfo/serial/'+reqMI.value[0].ItemCode;
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosproductinfo/serial/'+serialNum;
                ILList.add(IL); 
            }
        }
        //Product Registration
        if(reqPR != null){
            if(reqPR.payload.size() > 0){
                IL.Callout__c = 'Registration - Core Services';
                IL.FormName__c = 'Issues IQOS';
                IL.Response__c = JSON.Serialize(reqPR);
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                //IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosdevicereg/type/deviceId/id/'+reqPR.payload[0].deviceID;
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosdevicereg/type/deviceId/id/'+serialNum;
                ILList.add(IL); 
            }
        }
        //Order Information
        if(reqOI != null){
            if(reqOI.size() > 0){
                IL.Callout__c = 'Orders - Core Services';
                IL.FormName__c = 'Issues IQOS';
                IL.Response__c = JSON.Serialize(reqOI);
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                IL.Request__c = Label.Core_Service_URL+'/iqos/v1/orders' + ' {"type":"Device","id":' + '"' + serialNum + '"' + '}';
                ILList.add(IL); 
            }
        }
    }
    public class jsonWrapper_Response_Message{
            public integer statusCode;
            public String Message;
    }
    //Order Information
    public string orderInfoAPI(String serialNum){
        if(serialNum != null && serialNum != ''){
            //Order Information
            List<IQOSResponseClass.jsonWrapper_OI> jsonResOI;
            IQOSCallout ic = new IQOSCallout(); 
            jsonResOI = ic.csOrderInfoCallout(serialNum.toUpperCase());
            String sDate;
            date maxDate;
            List<Date> dateList = new List<Date>();
            map<string,IQOSResponseClass.jsonWrapper_OI> mapJSON = new map<string,IQOSResponseClass.jsonWrapper_OI>();
            map<string,IQOSResponseClass.jsonWrapper_OrderItems> mapOrderItems = new map<string,IQOSResponseClass.jsonWrapper_OrderItems>();
            map<string,IQOSResponseClass.jsonWrapper_OrderItems> mapOrderItemsSerialMatched = new map<string,IQOSResponseClass.jsonWrapper_OrderItems>();
            if(jsonResOI != null){
                //getting and converting the dates to salesforce date format
                if(jsonResOI.size() > 0){
                createIL(null,null,null,jsonResOI,serialNum);
                    for(integer i = 0; i < jsonResOI.size(); i++){
                        sDate = '20'+ jsonResOI[i].purchaseDate.substring(6,8) + '-' + jsonResOI[i].purchaseDate.substring(0,2) + '-'  + jsonResOI[i].purchaseDate.substring(3,5) + ' ' + '00:00:00';
                        dateList.add(date.valueof(sDate));
                    }
                }
                //sorting the dates to recent date
                if(dateList.size()>0){
                    dateList.sort();
                    maxDate = datelist.get(datelist.size()-1);
                }
                
                //getting the record with the recent date
                if(jsonResOI.size() > 0){
                    for(integer i = 0; i < jsonResOI.size(); i++){
                        sDate = '20'+ jsonResOI[i].purchaseDate.substring(6,8) + '-' + jsonResOI[i].purchaseDate.substring(0,2) + '-'  + jsonResOI[i].purchaseDate.substring(3,5) + ' ' + '00:00:00';
                        if(date.valueof(sDate) == maxDate)
                            mapJSON.put(sDate,jsonResOI[i]);
                    }
                }
                
                //getting the line items with the serial number matched
                if(mapJSON.values().size() > 0){
                    system.debug('mapJSON.values()[0].OrderItems --->' + mapJSON.values()[0].OrderItems);
                    for(IQOSResponseClass.jsonWrapper_OrderItems oi : mapJSON.values()[0].OrderItems){
                        system.debug('oi.serialNumbers[0].serialNumber -->' + oi.serialNumbers[0].serialNumber);
                        system.debug('serialNum -->' + serialNum);
                        
                        if(oi.serialNumbers[0].serialNumber == serialNum){
                            mapOrderItemsSerialMatched.put(serialNum, oi);
                        }else{
                            mapOrderItems.put(oi.serialNumbers[0].serialNumber, oi);
                        }
                    }
                }
                system.debug('mapOrderItemsSerialMatched --->' + mapOrderItemsSerialMatched.values().size());
                system.debug('mapOrderItems --->' + mapOrderItems.values().size());
                //Serial Number Matched
                if(mapOrderItemsSerialMatched.values().size()>0){
                    system.debug('----Inside mapOrderItemsSerialMatched----');
                    iqosSuccessOI = true;
                    //iqosPurchaseDate = mapJSON.values()[0].purchaseDate;
                    iqosPurchaseDate = maxDate;
                    iqosTPCustomer = mapOrderItemsSerialMatched.values()[0].totalPaidByCustomer;
                    iqosFTBuyer = mapOrderItemsSerialMatched.values()[0].firstTimeBuyer;
                    iqosBasePrice = mapOrderItemsSerialMatched.values()[0].basePrice;
                    
                    caseObj.Purchase_Date__c = iqosPurchaseDate;
                    caseObj.Total_Paid_by_Customer__c = iqosTPCustomer;
                    iqosTPC = string.valueof(caseObj.Total_Paid_by_Customer__c);
                    caseObj.First_Time_Buyer__c = iqosFTBuyer;
                    caseObj.Base_Price__c = iqosBasePrice;
                    iqosBP = string.valueof(caseObj.Base_Price__c);
                    
                    if(iqosTPCustomer == 0){
                        caseObj.Purchase_Price__c = iqosBasePrice;
                    }
                    else{
                        caseObj.Purchase_Price__c = iqosTPCustomer;
                    } 
                 }
                //Serial Number not matched get the first value on the list
                else if(mapOrderItems.values().size()>0){
                    system.debug('----Inside mapOrderItems----');
                    iqosSuccessOI = true;
                    //iqosPurchaseDate = mapJSON.values()[0].purchaseDate;
                    iqosPurchaseDate = maxDate;
                    iqosTPCustomer = mapOrderItems.values()[0].totalPaidByCustomer;
                    iqosFTBuyer = mapOrderItems.values()[0].firstTimeBuyer;
                    iqosBasePrice = mapOrderItems.values()[0].basePrice;
                    
                    caseObj.Purchase_Date__c = iqosPurchaseDate;
                    caseObj.Total_Paid_by_Customer__c = iqosTPCustomer;
                    iqosTPC = string.valueof(caseObj.Total_Paid_by_Customer__c);
                    caseObj.First_Time_Buyer__c = iqosFTBuyer;
                    caseObj.Base_Price__c = iqosBasePrice;
                    iqosBP = string.valueof(caseObj.Base_Price__c);
                    
                    if(iqosTPCustomer == 0){
                        caseObj.Purchase_Price__c = iqosBasePrice;
                    }
                    else{
                        caseObj.Purchase_Price__c = iqosTPCustomer;
                    }
                }
                else{
                    iqosSuccessOI = false;
                    caseObj.Purchase_Date__c = null;
                    caseObj.Total_Paid_by_Customer__c = null;
                    iqosTPC ='';
                    caseObj.First_Time_Buyer__c = false;
                    caseObj.Base_Price__c = null;
                    caseObj.Purchase_Price__c = null;
                    iqosBP = '';
                }
            }else{
                iqosSuccessOI = false;
                caseObj.Purchase_Date__c = null;
                caseObj.Total_Paid_by_Customer__c = null;
                iqosTPC ='';
                caseObj.First_Time_Buyer__c = false;
                caseObj.Base_Price__c = null;
                caseObj.Purchase_Price__c = null;
                iqosBP = '';
                caseObj.Core_Service_API_Problem__c = true;
                String msg = 'Internal Server Error on Core Services Orders. Please contact a Supervisor.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
                return 'error';
            }
            return 'success';
        }else{
            iqosSuccessOI = false;
            caseObj.Purchase_Date__c = null;
            caseObj.Total_Paid_by_Customer__c = null;
            iqosTPC ='';
            caseObj.First_Time_Buyer__c = false;
            caseObj.Base_Price__c = null;
            caseObj.Purchase_Price__c = null;
            iqosBP = '';    
            return null;            
        }
    } 
    //Product Registration
    public void productRegAPI(String serialNum){
        if(serialNum != null && serialNum != ''){
             //Product Registration
            IQOSResponseClass.jsonWrapper_PR jsonResPR;
            IQOSCallout ic = new IQOSCallout(); 
            jsonResPR = ic.csProductRegCallout(caseObj.Serial_Number__c);
            List<Date> dateList = new List<Date>();
            date maxDate;
            map<string,IQOSResponseClass.jsonWrapper_Payload> mapJSON = new map<string,IQOSResponseClass.jsonWrapper_Payload>();
            if(jsonResPR != null){
                if(jsonResPR.payload.size() > 0){
                    if(jsonResPR.Status.statusCode == '200'){
                        for(integer i = 0 ; i < jsonResPR.payload.size(); i++){
                            dateList.add(date.valueOf(jsonResPR.payload[i].registrationDate));
                        }
                    }
                    //sorting the dates to recent date
                    if(dateList.size()> 0){
                        dateList.sort();
                        maxDate = datelist.get(datelist.size()-1);
                    }
                    system.debug('maxDate --->' + maxDate);
                    
                    //getting the record with the recent date
                    if(maxDate != null){
                        for(integer i = 0; i < jsonResPR.payload.size(); i++){
                            if(date.valueof(jsonResPR.payload[i].registrationDate) == maxDate)
                                mapJSON.put(jsonResPR.payload[i].registrationDate,jsonResPR.payload[i]);
                        }
                    }
                    system.debug('mapJSON --->' + mapJSON);
                    if(mapJSON.values().size() > 0){
                        createIL(null,null,jsonResPR,null,serialNum);
                        iqosSuccessPR = true;
                        iqosCCN = mapJSON.values()[0].ccn;
                        iqosRegistrationDate = mapJSON.values()[0].registrationDate;
                        iqosRegistrationStatus = mapJSON.values()[0].registrationStatus;
                        
                        caseObj.registrationDate__c = date.valueOf(iqosRegistrationDate);
                        iqosRegDate = string.valueof(caseObj.registrationDate__c);
                        caseObj.registrationStatus__c = iqosRegistrationStatus;
                        caseObj.CCN__c = iqosCCN;
                    }
                    else{
                        iqosSuccessPR = false;
                        caseObj.registrationDate__c = null;
                        iqosRegDate = null;
                        caseObj.registrationStatus__c = '';
                        caseObj.CCN__c = '';
                    }
                }
                else{
                        iqosSuccessPR = false;
                        caseObj.registrationDate__c = null;
                        iqosRegDate = null;
                        caseObj.registrationStatus__c = '';
                        caseObj.CCN__c = '';
                }
            }else{
                iqosSuccessPR = false;
                caseObj.registrationDate__c = null;
                iqosRegDate = null;
                caseObj.registrationStatus__c = '';
                caseObj.CCN__c = '';
                caseObj.Core_Service_API_Problem__c = true;
                String msg = 'Internal Server Error on Core Services Registration. Please contact a Supervisor.';
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.INFO, msg));
            }
        }
        else{
            iqosSuccessPR = false;
            caseObj.registrationDate__c = null;
            iqosRegDate = null;
            caseObj.registrationStatus__c = '';
            caseObj.CCN__c = '';
        }
    }
    
    // Warranty Information
    public void warrantyInformation(){
        decimal warrantyBD;
        decimal warrantyED;
        Integer warrantDaysExp;
        List<Variable_Data__c> vdList = [Select Variable_Number__c, Variable_Name__c from Variable_Data__c where Variable_Name__c = 'Warranty Base Days' OR Variable_Name__c = 'Warranty Extended Days'];
        if(vdList.size() > 0){
            for(Variable_Data__c vd : vdList){
                if(vd.Variable_Name__c == 'Warranty Base Days'){
                    warrantyBD = vd.Variable_Number__c;
                }
                if(vd.Variable_Name__c == 'Warranty Extended Days'){
                    warrantyED = vd.Variable_Number__c;
                }
            }
        }
        
        if(caseObj.registrationStatus__c != null && caseObj.registrationStatus__c != ''){
            caseObj.Warranty_Start_Date__c = caseObj.Purchase_Date__c;
            iqosWSD = string.valueof(caseObj.Warranty_Start_Date__c);
            if(caseObj.registrationStatus__c == 'Active' && caseObj.First_Time_Buyer__c == true && (caseObj.CCN__c != null && caseObj.CCN__c != '')){
                if(caseObj.Purchase_Date__c != null){
                    caseObj.Warranty_Expiration_Date__c = caseObj.Purchase_Date__c + integer.valueof(warrantyBD) + integer.valueof(warrantyED);
                    iqosWED = string.valueof(caseObj.Warranty_Expiration_Date__c);
                }
            }else{
                if(caseObj.Purchase_Date__c != null){
                    caseObj.Warranty_Expiration_Date__c = caseObj.Purchase_Date__c + integer.valueof(warrantyBD);
                    iqosWED = string.valueof(caseObj.Warranty_Expiration_Date__c);
                }
            }
            
            if(caseObj.Incident_Date__c != null){
                //warrantDaysExp = caseObj.Warranty_Expiration_Date__c.daysBetween(caseObj.Incident_Date__c);
                warrantDaysExp = caseObj.Incident_Date__c.daysBetween(caseObj.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    caseObj.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else{
                    caseObj.Warranty_Status__c = 'UNDER WARRANTY';
                }
            }
            else if(caseObj.CreatedDate__c != null && caseObj.CreatedDate__c !=''){
                String cDate = caseObj.CreatedDate__c.substring(6,10) + '-' + caseObj.CreatedDate__c.substring(0,2) + '-' + caseObj.CreatedDate__c.substring(3,5);
                //warrantDaysExp = caseObj.Warranty_Expiration_Date__c.daysBetween(date.valueof(cDate));
                warrantDaysExp = date.valueof(cDate).daysBetween(caseObj.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    caseObj.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else{
                    caseObj.Warranty_Status__c = 'UNDER WARRANTY';
                }
            }
            //New issue created
            else if(caseObj.CreatedDate__c == null || caseObj.CreatedDate__c == ''){
                //warrantDaysExp = caseObj.Warranty_Expiration_Date__c.daysBetween(System.today());
                warrantDaysExp = System.today().daysBetween(caseObj.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    caseObj.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else{
                    caseObj.Warranty_Status__c = 'UNDER WARRANTY';
                }
            }
        }else{
            caseObj.Warranty_Status__c = '';
            caseObj.Warranty_Expiration_Date__c = null;
            iqosWED = '';
            caseObj.Warranty_Start_Date__c = null;
            iqosWSD = '';
        }
    }
}