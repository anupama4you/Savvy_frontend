trigger trgSDocAfterI on SDOC__SDoc__c (after insert) 
{
    Map<Id, SDOC__SDTemplate__c> templates = new Map<Id, SDOC__SDTemplate__c> ([SELECT Id,
                                                                                       Name
                                                                                FROM SDOC__SDTemplate__c]); 
                            
    List<Required_Document__c> newRDs = new List<Required_Document__c>();                        
                                                                                
    for (SDOC__SDoc__c sd : Trigger.New)
    {
        if (templates.get(sd.SDOC__SDTemplate__c).Name == 'Preliminary Assessment'
            || templates.get(sd.SDOC__SDTemplate__c).Name == 'Credit Proposal')
        {
            Required_Document__c rd = new Required_Document__c();
            rd.Name = templates.get(sd.SDOC__SDTemplate__c).Name;
            rd.Type__c = templates.get(sd.SDOC__SDTemplate__c).Name;
            rd.Opportunity__c = sd.SDOC__ObjectID__c;
            rd.SDoc__c = sd.Id;
            
            newRDs.add(rd);
        }
    }    
    
    insert newRDs;                                                                        
}