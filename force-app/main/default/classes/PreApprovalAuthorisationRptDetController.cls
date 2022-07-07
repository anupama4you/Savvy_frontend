public with sharing class PreApprovalAuthorisationRptDetController {
    
    public Boolean authorised {set;get;}
    public Boolean showMessage {set;get;}
    public Id oppIdSel {set;get;}
    public String status {set;get;}
    public String section {set;get;}
    public List<Custom_Opportunity__c> data {set;get;}

    // Filter params
    public FilterParams params {set;get;}
    private Map<String, Set<String>> filterOptions = new Map<String, Set<String>>();

    public PreApprovalAuthorisationRptDetController() {
        this.init();
    }

    private void init() {
        this.params = new FilterParams();
        this.filterOptions.put('owner', new Set<String>());
        this.filterOptions.put('lender', new Set<String>());
        this.filterOptions.put('loan_type', new Set<String>());

        this.authorised = PreApprovalAuthorisationHelper.isAuthoriser();
        if (String.isBlank(this.section)) {
            this.section = System.currentPageReference().getParameters().get('SECTION');
        }
        if (String.isBlank(this.status)) {
            this.status = System.currentPageReference().getParameters().get('STATUS');
        }
        this.search();
    }

    public void refresh() {
        this.init();
        this.showMessage = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Data refreshed successfully.'));
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

    public Pagereference backToPipeline() {
        return Page.PreApprovalAuthorisationPipelineReport;
    }

    public void search() {
        Set<String> statusList = null;
        if (String.isNotBlank(this.status)) {
            statusList = new Set<String> { this.status };
        } else {
            statusList = PreApprovalAuthorisationHelper.getSectionStatuses(this.section);
        }

        String sql = 'Select Id, Name, Status__c, Mobile_Number__c, Lead_Loan_Type__c, NAF_Net_Amount_Financed__c, ' +
                     '       Total_Brokerage__c, Total_Commission__c, Total_DOF__c, Total_Insurance_Commission__c, ' +
                     '       Owner_Name__c, LastModifiedDate, Loan_Product__c, Loan_Product__r.Lender__c ' + 
                     '       From Custom_Opportunity__c Where Status__c in :statusList ';
        if (!PreApprovalAuthorisationHelper.AUTHORISATION_SECTION.equals(this.section)) {
            sql += 'And (Preapproval_Auth_Date__c != null) ';
            if ('Settled'.equals(this.status)) {
                sql += 'AND (Date_Closed_or_Settled__c = LAST_N_DAYS:30) ';
            } else if ('Settlement Rejected'.equals(this.status) || 'Declined'.equals(this.status)) {
                sql += 'AND (LastModifiedDate = LAST_N_DAYS:30) ';
            }
        }
        // Filtering
        String ownerSel = this.params.ownership;
        String lenderSel = this.params.lender;
        String loanTypeSel = this.params.loanType;
        if (String.isNotBlank(ownerSel)) {
            sql += 'And (Owner_Name__c = :ownerSel) ';
        }
        if (String.isNotBlank(lenderSel)) {
            sql += 'And (Loan_Product__r.Lender__c = :lenderSel) ';
        }
        if (String.isNotBlank(loanTypeSel)) {
            sql += 'And (Lead_Loan_Type__c = :loanTypeSel) ';
        }
        sql += 'Order By Status__c, Name';
        // querying...
        this.data = Database.query(sql);
        // filling filter options...
        for (Custom_Opportunity__c o: this.data) {
            this.filterOptions.get('owner').add(o.Owner_Name__c);
            if (o.Loan_Product__c != null && String.isNotBlank(o.Loan_Product__r.Lender__c)) {
                this.filterOptions.get('lender').add(o.Loan_Product__r.Lender__c);
            }
            if (String.isNotBlank(o.Lead_Loan_Type__c)) {
                this.filterOptions.get('loan_type').add(o.Lead_Loan_Type__c);
            }
        }
        // sorting...
        // for (String k: this.filterOptions.keySet()) {
        //     Set<String> t = this.filterOptions.get(k);
        //     t.sort();
        // }
        if (this.data.isEmpty()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'There is not any opportunity to display.'));
            this.showMessage = true;
        }
    }

    public List<SelectOption> getOwnerOptions() {
        return this.getOptions('owner');
    }

    public List<SelectOption> getLenderOptions() {
        return this.getOptions('lender');
    }

    public List<SelectOption> getLoanTypeOptions() {
        return this.getOptions('loan_type');
    }

    public List<SelectOption> getOptions(String opt) {
        List<SelectOption> r = new List<SelectOption>();
        List<String> d = new List<String>(this.filterOptions.get(opt));
        d.sort();
        for (String v: d) {
            r.add(new SelectOption(v, v));
        }
        return r;
    }

    public void hideMessages() {
        System.debug('Hidding messages...');
        this.showMessage = false;
    }

    public class FilterParams {
        public String ownership {set;get;}
        public String lender {set;get;}
        public String loanType {set;get;}
    }
}