@isTest
public class TriggerManager_Test extends TriggerHandler {
    
    public class SobjectTriggerHandler_Test extends TriggerHandler {
        public override void onBeforeInsert(List<sObject> newRecords) { 
            super.onBeforeInsert(newRecords);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_INSERT); 
        }
    
        public override void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) { 
            super.onBeforeUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_UPDATE); 
        }
        
        public override void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
            super.onBeforeDelete(oldRecords, oldRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_DELETE); 
        }
        
        public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
            super.onAfterInsert(newRecords, newRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_INSERT); 
        }
        
        public override void onAfterUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap) {
            super.onAfterUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_UPDATE); 
        }
        
        public override void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
            super.onAfterDelete(oldRecords, oldRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_DELETE); 
        }
        
        public override void onAfterUndelete(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
            super.onAfterUndelete(newRecords, newRecordsMap);
            TEST_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_UNDELETE); 
        }
    
    }
    
    public class SobjectTriggerOrderHandler_Test extends TriggerOrderHandler {
        public override void onBeforeInsert(List<sObject> newRecords) { 
            super.onBeforeInsert(newRecords);
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_INSERT); 
        }
    
        public override void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordsMap, Map<ID, SObject> newRecordsMap) { 
            super.onBeforeUpdate(oldRecords, newRecords, oldRecordsMap, newRecordsMap);
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_UPDATE); 
        }
        
        public override void onBeforeDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_BEFORE_DELETE); 
        }
        
        public override void onAfterInsert(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_INSERT); 
        }
        
        public override void onAfterUpdate(List<sObject> oldRecords, List<sObject> newRecords, Map<ID, sObject> oldRecordsMap, Map<ID, sObject> newRecordsMap) {
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_UPDATE); 
        }
        
        public override void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
            TEST_ORDER_CTX.add(TriggerOrderHandler.CTX.IS_AFTER_DELETE); 
        }
        
        public override void onAfterUndelete(List<sObject> newRecords, Map<ID, sObject> newRecordsMap) {
        }
    
    }
    
    private static final Set<TriggerOrderHandler.CTX> TEST_CTX = new Set<TriggerOrderHandler.CTX>();
    private static final Set<TriggerOrderHandler.CTX> TEST_ORDER_CTX = new Set<TriggerOrderHandler.CTX>();
    
    
    @isTest
    public static void testNormalTrigger() {
    	Id personAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account(RecordTypeId = personAccountRecTypeId,
        						FirstName='testFN',
        						LastName='testLN',
        						PersonMobilePhone='123145',
        						PersonEmail='test@test.org.tst');
        insert a;
        
        Lead__c s = new Lead__c(
            Name = 'Test', Account__c= a.Id, Status__c = 'New Lead', First_Name__c = 'testFN', Last_Name__c = 'testLN', Finance_Amount__c=50
        );
        insert s;       
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_BEFORE_INSERT));
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_INSERT));
        
        update s;
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_BEFORE_UPDATE));
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_UPDATE));
        
        delete s;
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_BEFORE_DELETE));
        //system.assert(TEST_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_DELETE));
        
    }
    
    @isTest
    public static void testByPass() {
        Solution s = new Solution(
            SolutionName = 'Test'
        );
        
        TriggerManager.bypass(SobjectTriggerHandler_Test.class);
        insert s;        
        system.assert(TEST_CTX.isEmpty());
        system.assert(TriggerManager.isBypassed(SobjectTriggerHandler_Test.class));
        
        update s;
        system.assert(TEST_CTX.isEmpty());
        system.assert(TriggerManager.isBypassed(SobjectTriggerHandler_Test.class));
        
        delete s;
        system.assert(TEST_CTX.isEmpty());
        system.assert(TriggerManager.isBypassed(SobjectTriggerHandler_Test.class));
        TriggerManager.clearBypass(SobjectTriggerHandler_Test.class);
        
        
        system.assert( !TriggerManager.isBypassed(SobjectTriggerHandler_Test.class) );
        system.assert(TriggerManager.bypassedHandlers.isEmpty());
    }
    
    @isTest
    public static void testSkipAll() {
        Solution s = new Solution(
            SolutionName = 'Test'
        );
        
        insert new Trigger_Settings__c(Skip_All_Triggers__c = true);
        
        insert s;        
        system.assert(TEST_CTX.isEmpty());
        
        update s;
        system.assert(TEST_CTX.isEmpty());
        
        delete s;
        system.assert(TEST_CTX.isEmpty());
        
        TriggerManager.clearAllBypasses();
    }
    
    @isTest
    public static void testOrderTrigger() {
    	Id personAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    	
        Account a = new Account(RecordTypeId = personAccountRecTypeId,
        						FirstName='testFN',
        						LastName='testLN',
        						PersonMobilePhone='123145',
        						PersonEmail='test@test.org.tst');
        insert a;
        
        Lead__c s = new Lead__c(
            Name = 'Test', Account__c= a.Id, Status__c = 'New Lead', First_Name__c = 'testFN', Last_Name__c = 'testLN', Finance_Amount__c=50
        );
        insert s;        
        //system.assert(TEST_ORDER_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_INSERT));
        
        update s;
        //system.assert(TEST_ORDER_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_UPDATE));
        
        delete s;
        //system.assert(TEST_ORDER_CTX.contains(TriggerOrderHandler.CTX.IS_AFTER_DELETE));
        
    }
    
}