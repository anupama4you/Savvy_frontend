trigger AccMobileDuplicateIU on Account (before insert, before update) 

{ 
/*
   Map<String, Account> AccMap = new Map<String, Account>();

    for (Account Acc : System.Trigger.new) {

// We don't treat an Mobile number that isn't changing during an update as a duplicate. 

            if ((Acc.PersonMobilePhone != null) && 
            
            (System.Trigger.isInsert ||

                (Acc.PersonMobilePhone !=

                    System.Trigger.oldMap.get(Acc.Id).PersonMobilePhone))) {

// Make sure another new Account isn't also a duplicate 

     
            if (AccMap.containsKey(Acc.PersonMobilePhone)) {

                Acc.PersonMobilePhone.addError('Another new Account has the same Mobile number.');

            } else {

                AccMap.put(Acc.PersonMobilePhone, Acc);

            }

       }

    }

// Using a single database query, find all the Accounts in the database that have the same Mobile number as any 

// of the Accounts being inserted or updated. 

    if(!Test.isRunningTest())   { 
        if(!AccMap.keySet().isEmpty()){
            for (Account Acc : [SELECT PersonMobilePhone FROM Account
                             WHERE PersonMobilePhone IN : AccMap.KeySet()]) {
    
                Account newAcc = AccMap.get(Acc.PersonMobilePhone);
        
                newAcc.PersonMobilePhone.addError('An Account with this Mobile number already exists.');
        
            }
        }
        
    }
*/
}