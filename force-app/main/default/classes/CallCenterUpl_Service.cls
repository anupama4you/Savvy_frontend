public class CallCenterUpl_Service {
    
    public static void createCallTaskReference (List<Call_Center_Upl__c> newRecords){
        Set<Id> leadIds = new Set<Id>();
        for (Call_Center_Upl__c c : newRecords){
            leadIds.add(c.Account__c);
        }
        //System.debug(':::: CallTaskreference from Aspect System::: List size: ' + leadIds.size());
        
        List<Lead__c> leads = [Select id from Lead__c where id in :leadIds];
        
        if (!leadIds.isEmpty()){
            Map<Id, Id> accountsMap = new Map<Id, Id>();
            for(Custom_Opportunity__c opp : [Select id, Lead__c from Custom_Opportunity__c where Lead__c in :leads order by CreatedDate desc]){
                Id key = opp.Lead__c;
                if (!accountsMap.containsKey(key)){
                    accountsMap.put(key, opp.Id);
                	//System.debug('::::: Lead: ' + opp.Lead__c + ' OppID: ' + opp.Id);
                }
    		}
            
            Map<Id, Lead__c> existLeads = new Map<Id, Lead__c>();
            for (Lead__c l : leads){
                existLeads.put(l.id, l);
            }
            
            List<Task> newTaskList = new List<Task>();
            for (Call_Center_Upl__c c : newRecords){
                if (existLeads.containsKey(c.Account__c)){
                    Id whatId;
                    if (accountsMap.containsKey(c.Account__c)){
                        whatId = accountsMap.get(c.Account__c);
                    }else{
                        whatId = c.Account__c;
                    }
                    
                    Task newTask = new Task();
			        newTask.WhatId = whatId;
                    newTask.Description = 'SmsText:' + StringUtils.validateNull(c.SmsTextSent__c);
                    newTask.Subject = 'Aspects Call - ' + StringUtils.validateNull(c.Numattempts__c) + ' - ' + StringUtils.validateNull(c.Atime1__c) ;
                    newTask.TaskSubtype = 'Call';
                    newTask.Status = 'Completed';
                    newTask.IsReminderSet = false;
                    newTask.CallDisposition = StringUtils.validateNull(c.Dialerdisp__c);
                    newTask.Call_Email__c = StringUtils.validateNull(c.Email__c);
                    newTask.Call_Mobile_Number__c = StringUtils.validateNull(c.Mobile__c);
                    newTask.Call_ATime__c = StringUtils.validateNull(c.Atime1__c);
                    newTask.Call_Num_Attempts__c = StringUtils.validateNull(c.Numattempts__c);
                    newTask.Call_Center_Upl__c  = c.Id;
                    newTask.Call_Agent__c = StringUtils.validateNull(c.Agent__c);
                    newTaskList.add(newTask);
                    //System.debug('---> AccountFile: ' + c.Account__c + ' -WhatId: ' + whatId);
                    
                }
            }
            if(!newTaskList.isEmpty()){
                insert newTaskList;
                System.debug('Total records: ' + newTaskList.size());
            }
			
        }
    }
}