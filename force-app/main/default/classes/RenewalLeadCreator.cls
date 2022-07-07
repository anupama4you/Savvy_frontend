public class RenewalLeadCreator
{
    public static void Create()
    {
        List<Task> tasks = new List<Task>();
                
        // find the products that end 60 days from today
        for (Product__c p : [SELECT Id,   
                                    Opportunity_Name__c,
                                    Opportunity_Name__r.OwnerId                                    
                             FROM Product__c
                             WHERE Opportunity_Name__r.Status__c = 'Settled'
                             AND End_of_Loan_Date__c = :Date.today().addDays(60)])
        {
            // create renewal task
            Task newTask = new Task();
            newTask.OwnerId = p.Opportunity_Name__r.OwnerId;
            newTask.WhatId = p.Opportunity_Name__c;
            newTask.Subject = 'Car & Finance Renewal Task';
            newTask.Description = 'Car & Finance Renewal Task';           
            newTask.ActivityDate = Date.today();
            newTask.Status = 'Not Started';
            newTask.Priority = 'Normal';            
            newTask.IsReminderSet = true;
            newTask.ReminderDateTime = Datetime.now();                           
                                    
            tasks.add(newTask);
        }  
        
        insert tasks;
    
    
        /*    
        List<Lead__c> leads = new List<Lead__c>();
    
        User sysGen = [SELECT Id
                       FROM User
                       WHERE Name = 'System Generated'];
    
        // find the products that end 60 days from today
        for (Product__c p : [SELECT Id,          
                                    Opportunity_Name__r.Lead__r.Account__c,                          
                                    Opportunity_Name__r.Lead__r.OwnerId,
                                    Opportunity_Name__r.Lead__r.Owner.IsActive,
                                    Opportunity_Name__r.Lead__r.First_Name__c,
                                    Opportunity_Name__r.Lead__r.Last_Name__c,
                                    Opportunity_Name__r.Lead__r.Date_of_Birth__c,
                                    Opportunity_Name__r.Lead__r.Home_Phone__c,
                                    Opportunity_Name__r.Lead__r.Street__c,
                                    Opportunity_Name__r.Lead__r.Work_Phone__c,
                                    Opportunity_Name__r.Lead__r.Suburb__c,
                                    Opportunity_Name__r.Lead__r.Mobile_Number__c,
                                    Opportunity_Name__r.Lead__r.State__c,
                                    Opportunity_Name__r.Lead__r.Email_Address__c,
                                    Opportunity_Name__r.Lead__r.Postcode__c,
                                    Opportunity_Name__r.Lead__r.Finance_Amount__c
                             FROM Product__c
                             WHERE Opportunity_Name__r.Status__c = 'Settled'
                             AND End_of_Loan_Date__c = :Date.today().addDays(60)])
        {
            // create renewal leads
            Lead__c l = new Lead__c(Account__c = p.Opportunity_Name__r.Lead__r.Account__c,
                                    First_Name__c = p.Opportunity_Name__r.Lead__r.First_Name__c,
                                    Last_Name__c = p.Opportunity_Name__r.Lead__r.Last_Name__c,
                                    Date_of_Birth__c = p.Opportunity_Name__r.Lead__r.Date_of_Birth__c,
                                    Home_Phone__c = p.Opportunity_Name__r.Lead__r.Home_Phone__c,
                                    Street__c = p.Opportunity_Name__r.Lead__r.Street__c,
                                    Work_Phone__c = p.Opportunity_Name__r.Lead__r.Work_Phone__c,
                                    Suburb__c = p.Opportunity_Name__r.Lead__r.Suburb__c,
                                    Mobile_Number__c = p.Opportunity_Name__r.Lead__r.Mobile_Number__c,
                                    State__c = p.Opportunity_Name__r.Lead__r.State__c,
                                    Email_Address__c = p.Opportunity_Name__r.Lead__r.Email_Address__c,
                                    Postcode__c = p.Opportunity_Name__r.Lead__r.Postcode__c,  
                                    Finance_Amount__c = p.Opportunity_Name__r.Lead__r.Finance_Amount__c,
                                    Lead_Source__c = 'Car & Finance Renewal',
                                    Status__c = 'New Lead');
            
            // assign to old lead user if they are active, otherwise system generated                        
            if (p.Opportunity_Name__r.Lead__r.Owner.IsActive)
            {
                l.OwnerId = p.Opportunity_Name__r.Lead__r.OwnerId;
            }
            else
            {
                l.OwnerId = sysGen.Id;
            }
            
            leads.add(l);
        }  
        
        insert leads;
        */                           
    }
}