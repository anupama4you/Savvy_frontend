public class YTDCalculatorDTO {
	public String ytdLender {get;set;}
    //Esanda
    public String startDate {get;set;}
    public String endDate {get;set;}
    public String ytdWeeks {get;set;}
    public String ytdIncome {get;set;}					//ytdMacNetYtdSalary
    public String baseIncome {get;set;}					//ytdMacPayPeriodNetSalary
    public String ytdMonIncome {get;set;}
    public String netMonIncome {get;set;}
    public String monDifference {get;set;}
    public String baseTax {get;set;}
    public String baseMedi {get;set;}
    public String  ytdComment1 {get;set;}

    //Application 2
    public String startDateA2 {get;set;}
    public String endDateA2 {get;set;}
    public String ytdWeeksA2 {get;set;}
    public String ytdIncomeA2 {get;set;}
    public String baseIncomeA2 {get;set;}
    public String ytdMonIncomeA2 {get;set;}
    public String netMonIncomeA2 {get;set;}
    public String monDifferenceA2 {get;set;}
    public String discDiffA2 {get;set;}
    public String outAmountA2 {get;set;}
    public String  ytdComment2 {get;set;}

    //Others
    public String annualIncome {get;set;}
    public String ytdTax {get;set;}
    public String ytdMedi {get;set;}
    public String discDiff {get;set;}
    public String outAmount {get;set;}
    //Applicant 2
    public String startDateOthA2 {get;set;}
    public String endDateOthA2 {get;set;}
    public String ytdWeeksOthA2 {get;set;}
    public String ytdIncomeOthA2 {get;set;}
    public String ytdMonIncomeOthA2 {get;set;}
    public String annualIncomeOthA2 {get;set;}
    //Macquarie
    public String startYtdDate {get;set;}
    public String ytdMacPayPeriodDays {get;set;}
    public String ytdMacMonthlyNetYtdSalary {get;set;}
    public String ytdMacAnnuallyNetYtdSalary {get;set;}
    public String ytdMacMonthlyPayPeriodNetSalary {get;set;}
    public String ytdMacAnnuallyPayPeriodNetSalary {get;set;}
    public String ytdMacComments {get;set;}
    //Applicant 2
    public String startYtdDateA2 {get;set;}
    public String ytdMacStartDateA2 {get;set;}
    public String ytdMacEndDateA2 {get;set;}
    public String ytdMacNetYtdSalaryA2 {get;set;}
    public String ytdMacPayPeriodNetSalaryA2 {get;set;}
    public String ytdMacPayPeriodDaysA2 {get;set;}
    public String ytdMacMonthlyNetYtdSalaryA2 {get;set;}
    public String ytdMacAnnuallyNetYtdSalaryA2 {get;set;}
    public String ytdMacMonthlyPayPeriodNetSalaryA2 {get;set;}
    public String ytdMacAnnuallyPayPeriodNetSalaryA2 {get;set;}
    public String ytdMacCommentsA2 {get;set;}
    //Document
    public String attachmentId {get;set;}
     //Full Documentation
    public String fdLender {set;get;}
    public Decimal fdNetProfit {get;set;}
    public Decimal fdNetProfitDiscount {get;set;}
    public Decimal fdDepreciation {get;set;}
    public Decimal fdInterest {get;set;}
    public Decimal fdDirectorSalary {get;set;}
    public Decimal fullDocumentationTotal {get;set;}
    public Decimal fullDocTotalMonthly {get;set;}

    //St George
    public String sgtPaylipsFrecuency {set;get;}
    public String sgtPaylipsFrecuency1 {set;get;}
    public String sgtPaylipsFrecuency2 {set;get;}
    public String sgtPaylipsFrecuency3 {set;get;}
    
    public Decimal sgtPaylipsAmount {set;get;}
    public Decimal sgtPaylipsAmount1 {set;get;}
    public Decimal sgtPaylipsAmount2 {set;get;}
    public Decimal sgtPaylipsAmount3 {set;get;}
    
    public Decimal permanentMonthlyTotal {set;get;}
    public Decimal casualMonthlyTotal1 {set;get;}
    public Decimal casualMonthlyTotal2 {set;get;}
    public Decimal casualMonthlyTotal3 {set;get;}
    public Decimal casualTotalAverage {set;get;}
    
    public String sgtPaylipsFrecuencyA2 {set;get;}
    public String sgtPaylipsFrecuency1A2 {set;get;}
    public String sgtPaylipsFrecuency2A2 {set;get;}
    public String sgtPaylipsFrecuency3A2 {set;get;}
    
    public Decimal sgtPaylipsAmountA2 {set;get;}
    public Decimal sgtPaylipsAmount1A2 {set;get;}
    public Decimal sgtPaylipsAmount2A2 {set;get;}
    public Decimal sgtPaylipsAmount3A2 {set;get;}
    
    public Decimal permanentMonthlyTotalA2 {set;get;}
    public Decimal casualMonthlyTotal1A2 {set;get;}
    public Decimal casualMonthlyTotal2A2 {set;get;}
    public Decimal casualMonthlyTotal3A2 {set;get;}
    public Decimal casualTotalAverageA2 {set;get;}
    
    public String selfEmployedClass {get;set;}
    public String selfEmployedType {get;set;}

    //Lelo          YTD - Pepper fields         2018-05-10
    public Decimal latestPay1 {get;set;}
    public Decimal latestPay2 {get;set;}
    public Decimal latestPayMonthly1 {get;set;}
    public Decimal latestPayMonthly2 {get;set;}
    public String latestPayFrequency1 {set;get;}
    public String latestPayFrequency2 {set;get;}
    public Decimal servMonthlyRepayment {get;set;}
    // Lelo             2019-08-05
    public String trusteesNumber {set;get;}
    public Decimal fdNetProfit2 {get;set;}
    // public Decimal fdDepreciation2 {get;set;}
    // public Decimal fdInterest2 {get;set;}
    // public Decimal fdDirectorSalary2 {get;set;}
    public Decimal fullDocumentationTotal2 {get;set;}
    public Decimal fullDocTotalMonthly2 {get;set;}
    public Decimal sales {get;set;}
    //-
	//Yohan VillaLeal                   2019-09-13
    public String YTDGrossLenderApplic1 {set; get;}
    public Decimal GrossAnnualIncomeApplic1 {set; get;}
    public String YTDGrossLenderApplic2 {set; get;}
    public Decimal GrossAnnualIncomeApplic2 {set; get;}
    //--
    public String selfEmployedClass2 {get;set;}
    public String selfEmployedType2 {get;set;}
    public Decimal sales2 {get;set;}
    public Decimal fdNetProfit_2 {get;set;}
    public Decimal fdDepreciation2 {get;set;}
    public Decimal fdInterest2 {get;set;}
    public Decimal fdDirectorSalary2 {get;set;}
    public String trusteesNumber2 {set;get;}
    public Decimal fdNetProfit2_2 {get;set;}
    public Decimal fullDocumentationTotal_2 {get;set;}
    public Decimal fullDocumentationTotal2_2 {get;set;}
    public Decimal fullDocTotalMonthly_2 {get;set;}
    public Decimal fullDocTotalMonthly2_2 {get;set;}
    public Decimal fdNetProfitDiscount2 {get;set;}
    
    public YTDCalculatorDTO(){
        
    }
    public Boolean getStGeorgeApplicant2() {
        Boolean r = false;
        if (casualTotalAverageA2 > 0 || permanentMonthlyTotalA2 > 0) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsMacquarieApplicant2() {
        Boolean r = false;
        if (!String.isBlank(ytdMacPayPeriodDaysA2) && !String.isBlank(ytdMacStartDateA2) && !String.isBlank(ytdMacEndDateA2)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsOthersApplicant2() {
        Boolean r = false;
        if (!String.isBlank(ytdWeeksOthA2) && !String.isBlank(ytdIncomeOthA2) && !String.isBlank(startDateOthA2) && !String.isBlank(endDateOthA2)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsEsandaApplicant2() {
        Boolean r = false;
        if (!String.isBlank(ytdWeeksA2) && !String.isBlank(ytdIncomeA2) && !String.isBlank(baseIncomeA2) && !String.isBlank(endDateA2)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsSelfEmployedApplicant2() {
        Boolean r = false;
        if (fdNetProfit_2 != null) {
            r = true;
        }
        return r;
    }
}