public class FinanceOneLiability {
    public static FinanceOneDTOs.Liabilities liability(Application__c a){
        
        FinanceOneDTOs.Liabilities liabilities = new FinanceOneDTOs.Liabilities();
        
        List<Application_Other_Asset__c> propertyLiabilities= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                               Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c 
                                                               FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = :'Property Asset' 
                                                               AND Has_Loan__c = 'Y'];
        
        List<Application_Other_Asset__c> vehicleLiabilities= [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                              Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c 
                                                              FROM Application_Other_Asset__c WHERE Application__c = :a.Id AND RecordType.Name = :'Vehicle Asset'
                                                              AND Has_Loan__c = 'Y'];
        
        List < Application_Loan__c > otherLoans = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c,
                                                   Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c, Order__c
                                                   FROM Application_Loan__c WHERE Application__c =: a.Id ORDER BY Order__c
                                                  ];
        
        liabilities.general = new FinanceOneDTOs.GeneralLiability[propertyLiabilities.size()+vehicleLiabilities.size()+otherLoans.size()];
        
        Integer i = 0;
        
        for (Application_Other_Asset__c l : propertyLiabilities) {
            liabilities.general[i] = new FinanceOneDTOs.GeneralLiability();
            liabilities.general[i].type = 'mortgage';
            liabilities.general[i].balance = l.Amount_Owing__c;
            liabilities.general[i].owedTo = l.Lender__c;
            liabilities.general[i].monthlyPayment = NumberUtils.convertDecimalToScale(l.Monthly_Payment__c, 2);
            i++;
        }
        
        for (Application_Other_Asset__c l : vehicleLiabilities) {
            liabilities.general[i] = new FinanceOneDTOs.GeneralLiability();
            liabilities.general[i].type = 'motor_vehicle';
            liabilities.general[i].balance = l.Amount_Owing__c;
            liabilities.general[i].owedTo = l.Lender__c;
            liabilities.general[i].monthlyPayment = l.Monthly_Payment__c;
            i++;
        }
        
        for (Application_Loan__c l : otherLoans) {
            liabilities.general[i] = new FinanceOneDTOs.GeneralLiability();
            liabilities.general[i].type = FinanceOneUtils.liabilities(l.Type__c);
            liabilities.general[i].balance = l.Amount_Owing__c;
            liabilities.general[i].owedTo = l.Lender__c;
            liabilities.general[i].monthlyPayment = NumberUtils.convertDecimalToScale(l.Payment__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(l.Frequency__c, 'Monthly'), 2);
            i++;
        }
        
        List<Application_Credit_Card__c> liabilities2 = [SELECT Id, Name, Amount_Owing__c, Application__c, Issuer__c, Limit__c, Monthly_Payment__c, Is_Payout__c
                                                         FROM Application_Credit_Card__c WHERE Application__c = :a.Id];
        liabilities.creditFacilities = new FinanceOneDTOs.CreditFacilityLiability[liabilities2.size()];
        i = 0;
        for (Application_Credit_Card__c l2 : liabilities2) {
            liabilities.creditFacilities[i] = new FinanceOneDTOs.CreditFacilityLiability(); 
            liabilities.creditFacilities[i].type = 'credit_card';
            liabilities.creditFacilities[i].balance = l2.Amount_Owing__c;
            liabilities.creditFacilities[i].owedTo = l2.Issuer__c;
            liabilities.creditFacilities[i].creditLimit = l2.Limit__c;
            i++;
        }
        
        return liabilities;
    }
}