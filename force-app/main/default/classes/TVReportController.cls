public class TVReportController
{
    public Decimal TotalTarget 
    { 
        get
        {
            return (Decimal)Team_Target__c.getInstance().Team_Target__c;            
        }
    }
    public Decimal TotalActual { get; set; }

    public String getTimeNow()
    {
        return Datetime.now().format('dd/MM/yyyy hh:mm:ss a');
    }

    public List<SalesConsultant> getTableData()
    {
        Map<Id, SalesConsultant> td = new Map<Id, SalesConsultant>();
        
        Date startDate = Date.newInstance(Date.today().year(), Date.today().month(), 1);
        Date endDate = startDate.addMonths(1);
        
        // find the user Ids that should be included
        Set<Id> userIds = new Set<Id>();
        for (Group g : [SELECT Id
                        FROM Group
                        WHERE DeveloperName = 'Sales_Consultants' AND Type = 'Regular'
                        LIMIT 1])
        {
            for (GroupMember gm : [SELECT UserOrGroupId
                                   FROM GroupMember
                                   WHERE GroupId = :g.Id])
            {
                userIds.add(gm.UserOrGroupId);
            }                                   
        }                        
                
        TotalActual = 0;
        
        // get the user records
        for (User u : [SELECT Id,
                              Name,
                              Monthly_Commission_Target__c                                                 
                       FROM User                       
                       WHERE Id IN :userIds
                       ORDER BY LastName])
        {
            td.put(u.Id, new SalesConsultant(u));            
        }                               
        
        // find the opportunities settled for the user this month        
        for (Custom_Opportunity__c o : [SELECT Id,
                                        OwnerId,
                                        Name,
                                        Total_Commission__c
                                 FROM Custom_Opportunity__c
                                 WHERE OwnerId IN :td.keySet()
                                 AND Status__c = 'Settled'
                                 AND Date_Closed_or_Settled__c >= :startDate
                                 AND Date_Closed_or_Settled__c < :endDate
                                 ORDER BY Name])
        {
            td.get(o.OwnerId).Opportunities.add(o);
            td.get(o.OwnerId).Sum += (o.Total_Commission__c) != null ? o.Total_Commission__c : 0;
            TotalActual += o.Total_Commission__c;
        }                
        
        return td.values();
    }    

    private class SalesConsultant
    {
        public SalesConsultant(User c)
        {
            Consultant = c;
            Opportunities = new List<Custom_Opportunity__c>();
            Sum = 0;
        }
    
        public User Consultant { get; set; }
        public List<Custom_Opportunity__c> Opportunities { get; set; }            
        public Decimal Sum { get; set; }
    }
}