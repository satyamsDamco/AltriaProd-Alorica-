public without sharing class AcxiomCallout{
     
     Acxiom_Integration__c settings;
     private final String xxx_serviceBaseURL;
     private final string xxx_environmentType;
     private AcxiomClasses.TokenInfo currentToken;
     public string EndPointURL;     
     public IntegrationLog__c log;
     private Integer LogRequestMaxLength;
     private Integer LogResponseMaxLength;
     
    
     public AcxiomCallout(String strCalloutType){
        settings = Acxiom_Integration__c.getOrgDefaults();
        log = new IntegrationLog__c( Type__c = 'Acxiom', Callout__c = strCalloutType, Message__c = '');
        xxx_serviceBaseURL = settings.EndPointURL__c; 
        if(settings.Environment_Type__c == null || settings.Environment_Type__c == ''){
            xxx_environmentType = 'UAT';
        }else{
            xxx_environmentType = settings.Environment_Type__c; 
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
     
     public AcxiomClasses.TokenInfo getAccessToken(){         
         
         //RITM0214539 - API conversion to AIM - Updated access token process
         EndpointURL = settings.TokenEndpointURL__c;
         
         String authURL = 'https://api.insightsc3m.com/altria/oauth2/v2.0/token';
         String clientID = 'b7df4062-00b4-45bf-955a-1bf2d1a5dbcb';
         String clientSecret = 'Gve8Q~iWljbzQLXr-AvMHkiNrEGvKsOxOBQDBbQ7';
         String clientScope = 'https://api.insightsc3m.com/.default';
         
         
		 String body = 'grant_type=client_credentials&client_id='+clientID+'&client_secret='+clientSecret+'&scope='+clientScope;         
         String strResponseBody ='';
         Http http = new Http();
         HTTPResponse res; 
         
         if(!Test.isRunningTest()){
             HttpRequest req = new HttpRequest();
             req.setEndpoint(authURL);
             req.setMethod('POST');
             req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             req.setHeader('Ocp-Apim-Subscription-Key', 'c92441e743a7413ebec0709289ee1f9c');
             req.setBody(body);
             req.setTimeout(getTimeOut());

             res = http.send(req);
             
         }else{
             
             res = new HTTPResponse();    
             AcxiomClasses.TokenInfo response = new AcxiomClasses.TokenInfo();
             response.access_token = 'xyvyerev765775675ghfg';
             response.expires_in = '1799';
             response.token_type = 'trtyxyvyerev765775675ghfg';
             
             String strResponseBody1 = JSON.serialize(response);
             
             res.setBody(strResponseBody1);      
         }
         strResponseBody = res.getBody();
         logResponse(strResponseBody);
         currentToken = (AcxiomClasses.TokenInfo)Json.deserialize(strResponseBody, AcxiomClasses.TokenInfo.class);
         log.Success__c = true;
         
         if(currentToken == null || String.isEmpty(currentToken.access_token))
            throw new AcxiomCalloutException('Unable to get access token from Acxiom');
            
         return currentToken;
     }
     
    
    public AcxiomClasses.ConsumerFinalResponse FullSearchLookupRequest(String strRequestBody){
        
        //RITM0214539 - API conversion to AIM - Updated FullSearch Lookup Request
        HttpRequest req = new HttpRequest();
        EndPointURL = '/'+ settings.fullsearchMethod__c + '/'+ settings.Vendor_cd__c + '/' + settings.Channel_type_cd__c + '/' + settings.Website_Id__c;
        
		//2025-05-28
		//req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
        req.setEndpoint('https://api.insightsc3m.com/aimfullsearch' + EndPointURL);
		
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        //2025-05-28
		//req.setHeader('Authorization', currentToken.token_type+' '+currentToken.access_token);
		req.setHeader('Authorization', 'Bearer '+currentToken.access_token);
		req.setHeader('Ocp-Apim-Subscription-Key', 'fc32f147b727473c83aed0b9d3f1f458');
        req.setTimeout(getTimeOut());
        
        Http http = new Http();
        req.setBody(strRequestBody);
        
        logRequest(strRequestBody);
        
        HTTPResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req);            
        }else{
             res = new HTTPResponse();
             string strResponseBody = '';
             if(strRequestBody.contains('123')){
                 strResponseBody = '';
             }else{          
                 strResponseBody = '{"AuthenticationData":[{"ConsumerAuthCd":"Y","PID":"234563456"}],"RequestId":"c1eaa693-e3dd-4b7b-9133-6b689d518d87","StatusData":[{"ConsumerMessage":null,"StatusCode":"0000","StatusMessage":"SUCCESS"}],"WinningCCN":18241815,"CCN":18241815,"RetiredIDs":[],"WebSiteData":[],"ModelScores":null,"QualificationData":{"OpCoQualification":[{"AVCode":"2","AVOwner":"JMC","ConsumerAuthCD":"Y","DateOfBirth":"1964-08-09T00:00:00","OpCo":"PMUSA","PLCertificationQualifiedData":[{"CertificationCD":"S","ProductLineCD":"IQ","QualifiedCD":"S"},{"CertificationCD":"S","ProductLineCD":"TP","QualifiedCD":"S"},{"CertificationCD":"Y","ProductLineCD":"AS","QualifiedCD":"Y"},{"CertificationCD":"S","ProductLineCD":"ST","QualifiedCD":"S"}]}]},"AvailabilityData":{"ConsumerOptOffCD":null,"ConsumerOptOffReasonCD":null,"OpCoOptOff":[],"OptOffDate":null,"PLBrandOptOff":[],"PLOpCoOptOff":[],"ProductLineOptOff":[]},"ChannelData":{"Channel":[{"ChannelTypeCD":"DM","ChannelOptOff":null,"OptOffReasonCD":null,"ChannelShareLevelCD":"IND","ChannelOpCoOptOff":null,"ChannelBrand":[{"BrandFamilyCD":"02","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"03","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"04","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"05","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"09","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"13","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"40","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"43","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"46","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"67","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"90","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"BR","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"BX","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CD","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CDS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CO","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"DV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"EY","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"GS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"H2O","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"HD","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"HU","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"IQ","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"JCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"JU","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"NS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"NSI","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"PCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"PV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RC","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"ROY","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RT","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"SCA","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"SK","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"SL","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"SWB","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"UCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"VRV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"Z1","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"}],"ChannelLevel":[{"ContactLevel":"INDIV","AddressType":[{"AddressTypeCD":"H","ContactInfo":[{"Name":"Title","Value":"MR"},{"Name":"Fname","Value":"MICHAEL"},{"Name":"MidName","Value":"V"},{"Name":"Lname","Value":"SLEMP"},{"Name":"Addr1","Value":"179 COPLEY BRANCH RD"},{"Name":"City","Value":"BUTLER"},{"Name":"State","Value":"TN"},{"Name":"Zip","Value":"37640"},{"Name":"Zip4","Value":"7204"}],"ContactInfoStatus":{"ChannelStatus":"Y","ValidityFlag":"Y","ValidityReasons":[],"DeliverabilityFlag":"Y","DeliverabilityReasons":[],"RestrictedFlag":"N","RestrictedReasons":[],"SuppressedFlag":"N","SuppressedReasons":[]},"IndivDOIDate":null,"IndivDOISourceProgram":null,"IndivDOISourceProgramPhase":null,"SourceTransDate":"2012-03-30T15:36:56"}]}]},{"ChannelTypeCD":"EM","ChannelOptOff":null,"OptOffReasonCD":null,"ChannelShareLevelCD":"OPCO","ChannelOpCoOptOff":null,"ChannelBrand":[{"BrandFamilyCD":"02","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"03","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"04","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"05","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"09","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"13","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"40","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"43","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"46","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"67","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"90","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"BX","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CD","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CDS","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CO","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"CP","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"GS","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"H2O","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"HU","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"IQ","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"JCP","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"JU","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"NS","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"NSI","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"PCP","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"PV","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"ROY","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RS","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RT","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"RV","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"SK","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"UCP","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"VRV","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"},{"BrandFamilyCD":"Z1","AddressTypeCD":"P","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"Y"}],"ChannelLevel":[{"ContactLevel":"PMUSA","AddressType":[{"AddressTypeCD":"P","ContactInfo":[{"Name":"ContactInfo","Value":"18241815_PMUSA@QA.ARCWW2.COM"}],"ContactInfoStatus":{"ChannelStatus":"D","ValidityFlag":"Y","ValidityReasons":[],"DeliverabilityFlag":"Y","DeliverabilityReasons":[],"RestrictedFlag":"N","RestrictedReasons":[],"SuppressedFlag":"N","SuppressedReasons":[]},"IndivDOIDate":null,"IndivDOISourceProgram":null,"IndivDOISourceProgramPhase":null,"SourceTransDate":"2019-01-15T12:39:25"}]}]},{"ChannelTypeCD":"TM","ChannelOptOff":"N","OptOffReasonCD":"9I","ChannelShareLevelCD":"IND","ChannelOpCoOptOff":null,"ChannelBrand":[{"BrandFamilyCD":"02","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"03","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"04","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"05","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"09","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"13","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"40","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"43","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"46","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"67","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"90","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"BR","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"BX","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"CD","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"CDS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"CO","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"CP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"DV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"EY","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"GS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"H2O","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"HD","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"HU","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"IQ","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"JCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"JU","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"NS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"NSI","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"PCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"PV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"RC","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"ROY","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"RS","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"RT","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"RV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"SCA","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"SK","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"SL","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"SWB","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"UCP","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"VRV","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"},{"BrandFamilyCD":"Z1","AddressTypeCD":"H","BrandOptOffFlag":null,"OptOffReasonCD":null,"ContactabilityFlag":"N"}],"ChannelLevel":[{"ContactLevel":"INDIV","AddressType":[{"AddressTypeCD":"H","ContactInfo":[{"Name":"SOURCE","Value":"D"},{"Name":"ContactInfo","Value":"4237682623"}],"ContactInfoStatus":{"ChannelStatus":"N","ValidityFlag":"Y","ValidityReasons":[],"DeliverabilityFlag":"Y","DeliverabilityReasons":[],"RestrictedFlag":"N","RestrictedReasons":[],"SuppressedFlag":"N","SuppressedReasons":[]},"IndivDOIDate":null,"IndivDOISourceProgram":null,"IndivDOISourceProgramPhase":null,"SourceTransDate":"1997-01-05T00:00:00"}]}]}]},"PreferenceData":{"IndividualPreferences":[]},"OwnerSurveyData":[],"SubscriptionData":[],"OwnerListData":{"OwnerList":[]}}';       
                  }
             res.setBody(strResponseBody);
        }
        string strResponse = res.getBody();
        logResponse(strResponse);
        
        AcxiomClasses.ConsumerFullSearchResponse response = (AcxiomClasses.ConsumerFullSearchResponse)Json.deserialize(strResponse, AcxiomClasses.ConsumerFullSearchResponse.class);
        System.debug('test response '+response);
        
        AcxiomClasses.ConsumerFinalResponse cObj = new AcxiomClasses.ConsumerFinalResponse();
        
        cObj.StatusCode = response.StatusData[0].StatusCode;
        cObj.StatusMessage = response.StatusData[0].StatusMessage;
        cObj.ConsumerMessage =  response.StatusData[0].ConsumerMessage;
        cObj.RequestId = response.RequestId;
        log.Success__c = true;
            
        if(cObj.StatusCode == '0000'){     
        
            cObj.CCN = response.CCN;
            cObj.WinningCCN = response.WinningCCN;
            cObj.PID = response.AuthenticationData[0].PID;
            cObj.ConsumerAuthCd = response.AuthenticationData[0].ConsumerAuthCd;
            cObj.OpCo = response.QualificationData.OpCoQualification[0].OpCo;
            cObj.DateOfBirth = response.QualificationData.OpCoQualification[0].DateOfBirth;
            cObj.AVCode = response.QualificationData.OpCoQualification[0].AVCode;
            cObj.AVOwner = response.QualificationData.OpCoQualification[0].AVOwner;
			
            for (AcxiomClasses.Channel c : response.ChannelData.Channel){
                for(AcxiomClasses.ChannelLevel cLvl : c.ChannelLevel){
                    for(AcxiomClasses.AddressType addrs : cLvl.AddressType){
                        for(AcxiomClasses.ContactInfo cI : addrs.ContactInfo){
                        	if(cI.Name == 'Title'){
                                cObj.Title = cI.Value;
                            }else if(cI.Name == 'Fname'){
                                cObj.Fname = cI.Value;
                            }else if(cI.Name == 'Lname'){
                                cObj.Lname = cI.Value;
                            }else if(cI.Name == 'Addr1'){
                                cObj.Addr1 = cI.Value;
                             }else if(cI.Name == 'Addr2'){
                                cObj.Addr2 = cI.Value;
                            }else if(cI.Name == 'City'){
                                cObj.City = cI.Value;
                            }else if(cI.Name == 'State'){
                                cObj.State = cI.Value;
                            }else if(cI.Name == 'Zip'){
                                cObj.Zip = cI.Value;
                            }else if(cI.Name == 'Zip4'){
                                cObj.Zip4 = cI.Value;
                            }          
                        }
                    }
                }
            }

        }else{
            log('Status Message: ' + cObj.StatusMessage);            
            
        }        
        System.debug('Full search cObj '+cObj);
        
        return cObj ;
     	} 
     
   
      public AcxiomClasses.CCNLookupFinalResponse CCNLookupRequest(String strRequestBody){ 
         
          
        
        //RITM0214539 - API conversion to AIM - Updated CCN Lookup
        HttpRequest req = new HttpRequest();
        EndPointURL = '/' + settings.ccnlookupMethod__c + '/'+ settings.Vendor_cd__c + '/' + settings.Channel_type_cd__c + '/' + settings.Website_Id__c;
        
		//2025-06-03
		//req.setEndpoint(xxx_serviceBaseURL + EndPointURL);
        req.setEndpoint('https://api.insightsc3m.com/aimccnlookup' + EndPointURL);
		
        
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
		//2025-06-03
		//req.setHeader('Authorization', currentToken.token_type+' '+currentToken.access_token);
		req.setHeader('Authorization', 'Bearer '+currentToken.access_token);
		req.setHeader('Ocp-Apim-Subscription-Key', 'fc32f147b727473c83aed0b9d3f1f458');
		  
        req.setTimeout(getTimeOut());
        
        Http http = new Http();
        req.setBody(strRequestBody);
        
        logRequest(strRequestBody);
        
        HTTPResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req);            
        }else{
             res = new HTTPResponse();
             string strResponseBody = '';
             if(strRequestBody.contains('123')){
                 strResponseBody = '';
             }else{          
                 strResponseBody = '{"RequestId": "b2f5281e-e83c-492e-a509-a6ad49e05230","StatusData": [{"ConsumerMessage": null,"StatusCode": "0000","StatusMessage": "SUCCESS"}],"WinningCCN": 18241815,"CCN": 18241815,"RetiredIDs": [],"Individual": {"AllocatedBrandFamilyCode": null,"CurrentBrandCode": null,"LoyaltyPropensityAffinitySegmentModel": "FM-99","OpCo": "PMUSA","PID": "234563456"},"WebSiteData": [],"FlexData": [],"ModelScores": [],"QualificationData": {"OpCoQualification": [{"AVCode": "2","AVOwner": "JMC","ConsumerAuthCD": "Y","DateOfBirth": "1964-08-09T00:00:00","OpCo": "PMUSA","PLCertificationQualifiedData": [{"CertificationCD": "S","ProductLineCD": "IQ","QualifiedCD": "S"},{"CertificationCD": "S","ProductLineCD": "TP","QualifiedCD": "S"},{"CertificationCD": "Y","ProductLineCD": "AS","QualifiedCD": "Y"},{"CertificationCD": "S","ProductLineCD": "ST","QualifiedCD": "S"}]}]},"AvailabilityData": {"ConsumerOptOffCD": null,"ConsumerOptOffReasonCD": null,"OpCoOptOff": [],"OptOffDate": null,"PLBrandOptOff": [],"PLOpCoOptOff": [],"ProductLineOptOff": []},"ChannelData": {"Channel": [{"ChannelTypeCD": "DM","ChannelOptOff": null,"OptOffReasonCD": null,"ChannelShareLevelCD": "IND","ChannelOpCoOptOff": [],"ChannelBrand": [{"BrandFamilyCD": "02","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "03","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "04","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "05","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "09","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "13","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "40","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "43","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "46","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "67","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "90","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "BR","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "BX","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CD","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CDS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CO","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "DV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "EY","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "GS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "H2O","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "HD","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "HU","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "IQ","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "JCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "JU","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "NS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "NSI","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "PCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "PV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RC","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "ROY","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RT","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "SCA","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "SK","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "SL","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "SWB","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "UCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "VRV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "Z1","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"}],"ChannelLevel": [{"ContactLevel": "INDIV","AddressType": [{"AddressTypeCD": "H","ContactInfo": [{"Name": "Title","Value": "MR"},{"Name": "Fname","Value": "MICHAEL"},{"Name": "MidName","Value": "V"},{"Name": "Lname","Value": "SLEMP"},{"Name": "Addr1","Value": "179 COPLEY BRANCH RD"},{"Name": "City","Value": "BUTLER"},{"Name": "State","Value": "TN"},{"Name": "Zip","Value": "37640"},{"Name": "Zip4","Value": "7204"}],"ContactInfoStatus": {"ChannelStatus": "Y","ValidityFlag": "Y","ValidityReasons": [],"DeliverabilityFlag": "Y","DeliverabilityReasons": [],"RestrictedFlag": "N","RestrictedReasons": [],"SuppressedFlag": "N","SuppressedReasons": []},"IndivDOIDate": null,"IndivDOISourceProgram": null,"IndivDOISourceProgramPhase": null,"SourceTransDate": "2012-03-30T15:36:56"}]}]},{"ChannelTypeCD": "EM","ChannelOptOff": null,"OptOffReasonCD": null,"ChannelShareLevelCD": "OPCO","ChannelOpCoOptOff": [],"ChannelBrand": [{"BrandFamilyCD": "02","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "03","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "04","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "05","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "09","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "13","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "40","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "43","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "46","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "67","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "90","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "BX","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CD","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CDS","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CO","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "CP","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "GS","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "H2O","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "HU","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "IQ","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "JCP","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "JU","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "NS","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "NSI","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "PCP","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "PV","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "ROY","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RS","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RT","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "RV","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "SK","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "UCP","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "VRV","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"},{"BrandFamilyCD": "Z1","AddressTypeCD": "P","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "Y"}],"ChannelLevel": [{"ContactLevel": "PMUSA","AddressType": [{"AddressTypeCD": "P","ContactInfo": [{"Name": "ContactInfo","Value": "18241815_PMUSA@QA.ARCWW2.COM"}],"ContactInfoStatus": {"ChannelStatus": "D","ValidityFlag": "Y","ValidityReasons": [],"DeliverabilityFlag": "Y","DeliverabilityReasons": [],"RestrictedFlag": "N","RestrictedReasons": [],"SuppressedFlag": "N","SuppressedReasons": []},"IndivDOIDate": null,"IndivDOISourceProgram": null,"IndivDOISourceProgramPhase": null,"SourceTransDate": "2019-01-15T12:39:25"}]}]},{"ChannelTypeCD": "TM","ChannelOptOff": "N","OptOffReasonCD": "9I","ChannelShareLevelCD": "IND","ChannelOpCoOptOff": [],"ChannelBrand": [{"BrandFamilyCD": "02","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "03","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "04","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "05","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "09","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "13","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "40","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "43","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "46","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "67","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "90","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "BR","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "BX","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "CD","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "CDS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "CO","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "CP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "DV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "EY","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "GS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "H2O","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "HD","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "HU","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "IQ","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "JCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "JU","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "NS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "NSI","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "PCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "PV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "RC","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "ROY","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "RS","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "RT","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "RV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "SCA","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "SK","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "SL","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "SWB","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "UCP","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "VRV","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"},{"BrandFamilyCD": "Z1","AddressTypeCD": "H","BrandOptOffFlag": null,"OptOffReasonCD": null,"ContactabilityFlag": "N"}],"ChannelLevel": [{"ContactLevel": "INDIV","AddressType": [{"AddressTypeCD": "H","ContactInfo": [{"Name": "SOURCE","Value": "D"},{"Name": "ContactInfo","Value": "4237682623"}],"ContactInfoStatus": {"ChannelStatus": "N","ValidityFlag": "Y","ValidityReasons": [],"DeliverabilityFlag": "Y","DeliverabilityReasons": [],"RestrictedFlag": "N","RestrictedReasons": [],"SuppressedFlag": "N","SuppressedReasons": []},"IndivDOIDate": null,"IndivDOISourceProgram": null,"IndivDOISourceProgramPhase": null,"SourceTransDate": "1997-01-05T00:00:00"}]}]}]},"PreferenceData": {"IndividualPreferences": []},"ChannelDataShort": [],"OwnerSurveyData": [],"SubscriptionData": [],"OwnerListData": {"OwnerList": [{"ListCD": "-","OwnerCD": "PMUSA"}]}}'; 
             }
             res.setBody(strResponseBody);
        }
        string strResponse = res.getBody();
        logResponse(strResponse);

        AcxiomClasses.CCNLookupFinalResponse cObj = new AcxiomClasses.CCNLookupFinalResponse();
        
        AcxiomClasses.CCNLookupResponse response = (AcxiomClasses.CCNLookupResponse)Json.deserialize(strResponse, AcxiomClasses.CCNLookupResponse.class);
        System.debug('test response '+response);
        
        cObj.StatusCode = response.StatusData[0].StatusCode;
        cObj.StatusMessage = response.StatusData[0].StatusMessage;
        cObj.ConsumerMessage =  response.StatusData[0].ConsumerMessage;
        cObj.RequestId = response.RequestId;
        log.Success__c = true;  
          
        if(cObj.StatusCode == '0000'){     
        
            cObj.CCN = response.CCN;
            cObj.WinningCCN = response.WinningCCN;
            cObj.PID = response.Individual.PID;
            cObj.ConsumerAuthCd = response.QualificationData.OpCoQualification[0].ConsumerAuthCd;
            cObj.OpCo = response.QualificationData.OpCoQualification[0].OpCo;
            cObj.DateOfBirth = response.QualificationData.OpCoQualification[0].DateOfBirth;
            cObj.AVCode = response.QualificationData.OpCoQualification[0].AVCode;
            cObj.AVOwner = response.QualificationData.OpCoQualification[0].AVOwner;
			
            for (AcxiomClasses.Channel c : response.ChannelData.Channel){
                for(AcxiomClasses.ChannelLevel cLvl : c.ChannelLevel){
                    for(AcxiomClasses.AddressType addrs : cLvl.AddressType){
                        for(AcxiomClasses.ContactInfo cI : addrs.ContactInfo){
                        	if(cI.Name == 'Title'){
                                cObj.Title = cI.Value;
                            }else if(cI.Name == 'Fname'){
                                cObj.Fname = cI.Value;
                            }else if(cI.Name == 'Lname'){
                                cObj.Lname = cI.Value;
                            }else if(cI.Name == 'Addr1'){
                                cObj.Addr1 = cI.Value;
                            }else if(cI.Name == 'Addr2'){
                                cObj.Addr2 = cI.Value;
                            }else if(cI.Name == 'City'){
                                cObj.City = cI.Value;
                            }else if(cI.Name == 'State'){
                                cObj.State = cI.Value;
                            }else if(cI.Name == 'Zip'){
                                cObj.Zip = cI.Value;
                            }else if(cI.Name == 'Zip4'){
                                cObj.Zip4 = cI.Value;
                            }          
                        }
                    }
                }
            }
            
        }else{
            log('Status Message: ' + cObj.StatusMessage);            
            
        }        
        System.debug('CCN cObj '+cObj);
        
        return cObj;
      }
    
    
    public class AcxiomCalloutException extends Exception{}    
    
}