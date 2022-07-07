public with sharing class OppEmailUnsubscriptionExtension {
	
	public String email {set;get;}
	private String oppIdParam;
	public String errorMessage {set;get;}
	public Boolean hasBennProcessed {set;get;}

	public OppEmailUnsubscriptionExtension() {
		oppIdParam = System.currentPageReference().getParameters().get('P');
		email = System.currentPageReference().getParameters().get('E');
		hasBennProcessed = false;
		if (String.isBlank(oppIdParam)) {
			errorMessage = '(MSG-205) This URL is not valid.';
		}
	}

	private void process(String oppId) {
		List<Custom_Opportunity__c> opps = [SELECT Id, Name, Email_Address__c, emailoptout__c
											FROM Custom_Opportunity__c
											WHERE Id = :oppId];
		if (!opps.isEmpty()) {
			hasBennProcessed = opps.get(0).emailoptout__c;
			if (!hasBennProcessed) {
				hasBennProcessed = true;
				try {
					List<Customer_Unsubscription__c> d = [SELECT Name FROM Customer_Unsubscription__c 
					                                     WHERE ID__c = :opps.get(0).Id 
					                                     AND Object_Type__c = 'OPP'
					                                     AND Status__c = 'R'];
					if (d.isEmpty()) {
						Customer_Unsubscription__c cu = new Customer_Unsubscription__c();
						cu.Name = opps.get(0).Name;
						cu.ID__c = opps.get(0).Id;
						cu.Object_Type__c = 'OPP';
						cu.Status__c = 'R';
						insert cu;
					}
				} catch (Exception e) {
					errorMessage = e.getStackTraceString() + '|' + e.getCause() + '|' + e.getMessage();
				}

			}
		} else {
			errorMessage = '(MSG-205) record not found.';
		}
	}

	public void unsubscribeEmail() {
		process(oppIdParam);
	}

}