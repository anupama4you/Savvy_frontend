trigger trgInvoiceAfterI on Invoice__c (after insert) 
{
    /*List<Id> i = new List<Id>();
    i.add(Trigger.New[1].Id);
    SaasuInterface.SendInvoices(i);*/
        
        //SaasuInterface.SendInvoices(new List<Id>(Trigger.NewMap.keySet()));
    if (Trigger.isInsert){
        
    }
}