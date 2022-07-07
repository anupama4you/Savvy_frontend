public class SocietyOneDTO {
    // finance calculator input
    public Decimal carPrice { get; set; }
    public Decimal deposit { get; set; }
    public Decimal applicationFee { get; set; }
    public Decimal dof { get; set; }
    public Decimal maxDof {get;set;}
    public Decimal maxAppFee {get;set;}
    public Decimal ppsr { get; set; }
    public Decimal residualValue { get; set; }
    public Decimal clientRate { get; set; }
    public Decimal monthlyFee { get; set; }
  
    //Loan Details
    public String productLoanType { get; set; }
    public Integer term { get; set; }
    public String paymentType { get; set; }
  
    // Vehicle Details
    public String state { get; set; }
    public String vehicleGroup { get; set; }
    public String awd { get; set; }
    public String turbo { get; set; }
    public String diesel { get; set; }
  
    // Insurance Product
    public String gapLevel { get; set; }
    public Decimal gap { get; set; }
    public Decimal gapIncome { get; set; }
    public String warrantyLevel { get; set; }
    public Decimal warranty { get; set; }
    public Decimal warrantyIncome { get; set; }
    public String ltiLevel { get; set; }
    public Decimal lti { get; set; }
    public Decimal ltiIncome { get; set; }
    public String taiLevel { get; set; }
    public Decimal tai { get; set; }
    public Decimal taiIncome { get; set; }
    public String mvLevel { get; set; }
    public Decimal mv { get; set; }
    public Decimal mvIncome { get; set; }
    public Decimal cci { get; set; }
    public Decimal cciIncome { get; set; }
    public Decimal nwc { get; set; }
    public Decimal nwcIncome { get; set; }
  
    // finance calculator output
    public Decimal estimatedCommission { get; set; }
  
    public Decimal nafCalculated { get; set; }
    public Decimal rental { get; set; }
  
    public String loanTypeDetail { get; set; }
  
    //Lelo                                      2016-12-20
    public String loanType { get; set; }
    public Decimal tradeIn { get; set; }
    public Decimal payoutOn { get; set; }
    //-
  
    //Lelo                  Insurance                       2018-03-02
    public String nwcPlan { get; set; }
    public String nwcTerm { get; set; }
    public Decimal nwcCost { get; set; }
    public String nwcAcceptance { get; set; }
  
    public String mvAcceptance { get; set; }
    public String gapAcceptance { get; set; }
    public String taiAcceptance { get; set; }
    public String ltiAcceptance { get; set; }
    public String warrantyAcceptance { get; set; }
    public String cciAcceptance { get; set; }
  
    public String insuranceInputMode { get; set; }
    //-
    public Decimal riskFee { get; set; }
  
    public String loanPurpose { get; set; }
    public String purposeType { get; set; }
    public String tier { get; set; }
    //-
    public SocietyOneDTO() {
    }
  
    public void init() {
      estimatedCommission = 0.0;
      nafCalculated = 0.0;
      rental = 0.0;
      deposit = 0;
      tradeIn = 0;
      payoutOn = 0;
    }
  
    public Decimal getTotalAmount(String calcType) {
      Decimal r = 0.0;
      if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        if (carPrice != null)
          r +=
            carPrice +
            (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
      } else {
        if (carPrice != null)
          r += carPrice;
      }

      if (applicationFee != null)
        r += applicationFee;
      if (dof != null)
        r += dof;
      if (ppsr != null)
        r += ppsr;
      if (riskFee != null)
        r += riskFee;
      r -= getNetDeposit();
      return r;
    }
  
    public Decimal getTotalInsuranceType(String calcType) {
      Decimal r = 0.0;
      return r;
    }
  
    public Decimal getTotalInsuranceIncomeType(String calcType) {
      Decimal r = 0.0;
      return r;
    }

    public Decimal getRealtimeNaf() {
      Decimal r = this.getTotalAmount(QuotingCalculation.CALC_QUOTING);
      r += this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
      return r;
    }
  
    public Decimal getDofResult() {
      Decimal r = 0.0;
      if (dof != null) {
        r = dof / 1.1;
      }
      return r.setScale(2);
    }
  
    public Decimal getTotalCommission() {
      Decimal r = 0.0;
      if (estimatedCommission != null)
        r += estimatedCommission;
      r += getInsuranceIncome();
      r += getDofResult();
      return r.setScale(2);
    }
  
    public Decimal getTotalCommissionGst() {
      Decimal r = getTotalCommission() * 1.1;
      return r.setScale(2);
    }
  
    public Decimal getInsuranceIncome() {
      Decimal r = this.getTotalInsuranceIncomeType(
        QuotingCalculation.CALC_QUOTING
      );
      r = r / 1.1;
      return r.setScale(2);
    }
  
    public Decimal getMonthlyPayment() {
      Decimal r = 0.0;
      if (nafCalculated > 0) {
        if (rental != null)
          r += rental;
        if (monthlyFee != null)
          r += monthlyFee;
      }
      return r.setScale(2);
    }
  
    public Decimal getFortnightlyPayment() {
      Decimal r = getMonthlyPayment() * 12 / 26;
      return r.setScale(2);
    }
  
    public Decimal getWeeklyPayment() {
      Decimal r = getMonthlyPayment() * 12 / 52;
      return r.setScale(2);
    }
  
    public Decimal getNetDeposit() {
      Decimal netDeposit = 0;
      if (deposit != null)
        netDeposit += deposit;
      if (tradeIn != null)
        netDeposit += tradeIn;
      if (payoutOn != null)
        netDeposit -= payoutOn;
      return netDeposit;
    }
}