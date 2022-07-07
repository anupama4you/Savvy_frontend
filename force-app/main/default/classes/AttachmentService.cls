public class AttachmentService {
    public static void uploadToCloud(List<Attachment> newList){
    	Set<Id> parentIds = new Set<Id>();
    	for(Attachment att : newList){
    		parentIds.add(att.ParentId);
    	}
    	
    	if(!parentIds.isEmpty()){
    		Map<Id, Id> parentOpptyMap = new Map<Id, Id>();
    		for(ESL__Package_Document__c pDoc : [Select Id, ESL__Package__r.eSignLive_Opportunity_Lookup__c from ESL__Package_Document__c where Id in : parentIds]){
    			parentOpptyMap.put(pDoc.Id, pDoc.ESL__Package__r.eSignLive_Opportunity_Lookup__c);
    		}
    		Set<Id> attForDel = new Set<Id>();
    		for(Attachment att : newList){
    			System.debug('att.Name:' + att.Name + ':' + parentOpptyMap);
    			if(att.Name.contains('Consent') && att.Name.contains('_esigned') && !parentOpptyMap.isEmpty() && parentOpptyMap.get(att.ParentId) != null){
    				CloudRequiredDocument d = new CloudRequiredDocument('Consent');
    				d.blobFile = att.Body;
    				d.contentType = 'application/pdf';
    				d.docName = att.Name;
    				d.fileName = att.Name;
    				d.oppId = parentOpptyMap.get(att.ParentId);
    				CloudDocsHelper.saveToS3(d);
    				
    			}
    			if(att.Name.contains('EquifaxScore')){
    				CloudRequiredDocument d = new CloudRequiredDocument('Credit File');
    				d.blobFile = att.Body;
    				d.contentType = 'application/pdf';
    				d.docName = att.Name;
    				d.fileName = att.Name;
    				d.oppId = att.ParentId;
    				CloudDocsHelper.saveToS3(d);
    				attForDel.add(att.Id);
    			}
    		}
    		
    		if(!attForDel.isEmpty()){
    			deleteAttachments(attForDel);
    		}
    	}
    }
    
    @future
    public static void deleteAttachments(Set<Id> attIdsForDel){
    	List<Attachment> attForDel = [Select Id from Attachment where Id in :attIdsForDel];
    	if(!attForDel.isEmpty()){
    		delete attForDel;
    	}
    }
    
}