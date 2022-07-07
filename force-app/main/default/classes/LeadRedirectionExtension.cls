public with sharing class LeadRedirectionExtension {

	private final Lead__c lead;
    private final Custom_Opportunity__c opp;
    
    public LeadRedirectionExtension(ApexPages.StandardController stdController) {
        this.lead = (Lead__c)stdController.getRecord();
        this.opp = getOpportunity(this.lead.Id);
    }

    public PageReference redirectProcess() {
        PageReference r = null;
        System.debug('Redirecting.... ');
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = PROFILE.get(0).Name;
        String redirectActivation = BusinessParamHelper.getParameter(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE);
        System.debug('profileName >> ' + profileName);
        System.debug('redirectActivation >> ' + redirectActivation);
        if ('Y'.equals(redirectActivation)) {
            String redirectProfiles = BusinessParamHelper.getParameter(BusinessParamHelper.PARAM_LEAD_REDIRECT_PROFILES);
            profileName = '[' + profileName + ']';
            System.debug('profileName >> ' + profileName);
            System.debug('redirectProfiles >> ' + redirectProfiles);
            if (String.isNotBlank(redirectProfiles) && 
                redirectProfiles.containsIgnoreCase(profileName) ) {
                if (opp != null && !AppFlowExtension.OPPSTATUS_BEOPPORTUNITY.equals(opp.Status__c)) {
                    r = new PageReference('/' + this.opp.Id);
                } else {
                    r = new PageReference('/apex/AppFlow');
                    r.getParameters().put('id', this.lead.Id);
                }
            }
        }
        return r;
        //return null;
    }

    private Custom_Opportunity__c getOpportunity(Id leadId) {
        Custom_Opportunity__c r = null;
        List<Custom_Opportunity__c> d = [SELECT Id, Status__c FROM Custom_Opportunity__c WHERE Lead__c = :leadId ORDER BY LastModifiedDate DESC LIMIT 1];
        if (!d.isEmpty()) {
            r = d.get(0);
        }
        return r;
    }
    
}