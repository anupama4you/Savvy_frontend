public class FinanceOneResidential {
    
    public static FinanceOneDTOs.Residential residentialApp1(Application__c a, Custom_Opportunity__c o){
        List<Application_Servicing__c> listS = [SELECT Is_Splitting_Expenses__c
                                                FROM Application_Servicing__c WHERE Id =: o.ApplicationServicing__c];
        Application_Servicing__c s;
        if(!listS.isEmpty()){
            s = listS.get(0);
        }
        FinanceOneDTOs.Residential residential = new FinanceOneDTOs.Residential();
        
        residential.current = new FinanceOneDTOs.CurrentResidential();
        residential.current.address = new FinanceOneDTOs.Address();
        
        Date dateMovedInCurrentAddress;
        Date todayDate = Date.today();
        Integer durationCurrentAddress;
        Date dateMovedInCRA;
        Date dateMovedInPRA;
        Integer durationPreviousAddress = 0;
        
        residential.current.address.street = FinanceOneResidential.street2(a.Unit_Number__c, a.Street_Number__c, a.Street_Address__c, a.Street_Type__c);
        residential.current.address.suburb = a.Suburb__c;
        residential.current.address.state = a.State__c.toLowercase();
        residential.current.address.postcode = a.Postcode__c;
        
        dateMovedInCurrentAddress = Date.parse(a.Date_Moved_in_1__c);
        durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
        
        residential.current.duration = durationCurrentAddress;
        residential.current.status = FinanceOneUtils.residential(a.Current_Residence_Status_1__c);
        
        if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)') || a.Current_Residence_Status_1__c.equals('Boarding')){
            residential.current.contact = new FinanceOneDTOs.PointOfContact();
            residential.current.contact.name = a.Landlord_Name_1__c;
            residential.current.contact.phone = a.Landlord_Phone_1__c;
            
            if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)')){
                if(s != null){
                    if(s.Is_Splitting_Expenses__c){
                        residential.current.numberOfIndividualsOnLease = 2;    
                    }else{
                        residential.current.numberOfIndividualsOnLease = 1;     
                    }
                }else{
                    residential.current.numberOfIndividualsOnLease = 1; 
                }
            }
        }
        
        FinanceOneResidential.previous(residential, a);
        
        residential.postal = new FinanceOneDTOs.PostalResidential();
        residential.postal.sameAsCurrentAddress = true;
        
        return residential;
        
    }

    public static void previous(FinanceOneDTOs.Residential residential, Application__c a){
        String[] endDate;
        Date dateMovedInCRA;
        Date dateMovedInPRA;
        Integer durationPreviousAddress = 0;

		if(String.isNotBlank(a.Date_From_1__c) || String.isNotBlank(a.Date_From_1b__c) || String.isNotBlank(a.Date_From_1c__c) 
           || String.isNotBlank(a.Date_From_1d__c) || String.isNotBlank(a.Date_From_1e__c)){
               Boolean previousAddress1Position = true;
               Boolean previousAddress2Position = true;
               Boolean previousAddress3Position = true;
               Boolean previousAddress4Position = true;
               Boolean previousAddress5Position = true;
               
               Boolean previousAddress1 = true;
               Boolean previousAddress2 = true;
               Boolean previousAddress3 = true;
               Boolean previousAddress4 = true;
               Boolean previousAddress5 = true;
               
               Integer durationPRA1;
               Integer durationPRA2;
               Integer durationPRA3;
               Integer durationPRA4;
               Integer durationPRA5;
               
               String endDate1;
               String endDate2;
               String endDate3;
               String endDate4;
               String endDate5;
               String dateMovedIn;
               
               if(String.isNotBlank(a.Date_From_1__c) && previousAddress1Position){
                   previousAddress1Position = false;
                   previousAddress1 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_1__c);
                   dateMovedInPRA = Date.parse(a.Date_From_1__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_1__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1b__c) && previousAddress1Position && previousAddress2){
                   previousAddress1Position = false;
                   previousAddress2 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_1__c);
                   dateMovedInPRA = Date.parse(a.Date_From_1b__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_1__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1b__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1c__c) && previousAddress1Position && previousAddress3){
                   previousAddress1Position = false;
                   previousAddress3 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_1__c);
                   dateMovedInPRA = Date.parse(a.Date_From_1c__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   System.debug(durationPRA1);
                   endDate1 = a.Date_Moved_in_1__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1c__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1d__c) && previousAddress1Position && previousAddress4){
                   previousAddress1Position = false;
                   previousAddress4 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_1__c);
                   dateMovedInPRA = Date.parse(a.Date_From_1d__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_1__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1d__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress1Position && previousAddress5){
                   
                   previousAddress5 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_1__c);
                   dateMovedInPRA = Date.parse(a.Date_From_1e__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_1__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1e__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1b__c) && previousAddress2Position && previousAddress2){
                   previousAddress2Position = false;
                   previousAddress2 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1b__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1b__c;
                   
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_1c__c) && previousAddress2Position && previousAddress3){
                   previousAddress2Position = false;
                   previousAddress3 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1c__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1c__c;
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_1d__c) && previousAddress2Position && previousAddress4){
                   previousAddress2Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1d__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1d__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress2Position && previousAddress5){
                   
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1e__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1e__c;
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_1c__c) && previousAddress3Position && previousAddress3){
                   previousAddress3Position = false;
                   previousAddress3 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1c__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1c__c;
               }
               
               if(String.isNotBlank(a.Date_From_1d__c) && previousAddress3Position && previousAddress4){
                   previousAddress3Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1d__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1d__c;
               }
               
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress3Position && previousAddress5){
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1e__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1e__c;
               }
               
               if(String.isNotBlank(a.Date_From_1d__c) && previousAddress4Position && previousAddress4){
                   previousAddress4Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1d__c);
                   durationPRA4 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate4 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1d__c;
               }
               
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress4Position && previousAddress5){
                   previousAddress4Position = false;
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1e__c);
                   durationPRA4 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate4 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_1e__c;
               }
               
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress5Position && previousAddress5){
                   
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_1e__c);
                   durationPRA5 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate5 = dateMovedIn;
                   
                   
               }
               
               durationPreviousAddress += durationPRA1;
               Integer addresses = 1;
               
               if(durationPRA2 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA2;
                       addresses++;  
                   }
               }
               
               if(durationPRA3 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA3;
                       addresses++;  
                   }
               }
               
               if(durationPRA4 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA4;
                       addresses++;  
                   }
               }
               
               if(durationPRA5 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA5;
                       addresses++;  
                   }
               }
               
               residential.previous = new FinanceOneDTOs.PreviousResidential[addresses];
               
               previousAddress1Position = true;
               previousAddress2Position = true;
               previousAddress3Position = true;
               previousAddress4Position = true;
               previousAddress5Position = true;
               
               previousAddress1 = true;
               previousAddress2 = true;
               previousAddress3 = true;
               previousAddress4 = true;
               previousAddress5 = true;
               
               if(String.isNotBlank(a.Date_From_1__c) && previousAddress1Position && previousAddress1){
                   previousAddress1Position = false;
                   previousAddress1 = false;
                   if('AUS'.equals(a.Previous_Country_1__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1__c, a.Previous_Street_Number_1__c, a.Previous_Street_Address_1__c, a.Previous_Street_Type_1__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_1__c;
                       residential.previous[0].address.state = a.Previous_State_1__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_1__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       System.debug(residential.previous[0].endDate);
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_1__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_1__c+' '+a.Previous_Street_Address_2nd_1__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_1__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_1__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_1__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_1b__c) && previousAddress1Position && previousAddress2){
                   previousAddress1Position = false;
                   previousAddress2 = false;				   
                   if('AUS'.equals(a.Previous_Country_1b__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1b__c, a.Previous_Street_Number_1b__c, a.Previous_Street_Address_1b__c, a.Previous_Street_Type_1b__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_1b__c;
                       residential.previous[0].address.state = a.Previous_State_1b__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_1b__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1b__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_1b__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_1b__c+' '+a.Previous_Street_Address_2nd_1b__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_1b__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_1b__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_1b__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1b__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_1c__c) && previousAddress1Position && previousAddress3){
                   previousAddress1Position = false;
                   previousAddress3 = false;					   
                   if('AUS'.equals(a.Previous_Country_1c__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1c__c, a.Previous_Street_Number_1c__c, a.Previous_Street_Address_1c__c, a.Previous_Street_Type_1c__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_1c__c;
                       residential.previous[0].address.state = a.Previous_State_1c__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_1c__c;
                       System.debug(durationPRA1);
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_1c__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_1c__c+' '+a.Previous_Street_Address_2nd_1c__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_1c__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_1c__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_1c__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                   }
               }
               
               if(String.isNotBlank(a.Date_From_1d__c) && previousAddress1Position && previousAddress4){
                   previousAddress1Position = false;
                   previousAddress4 = false;					   
                   if('AUS'.equals(a.Previous_Country_1d__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1d__c, a.Previous_Street_Number_1d__c, a.Previous_Street_Address_1d__c, a.Previous_Street_Type_1d__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_1d__c;
                       residential.previous[0].address.state = a.Previous_State_1d__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_1d__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_1d__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_1d__c+' '+a.Previous_Street_Address_2nd_1d__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_1d__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_1d__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_1d__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                   }
               }
               System.debug(a.Date_From_1e__c);
               System.debug(previousAddress1Position);
               System.debug(previousAddress5);
               if(String.isNotBlank(a.Date_From_1e__c) && previousAddress1Position && previousAddress5){
                   
                   previousAddress5 = false;					   
                   if('AUS'.equals(a.Previous_Country_1e__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1e__c, a.Previous_Street_Number_1e__c, a.Previous_Street_Address_1e__c, a.Previous_Street_Type_1e__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_1e__c;
                       residential.previous[0].address.state = a.Previous_State_1e__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_1e__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_1e__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_1e__c+' '+a.Previous_Street_Address_2nd_1e__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_1e__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_1e__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_1e__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                       }
                       residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                   }
               }
               
               if(addresses >= 2){					   
                   if(String.isNotBlank(a.Date_From_1b__c) && previousAddress2Position && previousAddress2){
                       previousAddress2Position = false;
                       previousAddress2 = false;				   
                       if('AUS'.equals(a.Previous_Country_1b__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1b__c, a.Previous_Street_Number_1b__c, a.Previous_Street_Address_1b__c, a.Previous_Street_Type_1b__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_1b__c;
                           residential.previous[1].address.state = a.Previous_State_1b__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_1b__c;
                           residential.previous[1].duration = durationPRA2;
                           System.debug(a.Previous_Residence_Status_1b__c);
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1b__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1b__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_1b__c+' '+a.Previous_Street_Address_2nd_1b__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_1b__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_1b__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_1b__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1b__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1c__c) && previousAddress2Position && previousAddress3){
                       previousAddress2Position = false;
                       previousAddress3 = false;					   
                       if('AUS'.equals(a.Previous_Country_1c__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1c__c, a.Previous_Street_Number_1c__c, a.Previous_Street_Address_1c__c, a.Previous_Street_Type_1c__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_1c__c;
                           residential.previous[1].address.state = a.Previous_State_1c__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_1c__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1c__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_1c__c+' '+a.Previous_Street_Address_2nd_1c__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_1c__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_1c__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_1c__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1d__c) && previousAddress2Position && previousAddress4){
                       previousAddress2Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_1d__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1d__c, a.Previous_Street_Number_1d__c, a.Previous_Street_Address_1d__c, a.Previous_Street_Type_1d__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_1d__c;
                           residential.previous[1].address.state = a.Previous_State_1d__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1d__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_1d__c+' '+a.Previous_Street_Address_2nd_1d__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_1d__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_1d__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1e__c) && previousAddress2Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_1e__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1e__c, a.Previous_Street_Number_1e__c, a.Previous_Street_Address_1e__c, a.Previous_Street_Type_1e__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_1e__c;
                           residential.previous[1].address.state = a.Previous_State_1e__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1e__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_1e__c+' '+a.Previous_Street_Address_2nd_1e__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_1e__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_1e__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }
               
               if(addresses >= 3){					   
                   if(String.isNotBlank(a.Date_From_1c__c) && previousAddress3Position && previousAddress3){
                       previousAddress3Position = false;
                       previousAddress3 = false;					   
                       if('AUS'.equals(a.Previous_Country_1c__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1c__c, a.Previous_Street_Number_1c__c, a.Previous_Street_Address_1c__c, a.Previous_Street_Type_1c__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_1c__c;
                           residential.previous[2].address.state = a.Previous_State_1c__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_1c__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1c__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_1c__c+' '+a.Previous_Street_Address_2nd_1c__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_1c__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_1c__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_1c__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1c__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1d__c) && previousAddress3Position && previousAddress4){
                       previousAddress3Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_1d__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1d__c, a.Previous_Street_Number_1d__c, a.Previous_Street_Address_1d__c, a.Previous_Street_Type_1d__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_1d__c;
                           residential.previous[2].address.state = a.Previous_State_1d__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1d__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_1d__c+' '+a.Previous_Street_Address_2nd_1d__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_1d__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_1d__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1e__c) && previousAddress3Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_1e__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1e__c, a.Previous_Street_Number_1e__c, a.Previous_Street_Address_1e__c, a.Previous_Street_Type_1e__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_1e__c;
                           residential.previous[2].address.state = a.Previous_State_1e__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1e__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_1e__c+' '+a.Previous_Street_Address_2nd_1e__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_1e__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_1e__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
               }
               
               if(addresses >= 4){					   
                   if(String.isNotBlank(a.Date_From_1d__c) && previousAddress4Position && previousAddress4){
                       previousAddress4Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_1d__c)){
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           residential.previous[3].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1d__c, a.Previous_Street_Number_1d__c, a.Previous_Street_Address_1d__c, a.Previous_Street_Type_1d__c);
                           residential.previous[3].address.suburb = a.Previous_Suburb_1d__c;
                           residential.previous[3].address.state = a.Previous_State_1d__c.toLowercase();
                           residential.previous[3].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1d__c)){
                               residential.previous[3].address.street = a.Previous_Street_Address_1d__c+' '+a.Previous_Street_Address_2nd_1d__c;
                           }else{
                               residential.previous[3].address.street = a.Previous_Street_Address_1d__c;    
                           }
                           residential.previous[3].address.suburb = a.Previous_Overseas_City_1d__c;
                           residential.previous[3].address.state = 'outside_australia';
                           residential.previous[3].address.postcode = a.Previous_Postcode_1d__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1d__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_1e__c) && previousAddress4Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_1e__c)){
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           residential.previous[3].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1e__c, a.Previous_Street_Number_1e__c, a.Previous_Street_Address_1e__c, a.Previous_Street_Type_1e__c);
                           residential.previous[3].address.suburb = a.Previous_Suburb_1e__c;
                           residential.previous[3].address.state = a.Previous_State_1e__c.toLowercase();
                           residential.previous[3].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1e__c)){
                               residential.previous[3].address.street = a.Previous_Street_Address_1e__c+' '+a.Previous_Street_Address_2nd_1e__c;
                           }else{
                               residential.previous[3].address.street = a.Previous_Street_Address_1e__c;    
                           }
                           residential.previous[3].address.suburb = a.Previous_Overseas_City_1e__c;
                           residential.previous[3].address.state = 'outside_australia';
                           residential.previous[3].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }
               
               if(addresses >= 5){					   
                   if(String.isNotBlank(a.Date_From_1e__c) && previousAddress5Position && previousAddress5){
                       previousAddress5Position = false;
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_1e__c)){
                           residential.previous[4] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[4].address = new FinanceOneDTOs.Address();
                           residential.previous[4].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_1e__c, a.Previous_Street_Number_1e__c, a.Previous_Street_Address_1e__c, a.Previous_Street_Type_1e__c);
                           residential.previous[4].address.suburb = a.Previous_Suburb_1e__c;
                           residential.previous[4].address.state = a.Previous_State_1e__c.toLowercase();
                           residential.previous[4].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[4].duration = durationPRA5;
                           residential.previous[4].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate5.contains('/')){
                               endDate = endDate5.split('/');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('-')){
                               endDate = endDate5.split('-');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('.')){
                               endDate = endDate5.split('.');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[4] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[4].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_1e__c)){
                               residential.previous[4].address.street = a.Previous_Street_Address_1e__c+' '+a.Previous_Street_Address_2nd_1e__c;
                           }else{
                               residential.previous[4].address.street = a.Previous_Street_Address_1e__c;    
                           }
                           residential.previous[4].address.suburb = a.Previous_Overseas_City_1e__c;
                           residential.previous[4].address.state = 'outside_australia';
                           residential.previous[4].address.postcode = a.Previous_Postcode_1e__c;
                           residential.previous[4].duration = durationPRA5;
                           residential.previous[4].status = FinanceOneUtils.residential(a.Previous_Residence_Status_1e__c);
                           if(endDate5.contains('/')){
                               endDate = endDate5.split('/');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('-')){
                               endDate = endDate5.split('-');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('.')){
                               endDate = endDate5.split('.');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }					   
           }else{
               residential.previous = new FinanceOneDTOs.PreviousResidential[0];   
           }
	}
    
    public static FinanceOneDTOs.Residential residentialApp2(Application__c a, Custom_Opportunity__c o){
        List<Application_Servicing__c> listS = [SELECT Is_Splitting_Expenses__c
                                                FROM Application_Servicing__c WHERE Id =: o.ApplicationServicing__c];
        Application_Servicing__c s;
        if(!listS.isEmpty()){
            s = listS.get(0);
        }
        FinanceOneDTOs.Residential residential = new FinanceOneDTOs.Residential();
        
        residential.current = new FinanceOneDTOs.CurrentResidential();
        
        Date dateMovedInCurrentAddress;
        String[] endDate;
        Date todayDate = Date.today();
        Integer durationCurrentAddress;
        Date dateMovedInCRA;
        Date dateMovedInPRA;
        Integer durationPreviousAddress = 0;
        
        if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
            residential.current.address = new FinanceOneDTOs.Address();
            residential.current.address.street = FinanceOneResidential.street2(a.Unit_Number_2__c, a.Street_Number_2__c, a.Street_Address_2__c, a.Street_Type_2__c);
            residential.current.address.suburb = a.Suburb_2__c;
            residential.current.address.state = a.State_2__c.toLowercase();
            residential.current.address.postcode = a.Postcode_2__c;
            todayDate = Date.today();
            dateMovedInCurrentAddress = Date.parse(a.Date_Moved_in_2__c);
            durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
            residential.current.duration = durationCurrentAddress;
            residential.current.status = FinanceOneUtils.residential(a.Current_Residence_Status_2__c);
            if(a.Current_Residence_Status_2__c.equals('Renting(Agent)') || a.Current_Residence_Status_2__c.equals('Renting(Private)') || a.Current_Residence_Status_2__c.equals('Boarding')){
                residential.current.contact = new FinanceOneDTOs.PointOfContact();
                residential.current.contact.name = a.Landlord_Name_2__c;
                residential.current.contact.phone = a.Landlord_Phone_2__c;
                
                if(a.Current_Residence_Status_2__c.equals('Renting(Agent)') || a.Current_Residence_Status_2__c.equals('Renting(Private)')){
                    if(s != null){
                        if(s.Is_Splitting_Expenses__c){
                            residential.current.numberOfIndividualsOnLease = 2;    
                        }else{
                            residential.current.numberOfIndividualsOnLease = 1;     
                        }
                    }else{
                        residential.current.numberOfIndividualsOnLease = 1;  
                    }
                }
            }

            if(String.isNotBlank(a.Date_From_2__c) || String.isNotBlank(a.Date_From_2b__c) || String.isNotBlank(a.Date_From_2c__c) 
           || String.isNotBlank(a.Date_From_2d__c) || String.isNotBlank(a.Date_From_2e__c)){
               Boolean previousAddress1Position = true;
               Boolean previousAddress2Position = true;
               Boolean previousAddress3Position = true;
               Boolean previousAddress4Position = true;
               Boolean previousAddress5Position = true;
               
               Boolean previousAddress1 = true;
               Boolean previousAddress2 = true;
               Boolean previousAddress3 = true;
               Boolean previousAddress4 = true;
               Boolean previousAddress5 = true;
               
               Integer durationPRA1;
               Integer durationPRA2;
               Integer durationPRA3;
               Integer durationPRA4;
               Integer durationPRA5;
               
               String endDate1;
               String endDate2;
               String endDate3;
               String endDate4;
               String endDate5;
               String dateMovedIn;
               if(String.isNotBlank(a.Date_From_2__c) && previousAddress1Position){
                   previousAddress1Position = false;
                   previousAddress1 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_2__c);
                   dateMovedInPRA = Date.parse(a.Date_From_2__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_2__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2b__c) && previousAddress1Position && previousAddress2){
                   previousAddress1Position = false;
                   previousAddress2 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_2__c);
                   dateMovedInPRA = Date.parse(a.Date_From_2b__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_2__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2b__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2c__c) && previousAddress1Position && previousAddress3){
                   previousAddress1Position = false;
                   previousAddress3 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_2__c);
                   dateMovedInPRA = Date.parse(a.Date_From_2c__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_2__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2c__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2d__c) && previousAddress1Position && previousAddress4){
                   previousAddress1Position = false;
                   previousAddress4 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_2__c);
                   dateMovedInPRA = Date.parse(a.Date_From_2d__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_2__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2d__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress1Position && previousAddress5){
                   
                   previousAddress5 = false;
                   dateMovedInCRA = Date.parse(a.Date_Moved_in_2__c);
                   dateMovedInPRA = Date.parse(a.Date_From_2e__c);
                   durationPRA1 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate1 = a.Date_Moved_in_2__c;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2e__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2b__c) && previousAddress2Position && previousAddress2){
                   previousAddress2Position = false;
                   previousAddress2 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2b__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2b__c;
                   
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_2c__c) && previousAddress2Position && previousAddress3){
                   previousAddress2Position = false;
                   previousAddress3 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2c__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2c__c;
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_2d__c) && previousAddress2Position && previousAddress4){
                   previousAddress2Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2d__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2d__c;
                   
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress2Position && previousAddress5){
                   
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2e__c);
                   durationPRA2 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate2 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2e__c;
                   
                   
               }
               
               if(String.isNotBlank(a.Date_From_2c__c) && previousAddress3Position && previousAddress3){
                   previousAddress3Position = false;
                   previousAddress3 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2c__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2c__c;
               }
               
               if(String.isNotBlank(a.Date_From_2d__c) && previousAddress3Position && previousAddress4){
                   previousAddress3Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2d__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2d__c;
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress3Position && previousAddress5){
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2e__c);
                   durationPRA3 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate3 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2e__c;
               }
               
               if(String.isNotBlank(a.Date_From_2d__c) && previousAddress4Position && previousAddress4){
                   previousAddress4Position = false;
                   previousAddress4 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2d__c);
                   durationPRA4 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate4 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2d__c;
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress4Position && previousAddress5){
                   previousAddress4Position = false;
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2e__c);
                   durationPRA4 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate4 = dateMovedIn;
                   dateMovedInCRA = dateMovedInPRA;
                   dateMovedIn = a.Date_From_2e__c;
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress5Position && previousAddress5){
                   
                   previousAddress5 = false;
                   
                   dateMovedInPRA = Date.parse(a.Date_From_2e__c);
                   durationPRA5 = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                   endDate5 = dateMovedIn;
                   
                   
               }
               
               durationPreviousAddress += durationPRA1;
               Integer addresses = 1;
               
               if(durationPRA2 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA2;
                       addresses++;  
                   }
               }
               
               if(durationPRA3 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA3;
                       addresses++;  
                   }
               }
               
               if(durationPRA4 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA4;
                       addresses++;  
                   }
               }
               
               if(durationPRA5 != null){
                   if(durationPreviousAddress < 36){
                       durationPreviousAddress += durationPRA5;
                       addresses++;  
                   }
               }
               
               residential.previous = new FinanceOneDTOs.PreviousResidential[addresses];
               
               previousAddress1Position = true;
               previousAddress2Position = true;
               previousAddress3Position = true;
               previousAddress4Position = true;
               previousAddress5Position = true;
               
               previousAddress1 = true;
               previousAddress2 = true;
               previousAddress3 = true;
               previousAddress4 = true;
               previousAddress5 = true;
               
               
               if(String.isNotBlank(a.Date_From_2__c) && previousAddress1Position && previousAddress1){
                   previousAddress1Position = false;
                   previousAddress1 = false;
                   if('AUS'.equals(a.Previous_Country_2__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2__c, a.Previous_Street_Number_2__c, a.Previous_Street_Address_2__c, a.Previous_Street_Type_2__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_2__c;
                       residential.previous[0].address.state = a.Previous_State_2__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_2__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_2__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_2__c+' '+a.Previous_Street_Address_2nd_2__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_2__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_2__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_2__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_2b__c) && previousAddress1Position && previousAddress2){
                   previousAddress1Position = false;
                   previousAddress2 = false;				   
                   if('AUS'.equals(a.Previous_Country_2b__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2b__c, a.Previous_Street_Number_2b__c, a.Previous_Street_Address_2b__c, a.Previous_Street_Type_2b__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_2b__c;
                       residential.previous[0].address.state = a.Previous_State_2b__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_2b__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2b__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_2b__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_2b__c+' '+a.Previous_Street_Address_2nd_2b__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_2b__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_2b__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_2b__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2b__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_2c__c) && previousAddress1Position && previousAddress3){
                   previousAddress1Position = false;
                   previousAddress3 = false;					   
                   if('AUS'.equals(a.Previous_Country_2c__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2c__c, a.Previous_Street_Number_2c__c, a.Previous_Street_Address_2c__c, a.Previous_Street_Type_2c__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_2c__c;
                       residential.previous[0].address.state = a.Previous_State_2c__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_2c__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_2c__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_2c__c+' '+a.Previous_Street_Address_2nd_2c__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_2c__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_2c__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_2c__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_2d__c) && previousAddress1Position && previousAddress4){
                   previousAddress1Position = false;
                   previousAddress4 = false;
                   System.debug(a.Previous_Country_2d__c);
                   if('AUS'.equals(a.Previous_Country_2d__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2d__c, a.Previous_Street_Number_2d__c, a.Previous_Street_Address_2d__c, a.Previous_Street_Type_2d__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_2d__c;
                       residential.previous[0].address.state = a.Previous_State_2d__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_2d__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_2d__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_2d__c+' '+a.Previous_Street_Address_2nd_2d__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_2d__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_2d__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_2d__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }
               }
               
               if(String.isNotBlank(a.Date_From_2e__c) && previousAddress1Position && previousAddress5){
                   
                   previousAddress5 = false;					   
                   if('AUS'.equals(a.Previous_Country_2e__c)){
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       residential.previous[0].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2e__c, a.Previous_Street_Number_2e__c, a.Previous_Street_Address_2e__c, a.Previous_Street_Type_2e__c);
                       residential.previous[0].address.suburb = a.Previous_Suburb_2e__c;
                       residential.previous[0].address.state = a.Previous_State_2e__c.toLowercase();
                       residential.previous[0].address.postcode = a.Previous_Postcode_2e__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }else{
                       residential.previous[0] = new FinanceOneDTOs.PreviousResidential();
                       residential.previous[0].address = new FinanceOneDTOs.Address();
                       if(String.isNotBlank(a.Previous_Street_Address_2nd_2e__c)){
                           residential.previous[0].address.street = a.Previous_Street_Address_2e__c+' '+a.Previous_Street_Address_2nd_2e__c;
                       }else{
                           residential.previous[0].address.street = a.Previous_Street_Address_2e__c;    
                       }
                       residential.previous[0].address.suburb = a.Previous_Overseas_City_2e__c;
                       residential.previous[0].address.state = 'outside_australia';
                       residential.previous[0].address.postcode = a.Previous_Postcode_2e__c;
                       residential.previous[0].duration = durationPRA1;
                       residential.previous[0].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                       if(endDate1.contains('/')){
                           endDate = endDate1.split('/');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('-')){
                           endDate = endDate1.split('-');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                       if(endDate1.contains('.')){
                           endDate = endDate1.split('.');
                           residential.previous[0].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                       }
                   }
               }
               
               if(addresses >= 2){					   
                   if(String.isNotBlank(a.Date_From_2b__c) && previousAddress2Position && previousAddress2){
                       previousAddress2Position = false;
                       previousAddress2 = false;				   
                       if('AUS'.equals(a.Previous_Country_2b__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2b__c, a.Previous_Street_Number_2b__c, a.Previous_Street_Address_2b__c, a.Previous_Street_Type_2b__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_2b__c;
                           residential.previous[1].address.state = a.Previous_State_2b__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_2b__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2b__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2b__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_2b__c+' '+a.Previous_Street_Address_2nd_2b__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_2b__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_2b__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_2b__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2b__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2c__c) && previousAddress2Position && previousAddress3){
                       previousAddress2Position = false;
                       previousAddress3 = false;					   
                       if('AUS'.equals(a.Previous_Country_2c__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2c__c, a.Previous_Street_Number_2c__c, a.Previous_Street_Address_2c__c, a.Previous_Street_Type_2c__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_2c__c;
                           residential.previous[1].address.state = a.Previous_State_2c__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_2c__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2c__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_2c__c+' '+a.Previous_Street_Address_2nd_2c__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_2c__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_2c__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_2c__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2d__c) && previousAddress2Position && previousAddress4){
                       previousAddress2Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_2d__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2d__c, a.Previous_Street_Number_2d__c, a.Previous_Street_Address_2d__c, a.Previous_Street_Type_2d__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_2d__c;
                           residential.previous[1].address.state = a.Previous_State_2d__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2d__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_2d__c+' '+a.Previous_Street_Address_2nd_2d__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_2d__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_2d__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2e__c) && previousAddress2Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_2e__c)){
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           residential.previous[1].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2e__c, a.Previous_Street_Number_2e__c, a.Previous_Street_Address_2e__c, a.Previous_Street_Type_2e__c);
                           residential.previous[1].address.suburb = a.Previous_Suburb_2e__c;
                           residential.previous[1].address.state = a.Previous_State_2e__c.toLowercase();
                           residential.previous[1].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[1] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[1].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2e__c)){
                               residential.previous[1].address.street = a.Previous_Street_Address_2e__c+' '+a.Previous_Street_Address_2nd_2e__c;
                           }else{
                               residential.previous[1].address.street = a.Previous_Street_Address_2e__c;    
                           }
                           residential.previous[1].address.suburb = a.Previous_Overseas_City_2e__c;
                           residential.previous[1].address.state = 'outside_australia';
                           residential.previous[1].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[1].duration = durationPRA2;
                           residential.previous[1].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate2.contains('/')){
                               endDate = endDate2.split('/');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('-')){
                               endDate = endDate2.split('-');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate2.contains('.')){
                               endDate = endDate2.split('.');
                               residential.previous[1].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }
               
               if(addresses >= 3){					   
                   if(String.isNotBlank(a.Date_From_2c__c) && previousAddress3Position && previousAddress3){
                       previousAddress3Position = false;
                       previousAddress3 = false;					   
                       if('AUS'.equals(a.Previous_Country_2c__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2c__c, a.Previous_Street_Number_2c__c, a.Previous_Street_Address_2c__c, a.Previous_Street_Type_2c__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_2c__c;
                           residential.previous[2].address.state = a.Previous_State_2c__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_2c__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2c__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_2c__c+' '+a.Previous_Street_Address_2nd_2c__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_2c__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_2c__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_2c__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2c__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2d__c) && previousAddress3Position && previousAddress4){
                       previousAddress3Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_2d__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2d__c, a.Previous_Street_Number_2d__c, a.Previous_Street_Address_2d__c, a.Previous_Street_Type_2d__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_2d__c;
                           residential.previous[2].address.state = a.Previous_State_2d__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2d__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_2d__c+' '+a.Previous_Street_Address_2nd_2d__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_2d__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_2d__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2e__c) && previousAddress3Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_2e__c)){
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           residential.previous[2].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2e__c, a.Previous_Street_Number_2e__c, a.Previous_Street_Address_2e__c, a.Previous_Street_Type_2e__c);
                           residential.previous[2].address.suburb = a.Previous_Suburb_2e__c;
                           residential.previous[2].address.state = a.Previous_State_2e__c.toLowercase();
                           residential.previous[2].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }else{
                           residential.previous[2] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[2].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2e__c)){
                               residential.previous[2].address.street = a.Previous_Street_Address_2e__c+' '+a.Previous_Street_Address_2nd_2e__c;
                           }else{
                               residential.previous[2].address.street = a.Previous_Street_Address_2e__c;    
                           }
                           residential.previous[2].address.suburb = a.Previous_Overseas_City_2e__c;
                           residential.previous[2].address.state = 'outside_australia';
                           residential.previous[2].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[2].duration = durationPRA3;
                           residential.previous[2].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate3.contains('/')){
                               endDate = endDate3.split('/');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('-')){
                               endDate = endDate3.split('-');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                           if(endDate3.contains('.')){
                               endDate = endDate3.split('.');
                               residential.previous[2].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0]; 
                           }
                       }
                   }
               }
               
               if(addresses >= 4){					   
                   if(String.isNotBlank(a.Date_From_2d__c) && previousAddress4Position && previousAddress4){
                       previousAddress4Position = false;
                       previousAddress4 = false;					   
                       if('AUS'.equals(a.Previous_Country_2d__c)){
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           residential.previous[3].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2d__c, a.Previous_Street_Number_2d__c, a.Previous_Street_Address_2d__c, a.Previous_Street_Type_2d__c);
                           residential.previous[3].address.suburb = a.Previous_Suburb_2d__c;
                           residential.previous[3].address.state = a.Previous_State_2d__c.toLowercase();
                           residential.previous[3].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2d__c)){
                               residential.previous[3].address.street = a.Previous_Street_Address_2d__c+' '+a.Previous_Street_Address_2nd_2d__c;
                           }else{
                               residential.previous[3].address.street = a.Previous_Street_Address_2d__c;    
                           }
                           residential.previous[3].address.suburb = a.Previous_Overseas_City_2d__c;
                           residential.previous[3].address.state = 'outside_australia';
                           residential.previous[3].address.postcode = a.Previous_Postcode_2d__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2d__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
                   
                   if(String.isNotBlank(a.Date_From_2e__c) && previousAddress4Position && previousAddress5){
                       
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_2e__c)){
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           residential.previous[3].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2e__c, a.Previous_Street_Number_2e__c, a.Previous_Street_Address_2e__c, a.Previous_Street_Type_2e__c);
                           residential.previous[3].address.suburb = a.Previous_Suburb_2e__c;
                           residential.previous[3].address.state = a.Previous_State_2e__c.toLowercase();
                           residential.previous[3].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[3] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[3].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2e__c)){
                               residential.previous[3].address.street = a.Previous_Street_Address_2e__c+' '+a.Previous_Street_Address_2nd_2e__c;
                           }else{
                               residential.previous[3].address.street = a.Previous_Street_Address_2e__c;    
                           }
                           residential.previous[3].address.suburb = a.Previous_Overseas_City_2e__c;
                           residential.previous[3].address.state = 'outside_australia';
                           residential.previous[3].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[3].duration = durationPRA4;
                           residential.previous[3].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate4.contains('/')){
                               endDate = endDate4.split('/');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('-')){
                               endDate = endDate4.split('-');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate4.contains('.')){
                               endDate = endDate4.split('.');
                               residential.previous[3].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }
               
               if(addresses >= 5){					   
                   if(String.isNotBlank(a.Date_From_2e__c) && previousAddress5Position && previousAddress5){
                       previousAddress5Position = false;
                       previousAddress5 = false;					   
                       if('AUS'.equals(a.Previous_Country_2e__c)){
                           residential.previous[4] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[4].address = new FinanceOneDTOs.Address();
                           residential.previous[4].address.street = FinanceOneResidential.street2(a.Previous_Unit_Number_2e__c, a.Previous_Street_Number_2e__c, a.Previous_Street_Address_2e__c, a.Previous_Street_Type_2e__c);
                           residential.previous[4].address.suburb = a.Previous_Suburb_2e__c;
                           residential.previous[4].address.state = a.Previous_State_2e__c.toLowercase();
                           residential.previous[4].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[4].duration = durationPRA5;
                           residential.previous[4].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate5.contains('/')){
                               endDate = endDate5.split('/');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('-')){
                               endDate = endDate5.split('-');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('.')){
                               endDate = endDate5.split('.');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }else{
                           residential.previous[4] = new FinanceOneDTOs.PreviousResidential();
                           residential.previous[4].address = new FinanceOneDTOs.Address();
                           if(String.isNotBlank(a.Previous_Street_Address_2nd_2e__c)){
                               residential.previous[4].address.street = a.Previous_Street_Address_2e__c+' '+a.Previous_Street_Address_2nd_2e__c;
                           }else{
                               residential.previous[4].address.street = a.Previous_Street_Address_2e__c;    
                           }
                           residential.previous[4].address.suburb = a.Previous_Overseas_City_2e__c;
                           residential.previous[4].address.state = 'outside_australia';
                           residential.previous[4].address.postcode = a.Previous_Postcode_2e__c;
                           residential.previous[4].duration = durationPRA5;
                           residential.previous[4].status = FinanceOneUtils.residential(a.Previous_Residence_Status_2e__c);
                           if(endDate5.contains('/')){
                               endDate = endDate5.split('/');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('-')){
                               endDate = endDate5.split('-');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                           if(endDate5.contains('.')){
                               endDate = endDate5.split('.');
                               residential.previous[4].endDate = endDate[2]+'-'+endDate[1]+'-'+endDate[0];
                           }
                       }
                   }
               }					   
           }else{
               residential.previous = new FinanceOneDTOs.PreviousResidential[0];   
           }
        }else{
            residential.current.address = new FinanceOneDTOs.Address();
            residential.current.address.street = FinanceOneResidential.street2(a.Unit_Number__c, a.Street_Number__c, a.Street_Address__c, a.Street_Type__c);
            residential.current.address.suburb = a.Suburb__c;
            residential.current.address.state = a.State__c.toLowercase();
            residential.current.address.postcode = a.Postcode__c;
            todayDate = Date.today();
            dateMovedInCurrentAddress = Date.parse(a.Date_Moved_in_1__c);
            durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
            residential.current.duration = durationCurrentAddress;
            residential.current.status = FinanceOneUtils.residential(a.Current_Residence_Status_1__c);
            if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)') || a.Current_Residence_Status_1__c.equals('Boarding')){
                residential.current.contact = new FinanceOneDTOs.PointOfContact();
                residential.current.contact.name = a.Landlord_Name_1__c;
                residential.current.contact.phone = a.Landlord_Phone_1__c;
                
                if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)')){
                    if(s != null){
                        if(s.Is_Splitting_Expenses__c){
                            residential.current.numberOfIndividualsOnLease = 2;    
                        }else{
                            residential.current.numberOfIndividualsOnLease = 1;     
                        }
                    }else{
                        residential.current.numberOfIndividualsOnLease = 1;  
                    }
                }
            }
            FinanceOneResidential.previous(residential, a);
        }
        
        residential.postal = new FinanceOneDTOs.PostalResidential();
        residential.postal.sameAsCurrentAddress = true;
        
        return residential;
        
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
    
}