public with sharing class PreApprovalAuthorisationListExtension {

    public List<Custom_Opportunity__c> data {set;get;}
    public Boolean authorised {set;get;}
    public Boolean showMessage {set;get;}
    public Id oppIdSel {set;get;}

    public PreApprovalAuthorisationListExtension() {
        this.init();
    }

    private void init() {
        this.authorised = PreApprovalAuthorisationHelper.isAuthoriser();
        if (!this.authorised) {
            this.data = new List<Custom_Opportunity__c>();
            return;
        }
        this.data = [
            Select Id, Name, Mobile_Number__c, Lead_Loan_Type__c, NAF_Net_Amount_Financed__c, 
                   Total_Brokerage__c, Total_Commission__c, Total_DOF__c, Total_Insurance_Commission__c,
                   Owner_Name__c, LastModifiedDate
            From Custom_Opportunity__c
            Where Status__c = 'Pre-approval Authorisation Submitted'
            Order By LastModifiedDate
        ];
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

    public void refresh() {
        this.init();
        this.showMessage = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Data refreshed successfully.'));
    }

    public void hideMessages() {
        System.debug('Hidding messages...');
        this.showMessage = false;
    }
}