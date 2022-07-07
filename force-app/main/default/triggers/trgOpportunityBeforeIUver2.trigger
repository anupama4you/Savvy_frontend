trigger trgOpportunityBeforeIUver2 on Custom_Opportunity__c (before insert, before update) 
{
    // find the lead consultant dealers for the linked leads    
    //Set<Id> leadIds = new Set<Id>();
    //Set<Id> accountIds = new Set<Id>();
    //set<Id> oppIds = new set<Id>();
    //List <ID> relatedAppId = new List <Id> ();
    /*Id recTypeId;
    Id ownerQueueId;
    if(Trigger.isUpdate){
        recTypeId = Schema.SObjectType.Custom_Opportunity__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        ownerQueueId = SOQLSingletonQueries.recs().getHomeLoanQueue.Id;//[Select Id from Group where Name='Home Loans' and Type = 'Queue' limit 1].Id;
    }
    Set<Id> oppSettledIds = new Set<Id>();
    for (Custom_Opportunity__c o : Trigger.New) {        
        //leadIds.add(o.Lead__c);
        //accountIds.add(o.Account__c);
        if(Trigger.isUpdate){
            oppIds.add(o.Id);
            if(o.RecordTypeId == recTypeId && o.OwnerId != Trigger.OldMap.get(o.id).OwnerId && Trigger.OldMap.get(o.id).OwnerId == ownerQueueId){
                o.OwnerId = UserInfo.getUserId();
            }
            if(o.Status__c != Trigger.oldMap.get(o.Id).Status__c){
                if (o.Status__c == 'Settled'){
                    oppSettledIds.add(o.Id);
                }
            }
        }
        /*if(Trigger.isInsert){
            if (o.Application__c != null) {
                relatedAppId.add(o.Application__c);
            }
        }
    }        
    //Boolean isSettlementsTeam = false;
    /*Map<Id, Boolean> hasFinalDocs = new Map<Id, Boolean>();
    Map<Id, Boolean> hasLenderSett = new Map<Id, Boolean>();
    /*if (Trigger.isUpdate){
        if(!Test.isRunningTest())   { 
          for(UserRole ur : SOQLSingletonQueries.recs().getCurrentUserRoles){//[Select Name from UserRole where Id = :UserInfo.getUserRoleId()]){
            if(ur.Name == 'Settlement Team'){
              isSettlementsTeam = true;
            }
          }
        }
    }*/
    /*Map<Id, Lead__c> leads = new Map<Id, Lead__c> ();
    
    if(!Test.isRunningTest())   { 
        leads = SOQLSingletonQueries.setLeadIds(leadIds).leadsIdMap;/*new Map<Id, Lead__c> ([SELECT Id, Lead_Consultant_Dealer__c                                                           
                                       FROM Lead__c WHERE Id IN :leadIds]);
    }*/
    
    // find previous opportunities for the account
    /*Map<Id, Account> accounts = new Map<Id, Account>();
    if (Trigger.isInsert){
      accounts = SOQLSingletonQueries.setAccountIds(accountIds).settledAccountsIdMap;/*new Map<Id, Account> ([SELECT Id,
                                                                (SELECT Id,
                                                                        Occupation__c,
                                                                        Occupation_Status__c,
                                                                        Applicant_Net_Income__c,
                                                                        Co_Borrower_Net_Income__c,
                                                                        Other_Income__c,
                                                                        Other_Income_Detail__c,
                                                                        Mortgage_Rent__c,
                                                                        Living_Expenses__c,
                                                                        Existing_Loan_Payments__c,
                                                                        Credit_Card_Payments__c,
                                                                        Other_Expenses__c                                                                      
                                                                 FROM Opportunities__r
                                                                 WHERE Status__c = 'Settled'
                                                                 ORDER BY Date_Settled__c DESC)
                                                         FROM Account
                                                         WHERE Id IN :accountIds]);  
    } */                                                       
      // find the finance products and required documents linked to the opportunities  
    /*Map<Id, Custom_Opportunity__c> oppLists = new Map<Id, Custom_Opportunity__c>();
  
    if (Trigger.NewMap != null && Trigger.isUpdate && Trigger.New.size() == 1)
    {
        oppLists = SOQLSingletonQueries.setOppIds(Trigger.NewMap.keySet()).opportunityProdFinanceMap;
        /*if(oppLists == null){
            oppLists = new Map<Id, Custom_Opportunity__c> ([SELECT Id,
                                                               (SELECT Id
                                                                FROM Products__r
                                                                WHERE RecordType.Name = 'Finance'
                                                                ORDER BY CreatedDate DESC
                                                                LIMIT 1),
                                                               (SELECT Type__c
                                                                FROM Required_Documents__r)
                                                        FROM Custom_Opportunity__c
                                                        WHERE Id IN :Trigger.NewMap.keySet()]);
            if(oppLists == null){
                oppLists = new Map<Id, Custom_Opportunity__c> ();
            }
        }*/
        
    /*}                                                                                       
                                                        
    // find the System Generated user
    /*User sysGen = [SELECT Id
                   FROM User
                   WHERE Name = 'System Generated'];           Comment out reason: Query not used  */                                        
    /*
    // find the products for each opportunity
    Map<Id, List<Product__c>> products = new Map<Id, List<Product__c>>();
    // find the Cloud Documents for each opportunity
    Map<Id, List<DragDropToCloud__Cloud_Documents__c>> cloudDocs = new Map<Id, List<DragDropToCloud__Cloud_Documents__c>>();
    if (Trigger.NewMap != null)
    {
        if (Trigger.isUpdate && Trigger.New.size() == 1){ //SOQLSingletonQueries.setOppIds(oppSettledIds).productsByOppIds)
            if(!oppSettledIds.isEmpty()){
            
        
                for (Product__c p : SOQLSingletonQueries.setOppIds(oppSettledIds).productsByOppIds)/*[SELECT Id,
                                      Name,
                                      Opportunity_Name__c,
                                      (SELECT Id
                                       FROM Invoices__r)
                               FROM Product__c
                               WHERE Opportunity_Name__c IN :Trigger.NewMap.keySet()])*/
          /*      {
                    if(Test.isRunningTest()){
                    //System.assertEquals(null, p.Invoices__r);
                    //System.debug('Pass1 p.Invoices__r:' + p.Invoices__r.size() + ':' + p.Id);
                    }
                    if (!products.containsKey(p.Opportunity_Name__c))
                    {
                        products.put(p.Opportunity_Name__c, new List<Product__c>());    
                    } 
              
                    products.get(p.Opportunity_Name__c).add(p);   
                }
        
          
                for(DragDropToCloud__Cloud_Documents__c cloudDoc : SOQLSingletonQueries.setOppIds(oppSettledIds).cloudDocsByOppIds){
                     
                    if(!cloudDocs.containsKey(cloudDoc.Custom_Opportunity__c)){
                        hasFinalDocs.put(cloudDoc.Custom_Opportunity__c, false);
                        hasLenderSett.put(cloudDoc.Custom_Opportunity__c, false);
                        cloudDocs.put(cloudDoc.Custom_Opportunity__c, new List<DragDropToCloud__Cloud_Documents__c>());
                    }
                    if(cloudDoc.Document_Type__c == 'Final Signed Documents'){
                      cloudDocs.get(cloudDoc.Custom_Opportunity__c).add(cloudDoc);   
                      
                      hasFinalDocs.put(cloudDoc.Custom_Opportunity__c, true);
                    }
                    if(cloudDoc.Document_Type__c == 'Lender Settlement Confirmation'){
                      cloudDocs.get(cloudDoc.Custom_Opportunity__c).add(cloudDoc);   
                      hasLenderSett.put(cloudDoc.Custom_Opportunity__c, true);
                    }
                }
            
            }
        }
    }                         
    //Map<Id, Attachment> attLst = new Map<Id, Attachment>();
    /*if(!oppIds.isEmpty()){
        
        for(Attachment attOpp :  SOQLSingletonQueries.setOppIds(oppIds).attachmentsByOppIds){//[select id,parentId,OwnerId,Name,Body from Attachment where parentId in :oppIds]){
            attLst.put(attOpp.parentId, attOpp);
        }
    }*/
   /* 
    //List<Attachment> attLstToDel = new List<Attachment>();
    //Map<Custom_Opportunity__c, String> oppSettedEmailMap = new Map<Custom_Opportunity__c, String>();
    for (Custom_Opportunity__c o : Trigger.New) 
    {        
        /*if (leads.containsKey(o.Lead__c))
        {      
            o.Lead_Consultant_Dealer__c = leads.get(o.Lead__c).Lead_Consultant_Dealer__c;
        }*/
/*
        if (Trigger.isUpdate && Trigger.New.size() == 1)
        {
            
             // if the owner is System Generated and the status has changed from Unresolved Opportunity then change owner to the current user
            /*if(o.Status__c != Trigger.oldMap.get(o.Id).Status__c && Trigger.oldMap.get(o.Id).Status__c == 'unresolved opportunity'){
            
                o.ownerId =  UserInfo.getUserId(); 
            
            }*/
            
            /*if(o.Status__c != Trigger.oldMap.get(o.Id).Status__c && o.Status__c=='Settled'){
                if(!attLst.isEmpty()){
                    attLstToDel.add(attLst.get(o.Id));
                }
                //List<Attachment> attLst = new List<Attachment>([select id,parentId,OwnerId,Name,Body from Attachment where parentId=:o.Id]);

                //Delete attLst;
              
            }*/
    /*        
            //Opportunities for Settled Emails
            /*
            if(o.Settled_Email_Rules__c != Trigger.oldMap.get(o.Id).Settled_Email_Rules__c){
              oppSettedEmailMap.put(o, o.Settled_Email_Rules__c);
            }*/
     /*       // if there's a finance product then add it to the lookup
            if (oppLists.containsKey(o.Id) && oppLists.get(o.Id).Products__r != null)
            {
                for (Product__c p : oppLists.get(o.Id).Products__r)
                {
                    o.Loan_Product__c = p.Id;        
                }                             
            }
            
            // find if all required documents have been attached but only if the status is not settled
            if(o.Status__c != Trigger.oldMap.get(o.Id).Status__c){
              
            
              if (o.Status__c != 'Settled')
              {
                  //o.All_Documents_Attached__c = true;
                  
                  // find the document types that have been added                                                                
                  /*Set<String> docTypes = new Set<String>();   
                  if (oppLists.containsKey(o.Id) && oppLists.get(o.Id).Required_Documents__r != null){
                    
                                       
                      for (Required_Document__c d : oppLists.get(o.Id).Required_Documents__r)
                      {
                          docTypes.add(d.Type__c);        
                      }  
                  } */                                    
     /*         }
              // otherwise if the new status is settled then all products against the opportunity must have an invoice
              else
              { 
                  /*if(!attLst.isEmpty()){
                      attLstToDel.add(attLst.get(o.Id));
    /*              }*/
    /*              if (o.Id != null && products.containsKey(o.Id))
                  {
                      for (Product__c p : products.get(o.Id))
                      {
                        if(Test.isRunningTest()){
                            //System.assertEquals(null, p.Invoices__r);
                            System.debug('Pass2 p.Invoices__r:' + p.Invoices__r.size() + ':' + p.Id);
                        }
                          if (p.Invoices__r.size() == 0)
                          {
                              o.addError('All products must have an invoice before the opportunity can be settled');
                          }
                      }
                  }
                  if (o.Id != null && isSettlementsTeam){
                      if(cloudDocs.containsKey(o.Id)){
                          System.debug('cloudDocs::' + cloudDocs.get(o.Id));
                          if(cloudDocs.get(o.Id).size() < 2){
                              o.Account__c.addError('Final Signed Documents and Lender Settlement Confirmation Documents should be uploaded before an opportunity status is Settled.');
                          } else {
                              if(!(hasLenderSett.get(o.Id)) || !(hasFinalDocs.get(o.Id))){
                                  o.Account__c.addError('Final Signed Documents and Lender Settlement Confirmation Documents should be uploaded before an opportunity status is Settled.');
                              }
                              
                          }
                      } else {
                          o.Account__c.addError('Final Signed Documents and Lender Settlement Confirmation Documents should be uploaded before an opportunity status is Settled.');
                      }
                  }
              }       
            }        
        } 
        /*else if (Trigger.isInsert)
        {
            // if there's a previously settled opportunity for the account then copy some details across
            if (accounts.containsKey(o.Account__c))
            {
                for (Custom_Opportunity__c prev : accounts.get(o.Account__c).Opportunities__r)
                {
                    o.Occupation__c = prev.Occupation__c;
                    o.Occupation_Status__c = prev.Occupation_Status__c;
                    o.Applicant_Net_Income__c = prev.Applicant_Net_Income__c;
                    o.Co_Borrower_Net_Income__c = prev.Co_Borrower_Net_Income__c;
                    o.Other_Income__c = prev.Other_Income__c;
                    o.Other_Income_Detail__c = prev.Other_Income_Detail__c;
                    o.Mortgage_Rent__c = prev.Mortgage_Rent__c;
                    o.Living_Expenses__c = prev.Living_Expenses__c;
                    o.Existing_Loan_Payments__c = prev.Existing_Loan_Payments__c;
                    o.Credit_Card_Payments__c = prev.Credit_Card_Payments__c;
                    o.Other_Expenses__c = prev.Other_Expenses__c;
                    
                    break;
                }
            }
   /*     }        */ 
    /*}
    /*if(!attLstToDel.isEmpty()){
        try{
            delete attLstToDel;
        } catch (Exception ex){
            System.debug('Error:' + ex.getMessage());
        }
        
    }*/
    /*if (Trigger.isUpdate && Trigger.New.size() == 1) {
        Map<String, Id> etMap = new Map<String, Id>();
        for(EmailTemplate et : SOQLSingletonQueries.recs().getSettledEmailTemplates){
            //[select id, developername from EmailTemplate where developername  like 'Settled%'])
            etMap.put(et.developername, et.Id);
        }
        if(!etMap.isEmpty()){
            if(!oppSettedEmailMap.isEmpty()){
              System.debug('oppSettedEmailMap::');
              SettledEmail setEmail = new SettledEmail();
              setEmail.sendSettledEmails(oppSettedEmailMap, etMap);
            }
        }
    }*/
    

    // The trigger code for Vehicles Direct work
    /*if (Trigger.isUpdate && Trigger.New.size() == 1) {
        Id VDOwnerId = VDAllocation.allocateSettlements();
        Map<Id, User> vdOwnerMap = new Map<Id, User>();
        if(VDOwnerId != null){
            vdOwnerMap = SOQLSingletonQueries.setUserId(VDOwnerId).usersIdMap;
        }
        Map<Id, List<Attachment>> worksheetMap = new Map<Id, List<Attachment>>();
        Map<Id, List<Attachment>> dealerMap = new Map<Id, List<Attachment>>();
        Map<Id, List<Custom_Opportunity__History>> historyMap = new Map<Id, List<Custom_Opportunity__History>>();
        if(!oppIds.isEmpty() && Trigger.New.size() == 1){
            worksheetMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityWorksheetAttachMap;
            dealerMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityDealerAttachMap;
            historyMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityHistoryAttachMap;
        }
        Set<Id> prevOppIds = new Set<Id>();
        for(Id custOppId : historyMap.keySet()){
            List <Custom_Opportunity__History> VDOwnerHistory = historyMap.get(custOppId);
            
            String previousVDOwner = String.valueOf(VDOwnerHistory.get(VDOwnerHistory.size()-1).OldValue);
            if(previousVDOwner != null && previousVDOwner != ''){
            
                Id prevId = Id.valueOf(previousVDOwner);
                if(prevId != null){
                    prevOppIds.add(prevId);
                }
            }
        }
        
        Map<Id, User> prevUserMap = new Map<Id, User>();
        if(!prevOppIds.isEmpty()){
            prevUserMap = SOQLSingletonQueries.setUserIds(prevOppIds).usersIdsMap;
        }
        for (Custom_Opportunity__c VDOpp : Trigger.New) {
            If (VDOpp.VD_Status__c == 'Invoice Requested' && Trigger.oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
                
                User VDOwner;//[SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id =: VDOwnerId];
                if(VDOwnerId != null){
                    VDOwner = vdOwnerMap.get(VDOwnerId);
                    VDOpp.VD_Owner__c = VDOwnerId;
                }
                
                Set<id> reqDocId = new Set<id> ();
                if(Trigger.New.size() == 1){
                    List<Attachment> workSheets = worksheetMap.get(VDOpp.id);//[SELECT id,Name,body,ContentType FROM Attachment WHERE ParentId =: VDOpp.id and Name like '%worksheet%'];
                    
                    
                    EmailSender.sendEmailToVDSet(workSheets, VDOwner, VDOpp);
                }
            }
            
            if (VDOpp.VD_Status__c == 'Sent back to Finance Consultant' && Trigger.oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
                if(Trigger.New.size() == 1){
                    List<Attachment> invoices = dealerMap.get(VDOpp.id);//[SELECT id,Name,body,ContentType FROM Attachment WHERE ParentId =: VDOpp.id and Name like '%Dealer TI%'];
                    //List<Attachment> agreements = [SELECT id,Name,body,ContentType FROM Attachment WHERE ParentId =: VDOpp.id and Name like '%Agreement%'];
                    
                    List <Custom_Opportunity__History> VDOwnerHistory = historyMap.get(VDOpp.Id);//[SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM Custom_Opportunity__History where parentId =: VDOpp.Id and Field = 'VD_Owner__c' ORDER BY CreatedDate ASC];
                    //System.debug('The VDOwnerHistory is: ' + VDOwnerHistory);
                    //System.debug('The OldValue is: ' + VDOwnerHistory.get(VDOwnerHistory.size()-1).OldValue);
                    
                    String previousVDOwner = String.valueOf(VDOwnerHistory.get(VDOwnerHistory.size()-1).OldValue);
                    
                    User previousVD = prevUserMap.get(ID.valueOf(previousVDOwner)); // [SELECT Id,Name,Email FROM User WHERE Id =: ID.valueOf(previousVDOwner)];
                    System.debug('The Previous VD User is: ' + previousVD);
                    EmailSender.sendEmailToOppOwner(invoices, VDOpp); 
                    EmailSender.sendEmailToPreVD(VDOpp, previousVD);
                }
            } 
            
            if (VDOpp.VD_Status__c == 'Send back to Sales Consultant - cannot proceed' && Trigger.oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
                VDOpp.VD_Owner__c = null;
                EmailSender.sendEmailVDFailure(VDOpp);
            }
        }
    }*/

    // When there is application added to the Account/Lead without Opportunity
    /*if (Trigger.isInsert) {
        if (relatedAppId.size() > 0) {
            Map <Id,Application__c> relatedApp = new Map <Id,Application__c> (
                [SELECT Id,No_of_People__c,Marital_Status_1__c,No_of_Dependants_1__c,Email_Address_2__c,
                 First_Name_2__c,Last_Name_2__c,No_of_Dependants_2__c,Do_you_own_a_property__c,
                 Mode_of_Employment_1__c,Current_Occupation_1__c,Net_Income_1__c,Payment_Frequency_1__c,Net_Income_2__c,Payment_Frequency_2__c,
                 Partner_Income__c,Other_Income_Amount_1_1__c,Other_Income_Amount_1_2__c,
                 Other_Income_Amount_1_3__c,Other_Income_Amount_2_1__c,Other_Income_Amount_2_2__c,
                 Other_Income_Amount_2_3__c,Loan_Type_1__c,Loan_Type_2__c,Loan_Type_3__c,
                 Loans_Monthly_Payments_1__c,Loans_Monthly_Payments_2__c,Loans_Monthly_Payments_3__c,
                 Rent_per_month_1__c,Rent_per_month_2__c,Credit_Monthly_Payments_1__c,Credit_Monthly_Payments_2__c,
                 Credit_Monthly_Payments_3__c,Repayment_Regularity__c,Preferred_Repayment__c
                 FROM Application__c WHERE ID in: relatedAppId]);
            for (Custom_Opportunity__c newOpp : Trigger.new) {
                Application__c appBuffer = new Application__c ();
                appBuffer =relatedApp.get(newOpp.Application__c);
                // Sync the Second Applicant info
                if (appBuffer.First_Name_2__c != null) {
                    newOpp.Second_Applicant_First_Name__c = appBuffer.First_Name_2__c;
                }
                if (appBuffer.Last_Name_2__c != null) {
                    newOpp.Second_Applicant_Last_Name__c = appBuffer.Last_Name_2__c;
                }
                if (appBuffer.Email_Address_2__c != null) {
                    newOpp.Second_Applicant_Email__c = appBuffer.Email_Address_2__c;
                }
                // Calculating living expenses depending on Esanda's living expenses (because that's the lowest on the market)
                if (appBuffer.First_Name_2__c == null || appBuffer.Last_Name_2__c == null) {
                    if (appBuffer.Marital_Status_1__c == 'Single') {
                        if (appBuffer.No_of_Dependants_1__c == 0) {
                            newOpp.Living_Expenses__c = 1185;
                        } else if (appBuffer.No_of_Dependants_1__c == 1) {
                            newOpp.Living_Expenses__c = 1525;
                        } else if (appBuffer.No_of_Dependants_1__c == 2) {
                            newOpp.Living_Expenses__c = 1865;
                        } else if (appBuffer.No_of_Dependants_1__c == 3) {
                            newOpp.Living_Expenses__c = 2205;
                        } else if (appBuffer.No_of_Dependants_1__c == 4) {
                            newOpp.Living_Expenses__c = 2545;
                        } else if (appBuffer.No_of_Dependants_1__c == 5) {
                            newOpp.Living_Expenses__c = 2885;
                        } else {
                            newOpp.Living_Expenses__c = 3225;
                        } // end if for Marital_Status_1__c == 'Single'
                    } else {
                        if (appBuffer.No_of_Dependants_1__c == 0) {
                            newOpp.Living_Expenses__c = 2261;
                        } else if (appBuffer.No_of_Dependants_1__c == 1) {
                            newOpp.Living_Expenses__c = 2601;
                        } else if (appBuffer.No_of_Dependants_1__c == 2) {
                            newOpp.Living_Expenses__c = 2941;
                        } else if (appBuffer.No_of_Dependants_1__c == 3) {
                            newOpp.Living_Expenses__c = 3281;
                        } else if (appBuffer.No_of_Dependants_1__c == 4) {
                            newOpp.Living_Expenses__c = 3621;
                        } else if (appBuffer.No_of_Dependants_1__c == 5) {
                            newOpp.Living_Expenses__c = 3961;
                        } else {
                            newOpp.Living_Expenses__c = 4301;
                        }
                    } // end else for Marital_Status_1__c == 'Single'
                    // end if for First_Name_2__c == null || Last_Name_2__c == null
                } else {
                    if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 0) {
                        newOpp.Living_Expenses__c = 2261;
                    } else if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 1) {
                        newOpp.Living_Expenses__c = 2601;
                    } else if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 2) {
                        newOpp.Living_Expenses__c = 2941;
                    } else if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 3) {
                        newOpp.Living_Expenses__c = 3281;
                    } else if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 4) {
                        newOpp.Living_Expenses__c = 3621;
                    } else if ((appBuffer.No_of_Dependants_1__c + appBuffer.No_of_Dependants_2__c) == 5) {
                        newOpp.Living_Expenses__c = 3961;
                    } else {
                        newOpp.Living_Expenses__c = 4301;
                    }
                }  // end else for First_Name_2__c == null || Last_Name_2__c == null
                // map into Do_you_own_a_property__c field
                if (appBuffer.Do_you_own_a_property__c == 'yes') {
                    newOpp.Is_your_client_a_Property_Owner__c = 'Yes';
                }
                // map into Occupation_Status__c field
                if (appBuffer.Mode_of_Employment_1__c != null) {
                    if (appBuffer.Mode_of_Employment_1__c == 'Full Time') {
                        newOpp.Occupation_Status__c = 'Full-Time';
                    } else if (appBuffer.Mode_of_Employment_1__c == 'Part Time') {
                        newOpp.Occupation_Status__c = 'Part-Time';
                    } else if (appBuffer.Mode_of_Employment_1__c == 'Casual') {
                        newOpp.Occupation_Status__c = 'Casual';
                    } else if (appBuffer.Mode_of_Employment_1__c == 'Self Employed') {
                        newOpp.Occupation_Status__c = 'Self Employment';
                    } else if (appBuffer.Mode_of_Employment_1__c == 'Contract') {
                        newOpp.Occupation_Status__c = 'Contract';
                    } else {
                        newOpp.Occupation_Status__c = 'Other';
                    }
                }
                // map into Number_of_Dependents__c field
                if (appBuffer.No_of_Dependants_2__c != null) {
                    newOpp.Number_of_Dependents__c = String.valueOf(appBuffer.No_of_Dependants_1__c.intValue() + appBuffer.No_of_Dependants_2__c.intValue());
                } else {
                    newOpp.Number_of_Dependents__c = String.valueOf(appBuffer.No_of_Dependants_1__c.intValue());
                }
                // make other expenses zero
                newOpp.Other_Expenses__c = 0;
                
                // Make workflow rules into apex code
                // Occupation
                newOpp.Occupation__c = appBuffer.Current_Occupation_1__c;
                // Net Income for Applicant 1
                if (appBuffer.Payment_Frequency_1__c == 'Weekly') {
                    newOpp.Applicant_Net_Income__c = appBuffer.Net_Income_1__c * 4.33;
                } else if (appBuffer.Payment_Frequency_1__c == 'Fortnightly') {
                    newOpp.Applicant_Net_Income__c = appBuffer.Net_Income_1__c / 2 * 52 / 12;
                } else if (appBuffer.Payment_Frequency_1__c == 'Monthly') {
                    newOpp.Applicant_Net_Income__c = appBuffer.Net_Income_1__c;
                }
                // Net Income for Applicant 2 or Partner Income
                if (appBuffer.No_of_People__c == 2) {
                    if (appBuffer.Payment_Frequency_2__c == 'Weekly') {
                        newOpp.Co_Borrower_Net_Income__c = appBuffer.Net_Income_2__c * 4.33;
                    } else if (appBuffer.Payment_Frequency_2__c == 'Fortnightly') {
                        newOpp.Co_Borrower_Net_Income__c = appBuffer.Net_Income_2__c / 2 * 52 / 12;
                    } else if (appBuffer.Payment_Frequency_2__c == 'Monthly') {
                        newOpp.Co_Borrower_Net_Income__c = appBuffer.Net_Income_2__c;
                    }
                    
                } else {
                    newOpp.Co_Borrower_Net_Income__c = appBuffer.Partner_Income__c;
                }
                // Other Income
                Decimal otherIncomes = 0;
                if (appBuffer.Other_Income_Amount_1_1__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_1_1__c;
                }
                if (appBuffer.Other_Income_Amount_1_2__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_1_2__c;
                }
                if (appBuffer.Other_Income_Amount_1_3__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_1_3__c;
                }
                if (appBuffer.Other_Income_Amount_2_1__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_2_1__c;
                }
                if (appBuffer.Other_Income_Amount_2_2__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_2_2__c;
                }
                if (appBuffer.Other_Income_Amount_2_3__c != null) {
                    otherIncomes += appBuffer.Other_Income_Amount_2_3__c;
                }
                newOpp.Other_Income__c = otherIncomes;
                // Other Income Detail
                if (newOpp.Other_Income__c == 0) {
                    newOpp.Other_Income_Detail__c = 'Nothing';
                } else {
                    newOpp.Other_Income_Detail__c = 'Other Income';
                }
                // Rent/Mortgage
                Decimal sumMortgage = 0.0;
                if (appBuffer.Loan_Type_1__c == 'Mortgage') {
                    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_1__c;
                }
                if (appBuffer.Loan_Type_2__c == 'Mortgage') {
                    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_2__c;
                }
                if (appBuffer.Loan_Type_3__c == 'Mortgage') {
                    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_3__c;
                }
                Decimal totalRent = 0;
                if (appBuffer.Rent_per_month_1__c != null) {
                    totalRent += appBuffer.Rent_per_month_1__c;
                }
                if (appBuffer.Rent_per_month_2__c != null) {
                    totalRent += appBuffer.Rent_per_month_2__c;
                }
                newOpp.Mortgage_Rent__c = totalRent + sumMortgage;
                // Loan
                Decimal sumLoan = 0.0;
                if (appBuffer.Loan_Type_1__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_1__c != null) {
                    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_1__c;
                }
                if (appBuffer.Loan_Type_2__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_2__c != null) {
                    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_2__c;
                }
                if (appBuffer.Loan_Type_3__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_3__c != null) {
                    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_3__c;
                }
                newOpp.Existing_Loan_Payments__c = sumLoan;
                // Credit Card
                Decimal totalCreditCard = 0;
                if (appBuffer.Credit_Monthly_Payments_1__c !=  null) {
                    totalCreditCard += appBuffer.Credit_Monthly_Payments_1__c;
                }
                if (appBuffer.Credit_Monthly_Payments_2__c !=  null) {
                    totalCreditCard += appBuffer.Credit_Monthly_Payments_2__c;
                }
                if (appBuffer.Credit_Monthly_Payments_3__c !=  null) {
                    totalCreditCard += appBuffer.Credit_Monthly_Payments_3__c;
                }
                newOpp.Credit_Card_Payments__c = totalCreditCard;
                // This Commitment
                if (appBuffer.Repayment_Regularity__c == 'Week') {
                    newOpp.This_Commitment__c = appBuffer.Preferred_Repayment__c * 4.33;
                } else if (appBuffer.Repayment_Regularity__c == 'Fortnight') {
                    newOpp.This_Commitment__c = appBuffer.Preferred_Repayment__c * 13 / 6;
                } else {
                    newOpp.This_Commitment__c = appBuffer.Preferred_Repayment__c;
                }
                    
                // have a try to generate the doc
                // newOpp.Status__c = 'Application Forms Received';
                // Need to figure out a way to control the document generation
                try {
                    //SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+newOpp.id+'&Object=Custom_Opportunity__c&doclist=a07N0000006LbCU&oneclick=1');
                    SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+newOpp.id+'&Object=Custom_Opportunity__c&doclist=a049000000MeNTr&oneclick=1');
                } catch(Exception e) {
                     
                }
            } //end for loop
        } //end if for relatedAppId.size() > 0
    } //end if for Trigger.isInsert*/
}