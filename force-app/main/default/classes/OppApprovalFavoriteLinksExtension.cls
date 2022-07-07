public with sharing class OppApprovalFavoriteLinksExtension {

	public List<Approval_Link__c> data {set;get;}
	public Approval_Link__c obj {set;get;}
	public Boolean isShowForm {set;get;}

	public OppApprovalFavoriteLinksExtension() {
		loadForm();
		loadData();
	}

	private void loadForm(){
		isShowForm = false;
		String objId = System.currentPageReference().getParameters().get('IDX');
		if (!String.isBlank(objId)) {
			obj = [SELECT Id, Name, Website__c FROM Approval_Link__c WHERE Id = :objId];
			//Load for updating
			isShowForm = true;
		}		
	}

	private void loadData() {
		data = [SELECT Id, Name, Website__c FROM Approval_Link__c ORDER BY Name];
	}

	public PageReference newLogin () {
		isShowForm = true;
		obj = new Approval_Link__c();
		return null;
	}

	public PageReference cancel () {
		isShowForm = false;
		obj = null;
		return null;
	}

	public PageReference save () {
		//if (isFormValid()) {
			upsert obj;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The record has been saved.'));
			loadData();
			isShowForm = false;
			obj = null;
		//}
		return null;
	}	

	public PageReference deleteRecord() {
		if (obj != null && obj.Id != null) {
			delete obj;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The record has been deleted.'));
			loadData();
		}
		return cancel();
	}

}