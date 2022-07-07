public without sharing class CustomDeleteRecordController {
  
  @AuraEnabled
    public static Map<String, String> deleteRecord(Id recordId){
      Map<String, String> r = new Map<String, String>();
      r.put('status', '0');
      System.debug('@@recordId: ' + recordId);
      return r;
    }

}