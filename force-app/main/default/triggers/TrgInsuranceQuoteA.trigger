trigger TrgInsuranceQuoteA on Application_InsuranceQuote__c (after update) {

	for (Application_InsuranceQuote__c a : Trigger.new) {
		if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(a.Customer_Choice_Status__c)) {
			Application_InsuranceQuote__c b = Trigger.oldMap.get(a.Id);
			if (b != null && !a.Customer_Choice_Status__c.equals(b.Customer_Choice_Status__c) ) {
				//Send notification
				EmailSender.sendEmailPresentationFinished(a);
			}
		}
	}

}