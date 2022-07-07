public class SendScheduledEmails
{
    public static void Send()
    {
        
        EmailTemplate x3mths;
        EmailTemplate x1yr;
        EmailTemplate x2yrs;
        EmailTemplate x3yrs;
        EmailTemplate x4yrs;
        EmailTemplate x3mthsFromEnd;
    
        for (EmailTemplate et : [SELECT Id,
                                        DeveloperName,
                                        HtmlValue,
                                        Subject
                                 FROM EmailTemplate])
        {
            if (et.DeveloperName == 'Opp_3_mths_post_Settlement') { x3mths = et; }
            else if (et.DeveloperName == 'Opp_1_year_post_settlement') { x1yr = et; }
            else if (et.DeveloperName == 'Opp_2_years_post_Settlement') { x2yrs = et; }
            else if (et.DeveloperName == 'Opp_3_years_post_Settlement') { x3yrs = et; }
            else if (et.DeveloperName == 'Opp_4_years_post_Settlement') { x4yrs = et; }
            else if (et.DeveloperName == 'Opp_3_mths_before_Loan_ends') { x3mthsFromEnd = et; }
        }                                 
    
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
    
        // find opportunities that were settled
        Date d3mths = Date.today().addMonths(-3);
        Date d1yr = Date.today().addYears(-1);
        Date d2yrs = Date.today().addYears(-2);
        Date d3yrs = Date.today().addYears(-3);
        Date d4yrs = Date.today().addYears(-4);  
        Date d3mthsTime = Date.today().addMonths(3);        
		// find the users
        Set<Id> userIds = new Set<Id>();
        
    	for (Custom_Opportunity__c o : [SELECT Id, Name,
                                        OwnerId                                        
                                 FROM Custom_Opportunity__c                                 
                                 WHERE Status__c = 'Settled'
                                 AND Email_Address__c != null
                                 AND (Date_Settled__c = :d3mths
                                      OR Date_Settled__c = :d1yr
                                      OR Date_Settled__c = :d2yrs
                                      OR Date_Settled__c = :d3yrs
                                      OR Date_Settled__c = :d4yrs
                                      OR End_of_Loan_Date__c = :d3mthsTime)])
        {
        	userIds.add(o.OwnerId);
        }
        Map<Id, User> users = new Map<Id, User> ([SELECT Id,
                                                         Name
                                                  FROM User where id in: userIds]);
        for (Custom_Opportunity__c o : [SELECT Name,
                                        OwnerId,
                                        Email_Address__c,
                                        Status__c,
                                        Date_Settled__c,
                                        End_of_Loan_Date__c                                        
                                 FROM Custom_Opportunity__c                                 
                                 WHERE Status__c = 'Settled'
                                 AND Email_Address__c != null
                                 AND (Date_Settled__c = :d3mths
                                      OR Date_Settled__c = :d1yr
                                      OR Date_Settled__c = :d2yrs
                                      OR Date_Settled__c = :d3yrs
                                      OR Date_Settled__c = :d4yrs
                                      OR End_of_Loan_Date__c = :d3mthsTime)])
        {system.debug('debug1:' + o);
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            String htmlBody;
            
            if (o.Date_Settled__c <= d3mths 
                && o.Date_Settled__c.addDays(1) > d3mths
                && o.End_of_Loan_Date__c > Date.today())
            {
                msg.setSubject(x3mths.Subject);
                htmlBody = x3mths.HtmlValue;                
            }
            else if (o.Date_Settled__c <= d1yr 
                     && o.Date_Settled__c.addDays(1) > d1yr 
                     && o.End_of_Loan_Date__c > Date.today())
            {
                msg.setSubject(x1yr.Subject);
                htmlBody = x1yr.HtmlValue;                
            }
            else if (o.Date_Settled__c <= d2yrs 
                     && o.Date_Settled__c.addDays(1) > d2yrs 
                     && o.End_of_Loan_Date__c > Date.today())
            {
                msg.setSubject(x2yrs.Subject);
                htmlBody = x2yrs.HtmlValue;                 
            }
            else if (o.Date_Settled__c <= d3yrs 
                     && o.Date_Settled__c.addDays(1) > d3yrs 
                     && o.End_of_Loan_Date__c > Date.today())
            {
                msg.setSubject(x3yrs.Subject);
                htmlBody = x3yrs.HtmlValue;                 
            }
            else if (o.Date_Settled__c <= d4yrs 
                     && o.Date_Settled__c.addDays(1) > d4yrs 
                     && o.End_of_Loan_Date__c > Date.today())
            {
                msg.setSubject(x4yrs.Subject);
                htmlBody = x4yrs.HtmlValue;                 
            }
            else if (o.End_of_Loan_Date__c <= d3mthsTime
                     && o.End_of_Loan_Date__c.addDays(1) > d3mthsTime)
            {
                msg.setSubject(x3mthsFromEnd.Subject);
                htmlBody = x3mthsFromEnd.HtmlValue;                  
            }
                                    
            if (htmlBody != null)
            {
                msg.setSaveAsActivity(true);                
                msg.setToAddresses(new String[] { o.Email_Address__c });
                msg.setSenderDisplayName('Savvy Finance & Insurance');
                msg.setReplyTo('noreply@savvy.com.au'); 
                String ownerName;
                if(users.get(o.OwnerId) == null){
                	ownerName = '';
                } else {
                	ownerName = users.get(o.OwnerId).Name;
                }
                 
                msg.setHtmlBody(htmlBody.replace('{!Custom_Opportunity__c.Name}', o.Name).replace('{!Custom_Opportunity__c.OwnerFullName}', ownerName));                                                          
                msgs.add(msg);
            }
        }                                  
                
        Messaging.sendEmail(msgs);                
    }
}