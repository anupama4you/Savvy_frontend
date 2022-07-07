@isTest
public class TestApplicationExtraDataHelper {
	
    public static testMethod void generalTest() {
        Application__c app = new Application__c();
        app.Name = 'd';
        app.Email_Address__c = 'l@l.l';
        app.First_Name__c = 'Lelo';
        app.Last_Name__c = 'Lelos';
        app.Mobile_Number__c = '042588';
        insert app;
        Id appId = app.Id;
        List<Application_Extra_Data__c> dataList = ApplicationExtraDataHelper.getApplicationExtraDataList(appId, 'TYPE DATA');
        dataList = ApplicationExtraDataHelper.getApplicationExtraDataList(appId, new List<String>{'TYPE DATA'});
        
        Application_Extra_Data__c data = ApplicationExtraDataHelper.getApplicationExtraDataById('appExtraDataId');
        
        Boolean isOk = ApplicationExtraDataHelper.isExistAnApplicationExtraDataRecorded(appId, 'Notes');
        isOk = ApplicationExtraDataHelper.isExistApplicationExtraDataId(appId, 'Notes');
        
        ApplicationExtraDataHelper.addPlainData(appId, 'name', 'Notes', 'obj', true);
        
        ApplicationExtraDataHelper.upsertData(appId, 'name', 'Notes', 'obj');
        
        ApplicationExtraDataHelper.addData(appId, 'name', 'Notes', app, false);
        
        ApplicationExtraDataHelper.updateData(appId, 'Notes', app, false);

        ApplicationExtraDataHelper.getAllExtraDataTypesSaved(appId);
        
    }
    
}