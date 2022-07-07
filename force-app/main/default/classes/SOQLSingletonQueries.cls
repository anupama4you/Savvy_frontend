public without sharing class SOQLSingletonQueries {
    private static SOQLSingletonQueries instance;
    private static SOQLSingletonQueries instanceWithOppIds;
    private static SOQLSingletonQueries instanceWithLeadIds;
    private static SOQLSingletonQueries instanceWithAccountIds;
    private static SOQLSingletonQueries instanceWithProfileId;
    private static SOQLSingletonQueries instanceWithUserIds;
    private static SOQLSingletonQueries instanceWithUserId;
    private static SOQLSingletonQueries instanceWithApplicationIds;
    private static SOQLSingletonQueries instanceWithPersonEmails;
    private static SOQLSingletonQueries instanceWithPersonMobilePhones;
    private static SOQLSingletonQueries instanceWithEmailAddresses;
    private static SOQLSingletonQueries instanceWithEmailAddressesAndMobileNums;
    
    private static Id profileId;
    private static Id userId;
    private static Set<Id> oppIds;
    private static Set<Id> leadIds;
    private static Set<Id> accountIds;
    private static Set<Id> userIds;
    private static Set<Id> appIds;
    private static Set<String> personEmails;
    private static Set<String> personMobilePhones;
    private static Set<String> emailAddresses;
    private static Set<String> mobileNumbers;
    private static Decimal paramLeadDuplicateTime;
    private static String currentProfileName;
    
    public static final String HOME_LOAN_PROFILE = 'Home Loan - Sales';
    public static final String SALES_CONSULTANT3_PROFILE = 'Sales Consultant 3';
    public static final String REPORT_MANAGER_GROUP = 'Report Manager';
    public static final String FRANCHISED_SALES_CONSULTANTS = 'Franchised Sales Consultants';

    private SOQLSingletonQueries(){
    	
    }
    
    public static SOQLSingletonQueries recs() {
    	if (instance == null) instance = new SOQLSingletonQueries(); 
    	return instance;
    }
    
    public static SOQLSingletonQueries setProfId(Id recId){
    	if(profileId == null || (recId != null && profileId != recId)){
    		profileId = recId;
    		instanceWithProfileId = new SOQLSingletonQueries();
    	}
    	
    	if (instanceWithProfileId == null) instanceWithProfileId = new SOQLSingletonQueries();
    	
    	return instanceWithProfileId;
    }
    
    public static SOQLSingletonQueries setUserId(Id recId){
    	if(userId == null || (recId != null && userId != recId)){
    		userId = recId;
    		instanceWithUserId = new SOQLSingletonQueries();
    	}
    		
    	if (instanceWithUserId == null) instanceWithUserId = new SOQLSingletonQueries();
    	
    	return instanceWithUserId;
    }
    
    public static SOQLSingletonQueries setUserIds(Set<Id> idSet){
    	if(userIds == null){
    		userIds = new Set<Id>();
    	}
    	if(idSet !=null && !userIds.containsAll(idSet)){
    	
    		for(Id thisId: idSet){
    			userIds.add(thisId);
    		}
    		
    		instanceWithUserIds = new SOQLSingletonQueries();
    	}	

    	if (instanceWithUserIds == null) instanceWithUserIds = new SOQLSingletonQueries();
    	
    	return instanceWithUserIds;
    }
    
    public static SOQLSingletonQueries setPersonEmails(Set<String> idSet){
    	if(personEmails == null){
    		personEmails = new Set<String>();
    	}
    	if(idSet !=null && !personEmails.containsAll(idSet)){
    	
    		for(String thisId: idSet){
    			personEmails.add(thisId);
    		}
    		
    		instanceWithPersonEmails = new SOQLSingletonQueries();
    	}	

    	if (instanceWithPersonEmails == null) instanceWithPersonEmails = new SOQLSingletonQueries();
    	
    	return instanceWithPersonEmails;
    }
    
    public static SOQLSingletonQueries setEmailAddresses(Set<String> idSet){
    	if(emailAddresses == null){
    		emailAddresses = new Set<String>();
    	}
    	if(idSet !=null && !emailAddresses.containsAll(idSet)){
    	
    		for(String thisId: idSet){
    			emailAddresses.add(thisId);
    		}
    		
    		instanceWithEmailAddresses = new SOQLSingletonQueries();
    	}	

    	if (instanceWithEmailAddresses == null) instanceWithEmailAddresses = new SOQLSingletonQueries();
    	
    	return instanceWithEmailAddresses;
    }
    
    public static SOQLSingletonQueries setEmailAddressesAndMobileNums(Set<String> emls, Set<String> mobNums){
    	if(emailAddresses == null){
    		emailAddresses = new Set<String>();
    	}
    	if(mobileNumbers == null){
    		mobileNumbers = new Set<String>();
    	}
    	if((emls !=null && !emailAddresses.containsAll(emls)) || (mobNums !=null && !mobileNumbers.containsAll(mobNums))){
    	
    		for(String thisId: emls){
    			emailAddresses.add(thisId);
    		}
    		
    		for(String thisId: mobNums){
    			mobileNumbers.add(thisId);
    		}
    		
    		instanceWithEmailAddressesAndMobileNums = new SOQLSingletonQueries();
    	}	

    	if (instanceWithEmailAddressesAndMobileNums == null) instanceWithEmailAddressesAndMobileNums = new SOQLSingletonQueries();
    	
    	return instanceWithEmailAddressesAndMobileNums;
    }
    
    public static SOQLSingletonQueries setPersonMobilePhones(Set<String> idSet){
    	if(personMobilePhones == null){
    		personMobilePhones = new Set<String>();
    	}
    	if(idSet !=null && !personMobilePhones.containsAll(idSet)){
    	
    		for(String thisId: idSet){
                if (String.isNotBlank(thisId)) {
    			 personMobilePhones.add(thisId);
                }
    		}
    		
    		instanceWithPersonMobilePhones = new SOQLSingletonQueries();
    	}	

    	if (instanceWithPersonMobilePhones == null) instanceWithPersonMobilePhones = new SOQLSingletonQueries();
    	
    	return instanceWithPersonMobilePhones;
    }
    
    public static SOQLSingletonQueries setOppIds(Set<Id> idSet){
    	if(oppIds == null){
    		oppIds = new Set<Id>();
    	}
    	if(idSet !=null && !oppIds.containsAll(idSet)){
    		
    		for(Id thisId: idSet){
    			oppIds.add(thisId);
    		}
    		
    		instanceWithOppIds = new SOQLSingletonQueries();
    	}
    	
    	if (instanceWithOppIds == null) instanceWithOppIds = new SOQLSingletonQueries();
    	
    	return instanceWithOppIds;
    }
    
    public static SOQLSingletonQueries setLeadIds(Set<Id> idSet){
    	if(leadIds == null){
    		leadIds = new Set<Id>();
    	}
    	if(idSet !=null && !leadIds.containsAll(idSet)){
    		for(Id thisId: idSet){
    			leadIds.add(thisId);
    		}
    		
    		instanceWithLeadIds = new SOQLSingletonQueries();
    	}
    		
    	if (instanceWithLeadIds == null) instanceWithLeadIds = new SOQLSingletonQueries();
    	
    	return instanceWithLeadIds;
    }
    
    public static SOQLSingletonQueries setAccountIds(Set<Id> idSet){
    	if(accountIds == null){
    		accountIds = new Set<Id>();
    	}
    	if(idSet !=null && !accountIds.containsAll(idSet)){
    		for(Id thisId: idSet){
    			accountIds.add(thisId);
    		}
    		
    		instanceWithAccountIds = new SOQLSingletonQueries();
    	}
    	
    	if (instanceWithAccountIds == null) instanceWithAccountIds = new SOQLSingletonQueries();
    	
    	return instanceWithAccountIds;
    }
    
    public static SOQLSingletonQueries setApplicationIds(Set<Id> idSet){
    	if(appIds == null){
    		appIds = new Set<Id>();
    	}
    	if(idSet !=null && !appIds.containsAll(idSet)){

    		for(Id thisId: idSet){
    			appIds.add(thisId);
    		}
    		
    		instanceWithApplicationIds = new SOQLSingletonQueries();
    	}
    	
    	if (instanceWithApplicationIds == null) instanceWithApplicationIds = new SOQLSingletonQueries();
    	
    	return instanceWithApplicationIds;
    }
    
    public User sysGenUser{
		get{
			if(sysGenUser == null) {
        try {
				  sysGenUser = [Select Id, Name from User where Name='System Generated'];
        } catch (QueryException ex) {}
				if(sysGenUser == null){
					sysGenUser = new User();
				}
			}
			return sysGenUser;
		}
		set;
	}
	
	public List<User> adminOrDirectTLUsers{
    	get{
    		if(adminOrDirectTLUsers == null){
				adminOrDirectTLUsers = [SELECT Id,Name,Profile.Name,Email FROM User WHERE Profile.Name = 'System Admin' or Profile.Name = 'Direct Team Leader'];
				if(adminOrDirectTLUsers == null){
					adminOrDirectTLUsers = new List<User>();
				}
			}
			return adminOrDirectTLUsers;
    	}
    	set;
    }
    
    public Set<Id> settlementUserIds{
    	get{
    		if(settlementUserIds == null){
    			Group settlementGrp = [Select Id from Group where type='Queue' and DeveloperName='Settlement_Officers'];
    			if(settlementGrp != null){
    				if(settlementUserIds == null){
    					settlementUserIds = new Set<Id>();
    				}
    				for(GroupMember gMember : [Select UserOrGroupId From GroupMember where GroupId =:settlementGrp.Id]){
    					if(String.valueOf(gMember.UserOrGroupId).startsWith('005')){
    						settlementUserIds.add(gMember.UserOrGroupId);
    					}
    				}
    			}
				if(settlementUserIds == null){
					settlementUserIds = new Set<Id>();
				}
			}
			return settlementUserIds;
    	}
    	set;
    } 
    
    public Group getHomeLoanQueue {
    	get{
    		if (getHomeLoanQueue == null) {
    			getHomeLoanQueue = [Select Id, DeveloperName, Type from Group where DeveloperName = 'Home_Loans' and Type = 'Queue' limit 1];
    			if(getHomeLoanQueue == null){
    				getHomeLoanQueue = new Group();
    			}
    		}
    		return getHomeLoanQueue;
    	}
    	set;
    }
    
    public Profile getVDProfile {
    	get{
    		if (getVDProfile == null) {
    			getVDProfile = [select id, name from profile where name = 'Vehicles Direct - Settlements'];
    			if(getVDProfile == null){
    				getVDProfile = new Profile();
    			}
    		}
    		return getVDProfile;
    	}
    	set;
    }
    
    public List<UserRole> getCurrentUserRoles {
    	get{
    		if (getCurrentUserRoles == null) {
    			getCurrentUserRoles = [Select Id, Name from UserRole where Id = :UserInfo.getUserRoleId()];
    			if(getCurrentUserRoles == null){
    				getCurrentUserRoles = new List<UserRole>();
    			}
    		}
    		return getCurrentUserRoles;
    	}
    	set;
    }
    
    public List<EmailTemplate> getSettledEmailTemplates {
    	get{
    		if (getSettledEmailTemplates == null) { 
    			getSettledEmailTemplates = [select id, developername from EmailTemplate where developername  like 'Settled%'];
    			if(getSettledEmailTemplates == null){
    				getSettledEmailTemplates = new List<EmailTemplate>();
    			}
    		}
    		return getSettledEmailTemplates;
    	}
    	set;
    }
    
    public Map<Id, Custom_Opportunity__c> opportunityProdFinanceMap{
    	get{
    		if(opportunityProdFinanceMap == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				opportunityProdFinanceMap = new Map<Id, Custom_Opportunity__c> ([SELECT Id,
    										 (SELECT Id
                                              FROM Products__r
                                              WHERE RecordType.Name = 'Finance'
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                             FROM Custom_Opportunity__c
                                             WHERE Id IN :oppIds]);
    			}
    			if(opportunityProdFinanceMap == null){
    				opportunityProdFinanceMap = new Map<Id, Custom_Opportunity__c>();
    			}
    		}
    		return opportunityProdFinanceMap;
    	}
    	set;
    }
    
    public List<Product__c> financeProductsByOppIds{
    	get{
    		if(financeProductsByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				financeProductsByOppIds = [SELECT Id,
                                    Opportunity_Name__c,
                                    Loan_Term__c,
                                    End_of_Loan_Date__c,
                                    RecordType.Name
                             FROM Product__c
                             WHERE Opportunity_Name__c IN :oppIds
                             AND RecordType.Name = 'Finance'];
    			}
    			if(financeProductsByOppIds == null){
    				financeProductsByOppIds = new List<Product__c>();
    			}
    		}
    		return financeProductsByOppIds;
    	}
    	set;
    }
    
    public List<Task> uncompletedTasksByOppIds{
    	get{
    		if(uncompletedTasksByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				uncompletedTasksByOppIds = [SELECT Id,
                              Status, 
                              WhatId,
                              Subject
                       FROM Task
                       WHERE WhatId IN :oppIds
                       AND Status != 'Completed'];
    			}
    			if(uncompletedTasksByOppIds == null){
    				uncompletedTasksByOppIds = new List<Task>();
    			}
    		}
    		return uncompletedTasksByOppIds;
    	}
    	set;
    }
    
    public List<Task> uncompletedTasksByLeadIds{
    	get{
    		if(uncompletedTasksByLeadIds == null){
    			if(leadIds != null && !leadIds.isEmpty()){
    				uncompletedTasksByLeadIds = [SELECT Id,
                              Status, 
                              WhatId,
                              Subject
                       FROM Task
                       WHERE WhatId IN :leadIds
                       AND Status != 'Completed'];
    			}
    			if(uncompletedTasksByLeadIds == null){
    				uncompletedTasksByLeadIds = new List<Task>();
    			}
    		}
    		return uncompletedTasksByLeadIds;
    	}
    	set;
    }
    
    public List<Product__c> productsByOppIds{
    	get{
    		if(productsByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				productsByOppIds = [SELECT Id,
                                      Name,
                                      Opportunity_Name__c,
                                      (SELECT Id
                                       FROM Invoices__r)
                               FROM Product__c
                               WHERE Opportunity_Name__c IN :oppIds];
    			}
    			if(productsByOppIds == null){
    				productsByOppIds = new List<Product__c>();
    			}
    		}
    		return productsByOppIds;
    	}
    	set;
    }
    
    public List<Custom_Opportunity__c> opportunitiesByLeadIds{
    	get{
    		if(opportunitiesByLeadIds == null){
    			if(leadIds != null && !leadIds.isEmpty()){
    				opportunitiesByLeadIds = [select id,name,Mortgage_Rent__c,Lead__c,OwnerId from Custom_Opportunity__c where Lead__c in:leadIds];
    			}
    			if(opportunitiesByLeadIds == null){
    				opportunitiesByLeadIds = new List<Custom_Opportunity__c>();
    			}
    		}
    		return opportunitiesByLeadIds;
    	}
    	set;
    }
    
    public List<Custom_Opportunity__c> opportunitiesByAppIds{
    	get{
    		if(opportunitiesByAppIds == null){
    			if(appIds != null && !appIds.isEmpty()){
    				opportunitiesByAppIds = Database.query(SObjectUtils.getQueryString('where Application__c IN :  appIds', 'Custom_Opportunity__c'));//[select id,name,Mortgage_Rent__c,Lead__c,OwnerId from Custom_Opportunity__c where Lead__c in:leadIds];
    			}
    			if(opportunitiesByAppIds == null){
    				opportunitiesByAppIds = new List<Custom_Opportunity__c>();
    			}
    		}
    		return opportunitiesByAppIds;
    	}
    	set;
    }
    
    public List<Custom_Opportunity__c> opportunitiesByAccountIds{
    	get{
    		if(opportunitiesByAccountIds == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				opportunitiesByAccountIds = [Select Id, Name, Mobile_Number__c, Email_Address__c, Status__c, Account__c, OwnerId from Custom_Opportunity__c where account__c in : accountIds];
    			}
    			if(opportunitiesByAccountIds == null){
    				opportunitiesByAccountIds = new List<Custom_Opportunity__c>();
    			}
    		}
    		return opportunitiesByAccountIds;
    	}
    	set;
    }
    
    public List<Lead__c> leadsByAccountIds{
    	get{
    		if(leadsByAccountIds == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				leadsByAccountIds = [Select Id, Name, Mobile_Number__c, Email_Address__c, Status__c, Account__c FROM Lead__c WHERE Account__c in : accountIds];
    			}
    			if(leadsByAccountIds == null){
    				leadsByAccountIds = new List<Lead__c>();
    			}
    		}
    		return leadsByAccountIds;
    	}
    	set;
    }
    
    public List<Custom_Opportunity__c> opportunitiesByEmailAddresses{
    	get{
    		if(opportunitiesByEmailAddresses == null){
    			if(emailAddresses != null && !emailAddresses.isEmpty()){
    				opportunitiesByEmailAddresses = [SELECT id,Name,Email_Address__c FROM Custom_Opportunity__c WHERE Email_Address__c in: emailAddresses];
    			}
    			if(opportunitiesByEmailAddresses == null){
    				opportunitiesByEmailAddresses = new List<Custom_Opportunity__c>();
    			}
    		}
    		return opportunitiesByEmailAddresses;
    	}
    	set;
    }
    
    public List<Lead__Share> leadSharesByLeadIds{
    	get{
    		if(leadSharesByLeadIds == null){
    			if(leadIds != null && !leadIds.isEmpty()){
    				leadSharesByLeadIds = [Select UserOrGroupId, ParentId from Lead__Share where ParentId in : leadIds and RowCause = 'Manual'];
    			}
    			if(leadSharesByLeadIds == null){
    				leadSharesByLeadIds = new List<Lead__Share>();
    			}
    		}
    		return leadSharesByLeadIds;
    	}
    	set;
    }
    
    public List<AccountShare> accountSharesByAccountIds{
    	get{
    		if(accountSharesByAccountIds == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				accountSharesByAccountIds = [Select UserOrGroupId, AccountId from AccountShare where AccountId in : accountIds and (RowCause = 'Manual' or RowCause = 'Manual Sharing')];
    			}
    			if(accountSharesByAccountIds == null){
    				accountSharesByAccountIds = new List<AccountShare>();
    			}
    		}
    		return accountSharesByAccountIds;
    	}
    	set;
    }
    
    public List<Lead__c> becomeOpptyLeadsByAccountIds{
    	get{
    		if(becomeOpptyLeadsByAccountIds == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				becomeOpptyLeadsByAccountIds = [SELECT Id,Account__c,OwnerId FROM Lead__c WHERE Account__c IN :accountIds AND (Status__c = 'Become Opportunity')];
    			}
    			if(becomeOpptyLeadsByAccountIds == null){
    				becomeOpptyLeadsByAccountIds = new List<Lead__c>();
    			}
    		}
    		return becomeOpptyLeadsByAccountIds;
    	}
    	set;
    }
    
    public List<Lead__c> leadsByEmailsAndMobileNums{
    	get{
    		if(leadsByEmailsAndMobileNums == null){
    			if(emailAddresses != null && !emailAddresses.isEmpty() && mobileNumbers!= null && !mobileNumbers.isEmpty()){
    				User sysGen =SOQLSingletonQueries.recs().sysGenUser;
    				leadsByEmailsAndMobileNums = [SELECT Id, Name, Mobile_Number__c, Application__c, Email_Address__c, Status__c, Account__c, OwnerId, Employment_Status__c 
                                                  FROM Lead__c 
                                                  WHERE Account__c = null 
                                                  AND Status__c = 'New Lead' 
                                                  AND Employment_Status__c != 'Unemployed' 
                                                  AND OwnerId =: sysGen.id 
                                                  AND Email_Address__c IN: emailAddresses 
                                                  AND Mobile_Number__c IN: mobileNumbers];
    			}
    			if(leadsByEmailsAndMobileNums == null){
    				leadsByEmailsAndMobileNums = new List<Lead__c>();
    			}
    		}
    		return leadsByEmailsAndMobileNums;
    	}
    	set;
    }

    public List<Lead__c> leadsByEmailsAndMobileNumsSales{
        get{
            if(leadsByEmailsAndMobileNumsSales == null){
                if(emailAddresses != null && !emailAddresses.isEmpty() && mobileNumbers!= null && !mobileNumbers.isEmpty()){
                    User sysGen =SOQLSingletonQueries.recs().sysGenUser;
                    leadsByEmailsAndMobileNumsSales = [SELECT Id, Name, Mobile_Number__c, Application__c, Email_Address__c, Status__c, Account__c, OwnerId, Employment_Status__c 
                                                       FROM Lead__c 
                                                       WHERE OwnerId != : sysGen.id 
                                                       AND Email_Address__c IN: emailAddresses 
                                                       AND Mobile_Number__c IN: mobileNumbers
                                                       ORDER BY LastModifiedDate DESC LIMIT 10];
                }
                if(leadsByEmailsAndMobileNumsSales == null){
                    leadsByEmailsAndMobileNumsSales = new List<Lead__c>();
                }
            }
            return leadsByEmailsAndMobileNumsSales;
        }
        set;
    }
    
    public List<Application__c> applicationsByAccountIds{
    	get{
    		if(applicationsByAccountIds == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				applicationsByAccountIds = [SELECT Id,Account__c,OwnerId FROM Application__c WHERE Account__c IN :accountIds];
    			}
    			if(applicationsByAccountIds == null){
    				applicationsByAccountIds = new List<Application__c>();
    			}
    		}
    		return applicationsByAccountIds;
    	}
    	set;
    }
    
    public Map<Id, Lead__c> leadsIdMap{
    	get{
    		if(leadsIdMap == null){
    			if(leadIds != null && !leadIds.isEmpty()){
    				leadsIdMap = new Map<Id, Lead__c> ([SELECT Id, Lead_Consultant_Dealer__c, OwnerId, Owner.Name                                                         
                                       FROM Lead__c WHERE Id IN :leadIds]);
    			}
    			if(leadsIdMap == null){
    				leadsIdMap = new Map<Id, Lead__c>();
    			}
    		}
    		return leadsIdMap;
    	}
    	set;
    }
    
    public Map<Id, Account> accountsIdMap{
    	get{
    		if(accountsIdMap == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				accountsIdMap = new Map<Id, Account> ([SELECT id, Lead_Status__c,logged_in_user__c,Generated_Date__c,OwnerId, Owner.Name FROM Account WHERE id IN: accountIds]); 
    			}
    			if(accountsIdMap == null){
    				accountsIdMap = new Map<Id, Account>();
    			}
    		}
    		return accountsIdMap;
    	}
    	set;
    }
    
    public Map<Id, Application__c> applicationsIdMap{
    	get{
    		if(applicationsIdMap == null){
    			if(appIds != null && !appIds.isEmpty()){
    				applicationsIdMap = new Map<Id, Application__c>([Select Id,Name,OwnerId,Account__c,No_of_People__c,
    				Marital_Status_1__c,No_of_Dependants_1__c,Email_Address_2__c,First_Name_2__c,Last_Name_2__c,No_of_Dependants_2__c,
    				Do_you_own_a_property__c,Mode_of_Employment_1__c,Current_Occupation_1__c,Net_Income_1__c,Payment_Frequency_1__c,Net_Income_2__c,Payment_Frequency_2__c,
                 	Partner_Income__c,
                 	Rent_per_month_1__c,Rent_per_month_2__c,Repayment_Regularity__c,Preferred_Repayment__c 
                    from Application__c where Id in : appIds]);
    			}
    			if(applicationsIdMap == null){
    				applicationsIdMap = new Map<Id, Application__c>();
    			}
    		}
    		return applicationsIdMap;
    	}
    	set;
    }
    
    public Map<Id, Account> settledAccountsIdMap{
    	get{
    		if(settledAccountsIdMap == null){
    			if(accountIds != null && !accountIds.isEmpty()){
    				settledAccountsIdMap = new Map<Id, Account> ([SELECT Id,
                                                                (SELECT Id,
                                                                        Occupation__c,
                                                                        Occupation_Status__c,
                                                                        Applicant_Net_Income__c,
                                                                        Co_Borrower_Net_Income__c,
                                                                        Other_Income__c,
                                                                        Other_Income_Detail__c,
                                                                        Mortgage_Rent__c,
                                                                        Living_Expenses__c,
                                                                        Existing_Loan_Payments__c,
                                                                        Credit_Card_Payments__c,
                                                                        Other_Expenses__c                                                                      
                                                                 FROM Opportunities__r
                                                                 WHERE Status__c = 'Settled'
                                                                 ORDER BY Date_Settled__c DESC)
                                                         FROM Account
                                                         WHERE Id IN :accountIds]);   
    			}
    			if(settledAccountsIdMap == null){
    				settledAccountsIdMap = new Map<Id, Account>();
    			}
    		}
    		return settledAccountsIdMap;
    	}
    	set;
    }
    
    
    public List<Cloud_Documents__c> cloudDocsByOppIds{
    	get{
    		if(cloudDocsByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				cloudDocsByOppIds = [Select Id, Custom_Opportunity__c, Document_Type__c from Cloud_Documents__c where Custom_Opportunity__c in :oppIds];
    			}
    			if(cloudDocsByOppIds == null){
    				cloudDocsByOppIds = new List<Cloud_Documents__c>();
    			}
    		}
    		return cloudDocsByOppIds;
    	}
    	set;
    }
    
    public List<Attachment> attachmentsByOppIds{
    	get{
    		if(attachmentsByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				attachmentsByOppIds = [select id,parentId from Attachment where parentId in :oppIds];
    			}
    			if(attachmentsByOppIds == null){
    				attachmentsByOppIds = new List<Attachment>();
    			}
    		}
    		return attachmentsByOppIds;
    	}
    	set;
    }
    
    public List<User> vdUserByProfileId{
    	get{
    		if(vdUserByProfileId == null){
    			if(profileId != null){
    				vdUserByProfileId = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where profileid =: profileId AND isActive = true];
    			}
    			if(vdUserByProfileId == null){
    				vdUserByProfileId = new List<User>();
    			}
    		}
    		return vdUserByProfileId;
    	}
    	set;
    }
    
    public List<User> usersByIds{
    	get{
    		if(usersByIds == null){
    			if(userIds != null && !userIds.isEmpty()){
    				usersByIds = [select Id, Name from User where Id IN : userIds];
    			}
    			if(usersByIds == null){
    				usersByIds = new List<User>();
    			}
    		}
    		return usersByIds;
    	}
    	set;
    }
    
    public List<Account> accountsByPersonEmails{
    	get{
    		if(accountsByPersonEmails == null){
    			if(personEmails != null && !personEmails.isEmpty()){
            System.debug('personEmails >> ' + personEmails);
    				accountsByPersonEmails = [
						SELECT Id, PersonEmail, OwnerId, Partner_Owner__c 
            FROM Account 
						WHERE PersonEmail != null
						And PersonEmail IN : personEmails];
    			}
    			if(accountsByPersonEmails == null){
    				accountsByPersonEmails = new List<Account>();
    			}
    		}
    		return accountsByPersonEmails;
    	}
    	set;
    }
    
    public List<Account> accountsByPersonMobilePhones{
    	get{
    		if(accountsByPersonMobilePhones == null){
    			if(personMobilePhones != null && !personMobilePhones.isEmpty()){
            System.debug('personMobilePhones >> ' + personMobilePhones);
    				accountsByPersonMobilePhones = [SELECT PersonMobilePhone FROM Account WHERE PersonMobilePhone IN : personMobilePhones];
    			}
    			if(accountsByPersonMobilePhones == null){
    				accountsByPersonMobilePhones = new List<Account>();
    			}
    		}
    		return accountsByPersonMobilePhones;
    	}
    	set;
    }
    
    public Map<Id, Integer> vdOwnerOpportunityCountMap{
    	get{
    		if(vdOwnerOpportunityCountMap == null){
    			if(userIds != null && !userIds.isEmpty()){
    				vdOwnerOpportunityCountMap = new Map<Id, Integer>();
    				for(AggregateResult ar : [Select VD_Owner__c, count(Id) from Custom_Opportunity__c where VD_Owner__c in :userIds and VD_Status__c != 'Sent back to Finance Consultant' group by VD_Owner__c]){
    					vdOwnerOpportunityCountMap.put((Id)ar.get('VD_Owner__c'), Integer.valueOf(ar.get('expr0')));
    				}
    			}
    			if(vdOwnerOpportunityCountMap == null){
    				vdOwnerOpportunityCountMap = new Map<Id, Integer>();
    			}
    		}
    		return vdOwnerOpportunityCountMap;
    	}
    	set;
    }
    
    public Map<Id, User> usersIdMap{
    	get{
    		if(usersIdMap == null){
    			if(userId != null){
    				usersIdMap = new Map<Id, User>([SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id = :userId]);
    			}
    			if(usersIdMap == null){
    				usersIdMap = new Map<Id, User>();
    			}
    		}
    		return usersIdMap;
    	}
    	set;
    }
    
    public Map<Id, User> usersIdsMap{
    	get{
    		if(usersIdsMap == null){
    			if(userIds != null && !userIds.isEmpty()){
    				usersIdsMap = new Map<Id, User>([SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id in :userIds]);
    			}
    			if(usersIdsMap == null){
    				usersIdsMap = new Map<Id, User>();
    			}
    		}
    		return usersIdsMap;
    	}
    	set;
    }
    
    public Map<Id, Call_Reminder__c> callRemindersByOppIds{
    	get{
    		if(callRemindersByOppIds == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				callRemindersByOppIds = new Map<Id, Call_Reminder__c>([Select Id, Name, Custom_Opportunity__c from Call_Reminder__c where Custom_Opportunity__c in :oppIds]);
    			}
    			if(callRemindersByOppIds == null){
    				callRemindersByOppIds = new Map<Id, Call_Reminder__c>();
    			}
    		}
    		return callRemindersByOppIds;
    	}
    	set;
    }
    
    public Map<Id, List<Attachment>> opportunityWorksheetAttachMap{
    	get{
    		if(opportunityWorksheetAttachMap == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				List<Attachment> workSheets = [SELECT id,Name,body,ContentType,ParentId FROM Attachment WHERE ParentId in: oppIds and Name like '%worksheet%'];
    				opportunityWorksheetAttachMap = new Map<Id, List<Attachment>>();
    				for(Attachment att: workSheets){
    					if(opportunityWorksheetAttachMap.containsKey(att.ParentId)){
    						opportunityWorksheetAttachMap.get(att.ParentId).add(att);
    					} else {
    						opportunityWorksheetAttachMap.put(att.ParentId, new List<Attachment>{att});
    					}
    				}
    			}
    			if(opportunityWorksheetAttachMap == null){
    				opportunityWorksheetAttachMap = new Map<Id, List<Attachment>>();
    			}
    		}
    		return opportunityWorksheetAttachMap;
    	}
    	set;
    }
    
    public Map<Id, List<Attachment>> opportunityDealerAttachMap{
    	get{
    		if(opportunityDealerAttachMap == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				List<Attachment> dealers = [SELECT id,Name,body,ContentType,ParentId FROM Attachment WHERE ParentId in: oppIds and Name like '%Dealer TI%'];
    				opportunityDealerAttachMap = new Map<Id, List<Attachment>>();
    				for(Attachment att: dealers){
    					if(opportunityDealerAttachMap.containsKey(att.ParentId)){
    						opportunityDealerAttachMap.get(att.ParentId).add(att);
    					} else {
    						opportunityDealerAttachMap.put(att.ParentId, new List<Attachment>{att});
    					}
    				}
    			}
    			if(opportunityDealerAttachMap == null){
    				opportunityDealerAttachMap = new Map<Id, List<Attachment>>();
    			}
    		}
    		return opportunityDealerAttachMap;
    	}
    	set;
    }
    
    public Map<Id, List<Custom_Opportunity__History>> opportunityHistoryAttachMap{
    	get{
    		if(opportunityHistoryAttachMap == null){
    			if(oppIds != null && !oppIds.isEmpty()){
    				List<Custom_Opportunity__History> historyList = [SELECT Id, ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM Custom_Opportunity__History where parentId in: oppIds and Field = 'VD_Owner__c' ORDER BY CreatedDate ASC];
    				opportunityHistoryAttachMap = new Map<Id, List<Custom_Opportunity__History>>();
    				for(Custom_Opportunity__History att: historyList){
    					if(opportunityHistoryAttachMap.containsKey(att.ParentId)){
    						opportunityHistoryAttachMap.get(att.ParentId).add(att);
    					} else {
    						opportunityHistoryAttachMap.put(att.ParentId, new List<Custom_Opportunity__History>{att});
    					}
    				}
    			}
    			if(opportunityHistoryAttachMap == null){
    				opportunityHistoryAttachMap = new Map<Id, List<Custom_Opportunity__History>>();
    			}
    		}
    		return opportunityHistoryAttachMap;
    	}
    	set;
    }

    public static Boolean isActiveUser(Id userId) {
        Boolean r = false;
        List<User> uLts = [SELECT IsActive FROM User WHERE Id = :userId];
        if (!uLts.isEmpty()) {
            r = uLts.get(0).IsActive;
        }
        return r;
    }

    public static List<Account> searchAccounts(Lead__c lead) {
        List<Account> r = new List<Account>();
        if (lead != null) {
            String mobile = lead.Mobile_Number__c;
            String email = lead.Email_Address__c;
            if (String.isNotBlank(mobile) && String.isNotBlank(email)) {
                r = [SELECT Id, Name, OwnerId FROM Account WHERE PersonEmail = :email AND PersonMobilePhone = :mobile ORDER BY CreatedDate DESC];
            }
            if (r.isEmpty()) {
                if (String.isNotBlank(mobile)) {
                    r = [SELECT Id, Name, OwnerId FROM Account WHERE PersonMobilePhone = :mobile ORDER BY CreatedDate DESC];
                }
                if (r.isEmpty()) {
                    if (String.isNotBlank(email)) {
                        r = [SELECT Id, Name, OwnerId FROM Account WHERE PersonEmail = :email ORDER BY CreatedDate DESC];
                    }
                }
            }
        }
        return r;
    }

    public User sysAdminUser{
        get{
            if(sysAdminUser == null){
                try {
                  sysAdminUser = [Select Id, Name, Email from User where Name='Savvy Admin'];
                } catch (QueryException ex) {}
                if(sysAdminUser == null){
                    sysAdminUser = new User();
                }
            }
            return sysAdminUser;
        }
        set;
    }

    public Boolean isSavvyAdmin() {
        if (this.sysAdminUser != null && UserInfo.getUserId().equals(this.sysAdminUser.Id)) {
            return true;
        }
        return false;
    }

    public static Boolean isActiveConsultantUser(Id userId) {
        Boolean r = false;
        List<User> uLts = [SELECT Id, Name, Email, Phone, Extension, MobilePhone, Fax FROM User 
                           WHERE Id = :userId
                           AND ProfileId IN (SELECT Id FROM Profile WHERE (Name like 'Sales Consultant%' OR Name = :HOME_LOAN_PROFILE)) 
                           AND isActive = true];
        if (!uLts.isEmpty()) {
            r = true;
        }
        return r;
    }

    public static Decimal getLeadDuplicateTimeParam() {
        Decimal r = 0.0;
        List<Business_Parameters__c> d = [SELECT Number_Value__c FROM Business_Parameters__c WHERE Parameter__c = 'LEAD_DUPLICATE_TIME'];
        if (!d.isEmpty()) {
            r = d.get(0).Number_Value__c;
        } else {
            r = 1440;
        }
        return r;
    }

    public static Map<Id, List<Custom_Opportunity__c>> getOpportunitiesByAccount(Set<Id> accountIds) {
        System.debug('getOpportunitiesByAccount....');
        Map<Id, List<Custom_Opportunity__c>> r = new Map<Id, List<Custom_Opportunity__c>>();
        if (accountIds != null && !accountIds.isEmpty()) {
            List<String> statusList = new List<String>();
            statusList.add('Settled');
            statusList.add('Declined');
            statusList.add('Unresolved Opportunity');
            System.debug('status: ' + statusList);
            List<Custom_Opportunity__c> d = [
                SELECT Id, Name, Account__c, Status__c, Mobile_Number__c, Email_Address__c, Application__c, 
                       Application__r.Status__c, CreatedById, Application__r.Name, OwnerType__c, OwnerId
                FROM Custom_Opportunity__c
                WHERE Account__c IN :accountIds
                AND (NOT(Status__c IN :statusList))
                AND OwnerType__c = 'User'
                AND (LastModifiedDate = LAST_N_DAYS:30)
                ORDER BY LastModifiedDate DESC
            ];
            System.debug('Total records: ' + d.size());
            for (Custom_Opportunity__c o : d) {
                List<Custom_Opportunity__c> lst = r.get(o.Account__c);
                if (lst == null) {
                    lst = new List<Custom_Opportunity__c>();
                    r.put(o.Account__c, lst);
                }
                lst.add(o);
            }
            System.debug('Total found records: ' + r.size());
        }
        return r;
    }

    public static Map<String, Custom_Opportunity__c> getOpportunitiesByPhoneOrEmail(Set<String> phones, Set<String> emails) {
        System.debug('getOpportunitiesByPhoneOrEmail....');
        Map<String, Custom_Opportunity__c> r = new Map<String, Custom_Opportunity__c>();
        if (phones != null && emails != null) {
            List<String> statusList = new List<String>();
            statusList.add('Settled');
            statusList.add('Declined');
            statusList.add('Unresolved Opportunity');
            System.debug('phones: ' + phones);
            System.debug('emails: ' + emails);
            System.debug('status: ' + statusList);
            List<Custom_Opportunity__c> d = [
                SELECT Id, Name, Account__c, Mobile_Number__c, Email_Address__c, Application__c, 
                Application__r.Status__c, OwnerType__c, Status__c
                FROM Custom_Opportunity__c
                WHERE (Mobile_Number__c IN :phones
                OR Email_Address__c IN :emails)
                AND (NOT(Status__c IN :statusList))
                AND OwnerType__c = 'User'
                AND (LastModifiedDate = LAST_N_DAYS:30)
                ORDER BY LastModifiedDate DESC
            ];
            System.debug('Total records: ' + d.size());
            for (Custom_Opportunity__c o : d) {
                Custom_Opportunity__c opp = r.get(o.Mobile_Number__c);
                if (opp == null) {
                    r.put(o.Mobile_Number__c, o);
                    System.debug('Phone added: ' + o.Mobile_Number__c + ' | ' + o.Name);
                }
            }
            System.debug('Total found records: ' + r.size());
        }
        return r;
    }

    public static Map<Id, Lead__c> getLeadsByAccount(Set<Id> accountIds) {
        System.debug('getLeadsByAccount....');
        Map<Id, Lead__c> r = new Map<Id, Lead__c>();
        if (accountIds != null) {
            List<String> statusList = new List<String>();
            statusList.add('Closed Lead');
            statusList.add('Unresolved Lead');
            statusList.add('Become Opportunity');
            statusList.add('Sales Flow/Become Opportunity');
            System.debug('status: ' + statusList);
            List<Lead__c> d = [
                SELECT Id, Name, Account__c, Mobile_Number__c, Email_Address__c
                FROM Lead__c
                WHERE Account__c IN :accountIds
                AND (NOT(Status__c IN :statusList))
                AND (LastModifiedDate = LAST_N_DAYS:10)
                ORDER BY LastModifiedDate DESC
            ];
            System.debug('Total records: ' + d.size());
            for (Lead__c l : d) {
                r.put(l.Account__c, l);
            }
            System.debug('Total found records: ' + r.size());
        }
        return r;
    }

    public static Map<String, Lead__c> getLeadsByPhoneOrEmail(Set<String> phones, Set<String> emails) {
        System.debug('getLeadsByPhoneOrEmail....');
        Map<String, Lead__c> r = new Map<String, Lead__c>();
        if (phones != null && emails != null) {
			List<String> statusList = new List<String>();
			statusList.add('Closed Lead');
			statusList.add('Unresolved Lead');
			statusList.add('Become Opportunity');
			statusList.add('Sales Flow/Become Opportunity');
			try {
				//System.debug('phones: ' + phones);
				//System.debug('emails: ' + emails);
				//System.debug('status: ' + statusList);
				List<Lead__c> d = [
					SELECT Id, Name, Account__c, Mobile_Number__c, Email_Address__c
					FROM Lead__c
					WHERE (CreatedDate = LAST_N_DAYS:10)
					AND (Mobile_Number__c IN :phones
					OR Email_Address__c IN :emails)
					AND ((NOT(Status__c IN :statusList))
          OR (Status__c = 'Closed Lead' AND External_Lead__c = true))
					ORDER BY LastModifiedDate DESC
					LIMIT 10
				];
				// AND (LastModifiedDate = LAST_N_DAYS:10)
				System.debug('Total records: ' + d.size());
				for (Lead__c l : d) {
					r.put(l.Mobile_Number__c, l);
					r.put(l.Email_Address__c, l);
					//System.debug('Phone added: ' + l.Mobile_Number__c + ' | ' + l.Name);
				}
				//System.debug('Total found records: ' + r.size());
			} catch (System.QueryException e) {

			}
        }
        return r;
    }

    public static String getCurrentUserProfileName() {
        if (String.isBlank(currentProfileName)) {
            Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
            currentProfileName = p.Name;
        }
        return currentProfileName;
    }

    public static Boolean isHomeLoanUser() {
        if (HOME_LOAN_PROFILE.equals(getCurrentUserProfileName())) {
            return true;
        }
        return false;
    }

    public Group savvyTeamGroup {
        get{
            if(savvyTeamGroup == null){

                List<Group> d = [Select Id, Name from Group where Name='Savvy Team'];
                if (!d.isEmpty()) {
                    savvyTeamGroup = d.get(0);
                } else {
                    savvyTeamGroup = new Group();
                }
            }
            return savvyTeamGroup;
        }
        set;
    }

    public Map<String,Id> recordTypes {
        get{
            if (recordTypes == null) {
                recordTypes = new Map<String,Id>();
                for (RecordType rt: [SELECT Id, Name FROM RecordType]) {
                       recordTypes.put(rt.Name, rt.Id);
                }
            }
            return recordTypes;
        }
        set;
    }

    public static Set<Id> getMostRecentOpportunityOwnersByAccount(Set<Id> accountIds) {
        Set<Id> r = new Set<Id>();
        if (accountIds != null && !accountIds.isEmpty()) {
            List<Custom_Opportunity__c> d = [
                SELECT Owner.Id FROM Custom_Opportunity__c
                WHERE Account__c IN :accountIds
                AND OwnerType__c = 'User'
                ORDER BY LastModifiedDate DESC
                LIMIT 5
            ];
            for (Custom_Opportunity__c o : d) {
                r.add(o.Owner.Id);
            }
        }
        return r;
    }

    public Set<Id> salesConsultansProfiles {
        get{
            if(salesConsultansProfiles == null){
                salesConsultansProfiles = new Set<Id>();
                List<Profile> d = [SELECT Id FROM Profile WHERE (Name like 'Sales Consultant%')];
                for (Profile p: d) {
                    salesConsultansProfiles.add(p.Id);
                }
            }
            return salesConsultansProfiles;
        }
        set;
    }

    
    public Set<Id> activeSalesConsultans {
        get {
            if ( activeSalesConsultans == null) {
                activeSalesConsultans = new Set<Id>();
                List<User> d = [
                        SELECT Id FROM User 
                        WHERE ProfileId IN (SELECT Id FROM Profile WHERE (Name like 'Sales Consultant%' OR Name = :SOQLSingletonQueries.HOME_LOAN_PROFILE)) 
                        AND isActive = true];
                for (User u : d) {
                    activeSalesConsultans.add(u.Id);
                }
            }
            return activeSalesConsultans;
        }
        set;
    }

    public Set<Id> lenderLoginConsultans {
        get {
            if (lenderLoginConsultans == null) {
                lenderLoginConsultans = new Set<Id>();
                List<GroupMember> gm = [
                    Select UserOrGroupId From GroupMember
                    where GroupId in (
                      select id from Group 
                      where (
                        Name like 'Sales Consultants%' OR 
                        Name = 'Home Loans' OR
                        Name = 'Franchised Sales Consultants'
                      )
                    )
                ];
                Set<Id> ids = new Set<Id>();
                for (GroupMember g : gm) {
                    ids.add(g.UserOrGroupId);
                }
                List<User> d = [
                        SELECT Id FROM User 
                        WHERE Id IN :ids];
                for (User u : d) {
                    lenderLoginConsultans.add(u.Id);
                }
            }
            return lenderLoginConsultans;
        }
        set;
    }

    public static Boolean isSalesConsultant3() {
        if (SALES_CONSULTANT3_PROFILE.equals(getCurrentUserProfileName())) {
            return true;
        }
        return false;
    }

    public static Boolean isReportManager(Id userId) {
        if (userId != null) {
            List<GroupMember> gm = [
                Select UserOrGroupId From GroupMember
                where GroupId in (select id from Group where (Name=:REPORT_MANAGER_GROUP))
                and UserOrGroupId = :userId
            ];
            if (!gm.isEmpty()) {
                return true;
            }
        }
        return false;
    }

    public static Set<Id> getGroupMembers(String groupName) {
        Set<Id> r = new Set<Id>();
        List<GroupMember> gm = [
            Select UserOrGroupId From GroupMember
            where GroupId in (select id from Group where (Name = :groupName))
        ];
        for (GroupMember g : gm) {
            r.add(g.UserOrGroupId);
        }
        return r;
    }
    
    public static User getUserById(Id userId){
        return [Select Id, Name, Email, isActive From User Where Id = :userId];
    }

	public static Boolean isGroupMemberOf(String groupName) {
		Id userid = UserInfo.getUserId();
        List<GroupMember> gm = [
            Select UserOrGroupId From GroupMember
            where UserOrGroupId = :userid
			And GroupId in (select id from Group where (Name = :groupName))
        ];
        return !gm.isEmpty();
    }
  
  public Boolean isBrokerPartnerUser {
		get { return 'PowerPartner'.equals(UserInfo.getUserType()); }
		set;
	}

  public Contact myContact {
		get { 
      if (myContact == null) {
        Id userid = UserInfo.getUserId();
        List<Contact> d = [
          Select 
            Id, Name, AccountId, Account.S3_Folder__c,
            FirstName, LastName, Email, Phone, MobilePhone,
            Account.Franchised__c, Account.Business_Client_Portal__c
          From Contact Where Id in (
            Select ContactId From User Where Id =: userid
          )
        ];
        if (!d.isEmpty()) {
          myContact = d.get(0);
        }
      }
      return myContact; 
    }
		set;
	}

  public Id myAccountId {
		get { 
      if (myAccountId == null && this.myContact != null) {
        myAccountId = this.myContact.AccountId;
      }
      return myAccountId; 
    }
		set;
	}

  public Account myAccount {
		get { 
      if (myAccount == null && this.myAccountId != null) {
        // myAccount = this.myContact.AccountId;
        List<Account> d = [
          SELECT 
            Id, Name, Business_Name__c, Business_Logo__c 
          FROM Account WHERE Id = :this.myAccountId
        ];
        myAccount = d.isEmpty() ? null : d.get(0);
      }
      return myAccount; 
    }
		set;
	}

  public Boolean isFranchised {
		get { 
      return (
        this.myContact != null && 
        this.myContact.AccountId != null && 
        this.myContact.Account.Franchised__c
      );
    }
		set;
	}

  public static Custom_Opportunity__c getMostRecentOpportunityByEmail(String email) {
    Custom_Opportunity__c r = null;
    List<Custom_Opportunity__c> d = [
      SELECT Id, Name, Email_Address__c, Partner_Owner__c, OwnerId 
      FROM Custom_Opportunity__c 
      WHERE CreatedDate = LAST_N_DAYS:30
      AND Email_Address__c = :email
      ORDER BY CreatedDate DESC LIMIT 1
    ];
    return d.isEmpty() ? null : d.get(0);
  }

  // public static List<User> getFranchisedCounsultans() {
  //   List<GroupMember> d = [
  //     Select UserOrGroupId From GroupMember
  //     where GroupId in (
  //       select id from Group where (Name = :FRANCHISED_SALES_CONSULTANTS)
  //     )
  //   ];
  //   List<Id> ids = new List<Id>();
  //   for (GroupMember a: d) {
  //     ids.add(a.UserOrGroupId);
  //   }
  //   List<User> r = new List<User>();
  //   if (!ids.isEmpty()) {
  //     r = [
  //       SELECT Id, Name, State, Monthly_Commission_Target__c
  //       FROM User 
  //       WHERE id in :ids
  //       AND IsActive = true
  //     ];
  //   }
  //   return r;
  // }

  public List<User> franchisedCounsultantList {
    get {
      if (franchisedCounsultantList == null) {
        List<GroupMember> d = [
          Select UserOrGroupId From GroupMember
          where GroupId in (
            select id from Group where (Name = :FRANCHISED_SALES_CONSULTANTS)
          )
        ];
        List<Id> ids = new List<Id>();
        for (GroupMember a: d) {
          ids.add(a.UserOrGroupId);
        }
        List<User> r = new List<User>();
        if (!ids.isEmpty()) {
          r = [
            SELECT Id, Name, State, Monthly_Commission_Target__c
            FROM User 
            WHERE id in :ids
            AND IsActive = true
          ];
        }
        franchisedCounsultantList = r;
      }
      return franchisedCounsultantList;
    }
    set;
  }
  
  public static Id getPartnerDefaultOwner(Id accountId) {
    Id r = null;
    if (accountId != null) {
      List<Account> d = [
        SELECT Default_Ownership__c 
        FROM Account
        WHERE Id = :accountId
      ];
      r = !d.isEmpty()? d.get(0).Default_Ownership__c : r;
    }
		return r;
	}

  public static Map<Id, Account> getPartnerOwnerAccounts(Set<Id> accountIds) {
    Map<Id, Account> r = new Map<Id, Account>();
    if (accountIds != null && !accountIds.isEmpty()) {
      List<Account> d = [
        SELECT Default_Ownership__c, Franchised__c 
        FROM Account
        WHERE Id in :accountIds
      ];
      for (Account a: d) {
        r.put(a.Id, a);
      }
    }
		return r;
	}
  
  public static Account getPartnerAccount(Id userId) {
    Account r = null;
    if (String.isNotBlank(userId)) {
      List<User> userList = [
        SELECT Name, ContactId FROM User WHERE Id = :userId LIMIT 1
      ];
      if (!userList.isEmpty()) {
        List<Contact> contactList = [
          SELECT FirstName, LastName, Email, AccountId 
          FROM Contact WHERE Id = :userList[0].ContactId LIMIT 1
        ];
        
        if(!contactList.isEmpty()){
          List<Account> d = [
            SELECT 
              Id, Name, Business_Name__c, Business_Logo__c, Business_Website__c,
              Business_Address__c, Franchised__c, Phone, Fax,
              ABN__c, ACL__c, ACN__c
            FROM Account WHERE Id =: contactList[0].AccountId limit 1
          ];
          r = d[0];
        }
      }
    }
    return r;
	}

}