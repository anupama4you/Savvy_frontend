public without sharing class LeadShareService {
  public static void createShares(Set<Id> leadIds) {
    List<Lead__Share> leadShares = new List<Lead__Share>();
    if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      Id sGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
      LeadShareService.deleteShares(leadIds);
      for (
        Custom_Opportunity__c opp : SOQLSingletonQueries.setLeadIds(leadIds)
          .opportunitiesByLeadIds
      ) {
        System.debug(opp.Name + ' | ' + opp.OwnerId);
        if (string.valueOf(opp.OwnerId).startsWith('005')) {
          leadShares.add(
            new Lead__Share(
              UserOrGroupId = opp.OwnerId,
              ParentId = opp.Lead__c,
              AccessLevel = 'Edit'
            )
          );
        } else {
          if (sGenId != null) {
            leadShares.add(
              new Lead__Share(
                UserOrGroupId = sGenId,
                ParentId = opp.Lead__c,
                AccessLevel = 'Edit'
              )
            );
          }
        }
      }
      if (!leadShares.isEmpty()) {
        Database.SaveResult[] result = Database.Insert(leadShares, false);
      }
    }
  }

  public static void deleteShares(Set<Id> leadIds) {
    List<Lead__Share> leadSharesDel = new List<Lead__Share>();
    for (
      Lead__Share s : SOQLSingletonQueries.setLeadIds(leadIds)
        .leadSharesByLeadIds
    ) {
      leadSharesDel.add(s);
    }

    if (!leadSharesDel.isEmpty()) {
      delete leadSharesDel;
    }
  }
}