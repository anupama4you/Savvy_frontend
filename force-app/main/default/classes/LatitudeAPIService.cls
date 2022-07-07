public class LatitudeAPIService extends APIServiceManager {

  public static final String PARAM_ENDPOINT1 = 'Latitude_Endpoint1';
  public static final String PARAM_ENDPOINT2 = 'Latitude_Endpoint2';
  public static final String PARAM_CLIENTID = 'Latitude_Client_ID';
  public static final String PARAM_CLIENTSECRET = 'Latitude_Client_Secret';
  
  private static String endpoint1Param = null;
  private static String endpoint2Param = null;
  private static String clientIdParam = null;
  private static String secrectParam = null;
  
    private Map<String, List<Application_Income__c>> otherIncomeMap;
    //public List<YTD_Income__c> listYTD {get;set;}
  private Map < String, List < Application_Employment__c >> previousEmp;  
    public static String getName(String oppName, String applicationId, Integer status){
      String name;
      
      if(status == 201){
        name = (oppName.length() > 71) ? oppName.substring(0,71) : oppName;
        name += ' ['+applicationId+']';
      }else{
        Datetime t = Datetime.now();
        name = oppName+' ['+status+'-'+t.getTime()+']';
      }
      return name;
    }
    
    public Boolean submitRequest(Application__c a, Custom_Opportunity__c opp, Application_Quoting__c appQuoting){
        Boolean sr = true;
        /*
        listYTD = [Select Annualised_Income__c, Applicant_Type__c, Type__c From YTD_Income__c Where Opportunity__c = :opp.Id];
        
        for (YTD_Income__c y: listYTD) {
            if('Applicant 1'.equals(y.Applicant_Type__c) && !'Others'.equals(y.Type__c) && !'Self-Employed'.equals(y.Type__c)){
                this.addErrorMessage('YTD calculation type should be Others or Self-Employed, current value: ' + y.Type__c));
                sr = false;
                break;
            }
        }
        */
        Set<String> vehicleType = new Set<String>();
        vehicleType.add('CAR');
        vehicleType.add('VAN_LIGHT_COMMERCIAL');
        vehicleType.add('MINIBUS');
        vehicleType.add('UTILITY');
        vehicleType.add('STATION_WAGON_OR_4WD');
        vehicleType.add('BOAT');
        vehicleType.add('CARAVAN');
        vehicleType.add('MOTORHOME');
        vehicleType.add('TRAILER');
        
        if(!vehicleType.contains(appQuoting.Goods_type__c)){
            this.addErrorMessage('Vehicle type invalid to be sent to the Latitude API service');
            sr = false;
        }
        
        if(String.isBlank(a.Gender_1__c)){
            this.addErrorMessage('Applicant 1: Please select gender');
            sr = false;
        }
        
        if(a.Current_Residence_Status_1__c.equals('Renting(Agent)') || a.Current_Residence_Status_1__c.equals('Renting(Private)') || a.Current_Residence_Status_1__c.equals('Boarding')){
            if(String.isBlank(a.Residential_Payment_Frequency_1__c)){
                this.addErrorMessage('Applicant 1: Please select Payment Frequency in LANDLORD / MORTGAGE DETAILS');
                sr = false;
            }
        }
        
        if(a.Do_you_have_drivers_licence_1__c.equals('Yes')){
            if(!FieldValidationsHelper.isDateFormatValid(a.Expiry_Date_1__c)){
                this.addErrorMessage('Applicant 1: Please fill in Expiry Date (dd/mm/yyyy)');
                sr = false;
            }
        }
        
        if(!FieldValidationsHelper.isDateFormatValid(a.Date_Moved_in_1__c)){
            this.addErrorMessage('Applicant 1 Current Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
            sr = false;
        }
        
        if(!FieldValidationsHelper.isDateFormatValid(a.Date_Started_1__c)){
            this.addErrorMessage('Applicant 1 EMPLOYMENT & INCOME: Please fill in Start Date (dd/mm/yyyy)');
            sr = false;
        }
        
        if (a.Previous_Country_1__c != null && 
            (String.isNotBlank(a.Date_From_1__c) 
             || String.isNotBlank(a.Previous_Street_Address_1__c)
             || String.isNotBlank(a.Previous_Residence_Status_1__c))) {
                 if(String.isBlank(a.Date_From_1__c)){
                     this.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1__c)){
                         this.addErrorMessage('Applicant 1 - 1) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
             }
        
        if (a.Previous_Country_1b__c != null && 
            (String.isNotBlank(a.Date_From_1b__c) 
             || String.isNotBlank(a.Previous_Street_Address_1b__c)
             || String.isNotBlank(a.Previous_Residence_Status_1b__c))) {
                 if(String.isBlank(a.Date_From_1b__c)){
                     this.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1b__c)){
                         this.addErrorMessage('Applicant 1 - 2) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
             }
        
        if (a.Previous_Country_1c__c != null && 
            (String.isNotBlank(a.Date_From_1c__c) 
             || String.isNotBlank(a.Previous_Street_Address_1c__c)
             || String.isNotBlank(a.Previous_Residence_Status_1c__c))) {
                 if(String.isBlank(a.Date_From_1c__c)){
                     this.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1c__c)){
                         this.addErrorMessage('Applicant 1 - 3) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
             }
        
        if (a.Previous_Country_1d__c != null && 
            (String.isNotBlank(a.Date_From_1d__c) 
             || String.isNotBlank(a.Previous_Street_Address_1d__c)
             || String.isNotBlank(a.Previous_Residence_Status_1d__c))) {
                 if(String.isBlank(a.Date_From_1d__c)){
                     this.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1d__c)){
                         this.addErrorMessage('Applicant 1 - 4) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
             }
        
        if (a.Previous_Country_1e__c != null && 
            (String.isNotBlank(a.Date_From_1e__c) 
             || String.isNotBlank(a.Previous_Street_Address_1e__c)
             || String.isNotBlank(a.Previous_Residence_Status_1e__c))) {
                 if(String.isBlank(a.Date_From_1e__c)){
                     this.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please enter Date Moved In');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_1e__c)){
                         this.addErrorMessage('Applicant 1 - 5) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
             }
        
        if (a.Previous_Work_Country_1__c != null && 
            (String.isNotBlank(a.Start_Date_1__c)
             || String.isNotBlank(a.Finish_Date_1__c)
             || String.isNotBlank(a.Previous_Work_Address_1__c)
             || String.isNotBlank(a.Previous_Mode_of_Employment_1__c))) {
                 if(String.isBlank(a.Start_Date_1__c)){
                     this.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Start Date');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Start_Date_1__c)){
                         this.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in Start Date (dd/mm/yyyy)');
                         sr = false;
                     }
                 }
                 
                 if(String.isBlank(a.Finish_Date_1__c)){
                     this.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Finish Date');
                     sr = false;
                 }else{
                     if(!FieldValidationsHelper.isDateFormatValid(a.Finish_Date_1__c)){
                         this.addErrorMessage('Applicant 1 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in	Finish Date (dd/mm/yyyy)');
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
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Previous Job'];
        Integer previousEmployment = 2;
        for (Application_Employment__c emp: lst) {
            if('1'.equals(emp.Applicant__c)){
                if(emp.Finish_Date__c == null){
                    this.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Finish Date');
                    sr = false;
                    
                }
                
                if(emp.Start_Date__c == null){
                    this.addErrorMessage('Applicant 1 - '+previousEmployment+') Previous Employment: Please enter Start Date');
                    sr = false;
                    
                }
                previousEmployment++;
            }
        }
        
        List<Application_Employment__c> e = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job'];	
        Boolean applicant1 = true;
        for (Application_Employment__c emp: e) {
            if('1'.equals(emp.Applicant__c)){
                applicant1 = false;
                if(otherIncomeSecondJob(1)){
                    this.addErrorMessage('Applicant 1: Remove second job in Other Income');
                    sr = false;
                }
            }
        }
        
        if(applicant1 && otherIncomeSecondJob(1)){
            this.addErrorMessage('Applicant 1: Please add details of second job and remove second job in Other Income');
            sr = false;
        }
        
        List < Application_Income__c > otherIncome = new List < Application_Income__c >();
        List < Application_Income__c > otherIncome2 = new List < Application_Income__c >();														 
        
        if(otherIncomeMap != null){
            otherIncome = getOtherIncomes(otherIncomeMap.get('1'), otherIncome);
            otherIncome2 = getOtherIncomes(otherIncomeMap.get('2'), otherIncome2);
        }
        
        if(!otherIncome.isEmpty() || 'Own Outright'.equals(a.Current_Residence_Status_1__c) || 'Mortgage'.equals(a.Current_Residence_Status_1__c) || (a.No_of_People__c == 2 && (!otherIncome2.isEmpty() || ('No'.equals(a.Applicant_2_living_in_the_same_address__c) && ('Own Outright'.equals(a.Current_Residence_Status_2__c) || 'Mortgage'.equals(a.Current_Residence_Status_2__c)))))){
            List<Application_Other_Asset__c> properties= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                          Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                                                          FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = 'Property Asset'];
            if(!properties.isEmpty()){
                List<Application_Other_Asset__c> property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                            Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                                                            FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = 'Property Asset' AND (Category__c = null OR Category__c = '')];
                if(!property.isEmpty()){
                    this.addErrorMessage('PROPERTY (Address): Please select category');
                    sr = false;
                }else{
                    Boolean currentAddress = true;
                    property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                               Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                               FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Current Address Applicant 1' OR Category__c = 'Current Address Both Applicants')];
                    if('Own Outright'.equals(a.Current_Residence_Status_1__c) || 'Mortgage'.equals(a.Current_Residence_Status_1__c)){
                        
                        if(property.isEmpty()){
                            this.addErrorMessage('PROPERTY (Address): Please check the category of current address or add current address');
                            sr = false;
                            currentAddress = false;
                        }else{
                            Application_Other_Asset__c o = property.get(0);
                            if('Current Address Both Applicants'.equals(o.Category__c)){
                                if(a.No_of_People__c == 1){
                                    this.addErrorMessage('PROPERTY (Address): Check category');
                                    sr = false;
                                    currentAddress = false;
                                }
                                
                                if(a.No_of_People__c == 2){
                                    if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
                                        if(!a.Current_Residence_Status_2__c.equals(a.Current_Residence_Status_1__c)){
                                            this.addErrorMessage('PROPERTY (Address): Check category');
                                            sr = false;
                                        }
                                    }
                                }							
                            }
                        }
                    }
                    
                    if(!'Own Outright'.equals(a.Current_Residence_Status_1__c) && !'Mortgage'.equals(a.Current_Residence_Status_1__c)){
                        if(!property.isEmpty()){
                            this.addErrorMessage('PROPERTY (Address): Check properties');
                            sr = false;
                            currentAddress = false;
                        }
                    }
                    
                    if(currentAddress){
                        otherIncome = new List < Application_Income__c >();
                        
                        otherIncome = getOtherIncomes2(otherIncomeMap.get('1'), otherIncome);
                        if(!otherIncome.isEmpty()){
                            this.addErrorMessage('Applicant 1 Other Income: Please select property');
                            sr = false;
                        }else{
                            otherIncome = otherIncomeMap.get('1');
                            
                            otherIncome2 = otherIncomeMap.get('2');
                            
                            Boolean category;
                            if(otherIncome != null){
                                for (Application_Income__c income: otherIncome) {
                                    if(String.isNotBlank(income.Application_Other_Asset__c) && ('Investment Property'.equals(income.Type__c) || 'Rental Income'.equals(income.Type__c))){
                                        category = false;
                                        for (Application_Other_Asset__c p : properties) {
                                            if(income.Application_Other_Asset__c.equals(p.Id)){
                                                if('Current Address Applicant 1'.equals(p.Category__c) || 'Current Address Both Applicants'.equals(p.Category__c) || 'Current Address Applicant 2'.equals(p.Category__c) || 'Property Applicant 2'.equals(p.Category__c)){
                                                    this.addErrorMessage('PROPERTY (Address): Check category');
                                                    sr = false;
                                                    break;
                                                }else if('Property Both Applicants'.equals(p.Category__c)){
                                                    
                                                    Boolean checkCategory = false;
                                                    
                                                    if(otherIncome2 != null){
                                                        for (Application_Income__c i: otherIncome2) {
                                                            if(String.isNotBlank(i.Application_Other_Asset__c) && ('Investment Property'.equals(i.Type__c) || 'Rental Income'.equals(i.Type__c))){
                                                                checkCategory = true;
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    
                                                    if(!checkCategory){
                                                        this.addErrorMessage('PROPERTY (Address): Check category');
                                                        sr = false;
                                                        break;
                                                    }else{
                                                        
                                                        for (Application_Income__c income2: otherIncome2) {
                                                            if(String.isNotBlank(income2.Application_Other_Asset__c) && ('Investment Property'.equals(income2.Type__c) || 'Rental Income'.equals(income2.Type__c))){
                                                                if(income2.Application_Other_Asset__c.equals(p.Id)){
                                                                    category = true;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        
                                                        if(!category){
                                                            this.addErrorMessage('PROPERTY (Address): Check category');
                                                            sr = false;
                                                        }
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if(a.No_of_People__c == 2){
                        
                        Boolean currentAddress2 = true;
                        property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                   Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                                   FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Current Address Applicant 2' OR Category__c = 'Current Address Both Applicants')];
                        if(property.isEmpty()){
                            this.addErrorMessage('PROPERTY (Address): Please check the category of current address or add current address');
                            sr = false;
                            currentAddress2 = false;
                        }
                        if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
                            if('Own Outright'.equals(a.Current_Residence_Status_2__c) || 'Mortgage'.equals(a.Current_Residence_Status_2__c)){
                                
                                if(!property.isEmpty()){
                                    Application_Other_Asset__c o = property.get(0);
                                    if('Current Address Both Applicants'.equals(o.Category__c)){
                                        if(!a.Current_Residence_Status_2__c.equals(a.Current_Residence_Status_1__c)){
                                            this.addErrorMessage('PROPERTY (Address): Check category');
                                            sr = false;
                                        }
                                    }							
                                }		
                            }
                            
                            if(!'Own Outright'.equals(a.Current_Residence_Status_2__c) && !'Mortgage'.equals(a.Current_Residence_Status_2__c)){
                                if(!property.isEmpty()){
                                    this.addErrorMessage('PROPERTY (Address): Check properties');
                                    sr = false;
                                    currentAddress2 = false;
                                }
                            }
                        }
                        
                        if(currentAddress2){
                            otherIncome = new List < Application_Income__c >();
                            
                            otherIncome = getOtherIncomes2(otherIncomeMap.get('2'), otherIncome);
                            
                            if(!otherIncome.isEmpty()){
                                this.addErrorMessage('Applicant 2 Other Income: Please select property');
                                sr = false;
                            }else{
                                otherIncome = otherIncomeMap.get('2');
                                
                                otherIncome2 = otherIncomeMap.get('1');
                                
                                Boolean category;
                                if(otherIncome != null){
                                    for (Application_Income__c income: otherIncome) {
                                        if(String.isNotBlank(income.Application_Other_Asset__c) && ('Investment Property'.equals(income.Type__c) || 'Rental Income'.equals(income.Type__c))){ 
                                            category = false;
                                            for (Application_Other_Asset__c p : properties) {
                                                if(income.Application_Other_Asset__c.equals(p.Id)){
                                                    if('Current Address Applicant 1'.equals(p.Category__c) || 'Current Address Both Applicants'.equals(p.Category__c) || 'Current Address Applicant 2'.equals(p.Category__c) || 'Property Applicant 1'.equals(p.Category__c)){
                                                        this.addErrorMessage('PROPERTY (Address): Check category');
                                                        sr = false;
                                                        break;
                                                    }else if('Property Both Applicants'.equals(p.Category__c)){
                                                        
                                                        Boolean checkCategory = false;
                                                        if(otherIncome2 != null){
                                                            for (Application_Income__c i: otherIncome2) {
                                                                if(String.isNotBlank(i.Application_Other_Asset__c) && ('Investment Property'.equals(i.Type__c) || 'Rental Income'.equals(i.Type__c))){
                                                                    checkCategory = true;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        
                                                        if(!checkCategory){
                                                            this.addErrorMessage('PROPERTY (Address): Check category');
                                                            sr = false;
                                                            break;
                                                        }else{
                                                            
                                                            for (Application_Income__c income2: otherIncome2) {
                                                                if(String.isNotBlank(income2.Application_Other_Asset__c) && ('Investment Property'.equals(income2.Type__c) || 'Rental Income'.equals(income2.Type__c))){
                                                                    if(income2.Application_Other_Asset__c.equals(p.Id)){
                                                                        category = true;
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                            
                                                            if(!category){
                                                                this.addErrorMessage('PROPERTY (Address): Check category');
                                                                sr = false;
                                                            }
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                this.addErrorMessage('PROPERTY (Address): Check properties');
                sr = false;
            }
        }else{
            List<Application_Other_Asset__c> property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                        Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                                                        FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = 'Property Asset'];
            
            if(!property.isEmpty()){
                this.addErrorMessage('PROPERTY (Address): Check properties');
                sr = false;
            }
        }
        
        if(a.No_of_People__c == 2){
            if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
                if(a.Current_Residence_Status_2__c.equals('Renting(Agent)') || a.Current_Residence_Status_2__c.equals('Renting(Private)') || a.Current_Residence_Status_2__c.equals('Boarding')){
                    if(String.isBlank(a.Residential_Payment_Frequency_2__c)){
                        this.addErrorMessage('Applicant 2: Please select Payment Frequency in LANDLORD / MORTGAGE DETAILS');
                        sr = false;
                    }
                }
            }
            
            if(String.isBlank(a.Gender_2__c)){
                this.addErrorMessage('Applicant 2: Please select gender');
                sr = false;
            }
            
            if(a.Do_you_have_drivers_licence_2__c.equals('Yes')){
                if(!FieldValidationsHelper.isDateFormatValid(a.Expiry_Date_2__c)){
                    this.addErrorMessage('Applicant 2: Please fill in Expiry Date (dd/mm/yyyy)');
                    sr = false;
                }
            }
            
            if(!FieldValidationsHelper.isDateFormatValid(a.Date_Moved_in_2__c)){
                this.addErrorMessage('Applicant 2 Current Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                sr = false;
            }
            
            if(!FieldValidationsHelper.isDateFormatValid(a.Date_Started_2__c)){
                this.addErrorMessage('Applicant 2 EMPLOYMENT & INCOME: Please fill in Start Date (dd/mm/yyyy)');
                sr = false;
            }
            
            if (a.Previous_Country_2__c != null && 
                (String.isNotBlank(a.Date_From_2__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2__c))) {
                     if(String.isBlank(a.Date_From_2__c)){
                         this.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2__c)){
                             this.addErrorMessage('Applicant 2 - 1) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            if (a.Previous_Country_2b__c != null && 
                (String.isNotBlank(a.Date_From_2b__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2b__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2b__c))) {
                     if(String.isBlank(a.Date_From_2b__c)){
                         this.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2b__c)){
                             this.addErrorMessage('Applicant 2 - 2) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            if (a.Previous_Country_2c__c != null && 
                (String.isNotBlank(a.Date_From_2c__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2c__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2c__c))) {
                     if(String.isBlank(a.Date_From_2c__c)){
                         this.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2c__c)){
                             this.addErrorMessage('Applicant 2 - 3) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            if (a.Previous_Country_2d__c != null && 
                (String.isNotBlank(a.Date_From_2d__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2d__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2d__c))) {
                     if(String.isBlank(a.Date_From_2d__c)){
                         this.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2d__c)){
                             this.addErrorMessage('Applicant 2 - 4) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            if (a.Previous_Country_2e__c != null && 
                (String.isNotBlank(a.Date_From_2e__c) 
                 || String.isNotBlank(a.Previous_Street_Address_2e__c)
                 || String.isNotBlank(a.Previous_Residence_Status_2e__c))) {
                     if(String.isBlank(a.Date_From_2e__c)){
                         this.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please enter Date Moved In');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Date_From_2e__c)){
                             this.addErrorMessage('Applicant 2 - 5) Previous Residential Address: Please fill in Date Moved In (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            if (a.Previous_Work_Country_2__c != null && 
                (String.isNotBlank(a.Start_Date_2__c)
                 || String.isNotBlank(a.Finish_Date_2__c)
                 || String.isNotBlank(a.Previous_Work_Address_2__c)
                 || String.isNotBlank(a.Previous_Mode_of_Employment_2__c))) {
                     if(String.isBlank(a.Start_Date_2__c)){
                         this.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Start Date');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Start_Date_2__c)){
                             this.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in Start Date (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                     
                     if(String.isBlank(a.Finish_Date_2__c)){
                         this.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please enter Finish Date');
                         sr = false;
                     }else{
                         if(!FieldValidationsHelper.isDateFormatValid(a.Finish_Date_2__c)){
                             this.addErrorMessage('Applicant 2 PREVIOUS EMPLOYMENT (If current employment is less than 3 years): Please fill in	Finish Date (dd/mm/yyyy)');
                             sr = false;
                         }
                     }
                 }
            
            previousEmployment = 2;
            for (Application_Employment__c emp: lst) {
                if('2'.equals(emp.Applicant__c)){
                    if(emp.Finish_Date__c == null){
                        this.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Finish Date');
                        sr = false;
                        
                    }
                    
                    if(emp.Start_Date__c == null){
                        this.addErrorMessage('Applicant 2 - '+previousEmployment+') Previous Employment: Please enter Start Date');
                        sr = false;
                        
                    }
                    previousEmployment++;
                }
            }
            Boolean applicant2 = true;            
            for (Application_Employment__c emp: e) {
                if('2'.equals(emp.Applicant__c)){
                    applicant2 = false;
                    if(otherIncomeSecondJob(2)){
                        this.addErrorMessage('Applicant 2: Remove second job in Other Income');
                        sr = false;
                    }
                }
            }
            
            if(applicant2 && otherIncomeSecondJob(2)){
                this.addErrorMessage('Applicant 2: Please add details of second job and remove second job in Other Income');
                sr = false;
            }
        }
        return sr;
    }
    
    public LenderAPIResponse__c requestApplication(Custom_Opportunity__c opp, String apiUser) {
        LenderAPIResponse__c latitudeApp = null;
        loadAPIParameters();
        String NVIC;
		    // System.debug(opp.Application_AssetDetail__r.Variant__c);	
        if(opp.Application_AssetDetail__r.Variant__c != null){
          List<Glass_Variant__c> listG = [SELECT NVIC__c FROM Glass_Variant__c WHERE Code__c =: opp.Application_AssetDetail__r.Variant__c];
          if(!listG.isEmpty()){
            NVIC = listG.get(0).NVIC__c;
          }
        }
		
		    String endPoint;
        LatitudeAPIRequestDTO.Application app;
        LatitudeAPIRequestDTO.Preapproval app2;

        if(opp.Application_AssetDetail__c != null && NVIC != null){
              endPoint = '/broker/application';
              app = getLatitudeApplication(opp, apiUser, NVIC);
        }else{
              endPoint = '/broker/application/pre-approval';    
          app2 = getLatitudePreApproval(opp, apiUser);
        }
        
        if(app != null || app2 != null){
            String body;
            if(app != null){
              body = JSON.serialize(app);
            }else{
              body = JSON.serialize(app2);
            }
            body = body.replace('r_number', 'number');
            System.debug(body);
            String generatedToken;
            HttpRequest objReq = new HttpRequest();
            objReq.setEndpoint(endpoint1Param + '/oauth2/token');
            objReq.setMethod('POST');
            objReq.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientIdParam + ':' + secrectParam)));
            objReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            objReq.setBody('grant_type=client_credentials'); 
            objReq.setTimeout(60000);
            Http objHttp = new Http();
            HTTPResponse objRes;
            try{
                objRes = objHttp.send(objReq);
                System.debug(objRes);
                System.debug(objRes.getBody());
                JSONParser objParse = JSON.createParser(objRes.getBody());
                while (objParse.nextToken() != null) 
                {
                    if (objParse.getCurrentToken() == JSONToken.FIELD_NAME && objParse.getText() == 'access_token')
                    {
                        objParse.nextToken();
                        generatedToken = objParse.getText();
                    }
                }
                
                objReq = new HttpRequest();
                objReq.setEndpoint(endpoint2Param + endPoint);
                objReq.setMethod('POST');
                objReq.setHeader('Authorization', 'Bearer ' + generatedToken);
                objReq.setHeader('Content-Type', 'application/json');
                objReq.setBody(body);
                objHttp = new Http();
                objRes = objHttp.send(objReq);
                System.debug(objRes);
                LatitudeAPIResponseDTO r = (LatitudeAPIResponseDTO)JSON.deserialize(objRes.getBody(), LatitudeAPIResponseDTO.class);
                latitudeApp = new LenderAPIResponse__c();
                if(r.applicationId != null){
                    latitudeApp.Name = FinanceOneServices.getName(opp.Name, r.applicationId, objRes.getStatusCode());
                    latitudeApp.Application_ID__c = r.applicationId;
                    this.addConfirmMessage('Application ID: '+r.applicationId);
                    
                }else{
                    latitudeApp.Name = FinanceOneServices.getName(opp.Name, null, objRes.getStatusCode());
                    latitudeApp.Message__c = r.message;
                    if(objRes.getStatusCode() == 422){
                        for (LatitudeAPIResponseDTO.Error e: r.errors) {
                            this.addErrorMessage('Field: '+e.field+' Reason: '+e.reason);
                        }
                    }
                    this.addErrorMessage('Message: '+r.message);
                }
                
                latitudeApp.Opportunity__c = opp.Id;
                latitudeApp.Status__c = objRes.getStatusCode();
                latitudeApp.Request__c = body;
                latitudeApp.Response__c = objRes.getBody();
                latitudeApp.Provider__c = 'Latitude';
                if(app != null){
                  latitudeApp.Service__c = 'application';
                }else{
                  latitudeApp.Service__c = 'application/pre-approval';    
                }
                latitudeApp.Quoting_Source__c = LatitudeCalculatorExtension.LENDER_QUOTING;

                if (String.isNotBlank(latitudeApp.Request__c) && latitudeApp.Request__c.length() > 131072) {
                  latitudeApp.Request__c = latitudeApp.Request__c.substring(0,131072);
                }
                if (String.isNotBlank(latitudeApp.Response__c) && latitudeApp.Response__c.length() > 131072) {
                  latitudeApp.Response__c = latitudeApp.Response__c.substring(0,131072);
                }
                
                insert latitudeApp; 
            }catch(Exception e){
                this.addErrorMessage(e.getMessage());
            }
        }
        return latitudeApp;
    }
    
    public LatitudeAPIRequestDTO.Application getLatitudeApplication(Custom_Opportunity__c opp, String apiUser, String NVIC) {
        
        LatitudeAPIRequestDTO.Application request;
        
        Application_Quoting__c appQuoting = QuotingToolHelper.getApplicationQuoting(opp.Id, opp.Application__c);
        
        if (appQuoting == null){
            throw new GenericException ('Please make sure calculate before send to Money3 API.');
        }
        Custom_Opportunity__c o = APIServiceManager.getCustomOpportunityForApplication(opp);
        Application__c app = o.Application__r;
        LatitudeAPIService api = new LatitudeAPIService();
        otherIncomeMap = api.getAppIncomes(app.Id);
        if(submitRequest(app, o, appQuoting)){
            request = new LatitudeAPIRequestDTO.Application();
            
            request.applicants = new LatitudeAPIRequestDTO.Applicants();
            request.applicants.individualApplicants = getIndividualApplicants(o, app);
            
            request.broker = new LatitudeAPIRequestDTO.Broker();
            request.broker.id = apiUser;
            
            request.comments = APIServiceManager.getLenderComments(app.Id);
            
            request.loan = new LatitudeAPIRequestDTO.ApplicationRequestedLoan();
            request.loan.balloon = getCents(appQuoting.Residual_Value__c);
            request.loan.deposit = getCents(appQuoting.Deposit__c);
            request.loan.fees = new LatitudeAPIRequestDTO.Fees();
            request.loan.fees.origination = getCents(appQuoting.DOF__c);
            request.loan.goods = new LatitudeAPIRequestDTO.Goods();
            if('Business'.equals(app.Application_Type__c)){
                request.loan.goods.businessUse = true;
            }else{
                request.loan.goods.businessUse = false;
            }
            request.loan.goods.cashPrice = getCents(appQuoting.Vehicle_Price__c);
            request.loan.payees = new LatitudeAPIRequestDTO.Payees();
            request.loan.payees.collateralSupplier = new LatitudeAPIRequestDTO.CollateralSupplier();
            //if('Business'.equals(app.Application_Type__c)){
            if(String.isNotBlank(appQuoting.Private_Sales__c)){
              if('N'.equals(appQuoting.Private_Sales__c)){
                request.loan.payees.collateralSupplier.company = new LatitudeAPIRequestDTO.CompanyPayee();
                /*
                request.loan.payees.collateralSupplier.company.abn = app.Business_ABN__c;
                request.loan.payees.collateralSupplier.company.acn = app.Business_ACN__c;
                request.loan.payees.collateralSupplier.company.tradingName = app.Trading_Name__c;
                */
                request.loan.payees.collateralSupplier.company.tradingName = 'TBA';
              }else{
                request.loan.payees.collateralSupplier.individual = new LatitudeAPIRequestDTO.IndividualPayee();
                /*
                request.loan.payees.collateralSupplier.individual.firstName = app.First_Name__c;
                request.loan.payees.collateralSupplier.individual.lastName = app.Last_Name__c;
                */
                request.loan.payees.collateralSupplier.individual.firstName = 'TBA';
              }
            }
            request.loan.repayment = new LatitudeAPIRequestDTO.Repayment();
            request.loan.repayment.frequency = 'MONTHLY';
            request.loan.repayment.type = appQuoting.Payment__c.toUppercase();
            request.loan.term = appQuoting.Term__c.intValue();
            if(String.isNotBlank(appQuoting.Private_Sales__c)){
                if('Y'.equals(appQuoting.Private_Sales__c)){
                    request.salesSource = 'PRIVATE_SALE';
                }else{
                    request.salesSource = 'DEALERSHIP';
                }
            }
            if(appQuoting.Trade_In__c > 0){
                request.tradein = new List<LatitudeAPIRequestDTO.TradeIn>();
                LatitudeAPIRequestDTO.TradeIn tradeIn = new LatitudeAPIRequestDTO.TradeIn();
                
                if(appQuoting.Payout_On__c > 0){
                    tradein.payout = getCents(appQuoting.Payout_On__c);
                }
                tradein.value = getCents(appQuoting.Trade_In__c);
                tradein.year = 2015;
                tradein.model = 'TBA';
                request.tradein.add(tradeIn);
            }
            
            String complianceDateMonth = '06';
            if (o.Application_AssetDetail__r.Year__c.intValue() == Date.today().year() && Date.today().month() <= 6) {
              complianceDateMonth = '01';
            }
            request.vehicle = new LatitudeAPIRequestDTO.ApplicationVehicle();
            request.vehicle.auto = new LatitudeAPIRequestDTO.ApplicationAutoVehicle();
            request.vehicle.auto.complianceDate = o.Application_AssetDetail__r.Year__c.intValue()+'-'+complianceDateMonth;
            request.vehicle.auto.condition = o.Application_AssetDetail__r.Condition__c.toUppercase();
            request.vehicle.auto.garagedLocation = new LatitudeAPIRequestDTO.GaragedLocation();
            request.vehicle.auto.garagedLocation.address = new LatitudeAPIRequestDTO.AddressDetails();
            request.vehicle.auto.garagedLocation.address.country = 'AU';
            request.vehicle.auto.garagedLocation.address.postcode = app.Postcode__c;
            request.vehicle.auto.garagedLocation.address.state = app.State__c;
            request.vehicle.auto.garagedLocation.address.streetName = app.Street_Address__c;
            request.vehicle.auto.garagedLocation.address.streetNumber = app.Street_Number__c;
            if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c))){
                request.vehicle.auto.garagedLocation.address.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c).toUppercase();
            }
            request.vehicle.auto.garagedLocation.address.suburb = app.Suburb__c;
            request.vehicle.auto.garagedLocation.address.unitNumber = app.Unit_Number__c;
            
            if(!'new'.equals(o.Application_AssetDetail__r.Condition__c)){
              request.vehicle.auto.kilometers = o.Application_AssetDetail__r.Actual_KM__c.intValue();
            }
            
            request.vehicle.auto.nvic = NVIC;
            
            if(String.isNotBlank(o.Application_AssetDetail__r.Rego_State__c)){
                request.vehicle.auto.stateOfRegistration = o.Application_AssetDetail__r.Rego_State__c;
            }else{
                request.vehicle.auto.stateOfRegistration = app.State__c;    
            }
            request.vehicle.auto.type = appQuoting.Goods_type__c;
        }
        return request;
    }

    public LatitudeAPIRequestDTO.Preapproval getLatitudePreApproval(Custom_Opportunity__c opp, String apiUser) {
	
    LatitudeAPIRequestDTO.Preapproval request;
            
    Application_Quoting__c appQuoting = QuotingToolHelper.getApplicationQuoting(opp.Id, opp.Application__c);
            
    if (appQuoting == null){
      throw new GenericException ('Please make sure calculate before send to Money3 API.');
    }
    Custom_Opportunity__c o = APIServiceManager.getCustomOpportunityForApplication(opp);
    Application__c app = o.Application__r;
    LatitudeAPIService api = new LatitudeAPIService();
    otherIncomeMap = api.getAppIncomes(app.Id);
    if(submitRequest(app, o, appQuoting)){
      request = new LatitudeAPIRequestDTO.Preapproval();
                
      request.applicants = new LatitudeAPIRequestDTO.Applicants();
      request.applicants.individualApplicants = getIndividualApplicants(o, app);
                
      request.broker = new LatitudeAPIRequestDTO.Broker();
      request.broker.id = apiUser;
                
      request.comments = APIServiceManager.getLenderComments(app.Id);
                
      request.loan = new LatitudeAPIRequestDTO.RequestedLoan();
      request.loan.amountRequested = getCents(appQuoting.NAF__c);
      request.loan.term = appQuoting.Term__c.intValue();
                
      request.vehicle = new LatitudeAPIRequestDTO.PreApprovalVehicle();
      request.vehicle.condition = appQuoting.Vehicle_Condition__c;
      request.vehicle.stateOfRegistration = app.State__c;
      request.vehicle.type = appQuoting.Goods_type__c;
    }
      return request;
    }
    
    private List<LatitudeAPIRequestDTO.IndividualApplicant> getIndividualApplicants(Custom_Opportunity__c opp, Application__c app) {
        List<LatitudeAPIRequestDTO.IndividualApplicant> individualApplicants = new List<LatitudeAPIRequestDTO.IndividualApplicant>();
        previousEmp = APIServiceManager.loadPreviousEmployments(opp);
        LatitudeAPIRequestDTO.IndividualApplicant applicant = applicant(opp, app, 1);
        individualApplicants.add(applicant);
        
        if(app.No_of_People__c == 2){
            applicant = applicant(opp, app, 2);
            individualApplicants.add(applicant);
        }
        System.debug(individualApplicants);
        return individualApplicants;
    }
    
    private LatitudeAPIRequestDTO.IndividualApplicant applicant(Custom_Opportunity__c opp, Application__c app, Integer applicant){
        LatitudeAPIRequestDTO.IndividualApplicant i = new LatitudeAPIRequestDTO.IndividualApplicant();
        
        i.business = new LatitudeAPIRequestDTO.Business();
        i.consent = new LatitudeAPIRequestDTO.Consent();
        i.contact = new LatitudeAPIRequestDTO.Contact();
        i.contact.addresses = new LatitudeAPIRequestDTO.Addresses();
        i.identityDocuments = new LatitudeAPIRequestDTO.IdentityDocuments();
        i.identityDocuments.driverLicence = new LatitudeAPIRequestDTO.DriverLicenceDetails();
        String[] expirationDate;
        i.income = new LatitudeAPIRequestDTO.Income();
        i.name = new LatitudeAPIRequestDTO.PersonName();
        Decimal incomeSecondJob;
		String frecuencyIncomeSecondJob;

        if(applicant == 1){
            if('Business'.equals(app.Application_Type__c)){
                i.business.abn = app.Business_ABN__c;
            }
            i.consent.signedNoticeOfDisclosure = true;
            i.contact.addresses.mailingAddress = new LatitudeAPIRequestDTO.MailingAddress();
            i.contact.addresses.mailingAddress.streetAddress = new LatitudeAPIRequestDTO.AddressDetails();
            i.contact.addresses.mailingAddress.streetAddress.country = 'AU';
            i.contact.addresses.mailingAddress.streetAddress.postcode = app.Postcode__c;
            i.contact.addresses.mailingAddress.streetAddress.state = app.State__c;
            i.contact.addresses.mailingAddress.streetAddress.streetName = app.Street_Address__c;
            i.contact.addresses.mailingAddress.streetAddress.streetNumber = app.Street_Number__c;
            if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c))){
                i.contact.addresses.mailingAddress.streetAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c).toUppercase();
            }
            i.contact.addresses.mailingAddress.streetAddress.suburb = app.Suburb__c;
            i.contact.addresses.mailingAddress.streetAddress.unitNumber = app.Unit_Number__c;
            i.contact.addresses.residentialAddresses = getResidentialAddress(opp, app, 1);
            i.contact.email = app.Email_Address__c;
            i.contact.phone = new LatitudeAPIRequestDTO.Phone();
            i.contact.phone.home = app.Home_Phone__c;
            i.contact.phone.mobile = app.Mobile_Number__c;
            i.contact.phone.work = phoneWork(app.Work_Phone__c);
            
            String[] dateOfBirth = app.Date_of_Birth_1__c.split('/');
            i.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            i.dependants = dependants(app, 1);
            i.employmentHistory = getEmploymentHistoryItem(opp, app, 1);
            i.expenses = new LatitudeAPIRequestDTO.Expenses();
            if(app.No_of_People__c == 1){
                if(opp.ApplicationServicing__c != null){
                    if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                        i.expenses.sharedExpenses = true;
                        if(opp.ApplicationServicing__r.Is_Split_Living_Expenses__c){
                            i.expenses.livingMonthly = getCents(getLivingExpenses(app)/2);
                        }else{
                            i.expenses.livingMonthly = getCents(getLivingExpenses(app));
                        }
                    }else{
                        i.expenses.sharedExpenses = false;
                        i.expenses.livingMonthly = getCents(getLivingExpenses(app));
                    }
                }else{
                    i.expenses.sharedExpenses = false;
                    i.expenses.livingMonthly = getCents(getLivingExpenses(app));
                }
            }
            if(app.No_of_People__c == 2 && partner(app)){
              i.expenses.sharedExpenses = true;
              i.expenses.livingMonthly = getCents(getLivingExpenses(app)/2);
            }

            if(app.Current_Residence_Status_1__c.equals('Boarding')){
              i.expenses.otherMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, livingSameAddress(app, app.Board_per_month_1__c)));
            }
            if(app.Current_Residence_Status_1__c.equals('Renting(Agent)') || app.Current_Residence_Status_1__c.equals('Renting(Private)')){
              i.expenses.rentMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, livingSameAddress(app, app.Rent_per_month_1__c)));
            }
                        
            i.gender = LatitudeUtils.getLabelPicklistField(Application__c.Gender_1__c.getDescribe(), app.Gender_1__c).toUppercase();	
            i.holdings = new LatitudeAPIRequestDTO.Holdings();
            i.holdings.creditCards = getCreditCard(app);
            i.holdings.investmentProperties = getInvestmentProperty(opp, app, 1);
            i.holdings.loans = getLoanDetails(app);
            i.holdings.residentialProperties = getResidentialProperty(opp, app, 1);
            
            if(String.isNotBlank(app.Do_you_have_drivers_licence_1__c)){
                if('Yes'.equals(app.Do_you_have_drivers_licence_1__c)){
                    i.identityDocuments.driverLicence.licenceDetails = new LatitudeAPIRequestDTO.DriverLicence();
                    expirationDate = app.Expiry_Date_1__c.split('/');
                    i.identityDocuments.driverLicence.licenceDetails.expiryDate = expirationDate[2]+'-'+expirationDate[1]+'-'+expirationDate[0];
                    i.identityDocuments.driverLicence.licenceDetails.r_number = app.Drivers_License_1__c;
                }else{
                    i.identityDocuments.driverLicence.reasonUnlicensed = 'no license';
                }
            }
            /*
            List<YTD_Income__c> d = [Select Annualised_Income__c, Applicant_Type__c From YTD_Income__c Where Opportunity__c = :Opp.Id];
            
            YTD_Income__c ytd;
            YTD_Income__c ytd2;
            
            for (YTD_Income__c y: d) {
                
                if('Applicant 1'.equals(y.Applicant_Type__c)){
                    ytd = y;
                }
                
                if('Applicant 1 Second Job'.equals(y.Applicant_Type__c)){
                    ytd2 = y;
                }
                
            }
            
            if(ytd != null && ytd2 != null){
                System.debug(ytd.Annualised_Income__c);
                System.debug(ytd2.Annualised_Income__c);
                i.income.grossYearly = getCents(ytd.Annualised_Income__c + ytd2.Annualised_Income__c);
            }else if (ytd != null){
                i.income.grossYearly = getCents(ytd.Annualised_Income__c);
            }
            */
            
            if(opp.ApplicationServicing__c != null){
              if(opp.ApplicationServicing__r.Gross_Annual_Income_1__c != null && opp.ApplicationServicing__r.Gross_Annual_Income_1_Second_Job__c != null){
                i.income.grossYearly = getCents(opp.ApplicationServicing__r.Gross_Annual_Income_1__c + opp.ApplicationServicing__r.Gross_Annual_Income_1_Second_Job__c);
              }else if (opp.ApplicationServicing__r.Gross_Annual_Income_1__c != null){
                i.income.grossYearly = getCents(opp.ApplicationServicing__r.Gross_Annual_Income_1__c);
              }
            }else{
              for (String a: previousEmp.keySet()) {
                if(a.equals('1')){
                  List < Application_Employment__c > employments = previousEmp.get(a);
                  for (Application_Employment__c e: employments) {
                    if('Second Job'.equals(e.Type__c)){
                      incomeSecondJob = e.Income__c;
                      frecuencyIncomeSecondJob = e.Frequency__c;
                    }
                  }
                }
              }
                
              if(app.Net_Income_1__c != null && app.Payment_Frequency_1__c != null && incomeSecondJob != null && frecuencyIncomeSecondJob != null){
                i.income.grossYearly = getCents(OppApplicationServCalculatorUtils.getGrossAnnualIncome(app.Net_Income_1__c, app.Payment_Frequency_1__c) + OppApplicationServCalculatorUtils.getGrossAnnualIncome(incomeSecondJob, frecuencyIncomeSecondJob));
              }else if(app.Net_Income_1__c != null && app.Payment_Frequency_1__c != null){
                i.income.grossYearly = getCents(OppApplicationServCalculatorUtils.getGrossAnnualIncome(app.Net_Income_1__c, app.Payment_Frequency_1__c));
              }
            }

            if(getOtherIncome(1) != null){
                i.income.otherNetMonthly = getCents(getOtherIncome(1));
            }
            if(getSecondJobIncome(app, 1) != null){
                i.income.primaryNetMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Payment_Frequency_1__c, app.Net_Income_1__c) + getSecondJobIncome(app, 1));
            }else{
                i.income.primaryNetMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Payment_Frequency_1__c, app.Net_Income_1__c));
            }
            i.maritalStatus = app.Marital_Status_1__c.toUppercase();
            i.name.firstName = app.First_Name__c;
            i.name.lastName = app.Last_Name__c;
            i.name.middleName = app.Middle_Name__c;
            i.name.title = app.Title_1__c.toUppercase();
            if('MARRIED'.equalsIgnoreCase(app.Marital_Status_1__c) || 'DEFACTO'.equalsIgnoreCase(app.Marital_Status_1__c)){
                i.partnerPartyToLoan = false;
                if(partner(app)){
                    i.partnerPartyToLoan = true;
                }
            }
            i.primary = true;
        }
        
        if(applicant == 2){
            System.debug(applicant);
            if('Business'.equals(app.Application_Type__c)){
                i.business.abn = app.Business_ABN__c;
            }
            i.consent.signedNoticeOfDisclosure = true;
            i.contact.addresses.mailingAddress = new LatitudeAPIRequestDTO.MailingAddress();
            i.contact.addresses.mailingAddress.streetAddress = new LatitudeAPIRequestDTO.AddressDetails();
            if('No'.equals(app.Applicant_2_living_in_the_same_address__c)){
              i.contact.addresses.mailingAddress.streetAddress.country = 'AU';
              i.contact.addresses.mailingAddress.streetAddress.postcode = app.Postcode_2__c;
              i.contact.addresses.mailingAddress.streetAddress.state = app.State_2__c;
              i.contact.addresses.mailingAddress.streetAddress.streetName = app.Street_Address_2__c;
              i.contact.addresses.mailingAddress.streetAddress.streetNumber = app.Street_Number_2__c;
              if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type_2__c))){
                i.contact.addresses.mailingAddress.streetAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type_2__c).toUppercase();
              }
              i.contact.addresses.mailingAddress.streetAddress.suburb = app.Suburb_2__c;
              i.contact.addresses.mailingAddress.streetAddress.unitNumber = app.Unit_Number_2__c;
            }else{
              i.contact.addresses.mailingAddress.streetAddress.country = 'AU';
              i.contact.addresses.mailingAddress.streetAddress.postcode = app.Postcode__c;
              i.contact.addresses.mailingAddress.streetAddress.state = app.State__c;
              i.contact.addresses.mailingAddress.streetAddress.streetName = app.Street_Address__c;
              i.contact.addresses.mailingAddress.streetAddress.streetNumber = app.Street_Number__c;
              if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c))){
                i.contact.addresses.mailingAddress.streetAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c).toUppercase();
              }
              i.contact.addresses.mailingAddress.streetAddress.suburb = app.Suburb__c;
              i.contact.addresses.mailingAddress.streetAddress.unitNumber = app.Unit_Number__c;
            }
            i.contact.addresses.residentialAddresses = getResidentialAddress(opp, app, 2);
            i.contact.email = app.Email_Address_2__c;
            i.contact.phone = new LatitudeAPIRequestDTO.Phone();
            i.contact.phone.home = app.Home_Phone_2__c;
            i.contact.phone.mobile = app.Mobile_Number_2__c;
            i.contact.phone.work = phoneWork(app.Work_Phone_2__c);
            
            String[] dateOfBirth = app.Date_of_Birth_2__c.split('/');
            i.dateOfBirth = dateOfBirth[2]+'-'+dateOfBirth[1]+'-'+dateOfBirth[0];
            i.dependants = dependants(app, 2);
            i.employmentHistory = getEmploymentHistoryItem(opp, app, 2);
            System.debug(applicant);
            i.expenses = new LatitudeAPIRequestDTO.Expenses();
            if(partner(app)){
              i.expenses.sharedExpenses = true;
              i.expenses.livingMonthly = getCents(getLivingExpenses(app)/2);
            }
            
            if('No'.equals(app.Applicant_2_living_in_the_same_address__c)){
                if(app.Current_Residence_Status_2__c.equals('Boarding')){
                    if(String.isBlank(app.Residential_Payment_Frequency_2__c)){
                        i.expenses.otherMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, app.Board_per_month_2__c));
                    }else{
                        i.expenses.otherMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_2__c, app.Board_per_month_2__c));
                    }
                }
                if(app.Current_Residence_Status_2__c.equals('Renting(Agent)') || app.Current_Residence_Status_2__c.equals('Renting(Private)')){
                    if(String.isBlank(app.Residential_Payment_Frequency_2__c)){
                        i.expenses.rentMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, app.Rent_per_month_2__c));
                    }else{
                        i.expenses.rentMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_2__c, app.Rent_per_month_2__c));
                    }
                }
            } else {
              if(app.Current_Residence_Status_1__c.equals('Boarding')){
                i.expenses.otherMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, livingSameAddress(app, app.Board_per_month_1__c)));
              }
              if(app.Current_Residence_Status_1__c.equals('Renting(Agent)') || app.Current_Residence_Status_1__c.equals('Renting(Private)')){
                i.expenses.rentMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Residential_Payment_Frequency_1__c, livingSameAddress(app, app.Rent_per_month_1__c)));
              }
            }
            
            i.gender = LatitudeUtils.getLabelPicklistField(Application__c.Gender_1__c.getDescribe(), app.Gender_2__c).toUppercase();	
            i.holdings = new LatitudeAPIRequestDTO.Holdings();
            System.debug(applicant);
            i.holdings.investmentProperties = getInvestmentProperty(opp, app, 2);
            i.holdings.residentialProperties = getResidentialProperty(opp, app, 2);
            System.debug(applicant);
            if(String.isNotBlank(app.Do_you_have_drivers_licence_2__c)){
                if(app.Do_you_have_drivers_licence_2__c.equals('Yes')){
                    i.identityDocuments.driverLicence.licenceDetails = new LatitudeAPIRequestDTO.DriverLicence();
                    expirationDate = app.Expiry_Date_2__c.split('/');
                    i.identityDocuments.driverLicence.licenceDetails.expiryDate = expirationDate[2]+'-'+expirationDate[1]+'-'+expirationDate[0];
                    i.identityDocuments.driverLicence.licenceDetails.r_number = app.Drivers_License_2__c;
                }else{
                    i.identityDocuments.driverLicence.reasonUnlicensed = 'no license';
                }
            }
            /*
            List<YTD_Income__c> d = [Select Annualised_Income__c, Applicant_Type__c From YTD_Income__c Where Opportunity__c = :Opp.Id];
            
            YTD_Income__c ytd;
            YTD_Income__c ytd2;
            
            for (YTD_Income__c y: d) {
                
                if('Applicant 2'.equals(y.Applicant_Type__c)){
                    ytd = y;
                }
                
                if('Applicant 2 Second Job'.equals(y.Applicant_Type__c)){
                    ytd2 = y;
                }
                
            }
            
            if(ytd != null && ytd2 != null){
                i.income.grossYearly = getCents(ytd.Annualised_Income__c + ytd2.Annualised_Income__c);
            }else if (ytd != null){
                i.income.grossYearly = getCents(ytd.Annualised_Income__c);
            }
            */

            if(opp.ApplicationServicing__c != null){
              if(opp.ApplicationServicing__r.Gross_Annual_Income_2__c != null && opp.ApplicationServicing__r.Gross_Annual_Income_2_Second_Job__c != null){
                i.income.grossYearly = getCents(opp.ApplicationServicing__r.Gross_Annual_Income_2__c + opp.ApplicationServicing__r.Gross_Annual_Income_2_Second_Job__c);
              }else if (opp.ApplicationServicing__r.Gross_Annual_Income_2__c != null){
                i.income.grossYearly = getCents(opp.ApplicationServicing__r.Gross_Annual_Income_2__c);
              }
            }else{
              for (String a: previousEmp.keySet()) {
                if(a.equals('2')){
                  List < Application_Employment__c > employments = previousEmp.get(a);
                  for (Application_Employment__c e: employments) {
                    if('Second Job'.equals(e.Type__c)){
                      incomeSecondJob = e.Income__c;
                      frecuencyIncomeSecondJob = e.Frequency__c;
                    }
                  }
                }
              }
              
              if(app.Net_Income_2__c != null && app.Payment_Frequency_2__c != null && incomeSecondJob != null && frecuencyIncomeSecondJob != null){
                i.income.grossYearly = getCents(OppApplicationServCalculatorUtils.getGrossAnnualIncome(app.Net_Income_2__c, app.Payment_Frequency_2__c) + OppApplicationServCalculatorUtils.getGrossAnnualIncome(incomeSecondJob, frecuencyIncomeSecondJob));
              }else if(app.Net_Income_2__c != null && app.Payment_Frequency_2__c != null){
                i.income.grossYearly = getCents(OppApplicationServCalculatorUtils.getGrossAnnualIncome(app.Net_Income_2__c, app.Payment_Frequency_2__c));
              }
            }
            if(getOtherIncome(2) != null){
                i.income.otherNetMonthly = getCents(getOtherIncome(2));
            }
            if(getSecondJobIncome(app, 2) != null){
                i.income.primaryNetMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Payment_Frequency_2__c, app.Net_Income_2__c) + getSecondJobIncome(app, 2));
            }else{
                i.income.primaryNetMonthly = getCents(LatitudeUtils.getMonthlyIncome(app.Payment_Frequency_2__c, app.Net_Income_2__c));
            }
            i.maritalStatus = app.Marital_Status_2__c.toUppercase();
            i.name.firstName = app.First_Name_2__c;
            i.name.lastName = app.Last_Name_2__c;
            i.name.middleName = app.Middle_Name_2__c;
            i.name.title = app.Title_2__c.toUppercase();
            
            if('MARRIED'.equalsIgnoreCase(app.Marital_Status_2__c) || 'DEFACTO'.equalsIgnoreCase(app.Marital_Status_2__c)){
                i.partnerPartyToLoan = false;
                if(partner(app)){
                    i.partnerPartyToLoan = true;
                }
            }
           
            i.primary = false;
            System.debug(applicant);
        }
        
        return i;
    }
    
    private List<LatitudeAPIRequestDTO.ResidentialAddress> getResidentialAddress(Custom_Opportunity__c opp, Application__c app, Integer applicant){
        List<LatitudeAPIRequestDTO.ResidentialAddress> residentialAddresses = new List<LatitudeAPIRequestDTO.ResidentialAddress>();
        
        Integer durationCurrentAddress;
        LatitudeAPIRequestDTO.ResidentialAddress residential= new LatitudeAPIRequestDTO.ResidentialAddress();
        
        if(applicant == 1){
            residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
            residential.AddressDetails.country = 'AU';
            residential.AddressDetails.postcode = app.Postcode__c;
            residential.AddressDetails.state = app.State__c;
            residential.AddressDetails.streetName = app.Street_Address__c;
            residential.AddressDetails.streetNumber = app.Street_Number__c;
            if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c))){
                residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c).toUppercase();
            }
            residential.AddressDetails.suburb = app.Suburb__c;
            residential.AddressDetails.unitNumber = app.Unit_Number__c;
            residential.current = true;
            Date dateMovedInCurrentAddress = Date.parse(app.Date_Moved_in_1__c);
            Date todayDate = Date.today();
            durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
            residential.lengthOfResidence = durationCurrentAddress;
            
            residential.residentialStatus = LatitudeUtils.getResidential(app.Current_Residence_Status_1__c);
            
            residentialAddresses.add(residential);
            
            Integer durationPRA;
            
            Date dateMovedInCRA = dateMovedInCurrentAddress;
            Date dateMovedInPRA;			   
            
            Integer durationAddress = 0;
            durationAddress += durationCurrentAddress;
            
            if (app.Previous_Country_1__c != null && 
                (String.isNotBlank(app.Date_From_1__c) 
                 || String.isNotBlank(app.Previous_Street_Address_1__c)
                 || String.isNotBlank(app.Previous_Residence_Status_1__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_1__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_1__c)){
                         if('AUS'.equals(app.Previous_Country_1__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_1__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_1__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_1__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_1__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_1__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_1__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_1__c, app.Previous_Street_Address_2nd_1__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_1__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_1__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_1__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_1b__c != null && 
                (String.isNotBlank(app.Date_From_1b__c) 
                 || String.isNotBlank(app.Previous_Street_Address_1b__c)
                 || String.isNotBlank(app.Previous_Residence_Status_1b__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_1b__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_1b__c)){
                         if('AUS'.equals(app.Previous_Country_1b__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_1b__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_1b__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_1b__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1b__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1b__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_1b__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_1b__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_1b__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_1b__c, app.Previous_Street_Address_2nd_1b__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_1b__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_1b__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_1b__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_1c__c != null && 
                (String.isNotBlank(app.Date_From_1c__c)
                 || String.isNotBlank(app.Previous_Street_Address_1c__c)
                 || String.isNotBlank(app.Previous_Residence_Status_1c__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_1c__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_1c__c)){
                         if('AUS'.equals(app.Previous_Country_1c__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_1c__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_1c__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_1c__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1c__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1c__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_1c__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_1c__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_1c__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_1c__c, app.Previous_Street_Address_2nd_1c__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_1c__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_1c__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_1c__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_1d__c != null && 
                (String.isNotBlank(app.Date_From_1d__c) 
                 || String.isNotBlank(app.Previous_Street_Address_1d__c)
                 || String.isNotBlank(app.Previous_Residence_Status_1d__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_1d__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_1d__c)){
                         if('AUS'.equals(app.Previous_Country_1d__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_1d__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_1d__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_1d__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1d__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1d__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_1d__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_1d__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_1d__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_1d__c, app.Previous_Street_Address_2nd_1d__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_1d__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_1d__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_1d__c);
                     residentialAddresses.add(residential);
                 }
            System.debug(durationAddress);
            if (app.Previous_Country_1e__c != null && 
                (String.isNotBlank(app.Date_From_1e__c)
                 || String.isNotBlank(app.Previous_Street_Address_1e__c)
                 || String.isNotBlank(app.Previous_Residence_Status_1e__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_1e__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_1e__c)){
                         if('AUS'.equals(app.Previous_Country_1e__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_1e__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_1e__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_1e__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1e__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1e__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_1e__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_1e__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_1e__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_1e__c, app.Previous_Street_Address_2nd_1e__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_1e__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_1e__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_1e__c);
                     residentialAddresses.add(residential);
                 }
        }
        
        if(applicant == 2){
            Date dateMovedInCurrentAddress;
            if('No'.equals(app.Applicant_2_living_in_the_same_address__c)){
                residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                residential.AddressDetails.country = 'AU';
                residential.AddressDetails.postcode = app.Postcode_2__c;
                residential.AddressDetails.state = app.State_2__c;
                residential.AddressDetails.streetName = app.Street_Address_2__c;
                residential.AddressDetails.streetNumber = app.Street_Number_2__c;
                if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type_2__c))){
                    residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type_2__c).toUppercase();
                }
                residential.AddressDetails.suburb = app.Suburb_2__c;
                residential.AddressDetails.unitNumber = app.Unit_Number_2__c;
                residential.current = true;
                dateMovedInCurrentAddress = Date.parse(app.Date_Moved_in_2__c);
                Date todayDate = Date.today();
                durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                residential.lengthOfResidence = durationCurrentAddress;
                residential.residentialStatus = LatitudeUtils.getResidential(app.Current_Residence_Status_2__c);
            }else{
                residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                residential.AddressDetails.country = 'AU';
                residential.AddressDetails.postcode = app.Postcode__c;
                residential.AddressDetails.state = app.State__c;
                residential.AddressDetails.streetName = app.Street_Address__c;
                residential.AddressDetails.streetNumber = app.Street_Number__c;
                if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c))){
                    residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Street_Type__c).toUppercase();
                }
                residential.AddressDetails.suburb = app.Suburb__c;
                residential.AddressDetails.unitNumber = app.Unit_Number__c;
                residential.current = true;
                dateMovedInCurrentAddress = Date.parse(app.Date_Moved_in_1__c);
                Date todayDate = Date.today();
                durationCurrentAddress = dateMovedInCurrentAddress.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                residential.lengthOfResidence = durationCurrentAddress;
                residential.residentialStatus = LatitudeUtils.getResidential(app.Current_Residence_Status_1__c);
            }
            residentialAddresses.add(residential);
            
            Integer durationPRA;
            
            Date dateMovedInCRA = dateMovedInCurrentAddress;
            Date dateMovedInPRA;			   
            
            Integer durationAddress = 0;
            durationAddress += durationCurrentAddress;
            
            if (app.Previous_Country_2__c != null && 
                (String.isNotBlank(app.Date_From_2__c) 
                 || String.isNotBlank(app.Previous_Street_Address_2__c)
                 || String.isNotBlank(app.Previous_Residence_Status_2__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_2__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_2__c)){
                         if('AUS'.equals(app.Previous_Country_2__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_2__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_2__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_2__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_2__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_2__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_2__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_2__c, app.Previous_Street_Address_2nd_2__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_2__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_2__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_2__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_2b__c != null && 
                (String.isNotBlank(app.Date_From_2b__c) 
                 || String.isNotBlank(app.Previous_Street_Address_2b__c)
                 || String.isNotBlank(app.Previous_Residence_Status_2b__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_2b__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_2b__c)){
                         if('AUS'.equals(app.Previous_Country_2b__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_2b__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_2b__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_2b__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2b__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2b__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_2b__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_2b__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_2b__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_2b__c, app.Previous_Street_Address_2nd_2b__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_2b__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_2b__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_2b__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_2c__c != null && 
                (String.isNotBlank(app.Date_From_2c__c)
                 || String.isNotBlank(app.Previous_Street_Address_2c__c)
                 || String.isNotBlank(app.Previous_Residence_Status_2c__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_2c__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_2c__c)){
                         if('AUS'.equals(app.Previous_Country_2c__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_2c__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_2c__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_2c__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2c__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2c__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_2c__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_2c__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_2c__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_2c__c, app.Previous_Street_Address_2nd_2c__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_2c__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_2c__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_2c__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_2d__c != null && 
                (String.isNotBlank(app.Date_From_2d__c) 
                 || String.isNotBlank(app.Previous_Street_Address_2d__c)
                 || String.isNotBlank(app.Previous_Residence_Status_2d__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_2d__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     dateMovedInCRA = dateMovedInPRA;
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_2d__c)){
                         if('AUS'.equals(app.Previous_Country_2d__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_2d__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_2d__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_2d__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2d__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2d__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_2d__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_2d__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_2d__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_2d__c, app.Previous_Street_Address_2nd_2d__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_2d__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_2d__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_2d__c);
                     residentialAddresses.add(residential);
                 }
            
            if (app.Previous_Country_2e__c != null && 
                (String.isNotBlank(app.Date_From_2e__c)
                 || String.isNotBlank(app.Previous_Street_Address_2e__c)
                 || String.isNotBlank(app.Previous_Residence_Status_2e__c)) && durationAddress < 36) {
                     dateMovedInPRA = Date.parse(app.Date_From_2e__c);
                     durationPRA = dateMovedInPRA.monthsBetween(Date.newInstance(dateMovedInCRA.year(), dateMovedInCRA.month(), dateMovedInCRA.day()));
                     durationAddress += durationPRA;
                     residential= new LatitudeAPIRequestDTO.ResidentialAddress();
                     residential.AddressDetails = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Country_2e__c)){
                         if('AUS'.equals(app.Previous_Country_2e__c)){
                             residential.AddressDetails.country = 'AU';
                             residential.AddressDetails.state = app.Previous_State_2e__c;
                             residential.AddressDetails.streetName = app.Previous_Street_Address_2e__c;
                             residential.AddressDetails.streetNumber = app.Previous_Street_Number_2e__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2e__c))){
                                 residential.AddressDetails.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_2e__c).toUppercase();
                             }
                             residential.AddressDetails.suburb = app.Previous_Suburb_2e__c;
                             residential.AddressDetails.unitNumber = app.Previous_Unit_Number_2e__c;
                         }else{
                             residential.AddressDetails.country = 'OTHER';
                             residential.AddressDetails.state = app.Previous_Overseas_State_2e__c;
                             residential.AddressDetails.streetName = street(app.Previous_Street_Address_2e__c, app.Previous_Street_Address_2nd_2e__c);
                             residential.AddressDetails.suburb = app.Previous_Overseas_City_2e__c;
                         }
                     }
                     residential.AddressDetails.postcode = app.Previous_Postcode_2e__c;
                     
                     residential.current = false;
                     residential.lengthOfResidence = durationPRA;
                     residential.residentialStatus = LatitudeUtils.getResidential(app.Previous_Residence_Status_2e__c);
                     residentialAddresses.add(residential);
                 }
        }			 
        
        return residentialAddresses;
    }
    
    private List<LatitudeAPIRequestDTO.EmploymentHistoryItem> getEmploymentHistoryItem(Custom_Opportunity__c opp, Application__c app, Integer applicant){
        List<LatitudeAPIRequestDTO.EmploymentHistoryItem> employmentHistoryItems = new List<LatitudeAPIRequestDTO.EmploymentHistoryItem>();
        
        LatitudeAPIRequestDTO.EmploymentHistoryItem employmentHistoryItem = new LatitudeAPIRequestDTO.EmploymentHistoryItem();
        Date startDateEmploymentCurrent;
        
        if(applicant == 1){
            employmentHistoryItem.activity = LatitudeUtils.getActivity(app.Mode_of_Employment_1__c);
            employmentHistoryItem.current = true;
            if(
              !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_1__c)) && 
              !'PENSIONER'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_1__c)) && 
              !'RETIRED'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_1__c)) && 
              !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_1__c))
            ){
                startDateEmploymentCurrent = Date.parse(app.Date_Started_1__c);
                Date todayDate = Date.today();
                employmentHistoryItem.duration = startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employmentHistoryItem.employerName = app.Current_Employer_Name_1__c;
                employmentHistoryItem.employerPhone = app.Current_Employer_Phone_1__c;
                employmentHistoryItem.occupation = app.Current_Occupation_1__c;
            }
            employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
            employmentHistoryItem.employerAddress.country = 'AU';
            employmentHistoryItem.employerAddress.state = app.Current_Work_State_1__c;
            employmentHistoryItem.employerAddress.postcode = app.Current_Work_Postcode_1__c;
            employmentHistoryItem.employerAddress.streetName = app.Current_Work_Address_1__c;
            employmentHistoryItem.employerAddress.streetNumber = app.Current_Work_Street_Number_1__c;
            if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Current_Work_Street_Type_1__c))){
                employmentHistoryItem.employerAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Current_Work_Street_Type_1__c).toUppercase();
            }
            employmentHistoryItem.employerAddress.suburb = app.Current_Work_Suburb_1__c;
            employmentHistoryItem.employerAddress.unitNumber = app.Current_Work_Unit_Number_1__c;
        }
        
        if(applicant == 2){
            employmentHistoryItem.activity = LatitudeUtils.getActivity(app.Mode_of_Employment_2__c);
            employmentHistoryItem.current = true;
            if(
              !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_2__c)) && 
              !'PENSIONER'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_2__c)) && 
              !'RETIRED'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_2__c)) && 
              !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(app.Mode_of_Employment_2__c))
            ){
                startDateEmploymentCurrent = Date.parse(app.Date_Started_2__c);
                Date todayDate = Date.today();
                employmentHistoryItem.duration = startDateEmploymentCurrent.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employmentHistoryItem.employerName = app.Current_Employer_Name_2__c;
                employmentHistoryItem.employerPhone = app.Current_Employer_Phone_2__c;
                employmentHistoryItem.occupation = app.Current_Occupation_2__c;
            }
            employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
            employmentHistoryItem.employerAddress.country = 'AU';
            employmentHistoryItem.employerAddress.state = app.Current_Work_State_2__c;
            employmentHistoryItem.employerAddress.postcode = app.Current_Work_Postcode_2__c;
            employmentHistoryItem.employerAddress.streetName = app.Current_Work_Address_2__c;
            employmentHistoryItem.employerAddress.streetNumber = app.Current_Work_Street_Number_2__c;
            if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Current_Work_Street_Type_2__c))){
                employmentHistoryItem.employerAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Current_Work_Street_Type_2__c).toUppercase();
            }
            employmentHistoryItem.employerAddress.suburb = app.Current_Work_Suburb_2__c;
            employmentHistoryItem.employerAddress.unitNumber = app.Current_Work_Unit_Number_2__c;
        }
        
        employmentHistoryItems.add(employmentHistoryItem);
        Integer previousEmployments = 0;
        
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, toLabel(Street_Type__c),
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: app.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c =: String.valueOf(applicant)];
        
        for (Application_Employment__c e: lst) {
            previousEmployments++;
            employmentHistoryItem = new LatitudeAPIRequestDTO.EmploymentHistoryItem();	
            employmentHistoryItem.activity = LatitudeUtils.getActivity(e.Employment_Type__c);
            employmentHistoryItem.current = true;
            if(
              !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
              !'PENSIONER'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
              !'RETIRED'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
              !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(e.Employment_Type__c))
            ){
                Date todayDate = Date.today();
                employmentHistoryItem.duration = e.Start_Date__c.monthsBetween(Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day()));
                employmentHistoryItem.employerName = e.Employer_Name__c;
                employmentHistoryItem.employerPhone = e.Phone__c;
                employmentHistoryItem.occupation = e.Occupation__c;
            }
            employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
            employmentHistoryItem.employerAddress.country = 'AU';
            employmentHistoryItem.employerAddress.state = e.State__c;
            employmentHistoryItem.employerAddress.postcode = e.Postcode__c;
            employmentHistoryItem.employerAddress.streetName = e.Work_Address__c;
            employmentHistoryItem.employerAddress.streetNumber = e.Street_Number__c;
            employmentHistoryItem.employerAddress.streetType = e.Street_Type__c.toUppercase();
            employmentHistoryItem.employerAddress.suburb = e.Suburb__c;
            employmentHistoryItem.employerAddress.unitNumber = e.Unit_Number__c;
            employmentHistoryItems.add(employmentHistoryItem);
        }
        
        if(applicant == 1){
            if (app.Previous_Work_Country_1__c != null && 
                (String.isNotBlank(app.Start_Date_1__c)
                 || String.isNotBlank(app.Finish_Date_1__c)
                 || String.isNotBlank(app.Previous_Work_Address_1__c)
                 || String.isNotBlank(app.Previous_Mode_of_Employment_1__c))) {
                     previousEmployments++;
                     employmentHistoryItem = new LatitudeAPIRequestDTO.EmploymentHistoryItem();			 
                     employmentHistoryItem.activity = LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_1__c);
                     employmentHistoryItem.current = false;
                     if(
                       !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_1__c)) && 
                       !'PENSIONER'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_1__c)) && 
                       !'RETIRED'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_1__c)) && 
                       !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_1__c))
                     ){
                         Date startDatePE = Date.parse(app.Start_Date_1__c);
                         Date finishPE = Date.parse(app.Finish_Date_1__c);
                         employmentHistoryItem.duration = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
                         employmentHistoryItem.employerName = app.Previous_Employer_Name_1__c;
                         employmentHistoryItem.employerPhone = app.Previous_Employer_Phone_1__c;
                         employmentHistoryItem.occupation = app.Previous_Occupation_1__c;
                     }
                     employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Work_Country_1__c)){
                         if('AUS'.equals(app.Previous_Work_Country_1__c)){
                             employmentHistoryItem.employerAddress.country = 'AU';
                             employmentHistoryItem.employerAddress.state = app.Previous_Work_State_1__c;
                             employmentHistoryItem.employerAddress.streetName = app.Previous_Work_Address_1__c;
                             employmentHistoryItem.employerAddress.streetNumber = app.Previous_Work_Street_Number_1__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Work_Street_Type_1__c))){
                                 employmentHistoryItem.employerAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Work_Street_Type_1__c).toUppercase();
                             }
                             employmentHistoryItem.employerAddress.suburb = app.Previous_Work_Suburb_1__c;
                             employmentHistoryItem.employerAddress.unitNumber = app.Previous_Work_Unit_Number_1__c;
                         }else{
                             employmentHistoryItem.employerAddress.country = 'OTHER';
                             employmentHistoryItem.employerAddress.state = app.Previous_Work_Overseas_State_1__c;
                             employmentHistoryItem.employerAddress.streetName = street(app.Previous_Work_Address_1__c, app.Previous_Work_Address_2nd_1__c);
                             employmentHistoryItem.employerAddress.suburb = app.Previous_Work_Overseas_City_1__c;
                         }
                     }
                     employmentHistoryItem.employerAddress.postcode = app.Previous_Work_Postcode_1__c;
                     
                     employmentHistoryItems.add(employmentHistoryItem);
                 }
        }
        
        if(applicant == 2){
            if (app.Previous_Work_Country_2__c != null && 
                (String.isNotBlank(app.Start_Date_2__c)
                 || String.isNotBlank(app.Finish_Date_2__c)
                 || String.isNotBlank(app.Previous_Work_Address_2__c)
                 || String.isNotBlank(app.Previous_Mode_of_Employment_2__c))) {
                     previousEmployments++;
                     employmentHistoryItem = new LatitudeAPIRequestDTO.EmploymentHistoryItem();				 
                     employmentHistoryItem.activity = LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_2__c);
                     employmentHistoryItem.current = false;
                     if(
                       !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_2__c)) && 
                       !'PENSIONER'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_2__c)) && 
                       !'RETIRED'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_2__c)) && 
                       !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(app.Previous_Mode_of_Employment_2__c))
                     ){
                         Date startDatePE = Date.parse(app.Start_Date_2__c);
                         Date finishPE = Date.parse(app.Finish_Date_2__c);
                         employmentHistoryItem.duration = startDatePE.monthsBetween(Date.newInstance(finishPE.year(), finishPE.month(), finishPE.day()));
                         employmentHistoryItem.employerName = app.Previous_Employer_Name_2__c;
                         employmentHistoryItem.employerPhone = app.Previous_Employer_Phone_2__c;
                         employmentHistoryItem.occupation = app.Previous_Occupation_2__c;
                     }
                     employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
                     if(String.isNotBlank(app.Previous_Work_Country_2__c)){
                         if('AUS'.equals(app.Previous_Work_Country_2__c)){
                             employmentHistoryItem.employerAddress.country = 'AU';
                             employmentHistoryItem.employerAddress.state = app.Previous_Work_State_2__c;
                             employmentHistoryItem.employerAddress.streetName = app.Previous_Work_Address_2__c;
                             employmentHistoryItem.employerAddress.streetNumber = app.Previous_Work_Street_Number_2__c;
                             if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Work_Street_Type_2__c))){
                                 employmentHistoryItem.employerAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), app.Previous_Work_Street_Type_2__c).toUppercase();
                             }
                             employmentHistoryItem.employerAddress.suburb = app.Previous_Work_Suburb_2__c;
                             employmentHistoryItem.employerAddress.unitNumber = app.Previous_Work_Unit_Number_2__c;
                         }else{
                             employmentHistoryItem.employerAddress.country = 'OTHER';
                             employmentHistoryItem.employerAddress.state = app.Previous_Work_Overseas_State_2__c;
                             employmentHistoryItem.employerAddress.streetName = street(app.Previous_Work_Address_2__c, app.Previous_Work_Address_2nd_2__c);
                             employmentHistoryItem.employerAddress.suburb = app.Previous_Work_Overseas_City_2__c;
                         }
                     }
                     employmentHistoryItem.employerAddress.postcode = app.Previous_Work_Postcode_2__c;
                     
                     employmentHistoryItems.add(employmentHistoryItem);
                 }
        }
        
        if(!previousEmp.isEmpty()){
            for (String a: previousEmp.keySet()) {
                if(a.equals(String.valueOf(applicant))){
                    List < Application_Employment__c > employments = previousEmp.get(a);
                    for (Application_Employment__c e: employments) {
                        if('Previous Job'.equals(e.Type__c)){
                            if(previousEmployments < 2){
                                previousEmployments++;
                                employmentHistoryItem = new LatitudeAPIRequestDTO.EmploymentHistoryItem();
                                employmentHistoryItem.activity = LatitudeUtils.getActivity(e.Employment_Type__c);
                                employmentHistoryItem.current = false;
                                if(
                                  !'HOME_DUTIES'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
                                  !'PENSIONER'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
                                  !'RETIRED'.equals(LatitudeUtils.getActivity(e.Employment_Type__c)) && 
                                  !'UNEMPLOYED'.equals(LatitudeUtils.getActivity(e.Employment_Type__c))
                                ){
                                    System.debug(e.Start_Date__c);
                                    System.debug(e.Finish_Date__c);
                                    employmentHistoryItem.duration = e.Start_Date__c.monthsBetween(Date.newInstance(e.Finish_Date__c.year(), e.Finish_Date__c.month(), e.Finish_Date__c.day()));
                                    employmentHistoryItem.employerName = e.Employer_Name__c;
                                    employmentHistoryItem.employerPhone = e.Phone__c;
                                    employmentHistoryItem.occupation = e.Occupation__c;
                                }
                                employmentHistoryItem.employerAddress = new LatitudeAPIRequestDTO.AddressDetails();
                                if(String.isNotBlank(e.Country__c)){
                                    if('AUS'.equals(e.Country__c)){
                                        employmentHistoryItem.employerAddress.country = 'AU';
                                        employmentHistoryItem.employerAddress.state = e.State__c;
                                        employmentHistoryItem.employerAddress.streetName = e.Work_Address__c;
                                        employmentHistoryItem.employerAddress.streetNumber = e.Street_Number__c;
                                        if(String.isNotBlank(LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), e.Street_Type__c))){
                                            employmentHistoryItem.employerAddress.streetType = LatitudeUtils.getLabelPicklistField(Application__c.Street_Type__c.getDescribe(), e.Street_Type__c).toUppercase();
                                        }
                                        employmentHistoryItem.employerAddress.suburb = e.Suburb__c;
                                        employmentHistoryItem.employerAddress.unitNumber = e.Unit_Number__c;
                                    }else{
                                        employmentHistoryItem.employerAddress.country = 'OTHER';
                                        employmentHistoryItem.employerAddress.state = e.Overseas_State__c;
                                        employmentHistoryItem.employerAddress.streetName = street(e.Address_Line_1__c, e.Address_Line_2__c);
                                        employmentHistoryItem.employerAddress.suburb = e.Overseas_City__c;
                                    }
                                }
                                employmentHistoryItem.employerAddress.postcode = e.Postcode__c;
                                
                                employmentHistoryItems.add(employmentHistoryItem);
                            }
                        }
                    }
                }
            }
        }
        return employmentHistoryItems;
    }
    
    private Decimal getLivingExpenses(Application__c app){
        Decimal livingExpenses = 0;
        if(String.isNotBlank(app.Basic_Living_Expenses_Per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Basic_Living_Expenses_Per_Month__c, false);
        }
        if(String.isNotBlank(app.Childcare_Child_Maintenance_Per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Childcare_Child_Maintenance_Per_Month__c, false);
        }
        if(String.isNotBlank(app.Mobile_Phone_Internet_Pay_TV_per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
        }
        if(String.isNotBlank(app.Insurance_Expenses_per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Insurance_Expenses_per_Month__c, false);
        }
        if(String.isNotBlank(app.Travel_Transport_Expenses_per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Travel_Transport_Expenses_per_Month__c, false);
        }
        if(String.isNotBlank(app.Other_Expenses_per_Month__c)){
            livingExpenses += NumberUtils.convertToDecimal(app.Other_Expenses_per_Month__c, false);
        }
        
        return livingExpenses;
    }
    
    private List<LatitudeAPIRequestDTO.CreditCard> getCreditCard(Application__c app){
        List<LatitudeAPIRequestDTO.CreditCard> creditCards = new List<LatitudeAPIRequestDTO.CreditCard>();
        
        List<Application_Credit_Card__c> liabilities = [SELECT Id, Name, Amount_Owing__c, Application__c, Issuer__c, Limit__c, Monthly_Payment__c, Is_Payout__c
                                                        FROM Application_Credit_Card__c WHERE Application__c = :app.Id];
        
        LatitudeAPIRequestDTO.CreditCard c;
        
        for (Application_Credit_Card__c l : liabilities) {
            c = new LatitudeAPIRequestDTO.CreditCard();
            c.creditLimit = getCents2(l.Limit__c);
            c.currentBalance = getCents2(l.Amount_Owing__c);
            c.issuer = 'OTHER';
            creditCards.add(c);
        }														 
        
        return creditCards;
    }
    
    private List<LatitudeAPIRequestDTO.InvestmentProperty> getInvestmentProperty(Custom_Opportunity__c opp, Application__c app, Integer applicant){
        List<LatitudeAPIRequestDTO.InvestmentProperty> investmentProperties = new List<LatitudeAPIRequestDTO.InvestmentProperty>();
        
        List < Application_Income__c > otherIncome = otherIncomeMap.get(String.valueOf(applicant));
        List<Application_Other_Asset__c> property;
        if(applicant == 1){
            property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                       Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                       FROM Application_Other_Asset__c WHERE Application__c = :app.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Property Applicant 1' OR Category__c = 'Property Both Applicants')];
        }
        
        if(applicant == 2){
            property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                       Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                       FROM Application_Other_Asset__c WHERE Application__c = :app.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Property Applicant 2' OR Category__c = 'Property Both Applicants')];
        }
        
        if(otherIncome != null){
            for (Application_Income__c income: otherIncome) {
                if(String.isNotBlank(income.Application_Other_Asset__c) && ('Investment Property'.equals(income.Type__c) || 'Rental Income'.equals(income.Type__c))){
                    for (Application_Other_Asset__c p : property) {
                        
                        if(income.Application_Other_Asset__c.equals(p.Id)){
                            if(app.No_of_People__c == 1){
                                LatitudeAPIRequestDTO.InvestmentProperty investment = new LatitudeAPIRequestDTO.InvestmentProperty();
                                investment.estimatedValue = getCents2(p.Value__c);
                                
                                if('Y'.equals(p.Has_Loan__c)){
                                    investment.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                                    investment.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                                    investment.mortgage.mortgagee = 'OTHER';
                                    investment.mortgage.repaymentFrequency = 'MONTHLY';
                                    investment.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);
                                    if(opp.ApplicationServicing__c != null){
                                        if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                                            if(opp.ApplicationServicing__r.Is_Split_Rent_Mortgage__c){
                                                investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c/2);
                                                investment.mortgage.sharedMortgage = true;
                                            }else{
                                                investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                                investment.mortgage.sharedMortgage = false;
                                            }
                                        }else{
                                            investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                            investment.mortgage.sharedMortgage = false;
                                        }
                                    }else{
                                        investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                        investment.mortgage.sharedMortgage = false;
                                    }
                                }
                                investment.rentalIncomeAmount = getCents2(income.Income__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(income.Frequency__c, 'Monthly'));
                                investment.rentalIncomeFrequency = 'MONTHLY';
                                investmentProperties.add(investment);
                            }
                            
                            
                            if('Property Both Applicants'.equals(p.Category__c) && app.No_of_People__c == 2){
                                if(opp.ApplicationServicing__c != null){
                                    if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                                        LatitudeAPIRequestDTO.InvestmentProperty investment = new LatitudeAPIRequestDTO.InvestmentProperty();
                                        investment.estimatedValue = getCents2(p.Value__c/2);
                                        if('Y'.equals(p.Has_Loan__c)){
                                            investment.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                                            investment.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c/2);
                                            investment.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c/2);
                                            investment.mortgage.mortgagee = 'OTHER';
                                            investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c/2);
                                            investment.mortgage.repaymentFrequency = 'MONTHLY';
                                            investment.mortgage.sharedMortgage = true;
                                        }
                                        investment.rentalIncomeAmount = getCents2(income.Income__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(income.Frequency__c, 'Monthly'));
                                        investment.rentalIncomeFrequency = 'MONTHLY';
                                        investmentProperties.add(investment);
                                    }else{
                                        if(applicant == 1){
                                            LatitudeAPIRequestDTO.InvestmentProperty investment = new LatitudeAPIRequestDTO.InvestmentProperty();
                                            investment.estimatedValue = getCents2(p.Value__c);
                                            if('Y'.equals(p.Has_Loan__c)){
                                                investment.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                                                investment.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                                                investment.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);
                                                investment.mortgage.mortgagee = 'OTHER';
                                                investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                                investment.mortgage.repaymentFrequency = 'MONTHLY';
                                                investment.mortgage.sharedMortgage = false;
                                            }
                                            investment.rentalIncomeAmount = getCents2(income.Income__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(income.Frequency__c, 'Monthly'));
                                            investment.rentalIncomeFrequency = 'MONTHLY';
                                            investmentProperties.add(investment);
                                        }
                                    }
                                    
                                }else{
                                    if(applicant == 1){
                                        LatitudeAPIRequestDTO.InvestmentProperty investment = new LatitudeAPIRequestDTO.InvestmentProperty();
                                        investment.estimatedValue = getCents2(p.Value__c);
                                        if('Y'.equals(p.Has_Loan__c)){
                                            investment.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                                            investment.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                                            investment.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);
                                            investment.mortgage.mortgagee = 'OTHER';
                                            investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                            investment.mortgage.repaymentFrequency = 'MONTHLY';
                                            investment.mortgage.sharedMortgage = false;
                                        }
                                        investment.rentalIncomeAmount = getCents2(income.Income__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(income.Frequency__c, 'Monthly'));
                                        investment.rentalIncomeFrequency = 'MONTHLY';
                                        investmentProperties.add(investment);
                                    }
                                }
                            }
                            
                            if(!'Property Both Applicants'.equals(p.Category__c) && app.No_of_People__c == 2){
                                LatitudeAPIRequestDTO.InvestmentProperty investment = new LatitudeAPIRequestDTO.InvestmentProperty();
                                investment.estimatedValue = getCents2(p.Value__c);
                                if('Y'.equals(p.Has_Loan__c)){
                                    investment.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                                    investment.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                                    investment.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);
                                    investment.mortgage.mortgagee = 'OTHER';
                                    investment.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                    investment.mortgage.repaymentFrequency = 'MONTHLY';
                                    if(opp.ApplicationServicing__c != null){
                                        if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                                            investment.mortgage.sharedMortgage = true;
                                        }else{
                                            investment.mortgage.sharedMortgage = false;
                                        }
                                    }else{
                                        investment.mortgage.sharedMortgage = false;
                                    }
                                }
                                investment.rentalIncomeAmount = getCents2(income.Income__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(income.Frequency__c, 'Monthly'));
                                investment.rentalIncomeFrequency = 'MONTHLY';
                                investmentProperties.add(investment);
                            }
                        }
                    }
                }
            }
        }
        return investmentProperties;
    }
    
    private List<LatitudeAPIRequestDTO.LoanDetails> getLoanDetails(Application__c app){
        List<LatitudeAPIRequestDTO.LoanDetails> loanDetails = new List<LatitudeAPIRequestDTO.LoanDetails>();
        List < Application_Loan__c > otherLoans = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c,
                                                   Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c, Order__c
                                                   FROM Application_Loan__c WHERE Application__c =: app.Id ORDER BY Order__c
                                                  ];
        
        for (Application_Loan__c l : otherLoans) {
            LatitudeAPIRequestDTO.LoanDetails loan = new LatitudeAPIRequestDTO.LoanDetails();
            loan.currentAtSettlement = true;
            loan.lender = 'OTHER';
            loan.originalAmount = getCents2(l.Amount_Owing__c);
            loan.outstandingBalance = getCents2(l.Amount_Owing__c);
            loan.repaymentAmount = getCents(l.Payment__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(l.Frequency__c, 'Monthly'));
            loan.repaymentFrequency = 'MONTHLY';
            loan.type = LatitudeUtils.getLoanType(l.Type__c);
            loanDetails.add(loan);
        }
        
        List<Application_Other_Asset__c> vehicle = [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                    Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c 
                                                    FROM Application_Other_Asset__c WHERE Application__c = :app.Id AND RecordType.Name = :'Vehicle Asset'
                                                    AND Has_Loan__c = 'Y'];
        
        for (Application_Other_Asset__c l : vehicle) {
            LatitudeAPIRequestDTO.LoanDetails loan = new LatitudeAPIRequestDTO.LoanDetails();
            loan.currentAtSettlement = true;
            loan.lender = 'OTHER';
            loan.originalAmount = getCents2(l.Amount_Owing__c);
            loan.outstandingBalance = getCents2(l.Amount_Owing__c);
            loan.repaymentAmount = getCents2(l.Monthly_Payment__c);
            loan.repaymentFrequency = 'MONTHLY';
            loan.type = 'AUTOMOTIVE';
            loanDetails.add(loan);
        }		
        
        return loanDetails;
    }
    
    private List<LatitudeAPIRequestDTO.ResidentialProperty> getResidentialProperty(Custom_Opportunity__c opp, Application__c app, Integer applicant){
        List<LatitudeAPIRequestDTO.ResidentialProperty> residentialProperties = new List<LatitudeAPIRequestDTO.ResidentialProperty>();
        LatitudeAPIRequestDTO.ResidentialProperty residential;
        List<Application_Other_Asset__c> property;
        if(applicant == 1){
            property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                       Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                       FROM Application_Other_Asset__c WHERE Application__c = :app.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Current Address Applicant 1' OR Category__c = 'Current Address Both Applicants')];
        }
        
        if(applicant == 2){
            property= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                       Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c, Category__c 
                       FROM Application_Other_Asset__c WHERE Application__c = :app.Id AND RecordType.Name = 'Property Asset' AND (Category__c = 'Current Address Applicant 2' OR Category__c = 'Current Address Both Applicants')];
        }
        
        for (Application_Other_Asset__c p : property) {
            if(app.No_of_People__c == 1){
                residential = new LatitudeAPIRequestDTO.ResidentialProperty();
                residential.estimatedValue = getCents2(p.Value__c);
                if('Y'.equals(p.Has_Loan__c)){
                    residential.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                    residential.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                    residential.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);	
                    residential.mortgage.mortgagee = 'OTHER';
                    residential.mortgage.repaymentFrequency = 'MONTHLY';
                    if(opp.ApplicationServicing__c != null){
                        if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                            if(opp.ApplicationServicing__r.Is_Split_Rent_Mortgage__c){
                                residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c/2);
                                residential.mortgage.sharedMortgage = true;
                            }else{
                                residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                                residential.mortgage.sharedMortgage = false;
                            }
                        }else{
                            residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                            residential.mortgage.sharedMortgage = false;
                        }
                    }else{
                        residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                        residential.mortgage.sharedMortgage = false;
                    }
                }
                residentialProperties.add(residential);
            }
            if('Current Address Both Applicants'.equals(p.Category__c) && app.No_of_People__c == 2){
              residential = new LatitudeAPIRequestDTO.ResidentialProperty();	
              residential.estimatedValue = getCents2(p.Value__c/2);
              if('Y'.equals(p.Has_Loan__c)){
                residential.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                residential.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c/2);
                residential.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c/2);
                residential.mortgage.mortgagee = 'OTHER';
                residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c/2);
                residential.mortgage.repaymentFrequency = 'MONTHLY';
                residential.mortgage.sharedMortgage = true;
              }
              residentialProperties.add(residential);
            }
            
            if(!'Current Address Both Applicants'.equals(p.Category__c) && app.No_of_People__c == 2){
                residential = new LatitudeAPIRequestDTO.ResidentialProperty();
                residential.estimatedValue = getCents2(p.Value__c);
                
                if('Y'.equals(p.Has_Loan__c)){
                    residential.mortgage = new LatitudeAPIRequestDTO.Mortgage();
                    residential.mortgage.mortgageOriginalAmount = getCents2(p.Amount_Owing__c);
                    residential.mortgage.mortgageOutstandingBalance = getCents2(p.Amount_Owing__c);
                    residential.mortgage.mortgagee = 'OTHER';
                    residential.mortgage.repaymentAmount = getCents2(p.Monthly_Payment__c);
                    residential.mortgage.repaymentFrequency = 'MONTHLY';
                    if(opp.ApplicationServicing__c != null){
                        if(opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                            residential.mortgage.sharedMortgage = true;
                        }else{
                            residential.mortgage.sharedMortgage = false;
                        }
                    }else{
                        residential.mortgage.sharedMortgage = false;
                    }
                }
                residentialProperties.add(residential);
            }
        }
        
        return residentialProperties;
    }
    
    private Long getCents(Decimal a){
        Decimal cents = a * 100;
        return cents.intValue();
    }
    
    private Long getCents2(Decimal a){
        return a.intValue() * 100;
    }
    
    private Decimal getSecondJobIncome(Application__c app, Integer applicant){
        List < Application_Employment__c > secondJobIncome = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: app.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c =: String.valueOf(applicant)];
        
        if(!secondJobIncome.isEmpty()){
            Application_Employment__c e = secondJobIncome.get(0);
            return LatitudeUtils.getMonthlyIncome(e.Frequency__c, e.Income__c);
        }else{
            return null;
        }			
    }
    
    private Decimal getOtherIncome(Integer applicant){
        Decimal income;
        List < Application_Income__c > otherIncome = otherIncomeMap.get(String.valueOf(applicant));
        
        if(otherIncome != null){
            income = 0;
            
            for (Application_Income__c i: otherIncome) {
                if(!'Invesment Property'.equals(i.Type__c) && !'Rental Income'.equals(i.Type__c)){
                    income += LatitudeUtils.getMonthlyIncome(i.Frequency__c, i.Income__c);
                }
            }
        }
        
        return income;													 
    }
    
    public Boolean otherIncomeSecondJob(Integer applicant){
        List < Application_Income__c > otherIncome;
        
        if(otherIncomeMap != null){
            otherIncome = otherIncomeMap.get(String.valueOf(applicant));
        }
        
        if(otherIncome != null){
            for (Application_Income__c i: otherIncome) {
                if('Second Job'.equals(i.Type__c)){
                    return true;
                }
            }
        }
        
        return false;
    }
    
    public String street(String address1, String address2){
        String street;
        
        if(String.isNotBlank(address2)){
            street = address1+' '+address2;
        }else{
            street = address1;
        }
        
        return street;
    }
    
    public List < Application_Income__c > getOtherIncomes(List < Application_Income__c > income, List < Application_Income__c > otherIncome){
        
        if(income != null){
            for (Application_Income__c i: income) {
                if(String.isNotBlank(i.Application_Other_Asset__c) && ('Investment Property'.equals(i.Type__c) || 'Rental Income'.equals(i.Type__c))){
                    otherIncome.add(i);
                }
            }
        }
        
        return otherIncome;
    }
    
    public List < Application_Income__c > getOtherIncomes2(List < Application_Income__c > income, List < Application_Income__c > otherIncome){
        
        if(income != null){
            for (Application_Income__c i: income) {
                if(String.isBlank(i.Application_Other_Asset__c) && ('Investment Property'.equals(i.Type__c) || 'Rental Income'.equals(i.Type__c))){
                    otherIncome.add(i);
                }
            }
        }
        
        return otherIncome;
    }

    public void loadAPIParameters () {
      endpoint1Param = APIServiceManager.getParameterService(PARAM_ENDPOINT1);
      endpoint2Param = APIServiceManager.getParameterService(PARAM_ENDPOINT2);
      clientIdParam = APIServiceManager.getParameterService(PARAM_CLIENTID);
      secrectParam = APIServiceManager.getParameterService(PARAM_CLIENTSECRET);
      
      System.debug('endpoint1Param => ' + endpoint1Param);
      System.debug('endpoint2Param => ' + endpoint2Param);
      System.debug('clientIdParam => ' + clientIdParam);
      System.debug('secrectParam => ' + secrectParam);
    }
    
    public Long dependants(Application__c app, Integer applicant){
        if(partner(app)){
            Integer dependants = app.No_of_Dependants_1__c.intValue() + app.No_of_Dependants_2__c.intValue();
            if(Math.mod(dependants, 2) == 0){
                return dependants/2;
            }else{
                return dependants;
            }
        }else if(applicant == 1){
            return app.No_of_Dependants_1__c.intValue();
        }else{
            return app.No_of_Dependants_2__c.intValue();
        }
    }
    
    public Boolean partner(Application__c app){
        if(('MARRIED'.equalsIgnoreCase(app.Marital_Status_1__c) || 'DEFACTO'.equalsIgnoreCase(app.Marital_Status_1__c)) &&
           ('MARRIED'.equalsIgnoreCase(app.Marital_Status_2__c) || 'DEFACTO'.equalsIgnoreCase(app.Marital_Status_2__c)) &&
           app.Marital_Status_1__c.equals(app.Marital_Status_2__c) && 'Yes'.equals(app.Applicant_2_living_in_the_same_address__c) && app.No_of_People__c == 2){
               return true;
           }else{
               return false;    
           }
    }
    
    public String phoneWork(String phone){
        if(String.isBlank(phone)){
            phone = '0233223322';
        } 
        return phone;
    }

    public Decimal livingSameAddress(Application__c app, Decimal amount) {
      if('Yes'.equals(app.Applicant_2_living_in_the_same_address__c) && app.No_of_People__c == 2) {
        return amount/2;
      }
      return amount;
    }
}