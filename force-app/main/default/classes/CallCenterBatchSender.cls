global with sharing class CallCenterBatchSender implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global final Id leadId;
    global final List<Id> leads;

    public CallCenterBatchSender(Id LeadId) {
        System.debug('CallCenterBatchSender... created! -> ' + leadId);
        this.leads = new List<Id>{ leadId };
        // this.leadId = leadId;
    }

    public CallCenterBatchSender(List<Id> Leads) {
        System.debug('CallCenterBatchSender... created! -> ' + leads.size());
        this.leads = leads;
    }

    global Database.QueryLocator start (Database.BatchableContext bc) {
        System.debug('CallCenterBatchSender... start!');
        String query = 'Select Id, Name, First_Name__c, Last_Name__c, Mobile_Number__c, ' + 
                       '       Email_Address__c, Status__c, Postcode__c, State__c, Loan_Type__c, ' + 
                       '       Loan_For__c, Credit_History__c, Finance_Amount__c, Employment_Status__c, '+
                       '       Bucket_Type__c, CreatedDate, CC_Campaign_ID__c, CC_List_ID__c,  ' + 
                       '       CC_Lead_ID__c, CC_Sent_Date__c ' +
                       'From Lead__c Where Id in :leads';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead__c> scope) {
        System.debug('CallCenterBatchSender... executing job... ' + BC.getJobId());
        for (Lead__c a : scope) {
            System.debug('Sending to Call Center... ' + a.Name + ' | ' + a.Bucket_Type__c);
            Integer ccLeadId = ipSCAPEService.sendLead(a);
            // ipSCAPEService.ping();
            // Integer ccLeadId = -1;
            if (ccLeadId != null) {
                // a.Is_Call_Center__c = true;
            }
            a.CC_Lead_ID__c = ccLeadId;
            a.CC_Sent_Date__c = Datetime.now();
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('CallCenterBatchSender... finished!');
    }

}