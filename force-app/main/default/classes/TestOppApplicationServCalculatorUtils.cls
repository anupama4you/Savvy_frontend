@isTest
public class TestOppApplicationServCalculatorUtils {
	//Liberty
    private static List<String> LenderKeys = new List<String>{
            'LIB', 'ESA', 'F1ECO', 'FINA', 'MAC', 'MON3', 'PEP', 'GEO', 'LOWD'    
    };
        
        public static testMethod void testCalcTotLivingExpensesForFirstMac(){
            createFirstmanHEM();
            String  LENDER = 'Firstmac';
            String  SINGLEJOINT = 'Single';
            Integer DEPENDANTS = 4;
            String  STATE  = 'NT';
            String  AREA  = 'Metro';
            Decimal NAF   = 55676;
            
            Decimal servCalcTotLivingExpenses;
            servCalcTotLivingExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLender(LENDER, SINGLEJOINT, DEPENDANTS, STATE, AREA, NAF);
            
            system.debug('Living expenses to Firstmac: ' + servCalcTotLivingExpenses);
        } 

    public static testMethod void testFrecuencyFactor(){
        String param = null;
        //Null
        System.assertEquals(0.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Empty
        param = '';
        System.assertEquals(0.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Weekly
        param = 'Weekly';
        System.assertEquals(52.0/12.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Fortnightly
        param = 'Fortnightly';
        System.assertEquals((26.0/12.0), OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Monthly
        param = 'Monthly';
        System.assertEquals(1.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Yearly
        param = 'Yearly';
        System.assertEquals(1.0/12, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));
        //Different value
        param = 'DummyValue';
        System.assertEquals(0.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(param));

        //Testing default value
        System.assertEquals(52.0/12.0, OppApplicationServCalculatorUtils.getFrecuencyFactor(null, 'Weekly'));

    }
    
    public static testMethod void testLoadData(){
        List<String> keys = new List<String>{
            'LIB', 'ESA', 'F1ECO', 'FINA', 'MON3', 'AFS',
            'GEOSAMetro', 'GEOSARegional', 'GEOVICMetro', 'GEOVICRegional',
            'GEOWAMetro', 'GEOWARegional', 'GEONSWMetro', 'GEONSWRegional',
            'GEOTASMetro', 'GEOTASRegional', 'GEOQLDMetro', 'GEOVICRegional',
            'GEOACTMetro', 'GEOACTRegional', 'GEONTMetro', 'GEONTRegional',
            'Yamaha','MON3MI', 'GEOQLDRegional', 'APF-Centrelink only',
            'APF-Standard PAYG'
    	};
        List<List<Decimal>> r = null;
        String key = null;
        //Null key
        r = OppApplicationServCalculatorUtils.loadData(key);
        System.assertEquals(true, (r == null));
        //Empty key
        key = '';
        r = OppApplicationServCalculatorUtils.loadData(key);
        System.assertEquals(true, (r == null));
        //Wrong Key
        key = 'DummyKey';
        r = OppApplicationServCalculatorUtils.loadData(key);
        System.assertEquals(true, (r == null));
        
        for (String k : keys) {
            r = OppApplicationServCalculatorUtils.loadData(k);
            System.assertEquals(2, r.size());
        }
        
        //Load a Key previously loaded
        key = keys[0];
        r = OppApplicationServCalculatorUtils.loadData(key);
        System.assert(r != null);
    }
    
    public static testMethod void testLivingExpensesLender(){
        String lender = null; 
        String singleJoint = null;
        Integer dependants = null;
        String state = null;
        String area = null;
        Decimal v = null;
        
        //Null parameters
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        System.assertEquals(0.0, v);
        /*
        createITHEM(4280, 5340, 3, 'Single', 2082.0);
        //GEO
        lender = 'GEO';
        singleJoint = 'Single';
        state = 'SA';
        area = 'Metro';
        dependants = 3;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(2082.0, v);
        
        //GEO
        lender = 'GEO';
        state = 'SA';
        area = 'Regional';
        singleJoint = 'Single';
        dependants = 1;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(1532.0, v);
        //Test its values
        singleJoint = 'Joint';
        dependants = 5;
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(3838.0, v);
        
        //GEO
        lender = 'GEO';
        state = 'QLD';
        area = 'Regional';
        singleJoint = 'Single';
        dependants = 1;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(1465.0, v);
        //Test its values
        area = 'Metro';
        singleJoint = 'Joint';
        dependants = 5;
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(3808.0, v);
        */
        //MON3
        lender = 'MON3';
        singleJoint = 'Single';
        dependants = 3;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(2211.0, v);
        singleJoint = 'Joint';
        dependants = 6;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(3641.0, v);
        
        //Macquarie
        createITHEM(0, 4249, 1, 'Single', 2082.0);
        lender = 'MAC';
        singleJoint = 'Single';
        dependants = 1;
        state = 'QLD';
        area = 'Regional';
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        System.assert(v > 0.0);
        
        createITHEM(0, 4249, 3, 'Couple', 2082.0);
        singleJoint = 'Joint';
        dependants = 3;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        System.assert(v > 0.0);
        
        //Latitude
        createITHEM(0, 4249, 3, 'Single', 2082.0);
        lender = 'Latitude';
        singleJoint = 'Single';
        dependants = 3;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(0, v);
        
        createITHEM(0, 4249, 6, 'Couple', 2082.0);
        singleJoint = 'Joint';
        dependants = 6;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(0, v);
        
        //Firstmac
        createITHEM(0, 4249, 3, 'Single', 2082.0);
        lender = 'Firstmac';
        singleJoint = 'Single';
        dependants = 3;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(0, v);
        //
        createITHEM(0, 4249, 6, 'Couple', 2082.0);
        singleJoint = 'Joint';
        dependants = 6;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(0, v);
        
        //Esanda
        createITHEM(0, 4249, 1, 'Single', 1525.0);
        lender = 'ESA';
        singleJoint = 'Single';
        dependants = 1;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(1525.0, v);
        
        createITHEM(0, 4249, 5, 'Couple', 1525.0);
        singleJoint = 'Joint';
        dependants = 5;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(3961.0, v);
        /*
        //GEO, wrong dependants
        lender = 'GEO';
        singleJoint = 'Single';
        dependants = 3000;
        state = 'SA';
        area = 'Metro';
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area);
        //System.assertEquals(2422.0, v);
        
        //GREEN LIGHT
        Test_DataGeneratorHelper.createITHEM(3000, 20000, 3000, 'Single', 2082.0);
        lender = 'GRE';
        singleJoint = 'Single';
        dependants = 3000;
        Decimal naf = 10000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 21000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 26000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 32000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 37000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 42000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 50486, 3000, 'Single', 2082.0);
        naf = 47000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 55486, 3000, 'Single', 2082.0);
        naf = 55000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 95486, 3000, 'Single', 2082.0);
        naf = 65000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 95486, 3000, 'Single', 2082.0);
        naf = 75000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 95486, 3000, 'Single', 2082.0);
        naf = 85000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 95486, 3000, 'Single', 2082.0);
        naf = 95000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
        
        Test_DataGeneratorHelper.createITHEM(4249, 195486, 3000, 'Single', 2082.0);
        naf = 105000;
        //Test its values
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(lender, singleJoint, dependants, state, area, naf);
        System.assert(v > 0.0);
*/
        ServicingCalculatorDTO dto = new ServicingCalculatorDTO();
        dto.lender = 'GEO';
        dto.maritalStatus = 'Single';
        dto.noDependents = 30000;
        dto.state = state;
        dto.area = area;
        v = OppApplicationServCalculatorUtils.getLivingExpensesLender(dto);
        //System.assertEquals(2422.0, v);
    }
    /*
        public static testMethod void testLenderData(){
            String[] singleJoints = new List<String>{'Single','Joint'};
            String[] states =  new List<String>{'SA','WA', 'NSW', 'QLD', 'TAS', 'VIC', 'ACT', 'NT'};
            String[] areas = new List<String>{'Metro','Regional'};
            Decimal v = null;
            Integer dependants = 1;
            List<Decimal> d = null;
            
            for (String lender : lenderKeys) {
                for (String singleJoint : singleJoints) {
                    if ('GEO'.equalsIgnoreCase(lender)) {
                        for (String state : states) {
                            for (String area : areas) {
                                //Test its values
                                d = OppApplicationServCalculatorUtils.getLenderData(lender, singleJoint, dependants, state, area);
                                System.assert(d != null);
                                System.assert(d.size() > 0);
                            }
                        }
                    } else {
                        //Test its values
                        d = OppApplicationServCalculatorUtils.getLenderData(lender, singleJoint, dependants, null, null);
                        if (!'LOWD'.equals(lender)) {
                            System.assert(d != null);
                            System.assert(d.size() > 0);
                        } else {
                            System.assert(d == null);
                        }
                    }
                }
            }
            
            //Lender null
            d = OppApplicationServCalculatorUtils.getLenderData(null, singleJoints[0], dependants, null, null);
            System.assert(d == null);
            
            //Lender and Type nulls 
            d = OppApplicationServCalculatorUtils.getLenderData(null, null, null, null, null);
            System.assert(d == null);
            
            //Type null 
            d = OppApplicationServCalculatorUtils.getLenderData('ETETE', null, null, null, null);
            System.assert(d == null);
            
            //GEO extra param nulls 
            d = OppApplicationServCalculatorUtils.getLenderData('GEO', singleJoints[0], dependants, null, null);
            System.assert(d == null);
            
            //GEO extra param nulls 
            d = OppApplicationServCalculatorUtils.getLenderData('GEO', singleJoints[0], dependants, null, null);
            System.assert(d == null);
            
            //Wrong lender 
            d = OppApplicationServCalculatorUtils.getLenderData('DUMMYLENDER', singleJoints[0], dependants, null, null);
            System.assert(d == null);
            
        }
 	*/
    public static testMethod void testRentMinPerMonthLender(){
        List<String> lenders = new List<String> {'LIB','PEP','F1ECO','MON3','FINA','AFS'};
        Decimal v = 0.0;
        for (String lender: lenders) {
        	v = OppApplicationServCalculatorUtils.getRentMinPerMonthLender(lender, 'Single');
            System.assert(v > 0.0);
        }
        
        v = OppApplicationServCalculatorUtils.getRentMinPerMonthLender('MON3', 'Joint');
        System.assert(v > 0.0);
        
    }
    
    public static testMethod void testAppServicingCalcDTO(){
        AppServicingCalculatorDTO dto = new AppServicingCalculatorDTO();
        dto.empIncome1 = '0';
        dto.empIncome2 = '0';
        dto.otherIncome1 = '0';
        dto.otherIncome2 = '0';
        dto.monthIncome = '0';
        dto.monthRent = '0';
        dto.livingExpense = '0';
        //dto.otherDebts = '0';
        dto.subTotal = '0';
        dto.requiredSurplus = '0';
        dto.finalAmount = '0';
        
        // Lelo							2016-07-11
        dto.lender = '0';
        dto.state = '0';
        dto.area = '0';
        dto.typeStatus = '0';
        dto.dependants = '0';
        dto.splitting = '0';
        dto.partnerIncome = '0';
        dto.netPartnerIncome = '0';
        
        dto.netMonthlyIncome = '0';
        dto.totLiabilities = '0';
        dto.rentMtgePaid = '0';
        dto.livingExpenses = '0';
        dto.otherDebts = '0';
        dto.amountAvailablePayment = '0';
        
        dto.rentMtgePaidSplited = false;
        dto.livingExpensesSplited = false;
        
        dto.applicantIncome1 = '0';
        dto.applicantIncome2 = '0';
        dto.applicantOtherIncome1 = '0';
        dto.applicantOtherIncome2 = '0';
        
        //Expenses - Liabilities
        dto.loanType1 = '0';
        dto.loanFrecuency1 = '0';
        dto.loanAmount1 = '0';
        
        dto.loanType2 = '0';
        dto.loanFrecuency2 = '0';
        dto.loanAmount2 = '0';
        
        dto.loanType3 = '0';
        dto.loanFrecuency3 = '0';
        dto.loanAmount3 = '0';
        
        dto.loanType4 = '0';
        dto.loanFrecuency4 = '0';
        dto.loanAmount4 = '0';
        
        //Expenses - Rent / Mortgage
        dto.rentFrecuency = '0';
        dto.rentAmount = '0';
        
        //Expenses - Credit Cards
        dto.creditCardIssuer = '0';
        dto.creditLimit = '0';
        dto.amountOwing = '0';
        dto.monthlyPayment = '0';
        
        //Liberty Calculator
        dto.netNonCentrelinkIncome = '0';
        dto.centrelinkIncome = '0';
        dto.totalAssesableIncome = '0';
        dto.centrelinkIncomePercentage = '0';
        dto.annualCLToLoannet = '0';
        
        dto.getTotalOthresIncome();
        dto.getTotalOthresIncomeText();
        
    }

    public static testMethod void testLenderCode(){
        System.assert(String.isBlank(OppApplicationServCalculatorUtils.getLenderCode(null)));
        System.assert('PEP'.equals(OppApplicationServCalculatorUtils.getLenderCode('Pepper MV')));
        System.assert('PEP'.equals(OppApplicationServCalculatorUtils.getLenderCode('Pepper Summer')));
        System.assert('MAC'.equals(OppApplicationServCalculatorUtils.getLenderCode('Macquarie Consumer')));
        System.assert('MAC'.equals(OppApplicationServCalculatorUtils.getLenderCode('Macquarie Commercial')));
        System.assert('Yamaha'.equals(OppApplicationServCalculatorUtils.getLenderCode('Yamaha Marine')));
        System.assert('Yamaha'.equals(OppApplicationServCalculatorUtils.getLenderCode('Yamaha Motorcycle')));
        System.assert('Yamaha'.equals(OppApplicationServCalculatorUtils.getLenderCode('Yamaha Water')));
        System.assert('LIB'.equals(OppApplicationServCalculatorUtils.getLenderCode('Liberty Drive')));
        System.assert('LIB'.equals(OppApplicationServCalculatorUtils.getLenderCode('Liberty Options')));
        System.assert('AFS'.equals(OppApplicationServCalculatorUtils.getLenderCode('AFS Consumer')));
        System.assert('AFS'.equals(OppApplicationServCalculatorUtils.getLenderCode('AFS Commercial')));
        System.assert('FINA'.equals(OppApplicationServCalculatorUtils.getLenderCode('Finance One')));
        System.assert('GRE'.equals(OppApplicationServCalculatorUtils.getLenderCode('Green Light')));
        System.assert('MON3'.equals(OppApplicationServCalculatorUtils.getLenderCode('Money3')));
        System.assert('Latitude'.equals(OppApplicationServCalculatorUtils.getLenderCode('Latitude')));
        System.assert('LAP'.equals(OppApplicationServCalculatorUtils.getLenderCode('Latitude Personal Loan')));
        // System.assert('RateSetter'.equals(OppApplicationServCalculatorUtils.getLenderCode('RateSetter')));
        System.assert('Plenti'.equals(OppApplicationServCalculatorUtils.getLenderCode('Plenti')));
        System.assert('HEM'.equals(OppApplicationServCalculatorUtils.getLenderCode('Metro')));
        System.assert('HEM'.equals(OppApplicationServCalculatorUtils.getLenderCode('Any Other Calculator')));
    }

    public static testMethod void testSumApplicationIncomes() {
        List<Application_Income__c> incomes = new List<Application_Income__c>();
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Rental Income';
        i.Income__c = 1000;
        incomes.add(i);
        i.recalculateFormulas();
        System.assertEquals(800.0, OppApplicationServCalculatorUtils.sumApplicationIncomes(incomes));
    }

    public static testMethod void testApplicationServicing(){
      Application_Servicing__c a = new Application_Servicing__c();
      a.State__c = 'SA';
      insert a;
      OppApplicationServCalculatorUtils.getApplicationServicing(a.id);
    }
    
    public static void createFirstmanHEM() {
		FirstmacHEM__c tstFirstmacHEM = new FirstmacHEM__c(Name = 'S101', Annual_Income__c = 55676, Area__c = 'Metro', Dependants__c = 4, Marital_Status__c = 'Single', State__c = 'NT', Value__c = 5643);
		insert tstFirstmacHEM;
	}
    
    public static void createITHEM(Decimal min, Decimal max, Integer dependants, String singleJoint, Decimal value) {
		ITHEM__c tstITHEM = new ITHEM__c(Name ='S101', Min_value__c = min, Max_value__c = max, Dependants__c = dependants, Status_marital__c = singleJoint, Value__c = value);         
        insert tstITHEM;
	}
}