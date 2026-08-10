public class ConsumerSearchController {    
   
    public Id tranid{get;set;}    
    public string issueid {get;set;}
    public string tranSelectedValue {get;set;}
    public Contact conObj{get;set;}    
    public List<Contact> conlst{get;set;}
    public Boolean isConsumerBtnVisible{get;set;}
    public Boolean isIssueBtnVisible{get;set;}
    public Boolean RadioDisplay{get;set;}
    public Boolean isAgeZipMappingVerified{get;set;}
    public Boolean readOnlyCityState{get;set;}
    AcxiomClasses.ConsumerFinalResponse searchResponseData; 
    
    @TestVisible String FormName;
    public Boolean isSearch {get;set;}
    public Transaction_Management__c tranObj{get;set;}
    private string customerNumber;
    public string iqosid {get;set;}
    
    
    /* Constructor for Controller ConsumerSearchController. */
    public ConsumerSearchController(ApexPages.StandardController stdController) {       
        isConsumerBtnVisible=true;
        isIssueBtnVisible = true;
        isSearch = false;
        RadioDisplay = false;
        isAgeZipMappingVerified = false;
        readOnlyCityState = true;
        conObj=(contact)stdController.getRecord();
        conObj.Country__c = 'United States';
        customerNumber = '';
        conlst=new List<Contact>(); 
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');// Get Contact ID from current Page.
        if(counter != null) {
            tranid = counter.getValue();
            System.debug('I am cookie ' + tranid);
        }else{
            tranid = ApexPages.currentPage().getParameters().get('tranid');// For Spring release '20
            System.debug('I am URL ' + tranid);
        }
        if(tranid != null){
            tranObj = new Transaction_Management__c();
            tranObj = [Select id, Contact__c,Operating_Company__c,Comments__c from Transaction_Management__c where id =:tranid]; //Query for Operating Company.          
            String RecordTypeidObj = customerRecordTypeHelper.getCustomerRecordType(tranid );               
            if(RecordTypeidObj != ''){
               conObj.RecordTypeId = RecordTypeidObj;
            }
            
            /* Validation while customer calling and get Number from current page.*/
            if(ApexPages.currentPage().getParameters().get('customerNumber') != null && ApexPages.currentPage().getParameters().get('customerNumber') != ''){
                customerNumber = ApexPages.currentPage().getParameters().get('customerNumber');
                conObj.Phone = customerNumber;
                conObj.Country__c = null;
                isConsumerBtnVisible = true;
                isIssueBtnVisible = true;
                Search();
            }
        }
        init();     
    }
    
    /*INIT method for initialiaze and get field value for consumer's field from Search Page on Record Creation.*/
     public void init(){
            
        if(ApexPages.currentPage().getParameters().get('Fname') != null && ApexPages.currentPage().getParameters().get('Fname') != '')
            conObj.FirstName = ApexPages.currentPage().getParameters().get('Fname');            
        
        if(ApexPages.currentPage().getParameters().get('Lname') != null && ApexPages.currentPage().getParameters().get('Lname') != '')   
            conObj.LastName = ApexPages.currentPage().getParameters().get('Lname');
        
        if(ApexPages.currentPage().getParameters().get('Addr1') != null && ApexPages.currentPage().getParameters().get('Addr1') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('Addr1');
         
        if(ApexPages.currentPage().getParameters().get('Addr2') != null && ApexPages.currentPage().getParameters().get('Addr2') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('Addr2');

        if(ApexPages.currentPage().getParameters().get('City') != null && ApexPages.currentPage().getParameters().get('City') != '')
            conObj.City__c = ApexPages.currentPage().getParameters().get('City');
    
        if(ApexPages.currentPage().getParameters().get('State') != null && ApexPages.currentPage().getParameters().get('State') != '')
            conObj.State__c = ApexPages.currentPage().getParameters().get('State');
        
        if(ApexPages.currentPage().getParameters().get('dob') != null && ApexPages.currentPage().getParameters().get('dob') != ''){
            string dob = ApexPages.currentPage().getParameters().get('dob');
            if(dob.indexOf('-') != -1){                
                String [] dobString = dob.split('T');
                String [] dobString1 = dobString[0].split('-');
                date d = Date.newInstance(Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]), Integer.ValueOf(dobString1[2]));
                conObj.Birthdate1__c = d;
            }else{
                String [] dobString1 = dob.split('/'); 
                date d = Date.newInstance(Integer.ValueOf(dobString1[2]), Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]));
                conObj.Birthdate1__c = d;
            }
        }
          
        if(ApexPages.currentPage().getParameters().get('zip') != null && ApexPages.currentPage().getParameters().get('zip') != '')
            conObj.Zip_Code__c = ApexPages.currentPage().getParameters().get('zip');
    
        if(ApexPages.currentPage().getParameters().get('email') != null && ApexPages.currentPage().getParameters().get('email') != '')
            conObj.Email = ApexPages.currentPage().getParameters().get('email');
        
        if(ApexPages.currentPage().getParameters().get('country') != null && ApexPages.currentPage().getParameters().get('country') != ''){
            conObj.Country__c = ApexPages.currentPage().getParameters().get('country');
        }
        
        if(ApexPages.currentPage().getParameters().get('phone') != null && ApexPages.currentPage().getParameters().get('phone') != '')
            conObj.Phone = ApexPages.currentPage().getParameters().get('phone');    
            
        ageVerifyZipMap();      
    }
      
    //Acxiom Full Search.   
    public void getfullsearchList(){
        isAgeZipMappingVerified =false;
        
        //Create the JSON body for the request to be sent
        JSONGenerator genRequest = JSON.createGenerator(true);
        //get custom session Id
        String sessionId = getSessionID();
        
        genRequest.writeStartObject();
        genRequest.writeStringField('OwnerCd','');
        genRequest.writeStringField('ListCd','');
        genRequest.writeStringField('Title','');
        genRequest.writeStringField('FirstName',conObj.FirstName.trim());
        genRequest.writeStringField('MiddleName','');
        genRequest.writeStringField('LastName',conObj.LastName.trim());
        genRequest.writeStringField('Suffix','');
        genRequest.writeStringField('AddressLine1',conObj.Street_Address__c.trim());
        genRequest.writeStringField('AddressLine2','');
        genRequest.writeStringField('City',conObj.city__c.trim());
        genRequest.writeStringField('State',conObj.state__c.trim());
        genRequest.writeStringField('Zip',conObj.Zip_Code__c);
        genRequest.writeStringField('ZipPlus4','');
        Datetime yourDate = conObj.BirthDate1__c;
        String dateOutput = yourDate.format('MM/dd/YYYY');
        genRequest.writeStringField('DateOfBirth', dateOutput);
        genRequest.writeStringField('Gender','');
        genRequest.writeFieldName('DataFlags');
            genRequest.writeStartObject();    
            genRequest.writeStringField('SurveyResponseFlag','N');
            genRequest.writeStringField('FullViewFlag','N');
            genRequest.writeStringField('ChannelContactFlag','Y');
                genRequest.writeFieldName('ChannelTypeDataCd');
                genRequest.writeStartArray();
                    genRequest.writeStartObject(); 
                    genRequest.writeStringField('ChannelTypeInputFlag','ALL');
                    genRequest.writeEndObject();
                genRequest.writeEndArray();
            genRequest.writeStringField('WebsiteFlag','N');
            genRequest.writeStringField('RecentScoresFlag','N');
            genRequest.writeStringField('QualificationFlag','Y');
            genRequest.writeStringField('AvailabilityFlag','N');
            genRequest.writeStringField('PreferenceFlag','N');
            genRequest.writeStringField('SubscriptionFlag','N');
            genRequest.writeStringField('OwnerListFlag','N');
            genRequest.writeStringField('AuthenticationFlag','Y');
            genRequest.writeEndObject();
        genRequest.writeStringField('SessionId', sessionId);
        genRequest.writeEndObject();
      
        String searchRequest = genRequest.getAsString();
        System.debug('SearchRequest Full: ' + searchRequest);
        
        searchResponseData = new AcxiomClasses.ConsumerFinalResponse();
        searchResponseData=AcxiomServices.FullSearchLookupRequest(searchRequest,tranid,FormName);
        if(searchResponseData.RequestId == null || searchResponseData.RequestId == ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,'Server Error, Please try again'));
        }else if(searchResponseData.CCN == ''){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error,searchResponseData.ConsumerMessage));
        }
        TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
        mgmtHelper.createTransactionMgmtHistoryRecord('FULL_SEARCH','');
        searchResult(searchResponseData);
    }

    //Display Search Result, retrieved from Acxiom full search.
    public List<contact> searchResult( AcxiomClasses.ConsumerFinalResponse searchResponseData1){
        Contact con=new Contact();
        con.RequestId__c=searchResponseData1.RequestId;
        con.StatusCode__c=searchResponseData1.StatusCode;
        con.StatusMessage__c=searchResponseData1.StatusMessage;     
        conlst.add(con);
        if(searchResponseData1.CCN == null || searchResponseData1.CCN == ''){          
            conlst.clear(); 
        }else{
            con.FirstName=searchResponseData1.Fname;
            con.LastName=searchResponseData1.Lname;
            con.City__c=searchResponseData1.city;
            con.State__c=searchResponseData1.state;
            con.Zip_Code__c=searchResponseData1.zip;
            con.Street_Address__c=searchResponseData1.Addr1;
            con.Apt_Lot__c = searchResponseData1.Addr2;
            con.ccn__c=searchResponseData1.CCN;
            if(searchResponseData1.DateOfBirth != null && searchResponseData1.DateOfBirth != ''){
                String [] dobString= searchResponseData1.DateOfBirth.split('T');
                String [] dobString1 =dobString[0].split('-'); 
                date d = Date.newInstance(Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]), Integer.ValueOf(dobString1[2]));
                con.Birthdate1__c = d;
            }
        }  
        return conlst;
    }
    
    //clear Search result.
    public PageReference Clear() {
        issueid = '';
        iqosid = '';
        isConsumerBtnVisible = true;
        isIssueBtnVisible  = true;
        isSearch  = false;
        RadioDisplay = false;
        tranSelectedValue  = '';
        conObj = new Contact();
        conlst.clear(); 
        conObj.Country__c = 'United States'; 
        readOnlyCityState = true; 
        return null;
    }
    
    //Method to call Melissa webservice to get state and city for a zip.
    public PageReference getCityState(){
        conObj.city__c = '';
        conObj.state__c = '';
        if(conObj.Country__c != Label.Country){
            readOnlyCityState = false;
        }
        if(conObj.Country__c == Label.Country && conObj.Zip_Code__c != null && conObj.Zip_Code__c != ''){
            if(conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() ||  conObj.Zip_Code__c == '00000'){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                readOnlyCityState = true;
                return null;   
            }
            MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
            zipLookup = MelissaServices.ZipLookupServiceRequest(conObj.Zip_Code__c,tranid,FormName,'','');
            if(zipLookup ==  null){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State'));
                readOnlyCityState = false;
            }else{
                if(zipLookup.ErrorString != null && zipLookup.ErrorString != ''){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                    readOnlyCityState = true;
                }else{
                    if(!zipLookup.Results.isEmpty() && zipLookup.Results.size() >0){        
                        conObj.city__c = zipLookup.Results[0].Address.City.toUpperCase();
                        conObj.state__c = zipLookup.Results[0].Address.State.toUpperCase();                        
                        readOnlyCityState = true;
                        if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && conObj.State__c != null && conObj.State__c != '' && conObj.Birthdate1__c != null){
                            ageVerifyZipMap(); 
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State')); 
                        readOnlyCityState = false;                                               
                    }                        
                }                     
            } 
        }                
        return null;   
    }
    
    //Method to verify the Consumer based on the Age-Zip mapping.
    public void ageVerifyZipMap(){
        if(conObj.Zip_Code__c != null && conObj.State__c != null && conObj.State__c != '' && conObj.Birthdate1__c != null){
            ageMapping obj = new ageMapping();
            ageMapping.ageData ageObj = new ageMapping.ageData();
            ageObj = obj.FetchDataZip(conObj.Zip_Code__c, conObj.State__c, conObj.Birthdate1__c); 
            if(!ageObj.AgeVerify){                
               if(ageObj.StateAge == null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Age Zip/State Mapping Missing'));
               else
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer did not meet minimum age requirement. Consumer  age is '+ageObj.ConsumerAge +', the age restriction for the state/zip code is '+ ageObj.StateAge +'.  No action should be taken in the system.')); 
               isConsumerBtnVisible=true;
               isIssueBtnVisible = true;        
            }else{
                if(isSearch){
                    isConsumerBtnVisible=false;
                }               
                isIssueBtnVisible = false;            
            }
        }
    }
    
    //Method to perform local search.
    public PageReference Search(){
        conlst.clear(); 
        RadioDisplay = false;
        try{
        if(checkContact()){
            return null;
        }
        
        if(conObj.Country__c != null && conObj.Country__c == Label.Country && conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && (conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() ||  conObj.Zip_Code__c == '00000')){
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
            readOnlyCityState = true;
            return null;   
        }        
        
        if(conObj.LastName != null && conObj.LastName != '' && conObj.LastName.trim() != '' && conObj.LastName.length()< 2){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter at least 2 characters for Last Name.'));
            return null;
        }
        
        if(conObj.CCN__c != null && conObj.CCN__c!='' && conObj.CCN__c.length()<3){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid CCN #.'));
            return null; 
        }
        
        if(conObj.Phone != null && conObj.Phone.length()<10 && conObj.Phone!=''){            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Not a valid 10-digit phone number.'));
            return null;            
        }
        
        if(conObj.email != null &&  conObj.email!='' && !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', conObj.email))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter valid email')); 
            return null;
        }
        
        String query = 'select id,Name,CustomerID__c,Email,FirstName,LastName,ccn__c,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,BirthDate1__c from Contact ';    
        String queryCondition = '';
        if((conObj.CustomerID__c == null || conObj.CustomerID__c == '') && (conObj.ccn__c == null || conObj.ccn__c == '') && (conObj.Email == null || conObj.Email == '')&&(conObj.Phone == null || conObj.Phone == '') && (issueid == null || issueid == '') && (tranSelectedValue == null || tranSelectedValue == '')&& (conObj.LastName == null || conObj.LastName == '' || conObj.BirthDate1__c == null) && (conObj.LastName == null || conObj.LastName == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '') && (iqosid == null || iqosid == '')
          && conObj.Email != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Mandatory Fields: Please enter LN-Zip Code, LN-DOB, Issue #, CCN #, Customer ID, Phone #,Transaction #, or Email Address'));
            return null;
        }else{
            isSearch = true;
            boolean newSearchType = true;
            if(conObj.Country__c == Label.Country){
                ageVerifyZipMap();
            }else if(conObj.Country__c != null){
                isConsumerBtnVisible = false;
                isIssueBtnVisible = false;
            }
            String ConsumerId = '';
            String ConName = '';
            string soslCondition = '';
           
            string whereCondition = '';
          
            if(conObj.Phone != null && conObj.Phone != ''){
                newSearchType = false;
                //if(soslCondition != '') {soslCondition += ' AND '+conObj.phone;}
                //else {soslCondition += conObj.phone;}
                Pattern nonAlphanumeric = Pattern.compile('[^0-9]');
                Matcher matcher = nonAlphanumeric.matcher(conObj.Phone);
                system.debug(matcher.replaceAll(''));                
              
                
                if(soslCondition != '') {soslCondition += ' AND ('+conObj.phone+' or '+matcher.replaceAll('')+')';}
                else {soslCondition += '('+conObj.phone+' or '+matcher.replaceAll('')+')';} 
            }
            
            if(conObj.FirstName  != null && conObj.FirstName  != ''){
               //if(soslCondition != '') {soslCondition += ' AND '+conObj.FirstName.trim();}
               //else {soslCondition = conObj.FirstName.trim();}
               if(soslCondition != '') {soslCondition += ' AND '+conObj.FirstName.trim()+'*';}
               else {soslCondition = conObj.FirstName.trim()+'*';}

            }
            
            if(conObj.LastName  != null && conObj.LastName  != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.LastName.trim()+'*';}
                else {soslCondition = conObj.LastName.trim()+'*';}
            }
            if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Zip_Code__c ;}
                else {soslCondition += conObj.Zip_Code__c ;}
            }
            
            if(conObj.Street_Address__c != null && conObj.Street_Address__c != ''){
                if(soslCondition != '') {soslCondition += ' AND '+conObj.Street_Address__c.trim() ;}
                else {soslCondition += conObj.Street_Address__c.trim() ;}
            }
            
            if(conObj.Country__c != null && conObj.Country__c != ''){
                if(whereCondition != '') {whereCondition +=  ' and Country__c = \'' + conObj.Country__c.trim() + '\'';}
                else {whereCondition =  ' Where Country__c = \'' + conObj.Country__c.trim() + '\'';}
            }
            String dateOutput = '';
            String [] dateSplit;
            string dateOutput1 = '';
            if(conObj.BirthDate1__c != null){
                Date yourDate = conObj.Birthdate1__c;
                dateOutput = yourDate.format();
                dateSplit = dateOutput.split('/');
                dateOutput1 = '';
                if(dateSplit != null && dateSplit.size() == 3){
                   if(dateSplit[0].length() == 1)
                        dateOutput1 += '0'+dateSplit[0];
                    else
                        dateOutput1 += dateSplit[0];
                    
                    if(dateSplit[1].length() == 1)
                        dateOutput1 += '/0'+dateSplit[1];
                    else
                        dateOutput1 += '/0'+dateSplit[1];
                   
                   dateOutput1 += '/'+dateSplit[2];
                }
                
                if(soslCondition != '') {soslCondition += ' AND ('+dateOutput+' or '+dateOutput1+')';}
                else {soslCondition += '('+dateOutput+' or '+dateOutput1+')';}
            }
            
            if(conObj.CustomerID__c != null && conObj.CustomerID__c != ''){
                newSearchType = false;
                string custIdStr = conObj.CustomerID__c.trim();
                
                List<Contact> conObjlst = new List<Contact>([Select Name From Contact where CustomerID__c =: custIdStr]);
                if(!conObjlst.isEmpty() && conObjlst.size() >0){
                    soslCondition = conObjlst[0].Name;
                }else{
                    newSearchType = true;
                } 
                
                if(whereCondition != '') {whereCondition +=  ' and CustomerID__c = \'' + custIdStr+'\'';}
                else {whereCondition =  ' Where CustomerID__c =\'' + custIdStr+'\'';}
            }
            
            if(issueid != null && issueid != ''){
                newSearchType = false;
                string issueIdStr = issueid.trim();
                List<Case> caseObj = new List<Case>([Select id, Contactid, Contact.Name, Contact.CustomerID__c from Case where CaseNumber__c =: issueidStr]);
                if(!caseObj.isEmpty() && caseObj.size() >0 && caseObj[0].Contactid != null){
                   ConsumerId = caseObj[0].Contact.CustomerID__c;    
                   ConName = caseObj[0].Contact.Name;
                }else{
                    newSearchType = true;
                }
            }
            //IOQS-----------------------
            if(iqosid != null && iqosid != ''){
                newSearchType = false;
                string iqosIdStr = iqosid.trim();
                List<Case> caseObj = new List<Case>([Select id, Contactid, Contact.Name, Contact.CustomerID__c from Case where IQOS_Reference_ID__c =: iqosIdStr]);
                if(!caseObj.isEmpty() && caseObj.size() >0 && caseObj[0].Contactid != null){
                   ConsumerId = caseObj[0].Contact.CustomerID__c;    
                   ConName = caseObj[0].Contact.Name;
                }else{
                    newSearchType = true;
                }          
            }
            //IOQS-----------------------
            if(tranSelectedValue != null && tranSelectedValue != ''){
                newSearchType = false;
                string transIdStr = tranSelectedValue.trim();
                List<Transaction_Management__c> transactionObj = new List<Transaction_Management__c>([Select id, Contact__c,Contact__r.CustomerID__c, Contact__r.Name from Transaction_Management__c where Name =: transIdStr]);
                if(!transactionObj.isEmpty() && transactionObj.size() >0 && transactionObj[0].Contact__c != null){
                   ConsumerId = transactionObj[0].Contact__r.CustomerID__c;
                   ConName = transactionObj[0].Contact__r.Name;
                }else{
                    newSearchType = true;
                } 
            }
            
            if(ConsumerId != null && ConsumerId != ''){
                newSearchType = false;
                string custIdStr = ConsumerId.trim();
                soslCondition = ConName; 
                whereCondition = ' Where CustomerID__c = \'' + custIdStr+ '\'';
            }
            
            if(conObj.ccn__c != null && conObj.ccn__c != ''){
                newSearchType = false;
                string ccnIdStr = conObj.ccn__c.trim();
                //if(soslCondition != '') {soslCondition += ' AND '+ccnIdStr;}
                //else{
                soslCondition = ccnIdStr;
                //}
            }  
            
            if(conObj.Email != null && conObj.Email != ''){
                newSearchType = false;
                //if(soslCondition != '') {soslCondition += ' AND '+conObj.Email.trim() ;}
                //else { 
                    soslCondition = conObj.Email.trim();
                //}
            }
                        
            if(whereCondition != ''){
                whereCondition +=  ' and RecordType.Name = \'Consumer\' and Active__c = true ';
            }else{
                whereCondition =  ' Where RecordType.Name = \'Consumer\' and Active__c = true ';
            }
            
            String soslCondition2 = '';
            //Start: RITM1098283 - SCR 21-04-29 2021 Customer Search Enhancement
            //Do the search only if Street Address is not filled && CCN, Phone Number, Email, Issue Number, and Customer ID are not being searched
            if(conObj.Street_Address__c == null || conObj.Street_Address__c == ''){
                if((conObj.LastName != null && conObj.LastName  != '') && (conObj.Birthdate1__c != null)
                    && (conObj.Zip_Code__c != null && conObj.Zip_Code__c != '') && (conObj.FirstName != null && conObj.FirstName  != '')){
                    soslCondition2 = '(' + conObj.FirstName.trim()+'* AND ' + conObj.LastName.trim()+ '* AND ('+dateOutput+' or '+dateOutput1+') AND ' + conObj.Zip_Code__c + ')';
                }
                if((conObj.LastName != null && conObj.LastName  != '') && (conObj.Birthdate1__c != null )){
                    if(soslCondition2 != '') {soslCondition2 += ' OR (' + conObj.LastName.trim()+ '* AND ('+dateOutput+' or '+dateOutput1+'))';}
                    else {soslCondition2 += '('+ conObj.LastName.trim()+ '* AND ('+dateOutput+' or '+dateOutput1+'))';}
                }
                if((conObj.LastName != null && conObj.LastName  != '') && (conObj.Zip_Code__c != null && conObj.Zip_Code__c != '')){
                    if(soslCondition2 != '') {soslCondition2 += ' OR (' + conObj.LastName.trim()+'* AND ' + conObj.Zip_Code__c + '))';}
                    else {soslCondition2 += '('+ conObj.LastName.trim()+'* AND ' + conObj.Zip_Code__c + ')';}    
                }  
                whereCondition =  ' Where RecordType.Name = \'Consumer\' and Active__c = true ';
            }          
            //End: RITM1098283 - SCR 21-04-29 2021 Customer Search Enhancement
            
            if(soslCondition != null && soslCondition != ''){
                if(soslCondition.trim().length() < 3){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid data.'));
                    return null;
                }
                
                String firstSearch = '', secondSearch = '';
                boolean secSrch = false;
                firstSearch = escapeMetaCharacters(soslCondition);
                secondSearch = escapeMetaCharacters(soslCondition2);
                
                if(newSearchType)
                {
                    firstSearch = secondSearch;    
                }
                List<Contact> contactData = new List<Contact>();
                List<List <sObject>> searchList = new List<List <sObject>>();
                String searchQuery = '';
                if(!String.isEmpty(firstSearch)){
                    //soslCondition = String.escapeSingleQuotes(soslCondition);
                    searchQuery = 'FIND {'+ firstSearch +'} IN ALL FIELDS ';
                    searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,Email,CCN__c,CustomerType__c,FirstName,LastName,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,Birthdate1__c,DNU__c';
                    if(whereCondition  != null && whereCondition != '')
                        searchQuery += whereCondition ; 
                    searchQuery += ')';
                    System.debug('test searchQuery '+searchQuery);
                    searchList = search.query(searchQuery);
                    contactData= ((List<contact>)searchList[0]);  
                    System.debug('ContactData count: ' + contactData.size());
                }
                //If result of FirstSearch is empty, do the second search
                if(contactData.isEmpty()){
                    if(!String.isEmpty(secondSearch)){
                        secSrch = true;
                        searchQuery = 'FIND {'+ secondSearch +'} IN ALL FIELDS ';
                        searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,Email,CCN__c,CustomerType__c,FirstName,LastName,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,Birthdate1__c,DNU__c';
                        if(whereCondition  != null && whereCondition != '')
                            searchQuery += whereCondition ; 
                        searchQuery += ')';
                        System.debug('test searchQuery2 '+searchQuery);
                        searchList = search.query(searchQuery);
                        contactData= ((List<contact>)searchList[0]);  
                        System.debug('ContactData count: ' + contactData.size());
                    }
                }
                if(!contactData.isEmpty()){
                    for(Contact con :contactData){
                        Contact conInner = con;
                        //JAD: RITM0441447 - Implementation for SCR 20-06-03 2020 Wirecard Virtual Pay
                        if(conObj.Email  != null && conObj.Email  != '' && conInner.id != null  && !secSrch){
                            if(conObj.Email.trim() == conInner.Email.trim())
                                conInner = con;
                            else
                                conInner = new Contact();
                        }
                        else {
                            if(conObj.FirstName  != null && conObj.FirstName  != ''){
                                //if(conObj.FirstName.trim() == conInner.FirstName.trim())
                                //if( conInner.FirstName.trim().startsWithIgnoreCase(conObj.FirstName.trim())){
                                    conInner = con;
                                //}else
                                //    conInner = new Contact();
                            }
                            
                            if(conObj.LastName  != null && conObj.LastName  != '' && conInner.id != null){   
                                if (!newSearchType && !secSrch) conInner = con;
                                else if(conObj.CCN__c != '' && !secSrch) conInner = con;
                                else if(conInner.LastName.trim().startsWithIgnoreCase(conObj.LastName.trim()))
                                    conInner = con;
                                else
                                    conInner = new Contact();
                            }
                            
                            if(conObj.Country__c  != null && conObj.Country__c  != '' && conInner.id != null){
                                if(conObj.Country__c.trim() == conInner.Country__c.trim())
                                    conInner = con;
                                else
                                    conInner = new Contact();
                            }
                            
                            if(conObj.Street_Address__c  != null && conObj.Street_Address__c  != '' && conInner.id != null){
                                if(conObj.Street_Address__c.trim() == conInner.Street_Address__c.trim())
                                    conInner = con;
                                else
                                    conInner = new Contact();
                            }
                            
                            if(conObj.Zip_Code__c  != null && conObj.Zip_Code__c  != '' && conInner.id != null){
                                //if(conObj.Zip_Code__c == conInner.Zip_Code__c)
                                    conInner = con;
                                //else
                                   // conInner = new Contact();
                            }
                            
                            if(conObj.Phone  != null && conObj.Phone  != '' && conInner.id != null){
                                conInner = con;
                            }
                            
                            if(conObj.ccn__c  != null && conObj.ccn__c  != '' && conInner.id != null && !secSrch){
                                if(conObj.ccn__c.trim() == conInner.ccn__c.trim())
                                    conInner = con;
                                else
                                   conInner = new Contact();
                            }
                            
                            if(conObj.BirthDate1__c != null && conInner.id != null){
                                //if(conObj.BirthDate1__c == conInner.BirthDate1__c)
                                    conInner = con;
                                //else
                                   // conInner = new Contact();
                            }
                        }
                        if(conInner.id != null){
                            conlst.add(conInner);
                        }
                    }
                }

            }

            //Sort: if searching by Customer ID, move the exact match to the top of the result list
    if(conObj.CustomerID__c != null && conObj.CustomerID__c != '' && !conlst.isEmpty()){
    String searchedCustId = conObj.CustomerID__c.trim();
    List<Contact> topMatch = new List<Contact>();
    List<Contact> remaining = new List<Contact>();
    for(Contact c : conlst){
        if(c.CustomerID__c != null && c.CustomerID__c == searchedCustId){
            topMatch.add(c);
        }else{
            remaining.add(c);
        }
    }
    conlst.clear();
    conlst.addAll(topMatch);
    conlst.addAll(remaining);
}
            
            if(conlst.isEmpty() || conlst.Size() == 0){
                // Check if searching by primary-only fields (no extended search allowed)
                Boolean isPrimarySearchOnly = (conObj.Phone != null && conObj.Phone != '') ||
                                              (conObj.Email != null && conObj.Email != '') ||
                                              (conObj.ccn__c != null && conObj.ccn__c != '') ||
                                              (issueid != null && issueid != '') ||
                                              (iqosid != null && iqosid != '') ||
                                              (tranSelectedValue != null && tranSelectedValue != '') ||
                                              (conObj.CustomerID__c != null && conObj.CustomerID__c != '');

                if(conObj.Country__c == 'United States' && !isPrimarySearchOnly){
                    if(conObj.FirstName == null || conObj.FirstName == ''  || conObj.LastName == null || conObj.LastName == '' || conObj.Zip_Code__c == null || conObj.Zip_Code__c == '' ||  conObj.Street_Address__c ==  null || conObj.Street_Address__c == '' || conObj.BirthDate1__c == null || conObj.city__c == null || conObj.city__c == '' || conObj.state__c == null || conObj.state__c == ''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'No Consumer Information found in Local CRC Database. Please enter FN, LN, DOB, Zip Code, Street Address, City, and State for an Extended Search.'));
                    }else{
                        conlst.clear();
                        getfullsearchList();
                        if(conlst.isEmpty() || conlst.Size() == 0){
                            RadioDisplay=false;
                            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
                        }else{
                            RadioDisplay=false;
                        }
                    }
                }else{
                     ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
                }              
                return null;
            }
            else if (conlst.Size() > 999){
                conlst.clear();
                RadioDisplay=false;
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Too many search results found (over 1,000), please enter in more search criteria to narrow search results'));
                return null;
            }else{
                RadioDisplay=true;
                isConsumerBtnVisible = false;  // Enable "New Consumer" button
                isIssueBtnVisible = false;     // Enable "New Issue" button
                return null;
            }
        }
        }catch(Exception ex){
        }
        return null;
    }
    
    //Method to excape the special/meta characters in a SOQL/SOSL
    public String escapeMetaCharacters(String inputString){
        
        List<String> metaCharacters = new List<String>();
        
        metaCharacters.add('\\');
        metaCharacters.add('^');
        metaCharacters.add('$');
        metaCharacters.add('{');
        metaCharacters.add('}');
        metaCharacters.add('[');metaCharacters.add(']');
        metaCharacters.add('(');metaCharacters.add(')');
        metaCharacters.add('+');
        metaCharacters.add('?');metaCharacters.add('|');
        metaCharacters.add('<');metaCharacters.add('>');
        metaCharacters.add('-');
        metaCharacters.add('&');
        metaCharacters.add('\'');
        string b = '\\';
        for (Integer i = 0 ; i < metaCharacters.size(); i++){
            system.debug('gcc ---->' + inputString.contains(metaCharacters[i]));
            if(inputString.contains(metaCharacters[i])){
                inputString= inputString.replace(metaCharacters[i],b+metaCharacters[i]);
            }
        }
        return inputString;
    }
    
    //Method that is called remotely to call the CCN Lookup service to get the consumer details from Axciom.
    @RemoteAction
    public static AcxiomClasses.CCNLookupFinalResponse CCNLookup(string CCNNumber, string tranidData){
        
        //Create the JSON body for the request to be sent
        JSONGenerator genRequest = JSON.createGenerator(true);
        
        //get custom session Id
        String sessionId = getSessionID();
        
        genRequest.writeStartObject();
        genRequest.writeStringField('CCN', CCNNumber);
        genRequest.writeFieldName('DataFlags');
            genRequest.writeStartObject();  
            genRequest.writeStringField('SurveyResponseFlag', 'N');
            genRequest.writeStringField('FullViewFlag', 'N');
            genRequest.writeStringField('ChannelContactFlag', 'Y');
            genRequest.writeFieldName('ChannelTypeDataCd');
                genRequest.writeStartArray();
                    genRequest.writeStartObject(); 
                    genRequest.writeStringField('ChannelType', 'ALL');
                    genRequest.writeEndObject();
                genRequest.writeEndArray();
            genRequest.writeStringField('ChannelDataShortFlag', 'N');
            genRequest.writeFieldName('ChannelTypeDataShortCd');
                genRequest.writeStartArray();
                    genRequest.writeStartObject(); 
                    genRequest.writeStringField('ChannelType', 'ALL');
                    genRequest.writeEndObject();
                genRequest.writeEndArray();
            genRequest.writeStringField('WebsiteFlag', 'N');
            genRequest.writeStringField('FlexDataFlag', 'N');
            genRequest.writeStringField('PromoRedemptionFlag', 'N');
            genRequest.writeStringField('RecentScoresFlag', 'N');
            genRequest.writeStringField('QualificationFlag', 'Y');
            genRequest.writeStringField('AvailabilityFlag', 'N');
            genRequest.writeStringField('PreferenceFlag', 'N');
            genRequest.writeStringField('SubscriptionFlag', 'N');
            genRequest.writeStringField('OwnerListFlag', 'Y');
            genRequest.writeEndObject();
        genRequest.writeStringField('SessionId', sessionId);
        genRequest.writeEndObject();
      
        String searchRequest = genRequest.getAsString();
        System.debug('SearchRequest CCN: ' + searchRequest);
        
        AcxiomClasses.CCNLookupFinalResponse responseCNN = new AcxiomClasses.CCNLookupFinalResponse();
        try{
            responseCNN =  AcxiomServices.CCNLookupRequest(searchRequest,CCNNumber,tranidData,'ConsumerSearch');
            responseCNN.showLocalData = false; 
            if(responseCNN.StatusCode!=null && responseCNN.StatusCode != ''){
                TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                mgmtHelper.createTransactionMgmtHistoryRecord('CCNLOOKUP',tranidData);
            }
        }catch(Exception e){
            
        }
        return responseCNN;        
    }
    
    //Method to call CCN lookup search webservice.
    public PageReference CCNLookupSearch(){
        string CCNNumberValue = ApexPages.currentPage().getParameters().get('CCNNumberId');
        conlst.clear(); 
        if(CCNNumberValue != null && CCNNumberValue.trim() != '' && CCNNumberValue.length()>3){
             string soslCondition = CCNNumberValue;
             String whereCondition =  ' Where RecordType.Name = \'Consumer\' and Active__c = true';
            
             string searchQuery = 'FIND {'+ soslCondition +'} IN ALL FIELDS ';
             searchQuery += 'RETURNING Contact(id,Name,CustomerID__c,Email,CCN__c,CustomerType__c,FirstName,LastName,phone,MobilePhone,OtherPhone,zip_code__c,Street_Address__c,State__c, City__c,Country__c,Birthdate1__c,DoNotUse__c';
             if(whereCondition  != null && whereCondition != '')
                 searchQuery += whereCondition ; 
             searchQuery += ')';
             
             List<List <sObject>> searchList = search.query(searchQuery);
             List<Contact> contactData= ((List<contact>)searchList[0]);              
             if(!contactData.isEmpty()){
                for(Contact con :contactData){
                    Contact conInner = con;
                    
                    if(CCNNumberValue  != null && CCNNumberValue  != '' && conInner.id != null){
                        if(CCNNumberValue == conInner.ccn__c)
                            conInner = con;
                        else
                            conInner = new Contact();
                    }
                    
                    if(conInner.id != null){
                        conlst.add(conInner);
                    }
                }
            }
            RadioDisplay=true;
            if(conlst.isEmpty() || conlst.Size() == 0){ 
                RadioDisplay=false;                    
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
            }             
        }else{
            RadioDisplay=false;                    
            ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'No record found, Please create new consumer.'));
        }
        return null;
    }
    
    //Method to check if a consumer is associated to the transaction.
    public Boolean checkContact(){
        Boolean checkContact = false; 
        system.debug('-----tranObj--------'+tranObj);
        system.debug('tranid is: ' + tranid);
        if(tranObj == null){
            System.debug('tranObj is null');
        }else{
              if(tranObj.Contact__c == null){
                        Transaction_Management__c tranData = [Select id,Contact__c from Transaction_Management__c where id =:tranObj.id];
                        system.debug('-------tranData.Contact__c----------'+tranData.Contact__c);
                        if(tranData.Contact__c != null){
                            tranObj.Contact__c = tranData.Contact__c;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer already associated with current transaction.'));
                            checkContact = true;
                        }
                }else{
                    checkContact = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Consumer already associated with current transaction.'));
                }
        }
        return checkContact ;
    }
    
    //Method to refresh the tab.
    public PageReference RefreshContact(){        
        if(checkContact()){
            Clear();
            isConsumerBtnVisible =false;            
        }
        return null;
    }
    
    //Create Custom Session ID for CCN and FullSearch
    public static String getSessionID(){
        String datetimeNow = String.valueOf(Datetime.valueOf(System.now()));
        //sessionId format : CRC_MMDDYYYY_HHMMSS
        String sessionId = 'CRC_' + 
            datetimeNow.substring(5,7) + datetimeNow.substring(8,10) + datetimeNow.substring(0,4) 
            + '_' +
            datetimeNow.substring(11,13) + datetimeNow.substring(14,16) + datetimeNow.substring(17,19);
        System.debug('Custom SessionId: ' + sessionId);
        return sessionId;
    }
}