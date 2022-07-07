@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    // Implement this interface method

    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response

        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');

        res.setBody('{"subscriber_id":800,"sendlast_should":0,"sendlast_did":0,"result_code":1,"result_message":"Contact updated","result_output":"json"}');

        res.setStatusCode(200);

        return res;

    }
}