public without sharing class LeadEditExtension {
    
    private String userProfile = null;

    public LeadEditExtension(ApexPages.StandardController c) {
        record = (Lead__c) c.getRecord();
        initialStatus = record.Status__c;

        // if in portal then default a couple of things
        if (record.Id == null && IsPortal) {
            record.Lead_Source__c = 'Savvy Dealer Program';
            record.Status__c = 'New Lead';
        }
        if (String.isBlank(record.State__c)) {
            record.State__c = PostcodeHelper.getState(record.Postcode__c);
        }
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        userProfile = p.name;
    }

    private Lead__c record;
    private String initialStatus;

    // this checks if the current user has a portal profile - if so then we must be in the portal
    public Boolean IsPortal {
        get {
            if (IsPortal == null) {
                IsPortal = ([SELECT UserType FROM Profile WHERE Id =: UserInfo.getProfileId()].UserType == 'CspLitePortal');
            }
            return IsPortal;
        }
        set;
    }

    // this checks if the current user can edit this record
    public Boolean getHasEditAccess() {

        return true; //Lelo      2017-10-04          always allow due to Aspect Integration

        //if (record.Id == null)
        //{
        //    return true;
        //}    

        //// portal user cannot edit record unless they own it
        //if (IsPortal && record.OwnerId != UserInfo.getUserId())
        //{
        //    return false;
        //}

        //for (UserRecordAccess ura : [SELECT RecordId
        //                             FROM UserRecordAccess
        //                             WHERE UserId = :UserInfo.getUserId()
        //                             AND RecordId = :record.Id
        //                             AND HasEditAccess = true])
        //{
        //    return true;
        //}               

        //return false;                      
    }

    // if the user is System Generated then this checks if this is the oldest one
    public Boolean getIsOldestSysGen() {
        if (record.Owner.Name != 'System Generated') {
            return true;
        }

        if (getHasEditAccess() == true) {
            return true;
        }

        for (Lead__c l: [SELECT Id
                FROM Lead__c
                WHERE Owner.Name = 'System Generated'
                AND Employment_Status__c != 'Unemployed'
                AND CreatedDate <: record.CreatedDate
            ])

        {
            return false;
        }

        return true;
    }

    public PageReference SaveOverride() {
        try {
            if (record.Status__c == null) {
                return CustomException.formatException('A Lead cannot be saved with no value selected in the Status field');
            }

            // if this is being created from within the portal then populate the lead consultant and lead consultant dealer fields
            if (record.Id == null && IsPortal) {
                record.Lead_Consultant__c = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId;
                record.Lead_Consultant_Dealer__c = [SELECT AccountId FROM User WHERE Id =: UserInfo.getUserId()].AccountId;
            }

            Boolean createExistingLeadTask = false;
            Boolean createCallBackTask = false;
            Boolean closeTasks = false;

            // find original lead data
            Lead__c originalLead = new Lead__c();
            for (Lead__c l: [SELECT Id,
                    OwnerId,
                    Status__c
                    FROM Lead__c
                    WHERE Id =: record.Id
                ]) {
                originalLead = l;
            }

            // do the processing as long as this isn't a portal user
            if (!IsPortal) {
                // find the account record
                List<Account> d = null;
                if (record.Account__c == null) {
                    d = SOQLSingletonQueries.searchAccounts(record);
                } else {
                    d = [SELECT Id, OwnerId, Force_Owner_Change__c,
                            (SELECT Id FROM Opportunities__r),
                            (SELECT Id FROM Leads__r)
                            FROM Account
                            WHERE Id = :record.Account__c
                        ];
                }
                Account a = null;
                if (!d.isEmpty()) {
                    a = d.get(0);
                } else {
                    a = new Account(RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Person Account'));
                    a.FirstName = record.First_Name__c;
                    a.LastName = record.Last_Name__c;
                    a.Street_Address__c = record.Street_Address__c;
                    a.Suburb__c = record.Suburb__c;
                    a.State__c = record.State__c;
                    a.Postcode__c = record.Postcode__c;
                    a.PersonHomePhone = record.Home_Phone__c;
                    a.PersonOtherPhone = record.Work_Phone__c;
                    a.PersonMobilePhone = record.Mobile_Number__c;
                    a.PersonEmail = record.Email_Address__c;
                    a.OwnerId = SOQLSingletonQueries.recs().sysGenUser.Id;
                    insert a;
                    record.Account__c = a.Id;
                }

                // set the owner of the record to that of the account record
                //record.OwnerId = a.OwnerId;
                record.OwnerId = UserInfo.getUserId();

                /*                      
                      // see spec, section 5.6 - 1a
                      if (a.OwnerId != UserInfo.getUserId()  && a.Opportunities__r.size() >= 1 )
                      {
                */ // the status of the record must be New Lead
                if (record.Status__c == 'New Lead')
                    createExistingLeadTask = true;
                

                // see spec, section 5.6 - 1a
                //   if (a.OwnerId != UserInfo.getUserId()  && a.Opportunities__r.size() >= 1 )
                //   {
                // the status of the record must be New Lead
                if (record.Reason_for_closure__c == 'Duplicate Lead')
                    createExistingLeadTask = true;
                

                if (a.OwnerId != UserInfo.getUserId()) {
                    if (record.Status__c == 'Unresolved Lead') {
                        return CustomException.formatException('The status must not be Unresolved Lead');
                    }
                }

                //set the account owner as the new user name for account which has ownership as 'System Generated'
                /*
                User u = SOQLSingletonQueries.recs().sysGenUser;
                if (a.OwnerId == u.id) {
                    a.OwnerId = UserInfo.getUserId();
                    a.Force_Owner_Change__c = true;
                    update a;
                    record.ownerId = UserInfo.getUserId();

                    a.Force_Owner_Change__c = false;
                    update a;
                } else if (a.OwnerId == UserInfo.getUserId()) {
                    // the status of the record must not be New Lead
                    if (record.Status__c == 'New Lead') {
                        return CustomException.formatException('The status must not be New Lead.');
                    }
                    closeTasks = true;
                }
                */

                // do the status based checks
                if (record.Status__c != originalLead.Status__c) {
                    if (record.Status__c == 'Attempted Contact 1' || record.Status__c == 'Attempted Contact 2' ||
                        record.Status__c == 'Attempted Contact 3' || record.Status__c == 'Attempted Contact 4' ||
                        record.Status__c == 'Attempted Contact 5' || record.Status__c == 'Attempted Contact 6') {
                        createCallBackTask = true;
                    }
                }
            }

            // if the owner has changed then close any open tasks
            if (record.Status__c != originalLead.Status__c && (record.OwnerId != originalLead.OwnerId ||
                    closeTasks)) {
                List < Task > tasks = [SELECT Id,
                    Status,
                    Status_Override__c
                    FROM Task
                    WHERE WhatId =: record.Id
                    AND Status != 'Completed'
                ];

                for (Task t: tasks) {
                    t.Status_Override__c = true;
                    t.Status = 'Completed';
                }

                update tasks;
            }

            upsert record;


            // fetch the Account details
            /*
            Account acc;
            for (Account a: [SELECT Name,
                    OwnerId
                    FROM Account
                    WHERE Id =: record.Account__c
                ]) {
                acc = a;
            }
            */
           
            // create a task for a new Account

            if (createCallBackTask) {
                TaskCreator.CreateTask(record.OwnerId,
                    record.Id,
                    'Call back in 4 hours',
                    '',
                    0,
                    'High',
                    4);
            }

            // create the task for an existing lead enquiring

            Id taskOwnerId = UserInfo.getUserId();
            if (record.OwnerId != null && record.OwnerId != SOQLSingletonQueries.recs().sysGenUser.Id) {
                taskOwnerId = record.OwnerId;
            }
            // if (createExistingLeadTask) {
            //     TaskCreator.CreateTask(taskOwnerId,
            //         record.Id,
            //         'Existing Lead has enquired again - Follow up',
            //         '',
            //         0,
            //         'High',
            //         2);
            // }


            // if the record status has changed to Become Opportunity then do the Convert Lead function
            if (record.Status__c != initialStatus && record.Status__c == 'Sales Flow/Become Opportunity') {
                PageReference ref = Page.AppPreFlow;
                ref.getParameters().put('id', record.Id);
                return ref;
            } else {
                // if the owner is system generated but the owner of the account is different from this user then redirect to home page
                if (record.Owner.Name == 'System Generated' && taskOwnerId != UserInfo.getUserId()) {
                    return new PageReference('/');
                } else if (record.OwnerId != UserInfo.getUserId()) {
                    return new PageReference('/');
                } else {
                    return new PageReference('/' + record.Id);
                }
            }
        }
        catch (Exception e) {
            CustomException.formatException(e);
            return null;
        }
    }

    public PageReference Submit() {
        try {
            // flag the record as submitted from portal
            record.Submitted_from_Portal__c = true;

            // save the record
            return SaveOverride();
        }
        catch (Exception e) {
            CustomException.formatException(e);
            return null;
        }
    }

    public Boolean getIsAdminProfile() {
        if ('System Admin'.equals(userProfile)) {
            return true;
        }
        return false;
    }
}