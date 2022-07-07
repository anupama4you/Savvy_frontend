@isTest
public class TestTriggers
{
    public static testMethod void testTrgAccountAfterU()
    {                
        test.starttest();
        Test_DataGeneratorHelper.createAccount();
        user SysGen = [SELECT Id FROM User WHERE Name = 'System Generated' limit 1];   
        Test_DataGeneratorHelper.createLead(); 
        Test_DataGeneratorHelper.tstLead.Status__c = 'New Lead';
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstAccount.OwnerId = SysGen.Id;
        update Test_DataGeneratorHelper.tstAccount;
        
        Application__c app = new Application__c();
        Account acc = new Account ();
        
        acc.FirstName = 'Michelle';
        acc.LastName = 'Odine';
        acc.PersonMobilePhone = '0439904537';
        acc.PersonEmail = 'michelle@diamondstrata.com.au';
        
        app.First_Name__c = 'Michelle';
        app.Last_Name__c = 'Odine';
        app.Mobile_Number__c = '0439 904 537';
        app.Email_Address__c = 'michelle@diamondstrata.com.au';
        
        insert acc;
        insert app;
        
        acc.OwnerId = SysGen.Id;
        
        update acc;
        
        test.stopTest();
    } 
    
    public static testMethod void testTrgTaskBeforeU()
    {
        
        test.startTest();
        Test_DataGeneratorHelper.createLead();
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'New Lead';
        update Test_DataGeneratorHelper.tstLead;
        
        Task t = new Task(WhatId = Test_DataGeneratorHelper.tstLead.Id);
        insert t;
        t.Status = 'Completed';
        
        try
        {
            update t;
        }
        catch(Exception e)
        {       
        }
        
        // set to unresolved lead so all the tasks are closed
        //Test_DataGeneratorHelper.tstLead.Status__c = 'Unresolved Lead';
        Test_DataGeneratorHelper.tstLead.Status__c = 'Closed Lead';
        Test_DataGeneratorHelper.tstLead.Reason_for_closure__c = 'Not Proceeding';
        update Test_DataGeneratorHelper.tstLead;
        test.stopTest();
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 1'; 
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 2';
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 3';
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 4';
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 5';
        update Test_DataGeneratorHelper.tstLead;
        
        Test_DataGeneratorHelper.tstLead.Status__c = 'Attempted Contact 6';
        update Test_DataGeneratorHelper.tstLead;
                
        update t;
        
        t.From_Opportunity_Settled__c = true;
        t.WhatId = null;
        
        try
        {
            update t;
        }
        catch(Exception e)
        {       
        }
        
    }
    
    /*public static testMethod void testTrgOpportunityAfterIU()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createOpportunity();
        
        // set to unresolved opportunity so all the tasks are closed
        Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Unresolved Opportunity';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        
        
        // set to Closed opportunity so all the tasks are closed
        //Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Closed Opportunity';
        //update Test_DataGeneratorHelper.tstOpportunity;
    
        Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Quote Sent';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        // set to unresolved opportunity so all the tasks are closed
        Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Unresolved Opportunity';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        GenerateProductInvoicesExtension gpie = new GenerateProductInvoicesExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
        gpie.Generate();
        
        Test_DataGeneratorHelper.tstOpportunity.Status__c = 'Settled';     
        Test_DataGeneratorHelper.tstOpportunity.Date_Closed_or_Settled__c = Date.today();        
        Test_DataGeneratorHelper.tstOpportunity.Sent_for_Settlement_Date__c = Date.today();        
        update Test_DataGeneratorHelper.tstOpportunity;    
        
        Test.StopTest();

    }*/
    
   public static testMethod void testTrgLeadAfterI()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createAccount();
        
        Lead__c ld = new Lead__c();
        ld.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        ld.First_Name__c = 'tesqdwt';
        ld.Last_Name__c = 'tesdt';
        //ld.status__c = 'Unresolved Lead';
        ld.status__c = 'New Lead';
        ld.Email_Address__c = 'teada@test.com';
        ld.Finance_Amount__c = 1;
        ld.State__c = 'SA';
        insert ld;
        
        Lead__c l = new Lead__c();
        l.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        l.First_Name__c = 'test';
        l.Last_Name__c = 'test';
        l.status__c = 'Attempted Contact 1';
        l.Email_Address__c = 'test7@test.com';
        l.Finance_Amount__c = 1;
        l.State__c = 'SA';
        insert l;
        
        //l.status__c = 'Unresolved Lead';
        l.status__c = 'Closed Lead';
        l.Reason_for_closure__c = 'Not Proceeding';
        update l;
        
        Test.StopTest();
    }
    
    public static testMethod void testTrgSDocAfterI()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createOpportunity();
        SDOC__SDTemplate__c sdTemp = new SDOC__SDTemplate__c();
        sdTemp.Name = 'Preliminary Assessment';
        sdTemp.SDOC__Template_Format__c = 'DOC';
        insert sdTemp;
        
        SDOC__SDoc__c sdoc = new SDOC__SDoc__c();
        sdoc.SDOC__ObjectID__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        sdoc.SDOC__SDTemplate__c = sdTemp.Id;
        insert sdoc;
        
        Test.StopTest();    
    } 
    public static testMethod void trgOptyLenderFieldU()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createOpportunity();
        //recordTypes();
        Product__c tstFinanceProduct1= new Product__c(Opportunity_Name__c = Test_DataGeneratorHelper.tstOpportunity.Id,
                                            Lender__c = 'Finance One',
                                            End_of_Loan_Date__c = Date.today().addDays(60),                                            
                                            DOF__c = 1,
                                            Brokerage__c = 1);
        insert tstFinanceProduct1;
        
        tstFinanceProduct1.Lender__c = 'Pepper';
        
        update tstFinanceProduct1;
        
        Test.StopTest();    
    }
    /*public static testMethod void testTrgOpportunityAfterI()
    {

        Test.StartTest();
        Test_DataGeneratorHelper.createAccount();
        Test_DataGeneratorHelper.createLead();
        
        
        Custom_Opportunity__c opp1 = new Custom_Opportunity__c();
        opp1.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        opp1.Lead__c = Test_DataGeneratorHelper.tstLead.Id;
        opp1.Status__c = 'Unresolved Opportunity';
        insert opp1;
        
        Custom_Opportunity__c opp = new Custom_Opportunity__c();
        opp.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        opp.Lead__c = Test_DataGeneratorHelper.tstLead.Id;
        opp.Status__c = 'Quote Sent';
        insert opp;
        
        opp.status__c = 'Unresolved Opportunity';
        update opp;
        
        Custom_Opportunity__c opp2 = new Custom_Opportunity__c();
        opp2.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        opp2.Lead__c = Test_DataGeneratorHelper.tstLead.Id;
        opp2.Status__c = 'Invoice Received';
        insert opp2;
        
        opp.status__c = 'Quote sent';
        update opp;
        
        opp.status__c = 'Awaiting Further Information';
        update opp;
        Test.StopTest();
        
        
        
        
    }*/
    
    public static testMethod void testTrgOppBefore()
    {                
        test.starttest();
        Test_DataGeneratorHelper.createAccount();
        user SysGen = [SELECT Id FROM User WHERE Name = 'System Generated' limit 1];

        Test_DataGeneratorHelper.tstAccount.OwnerId = SysGen.Id;
        update Test_DataGeneratorHelper.tstAccount;
        
        Custom_Opportunity__c opp2 = new Custom_Opportunity__c();
        opp2.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        opp2.Status__c = 'Invoice Received';
        
        insert opp2;
        
        opp2.Status__c='settled';
        opp2.Date_Closed_or_Settled__c = Date.today();        
        opp2.Sent_for_Settlement_Date__c = Date.today();
        update opp2;
        
        //opp2.VD_Status__c = 'Invoice Requested';
        //update opp2;
        
        Custom_Opportunity__c opp3 = new Custom_Opportunity__c();
        opp3.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        opp3.Status__c = 'Documents Sent';
        insert opp3;
        
        opp3.status__c = 'Documents Sent';
        update opp3;
        
        opp3.status__c = 'Sent to Lender';
        update opp3;
        
        //opp3.VD_Status__c = 'Sent back to Finance Consultant';
        //update opp3;
        
        //Test_DataGeneratorHelper.createOpportunity();
        //Test_DataGeneratorHelper.tstOpportunity.VD_Status__c = 'Invoice Requested';
        //update Test_DataGeneratorHelper.tstOpportunity;
        
        test.stopTest();
        
        opp3.status__c = 'Settlement Rejected';
        update opp3;
        
    } 
    
    public static testMethod void trgLeadAfterU()
    {
        test.startTest();
        Test_DataGeneratorHelper.createAccount();
        
        Lead__c lds = new Lead__c();
        lds.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        lds.First_Name__c = 'Wall';
        lds.Last_Name__c = 'Test';
        lds.status__c = 'Attempted Contact 1';
        lds.Mobile_Number__c = '1234';
        lds.Email_Address__c = 'wall@test.com';
        lds.Finance_Amount__c = 1;
        lds.State__c = 'SA';
        insert lds;
        
        Lead__c lds2 = new Lead__c();
        lds2.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        lds2.First_Name__c = 'Wall2';
        lds2.Last_Name__c = 'Test2';
        lds2.status__c = 'New Lead';
        lds2.Mobile_Number__c = '1234';
        lds2.Email_Address__c = 'wall@test.com';
        lds2.Finance_Amount__c = 1;
        lds2.State__c = 'SA';
        insert lds2;
        
        lds2.status__c = 'New Lead';
        update lds2;
        test.stopTest();   
    }
    
    public static testMethod void trgAppBeforeI() {
        test.startTest();
        
        Application__c app = new Application__c();
        Account acc = new Account ();
        
        user SysGen = [SELECT Id FROM User WHERE Name = 'System Generated' limit 1];
        
        acc.FirstName = 'Michelle';
        acc.LastName = 'Odine';
        acc.PersonMobilePhone = '0439904537';
        acc.PersonEmail = 'michelle@diamondstrata.com.au';
        acc.OwnerId = SysGen.Id;
        
        app.First_Name__c = 'Michelle';
        app.Last_Name__c = 'Odine';
        app.Mobile_Number__c = '0439 904 537';
        app.Email_Address__c = 'michelle@diamondstrata.com.au';
        app.Street_Address__c = '123 Test Street';
        app.Suburb__c = 'Test Suburb';
        app.Postcode__c = '5678';
        app.Business_ABN__c = '123456789';
        
        insert acc;
        insert app;
        
        test.stopTest();
    }
    
    public static testMethod void trgAppAfterI() {
        test.startTest();
        
        Test_DataGeneratorHelper.createOpportunity();
        Application__c app = new Application__c();
        
        Test_DataGeneratorHelper.tstOpportunity.Mobile_Number__c = '0439904537';
        Test_DataGeneratorHelper.tstOpportunity.Email_Address__c = 'bulk21@g.com';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        app.First_Name__c = 'Michelle';
        app.Last_Name__c = 'Odine';
        app.Mobile_Number__c = '0439904537';
        app.Email_Address__c = 'bulk21@g.com';
        app.No_of_Dependants_1__c = 2;
        app.Do_you_own_a_property__c = 'Yes';
        app.Mode_of_Employment_1__c = 'Full Time';
        app.No_of_Dependants_2__c = 0;
        app.Current_Occupation_1__c = 'Developer';
        app.Net_Income_1__c = 5000;
        app.Partner_Income__c = 4000;
        //app.Loan_Type_1__c = 'Mortgage';
        //app.Loans_Monthly_Payments_1__c = 3000;
        //app.Loan_Type_2__c = 'Car Loan';
        //app.Loans_Monthly_Payments_2__c = 1500;
        //app.Loan_Type_3__c = '';
        //app.Loans_Monthly_Payments_3__c = 0;
        app.Rent_per_month_1__c = 2000;
        app.Rent_per_month_2__c = 0;
        app.Repayment_Regularity__c = 'Month';
        app.Preferred_Repayment__c = 3200;
        app.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        
        insert app;
        
        test.stopTest(); 
    }
    
    /*public static testMethod void trgAppBeforeU() {
        test.startTest();
        
        test.stopTest();
    }*/
    
    public static testMethod void trgAppAfterU() {
        test.startTest();
        
        Test_DataGeneratorHelper.createOpportunity();
        Application__c app = new Application__c();
        
        Test_DataGeneratorHelper.tstOpportunity.Mobile_Number__c = '0439904537';
        Test_DataGeneratorHelper.tstOpportunity.Email_Address__c = 'bulk21@g.com';
        update Test_DataGeneratorHelper.tstOpportunity;
        
        app.First_Name__c = 'Michelle';
        app.Last_Name__c = 'Odine';
        app.Mobile_Number__c = '0439904537';
        app.Email_Address__c = 'bulk21@g.com';
        app.No_of_Dependants_1__c = 2;
        app.Do_you_own_a_property__c = 'Yes';
        app.Mode_of_Employment_1__c = 'Full Time';
        app.No_of_Dependants_2__c = 0;
        app.Current_Occupation_1__c = 'Developer';
        app.Net_Income_1__c = 5000;
        app.Partner_Income__c = 4000;
        //app.Loan_Type_1__c = 'Mortgage';
        //app.Loans_Monthly_Payments_1__c = 3000;
        //app.Loan_Type_2__c = 'Car Loan';
        //app.Loans_Monthly_Payments_2__c = 1500;
        //app.Loan_Type_3__c = '';
        //app.Loans_Monthly_Payments_3__c = 0;
        app.Rent_per_month_1__c = 2000;
        app.Rent_per_month_2__c = 0;
        app.Repayment_Regularity__c = 'Month';
        app.Preferred_Repayment__c = 3200;
        app.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        
        insert app;
        
        app.First_Name_2__c = 'Adam';
        app.Last_Name_2__c = 'Odine';
        app.No_of_Dependants_1__c = 3;
        app.Do_you_own_a_property__c = 'Yes';
        app.Mode_of_Employment_1__c = 'Full Time';
        app.Mode_of_Employment_2__c = 'Full Time';
        app.No_of_Dependants_2__c = 0;
        app.Current_Occupation_1__c = 'Developer';
        app.Current_Occupation_1__c = 'Engineer';
        app.Net_Income_1__c = 5000;
        app.Net_Income_2__c = 4000;
        //app.Loan_Type_1__c = 'Mortgage';
        //app.Loans_Monthly_Payments_1__c = 3000;
        //app.Loan_Type_2__c = 'Car Loan';
        //app.Loans_Monthly_Payments_2__c = 1500;
        //app.Loan_Type_2__c = '';
        //app.Loans_Monthly_Payments_2__c = 0;
        app.Rent_per_month_1__c = 2000;
        app.Rent_per_month_2__c = 0;
        app.Repayment_Regularity__c = 'Month';
        app.Preferred_Repayment__c = 3200;
        
        update app;
        
        test.stopTest();
    }
         
}