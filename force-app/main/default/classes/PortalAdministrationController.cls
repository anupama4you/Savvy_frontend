public with sharing class PortalAdministrationController
{        
    public Account Dealer
    {
        get
        {
            if (Dealer == null)
            {
                Id accId = [SELECT AccountId
                            FROM User
                            WHERE Id = :UserInfo.getUserId()
                            LIMIT 1].AccountId;
                
                Dealer = [SELECT Id,
                                 Name
                          FROM Account
                          WHERE Id = :accId];
            }
            return Dealer;
        }
        set;        
    }
    
    public String getDealerName()
    {
        return Dealer.Name;
    }
            
    public LeadSummary ThisLeadSummary
    {
        get
        {
            if (ThisLeadSummary == null)
            {
                ThisLeadSummary = new LeadSummary(Dealer.Id);
            }
            return ThisLeadSummary;
        }
        set;
    }
            
    public List<Invoice__c> Invoices
    {
        get
        {
            return [SELECT Id,
                           Date_of_Invoice__c,
                           Invoice_Amount__c
                    FROM Invoice__c                    
                    ORDER BY Date_of_Invoice__c DESC];
        }       
    }
    
    private class LeadSummary
    {
        public LeadSummary(Id accountId)
        {            
            Date thisMonthStart = Date.NewInstance(Date.today().year(), Date.today().month(), 1);
            Date thisMonthEnd = thisMonthStart.addMonths(1);
                               
            LeadsSentThisMonth = 0;
            OpportunitiesSettledThisMonth = 0;
            LeadsSentAllTime = 0;
            OpportunitiesSettledAllTime = 0;
            
            for (AggregateResult ar : [SELECT COUNT(Id)
                                       FROM Lead__c
                                       WHERE CreatedDate >= :thisMonthStart 
                                       AND CreatedDate < :thisMonthEnd])
            {
                LeadsSentThisMonth = Integer.valueOf(ar.get('expr0'));    
            }                  
            
            for (AggregateResult ar : [SELECT COUNT(Id)
                                       FROM Custom_Opportunity__c
                                       WHERE Status__c = 'Settled'
                                       AND Date_Closed_or_Settled__c >= :thisMonthStart 
                                       AND Date_Closed_or_Settled__c < :thisMonthEnd])
            {
                OpportunitiesSettledThisMonth = Integer.valueOf(ar.get('expr0'));    
            } 
            
            for (AggregateResult ar : [SELECT COUNT(Id)
                                       FROM Lead__c])
            {
                LeadsSentAllTime = Integer.valueOf(ar.get('expr0'));    
            }                  
            
            for (AggregateResult ar : [SELECT COUNT(Id)
                                       FROM Custom_Opportunity__c
                                       WHERE Status__c = 'Settled'])
            {
                OpportunitiesSettledAllTime = Integer.valueOf(ar.get('expr0'));    
            }                   
        }
    
        public Integer LeadsSentThisMonth { get; set; }
        public Integer OpportunitiesSettledThisMonth { get; set; }
        public Integer LeadsSentAllTime { get; set; }
        public Integer OpportunitiesSettledAllTime { get; set; }            
    }
}