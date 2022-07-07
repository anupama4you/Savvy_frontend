public class Task_Service {
    public static void updateOpportunityByCallTask(List<Task> newRecords) {
    	Set<Id> oppsId = new Set<Id>();
    	for (Task t : newRecords){
            if (t.WhatId != null && 'Custom_Opportunity__c'.equalsIgnoreCase(t.WhatId.getSObjectType().getDescribe().getName()) &&
                (t.TaskSubtype == 'Call' || (String.isNotBlank(t.Subject) && t.Subject.containsIgnoreCase('call')))) {
                oppsId.add(t.WhatId);
            }
        }
        if (!oppsId.isEmpty()) {
            List<Custom_Opportunity__c> opps = [Select id, Date_Last_Call_Activity__c from Custom_Opportunity__c where Id in :oppsId];
            //DateTime toSendAspect = DateUtils.getDateOfWorkingDay(System.now(), 7);
            //Date newDate = date.newinstance(toSendAspect.year(), toSendAspect.month(), toSendAspect.day());
        	List<Custom_Opportunity__c> updateOpps = new List<Custom_Opportunity__c>();
        	for (Custom_Opportunity__c o : opps){
        		o.Date_Last_Call_Activity__c = System.now();
        		//o.Date_Send_To_Aspect__c = newDate;
        		updateOpps.add(o);
        	}
        	if (!updateOpps.isEmpty()){
        		update updateOpps;
        	}
        }
    }
}