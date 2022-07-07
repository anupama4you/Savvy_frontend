public with sharing class FollowingUpReportDetailController {

	public User rptUser {set;get;}
	public Map<Id, FollowingUp_Report__c> reports {set;get;}
	public FollowingUp_Report__c report {set;get;}
	public Map<String, List<FollowingUpReportController.DetailReport>> detailData {set;get;}
	public Id reportId {set;get;}
	public Boolean isResponding {set;get;}
	public Note response {set;get;}
	public List<Note> notes {set;get;}

	Map<Id, FollowingUpReportController.DetailReport> oppsMap;

	public FollowingUpReportDetailController() {
		this.notes = new List<Note>();
	}

	public void initReport() {
		this.init();
		this.changeReportStatus('Read');
	}

	private void init() {
		String p = System.currentPageReference().getParameters().get('U');
		Id userId = UserInfo.getUserId();
		this.isResponding = false;
		if (String.isNotBlank(p)) {
			userId = p;
		}
		loadReport(userId);
	}

	private void loadReport(Id userId) {
		// Finding the user
		List<User> d = [
			SELECT Id, Phone, Email, MobilePhone, Name, IsActive, profileid 
			FROM User Where id = :userId
		];
		this.rptUser = d.get(0);
		// Loading the Following Up Reports for the user
		this.reports = new Map<Id, FollowingUp_Report__c>();		
		this.report = null;
		List<FollowingUp_Report__c> lst = [
			SELECT Id, Name, CreatedDate, Notes__c, User__c, Total_Opportunities__c, Status__c 
			FROM FollowingUp_Report__c 
			WHERE User__c = :this.rptUser.Id ORDER BY CreatedDate DESC
		];
		for (FollowingUp_Report__c a: lst) {
			if (this.report == null) {
				this.report = a;
				this.reportId = a.Id;
			}
			this.reports.put(a.Id, a);
		}
		// Seacrhing for details
		this.search();
	}

	public void search() {
		this.detailData = new Map<String, List<FollowingUpReportController.DetailReport>>();
		this.oppsMap = new Map<Id, FollowingUpReportController.DetailReport>();
		this.loadNotes();
		if (this.report != null) {
			// Initial Lists
			this.detailData.put(
				FollowingUpReportController.getCategory(null), 
				new List<FollowingUpReportController.DetailReport>());
	        this.detailData.put(
	        	FollowingUpReportController.getCategory(3), 
	        	new List<FollowingUpReportController.DetailReport>());
	        this.detailData.put(
	        	FollowingUpReportController.getCategory(2), 
	        	new List<FollowingUpReportController.DetailReport>());
	        this.detailData.put(
	        	FollowingUpReportController.getCategory(1), 
	        	new List<FollowingUpReportController.DetailReport>());
	        this.detailData.put(
	        	FollowingUpReportController.getCategory(0), 
	        	new List<FollowingUpReportController.DetailReport>());
			
	        // Search most recent calls
	        List<AggregateResult> dc = [
	            select WhatId, Max(CreatedDate) maxdate, Count(Id) total from Task
	            where ((Subject like 'Voice call%') or (Subject like '%ipSCAPE%')) and CallDurationInSeconds >= 20
	            and WhatId IN (
	            	SELECT Custom_Opportunity__c FROM FollowingUp_Report_Detail__c 
                	WHERE FollowingUp_Report__c = :this.report.Id
	            )
	            and CreatedDate = last_n_days:30
	            group by WhatId
	        ];
	        for (AggregateResult a: dc) {
	            FollowingUpReportController.DetailReport rp = new FollowingUpReportController.DetailReport();
	            rp.lastCallDate = (Datetime)a.get('maxdate');
	            rp.totalCalls = (Integer)a.get('total');
	            rp.days = FollowingUpReportController.calcDays(rp.lastCallDate);
	            this.oppsMap.put((Id)a.get('WhatId'), rp);
	        }
			// Searching Opps
			List<Custom_Opportunity__c> d = [
                SELECT Id, Name, Status__c, Email_Address__c, Mobile_Number__c, State__c, Lead_Loan_Type__c,
                       Total_Brokerage__c, Total_Commission__c, Total_DOF__c, Total_Insurance_Commission__c,
                       Finance_Amount__c
                FROM Custom_Opportunity__c
                WHERE Id in (
                	SELECT Custom_Opportunity__c FROM FollowingUp_Report_Detail__c 
                	WHERE FollowingUp_Report__c = :this.report.Id
                )
                ORDER BY Name
            ];
            List<FollowingUpReportController.DetailReport> lst = null;
            String cat = null;
            for (Custom_Opportunity__c o : d) {
                FollowingUpReportController.DetailReport dr = this.oppsMap.get(o.Id);
                if (dr == null) {
                    dr = new FollowingUpReportController.DetailReport();
                    this.oppsMap.put(o.Id, dr);
                }
                dr.opp = o;
                cat = FollowingUpReportController.getCategory(dr.days);
                lst = this.detailData.get(cat);
                if (lst == null) {
                    lst = new List<FollowingUpReportController.DetailReport>();
                    this.detailData.put(cat, lst);
                }
                lst.add(dr);
            }

            // Searching activities
            this.loadActivities();

            // Delete unused categories
            for (String k: this.detailData.keySet()) {
            	if (this.detailData.get(k).isEmpty()) {
            		this.detailData.remove(k);
            	}
            }
		}
	}

	private void loadActivities() {
        System.debug('loadActivities...');
        List<AggregateResult> d = [
            select WhatId, Max(CreatedDate) maxdate, Count(Id) total from Task
            where (TaskSubtype = 'Email')
            and WhatId in (
                select Id from Custom_Opportunity__c where Id in :oppsMap.keySet()
            )
            and CreatedDate = last_n_days:30
            group by WhatId
        ];
        for (AggregateResult a: d) {
            FollowingUpReportController.DetailReport rp = this.oppsMap.get((Id)a.get('WhatId'));
            if (rp == null) {
                rp = new FollowingUpReportController.DetailReport();
                this.oppsMap.put((Id)a.get('WhatId'), rp);
            }
            rp.lastEmailDate = (Datetime)a.get('maxdate');
            rp.totalEmails = (Integer)a.get('total');
        }
        // SMS
        d = [
            select Custom_Opportunity__c, Max(CreatedDate) maxdate, Count(Id) total from smagicinteract__smsMagic__c
            where Custom_Opportunity__c in :oppsMap.keySet()
            and CreatedDate = last_n_days:30
            group by Custom_Opportunity__c
        ];
        for (AggregateResult a: d) {
            FollowingUpReportController.DetailReport rp = this.oppsMap.get((Id)a.get('Custom_Opportunity__c'));
            if (rp == null) {
                rp = new FollowingUpReportController.DetailReport();
                this.oppsMap.put((Id)a.get('Custom_Opportunity__c'), rp);
            }
            rp.lastSMSDate = (Datetime)a.get('maxdate');
            rp.totalSMS = (Integer)a.get('total');
        }
    }

	public Set<String> getDetailReportKeys() {
        System.debug('getDetailReportKeys...');
        return this.detailData.keySet();
    }

	public List<FollowingUp_Report__c> getNotifications() {
		List<FollowingUp_Report__c> r = new List<FollowingUp_Report__c>();
		if (this.reports != null) {
			for (FollowingUp_Report__c a: this.reports.values()) {
				r.add(a);
			}
		}
		return r;
	}

	public void selectReport() {
		this.isResponding = false;
		this.report = this.reports.get(this.reportId);
		this.changeReportStatus('Read');
		this.search();
	}

	private void changeReportStatus(String status) {
		if (this.report == null || String.isBlank(status)) return;
		if (FollowingUpReportController.NOTI_UNREAD_STATUS.equals(this.report.Status__c) && 
			FollowingUpReportController.NOTI_READ_STATUS.equals(status) && 
			UserInfo.getUserId().equals(this.rptUser.Id)) {
			this.report.Status__c = status;
			update this.report;
		}
	}

	public void displayResponse() {
		this.response = new Note();
	}

	public void respondReport() {
		// Validations
		// completing data
		this.response.parentId = this.report.Id;
		this.response.title = 'Reponse #' + (this.notes.size() + 1) + ' (report: ' + this.report.name + ')';
		// saving
		insert this.response;
		this.report.Status__c = FollowingUpReportController.NOTI_RESPONDED_STATUS;
		update this.report;
		this.response = null;
		this.isResponding = false;
		this.loadNotes();
	}

	private void loadNotes() {
		this.notes = new List<Note>();
		if (this.report == null) return;
		this.notes = [
			SELECT Id, Title, Body, ParentId, CreatedDate FROM Note 
			WHERE ParentId = :this.report.Id 
			ORDER BY CreatedDate DESC
		];
	}

	public Boolean getHasNotes() {
		if (this.notes != null && !this.notes.isEmpty()) {
			return true;
		}
		return false;
	}

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
}