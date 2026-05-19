@istest
global class eSignMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Uername": "test@affirma.com","Password": "abcxyz123"}');
        response.setStatusCode(200);
        return response; 
    }
    
    
}