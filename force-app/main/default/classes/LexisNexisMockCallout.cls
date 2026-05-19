@isTest
global class LexisNexisMockCallout implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://staging.identitymanagement.lexisnexis.com/identity-proofing/services/identityProofingServiceWS/v2', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        String responseXMLTest = '';
        responseXMLTest += '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        responseXMLTest += '<soap:Body>';
        responseXMLTest += '<ns1:invokeIdentityServiceResponse xmlns:ns1="http://ws.identityproofing.idm.risk.lexisnexis.com/">';
        responseXMLTest += '<identityProofingResponse xmlns="http://ns.lexisnexis.com/identity-proofing/1.0" xmlns:ns="http://ns.lexisnexis.com/identity-proofing/1.0" ns:transactionID="00f615da-cd0b-26f3-df39-c2dd86f809f2" ns:responseUniqueId="60090736">';
        responseXMLTest += '<workFlow>CRC_NEW</workFlow>';
        responseXMLTest += '<status>FAIL</status>';
        responseXMLTest += '<statusDescription>Failed to retrieve a unique identity</statusDescription>';
        responseXMLTest += '</identityProofingResponse></ns1:invokeIdentityServiceResponse></soap:Body></soap:Envelope>';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseXMLTest);
        res.setStatusCode(200);
        return res;
    }
}