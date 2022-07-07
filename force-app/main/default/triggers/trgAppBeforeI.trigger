trigger trgAppBeforeI on Application__c (before insert) {
    
    // Find the system generated consultant and later add it as the owner for new lead
    //User sysGen = [SELECT id,Name FROM User WHERE Name = 'System Generated'];
    
    // Change the Application_name into some meaningful names
    /*for (Application__c newApp : Trigger.New) {
        if ((newApp.First_Name__c != null) && (newApp.Last_Name__c != null)) {
            newApp.Name = newApp.First_Name__C + ' ' + newApp.Last_Name__c;
        }
        //if (newApp.Length_of_Term__c != null) {
        //    newApp.Length_of_Term__c = newApp.Length_of_Term__c * 12;
        //}
    }*/
    
     /*// Use Email Address to identify the Account to match the Application
    Set <String> AppEmails = new Set <String> ();
    
    for (Application__c newApp : Trigger.New) {
        AppEmails.add(newApp.Email_Address__c);
    }
    // The list to check for the situation App email matches the Opp but not the Acc
    List <Custom_Opportunity__c> OppMatchList = [SELECT id,Name,Email_Address__c FROM Custom_Opportunity__c WHERE Email_Address__c in: AppEmails];
    
    // Prepare the Account map to match the Email addresses
    Map <String, Account> matchingAccMap = new Map <String, Account> ();
    // Prepare the Account list to update Accounts
    List <Account> AccToUpdate = new List <Account> ();
    
    for (Account acc : [Select Id, PersonEmail, OwnerId From Account Where PersonEmail IN : AppEmails]) {
        matchingAccMap.put(acc.PersonEmail, acc);
    }
    // If there is Opp matching the App but no Account to match it
    if (matchingAccMap.size() == 0 && OppMatchList.size() > 0) {
        EmailSender.sendEmailAppOppNoAcc(trigger.New);
    }
    
     /*for (Application__c newApp : trigger.New) {
        if (matchingAccMap.get(newApp.Email_Address__c) != null) {
            // Link Account to Application
            newApp.Account__c = matchingAccMap.get(newApp.Email_Address__c).Id;
            
            // Change the Application Owner to be the Account Owner
            Account accBuffer = new Account ();
            accBuffer = matchingAccMap.get(newApp.Email_Address__c);
            if (accBuffer.OwnerId != newApp.OwnerId) {
                newApp.OwnerId = accBuffer.OwnerId;
            }
            
            /* Make the Account related address equal to Application Address
             * For unknown reason, "if" expressions are not able to run
             * The initial idea was to check whether the addresses are blank
             * If this does not work at last, in the document generating rule
             * we can use Application address instead of Account address 
             */
    /*         accBuffer.Street_Address__c = newApp.Street_Address__c;
            accBuffer.Suburb__c = newApp.Suburb__c;
            accBuffer.Postcode__c = newApp.Postcode__c;
            accBuffer.ABN__c = newApp.Business_ABN__c;
            
            AccToUpdate.add(accBuffer);
        } 
    }*/
    
    /*// Some small mod to make the data better presented
    for (Application__c newApp : trigger.New) {
        if (newApp.Mobile_Number__c != null) 
        	newApp.Mobile_Number__c = newApp.Mobile_Number__c.replace(' ','');
    }*/
    
    //update AccToUpdate;
    
}