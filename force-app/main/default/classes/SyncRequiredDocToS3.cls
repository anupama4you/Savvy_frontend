global class SyncRequiredDocToS3 implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	
	global Database.QueryLocator start( Database.BatchableContext bc ){         
        return DataBase.getQueryLocator([Select Id, Name, Opportunity__c, Opportunity_Name__c, Attachment_Id__c, Type__c, Uploaded_To_S3__c From Required_Document__c where Uploaded_To_S3__c = false and Attachment_Id__c != null]);
    } 
    
    global void execute( Database.BatchableContext bc, List<Required_Document__c> scope ){}
        
    global void finish( Database.BatchableContext bc ){}
}