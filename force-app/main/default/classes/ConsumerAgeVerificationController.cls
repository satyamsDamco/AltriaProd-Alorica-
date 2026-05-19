public class ConsumerAgeVerificationController {
    
    public contact conObj {get;set;}
    public Id tranid {get;set;}
    public boolean readOnlyCityState{get;set;}
    string oldZip;
    @TestVisible private string FormName;
    public Id contactId{get;set;}
    
     /* Initiate consutructor for Controller ConsumerAgeVerificationController. */
    public ConsumerAgeVerificationController (ApexPages.StandardController stdController){
        conObj = new Contact();
        contactId = stdController.getId();
        conObj = [Select Id, CustomerType__c,ccn__c, Salutation, FirstName, Suffix__c, LastName, Street_Address__c, City__c, Apt_Lot__c, State__c, Zip_Code__c, Birthdate1__c
                  From Contact Where id =: contactId];
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue(); 
        }
    }
       //Get City and State based on postal code using Melissa webservice.
    public void getcitystate(){
        if(conObj.Zip_Code__c!=null && oldZip != conObj.Zip_Code__c){
            conObj.city__c = '';
            conObj.state__c = '';
            if(conObj.Zip_Code__c.length() != 5 || !conObj.Zip_Code__c.isNumeric() || conObj.Zip_Code__c == '00000'){
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                readOnlyCityState = true;
            }else {
                oldZip = conObj.Zip_Code__c;
                MelissaClasses.zipLookupResponse zipLookup = new MelissaClasses.zipLookupResponse();
                zipLookup = MelissaServices.ZipLookupServiceRequest(conObj.Zip_Code__c,tranid,FormName, conObj.CCN__c, conObj.id);
                
                if(zipLookup ==  null){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please enter the City and State'));
                    readOnlyCityState = false;
                }else{
                    if(zipLookup.ErrorString != null && zipLookup.ErrorString != ''){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Please enter valid zip code.'));
                        readOnlyCityState = true;
                    }else{
                        if(!zipLookup.Results.isEmpty() && zipLookup.Results.size() >0){        
                            conObj.city__c = zipLookup.Results[0].Address.City;
                            conObj.state__c = zipLookup.Results[0].Address.State;
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
    //Method to reset the fields on the page
    public PageReference reset(){
        conObj = [Select Id, CustomerType__c, Salutation, FirstName, Suffix__c, LastName, Street_Address__c, City__c, Apt_Lot__c, State__c, Zip_Code__c, Birthdate1__c
                  From Contact Where id =: contactId];
        return null;
    }
    
    //Method for calling age verification via lexis nexis web service
    /* 
    * Updated By: Gian Carlo Cutchon
    * Date: 12/13/2018
    * Description: Updated API from SOAP to REST
    * RITM: RITM2227221: SCR 18-12-03 2018 Lexis Nexis Rest API
    */
    
    public PageReference ageVerify(){
        PageReference pgRef;
        if(tranId != null){
            LexisNexisResponseClass.AgeVerificationResponse jsonResponse;
            IntegrationLog__c IL = new IntegrationLog__c();
            Transaction_Management__c calldetails = [select id, name, Operating_Company__c, Operating_Company__r.OperatingCompany__c from Transaction_Management__c where id =:tranid];
           
           /* LexisNexisClasses.AgeVerificationRequest ageVerificationRequest = new LexisNexisClasses.AgeVerificationRequest();
            ageVerificationRequest.Prefix = conObj.Salutation;
            ageVerificationRequest.FirstName = conObj.FirstName;
            ageVerificationRequest.MiddleName = '';//conObj.Middle_Name__c;
            ageVerificationRequest.LastName = conObj.LastName;
            ageVerificationRequest.Suffix = conObj.Suffix__c;
            string dob;
            if(conObj.Birthdate1__c != null){
                dob = conObj.Birthdate1__c.format();
            }else{
                dob = '';
            }
            string month;
            string year;
            string day;
            if(dob != null && dob != ''){
                string[] dobString = dob.split('/');
                month = dobString[0];
                year = dobString[2];
                day = dobString[1];
            }else{
                month = '';
                year = '';
                day = '';   
            }
            ageVerificationRequest.DOBYear = year;
            ageVerificationRequest.DOBMonth = month;
            ageVerificationRequest.DOBDay = day;
            ageVerificationRequest.AddressLine1 = conObj.Street_Address__c;
            ageVerificationRequest.AddressLine2 = conObj.Apt_Lot__c;
            ageVerificationRequest.City = conObj.City__c;
            ageVerificationRequest.State = conObj.State__c;
            ageVerificationRequest.Zip = conObj.Zip_Code__c;
            
            Contact conUpd = [Select Id, AVF_GIID_Received__c, Birthdate1__c,Age_Verification_Source__c,Age_Verified_Date__c,CCN__c
                                       From Contact Where Id =: conObj.Id];
            
            LexisNexisClasses.AgeVerificationResponse ageVerificationResponse = LexisNexisServices.AgeVerificationRequest(ageVerificationRequest,tranid,'Consumer Age verification',calldetails.Operating_Company__r.OperatingCompany__c, conUpd.CCN__c, conUpd.id); */
            Contact conUpd = [Select Id, AVF_GIID_Received__c, Birthdate1__c,Age_Verification_Source__c,Age_Verified_Date__c,CCN__c,AV_Code__c From Contact Where Id =: conObj.Id];
            string dob;
            if(conObj.Birthdate1__c != null){
                dob = conObj.Birthdate1__c.format();
            }else{
                dob = '';
            }
            string month;
            string year;
            string day;
            if(dob != null && dob != ''){
                string[] dobString = dob.split('/');
                month = dobString[0];
                year = dobString[2];
                day = dobString[1];
            }else{
                month = '';
                year = '';
                day = '';   
            }
            
            LexisNexis_Integration__c settings;
        
            if(calldetails.Operating_Company__r.OperatingCompany__c != null && calldetails.Operating_Company__r.OperatingCompany__c != ''){
                settings = LexisNexis_Integration__c.getInstance(calldetails.Operating_Company__r.OperatingCompany__c);      
            }  
            
            LexisNexisResponseClass.AgeVerificationRequest jsonSetBody = new LexisNexisResponseClass.AgeVerificationRequest();
            jsonSetBody.Settings = new LexisNexisResponseClass.jsonWrapper_Settings();
            jsonSetBody.Settings.Mode = 'live';
            jsonSetBody.Settings.Reference = settings.Account_Number__c;
            jsonSetBody.Settings.Locale = 'en_US';
            jsonSetBody.Settings.Venue = 'online';
            jsonSetBody.Person = new LexisNexisResponseClass.jsonWrapper_Person();
            jsonSetBody.Person.Name = new LexisNexisResponseClass.jsonWrapper_Name();
            jsonSetBody.Person.Name.FirstName = conObj.FirstName;
            jsonSetBody.Person.Name.LastName = conObj.LastName;
            jsonSetBody.Person.Addresses = new list<LexisNexisResponseClass.jsonWrapper_Addresses>{new LexisNexisResponseClass.jsonWrapper_Addresses()};
            jsonSetBody.Person.Addresses[0].StreetAddress1 = conObj.Street_Address__c;
            if(conObj.Apt_Lot__c != null && conObj.Apt_Lot__c != ''){
                jsonSetBody.Person.Addresses[0].StreetAddress2 = conObj.Apt_Lot__c;
            }
            
            jsonSetBody.Person.Addresses[0].City = conObj.City__c;
            jsonSetBody.Person.Addresses[0].State = conObj.State__c;
            jsonSetBody.Person.Addresses[0].Zip5 = conObj.Zip_Code__c;
            jsonSetBody.Person.Addresses[0].Country = 'US';
            jsonSetBody.Person.Addresses[0].Context = 'primary';
            jsonSetBody.Person.DateOfBirth = new LexisNexisResponseClass.jsonWrapper_DOB();
            jsonSetBody.Person.DateOfBirth.Year = integer.valueof(year); 
            jsonSetBody.Person.DateOfBirth.Month = integer.valueof(month); 
            jsonSetBody.Person.DateOfBirth.Day = integer.valueof(day); 
            
            LexisNexis_Callout lc = new LexisNexis_Callout();
            jsonResponse = lc.AgeVerification_Callout(jsonSetBody,calldetails.Operating_Company__r.OperatingCompany__c);
            
            if(jsonResponse != null){
                if(jsonResponse.Status.TransactionStatus != null && jsonResponse.Status.TransactionStatus == 'passed'){
                //conUpd.Birthdate1__c = conObj.Birthdate1__c;
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Age Verified'));
                conUpd.AVF_GIID_Received__c = true;
                conUpd.Age_Verification_Source__c = 'Lexis Nexis'; 
                conUpd.Age_Verified_Date__c = system.now(); 
                conUpd.AV_Code__c = '2';
                IL.Message__c = 'Age Verification AgeVerificationResponse:[Message=Age verified, Status=pass]';
                
                }else if(jsonResponse.Status.TransactionStatus != null && jsonResponse.Status.TransactionStatus == 'failed'){
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Age could not be verified'));
                    conUpd.AVF_GIID_Received__c = false;
                    conUpd.Age_Verification_Source__c = ''; 
                    conUpd.Age_Verified_Date__c = null; 
                    conUpd.AV_Code__c = null;
                    IL.Message__c = 'Age Verification AgeVerificationResponse:[Message=Age could not be verified, Status=fail]';     
                }
                Database.SaveResult saveRst = Database.update(conUpd);
                TransactionMgmtHelper mgmtHelper1 = new TransactionMgmtHelper();
                mgmtHelper1.createTransactionMgmtHistoryRecord('AGE_VERIFICATION_REQUEST',conObj.Id);
                
                TransactionMgmtHelper mgmtHelper2 = new TransactionMgmtHelper();
                mgmtHelper2.createTransactionMgmtHistoryRecord('AGE_VERIFY',String.valueOf(conObj.Id));
                
                
                IL.Callout__c = 'Age Verification';
                IL.FormName__c = 'Consumer Age verification';
                IL.Consumer_Trade_Customer__c = conObj.Id;
                IL.Response__c = JSON.Serialize(jsonResponse);
                IL.Type__c = 'Lexis Nexis';
                IL.Success__c = true;
                IL.Request__c = JSON.Serialize(jsonSetBody);
                IL.Transaction_Management__c = calldetails.Id;
                Database.SaveResult saveIL = Database.insert(IL);
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, 'Bad Request'));
                IL.Callout__c = 'Age Verification';
                IL.FormName__c = 'Consumer Age verification';
                IL.Consumer_Trade_Customer__c = conObj.Id;
                IL.Response__c = null;
                IL.Type__c = 'Lexis Nexis';
                IL.Success__c = false;
                IL.Request__c = JSON.Serialize(jsonSetBody);
                IL.Transaction_Management__c = calldetails.Id;
                IL.Message__c = 'Bad Request';
                Database.SaveResult saveIL = Database.insert(IL);
            }
            
            /* if(ageVerificationResponse != null){
                if(ageVerificationResponse.Status != null && ageVerificationResponse.Status == 'PASS'){
                    conObj.AVF_GIID_Received__c = true;
                    ApexPages.addMessage(new ApexPages.Message(apexpages.severity.info, ageVerificationResponse.Message));
                    
                    conUpd.Birthdate1__c = conObj.Birthdate1__c;
                    conUpd.AVF_GIID_Received__c = conObj.AVF_GIID_Received__c;
                    conUpd.Age_Verification_Source__c = 'Lexis Nexis'; 
                    conUpd.Age_Verified_Date__c = system.now(); 
                    Database.SaveResult saveRst = Database.update(conUpd);
                }else{
                    //conObj.Age_Verified__c = false;
                    if(ageVerificationResponse.Status != null && ageVerificationResponse.Status.trim() == 'Error'){
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, 'Server Error, Please try again!'));
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(apexpages.severity.Error, ageVerificationResponse.Message));
                    }
                }
            }*/
                
            
            
        }
        return null;   
     }
}