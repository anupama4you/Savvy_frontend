public without sharing class AppPreFlowController {

    public Lead__c leadSel {get;set;}
    private String leadId = null;
    private Boolean isLeadFlow = false;
	private Boolean isOtherOwner = false;
	private User sysGen = null;

	public AppPreFlowController() {
		String paramTmp = System.currentPageReference().getParameters().get('id');
	    isLeadFlow = false;
	    if (String.isNotBlank(paramTmp)) {
	      if (!paramTmp.startsWith('005')) {
	        leadId = paramTmp;
	        isLeadFlow = true;
	      }
	    }
	    sysGen = SOQLSingletonQueries.recs().sysGenUser;
	}

	public void processLead() {
		isOtherOwner = false;
		List<Lead__c> leadList = [SELECT Id, Name, OwnerId, First_Name__c, Last_Name__c, Street_Address__c, Suburb__c, State__c, Postcode__c, 
			                         Home_Phone__c, Work_Phone__c, Mobile_Number__c, Email_Address__c, account__r.createddate FROM Lead__c
			                      WHERE Id = :leadId];
        if (!leadList.isEmpty()) {
        	leadSel = leadList.get(0);
			if (leadSel.OwnerId == sysGen.Id) {
				leadSel.OwnerId = UserInfo.getUserId();
				if (isLeadFlow) {
					checkAccountCreation(leadSel);
				}
				update leadSel;  
			} else if (leadSel.Account__c == null) {
				checkAccountCreation(leadSel);
				update leadSel;
			}
        } 
	}

	public Boolean getHasLeadSelected() {
      if (this.leadSel != null) {
        return true;
      }
      return false;
    }

    public PageReference returnHome(){
        return new PageReference('/');
    }

    public void checkAccountCreation(Lead__c a) {
		if (a != null) {
			//User sysGen = SOQLSingletonQueries.recs().sysGenUser;
			//User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
			Id ownerId = UserInfo.getUserId();
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
					//check if the account ownership corresponds to another active consultant
					if (acc.OwnerId != ownerId) {
						if (SOQLSingletonQueries.isActiveConsultantUser(acc.OwnerId)) {
							isOtherOwner = true;
						} else {
							//AppPreFlowController.changeAccountOwnership(acc.Id, ownerId);
							//acc.OwnerId = ownerId;
							//update acc;
						}
					}
				}
				a.Account__c = acc.Id;
				//System.debug('2> ownId: ' + ownerId + ' | Sadmin: ' + savvyAdmin.Id + ' | leown: ' + a.OwnerId + ' | sysgen:' + sysGen.Id);
			}
		}
    }

    public static void changeAccountOwnership(Id accountId, Id newOwnerId) {
    	List<Account> aList = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :accountId];
    	if (!aList.isEmpty()) {
    		Account a = aList.get(0);
    		a.OwnerId = newOwnerId;
    		update a;
    	}
    }
}