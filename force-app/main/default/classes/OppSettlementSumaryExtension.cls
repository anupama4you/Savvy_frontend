public class OppSettlementSumaryExtension {
    
    public static final String CONSULTANT = 'CONSULTANT';
    public static final String CLIENT = 'CLIENT';
    public static final String LENDER = 'LENDER';
    
    public static final String SUBMITED = 'SBM';
    public static final String SENT = 'SNT';
    
    //Summary
    public Integer[] totalOwns = new Integer[]{0, 0, 0, 0, 0, 0};
    public Integer[] totalAll = new Integer[]{0, 0, 0, 0, 0, 0};
    
    //List
    public String approvalType = null;
    public Map<String, List<OppApprovalDTO>> rawData;
    
    public String idUser = UserInfo.getUserId();
    public boolean showSummary = false;

    //Approval users
    List<Id> approverIds = new List<Id>();
    List<Id> showSettlement = new List<Id>();
    //Constructor
    public OppSettlementSumaryExtension() {
        approvalType = System.currentPageReference().getParameters().get('approvalType');
        System.debug('constructor... ' + approvalType);
        approverIds = ApprovalTools.getSettlementTeamUsersIds(false);
        ShowSettlement = ApprovalTools.getShowSettlement();
        verifyShow();
        List<queueSobject> queue = [select queue.id from queueSobject where queue.developerName = 'Settlement_Officers'];
        if(queue !=null && !queue.isEmpty()){
            for(queueSobject q : queue){
                approverIds.add(q.QueueId);
            }
        }
        if (String.isBlank(approvalType)) {
            calculateSummary();
        } else {
            loadOpportunityData();
        }
    }
    
    //Summary
    public void calculateSummary() {
        totalOwns = new Integer[]{0, 0, 0, 0, 0, 0};
        totalAll = new Integer[]{0, 0, 0, 0, 0, 0};
        List<String> oppStatus = new List<String>{
            'Internal Settlement','Documents Sent','Documents Received','Sent to Lender for Settlement','Awaiting Further Information','Rejected By Lender'
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
                if ('Internal Settlement'.equals(d.get('Status__c'))) {
                    totalAll[0] = (Integer)d.get('total');
                } else if ('Documents Sent'.equals(d.get('Status__c'))) {
                    totalAll[1] = (Integer)d.get('total');
                } else if ('Documents Received'.equals(d.get('Status__c'))) {
                    totalAll[2] = (Integer)d.get('total');
                } else if ('Sent to Lender for Settlement'.equals(d.get('Status__c'))) {
                    totalAll[3] = (Integer)d.get('total');
                } else if ('Awaiting Further Information'.equals(d.get('Status__c'))) {
                    totalAll[4] = (Integer)d.get('total');
                } else if ('Rejected By Lender'.equals(d.get('Status__c'))) {
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
                    if ('Internal Settlement'.equals(d.get('Status__c'))) {
                        totalOwns[0] = (Integer)d.get('total');
                    } else if ('Documents Sent'.equals(d.get('Status__c'))) {
                        totalOwns[1] = (Integer)d.get('total');
                    } else if ('Documents Received'.equals(d.get('Status__c'))) {
                        totalOwns[2] = (Integer)d.get('total');
                    } else if ('Sent to Lender for Settlement'.equals(d.get('Status__c'))) {
                        totalOwns[3] = (Integer)d.get('total');
                    } else if ('Awaiting Further Information'.equals(d.get('Status__c'))) {
                        totalOwns[4] = (Integer)d.get('total');
                    } else if ('Rejected By Lender'.equals(d.get('Status__c'))) {
                        totalOwns[5] = (Integer)d.get('total');
                    }
                }
            }
        }
        System.debug('results: ' + totalOwns);
    }
    
    public void verifyShow(){
        for(Id i : approverIds){
            if(i==idUser){
                showSummary=true;
                break;
            }
        }
        for(Id i : showSettlement){
            if(i==idUser){
                showSummary=true;
                break;
            }
        }
    }
    
    public boolean getVerifyShow(){
        return showSummary;
    }
    
    public Integer getMyInternalSettlement() {
        return totalOwns[0];
    }
    
    
    public Integer getMyDocumentsSend() {
        return totalOwns[1];
    }
    
    public Integer getMyDocumentsReceived() {
        return totalOwns[2];
    }
    
    public Integer getAllInternalSettlement() {
        totalAll[0]=totalAll[0]+totalOwns[0];
        return totalAll[0];
    }
    
    public Integer getAllDocumentsSend() {
        totalAll[1]=totalAll[1]+totalOwns[1];
        return totalAll[1];
    }
    
    public Integer getAllDocumentsReceived() {
        totalAll[2]=totalAll[2]+totalOwns[2];
        return totalAll[2];
    }
    
    public Integer getMySenttoLenderforSettlement() {
        return totalOwns[3];
    }
    
    public Integer getMyAwaitingFurtherInformation() {
        return totalOwns[4];
    }
    
    public Integer getMyRejectedByLender() {
        return totalOwns[5];
    }
    
    public Integer getAllSenttoLenderforSettlement() {
        totalAll[3]=totalAll[3]+totalOwns[3];
        return totalAll[3];
    }
    
    public Integer getAllAwaitingFurtherInformation() {
        totalAll[4]=totalAll[4]+totalOwns[4];
        return totalAll[4];
    }
    
    public Integer getAllRejectedByLender() {
        totalAll[5]=totalAll[5]+totalOwns[5];
        return totalAll[5];
    }
    
    
    public Integer getMyConsultant() {
        return totalOwns[0] + totalOwns[1];
    }

    public Integer getAllConsultant() {
        return totalAll[0] + totalAll[1];
    }

    public Integer getMyClient() {
        return totalOwns[2] + totalOwns[4];
    }

    public Integer getAllClient() {
        return totalAll[2] + totalAll[4];
    }

    public Integer getMyLender() {
        return totalOwns[3] + totalOwns[5];
    }

    public Integer getAllLender() {
        return totalAll[3] + totalAll[5];
    }

    //Approval List
    public String getApprovalTypeLabel() {
        String r = 'Settlement Officer Approval';
        if (CONSULTANT.equals(approvalType)) {
            r =  r + ' Consultant List';
        }
        if (CLIENT.equals(approvalType)) {
            r =  r + ' Client List';
        }
        if (LENDER.equals(approvalType)) {
            r =  r + ' Lender List';
        }
        return r;
    }
    
    public void loadOpportunityData() {
        List<String> statusList = null;
        List<OppApprovalDTO> submitList = new List<OppApprovalDTO>();
        List<OppApprovalDTO> sentList = new List<OppApprovalDTO>();
        rawData = new Map<String, List<OppApprovalDTO>>();
        
        if (CONSULTANT.equals(approvalType)) {
            statusList = new List<String>{'Internal Settlement','Documents Sent'};
        } else if (CLIENT.equals(approvalType)) {
            statusList = new List<String>{'Documents Received','Awaiting Further Information'};
        } else if (LENDER.equals(approvalType)) {    
            statusList = new List<String>{'Sent to Lender for Settlement','Rejected By Lender'};
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
            Map<Id, User> settlementUsers = ApprovalTools.getUserSettlementTeamUsers();
            for (Custom_Opportunity__c o : tmp) {
                OppApprovalDTO dto = makeOppApprovalDTO(o, piwiMap.get(o.Id), settlementUsers);
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
    
    
    public OppApprovalDTO makeOppApprovalDTO(Custom_Opportunity__c opp, ProcessInstanceWorkitem piwi, 
                                              Map<Id, User> settlementUsers) {
        OppApprovalDTO r = new OppApprovalDTO();
        r.oppId = opp.Id;
        r.name = opp.name;
        r.ownerId = opp.Owner.Id;
        r.ownerName = opp.Owner.Name;
        r.submittedDate = opp.Last_Submission_Date__c;
        //ProcessInstanceWorkitem piwi = ApprovalTools.getOpportunityProcessInstanceWorkitemId(opp.Id);
        if (piwi != null) {
            r.processInstanceWorkitemId = piwi.Id;
            User u = settlementUsers.get(piwi.ActorId);
            if (u == null) {
                u = ApprovalTools.getUser(piwi.ActorId);
            }
            if (u != null) {
                r.approverId = u.Id;
                r.approverName = u.Name;
            }
            System.debug('Current userId: ' + UserInfo.getName() + '|' + UserInfo.getUserId());
        }
       

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
    
}