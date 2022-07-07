public with sharing class OppApprovalMonitoringExtension {

    private static final String PROCESS_NODE_PREAPPROVAL_CHECK_DOCS = 'Pre_Approval';
    private static final String PROCESS_NODE_AMENDMENT_CHECK_DOCS = 'Checking_Documentation_Amendment';
    private static final String PROCESS_NODE_FORMAL_APPROVAL_CHECK_DOCS = 'Formal_Approval';

    private static final String PROCESS_DEF_PREAPPROVAL = 'Pre Approval';
    private static final String PROCESS_DEF_AMENDMENT = 'Amendment';
    private static final String PROCESS_DEF_FORMAL_APPROVAL = 'Formal Approval';


    private static final String PROCESS_TYPE_PREAPPROVAL = 'P';
    private static final String PROCESS_TYPE_AMENDMENT = 'A';
    private static final String PROCESS_TYPE_FORMAL_APPROVAL = 'F';

    public List<RowDTO> data {set;get;}
    private Map<Id, SummaryDTO> summaryMap;
    public SummaryDTO totals {set;get;}
    public Integer oppSettleds {set;get;}
    public Integer oppProcesseds {set;get;}

    //Aproval Steps description
  private Id STEP_RPEAPPROVAL = null;
    private Id STEP_AMENDMENT = null;
    private Id STEP_FORMAL_APPROVAL = null;

    //Aproval Process definition Ids
    private Id PROCESS_PREAPPROVAL_ID = null;
    private Id PROCESS_AMENDMENT_ID = null;
    private Id PROCESS_FORMAL_APPROVAL_ID = null;

    private Id PROFILE_APPROVAL_TEAM_ID = null;

    public Date StartDate {set;get;}
    public Date EndDate {set;get;}

    public Integer month {set;get;}
    public Integer year {set;get;}

    //Pagination
    public Integer currentPage {set;get;}
    public Integer totalPages {set;get;}
    private Integer offsetRecords = 500;

    public OppApprovalMonitoringExtension() {
        String paramTmp = System.currentPageReference().getParameters().get('RECORDS');
        if (String.isNotBlank(paramTmp) && paramTmp.isNumeric()) {
            offsetRecords = Integer.valueOf(paramTmp);
        }
        //Init dates
        Date today = Date.today();
        year = today.year();
        month = today.month();
        loadData();
        search();        
    }

    public List<SelectOption> getYearOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer currentYear = Date.today().year();
        year = currentYear;
        for (; currentYear >= 2016; currentYear--) {
            r.add(new SelectOption(String.valueOf(currentYear), String.valueOf(currentYear)));
        }
        return r;
    }

    public List<SelectOption> getMonthOptions() {
        List<SelectOption> r = new List<SelectOption>();
        month = Date.today().month();
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
    
    /**
    * Get Approval History List
    **/
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
            // System.debug('row.typeProcess >> ' + row.typeProcess + '|' + processInstance.ProcessDefinitionID);
            //System.debug('Iterating over processInstance.Steps...');
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
                        SELECT Id, Name, Status__c, Loan_Product__r.Lender__c, Owner.Name, Owner.Id, CreatedBy.Name, OwnerType__c 
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
            for (RowDTO row : tmpR) {
                Custom_Opportunity__c c = opps.get(row.oppId);
                if (c != null) {
                    User approverUser = approverMap.get(row.appApproverId);
                    if ('Pending'.equals(row.appStatus)) {
                        ProcessInstanceWorkitem piw = pendingProcessesMap.get(row.appProcessId);
                        if (piw != null) approverUser = approverMap.get(piw.ActorId);
                    }

                    //System.debug('Comparing profiles: ' + approverUser.ProfileId + '|' + PROFILE_APPROVAL_TEAM_ID);
                    if (approverUser != null && approverUser.ProfileId == PROFILE_APPROVAL_TEAM_ID) {

                        SummaryDTO summDto = summaryMap.get(approverUser.Id);
                        if (summDto == null) {
                            summDto = new SummaryDTO(approverUser.Id, approverUser.Name);
                            summaryMap.put(approverUser.Id, summDto);
                        }

                        row.oppName = c.Name;
                        row.oppStatus = c.Status__c;
                        row.oppLender = c.Loan_Product__r.Lender__c;
                        row.oppOwnerId = c.Owner.Id;
                        row.oppOwnerName = c.Owner.Name;
                        if ('Queue'.equals(c.OwnerType__c)) {
                            row.oppOwnerName = c.CreatedBy.Name;
                        }
                        if (approverUser != null) row.appApproverName = approverUser.Name;


                        //Calculate
                        summDto.approverName = row.appApproverName;
                        if (PROCESS_TYPE_PREAPPROVAL.equals(row.typeProcess)) {
                            if ('Pending'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed1++;
                                    summDto.awaiting1++;
                                } else {
                                    summDto.pending1++;
                                }
                            } else if ('Removed'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed1++;
                                } 
                                summDto.recalled1++;
                            } else {
                                summDto.completed1++;
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed1++;
                                }
                            }
                        } else if (PROCESS_TYPE_AMENDMENT.equals(row.typeProcess)) {
                            if ('Pending'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed2++;
                                    summDto.awaiting2++;
                                } else {
                                    summDto.pending2++;
                                }
                            } else if ('Removed'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed2++;
                                } 
                                summDto.recalled2++;
                            } else {
                                summDto.completed2++;
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed2++;
                                }
                            }
                        } if (PROCESS_TYPE_FORMAL_APPROVAL.equals(row.typeProcess)) {
                            if ('Pending'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed3++;
                                    summDto.awaiting3++;
                                } else {
                                    summDto.pending3++;
                                }
                            } else if ('Removed'.equals(row.appStatus)) {
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed3++;
                                } 
                                summDto.recalled3++;
                            } else {
                                summDto.completed3++;
                                if (row.appSentToLenderDate != null) {
                                    summDto.processed3++;
                                }
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
        }
        System.debug('Row total >> ' + r.size());
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
                totals.pending1 += s.pending1;
                totals.processed1 += s.processed1;
                totals.recalled1 += s.recalled1;
                totals.completed1 += s.completed1;
                totals.awaiting1 += s.awaiting1;

                totals.pending2 += s.pending2;
                totals.processed2 += s.processed2;
                totals.recalled2 += s.recalled2;
                totals.completed2 += s.completed2;
                totals.awaiting2 += s.awaiting2;

                totals.pending3 += s.pending3;
                totals.processed3 += s.processed3;
                totals.recalled3 += s.recalled3;
                totals.completed3 += s.completed3;
                totals.awaiting3 += s.awaiting3;

            }
        }
    }

    public PageReference search() {
        StartDate = Date.newInstance(year, month, 1);
        EndDate = StartDate.addMonths(1);
        summaryMap = new Map<Id, SummaryDTO>();
        oppSettleds = 0;
        oppProcesseds = 0;
        data = getApprovalHistory();
        calculateTotals();

        //Pagination
        currentPage = 1;
        totalPages = 1;

        //data = fillData();

        if (data.size() > 0) {
            Decimal tmpPages = Decimal.valueOf(data.size()) / Decimal.valueOf(offsetRecords);
            if (tmpPages > 0) {
                totalPages = tmpPages.round(System.RoundingMode.CEILING).intValue();
            }
            System.debug(data.size() + '|' + tmpPages + '|' + totalPages + '|' + offsetRecords);
        }

        return null;
    }
    
    public List<SummaryDTO> getSummaryData() {
        List<SummaryDTO> r = new List<SummaryDTO>();
        if (!summaryMap.isEmpty()) {
            r = summaryMap.values();
        }
        return r;
    }

    public Decimal getPercentage() {
        Decimal r = 0.0;
        if (oppProcesseds > 0) r = (Decimal.valueOf(oppSettleds)/Decimal.valueOf(oppProcesseds))*100.0;
        return r;
    }

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
        public Id approverId {set;get;}
        public String approverName {set;get;}

        public Integer pending1 {set;get;}
        public Integer processed1 {set;get;}     //Sent it to Lender
        public Integer recalled1 {set;get;}      
        public Integer completed1 {set;get;}
        public Integer awaiting1 {set;get;}

        public Integer pending2 {set;get;}
        public Integer processed2 {set;get;}     //Sent it to Lender
        public Integer recalled2 {set;get;}      
        public Integer completed2 {set;get;}
        public Integer awaiting2 {set;get;}

        public Integer pending3 {set;get;}
        public Integer processed3 {set;get;}     //Sent it to Lender
        public Integer recalled3 {set;get;}      
        public Integer completed3 {set;get;}
        public Integer awaiting3 {set;get;}

        public SummaryDTO(String approverName) {
            this.approverName = approverName;
            this.pending1 = 0;
            this.processed1 = 0;
            this.recalled1 = 0;
            this.completed1 = 0;
            this.awaiting1 = 0;

            this.pending2 = 0;
            this.processed2 = 0;
            this.recalled2 = 0;
            this.completed2 = 0;
            this.awaiting2 = 0;

            this.pending3 = 0;
            this.processed3 = 0;
            this.recalled3 = 0;
            this.completed3 = 0;
            this.awaiting3 = 0;
        }

        public SummaryDTO(Id approverId, String approverName) {
            this(approverName);
            this.approverId = approverId;
        }

        public Integer getPending() {
            return pending1 + pending2 + pending3;
        }

        public Integer getProcessed() {
            return processed1 + processed2 + processed3;
        }

        public Integer getRecalled() {
            return recalled1 + recalled2 + recalled3;
        }

        public Integer getCompleted() {
            return completed1 + completed2 + completed3;
        }

        public Integer getAwaiting() {
            return awaiting1 + awaiting2 + awaiting3;
        }

    }

    public Double offset {
        get{
            TimeZone tz = UserInfo.getTimeZone();
            //Milliseconds to Day
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }

    public void goNext() {
        if (currentPage < totalPages) {
            currentPage++;
        }
    }

    public void goBack() {
        if (currentPage > 1) {
            currentPage--;
        }   
    }

    public List<RowDTO> getDataPage() {
        List<RowDTO> r = new List<RowDTO>();

        Integer idxA = offsetRecords * (currentPage - 1);
        
        for (Integer i = 0; i < offsetRecords ; i++) {
            if ((idxA+i) < data.size()) {
                r.add(data.get(idxA+i));
            }
        }

        return r;
    }

    //private List<RowDTO> fillData() {
    //    List<RowDTO> r = new List<RowDTO>();
    //    for (Integer i = 1; i <= 100;i++) {
    //        RowDTO a = new RowDTO();
    //        a.oppName = 'Name ' + i;
    //        a.oppStatus = 'Any Status';
    //        a.oppLender = 'Any Lender';
    //        a.oppOwnerName = 'Any Owner';
    //        a.appApproverName = 'Any Approver';
    //        a.appSubmissionDate = Date.today();
    //        a.appSentToLenderDate = Date.today().addDays(i);
    //        a.appCompletedDate = Date.today().addDays(i*2);
    //        a.appStatus = 'Any Status';
    //        a.appTimeCompleted = Decimal.valueOf(i*10);
    //        r.add(a);
    //    }
    //    return r;   
    //}

}