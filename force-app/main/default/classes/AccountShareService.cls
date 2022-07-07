public without sharing class AccountShareService {
	
    public static void createShares(Set<Id> acctIds){
      if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
        List<AccountShare> acctShares = new List<AccountShare>();
        Id userOrGroupId = SOQLSingletonQueries.recs().savvyTeamGroup.Id;
        AccountShareService.deleteShares(acctIds);
        for (Id accountId: acctIds) {
          acctShares.add(new AccountShare(UserOrGroupId=userOrGroupId, AccountId=accountId, AccountAccessLevel='Edit', OpportunityAccessLevel='Read', CaseAccessLevel='Read'));
        }
      
        if(!acctShares.isEmpty()){
          Database.SaveResult[] result = Database.Insert(acctShares, false);
	      }
      }
    }
    
    public static void deleteShares(Set<Id> acctIds){
    	List<AccountShare> acctSharesDel = SOQLSingletonQueries.setAccountIds(acctIds).accountSharesByAccountIds;
	    if(!acctSharesDel.isEmpty()){
	    	delete acctSharesDel;
	    }    	
    }
}