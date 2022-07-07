public class OppApprovalSummaryExtension {
    
    public static final String PREAPPROVALS = 'PREAPPROVALS';
    public static final String AMENDMENTS = 'AMENDMENTS';
    public static final String FORMALAPPROVALS = 'FORMALAPPROVALS';
    
    public static final String SUBMITED = 'SBM';
    public static final String SENT = 'SNT';
    
    //Summary
    private Integer[] totalOwns = new Integer[]{0, 0, 0, 0, 0, 0};
    private Integer[] totalAll = new Integer[]{0, 0, 0, 0, 0, 0};
    
    //List
    private String approvalType = null;
    private Map<String, List<OppApprovalDTO>> rawData;

    //Approval users
    List<Id> approverIds = new List<Id>();
    //Constructor
    public OppApprovalSummaryExtension() {
        approvalType = System.currentPageReference().getParameters().get('approvalType');
        System.debug('constructor... ' + approvalType);
        approverIds = ApprovalTools.getApprovalTemUsersIds(false);
        if (String.isBlank(approvalType)) {
            calculateSummary();
        } else {
            loadOpportunityData();
        }
    }
    
    //Summary
    private void calculateSummary() {
        totalOwns = new Integer[]{0, 0, 0, 0, 0, 0};
        totalAll = new Integer[]{0, 0, 0, 0, 0, 0};
        List<String> oppStatus = new List<String>{
            'Submitted for Pre-Approval','Submitted for Amendment', 'Submitted for Formal Approval',
            'Sent to Lender for Pre-Approval','Sent to Lender for Amendment','Sent to Lender for Formal Approval'
        };
        //Totals
        List<ProcessInstanceWorkitem> otherProcesses = 
            [SELECT p.ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem p 
             WHERE (p.ActorId != :UserInfo.getUserId() AND p.ActorId in :approverIds) AND p.ProcessInstance.Status = 'Pending'];

        List<Id> oppIds = new List<Id>();
        if (otherProcesses != null && !otherProcesses.isEmpty()) {
            for (ProcessInstanceWorkitem p : otherProcesses) {
                oppIds.add(p.ProcessInstance.TargetObjectId);
            }
        }

        List<AggregateResult> result  = [
            SELECT Status__c, COUNT(Name) total FROM Custom_Opportunity__c
            WHERE Status__c IN :oppStatus AND Id IN :oppIds
            GROUP BY Status__c ORDER BY Status__c
        ];
        if (result != null) {
            for (AggregateResult d : result) {
                if ('Submitted for Pre-Approval'.equals(d.get('Status__c'))) {
                    totalAll[0] = (Integer)d.get('total');
                } else if ('Submitted for Amendment'.equals(d.get('Status__c'))) {
                    totalAll[1] = (Integer)d.get('total');
                } else if ('Submitted for Formal Approval'.equals(d.get('Status__c'))) {
                    totalAll[2] = (Integer)d.get('total');
                } else if ('Sent to Lender for Pre-Approval'.equals(d.get('Status__c'))) {
                    totalAll[3] = (Integer)d.get('total');
                } else if ('Sent to Lender for Amendment'.equals(d.get('Status__c'))) {
                    totalAll[4] = (Integer)d.get('total');
                } else if ('Sent to Lender for Formal Approval'.equals(d.get('Status__c'))) {
                    totalAll[5] = (Integer)d.get('total');
                }
            }
        }
        System.debug('results: ' + totalAll);
        //Owns
        //Obtain my processes
        List<ProcessInstanceWorkitem> myProcesses = 
            [SELECT p.ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem p 
             WHERE p.ActorId = :UserInfo.getUserId() AND p.ProcessInstance.Status = 'Pending'];
        
        oppIds = new List<Id>();
        if (myProcesses != null && !myProcesses.isEmpty()) {
            for (ProcessInstanceWorkitem p : myProcesses) {
                oppIds.add(p.ProcessInstance.TargetObjectId);
            }
        }
        
        //Make the query
        if (!oppIds.isEmpty()) {
            result  = [
                SELECT Status__c, count(id) total FROM Custom_Opportunity__c 
                WHERE Id IN :oppIds AND Status__c IN :oppStatus GROUP BY Status__c ORDER BY Status__c
            ];
            if (result != null) {
                for (AggregateResult d : result) {
                    if ('Submitted for Pre-Approval'.equals(d.get('Status__c'))) {
                        totalOwns[0] = (Integer)d.get('total');
                    } else if ('Submitted for Amendment'.equals(d.get('Status__c'))) {
                        totalOwns[1] = (Integer)d.get('total');
                    } else if ('Submitted for Formal Approval'.equals(d.get('Status__c'))) {
                        totalOwns[2] = (Integer)d.get('total');
                    } else if ('Sent to Lender for Pre-Approval'.equals(d.get('Status__c'))) {
                        totalOwns[3] = (Integer)d.get('total');
                    } else if ('Sent to Lender for Amendment'.equals(d.get('Status__c'))) {
                        totalOwns[4] = (Integer)d.get('total');
                    } else if ('Sent to Lender for Formal Approval'.equals(d.get('Status__c'))) {
                        totalOwns[5] = (Integer)d.get('total');
                    }
                }
            }
        }
        System.debug('results: ' + totalOwns);
    }
    
    public Integer getMySubmitedPreApprovalProcessess() {
        return totalOwns[0];
    }
    
    public Integer getMySubmitedAmendmentProcessess() {
        return totalOwns[1];
    }
    
    public Integer getMySubmitedFormalApprovalProcessess() {
        return totalOwns[2];
    }
    
    public Integer getAllSubmitedPreApprovalProcessess() {
        return totalAll[0];
    }
    
    public Integer getAllSubmitedAmendmentProcessess() {
        return totalAll[1];
    }
    
    public Integer getAllSubmitedFormalApprovalProcessess() {
        return totalAll[2];
    }
    
    public Integer getMySentToLenderPreApprovalProcessess() {
        return totalOwns[3];
    }
    
    public Integer getMySentToLenderAmendmentProcessess() {
        return totalOwns[4];
    }
    
    public Integer getMySentToLenderFormalApprovalProcessess() {
        return totalOwns[5];
    }
    
    public Integer getAllSentToLenderPreApprovalProcessess() {
        return totalAll[3];
    }
    
    public Integer getAllSentToLenderAmendmentProcessess() {
        return totalAll[4];
    }
    
    public Integer getAllSentToLenderFormalApprovalProcessess() {
        return totalAll[5];
    }
    
    
    public Integer getMyPreApprovalProcessTotals() {
        return totalOwns[0] + totalOwns[3];
    }

    public Integer getAllPreApprovalProcessTotals() {
        return totalAll[0] + totalAll[3];
    }

    public Integer getMyAmendmentProcessTotals() {
        return totalOwns[1] + totalOwns[4];
    }

    public Integer getAllAmendmentProcessTotals() {
        return totalAll[1] + totalAll[4];
    }

    public Integer getMyFormalApprovalProcessTotals() {
        return totalOwns[2] + totalOwns[5];
    }

    public Integer getAllFormalApprovalProcessTotals() {
        return totalAll[2] + totalAll[5];
    }

    //Approval List
    public String getApprovalTypeLabel() {
        String r = 'Processes';
        if (PREAPPROVALS.equals(approvalType)) {
            r = 'Pre-Approval ' + r;
        }
        if (AMENDMENTS.equals(approvalType)) {
            r = 'Amendment ' + r;
        }
        if (FORMALAPPROVALS.equals(approvalType)) {
            r = 'Formal Approval ' + r;
        }
        return r;
    }
    
    private void loadOpportunityData() {
        List<String> statusList = null;
        List<OppApprovalDTO> submitList = new List<OppApprovalDTO>();
        List<OppApprovalDTO> sentList = new List<OppApprovalDTO>();
        rawData = new Map<String, List<OppApprovalDTO>>();
        
        if (PREAPPROVALS.equals(approvalType)) {
            statusList = new List<String>{'Submitted for Pre-Approval','Sent to Lender for Pre-Approval'};
        } else if (AMENDMENTS.equals(approvalType)) {
            statusList = new List<String>{'Submitted for Amendment','Sent to Lender for Amendment'};
        } else if (FORMALAPPROVALS.equals(approvalType)) {    
            statusList = new List<String>{'Submitted for Formal Approval','Sent to Lender for Formal Approval'};
        }
        
        List<ProcessInstanceWorkitem> tmpPwi = [SELECT p.ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem p 
                                                WHERE (p.ActorId in :approverIds) AND p.ProcessInstance.Status = 'Pending'];

        List<Id> oppIds = new List<Id>();
        for (ProcessInstanceWorkitem pwi : tmpPwi) {
            oppIds.add(pwi.ProcessInstance.TargetObjectId);
        }

        List<Custom_Opportunity__c> tmp = null;
        if (!oppIds.isEmpty()) {
            tmp = [SELECT Id, Name, Owner.Name, Owner.Id, Status__c , Loan_Product__r.Lender__c, Last_Submission_Date__c,
                          Loan_Product__r.Quoting_Source__c 
                   FROM Custom_Opportunity__c 
                   WHERE Status__c IN :statusList AND Id IN :oppIds ORDER BY Last_Submission_Date__c];
        }
                                           //SELECT TargetObjectid FROM ProcessInstance where Status = 'Pending')];

        if (tmp != null) {
            //Preload data
            oppIds = new List<Id>();
            for (Custom_Opportunity__c o : tmp) {
                oppIds.add(o.Id);
            }
            //ProcessInstanceWorkitem
            Map<Id,ProcessInstanceWorkitem> piwiMap = ApprovalTools.getOpportunityProcessInstanceWorkitemIdMap(oppIds);
            //Approval Team Users
            Map<Id, User> approvalUsers = ApprovalTools.getUserApprovalTeamUsers();
            for (Custom_Opportunity__c o : tmp) {
                OppApprovalDTO dto = makeOppApprovalDTO(o, piwiMap.get(o.Id), approvalUsers);
                if (statusList[0].equals(o.Status__c)) {
                    submitList.add(dto);
                } else if (statusList[1].equals(o.Status__c)) {
                    sentList.add(dto);
                }
            }
        }
        System.debug('statusList[0] >> ' + statusList[0]);
        System.debug('statusList[1] >> ' + statusList[1]);
        rawData.put(SUBMITED, submitList);
        rawData.put(SENT, sentList);
    }
    
    private String getLastApplicationNote(Id oppId) {
        String r = null;
        String typeData = 'Notes';
        
        if (PREAPPROVALS.equals(approvalType)) {
            typeData = 'Notes';
        } else if (AMENDMENTS.equals(approvalType)) {
            typeData = 'Notes (Amendment)';
        } else if (FORMALAPPROVALS.equals(approvalType)) {
            typeData = 'Notes (Formal Approval)';
        }
        
        List<Application_Extra_Data__c> a = [SELECT Data__c, LastModifiedDate, Category__c FROM Application_Extra_Data__c WHERE Application__c IN (
                                                SELECT Application__c FROM Custom_Opportunity__c WHERE ID = :oppId
                                             ) AND Type_of_Data__c = :typeData ORDER BY LastModifiedDate DESC LIMIT 1];
        if (a != null && !a.isEmpty()) {
            r = a.get(0).Category__c + ': ' + a.get(0).Data__c;
        }
        return r;
    }
    
    private OppApprovalDTO makeOppApprovalDTO(Custom_Opportunity__c opp, ProcessInstanceWorkitem piwi, 
                                              Map<Id, User> approvalUsers) {
        OppApprovalDTO r = new OppApprovalDTO();
        r.oppId = opp.Id;
        r.name = opp.name;
        r.ownerId = opp.Owner.Id;
        r.ownerName = opp.Owner.Name;
        r.submittedDate = opp.Last_Submission_Date__c;
        //ProcessInstanceWorkitem piwi = ApprovalTools.getOpportunityProcessInstanceWorkitemId(opp.Id);
        if (piwi != null) {
            r.processInstanceWorkitemId = piwi.Id;
            User u = approvalUsers.get(piwi.ActorId);
            if (u == null) {
                u = ApprovalTools.getUser(piwi.ActorId);
            }
            if (u != null) {
                r.approverId = u.Id;
                r.approverName = u.Name;
            }
            System.debug('Current userId: ' + UserInfo.getName() + '|' + UserInfo.getUserId());
        }
        r.note = getLastApplicationNote(opp.Id);

        if (r.submittedDate == null) {
            List<ProcessInstanceStep> steps = ApprovalTools.getMostRecentProcessInstanceSteps(opp.Id);
            for (ProcessInstanceStep s : steps) {
                if ('Started'.equals(s.StepStatus)) {
                    r.submittedDate = s.CreatedDate;
                    break;
                }
            }
        }

        //Lender
        //List<Product__c> prd = [SELECT Lender__c FROM Product__c 
        //                        WHERE Opportunity_Name__c = :opp.Id 
        //                        AND RecordType.Name = 'Finance'];
        //if (!prd.isEmpty()) {
        if (opp.Loan_Product__c != null) {
            //Product__c p = opp.Loan_Product__c;
            r.productLender = opp.Loan_Product__r.Lender__c;

            //GetTemplate
            if ('ANZ Consumer'.equals(opp.Loan_Product__r.Quoting_Source__c) ||
                'ANZ Commercial'.equals(opp.Loan_Product__r.Quoting_Source__c) ||
                'ANZ Others'.equals(opp.Loan_Product__r.Quoting_Source__c)) {
                r.approvalTemplate = 'ApprovalANZSummaryTemplate';
            } else {
                System.debug('Using defalult approval template');
                r.approvalTemplate = 'ApprovalANZSummaryTemplate';
            }
        }
        return r;
    }
    
    public List<OppApprovalDTO> getMyOpportunitiesSubmitedList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData.get(SUBMITED)) {
            if (dto.approverId == UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        r.sort();
        return r;
    }
    
    public List<OppApprovalDTO> getOtherOpportunitiesSubmitedList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData.get(SUBMITED)) {
            if (dto.approverId != UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        r.sort();
        return r;
    }
    
    public List<OppApprovalDTO> getMyOpportunitiesSentList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData.get(SENT)) {
            if (dto.approverId == UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        r.sort();
        return r;
    }
    
    public List<OppApprovalDTO> getOtherOpportunitiesSentList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData.get(SENT)) {
            if (dto.approverId != UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        r.sort();
        return r;
    }
    
    //Links
    public PageReference consultantDetails() {
        return null;
    }
    
}