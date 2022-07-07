public without sharing class LeadScreenPopControlller {

	public String paramId {set;get;}		//Caller ID >> lead ID
	public String ani {set;get;}		//Caller ID >> lead ID
	public String dnis {set;get;}		//Caller Phone

	public Lead__c lead {set;get;}
	public Custom_Opportunity__c opp {set;get;}
	public Account account {set;get;}

	public LeadScreenPopControlller() {
		if (System.currentPageReference().getParameters().containsKey('ID')) {
			paramId = System.currentPageReference().getParameters().get('ID');
		}
		if (System.currentPageReference().getParameters().containsKey('ANI')) {
			ani = System.currentPageReference().getParameters().get('ANI');
		}
		if (System.currentPageReference().getParameters().containsKey('DNIS')) {
			dnis = System.currentPageReference().getParameters().get('DNIS');
		}
		loadData();
	}

	private void loadData() {
		Id objId = null;
		try {
			//Check Id
			if (String.isNotBlank(paramId)) {
				objId = paramId;
			//Check ANI
			} else if (String.isNotBlank(ani)) {
				objId = ani;
			}
		} catch (StringException e) {
			System.debug('Error getting the id, paramId >> ' + paramId + '| ani >> ' + ani);
			System.debug(e.getMessage());
			System.debug(e.getCause());
		}
		
		if (objId != null) {
			presetObjects(objId);
		}

		//Check DNIS
	}

	private void presetObjects(Id objId) {

		if ('Custom_Opportunity__c'.equalsIgnoreCase(objId.getSObjectType().getDescribe().getName())) {
			this.opp = findOpportunityById(objId);
		} else if ('Lead__c'.equalsIgnoreCase(objId.getSObjectType().getDescribe().getName())) {
			List<Lead__c> objList = [SELECT Id, Name, Status__c FROM Lead__c WHERE Id = :objId];
			if (!objList.isEmpty()) {
				this.lead = objList.get(0);
				this.opp = findOpportunityByLeadId(this.lead.Id);
			}
		} else if ('Account'.equalsIgnoreCase(objId.getSObjectType().getDescribe().getName())) {
			List<Account> objList = [SELECT Id, Name, PersonHomePhone FROM Account WHERE Id = :objId];
			if (!objList.isEmpty()) {
				this.account = objList.get(0);
				this.opp = findOpportunityByAccountId(this.account.Id);
			}
		}
	}

	private Custom_Opportunity__c findOpportunityById(Id objId) {
		Custom_Opportunity__c r = null;
		List<Custom_Opportunity__c> objList = [SELECT Id, Name, Status__c FROM Custom_Opportunity__c WHERE Id = :objId];
		if (!objList.isEmpty()) {
			r = objList.get(0);
		}
		return r;
	}

	private Custom_Opportunity__c findOpportunityByLeadId(Id objId) {
		Custom_Opportunity__c r = null;
		List<Custom_Opportunity__c> objList = [SELECT Id, Name, Status__c FROM Custom_Opportunity__c WHERE Lead__c = :objId ORDER BY LastModifiedDate DESC];
		if (!objList.isEmpty()) {
			r = objList.get(0);
		}
		return r;
	}

	private Custom_Opportunity__c findOpportunityByAccountId(Id objId) {
		Custom_Opportunity__c r = null;
		List<Custom_Opportunity__c> objList = [SELECT Id, Name, Status__c FROM Custom_Opportunity__c WHERE Account__c = :objId ORDER BY LastModifiedDate DESC];
		if (!objList.isEmpty()) {
			r = objList.get(0);
		}
		return r;
	}

	public List<Param> getParameters() {
		List<Param> r = new List<Param>();
		System.debug('Parameters >> ');
		for (String k : System.currentPageReference().getParameters().keySet()) {
			Param p = new Param();
			p.key = k;
			p.value = System.currentPageReference().getParameters().get(k);
			r.add(p);
			System.debug(k + ' | ' + p.value);
		}
		System.debug('======================================');
		return r;
	}


	public class Param {
		public String key {set;get;}
		public String value {set;get;}
	}
}