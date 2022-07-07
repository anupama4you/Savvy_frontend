@isTest(SeeAllData=true)
public class TestEmailSender {
    Static Custom_Opportunity__c VDOpp1 = new Custom_Opportunity__c ();
    static Custom_Opportunity__c VDOpp2 = new Custom_Opportunity__c ();
    static List <Attachment> invoices = new List <Attachment> ();
    static List <Attachment> agreements = new List <Attachment> ();
    static List <Attachment> workSheets = new List <Attachment> ();
    static List <Attachment> driverLicenses = new List <Attachment> ();
    static User VDSale = new User ();
    static User VDSettle = new User ();
    static List <Application__c> appForOpp = new List <Application__c> ();
    public static Map < String,	id > RecordTypes;
    public static List<User> consultants = null;

    public static void init(){
        consultants = [SELECT user.id, user.Email, user.FirstName, user.LastName, user.profile.name FROM User, user.profile WHERE profile.name = 'Sales Consultant'];
        //List <User> consultants = [SELECT user.id, user.Email, user.FirstName, user.LastName, user.profile.name FROM User, user.profile WHERE profile.name = 'Asset Finance - Sales Consultant'];
        List <User> VDSales = [SELECT user.id, user.Email, user.FirstName, user.LastName, user.profile.name FROM User, user.profile WHERE profile.name = 'Vehicles Direct - Sales'];
        List <User> VDSettles = [SELECT user.id, user.Email, user.FirstName, user.LastName, user.profile.name FROM User, user.profile WHERE profile.name = 'Vehicles Direct - Settlements'];

        Custom_Opportunity__c emailOpp1 = new Custom_Opportunity__c ();
        Custom_Opportunity__c emailOpp2 = new Custom_Opportunity__c ();
        
        emailOpp1.Owner__c = consultants.get(0).id;
        emailOpp1.Name = 'test1';
        emailOpp2.Owner__c = consultants.get(0).id;
        emailOpp2.Name = 'test2';
        emailOpp1.VD_Owner__c = VDSales.get(0).id;
        emailOpp2.VD_Owner__c = VDSettles.get(0).id;
        
        emailOpp1.VD_Reason_for_closure__c = 'reason';
        emailOpp2.VD_Reason_for_closure__c = 'reason';

        VDSale = VDSales.get(0);
        VDSettle = VDSettles.get(0);
        
        insert emailOpp1;
        insert emailOpp2;
        update emailOpp1;
        update emailOpp2;
        
        system.debug('The emailOpp1 owner email: ' + emailOpp1.Owner_Email__c);
        
        Attachment invoice = new Attachment ();
        Attachment agreement = new Attachment ();
        Attachment driverLicense = new Attachment ();
        Attachment worksheet = new Attachment ();
        
        //Required_Document__c driverl = new Required_Document__c ();
        //driverl.Opportunity__c = emailOpp1.id;
        //driverl.Type__c = 'Drivers License (Front & Back)';
        //insert driverl;
        
        //driverLicenses = [SELECT id,Name,body,ContentType FROM Attachment WHERE id =: driverl.id];
        
        invoice.Name = 'ITI';
        agreement.Name = 'Agreement';
        driverLicense.Name = 'Drivers License (Front & Back)';
        worksheet.Name = 'worksheet';
        
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        
        invoice.body = bodyBlob;
        agreement.body = bodyBlob;
        driverLicense.body = bodyBlob;
        worksheet.body = bodyBlob;
        
        invoice.ParentId = emailOpp2.id;
        agreement.ParentId = emailOpp2.id;
        driverLicense.ParentId = emailOpp1.id;
        worksheet.ParentId = emailOpp1.id;
        
        insert invoice;
        insert agreement;
        insert driverLicense;
        insert worksheet;
        
        invoices.add(invoice);
        agreements.add(agreement);
        driverLicenses.add(driverLicense);
        worksheets.add(worksheet);
        
        VDOpp1 = [SELECT id,Name,owner_email__c,VD_Reason_for_closure__c, Owner_Name__c, CreatedById, Application_AssetDetail__r.PPSR_Proxy_Message__c 
          FROM Custom_Opportunity__c WHERE id =: emailOpp1.id];
        System.debug('VDOpp1 owner email is: ' + VDOpp1.Owner_Email__c + '|' + VDOpp1.VD_Reason_for_closure__c);
        VDOpp2 = [SELECT id,Name,owner_email__c FROM Custom_Opportunity__c WHERE id =: emailOpp2.id];
        
        Test_DataGeneratorHelper.createAccount();

        Application__c app = new Application__c ();
        app.Name = 'Test Testing';
        app.First_Name__c = 'Test';
        app.Last_Name__c = 'Testing';
        app.Mobile_Number__c = '0427383238';
        app.Email_Address__c = 'test@testing.com';
        app.No_of_Dependants_1__c = 0;
        app.Finance_Amount__c = 10000;
        app.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        insert app;
        
        appForOpp.add(app);
    }

    public static testmethod void EmailSenderTest () {
        init ();
        Test.startTest();
        EmailSender.sendEmailToOppOwner(invoices, VDOpp2);
        EmailSender.sendEmailToPreVD(VDOpp2, VDSale);
        EmailSender.sendEmailToVDSet(workSheets, VDSettle, VDOpp1);
        EmailSender.sendEmailVDFailure(VDOpp1);
        EmailSender.sendEmailAppOppNoAcc(appForOpp);
        //EmailSender.sendEmailAppAccNoOpp(appForOpp.get(0));

        //Lelo      2016-11-09
        EmailSender.sendEmailToVDSent_v2(workSheets, new String[] {'lelo@l.com'}, VDOpp1);
        EmailSender.sendEmailToConsultantVDStatus(VDOpp1, new String[] {'lelo@l.com'}, 'erere', 'dfdfdfdfd');
        
        //Lelo
        EmailSender.sendEmailAppAccNoOpp(appForOpp.get(0));

        List<String> toemails = new List<String>();
        toemails.add('lelo@l.com');
        EmailSender.sendEmailToVDSalesBack(toemails, VDOpp1);
        EmailSender.sendEmailToVDFormalApproval(toemails, VDOpp1);
        // no add more email test
        Test.stopTest();
    }

    public static testmethod void EmailSenderTest_2 () {
        init ();
        Test.startTest();
        List<String> toemails = new List<String>();
        toemails.add('lelo@l.com');
        System.debug('@@VDOpp1: ' + JSON.serializePretty(VDOpp1));
        EmailSender.sendEmailAppNotificationUnfinished(VDOpp1, toemails);
        //PPSR
        EmailSender.sendEmailPPSRNotificationError(VDOpp1, 'Subject here!', 'Body text here!', toemails);
        EmailSender.sendEmailPPSRNotification(VDOpp1, toemails);

        //
        List<Lead__c> leads = [
          Select Id, Name, Mobile_Number__c, Email_Address__c From Lead__c 
          Where  CreatedDate = LAST_N_DAYS:3 Order By CreatedDate DESC Limit 1
        ];
        if (!leads.isEmpty()) {
          EmailSender.leadFlowNotification(leads.get(0), VDSale);
        }
        Test.stopTest();
    }

    //Lelo      2017-07-10
    @isTest static void testSendPresentation() {
        Test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Email_Address__c = 'salesforce.dev@savvy.com.au';
        if (o == null) {
            System.debug('Opp testing >> is null');    
        } else {
            System.debug('Opp testing >> ' + o.Name  + '> ' + o.Application__c);
        }
        EmailSender.sendCustomerInsurancePresentation(o, 'dfdfdfdfd');
        Test.stopTest();
    }

    //Lelo      2017-07-20
    @isTest static void testSendQuotingEmailToCustomer() {
        Test.startTest();
        Test_DataGeneratorHelper.applicationQuoting(true);
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        quoting.Name = 'Finance One';
        quoting.Risk_Fee__c = 1000.00;
        update quoting;
        Test_DataGeneratorHelper.reloadOpportunity();
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        o.Email_Address__c = 'salesforce.dev@savvy.com.au';
        //Create results
        Application_Quoting_Result__c rst = new Application_Quoting_Result__c();
        rst.Result_Type__c = QuotingCalculation.CALC_QUOTING;
        rst.Rental__c = 150;
        rst.Monthly_Payment__c = 450;
        rst.Application_Quoting__c = quoting.Id;
        insert rst;

        rst = new Application_Quoting_Result__c();
        rst.Result_Type__c = QuotingCalculation.CALC_PROTECTED;
        rst.Rental__c = 150;
        rst.Monthly_Payment__c = 450;
        rst.Application_Quoting__c = quoting.Id;
        insert rst;
        
        EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(o, quoting);
        EmailSender.sendQuotingEmailToCustomer(param);
        Test.stopTest();
    }

    //Lelo      2018-03-19
    @isTest static void testSendEmailPresentationFinished() {
        Test.startTest();
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        update quoting;
        EmailSender.sendEmailPresentationFinished(quote);
    }
    
    @isTest static void testsendEmailAppNotificationForOpportunityClosed() {
        Test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        EmailSender.sendEmailAppNotificationForOpportunityClosed(Test_DataGeneratorHelper.tstOpportunity);
    }

    public static void recordTypes() {

		RecordTypes = new Map < String,
		Id > ();
		for (RecordType rt: [SELECT Id, Name
		FROM RecordType]) {
			RecordTypes.put(rt.Name, rt.Id);
		}
	}

    @isTest static void testPreApprovedNotification() {
        
        recordTypes();
        Account a = new Account(
            RecordTypeId = recordTypes.get('Person Account'),
            FirstName = 'f',
            LastName = 'l'
        );
        insert a;
        
        Custom_Opportunity__c o = new Custom_Opportunity__c(
            Name = 'n',
            Status__c = 's',
            First_Name__c = 'f',
            Last_Name__c = 'l',
            Mobile_Number__c = '1',
            Email_Address__c = 'e@e.com',
            Account__c = a.Id
        );
        
        insert o;
        Custom_Opportunity__c opp =[
          SELECT 
            Name, Owner_Name__c, Owner_Phone__c, 
            Owner_Mobile__c, Owner_Email__c, 
            First_Name__c, Email_Address__c,
            OwnerId, Partner_Is_External__c 
          FROM Custom_Opportunity__c where Id =: o.Id
        ];

        Cloud_Documents__c d = new Cloud_Documents__c();
        d.Document_Type__c='Quoting Calculation (Pre-approval)';
        d.Custom_Opportunity__c = o.Id;
        
        insert d;

        Parameters_Service__c param =  Parameters_Service__c.getInstance('OppPreApprovedCustomerEmail');
        param.value__c = 'OFF';
        update param;
        param =  Parameters_Service__c.getInstance('OppPreApprovedLenderEmail');
        param.value__c = 'OFF';
        update param;

        EmailSender.sendEmailOpportunityPreApproved(opp);
        EmailSender.sendEmailOpportunityPreApprovedLiberty(opp.Id);
        
        param =  Parameters_Service__c.getInstance('OppPreApprovedCustomerEmail');
        param.value__c = 'ON';
        update param;
        param =  Parameters_Service__c.getInstance('OppPreApprovedLenderEmail');
        param.value__c = 'ON';
        update param;
        EmailSender.sendEmailOpportunityPreApproved(opp);
        EmailSender.sendEmailOpportunityPreApprovedLiberty(opp.Id);
    }

    @isTest static void testSendReqDocsNotification() {
      Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
      Test.startTest();
      Set<Id> oppIds = new Set<Id>();
      oppIds.add(o.Id);
      EmailSender.sendRequiredDocNotification(oppIds);
    }

    @isTest static void testSendLeadFlowNotification() {
      Test_DataGeneratorHelper.createLead();
      lead__c lead = Test_DataGeneratorHelper.tstLead;
      lead.Name = 'Random Lead';
      consultants = [SELECT user.id, user.Email, user.FirstName, user.LastName, user.profile.name FROM User, user.profile WHERE profile.name = 'Sales Consultant'];
      User u = consultants.get(0);
      Test.startTest();
      EmailSender.leadFlowNotification(lead, u);
      Test.stopTest();
    }
}