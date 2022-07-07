trigger trgOpportunityAfterUApproval on Custom_Opportunity__c (after update) {
    //System.debug('Executing >> trgOpportunityAfterUApproval');
    for (Custom_Opportunity__c opps : Trigger.New) {           
        //Lelo              2016-08-11
        //Schedule notification when status is 'Sent To Lender ....'
        //System.debug('Checking for SentToLender notification...');
        //System.debug(opps.Status__c + ' == ' + trigger.oldMap.get(opps.Id).Status__c);
        if (opps.Status__c != trigger.oldMap.get(opps.Id).Status__c && opps.Status__c != null &&
            (opps.Status__c == 'Submitted for Pre-Approval' ||
             opps.Status__c == 'Submitted for Amendment' ||
             opps.Status__c == 'Submitted for Formal Approval')) {
                String status = opps.Status__c;
                Integer min = 1;    //60 to one hour
                Integer h = 1;
                if (status.contains('Pre-Approval')) {
                    h = 1;      //h = 2; ORIGINAL
                } else if (status.contains('Amendment')) {
                    h = 1;
                } else if (status.contains('Formal Approval')) {
                    h = 1;
                }
                //SendADelayedNotification.scheduleNotification(opps.Id, opps.Status__c, '', h*min);
                //System.debug('Scheduled a Delayed Notification');
            }
        //end-   
    }
    
}