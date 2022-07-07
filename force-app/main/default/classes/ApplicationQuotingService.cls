public class ApplicationQuotingService {
    
    public static void authorizationChecker(List<Application_Quoting__c> newList, Map<Id, Application_Quoting__c> oldMap){
        if(oldMap != null){
            for (Application_Quoting__c newAppQuoting : newList) {
                if (!newAppQuoting.Name.equals(oldMap.get(newAppQuoting.Id).Name)) {
                    Custom_Opportunity__c opp = [Select Preapproval_Auth_Date__c From Custom_Opportunity__c Where Id =:newAppQuoting.Opportunity__c];
                    if(opp.Preapproval_Auth_Date__c != null){
                        opp.Preapproval_Auth_Date__c = null;
                        update opp;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Lender has been changed, please submit an Authorised Pre-approval for this deal before proceeding for any other approval process.'));   
                    }
                }
            }
        }
    }
}