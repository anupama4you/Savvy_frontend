public class AppServicingCalculatorDTO {
	
    public String empIncome1 {get;set;}
    public String empIncome2 {get;set;}
    public String otherIncome1 {get;set;}
    public String otherIncome2 {get;set;}
    public String monthIncome {get;set;}
    public String monthRent {get;set;}
    public String livingExpense {get;set;}
    //public String otherDebts {get;set;}
    public String subTotal {get;set;}
    public String requiredSurplus {get;set;}
    public String finalAmount {get;set;}
    
    // Lelo							2016-07-11
    public String lender {get;set;}
    public String state {get;set;}
    public String area {get;set;}
    public String typeStatus {get;set;}
    public String dependants {get;set;}
    public String splitting {get;set;}
    public String partnerIncome {get;set;}
    public String netPartnerIncome {get;set;}
    
    public String netMonthlyIncome {get;set;}
    public String totLiabilities {get;set;}
    public String rentMtgePaid {get;set;}
    public String livingExpenses {get;set;}
    public String rentMtgePaidFull {get;set;}
    public String livingExpensesFull {get;set;}
    public String otherDebts {get;set;}
    public String amountAvailablePayment {get;set;}
    
    public Boolean rentMtgePaidSplited {get;set;}
    public Boolean livingExpensesSplited {get;set;}
    
    public String applicantIncome1 {get;set;}
    public String applicantIncome2 {get;set;}
    public String applicantIncome1b {get;set;}
    public String applicantIncome2b {get;set;}
    public String applicantOtherIncome1 {get;set;}
    public String applicantOtherIncome2 {get;set;}
    
    //Expenses - Liabilities
    public String loanType1 {get;set;}
    public String loanFrecuency1 {get;set;}
    public String loanAmount1 {get;set;}
    
    public String loanType2 {get;set;}
    public String loanFrecuency2 {get;set;}
    public String loanAmount2 {get;set;}
    
    public String loanType3 {get;set;}
    public String loanFrecuency3 {get;set;}
    public String loanAmount3 {get;set;}
    
    public String loanType4 {get;set;}
    public String loanFrecuency4 {get;set;}
    public String loanAmount4 {get;set;}
    
    //Expenses - Rent / Mortgage
    public String rentFrecuency {get;set;}
    public String rentAmount {get;set;}
    
    //Expenses - Credit Cards
    public String creditCardIssuer {get;set;}
    public String creditLimit {get;set;}
    public String amountOwing {get;set;}
    public String monthlyPayment {get;set;}
    
    //Liberty Calculator
    public String netNonCentrelinkIncome {get;set;}
    public String centrelinkIncome {get;set;}
    public String totalAssesableIncome {get;set;}
    public String centrelinkIncomePercentage {get;set;}
    public String annualCLToLoannet {get;set;}
    
    public Boolean isLowDocSelfEmployed {get;set;}
    public String mortgageAmount {get;set;}

    public String boardAmount {get;set;}
    public String netProfitAfterTax {get;set;}
    public String netProfitBeforeTax {get;set;}

    public String naf {get;set;}
    public String bufferAmount {get;set;}
    public String rentFrequency {get;set;}
    public List<LoanDTO> loanList {get;set;}

    public String monthlyRepayment {get;set;}
    public String mortgageBuffer {get;set;}
	public String lenderCode {get;set;}
    
    public AppServicingCalculatorDTO() {
        isLowDocSelfEmployed = false;
    }

    public Decimal getTotalOthresIncome() {
        Decimal r = 0;
        r += NumberUtils.convertToDecimal(applicantOtherIncome1, false);
        r += NumberUtils.convertToDecimal(applicantOtherIncome2, false);
        return r;
    }
    
    public String getTotalOthresIncomeText() {
        return ('$ ' + String.valueOf(getTotalOthresIncome().format()));
    }
    
    public class LoanDTO {
        public String loanType {get;set;}
        public String amount {get;set;}
        public Boolean repaid {get;set;}
        public String frequency {get;set;}
    }
}