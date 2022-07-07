public with sharing class AccountsTableController {
    
    @AuraEnabled
    public static List<Account> getRecords() {
        List<Account> accs = [SELECT Id, Name, Type, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, CreatedDate
                              FROM Account ORDER BY Name LIMIT 10];
        return accs;
    }
    
    @AuraEnabled
    public static void updateRecords(String jsonString){
        try{
            List<Account> records = (List<Account>) JSON.deserialize(jsonString, List<Account>.class);
            update records;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled        
    public static Map<String,String> getPicklistValues(String objectAPIName, String fieldAPIName){
        Map<String,String> pickListValuesMap = new Map<String,String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get(fieldAPIName).getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            if(isFieldNotRequired)
                pickListValuesMap.put('--None--', '');
            if(pickListVal.isActive())
                pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        return pickListValuesMap;
    }
}