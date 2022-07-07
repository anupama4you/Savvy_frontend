public with sharing class PreApprovalAuthorisationReport2Extension {

    public static final string RPT_TYPE_DETAILED = 'DETAILED';

    public Boolean authorised {set;get;}
    public Boolean showMessage {set;get;}
    public Datetime startDate {set;get;}
    public Datetime endDate {set;get;}
    public Map<String, List<Custom_Opportunity__c>> detailedData {set;get;}
    public Map<String, Set<String>> sectionStatuses {set;get;}
    public Id oppIdSel {set;get;}

    public Boolean runFullReport {set;get;}

    public PreApprovalAuthorisationReport2Extension() {
        this.init();
    }

    private void init() {
        this.authorised = PreApprovalAuthorisationHelper.isAuthoriser();
        if (!this.authorised) {
            return;
        }
        
        // Initialising dates
        this.startDate = Datetime.now();
        this.endDate = Datetime.now();
        this.loadDetailData();
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
    
    // Detailed report
    public void loadDetailData() {
        this.detailedData = new Map<String, List<Custom_Opportunity__c>>();
        Set<String> excludedStatuses = PreApprovalAuthorisationHelper.excludedStatuses();
        List<Custom_Opportunity__c> d = [
            Select Name, Status__c, Id, Total_Brokerage__c, Owner_Name__c, LastModifiedDate,  
                Total_Commission__c, NAF_Net_Amount_Financed__c, Loan_Product__c, Loan_Product__r.Lender__c
            From Custom_Opportunity__c
            Where Status__c in (
                'Pre-approval Authorisation Submitted','Pre-approval Authorisation Approved',
                'Pre-approval Authorisation Declined','Pre-approval Authorisation Recalled')
            OR (
                Preapproval_Auth_Date__c != null 
                    AND (
                        (NOT (Status__c In :excludedStatuses)) OR
                        (Status__c = 'Settled' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30) OR
                        (Status__c = 'Settlement Rejected' AND LastModifiedDate = LAST_N_DAYS:30) OR
                        (Status__c = 'Declined' AND LastModifiedDate = LAST_N_DAYS:30)
                    )
                )
            Order By Status__c, Name, Owner_Name__c
        ];
        Set<String> otherStatuses = new Set<String>();
        for (Custom_Opportunity__c o: d) {
            List<Custom_Opportunity__c> t = this.detailedData.get(o.Status__c);
            if (t == null) {
                t = new List<Custom_Opportunity__c>();
                this.detailedData.put(o.Status__c, t);
                String sec = PreApprovalAuthorisationHelper.getSection(o.Status__c);
                if (PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION.equals(sec)) {
                    otherStatuses.add(o.Status__c);
                }
            }
            t.add(o);
        }
        this.sectionStatuses = new Map<String, Set<String>>();
        for (String k: this.getSections()) {
            this.sectionStatuses.put(k, PreApprovalAuthorisationHelper.getSectionStatuses(k));
        }
        if (!otherStatuses.isEmpty()) {
            this.sectionStatuses.put(PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION, otherStatuses);
        }
        // Creating empty lists for statuses without any opportunity
        for (String k: this.sectionStatuses.keySet()) {
            for (String s: this.sectionStatuses.get(k)) {
                if (!this.detailedData.containsKey(s)) {
                    this.detailedData.put(s, new List<Custom_Opportunity__c>());
                }
            }
        }
    }

    public Set<String> getDetailedDataKeys() {
        return this.detailedData.keySet();
    }

    public List<String> getSections() {
        return new List<String>{
            PreApprovalAuthorisationHelper.AUTHORISATION_SECTION,
            PreApprovalAuthorisationHelper.PREAPPROVAL_SECTION,
            PreApprovalAuthorisationHelper.AMENDMENT_SECTION,
            PreApprovalAuthorisationHelper.FORMALAPPROVAL_SECTION,
            PreApprovalAuthorisationHelper.SETTLEMENT_SECTION,
            PreApprovalAuthorisationHelper.OTHERPROCESSES_SECTION
        };
    }

    public Pagereference openApproval() {
        System.debug('Opp selected: ' + this.oppIdSel);
        if (this.oppIdSel != null) {
            List<ProcessInstanceWorkItem> workItemList = [
                Select p.Id,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :this.oppIdSel
            ];
            if (!workItemList.isEmpty()) {
                return new PageReference(
                    '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemList.get(0).Id);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The selected opportunity does not have any active approval process.'));
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is not any opportunity selected.'));
        }
        this.showMessage = true;
        return null;
    }

    public void runFullReportAction() {
        this.runFullReport = true;
    }

}