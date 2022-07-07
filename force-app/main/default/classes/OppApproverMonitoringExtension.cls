public with sharing class OppApproverMonitoringExtension {

    private static final String PROCESS_NODE_PREAPPROVAL_CHECK_DOCS = 'Pre_Approval';
    private static final String PROCESS_NODE_AMENDMENT_CHECK_DOCS = 'Checking_Documentation_Amendment';
    private static final String PROCESS_NODE_FORMAL_APPROVAL_CHECK_DOCS = 'Formal_Approval';

    private static final String PROCESS_DEF_PREAPPROVAL = 'Pre Approval';
    private static final String PROCESS_DEF_AMENDMENT = 'Amendment';
    private static final String PROCESS_DEF_FORMAL_APPROVAL = 'Formal Approval';

    private static final String PROCESS_TYPE_PREAPPROVAL = 'P';
    private static final String PROCESS_TYPE_AMENDMENT = 'A';
    private static final String PROCESS_TYPE_FORMAL_APPROVAL = 'F';

    //Aproval Steps description
    private Id STEP_RPEAPPROVAL = null;
    private Id STEP_AMENDMENT = null;
    private Id STEP_FORMAL_APPROVAL = null;
    
    //Aproval Process definition Ids
    private Id PROCESS_PREAPPROVAL_ID = null;
    private Id PROCESS_AMENDMENT_ID = null;
    private Id PROCESS_FORMAL_APPROVAL_ID = null;

    private Id PROFILE_APPROVAL_TEAM_ID = null;

	public User o {set;get;}

    private Date StartDate {set;get;}
    private Date EndDate {set;get;}
    public Integer month {set;get;}
    public Integer year {set;get;}

    public List<RowDTO> data {set;get;}
    private Map<String, SummaryDTO> summaryMap;
    public SummaryDTO totals {set;get;}
    public Integer oppSettleds {set;get;}
    public Integer oppProcesseds {set;get;}

    public Boolean isResultMode {set;get;}

    public OppApproverMonitoringExtension() {
        isResultMode = false;
        //Checking params...
        String id = System.currentPageReference().getParameters().get('ID');
        String m = System.currentPageReference().getParameters().get('M');
        String y = System.currentPageReference().getParameters().get('Y');
        Date today = Date.today();
        if (String.isBlank(id)) {
            id = UserInfo.getUserId();
            isResultMode = true;
        }
        o = [SELECT Id, Name, ProfileId FROM User WHERE Id = :id];
        //Init dates
        if (!String.isBlank(m)) {
            month = Integer.valueOf(m);
        } else {
            month = today.month();    
        }
        if (!String.isBlank(y)) {
            year = Integer.valueOf(y);
        } else {
            year = today.year();
        }
        System.debug(id + '|' + month + '|' + year);

        //Load Data
        loadData();
        search();
    }

    private void loadData() {
        //Approval Team Profile Id
        List<Profile> p = [SELECT Id FROM Profile WHERE Name = 'Approval Officer'];
        if (!p.isEmpty()) {
            PROFILE_APPROVAL_TEAM_ID = p.get(0).Id;
        }
        System.debug('Profile >> ' + PROFILE_APPROVAL_TEAM_ID);
        //Load nodes descriptions
        List<ProcessNode> tmpNodes = [SELECT Id, DeveloperName FROM ProcessNode];
        for(ProcessNode n : tmpNodes) {
            if (PROCESS_NODE_PREAPPROVAL_CHECK_DOCS.equals(n.DeveloperName)) {
                STEP_RPEAPPROVAL = n.Id;
            } else if (PROCESS_NODE_AMENDMENT_CHECK_DOCS.equals(n.DeveloperName)) {
                STEP_AMENDMENT = n.Id;
            } else if (PROCESS_NODE_FORMAL_APPROVAL_CHECK_DOCS.equals(n.DeveloperName)) {
                STEP_FORMAL_APPROVAL = n.Id;
            }
        }
        //Proces definition
        List<ProcessDefinition> tmpDef = [SELECT Id, Name FROM ProcessDefinition WHERE State = 'Active'];
        for(ProcessDefinition n : tmpDef) {
            if (PROCESS_DEF_PREAPPROVAL.equals(n.Name)) {
                PROCESS_PREAPPROVAL_ID = n.Id;
                System.debug('PROCESS_PREAPPROVAL_ID >> ' + PROCESS_PREAPPROVAL_ID);
            } else if (PROCESS_DEF_AMENDMENT.equals(n.Name)) {
                PROCESS_AMENDMENT_ID = n.Id;
                System.debug('PROCESS_AMENDMENT_ID >> ' + PROCESS_AMENDMENT_ID);
            } else if (PROCESS_DEF_FORMAL_APPROVAL.equals(n.Name)) {
                PROCESS_FORMAL_APPROVAL_ID = n.Id;
                System.debug('STEP_FORMAL_APPROVAL >> ' + PROCESS_FORMAL_APPROVAL_ID);
            }
        }
    }

    public PageReference search() {
        StartDate = Date.newInstance(year, month, 1);
        EndDate = StartDate.addMonths(1);
        summaryMap = new Map<String, SummaryDTO>();
        oppSettleds = 0;
        oppProcesseds = 0;
        data = getApprovalHistory();
        calculateTotals();
        return null;
    }

    public List<SelectOption> getYearOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer currentYear = Date.today().year();
        for (; currentYear >= 2016; currentYear--) {
            r.add(new SelectOption(String.valueOf(currentYear), String.valueOf(currentYear)));
        }
        return r;
    }

    public List<SelectOption> getMonthOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('1','January'));
        r.add(new SelectOption('2','February'));
        r.add(new SelectOption('3','March'));
        r.add(new SelectOption('4','April'));
        r.add(new SelectOption('5','May'));
        r.add(new SelectOption('6','June'));
        r.add(new SelectOption('7','July'));
        r.add(new SelectOption('8','August'));
        r.add(new SelectOption('9','September '));
        r.add(new SelectOption('10','October '));
        r.add(new SelectOption('11','November'));
        r.add(new SelectOption('12','December'));
        return r;
    }

    public Double offset {get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}

    public class RowDTO {
        //Opportunity
        public Id oppId {set;get;}
        public String oppName {set;get;}
        public String oppStatus {set;get;}
        public String oppLender {set;get;}
        public String oppOwnerId {set;get;}
        public String oppOwnerName {set;get;}
        

        //Approval process
        public Id appProcessId {set;get;}
        public Id appApproverId {set;get;}
        public String appApproverName {set;get;}
        public Datetime appSubmissionDate {set;get;}
        public Datetime appSentToLenderDate {set;get;}
        public Datetime appCompletedDate {set;get;}
        public String appStatus {set;get;}
        public Double appTimeCompleted {set;get;}

        //Type of process
        public String typeProcess {set;get;}

        public Long getTimeProcessing() {
            Long r = null;
            if (appSubmissionDate != null && appSentToLenderDate != null) {
                r = (appSentToLenderDate.getTime() - appSubmissionDate.getTime()) / 1000 / 60;
            }
            return r;
        }
    }

    public class SummaryDTO {
        public String typeProcess {set;get;}
        public String processName {set;get;}

        public Integer pending {set;get;}
        public Integer processed {set;get;}     //Sent it to Lender
        public Integer recalled {set;get;}      
        public Integer completed {set;get;}
        public Integer awaiting {set;get;}

        public SummaryDTO(String processName) {
            this.processName = processName;
            this.pending = 0;
            this.processed = 0;
            this.recalled = 0;
            this.completed = 0;
            this.awaiting = 0;

        }

        public SummaryDTO(String typeProcess, String processName) {
            this(processName);
            this.typeProcess = typeProcess;
        }

    }

    public Decimal getPercentage() {
        Decimal r = 0.0;
        if (oppProcesseds > 0) r = (Decimal.valueOf(oppSettleds)/Decimal.valueOf(oppProcesseds))*100.0;
        return r;
    }

    public List<SummaryDTO> getSummaryData() {
        List<SummaryDTO> r = new List<SummaryDTO>();
        if (!summaryMap.isEmpty()) {
            r = summaryMap.values();
        }
        return r;
    }

    public List<RowDTO> getApprovalHistory() {
        List<RowDTO> r = new List<RowDTO>();
        List<RowDTO> tmpR = new List<RowDTO>();
        //Opportunity Ids
        Set<Id> oppIds = new Set<Id>();
        Set<Id> approverIds = new Set<Id>();
        Set<Id> pendingProcessIds = new Set<Id>();

        //System.debug('Getting processInstance for ' + objId);
        List<ProcessInstance> processInstanceList = getProcessInstance();
        for (ProcessInstance processInstance : processInstanceList) {

            //System.debug('processInstance Id >> ' + processInstance.Id);
            
            RowDTO row = new RowDTO();
            row.appProcessId = processInstance.Id;
            row.oppId = processInstance.TargetObjectId;
            row.appApproverId = processInstance.LastActorId;
            row.appSubmissionDate = processInstance.CreatedDate;
            row.appTimeCompleted = processInstance.ElapsedTimeInMinutes;
            if (processInstance.CompletedDate != null) {
                row.appCompletedDate = processInstance.CompletedDate;
            }
            row.appStatus = processInstance.Status;

            if (processInstance.ProcessDefinitionID == PROCESS_PREAPPROVAL_ID) {
                row.typeProcess = PROCESS_TYPE_PREAPPROVAL;
            } else if (processInstance.ProcessDefinitionID == PROCESS_AMENDMENT_ID) {
                row.typeProcess = PROCESS_TYPE_AMENDMENT;
            } else if (processInstance.ProcessDefinitionID == PROCESS_FORMAL_APPROVAL_ID) {
                row.typeProcess = PROCESS_TYPE_FORMAL_APPROVAL;
            }
            System.debug('row.typeProcess >> ' + row.typeProcess + '|' + processInstance.ProcessDefinitionID);
            Boolean isApproverSetted = false;
            for(ProcessInstanceStep stepInstance : processInstance.Steps){
                if ('Removed'.equals(stepInstance.StepStatus)) {
                    row.appApproverId = stepInstance.OriginalActor.Id;   
                    isApproverSetted = true;
                } else if (!'Reassigned'.equals(stepInstance.StepStatus)) {
                    if (STEP_RPEAPPROVAL == stepInstance.StepNodeID ||
                        STEP_AMENDMENT == stepInstance.StepNodeID ||
                        STEP_FORMAL_APPROVAL == stepInstance.StepNodeID) {
                        row.appSentToLenderDate = stepInstance.CreatedDate;
                        if (!isApproverSetted) row.appApproverId = stepInstance.ActorId;
                    }
                }
            }

            if ('Pending'.equals(processInstance.Status)) {
                pendingProcessIds.add(processInstance.Id);
            }


            oppIds.add(processInstance.TargetObjectId);
            approverIds.add(row.appApproverId);
            //System.debug('row >> ' + row);
            tmpR.add(row);

        }

        //Fill opportunity details
        if (!tmpR.isEmpty()) {
            //Pending Process work items
            Map<Id, ProcessInstanceWorkitem> pendingProcessesMap = new Map<Id, ProcessInstanceWorkitem>();
            if (!pendingProcessIds.isEmpty()) {
                List<ProcessInstanceWorkitem> pendingProcessesList = 
                [SELECT ProcessInstanceId, p.ActorId FROM ProcessInstanceWorkitem p 
                 WHERE  ProcessInstanceId = :pendingProcessIds AND p.ProcessInstance.Status = 'Pending'];
                 for (ProcessInstanceWorkitem piw : pendingProcessesList) {
                    pendingProcessesMap.put(piw.ProcessInstanceId, piw);
                    approverIds.add(piw.ActorId);
                 }
            }

            //Opportunities
            Map<Id, Custom_Opportunity__c> opps = new Map<Id, Custom_Opportunity__c>();
            List<Custom_Opportunity__c> oppList = [
                        SELECT Id, Name, Status__c, Loan_Product__r.Lender__c, Owner.Name, Owner.Id 
                        FROM Custom_Opportunity__c WHERE Id in :oppIds];
            for (Custom_Opportunity__c c :oppList) {
                opps.put(c.Id, c);
            }
            //Users
            System.debug('approverIds >> ' + approverIds);
            Map<Id, User> approverMap = new Map<Id, User>();
            List<User> approverList = [SELECT Id, Name, ProfileId FROM User WHERE Id in :approverIds];
            for (User u : approverList) {
                approverMap.put(u.Id, u);
            }
            System.debug('approverMap >> ' + approverMap);
            System.debug('tmpR >> ' + tmpR);
            Set<Id> oppSettledList = new Set<Id>();
            Set<Id> oppProcessedList = new Set<Id>();

            SummaryDTO summDto = new SummaryDTO(PROCESS_TYPE_PREAPPROVAL, 'Pre-Approval');
            summaryMap.put(PROCESS_TYPE_PREAPPROVAL, summDto);
            summDto = new SummaryDTO(PROCESS_TYPE_AMENDMENT, 'Amendment');
            summaryMap.put(PROCESS_TYPE_AMENDMENT, summDto);
            summDto = new SummaryDTO(PROCESS_TYPE_FORMAL_APPROVAL, 'Formal Approval');
            summaryMap.put(PROCESS_TYPE_FORMAL_APPROVAL, summDto);

            for (RowDTO row : tmpR) {
                Custom_Opportunity__c c = opps.get(row.oppId);
                if (c != null) {
                    User approverUser = approverMap.get(row.appApproverId);
                    if ('Pending'.equals(row.appStatus)) {
                        ProcessInstanceWorkitem piw = pendingProcessesMap.get(row.appProcessId);
                        if (piw != null) approverUser = approverMap.get(piw.ActorId);
                    }

                    //System.debug('Comparing profiles: ' + approverUser.ProfileId + '|' + PROFILE_APPROVAL_TEAM_ID);
                    if (approverUser != null && approverUser.Id == o.Id && approverUser.ProfileId == PROFILE_APPROVAL_TEAM_ID) {

                        summDto = summaryMap.get(row.typeProcess);
                        
                        row.oppName = c.Name;
                        row.oppStatus = c.Status__c;
                        row.oppLender = c.Loan_Product__r.Lender__c;
                        row.oppOwnerId = c.Owner.Id;
                        row.oppOwnerName = c.Owner.Name;      
                        if (approverUser != null) row.appApproverName = approverUser.Name;

                        if ('Pending'.equals(row.appStatus)) {
                            if (row.appSentToLenderDate != null) {
                                summDto.processed++;
                                summDto.awaiting++;
                            } else {
                                summDto.pending++;
                            }
                        } else if ('Removed'.equals(row.appStatus)) {
                            if (row.appSentToLenderDate != null) {
                                summDto.processed++;
                            } 
                            summDto.recalled++;
                        } else {
                            summDto.completed++;
                            if (row.appSentToLenderDate != null) {
                                summDto.processed++;
                            }
                        }

                        r.add(row);
                        
                        oppProcessedList.add(c.Id);
                        if ('Settled'.equals(c.Status__c)) {
                            oppSettledList.add(c.Id);
                        }

                    }

                    
                }
            }
            oppSettleds = oppSettledList.size();
            oppProcesseds = oppProcessedList.size();
            /*oppSettleds = 4;
            oppProcesseds = 92;*/
        }
        return r;
    }

    //Get the Process Instance Attached to the Record
    private List<ProcessInstance> getProcessInstance(){

        Set<Id> procDefIds = new Set<Id>();
        procDefIds.add(PROCESS_PREAPPROVAL_ID);
        procDefIds.add(PROCESS_AMENDMENT_ID);
        procDefIds.add(PROCESS_FORMAL_APPROVAL_ID);

        System.debug('StartDate>> ' + StartDate.format() + ' EndDate >> ' + EndDate.format());
        List<ProcessInstance> lstProcessInstance = [
        SELECT Id, ProcessDefinitionID, CreatedDate, Status, LastActorId, TargetObjectId, CompletedDate, ElapsedTimeInMinutes, 
        (Select StepStatus,StepNodeId, OriginalActor.Id, OriginalActor.Name, ActorId, Actor.Name, Comments,
        CreatedDate, CreatedById, CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC)
        FROM ProcessInstance WHERE (CreatedDate >= :StartDate AND CreatedDate < :EndDate) 
        AND (ProcessDefinitionID in :procDefIds)
        ORDER BY CreatedDate desc];

        //System.debug('StartDate>> ' + StartDate.format() + ' EndDate >> ' + EndDate.format());
        //Set<Id> procDefIds = new Set<Id>();
        //procDefIds.add(PROCESS_PREAPPROVAL_ID);
        //procDefIds.add(PROCESS_AMENDMENT_ID);
        //procDefIds.add(PROCESS_FORMAL_APPROVAL_ID);
        ////Pending processes
        //Set<Id> tmpIds = new Set<Id>();
        //for (ProcessInstanceWorkitem p : [SELECT ProcessInstanceId FROM ProcessInstanceWorkitem p WHERE p.ActorId = :o.Id]) {
        //    tmpIds.add(p.ProcessInstanceId);
        //    System.debug('Id >> ' + p.ProcessInstanceId);
        //}
        ////Previous processes
        //for (ProcessInstanceStep p : [SELECT ProcessInstanceId FROM ProcessInstanceStep WHERE ActorId = :o.Id 
        //                              OR (OriginalActorId = :o.Id AND StepStatus = 'Removed')]) {
        //    tmpIds.add(p.ProcessInstanceId);
        //    System.debug('Id >> ' + p.ProcessInstanceId);
        //}
        ////
        //System.debug('Pending processes >> ' + tmpIds.size());

        //List<ProcessInstance> lstProcessInstance = [
        //        SELECT Id, ProcessDefinitionID, CreatedDate, Status, LastActorId, TargetObjectId, CompletedDate, ElapsedTimeInMinutes,
        //        (Select StepStatus,StepNodeId, OriginalActor.Id, OriginalActor.Name, ActorId, Actor.Name, Comments,
        //        CreatedDate, CreatedById, CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC)
        //        FROM ProcessInstance WHERE (CreatedDate >= :StartDate AND CreatedDate < :EndDate) 
        //        AND (Id IN :tmpIds) AND (ProcessDefinitionID in :procDefIds)
        //        ORDER BY CreatedDate DESC];
        //System.debug('ProcessInstance >> ' + lstProcessInstance.size());

        //List<ProcessInstance> tmpHistory = [
        //        SELECT Id, ProcessDefinitionID, CreatedDate, Status, LastActorId, TargetObjectId, CompletedDate, ElapsedTimeInMinutes,
        //        (Select StepStatus,StepNodeId, OriginalActor.Id, OriginalActor.Name, ActorId, Actor.Name, Comments,
        //        CreatedDate, CreatedById, CreatedBy.Name FROM Steps ORDER BY CreatedDate DESC)
        //        FROM ProcessInstance WHERE (CreatedDate >= :StartDate AND CreatedDate < :EndDate) 
        //        AND (Id IN (SELECT ProcessInstanceId FROM ProcessInstanceStep WHERE ActorId = :o.Id))
        //        ORDER BY CreatedDate DESC];

        //if (!tmpHistory.isEmpty()) {
        //    lstProcessInstance.addAll(tmpHistory);
        //}
        //System.debug('tmpHistory >> ' + tmpHistory.size());
        System.debug('Total >> ' + lstProcessInstance.size());
        return lstProcessInstance;
    }

    //get All Process Nodes attached to Process Instance
    public Map<Id,ProcessNode> getProcessNode(ProcessInstance processInstance){
        if(processInstance == null) return null;
        return new Map<Id,ProcessNode>([SELECT Id,Name FROM ProcessNode
                                        WHERE ProcessDefinitionId = :processInstance.ProcessDefinitionId]);

    }

    private void calculateTotals() {
        totals = new SummaryDTO('TOTALS');
        if (!summaryMap.isEmpty()) {
            for (SummaryDTO s : summaryMap.values()) {
                totals.pending += s.pending;
                totals.processed += s.processed;
                totals.recalled += s.recalled;
                totals.completed += s.completed;
                totals.awaiting += s.awaiting;
            }
        }
    }
}