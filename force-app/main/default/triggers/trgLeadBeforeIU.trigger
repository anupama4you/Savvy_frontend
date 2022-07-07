trigger trgLeadBeforeIU on Lead__c (before insert, before update) 
{    
    // find the owners of the new leads
    Map<Id, Integer> owners = new Map<Id, Integer>();
    set<Lead__c> ldId = new set<Lead__c>();
    set<Id> accId = new set<Id>();
    Map<String, Lead__c> leadMap = new Map<String, Lead__c>();
    Map<String, Lead__c> leadToPhone = new Map<string, Lead__c>();
    Map<String,Id> emailMap = new Map<String,Id>();
    Map<String,Id> phoneMap = new Map<String,Id>();
    Boolean makeDup=false;
    
    for (Lead__c newLead : Trigger.New)
    {
        owners.put(newLead.OwnerId, 0);
        accId.add(newLead.Account__c);
        
        if(newLead.Email_Address__c != null){
        
             leadMap.put(newLead.Email_Address__c, newLead);

        }
        if(newLead.mobile_number__c != null){
            
            leadToPhone.put(newLead.mobile_number__c, newLead);
            
        }
        
        
        if(Trigger.isInsert){
        
            makeDup=true;
        
        }
        if(trigger.isUpdate ){
            
            if(newLead.status__c == Trigger.oldMap.get(newLead.Id).Status__c)
        
                makeDup=true;
        
        }
        
    }
    
    Map<Id,Account> accMap = new Map<Id,Account>([Select id,name from Account where id In:accId]);
    List<Lead__c> ldNLst = new List<Lead__c>([Select id,name, status__c,Account__c,Email_Address__c,Mobile_Number__c from Lead__c where (Email_Address__c IN :leadMap.KeySet() OR Mobile_Number__c In : leadToPhone.keyset()) and Account__c in: accMap.values() AND status__c != 'New Lead']);
    
    /*if(ldNewMap.size()>1){
    
        for(Lead__c ldEmPH:ldNewMap.values()){
        
            emailMap.put(ldEmPh.email_Address__c,ldEmPh.id);
            phoneMap.put(ldEmPh.Mobile_Number__c,ldEmPh.id);
        
        }
        
    }*/
    //Find the duplicate lead and change the status of lead to closed lead

    if(makeDup == true){ 
       
       Boolean isMakedupLead=false;
       for(Lead__c ldN:trigger.new){
       
           if(ldNLst.size()>1 ){
           
               for(Lead__c ldLst:ldNLst){
           
                   if(accMap != null && ldN.Account__c != null && accMap.containsKey(ldN.Account__c) && accMap.containsKey(ldLst.Account__c)){
                   
                       isMakedupLead = true;
              
                   }
                   
               }
               
           }
           
           if(ldN.Account__c != null && accMap.containsKey(ldN.Account__c) && ldN.status__c == 'New Lead'){
           
               isMakedupLead = true;
           
           }
           
           if(isMakedupLead == true){
           
               ldN.status__c = 'Closed Lead';
               ldN.Reason_for_closure__c='Duplicate Lead';
                   
           }
       
       
       }
       //LeadTriggerHandler.beforeInsertExecution(trigger.new,leadMap,accMap,leadToPhone); 
          
    }
         
    // now find the number of 'active' leads per owner
    /*for (Lead__c l : [SELECT Id,
                             OwnerId
                      FROM Lead__c
                      WHERE OwnerId IN :owners.keySet()
                      AND Owner.Name != 'System Generated'
                      AND Status__c IN ('New Lead', 'Attempted Contact')])
    {
        owners.put(l.OwnerId, owners.get(l.OwnerId) + 1);
    }   
                
    for (Lead__c newLead : Trigger.New)
    {
        // now see if any owners for the new leads have more than 90 leads
        if ((Trigger.oldMap == null || Trigger.oldMap.get(newLead.Id).OwnerId != newLead.OwnerId)
            && owners.get(newLead.OwnerId) >= 90)
        {
            newLead.addError('A user cannot own more than 90 active leads.');
        }                                   
    }*/
    
}