@isTest
public class TestPartnerCommunityController {

  static {
    loadSettings();
  }

  @isTest
  static void testRecentItems() {
    Test.startTest();
    PartnerCommunityController.getRecentItems(10);
    Test.stopTest();
  }

  @isTest
  static void testLeadMethods() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      List<Lead__c> leads = buildLeads();
      PartnerCommunityController.getRecentItems(10);
      PartnerCommunityController.getRecentLeads(10);
      PartnerCommunityController.getUnassignedLeadList();
      // Convert
      Lead__c lead = leads.get(0);
      Custom_Opportunity__c opp = new Custom_Opportunity__c();
      opp.Name = lead.Name;
      opp.First_Name__c = lead.First_Name__c;
      opp.Last_Name__c = lead.Last_Name__c;
      opp.Email_Address__c = lead.Email_Address__c;
      opp.Mobile_Number__c = lead.Mobile_Number__c;
      opp.Lead__c = lead.Id;
      PartnerCommunityController.convertToOpportunity(lead.Id, opp);
      // Default Owner
      PartnerCommunityController.getPartnerDefaultOwner(
        SOQLSingletonQueries.recs().myAccountId
      );
    }
    Test.stopTest();
  }

  @isTest
  static void testCloudDocMethods() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      try {
        PartnerCommunityController.uploadFileOrFail(null, 'myfile.txt', 'plain/txt', 'file content here');
      } catch (GenericException e) {
        System.assert(e.getMessage().containsIgnoreCase('not found') == true, 'Task exception validated');
      }
      Test_DataGeneratorHelper.buildCarApp(true);
      Test_DataGeneratorHelper.createQuoting();
      Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
      PartnerCommunityController.uploadFileOrFail(o.Id, 'myfile1.txt', 'plain/txt', 'file content here');
      PartnerCommunityController.uploadFileOrFail(o.Id, 'myfile2.txt', 'plain/txt', Blob.valueOf('Hola!'));

      List<Cloud_Documents__c> docs = PartnerCommunityController.listCloudDocuments(o.Id);
      System.assert(!docs.isEmpty(), 'Document not uploaded');
      Cloud_Documents__c doc = docs.get(0);
      PartnerCommunityController.signCloudDocument(doc.Id);
      PartnerCommunityController.deleteCloudDocument(doc.Id);

      // PartnerCommunityController.getUnassignedLeadList();
    }
    Test.stopTest();
  }

  @isTest
  static void testOppMethods() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      Test_DataGeneratorHelper.buildCarApp(true);
      Test_DataGeneratorHelper.createQuoting();
      Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
      PartnerCommunityController.getPipelineOpportunities();
      // Quoting
      Application_Quoting__c quoting = PartnerCommunityController.getOppQuoting(o.Id, new List<String>{'Name','Id'});
      // Opp Todo
      PartnerCommunityController.getOppTodoListStatuses(o.Id);

      // clone Opportunity
      PartnerCommunityController.cloneOpportunity(o.Id);
      PartnerCommunityController.cloneOpportunity(null);
      // deleting an opportunity
      Custom_Opportunity__c opp2 = Test_DataGeneratorHelper.buildOpp(true);
      Id opp2Id = opp2.Id;
      delete opp2;
      try {
        PartnerCommunityController.cloneOpportunity(opp2Id);
      } catch (GenericException e) {}

    }
    Test.stopTest();
  }

  @isTest
  static void testTaskMethods() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      Lead__c lead = buildLead();
      PartnerCommunityController.MyTask t = new PartnerCommunityController.MyTask();
      t.whatId = lead.Id;
      t.subject = 'Call';
      t.comments = 'xyz';
      t.dueDate = Date.today() + 10;
      t.priority = 'Normal';
      t.status = 'Completed';
      Id taskId = PartnerCommunityController.createTask(t);
      System.assert(taskId != null, 'Task not created!');
      // Error validation
      try {
        taskId = PartnerCommunityController.createTask(null);
      } catch (GenericException e) {
        System.assert(e.getMessage().containsIgnoreCase('not found') == true, 'Task exception validated');
      }
    }
    Test.stopTest();
  }

  @isTest
  static void testPartnerOwnerMethods() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Test.startTest();
    System.runAs(pu) {
      
      List<Account> accs = new List<Account>{ 
        Test_DataGeneratorHelper.buildAcc()
      };
      PartnerCommunityController.dataCheckerAccounts(accs);

      List<Custom_Opportunity__c> opps = new List<Custom_Opportunity__c>{ 
        Test_DataGeneratorHelper.buildOpp(true)
      };
      PartnerCommunityController.dataCheckerOpps(opps);

      List<Application__c> apps = new List<Application__c>{ 
        Test_DataGeneratorHelper.buildCarApp(true)
      };
      PartnerCommunityController.dataCheckerApplications(apps);

      List<Lead__c> leads = buildLeads();
      PartnerCommunityController.dataCheckerLeads(leads);

    }
    Test.stopTest();
  }


  private static void loadSettings() {
    System.debug('Creating Parameter Settings...');
    List<Parameters_Service__c> settings = new List<Parameters_Service__c>();
    Parameters_Service__c a = new Parameters_Service__c();
    a.Name = 'AmazonS3PartnerBucket';
    a.value__c = 'my-test-bucket';
    settings.add(a);

    a = new Parameters_Service__c();
    a.Name = 'AmazonS3PartnerFolder';
    a.value__c = 'my-test-folder';
    settings.add(a);

    // S3 params
    a = new Parameters_Service__c();
    a.Name = 'AmazonS3AccessKey';
    a.value__c = 'aws-key-here';
    settings.add(a);

    a = new Parameters_Service__c();
    a.Name = 'AmazonS3SecretKey';
    a.value__c = 'aws-secret-here';
    settings.add(a);

    a = new Parameters_Service__c();
    a.Name = 'AmazonS3DefaultBucket';
    a.value__c = 'default-bucket';
    settings.add(a);

    insert settings;
  }

  // private static User buildPartnerUser() {
  //   Id recType = SOQLSingletonQueries.recs()
  //     .recordTypes.get('Business Account');
  //   Account a = new Account(
  //     Name = 'Test Business Account',
  //     S3_Folder__c = 'testfolder',
  //     RecordTypeId = recType
  //   );
  //   insert a;
  //   Contact c = new Contact(LastName = 'Montoya');
  //   c.AccountId = a.Id;
  //   insert c;
  //   String username = 'newone-123456789@noemail.com';
  //   System.runAs(new User(Id = UserInfo.getUserId())) {
  //     // UserRole r = [select id from UserRole where name = 'CEO'];
  //     // UserLicense licence = [SELECT Id FROM UserLicense where name ='Partner Community'];

  //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Broker Community User'];
  //     User comUser = new User(
  //       alias = 'test123',
  //       email = 'test123@noemail.com',
  //       emailencodingkey = 'UTF-8',
  //       lastname = 'Testing',
  //       languagelocalekey = 'en_US',
  //       localesidkey = 'en_US',
  //       profileid = p.Id,
  //       country = 'United States',
  //       IsActive = true,
  //       contactId = c.Id,
  //       timezonesidkey = 'America/Los_Angeles',
  //       username = username
  //     );
  //     insert comuser;
  //   }
  //   User u = [SELECT id FROM user WHERE username = :username LIMIT 1];
  //   return u;
  // }

  private static Lead__c buildLead() {
    Lead__c a = new Lead__c(
			First_Name__c = 'Leo', 
			Last_Name__c = 'Gills', 
			Finance_Amount__c = 15000.0, 
			Mobile_Number__c = '0477000123',
			Email_Address__c = 'lg@lg-devcompany-34546435345.com', 
			Status__c = 'New Lead',
			Loan_type__c = 'Car Loan',
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
    insert a;
    return a;
  }

  private static List<Lead__c> buildLeads() {
    List<Lead__c> leads = new List<Lead__c>();
    Lead__c a = new Lead__c(
			First_Name__c = 'Leo', 
			Last_Name__c = 'Gills', 
			Finance_Amount__c = 15000.0, 
			Mobile_Number__c = '0477000123',
			Email_Address__c = 'lg@lg-devcompany-34546435345.com', 
			Status__c = 'New Lead',
			Loan_type__c = 'Car Loan',
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
    leads.add(a);

    a = new Lead__c(
			First_Name__c = 'Finn', 
			Last_Name__c = 'Soler', 
			Finance_Amount__c = 12000.0, 
			Mobile_Number__c = '0477000124',
			Email_Address__c = 'fs@lg-devcompany-34546435345.com', 
			Status__c = 'New Lead',
			Loan_type__c = 'Car Loan',
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
    leads.add(a);

    a = new Lead__c(
			First_Name__c = 'Mary', 
			Last_Name__c = 'Lee', 
			Finance_Amount__c = 23000.0, 
			Mobile_Number__c = '0477000125',
			Email_Address__c = 'ml@lg-devcompany-34546435345.com', 
			Status__c = 'New Lead',
			Loan_type__c = 'Car Loan',
			Credit_History__c = 'Excellent',
			Employment_Status__c = 'Full Time');
    leads.add(a);
    insert leads;
    return leads;
  }
}