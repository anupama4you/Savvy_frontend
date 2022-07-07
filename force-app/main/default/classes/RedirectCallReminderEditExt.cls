public with sharing class RedirectCallReminderEditExt {
	public String recId {get;set;}
	public String DesiredURL {get;set;}
    public string callfunc{get;set;}
    
    public RedirectCallReminderEditExt(ApexPages.StandardController controller){
    	this.recId = String.valueOf(((Call_Reminder__c)controller.getRecord()).Id);
    	if(recId != null){
    		DesiredURL = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/' + recId + '/e?nooverride=1';
    		callfunc = ' <script> func(); </script>';
    	}
    	
    }
    
    
}