@isTest
public with sharing class EquifaxMock implements HttpCalloutMock {
    public String req1;
    public EquifaxMock(String req1){
        this.req1 = req1;

    }

    public HTTPResponse respond(HTTPRequest req) { 
         HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'text/xml');

        res.setBody(this.req1);

        res.setStatusCode(200);

        return res;
    }
}