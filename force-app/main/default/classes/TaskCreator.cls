public class TaskCreator
{
    public static void CreateTask(Id ownerId, Id whatId, String subject, String comments, Integer dueInDays, String priority, Decimal reminderInHours)    
    {
        CreateTask(ownerId, whatId, subject, comments, dueInDays, priority, reminderInHours, false);   
    }
    
    public static void CreateTask(Id ownerId, Id whatId, String subject, String comments, Integer dueInDays, String priority, Decimal reminderInHours, String ownerType)    
    {
        CreateTask(ownerId, whatId, subject, comments, dueInDays, priority, reminderInHours, false, ownerType);   
    }
	public static void CreateTask(Id ownerId, Id whatId, String subject, String comments, Integer dueInDays, String priority, Decimal reminderInHours, Boolean fromOpportunitySettled, String ownerType)
    {
    		Group grp = [Select DeveloperName From Group where Id = : ownerId and Type= :ownerType];
    		if(grp != null){
    			List<Task> newTaskList = new List<Task>();
    			for(User usr : [select Id from User where UserRole.DeveloperName = :grp.DeveloperName]){
    				Task newTask = new Task();
			        newTask.OwnerId = usr.Id;
			        newTask.WhatId = whatId;
			        newTask.Subject = subject;
			        if(comments == 'Existing Lead has enquired again - Follow up'){
			        
			            newTask.isDuplicate__c=true;
			        
			        }
			        
			        newTask.Description = comments;
			        if (dueInDays != null)
			        {
			            newTask.ActivityDate = (Date.today() + dueInDays);
			        }
			        newTask.Status = 'Not Started';
			        newTask.Priority = priority;
			        if (reminderInHours != null)
			        {
			            newTask.IsReminderSet = true;
			            if (reminderInHours < 1)
			            {
			                newTask.ReminderDateTime = Datetime.now().addMinutes(Integer.valueOf(reminderInHours * 60));
			            }
			            else
			            {
			                newTask.ReminderDateTime = Datetime.now().addHours(Integer.valueOf(reminderInHours));
			            }
			        }
			        newTask.From_Opportunity_Settled__c = fromOpportunitySettled;
			        newTaskList.add(newTask);
    			}
    			
    			if(!newTaskList.isEmpty()){
    				insert newTaskList;
    			}
    		}
    }
    
    public static void CreateTask(Id ownerId, Id whatId, String subject, String comments, Integer dueInDays, String priority, Decimal reminderInHours, Boolean fromOpportunitySettled)

    {
    	if(string.valueOf(ownerId).startsWith('005')){
    		if (SOQLSingletonQueries.isActiveUser(ownerId)) {
		        Task newTask = new Task();
		        newTask.OwnerId = ownerId;
		        newTask.WhatId = whatId;
		        newTask.Subject = subject;
		        if(comments == 'Existing Lead has enquired again - Follow up'){
		        
		            newTask.isDuplicate__c=true;
		        
		        }
		        
		        newTask.Description = comments;
		        if (dueInDays != null)
		        {
		            newTask.ActivityDate = (Date.today() + dueInDays);
		        }
		        newTask.Status = 'Not Started';
		        newTask.Priority = priority;
		        if (reminderInHours != null)
		        {
		            newTask.IsReminderSet = true;
		            if (reminderInHours < 1)
		            {
		                newTask.ReminderDateTime = Datetime.now().addMinutes(Integer.valueOf(reminderInHours * 60));
		            }
		            else
		            {
		                newTask.ReminderDateTime = Datetime.now().addHours(Integer.valueOf(reminderInHours));
		            }
		        }
		        newTask.From_Opportunity_Settled__c = fromOpportunitySettled;
		        
		        insert newTask;
		    }
    	} else {
    		CreateTask(ownerId, whatId, subject, comments, dueInDays, priority, reminderInHours, false, 'Queue');   
    	}
    }
}