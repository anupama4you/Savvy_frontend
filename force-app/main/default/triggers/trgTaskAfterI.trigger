trigger trgTaskAfterI on Task (after insert) {
	System.debug('Executing trgTaskAfterI...');
	Map<Id, Custom_Opportunity__c> oppMap = new Map<Id, Custom_Opportunity__c>();

	for (Task t : Trigger.New) {
		Id whatId = t.whatId;
		if (whatId != null) {
			//System.debug('SObject >> ' + whatId.getSObjectType() + ' | ' + t.Call_Outcome__c);
			if ('Custom_Opportunity__c'.equalsIgnoreCase(whatId.getSObjectType().getDescribe().getName())) {
				System.debug('SObject is an Opportunity...');
				if (String.isNotBlank(t.Call_Outcome__c)) {
					Custom_Opportunity__c o = new Custom_Opportunity__c();
					if (t.Call_Outcome__c.containsIgnoreCase('Appsent')) {
						o.Status__c = 'Application Form Sent';
					} else if (t.Call_Outcome__c.containsIgnoreCase('Awatingp')) {
						o.Status__c = 'Awaiting Paperwork';
					} else if (t.Call_Outcome__c.containsIgnoreCase('Declined')) {
						o.Status__c = 'Declined';
						o.Reason_for_Closure__c = 'Declined';
					} else if (t.Call_Outcome__c.containsIgnoreCase('Followup')) {
						o.Status__c = 'Future follow up';
					} else if (t.Call_Outcome__c.containsIgnoreCase('Qsent')) {
						o.Status__c = 'Quote Sent';
					} else if (t.Call_Outcome__c.containsIgnoreCase('Settled')) {
						o.Status__c = 'Settled';
					} else if (t.Call_Outcome__c.containsIgnoreCase('AdminCal')) {
						o.Status__c = 'Closed Opportunity';
						o.Reason_for_Closure__c = 'Admin Call';
					} else if (t.Call_Outcome__c.containsIgnoreCase('CCTM')) {
						o.Status__c = 'Closed Opportunity';
						o.Reason_for_Closure__c = 'Client changed their mind';
					} else if (t.Call_Outcome__c.containsIgnoreCase('CNBQ')) {
						o.Status__c = 'Closed Opportunity';
						o.Reason_for_Closure__c = 'Could not beat quote';
					} else if (t.Call_Outcome__c.containsIgnoreCase('SDFFR')) {
						o.Status__c = 'Closed Opportunity';
						o.Reason_for_Closure__c = 'Send details for future reference';
					}

					//Add opp if there is a status applicable
					if (String.isNotBlank(o.Status__c)) {
						o.Id = whatId;
						oppMap.put(o.Id, o);
					}
				}
			}
		}
	}
	System.debug('Total records >> ' + oppMap.size());
	if (!oppMap.isEmpty()) {
		System.debug('Finding opps >> ' + oppMap);
		//Get the opportunities
		List<Custom_Opportunity__c> oppList = [SELECT Id, Status__c, Reason_for_Closure__c, Date_Closed_or_Settled__c FROM Custom_Opportunity__c 
											   WHERE Id IN :oppMap.keySet() 
											   AND Status__c NOT IN ('Settled','Closed Opportunity')];
		List<Custom_Opportunity__c> upOppList = new List<Custom_Opportunity__c>();
		//Update its status
		if (!oppList.isEmpty()) {
			System.debug('Total opps >> ' + oppList.size());
			for (Custom_Opportunity__c o : oppList) {
				Custom_Opportunity__c ns = oppMap.get(o.Id);
				if (ns != null) {
					System.debug('Statuses >> ' + o.Status__c + ' | ' + ns.Status__c);
					if (!ns.Status__c.equals(o.Status__c)) {
						o.Status__c = ns.Status__c;
						if (String.isNotBlank(ns.Reason_for_Closure__c)) {
							o.Reason_for_Closure__c = ns.Reason_for_Closure__c;
							o.Date_Closed_or_Settled__c = Datetime.now();
						}
						if ('Settled'.equals(o.Status__c)) {
							o.Date_Closed_or_Settled__c = Datetime.now();	
						}
						upOppList.add(o);
					}
				}
			}
			if (!upOppList.isEmpty()) {
				System.debug('Saving opps...');
				//Save
				try {
					update upOppList;
					System.debug('Opps saved >> ' + upOppList.size());
				} catch (Exception e) {
					System.debug(e.getMessage());
				}
			}
		}
	}

}