trigger AccEmailDuplicateIU on Account (before insert, before update) {
/*
    Map<String, Account> AccMap = new Map<String, Account>();
    Set<Id> accOwnerIds = new Set<Id>();
    
    for (Account Acc : System.Trigger.new) {

            if(trigger.isInsert){
            
                accOwnerIds.add(acc.ownerId); 
            
            }else if(trigger.isUpdate){
            
                if(acc.OwnerId != Trigger.OldMap.get(acc.Id).OwnerId ){
        
                    accOwnerIds.add(acc.ownerId);       
       
                }
             
            } 
            
            // We don't treat an email address that isn't changing during an update as a duplicate. 

            if ((Acc.PersonEmail != null || Acc.PersonMobilePhone != null) && 
            
            (System.Trigger.isInsert ||

                (Acc.PersonEmail != System.Trigger.oldMap.get(Acc.Id).PersonEmail))) {

            // Make sure another new Account isn't also a duplicate 

     
            if (AccMap.containsKey(Acc.PersonEmail)) {

                Acc.PersonEmail.addError('Another new Account has the same email address.');

            } else {

                AccMap.put(Acc.PersonEmail, Acc);

            }
            
       }
       
       if(trigger.isUpdate){
           
           if(acc.logged_in_user__c == true){
           
               acc.ownerId =  userinfo.getUserId();
               acc.logged_in_user__c=false;
               acc.Opportunity_status__c = '';
           
           }
           
       }   
           

    }
    
    Map<Id,string> accUserId = new Map<Id,string>();
       
    if(accOwnerIds != null && accOwnerIds.size()>0){
    
        for(User uObj:[select Id, name from user where id IN : accOwnerIds]){
       
         accUserId.put(uObj.Id,uObj.name);
        
        }
    
    }
    system.debug('@@accUserId'+accUserId);
    
/*  for(Account acc:trigger.new){
    
        if(!accUserId.isEmpty() && accUserId.containsKey(acc.OwnerId)){
  
              acc.Account_Owner_Custom__c=accUserId.get(acc.OwnerId);
        
        }
        
    }
    
// Using a single database query, find all the Accounts in the database that have the same email address as any 

// of the Accounts being inserted or updated. 

    if(!AccMap.keySet().isEmpty()){
        
    
        for (Account Acc : [SELECT PersonEmail FROM Account
    
                          WHERE PersonEmail IN : AccMap.KeySet()]) {
    
            Account newAcc = AccMap.get(Acc.PersonEmail);
    
            newAcc.PersonEmail.addError('An Account with this email address already exists.');
    
        }
    }
   */

}