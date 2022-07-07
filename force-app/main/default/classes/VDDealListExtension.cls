public class VDDealListExtension {

    public List<Custom_Opportunity__c> VDTasks {get;set;}
    Public Id currentUser {get;set;}
    
    public VDDealListExtension ( ) {
        currentUser = UserInfo.getUserId();
        VDTasks = [SELECT id,Name,VD_Owner__c,VD_Status__c,VD_Notes__c,Status__c FROM Custom_Opportunity__c 
        		   WHERE VD_Owner__c =: currentUser 
        		   AND Status__c not in ('Settled','Closed Opportunity','Internal Settlement')
				   AND VD_Status__c not in ('Send back to Sales Consultant')
        		   AND VD_Is_Old_Process__c = true];
    }
}