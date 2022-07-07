public with sharing class OppApprovalSalesConsultantsListExtension {

	public List<User> data {set;get;}

	public OppApprovalSalesConsultantsListExtension() {
		loadData();
	}

	private void loadData() {
        data = [SELECT Id, Name, Email, Phone, Extension, MobilePhone, Fax FROM User 
                WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name = 'Sales Consultant') 
                AND isActive = true ORDER BY Name];
	}

}