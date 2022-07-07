public with sharing class VDReassignmentProcessExtension {

	private Custom_Opportunity__c o;
	public Id newApproverId {set;get;}

	public VDReassignmentProcessExtension (ApexPages.StandardController controller) {
		o = (Custom_Opportunity__c)controller.getRecord();
	}


	public List<SelectOption> getApproverList() {
		List<SelectOption> r = new List<SelectOption>();
		List<User> userList = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User 
							   Where profileid IN (select id from profile where name = 'Vehicles Direct - Sales') 
							   AND isActive = true];
		for (User u : userList) {
			if (o.VD_Owner__c != u.Id) {
				r.add(new SelectOption(u.Id, u.Name));
			}
		}
		return r;
	}

	public PageReference reassign() {
		//Validate
		if (o.VD_Owner__c == newApproverId) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a different Approver.'));
			return null; 
		}
		ApprovalTools.reassignApprover(o.VD_Worksheet__c, newApproverId);
		//Opportunity
		o.VD_Owner__c = newApproverId;
		update o;
		return Page.VDApprovalSummary;
	}


}