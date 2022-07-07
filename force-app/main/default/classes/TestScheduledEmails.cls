@isTest
public class TestScheduledEmails
{
    public static testMethod void myUnitTest()
    {                          
          
        
        Test.startTest();
        Test_DataGeneratorHelper.recordTypes();                      
        Test_DataGeneratorHelper.createAccount();
        Test_DataGeneratorHelper.createLead();            
        Custom_Opportunity__c o3m = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                  Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                  Status__c = 'Quote Sent',
                                  Email_Address__c = 'me@here.com'); 
        //insert o3m;                                          
        
        Custom_Opportunity__c o1y = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                  Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                  Status__c = 'Quote Sent',
                                  Email_Address__c = 'test3@test.com');    
        //insert o1y;  
        
        Custom_Opportunity__c o2y = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                  Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                  Status__c = 'Quote Sent',
                                  Email_Address__c = 'test4@test.com');
        //insert o2y;
        
        Custom_Opportunity__c o3y = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                  Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                  Status__c = 'Quote Sent',
                                  Email_Address__c = 'test5@test.com');
        //insert o3y; 
        
        Custom_Opportunity__c o4y = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                  Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                  Status__c = 'Quote Sent',
                                  Email_Address__c = 'test6@test.com');  
        //insert o4y;
        
        List<Custom_Opportunity__c> opps = new List<Custom_Opportunity__c>();
        opps.add(o3m);
        opps.add(o1y);
        opps.add(o2y);
        opps.add(o3y);
        opps.add(o4y);
        
        insert opps;
                             
        Product__c o3mp = new Product__c(RecordTypeId = Test_DataGeneratorHelper.RecordTypes.get('Finance'),
                              Opportunity_Name__c = o3m.Id,
                              End_of_Loan_Date__c = Date.today().addDays(1),                              
                              DOF__c = 1,                              
                              Brokerage__c = 1);                     
        
        Product__c o1yp = new Product__c(RecordTypeId = Test_DataGeneratorHelper.RecordTypes.get('Finance'),
                              Opportunity_Name__c = o1y.Id,
                              End_of_Loan_Date__c = Date.today().addDays(1),                              
                              DOF__c = 1,
                              Brokerage__c = 1);  
        
        Product__c o2yp = new Product__c(RecordTypeId = Test_DataGeneratorHelper.RecordTypes.get('Finance'),
                              Opportunity_Name__c = o2y.Id,
                              End_of_Loan_Date__c = Date.today().addDays(1),                              
                              DOF__c = 1,
                              Brokerage__c = 1);
        
        Product__c o3yp = new Product__c(RecordTypeId = Test_DataGeneratorHelper.RecordTypes.get('Finance'),
                              Opportunity_Name__c = o3y.Id,
                              End_of_Loan_Date__c = Date.today().addDays(1),                              
                              DOF__c = 1,
                              Brokerage__c = 1); 
        
        Product__c o4yp = new Product__c(RecordTypeId = Test_DataGeneratorHelper.RecordTypes.get('Finance'),
                              Opportunity_Name__c = o4y.Id,
                              End_of_Loan_Date__c = Date.today().addDays(1),                              
                              DOF__c = 1,
                              Brokerage__c = 1);
                              
        List<Product__c> products = new List<Product__c>();
        products.add(o3mp);
        products.add(o1yp);
        products.add(o2yp);
        products.add(o3yp);
        products.add(o4yp);  
        
        insert products;                            
        System.debug('products:::' + products);
        Set<Id> prodIds = new Set<Id>();
        for(Product__c pp : products){
        	prodIds.add(pp.Id);
        }
        
        //GenerateProductInvoicesExtension gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(o3m));
        //gpie.Generate();
                                                                                                                                                                                                   
        //gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(o1y));
        //gpie.Generate();                               
                                                                                 
        //gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(o2y));
        //gpie.Generate();                        
                                        
        //gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(o3y));
        //gpie.Generate();
                                                                                   
        //gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(o4y));
        //gpie.Generate();
                                                                        
        // close all open tasks
        List<Task> tasks = [SELECT Id,
                                   Status
                            FROM Task
                            WHERE Status != 'Completed'];
                            
        for (Task t : tasks)                            
        {
            t.Status = 'Completed';
        }                          
        //update tasks;            
                    
        o3m.Status__c = 'Settled';
        o3m.Date_closed_or_settled__c = Date.today().addMonths(-3);
        o3m.Sent_for_Settlement_Date__c = Date.today().addMonths(-3); 
        //update o3m;
        System.debug([Select Id from Product__c where Opportunity_Name__c= : o3m.Id].size());
        o1y.Status__c = 'Settled';
        o1y.Date_closed_or_settled__c = Date.today().addYears(-1);
        o1y.Sent_for_Settlement_Date__c = Date.today().addYears(-1); 
        //update o1y;
        System.debug([Select Id from Product__c where Opportunity_Name__c= : o1y.Id].size());
        o2y.Status__c = 'Settled';
        o2y.Date_closed_or_settled__c = Date.today().addYears(-2);
        o2y.Sent_for_Settlement_Date__c = Date.today().addYears(-2); 
        //update o2y;  
        System.debug([Select Id from Product__c where Opportunity_Name__c= : o2y.Id].size());
        o3y.Status__c = 'Settled';
        o3y.Date_closed_or_settled__c = Date.today().addYears(-3);
        o3y.Sent_for_Settlement_Date__c = Date.today().addYears(-3); 
        //update o3y;
        System.debug([Select Id from Product__c where Opportunity_Name__c= : o3y.Id].size());
        o4y.Status__c = 'Settled';
        o4y.Date_closed_or_settled__c = Date.today().addYears(-4);
        o4y.Sent_for_Settlement_Date__c = Date.today().addYears(-4); 
        //update o4y;
        System.debug([Select Id from Product__c where Opportunity_Name__c= : o4y.Id].size());
        System.debug('opps:::' + opps);
        Set<Id> opIdsTest = new Set<Id>();
        for(Custom_Opportunity__c opRec : opps){
        	opIdsTest.add(opRec.Id);
        }
        
        /*List<Invoice__c> invoiceList = new List<Invoice__c>();
        //for(Product__c prod : products){
        Invoice__c inv1 = new Invoice__c(RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Insurance Invoice').getRecordTypeId(), Account__c = Test_DataGeneratorHelper.tstAccount.Id, Date_of_Invoice__c = Date.today(), Saasu_Expense_Number__c = 'test1', Opportunity__c = o3m.Id, Product__c = o3mp.Id);
        invoiceList.add(inv1);
        Invoice__c inv2 = new Invoice__c(RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Insurance Invoice').getRecordTypeId(), Account__c = Test_DataGeneratorHelper.tstAccount.Id, Date_of_Invoice__c = Date.today(), Saasu_Expense_Number__c = 'test2', Opportunity__c = o1y.Id, Product__c = o1yp.Id);
        invoiceList.add(inv2);
        Invoice__c inv3 = new Invoice__c(RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Insurance Invoice').getRecordTypeId(), Account__c = Test_DataGeneratorHelper.tstAccount.Id, Date_of_Invoice__c = Date.today(), Saasu_Expense_Number__c = 'test3', Opportunity__c = o2y.Id, Product__c = o2yp.Id);
        invoiceList.add(inv3);
        Invoice__c inv4 = new Invoice__c(RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Insurance Invoice').getRecordTypeId(), Account__c = Test_DataGeneratorHelper.tstAccount.Id, Date_of_Invoice__c = Date.today(), Saasu_Expense_Number__c = 'test4', Opportunity__c = o3y.Id, Product__c = o3yp.Id);
        invoiceList.add(inv4);
        Invoice__c inv5 = new Invoice__c(RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Insurance Invoice').getRecordTypeId(), Account__c = Test_DataGeneratorHelper.tstAccount.Id, Date_of_Invoice__c = Date.today(), Saasu_Expense_Number__c = 'test5', Opportunity__c = o4y.Id, Product__c = o4yp.Id);
        invoiceList.add(inv5);
        //}
        System.debug('invoiceList:::' + invoiceList);
        insert invoiceList;*/
        System.assertEquals(5, [Select Id from Product__c].size());
        //System.assertEquals(5, [Select Id from Invoice__c where Product__c in : prodIds].size());
        //for(Product__c pr : QueryStaticsObjects.setProductList(opIdsTest)){
        //	System.debug('OPPORTUNITIES INVOICES:' + pr.Id);
        //	for(Invoice__c ii : pr.Invoices__r){
        //		System.debug('OPPORTUNITIES INVOICES:' + ii);
        //	}
        	
        //}
        
        update opps;
                                         
        String sched = '0 0 18 * * ? 2099';
        
        // Schedule the test job
        String jobId = System.schedule('TestScheduledEmails', sched, new ScheduledEmails());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT id, 
                                 CronExpression, 
                                 TimesTriggered, 
                                 NextFireTime 
                          FROM   CronTrigger 
                          WHERE  id = :jobId];
                          
        // Verify the expressions are the same
        System.assertEquals(sched, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2099-01-01 18:00:00', String.valueOf(ct.NextFireTime));      
        
        Test.stopTest();         
    }
}