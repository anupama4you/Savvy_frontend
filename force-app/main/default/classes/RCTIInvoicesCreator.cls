public class RCTIInvoicesCreator
{
    public static void Create()
    {
        // find the RCTI record type
        Id rctiRT = [SELECT Id
                     FROM RecordType
                     WHERE sObjectType = 'Invoice__c'
                     AND Name = 'RCTI'].Id;
    
        // find the start and end dates for last month
        Date oneMonthAgo = Date.today().addMonths(-1);
        Date lastMonthStart = Date.NewInstance(oneMonthAgo.year(), oneMonthAgo.month(), 1);
        Date lastMonthEnd = lastMonthStart.addMonths(1);
    
        List<Invoice__c> invoices = new List<Invoice__c>();
    
        // find the opportunities settled last month
        for (Custom_Opportunity__c o : [SELECT Id,
                                        Lead_Consultant_Dealer__c,
                                        Lead_Consultant_Dealer__r.Commission_Amount__c,
                                        Lead_Consultant_Dealer__r.Commission_Percentage__c,
                                        Finance_Amount__c
                                 FROM Custom_Opportunity__c
                                 WHERE Status__c = 'Settled'
                                 AND Lead__r.Lead_Consultant__c != null
                                 AND Date_Closed_or_Settled__c >= :lastMonthStart
                                 AND Date_Closed_or_Settled__c < :lastMonthEnd])
        {
            Invoice__c inv = new Invoice__c();
            inv.RecordTypeId = rctiRT;
            inv.Account__c = o.Lead_Consultant_Dealer__c;
            inv.Opportunity__c = o.Id;
            inv.Date_of_Invoice__c = Date.today();            
            
            invoices.add(inv);
        }   
        
        insert invoices;                              
    }
}