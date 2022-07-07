global class SendADelayedNotification implements Database.Batchable<sObject> {
	
    global final String query;
    global final String status;
    global final String timeDesc;
    global final Boolean isRescheduled;
    global final Integer longTime;
    global final String objId;
    public String dtex{get;set;}
    public Integer hours{get;set;}
    public Integer minuts{get;set;}
    
    //Sent to Lender Notifications
    global final Boolean isSentToLender;

    global SendADelayedNotification(String oppId, String currentStatus, String timeDescription, Integer longTimeSchedulled) {
        this(oppId, currentStatus, timeDescription, longTimeSchedulled, false);
    }

    global SendADelayedNotification(String oppId, String currentStatus, String timeDescription, Integer longTimeSchedulled, 
                                    Boolean rescheduled) {
        this(oppId, currentStatus, timeDescription, longTimeSchedulled, rescheduled, false);
    }
    
    global SendADelayedNotification(String oppId, String currentStatus, String timeDescription, Integer longTimeSchedulled, 
                                    Boolean rescheduled, Boolean sentToLender) {
        query = 'Select Id, Name, Status__c, Owner_Email__c, OwnerId, Owner.Name From Custom_Opportunity__c Where id = \'' + oppId + '\'';
        objId = oppId;
        timeDesc = timeDescription;
        status = currentStatus;
        longTime = longTimeSchedulled;
        isRescheduled = rescheduled;
        isSentToLender = sentToLender;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        //System.debug('starting...');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) { 
        List<Messaging.Email> mails = new List<Messaging.Email>();
        for(Sobject s : scope){
        	Custom_Opportunity__c o = (Custom_Opportunity__c)s;
            if (status.equalsIgnoreCase(o.Status__c)) {
                String emailTmplName = getEmailtTemplate();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailTemplate emailTmpl = [
                				SELECT Id, DeveloperName, HtmlValue, Subject
                                FROM EmailTemplate
                                WHERE DeveloperName = :emailTmplName limit 1];
                
                mail.setSubject(emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}', o.Name));
                String body = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}', o.Name).replace('{!Custom_Opportunity__c.OwnerFullName}', o.Owner.Name);
                body = body.replace('{APPROVAL_PROCESS}', getApprovalProcess());
                mail.setHtmlBody(body);
                mail.setSaveAsActivity(true);
                mail.setToAddresses(new String[] { o.Owner_Email__c });
                //mail.setToAddresses(new String[] { 'armando.c@savvy.com.au','leandro.l@savvy.com.au' });
                //mail.setToAddresses(new String[] { 'leandro.l@savvy.com.au' });
                mail.setSenderDisplayName('Savvy Finance & Insurance');
                mail.setReplyTo('noreply@savvy.com.au'); 
                mails.add(mail);

                if (isSentToLender) {
                    //Prepare approver notification
                    emailTmplName = getApproverEmailtTemplate();
                    emailTmpl = [
                                SELECT Id, DeveloperName, HtmlValue, Subject
                                FROM EmailTemplate
                                WHERE DeveloperName = :emailTmplName limit 1];
                    mail = new Messaging.SingleEmailMessage();
                    mail.setSubject(emailTmpl.Subject.replace('{!Custom_Opportunity__c.Name}', o.Name));
                    body = emailTmpl.HtmlValue.replace('{!Custom_Opportunity__c.Name}', o.Name).replace('{!Custom_Opportunity__c.OwnerFullName}', o.Owner.Name);
                    body = body.replace('{APPROVAL_PROCESS}', getApprovalProcess());
                    body += '<p><h1>' + status + '</h1></p>';
                    mail.setHtmlBody(body);
                    mail.setSaveAsActivity(true);
                    mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
                    //mail.setToAddresses(new String[] { 'armando.c@savvy.com.au','leandro.l@savvy.com.au' });
                    //mail.setToAddresses(new String[] { 'leandro.l@savvy.com.au' });
                    mail.setSenderDisplayName('Savvy Finance & Insurance');
                    mail.setReplyTo('noreply@savvy.com.au'); 
                    mails.add(mail);

                }

                if (!isRescheduled) {
                    //Create a task
                    Id ownerId = o.OwnerId;
                    TaskCreator.CreateTask(
                        ownerId, o.Id, getTaskSubject(), '', null, 'High', (1/60)
                    );

                    if (isSentToLender) {
                        ownerId = UserInfo.getUserId();
                        TaskCreator.CreateTask(
                            ownerId, o.Id, getTaskSubject(true), '', null, 'High', (1/60)
                        );
                    }
                }
                
            }
            System.debug('Processing >> ' + o.Name + ' oemail >> ' + o.Owner_Email__c + ' hour >> ' + timeDesc);
      	}
        Datetime dt = System.now();
        hours=dt.hour();
        minuts=dt.minute();
		dtex=dt.format('EEEE');
        if (!mails.isEmpty()) {
            try {
                if(dtex.equals('Monday') || dtex.equals('Tuesday') || dtex.equals('Wednesday') || dtex.equals('Thursday') || dtex.equals('Friday')) {
                    if (hours>=8 && hours<17) {
            	Messaging.sendEmail(mails);
            	System.debug('Total emails sent >> ' + mails.size());
                    }
                }
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
	
    global void finish(Database.BatchableContext BC){
        //Reschedule
        SendADelayedNotification.scheduleNotification(objId, status, timeDesc, longTime, true, isSentToLender);
    }
	
    private String getEmailtTemplate() {
        String r = 'Sales_Consultan_Submitted_For_Approval_Notification';
        if (status.containsIgnoreCase('Sent to ')) {
            r = 'Sales_Consultan_SentToLender_Notification';
        }
        return r;
    }

    private String getApproverEmailtTemplate() {
        String r = 'Approval_Team_SentToLender_Notification';
        /*if (status.contains('Submitted for ')) {
            if (isSentToLender) {
                r = 'Sales_Consultan_SentToLender_Notification';
            } else {
                r = 'Sales_Consultan_Submitted_For_Approval_Notification';
            }
        }*/
        return r;
    }
 	
    private String getApprovalProcess() {
        String r = 'Unknown';
        if (('Submitted for Pre-Approval'.equals(status)) || ('Sent to Lender for Pre-Approval'.equals(status))) {
            r = 'Pre-Approval';
        } else if (('Submitted for Amendment'.equals(status)) || ('Sent to Lender for Amendment'.equals(status))) {
            r = 'Amendment';
        } else if (('Submitted for Formal Approval'.equals(status)) || ('Sent to Lender for Formal Approval'.equals(status))) {
            r = 'Formal Approval';
        }
        return r;
    }


    public static void scheduleNotification(String oppId, String currentStatus, String timeDescription, Integer minutes) {
        scheduleNotification(oppId, currentStatus, timeDescription, minutes, false);
    }

    public static void scheduleNotification(String oppId, String currentStatus, String timeDescription, Integer minutes,
                                            Boolean rescheduled) {
        scheduleNotification(oppId, currentStatus, timeDescription, minutes, rescheduled, false);
    }

    public static void scheduleNotification(String oppId, String currentStatus, String timeDescription, Integer minutes, 
                                            Boolean rescheduled, Boolean sentToLender) {
        Datetime d = Datetime.now();
        String jobName = 'OppDelayedNotification:' + oppId + '|' + d.format('yyyy.MM.dd.HH.mm.ss');
        removeAllScheduleNotifications(oppId);
        if (isLimitReachedForScheduleJobs()) {
            //Schedule a new job
            System.scheduleBatch(
                				new SendADelayedNotification(oppId, currentStatus, timeDescription, minutes, rescheduled, sentToLender), 
                				jobName, getMinutesEstimation(minutes));
        } else {
            System.debug('Limit for scheduling jobs has been reached.');
        }
    }

    private static Integer getMinutesEstimation(Integer minutes) {
        Integer r = minutes;
        Datetime i = Datetime.now();
        Datetime f = i.addMinutes(r);
        if (f.hour() >= 6) {
            f = f.addDays(1);
            if ('Sat'.equals(f.format('EEE'))) {
                f = f.addDays(2);
            }
            if ('Sun'.equals(f.format('EEE'))) {
                f = f.addDays(1);
            }
            f = Datetime.newInstance(f.year(), f.month(), f.day(), 8, getRandom(30), 0);
            Long t = (f.getTime() - i.getTime()) / 1000 / 60;
            r = t.intValue();
        }
        return r;
    }

    private static Integer getRandom(Integer top) {
        return Integer.ValueOf(Math.rint(Math.random() * top));
    }

    public String getTaskSubject() {
        return getTaskSubject(false);
    }

    public String getTaskSubject(boolean isForApprover) {
        String r = 'Unknown';
        if ('Submitted for Pre-Approval'.equals(status)) {
            r = 'Submitted for Pre-Approval Follow up';
        } else if ('Submitted for Amendment'.equals(status)) {
            r = 'Submitted for Amendment Follow up';
        } else if ('Submitted for Formal Approval'.equals(status)) {
            r = 'Submitted for Formal Approval Follow up';
        } else if ('Sent to Lender for Pre-Approval'.equals(status)) {
            if (isForApprover) {
                r = 'Follow up Pre-Approval submission with Lender & update system';
            } else {
                r = 'Follow up Pre-Approval submission with Lender';
            }
        } else if ('Sent to Lender for Amendment'.equals(status)) {
            if (isForApprover) {
                r = 'Follow up Amendment submission with Lender & update system';
            } else {
                r = 'Follow up Amendment submission with Lender';
            }
        } else if ('Sent to Lender for Formal Approval'.equals(status)) {
            if (isForApprover) {
                r = 'Follow up Formal Approval submission with Lender & update system';
            } else {
                r = 'Follow up Formal Approval submission with Lender';
            }
        }
        return r;
    }

    public static void removeAllScheduleNotifications(String oppId) {

        String jobName = 'OppDelayedNotification:' + oppId + '%';
        //Delete previous Jobs
        try {
            List<CronTrigger> jobs = [SELECT Id FROM CronTrigger c WHERE CronJobDetail.Name LIKE :jobName];
            if (jobs != null) {
                for (CronTrigger c : jobs) {
                    System.abortJob(c.Id);
                }
            }
        } catch (Exception ignore) {}
        System.debug('Removing all schedule notifications for ' + oppId);
    }

    public static void closeAllTaskNotifications(String oppId) {
        List<Task> tasks = [SELECT Id, Subject FROM Task 
                            WHERE WhatId = :oppId 
                            AND Subject LIKE 'Submitted for%' AND Subject LIKE '% Follow Up'];
        if (!tasks.isEmpty()) {
            for (Task t : tasks) {
                t.Status = 'Completed';
            }
            try {
                update tasks;
            } catch (Exception e) {}
        }
        System.debug('Closing all tasks for ' + oppId + ' >> ' + tasks.size());
    }

    public static boolean isLimitReachedForScheduleJobs() {
        boolean r = false;
        Integer MAX_BATCHES = 90;
        Integer runningBatchJobs = [
            select count() from CronTrigger
            where State in ('WAITING','ACQUIRED','EXECUTING')
            or NextFireTime != NULL
        ];
        if(runningBatchJobs < MAX_BATCHES) {
            r = true;
        }
        return r;
    }
}