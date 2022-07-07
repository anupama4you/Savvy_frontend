public class FinanceOneIncome {
    public static FinanceOneDTOs.Income[] income(Integer applicant, Application__c a, Custom_Opportunity__c o){
        
        List < Application_Employment__c > secondJobIncome = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c =: String.valueOf(applicant)];
        
        List < Application_Income__c > otherIncome = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                      Income__c, Order__c, Type__c
                                                      FROM Application_Income__c WHERE Application__c =: a.Id 
                                                      AND Applicant__c =: String.valueOf(applicant) ORDER BY Order__c
                                                     ];
        List<Application_Servicing__c> listS = [SELECT Income_1__c, Income_1b__c, Income_2__c, Income_2b__c FROM Application_Servicing__c WHERE Id =: o.ApplicationServicing__c];
        
        Application_Servicing__c s;
        if(!listS.isEmpty()){
            s = listS.get(0);
        }
        
        FinanceOneDTOs.Income[] incomes = new FinanceOneDTOs.Income[secondJobIncome.size()+otherIncome.size()+1];
        
        if(applicant == 1){
            incomes[0] = new FinanceOneDTOs.Income();
            incomes[0].type = FinanceOneUtils.income(a.Mode_of_Employment_1__c);
            Decimal netIncome;
            if(s != null){
                netIncome = s.Income_1__c;
            }else{
                netIncome = FinanceOneUtils.getMonthlyIncome(a.Payment_Frequency_1__c, a.Net_Income_1__c);
            }
            incomes[0].value = netIncome;
            incomes[0].frequency = 'monthly'; 
        }
        
        if(applicant == 2){
            incomes[0] = new FinanceOneDTOs.Income();
            incomes[0].type = FinanceOneUtils.income(a.Mode_of_Employment_2__c);
            Decimal netIncome;
            if(s != null){
                netIncome = s.Income_2__c;
            }else{
                netIncome = FinanceOneUtils.getMonthlyIncome(a.Payment_Frequency_2__c, a.Net_Income_2__c);
            }
            incomes[0].value = netIncome;
            incomes[0].frequency = 'monthly';
        }
        
        Integer i = 1;
        for (Application_Employment__c e: secondJobIncome) {
            incomes[1] = new FinanceOneDTOs.Income();
            incomes[1].type = FinanceOneUtils.income(e.Employment_Type__c);
            Decimal income;
            if(s != null){
                if(applicant == 1){
                    income = s.Income_1b__c;  
                }else{
                    income = s.Income_2b__c; 
                }   
            }else{
                income = FinanceOneUtils.getMonthlyIncome(e.Frequency__c, e.Income__c);
            }
            incomes[1].value = income;
            incomes[1].frequency = 'monthly';
            i = 2;
        }
        
        for (Application_Income__c income: otherIncome) {
            incomes[i] = new FinanceOneDTOs.Income();
            incomes[i].type = FinanceOneUtils.income(income.Type__c);
            incomes[i].value = FinanceOneUtils.getMonthlyIncome(income.Frequency__c, income.Income__c);
            incomes[i].frequency = 'monthly';
            if('Other'.equals(income.Type__c) || 'Superannuation'.equals(income.Type__c) || 'Trust Income'.equals(income.Type__c)){
                incomes[i].comment = ' ';   
            }
            //incomes[i].comment = income.Detail__c;
            i++;
        }
        
        return incomes;
    }
    
}