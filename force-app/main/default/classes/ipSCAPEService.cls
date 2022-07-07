public class ipSCAPEService {

    public static Map<String, Map<String, List<ipSCAPECampaignSettings__c>>> campaignSettings; // Map<Bucket, Map<Loan Type, List<Setting>>>

    private static ConnectionRESTWs.Param preparePOSTRequest(String endPointCall) {
        return prepareRequest(endPointCall, ConnectionRESTWs.POST);
    }

    private static ConnectionRESTWs.Param prepareGETRequest(String endPointCall) {
        return prepareRequest(endPointCall, ConnectionRESTWs.GET);
    }

    private static ConnectionRESTWs.Param prepareRequest(String endPointCall, String method) {
        ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        p.endpoint = s.endpoint__c + endPointCall;
        p.method = method;
        p.requestHeader = new Map<String, String>();
        p.requestHeader.put('Content-Type', 'application/x-www-form-urlencoded');
        p.setCredentials(s.username__c, s.password__c);
        return p;
    }

    public static ipSCAPEDTOs.BasicResult ping() {
        ipSCAPEDTOs.BasicResult r = null;
        ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/ping');
        HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
            r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
        }
        return r;
    }

    public static ipSCAPEDTOs.LoginResult login() {
        ipSCAPEDTOs.LoginResult r = null;
        ConnectionRESTWs.Param p = preparePOSTRequest('/api/latest/user/login');
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        p.body = 'apiKey=' + s.apiKey__c + '&destinationState=Login&updateState=1';
        HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
            r = (ipSCAPEDTOs.LoginResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.LoginResult.class);
        }
        return r;
    }

    @Future(callout=true)
    public static void autoLogin() {
        System.debug('autoLogin...');
        ipSCAPEDTOs.LoginResult r = login();
         if (r == null || 'error'.equals(r.errorCode)) {
            // Send an urgen notification
            System.debug('Error!!!!!!!!');
        }
        System.debug('autoLogin end.');
    }

    public static void readOrgDetails() {
        ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/organisation/readorgdetails');
        HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
            System.debug(res.getStatusCode() + ': ' + res.getStatus());
            System.debug(res.getBody());
        }
    }

    public static ipSCAPEDTOs.UserListResult readUserList() {
        ipSCAPEDTOs.UserListResult r = null;
        ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/user/readuserslist');
        p.requestQuery = new Map<String, String>();
        p.requestQuery.put('agentStatus', '');
        p.requestQuery.put('isLoggedIn', '');
        p.requestQuery.put('pageNo', '1');
        p.requestQuery.put('perPage', '50');
        p.requestQuery.put('showAssignedCampaigns', '');
        p.requestQuery.put('showTimeInStatus', '');
        p.requestQuery.put('sortField', 'firstName');
        p.requestQuery.put('sortOrder', 'ASC');
        p.requestQuery.put('userType', '');
        HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
            r = (ipSCAPEDTOs.UserListResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.UserListResult.class);
        }
        return r;
    }

    public static Integer sendLead(Lead__c lead) {
        Integer r = -1;
        if (lead != null)  {
            // Lead details
            LeadExtraData a = new LeadExtraData();
            a.FirstName = lead.First_Name__c;
            a.LastName = lead.Last_Name__c;
            a.Email = lead.Email_Address__c;
            a.CreatedDate = DateUtils.formatDate(lead.CreatedDate, 'yyMMdd');
            a.LoanType = lead.Loan_Type__c;
            a.Postcode = lead.Postcode__c;
            a.State = getNewState(lead.State__c);

            String timeZone = PostcodeHelper.getTimezone(lead.State__c);
            

            ConnectionRESTWs.Param p = preparePOSTRequest('/api/latest/lead/createlead');
            p.body = 'campaignId=' + lead.CC_Campaign_ID__c.intValue() + ' &leadType=New&listId=' + lead.CC_List_ID__c.intValue() + 
                     '&phone1=' + lead.Mobile_Number__c + '&customerKey=' + lead.Id +
                     '&leadData=' + EncodingUtil.urlEncode(JSON.serialize(a, true) , 'UTF-8');
            if (timeZone != null) {
                p.body += '&timezone=' + timeZone;
            }
            HttpResponse res = ConnectionRESTWs.invoke(p);
            if (res != null) {
                ipSCAPEDTOs.CreateLeadResult rslt = (ipSCAPEDTOs.CreateLeadResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.CreateLeadResult.class);
                if (rslt != null) {
                    if (rslt.result != null && rslt.result.leadId != null) {
                        r = rslt.result.leadId;
                    } else if (rslt.errorDetails != null) {
                        String[] d = rslt.errorDetails.remove('{').remove('}').remove(' ').split(',');
                        if (d != null && d.size() == 3){
                            r = Integer.valueOf(d[2].remove('leadId='));
                        }
                    }
                }
            }
        }
        return r;
    }

    public static String getNewState(String state) {
      String r = state;
      if ('NSW'.equalsIgnoreCase(state) || 'ACT'.equalsIgnoreCase(state)) {
        r = 'NSW/ACT';
      } else if ('SA'.equalsIgnoreCase(state) || 'NT'.equalsIgnoreCase(state)) {
        r = 'SA/NT';
      } else if ('VIC'.equalsIgnoreCase(state) || 'TAS'.equalsIgnoreCase(state)) {
        r = 'VIC/TAS';
      }
      return r;
    }

    @Future(callout=true)
    public static void sendLeads(List<Id> idLeads) {
        System.debug('sendLeads...');
        if (idLeads != null) {
            String sql = 'Select Id, Name, First_Name__c, Last_Name__c, Mobile_Number__c, ' + 
                         '       Email_Address__c, Status__c, Postcode__c, State__c, Loan_Type__c, ' + 
                         '       Loan_For__c, Credit_History__c, Finance_Amount__c, Employment_Status__c, '+
                         '       Bucket_Type__c, CreatedDate, CC_Campaign_ID__c, CC_List_ID__c,  ' + 
                         '       CC_Lead_ID__c, CC_Sent_Date__c ' +
                         'From Lead__c Where Id in :idLeads';
            List<Lead__c> leads = Database.query(sql);
            Integer ccLeadId = null;
            for (Lead__c a: leads) {
                System.debug('sending lead... ' + a.Name);
                ccLeadId = sendLead(a);
                if (ccLeadId != null && ccLeadId > 0) {
                    ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
                    if (s.Mark_In_Call_Center__c) {
                        a.Is_Call_Center__c = true;
                    }
                }
                a.CC_Lead_ID__c = ccLeadId;
                a.CC_Sent_Date__c = Datetime.now();
            }
            System.debug('Sent Leads: ' + leads.size());
            System.debug('Updating leads details...');
            update leads;
        }
    }

    public class ReadCallParam {
        public String activityId {set;get;}
        public String agentId {set;get;}
        public String callType {set;get;}
        public String calledNumber {set;get;}
        public String callerNumber {set;get;}
        public String campaignId {set;get;}
        public String campaignTitle {set;get;}
        public String fromTimestamp {set;get;}
        public String interactionId {set;get;}
        public String pageNo {set;get;}
        public String perPage {set;get;}
        public String sortField {set;get;}
        public String sortOrder {set;get;}
        public String toTimestamp {set;get;}
        public String wrapCode {set;get;}

        public Map<String, String> getParams() {
            Map<String, String> r = new Map<String, String>();
            if (String.isNotBlank(this.activityId)) {
                r.put('activityId', this.activityId);
            }
            if (String.isNotBlank(this.agentId)) {
                r.put('agentId', this.agentId);
            }
            if (String.isNotBlank(this.callType)) {
                r.put('callType', this.callType);
            }
            if (String.isNotBlank(this.calledNumber)) {
                r.put('calledNumber', this.calledNumber);
            }
            if (String.isNotBlank(this.callerNumber)) {
                r.put('callerNumber', this.callerNumber);
            }
            if (String.isNotBlank(this.campaignId)) {
                r.put('campaignId', this.campaignId);
            }
            if (String.isNotBlank(this.campaignTitle)) {
                r.put('campaignTitle', this.campaignTitle);
            }
            if (String.isNotBlank(this.fromTimestamp)) {
                r.put('fromTimestamp', this.fromTimestamp);
            }
            if (String.isNotBlank(this.interactionId)) {
                r.put('interactionId', this.interactionId);
            }
            if (String.isNotBlank(this.pageNo)) {
                r.put('pageNo', this.pageNo);
            }
            if (String.isNotBlank(this.perPage)) {
                r.put('perPage', this.perPage);
            }
            if (String.isNotBlank(this.sortField)) {
                r.put('sortField', this.sortField);
            }
            if (String.isNotBlank(this.sortOrder)) {
                r.put('sortOrder', this.sortOrder);
            }
            if (String.isNotBlank(this.toTimestamp)) {
                r.put('toTimestamp', this.toTimestamp);
            }
            if (String.isNotBlank(this.wrapCode)) {
                r.put('wrapCode', this.wrapCode);
            }
            return r;
        }
    }
    
    public static void checkCalls(Integer minutes) {
        Datetime dt = DateTime.now().addMinutes((-1)*minutes);
        ReadCallParam param = new ReadCallParam();
        param.fromTimestamp = DateUtils.convertToString(
            dt, DateUtils.YYYY_MM_DD + ' ' + DateUtils.hhmmss);
        param.perPage = '1000';
        param.sortOrder = 'DESC';
        checkCalls(param.getParams());
    }

    @Future(callout=true)
    public static void checkCalls(Map<String, String> params) {
        System.debug('Checking Activities...');
        ipSCAPEDTOs.CallListResult r = null;
        ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/campaign/readcallslist');
        p.requestHeader.put('Content-Type', '');
        for (String k: params.keySet()) {
            p.addRequestQuery(k, params.get(k), true);    
        }
        HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
            r = (ipSCAPEDTOs.CallListResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.CallListResult.class);
            if (r != null) {
                processActivityList(r.result);
            }
        }
    }

    public static void processActivityList(ipSCAPEDTOs.CallListResultDTO result) {
        System.debug('Processing CallList... ');
        if (result == null || result.data == null || result.data.isEmpty()) return;
        List<Task> newTasks = new List<Task>();
        // Get cache
        Set<String> ccActivityCache  = new Set<String>();
        List<Task> d = [
            Select ipSCAPE_Activity__c From Task 
            Where ipSCAPE_Activity__c != null 
            And CreatedDate = LAST_N_DAYS:1
            Order by CreatedDate DESC
        ];
        for (Task t : d) {
            ccActivityCache.add(t.ipSCAPE_Activity__c);
        }
        System.debug('Total activities in cache: ' + ccActivityCache.size());
        Set<Integer> ccLeadIds = new Set<Integer>();
        // Identify new ccleads
        for (ipSCAPEDTOs.CallDTO c: result.data) {
            if (c.activityId != null && !ccActivityCache.contains(String.valueOf(c.activityId)) && String.isNotBlank(c.endTimestamp)) {
                newTasks.add(makeTask(c));
                ccActivityCache.add(String.valueOf(c.activityId));
                if (c.leadId != null && c.leadId > 0) {
                    ccLeadIds.add(c.leadId);
                } else {
                    // Feed by phone number to search later

                }
            }
        }
        System.debug('Total CC Leads to seach: ' + ccLeadIds.size() + ' | ' + ccLeadIds);
        Map<Integer, Id> linkedObjs = searchCCLeads(ccLeadIds);
        if (!linkedObjs.isEmpty()) {
            for (Task t: newTasks) {
                if (t.ipSCAPE_Lead_Id__c != null && t.ipSCAPE_Lead_Id__c > 0) {
                    Integer ccLeadId = t.ipSCAPE_Lead_Id__c.intValue();
                    if (linkedObjs.containsKey(ccLeadId)) {
                        t.WhatId = linkedObjs.get(ccLeadId);
                    }
                }
            }
        }
        System.debug('Total new Activities: ' + newTasks.size());
        if (!newTasks.isEmpty()) {
            insert newTasks;
        }
    }

    public static Task makeTask(ipSCAPEDTOs.CallDTO call) {
        if (call == null) return null;
        Task r = new Task();

        r.ipSCAPE_Activity__c = String.valueOf(call.activityId);
        r.ipSCAPE_Campaign__c = call.campaignTitle;
        r.ipSCAPE_ActivityOrigin__c = 'ipSCAPE';
        // r.ipSCAPE_Booking_ID__c = null;
        r.ipSCAPE_CallCenter__c = StringUtils.getLocalPhoneFormat(call.callerNumber);
        r.Call_Mobile_Number__c = StringUtils.getLocalPhoneFormat(call.calledNumber);
        if ( String.isNotBlank(call.startTimestamp)) {
            r.ipSCAPE_CallStart__c = Datetime.valueOf(call.startTimestamp);
            r.ActivityDate = r.ipSCAPE_CallStart__c.date();
        }
        if ( String.isNotBlank(call.endTimestamp)) {
            r.ipSCAPE_CallEnd__c = Datetime.valueOf(call.endTimestamp);
        }
        if (call.interactionId != null) {
            r.CallObject = String.valueOf(call.interactionId);
        }
        r.ipSCAPE_AgentName__c = call.agentName;
        r.ipSCAPE_Lead_Id__c = call.leadId;
        // r.ipSCAPE_Time_In_Queue__c = activity.secondsInQueue; It is in Activity Service
        // Custom fiedls
        // r.CallType__c = call.activityStatus;
        r.CallDisposition = call.wrapCode;
        if (call.duration != null) {
            r.CallDurationInSeconds = call.duration;
        }
        
        // 
        // r.WhatId = null;
        r.Description = '[Automatic Savvy Process] [agentId:' + call.agentId  + '] [' + call.wrapId + ']';
        r.Subject = call.activityStatus.toLowerCase().capitalize();
        if (!r.Subject.endsWithIgnoreCase('Call')) {
            r.Subject += ' Call';
        }
        r.Subject += ' using ipSCAPE [auto]';
        r.TaskSubtype = 'Call';
        r.Status = 'Completed';
        r.IsReminderSet = false;
        return r;
    }

    public static Map<Integer, Id> searchCCLeads(Set<Integer> ids) {
        System.debug('searching CCLeads...');
        Map<Integer, Id> r = new Map<Integer, Id>();
        if (ids == null || ids.isEmpty()) return r;
        List<Lead__c> leads = [
            Select Id, CC_Lead_ID__c From Lead__c
            Where CC_Lead_ID__c in :ids
        ];
        System.debug('Total Leads found: ' + leads.size());
        Set<Id> leadIds = new Set<Id>();
        for (Lead__c a: leads) {
            r.put(a.CC_Lead_ID__c.intValue(), a.Id);
            leadIds.add(a.Id);
        }
        // search Opps
        if (!leadIds.isEmpty()) {
            List<Custom_Opportunity__c> dopps = [
                Select Id, Lead__c From Custom_Opportunity__c 
                Where Lead__c in :leadIds
            ];
            Map<Id, Id> leadOpps = new Map<Id, Id>();
            for (Custom_Opportunity__c o: dopps) {
                leadOpps.put(o.Lead__c, o.Id);
            }
            // Check 
            for (Integer ccId: r.keySet()) {
                Id leadId = r.get(ccId);
                if (leadOpps.containsKey(leadId)) {
                    r.put(ccId, leadOpps.get(leadId));
                }
            }
        }
        return r;
    }

    // Update ipSCAPE leads


    //  Get Campaign Details
    public static ipSCAPECampaignSettings__c getCampaignSetting(Lead__c lead) {
        ipSCAPECampaignSettings__c r = null;
        if (lead != null && String.isNotBlank(lead.Bucket_Type__c)) {
            loadCampaignSettings();
            String camploanType = campaignLoanType(lead.Loan_Type__c);
            Map<String, List<ipSCAPECampaignSettings__c>> b = campaignSettings.get(lead.Bucket_Type__c);
            if (b != null && !b.isEmpty()) {
                for (String k: b.keySet()) {
                    List<ipSCAPECampaignSettings__c> clst = b.get(k);
                    if (clst != null && !clst.isEmpty()) {
                        if (k.equals(camploanType) || 'Money3'.equals(k)) {
                            if (clst.size() == 1) {
                                r = clst.get(0);
                            } else {
                                for (ipSCAPECampaignSettings__c a: clst) {
                                    string cmp = '|' + lead.State__c + '|';
                                    if (a.States__c.containsIgnoreCase(cmp)) {
                                        r = a;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // if (r == null) {
        //     r = getDefaultIpSCAPECampaignSetting();
        // }
        return r;
    }

    public static ipSCAPECampaignSettings__c getDefaultIpSCAPECampaignSetting() {
        ipSCAPECampaignSettings__c r = new ipSCAPECampaignSettings__c();
        ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
        r.Name = 'DEFAULT';
        r.Campaign_ID__c = s.Default_Campaign_ID__c;
        r.List_ID__c = s.Default_List_ID__c;
        return r;
    }

    private static void loadCampaignSettings() {
        if (campaignSettings == null) {
            campaignSettings = new Map<String, Map<String, List<ipSCAPECampaignSettings__c>>>();
            List<ipSCAPECampaignSettings__c> d = ipSCAPECampaignSettings__c.getAll().values();
            d.sort();
            Map<String, List<ipSCAPECampaignSettings__c>> cs = null;
            List<ipSCAPECampaignSettings__c> clst = null;
            ipSCAPESettings__c s = ipSCAPESettings__c.getInstance();
            for (ipSCAPECampaignSettings__c a: d) {
                if (s.Campaign_Version__c.equals(a.Campaign_Version__c)) {
                  String b = a.Bucket__c;
                  cs = campaignSettings.get(b);
                  if (cs == null) {
                      cs = new Map<String, List<ipSCAPECampaignSettings__c>>();
                      campaignSettings.put(b, cs);
                  }
                  String k2 = a.Loan_Type__c;
                  if ('Money3'.equals(b)) {
                      k2 = b;
                  }
                  clst = cs.get(k2);
                  if (clst == null) {
                      clst = new List<ipSCAPECampaignSettings__c>();
                      cs.put(k2, clst);
                  }
                  clst.add(a);
                }
            }
            // System.debug(JSON.serializePretty(campaignSettings));
        }
        // system.debug(JSON.serializePretty(campaignSettings));
    }

    public static String campaignLoanType(String loanType) {
        String r = loanType;
        if ('Caravan Finance'.equals(loanType) ||
            'Boat Finance'.equals(loanType) ||
            'Bike Finance'.equals(loanType)) {
            r = 'Leisure Loan';
        } else if (
          'Truck Loan'.equals(loanType) ||
          'Hire Purchase'.equals(loanType) ||
          'Aircraft Finance'.equals(loanType) ||
          'Chattel Mortgage'.equals(loanType)
        ) {
            r = 'Commercial Loan';
        }
        return r;
    }

    // @Future(callout=true)
    public static void completeLead(Id leadId) {
        System.debug('Completing lead... ' + leadId);
        if (leadId == null) return;
        completeLeads(new Set<Id>{leadId});
        // List<Lead__c> d = [Select Name, CC_Lead_ID__c, CC_Completed_Date__c From Lead__c Where Id = :leadId];
		// if (!d.isEmpty() && d.get(0).CC_Lead_ID__c != null) {
		// 	Lead__c a = d.get(0);
		// 	System.debug('processing...' + a.Name + ' [' + a.CC_Lead_ID__c + ']');
        //     ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/lead/updateleaddetails');
        //     p.method = ConnectionRESTWs.PUT;
        //     p.requestHeader.put('Content-Type', '');
        //     p.addRequestQuery('isComplete', '1', true);
        //     p.addRequestQuery('leadId', String.valueOf(a.CC_Lead_ID__c.intValue()), true);
        //     HttpResponse res = ConnectionRESTWs.invoke(p);
        //     if (res != null) {
        //         System.debug(res.getBody());
        //         ipSCAPEDTOs.BasicResult r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
        //         if ('success'.equals(r.resultCode)) {
        //             a.CC_Completed_Date__c = Datetime.now();
        //             update a;
        //         }
        //         // r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
        //     }
        // }
    }

    @Future(callout=true)
    public static void completeLeads(Set<Id> leadIds) {
        System.debug('Completing leads... ' + leadIds);
        if (leadIds == null) return;
        List<Lead__c> d = [
            Select Name, CC_Lead_ID__c, CC_Completed_Date__c 
            From Lead__c Where Id = :leadIds
            And CC_Lead_ID__c > 0 And CC_Completed_Date__c = null];
        List<Lead__c> leads = new List<Lead__c>();
		for (Lead__c a: d) {
            System.debug('processing...' + a.Name + ' [' + a.CC_Lead_ID__c + ']');
            ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/lead/updateleaddetails');
            p.method = ConnectionRESTWs.PUT;
            p.requestHeader.put('Content-Type', '');
            p.addRequestQuery('isComplete', '1', true);
            p.addRequestQuery('leadId', String.valueOf(a.CC_Lead_ID__c.intValue()), true);
            HttpResponse res = ConnectionRESTWs.invoke(p);
            if (res != null) {
                System.debug(res.getBody());
                ipSCAPEDTOs.BasicResult r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
                if ('success'.equals(r.resultCode)) {
                    a.CC_Completed_Date__c = Datetime.now();
                    leads.add(a);
                }
                // r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
            }
        }
        if (!leads.isEmpty()) {
            update leads;
        }
    }

    public static Boolean completeCCLead(String ccLeadId) {
        System.debug('Completing CC lead... ' + ccLeadId);
        if (ccLeadId == null) return false;
        ConnectionRESTWs.Param p = prepareGETRequest('/api/latest/lead/updateleaddetails');
        p.method = ConnectionRESTWs.PUT;
        p.requestHeader.put('Content-Type', '');
        p.addRequestQuery('isComplete', '1', true);
        p.addRequestQuery('leadId', ccLeadId, true);
        try {
            HttpResponse res = ConnectionRESTWs.invoke(p);
            if (res != null) {
                System.debug(res.getBody());
                ipSCAPEDTOs.BasicResult r = (ipSCAPEDTOs.BasicResult)JSON.deserialize(res.getBody(), ipSCAPEDTOs.BasicResult.class);
                if ('success'.equals(r.resultCode)) {
                    System.debug('CCLead completed! ' + ccLeadId);
                    return true;
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return false;
    }

    @Future(callout=true)
    public static void completeCCLeadAsync() {
        System.debug('Running completeCCLeadAsync...');
        List<Lead__c> d = [
            Select Id, Name, CC_Lead_ID__c, CC_Completed_Date__c From Lead__c 
            Where CC_Lead_ID__c > 0 And LastModifiedDate = LAST_N_DAYS:10
            And CC_Completed_Date__c = null
            And Owner_Name__c != 'System Generated'];
        List<Lead__c> leads = new List<Lead__c>();
        System.debug('Total leads to be completed: ' + d.size());
        for (Lead__c a: d) {
            System.debug('Processing Lead: ' + a.name + ' [' + a.Id + ']');
            if (completeCCLead(String.valueOf(a.CC_Lead_ID__c))) {
                a.CC_Completed_Date__c = Datetime.now();
                leads.add(a);
            }
        }
        if (!leads.isEmpty()) {
            update leads;
            System.debug('Total leads reported: ' + leads.size());
        }
    }

    // Inner classes
    private class LeadExtraData {
        public String FirstName {set;get;}
        public String LastName {set;get;}
        public String Email {set;get;}
        public String CreatedDate {set;get;}
        public String LoanType {set;get;}
        public String Postcode {set;get;}
        public String State {set;get;}
    }

}