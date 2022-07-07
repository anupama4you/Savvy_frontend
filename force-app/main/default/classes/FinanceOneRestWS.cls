public class FinanceOneRestWS {
  
  public FinanceOneAPIManager mgr {set;get;}

  public FinanceOneRestWS() {
    this.mgr = new FinanceOneAPIManager();
  }

    public Boolean submitRequest(Application__c a, String o){
        Boolean sr = true;
        
        if('Business'.equals(a.Application_Type__c)){
            List<Application_Employment__c> entity = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                Work_Address__c, Phone__c,
                Unit_Number__c, Street_Number__c, Street_Type__c,
                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                Overseas_City__c, Address_Line_2__c, Address_Type__c
                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            for (Application_Employment__c e: entity) {
                System.debug(e.Unit_Number__c);
                /*
                if(String.isBlank(e.Unit_Number__c)){
                  this.mgr.addErrorMessage('Finance Details: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(e.Street_Number__c)){
                  this.mgr.addErrorMessage('Finance Details: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(e.Street_Type__c)){
                  this.mgr.addErrorMessage('Finance Details: Please select Street Type');
                  sr = false;
                }
                */                
                if(String.isBlank(e.State__c)){
                    this.mgr.addErrorMessage('Finance Details: Please select State');
                    sr = false;
                }
                
            }
            
            if(entity.isEmpty()){
                this.mgr.addErrorMessage('Finance Details: Please enter Unit Number and Street Number');
                this.mgr.addErrorMessage('Finance Details: Please select Street Type and State');
                sr = false;
            }		
            if(a.No_of_People__c == 2 && a.No_of_Directors__c == 1){
                this.mgr.addErrorMessage('Check No. of Directors');
                sr = false;
            }
            
        }
        
        List<Cloud_Documents__c> documents = [select Document_Type__c, File_Name__c from Cloud_Documents__c where 
                                                               Custom_Opportunity__c=:o and Send_To_Lender__c=true];
        
        
        if(documents.isEmpty()){
            this.mgr.addErrorMessage('There are not documents');
            sr = false;
        }
        
        if(String.isBlank(a.Gender_1__c)){
            this.mgr.addErrorMessage('Applicant 1: Please select gender');
            sr = false;
        }
        
        // if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)') || a.Current_Residence_Status_1__c.equals('Boarding')){
        if('Renting(Agent)'.equals(a.Current_Residence_Status_1__c) || 'Renting(Private)'.equals(a.Current_Residence_Status_1__c) || 'Boarding'.equals(a.Current_Residence_Status_1__c)){
            if(String.isBlank(a.Residential_Payment_Frequency_1__c)){
                this.mgr.addErrorMessage('Applicant 1: Please select Payment Frequency in LANDLORD / MORTGAGE DETAILS');
                sr = false;
            }
        }
        
        if('Yes'.equals(a.Do_you_have_drivers_licence_1__c)){
            if(String.isBlank(a.Type_of_Licence_1__c)){
                this.mgr.addErrorMessage('Applicant 1: Please select Type of Licence');
                sr = false;
            }
            if(String.isNotBlank(a.Type_of_Licence_1__c) && 'NONE'.equals(a.Type_of_Licence_1__c)){
                this.mgr.addErrorMessage('Applicant 1: Type of Licence is not accepted');
                sr = false;
            }
            System.debug(a.Expiry_Date_1__c);
            if(!FieldValidationsHelper.isDateFormatValid(a.Expiry_Date_1__c)){
                this.mgr.addErrorMessage('Applicant 1: Please fill in Expiry Date (dd/mm/yyyy)');
                sr = false;
            }
        }
        System.debug(FieldValidationsHelper.isDateFormatValid(a.Date_Moved_in_1__c));
        if(!FieldValidationsHelper.isDateFormatValid(a.Date_Moved_in_1__c)){
            this.mgr.addErrorMessage('Applicant 1 Current Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
            sr = false;
        }
        /*
        if(String.isBlank(a.Unit_Number__c)){
          this.mgr.addErrorMessage('Applicant 1 Current Residential Address: Please enter Unit Number'));
          sr = false;
        }

        if(String.isBlank(a.Street_Number__c)){
          this.mgr.addErrorMessage('Applicant 1 Current Residential Address: Please enter Street Number'));
          sr = false;
        }

        if(String.isBlank(a.Street_Type__c)){
          this.mgr.addErrorMessage('Applicant 1 Current Residential Address: Please select Street Type'));
          sr = false;
        }
        */
        if(String.isBlank(a.State__c)){
            this.mgr.addErrorMessage('Applicant 1 Current Residential Address: Please select State');
            sr = false;
        }
        
        if(String.isBlank(a.Do_you_expect_any_change_to_your_financi__c)){
            this.mgr.addErrorMessage('Please select a value for Do you expect any significant adverse change to your household financial position in the future? field');
            sr = false; 
        }
        
        if(!FieldValidationsHelper.isDateFormatValid(a.Date_Started_1__c)){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please enter Start Date');
            sr = false;
        }
        
        if(!a.Mode_of_Employment_1__c.equals('Full Time') && !a.Mode_of_Employment_1__c.equals('Part Time')	&& !a.Mode_of_Employment_1__c.equals('Casual') 
           && !a.Mode_of_Employment_1__c.equals('Unemployed') && !a.Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') && !a.Mode_of_Employment_1__c.equals('Contract') && !a.Mode_of_Employment_1__c.equals('Centrelink - Newstart only') && !a.Mode_of_Employment_1__c.equals('Self Employed')){
               this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Employment cannot be send');
               sr = false;
           }
        
        if(a.Mode_of_Employment_1__c.equals('Self Employed') && a.Application_Type__c.equals('Personal')){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Employment cannot be send');
            sr = false;
        }
        
        if (a.Previous_Country_1__c != null && 
            (String.isNotBlank(a.Date_From_1__c) 
             || String.isNotBlank(a.Previous_Street_Address_1__c)
             || String.isNotBlank(a.Previous_Residence_Status_1__c))) {
                 if(String.isBlank(a.Date_From_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 /*
                if(String.isBlank(a.Previous_Unit_Number_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Number_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Type_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Street_Address_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please enter Street Name');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Country_1__c)){
                     if(String.isBlank(a.Previous_State_1__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please select State');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Country_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please select Country');
                     sr = false;
                 }
                 
                 if(String.isBlank(a.Previous_Residence_Status_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please select Residential status');
                     sr = false;
                 }
             }
        
        if (a.Previous_Country_1b__c != null && 
            (String.isNotBlank(a.Date_From_1b__c) 
             || String.isNotBlank(a.Previous_Street_Address_1b__c)
             || String.isNotBlank(a.Previous_Residence_Status_1b__c))) {
                 if(String.isBlank(a.Date_From_1b__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1b__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 /*
                if(String.isBlank(a.Previous_Unit_Number_1b__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Number_1b__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Type_1b__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Street_Address_1b__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please enter Street Name');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Country_1b__c)){
                     if(String.isBlank(a.Previous_State_1b__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please select State');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Country_1b__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please select Country');
                     sr = false;
                 }
                 
                 if(String.isBlank(a.Previous_Residence_Status_1b__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please select Residential status');
                     sr = false;
                 }
             }
        
        if (a.Previous_Country_1c__c != null && 
            (String.isNotBlank(a.Date_From_1c__c) 
             || String.isNotBlank(a.Previous_Street_Address_1c__c)
             || String.isNotBlank(a.Previous_Residence_Status_1c__c))) {
                 if(String.isBlank(a.Date_From_1c__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1c__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 /*
                if(String.isBlank(a.Previous_Unit_Number_1c__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Number_1c__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Type_1c__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Street_Address_1c__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please enter Street Name');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Country_1c__c)){
                     if(String.isBlank(a.Previous_State_1c__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please select State');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Country_1c__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please select Country');
                     sr = false;
                 }
                 
                 if(String.isBlank(a.Previous_Residence_Status_1c__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please select Residential status');
                     sr = false;
                 }
             }		
        
        if (a.Previous_Country_1d__c != null && 
            (String.isNotBlank(a.Date_From_1d__c) 
             || String.isNotBlank(a.Previous_Street_Address_1d__c)
             || String.isNotBlank(a.Previous_Residence_Status_1d__c))) {
                 if(String.isBlank(a.Date_From_1d__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1d__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 /*
                if(String.isBlank(a.Previous_Unit_Number_1d__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Number_1d__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Type_1d__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Street_Address_1d__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please enter Street Name');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Country_1d__c)){
                     if(String.isBlank(a.Previous_State_1d__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please select State');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Country_1d__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please select Country');
                     sr = false;
                 }
                 
                 if(String.isBlank(a.Previous_Residence_Status_1d__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please select Residential status');
                     sr = false;
                 }
             }
        
        if (a.Previous_Country_1e__c != null && 
            (String.isNotBlank(a.Date_From_1e__c) 
             || String.isNotBlank(a.Previous_Street_Address_1e__c)
             || String.isNotBlank(a.Previous_Residence_Status_1e__c))) {
                 if(String.isBlank(a.Date_From_1e__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1e__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 /*
                if(String.isBlank(a.Previous_Unit_Number_1e__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Number_1e__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Street_Type_1e__c)){
                  this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Street_Address_1e__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please enter Street Name');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Country_1e__c)){
                     if(String.isBlank(a.Previous_State_1e__c)){
                         this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please select State');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Country_1e__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please select Country');
                     sr = false;
                 }
                 
                 if(String.isBlank(a.Previous_Residence_Status_1e__c)){
                     this.mgr.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please select Residential status');
                     sr = false;
                 }
             }
            /*
          if(String.isBlank(a.Current_Work_Unit_Number_1__c)){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please enter Unit Number');
            sr = false;
          }

          if(String.isBlank(a.Current_Work_Street_Number_1__c)){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please enter Street Number');
            sr = false;
          }

          if(String.isBlank(a.Current_Work_Street_Type_1__c)){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please select Street Type');
            sr = false;
          }
          */
        if(String.isBlank(a.Current_Work_State_1__c)){
            this.mgr.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please select State');
            sr = false;
        }
        
        List<Application_Employment__c> e = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c = '1'];
        
        for (Application_Employment__c emp: e) {
            /*
            if(String.isBlank(emp.Unit_Number__c)){
              this.mgr.addErrorMessage('Applicant 1 - Second Job: Please enter Unit Number');
              sr = false;
            }
            */
            if(!emp.Employment_Type__c.equals('Full Time') && !emp.Employment_Type__c.equals('Part Time') && !emp.Employment_Type__c.equals('Casual') 
               && !emp.Employment_Type__c.equals('Unemployed') && !emp.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') && !emp.Employment_Type__c.equals('Contract') && !emp.Employment_Type__c.equals('Centrelink - Newstart only')){
                   this.mgr.addErrorMessage('Applicant 1 - Second Job: Employment cannot be send');
                   sr = false;
               }
            
            if(FinanceOneRestWS.otherIncomeSecondJob(1, a)){
                this.mgr.addErrorMessage('Applicant 1: Remove second job in Other Income');
                sr = false;
            }
        }
        
        if(e.isEmpty() && FinanceOneRestWS.otherIncomeSecondJob(1, a)){
            this.mgr.addErrorMessage('Applicant 1: Please add details of second job and remove second job in Other Income');
            sr = false;
        }
        
        if (a.Previous_Work_Country_1__c != null && 
            (String.isNotBlank(a.Start_Date_1__c)
             || String.isNotBlank(a.Finish_Date_1__c)
             || String.isNotBlank(a.Previous_Work_Address_1__c)
             || String.isNotBlank(a.Previous_Mode_of_Employment_1__c))) {
                 /*
                if(String.isBlank(a.Previous_Work_Unit_Number_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(a.Previous_Work_Street_Number_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Street Number');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Previous_Work_Address_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Work Address');
                     sr = false;
                 }
                 /*
                if(String.isBlank(a.Previous_Work_Street_Type_1__c)){
                  this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please select Street Type');
                  sr = false;
                }
                */
                 if(String.isBlank(a.Start_Date_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Start Date');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Start_Date_1__c)){
                         this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in Start Date (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Finish_Date_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Finish Date');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Finish_Date_1__c)){
                         this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in	Finish Date (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Previous_Mode_of_Employment_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please select Employment Type');
                     sr = false;
                 }else{
                     if(!a.Previous_Mode_of_Employment_1__c.equals('Full Time') && !a.Previous_Mode_of_Employment_1__c.equals('Part Time') && !a.Previous_Mode_of_Employment_1__c.equals('Casual') 
                        && !a.Previous_Mode_of_Employment_1__c.equals('Unemployed') && !a.Previous_Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') && !a.Previous_Mode_of_Employment_1__c.equals('Contract')){
                            this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Employment cannot be send');
                            sr = false;
                        }
                 }
                 
                 if(String.isBlank(a.Previous_Work_Country_1__c)){
                     this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please select Country');
                     sr = false;
                 }
                 
                 if('AUS'.equals(a.Previous_Work_Country_1__c)){
                     if(String.isBlank(a.Previous_Work_State_1__c)){
                         this.mgr.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter State');
                         sr = false;
                     }
                 }
             }
        
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c = '1'];
        
        Integer previousEmployment = 2;
        for (Application_Employment__c emp: lst) {
            
            if(emp.Finish_Date__c == null){
                this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Finish Date');
                sr = false;
                
            }
            
            if(emp.Start_Date__c == null){
                this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Start Date');
                sr = false;
                
            }
            /*
            if(String.isBlank(emp.Unit_Number__c)){
              this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Unit Number');
              sr = false;
            }

            if(String.isBlank(emp.Street_Number__c)){
              this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Street Number');
              sr = false;
            }

            if(String.isBlank(emp.Street_Type__c)){
              this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please select Street Type');
              sr = false;
            }
            */
            if(String.isBlank(emp.Work_Address__c)){
                this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Work Address');
                sr = false;
            }
            
            if(String.isBlank(emp.Employment_Type__c)){
                this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please select Employment Type');
                sr = false;
            }else{
                if(!emp.Employment_Type__c.equals('Full Time') && !emp.Employment_Type__c.equals('Part Time') && !emp.Employment_Type__c.equals('Casual') 
                   && !emp.Employment_Type__c.equals('Unemployed') && !emp.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') && !emp.Employment_Type__c.equals('Contract') && !emp.Employment_Type__c.equals('Centrelink - Newstart only')){
                       this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Employment cannot be send');
                       sr = false;
                   }
            }
            
            if('AUS'.equals(emp.Country__c)){
                if(String.isBlank(emp.State__c)){
                    this.mgr.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Work Address');
                    sr = false;
                }
            }
            
            previousEmployment++;
        }
        
        if(a.No_of_People__c == 2){
            if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
                if(a.Current_Residence_Status_2__c.equals('Renting(Agent)') || a.Current_Residence_Status_2__c.equals('Renting(Private)') || a.Current_Residence_Status_2__c.equals('Boarding')){
                    if(String.isBlank(a.Residential_Payment_Frequency_2__c)){
                        this.mgr.addErrorMessage('Applicant 2: Please select Payment Frequency in LANDLORD / MORTGAGE DETAILS');
                        sr = false;
                    }
                }

                if(!FieldValidationsHelper.isDateFormatValid(a.Date_Moved_in_2__c)){
                    this.mgr.addErrorMessage('Applicant 2 Current Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                    sr = false;
                }
                
                if(String.isBlank(a.State_2__c)){
                    this.mgr.addErrorMessage('Applicant 2 Current Residential Address: Please select State');
                    sr = false;
                }

                if (a.Previous_Country_2__c != null && 
                (String.isNotBlank(a.Date_From_2__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2__c))) {
                     if(String.isBlank(a.Date_From_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     /*
                    if(String.isBlank(a.Previous_Unit_Number_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please enter Unit Number');
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Number_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please enter Street Number');
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Type_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please select Street Type');
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Previous_Street_Address_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please enter Street Name');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Country_2__c)){
                         if(String.isBlank(a.Previous_State_2__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please select State');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Country_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please select Country');
                         sr = false;
                     }
                     
                     if(String.isBlank(a.Previous_Residence_Status_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please select Residential status');
                         sr = false;
                     }
                 }
            
            if (a.Previous_Country_2b__c != null && 
                (String.isNotBlank(a.Date_From_2b__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2b__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2b__c))) {
                     if(String.isBlank(a.Date_From_2b__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2b__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     /*
                    if(String.isBlank(a.Previous_Unit_Number_2b__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please enter Unit Number'));
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Number_2b__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please enter Street Number'));
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Type_2b__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please select Street Type'));
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Previous_Street_Address_2b__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please enter Street Name');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Country_2b__c)){
                         if(String.isBlank(a.Previous_State_2b__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please select State');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Country_2b__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please select Country');
                         sr = false;
                     }
                     
                     if(String.isBlank(a.Previous_Residence_Status_2b__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please select Residential status');
                         sr = false;
                     }
                 }
            
            if (a.Previous_Country_2c__c != null && 
                (String.isNotBlank(a.Date_From_2c__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2c__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2c__c))) {
                     if(String.isBlank(a.Date_From_2c__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2c__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     /*
                    if(String.isBlank(a.Previous_Unit_Number_2c__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please enter Unit Number');
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Number_2c__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please enter Street Number');
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Type_2c__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please select Street Type');
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Previous_Street_Address_2c__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please enter Street Name');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Country_2c__c)){
                         if(String.isBlank(a.Previous_State_2c__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please select State');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Country_2c__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please select Country');
                         sr = false;
                     }
                     
                     if(String.isBlank(a.Previous_Residence_Status_2c__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please select Residential status');
                         sr = false;
                     }
                 }		
            
            if (a.Previous_Country_2d__c != null && 
                (String.isNotBlank(a.Date_From_2d__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2d__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2d__c))) {
                     if(String.isBlank(a.Date_From_2d__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2d__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     /*
                      if(String.isBlank(a.Previous_Unit_Number_2d__c)){
                        this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please enter Unit Number');
                        sr = false;
                      }

                      if(String.isBlank(a.Previous_Street_Number_2d__c)){
                        this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please enter Street Number');
                        sr = false;
                      }

                      if(String.isBlank(a.Previous_Street_Type_2d__c)){
                        this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please select Street Type');
                        sr = false;
                      }
                      */
                     if(String.isBlank(a.Previous_Street_Address_2d__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please enter Street Name');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Country_2d__c)){
                         if(String.isBlank(a.Previous_State_2d__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please select State');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Country_2d__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please select Country');
                         sr = false;
                     }
                     
                     if(String.isBlank(a.Previous_Residence_Status_2d__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please select Residential status');
                         sr = false;
                     }
                 }
            
            if (a.Previous_Country_2e__c != null && 
                (String.isNotBlank(a.Date_From_2e__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2e__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2e__c))) {
                     if(String.isBlank(a.Date_From_2e__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2e__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     /*
                    if(String.isBlank(a.Previous_Unit_Number_2e__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please enter Unit Number'));
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Number_2e__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please enter Street Number'));
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Street_Type_2e__c)){
                      this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please select Street Type'));
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Previous_Street_Address_2e__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please enter Street Name');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Country_2e__c)){
                         if(String.isBlank(a.Previous_State_2e__c)){
                             this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please select State');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Country_2e__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please select Country');
                         sr = false;
                     }
                     
                     if(String.isBlank(a.Previous_Residence_Status_2e__c)){
                         this.mgr.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please select Residential status');
                         sr = false;
                     }
                 }
            }
            
            if(String.isBlank(a.Gender_2__c)){
                this.mgr.addErrorMessage('Applicant 2: Please select gender');
                sr = false;
            }
            
            if(a.Do_you_have_drivers_licence_2__c.equals('Yes')){
                if(String.isBlank(a.Type_of_Licence_2__c)){
                    this.mgr.addErrorMessage('Applicant 2: Please select Type of Licence');
                    sr = false;
                }
                
                if(String.isNotBlank(a.Type_of_Licence_2__c) && 'NONE'.equals(a.Type_of_Licence_2__c)){
                    this.mgr.addErrorMessage('Applicant 2: Type of Licence is not accepted');
                    sr = false;
                }
                
                if(!FieldValidationsHelper.isDateFormatValid(a.Expiry_Date_2__c)){
                    this.mgr.addErrorMessage('Applicant 2: Please fill in Expiry Date (dd/mm/yyyy)');
                    sr = false;
                }
            }

            /*
            if(String.isBlank(a.Unit_Number_2__c)){
              this.mgr.addErrorMessage('Applicant 2 Current Residential Address: Please enter Unit Number');
              sr = false;
            }

            if(String.isBlank(a.Street_Number_2__c)){
              this.mgr.addErrorMessage('Applicant 2 Current Residential Address: Please enter Street Number');
              sr = false;
            }

            if(String.isBlank(a.Street_Type_2__c)){
              this.mgr.addErrorMessage('Applicant 2 Current Residential Address: Please select Street Type');
              sr = false;
            }
            */
            if(!FieldValidationsHelper.isDateFormatValid(a.Date_Started_2__c)){
                this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please enter Start Date');
                sr = false;
            }
            
            if(!a.Mode_of_Employment_2__c.equals('Full Time') && !a.Mode_of_Employment_2__c.equals('Part Time')	&& !a.Mode_of_Employment_2__c.equals('Casual') 
               && !a.Mode_of_Employment_2__c.equals('Unemployed') && !a.Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') && !a.Mode_of_Employment_2__c.equals('Contract') && !a.Mode_of_Employment_2__c.equals('Centrelink - Newstart only') && !a.Mode_of_Employment_2__c.equals('Self Employed')){
                   this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Employment cannot be send');
                   sr = false;
               }
            
            if(a.Mode_of_Employment_2__c.equals('Self Employed') && a.Application_Type__c.equals('Personal')){
                this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Employment cannot be send');
                sr = false;
            }

            /*
            if(String.isBlank(a.Current_Work_Unit_Number_2__c)){
              this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please enter Unit Number'));
              sr = false;
            }

            if(String.isBlank(a.Current_Work_Street_Number_2__c)){
              this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please enter Street Number'));
              sr = false;
            }

            if(String.isBlank(a.Current_Work_Street_Type_2__c)){
              this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please select Street Type'));
              sr = false;
            }
            */
            if(String.isBlank(a.Current_Work_State_2__c)){
                this.mgr.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please select State');
                sr = false;
            }
            
            e = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
                Unit_Number__c, Street_Number__c, Street_Type__c,
                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
                FROM Application_Employment__c 
                WHERE Application__c =: a.Id
                AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c = '2'];
            
            
            for (Application_Employment__c emp: e) {
                /*
                if(String.isBlank(emp.Unit_Number__c)){
                  this.mgr.addErrorMessage('Applicant 2 - Second Job: Please enter Unit Number'));
                  sr = false;
                }
                */
                if(!emp.Employment_Type__c.equals('Full Time') && !emp.Employment_Type__c.equals('Part Time') && !emp.Employment_Type__c.equals('Casual') 
                   && !emp.Employment_Type__c.equals('Unemployed') && !emp.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') && !emp.Employment_Type__c.equals('Contract') && !emp.Employment_Type__c.equals('Centrelink - Newstart only')){
                       this.mgr.addErrorMessage('Applicant 2 - Second Job: Employment cannot be send');
                       sr = false;
                   }
                
                if(FinanceOneRestWS.otherIncomeSecondJob(2, a)){
                    this.mgr.addErrorMessage('Applicant 2: Remove second job in Other Income');
                    sr = false;
                }
            }
            
            if(e.isEmpty() && FinanceOneRestWS.otherIncomeSecondJob(2, a)){
                this.mgr.addErrorMessage('Applicant 2: Please add details of second job and remove second job in Other Income');
                sr = false;
            }			
            
            if (a.Previous_Work_Country_2__c != null && 
                (String.isNotBlank(a.Start_Date_2__c)
                 || String.isNotBlank(a.Finish_Date_2__c)
                 || String.isNotBlank(a.Previous_Work_Address_2__c)
                 || String.isNotBlank(a.Previous_Mode_of_Employment_2__c))) {
                     /*
                    if(String.isBlank(a.Previous_Work_Unit_Number_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Unit Number');
                      sr = false;
                    }

                    if(String.isBlank(a.Previous_Work_Street_Number_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Street Number');
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Previous_Work_Address_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please enter Work Address');
                         sr = false;
                     }
                     /*
                    if(String.isBlank(a.Previous_Work_Street_Type_2__c)){
                      this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years) : Please select Street Type');
                      sr = false;
                    }
                    */
                     if(String.isBlank(a.Start_Date_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Start Date');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Start_Date_2__c)){
                             this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in Start Date (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Finish_Date_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Finish Date');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Finish_Date_2__c)){
                             this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in	Finish Date (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Previous_Mode_of_Employment_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please select Employment Type');
                         sr = false;
                     }else{
                         if(!a.Previous_Mode_of_Employment_2__c.equals('Full Time') && !a.Previous_Mode_of_Employment_2__c.equals('Part Time') && !a.Previous_Mode_of_Employment_2__c.equals('Casual') 
                            && !a.Previous_Mode_of_Employment_2__c.equals('Unemployed') && !a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') && !a.Previous_Mode_of_Employment_2__c.equals('Contract') && !a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Newstart only')){
                                this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Employment cannot be send');
                                sr = false;
                            }					 
                     }
                     
                     if(String.isBlank(a.Previous_Work_Country_2__c)){
                         this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please select Country');
                         sr = false;
                     }
                     
                     if('AUS'.equals(a.Previous_Work_State_2__c)){
                         if(String.isBlank(a.Previous_Work_State_2__c)){
                             this.mgr.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter State');
                             sr = false;
                         }
                     }
                 }			
            
            lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c = '2'];
            
            previousEmployment = 2;
            for (Application_Employment__c emp: lst) {
                
                if(emp.Finish_Date__c == null){
                    this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Finish Date');
                    sr = false;
                    
                }
                
                if(emp.Start_Date__c == null){
                    this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Start Date');
                    sr = false;
                    
                }
                /*
                if(String.isBlank(emp.Unit_Number__c)){
                  this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Unit Number');
                  sr = false;
                }

                if(String.isBlank(emp.Street_Number__c)){
                  this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Street Number');
                  sr = false;
                }

                if(String.isBlank(emp.Street_Type__c)){
                  this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please select Street Type');
                  sr = false;
                }
                */
                if(String.isBlank(emp.Work_Address__c)){
                    this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Work Address');
                    sr = false;
                }
                
                if(String.isBlank(emp.Employment_Type__c)){
                    this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please select Employment Type');
                    sr = false;
                }else{
                    if(!emp.Employment_Type__c.equals('Full Time') && !emp.Employment_Type__c.equals('Part Time') && !emp.Employment_Type__c.equals('Casual') 
                       && !emp.Employment_Type__c.equals('Unemployed') && !emp.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') && !emp.Employment_Type__c.equals('Contract') && !emp.Employment_Type__c.equals('Centrelink - Newstart only')){
                           this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Employment cannot be send');
                           sr = false;
                       }
                }
                
                if('AUS'.equals(emp.Country__c)){
                    if(String.isBlank(emp.State__c)){
                        this.mgr.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Work Address');
                        sr = false;
                    }
                }
                
                previousEmployment++;
            }
        }
        
        return sr;
    }
    
    public static Integer getFinanceOneType(Application__c app) {
      Integer r = 0;
      if (app != null) {
        if('Personal'.equals(app.Application_Type__c)) {
          r = 1;
        } else if ('Business'.equals(app.Application_Type__c)) {
          if(String.isNotBlank(app.Trust_Name__c)){
            r = (app.No_of_Directors__c == 0) ? 5 : 6;
          } else if ('Individual or Sole Trader'.equals(app.Business_Structure__c)) {
            r = 3;
          } else if ('Partnership'.equals(app.Business_Structure__c)){
            r = 4;
          } else if ('Company'.equals(app.Business_Structure__c)) {
            r = 2;
          }  
        }
      }
      return r;
    }

    public static LenderAPIResponse__c application (String oppId, String apiUser) {
      return application(oppId, null, apiUser);
    }
    
    public static LenderAPIResponse__c application (String oppId, Integer financeOneAppType, String apiUser) {
      FinanceOneAPIManager apiMgr = submitApplication(oppId, financeOneAppType, apiUser);
      return apiMgr == null? null : apiMgr.lenderRes;
    }

    public static FinanceOneAPIManager submitApplication (String oppId, Integer financeOneAppType, String apiUser) {
        Custom_Opportunity__c o = [SELECT Application__c, Application_AssetDetail__c, ApplicationServicing__c, Name FROM Custom_Opportunity__c WHERE Id =: oppId];
        Application__c a = [SELECT Length_of_Term__c, Title_1__c, First_Name__c,
                            Last_Name__c, Date_of_Birth_1__c, toLabel(Gender_1__c), Current_Residential_Status_1__c, Marital_Status_1__c,
                            Street_Address__c, Suburb__c, State__c, Postcode__c, Drivers_License_1__c, Driver_Licence_State_Issue_1__c,
                            Expiry_Date_1__c, Type_of_Licence_1__c, Current_Occupation_1__c, Current_Employer_Name_1__c, Basic_Living_Expenses_Per_Month__c,
                            Mobile_Number__c, Street_Number__c, toLabel(Street_Type__c), Landlord_Name_1__c, Landlord_Phone_1__c,
                            Current_Employer_Phone_1__c, Current_Work_Street_Number_1__c, Current_Work_Address_1__c, Current_Work_Street_Type_1__c,
                            Current_Work_Suburb_1__c, Current_Work_Postcode_1__c, Net_Income_1__c, Payment_Frequency_1__c,
                            Childcare_Child_Maintenance_Per_Month__c, Mobile_Phone_Internet_Pay_TV_per_Month__c, Insurance_Expenses_per_Month__c,
                            Travel_Transport_Expenses_per_Month__c, Other_Expenses_per_Month__c, Income_Type_Expenses__c, No_of_People__c,
                            Previous_Street_Number_1__c, Previous_Street_Address_1__c, toLabel(Previous_Street_Type_1__c), Previous_Suburb_1__c,
                            Previous_Postcode_1__c, Title_2__c, First_Name_2__c, Last_Name_2__c, Date_of_Birth_2__c, toLabel(Gender_2__c), Mobile_Number_2__c,
                            Previous_Street_Number_2__c, Previous_Street_Address_2__c, toLabel(Previous_Street_Type_2__c), Previous_Suburb_2__c,
                            Previous_Postcode_2__c, Street_Number_2__c, Street_Address_2__c, toLabel(Street_Type_2__c), Suburb_2__c, State_2__c, Postcode_2__c,
                            Drivers_License_2__c, Current_Occupation_2__c, Current_Employer_Name_2__c, Current_Employer_Phone_2__c, Current_Work_Street_Number_2__c,
                            Current_Work_Address_2__c, Current_Work_Street_Type_2__c, Current_Work_Suburb_2__c, Current_Work_Postcode_2__c, Net_Income_2__c,
                            Date_Moved_in_1__c, Date_From_1__c, Date_Started_1__c, Date_Moved_in_2__c, Date_From_2__c, Expiry_Date_2__c, Date_Started_2__c,
                            Marital_Status_2__c, Previous_State_1__c, Current_Work_State_1__c, Landlord_Name_2__c, Landlord_Phone_2__c, Driver_Licence_State_Issue_2__c,
                            Type_of_Licence_2__c, Current_Work_State_2__c, Type_of_Asset__c, Previous_Residence_Status_1__c, Current_Residential_Status_2__c,
                            Current_Residence_Status_1__c, Previous_Residence_Status_2__c, Current_Residence_Status_2__c, Mode_of_Employment_1__c, Mode_of_Employment_2__c,
                            Previous_State_2__c, Date_From_1b__c, Date_From_1c__c, Date_From_1d__c, Date_From_1e__c, Previous_Street_Number_1b__c, Previous_Street_Address_1b__c,
                            toLabel(Previous_Street_Type_1b__c), Previous_Suburb_1b__c, Previous_State_1b__c, Previous_Postcode_1b__c, Previous_Residence_Status_1b__c,
                            Previous_Street_Number_1c__c, Previous_Street_Address_1c__c, toLabel(Previous_Street_Type_1c__c), Previous_Suburb_1c__c, Previous_State_1c__c,
                            Previous_Postcode_1c__c, Previous_Residence_Status_1C__c, Previous_Street_Number_1d__c, Previous_Street_Address_1d__c, toLabel(Previous_Street_Type_1d__c),
                            Previous_Suburb_1d__c, Previous_State_1d__c, Previous_Postcode_1d__c, Previous_Residence_Status_1d__c, Previous_Street_Number_1e__c,
                            Previous_Street_Address_1e__c, toLabel(Previous_Street_Type_1e__c), Previous_Suburb_1e__c, Previous_State_1e__c, Previous_Postcode_1e__c,
                            Previous_Residence_Status_1e__c, Date_From_2b__c, Date_From_2c__c, Date_From_2d__c, Date_From_2e__c, Start_Date_1__c, Finish_Date_1__c,
                            Previous_Mode_of_Employment_1__c, Previous_Occupation_1__c, Previous_Employer_Name_1__c, Previous_Reference_Name_1__c, Previous_Employer_Phone_1__c,
                            Previous_Work_Street_Number_1__c, Previous_Work_Address_1__c, Previous_Work_Street_Type_1__c, Previous_Work_Suburb_1__c, Previous_Work_State_1__c,
                            Previous_Work_Postcode_1__c, Payment_Frequency_2__c, Business_Structure__c, Trading_Name__c, Business_ABN__c, Trading_Address__c,
                            Previous_Street_Number_2b__c, Previous_Street_Address_2b__c, toLabel(Previous_Street_Type_2b__c), Previous_Suburb_2b__c, Previous_State_2b__c,
                            Previous_Postcode_2b__c, Previous_Residence_Status_2b__c, Previous_Street_Number_2c__c, Previous_Street_Address_2c__c, toLabel(Previous_Street_Type_2c__c),
                            Previous_Suburb_2c__c, Previous_State_2c__c, Previous_Postcode_2c__c, Previous_Residence_Status_2c__c, Previous_Street_Number_2d__c,
                            Previous_Street_Address_2d__c, toLabel(Previous_Street_Type_2d__c), Previous_Suburb_2d__c, Previous_State_2d__c, Previous_Postcode_2d__c,
                            Previous_Residence_Status_2d__c, Previous_Street_Number_2e__c, Previous_Street_Address_2e__c, toLabel(Previous_Street_Type_2e__c), Previous_Suburb_2e__c,
                            Previous_State_2e__c, Previous_Postcode_2e__c, Previous_Residence_Status_2e__c, Start_Date_2__c, Finish_Date_2__c, Previous_Mode_of_Employment_2__c,
                            Previous_Occupation_2__c, Previous_Employer_Name_2__c, Previous_Reference_Name_2__c, Previous_Employer_Phone_2__c, Previous_Work_Street_Number_2__c,
                            Previous_Work_Address_2__c, Previous_Work_Street_Type_2__c, Previous_Work_Suburb_2__c, Previous_Work_State_2__c, Previous_Work_Postcode_2__c, Do_you_have_drivers_licence_1__c,
                            Do_you_expect_any_change_to_your_financi__c, No_of_Dependants_1__c, Email_Address__c, Email_Address_2__c, Rent_per_month_1__c, Residential_Payment_Frequency_1__c,
                            Rent_per_month_2__c, Do_you_have_drivers_licence_2__c, Residential_Payment_Frequency_2__c, Purchase_Price__c, Previous_Country_1__c, Previous_Country_1b__c,
                            Previous_Country_1c__c, Previous_Country_1d__c, Previous_Country_1e__c, Previous_Overseas_City_1__c, Previous_Overseas_City_1b__c, Previous_Overseas_City_1c__c,
                            Previous_Overseas_City_1d__c, Previous_Overseas_City_1e__c, Applicant_2_living_in_the_same_address__c, Previous_Overseas_City_2__c, Previous_Overseas_City_2b__c,
                            Previous_Overseas_City_2c__c, Previous_Overseas_City_2d__c, Previous_Overseas_City_2e__c, Previous_Country_2__c, Previous_Country_2b__c, Previous_Country_2c__c,
                            Previous_Country_2d__c, Previous_Country_2e__c, Previous_Work_Overseas_City_1__c, Previous_Work_Overseas_State_1__c, Current_Work_Unit_Number_1__c,
                            Previous_Work_Address_2nd_1__c, Current_Work_Unit_Number_2__c, Previous_Work_Unit_Number_2__c, Reference_Name_1__c, Nature_of_Business__c, Reference_Name_2__c,
                            Previous_Work_Country_2__c, Previous_Work_Address_2nd_2__c, Previous_Work_Overseas_City_2__c, Previous_Work_Country_1__c, Unit_Number__c, Previous_Street_Address_2nd_1__c,
                            Previous_Unit_Number_2__c, Previous_Street_Address_2nd_2b__c, Previous_Unit_Number_2c__c, Previous_Unit_Number_2d__c, No_of_Dependants_2__c, Previous_Unit_Number_1c__c,
                            Previous_Work_Unit_Number_1__c, Unit_Number_2__c, Previous_Unit_Number_2e__c, No_of_Directors__c, Business_ACN__c, Previous_Unit_Number_1__c, Previous_Unit_Number_1b__c,
                            Previous_Unit_Number_1d__c, Previous_Unit_Number_1e__c, Previous_Street_Address_2nd_2__c, Previous_Unit_Number_2b__c, Previous_Street_Address_2nd_1b__c,
                            Previous_Street_Address_2nd_1c__c, Previous_Street_Address_2nd_1d__c, Previous_Street_Address_2nd_1e__c, Previous_Street_Address_2nd_2c__c, Previous_Street_Address_2nd_2d__c,
                            Previous_Street_Address_2nd_2e__c, Application_Type__c, Board_per_Month_1__c, Board_per_Month_2__c, Trust_Name__c
                            FROM Application__c WHERE Id =: o.Application__c]; 
        List<Application_Asset_Detail__c> listAsset = [
          SELECT Make__c, Model__c, Year__c, Actual_KM__c, VIN__c, Variant__c, Price__c, Variant_Desc__c, Series__c
          FROM Application_Asset_Detail__c WHERE Id =: o.Application_AssetDetail__c
        ];
        Application_Asset_Detail__c asset;
        Glass_Variant__c g;
        Integer application = financeOneAppType > 0 ? financeOneAppType : getFinanceOneType(a);
        if(!listAsset.isEmpty()){
          asset = listAsset.get(0);
          List<Glass_Variant__c> listG = [
            SELECT NVIC__c, Style__c
            FROM Glass_Variant__c WHERE Code__c =: asset.Variant__c
          ];
          if(!listG.isEmpty()){
            g = listG.get(0);
          }
        }
        
        List<Application_Quoting__c> r = [SELECT Loan_Product__c, Loan_Facility_Type__c, Repayment_Monthly__c, DOF__c, Payout_On__c,
                                          Deposit__c, Trade_In__c, Goods_sub_type__c, Goods_type__c, Vehicle_Price__c, Term__c
                                          FROM Application_Quoting__c WHERE Application__c =: o.Application__c ORDER BY LastModifiedDate DESC];
        Application_Quoting__c quoting;
        if(!r.isEmpty()){
            quoting = r.get(0);
        }
        List<Application_Extra_Data__c> listE = [SELECT Category__c, Data__c
                                                 FROM Application_Extra_Data__c WHERE Application__c =: o.Application__c AND Category__c = 'Lender'];
        Application_Extra_Data__c e;
        if(!listE.isEmpty()){
            e = listE.get(0);
        }
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        LenderAPIResponse__c lenderRes = null;
        if(application == 1){
          f.mgr.lenderRes = f.individualApplication(o, a, asset, g, quoting, e, apiUser);   
        }
        
        if(application == 2){
          System.debug(application);
          f.mgr.lenderRes = f.companyApplication(o, a, asset, g, quoting, e, apiUser);  
        }
        
        if(application == 3){
          f.mgr.lenderRes = f.soleTraderApplication(o, a, asset, g, quoting, e, apiUser);  
        }
        
        if(application == 4){
          f.mgr.lenderRes = f.partnershipApplication(o, a, asset, g, quoting, e, apiUser);  
        }
        
        if(application == 5){
          f.mgr.lenderRes = f.trustWithIndividualTrusteeApplication(o, a, asset, g, quoting, e, apiUser);  
        }
        
        if(application == 6){
          f.mgr.lenderRes = f.trustWithCompanyTrusteeApplication(o, a, asset, g, quoting, e, apiUser);  
        }
        return f.mgr;
    }
    
    public LenderAPIResponse__c individualApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;

        FinanceOneDTOs.IndividualApplication dto = new FinanceOneDTOs.IndividualApplication();
        
        
        if(submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c, Lender__c, Quoting_Source__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            Decimal livingExpenses = 0;
            if(String.isNotBlank(a.Basic_Living_Expenses_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Basic_Living_Expenses_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Childcare_Child_Maintenance_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Childcare_Child_Maintenance_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Mobile_Phone_Internet_Pay_TV_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
            }
            if(String.isNotBlank(a.Insurance_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Insurance_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Travel_Transport_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Travel_Transport_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Other_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Other_Expenses_per_Month__c, false);
            }
            
            
            dto.householdExpenses = new FinanceOneDTOs.HouseholdExpenses();
            dto.householdExpenses.livingExpenses = livingExpenses;
            dto.householdExpenses.minorDependants = a.No_of_Dependants_1__c.intValue();
            dto.householdExpenses.adultDependants = 0;
            dto.householdExpenses.expensesIncludeDependants = true;
            dto.householdExpenses.sharesLivingExpenses = false;
            
            if(a.No_of_People__c == 2){
                dto.householdExpenses.minorDependants = a.No_of_Dependants_1__c.intValue()+a.No_of_Dependants_2__c.intValue();   
            }
            
            dto.individuals = new FinanceOneDTOs.Individual[a.No_of_People__c.intValue()];
            dto.individuals[0] = new FinanceOneDTOs.Individual(); 
            dto.individuals[0].personal = new FinanceOneDTOs.Personal();
            dto.individuals[0].personal.isExistingClient = false;
            dto.individuals[0].personal.title = a.Title_1__c.toLowercase();
            dto.individuals[0].personal.firstName = a.First_Name__c;
            dto.individuals[0].personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.individuals[0].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.individuals[0].personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.individuals[0].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.individuals[0].personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.individuals[0].personal.visaType = 'not_listed';  
            }
            dto.individuals[0].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.individuals[0].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.individuals[0].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.individuals[0].personal.contactMethods[0].type = 'mobile_phone';
            dto.individuals[0].personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.individuals[0].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.individuals[0].personal.contactMethods[1].type = 'email_address';
            dto.individuals[0].personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.individuals[0].residential = FinanceOneResidential.residentialApp1(a, o);
            
            dto.individuals[0].licence = new FinanceOneDTOs.Licence();
            if(a.Do_you_have_drivers_licence_1__c.equals('Yes')){
                dto.individuals[0].licence.isLicenceProvided = true;
                //if(a.Type_of_Asset__c.equals('Car') || a.Type_of_Asset__c.equals('Truck')){
                dto.individuals[0].licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[1];
                dto.individuals[0].licence.vehicleLicences[0] = new FinanceOneDTOs.VehicleLicence(); 
                dto.individuals[0].licence.vehicleLicences[0].licenceNumber = a.Drivers_License_1__c;
                dto.individuals[0].licence.vehicleLicences[0].state = a.Driver_Licence_State_Issue_1__c.toLowercase();
                String[] expirationDate = a.Expiry_Date_1__c.split('/');
                dto.individuals[0].licence.vehicleLicences[0].expirationDate = expirationDate[2]+'-'+expirationDate[1]+'-'+expirationDate[0];
                dto.individuals[0].licence.vehicleLicences[0].licenceType = FinanceOneUtils.getVehicleLicenceType(a.Type_of_Licence_1__c);
                dto.individuals[0].licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
                //}
            }else{
                dto.individuals[0].licence.isLicenceProvided = false;
                dto.individuals[0].licence.reasonForNotProviding = '     ';
                dto.individuals[0].licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[0];
                dto.individuals[0].licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
            }
            dto.individuals[0].licence.hasSpecialRestrictions = false;
            //dto.individuals[0].licence.specialRestrictionsDetails = 'Customer requires glasses to drive.';
            
            String[] expirationDate;
            
            
            
            dto.individuals[0].employment = FinanceOneEmployment.employmentApp1(1, a);
            System.debug(dto.individuals[0].employment.current);
            System.debug(dto.individuals[0].employment.previous);
            dto.individuals[0].creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.individuals[0].creditHistory.details = 'Average';
            
            dto.individuals[0].incomes = FinanceOneIncome.income(1, a, o);
            
            dto.individuals[0].liabilities = FinanceOneLiability.liability(a);
            
            if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)')){
                dto.individuals[0].expenses = new FinanceOneDTOs.Expense[1];
                dto.individuals[0].expenses[0] = new FinanceOneDTOs.Expense();
                dto.individuals[0].expenses[0].type = 'rent'; 
                
                if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                    dto.individuals[0].expenses[0].value = a.Rent_per_month_1__c/12;
                    dto.individuals[0].expenses[0].frequency = 'monthly';
                }else{
                    dto.individuals[0].expenses[0].value = a.Rent_per_month_1__c;
                    dto.individuals[0].expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                }
            }else if(a.Current_Residence_Status_1__c.equals('Boarding')){
                dto.individuals[0].expenses = new FinanceOneDTOs.Expense[1];
                dto.individuals[0].expenses[0] = new FinanceOneDTOs.Expense();
                dto.individuals[0].expenses[0].type = 'other_expense'; 
                
                if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                    dto.individuals[0].expenses[0].value = a.Board_per_month_1__c/12;
                    dto.individuals[0].expenses[0].frequency = 'monthly';
                }else{
                    dto.individuals[0].expenses[0].value = a.Board_per_month_1__c;
                    dto.individuals[0].expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                }
            }else{
                dto.individuals[0].expenses = new FinanceOneDTOs.Expense[0];  
            }
            
            dto.individuals[0].other = new FinanceOneDTOs.Other();
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.individuals[0].other.circumstancesChanging = true;
                dto.individuals[0].other.changeInformation = '----------';
            }else{
                dto.individuals[0].other.circumstancesChanging = false;   
            }
            
            if(a.No_of_People__c == 2){
                dto.individuals[1] = new FinanceOneDTOs.Individual(); 
                dto.individuals[1].personal = new FinanceOneDTOs.Personal();
                dto.individuals[1].personal.isExistingClient = false;
                dto.individuals[1].personal.title = a.Title_2__c.toLowercase();
                dto.individuals[1].personal.firstName = a.First_Name_2__c;
                dto.individuals[1].personal.lastName = a.Last_Name_2__c;
                dateOfBirth = a.Date_of_Birth_2__c.split('/');
                dto.individuals[1].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
                dto.individuals[1].personal.sex = FinanceOneUtils.sex(a.Gender_2__c);
                dto.individuals[1].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_2__c);
                if('Spouse VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.individuals[1].personal.visaType = 'permanent_partner_visa_migrant_100';  
                }
                if('Working VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.individuals[1].personal.visaType = 'not_listed';  
                }
                dto.individuals[1].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_2__c);
                dto.individuals[1].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
                dto.individuals[1].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
                dto.individuals[1].personal.contactMethods[0].type = 'mobile_phone';
                dto.individuals[1].personal.contactMethods[0].value = a.Mobile_Number_2__c;
                dto.individuals[1].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
                dto.individuals[1].personal.contactMethods[1].type = 'email_address';
                dto.individuals[1].personal.contactMethods[1].value = a.Email_Address_2__c;
                
                dto.individuals[1].residential = FinanceOneResidential.residentialApp2(a, o);
                
                dto.individuals[1].licence = new FinanceOneDTOs.Licence();
                if(a.Do_you_have_drivers_licence_2__c.equals('Yes')){
                    dto.individuals[1].licence.isLicenceProvided = true;
                    //if(a.Type_of_Asset__c.equals('Car') || a.Type_of_Asset__c.equals('Truck')){
                    dto.individuals[1].licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[1];
                    dto.individuals[1].licence.vehicleLicences[0] = new FinanceOneDTOs.VehicleLicence(); 
                    dto.individuals[1].licence.vehicleLicences[0].licenceNumber = a.Drivers_License_2__c;
                    dto.individuals[1].licence.vehicleLicences[0].state = a.Driver_Licence_State_Issue_2__c.toLowercase();
                    expirationDate = a.Expiry_Date_2__c.split('/');
                    dto.individuals[1].licence.vehicleLicences[0].expirationDate = expirationDate[2]+'-'+expirationDate[1]+'-'+expirationDate[0];
                    dto.individuals[1].licence.vehicleLicences[0].licenceType = FinanceOneUtils.getVehicleLicenceType(a.Type_of_Licence_2__c);
                    dto.individuals[1].licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
                    //}
                }else{
                    dto.individuals[1].licence.isLicenceProvided = false;
                    dto.individuals[1].licence.reasonForNotProviding = '     ';
                    dto.individuals[1].licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[0];
                    dto.individuals[1].licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
                }
                dto.individuals[1].licence.hasSpecialRestrictions = false;
                dto.individuals[1].employment = FinanceOneEmployment.employmentApp2(2, a);
                
                dto.individuals[1].creditHistory = new FinanceOneDTOs.CreditHistory();
                dto.individuals[1].creditHistory.details = 'Average';
                
                dto.individuals[1].incomes = FinanceOneIncome.income(2, a, o);
                
                dto.individuals[1].liabilities = new FinanceOneDTOs.Liabilities();
                dto.individuals[1].liabilities.general = new FinanceOneDTOs.GeneralLiability[0];
                dto.individuals[1].liabilities.creditFacilities = new FinanceOneDTOs.CreditFacilityLiability[0];
                if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
                    if(a.Current_Residence_Status_2__c.equals('Renting(Agent)') || a.Current_Residence_Status_2__c.equals('Renting(Private)')){
                        dto.individuals[1].expenses = new FinanceOneDTOs.Expense[1];
                        dto.individuals[1].expenses[0] = new FinanceOneDTOs.Expense();
                        dto.individuals[1].expenses[0].type = 'rent'; 
                        Decimal rent;
                        if(a.Rent_per_month_2__c == null){
                            rent = 1;
                        }else{
                            rent = a.Rent_per_month_2__c;
                        }
                        if(String.isBlank(a.Residential_Payment_Frequency_2__c)){
                            
                            if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                                dto.individuals[1].expenses[0].value = rent/12;
                                dto.individuals[1].expenses[0].frequency = 'monthly';
                            }else{
                                dto.individuals[1].expenses[0].value = rent;
                                dto.individuals[1].expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                            }
                        }else{
                            
                            if('Yearly'.equals(a.Residential_Payment_Frequency_2__c)){
                                dto.individuals[1].expenses[0].value = rent/12;
                                dto.individuals[1].expenses[0].frequency = 'monthly';
                            }else{
                                dto.individuals[1].expenses[0].value = rent;
                                dto.individuals[1].expenses[0].frequency = a.Residential_Payment_Frequency_2__c.toLowercase();
                            }
                        }
                        
                    }else if(a.Current_Residence_Status_2__c.equals('Boarding')){
                        dto.individuals[1].expenses = new FinanceOneDTOs.Expense[1];
                        dto.individuals[1].expenses[0] = new FinanceOneDTOs.Expense();
                        dto.individuals[1].expenses[0].type = 'rent'; 
                        Decimal board;
                        if(a.Board_per_month_2__c == null){
                            board = 1;
                        }else{
                            board = a.Board_per_month_2__c;
                        }
                        if(String.isBlank(a.Residential_Payment_Frequency_2__c)){
                            
                            if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                                dto.individuals[1].expenses[0].value = board/12;
                                dto.individuals[1].expenses[0].frequency = 'monthly';
                            }else{
                                dto.individuals[1].expenses[0].value = board;
                                dto.individuals[1].expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                            }
                        }else{
                            
                            if('Yearly'.equals(a.Residential_Payment_Frequency_2__c)){
                                dto.individuals[1].expenses[0].value = board/12;
                                dto.individuals[1].expenses[0].frequency = 'monthly';
                            }else{
                                dto.individuals[1].expenses[0].value = board;
                                dto.individuals[1].expenses[0].frequency = a.Residential_Payment_Frequency_2__c.toLowercase();
                            }
                        }
                    }else{
                        dto.individuals[1].expenses = new FinanceOneDTOs.Expense[0];  
                    }
                }else{
                    dto.individuals[1].expenses = new FinanceOneDTOs.Expense[0];
                }
                //dto.individuals[1].other = new FinanceOneDTOs.Other();
                //dto.individuals[1].other.circumstancesChanging = true;
                //dto.individuals[1].other.changeInformation = 'Example expected change in circumstances text.';
                dto.individuals[1].other = new FinanceOneDTOs.Other();
                if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                    dto.individuals[1].other.circumstancesChanging = true;
                    dto.individuals[1].other.changeInformation = '----------';
                }else{
                    dto.individuals[1].other.circumstancesChanging = false;   
                }
                
            }
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServiceIndividualApplication(dto, o, UUID, apiUser, this.mgr); 
            }
        }
        
        return lenderRes;
    }
    
    public LenderAPIResponse__c companyApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;
        FinanceOneDTOs.CompanyApplication dto = new FinanceOneDTOs.CompanyApplication();
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        if(f.submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            //dto.productTypeId = 'COM.S.BRO';
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            dto.directors = new FinanceOneDTOs.Guarantor[a.No_of_People__c.intValue()];
            dto.directors[0] = new FinanceOneDTOs.Guarantor(); 
            dto.directors[0].personal = new FinanceOneDTOs.Personal();
            dto.directors[0].personal.isExistingClient = false;
            dto.directors[0].personal.title = a.Title_1__c.toLowercase();
            dto.directors[0].personal.firstName = a.First_Name__c;
            dto.directors[0].personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.directors[0].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.directors[0].personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.directors[0].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.directors[0].personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.directors[0].personal.visaType = 'not_listed';  
            }
            dto.directors[0].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.directors[0].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.directors[0].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.directors[0].personal.contactMethods[0].type = 'mobile_phone';
            dto.directors[0].personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.directors[0].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.directors[0].personal.contactMethods[1].type = 'email_address';
            dto.directors[0].personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.directors[0].residential = FinanceOneResidential.residentialApp1(a, o);
            
            String[] expirationDate;
            
            dto.directors[0].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
            dto.directors[0].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
            dto.directors[0].employment.guarantorEmployment.duration = 0;
            dto.directors[0].employment.standardEmployments = FinanceOneEmployment.employmentApp1(1, a);
            
            dto.directors[0].creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.directors[0].creditHistory.details = 'Average';
            
            dto.directors[0].other = new FinanceOneDTOs.Other();
            
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.directors[0].other.circumstancesChanging = true;
                dto.directors[0].other.changeInformation = '----------';
            }else{
                dto.directors[0].other.circumstancesChanging = false;   
            }
            
            if(a.No_of_People__c == 2){
                dto.directors[1] = new FinanceOneDTOs.Guarantor(); 
                dto.directors[1].personal = new FinanceOneDTOs.Personal();
                dto.directors[1].personal.isExistingClient = false;
                dto.directors[1].personal.title = a.Title_2__c.toLowercase();
                dto.directors[1].personal.firstName = a.First_Name_2__c;
                dto.directors[1].personal.lastName = a.Last_Name_2__c;
                dateOfBirth = a.Date_of_Birth_2__c.split('/');
                dto.directors[1].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
                dto.directors[1].personal.sex = FinanceOneUtils.sex(a.Gender_2__c);
                dto.directors[1].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_2__c);
                if('Spouse VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.directors[1].personal.visaType = 'permanent_partner_visa_migrant_100';  
                }
                if('Working VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.directors[1].personal.visaType = 'not_listed';  
                }
                dto.directors[1].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_2__c);
                dto.directors[1].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
                dto.directors[1].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
                dto.directors[1].personal.contactMethods[0].type = 'mobile_phone';
                dto.directors[1].personal.contactMethods[0].value = a.Mobile_Number_2__c;
                dto.directors[1].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
                dto.directors[1].personal.contactMethods[1].type = 'email_address';
                dto.directors[1].personal.contactMethods[1].value = a.Email_Address_2__c;
                
                dto.directors[1].residential = FinanceOneResidential.residentialApp2(a, o);
                
                dto.directors[1].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
                dto.directors[1].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
                dto.directors[1].employment.guarantorEmployment.duration = 0;
                dto.directors[1].employment.standardEmployments = FinanceOneEmployment.employmentApp2(2, a);
                
                dto.directors[1].creditHistory = new FinanceOneDTOs.CreditHistory();
                dto.directors[1].creditHistory.details = 'Average';
                
                //dto.individuals[1].other = new FinanceOneDTOs.Other();
                //dto.individuals[1].other.circumstancesChanging = true;
                //dto.individuals[1].other.changeInformation = 'Example expected change in circumstances text.';
                dto.directors[1].other = new FinanceOneDTOs.Other();
                if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                    dto.directors[1].other.circumstancesChanging = true;
                    dto.directors[1].other.changeInformation = '----------';
                }else{
                    dto.directors[1].other.circumstancesChanging = false;   
                }
                
            }
            dto.company = new FinanceOneDTOs.CommercialEntity();
            dto.company.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.company.creditHistory.details = 'Average';
            
            dto.company.incomes = new FinanceOneDTOs.Income[0];
            
            dto.company.liabilities = FinanceOneLiability.liability(a);
            
            dto.company.expenses = new FinanceOneDTOs.Expense[0];
            
            Application_Employment__c entity = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                Work_Address__c, Phone__c,
                                                Unit_Number__c, Street_Number__c, Street_Type__c,
                                                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            
            dto.company.entity = new FinanceOneDTOs.Entity();
            dto.company.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.company.entity.tradingName = a.Trading_Name__c;
            dto.company.entity.abn = a.Business_ABN__c;
            dto.company.entity.acn = a.Business_ACN__c;
            dto.company.entity.address = new FinanceOneDTOs.Address();
            dto.company.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.company.entity.address.suburb = entity.Suburb__c;
            dto.company.entity.address.state = entity.State__c.toLowercase();
            dto.company.entity.address.postcode = entity.Postcode__c;
            dto.company.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServiceCompanyApplication(dto, o, UUID, apiUser, this.mgr);
            }
        }

        return lenderRes;
    }
    
    public LenderAPIResponse__c soleTraderApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;
        FinanceOneDTOs.SoleTraderApplication dto = new FinanceOneDTOs.SoleTraderApplication();
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        if(f.submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            
            
            //dto.productTypeId = productTypeId.data[1].id;
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            //dto.productTypeId = 'COM.S.BRO';
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            Decimal livingExpenses = 0;
            if(String.isNotBlank(a.Basic_Living_Expenses_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Basic_Living_Expenses_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Childcare_Child_Maintenance_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Childcare_Child_Maintenance_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Mobile_Phone_Internet_Pay_TV_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
            }
            if(String.isNotBlank(a.Insurance_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Insurance_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Travel_Transport_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Travel_Transport_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Other_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Other_Expenses_per_Month__c, false);
            }
            
            dto.householdExpenses = new FinanceOneDTOs.HouseholdExpenses();
            dto.householdExpenses.livingExpenses = livingExpenses;
            dto.householdExpenses.minorDependants = a.No_of_Dependants_1__c.intValue();
            dto.householdExpenses.adultDependants = 0;
            dto.householdExpenses.expensesIncludeDependants = true;
            dto.householdExpenses.sharesLivingExpenses = false;
            
            if(a.No_of_People__c == 2){
                dto.householdExpenses.minorDependants = a.No_of_Dependants_1__c.intValue()+a.No_of_Dependants_2__c.intValue();   
            }
            
            dto.soleTrader = new FinanceOneDTOs.SoleTrader(); 
            dto.soleTrader.personal = new FinanceOneDTOs.Personal();
            dto.soleTrader.personal.isExistingClient = false;
            dto.soleTrader.personal.title = a.Title_1__c.toLowercase();
            dto.soleTrader.personal.firstName = a.First_Name__c;
            dto.soleTrader.personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.soleTrader.personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.soleTrader.personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.soleTrader.personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.soleTrader.personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.soleTrader.personal.visaType = 'not_listed';  
            }
            dto.soleTrader.personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.soleTrader.personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.soleTrader.personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.soleTrader.personal.contactMethods[0].type = 'mobile_phone';
            dto.soleTrader.personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.soleTrader.personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.soleTrader.personal.contactMethods[1].type = 'email_address';
            dto.soleTrader.personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.soleTrader.licence = new FinanceOneDTOs.Licence();
            if(a.Do_you_have_drivers_licence_1__c.equals('Yes')){
                dto.soleTrader.licence.isLicenceProvided = true;
                //if(a.Type_of_Asset__c.equals('Car') || a.Type_of_Asset__c.equals('Truck')){
                dto.soleTrader.licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[1];
                dto.soleTrader.licence.vehicleLicences[0] = new FinanceOneDTOs.VehicleLicence(); 
                dto.soleTrader.licence.vehicleLicences[0].licenceNumber = a.Drivers_License_1__c;
                dto.soleTrader.licence.vehicleLicences[0].state = a.Driver_Licence_State_Issue_1__c.toLowercase();
                String[] expirationDate = a.Expiry_Date_1__c.split('/');
                dto.soleTrader.licence.vehicleLicences[0].expirationDate = expirationDate[2]+'-'+expirationDate[1]+'-'+expirationDate[0];
                dto.soleTrader.licence.vehicleLicences[0].licenceType = FinanceOneUtils.getVehicleLicenceType(a.Type_of_Licence_1__c);
                dto.soleTrader.licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
                //}
            }else{
                dto.soleTrader.licence.isLicenceProvided = false;
                dto.soleTrader.licence.reasonForNotProviding = '     ';
                dto.soleTrader.licence.vehicleLicences = new FinanceOneDTOs.VehicleLicence[0];
                dto.soleTrader.licence.marineLicences = new FinanceOneDTOs.MarineLicence[0];
            }
            dto.soleTrader.licence.hasSpecialRestrictions = false;
            
            dto.soleTrader.residential = FinanceOneResidential.residentialApp1(a, o);
            
            String[] expirationDate;
            
            dto.soleTrader.employment = new FinanceOneDTOs.SoleTraderEmployment();
            dto.soleTrader.employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
            dto.soleTrader.employment.guarantorEmployment.duration = 0;
            dto.soleTrader.employment.standardEmployments = FinanceOneEmployment.employmentApp1(1, a);
            dto.soleTrader.employment.receivesPaygIncome = false;    
            
            dto.soleTrader.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.soleTrader.creditHistory.details = 'Average';
            
            dto.soleTrader.incomes = FinanceOneIncome.income(1, a, o);
            
            dto.soleTrader.liabilities = FinanceOneLiability.liability(a);
            
            if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)')){
                dto.soleTrader.expenses = new FinanceOneDTOs.Expense[1];
                dto.soleTrader.expenses[0] = new FinanceOneDTOs.Expense();
                dto.soleTrader.expenses[0].type = 'rent'; 
                
                if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                    dto.soleTrader.expenses[0].value = a.Rent_per_month_1__c/12;
                    dto.soleTrader.expenses[0].frequency = 'monthly';
                }else{
                    dto.soleTrader.expenses[0].value = a.Rent_per_month_1__c;
                    dto.soleTrader.expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                }
            }else if(a.Current_Residence_Status_1__c.equals('Boarding')){
                dto.soleTrader.expenses = new FinanceOneDTOs.Expense[1];
                dto.soleTrader.expenses[0] = new FinanceOneDTOs.Expense();
                dto.soleTrader.expenses[0].type = 'other_expense'; 
                
                if('Yearly'.equals(a.Residential_Payment_Frequency_1__c)){
                    dto.soleTrader.expenses[0].value = a.Board_per_month_1__c/12;
                    dto.soleTrader.expenses[0].frequency = 'monthly';
                }else{
                    dto.soleTrader.expenses[0].value = a.Board_per_month_1__c;
                    dto.soleTrader.expenses[0].frequency = a.Residential_Payment_Frequency_1__c.toLowercase();
                }
            }else{
                dto.soleTrader.expenses = new FinanceOneDTOs.Expense[0];  
            }
            
            dto.soleTrader.other = new FinanceOneDTOs.Other();
            
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.soleTrader.other.circumstancesChanging = true;
                dto.soleTrader.other.changeInformation = '----------';
            }else{
                dto.soleTrader.other.circumstancesChanging = false;   
            }
            
            
            Application_Employment__c entity = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                Work_Address__c, Phone__c,
                                                Unit_Number__c, Street_Number__c, Street_Type__c,
                                                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            
            dto.soleTrader.entity = new FinanceOneDTOs.Entity();
            dto.soleTrader.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.soleTrader.entity.tradingName = a.Trading_Name__c;
            dto.soleTrader.entity.abn = a.Business_ABN__c;
            dto.soleTrader.entity.acn = a.Business_ACN__c;
            dto.soleTrader.entity.address = new FinanceOneDTOs.Address();
            dto.soleTrader.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.soleTrader.entity.address.suburb = entity.Suburb__c;
            dto.soleTrader.entity.address.state = entity.State__c.toLowercase();
            dto.soleTrader.entity.address.postcode = entity.Postcode__c;
            dto.soleTrader.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServiceSoleTraderApplication(dto, o, UUID, apiUser, this.mgr);
            }
        }
        return lenderRes;
    }
    
    public LenderAPIResponse__c partnershipApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;
        FinanceOneDTOs.PartnershipApplication dto = new FinanceOneDTOs.PartnershipApplication();
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        if(f.submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            //dto.productTypeId = 'COM.S.BRO';
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            Decimal livingExpenses = 0;
            if(String.isNotBlank(a.Basic_Living_Expenses_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Basic_Living_Expenses_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Childcare_Child_Maintenance_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Childcare_Child_Maintenance_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Mobile_Phone_Internet_Pay_TV_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
            }
            if(String.isNotBlank(a.Insurance_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Insurance_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Travel_Transport_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Travel_Transport_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Other_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Other_Expenses_per_Month__c, false);
            }
            
            dto.partners = new FinanceOneDTOs.Guarantor[a.No_of_People__c.intValue()];
            dto.partners[0] = new FinanceOneDTOs.Guarantor(); 
            dto.partners[0].personal = new FinanceOneDTOs.Personal();
            dto.partners[0].personal.isExistingClient = false;
            dto.partners[0].personal.title = a.Title_1__c.toLowercase();
            dto.partners[0].personal.firstName = a.First_Name__c;
            dto.partners[0].personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.partners[0].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.partners[0].personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.partners[0].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.partners[0].personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.partners[0].personal.visaType = 'not_listed';  
            }
            dto.partners[0].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.partners[0].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.partners[0].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.partners[0].personal.contactMethods[0].type = 'mobile_phone';
            dto.partners[0].personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.partners[0].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.partners[0].personal.contactMethods[1].type = 'email_address';
            dto.partners[0].personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.partners[0].residential = FinanceOneResidential.residentialApp1(a, o);
            
            String[] expirationDate;
            
            dto.partners[0].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
            dto.partners[0].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
            dto.partners[0].employment.guarantorEmployment.duration = 0;
            dto.partners[0].employment.standardEmployments = FinanceOneEmployment.employmentApp1(1, a);
            dto.partners[0].creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.partners[0].creditHistory.details = 'Average';
            
            dto.partners[0].other = new FinanceOneDTOs.Other();
            
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.partners[0].other.circumstancesChanging = true;
                dto.partners[0].other.changeInformation = '----------';
            }else{
                dto.partners[0].other.circumstancesChanging = false;   
            }
            
            if(a.No_of_People__c == 2){
                dto.partners[1] = new FinanceOneDTOs.Guarantor(); 
                dto.partners[1].personal = new FinanceOneDTOs.Personal();
                dto.partners[1].personal.isExistingClient = false;
                dto.partners[1].personal.title = a.Title_2__c.toLowercase();
                dto.partners[1].personal.firstName = a.First_Name_2__c;
                dto.partners[1].personal.lastName = a.Last_Name_2__c;
                dateOfBirth = a.Date_of_Birth_2__c.split('/');
                dto.partners[1].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
                dto.partners[1].personal.sex = FinanceOneUtils.sex(a.Gender_2__c);
                dto.partners[1].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_2__c);
                if('Spouse VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.partners[1].personal.visaType = 'permanent_partner_visa_migrant_100';  
                }
                if('Working VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.partners[1].personal.visaType = 'not_listed';  
                }
                dto.partners[1].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_2__c);
                dto.partners[1].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
                dto.partners[1].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
                dto.partners[1].personal.contactMethods[0].type = 'mobile_phone';
                dto.partners[1].personal.contactMethods[0].value = a.Mobile_Number_2__c;
                dto.partners[1].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
                dto.partners[1].personal.contactMethods[1].type = 'email_address';
                dto.partners[1].personal.contactMethods[1].value = a.Email_Address_2__c;
                
                dto.partners[1].residential = FinanceOneResidential.residentialApp2(a, o);
                
                dto.partners[1].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
                dto.partners[1].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
                dto.partners[1].employment.guarantorEmployment.duration = 0;
                dto.partners[1].employment.standardEmployments = FinanceOneEmployment.employmentApp2(2, a);
                
                dto.partners[1].creditHistory = new FinanceOneDTOs.CreditHistory();
                dto.partners[1].creditHistory.details = 'Average';
                
                //dto.individuals[1].other = new FinanceOneDTOs.Other();
                //dto.individuals[1].other.circumstancesChanging = true;
                //dto.individuals[1].other.changeInformation = 'Example expected change in circumstances text.';
                dto.partners[1].other = new FinanceOneDTOs.Other();
                if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                    dto.partners[1].other.circumstancesChanging = true;
                    dto.partners[1].other.changeInformation = '----------';
                }else{
                    dto.partners[1].other.circumstancesChanging = false;   
                }
                
            }
            
            dto.commercialEntity = new FinanceOneDTOs.CommercialEntity();
            dto.commercialEntity.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.commercialEntity.creditHistory.details = 'Average';
            
            dto.commercialEntity.incomes = new FinanceOneDTOs.Income[0];
            
            dto.commercialEntity.liabilities = FinanceOneLiability.liability(a);
            
            dto.commercialEntity.expenses = new FinanceOneDTOs.Expense[0];
            
            Application_Employment__c entity = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                Work_Address__c, Phone__c,
                                                Unit_Number__c, Street_Number__c, Street_Type__c,
                                                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            
            dto.commercialEntity.entity = new FinanceOneDTOs.Entity();
            dto.commercialEntity.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.commercialEntity.entity.tradingName = a.Trading_Name__c;
            dto.commercialEntity.entity.abn = a.Business_ABN__c;
            dto.commercialEntity.entity.acn = a.Business_ACN__c;
            dto.commercialEntity.entity.address = new FinanceOneDTOs.Address();
            dto.commercialEntity.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.commercialEntity.entity.address.suburb = entity.Suburb__c;
            dto.commercialEntity.entity.address.state = entity.State__c.toLowercase();
            dto.commercialEntity.entity.address.postcode = entity.Postcode__c;
            dto.commercialEntity.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServicePartnershipApplication(dto, o, UUID, apiUser, this.mgr);
            }
        }
        return lenderRes;
    }
    
    public LenderAPIResponse__c trustWithIndividualTrusteeApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;
        FinanceOneDTOs.TrustWithIndividualTrusteeApplication dto = new FinanceOneDTOs.TrustWithIndividualTrusteeApplication();
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        if(f.submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            //dto.productTypeId = 'COM.S.BRO';
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            dto.trustees = new FinanceOneDTOs.TrusteeIndividual[a.No_of_People__c.intValue()];
            dto.trustees[0] = new FinanceOneDTOs.TrusteeIndividual(); 
            dto.trustees[0].personal = new FinanceOneDTOs.Personal();
            dto.trustees[0].personal.isExistingClient = false;
            dto.trustees[0].personal.title = a.Title_1__c.toLowercase();
            dto.trustees[0].personal.firstName = a.First_Name__c;
            dto.trustees[0].personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.trustees[0].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.trustees[0].personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.trustees[0].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.trustees[0].personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.trustees[0].personal.visaType = 'not_listed';  
            }
            dto.trustees[0].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.trustees[0].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.trustees[0].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.trustees[0].personal.contactMethods[0].type = 'mobile_phone';
            dto.trustees[0].personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.trustees[0].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.trustees[0].personal.contactMethods[1].type = 'email_address';
            dto.trustees[0].personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.trustees[0].residential = FinanceOneResidential.residentialApp1(a, o);
            
            String[] expirationDate;
            
            dto.trustees[0].employment = FinanceOneEmployment.employmentApp1(1, a);
            
            dto.trustees[0].creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.trustees[0].creditHistory.details = 'Average';
            
            dto.trustees[0].other = new FinanceOneDTOs.Other();
            
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.trustees[0].other.circumstancesChanging = true;
                dto.trustees[0].other.changeInformation = '----------';
            }else{
                dto.trustees[0].other.circumstancesChanging = false;   
            }
            
            if(a.No_of_People__c == 2){
                dto.trustees[1] = new FinanceOneDTOs.TrusteeIndividual(); 
                dto.trustees[1].personal = new FinanceOneDTOs.Personal();
                dto.trustees[1].personal.isExistingClient = false;
                dto.trustees[1].personal.title = a.Title_2__c.toLowercase();
                dto.trustees[1].personal.firstName = a.First_Name_2__c;
                dto.trustees[1].personal.lastName = a.Last_Name_2__c;
                dateOfBirth = a.Date_of_Birth_2__c.split('/');
                dto.trustees[1].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
                dto.trustees[1].personal.sex = FinanceOneUtils.sex(a.Gender_2__c);
                dto.trustees[1].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_2__c);
                if('Spouse VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.trustees[1].personal.visaType = 'permanent_partner_visa_migrant_100';  
                }
                if('Working VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.trustees[1].personal.visaType = 'not_listed';  
                }
                dto.trustees[1].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_2__c);
                dto.trustees[1].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
                dto.trustees[1].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
                dto.trustees[1].personal.contactMethods[0].type = 'mobile_phone';
                dto.trustees[1].personal.contactMethods[0].value = a.Mobile_Number_2__c;
                dto.trustees[1].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
                dto.trustees[1].personal.contactMethods[1].type = 'email_address';
                dto.trustees[1].personal.contactMethods[1].value = a.Email_Address_2__c;
                
                dto.trustees[1].residential = FinanceOneResidential.residentialApp2(a, o);
                
                dto.trustees[1].employment = FinanceOneEmployment.employmentApp2(2, a);
                
                dto.trustees[1].creditHistory = new FinanceOneDTOs.CreditHistory();
                dto.trustees[1].creditHistory.details = 'Average';
                
                //dto.individuals[1].other = new FinanceOneDTOs.Other();
                //dto.individuals[1].other.circumstancesChanging = true;
                //dto.individuals[1].other.changeInformation = 'Example expected change in circumstances text.';
                dto.trustees[1].other = new FinanceOneDTOs.Other();
                if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                    dto.trustees[1].other.circumstancesChanging = true;
                    dto.trustees[1].other.changeInformation = '----------';
                }else{
                    dto.trustees[1].other.circumstancesChanging = false;   
                }
                
            }
            
            dto.trust = new FinanceOneDTOs.CommercialEntity();
            dto.trust.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.trust.creditHistory.details = 'Average';
            
            dto.trust.incomes = new FinanceOneDTOs.Income[0];
            
            dto.trust.liabilities = FinanceOneLiability.liability(a);
            
            dto.trust.expenses = new FinanceOneDTOs.Expense[0];
            
            Application_Employment__c entity = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                Work_Address__c, Phone__c,
                                                Unit_Number__c, Street_Number__c, Street_Type__c,
                                                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            
            dto.trust.entity = new FinanceOneDTOs.Entity();
            dto.trust.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.trust.entity.tradingName = a.Trading_Name__c;
            dto.trust.entity.abn = a.Business_ABN__c;
            dto.trust.entity.acn = a.Business_ACN__c;
            dto.trust.entity.address = new FinanceOneDTOs.Address();
            dto.trust.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.trust.entity.address.suburb = entity.Suburb__c;
            dto.trust.entity.address.state = entity.State__c.toLowercase();
            dto.trust.entity.address.postcode = entity.Postcode__c;
            dto.trust.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServiceTrustWithIndividualTrusteeApplication(dto, o, UUID, apiUser, this.mgr);
            }
        }
        return lenderRes;
    }
    
    public LenderAPIResponse__c trustWithCompanyTrusteeApplication(Custom_Opportunity__c o, Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting, Application_Extra_Data__c e, String apiUser){
        LenderAPIResponse__c lenderRes = null;
        FinanceOneDTOs.TrustWithCompanyTrusteeApplication dto = new FinanceOneDTOs.TrustWithCompanyTrusteeApplication();
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        if(f.submitRequest(a, o.Id)){
            //dto.uploadedDocuments = '679d9ebf-1ab2-4e61-847e-0a80484225cc';
            String UUID;
            //if (!Test.isRunningTest()) {
            UUID = file(o.Id);
            //}else{
            //UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc'; 
            //}
            dto.uploadedDocuments = UUID;
            
            System.debug(FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c));
            
            dto.productTypeId = FinanceOneUtils.productTypeId(quoting.Loan_Product__c, quoting.Loan_Facility_Type__c);
            //dto.productTypeId = 'COM.S.BRO';
            dto.loan = new FinanceOneDTOs.Loan();
            
            //dto.loan.purpose = FinanceOneUtils.loanPurposes(a.Type_of_Asset__c);
            dto.loan.purpose = FinanceOneUtils.loanPurposes(quoting.Goods_type__c);
            //dto.loan.term = a.Length_of_Term__c.intValue() * 12;
            dto.loan.term = quoting.Term__c.intValue();
            dto.loan.repaymentCapacity = quoting.Repayment_Monthly__c;
            dto.loan.repaymentFrequency = 'monthly';
            dto.loan.feePaymentPreference = 'finance_under_contract';
            dto.loan.otherFeaturesOrRequirements = 'no';
            
            dto.financial = new FinanceOneDTOs.Financial();
            dto.financial.retailPrice = quoting.Vehicle_Price__c;    
            dto.financial.brokerageFee = quoting.DOF__c;
            dto.financial.existingPayout = quoting.Payout_On__c;
            dto.financial.deposit = quoting.Deposit__c;
            dto.financial.tradeIn = quoting.Trade_In__c;
            //dto.financial.insurances = new FinanceOneDTOs.Insurance[0];
            
            Map<String,id> RecordTypes = new Map<String, Id>();
            List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
            for (RecordType rt : productTypes) {
                RecordTypes.put(rt.Name, rt.Id);
            }
            
            String recordTypeId = RecordTypes.get('Insurance');
            List<Product__c> p = [Select RecordTypeId, Insurance_Type__c, Insurance_Policy_Amount__c, Insurer__c from Product__c where Opportunity_Name__c =: o.Id and RecordTypeId =: recordTypeId];
            
            dto.financial.insurances = new FinanceOneDTOs.Insurance[p.size()];
            
            Integer i = 0;
            for (Product__c product : p) {
                dto.financial.insurances[i] = new FinanceOneDTOs.Insurance();
                dto.financial.insurances[i].type = FinanceOneUtils.insuranceType(product.Insurance_Type__c);
                dto.financial.insurances[i].name = product.Insurer__c;
                dto.financial.insurances[i].value = product.Insurance_Policy_Amount__c;   
                i++;
            }
            
            dto.security = FinanceOneSecurity.security(a, asset, g, quoting);
            
            dto.additionalInformation = new FinanceOneDTOs.AdditionalInformation();
            dto.additionalInformation.notes = '';
            if(e != null && String.isNotBlank(e.Data__c)){
              dto.additionalInformation.notes = e.Data__c;
            }
            
            Decimal livingExpenses = 0;
            if(String.isNotBlank(a.Basic_Living_Expenses_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Basic_Living_Expenses_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Childcare_Child_Maintenance_Per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Childcare_Child_Maintenance_Per_Month__c, false);
            }
            if(String.isNotBlank(a.Mobile_Phone_Internet_Pay_TV_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
            }
            if(String.isNotBlank(a.Insurance_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Insurance_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Travel_Transport_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Travel_Transport_Expenses_per_Month__c, false);
            }
            if(String.isNotBlank(a.Other_Expenses_per_Month__c)){
                livingExpenses += NumberUtils.convertToDecimal(a.Other_Expenses_per_Month__c, false);
            }
            
            dto.trusteeDirectors = new FinanceOneDTOs.Guarantor[a.No_of_People__c.intValue()];
            dto.trusteeDirectors[0] = new FinanceOneDTOs.Guarantor(); 
            dto.trusteeDirectors[0].personal = new FinanceOneDTOs.Personal();
            dto.trusteeDirectors[0].personal.isExistingClient = false;
            dto.trusteeDirectors[0].personal.title = a.Title_1__c.toLowercase();
            dto.trusteeDirectors[0].personal.firstName = a.First_Name__c;
            dto.trusteeDirectors[0].personal.lastName = a.Last_Name__c;
            String[] dateOfBirth = a.Date_of_Birth_1__c.split('/');
            dto.trusteeDirectors[0].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            dto.trusteeDirectors[0].personal.sex = FinanceOneUtils.sex(a.Gender_1__c);
            dto.trusteeDirectors[0].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_1__c);
            if('Spouse VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.trusteeDirectors[0].personal.visaType = 'permanent_partner_visa_migrant_100';  
            }
            if('Working VISA'.equals(a.Current_Residential_Status_1__c)){
                dto.trusteeDirectors[0].personal.visaType = 'not_listed';  
            }
            dto.trusteeDirectors[0].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_1__c);
            dto.trusteeDirectors[0].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
            dto.trusteeDirectors[0].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
            dto.trusteeDirectors[0].personal.contactMethods[0].type = 'mobile_phone';
            dto.trusteeDirectors[0].personal.contactMethods[0].value = a.Mobile_Number__c;
            dto.trusteeDirectors[0].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
            dto.trusteeDirectors[0].personal.contactMethods[1].type = 'email_address';
            dto.trusteeDirectors[0].personal.contactMethods[1].value = a.Email_Address__c;
            
            dto.trusteeDirectors[0].residential = FinanceOneResidential.residentialApp1(a, o);
            
            String[] expirationDate;
            
            dto.trusteeDirectors[0].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
            dto.trusteeDirectors[0].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
            dto.trusteeDirectors[0].employment.guarantorEmployment.duration = 0;
            dto.trusteeDirectors[0].employment.standardEmployments = FinanceOneEmployment.employmentApp1(1, a);
            
            dto.trusteeDirectors[0].creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.trusteeDirectors[0].creditHistory.details = 'Average';
            
            dto.trusteeDirectors[0].other = new FinanceOneDTOs.Other();
            
            if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                dto.trusteeDirectors[0].other.circumstancesChanging = true;
                dto.trusteeDirectors[0].other.changeInformation = '----------';
            }else{
                dto.trusteeDirectors[0].other.circumstancesChanging = false;   
            }
            
            if(a.No_of_People__c == 2){
                dto.trusteeDirectors[1] = new FinanceOneDTOs.Guarantor(); 
                dto.trusteeDirectors[1].personal = new FinanceOneDTOs.Personal();
                dto.trusteeDirectors[1].personal.isExistingClient = false;
                dto.trusteeDirectors[1].personal.title = a.Title_2__c.toLowercase();
                dto.trusteeDirectors[1].personal.firstName = a.First_Name_2__c;
                dto.trusteeDirectors[1].personal.lastName = a.Last_Name_2__c;
                dateOfBirth = a.Date_of_Birth_2__c.split('/');
                dto.trusteeDirectors[1].personal.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
                dto.trusteeDirectors[1].personal.sex = FinanceOneUtils.sex(a.Gender_2__c);
                dto.trusteeDirectors[1].personal.residencyStatus = FinanceOneUtils.residencyStatus(a.Current_Residential_Status_2__c);
                if('Spouse VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.trusteeDirectors[1].personal.visaType = 'permanent_partner_visa_migrant_100';  
                }
                if('Working VISA'.equals(a.Current_Residential_Status_2__c)){
                    dto.trusteeDirectors[1].personal.visaType = 'not_listed';  
                }
                dto.trusteeDirectors[1].personal.maritalStatus = FinanceOneUtils.maritalStatus(a.Marital_Status_2__c);
                dto.trusteeDirectors[1].personal.contactMethods = new FinanceOneDTOs.ContactMethod[2];
                dto.trusteeDirectors[1].personal.contactMethods[0] = new FinanceOneDTOs.ContactMethod();
                dto.trusteeDirectors[1].personal.contactMethods[0].type = 'mobile_phone';
                dto.trusteeDirectors[1].personal.contactMethods[0].value = a.Mobile_Number_2__c;
                dto.trusteeDirectors[1].personal.contactMethods[1] = new FinanceOneDTOs.ContactMethod();
                dto.trusteeDirectors[1].personal.contactMethods[1].type = 'email_address';
                dto.trusteeDirectors[1].personal.contactMethods[1].value = a.Email_Address_2__c;
                
                dto.trusteeDirectors[1].residential = FinanceOneResidential.residentialApp2(a, o);
                
                dto.trusteeDirectors[1].employment = new FinanceOneDTOs.CommercialIndividualEmployment();
                dto.trusteeDirectors[1].employment.guarantorEmployment = new FinanceOneDTOs.GuarantorEmployment();
                dto.trusteeDirectors[1].employment.guarantorEmployment.duration = 0;
                dto.trusteeDirectors[1].employment.standardEmployments = FinanceOneEmployment.employmentApp2(2, a);
                
                dto.trusteeDirectors[1].creditHistory = new FinanceOneDTOs.CreditHistory();
                dto.trusteeDirectors[1].creditHistory.details = 'Average';
                
                //dto.individuals[1].other = new FinanceOneDTOs.Other();
                //dto.individuals[1].other.circumstancesChanging = true;
                //dto.individuals[1].other.changeInformation = 'Example expected change in circumstances text.';
                dto.trusteeDirectors[1].other = new FinanceOneDTOs.Other();
                if(a.Do_you_expect_any_change_to_your_financi__c.equals('Yes')){
                    dto.trusteeDirectors[1].other.circumstancesChanging = true;
                    dto.trusteeDirectors[1].other.changeInformation = '----------';
                }else{
                    dto.trusteeDirectors[1].other.circumstancesChanging = false;   
                }
                
            }
            
            dto.trust = new FinanceOneDTOs.CommercialEntity();
            dto.trust.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.trust.creditHistory.details = 'Average';
            
            dto.trust.incomes = new FinanceOneDTOs.Income[0];
            
            dto.trust.liabilities = FinanceOneLiability.liability(a);
            
            dto.trust.expenses = new FinanceOneDTOs.Expense[0];
            
            Application_Employment__c entity = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                Work_Address__c, Phone__c,
                                                Unit_Number__c, Street_Number__c, Street_Type__c,
                                                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
            
            dto.trust.entity = new FinanceOneDTOs.Entity();
            dto.trust.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.trust.entity.tradingName = a.Trading_Name__c;
            dto.trust.entity.abn = a.Business_ABN__c;
            dto.trust.entity.acn = a.Business_ACN__c;
            dto.trust.entity.address = new FinanceOneDTOs.Address();
            dto.trust.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.trust.entity.address.suburb = entity.Suburb__c;
            dto.trust.entity.address.state = entity.State__c.toLowercase();
            dto.trust.entity.address.postcode = entity.Postcode__c;
            dto.trust.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            
            dto.trusteeEntity = new FinanceOneDTOs.TrusteeCompany();
            dto.trusteeEntity.creditHistory = new FinanceOneDTOs.CreditHistory();
            dto.trusteeEntity.creditHistory.details = 'Average';
            
            dto.trusteeEntity.entity = new FinanceOneDTOs.Entity();
            dto.trusteeEntity.entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
            dto.trusteeEntity.entity.tradingName = a.Trading_Name__c;
            dto.trusteeEntity.entity.abn = a.Business_ABN__c;
            dto.trusteeEntity.entity.address = new FinanceOneDTOs.Address();
            dto.trusteeEntity.entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
            dto.trusteeEntity.entity.address.suburb = entity.Suburb__c;
            dto.trusteeEntity.entity.address.state = entity.State__c.toLowercase();
            dto.trusteeEntity.entity.address.postcode = entity.Postcode__c;
            dto.trusteeEntity.entity.predominantBusinessActivity = a.Nature_of_Business__c;
            if (UUID != null) {
                lenderRes = FinanceOneServices.postServiceTrustWithCompanyTrusteeApplication(dto, o, UUID, apiUser, this.mgr);
            }
        }
        return lenderRes;
    }
    
    public String file(String oppId){
        String UUID;
        
        List<Cloud_Documents__c> documents = [select Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
                                                               Custom_Opportunity__c=:oppId and Send_To_Lender__c=true];
        
        Integer f = 1;
        String files = '{';
        List<Integer> fileSize = new List<Integer>();
        List<String> fileName = new List<String>();
        List<String> fileType = new List<String>();
        Map<String, Blob> filesMap = new Map<String, Blob>();
        Integer filesSize = 0;
        Blob file;
        final Integer SFMAXFILESIZE = 4394184;
        System.debug('total docs => ' + documents.size());
        for (Cloud_Documents__c d : documents) {
          System.debug('Downloading => ' + d.Document_Type__c);
            if (!Test.isRunningTest()) {
                file = CloudDocsHelper.fileDownLoad(d);
            }else{
                file = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAmEAAAAwMNAAAAAAAAAAAAAAAAFhfI6PAYKCk2R2ZnaoaJmKn4/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AJ1euwWNClEi8WE6TqSxg6S0dsdR2joB5Hcmdd6ywCJo7EzLu2WARGQDAf/Z');
            }
            if(file != null){
              System.debug('adding file => ' + d.File_Name__c);
                fileSize.add(file.size());
                fileName.add(d.File_Name__c);
                fileType.add(d.Document_Type__c);
                filesMap.put(d.File_Name__c, file);
            }
        }
        try{
            if(fileSize.size() != 0){ 
                for (Integer i = fileSize.size() - 1; i > 0; i--) {
                    for (Integer j = 0; j < i; j++) {
                        if (fileSize.get(j) > fileSize.get(j + 1)) {
                            Integer value = fileSize.get(j+1);
                            String value2 = fileName.get(j+1);
                            String value3 = fileType.get(j+1);
                            fileSize.set(j+1, fileSize.get(j));
                            fileSize.set(j, value);
                            fileName.set(j+1, fileName.get(j));
                            fileName.set(j, value2);
                            fileType.set(j+1, fileType.get(j));
                            fileType.set(j, value3);
                        }
                    }
                }
                
                for (Integer i = 0; i < fileSize.size(); i++) {
                    filesSize += fileSize.get(i);
                    if(filesSize <= SFMAXFILESIZE){
                        files = files+'"file'+f+'":"'+fileName.get(i)+'",';
                        f++;
                    }
                }
                
                files = files.substring(0, files.length()-1)+'}';
                System.debug(files);
                String form64 = '';
                
                form64 += FinanceOneFile.WriteBoundary();
                form64 += FinanceOneFile.WriteBodyParameter('json', files);
                form64 += FinanceOneFile.WriteBoundary();
                
                FinanceOneFile.WriteFileResult result;
                f = 0;
                filesSize = 0;
                System.debug(fileSize);
                System.debug(fileName);
                Boolean isLimitError = false;
                for (Integer i = 0; i < fileSize.size(); i++) {
                    filesSize += fileSize.get(i);
                    if(filesSize <= SFMAXFILESIZE){
                        f++;
                        result = FinanceOneFile.WriteFile('file'+f, fileName.get(i), FinanceOneUtils.getContentType(fileName.get(i)), filesMap.get(fileName.get(i)));
                        form64 += result.Content;
                    }else{
                      this.mgr.addErrorMessage('File can not be sent due to its size exceeds SF limit ['+fileName.get(i)+'] ('+fileType.get(i)+')');
                      isLimitError = true;
                    }
                }
                if(isLimitError){
                  this.mgr.addErrorMessage('The total files size should not be over 4.2MB, Salesforce limit reached.');   
                }
                // System.debug(filesSize);
                if(f > 0){
                    form64 += FinanceOneFile.WriteBoundary(result.EndingType);
                    blob formBlob = EncodingUtil.base64Decode(form64);
                    string contentLength = string.valueOf(formBlob.size());
                    string contentType = FinanceOneFile.GetContentType();
                    HttpRequest httpRequest = new HttpRequest();
                    
                    httpRequest.setBodyAsBlob(formBlob);
                    String url = APIServiceManager.getParameterService(FinanceOneServices.PARAM_ENDPOINT1);
                    httpRequest.setEndpoint(url + '/documents');
                    httpRequest.setHeader('Connection', 'keep-alive');
                    httpRequest.setHeader('Content-Length', contentLength);
                    httpRequest.setHeader('Content-Type', contentType);
                    httpRequest.setMethod('POST');
                    httpRequest.setTimeout(120000);
                    httpRequest.setHeader('x-api-key', APIServiceManager.getParameterService(FinanceOneServices.PARAM_TOKEN));
                    Http http = new Http();
                    HttpResponse response;
                    if (!Test.isRunningTest()) {
                        response = http.send(httpRequest);
                        System.debug(response);
                        System.debug(response.getBody());
                        ResponseFinanceOne r = (ResponseFinanceOne)JSON.deserialize(response.getBody(), ResponseFinanceOne.class);
                        UUID = r.data.uuid;
                    }else{
                        UUID = '679d9ebf-1ab2-4e61-847e-0a80484225cc';  
                    }
                }else{
                  this.mgr.addErrorMessage('Any file was sent, please review/optimize them and try again.');
                }
            }else{
              this.mgr.addErrorMessage('There is not any file to be sent, please review/optimize them and try again');
            }    
        }catch(Exception e){
          this.mgr.addErrorMessage(e.getMessage());
        }
        return UUID;
    }
    
    public static Boolean otherIncomeSecondJob(Integer applicant, Application__c a){
        
        List < Application_Income__c > otherIncome = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                      Income__c, Order__c, Type__c
                                                      FROM Application_Income__c WHERE Application__c =: a.Id 
                                                      AND Applicant__c =: String.valueOf(applicant) AND Type__c = 'Second Job' ORDER BY Order__c
                                                     ];
        
        if(!otherIncome.isEmpty()){
            return true;
        }else{
            return false;
        }
        
    }
}