public without sharing class LexisNexisCallout{
     
     LexisNexis_Integration__c settings;
     @TestVisible private final String xxx_serviceBaseURL;
     public string EndPointURL;
     
     public IntegrationLog__c log;
     private Integer LogRequestMaxLength;
     private Integer LogResponseMaxLength;
     
      public LexisNexisCallout(String strCalloutType, string AccountName){
       log = new IntegrationLog__c( Type__c = 'Lexis Nexis', Callout__c = strCalloutType, Message__c = '');
       try{
            settings = LexisNexis_Integration__c.getInstance(AccountName);
            xxx_serviceBaseURL = settings.EndPointURL__c;        
        }catch (Exception e){
            settings = LexisNexis_Integration__c.getInstance('PMUSA');
            xxx_serviceBaseURL = settings.EndPointURL__c; 
        }   
     }
     
     public void transaction(String tranId){
         log.Transaction_Management__c =  TranId;
     }
     
     public void formName(String FormName){
         log.FormName__c = FormName;
     }
     
     public void customerCCN(String customerCCN){
         log.CustomerCCN__c = customerCCN;
     }
     
     public void customerUpdate(String customerObj){
         log.Consumer_Trade_Customer__c = customerObj;
     }
     
     public integer getTimeOut(){
         if(settings.RequestTimeOut__c == null || settings.RequestTimeOut__c > 60)
            return 6000;
         else
            return Integer.ValueOf(settings.RequestTimeOut__c * 1000) ;
     }
     
     public void log(String strMessage){
        if(String.isNotBlank(log.Message__c))
            log.Message__c += '\n';
        log.Message__c += strMessage; 
     }
     
     public void log(Exception ex){
         String strException = ex.getTypeName()  + ' ' + ex.getMessage() + '\n' + ex.getStackTraceString();
         log(strException);
         log.Success__c = false;
     }
     
     public void logRequest(String strRequest){
         if(LogRequestMaxLength == null)
            LogRequestMaxLength = IntegrationLog__c.Request__c.getDescribe().getLength();
         log.Request__c = strRequest.length() > LogRequestMaxLength ? strRequest.substring(LogRequestMaxLength - 100) + ' .... **Request JSON is truncated because it was exceeding the field size.' : strRequest;
     }
     
     public void logResponse(String strResponse){
         if(LogResponseMaxLength == null)
            LogResponseMaxLength = IntegrationLog__c.Response__c.getDescribe().getLength();
         log.Response__c = strResponse.length() > LogResponseMaxLength ? strResponse.substring(LogResponseMaxLength - 100) + ' .... **Response JSON is truncated because it was exceeding the field size.' : strResponse;
     }
     
     public LexisNexisClasses.AgeVerificationResponse AgeVerificationRequest(LexisNexisClasses.AgeVerificationRequest requestBody){     
        LexisNexisClasses.AgeVerificationResponse cObj = new LexisNexisClasses.AgeVerificationResponse();
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String transactionID= h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        HttpRequest req = new HttpRequest();
        EndPointURL = '/identity-proofing/services/identityProofingServiceWS/v2';
        req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
        req.setMethod('GET');        
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', '""');
        req.setHeader('Accept-Encoding', 'gzip,deflate');
        req.setTimeout(getTimeOut());        
        String requestXMLBody = '';
        requestXMLBody += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        requestXMLBody += '<soap:Header><wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">';
        requestXMLBody += '<wsse:UsernameToken wsu:Id="UsernameToken-49" xmlns:wsu="http://docs.oasisopen.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
        requestXMLBody += '<wsse:Username>'+settings.Account_Number__c+'/'+settings.User_Id__c+'</wsse:Username>';
        requestXMLBody += '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+settings.Password__c+'</wsse:Password>';
        requestXMLBody += '</wsse:UsernameToken></wsse:Security></soap:Header>';
        requestXMLBody += '<soap:Body>';
        requestXMLBody += '<invokeIdentityService xmlns:wsn="http://ns.lexisnexis.com/identity-proofing/1.0">';
        requestXMLBody += '<wsn:identityProofingRequest wsn:transactionID="'+transactionID+'" wsn:locale="en_US" wsn:customerReference="180690628">';
        requestXMLBody += '<wsn:workFlow>'+settings.Workflow_Name__c+'</wsn:workFlow>';
        requestXMLBody += '<wsn:inputSubject>';
        requestXMLBody += '<wsn:person>';
        requestXMLBody += '<wsn:name>';
        if(requestBody.Prefix != '' && requestBody.Prefix != null)
            requestXMLBody += '<wsn:prefix>'+requestBody.Prefix+'</wsn:prefix>';
        else
            requestXMLBody += '<wsn:prefix/>';
        if(requestBody.FirstName != '' && requestBody.FirstName != null)
            requestXMLBody += '<wsn:first>'+requestBody.FirstName+'</wsn:first>';
        else
            requestXMLBody += '<wsn:first/>';
        if(requestBody.MiddleName != '' && requestBody.MiddleName != null)
            requestXMLBody += '<wsn:middle>'+requestBody.MiddleName+'</wsn:middle>';
        else
            requestXMLBody += '<wsn:middle/>';
        if(requestBody.LastName != '' && requestBody.LastName != null)
            requestXMLBody += '<wsn:last>'+requestBody.LastName+'</wsn:last>';
        else
            requestXMLBody += '<wsn:last/>';
        if(requestBody.Suffix != '' && requestBody.Suffix != null)
            requestXMLBody += '<wsn:suffix>'+requestBody.Suffix+'</wsn:suffix>';
        else
            requestXMLBody += '<wsn:suffix/>';
        requestXMLBody += '</wsn:name>';
        requestXMLBody += '<wsn:dateOfBirth>';
        if(requestBody.DOBYear != '' && requestBody.DOBYear != null)
            requestXMLBody += '<wsn:Year>'+requestBody.DOBYear+'</wsn:Year>';
        else
            requestXMLBody += '<wsn:Year/>';
        if(requestBody.DOBMonth != '' && requestBody.DOBMonth != null)
            requestXMLBody += '<wsn:Month>'+requestBody.DOBMonth+'</wsn:Month>';
        else
            requestXMLBody += '<wsn:Month/>';
        if(requestBody.DOBDay != '' && requestBody.DOBDay != null)
            requestXMLBody += '<wsn:Day>'+requestBody.DOBDay+'</wsn:Day>';
        else
            requestXMLBody += '<wsn:Day/>';
        requestXMLBody += '</wsn:dateOfBirth>';
        requestXMLBody += '<wsn:address addressPurpose="PRIMARY_RESIDENCE">';
        if(requestBody.AddressLine1 != '' && requestBody.AddressLine1 != null)
            requestXMLBody += '<wsn:addressLine1>'+requestBody.AddressLine1+'</wsn:addressLine1>';
        else
            requestXMLBody += '<wsn:addressLine1/>';
        if(requestBody.AddressLine2 != '' && requestBody.AddressLine2 != null)
            requestXMLBody += '<wsn:addressLine2>'+requestBody.AddressLine2+'</wsn:addressLine2>';
        else
            requestXMLBody += '<wsn:addressLine2/>';
        if(requestBody.City != '' && requestBody.City != null)
            requestXMLBody += '<wsn:city>'+requestBody.City+'</wsn:city>';
        else
            requestXMLBody += '<wsn:city/>';
        if(requestBody.State != '' && requestBody.State != null)
            requestXMLBody += '<wsn:stateCode>'+requestBody.State+'</wsn:stateCode>';
        else
            requestXMLBody += '<wsn:stateCode/>';
        if(requestBody.Zip != '' && requestBody.Zip != null)
            requestXMLBody += '<wsn:zip5>'+requestBody.Zip+'</wsn:zip5>';
        else
            requestXMLBody += '<wsn:zip5/>';
        requestXMLBody += '</wsn:address>';
        requestXMLBody += '</wsn:person>';
        requestXMLBody += '</wsn:inputSubject>';
        requestXMLBody += '</wsn:identityProofingRequest>';
        requestXMLBody += '</invokeIdentityService>';
        requestXMLBody += '</soap:Body>';
        requestXMLBody += '</soap:Envelope>';     
        Http http = new Http();
        req.setBody(requestXMLBody);
        logRequest(requestXMLBody);
        HTTPResponse res; 
        if(!Test.isRunningTest()){
            res = http.send(req);
        }else{
            res = new HTTPResponse();
             string responseXMLTest = '';
             if(requestXMLBody.contains('123')){
                 responseXMLTest = '';
             }else if(requestXMLBody.contains('9876')){          
                responseXMLTest += '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
                responseXMLTest += '<soap:Body>';
                responseXMLTest += '<ns1:invokeIdentityServiceResponse xmlns:ns1="http://ws.identityproofing.idm.risk.lexisnexis.com/">';
                responseXMLTest += '<identityProofingResponse xmlns="http://ns.lexisnexis.com/identity-proofing/1.0" xmlns:ns="http://ns.lexisnexis.com/identity-proofing/1.0" ns:transactionID="00f615da-cd0b-26f3-df39-c2dd86f809f2" ns:responseUniqueId="60090736">';
                responseXMLTest += '<workFlow>CRC_NEW</workFlow>';
                responseXMLTest += '<status>FAIL</status>';
                responseXMLTest += '<statusDescription>Failed to retrieve a unique identity</statusDescription>';
                responseXMLTest += '</identityProofingResponse></ns1:invokeIdentityServiceResponse></soap:Body></soap:Envelope>';
             }else{          
                responseXMLTest += '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
                responseXMLTest += '<soap:Body>';
                responseXMLTest += '<ns1:invokeIdentityServiceResponse xmlns:ns1="http://ws.identityproofing.idm.risk.lexisnexis.com/">';
                responseXMLTest += '<identityProofingResponse xmlns="http://ns.lexisnexis.com/identity-proofing/1.0" xmlns:ns="http://ns.lexisnexis.com/identity-proofing/1.0" ns:transactionID="00f615da-cd0b-26f3-df39-c2dd86f809f2" ns:responseUniqueId="60090736">';
                responseXMLTest += '<workFlow>CRC_NEW</workFlow>';
                responseXMLTest += '<status>Pass</status>';
                responseXMLTest += '<statusDescription>Failed to retrieve a unique identity</statusDescription>';
                responseXMLTest += '</identityProofingResponse></ns1:invokeIdentityServiceResponse></soap:Body></soap:Envelope>';
             }
             res.setBody(responseXMLTest);
        }
        String strResponse = res.getBody();
        string status = res.getStatus();
        logResponse(strResponse);     
        String statusResponse, messageResponse;   
        if(String.isNotEmpty(status) && status == 'OK'){   
            log.Success__c = true;
            XMLDom xmlDomObj;         
            boolean isResponseError = false;  
            xmlDomObj = new XMLDom(strResponse);
            List <XMLDom.Element> lstRecordElements = xmlDomObj.getElementsByTagName('invokeIdentityServiceResponse');
            for(XMLDom.Element  child: lstRecordElements){
                for(XMLDom.Element  elementRecord: child.childNodes){
                    for(XMLDom.Element  elementRecord1 : elementRecord.childNodes){
                        if(elementRecord1.nodeName.toLowerCase() == 'status'){
                            statusResponse = elementRecord1.NodeValue.tolowerCase();
                            if(statusResponse == 'PASS'){
                                messageResponse = 'Age verified';
                            }else{
                                messageResponse = 'Age could not be verified';                                
                            }
                        }
                    }
                }
            }            
        }else{
            statusResponse = 'Error';
            messageResponse = '';
        }
        cObj.Status = statusResponse;
        cObj.Message = messageResponse;
        return cObj;
     }
         
    public class LexisNexisCalloutException extends Exception{}    
    
}