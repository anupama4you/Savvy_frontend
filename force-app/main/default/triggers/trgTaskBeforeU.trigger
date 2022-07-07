trigger trgTaskBeforeU on Task (before update) 
{
    // find the list of what Ids
    Set<Id> whatIds = new Set<Id>();
    for (Task t : Trigger.New)
    {
        whatIds.add(t.WhatId);
    }
    
    // find any leads referenced by the what Ids
    Map<Id, Lead__c> leads = new Map<Id, Lead__c>([SELECT Id,
                                                          Status__c
                                                   FROM Lead__c
                                                   WHERE Id IN :whatIds]);
                                                   
    // find any opportunities referenced by the what Ids
    Map<Id, Custom_Opportunity__c> opps = new Map<Id, Custom_Opportunity__c>([SELECT Id,
                                                                       Status__c
                                                                FROM Custom_Opportunity__c
                                                                WHERE Id IN :whatIds]);                                                   
    
    // go through the tasks and apply the business rules based on status
    for (Task t : Trigger.New)
    {
        // if we're overriding the status then do no checks
        if (t.Status_Override__c)
        {
            continue;
        }
    
        if (leads.containsKey(t.WhatId))
        {
            // is the task being set to completed 
            if (t.Status == 'Completed'
                && !t.From_Opportunity_Settled__c)
            {
        /*      // if the lead is still set to new lead then don't allow the task to be closed
                if (leads.get(t.WhatId).Status__c == 'New Lead')
                {
                    t.addError('You cannot update this Task to Completed until the associated Lead no longer has a status of New Lead.');
                }
       */         
                // if the lead is set to attempted contact then create a new task
                if (leads.get(t.WhatId).Status__c == 'Attempted Contact') 
                {
                    TaskCreator.CreateTask(t.ownerId, 
                                           t.whatId, 
                                           '24 hours to action', 
                                           null, 
                                           1, 
                                           'High', 
                                           24);
                }
            
            }                    
        }
        else if (t.From_Opportunity_Settled__c
                 && t.Status == 'Completed'
                 && (!opps.containsKey(t.WhatId)
                     || opps.get(t.WhatId).Status__c != 'Unresolved Opportunity'))
        {                           
            t.addError('This task must be related to a new lead before it can be completed');
        }
    }   
       
}