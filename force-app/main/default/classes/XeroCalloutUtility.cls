/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Handles the physical callout to the Xero API
**/
public with sharing class XeroCalloutUtility {
    /**
* 	@author Ben Edwards (ben@benedwards.co.nz)
*	@description Query the custom object for the Xero Account Settings
* 	@return Returns a single XeroSetting__c record
**/
    /*public Xero_Settings__c xeroSettings {

get {

if (xeroSettings == null) {

xeroSettings = Xero_Settings__c.getInstance();
}
return xeroSettings;
};
set;
}*/

/**
* 	@author Leandro 				2018-09-27
*	@description Execute the physical callout and return the response
* 	@return Returns the HttpResponse from the Xero API
*
    public static HttpResponse executeCallout (String method, String resourceName, String requestBody, Xero_API_Setting__c xeroSetting) {
        List<Xero_API_Setting__c> xeroSettings = null;
        // Instantiate a new request
        HttpRequest request = new HttpRequest();
        
        // Set request parameters
        request.setMethod(method);
        request.setEndpoint(xeroSetting.Endpoint__c + resourceName);
        
        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');
        
        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {
            
            // Set the body to the callout
            request.setBody(requestBody);
            
            // Set the content to XML
            request.setHeader('Content-Type', 'text/xml');
        }
        
        System.debug('Yohan VillaLeal: Sign the request based on OAuth 1.0a');
        // Sign the request based on OAuth 1.0a
        request = XeroOAuthUtility.signRequest(request, xeroSetting);
        
        // Print the request
        System.debug('Yohan VillaLeal: Request: ' + request);
        System.debug('Yohan VillaLeal: Body Request: ' + request.getBody());
        // Execute callout and return
        Http http = new Http();
        HttpResponse httpResponse = http.send(request);
        System.debug('Yohan VillaLeal: Status Code '+httpResponse.getStatusCode());
        System.debug('Yohan VillaLeal: Status '+httpResponse.getStatus());
        System.debug('Yohan VillaLeal: Body '+httpResponse.getBody());
        
        return httpResponse;
        //  return new Http().send(request);
	}    */
    
/**
* 	@author Ben Edwards (ben@benedwards.co.nz)
*	@description Execute the physical callout and return the response
* 	@return Returns the HttpResponse from the Xero API
*
    public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {
        return executeCallout(method, resourceName, requestBody, null);
    }*/
    
    /**
* 	@author Ben Edwards (ben@benedwards.co.nz)
*	@description Execute the physical callout and return the response
* 	@return Returns the HttpResponse from the Xero API
**/
    public static HttpResponse executeJsonCallout (String method, String resourceName, String requestBody, Xero_API_Setting__c xeroSetting) {
    	System.debug('executeJsonCallout...');
        List<Xero_API_Setting__c> xeroSettings = null;
        
        if (xeroSetting == null) {
        	System.debug('Loading Xero API Setting by default...');
        	xeroSettings = [
            Select t.id, t.Consumer_Key__c, t.Consumer_Secret__c, t.Endpoint__c, t.App_Name__c, 
                   t.Profile__c, t.Active__c, t.Invoice_Status__c, Xero_Tenant_ID__c 
            from Xero_API_Setting__c t];
        	xeroSetting = xeroSettings[0];
        }
        // Instantiate a new request
        HttpRequest request = new HttpRequest();
        
        System.debug('method: ' + method);
        System.debug('resourceName: ' + resourceName);
        System.debug('requestBody: ' + requestBody);
        System.debug('xeroSetting: ' + XeroXmlUtility.serializeJson(xeroSetting));
        // Set request parameters
        request.setMethod(method);
        request.setEndpoint(xeroSetting.Endpoint__c + resourceName);
        
        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');
        
        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {
            
            // Set the body to the callout
            request.setBody(requestBody);
            
            // Set the content to XML
            request.setHeader('Content-Type', 'application/json');
        }
        
        System.debug('Yohan VillaLeal: Sign the request based on OAuth 1.0a');
        // Sign the request based on OAuth 1.0a
        // request = XeroOAuthUtility.signRequest(request, xeroSetting);
        
        // request.setHeader('xero-tenant-id', 'b7464c72-24b6-4c59-aef6-315cd1028a8f');
        request.setHeader('xero-tenant-id', xeroSetting.Xero_Tenant_ID__c);
        // Print the request
        System.debug('Yohan VillaLeal: Request: ' + request);
        System.debug('Yohan VillaLeal: Body Request: ' + request.getBody());
        // Execute callout and return
        Http http = new Http();
        request.setTimeout(120000);
        HttpResponse httpResponse = http.send(request);
        System.debug('Yohan VillaLeal: Status Code '+httpResponse.getStatusCode());
        System.debug('Yohan VillaLeal: Status '+httpResponse.getStatus());
        System.debug('Yohan VillaLeal: Body '+httpResponse.getBody());
        
        return httpResponse;
        //  return new Http().send(request);
    }
}