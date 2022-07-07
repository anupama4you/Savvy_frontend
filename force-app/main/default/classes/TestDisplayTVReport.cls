@isTest(seeAlldata=true)
public class TestDisplayTVReport
{
    public static testMethod void myDisplayTVReport()
    {                
        
        User u = [SELECT Id
                  FROM User
                  WHERE profile.name like'Sales Consultant%'
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
                                  PersonEmail = 'test1'+System.now().millisecond() +'@test.com',
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
                                             Status__c = 'Quote Sent',OwnerId = u.Id/*,
                                             Date_closed_or_settled__c = Date.today().addMonths(-1)addYes(-1)*/);
        insert TestOpportunity;  
 
        //GenerateProductInvoicesExtension gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(TestOpportunity));
        //gpie.Generate();
        //gpie.Generate();
        
        TestOpportunity.Status__c = 'Settled';
        TestOpportunity.Date_Closed_or_Settled__c = Date.today();
        TestOpportunity.Sent_for_Settlement_Date__c = Date.today();
        
        update TestOpportunity;  
        
        TestOpportunity.Status__c = 'Closed Opportunity';
        TestOpportunity.Reason_For_Closure__c = 'could not beat quote';
        TestOpportunity.Date_Closed_or_Settled__c = Date.today();
        TestOpportunity.Sent_for_Settlement_Date__c = Date.today();
        
        update TestOpportunity; 
        
        TestLead.OwnerId = u.Id;
        TestLead.Date_Lead_to_Consultant__c = Date.today();
        update TestLead;
        
        
        System.runAs(u)
        {
            test.startTest();
            DisplayTVReport ctrl = new DisplayTVReport();
            ctrl.getConsWrapperList();
            ctrl.OverallLeads=4;
            ctrl.getTotalPreApproved();
            ctrl.getTotalVDSent();
            ctrl.getTotalVDNewDemoSent();
            ctrl.getTotalFullCompInsSales();
            ctrl.getTotalOtherInsSales();
            ctrl.getTotalFullCompConversionRate();
            ctrl.getTotalOtherConversionRate();

            List<SelectOption> y = ctrl.Years;
            ctrl.getOverallVDConversion();
            ctrl.getTotalPAIntoVD();
            ctrl.getTotalCurrentPreApproved();

            Test.StopTest();

        
        }
        
        
        
    }    

    public static testMethod void myDisplayTVReport2()
    {                
        
        User u = [SELECT Id
                  FROM User
                  WHERE profile.name like'Sales Consultant%'
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
                                  PersonEmail = 'test1'+System.now().millisecond() +'@test.com',
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
                                             Status__c = 'Quote Sent',OwnerId = u.Id/*,
                                             Date_closed_or_settled__c = Date.today().addMonths(-1)addYes(-1)*/);
        insert TestOpportunity;  
 
        //GenerateProductInvoicesExtension gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(TestOpportunity));
        //gpie.Generate();
        //gpie.Generate();
        
        TestOpportunity.Status__c = 'Settled';
        TestOpportunity.Date_Closed_or_Settled__c = Date.today();
        TestOpportunity.Sent_for_Settlement_Date__c = Date.today();
        
        update TestOpportunity;  
        
        TestOpportunity.Status__c = 'Closed Opportunity';
        TestOpportunity.Reason_For_Closure__c = 'could not beat quote';
        TestOpportunity.Date_Closed_or_Settled__c = Date.today();
        TestOpportunity.Sent_for_Settlement_Date__c = Date.today();
        
        update TestOpportunity; 
        
        TestLead.OwnerId = u.Id;
        TestLead.Date_Lead_to_Consultant__c = Date.today();
        update TestLead;
        
        
        System.runAs(u)
        {
            test.startTest();
            DisplayTVReport2Extension ctrl = new DisplayTVReport2Extension();
            ctrl.getConsWrapperList();
            ctrl.OverallLeads=4;
            ctrl.getTotalPreApproved();
            ctrl.getTotalVDSent();
            ctrl.getTotalVDNewDemoSent();
            ctrl.getTotalFullCompInsSales();
            ctrl.getTotalOtherInsSales();
            ctrl.getTotalFullCompConversionRate();
            ctrl.getTotalOtherConversionRate();

            List<SelectOption> y = ctrl.Years;
            ctrl.getOverallVDConversion();
            ctrl.getTotalPAIntoVD();
            ctrl.getTotalCurrentPreApproved();

            Test.StopTest();

        
        }
        
        
        
    }    
    
}