@isTest
global class MelissaMockCallout implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://expressentry.melissadata.net/web/ExpressPostalCode?format=JSON&id=+xxx_UserId+&postalcode=+zipCodeval+&maxrecords=1', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Status":"Pass"}');
        res.setStatusCode(200);
        return res;
    }
}