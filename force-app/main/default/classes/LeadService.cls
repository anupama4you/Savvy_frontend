public class LeadService {

  public static final String EXT_LEAD_SETTING_ACTIVE = 'External_Lead_Setting_Active';
  public static final String EXT_LEAD_SETTING_PERCENTAGE = 'External_Lead_Setting_Percentage';
  public static final String EXT_LEAD_SETTING_STARTING_TIME = 'External_Lead_Setting_Starting_Time';
  
	public static void leadSharing(List<Lead__c> newList){
		Set<Id> leadIds = new Set<Id>();
		for (Lead__c newLead : newList) {
			/*if(newLead.OwnerId != oldMap.get(newLead.Id).OwnerId){
		    	
			}*/
			leadIds.add(newLead.id);
		}
		
		if(!leadIds.isEmpty()){
			 LeadShareService.createShares(leadIds);
		}
	}
    
	public static void setApplicationOwnerAndAccount(List<Lead__c> newList, Map<Id, Lead__c> oldMap){
		Set<Id> relatedAppId = new Set <Id> ();
		List<Application__c> AppToUpdate = new List<Application__c> ();
		for (Lead__c newLead : newList) {
			if (newLead.Application__c != null && newLead.Application__c != oldMap.get(newLead.Id).Application__c) {
				relatedAppId.add(newLead.Application__c);
			}
		}
		
		if (!relatedAppId.isEmpty()){
			Map<Id,Application__c> relatedApp = SOQLSingletonQueries.setApplicationIds(relatedAppId).applicationsIdMap;
			for(Lead__c newLead : newList) {
				if (oldMap.get(newLead.id).Account__c == null && newLead.Account__c != null) { 
					if (newLead.Application__c != null && newLead.Application__c != oldMap.get(newLead.Id).Application__c) {
						Application__c appBuffer = relatedApp.get(newLead.Application__c);
						appBuffer.Account__c = newLead.Account__c;
            appBuffer.OwnerId = newLead.OwnerId;
            AppToUpdate.add(appBuffer);
					}
				}
			}
		}
		
		try{
			if(!AppToUpdate.isEmpty()){
				update AppToUpdate;
			}
		}catch( Exception e){
      System.debug('@@ERROR:' + e.getMessage());
    }
	}
	
	/*	
	 *	@author Andre Calimlim
	 *	@description moved from trgLeadAfterU trigger that will update the uncompleted Tasks to completed if Lead Status is Unresolved Lead or Become Opportunity.
	 *			     This will also update the Lead_Status__c field in Account record. 
	 *	@param newList - List of new Lead records
	 *	@param oldMap - map of old Lead records
	 */
	public static void setStatusOnTaskAndAccount(List<Lead__c> newList, Map<Id, Lead__c> oldMap){
		Map<Id, List<Task>> openTasks = new Map<Id, List<Task>>();
		List<Account> acctForUpdate = new List<Account>();
		Set<Id> ldIds = new Set<Id>();
		Set<Id> accIds = new Set<Id>();
		
		for (Lead__c newLead : newList){
			if(newLead.Status__c != oldMap.get(newLead.Id).Status__c){
				if (newLead.Status__c == 'Unresolved Lead' || newLead.Status__c == 'Become Opportunity'){
					ldIds.add(newLead.Id);
					if(newLead.Status__c == 'Unresolved Lead'){
						accIds.add(newLead.account__c);
					}
				}
			}
		}
		
		for (Task t : SOQLSingletonQueries.setLeadIds(ldIds).uncompletedTasksByLeadIds){
			if (!openTasks.containsKey(t.WhatId)){
				openTasks.put(t.WhatId, new List<Task>());
			}
			openTasks.get(t.WhatId).add(t);
		}
		
		List<Task> tasks = new List<Task>();

		for (Lead__c newLead : newList){
			
			// has the status changed 
			if(newLead.Status__c != oldMap.get(newLead.Id).Status__c && !openTasks.isEmpty()){
				// has open Tasks
				if(openTasks.containsKey(newLead.Id)){
					// check Lead Status
					if (newLead.Status__c == 'Unresolved Lead' || newLead.Status__c == 'Become Opportunity'){
						for (Task t : openTasks.get(newLead.Id)){
							t.Status = 'Completed';
							tasks.add(t);
						}
	            	} else {
	            		// otherwise the status cannot be changed if there are open tasks
	            		newLead.Status__c.addError('The status cannot be changed while there are open tasks.');
	            	}
				}
			}
		}
		
		Map<Id,Account> accMap = SOQLSingletonQueries.setAccountIds(accIds).accountsIdMap;
		for (Lead__c newLead : newList){
			if(newLead.Status__c != oldMap.get(newLead.Id).Status__c && newLead.Status__c == 'Unresolved Lead' && !accMap.isEmpty()){
				Account tempAcct = new Account();
				tempAcct = accMap.get(newLead.Account__c);
	            tempAcct.Lead_Status__c = newLead.status__c;
	            tempAcct.OwnerId =  newLead.OwnerId;
	            acctForUpdate.add(tempAcct);
			}
		}
		
		try{
			if(!tasks.isEmpty()){
				update tasks;
			}
			
			if(!acctForUpdate.isEmpty()){
				update acctForUpdate;
			}
		}catch( Exception e){
           System.debug('@@ERROR:' + e.getMessage());
        }
	}
	
	public static void queueActiveLeadOnUpdate(List<Lead__c> newList, Map<Id, Lead__c> oldMap){
		List<Lead__c> ldUpOBjs=new List<Lead__c>();
		Set<Id> ldUpdIds = new Set<Id>(); 
		Map<Id,String> idToStatusMap=new Map<Id,String>();
    
    // Lelo         2020-10-15
    List<Lead__c> newSLObjs = new List<Lead__c>();

    Set<Id> partnerIds = new Set<Id>();
    for(Lead__c newLead : newList){
      if (String.isNotBlank(newLead.Partner_Owner__c)) {
        partnerIds.add(newLead.Partner_Owner__c);
      }
    }
    Map<Id, Account> partnerMap = SOQLSingletonQueries.getPartnerOwnerAccounts(partnerIds);
    System.debug('@@partnerMap: ' + JSON.serializePretty(partnerMap));

		for(Lead__c newLead : newList){
      System.debug('@@Lead add to Active Campaign: ' + newLead.Id + '|' + newLead.Partner_Owner__c);
      if ('Small Loan'.equals(newLead.Loan_Type__c)) {
        newSLObjs.add(newLead);
      } else if (
        String.isBlank(newLead.Partner_Owner__c) || 
        (
          partnerMap.containsKey(newLead.Partner_Owner__c) &&
          partnerMap.get(newLead.Partner_Owner__c).Franchised__c
        )
      ) {
        System.debug('@@ adding lead to active campaign...');
        ldUpOBjs.add(newLead);
        if(
          newLead.Last_Name__c != oldMap.get(newLead.id).Last_Name__c 
          || newLead.First_Name__c != oldMap.get(newLead.id).First_Name__c 
          || newLead.Email_Address__c != oldMap.get(newLead.id).Email_Address__c 
          || newLead.Status__c != oldMap.get(newLead.id).Status__c 
          || newLead.Reason_for_closure__c != oldMap.get(newLead.id).Reason_for_closure__c 
          || newLead.Finance_Amount__c != oldMap.get(newLead.id).Finance_Amount__c 
          || newLead.Owner.name != oldMap.get(newLead.id).Owner.name 
          || newLead.Owner_Email__c != oldMap.get(newLead.id).Owner_Email__c 
          || newLead.Owner_Mobile__c!=oldMap.get(newLead.id).Owner_Mobile__c 
          || newLead.Owner_Phone__c!=oldMap.get(newLead.id).Owner_Phone__c
        ){
          ldUpdIds.add(newLead.Id);
          
          if(
            newLead.Status__c != oldMap.get(newLead.id).Status__c || 
            newLead.Reason_For_Closure__c != oldMap.get(newLead.Id).Reason_For_Closure__c
          ){
            idToStatusMap.put(newLead.id,'Yes');
          } else {
            idToStatusMap.put(newLead.id,'No');
          }
        }
      }
		}
		
		if(ldUpdIds.size()>0) {
			integer ctr;
			List<Lead__c> leadBatch = new List<Lead__c>();
      List<Lead__c> leadBatch2 = new List<Lead__c>();
      if (ldUpOBjs.size() > 40){
        for (ctr = 0; ctr > 40; ctr++){
          leadBatch.add(ldUpOBjs[ctr]);
          ldUpOBjs.remove(ctr);
        }
      }
      if(ldUpOBjs.size() > 0){
        for(Lead__c ld: ldUpOBjs){
          leadBatch2.add(ld);
        }
      }
      if(!Test.isRunningTest()) { 
        if(!leadBatch.isEmpty()){
          System.enqueueJob(new queueActiveLeadTagCallout (leadBatch,idToStatusMap)); 
        }
        
        if(!leadBatch2.isEmpty()){
          System.enqueueJob(new queueActiveLeadTagCallout (leadBatch2,idToStatusMap));
        }
			}
    }
    
    if (!newSLObjs.isEmpty()) {
      System.debug('Small Loan leads to sent to Active Campaign...');
      // System.debug(JSON.serializePretty(newSLObjs));
      if(!Test.isRunningTest()) { 
        System.enqueueJob(new queueActiveSmallLoanLeadCallout (newSLObjs));
      }
    }
	}
	
  public static void queueActiveLeadOnInsert(List<Lead__c> newList){
    	Set<Id> ldIds = new Set<Id>();
    	List<Lead__c> ldUpOBjs=new List<Lead__c>();
    	Map<Id,String> idToStatusMap=new Map<Id,String>();

      Set<Id> partnerIds = new Set<Id>();
      for(Lead__c newLead : newList){
        if (String.isNotBlank(newLead.Partner_Owner__c)) {
          partnerIds.add(newLead.Partner_Owner__c);
        }
      }
      Map<Id, Account> partnerMap = SOQLSingletonQueries.getPartnerOwnerAccounts(partnerIds);
      
    	for(Lead__c newLead : newList){
        // Exlude Small Personal Loans and Partner leads
        if (
          !'Small Loan'.equals(newLead.Loan_Type__c) &&
          (
            String.isBlank(newLead.Partner_Owner__c) || 
            (
              partnerMap.containsKey(newLead.Partner_Owner__c) &&
              partnerMap.get(newLead.Partner_Owner__c).Franchised__c
            )
          )
        ) {
          ldIds.add(newLead.id);
          ldUpOBjs.add(newLead);
          idToStatusMap.put(newLead.id,'Yes');
          // System.debug('@@Lead add to Active Campaign: ' + newLead.Id);
        }
        // if (String.isNotBlank(newLead.Partner_Owner__c)) {
        //   System.debug('@@ Franchise lead: ' + newLead.Id + ' >> '  + partnerMap.get(newLead.Partner_Owner__c).Franchised__c);
        // }
      }

      if(ldIds.size()>0){
        integer ctr;
        List<Lead__c> leadBatch = new List<Lead__c>();
        List<Lead__c> leadBatch2 = new List<Lead__c>();
        if (ldUpOBjs.size() > 90){
          for (ctr = 0; ctr > 90; ctr++){
            leadBatch.add(ldUpOBjs[ctr]);
            ldUpOBjs.remove(ctr);
          }
        } 
        
        if(ldUpOBjs.size() > 0){
          for(Lead__c ld: ldUpOBjs){
            leadBatch2.add(ld);
          }
        }
        if(!Test.isRunningTest()) { 
          if(!leadBatch.isEmpty()){
            System.enqueueJob(new queueActiveLeadCampaignCallout (leadBatch,idToStatusMap));
          }
          
          if(!leadBatch2.isEmpty()){
            System.enqueueJob(new queueActiveLeadCampaignCallout (leadBatch2,idToStatusMap));
          }
        }
      }
    }
    
    public static void queueActiveLeadOnDelete(List<Lead__c> oldList){
    	List<String> emailAdd = new List<String>();
    	Set<Id> ldIds = new Set<Id>();
    	
    	for(Lead__c oldLead : oldList){
    		emailAdd.add(oldLead.Email_Address__c);
    		ldIds.add(oldLead.id);
    	}
    	if(ldIds.size()>0 || emailAdd.size()>0){
    		
    		integer ctr;
    		List<String> emailBatch = new List<String>();
    		List<String> emailBatch2 = new List<String>();
    		
    		if (emailAdd.size() > 40){
    			for (ctr = 0; ctr > 40; ctr++){
    				emailBatch.add(emailAdd[ctr]);
    				emailAdd.remove(ctr);
    			}
    		}
    		
    		if(emailAdd.size() > 0){
    			for(String eml: emailAdd){
    				emailBatch2.add(eml);
    			}
    		}
    		if(!Test.isRunningTest()) {
	    		if(!emailBatch.isEmpty()){
	    			System.enqueueJob(new queueActiveLeadDeleteCallout (emailBatch));
	    		}
	    		
	    		if(!emailBatch2.isEmpty()){
	    			System.enqueueJob(new queueActiveLeadDeleteCallout (emailBatch2));
	    		}
    		}
    	}
    }

    //  Lelo 					2016-12-27
    public static void checkAccountCreation(List<Lead__c> newList) {
    	if (newList != null) {
    		User sysGen = SOQLSingletonQueries.recs().sysGenUser;
    		User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
    		for (Lead__c a: newList) {
    			Id ownerId = a.OwnerId;
    			if (ownerId == null || savvyAdmin.Id == ownerId) {
    				ownerId = sysGen.Id;
    			}
    			//System.debug('1> ownId: ' + ownerId + ' | Sadmin: ' + savvyAdmin.Id + ' | leown: ' + a.OwnerId + ' | sysgen:' + sysGen.Id);
    			if (a.Account__c == null) {
    				//Check for an account
    				//System.debug('Checking for an account... ' + a.First_Name__c);
    				List<Account> accList = SOQLSingletonQueries.searchAccounts(a);
    				Account acc = null;
    				if (accList.isEmpty()) {
    					//System.debug('Creating an account... ' + a.First_Name__c);
    					acc = new Account();
    					acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Person Account'].Id;
    					acc.FirstName = a.First_Name__c;
              acc.LastName = a.Last_Name__c;

              acc.Street_Address__c = a.Street_Address__c;
              acc.Suburb__c = a.Suburb__c;
              acc.State__c = a.State__c;
              acc.Postcode__c = a.Postcode__c;
              acc.PersonHomePhone = a.Home_Phone__c;
              acc.PersonOtherPhone = a.Work_Phone__c;
              acc.PersonMobilePhone = a.Mobile_Number__c;
              acc.PersonEmail = a.Email_Address__c;
              acc.OwnerId = ownerId;
              insert acc;
    				} else {
    					//System.debug('Account found it... ');
    					acc = accList.get(0);
    				}
    				a.Account__c = acc.Id;
    				a.OwnerId = ownerId;
    				//System.debug('2> ownId: ' + ownerId + ' | Sadmin: ' + savvyAdmin.Id + ' | leown: ' + a.OwnerId + ' | sysgen:' + sysGen.Id);
    			}
    		}
    	}
    }
    //  -

    public static void dataChecker(List<Lead__c> newList) {
    	if (newList != null) {
    		for (Lead__c a: newList) {
          // Name
          a.Name = a.First_Name__c + ' ' + a.Last_Name__c;
          // Mobile
            a.Mobile_Number__c = StringUtils.removeSpaces(a.Mobile_Number__c);
          // Calculate State
          if (String.isBlank(a.State__c)) {
            a.State__c = PostcodeHelper.getState(a.Postcode__c);
          }
          // Check Loan Type
          a.Loan_Type__c = getValidLoanType(a.Loan_Type__c);
          // Check for BCCL
          if (
            ('Car Loan'.equals(a.Loan_Type__c) && 
            (!'Excellent'.equalsIgnoreCase(a.Credit_History__c) && !'Average'.equalsIgnoreCase(a.Credit_History__c) && !'Not Sure'.equalsIgnoreCase(a.Credit_History__c))
            ) ||
            (
              'Personal Loan'.equals(a.Loan_Type__c) &&
              String.isNotBlank(a.Loan_For__c) && 
              'Bike,Boat,Car,Caravan,Car Loan,JetSki,Vehicle Purchase'.containsIgnoreCase(a.Loan_For__c) &&
              !'Centrelink - Family Tax Benefits/Other'.equals(a.Employment_Status__c) &&
              a.Finance_Amount__c >= 5000 &&
              String.isNotBlank(a.Credit_History__c) && 
              !'Excellent'.equalsIgnoreCase(a.Credit_History__c)
            )
            ) {
            a.Loan_Type__c = 'Bad Credit Car Loan';
          } 
          if ('Other'.equals(a.Loan_Type__c)) {
            a.Loan_Type__c = 'Personal Loan';
          }
    		}
    	}
    }

    //public static void checkLeads(List<Lead__c> newList) {

    //}

    public static void checkDuplicates(List<Lead__c> newList) {

    	// Lead phones 
    	Set<String> phones = new Set<String>();
      Set<String> extPhones = new Set<String>();
    	
    	Decimal timeLimit = SOQLSingletonQueries.getLeadDuplicateTimeParam();
    	Datetime limitDate = Datetime.now().addMinutes(timeLimit.intValue() * (-1));
      // Id partnerId = null;
      for (Lead__c a : newList) {
    		phones.add(a.Mobile_Number__c);
        // if (a.Partner_Owner__c != null && partnerId == null) {
        //   partnerId = a.Partner_Owner__c;
        // }
    	}
      
    	List<Lead__c> leads = [
        SELECT Id, Mobile_Number__c, External_Lead__c 
        FROM Lead__c 
        WHERE Mobile_Number__c in :phones 
        AND Employment_Status__c != 'Unemployed'
        AND CreatedDate >= :limitDate
        // AND Partner_Owner__c = :partnerId
      ];
      
      phones = new Set<String>();
    	for (Lead__c a : leads) {
    		phones.add(a.Mobile_Number__c);
        if (a.External_Lead__c) {
          extPhones.add(a.Mobile_Number__c);
        }
    	}

      for (Lead__c a : newList) {
        if (StringUtils.isTestData(a.First_Name__c) || StringUtils.isTestData(a.Last_Name__c)) {
          a.Status__c = 'Closed Lead';
          a.Reason_for_closure__c = 'Wrong Number or Details';
          a.Automatic_Closure__c = true;
          a.Notes__c = 'First name/last name is Test :/';
        } else if (phones.contains(a.Mobile_Number__c)) {
            a.Status__c = 'Closed Lead';
            a.Reason_for_closure__c = 'Duplicate Lead';
            a.Automatic_Closure__c = true;
            if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
              a.External_Lead__c = extPhones.contains(a.Mobile_Number__c);
            }
        }
      }
    }

    public static String getLoanTypeFormApp(String assetType) {
    	String r = null;
    	if (String.isNotBlank(assetType)) {
    		if ('Car'.equalsIgnoreCase(assetType)) {
    			r = 'Car Loan';
    		} else if ('Personal'.equalsIgnoreCase(assetType)) {
    			r = 'Personal Loan';
    		} else if (assetType.containsIgnoreCase('Bike') ||
    				   assetType.containsIgnoreCase('Boat') ||
    				   assetType.containsIgnoreCase('Caravan') ||
					   assetType.containsIgnoreCase('Motorhome') ||
					   assetType.containsIgnoreCase('Camper') ||
    				   'JetSki'.equalsIgnoreCase(assetType)) {
    			r = 'Leisure Loan';
    		} else if (assetType.containsIgnoreCase('Aircraft') ||
    				   assetType.containsIgnoreCase('Truck') ||
					   assetType.containsIgnoreCase('Commercial') ||
    				   'Equipment'.equalsIgnoreCase(assetType)) {
    			r = 'Commercial Loan';
    		} else if ('Home'.equalsIgnoreCase(assetType)) {
    			r = 'Home Loan';
    		} else {
    			r = assetType;
    		}
    	}
    	return r;
    }

	public static String getValidLoanType(String assetType) {
    	String r = assetType;
    	if (String.isNotBlank(assetType)) {
    		if (assetType.equalsIgnoreCase('Car')) {
          r = 'Car Loan';
        } else if (assetType.containsIgnoreCase('Bike') ||
    				 assetType.containsIgnoreCase('Boat') ||
    				 assetType.containsIgnoreCase('Caravan') ||
					   assetType.containsIgnoreCase('Motorhome') ||
					   assetType.containsIgnoreCase('Camper') ||
    				 'JetSki'.equalsIgnoreCase(assetType)) {
    			r = 'Leisure Loan';
    		} else if (assetType.containsIgnoreCase('Aircraft') ||
    				   assetType.containsIgnoreCase('Truck') ||
					   assetType.containsIgnoreCase('Commercial') ||
    				   'Equipment'.equalsIgnoreCase(assetType)) {
    			r = 'Commercial Loan';
    		}
    	}
    	return r;
	}
	
    //  Lelo                    2018-08-08
    public static void suggestAnOwner(List<Lead__c> newList) {
      System.debug('suggestAnOwner...');
      if (newList != null) {
        User sysGen = SOQLSingletonQueries.recs().sysGenUser;
        User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
        Id pdo = null;
        for (Lead__c a: newList) {
          if (a.Partner_Owner__c != null) {
            if (a.OwnerId == sysGen.Id || a.OwnerId == savvyAdmin.Id) {
              if (pdo == null) {
                pdo = PartnerCommunityController.getPartnerDefaultOwner(a.Partner_Owner__c);
              }
              a.OwnerId = pdo != null? pdo : a.OwnerId;
            }
          } else {
            if ('New Lead'.equals(a.Status__c)) {
              List<Account> accList = SOQLSingletonQueries.searchAccounts(a);
              Set<Id> accIdList = new Set<Id>();
              for (Account x : accList) {
                accIdList.add(x.Id);
              }
              System.debug('Accounts: ' + accList.size());
              if (!accIdList.isEmpty()) {
                // Search for the most recent opps
                Set<Id> owners = SOQLSingletonQueries.getMostRecentOpportunityOwnersByAccount(accIdList);
                System.debug('Total potencial owners: ' + owners.size());
                for (Id i : owners) {
                  if (sysGen.Id != i && savvyAdmin.Id != i && SOQLSingletonQueries.isActiveConsultantUser(i)) {
                    // Suggest owner
                    a.Suggested_Owner__c = i;
                    System.debug('Owners suggested: ' + a.Suggested_Owner__c);
                    break;
                  }
                }
              }
            }
          }
        }
      }
    }
    //  -

  //  // Lelo 					2016-12-27
  //  public static void unresolveLeadOnUpdate(List<Lead__c> newList, Map<Id, Lead__c> oldMap){
		
		//for(Lead__c newLead : newList){
  //          System.debug(newLead.Status__c + '|' + oldMap.get(newLead.id).Status__c);
  //          if ('Unresolved Lead'.equals(newLead.Status__c) &&
  //              !'Unresolved Lead'.equals(oldMap.get(newLead.id).Status__c)) {
  //              newLead.Status__c = oldMap.get(newLead.id).Status__c;
  //          }
  //      }
  //  }
  //  //-
	
  /*public static void checkCallCenterSent(List<Lead__c> newList, Map<Id, Lead__c> oldMap){
        Set<Id> leadIds = new Set<Id>();
        for (Lead__c newLead : newList) {
            
            leadIds.add(newLead.id);
        }
        
        if(!leadIds.isEmpty()){
             LeadShareService.createShares(leadIds);
        }
    }*/

  public static void bucketChecker(List<Lead__c> newList){
    if (newList == null || newList.isEmpty()) { return; }
    List<AggregateResult> d = null;
    String bt = null;
    Integer hl1 = 0;
    Integer hl2 = 0;
		String uprofile = SOQLSingletonQueries.getCurrentUserProfileName();
		Boolean isSalesUser = false;
    Boolean distributeThisLead = false;
		if (uprofile.containsIgnoreCase('Sales Consultant')) {
			isSalesUser = true;
		}
    if (!isSalesUser && !SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      for (Lead__c a : newList) {
        if ('New Lead'.equals(a.Status__c) && !'Small Loans'.equals(a.Bucket_Type__c) && !'BCCL'.equals(a.UTM_Campaign__c)) {
          if ('Unemployed'.equals(a.Employment_Status__c) || 'Centrelink - Newstart only'.equals(a.Employment_Status__c)) {
            // UNEMPLOYED
            a.Bucket_Type__c = 'Unemployed';
          } else if ('Home Loan'.equals(a.Loan_Type__c) && 'New Lead'.equals(a.Status__c)) {
            // HOME LOANS
            // if (d == null) {
            // 	d = [
            // 		SELECT Bucket_Type__c, count(Id) total FROM Lead__c
            // 		WHERE CreatedDate = TODAY AND Loan_Type__c = 'Home Loan'
            // 		AND Status__c != 'Closed Lead' AND Reason_for_closure__c != 'Duplicate Lead'
            // 		GROUP BY Bucket_Type__c
            // 	];
            // 	if (!d.isEmpty()) {
            // 		for (AggregateResult x : d) {
            // 			if ('Home Loan'.equals(x.get('Bucket_Type__c'))) {
            // 				hl1 = (Integer)x.get('total');
            // 			} else if ('HLII'.equals(x.get('Bucket_Type__c'))) {
            // 				hl2 = (Integer)x.get('total');
            // 			}
            // 		}
            // 	}
            // }
            // if (hl1 < hl2) {
            // 	bt = 'Home Loan';
            // 	hl1++;
            // } else {
            // 	bt = 'HLII';
            // 	hl2++;
            // }
            // a.Bucket_Type__c = bt;
            a.Bucket_Type__c = 'HLII';
          } else if ('Insurance'.equals(a.Loan_Type__c)) {
            // INSURNCES
            a.Bucket_Type__c = 'Insurance';
          } else if ('Student VISA'.equals(a.Residential_Status__c) || 'Bridging VISA'.equals(a.Residential_Status__c)) {
            // INSURNCES
            a.Bucket_Type__c = 'Visa Exceptions';
          } else if ('Personal Loan'.equals(a.Loan_Type__c) &&
                  'Excellent'.equalsIgnoreCase(a.Credit_History__c) &&
                  a.Finance_Amount__c >= 5000 &&
                !'Centrelink - Family Tax Benefits/Other'.equals(a.Employment_Status__c)
          ) {
            // PERSONAL LOANS
            a.Bucket_Type__c = '8k PL';
            distributeThisLead = true;
          } else {
            if (
              (('Personal Loan'.equals(a.Loan_Type__c) && 
              (!'Excellent'.equalsIgnoreCase(a.Credit_History__c) ||
              ('Excellent'.equalsIgnoreCase(a.Credit_History__c) && a.Finance_Amount__c < 5000) ||
              'Centrelink - Family Tax Benefits/Other'.equals(a.Employment_Status__c))) ||
              (a.Finance_Amount__c < 8000 && 'Centrelink - Family Tax Benefits/Other'.equals(a.Employment_Status__c)) ||
              a.Finance_Amount__c < 5000
              ) && 
              (!(String.isNotBlank(a.Loan_For__c) && 'Bike,Boat,Car,Caravan,Car Loan,JetSki,Vehicle Purchase'.containsIgnoreCase(a.Loan_For__c) &&
                a.Finance_Amount__c >= 5000 && !'Centrelink - Family Tax Benefits/Other'.equals(a.Employment_Status__c))) &&
              (!'Bad Credit Car Loan'.equals(a.Loan_Type__c))
            ) {
              a.Bucket_Type__c = 'Money3';
            } else if (!(
                  (String.isBlank(a.Credit_History__c) || 
                  (!'Excellent'.equalsIgnoreCase(a.Credit_History__c) && !'Average'.equalsIgnoreCase(a.Credit_History__c))
                  ) && 
                  a.Finance_Amount__c < 5000)
            ) {
              a.Bucket_Type__c = 'Sales';
              distributeThisLead = true;
            }
          }

        }
        if (
          distributeThisLead &&
          String.isBlank(a.Partner_Owner__c) &&
          String.isBlank(a.Application__c) &&
          !'Novated Lease'.equals(a.qq_form__c) &&
          (
            'Employed'.equals(a.Employment_Status__c) ||
            'Full Time'.equals(a.Employment_Status__c) ||
            'Self Employed'.equals(a.Employment_Status__c)
          )
        ) {
          // distribution
          distributeLead(a);

          // if (
          //   a.Application__c == null &&
          //   (
          //     (
          //       'Car Loan'.equals(a.Loan_Type__c) &&
          //       'Excellent'.equalsIgnoreCase(a.Credit_History__c) &&
          //       a.Finance_Amount__c >= 15000 && 
          //       (
          //         'Employed'.equals(a.Employment_Status__c) ||
          //         'Full Time'.equals(a.Employment_Status__c)
          //       )
          //     ) || 
          //     (
          //       'Commercial Loan'.equals(a.Loan_Type__c) &&
          //       'Excellent'.equalsIgnoreCase(a.Credit_History__c)
          //     )
          //   )
          // ) {
          //   distributeLead(a);
          // }
        }
			// System.debug(a.Name + ': ' + a.Bucket_Type__c);
      }
    }
  }

	public static void assosiateCampaign(List<Lead__c> newList) {
		System.debug('assosiating Campaign and List...');
		if (newList == null || newList.isEmpty()) { return; }
		for (Lead__c a : newList) {
      if (!a.External_Lead__c && String.isBlank(a.Partner_Owner__c)) {
        ipSCAPECampaignSettings__c cs = ipSCAPEService.getCampaignSetting(a);
        if (cs != null) {
          a.CC_Campaign_ID__c = cs.Campaign_ID__c;
          a.CC_List_ID__c = cs.List_ID__c;
        }
      }
		}
		System.debug('assosiating Campaign and List... total: ' + newList.size());
	}

	public static Id callCenterService(List<Lead__c> newList, Boolean forceExecution){
		System.debug('callCenterService...');
		Id jobID = null;
		ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
		if (!(s.Automatic_Mode__c || forceExecution)) {
			System.debug('Automatic Process is OFF.');
			return jobID;
		}
		// CallCenterBatchSender p = null;
		List<Id> leadIds = new List<Id>();
		for (Lead__c a: newList) {
			if (
        !a.External_Lead__c && a.Partner_Owner__c == null &&
        (
          'Sales'.equals(a.Bucket_Type__c) || '8k PL'.equals(a.Bucket_Type__c) || 'Money3'.equals(a.Bucket_Type__c)
        )
      ) {
				leadIds.add(a.Id);
			} else {
				System.debug('lead not allowed to be sent. ' + a.Id);
			}
		}
		if (!leadIds.isEmpty()) {
			ipSCAPEService.sendLeads(leadIds);
			/*
			// if (!Test.isRunningTest()) {
				p = new CallCenterBatchSender(leadIds);
				jobID = database.executeBatch(p);
			// }
			*/
		}
		return jobID;
	}

	public static Id sendToCallCenter() {
		return sendToCallCenter(100);
	}

	public static Id sendToCallCenter(Integer records) {
		List<Lead__c> leads = [
			Select Id, Name, Status__c, Bucket_Type__c, External_Lead__c, Partner_Owner__c From Lead__c
			Where Status__c = 'New Lead'
			And Bucket_Type__c in ('Sales','8k PL','Money3')
			And CC_Lead_ID__c = null
			And CC_Campaign_ID__c != null
			And CC_List_ID__c != null
			LIMIT :records
		];
		return callCenterService(leads, true);
	}

	public static void invokeCallCenterProcesses(List<Lead__c> leads) {
    // Preparing lead details
    checkDuplicates(leads);
    dataChecker(leads);
    bucketChecker(leads);
    assosiateCampaign(leads);
	}

	public static void completeCCLeads(List<Lead__c> newRecords) {
		if (newRecords == null || newRecords.isEmpty()) return;
		Set<Id> ids = new Set<Id>();
		for (Lead__c a : newRecords) {
			ids.add(a.Id);
		}
		if (!ids.isEmpty()) {
			ipSCAPEService.completeLeads(ids);
		}
	}

  /*******************************************************************************************************
  * @author Lelo
  * @date 19/04/2021 
  * @description distribute clean leads between an internal and external pool
  * @param lead object with all data related with the lead
  */
  public static void distributeLead(Lead__c lead) {
    System.debug('Distributing leads...');
    if (lead == null) return;
    if (SOQLSingletonQueries.recs().isBrokerPartnerUser) return;
    // if (!'Sales'.equals(lead.Bucket_Type__c) &&
		// 	  !'8k PL'.equals(lead.Bucket_Type__c) &&
		// 		!'Money3'.equals(lead.Bucket_Type__c)) {
		// 		return;
		// }
    Boolean isOn = false;
    Decimal perc = 0.0;
    Parameters_Service__c param =  Parameters_Service__c.getInstance(EXT_LEAD_SETTING_ACTIVE);
    
    if (param != null && 'ON'.equalsIgnoreCase(param.value__c)) {
      param =  Parameters_Service__c.getInstance(EXT_LEAD_SETTING_PERCENTAGE);
      if (param != null) {
        perc = NumberUtils.convertToDecimal(param.value__c, false) / 100;
        if (perc > 0) {
          isOn = true;
        }
      }      
    }

    if (isOn) {
      param =  Parameters_Service__c.getInstance(EXT_LEAD_SETTING_STARTING_TIME);
      Datetime startingTime = param.Datetime_Value__c;
      // System.debug('Distribution active! [days: ' + days + '] [perc: ' + perc.format() + '%] [start: ' + startingTime + ']');
      System.debug('Distribution active! [days: TODAY] [perc: ' + perc.format() + '%] [start: ' + startingTime + ']');
      if (startingTime != null && Datetime.now() < startingTime) {
        System.debug('Starting Time not reached to distribute leads!');
        return;
      }

      // List<String> buckets = new List<String>{'Sales','8k PL','Money3'};
      // // String q = 'SELECT External_Lead__c, Count(Id) total FROM Lead__c WHERE (createdDate = LAST_N_DAYS:' + days + ') AND (Bucket_type__c in :buckets) ';
      // // String q = 'SELECT External_Lead__c, Count(Id) total FROM Lead__c WHERE (createdDate = THIS_MONTH) AND (Bucket_type__c in :buckets) ';
      // String q = 'SELECT External_Lead__c, Count(Id) total FROM Lead__c WHERE (createdDate = TODAY) AND (Bucket_type__c in :buckets) ';
      // if (startingTime != null) {
      //   q += 'AND (createdDate >= :startingTime) ';
      // }
      // q += 'GROUP BY External_Lead__c';

      // List<AggregateResult> result = Database.query(q);
      // Decimal totalInternalLeads = 0;
      // Decimal totalExternalLeads = 0;
      // for (AggregateResult a: result) {
      //   if ((Boolean)a.get('External_Lead__c')) {
      //     totalExternalLeads = (Decimal)a.get('total');
      //   } else {
      //     totalInternalLeads = (Decimal)a.get('total');
      //   }
      // }
      // Decimal totalLeads = totalInternalLeads + totalExternalLeads;
      // System.debug('Total leads: '+totalLeads+' internal['+totalInternalLeads+'] external['+totalExternalLeads+']');
      // if (totalLeads > 0 || perc == 1.0) {
        // Calculate percentages
        // Distributor extDist = new Distributor(perc, totalExternalLeads, totalLeads);
        // Distributor intDist = new Distributor(1.00 - perc, totalInternalLeads, totalLeads);
        // System.debug(JSON.serializePretty(intDist));
        // if (!extDist.isOver() || perc == 1.0) {
          // Id accId = distributeAccount(days, startingTime);
          External_Lead_Setting__c dis = distributeAccount(startingTime, lead);
          if (dis != null) {
            System.debug('Account selected: ' + dis.Account__c + ' [' + dis.Account__r.Default_Ownership__c + ']');
            // lead.Account__c = accId;
            lead.Partner_Owner__c = dis.Account__c;
            lead.External_Lead__c = true;
            lead.Status__c = 'New Lead';
            if (String.isNotBlank(dis.Account__r.Default_Ownership__c)) {
              lead.OwnerId = dis.Account__r.Default_Ownership__c;
            }
            // lead.Reason_for_closure__c = 'No longer Proceeding - Response Saved';
            // lead.Notes__c = 'External lead!';
          } else {
            System.debug('Account not selected, there is not any account available!');
          }
        // }
      // }
    }
  }

  /*******************************************************************************************************
  * @author Lelo
  * @date 19/04/2021 
  * @description select which account should be assigned to a lead
  * @param startingTime when statistics should be counted, it can be null
  */
  public static External_Lead_Setting__c distributeAccount(Datetime startingTime, Lead__c lead) {
    // Load account settings
    Datetime now = Datetime.now();
    Decimal fa = lead.Finance_Amount__c;
    
    Set<String> loanTypes = new Set<String>{'All',lead.Loan_Type__c};
    String q = 'SELECT Account__c, Account__r.Name, Weight__c, Limit__c, ';
    q += 'Limit_Rotation__c, Min_Loan_Amount__c, Start_Date__c, Bad_Credit_Limit__c, ';
    q += 'Max_Daily__c, Loan_Type__c, Account__r.Default_Ownership__c, Credit_History_Leads__c ';
    q += 'FROM External_Lead_Setting__c WHERE Active__c = true ';
    q += 'AND (Start_Date__c = null OR Start_Date__c <= :now) ';
    q += 'AND (Min_Loan_Amount__c = null OR Min_Loan_Amount__c <= :fa) ';
    if (DateUtils.isWeekend()) {
      q += 'AND Exclude_Weekends__c = false ';
    }
    q += 'AND (Loan_Type__c IN :loanTypes) ';
    // Add Credit History
    q += 'AND (Credit_History_Leads__c includes (\'' + lead.Credit_History__c + '\')) ';
    // Ordering
    q += 'ORDER BY Min_Loan_Amount__c DESC';
    List<External_Lead_Setting__c> d = Database.query(q);
    System.debug('Total External Lead Accounts: ' + d.size());
    if (d.isEmpty()) return null;

    Map<Id, External_Lead_Setting__c> monthlyAccounts = new Map<Id, External_Lead_Setting__c>();
    Set<Id> limitedBcAccounts = new Set<Id>();
    for (External_Lead_Setting__c a: d) {
      if ('Monthly'.equals(a.Limit_Rotation__c)) {
        monthlyAccounts.put(a.Account__c, a);
      }
      if (a.Bad_Credit_Limit__c > 0.00) {
        List<String> vals = a.Credit_History_Leads__c.split(';');
        if (
          !vals.isEmpty() &&
          (
            !vals.contains('Excellent') ||
            vals.size() > 1
          )
        ) {
          limitedBcAccounts.add(a.Account__c);
        }
      }
    }
    System.debug('Total monthlyAccounts: ' + monthlyAccounts.size());
    System.debug('Total limitedBcAccounts: ' + limitedBcAccounts.size());

    Id sysAdmin = SOQLSingletonQueries.recs().sysAdminUser.Id;

    // load current totals
    q = 'SELECT Partner_Owner__c, Count(Id) total FROM Lead__c ';
    // q += 'WHERE (createdDate = LAST_N_DAYS:' + days + ') ';
    // q += 'WHERE (createdDate = THIS_MONTH) ';
    q += 'WHERE (createdDate = TODAY) ';
    q += 'AND (External_Lead__c = true) ';
    q += 'AND (CreatedById = :sysAdmin) ';
    q += 'AND (Reason_for_closure__c != \'Duplicate Lead\') ';
    
    if (startingTime != null) {
      q += 'AND (createdDate >= :startingTime) ';
    }
    q += 'GROUP BY Partner_Owner__c';

    List<AggregateResult> totalList = Database.query(q);
    // load current totals
    Map<Id, Decimal> totalExtLeadsMap = new Map<Id, Decimal>();
    for (AggregateResult a: totalList) {
      totalExtLeadsMap.put((Id)a.get('Partner_Owner__c'), (Decimal)a.get('total'));
    }
    
    Map<Id, Decimal> monthlyExtLeadsMap = new Map<Id, Decimal>();
    if (!monthlyAccounts.isEmpty()) {
      Set<Id> ids = monthlyAccounts.keySet();
      // load monthly totals
      q = 'SELECT Partner_Owner__c, Count(Id) total FROM Lead__c ';
      q += 'WHERE (createdDate = THIS_MONTH) ';
      q += 'AND (External_Lead__c = true) ';
      q += 'AND (Partner_Owner__c IN :ids) ';
      q += 'AND (CreatedById = :sysAdmin) ';
      q += 'AND (Reason_for_closure__c != \'Duplicate Lead\') ';
      if (startingTime != null) {
        q += 'AND (createdDate >= :startingTime) ';
      }
      q += 'GROUP BY Partner_Owner__c';
      totalList = Database.query(q);
      // load current totals      
      for (AggregateResult a: totalList) {
        monthlyExtLeadsMap.put((Id)a.get('Partner_Owner__c'), (Decimal)a.get('total'));
      }
    }

    // Verify Bad Credit
    Boolean isBadCredit = !'Excellent'.equals(lead.Credit_History__c);
    System.debug('isBadCredit: ' + isBadCredit);
    Map<Id, Decimal> monthlyBCExtLeadsMap = new Map<Id, Decimal>();
    if (isBadCredit && !limitedBcAccounts.isEmpty()) {
      // load monthly totals
      q = 'SELECT Partner_Owner__c, Count(Id) total FROM Lead__c ';
      q += 'WHERE (createdDate = THIS_MONTH) ';
      q += 'AND (External_Lead__c = true) ';
      q += 'AND (Partner_Owner__c IN :limitedBcAccounts) ';
      q += 'AND (CreatedById = :sysAdmin) ';
      q += 'AND (Reason_for_closure__c != \'Duplicate Lead\') ';
      if (startingTime != null) {
        q += 'AND (createdDate >= :startingTime) ';
      }
      q += 'AND (Credit_History__c != \'Excellent\') ';
      q += 'GROUP BY Partner_Owner__c';
      totalList = Database.query(q);
      // load current totals      
      for (AggregateResult a: totalList) {
        monthlyBCExtLeadsMap.put((Id)a.get('Partner_Owner__c'), (Decimal)a.get('total'));
      }
    }
    System.debug('Total monthlyBCExtLeadsMap: ' + monthlyBCExtLeadsMap.size());
    // Check limits
    List<Distributor> disList = new List<Distributor>();
    Decimal totalExtLeads = 0.00;
    Decimal totalWeight = 0.0;
    for (External_Lead_Setting__c a: d) {
      Distributor dis = new Distributor(a);
      if (totalExtLeadsMap.containsKey(a.Account__c)) {
        dis.count = totalExtLeadsMap.get(a.Account__c);
      }
      if (monthlyExtLeadsMap.containsKey(a.Account__c)) {
        dis.countMonthly = monthlyExtLeadsMap.get(a.Account__c);
      }
      if (isBadCredit && monthlyBCExtLeadsMap.containsKey(a.Account__c)) {
        dis.checkBadCredit = true;
        dis.countBcMonthly = monthlyBCExtLeadsMap.get(a.Account__c);
      }
      // Validate limits
      if (!dis.isLimitExceeded()) {
        disList.add(dis);
        // Calculate total Ext. Leads
        totalExtLeads += dis.count;
        // Calculate total weight
        totalWeight += a.Weight__c > 0? a.Weight__c : 0.0;
      } else {
        System.debug('Account excluded: [' + a.Account__c + '] limit reached! ' + a.Limit__c);
      }
    }
    System.debug('disList: ' + JSON.serializePretty(disList));
    // Calculate current percentages
    Map<Id, External_Lead_Setting__c> ids = new Map<Id, External_Lead_Setting__c>();
    Decimal minDiff = 0.00;
    for (Distributor dis : disList) {
      dis.perc = dis.weight / totalWeight;
      dis.total = totalExtLeads;
      System.debug('Account: ' + dis.accountId + ' perc[' + dis.perc +'] current[' + dis.getCurrPerc() +'] diff[' + dis.getDiff() +'] over?['+dis.isOver()+']');
      // System.debug(JSON.serializePretty(dis));
      // Check conditions
      Boolean excludeDis = false;
      // Finance amount
      // if (dis.setting.Min_Loan_Amount__c > 0 && lead.Finance_Amount__c < dis.setting.Min_Loan_Amount__c) {
      //   excludeDis = true;
      //   System.debug('Account excluded: [' + dis.setting.Account__r.Name + '] Loan Amount low ' + lead.Finance_Amount__c + ' min. expected: ' + dis.setting.Min_Loan_Amount__c);
      // }

      if (!excludeDis && !dis.isOver()) {
        if (ids.isEmpty()) {
          minDiff = dis.getDiff();
          ids.put(dis.accountId, dis.setting);
        } else if (minDiff == dis.getDiff()) {
          ids.put(dis.accountId, dis.setting);
        } else if (dis.getDiff() > minDiff) {
          minDiff = dis.getDiff();
          ids.clear();
          ids.put(dis.accountId, dis.setting);
        }
      }
    }
    if (!ids.isEmpty()) {
      if (ids.size() == 1) {
        return ids.values().get(0);
      } else {
        Integer idx = Integer.valueof((Math.random() * ids.size()));
        System.debug('Account available: ' + ids);
        return ids.values().get(idx);
      }
    }
    // 
    return null;
  }

  public class Distributor {

    Id accountId {set;get;}
    Decimal perc {set;get;}
    Decimal weight {set;get;}
    Decimal count {set;get;} 
    Decimal myLimit {set;get;}
    Decimal total {set;get;}
    Decimal countMonthly {set;get;} 
    Decimal myLimitMonthly {set;get;}
    Decimal countBcMonthly {set;get;}
    Boolean checkBadCredit {set;get;}

    External_Lead_Setting__c setting {set;get;}

    private Distributor() {
      checkBadCredit = false;
      this.perc = 0.00;
      this.count = 0.00;
      this.total = 0.00;
      this.myLimitMonthly = 0.0;
      this.countMonthly = 0.00;
      this.countBcMonthly = 0.00;
    }

    public Distributor (External_Lead_Setting__c setting) {
      this();
      this.setting = setting;
      this.accountId = setting.Account__c;
      this.weight = setting.Weight__c;
      if ('Daily'.equals(setting.Limit_Rotation__c)) {
        this.myLimit = setting.Limit__c;
      } else if ('Monthly'.equals(setting.Limit_Rotation__c)) {
        this.myLimit = setting.Max_Daily__c;
        this.myLimitMonthly = setting.Limit__c;
      }
    }

    public Distributor (Decimal perc, Decimal count, Decimal total) {
      this();
      this.perc = perc;
      this.count = count;
      this.total = total;
    }

    public Decimal getCurrPerc() {
      return this.total > 0? this.count / this.total : 0.00;
    }

    public Decimal getDiff() {
      return this.perc - this.getCurrPerc();
    }

    public Boolean isOver() {
      return this.isLimitExceeded() || this.getDiff() < 0;
      /*
      if (
        this.myLimitMonthly > 0 && this.countMonthly > this.myLimitMonthly &&
        !this.checkBadCredit
      ) {
        r = false;
        System.debug('isOver result A: ' + r);
      } else if (
        (this.myLimit > 0 && this.count >= this.myLimit) ||
        this.getDiff() < 0
      ) {
        System.debug('isOver result B: ' + r);
        if (
          this.checkBadCredit && this.setting != null &&
          this.setting.Bad_Credit_Limit__c > 0.00
         ) {
          System.debug('isOver result B.Y: ' + r);
          Decimal x = (this.countBcMonthly/this.countMonthly)*100;
          System.debug('isOver: x['+ x +'] Bad_Credit_Limit__c['+ this.setting.Bad_Credit_Limit__c +']');
          r = (
            this.countMonthly > 0 &&
            x < this.setting.Bad_Credit_Limit__c
          );
        } else {
          System.debug('isOver result B.N: ' + r);
          r = true;
        }
      }
      System.debug('isOver final result: ' + r);
      return r;
      */
    }

    public Boolean isLimitExceeded() {
      Boolean r = (
        (
          this.myLimitMonthly > 0 && 
          this.countMonthly > this.myLimitMonthly
        ) ||
        (
          this.myLimit > 0 && this.count >= this.myLimit
        )
      );
      r = !r? isBcOver() : r;
      return r;
    }

    public Boolean isBcOver() {
      Decimal x = this.countMonthly > 0? (this.countBcMonthly/this.countMonthly)*100 : 0;
      return (
        this.checkBadCredit && this.setting != null && this.setting.Bad_Credit_Limit__c > 0.00 && x >= this.setting.Bad_Credit_Limit__c
      );
    }

  }
    
  public static Lead__c getRecentExternalLead(String phone, String email) {
    System.debug('getLeadsByPhoneOrEmail....');
    Lead__c r = null;
    if (String.isNotBlank(phone) || String.isNotBlank(email)) {
      String q = 'SELECT Id, Partner_Owner__c, OwnerId FROM Lead__c WHERE (CreatedDate = LAST_N_DAYS:5) ';
      if (String.isNotBlank(phone)) {
        q += 'AND (Mobile_Number__c = :phone ';
      }
      if (String.isNotBlank(email)) {
        q += 'OR Email_Address__c = :email) ';
      }
      q += 'AND Status__c != \'Closed Lead\' ';
      q += 'ORDER BY LastModifiedDate DESC LIMIT 1';
      System.debug('sql:' + q);
      try {
        List<Lead__c> d = Database.query(q);
        // System.debug('Total records: ' + d.size());
        r = !d.isEmpty()? d.get(0) : r;
        //System.debug('Total found records: ' + r.size());
      } catch (System.QueryException e) {}
    }
    return r;
  }
}