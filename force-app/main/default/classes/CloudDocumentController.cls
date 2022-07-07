public without sharing class CloudDocumentController {
    //Get the cloud document on upload aura comoponent
   @AuraEnabled
    public static List<Cloud_Documents__c> getRecords(String oppId) {
        List<Cloud_Documents__c> accs = [Select Id, Name, Document_Type__c, Send_To_Lender__c, File_Name__c, Preview_Link__c, SendToLender__c   
                              	From Cloud_Documents__c WHERE Custom_Opportunity__c = :oppId 
                                Order By CreatedDate DESC];
        return accs;
    }
    
    //Update Cloud_Documents__c picklist values updated here 
    @AuraEnabled
    public static void updateRecords(String jsonString){
        try{
            List<Cloud_Documents__c> records = (List<Cloud_Documents__c>) JSON.deserialize(jsonString, List<Cloud_Documents__c>.class);
            for (Cloud_Documents__c a: records) {
              a.Send_To_Lender__c = 'Yes'.equals(a.SendToLender__c);
            }
            update records;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //get the picklist value dynamic from getPicklistValues method
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
        system.debug('::: pickListValuesMap :::'+pickListValuesMap);
        return pickListValuesMap;
    }
    
    //get Yes No Picklist value from here 
    @AuraEnabled        
    public static Map<String,String> getYesNoPicklistValues(String objectAPIName, String fieldAPIName){
        Map<String,String> pickListValuesMap = new Map<String,String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get(fieldAPIName).getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
           // if(isFieldNotRequired)
            //    pickListValuesMap.put('--None--', '');
            if(pickListVal.isActive())
                pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        system.debug('::: pickListValuesMap :::'+pickListValuesMap);
        return pickListValuesMap;
    }
    
    // Delete Cloud Document 
    @AuraEnabled
    public static void deleteCloudDoc (String deleteDocId) {
        System.debug('deleteDocId =====>' + deleteDocId);
        deleteDocId = deleteDocId.replaceAll('"','');
        List<Cloud_Documents__c> delDoc = new List<Cloud_Documents__c>();
        Cloud_Documents__c docc = new Cloud_Documents__c();
        docc.id = deleteDocId;
        delDoc.add( docc );
        delete docc;
    }
    
    //Insert Cloud document 
    @AuraEnabled
    public static void insertCloudDoc (String docId, String docName, String customOppId) {
      ContentVersion vers = [SELECT FileExtension, FileType, VersionData FROM ContentVersion WHERE ContentDocumentId =:docId LIMIT 1 ];
      PartnerCommunityController.uploadFileOrFail(customOppId, docName, S3Utils.getContentType(docName), vers.VersionData);
      delete new ContentDocument(Id=docId);
    }

  // Amazon S3 link
  @AuraEnabled
  public static String signCloudDocument(String docId) {
    return S3Utils.getSignedURL(docId);
  }

}