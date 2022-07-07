trigger trgAppAfterU on Application__c (after update) {
    /*// Find the Opps with same Application ID
    Set <Id> relatedApp = new Set <Id> ();
    for (Application__c newApp : trigger.New) {
        relatedApp.add(newApp.Id);
    }
    
    // Identify the opps by the application id
    Map <Id, Custom_Opportunity__c> matchingOppMap = new Map <Id, Custom_Opportunity__c> ();
    // list for opps to be updated
    List <Custom_Opportunity__C> OppToUpdate = new List <Custom_Opportunity__c> ();
    List <Custom_Opportunity__C> OppToUpdate2 = new List <Custom_Opportunity__c> ();
    Id recTypeId = Schema.SObjectType.Custom_Opportunity__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
    Map<Id, Application__c> appMap = new Map<Id, Application__c>([Select Id, Loan_Type_1__c, Loan_Type_2__c, Loan_Type_3__c from Application__c where Id in : relatedApp]);
    for (Custom_Opportunity__c opp: [Select Id, 
                                            Name, 
                                            Mobile_Number__c, 
                                            Email_Address__c, 
                                            Status__c, 
                                            Application__c, 
                                            Account__c,
                                            Address__c,
                                            All_Documents_Attached__c,
                                            Applicant_Net_Income__c,
                                            Approval_conditions_checked__c,
                                            ASIC_Registration__c,
                                            Borrower_Contact__c,
                                            Client_Budget__c,
                                            Co_Borrower_Net_Income__c,
                                            Confirm_Settled__c,
                                            Credit_Card_Payments__c,
                                            Current_payslip_with_vehicle_allowance__c,
                                            Date_Closed_or_Settled__c,
                                            Date_of_Birth__c,
                                            Dealer_Address__c,
                                            Dealer_Contacted__c,
                                            Dealer_Contact_Name__c,
                                            Dealer_Email__c,
                                            Dealer_Fax_Number__c,
                                            Dealer_Name__c,
                                            Dealer_Phone_Number__c,
                                            Docs_not_fraudulent_amended__c,
                                            Employer_ABN_arm_s_length__c,
                                            Employer_letter_confirming_business_use__c,
                                            Establishment_Fee__c,
                                            Existing_Loan_Payments__c,
                                            Finance_Product__c,
                                            First_Name__c,
                                            Flag_Is_Note_for_Amendment_Created__c,
                                            Flag_Is_Note_for_Formal_Approval_Created__c,
                                            Flag_Is_Note_for_Pre_Approval_Created__c,
                                            FolderId__c,
                                            Goods_Description__c,
                                            Goods_Type__c,
                                            Google_the_employer_to_match_app__c,
                                            Home_Phone__c,
                                            Insurance_Cover__c,
                                            International_Number__c,
                                            Is_your_client_a_Property_Owner__c,
                                            Last_Name__c,
                                            Lead__c,
                                            Lead_Consultant_Dealer__c,
                                            Lender_Approved__c,
                                            Pre_Approved_Vehicle_Age__c,
                                            Letter_from_Accountant__c,
                                            Living_Expenses__c,
                                            Loan_Product__c,
                                            Loan_Term_Process__c,
                                            Low_Doc_confirmation__c,
                                            Mortgage_Rent__c,
                                            New_Used__c,
                                            No_hardship_for_applicant__c,
                                            Notes__c,
                                            Notes_to_Settlement_Officer__c,
                                            Number_of_Dependents__c,
                                            Occupation__c,
                                            Occupation_Status__c,
                                            Occupation_Time_Months__c,
                                            Occupation_Time_Years__c,
                                            Other_Expenses__c,
                                            Other_Fees_or_Charges__c,
                                            Other_Income__c,
                                            Other_Income_Detail__c,
                                            Owner__c,
                                            Payout_Details__c,
                                            Payslip_shows_YTD_figure__c,
                                            Personal_references_loaded__c,
                                            Pre_Approved_Amount__c,
                                            Preferred_Lender__c,
                                            Purchase_Type__c,
                                            Reason_for_Closure__c,
                                            Recent_Business_Activity_Statement__c,
                                            Recent_Tax_Return_with_M_V_deductions__c,
                                            Record_Owner_Email__c,
                                            Required_Client_Deposit__c,
                                            Second_Applicant_Email__c,
                                            Second_Applicant_First_Name__c,
                                            Second_Applicant_Last_Name__c,
                                            Secondary_form_of_Income__c,
                                            Sent_for_Settlement_Date__c,
                                            SentToLenderNotified__c,
                                            Settled_Email_Rules__c,
                                            Settlement_Officer_Notes__c,
                                            Signed_Deed_of_Novation__c,
                                            smsoptout__c,
                                            Special_Conditions__c,
                                            Split_Expenses__c,
                                            State__c,
                                            This_Commitment__c,
                                            Trade_in_Details__c,
                                            VD_Notes__c,
                                            VD_Owner__c,
                                            VD_Reason_for_closure__c,
                                            VD_Status__c,
                                            Vehicle_Details__c,
                                            Vehicle_securities_registration_fee__c,
                                            Vendor_and_purchaser_arm_s_length__c,
                                            VerifiedFields__c,
                                            Work_Phone__c,
                                            RecordTypeId
                                            From Custom_Opportunity__c where Application__c IN : relatedApp]) {
        
        matchingOppMap.put(opp.Application__c, opp);
        
        //if(opp.Status__c == 'Settled') {
            //Custom_Opportunity__c clonedOpp = opp.clone(false, true, false, false);
            //clonedOpp.Settled_and_Mortgaged__c = false;
            //for(Id appId : appMap.keySet()){
                if(appMap.get(opp.Application__c).Loan_Type_1__c == 'Mortgage' && (appMap.get(opp.Application__c).Loan_Type_1__c != Trigger.OldMap.get(opp.Application__c).Loan_Type_1__c)){
                    //clonedOpp.Settled_and_Mortgaged__c = true;
                    opp.Settled_and_Mortgaged__c = true;
                } else {
                    
                    //opp.Settled_and_Mortgaged__c = false;
                
                    if(appMap.get(opp.Application__c).Loan_Type_2__c == 'Mortgage' && (appMap.get(opp.Application__c).Loan_Type_2__c != Trigger.OldMap.get(opp.Application__c).Loan_Type_2__c)){
                        //clonedOpp.Settled_and_Mortgaged__c = true;
                        opp.Settled_and_Mortgaged__c = true;
                    } else {
                        
                        //opp.Settled_and_Mortgaged__c = false;
                    
                        if(appMap.get(opp.Application__c).Loan_Type_3__c == 'Mortgage' && (appMap.get(opp.Application__c).Loan_Type_3__c != Trigger.OldMap.get(opp.Application__c).Loan_Type_3__c)){
                            //clonedOpp.Settled_and_Mortgaged__c = true;
                            opp.Settled_and_Mortgaged__c = true;
                        } else {
                            opp.Settled_and_Mortgaged__c = false;
                        }
                    }
                }
                //clonedOpp.RecordTypeId = recTypeId;
                /*if(opp.Settled_and_Mortgaged__c){
                    
                }
                OppToUpdate2.add(opp);
                //OppToUpdate.add(opp);
            //}
        //}
    }
    
    for (Application__c newApp: trigger.New) {
        if (matchingOppMap.get(newApp.Id) != null) {
            Custom_Opportunity__c oppBuffer = new Custom_Opportunity__c ();
            oppBuffer = matchingOppMap.get(newApp.Id);
            
            if (/*oppBuffer.Status__c != 'Closed Opportunity' && oppBuffer.Status__c != 'Unresolved Opportunity' && oppBuffer.Status__c != 'Settled') {
                
                // Sync with Opportunity Sencond Applicant info
                if (newApp.First_Name_2__c != null) {
                    oppBuffer.Second_Applicant_First_Name__c = newApp.First_Name_2__c;
                }
                if (newApp.Last_Name_2__c != null) {
                    oppBuffer.Second_Applicant_Last_Name__c = newApp.Last_Name_2__c;
                }
                if (newApp.Email_Address_2__c != null) {
                    oppBuffer.Second_Applicant_Email__c = newApp.Email_Address_2__c;
                }
                
                // update the living expenses for the Opportunity
                if (newApp.First_Name_2__c == null || newApp.Last_Name_2__c == null) {
                    if (newApp.Marital_Status_1__c != null) {
                    if (newApp.Marital_Status_1__c == 'Single') {
                        if (newApp.No_of_Dependants_1__c == 0) {
                            oppBuffer.Living_Expenses__c = 1185;
                        } else if (newApp.No_of_Dependants_1__c == 1) {
                            oppBuffer.Living_Expenses__c = 1525;
                        } else if (newApp.No_of_Dependants_1__c == 2) {
                            oppBuffer.Living_Expenses__c = 1865;
                        } else if (newApp.No_of_Dependants_1__c == 3) {
                            oppBuffer.Living_Expenses__c = 2205;
                        } else if (newApp.No_of_Dependants_1__c == 4) {
                            oppBuffer.Living_Expenses__c = 2545;
                        } else if (newApp.No_of_Dependants_1__c == 5) {
                            oppBuffer.Living_Expenses__c = 2885;
                        } else {
                            oppBuffer.Living_Expenses__c = 3225;
                        } // end if for Marital_Status_1__c == 'Single'
                    } else {
                        if (newApp.No_of_Dependants_1__c == 0) {
                            oppBuffer.Living_Expenses__c = 2261;
                        } else if (newApp.No_of_Dependants_1__c == 1) {
                            oppBuffer.Living_Expenses__c = 2601;
                        } else if (newApp.No_of_Dependants_1__c == 2) {
                            oppBuffer.Living_Expenses__c = 2941;
                        } else if (newApp.No_of_Dependants_1__c == 3) {
                            oppBuffer.Living_Expenses__c = 3281;
                        } else if (newApp.No_of_Dependants_1__c == 4) {
                            oppBuffer.Living_Expenses__c = 3621;
                        } else if (newApp.No_of_Dependants_1__c == 5) {
                            oppBuffer.Living_Expenses__c = 3961;
                        } else {
                            oppBuffer.Living_Expenses__c = 4301;
                        }
                    } // end else for Marital_Status_1__c == 'Single'
                    } // end if for Marital_Status_1__c != null
                    // end if for First_Name_2__c == null || Last_Name_2__c == null
                } else {
                    if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 0) {
                        oppBuffer.Living_Expenses__c = 2261;
                    } else if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 1) {
                        oppBuffer.Living_Expenses__c = 2601;
                    } else if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 2) {
                        oppBuffer.Living_Expenses__c = 2941;
                    } else if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 3) {
                        oppBuffer.Living_Expenses__c = 3281;
                    } else if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 4) {
                        oppBuffer.Living_Expenses__c = 3621;
                    } else if ((newApp.No_of_Dependants_1__c + newApp.No_of_Dependants_2__c) == 5) {
                        oppBuffer.Living_Expenses__c = 3961;
                    } else {
                        oppBuffer.Living_Expenses__c = 4301;
                    }
                } // end else for First_Name_2__c == null || Last_Name_2__c == null
                // map into Do_you_own_a_property__c field
                if (newApp.Do_you_own_a_property__c == 'yes') {
                    oppBuffer.Is_your_client_a_Property_Owner__c = 'Yes';
                }
                // map into Occupation_Status__c field
                if (newApp.Mode_of_Employment_1__c != null) {
                    if (newApp.Mode_of_Employment_1__c == 'Full Time') {
                        oppBuffer.Occupation_Status__c = 'Full-Time';
                    } else if (newApp.Mode_of_Employment_1__c == 'Part Time') {
                        oppBuffer.Occupation_Status__c = 'Part-Time';
                    } else if (newApp.Mode_of_Employment_1__c == 'Casual') {
                        oppBuffer.Occupation_Status__c = 'Casual';
                    } else if (newApp.Mode_of_Employment_1__c == 'Self Employed') {
                        oppBuffer.Occupation_Status__c = 'Self Employment';
                    } else if (newApp.Mode_of_Employment_1__c == 'Contract') {
                        oppBuffer.Occupation_Status__c = 'Contract';
                    } else {
                        oppBuffer.Occupation_Status__c = 'Other';
                    }
                }
                // map into Number_of_Dependents__c field
                if (newApp.No_of_Dependants_2__c != null) {
                    oppBuffer.Number_of_Dependents__c = String.valueOf(newApp.No_of_Dependants_1__c.intValue() + newApp.No_of_Dependants_2__c.intValue());
                } else {
                    oppBuffer.Number_of_Dependents__c = String.valueOf(newApp.No_of_Dependants_1__c.intValue());
                }
                // make other expenses zero
                oppBuffer.Other_Expenses__c = 0;
                
                // Make workflow rules into apex code
                // Occupation
                oppBuffer.Occupation__c = newApp.Current_Occupation_1__c;
                // Net Income for Applicant 1
                if (newApp.Payment_Frequency_1__c == 'Weekly') {
                    oppBuffer.Applicant_Net_Income__c = newApp.Net_Income_1__c * 4.33;
                } else if (newApp.Payment_Frequency_1__c == 'Fortnightly') {
                    oppBuffer.Applicant_Net_Income__c = newApp.Net_Income_1__c / 2 * 52 / 12;
                } else if (newApp.Payment_Frequency_1__c == 'Monthly') {
                    oppBuffer.Applicant_Net_Income__c = newApp.Net_Income_1__c;
                }
                // Net Income for Applicant 2 or Partner Income
                if (newApp.No_of_People__c == 2) {
                    if (newApp.Payment_Frequency_2__c == 'Weekly') {
                        oppBuffer.Co_Borrower_Net_Income__c = newApp.Net_Income_2__c * 4.33;
                    } else if (newApp.Payment_Frequency_2__c == 'Fortnightly') {
                        oppBuffer.Co_Borrower_Net_Income__c = newApp.Net_Income_2__c / 2 * 52 / 12;
                    } else if (newApp.Payment_Frequency_2__c == 'Monthly') {
                        oppBuffer.Co_Borrower_Net_Income__c = newApp.Net_Income_2__c;
                    }
                } else {
                    oppBuffer.Co_Borrower_Net_Income__c = newApp.Partner_Income__c;
                }
                // Other Income
                Decimal otherIncomes = 0;
                if (newApp.Other_Income_Amount_1_1__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_1_1__c;
                }
                if (newApp.Other_Income_Amount_1_2__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_1_2__c;
                }
                if (newApp.Other_Income_Amount_1_3__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_1_3__c;
                }
                if (newApp.Other_Income_Amount_2_1__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_2_1__c;
                }
                if (newApp.Other_Income_Amount_2_2__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_2_2__c;
                }
                if (newApp.Other_Income_Amount_2_3__c != null) {
                    otherIncomes += newApp.Other_Income_Amount_2_3__c;
                }
                oppBuffer.Other_Income__c = otherIncomes;
                // Other Income Detail
                if (oppBuffer.Other_Income__c == 0) {
                    oppBuffer.Other_Income_Detail__c = 'Nothing';
                } else {
                    oppBuffer.Other_Income_Detail__c = 'Other Income';
                }
                // Rent/Mortgage
                Decimal sumMortgage = 0.0;
                if (newApp.Loan_Type_1__c == 'Mortgage') {
                    sumMortgage = sumMortgage + newApp.Loans_Monthly_Payments_1__c;
                }
                if (newApp.Loan_Type_2__c == 'Mortgage') {
                    sumMortgage = sumMortgage + newApp.Loans_Monthly_Payments_2__c;
                }
                if (newApp.Loan_Type_3__c == 'Mortgage') {
                    sumMortgage = sumMortgage + newApp.Loans_Monthly_Payments_3__c;
                }
                Decimal totalRent = 0;
                if (newApp.Rent_per_month_1__c != null) {
                    totalRent += newApp.Rent_per_month_1__c;
                }
                if (newApp.Rent_per_month_2__c != null) {
                   totalRent += newApp.Rent_per_month_2__c;
                }
                oppBuffer.Mortgage_Rent__c = totalRent + sumMortgage;
                // Loan
                Decimal sumLoan = 0.0;
                if (newApp.Loan_Type_1__c != 'Mortgage' && newApp.Loans_Monthly_Payments_1__c != null) {
                    sumLoan = sumLoan + newApp.Loans_Monthly_Payments_1__c;
                }
                if (newApp.Loan_Type_2__c != 'Mortgage' && newApp.Loans_Monthly_Payments_2__c != null) {
                    sumLoan = sumLoan + newApp.Loans_Monthly_Payments_2__c;
                }
                if (newApp.Loan_Type_3__c != 'Mortgage' && newApp.Loans_Monthly_Payments_3__c != null) {
                    sumLoan = sumLoan + newApp.Loans_Monthly_Payments_3__c;
                }
                oppBuffer.Existing_Loan_Payments__c = sumLoan;
                // Credit Card
                Decimal totalCreditCard = 0;
                if (newApp.Credit_Monthly_Payments_1__c !=  null) {
                    totalCreditCard += newApp.Credit_Monthly_Payments_1__c;
                }
                if (newApp.Credit_Monthly_Payments_2__c !=  null) {
                    totalCreditCard += newApp.Credit_Monthly_Payments_2__c;
                }
                if (newApp.Credit_Monthly_Payments_3__c !=  null) {
                    totalCreditCard += newApp.Credit_Monthly_Payments_3__c;
                }
                oppBuffer.Credit_Card_Payments__c = totalCreditCard;
                // This Commitment
                if (newApp.Repayment_Regularity__c == 'Week') {
                    oppBuffer.This_Commitment__c = newApp.Preferred_Repayment__c * 4.33;
                } else if (newApp.Repayment_Regularity__c == 'Fortnight') {
                    oppBuffer.This_Commitment__c = newApp.Preferred_Repayment__c * 13 / 6;
                } else {
                    oppBuffer.This_Commitment__c = newApp.Preferred_Repayment__c;
                }
                
                if (newApp.Marital_Status_1__c != Trigger.OldMap.get(newApp.Id).Marital_Status_1__c || 
                   newApp.No_of_Dependants_1__c != Trigger.OldMap.get(newApp.Id).No_of_Dependants_1__c || 
                   newApp.No_of_Dependants_2__c != Trigger.OldMap.get(newApp.Id).No_of_Dependants_2__c || 
                   newApp.Net_Income_1__c != Trigger.OldMap.get(newApp.Id).Net_Income_1__c || 
                   newApp.Net_Income_2__c != Trigger.OldMap.get(newApp.Id).Net_Income_2__c || 
                   newApp.Partner_Income__c != Trigger.OldMap.get(newApp.Id).Partner_Income__c || 
                   newApp.Other_Income_Amount_1_1__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_1_1__c || 
                   newApp.Other_Income_Amount_1_2__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_1_2__c || 
                   newApp.Other_Income_Amount_1_3__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_1_3__c || 
                   newApp.Other_Income_Amount_2_1__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_2_1__c || 
                   newApp.Other_Income_Amount_2_2__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_2_2__c || 
                   newApp.Other_Income_Amount_2_3__c != Trigger.OldMap.get(newApp.Id).Other_Income_Amount_2_3__c || 
                   newApp.Loans_Monthly_Payments_1__c != Trigger.OldMap.get(newApp.Id).Loans_Monthly_Payments_1__c || 
                   newApp.Loans_Monthly_Payments_2__c != Trigger.OldMap.get(newApp.Id).Loans_Monthly_Payments_2__c || 
                   newApp.Loans_Monthly_Payments_3__c != Trigger.OldMap.get(newApp.Id).Loans_Monthly_Payments_3__c || 
                   newApp.Rent_per_month_1__c != Trigger.OldMap.get(newApp.Id).Rent_per_month_1__c || 
                   newApp.Rent_per_month_2__c != Trigger.OldMap.get(newApp.Id).Rent_per_month_2__c || 
                   newApp.Credit_Monthly_Payments_1__c != Trigger.OldMap.get(newApp.Id).Credit_Monthly_Payments_1__c || 
                   newApp.Credit_Monthly_Payments_2__c != Trigger.OldMap.get(newApp.Id).Credit_Monthly_Payments_2__c || 
                   newApp.Credit_Monthly_Payments_3__c != Trigger.OldMap.get(newApp.Id).Credit_Monthly_Payments_3__c || 
                   newApp.Preferred_Repayment__c != Trigger.OldMap.get(newApp.Id).Preferred_Repayment__c) {
                    // generate a new doc depending on the new data of Application
                    try {
                        //SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+oppBuffer.id+'&Object=Custom_Opportunity__c&doclist=a07N0000006LbCU&oneclick=1');
                        SDOC.SDBatch.createSDoc(UserInfo.getSessionId(),'id='+oppBuffer.id+'&Object=Custom_Opportunity__c&doclist=a049000000MeNTr&oneclick=1');
                    } catch(Exception e) {
                    
                    }
                }
                
                OppToUpdate.add(oppBuffer);
            } 
        }
    }
    if(!OppToUpdate2.isEmpty()){
        update OppToUpdate2;
    }
    if(!OppToUpdate.isEmpty()){
        update OppToUpdate;
    }
    */
}