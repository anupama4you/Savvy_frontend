trigger trgLeadAfterI on Lead__c(after insert) 
{
    // this only runs when a single lead is inserted and it has an email address
    if (Trigger.New.size() == 1 && Trigger.New[0].Email_Address__c != null)
    {
        // get the credit guide document
        Document d = [SELECT Body,
                             Type
                      FROM Document
                      WHERE DeveloperName = 'Credit_Guide'];    
    
        // create the email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // find the email template
        for (EmailTemplate et : [SELECT HtmlValue
                                 FROM EmailTemplate 
                                 WHERE DeveloperName = 'Lead_Welcome_to_Savvy'])
        {
            mail.setHtmlBody(et.HtmlValue.replace('{!Lead__c.Name}', Trigger.New[0].First_Name__c + ' ' + Trigger.New[0].Last_Name__c));
        }
                                               
        mail.setSaveAsActivity(true);
        mail.setToAddresses(new String[] { Trigger.New[0].Email_Address__c });
        
        for (OrgWideEmailAddress o : [SELECT Id
                                      FROM OrgWideEmailAddress 
                                      WHERE DisplayName = 'Savvy'])
        {
            mail.setOrgWideEmailAddressId(o.Id);
        }                                              
                
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setFileName('Savvy Credit Guide.' + d.Type);
        attach.setInline(false);
        attach.Body = d.Body;
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    }
}