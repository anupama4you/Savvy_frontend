public class FinanceOneEmployment {
    public static FinanceOneDTOs.StandardEmployment employmentApp1(Integer applicant, Application__c a){
        FinanceOneDTOs.StandardEmployment employment = new FinanceOneDTOs.StandardEmployment();
        employment.current = new FinanceOneDTOs.CurrentEmployments();
        
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c =: String.valueOf(applicant)];
        
        Date todayDate = Date.today();
        Date startDateEmploymentCurrent;
        Integer durationEmploymentCurrent;
        Integer durationEmploymentCurrentSecondJob;
        Boolean secondJobStandard = false;
        Boolean secondJobSelf = false;
        Boolean secondJobUnemployed = false;
        Boolean secondJobBenefit= false;
        String secondJob;
        String[] endDate;
        
        List<Application_Employment__c> listE = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                 Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                 Work_Address__c, Phone__c,
                                                 Unit_Number__c, Street_Number__c, Street_Type__c,
                                                 Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                 Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                 FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
        
        Application_Employment__c entity;
        if(!listE.isEmpty()){
            entity = listE.get(0);
        }
        
        for (Application_Employment__c e: lst) {	
            
            if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
               || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                   if(a.Mode_of_Employment_1__c.equals('Full Time') || a.Mode_of_Employment_1__c.equals('Part Time')
                      || a.Mode_of_Employment_1__c.equals('Casual') || a.Mode_of_Employment_1__c.equals('Contract')){
                          secondJobStandard = true;
                          employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[2];
                          employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                          startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                          durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[0].duration = durationEmploymentCurrent;
                          employment.current.standard[0].basis = FinanceOneUtils.employment(a.Mode_of_Employment_1__c);
                          employment.current.standard[0].occupation = a.Current_Occupation_1__c;
                          employment.current.standard[0].employerName = a.Current_Employer_Name_1__c;
                          employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(a.Reference_Name_1__c);
                          employment.current.standard[0].contact.phone = a.Current_Employer_Phone_1__c;
                          employment.current.standard[0].address = new FinanceOneDTOs.Address();
                          employment.current.standard[0].address.street = FinanceOneEmployment.street2(a.Current_Work_Unit_Number_1__c, a.Current_Work_Street_Number_1__c, a.Current_Work_Address_1__c, a.Current_Work_Street_Type_1__c);
                          employment.current.standard[0].address.suburb = a.Current_Work_Suburb_1__c;
                          employment.current.standard[0].address.state = a.Current_Work_State_1__c.toLowercase();
                          employment.current.standard[0].address.postcode = a.Current_Work_Postcode_1__c;
                          employment.current.standard[1] = new FinanceOneDTOs.CurrentStandardEmployment();
                          durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[1].duration = durationEmploymentCurrentSecondJob;
                          employment.current.standard[1].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                          employment.current.standard[1].occupation = e.Occupation__c;
                          employment.current.standard[1].employerName = e.Employer_Name__c;
                          employment.current.standard[1].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[1].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                          employment.current.standard[1].contact.phone = e.Phone__c;
                          employment.current.standard[1].address = new FinanceOneDTOs.Address();
                          employment.current.standard[1].address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+e.Work_Address__c+' '+e.Street_Type__c;
                          employment.current.standard[1].address.suburb = e.Suburb__c;
                          employment.current.standard[1].address.state = e.State__c.toLowercase();
                          employment.current.standard[1].address.postcode = e.Postcode__c;
                          employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                          employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                          employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                      }else{
                          employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[1];
                          employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                          durationEmploymentCurrent = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[0].duration = durationEmploymentCurrent;
                          employment.current.standard[0].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                          employment.current.standard[0].occupation = e.Occupation__c;
                          employment.current.standard[0].employerName = e.Employer_Name__c;
                          employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                          employment.current.standard[0].contact.phone = e.Phone__c;
                          employment.current.standard[0].address = new FinanceOneDTOs.Address();
                          employment.current.standard[0].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                          employment.current.standard[0].address.suburb = e.Suburb__c;
                          employment.current.standard[0].address.state = e.State__c.toLowercase();
                          employment.current.standard[0].address.postcode = e.Postcode__c;
                          secondJob = 'standard';
                      }
                   
               }
            /*
if(e.Employment_Type__c.equals('Self Employed')){
if(a.Mode_of_Employment_1__c.equals('Self Employed')){
secondJobSelf = true;
employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[2];
employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[0].duration = durationEmploymentCurrent;
employment.current.self[0].entity = new FinanceOneDTOs.Entity();
employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[0].entity.tradingName = a.Trading_Name__c;
employment.current.self[0].entity.abn = a.Business_ABN__c;
employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
employment.current.self[0].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+e.Work_Address__c+' '+e.Street_Type__c;
employment.current.self[0].entity.address.suburb = e.Suburb__c;
employment.current.self[0].entity.address.state = e.State__c.toLowercase();
employment.current.self[0].entity.address.postcode = e.Postcode__c;
employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.current.self[0].occupation = a.Current_Occupation_1__c;
employment.current.self[1] = new FinanceOneDTOs.CurrentSelfEmployment();
durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[1].duration = durationEmploymentCurrentSecondJob;
employment.current.self[1].entity = new FinanceOneDTOs.Entity();
employment.current.self[1].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[1].entity.tradingName = a.Trading_Name__c;
employment.current.self[1].entity.abn = a.Business_ABN__c;
employment.current.self[1].entity.address = new FinanceOneDTOs.Address();
employment.current.self[1].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+e.Work_Address__c+' '+e.Street_Type__c;
employment.current.self[1].entity.address.suburb = e.Suburb__c;
employment.current.self[1].entity.address.state = e.State__c.toLowercase();
employment.current.self[1].entity.address.postcode = e.Postcode__c;
employment.current.self[1].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.current.self[1].occupation = e.Occupation__c;
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}else{
employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[1];
employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[0].duration = durationEmploymentCurrentSecondJob;
employment.current.self[0].entity = new FinanceOneDTOs.Entity();
employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[0].entity.tradingName = a.Trading_Name__c;
employment.current.self[0].entity.abn = a.Business_ABN__c;
employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
employment.current.self[0].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+e.Work_Address__c+' '+e.Street_Type__c;
employment.current.self[0].entity.address.suburb = e.Suburb__c;
employment.current.self[0].entity.address.state = e.State__c.toLowercase();
employment.current.self[0].entity.address.postcode = e.Postcode__c;
employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.current.self[0].occupation = e.Occupation__c;
secondJob = 'self';
}                        
}
*/
            if(e.Employment_Type__c.equals('Unemployed')){
                if(a.Mode_of_Employment_1__c.equals('Unemployed')){
                    secondJobUnemployed = true;
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[2];
                    employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                    startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                    durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[0].duration = durationEmploymentCurrent;
                    employment.current.unemployed[1] = new FinanceOneDTOs.CurrentUnemployed();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[1].duration = durationEmploymentCurrentSecondJob;
                    employment.current.unemployed[1].notes= 'no reason';
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }else{
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[1];
                    employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[0].duration = durationEmploymentCurrentSecondJob;
                    employment.current.unemployed[0].notes= 'no reason';
                    secondJob = 'unemployed';
                }  
            }
            
            if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                if(a.Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') || a.Mode_of_Employment_1__c.equals('Centrelink - Newstart only')){
                    secondJobBenefit = true;
                    
                    employment.current.benefits = FinanceOneEmployment.benefit(2, a, applicant);
                    employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                    startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                    durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[0].duration = durationEmploymentCurrent;
                    employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(a.Mode_of_Employment_1__c);
                    employment.current.benefits[1] = new FinanceOneDTOs.CurrentBenefit();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[1].duration = durationEmploymentCurrentSecondJob;
                    employment.current.benefits[1].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                    
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                }else{
                    
                    employment.current.benefits = FinanceOneEmployment.benefit(1, a, applicant);
                    employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[0].duration = durationEmploymentCurrentSecondJob;
                    employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                    
                    secondJob = 'benefit';
                }  
            }
        }
        
        if(a.Mode_of_Employment_1__c.equals('Full Time') || a.Mode_of_Employment_1__c.equals('Part Time')
           || a.Mode_of_Employment_1__c.equals('Casual') || a.Mode_of_Employment_1__c.equals('Contract')){
               if(!secondJobStandard){
                   employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[1];
                   employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                   startDateEmploymentCurrent= Date.parse(a.Date_Started_1__c);
                   durationEmploymentCurrent = startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                   employment.current.standard[0].duration = durationEmploymentCurrent;
                   employment.current.standard[0].basis = FinanceOneUtils.employment(a.Mode_of_Employment_1__c);
                   employment.current.standard[0].occupation = a.Current_Occupation_1__c;
                   employment.current.standard[0].employerName = a.Current_Employer_Name_1__c;
                   employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                   employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(a.Reference_Name_1__c);
                   employment.current.standard[0].contact.phone = a.Current_Employer_Phone_1__c;
                   employment.current.standard[0].address = new FinanceOneDTOs.Address();
                   employment.current.standard[0].address.street = FinanceOneEmployment.street2(a.Current_Work_Unit_Number_1__c, a.Current_Work_Street_Number_1__c, a.Current_Work_Address_1__c, a.Current_Work_Street_Type_1__c);
                   employment.current.standard[0].address.suburb = a.Current_Work_Suburb_1__c;
                   employment.current.standard[0].address.state = a.Current_Work_State_1__c.toLowercase();
                   employment.current.standard[0].address.postcode = a.Current_Work_Postcode_1__c;
                   /*
if('self'.equals(secondJob)){
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}
*/
                   if('unemployed'.equals(secondJob)){
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                       employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                   }
                   if('benefit'.equals(secondJob)){
                       employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                   }
                   if(String.isBlank(secondJob)){
                       employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                       employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                   }
               }
           }
        
        if(a.Mode_of_Employment_1__c.equals('Self Employed')){
            if(!secondJobSelf && 'Business'.equals(a.Application_Type__c)){
                employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[1];
                employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.self[0].duration = durationEmploymentCurrent;
                employment.current.self[0].entity = new FinanceOneDTOs.Entity();
                employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
                employment.current.self[0].entity.tradingName = a.Trading_Name__c;
                employment.current.self[0].entity.abn = a.Business_ABN__c;
                employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
                employment.current.self[0].entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
                employment.current.self[0].entity.address.suburb = entity.Suburb__c;
                employment.current.self[0].entity.address.state = entity.State__c.toLowercase();
                employment.current.self[0].entity.address.postcode = entity.Postcode__c;
                employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
                employment.current.self[0].occupation = a.Current_Occupation_1__c;
                if('standard'.equals(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('unemployed'.equals(secondJob)){
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('benefit'.equals(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }																			  
            }
        }
        
        if(a.Mode_of_Employment_1__c.equals('Unemployed')){
            if(!secondJobUnemployed){
                employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[1];
                employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.unemployed[0].duration = durationEmploymentCurrent;
                employment.current.unemployed[0].notes= 'no reason';
                /*
if('self'.equals(secondJob)){
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}
*/
                if('standard'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('benefit'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                }
            }
        }
        
        if(a.Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') || a.Mode_of_Employment_1__c.equals('Centrelink - Newstart only')){
            if(!secondJobBenefit){
                
                employment.current.benefits = FinanceOneEmployment.benefit(1, a, applicant);
                employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_1__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.benefits[0].duration = durationEmploymentCurrent;
                employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(a.Mode_of_Employment_1__c);
                
                /*
if('self'.equals(secondJob)){
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
}
*/
                if('standard'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                }
                if('unemployed'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
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
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        FinanceOneEmployment f = new FinanceOneEmployment();
        if(String.isNotBlank(a.Start_Date_1__c)){
            employment.previous = f.previousEmploymentApp1(applicant, a);
        }else if(!lst.isEmpty()){
            employment.previous = f.previousEmploymentApp12(applicant, a);
        }else{
            employment.previous = new FinanceOneDTOs.PreviousEmployments();
            employment.previous.standard = new FinanceOneDTOs.PreviousStandardEmployment[0];
            employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
            employment.previous.unemployed = new FinanceOneDTOs.PreviousUnemployed[0];
            employment.previous.benefits = new FinanceOneDTOs.PreviousBenefit[0];
        }
        
        return employment;   
    }
    
    public FinanceOneDTOs.PreviousEmployments previousEmploymentApp1(Integer applicant, Application__c a){
        FinanceOneDTOs.PreviousEmployments employment = new FinanceOneDTOs.PreviousEmployments();
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        
        
        Date startDatePE = Date.parse(a.Start_Date_1__c);
        Date finishPE = Date.parse(a.Finish_Date_1__c);
        Integer durationPE1 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
        
        
        Integer previousEmployment = 0;
        Integer durationPE2;
        Integer durationPE3;
        Integer durationPE4;
        Integer durationPE5;
        
        for (Application_Employment__c e: lst) {
            previousEmployment++;
            if(previousEmployment==1){
                startDatePE= e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE2 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==2){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE3 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==3){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE4 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==4){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE5 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
        }
        
        Integer durationEmploymentPrevious = 0;
        
        durationEmploymentPrevious += durationPE1;
        
        Integer employments = 1;
        
        if(durationPE2 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE2;
                employments++;
            }
        }
        
        if(durationPE3 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE3;
                employments++;
            }
        }
        
        if(durationPE4 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE4;
                employments++;
            }
        }
        
        if(durationPE5 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE5;
                employments++;
            }
        }
        
        Integer standardEmployments = 0;
        //Integer selfEmployments = 0;
        Integer unemployedEmployments = 0;
        Integer benefitEmployments = 0;
        
        previousEmployment = 0;
        
        for (Application_Employment__c e: lst) {
            
            if(previousEmployment < employments - 1 ){
                
                if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                   || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                       standardEmployments++;
                   }
                /*
if(e.Employment_Type__c.equals('Self Employed')){
selfEmployments++;
}
*/
                if(e.Employment_Type__c.equals('Unemployed')){
                    unemployedEmployments++;
                }
                
                if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                    benefitEmployments++;
                }
            }
            previousEmployment++;
        }
        
        if(a.Previous_Mode_of_Employment_1__c.equals('Full Time') || a.Previous_Mode_of_Employment_1__c.equals('Part Time')
           || a.Previous_Mode_of_Employment_1__c.equals('Casual') || a.Previous_Mode_of_Employment_1__c.equals('Contract')){
               System.debug(standardEmployments);
               standardEmployments = standardEmployments + 1;
           }
        /*
if(a.Previous_Mode_of_Employment_1__c.equals('Self Employed')){
selfEmployments = selfEmployments + 1;
}
*/
        if(a.Previous_Mode_of_Employment_1__c.equals('Unemployed')){
            unemployedEmployments = unemployedEmployments + 1;
        }
        
        if(a.Previous_Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') || a.Previous_Mode_of_Employment_1__c.equals('Centrelink - Newstart only')){
            benefitEmployments = benefitEmployments + 1;
        }
        
        employment.standard = new FinanceOneDTOs.PreviousStandardEmployment[standardEmployments];
        //employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[selfEmployments];
        employment.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
        employment.unemployed = new FinanceOneDTOs.PreviousUnemployed[unemployedEmployments];
        employment.benefits = new FinanceOneDTOs.PreviousBenefit[benefitEmployments];
        
        Integer standardPosition = 0;
        Integer selfPosition = 0;
        Integer unemployedPosition = 0;
        Integer benefitPosition = 0;
        String[] endDate;        
        if(a.Previous_Mode_of_Employment_1__c.equals('Full Time') || a.Previous_Mode_of_Employment_1__c.equals('Part Time')
           || a.Previous_Mode_of_Employment_1__c.equals('Casual') || a.Previous_Mode_of_Employment_1__c.equals('Contract')){
               
               if('AUS'.equals(a.Previous_Work_Country_1__c)){
                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                   employment.standard[standardPosition].duration = durationPE1;
                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(a.Previous_Mode_of_Employment_1__c);
                   employment.standard[standardPosition].occupation = a.Previous_Occupation_1__c;
                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
                   employment.standard[standardPosition].employerName = a.Previous_Employer_Name_1__c;
                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(a.Previous_Reference_Name_1__c);
                   employment.standard[standardPosition].contact.phone = a.Previous_Employer_Phone_1__c;
                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(a.Previous_Work_Unit_Number_1__c, a.Previous_Work_Street_Number_1__c, a.Previous_Work_Address_1__c, a.Previous_Work_Street_Type_1__c);
                   employment.standard[standardPosition].address.suburb = a.Previous_Work_Suburb_1__c;
                   employment.standard[standardPosition].address.state = a.Previous_Work_State_1__c.toLowercase();
                   employment.standard[standardPosition].address.postcode = a.Previous_Work_Postcode_1__c;
               }else{
                   System.debug('standard');
                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                   employment.standard[standardPosition].duration = durationPE1;
                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(a.Previous_Mode_of_Employment_1__c);
                   employment.standard[standardPosition].occupation = a.Previous_Occupation_1__c;
                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
                   employment.standard[standardPosition].employerName = a.Previous_Employer_Name_1__c;
                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                   employment.standard[standardPosition].contact.name = 'Payroll';
                   employment.standard[standardPosition].contact.phone = '0233223322';
                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(a.Previous_Work_Address_1__c, a.Previous_Work_Address_2nd_1__c);
                   employment.standard[standardPosition].address.suburb = a.Previous_Work_Overseas_City_1__c;
                   //employment.previous.standard[standardPosition].address.state = a.Previous_Work_Overseas_State_1__c.toLowercase();
                   employment.standard[standardPosition].address.state = 'outside_australia';
                   employment.standard[standardPosition].address.postcode = a.Previous_Work_Postcode_1__c;    
               }    
               standardPosition++;
           }
        /*
if(a.Previous_Mode_of_Employment_1__c.equals('Self Employed')){
if('AUS'.equals(a.Previous_Country_1__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE1;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;

endDate = a.Finish_Date_1__c.split('/');
employment.previous.self[selfPosition].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE1;

employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
//employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = a.Previous_Occupation_1__c;

//employment.previous.self[selfPosition].occupation = 'ocupation';
endDate = a.Finish_Date_1__c.split('/');
employment.previous.self[selfPosition].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
}
selfPosition++;
}
*/
        if(a.Previous_Mode_of_Employment_1__c.equals('Unemployed')){
            if('AUS'.equals(a.Previous_Work_Country_1__c)){
                employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                employment.unemployed[unemployedPosition].duration = durationPE1;
                employment.unemployed[unemployedPosition].notes = 'no reason';
                employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
            }else{
                employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                employment.unemployed[unemployedPosition].duration = durationPE1;
                employment.unemployed[unemployedPosition].notes = 'no reason';
                employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
            }
            unemployedPosition++;
        }
        
        if(a.Previous_Mode_of_Employment_1__c.equals('Centrelink - Family Tax Benefits/Other') || a.Previous_Mode_of_Employment_1__c.equals('Centrelink - Newstart only')){
            if('AUS'.equals(a.Previous_Work_Country_1__c)){
                employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                employment.benefits[benefitPosition].duration = durationPE1;
                employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(a.Previous_Mode_of_Employment_1__c);
                employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
            }else{
                employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                employment.benefits[benefitPosition].duration = durationPE1;
                employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(a.Previous_Mode_of_Employment_1__c);
                employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_1__c);
            }
            benefitPosition++;
        }
        
        if(employments >= 2){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                
                previousEmployment++;
                if(previousEmployment==1){
                    
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE2;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            
                            unemployedPosition++;
                        }
                    }    
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE2;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 3){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==2){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE3;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE3;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 4){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==3){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE4;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE4;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 5){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==4){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE5;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE5;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        return employment;
        
    }
    
    public FinanceOneDTOs.PreviousEmployments previousEmploymentApp12(Integer applicant, Application__c a){
        FinanceOneDTOs.PreviousEmployments employment = new FinanceOneDTOs.PreviousEmployments();
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        
        Integer previousEmployment = 0;
        Integer durationPE2;
        Integer durationPE3;
        Integer durationPE4;
        Integer durationPE5;
        Date startDatePE;
        Date finishPE;
        
        for (Application_Employment__c e: lst) {
            previousEmployment++;
            if(previousEmployment==1){
                startDatePE= e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE2 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==2){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE3 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==3){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE4 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==4){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE5 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
        }
        
        Integer durationEmploymentPrevious = 0;
        
        durationEmploymentPrevious += durationPE2;
        
        Integer employments = 1;
        
        if(durationPE3 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE3;
                employments++;
            }
        }
        
        if(durationPE4 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE4;
                employments++;
            }
        }
        
        if(durationPE5 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE5;
                employments++;
            }
        }
        
        Integer standardEmployments = 0;
        //Integer selfEmployments = 0;
        Integer unemployedEmployments = 0;
        Integer benefitEmployments = 0;
        
        previousEmployment = 0;
        
        for (Application_Employment__c e: lst) {
            
            if(previousEmployment < employments){
                
                if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                   || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                       standardEmployments++;
                   }
                /*
if(e.Employment_Type__c.equals('Self Employed')){
selfEmployments++;
}
*/
                if(e.Employment_Type__c.equals('Unemployed')){
                    unemployedEmployments++;
                }
                
                if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                    benefitEmployments++;
                }
            }
            previousEmployment++;
        }
        
        employment.standard = new FinanceOneDTOs.PreviousStandardEmployment[standardEmployments];
        //employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[selfEmployments];
        employment.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
        employment.unemployed = new FinanceOneDTOs.PreviousUnemployed[unemployedEmployments];
        employment.benefits = new FinanceOneDTOs.PreviousBenefit[benefitEmployments];
        
        Integer standardPosition = 0;
        Integer selfPosition = 0;
        Integer unemployedPosition = 0;
        Integer benefitPosition = 0;
        
        if(employments >= 1){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                
                previousEmployment++;
                if(previousEmployment==1){
                    
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE2;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            
                            unemployedPosition++;
                        }
                    }    
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE2;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);	
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 2){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==2){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE3;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE3;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 3){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==3){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE4;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE4;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 4){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==4){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE5;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE5;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        return employment;
        
    }
    
    public static FinanceOneDTOs.StandardEmployment employmentApp2(Integer applicant, Application__c a){
        FinanceOneDTOs.StandardEmployment employment = new FinanceOneDTOs.StandardEmployment();
        employment.current = new FinanceOneDTOs.CurrentEmployments();
        
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c =: String.valueOf(applicant)];
        
        Date todayDate = Date.today();
        Date startDateEmploymentCurrent;
        Integer durationEmploymentCurrent;
        Integer durationEmploymentCurrentSecondJob;
        Boolean secondJobStandard = false;
        Boolean secondJobSelf = false;
        Boolean secondJobUnemployed = false;
        Boolean secondJobBenefit= false;
        String secondJob;
        String[] endDate;
        
        List<Application_Employment__c> listE = [SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                                                 Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                                                 Work_Address__c, Phone__c,
                                                 Unit_Number__c, Street_Number__c, Street_Type__c,
                                                 Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                                                 Overseas_City__c, Address_Line_2__c, Address_Type__c
                                                 FROM Application_Employment__c WHERE Application__c =: a.Id and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1];
        
        Application_Employment__c entity;
        if(!listE.isEmpty()){
            entity = listE.get(0);
        }
        
        for (Application_Employment__c e: lst) {	
            
            if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
               || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                   if(a.Mode_of_Employment_2__c.equals('Full Time') || a.Mode_of_Employment_2__c.equals('Part Time')
                      || a.Mode_of_Employment_2__c.equals('Casual') || a.Mode_of_Employment_2__c.equals('Contract')){
                          secondJobStandard = true;
                          employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[2];
                          employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                          startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                          durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[0].duration = durationEmploymentCurrent;
                          employment.current.standard[0].basis = FinanceOneUtils.employment(a.Mode_of_Employment_2__c);
                          employment.current.standard[0].occupation = a.Current_Occupation_2__c;
                          employment.current.standard[0].employerName = a.Current_Employer_Name_2__c;
                          employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(a.Reference_Name_2__c);
                          employment.current.standard[0].contact.phone = a.Current_Employer_Phone_2__c;
                          employment.current.standard[0].address = new FinanceOneDTOs.Address();
                          employment.current.standard[0].address.street = FinanceOneEmployment.street2(a.Current_Work_Unit_Number_2__c, a.Current_Work_Street_Number_2__c, a.Current_Work_Address_2__c, a.Current_Work_Street_Type_2__c);
                          employment.current.standard[0].address.suburb = a.Current_Work_Suburb_2__c;
                          employment.current.standard[0].address.state = a.Current_Work_State_2__c.toLowercase();
                          employment.current.standard[0].address.postcode = a.Current_Work_Postcode_2__c;
                          employment.current.standard[1] = new FinanceOneDTOs.CurrentStandardEmployment();
                          durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[1].duration = durationEmploymentCurrentSecondJob;
                          employment.current.standard[1].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                          employment.current.standard[1].occupation = e.Occupation__c;
                          employment.current.standard[1].employerName = e.Employer_Name__c;
                          employment.current.standard[1].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[1].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                          employment.current.standard[1].contact.phone = e.Phone__c;
                          employment.current.standard[1].address = new FinanceOneDTOs.Address();
                          employment.current.standard[1].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                          employment.current.standard[1].address.suburb = e.Suburb__c;
                          employment.current.standard[1].address.state = e.State__c.toLowercase();
                          employment.current.standard[1].address.postcode = e.Postcode__c;
                          employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                          employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                          employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                      }else{
                          employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[1];
                          employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                          durationEmploymentCurrent = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                          employment.current.standard[0].duration = durationEmploymentCurrent;
                          employment.current.standard[0].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                          employment.current.standard[0].occupation = e.Occupation__c;
                          employment.current.standard[0].employerName = e.Employer_Name__c;
                          employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                          employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                          employment.current.standard[0].contact.phone = e.Phone__c;
                          employment.current.standard[0].address = new FinanceOneDTOs.Address();
                          employment.current.standard[0].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                          employment.current.standard[0].address.suburb = e.Suburb__c;
                          employment.current.standard[0].address.state = e.State__c.toLowercase();
                          employment.current.standard[0].address.postcode = e.Postcode__c;
                          secondJob = 'standard';
                      }
                   
               }
            /*
if(e.Employment_Type__c.equals('Self Employed')){
if(a.Mode_of_Employment_2__c.equals('Self Employed')){
secondJobSelf = true;
employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[2];
employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[0].duration = durationEmploymentCurrent;
employment.current.self[0].entity = new FinanceOneDTOs.Entity();
employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[0].entity.tradingName = a.Trading_Name__c;
employment.current.self[0].entity.abn = a.Business_ABN__c;
employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
employment.current.self[0].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+a.Trading_Address__c+' '+e.Street_Type__c;
employment.current.self[0].entity.address.suburb = e.Suburb__c;
employment.current.self[0].entity.address.state = e.State__c.toLowercase();
employment.current.self[0].entity.address.postcode = e.Postcode__c;
employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.current.self[0].occupation = a.Current_Occupation_1__c;
employment.current.self[1] = new FinanceOneDTOs.CurrentSelfEmployment();
durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[1].duration = durationEmploymentCurrentSecondJob;
employment.current.self[1].entity = new FinanceOneDTOs.Entity();
employment.current.self[1].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[1].entity.tradingName = a.Trading_Name__c;
employment.current.self[1].entity.abn = a.Business_ABN__c;
employment.current.self[1].entity.address = new FinanceOneDTOs.Address();
employment.current.self[1].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+a.Trading_Address__c+' '+e.Street_Type__c;
employment.current.self[1].entity.address.suburb = e.Suburb__c;
employment.current.self[1].entity.address.state = e.State__c.toLowercase();
employment.current.self[1].entity.address.postcode = e.Postcode__c;
employment.current.self[1].entity.predominantBusinessActivity = 'p';
employment.current.self[1].occupation = e.Occupation__c;
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}else{
employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[1];
employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
employment.current.self[0].duration = durationEmploymentCurrentSecondJob;
employment.current.self[0].entity = new FinanceOneDTOs.Entity();
employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.current.self[0].entity.tradingName = a.Trading_Name__c;
employment.current.self[0].entity.abn = a.Business_ABN__c;
employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
employment.current.self[0].entity.address.street = e.Unit_Number__c+'/'+e.Street_Number__c+' '+a.Trading_Address__c+' '+e.Street_Type__c;
employment.current.self[0].entity.address.suburb = e.Suburb__c;
employment.current.self[0].entity.address.state = e.State__c.toLowercase();
employment.current.self[0].entity.address.postcode = e.Postcode__c;
employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.current.self[0].occupation = e.Occupation__c;
secondJob = 'self';
}                        
}
*/
            if(e.Employment_Type__c.equals('Unemployed')){
                if(a.Mode_of_Employment_2__c.equals('Unemployed')){
                    secondJobUnemployed = true;
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[2];
                    employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                    startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                    durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[0].duration = durationEmploymentCurrent;
                    employment.current.unemployed[1] = new FinanceOneDTOs.CurrentUnemployed();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[1].duration = durationEmploymentCurrentSecondJob;
                    employment.current.unemployed[1].notes= 'no reason';
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }else{
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[1];
                    employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.unemployed[0].duration = durationEmploymentCurrentSecondJob;
                    employment.current.unemployed[0].notes= 'no reason';
                    secondJob = 'unemployed';
                }  
            }
            
            if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                if(a.Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') || a.Mode_of_Employment_2__c.equals('Centrelink - Newstart only')){
                    secondJobBenefit = true;
                    
                    employment.current.benefits = FinanceOneEmployment.benefit(2, a, applicant);																		
                    employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                    startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                    durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[0].duration = durationEmploymentCurrent;
                    employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(a.Mode_of_Employment_2__c);
                    employment.current.benefits[1] = new FinanceOneDTOs.CurrentBenefit();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[1].duration = durationEmploymentCurrentSecondJob;
                    employment.current.benefits[1].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                    
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                }else{
                    
                    employment.current.benefits = FinanceOneEmployment.benefit(1, a, applicant);
                    employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                    durationEmploymentCurrentSecondJob = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                    employment.current.benefits[0].duration = durationEmploymentCurrentSecondJob;
                    employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                    
                    secondJob = 'benefit';
                }  
            }
        }
        
        if(a.Mode_of_Employment_2__c.equals('Full Time') || a.Mode_of_Employment_2__c.equals('Part Time')
           || a.Mode_of_Employment_2__c.equals('Casual') || a.Mode_of_Employment_2__c.equals('Contract')){
               if(!secondJobStandard){
                   employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[1];
                   employment.current.standard[0] = new FinanceOneDTOs.CurrentStandardEmployment();
                   startDateEmploymentCurrent= Date.parse(a.Date_Started_2__c);
                   durationEmploymentCurrent = startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                   employment.current.standard[0].duration = durationEmploymentCurrent;
                   employment.current.standard[0].basis = FinanceOneUtils.employment(a.Mode_of_Employment_2__c);
                   employment.current.standard[0].occupation = a.Current_Occupation_2__c;
                   employment.current.standard[0].employerName = a.Current_Employer_Name_2__c;
                   employment.current.standard[0].contact = new FinanceOneDTOs.PointOfContact();
                   employment.current.standard[0].contact.name = FinanceOneEmployment.pointOfContactName(a.Reference_Name_2__c);
                   employment.current.standard[0].contact.phone = a.Current_Employer_Phone_2__c;
                   employment.current.standard[0].address = new FinanceOneDTOs.Address();
                   employment.current.standard[0].address.street = FinanceOneEmployment.street2(a.Current_Work_Unit_Number_2__c, a.Current_Work_Street_Number_2__c, a.Current_Work_Address_2__c, a.Current_Work_Street_Type_2__c);
                   employment.current.standard[0].address.suburb = a.Current_Work_Suburb_2__c;
                   employment.current.standard[0].address.state = a.Current_Work_State_2__c.toLowercase();
                   employment.current.standard[0].address.postcode = a.Current_Work_Postcode_2__c;
                   /*
if('self'.equals(secondJob)){
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}
*/
                   if('unemployed'.equals(secondJob)){
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                       employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                   }
                   if('benefit'.equals(secondJob)){
                       employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                   }
                   if(String.isBlank(secondJob)){
                       employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                       employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                       employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                   }
               }
           }
        
        if(a.Mode_of_Employment_2__c.equals('Self Employed')){
            if(!secondJobSelf && 'Business'.equals(a.Application_Type__c)){
                employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[1];
                employment.current.self[0] = new FinanceOneDTOs.CurrentSelfEmployment();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.self[0].duration = durationEmploymentCurrent;
                employment.current.self[0].entity = new FinanceOneDTOs.Entity();
                employment.current.self[0].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
                employment.current.self[0].entity.tradingName = a.Trading_Name__c;
                employment.current.self[0].entity.abn = a.Business_ABN__c;
                employment.current.self[0].entity.address = new FinanceOneDTOs.Address();
                employment.current.self[0].entity.address.street = FinanceOneEmployment.street2(entity.Unit_Number__c, entity.Street_Number__c, a.Trading_Address__c, entity.Street_Type__c);
                employment.current.self[0].entity.address.suburb = entity.Suburb__c;
                employment.current.self[0].entity.address.state = entity.State__c.toLowercase();
                employment.current.self[0].entity.address.postcode = entity.Postcode__c;
                employment.current.self[0].entity.predominantBusinessActivity = a.Nature_of_Business__c;
                employment.current.self[0].occupation = a.Current_Occupation_2__c;
                if('standard'.equals(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('unemployed'.equals(secondJob)){
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('benefit'.equals(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
            }
        }
        
        if(a.Mode_of_Employment_2__c.equals('Unemployed')){
            if(!secondJobUnemployed){
                employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[1];
                employment.current.unemployed[0] = new FinanceOneDTOs.CurrentUnemployed();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.unemployed[0].duration = durationEmploymentCurrent;
                employment.current.unemployed[0].notes= 'no reason';
                /*
if('self'.equals(secondJob)){
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
}
*/
                if('standard'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.benefits = new FinanceOneDTOs.CurrentBenefit[0];
                }
                if('benefit'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.benefits = FinanceOneEmployment.benefit(0, a, applicant);
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                }
            }
        }
        
        if(a.Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') || a.Mode_of_Employment_2__c.equals('Centrelink - Newstart only')){
            if(!secondJobBenefit){
                
                employment.current.benefits = FinanceOneEmployment.benefit(1, a, applicant);
                employment.current.benefits[0] = new FinanceOneDTOs.CurrentBenefit();
                startDateEmploymentCurrent = Date.parse(a.Date_Started_2__c);
                durationEmploymentCurrent= startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employment.current.benefits[0].duration = durationEmploymentCurrent;
                employment.current.benefits[0].benefitType = FinanceOneUtils.benefit(a.Mode_of_Employment_2__c);
                
                /*
if('self'.equals(secondJob)){
employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
}
*/
                if('standard'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                }
                if('unemployed'.equals(secondJob)){
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                }
                if(String.isBlank(secondJob)){
                    employment.current.unemployed = new FinanceOneDTOs.CurrentUnemployed[0];
                    employment.current.standard = new FinanceOneDTOs.CurrentStandardEmployment[0];
                    employment.current.self = new FinanceOneDTOs.CurrentSelfEmployment[0];
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
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        FinanceOneEmployment f = new FinanceOneEmployment();
        if(String.isNotBlank(a.Start_Date_2__c)){
            employment.previous = f.previousEmploymentApp2(applicant, a);
        }else if(!lst.isEmpty()){
            employment.previous = f.previousEmploymentApp22(applicant, a);
        }else{
            employment.previous = new FinanceOneDTOs.PreviousEmployments();
            employment.previous.standard = new FinanceOneDTOs.PreviousStandardEmployment[0];
            employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
            employment.previous.unemployed = new FinanceOneDTOs.PreviousUnemployed[0];
            employment.previous.benefits = new FinanceOneDTOs.PreviousBenefit[0];
        }    
        
        
        return employment; 
    }
    
    public FinanceOneDTOs.PreviousEmployments previousEmploymentApp2(Integer applicant, Application__c a){
        FinanceOneDTOs.PreviousEmployments employment = new FinanceOneDTOs.PreviousEmployments();
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        
        Date startDatePE = Date.parse(a.Start_Date_2__c);
        Date finishPE = Date.parse(a.Finish_Date_2__c);
        Integer durationPE1 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
        Integer previousEmployment = 0;
        Integer durationPE2;
        Integer durationPE3;
        Integer durationPE4;
        Integer durationPE5;
        
        for (Application_Employment__c e: lst) {
            previousEmployment++;
            if(previousEmployment==1){
                startDatePE= e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE2 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==2){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE3 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==3){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE4 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==4){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE5 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
        }
        
        Integer durationEmploymentPrevious = 0;
        
        durationEmploymentPrevious += durationPE1;
        Integer employments = 1;
        
        if(durationPE2 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE2;
                employments++;
            }
        }
        
        if(durationPE3 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE3;
                employments++;
            }
        }
        
        if(durationPE4 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE4;
                employments++;
            }
        }
        
        if(durationPE5 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE5;
                employments++;
            }
        }
        
        Integer standardEmployments = 0;
        //Integer selfEmployments = 0;
        Integer unemployedEmployments = 0;
        Integer benefitEmployments = 0;
        
        previousEmployment = 0;
        
        for (Application_Employment__c e: lst) {
            
            if(previousEmployment < employments - 1 ){
                System.debug(e.Employment_Type__c);
                if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                   || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                       standardEmployments++;
                   }
                /*
if(e.Employment_Type__c.equals('Self Employed')){
selfEmployments++;
}
*/
                if(e.Employment_Type__c.equals('Unemployed')){
                    unemployedEmployments++;
                }
                
                if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                    benefitEmployments++;
                }
            }
            previousEmployment++;
        }
        
        if(a.Previous_Mode_of_Employment_2__c.equals('Full Time') || a.Previous_Mode_of_Employment_2__c.equals('Part Time')
           || a.Previous_Mode_of_Employment_2__c.equals('Casual') || a.Previous_Mode_of_Employment_2__c.equals('Contract')){
               standardEmployments = standardEmployments + 1;
           }
        /*
if(a.Previous_Mode_of_Employment_2__c.equals('Self Employed')){
selfEmployments = selfEmployments + 1;
}
*/
        if(a.Previous_Mode_of_Employment_2__c.equals('Unemployed')){
            unemployedEmployments = unemployedEmployments + 1;
        }
        
        if(a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') || a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Newstart only')){
            benefitEmployments = benefitEmployments + 1;
        }
        
        employment.standard = new FinanceOneDTOs.PreviousStandardEmployment[standardEmployments];
        //employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[selfEmployments];
        employment.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
        employment.unemployed = new FinanceOneDTOs.PreviousUnemployed[unemployedEmployments];
        employment.benefits = new FinanceOneDTOs.PreviousBenefit[benefitEmployments];
        
        Integer standardPosition = 0;
        Integer selfPosition = 0;
        Integer unemployedPosition = 0;
        Integer benefitPosition = 0;
        String[] endDate;
        if(a.Previous_Mode_of_Employment_2__c.equals('Full Time') || a.Previous_Mode_of_Employment_2__c.equals('Part Time')
           || a.Previous_Mode_of_Employment_2__c.equals('Casual') || a.Previous_Mode_of_Employment_2__c.equals('Contract')){
               if('AUS'.equals(a.Previous_Work_Country_2__c)){
                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                   employment.standard[standardPosition].duration = durationPE1;
                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(a.Previous_Mode_of_Employment_2__c);
                   employment.standard[standardPosition].occupation = a.Previous_Occupation_2__c;
                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_2__c);
                   employment.standard[standardPosition].employerName = a.Previous_Employer_Name_2__c;
                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(a.Previous_Reference_Name_2__c);
                   employment.standard[standardPosition].contact.phone = a.Previous_Employer_Phone_2__c;
                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(a.Previous_Work_Unit_Number_2__c, a.Previous_Work_Street_Number_2__c, a.Previous_Work_Address_2__c, a.Previous_Work_Street_Type_2__c);
                   employment.standard[standardPosition].address.suburb = a.Previous_Work_Suburb_2__c;
                   employment.standard[standardPosition].address.state = a.Previous_Work_State_2__c.toLowercase();
                   employment.standard[standardPosition].address.postcode = a.Previous_Work_Postcode_2__c;
               }else{
                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                   employment.standard[standardPosition].duration = durationPE1;
                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(a.Previous_Mode_of_Employment_2__c);
                   employment.standard[standardPosition].occupation = a.Previous_Occupation_2__c;
                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_2__c);
                   employment.standard[standardPosition].employerName = a.Previous_Employer_Name_2__c;
                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                   employment.standard[standardPosition].contact.name = 'Payroll';
                   employment.standard[standardPosition].contact.phone = '0233223322';
                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(a.Previous_Work_Address_2__c, a.Previous_Work_Address_2nd_2__c);
                   employment.standard[standardPosition].address.suburb = a.Previous_Work_Overseas_City_2__c;
                   employment.standard[standardPosition].address.state = 'outside_australia';
                   employment.standard[standardPosition].address.postcode = a.Previous_Work_Postcode_2__c;
               }
               standardPosition++;
           }
        /*
if(a.Previous_Mode_of_Employment_2__c.equals('Self Employed')){
if('AUS'.equals(a.Previous_Country_2__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE1;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
endDate = a.Finish_Date_2__c.split('/');
employment.previous.self[selfPosition].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE1;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
endDate = a.Finish_Date_2__c.split('/');
employment.previous.self[selfPosition].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
}
selfPosition++;
}
*/
        if(a.Previous_Mode_of_Employment_2__c.equals('Unemployed')){
            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
            employment.unemployed[unemployedPosition].duration = durationPE1;
            employment.unemployed[unemployedPosition].notes = 'no reason';
            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_2__c);
            unemployedPosition++;
        }
        
        if(a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Family Tax Benefits/Other') || a.Previous_Mode_of_Employment_2__c.equals('Centrelink - Newstart only')){
            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
            employment.benefits[benefitPosition].duration = durationPE1;
            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(a.Previous_Mode_of_Employment_2__c);
            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate(a.Finish_Date_2__c);
            benefitPosition++;
        }
        
        if(employments >= 2){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                System.debug(e.Employment_Type__c);
                previousEmployment++;
                if(previousEmployment==1){
                    System.debug(e.Employment_Type__c);
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE2;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }    
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE2;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 3){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==2){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE3;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE3;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 4){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==3){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE4;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE4;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 5){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==4){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE5;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE5;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        return employment;
    }
    
    public FinanceOneDTOs.PreviousEmployments previousEmploymentApp22(Integer applicant, Application__c a){
        FinanceOneDTOs.PreviousEmployments employment = new FinanceOneDTOs.PreviousEmployments();
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job' AND Applicant__c =: String.valueOf(applicant)];
        
        /*
Date startDatePE = Date.parse(a.Start_Date_2__c);
Date finishPE = Date.parse(a.Finish_Date_2__c);
Integer durationPE1 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
*/
        
        Integer previousEmployment = 0;
        Integer durationPE2;
        Integer durationPE3;
        Integer durationPE4;
        Integer durationPE5;
        Date startDatePE;
        Date finishPE;
        for (Application_Employment__c e: lst) {
            previousEmployment++;
            if(previousEmployment==1){
                startDatePE= e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE2 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==2){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE3 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==3){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE4 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
            
            if(previousEmployment==4){
                startDatePE = e.Start_Date__c;
                finishPE = e.Finish_Date__c;
                durationPE5 = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
            }
        }
        
        Integer durationEmploymentPrevious = 0;
        
        durationEmploymentPrevious += durationPE2;
        Integer employments = 1;
        /*
if(durationPE2 != null){
if(durationEmploymentPrevious < 36){
durationEmploymentPrevious += durationPE2;
employments++;
}
}
*/
        if(durationPE3 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE3;
                employments++;
            }
        }
        
        if(durationPE4 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE4;
                employments++;
            }
        }
        
        if(durationPE5 != null){
            if(durationEmploymentPrevious < 36){
                durationEmploymentPrevious += durationPE5;
                employments++;
            }
        }
        
        Integer standardEmployments = 0;
        //Integer selfEmployments = 0;
        Integer unemployedEmployments = 0;
        Integer benefitEmployments = 0;
        
        previousEmployment = 0;
        
        for (Application_Employment__c e: lst) {
            
            if(previousEmployment < employments){
                System.debug(e.Employment_Type__c);
                if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                   || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                       standardEmployments++;
                   }
                /*
if(e.Employment_Type__c.equals('Self Employed')){
selfEmployments++;
}
*/
                if(e.Employment_Type__c.equals('Unemployed')){
                    unemployedEmployments++;
                }
                
                if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                    benefitEmployments++;
                }
            }
            previousEmployment++;
        }
        
        employment.standard = new FinanceOneDTOs.PreviousStandardEmployment[standardEmployments];
        //employment.previous.self = new FinanceOneDTOs.PreviousSelfEmployment[selfEmployments];
        employment.self = new FinanceOneDTOs.PreviousSelfEmployment[0];
        employment.unemployed = new FinanceOneDTOs.PreviousUnemployed[unemployedEmployments];
        employment.benefits = new FinanceOneDTOs.PreviousBenefit[benefitEmployments];
        
        Integer standardPosition = 0;
        Integer selfPosition = 0;
        Integer unemployedPosition = 0;
        Integer benefitPosition = 0;
        
        if(employments >= 1){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                System.debug(e.Employment_Type__c);
                previousEmployment++;
                if(previousEmployment==1){
                    System.debug(e.Employment_Type__c);
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE2;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE2;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE2;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }    
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE2;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 2){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==2){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE3;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE3;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE3;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE3;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 3){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==3){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE4;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE4;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE4;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE4;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        if(employments >= 4){
            previousEmployment = 0;
            for (Application_Employment__c e: lst) {
                previousEmployment++;
                if(previousEmployment==4){
                    if(standardPosition < standardEmployments){
                        if(e.Employment_Type__c.equals('Full Time') || e.Employment_Type__c.equals('Part Time')
                           || e.Employment_Type__c.equals('Casual') || e.Employment_Type__c.equals('Contract')){
                               if('AUS'.equals(e.Country__c)){
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = FinanceOneEmployment.pointOfContactName(e.Contact_Name__c);
                                   employment.standard[standardPosition].contact.phone = e.Phone__c;
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street2(e.Unit_Number__c, e.Street_Number__c, e.Work_Address__c, e.Street_Type__c);
                                   employment.standard[standardPosition].address.suburb = e.Suburb__c;
                                   employment.standard[standardPosition].address.state = e.State__c.toLowercase();
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }else{
                                   employment.standard[standardPosition] = new FinanceOneDTOs.PreviousStandardEmployment();
                                   employment.standard[standardPosition].duration = durationPE5;
                                   employment.standard[standardPosition].basis = FinanceOneUtils.employment(e.Employment_Type__c);
                                   employment.standard[standardPosition].occupation = e.Occupation__c;
                                   employment.standard[standardPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                                   employment.standard[standardPosition].employerName = e.Employer_Name__c;
                                   employment.standard[standardPosition].contact = new FinanceOneDTOs.PointOfContact();
                                   employment.standard[standardPosition].contact.name = 'Payroll';
                                   employment.standard[standardPosition].contact.phone = '0233223322';
                                   employment.standard[standardPosition].address = new FinanceOneDTOs.Address();
                                   employment.standard[standardPosition].address.street = FinanceOneEmployment.street(e.Address_Line_1__c, e.Address_Line_2__c);
                                   employment.standard[standardPosition].address.suburb = e.Overseas_City__c;
                                   employment.standard[standardPosition].address.state = 'outside_australia';
                                   employment.standard[standardPosition].address.postcode = e.Postcode__c;
                               }
                               standardPosition++;
                           }
                    }
                    /*
if(selfPosition < selfEmployments){
if(e.Employment_Type__c.equals('Self Employed')){
if('AUS'.equals(e.Country__c)){
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = entity.State__c.toLowercase();
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}else{
employment.previous.self[selfPosition] = new FinanceOneDTOs.PreviousSelfEmployment();
employment.previous.self[selfPosition].duration = durationPE5;
employment.previous.self[selfPosition].entity = new FinanceOneDTOs.Entity();
employment.previous.self[selfPosition].entity.entityType = FinanceOneUtils.entityType(a.Business_Structure__c);
employment.previous.self[selfPosition].entity.tradingName = a.Trading_Name__c;
employment.previous.self[selfPosition].entity.abn = a.Business_ABN__c;
employment.previous.self[selfPosition].entity.address = new FinanceOneDTOs.Address();
employment.previous.self[selfPosition].entity.address.street = entity.Unit_Number__c+'/'+entity.Street_Number__c+' '+a.Trading_Address__c+' '+entity.Street_Type__c;
employment.previous.self[selfPosition].entity.address.suburb = entity.Suburb__c;
employment.previous.self[selfPosition].entity.address.state = 'outside_australia';
employment.previous.self[selfPosition].entity.address.postcode = entity.Postcode__c;
employment.previous.self[selfPosition].entity.predominantBusinessActivity = a.Nature_of_Business__c;
employment.previous.self[selfPosition].occupation = entity.Occupation__c;
employment.previous.self[selfPosition].endDate = e.Finish_Date__c.year()+'-'+e.Finish_Date__c.month()+'-'+e.Finish_Date__c.day();
}
selfPosition++;
}
}
*/
                    if(unemployedPosition < unemployedEmployments){
                        if(e.Employment_Type__c.equals('Unemployed')){
                            employment.unemployed[unemployedPosition] = new FinanceOneDTOs.PreviousUnemployed();
                            employment.unemployed[unemployedPosition].duration = durationPE5;
                            employment.unemployed[unemployedPosition].notes = 'no reason';
                            employment.unemployed[unemployedPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            unemployedPosition++;
                        }
                    }
                    if(benefitPosition < benefitEmployments){
                        if(e.Employment_Type__c.equals('Centrelink - Family Tax Benefits/Other') || e.Employment_Type__c.equals('Centrelink - Newstart only')){
                            employment.benefits[benefitPosition] = new FinanceOneDTOs.PreviousBenefit();
                            employment.benefits[benefitPosition].duration = durationPE5;
                            employment.benefits[benefitPosition].benefitType = FinanceOneUtils.benefit(e.Employment_Type__c);
                            employment.benefits[benefitPosition].endDate = FinanceOneEmployment.endDate2(e.Finish_Date__c);
                            benefitPosition++;
                        }
                    }
                }
            }
        }
        
        return employment;
    }
    
    public static String endDate(String e){
        String[] endDate;
        if(e.contains('/')){
            endDate = e.split('/');
        }
        if(e.contains('-')){
            endDate = e.split('-');
        }
        return endDate[2]+'-'+endDate[1]+'-'+endDate[0];
    }
    
    public static String endDate2(Date e){
        String endDate;
        
        if(e.month()<10 && e.day()<10){
            endDate = e.year()+'-0'+e.month()+'-0'+e.day();
        }else if(e.month()<10){
            endDate = e.year()+'-0'+e.month()+'-'+e.day();
        }else if(e.day()<10){
            endDate = e.year()+'-'+e.month()+'-0'+e.day();
        }else{
            endDate = e.year()+'-'+e.month()+'-'+e.day();
        }
        
        return endDate;
    }
    
    public static String street(String address1, String address2){
        String street;
        
        if(String.isNotBlank(address2)){
            street = address1+' '+address2;
        }else{
            street = address1;
        }
        
        return street;
    }
    
    public static String street2(String unitNumber, String streetNumber, String address, String streetType){
        String street;
        
        if(String.isBlank(unitNumber) && String.isNotBlank(streetNumber) && String.isNotBlank(streetType)){
            street = streetNumber+' '+address+' '+streetType;
        }else if(String.isBlank(unitNumber) && String.isBlank(streetNumber) && String.isNotBlank(streetType)){
            street = address+' '+streetType;
        }else if(String.isBlank(unitNumber) && String.isBlank(streetType) && String.isNotBlank(streetNumber)){
            street = streetNumber+' '+address;
        }else if(String.isBlank(unitNumber) && String.isBlank(streetNumber) && String.isBlank(streetType)){
            street = address;
        }else{
            street = unitNumber+'/'+streetNumber+' '+address+' '+streetType;
        }
        
        return street;
    }
    
    public static String pointOfContactName(String n){
        String name;
        
        if(String.isBlank(n)){
            name = 'Payroll';
        }else{
            name = n;
        }
        
        return name;
    }
    
    public static FinanceOneDTOs.CurrentBenefit[] benefit(Integer employments, Application__c a, Integer applicant){
        List < Application_Income__c > otherIncome = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                      Income__c, Order__c, Type__c
                                                      FROM Application_Income__c WHERE Application__c =: a.Id 
                                                      AND Applicant__c =: String.valueOf(applicant) AND (Type__c = 'Child Support' OR Type__c = 'Family Part A & B' OR Type__c = 'Parenting Payment Partnered' OR Type__c = 'Parenting Payment Single' OR Type__c = 'Rent Assistance' OR Type__c = 'Newstart' OR Type__c = 'Carers Payment') ORDER BY Order__c
                                                     ];
        
        FinanceOneDTOs.CurrentBenefit[] o = new FinanceOneDTOs.CurrentBenefit[otherIncome.size()+employments];
        
        Integer i = employments;
        for (Application_Income__c income: otherIncome) {
            o[i] = new FinanceOneDTOs.CurrentBenefit();
            o[i].duration = 24;
            o[i].benefitType = FinanceOneUtils.benefit(income.Type__c);
            i++;
        }
        
        return o;
    }   
}