public class OppApprovalSettlementSummaryExtension {

    private String SETTLEMENT_PROCESS_DEFINITION = 'Settlement Officer Approval';
    private Id SETTLEMENT_PROCESS_DEFINITION_ID = null;

	private List<String> oppStatus = new List<String>{
            'Documents In', 'Documents Sent', 'Awaiting Further Information', 'Sent to Lender'
        };

    public Map<String, RowDTO> data {set;get;}

    public Integer statusIdx = -1;
    public String typeData = null;

    List<OppApprovalDTO> rawData = null;

	public OppApprovalSettlementSummaryExtension() {
        statusIdx = -1;
        loadSettings();
		String idx = System.currentPageReference().getParameters().get('IDX');
        typeData = System.currentPageReference().getParameters().get('T');
		if (String.isBlank(idx)) {
			calculateSummary();	
		} else {
			if (idx.isNumeric()) {
				try {
					statusIdx = Integer.valueOf(idx);
                    if (String.isBlank(typeData)) {
                        typeData = 'OWN';
                    }
					loadOpportunityData();
				} catch (Exception e) {
					System.debug('Error: ' + e.getMessage());
				}
			}
		}
	}

    private void loadSettings() {
        SETTLEMENT_PROCESS_DEFINITION_ID = ApprovalTools.getProcessDefinitionIdByName(SETTLEMENT_PROCESS_DEFINITION);
        System.debug('Process definition >> ' + SETTLEMENT_PROCESS_DEFINITION_ID);
    }

    public class RowDTO {
        public Integer own {set;get;}
        public Integer others {set;get;}
        
        public RowDTO () {
            this.own = 0;
            this.others = 0;
        }

        public Integer getTotal() {
            Integer r = 0;
            if (own != null) r += own;
            if (others != null) r += others;
            return r;
        }

        public Double getPercentage() {
            Double r = 0;
            if (getTotal() > 0) {
                r = Double.valueOf(own) / Double.valueOf(getTotal()) * 100;
            }
            return r;
        }

    }

	//Summary
    private void calculateSummary() {

        data = new Map<String, RowDTO>();
        for (String s : oppStatus) {
            data.put(s, new RowDTO());    
        }
        
        //Select all pending process instance 
        List<ProcessInstance> piList = [
            SELECT Id, TargetObjectid FROM ProcessInstance 
            WHERE ProcessDefinitionID = :SETTLEMENT_PROCESS_DEFINITION_ID 
            AND  Status = 'Pending'];


        List<Id> oppIds = new List<Id>();
        List<Id> piIds = new List<Id>();
        for (ProcessInstance p : piList) {
            oppIds.add(p.TargetObjectid);
            piIds.add(p.Id);
        }

        //Load Opportunities
        Map<Id, Custom_Opportunity__c> oppMap = null;
        for (Custom_Opportunity__c c : [SELECT Id, Status__c FROM Custom_Opportunity__c WHERE Id in :oppIds]) {
            oppMap.put(c.Id, c);
        }

        List<ProcessInstanceWorkitem> pwiList = 
            [SELECT ProcessInstance.Id, ActorId FROM ProcessInstanceWorkitem p 
             WHERE p.ProcessInstance.Id in :piIds];
        Map<Id, Id> piActorMap = new Map<Id, Id>();
        for (ProcessInstanceWorkitem p : pwiList) {
            piActorMap.put(p.ProcessInstance.Id, p.ActorId);
        }

        //Load data
        for (ProcessInstance p : piList) {
            Custom_Opportunity__c c = oppMap.get(p.TargetObjectid);
            RowDTO r = data.get(c.Status__c);
            if (r != null) {
                Id actorId = piActorMap.get(p.Id);
                if (actorId == UserInfo.getUserId()) {
                    r.own++;
                } else {
                    r.others++;
                }   
            }
        }

        //Consolidate
        RowDTO total = new RowDTO();
        for (RowDTO r : data.values()) {
            total.own += r.own;
            total.others += r.others;
        }
        data.put('TOTAL', total);
        System.debug('results: ');
    }

    public RowDTO getDataStatus1() {
        return data.get(oppStatus[0]);
    }

    public RowDTO getDataStatus2() {
        return data.get(oppStatus[1]);
    }

    public RowDTO getDataStatus3() {
        return data.get(oppStatus[2]);
    }

    public RowDTO getDataStatus4() {
        return data.get(oppStatus[3]);
    }

    public RowDTO getDataTotal() {
        return data.get('TOTAL');
    }

    public String getStatus1() {
        return oppStatus[0];
    }

    public String getStatus2() {
        return oppStatus[1];
    }

    public String getStatus3() {
        return oppStatus[2];
    }

    public String getStatus4() {
        return oppStatus[3];
    }
 	
    
    //List
    private void loadOpportunityData() {
    	rawData = new List<OppApprovalDTO>();
    	List<Custom_Opportunity__c> tmp = [SELECT Id, Name, Owner.Name, Owner.Id FROM Custom_Opportunity__c 
                                           WHERE Status__c = :oppStatus[statusIdx] AND Id IN (
                                            SELECT TargetObjectid FROM ProcessInstance where Status = 'Pending')];
        if (tmp != null) {
            for (Custom_Opportunity__c o : tmp) {
                rawData.add(makeOppApprovalDTO(o));
            }
        }
    }

    private OppApprovalDTO makeOppApprovalDTO(Custom_Opportunity__c opp) {
        OppApprovalDTO r = new OppApprovalDTO();
        r.oppId = opp.Id;
        r.name = opp.name;
        r.ownerId = opp.Owner.Id;
        r.ownerName = opp.Owner.Name;
        
        ProcessInstanceWorkitem piwi = ApprovalTools.getOpportunityProcessInstanceWorkitemId(opp.Id);
        if (piwi != null) {
        	r.processInstanceWorkitemId = piwi.Id;
            User u = ApprovalTools.getUser(piwi.ActorId);
            if (u != null) {
            	r.approverId = u.Id;
                r.approverName = u.Name;
            }
            System.debug('Current userId: ' + UserInfo.getName() + '|' + UserInfo.getUserId());
        }
        //r.note = getLastApplicationNote(opp.Id);

        List<ProcessInstanceStep> steps = ApprovalTools.getMostRecentProcessInstanceSteps(opp.Id);
        for (ProcessInstanceStep s : steps) {
            if ('Started'.equals(s.StepStatus)) {
                r.submittedDate = s.CreatedDate;
                break;
            }
        }

        //Lender
        List<Product__c> prd = [SELECT Lender__c FROM Product__c 
                                WHERE Opportunity_Name__c = :opp.Id 
                                AND RecordType.Name = 'Finance'];
        if (!prd.isEmpty()) {
            r.productLender = prd[0].Lender__c;
        }
        return r;
    }

    public String getActiveStatus() {
    	String r = 'Unknown';
    	if (isStatusSelected()) {
    		r = oppStatus[statusIdx];
    	}
    	return r;
    }

    private Boolean isStatusSelected() {
    	Boolean r = false;
    	if (statusIdx != null && statusIdx >= 0 && statusIdx < oppStatus.size()) {
    		r = true;
    	}
    	return r;
    }

    public List<OppApprovalDTO> getMyApplicationsList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData) {
            if (dto.approverId != UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        return r;
    }

    public List<OppApprovalDTO> getOtherApplicationsList() {
        List<OppApprovalDTO> r = new List<OppApprovalDTO>();
        for (OppApprovalDTO dto : rawData) {
            if (dto.approverId != UserInfo.getUserId()) {
                r.add(dto);
            }
        }
        return r;
    }

}