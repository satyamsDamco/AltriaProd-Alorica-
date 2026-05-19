@istest
global class esignMockDcoument implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Details": { "AccountNumber":"123456", "BusinessGUID": "abcd-xyzx", "Email": "test@affirma.com", "Documents": [  {  "DocumentGUID": "abcde-xyzxpq",  "Password": "1234567abc"   }  ],  "Fields": [ {  "Name" : "{DocumentBusinessName}", "Value":"Affirma" },  {  "Name":"{CustomerFirstName}", "Value": "Test" }, {  "Name":"{CustomerLastName}",  "Value":"TestL"  }, { "Name":"{CustomerAddress1}",  "Value":"test address"  },  {"Name":"{CustomerAddress2}",  "Value":"" },  {  "Name":"{CustomerCity}",  "Value":"Wl"   },  { "Name":"{CustomerState}", "Value":"WC"  }, {  "Name":"{CustomerZip}",    "Value":"12345" } ] }}');
        response.setStatusCode(200);
        return response; 
    }

}