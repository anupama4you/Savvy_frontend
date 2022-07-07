public without sharing class OpenNextOppController {   

    public Lead__c leadSel {get;set;}

    public PageReference NextLeadURL() {
        List<Lead__c> d = [SELECT Id, Name, Loan_Type__c, Finance_Amount__c, Credit_History__c,
                                 OwnerId, account__r.createddate
                          FROM Lead__c
                          WHERE Owner.Name = 'System Generated'
                          AND (Bucket_Type__c = 'Home Loan')
                          AND Status__c = 'New Lead'
                          ORDER BY CreatedDate ASC
                          LIMIT 1];
        for (Lead__c l : d) {
            this.leadSel = l;
        }
        if (this.leadSel != null) {
          leadSel.OwnerId = UserInfo.getUserId();
          update leadSel;
        }
        return null;
    }

    public PageReference ReturnHome() {
        return new PageReference('/');
    }

    public Boolean getHasLeadSelected() {
        if (this.leadSel != null) {
            return true;
        }
        return false;
    }

}