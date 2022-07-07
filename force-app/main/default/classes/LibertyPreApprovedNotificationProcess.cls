global class LibertyPreApprovedNotificationProcess {
  @InvocableMethod(
    label='Liberty Pre-Approved Notifications'
    description='Liberty Pre-Approved Notifications'
  )
  public static void notify(List<Id> ids) {
    System.debug('LibertyPreApprovedNotificationProcess... ' + JSON.serialize(ids));
    if (ids != null) {
      List<AggregateResult> d = [
        SELECT WhatId
        FROM Task
        WHERE
          Subject = 'Email: Pre-approved loan - Savvy'
          AND WhatId IN :ids
          AND CreatedDate = LAST_N_DAYS:30
        GROUP BY WhatId
        HAVING COUNT(Subject) > 1
      ];
      Set<Id> oppEmail = new Set<Id>();
      for (AggregateResult o : d) {
        oppEmail.add((Id) o.get('WhatId'));
      }
      for (Id oId : ids) {
        if (!oppEmail.contains(oId)) {
          EmailSender.sendEmailOpportunityPreApprovedLiberty(oId);
        }
      }
    }
  }
}