public class ApplicationIncomeService {

	public static void changeFieldValues(List<Application_Income__c> newList){
		//System.debug('changeFieldValues...');
		String amp = '&amp;';
		if (newList != null) {
			for (Application_Income__c a : newList) {
				if (String.isNotBlank(a.Type__c) && a.Type__c.contains(amp)) {
					a.Type__c = a.Type__c.replace(amp,'&');
				}
				if (String.isBlank(a.Frequency__c)) {
					a.Frequency__c = 'Monthly';
				}
			}
		}
	}

}