@RestResource(urlMapping='/LeadRecentCalls/*')
global with sharing class LeadRecentCallResource {

	@HttpGet
    global static ResponseDTO getData() {
    	RestRequest req = RestContext.request;
    	Integer tcall = 5;
    	if (req.params != null) {
    		if (req.params.containsKey('tcall')) {
    			tcall = Integer.valueOf(req.params.get('tcall'));
    		}
    	}
    	tcall = tcall * (-1);
    	Datetime dt = Datetime.now().addMinutes(tcall);
    	System.debug('Time call >> ' + tcall + ' minutes' + '|date: ' + dt);
    	ResponseDTO r = new ResponseDTO();
		r.records = new List<Lead__c>();
		List<Task> t = [
			SELECT WhatId FROM Task 
			WHERE CreatedDate >= :dt
			AND TaskSubtype = 'Task'
			AND WhatId != null
			AND Subject LIKE 'Voice call from ANI%'
		];
		System.debug('Total ids: ' + t.size());
		Set<Id> leadIds = new Set<Id>();
		Set<Id> oppIds = new Set<Id>();
		for (Task a : t) {
			System.debug(a.whatId.getSObjectType().getDescribe().getName() + ': ' + a.whatId);
			if ('Lead__c'.equalsIgnoreCase(a.whatId.getSObjectType().getDescribe().getName())) {
				leadIds.add(a.whatId);
			} else if ('Custom_Opportunity__c'.equalsIgnoreCase(a.whatId.getSObjectType().getDescribe().getName())) {
				oppIds.add(a.whatId);
			}
		}

		if (!oppIds.isEmpty()) {
			List<Custom_Opportunity__c> opps = [SELECT Lead__c FROM Custom_Opportunity__c WHERE Id IN :oppIds];
			for (Custom_Opportunity__c o : opps) {
				leadIds.add(o.Lead__c);
			}
		}

		System.debug('Total ids for searching, Leads: ' + leadIds.size() + ' | opps: ' + oppIds.size());
		if (!leadIds.isEmpty()) {
			r.records = [
				SELECT Id,First_Name__c,Last_Name__c,Loan_Type__c,Mobile_Number__c,Email_Address__c,
				       Home_Phone__c,Work_Phone__c,State__c,Postcode__c,CreatedDate,
				       Suggested_Owner__r.Email,Owner_Email__c
				FROM Lead__c 
				WHERE CreatedDate = LAST_N_DAYS:14 
				AND Is_Call_Center__c = true
				AND Bucket_Type__c != 'Money3'
				AND Id IN :leadIds
				ORDER BY CreatedDate ASC
			];
			System.debug('Total found records: ' + r.records.size());
		}
		return r;
	}

	global class ResponseDTO {
		public List<Lead__c> records {set;get;}
	}
}