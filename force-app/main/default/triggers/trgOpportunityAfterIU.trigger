trigger trgOpportunityAfterIU on Custom_Opportunity__c (after insert, after update) 
{    
  
    List<Id> OppIds = new List<Id>();
    List<Id> OppUpdsIds = new List<Id>();
    Map<Id,String> idToStatusMap = new Map<Id,String>(); 
  
    List<Custom_Opportunity__c> listOppInsert = new List<Custom_Opportunity__c>();
    List<Custom_Opportunity__c> listOppUpdate = new List<Custom_Opportunity__c>();

   
    if(trigger.isInsert || trigger.isUpdate){
      System.debug('@@Started:');
    // find which opportunities have open tasks
        Map<Id, List<Task>> openTasks = new Map<Id, List<Task>>();
        for (Task t : [SELECT Id,
                              Status,
                              WhatId,
                              Subject
                       FROM Task
                       WHERE WhatId IN :Trigger.newMap.keySet()
                       AND Status != 'Completed']){
      if (!openTasks.containsKey(t.WhatId)){
        openTasks.put(t.WhatId, new List<Task>());
            }
            openTasks.get(t.WhatId).add(t);
        }                                                         
        
        List<Task> tasks = new List<Task>();
        set<id> accId = new set<id>(); 
         set<id> leadId = new set <Id>();   
         map<id, id> newOppOwnerIdMap = new map<id, id>();
         map<id, id> newLeadOwnerIdMap = new map<id, id>();
        for (Custom_Opportunity__c newOpp : Trigger.New){                                    
            accId.add(newOpp.account__c);
            leadId.add(newOpp.Lead__c);
            OppIds.add(newOpp.id);
             listOppInsert.add(newOpp);
            
            if(trigger.isInsert){
            
                idToStatusMap.put(newOpp.id,'Yes');
              newOppOwnerIdMap.put(newOpp.account__c, newOpp.OwnerId);
              if(newOpp.account__c != null){
                newOppOwnerIdMap.put(newOpp.account__c, newOpp.OwnerId);
              }
              if(newOpp.Lead__c != null){
                newLeadOwnerIdMap.put(newOpp.Lead__c, newOpp.OwnerId);
              }
            }
            if(trigger.isUpdate){
              
        if(newOpp.account__c != null){
          if(newOpp.account__c != Trigger.OldMap.get(newOpp.id).account__c || newOpp.OwnerId != Trigger.OldMap.get(newOpp.id).OwnerId){
            newOppOwnerIdMap.put(newOpp.account__c, newOpp.OwnerId);
          }
              }
              if(newOpp.Lead__c != null){
                if(newOpp.Lead__c != Trigger.OldMap.get(newOpp.id).Lead__c || newOpp.OwnerId != Trigger.OldMap.get(newOpp.id).OwnerId){
            newLeadOwnerIdMap.put(newOpp.Lead__c, newOpp.OwnerId);
          }
              }
                if(newOpp.name != Trigger.OldMap.get(newOpp.id).name || newOpp.Status__c != Trigger.OldMap.get(newOpp.id).Status__c || newOpp.Reason_for_Closure__c != Trigger.OldMap.get(newOpp.id).Reason_for_Closure__c || newOpp.Opp_Loan_Term__c != Trigger.OldMap.get(newOpp.id).Opp_Loan_Term__c || newOpp.Opp_Loan_Type__c != Trigger.OldMap.get(newOpp.id).Opp_Loan_Type__c || newOpp.Owner_Name__c != Trigger.OldMap.get(newOpp.id).Owner_Name__c){
                    
                    OppUpdsIds.add(newOpp.Id);
                    listOppUpdate.add(newOpp);
                    
                    if(newOpp.Status__c != Trigger.OldMap.get(newOpp.id).Status__c || newOpp.Reason_For_Closure__c != Trigger.OldMap.get(newOpp.Id).Reason_For_Closure__c){
            idToStatusMap.put(newOpp.id,'Yes');
                    }else{
                      idToStatusMap.put(newOpp.id,'No');
                    }
                }
            }
            
      // has the status changed and are there open tasks
            if (Trigger.oldMap != null && newOpp.Status__c != Trigger.oldMap.get(newOpp.Id).Status__c && openTasks.containsKey(newOpp.Id)){
        for (Task t : openTasks.get(newOpp.Id)){
          t.Status = 'Completed';
          tasks.add(t);
        }   
        
                // has status has changed to 'Sent for Settlement' and are there open tasks
         
               if (Trigger.oldMap != null && newOpp.Status__c != Trigger.oldMap.get(newOpp.Id).Status__c && openTasks.containsKey(newOpp.Id)){
                 if (newOpp.Status__c == 'Sent for Settlement' ){  
                      //Trigger.New[0].Status__c.AddError('The status cannot be changed while there are open tasks.');
                    newOpp.Status__c.AddError('The status cannot be changed while there are open tasks.');
                  }
                
               }
            }                       
        }    
        
        
        // loop through the finance products and update the end of loan date if applicable
        List<Product__c> products = new List<Product__c>();
        for (Product__c p : [SELECT Id,
                                    Opportunity_Name__c,
                                    Loan_Term__c,
                                    End_of_Loan_Date__c
                             FROM Product__c
                             WHERE Opportunity_Name__c IN :Trigger.NewMap.keySet()
                             AND RecordType.Name = 'Finance']){
      String oldStatus = '';
            if (Trigger.OldMap != null){
                oldStatus = Trigger.OldMap.get(p.Opportunity_Name__c).Status__c;
            }
        
            // find the potential new end of loan date
            Date endOfLoan;
            if (Trigger.NewMap.get(p.Opportunity_Name__c).Date_Settled__c != null && p.Loan_Term__c != null){
                endOfLoan = Trigger.NewMap.get(p.Opportunity_Name__c).Date_Settled__c.addMonths(Integer.valueOf(p.Loan_Term__c));
            }
    
            // if the end of loan date has changed then 
            if (endOfLoan != p.End_of_Loan_Date__c){
        p.End_of_Loan_Date__c = endOfLoan;
        products.add(p);     
      }
        } 
        
        
      List<Call_Reminder__c> callRemindersToAdd = new List<Call_Reminder__c>();
        // this should only run when 1 opportunity is inserted/updated
        if (Trigger.New.size() == 1){     
            Id taskOwnerId;
            if(Trigger.New[0].Account__c != null){
              for (Custom_Opportunity__c opps :Trigger.new ) {
            
                  taskOwnerId =  opps.OwnerId; 
              }
            }
            // only check the status if it has changed
            if (Trigger.Old == null || Trigger.New[0].Status__c != Trigger.oldMap.get(Trigger.New[0].Id).Status__c){
              set<Id> settleMntTeam= new set<Id>(); 
               for(User usrId:[Select id,name from User where name in ('Katia Abi-Richa','Armando Cerquozzi','Kate Nguyen')]){                  
                 settleMntTeam.add(usrId.id);                   
               }
               if (Trigger.New[0].Id != null && Trigger.New[0].Status__c != 'Settled'){
                  List<Call_Reminder__c> existingCallReminders = [Select Id from Call_Reminder__c where Custom_Opportunity__c = :Trigger.New[0].Id];
                  if(existingCallReminders != null && !existingCallReminders.isEmpty()){
                    delete existingCallReminders;
                  }
                  
                }
                if (Trigger.New[0].Id != null && Trigger.New[0].Status__c == 'Settled'){
                  List<Call_Reminder__c> existingCallReminders = [Select Id from Call_Reminder__c where Custom_Opportunity__c = :Trigger.New[0].Id];
                  if(existingCallReminders == null || existingCallReminders.isEmpty()){
            Call_Reminder__c cRem1 = new Call_Reminder__c(Name = '3rd month reminder', Custom_Opportunity__c = Trigger.New[0].Id);
            callRemindersToAdd.add(cRem1);
            Call_Reminder__c cRem2 = new Call_Reminder__c(Name = '1st year reminder', Custom_Opportunity__c = Trigger.New[0].Id);
            callRemindersToAdd.add(cRem2);
            Call_Reminder__c cRem3 = new Call_Reminder__c(Name = '2nd year reminder', Custom_Opportunity__c = Trigger.New[0].Id);
            callRemindersToAdd.add(cRem3);
            Call_Reminder__c cRem4 = new Call_Reminder__c(Name = '3rd year reminder', Custom_Opportunity__c = Trigger.New[0].Id);
            callRemindersToAdd.add(cRem4);
            Call_Reminder__c cRem5 = new Call_Reminder__c(Name = '4th year reminder', Custom_Opportunity__c = Trigger.New[0].Id);
            callRemindersToAdd.add(cRem5);
                    
                  }
                }               
                if (Trigger.New[0].Status__c == 'I Consent'
                    || Trigger.New[0].Status__c == 'Quote Sent'
                    || Trigger.New[0].Status__c == 'Application Form Sent'
                    || Trigger.New[0].Status__c == 'Application Forms Received'
                    || Trigger.New[0].Status__c == 'Awaiting Paperwork'
                    || Trigger.New[0].Status__c == '24 Hour Call'
                    || Trigger.New[0].Status__c == 'Future Follow Up'
                    || Trigger.New[0].Status__c == 'Submitted for Approval'
                    || Trigger.New[0].Status__c == 'Pre-Approved'
                    || Trigger.New[0].Status__c == 'Invoice Requested'
                    || Trigger.New[0].Status__c == 'Pre-approved FFU'){ 
          TaskCreator.CreateTask(taskOwnerId,
                                           Trigger.New[0].Id,
                                           'Make Contact',
                                           'Contact the client within the next 24 hours',
                                           1,
                                           'High',
                                            24);
                
                } else if(Trigger.New[0].Status__c == 'Internal Settlement'){
                   for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           Trigger.New[0].Id,
                                           'Internal Settlement',
                                           'Overdue for Documents issue',
                                           0,
                                           'Normal',
                                           2);
                    }
                } else if (Trigger.New[0].Status__c == 'Awaiting Further Information'){
          for( Id stlId:settleMntTeam){
            TaskCreator.CreateTask(stlId,
                                           Trigger.New[0].Id,
                                           'Awaiting Further Information',
                                           'Awaiting Paperwork',
                                           0,
                                           'Normal',
                                           4);
                    }
                
                } else if (Trigger.New[0].Status__c == 'Documents Sent'){                    
                     for( Id stlId:settleMntTeam){
                      TaskCreator.CreateTask(stlId,
                                           Trigger.New[0].Id,
                                           'Documents Sent',
                                           'Follow up Client',
                                           0,
                                           'Normal',
                                           12);
                    }
                
                } else if (Trigger.New[0].Status__c == 'Sent to Lender'){                    
                     for( Id stlId:settleMntTeam){
                      TaskCreator.CreateTask(stlId,
                                           Trigger.New[0].Id,
                                           'Sent to Lender',
                                           'Docs to Lender',
                                           0,
                                           'Normal',
                                           4);
                    }                
                } else if (Trigger.New[0].Status__c == 'Settlement Rejected'){
          for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           Trigger.New[0].Id,
                                           'Settlement Rejected',
                                           'Check Settlement Status',
                                           0,
                                           'Normal',
                                           1);
                  }
                } else if (Trigger.New[0].Status__c == 'Invoice Received'){                                 
                    String comments = 'Please complete the following:\n\n';
                    comments += '1. Generate doc worksheet\n';
                    comments += '2. Preliminary assessment\n';
                    comments += '3. Prepare documents ready for settlement';
                
                    TaskCreator.CreateTask(taskOwnerId,
                                           Trigger.New[0].Id,
                                           'Pre-settlement tasks for ' + Trigger.New[0].Name,
                                           comments,                                       
                                           1,
                                           'Normal',
                                           24);       
             }                  
            }                      
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT id, Lead_Status__c,logged_in_user__c,Generated_Date__c,OwnerId, Owner.Name FROM Account WHERE id IN: accId]); 
        Map<Id,Lead__c> leadMap = new Map<Id,Lead__c>([SELECT id, OwnerId, Owner.Name FROM Lead__c WHERE id IN: leadId]);
       
    if(trigger.isInsert){
      if(oppIds.size()>0){               
                 if(!Test.isRunningTest()) {       
                    integer ctr;
                    List<Custom_Opportunity__c> oppBatch = new List<Custom_Opportunity__c>();
                  
                    while (listOppInsert.size() > 0){
                        if (listOppInsert.size() > 40){                     
                          for (ctr = 0; ctr > 40; ctr++){
                              oppBatch.add(listOppInsert[ctr]);
                                listOppInsert.remove(ctr);
                             }
                            System.enqueueJob(new queueActiveOppCampaignCallout (oppBatch,idToStatusMap));
                            oppBatch = new List<Custom_Opportunity__c>();                            
                        } else {
                          System.enqueueJob(new queueActiveOppCampaignCallout (listOppInsert,idToStatusMap));
                            break;
                        }  
                    }                                    
                 } //end if
             }           
    }
       
         if(trigger.isUpdate){       
          if(OppUpdsIds.size()>0){
                if(!Test.isRunningTest()) {       
                    integer ctr;
                    List<Custom_Opportunity__c> oppBatch = new List<Custom_Opportunity__c>();
                    List<Custom_Opportunity__c> oppBatch2 = new List<Custom_Opportunity__c>();
                    if (listOppUpdate.size() > 40)    {                     
                        for (ctr = 0; ctr > 40; ctr++){
                          oppBatch.add(listOppUpdate[ctr]);
                            listOppUpdate.remove(ctr);
                      }
                             //System.enqueueJob(new queueActiveOppTagCallout (oppBatch,idToStatusMap)); 
                            //oppBatch = new List<Custom_Opportunity__c>();                            
                    }
                    if(listOppUpdate.size() > 0){
                      for(Custom_Opportunity__c opp: listOppUpdate){
                          oppBatch2.add(opp);
                        }
                    }
                    /*while (listOppUpdate.size() > 0){
                        if (listOppUpdate.size() > 40)    {                     
                          for (ctr = 0; ctr > 40; ctr++){
                              oppBatch.add(listOppUpdate[ctr]);
                                listOppUpdate.remove(ctr);
                             }
                             //System.enqueueJob(new queueActiveOppTagCallout (oppBatch,idToStatusMap)); 
                            //oppBatch = new List<Custom_Opportunity__c>();                            
                        }else{
                          for(Custom_Opportunity__c opp: listOppUpdate){
                            oppBatch2.add(opp);
                          }
                          
                          //System.enqueueJob(new queueActiveOppTagCallout (listOppUpdate,idToStatusMap));
                            break;
                        }
                    }*/
                    if(!oppBatch.isEmpty()){
                      System.enqueueJob(new queueActiveOppTagCallout (oppBatch,idToStatusMap)); 
                    }
                    if(!oppBatch2.isEmpty()){
                      System.enqueueJob(new queueActiveOppTagCallout (oppBatch2,idToStatusMap));
                    }
                                      
                 } //end if
             }       
         }
        
        // The feefo callout code. Now it is commented for Active Campaign deployment.
        Set<Id> calloutOpps = new Set<Id> ();
        // Reflect Account status same as lead status.     
         for (Custom_Opportunity__c cp :Trigger.new) {
            if(cp.Status__c != null && !accMap.isEmpty()){
                accMap.get(cp.Account__c).Opportunity_Status__c = cp.status__c;
          }
          if(trigger.isUpdate){
            if(cp.Status__c != trigger.oldMap.get(cp.Id).Status__c){
              if(trigger.oldMap.get(cp.Id).Status__c == 'unresolved opportunity'){        
                    accMap.get(cp.Account__c).ownerId =  cp.OwnerId; 
                  }
                  if(cp.Status__c == 'unresolved opportunity'){
                      accMap.get(cp.Account__c).ownerId =  cp.OwnerId; 
                      accMap.get(cp.Account__c).Opportunity_Status__c = cp.status__c;
                   }
                   if(cp.Status__c == 'Settled') {
                    calloutOpps.add(cp.Id);
                }
            }
          } else {
            if (cp.Status__c == 'Settled') {
                  calloutOpps.add(cp.Id);
              }
          }  
         }
        
        //List<AccountShare> acctSharesDel = new List<AccountShare>();
        //List<AccountShare> acctShares = new List<AccountShare>();
        
        if(!newOppOwnerIdMap.keySet().isEmpty()){
          Id sysGenId = AccountShareService.sysGenId;
          set<id> acctIdToCheck = new set<id>();
          for(Id acctId : newOppOwnerIdMap.keySet()){
            //check if account related is also the opportunity owner
            if((accMap.get(acctId)!=null) && (accMap.get(acctId).OwnerId != newOppOwnerIdMap.get(acctId) || accMap.get(acctId).Owner.Name == 'System Generated')){
              acctIdToCheck.add(acctId);
              if(String.valueOf(newOppOwnerIdMap.get(acctId)).startsWith('005')){
                accMap.get(acctId).OwnerId = newOppOwnerIdMap.get(acctId);
              } else {
                if(sysGenId != null){
                  accMap.get(acctId).OwnerId = sysGenId;
                }
                
              }
            }
            
          }
          if(!acctIdToCheck.isEmpty()){          
            //AccountShareService.deleteShares(acctIdToCheck);
            if(!accMap.isEmpty()){
                update accMap.values();
              }      
          }
        }          
      
        if(!newLeadOwnerIdMap.isEmpty()){
          Id sysGenId = AccountShareService.sysGenId;
          set<id> leadIdToCheck = new set<id>();
          for(Id ldId : newLeadOwnerIdMap.keySet()){
            if(leadMap.get(ldId).OwnerId != newLeadOwnerIdMap.get(ldId) || leadMap.get(ldId).Owner.Name == 'System Generated'){
              leadIdToCheck.add(ldId);
              if(String.valueOf(newLeadOwnerIdMap.get(ldId)).startsWith('005')){
                leadMap.get(ldId).OwnerId = newLeadOwnerIdMap.get(ldId);
              } else {
                if(sysGenId != null){
                  leadMap.get(ldId).OwnerId = sysGenId;
                }
                
              }
              
            }
          }
          if(!leadIdToCheck.isEmpty()){          
            //LeadShareService.deleteShares(leadIdToCheck);
            if(!leadMap.isEmpty()){
                update leadMap.values();
              }      
          }
        } 
        try{
          
          
      
      if(!tasks.isEmpty()){
        update tasks;
      }
      
      if(!products.isEmpty()){
        update products;
      }
      
      if(!callRemindersToAdd.isEmpty()){
        insert callRemindersToAdd;
      }
      
            if(!Test.isRunningTest()) {
              if (!calloutOpps.isEmpty()) {
                  FeefoCallout.makeFeefoCallout (calloutOpps);
              }
      }
        }catch( Exception e){
        
          System.debug('@@Error on callout/account update' + e.getMessage());
        }
        
        
  }
}