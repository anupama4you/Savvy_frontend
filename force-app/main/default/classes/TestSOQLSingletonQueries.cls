@isTest
public class TestSOQLSingletonQueries {
  
  @isTest
  static void testInstanceMethods() {
    Test.startTest();
    User usr = SOQLSingletonQueries.recs().sysGenUser;
    usr = SOQLSingletonQueries.recs().sysAdminUser;
    Boolean bl = SOQLSingletonQueries.recs().isSavvyAdmin();

    Map<Id, User> usrmap = SOQLSingletonQueries.recs().usersIdMap;
    usrmap = SOQLSingletonQueries.recs().usersIdsMap;

    List<User> users = SOQLSingletonQueries.recs().adminOrDirectTLUsers;
    users = SOQLSingletonQueries.recs().usersByIds;

    Set<Id> ids = SOQLSingletonQueries.recs().settlementUserIds;
    ids = SOQLSingletonQueries.recs().salesConsultansProfiles;
    ids = SOQLSingletonQueries.recs().activeSalesConsultans;
    ids = SOQLSingletonQueries.recs().lenderLoginConsultans;
    
    Group g = SOQLSingletonQueries.recs().getHomeLoanQueue;
    g = SOQLSingletonQueries.recs().savvyTeamGroup;

    List<UserRole> roles = SOQLSingletonQueries.recs().getCurrentUserRoles;
    List<EmailTemplate> etmpls = SOQLSingletonQueries.recs().getSettledEmailTemplates;
    
    Map<Id, Custom_Opportunity__c> omap = SOQLSingletonQueries.recs().opportunityProdFinanceMap;
    List<Custom_Opportunity__c> opps = SOQLSingletonQueries.recs().opportunitiesByLeadIds;
    opps = SOQLSingletonQueries.recs().opportunitiesByAppIds;
    opps = SOQLSingletonQueries.recs().opportunitiesByAccountIds;
    opps = SOQLSingletonQueries.recs().opportunitiesByEmailAddresses;

    Map<Id, List<Custom_Opportunity__History>> ohismap = SOQLSingletonQueries.recs().opportunityHistoryAttachMap;

    List<Product__c> prods = SOQLSingletonQueries.recs().financeProductsByOppIds;
    prods = SOQLSingletonQueries.recs().productsByOppIds;
    List<Task> tasks = SOQLSingletonQueries.recs().uncompletedTasksByOppIds;
    tasks = SOQLSingletonQueries.recs().uncompletedTasksByLeadIds;
    
    Map<Id, Lead__c> leadmap = SOQLSingletonQueries.recs().leadsIdMap;
    List<Lead__c> leads = SOQLSingletonQueries.recs().leadsByAccountIds;
    leads = SOQLSingletonQueries.recs().becomeOpptyLeadsByAccountIds;
    leads = SOQLSingletonQueries.recs().leadsByEmailsAndMobileNums;
    leads = SOQLSingletonQueries.recs().leadsByEmailsAndMobileNumsSales;

    List<Lead__Share> leadShares = SOQLSingletonQueries.recs().leadSharesByLeadIds;
    List<AccountShare> accShares = SOQLSingletonQueries.recs().accountSharesByAccountIds;
    Map<Id, Account> accmap = SOQLSingletonQueries.recs().accountsIdMap;
    accmap = SOQLSingletonQueries.recs().settledAccountsIdMap;
    List<Account> accs = SOQLSingletonQueries.recs().accountsByPersonEmails;
    accs = SOQLSingletonQueries.recs().accountsByPersonMobilePhones;

    Map<Id, Application__c> appmap = SOQLSingletonQueries.recs().applicationsIdMap;
    List<Application__c> apps = SOQLSingletonQueries.recs().applicationsByAccountIds;

    List<Cloud_Documents__c> docs = SOQLSingletonQueries.recs().cloudDocsByOppIds;

    Map<Id, List<Attachment>> attsmap = SOQLSingletonQueries.recs().opportunityWorksheetAttachMap;
    attsmap = SOQLSingletonQueries.recs().opportunityDealerAttachMap;
    List<Attachment> atts = SOQLSingletonQueries.recs().attachmentsByOppIds;

    Map<Id, Call_Reminder__c> remimap = SOQLSingletonQueries.recs().callRemindersByOppIds;

    Map<String,Id> rectypes = SOQLSingletonQueries.recs().recordTypes;

    bl = SOQLSingletonQueries.recs().isBrokerPartnerUser;
    Contact c = SOQLSingletonQueries.recs().myContact;
    Id accId = SOQLSingletonQueries.recs().myAccountId;
    bl = SOQLSingletonQueries.recs().isFranchised;
    Account acc = SOQLSingletonQueries.recs().myAccount;
    
    List<User> fu = SOQLSingletonQueries.recs().franchisedCounsultantList;

    Test.stopTest();
  }

  @isTest
  static void testVDfunctions() {
    Test.startTest();
    Profile p = SOQLSingletonQueries.recs().getVDProfile;
    List<User> users = SOQLSingletonQueries.recs().vdUserByProfileId;
    Map<Id, Integer> idmap = SOQLSingletonQueries.recs().vdOwnerOpportunityCountMap;
    Test.stopTest();
  }

  @isTest
  static void testStaticMethods() {
    Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    Test_DataGeneratorHelper.createLead();
    Lead__c lead = Test_DataGeneratorHelper.tstLead;
    Account acc = Test_DataGeneratorHelper.tstAccount;
    
    Test.startTest();
    
    Set<Id> oppIdSet = new Set<Id>{o.Id};
    Set<Id> leadIdSet = new Set<Id>{lead.Id};
    Set<Id> accIdSet = new Set<Id>{acc.Id};
    Set<Id> appIdSet = new Set<Id>{app.Id};

    Set<String> emailSet = new Set<String> {'test@savvy.com.au'};
    Set<String> mobileSet = new Set<String> {'0460000000'};
    
    SOQLSingletonQueries.setProfId(UserInfo.getProfileId());
    SOQLSingletonQueries.setUserId(UserInfo.getUserId());
    SOQLSingletonQueries.setUserIds(new Set<Id> {UserInfo.getUserId()});
    SOQLSingletonQueries.setPersonEmails(emailSet);
    SOQLSingletonQueries.setEmailAddresses(emailSet);
    
    SOQLSingletonQueries.setEmailAddressesAndMobileNums(emailSet, mobileSet);
    SOQLSingletonQueries.getOpportunitiesByPhoneOrEmail(mobileSet, emailSet);
    SOQLSingletonQueries.getLeadsByPhoneOrEmail(mobileSet, emailSet);

    SOQLSingletonQueries.setPersonMobilePhones(mobileSet);

    SOQLSingletonQueries.setOppIds(oppIdSet);
    SOQLSingletonQueries.setLeadIds(leadIdSet);
    SOQLSingletonQueries.setAccountIds(accIdSet);
    SOQLSingletonQueries.setApplicationIds(appIdSet);
    SOQLSingletonQueries.getOpportunitiesByAccount(accIdSet);
    SOQLSingletonQueries.getLeadsByAccount(accIdSet);
    SOQLSingletonQueries.getMostRecentOpportunityOwnersByAccount(accIdSet);

    SOQLSingletonQueries.isActiveUser(UserInfo.getUserId());
    SOQLSingletonQueries.isActiveConsultantUser(UserInfo.getUserId());
    
    SOQLSingletonQueries.searchAccounts(lead);
    SOQLSingletonQueries.getLeadDuplicateTimeParam();

    SOQLSingletonQueries.getCurrentUserProfileName();
    SOQLSingletonQueries.isHomeLoanUser();
    SOQLSingletonQueries.isSalesConsultant3();
    SOQLSingletonQueries.isReportManager(UserInfo.getUserId());
    SOQLSingletonQueries.getGroupMembers('Sales Consultants');
    SOQLSingletonQueries.getUserById(UserInfo.getUserId());
    SOQLSingletonQueries.isGroupMemberOf('Sales Consultants');

    SOQLSingletonQueries.getMostRecentOpportunityByEmail(app.Email_Address__c);
    SOQLSingletonQueries.getMostRecentOpportunityByEmail(null);

    SOQLSingletonQueries.getPartnerDefaultOwner(acc.Id);

    Set<Id> ids = null;
    SOQLSingletonQueries.getPartnerOwnerAccounts(ids);
    ids = new Set<Id>();
    SOQLSingletonQueries.getPartnerOwnerAccounts(ids);
    ids.add(acc.Id);
    SOQLSingletonQueries.getPartnerOwnerAccounts(ids);

    SOQLSingletonQueries.getPartnerAccount(UserInfo.getUserId());

    Test.stopTest();
  }

}