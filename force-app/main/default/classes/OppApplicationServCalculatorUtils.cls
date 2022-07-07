public class OppApplicationServCalculatorUtils {
	
    //Joy Start
    /*public static Map<String, String> lenderMap = new Map<String, String> {
      'ACL'=>'Affordable',  
      'AFS'=>'AFS',  
      'ESA'=>'ANZ', 'BOQ'=>'BOQ', 'F1ECO'=>'F1 Economy Motors', 'FINA'=>'FINANCE 1', 
      'GRE'=>'Green Light', 'GREB'=>'Green Light (Budget)', 'LAP'=>'Latitude Personal',
      'LIB'=>'Liberty', 'MAC'=>'Macquarie', 'MON3'=>'Money 3', 'MON3MI'=>'Money 3 (Micro/Mini)', 
      'MONPL'=>'Money Place', 'PEP'=>'Pepper', 'Plenti' => 'Plenti', 'Firstmac' => 'Firstmac',
      'Latitude' => 'Latitude (Car Loan)', 'Yamaha' => 'Yamaha', 'Wisr' => 'Wisr' //, 'GEO'=>'St George'
    };*/
    public static Map<String, String> lenderMap = new Map<String, String> {
      'HEMS'=>'Others (HEMS)','GRE'=>'Green Light','GREB'=>'Green Light (Budget)','MON3'=>'Money 3',
      'MON3MI'=>'Money 3 (Micro/Mini)','FINA'=>'FINANCE 1','F1ECO'=>'F1 Economy Motors',
      'APF-Centrelink only'=>'APF-Centrelink only','APF-Standard PAYG'=>
      'APF-Standard PAYG'
    };//Joy End
    
    private static Map<String, List<List<Decimal>>> data = new Map<String, List<List<Decimal>>>();
    
    public static Decimal getFrecuencyFactor(String frecuency, String defaultVal) {
        String r = frecuency;
        if (String.isBlank(r)) {
            r = defaultVal;
        }
        return getFrecuencyFactor(r);
    }
    
    public static Decimal getFrecuencyFactor(String frecuency) {
        Decimal factor = 0.0;
        if ('Weekly'.equalsIgnoreCase(frecuency)) {
            factor = 52.0/12.0;
        } else if ('Fortnightly'.equalsIgnoreCase(frecuency)) {
            factor = 26.0/12.0;
        } else if ('Monthly'.equalsIgnoreCase(frecuency)) {
            factor = 1.0;
        }  else if ('Yearly'.equalsIgnoreCase(frecuency)) {
            factor = 1.0/12.0;
        }
        return factor;
    }
    
    public static Decimal getLivingExpensesLender(ServicingCalculatorDTO dto) {
        if(String.isNotBlank(dto.lender) && String.isNotBlank(dto.getSingleJoint()) && dto.noDependents != null && dto.naf != null){
            return getLivingExpensesLender(dto.lender, dto.getSingleJoint(), dto.noDependents, dto.state, dto.area, dto.naf);
        }
        return 0.00;
    }
    
    public static Decimal getLivingExpensesLender(String lender, String singleJoint, Integer dependants, String state, String area) {
        if(String.isNotBlank(lender) && String.isNotBlank(singleJoint) && dependants != null && String.isNotBlank(state) && String.isNotBlank(area)){
            return getLivingExpensesLender(lender, singleJoint, dependants, state, area, 0.0);
        }
        return 0.00;
    }
	
    //Yohan VillaLeal                        2019-09-02
    public static Decimal getLivingExpensesLender(String lender, String singleJoint, Integer dependants, String state, String area, Decimal netAnnualIncome) {
        Decimal livingExpenses = 0;
        System.debug('getLivingExpensesLender >> ' + lender + '|' + singleJoint + '|' + dependants + '|' + netAnnualIncome+ '|' + state+ '|' + area);
        if(dependants > 8){ dependants = 8;}
        
        if ('HEM'.equalsIgnoreCase(lender) ||
            'RateSetter'.equalsIgnoreCase(lender) ||
            'Plenti'.equalsIgnoreCase(lender)||
            'MONPL'.equalsIgnoreCase(lender) ||
            'MAC'.equalsIgnoreCase(lender) ||
            'LIB'.equalsIgnoreCase(lender) ||
            'AFS'.equalsIgnoreCase(lender) ||
            'ACL'.equalsIgnoreCase(lender) ||
            'BOQ'.equalsIgnoreCase(lender) ||
            'LAP'.equalsIgnoreCase(lender) ||
            'Latitude'.equalsIgnoreCase(lender) ||
            'Wisr'.equalsIgnoreCase(lender) ||
            'PEP'.equalsIgnoreCase(lender)) {
                Decimal netMonthlyIncome = netAnnualIncome/12;
                livingExpenses = getHEMLivingExpenses(singleJoint, dependants, netMonthlyIncome);
                if(lender != 'MAC'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'The HEM figures provided should be checked against this lender’s servicing calculator'));
                }
        } else if('Firstmac'.equalsIgnoreCase(lender)){
            
                if(dependants > 3){ 
                    dependants = 3;
                }
                if ('Joint'.equalsIgnoreCase(singleJoint)){ singleJoint = 'Couple';}
                
                if(netAnnualIncome <= 23070){ netAnnualIncome = 23070;}
                if(netAnnualIncome > 23070 && netAnnualIncome <= 28838){ netAnnualIncome = 28838;}
                if(netAnnualIncome > 28838 && netAnnualIncome <= 34606){ netAnnualIncome = 34606;}
                if(netAnnualIncome > 34606 && netAnnualIncome <= 40373){ netAnnualIncome = 40373;}
                if(netAnnualIncome > 40373 && netAnnualIncome <= 46141){ netAnnualIncome = 46141;}
                if(netAnnualIncome > 46141 && netAnnualIncome <= 51908){ netAnnualIncome = 51908;}
                if(netAnnualIncome > 51908 && netAnnualIncome <= 57676){ netAnnualIncome = 57676;}
                if(netAnnualIncome > 57676 && netAnnualIncome <= 69211){ netAnnualIncome = 69211;}
                if(netAnnualIncome > 69211 && netAnnualIncome <= 80746){ netAnnualIncome = 80746;}
                if(netAnnualIncome > 80746 && netAnnualIncome <= 92281){ netAnnualIncome = 92281;}
                if(netAnnualIncome > 92281 && netAnnualIncome <= 103817){ netAnnualIncome = 103817;}
                if(netAnnualIncome > 103817 && netAnnualIncome <= 115352){ netAnnualIncome = 115352;}
                if(netAnnualIncome > 115352 && netAnnualIncome <= 138422){ netAnnualIncome = 138422;}
                if(netAnnualIncome > 138422 && netAnnualIncome <= 161493){ netAnnualIncome = 161493;}
                if(netAnnualIncome > 161493 && netAnnualIncome <= 184563){ netAnnualIncome = 184563;}
                if(netAnnualIncome > 184563 && netAnnualIncome <= 230704){ netAnnualIncome = 230704;}
                if(netAnnualIncome > 230704 && netAnnualIncome <= 50000000){ netAnnualIncome = 50000000;}
                
                List<Decimal> firstmacValues = getFirstMacValue(lender, singleJoint, dependants, state, area, netAnnualIncome);
                livingExpenses = getLivingExpensesByDependants(firstmacValues, dependants);
                livingExpenses = (livingExpenses*52)/12;
        } else{
                List<List<Decimal>> d = loadData(lender);
                List<Decimal> dataLender = null;
                if (d != null) {
                    if ('Single'.equalsIgnoreCase(singleJoint)) {
                        dataLender = d.get(0);
                    } else if ('Joint'.equalsIgnoreCase(singleJoint)) {
                        dataLender = d.get(1);
                    }
                    livingExpenses = getLivingExpensesByDependants(dataLender, dependants);
                } 
        }
        
        if (livingExpenses == null) {
            System.debug('Living Expenses is null');
            return 0.00;
        }
        return livingExpenses;
    }
    //--
    
    //Joy START
    public static Decimal getLivingExpensesLenderHEMS(Integer dependants, String state, Decimal nemonthlyIncome, string status) {
        Decimal YearlyIncomewithTax = 0.00;
        Decimal MonthlyIncomeNoTax = 0.00;
        MonthlyIncomeNoTax = nemonthlyIncome;
        if(dependants > 3){//max dependants is 3
            dependants = 3;
        }
        if(status == 'Defacto'){//Defacto has same calculation as Married
            status = 'Married';
        }
        //This compuation is for Company Ltd - Self Employed GrossYearly
        YearlyIncomewithTax = (MonthlyIncomeNoTax * 12)/0.7;
        //system.debug('Joy');
        // System.debug('getLivingExpensesLenderHEMS=>' + dependants+'|'+state+'|'+nemonthlyIncome+'|'+status+'|'+YearlyIncomewithTax);
        List<HEM_Table__c> recList = [
          select id, Monthly_Living_Expense__c  from 
          HEM_Table__c where State__c = :state and Min_Income__c <= :YearlyIncomewithTax and Max_Income__c > :YearlyIncomewithTax 
          and Marital_Status__c = :status and No_of_Dependents__c = :String.valueOf(dependants) limit 1];
        if(recList.size() > 0){
        	return recList[0].Monthly_Living_Expense__c;
        }else{
            return 0.00;
        }
    }
    
    public static Decimal getGrossAnnualIncome(Decimal IncomeAmount, String payFrequencyType){
        Decimal finalIncome = 0.00;
        if('Annually'.equalsIgnoreCase(payFrequencyType)){
            finalIncome = (IncomeAmount)/0.7;
        }else if('Monthly'.equalsIgnoreCase(payFrequencyType)){
            finalIncome = (IncomeAmount * 12)/0.7;
        }else if('Fortnightly'.equalsIgnoreCase(payFrequencyType)){
            finalIncome = (IncomeAmount * 26)/0.7;
        }else if('Weekly'.equalsIgnoreCase(payFrequencyType)){
            finalIncome = (IncomeAmount * 52)/0.7;
        }
        return finalIncome;
    }
    //Joy END
    
    public static List<List<Decimal>> loadData(String lenderKey) {
		
        if (String.isBlank(lenderKey)) {
            return null;
        }
        List<List<Decimal>> r = data.get(lenderKey);

        if (r != null) {
            return r;
        }
        r = new List<List<Decimal>>();
        List<Decimal> singleValues = null;
        List<Decimal> jointValues = null;
        if ('LIB'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1235.0, 460.0);
            jointValues = generateData(6, 2426.0, 460.0);
        } else if ('AFS'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1175.0, 415.0);
            jointValues = generateData(6, 1765.0, 415.0);
        } 
        // else if ('PEP'.equalsIgnoreCase(lenderKey)) {
        //     singleValues = generateData(6, 1540.0, 575.0);
        //     jointValues = generateData(6, 2235.0, 575.0);
        // } 
        else if ('ESA'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1185.0, 340.0);
            jointValues = generateData(6, 2261.0, 340.0);
        } else if ('MON3'.equalsIgnoreCase(lenderKey)) {
            // singleValues = generateData(6, 1560.0, 216.6);
            // jointValues = generateData(6, 2340.0, 216.6);
            singleValues = generateData(6, (360.0*52.0/12.0), (50.0*52.0/12.0));
            jointValues = generateData(6, (540.0*52.0/12.0), (50.0*52.0/12.0));
        } else if ('MON3MI'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, (225.0*52.0/12.0), (50.0*52.0/12.0));
            jointValues = generateData(6, (360.0*52.0/12.0), (50.0*52.0/12.0));
        } else if ('FINA'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1465.0, 230.0);
            jointValues = generateData(6, 2650.0, 230.0);
        } else if ('F1ECO'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1195.0, 230.0);
            jointValues = generateData(6, 1885.0, 230.0);
        } else if ('GRE'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1400.0, 250.0);
            jointValues = generateData(6, 2300.0, 250.0);
        } else if ('GREB'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 960.0, 250.0);
            jointValues = generateData(6, 1478.0, 250.0);
        } else if ('MAC'.equalsIgnoreCase(lenderKey)) {
            //singleValues = new List<Decimal>{ 1199.0, 1569.0, 1769.0, 2151.0 };
            //jointValues = new List<Decimal>{ 2333.0, 2881.0, 3320.0, 3594.0 };
            //singleValues = new List<Decimal>{ 1224.0, 1604.0, 1818.0, 2202.0 };
            //jointValues = new List<Decimal>{ 2410.0, 3007.0, 3474.0, 3765.0 };
        } else if ('GEONSWMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1203.0, 1490.0, 1821.0, 1990.0, 2159.0, 2328.0 };
            jointValues = new List<Decimal>{ 2210.0, 2703.0, 3136.0, 3356.0, 3575.0, 3794.0 };
        } else if ('GEONSWRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1278.0, 1564.0, 1896.0, 2065.0, 2235.0, 2405.0 };
            jointValues = new List<Decimal>{ 2285.0, 2778.0, 3210.0, 3430.0, 3650.0, 3870.0 };
        } else if ('GEOQLDMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1218.0, 1504.0, 1836.0, 2005.0, 2174.0, 2343.0 };
            jointValues = new List<Decimal>{ 2225.0, 2718.0, 3151.0, 3370.0, 3589.0, 3808.0 };
        } else if ('GEOQLDRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1178.0, 1465.0, 1796.0, 1965.0, 2134.0, 2303.0 };
            jointValues = new List<Decimal>{ 2186.0, 2678.0, 3112.0, 3331.0, 3550.0, 3769.0 };
        } else if ('GEOWAMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1208.0, 1495.0, 1826.0, 1996.0, 2165.0, 2334.0 };
            jointValues = new List<Decimal>{ 2216.0, 2709.0, 3142.0, 3361.0, 3580.0, 3799.0 };
        } else if ('GEOWARegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1152.0, 1439.0, 1770.0, 1940.0, 2109.0, 2278.0 };
            jointValues = new List<Decimal>{ 2160.0, 2652.0, 3086.0, 3305.0, 3524.0, 3743.0 };
        } else if ('GEOVICMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1221.0, 1507.0, 1839.0, 2008.0, 2177.0, 2346.0 };
            jointValues = new List<Decimal>{ 2228.0, 2721.0, 3154.0, 3373.0, 3592.0, 3811.0 };
        } else if ('GEOVICRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1319.0, 1606.0, 1937.0, 2106.0, 2276.0, 2446.0 };
            jointValues = new List<Decimal>{ 2326.0, 2819.0, 3251.0, 2471.0, 2691.0, 2911.0 };
        } else if ('GEOSAMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1296.0, 1582.0, 1913.0, 2082.0, 2252.0, 2422.0 };
            jointValues = new List<Decimal>{ 2302.0, 2795.0, 3227.0, 3447.0, 3667.0, 3887.0 };
        } else if ('GEOSARegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1246.0, 1532.0, 1863.0, 2033.0, 2202.0, 2371.0 };
            jointValues = new List<Decimal>{ 2252.0, 2745.0, 3178.0, 3398.0, 3618.0, 3838.0 };
        } else if ('GEOTASMetro'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1331.0, 1617.0, 1948.0, 2117.0, 2287.0, 2457.0 };
            jointValues = new List<Decimal>{ 2337.0, 2830.0, 3262.0, 3482.0, 3702.0, 3922.0 };
        } else if ('GEOTASRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1239.0, 1525.0, 1857.0, 2026.0, 2195.0, 2364.0 };
            jointValues = new List<Decimal>{ 2246.0, 2739.0, 3172.0, 3391.0, 3611.0, 3831.0 };
        } else if ('GEOACTMetro'.equalsIgnoreCase(lenderKey) || 'GEOACTRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1277.0, 1563.0, 1894.0, 2064.0, 2234.0, 2404.0 };
            jointValues = new List<Decimal>{ 2283.0, 2777.0, 3209.0, 3429.0, 3649.0, 3869.0 };
        } else if ('GEONTMetro'.equalsIgnoreCase(lenderKey) || 'GEONTRegional'.equalsIgnoreCase(lenderKey)) {
            singleValues = new List<Decimal>{ 1277.0, 1563.0, 1894.0, 2064.0, 2234.0, 2404.0 };
            jointValues = new List<Decimal>{ 2283.0, 2777.0, 3209.0, 3429.0, 3649.0, 3869.0 };
        } else if ('Yamaha'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1504.0, 541.0);
            jointValues = generateData(6, 2180.0, 541.0);
        } else if ('APF-Centrelink only'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1004.0, 216.50);
            jointValues = generateData(6, 1905.0, 216.50);
        } else if ('APF-Standard PAYG'.equalsIgnoreCase(lenderKey)) {
            singleValues = generateData(6, 1255.0, 216.50);
            jointValues = generateData(6, 2156.0, 216.50);
        }

        if (singleValues != null && jointValues != null) {
            r.add(singleValues);
            r.add(jointValues);
        } else {
            r = null;
        }
        return r;

    }

    private static List<Decimal> generateData(Integer depLimit, Decimal startValue, Decimal factor) {
        List<Decimal> r = new List<Decimal>();
		Decimal v = 0;
        for (Integer i = 0; i <= depLimit; i++) {
            v = startValue + (i * factor);
            r.add(v.round(System.RoundingMode.CEILING));
        }
        return r;
    }
    
    public static Decimal getRentMinPerMonthLender(String lenderKey, String singleJoint) {
        Decimal r = 0.0;
        if ('LIB'.equals(lenderKey)) {
            r = 425.0;
        } else if ('PEP'.equals(lenderKey)) {
            r = 810.0;
        } else if ('MON3'.equals(lenderKey)) {
            if (String.isBlank(singleJoint) || 'Single'.equalsIgnoreCase(singleJoint)) {
                r = 100.0;
            } else {
                r = 200.0;
            }
        } else if ('FINA'.equals(lenderKey)) {
            r = 433.0;
        } else if ('F1ECO'.equals(lenderKey)) {
            r = 433.0;
        } else if ('AFS'.equals(lenderKey)) {
            r = 580.0;
        }
        return r;
    }

    public static Decimal sumApplicationIncomes(List<Application_Income__c> incomes) {
        Decimal r = 0;
        if (incomes != null) {
            for (Application_Income__c i : incomes) {
                Decimal factor = 1.0;
                if ('Rental Income'.equals(i.Type__c)) {
                    factor = 0.8;
                }
                r += i.Monthly_Income__c * factor;
            }
        }
        return r;
    }

    public static Application_Servicing__c getApplicationServicing(Id servId) {
        Application_Servicing__c r = null;
        if (servId != null) {
            List<Application_Servicing__c> d = [
                SELECT Is_Self_Employed__c, Is_Split_Living_Expenses__c, Is_Split_Rent_Mortgage__c, Is_Splitting_Expenses__c, Lender_Code__c, 
                       Net_Non_Centrelink__c, Partner_Income__c, Net_Partner_Income__c, Total_Amount_Available__c, Total_Credit_Cards__c,
                       Total_Liabilities__c, Total_Living_Expenses__c, Total_Living_Expenses_Full__c, Total_Net_Monthly_Income__c, Total_Rent_Mortgage__c,
                       Total_Rent_Mortgage_Full__c, Income_1__c, Income_2__c, Net_Profit_After_Tax__c, Net_Profit_Before_Tax__c, NAF__c, 
                       Area__c, State__c, Income_1b__c, Income_2b__c, IncomePayFrecuency_1b__c, IncomePayFrecuency_2b__c, IncomePayFrecuency_1__c, IncomePayFrecuency_2__c //Joy
                FROM Application_Servicing__c WHERE Id = :servId];
            if (!d.isEmpty()) {
                r = d.get(0);
            }

        }
        return r;
    }

    public static String getLenderCode(String lender) {
        if (String.isBlank(lender)) return null;
        String r = null;
        if (lender.containsIgnoreCase('Pepper')) {
            r = 'PEP';
        } else if (lender.containsIgnoreCase('Macquarie')) {
            r = 'MAC';
        } else if (lender.containsIgnoreCase('Yamaha')) {
            r = 'Yamaha';
        } else if (lender.containsIgnoreCase('Liberty')) {
            r = 'LIB';
        } else if (lender.startsWith('AFS')) {
            r = 'AFS';
        } else if ('Finance One'.equals(lender)) {
            r = 'FINA';
        } else if ('Green Light'.equals(lender)) {
            r = 'GRE';
        } else if ('Money3'.equals(lender)) {
            r = 'MON3';
        } else if ('Latitude'.equals(lender)) {
            r = 'Latitude';
        } else if ('Latitude Personal Loan'.equals(lender)) {
            r = 'LAP';
        } else if ('RateSetter'.equals(lender)) {
            r = 'Plenti';
        } else if ('Plenti'.equals(lender)) {
          r = 'Plenti';
        } else if ('Others (HEMS)'.equals(lender)) {//Joy 
          r = 'HEMS';
        } else {
            r = 'HEM';
        }
        return r;
    } 
    
    public static List<Decimal> getFirstMacValue(String lender, String singleJoint, Integer dependants, String state, String area, Decimal naf){
            
        List<Decimal> r = new List<Decimal>();
        List<FirstmacHEM__c> d =  [SELECT t.Annual_Income__c, t.Area__c, t.Dependants__c, t.Marital_Status__c, t.State__c, t.Value__c
                                   FROM FirstmacHEM__c t
                                   WHERE t.Annual_Income__c = :naf
                                   AND t.Area__c = :area
                                   AND t.Dependants__c = :dependants
                                   AND t.Marital_Status__c = :singleJoint
                                   AND t.State__c = :state
                                  ];
        
        for (FirstmacHEM__c s : d) {
            r.add(s.Value__c);
        }
        return r;
    }
    
    //Yohan VillaLeal                           2019-09-02
    public static Decimal getHEMLivingExpenses(String singleJoint, Integer dependants, Decimal netAnnualIncome) {
        if ('Joint'.equalsIgnoreCase(singleJoint)){ 
            singleJoint = 'Couple';
        }
        ITHEM__c sufix = [Select Value__c 
                          From ITHEM__c 
                          Where Min_value__c <= :netAnnualIncome  
                          And Max_value__c >= :netAnnualIncome   
                          And Dependants__c =:dependants 
                          And Status_marital__c =:singleJoint 
                          Limit 1];
        return sufix.Value__c;
    }
    
    public static Decimal getLivingExpensesByDependants(List<Decimal> dataLender, Integer dependants){
        Decimal livingExpenses = 0.00;
        if(dataLender != null && dataLender.size() > 0){
            if (dependants < dataLender.size()) {
                livingExpenses = dataLender.get(dependants);
            } else {
                livingExpenses = dataLender.get(dataLender.size()-1);
            }
        }
        return livingExpenses;
    }
    //--
}