public with sharing class FollowingUpReportController {

    public static String NOTI_READ_STATUS = 'Read';
    public static String NOTI_UNREAD_STATUS = 'Unread';
    public static String NOTI_RESPONDED_STATUS = 'Responded';

    public static String GENERAL_PROFILE = 'G';
    public static String CLOSED_OPPS_PROFILE = 'CO';
    public static String FOLLOWUP_PROFILE = 'FU';

    public String reportProfile {set;get;}
    public DataReport totals {set;get;}
    public Id ownerSelected {set;get;}
    public DataReport consultantSelected {set;get;}
    public Map<String, List<DetailReport>> detailData {set;get;}
    public Map<String, List<DataReport>> reportMap {set;get;}      // Owner ID and report data
    public boolean isNotifying {set;get;}
    public FollowingUp_Report__c notification {set;get;}
    public Id oppSelected {set;get;}
    public String catSelected {set;get;}
    public Map<String, DetailReportIterator> pageDetailData {set;get;}

    //Helper objects
    
    Map<Id, DataReport> dataMap {set;get;}      // Owner ID and report data
    Map<Id, DetailReport> oppsMap;              // Opps and days call
    Set<String> oppStatus {set;get;}            // query opp status
    
    public String teamSel {set;get;}        
    public List<String> teamList = new List<String>{'Sales Consultants','Sales Consultants 3'};
    public Set<Id> memberIds {set;get;}

    public FollowingUpReportController() {
        System.debug('FollowingUpReportController...');
        this.init();
        this.buildReport();
    }

    private void init() {
        System.debug('init...');
        this.isNotifying = false;
        this.notification = null;
        this.teamSel = this.teamList.get(0);
        if (String.isBlank(this.reportProfile)) {
            this.reportProfile = System.currentPageReference().getParameters().get('PROFILE');
        }
        System.debug('reportProfile...' + this.reportProfile);
        if (this.getDisplayClosedOpps()) {
            this.oppStatus = new Set<String>{
                'Closed Opportunity'
            };
        } else if (this.getDisplayFollowUpOpps()) {
            this.oppStatus = new Set<String>{
                'Future follow up'
            };
        } else {
            this.reportProfile = GENERAL_PROFILE;
            this.oppStatus = new Set<String>{
                'Quote Sent','Application Form Sent',
                'Application Forms Received','Awaiting Paperwork',
                '24 Hour Call','Pre-Approved',
                'Become Opportunity'
            };
        }
        System.debug('reportProfile...' + this.reportProfile);
    }

    public PageReference loadClosedOppsProfile() {
        System.debug('loadClosedOppsProfile...');
        //this.reportProfile = CLOSED_OPPS_PROFILE;
        //this.init();
        //this.buildReport();
        //this.hideDetails();
        //PageReference ref = Page.FollowingUpReport;
        PageReference ref = ApexPages.currentPage();
        ref.getParameters().put('PROFILE',CLOSED_OPPS_PROFILE);
        ref.setRedirect(true);
        return ref;
    }

    public PageReference loadFollowUpProfile() {
        System.debug('loadFollowUpProfile...');
        //this.reportProfile = FOLLOWUP_PROFILE;
        //this.init();
        //this.buildReport();
        //this.hideDetails();
        PageReference ref = ApexPages.currentPage();
        ref.getParameters().put('PROFILE',FOLLOWUP_PROFILE);
        ref.setRedirect(true);
        return ref;
    }

    public PageReference loadGeneralProfile() {
        System.debug('loadGeneralProfile...');
        //this.reportProfile = GENERAL_PROFILE;
        //this.init();
        //this.buildReport();
        //this.hideDetails();
        PageReference ref = ApexPages.currentPage();
        ref.getParameters().put('PROFILE',GENERAL_PROFILE);
        ref.setRedirect(true);
        return ref;   
    }

    public String getReportTitle() {
        String r = 'General Consultant Following Up Report';
        if (this.getDisplayClosedOpps()) {
            r = 'Closed Opportunities Report';
        } else if (this.getDisplayFollowUpOpps()) {
            r = 'Future Follow Up Report';
        }
        return r;
    }

    public void buildReport() {
        System.debug('buildReport...');
        this.totals = new DataReport();
        // Load totals
        this.loadTotals();
        this.loadOwnerNames();
        this.loadActivities();
        this.sortList();
    }

    private void loadTotals() {
        System.debug('loadTotals...');
        this.reportMap = new Map<String, List<DataReport>>();
        this.dataMap = new Map<Id, DataReport>();
        Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
        List<AggregateResult> d = null;
        if (this.getDisplayClosedOpps() && !Test.isRunningTest()) {
            this.memberIds = SOQLSingletonQueries.getGroupMembers(this.teamSel);
            d  = [
                select OwnerId, count(Id) opps from Custom_Opportunity__c
                where Status__c IN :this.oppStatus
                and OwnerType__c != 'Queue'
                and OwnerId IN :this.memberIds
                group by OwnerId
            ];
        } else {
            d  = [
                select OwnerId, count(Id) opps from Custom_Opportunity__c
                where Status__c IN :this.oppStatus
                and OwnerType__c != 'Queue'
                and OwnerId != :sysGenId
                and OwnerId in (Select Id from user where isActive = true)
                group by OwnerId
            ];
        }
        for (AggregateResult a: d) {
            DataReport rpt = new DataReport();
            rpt.ownerId = (Id)a.get('OwnerId');
            rpt.totalOpps = (Integer)a.get('opps'); 
            this.totals.totalOpps += rpt.totalOpps;
            this.dataMap.put(rpt.ownerId, rpt);
        }
        // check groups
        Map<Id, Id> userGroupMap = new Map<Id, Id>(); // User Id, Group Id
        Set<Id> groupIds = new Set<Id>();
        List<GroupMember> glst = [
            select UserOrGroupId, GroupId from GroupMember 
            where UserOrGroupId in :this.dataMap.keySet()
        ];
        for (GroupMember a: glst) {
            userGroupMap.put(a.UserOrGroupId, a.GroupId);
            groupIds.add(a.GroupId);
        }
        Map<Id, String> groupNamesMap = new Map<Id, String>();
        if (!groupIds.isEmpty()) {
            for (Group a : [select Id, DeveloperName, Name from Group 
                            where Id IN :groupIds
                            and Name in :this.teamList]) {
                groupNamesMap.put(a.Id, a.Name);
            }
        }
        for (String a: this.teamList) {
            this.reportMap.put(a, new List<DataReport>());
        }
        for (Id a: this.dataMap.keySet()) {
            String g = groupNamesMap.get(userGroupMap.get(a));
            if (String.isBlank(g)) {
                g = '-- Other gorups --';
            }
            List<DataReport> lst = this.reportMap.get(g);
            if (lst ==null) {
                lst = new List<DataReport>();
                this.reportMap.put(g, lst);
            }
            lst.add(this.dataMap.get(a));
        }
    }

    private void loadOwnerNames() {
        System.debug('loadOwnerNames...');
        if (this.dataMap.isEmpty()) return;
        List<User> d = [
            Select Id, Name, State, isActive from user where Id in :this.dataMap.keySet()
        ];
        for (User a : d) {
            this.dataMap.get(a.Id).ownerName = a.Name;
            this.dataMap.get(a.Id).state = a.State;
            this.dataMap.get(a.Id).isActive = a.isActive;
        }
    }

    private void loadActivities() {
        System.debug('loadActivities...');
        this.oppsMap = new Map<Id, DetailReport>();
        // Getting opp ids
        Set<Id> oppIds = new Set<Id>();
        List<Custom_Opportunity__c> lst = null;
        if (this.getDisplayClosedOpps()) {
            lst = [
                select Id from Custom_Opportunity__c
                where Status__c IN :this.oppStatus
                and OwnerType__c != 'Queue'
                and OwnerId in :this.memberIds
            ];
        } else if (this.getDisplayFollowUpOpps()) {
            lst = [
                select Id, OwnerId,  
                    (Select Id, Subject, ActivityDate, Priority, ReminderDateTime, Status, TaskSubtype from Tasks 
                     where (NOT Subject like 'Voice call%') and TaskSubtype != 'Email' and (NOT Subject like 'Aspects call%') and (NOT Subject like '%ipSCAPE%')
                     Order by CreatedDate DESC Limit 1) LastTask
                from Custom_Opportunity__c
                where Status__c IN :this.oppStatus
                and OwnerType__c != 'Queue'
            ];
        } else {
            lst = [
                select Id from Custom_Opportunity__c
                where Status__c IN :this.oppStatus
                and OwnerType__c != 'Queue'
            ];
        }
        for (Custom_Opportunity__c o : lst) {
            oppIds.add(o.Id);
            if (this.getDisplayFollowUpOpps()) {
                //  Min report
                DataReport rpt = this.dataMap.get(o.OwnerId);
                if (rpt == null) {
                    rpt = new DataReport();
                    this.dataMap.put(o.OwnerId, rpt);
                }
                // Detailed report
                DetailReport rp = new DetailReport();
                this.oppsMap.put(o.Id, rp);
                if (o.tasks == null || o.tasks.isEmpty()) {
                    rpt.twoDayOpps += 1;
                    rp.days = 2;
                } else {
                    Task t = o.tasks.get(0);
                    if (t.ActivityDate >= Date.today()) {
                        rpt.zeroDayOpps += 1;
                        rp.days = 0;
                    } else {
                        rpt.oneDayOpps += 1;
                        rp.days = 1;
                    }
                }
            }
        }

        List<AggregateResult> d = [
            select WhatId, Max(CreatedDate) maxdate, Count(Id) total from Task
            //where (TaskSubtype = 'Call' or Subject like 'Voice call%' or Subject like 'Aspects Call%')
            where ((Subject like 'Voice call%')
             or (Subject like '%ipSCAPE%'))
            and CallDurationInSeconds >= 20
            and WhatId in :oppIds
            and CreatedDate = last_n_days:30
            group by WhatId
        ];
        for (AggregateResult a: d) {
            DetailReport rp = this.oppsMap.get((Id)a.get('WhatId'));
            if (rp == null) {
                rp = new DetailReport();
                this.oppsMap.put((Id)a.get('WhatId'), rp);
            }
            rp.lastCallDate = (Datetime)a.get('maxdate');
            rp.totalCalls = (Integer)a.get('total');
            if (!this.getDisplayFollowUpOpps()) {
                rp.days = calcDays(rp.lastCallDate);
            }
        }

        if (!this.getDisplayFollowUpOpps() && !oppsMap.isEmpty()) {
            // Get Opp ownerIds
            List<Custom_Opportunity__c> opps = [
                select Id, OwnerId,
                    (Select Id, Subject, ActivityDate, Priority, ReminderDateTime, Status, TaskSubtype from Tasks
                         where (NOT Subject like 'Voice call%') and TaskSubtype != 'Email' and (NOT Subject like 'Aspects call%') and (NOT Subject like '%ipSCAPE%')
                         Order by CreatedDate DESC Limit 1)
                from Custom_Opportunity__c where Id in :oppsMap.keySet()
                and OwnerId in (Select Id from user where isActive = true)
            ];
            for (Custom_Opportunity__c o: opps) {
                DataReport rpt = this.dataMap.get(o.OwnerId);
                if (rpt != null) {
                    rpt.oppIds.add(o.Id);
                    Integer days = oppsMap.get(o.Id).days;
                    if (rpt != null && days != null) {
                        if (days == 0) {
                            rpt.zeroDayOpps++;
                            this.totals.zeroDayOpps++;
                        } else if (days == 1) {
                            rpt.oneDayOpps += days;
                            this.totals.oneDayOpps++;
                        } else if (days == 2) {
                            rpt.twoDayOpps++;
                            this.totals.twoDayOpps++;
                        } else {
                            rpt.threeDayOpps++;
                            this.totals.threeDayOpps++;
                        }
                    }
                }
            }
        }

        // emails
        d = [
            select WhatId, Max(CreatedDate) maxdate, Count(Id) total from Task
            where (TaskSubtype = 'Email')
            and WhatId in :oppIds
            and CreatedDate = last_n_days:30
            group by WhatId
        ];
        for (AggregateResult a: d) {
            DetailReport rp = this.oppsMap.get((Id)a.get('WhatId'));
            if (rp == null) {
                rp = new DetailReport();
                this.oppsMap.put((Id)a.get('WhatId'), rp);
            }
            rp.lastEmailDate = (Datetime)a.get('maxdate');
            rp.totalEmails = (Integer)a.get('total');
        }
        // SMS
        d = [
            select Custom_Opportunity__c, Max(CreatedDate) maxdate, Count(Id) total from smagicinteract__smsMagic__c
            where Custom_Opportunity__c in :oppIds
            and CreatedDate = last_n_days:30
            group by Custom_Opportunity__c
        ];
        for (AggregateResult a: d) {
            DetailReport rp = this.oppsMap.get((Id)a.get('Custom_Opportunity__c'));
            if (rp == null) {
                rp = new DetailReport();
                this.oppsMap.put((Id)a.get('Custom_Opportunity__c'), rp);
            }
            rp.lastSMSDate = (Datetime)a.get('maxdate');
            rp.totalSMS = (Integer)a.get('total');
        }
    }

    private void searchDetails() {
        System.debug('searchDetails...');
        this.detailData = new Map<String, List<DetailReport>>();
        this.detailData.put(getCategory(null, this.reportProfile), new List<DetailReport>());
        this.detailData.put(getCategory(3, this.reportProfile), new List<DetailReport>());
        this.detailData.put(getCategory(2, this.reportProfile), new List<DetailReport>());
        this.detailData.put(getCategory(1, this.reportProfile), new List<DetailReport>());
        this.detailData.put(getCategory(0, this.reportProfile), new List<DetailReport>());
        if (this.consultantSelected != null) {
            Id ownerId = this.consultantSelected.ownerId;
            //List<String> status = this.oppStatus;
            String sql = 'SELECT Id, Name, Status__c, Email_Address__c, Mobile_Number__c, State__c, Lead_Loan_Type__c, ' +
                         '        Total_Commission__c, Finance_Amount__c, Date_Closed_or_Settled__c, Reason_for_Closure__c, CreatedDate ';
            if (this.getDisplayFollowUpOpps()) {
                sql += ', ' +
                       '(Select Id, Subject, ActivityDate, Priority, ReminderDateTime, Status, TaskSubtype from Tasks ' +
                       'where (NOT Subject like \'Voice call%\') and TaskSubtype != \'Email\' and (NOT Subject like \'Aspects call%\') and (NOT Subject like \'%ipSCAPE%\') ' +
                       'Order by CreatedDate DESC Limit 1) LastTask ';
            }
            sql += 'FROM Custom_Opportunity__c ' +
                   'WHERE OwnerId = :ownerId ' +
                   'AND Status__c in :oppStatus ' +
                   'ORDER BY Name';
            List<Custom_Opportunity__c> d = Database.query(sql);
            List<DetailReport> lst = null;
            String cat = null;
            for (Custom_Opportunity__c o : d) {
                DetailReport dr = this.oppsMap.get(o.Id);
                if (dr == null) {
                    dr = new DetailReport();
                    this.oppsMap.put(o.Id, dr);
                }
                dr.opp = o;
                cat = getCategory(dr.days, this.reportProfile);
                lst = this.detailData.get(cat);
                if (lst == null) {
                    lst = new List<DetailReport>();
                    this.detailData.put(cat, lst);
                }
                if (this.getDisplayFollowUpOpps()) {
                    if (o.tasks != null && !o.tasks.isEmpty()) {
                        dr.task = o.tasks.get(0);
                    }
                }
                lst.add(dr);
            }
        }
        if (this.getDisplayClosedOpps()) {
            System.debug('Filling iterators...');
            this.pageDetailData = new Map<String, DetailReportIterator>();
            for (String k : this.detailData.keySet()) {
                DetailReportIterator a = new DetailReportIterator(this.detailData.get(k));
                a.pageSize = 10;
                this.pageDetailData.put(k, a);
                this.detailData.put(k, a.next());
                System.debug(k + ': ' + a.fullList.size());    
            }
            System.debug('pageDetailData : ' + pageDetailData.size());
        }
    }

    public Set<String> getDetailReportKeys() {
        System.debug('getDetailReportKeys...');
        return this.detailData.keySet();
    }

    public Set<String> getReportKeys() {
        System.debug('getReportKeys...');
        if (this.getDisplayClosedOpps()) {
            return new Set<String>{this.teamSel};
        }
        return this.reportMap.keySet();
    }

    public void showDetails() {
        System.debug('showDetails: ' + this.ownerSelected);
        this.consultantSelected = null;
        if (this.ownerSelected != null) {
            this.consultantSelected = this.dataMap.get(this.ownerSelected);
        }
        this.searchDetails();
        this.initNotification();
        //PageReference ref = ApexPages.currentPage();
        //return ref.setAnchor('pnlDetails');
    }

    public void hideDetails() {
        System.debug('hideDetails...');
        this.consultantSelected = null;
        this.ownerSelected = null;
        this.initNotification();
        // this.searchDetails();
    }

    public static Integer calcDays(Datetime a) {
        Decimal c = (Datetime.now().getTime() - a.getTime())/1000.0/60.0/60.0/24.0;
        return c.intValue();
    }

    public static String getCategory(Integer days) {
        return getCategory(days, null);
    }

    public static String getCategory(Integer days, String reportType) {
        String r = null;
        if (FOLLOWUP_PROFILE.equals(reportType)) {
            if (days == 0) {
                r = 'Active Tasks';
            } else if (days == 1) {
                r = 'Overdued Tasks';
            } else if (days == 2) {
                r = 'Missed Tasks';
            }
        } else {
            r = 'Not calls';
            if (days == 0) {
                r = '0 days calls';
            } else if (days == 1) {
                r = '1 day calls';
            } else if (days == 2) {
                r = '2 days calls';
            } else if (days >= 3) {
                r = '+3 days calls';
            }
        }
        return r;
    }

    private void sortList() {
        System.debug('sortList...');
        for (String k : this.reportMap.keySet()) {
            List<DataReport> r = this.reportMap.get(k);
            r.sort();
            //System.debug('sorted ' + r.size() + ' records');
            //System.debug(JSON.serializePretty(r));
            this.reportMap.put(k, r);
        }
    }

    public List<DataReport> getData() {
        System.debug('getData...');
        List<DataReport> r = this.dataMap.values();
        r.sort();
        return r;
    }

    public void prepareNotification() {
        System.debug('prepareNotification... ' + this.consultantSelected);
        if (this.consultantSelected != null) {
            this.isNotifying = true;
            this.markOpps(false, null);
            if (this.notification == null) {
                this.notification = new FollowingUp_Report__c();
            }
        }
    }

    private void markOpps(Boolean mark, String category) {
        List<DetailReport> tmp = null;
        if (String.isBlank(category)) {
            tmp = this.oppsMap.values();
        } else {
            if (this.getDisplayClosedOpps()) {
                tmp = this.pageDetailData.get(category).fullList;
            } else {
                tmp = this.detailData.get(category);
            }
        }
        if (tmp != null) {
            for (DetailReport a : tmp) {
                a.sel = mark;
            }
        }
    }

    private void initNotification() {
        System.debug('initNotification...');
        this.isNotifying = false;
        this.notification = null;
        this.markOpps(false, null);
    }

    public void sendNotification() {
        System.debug('sendNotification...');
        if (String.isBlank(this.notification.Notes__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please include some notes before sending a notification.'));
            return;
        }
        System.debug('Notes: ' + this.notification.Notes__c);
        this.notification.Name =Datetime.now().format(DateUtils.FORMAT_LOCAL_FULL);
        this.notification.User__c = this.consultantSelected.ownerId;
        this.notification.OwnerId = this.consultantSelected.ownerId;
        this.notification.Status__c = NOTI_UNREAD_STATUS;
        insert this.notification;
        Map<Id, FollowingUp_Report_Detail__c> opps = new Map<Id, FollowingUp_Report_Detail__c>();
        for (DetailReport a: this.oppsMap.values()) {
            if (a.sel) {
                System.debug('Opp: ' + a.opp.Name);
                FollowingUp_Report_Detail__c f = new FollowingUp_Report_Detail__c();
                f.FollowingUp_Report__c = this.notification.Id;
                f.Custom_Opportunity__c = a.opp.Id;
                f.Name = a.opp.Name;
                opps.put(a.opp.Id, f);
            }
        }
        if (!opps.isEmpty()) {
            insert opps.values();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Notification has been saved and sent it to the consultant.'));
        this.initNotification();
    }
    
    public void addOppNotification() {
        System.debug('addOppNotification...' + this.oppSelected);
        if (this.oppSelected != null) {
            DetailReport o = this.oppsMap.get(this.oppSelected);
            if (o != null) {
                o.sel = true;
                System.debug(o.opp.Name + ': ' + this.oppSelected);
            }
            //this.oppSelMap.put(this.oppSelected, true);
        }
    }

    public void remOppNotification() {
        System.debug('addOppNotification... ' + this.oppSelected);
        if (this.oppSelected != null) {
            DetailReport o = this.oppsMap.get(this.oppSelected);
            if (o != null) {
                o.sel = false;
            }
            //this.oppSelMap.put(this.oppSelected, false);
        }
    }

    public void selectAllCategory() {
        System.debug('selectAllCategory... ' + this.catSelected);
        this.markOpps(true, this.catSelected);
    }

    public void unselectAllCategory() {
        System.debug('unselectAllCategory... ' + this.catSelected);
        this.markOpps(false, this.catSelected);
    }

    public Integer getTotalSelectedOpps() {
        Integer r = 0;
        for (DetailReport a : this.oppsMap.values()) {
            if (a.sel) r++; 
        }
        return r;
    }

    public void cancelNotification() {
        System.debug('cancelNotification...');
        this.initNotification();
    }

    public class DataReport implements Comparable {
        public Id ownerId {set;get;}
        public String ownerName {set;get;}
        public String state {set;get;}
        public Integer totalOpps {set;get;}
        public Integer zeroDayOpps {set;get;}
        public Integer oneDayOpps {set;get;}
        public Integer twoDayOpps {set;get;}
        public Integer threeDayOpps {set;get;}
        public Boolean isActive {set;get;}
        public Set<Id> oppIds {set;get;}

        public DataReport() {
            this.totalOpps = 0;
            this.zeroDayOpps = 0;
            this.oneDayOpps = 0;
            this.twoDayOpps = 0;
            this.threeDayOpps = 0;
            this.oppIds = new Set<Id>();
        }

        public Integer getNotCallOpps() {
            return this.totalOpps - this.zeroDayOpps - this.oneDayOpps - this.twoDayOpps - this.threeDayOpps;
        }

        public Integer compareTo(Object o) {
            DataReport r = (DataReport)o;
            Integer returnValue = 0;
            if (String.isNotBlank(this.state) && String.isNotBlank(r.state)) {
                returnValue = this.state.compareTo(r.state);
            } else if (String.isNotBlank(this.state) && String.isBlank(r.state)) {
                returnValue = -1;
            } else if (String.isBlank(this.state) && String.isNotBlank(r.state)) {
                returnValue = 1;
            }
            if (returnValue == 0) {
                if (String.isNotBlank(this.ownerName) && String.isNotBlank(r.ownerName)) {
                    returnValue = this.ownerName.compareTo(r.ownerName);
                } else if (String.isNotBlank(this.ownerName) && String.isBlank(r.ownerName)) {
                    returnValue = -1;
                } else if (String.isBlank(this.ownerName) && String.isNotBlank(r.ownerName)) {
                    returnValue = 1;
                }   
            }
            return returnValue;
        }
    }

    public class DetailReport implements Comparable {
        public Custom_Opportunity__c opp {set;get;}
        public Task task {set;get;}
        public Integer days {set;get;}
        public Datetime lastCallDate {set;get;}
        public Datetime lastSMSDate {set;get;}
        public Datetime lastEmailDate {set;get;}
        public Integer totalCalls {set;get;}
        public Integer totalSMS {set;get;}
        public Integer totalEmails {set;get;}

        public Boolean sel {set;get;}

        public DetailReport() {
            this.sel = false;
            this.totalCalls = 0;
            this.totalSMS = 0;
            this.totalEmails = 0;
        }

        public Integer compareTo(Object o) {
            DataReport r = (DataReport)o;
            Integer returnValue = 0;

            return returnValue;   
        }
    }

    public Boolean getDisplayClosedOpps() {
        if (CLOSED_OPPS_PROFILE.equals(this.reportProfile)) {
            return true;
        }
        return false;
    }

    public Boolean getDisplayFollowUpOpps() {
        if (FOLLOWUP_PROFILE.equals(this.reportProfile)) {
            return true;
        }
        return false;
    }

    public List<SelectOption> getTeamOptions() {
        List<SelectOption> r = new List<SelectOption>();
        for (String a: this.teamList) {
            r.add(new SelectOption(a,a));
        }
        return r;
    }

    public void previousPage() {
        if (String.isNotBlank(this.catSelected)) {
            DetailReportIterator a = this.pageDetailData.get(this.catSelected);
            if (a != null) {
                this.detailData.put(this.catSelected, a.previous());
            }                
        }
    }

    public void nextPage() {
        if (String.isNotBlank(this.catSelected)) {
            DetailReportIterator a = this.pageDetailData.get(this.catSelected);
            if (a != null) {
                this.detailData.put(this.catSelected, a.next());
            }
        }
    }

    public void firstPage() {
        if (String.isNotBlank(this.catSelected)) {
            DetailReportIterator a = this.pageDetailData.get(this.catSelected);
            if (a != null) {
                this.detailData.put(this.catSelected, a.first());
            }                
        }
    }

    public void lastPage() {
        if (String.isNotBlank(this.catSelected)) {
            DetailReportIterator a = this.pageDetailData.get(this.catSelected);
            if (a != null) {
                this.detailData.put(this.catSelected, a.last());
            }                
        }
    }

    public void resetPage() {
        if (String.isNotBlank(this.catSelected)) {
            DetailReportIterator a = this.pageDetailData.get(this.catSelected);
            if (a != null) {
                a.reset();
                this.detailData.put(this.catSelected, a.next());
            }                
        }
    }
}