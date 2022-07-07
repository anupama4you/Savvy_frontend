public class FinanceOneUtils {
    public static String loanPurposes(String typeOfAsset){
        String loanPurpose;
        if(typeOfAsset.equals('Car')){
            loanPurpose = 'motor_vehicle'; 
        }
        
        if(typeOfAsset.equals('Boat')){
            loanPurpose = 'watercraft'; 
        }
        
        if(typeOfAsset.equals('Motorbike')){
            loanPurpose = 'motor_bike'; 
        }
        
        if(typeOfAsset.equals('Caravan')){
            loanPurpose = 'caravan'; 
        }

        if (typeOfAsset.equals('Equipment')) {
          loanPurpose = 'plant_and_equipment';
        }

        if (typeOfAsset.equals('Truck')) {
          loanPurpose = 'truck';
        }

        return loanPurpose;
    }
    
    public static String sex(String Gender){
        String sex;
        if(Gender.equals('Others')){
            sex = 'other';   
        }else{
            sex = Gender.toLowercase();   
        }
        return sex;
    }
    
    public static String residencyStatus(String currentResidentialStatus){
        String residencyStatus;
        if(currentResidentialStatus.equals('Australian Citizen')){
            residencyStatus = 'citizen'; 
        }
        /*
if(currentResidentialStatus.equals('Working VISA') || currentResidentialStatus.equals('Student VISA') 
|| currentResidentialStatus.equals('Student VISA') || currentResidentialStatus.equals('Spouse VISA')
|| currentResidentialStatus.equals('Temporary VISA')){
residencyStatus = 'visa'; 
}
*/
        if(currentResidentialStatus.equals('Working VISA') || currentResidentialStatus.equals('Spouse VISA')){
            residencyStatus = 'visa'; 
        }
        if(currentResidentialStatus.equals('PR VISA')){
            residencyStatus = 'permanent_resident'; 
        }
        
        if(currentResidentialStatus.equals('Other')){
            residencyStatus = 'other'; 
        }
        return residencyStatus;
    }
    
    public static String maritalStatus(String maritalStatus){
        String status;
        if(maritalStatus.equals('Defacto')){
            status = 'de_facto';   
        }else{
            status = maritalStatus.toLowercase();   
        }
        return status;
    }
    
    public static String residential(String residential){
        String r;
        if(residential.equals('Renting(Agent)') || residential.equals('Renting(Private)')){
            r = 'renting';
        }
        
        if(residential.equals('Boarding')){
            r = 'boarding';
        }
        
        if(residential.equals('Own Outright')){
            r = 'owned_outright';
        }
        
        if(residential.equals('Mortgage')){
            r = 'owned_under_finance';
        }
        
        if(residential.equals('Parents/Relative')){
            r = 'living_with_relatives';
        }
        
        if(residential.equals('Employer Accommodation')){
            r = 'employer_provided';
        }
        return r;
    }
    
    public static String employment(String e){
        String basis;
        if(e.equals('Full Time')){
            basis = 'full_time';
        }
        
        if(e.equals('Part Time')){
            basis = 'part_time';
        }
        
        if(e.equals('Casual')){
            basis = 'casual';
        }
        
        if(e.equals('Unemployed') || e.equals('Centrelink - Family Tax Benefits/Other') || e.equals('Contract')){
            basis = 'other';
        }
        
        return basis;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    }
    
    public static String income(String i){
        String income;
        
        if('Rental Income'.equals(i) || 'Investment Property'.equals(i)){
            income = 'rental_income';  
        }
        
        if('Maintenance'.equals(i)){
            income = 'maintenance_income';  
        }
        
        if('Other'.equals(i) || 'Superannuation'.equals(i) || 'Trust Income'.equals(i)){
            income = 'other_income';  
        }
        
        if('Self Employed'.equals(i)){
            income = 'business_income';  
        }
        
        if('Investment Income'.equals(i)){
            income = 'dividends';  
        }
        
        if('Full Time'.equals(i) || 'Part Time'.equals(i) || 'Casual'.equals(i) || 'Contract'.equals(i)){
            income = 'payg_income';  
        }
        
        if('Centrelink - Family Tax Benefits/Other'.equals(i) || 'Child Support'.equals(i) || 'Family Part A & B'.equals(i) || 'Parenting Payment Partnered'.equals(i) || 'Parenting Payment Single'.equals(i) || 'Rent Assistance'.equals(i)){
            income = 'benefit_family_tax';  
        }
        
        if('Carers Payment'.equals(i)){
            income = 'benefit_carer_pension';  
        }
        
        if('Newstart'.equals(i) || 'Centrelink - Newstart only'.equals(i)){
            income = 'benefit_newstart_family';  
        }
        
        return income;
    }
    
    public static String liabilities(String l){
        String liability;
        
        if(l.equals('Payday Loan')){
            liability = 'payday_loan';  
        }
        
        if(l.equals('Personal Loan') || l.equals('Debt/Default Arrangements') || l.equals('Line of Credit')){
            liability = 'personal_loan';  
        }
        
        if(l.equals('Other')){
            liability = 'loan';  
        }
        
        return liability;
    }
    
    public static String productTypeId(String loanProduct, String loanFacilityType){
        String productTypeId;
        
        if(loanProduct.equals('Consumer Loan')){
            if(loanFacilityType.equals('Platinum')){
                productTypeId = 'CON.S.PLAT';   
            }
            
            if(loanFacilityType.equals('Gold')){
                productTypeId = 'CON.S.GOL';  
            }
            
            if(loanFacilityType.equals('Silver')){
                productTypeId = 'CON.S.SIL';  
            }
            
            if(loanFacilityType.equals('Economy')){
                productTypeId = 'CON.S.ECO';  
            }
            
            if(loanFacilityType.equals('Bronze')){
                productTypeId = 'CON.S.BRO';  
            }
        }else{
            if(loanFacilityType.equals('Gold')){
                productTypeId = 'COM.S.GOL';  
            }
            
            if(loanFacilityType.equals('Silver')){
                productTypeId = 'COM.S.SIL';  
            }
            
            if(loanFacilityType.equals('Bronze')){
                productTypeId = 'COM.S.BRO';  
            }

            if(loanFacilityType.equals('Platinum')){
                productTypeId = 'COM.S.PLAT';  
            }
        }
        
        return productTypeId;
    }
    
    public static String entityType(String t){
        String entityType;
        
        if(t.equals('Individual or Sole Trader')){
            entityType = 'sole_trader';
        }
        
        if(t.equals('Partnership')){
            entityType = 'partnership';
        }
        
        if(t.equals('Company')){
            entityType = 'company';
        }
        
        if(t.equals('Trust')){
            entityType = 'trust';
        }
        
        return entityType;
    }
    
    public static String insuranceType(String t){
        String insuranceType;
        
        if('Gap Insurance'.equals(t)){
            insuranceType = 'gap';
        }
        
        if('Warranty'.equals(t)){
            insuranceType = 'warranty';
        }
        
        if('LTI'.equals(t) || 'CCI'.equals(t)){
            insuranceType = 'consumer_credit';
        }
        /*
if('Type and Rim Insurance'.equals(t)){
insuranceType = 'other';
}
*/
        if('Full Comprehensive'.equals(t)){
            insuranceType = 'comprehensive';
        }
        
        return insuranceType;
    }
    
    public static String getContentType(String file){
        String contentType;
        String[] extension;
        if(file != null){
            extension = file.split('\\.');
        }
        if(extension != null){
            if('pdf'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'application/pdf';
            }
            
            if('doc'.equalsIgnoreCase(extension[extension.size()-1]) || 'dot'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'application/msword';
            }
            
            if('docx'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            
            if('png'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'image/png';
            }
            
            if('gif'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'image/gif';
            }
            
            if('jpeg'.equalsIgnoreCase(extension[extension.size()-1]) || 'jpg'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'image/jpeg';
            }
            
            if('pjpeg'.equalsIgnoreCase(extension[extension.size()-1])){
                contentType = 'image/pjpeg';
            }
        }
        return contentType;
    }
    
    public static String getVehicleLicenceType(String t){
        String licenceType;
        
        if('FULL'.equals(t) || 'HEAVY_VEHICLE'.equals(t)){
            licenceType = 'open';
        }
        
        if('LEARNER'.equals(t)){
            licenceType = 'learner';
        }
        
        if('PROVISIONAL'.equals(t)){
            licenceType = 'provisional';
        }
        
        return licenceType;
    }
    
    public static Decimal getMonthlyIncome(String frecuency, Decimal income){
        Decimal monthlyIncome;
        monthlyIncome =  income * OppApplicationServCalculatorUtils.getFrecuencyFactor(frecuency, 'Monthly');
        return monthlyIncome;
    }
    
    public static String benefit(String b){
        String benefit;
        
        if('Centrelink - Family Tax Benefits/Other'.equals(b) || 'Child Support'.equals(b) || 'Family Part A & B'.equals(b) || 'Parenting Payment Partnered'.equals(b) || 'Parenting Payment Single'.equals(b) || 'Rent Assistance'.equals(b)){
            benefit = 'benefit_family_tax';  
        }
        
        if('Centrelink - Newstart only'.equals(b) || 'Newstart'.equals(b)){
            benefit = 'benefit_newstart_family';  
        }
        
        if('Carers Payment'.equals(b)){
            benefit = 'benefit_carer_pension';  
        }		
        
        return benefit;
    }
}