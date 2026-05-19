/*
*   @Author: Gian Carlo Cutchon
*   @Date: 12/14/2018
*   @Apex Name: lexisNexisHttpCalloutMock
*   @Description: This class is use to handle the mock response from Lexis Nexis Callout to be use in test classes.
*
*/
@isTest
public with sharing class lexisNexisHttpCalloutMock implements HttpCalloutMock {
    //A single method that acts as a webservice to simulate 3rd party services
            
    public HTTPResponse respond(HTTPRequest req){
        
        System.debug('--- Inside lexisNexisHttpCalloutMock ---');
        String mock = req.getEndpoint();
        System.debug('mock--->' +mock);
        
        //Authentication
        if(req.getEndpoint().endsWith('conversation')){
            System.debug('--- Response Mock ---');
            LexisNexisResponseClass.AgeVerificationResponse resAuth = new LexisNexisResponseClass.AgeVerificationResponse();
            resAuth.Status = new LexisNexisResponseClass.jsonWrapper_Status();
            resAuth.Status.ConversationId = '31000146968005';
            resAuth.Status.RequestId = '357732315';
            resAuth.Status.TransactionStatus = 'passed';
            resAuth.Status.Reference = '48175';
            resAuth.Status.LexID = '139394441726';

            httpResponse res = new httpResponse();

            //Set the Status
            res.setStatus('OK');

            //Set the StatusCode
            res.setStatusCode(200);
            res.setBody(JSON.serialize(resAuth));
            return res;
        }
        
        httpResponse res = new httpResponse();
            //Set the Status
            res.setStatus('No Content');
            //Set the StatusCode
            res.setStatusCode(204);
            return res;
        
    }
    
}