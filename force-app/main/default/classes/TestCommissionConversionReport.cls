@isTest
public class TestCommissionConversionReport
{
    public static testMethod void myUnitTest()
    {                
        Test.StartTest(); 

        set<Id> userIds = new Set<Id>();
        for (Group g : [SELECT Id
            FROM Group
            WHERE DeveloperName = 'Sales_Consultants' and Type = 'Regular'
            LIMIT 1])
        {
            
            for (GroupMember gm : [SELECT UserOrGroupId
                                   FROM GroupMember
                                   WHERE GroupId = :g.Id])
            {
                userIds.add(gm.UserOrGroupId);
            } 
       }           
 
        
        User u = [SELECT Id
                  FROM User
                  WHERE id in:userIds
                  AND IsActive = true
                  LIMIT 1];
        Map<String,id> RecordTypes = new Map<String, Id>();
        for (RecordType rt : [SELECT Id,
                                     Name
                              FROM RecordType])
        {
            RecordTypes.put(rt.Name, rt.Id);
        }  
        
        Account TestAccount = new Account(RecordTypeId = recordTypes.get('Person Account'),
                                  FirstName = 'Test12',
                                  LastName = 'Test3',
                                  PersonMobilePhone = '04123425678',
                                  PersonEmail = 'test1@test.com',
                                  PersonOtherStreet = 'Test',
                                  PersonOtherCity = 'Test',
                                  PersonOtherState = 'Test',
                                  PersonOtherPostalCode = 'Test');
        insert TestAccount;
        
        testAccount.PersonMobilePhone ='12341212343';
        
        update testAccount;
         
        Account TestLeadConsultantDealer = new Account(RecordTypeId = recordTypes.get('Savvy Dealer'),
                                               Name = 'Testde',
                                               BillingStreet = 'Test',
                                               BillingCity = 'Test',
                                               BillingState = 'Test',
                                               BillingPostalCode = 'Test',
                                               ShippingStreet = 'Test',
                                               ShippingCity = 'Test',
                                               ShippingState = 'Test',
                                               ShippingPostalCode = 'Test',
                                               Commission_Amount__c = 123);
        insert TestLeadConsultantDealer;
        
        Contact TestLeadConsultant = new Contact(AccountId = TestLeadConsultantDealer.Id,
                                         FirstName = 'Testwf',
                                         LastName = 'Teste');
        insert TestLeadConsultant;   
        
        Lead__c TestLead = new Lead__c(Account__c = TestAccount.Id,
                               First_Name__c = 'Testcd',
                               Last_Name__c = 'Testwe',
                               Finance_Amount__c = 123,
                               Email_Address__c = 'testr2@test.com',
                               Lead_Consultant__c = TestLeadConsultant.Id,
                               OwnerId = UserInfo.getUserId(),
                               Status__c = 'Attempted Contact 1');
        insert TestLead; 
        
        Custom_Opportunity__c TestOpportunity = new Custom_Opportunity__c(Account__c = TestAccount.Id,
                                             Lead__c = TestLead.Id,
                                             Status__c = 'Quote Sent'/*,
                                             Date_closed_or_settled__c = Date.today().addMonths(-1)addYes(-1)*/);
        insert TestOpportunity;  
        Test.stopTest();
        // close all open tasks
        List<Task> tasks = [SELECT Id,
                                   Status
                            FROM Task
                            WHERE Status != 'Completed'];
                            
        for (Task t : tasks)                            
        {
            t.Status = 'Completed';
        }                          
        update tasks;     
        
        //GenerateProductInvoicesExtension gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(TestOpportunity));
        //gpie.Generate();
        //gpie.Generate();
        
        TestOpportunity.Status__c = 'Settled';
        TestOpportunity.Date_Closed_or_Settled__c = Date.today();
        TestOpportunity.Sent_for_Settlement_Date__c = Date.today();
        TestOpportunity.OwnerId = u.Id;
        
        update TestOpportunity;
                                                                                   
        
        TestLead.OwnerId = u.Id;
        TestLead.Date_Lead_to_Consultant__c = Date.today();
        update TestLead;
        
        System.runAs(u)
        {
            CommissionConversionReport ctrl = new CommissionConversionReport();
            system.assert(ctrl.Consultants != null);
            system.assert(ctrl.Years != null);
        }
        
        
    }    
}