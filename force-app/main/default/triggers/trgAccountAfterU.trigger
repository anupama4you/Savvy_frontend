trigger trgAccountAfterU on Account (after update) {
    // find which accounts have had their owner changed
    //Set<Id> accIds = new Set<Id>();
    
   // for (Account a : Trigger.New) {
        /*if(a.OwnerId != Trigger.OldMap.get(a.Id).OwnerId ){
            
        }*/
        //accIds.add(a.id);
    //}
    /*
    Map<Id,List<Lead__c>> accLeadMap =  new Map<Id,List<Lead__c>>();
    if(!Test.isRunningTest())   { 
       // for(Lead__c ld : SOQLSingletonQueries.setAccountIds(accIds).becomeOpptyLeadsByAccountIds){//[SELECT Id,Account__c,OwnerId FROM Lead__c WHERE Account__c IN :accIds AND (Status__c = 'Become Opportunity')]){
         //   if(accLeadMap.containsKey(ld.Account__c)){
         //       accLeadMap.get(ld.Account__c).add(ld);
         //   }else{
          //      accLeadMap.Put(ld.Account__c, new List<Lead__c>{ld});
        //    }
        //}
    }
    // update any open leads related to accounts with changed owners
    List<Lead__c> leads = new List<Lead__c>();
                 
    for(Account acc:Trigger.new){
        if(accLeadMap.containsKey(acc.id)){
            for (Lead__c l : accLeadMap.get(acc.id)){
                if(l.ownerId != acc.ownerId){
                    l.ownerId = acc.ownerId;
                    leads.add(l);
                }
            }
        }
    }                       
    if(!leads.isEmpty()){
        update leads;
    }
    
    
    /*
    // update application related to accounts with changed owners
    Map<Id,List<Application__c>> matchingAppMap =  new Map<Id,List<Application__c>>();
    List <Application__c> relatedApps = new List <Application__c>(); 
    if(!Test.isRunningTest())   { 
        relatedApps = SOQLSingletonQueries.setAccountIds(accIds).applicationsByAccountIds;//[SELECT Id,Account__c,OwnerId FROM Application__c WHERE Account__c IN :accIds];
    }
    
    for(Application__c app : relatedApps){
        if(matchingAppMap.containsKey(app.Account__c)){
            matchingAppMap.get(app.Account__c).add(app);
        }else{
            matchingAppMap.Put(app.Account__c, new List<Application__c>{app}); 
        }
    }
    
    List<Application__c> AppToUpdate = new List<Application__c>();
    
    for(Account acc:Trigger.new){
        if(matchingAppMap.containsKey(acc.id)){
            for (Application__c app : matchingAppMap.get(acc.id)){
                if(app.ownerId != acc.ownerId){
                    app.ownerId = acc.ownerId;
                    AppToUpdate.add(app);
                }
                 
            }
        }
    }                       
    if(!AppToUpdate.isEmpty()){
        update AppToUpdate;
    }*/
    
    /*if(!accIds.isEmpty()){
        AccountShareService.createShares(accIds);
    }*/
}