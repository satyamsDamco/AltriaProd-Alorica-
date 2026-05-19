@RestResource(urlMapping='/OACComplaintAPI/') //url name to be use to invoke the apex rest in external app
global class createOACIssue {
    
    
    private static string iqosDateCodeMilitaryTime = '';
    private static map<string,string> iqosDate_Map = new map<string,string>();
    private static map<string,string> iqosShift_Map = new map<string,string>();
    private static map<string,string> iqosModule_Map = new map<string,string>();
    private static map<string,string> iqosFactory_Map = new map<string,string>();
    private static map<string,string> iqosDateCodeLocation_Map = new map<string,string>();
    private static map<string,string> iqosDateCodeMilitaryTime_Map = new map<string,string>();
    private static map<string,string> newIQOSSerielNum_Map = new map<string,string>();
    private static map<string,string> originalIQOSSerielNum_Map = new map<string,string>();
      
    private static map<string,string> iqosCCN_Map = new map<string,string>();
    private static map<string,string> iqosRegistrationDate_Map = new map<string,string>();
    private static map<string,string> iqosRegistrationStatus_Map = new map<string,string>();
    
    
    public static string productionDate = '';
    public static string iqosRegDate = '';
    public static string iqosTPC = '';
    public static string iqosBP = '';
    
    private static List<IntegrationLog__c> ILList = new List<IntegrationLog__c>();
    
    
    private static map<string, date> iqosPurchaseDate_Map = new map<string, date>();
    private static map<string, decimal> iqosTPCustomer_Map = new map<string, decimal>();
    private static map<string, boolean> iqosFTBuyer_Map = new map<string, boolean>();
    private static map<string, decimal> iqosBasePrice_Map = new map<string, decimal>();
    
    
    private static map<string, boolean> iqosSuccess_Map = new  map<string, boolean>();
    private static map<string, boolean> iqosSuccessPR_Map = new  map<string, boolean>();
    private static map<string, boolean> iqosSuccessOI_Map = new  map<string, boolean>();
    private static map<string, boolean> iqosCSAPIProb_Map = new  map<string, boolean>();
    public static contact contactList2 = new contact();
    
    public static list<case> newCaseList = new list<case>();
    private static Savepoint sp;
    
    // Searching the contact record base on CCN or Address
    global static Set<Id> contactID(String ccn, String conAdd){
        Set<Id> conIds = new Set<Id>();
        if(ccn != null && ccn != ''){
            List<List<sObject>> searchList = [FIND :ccn IN ALL FIELDS RETURNING Contact(Id)];
            List<Contact> conList = (List<Contact>)searchList[0];
            for(Contact con: conList){
                conIds.add(con.id);
            }
            if(conIds.size() > 0){
                return conIds;
            }
            else{
                if(conAdd != null && conAdd != ''){
                    List<List<sObject>> searchList2 = [FIND :conAdd IN ALL FIELDS RETURNING Contact(Id)];
                    List<Contact> conList2 = (List<Contact>)searchList2[0];
                    for(Contact con: conList2){
                        conIds.add(con.id);
                    }
                    if(conIds.size() > 0){
                        return conIds;
                    }
                }
            }
        }
        else if(conAdd != null && conAdd != ''){
            List<List<sObject>> searchList3 = [FIND :conAdd IN ALL FIELDS RETURNING Contact(Id)];
            List<Contact> conList2 = (List<Contact>)searchList3[0];
            for(Contact con: conList2){
                conIds.add(con.id);
            }
            if(conIds.size() > 0){
                return conIds;
            }   
        }
        return null;
    }
    
    @HttpPost // Insert/Update Contact data in saleforce
    global static List<jsonWrapper_Response> doPost(){
        
        Map<String,String> iqosSerialNum = new Map<String,String>();
        //Kit Mapping
        IQOSResponseClass.jsonWrapper_KM jsonRes;
        //Manufacturing Information
        IQOSResponseClass.jsonWrapper_MI jsonResMI;
        IQOSCallout ic = new IQOSCallout(); 
        String militaryTime;
        String hh;
        String mm;
        
        String caseRefId;
        List<String> mandatoryMessage;
        list<case> issueList = new list<case>();
        List<Contact> conListToUpsert = new List<Contact>();
        List<Contact> conListToInsert = new List<Contact>();
        RestResponse res = RestContext.response;
        List<jsonWrapper_Response> resJSON = new List<jsonWrapper_Response>();
        RestRequest req = new RestRequest();
        IQOSResponseClass.jsonWrapper_CEA jsonBody = new IQOSResponseClass.jsonWrapper_CEA();
        OACValidation cv = new OACValidation();
        
        try{    
            req = RestContext.request;
            jsonBody = (IQOSResponseClass.jsonWrapper_CEA) json.deserialize(req.requestBody.toString(), IQOSResponseClass.jsonWrapper_CEA.class);
            system.debug('ggcutchon contactID' + contactID(jsonBody.ContactInfo.ccn,jsonBody.ContactInfo.addressLine1));
            //system.debug('test response'+contactID(jsonBody.ContactInfo.ccn,null));
            String inputDob = jsonBody.contactInfo.DOB; // "2003-08-12"
            Date dobDate = Date.valueOf(inputDob); // Converts to Date object
            String Birthdate = dobDate.month() + '/' + dobDate.day() + '/' + dobDate.year(); // "08/12/2003"

            List<Contact> contactList = [Select firstName, LastName, Suffix__c, Title, Street_Address__c, Apt_Lot__c, Zip_Code__c, City__c, State__c, Address_Verified__c, Phone, MobilePhone, Email, OtherPhone, Birthdate1__c, AV_Code__c, AVF_GIID_Received__c, CCN__c from contact where id IN: contactID(jsonBody.ContactInfo.ccn,jsonBody.ContactInfo.addressLine1)];
            List<contact> contactList2 = [Select id,firstName, LastName, Suffix__c, Title, Street_Address__c, Apt_Lot__c, Zip_Code__c, City__c, State__c, Address_Verified__c, Phone, MobilePhone, Email, OtherPhone, Birthdate1__c, AV_Code__c, AVF_GIID_Received__c, CCN__c from contact where Zip_Code__c = :jsonBody.contactInfo.zip and State__c =:jsonBody.contactInfo.state and  City__c = :jsonBody.contactInfo.city and Street_Address__c = :jsonBody.contactInfo.addressLine1 and Birthdate__c =:Birthdate];
            System.debug('contact list'+contactList);
            System.debug('contact list'+contactList2);
            System.debug('jsonBody'+jsonBody);

            mandatoryMessage = cv.checkMandatoryFields(jsonBody);
            
            if(mandatoryMessage.size() > 0){
                            System.debug('inside mandatoryMessage'+mandatoryMessage);

                for(String eMsg: mandatoryMessage){
                    res.statusCode = 500;
                    jsonWrapper_Response item = new jsonWrapper_Response();
                    item.errorMessage = eMsg;
                    resJSON.add(item);
                }
                createIL(jsonBody, resJSON, res);
                System.debug('return --1--->'+resJSON);
                return resJSON;
            }
            else{
                if(jsonBody.IssueInfo.size() > 0){
                    System.debug('JsonBody If condition');
                    for(integer jsonIssue = 0 ; jsonIssue < jsonBody.IssueInfo.size(); jsonIssue++ ){
                        //----- Core Service Callout for Manufacturing Info, Kit Mapping, Product Registration, Order Information and Warranty Information
                        if(jsonBody.IssueInfo[jsonIssue].SerialNumber != null && jsonBody.IssueInfo[jsonIssue].SerialNumber != ''){
                        jsonRes = ic.csKitMappingCallout(jsonBody.IssueInfo[jsonIssue].SerialNumber); 
                            System.debug('jsonRes'+jsonRes);
                        if(jsonRes != null){
                                if(jsonRes.value.size() > 0){
                                    createIL_CS(null,jsonRes,null,null,jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                    for(integer x = 0 ; x < jsonRes.value.size(); x++ ){
                                        if(jsonRes.value[x].PackagingLevel.Id == 12){
                                            iqosSerialNum.put(jsonRes.value[x].InputItemCode,jsonRes.value[x].ItemCode);
                                        }
                                    }           

                                    if(iqosSerialNum.containskey(jsonBody.IssueInfo[jsonIssue].SerialNumber) && iqosSerialNum.get(jsonBody.IssueInfo[jsonIssue].SerialNumber) != null && iqosSerialNum.get(jsonBody.IssueInfo[jsonIssue].SerialNumber) != ''){
                                        
                                        // Manufacturing Info: Serial number have kit mapping.
                                        jsonResMI = ic.csManufacturingCallout(iqosSerialNum.get(jsonBody.IssueInfo[jsonIssue].SerialNumber)); 
                                        if(jsonResMI != null){
                                            if(jsonResMI.value.size() > 0){ 
                                                
                                                iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                                                
                                                iqosDate_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionDateTime);
                                                iqosShift_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].Shift);
                                                iqosModule_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionLine.Code);
                                                iqosFactory_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.Code); //INC0035953 - Changed extracted value from Name to Code
                                                iqosDateCodeLocation_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.CityRomanized);
                                                
                                                militaryTime = jsonResMI.value[0].ProductionDateTime;
                                                hh = militaryTime.substring(11,13);
                                                mm = militaryTime.substring(14,16);
                                                iqosDateCodeMilitaryTime = hh + mm;
                                                iqosDateCodeMilitaryTime_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, hh + mm);
                                                
                                                newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, iqosSerialNum.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                originalIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                                orderInfoAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                productRegAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                createIL_CS(jsonResMI,null,null,null,newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                
                                            }else{
                                                iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                            }
                                        //iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                        }else{
                                            iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                                        }
                                    }   
                                    
                                    else{
                                         // Manufacturing Info: packaging level 12 but serial number doesn't have kit mapping.
                                        jsonResMI = ic.csManufacturingCallout(jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                        if(jsonResMI != null){
                                            if(jsonResMI.value.size() > 0){ 
                                            
                                                iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                                                iqosDate_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionDateTime);
                                                iqosShift_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].Shift);
                                                iqosModule_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionLine.Code);
                                                iqosFactory_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.Code); //INC0035953 - Changed extracted value from Name to Code
                                                iqosDateCodeLocation_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.CityRomanized);
                                                
                                                militaryTime = jsonResMI.value[0].ProductionDateTime;
                                                hh = militaryTime.substring(11,13);
                                                mm = militaryTime.substring(14,16);
                                                iqosDateCodeMilitaryTime = hh + mm;
                                                iqosDateCodeMilitaryTime_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, hh + mm);
                                                
                                                newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                                originalIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                                orderInfoAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                productRegAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                                createIL_CS(jsonResMI,null,null,null,jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            }
                                            else{
                                                iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                            }
                                        //iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                        }else{
                                            iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                                        }
                                    }
                                }
                                else{
                                    // Manufacturing Info: If serial number doesn't have kit mapping.
                                    jsonResMI = ic.csManufacturingCallout(jsonBody.IssueInfo[jsonIssue].SerialNumber); 
                                    if(jsonResMI != null){
                                        if(jsonResMI.value.size() > 0){
                                            iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                
                                            iqosDate_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionDateTime);
                                            iqosShift_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].Shift);
                                            iqosModule_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonResMI.value[0].ProductionLine.Code);
                                            iqosFactory_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.Code); //INC0035953 - Changed extracted value from Name to Code
                                            iqosDateCodeLocation_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber,jsonResMI.value[0].ProductionLine.Factory.CityRomanized);
                                            
                                            militaryTime = jsonResMI.value[0].ProductionDateTime;
                                            hh = militaryTime.substring(11,13);
                                            mm = militaryTime.substring(14,16);
                                            iqosDateCodeMilitaryTime = hh + mm;
                                            iqosDateCodeMilitaryTime_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, hh + mm);
                                            
                                            newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            originalIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            orderInfoAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                            productRegAPI(newIQOSSerielNum_Map.get(jsonBody.IssueInfo[jsonIssue].SerialNumber));
                                            createIL_CS(jsonResMI,null,null,null,jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                        }
                                        else{
                                            // If serial number doesn't have Kit Mapping and Manufacturing Information still checks Order Information and Product Registration
                                            newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            iqosSuccess_map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                            system.debug('---- inside else apex message-----');
                                            String msg = 'Serial Number not found.';
                                            orderInfoAPI(jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            productRegAPI(jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                            createIL_CS(jsonResMI,null,null,null,jsonBody.IssueInfo[jsonIssue].SerialNumber);

                                        }
                                    //iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                                    }else{
                                        newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                        iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                                    }
                                }
                            //iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, false);
                            }else{
                                newIQOSSerielNum_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, jsonBody.IssueInfo[jsonIssue].SerialNumber);
                                iqosCSAPIProb_Map.put(jsonBody.IssueInfo[jsonIssue].SerialNumber, true);
                            }
                        }
                    } // end of for loop                                        
                } //end if jsonBody.issue.size()    
                //----- End of Core Service APIs    
                
                //Set SavePoint
                sp = Database.setSavepoint();
                Integer count = 0;
                if(!contactList2.isEmpty()){
                    for(contact con: contactList2){
                        System.debug('contactsize2-->'+contactList2);
                        if(con.FirstName == jsonBody.ContactInfo.FirstName && con.LastName == jsonBody.ContactInfo.lastName){
                            count = count + 1;
                        } 
                    }
                    system.debug('count Value is '+ count );
                    if (count == 1) {
                        System.debug('test resposnse1');
                            res.statusCode = 201;
                            issueList = createNewCase(contactList2[0]);
                            System.debug('issuelist====><===='+issueList);
                            if(issueList.size() > 0){
                                for(integer x = 0 ; x < issueList.size(); x++ ){
                                    jsonWrapper_Response item = new jsonWrapper_Response();
                                    item.MasterId = issueList[x].MasterId__c;
                                    resJSON.add(item);
                                    createTMH(contactList2[0],null,true,issueList[x].Transaction__c);
                                }
                            }
                            createIL(jsonBody, resJSON, res);
                            System.debug('return --3--->'+resJSON);
                            return resJSON;
                    }
                }
                if(count != 1){
                    if(contactList.size() > 0){
                        System.debug('contactsize-->'+contactList);
                        for(contact con: contactList){
                            if((jsonBody.ContactInfo.ccn!= null && jsonBody.ContactInfo.ccn != '') && con.CCN__c == jsonBody.ContactInfo.ccn){
                                system.debug('------ inside CCN --------------');
                                con.FirstName = jsonBody.ContactInfo.firstName.toUpperCase();
                                con.LastName = jsonBody.ContactInfo.lastName.toUpperCase();
                                con.Suffix__c = jsonBody.ContactInfo.suffix;
                                con.Salutation =  jsonBody.ContactInfo.prefix;
                                con.Street_Address__c = jsonBody.ContactInfo.addressLine1.toUpperCase();
                                if(jsonBody.ContactInfo.addressLine2 != null){
                                    con.Apt_Lot__c = jsonBody.ContactInfo.addressLine2.toUpperCase();
                                }
                                con.Zip_Code__c = jsonBody.ContactInfo.zip;
                                con.City__c = jsonBody.ContactInfo.city.toUpperCase();
                                con.State__c = jsonBody.ContactInfo.state.toUpperCase();
                                con.Address_Verified__c = jsonBody.ContactInfo.addressVerified;
                                con.Phone = jsonBody.ContactInfo.telephone;
                                con.MobilePhone = jsonBody.ContactInfo.mobilePhone;
                                con.Email = jsonBody.ContactInfo.emailAddress;
                                con.OtherPhone = jsonBody.ContactInfo.alternateTelephone;
                                con.Birthdate1__c = date.valueof(jsonBody.ContactInfo.dob);
                                con.AV_Code__c = jsonBody.ContactInfo.avCode;
                                con.AVF_GIID_Received__c = jsonBody.ContactInfo.ageVerified;
                                
                                conListToUpsert.add(con);
                            }
                            
                            else if(
                                con.FirstName == jsonBody.ContactInfo.firstName && 
                                con.LastName == jsonBody.ContactInfo.lastName && 
                                con.Street_Address__c == jsonBody.ContactInfo.addressLine1 && 
                                (((con.Apt_Lot__c != null ? con.Apt_Lot__c : '') == jsonBody.ContactInfo.addressLine2) || ((con.Apt_Lot__c != null ? con.Apt_Lot__c : null) == jsonBody.ContactInfo.addressLine2))&&
                                con.Zip_Code__c == jsonBody.ContactInfo.zip && 
                                con.City__c == jsonBody.ContactInfo.city && 
                                con.State__c == jsonBody.ContactInfo.state && 
                                con.Birthdate1__c == date.valueof(jsonBody.ContactInfo.dob)){
                                    
                                    system.debug('------ inside fName --------------');
                                    con.Suffix__c = jsonBody.ContactInfo.suffix;
                                    con.Salutation =  jsonBody.ContactInfo.prefix;
                                    con.Address_Verified__c = jsonBody.ContactInfo.addressVerified;
                                    con.Phone = jsonBody.ContactInfo.telephone;
                                    con.MobilePhone = jsonBody.ContactInfo.mobilePhone;
                                    con.Email = jsonBody.ContactInfo.emailAddress;
                                    con.OtherPhone = jsonBody.ContactInfo.alternateTelephone;
                                    con.AV_Code__c = jsonBody.ContactInfo.avCode;
                                    con.AVF_GIID_Received__c = jsonBody.ContactInfo.ageVerified;
                                    con.CCN__c = jsonBody.ContactInfo.ccn;
           
                                    conListToUpsert.add(con);                       
                            }
                        }
                        
                    }
                    
                    else{
                        System.debug('test resposnse');
                       res.statusCode = 201;
                       issueList = createNewContact();
                       if(issueList.size() > 0){
                           for(integer x = 0 ; x < issueList.size(); x++ ){
                               
                               jsonWrapper_Response item = new jsonWrapper_Response();
                              // item.ReferenceId = issueList[x].IQOS_Reference_ID__c;
                               item.MasterId = issueList[x].MasterId__c;
    
                               resJSON.add(item);
                           }
                       }
                       createIL(jsonBody, resJSON, res);
                       System.debug('return --2--->'+resJSON);
    
                       return resJSON;  
                    }
                    
                    if(conListToUpsert.size() > 0){
                                            System.debug('test resposnse1');
    
                        res.statusCode = 201;
                        update conListToUpsert;
                        issueList = createNewCase(conListToUpsert[0]);
                        System.debug('issuelist====><===='+issueList);
                        if(issueList.size() > 0){
                           for(integer x = 0 ; x < issueList.size(); x++ ){
                               jsonWrapper_Response item = new jsonWrapper_Response();
                               //item.ReferenceId = issueList[x].IQOS_Reference_ID__c;
                               item.MasterId = issueList[x].MasterId__c;
                               resJSON.add(item);
                               createTMH(conListToUpsert[0],null,true,issueList[x].Transaction__c);
                           }
                        }
                        createIL(jsonBody, resJSON, res);
                        System.debug('return --3--->'+resJSON);
    
                        return resJSON; 
                    }
                    else{
                        res.statusCode = 201 ;
                        issueList = createNewContact();
    
                        if(issueList.size() > 0){
                           for(integer x = 0 ; x < issueList.size(); x++ ){
                               jsonWrapper_Response item = new jsonWrapper_Response();
                              // item.ReferenceId = issueList[x].IQOS_Reference_ID__c;
                               item.MasterId = issueList[x].MasterId__c;
                               resJSON.add(item);
                           }
                        }
                        createIL(jsonBody, resJSON, res);
                        System.debug('return --4--->'+resJSON);
    
                        return resJSON;  
                    }

                }
                else{
                    return null;
                }
                  
            }//end else
        }

        catch(Exception e)
        {
            if(sp!=null){
                Database.rollback(sp);
            }
            String errorMessage = e.getMessage();
            Integer occurence;
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
            }
            else if (e.getMessage().contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST')){
                occurence = errorMessage.indexOf('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST,') + 41;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
                System.debug('*****Line : ' + e.getLineNumber());
            }
            else {
                errorMessage = e.getLineNumber() + ' : ' + e.getMessage(); 
                System.debug('Error msg: ' + errorMessage);
            }

            res.statusCode = 500;
            jsonWrapper_Response item = new jsonWrapper_Response();
            item.errorMessage = errorMessage;
            resJSON.add(item);
            createIL(jsonBody, resJSON, res);
            System.debug('return --5--->'+resJSON);

            return resJSON;
           
        } 
    }
    
    //Creating new contact
    public static list<case> createNewContact(){
        list<case> issueList = new list<case>();
        RestRequest req = RestContext.request;
        IQOSResponseClass.jsonWrapper_CEA jsonBody2 = (IQOSResponseClass.jsonWrapper_CEA) json.deserialize(req.requestBody.toString(), IQOSResponseClass.jsonWrapper_CEA.class);
        
        list<Customer_Type__c> ct = [Select Id, Description__c from Customer_Type__c where Description__c = 'CONSUMER' limit 1];
        list<Operating_Company__c> opList = [Select Id from Operating_Company__c  where OperatingCompany__c = 'PMUSA' limit 1];
        system.debug('ct --->' + ct);
        contact newCon = new contact();
                        
        newCon.FirstName = jsonBody2.ContactInfo.firstName.toUpperCase();
        newCon.LastName = jsonBody2.ContactInfo.lastName.toUpperCase();
        newCon.Suffix__c = jsonBody2.ContactInfo.suffix;
        newCon.Salutation =  jsonBody2.ContactInfo.prefix;
        newCon.Street_Address__c = jsonBody2.ContactInfo.addressLine1.toUpperCase();
        if(jsonBody2.ContactInfo.addressLine2 != null){
            newCon.Apt_Lot__c = jsonBody2.ContactInfo.addressLine2.toUpperCase();
        }
        newCon.Zip_Code__c = jsonBody2.ContactInfo.zip;
        newCon.City__c = jsonBody2.ContactInfo.city.toUpperCase();
        newCon.State__c = jsonBody2.ContactInfo.state.toUpperCase();
        newCon.Address_Verified__c = jsonBody2.ContactInfo.addressVerified;
        newCon.Phone = jsonBody2.ContactInfo.telephone;
        newCon.MobilePhone = jsonBody2.ContactInfo.mobilePhone;
        newCon.Email = jsonBody2.ContactInfo.emailAddress;
        newCon.OtherPhone = jsonBody2.ContactInfo.alternateTelephone;
        newCon.Birthdate1__c = date.valueof(jsonBody2.ContactInfo.dob);
        newCon.AV_Code__c = jsonBody2.ContactInfo.avCode;
        newCon.AVF_GIID_Received__c = jsonBody2.ContactInfo.ageVerified;
        newCon.CCN__c = jsonBody2.ContactInfo.ccn;
        if(ct.size() > 0){
            newCon.CustomerType1__c = ct[0].id;
        }
        if(opList.size() > 0){
            newCon.Op_Company__c = opList[0].id;
        }
        newCon.CustomerType__c = Label.CustomerType;
        newCon.Country__c = 'United States';
        newCon.RecordTypeId = '0123600000121TgAAI';
        
        insert newCon;
        issueList = createNewCase(newCon);

        createTMH(newCon,null,false,issueList[0].Transaction__c);

                
        return issueList;
    }
    
    //Creating Issue (Case)
    public static list<case> createNewCase(contact conID){
        
        RestRequest req = RestContext.request;
        IQOSResponseClass.jsonWrapper_CEA jsonBody3 = (IQOSResponseClass.jsonWrapper_CEA) json.deserialize(req.requestBody.toString(), IQOSResponseClass.jsonWrapper_CEA.class);
        
        map<string, Brand_Hierarchy__c> BH_Map = new map<string, Brand_Hierarchy__c>();
        map<string, Issue_Hierarchy__c> IH_Map = new map<string, Issue_Hierarchy__c>();
        List<Brand_Hierarchy__c> BH = new List<Brand_Hierarchy__c>();
        List<Issue_Hierarchy__c> IH = new List<Issue_Hierarchy__c>();
        Product_Line__c PL = new Product_Line__c();
        Map<String, case> oldCaseMap = new Map<String, case>();
        //Case newCase = new Case();
        List<Case> oldCase = new List<Case>();
        List<String> iqosRefList = new List<String> ();
        List<String> BHList = new List<String> ();
        List<String> IHList = new List<String> ();
        Transaction_Management__c tm = new Transaction_Management__c();
        
        PL = [Select Id, Operating_Company__c,Op_Company__c, Name, Op_Company__r.Default_TFN__c,Code__c from Product_Line__c where Name =: Label.IQOS_Product Limit 1];
        
        Transaction_Management__c newTM = createTM(conID, PL.Op_Company__c, PL.Op_Company__r.Default_TFN__c );

        if(jsonBody3.IssueInfo.size() > 0){
            for(integer jsonIssue = 0 ; jsonIssue < jsonBody3.IssueInfo.size(); jsonIssue++ ){
                iqosRefList.add(jsonBody3.IssueInfo[jsonIssue].ReferenceID);
                if(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy != null && jsonBody3.IssueInfo[jsonIssue].BrandHierarchy != ''){
                    BHList.add(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy);
                }
                if(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy != null && jsonBody3.IssueInfo[jsonIssue].IssueHierarchy != '' ){
                    IHList.add(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy);
                }
            }
        }
        
        //Checking for Old case that hase same IQOS ref id
        if(iqosRefList.size() > 0){
            oldCase = [Select IQOS_Reference_ID__c,id, Transaction__c, MasterId__c from Case where IQOS_Reference_ID__c IN: iqosRefList AND ContactID =: conID.Id ];
        }
        
        if(oldCase.size() > 0){
            for(case OC : oldCase){
                oldCaseMap.put(OC.IQOS_Reference_ID__c, OC);
            }   
        }//end of old case
        
        //getting the brand hierarcy
        if(BHList.size() > 0){
            BH = [Select Name, Id, UPC__c, Brand_Code__c, Filter__c, Packaging__c,Brand_Code__r.Name, Cut__c, Flavor__c, PaperType__c, Taste__c, Length__c  from Brand_Hierarchy__c Where Name IN: BHList ];
        }
        if(BH.size() > 0){
            for(Brand_Hierarchy__c b: BH){
                BH_Map.put(b.Name, b);
            }   
        }//end of brand hierarcy
        
        //getting the issue hierarcy
        if(IHList.size() > 0){
            IH = [Select Name, Id, Classification__c,Issue_Type__c, Group__c,Reason__c, Cause__c, Classification__r.Description__c, Reason__r.Description__c,  Issue_Type__r.Description__c,Cause__r.Description__c,Group__r.Description__c from Issue_Hierarchy__c where  Name IN: IHList];
        }
        if(IH.size() > 0){
            for(Issue_Hierarchy__c i: IH){
                IH_Map.put(i.Name, i);
            }   
        }//end of issue hierarcy
        
        if(jsonBody3.IssueInfo.size() > 0){
            for(integer jsonIssue = 0 ; jsonIssue < jsonBody3.IssueInfo.size(); jsonIssue++ ){
                Case newCase = new Case();
                system.debug('jsonBody3.IssueInfo[jsonIssue].BrandHierarchy --->' + jsonBody3.IssueInfo[jsonIssue].BrandHierarchy);
                
                if(IH_Map.containskey(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy)){
                    newCase.Issue_Hierarchy_Code__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Id;
                    newCase.Classificationtxt__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Classification__r.Description__c;
                    newCase.Reasontxt__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Reason__r.Description__c;
                    newCase.Issue_Type__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Issue_Type__r.Description__c;
                    newCase.Causetxt__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Cause__r.Description__c;
                    newCase.Group_Code__c = IH_Map.get(jsonBody3.IssueInfo[jsonIssue].IssueHierarchy).Group__r.Description__c;
                }
                if(BH_Map.containskey(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy)){
                    newCase.Crc_Brand_Hierarchy_Code__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Id;
                    newCase.UPC_code__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).UPC__c;
                    newCase.Brandcode__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Brand_Code__r.Name;
                    newCase.Packaging__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Packaging__c;
                    newCase.Filter__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Filter__c;
                    newCase.Cut__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Cut__c;
                    newCase.Flavor__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Flavor__c;
                    newCase.Paper_Type__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).PaperType__c;
                    newCase.Taste__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Taste__c;
                    newCase.Length_Code__c = BH_Map.get(jsonBody3.IssueInfo[jsonIssue].BrandHierarchy).Length__c;
                }
                
                newCase.Affected_Type__c = jsonBody3.IssueInfo[jsonIssue].AffectedType;
                newCase.AffectedQty__c = jsonBody3.IssueInfo[jsonIssue].AffectedQuantity;
                newCase.CEA_Agent_ID__c = jsonBody3.IssueInfo[jsonIssue].AgentID;
                newCase.Comment__c = jsonBody3.IssueInfo[jsonIssue].Comment;
                newCase.Complaint_Source__c = jsonBody3.IssueInfo[jsonIssue].ComplaintSource;
                newCase.Consumer_Mentions__c = jsonBody3.IssueInfo[jsonIssue].ConsumerMentions;
                newCase.Expected_Type__c = jsonBody3.IssueInfo[jsonIssue].ExpectedType;
                newCase.ExpectedQty__c = jsonBody3.IssueInfo[jsonIssue].ExpectedQuantity;
                newCase.Inbound_Tracking__c = jsonBody3.IssueInfo[jsonIssue].InboundTracking;
                if(jsonBody3.IssueInfo[jsonIssue].IncidentDate != '' && jsonBody3.IssueInfo[jsonIssue].IncidentDate != null){
                    newCase.Incident_Date__c = date.valueof(jsonBody3.IssueInfo[jsonIssue].IncidentDate);
                }
                newCase.IQOS_Reference_ID__c = jsonBody3.IssueInfo[jsonIssue].ReferenceID;
                newCase.Outbound_Tracking__c = jsonBody3.IssueInfo[jsonIssue].OutboundTracking;
                //newCase.ProdrReturnReq__c = jsonBody3.IssueInfo[jsonIssue].ProductRetReqforReimbursement;
                if(jsonBody3.IssueInfo[jsonIssue].PurchaseDate != '' && jsonBody3.IssueInfo[jsonIssue].PurchaseDate != null){
                    newCase.Purchase_Date__c = date.valueof(jsonBody3.IssueInfo[jsonIssue].PurchaseDate);
                }
                newCase.Purchase_Price__c = jsonBody3.IssueInfo[jsonIssue].PurchasePrice;
                newCase.Purchase_Type__c = jsonBody3.IssueInfo[jsonIssue].PurchaseType;
                newCase.PurchaseQty__c = jsonBody3.IssueInfo[jsonIssue].PurchaseQuantity;
                newCase.Reimbursed_Or_Replaced_Indicator__c = jsonBody3.IssueInfo[jsonIssue].ReimbursedOrRepIndicator;
                newCase.Reimbursement_Amount__c = jsonBody3.IssueInfo[jsonIssue].ReimbursementAmount;

                newCase.Third_Party_Reimbursement_Amount__c = jsonBody3.IssueInfo[jsonIssue].ThirdPartyRA;
                newCase.Op_Company__c = PL.Op_Company__c;
                newCase.ContactID = conID.Id;
                newCase.Product_Line__c = jsonBody3.IssueInfo[jsonIssue].ProductLine; // added new field Affirma
                newCase.Channel_Contact__c = jsonBody3.IssueInfo[jsonIssue].ChannelContact; // added new field Affirma
                newCase.PLCode__c = PL.Code__c;
                newCase.Product_Line_Code__c = PL.Id;
                //added by affirma
                if(jsonBody3.IssueInfo[jsonIssue].SellByDate != '' && jsonBody3.IssueInfo[jsonIssue].SellByDate != null){
                    newCase.Date_Code__c = jsonBody3.IssueInfo[jsonIssue].SellByDate;
                }
                
                System.debug('refid'+ jsonBody3.IssueInfo[jsonIssue].ReferenceID);
                
                if(jsonBody3.IssueInfo[jsonIssue].ReferenceID == null ){

                    /*if(oldCaseMap.containskey(jsonBody3.IssueInfo[jsonIssue].ReferenceID)){

                         newCase.Transaction__c = oldCaseMap.get(jsonBody3.IssueInfo[jsonIssue].ReferenceID).Transaction__c;
                         newCase.MasterId__c =  oldCaseMap.get(jsonBody3.IssueInfo[jsonIssue].ReferenceID).MasterId__c;
                    }
                    else{*/
                    System.debug('test if statement');
                        tm = newTM;
                        system.debug('TM ---->' + TM);
                        newCase.Transaction__c = tm.id;
                        newCase.MasterId__c = string.valueof(tm.Name);                  
                   // }
                }
                //Core Service Manufacturing Information 
                if(jsonBody3.IssueInfo[jsonIssue].SerialNumber != null && jsonBody3.IssueInfo[jsonIssue].serialNumber != '')
                {
                    system.debug('iqosSuccess --->' + iqosSuccess_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));
                    if(!iqosSuccess_Map.isEmpty()){
                        if(iqosSuccess_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber)){
                            string fChar;
                            if(integer.valueof(iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber).substring(5,7)) < 10){
                                fChar = iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber).substring(6,7);
                            }
                            else{
                                fChar = iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber).substring(5,7);
                            }
                            String cDate = fChar + '/' + iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber).substring(8,10) + '/' + iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber).substring(0,4);
                            newCase.Production_date__c = date.valueOf(iqosDate_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));
                            //2018-02-11T15:56:13Z
                            newCase.DateCodeProductionDate__c = cDate;
                            newCase.DateCodeShift__c = iqosShift_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                            newCase.DateCodeUnit__c = iqosModule_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                            newCase.DateCodeRptFactory__c = iqosFactory_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                            newCase.DateCodeLocation__c = iqosDateCodeLocation_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);         
                            newCase.DateCodeMilitaryTime__c = iqosDateCodeMilitaryTime_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);     
                            newCase.Serial_Number__c = newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                            newCase.Original_Serial_Number__c = originalIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                        }
                        else{
                            newCase.Serial_Number__c = jsonBody3.IssueInfo[jsonIssue].SerialNumber;
                            newCase.Original_Serial_Number__c = jsonBody3.IssueInfo[jsonIssue].SerialNumber;
                        }
                    } else{
                        newCase.Serial_Number__c = jsonBody3.IssueInfo[jsonIssue].SerialNumber;
                    }
                    //------------------------------------
                    //Core Service Product Registration
                    system.debug('iqosSuccessPR --->' + iqosSuccessPR_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber)));
                    if(!iqosSuccessPR_Map.isEmpty()){
                        if(iqosSuccessPR_Map.containsKey(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber))){
                            if(iqosSuccessPR_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber))){
                                newCase.registrationDate__c = date.valueOf(iqosRegistrationDate_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber)));
                                newCase.registrationStatus__c = iqosRegistrationStatus_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));
                                newCase.CCN__c = iqosCCN_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber);
                            }
                        }
                        //-------------------------------------
                        //Core Service Order Information
                        system.debug('iqosSuccessOI --->' + iqosSuccessOI_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber)));
                    }
                    if(!iqosSuccessOI_Map.isEmpty()){
                        if(iqosSuccessOI_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber))){
                            newCase.Total_Paid_by_Customer__c = iqosTPCustomer_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));
                            newCase.First_Time_Buyer__c = iqosFTBuyer_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));
                            newCase.Base_Price__c = iqosBasePrice_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber));    
                            warrantyInformation(newCase);    
                        }
                    }
                    //--------------------------------------
                    
                    //--------------------------------------
                    if(!iqosCSAPIProb_Map.isEmpty() && 
                        newIQOSSerielNum_Map.containsKey(jsonBody3.IssueInfo[jsonIssue].serialNumber) && 
                        iqosCSAPIProb_Map.containsKey(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber))){
                        if(iqosCSAPIProb_Map.get(newIQOSSerielNum_Map.get(jsonBody3.IssueInfo[jsonIssue].serialNumber))){
                            newCase.Core_Service_API_Problem__c = true;
                        }
                    }
                }

                //Core Service Integration Logs
                
                newCaseList.add(newCase);
            }// end for loop
        }// end if json.issueinfo.size() > 0
        if(newCaseList.size() > 0){
             //Core Service Integration Logs
            if(ILList.size() > 0){
                insert ILList;
            }
            insert newCaseList; 
            
        for(case issue: newCaseList){
                createTMH(conID,issue,false,issue.Transaction__c);

            }
        }
        if(jsonBody3.StoreInfo != null){
            createNewStore(newCaseList);
        }

        return newCaseList;
    }
    //Creating Store
    public static void createNewStore( list<case> caseList){
        system.debug('------- Inside createNewStore -------- ');
        List<Store__c> storeList = new List<Store__c>();
        RestRequest req = RestContext.request;
        IQOSResponseClass.jsonWrapper_CEA jsonBody4 = (IQOSResponseClass.jsonWrapper_CEA) json.deserialize(req.requestBody.toString(), IQOSResponseClass.jsonWrapper_CEA.class);

        Store_Type__c ST = new Store_Type__c();
        system.debug('caseList --->' +caseList);
        if(jsonBody4.StoreInfo.StoreType != null && jsonBody4.StoreInfo.StoreType != ''){
            ST = [Select Id, Description__c from Store_Type__c where Description__c =: jsonBody4.StoreInfo.StoreType limit 1];
        }
        for(case ca: caseList){
            if(jsonBody4.StoreInfo != null){
                Store__c s = new Store__c();
                s.Store_Type__c = st.Id;
                s.Store_Name__c = jsonBody4.StoreInfo.StoreName;
                s.Store_Address1__c = jsonBody4.StoreInfo.StoreAddress1;
                s.Store_Address2__c = jsonBody4.StoreInfo.StoreAddress2;
                s.Store_City__c = jsonBody4.StoreInfo.StoreCity;
                s.Store_State__c = jsonBody4.StoreInfo.StoreState;
                s.Store_Zip__c = jsonBody4.StoreInfo.storezip;
                s.Store_Comment__c = jsonBody4.StoreInfo.storecomments;
                s.Issue__c = ca.Id;
                
                storeList.add(s);
            }
            
        }
        if(storeList.size() > 0){
            insert storeList;
        }

    }
    //Creating Transaction Management
    public static Transaction_Management__c createTM(contact conID, Id DNIS, Id TFN){
        system.debug('------- Inside createTM -------- ');
        Transaction_Management__c TM = new Transaction_Management__c();
        TM.Contact__c = conID.Id;
        TM.Comments__c = 'CEA IQOS Complaint by API';
        TM.Disposition__c = 'Completed';
        TM.TFN__c = TFN;
        TM.End_Date_Time__c = system.now();
        TM.Operating_Company__c = DNIS;
        TM.Start_Date_Time__c = system.now();
        
        insert TM;
        Transaction_Management__c insertedTM = [Select Id, Name from Transaction_Management__c where Id =: TM.id limit 1];
        return insertedTM;
    }
    //Creating Transaction Management History
    public static void createTMH(contact con, case issue, boolean updateCon, Id tmID){
        system.debug('------- Inside createTMH -------- ');
        Transaction_Management_History__c TMH = new Transaction_Management_History__c();

        TMH.Contact_Associated__c = false;
        TMH.Customer__c = con.Id; 
        TMH.First_Name__c = con.FirstName;
        TMH.Issue_Reviewed_By__c = userinfo.getuserid();
        TMH.Last_Name__c = con.LastName;
        TMH.Transaction_Management__c = tmID;
        if(issue != null){
            //TMH.Transaction_Management__c = issue.Transaction__c;
            TMH.Issue__c = issue.Id;
            TMH.Service_Group_Code__c = 'CRC';
            TMH.Service_Request_Code__c = 'CREATEISSUE';
        }
        else if(issue == null && updateCon == false){
            TMH.Service_Group_Code__c = 'Consumer';
            TMH.Service_Request_Code__c = 'CREATECUST';
        }
        
        else if(issue == null && updateCon == true){
            TMH.Service_Group_Code__c = 'CUSTOMERS';
            TMH.Service_Request_Code__c = 'UPDATECUST';
        }
        
        insert TMH;
    }
    
    //Creation of Integration Log
    public static void createIL(IQOSResponseClass.jsonWrapper_CEA  req, List<jsonWrapper_Response> res, RestResponse rRes){
        IntegrationLog__c IL = new IntegrationLog__c();
        jsonWrapper_Response_Message RM = new jsonWrapper_Response_Message();
        
        IL.Callout__c = 'CEA Complaint';
        IL.FormName__c = 'Issues IQOS';
        if(rRes.statusCode == 500){
            RM.statusCode = 500;
            RM.Message = 'INTERNAL SERVER ERROR';
            IL.Message__c = JSON.Serialize(RM);
            IL.Success__c = false;
        }
        else if(rRes.statusCode == 201){
            RM.statusCode = 201;
            RM.Message = 'CREATED';
            IL.Message__c = JSON.Serialize(RM);
            IL.Success__c = true;
        }
        IL.Request__c = JSON.Serialize(req);
        IL.Response__c = JSON.Serialize(res);
        IL.Type__c = 'Alorica';
        
        insert IL;

    }
    //creation of integration log for Core Service
     public static void createIL_CS(IQOSResponseClass.jsonWrapper_MI  reqMI, IQOSResponseClass.jsonWrapper_KM reqKM, IQOSResponseClass.jsonWrapper_PR reqPR, List<IQOSResponseClass.jsonWrapper_OI> reqOI, String serialNum){
        String response = ''; 
        IntegrationLog__c IL = new IntegrationLog__c();
        jsonWrapper_Response_Message RM = new jsonWrapper_Response_Message();
        //Kit Mapping
        if(reqKM != null){
            if(reqKM.value.size() > 0){
                IL.Callout__c = 'Device to Kit - Core Services';
                IL.FormName__c = 'Issues IQOS';
                response = JSON.Serialize(reqKM);
                if(response.length() > 131072){
                    response = response.substring(0, 131072);
                }
                IL.Response__c = response;
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/'+serialNum;
                ILList.add(IL); 
            }
        }
        //Manufacturing Information
        if(reqMI != null){
            if(reqMI.value.size() > 0){
                IL.Callout__c = 'Manufacturing - Core Services';
                IL.FormName__c = 'Issues IQOS';
                response = JSON.Serialize(reqMI);
                if(response.length() > 131072){
                    response = response.substring(0, 131072);
                }
                IL.Response__c = response;
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosproductinfo/serial/'+serialNum;
                ILList.add(IL); 
            }
        }
        
        //Product Registration
        if(reqPR != null){
            if(reqPR.payload.size() > 0){
                IL.Callout__c = 'Registration - Core Services';
                IL.FormName__c = 'Issues IQOS';
                response = JSON.Serialize(reqPR);
                if(response.length() > 131072){
                    response = response.substring(0, 131072);
                }
                IL.Response__c = response;
                IL.Type__c = 'Core Services';
                IL.Success__c = true;
                RM.statusCode = 200;
                RM.Message = 'OK';
                IL.Message__c = JSON.Serialize(RM);
                IL.Request__c = Label.Core_Service_URL+'/products/v1/iqosdevicereg/type/deviceId/id/'+serialNum;
                ILList.add(IL); 
            }
        }
        
        //Order Information
        if(reqOI != null){
            if(reqOI.size() > 0){
                IL.Callout__c = 'Orders - Core Services';
                IL.FormName__c = 'Issues IQOS';
                response = JSON.Serialize(reqOI);
                if(response.length() > 131072){
                    response = response.substring(0, 131072);
                }
                IL.Response__c = response;
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
    // creation of the JSON Response
    global class jsonWrapper_Response_list{
           public list<jsonWrapper_Response> responseList{get; set;}
    }
    global class jsonWrapper_Response{
           // public String ReferenceId{get; set;}
            public String MasterId{get; set;}
            public String errorMessage{get; set;}
    }
    
    global class jsonWrapper_Response_Message{
            public integer statusCode;
            public String Message;
    }
    
     //Product Registration
    public static void productRegAPI(String serialNum){
        if(serialNum != null && serialNum != ''){
             //Product Registration
            IQOSResponseClass.jsonWrapper_PR jsonResPR;
            IQOSCallout ic = new IQOSCallout(); 
            jsonResPR = ic.csProductRegCallout(serialNum);
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
                        createIL_CS(null,null,jsonResPR,null,serialNum);
                        iqosSuccessPR_Map.put(serialNum, true);
                        iqosCCN_Map.put(serialNum, mapJSON.values()[0].ccn);
                        iqosRegistrationDate_Map.put(serialNum, mapJSON.values()[0].registrationDate);
                        iqosRegistrationStatus_Map.put(serialNum, mapJSON.values()[0].registrationStatus);
       
                    }else{
                        iqosSuccessPR_Map.put(serialNum, false);
                    }
                }
            //iqosCSAPIProb_Map.put(serialNum, false);
            }else{
                //system.assertequals('test',serialNum);
                iqosSuccessPR_Map.put(serialNum, false);
                iqosCSAPIProb_Map.put(serialNum, true);
            }
        }

    }
     //Order Information
    public static void orderInfoAPI(String serialNum){
        if(serialNum != null && serialNum != ''){
        //Order Information
            List<IQOSResponseClass.jsonWrapper_OI> jsonResOI;
            IQOSCallout ic = new IQOSCallout(); 
            jsonResOI = ic.csOrderInfoCallout(serialNum);
            String sDate;
            date maxDate;
            List<Date> dateList = new List<Date>();
            map<string,IQOSResponseClass.jsonWrapper_OI> mapJSON = new map<string,IQOSResponseClass.jsonWrapper_OI>();
            map<string,IQOSResponseClass.jsonWrapper_OrderItems> mapOrderItems = new map<string,IQOSResponseClass.jsonWrapper_OrderItems>();
            map<string,IQOSResponseClass.jsonWrapper_OrderItems> mapOrderItemsSerialMatched = new map<string,IQOSResponseClass.jsonWrapper_OrderItems>();
            if(jsonResOI != null){
                //getting and converting the dates to salesforce date format
                if(jsonResOI.size() > 0){
                createIL_CS(null,null,null,jsonResOI,serialNum);
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
                    iqosSuccessOI_Map.put(serialNum, true);                
                    iqosPurchaseDate_Map.put(serialNum, maxDate);
                    iqosTPCustomer_Map.put(serialNum, mapOrderItemsSerialMatched.values()[0].totalPaidByCustomer);
                    iqosFTBuyer_Map.put(serialNum, mapOrderItemsSerialMatched.values()[0].firstTimeBuyer);
                    iqosBasePrice_Map.put(serialNum,mapOrderItemsSerialMatched.values()[0].basePrice);

                 }
                //Serial Number not matched get the first value on the list
                else if(mapOrderItems.values().size()>0){
                    system.debug('----Inside mapOrderItems----');
                    iqosSuccessOI_Map.put(serialNum, true);
                    iqosPurchaseDate_Map.put(serialNum, maxDate);
                    iqosTPCustomer_Map.put(serialNum, mapOrderItems.values()[0].totalPaidByCustomer);
                    iqosFTBuyer_Map.put(serialNum, mapOrderItems.values()[0].firstTimeBuyer);
                    iqosBasePrice_Map.put(serialNum,mapOrderItems.values()[0].basePrice);
                    
                }else{
                    iqosSuccessOI_Map.put(serialNum, false);
                }
            //iqosCSAPIProb_Map.put(serialNum, false);
            }else{
                iqosSuccessOI_Map.put(serialNum, false);
                iqosCSAPIProb_Map.put(serialNum, true);
            }
        }
    } 
    // Warranty Information
    public static void warrantyInformation(case newCase){
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
        
        if(newCase.registrationStatus__c != null && newCase.registrationStatus__c != ''){
            newCase.Warranty_Start_Date__c = newCase.Purchase_Date__c;
            if(newCase.registrationStatus__c == 'Active' && newCase.First_Time_Buyer__c == true && (newCase.CCN__c != null && newCase.CCN__c != '')){
                if(newCase.Purchase_Date__c != null){
                    newCase.Warranty_Expiration_Date__c = newCase.Purchase_Date__c + integer.valueof(warrantyBD) + integer.valueof(warrantyED);
                }
            }else{
                if(newCase.Purchase_Date__c != null){
                    newCase.Warranty_Expiration_Date__c = newCase.Purchase_Date__c + integer.valueof(warrantyBD);
                }
            }
            
            if(newCase.Incident_Date__c != null){
                if(newCase.Warranty_Expiration_Date__c != null)
                warrantDaysExp = newCase.Incident_Date__c.daysBetween(newCase.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    newCase.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else if(warrantDaysExp > 0) {
                    newCase.Warranty_Status__c = 'UNDER WARRANTY';
                }
                //If Purchase Date is null
                else{
                    newCase.Warranty_Status__c = '';
                }
            }
            else if(newCase.CreatedDate__c != null && newCase.CreatedDate__c !=''){
                String cDate = newCase.CreatedDate__c.substring(6,10) + '-' + newCase.CreatedDate__c.substring(0,2) + '-' + newCase.CreatedDate__c.substring(3,5);
                if(newCase.Warranty_Expiration_Date__c != null)
                warrantDaysExp = date.valueof(cDate).daysBetween(newCase.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    newCase.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else if(warrantDaysExp > 0) {
                    newCase.Warranty_Status__c = 'UNDER WARRANTY';
                }
                //If Purchase Date is null
                else{
                    newCase.Warranty_Status__c = '';
                }
            }
            //New issue created
            else if(newCase.CreatedDate__c == null || newCase.CreatedDate__c == ''){
                if(newCase.Warranty_Expiration_Date__c != null)
                warrantDaysExp = System.today().daysBetween(newCase.Warranty_Expiration_Date__c);
                if(warrantDaysExp < 0){
                    newCase.Warranty_Status__c = 'WARRANTY IS EXPIRED';
                }
                else if(warrantDaysExp > 0) {
                    newCase.Warranty_Status__c = 'UNDER WARRANTY';
                }
                //If Purchase Date is null
                else{
                    newCase.Warranty_Status__c = '';
                }
            }
        }
    }
 

}