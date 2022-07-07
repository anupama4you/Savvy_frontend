trigger trgLeadAfterU on Lead__c (after insert, after update,after delete) 
{
    
    // Update Lead Status on account
    /*List<Id> ldUpdIds = new List<Id>(); 
    List<Id> ldUpdIds2 = new List<Id>();
    Set<Id> ldIds = new Set<Id>();
    set<id> accId = new set<id>();
    List<string> emailAdd = new List<string>();
    List<Lead__c> ldUpOBjs=new List<Lead__c>();
    string isStatusUpd;
    Map<Id,String> idToStatusMap=new Map<Id,String>();
    set<id> leadIds = new set<id>();
    if(trigger.isInsert || trigger.isUpdate){
        
        for(Lead__c ld:Trigger.new){
    
            accId.add(ld.account__c);

            ldIds.add(ld.id);
            ldUpOBjs.add(ld);
            emailAdd.add(ld.email_address__c);
            /*if(trigger.isInsert){
            
                idToStatusMap.put(ld.id,'Yes');
            
            }
            if(trigger.isUpdate){
            
                /*if(ld.Last_Name__c != Trigger.OldMap.get(ld.id).Last_Name__c || ld.First_Name__c != Trigger.OldMap.get(ld.id).First_Name__c || ld.Email_Address__c != Trigger.OldMap.get(ld.id).Email_Address__c || ld.Status__c != Trigger.OldMap.get(ld.id).Status__c || ld.Reason_for_closure__c != Trigger.OldMap.get(ld.id).Reason_for_closure__c || ld.Finance_Amount__c != Trigger.OldMap.get(ld.id).Finance_Amount__c || ld.Owner.name != Trigger.OldMap.get(ld.id).Owner.name || ld.Owner_Email__c != Trigger.OldMap.get(ld.id).Owner_Email__c || ld.Owner_Mobile__c!=Trigger.OldMap.get(ld.id).Owner_Mobile__c || ld.Owner_Phone__c!=Trigger.OldMap.get(ld.id).Owner_Phone__c){
                            
                    ldUpdIds.add(ld.Id);
                    
                    if(ld.Status__c != Trigger.OldMap.get(ld.id).Status__c || ld.Reason_For_Closure__c != Trigger.OldMap.get(ld.Id).Reason_For_Closure__c){
                    
                        idToStatusMap.put(ld.id,'Yes');
                    
                    }else{
                    
                        idToStatusMap.put(ld.id,'No');
                    
                    }
                    
                }
                if(ld.OwnerId != Trigger.OldMap.get(ld.Id).OwnerId ){
		            leadIds.add(ld.id);
		        }
            }
           
            
        }
        
     /*Map<Id,List<Custom_Opportunity__c>> oppMap=new Map<Id,List<Custom_Opportunity__c>>();
     for(Custom_Opportunity__c ctOpp:SOQLSingletonQueries.setLeadIds(ldIds).opportunitiesByLeadIds){
     
         if(oppMap.containsKey(ctOpp.Lead__c)){
                            
            oppMap.get(ctOpp.Lead__c).add(ctOpp);
                                     
         }else{
        
            oppMap.Put(ctOpp.Lead__c, new List<Custom_Opportunity__c>{ctOpp}); 
                 
         }
     
     }*/
     //Map<Id,Account> accMap = SOQLSingletonQueries.setAccountIds(accId).accountsIdMap;//new Map<Id,Account>([SELECT id, Lead_Status__c FROM Account WHERE id IN: accId]);
     //List<Account> acctForUpdate = new List<Account>();
     /*if(trigger.isInsert){
       
           if(ldIds.size()>0){
                if(!Test.isRunningTest()) {                
                  integer ctr;
                  List<Lead__c> leadBatch = new List<Lead__c>();
                  //System.debug('***ldUpOBjs:'+ldUpOBjs.size());
                  while (ldUpOBjs.size() > 0){
                      if (ldUpOBjs.size() > 90)    {                     
                              for (ctr = 0; ctr > 90; ctr++){
                                  leadBatch.add(ldUpOBjs[ctr]);
                                  ldUpOBjs.remove(ctr);
                              }
                              System.enqueueJob(new queueActiveLeadCampaignCallout (leadBatch,idToStatusMap));
                              leadBatch = new List<Lead__c>();                            
                      }else{
                              System.enqueueJob(new queueActiveLeadCampaignCallout(ldUpOBjs,idToStatusMap));                  
                              break;
                      }  
                  } //end while         
                                   
               } //end if
               
           }
           
       }
       
       if(trigger.isUpdate){
       
           if(ldUpdIds.size()>0){
               if(!Test.isRunningTest()) {       
                   
                  integer ctr;
                  List<Lead__c> leadBatch = new List<Lead__c>();
                  List<Lead__c> leadBatch2 = new List<Lead__c>();
                  System.debug('***ldUpOBjs:'+ldUpOBjs.size());
                  if (ldUpOBjs.size() > 40)    {                     
                        for (ctr = 0; ctr > 40; ctr++){
                        	leadBatch.add(ldUpOBjs[ctr]);
                            ldUpOBjs.remove(ctr);
                    	}
                           	//System.enqueueJob(new queueActiveOppTagCallout (oppBatch,idToStatusMap)); 
                            //oppBatch = new List<Custom_Opportunity__c>();                            
                  }
                  if(ldUpOBjs.size() > 0){
                    	for(Lead__c ld: ldUpOBjs){
                      		leadBatch2.add(ld);
                      	}
                  }
                             
                  	if(!leadBatch.isEmpty()){
                  		System.enqueueJob(new queueActiveLeadTagCallout (leadBatch,idToStatusMap)); 
                  	}
                  	if(!leadBatch2.isEmpty()){
                  		System.enqueueJob(new queueActiveLeadTagCallout (leadBatch2,idToStatusMap));
                  	}                         
               } //end if
               
           }
       
       }     */    

        //update accMap.values();
        
        /*if(trigger.isUpdate){
    
            // find which leads have open tasks
            Map<Id, List<Task>> openTasks = new Map<Id, List<Task>>();
            for (Task t : SOQLSingletonQueries.setLeadIds(Trigger.newMap.keySet()).uncompletedTasksByLeadIds)
            {
                if (!openTasks.containsKey(t.WhatId))
                {
                    openTasks.put(t.WhatId, new List<Task>());
                }
            
                openTasks.get(t.WhatId).add(t);
            }                          
        
            List<Task> tasks = new List<Task>();
            
            
        
            //String ownerName = [Select id, name from User where Id in:ownerId].name;
         
            for (Lead__c newLead : Trigger.New)
            {                        
            
                // has the status changed and are there open tasks
                if (Trigger.oldMap != null
                    && newLead.Status__c != Trigger.oldMap.get(newLead.Id).Status__c
                    && openTasks.containsKey(newLead.Id))
                {
                    // if the status is unresolved lead or become opportunity then close any open tasks
                    if (newLead.Status__c == 'Unresolved Lead'
                        || newLead.Status__c == 'Become Opportunity')
                    {
                        for (Task t : openTasks.get(newLead.Id))
                        {
                            t.Status = 'Completed';
                            tasks.add(t);
                        }   
                    }
                    // otherwise the status cannot be changed if there are open tasks
                    else
                    {      
                        newLead.Status__c.addError('The status cannot be changed while there are open tasks.');
                    }
                } 
            
            }  
            if(!tasks.isEmpty()){
            	update tasks;
            }  
            
       
    
            for(Lead__c ld:Trigger.new){

               if(ld.Status__c != trigger.oldMap.get(ld.Id).Status__c && ld.Status__c == 'unresolved Lead' ){
                  	if(accMap.size() > 0){
                  		Account tempAcct = new Account();
                  		tempAcct = accMap.get(ld.Account__c);
                  		tempAcct.Lead_Status__c = ld.status__c;
                  		tempAcct.ownerId =  ld.OwnerId;
                  		acctForUpdate.add(tempAcct);
                  	}
                }
         
            }
        }
    
         try{
    
            if(acctForUpdate.size() > 0){
            
                update acctForUpdate;
                
            }

        }catch( Exception e){
           
        }
        
    }
     /*if(trigger.isdelete){
        List<Lead__c> ldOBjs=new List<Lead__c>();
        
        for(Lead__c ldel:trigger.old){
            
            emailAdd.add(ldel.Email_Address__c);
            ldIds.add(ldel.id);
            ldOBjs.add(ldel);
            
            system.debug('@@ldel.email'+ldel.Email_Address__c);
            
        }
        if(ldIds.size()>0 || emailAdd.size()>0){
         System.debug('ldUpdIds: ' + ldUpdIds);
                   
            
               if(!Test.isRunningTest()) {       
                   
                  integer ctr;
                  List<String> emailBatch = new List<String>();     
                  while (emailAdd.size() > 0){
                      if (emailAdd.size() > 40)    {                     
                              for (ctr = 0; ctr > 40; ctr++){
                                  emailBatch.add(emailAdd[ctr]);
                                  emailAdd.remove(ctr);
                              }
                              System.enqueueJob(new queueActiveLeadDeleteCallout (emailBatch));
                              emailBatch = new List<String>();                                
                      }else{
                              System.enqueueJob(new queueActiveLeadDeleteCallout (emailAdd));
                              break;
                      }  
                  }
                                                      
                                           
               } //end if
            
         }
        
    }*/
    
    /*if (trigger.isUpdate) {
        Set <Id> relatedAppId = new Set <Id> ();
        List <Application__c> AppToUpdate = new List <Application__c> ();
        for (Lead__c newLead : trigger.New) {
            if (newLead.Application__c != null && newLead.Application__c != trigger.OldMap.get(newLead.Id).Application__c) {
                relatedAppId.add(newLead.Application__c);
            }
        }
        if (relatedAppId.size() > 0) {
            Map <Id,Application__c> relatedApp = new Map <Id,Application__c> ([SELECT Id,Name,OwnerId,Account__c FROM Application__c WHERE ID in: relatedAppId]);
            for (Lead__c newLead : trigger.new) {
                if (Trigger.oldMap.get(newLead.id).Account__c == null && newLead.Account__c != null) {
                    Application__c appBuffer = relatedApp.get(newLead.Application__c);
                    appBuffer.Account__c = newLead.Account__c;
                    appBuffer.OwnerId = newLead.OwnerId;
                    AppToUpdate.add(appBuffer);
                } //end if for Lead Account
            } // end for loop
        } //end if for relatedAppId.size() > 0
        update AppToUpdate;
    } //end if for lead.isUpdate
    if(!leadIds.isEmpty()){
		 LeadShareService.createShares(leadIds);
	}*/
}