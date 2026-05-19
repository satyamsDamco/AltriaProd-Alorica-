public class ConsumerEntryController {
    public contact conObj {get;set;}
    public Boolean Customershow {get;set;}
    public Boolean readOnlyCityState{get;set;}
    public Id tranid {get;set;}
    public string message{get;set;}
    public string ziperror{get;set;}
    public string resultcode{get;set;}
    @TestVisible private string FormName;
    private Transaction_Management__c tranObj;
    public string fromPage{get;set;}
    public boolean isAgeVerificationReq{get;set;}
    public boolean dobEditable{get;set;}
    private boolean AVFFlag;
    public List<SelectOption> customerTypeList {get;set;}
    Map<id,Customer_Type__c> customerType; 
    public string selectedCustomerTypeId{get;set;}
    Date currDOB;
    string oldZip;
    private Date oldDOB ; 
    id consumerRectype;
    private string ccnNumber;
    private String CustomerId;
    Private string OpCompany;
    public Boolean isHotZip{get;set;}
    public String oldEmail;
    public Boolean emailVerified;
    public boolean isNotEditable{get;set;}
    
    /* Initiated Constructor for controller. */
    public ConsumerEntryController (ApexPages.StandardController stdController){
        isNotEditable = false;
        dobEditable = true;  
        isAgeVerificationReq = true;
        conObj = new Contact();
        customerTypeList = new List<SelectOption>();
        customerType = new Map<id,Customer_Type__c>();
        fromPage = '';
        AVFFlag = false;
        ccnNumber = '';
        CustomerId = '';
        this.conObj = (Contact)stdController.getRecord();
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');// Get Current transaction ID from Cookies. 
        if(counter != null) {
            tranid = counter.getValue();
             if(conObj.id == null){
               String RecordTypeidObj = customerRecordTypeHelper.getCustomerRecordType(tranid);//Assign Record Type when creating new customer.
               
               if(RecordTypeidObj != ''){
                   conObj.RecordTypeId = RecordTypeidObj;
               }
            }
       }
       
       consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
       if(conObj.RecordTypeId != consumerRectype){
            Customershow = false;
       }else{
            Customershow = true;
       }
       getCustomerType(); 
               
       init(); 
        /* Display Contacts value for existing record. */
       if(conObj.id != null){
           Contact c = [Select id, CCN__c,Birthdate1__c,Zip_Code__c,Age_Verification_Source__c,AVF_GIID_Received__c,CustomerType1__c from Contact where id =:conObj.id];
           conObj.First_Time_Caller__c = 'N'; 
           CustomerId = conObj.id;
           ccnNumber = c.CCN__c;
           if(c.Birthdate1__c != null){
               currDOB = c.Birthdate1__c;
           }
           if(c.Zip_Code__c !=  null && c.Zip_Code__c != ''){
               oldZip = c.Zip_Code__c;
           }
           AVFFlag = c.AVF_GIID_Received__c;
           if(c.CustomerType1__c  != null){
                selectedCustomerTypeId = c.CustomerType1__c;
           }
       }
            
       birthDate(); // Calculate Birthdate.
       getCurrCountry(); //Get Current Country for Customer. 
       //RITM0441447 - Production Implementation for SCR 20-06-03 2020 Wirecard Virtual Pay
       oldEmail = conObj.Email;
       emailVerified = conObj.Email_Verified__c;
        
       	id userid = userinfo.getProfileId();
        List<Profile> profileRec = [SELECT Name FROM Profile WHERE Id = :userid];
        if(!profileRec.isEmpty()) {
            if(profileRec[0].Name == 'CRC Agent') {
                isNotEditable = true;
            }
        }
    }
    
    /* From an Object named Customer Type, get all the Customer Type picklist value on Consumer Entry Page.  */
    public void getCustomerType(){
        
        customerTypeList = new List<SelectOption>();
        customerType = new Map<id,Customer_Type__c>([Select Id, Description__c 
                                                       from Customer_Type__c 
                                                       where IsActive__c = true
                                                       and CodeType__c =: 'CONSUMERS']);
        customerTypeList.add(new SelectOption('0', '--Select Customer Type--',false)); 
        Id customTypeid;
        if(!customerType.isEmpty()){
            for(Customer_Type__c ct :customerType.values()){
                customerTypeList.add(new SelectOption(ct.id, ct.Description__c));
                
                if(customTypeid == null && ct.Description__c == 'CONSUMER'){
                    customTypeid = ct.id;
                }                
            }
            
            if(conObj.id == null){      
                if(customTypeid != null && conObj.RecordTypeId == consumerRectype){
                    selectedCustomerTypeId = customTypeid;
                    conObj.CustomerType__c = 'CONSUMER';
                    conObj.CustomerType1__c = customTypeid;
                }
            }   
        }
    }
    
    /* Method to Consumer Type Selection. On Basis of Customer Types Consumer and Trader Customer fields would be rendered.  */
    public PageReference changeCustomerType(){
        if(selectedCustomerTypeId != null && selectedCustomerTypeId != '' && selectedCustomerTypeId != '0' && !customerType.isEmpty()){
            if(customerType.ContainsKey(selectedCustomerTypeId)){
                conObj.CustomerType__c = customerType.get(selectedCustomerTypeId).Description__c;
                conObj.CustomerType1__c  = selectedCustomerTypeId;
                
                if(conObj.CustomerType__c == 'CONSUMER'){
                    isAgeVerificationReq = true;
                }else{
                    isAgeVerificationReq = false;
                }
            }else{
                conObj.CustomerType__c = '';
                conObj.CustomerType1__c = null;
                isAgeVerificationReq = false;
            }
        }else{
            conObj.CustomerType__c = '';
            conObj.CustomerType1__c = null;
            isAgeVerificationReq = false;
        }
        return null;
    }
        /* Methods to get calculate Birthdate for consumer. */
     public void birthDate(){
        long age;
        if(conObj.id != null && currDOB != null){
           age = ((currDOB.daysBetween(system.TODAY())/365.2425)).round(System.RoundingMode.FLOOR);  
           if(age >= 18 && age <= 21){
                dobEditable = false;
           }else{
                dobEditable = true; 
           }
        }
     }
    
    //Metho to get the country for consumer.
    public void getCurrCountry(){
        if(conObj.Country__c == null || conObj.Country__c == '--None--' || conObj.Country__c == Label.Country){
            readOnlyCityState = true; 
            isAgeVerificationReq = true;
        }else{
            readOnlyCityState = false;   
            isAgeVerificationReq = false;
        }
        if(isAgeVerificationReq && conObj.CustomerType__c != Label.CustomerType){
            isAgeVerificationReq = false;
        }
    }
    
    public void streetChanged()
    {
        conObj.Address_Verified__c = false;
    }
   
    
    //Method to initialise all the parameters and fields for consumer record. 
    public void init(){
    
        if(ApexPages.currentPage().getParameters().get('from') != null && ApexPages.currentPage().getParameters().get('from') != '')
            fromPage =  ApexPages.currentPage().getParameters().get('from');  
        
        if(ApexPages.currentPage().getParameters().get('Fname') != null && ApexPages.currentPage().getParameters().get('Fname') != '')
            conObj.FirstName = ApexPages.currentPage().getParameters().get('Fname');            
        
        if(ApexPages.currentPage().getParameters().get('Lname') != null && ApexPages.currentPage().getParameters().get('Lname') != '')   
            conObj.LastName = ApexPages.currentPage().getParameters().get('Lname');
        
        if(ApexPages.currentPage().getParameters().get('Title') != null && ApexPages.currentPage().getParameters().get('Title') != '')
            conObj.Salutation = ApexPages.currentPage().getParameters().get('Title');
        
        if(ApexPages.currentPage().getParameters().get('Addr1') != null && ApexPages.currentPage().getParameters().get('Addr1') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('Addr1');
        
        if(ApexPages.currentPage().getParameters().get('Addr2') != null && ApexPages.currentPage().getParameters().get('Addr2') != '')
            conObj.Apt_Lot__c = ApexPages.currentPage().getParameters().get('Addr2');
        
        if(ApexPages.currentPage().getParameters().get('add') != null && ApexPages.currentPage().getParameters().get('add') != '')
            conObj.Street_Address__c = ApexPages.currentPage().getParameters().get('add');

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
                currDOB = d;
            }else{
                String [] dobString1 = dob.split('/'); 
                date d = Date.newInstance(Integer.ValueOf(dobString1[2]), Integer.ValueOf(dobString1[0]), Integer.ValueOf(dobString1[1]));
                conObj.Birthdate1__c = d;
                currDOB = d;
            }
        }
          
        if(ApexPages.currentPage().getParameters().get('zip') != null && ApexPages.currentPage().getParameters().get('zip') != '')
            conObj.Zip_Code__c = ApexPages.currentPage().getParameters().get('zip');
         
        if(ApexPages.currentPage().getParameters().get('ccn') != null && ApexPages.currentPage().getParameters().get('ccn') != '')
            conObj.CCN__c = ApexPages.currentPage().getParameters().get('ccn');
        
        if(ApexPages.currentPage().getParameters().get('avcode') != null && ApexPages.currentPage().getParameters().get('avcode') != '')
            conObj.AV_Code__c = ApexPages.currentPage().getParameters().get('avcode');
        
        if(conObj.id == null && conObj.AV_Code__c != null && conObj.AV_Code__c.trim() != '' && (conObj.AV_Code__c == '1' || conObj.AV_Code__c == '2' || conObj.AV_Code__c == '3')){
            conObj.Age_Verified_Date__c = system.now();  
            conObj.Age_Verification_Source__c = 'CCNLookup';
            conObj.AVF_GIID_Received__c = true;
            conObj.Address_Verified__c = true; //Set to true as requested by Brian when coming from CCN - 2/20/2020
            AVFFlag = true;
        }
        if(ApexPages.currentPage().getParameters().get('avowner') != null && ApexPages.currentPage().getParameters().get('avowner') != '')
            opCompany = ApexPages.currentPage().getParameters().get('avowner');           
        
        
        if(ApexPages.currentPage().getParameters().get('email') != null && ApexPages.currentPage().getParameters().get('email') != '')
            conObj.Email = ApexPages.currentPage().getParameters().get('email');
        
        if(ApexPages.currentPage().getParameters().get('country') != null && ApexPages.currentPage().getParameters().get('country') != ''){
            conObj.Country__c = ApexPages.currentPage().getParameters().get('country');
        }
        
        if(ApexPages.currentPage().getParameters().get('phone') != null && ApexPages.currentPage().getParameters().get('phone') != '')
            conObj.Phone = ApexPages.currentPage().getParameters().get('phone');
            
        if(ApexPages.currentPage().getParameters().get('comName') != null && ApexPages.currentPage().getParameters().get('comName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('comName'); 
        
        if(ApexPages.currentPage().getParameters().get('agentName') != null && ApexPages.currentPage().getParameters().get('agentName') != '')
            conObj.Company_Name__c =  ApexPages.currentPage().getParameters().get('agentName'); 
        
        if(ApexPages.currentPage().getParameters().get('DBA') != null && ApexPages.currentPage().getParameters().get('DBA') != '')
            conObj.DBA_Name__c =  ApexPages.currentPage().getParameters().get('DBA'); 
        
        if(ApexPages.currentPage().getParameters().get('accountNo') != null && ApexPages.currentPage().getParameters().get('accountNo') != '')
            conObj.Account_No__c =  ApexPages.currentPage().getParameters().get('accountNo'); 
        
        if(ApexPages.currentPage().getParameters().get('retail') != null && ApexPages.currentPage().getParameters().get('retail') != '')
            conObj.Retail_control__c =  ApexPages.currentPage().getParameters().get('retail'); 
        
        if(ApexPages.currentPage().getParameters().get('fSphone') != null && ApexPages.currentPage().getParameters().get('fSphone') != '')
            conObj.Phone =  ApexPages.currentPage().getParameters().get('fSphone'); 
        
        if(ApexPages.currentPage().getParameters().get('territory') != null && ApexPages.currentPage().getParameters().get('territory') != '')
            conObj.Territory__c =  ApexPages.currentPage().getParameters().get('territory'); 
        
        if(ApexPages.currentPage().getParameters().get('custType') != null && ApexPages.currentPage().getParameters().get('custType') != '')
            conObj.CustomerType__c=  ApexPages.currentPage().getParameters().get('custType');
            
        if(ApexPages.currentPage().getParameters().get('custType1') != null && ApexPages.currentPage().getParameters().get('custType1') != ''){
            conObj.CustomerType1__c=  ApexPages.currentPage().getParameters().get('custType1');
            selectedCustomerTypeId  = conObj.CustomerType1__c;      
        }   
            
        if(tranid != null){
            tranObj = new Transaction_Management__c();
            tranObj = [Select id, Contact__c, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
            
        }
        
        //Research Panelist
        if(ApexPages.currentPage().getParameters().get('studyID') != null && ApexPages.currentPage().getParameters().get('studyID') != ''){
            conObj.Study_ID__c =  ApexPages.currentPage().getParameters().get('studyID');    
        }
        
        if(ApexPages.currentPage().getParameters().get('partID') != null && ApexPages.currentPage().getParameters().get('partID') != ''){
            conObj.Participant_ID__c =  ApexPages.currentPage().getParameters().get('partID');    
        }
        
        if(ApexPages.currentPage().getParameters().get('blindCode') != null && ApexPages.currentPage().getParameters().get('blindCode') != ''){
            conObj.Blinding_Code__c =  ApexPages.currentPage().getParameters().get('blindCode');    
        }
        
        if(ApexPages.currentPage().getParameters().get('resCom') != null && ApexPages.currentPage().getParameters().get('resCom') != ''){
            conObj.Research_Company__c =  ApexPages.currentPage().getParameters().get('resCom');    
        }
        
        if(ApexPages.currentPage().getParameters().get('resLoc') != null && ApexPages.currentPage().getParameters().get('resLoc') != ''){
            conObj.Research_Location__c =  ApexPages.currentPage().getParameters().get('resLoc');    
        }
        
        if(ApexPages.currentPage().getParameters().get('proFlavType') != null && ApexPages.currentPage().getParameters().get('proFlavType') != ''){
            conObj.Project_Flavor_Type__c =  ApexPages.currentPage().getParameters().get('proFlavType');    
        }
        
        if(ApexPages.currentPage().getParameters().get('rName') != null && ApexPages.currentPage().getParameters().get('rName') != ''){
            conObj.Research_Panelist_Name__c =  ApexPages.currentPage().getParameters().get('rName');    
        }
    }
    
   //Get City and State based on postal code using Melissa webservice.
    public void getcitystate(){
        if(conObj.Country__c !=Label.Country){
            conObj.city__c = '';
            conObj.state__c = '';
        }
        if(conObj.Country__c ==Label.Country && conObj.Zip_Code__c!=null && oldZip != conObj.Zip_Code__c){
            conObj.city__c = '';
            conObj.state__c = '';
            if(conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() || conObj.Zip_Code__c == '00000'){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                readOnlyCityState = true;
                oldZip = conObj.Zip_Code__c;
            }else {
                oldZip = conObj.Zip_Code__c;
                
                MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
                zipLookup = MelissaServices.ZipLookupServiceRequest(conObj.Zip_Code__c,tranid,FormName,ccnNumber,CustomerId);
                
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
                            
                         }else{
                             ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State')); 
                             readOnlyCityState = false;                                               
                         }                        
                     }                     
                } 
            }
        } 
    }
    
    //Method to verify address using Melissa webservice.
    public void  getaddressverified(){
        if(conObj.Country__c == Label.Country){
            MelissaClasses.consumerAddressRequest addressdata = new MelissaClasses.consumerAddressRequest();
            addressdata.AddressLine1 = conObj.Street_Address__c;
            if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != '')
                addressdata.AddressLine1 += ' ' +conObj.Apt_Lot__c;
            addressdata.AddressLine2 = '';
            addressdata.City = conObj.City__c;
            addressdata.State = conObj.State__c;
            addressdata.PostalCode = conObj.Zip_Code__c;
            addressdata.Country = conObj.Country__c;
            List<MelissaClasses.consumerAddressInnerResponse> addresp;
            addresp = MelissaServices.usaAddressRequest(addressdata,tranid,FormName,ccnNumber,CustomerId);
            for(MelissaClasses.consumerAddressInnerResponse resultlist:addresp){
                message=resultlist.Message;
                resultcode=resultlist.ResultCode;
                if(resultcode=='Success'){
                    conObj.Address_Verified__c=true;
                    conObj.Verify_Address__c = false;
                    if(message!=null && message!=''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, message));
                    }                        
                }else if(resultcode=='info'){
                    conObj.Address_Verified__c=false;
                    conObj.Verify_Address__c = false;
                    if(message!=null && message!=''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, message));
                    }                        
                }else{
                    conObj.Address_Verified__c=false;
                    conObj.Verify_Address__c = false;
                    if(message!=null && message!=''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, message));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please try again!'));
                    }
                }
             }
        }
    }
    //fromPage
    public PageReference assignContactTransaction(){
        try{
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
                tranObj = [Select Id,Contact__c,Comments__c From Transaction_Management__c Where Id=: tranid];
                
                if(fromPage != null &&  fromPage == 'search'){
                    tranObj.Contact__c =  conObj.id;
                    update tranObj;
                    conObj.First_Time_Caller__c = 'N';
                    List<Case> issueList = new List<Case>([Select id, ContactID,Contact_DOB__c,Contact_CCN_Number__c,Contact_Apt_Lot__c,Contact_Street_Address__c,
                                                           Contact_City__c,Contact_State__c, Contact_Country__c,Contact_Zip_Code__c   
                                                           from case 
                                                           where Transaction__c =:tranObj.id and ContactID = null]);
                    Contact conUpdateObj = [select id, BirthDate__c, CCN__c,Apt_Lot__c,City__c,Country__c,CustomerID__c,State__c,Street_Address__c,Zip_Code__c,Name from Contact where id = :conObj.id];    
                    if(!issueList.isEmpty() && issueList.size() >0){
                        for(case c :issueList){
                            c.ContactID = conObj.id;
                            
                            if(conUpdateObj.BirthDate__c != null && conUpdateObj.BirthDate__c != '')
                                c.Contact_DOB__c = conUpdateObj.BirthDate__c;
                            
                            if(conUpdateObj.CCN__c != null && conUpdateObj.CCN__c != '')    
                                c.Contact_CCN_Number__c = conUpdateObj.CCN__c; 
                            
                            if(conUpdateObj.Apt_Lot__c != null && conUpdateObj.Apt_Lot__c != ''){
                                c.Contact_Apt_Lot__c = conUpdateObj.Apt_Lot__c;
                            }   
                                        
                            if(conUpdateObj.Street_Address__c != null && conUpdateObj.Street_Address__c != ''){
                                c.Contact_Street_Address__c = conUpdateObj.Street_Address__c;                    
                            }
                            
                            if(conUpdateObj.City__c!= null && conUpdateObj.City__c != ''){
                                c.Contact_City__c = conUpdateObj.City__c;                    
                            }
                            
                            if(conUpdateObj.State__c != null && conUpdateObj.State__c!= ''){
                                c.Contact_State__c = conUpdateObj.State__c;                    
                            }
                              
                            if(conUpdateObj.Country__c != null && conUpdateObj.Country__c != ''){
                                c.Contact_Country__c = conUpdateObj.Country__c;                    
                            }
                            
                            if(conUpdateObj.Zip_Code__c  != null && conUpdateObj.Zip_Code__c != ''){
                                c.Contact_Zip_Code__c = conUpdateObj.Zip_Code__c ;                   
                            }
                        }
                        update issueList;
                        if(issueList.size() > 1){
                        conObj.Repeat_Complainer__c = true;
                        if(conObj.Repeat_Complainer_Date__c == null){
                            conObj.Repeat_Complainer_Date__c = System.today();
                        }
                        
                        
                        system.debug('---conObj.Repeat_Complainer__c----'+conObj.Repeat_Complainer__c);
                    }
                    }
                }
                // Create Transaction History for Chat
                if(tranObj.Comments__c == 'Chat') {
                    tranObj.Comments__c = '';
                    update tranObj;
                    TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                    mgmtHelper.createTransactionMgmtHistoryRecord('CHAT_START','');
                }
            }
            update conObj;
            isHotZip = checkHotZip();
            PageReference pg=new PageReference ('/apex/ConsumerDetailPage?id='+conObj.id+'&isHotZip='+isHotZip);
            pg.setRedirect(true);
            return pg;
            
        }catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
    
    }   
    
    //Method to save the consumer record.
    public PageReference save(){
        try{
            String respanError = '';
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
                tranObj = [Select Id,Contact__c,Comments__c From Transaction_Management__c Where Id=: tranid];
            }
            //start here
            //Added for address verification
            System.debug('cosnumer address verify'+conObj.Address_Verified__c);
            if (conObj.Id != null)
            {
            Contact conlist = [SELECT ID,Address_Verified__c,Street_Address__c,City__c,Apt_Lot__c,State__c,Zip_Code__c
                               FROM CONTACT where id =: conObj.Id];
             System.debug('test new value'+conObj.Street_Address__c);
            System.debug('test old value'+conlist.Street_Address__c);
			
            if(conlist.Address_Verified__c == true){
                conlist.Address_Verified__c = false;
                //update conlist;
                System.debug('new boolean value'+conlist.Address_Verified__c);
                if(conObj.Verify_Address__c != true && 
                   ( conObj.Street_Address__c !=conlist.Street_Address__c ||conObj.Zip_Code__c != conlist.Zip_Code__c || conObj.Apt_Lot__c != conlist.Apt_Lot__c)){
                    System.debug('test in if');
                    getaddressverified();
                    System.debug('test end if');
                }
            }
            }
            //end here
            if(conObj.Country__c==Label.Country && conObj.CustomerType__c   != Label.Field_Sales_Force){ 
                if(conObj.Zip_Code__c != null && conObj.Zip_Code__c != '' && (conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() || conObj.Zip_Code__c == '00000')){ 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid zip code'));
                    return null;
                }
                if(oldZip != conObj.Zip_Code__c){            
                    getcitystate();                
                    if(ApexPages.hasmessages(ApexPages.severity.ERROR)){
                            return null;
                    }           
                }                
            }
            
            if(conObj.CustomerType__c   == Label.Research_Panelist){
                if(conObj.Study_ID__c == null || conObj.Study_ID__c == ''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Study ID is required'));
                    return null;
                }
				//RITM0812476 - SCR 20-02-03 2020 Research Panelist - Salutation to be Mandatory
                if(conObj.Salutation == null || conObj.Salutation == ''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Prefix.'));
                    return null;
                }
                
                if(conObj.Participant_ID__c != null && conObj.Participant_ID__c != '' && (conObj.Participant_ID__c.contains('\t') || conObj.Participant_ID__c.contains('|') || conObj.Participant_ID__c.contains(','))){
                    respanError = respanError + 'Participant ID, ';
                }
                
                if(conObj.Blinding_Code__c != null && conObj.Blinding_Code__c != '' &&(conObj.Blinding_Code__c.contains('\t') || conObj.Blinding_Code__c.contains('|') || conObj.Blinding_Code__c.contains(','))){
                    respanError = respanError + 'Blinding Code, ';
                }
                
                if(conObj.Research_Company__c != null && conObj.Research_Company__c != '' &&(conObj.Research_Company__c.contains('\t') || conObj.Research_Company__c.contains('|') || conObj.Research_Company__c.contains(','))){
                    respanError = respanError + 'Research Company, ';
                }
                
                if(conObj.Research_Location__c != null && conObj.Research_Location__c != '' &&(conObj.Research_Location__c.contains('\t') || conObj.Research_Location__c.contains('|') || conObj.Research_Location__c.contains(','))){
                    respanError = respanError + 'Research Location, ';
                }
                
                if(conObj.Research_Panelist_Name__c != null && conObj.Research_Panelist_Name__c != '' &&(conObj.Research_Panelist_Name__c.contains('\t') || conObj.Research_Panelist_Name__c.contains('|') || conObj.Research_Panelist_Name__c.contains(','))){
                    respanError = respanError + 'Name, ';
                }
                
                if(conObj.Project_Flavor_Type__c != null && conObj.Project_Flavor_Type__c != '' &&(conObj.Project_Flavor_Type__c.contains('\t') || conObj.Project_Flavor_Type__c.contains('|') || conObj.Project_Flavor_Type__c.contains(','))){
                    respanError = respanError + 'Project Flavor/Type, ';
                }
                
                if(conObj.Research_Panelist_Address__c != null && conObj.Research_Panelist_Address__c != '' &&(conObj.Research_Panelist_Address__c.contains('\t') || conObj.Research_Panelist_Address__c.contains('|') || conObj.Research_Panelist_Address__c.contains(','))){
                    respanError = respanError + 'Address, ';
                }
                
                if(conObj.Research_Panelist_Notes__c != null && conObj.Research_Panelist_Notes__c != '' &&(conObj.Research_Panelist_Notes__c.contains('\t') || conObj.Research_Panelist_Notes__c.contains('|') || conObj.Research_Panelist_Notes__c.contains(','))){
                    respanError = respanError + 'Customer Notes, ';
                }
                
                if(conObj.Participation_Date__c != null && conObj.Participation_Date__c != '' &&(conObj.Participation_Date__c.contains('\t') || conObj.Participation_Date__c.contains('|') || conObj.Participation_Date__c.contains(','))){
                    respanError = respanError + 'Participation Date, ';
                }
                if(respanError != ''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,respanError.removeEnd(', ') + ' cannot contain a "|", "," characters or have multiple lines.'));
                    return null;
                }
            }
            
            if(conObj.CustomerType__c  != null && !Customershow){
                conObj.FirstName = 'Trade';
                conObj.LastName = 'Customer'; 
                if(conObj.CustomerType__c    == Label.Field_Sales_Force){
                    conObj.Street_Address__c = ' ';
                    conObj.City__c = ' ';
                    conObj.State__c = ' ';
                    conObj.Country__c = ' ';
                    conObj.Zip_Code__c = ' ';
               }   
            }
            
            if(Label.CustomerType != conObj.CustomerType__c){
                conObj.Birthdate1__c = null;
                conObj.Birthdate__c = '';
                conObj.AVF_GIID_Received__c = false;
            }
            
            if(Customershow && conObj.id == null){
            
                if(conObj.AV_Code__c != null && conObj.AV_Code__c.trim() != '' && (conObj.AV_Code__c == '1' || conObj.AV_Code__c == '2' || conObj.AV_Code__c == '3')){
                    conObj.Age_Verified_Date__c = system.now(); 
                    conObj.Age_Verification_Source__c = 'CCNLookup';
                    conObj.AVF_GIID_Received__c = true;
                    AVFFlag = true;
                }
                
                Transaction_Management__c tran = new Transaction_Management__c();
                tran =  [Select id, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
                
                if(tran.id != null && conObj.Op_Company__c == null)
                    conObj.Op_Company__c = tran.Operating_Company__c;
            }
            
            if(conObj.Birthdate1__c !=NULL){
                String dateOutput = conObj.Birthdate1__c.format();
                conObj.Birthdate__c=dateOutput;
                                
                
                if(!conObj.AVF_GIID_Received__c){
                    conObj.Age_Verification_Source__c = null;
                    conObj.Age_Verified_Date__c = null;
                }
                if(conObj.AVF_GIID_Received__c && !AVFFlag ){
                    conObj.Age_Verification_Source__c = 'GIID';
                    conObj.Age_Verified_Date__c = system.now(); 
                }
                if(currDOB != conObj.Birthdate1__c){
                    conObj.AVF_GIID_Received__c = false;
                    conObj.Age_Verification_Source__c = null;
                    conObj.Age_Verified_Date__c = null;
                }            
            }else{
                conObj.AVF_GIID_Received__c = false;
                conObj.Age_Verification_Source__c = null;
                conObj.Age_Verified_Date__c = null;
            }
            if(conObj.id==null){
                if(tranObj.Contact__c != null){
                    system.debug('t-' + tranObj.Contact__c);
                    if(Customershow)
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Consumer already associated with current transaction.'));
                    else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Trade Customer already associated with current transaction.'));
                    return null;
                }
            }else{
                if(tranObj.Contact__c != null && tranObj.Contact__c != conObj.id){
                    if(Customershow)
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Consumer already associated with current transaction.'));
                    else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Trade Customer already associated with current transaction.'));
                    return null;
                }
            }
            if(conObj.id==null){ 
                
                conObj.First_Time_Caller__c = 'Y'; 
                Database.SaveResult saveRst = Database.insert(conObj);
                tranObj.Contact__c =  conObj.id;
                update tranObj;
                if(saveRst.isSuccess()){
                    TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                    mgmtHelper.createTransactionMgmtHistoryRecord('CREATECUST',String.valueOf(saveRst.getId()));
                }
                List<Case> issueList = new List<Case>([Select id, ContactID,Contact_DOB__c,Contact_CCN_Number__c,Contact_Apt_Lot__c,Contact_Street_Address__c,
                                                       Contact_City__c,Contact_State__c, Contact_Country__c,Contact_Zip_Code__c                
                                                       from case where Transaction__c =:tranObj.id and ContactID = null]);
                Contact conUpdateObj = [select id, BirthDate__c, CCN__c,Apt_Lot__c,CustomerID__c,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,Name from Contact where id = :conObj.id];
                if(!issueList.isEmpty() && issueList.size() >0){
                    for(case c :issueList){
                        c.ContactID = conObj.id;                         
           
                        if(conUpdateObj.BirthDate__c != null && conUpdateObj.BirthDate__c != '')
                            c.Contact_DOB__c = conUpdateObj.BirthDate__c;
                            
                        if(conUpdateObj.CCN__c != null && conUpdateObj.CCN__c != '')    
                            c.Contact_CCN_Number__c = conUpdateObj.CCN__c; 
                        
                        if(conUpdateObj.Apt_Lot__c != null && conUpdateObj.Apt_Lot__c != ''){
                            c.Contact_Apt_Lot__c = conUpdateObj.Apt_Lot__c;
                        }   
                                    
                        if(conUpdateObj.Street_Address__c != null && conUpdateObj.Street_Address__c != ''){
                            c.Contact_Street_Address__c = conUpdateObj.Street_Address__c;                    
                        }
                        
                        if(conUpdateObj.City__c!= null && conUpdateObj.City__c != ''){
                            c.Contact_City__c = conUpdateObj.City__c;                    
                        }
                        
                        if(conUpdateObj.State__c != null && conUpdateObj.State__c!= ''){
                            c.Contact_State__c = conUpdateObj.State__c;                    
                        }
                        
                        if(conUpdateObj.Country__c != null && conUpdateObj.Country__c != ''){
                            c.Contact_Country__c = conUpdateObj.Country__c;                    
                        }
                        
                        if(conUpdateObj.Zip_Code__c  != null && conUpdateObj.Zip_Code__c != ''){
                            c.Contact_Zip_Code__c = conUpdateObj.Zip_Code__c ;                   
                        }
                    }
                    update issueList;
                    
                    if(issueList.size() > 1){
                        conObj.Repeat_Complainer__c = true;
                        if(conObj.Repeat_Complainer_Date__c == null){
                            conObj.Repeat_Complainer_Date__c = System.today();
                        }
                        update conObj;
                        
                    }
                }
            }else{ 
                
                Database.UpsertResult upsRst = Database.upsert(conObj);
                
                if(upsRst.isSuccess()){
                    TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                    if(upsRst.isCreated()){
                        mgmtHelper.createTransactionMgmtHistoryRecord('CREATECUST',String.valueOf(upsRst.getId()));
                    }else{
                        mgmtHelper.createTransactionMgmtHistoryRecord('UPDATECUST',String.valueOf(upsRst.getId()));
                    }
                    //JAD: RITM0441447 - Production Implementation for SCR 20-06-03 2020 Wirecard Virtual Pay
                    if(oldEmail == conObj.Email && emailVerified == conObj.Email_Verified__c){
                        //no changes. do nothing.
                    }
                    else{
                        if(oldEmail != conObj.Email){
                            if(conObj.Email == null || conObj.Email == ''){
                                tranObj.Comments__c = 'Email was cleared';
                                update tranObj;
                            }else{
                                tranObj.Comments__c = conObj.Email;
                                update tranObj;
                            }	
                            mgmtHelper.createTransactionMgmtHistoryRecord('EMAIL_ADDRESS_UPDATE',String.valueOf(upsRst.getId()));
                            tranObj.Comments__c = '';
                            update tranObj;
                        }
                        else if((emailVerified == false || oldEmail != conObj.Email) && conObj.Email_Verified__c == true){
                            tranObj.Comments__c = 'Email address was confirmed';
                            update tranObj;
                            mgmtHelper.createTransactionMgmtHistoryRecord('EMAIL_CONFIRMED_UPDATE',String.valueOf(upsRst.getId()));
                            tranObj.Comments__c = '';
                            update tranObj;
                        }
                        else if(emailVerified == true  && conObj.Email_Verified__c == false){
                        tranObj.Comments__c = 'Email Confirmed was cleared';
                        update tranObj;
                        mgmtHelper.createTransactionMgmtHistoryRecord('EMAIL_CONFIRMED_UPDATE',String.valueOf(upsRst.getId()));
                        tranObj.Comments__c = '';
                        update tranObj;
                    }
                    }
                    //--JAD: RITM0441447 -- end
                }
            } 
            
            if(tranObj.Comments__c == 'Chat') {
                tranObj.Comments__c = '';
                update tranObj;
	            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
	            mgmtHelper.createTransactionMgmtHistoryRecord('CHAT_START','');
            }
            isHotZip = checkHotZip();
            PageReference pg=new PageReference ('/apex/ConsumerDetailPage?id='+conObj.id+'&isHotZip='+isHotZip);
            pg.setRedirect(true);
            return pg;
        }
        catch(DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
    } 
    
    /* Cancel Button method, which redirect to Consumer Detail Page. */
    public PageReference cancelRedirect(){   
        PageReference pageRef = new PageReference('/apex/ConsumerDetailPage?id='+conObj.Id);
        pageRef.setRedirect(true);
        return pageRef;             
    } 
    
    public Boolean checkHotZip(){
        Boolean isHot;
        Integer countMe;
        if(conObj.Zip_Code__c != null){
            countMe = [SELECT count() FROM Hot_Zip__c WHERE Zip_Code__c =: conObj.Zip_Code__c AND Active__c = true];
        }
        if(countMe > 0){
            isHot = true;
        }else{
            isHot = false;  
        }
        return isHot;
    }
    
}