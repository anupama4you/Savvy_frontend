public class SettledEmail {
	 
	
	private void sendSettledEmail1(List<Custom_Opportunity__c> recList, Id templateId){
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		List<Messaging.SendEmailResult> results = new list<Messaging.SendEmailResult>();
		Map<Id, Id> personAccountMap = new Map<Id, Id>();
		Set<Id> accountIds = new Set<Id>();
		for(Custom_Opportunity__c rec : recList){
			accountIds.add(rec.Account__c);
		}
		for(Account acc : [Select Id, PersonContactId From Account Where Id in:accountIds and PersonContactId != null and PersonEmail != null]){
			personAccountMap.put(acc.Id, acc.PersonContactId);
		}
		for(Custom_Opportunity__c rec : recList){
			if (!rec.emailoptout__c) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTargetObjectId(personAccountMap.get(rec.Account__c));
				mail.setSaveAsActivity(true);
				mail.setWhatId(rec.Id);
				mail.setTemplateId(templateId);
				mail.setReplyTo(rec.Owner_Email__c);
				mail.setSenderDisplayName(rec.Owner_Name__c);
				mails.add(mail);
			}
		}
		
        // Lelo 								2016-08-17
        // results = Messaging.sendEmail(mails);
        if (!mails.isEmpty()) {
	        try {
	            results = Messaging.sendEmail(mails);
	        } catch (EmailException e) {
	            System.debug('Error: ' + e.getMessage());
	        }
	    }
        //-
        
		for(Messaging.SendEmailResult result : results){
			if (!result.isSuccess()){
				for(Messaging.SendEmailError err : result.getErrors()){
					System.debug('>>>>>>>>>>>>>> Error generated when sending mail - ' + err.getMessage());
				}
			}
		}
		
	}
	
	public void sendSettledEmails(Map<Custom_Opportunity__c, String> recMap, Map<String, Id> etMap){
    /*
		List<Custom_Opportunity__c> oppSett1 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett2 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett3 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett4 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett5 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett6 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett7 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett8 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett9 = new List<Custom_Opportunity__c>();
		List<Custom_Opportunity__c> oppSett10 = new List<Custom_Opportunity__c>();
		for(Custom_Opportunity__c op : recMap.keySet()){
			if (!op.emailoptout__c) {
				if(recMap.get(op) == 'Settled 1'){
					oppSett1.add(op);
				}
				if(recMap.get(op) == 'Settled 2'){
					oppSett2.add(op);
				}
				if(recMap.get(op) == 'Settled 3'){
					oppSett3.add(op);
				}
				if(recMap.get(op) == 'Settled 4'){
					oppSett4.add(op);
				}
				if(recMap.get(op) == 'Settled 5'){
					oppSett5.add(op);
				}
				if(recMap.get(op) == 'Settled 6'){
					oppSett6.add(op);
				}
				if(recMap.get(op) == 'Settled 7'){
					oppSett7.add(op);
				}
				if(recMap.get(op) == 'Settled 8'){
					oppSett8.add(op);
				}
				if(recMap.get(op) == 'Settled 9'){
					oppSett9.add(op);
				}
				if(recMap.get(op) == 'Settled 10'){
					oppSett10.add(op);
				}
			}
		}
		if(!oppSett1.isEmpty()){
			sendSettledEmail1(oppSett1, etMap.get('Settled_Email_1'));
		} 
		if(!oppSett2.isEmpty()){
			sendSettledEmail1(oppSett2, etMap.get('Settled_Email_2'));
		} 
		if(!oppSett3.isEmpty()){
			sendSettledEmail1(oppSett3, etMap.get('Settled_Email_3'));
		} 
		if(!oppSett4.isEmpty()){
			sendSettledEmail1(oppSett4, etMap.get('Settled_Email_4'));
		} 
		if(!oppSett5.isEmpty()){
			sendSettledEmail1(oppSett5, etMap.get('Settled_Email_5'));
		} 
		if(!oppSett6.isEmpty()){
			sendSettledEmail1(oppSett6, etMap.get('Settled_Email_6'));
		} 
		if(!oppSett7.isEmpty()){
			sendSettledEmail1(oppSett7, etMap.get('Settled_Email_7'));
		} 
		if(!oppSett8.isEmpty()){
			sendSettledEmail1(oppSett8, etMap.get('Settled_Email_8'));
		} 
		if(!oppSett9.isEmpty()){
			sendSettledEmail1(oppSett9, etMap.get('Settled_Email_9'));
		} 
		if(!oppSett10.isEmpty()){
			sendSettledEmail1(oppSett10, etMap.get('Settled_Email_10'));
		} 
    */
	}
}