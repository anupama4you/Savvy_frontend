trigger trgTaskAfterID on Task (after delete, after insert) {
	Set<Id> whatIds = new Set<Id>();
	if (Trigger.isInsert){
		for (Task t : Trigger.New)
	    {
	        whatIds.add(t.WhatId);
	    }
	} else {
		for (Task t : Trigger.Old)
	    {
	        whatIds.add(t.WhatId);
	    }
	}
	
    
    Map<Id, Call_Reminder__c> callReminders = new Map<Id, Call_Reminder__c>([SELECT Id,
                                                          Call_Attempts__c, Call_Successful__c
                                                   FROM Call_Reminder__c
                                                   WHERE Id IN :whatIds]);
	if(Trigger.isInsert){                                       
		for (Task t : Trigger.New){
	    	if (callReminders.containsKey(t.WhatId)){
	        	callReminders.get(t.WhatId).Call_Attempts__c += 1;
	        	if(t.Status == 'Completed Successful'){
	        		callReminders.get(t.WhatId).Call_Successful__c = true;
	        	}
	        }
	        
	    }
    } else {
    	for (Task t : Trigger.Old){
	        if (Trigger.isDelete && callReminders.containsKey(t.WhatId) && callReminders.get(t.WhatId).Call_Attempts__c > 0){
	        	callReminders.get(t.WhatId).Call_Attempts__c -= 1;
	        }
	    }
    } 
    if(!callReminders.values().isEmpty()){
    	update callReminders.values();
    }
}