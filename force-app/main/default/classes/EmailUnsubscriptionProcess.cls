global class EmailUnsubscriptionProcess implements Schedulable {
	global void execute(SchedulableContext sc) {
		process();
	}

	private void process() {
		List<Id> oppIds = new List<Id>();
		List<Customer_Unsubscription__c> d = [SELECT ID__c, Object_Type__c, Status__c FROM Customer_Unsubscription__c 
										      WHERE Status__c = 'R' AND Object_Type__c = 'OPP'];
		for (Customer_Unsubscription__c c : d) {
			c.Status__c = 'P';
			oppIds.add(c.ID__c);
		}
		if (!oppIds.isEmpty()) {
			List<Custom_Opportunity__c> opps = [SELECT emailoptout__c FROM Custom_Opportunity__c WHERE ID IN :oppIds
								       		    AND emailoptout__c = false ];
		    if (!opps.isEmpty()) {
		    	for (Custom_Opportunity__c o: opps) {
		    		o.emailoptout__c = true;
		    	}
		  		update opps;  	
		    }
		    update d;
		}
	}
}