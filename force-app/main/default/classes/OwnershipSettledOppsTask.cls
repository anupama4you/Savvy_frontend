global class OwnershipSettledOppsTask implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        List<Custom_Opportunity__c> d = [
            Select Id, Name, Status__c, OwnerId, Date_Closed_or_Settled__c
            from Custom_Opportunity__c 
            where Date_Closed_or_Settled__c = LAST_90_DAYS
            and Reason_for_Closure__c = null 
            and Status__c = 'Unresolved Opportunity' 
            order by Date_Closed_or_Settled__c DESC];
        for (Custom_Opportunity__c o: d) {
            System.debug('Opp 1: ' + o.Name + ' | ' + o.Status__c + ' | ' + o.OwnerId);
            List<Custom_Opportunity__History> hd = [
                SELECT Id, Field, NewValue, OldValue, CreatedDate 
                FROM Custom_Opportunity__History 
                WHERE ParentId = :o.Id
                AND Field = 'Owner'
                ORDER BY CreatedDate DESC
            ];
            String ownerId = null;
            for (Custom_Opportunity__History h: hd) {
                if (ownerId == null && !'Sales Consultants'.equals(String.valueOf(h.NewValue))) {
                    ownerId = String.valueOf(h.OldValue);
                }
            }
            o.Status__c = 'Settled';
            if (String.isNotBlank(ownerId)) {
                o.OwnerId = ownerId;
            }
            System.debug('Opp 2: ' + o.Name + ' | ' + o.Status__c + ' | ' + o.OwnerId);
        }
        if (!d.isEmpty()) {
            update d;
        }
    }
    
}