public class CallCenterOpportunityNotification {
    
    @InvocableMethod(label='Update call center leads' description='Update and Complete leads into the call center provider')
    public static List<Custom_Opportunity__c> notify(List<Custom_Opportunity__c> opps) {
        System.debug('Call center notification...');
        if (opps != null) {
            for (Custom_Opportunity__c o : opps) {
                // LeadService.completeCCLead(o.Lead__c);
                ipSCAPEService.completeLead(o.Lead__c);
            }
        }
        return opps;
    }

}