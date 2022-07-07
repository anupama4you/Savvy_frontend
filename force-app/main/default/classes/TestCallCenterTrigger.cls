@isTest(SeeAllData=true)
public class TestCallCenterTrigger extends TestAPILenders{
    
    public static Custom_Opportunity__c opp;
    
    public static testMethod void testGeneral(){
        opp = loadData();
        Test_DataGeneratorHelper.createLead();
        opp.Lead__r = Test_DataGeneratorHelper.tstLead;
        update opp;
        Test.startTest();
        Call_Center_Upl__c callCenter = new Call_Center_Upl__c();
        callCenter.Account__c = Test_DataGeneratorHelper.tstLead.Id;
        callCenter.Mobile__c = '0410987654';
        callCenter.Email__c = 'email@savvy.com.au';
        callCenter.SmsTextSent__c = 'Sms Text Sent';
        callCenter.Dialerdisp__c = 'Dialerdisp';
        callCenter.Agent__c = 'Agent_1';
        callCenter.Atime1__c = '2018-09-27 19:58:03';
        insert callCenter;
        List<Call_Center_Upl__c> calls = new List<Call_Center_Upl__c>();
        calls.add(callCenter);
        CallCenterUpl_Service.createCallTaskReference(calls);
        
        Map<ID, sObject> newRecordsMap = new Map<ID, sObject>();
        newRecordsMap.put(Test_DataGeneratorHelper.tstLead.Id, callCenter);
        CallCenterUplTriggerHandler callHandler = new CallCenterUplTriggerHandler();
        callHandler.onAfterInsert(calls, newRecordsMap);
        Test.stopTest();
    }
}