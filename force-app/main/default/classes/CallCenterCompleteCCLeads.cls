global class CallCenterCompleteCCLeads implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        ipSCAPEService.completeCCLeadAsync();
        /*
        List<Lead__c> d = [
            Select Id, Name, CC_Lead_ID__c, CC_Completed_Date__c From Lead__c 
            Where CC_Lead_ID__c > 0 And CreatedDate = LAST_N_DAYS:1
            And CC_Completed_Date__c = null
            And Owner_Name__c != 'System Generated'];
        List<Lead__c> leads = new List<Lead__c>();
        System.debug('Total leads to be completed: ' + d.size());
        for (Lead__c a: d) {
            System.debug('Processing Lead: ' + a.name + ' [' + a.Id + ']');
            if (ipSCAPEService.completeCCLead(String.valueOf(a.CC_Lead_ID__c))) {
                a.CC_Completed_Date__c = Datetime.now();
                leads.add(a);
            }
        }
        if (!leads.isEmpty()) {
            update leads;
            System.debug('Total leads reported: ' + leads.size());
        }
        */
    }

}