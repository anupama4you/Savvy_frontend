public class LatitudeUtils {
    
    public static String getResidential(String r){
        
        String residential;
        
        if('Parents/Relative'.equals(r)){
            residential = 'BOARDING_PARENTS'; 
        }
        
        if('Boarding'.equals(r)){
            residential = 'BOARDING_OTHER'; 
        }
        
        if('Own Outright'.equals(r)){
            residential = 'OWNER'; 
        }
        
        if('Renting(Agent)'.equals(r) || 'Renting(Private)'.equals(r)){
            residential = 'RENTING'; 
        }
        
        if('Mortgage'.equals(r)){
            residential = 'BUYING'; 
        }
        
        return residential;
    }
    
    public static String getActivity(String a){
        
        String activity;
        if('Casual'.equals(a)){
            activity = 'CASUAL'; 
        }
        /*
if(''.equals(a)){
activity = 'COMPENSATION'; 
}
*/
        if('Full Time'.equals(a)){
            activity = 'FULL_TIME'; 
        }
        
        if('Financially Supported by Partner'.equals(a)){
            activity = 'HOME_DUTIES'; 
        }
        
        if('Part Time'.equals(a)){
            activity = 'PART_TIME'; 
        }
        /*
if(''.equals(a)){
activity = 'RETIRED'; 
}

if(''.equals(a)){
activity = 'PENSIONER'; 
}
*/
        if('Unemployed'.equals(a)){
            activity = 'UNEMPLOYED'; 
        }
        
        if('Self Employed'.equals(a)){
            activity = 'SELF_EMPLOYED'; 
        }
        
        if('Contract'.equals(a)){
            activity = 'FIXED_TERM_CONTRACT'; 
        }
        
        return activity;
    }
    
    public static String getLoanType(String l){
        String loanType;
        
        if('Debt/Default Arrangements'.equals(l) || 'Line of Credit'.equals(l) || 'Payday Loan'.equals(l) || 'Personal Loan'.equals(l) || 'Other'.equals(l)){
            loanType = 'PERSONAL'; 
        }
        /*
if(''.equals(l)){
loanType = 'AUTOMOTIVE'; 
}
*/
        return loanType;
    }	
        
    public static String getLabelPicklistField(Schema.DescribeFieldResult fieldResult, String value) {
        String r = null;
        if (fieldResult != null && String.isNotBlank(value)) {
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple) {
                if (f.getValue().equalsIgnoreCase(value)) {
                    r = f.getLabel();
                    break;
                }
            }
        }
        return String.isNotBlank(r) ? r : value;
    }
    
    public static Decimal getMonthlyIncome(String frecuency, Decimal income){
        Decimal monthlyIncome;
        monthlyIncome =  income * OppApplicationServCalculatorUtils.getFrecuencyFactor(frecuency, 'Monthly');
        return monthlyIncome;
    }
}