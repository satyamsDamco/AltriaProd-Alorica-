@IsTest global class AcxiomMockResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
     
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
    
        if(req.getEndpoint().contains('token?grant_type=client_credentials')){
             AcxiomClasses.TokenInfo response = new AcxiomClasses.TokenInfo();
             response.access_token = 'xyvyerev765775675ghfg';
             response.expires_in = '1799';
             response.token_type = 'trtyxyvyerev765775675ghfg';
             
             String strResponseBody = JSON.serialize(response);
             
             res.setBody(strResponseBody);
              
        }else if(req.getEndpoint().contains('api/FullSearch')){            
            String strResponseBody = '[CCN=3279879, FullSearch=FullSearchInner:[intTransactionId=1178493311, objAuthenticationData=AuthenticationData:[strConsumerAuthCd=Y, strLexisNexisId=1439597713], objChannelData=ChannelData:[aObjChannel=(Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=Title, strValue=MRS], contact:[strName=Fname, strValue=JOAN], contact:[strName=Lname, strValue=LAGUARDIA], contact:[strName=Addr1, strValue=413 NE 25TH AVE], contact:[strName=City, strValue=CAPE CORAL], contact:[strName=State, strValue=FL], contact:[strName=Zip, strValue=33909], contact:[strName=Zip4, strValue=2802])])])], Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=ContactInfo, strValue=3279879_PMUSA@QA.ARCWW2.COM], contact:[strName=EXPL_CS, strValue=D], contact:[strName=DOI_WEB, strValue=13], contact:[strName=DOMAIN, strValue=QA.ARCWW2.COM])])])], Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=ContactInfo, strValue=2392239151], contact:[strName=SOURCE, strValue=D])])])])], objQualificationData=QualificationData:[aObjOpCoQualification=(QualificationInner:[dtDOB=1953-04-22T00:00:00, strAVCode=2, strAVOwner=JMC, strOpCo=PMUSA])]], RequestId=4159826, StatusData=(statusClass:[ConsumerMessage=, StatusCode=071, StatusMessage=CCN FOUND, AGE VERIFICATION CAN BE SHARED]), WinningCCN=3279879]';             
            res.setBody(strResponseBody);
            
        }else if(req.getEndpoint().contains('api/WebCCNLookup')){
            String strResponseBody = '[CCN=3279879, CcnLookup=CCNLookupInner:[intTransactionId=1178493313, objAuthenticationData=AuthenticationData:[strConsumerAuthCd=Y, strLexisNexisId=1439597713], objChannelData=ChannelData:[aObjChannel=(Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=Title, strValue=MRS], contact:[strName=Fname, strValue=JOAN], contact:[strName=Lname, strValue=LAGUARDIA], contact:[strName=Addr1, strValue=413 NE 25TH AVE], contact:[strName=City, strValue=CAPE CORAL], contact:[strName=State, strValue=FL], contact:[strName=Zip, strValue=33909], contact:[strName=Zip4, strValue=2802])])])], Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=ContactInfo, strValue=3279879_PMUSA@QA.ARCWW2.COM], contact:[strName=EXPL_CS, strValue=D], contact:[strName=DOI_WEB, strValue=13], contact:[strName=DOMAIN, strValue=QA.ARCWW2.COM])])])], Channel:[aObjChannelLevel=(ChannelLevel:[aObjAddressType=(AddressType:[aObjContactInfo=(contact:[strName=ContactInfo, strValue=2392239151], contact:[strName=SOURCE, strValue=D])])])])], objQualificationData=QualificationData:[aObjOpCoQualification=(QualificationInner:[dtDOB=1953-04-22T00:00:00, strAVCode=2, strAVOwner=JMC, strOpCo=PMUSA])]], RequestId=4159876, StatusData=(statusClass:[ConsumerMessage=, StatusCode=0000, StatusMessage=SUCCESS]), WinningCCN=3279879]'; 
            res.setBody(strResponseBody);            
        }
        res.setStatusCode(200);
        return res;
    }
}