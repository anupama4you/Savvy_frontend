public class ApplicationExtraDataHelper {
	
    public static void upsertData(Id appId, String name, String typeOfData, Object obj) {
    	upsertData(appId, name, typeOfData, obj, true);
    }
    
    public static void upsertData(Id appId, String name, String typeOfData, Object obj, Boolean isPreApproval) {
        Application_Extra_Data__c aed = getApplicationExtraDataId(appId, typeOfData);
        if (aed != null) {
            aed.Data__c = JSON.serialize(obj);
            aed.Name = name;
            aed.Is_Pre_approval__c = isPreApproval;
            update aed;
        } else {
            addData(appId, name, typeOfData, obj, isPreApproval);
        }
    }
    
    public static void updateData(Id appId, String typeOfData, Object obj, Boolean isPreApproval) {
        Application_Extra_Data__c aed = getApplicationExtraDataId(appId, typeOfData);
        if (aed != null) {
            aed.Data__c = JSON.serialize(obj);
            aed.Is_Pre_approval__c = isPreApproval;
            update aed;
        }
    }
    
    public static void addData(Id appId, String name, String typeOfData, Object obj, Boolean isPreApproval) {
        Application_Extra_Data__c aed = new Application_Extra_Data__c();
        aed.Name = name;
        aed.Application__c = appId;
        aed.Type_of_Data__c = typeOfData;
        aed.Is_Pre_approval__c = isPreApproval;
        aed.Data__c = JSON.serialize(obj);
        insert aed;
    }
    
    public static void addPlainData(Id appId, String name, String typeOfData, String obj, Boolean isPreApproval) {
        addPlainData(appId, name, typeOfData, obj, isPreApproval, '') ;
    }
    
    public static void addPlainData(Id appId, String name, String typeOfData, String obj, Boolean isPreApproval, String category) {
        Application_Extra_Data__c aed = new Application_Extra_Data__c();
        aed.Name = name;
        aed.Application__c = appId;
        aed.Type_of_Data__c = typeOfData;
        aed.Is_Pre_approval__c = isPreApproval;
        aed.Data__c = obj;
        aed.Category__c = category;
        insert aed;
    }
    
    public static Application_Extra_Data__c getApplicationExtraDataId(Id appId, String typeOfData) {
      Application_Extra_Data__c r = null;
      if (String.isNotBlank(appId) && String.isNotBlank(typeOfData)) {
        try {
          r = [
            Select Name, Data__c, Is_Pre_approval__c, Category__c, Type_of_Data__c 
            From Application_Extra_Data__c 
            Where Application__c = :appId 
            And Type_of_Data__c = :typeOfData
            ORDER BY LastModifiedDate 
            DESC LIMIT 1
          ];
        } catch(Exception ignore){}
      }
      return r;
    }
 	
    public static Boolean isExistApplicationExtraDataId(Id appId, String typeOfData) {
        Application_Extra_Data__c d = getApplicationExtraDataId(appId, typeOfData);
        if (d != null) {
            return true;
        }
        return false;
    }
    
    public static Boolean isExistAnApplicationExtraDataRecorded(Id appId, String typeOfData) {
        Application_Extra_Data__c d = getApplicationExtraDataId(appId, typeOfData);
        if (d != null) {
            return true;
        }
        return false;
    }
    
    public static Application_Extra_Data__c getApplicationExtraDataById(String appExtraDataId) {
        Application_Extra_Data__c r = null;
        try {
            r = [Select Name, Data__c, Is_Pre_approval__c, Category__c, Type_of_Data__c 
                 From Application_Extra_Data__c 
                 Where Id = :appExtraDataId];
        } catch(Exception ignore){}
        return r;
    }
 	
    public static List<Application_Extra_Data__c> getApplicationExtraDataList(Id appId, String typeOfData) {
      List<Application_Extra_Data__c> r = null;
      if (String.isNotBlank(appId) && String.isNotBlank(typeOfData)) {
        try {
            r = [
            Select Id, Name, Data__c, LastModifieddate, Is_Pre_approval__c, Owner.Name, Category__c, Type_of_Data__c 
            From Application_Extra_Data__c 
            Where Application__c = :appId 
            And Type_of_Data__c = :typeOfData 
            Order by LastModifieddate desc
          ];
        } catch(Exception ignore){}
      }
      return r;
    }
    
    public static List<Application_Extra_Data__c> getApplicationExtraDataList(Id appId, String[] typeOfData) {
      List<Application_Extra_Data__c> r = null;
      if (String.isNotBlank(appId) && typeOfData != null && !typeOfData.isEmpty()) {
        try {
          r = [
            Select Id, Name, Data__c, LastModifieddate, Is_Pre_approval__c, Owner.Name, Category__c, Type_of_Data__c 
            From Application_Extra_Data__c 
            Where Application__c = :appId 
            And Type_of_Data__c = :typeOfData 
            Order by LastModifieddate desc
          ];
        } catch(Exception ignore){}
      }
      return r;
    }
    
    public static Set<String> getAllExtraDataTypesSaved(Id appId) {
        Set<String> r = new Set<String>();
        if (appId != null) {
            List<Application_Extra_Data__c> d = 
                    [Select Type_of_Data__c From Application_Extra_Data__c 
                     Where Application__r.Id = :appId];
            for (Application_Extra_Data__c a : d) {
                r.add(a.Type_of_Data__c);
            }
        }
        return r;
    }
}