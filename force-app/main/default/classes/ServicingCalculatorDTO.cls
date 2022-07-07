public class ServicingCalculatorDTO {
	
    public String lender {get;set;}
    public String lenderName {get;set;}
    public String state {get;set;}
    public String area {get;set;}
    public String maritalStatus {get;set;}
    public Integer noDependents {get;set;}
    public String splittingExpenses {get;set;}
    public Decimal partnerIncome {get;set;}
 	
    public boolean splitRentMortgage {get;set;}
    public boolean splitLivingExpenses {get;set;}
    
    //Variables Calculated
    public Decimal totNetMonthlyIncome {get;set;}
    public Decimal totLiabilities {get;set;}
    public Decimal totRentMtgPaid {get;set;}
    public Decimal totOtherDebts {get;set;}
    public Decimal totLivingExpenses {get;set;}
    public Decimal totAmountLoanPayment {get;set;}
    public Decimal splitNetPartIncomeTotal {get;set;}
    public Decimal splitRentMortgageTotal {get;set;}
    public Decimal splitLivingExpensesTotal {get;set;}
    
    //Income
    //Applicant 1
    public String servCalcIncomePayFrecuency1 {get;set;}
    public Decimal servCalcIncomeAmount1 {get;set;}
    public String servCalcOtherIncomePayFrecuency1 {get;set;}
    public String servCalcOtherIncomeType1 {get;set;}
    public Decimal servCalcOtherIncomeAmount1 {get;set;}
    //Applicant 2
    public String servCalcIncomePayFrecuency2 {get;set;}
    public Decimal servCalcIncomeAmount2 {get;set;}
    public String servCalcOtherIncomePayFrecuency2 {get;set;}
    public String servCalcOtherIncomeType2 {get;set;}
    public Decimal servCalcOtherIncomeAmount2 {get;set;}
    
    //Expenses
    public String servCalcLoanType {get;set;}
    public String servCalcLoanType2 {get;set;}
    public String servCalcLoanType3 {get;set;}
    public String servCalcLoanType4 {get;set;}
    
    public String servCalcLoanPayFrecuency {get;set;}
    public String servCalcLoanPayFrecuency2 {get;set;}
    public String servCalcLoanPayFrecuency3 {get;set;}
    public String servCalcLoanPayFrecuency4 {get;set;}
    public Decimal servCalcLoanPayAmount {get;set;}
    public Decimal servCalcLoanPayAmount2 {get;set;}
    public Decimal servCalcLoanPayAmount3 {get;set;}
    public Decimal servCalcLoanPayAmount4 {get;set;}
    
    public String servCalcRentPayFrecuency {get;set;}
    public Decimal servCalcRentPayAmount {get;set;}
    
    public String servCalcCCardIssuer {get;set;}
    public Decimal servCalcCCardCreditLimit {get;set;}
    public Decimal servCalcCCardAmountOwing {get;set;}
    public Decimal servCalcCCardMonthlyPayment {get;set;}
    
    public Decimal servCalcCLinkNetNonCentIncome {get;set;}
    public Decimal servCalcCLinkIncome {get;set;}
    public Decimal servCalcCLinkTotalIncome {get;set;}
    public Decimal servCalcCLinkIncomePercentage {get;set;}
    public Decimal servCalcCLinkAnnualToLoannet {get;set;}
    
    public Decimal naf {get;set;}
    
    public ServicingCalculatorDTO() {
        init();
    }
    
    public void init() {
        totNetMonthlyIncome = 0.0;
        totLiabilities = 0.0;
        totRentMtgPaid = 0.0;
        totOtherDebts = 0.0;
        totLivingExpenses = 0.0;
        splitNetPartIncomeTotal = 0.0;
        splitRentMortgageTotal = 0.0;
		splitLivingExpensesTotal = 0.0;    
        totAmountLoanPayment = 0.0;
        splitRentMortgage = false;
        splitLivingExpenses = false;
    }
    
    public String getSingleJoint() {
        String r = this.maritalStatus;
        if (!'Single'.equalsIgnoreCase(r)) {
            r = 'Joint';
        }
        return r;
    }
    
    
    public Decimal getApplicantIncome1() {
        return servCalcIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency1);
    }
    
    public Decimal getApplicantIncome2() {
        return servCalcIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency2);
    }
    
    public Decimal getApplicantOtherIncome1() {
        return servCalcOtherIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcOtherIncomePayFrecuency1);
    }
    
    public Decimal getApplicantOtherIncome2() {
        return servCalcOtherIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcOtherIncomePayFrecuency2);
    }
    
    /*
    public Decimal getTotNetMonthlyIncome() {
        return 0;
    }
    
    public Decimal getTotLiabilities() {
        return 0;
    }
    
    public Decimal getTotOtherDebts() {
        return 0;
    }
    
    public Decimal getTotAmountLoanPayment() {
        Decimal r = 0;
        
        return r;
    }
	*/
}