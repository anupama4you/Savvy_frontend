public class YTDCalculatorExtension {
    
    public static final String APPTYPE_1 = 'Applicant 1';
    public static final String APPTYPE_1_2NDJOB = 'Applicant 1 Second Job';
    public static final String APPTYPE_2 = 'Applicant 2';
    public static final String APPTYPE_2_2NDJOB = 'Applicant 2 Second Job';
    
    public Custom_Opportunity__c opp;
    // The boolean to control the page to stay on quotingTool div
    public boolean quotingTool {get;set;}
    // The boolean to control the page to stay on servicingCalc div
    public boolean servicingCalc {get;set;}
    // The boolean to control the page to stay on YtdCalc div
    public boolean ytdCalc {get;set;}
    // The boolean to control the page to stay on Asset Details div
    public boolean assetDetails {get;set;}
    // The boolean to control the page to stay on Asset Details div
    public boolean notesSection {get;set;}
    // The variables for YTD Calculator
    //public date startDate {get;set;}
    //public date endDate {get;set;}
    //Others Applicant 1
    public date startDateOth {get;set;}
    public date endDateOth {get;set;}
    public decimal ytdWeeksOth {get;set;}
    public decimal ytdIncomeOth {get;set;}
    public decimal ytdMonIncomeOth {get;set;}
    public decimal annualIncomeOth {get;set;}
    //Others Applicant 2
    //public date startDateOthA2 {get;set;}
    //public date endDateOthA2 {get;set;}
    public decimal ytdWeeksOthA2 {get;set;}
    //public decimal ytdIncomeOthA2 {get;set;}
    public decimal ytdMonIncomeOthA2 {get;set;}
    public decimal annualIncomeOthA2 {get;set;}
    public String ytdCalcLender {get;set;}
    public List < SelectOption > ytdCalcLenderSelect {get;set;}
    
    //Applicant 2
    /*
    public date startDateA2 {get;set;}
    public date endDateA2 {get;set;}
    public decimal ytdWeeksA2 {get;set;}
    public decimal ytdIncomeA2 {get;set;}
    public decimal baseIncomeA2 {get;set;}
    public decimal ytdMonIncomeA2 {get;set;}
    public decimal netMonIncomeA2 {get;set;}
    public decimal monDifferenceA2 {get;set;}
    public decimal discDiffA2 {get;set;}
    public decimal outAmountA2 {get;set;}
    //Macquarie
    public Date ytdMacYtdStartDate {get;set;}
    public Date ytdMacStartDate {get;set;}
    public Date ytdMacEndDate {get;set;}
    public Decimal ytdMacNetYtdSalary {get;set;}
    public Decimal ytdMacPayPeriodNetSalary {get;set;}
    */
    public Decimal ytdMacPayPeriodDays {get;set;}
    public Decimal ytdMacMonthlyNetYtdSalary {get;set;}
    public Decimal ytdMacAnnuallyNetYtdSalary {get;set;}
    public Decimal ytdMacMonthlyPayPeriodNetSalary {get;set;}
    public Decimal ytdMacAnnuallyPayPeriodNetSalary {get;set;}
    /*
    public String ytdMacComments {get;set;}
    //Applicant 2
    public Date ytdMacYtdStartDateA2 {get;set;}
    public Date ytdMacStartDateA2 {get;set;}
    public Date ytdMacEndDateA2 {get;set;}
    public Decimal ytdMacNetYtdSalaryA2 {get;set;}
    public Decimal ytdMacPayPeriodNetSalaryA2 {get;set;}
    public Decimal ytdMacPayPeriodDaysA2 {get;set;}
    public Decimal ytdMacMonthlyNetYtdSalaryA2 {get;set;}
    public Decimal ytdMacAnnuallyNetYtdSalaryA2 {get;set;}
    public Decimal ytdMacMonthlyPayPeriodNetSalaryA2 {get;set;}
    public Decimal ytdMacAnnuallyPayPeriodNetSalaryA2 {get;set;}
    public String ytdMacCommentsA2 {get;set;}
    */
    public decimal ytdWeeks {get;set;}
    public decimal ytdIncome {get;set;}
    public decimal baseIncome {get;set;}
    /*
    public String ytdComment2 {get;set;}
    public String ytdComment1 {get;set;}
    */
    public decimal ytdMonIncome {get;set;}
    public decimal baseTax {get;set;}
    public decimal baseMedi {get;set;}
    public decimal netMonIncome {get;set;}
    public decimal monDifference {get;set;}
    public decimal discDiff {get;set;}
    public decimal outAmount {get;set;}
    /*
    public Decimal latestPay1 {get;set;}
    public Decimal latestPay2 {get;set;}
    public Decimal latestPayMonthly1 {get;set;}
    public Decimal latestPayMonthly2 {get;set;}
    public String latestPayFrequency1 {get;set;}
    public String latestPayFrequency2 {get;set;}
    */
    public String ytdLenderApplic {get;set;}
    
    //public Decimal ytdGrossAnnualIncomeApplic1 {set; get;}
    //public Decimal ytdGrossAnnualIncomeApplic2 {set; get;}

    public String fdLender {get;set;}
    /*
    public Decimal fdNetProfit {get;set;}
    public Decimal fdDepreciation {get;set;}
    public Decimal fdInterest {get;set;}
    public Decimal fdDirectorSalary {get;set;}
    //- Lelo        2017-02-09
    public String fldSelfEmployedClass {get;set;}
    */
    public String fldSelfEmployedType {get;set;}
    /*
    public String trusteesNumber {get;set;}
    public Decimal fdNetProfit2 {get;set;}
    public Decimal fdSales {get;set;}
    public String fldSelfEmployedClass2 {get;set;}
    */
    public String fldSelfEmployedType2 {get;set;}
    /*
    public Decimal fdSales2 {get;set;}
    public Decimal fdNetProfit_2 {get;set;}
    public Decimal fdDepreciation2 {get;set;}
    public Decimal fdInterest2 {get;set;}
    public Decimal fdDirectorSalary2 {get;set;}
    public String trusteesNumber2 {get;set;}
	public Decimal fdNetProfit2_2 {get;set;}
*/
    public decimal baseIncomeLowDoc {get;set;}
    
    public List < SelectOption > frequency {get;set;}
    public List <SelectOption> ytdLenderOptionsApplic {get;set;}
    private List<String> ytdLenderValues = new List<String> {
      'Any', 'Firstmac' 
    };
        
    public String sgtPaylipsFrecuency {get;set;}
    public Decimal sgtPaylipsAmount {get;set;}
    public String sgtPaylipsFrecuency1 {get;set;}
    public Decimal sgtPaylipsAmount1 {get;set;}
    public String sgtPaylipsFrecuency2 {get;set;}
    public Decimal sgtPaylipsAmount2 {get;set;}
    public String sgtPaylipsFrecuency3 {get;set;}
    public Decimal sgtPaylipsAmount3 {get;set;}
    public String sgtPaylipsFrecuencyA2 {get;set;}
    public Decimal sgtPaylipsAmountA2 {get;set;}
    public String sgtPaylipsFrecuency1A2 {get;set;}
    public Decimal sgtPaylipsAmount1A2 {get;set;}
    public String sgtPaylipsFrecuency2A2 {get;set;}
    public Decimal sgtPaylipsAmount2A2 {get;set;}
    public String sgtPaylipsFrecuency3A2 {get;set;}
    public Decimal sgtPaylipsAmount3A2 {get;set;}
    
    //  YTD Refactoring
    //Jesus Mora 2020-01-02
    private Map<String, YTD_Income__c> dataMap;
    private Map<String, Application_Employment__c> employmentMap;
    //--
    
    public YTDCalculatorExtension(ApexPages.StandardController controller){
        this.opp = (Custom_Opportunity__c) controller.getRecord();
        ytdIncome = 0.00;
        quotingTool = false;
        servicingCalc = false;
        ytdCalc = false;
        assetDetails = false;
        notesSection = false;
        //startDate = Date.newInstance(2016, 7, 1);
        ytdCalcLender = 'ANZ';
        //clearYTDEsandaOtherFields();
        ytdWeeks = 0.0;
        netMonIncome = 0.0;
        ytdMonIncome = 0.0;
        monDifference = 0.0;
        baseTax = 0.0;
        baseMedi = 0;
        ytdWeeksOth = 0;
        ytdMonIncomeOth = 0;
        annualIncomeOth = 0;
        ytdWeeksOthA2 = 0;
        ytdMonIncomeOthA2 = 0;
        annualIncomeOthA2 = 0;
        //ytdMacStartDate = Date.today();
        //ytdMacEndDate = Date.today();
        ytdMacPayPeriodDays = 0.0;
        ytdMacMonthlyNetYtdSalary = 0.0;
        ytdMacMonthlyPayPeriodNetSalary = 0.0;
        ytdMacAnnuallyNetYtdSalary = 0.0;
        ytdMacAnnuallyPayPeriodNetSalary = 0.0;
        ytdCalcLenderSelect = new List < SelectOption > ();
        ytdCalcLenderSelect.add(new SelectOption('None', 'None'));
        ytdCalcLenderSelect.add(new SelectOption('Esanda', 'ANZ'));
        ytdCalcLenderSelect.add(new SelectOption('Pepper', 'Pepper'));
        ytdCalcLenderSelect.add(new SelectOption('Macquarie', 'Macquarie'));
        //ytdCalcLenderSelect.add(new SelectOption ('St George', 'St George'));
        ytdCalcLenderSelect.add(new SelectOption('Others', 'Others'));
        //ytdCalcLenderSelect.add(new SelectOption ('LowDocumentation', 'Low-Doc (Self-Employed)'));
        //ytdCalcLenderSelect.add(new SelectOption ('Full-Documentation', 'Full-Doc (Self-Employed)'));
        ytdCalcLenderSelect.add(new SelectOption('Self-Employed', 'Self-Employed'));
        //ytdCalcLender = 'Esanda';
        ytdCalcLender = 'None';
        fldSelfEmployedType = 'Company Pty Ltd';
        fldSelfEmployedType2 = 'Company Pty Ltd';
        frequency = new List < SelectOption > ();
        frequency.add(new SelectOption('', '--None--'));
        frequency.add(new SelectOption('Weekly', 'Weekly'));
        frequency.add(new SelectOption('Fortnightly', 'Fortnightly'));
        frequency.add(new SelectOption('Monthly', 'Monthly'));
        frequency.add(new SelectOption('Yearly', 'Yearly'));
                
        ytdLenderOptionsApplic = new List<SelectOption>();
            for(String value : ytdLenderValues) {
                ytdLenderOptionsApplic.add(new SelectOption (value, value));
            }
                
        loadYTDValues(); // YTD
    }
    
    public void clearYTDEsandaOtherFields() {
        /*
        startDate = null;
        ytdMacStartDate = null;
        ytdMacStartDateA2 = null;
        ytdMacYtdStartDate = null;
        ytdMacYtdStartDateA2 = null;
        startDateOth = null;
        Integer year = Date.today().year();
        if (Date.today().month() < 7) {
            year--;
        }
        if (('Esanda'.equals(ytdCalcLender) || 'Pepper'.equals(ytdCalcLender)) && startDate == null) {
            startDate = Date.newinstance(year, 7, 1);
            startDateA2 = Date.newinstance(year, 7, 1);
        } else if (('Macquarie'.equals(ytdCalcLender)) && ytdMacStartDate == null) {
            ytdMacYtdStartDate = Date.newinstance(year, 7, 1);
            ytdMacYtdStartDateA2 = Date.newinstance(year, 7, 1);
            ytdMacStartDate = Date.newinstance(year, 7, 1);
            ytdMacStartDateA2 = Date.newinstance(year, 7, 1);
        } else if (('Others'.equals(ytdCalcLender)) && startDateOth == null) {
            startDateOth = Date.newinstance(year, 7, 1);
            startDateOthA2 = Date.newinstance(year, 7, 1);
        }
        */
        //ytdIncome = null;
        //baseIncome = null;
        //ytdIncomeOth = null;
        //baseIncomeOth = null;
        //endDate = null;
        //endDateOth = null;
        //initYTDEsandaOtherFieldsCalculated();
                    
        YTD_Income__c a = null;
        Integer year = Date.today().year();
        
        if (Date.today().month() < 7) {
            year--;
        }
        
        if (!this.dataMap.containsKey(APPTYPE_1)) {
            a = new YTD_Income__c();
            a.Applicant_Type__c = APPTYPE_1;
            a.Start_Date__c = Date.newinstance(year, 7, 1);
            a.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
            a.End_Date__c = Date.today();
            this.dataMap.put(APPTYPE_1, a);
            if('Others'.equals(ytdCalcLender)){
                this.calculateWeeks(a);
            }
            if('Macquarie'.equals(ytdCalcLender)){
                macDayssBeteenDatesApp1();
            }
            if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                calcWeeksBeteenDatesApp1();
            }
        } 
        // TODO: verify if there is a second job for app 1
        // TODO: verify same conditions for Applicant 2
        if(this.employmentMap.containsKey(APPTYPE_1_2NDJOB)){
            YTD_Income__c app1S = null;
            if (!this.dataMap.containsKey(APPTYPE_1_2NDJOB)) {
                app1S = new YTD_Income__c();
                app1S.Applicant_Type__c = APPTYPE_1_2NDJOB;
                app1S.Start_Date__c = Date.newinstance(year, 7, 1);
                app1S.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                app1S.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_1_2NDJOB, app1S);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(app1S);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp12ndJob();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp12ndJob();
                }
            }
        }
        
        if(opp.Application__r.No_of_People__c == 2){
            YTD_Income__c a2 = null;
            if (!this.dataMap.containsKey(APPTYPE_2)) {
                a2 = new YTD_Income__c();
                a2.Applicant_Type__c = APPTYPE_2;
                a2.Start_Date__c = Date.newinstance(year, 7, 1);
                a2.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                a2.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_2, a2);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(a2);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp2();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp2();
                }
            }
        }
        if(this.employmentMap.containsKey(APPTYPE_2_2NDJOB) && opp.Application__r.No_of_People__c == 2){
            YTD_Income__c a2S = null;
            if (!this.dataMap.containsKey(APPTYPE_2_2NDJOB)) {
                a2S = new YTD_Income__c();
                a2S.Applicant_Type__c = APPTYPE_2_2NDJOB;
                a2S.Start_Date__c = Date.newinstance(year, 7, 1);
                a2S.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                a2S.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_2_2NDJOB, a2S);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(a2S);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp22ndJob();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp22ndJob();
                }
            }
        }
                       
        if (this.dataMap.containsKey(APPTYPE_1)) {
            YTD_Income__c o = this.dataMap.get(APPTYPE_1);
            if('Others'.equals(ytdCalcLender)){
                if(o.Type__c != null){
                    if(!o.Type__c.equals('Others')){
                        o.Start_Date__c = Date.newinstance(year, 7, 1);
                        o.End_Date__c = Date.today();
                        o.Gross_YTD_Income__c = null;
                        o.Gross_Annual_Income__c = null;
                        ytdLenderApplic = 'Any';
                    }else{
                        data();
                    }
                }
                this.calculateWeeks(o);
            }
            if('Macquarie'.equals(ytdCalcLender)){
                if(o.Type__c != null){
                    if(!o.Type__c.equals('Macquarie')){
                        o.Start_Date__c = Date.newinstance(year, 7, 1);
                        o.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                        o.End_Date__c = Date.today();
                        o.Net_Annual_Income__c = null;
                        o.Net_Last_Income__c = null;
                        o.Comment__c = null;
                    }else{
                        data();
                    }
                }
                macDayssBeteenDatesApp1();
            }
            if('Pepper'.equals(ytdCalcLender)){
                if(o.Type__c != null){
                    if(!o.Type__c.equals('Pepper')){
                        o.Start_Date__c = Date.newinstance(year, 7, 1);
                        o.End_Date__c = Date.today();
                        o.Net_Annual_Income__c = null;
                        o.Net_Income__c = null;
                        o.Gross_YTD_Income__c = null;
                        o.Gross_Net_Income__c = null;
                        o.Net_Last_Income__c = null;
                        o.Last_Income_Frequency__c = null;
                        ytdCalcNetLastestPay1();
                    }else{
                        data();
                    }
                }
                calcWeeksBeteenDatesApp1();
            }
            if('Esanda'.equals(ytdCalcLender)){
                if(o.Type__c != null){
                    if(!o.Type__c.equals('Esanda')){
                        o.Start_Date__c = Date.newinstance(year, 7, 1);
                        o.End_Date__c = Date.today();
                        o.Net_Annual_Income__c = null;
                        o.Net_Income__c = null;
                        o.Gross_YTD_Income__c = null;
                        o.Gross_Net_Income__c = null;
                    }else{
                        data();
                    }
                }
                calcWeeksBeteenDatesApp1();
            }
            if('Self-Employed'.equals(ytdCalcLender)){
                if(o.Type__c != null){
                    if(!o.Type__c.equals('Self-Employed')){
                        o.Self_Employed_Type__c = null;
                        o.Trustees_Number__c = null;
                        o.Self_Employed_Class__c = null;
                        o.Sales__c = null;
                        o.Net_Profit__c = null;
                        o.Depreciation__c = null;
                        o.Interest__c = null;
                        o.Director_Salary__c = null;
                        o.Net_Profit_2__c = null;
                    }else{
                        data();
                    }
                }
            }
        }
        
        // TODO: verify if there is a second job for app 1
        // TODO: verify same conditions for Applicant 2
        if(this.employmentMap.containsKey(APPTYPE_1_2NDJOB)){
            if (this.dataMap.containsKey(APPTYPE_1_2NDJOB)) {
                YTD_Income__c o = this.dataMap.get(APPTYPE_1_2NDJOB);
                if('Others'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Others')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Annual_Income__c = null;
                            ytdLenderApplic = 'Any';
                        }else{
                            data();
                        }
                    }
                    this.calculateWeeks(o);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Macquarie')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Comment__c = null;
                        }else{
                            data();
                        }
                    }
                    macDayssBeteenDatesApp12ndJob();
                }
                if('Pepper'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Pepper')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Last_Income_Frequency__c = null;
                            ytdCalcNetLastestPay12ndJob();
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp12ndJob();
                }
                if('Esanda'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Esanda')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp12ndJob(); 
                }
                if('Self-Employed'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Self-Employed')){
                            o.Self_Employed_Type__c = null;
                            o.Trustees_Number__c = null;
                            o.Self_Employed_Class__c = null;
                            o.Sales__c = null;
                            o.Net_Profit__c = null;
                            o.Depreciation__c = null;
                            o.Interest__c = null;
                            o.Director_Salary__c = null;
                            o.Net_Profit_2__c = null;
                        }else{
                            data();
                        }
                    }
                }
            }
        }
        
        if(opp.Application__r.No_of_People__c == 2){
            if (this.dataMap.containsKey(APPTYPE_2)) {
                YTD_Income__c o = this.dataMap.get(APPTYPE_2);
                System.debug(ytdCalcLender);
                if('Others'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Others')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Annual_Income__c = null;
                            ytdLenderApplic = 'Any';
                        }else{
                            data();
                        }
                    }
                    this.calculateWeeks(o);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Macquarie')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Comment__c = null;
                        }else{
                            data();
                        }
                    }
                    macDayssBeteenDatesApp2();
                }
                if('Pepper'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Pepper')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Last_Income_Frequency__c = null;
                            ytdCalcNetLastestPay2();
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp2();
                }
                if('Esanda'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Esanda')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp2(); 
                }
                if('Self-Employed'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Self-Employed')){
                            o.Self_Employed_Type__c = null;
                            o.Trustees_Number__c = null;
                            o.Self_Employed_Class__c = null;
                            o.Sales__c = null;
                            o.Net_Profit__c = null;
                            o.Depreciation__c = null;
                            o.Interest__c = null;
                            o.Director_Salary__c = null;
                            o.Net_Profit_2__c = null;
                        }else{
                            System.debug(o.Type__c);
                            System.debug(ytdCalcLender);
                            data();
                        }
                    }
                }
            }
        }

        if(this.employmentMap.containsKey(APPTYPE_2_2NDJOB) && opp.Application__r.No_of_People__c == 2){
            if (this.dataMap.containsKey(APPTYPE_2_2NDJOB)) {
                YTD_Income__c o = this.dataMap.get(APPTYPE_2_2NDJOB);
                if('Others'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Others')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Annual_Income__c = null;
                            ytdLenderApplic = 'Any';
                        }else{
                            data();
                        }
                    }
                    this.calculateWeeks(o);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Macquarie')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Comment__c = null;
                        }else{
                            data();
                        }
                    }
                    macDayssBeteenDatesApp22ndJob();
                }
                if('Pepper'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Pepper')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                            o.Net_Last_Income__c = null;
                            o.Last_Income_Frequency__c = null;
                            ytdCalcNetLastestPay22ndJob();
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp22ndJob();
                }
                if('Esanda'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Esanda')){
                            o.Start_Date__c = Date.newinstance(year, 7, 1);
                            o.End_Date__c = Date.today();
                            o.Net_Annual_Income__c = null;
                            o.Net_Income__c = null;
                            o.Gross_YTD_Income__c = null;
                            o.Gross_Net_Income__c = null;
                        }else{
                            data();
                        }
                    }
                    calcWeeksBeteenDatesApp22ndJob(); 
                }
                
                if('Self-Employed'.equals(ytdCalcLender)){
                    if(o.Type__c != null){
                        if(!o.Type__c.equals('Self-Employed')){
                            o.Self_Employed_Type__c = null;
                            o.Trustees_Number__c = null;
                            o.Self_Employed_Class__c = null;
                            o.Sales__c = null;
                            o.Net_Profit__c = null;
                            o.Depreciation__c = null;
                            o.Interest__c = null;
                            o.Director_Salary__c = null;
                            o.Net_Profit_2__c = null;
                        }else{
                            data();
                        }
                    }
                }
            }
        }
        
        if('Self-Employed'.equals(ytdCalcLender)){
            
            getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp1()), this.getApp1());
            if(Opp.Application__r.No_of_People__c == 2){
                getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp2()), this.getApp2());
            }
            if(getHasSecondJob1()){
                getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp12ndJob()), this.getApp12ndJob());
            }
            if(getHasSecondJob2()){
                getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp22ndJob()), this.getApp22ndJob());
            }
        }
    }
    
    public PageReference ytdCalculate() {
        //initYTDEsandaOtherFieldsCalculated();
        ytdWeeksOth = 0;
        ytdMonIncomeOth = 0;
        annualIncomeOth = 0;
        if (startDateOth == null || endDateOth == null) {
            return null;
        }
        //startDate = Date.parse(startDateYTD);
        //endDate = Date.parse(endDateYTD);
        if (endDateOth < startDateOth) {
            ytdCalc = true;
            servicingCalc = false;
            quotingTool = false;
            assetDetails = false;
            notesSection = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please choose an End Date that is later than the Start Date.'));
            return null;
        }
        ytdWeeksOth = startDateOth.daysBetween(endDateOth);
        ytdWeeksOth = ytdWeeksOth / 7;
        if (ytdIncomeOth != null) {
            if (ytdWeeksOth > 0) {
                annualIncomeOth = ytdIncomeOth / ytdWeeksOth * 52;
            } else {
                annualIncomeOth = ytdIncomeOth / 1 * 52;
            }
            Decimal tx = taxCalculate(annualIncomeOth);
            Decimal md = annualIncomeOth * 0.02;
            ytdMonIncomeOth = (annualIncomeOth - tx - md) / 12;
        }
        servicingCalc = false;
        quotingTool = false;
        ytdCalc = true;
        assetDetails = false;
        notesSection = false;
        return null;
    }
    
    private static decimal taxCalculate(decimal income) {
        decimal tax = 0.0;
        if (income <= 18200) {
            tax = 0.0;
        } else if (income <= 37000) {
            tax = (income - 18200) * 0.19;
        } else if (income <= 80000) {
            tax = 3572 + ((income - 37000) * 0.325);
        } else if (income <= 180000) {
            tax = 17547 + ((income - 80000) * 0.37);
        } else {
            tax = 54547 + ((income - 180000) * 0.45);
        }
        return tax;
    }
        
    public PageReference ytdSavePdf() {
        return ytdSaveCalculationPdf(false);
    }
    
    public PageReference ytdSavePreApprovalPdf() {
        return ytdSaveCalculationPdf(true);
    }
    
    private PageReference ytdSaveCalculationPdf(boolean preApproval) {
        servicingCalc = false;
        ytdCalc = true;
        quotingTool = false;
        assetDetails = false;
        notesSection = false;
        PageReference pdf = null;
        String fileNick = '';
        
        Application_YTD__c ytd = null;
        if (this.Opp.ApplicationYTD__c != null) {
            ytd = this.Opp.ApplicationYTD__r;
        }
        if (ytd == null) {
            ytd = new Application_YTD__c();
        }
        YTDCalculatorDTO dto = new YTDCalculatorDTO();
        dto.ytdLender = ytdCalcLender;
        ytd.Type__c = ytdCalcLender;
        //Lelo      Pepper          2018-06-10
        ytd.Latest_Payment_1__c = null;
        ytd.Latest_Payment_Frequency_1__c = null;
        ytd.Latest_Payment_Monthly_1__c = null;
        ytd.Latest_Payment_2__c = null;
        ytd.Latest_Payment_Frequency_2__c = null;
        ytd.Latest_Payment_Monthly_2__c = null;
        //-
        if ('Esanda'.endsWithIgnoreCase(ytdCalcLender) || 'Pepper'.endsWithIgnoreCase(ytdCalcLender)) {
            //if (isYtdEsandaPdfReadyToGenerate()) {
            if(isEsandaValidated()){
                saveYTDCalculator();
                /*
                fileNick = ytdCalcLender;
                pdf = Page.GenerateYtdEsandaPdf;
                pdf.getParameters().put('id', Opp.Id);
                dto.startDate = String.valueOf(startDate);
                dto.endDate = String.valueOf(endDate);
                dto.ytdWeeks = formatDecimalValues(ytdWeeks, 1);
                dto.ytdIncome = String.valueOf(ytdIncome.format());
                dto.baseIncome = String.valueOf(baseIncome.format());
                dto.monDifference = formatDecimalValues(monDifference);
                dto.discDiff = formatDecimalValues(discDiff);
                dto.outAmount = formatDecimalValues(outAmount);
                dto.baseTax = String.valueOf(baseTax.format());
                dto.baseMedi = String.valueOf(baseMedi.format());
                dto.ytdMonIncome = formatDecimalValues(ytdMonIncome);
                dto.netMonIncome = formatDecimalValues(netMonIncome);
                dto.ytdComment1 = ytdComment1;
                dto.latestPay1 = this.latestPay1;
                dto.latestPayFrequency1 = this.latestPayFrequency1;
                dto.latestPayMonthly1 = this.latestPayMonthly1;
                ytd.Start_Date_1__c = startDate;
                ytd.End_Date_1__c = endDate;
                ytd.Weeks_1__c = ytdWeeks.setScale(1);
                ytd.Income_1_1__c = ytdIncome;
                ytd.Income_1_2__c = baseIncome;
                ytd.Difference_1__c = monDifference;
                ytd.Discounted_1__c = discDiff;
                ytd.Monthly_Amount_Servicing_1__c = outAmount;
                ytd.Income_Monthly_1_1__c = ytdMonIncome;
                ytd.Income_Monthly_1_2__c = netMonIncome;
                ytd.Comment_1__c = ytdComment1;
                ytd.Latest_Payment_1__c = this.latestPay1;
                ytd.Latest_Payment_Frequency_1__c = this.latestPayFrequency1;
                ytd.Latest_Payment_Monthly_1__c = this.latestPayMonthly1;
                //Applicant 2
                if (opp.Application__r.No_of_People__c == 2) {
                    dto.startDateA2 = String.valueOf(startDateA2);
                    dto.endDateA2 = String.valueOf(endDateA2);
                    dto.ytdWeeksA2 = formatDecimalValues(ytdWeeksA2, 1);
                    dto.ytdIncomeA2 = String.valueOf(ytdIncomeA2.format());
                    dto.baseIncomeA2 = String.valueOf(baseIncomeA2.format());
                    dto.monDifferenceA2 = formatDecimalValues(monDifferenceA2);
                    dto.discDiffA2 = formatDecimalValues(discDiffA2);
                    dto.outAmountA2 = formatDecimalValues(outAmountA2);
                    dto.ytdMonIncomeA2 = formatDecimalValues(ytdMonIncomeA2);
                    dto.netMonIncomeA2 = formatDecimalValues(netMonIncomeA2);
                    dto.ytdComment2 = ytdComment2;
                    dto.latestPay2 = this.latestPay2;
                    dto.latestPayFrequency2 = this.latestPayFrequency2;
                    dto.latestPayMonthly2 = this.latestPayMonthly2;
                    ytd.Start_Date_2__c = startDateA2;
                    ytd.End_Date_2__c = endDateA2;
                    ytd.Weeks_2__c = ytdWeeksA2.setScale(1);
                    ytd.Income_2_1__c = ytdIncomeA2;
                    ytd.Income_2_2__c = baseIncomeA2;
                    ytd.Difference_2__c = monDifferenceA2;
                    ytd.Discounted_2__c = discDiffA2;
                    ytd.Monthly_Amount_Servicing_2__c = outAmountA2;
                    ytd.Income_Monthly_2_1__c = ytdMonIncomeA2;
                    ytd.Income_Monthly_2_2__c = netMonIncomeA2;
                    ytd.Comment_2__c = ytdComment2;
                    ytd.Latest_Payment_2__c = this.latestPay2;
                    ytd.Latest_Payment_Frequency_2__c = this.latestPayFrequency2;
                    ytd.Latest_Payment_Monthly_2__c = this.latestPayMonthly2;
                } else {
                    ytd.Start_Date_2__c = null;
                    ytd.End_Date_2__c = null;
                    ytd.Weeks_2__c = null;
                    ytd.Income_2_1__c = null;
                    ytd.Income_2_2__c = null;
                    ytd.Difference_2__c = null;
                    ytd.Discounted_2__c = null;
                    ytd.Monthly_Amount_Servicing_2__c = null;
                    ytd.Income_Monthly_2_1__c = null;
                    ytd.Income_Monthly_2_2__c = null;
                    ytd.Comment_2__c = null;
                }
                ytd.Self_Employed_Class__c = null;
                ytd.Self_Employed_Type__c = null;
                ytd.Sales__c = null;
                ytd.Annually_1_1__c = null;
                ytd.Annually_1_2__c = null;
                ytd.Sales_2__c = null;
                ytd.Self_Employed_Class_2__c = null;
                ytd.Self_Employed_Type_2__c = null;
                ytd.Annually_2_1__c = null;
                ytd.Annually_2_2__c = null;
                ytd.Start_Date_A_1__c = null;
                ytd.Start_Date_A_2__c = null;
                ytd.GrossAnnualIncomeApplic1__c = null;
                ytd.GrossAnnualIncomeApplic2__c = null;
                ytd.Trustess_Number__c = null;
                ytd.Net_Profit_2__c = null;
                ytd.Full_Doc_Total_2__c = null;
                ytd.Full_Doc_Total_Monthly_2__c = null;
                ytd.Trustess_Number_2__c = null;
                ytd.Net_Profit_2_2__c = null;
                ytd.Full_Doc_Total_2_2__c = null;
                ytd.Full_Doc_Total_Monthly_2_2__c = null;
                if('Pepper'.endsWithIgnoreCase(ytdCalcLender)){
                    ytd.Comment_1__c = null;
                    ytd.Comment_2__c = null;
                }
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
*/
            }
        } else if ('Macquarie'.endsWithIgnoreCase(ytdCalcLender)) {
            //if (isYtdMacquariePdfReadyToGenerate()) {
            if(isMacquarieValidated()){
                saveYTDCalculator();
                /*
                fileNick = ytdCalcLender;
                pdf = Page.GenerateYtdMacquariePdf;
                pdf.getParameters().put('id', Opp.Id);
                dto.startDate = String.valueOf(ytdMacStartDate);
                dto.endDate = String.valueOf(ytdMacEndDate);
                dto.ytdIncome = String.valueOf(ytdMacNetYtdSalary.format());
                dto.baseIncome = String.valueOf(ytdMacPayPeriodNetSalary.format());
                dto.ytdMacPayPeriodDays = formatDecimalValues(ytdMacPayPeriodDays, 1);
                dto.ytdMacMonthlyNetYtdSalary = formatDecimalValues(ytdMacMonthlyNetYtdSalary);
                dto.ytdMacAnnuallyNetYtdSalary = formatDecimalValues(ytdMacAnnuallyNetYtdSalary);
                dto.ytdMacMonthlyPayPeriodNetSalary = formatDecimalValues(ytdMacMonthlyPayPeriodNetSalary);
                dto.ytdMacAnnuallyPayPeriodNetSalary = formatDecimalValues(ytdMacAnnuallyPayPeriodNetSalary);
                dto.ytdMacComments = ytdMacComments;
                dto.startYtdDate = String.valueOf(ytdMacYtdStartDate);
                ytd.Start_Date_A_1__c = ytdMacYtdStartDate;
                ytd.Start_Date_1__c = ytdMacStartDate;
                ytd.End_Date_1__c = ytdMacEndDate;
                ytd.Weeks_1__c = ytdMacPayPeriodDays.setScale(1);
                ytd.Income_1_1__c = ytdMacNetYtdSalary;
                ytd.Income_1_2__c = ytdMacPayPeriodNetSalary;
                ytd.Income_Monthly_1_1__c = ytdMacMonthlyNetYtdSalary;
                ytd.Annually_1_1__c = ytdMacAnnuallyNetYtdSalary;
                ytd.Income_Monthly_1_2__c = ytdMacMonthlyPayPeriodNetSalary;
                ytd.Annually_1_2__c = ytdMacAnnuallyPayPeriodNetSalary;
                ytd.Comment_1__c = ytdMacComments;
                //Applicant 2
                if (opp.Application__r.No_of_People__c == 2) {
                    dto.ytdMacStartDateA2 = String.valueOf(ytdMacStartDateA2);
                    dto.ytdMacEndDateA2 = String.valueOf(ytdMacEndDateA2);
                    dto.ytdMacNetYtdSalaryA2 = String.valueOf(ytdMacNetYtdSalaryA2.format());
                    dto.ytdMacPayPeriodNetSalaryA2 = String.valueOf(ytdMacPayPeriodNetSalaryA2.format());
                    dto.ytdMacPayPeriodDaysA2 = formatDecimalValues(ytdMacPayPeriodDaysA2, 1);
                    dto.ytdMacMonthlyNetYtdSalaryA2 = formatDecimalValues(ytdMacMonthlyNetYtdSalaryA2);
                    dto.ytdMacAnnuallyNetYtdSalaryA2 = formatDecimalValues(ytdMacAnnuallyNetYtdSalaryA2);
                    dto.ytdMacMonthlyPayPeriodNetSalaryA2 = formatDecimalValues(ytdMacMonthlyPayPeriodNetSalaryA2);
                    dto.ytdMacAnnuallyPayPeriodNetSalaryA2 = formatDecimalValues(ytdMacAnnuallyPayPeriodNetSalaryA2);
                    dto.ytdMacCommentsA2 = ytdMacCommentsA2;
                    dto.startYtdDateA2 = String.valueOf(ytdMacYtdStartDateA2);
                    ytd.Start_Date_A_2__c = ytdMacYtdStartDateA2;
                    ytd.Start_Date_2__c = ytdMacStartDateA2;
                    ytd.End_Date_2__c = ytdMacEndDateA2;
                    ytd.Weeks_2__c = ytdMacPayPeriodDaysA2.setScale(1);
                    ytd.Income_2_1__c = ytdMacNetYtdSalaryA2;
                    ytd.Income_2_2__c = ytdMacPayPeriodNetSalaryA2;
                    ytd.Income_Monthly_2_1__c = ytdMacMonthlyNetYtdSalaryA2;
                    ytd.Annually_2_1__c = ytdMacAnnuallyNetYtdSalaryA2;
                    ytd.Income_Monthly_2_2__c = ytdMacMonthlyPayPeriodNetSalaryA2;
                    ytd.Annually_2_2__c = ytdMacAnnuallyPayPeriodNetSalaryA2;
                    ytd.Comment_2__c = ytdMacCommentsA2;
                } else {
                    ytd.Start_Date_A_2__c = null;
                    ytd.Start_Date_2__c = null;
                    ytd.End_Date_2__c = null;
                    ytd.Weeks_2__c = null;
                    ytd.Income_2_1__c = null;
                    ytd.Income_2_2__c = null;
                    ytd.Income_Monthly_2_1__c = null;
                    ytd.Annually_2_1__c = null;
                    ytd.Income_Monthly_2_2__c = null;
                    ytd.Annually_2_2__c = null;
                    ytd.Comment_2__c = null;
                }
                ytd.Self_Employed_Class__c = null;
                ytd.Self_Employed_Type__c = null;
                ytd.Sales__c = null;
                ytd.Sales_2__c = null;
                ytd.Self_Employed_Class_2__c = null;
                ytd.Self_Employed_Type_2__c = null;
                ytd.Difference_1__c = null;
                ytd.Discounted_1__c = null;
                ytd.Monthly_Amount_Servicing_1__c = null;
                ytd.Difference_2__c = null;
                ytd.Discounted_2__c = null;
                ytd.Monthly_Amount_Servicing_2__c = null;
                ytd.GrossAnnualIncomeApplic1__c = null;
                ytd.GrossAnnualIncomeApplic2__c = null;
                ytd.Trustess_Number__c = null;
                ytd.Net_Profit_2__c = null;
                ytd.Full_Doc_Total_2__c = null;
                ytd.Full_Doc_Total_Monthly_2__c = null;
                ytd.Trustess_Number_2__c = null;
                ytd.Net_Profit_2_2__c = null;
                ytd.Full_Doc_Total_2_2__c = null;
                ytd.Full_Doc_Total_Monthly_2_2__c = null;
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
                */
            }
        } else if ('Others'.endsWithIgnoreCase(ytdCalcLender)) {
            //if (isYtdOthersPdfReadyToGenerate()) {
            if(isOthersValidated()){
                saveYTDCalculator();
                /*
                fileNick = ytdCalcLender;
                pdf = Page.GenerateYtdPdf;
                dto.startDate = String.valueOf(startDateOth);
                dto.endDate = String.valueOf(endDateOth);
                dto.ytdWeeks = formatDecimalValues(ytdWeeksOth, 1);
                dto.ytdIncome = String.valueOf(ytdIncomeOth.format());
                dto.ytdMonIncome = formatDecimalValues(ytdMonIncomeOth);
                dto.annualIncome = formatDecimalValues(annualIncomeOth);
                ytd.Start_Date_1__c = startDateOth;
                ytd.End_Date_1__c = endDateOth;
                ytd.Weeks_1__c = ytdWeeksOth.setScale(1);
                ytd.Income_1_1__c = ytdIncomeOth;
                ytd.Income_1_2__c = annualIncomeOth;
                ytd.Income_Monthly_1_1__c = ytdMonIncomeOth;
                if('Firstmac'.equals(ytdLenderApplic)){
                    if(ytdGrossAnnualIncomeApplic1 != null){
                        if(ytdGrossAnnualIncomeApplic1 == 0){
                            ytd.GrossAnnualIncomeApplic1__c = 0.00;
                            dto.GrossAnnualIncomeApplic1 = 0.00;
                            dto.YTDGrossLenderApplic1 = 'Firstmac';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Gross Annual Income in Application 1 is 0.00')); 
                        }else{
                            ytd.GrossAnnualIncomeApplic1__c = ytdGrossAnnualIncomeApplic1;
                            dto.GrossAnnualIncomeApplic1 = ytdGrossAnnualIncomeApplic1;
                            dto.YTDGrossLenderApplic1 = 'Firstmac';    
                        }
                    }
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    dto.startDateOthA2 = String.valueOf(startDateOthA2);
                    dto.endDateOthA2 = String.valueOf(endDateOthA2);
                    dto.ytdWeeksOthA2 = formatDecimalValues(ytdWeeksOthA2, 1);
                    dto.ytdIncomeOthA2 = String.valueOf(ytdIncomeOthA2.format());
                    dto.ytdMonIncomeOthA2 = formatDecimalValues(ytdMonIncomeOthA2);
                    dto.annualIncomeOthA2 = formatDecimalValues(annualIncomeOthA2);
                    ytd.Start_Date_2__c = startDateOthA2;
                    ytd.End_Date_2__c = endDateOthA2;
                    ytd.Weeks_2__c = ytdWeeksOthA2.setScale(1);
                    ytd.Income_2_1__c = ytdIncomeOthA2;
                    ytd.Income_Monthly_2_1__c = ytdMonIncomeOthA2;
                    ytd.Income_2_2__c = annualIncomeOthA2;
                    if('Firstmac'.equals(ytdLenderApplic)){
                        if(ytdGrossAnnualIncomeApplic2 != null){
                            if(ytdGrossAnnualIncomeApplic2 == 0){
                                ytd.GrossAnnualIncomeApplic2__c = 0.00;
                                dto.GrossAnnualIncomeApplic2 = 0.00;
                                dto.YTDGrossLenderApplic2 = 'Firstmac';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Gross Annual Income in Application 2 is 0.00')); 
                            }else{
                                ytd.GrossAnnualIncomeApplic2__c = ytdGrossAnnualIncomeApplic2;
                                dto.GrossAnnualIncomeApplic2 = ytdGrossAnnualIncomeApplic2;
                                dto.YTDGrossLenderApplic2 = 'Firstmac';    
                            }
                        }
                    }
                }else{
                    ytd.Start_Date_2__c = null;
                    ytd.End_Date_2__c = null;
                    ytd.Weeks_2__c = null;
                    ytd.Income_2_1__c = null;
                    ytd.Income_Monthly_2_1__c = null;
                    ytd.Income_2_2__c = null;
                    ytd.GrossAnnualIncomeApplic2__c = null;
                }
                ytd.Difference_1__c = null;
                ytd.Discounted_1__c = null;
                ytd.Monthly_Amount_Servicing_1__c = null;
                ytd.Income_Monthly_1_2__c = null;
                ytd.Comment_1__c = null;
                ytd.Difference_2__c = null;
                ytd.Discounted_2__c = null;
                ytd.Monthly_Amount_Servicing_2__c = null;
                ytd.Income_Monthly_2_2__c = null;
                ytd.Comment_2__c = null;
                ytd.Self_Employed_Class__c = null;
                ytd.Self_Employed_Type__c = null;
                ytd.Sales__c = null;
                ytd.Annually_1_1__c = null;
                ytd.Annually_1_2__c = null;
                ytd.Sales_2__c = null;
                ytd.Self_Employed_Class_2__c = null;
                ytd.Self_Employed_Type_2__c = null;
                ytd.Annually_2_1__c = null;
                ytd.Annually_2_2__c = null;
                ytd.Start_Date_A_1__c = null;
                ytd.Start_Date_A_2__c = null;
                ytd.Trustess_Number__c = null;
                ytd.Net_Profit_2__c = null;
                ytd.Full_Doc_Total_2__c = null;
                ytd.Full_Doc_Total_Monthly_2__c = null;
                ytd.Trustess_Number_2__c = null;
                ytd.Net_Profit_2_2__c = null;
                ytd.Full_Doc_Total_2_2__c = null;
                ytd.Full_Doc_Total_Monthly_2_2__c = null;
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
                */
            }
        } else if ('Self-Employed'.endsWithIgnoreCase(ytdCalcLender)) {
            /*
            Boolean app1 = isYtdFullDocPdfReadyToGenerate();
            Boolean app2 = true;
            if (opp.Application__r.No_of_People__c == 2) {
                app2 = isYtdFullDocPdfReadyToGenerate2();
            }
if (app1 && app2) {
*/
            if (isSelfEmployedValidated()) {
                saveYTDCalculator();
              /*
                fileNick = 'SelfEmployed_' + fldSelfEmployedClass;
                pdf = Page.GenerateYtdPdf;
                pdf.getParameters().put('id', Opp.Id);
                dto.ytdLender = ytdCalcLender;
                */
                //dto.fdLender = fdLender;
                /*
                dto.fdNetProfit = fdNetProfit;
                if ('Company Pty Ltd'.equals(fldSelfEmployedType) && this.fdSales != null && this.fdSales > 0) {
                    dto.sales = this.fdSales;
                }
                if (fdNetProfit != null) dto.fdNetProfitDiscount = fdNetProfit * 0.3;
                dto.fullDocumentationTotal = getFullDocumentationTotal();
                dto.fullDocTotalMonthly = getFullDocumentationMonthlyTotal();
                dto.selfEmployedClass = fldSelfEmployedClass;
                dto.selfEmployedType = fldSelfEmployedType;
                if ('Trust'.equals(this.fldSelfEmployedType)) {
                    dto.trusteesNumber = this.trusteesNumber;
                    if ('2'.equals(this.trusteesNumber)) {
                        */
                        //dto.fdNetProfit2 = fdNetProfit;
                        /*
                        dto.fdNetProfit2 = fdNetProfit2;
*/
                        // dto.fdDepreciation2 = fdDepreciation2;
                        // dto.fdInterest2 = fdInterest2;
                        // dto.fdDirectorSalary2 = fdDirectorSalary2;
                        /*
                        dto.fullDocumentationTotal2 = getFullDocumentationTotal2();
                        dto.fullDocTotalMonthly2 = getFullDocumentationMonthlyTotal2();
                    }
                } else {
                    dto.fdDepreciation = fdDepreciation;
                    dto.fdInterest = fdInterest;
                    dto.fdDirectorSalary = fdDirectorSalary;
                }
                ytd.Self_Employed_Class__c = fldSelfEmployedClass;
                ytd.Self_Employed_Type__c = fldSelfEmployedType;
                ytd.Income_Monthly_1_1__c = fdNetProfit;
                if ('Company Pty Ltd'.equals(fldSelfEmployedType) && this.fdSales != null && this.fdSales > 0) {
                    ytd.Sales__c = this.fdSales;
                }
                ytd.Difference_1__c = fdNetProfit * 0.3;
                ytd.Income_Monthly_1_2__c = fdDepreciation;
                ytd.Annually_1_1__c = fdInterest;
                ytd.Annually_1_2__c = fdDirectorSalary;
                ytd.Income_1_1__c = getFullDocumentationTotal();
                ytd.Monthly_Amount_Servicing_1__c = getFullDocumentationMonthlyTotal();
                ytd.Start_Date_1__c = null;
                ytd.End_Date_1__c = null;
                ytd.Weeks_1__c = null;
                ytd.Income_1_2__c = null;
                ytd.Discounted_1__c = null;
                ytd.Comment_1__c = null;
                ytd.Start_Date_2__c = null;
                ytd.End_Date_2__c = null;
                ytd.Weeks_2__c = null;
                ytd.Income_2_1__c = null;
                ytd.Income_2_2__c = null;
*/
                //ytd.Difference_2__c = null;
                /*
                ytd.Discounted_2__c = null;
            */
                //ytd.Monthly_Amount_Servicing_2__c = null;
                //ytd.Income_Monthly_2_1__c = null;
                //ytd.Income_Monthly_2_2__c = null;
                /*
                ytd.Comment_2__c = null;
            */
                //ytd.Annually_2_1__c = null;
                //ytd.Annually_2_2__c = null;
                /*
                ytd.Net_Profit_2__c = null;
            */
                // ytd.Depreciation_2__c = null;
                // ytd.Interest_2__c = null;
                // ytd.Director_Salary_2__c = null;
                /*
                ytd.Full_Doc_Total_2__c = null;
                ytd.Full_Doc_Total_Monthly_2__c = null;
                ytd.Trustess_Number__c = null;
                ytd.GrossAnnualIncomeApplic1__c = null;
                ytd.GrossAnnualIncomeApplic2__c = null;
                ytd.Start_Date_A_1__c = null;
                ytd.Start_Date_A_2__c = null;
                if ('Sole Trader'.equals(this.fldSelfEmployedType)) {
                    ytd.Sales__c = null;
                    ytd.Income_1_1__c = getFullDocumentationMonthlyTotal() * 12;
                }
                if ('Trust'.equals(this.fldSelfEmployedType)) {
                    ytd.Income_Monthly_1_2__c = null;
                    ytd.Annually_1_1__c = null;
                    ytd.Annually_1_2__c = null;
                    ytd.Trustess_Number__c = this.trusteesNumber;
                    ytd.Sales__c = null;
                    if ('2'.equals(this.trusteesNumber)) {
                        ytd.Net_Profit_2__c = fdNetProfit2;
                        */
                        // ytd.Depreciation_2__c = fdDepreciation2;
                        // ytd.Interest_2__c = fdInterest2;
                        // ytd.Director_Salary_2__c = fdDirectorSalary2;
                        /*
                        ytd.Full_Doc_Total_2__c = getFullDocumentationTotal2();
                        ytd.Full_Doc_Total_Monthly_2__c = getFullDocumentationMonthlyTotal2();
                    }
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    dto.fdNetProfit_2 = fdNetProfit_2;
                    if ('Company Pty Ltd'.equals(fldSelfEmployedType2) && this.fdSales2 != null && this.fdSales2 > 0) {
                        dto.sales2 = this.fdSales2;
                    }
                    if (fdNetProfit_2 != null) dto.fdNetProfitDiscount2 = fdNetProfit_2 * 0.3;
                    dto.fullDocumentationTotal_2 = getFullDocumentationTotal_2();
                    dto.fullDocTotalMonthly_2 = getFullDocumentationMonthlyTotal_2();
                    dto.selfEmployedClass2 = fldSelfEmployedClass2;
                    dto.selfEmployedType2 = fldSelfEmployedType2;
                    if ('Trust'.equals(this.fldSelfEmployedType2)) {
                        dto.trusteesNumber2 = this.trusteesNumber2;
                        if ('2'.equals(this.trusteesNumber2)) {
                            dto.fdNetProfit2_2 = fdNetProfit2_2;
                            */
                            // dto.fdDepreciation2 = fdDepreciation2;
                            // dto.fdInterest2 = fdInterest2;
                            // dto.fdDirectorSalary2 = fdDirectorSalary2;
                            /*
                            dto.fullDocumentationTotal2_2 = getFullDocumentationTotal2_2();
                            dto.fullDocTotalMonthly2_2 = getFullDocumentationMonthlyTotal2_2();
                        }
                    } else {
                        dto.fdDepreciation2 = fdDepreciation2;
                        dto.fdInterest2 = fdInterest2;
                        dto.fdDirectorSalary2 = fdDirectorSalary2;
                    }
                    ytd.Self_Employed_Class_2__c = fldSelfEmployedClass2;
                    ytd.Self_Employed_Type_2__c = fldSelfEmployedType2;
                    ytd.Income_Monthly_2_1__c = fdNetProfit_2;
                    if ('Company Pty Ltd'.equals(fldSelfEmployedType2) && this.fdSales2 != null && this.fdSales2 > 0) {
                        ytd.Sales_2__c = this.fdSales2;
                    }
                    ytd.Difference_2__c = fdNetProfit_2 * 0.3;
                    ytd.Income_Monthly_2_2__c = fdDepreciation2;
                    ytd.Annually_2_1__c = fdInterest2;
                    ytd.Annually_2_2__c = fdDirectorSalary2;
                    ytd.Income_2_1__c = getFullDocumentationTotal_2();
                    ytd.Monthly_Amount_Servicing_2__c = getFullDocumentationMonthlyTotal_2();
                    ytd.Net_Profit_2_2__c = null;
                    ytd.Full_Doc_Total_2_2__c = null;
                    ytd.Full_Doc_Total_Monthly_2_2__c = null;
                    ytd.Trustess_Number_2__c = null;
                    if ('Sole Trader'.equals(this.fldSelfEmployedType2)) {
                        ytd.Sales_2__c = null;
                        ytd.Income_2_1__c = getFullDocumentationMonthlyTotal_2() * 12;
                    }
                    if ('Trust'.equals(this.fldSelfEmployedType2)) {
                        ytd.Income_Monthly_2_2__c = null;
                        ytd.Annually_2_1__c = null;
                        ytd.Annually_2_2__c = null;
                        ytd.Trustess_Number_2__c = this.trusteesNumber2;
                        ytd.Sales_2__c = null;
                        if ('2'.equals(this.trusteesNumber2)) {
                            ytd.Net_Profit_2_2__c = fdNetProfit2_2;
                            */
                            // ytd.Depreciation_2__c = fdDepreciation2;
                            // ytd.Interest_2__c = fdInterest2;
                            // ytd.Director_Salary_2__c = fdDirectorSalary2;
                            /*
                            ytd.Full_Doc_Total_2_2__c = getFullDocumentationTotal2_2();
                            ytd.Full_Doc_Total_Monthly_2_2__c = getFullDocumentationMonthlyTotal2_2();
                        }
                    }
                }else{
                    ytd.Self_Employed_Class_2__c = null;
                    ytd.Self_Employed_Type_2__c = null;
                    ytd.Difference_2__c = null;
                    ytd.Income_Monthly_2_1__c = null;
                    ytd.Sales_2__c = null;
                    ytd.Income_Monthly_2_2__c = null;
                    ytd.Annually_2_1__c = null;
                    ytd.Annually_2_2__c = null;
                    ytd.Income_2_1__c = null;
                    ytd.Monthly_Amount_Servicing_2__c = null;                
                    ytd.Full_Doc_Total_2_2__c = null;
                    ytd.Full_Doc_Total_Monthly_2_2__c = null;
                    ytd.Trustess_Number_2__c = null;
                    ytd.Net_Profit_2_2__c = null;
                }
                
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
*/  
            }
        }
        /*
        if (ytd.Id == null) {
            insert ytd;
            this.Opp.ApplicationYTD__c = ytd.Id;
            update this.Opp;
        } else {
            update ytd;
        }
*/
        //Update Application
        /*
        if (this.Opp.Application__r != null) {
            if (ytd.Type__c == 'Esanda') {
                this.Opp.Application__r.Net_Income_1__c = ytd.Income_Monthly_1_2__c;
                this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                if (opp.Application__r.No_of_People__c == 2) {
                    this.Opp.Application__r.Net_Income_2__c = ytd.Income_Monthly_2_2__c;
                    this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                }
            } else if (ytd.Type__c == 'Pepper') {
                List < Decimal > tmpIncs = new List < Decimal > ();
                if (ytd.Income_Monthly_1_1__c != null && ytd.Income_Monthly_1_1__c > 0) {
                    tmpIncs.add(ytd.Income_Monthly_1_1__c);
                }
                if (ytd.Income_Monthly_1_2__c != null && ytd.Income_Monthly_1_2__c > 0) {
                    tmpIncs.add(ytd.Income_Monthly_1_2__c);
                }
                if (ytd.Latest_Payment_Monthly_1__c != null && ytd.Latest_Payment_Monthly_1__c > 0) {
                    tmpIncs.add(ytd.Latest_Payment_Monthly_1__c);
                }
                if (!tmpIncs.isEmpty()) {
                    tmpIncs.sort();
                    this.Opp.Application__r.Net_Income_1__c = tmpIncs.get(0);
                }
                this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                if (opp.Application__r.No_of_People__c == 2) {
                    tmpIncs = new List < Decimal > ();
                    if (ytd.Income_Monthly_2_1__c != null && ytd.Income_Monthly_2_1__c > 0) {
                        tmpIncs.add(ytd.Income_Monthly_2_1__c);
                    }
                    if (ytd.Income_Monthly_2_2__c != null && ytd.Income_Monthly_2_2__c > 0) {
                        tmpIncs.add(ytd.Income_Monthly_2_2__c);
                    }
                    if (ytd.Latest_Payment_Monthly_2__c != null && ytd.Latest_Payment_Monthly_2__c > 0) {
                        tmpIncs.add(ytd.Latest_Payment_Monthly_2__c);
                    }
                    if (!tmpIncs.isEmpty()) {
                        tmpIncs.sort();
                        this.Opp.Application__r.Net_Income_2__c = tmpIncs.get(0);
                    }
                    this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                }
            } else if (ytd.Type__c == 'Macquarie') {
                if (ytd.Income_Monthly_1_1__c != null && ytd.Income_Monthly_1_2__c != null) {
                    if (ytd.Income_Monthly_1_1__c < ytd.Income_Monthly_1_2__c) {
                        this.Opp.Application__r.Net_Income_1__c = ytd.Income_Monthly_1_1__c;
                    } else {
                        this.Opp.Application__r.Net_Income_1__c = ytd.Income_Monthly_1_2__c;
                    }
                    this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    if (ytd.Income_Monthly_2_1__c != null && ytd.Income_Monthly_2_2__c != null) {
                        if (ytd.Income_Monthly_2_1__c < ytd.Income_Monthly_2_2__c) {
                            this.Opp.Application__r.Net_Income_2__c = ytd.Income_Monthly_2_1__c;
                        } else {
                            this.Opp.Application__r.Net_Income_2__c = ytd.Income_Monthly_2_2__c;
                        }
                        this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                    }
                }
            } else if (ytd.Type__c == 'Others') {
                */
                //this.Opp.Application__r.Net_Income_1__c = ytd.Income_Monthly_1_1__c;
                //this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                /*if(ytd.GrossAnnualIncomeApplic1__c != null){
                    this.Opp.ApplicationYTD__r.GrossAnnualIncomeApplic1__c = ytd.GrossAnnualIncomeApplic1__c;
                    ytdLenderApplic = 'Firstmac';
                }*/
                //if (opp.Application__r.No_of_People__c == 2) {
                    //this.Opp.Application__r.Net_Income_2__c = ytd.Income_Monthly_2_1__c;
                    //this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                     /*if(ytd.GrossAnnualIncomeApplic2__c != null){
                     	this.Opp.ApplicationYTD__r.GrossAnnualIncomeApplic2__c = ytd.GrossAnnualIncomeApplic2__c;
                        ytdLenderApplic2 = 'Firstmac';
                     }*/
                //}
            //}
            //update this.Opp.Application__r;
        //}
        //loadServicingCalculatorData();
        String prefixName = 'YTD_' + fileNick;
        if (preApproval) {
            prefixName += '_PRE_APPROVAL';
            if (this.Opp.Application__c != null) {
                ApplicationExtraDataHelper.upsertData(this.Opp.Application__r.id, fileNick, 'YTD Calculation', this.dataMap);
            }
        }
        
        return null;
    }
    
    public void saveYTDCalculator(){
        List<YTD_Income__c> ytd = new List<YTD_Income__c>();
        List<YTD_Income__c> ytd2 = new List<YTD_Income__c>();
        List<Application_Employment__c> emp = new List<Application_Employment__c>();
        
        Set <String> a = new Set<String>();
        a = dataMap.keySet();
        
        for(String t: a){
            YTD_Income__c o = this.dataMap.get(t);
            o.Opportunity__c = Opp.Id;
            o.Type__c = ytdCalcLender;
            if(ytdCalcLender.equals('Others')){
                o.Weeks__c = o.Weeks__c.setScale(1);
                o.Gross_Net_Income__c = null;
                o.Net_Annual_Income__c = null;
                o.Net_Income__c = null;
                o.Net_Last_Income__c = null;
                o.Last_Income_Frequency__c = null;
                o.Self_Employed_Class__c = null;
                o.Self_Employed_Type__c = null;
                o.Trustees_Number__c = null;
                o.Net_Profit__c = null;
                o.Net_Profit_2__c = null;
                o.Depreciation__c = null;
                o.Director_Salary__c = null;
                o.Interest__c = null;
                o.Sales__c = null;
                o.Comment__c = null;
                o.Employment_Start_Date__c = null;
                o.Net_YTD_Salary_Annually__c = null;
                o.Net_YTD_Salary_Monthly__c = null;
                o.Pay_Period_Annually__c = null;
                o.Pay_Period_Monthly__c = null;
                o.Net_Profit_Calc_After_Tax__c = null;
                o.Difference__c = null;
                o.Discounted__c = null;
                o.Monthly_Amount__c = null;
                o.Net_Profit_Calc__c = null;
                o.Net_Profit_Calc_2__c = null;
                o.Net_Monthly_Income_2__c = null;
                if(APPTYPE_1.equals(o.Applicant_Type__c)){
                    o.Lender__c = ytdLenderApplic;
                }else{
                    o.Lender__c = null;
                }
                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_1_2NDJOB);
                        e.Income__c = o.Net_Monthly_Income__c;
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_2_2NDJOB);
                        e.Income__c = o.Net_Monthly_Income__c;
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if (this.Opp.Application__r != null) {
                    if(APPTYPE_1.equals(o.Applicant_Type__c)){
                        this.Opp.Application__r.Net_Income_1__c = o.Net_Monthly_Income__c;
                        this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                    }
                    if(APPTYPE_2.equals(o.Applicant_Type__c)){
                        this.Opp.Application__r.Net_Income_2__c = o.Net_Monthly_Income__c;
                        this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                    }
                }
            }
            if(ytdCalcLender.equals('Pepper')){
                o.Annualised_Income__c = null;
                o.Net_Monthly_Income__c = null;
                o.Gross_Annual_Income__c = null;
                o.Weeks__c = o.Weeks__c.setScale(1);
                o.Lender__c = null;
                o.Self_Employed_Class__c = null;
                o.Self_Employed_Type__c = null;
                o.Trustees_Number__c = null;
                o.Net_Profit__c = null;
                o.Net_Profit_2__c = null;
                o.Depreciation__c = null;
                o.Director_Salary__c = null;
                o.Interest__c = null;
                o.Sales__c = null;
                o.Employment_Start_Date__c = null;
                o.Net_YTD_Salary_Annually__c = null;
                o.Net_YTD_Salary_Monthly__c = null;
                o.Pay_Period_Annually__c = null;
                o.Pay_Period_Monthly__c = null;
                o.Comment__c = null;
                o.Net_Profit_Calc_After_Tax__c = null;
                o.Difference__c = null;
                o.Discounted__c = null;
                o.Monthly_Amount__c = null;
                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_1_2NDJOB);
                        List < Decimal > tmpIncs = new List < Decimal > ();
                        if (o.Net_Income__c!= null && o.Net_Income__c > 0) {
                            tmpIncs.add(o.Net_Income__c);
                        }
                        if (o.Gross_Net_Income__c != null && o.Gross_Net_Income__c > 0) {
                            tmpIncs.add(o.Gross_Net_Income__c);
                        }
                        if (o.Net_Last_Monthly_Income__c != null && o.Net_Last_Monthly_Income__c > 0) {
                            tmpIncs.add(o.Net_Last_Monthly_Income__c);
                        }
                        if (!tmpIncs.isEmpty()) {
                            tmpIncs.sort();
                            e.Income__c = tmpIncs.get(0);
                        }
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_2_2NDJOB);
                        List < Decimal > tmpIncs = new List < Decimal > ();
                        if (o.Net_Income__c != null && o.Net_Income__c > 0) {
                            tmpIncs.add(o.Net_Income__c);
                        }
                        if (o.Gross_Net_Income__c != null && o.Gross_Net_Income__c > 0) {
                            tmpIncs.add(o.Gross_Net_Income__c);
                        }
                        if (o.Net_Last_Monthly_Income__c != null && o.Net_Last_Monthly_Income__c > 0) {
                            tmpIncs.add(o.Net_Last_Monthly_Income__c);
                        }
                        if (!tmpIncs.isEmpty()) {
                            tmpIncs.sort();
                            e.Income__c = tmpIncs.get(0);
                        }
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if (this.Opp.Application__r != null) {
                    if(APPTYPE_1.equals(o.Applicant_Type__c)){
                        List < Decimal > tmpIncs = new List < Decimal > ();
                        if (o.Net_Income__c != null && o.Net_Income__c > 0) {
                            tmpIncs.add(o.Net_Income__c);
                        }
                        if (o.Gross_Net_Income__c != null && o.Gross_Net_Income__c > 0) {
                            tmpIncs.add(o.Gross_Net_Income__c);
                        }
                        if (o.Net_Last_Monthly_Income__c != null && o.Net_Last_Monthly_Income__c > 0) {
                            tmpIncs.add(o.Net_Last_Monthly_Income__c);
                        }
                        if (!tmpIncs.isEmpty()) {
                            tmpIncs.sort();
                            this.Opp.Application__r.Net_Income_1__c = tmpIncs.get(0);
                        }
                        this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                    }
                    if(APPTYPE_2.equals(o.Applicant_Type__c)){
                        if (opp.Application__r.No_of_People__c == 2) {
                            List < Decimal > tmpIncs = new List < Decimal > ();
                            if (o.Net_Income__c != null && o.Net_Income__c > 0) {
                                tmpIncs.add(o.Net_Income__c);
                            }
                            if (o.Gross_Net_Income__c != null && o.Gross_Net_Income__c > 0) {
                                tmpIncs.add(o.Gross_Net_Income__c);
                            }
                            if (o.Net_Last_Monthly_Income__c != null && o.Net_Last_Monthly_Income__c > 0) {
                                tmpIncs.add(o.Net_Last_Monthly_Income__c);
                            }
                            if (!tmpIncs.isEmpty()) {
                                tmpIncs.sort();
                                this.Opp.Application__r.Net_Income_2__c = tmpIncs.get(0);
                            }
                            this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                        }
                    }
                }
            }
            if(ytdCalcLender.equals('Macquarie')){
                o.Annualised_Income__c = null;
                o.Net_Monthly_Income__c = null;
                o.Gross_Annual_Income__c = null;
                o.Weeks__c = o.Weeks__c.setScale(1);
                o.Lender__c = null;
                o.Self_Employed_Class__c = null;
                o.Self_Employed_Type__c = null;
                o.Trustees_Number__c = null;
                o.Net_Profit__c = null;
                o.Net_Profit_2__c = null;
                o.Depreciation__c = null;
                o.Director_Salary__c = null;
                o.Interest__c = null;
                o.Sales__c = null;
                o.Gross_YTD_Income__c = null;
                o.Gross_Net_Income__c = null;
                o.Last_Income_Frequency__c = null;
                o.Net_Income__c = null;
                o.Net_Profit_Calc_After_Tax__c = null;
                o.Difference__c = null;
                o.Discounted__c = null;
                o.Monthly_Amount__c = null;
                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_1_2NDJOB);
                        if (o.Net_YTD_Salary_Monthly__c != null && o.Pay_Period_Monthly__c != null) {
                            if (o.Net_YTD_Salary_Monthly__c < o.Pay_Period_Monthly__c) {
                                e.Income__c = o.Net_YTD_Salary_Monthly__c;
                            } else {
                                e.Income__c = o.Pay_Period_Monthly__c;
                            }
                            e.Frequency__c = 'Monthly';
                        }
                        emp.add(e);
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_2_2NDJOB);
                        if (o.Net_YTD_Salary_Monthly__c != null && o.Pay_Period_Monthly__c != null) {
                            if (o.Net_YTD_Salary_Monthly__c < o.Pay_Period_Monthly__c) {
                                e.Income__c = o.Net_YTD_Salary_Monthly__c;
                            } else {
                                e.Income__c = o.Pay_Period_Monthly__c;
                            }
                            e.Frequency__c = 'Monthly';
                        }
                        emp.add(e);
                    }
                }
                if (this.Opp.Application__r != null) {
                    
                    if(APPTYPE_1.equals(o.Applicant_Type__c)){
                        if (o.Net_YTD_Salary_Monthly__c != null && o.Pay_Period_Monthly__c != null) {
                            if (o.Net_YTD_Salary_Monthly__c < o.Pay_Period_Monthly__c) {
                                this.Opp.Application__r.Net_Income_1__c = o.Net_YTD_Salary_Monthly__c;
                            } else {
                                this.Opp.Application__r.Net_Income_1__c = o.Pay_Period_Monthly__c;
                            }
                            this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                        }
                    }
                    
                    if(APPTYPE_2.equals(o.Applicant_Type__c)){
                        if (o.Net_YTD_Salary_Monthly__c != null && o.Pay_Period_Monthly__c != null) {
                            if (o.Net_YTD_Salary_Monthly__c < o.Pay_Period_Monthly__c) {
                                this.Opp.Application__r.Net_Income_2__c = o.Net_YTD_Salary_Monthly__c;
                            } else {
                                this.Opp.Application__r.Net_Income_2__c = o.Pay_Period_Monthly__c;
                            }
                            this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                        }
                    }
                    
                }
            }
            if(ytdCalcLender.equals('Self-Employed')){
                o.Start_Date__c = null;
                o.Employment_Start_Date__c = null;
                o.End_Date__c = null;
                o.Gross_YTD_Income__c = null;
                o.Weeks__c = null;
                o.Gross_Net_Income__c = null;
                o.Last_Income_Frequency__c = null;
                o.Net_Annual_Income__c = null;
                o.Net_Income__c = null;
                o.Net_Last_Income__c = null;
                o.Net_YTD_Salary_Annually__c = null;
                o.Net_YTD_Salary_Monthly__c = null;
                o.Pay_Period_Annually__c = null;
                o.Pay_Period_Monthly__c = null;
                o.Comment__c = null;
                o.Annualised_Income__c = null;
                o.Lender__c = null;
                o.Gross_Annual_Income__c = null;
                o.Difference__c = o.Net_Profit__c * 0.3;
                o.Discounted__c = null;
                o.Monthly_Amount__c = null;
                if(o.Net_Profit_Calc_2__c == 0){
                    o.Net_Profit_Calc_2__c = null;   
                }
                if(o.Net_Monthly_Income_2__c == 0){
                    o.Net_Monthly_Income_2__c = null;   
                }
                if(o.Self_Employed_Type__c.equals('Company Pty Ltd')){
                    o.Trustees_Number__c = null;
                    o.Net_Profit_2__c = null;
                    o.Net_Profit_Calc_After_Tax__c = null;
                    o.Net_Profit_Calc_2__c = null;
                    o.Net_Monthly_Income_2__c = null;
                }
                if(o.Self_Employed_Type__c.equals('Sole Trader')){
                    o.Sales__c = null;
                    o.Trustees_Number__c = null;
                    o.Net_Profit_2__c = null;
                    o.Net_Profit_Calc__c = null;
                    o.Net_Profit_Calc_After_Tax__c = o.Net_Monthly_Income__c * 12;
                    o.Net_Profit_Calc_2__c = null;
                    o.Net_Monthly_Income_2__c = null;
                }
                if(o.Self_Employed_Type__c.equals('Trust')){
                    o.Sales__c = null;
                    o.Depreciation__c = null;
                    o.Director_Salary__c = null;
                    o.Interest__c = null;
                    o.Net_Profit_Calc_After_Tax__c = null;
                    if(o.Trustees_Number__c == null || o.Trustees_Number__c.equals('1')){
                        o.Trustees_Number__c = '1';
                        o.Net_Profit_2__c = null;
                        o.Net_Profit_Calc_2__c = null;
                        o.Net_Monthly_Income_2__c = null;
                    }    
                }
            }
            if(ytdCalcLender.equals('Esanda')){
                o.Annualised_Income__c = null;
                o.Net_Monthly_Income__c = null;
                o.Gross_Annual_Income__c = null;
                o.Weeks__c = o.Weeks__c.setScale(1);
                o.Lender__c = null;
                o.Last_Income_Frequency__c = 'Monthly';
                o.Self_Employed_Class__c = null;
                o.Self_Employed_Type__c = null;
                o.Trustees_Number__c = null;
                o.Net_Profit__c = null;
                o.Net_Profit_2__c = null;
                o.Depreciation__c = null;
                o.Director_Salary__c = null;
                o.Interest__c = null;
                o.Sales__c = null;
                o.Employment_Start_Date__c = null;
                o.Net_YTD_Salary_Annually__c = null;
                o.Net_YTD_Salary_Monthly__c = null;
                o.Pay_Period_Annually__c = null;
                o.Pay_Period_Monthly__c = null;
                o.Net_Profit_Calc_After_Tax__c = null;
                o.Net_Last_Income__c = null;
                o.Last_Income_Frequency__c = null;
                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_1_2NDJOB);
                        e.Income__c = o.Gross_Net_Income__c;
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB)) {
                        Application_Employment__c e = this.employmentMap.get(APPTYPE_2_2NDJOB);
                        e.Income__c = o.Gross_Net_Income__c;
                        e.Frequency__c = 'Monthly';
                        emp.add(e);
                    }
                }
                if (this.Opp.Application__r != null) {
                    if(APPTYPE_1.equals(o.Applicant_Type__c)){
                        this.Opp.Application__r.Net_Income_1__c = o.Gross_Net_Income__c;
                        this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                    }
                    if(APPTYPE_2.equals(o.Applicant_Type__c)){
                        if (opp.Application__r.No_of_People__c == 2) {
                            this.Opp.Application__r.Net_Income_2__c = o.Gross_Net_Income__c;
                            this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                        }
                    }
                }
                   
                }
            ytd.add(o);
        }
        
        try{
            upsert ytd;
            update emp;
            update this.Opp.Application__r;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The record is saved successfully.'));
        }catch (Exception e){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Refresh this page because some employment details have changed in application form.'));
        }
    }
    /*
    private Boolean isYtdEsandaPdfReadyToGenerate() {
        ytdEsandaFullCalculation();
        System.debug('A1:' + ytdMonIncome + '|' + netMonIncome);
        Boolean r = true;
        if (ytdMonIncome > 0.0 && netMonIncome > 0.0) {} else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill all fields before generating the Pdf.'));
            r = false;
        }
        if (opp.Application__r.No_of_People__c == 2) {
            System.debug('A2:' + ytdMonIncomeA2 + '|' + ytdMonIncomeA2);
            if (ytdMonIncomeA2 > 0.0 && netMonIncomeA2 > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill all fields before generating the Pdf.'));
                r = false;
            }
            if ('Pepper'.endsWithIgnoreCase(ytdCalcLender)) {
                if (this.latestPayMonthly1 == null || this.latestPayMonthly1 == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill all fields before generating the Pdf.'));
                    r = false;
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    if (this.latestPayMonthly2 == null || this.latestPayMonthly2 == 0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill all fields before generating the Pdf.'));
                        r = false;
                    }
                }
            }
        }
        return r;
    }
    */
    /*
    private String formatDecimalValues(Decimal value, Integer scale) {
        if (value != null) {
            return String.valueOf(value.setScale(scale, RoundingMode.HALF_UP).format());
        }
        return null;
    }
    private String formatDecimalValues(Decimal value) {
        return formatDecimalValues(value, 2);
    }
    */
    /*
    private Boolean isYtdMacquariePdfReadyToGenerate() {
        ytdMacDayssBeteenDates();
        Boolean r = true;
        if (ytdMacYtdStartDate == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill the Employment start or YTD start date field before generating the Pdf.'));
            r = false;
        }
        if (ytdMacPayPeriodDays > 0.0 && ytdMacNetYtdSalary > 0.0 && ytdMacPayPeriodNetSalary > 0.0 && ytdMacMonthlyNetYtdSalary > 0.0 && ytdMacAnnuallyNetYtdSalary > 0.0 && ytdMacMonthlyPayPeriodNetSalary > 0.0 && ytdMacAnnuallyPayPeriodNetSalary > 0.0) {} else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill all fields before generating the Pdf.'));
            r = false;
        }
        if (opp.Application__r.No_of_People__c == 2) {
            ytdMacDayssBeteenDatesA2();
            if (ytdMacYtdStartDateA2 == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill the Employment start or YTD start date field before generating the Pdf.'));
                r = false;
            }
            if (ytdMacPayPeriodDaysA2 > 0.0 && ytdMacNetYtdSalaryA2 > 0.0 && ytdMacPayPeriodNetSalaryA2 > 0.0 && ytdMacMonthlyNetYtdSalaryA2 > 0.0 && ytdMacAnnuallyNetYtdSalaryA2 > 0.0 && ytdMacMonthlyPayPeriodNetSalaryA2 > 0.0 && ytdMacAnnuallyPayPeriodNetSalaryA2 > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill all fields before generating the Pdf.'));
                r = false;
            }
        }
        return r;
    }
    */
    /*
    private Boolean isYtdOthersPdfReadyToGenerate() {
        ytdCalculate();
        Boolean r = true;
        if (ytdIncomeOth > 0.0 && ytdWeeksOth > 0.0) {} else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill all fields before generating the Pdf.'));
            r = false;
        }
        //Applicant 2
        if (opp.Application__r.No_of_People__c == 2) {
            ytdCalculateA2();
            if (ytdIncomeOthA2 > 0.0 && ytdWeeksOthA2 > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill all fields before generating the Pdf.'));
                r = false;
            }
        }
        return r;
    }
    */
    /*
    private Boolean isYtdFullDocPdfReadyToGenerate() {
        //ytdFullCalculation();
        Boolean r = true;
        // Check for 2 trustees
        if ('Trust'.equals(this.fldSelfEmployedType)) {
            if (fdNetProfit == null || fdNetProfit == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill Trust disbursement field for 1st trustee.'));
                r = false;
            }
            if (getFullDocumentationTotal() == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Total must be greater than 0 for 1st trustee.'));
                r = false;
            }
            if ('2'.equals(this.trusteesNumber)) {
                if (fdNetProfit2 == null || fdNetProfit2 == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill Trust disbursement field for 2nd trustee.'));
                    r = false;
                }
                if (getFullDocumentationTotal2() == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Total must be greater than 0 for 2nd trustee.'));
                    r = false;
                }
            }
        } else {
            if (fdNetProfit == null || fdNetProfit == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill Net Profit field before generating the Pdf.'));
                r = false;
            }
            if (getFullDocumentationTotal() == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Total must be greater than 0.'));
                r = false;
            }
        }
        return r;
    }
    
    private Boolean isYtdFullDocPdfReadyToGenerate2() {
        //ytdFullCalculation();
        Boolean r = true;
        // Check for 2 trustees
        if ('Trust'.equals(this.fldSelfEmployedType2)) {
            if (fdNetProfit_2 == null || fdNetProfit_2 == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill Trust disbursement field for 1st trustee.'));
                r = false;
            }
            if (getFullDocumentationTotal_2() == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Total must be greater than 0 for 1st trustee.'));
                r = false;
            }
            if ('2'.equals(this.trusteesNumber2)) {
                if (fdNetProfit2_2 == null || fdNetProfit2_2 == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill Trust disbursement field for 2nd trustee.'));
                    r = false;
                }
                if (getFullDocumentationTotal2_2() == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Total must be greater than 0 for 2nd trustee.'));
                    r = false;
                }
            }
        } else {
            if (fdNetProfit_2 == null || fdNetProfit_2 == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill Net Profit field before generating the Pdf.'));
                r = false;
            }
            if (getFullDocumentationTotal_2() == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Total must be greater than 0.'));
                r = false;
            }
        }
        return r;
    }
    */
    /*    
    public Decimal getFullDocumentationTotal() {
        return calculateFullDocumentationTotal(false);
    }
    */
    /*
    public Decimal getFullDocumentationTotal2() {
        return calculateFullDocumentationTotal2(false);
    }
    */
    /*
    private Decimal calculateFullDocumentationTotal(Boolean includeTax) {
        return calculateFullDocumentationTotal(includeTax, fdNetProfit, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary);
    }
    */
    /*
    public Decimal getFullDocumentationMonthlyTotal() {
        return getFullDocMonthlyTotal(calculateFullDocumentationTotal(true));
    }
    */
    // 2nd Trustee 
    /*
    private Decimal calculateFullDocumentationTotal2(Boolean includeTax) {
        return calculateFullDocumentationTotal2(includeTax, fdNetProfit2, fldSelfEmployedType);
    }
    *
    public Decimal getFullDocumentationMonthlyTotal2() {
        return getFullDocMonthlyTotal(calculateFullDocumentationTotal2(true));
    }
    
    public Decimal getFullDocumentationTotal_2() {
        return calculateFullDocumentationTotal_2(false);
    }
    public Decimal getFullDocumentationTotal2_2() {
        return calculateFullDocumentationTotal2_2(false);
    }
    private Decimal calculateFullDocumentationTotal_2(Boolean includeTax) {
        return calculateFullDocumentationTotal(includeTax, fdNetProfit_2, fldSelfEmployedType2, fdDepreciation2, fdInterest2, fdDirectorSalary2);
    }
    
    private Decimal calculateFullDocumentationTotal(Boolean includeTax, Decimal netProfit, String selfEmpType, Decimal depr, Decimal interest, Decimal dirSalary) {
        Decimal r = 0;
        if (netProfit != null) {
            r += netProfit;
            if (includeTax && 
               'Company Pty Ltd'.equals(selfEmpType)) {
                r -= netProfit * 0.3;
            }
        }
        if (!'Trust'.equals(selfEmpType)) {
            if (depr != null) r += depr;
            if (interest != null) r += interest;
            if (dirSalary != null) r += dirSalary;
        }
        return r;
    }
    
    public Decimal getFullDocumentationMonthlyTotal_2() {
        return getFullDocMonthlyTotal_2(calculateFullDocumentationTotal_2(true));
    }
    // 2nd Trustee 
    private Decimal calculateFullDocumentationTotal2_2(Boolean includeTax) {
        return calculateFullDocumentationTotal2(includeTax, fdNetProfit2_2, fldSelfEmployedType2);
    }
    
    private Decimal calculateFullDocumentationTotal2(Boolean includeTax, Decimal netProfit, String selfEmpType) {
        Decimal r = 0;
        if (netProfit != null) {
            r += netProfit;
            if (includeTax && 
               'Company Pty Ltd'.equals(selfEmpType)) {
                r -= netProfit * 0.3;
            }
        }
        // if (fdDepreciation2 != null) r += fdDepreciation2;
        // if (fdInterest2 != null) r += fdInterest2;
        // if (fdDirectorSalary2 != null) r += fdDirectorSalary2;
        return r;
    }
    
    public Decimal getFullDocumentationMonthlyTotal2_2() {
        return getFullDocMonthlyTotal_2(calculateFullDocumentationTotal2_2(true));
    }
    /*
    private Decimal getFullDocMonthlyTotal(Decimal annualIncomeTmp) {
        return getFullDocMonthlyTotal(annualIncomeTmp, fldSelfEmployedType);
    }
    */
    /*
    private Decimal getFullDocMonthlyTotal_2(Decimal annualIncomeTmp) {
        return getFullDocMonthlyTotal(annualIncomeTmp, fldSelfEmployedType2);
    }
    */
    /*
    private Decimal getFullDocMonthlyTotal(Decimal annualIncomeTmp, String selfEmployedType) {
        Decimal r = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(selfEmployedType) || 'Trust'.equals(selfEmployedType)) {
            r = annualIncomeTmp / 12;
        } else {
            r = (annualIncomeTmp - tx - md) / 12;
        }
        return r;
    }
    */
    /*
    private Boolean isYtdLowDocPdfReadyToGenerate() {
        //ytdFullCalculation();
        if (baseIncomeLowDoc > 0.0) {
            return true;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill all fields before generating the Pdf.'));
        return false;
    }
    */
    /*
    private void ytdEsandaFullCalculation() {
        //Applicant 1
        ytdCalcWeeksBeteenDates();
        //Applicant 2
        ytdCalcWeeksBeteenDatesA2();
    }
    */
    //Macquarie
    /*
    public PageReference ytdMacDayssBeteenDates() {
        if (ytdMacStartDate != null && ytdMacEndDate != null) {
            if (ytdMacEndDate < ytdMacStartDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Pay period end date is before pay period start date.'));
                ytdMacPayPeriodDays = 0.0;
            } else {
                ytdMacPayPeriodDays = ytdMacStartDate.daysBetween(ytdMacEndDate) + 1;
                if (ytdMacPayPeriodDays > 365) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 1 - Pay period exceeds 365 days'));
                }
                ytdOtherDatesValitations();
            }
        }
        ytdMacNetYTDSalary();
        ytdMacCalcPayPeriodSalary();
        return null;
    }
    */
    /*
    public PageReference ytdMacDayssBeteenDatesA2() {
        if (ytdMacStartDateA2 != null && ytdMacEndDateA2 != null) {
            if (ytdMacEndDateA2 < ytdMacStartDateA2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Pay period end date is before pay period start date.'));
                ytdMacPayPeriodDaysA2 = 0.0;
            } else {
                ytdMacPayPeriodDaysA2 = ytdMacStartDateA2.daysBetween(ytdMacEndDateA2) + 1;
                if (ytdMacPayPeriodDaysA2 > 365) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 2 - Pay period exceeds 365 days'));
                }
                ytdOtherDatesValitationsA2();
            }
        }
        ytdMacNetYTDSalaryA2();
        ytdMacCalcPayPeriodSalaryA2();
        return null;
    }
    */
    /*
    public PageReference ytdCalculateA2() {
        ytdWeeksOthA2 = 0;
        ytdMonIncomeOthA2 = 0;
        annualIncomeOthA2 = 0;
        if (startDateOthA2 == null || endDateOthA2 == null) {
            return null;
        }
        if (endDateOthA2 < startDateOthA2) {
            ytdCalc = true;
            servicingCalc = false;
            quotingTool = false;
            assetDetails = false;
            notesSection = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please choose an End Date that is later than the Start Date.'));
            return null;
        }
        ytdWeeksOthA2 = startDateOthA2.daysBetween(endDateOthA2);
        ytdWeeksOthA2 = ytdWeeksOthA2 / 7;
        if (ytdIncomeOthA2 != null) {
            if (ytdWeeksOthA2 > 0) {
                annualIncomeOthA2 = ytdIncomeOthA2 / ytdWeeksOthA2 * 52;
            } else {
                annualIncomeOthA2 = ytdIncomeOthA2 / 1 * 52;
            }
            Decimal tx = taxCalculate(annualIncomeOthA2);
            Decimal md = annualIncomeOthA2 * 0.02;
            ytdMonIncomeOthA2 = (annualIncomeOthA2 - tx - md) / 12;
        }
        servicingCalc = false;
        quotingTool = false;
        ytdCalc = true;
        assetDetails = false;
        notesSection = false;
        return null;
    }
    */
    /*
    public PageReference ytdCalcWeeksBeteenDates() {
        if (startDate != null && endDate != null) {
            if (endDate < startDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose an End Date that is later than the Start Date.'));
                ytdWeeks = 0.0;
            } else {
                ytdWeeks = startDate.daysBetween(endDate);
                ytdWeeks = ytdWeeks / 7;
            }
        }
        ytdCalcYtdNetMonthly();
        ytdCalcBaseIncome();
        return null;
    }
    */
    /*
    public PageReference ytdCalcWeeksBeteenDatesA2() {
        if (startDateA2 != null && endDateA2 != null) {
            if (endDateA2 < startDateA2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose an End Date that is later than the Start Date.'));
                ytdWeeksA2 = 0.0;
            } else {
                ytdWeeksA2 = startDateA2.daysBetween(endDateA2);
                ytdWeeksA2 = ytdWeeksA2 / 7;
            }
        }
        ytdCalcYtdNetMonthlyA2();
        ytdCalcBaseIncomeA2();
        return null;
    }
    */
    /*
    private void ytdOtherDatesValitations() {
        if (ytdMacStartDate != null && ytdMacEndDate != null) {
            Date tmpDate1 = Date.newInstance(ytdMacEndDate.year(), 7, 1);
            Date tmpDate2 = Date.newInstance(ytdMacEndDate.year(), 7, 31);
            if (ytdMacEndDate >= tmpDate1 && ytdMacEndDate < tmpDate2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 1 - Additional pay slip information may be required'));
            }
            tmpDate2 = Date.newInstance(ytdMacStartDate.year(), 7, 1);
            if ((ytdMacEndDate >= tmpDate1 && ytdMacStartDate < tmpDate1) || (ytdMacEndDate >= tmpDate2 && ytdMacStartDate < tmpDate2)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 1 - Pay period spans across multiple financial years. Net YTD Salary calculation is from' + ytdCalcYearToDateYtdPEriod(ytdMacEndDate).format() + ' to ' + ytdMacEndDate.format()));
            }
        }
    }
    private void ytdOtherDatesValitationsA2() {
        if (ytdMacStartDateA2 != null && ytdMacEndDateA2 != null) {
            Date tmpDate1 = Date.newInstance(ytdMacEndDateA2.year(), 7, 1);
            Date tmpDate2 = Date.newInstance(ytdMacEndDateA2.year(), 7, 31);
            if (ytdMacEndDateA2 >= tmpDate1 && ytdMacEndDateA2 < tmpDate2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 2 - Additional pay slip information may be required'));
            }
            tmpDate2 = Date.newInstance(ytdMacStartDateA2.year(), 7, 1);
            if ((ytdMacEndDateA2 >= tmpDate1 && ytdMacStartDateA2 < tmpDate1) || (ytdMacEndDateA2 >= tmpDate2 && ytdMacStartDateA2 < tmpDate2)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant 2 - Pay period spans across multiple financial years. Net YTD Salary calculation is from' + ytdCalcYearToDateYtdPEriod(ytdMacEndDateA2).format() + ' to ' + ytdMacEndDateA2.format()));
            }
        }
    }
    */
    /*
    public PageReference ytdMacNetYTDSalary() {
        ytdMacAnnuallyNetYtdSalary = 0.0;
        ytdMacMonthlyNetYtdSalary = 0.0;
        if (ytdMacYtdStartDate != null && ytdMacEndDate != null) {
            //Date netYtdStartDate = ytdCalcYearToDateYtdPEriod(ytdMacEndDate);
            Date netYtdStartDate = ytdMacYtdStartDate;
            Decimal days = netYtdStartDate.daysBetween(ytdMacEndDate) + 1;
            if (days > 0 && netYtdStartDate != null) {
                Date tmpDate = Date.newInstance(netYtdStartDate.year() + 1, netYtdStartDate.month(), 1);
                System.debug(ytdMacNetYtdSalary);
                ytdMacAnnuallyNetYtdSalary = (ytdMacNetYtdSalary / days) * netYtdStartDate.daysBetween(tmpDate);
                ytdMacMonthlyNetYtdSalary = ytdMacAnnuallyNetYtdSalary / 12;
            }
        }
        return null;
    }
    */
    /*
    public PageReference ytdMacNetYTDSalaryA2() {
        ytdMacAnnuallyNetYtdSalaryA2 = 0.0;
        ytdMacMonthlyNetYtdSalaryA2 = 0.0;
        if (ytdMacYtdStartDateA2 != null && ytdMacEndDateA2 != null) {
            //Date netYtdStartDate = ytdCalcYearToDateYtdPEriodA2(ytdMacEndDateA2);
            Date netYtdStartDate = ytdMacYtdStartDateA2;
            Decimal days = netYtdStartDate.daysBetween(ytdMacEndDateA2) + 1;
            if (days > 0 && netYtdStartDate != null) {
                Date tmpDate = Date.newInstance(netYtdStartDate.year() + 1, netYtdStartDate.month(), 1);
                ytdMacAnnuallyNetYtdSalaryA2 = (ytdMacNetYtdSalaryA2 / days) * netYtdStartDate.daysBetween(tmpDate);
                ytdMacMonthlyNetYtdSalaryA2 = ytdMacAnnuallyNetYtdSalaryA2 / 12;
            }
        }
        return null;
    }
    */
    /*
    public PageReference ytdMacCalcPayPeriodSalary() {
        ytdMacAnnuallyPayPeriodNetSalary = 0.0;
        ytdMacMonthlyPayPeriodNetSalary = 0.0;
        if (ytdMacPayPeriodDays > 0 && ytdMacStartDate != null) {
            Date tmpDate = Date.newInstance(ytdMacStartDate.year() + 1, ytdMacStartDate.month(), 1);
            ytdMacAnnuallyPayPeriodNetSalary = (ytdMacPayPeriodNetSalary / ytdMacPayPeriodDays) * ytdMacStartDate.daysBetween(tmpDate);
            ytdMacMonthlyPayPeriodNetSalary = ytdMacAnnuallyPayPeriodNetSalary / 12;
        }
        return null;
    }
    */
    /*
    public PageReference ytdMacCalcPayPeriodSalaryA2() {
        ytdMacAnnuallyPayPeriodNetSalaryA2 = 0.0;
        ytdMacMonthlyPayPeriodNetSalaryA2 = 0.0;
        if (ytdMacPayPeriodDaysA2 > 0 && ytdMacStartDateA2 != null) {
            Date tmpDate = Date.newInstance(ytdMacStartDateA2.year() + 1, ytdMacStartDateA2.month(), 1);
            ytdMacAnnuallyPayPeriodNetSalaryA2 = (ytdMacPayPeriodNetSalaryA2 / ytdMacPayPeriodDaysA2) * ytdMacStartDateA2.daysBetween(tmpDate);
            ytdMacMonthlyPayPeriodNetSalaryA2 = ytdMacAnnuallyPayPeriodNetSalaryA2 / 12;
        }
        return null;
    }
    */
    /*
    public PageReference ytdCalcYtdNetMonthly() {
        System.debug('ytdCalcYtdNetMonthly1:' + ytdIncome + '|' + ytdWeeks);
        if (ytdIncome != null && ytdWeeks != null && ytdWeeks > 0) {
            ytdMonIncome = (ytdIncome / ytdWeeks) * 4.33;
            if (netMonIncome != null) {
                monDifference = ytdMonIncome - netMonIncome;
            }
        } else {
            ytdMonIncome = null;
            monDifference = null;
        }
        System.debug('ytdCalcYtdNetMonthly2:' + ytdMonIncome + '|' + monDifference);
        return null;
    }
    */
    /*
    public PageReference ytdCalcYtdNetMonthlyA2() {
        if (ytdIncomeA2 != null && ytdWeeksA2 != null && ytdWeeksA2 > 0) {
            ytdMonIncomeA2 = (ytdIncomeA2 / ytdWeeksA2) * 4.33;
            if (netMonIncomeA2 != null) {
                monDifferenceA2 = ytdMonIncomeA2 - netMonIncomeA2;
            }
        } else {
            ytdMonIncomeA2 = null;
            monDifferenceA2 = null;
        }
        return null;
    }
    */
    /*
    public PageReference ytdCalcBaseIncome() {
        System.debug('ytdCalcBaseIncome1:' + baseIncome);
        netMonIncome = null;
        //monDifference = null;
        baseTax = null;
        baseMedi = null;
        discDiff = null;
        outAmount = null;
        if (baseIncome != null) {
            if (ytdCalcLender == 'Esanda') {
                baseMedi = baseIncome * 0.02;
                baseTax = taxCalculate(baseIncome);
                netMonIncome = (baseIncome - baseMedi - baseTax) / 12.0;
                if (ytdMonIncome != null) {
                    monDifference = ytdMonIncome - netMonIncome;
                    discDiff = monDifference * 0.7;
                    outAmount = netMonIncome + discDiff;
                }
            } else if (ytdCalcLender == 'Pepper') {
                Decimal tmpAannualIncome = 0;
                if (ytdWeeks > 0) {
                    tmpAannualIncome = baseIncome / ytdWeeks * 52;
                } else {
                    tmpAannualIncome = baseIncome / 1 * 52;
                }
                Decimal tx = taxCalculate(tmpAannualIncome);
                Decimal md = tmpAannualIncome * 0.02;
                netMonIncome = (tmpAannualIncome - tx - md) / 12;
                monDifference = 0.0;
                baseTax = 0.0;
                baseMedi = 0.0;
                discDiff = 0.0;
                outAmount = 0.0;
            }
        }
        System.debug('ytdCalcBaseIncome2:' + netMonIncome + '|' + ytdMonIncome + '|' + discDiff + '|' + outAmount);
        return null;
    }
    */
    /*
    public PageReference ytdCalcBaseIncomeA2() {
        netMonIncomeA2 = null;
        //monDifferenceA2 = null;
        discDiffA2 = null;
        outAmountA2 = null;
        if (baseIncomeA2 != null) {
            if (ytdCalcLender == 'Esanda') {
                Decimal md = baseIncomeA2 * 0.02;
                Decimal tx = taxCalculate(baseIncomeA2);
                netMonIncomeA2 = (baseIncomeA2 - md - tx) / 12.0;
                if (ytdMonIncomeA2 != null) {
                    monDifferenceA2 = ytdMonIncomeA2 - netMonIncomeA2;
                    discDiffA2 = monDifferenceA2 * 0.7;
                    outAmountA2 = netMonIncomeA2 + discDiffA2;
                }
            } else if (ytdCalcLender == 'Pepper') {
                Decimal tmpAannualIncome = 0;
                if (ytdWeeksA2 > 0) {
                    tmpAannualIncome = baseIncomeA2 / ytdWeeksA2 * 52;
                } else {
                    tmpAannualIncome = baseIncomeA2 / 1 * 52;
                }
                Decimal tx = taxCalculate(tmpAannualIncome);
                Decimal md = tmpAannualIncome * 0.02;
                netMonIncomeA2 = (tmpAannualIncome - tx - md) / 12;
                monDifferenceA2 = 0.0;
                discDiffA2 = 0.0;
                outAmountA2 = 0.0;
            }
        }
        return null;
    }
    */
    private Date ytdCalcYearToDateYtdPEriod(Date endDateParam) {
        Integer year = endDateParam.year();
        if (endDateParam.month() < 7) {
            year--;
        }
        /*
        if (ytdMacEndDate.month() < 7) {
            year--;
        }
        */
        return Date.newInstance(year, 7, 1);
    }
       
    public Decimal getPermanentMonthlyTotal() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency != null && sgtPaylipsAmount != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency) * sgtPaylipsAmount;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal1() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency1 != null && sgtPaylipsAmount1 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency1) * sgtPaylipsAmount1;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal2() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency2 != null && sgtPaylipsAmount2 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency2) * sgtPaylipsAmount2;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal3() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency3 != null && sgtPaylipsAmount3 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency3) * sgtPaylipsAmount3;
        }
        return r;
    }
    
    public Decimal getCasualTotalAverage() {
        Decimal r = 0;
        Integer i = 0;
        Decimal tmp = getCasualMonthlyTotal1();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        tmp = getCasualMonthlyTotal2();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        tmp = getCasualMonthlyTotal3();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        if (i > 0) {
            r = r / i;
        }
        return r;
    }
    
    public Decimal getPermanentMonthlyTotalA2() {
        Decimal r = 0;
        if (sgtPaylipsFrecuencyA2 != null && sgtPaylipsAmountA2 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuencyA2) * sgtPaylipsAmountA2;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal1A2() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency1A2 != null && sgtPaylipsAmount1A2 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency1A2) * sgtPaylipsAmount1A2;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal2A2() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency2A2 != null && sgtPaylipsAmount2A2 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency2A2) * sgtPaylipsAmount2A2;
        }
        return r;
    }
    
    public Decimal getCasualMonthlyTotal3A2() {
        Decimal r = 0;
        if (sgtPaylipsFrecuency3A2 != null && sgtPaylipsAmount3A2 != null) {
            r = OppApplicationServCalculatorUtils.getFrecuencyFactor(sgtPaylipsFrecuency3A2) * sgtPaylipsAmount3A2;
        }
        return r;
    }
    
    public Decimal getCasualTotalAverageA2() {
        Decimal r = 0;
        Integer i = 0;
        Decimal tmp = getCasualMonthlyTotal1A2();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        tmp = getCasualMonthlyTotal2A2();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        tmp = getCasualMonthlyTotal3A2();
        if (tmp > 0) {
            i++;
            r += tmp;
        }
        if (i > 0) {
            r = r / i;
        }
        return r;
    }
    
    private void loadYTDValues() {
        this.employmentMap = new Map<String, Application_Employment__c>();
        List<Application_Employment__c> d2 = [Select Applicant__c From Application_Employment__c 
                                              Where Application__c = :Opp.Application__r.Id and Type__c = 'Second Job'];
        
        for (Application_Employment__c a : d2) {
            if(a.Applicant__c != null){
                if(a.Applicant__c.equals('1')){
                    this.employmentMap.put(APPTYPE_1_2NDJOB, a);
                }else{
                    this.employmentMap.put(APPTYPE_2_2NDJOB, a);
                }   
            }
        }
        
        // Validate records according with App Form
        // Select to check if there are second jobs
        this.dataMap = new Map<String, YTD_Income__c>();
        // Load details
        List<YTD_Income__c> d = [Select Id, Annualised_Income__c, Applicant_Type__c, End_Date__c, Gross_Annual_Income__c,
                                 Gross_YTD_Income__c, Lender__c, Net_Monthly_Income__c, Opportunity__c, Start_Date__c,
                                 Type__c, Weeks__c, Gross_Net_Income__c, Last_Income_Frequency__c, Net_Annual_Income__c,
                                 Net_Income__c, Net_Last_Income__c, Net_Last_Monthly_Income__c, Comment__c, Employment_Start_Date__c,
                                 Net_YTD_Salary_Annually__c, Net_YTD_Salary_Monthly__c, Pay_Period_Annually__c,	Pay_Period_Monthly__c,
                                 Depreciation__c, Director_Salary__c, Interest__c, Net_Profit__c, Net_Profit_2__c, Sales__c,
                                 Self_Employed_Class__c, Self_Employed_Type__c, Trustees_Number__c, Net_Profit_Calc__c, Net_Profit_Calc_2__c,
                                 Net_Monthly_Income_2__c, Difference__c, Discounted__c, Monthly_Amount__c
                                 From YTD_Income__c Where Opportunity__c = :Opp.Id];
        
        for (YTD_Income__c a : d) {
            this.dataMap.put(a.Applicant_Type__c, a);
        }
        
        if (!d.isEmpty()) {
            ytdCalcLender = d.get(0).Type__c;
        }
        
        if (this.dataMap.containsKey(APPTYPE_1)) {
            YTD_Income__c o = this.dataMap.get(APPTYPE_1);
            ytdLenderApplic = o.Lender__c;
        }
        
        clearYTDEsandaOtherFields();
        if (d.isEmpty()) {                
            // old implementation
            if (this.Opp.ApplicationYTD__c != null) {
                Application_YTD__c ytd = this.Opp.ApplicationYTD__r;
                if (ytd == null) {
                    return;
                }
                ytdCalcLender = ytd.Type__c;
                if ('Esanda'.endsWithIgnoreCase(ytdCalcLender) || 'Pepper'.endsWithIgnoreCase(ytdCalcLender)) {
                    this.getApp1().Start_Date__c = ytd.Start_Date_1__c;
                    this.getApp1().End_Date__c = ytd.End_Date_1__c;
                    this.getApp1().Weeks__c = ytd.Weeks_1__c;
                    this.getApp1().Net_Annual_Income__c = ytd.Income_1_1__c;
                    this.getApp1().Gross_YTD_Income__c = ytd.Income_1_2__c;
                    this.getApp1().Difference__c = ytd.Difference_1__c;
                    this.getApp1().Discounted__c = ytd.Discounted_1__c;
                    this.getApp1().Monthly_Amount__c = ytd.Monthly_Amount_Servicing_1__c;
                    this.getApp1().Net_Income__c = ytd.Income_Monthly_1_1__c;
                    this.getApp1().Gross_Net_Income__c = ytd.Income_Monthly_1_2__c;
                    this.getApp1().Comment__c = ytd.Comment_1__c;
                    this.getApp1().Net_Last_Income__c = ytd.Latest_Payment_1__c;
                    this.getApp1().Last_Income_Frequency__c = ytd.Latest_Payment_Frequency_1__c;
                    this.ytdCalcNetLastestPay1();
                    if (opp.Application__r.No_of_People__c == 2) {
                        this.getApp2().Start_Date__c = ytd.Start_Date_2__c;
                        this.getApp2().End_Date__c = ytd.End_Date_2__c;
                        this.getApp2().Weeks__c = ytd.Weeks_2__c;
                        this.getApp2().Net_Annual_Income__c = ytd.Income_2_1__c;
                        this.getApp2().Gross_YTD_Income__c = ytd.Income_2_2__c;
                        this.getApp2().Difference__c = ytd.Difference_2__c;
                        this.getApp2().Discounted__c = ytd.Discounted_2__c;
                        this.getApp2().Monthly_Amount__c = ytd.Monthly_Amount_Servicing_2__c;
                        this.getApp2().Net_Income__c = ytd.Income_Monthly_2_1__c;
                        this.getApp2().Gross_Net_Income__c = ytd.Income_Monthly_2_2__c;
                        this.getApp2().Comment__c = ytd.Comment_2__c;
                        this.getApp2().Net_Last_Income__c = ytd.Latest_Payment_2__c;
                        this.getApp2().Last_Income_Frequency__c = ytd.Latest_Payment_Frequency_2__c;
                        this.ytdCalcNetLastestPay2();
                    }
                } else if ('Macquarie'.endsWithIgnoreCase(ytdCalcLender)) {
                    this.getApp1().Employment_Start_Date__c = ytd.Start_Date_A_1__c;
                    this.getApp1().Start_Date__c = ytd.Start_Date_1__c;
                    this.getApp1().End_Date__c = ytd.End_Date_1__c;
                    this.getApp1().Weeks__c = ytd.Weeks_1__c;
                    this.getApp1().Net_Annual_Income__c = ytd.Income_1_1__c;
                    this.getApp1().Net_Last_Income__c = ytd.Income_1_2__c;
                    this.getApp1().Net_YTD_Salary_Monthly__c = ytd.Income_Monthly_1_1__c;
                    this.getApp1().Net_YTD_Salary_Annually__c = ytd.Annually_1_1__c;
                    this.getApp1().Pay_Period_Monthly__c = ytd.Income_Monthly_1_2__c;
                    this.getApp1().Pay_Period_Annually__c = ytd.Annually_1_2__c;
                    this.getApp1().Comment__c = ytd.Comment_1__c;
                    if (opp.Application__r.No_of_People__c == 2) {
                        this.getApp2().Employment_Start_Date__c = ytd.Start_Date_A_2__c;
                        this.getApp2().Start_Date__c = ytd.Start_Date_2__c;
                        this.getApp2().End_Date__c = ytd.End_Date_2__c;
                        this.getApp2().Weeks__c = ytd.Weeks_2__c;
                        this.getApp2().Net_Annual_Income__c = ytd.Income_2_1__c;
                        this.getApp2().Net_Last_Income__c = ytd.Income_2_2__c;
                        this.getApp2().Net_YTD_Salary_Monthly__c = ytd.Income_Monthly_2_1__c;
                        this.getApp2().Net_YTD_Salary_Annually__c = ytd.Annually_2_1__c;
                        this.getApp2().Pay_Period_Monthly__c = ytd.Income_Monthly_2_2__c;
                        this.getApp2().Pay_Period_Annually__c = ytd.Annually_2_2__c;
                        this.getApp2().Comment__c = ytd.Comment_2__c;
                    }
                } else if ('Others'.endsWithIgnoreCase(ytdCalcLender)) {
                    this.getApp1().Start_Date__c = ytd.Start_Date_1__c;
                    this.getApp1().End_Date__c = ytd.End_Date_1__c;
                    this.getApp1().Weeks__c = ytd.Weeks_1__c;
                    this.getApp1().Gross_YTD_Income__c = ytd.Income_1_1__c;
                    this.getApp1().Annualised_Income__c = ytd.Income_1_2__c;
                    this.getApp1().Net_Monthly_Income__c = ytd.Income_Monthly_1_1__c;
                    if(ytd.GrossAnnualIncomeApplic1__c!=null){
                        this.getApp1().Gross_Annual_Income__c = ytd.GrossAnnualIncomeApplic1__c;
                        ytdLenderApplic = 'Firstmac';
                    }
                    if (opp.Application__r.No_of_People__c == 2) {
                        this.getApp2().Start_Date__c = ytd.Start_Date_2__c;
                        this.getApp2().End_Date__c = ytd.End_Date_2__c;
                        this.getApp2().Weeks__c = ytd.Weeks_2__c;
                        this.getApp2().Gross_YTD_Income__c = ytd.Income_2_1__c;
                        this.getApp2().Net_Monthly_Income__c = ytd.Income_Monthly_2_1__c;
                        this.getApp2().Annualised_Income__c = ytd.Income_2_2__c;
                        if(ytd.GrossAnnualIncomeApplic2__c!=null){
                            this.getApp2().Gross_Annual_Income__c = ytd.GrossAnnualIncomeApplic2__c;
                            ytdLenderApplic = 'Firstmac';
                        }
                    }
                } else if ('Self-Employed'.endsWithIgnoreCase(ytdCalcLender)) {
                    fdLender = ytd.Lender__c;
                    this.getApp1().Net_Profit__c = ytd.Income_Monthly_1_1__c;
                    this.getApp1().Sales__c = null;
                    if ('Company Pty Ltd'.equals(ytd.Self_Employed_Type__c) && ytd.Sales__c != null) {
                        this.getApp1().Sales__c = ytd.Sales__c;
                    }
                    this.getApp1().Depreciation__c = ytd.Income_Monthly_1_2__c;
                    this.getApp1().Interest__c = ytd.Annually_1_1__c;
                    this.getApp1().Director_Salary__c = ytd.Annually_1_2__c;
                    this.getApp1().Self_Employed_Class__c = ytd.Self_Employed_Class__c;
                    this.getApp1().Self_Employed_Type__c = ytd.Self_Employed_Type__c;
                    this.getApp1().Trustees_Number__c = null;
                    if ('Trust'.equals(this.getApp1().Self_Employed_Type__c)) {
                        if(String.isNotBlank(ytd.Trustess_Number__c)) {
                            this.getApp1().Trustees_Number__c = ytd.Trustess_Number__c;
                            if ('2'.equals(this.getApp1().Trustees_Number__c)) {
                                this.getApp1().Net_Profit_2__c = ytd.Net_Profit_2__c;
                                // fdDepreciation2 = ytd.Depreciation_2__c;
                                // fdInterest2 = ytd.Interest_2__c;
                                // fdDirectorSalary2 = ytd.Director_Salary_2__c;
                                getFullDocumentationTotal2App1();
                            }
                        }
                    }
                    getFullDocumentationTotalApp1();
                    if (opp.Application__r.No_of_People__c == 2) {
                        this.getApp2().Net_Profit__c = ytd.Income_Monthly_2_1__c;                     
                        this.getApp2().Sales__c = null;
                        if ('Company Pty Ltd'.equals(ytd.Self_Employed_Type_2__c) && ytd.Sales_2__c != null) {
                            this.getApp2().Sales__c = ytd.Sales_2__c;
                        }
                        this.getApp2().Depreciation__c = ytd.Income_Monthly_2_2__c;
                        this.getApp2().Interest__c = ytd.Annually_2_1__c;
                        this.getApp2().Director_Salary__c = ytd.Annually_2_2__c;
                        this.getApp2().Self_Employed_Class__c = ytd.Self_Employed_Class_2__c;
                        if(ytd.Self_Employed_Type_2__c != null ){
                            this.getApp2().Self_Employed_Type__c = ytd.Self_Employed_Type_2__c;    
                        }
                        this.getApp2().Trustees_Number__c = null;
                        if ('Trust'.equals(this.getApp2().Self_Employed_Type__c)) {
                            if(String.isNotBlank(ytd.Trustess_Number_2__c)) {
                                this.getApp2().Trustees_Number__c = ytd.Trustess_Number_2__c;
                                if ('2'.equals(this.getApp2().Trustees_Number__c)) {
                                    this.getApp2().Net_Profit_2__c = ytd.Net_Profit_2_2__c;
                                    // fdDepreciation2 = ytd.Depreciation_2__c;
                                    // fdInterest2 = ytd.Interest_2__c;
                                    // fdDirectorSalary2 = ytd.Director_Salary_2__c;
                                    getFullDocumentationTotal2App2();
                                }
                            }
                        }
                        getFullDocumentationTotalApp2();
                    }
                }
            }
            clearYTDEsandaOtherFields();
        }
    }   
    
    //   YTD Refactoring - OTHERS
    // Jesus Mora						2020-1-2
    // Variables
    public YTD_Income__c getApp1() {
        return getApplicantType(APPTYPE_1);
    }
    
    public YTD_Income__c getApp2() {
        return getApplicantType(APPTYPE_2);
    }
    
    public YTD_Income__c getApp12ndJob() {
        return getApplicantType(APPTYPE_1_2NDJOB);
    }
    
    public YTD_Income__c getApp22ndJob() {
        return getApplicantType(APPTYPE_2_2NDJOB);
    }
    
    private YTD_Income__c getApplicantType(String appType) {
        return this.dataMap.get(appType);
    }
 	
    // Calculate weeks
    public void calculateWeeksApp1() {
        this.calculateWeeks(this.getApp1());
    }
    
    public void calculateWeeksApp2() {
        this.calculateWeeks(this.getApp2());
    }
    
    public void calculateWeeksApp12ndJob() {
        this.calculateWeeks(this.getApp12ndJob());
    }
    
    public void calculateWeeksApp22ndJob() {
        this.calculateWeeks(this.getApp22ndJob());
    }
    
    public void calcWeeksBeteenDatesApp1() {
        this.calcWeeksBeteenDates(this.getApp1());
    }
    
    public void calcWeeksBeteenDatesApp2() {
        this.calcWeeksBeteenDates(this.getApp2());
    }
    
    public void calcWeeksBeteenDatesApp12ndJob() {
        this.calcWeeksBeteenDates(this.getApp12ndJob());
    }
    
    public void calcWeeksBeteenDatesApp22ndJob() {
        this.calcWeeksBeteenDates(this.getApp22ndJob());
    }
    
    public void macDayssBeteenDatesApp1() {
        this.macDayssBeteenDates(this.getApp1());
    }
    
    public void macDayssBeteenDatesApp2() {
        this.macDayssBeteenDates(this.getApp2());
    }
    
    public void macDayssBeteenDatesApp12ndJob() {
        this.macDayssBeteenDates(this.getApp12ndJob());
    }
    
    public void macDayssBeteenDatesApp22ndJob() {
        this.macDayssBeteenDates(this.getApp22ndJob());
    }
    
    public void macNetYTDSalaryApp1() {
        this.macNetYTDSalary(this.getApp1());
    }
    
    public void macNetYTDSalaryApp12ndJob() {
        this.macNetYTDSalary(this.getApp12ndJob());
    }
    
    public void macNetYTDSalaryApp2() {
        this.macNetYTDSalary(this.getApp2());
    }
    
    public void macNetYTDSalaryApp22ndJob() {
        this.macNetYTDSalary(this.getApp22ndJob());
    }
    
    public void macCalcPayPeriodSalaryApp1() {
        this.macCalcPayPeriodSalary(this.getApp1());
    }
    
    public void macCalcPayPeriodSalaryApp12ndJob() {
        this.macCalcPayPeriodSalary(this.getApp12ndJob());
    }
    
    public void macCalcPayPeriodSalaryApp2() {
        this.macCalcPayPeriodSalary(this.getApp2());
    }
    
    public void macCalcPayPeriodSalaryApp22ndJob() {
        this.macCalcPayPeriodSalary(this.getApp22ndJob());
    }
    
    public void getFullDocumentationTotalApp1() {
        if (!'Sole Trader'.equals(this.getApp1().Self_Employed_Type__c)){
            calculateFullDocumentationTotal(false, this.getApp1());
        }
        getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp1()), this.getApp1());
    }
    
    //public void fullDocumentationTotalApp1() {
        //calculateFullDocumentationTotaln(false, this.getApp1());
    //}
    
    public void getFullDocumentationMonthlyTotalApp1() {
        getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp1()), this.getApp1());
    }
    
    public void getFullDocumentationTotal2App1() {
        calculateFullDocumentationTotal2(false, this.getApp1());
        getFullDocMonthlyTotal2(calculateFullDocumentationTotal2_2(true, this.getApp1()), this.getApp1());
    }
    
    //public Decimal getFullDocumentationMonthlyTotal2App1() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal2(true, this.getApp1()), this.getApp1());
    //}
    
    public void getFullDocumentationTotalApp2() {
        if (!'Sole Trader'.equals(this.getApp2().Self_Employed_Type__c)){
            calculateFullDocumentationTotal(false, this.getApp2());
        }
        getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp2()), this.getApp2());
    }
    
    public void getFullDocumentationTotal2App2() {
        calculateFullDocumentationTotal2(false, this.getApp2());
        getFullDocMonthlyTotal2(calculateFullDocumentationTotal2_2(true, this.getApp2()), this.getApp2());
    }
    
    public void getFullDocumentationTotalApp12ndJob() {
        if (!'Sole Trader'.equals(this.getApp12ndJob().Self_Employed_Type__c)){
            calculateFullDocumentationTotal(false, this.getApp12ndJob());
        }
        getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp12ndJob()), this.getApp12ndJob());
    }
    
    public void getFullDocumentationTotal2App12ndJob() {
        calculateFullDocumentationTotal2(false, this.getApp12ndJob());
        getFullDocMonthlyTotal2(calculateFullDocumentationTotal2_2(true, this.getApp12ndJob()), this.getApp12ndJob());
    }
    
    public void getFullDocumentationTotalApp22ndJob() {
        if (!'Sole Trader'.equals(this.getApp22ndJob().Self_Employed_Type__c)){
            calculateFullDocumentationTotal(false, this.getApp22ndJob());
        }
        getFullDocMonthlyTotal(calculateFullDocumentationTotal_2(true, this.getApp22ndJob()), this.getApp22ndJob());
    }
    
    public void getFullDocumentationTotal2App22ndJob() {
        calculateFullDocumentationTotal2(false, this.getApp22ndJob());
        getFullDocMonthlyTotal2(calculateFullDocumentationTotal2_2(true, this.getApp22ndJob()), this.getApp22ndJob());
    }
    
    //public Decimal getFullDocumentationMonthlyTotalApp2() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal(true, this.getApp2()), this.getApp2());
    //}
    
    //public Decimal getFullDocumentationTotal2App2() {
        //return calculateFullDocumentationTotal2(false, this.getApp2());
    //}
    
    //public Decimal getFullDocumentationMonthlyTotal2App2() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal2(true, this.getApp2()), this.getApp2());
    //}
    
    //public Decimal getFullDocumentationTotalApp12ndJob() {
        //return calculateFullDocumentationTotal(false, this.getApp12ndJob());
    //}
    
    //public Decimal getFullDocumentationMonthlyTotalApp12ndJob() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal(true, this.getApp12ndJob()), this.getApp12ndJob());
    //}
    
    //public Decimal getFullDocumentationTotal2App12ndJob() {
        //return calculateFullDocumentationTotal2(false, this.getApp12ndJob());
    //}
    
    //public Decimal getFullDocumentationMonthlyTotal2App12ndJob() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal2(true, this.getApp12ndJob()), this.getApp12ndJob());
    //}
    
    //public Decimal getFullDocumentationTotalApp22ndJob() {
        //return calculateFullDocumentationTotal(false, this.getApp22ndJob());
    //}
    
    //public Decimal getFullDocumentationMonthlyTotalApp22ndJob() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal(true, this.getApp22ndJob()), this.getApp22ndJob());
    //}
    
    //public Decimal getFullDocumentationTotal2App22ndJob() {
        //return calculateFullDocumentationTotal2(false, this.getApp22ndJob());
    //}
    
    //public Decimal getFullDocumentationMonthlyTotal2App22ndJob() {
        //return getFullDocMonthlyTotal(calculateFullDocumentationTotal2(true, this.getApp22ndJob()), this.getApp22ndJob());
    //}
    
    private void calculateWeeks(YTD_Income__c a) {
        
        //initYTDEsandaOtherFieldsCalculated();
        a.Weeks__c = 0;
        a.Net_Monthly_Income__c = 0;
        a.Annualised_Income__c = 0;
        if (a.Start_Date__c == null || a.End_Date__c == null) {
            return;
        }
        //startDate = Date.parse(startDateYTD);
        //endDate = Date.parse(endDateYTD);
        if (a.End_Date__c < a.Start_Date__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, a.Applicant_Type__c+' - Please choose an End Date that is later than the Start Date.'));
            return;
        }
        a.Weeks__c = a.Start_Date__c.daysBetween(a.End_Date__c);
        a.Weeks__c = a.Weeks__c / 7;
        if (a.Gross_YTD_Income__c != null) {
            if (a.Weeks__c > 0) {
                a.Annualised_Income__c = a.Gross_YTD_Income__c / a.Weeks__c * 52;
            } else {
                a.Annualised_Income__c = a.Gross_YTD_Income__c / 1 * 52;
            }
            Decimal tx = taxCalculate(a.Annualised_Income__c);
            Decimal md = a.Annualised_Income__c * 0.02;
            a.Net_Monthly_Income__c = (a.Annualised_Income__c - tx - md) / 12;
        }
    }
    
    private Boolean isOthersValidated() {
        Boolean r = true;
        Set <String> a = new Set<String>();
        a = dataMap.keySet();
        
        for(String t: a){
            YTD_Income__c o = this.dataMap.get(t);
            calculateWeeks(o);
            if (o.Weeks__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please check out your dates, weeks value should be greater than 0.'));
                r = false;
            }
            if (o.Gross_YTD_Income__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Gross YTD Income From Payslip.'));
                r = false;
            }
            if(ytdLenderApplic.equals('Firstmac') && (o.Gross_Annual_Income__c == null || o.Gross_Annual_Income__c ==0)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, o.Applicant_Type__c+' - Gross Annual Income should not be blank or zero'));
            }
        }
        
        return r;
    }
    
    public Boolean getHasSecondJob1(){
        if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
            return true;
        }
        return false;
    }
    
    public Boolean getHasSecondJob2(){
        if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB) && opp.Application__r.No_of_People__c == 2) {
            return true;
        }
        return false;
    }
    
    private void calcWeeksBeteenDates(YTD_Income__c a) {
        if (a.Start_Date__c != null && a.End_Date__c != null) {
            if (a.End_Date__c < a.Start_Date__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose an End Date that is later than the Start Date.'));
                a.Weeks__c = 0.0;
            } else {
                a.Weeks__c = a.Start_Date__c.daysBetween(a.End_Date__c);
                a.Weeks__c = a.Weeks__c / 7;
            }
        }else{
          a.Weeks__c = 0.0;  
        }
        calcYtdNetMonthly(a);
        calcBaseIncome(a);
    }
    
    private void calcYtdNetMonthly(YTD_Income__c a) {
        System.debug('ytdCalcYtdNetMonthly1:' + ytdIncome + '|' + ytdWeeks);
        if (a.Net_Annual_Income__c != null && a.Weeks__c != null && a.Weeks__c > 0) {
            a.Net_Income__c = (a.Net_Annual_Income__c / a.Weeks__c) * 4.33;
            if (a.Gross_Net_Income__c != null) {
                a.Difference__c = a.Net_Income__c - a.Gross_Net_Income__c;
            }
        } else {
            a.Net_Income__c = null;
            a.Difference__c = null;
        }
        System.debug('ytdCalcYtdNetMonthly2:' + ytdMonIncome + '|' + monDifference);
    }
    
    private void calcBaseIncome(YTD_Income__c a) {
        System.debug('ytdCalcBaseIncome1:' + baseIncome);
        a.Gross_Net_Income__c = null;
        //monDifference = null;
        baseTax = null;
        baseMedi = null;
        a.Discounted__c = null;
        a.Monthly_Amount__c = null;
        if (a.Gross_YTD_Income__c != null) {
            if (ytdCalcLender == 'Esanda') {
                baseMedi = a.Gross_YTD_Income__c * 0.02;
                baseTax = taxCalculate(a.Gross_YTD_Income__c);
                a.Gross_Net_Income__c = (a.Gross_YTD_Income__c - baseMedi - baseTax) / 12.0;
                if (a.Net_Income__c != null) {
                    a.Difference__c = a.Net_Income__c - a.Gross_Net_Income__c;
                    a.Discounted__c = a.Difference__c * 0.7;
                    a.Monthly_Amount__c = a.Gross_Net_Income__c + a.Discounted__c;
                }
            } else if (ytdCalcLender == 'Pepper') {
                Decimal tmpAannualIncome = 0;
                if (a.Weeks__c > 0) {
                    tmpAannualIncome = a.Gross_YTD_Income__c / a.Weeks__c * 52;
                } else {
                    tmpAannualIncome = a.Gross_YTD_Income__c / 1 * 52;
                }
                Decimal tx = taxCalculate(tmpAannualIncome);
                Decimal md = tmpAannualIncome * 0.02;
                a.Gross_Net_Income__c = (tmpAannualIncome - tx - md) / 12;
                a.Difference__c = 0.0;
                baseTax = 0.0;
                baseMedi = 0.0;
                a.Discounted__c = 0.0;
                a.Monthly_Amount__c = 0.0;
            }
        }
        System.debug('ytdCalcBaseIncome2:' + netMonIncome + '|' + ytdMonIncome + '|' + discDiff + '|' + outAmount);
    }
    
    public void ytdCalcNetLastestPay1() {
        getApp1().recalculateFormulas();
    }
    
    public void ytdCalcNetLastestPay2() {
        getApp2().recalculateFormulas();
    }
    
    public void ytdCalcNetLastestPay12ndJob() {
        getApp12ndJob().recalculateFormulas();
    }
    
    public void ytdCalcNetLastestPay22ndJob() {
        getApp22ndJob().recalculateFormulas();
    }
    
    private Boolean isEsandaValidated() {
        esandaFullCalculation();
        System.debug('A1:' + ytdMonIncome + '|' + netMonIncome);
        Boolean r = true;
        Set <String> a = new Set<String>();
        a = dataMap.keySet();
        for(String t: a){
            YTD_Income__c o = this.dataMap.get(t);
            calcWeeksBeteenDates(o);
            if (o.Weeks__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please check out your dates, weeks value should be greater than 0.'));
                r = false;
            }
            if (o.Net_Annual_Income__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Net YTD Income From Payslips before generating the Pdf.'));
                r = false;
            }
            if ('Esanda'.endsWithIgnoreCase(ytdCalcLender)) {
                if (o.Gross_Net_Income__c > 0.0) {} else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Annual Gross Base Income before generating the Pdf.'));
                    r = false;
                }
            }
            if ('Pepper'.endsWithIgnoreCase(ytdCalcLender)) {
                if (o.Gross_Net_Income__c > 0.0) {} else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Gross YTD Income From Payslip before generating the Pdf.'));
                    r = false;
                }
                if (o.Net_Last_Monthly_Income__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Net last pay period income before generating the Pdf.'));
                    r = false;
                }
                if (o.Net_Last_Monthly_Income__c == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Net last pay period income should be greater than 0.'));
                    r = false;
                }
            }
        }
        return r;
    }
    
    private void esandaFullCalculation() {
        //Applicant 1
        calcWeeksBeteenDatesApp1();
        //Applicant 2
        if(Opp.Application__r.No_of_People__c == 2){
            calcWeeksBeteenDatesApp2();
        }
        if(getHasSecondJob1()){
            calcWeeksBeteenDatesApp12ndJob();
        }
        if(getHasSecondJob2()){
            calcWeeksBeteenDatesApp22ndJob();
        }
    }
    
    private void macDayssBeteenDates(YTD_Income__c a) {
        if (a.Start_Date__c != null && a.End_Date__c != null) {
            if (a.End_Date__c < a.Start_Date__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, a.Applicant_Type__c+' - Pay period end date is before pay period start date.'));
                a.Weeks__c = 0.0;
            } else {
                a.Weeks__c = a.Start_Date__c.daysBetween(a.End_Date__c) + 1;
                if (a.Weeks__c > 365) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, a.Applicant_Type__c+' - Pay period exceeds 365 days'));
                }
                otherDatesValitations(a);
            }
        }else{
         a.Weeks__c = 0.0;   
        }
        macNetYTDSalary(a);
        macCalcPayPeriodSalary(a);
    }
    
    private void macNetYTDSalary(YTD_Income__c a) {
        a.Net_YTD_Salary_Annually__c = 0.0;
        a.Net_YTD_Salary_Monthly__c = 0.0;
        if (a.Employment_Start_Date__c != null && a.End_Date__c != null) {
            //Date netYtdStartDate = ytdCalcYearToDateYtdPEriod(ytdMacEndDate);
            Date netYtdStartDate = a.Employment_Start_Date__c;
            Decimal days = netYtdStartDate.daysBetween(a.End_Date__c) + 1;
            if (days > 0 && netYtdStartDate != null) {
                Date tmpDate = Date.newInstance(netYtdStartDate.year() + 1, netYtdStartDate.month(), 1);
                if(a.Net_Annual_Income__c != null){
                    a.Net_YTD_Salary_Annually__c = (a.Net_Annual_Income__c / days) * netYtdStartDate.daysBetween(tmpDate);
                }
                a.Net_YTD_Salary_Monthly__c = a.Net_YTD_Salary_Annually__c / 12;
            }
        }
    }
    
    public void macCalcPayPeriodSalary(YTD_Income__c a) {
        a.Pay_Period_Annually__c = 0.0;
        a.Pay_Period_Monthly__c = 0.0;
        if (a.Weeks__c > 0 && a.Start_Date__c != null) {
            Date tmpDate = Date.newInstance(a.Start_Date__c.year() + 1, a.Start_Date__c.month(), 1);
            if(a.Net_Last_Income__c != null){
                a.Pay_Period_Annually__c = (a.Net_Last_Income__c / a.Weeks__c) * a.Start_Date__c.daysBetween(tmpDate);
            }
            a.Pay_Period_Monthly__c = a.Pay_Period_Annually__c / 12;
        }
    }
    
    private void otherDatesValitations(YTD_Income__c a) {
        if (a.Start_Date__c != null && a.End_Date__c != null) {
            Date tmpDate1 = Date.newInstance(a.End_Date__c.year(), 7, 1);
            Date tmpDate2 = Date.newInstance(a.End_Date__c.year(), 7, 31);
            if (a.End_Date__c >= tmpDate1 && a.End_Date__c < tmpDate2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, a.Applicant_Type__c+' - Additional pay slip information may be required'));
            }
            tmpDate2 = Date.newInstance(a.Start_Date__c.year(), 7, 1);
            if ((a.End_Date__c >= tmpDate1 && a.Start_Date__c < tmpDate1) || (a.End_Date__c >= tmpDate2 && a.Start_Date__c < tmpDate2)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, a.Applicant_Type__c+' - Pay period spans across multiple financial years. Net YTD Salary calculation is from' + ytdCalcYearToDateYtdPEriod(a.End_Date__c).format() + ' to ' + a.End_Date__c.format()));
            }
        }
    }
    
    private Boolean isMacquarieValidated() {
        //ytdMacDayssBeteenDates();
        macDayssBeteenDatesApp1();
        if(Opp.Application__r.No_of_People__c == 2){
            macDayssBeteenDatesApp2();
        }
        if(getHasSecondJob1()){
            macDayssBeteenDatesApp12ndJob();
        }
        if(getHasSecondJob2()){
            macDayssBeteenDatesApp22ndJob();
        }
        Boolean r = true;
        Set <String> a = new Set<String>();
        a = dataMap.keySet();
        for(String t: a){
            YTD_Income__c o = this.dataMap.get(t);
            macDayssBeteenDates(o);
			if (o.Weeks__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please check out your dates, pay period value should be greater than 0.'));
                r = false;
            }
            if (o.Employment_Start_Date__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill the Employment start or YTD start date field before generating the Pdf.'));
                r = false;
            }
            /*
            if (o.Weeks__c > 0.0 && o.Net_Annual_Income__c > 0.0 && o.Net_Last_Income__c > 0.0 && o.Net_YTD_Salary_Monthly__c > 0.0 && o.Net_YTD_Salary_Annually__c > 0.0 && o.Pay_Period_Monthly__c > 0.0 && o.Pay_Period_Annually__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill all fields before generating the Pdf.'));
                r = false;
            }
*/
            if (o.Net_Annual_Income__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Net Year-to-Date From Payslip should not be blank or zero.'));
                r = false;
            }
            if (o.Net_Last_Income__c > 0.0) {} else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Most Recent Payslip Net Income should not be blank or zero.'));
                r = false;
            }
        }
        return r;
    }
        
    private void calculateFullDocumentationTotal(Boolean includeTax, YTD_Income__c a) {
        //Decimal r = 0;
        a.Net_Profit_Calc__c = 0;
        if (a.Net_Profit__c != null) {
            a.Net_Profit_Calc__c += a.Net_Profit__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                a.Net_Profit_Calc__c -= a.Net_Profit__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) a.Net_Profit_Calc__c += a.Depreciation__c;
            if (a.Interest__c != null) a.Net_Profit_Calc__c += a.Interest__c;
            if (a.Director_Salary__c != null) a.Net_Profit_Calc__c += a.Director_Salary__c;
        }
        //return r;
    }
    /*
    private Decimal calculateFullDocumentationTotal(Boolean includeTax, YTD_Income__c a) {
        Decimal r = 0;
        if (a.Net_Profit__c != null) {
            r += a.Net_Profit__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                r -= a.Net_Profit__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) r += a.Depreciation__c;
            if (a.Interest__c != null) r += a.Interest__c;
            if (a.Director_Salary__c != null) r += a.Director_Salary__c;
        }
        return r;
    }
    */
    private void getFullDocMonthlyTotal(Decimal annualIncomeTmp, YTD_Income__c a) {
        //Decimal r = 0;
        a.Net_Monthly_Income__c = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
            a.Net_Monthly_Income__c = annualIncomeTmp / 12;
        } else {
            a.Net_Monthly_Income__c = (annualIncomeTmp - tx - md) / 12;
        }
        //return r;
    }
    /*
    private Decimal getFullDocMonthlyTotal(Decimal annualIncomeTmp, YTD_Income__c a) {
        Decimal r = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(a.Self_Employed_Type__c) || 'Trust'.equals(a.Self_Employed_Type__c)) {
            r = annualIncomeTmp / 12;
        } else {
            r = (annualIncomeTmp - tx - md) / 12;
        }
        return r;
    }
    */
    private void calculateFullDocumentationTotal2(Boolean includeTax, YTD_Income__c a) {
        //Decimal r = 0;
        a.Net_Profit_Calc_2__c = 0;
        if (a.Net_Profit_2__c != null) {
            a.Net_Profit_Calc_2__c += a.Net_Profit_2__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                a.Net_Profit_Calc_2__c -= a.Net_Profit_2__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) a.Net_Profit_Calc_2__c += a.Depreciation__c;
            if (a.Interest__c != null) a.Net_Profit_Calc_2__c += a.Interest__c;
            if (a.Director_Salary__c != null) a.Net_Profit_Calc_2__c += a.Director_Salary__c;
        }
        //return r;
    }
    /*
    private Decimal calculateFullDocumentationTotal2(Boolean includeTax, YTD_Income__c a) {
        Decimal r = 0;
        if (a.Net_Profit_2__c != null) {
            r += a.Net_Profit_2__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                r -= a.Net_Profit_2__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) r += a.Depreciation__c;
            if (a.Interest__c != null) r += a.Interest__c;
            if (a.Director_Salary__c != null) r += a.Director_Salary__c;
        }
        return r;
    }
    */
    private Boolean isSelfEmployedValidated() {
        //ytdFullCalculation();
        Boolean r = true;
        Set <String> a = new Set<String>();
        a = dataMap.keySet();
        // Check for 2 trustees
        for(String t: a){
            YTD_Income__c o = this.dataMap.get(t);
            if(o.Self_Employed_Class__c == null){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please select an option of Self-Employed Class.'));
                    r = false;  
            }
            if(o.Self_Employed_Type__c == null){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please select an option of Self-Employed Type.'));
                    r = false;  
            }
            if ('Trust'.equals(o.Self_Employed_Type__c)) {
                if (o.Net_Profit__c == null || o.Net_Profit__c == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Trust disbursement field for 1st trustee.'));
                    r = false;
                }
                //if(APPTYPE_1.equals(o.Applicant_Type__c)){
                    if (o.Net_Profit_Calc__c == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 1st trustee.'));
                        r = false;
                    }
                //}
                /*
                if(APPTYPE_2.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp2() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 1st trustee.'));
                        r = false;
                    }
                }
                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp12ndJob() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 1st trustee.'));
                        r = false;
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp22ndJob() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 1st trustee.'));
                        r = false;
                    }
                }
                */
                if ('2'.equals(o.Trustees_Number__c)) {
                    if (o.Net_Profit_2__c == null || o.Net_Profit_2__c == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Trust disbursement field for 2nd trustee.'));
                        r = false;
                    }
                    //if(APPTYPE_1.equals(o.Applicant_Type__c)){
                        if (o.Net_Profit_Calc_2__c == 0.0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 2nd trustee.'));
                            r = false;
                        }
                    //}
                    /*
                    if(APPTYPE_2.equals(o.Applicant_Type__c)){
                        if (getFullDocumentationTotal2App2() == 0.0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 2nd trustee.'));
                            r = false;
                        }
                    }
                    if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                        if (getFullDocumentationTotal2App12ndJob() == 0.0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 2nd trustee.'));
                            r = false;
                        }
                    }
                    if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                        if (getFullDocumentationTotal2App22ndJob() == 0.0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0 for 2nd trustee.'));
                            r = false;
                        }
                    }
                    */
                }
            } else {
                if (o.Net_Profit__c == null || o.Net_Profit__c == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Please fill Net Profit field before generating the Pdf.'));
                    r = false;
                }
                //if(APPTYPE_1.equals(o.Applicant_Type__c)){
                    //fullDocumentationTotalApp1();
                if ('Company Pty Ltd'.equals(o.Self_Employed_Type__c)){
                    if (o.Net_Profit_Calc__c == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0.'));
                        r = false;
                    }
                }
                
                if ('Sole Trader'.equals(o.Self_Employed_Type__c)){
                    if (o.Net_Monthly_Income__c == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0.'));
                        r = false;
                    }
                }
                //}
                /*
                if(APPTYPE_2.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp2() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0.'));
                        r = false;
                    }
                }

                if(APPTYPE_1_2NDJOB.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp12ndJob() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0.'));
                        r = false;
                    }
                }
                if(APPTYPE_2_2NDJOB.equals(o.Applicant_Type__c)){
                    if (getFullDocumentationTotalApp22ndJob() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, o.Applicant_Type__c+' - Total must be greater than 0.'));
                        r = false;
                    }
                }
                */
            }
        }
        return r;
    }
    /*
    public static void removeApplicant(Id oppId, String applicant){
        Boolean secondJob = false;
        if(applicant.equals(APPTYPE_1_2NDJOB) || applicant.equals(APPTYPE_2_2NDJOB)){
            List<Custom_Opportunity__c> d = [Select Application__r.Id From Custom_Opportunity__c Where Id = :oppId];
            String a;
            if(applicant.equals(APPTYPE_1_2NDJOB)){
                a = '1'; 
            }
            
            if(applicant.equals(APPTYPE_2_2NDJOB)){
                a = '2'; 
            }
            for (Custom_Opportunity__c o : d) {
                
                List<Application_Employment__c> d2 = [Select Applicant__c From Application_Employment__c 
                                                      Where Application__c = :o.Application__r.Id and Type__c = 'Second Job' and Applicant__c = :a];
                
                if(d2.isEmpty()){
                    secondJob = true;  
                }
                
            }
        }
        removeApplicant(oppId, applicant, secondJob);
    }
    
    public static void removeApplicant(Id oppId, String applicant, Boolean secondJob){
        if(secondJob){
            if(applicant.equals(APPTYPE_1_2NDJOB)){
                delete [Select Id From YTD_Income__c Where Opportunity__c = :oppId and Applicant_Type__c = :APPTYPE_1_2NDJOB];
            }
            
            if(applicant.equals(APPTYPE_2_2NDJOB)){
                delete [Select Id From YTD_Income__c Where Opportunity__c = :oppId and Applicant_Type__c = :APPTYPE_2_2NDJOB];
            }
            
        }else{
            
            List<Custom_Opportunity__c> d2 = [Select Application__r.Id, Application__r.No_of_People__c From Custom_Opportunity__c Where Id = :oppId];
            
            for (Custom_Opportunity__c o : d2) {
                if(o.Application__r.No_of_People__c == 1){ 
                    delete [Select Id From YTD_Income__c Where Opportunity__c = :oppId and Applicant_Type__c = :APPTYPE_2];
                    
                    List<Application__c> d5 = [select Net_Income_1__c, Payment_Frequency_1__c, Net_Income_2__c, Payment_Frequency_2__c  from Application__c where Id = :o.Application__r.Id];
                    
                    for (Application__c o2 : d5) {
                        o2.Net_Income_2__c = null;
                        o2.Payment_Frequency_2__c = null;
                        update o2;
                    }
                }
            }
            for (Custom_Opportunity__c o : d2) {
                
                List<Application_Employment__c> d3 = [Select Applicant__c From Application_Employment__c 
                                                      Where Application__c = :o.Application__r.Id and Type__c = 'Second Job' and Applicant__c = '2'];
                
                if(!d3.isEmpty()){
                    delete [Select Id From YTD_Income__c Where Opportunity__c = :oppId and Applicant_Type__c = :APPTYPE_2_2NDJOB];  
                }
            }  
        }
    }
    */
    
    public static void removeIncomes(Id oppId, Decimal numberOfPeople, Map<String, Boolean> data){
        
        List<String> applicantType = new List<String>();
        
        Boolean applicantSecondJob = data.get(APPTYPE_1_2NDJOB);
        
        if(applicantSecondJob == false){
            applicantType.add(APPTYPE_1_2NDJOB);
        }
        
        applicantSecondJob = data.get(APPTYPE_2_2NDJOB);
        
        if(applicantSecondJob == false){
            applicantType.add(APPTYPE_2_2NDJOB); 
        }
        
        if(numberOfPeople == 1){
            applicantType.add(APPTYPE_2);
            if(applicantSecondJob == true){
                applicantType.add(APPTYPE_2_2NDJOB); 
            }
        }
        if(!applicantType.isEmpty()){
            delete [Select Id From YTD_Income__c Where Opportunity__c = :oppId and Applicant_Type__c IN:applicantType];
        }
    }
    
    public void data(){
        this.dataMap.clear();
        // Load details
        List<YTD_Income__c> d = [Select Id, Annualised_Income__c, Applicant_Type__c, End_Date__c, Gross_Annual_Income__c,
                                 Gross_YTD_Income__c, Lender__c, Net_Monthly_Income__c, Opportunity__c, Start_Date__c,
                                 Type__c, Weeks__c, Gross_Net_Income__c, Last_Income_Frequency__c, Net_Annual_Income__c,
                                 Net_Income__c, Net_Last_Income__c, Net_Last_Monthly_Income__c, Comment__c, Employment_Start_Date__c,
                                 Net_YTD_Salary_Annually__c, Net_YTD_Salary_Monthly__c, Pay_Period_Annually__c,	Pay_Period_Monthly__c,
                                 Depreciation__c, Director_Salary__c, Interest__c, Net_Profit__c, Net_Profit_2__c, Sales__c,
                                 Self_Employed_Class__c, Self_Employed_Type__c, Trustees_Number__c, Net_Profit_Calc__c, Net_Profit_Calc_2__c,
                                 Net_Monthly_Income_2__c, Difference__c, Discounted__c, Monthly_Amount__c
                                 From YTD_Income__c Where Opportunity__c = :Opp.Id];
        
        for (YTD_Income__c a : d) {
            this.dataMap.put(a.Applicant_Type__c, a);   
        }
        
        YTD_Income__c a = null;
        Integer year = Date.today().year();
        
        if (Date.today().month() < 7) {
            year--;
        }
        
        if (!this.dataMap.containsKey(APPTYPE_1)) {
            a = new YTD_Income__c();
            a.Applicant_Type__c = APPTYPE_1;
            a.Start_Date__c = Date.newinstance(year, 7, 1);
            a.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
            a.End_Date__c = Date.today();
            
            this.dataMap.put(APPTYPE_1, a);
            
            if('Others'.equals(ytdCalcLender)){
                this.calculateWeeks(a);
            }
            if('Macquarie'.equals(ytdCalcLender)){
                macDayssBeteenDatesApp1();
            }
            if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                calcWeeksBeteenDatesApp1();
            }
        }
        // TODO: verify if there is a second job for app 1
        // TODO: verify same conditions for Applicant 2
        if(this.employmentMap.containsKey(APPTYPE_1_2NDJOB)){
            YTD_Income__c app1S = null;
            if (!this.dataMap.containsKey(APPTYPE_1_2NDJOB)) {
                app1S = new YTD_Income__c();
                app1S.Applicant_Type__c = APPTYPE_1_2NDJOB;
                app1S.Start_Date__c = Date.newinstance(year, 7, 1);
                app1S.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                app1S.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_1_2NDJOB, app1S);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(app1S);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp12ndJob();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp12ndJob();
                }
            }
        }
        
        if(opp.Application__r.No_of_People__c == 2){
            YTD_Income__c a2 = null;
            if (!this.dataMap.containsKey(APPTYPE_2)) {
                a2 = new YTD_Income__c();
                a2.Applicant_Type__c = APPTYPE_2;
                a2.Start_Date__c = Date.newinstance(year, 7, 1);
                a2.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                a2.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_2, a2);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(a2);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp2();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp2();
                }
            }
        }
        
        if(this.employmentMap.containsKey(APPTYPE_2_2NDJOB) && opp.Application__r.No_of_People__c == 2){
            YTD_Income__c a2S = null;
            if (!this.dataMap.containsKey(APPTYPE_2_2NDJOB)) {
                a2S = new YTD_Income__c();
                a2S.Applicant_Type__c = APPTYPE_2_2NDJOB;
                a2S.Start_Date__c = Date.newinstance(year, 7, 1);
                a2S.Employment_Start_Date__c = Date.newinstance(year, 7, 1);
                a2S.End_Date__c = Date.today();
                this.dataMap.put(APPTYPE_2_2NDJOB, a2S);
                if('Others'.equals(ytdCalcLender)){
                    this.calculateWeeks(a2S);
                }
                if('Macquarie'.equals(ytdCalcLender)){
                    macDayssBeteenDatesApp22ndJob();
                }
                if('Pepper'.equals(ytdCalcLender) || 'Esanda'.equals(ytdCalcLender)){
                    calcWeeksBeteenDatesApp22ndJob();
                }
            }
        }
    }
    
    private Decimal calculateFullDocumentationTotal_2(Boolean includeTax, YTD_Income__c a) {
        Decimal r = 0;
        if (a.Net_Profit__c != null) {
            r += a.Net_Profit__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                r -= a.Net_Profit__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) r += a.Depreciation__c;
            if (a.Interest__c != null) r += a.Interest__c;
            if (a.Director_Salary__c != null) r += a.Director_Salary__c;
        }
        return r;
    }
    
    private Decimal calculateFullDocumentationTotal2_2(Boolean includeTax, YTD_Income__c a) {
        Decimal r = 0;
        if (a.Net_Profit_2__c != null) {
            r += a.Net_Profit_2__c;
            if (includeTax && 
               'Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
                r -= a.Net_Profit_2__c * 0.3;
            }
        }
        if (!'Trust'.equals(a.Self_Employed_Type__c)) {
            if (a.Depreciation__c != null) r += a.Depreciation__c;
            if (a.Interest__c != null) r += a.Interest__c;
            if (a.Director_Salary__c != null) r += a.Director_Salary__c;
        }
        return r;
    }
    
    private void getFullDocMonthlyTotal2(Decimal annualIncomeTmp, YTD_Income__c a) {
        //Decimal r = 0;
        a.Net_Monthly_Income_2__c = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(a.Self_Employed_Type__c)) {
            a.Net_Monthly_Income_2__c = annualIncomeTmp / 12;
        } else {
            a.Net_Monthly_Income_2__c = (annualIncomeTmp - tx - md) / 12;
        }
        //return r;
    }

    public void fullDocumentationTotalApp1() {
        getFullDocumentationTotalApp1();
        if ('2'.equals(this.getApp1().Trustees_Number__c)){
            getFullDocumentationTotal2App1();   
        }
    }

    public void fullDocumentationTotalApp2() {
        getFullDocumentationTotalApp2();
        if ('2'.equals(this.getApp2().Trustees_Number__c)){
            getFullDocumentationTotal2App2();   
        }
    }

    public void fullDocumentationTotalApp12ndJob() {
        getFullDocumentationTotalApp12ndJob();
        if ('2'.equals(this.getApp12ndJob().Trustees_Number__c)){
            getFullDocumentationTotal2App12ndJob();   
        }
    }

    public void fullDocumentationTotalApp22ndJob() {
        getFullDocumentationTotalApp22ndJob();
        if ('2'.equals(this.getApp22ndJob().Trustees_Number__c)){
            getFullDocumentationTotal2App22ndJob();   
        }
    }
   // -

   public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}