public without sharing class MelissaCallout{
     
     Melissa_Integration__c settings;
     private final String xxx_zipLookupServiceBaseURL;
     private final String xxx_usaAddressServiceBaseURL;
     private final String xxx_globalAddressServiceBaseURL;
     private final String xxx_UserId;
     
     public IntegrationLog__c log;
     private Integer LogRequestMaxLength;
     private Integer LogResponseMaxLength;
     
      public MelissaCallout(String strCalloutType){
        settings = Melissa_Integration__c.getOrgDefaults();
        log = new IntegrationLog__c( Type__c = 'Melissa', Callout__c = strCalloutType, Message__c = '');
        xxx_zipLookupServiceBaseURL = settings.ZipEndPointURL__c;
        xxx_usaAddressServiceBaseURL= settings.USAAddressEndPoint__c;
        xxx_globalAddressServiceBaseURL = settings.globalAddressEndPoint__c;
        xxx_UserId =  settings.User_Id__c;
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
     
     public void transaction(String tranId){
         log.Transaction_Management__c =  TranId;
     }
     
     public void formName(String FormName){
         log.FormName__c = FormName;
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
     
    
     public MelissaClasses.zipLookupResponse ZipLookupRequest(String zipCodeval){
        
        HttpRequest req = new HttpRequest();
        String ZipEndPointURL = 'web/ExpressPostalCode?format=JSON&id='+xxx_UserId+'&postalcode='+zipCodeval+'&maxrecords=1';
        req.setEndpoint(xxx_zipLookupServiceBaseURL + ZipEndPointURL);
        req.setMethod('GET');
        req.setTimeout(getTimeOut());
        
        logRequest(xxx_zipLookupServiceBaseURL + ZipEndPointURL);
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req);            
        }else{
             res = new HTTPResponse();  
             string strResponseBody = '';
             if(zipCodeval.contains('15221')){

                 strResponseBody = '';
             }else{    
                 strResponseBody = '{"Version":"3.0.0a","ResultCode":"XS01","ErrorString":"","Results":[{"Address":{"AddressLine1":"","City":"Cape Coral","CityAccepted":"","CityNotAccepted":"","State":"FL","PostalCode":"33909","CountrySubdivisionCode":"US-FL","AddressKey":"","SuiteName":"","SuiteCount":0,"SuiteList":[""],"PlusFour":[""],"MAK":"","BaseMAK":""}}]}';
             }
             res.setBody(strResponseBody);
        }
        
        
        String strResponse = res.getBody();
        System.debug('Test zip'+strResponse);
        logResponse(strResponse);
        MelissaClasses.zipLookupResponse response;
        
        if(zipCodeval == '99999'){
            
            MelissaClasses.AddressInnerClass ccInner = new MelissaClasses.AddressInnerClass();
            ccInner.City = 'UNKNOWN';
            ccInner.PostalCode = '99999';
            ccInner.State = 'XX';
            MelissaClasses.AddressOuterClass ccOuter = new MelissaClasses.AddressOuterClass();
            ccOuter.Address = ccInner;
            List<MelissaClasses.AddressOuterClass> ccOuterList = new List<MelissaClasses.AddressOuterClass>();
            ccOuterList.add(ccOuter);
            MelissaClasses.zipLookupResponse resZip = new MelissaClasses.zipLookupResponse();
            resZip.Results = ccOuterList;
            response = resZip;
        }else{ 
            response = (MelissaClasses.zipLookupResponse)Json.deserialize(strResponse, MelissaClasses.zipLookupResponse.class);
        }
        String strStatus = response.ResultCode;
        if(String.isNotEmpty(strStatus) && strStatus.equalsIgnoreCase('XS01'))
            log.Success__c = true;
            
        if(String.isNotEmpty(strStatus ))   
            log('Result Code: ' + strStatus );
            
        String strErrSpecMessage = response.ErrorString;
        if(String.isNotEmpty(strErrSpecMessage))
            log('Error_spcMessage: ' + strErrSpecMessage);
                                   
        
        return response;
     }
     
     
     public List<MelissaClasses.consumerAddressInnerResponse> usaAddressRequest(MelissaClasses.consumerAddressRequest addressObj){
        
        List<MelissaClasses.consumerAddressInnerResponse> consumerAddResList = new List<MelissaClasses.consumerAddressInnerResponse>();
        
        try{
            String requestValue = '{CustomerID:"'+xxx_UserId+'",Records:[{"';
            requestValue += 'RecordID":"1","';
            requestValue += 'AddressLine1":"'+addressObj.AddressLine1+'","';
            requestValue += 'AddressLine2":"'+addressObj.AddressLine2+'","';
            requestValue += 'Locality":"'+addressObj.City+'","'; 
            requestValue += 'AdministrativeArea":"'+addressObj.State+'","'; 
            requestValue += 'PostalCode":"'+addressObj.PostalCode+'","'; 
            requestValue += 'AddressLine3":"'+ +'","';
            requestValue += 'AddressLine4":"'+ +'","';
            requestValue += 'AddressLine5":"'+ +'","';
            requestValue += 'AddressLine6":"'+ +'","';
            requestValue += 'AddressLine7":"'+ +'","';
            requestValue += 'AddressLine8":"'+ +'","';
            requestValue += 'DoubleDependentLocality":"'+ +'","';
            requestValue += 'DependentLocality":"'+ +'","';      
            requestValue += 'SubAdministrativeArea":"'+ +'","';        
            requestValue += 'SubNationalArea":"'+ +'","';  
            requestValue += 'Country":"'+addressObj.Country+'"}]}';
            System.debug('requestValue'+requestValue);
            
            
            HttpRequest req = new HttpRequest();
            String endPoint = '/v3/WEB/ContactVerify/doContactVerify';
            req.setEndpoint(xxx_usaAddressServiceBaseURL + endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(getTimeOut());
            req.setBody(requestValue);
            
            logRequest(requestValue);
            Http http = new Http();
            HTTPResponse res;
            String responseStatus;
            if(!Test.isRunningTest()){
                res = http.send(req);  
                responseStatus = res.getStatus();
            }else{
                 res = new HTTPResponse();  
                 string strResponseBody = '';
                 if(requestValue.contains('15220')){
    
                     strResponseBody = '';
                 }else{    
                     strResponseBody = '{"Records":[{"AddressExtras":" ","AddressKey":"15220231422","AddressLine1":"532 Chatham Park Dr Apt 2B","AddressLine2":" ","City":"Pittsburgh","CompanyName":" ","EmailAddress":" ","MelissaAddressKey":"8683969182","NameFull":" ","PhoneNumber":" ","PostalCode":"15220-2314","RecordExtras":" ","RecordID":"1","Reserved":" ","Results":"AC02,AC03,AC13,AS01","State":"PA"}],"TotalRecords":"1","TransmissionReference":" ","TransmissionResults":" ","Version":"4.0.25"}';
                 	 responseStatus = 'OK';
                 }
                 res.setBody(strResponseBody);
            }
            
           
            System.debug('Address verification: '+responseStatus);
            if(responseStatus!='OK'){
                logResponse('Error_spcMessage: Server Error, Please try again!');
                log.Success__c = false; 
                consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('Error','Server Error, Please try again!')); 
            }else{
                String strResponse = res.getBody();
                MelissaClasses.consumerData responseData = (MelissaClasses.consumerData)Json.deserialize(strResponse, MelissaClasses.consumerData.class);
                System.debug('test response '+responseData);
                
                logResponse(strResponse);
                log.Success__c = true;
                
                if(!responseData.Records.isEmpty() && responseData.Records.size() >0){
                    MelissaClasses.consumerAddressResponse customerInfo = responseData.Records[0];
                    Boolean verifyAddress = false;
                    Map<String, AddressResponse__c> addressCodeMap = AddressResponse__c.getAll(); //AC01,AC02,AC03,AC13,AS01
                    
                    if(customerInfo.Results.contains('AS01')){
                        if(customerInfo.PostalCode != null && customerInfo.PostalCode.trim() != '' &&  customerInfo.PostalCode.length() >5){
                            customerInfo.PostalCode = customerInfo.PostalCode.subString(0,5);
                        }
                        
                        if(addressObj.City == customerInfo.City && addressObj.State == customerInfo.State && addressObj.PostalCode == customerInfo.PostalCode){
                            consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('Success','Address Verified'));  
                            verifyAddress = true;
                        }else{                        
                            String MessageInfo = 'Address may require adjustment , ZIP should  be '+ customerInfo.PostalCode+', City should be '+ customerInfo.City+', State should be '+customerInfo.State+'.  Please adjust address if applicable';
                            consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('Info', MessageInfo));                        
                        }
                    }else{   
                        if(!addressCodeMap.isEmpty() && customerInfo.Results != null && customerInfo.Results.trim() != ''){
                            for(AddressResponse__c add :addressCodeMap.values()){
                                if(customerInfo.Results.contains(add.Name)){
                                    consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse(add.Name, add.Response_Description__c));
                                }
                            }
                        }
                    }                    
                    
                    if(consumerAddResList.isEmpty()){
                        consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('Error','Address not Verified'));
                    } 
                    
                }else{
                    consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('info','No data found, please verify mannully')); 
                }      
            }
        }catch (Exception e){
            System.debug('ERROR:' + e);
            consumerAddResList.add(new MelissaClasses.consumerAddressInnerResponse('Error','Server Error, Please try again!'));  
        }
        
        return consumerAddResList;    
    }
    
    public class MelissaCalloutException extends Exception{}    
    
}