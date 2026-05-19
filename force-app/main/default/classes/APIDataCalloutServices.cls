/************************************************************************ 
Author: Randolf Suplito
Date: 08/08/2022
Description: This service class will handle all data feed api callout
*************************************************************************/

public class APIDataCalloutServices {
    
    @future (callout=true)
    public static void dataFeedCallout(String jsonPayload, String callOutName) {
        
        List<responseDTO> resList = new List<responseDTO>();
        
        try {
            //Get authorization token
            String authToken = authCallout();
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            // RITM2618162 - 2023-02-23
            // RITM2639848 - 2023-03-13
            request.setTimeout(120000);
            // RITM2618173 - 2023-02-23
            // RITM3167644 - 2024-08-25
            request.setClientCertificateName(Label.FEED_API_certname); //('FEED_API_2025_09_02') //('FEED_API_2024_08_25')
            request.setMethod('POST');
            request.setEndpoint(Label.APIDataFeed_MasterDataUrl);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ authToken);
      		request.setHeader('Ocp-Apim-Subscription-Key', Label.APIDataFeed_SubscriptionKeyCID);
            request.setBody(jsonPayload);
            
            HttpResponse response = http.send(request);
            string responsePayload = response.getBody();
            System.debug('@@responsePayload: ' + responsePayload);
            string statusCode = string.valueof(response.getStatusCode());
            
            responseDTO resDTO = (responseDTO) json.deserialize(responsePayload, responseDTO.class);
            resDTO.statusCode = statusCode;
            resList.add(resDTO);
                
            createIL(jsonPayload, resList, callOutName);
        } catch(Exception e) {
            responseDTO resDTO = new responseDTO();
            resDTO.statuscode = '500';
            resDTO.code = 0;
            resDTO.message = e.getMessage();
            resList.add(resDTO);
            
            createIL(jsonPayload, resList, callOutName);
        }
    }
    
    
    public static String authCallout(){
        String client_id = Label.APIDataFeed_ClientId;
        String client_secret = Label.APIDataFeed_ClientSecret;
        String scope = Label.APIDataFeed_Scope;
        
        String content= 'grant_type='+EncodingUtil.urlEncode('client_credentials', 'UTF-8')+
                        '&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')+
                        '&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8')+
                        '&scope='+EncodingUtil.urlEncode(scope, 'UTF-8');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(Label.APIDataFeed_OAuthUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Ocp-Apim-Subscription-Key',Label.APIDataFeed_SubscriptionKey);
        request.setBody(content);

        HttpResponse response = http.send(request);
        string resposePayload = response.getBody();
        System.Debug('Authentication Token Response---------> '+ resposePayload );
        
        jsonAuthDTO jsonBody = (jsonAuthDTO) json.deserialize(resposePayload, jsonAuthDTO.class);
        return jsonBody.access_token;
    }
    
    //Creation of Integration Log
    public static void createIL(String jsonPayload, List<responseDTO> resList, String callOutName){
        
        List<IntegrationLog__c> integLogList = new List<IntegrationLog__c>();
        
        for(responseDTO res : resList) {
            IntegrationLog__c IL = new IntegrationLog__c();
            
            IL.Callout__c = callOutName;
            IL.FormName__c = callOutName;
            
            if(res.statusCode == '200'){
                IL.Message__c = JSON.Serialize(res);
                IL.Success__c = true;
            } else {
                IL.Message__c = JSON.Serialize(res);
                IL.Success__c = false;
            }
            IL.Request__c = jsonPayload;
            IL.Response__c = JSON.Serialize(res);
            IL.Type__c = ConstantClass.APIDATAFEED_TYPE_OUTBOUND;
            
            integLogList.add(IL);
        }
        
        if(!integLogList.isEmpty()) {
            Database.SaveResult[] srList = Database.insert(integLogList, false);           
            for(Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('Id: ' + sr.getId());
                } 
            }
        }
    }
    
    public class jsonAuthDTO{
        public String token_type {get;set;}
        public Integer expires_in {get;set;}
        public Integer ext_expires_in {get;set;}
        public String access_token {get;set;}
    }
    
    public class responseDTO {
        public String statusCode{get; set;}
        public Integer code{get; set;}
        public String message{get; set;}
        public Integer controlId{get; set;}
        public String stagingFailedObjects{get; set;}
        public String finalFailedObjects{get; set;}
    }
}