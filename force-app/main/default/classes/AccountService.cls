public class AccountService {
  public static void checkAccEmailMobileDuplicate(List<Account> newList) {
    Map<String, Account> AccMap = new Map<String, Account>();
    Map<String, Account> AccMap2 = new Map<String, Account>();

    // Partner portal validation - exclude them
    if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      for (Account newAcct : newList) {
        if ((newAcct.PersonEmail != null || newAcct.PersonMobilePhone != null)) {
          if (AccMap.containsKey(newAcct.PersonEmail)) {
            newAcct.PersonEmail.addError(
              'Another new Account has the same email address.'
            );
          } else if (String.isNotBlank(newAcct.PersonEmail)) {
            AccMap.put(newAcct.PersonEmail, newAcct);
          }

          if (AccMap2.containsKey(newAcct.PersonMobilePhone)) {
            newAcct.PersonMobilePhone.addError(
              'Another new Account has the same Mobile number.'
            );
          } else if (String.isNotBlank(newAcct.PersonMobilePhone)) {
            AccMap2.put(newAcct.PersonMobilePhone, newAcct);
          }
        }
      }
    }

    if (!AccMap.keySet().isEmpty()) {
      for (
        Account Acc : SOQLSingletonQueries.setPersonEmails(AccMap.KeySet())
          .accountsByPersonEmails
      ) {
        if (Acc.PersonEmail != null && AccMap.get(Acc.PersonEmail) != null) {
          Account newAcc = AccMap.get(Acc.PersonEmail);
          if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
            newAcc.PersonEmail.addError(
              'An Account with this email address already exists.'
            );
          }
        }
      }
    }

    if (!AccMap2.keySet().isEmpty()) {
      for (
        Account Acc : SOQLSingletonQueries.setPersonMobilePhones(
            AccMap2.KeySet()
          )
          .accountsByPersonMobilePhones
      ) {
        if (
          Acc.PersonMobilePhone != null &&
          AccMap2.get(Acc.PersonMobilePhone) != null
        ) {
          Account newAcc = AccMap2.get(Acc.PersonMobilePhone);
          newAcc.PersonMobilePhone.addError(
            'An Account with this Mobile number already exists.'
          );
        }
      }
    }
  }

  public static void checkAccEmailMobileDuplicate(
    List<Account> newList,
    Map<Id, Account> oldMap
  ) {
    Map<String, Account> AccMap = new Map<String, Account>();
    Map<String, Account> AccMap2 = new Map<String, Account>();
    Set<Id> accOwnerIds = new Set<Id>();

    // Partner portal validation - exclude them
    if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      for (Account newAcct : newList) {
        if (newAcct.OwnerId != oldMap.get(newAcct.Id).OwnerId) {
          accOwnerIds.add(newAcct.ownerId);
        }

        if (
          (newAcct.PersonEmail != null &&
          newAcct.PersonEmail != oldMap.get(newAcct.Id).PersonEmail) ||
          (newAcct.PersonMobilePhone != null &&
          newAcct.PersonMobilePhone != oldMap.get(newAcct.Id).PersonMobilePhone)
        ) {
          if (AccMap.containsKey(newAcct.PersonEmail)) {
            newAcct.PersonEmail.addError(
              'Another new Account has the same email address.'
            );
          } else {
            AccMap.put(newAcct.PersonEmail, newAcct);
          }

          if (AccMap2.containsKey(newAcct.PersonMobilePhone)) {
            newAcct.PersonMobilePhone.addError(
              'Another new Account has the same Mobile number.'
            );
          } else {
            AccMap2.put(newAcct.PersonMobilePhone, newAcct);
          }
        }

        if (newAcct.logged_in_user__c == true) {
          newAcct.ownerId = userinfo.getUserId();
          newAcct.logged_in_user__c = false;
          newAcct.Opportunity_status__c = '';
        }
      }
    }

    if (!AccMap.keySet().isEmpty()) {
      for (
        Account Acc : SOQLSingletonQueries.setPersonEmails(AccMap.KeySet())
          .accountsByPersonEmails
      ) {
        if (Acc.PersonEmail != null && AccMap.get(Acc.PersonEmail) != null) {
          Account newAcc = AccMap.get(Acc.PersonEmail);
          newAcc.PersonEmail.addError(
            'An Account with this email address already exists.'
          );
        }
      }
    }

    if (!AccMap2.keySet().isEmpty()) {
      for (
        Account Acc : SOQLSingletonQueries.setPersonMobilePhones(
            AccMap2.KeySet()
          )
          .accountsByPersonMobilePhones
      ) {
        if (
          Acc.PersonMobilePhone != null &&
          AccMap2.get(Acc.PersonMobilePhone) != null
        ) {
          Account newAcc = AccMap2.get(Acc.PersonMobilePhone);
          newAcc.PersonMobilePhone.addError(
            'An Account with this Mobile number already exists.'
          );
        }
      }
    }
  }

  public static void accountSharing(List<Account> newList) {
    Set<Id> acctIds = new Set<Id>();
    for (Account a : newList) {
      if (a.isPersonAccount) {
        acctIds.add(a.id);
      }
    }

    if (!acctIds.isEmpty()) {
      AccountShareService.createShares(acctIds);
    }
  }

  public static void setDefaultOwnership(List<Account> newList) {
    if (newList == null || newList.isEmpty()) {
      return;
    }
    if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
      for (Account a : newList) {
        if (a.isPersonAccount && (a.OwnerId == null || a.OwnerId != sysGenId)) {
          if (
            String.isBlank(a.Id) || !SOQLSingletonQueries.recs().isSavvyAdmin()
          ) {
            a.OwnerId = sysGenId;
          }
        }
      }
    }
  }
  
  // public static void setLeadAndApplicationOwner(List<Account> newList, Map<Id, Account> oldMap){
  // 	Map<Id, Account> acctIdMap = new Map<Id, Account>();
  // 	List<Application__c> AppToUpdate = new List<Application__c>();
  // 	List<Lead__c> leads = new List<Lead__c>();

  // 	for (Account newAcct : newList) {
  // 		if(newAcct.OwnerId != oldMap.get(newAcct.Id).OwnerId ){
  // 			acctIdMap.put(newAcct.id, newAcct);
  // 		}

  // 	}

  // 	for(Lead__c ld : SOQLSingletonQueries.setAccountIds(acctIdMap.keySet()).becomeOpptyLeadsByAccountIds){
  // 		if(acctIdMap.get(ld.Account__c) != null && ld.OwnerId != acctIdMap.get(ld.Account__c).OwnerId){
  // 			ld.OwnerId = acctIdMap.get(ld.Account__c).OwnerId;
  // 			leads.add(ld);
  // 		}
  // 	}

  // 	for(Application__c app : SOQLSingletonQueries.setAccountIds(acctIdMap.keySet()).applicationsByAccountIds){
  // 		if(acctIdMap.get(app.Account__c) != null && app.OwnerId != acctIdMap.get(app.Account__c).OwnerId){
  // 			app.OwnerId = acctIdMap.get(app.Account__c).OwnerId;
  // 			AppToUpdate.add(app);
  // 		}
  // 	}

  // 	try{

  // 		if(!leads.isEmpty()){
  // 			update leads;

  // 		}
  // 		if(!AppToUpdate.isEmpty()){
  // 			update AppToUpdate;
  // 		}
  // 	}catch( Exception e){
  //          System.debug('@@ERROR:' + e.getMessage());
  //       }
  // }
}