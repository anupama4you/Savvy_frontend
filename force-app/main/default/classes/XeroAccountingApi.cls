/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {
    
    // Ordering ENUM
    public enum SortOrder {ASCENDING, DESCENDING}
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return ALL contacts for your Xero environment
*   @return List of Xero Contact wrapper classes
*
public static List<XeroContact> getContacts (Xero_API_Setting__c xeroSetting) {

List<XeroContact> xeroContacts = new List<XeroContact>();

// Execute the callout to the Contacts resource
HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts', null, xeroSetting);
System.debug('Yohan VillaLeal: httpResponse Body '+ response.getBody());

if (response.getStatusCode() == 200) {
// Use the parser to convert the response into Xero objects
xeroContacts = XeroCalloutResponseParser.parseContacts(response.getBody());
}
else {
// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}
return xeroContacts;
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return ALL contacts for your Xero environment
*   @return List of Xero Contact wrapper classes
*
public static XeroContact getContact (String xeroContactId) {

XeroContact xeroContact = new XeroContact();

// Execute the callout to the Contacts resource
HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts/' + xeroContactId, null);

// If successful response
if (response.getStatusCode() == 200) {

// Use the parser to convert the response into Xero objects
xeroContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
}
else {

// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}

return xeroContact;
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to create a Contact in Xero. 
*   @return Returns the Contact Id of the Contact created in Xero
*
public static XeroContact createContact (String contactBody) {

// The created contact to return
XeroContact createdContact;

System.debug('Yohan VillaLeal: Body ' + contactBody);
// Execute the callout to the Contacts resource
HttpResponse response = XeroCalloutUtility.executeCallout('POST', 'Contacts', contactBody);

// If successful response
if (response.getStatusCode() == 200) {

// Use the parser to convert the response into Xero objects
createdContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
}
else {

// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}

return createdContact;
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return ALL invoices for your Xero environment
*   @return List of Xero Invoice wrapper classes
*
public static List<XeroInvoice> getInvoices () {

return getInvoices(null, null);
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return ALL invoices for your Xero environment
*   @return List of Xero Invoice wrapper classes
*
public static List<XeroInvoice> getInvoices (String orderBy, XeroAccountingApi.SortOrder sortOrder) {

List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

String endpoint = 'Invoices';

// Add any ordering parameters
if (String.isNotBlank(orderBy)) {

endpoint += '?order=' + orderBy;
}

// Set a sort order if exists
// Only bothering with descending, as ascending is done by default
if (sortOrder != null && sortOrder == XeroAccountingApi.SortOrder.DESCENDING) {

endpoint += '%20DESC';
}

// Execute the callout to the Invoice resource
HttpResponse response = XeroCalloutUtility.executeCallout('GET', endpoint, null);

// If successful response
if (response.getStatusCode() == 200) {

// Use the parser to convert the response into Xero objects
xeroInvoices = XeroCalloutResponseParser.parseInvoices(response.getBody());
}
else {

// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}

return xeroInvoices;

}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return a single invoice for your Xero environment for a given Xero Invoice
*   @return Single Xero Invoice
*
public static XeroInvoice getInvoice (String invoiceId) {

XeroInvoice xeroInvoice = new XeroInvoice();

// Execute the callout to the Invoice resource
HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices/' + invoiceId, null);

// If successful response
if (response.getStatusCode() == 200) {

// Use the parser to convert the response into Xero objects
xeroInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
}
else {

// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}

return xeroInvoice;
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to return all invoices for a given Contact Id
*   @return List of Xero Invoice wrapper classes
*
public static List<XeroInvoice> getInvoicesForContact (String xeroContactId) {

List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

// Execute the callout to the Invoice resource with the Contact ID filter
HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices?where=Contact.ContactID%20%3D%20Guid%28%22' + xeroContactId + '%22%29', null);

// If successful response
if (response.getStatusCode() == 200) {
system.debug('Yohan VillaLeal: Use the parser to convert the response into Xero objects');
// Use the parser to convert the response into Xero objects
xeroInvoices = XeroCalloutResponseParser.parseInvoices(response.getBody());
}
else {

// Raise error
throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
}

return xeroInvoices;
}*/
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Method to create an invoice in Xero. 
*   @return Returns the invoice Id of the invoice created in Xero
**/
    public static XeroInvoice createInvoice (String invoiceBody, Xero_API_Setting__c xeroSetting) {
        
        // The created invoice to return
        XeroInvoice createdInvoice;
        
        HttpResponse response = null;
        System.debug('JSON request...');
        System.debug('JSON request ' + invoiceBody);
        response = XeroCalloutUtility.executeJsonCallout('POST', 'Invoices', invoiceBody, xeroSetting);
        System.debug('Yohan VillaLeal Savvy ' + response.getBody());
        
        if (response.getStatusCode() == 200) {
            createdInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
            System.debug('Yohan createInvoice ' + createdInvoice.InvoiceNumber);
        }
        else if (response.getStatusCode() == 400){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invoice not of valid status for creation'));
        }
        return createdInvoice;
    }
    
    /**
*   @author Ben Edwards (ben@benedwards.co.nz)
*   @description Custom exception class to throw errors for web service callouts
**/
    public class XeroAccountingApiException extends Exception {}
    
    /**
*   @author Yohan VillaLeal
*   @description Method to return a Sigle Tracking by categories for your Xero environment for a given Xero Invoice
*   @return a list of Tracking by category - Xero Invoice
**/
    public static XeroOnlineInvoices getInvoicePdf (String invoiceID, Xero_API_Setting__c xeroSetting) {
        
        XeroOnlineInvoices onlineInvoices = new XeroOnlineInvoices();
        HttpResponse response = null;
        // Execute the callout to the Invoice resource        
        String url = 'Invoices/'+invoiceID+'/OnlineInvoice';
        if (Test.isRunningTest()) {
            url = 'Invoices?InvoiceID='+invoiceID+'/OnlineInvoice';
        }
        response = XeroCalloutUtility.executeJsonCallout('GET', url, null, xeroSetting);
        
        // If successful response
        if (response.getStatusCode() == 200) {
            // Use the parser to convert the response into Xero objects
            System.debug('Yohan VillaLeal response.getBody() ' + response.getBody());
            onlineInvoices = XeroCalloutResponseParser.parseOnlineInvoice(response.getBody())[0];
        }else if(response.getStatusCode() == 400){
            onlineInvoices.ErrorMsg = 'Invoices Documents can only be downloaded for invoices that have been AUTHORISED';
        }else {
            // Raise error
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error ocurred downloading the documents.'));
        }
        return onlineInvoices;
    }
    
    /**
*   @author Yohan VillaLeal
*   @description Method to return a Sigle Tracking by categories for your Xero environment for a given Xero Invoice
*   @return a list of Tracking by category - Xero Invoice
**/
    public static XeroTrackingCategories getTrackingCaategory (Xero_API_Setting__c xeroSetting) {
        
        XeroTrackingCategories trackingCategory = new XeroTrackingCategories();
        HttpResponse response = null;
        // Execute the callout to the Invoice resource        
        String url = 'TrackingCategories/' + xeroSetting.Tag_Category__c;
        if (Test.isRunningTest()) {
            url = 'TrackingCategories?TrackingCategoryID='+xeroSetting.Tag_Category__c;
        }
        response = XeroCalloutUtility.executeJsonCallout('GET', url, null, xeroSetting);
        
        // If successful response
        if (response.getStatusCode() == 200) {
            System.debug('Yohan VillaLeal response.getBody() ' + response.getBody());
            trackingCategory = XeroCalloutResponseParser.parseTrackingCategories(response.getBody())[0];
        }else {
            // Raise error
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error ocurred getting the categories.'));
        }
        return trackingCategory;
    }
    
    public static void createTrackingOption (String optionBody, Xero_API_Setting__c xeroSetting){
        
        // The created option to return
        boolean optionReturn = false;
        
        HttpResponse response = null;
        
        System.debug('JSON request...');
        String url = 'TrackingCategories/'+xeroSetting.Tag_Category__c+'/Options';
        if (Test.isRunningTest()) {
            url = 'TrackingCategories?TrackingCategoryID='+xeroSetting.Tag_Category__c+'/Options';
        }
        response = XeroCalloutUtility.executeJsonCallout('PUT', url, optionBody, xeroSetting);
        
        // If successful response
        if (response.getStatusCode() == 200) {
            System.debug('Tracking Option created successfully');            
        }
        else {
            // Raise error
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error ocurred creating a tracking option.'));
        }
    }
}