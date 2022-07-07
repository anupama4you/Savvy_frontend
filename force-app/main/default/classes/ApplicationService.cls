public class ApplicationService {

    public static final String APP_STATUS_SAVEDLATER = 'STL';
    public static final String APP_STATUS_UNFINISHED = 'U';
    public static final String APP_STATUS_FINISHED = 'F';
    public static final String APP_STATUS_FLOWFILLED = 'FF';

    public static final String PROPERTY_ASSET_TYPE = 'Property Asset';
    public static final String VEHICLE_ASSET_TYPE = 'Vehicle Asset';
    public static final String OTHER_ASSET_TYPE = 'Other Asset';

    public static void changeFieldValues(List<Application__c> newList){
    	System.debug('changeFieldValues...' + newList);
    	for (Application__c newApp : newList) {
    		// Change the Application_name into some meaningful names
    		if ((newApp.First_Name__c != null) && (newApp.Last_Name__c != null)) {
    			newApp.Name = newApp.First_Name__c + ' ' + newApp.Last_Name__c;
    		}
    		// Some small mod to make the data better presented
    		if (newApp.Mobile_Number__c != null){
    			newApp.Mobile_Number__c = newApp.Mobile_Number__c.replace(' ','');
    		}

        // External leads
        System.debug('searching the most recent Lead...');
        Lead__c extLead = LeadService.getRecentExternalLead(
            newApp.Mobile_Number__c, newApp.Email_Address__c);
        if (extLead != null) {
          System.debug('Lead: ' + extLead.Id + ' | ' + extLead.Partner_Owner__c);
          newApp.External_Lead__c = true;
          if (
            String.isBlank(newApp.Partner_Owner__c) &&
            String.isNotBlank(extLead.Partner_Owner__c)
          ) {
            newApp.Partner_Owner__c = extLead.Partner_Owner__c;
            newApp.OwnerId = extLead.OwnerId;
          }
        }

        if (String.isBlank(newApp.Partner_Owner__c)) {
          Custom_Opportunity__c opp = SOQLSingletonQueries.getMostRecentOpportunityByEmail(
            newApp.Email_Address__c);
          if (opp != null && String.isNotBlank(opp.Partner_Owner__c)) {
            newApp.Partner_Owner__c = opp.Partner_Owner__c;
            newApp.OwnerId = opp.OwnerId;
          }
        }

        if (
          String.isNotBlank(newApp.Partner_Owner__c) &&
          !SOQLSingletonQueries.recs().isBrokerPartnerUser &&
          newApp.OwnerId == UserInfo.getUserId()
        ) {
          Id ownerId = SOQLSingletonQueries.getPartnerDefaultOwner(newApp.Partner_Owner__c);
          if (String.isNotBlank(ownerId)) {
            newApp.OwnerId = ownerId;
          }
        }

    	}
    }
    
    public static void updateRelatedAccount(List<Application__c> newList){
    	System.debug('updateRelatedAccount...' + newList);
    	// Use Email Address to identify the Account to match the Application
    	Set <String> AppEmails = new Set <String> ();
    	
    	for (Application__c newApp : newList) {
    		if(newApp.Email_Address__c != null){
    			AppEmails.add(newApp.Email_Address__c);
    		}   
	    }
	    if(!AppEmails.isEmpty()){
            User sysGen =SOQLSingletonQueries.recs().sysGenUser;
	    	// The list to check for the situation App email matches the Opp but not the Acc
	    	List <Custom_Opportunity__c> OppMatchList = SOQLSingletonQueries.setEmailAddresses(AppEmails).opportunitiesByEmailAddresses;// [SELECT id,Name,Email_Address__c FROM Custom_Opportunity__c WHERE Email_Address__c in: AppEmails];
	    	// Prepare the Account map to match the Email addresses
	    	Map <String, Account> matchingAccMap = new Map <String, Account> ();
	    	// Prepare the Account list to update Accounts
	    	//List <Account> AccToUpdate = new List <Account> ();
	    	Map<Id, Account> mccToUpdateMap = new Map<Id, Account>();
	    	
	    	for (Account acc : SOQLSingletonQueries.setPersonEmails(AppEmails).accountsByPersonEmails){//[Select Id, PersonEmail, OwnerId From Account Where PersonEmail IN : AppEmails]) 
	    		matchingAccMap.put(acc.PersonEmail, acc);
	    	}
	    	// If there is Opp matching the App but no Account to match it
	    	if (matchingAccMap.isEmpty() && !OppMatchList.isEmpty()) {
	    		EmailSender.sendEmailAppOppNoAcc(newList);
	    	}
	    	
	    	for (Application__c newApp : newList) {
	    		if (matchingAccMap.containsKey(newApp.Email_Address__c)) {
            // 
            Account accBuffer = matchingAccMap.get(newApp.Email_Address__c);
            // Verify account ownership
            Boolean linkAccount = (
              (
                String.isBlank(newApp.Partner_Owner__c) &&
                String.isBlank(accBuffer.Partner_Owner__c)
              ) || (
                String.isNotBlank(newApp.Partner_Owner__c) &&
                newApp.Partner_Owner__c.equals(accBuffer.Partner_Owner__c) 
              )
            );
            if (linkAccount) {
              // Link Account to Application
              newApp.Account__c = accBuffer.Id;
              // Original OwnerId App
              Id appOwnerId = newApp.OwnerId;
              // Change the Application Owner to be the Account Owner
              if (accBuffer.OwnerId != newApp.OwnerId) {
                newApp.OwnerId = accBuffer.OwnerId;
              }
              /* Make the Account related address equal to Application Address
                * For unknown reason, "if" expressions are not able to run
                * The initial idea was to check whether the addresses are blank
                * If this does not work at last, in the document generating rule
                * we can use Application address instead of Account address 
                */
              accBuffer.Street_Address__c = newApp.Street_Address__c;
              accBuffer.Suburb__c = newApp.Suburb__c;
              accBuffer.Postcode__c = newApp.Postcode__c;
              accBuffer.ABN__c = newApp.Business_ABN__c;
              
              //check for Inactive users
              if (!SOQLSingletonQueries.isActiveUser(accBuffer.OwnerId)) {
                Id newOwnerId = String.isNotBlank(newApp.Partner_Owner__c) ? appOwnerId : sysGen.Id;
                accBuffer.OwnerId = newOwnerId;
                newApp.OwnerId = newOwnerId;
              }
              
              //AccToUpdate.add(accBuffer);
              mccToUpdateMap.put(accBuffer.Id, accBuffer);
            }
	    		}
	    	}
	    	//if(!AccToUpdate.isEmpty()){
	    	if(!mccToUpdateMap.isEmpty()){
	    		update mccToUpdateMap.values();
	    	}
	    }
	    
    }
    
    private static Boolean shouldUpdateOppApp(String currentAppStatus, String newAppStatus) {
        Boolean r = false;
        System.debug('String currentAppStatus, String newAppStatus >>>>>>>>>>>>>>> ' + currentAppStatus +' '+ newAppStatus);
        if (String.isBlank(currentAppStatus) || !APP_STATUS_FINISHED.equals(currentAppStatus)) {
            r = true;
        } else if (APP_STATUS_FINISHED.equals(currentAppStatus) && APP_STATUS_FINISHED.equals(newAppStatus)) {
            r = true;
        }
        System.debug('shouldUpdateOppApp: ' + currentAppStatus + '|' + newAppStatus + '|' + r);
        return r;
    }

    public static void linkApplication(List<Application__c> newList){
        Boolean linkDone = false;
        Set<Id> accountIds = new Set<Id>();
        User sysGen = SOQLSingletonQueries.recs().sysGenUser;
        User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
        // list for opps to be updated
        List <Custom_Opportunity__C> oppToUpdate = new List <Custom_Opportunity__c> ();
        List <Lead__C> leadToUpdate = new List <Lead__C> ();
        List <Lead__C> leadToCreate = new List <Lead__C> ();
        
        Set<String> phones = new Set<String>();
        Set<String> emails = new Set<String>();
        System.debug('Getting Account Ids, phones and emails...');
        for (Application__c a : newList) {
            if (a.Account__c != null) {
            	accountIds.add(a.Account__c);
            }
            phones.add(a.Mobile_Number__c);     // prepare phones
            emails.add(a.Email_Address__c);     // prepare emails
        }
        System.debug('Accounts: ' + accountIds.size() + ' | Phones: ' + phones.size() +  ' | Emails: ' + emails.size());
        Map<Id, List<Custom_Opportunity__c>> accountOpps = new Map<Id, List<Custom_Opportunity__c>>();
        if (!accountIds.isEmpty()) {
            System.debug('Getting recent Opportunities by Account...');
            accountOpps = SOQLSingletonQueries.getOpportunitiesByAccount(accountIds);
            System.debug('Total records: ' + accountOpps.size());
        }
        Map<Id, Lead__c> accountLeads = null;
        Map<String, Custom_Opportunity__c> oppList = null;
        Map<String, Lead__c> leadList = null;
		
        // Check new Applications
        for (Application__c app : newList) {
            System.debug('Checking application: ' + app.Name + ' | ' + app.Mobile_Number__c + ' | ' + app.Email_Address__c + ' | ' + app.Account__c); 
            if (!APP_STATUS_FLOWFILLED.equals(app.Status__c)) {
                if (app.Account__c != null) {
                    // Search by Account
                    System.debug('Searching by Account...');
                    //Opportunity
                    if (accountOpps.containsKey(app.Account__c)) {
                        for (Custom_Opportunity__c opp : accountOpps.get(app.Account__c)) {
                            if (!linkDone) {
                                if (shouldUpdateOppApp(opp.Application__r.Status__c, app.Status__c)) {
                                    opp.Application__c = app.Id;
                                    updateOpportunityDataFromApp(opp, app);
                                    oppToUpdate.add(opp);
                                }
                                if('Closed Opportunity'.equals(opp.Status__c)){
                            		EmailSender.sendEmailAppNotificationForOpportunityClosed(opp);
                                }
                                linkDone = true;
                            }
                        }
                    }
                    System.debug('Opportunity found it: ' + linkDone);
                    if (!linkDone) {
                        // Lead
                        if (accountLeads == null) {
                            accountLeads = SOQLSingletonQueries.getLeadsByAccount(accountIds);
                        }
                        Lead__c l = accountLeads.get(app.Account__c);
                        if (l != null) {
                            l.Application__c = app.Id;
                            leadToUpdate.add(l);
                            linkDone = true;
                        }
                        System.debug('Lead found it: '+ linkDone);
                    }
                    // if (!linkDone) {
                    //     if (app.Account__c != sysGen.Id && app.Account__c != savvyAdmin.Id) {
                    //         System.debug('Sending notification...');
                    //         EmailSender.sendEmailAppAccNoOpp(app);
                    //     }
                    // }
                } 
                if (!linkDone) {
                    System.debug('Searching by phones and emails');
                    //Search by phone and email
                    if (oppList == null) {
                        System.debug('Loading opportunities...');
                        //get the most recent Opportunity for every phone or email given
                        oppList = SOQLSingletonQueries.getOpportunitiesByPhoneOrEmail(phones, emails);
                        System.debug('Total records: ' + oppList.size());
                    }
                    // check Opportunities
                    if (oppList.containsKey(app.Mobile_Number__c)) {
                        Custom_Opportunity__c opp = oppList.get(app.Mobile_Number__c);
                        if (shouldUpdateOppApp(opp.Application__r.Status__c, app.Status__c)) {
                            opp.Application__c = app.Id;
                            updateOpportunityDataFromApp(opp, app);
                            oppToUpdate.add(opp);
                        }
                        if('Closed Opportunity'.equals(opp.Status__c)){
                            EmailSender.sendEmailAppNotificationForOpportunityClosed(opp);        
                        }
                        linkDone = true;
                    }
                    System.debug('Opportunity found it: ' + linkDone);
                    if (!linkDone) {
                        // check Leads
                        if (leadList == null) {
                            System.debug('Loading leads...');
                            //get the most recent lead for every phone or email given
                            leadList = SOQLSingletonQueries.getLeadsByPhoneOrEmail(phones, emails);
                            System.debug('Total records: ' + leadList.size());
                        }
                        Lead__c l = null;
                        if (leadList.containsKey(app.Mobile_Number__c)) {
                            l = leadList.get(app.Mobile_Number__c);
                        } else if (leadList.containsKey(app.Email_Address__c)) {
                            l = leadList.get(app.Email_Address__c);
                        }
                        if (l != null) {
                            l.Application__c = app.Id;
                            leadToUpdate.add(l);
                            linkDone = true;
                        }
                        System.debug('Lead found it: ' + linkDone);
                    }
                }
                if(!linkDone) {
                    // Create a new Lead
                    System.debug('Creating a new Lead...');
                    Lead__c newLead = new Lead__c ();
                    newLead.Application__c = app.id;
                    Id ownerId = app.OwnerId;
                    newLead.Account__c = app.Account__c;
                    if (!SOQLSingletonQueries.isActiveUser(ownerId)) {
                        ownerId = sysGen.Id;
                    }
                    newLead.Status__c = 'New Lead';
                    newLead.OwnerId = ownerId;
                    newLead.First_Name__c = app.First_Name__c;
                    newLead.Last_Name__c = app.Last_Name__c;
                    newLead.Middle_Name__c = app.Middle_Name__c;
                    newLead.Mobile_Number__c = app.Mobile_Number__c;
                    newLead.Email_Address__c = app.Email_Address__c;
                
                    newLead.Lead_Source__c = 'Savvy Direct Program';
                    newLead.Employment_Status__c = app.Mode_of_Employment_1__c;
                    if (app.Date_of_Birth_1__c != null) {
                        newLead.Date_of_Birth__c = Date.parse(app.Date_of_Birth_1__c);
                    }
                    newLead.Street_Address__c = app.Street_Address__c;
                    newLead.Suburb__c = app.Suburb__c;
                    newLead.Postcode__c = app.Postcode__c;
                    newLead.Home_Phone__c = app.Home_Phone__c;
                    newLead.Work_Phone__c = app.Work_Phone__c;
                    newLead.Finance_Amount__c = 0;
                    if (app.Finance_Amount__c != null) {
                        newLead.Finance_Amount__c = app.Finance_Amount__c;
                    }
                    newLead.Property_Owner__c = app.Do_you_own_a_property__c;
                    newLead.Vehicle_Year__c = app.Vehicle_Year__c;
                    newLead.Vehicle_Make__c = app.Vehicle_Make__c;
                    newLead.Vehicle_Model__c = app.Vehicle_Model__c;
                    newLead.Length_of_Term__c = app.Length_of_Term__c;
                    newLead.Loan_Type__c = LeadService.getLoanTypeFormApp(app.Type_of_Asset__c);
                    newLead.Loan_For__c = app.Type_of_Asset__c;
                    newLead.Credit_History__c = app.Credit_Status_1__c;
                    newLead.Partner_Owner__c = app.Partner_Owner__c;
                    if (String.isNotBlank(app.Partner_Owner__c)) {
                      newLead.OwnerId = app.OwnerId;
                    }
                    leadToCreate.add(newLead);  
                }
            }
        }
        System.debug('Opportunities to update: ' + oppToUpdate.size());
        System.debug('Leads to update        : ' + leadToUpdate.size());
        System.debug('Leads to create        : ' + leadToCreate.size());
        //try {
            if (!oppToUpdate.isEmpty()) {
                update oppToUpdate;
                //Checking for supporting documents
                OpportunityService.uploadS3ApplicationDocs(oppToUpdate, new Map<Id, Custom_Opportunity__c>());
            } else if (!leadToUpdate.isEmpty()) {
                update leadToUpdate;
            } else if (!leadToCreate.isEmpty()) {
                // Prepare records
                LeadService.invokeCallCenterProcesses(leadToCreate);
                insert leadToCreate;
                // Send lead
                LeadService.callCenterService(leadToCreate, false);
            }
        //} catch( Exception e){
        //    System.debug('@@ERROR:' + e.getMessage());
        //}
    }

    public static String getApplicationAssetType(Id appId) {
        String r = null;
        if (appId != null) {
            List<Application__c> d = [
                SELECT Type_of_Asset__c FROM Application__c WHERE Id = :appId
            ];
            if (!d.isEmpty()) {
                r = d.get(0).Type_of_Asset__c;
            }
        }
        return r;
    }

    public class Asset {
        public String assetType {set;get;}      //Property (P) or Vehicle (V)
        public String detail {set;get;}
        public Decimal value {set;get;}
        public String hasLoan {set;get;}
        public String loanType {set;get;}
        public String lender {set;get;}
        public Decimal amountOwing {set;get;}
        public Decimal payment {set;get;}
        public String frequency {set;get;}
        public Boolean isPayout {set;get;}
        public Integer order {set;get;}

        public Asset(String assetType) {
            this.assetType = assetType;
        }
    }    

    public static List<Application_Loan__c> getApplicationLoans(Id appId) {
        List<Application_Loan__c> r = new List<Application_Loan__c>();
        if (appId != null) {
            r = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c, 
                        Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c,
                        Order__c 
                 FROM Application_Loan__c WHERE Application__c = :appId ORDER BY Order__c];
        }
        return r;
    }
        
    public static void updateOpportunityDataFromApp(Custom_Opportunity__c opp, Application__c app) {
        if (opp != null && app != null) {
            System.debug('Updating Opportunity details from appId: ' + app.Id);
            // Sync with Opportunity Sencond Applicant info
            if (app.First_Name_2__c != null) {
                opp.Second_Applicant_First_Name__c = app.First_Name_2__c;
            }
            if (app.Last_Name_2__c != null) {
                opp.Second_Applicant_Last_Name__c = app.Last_Name_2__c;
            }
            if (app.Email_Address_2__c != null) {
                opp.Second_Applicant_Email__c = app.Email_Address_2__c;
            }
            
            // might use in update
            // Calculating living expenses depending on Esanda's living expenses (because that's the lowest on the market)
            
            if (app.First_Name_2__c == null || app.Last_Name_2__c == null) {
                if (app.Marital_Status_1__c == 'Single') {
                    if (app.No_of_Dependants_1__c == 0) {
                        opp.Living_Expenses__c = 1185;
                    } else if (app.No_of_Dependants_1__c == 1) {
                        opp.Living_Expenses__c = 1525;
                    } else if (app.No_of_Dependants_1__c == 2) {
                        opp.Living_Expenses__c = 1865;
                    } else if (app.No_of_Dependants_1__c == 3) {
                        opp.Living_Expenses__c = 2205;
                    } else if (app.No_of_Dependants_1__c == 4) {
                        opp.Living_Expenses__c = 2545;
                    } else if (app.No_of_Dependants_1__c == 5) {
                        opp.Living_Expenses__c = 2885;
                    } else {
                        opp.Living_Expenses__c = 3225;
                    } // end if for Marital_Status_1__c == 'Single'
                } else {
                    if (app.No_of_Dependants_1__c == 0) {
                        opp.Living_Expenses__c = 2261;
                    } else if (app.No_of_Dependants_1__c == 1) {
                        opp.Living_Expenses__c = 2601;
                    } else if (app.No_of_Dependants_1__c == 2) {
                        opp.Living_Expenses__c = 2941;
                    } else if (app.No_of_Dependants_1__c == 3) {
                        opp.Living_Expenses__c = 3281;
                    } else if (app.No_of_Dependants_1__c == 4) {
                        opp.Living_Expenses__c = 3621;
                    } else if (app.No_of_Dependants_1__c == 5) {
                        opp.Living_Expenses__c = 3961;
                    } else {
                        opp.Living_Expenses__c = 4301;
                    }
                }
            } else {
                if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 0) {
                    opp.Living_Expenses__c = 2261;
                } else if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 1) {
                    opp.Living_Expenses__c = 2601;
                } else if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 2) {
                    opp.Living_Expenses__c = 2941;
                } else if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 3) {
                    opp.Living_Expenses__c = 3281;
                } else if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 4) {
                    opp.Living_Expenses__c = 3621;
                } else if ((app.No_of_Dependants_1__c + app.No_of_Dependants_2__c) == 5) {
                    opp.Living_Expenses__c = 3961;
                } else {
                    opp.Living_Expenses__c = 4301;
                }
            } // end else for First_Name_2__c == null || Last_Name_2__c == null
            // map into Do_you_own_a_property__c field
            if (app.Do_you_own_a_property__c == 'yes') {
                opp.Is_your_client_a_Property_Owner__c = 'Yes';
            }
            
            // map into Occupation_Status__c field
            if (app.Mode_of_Employment_1__c != null) {
                if (app.Mode_of_Employment_1__c == 'Full Time') {
                    opp.Occupation_Status__c = 'Full-Time';
                } else if (app.Mode_of_Employment_1__c == 'Part Time') {
                    opp.Occupation_Status__c = 'Part-Time';
                } else if (app.Mode_of_Employment_1__c == 'Casual') {
                    opp.Occupation_Status__c = 'Casual';
                } else if (app.Mode_of_Employment_1__c == 'Self Employed') {
                    opp.Occupation_Status__c = 'Self Employment';
                } else if (app.Mode_of_Employment_1__c == 'Contract') {
                    opp.Occupation_Status__c = 'Contract';
                } else {
                    opp.Occupation_Status__c = 'Other';
                }
            }
            // map into Number_of_Dependents__c field
            Integer totalDependants = 0;
            if (app.No_of_Dependants_1__c != null) {
                totalDependants = app.No_of_Dependants_1__c.intValue();
            }
            if (app.No_of_Dependants_2__c != null) {
                totalDependants  += app.No_of_Dependants_2__c.intValue();
            }
            opp.Number_of_Dependents__c = String.valueOf(totalDependants);
            
            // make other expenses zero
            opp.Other_Expenses__c = 0;
            
            // Make workflow rules into apex code
            // Occupation
            opp.Occupation__c = app.Current_Occupation_1__c;
            // Net Income for Applicant 1
            if (app.Payment_Frequency_1__c == 'Weekly') {
                opp.Applicant_Net_Income__c = app.Net_Income_1__c * 4.33;
            } else if (app.Payment_Frequency_1__c == 'Fortnightly') {
                opp.Applicant_Net_Income__c = app.Net_Income_1__c / 2 * 52 / 12;
            } else if (app.Payment_Frequency_1__c == 'Monthly') {
                opp.Applicant_Net_Income__c = app.Net_Income_1__c;
            }
            // Net Income for Applicant 2 or Partner Income
            if (app.No_of_People__c == 2) {
                if (app.Payment_Frequency_2__c == 'Weekly') {
                    opp.Co_Borrower_Net_Income__c = app.Net_Income_2__c * 4.33;
                } else if (app.Payment_Frequency_2__c == 'Fortnightly') {
                    opp.Co_Borrower_Net_Income__c = app.Net_Income_2__c / 2 * 52 / 12;
                } else if (app.Payment_Frequency_2__c == 'Monthly') {
                    opp.Co_Borrower_Net_Income__c = app.Net_Income_2__c;
                }
            } else {
                opp.Co_Borrower_Net_Income__c = app.Partner_Income__c;
            }
            // Other Income
            Decimal otherIncomes = 0;
            opp.Other_Income__c = otherIncomes;
            // Other Income Detail
            if (opp.Other_Income__c == 0) {
                opp.Other_Income_Detail__c = 'Nothing';
            } /*else {
                opp.Other_Income_Detail__c = 'Other Income';
            }*/
            // Rent/Mortgage
            Decimal sumMortgage = 0.0;
            //if (app.Loan_Type_1__c == 'Mortgage') {
            //    sumMortgage = sumMortgage + app.Loans_Monthly_Payments_1__c;
            //}
            //if (app.Loan_Type_2__c == 'Mortgage') {
            //    sumMortgage = sumMortgage + app.Loans_Monthly_Payments_2__c;
            //}
            //if (app.Loan_Type_3__c == 'Mortgage') {
            //    sumMortgage = sumMortgage + app.Loans_Monthly_Payments_3__c;
            //}
            Decimal totalRent = 0;
            if (app.Rent_per_month_1__c != null) {
                totalRent += app.Rent_per_month_1__c;
            }
            if (app.Rent_per_month_2__c != null) {
                totalRent += app.Rent_per_month_2__c;
            }
            opp.Mortgage_Rent__c = totalRent + sumMortgage;
            // Loan
            Decimal sumLoan = 0.0;
            //if (app.Loan_Type_1__c != 'Mortgage' && app.Loans_Monthly_Payments_1__c != null) {
            //    sumLoan = sumLoan + app.Loans_Monthly_Payments_1__c;
            //}
            //if (app.Loan_Type_2__c != 'Mortgage' && app.Loans_Monthly_Payments_2__c != null) {
            //    sumLoan = sumLoan + app.Loans_Monthly_Payments_2__c;
            //}
            //if (app.Loan_Type_3__c != 'Mortgage' && app.Loans_Monthly_Payments_3__c != null) {
            //    sumLoan = sumLoan + app.Loans_Monthly_Payments_3__c;
            //}
            opp.Existing_Loan_Payments__c = sumLoan;
            // Credit Card
            Decimal totalCreditCard = 0;
            opp.Credit_Card_Payments__c = totalCreditCard;
            // This Commitment
            if (app.Repayment_Regularity__c == 'Week') {
                opp.This_Commitment__c = app.Preferred_Repayment__c * 4.33;
            } else if (app.Repayment_Regularity__c == 'Fortnight') {
                opp.This_Commitment__c = app.Preferred_Repayment__c * 13 / 6;
            } else {
                opp.This_Commitment__c = app.Preferred_Repayment__c;
            }
            
            // have a try to generate the doc
            // opp.Status__c = 'Application Forms Received';
            // Need to figure out a way to control the document generation
            // if (app.Net_Income_1__c != null && app.Net_Income_1__c > 0) {
            //     try {
            //         //SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+opp.id+'&Object=Custom_Opportunity__c&doclist=a07N0000006LbCU&oneclick=1');
            //         SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+opp.id+'&Object=Custom_Opportunity__c&doclist=a049000000MeNTr&oneclick=1');
            //     } catch(Exception e) {
            
            //     }
            // }
        }
    }

    public static ServicingCalcHelper.Parameter prepareServicingInfo(Id appId) {
        ServicingCalcHelper.Parameter param = null;
        if (appId == null) return param;
        param = new ServicingCalcHelper.Parameter();
        List<Application__c> appLst = [
            SELECT 
                   Net_Income_1__c, Payment_Frequency_1__c, Net_Income_2__c, Payment_Frequency_2__c,
                   No_of_People__c, Rent_per_month_1__c, Board_per_month_1__c, Current_Residence_Status_1__c, 
                   Residential_Payment_Frequency_1__c, Marital_Status_1__c, No_of_Dependants_1__c
            FROM Application__c WHERE Id = :appId
        ];
        param.totalLiabilities = 0.0;
        param.totalRentMortgageBoard = 0.0;
        if (!appLst.isEmpty()) {
            Application__c app = appLst.get(0);
            //Marital status
            if (String.isNotBlank(app.Marital_Status_1__c)) {
                param.maritalStatus = app.Marital_Status_1__c;
            }
            //Dependants
            if (app.No_of_Dependants_1__c != null) {
                param.dependents = Integer.valueOf(app.No_of_Dependants_1__c);
            }
            // Income
            if (app.Net_Income_1__c != null) {
                param.income1 = app.Net_Income_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Payment_Frequency_1__c, 'Monthly');
            }
            if (app.No_of_People__c == 2) {
                if (app.Net_Income_2__c != null) {
                    param.income2 = app.Net_Income_2__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Payment_Frequency_2__c, 'Monthly');
                }   
            }
            // Other Income
            Map<Long, List<Application_Income__c>> incomeMap = getApplicationIncomeMap2(appId);
            if (!incomeMap.isEmpty()) {
                for (Long k : incomeMap.keySet()) {
                    if (k == 1) {
                        param.totalOtherIncome1 = OppApplicationServCalculatorUtils.sumApplicationIncomes(incomeMap.get(k));
                    } else if (k == 2) {
                        param.totalOtherIncome2 = OppApplicationServCalculatorUtils.sumApplicationIncomes(incomeMap.get(k));
                    }
                }
            }
            // Total credit cards
            param.totalCreditCards = getApplicationTotalCreditCards(appId);
            // Total Liabilities
            
            // Vehicles
            List<Application_Other_Asset__c> veh = getApplicationOtherAssets(app.Id, VEHICLE_ASSET_TYPE);
            for (Application_Other_Asset__c a: veh) {
                if ('Y'.equals(a.Has_Loan__c)) {
                    param.totalLiabilities += a.Monthly_Payment__c;
                }
            }
            //String frequency = null;
            //if (app.Loans_Monthly_Payments_4__c != null && 'Y'.equals(app.Vehicle_Has_Loan_1__c)) {
            //    frequency = app.Loan_Frequency_4__c;
            //    if (!app.Loan_Repaid_4__c) {
            //        System.debug(param.totalLiabilities + '|' + app.Loans_Monthly_Payments_4__c + '|' + frequency);
            //        param.totalLiabilities += app.Loans_Monthly_Payments_4__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(frequency, 'Monthly');
            //    }
            //}
            //if (app.Loans_Monthly_Payments_5__c > 0 && 'Y'.equals(app.Vehicle_Has_Loan_2__c)) {
            //    frequency = app.Loan_Frequency_5__c;
            //    if (String.isBlank(frequency)) {
            //        frequency = 'Monthly';
            //    }
            //    if (!app.Loan_Repaid_5__c) {
            //        param.totalLiabilities += app.Loans_Monthly_Payments_5__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(frequency, 'Monthly');
            //    }
            //}
            //if (app.Loans_Monthly_Payments_6__c > 0 && 'Y'.equals(app.Vehicle_Has_Loan_3__c)) {
            //    frequency = app.Loan_Frequency_6__c;
            //    if (String.isBlank(frequency)) {
            //        frequency = 'Monthly';
            //    }
            //    if (!app.Loan_Repaid_6__c) {
            //        param.totalLiabilities += app.Loans_Monthly_Payments_6__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(frequency, 'Monthly');
            //    }
            //}

            if (app.Rent_per_month_1__c> 0) {
                if ('Renting(Agent)'.equals(app.Current_Residence_Status_1__c) || 'Renting(Private)'.equals(app.Current_Residence_Status_1__c) || 'Parents/Relative'.equals(app.Current_Residence_Status_1__c) || 'Employer Accommodation'.equals(app.Current_Residence_Status_1__c)) {
                    param.totalRentMortgageBoard += app.Rent_per_month_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Residential_Payment_Frequency_1__c, 'Monthly');
                }
            }
            if (app.Board_per_month_1__c> 0) {
                if ('Parents/Relative'.equals(app.Current_Residence_Status_1__c) || 'Boarding'.equals(app.Current_Residence_Status_1__c)) {
                    param.totalRentMortgageBoard += app.Board_per_month_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Residential_Payment_Frequency_1__c, 'Monthly');
                }
            }
            // Renting / Mortgage / Boarding
            param.totalRentMortgageBoard += getApplicationTotalMortgage(appId);
            // if (app.Total_Mortgage_Loan__c != null) {
            //     param.totalRentMortgageBoard += app.Total_Mortgage_Loan__c;
            // }
        }
        //Other Loans
        List<Application_Loan__c> loanList = getApplicationLoans(appId);
        if (!loanList.isEmpty()) {
            for (Application_Loan__c a : loanList) {
                if ('Mortgage'.equals(a.Type__c)){
                    param.totalRentMortgageBoard += a.Payment__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(a.Frequency__c, 'Monthly');
                } else {
                    param.totalLiabilities += a.Payment__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(a.Frequency__c, 'Monthly');
                }
            }
        }

        return param;
    }

    public static Application_Asset_Detail__c getAssetDetail(Id oppId) {
        Application_Asset_Detail__c r = null;
        if (oppId != null) {
            List<Application_Asset_Detail__c> d = [
                SELECT Type__c, Condition__c, Year__c, Actual_KM__c, LVR__c
                FROM Application_Asset_Detail__c WHERE Id IN (
                    SELECT Application_AssetDetail__c FROM Custom_Opportunity__c
                    WHERE Id = :oppId
                )];
            if (!d.isEmpty()) {
                r = d.get(0);
            }
        }
        return r;
    }

    public static Integer getAssetDetailYear(Id oppId) {
        Integer r = null;
        if (oppId != null) {
            List<Custom_Opportunity__c> d = [
                SELECT Application_AssetDetail__c, Application_AssetDetail__r.Condition__c, Application_AssetDetail__r.Year__c,
                       Application__c, Application__r.Vehicle_Year__c
                FROM Custom_Opportunity__c
                WHERE Id = :oppId
            ];
            if (!d.isEmpty()) {
                Custom_Opportunity__c o = d.get(0);
                if (o.Application_AssetDetail__c != null && o.Application_AssetDetail__r.Year__c != null) {
                    r = o.Application_AssetDetail__r.Year__c.intValue();
                }
            }
        }
        return r;
    }
    
    public static Map < String, List < Application_Income__c >> getApplicationIncomeMap(Id appId) {
        Map < String, List < Application_Income__c >> incomeMap = new Map <String,List <Application_Income__c>>();
        if (appId != null) {
            List < Application_Income__c > lst = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                  Income__c, Order__c, Type__c, Monthly_Income__c, Application_Other_Asset__c
                                                  FROM Application_Income__c WHERE Application__c =: appId ORDER BY Order__c
                                                 ];
            
            for (Application_Income__c a: lst) {
                if (String.isNotBlank(a.Applicant__c)) {
                    List<Application_Income__c> income = incomeMap.get(a.Applicant__c);
                    if (income == null) {
                        income = new List < Application_Income__c > ();
                        incomeMap.put(a.Applicant__c, income);
                    }
                    income.add(a);
                }
            }
        }
        return incomeMap;
    }

    public static Map < Long, List < Application_Income__c >> getApplicationIncomeMap2(Id appId) {
        Map < String, List < Application_Income__c >> d = getApplicationIncomeMap(appId);
        Map <Long, List < Application_Income__c >> r = new Map <Long, List < Application_Income__c >>();
        for (String key : d.keySet()) {
            r.put(Long.valueOf(key), d.get(key));
        }
        return r;
    }

    // Lelo                 2019-03-07
    public static List<Application_Credit_Card__c> getApplicationCreditCards(Id appId) {
        List<Application_Credit_Card__c> r = new List<Application_Credit_Card__c>();
        if (appId != null) {
            r = [SELECT Id, Name, Amount_Owing__c, Application__c, Issuer__c, Limit__c, Monthly_Payment__c, Is_Payout__c
                FROM Application_Credit_Card__c WHERE Application__c = :appId ORDER BY Issuer__c];
        }
        return r;
    }

    public static Decimal getApplicationTotalCreditCards(Id appId) {
        Decimal r = 0.00;
        if (appId != null) {
            List<AggregateResult> d = [SELECT SUM(Monthly_Payment__c) total 
                                       FROM Application_Credit_Card__c 
                                       WHERE Application__c = :appId
                                       AND Is_Payout__c = false];
            if (!d.isEmpty() && d[0].get('total') != null) {
                r = (Decimal)d[0].get('total');
            }
        }
        return r;
    }

    public static List<Application_Other_Asset__c> getApplicationOtherAssets(Id appId) {
        return getApplicationOtherAssets(appId, null);
    }

    public static Decimal getApplicationTotalMortgage(Id appId) {
        Decimal r = 0.00;
        if (appId != null) {
            List<AggregateResult> d = [SELECT SUM(Monthly_Payment__c) total FROM Application_Other_Asset__c 
                    WHERE Application__c = :appId AND RecordType.Name= :PROPERTY_ASSET_TYPE AND Has_Loan__c = 'Y'];
            if (!d.isEmpty() && d[0].get('total') != null) {
                r = (Decimal)d[0].get('total');
            }
        }
        return r;
    }

    public static List<Application_Other_Asset__c> getApplicationOtherAssets(Id appId, String assetType) {
        List<Application_Other_Asset__c> r = new List<Application_Other_Asset__c>();
        if (appId != null) {
            String sql = 'SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c, ' +
                         '       Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c ' +
                         'FROM Application_Other_Asset__c WHERE Application__c = :appId ';
            if (String.isNotBlank(assetType)) {
                sql += 'AND RecordType.Name = :assetType ';
            }
            sql += 'ORDER BY RecordType.Name, Description__c';
            r = Database.query(sql);
        }
        return r;
    }

    public static Map<String, List<Application_Other_Asset__c>> getApplicationOtherAssetsMap(Id appId) {
        Map<String, List<Application_Other_Asset__c>> r = new Map<String, List<Application_Other_Asset__c>>();
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(appId);
        for (Application_Other_Asset__c a : d) {
            List<Application_Other_Asset__c> m = r.get(a.RecordType.Name);
            if (m == null) {
                m = new List<Application_Other_Asset__c>();
                r.put(a.RecordType.Name, m);
            }
            m.add(a);
        }
        return r;
    }

    public static Boolean hasVerifiableCredit(Id appId) {
        Boolean r = false;
        if (appId != null) {
            List<Application_Other_Asset__c> d = [SELECT Id FROM Application_Other_Asset__c WHERE Application__c = :appId];
            if (!d.isEmpty()) {
                r = true;
            }
        }
        return r;
    }

}