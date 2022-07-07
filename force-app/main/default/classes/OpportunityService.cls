public class OpportunityService {

	public static void updateOpptyAndRemoveAttachments(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
		Boolean isSettlementsTeam = false;
		Id recTypeId = Schema.SObjectType.Custom_Opportunity__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
		Id ownerQueueId = SOQLSingletonQueries.recs().getHomeLoanQueue.Id;
		
		for(UserRole ur : SOQLSingletonQueries.recs().getCurrentUserRoles){
			if(ur.Name == 'Settlement Team'){
				isSettlementsTeam = true;
			}
		}
		Set<Id> oppIds = new Set<Id>();
		Set<Id> oppSettledIds = new Set<Id>();
		// find the products for each opportunity
    	Map<Id, List<Product__c>> products = new Map<Id, List<Product__c>>();
    	
		for (Custom_Opportunity__c o : newList) {
			oppIds.add(o.Id);
			if(o.RecordTypeId == recTypeId && o.OwnerId != oldMap.get(o.id).OwnerId && oldMap.get(o.id).OwnerId == ownerQueueId){
				o.OwnerId = UserInfo.getUserId();
			}
			if(o.Status__c != oldMap.get(o.Id).Status__c){
				if (o.Status__c == 'Settled'){
					oppSettledIds.add(o.Id);
				}
			}
		}
		
		Map<Id, Boolean> hasFinalDocs = new Map<Id, Boolean>();
    	Map<Id, Boolean> hasLenderSett = new Map<Id, Boolean>();
		Map<Id, Attachment> attLst = new Map<Id, Attachment>();
		// find the finance products and required documents linked to the opportunities  
   		Map<Id, Custom_Opportunity__c> oppLists = SOQLSingletonQueries.setOppIds(oppIds).opportunityProdFinanceMap;
   	
    	Map<Id, List<Cloud_Documents__c>> cloudDocs = new Map<Id, List<Cloud_Documents__c>>();
    	if(!oppSettledIds.isEmpty()){
    		for (Product__c p : SOQLSingletonQueries.setOppIds(oppSettledIds).productsByOppIds){
    			if (!products.containsKey(p.Opportunity_Name__c)){
    				products.put(p.Opportunity_Name__c, new List<Product__c>());
    			} 
              	products.get(p.Opportunity_Name__c).add(p); 
    		}
    		
    		for(Cloud_Documents__c cloudDoc : SOQLSingletonQueries.setOppIds(oppSettledIds).cloudDocsByOppIds){
    			if(!cloudDocs.containsKey(cloudDoc.Custom_Opportunity__c)){
                	hasFinalDocs.put(cloudDoc.Custom_Opportunity__c, false);
                    hasLenderSett.put(cloudDoc.Custom_Opportunity__c, false);
                    cloudDocs.put(cloudDoc.Custom_Opportunity__c, new List<Cloud_Documents__c>());
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
		if(!oppIds.isEmpty()){
			for(Attachment attOpp :  SOQLSingletonQueries.setOppIds(oppIds).attachmentsByOppIds){
	            attLst.put(attOpp.parentId, attOpp);
	        }
		}
		List<Attachment> attLstToDel = new List<Attachment>();
		for (Custom_Opportunity__c o : newList){
			if(!oppLists.isEmpty()){
				if (oppLists.containsKey(o.Id) && oppLists.get(o.Id).Products__r != null){
					for (Product__c p : oppLists.get(o.Id).Products__r){
						if(o.Loan_Product__c != p.Id){
							o.Loan_Product__c = p.Id; 
						}       
			    	}   
				}
			}
			if(o.Status__c != oldMap.get(o.Id).Status__c){
				if(o.Status__c =='Settled'){
					if(!attLst.isEmpty()){
						attLstToDel.add(attLst.get(o.Id));
					}
					
					if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
            if (o.Id != null && products.containsKey(o.Id)){
              for (Product__c p : products.get(o.Id)){
                // if(Test.isRunningTest()){
                //   //System.assertEquals(null, p.Invoices__r);
                //   System.debug('Pass2 p.Invoices__r:' + p.Invoices__r.size() + ':' + p.Id);
                // }
                if (p.Invoices__r.size() == 0){
                  o.addError('All products must have an invoice before the opportunity can be settled');
                }
              }
            }
            if (o.Id != null && isSettlementsTeam){
              if(cloudDocs.containsKey(o.Id)){
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
				} else {
					
					o.All_Documents_Attached__c = true;
				}
				if(!'Settled'.equals(o.Status__c) && 'Unresolved Opportunity'.equals(oldMap.get(o.Id).Status__c)){
					System.debug('Changing ownership... to current user :(');
					o.ownerId =  UserInfo.getUserId(); 
				}
			} 
		}
		try{
			if(!attLstToDel.isEmpty()){
				delete attLstToDel;
			}
		} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
    	}
	}
	
	public static void sendEmailTemplates(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
		Map<Custom_Opportunity__c, String> oppSettedEmailMap = new Map<Custom_Opportunity__c, String>();
		for (Custom_Opportunity__c o : newList){
			if(o.Settled_Email_Rules__c != oldMap.get(o.Id).Settled_Email_Rules__c && !o.emailoptout__c){
				oppSettedEmailMap.put(o, o.Settled_Email_Rules__c);
			}
		}
		if(!oppSettedEmailMap.isEmpty()){
			Map<String, Id> etMap = new Map<String, Id>();
			for(EmailTemplate et : SOQLSingletonQueries.recs().getSettledEmailTemplates){
				etMap.put(et.developername, et.Id);
			}
	    	if(!etMap.isEmpty()){
	          SettledEmail setEmail = new SettledEmail();
	          setEmail.sendSettledEmails(oppSettedEmailMap, etMap);
	        }
	    }
	}
	
	public static void setConsultantDealer(List<Custom_Opportunity__c> newList){
		Set<Id> leadIds = new Set<Id>();
		for (Custom_Opportunity__c o : newList){
			if(o.Lead__c != null){
				leadIds.add(o.Lead__c);
			}
		}
		if(!leadIds.isEmpty()){
			Map<Id, Lead__c> leads = SOQLSingletonQueries.setLeadIds(leadIds).leadsIdMap;
			
			for(Custom_Opportunity__c o : newList){
				if (o.Lead__c != null && leads.containsKey(o.Lead__c)){      
		            o.Lead_Consultant_Dealer__c = leads.get(o.Lead__c).Lead_Consultant_Dealer__c;
		        }
			}
		}
	}
	
	public static void setConsultantDealer(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
		Set<Id> leadIds = new Set<Id>();
		for (Custom_Opportunity__c o : newList){
			if(o.Lead__c != null && o.Lead__c != oldMap.get(o.Id).Lead__c){
				leadIds.add(o.Lead__c);
			}
		}
		if(!leadIds.isEmpty()){
			Map<Id, Lead__c> leads = SOQLSingletonQueries.setLeadIds(leadIds).leadsIdMap;
		
			for(Custom_Opportunity__c o : newList){
				if (o.Lead__c != null && leads.containsKey(o.Lead__c) && o.Lead__c != oldMap.get(o.Id).Lead__c){      
		            o.Lead_Consultant_Dealer__c = leads.get(o.Lead__c).Lead_Consultant_Dealer__c;
		        }
			}
		}
	}
	
	public static void vehiclesDirectWork(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
		Set<Id> oppIds = new Set<Id>();
		for (Custom_Opportunity__c o : newList) {
			oppIds.add(o.Id);
			
		}
		Id VDOwnerId = VDAllocation.allocateSettlements();
		Map<Id, User> vdOwnerMap = new Map<Id, User>();
		if(VDOwnerId != null){
			vdOwnerMap = SOQLSingletonQueries.setUserId(VDOwnerId).usersIdMap;
		}
		Map<Id, List<Attachment>> worksheetMap = new Map<Id, List<Attachment>>();
        Map<Id, List<Attachment>> dealerMap = new Map<Id, List<Attachment>>();
        Map<Id, List<Custom_Opportunity__History>> historyMap = new Map<Id, List<Custom_Opportunity__History>>();
        if(!oppIds.isEmpty()){
        	worksheetMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityWorksheetAttachMap;
            dealerMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityDealerAttachMap;
            historyMap = SOQLSingletonQueries.setOppIds(oppIds).opportunityHistoryAttachMap;
        }
        Set<Id> prevOppIds = new Set<Id>();
        for(Id custOppId : historyMap.keySet()){
        	List <Custom_Opportunity__History> VDOwnerHistory = historyMap.get(custOppId);
        	String previousVDOwner = String.valueOf(VDOwnerHistory.get(VDOwnerHistory.size()-1).OldValue);
            if(previousVDOwner != null && previousVDOwner != ''){
            	Id prevId;
            	try{
            		prevId = Id.valueOf(previousVDOwner);
            	}catch (Exception e) {
				    system.debug('error:' + e.getMessage());
				}
                if(prevId != null){
                    prevOppIds.add(prevId);
                }
            }
        }
        Map<Id, User> prevUserMap = new Map<Id, User>();
        if(!prevOppIds.isEmpty()){
            prevUserMap = SOQLSingletonQueries.setUserIds(prevOppIds).usersIdsMap;
        }
        
        for (Custom_Opportunity__c VDOpp : newList) {
        	//Lelo 		2016-11-09
        	if (VDOpp.VD_Is_Old_Process__c) {
	        	If (VDOpp.VD_Status__c == 'Invoice Requested' && oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
	        		User VDOwner;
	                if(VDOwnerId != null){
	                    VDOwner = vdOwnerMap.get(VDOwnerId);
	                    VDOpp.VD_Owner__c = VDOwnerId;
	                }
	                
	                Set<id> reqDocId = new Set<id> ();
	                //if(Trigger.New.size() == 1){
		            List<Attachment> workSheets = worksheetMap.get(VDOpp.id);   
		            EmailSender.sendEmailToVDSet(workSheets, VDOwner, VDOpp);
	            	//}
	        	}
	        	
	        	if (VDOpp.VD_Status__c == 'Sent back to Finance Consultant' && oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
	        		List<Attachment> invoices = dealerMap.get(VDOpp.id);
		            List <Custom_Opportunity__History> VDOwnerHistory = historyMap.get(VDOpp.Id);           
		            String previousVDOwner = String.valueOf(VDOwnerHistory.get(VDOwnerHistory.size()-1).OldValue);
		            if(previousVDOwner != null && previousVDOwner != ''){
						Id prevId;
		            	try{
		            		prevId = Id.valueOf(previousVDOwner);
		            	}catch (Exception e) {
						    system.debug('error:' + e.getMessage());
						}
						if(prevId!= null){
			            	User previousVD = prevUserMap.get(prevId); // [SELECT Id,Name,Email FROM User WHERE Id =: ID.valueOf(previousVDOwner)];
			        		EmailSender.sendEmailToPreVD(VDOpp, previousVD);
						}
		            }
					EmailSender.sendEmailToOppOwner(invoices, VDOpp); 
	        	}
	        	
	        	if (VDOpp.VD_Status__c == 'Send back to Sales Consultant - cannot proceed' && oldMap.get(VDOpp.id).VD_Status__c != VDOpp.VD_Status__c) {
	        		VDOpp.VD_Owner__c = null;
	                EmailSender.sendEmailVDFailure(VDOpp);
	        	}
	        }
        }
	}
	
	public static void copyPreviousSettledOppty(List<Custom_Opportunity__c> newList){
		Set<Id> accountIds = new Set<Id>();
		for (Custom_Opportunity__c o : newList) {
			accountIds.add(o.Account__c);
		}
		
		// find previous opportunities for the account
		 
		Map<Id, Account> accounts = SOQLSingletonQueries.setAccountIds(accountIds).settledAccountsIdMap;
		for (Custom_Opportunity__c o : newList){
			
			if (accounts.containsKey(o.Account__c)){
				for (Custom_Opportunity__c prev : accounts.get(o.Account__c).Opportunities__r){
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
		}
	}
	
    public static void generateDoc(List<Custom_Opportunity__c> newList){
    	Set<Id> relatedAppId = new Set<Id>();
        for (Custom_Opportunity__c newOpp : newList) {
            if (newOpp.Application__c != null) {
                relatedAppId.add(newOpp.Application__c);
            }
        }
        if (relatedAppId.size() > 0) {
            Map <Id,Application__c> relatedApp = SOQLSingletonQueries.setApplicationIds(relatedAppId).applicationsIdMap;
            
            for (Custom_Opportunity__c newOpp : newList) {
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
                Decimal dependants = 0;
                if (appBuffer.No_of_Dependants_1__c != null) {
                	dependants += appBuffer.No_of_Dependants_1__c; 
                }
				if (appBuffer.No_of_Dependants_2__c != null) {
					dependants += appBuffer.No_of_Dependants_2__c; 	
				}                
                //if (appBuffer.No_of_Dependants_2__c != null) {
                //    newOpp.Number_of_Dependents__c = String.valueOf(appBuffer.No_of_Dependants_1__c.intValue() + appBuffer.No_of_Dependants_2__c.intValue());
                //} else {
                //    newOpp.Number_of_Dependents__c = String.valueOf(appBuffer.No_of_Dependants_1__c.intValue());
                //}
                newOpp.Number_of_Dependents__c = String.valueOf(dependants.intValue());
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
                newOpp.Other_Income__c = otherIncomes;
                // Other Income Detail
                if (newOpp.Other_Income__c == 0) {
                    newOpp.Other_Income_Detail__c = 'Nothing';
                } else {
                    newOpp.Other_Income_Detail__c = 'Other Income';
                }
                // Rent/Mortgage
                Decimal sumMortgage = 0.0;
                //if (appBuffer.Loan_Type_1__c == 'Mortgage') {
                //    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_1__c;
                //}
                //if (appBuffer.Loan_Type_2__c == 'Mortgage') {
                //    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_2__c;
                //}
                //if (appBuffer.Loan_Type_3__c == 'Mortgage') {
                //    sumMortgage = sumMortgage + appBuffer.Loans_Monthly_Payments_3__c;
                //}
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
                //if (appBuffer.Loan_Type_1__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_1__c != null) {
                //    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_1__c;
                //}
                //if (appBuffer.Loan_Type_2__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_2__c != null) {
                //    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_2__c;
                //}
                //if (appBuffer.Loan_Type_3__c != 'Mortgage' && appBuffer.Loans_Monthly_Payments_3__c != null) {
                //    sumLoan = sumLoan + appBuffer.Loans_Monthly_Payments_3__c;
                //}
                newOpp.Existing_Loan_Payments__c = sumLoan;
                // Credit Card
                Decimal totalCreditCard = 0;
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
                	System.debug('@@ERROR:' + e.getMessage());
                }
            } //end for loop
        } //end if for relatedAppId.size() > 0
    }
    
    public static void acctAndLeadOwnerUpdate(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	List<Lead__c> leadsToUpdate = new List<Lead__c>();
    	//List<Account> acctsToUpdate = new List<Account>();

    	Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
    	Map<Id, Id> newLeadOwnerIdMap = new Map<Id, Id>();
    	//Map<Id, Id> newOppOwnerIdMap =  new Map<Id, Id>();

    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Lead__c != null && ((newOpp.Lead__c != oldMap.get(newOpp.Id).Lead__c) || (newOpp.OwnerId != oldMap.get(newOpp.Id).OwnerId))){
    			newLeadOwnerIdMap.put(newOpp.Lead__c, newOpp.OwnerId);
    		}
    		//if(newOpp.Account__c != null && ((newOpp.Account__c != oldMap.get(newOpp.Id).Account__c) || (newOpp.OwnerId != oldMap.get(newOpp.Id).OwnerId))){
    		//	newOppOwnerIdMap.put(newOpp.account__c, newOpp.OwnerId);
    		//}
    	}
    	if(!newLeadOwnerIdMap.keySet().isEmpty()){
	    	Map<Id,Lead__c> leadMap = SOQLSingletonQueries.setLeadIds(newLeadOwnerIdMap.keySet()).leadsIdMap;
	    	
	    	for(Id ldId : newLeadOwnerIdMap.keySet()){
	    		if(newLeadOwnerIdMap.get(ldId) != null){
	    			if(String.valueOf(newLeadOwnerIdMap.get(ldId)).startsWith('005')){
		    			if(leadMap.get(ldId) != null){
		    				leadMap.get(ldId).OwnerId = newLeadOwnerIdMap.get(ldId);
		    				leadsToUpdate.add(leadMap.get(ldId));
		    			}
		    		} else {
		    			if(sysGenId != null){
		    				leadMap.get(ldId).OwnerId = sysGenId;
		    				leadsToUpdate.add(leadMap.get(ldId));
		    			}
		    		}
	    		}
	    	}
    	}
    	/*
    	if(!newOppOwnerIdMap.keySet().isEmpty()){
	    	Map<Id,Account> accMap = SOQLSingletonQueries.setAccountIds(newOppOwnerIdMap.keySet()).accountsIdMap;
	    	
	    	for(Id acctId : newOppOwnerIdMap.keySet()){
	    		if(newOppOwnerIdMap.get(acctId) != null){
		    		if(String.valueOf(newOppOwnerIdMap.get(acctId)).startsWith('005')){
		    			if(accMap.get(acctId) != null){
		    				accMap.get(acctId).OwnerId = newOppOwnerIdMap.get(acctId);
		                  	acctsToUpdate.add(accMap.get(acctId));
		    			}
		    		} else {
		    			if(sysGenId != null){
		    				accMap.get(acctId).OwnerId = sysGenId;
		    				acctsToUpdate.add(accMap.get(acctId));
		    			}
		    		}
	    		}
	    	}
    	}
    	*/
    	try{
    		//if(!acctsToUpdate.isEmpty()){
    		//	update acctsToUpdate;
    		//	AccountService.accountSharing(acctsToUpdate);
    		//}
    		if(!leadsToUpdate.isEmpty()){
                update leadsToUpdate;
                LeadService.leadSharing(leadsToUpdate);      
            }
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void acctAndLeadOwnerUpdate(List<Custom_Opportunity__c> newList){
    	List<Lead__c> leadsToUpdate = new List<Lead__c>();
    	//List<Account> acctsToUpdate = new List<Account>();
		
    	Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
    	Map<Id, Id> newLeadOwnerIdMap = new Map<Id, Id>();
    	//Map<Id, Id> newOppOwnerIdMap =  new Map<Id, Id>();

    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Lead__c != null){
    			newLeadOwnerIdMap.put(newOpp.Lead__c, newOpp.OwnerId);
    		}
    		//if(newOpp.Account__c != null){
    		//	newOppOwnerIdMap.put(newOpp.account__c, newOpp.OwnerId);
    		//}
    	}
    	if(!newLeadOwnerIdMap.keySet().isEmpty()){
	    	Map<Id,Lead__c> leadMap = SOQLSingletonQueries.setLeadIds(newLeadOwnerIdMap.keySet()).leadsIdMap;
	    	
	    	for(Id ldId : newLeadOwnerIdMap.keySet()){
	    		if(newLeadOwnerIdMap.get(ldId) != null){
	    			if(String.valueOf(newLeadOwnerIdMap.get(ldId)).startsWith('005')){
		    			if(leadMap.get(ldId) != null){
		    				leadMap.get(ldId).OwnerId = newLeadOwnerIdMap.get(ldId);
		    				leadsToUpdate.add(leadMap.get(ldId));
		    			}
		    		} else {
		    			if(sysGenId != null){
		    				leadMap.get(ldId).OwnerId = sysGenId;
		    				leadsToUpdate.add(leadMap.get(ldId));
		    			}
		    		}
	    		}
	    	}
    	}
    	/*
    	if(!newOppOwnerIdMap.keySet().isEmpty()){
	    	Map<Id,Account> accMap = SOQLSingletonQueries.setAccountIds(newOppOwnerIdMap.keySet()).accountsIdMap;
	    	
	    	for(Id acctId : newOppOwnerIdMap.keySet()){
	    		if(newOppOwnerIdMap.get(acctId) != null){
		    		if(String.valueOf(newOppOwnerIdMap.get(acctId)).startsWith('005')){
		    			if(accMap.get(acctId) != null){
		    				accMap.get(acctId).OwnerId = newOppOwnerIdMap.get(acctId);
		                  	acctsToUpdate.add(accMap.get(acctId));
		    			}
		    		} else {
		    			if(sysGenId != null){
		    				accMap.get(acctId).OwnerId = sysGenId;
		    				acctsToUpdate.add(accMap.get(acctId));
		    			}
		    		}
	    		}
	    	}
    	}
    	*/
    	try{
    		//if(!acctsToUpdate.isEmpty()){
    		//	update acctsToUpdate;
    		//	AccountService.accountSharing(acctsToUpdate);
    		//}
    		if(!leadsToUpdate.isEmpty()){           
                update leadsToUpdate;
                LeadService.leadSharing(leadsToUpdate);
            }
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void cloneSettledWithMortgaged(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	Map<Id, Custom_Opportunity__c> listOppCloned = new Map<Id, Custom_Opportunity__c>();
    	Group homeLoan = SOQLSingletonQueries.recs().getHomeLoanQueue;
    	Id recTypeId = Schema.SObjectType.Custom_Opportunity__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
    	Set <Id> relatedApp = new Set <Id> ();
    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Application__c != null && newOpp.Application__c != oldMap.get(newOpp.id).Application__c 
    			|| newOpp.Settled_and_Mortgaged__c != oldMap.get(newOpp.id).Settled_and_Mortgaged__c 
    			|| newOpp.Status__c != oldMap.get(newOpp.id).Status__c && newOpp.Status__c == 'Settled'){
    			relatedApp.add(newOpp.Application__c);
    		}
    	}
    	Map<Id, Application__c> appMap = new Map<Id, Application__c>();
    	if(!relatedApp.isEmpty()){
    		appMap = SOQLSingletonQueries.setApplicationIds(relatedApp).applicationsIdMap;
    	}
    	
    	for (Custom_Opportunity__c newOpp : newList){
    		if((newOpp.Settled_and_Mortgaged__c != oldMap.get(newOpp.id).Settled_and_Mortgaged__c || newOpp.Status__c != oldMap.get(newOpp.id).Status__c) && !appMap.isEmpty()){
    		//if(!appMap.isEmpty()){
	    		//if((newOpp.Status__c == 'Settled') && (newOpp.Settled_and_Mortgaged__c == true || ((appMap.get(newOpp.Application__c).Loan_Type_1__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_2__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_3__c == 'Mortgage')))){
	    		//	Custom_Opportunity__c cloneOpp = newOpp.clone(false, true, false, false);
	    		//	cloneOpp.RecordTypeId = recTypeId;
	    		//	if(homeLoan != null){
       //             	cloneOpp.OwnerId = homeLoan.Id;
       //             	listOppCloned.put(newOpp.Id, cloneOpp);
       //        		}
	    		//}
    		}
    		
    		if(newOpp.Application__c != null && newOpp.Application__c != oldMap.get(newOpp.id).Application__c && !appMap.isEmpty() && appMap.get(newOpp.Application__c) != null){
    			//if(newOpp.Status__c == 'Settled' && ((appMap.get(newOpp.Application__c).Loan_Type_1__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_2__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_3__c == 'Mortgage'))){
    			//	Custom_Opportunity__c cloneOpp = newOpp.clone(false, true, false, false);
    			//	cloneOpp.RecordTypeId = recTypeId;
    			//	if(homeLoan != null){
       //             	cloneOpp.OwnerId = homeLoan.Id;
       //             	listOppCloned.put(newOpp.Id, cloneOpp);
       //         	}
    			//}
    		}
    	}
    	
    	try{
    		if(!listOppCloned.values().isEmpty()){
    			insert listOppCloned.values();
    		}
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void cloneSettledWithMortgaged(List<Custom_Opportunity__c> newList){
    	List<Custom_Opportunity__c> listOppCloned = new List<Custom_Opportunity__c>();
    	Group homeLoan = SOQLSingletonQueries.recs().getHomeLoanQueue;
    	Id recTypeId = Schema.SObjectType.Custom_Opportunity__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
    	Set <Id> relatedApp = new Set <Id> ();
    	
    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Application__c != null && newOpp.Status__c == 'Settled'){
    			relatedApp.add(newOpp.Application__c);
    		}
    	}
    	Map<Id, Application__c> appMap = new Map<Id, Application__c>();
    	if(!relatedApp.isEmpty()){
    		appMap = SOQLSingletonQueries.setApplicationIds(relatedApp).applicationsIdMap;
    	}
    	
    	for (Custom_Opportunity__c newOpp : newList){
    		if(homeLoan != null){
	    		if(newOpp.Application__c != null && newOpp.OwnerId != homeLoan.Id){
	    			//if(newOpp.Status__c == 'Settled' && ((appMap.get(newOpp.Application__c).Loan_Type_1__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_2__c == 'Mortgage') || (appMap.get(newOpp.Application__c).Loan_Type_3__c == 'Mortgage'))){
	    			//	Custom_Opportunity__c cloneOpp = newOpp.clone(false, true, false, false);
	    			//	cloneOpp.RecordTypeId = recTypeId;
        //            	cloneOpp.OwnerId = homeLoan.Id;
        //            	listOppCloned.add(cloneOpp);
        //        	}
    			}
    		}
    	}
    	
    	try{
    		if(!listOppCloned.isEmpty()){
    			insert listOppCloned;
    		}
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void tasksUpdateOnStatusChange(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	List<Task> tasks = new List<Task>();

    	Map<Id, Custom_Opportunity__c> oppWithStatusChanged = new Map<Id, Custom_Opportunity__c>();
    	for (Custom_Opportunity__c newOpp : newList){
    		if (newOpp.Status__c != oldMap.get(newOpp.Id).Status__c){
    			oppWithStatusChanged.put(newOpp.Id, newOpp);
    		}
    	}
    	// find which opportunities have open tasks
    	for (Task t : SOQLSingletonQueries.setOppIds(oppWithStatusChanged.keySet()).uncompletedTasksByOppIds){
    		if(oppWithStatusChanged.get(t.WhatId) != null){
    			if(oppWithStatusChanged.get(t.WhatId).Status__c != oldMap.get(t.WhatId).Status__c){
	    			t.Status = 'Completed';
	    			tasks.add(t);
	    		}
	    		
	    		if(oppWithStatusChanged.get(t.WhatId).Status__c == 'Sent for Settlement'){
	    			oppWithStatusChanged.get(t.WhatId).Status__c.AddError('The status cannot be changed while there are open tasks.');
	    		}
    		}
    		
    	}
    	
    	try{
    		if(!tasks.isEmpty()){
    			update tasks;
    		}
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void productUpdate(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	List<Product__c> products = new List<Product__c>();
    	Map<Id, Custom_Opportunity__c> oppIdsDateChangedMap = new Map<Id, Custom_Opportunity__c>();
    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Date_Settled__c != null && newOpp.Date_Settled__c != oldMap.get(newOpp.Id).Date_Settled__c){
    			oppIdsDateChangedMap.put(newOpp.Id, newOpp);
    		}
    	}
    	
    	if(!oppIdsDateChangedMap.isEmpty()){
    		for (Product__c p : SOQLSingletonQueries.setOppIds(oppIdsDateChangedMap.keySet()).financeProductsByOppIds){
	    		// find the potential new end of loan date
	    		Date endOfLoan;
	    		if (p.Loan_Term__c != null && p.Opportunity_Name__c != null && oppIdsDateChangedMap.get(p.Opportunity_Name__c) != null){
	    			endOfLoan = oppIdsDateChangedMap.get(p.Opportunity_Name__c).Date_Settled__c.addMonths(Integer.valueOf(p.Loan_Term__c));
	    		}
	    		
	    		// if the end of loan date has changed then 
	            if (endOfLoan != null && endOfLoan != p.End_of_Loan_Date__c){
	            	p.End_of_Loan_Date__c = endOfLoan;
	            	products.add(p);
	            }
	    	}
    	}
    	
    	try{
    		if(!products.isEmpty()){
    			update products;
    		}
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void productUpdate(List<Custom_Opportunity__c> newList){
    	List<Product__c> products = new List<Product__c>();
    	Map<Id, Custom_Opportunity__c> oppIdsDateChangedMap = new Map<Id, Custom_Opportunity__c>();
    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Date_Settled__c != null){
    			oppIdsDateChangedMap.put(newOpp.Id, newOpp);
    		}
    	}
    	
    	if(!oppIdsDateChangedMap.isEmpty()){
    		for (Product__c p : SOQLSingletonQueries.setOppIds(oppIdsDateChangedMap.keySet()).financeProductsByOppIds){
	    		// find the potential new end of loan date
	    		Date endOfLoan;
	    		if (p.Loan_Term__c != null && p.Opportunity_Name__c != null && oppIdsDateChangedMap.get(p.Opportunity_Name__c) != null){
	    			endOfLoan = oppIdsDateChangedMap.get(p.Opportunity_Name__c).Date_Settled__c.addMonths(Integer.valueOf(p.Loan_Term__c));
	    		}
	    		
	    		// if the end of loan date has changed then 
	            if (endOfLoan != null && endOfLoan != p.End_of_Loan_Date__c){
	            	p.End_of_Loan_Date__c = endOfLoan;
	            	products.add(p);
	            }
	    	}
    	}
    	
    	try{
    		if(!products.isEmpty()){
    			update products;
    		}
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void callRemindersToAddOrRemove(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	List<Call_Reminder__c> callRemindersToAdd = new List<Call_Reminder__c>();
    	List<Call_Reminder__c> callRemindersToDel = new List<Call_Reminder__c>();
    	Set<Id> oppIds = new Set<Id>();
    	for (Custom_Opportunity__c newOpp : newList){
    		if(newOpp.Status__c != oldMap.get(newOpp.Id).Status__c){
    			oppIds.add(newOpp.Id);
    		}
    	}
    	
    	if(!oppIds.isEmpty()){
    		Map<Id, Call_Reminder__c> existingCallReminders =SOQLSingletonQueries.setOppIds(oppIds).callRemindersByOppIds;
    		Map<Id, List<Call_Reminder__c>> existingCallRemindersOpptyIds = new Map<Id, List<Call_Reminder__c>>();
    		for(Call_Reminder__c cr: existingCallReminders.values()){
    			if(!existingCallRemindersOpptyIds.containsKey(cr.Custom_Opportunity__c)){
    				existingCallRemindersOpptyIds.put(cr.Custom_Opportunity__c, new List<Call_Reminder__c>());
    			}
    			existingCallRemindersOpptyIds.get(cr.Custom_Opportunity__c).add(cr);
    			
    		}
    		for (Custom_Opportunity__c newOpp : newList){
    			if(newOpp.Status__c == 'Settled' && newOpp.Status__c != oldMap.get(newOpp.Id).Status__c){
    				if(existingCallRemindersOpptyIds == null || existingCallRemindersOpptyIds.isEmpty() || existingCallRemindersOpptyIds.get(newOpp.Id) == null || existingCallRemindersOpptyIds.get(newOpp.Id).isEmpty()){
    					Call_Reminder__c cRem1 = new Call_Reminder__c(Name = '3rd month reminder', Custom_Opportunity__c = newOpp.Id);
                        callRemindersToAdd.add(cRem1);
                        Call_Reminder__c cRem2 = new Call_Reminder__c(Name = '1st year reminder', Custom_Opportunity__c = newOpp.Id);
                        callRemindersToAdd.add(cRem2);
                        Call_Reminder__c cRem3 = new Call_Reminder__c(Name = '2nd year reminder', Custom_Opportunity__c = newOpp.Id);
                        callRemindersToAdd.add(cRem3);
                        Call_Reminder__c cRem4 = new Call_Reminder__c(Name = '3rd year reminder', Custom_Opportunity__c = newOpp.Id);
                        callRemindersToAdd.add(cRem4);
                        Call_Reminder__c cRem5 = new Call_Reminder__c(Name = '4th year reminder', Custom_Opportunity__c = newOpp.Id);
                        callRemindersToAdd.add(cRem5);
    				}
    			} else {
    				if(existingCallRemindersOpptyIds != null && !existingCallRemindersOpptyIds.isEmpty() && existingCallRemindersOpptyIds.get(newOpp.Id) != null && !existingCallRemindersOpptyIds.get(newOpp.Id).isEmpty()){
    					for(Call_Reminder__c toDel : existingCallRemindersOpptyIds.get(newOpp.Id)){
    						callRemindersToDel.add(toDel);
    					}
    				}
    			}
    		}
    	}
    	
    	try{
    		if(!callRemindersToAdd.isEmpty()){
                insert callRemindersToAdd;
            }
            if(!callRemindersToDel.isEmpty()){
            	delete callRemindersToDel;
            }
    	} catch(Exception e) {
        	System.debug('@@ERROR:' + e.getMessage());
		}
    }
    
    public static void opportunityMakeFeefoCallout(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	if(newList.size() == 1){
    		Set<Id> calloutOpps = new Set<Id> ();
	    	for (Custom_Opportunity__c cp : newList){
	    		if(cp.Status__c != oldMap.get(cp.Id).Status__c && cp.Status__c == 'Settled'){
	    			calloutOpps.add(cp.Id);
	    		} else if(cp.Status__c != oldMap.get(cp.Id).Status__c && cp.Status__c == 'Closed Opportunity' && (
					'Cannot contact after 6 + attempts'.equals(cp.Reason_for_Closure__c) ||
					'Client changed their mind'.equals(cp.Reason_for_Closure__c) ||
					'Could not beat quote'.equals(cp.Reason_for_Closure__c) ||
					'Send details for future reference'.equals(cp.Reason_for_Closure__c))){
	    			calloutOpps.add(cp.Id);
	    		}
	    	}
	    	try{
	    		if(!Test.isRunningTest()) {
	                if (!calloutOpps.isEmpty()) {
	                    FeefoCallout.makeFeefoCallout (calloutOpps);
	                }
	            }
	    	} catch(Exception e) {
	        	System.debug('@@ERROR:' + e.getMessage());
			}
    	}
    }
    
    public static void opportunityMakeFeefoCallout(List<Custom_Opportunity__c> newList){
    	if(newList.size() == 1){
    		Set<Id> calloutOpps = new Set<Id> ();
	    	for (Custom_Opportunity__c cp : newList){
	    		if(cp.Status__c == 'Settled'){
	    			calloutOpps.add(cp.Id);
	    		}
	    	}
	    	
	    	
	    	try{
	    		if(!Test.isRunningTest()) {
	                if (!calloutOpps.isEmpty()) {
	                    FeefoCallout.makeFeefoCallout (calloutOpps);
	                }
	            }
	    	} catch(Exception e) {
	        	System.debug('@@ERROR:' + e.getMessage());
			}
    	}
    }
    
    public static void enqueueActiveOpp(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	Set<Id> OppUpdsIds = new Set<Id>();
    	Map<Id,String> idToStatusMap = new Map<Id,String>(); 
    	List<Custom_Opportunity__c> listOppUpdate = new List<Custom_Opportunity__c>();
    	for (Custom_Opportunity__c newOpp : newList){ 
    		if(newOpp.name != oldMap.get(newOpp.id).name 
    			|| newOpp.Status__c != oldMap.get(newOpp.id).Status__c 
    			|| newOpp.Reason_for_Closure__c != oldMap.get(newOpp.id).Reason_for_Closure__c 
    			|| newOpp.Opp_Loan_Term__c != oldMap.get(newOpp.id).Opp_Loan_Term__c 
    			|| newOpp.Opp_Loan_Type__c != oldMap.get(newOpp.id).Opp_Loan_Type__c 
    			|| newOpp.Owner_Name__c != oldMap.get(newOpp.id).Owner_Name__c 
    			//|| newOpp.Settled_and_Mortgaged__c != oldMap.get(newOpp.id).Settled_and_Mortgaged__c
    			){
    				
    			OppUpdsIds.add(newOpp.Id);
    			listOppUpdate.add(newOpp);
    			
    			if(newOpp.Status__c != oldMap.get(newOpp.id).Status__c || newOpp.Reason_For_Closure__c != oldMap.get(newOpp.Id).Reason_For_Closure__c){
                	idToStatusMap.put(newOpp.id,'Yes');
               	}else{
                	idToStatusMap.put(newOpp.id,'No');
             	}
    		}
    	}
    	
    	if(OppUpdsIds.size()>0){
    		integer ctr;
            List<Custom_Opportunity__c> oppBatch = new List<Custom_Opportunity__c>();
            List<Custom_Opportunity__c> oppBatch2 = new List<Custom_Opportunity__c>();
                
            if (listOppUpdate.size() > 40)    {                     
              	for (ctr = 0; ctr > 40; ctr++){
                   	oppBatch.add(listOppUpdate[ctr]);
                    listOppUpdate.remove(ctr);
               	}                           
            }
            if(listOppUpdate.size() > 0){
               	for(Custom_Opportunity__c opp: listOppUpdate){
                   	oppBatch2.add(opp);
               	}
            }
            
       		if(!Test.isRunningTest()) {             
               	if(!oppBatch.isEmpty()){
                	System.enqueueJob(new queueActiveOppTagCallout (oppBatch,idToStatusMap)); 
              	}
                if(!oppBatch2.isEmpty()){
                	System.enqueueJob(new queueActiveOppTagCallout (oppBatch2,idToStatusMap));
               	}
    		}
    	}
    }

    public static void enqueueActiveOpp(List<Custom_Opportunity__c> newList){
    	System.debug('enqueueActiveOpp...');
    	Set<Id> oppIds = new Set<Id>();
    	Map<Id,String> idToStatusMap = new Map<Id,String>(); 
    	List<Custom_Opportunity__c> listOppInsert = new List<Custom_Opportunity__c>();
    	for (Custom_Opportunity__c newOpp : newList){ 
    		listOppInsert.add(newOpp);
    		oppIds.add(newOpp.Id);
    		idToStatusMap.put(newOpp.id,'Yes');
    	}
    	
    	if(oppIds.size()>0){
    		integer ctr;
            List<Custom_Opportunity__c> oppBatch = new List<Custom_Opportunity__c>();
            List<Custom_Opportunity__c> oppBatch2 = new List<Custom_Opportunity__c>();
                
            if (listOppInsert.size() > 40){                     
              	for (ctr = 0; ctr > 40; ctr++){
                   	oppBatch.add(listOppInsert[ctr]);
                    listOppInsert.remove(ctr);
               	}
            }
            if(listOppInsert.size() > 0){
               	for(Custom_Opportunity__c opp: listOppInsert){
                   	oppBatch2.add(opp);
               	}
            }
            
       		if(!Test.isRunningTest()) {
               	if(!oppBatch.isEmpty()){
                	System.enqueueJob(new queueActiveOppTagCallout(oppBatch, idToStatusMap)); 
              	}
                if(!oppBatch2.isEmpty()){
                	System.enqueueJob(new queueActiveOppTagCallout(oppBatch2, idToStatusMap));
               	}
    		}
    	}
    }
    
    public static void taskCreatorOnStatusChange(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap){
    	// this should only run when 1 opportunity is inserted/updated
    	if (newList.size() == 1){
    		Custom_Opportunity__c newOpp = newList.get(0);
    		Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
			Id taskOwnerId = sysGenId;
    		if (newOpp.Account__c != null) {
    			if(String.valueOf(newOpp.OwnerId).startsWith('005')){
    				taskOwnerId = newOpp.OwnerId;
    			}
    		}
    		
    		if (oldMap == null || newOpp.Status__c != oldMap.get(newOpp.Id).Status__c){
    			set<Id> settleMntTeam= SOQLSingletonQueries.recs().settlementUserIds; 
    			if(newOpp.Status__c == 'Internal Settlement'){
                   for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           newOpp.Id,
                                           'Internal Settlement',
                                           'Overdue for Documents issue',
                                           0,
                                           'Normal',
                                           2);
                    }
                } else if (newOpp.Status__c == 'Awaiting Further Information'){
                    for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           newOpp.Id,
                                           'Awaiting Further Information',
                                           'Awaiting Paperwork',
                                           0,
                                           'Normal',
                                           4);
                    }
                
                } else if (newOpp.Status__c == 'Documents Sent'){                    
                    for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           newOpp.Id,
                                           'Documents Sent',
                                           'Follow up Client',
                                           0,
                                           'Normal',
                                           12);
                    }
                
                } else if (newOpp.Status__c == 'Sent to Lender'){                    
                    for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           newOpp.Id,
                                           'Sent to Lender',
                                           'Docs to Lender',
                                           0,
                                           'Normal',
                                           4);
                    }                
                } else if (newOpp.Status__c == 'Settlement Rejected'){
                    for( Id stlId:settleMntTeam){
                        TaskCreator.CreateTask(stlId,
                                           newOpp.Id,
                                           'Settlement Rejected',
                                           'Check Settlement Status',
                                           0,
                                           'Normal',
                                           1);
                    }
                } else if (newOpp.Status__c == 'Invoice Received'){                                 
                    String comments = 'Please complete the following:\n\n';
                    comments += '1. Generate doc worksheet\n';
                    comments += '2. Preliminary assessment\n';
                    comments += '3. Prepare documents ready for settlement';
                
                    TaskCreator.CreateTask(taskOwnerId,
                                           newOpp.Id,
                                           'Pre-settlement tasks for ' + newOpp.Name,
                                           comments,                                       
                                           1,
                                           'Normal',
                                           24);       
                }
    		}
    	}
    }

    //Lelo 				2017-06-27
    public static void checkPreApprovedStatusDate(
      List<Custom_Opportunity__c> newList, 
      Map<Id, Custom_Opportunity__c> oldMap
    ){
    	for (Custom_Opportunity__c o : newList) {
    		if(o.Status__c != oldMap.get(o.Id).Status__c){
				if (o.Status__c == 'Pre-Approved') { 
					Datetime a = Datetime.now().addHours(11);
          if (o.Pre_Approved_Date__c == null){
					  o.Pre_Approved_Date__c = Datetime.now();
          }
          if (o.Date_Pre_Approved__c == null){
					  o.Date_Pre_Approved__c = a.date();
          }
				}
			}
    	}
    }
    //-
    
    //Lelo 				2017-10-10
    public static void uploadS3ApplicationDocs(List<Custom_Opportunity__c> newList, Map<Id, Custom_Opportunity__c> oldMap) {
    	//System.debug('uploadS3ApplicationDocs...');
    	for (Custom_Opportunity__c o : newList) {
    		//System.debug('Opp name: ' + o.Name + ' | ' + o.Application__c);
    		if (o.Application__c != null) {
    			Custom_Opportunity__c oOld = null;
    			if (oldMap != null && !oldMap.isEmpty()) {
    				oOld = oldMap.get(o.Id);
    				//System.debug('oOld: ' + oOld.Application__c);
    			}
    			if (
            o.Application__c != null && 
            (
              (oOld == null) ||
              (oOld.Application__c == null) ||
              (!o.Application__c.equals(oOld.Application__c))
            )
          ) {
    				Application__c app = [
              SELECT Supporting_Document_1__c, Supporting_Doc_Type_1__c, 
                      Supporting_Document_2__c, Supporting_Doc_Type_2__c,
                      Supporting_Document_3__c, Supporting_Doc_Type_3__c,
                      Supporting_Document_4__c, Supporting_Doc_Type_4__c,
                      Supporting_Document_5__c, Supporting_Doc_Type_5__c,
                      Supporting_Document_6__c, Supporting_Doc_Type_6__c,
                      Supporting_Document_7__c, Supporting_Doc_Type_7__c,
                      Supporting_Document_8__c, Supporting_Doc_Type_8__c,
                      Supporting_Document_9__c, Supporting_Doc_Type_9__c,
                      Supporting_Document_10__c, Supporting_Doc_Type_10__c
              FROM Application__c WHERE Id = :o.Application__c];
    				if (String.isNotBlank(app.Supporting_Document_1__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_1__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_1__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_1__c, app.Supporting_Doc_Type_1__c);
    					}	
    				}
    				if (String.isNotBlank(app.Supporting_Document_2__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_2__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_2__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_2__c, app.Supporting_Doc_Type_2__c);
    					}	
    				}
    				if (String.isNotBlank(app.Supporting_Document_3__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_3__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_3__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_3__c, app.Supporting_Doc_Type_3__c);
    					}	
    				}
    				if (String.isNotBlank(app.Supporting_Document_4__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_4__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_4__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_4__c, app.Supporting_Doc_Type_4__c);
    					}	
    				}
    				if (String.isNotBlank(app.Supporting_Document_5__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_5__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_5__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_5__c, app.Supporting_Doc_Type_5__c);
    					}	
    				}
            if (String.isNotBlank(app.Supporting_Document_6__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_6__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_6__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_6__c, app.Supporting_Doc_Type_6__c);
    					}	
    				}
            if (String.isNotBlank(app.Supporting_Document_7__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_7__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_7__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_7__c, app.Supporting_Doc_Type_7__c);
    					}	
    				}
            if (String.isNotBlank(app.Supporting_Document_8__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_8__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_8__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_8__c, app.Supporting_Doc_Type_8__c);
    					}	
    				}
            if (String.isNotBlank(app.Supporting_Document_9__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_9__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_9__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_9__c, app.Supporting_Doc_Type_9__c);
    					}	
    				}
            if (String.isNotBlank(app.Supporting_Document_10__c)) {
    					if (!CloudDocsHelper.isFileNameUploaded(o.Id, CloudDocsHelper.getFileName(app.Supporting_Document_10__c)) &&
    						CloudDocsHelper.isS3AmazonUrlLink(app.Supporting_Document_10__c)) {
    						CloudDocsHelper.uploadFileFromUrl(o.Id, app.Supporting_Document_10__c, app.Supporting_Doc_Type_10__c);
    					}	
    				}

    			}
    		}
    	}
    }
    //-

    //HJ - Unresolved process - 14022019  - I
    public static void updateUnresolvedProcessByLastModified(List<Custom_Opportunity__c> newRecords, Map<Id, Custom_Opportunity__c> oldMap){

    	Set<Id> oppsId = new Set<Id>();
    	for (Custom_Opportunity__c op : newRecords){
            oppsId.add(op.Id);
        }

        List<Custom_Opportunity__c> opps = [
			Select id, Date_Last_Call_Activity__c, Date_Send_To_Aspect__c 
			from Custom_Opportunity__c where Id in :oppsId];
        DateTime toSendAspect = DateUtils.getDateOfWorkingDay(System.now(), 7);
        Date newDate = date.newinstance(toSendAspect.year(), toSendAspect.month(), toSendAspect.day());

        if (!opps.isEmpty()){

        	List<Custom_Opportunity__c> updateOpps = new List<Custom_Opportunity__c>();

        	for (Custom_Opportunity__c o : opps){
        		o.Date_Send_To_Aspect__c = newDate;
        		updateOpps.add(o);
        	}

        	if (!updateOpps.isEmpty()){
        		update updateOpps;
        	}      	
        }
    }
    //HJ - Unresolved process - 14022019  - F

	public static void checkCallCenterNotification(List<Custom_Opportunity__c> newRecords) {
		if (newRecords == null || newRecords.isEmpty()) return;
		Set<Id> ids = new Set<Id>();
		for (Custom_Opportunity__c o : newRecords) {
			if (o.Lead__c != null) {
				ids.add(o.Lead__c);
			}
		}
		if (!ids.isEmpty()) {
			ipSCAPEService.completeLeads(ids);
		}
	}
    //Jesus Mora 2019-11-27 start
    public static void resetClonedDetails(List<Custom_Opportunity__c> newList){
      for(Custom_Opportunity__c opp: newList){
        if(opp.isClone()){
          if(!opp.OwnerType__c.equals('Queue')){
            List<Custom_Opportunity__c> r = [
              SELECT OwnerId FROM Custom_Opportunity__c WHERE Id = :opp.getCloneSourceId()
            ];
            for(Custom_Opportunity__c o: r){
              opp.OwnerId = o.OwnerId;
            }   
          }
          opp.Cloned__c = true;
          opp.VD_Owner__c = null;
          opp.VD_Worksheet__c = null;
          opp.Status__c = 'Become Opportunity';
          opp.Loan_Product__c = null;
          opp.Application_AssetDetail__c = null;
          opp.Date_Pre_Approved__c = null;
          opp.Date_Closed_or_Settled__c = null;
          opp.Preapproval_Auth_Date__c = null;
          opp.Lead__c = null;
          if (opp.Application__c != null) {
            // Delete application details
            delete [Select Id From Application_Extra_Data__c Where Application__c = :opp.Application__c];
          }
        }
      } 
    }
    //Jesus Mora 2019-11-27 end

}