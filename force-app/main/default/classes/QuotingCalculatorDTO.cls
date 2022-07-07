public class QuotingCalculatorDTO {
  // univeral variables
  public String lender { get; set; }
  // vehicles details
  public String state { get; set; }
  public String vehicleGroup { get; set; }
  public String awd { get; set; }
  public String turbo { get; set; }
  public String diesel { get; set; }
  // insurance details
  public String gapLevel { get; set; }
  public String gap { get; set; }
  public String gapIncome { get; set; }
  public String nwc { get; set; }
  public String nwcIncome { get; set; }
  public String warrantyLevel { get; set; }
  public String warranty { get; set; }
  public String warrantyIncome { get; set; }
  public String ltiLevel { get; set; }
  public String lti { get; set; }
  public String ltiIncome { get; set; }
  public String truckGapLevel { get; set; }
  public String truckGap { get; set; }
  public String truckGapIncome { get; set; }
  public String taiLevel { get; set; }
  public String tai { get; set; }
  public String taiIncome { get; set; }
  public String mvLevel { get; set; }
  public String mv { get; set; }
  public String mvIncome { get; set; }
  //public String cciLevel {get;set;}
  public String cci { get; set; }
  public String cciIncome { get; set; }
  // finance and loan details
  public String carPrice { get; set; }
  public String deposit { get; set; }
  public String applicationFee { get; set; }
  public String dof { get; set; }
  public String ppsr { get; set; }
  public String residualValue { get; set; }
  // Pepper calculators do not have base Rate
  public String baseRate { get; set; }
  public String clientRate { get; set; }
  public String term { get; set; }
  public String paymentType { get; set; }
  public String repaymentType { get; set; }
  // Commission and Repayment
  public String estimatedCommission { get; set; }
  public String insuranceIncome { get; set; }
  public String dofResult { get; set; }
  public String totalCommission { get; set; }
  public String totalCommissionGst { get; set; }
  public String naf { get; set; }
  public String rental { get; set; }
  public String monthlyFee { get; set; }
  public String monthlyPayment { get; set; }
  public String fortnightlyPayment { get; set; }
  public String weeklyPayment { get; set; }
  // specific variables
  // specific for ANZ consumer and commercial
  public String adverseCredit { get; set; }
  public String customerProfile { get; set; } //Yamaha - Motorcycles
  public String ltv { get; set; }
  // specific for ANZ others
  public String recommendedRate { get; set; }
  public String goodsType { get; set; }
  public String vehiclesProfile { get; set; }
  // specific for Macquarie Consumer
  public String brokerage { get; set; }
  public String carAge { get; set; }
  public String motorCycles { get; set; }
  public String caravanCampervans { get; set; }
  // specific for Pepper MV, Pepper Leisure, and Pepper 5 Oh!
  public String registrationFee { get; set; }
  public String clientTier { get; set; }
  // specific for St George MV and Leisure
  public String loanType { get; set; }
  public String paymentFrequency { get; set; }
  public String carType { get; set; }
  // specific for Liberty Drive and Options
  public String lvr { get; set; }
  // St George calculators have loanType as well
  public String vehicleAge { get; set; }
  // specific for Liberty Options only
  public String riskFee { get; set; }
  public String rateOption { get; set; }
  // insurance details only for Liberty
  public String isp { get; set; }
  public String ispIncome { get; set; }
  public String fpa { get; set; }
  public String fpaIncome { get; set; }
  public String veiLevel { get; set; }
  public String vei { get; set; }
  public String veiIncome { get; set; }
  public String lpiLevel { get; set; }
  public String lpi { get; set; }
  public String lpiIncome { get; set; }
  // specific for Finance One
  // will use loanType in St George and riskFee in Liberty
  // control the PDF content for Liberty Insurance Product
  public String libertyBoolean { get; set; }
  public Boolean isLiberty { get; set; }
  // control the PDF content for Finance One content
  public String financeOneBoolean { get; set; }
  public Boolean isFinanceOne { get; set; }
  // the variables for saving the product
  public String productLoanType { get; set; }
  public String productGoodsType { get; set; }

  public Decimal brokeragePercentage { get; set; }
  public String privateSales { get; set; }
  public String saleBacksPurchased { get; set; }

  //General
  public String extraLabel1 { get; set; }
  public String extraLabel2 { get; set; }
  public String extraLabel3 { get; set; }
  public String extraLabel4 { get; set; }

  public Decimal extraValue1 { get; set; }
  public Decimal extraValue2 { get; set; }
  public Decimal extraValue3 { get; set; }
  public Decimal extraValue4 { get; set; }

  public String loanTypeDetail { get; set; }
  public String tradeIn { get; set; }
  public String payoutOn { get; set; }
  public String netDeposit { get; set; }

  public String insuranceInputMode { get; set; }
  //Yohan VillaLeal                               2019-08-22
  public String loanPurpose { get; set; }
  //-
}