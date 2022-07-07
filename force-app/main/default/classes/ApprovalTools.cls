public without sharing class ApprovalTools {
        
    //Constans
    public static final String PREAPPROVAL_PROCESS_DEFINITION = 'Pre_Approval_v2';
    public static final String AMENDMENT_PROCESS_DEFINITION = 'Amendment_v2';
    public static final String FORMALAPPROVAL_PROCESS_DEFINITION = 'Formal_Approval_v2';
    public static final String PREAPPROVAL_AUTHPROCESS_DEFINITION = 'Pre_approval_Authorisation_process';
    //VD Process
    public static final String VD_SALES_NEW_LEAD_PROCESS_DEFINITION = 'VD_Sales_New_Lead';
    public static final String VD_SALES_ATTEMPT_CONTACT_PROCESS_DEFINITION = 'VD_Sales_Attempted_Contact';
    public static final String VD_SALES_SEARCHING_VEHICLE_PROCESS_DEFINITION = 'VD_Sales_Searching_Vehicle';
    
    public static final String VD_SETTLEMENT_FILE_IN_PROCESS_DEFINITION = 'VD_Settlement_File_In';
    public static final String VD_SETTLEMENT_INVOICE_SENT_PROCESS_DEFINITION = 'VD_Settlement_Invoice_Request_Sent';
    public static final String VD_SETTLEMENT_INVOICE_RECEIVED_PROCESS_DEFINITION = 'VD_Settlement_Invoice_Request_Received';
    
    //Settlement Dashboard Viewer
    public static final String SETTLEMENT_DASHVIEWER_GROUP = 'Settlement Dashboard Viewer';
    public static final String SETTLEMENT_TEAM_QUEUE = 'Settlement Officers';

    public static Map<String, String> newOppStatus = new Map<String, String>();

    public static Id getLastApprover(Id targetObjectId) {
        List<ProcessInstance> data = [SELECT LastActorId, 
                                      (SELECT ActorId FROM StepsAndWorkitems ORDER BY CreatedDate DESC)
                                      FROM ProcessInstance 
                                      WHERE TargetObjectId = :targetObjectId AND Status IN ('Approved','Rejected')
                                      ORDER BY CompletedDate desc limit 10];
        if (data != null && !data.isEmpty()) {
            for (ProcessInstance pi : data) {
                if (pi.LastActorId != null) {
                    if (isUserIdAnApprovalTeam(pi.LastActorId)) {
                        return pi.LastActorId;
                    }
                } else {
                    for (ProcessInstanceStep s : pi.Steps) {  
                        if (isUserIdAnApprovalTeam(s.ActorId)) {
                            return s.ActorId;
                        }
                    }
                }
            }
        }
        return null;
    }
    
    public static Boolean isUserIdAnApprovalTeam(Id userId) {
        Boolean r = false;
        try {
            User u = [SELECT userrole.name, IsActive FROM User WHERE Id = :userId];
            if (u != null && 'Approval Team'.equals(u.userrole.name) && 
                u.IsActive == true) {
                return true;    
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return r;
    }


    public static void reassignApprover(Id objId, Id approverId) { 
        if (objId != null && approverId != null) {
            List<ProcessInstanceWorkItem> workItemList = 
                [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId
                 From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :objId];
            
            if (workItemList != null && !workItemList.isEmpty()) {
                if (workItemList.get(0).ActorId != approverId) {
                    workItemList.get(0).ActorId = approverId;
                    update workItemList;
                    System.debug('reassignApprover >> ActorId updated with ' + approverId + ' for ' + objId);
                }
            }
        }
    }
    
   
    public static void autoAssignApprover(Id objId) {
        System.debug('Starting autoAssignApprover process...');
        Id lastApproverId = getNextApprovalUser(objId);
        if (lastApproverId != null) {
            reassignApprover(objId, lastApproverId);
            System.debug('Process >> ' + objId + ' assigned to ' + lastApproverId);
        } else {
            System.debug('An Approval Team user hasn\'t been found for objId >> ' + objId);
        }

    }
    
    public static Id getNextApprovalUser(Id objId) {
        Id r = getLastApprover(objId);
        System.debug('Searching for the last one approver... >> ' + r);
        if (r == null) {
            System.debug('Auto-assign approver...');
            List<Id> userIds = getApprovalTemUsersIds();
            String userIdsTmp = String.valueOf(userIds);
            System.debug('Approval Team users 1>> ' + userIds);
            System.debug('Approval Team users 2>> ' + userIdsTmp);
            List<AggregateResult> result  = 
            [SELECT ActorId, COUNT(Id) total
             FROM ProcessInstanceWorkitem where ProcessInstanceId IN (
                    SELECT Id FROM ProcessInstance where Status = 'Pending'
             ) AND ActorId IN (select id from user where userrole.name = 'Approval Team')
             GROUP BY ActorId ORDER BY COUNT(Id)];
             System.debug('Load work Approval Team users >> ' + result);

             Map<Id, Integer> loadWork = new Map<Id, Integer>();
             for (AggregateResult ar : result) {
                loadWork.put((Id)ar.get('ActorId'), (Integer)ar.get('total'));
             }
             System.debug('Map created with the Approval Team users work load >> ' + loadWork.size() + '|' + loadWork);
             System.debug('Searching for Approval Team users without assignments...');
             for (Id userId : userIds) {
                if (!loadWork.containsKey(userId)) {
                    r = userId;
                    System.debug('An Approval Team user has been found >> ' + r);
                    break;
                }
             }
             if (r == null && !result.isEmpty()) {
                for (AggregateResult a : result) {
                    if (r == null && userIdsTmp.contains((Id)a.get('ActorId'))) {
                        r = (Id)a.get('ActorId');
                        System.debug('Choosing the first Approval Team user from work load >> ' + r);
                    }
                }
             }
        }
        return r;
    }

    public static Id[] getApprovalTemUsersIds() {
        return getApprovalTemUsersIds(true);
    }

    public static Id[] getApprovalTemUsersIds(boolean onlyActiveUsers) {
        List<User> users = null;
        if (onlyActiveUsers) {
            users = [select id from user where userrole.name = 'Approval Team' and IsActive = true];
        } else {
            users = [select id from user where userrole.name = 'Approval Team'];
        }
        Id[] r = new List<Id>();
        if (users != null && !users.isEmpty()) {
            for (User u : users) {
                r.add(u.Id);
            }
        }
        return r;
    }
    
    /**
    * Get ProcessInstanceWorkItemId using SOQL
    **/
    public static Id getWorkItemId(Id targetObjectId) {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
    /**
    * Get Approval History List
    **/
    public static List<ApprovalStepDTO> getApprovalHistory(Id objId) {
        List<ApprovalStepDTO> r = new List<ApprovalStepDTO>();
        //System.debug('Getting processInstance for ' + objId);
        List<ProcessInstance> processInstanceList = getProcessInstance(objId);
        for (ProcessInstance processInstance : processInstanceList) {
            //System.debug('Getting processNode for ' + processInstance);
            Map<Id,ProcessNode> mpProcessNode = getProcessNode(processInstance);
            if(processInstance == null) return r;
            //System.debug('Iterating over processInstance.Steps...');
            for(ProcessInstanceStep stepInstance : processInstance.Steps){
                ApprovalStepDTO approvalStep = new ApprovalStepDTO(stepInstance,mpProcessNode.get(stepInstance.StepNodeID));
                r.add(approvalStep);
                //System.debug('approvalStep >> ' + approvalStep.instanceStep.StepStatus + '|' + approvalStep.instanceStep.CreatedDate);
            }
        }
        return r;
    }

    //Get the Process Instance Attached to the Record
    private static List<ProcessInstance> getProcessInstance(Id objId){
        List<ProcessInstance> lstProcessInstance = [SELECT Id, ProcessDefinitionID,
        (Select StepStatus,StepNodeId, OriginalActor.Name,ActorId, Actor.Name, Comments,
        CreatedDate, CreatedById,CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC)
        FROM ProcessInstance WHERE TargetObjectId = :objId ORDER BY CompletedDate desc LIMIT 20];
        return lstProcessInstance;
    }

    //get All Process Nodes attached to Process Instance
    public static Map<Id,ProcessNode> getProcessNode(ProcessInstance processInstance){
        if(processInstance == null) return null;
        return new Map<Id,ProcessNode>([SELECT Id,Name FROM ProcessNode
                                        WHERE ProcessDefinitionId = :processInstance.ProcessDefinitionId]);

    }

    public static List<ProcessInstanceStep> getMostRecentProcessInstanceSteps(Id objId) {
        List<ProcessInstanceStep> r = new List<ProcessInstanceStep>();
        List<ProcessInstance> lstProcessInstance = [
        SELECT Id, ProcessDefinitionID, (
            SELECT StepStatus,StepNodeId, OriginalActor.Name,ActorId, Actor.Name, Comments,
            CreatedDate, CreatedById,CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC)
        FROM ProcessInstance WHERE TargetObjectId = :objId ORDER BY CompletedDate DESC LIMIT 1];

        if (lstProcessInstance != null && !lstProcessInstance.isEmpty()) {
            r = lstProcessInstance[0].Steps;
        }

        return r;
    }

    public static void submittForApproval(String approvalProcessDefinition, Id objId, String comments, 
                                          boolean scheduleUnattendedSubmission) {
        submittForApproval(approvalProcessDefinition, objId, comments, scheduleUnattendedSubmission, null);
    }
    public static void submittForApproval(String approvalProcessDefinition, Id objId, String comments, 
                                         boolean scheduleUnattendedSubmission, Id approverId) {
        submittForApproval(approvalProcessDefinition, objId, comments, scheduleUnattendedSubmission, approverId, null);
    }

    public static void submittForApproval(String approvalProcessDefinition, Id objId, String comments, 
                                          boolean scheduleUnattendedSubmission, Id approverId, Id oppOwnerId) {
        // Create an approval request for the Opportunity
        System.debug('approvalProcessDefinition >> ' + approvalProcessDefinition + '|objId >> ' + objId + '|comments >> ' + comments + 
                     '|scheduleUnattendedSubmission >> ' + scheduleUnattendedSubmission + '|approverId >> ' + approverId + 
                     '|oppOwnerId >> ' + oppOwnerId);
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setProcessDefinitionNameOrId(approvalProcessDefinition);
        req1.setObjectId(objId); 
        req1.setComments(comments);
        
        if (oppOwnerId != null) {
            req1.setSubmitterId(oppOwnerId);
        }
        try {
            if (approverId == null) {
                //Autoassignment
                approverId = ApprovalTools.getNextApprovalUser(objId);
            }
            if (approverId != null) {
                req1.setNextApproverIds(new Id[] {approverId});
            }
        } catch (Exception e) {
            System.debug('Error during assignment >> ' + e.getMessage());
        }
        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);

        if (result.isSuccess()) {
            if (scheduleUnattendedSubmission) {
                //Schedule notifications
                sheduleNotification(approvalProcessDefinition, objId);
            }
        }
    }

    private static void sheduleNotification(String approvalProcessDefinition, Id objId) {
        String currentStatus = getOpportunityCurrentStatus(objId);
        Integer min = -1;
        if (PREAPPROVAL_PROCESS_DEFINITION.equals(approvalProcessDefinition)) {
            min = 120;    //120
        } else if (AMENDMENT_PROCESS_DEFINITION.equals(approvalProcessDefinition)) {
            min = 30;
        } else if (FORMALAPPROVAL_PROCESS_DEFINITION.equals(approvalProcessDefinition)) {
            min = 30;
        }
        if (min > 0) {
            // SendADelayedNotification.scheduleNotification(objId, currentStatus, '', min);
        }
    }

    public static String getOpportunityCurrentStatus(Id oppId) {
        String r = null;
        List<Custom_Opportunity__c> opps = [SELECT Status__c FROM Custom_Opportunity__c WHERE Id = :oppId];
        if (!opps.isEmpty()) {
            r = opps[0].Status__c;
        }
        return r;
    }

    public static void approvalProcess(Id objId, String action, String comments, String currentStatus, Id approverId, Id ownerObjId) {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(comments);
        req.setAction(action);
        req.setNextApproverIds(new Id[] {approverId});
        Id workItemId = ApprovalTools.getWorkItemId(objId); 

        if(workItemId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No workID found it.'));
        } else {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            if (result.isSuccess()) {
                String newStatus = getOpportunityCurrentStatus(objId);

                //Remove schedulle email alerts
                SendADelayedNotification.removeAllScheduleNotifications(objId);
                //Close task reminders
                SendADelayedNotification.closeAllTaskNotifications(objId);

                if ('Approve'.equals(action)) {
                    if (newStatus.containsIgnoreCase('Sent to')) {
                        //Schedule notifications
                        sheduleSentToLenderNotification(objId, newStatus);
                    } else if ((newStatus.equals('Pre-Approved')) || (newStatus.equals('Formal Approved'))) {
                        //Generate a task
                        createTask(ownerObjId, objId, 'Follow up call', 'High', (1/60));
                    }
                } else if ('Reject'.equals(action)) {
                    //Generate a task
                    createTask(ownerObjId, objId, 'Follow up call', 'High', (1/60));
                    
                }
            }
        }
    }

    private static void sheduleSentToLenderNotification(Id objId, String currentStatus) {
        System.debug('sheduleSentToLenderNotification... ' + currentStatus);
        Integer min = 1;
        if (currentStatus.contains('Pre-Approval')) {
            min = 120; //120
        } else if (currentStatus.contains('Amendment')) {
            min = 30;    //30
        } else if (currentStatus.contains('Formal Approval')) {
            min = 30;    //30
        }

        // SendADelayedNotification.scheduleNotification(objId, currentStatus, '', min, false, true);
    }


    private static void createTask(Id ownerId, Id objId, String subject, String priority, Decimal reminderInHours) {
        System.debug('Creating a task for >> ' + objId + '|' + ownerId + '|' + subject + '|' + priority + '|' + reminderInHours);
        Id ownerIdTmp = ownerId;
        TaskCreator.CreateTask(
            ownerIdTmp, objId, subject, '', null, priority, reminderInHours
        );
    }

    public static User getUser(Id userId) {
        User r = null;
        if (userId != null) {
            List<User> u = [SELECT Id, Name FROM User WHERE Id = :userId];
            if (u != null && !u.isEmpty()) {
                r = u[0];
            }
        }
        return r;
    }

    public static ProcessInstanceWorkitem getOpportunityProcessInstanceWorkitemId(Id oppId) {
        ProcessInstanceWorkitem r = null;
        if (oppId != null) {
            List<ProcessInstanceWorkitem> ids = [SELECT Id, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId IN (
                            SELECT Id FROM ProcessInstance 
                            WHERE TargetObjectId = :oppId AND Status = 'Pending')];
            if (ids != null && !ids.isEmpty()) {
                r = ids[0];
            }
        }
        return r;
    }

    public static Map<Id,ProcessInstanceWorkitem> getOpportunityProcessInstanceWorkitemIdMap(List<Id> idList) {
        Map<Id,ProcessInstanceWorkitem> r = new Map<Id,ProcessInstanceWorkitem>();
        if (idList != null) {
            Map<Id,ProcessInstance> piMap = new Map<Id,ProcessInstance>();
            List<ProcessInstance> piList = [SELECT Id, TargetObjectId FROM ProcessInstance 
                                          WHERE TargetObjectId IN :idList AND Status = 'Pending'];
            for (ProcessInstance p : piList) {
                piMap.put(p.Id, p);
            }
        
            List<ProcessInstanceWorkitem> ids = [SELECT Id, ActorId, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId IN (
                            SELECT Id FROM ProcessInstance 
                            WHERE TargetObjectId IN :idList AND Status = 'Pending')];
            for (ProcessInstanceWorkitem p : ids) {
                ProcessInstance pi = piMap.get(p.ProcessInstanceId);
                if (!piMap.containsKey(pi.TargetObjectId)) {
                    r.put(pi.TargetObjectId, p);
                }
            }
        }
        return r;
    }

    public static Map<Id, User> getUserApprovalTeamUsers() {
        Map<Id, User> r = new Map<Id, User>();
        List<User> users = [SELECT Id, Name FROM User WHERE userrole.name = 'Approval Team'];
        for (User u : users) {
            r.put(u.Id, u);
        }
        return r;
    }

    public static void approvalVDProcess(Id objId, String action, String comments, String currentStatus, String actionSelected, Id approverId, Id ownerObjId) {
        System.debug('Starting approvalVDProcess ...');
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(comments);
        req.setAction(action);
        req.setNextApproverIds(new Id[] {approverId});
        Id workItemId = ApprovalTools.getWorkItemId(objId); 

        if(workItemId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No workID found it.'));
        } else {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            System.debug('Approval Result: ' + result.getInstanceStatus());
            if (!result.isSuccess()) {
                for (Database.Error e: result.getErrors()) {
                    System.debug(e.getStatusCode() + ': ' + e.getMessage());
                }
            }
            //if (result.isSuccess()) {
                
                //String newStatus = getOpportunityVDCurrentStatus(objId);
                //System.debug('process successful ' + '!' + newStatus);
                ////Remove schedulle email alerts
                //SendADelayedNotification.removeAllScheduleNotifications(objId);
                ////Close task reminders
                //SendADelayedNotification.closeAllTaskNotifications(objId);

                /*if ('Approve'.equals(action)) {
                    if (newStatus.containsIgnoreCase('Sent to')) {
                        //Schedule notifications
                        //sheduleSentToLenderNotification(objId, newStatus);
                    } else if ((newStatus.equals('Pre-Approved')) || (newStatus.equals('Formal Approved'))) {
                        //Generate a task
                        //createTask(ownerObjId, objId, 'Follow up call', 'High', (1/60));
                    }
                } else if ('Reject'.equals(action)) {
                    //
                    
                }*/
            //}
            
        }
    }

    public static String getOpportunityVDCurrentStatus(Id oppId) {
        String r = null;
        List<Custom_Opportunity__c> opps = [SELECT VD_Worksheet__r.Approval_Status__c FROM Custom_Opportunity__c WHERE Id = :oppId];
        if (!opps.isEmpty()) {
            r = opps[0].VD_Worksheet__r.Approval_Status__c;
        }
        return r;
    }

    public static Id getProcessDefinitionIdByName(String name) {
        Id r = null;
        List<ProcessDefinition> tmpDef = [
                SELECT Id, Name FROM ProcessDefinition 
                WHERE Name = :name AND State = 'Active'];
        if (tmpDef.isEmpty()) {
            r = tmpDef.get(0).Id;
        }
        return r;
    }

    public static String checkRecordForApprovalProcess(Id objId) {
        String r = null;
        List<ProcessDefinition> tmnpList = [
            SELECT Name FROM ProcessDefinition WHERE Id in (
                SELECT ProcessDefinitionID FROM ProcessInstance WHERE TargetObjectId = :objId AND Status = 'Pending'
            ) LIMIT 1
        ];
        if (!tmnpList.isEmpty()) {
            r = tmnpList.get(0).Name;
        }
        return r;
    }

    public static Boolean isUserIdSettlementTeam(Id userId) {
        //'Finance Administrator' //Prifile
        //' Settlement Team'      //Role
        // Boolean r = false;
        Map<Id, User> users = getUserSettlementTeamUsers();
        User u = users.get(userId);
        if (u != null && u.isActive) {
            return true;
        }
        // try {
        //     User u = [SELECT userrole.name, IsActive FROM User WHERE Id = :userId];
        //     if (u != null && 'Settlement Team'.equals(u.userrole.name) && 
        //         u.IsActive == true) {
        //         return true;    
        //     }
        // } catch (Exception e) {
        //     System.debug('Error: ' + e.getMessage());
        // }
        return false;
    }

    public static void recallProcess(Id objId, String comments) {
        Id workItemId = ApprovalTools.getWorkItemId(objId); 
        Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
        if (workItemId != null) {
            pwr.setWorkitemId(workItemId);
            pwr.setComments(comments);
            pwr.setAction('Removed'); 
            Approval.ProcessResult pr = Approval.process(pwr);
        } else {
            System.debug('No active approval process for TargetObjectId >> ' + objId);
        }
    }
    
    //Juan Carlos Romero 25/07/2018
    public static Id[] getSettlementTeamUsersIds(boolean onlyActiveUsers) {
        List<User> users = null;
        Set<Id> settledTeamUsers = SOQLSingletonQueries.getGroupMembers(SETTLEMENT_TEAM_QUEUE);
        if (onlyActiveUsers) {
            users = [select id from user where (userrole.name = 'Settlement Team' or userrole.name = 'Approval Team')
                     and id in :settledTeamUsers and IsActive = true];
        } else {
            users = [select id from user where (userrole.name = 'Settlement Team' or userrole.name = 'Approval Team')
                     and id in :settledTeamUsers];
        }
        Id[] r = new List<Id>();
        if (users != null && !users.isEmpty()) {
            for (User u : users) {
                r.add(u.Id);
            }
        }
        return r;
    }

	//JUAN ROMERO 01/08/2018
    public static Map<Id, User> getUserSettlementTeamUsers() {
        Map<Id, User> r = new Map<Id, User>();
        Set<Id> settledTeamUsers = SOQLSingletonQueries.getGroupMembers(SETTLEMENT_TEAM_QUEUE);
        List<User> users = [SELECT Id, Name, isActive FROM User WHERE (userrole.name = 'Settlement Team' or userrole.name = 'Approval Team')
        AND id in :settledTeamUsers];
        for (User u : users) {
            r.put(u.Id, u);
        }
        return r;
    }
    
    //JUAN CARLOS ROMERO 04/09/2018
    public static Id[] getShowSettlement(){
        Id[] r = new List<Id>();
        List<GroupMember> member = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name= :SETTLEMENT_DASHVIEWER_GROUP];
        if(member != null && !member.isEmpty()){
            for(GroupMember g : member){
                r.add(g.UserOrGroupId);
            }
        }
        return r;
    }

    // Lelo             2021-10-28
    public static void submitForFormalApproval(Id recordId, String comments) {
      submittForApproval(PREAPPROVAL_PROCESS_DEFINITION, recordId, comments, false);
    }

    public static void generatePreliminaryAssessmet(Id oppId) {
      CloudDocsHelper.deleteCloudDocument(oppId, 'Preliminary Assessment');
      PageReference pdf = Page.PreliminaryAssessmentTmpl;
      pdf.getParameters().put('id', oppId);
      String prefixName = 'PreliminaryAssessment';
      QuotingToolHelper.attachPdfFile(oppId, prefixName, pdf, true);
    }

    public static void generateApplicationFormDocument(Id oppId) {
      //Re-generate Application Form (Pre-approval) document
      try {
        CloudDocGeneratorBatch.createBatch(oppId, CloudDocGeneratorBatch.APP_PREAPPROVAL_DOC, 1);
      } catch (Exception e) {
        System.debug('generateApplicationFormDocument >> ' + e);
      }
    }
}