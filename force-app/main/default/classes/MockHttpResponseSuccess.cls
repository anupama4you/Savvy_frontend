/*
 *  @description This is an implementation for the HttpCalloutMock interface to specify the  Apex runtime calls to send a successful response from callout.
 *  @author Andre Calimlim
 *  @date 11.01.2016
 */
@isTest
public with sharing class MockHttpResponseSuccess implements HttpCalloutMock{
    public static HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/plain');
        res.setBody('success');
        
        res.setStatusCode(200);
        return res;
    }
}