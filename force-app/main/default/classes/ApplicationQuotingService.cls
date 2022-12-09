public class ApplicationQuotingService {
  public static void authorizationChecker(
    List<Application_Quoting__c> newList,
    Map<Id, Application_Quoting__c> oldMap
  ) {
    if (oldMap != null) {
      for (Application_Quoting__c newAppQuoting : newList) {
        if (!newAppQuoting.Name.equals(oldMap.get(newAppQuoting.Id).Name)) {
          Custom_Opportunity__c opp = [
            SELECT Preapproval_Auth_Date__c
            FROM Custom_Opportunity__c
            WHERE Id = :newAppQuoting.Opportunity__c
          ];
          if (opp.Preapproval_Auth_Date__c != null) {
            opp.Preapproval_Auth_Date__c = null;
            update opp;
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'Lender has been changed, please submit an Authorised Pre-approval for this deal before proceeding for any other approval process.'
              )
            );
          }
        }
      }
    }
  }

  public static void removeOlderQuotings (
    List<Application_Quoting__c> data
  ) {

    if (data != null && !data.isEmpty()) {
      Set<Id> oppIds = new Set<Id>();
      Set<Id> quotingIds = new Set<Id>();
      for (Application_Quoting__c q : data) {
        quotingIds.add(q.Id);
        if (q.Opportunity__c != null) {
          oppIds.add(q.Opportunity__c);
        }
      }
      if (!oppIds.isEmpty()) {
        List<Application_Quoting__c> quotes = [
          SELECT Id FROM Application_Quoting__c
          WHERE Opportunity__c IN :oppIds
          AND Id NOT IN :quotingIds
        ];
        quotingIds.clear();
        for (Application_Quoting__c q: quotes) {
          quotingIds.add(q.Id);
        }
        removeOlderQuotings(quotingIds);
      }
    }

  }

  public static void removeOlderQuotings (
    Set<Id> quotingIds
  ) {

    if (!quotingIds.isEmpty()) {
      delete [SELECT Id FROM Application_Quoting_Result__c WHERE Application_Quoting__c IN :quotingIds];
      delete [SELECT Id FROM Application_Quoting__c WHERE Id IN :quotingIds];
    }

  }
}