/**
* @author       Ben Edwards (ben@edwards.nz)
* @description  Class to parse responses from Xero callouts
**/
public with sharing class XeroCalloutResponseParser {
	
	/**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Method to convert JSON responses into Xero objects
    *   @return Returns a Xero wrapper class object from a given response body
    *
    public static List<XeroContact> parseContacts(String jsonBody) {

        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'Contacts');
        
        // And finally parse the now re-serialized contact list back into Contact objects
        return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
    }*/

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Method to convert JSON responses into Xero objects
    *   @return Returns a Xero wrapper class object from a given response body
    **/
    public static List<XeroInvoice> parseInvoices(String jsonBody) {

        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'Invoices');

        // And finally parse the now re-serialized contact list back into Contact objects
        return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
    }
    
    /**
    *   @author Yohan Villamizar
    *   @description Method to take the full JSON response and just return the object portion. Eg. The TrackingCategories only
    *   @return JSON String with only specific object data
    **/
	public static List<XeroTrackingCategories> parseTrackingCategories(String jsonBody) {
		
        System.debug('Yohan VillaLeal jsonBody ' + jsonBody);
        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'TrackingCategories');
        System.debug('Yohan VillaLeal jsonSerialized ' + jsonSerialized);
        
        // And finally parse the now re-serialized contact list back into Contact objects
        List<XeroTrackingCategories> lis = (List<XeroTrackingCategories>) JSON.deserialize(jsonSerialized, List<XeroTrackingCategories>.class);
        System.debug('Yohan VillaLeal lis ' + lis[0]);
        return lis;
    }
    
    /**
    *   @author Yohan Villamizar
    *   @description Method to take the full JSON response and just return the object portion. Eg. The TrackingCategories only
    *   @return JSON String with only specific object data
    **/
	public static List<XeroOnlineInvoices> parseOnlineInvoice(String jsonBody) {
		
        System.debug('Yohan VillaLeal jsonBody ' + jsonBody);
        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'OnlineInvoices');
        System.debug('Yohan VillaLeal jsonSerialized ' + jsonSerialized);
        
        // And finally parse the now re-serialized contact list back into Contact objects
        List<XeroOnlineInvoices> lis = (List<XeroOnlineInvoices>) JSON.deserialize(jsonSerialized, List<XeroOnlineInvoices>.class);
        System.debug('Yohan VillaLeal lis ' + lis[0]);
        return lis;
    }
    
    /**
    *   @author Yohan Villamizar
    *   @description Method to take the full JSON response and just return the object portion. Eg. The TrackingCategories.Option only
    *   @return JSON String with only specific object data
    *
	public static List<XeroTrackingCategories.Option> parseTrackingOption(String jsonBody) {

        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'TrackingCategories.Options');
        
        // And finally parse the now re-serialized contact list back into Contact objects
        return (List<XeroTrackingCategories.Option>) JSON.deserialize(jsonSerialized, List<XeroTrackingCategories.Option>.class);
    }*/
    
    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Method to take the full JSON response and just return the object portion. Eg. The Contact and Invoice portion only
    *   @return JSON String with only specific object data
    **/
    private static String generateJsonStringForParsing (String jsonBody, String objectName) {

    	// Parse the JSON response
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);        
        // Re-serialize just the object portion back to JSON
        return JSON.serialize((List<Object>) jsonResponseMap.get(objectName));
    }
}