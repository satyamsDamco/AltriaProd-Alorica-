/*
*   @Author: Gian Carlo Cutchon
*   @Date: 12/12/2018
*   @Apex Name: LexisNexis_Callout
*   @Description: This class is use for Lexis call out to server.
*
*/
public with sharing class LexisNexis_Callout{
    
    public LexisNexisResponseClass.AgeVerificationResponse AgeVerification_Callout(LexisNexisResponseClass.AgeVerificationRequest jsonSetBody, String AccountName){
        
        LexisNexisResponseClass.AgeVerificationResponse jsonResponse;
        String TransactionStatus;
        LexisNexis_Integration__c settings;
        
        if(AccountName != null && AccountName != ''){
            settings = LexisNexis_Integration__c.getInstance(AccountName);      
        }else{
            settings = LexisNexis_Integration__c.getInstance('PMUSA');
        }  
        String username = settings.User_Id__c;
        String password = settings.Password__c;
        //string url = 'https://staging.ws.idms.lexisnexis.com/restws/identity/v2/48075/CRC_Ver/conversation';
        string url = settings.EndPointURL__c + '/restws/identity/v2/' + settings.Account_Number__c + '/' + settings.Workflow_Name__c + '/conversation';

        HttpResponse res;
        HttpRequest req = new HttpRequest();
        req.setEndPoint(url); 
        req.setMethod('POST');

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json'); 
        
        /*LexisNexisResponseClass.AgeVerificationRequest jsonSetBody = new LexisNexisResponseClass.AgeVerificationRequest();
        jsonSetBody.Settings = new LexisNexisResponseClass.jsonWrapper_Settings();
        jsonSetBody.Settings.Mode = 'live';
        jsonSetBody.Settings.Reference = '48175';
        jsonSetBody.Settings.Locale = 'en_US';
        jsonSetBody.Settings.Venue = 'online';
        jsonSetBody.Person = new LexisNexisResponseClass.jsonWrapper_Person();
        jsonSetBody.Person.Name = new LexisNexisResponseClass.jsonWrapper_Name();
        jsonSetBody.Person.Name.FirstName = 'John';
        jsonSetBody.Person.Name.LastName = 'Doe';
        jsonSetBody.Person.Addresses = new list<LexisNexisResponseClass.jsonWrapper_Addresses>{new LexisNexisResponseClass.jsonWrapper_Addresses()};
        jsonSetBody.Person.Addresses[0].StreetAddress1 = '555 Main St W';
        jsonSetBody.Person.Addresses[0].StreetAddress2 = 'Apt 123';
        jsonSetBody.Person.Addresses[0].City = 'Anytown';
        jsonSetBody.Person.Addresses[0].State = 'FL';
        jsonSetBody.Person.Addresses[0].Zip5 = '33498';
        jsonSetBody.Person.Addresses[0].Country = 'US';
        jsonSetBody.Person.Addresses[0].Context = 'primary';
        jsonSetBody.Person.DateOfBirth = new LexisNexisResponseClass.jsonWrapper_DOB();
        jsonSetBody.Person.DateOfBirth.Year = 1967; 
        jsonSetBody.Person.DateOfBirth.Month = 12; 
        jsonSetBody.Person.DateOfBirth.Day = 13; */
        
        String s = JSON.Serialize(jsonSetBody);
        system.debug (s);
        req.setBody(JSON.Serialize(jsonSetBody));
        
        Http http_req = new Http();
        res = http_req.send(req);
        String statusCode = string.valueof(res.getStatusCode());
        String resStatus = res.getStatus();
        string myReturn = res.getBody(); //this is your return json object
        System.Debug('LexisNexis Response----------------> ' +res.toString());
        System.Debug('reponse ---> ' + myReturn );  
        
        if(statusCode == '200'){
            //LexisNexisResponseClass.AgeVerificationResponse jsonResponse = new LexisNexisResponseClass.AgeVerificationResponse();
            jsonResponse = (LexisNexisResponseClass.AgeVerificationResponse) json.deserialize(myReturn, LexisNexisResponseClass.AgeVerificationResponse.class );
            System.Debug('JSON reponse ---> ' + jsonResponse ); 
            
            if(jsonResponse.Status != null){
                TransactionStatus = jsonResponse.Status.TransactionStatus;
            }
                        
        }else{
            TransactionStatus = resStatus;
        }
        System.Debug('resStatus ---> ' + resStatus );
        System.Debug('TransactionStatus ---> ' + TransactionStatus );
        if(TransactionStatus != '' && TransactionStatus!= null && (TransactionStatus == 'passed' || TransactionStatus == 'failed')){
            return jsonResponse;
        }else{
            return null;
        }
        
    }
}