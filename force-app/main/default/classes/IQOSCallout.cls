/*
*   @Author: Gian Carlo Cutchon
*   @Date: 12/28/2017
*   @Apex Name: IQOSCallout
*   @Description: This class is use for IQOS call out to Core Services
*
*/
public with sharing class IQOSCallout{
    // getting the authentication token
    //IssueEntryController IE = new IssueEntryController();
    public static string authCallout(){
            //String client_secret= 'WCCl7J7TlGDshGnWTJ8JiHax1UkB0D3vk7iCCIBl0Gs=';
           // String client_id ='f3f8bf80-9068-4b1c-91e6-9d3322d03242';
            
            String client_secret= Label.Core_Service_Client_Secret;
            String client_id = Label.Core_Service_Client_Id;
            
            String content = 'grant_type='+EncodingUtil.urlEncode('client_credentials', 'UTF-8')+'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8');
            
            HttpResponse res;
            HttpRequest req = new HttpRequest();
            //req.setEndPoint('https://login.microsoftonline.com/535b2d87-664f-415a-b7fa-fd3f1086d450/oauth2/token'); 
            req.setEndPoint(Label.IQOS_Auth_URL);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody(content);
            
            Http http_req = new Http();
            res = http_req.send(req);
            string myReturn = res.getBody(); //this is your return json object
            System.Debug('Authentication Token Response---------> '+res.toString());
            
            IQOSResponseClass.jsonWrapper_Auth jsonBody = (IQOSResponseClass.jsonWrapper_Auth) json.deserialize(myReturn, IQOSResponseClass.jsonWrapper_Auth.class );
            return jsonBody.access_token;
    }
    
    //Call out to Core Service for Manufacturing Information
    public IQOSResponseClass.jsonWrapper_MI csManufacturingCallout(String serialNum){
            string EndPointUrl = Label.Core_Service_URL+'/products/v1/iqosproductinfo/serial/'+serialNum;
            httpRequest req = new httpRequest();        
            req.setMethod('GET');
            req.setEndpoint(EndPointUrl);
            req.setHeader('Authorization', 'Bearer '+ authCallout());
            req.setHeader('Content-Type', 'application/json');              
            req.setTimeout(120000);         
            httpResponse res = new http().send(req);            
            string myReturn = res.getBody(); //this is your return json object
            string statusCode = string.valueof(res.getStatusCode());
            System.Debug('Manufacturing Response--------------------> '+res.toString());
            system.debug(myReturn);
            
            if(statusCode == '200'){
                IQOSResponseClass.jsonWrapper_MI jsonBody = (IQOSResponseClass.jsonWrapper_MI) json.deserialize(myReturn, IQOSResponseClass.jsonWrapper_MI.class );
                system.debug('JSON Response ----> ' + jsonBody);
                return jsonBody;
            }else{
                return null;
            }
    }
    
    //Call out To Core Services for Kit Serial Number:
    public IQOSResponseClass.jsonWrapper_KM csKitMappingCallout(String serialNum){
            string EndPointUrl = Label.Core_Service_URL+'/products/v1/iqoscomponenttokitmapping/serial/'+serialNum;
            httpRequest req = new httpRequest();        
            req.setMethod('GET');
            req.setEndpoint(EndPointUrl);
            req.setHeader('Authorization', 'Bearer '+ authCallout());
            req.setHeader('Content-Type', 'application/json');              
            req.setTimeout(120000);         
            httpResponse res = new http().send(req);            
            string myReturn = res.getBody(); //this is your return json object
            String statusCode = string.valueof(res.getStatusCode());
            System.Debug('Kit Mapping Response----------------> ' +res.toString());
            system.debug(myReturn);
            
            if(statusCode == '200'){
                IQOSResponseClass.jsonWrapper_KM jsonBody = (IQOSResponseClass.jsonWrapper_KM) json.deserialize(myReturn, IQOSResponseClass.jsonWrapper_KM.class );
                system.debug('JSON Response ----> ' + jsonBody);
                return jsonBody;
            }else{
                return null;
            }
    }
    
    //Call out To Core Services for Product Registration:
    public IQOSResponseClass.jsonWrapper_PR csProductRegCallout(String productID){
            string EndPointUrl = Label.Core_Service_URL+'/products/v1/iqosdevicereg/type/deviceId/id/'+productID;
            httpRequest req = new httpRequest();        
            req.setMethod('GET');
            req.setEndpoint(EndPointUrl);
            req.setHeader('Authorization', 'Bearer '+ authCallout());
            req.setHeader('Content-Type', 'application/json');              
            req.setTimeout(120000);         
            httpResponse res = new http().send(req);      
            string myReturn = res.getBody(); //this is your return json object
            String statusCode = string.valueof(res.getStatusCode());
            System.Debug('Product Registration Response----------------> ' +res.toString());
            system.debug(myReturn);
            if(statusCode == '200'){
                IQOSResponseClass.jsonWrapper_PR jsonBody = (IQOSResponseClass.jsonWrapper_PR) json.deserialize(myReturn, IQOSResponseClass.jsonWrapper_PR.class );
                system.debug('JSON Response ----> ' + jsonBody);
                return jsonBody;
            }else{
                return null;
            }
    }

    //Call out To Core Services for Order Information:
    public list<IQOSResponseClass.jsonWrapper_OI> csOrderInfoCallout(String productID){
            //string EndPointUrl = Label.Core_Service_URL+'/iqos/v1/orders/type/{type}/id/{ID}/upc/{upc}/days/'+daysOfHistory;
            string EndPointUrl = Label.Core_Service_URL+'/iqos/v1/orders';
            httpRequest req = new httpRequest();        
            req.setMethod('POST');
            req.setEndpoint(EndPointUrl);
            req.setHeader('Authorization', 'Bearer '+ authCallout());
            req.setHeader('Content-Type', 'application/json');              
            req.setTimeout(120000);    
            IQOSResponseClass.jsonWrapper_OrderBody jsonSetBody = new IQOSResponseClass.jsonWrapper_OrderBody();
            jsonSetBody.type = 'Device';
            jsonSetBody.id = productID;
            req.setBody(JSON.Serialize(jsonSetBody));
            httpResponse res = new http().send(req);            
            string myReturn = res.getBody(); //this is your return json object
            String statusCode = string.valueof(res.getStatusCode());
            System.Debug('Order Information Response----------------> ' +res.toString());
            system.debug(myReturn);
            if(statusCode == '200'){
                String myReturnReplaced = myReturn.replace('"date":', '"purchaseDate":');
                list<IQOSResponseClass.jsonWrapper_OI> jsonBody = (List<IQOSResponseClass.jsonWrapper_OI>) json.deserialize(myReturnReplaced, list<IQOSResponseClass.jsonWrapper_OI>.class );
                system.debug('JSON Response ----> ' + jsonBody);
                return jsonBody;
            }else{
                return null;
            }
    }
}