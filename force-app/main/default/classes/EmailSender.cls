public class EmailSender {

    public static void sendEmailToVDSet (List<Attachment> workSheets, User VDOwner, Custom_Opportunity__c VDOpp) {
        String [] toAddresses = new List <String> ();
        toAddresses.add(VDOwner.Email);
        sendEmailToVDSet(workSheets, toAddresses, VDOpp);
    }

    //Lelo              2016-11-09
    public static void sendEmailToVDSet (List<Attachment> workSheets, List<String> toAddresses, Custom_Opportunity__c VDOpp) {
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Create Email attachment
        List<Messaging.EmailFileAttachment> emailAttachList = new List<Messaging.EmailFileAttachment> ();
        for (Attachment worksheet : worksheets) {
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setFileName(worksheet.Name);
            emailAttach.setBody(worksheet.Body);
            emailAttach.setContentType(worksheet.ContentType);
            emailAttach.setInline(false);
            emailAttachList.add(emailAttach);
        }
        /*for (Attachment driverLicense : driverLicenses) {
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setFileName(driverLicense.Name);
            emailAttach.setBody(driverLicense.Body);
            emailAttach.setContentType(driverLicense.ContentType);
            emailAttach.setInline(false);
            emailAttachList.add(emailAttach);
        }*/

        EmailTemplate emailTmpl = getEmailTemplate('VD_Sent_to_VD_Settlement');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id);

        
        //String subject = 'The client ' + VDOpp.Name + ' has been sent to Vehicles Direct Settlement';
        //String emailBody = '<html> <head> </head>';
        //emailBody += '<body style=" color: #232323;font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        //emailBody += 'Hi there, ';
        //emailBody += '<p>The Vehicles Direct Sales have done their job and send the Opportunity to you.</p>';
        ////emailBody += '<p>Please go to https://cs6.salesforce.com/' + VDOpp.Id + ' to start your work.';
        //emailBody += '<p>Please go to https://ap1.salesforce.com/' + VDOpp.Id + ' to start your work.</p>';
        //emailBody += '<p>Regards,</p>';
        //emailBody += '</body></html>';
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        email.setFileAttachments(emailAttachList);
        // send the Email
        // Lelo 								2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
    }
    public static void sendEmailToOppOwner (List<Attachment> invoices, Custom_Opportunity__c VDOpp) {
        // Send email to notify the Sales Consultant with attachment of generated Internal Invoice
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Create Email attachment
        List<Messaging.EmailFileAttachment> emailAttachList = new List<Messaging.EmailFileAttachment> ();
        if (invoices != null) {
            for (Attachment invoice : invoices) {
                Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
                emailAttach.setFileName(invoice.Name);
                emailAttach.setBody(invoice.Body);
                emailAttach.setContentType(invoice.ContentType);
                emailAttach.setInline(false);
                emailAttachList.add(emailAttach);
            }
        }
        //Opp Id
        email.setWhatId(VDOpp.Id);
        String [] toAddresses = new List <String> ();
        toAddresses.add(VDOpp.Owner_Email__c);
        String subject = 'The client ' + VDOpp.Name + ' has been sent back from Vehicles Direct';
        String emailBody = '<html> <head> </head>';
        emailBody += '<body style=" color: #232323;font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        emailBody += 'Hi there, ';
        emailBody += '<p>The Vehicles Direct team have done their job and send the Opportunity back to you.</p>';
        //emailBody += '<p>The internal tax invoice has been attached to this email.</p>';
        emailBody += '<p>The internal tax invoice has been include into the Cloud Documents.</p>';
        //emailBody += '<p>Please go to https://cs6.salesforce.com/' + VDOpp.Id + ' to start your work.';
        emailBody += '<p>Please go to https://ap1.salesforce.com/' + VDOpp.Id + ' to start your work.</p>';
        emailBody += '<p>Regards,</p>';
        emailBody += '</body></html>';
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        email.setFileAttachments(emailAttachList);
        // send the Email
        // Lelo 								2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        System.debug('The sending email for Opp Owner result is: ' + r);
        System.debug('The email addresses to be sent are: ' + toAddresses);
    }

    public static void sendEmailVDFailure (Custom_Opportunity__c VDOpp) {
        sendEmailVDFailure(VDOpp, VDOpp.VD_Reason_for_closure__c);
    }

    public static void sendEmailVDFailure (Custom_Opportunity__c VDOpp, String reasonClosure) {
        // Send email to notify the Sales Consultant about the failure of deal
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        System.debug(VDOpp.Name + '|' + VDOpp.Owner_Email__c + '|' + reasonClosure);

        EmailTemplate emailTmpl = getEmailTemplate('VD_Consultant_Notification_Decline');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id)
                            .replace('PARAM_REASON', reasonClosure);

        String [] toAddresses = new List <String> ();
        toAddresses.add(VDOpp.Owner_Email__c);
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo 								2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
    }
    
    public static void sendEmailToPreVD (Custom_Opportunity__c VDOpp, User previousVD) {
        sendEmailToPreVD(VDOpp, new String[] {previousVD.Email});
    }
    public static void sendEmailToPreVD (Custom_Opportunity__c VDOpp, String [] toAddresses) {
        // Send email to notify the previous VD Owner with attachment of generated invoice
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        /* 
        // Create Email attachment
        List<Messaging.EmailFileAttachment> emailAttachList = new List<Messaging.EmailFileAttachment> ();
        for (Attachment invoice : invoices) {
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setFileName(invoice.Name);
            emailAttach.setBody(invoice.Body);
            emailAttach.setContentType(invoice.ContentType);
            emailAttach.setInline(false);
            emailAttachList.add(emailAttach);
        }
        */
        
        EmailTemplate emailTmpl = getEmailTemplate('VD_Sent_Back_to_Consultant');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id);

        /*String [] toAddresses = new List <String> ();
        toAddresses.add(emailAddress);*/
        /*String subject = 'The deal named ' + VDOpp.Name + ' has been sent back to Asset Finance';
        String emailBody = '<html> <head> </head>';
        emailBody += '<body style=" color: #232323;font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        emailBody += 'Hi there, ';
        emailBody += '<p>The Vehicles Direct Settlement team have done their job and sending the Opportunity back to Sales Consultant.</p>';
        //emailBody += '<p>The invoice has been attached to this email so you can have a look at it.</p>';
        //emailBody += '<p>Please go to https://cs6.salesforce.com/' + VDOpp.Id + ' to start your work.';
        emailBody += '<p>If you would like to have a review about this deal, please go to https://ap1.salesforce.com/' + VDOpp.Id + '</p>';
        emailBody += '<p>Regards,</p>';
        emailBody += '</body></html>';*/
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        //email.setFileAttachments(emailAttachList);
        // send the Email
        // Lelo 								2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        //System.debug('The sending email result is: ' + r);
    }
    
    public static void sendEmailAppAccNoOpp (Application__c app) {
        // Send Email to the Account Owner of the Account that received Application but no Opportunity to match the App
        Account acc = [Select Id,Name,Owner_Email__c From Account Where Id =: app.Account__c];
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String [] toAddresses = new List <String> ();
        toAddresses.add(acc.Owner_Email__c);
        String subject = 'The Application named ' + app.Name + ' has been attached to Account named ' + acc.Name + ' without Opportunity matched';
        String emailBody = '<html> <head> </head>';
        emailBody += '<body style=" color: #232323; font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        emailBody += 'Hi there, ';
        emailBody += '<p>The newly come Application with the name ' + app.Name + ' has been attached to the Account with the name ' + acc.Name + '.</p>';
        emailBody += '<p>However, the Application did not match an Opportunity because </p>';
        emailBody += '<p>1. there is no Opportunity or Lead related to this Account or </p>';
        emailBody += '<p>2. The Opportunity has a different email address from the Account</p>';
        emailBody += '<p>Please have a check for this Account. If there is a related Oppportunity, please manually attach this Application to it.</p>';
        emailBody += '<p>Please go to https://ap1.salesforce.com/' + app.Id + ' for the application and https://ap1.salesforce.com/' + acc.Id + ' for the account.</p>';
        emailBody += '<p>Regards,</p>';
        emailBody += '</body></html>';
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo 								2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        System.debug('The sending email result is: ' + r);
    }
    
    public static void sendEmailAppOppNoAcc (List <Application__c> apps) {
      String [] toAddresses = new List <String> ();
      User su = SOQLSingletonQueries.recs().sysAdminUser;
      if (su != null) {
        toAddresses.add(su.Email);
      }
      // List <User> admins = SOQLSingletonQueries.recs().adminOrDirectTLUsers;//[SELECT Id,Name,Profile.Name,Email FROM User WHERE Profile.Name = 'System Admin' or Profile.Name = 'Direct Team Leader'];
      for (Application__c app: apps) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String subject = 'The Application named ' + app.Name + ' does not have a match with Account but a match with Opportunity';
        String emailBody = '<html> <head> </head>';
        emailBody += '<body style=" color: #232323;font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        emailBody += 'Hi there, ';
        emailBody += '<p>The newly come Application with the name ' + app.Name + ' does not have a match with Account but a match with Opportunity.</p>';
        emailBody += '<p>What you as a System Admin need to do: </p>';
        emailBody += '<p>1. There is propably a new lead created according to the Application. Please delete it.</p>';
        emailBody += '<p>2. Search the Opportunity with the email address of this Application, and manually attach this Application to the Opportunity.</p>';
        emailBody += '<p>As the application Id has not been generated when this email is sent, please use the global search on Salesforce header to get the details of this Application. Sorry for the inconvenience.</p>';
        emailBody += '<p>Regards,</p>';
        emailBody += '</body></html>';
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        System.debug('The sending email result is: ' + r);
      }
    }

    //Lelo          2016-11-09
    public static void sendEmailToVDSent_v2 (List<Attachment> workSheets, List<String> toAddresses, Custom_Opportunity__c VDOpp) {
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Create Email attachment
        List<Messaging.EmailFileAttachment> emailAttachList = new List<Messaging.EmailFileAttachment> ();
        for (Attachment worksheet : worksheets) {
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setFileName(worksheet.Name);
            emailAttach.setBody(worksheet.Body);
            emailAttach.setContentType(worksheet.ContentType);
            emailAttach.setInline(false);
            emailAttachList.add(emailAttach);
        }
        
        EmailTemplate emailTmpl = getEmailTemplate('VD_Sent');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id);
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        email.setFileAttachments(emailAttachList);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }

    public static void sendEmailToConsultantVDStatus (Custom_Opportunity__c VDOpp, String [] toAddresses, String newStatus, String profileName) {
        // Send email to notify the Consultant about new VD status
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTmpl = getEmailTemplate('VD_Consultant_Notification');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id)
                            .replace('{PARAM_VD_PROFILE}', profileName)
                            .replace('{PARAM_NEW_VDSTATUS}', newStatus);
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        System.debug('The sending email result is: ' + r);
    }

    private static EmailTemplate getEmailTemplate(String name) {
      List<EmailTemplate> r = [
                              SELECT Id, DeveloperName, HtmlValue, Subject, Markup
                              FROM EmailTemplate
                              WHERE DeveloperName = :name limit 1];
      return r.isEmpty()? null: r[0];
    }

    //Lelo          2017-02-23
    public static void sendEmailToVDSalesBack(List<String> toAddresses, Custom_Opportunity__c VDOpp) {
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTmpl = getEmailTemplate('VD_Sent_Back_VD_Sales');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',VDOpp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',VDOpp.Id);
        //Opp Id
        email.setWhatId(VDOpp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }


    //Lelo              2017-06-22
    public static void sendCustomerInsurancePresentation(Custom_Opportunity__c opp, String pCode) {
        sendCustomerInsurancePresentation(opp, pCode, null);
    }

    // Lelo             2019-12-23
    public static void sendCustomerInsurancePresentation(Custom_Opportunity__c opp, String pCode, Set<String> docs) {
        Boolean isPartnerUser = SOQLSingletonQueries.recs().isBrokerPartnerUser;
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String tmplName = 'Customer_Insurance_Product_Presentation';
        // EmailTemplate emailTmpl = getEmailTemplate('Customer_Insurance_Product_Presentation'); // replaced on 24th Dec 2019
        if (isPartnerUser) {
          tmplName = 'Partners_Customer_Insurance_Presentation';
        } else {
          if (docs != null && !docs.isEmpty()) {
            // emailTmpl = getEmailTemplate('Customer_Insurance_Presentation_v3');        
            tmplName = 'Customer_Insurance_Presentation_v3';
          }
        }
        
        String subject = '';
        String emailBody = '';
        EmailTemplate emailTmpl = getEmailTemplate(tmplName);
        if (isPartnerUser) {
          Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(
            emailTmpl.Id, opp.Ownerid, opp.Id
          );
          subject = message.getSubject();
          emailBody = message.getHtmlBody();
        } else {
          subject = emailTmpl.Subject;
          emailBody = emailTmpl.HtmlValue;
        }

        //email.setTemplateId(emailTmpl.Id);
        //email.setTargetObjectId(UserInfo.getUserId());

        String title = opp.Application__r.Title_1__c;
        if (String.isBlank(title)) {
            title = '';
        }
        String fname = opp.Application__r.First_Name__c;
        if (String.isBlank(fname)) {
            fname = '';
        }
        String lname = opp.Application__r.Last_Name__c;
        if (String.isBlank(lname)) {
            lname = '';
        }
        String oname = opp.Owner_Name__c;
        if (String.isBlank(oname)) {
            oname = '';
        }
        String ophone = opp.Owner_Phone__c;
        if (String.isBlank(ophone)) {
            ophone = '';
        }
        String omobile = opp.Owner_Mobile__c;
        if (String.isBlank(omobile)) {
            omobile = '';
        }
        String oemail = opp.Owner_Email__c;
        if (String.isBlank(oemail)) {
            oemail = 'salesforce@savvy.com.au';
        }

        //Params
        if (isPartnerUser) {
          emailBody = emailBody.replace('{!relatedTo.Application__r.Title_1__c}', title);
          emailBody = emailBody.replace('{!relatedTo.Application__r.First_Name__c}', fname);
          emailBody = emailBody.replace('{!relatedTo.Application__r.Last_Name__c}', lname);
          emailBody = emailBody.replace('{PCODE}', pCode);
        } else {
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Application__r.Title_1__c}', title);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Application__r.First_Name__c}', fname);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Application__r.Last_Name__c}', lname);
          emailBody = emailBody.replace('{!PCODE}', pCode);

          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Name__c}', oname);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Phone__c}', ophone);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Mobile__c}', omobile);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Email__c}', oemail);        
          emailBody = emailBody.replace('<![CDATA[', '');
          emailBody = emailBody.replace(']]>', '');
        }
        System.debug(emailBody);

        //Opp Id
        email.setWhatId(opp.Id);

        //Address
        List<String> to = new List<String>();
        to.add(opp.Email_Address__c);

        // Lelo         2019-12-23
        // Attachments
        List<Messaging.EmailFileAttachment> files = new List<Messaging.EmailFileAttachment>();
        if (docs != null && !docs.isEmpty()) {

            List<Document> sfDocs = [
                SELECT Name, Type, Url, DeveloperName, Description, Body, BodyLength, ContentType 
                FROM Document WHERE DeveloperName IN :docs
            ];
            for (Document d: sfDocs) {
                Messaging.EmailFileAttachment a = new Messaging.EmailFileAttachment();
                a.filename = d.Name;
                a.body  = d.Body;
                a.contenttype = d.ContentType;
                files.add(a);
            }
        }

        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(to);
        email.setHtmlBody(emailBody);
        if (!files.isEmpty()) {
            email.setFileAttachments(files);
        }

        // send the Email
        Messaging.SendEmailResult [] r = null;
        //try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        //} catch (EmailException e) {
        //    System.debug('Error: ' + e.getMessage());
        //}
        //-
        
    }
    //-
    
    //Lelo              2017-06-22
    public static void sendQuotingEmailToCustomer(QuotingEmailParam param) {
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Boolean isPartnerPortal = SOQLSingletonQueries.recs().isBrokerPartnerUser;
        String templName = isPartnerPortal? 'Quoting_Customer_Email_Partner' : 'Quoting_Customer_Email';
        if (param.isPersonalCalc()) {
          templName = isPartnerPortal? 'Quoting_Customer_Email_PL_Partner' : 'Quoting_Customer_Email_PL';
        }
        
        EmailTemplate emailTmpl = getEmailTemplate(templName);

        System.debug('Quoting Name >> ' + param.quoting.Name);

        String subject = emailTmpl.Subject;
        String emailBody = isPartnerPortal? emailTmpl.Markup : emailTmpl.HtmlValue;
        if (isPartnerPortal) {
          SendEmailController.EmailMessage msg = SendEmailController.renderEmailTemplatewithMergeField(
            emailTmpl.Id, param.opp.Id
          );
          if (msg != null) {
            emailBody = msg.emailBody;
          }           
        }
        System.debug('@@subject: ' + subject);
        System.debug('@@emailBody: ' + emailBody);
        if (isPartnerPortal) {
          emailBody = emailBody.replace('{!relatedTo.Account_First_Name__c}', param.fname.capitalize());
        } else {
          //Params
          //emailBody = emailBody.replace('{!Custom_Opportunity__c.Application__r.Title_1__c}', param.title);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Account_First_Name__c}', param.fname.capitalize());
          //emailBody = emailBody.replace('{!Custom_Opportunity__c.Application__r.Last_Name__c}', param.lname);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Name__c}', param.oname);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Phone__c}', param.ophone);
          String ownerMobile = String.isNotBlank(param.omobile) ? param.omobile : '';
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Mobile__c}', ownerMobile);
          emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Email__c}', param.oemail);
        }

        //Quoting figures
        emailBody = emailBody.replace('{PARAM_LOAN_PROD}', param.loanProduct);
        emailBody = emailBody.replace('{PARAM_PAYMENT}', param.payment);
        emailBody = emailBody.replace('{PARAM_PURCHASE_PRICE}', NumberUtils.format(param.vehiclePrice));
        emailBody = emailBody.replace('{PARAM_NET_DEPOSIT}', NumberUtils.format(param.netDeposit));
        emailBody = emailBody.replace('{PARAM_TERM}', String.valueOf(param.term));
        // emailBody = emailBody.replace('{PARAM_RESIDUAL_PERCENTAGE}', String.valueOf(param.residualPer));
        emailBody = emailBody.replace('{PARAM_RESIDUAL}', NumberUtils.format(param.residual));
        emailBody = emailBody.replace('{PARAM_MONTHLY_PAYMENT}', NumberUtils.format(param.monthlyPayment));
        emailBody = emailBody.replace('{PARAM_INTEREST_RATE}', NumberUtils.format(param.interestRate));

        String repInclusions = '';

        if (param.govFee > 0) {
          // emailBody = emailBody.replace('{PARAM_GOVFEE}', param.govFee.setScale(2).format());
          repInclusions += 'government fee of $' + NumberUtils.format(param.govFee);
        }
        if (param.lenderFee > 0) {
          // emailBody = emailBody.replace('{PARAM_LENDERFEE}', param.lenderFee.setScale(2).format());
          repInclusions += String.isNotBlank(repInclusions)? ', ' : '';
          repInclusions += 'lender fee of $' + NumberUtils.format(param.lenderFee);
        }
        if (param.riskFee > 0) {
          repInclusions += String.isNotBlank(repInclusions)? ', ' : '';
          repInclusions += 'risk fee of $' + NumberUtils.format(param.riskFee);
        }
        if (param.monthlyFee > 0) {
          repInclusions += String.isNotBlank(repInclusions)? ', ' : '';
          repInclusions += 'monthly fee of $' + NumberUtils.format(param.monthlyFee);
        }
        
        // emailBody = emailBody.replace('{PARAM_BROKERFEE}', param.brokerFee.setScale(2).format());
        repInclusions += String.isNotBlank(repInclusions)? ' and ' : '';
        repInclusions += 'broker fee of $' + NumberUtils.format(param.brokerFee);
        
        repInclusions = '*Repayments include ' + repInclusions + '.';
        emailBody = emailBody.replace('{PARAM_OTHERFEES}', repInclusions);

        //Protected
        emailBody = emailBody.replace('{PARAM_MONTHLY_PAYMENT_PRO}', NumberUtils.format(param.monthlyPaymentPro));
        
        // Customer Portal
        String portalUrl = System.Label.Customer_Portal_Url_Base;
        if (isPartnerPortal) {
          Contact c = SOQLSingletonQueries.recs().myContact;
          if (c != null) {
            portalUrl = String.isNotBlank(c.Account.Business_Client_Portal__c)? c.Account.Business_Client_Portal__c : '#';
          }
        }
        emailBody = emailBody.replace('{PARTNER_CLIENT_PORTAL}', portalUrl);
        emailBody = emailBody.replace('{EMAIL_ADDRESS}', EncodingUtil.urlEncode(param.opp.Email_Address__c, 'UTF-8'));

        //Opp Id
        email.setWhatId(param.opp.Id);

        //Address
        List<String> to = new List<String>();
        to.add(param.opp.Email_Address__c);
        //Owner email
        List<String> ownerEmail = new List<String>() ;
        ownerEmail.add(param.opp.Owner_Email__c);
        //to.add(param.opp.Owner_Email__c);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(to);
        email.setBccAddresses(ownerEmail);
        email.setReplyTo(ownerEmail.get(0));
        email.setSenderDisplayName(param.opp.Owner_Name__c);
        email.setHtmlBody(emailBody);
        
        // send the Email
        Messaging.SendEmailResult [] r = null;
        //try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        //} catch (EmailException e) {
        //    System.debug('Error: ' + e.getMessage());
        //}
        //-
        
    }
    //-

    public class QuotingEmailParam {
        public Custom_Opportunity__c opp {set;get;} 
        public Application_Quoting__c quoting {set;get;}

        //General
        public String title {set;get;}
        public String fname {set;get;}
        public String lname {set;get;}
        public String oname {set;get;}
        public String ophone {set;get;}
        public String omobile {set;get;}
        public String oemail {set;get;}

        //Quoting
        public String loanProduct {set;get;}
        public String payment {set;get;}
        public Decimal vehiclePrice {set;get;}
        public Decimal netDeposit {set;get;}
        public Decimal term {set;get;}
        public Decimal residualPer {set;get;}
        public Decimal residual {set;get;}
        public Decimal monthlyPayment {set;get;}
        public Decimal interestRate {set;get;}

        public Decimal govFee {set;get;}
        public Decimal lenderFee {set;get;}
        public Decimal riskFee {set;get;}
        public Decimal brokerFee {set;get;}
        public Decimal monthlyFee {set;get;}

        //Protected
        public Decimal monthlyPaymentPro {set;get;}

        public QuotingEmailParam(Custom_Opportunity__c opp, Application_Quoting__c quoting) {
            this.opp = opp;
            this.quoting = quoting;
            loadData();
        }

        private void loadData() {

            if (this.opp != null) {
                //fname = this.opp.Name;
                if (this.opp.Account__c != null && String.isNotBlank(this.opp.Account__r.FirstName)) {
                    fname = this.opp.Account__r.FirstName;    
                } else {
                    fname = this.opp.Name;    
                }
                oname = this.opp.Owner_Name__c;
                ophone = this.opp.Owner_Phone__c;
                omobile = this.opp.Owner_Mobile__c;
                oemail = this.opp.Owner_Email__c;
            }
            title = String.isBlank(title)? '' : title;
            fname = String.isBlank(fname)? '' : fname;
            lname = String.isBlank(lname)? '' : lname;
            oname = String.isBlank(oname)? '' : oname;
            ophone = String.isBlank(ophone)? '' : ophone;
            oemail = String.isBlank(oemail)? 'salesforce@savvy.com.au' : oemail;

            netDeposit = 0;
            monthlyPaymentPro = 0;
            govFee = 0;
            lenderFee = 0;
            riskFee = 0;
            brokerFee = 0;
            if (this.quoting != null) {
                loanProduct = this.quoting.Loan_Product__c;
                loanProduct = String.isBlank(loanProduct)? '' : loanProduct;
                if (loanProduct.containsIgnoreCase('chattel')) {
                  loanProduct = 'Chattel Mortgage';
                } else if (loanProduct.containsIgnoreCase('lease')) {
                  loanProduct = 'Car Lease';
                }
                vehiclePrice = this.quoting.Vehicle_Price__c;
                netDeposit = this.quoting.Net_Deposit__c;
                term = this.quoting.Term__c;
                monthlyPayment = this.quoting.Repayment_Monthly__c;
                payment = this.quoting.Payment__c;

                govFee = (this.quoting.PPSR__c > 0.00) ? this.quoting.PPSR__c : 0;
                lenderFee = (this.quoting.Application_Fee__c > 0.00) ? this.quoting.Application_Fee__c : 0;
                brokerFee = (this.quoting.DOF__c > 0.00) ? this.quoting.DOF__c : 0;
                monthlyFee = (this.quoting.Monthly_Fee__c > 0.00) ? this.quoting.Monthly_Fee__c : 0;

                if (this.quoting.Name.startsWith('Liberty')) {
                  lenderFee -= brokerFee;
                }

                if (String.isNotBlank(payment)) {
                    payment = payment.toLowerCase();
                }

                interestRate = this.quoting.Client_Rate__c;
                
                // Verify risk fee
                if (
                  'Finance One'.equals(quoting.Name) || 'Finance One Commercial'.equals(quoting.Name) || 
                  'Affordable'.equals(quoting.Name)  || 'CarStart'.equals(quoting.Name) || 
                  'Azora Consumer'.equals(quoting.Name) || 'Money3'.equals(quoting.Name) ||
                  'Liberty Drive'.equals(quoting.Name) || 'Liberty Leisure'.equals(quoting.Name)
                ) {
                  riskFee = (this.quoting.Risk_Fee__c > 0.00) ? this.quoting.Risk_Fee__c : 0;
                }

                // Map<String,Application_Quoting_Result__c> rslMap = QuotingCalculation.getMapQuotingResultsByQuoId(quoting.Id);
                // Application_Quoting_Result__c proRsl = rslMap.get(QuotingCalculation.CALC_PROTECTED);
                // if (proRsl != null) {
                //     monthlyPaymentPro = proRsl.Monthly_Payment__c;
                // } else {
                //     if (!isLatitudePersosal()) {
                //         throw new CustomException('There is not a protected payment for this quote.');
                //     }
                // }
                calculate();
            }

            if (vehiclePrice == null) {
                vehiclePrice = 0;
            }
            if (monthlyPayment == null) {
                monthlyPayment = 0;
            }
            if (interestRate == null) {
                interestRate = 0;
            }
            if (String.isBlank(payment)) {
                payment = '';
            }
            if (netDeposit == null) {
                netDeposit = 0;
            }
            if (term == null) {
                term = 0;
            }

        }

        public Boolean isLatitudePersosal() {
            if (this.quoting == null) return false;
            if ('Latitude Personal Loan'.equals(this.quoting.Name)) return true;
            return false;
        }

        public Boolean isPersonalCalc() {
          Set<String> plList = new Set<String>();
          plList.add('Latitude Personal Loan');
          plList.add('Wisr');
          plList.add('RateSetter PL');
          plList.add('Plenti PL');
          plList.add('Money Place');
          plList.add('Pepper PL');

          if (this.quoting != null && (plList.contains(this.quoting.Name) || 
             ('Money3'.equals(this.quoting.Name) && 
              'Personal Finance'.equals(this.quoting.Customer_Profile__c)))) {
            return true;
          }
          return false;
        }

        private void calculate() {
            //ResidualPercentage
            this.residual = this.quoting.Residual_Value__c > 0? this.quoting.Residual_Value__c : 0;
            // Decimal deposit = this.quoting.Net_Deposit__c > 0? this.quoting.Net_Deposit__c : 0;
            // Decimal price = this.quoting.Vehicle_Price__c > 0? this.quoting.Vehicle_Price__c : 0;
            // price = price - deposit;
            this.residualPer = 0;
            // if (('Macquarie Consumer'.equals(this.quoting.Name) ||
            //     'Macquarie Commercial'.equals(this.quoting.Name)) && 
            //     this.quoting.Residual_Value_Percentage__c > 0) {
            //   this.residualPer = this.quoting.Residual_Value_Percentage__c;
            // }
            // if (this.residualPer == 0 && price > 0) {
            //   residualPer = residual / price * 100;
            //   residualPer = residualPer.setScale(2);
            // }
        }


    }

    //Lelo          2017-02-23
    public static void sendEmailPresentationFinished(Application_InsuranceQuote__c quote) {

        Custom_Opportunity__c o = [
            SELECT Id, Name, Owner_Name__c, Owner_Email__c FROM Custom_Opportunity__c 
            WHERE Id IN (
              SELECT Opportunity__c FROM Application_Quoting__c WHERE App_Insurance_Quote__c = :quote.Id
            )
        ];

        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTmpl = getEmailTemplate('Owner_Presenting_Notification');
        List<String> toAddresses = new List<String>();
        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',o.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',o.Id);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Name__c}',o.Owner_Name__c);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Name}',o.Name);
        emailBody = emailBody.replace('{!URL}',URL.getSalesforceBaseUrl().toExternalForm());
        //Opp Id
        email.setWhatId(o.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        toAddresses.add(o.Owner_Email__c);
        //toAddresses.add('leandro.l@savvy.com.au');
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }

    public static OrgWideEmailAddress getNoReplyEmail() {
      List<OrgWideEmailAddress> d = [
        SELECT Id, Address, DisplayName 
        FROM OrgWideEmailAddress 
        WHERE DisplayName='Do-Not-Reply'
      ];
      return !d.isEmpty()? d.get(0) : null;
    }

    @future(callout=true)
    public static void sendEmailOpportunityPreApproved(Id oppId) {
      Custom_Opportunity__c opp =[
          SELECT 
            Name, Owner_Name__c, Owner_Phone__c, 
            Owner_Mobile__c, Owner_Email__c, 
            First_Name__c, Email_Address__c,
            OwnerId, Pre_Approved_Date__c, Date_Pre_Approved__c,
            Partner_Is_External__c
          FROM Custom_Opportunity__c where Id =: oppId
      ];
      sendEmailOpportunityPreApproved(opp);
    }

    public static void sendEmailOpportunityPreApproved(Custom_Opportunity__c o) {
      System.debug('sendEmailOpportunityPreApproved...');
      System.debug(JSON.serializePretty(o));
      Parameters_Service__c param =  Parameters_Service__c.getInstance('OppPreApprovedCustomerEmail');
      
      if (o == null || param == null || !'ON'.equals(param.value__c) || o.Partner_Is_External__c) {
        System.debug('Opportunity Pre Approved is not active, check parameter: OppPreApprovedCustomerEmail');
        return;
      }

      String tmplName = 'Opp_Pre_Approved_Customer_Notification';
      if (o.Partner_Is_External__c) {
        tmplName = 'Partner_Pre_Approved_Customer_Email';
      }
      System.debug('@@tmplName: ' + tmplName);
      // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
      // Define the Email
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      
      String subject = '';
      String emailBody = '';
      String oppFName = String.isNotBlank(o.First_Name__c)?o.First_Name__c:'';
      String ownerName = o.Owner_Name__c != null?o.Owner_Name__c:'';
      EmailTemplate emailTmpl = getEmailTemplate(tmplName);
      if (o.Partner_Is_External__c) {
        System.debug('@@ loading external templae...');
        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(
          emailTmpl.Id, o.Ownerid, o.Id
        );
        subject = message.getSubject();
        emailBody = message.getHtmlBody();

        emailBody = emailBody.replace('{!relatedTo.First_Name__c}',oppFName);
      } else {
        System.debug('@@ loading external templae...');
        String ownerPhone = o.Owner_Phone__c != null?o.Owner_Phone__c:'';
        String ownerMobile = o.Owner_Mobile__c != null?o.Owner_Mobile__c:'';
        String ownerEmail = o.Owner_Email__c != null?o.Owner_Email__c:'';

        subject = emailTmpl.Subject;
        emailBody = emailTmpl.HtmlValue;
        
        emailBody = emailBody.replace('{!Custom_Opportunity__c.First_Name__c}',oppFName);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.OwnerFullName}',ownerName);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.OwnerPhone}',ownerPhone);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Mobile__c}',ownerMobile);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Email__c}',ownerEmail);
        emailBody = emailBody.replace('<![CDATA[', '');
        emailBody = emailBody.replace(']]>', '');

      }

      List<String> toAddresses = new List<String>();
        
        //Opp Id
        email.setWhatId(o.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        toAddresses.add(o.Email_Address__c);
        //toAddresses.add('leandro.l@savvy.com.au');
        // email.setSenderDisplayName(ownerName);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
          OrgWideEmailAddress owea = getNoReplyEmail();
          if (owea != null) {
            email.setOrgWideEmailAddressId(owea.Id);
          }
          r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }

    @future(callout=true)
    public static void sendEmailOpportunityPreApprovedLiberty(Id oppId) {
      sendEmailOpportunityPreApprovedLiberty(oppId, true);
    }

    public static void sendEmailOpportunityPreApprovedLiberty(Id oppId, Boolean noReply) {
      
      Custom_Opportunity__c opp =[
          SELECT 
            Name, Owner_Name__c, Owner_Phone__c, 
            Owner_Mobile__c, Owner_Email__c,
            Partner_Is_External__c 
          FROM Custom_Opportunity__c where Id =: oppId
      ];
      sendEmailOpportunityPreApprovedLiberty(opp, noReply);
    }

    public static void sendEmailOpportunityPreApprovedLiberty(Custom_Opportunity__c o, Boolean noReply) {    
      Parameters_Service__c param =  Parameters_Service__c.getInstance('OppPreApprovedLenderEmail');

      if (o == null || param == null || !'ON'.equals(param.value__c) || o.Partner_Is_External__c) {
        System.debug('Opportunity Pre Approved is not active, check parameter: OppPreApprovedLenderEmail');
        return;
      }
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTmpl = getEmailTemplate('Opp_Pre_Approved_Customer_Notification_Liberty');
        List<String> toAddresses = new List<String>();
        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',o.Name);
        String ownerName = o.Owner_Name__c != null?o.Owner_Name__c:'';
        String ownerPhone = o.Owner_Phone__c != null?o.Owner_Phone__c:'';
        String ownerMobile = o.Owner_Mobile__c != null?o.Owner_Mobile__c:'';
        String ownerEmail = o.Owner_Email__c != null?o.Owner_Email__c:'';

        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}',o.Name);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.OwnerFullName}',ownerName);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.OwnerPhone}',ownerPhone);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Mobile__c}',ownerMobile);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Email__c}',ownerEmail);
        emailBody = emailBody.replace('<![CDATA[', '');
        emailBody = emailBody.replace(']]>', '');
        //Opp Id
        email.setWhatId(o.Id);
        // email.setSenderDisplayName(ownerName);
        //Set parameters of the Email
        
        //toAddresses.add(o.Owner_Email__c);
        param =  Parameters_Service__c.getInstance('Liberty_LFI_Email');
        email.setSubject(subject);
        List<String> emails = param.value__c.split(',');
        for(String e: emails){
          toAddresses.add(e);
        }
        
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        List<Messaging.EmailFileAttachment> files = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment a = new Messaging.EmailFileAttachment();
        PageReference pdf = Page.GenerateAppPdf;
        pdf.getParameters().put('id', o.Id);
        pdf.getParameters().put('IS_PREAPPROVAL', String.valueOf(true));
        String prefixName = 'App_PRE_APPROVAL_';
        
        Blob body = Test.isRunningTest()?Blob.valueOf('a'):pdf.getContent();

        String fileName = prefixName + '_' + o.Id + '_' + Datetime.now().format('yyyyMMddHHmmss') + '.pdf';
        String docType = 'Application Form (Pre-approval)';

        a.filename = fileName;
        a.body  = body;
        a.contenttype = 'application/pdf';
        files.add(a);

        List<Cloud_Documents__c> preApprovalFiles = [
          SELECT Bucket_Name__c, Folder_Id__c, CreatedDate, File_Name__c, Document_Type__c 
          FROM Cloud_Documents__c 
          WHERE Custom_Opportunity__c =:o.Id and Document_Type__c = 'Quoting Calculation (Pre-approval)'
          ORDER BY CreatedDate DESC
        ];
        
        if (!preApprovalFiles.isEmpty()) {
          Cloud_Documents__c preApprovalFile = preApprovalFiles.get(0);
          a = new Messaging.EmailFileAttachment();
          a.filename = preApprovalFile.File_Name__c;
          a.body  = Test.isRunningTest()?Blob.valueOf('a'):CloudDocsHelper.fileDownLoad(preApprovalFile);
          a.contenttype = 'application/pdf';
          files.add(a);
        }

        email.setFileAttachments(files);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
          if (noReply) {
            OrgWideEmailAddress owea = getNoReplyEmail();
            if (owea != null) {
              email.setOrgWideEmailAddressId(owea.Id);
            }
          }
          r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }

    public static void leadFlowNotification(Lead__c lead, User newOwner) {
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTmpl = getEmailTemplate('LeadFlowNotification');

        String subject = emailTmpl.Subject.replace('{!Lead__c.Name}', lead.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Lead__c.Id}', lead.Id);
        emailBody = emailBody.replace('{URL}', System.URL.getSalesforceBaseUrl().ToExternalForm());
        emailBody = emailBody.replace('{!Lead__c.Name}', lead.Name);
        emailBody = emailBody.replace('{!Lead__c.Mobile_Number__c}', lead.Mobile_Number__c);
        emailBody = emailBody.replace('{!Lead__c.Email_Address__c}', lead.Email_Address__c);


        //Opp Id
        email.setWhatId(lead.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(new String[] {newOwner.Email});
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
    }

    //PPSR - HJ - I

    public static Messaging.SendEmailResult [] sendEmailNotification(Id id, String subject, String emailBody, List<String> toAddresses, String process){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //Opp Id
        email.setWhatId(id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            throw new GenericException ('::Error sending the email: ' + process, e);
        }
        return r;
    }

    public static void sendEmailPPSRNotification(Custom_Opportunity__c opp, List<String> toAddressSend){
        List<String> toAddresses = new List<String>();
        for (String address : toAddressSend){
            toAddresses.add(address);
        }
        toAddresses.add(opp.Owner_Email__c);
        EmailTemplate emailTmpl = getEmailTemplate('PPSR_Response_Certificate');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name );
        String msgName = opp.Application_AssetDetail__r != null 
          ? opp.Application_AssetDetail__r.PPSR_Proxy_Message__c
          : 'No proxy error message';
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.OwnerFullName}',opp.Owner_Name__c )
                 .replace('{!Custom_Opportunity__c.Name}',opp.Name ).replace('{!Custom_Opportunity__c.Id}',opp.Id )
                            .replace('{!MessageName}', msgName);
        try{
            sendEmailNotification (opp.Id, subject, emailBody, toAddresses, 'sendEmailPPSRNotification');
        }catch (Exception ex){
            System.debug('sendEmailPPSRNotification error description: ' + ex.getMessage());
        }
    }

    public static void sendEmailPPSRNotificationError(Custom_Opportunity__c opp, String messageError, String messageBody, List<String> toAddressSend){

        List<String> toAddresses = new List<String>();
        for (String address : toAddressSend){
            toAddresses.add(address);
        }
        toAddresses.add(opp.Owner_Email__c);
        EmailTemplate emailTmpl = getEmailTemplate('PPSR_Error_Proxy_Certificate');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name );
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}',opp.Name ).replace('{!Custom_Opportunity__c.Id}',opp.Id )
                            .replace('{!MessageError}', messageError).replace('{!MessageBody}', messageBody);
        try{
            sendEmailNotification (opp.Id, subject, emailBody, toAddresses, 'sendEmailPPSRNotificationError');
        }catch (Exception ex){
            System.debug('sendEmailPPSRNotificationError  error description: ' + ex.getMessage());
        }
    }
    
    public static void sendEmailAppNotificationUnfinished(Custom_Opportunity__c opp, List<String> toAddresses){
        List<String> toAddress = new List<String>();
        User user = SOQLSingletonQueries.getUserById(opp.CreatedById);
        toAddress.add(user.Email);
        EmailTemplate emailTmpl = getEmailTemplate('AppNotificationUnfinished');
        try{
          String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name );
          String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}',opp.Name )
                                              .replace('{!Custom_Opportunity__c.Id}',opp.Id )
            								  .replace('{!Custom_Opportunity__c.Owner_Name__c}', user.Name);
        
        
            sendEmailNotification(opp.Id, subject, emailBody, toAddress, 'sendEmailAppNotificationUnfinishedError');
        }catch (Exception ex){
            System.debug('sendEmailAppNotificationUnfinishedError error description: ' + ex.getMessage());
        }
    }
    /* Yohan Villamizar Leal 2020-01-28
     * This notification is sent when an Opportunity is closed and the application has been 
     * fill for the client.
	*/
    public static void sendEmailAppNotificationForOpportunityClosed(Custom_Opportunity__c opp){
        List<String> toAddress = new List<String>();
        Id userId = null;
        if('Queue'.equals(opp.OwnerType__c)){
            userId = opp.CreatedById;
        } else{
            userId = opp.OwnerId;
        }
        try {
          User sysGen = SOQLSingletonQueries.recs().sysGenUser;
          User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
          User user = SOQLSingletonQueries.getUserById(userId);
          
          if(user != null && user.Id != sysGen.Id && user.Id != savvyAdmin.Id && user.IsActive){
              toAddress.add(user.Email);
          }else{
              toAddress.add(BusinessParamHelper.getParameter('SALESFORCEDEV_EMAIL'));
          }
          EmailTemplate emailTmpl = getEmailTemplate('New_App_For_Closed_Opportunity');
          
          String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Application__r.Name}',opp.Application__r.Name );
          String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}',opp.Name )
              .replace('{!Custom_Opportunity__c.Id}',opp.Id )
              .replace('{!Custom_Opportunity__c.OwnerFullName}', user.Name);
        
          sendEmailNotification(opp.Id, subject, emailBody, toAddress, 'New_App_For_Closed_Opportunity');
        } catch (Exception ex){
            System.debug('New_App_For_Closed_Opportunity error description: ' + ex.getMessage());
        }
    }

    //Lelo          2017-02-23
    public static void sendEmailToVDFormalApproval(List<String> toAddresses, Custom_Opportunity__c opp) {
        // Send email to notify the VD settlement team with attachments of Driver's License and VD worksheet
        // Define the Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // VD Sent Back VD Sales - Formal Approval
        EmailTemplate emailTmpl = getEmailTemplate('VD_Sent_Back_VD_Sales_Formal_Approval');

        String subject = emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}',opp.Name);
        String emailBody = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Id}',opp.Id);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Name}',opp.Name);
        emailBody = emailBody.replace('{!Custom_Opportunity__c.Owner_Name__c}',opp.Owner_Name__c);
        //Opp Id
        email.setWhatId(opp.Id);
        //Set parameters of the Email
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(emailBody);
        // send the Email
        // Lelo                                 2016-08-17
        // Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});     //original line
        Messaging.SendEmailResult [] r = null;
        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage [] {email});
        } catch (EmailException e) {
            System.debug('Error: ' + e.getMessage());
        }
        //-
        
    }
  
  public static void sendRequiredDocNotification(Set<Id> oppIds) {
    System.debug('sendRequiredDocNotification...');
    if (oppIds != null && !oppIds.isEmpty()) {
      String tmplName = 'Required_Document_Notification';
      EmailTemplate tmpl = getEmailTemplate(tmplName);
      if (tmpl == null) {
        System.debug('@@ CRITIAL ERROR: email template not found [' + tmplName + '] EmailSender.sendRequiredDocNotification');
        return;
      }

      // Get Owner emails/Ids
      List<Custom_Opportunity__c> opps = [
        SELECT Ownerid, Owner_Email__c, OwnerType__c 
        FROM Custom_Opportunity__c
        WHERE Id in :oppIds
      ];

      Map<Id, Custom_Opportunity__c> oppMap = new Map<Id, Custom_Opportunity__c>();
      for (Custom_Opportunity__c o: opps) {
        oppMap.put(o.Id, o);
      }


      List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
      for (Id idx : oppIds) {
        try {
          Custom_Opportunity__c o = oppMap.get(idx);
          Id whoId = 'User'.equals(o.OwnerType__c)? o.Ownerid : UserInfo.getUserId();
          Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(
            tmpl.Id, whoId, idx
          );
          message.saveAsActivity = false;
          emails.add(message);
        } catch (Exception e) {
          System.debug('@@Error: ' + e.getMessage());
        }
      }

      if (!emails.isEmpty()) {
        try {
          Messaging.sendEmail(emails);
          System.debug('@@Email sent!');
        } catch (EmailException e) {
          System.debug('Error: ' + e.getMessage());
        }
      }
    }
  }

}