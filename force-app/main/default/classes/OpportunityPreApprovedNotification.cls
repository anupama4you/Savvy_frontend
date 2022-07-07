global class OpportunityPreApprovedNotification {
  @InvocableMethod(
    label='Opportunity Pre-Approved Notificacions'
    description='Opportunity Pre-Approved Notificacions'
  )
  public static List<Custom_Opportunity__c> notify(
    List<Custom_Opportunity__c> opps
  ) {
    if (opps != null) {
      List<Id> ids = new List<Id>();
      for (Custom_Opportunity__c o : opps) {
        ids.add(o.Id);
      }
      
      List<AggregateResult> opportunity = [
        SELECT WhatId
        FROM Task
        WHERE Subject = 'Email: Pre-approved loan - Savvy' 
        AND WhatId IN :ids
        AND CreatedDate = LAST_N_DAYS:30
        GROUP BY WhatId
        HAVING COUNT(Subject) > 0
      ];
      Set<Id> oppEmail = new Set<Id>();
      for (AggregateResult o : opportunity) {
        oppEmail.add((Id) o.get('WhatId'));
      }
      for (Custom_Opportunity__c o : opps) {
        if (!oppEmail.contains(o.Id)) {
          EmailSender.sendEmailOpportunityPreApproved(o);
          // EmailSender.sendEmailOpportunityPreApprovedLiberty(o.Id);
        }
      }
    }
    return opps;
  }
}