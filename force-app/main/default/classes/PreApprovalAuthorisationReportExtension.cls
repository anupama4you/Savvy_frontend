public with sharing class PreApprovalAuthorisationReportExtension {

    public static final string RPT_TYPE_DETAILED = 'DETAILED';

    public Boolean authorised {set;get;}
    public Boolean showMessage {set;get;}
    public Datetime startDate {set;get;}
    public Datetime endDate {set;get;}
    public Map<String, List<AggregateResult>> data {set;get;}
    public Map<String, List<AggregateResult>> approvalData {set;get;}
    
    public PreApprovalAuthorisationReportExtension() {
        this.init();
    }

    private void init() {
        this.data = new Map<String, List<AggregateResult>>();
        this.authorised = PreApprovalAuthorisationHelper.isAuthoriser();
        if (!this.authorised) {
            return;
        }
        
        // Initialising dates
        this.startDate = Datetime.now();
        this.endDate = Datetime.now();
        this.loadData();
    }

    private void loadData() {
        List<AggregateResult> results = [
            Select Status__c, count(Id) records, sum(Total_Brokerage__c) totalBrokerage, sum(Total_DOF__c) totalDof, 
                sum(Total_Insurance_Commission__c) totalInsurance, sum(Total_Commission__c) totalComm, 
                sum(NAF_Net_Amount_Financed__c) totalNAF
            From Custom_Opportunity__c
            Where Status__c in (
                'Pre-approval Authorisation Submitted','Pre-approval Authorisation Approved',
                'Pre-approval Authorisation Declined','Pre-approval Authorisation Recalled')
            OR (
                Preapproval_Auth_Date__c != null 
                    AND (
                        (NOT (Status__c In ('Closed Opportunity','Unresolved Opportunity','Settled','Settlement Rejected','Declined'))) OR
                        (Status__c = 'Settled' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30) OR
                        (Status__c = 'Settlement Rejected' AND LastModifiedDate = LAST_N_DAYS:30) OR
                        (Status__c = 'Declined' AND LastModifiedDate = LAST_N_DAYS:30)
                    )
                )
            Group By Status__c Order By Status__c
        ];
        for (AggregateResult a: results) {
            String section = PreApprovalAuthorisationHelper.getSection((String)a.get('Status__c'));
            List<AggregateResult> lst = this.data.get(section);
            if (lst == null) {
                lst = new List<AggregateResult>();
                this.data.put(section, lst);
            }
            lst.add(a);
        }
        this.approvalData = new Map<String, List<AggregateResult>>();
        this.approvalData.put('Settlement', getProcessesData(PreApprovalAuthorisationHelper.SETTLEMENT_SECTION));
        this.approvalData.put('Formal Approval', getProcessesData(PreApprovalAuthorisationHelper.FORMALAPPROVAL_SECTION));
        this.approvalData.put('Amendments', getProcessesData(PreApprovalAuthorisationHelper.AMENDMENT_SECTION));
        this.approvalData.put('Pre-Approval', getProcessesData(PreApprovalAuthorisationHelper.PREAPPROVAL_SECTION));
        
    }

    public void refresh() {
        this.init();
        this.showMessage = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Data refreshed successfully.'));
    }

    public void hideMessages() {
        System.debug('Hidding messages...');
        this.showMessage = false;
    }
    
    public List<AggregateResult> getAuthorisationData() {
        return this.getProcessesData(PreApprovalAuthorisationHelper.AUTHORISATION_SECTION);
    }

    public List<AggregateResult> getOtherProcessesData() {
        return this.getProcessesData(PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION);
    }

    private List<AggregateResult> getProcessesData(String process) {
        List<AggregateResult> r = this.data.get(process);
        if (r == null) {
            r = new List<AggregateResult>();
        }
        return r;
    }

    public Set<String> getApprovalDataKeys() {
        return this.approvalData.keySet();
    }

}