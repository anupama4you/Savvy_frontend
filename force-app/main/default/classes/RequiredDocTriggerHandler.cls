public class RequiredDocTriggerHandler extends TriggerOrderHandler {
  public override void onAfterDelete(List<sObject> oldRecords, Map<ID, sObject> oldRecordsMap) {
		System.debug('@@Check for notification when a required doc is deleted');
    // Extract Opp Ids
    Set<Id> oppIds = new Set<Id>();
    for (Required_Document__c x : (List<Required_Document__c>)oldRecords) {
      oppIds.add(x.Opportunity__c);
    }

    // 
    List<AggregateResult> d = [
      SELECT Opportunity__c, COUNT(Id) TOTAL 
      FROM Required_Document__c
      WHERE Opportunity__c in :oppIds
      // AND (NOT Type__c LIKE '%Bank Statements')
      GROUP BY Opportunity__c
    ];

    //
    for (AggregateResult a: d) {
      Integer total = (Integer)a.get('TOTAL');
      Id oId = (Id)a.get('Opportunity__c');
      if (total > 0 && oppIds.contains(oId)) {
        oppIds.remove(oId);
      }
    }

    EmailSender.sendRequiredDocNotification(oppIds);
	}
}