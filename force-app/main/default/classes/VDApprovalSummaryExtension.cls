public class VDApprovalSummaryExtension {

	public static final String VD_SALES = 'Vehicles Direct - Sales';
	public static final String VD_SETTLEMENTS = 'Vehicles Direct - Settlements';

	public static final String[] VD_SALES_STATUS = new String[] {'New Lead','Attempted Contact','Searching for Vehicle and Negotiating deal'};
	public static final String[] VD_SETTLEMENTS_STATUS = new String[] {'VD File In','Invoice Request Sent','Invoice Request Received'};

	public String userProfile {set;get;}
	public Integer groupType {set;get;}
	private List<StatusDTO> statusList;

	//Opportunities List
	public List<RowDTO> dataList {get;set;}
	public String activeVDStatus {set;get;}

	//Constructor
    public VDApprovalSummaryExtension() {

    	//Current user profile
    	Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
		userProfile = p.name;
		System.debug('Current userProfile >> ' + userProfile);

		if (!isVDSales() && !isVDSettlements()) {
			userProfile = VD_SALES;
			System.debug('Using profile >> ' + userProfile);
		}

		String paramIdx = System.currentPageReference().getParameters().get('idx');
		groupType = 0;
		if (String.isBlank(paramIdx)) {
			calculateSummary();
		} else {
			//Group
			if ('1'.equals(System.currentPageReference().getParameters().get('g'))) {
				groupType = 1;
			}
			
			Integer idx = Integer.valueOf(paramIdx);
			String[] tmp = null;
			if (isVDSales()) {
				tmp = VD_SALES_STATUS;
			} else if (isVDSettlements()) {
				tmp = VD_SETTLEMENTS_STATUS;
			}
			if (tmp != null && idx > 0 && idx <= tmp.size()) { 
				activeVDStatus = tmp[idx-1];
			}
			loadOpportunityData();
		}

    }

    private void calculateSummary() {
    	statusList = new List<StatusDTO>();
    	Map<String, StatusDTO> mList = new Map<String, StatusDTO>();
    	String[] tmpList = null;
    	if (isVDSales()) {
    		tmpList = VD_SALES_STATUS;
		} else if (isVDSettlements()) { 
			tmpList = VD_SETTLEMENTS_STATUS;
		}	

		for (String s: tmpList) {
			mList.put(s, new StatusDTO(s, 0, 0));
		}

		Map<String, Integer> myProcess = new Map<String, Integer>();
		Map<String, Integer> allProcess = new Map<String, Integer>();

		//Own
		AggregateResult[] result = [
			Select VD_Worksheet__r.Approval_Status__c Status, count(Id) countId from Custom_Opportunity__c 
			Where VD_Worksheet__r.Approval_Status__c in :tmpList And VD_Owner__c = :UserInfo.getUserId()
			And VD_Is_Old_Process__c = false
			Group By VD_Worksheet__r.Approval_Status__c];

		for (AggregateResult s : result) {
			StatusDTO dto = mList.get((String)s.get('Status'));
			if (dto != null) {
				dto.own = (Integer)s.get('countId');
			}
		}

		//Others
		result = [
			Select VD_Worksheet__r.Approval_Status__c Status, count(Id) countId from Custom_Opportunity__c 
			Where VD_Worksheet__r.Approval_Status__c in :tmpList And VD_Owner__c != :UserInfo.getUserId()
			And VD_Is_Old_Process__c = false
			Group By VD_Worksheet__r.Approval_Status__c];

		for (AggregateResult s : result) {
			StatusDTO dto = mList.get((String)s.get('Status'));
			if (dto != null) {
				dto.others = (Integer)s.get('countId');
			}
		}

		for (String s: tmpList) {
			statusList.add(mList.get(s));
		}

		
    }

    private StatusDTO getStatusDTO(Integer pos) {
    	return statusList.get(pos);
    }

    public StatusDTO getStatusDTO1() {
    	return getStatusDTO(0);
    }

    public StatusDTO getStatusDTO2() {
    	return getStatusDTO(1);
    }

    public StatusDTO getStatusDTO3() {
    	return getStatusDTO(2);
    }

    public class StatusDTO {
    	public String status {get;set;}
    	public Integer own {get;set;}
    	public Integer others {get;set;}

    	public StatusDTO (String s, Integer own, Integer others) {
    		this.status = s;
    		this.own = own;
    		this.others = others;
    	}

    	public Integer getTotal() {
    		Integer r = 0;
    		if (own !=null) r += own;
    		if (others !=null) r += others;
    		return r;
    	}

    }

    public Boolean isVDSales() {
    	Boolean r = false;
    	if (VD_SALES.equals(userProfile)) {
    		r = true;
    	}
    	return r;
    }

    public Boolean isVDSettlements() {
    	Boolean r = false;
    	if (VD_SETTLEMENTS.equals(userProfile)) {
    		r = true;
    	}
    	return r;
    }

    public void loadOpportunityData() {
    	dataList = new List<RowDTO>();
    	Id userId = UserInfo.getUserId();
    	System.debug(userId + '|' + activeVDStatus + '|' + groupType);
    	List<Custom_Opportunity__c> tmpList = null;
    	if (groupType == 0) {
	    	tmpList = [Select Id, Name, Owner.Name, Owner.Id, Status__c, VD_Status_Process__c, VD_Notes__c, VD_Owner__r.Name from Custom_Opportunity__c 
						Where VD_Status_Process__c = :activeVDStatus And VD_Owner__c = :userId];
		} else if (groupType == 1) {
			tmpList = [Select Id, Name, Owner.Name, Owner.Id, Status__c, VD_Status_Process__c, VD_Notes__c, VD_Owner__r.Name from Custom_Opportunity__c 
						Where VD_Status_Process__c = :activeVDStatus And VD_Owner__c != :userId];
		}
		if (!tmpList.isEmpty()) {
			List<Id> oppIds = new List<Id>();
			for (Custom_Opportunity__c o : tmpList) {
				oppIds.add(o.Id);
			}
			//ProcessInstanceWorkitem
	        Map<Id,ProcessInstanceWorkitem> piwiMap = ApprovalTools.getOpportunityProcessInstanceWorkitemIdMap(oppIds);
	        for (Custom_Opportunity__c o : tmpList) {
	        	dataList.add(new RowDTO(o, piwiMap.get(o.Id)));
	        }
	    }
		

    }

    public Boolean getIsVDManager() {
        Boolean r = false;
        List<GroupMember> tmp = [
            SELECT Id, group.id, group.name, group.type, UserOrGroupId FROM GroupMember
            WHERE group.name = 'Vehicles Direct Manager' AND UserOrGroupId =: UserInfo.getUserId()
        ];
        if (!tmp.isEmpty()) {
            r = true;
        }
        return r;
    }

    public class RowDTO {
    	public Custom_Opportunity__c o {set;get;}
    	public Id processInstanceWorkitemId {set;get;}

    	public RowDTO(Custom_Opportunity__c o, ProcessInstanceWorkitem piwi) {
    		this.o = o;
    		if (piwi != null) {
    			this.processInstanceWorkitemId = piwi.Id;	
    		}
    	}

    }

}