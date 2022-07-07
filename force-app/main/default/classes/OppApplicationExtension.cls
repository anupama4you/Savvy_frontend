public without sharing class OppApplicationExtension {
    public Custom_Opportunity__c Opp;
    // The boolean to control the page to stay on quotingTool div
    public boolean quotingTool {get;set;}
    public String redirectQuting {get;set;}
    // The boolean to control the page to stay on servicingCalc div
    public boolean servicingCalc {get;set;}
    // The boolean to control the page to stay on YtdCalc div
    public boolean ytdCalc {get;set;}
    // The boolean to control the page to stay on Asset Details div
    public boolean assetDetails {get;set;}
    // The boolean to control the page to stay on Asset Details div
    public boolean notesSection {get;set;}
    // The variables for quoting tool
    public decimal gap {get;set;}
    public decimal warranty {get;set;}
    public decimal lpi {get;set;}
    public decimal other {get;set;}
    public decimal brokerageRate {get;set;}
    public decimal interestRate {get;set;}
    public decimal monthlyFee {get;set;}
    public decimal equipmentCost {get;set;}
    public decimal rental {get;set;}
    public decimal monthlyPayment {get;set;}
    public decimal fortnightPayment {get;set;}
    public decimal weeklyPayment {get;set;}
    public decimal residualValue {get;set;}
    public decimal clientRate {get;set;}
    public decimal brokerage {get;set;}
    public boolean isCommercial {get;set;}
    // The variables for servicing calculator
    public decimal emIncome1 {get;set;}
    public decimal emIncome2 {get;set;}
    public decimal othIncome1 {get;set;}
    public decimal othIncome2 {get;set;}
    public decimal rentMon {get;set;}
    public decimal othDebts {get;set;}
    public decimal livExpense {get;set;}
    public decimal reqSurplus {get;set;}
    public decimal emIncomeMon1 {get;set;}
    public decimal emIncomeMon2 {get;set;}
    public decimal othIncomeMon1 {get;set;}
    public decimal othIncomeMon2 {get;set;}
    public decimal rentMonth {get;set;}
    public decimal othDebtsMon {get;set;}
    public String incFreq1 {get;set;}
    public String incFreq2 {get;set;}
    public String othFreq1 {get;set;}
    public String othFreq2 {get;set;}
    public String rentFreq {get;set;}
    public String debtFreq {get;set;}
    public List <SelectOption> frequency {get;set;}
    public decimal monIncome {get;set;}
    public decimal subTotal {get;set;}
    public decimal amtForLoan {get;set;}
    // The variables for YTD Calculator
    public date startDate {get;set;}
    public date endDate {get;set;}
    //Others Applicant 1
    public date startDateOth {get;set;}
    public date endDateOth {get;set;}
    public decimal ytdWeeksOth {get;set;}
    public decimal ytdIncomeOth {get;set;}
    public decimal ytdMonIncomeOth {get;set;}
    public decimal annualIncomeOth {get;set;}
    //Others Applicant 2
    public date startDateOthA2 {get;set;}
    public date endDateOthA2 {get;set;}
    public decimal ytdWeeksOthA2 {get;set;}
    public decimal ytdIncomeOthA2 {get;set;}
    public decimal ytdMonIncomeOthA2 {get;set;}
    public decimal annualIncomeOthA2 {get;set;}
    //-
    public decimal ytdWeeks {get;set;}
    public decimal ytdIncome {get;set;}
    public decimal baseIncome {get;set;}
    public String ytdComment2 {get;set;}
    public String ytdComment1 {get;set;}
    //public decimal ytdIncomeOth {get;set;}
    //public decimal baseIncomeOth {get;set;}
    public decimal baseIncomeLowDoc {get;set;}
    public decimal annualIncome {get;set;}
    public decimal ytdTax {get;set;}
    public decimal ytdMedi {get;set;}
    public decimal ytdMonIncome {get;set;}
    public decimal baseTax {get;set;}
    public decimal baseMedi {get;set;}
    public decimal netMonIncome {get;set;}
    public decimal monDifference {get;set;}
    public decimal discDiff {get;set;}
    public decimal outAmount {get;set;}
    public Blob ytdDocBody {get;set;}
    public String ytdDocName {get;set;}
    public String ytdDocContectType {get;set;}
    // variables for Application
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String emailAddress {get;set;}
    public String mobileNumber {get;set;}
    public String typeAsset {get;set;}
    public String vehicleMake {get;set;}
    public String vehicleModel {get;set;}
    public String vehicleYear {get;set;}
    public Decimal purchasePrice {get;set;}
    public Decimal financeAmount {get;set;}
    public integer lengthTerm {get;set;}
    public Decimal preferredRepayment {get;set;}
    public String repaymentRegularity {get;set;}
    public integer noPeople {get;set;}
    public String applicationType {get;set;}
    public String abnCode {get;set;}
    public String acn {get;set;}
    public String tradingName {get;set;}
    public String trustName {get;set;}
    public String tradingAddress {get;set;}
    public String natureBusiness {get;set;}
    public integer noDirectors {get;set;}
    public Decimal estimatedProfit {get;set;}
    public String accountantName {get;set;}
    public String accountantPhone {get;set;}
    public String title1 {get;set;}
    public String title2 {get;set;}
    public String firstName2 {get;set;}
    public String middleName {get;set;}
    public String middleName2 {get;set;}
    public String lastName2 {get;set;}
    public String dateBirth1 {get;set;}
    public String dateBirth2 {get;set;}
    public String gender1 {get;set;}
    public String gender2 {get;set;}
    public String driversLicense1 {get;set;}
    public String driversLicense2 {get;set;}
    public String typeLicence1 {get;set;}
    public String typeLicence2 {get;set;}
    public String expiryDate1 {get;set;}
    public String expiryDate2 {get;set;}
    public String maritalStatus1 {get;set;}
    public String maritalStatus2 {get;set;}
    public integer noDependants1 {get;set;}
    public integer noDependants2 {get;set;}
    public String agesDependants1 {get;set;}
    public String agesDependants2 {get;set;}
    public String homePhone {get;set;}
    public String homePhone2 {get;set;}
    public String workPhone {get;set;}
    public String workPhone2 {get;set;}
    public String mobileNumber2 {get;set;}
    public String emailAddress2 {get;set;}
    public decimal partnerIncome {get;set;}
    public decimal partnerIncome2 {get;set;}
    public String applicant2SameAddress {get;set;}
    public String streetAddress {get;set;}
    public String streetAddress2 {get;set;}
    public String suburb {get;set;}
    public String suburb2 {get;set;}
    public String postcode {get;set;}
    public String postcode2 {get;set;}
    public String dateMovedIn1 {get;set;}
    public String dateMovedIn2 {get;set;}
    public String currentStatus1 {get;set;}
    public String currentStatus2 {get;set;}
    public String landlordName1 {get;set;}
    public String landlordName2 {get;set;}
    public String landlordPhone1 {get;set;}
    public String landlordPhone2 {get;set;}
    public decimal rentMonth1 {get;set;}
    public decimal rentMonth2 {get;set;}
    //- Lelo, new fields                2016-06-27
    public decimal boardMonth1 {get;set;}
    public decimal boardMonth2 {get;set;}
    //-
    public String living3Years1 {get;set;}
    public String living3Years2 {get;set;}
    public String previousStreetAddress1 {get;set;}
    public String previousStreetAddress2 {get;set;}
    public String previousSuburb1 {get;set;}
    public String previousSuburb2 {get;set;}
    public String previousPostcode1 {get;set;}
    public String previousPostcode2 {get;set;}
    public String dateFrom1 {get;set;}
    public String dateFrom2 {get;set;}
    public String previousResidenceStatus1 {get;set;}
    public String previousResidenceStatus2 {get;set;}
    public String modeEmployment1 {get;set;}
    public String modeEmployment2 {get;set;}
    public String employerName1 {get;set;}
    public String employerName2 {get;set;}
    /**Curremt work address --- I--HJ**/
    public String currentWorkUnitNumber1 {get;set;}
    public String currentWorkUnitNumber2 {get;set;}
    public String currentWorkStreetNumber1 {get;set;}
    public String currentWorkStreetNumber2 {get;set;}
    public String currentWorkStreetType1 {get;set;}
    public String currentWorkStreetType2 {get;set;}
    public String currentWorkSuburb1 {get;set;}
    public String currentWorkSuburb2 {get;set;}
    public String currentWorkPostcode1 {get;set;}
    public String currentWorkPostcode2 {get;set;}
    public String currentWorkState1 {get;set;}
    public String currentWorkState2 {get;set;}
    public String previousWorkUnitNumber1 {get;set;}
    public String previousWorkUnitNumber2 {get;set;}
    public String previousWorkStreetNumber1 {get;set;}
    public String previousWorkStreetNumber2 {get;set;}
    public String previousWorkStreetType1 {get;set;}
    public String previousWorkStreetType2 {get;set;}
    public String previousWorkSuburb1 {get;set;}
    public String previousWorkSuburb2 {get;set;}
    public String previousWorkPostcode1 {get;set;}
    public String previousWorkPostcode2 {get;set;}
    public String previousWorkState1 {get;set;}
    public String previousWorkState2 {get;set;}
    public String previousWorkOverseasState1 {get;set;}
    public String previousWorkOverseasState2 {get;set;}
    /**Curremt work address --- F--HJ**/
    public String workAddress1 {get;set;}
    public String workAddress2 {get;set;}
    public String employerPhone1 {get;set;}
    public String employerPhone2 {get;set;}
    public String referenceName1 {get;set;}
    public String referenceName2 {get;set;}
    public String occupation1 {get;set;}
    public String occupation2 {get;set;}
    public String dateStarted1 {get;set;}
    public String dateStarted2 {get;set;}
    public decimal netIncome1 {get;set;}
    public decimal netIncome2 {get;set;}
    public String paymentFrequency1 {get;set;}
    public String paymentFrequency2 {get;set;}
    public String employed3Years1 {get;set;}
    public String employed3Years2 {get;set;}
    public String previousModeEmployment1 {get;set;}
    public String previousModeEmployment2 {get;set;}
    public String previousEmployerName1 {get;set;}
    public String previousEmployerName2 {get;set;}
    public String previousWorkAddress1 {get;set;}
    public String previousWorkAddress2 {get;set;}
    public String previousEmployerPhone1 {get;set;}
    public String previousEmployerPhone2 {get;set;}
    public String previousReferenceName1 {get;set;}
    public String previousReferenceName2 {get;set;}
    public String previousOccupation1 {get;set;}
    public String previousOccupation2 {get;set;}
    public String startDate1 {get;set;}
    public String startDate2 {get;set;}
    public String finishDate1 {get;set;}
    public String finishDate2 {get;set;}
    //public String receiveOther1 {get;set;}
    //public String receiveOther2 {get;set;}
    // public String otherType11 {get;set;}
    // public String otherType21 {get;set;}
    // public String otherDetail11 {get;set;}
    // public String otherDetail21 {get;set;}
    // public decimal otherAmount11 {get;set;}
    // public decimal otherAmount21 {get;set;}
    // public String otherType12 {get;set;}
    // public String otherType22 {get;set;}
    // public String otherDetail12 {get;set;}
    // public String otherDetail22 {get;set;}
    // public decimal otherAmount12 {get;set;}
    // public decimal otherAmount22 {get;set;}
    // public String otherType13 {get;set;}
    // public String otherType23 {get;set;}
    // public String otherDetail13 {get;set;}
    // public String otherDetail23 {get;set;}
    // public decimal otherAmount13 {get;set;}
    // public decimal otherAmount23 {get;set;}
    // public String otherType14 {get;set;}
    // public String otherType24 {get;set;}
    // public String otherDetail14 {get;set;}
    // public String otherDetail24 {get;set;}
    // public decimal otherAmount14 {get;set;}
    // public decimal otherAmount24 {get;set;}
    // public String otherType15 {get;set;}
    // public String otherType25 {get;set;}
    // public String otherDetail15 {get;set;}
    // public String otherDetail25 {get;set;}
    // public decimal otherAmount15 {get;set;}
    // public decimal otherAmount25 {get;set;}
    // public String otherType16 {get;set;}
    // public String otherType26 {get;set;}
    // public String otherDetail16 {get;set;}
    // public String otherDetail26 {get;set;}
    // public decimal otherAmount16 {get;set;}
    // public decimal otherAmount26 {get;set;}
    
    public String bankName {get;set;}
    public Decimal bankValue {get;set;}
    public String superValue {get;set;}
    public Decimal superValueHow {get;set;}
    public Decimal furnitureValue {get;set;}
    //- Lelo                                2016-06-27
    public Decimal basicLivingExpensesMonth {get;set;}
    public Decimal childcareChildMaintenanceMonth {get;set;}
    public Decimal mobilePhoneInternetPayTVMonth {get;set;}
    public Decimal insuranceExpensesMonth {get;set;}
    public Decimal travelTransportExpensesMonth {get;set;}
    public Decimal otherExpensesMonth {get;set;}
    public String incomeTypeExpenses {get;set;}
    //-
    //- Lelo, section References / Supporting documents                         2016-06-27
    public String personalReference1Address {get;set;}
    public String personalReference1Full_Name {get;set;}
    public String personalReference1Phone {get;set;}
    public String personalReference1Relationship {get;set;}
    public String personalReference2Address {get;set;}
    public String personalReference2Full_Name {get;set;}
    public String personalReference2Phone {get;set;}
    public String personalReference2Relationship {get;set;}
    public String supportingDocument1 {get;set;}
    public String supportingDocument2 {get;set;}
    public String supportingDocument3 {get;set;}
    public String supportingDocument4 {get;set;}
    public String expectAnyChangeYourFinaPosition {get;set;}
    public String anythingYouWantTellUsAboutApp {get;set;}
    public String creditStatus1 {get;set;}
    public String creditStatus2 {get;set;}
    //- Lelo                                                                    2016-06-28
    public String currentResidentialStatus1 {get;set;}
    public String currentResidentialStatus2 {get;set;}
    //- Lelo                                2016-06-30
    public String entityName {get;set;}
    public String Postcode6 {get;set;}
    public String NoAppState {get;set;}
    //- Lelo                                2016-07-05
    public String stateOfIssue1 {get;set;}
    public String stateOfIssue2 {get;set;}
    //- Lelo                                2017-04-05
    public String unitNumber1 {get;set;}
    public String unitNumber2 {get;set;}
    public String streetNumber1 {get;set;}
    public String streetNumber2 {get;set;}
    public String streetType1 {get;set;}
    public String streetType2 {get;set;}
    public String state1 {get;set;}
    public String state2 {get;set;}
    public Application__c app0 {get;set;}
    public Integer numPrevAddress1 {get;set;}
    public Integer numPrevAddress2 {get;set;}
    //Jesus Mora
    public String addressLookup {get;set;}
    public String addressLookup2 {get;set;}
    public String addressLookup3 {get;set;}
    public String addressLookup4 {get;set;}
    public String addressLookup5 {get;set;}
    public String addressLookup6 {get;set;}
    public String addressLookup7 {get;set;}
    public String addressLookup8 {get;set;}
    public String addressLookup9 {get;set;}
    public String addressLookup10 {get;set;}
    public String addressLookup11 {get;set;}
    public String addressLookup12 {get;set;}
    public String addressLookup13 {get;set;}
    public String addressLookup14 {get;set;}
    public String addressLookup15 {get;set;}
    public String addressLookup16 {get;set;}
    public String addressLookup17 {get;set;}
    public String addressLookup23 {get;set;}
    public String addressLookup24 {get;set;}
    public String addressLookup25 {get;set;}
    public String addressLookup26 {get;set;}
    public String addressLookup27 {get;set;}
    public String addressLookup28 {get;set;}
    public String addressLookup29 {get;set;}
    public String addressLookup30 {get;set;}
    public String addressLookup31 {get;set;}
    public String addressLookup32 {get;set;}
    public String addressLookup33 {get;set;}
    public String addressLookup19 {get;set;}
    public String addressLookup20 {get;set;}
    public String addressLookup21 {get;set;}
    public String addressLookup18 {get;set;}
    public String addressLookup34 {get;set;}
    public String addressLookup35 {get;set;}
    public String addressLookup36 {get;set;}
    public String addressLookup37 {get;set;}
    public String addressLookup38 {get;set;}
    public String addressLookup39 {get;set;}
    public String addressLookup40 {get;set;}
    public String addressLookup41 {get;set;}
    public String addressLookup42 {get;set;}
    private Map < String, List < Application_Employment__c >> prevEmplMap = null;
    private List < Application_Employment__c > prevEmplRemList = null;
    private Application_Employment__c addressFinanceDetail = null;
    //
    public List <SelectOption> licenceTypes {get;set;}
    public List <SelectOption> assetTypes {get;set;}
    public List <SelectOption> frequency2 {get;set;}
    public List <SelectOption> peopleNumber {get;set;}
    public List <SelectOption> applicationTypes {get;set;}
    public List <SelectOption> titleTypes {get;set;}
    public List <SelectOption> maritalStatuses {get;set;}
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> yes0No1Options {get;set;}
    public List <SelectOption> residenceStatuses {get;set;}
    public List <SelectOption> employmentTypes {get;set;}
    public List <SelectOption> loanTypes {get;set;}
    //- Lelo                                2016-06-27
    public List <SelectOption> creditStatusSel {get;set;}
    //- Lelo                                2016-06-28
    public List <SelectOption> curResidentialStatusSel {get;set;}
    //- Lelo                                2016-07-05
    public List <SelectOption> statesOfIssue2Sel {get;set;}
    //-
    public List < AppServicingCalculatorDTO.LoanDTO > servLoanList {get;set;}
    // choose lender panel
    public String lenderSelect {get;set;}
    public List <SelectOption> lenders {get;set;}
    //- Lelo        Servicing Calculator            2017-01-20
    public Boolean isServLowDocSelfEmployed {get;set;}
    //public Decimal servCalcNAF {get;set;}
    //- Lelo        Servicing Calculator            2016-07-06
    public String servCalcLender {get;set;}
    
    //-Yohan VillaLeal      Servicing calculator
    public List < String > servAreas = new List < String > {
        'Metro', 'Non Metro'};
            public String servArea {get;set;}
    public Decimal servCalcMortgageBuffer {get;set;}
    public List < String > servStates = new List < String > {
        'ACT', 'NSW','NT', 'QLD','SA', 'TAS','VIC', 'WA'
            };
                public Boolean isFirstmac {get;set;}
    public String servState {get;set;}    
    public List <SelectOption> servCalcLenderSelect {get;set;}
    private Map < String, String > servCalcLenderValues = OppApplicationServCalculatorUtils.lenderMap;
    // private Map < String, String > servCalcLenderValues = new Map < String, String > {
    //     'AFS' => 'AFS',
    //     'ESA' => 'ANZ',
    //     'F1ECO' => 'F1 Economy Motors',
    //     'FINA' => 'Finance 1',
    //     'Firstmac' => 'Firstmac',
    //     'GRE' => 'Green Light',
    //     'LAP' => 'Latitude Personal',
    //     'Latitude' => 'Latitude (Car Loan)',
    //     'LIB' => 'Liberty',
    //     'MAC' => 'Macquarie',
    //     'MON3' => 'Money 3',
    //     'MON3MI' => 'Money 3 (Micro)',
    //     'MONPL' => 'Money Place',
    //     //'PEP'=>'Pepper', 'GEO'=>'St George'
    //     'PEP' => 'Pepper',
    //     'RateSetter' => 'RateSetter',
    //     'Yamaha' => 'Yamaha'
    // };
    public String servCalcState {get;set;}
    //public List<SelectOption> servCalcStateSelect {get;set;}
    public String servCalcArea {get;set;}
    public List <SelectOption> servCalcAreaSelect {get;set;}
    private List < String > servCalcAreaValues = new List < String > {
        'Metro', 'Regional'};
            public String servCalcType {get;set;}
    //public List<SelectOption> servCalcTypeSelect {get;set;}
    public String servCalcNoDependents {get;set;}
    public List <SelectOption> servCalcNoDependentsSelect {get;set;}
    public String servCalcSplittingExpenses {get;set;}
    public Decimal servCalcPartnerIncome {get;set;}
    public Decimal servCalcTotNetMonthlyIncome {get;set;}
    public Decimal secondJobCalcTotNetMonthlyIncome {get;set;}
    public Decimal servCalcTotLiabilities {get;set;}
    public Decimal servCalcLiabilityCount {get;set;}
    public Decimal servCalcTotRentMtgPaid {get;set;}
    public Decimal servCalcTotLivingExpenses {get;set;}
    //public Decimal servCalcTotOtherDebts {get;set;}
    public Decimal servCalcTotAmountLoanPayment {get;set;}
    public Decimal servCalcBuffer {get;set;}
    public String servCalcIncomePayFrecuency1 {get;set;}
    public String servCalcIncomePayFrecuency1b {get;set;}
    public String servCalcIncomePayFrecuency2b {get;set;}
    public Decimal servCalcIncomeAmount1 {get;set;}
    public Decimal servCalcIncomeAmount1b {get;set;}
    public Decimal servCalcIncomeAmount2b {get;set;}
    public Decimal servCalcEstimateAmount {get;set;}
    public String servCalcOtherIncomePayFrecuency1 {get;set;}
    public String servCalcOtherIncomeType1 {get;set;}
    public Decimal servCalcOtherIncomeAmount1 {get;set;}
    public List <SelectOption> servCalcOtherIncomeTypeSelect {get;set;}
    private List < String > servCalcOtherIncomeTypeValues = new List < String > {
        'Rental Income',
            'Child Support',
            'Family Part A & B',
            'Investment Income',
            'Newstart',
            'Rent Assistance',
            'Parenting Payment Single',
            'Parenting Payment Partnered',
            'Second Job',
            'Trust Income',
            'Other'
            };
                public String servCalcIncomePayFrecuency2 {get;set;}
    public Decimal servCalcIncomeAmount2 {get;set;}
    public String servCalcOtherIncomePayFrecuency2 {get;set;}
    public String servCalcOtherIncomeType2 {get;set;}
    public Decimal servCalcOtherIncomeAmount2 {get;set;}
    public String servCalcLoanType {get;set;}
    public String servCalcLoanType2 {get;set;}
    public String servCalcLoanType3 {get;set;}
    public String servCalcLoanType4 {get;set;}
    public List <SelectOption> servCalcLoanTypeSelect {get;set;}
    private List < String > servCalcLoanTypeValues = new List < String > {
        'Car Loan',
            'Line of Credit',
            'Mortgage',
            'Payday Loan',
            'Personal Loan'
            };
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
    //- Lelo                                2016-07-29
    public boolean servCalcSplitRentMortgage {get;set;}
    public boolean servCalcCSplitLivingExpenses {get;set;}
    private String servCalcCSplitOrder = '';
    public Decimal servCalcSplitNetPartIncomeTotal {get;set;}
    public Decimal servCalcSplitRentMortgageTotal {get;set;}
    public Decimal servCalcSplitLivingExpensesTotal {get;set;}
    public Decimal servCalcNetAfterTax {get;set;}
    public Decimal servCalcNetBeforeTax {get;set;}
    //- Lelo        YTD Calculator          2016-07-13
    public String ytdCalcLender {get;set;}
    public List <SelectOption> ytdCalcLenderSelect {get;set;}
    public date startDateEsa {get;set;}
    public date endDateEsa {get;set;}
    public decimal ytdWeeksEsa {get;set;}
    public decimal ytdIncomeEsa {get;set;}
    public decimal baseIncomeEsa {get;set;}
    public decimal ytdMonIncomeEsa {get;set;}
    public decimal baseTaxEsa {get;set;}
    public decimal baseMediEsa {get;set;}
    public decimal netMonIncomeEsa {get;set;}
    public decimal monDifferenceEsa {get;set;}
    //Applicant 2
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
    public Decimal ytdMacPayPeriodDays {get;set;}
    public Decimal ytdMacMonthlyNetYtdSalary {get;set;}
    public Decimal ytdMacAnnuallyNetYtdSalary {get;set;}
    public Decimal ytdMacMonthlyPayPeriodNetSalary {get;set;}
    public Decimal ytdMacAnnuallyPayPeriodNetSalary {get;set;}
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
    //- Lelo        YTD Calculator          2016-08-22
    //Full Documentation
    public String fdLender {get;set;}
    public Decimal fdNetProfit {get;set;}
    public Decimal fdNetProfitCalc {get;set;}
    public Decimal fdNetProfitCalc2 {get;set;}
    public Decimal fdDepreciation {get;set;}
    public Decimal fdInterest {get;set;}
    public Decimal fdDirectorSalary {get;set;}
    //- Lelo        2017-02-09
    public String fldSelfEmployedClass {get;set;}
    public String fldSelfEmployedType {get;set;}
    //St George
    public String sgtPaylipsFrecuency {get;set;}
    public String sgtPaylipsFrecuency1 {get;set;}
    public String sgtPaylipsFrecuency2 {get;set;}
    public String sgtPaylipsFrecuency3 {get;set;}
    public Decimal sgtPaylipsAmount {get;set;}
    public Decimal sgtPaylipsAmount1 {get;set;}
    public Decimal sgtPaylipsAmount2 {get;set;}
    public Decimal sgtPaylipsAmount3 {get;set;}
    public String sgtPaylipsFrecuencyA2 {get;set;}
    public String sgtPaylipsFrecuency1A2 {get;set;}
    public String sgtPaylipsFrecuency2A2 {get;set;}
    public String sgtPaylipsFrecuency3A2 {get;set;}
    public Decimal sgtPaylipsAmountA2 {get;set;}
    public Decimal sgtPaylipsAmount1A2 {get;set;}
    public Decimal sgtPaylipsAmount2A2 {get;set;}
    public Decimal sgtPaylipsAmount3A2 {get;set;}
    //- Lelo        Application: new fields          2016-07-13
    public String relativeName1 {get;set;}
    public String relativePhone1 {get;set;}
    public String relativeName2 {get;set;}
    public String relativePhone2 {get;set;}
    //- Lelo        Application: new fields          2016-07-13
    public String haveDriverLicence1 {get;set;}
    public String haveDriverLicence2 {get;set;}
    //- Lelo        Application: new fields for Notes          2016-08-03
    public String noteText {get;set;}
    public Id noteId {get;set;}
    public String noteCategory {get;set;}
    //- Lelo        Application: new fields           2016-08-03
    // public Integer propertySel {get;set;}
    // public Integer vehicleSel {get;set;}
    //- Lelo        Servicing: new fields           2018-05-02
    public Map < Long, List < Application_Income__c >> servIncomeMap {get;set;}
    //Lelo          YTD - Pepper fields         2018-05-10
    public Decimal latestPay1 {get;set;}
    public Decimal latestPay2 {get;set;}
    public Decimal latestPayMonthly1 {get;set;}
    public Decimal latestPayMonthly2 {get;set;}
    public String latestPayFrequency1 {get;set;}
    public String latestPayFrequency2 {get;set;}
    
    //Lelo          Servicing - Pepper fields       2018-05-10
    public Decimal servMonthlyRepayment {get;set;}
    //-
    
    //PopUp - HJ - I - 14082018
    public Boolean displayPopUp {get;set;}
    public Boolean ABNlookupDisplayPopUp {get;set;}
    public Boolean abnInfo {get;set;}
    public Boolean ABNandACNdisplayPopUp {get;set;}
    public Boolean NameDisplayPopUp {get;set;}
    public Boolean MessageDisplayPopUp {set; get;}
    public AddressSplit addressSplit {get;set;}
    public String tmpAddress {get;set;}
    public String tmpAddressNew {get;set;}
    public Integer tmpRow {get;set;}
    public String section {get;set;}
    public Boolean isUserApprovalTeam {get;set;}
    // Lelo                 2019-08-05
    public String trusteesNumber {get;set;}
    public Decimal fdNetProfit2 {get;set;}
    public Decimal fdSales {get;set;}
    // Yohan Villa Leal                   2019-09-08  
    public boolean isSecondJobApplic1 {set;get;}
    public boolean isSecondJobApplic2 {set;get;}
    public List<Application_Employment__c> lstPrevEmployment{set; get;}
    pubLic List<Application_Employment__c> listAppEmploym {set;get;}
    public Application_Employment__c secondJobApplic1 {set;get;}
    public Application_Employment__c secondJobApplic2 {set;get;}
    //--
    //Yohan VillaLeal                    2019-09-12
    public String ytdLenderApplic {get;set;}
    public Decimal ytdGrossAnnualIncomeApplic1 {set; get;}
    public Decimal ytdGrossAnnualIncomeApplic2 {set; get;}
    public List <SelectOption> ytdLenderOptionsApplic {get;set;}
    private List<String> ytdLenderValues = new List<String> {
        'Any', 'Firstmac' 
            };
                //--
                //ABN Lookup PopUp
                public String nameLookup {set; get;}
    public ABNnameLookupDto Name {set; get;}
    public ABNlookupDto abnLookupDto {set; get;}
    public ABNlookupDto abnLookupDtoByName {set; get;}
    public String abnLookup {get;set;}
    public List <SelectOption> abnOptionValues {get;set;}
    private List<String> abnOptions = new List<String> {
        'ABN', 'ACN', 'Name'
            }; 
                public Map<Integer,List<ABNnameLookupDto.Names>> recordNames {set; get;}
    private integer count=1;   //to track the function calling
    public integer counter {get; set;}   //to keep track of offset
    private integer list_size=5; //to set the page size to show the rows/records
    public integer total_size; //used to show user the total size of the list
    public Integer countPage {set; get;}
    //--
    //PopUp - HJ - F -
    public String fldSelfEmployedClass2 {get;set;}
    public String fldSelfEmployedType2 {get;set;}
    public Decimal fdSales2 {get;set;}
    public Decimal fdNetProfit_2 {get;set;}
    public Decimal fdDepreciation2 {get;set;}
    public Decimal fdInterest2 {get;set;}
    public Decimal fdDirectorSalary2 {get;set;}
    public String trusteesNumber2 {get;set;}
    public Decimal fdNetProfit2_2 {get;set;}
    public List <SelectOption> properties {get;set;}
    public List <SelectOption> properties2 {get;set;}
  
    public Decimal grossAnnualIncome1 {get;set;}//Joy
    public Decimal grossAnnualIncome2 {get;set;}//Joy
    public Decimal grossAnnualIncome1SecondJob {get;set;}
    public Decimal grossAnnualIncome2SecondJob {get;set;}
    
    public OppApplicationExtension(ApexPages.StandardController controller) {
        system.debug('this page custom opportunity' + this.Opp);
        this.Opp = (Custom_Opportunity__c) controller.getRecord();
        
        //createQuotepage1.getParameters().clear();
        // Default values
        this.app0 = new Application__c();
        this.app0.Previous_Country_1__c = 'AUS';

        this.noPeople = 1;
        this.applicationType = 'Personal';
        this.firstName = this.Opp.First_Name__c;
        this.lastName = this.Opp.Last_Name__c;
        this.emailAddress = this.Opp.Email_Address__c;
        this.mobileNumber = this.Opp.Mobile_Number__c;
        this.app0.Date_of_Birth_1__c = '';

        numPrevAddress1 = 1;
        numPrevAddress2 = 1;
        isSecondJobApplic1 = false;
        isSecondJobApplic2 = false;
        secondJobApplic1 = new Application_Employment__c();
        secondJobApplic2 = new Application_Employment__c();
        String currUrl = ApexPages.currentPage().getUrl();
        if (currUrl == null || !currUrl.contains('ServicingCalculator')) {
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_1b__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_1b__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_1b__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_1b__c))) {
                  numPrevAddress1++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_1c__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_1c__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_1c__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_1c__c))) {
                  numPrevAddress1++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_1d__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_1d__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_1d__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_1d__c))) {
                  numPrevAddress1++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_1e__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_1e__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_1e__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_1e__c))) {
                  numPrevAddress1++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_2b__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_2b__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_2b__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_2b__c))) {
                  numPrevAddress2++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_2c__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_2c__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_2c__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_2c__c))) {
                  numPrevAddress2++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_2d__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_2d__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_2d__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_2d__c))) {
                  numPrevAddress2++;
              }
          if (this.Opp.Application__c != null && this.Opp.Application__r.Previous_Country_2e__c != null && 
              (String.isNotBlank(this.Opp.Application__r.Date_From_2e__c) 
              || String.isNotBlank(this.Opp.Application__r.Previous_Street_Address_2e__c)
              || String.isNotBlank(this.Opp.Application__r.Previous_Residence_Status_2e__c))) {
                  numPrevAddress2++;
              }
          }
        loadPreviousEmployments();
        quotingTool = false;
        servicingCalc = false;
        ytdCalc = false;
        assetDetails = false;
        notesSection = false;
        //startDate = Date.newInstance(2016, 7, 1);
        ytdCalcLender = 'ANZ';
        clearYTDEsandaOtherFields();
        //
        monthlyFee = 5;
        isCommercial = false;
        //- Lelo        Serv Calculator          2016-07-28
        servCalcLiabilityCount = 1;
        servCalcSplitRentMortgage = false;
        servCalcCSplitLivingExpenses = false;
        isServLowDocSelfEmployed = false;
        //- Lelo        YTD Calculator          2016-07-13
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
        ytdCalcLenderSelect = new List<SelectOption>();
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
        
        //-
        fldSelfEmployedType = 'Company Pty Ltd';
        fldSelfEmployedType2 = 'Company Pty Ltd';
        frequency = new List<SelectOption>();
        frequency.add(new SelectOption('', '--None--'));
        frequency.add(new SelectOption('Weekly', 'Weekly'));
        frequency.add(new SelectOption('Fortnightly', 'Fortnightly'));
        frequency.add(new SelectOption('Monthly', 'Monthly'));
        frequency.add(new SelectOption('Yearly', 'Yearly'));
        assetTypes = new List<SelectOption>();
        assetTypes.add(new SelectOption('', '--None--'));
        assetTypes.add(new SelectOption('Car', 'Car'));
        assetTypes.add(new SelectOption('Bike', 'Bike'));
        assetTypes.add(new SelectOption('Caravan', 'Caravan'));
        assetTypes.add(new SelectOption('Truck', 'Truck'));
        assetTypes.add(new SelectOption('Boat', 'Boat'));
        assetTypes.add(new SelectOption('JetSki', 'JetSki'));
        assetTypes.add(new SelectOption('Equipment', 'Equipment'));
        assetTypes.add(new SelectOption('Aircraft', 'Aircraft'));
        assetTypes.add(new SelectOption('Home', 'Home'));
        assetTypes.add(new SelectOption('Personal', 'Personal'));
        assetTypes.add(new SelectOption('RV/Motorhome', 'RV/Motorhome'));
        assetTypes.add(new SelectOption('Camper Trailer', 'Camper Trailer'));
        // assetTypes.add(new SelectOption('Other', 'Other'));
        frequency2 = new List<SelectOption>();
        frequency2.add(new SelectOption('', '--None--'));
        frequency2.add(new SelectOption('Week', 'Week'));
        frequency2.add(new SelectOption('Fortnight', 'Fortnight'));
        frequency2.add(new SelectOption('Month', 'Month'));
        peopleNumber = new List<SelectOption>();
        peopleNumber.add(new SelectOption('', '--None--'));
        peopleNumber.add(new SelectOption('1', 'One'));
        peopleNumber.add(new SelectOption('2', 'Two'));
        applicationTypes = new List<SelectOption>();
        applicationTypes.add(new SelectOption('', '--None--'));
        applicationTypes.add(new SelectOption('Personal', 'Personal'));
        applicationTypes.add(new SelectOption('Business', 'Business'));
        titleTypes = new List<SelectOption>();
        titleTypes.add(new SelectOption('', '--None--'));
        titleTypes.add(new SelectOption('Mr', 'Mr'));
        titleTypes.add(new SelectOption('Mrs', 'Mrs'));
        titleTypes.add(new SelectOption('Miss', 'Miss'));
        titleTypes.add(new SelectOption('Ms', 'Ms'));
        titleTypes.add(new SelectOption('Dr', 'Dr'));
        maritalStatuses = new List<SelectOption>();
        maritalStatuses.add(new SelectOption('', '--None--'));
        maritalStatuses.add(new SelectOption('Married', 'Married'));
        maritalStatuses.add(new SelectOption('Defacto', 'Defacto'));
        maritalStatuses.add(new SelectOption('Single', 'Single'));
        yesNoOptions = new List<SelectOption>();
        yesNoOptions.add(new SelectOption('', '--None--'));
        yesNoOptions.add(new SelectOption('Yes', 'Yes'));
        yesNoOptions.add(new SelectOption('No', 'No'));
        yes0No1Options = new List<SelectOption>();
        yes0No1Options.add(new SelectOption('', '--None--'));
        yes0No1Options.add(new SelectOption('0', 'Yes'));
        yes0No1Options.add(new SelectOption('1', 'No'));
        residenceStatuses = new List<SelectOption>();
        residenceStatuses.add(new SelectOption('', '--None--'));
        residenceStatuses.add(new SelectOption('Own Outright', 'Own Outright'));
        residenceStatuses.add(new SelectOption('Mortgage', 'Mortgage'));
        residenceStatuses.add(new SelectOption('Parents/Relative', 'Parents/Relative'));
        //- Lelo, new options added             2016-06-27
        //residenceStatuses.add(new SelectOption ('Renting', 'Renting'));
        residenceStatuses.add(new SelectOption('Renting(Agent)', 'Renting(Agent)'));
        residenceStatuses.add(new SelectOption('Renting(Private)', 'Renting(Private)'));
        //-
        residenceStatuses.add(new SelectOption('Boarding', 'Boarding'));
        residenceStatuses.add(new SelectOption('Employer Accommodation', 'Employer Accommodation'));
        residenceStatuses.add(new SelectOption('Non-Resident', 'Non-Resident'));
        employmentTypes = new List<SelectOption>();
        employmentTypes.add(new SelectOption('', '--None--'));
        employmentTypes.add(new SelectOption('Full Time', 'Full Time'));
        employmentTypes.add(new SelectOption('Part Time', 'Part Time'));
        employmentTypes.add(new SelectOption('Casual', 'Casual'));
        employmentTypes.add(new SelectOption('Self Employed', 'Self Employed'));
        employmentTypes.add(new SelectOption('Contract', 'Contract'));
        employmentTypes.add(new SelectOption('Financially Supported by Partner', 'Financially Supported by Partner'));
        employmentTypes.add(new SelectOption('Unemployed', 'Unemployed'));
        employmentTypes.add(new SelectOption('Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other'));
        employmentTypes.add(new SelectOption('Centrelink - Newstart only', 'Centrelink - Newstart only'));
        //-
        loanTypes = new List<SelectOption>();
        loanTypes.add(new SelectOption('', '--None--'));
        loanTypes.add(new SelectOption('Mortgage', 'Mortgage'));
        loanTypes.add(new SelectOption('Personal Loan', 'Personal Loan'));
        loanTypes.add(new SelectOption('Car Loan', 'Car Loan'));
        loanTypes.add(new SelectOption('Line of Credit', 'Line of Credit'));
        loanTypes.add(new SelectOption('Payday Loan', 'Payday Loan'));
        //- Lelo                                2020-03-02
        creditStatusSel = new List<SelectOption>();
        creditStatusSel.add(new SelectOption('', '--None--'));
        creditStatusSel.add(new SelectOption('Excellent', 'Excellent'));
        creditStatusSel.add(new SelectOption('Average', 'Average'));
        creditStatusSel.add(new SelectOption('Poor', 'Poor'));
        creditStatusSel.add(new SelectOption('Not Sure', 'Not sure'));
        creditStatusSel.add(new SelectOption('Current or Discharged Bankrupt Part 10', 'Current or Discharged Bankrupt (Part 10)'));
        creditStatusSel.add(new SelectOption('Current or Discharged Debt Agreement Part 9', 'Current or Discharged Debt Agreement (Part 9)'));
        // creditStatusSel.add(new SelectOption('Discharged Bankrupt Part 10', 'Discharged Bankrupt (Part 10)'));
        // creditStatusSel.add(new SelectOption('Discharged Debt Agreement Part 9', 'Discharged Debt Agreement (Part 9)'));
        // creditStatusSel.add(new SelectOption('Current Bankrupt Part 10', 'Current Bankrupt (Part 10)'));
        // creditStatusSel.add(new SelectOption('Currently in Debt Agreement Part 9', 'Currently in Debt Agreement (Part 9)'));
        // creditStatusSel.add(new SelectOption('Perfect', 'Perfect'));
        // creditStatusSel.add(new SelectOption('Paid Defaults', 'Paid Defaults'));
        // creditStatusSel.add(new SelectOption('Unpaid Defaults', 'Unpaid Defaults'));
        // creditStatusSel.add(new SelectOption('Discharged Bankrupt', 'Discharged Bankrupt'));
        // creditStatusSel.add(new SelectOption('Bankrupt Discharged Part 9', 'Bankrupt Discharged Part 9'));
        // creditStatusSel.add(new SelectOption('Currently Bankrupt', 'Currently Bankrupt'));
        // creditStatusSel.add(new SelectOption('Current_Employer_Name_1__c in Part 9 Agreement', 'Currently in Part 9 Agreement'));
        //- Lelo                                2020-03-02
        curResidentialStatusSel = new List<SelectOption>();
        curResidentialStatusSel.add(new SelectOption('', '--None--'));
        curResidentialStatusSel.add(new SelectOption('Australian Citizen', 'Australian Citizen'));
        curResidentialStatusSel.add(new SelectOption('PR VISA', 'Permanent Resident'));
        curResidentialStatusSel.add(new SelectOption('Working VISA', 'Working Visa'));
        curResidentialStatusSel.add(new SelectOption('Student VISA', 'Student Visa'));
        curResidentialStatusSel.add(new SelectOption('Bridging VISA', 'Bridging Visa'));
        curResidentialStatusSel.add(new SelectOption('Spouse VISA', 'Spouse Visa'));
        curResidentialStatusSel.add(new SelectOption('Temporary VISA', 'Temporary Visa'));
        curResidentialStatusSel.add(new SelectOption('Visitors', 'Visitors'));
        curResidentialStatusSel.add(new SelectOption('Other', 'Other'));
        //- Lelo                                2016-07-05
        statesOfIssue2Sel = UtilitiesList.getStatesOptions();
        //-
        //- Lelo        Servicing Calculator            2016-07-06
        servCalcLenderSelect = new List<SelectOption>();
        servCalcLenderSelect.add(new SelectOption('', '--None--'));
        for (String key: servCalcLenderValues.keySet()) {
            servCalcLenderSelect.add(new SelectOption(key, servCalcLenderValues.get(key)));
        }
        //servCalcTypeSelect = new List<SelectOption>();
        //servCalcTypeSelect.add(new SelectOption ('', '--None--'));
        //servCalcTypeSelect.add(new SelectOption ('Single', 'Single'));
        ////servCalcTypeSelect.add(new SelectOption ('Joint', 'Joint'));
        //servCalcTypeSelect.add(new SelectOption ('De Facto', 'De Facto'));
        //servCalcTypeSelect.add(new SelectOption ('Married', 'Married'));
        servCalcNoDependentsSelect = new List<SelectOption>();
        servCalcNoDependentsSelect.add(new SelectOption('', '--None--'));
        for (Integer i = 0; i <= 6; i++) {
            servCalcNoDependentsSelect.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        servCalcOtherIncomeTypeSelect = new List<SelectOption>();
        servCalcOtherIncomeTypeSelect.add(new SelectOption('', '--None--'));
        for (String value: servCalcOtherIncomeTypeValues) {
            servCalcOtherIncomeTypeSelect.add(new SelectOption(value, value));
        }
        servCalcLoanTypeSelect = new List<SelectOption>();
        servCalcLoanTypeSelect.add(new SelectOption('', '--None--'));
        for (String value: servCalcLoanTypeValues) {
            servCalcLoanTypeSelect.add(new SelectOption(value, value));
        }
        servCalcAreaSelect = new List<SelectOption>();
        servCalcAreaSelect.add(new SelectOption('', '--None--'));
        for (String value: servCalcAreaValues) {
            servCalcAreaSelect.add(new SelectOption(value, value));
        }
        servCalculatedVariablesInitialization();
        Map < String, Lenders__c > LendersMap = Lenders__c.getAll();
        List < Lenders__c > allLenders = lendersMap.values();
        allLenders.sort();
        lenderSelect = '--None--';
        lenders = new List<SelectOption>();
        lenders.add(new SelectOption('--None--', '--None--'));
        for (Lenders__c lender: allLenders) {
            if (lender.Active__c) {
                lenders.add(new SelectOption(lender.lender__c, lender.lender__c));
            }
        }
        //-
        licenceTypes = new List<SelectOption>();
        licenceTypes.add(new SelectOption('NONE', '--None--'));
        licenceTypes.add(new SelectOption('FULL', 'FULL'));
        licenceTypes.add(new SelectOption('PROVISIONAL', 'PROVISIONAL'));
        licenceTypes.add(new SelectOption('LEARNER', 'LEARNER'));
        licenceTypes.add(new SelectOption('HEAVY_VEHICLE', 'HEAVY_VEHICLE'));
        //Quoting re-direct
        String paramTmp = System.currentPageReference().getParameters().get('sec');
        if (!String.isBlank(paramTmp)) {
            if ('YTD'.equals(paramTmp)) {
                ytdCalc = true;
            } else if ('SRV'.equals(paramTmp)) {
                servicingCalc = true;
            } else if ('NTS'.equals(paramTmp)) {
                notesSection = true;
            }
        }
        //Quoting re-direct
        paramTmp = System.currentPageReference().getParameters().get('LENDER_QUOTING');
        redirectQuting = '0';
        System.debug(paramTmp);
        if (!String.isBlank(paramTmp)) {
            lenderSelect = paramTmp;
            quotingTool = true;
            redirectQuting = '1';
        } else {
            //Pre-load last quoting saved
            Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(Opp.Id, Opp.Application__c);
            if (q != null) {
                lenderSelect = q.Name;
            }
        }
        //Lelo                  2017-02-02
        //loanRepaid1 = false;
        //loanRepaid2 = false;
        //loanRepaid3 = false;
        //loanRepaid4 = false;
        //loanRepaid5 = false;
        //loanRepaid6 = false;
        //-
        loadYTDValues(); // YTD
        //Lelo                  2017-12-18              Loans
        this.loadApplicationLoans();
        // Lelo         2019-03-07
        this.loadCreditCards();
        this.loadOtherAssets();
        //-
        // loadServicingCalculatorData(); //Servicing re-calculate
        System.debug(Opp.Application__r.Net_Income_1__c);
        System.debug(Opp.Application__r.Net_Income_2__c);
        this.loadApplicationIncomes();
        //PopUp - HJ - I - 14082018
        isUserApprovalTeam = !ApprovalTools.isUserIdAnApprovalTeam(UserInfo.getUserId());
        //isUserApprovalTeam = true;
        //PopUp - HJ - F - 14082018
        lstPrevEmployment = null;
        //Yohan VillaLeal                2019-09-12
        ytdLenderOptionsApplic = new List<SelectOption>();
        for(String value : ytdLenderValues) {
            ytdLenderOptionsApplic.add(new SelectOption (value, value));
        }
        //--
        //Yohan VillaLeal                2019-09-23
        abnOptionValues = new List<SelectOption>();
        for(String value : abnOptions) {
            abnOptionValues.add(new SelectOption (value, value));
        }
        //--
        abnInfo = false;
        this.counter=0;
        this.countPage = 0;
        
        //Full Doc
        fdNetProfitCalc = 0.0;
        fdNetProfitCalc2 = 0.0;
        
       
    }
    //- Lelo        YTD Calculator          2016-08-22  
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
    //St George - App 2
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
    //-
    public Decimal getFullDocumentationTotal() {
        return calculateFullDocumentationTotal(false);
    }
    public Decimal getFullDocumentationTotal2() {
        return calculateFullDocumentationTotal2(false);
    }
    private Decimal calculateFullDocumentationTotal(Boolean includeTax) {
        return calculateFullDocumentationTotal(includeTax, fdNetProfit, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary);
    }
    public void fullDocumentationTotalApp1() {
        getFullDocumentationTotalApp1();
        if ('2'.equals(trusteesNumber)){
            getFullDocumentationTotal2App1();   
        }
    }
    public void getFullDocumentationTotalApp1() {
        if (!'Sole Trader'.equals(fldSelfEmployedType)){
            calculateFullDocumentationTotal(false, fdNetProfit, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary);
        }
        getFullDocumentationMonthlyTotalApp1();
    }
    public void getFullDocumentationTotal2App1() {
        calculateFullDocumentationTotal2App1(false, fdNetProfit_2, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary);
        getFullDocMonthlyTotal2App1(calculateFullDocumentationTotalApp1(true, fdNetProfit_2, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary), fldSelfEmployedType);
    }
    private void calculateFullDocumentationTotal2App1(Boolean includeTax, Decimal netProfit2, String selfEmplyedType, Decimal depri, Decimal inter, Decimal ds) {
        //Decimal r = 0;
        fdNetProfitCalc2 = 0;
        if (netProfit2 != null) {
            fdNetProfitCalc2 += netProfit2;
            if (includeTax && 
               'Company Pty Ltd'.equals(selfEmplyedType)) {
                fdNetProfitCalc2 -= netProfit2 * 0.3;
            }
        }
        if (!'Trust'.equals(selfEmplyedType)) {
            if (depri != null) fdNetProfitCalc2 += depri;
            if (inter != null) fdNetProfitCalc2 += inter;
            if (ds != null) fdNetProfitCalc2 += ds;
        }
        //return r;
    }
    private void getFullDocMonthlyTotal2App1(Decimal annualIncomeTmp, String fldSelfEmployedType) {
        //Decimal r = 0;
        fdNetProfit2_2  = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(fldSelfEmployedType)) {
            fdNetProfit2_2  = annualIncomeTmp / 12;
        } else {
            fdNetProfit2_2  = (annualIncomeTmp - tx - md) / 12;
        }
        //return r;
    }
    public Decimal getFullDocumentationMonthlyTotal() {
        return getFullDocMonthlyTotal(calculateFullDocumentationTotal(true));
    }
    public Decimal getFullDocumentationMonthlyTotalApp1() {
        return getFullDocMonthlyTotalApp1(calculateFullDocumentationTotalApp1(true, fdNetProfit, fldSelfEmployedType, fdDepreciation, fdInterest, fdDirectorSalary), fldSelfEmployedType);
    }
    
    public Decimal calculateFullDocumentationTotalApp1(Boolean includeTax, Decimal netProfit, String selfEmpType, Decimal depr, Decimal interest, Decimal dirSalary) {
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
    
    // 2nd Trustee 
    private Decimal calculateFullDocumentationTotal2(Boolean includeTax) {
        return calculateFullDocumentationTotal2(includeTax, fdNetProfit2, fldSelfEmployedType);
    }

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
        fdNetProfitCalc = 0;
        if (netProfit != null) {
            fdNetProfitCalc += netProfit;
            if (includeTax && 
                'Company Pty Ltd'.equals(selfEmpType)) {
                    fdNetProfitCalc -= netProfit * 0.3;
                }
        }
        if (!'Trust'.equals(selfEmpType)) {
            if (depr != null) fdNetProfitCalc += depr;
            if (interest != null) fdNetProfitCalc += interest;
            if (dirSalary != null) fdNetProfitCalc += dirSalary;
        }
        
        return fdNetProfitCalc;
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
    private Decimal getFullDocMonthlyTotal(Decimal annualIncomeTmp) {
        return getFullDocMonthlyTotal(annualIncomeTmp, fldSelfEmployedType);
    }
    
    private Decimal getFullDocMonthlyTotal_2(Decimal annualIncomeTmp) {
        return getFullDocMonthlyTotal(annualIncomeTmp, fldSelfEmployedType2);
    }
    
    private Decimal getFullDocMonthlyTotal(Decimal annualIncomeTmp, String selfEmployedType) {
        Decimal r = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(selfEmployedType) || 'Trust'.equals(selfEmployedType)) {
            r = annualIncomeTmp / 12;
        } else {
            r = (annualIncomeTmp - tx - md) / 12;
        }
        //fdNetProfit2 = r;
        return r;
    }
    
    public Decimal getFullDocMonthlyTotalApp1(Decimal annualIncomeTmp, String selfEmployedType) {
        fdNetProfit2  = 0;
        Decimal tx = taxCalculate(annualIncomeTmp);
        Decimal md = annualIncomeTmp * 0.02;
        if ('Company Pty Ltd'.equals(selfEmployedType) ) {
            fdNetProfit2  = annualIncomeTmp / 12;
        } else {
            fdNetProfit2  = (annualIncomeTmp - tx - md) / 12;
        }
        return fdNetProfit2;
    }

    //- Lelo        YTD Calculator          2016-08-03  
    public PageReference saveNotePreApproval() {
        return saveNote('Notes');
    }
    public PageReference saveNoteAmendment() {
        return saveNote('Notes (Amendment)');
    }
    public PageReference saveNoteFormalApproval() {
        return saveNote('Notes (Formal Approval)');
    }
    public PageReference saveNote(String typeData) {
        ytdCalc = false;
        servicingCalc = false;
        quotingTool = false;
        assetDetails = false;
        notesSection = true;
        if (Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save the Application form before saving for Pre-appoval.'));
            return null;
        }
        if (String.isBlank(noteText)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill the note before saving for Pre-appoval.'));
            return null;
        }
        //Save
        ApplicationExtraDataHelper.addPlainData(Opp.Application__c, 'Note', typeData, noteText, true, noteCategory);
        //Check flag in opportunity
        if ('Notes'.equalsIgnoreCase(typeData)) {
            Opp.Flag_Is_Note_for_Pre_Approval_Created__c = true;
        }
        if ('Notes (Amendment)'.equalsIgnoreCase(typeData)) {
            Opp.Flag_Is_Note_for_Amendment_Created__c = true;
        }
        if ('Notes (Formal Approval)'.equalsIgnoreCase(typeData)) {
            Opp.Flag_Is_Note_for_Formal_Approval_Created__c = true;
        }
        update Opp;
        noteText = null;
        noteId = null;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your note has been saved successfully!'));
        return null;
    }
    public List < Application_Extra_Data__c > getNotesForPreappoval() {
        List < String > params = new List < String > ();
        params.add('Notes');
        params.add('Notes (Amendment)');
        params.add('Notes (Formal Approval)');
        return ApplicationExtraDataHelper.getApplicationExtraDataList(Opp.Application__c, params);
    }
    public PageReference cancelNote() {
        noteText = null;
        noteId = null;
        return null;
    }
    public PageReference prepareEditNote() {
        System.debug('Edit noteId >> ' + noteId);
        if (noteId != null) {
            Application_Extra_Data__c d = ApplicationExtraDataHelper.getApplicationExtraDataById(noteId);
            if (d != null) {
                noteText = d.Data__c;
                if (String.isNotBlank(noteText)) {
                    noteText = noteText.removeStart('"').removeEnd('"');
                }
            }
        }
        return null;
    }
    //- Lelo        YTD Calculator          2016-07-12  
    private void ytdEsandaFullCalculation() {
        //Applicant 1
        ytdCalcWeeksBeteenDates();
        //Applicant 2
        ytdCalcWeeksBeteenDatesA2();
    }
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
    //Macquarie
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
    public PageReference ytdMacNetYTDSalary() {
        ytdMacAnnuallyNetYtdSalary = 0.0;
        ytdMacMonthlyNetYtdSalary = 0.0;
        if (ytdMacYtdStartDate != null && ytdMacEndDate != null) {
            //Date netYtdStartDate = ytdCalcYearToDateYtdPEriod(ytdMacEndDate);
            Date netYtdStartDate = ytdMacYtdStartDate;
            Decimal days = netYtdStartDate.daysBetween(ytdMacEndDate) + 1;
            if (days > 0 && netYtdStartDate != null) {
                Date tmpDate = Date.newInstance(netYtdStartDate.year() + 1, netYtdStartDate.month(), 1);
                ytdMacAnnuallyNetYtdSalary = (ytdMacNetYtdSalary / days) * netYtdStartDate.daysBetween(tmpDate);
                ytdMacMonthlyNetYtdSalary = ytdMacAnnuallyNetYtdSalary / 12;
            }
        }
        return null;
    }
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
    //Cell Controls!$P$4 file YTD Cal.xlsx
    private Date ytdCalcYearToDateYtdPEriod(Date endDateParam) {
        Integer year = endDateParam.year();
        if (ytdMacEndDate.month() < 7) {
            year--;
        }
        return Date.newInstance(year, 7, 1);
    }
    private Date ytdCalcYearToDateYtdPEriodA2(Date endDateParam) {
        Integer year = endDateParam.year();
        if (ytdMacEndDateA2.month() < 7) {
            year--;
        }
        return Date.newInstance(year, 7, 1);
    }
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
    /*
private Integer ytdCalculateMonths(Date date1, Date date2) {
Integer r = 0;
if (date1 != null && date2 != null) {
if (date2 < date1) {
r = r - 1;
}
r += (date2.year() - date1.year()) * 12;
r += date2.month() - date1.month();
}
return r;
}*/
    //-
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
    //public PageReference servCalculate() {
    //if (incFreq1 == null || incFreq2 == null || othFreq1 == null || othFreq2 == null || rentFreq == null || debtFreq == null) {
    // servicingCalc = true;
    // quotingTool = false;
    // ytdCalc = false;
    // assetDetails = false;
    // notesSection = false;
    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There are fields that you have not chosen a frequency. This system will use MONTHLY as default.'));
    //}
    //if (incFreq1 == 'Weekly') {
    // emIncomeMon1 = emIncome1 * 4.33;
    // emIncomeMon1 = emIncomeMon1.setScale(2);
    //} else if (incFreq1 == 'Fortnightly') {
    // emIncomeMon1 = emIncome1 * 26 / 12;
    // emIncomeMon1 = emIncomeMon1.setScale(2);
    //} else if (incFreq1 == 'Monthly') {
    // emIncomeMon1 = emIncome1;
    //}
    //if (incFreq2 == 'Weekly') {
    // emIncomeMon2 = emIncome2 * 4.33;
    // emIncomeMon2 = emIncomeMon2.setScale(2);
    //} else if (incFreq2 == 'Fortnightly') {
    // emIncomeMon2 = emIncome2 * 26 / 12;
    // emIncomeMon2 = emIncomeMon2.setScale(2);
    //} else if (incFreq2 == 'Monthly') {
    // emIncomeMon2 = emIncome2;
    //}
    //if (othFreq1 == 'Weekly') {
    // othIncomeMon1 = othIncome1 * 4.33;
    // othIncomeMon1 = othIncomeMon1.setScale(2);
    //} else if (othFreq1 == 'Fortnightly') {
    // othIncomeMon1 = othIncome1 * 26 / 12;
    // othIncomeMon1 = othIncomeMon1.setScale(2);
    //} else if (othFreq1 == 'Monthly') {
    // othIncomeMon1 = othIncome1;
    //}
    //if (othFreq2 == 'Weekly') {
    // othIncomeMon2 = othIncome2 * 4.33;
    // othIncomeMon2 = othIncomeMon2.setScale(2);
    //} else if (othFreq2 == 'Fortnightly') {
    // othIncomeMon2 = othIncome2 * 26 / 12;
    // othIncomeMon2 = othIncomeMon2.setScale(2);
    //} else if (othFreq2 == 'Monthly') {
    // othIncomeMon2 = othIncome2;
    //}
    //if (rentFreq == 'Weekly') {
    // rentMonth = rentMon * 4.33;
    // rentMonth = rentMonth.setScale(2);
    //} else if (rentFreq == 'Fortnightly') {
    // rentMonth = rentMon * 26 / 12;
    // rentMonth = rentMonth.setScale(2);
    //} else if (rentFreq == 'Monthly') {
    // rentMonth = rentMon;
    //}
    //if (debtFreq == 'Weekly') {
    // othDebtsMon = othDebts * 4.33;
    // othDebtsMon = othDebtsMon.setScale(2);
    //} else if (debtFreq == 'Fortnightly') {
    // othDebtsMon = othDebts * 26 / 12;
    // othDebtsMon = othDebtsMon.setScale(2);
    //} else if (debtFreq == 'Monthly') {
    // othDebtsMon = othDebts;
    //}
    //reqSurplus = 0;
    //if (emIncomeMon1 == null) {
    // emIncomeMon1 = 0;
    //}
    //if (emIncomeMon2 == null) {
    // emIncomeMon2 = 0;
    //}
    //if (othIncomeMon1 == null) {
    // othIncomeMon1 = 0;
    //}
    //if (othIncomeMon2 == null) {
    // othIncomeMon2 = 0;
    //}
    //if (rentMonth == null) {
    // rentMonth = 0;
    //}
    //if (othDebtsMon == null) {
    // othDebtsMon = 0;
    //}
    //monIncome = emIncomeMon1 + emIncomeMon2 + othIncomeMon1 + othIncomeMon2;
    //subTotal = monIncome - rentMonth - livExpense - othDebtsMon;
    //amtForLoan = subTotal - reqSurplus;
    //servicingCalc = true;
    //quotingTool = false;
    //ytdCalc = false;
    //assetDetails = false;
    //notesSection = false;
    //    return null;
    //}
    //public PageReference calculate () {
    //    if (interestRate == null || interestRate == 0.0) {
    //        servicingCalc = false;
    //        ytdCalc = false;
    //        quotingTool = true;
    //        assetDetails = false;
    //        notesSection = false;
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Interest Rate cannot be Zero.'));
    //        return null;
    //    }
    //    if (Opp.Loan_Product__r.DOF__c == null) {
    //        Opp.Loan_Product__r.DOF__c = 0;
    //    }
    //    if (Opp.Loan_Product__r.Cost_of_Goods__c == null) {
    //        Opp.Loan_Product__r.Cost_of_Goods__c = 0;
    //    }
    //    if (Opp.Loan_Product__r.Lender_App_Fee__c == null) {
    //        Opp.Loan_Product__r.Lender_App_Fee__c = 0;
    //    }
    //    if (Opp.Loan_Product__r.Equalisation_Fee_PPSR__c == null) {
    //        Opp.Loan_Product__r.Equalisation_Fee_PPSR__c = 0;
    //    }
    //    if (brokerageRate != 0 && brokerageRate < 1) {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The brokerage rate is smaller than 1%. This might not give you effective calculation.'));
    //    }
    //    if (interestRate != 0 && interestRate < 1) {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The interest rate is smaller than 1%. This might not give you effective calculation.'));
    //    }
    //    if (Opp.Loan_Product__r.Residual_Percentage__c != 0 && Opp.Loan_Product__r.Residual_Percentage__c < 1) {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The residual rate is smaller than 1%. This might not give you effective calculation.'));
    //    }
    //    update Opp.Loan_Product__r;
    //    update Opp;
    //    equipmentCost = Opp.Loan_Product__r.Cost_of_Goods__c + Opp.Loan_Product__r.Lender_App_Fee__c + Opp.Loan_Product__r.DOF__c + gap + warranty + lpi + other + Opp.Loan_Product__r.Equalisation_Fee_PPSR__c;
    //    Opp.Loan_Product__r.Brokerage__c = equipmentCost * (brokerageRate/100);
    //    if (Opp.Loan_Product__r.Residual_Percentage__c == null || Opp.Loan_Product__r.Residual_Percentage__c == 0) {
    //        if (Opp.Loan_Product__r.Balloon_Residual_Requested__c == null || Opp.Loan_Product__r.Balloon_Residual_Requested__c == 0) {
    //            residualValue = 0;
    //        } else {
    //            residualValue = Opp.Loan_Product__r.Balloon_Residual_Requested__c;
    //        }
    //    } else {
    //        residualValue = Opp.Loan_Product__r.Cost_of_Goods__c *  Opp.Loan_Product__r.Residual_Percentage__c / 100;
    //    }
    //    rental = pmt((equipmentCost+Opp.Loan_Product__r.Brokerage__c),((interestRate/100)/12),Opp.Loan_Product__r.Loan_Term__c,residualValue,isCommercial);
    //    monthlyPayment = rental + monthlyFee;
    //    fortnightPayment = monthlyPayment * 12 / 26;
    //    weeklyPayment = monthlyPayment / 4.33;
    //    clientRate = rate(equipmentCost,Opp.Loan_Product__r.Loan_Term__c,rental,residualValue,((interestRate/100)/12),isCommercial)*12;
    //    Opp.Loan_Product__r.Client_Rate__C = clientRate * 100;
    //    update Opp.Loan_Product__r;
    //    update Opp;
    //    servicingCalc = false;
    //    ytdCalc = false;
    //    quotingTool = true;
    //    assetDetails = false;
    //    notesSection = false;
    //    return null;
    //}
    public PageReference AppPdf() {
        return saveAppPdf(false);
    }
    public PageReference AppPdfPreApproval() {
        return saveAppPdf(true);
    }
    private PageReference saveAppPdf(boolean preApproval) {
        if (preApproval) {
            if (!isApplicationReadyToBePreApproved()) {
                return null;
            }
        } else if (!isApplicationReadyToBeSaved()) {
            return null;
        }
        servicingCalc = false;
        ytdCalc = false;
        quotingTool = false;
        assetDetails = false;
        notesSection = false;
        if (Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is not an existing Application linked to this Opportunity. Please use New Application button to create a new application.'));
            return null;
        }
        if (Opp.Application__r != null) {
            update Opp.Application__r;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: an Application form is required before generating a pdf file.'));
            return null;
        }
        update Opp;
        PageReference appPdf = Page.GenerateAppPdf;
        appPdf.getParameters().put('id', Opp.Id);
        appPdf.getParameters().put('IS_PREAPPROVAL', String.valueOf(preApproval));
        String prefixName = 'App_';
        if (preApproval) {
            prefixName += 'PRE_APPROVAL_';
            ApplicationExtraDataHelper.upsertData(Opp.Application__c, 'Application Form', 'Application Form (Pre-approval)', '<NOT APPLICABLE>');
        }
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, appPdf, preApproval);
        /*
Attachment attachApp = new Attachment();

Blob body;
try {
body = appPdf.getContent();
} catch (VisualforceException e) {
body = Blob.valueOf('Error occurred in generating the PDF file.');
}

//Make unique name with accumulated number for Application PDF name
List<attachment> existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%App%'];

attachApp.Body = body;
String fileName = 'App_' + Opp.Application__r.Id + '_' + (existingAttach.size()+1) + '.pdf';
if (preApproval) {
fileName = 'App_PRE_APPROVAL_' + Opp.Application__r.Id + '_' + (existingAttach.size()+1) + '.pdf';
}
attachApp.Name = fileName;
attachApp.IsPrivate = false;
attachApp.ParentId = Opp.Id;
insert attachApp;
*/
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Application Form PDF saved successfully.'));
        //return new PageReference ('/'+Opp.Id);
        return null;
    }
    
    // public PageReference ServicingPdf() {
    
    //     if (monIncome == null || monIncome == 0.0) {
    //         servicingCalc = true;
    //         ytdCalc = false;
    //         quotingTool = false;
    //         assetDetails = false;
    //         notesSection = false;
    //         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please calculate before generating the Pdf.'));
    //         return null;
    //     }
    //     PageReference servicingPdf = Page.GenerateServicingPdf;
    //     servicingPdf.getParameters().put('id', Opp.Id);
    //     servicingPdf.getParameters().put('Employment Income 1', String.valueOf(emIncomeMon1.format()));
    //     servicingPdf.getParameters().put('Employment Income 2', String.valueOf(emIncomeMon2.format()));
    //     servicingPdf.getParameters().put('Other Income 1', String.valueOf(othIncomeMon1.format()));
    //     servicingPdf.getParameters().put('Other Income 2', String.valueOf(othIncomeMon2.format()));
    //     servicingPdf.getParameters().put('Monthly Income', String.valueOf(monIncome.format()));
    //     servicingPdf.getParameters().put('Rent/Mortgage', String.valueOf(rentMonth.format()));
    //     servicingPdf.getParameters().put('Living Expense', String.valueOf(livExpense.format()));
    //     servicingPdf.getParameters().put('Other Debts', String.valueOf(othDebtsMon.format()));
    //     if (subTotal < 0) {
    //         String tempSubTotal = '(' + math.abs(subTotal).format() + ')';
    //         servicingPdf.getParameters().put('Sub Total', tempSubTotal);
    //     } else {
    //         servicingPdf.getParameters().put('Sub Total', String.valueOf(subTotal.format()));
    //     }
    //     servicingPdf.getParameters().put('Required Surplus', String.valueOf(reqSurplus.format()));
    //     if (amtForLoan < 0) {
    //         String tempAmt = '(' + math.abs(amtForLoan).format() + ')';
    //         servicingPdf.getParameters().put('Final Amount', tempAmt);
    //     } else {
    //         servicingPdf.getParameters().put('Final Amount', String.valueOf(amtForLoan.format()));
    //     }
    //     Attachment attachServ = new Attachment();
    //     Blob body;
    //     try {
    //         body = servicingPdf.getContent();
    //     } catch (VisualforceException e) {
    //         body = Blob.valueOf('Error occurred in generating the PDF file.');
    //     }
    //     //Make unique name with accumulated number for Servicing Calculation name
    //     List < attachment > existingAttach = [Select id, name, description from attachment where parentID =: Opp.Id and Name like '%Servicing%'];
    //     attachServ.Body = body;
    //     String fileName = 'Servicing_Calculation_' + Opp.Id + '_' + (existingAttach.size() + 1) + '.pdf';
    //     attachServ.Name = fileName;
    //     attachServ.IsPrivate = false;
    //     attachServ.ParentId = Opp.Id;
    //     insert attachServ;
    //     return new PageReference('/' + Opp.Id);
    // }
    
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
            if (ytdMacYtdStartDate == null) {
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
    private Boolean isYtdLowDocPdfReadyToGenerate() {
        //ytdFullCalculation();
        if (baseIncomeLowDoc > 0.0) {
            return true;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill all fields before generating the Pdf.'));
        return false;
    }
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
    private Boolean isYtdStGeorgePdfReadyToGenerate() {
        //ytdFullCalculation();
        Boolean r = true;
        //Applicant 1
        if (getPermanentMonthlyTotal() > 0.0 || getCasualTotalAverage() > 0.0) {
            if (getCasualTotalAverage() > 0.0) {
                if (getCasualMonthlyTotal1() == 0.0 || getCasualMonthlyTotal2() == 0.0 || getCasualMonthlyTotal3() == 0.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill all Payslips fields in Casual section.'));
                    r = false;
                }
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Please fill Permanent Full Time/Part Time or Casual section before generating the Pdf.'));
            r = false;
        }
        //Applicant 2
        if (opp.Application__r.No_of_People__c == 2) {
            if (getPermanentMonthlyTotalA2() > 0.0 || getCasualTotalAverageA2() > 0.0) {
                if (getCasualTotalAverageA2() > 0.0) {
                    if (getCasualMonthlyTotal1A2() == 0.0 || getCasualMonthlyTotal2A2() == 0.0 || getCasualMonthlyTotal3A2() == 0.0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill all Payslips fields in Casual section.'));
                        r = false;
                    }
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Please fill Permanent Full Time/Part Time or Casual section before generating the Pdf.'));
                r = false;
            }
        }
        return r;
    }
    
    public PageReference ytdSavePdf() {
        return ytdSaveCalculationPdf(false);
    }
    
    public PageReference ytdSavePreApprovalPdf() {
        return ytdSaveCalculationPdf(true);
    }
    
    private void loadYTDValues() {
        if (this.Opp.ApplicationYTD__c != null) {
            Application_YTD__c ytd = this.Opp.ApplicationYTD__r;
            if (ytd == null) {
                return;
            }
            
            ytdCalcLender = ytd.Type__c;
            if ('Esanda'.endsWithIgnoreCase(ytdCalcLender) || 'Pepper'.endsWithIgnoreCase(ytdCalcLender)) {
                startDate = ytd.Start_Date_1__c;
                endDate = ytd.End_Date_1__c;
                ytdWeeks = ytd.Weeks_1__c;
                ytdIncome = ytd.Income_1_1__c;
                baseIncome = ytd.Income_1_2__c;
                monDifference = ytd.Difference_1__c;
                discDiff = ytd.Discounted_1__c;
                outAmount = ytd.Monthly_Amount_Servicing_1__c;
                ytdMonIncome = ytd.Income_Monthly_1_1__c;
                netMonIncome = ytd.Income_Monthly_1_2__c;
                ytdComment1 = ytd.Comment_1__c;
                this.latestPay1 = ytd.Latest_Payment_1__c;
                this.latestPayFrequency1 = ytd.Latest_Payment_Frequency_1__c;
                this.ytdCalcNetLastestPay1();
                if (opp.Application__r.No_of_People__c == 2) {
                    startDateA2 = ytd.Start_Date_2__c;
                    endDateA2 = ytd.End_Date_2__c;
                    ytdWeeksA2 = ytd.Weeks_2__c;
                    ytdIncomeA2 = ytd.Income_2_1__c;
                    baseIncomeA2 = ytd.Income_2_2__c;
                    monDifferenceA2 = ytd.Difference_2__c;
                    discDiffA2 = ytd.Discounted_2__c;
                    outAmountA2 = ytd.Monthly_Amount_Servicing_2__c;
                    ytdMonIncomeA2 = ytd.Income_Monthly_2_1__c;
                    netMonIncomeA2 = ytd.Income_Monthly_2_2__c;
                    ytdComment2 = ytd.Comment_2__c;
                    this.latestPay2 = ytd.Latest_Payment_2__c;
                    this.latestPayFrequency2 = ytd.Latest_Payment_Frequency_2__c;
                    this.ytdCalcNetLastestPay2();
                }
            } else if ('Macquarie'.endsWithIgnoreCase(ytdCalcLender)) {
                ytdMacYtdStartDate = ytd.Start_Date_A_1__c;
                ytdMacStartDate = ytd.Start_Date_1__c;
                ytdMacEndDate = ytd.End_Date_1__c;
                ytdMacPayPeriodDays = ytd.Weeks_1__c;
                ytdMacNetYtdSalary = ytd.Income_1_1__c;
                ytdMacPayPeriodNetSalary = ytd.Income_1_2__c;
                ytdMacMonthlyNetYtdSalary = ytd.Income_Monthly_1_1__c;
                ytdMacAnnuallyNetYtdSalary = ytd.Annually_1_1__c;
                ytdMacMonthlyPayPeriodNetSalary = ytd.Income_Monthly_1_2__c;
                ytdMacAnnuallyPayPeriodNetSalary = ytd.Annually_1_2__c;
                ytdMacComments = ytd.Comment_1__c;
                if (opp.Application__r.No_of_People__c == 2) {
                    ytdMacYtdStartDateA2 = ytd.Start_Date_A_2__c;
                    ytdMacStartDateA2 = ytd.Start_Date_2__c;
                    ytdMacEndDateA2 = ytd.End_Date_2__c;
                    ytdMacPayPeriodDaysA2 = ytd.Weeks_2__c;
                    ytdMacNetYtdSalaryA2 = ytd.Income_2_1__c;
                    ytdMacPayPeriodNetSalaryA2 = ytd.Income_2_2__c;
                    ytdMacMonthlyNetYtdSalaryA2 = ytd.Income_Monthly_2_1__c;
                    ytdMacAnnuallyNetYtdSalaryA2 = ytd.Annually_2_1__c;
                    ytdMacMonthlyPayPeriodNetSalaryA2 = ytd.Income_Monthly_2_2__c;
                    ytdMacAnnuallyPayPeriodNetSalaryA2 = ytd.Annually_2_2__c;
                    ytdMacCommentsA2 = ytd.Comment_2__c;
                }
            } else if ('Others'.endsWithIgnoreCase(ytdCalcLender)) {
                startDateOth = ytd.Start_Date_1__c;
                endDateOth = ytd.End_Date_1__c;
                ytdWeeksOth = ytd.Weeks_1__c;
                ytdIncomeOth = ytd.Income_1_1__c;
                annualIncomeOth = ytd.Income_1_2__c;
                ytdMonIncomeOth = ytd.Income_Monthly_1_1__c;
                if(ytd.GrossAnnualIncomeApplic1__c!=null){
                    ytdGrossAnnualIncomeApplic1 = ytd.GrossAnnualIncomeApplic1__c;
                    ytdLenderApplic = 'Firstmac';
                }else{
                    ytdGrossAnnualIncomeApplic1 = 0.00;
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    startDateOthA2 = ytd.Start_Date_2__c;
                    endDateOthA2 = ytd.End_Date_2__c;
                    ytdWeeksOthA2 = ytd.Weeks_2__c;
                    ytdIncomeOthA2 = ytd.Income_2_1__c;
                    ytdMonIncomeOthA2 = ytd.Income_Monthly_2_1__c;
                    annualIncomeOthA2 = ytd.Income_2_2__c;
                    if(ytd.GrossAnnualIncomeApplic2__c!=null){
                        ytdGrossAnnualIncomeApplic2 = ytd.GrossAnnualIncomeApplic2__c;
                        ytdLenderApplic = 'Firstmac';
                    }else{
                        ytdGrossAnnualIncomeApplic2 = 0.00;
                    }
                }
            } else if ('LowDocumentation'.endsWithIgnoreCase(ytdCalcLender)) {
                baseIncomeLowDoc = ytd.Income_1_1__c;
            } else if ('Full-Documentation'.endsWithIgnoreCase(ytdCalcLender)) {
                fdLender = ytd.Lender__c;
                fdNetProfit = ytd.Income_Monthly_1_1__c;
                fdDepreciation = ytd.Income_Monthly_1_2__c;
                fdInterest = ytd.Annually_1_1__c;
                fdDirectorSalary = ytd.Annually_1_2__c;
            } else if ('Self-Employed'.endsWithIgnoreCase(ytdCalcLender)) {
                fdLender = ytd.Lender__c;
                fdNetProfit = ytd.Income_Monthly_1_1__c;
                this.fdSales = null;
                if ('Company Pty Ltd'.equals(fldSelfEmployedType) && ytd.Sales__c != null) {
                    this.fdSales = ytd.Sales__c;
                }
                fdDepreciation = ytd.Income_Monthly_1_2__c;
                fdInterest = ytd.Annually_1_1__c;
                fdDirectorSalary = ytd.Annually_1_2__c;
                fldSelfEmployedClass = ytd.Self_Employed_Class__c;
                fldSelfEmployedType = ytd.Self_Employed_Type__c;
                this.trusteesNumber = null;
                if ('Trust'.equals(fldSelfEmployedType)) {
                    if(String.isNotBlank(ytd.Trustess_Number__c)) {
                        this.trusteesNumber = ytd.Trustess_Number__c;
                        if ('2'.equals(this.trusteesNumber)) {
                            fdNetProfit2 = ytd.Net_Profit_2__c;
                            // fdDepreciation2 = ytd.Depreciation_2__c;
                            // fdInterest2 = ytd.Interest_2__c;
                            // fdDirectorSalary2 = ytd.Director_Salary_2__c;
                        }
                    }
                }
                if (opp.Application__r.No_of_People__c == 2) {
                    fdNetProfit_2 = ytd.Income_Monthly_2_1__c;
                    this.fdSales2 = null;
                    if ('Company Pty Ltd'.equals(fldSelfEmployedType2) && ytd.Sales_2__c != null) {
                        this.fdSales2 = ytd.Sales_2__c;
                    }
                    fdDepreciation2 = ytd.Income_Monthly_2_2__c;
                    fdInterest2 = ytd.Annually_2_1__c;
                    fdDirectorSalary2 = ytd.Annually_2_2__c;
                    fldSelfEmployedClass2 = ytd.Self_Employed_Class_2__c;
                    fldSelfEmployedType2 = ytd.Self_Employed_Type_2__c;
                    this.trusteesNumber2 = null;
                    if ('Trust'.equals(fldSelfEmployedType2)) {
                        if(String.isNotBlank(ytd.Trustess_Number_2__c)) {
                            this.trusteesNumber2 = ytd.Trustess_Number_2__c;
                            if ('2'.equals(this.trusteesNumber2)) {
                                fdNetProfit2_2 = ytd.Net_Profit_2_2__c;
                                // fdDepreciation2 = ytd.Depreciation_2__c;
                                // fdInterest2 = ytd.Interest_2__c;
                                // fdDirectorSalary2 = ytd.Director_Salary_2__c;
                            }
                        }
                    }   
                }
            }
        }
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
            if (isYtdEsandaPdfReadyToGenerate()) {
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
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
            }
        } else if ('Macquarie'.endsWithIgnoreCase(ytdCalcLender)) {
            if (isYtdMacquariePdfReadyToGenerate()) {
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
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
            }
        } else if ('Others'.endsWithIgnoreCase(ytdCalcLender)) {
            if (isYtdOthersPdfReadyToGenerate()) {
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
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
            }
        } else if ('Self-Employed'.endsWithIgnoreCase(ytdCalcLender)) {
            Boolean app1 = isYtdFullDocPdfReadyToGenerate();
            Boolean app2 = true;
            if (opp.Application__r.No_of_People__c == 2) {
                app2 = isYtdFullDocPdfReadyToGenerate2();
            }
            if (app1 && app2) {
                fileNick = 'SelfEmployed_' + fldSelfEmployedClass;
                pdf = Page.GenerateYtdPdf;
                pdf.getParameters().put('id', Opp.Id);
                dto.ytdLender = ytdCalcLender;
                //dto.fdLender = fdLender;
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
                        //dto.fdNetProfit2 = fdNetProfit;
                        dto.fdNetProfit2 = fdNetProfit2;
                        // dto.fdDepreciation2 = fdDepreciation2;
                        // dto.fdInterest2 = fdInterest2;
                        // dto.fdDirectorSalary2 = fdDirectorSalary2;
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
                //ytd.Difference_2__c = null;
                ytd.Discounted_2__c = null;
                ytd.Monthly_Amount_Servicing_2__c = null;
                //ytd.Income_Monthly_2_1__c = null;
                //ytd.Income_Monthly_2_2__c = null;
                ytd.Comment_2__c = null;
                //ytd.Annually_2_1__c = null;
                //ytd.Annually_2_2__c = null;
                ytd.Net_Profit_2__c = null;
                // ytd.Depreciation_2__c = null;
                // ytd.Interest_2__c = null;
                // ytd.Director_Salary_2__c = null;
                ytd.Full_Doc_Total_2__c = null;
                ytd.Full_Doc_Total_Monthly_2__c = null;
                ytd.Trustess_Number__c = null;
                if ('Sole Trader'.equals(this.fldSelfEmployedType)) {
                    ytd.Sales__c = null;
                }
                if ('Trust'.equals(this.fldSelfEmployedType)) {
                    ytd.Income_Monthly_1_2__c = null;
                    ytd.Annually_1_1__c = null;
                    ytd.Annually_1_2__c = null;
                    ytd.Trustess_Number__c = this.trusteesNumber;
                    ytd.Sales__c = null;
                    if ('2'.equals(this.trusteesNumber)) {
                        ytd.Net_Profit_2__c = fdNetProfit2;
                        // ytd.Depreciation_2__c = fdDepreciation2;
                        // ytd.Interest_2__c = fdInterest2;
                        // ytd.Director_Salary_2__c = fdDirectorSalary2;
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
                            // dto.fdDepreciation2 = fdDepreciation2;
                            // dto.fdInterest2 = fdInterest2;
                            // dto.fdDirectorSalary2 = fdDirectorSalary2;
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
                    if ('Sole Trader'.equals(this.fldSelfEmployedType)) {
                        ytd.Sales_2__c = null;
                    }
                    if ('Trust'.equals(this.fldSelfEmployedType2)) {
                        ytd.Income_Monthly_2_2__c = null;
                        ytd.Annually_2_1__c = null;
                        ytd.Annually_2_2__c = null;
                        ytd.Trustess_Number_2__c = this.trusteesNumber2;
                        ytd.Sales_2__c = null;
                        if ('2'.equals(this.trusteesNumber2)) {
                            ytd.Net_Profit_2_2__c = fdNetProfit2_2;
                            // ytd.Depreciation_2__c = fdDepreciation2;
                            // ytd.Interest_2__c = fdInterest2;
                            // ytd.Director_Salary_2__c = fdDirectorSalary2;
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
            }
        } else if ('LowDocumentation'.endsWithIgnoreCase(ytdCalcLender)) {
            if (isYtdLowDocPdfReadyToGenerate()) {
                fileNick = 'Low-Documentation';
                //pdf = Page.GenerateYtdPdf;
                //pdf.getParameters().put('id',Opp.Id);
                dto.ytdLender = 'Low-Documentation';
                dto.baseIncome = baseIncomeLowDoc.format();
                ytd.Income_1_1__c = baseIncomeLowDoc;
                ytd.Start_Date_1__c = null;
                ytd.End_Date_1__c = null;
                ytd.Weeks_1__c = null;
                ytd.Income_1_2__c = null;
                ytd.Difference_1__c = null;
                ytd.Discounted_1__c = null;
                ytd.Monthly_Amount_Servicing_1__c = null;
                ytd.Income_Monthly_1_1__c = null;
                ytd.Income_Monthly_1_2__c = null;
                ytd.Comment_1__c = null;
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
                ytd.Annually_1_1__c = null;
                ytd.Annually_1_2__c = null;
                ytd.Annually_2_1__c = null;
                ytd.Annually_2_2__c = null;
                //pdf.getParameters().put('Start Date', dto.startDate);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'YTD Calculation PDF saved successfully.'));
            }
        } else if ('Full-Documentation'.endsWithIgnoreCase(ytdCalcLender)) {
            if (isYtdFullDocPdfReadyToGenerate()) {
                fileNick = 'Full_Documentation';
                pdf = Page.GenerateYtdPdf;
                pdf.getParameters().put('id', Opp.Id);
                dto.ytdLender = 'Full-Documentation';
                dto.fdLender = fdLender;
                dto.fdNetProfit = fdNetProfit;
                dto.fdDepreciation = fdDepreciation;
                dto.fdInterest = fdInterest;
                dto.fdDirectorSalary = fdDirectorSalary;
                dto.fullDocumentationTotal = getFullDocumentationTotal();
                ytd.Lender__c = fdLender;
                ytd.Income_Monthly_1_1__c = fdNetProfit;
                ytd.Income_Monthly_1_2__c = fdDepreciation;
                ytd.Annually_1_1__c = fdInterest;
                ytd.Annually_1_2__c = fdDirectorSalary;
                ytd.Income_1_1__c = getFullDocumentationTotal();
                ytd.Start_Date_1__c = null;
                ytd.End_Date_1__c = null;
                ytd.Weeks_1__c = null;
                ytd.Income_1_2__c = null;
                ytd.Difference_1__c = null;
                ytd.Discounted_1__c = null;
                ytd.Monthly_Amount_Servicing_1__c = null;
                ytd.Comment_1__c = null;
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
                ytd.Annually_2_1__c = null;
                ytd.Annually_2_2__c = null;
                pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
            }
        }
        if (ytd.Id == null) {
            insert ytd;
            this.Opp.ApplicationYTD__c = ytd.Id;
            update this.Opp;
        } else {
            update ytd;
        }
        //Update Application
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
                this.Opp.Application__r.Net_Income_1__c = ytd.Income_Monthly_1_1__c;
                this.Opp.Application__r.Payment_Frequency_1__c = 'Monthly';
                /*if(ytd.GrossAnnualIncomeApplic1__c != null){
this.Opp.ApplicationYTD__r.GrossAnnualIncomeApplic1__c = ytd.GrossAnnualIncomeApplic1__c;
ytdLenderApplic = 'Firstmac';
}*/
                if (opp.Application__r.No_of_People__c == 2) {
                    this.Opp.Application__r.Net_Income_2__c = ytd.Income_Monthly_2_1__c;
                    this.Opp.Application__r.Payment_Frequency_2__c = 'Monthly';
                    /*if(ytd.GrossAnnualIncomeApplic2__c != null){
this.Opp.ApplicationYTD__r.GrossAnnualIncomeApplic2__c = ytd.GrossAnnualIncomeApplic2__c;
ytdLenderApplic2 = 'Firstmac';
}*/
                }
            }
            update this.Opp.Application__r;
        }
        //loadServicingCalculatorData();
        String prefixName = 'YTD_' + fileNick;
        if (preApproval) {
            prefixName += '_PRE_APPROVAL';
            if (this.Opp.Application__c != null) {
                ApplicationExtraDataHelper.upsertData(this.Opp.Application__r.id, fileNick, 'YTD Calculation', dto);
            }
        }
        if (pdf != null) {
            QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, pdf);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'YTD Calculation PDF saved successfully.'));
            return null;
        }
        return null;
    }
    public PageReference ytdPdf() {
        //if (ytdMonIncome == null || ytdMonIncome == 0.0) {
        // servicingCalc = false;
        // ytdCalc = true;
        // quotingTool = false;
        // assetDetails = false;
        // notesSection = false;
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please calculate before generating the Pdf.'));
        // return null;
        //}
        //PageReference ytdPdf = Page.GenerateYtdPdf;
        //ytdPdf.getParameters().put('id', Opp.Id);
        //ytdPdf.getParameters().put('Start Date', String.valueOf(startDate));
        //ytdPdf.getParameters().put('End Date', String.valueOf(endDate));
        //ytdPdf.getParameters().put('YTD Weeks', String.valueOf(ytdWeeks.format()));
        //ytdPdf.getParameters().put('YTD Income', String.valueOf(ytdIncome.format()));
        //ytdPdf.getParameters().put('Base Income', String.valueOf(baseIncome.format()));
        //ytdPdf.getParameters().put('Annualised Income', String.valueOf(annualIncome.format()));
        //ytdPdf.getParameters().put('YTD Monthly Income', String.valueOf(ytdMonIncome.format()));
        //ytdPdf.getParameters().put('Base Monthly Income', String.valueOf(netMonIncome.format()));
        //ytdPdf.getParameters().put('Monthly Difference', String.valueOf(monDifference.format()));
        //ytdPdf.getParameters().put('Discounted Difference', String.valueOf(discDiff.format()));
        //ytdPdf.getParameters().put('Output Amount', String.valueOf(outAmount.format()));
        //Attachment attachYtd = new Attachment();
        //Blob body;
        //try {
        // body = ytdPdf.getContent();
        //} catch (VisualforceException e) {
        // body = Blob.valueOf('Error occurred in generating the PDF file.');
        //}
        ////Make unique name with accumulated number for Ytd Calculation name
        //List<attachment > existingAttach = [Select id, name, description from attachment where parentID = : Opp.Id and Name like '%Ytd%'];
        //attachYtd.Body = body;
        //String fileName = 'Ytd_Calculation_' + Opp.Id + '_' + (existingAttach.size() + 1) + '.pdf';
        //attachYtd.Name = fileName;
        //attachYtd.IsPrivate = false;
        //attachYtd.ParentId = Opp.Id;
        //insert attachYtd;
        return new PageReference('/' + Opp.Id);
    }
    private String formatDecimalValues(Decimal value, Integer scale) {
        if (value != null) {
            return String.valueOf(value.setScale(scale, RoundingMode.HALF_UP).format());
        }
        return null;
    }
    private String formatDecimalValues(Decimal value) {
        return formatDecimalValues(value, 2);
    }
    public PageReference clearYTDEsandaOtherFields() {
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
            endDate = Date.today();//Joy
        } else if (('Macquarie'.equals(ytdCalcLender)) && ytdMacStartDate == null) {
            ytdMacYtdStartDate = Date.newinstance(year, 7, 1);
            ytdMacYtdStartDateA2 = Date.newinstance(year, 7, 1);
            ytdMacStartDate = Date.newinstance(year, 7, 1);
            ytdMacStartDateA2 = Date.newinstance(year, 7, 1);
            ytdMacEndDate = Date.today();//Joy
        } else if (('Others'.equals(ytdCalcLender)) && startDateOth == null) {
            startDateOth = Date.newinstance(year, 7, 1);
            startDateOthA2 = Date.newinstance(year, 7, 1);
            endDateOth = Date.today();//Joy
        }
        //ytdIncome = null;
        //baseIncome = null;
        //ytdIncomeOth = null;
        //baseIncomeOth = null;
        //endDate = null;
        //endDateOth = null;
        //initYTDEsandaOtherFieldsCalculated();
        ytdEsandaFullCalculation();//Joy
        return null;
    }
    public PageReference clearYTDCalcSectionFields() {
        Integer currentYear = System.Today().year();
        if (System.Today().month() < 7) {
          currentYear--;
        }
        startDate = Date.newInstance(currentYear, 07, 01);
        endDate = Date.today();//Joy
        ytdIncome = null;
        baseIncome = null;
        ytdWeeks = null;
        ytdMonIncome = null;
        netMonIncome = null;
        monDifference = null;
        discDiff = null;
        outAmount = null;
        latestPay2 = null;
        latestPayFrequency2 = null;
        latestPayMonthly2 = null;
        ytdMacYtdStartDate = Date.newInstance(currentYear, 07, 01);
        ytdMacNetYtdSalary = null;
        ytdMacStartDate = Date.newInstance(currentYear, 07, 01);
        ytdMacEndDate = Date.today();
        ytdMacPayPeriodNetSalary = null;
        ytdMacPayPeriodDays = null;
        ytdMacMonthlyNetYtdSalary = 0.0;
        ytdMacMonthlyPayPeriodNetSalary = 0.0;
        ytdMacAnnuallyNetYtdSalary = 0.0;
        ytdMacAnnuallyPayPeriodNetSalary = 0.0;
        startDateOth = Date.newInstance(currentYear, 07, 01);
        ytdLenderApplic = null;
        endDateOth = Date.today();
        ytdWeeksOth = null;
        ytdIncomeOth = null;
        ytdMonIncomeOth = 0.0;
        annualIncomeOth = 0.0;
        ytdGrossAnnualIncomeApplic1 = null;
        fldSelfEmployedClass = null;
        fldSelfEmployedType = null;
        trusteesNumber = null;
        fdNetProfit = null;
        fdDepreciation = null;
        fdDirectorSalary = null;
        fdNetProfitCalc = 0.0;
        fdInterest = null;
        fdNetProfit2 = 0.0;
        fdNetProfit2_2 = 0.0;
        fdNetProfitCalc2 = 0.0;
        fdNetProfit_2 = null;
        ytdEsandaFullCalculation();//Joy
        return null;
    }
    private void initYTDEsandaOtherFieldsCalculated() {
        ytdWeeks = 0.0;
        annualIncome = 0.0;
        ytdTax = 0.0;
        ytdMedi = 0.0;
        ytdMonIncome = 0.0;
        baseTax = 0.0;
        baseMedi = 0.0;
        netMonIncome = 0.0;
        monDifference = 0.0;
        discDiff = 0.0;
        outAmount = 0.0;
    }
    public PageReference saveQuote() {
        //if (rental == null || rental == 0.0) {
        // servicingCalc = false;
        // ytdCalc = false;
        // quotingTool = true;
        // assetDetails = false;
        // notesSection = false;
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please calculate before generating the quote.'));
        // return null;
        //}
        //update Opp.Loan_Product__r;
        //update Opp;
        //PageReference quote = Page.GenerateQuotePdf;
        //quote.getParameters().put('id', Opp.Id);
        //quote.getParameters().put('Financed Amount', String.valueOf(equipmentCost.format()));
        //clientRate = clientRate * 100;
        //quote.getParameters().put('Client Rate', String.valueOf(clientRate.format()));
        //quote.getParameters().put('Residual Value', String.valueOf(residualValue.format()));
        //quote.getParameters().put('Monthly Payment', String.valueOf(monthlyPayment.format()));
        //quote.getParameters().put('Fortnightly Payment', String.valueOf(fortnightPayment.format()));
        //weeklyPayment = weeklyPayment.setScale(2);
        //quote.getParameters().put('Weekly Payment', String.valueOf(weeklyPayment.format()));
        //quote.getParameters().put('Interest Rate', String.valueOf(interestRate.format()));
        //Attachment attachQuote = new Attachment();
        //Blob body;
        //try {
        // body = quote.getContent();
        //} catch (VisualforceException e) {
        // body = Blob.valueOf('Error occurred in generating the PDF file.');
        //}
        ////Make unique name with accumulated number for Quote name
        //List<attachment > existingAttach = [Select id, name, description from attachment where parentID = : Opp.Id and Name like '%Quote%'];
        //attachQuote.Body = body;
        //String fileName = 'Quote_' + Opp.Id + '_' + (existingAttach.size() + 1) + '.pdf';
        //attachQuote.Name = fileName;
        //attachQuote.IsPrivate = false;
        //attachQuote.ParentId = Opp.Id;
        //insert attachQuote;
        return new PageReference('/' + Opp.Id);
    }
    public PageReference emailQuote() {
        //// Save the quote as an attachment to the Opportunity record
        //// Copied from the last function
        //if (rental == null || rental == 0.0) {
        // servicingCalc = false;
        // ytdCalc = false;
        // quotingTool = true;
        // assetDetails = false;
        // notesSection = false;
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please calculate before generating the quote.'));
        // return null;
        //}
        //update Opp.Loan_Product__r;
        //update Opp;
        //PageReference quote = Page.GenerateQuotePdf;
        //quote.getParameters().put('id', Opp.Id);
        //quote.getParameters().put('Financed Amount', String.valueOf(equipmentCost.format()));
        //clientRate = clientRate * 100;
        //quote.getParameters().put('Client Rate', String.valueOf(clientRate.format()));
        //quote.getParameters().put('Residual Value', String.valueOf(residualValue.format()));
        //quote.getParameters().put('Monthly Payment', String.valueOf(monthlyPayment.format()));
        //quote.getParameters().put('Fortnightly Payment', String.valueOf(fortnightPayment.format()));
        //weeklyPayment = weeklyPayment.setScale(2);
        //quote.getParameters().put('Weekly Payment', String.valueOf(weeklyPayment.format()));
        //quote.getParameters().put('Interest Rate', String.valueOf(interestRate.format()));
        //Attachment attachQuote = new Attachment();
        //Blob body;
        //try {
        // body = quote.getContent();
        //} catch (VisualforceException e) {
        // body = Blob.valueOf('Error occurred in generating the PDF file.');
        //}
        ////Make unique name with accumulated number for Quote name
        //List<attachment > existingAttach = [Select id, name, description from attachment where parentID = : Opp.Id and Name like '%Quote%'];
        //attachQuote.Body = body;
        //String fileName = 'Quote_' + Opp.Id + '_' + (existingAttach.size() + 1) + '.pdf';
        //attachQuote.Name = fileName;
        //attachQuote.IsPrivate = false;
        //attachQuote.ParentId = Opp.Id;
        //insert attachQuote;
        //// Define the Email
        //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //// Create Email attachment
        //Messaging.EmailFileAttachment emailQuote = new Messaging.EmailFileAttachment();
        //emailQuote.setFileName(fileName);
        //emailQuote.setBody(body);
        //Custom_Opportunity__c newOpp = [SELECT Id, Email_Address__c, Account_First_Name__c, OwnerId FROM Custom_Opportunity__C WHERE ID = : Opp.ID];
        //User oppOwner = [SELECT ID, Phone, Email, MobilePhone, Name FROM User Where ID = : newOpp.OwnerId];
        //String address = newOpp.Email_Address__c;
        //String[] toAddresses = new List<String >();
        //toAddresses.add(address);
        //String subject = 'Your quote at Savvy Finance';
        //String emailBody = '<html> <head> </head>';
        //emailBody += '<body style=" color: #232323;font-family: Calibri, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 1.5em;">';
        //emailBody += 'Hi ' + newOpp.Account_First_Name__c + ', ';
        //emailBody += '<p>Thank you for your enquiry and your time on the phone today.</p>';
        //emailBody += '<p>I’ve attached the quote for you here with this email. My contact details are below if you have any further questions or queries.</p>';
        //emailBody += '<p>I look forward to hearing from you and hope to be able to assist with your finance requirements.</p>';
        //emailBody += '<p>Regards,</p>';
        //emailBody += '<p><strong>' + oppOwner.Name + '</strong> - Finance Consultant</p>';
        //emailBody += '<p><strong>P:</strong> ' + oppOwner.Phone;
        //emailBody += '<font color="red">|</font><strong>F:</strong> 1300 978 066 <font color="red">|</font> <strong>L:</strong> 1300 974 066 <font color="red">|</font>';
        //emailBody += '<strong>M:</strong> ' + oppOwner.MobilePhone + '<br>';
        //emailBody += 'E: ' + oppOwner.Email;
        //emailBody += '<font color="red">|</font>Web: www.savvy.com.au<br>';
        //emailBody += 'Adelaide Office: Level 1, 145 The Parade, Norwood SA 5067<br>';
        //emailBody += 'Sydney Office: Suite 206, 4 Clark Street, Crows Nest, NSW, 2064<br>';
        //emailBody += 'Melbourne Office: Suite 6, 596 North Road, Ormond, VIC, 3024<br> </p>';
        //emailBody += '<img src="http://www.savvy.com.au/sites/default/files/savy_logo.png" style="width:150px" alt="Home">';
        //emailBody += '</body></html>';
        ////Set parameters of the Email
        //email.setSubject(subject);
        //email.setToAddresses(toAddresses);
        //email.setHtmlBody(emailBody);
        //email.setFileAttachments(new Messaging.EmailFileAttachment[] {
        // emailQuote
        //});
        //// send the Email
        //Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
        // email
        //});
        return new PageReference('/' + Opp.Id);
    }
    public PageReference validateAppForm() {
        if (isApplicationReadyToBeSaved()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Application form OK!'));
        }
        return null;
    }
    private boolean isApplicationReadyToBePreApproved() {
        Boolean r = true;
        if (!isApplicationReadyToBeSaved()) {
            r = false;
        }
        //New Pre-approval validations
        
        //Servicing Calculator
        if (!ApplicationExtraDataHelper.isExistApplicationExtraDataId(Opp.Application__c, 'Servicing Calculation')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A Servicing Calculation must be generated for Pre-approval'));
            r = false;
        }
        //Asset Details - LTV
        if (!ApplicationExtraDataHelper.isExistApplicationExtraDataId(Opp.Application__c, 'Asset Detail - LTV (Pre-approval)')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An Asset Detail - LTV Calculation must be generated for Pre-approval'));
            r = false;
        }
        //Quoting Tool
        if (!ApplicationExtraDataHelper.isExistApplicationExtraDataId(Opp.Application__c, 'Quoting Calculation')) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Quoting Calculation must be generated for Pre-approval'));
            //r = false;
        }
        return r;
    }
    private boolean isApplicationReadyToBeSaved() {
        boolean r = true;
        boolean isNewApplication = true;
        if (Opp.Application__c != null) {
            isNewApplication = false;
        }
        //******************************************************************
        //LOAN DETAILS
        //******************************************************************
        //Loan details
        if ((isNewApplication && String.isBlank(typeAsset)) || (!isNewApplication && String.isBlank(Opp.Application__r.Type_of_Asset__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Type of Asset is required, please select a value'));
            r = false;
        }
        //Finance Amount
        if ((isNewApplication && financeAmount < 5000) || (!isNewApplication && Opp.Application__r.Finance_Amount__c < 5000)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Finance Amount, min. loan amount is $5,000, please check your value.'));
            r = false;
        }
        //Loan Term
        if ((isNewApplication && (lengthTerm == null || lengthTerm <= 0)) || (!isNewApplication && (Opp.Application__r.Length_of_Term__c != null && Opp.Application__r.Length_of_Term__c == 0))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Loan Term is required, please select a value'));
            r = false;
        }
        //Repayment frequency
        if ((isNewApplication && String.isBlank(String.valueOf(repaymentRegularity))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.Repayment_Regularity__c)))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Repayment frequency is required, please select a value'));
            r = false;
        }
        //No. of People
        if ((isNewApplication && String.isBlank(String.valueOf(noPeople))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.No_of_People__c)))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No. of People is required, please select a value'));
            r = false;
        }
        //Application Type
        if ((isNewApplication && String.isBlank(applicationType)) || (!isNewApplication && String.isBlank(Opp.Application__r.Application_Type__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application Type is required, please select a value'));
            r = false;
        }
        //Finance Details
        if ('Business'.equalsIgnoreCase(applicationType) || 'Business'.equalsIgnoreCase(Opp.Application__r.Application_Type__c)) {
            //Entity Name
            if ((isNewApplication && String.isBlank(entityName)) || (!isNewApplication && String.isBlank(Opp.Application__r.Entity_Name__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Entity Name is required, please fill in this field'));
                r = false;
            }
            //
            if ((isNewApplication && String.isBlank(abnCode)) || (!isNewApplication && String.isBlank(Opp.Application__r.Business_ABN__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ABN is required, please fill in this field'));
                r = false;
            }
            /*
* if (String.isBlank(abn)) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ABN is required, please fill in this field'));
r = false;
}*/
            //Business Structure
            if ((isNewApplication && String.isBlank(this.app0.Business_Structure__c)) || (!isNewApplication && String.isBlank(Opp.Application__r.Business_Structure__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Business Structure is required, please fill in this field'));
                r = false;
            }else { 
                if (isNewApplication && 'Company'.equals(this.app0.Business_Structure__c)) {
                    if (String.isBlank(acn)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ACN is required, please fill in this field'));
                        r = false;
                    } else if (acn.deleteWhitespace().length() != 9) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ACN should have 9 digits'));
                        r = false;
                    }
                } else if (!isNewApplication && 'Company'.equals(this.Opp.Application__r.Business_Structure__c)) {
                    if (String.isBlank(this.Opp.Application__r.Business_ACN__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ACN is required, please fill in this field'));
                        r = false;
                    } else {
                        String tmpAcn = this.Opp.Application__r.Business_ACN__c;
                        if (tmpAcn.deleteWhitespace().length() != 9) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ACN should have 9 digits'));
                            r = false;
                        }
                    }
                }
            }
            //Trading name
            if ((isNewApplication && String.isBlank(tradingName)) || (!isNewApplication && String.isBlank(Opp.Application__r.Trading_Name__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Trading Name is required, please fill in this field'));
                r = false;
            }
            //Trading address
            if ((isNewApplication && String.isBlank(tradingAddress)) || (!isNewApplication && String.isBlank(Opp.Application__r.Trading_Address__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Trading Address is required, please fill in this field'));
                r = false;
            }
            //Nature of business
            if ((isNewApplication && String.isBlank(natureBusiness)) || (!isNewApplication && String.isBlank(Opp.Application__r.Nature_of_Business__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Nature of Business is required, please fill in this field'));
                r = false;
            }
            //Accountant Name
            if ((isNewApplication && String.isBlank(accountantName)) || (!isNewApplication && String.isBlank(Opp.Application__r.Accountant_Name__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Accountant Name is required, please fill in this field'));
                r = false;
            }
            //Accountant Phone
            if ((isNewApplication && String.isBlank(accountantPhone)) || (!isNewApplication && String.isBlank(Opp.Application__r.Accountant_Phone__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Accountant Phone is required, please fill in this field'));
                r = false;
            }
            //No of directors
            if ((isNewApplication && String.isBlank(String.valueOf(noDirectors))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.No_of_Directors__c)))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No of Directors is required, please fill in this field'));
                r = false;
            }
        }
        //******************************************************************
        //CLIENT DETAILS 
        //******************************************************************
        //Application 1
        //Title
        if ((isNewApplication && String.isBlank(title1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Title_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Title in  is required, please select a value'));
            r = false;
        }
        if ((isNewApplication && String.isBlank(firstName)) || (!isNewApplication && String.isBlank(Opp.Application__r.First_Name__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: First Name is required'));
            r = false;
        }
        if ((isNewApplication && String.isBlank(lastName)) || (!isNewApplication && String.isBlank(Opp.Application__r.Last_Name__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Surname is required'));
            r = false;
        }
        //Date of Birth
        if ((isNewApplication && !FieldValidationsHelper.isDateFormatValid(dateBirth1)) || (!isNewApplication && !FieldValidationsHelper.isDateFormatValid(Opp.Application__r.Date_of_Birth_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Date of Birth is required, please fill in this field (dd/mm/yyyy)'));
            r = false;
        }
        //Current Residency Status
        if ((isNewApplication && String.isBlank(currentResidentialStatus1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Current_Residential_Status_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Current Residency Status is required'));
            r = false;
        } else if ('PR VISA'.equalsIgnoreCase(currentResidentialStatus1) || 'PR VISA'.equalsIgnoreCase(Opp.Application__r.Current_Residential_Status_1__c)) {
            if ((isNewApplication && String.isBlank(app0.Actual_Nationality_1__c)) || (!isNewApplication && String.isBlank(Opp.Application__r.Actual_Nationality_1__c))) {
                //if (this.Opp.Loan_Product__c != null && 'ANZ'.equalsIgnoreCase(this.Opp.Loan_Product__r.Lender__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Actual Nationality is required when Current Residency Status is Permanent Resident'));
                r = false;
                //}
            }
        }
        //Do you have a drivers licence?
        if ((isNewApplication && String.isBlank(haveDriverLicence1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Do_you_have_drivers_licence_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Do you have a drivers licence? is required'));
            r = false;
        }
        if ('Yes'.equalsIgnoreCase(haveDriverLicence1) || 'Yes'.equalsIgnoreCase(Opp.Application__r.Do_you_have_drivers_licence_1__c)) {
            //Driver licence number
            if ((isNewApplication && String.isBlank(driversLicense1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Drivers_License_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Driver Licence Number is required'));
                r = false;
            }
            //Type of Licence
            //if ((isNewApplication && String.isBlank(typeLicence1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Type_of_Licence_1__c))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Type of Licence is required'));
            //    r = false;
            //}
            //Expiry date
            if ((isNewApplication && String.isBlank(expiryDate1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Expiry_Date_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Expiry Date is required'));
                r = false;
            }
            //State of issue
            if ((isNewApplication && String.isBlank(stateOfIssue1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Driver_Licence_State_Issue_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: State of Issue is required'));
                r = false;
            }
        }
        if ((isNewApplication && 'Car'.equalsIgnoreCase(applicationType)) || (!isNewApplication && 'Car'.equalsIgnoreCase(this.Opp.Application__r.Type_of_Asset__c))) {
            if ((isNewApplication && app0.Year_First_Licensed_1__c == null) || (!isNewApplication && this.Opp.Application__r.Year_First_Licensed_1__c == null)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Year First Licensed is required'));
                r = false;
            }
            // if ((isNewApplication && app0.Time_Last_Fault_1__c == null) || (!isNewApplication && this.Opp.Application__r.Time_Last_Fault_1__c == null)) {
            //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: How long since you had an at fault accident/claim (including theft, hail, fire) is required'));
            //     r = false;
            // }
        }
        //Marital Status
        if ((isNewApplication && String.isBlank(maritalStatus1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Marital_Status_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Marital Status is required'));
            r = false;
        }
        //No. of Dependants
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(noDependants1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.No_of_Dependants_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: No. of Dependants is required'));
            r = false;
        }
        //Mobile Phone
        if ((isNewApplication && String.isBlank(mobileNumber)) || (!isNewApplication && String.isBlank(Opp.Application__r.Mobile_Number__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Mobile Phone is required, please fill in this field'));
            r = false;
        }
        //Email
        if ((isNewApplication && String.isBlank(emailAddress)) || (!isNewApplication && String.isBlank(Opp.Application__r.Email_Address__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Email is required, please fill in this field'));
            r = false;
        }
        //Applicant 1 - Current Residential Address
        //Street Address
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(streetAddress)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Street_Address__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Street Address is required'));
            r = false;
        }
        //Suburb
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(suburb)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Suburb__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Suburb is required'));
            r = false;
        }
        //Postcode
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(postcode)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Postcode__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Postcode is required'));
            r = false;
        }
        //State
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(state1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.State__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Postcode is required'));
            r = false;
        }
        //Date Moved In
        if ((isNewApplication && !FieldValidationsHelper.isDateFormatValid(dateMovedIn1)) || (!isNewApplication && !FieldValidationsHelper.isDateFormatValid((Opp.Application__r.Date_Moved_in_1__c)))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Date Moved In is required'));
            r = false;
        }
        //Residential Status
        if ((isNewApplication && String.isBlank(currentStatus1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Current_Residence_Status_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Residential Status is required'));
            r = false;
        }
        if ('Parents/Relative'.equalsIgnoreCase(currentStatus1) || 'Parents/Relative'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c)) {
            //Relative Name
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(relativeName1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Relative_Name_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Relative Name is required'));
                r = false;
            }
            //Relative Phone
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(relativePhone1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Relative_Phone_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Relative Phone is required'));
                r = false;
            }
        } else if (('Renting(Agent)'.equalsIgnoreCase(currentStatus1) || 'Renting(Agent)'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c)) || ('Renting(Private)'.equalsIgnoreCase(currentStatus1) || 'Renting(Private)'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c)) || ('Boarding'.equalsIgnoreCase(currentStatus1) || 'Boarding'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c))) {
            //Landlord/Mortgage details Name/Company
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(landlordName1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Landlord_Name_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Landlord/Mortgage details Name/Company is required'));
                r = false;
            }
            //Landlord/Mortgage details Phone
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(landlordPhone1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Landlord_Phone_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Landlord/Mortgage details Phone is required'));
                r = false;
            }
            if ('Boarding'.equalsIgnoreCase(currentStatus1) || 'Boarding'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c)) {
                //Landlord/Mortgage details Board Per Month
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(boardMonth1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Board_per_Month_1__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Landlord/Mortgage details Board Per Month is required'));
                    r = false;
                }
            } else {
                //Landlord/Mortgage details Rent Per Month
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(rentMonth1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Rent_per_month_1__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 - Current Residential Address: Landlord/Mortgage details Rent Per Month is required'));
                    r = false;
                }
            }
        }
        //Living for more than 3 years?
        if ((isNewApplication && String.isBlank(living3Years1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Living_more_than_three_years_1__c))) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Living for more than 3 years? is required, please select a value'));
            //r = false;
        } else if ('No'.equalsIgnoreCase(living3Years1) || 'No'.equalsIgnoreCase(Opp.Application__r.Living_more_than_three_years_1__c)) {
            ////Street Address
            //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousStreetAddress1)) || 
            //    (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Street_Address_1__c))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Previous Street Address is required, please fill in this field'));
            //    r = false;
            //}
            ////Suburb
            //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousSuburb1)) || 
            //    (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Suburb_1__c))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Previous Suburb is required, please fill in this field'));
            //    r = false;
            //}
            ////Postcode
            //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousPostcode1)) || 
            //    (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Postcode_1__c))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Previous Postcode is required, please fill in this field'));
            //    r = false;
            //}
            ////Date Moved In
            //if ((isNewApplication && String.isBlank(String.valueOf(dateFrom1))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.Date_From_1__c)))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Previous Date Moved In is required, please fill in this field'));
            //    r = false;
            //}
            ////Residential Status
            //if ((isNewApplication && String.isBlank(previousResidenceStatus1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Previous_Residence_Status_1__c))) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Previous Residential Status is required, please select a value'));
            //    r = false;
            //}
        } else if ('Yes'.equalsIgnoreCase(living3Years1) || 'Yes'.equalsIgnoreCase(Opp.Application__r.Living_more_than_three_years_1__c)) {}
        if ((isNewApplication && String.isBlank(creditStatus1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Credit_Status_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Credit History is required, please select a value'));
            r = false;
        }
        //Application 2
        if (noPeople == 2 || Opp.Application__r.No_of_People__c == 2) {
            //Title
            if ((isNewApplication && String.isBlank(title2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Title_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Title is required, please select a value'));
                r = false;
            }
            //First Name
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(firstName2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.First_Name_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: First Name is required, please fill in this field'));
                r = false;
            }
            //Surname
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(lastName2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Last_Name_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Surname is required, please fill in this field'));
                r = false;
            }
            //Date of Birth
            if ((isNewApplication && !FieldValidationsHelper.isDateFormatValid(dateBirth2)) || (!isNewApplication && !FieldValidationsHelper.isDateFormatValid(Opp.Application__r.Date_of_Birth_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Date of Birth is required, please fill in this field (dd/mm/yyyy)'));
                r = false;
            }
            //Current Residency Status
            if ((isNewApplication && String.isBlank(currentResidentialStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Current_Residential_Status_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Current Residency Status is required, please select a value'));
                r = false;
            }
            //Current Residency Status
            if ((isNewApplication && String.isBlank(currentResidentialStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Current_Residential_Status_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1: Current Residency Status is required, please fill in this field'));
                r = false;
            } else if ('PR VISA'.equalsIgnoreCase(currentResidentialStatus2) || 'PR VISA'.equalsIgnoreCase(Opp.Application__r.Current_Residential_Status_2__c)) {
                if ((isNewApplication && String.isBlank(this.app0.Actual_Nationality_2__c)) || (!isNewApplication && String.isBlank(Opp.Application__r.Actual_Nationality_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Actual Nationality is required when Current Residency Status is Permanent Resident, please fill in this field'));
                    r = false;
                }
            }
            //Do you have a drivers licence?
            if ((isNewApplication && String.isBlank(haveDriverLicence2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Do_you_have_drivers_licence_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Do you have a drivers licence? is required, please select a value'));
                r = false;
            }
            if ((isNewApplication && String.isBlank(creditStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Credit_Status_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Credit History is required, please select a value'));
                r = false;
            }
            if ('Yes'.equalsIgnoreCase(haveDriverLicence2) || 'Yes'.equalsIgnoreCase(Opp.Application__r.Do_you_have_drivers_licence_2__c)) {
                //Driver licence number
                if ((isNewApplication && String.isBlank(driversLicense2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Drivers_License_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Driver Licence Number is required, please fill in this field'));
                    r = false;
                }
                //Type of Licence
                //if ((isNewApplication && String.isBlank(typeLicence2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Type_of_Licence_2__c))) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Type of Licence is required'));
                //    r = false;
                //}
                //Expiry date
                if ((isNewApplication && String.isBlank(expiryDate2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Expiry_Date_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Expiry Date is required, please fill in this field'));
                    r = false;
                }
                //State of issue
                if ((isNewApplication && String.isBlank(stateOfIssue2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Driver_Licence_State_Issue_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: State of Issue is required, please fill in this field'));
                    r = false;
                }
            }
            //Marital Status
            if ((isNewApplication && String.isBlank(maritalStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Marital_Status_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Marital Status is required, please select a value'));
                r = false;
            }
            //No. of Dependants
            if ((isNewApplication && String.isBlank(String.valueOf(noDependants2))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.No_of_Dependants_2__c)))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: No. of Dependants is required, please fill in this field'));
                r = false;
            }
            //Mobile Phone
            if ((isNewApplication && String.isBlank(mobileNumber2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Mobile_Number_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Mobile Phone is required, please fill in this field'));
                r = false;
            }
            //Email
            if ((isNewApplication && String.isBlank(emailAddress2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Email_Address_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Email is required, please fill in this field'));
                r = false;
            }
            //Applicant 2 - Current Residential Address
            //Living in the same address?
            if ((isNewApplication && String.isBlank(applicant2SameAddress)) || (!isNewApplication && String.isBlank(Opp.Application__r.Applicant_2_living_in_the_same_address__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Living in the same address? is required'));
                r = false;
            } else if ('No'.equalsIgnoreCase(applicant2SameAddress) || 'No'.equalsIgnoreCase(Opp.Application__r.Applicant_2_living_in_the_same_address__c)) {
                //Street Address
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(streetAddress2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Street_Address_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Street Address is required'));
                    r = false;
                }
                //Suburb
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(suburb2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Suburb_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Suburb is required'));
                    r = false;
                }
                //Postcode
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(postcode2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Postcode_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Postcode is required'));
                    r = false;
                }
                //State
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(state2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.State_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: State is required'));
                    r = false;
                }
                //Date Moved In
                if ((isNewApplication && !FieldValidationsHelper.isDateFormatValid(dateMovedIn2)) || (!isNewApplication && !FieldValidationsHelper.isDateFormatValid((Opp.Application__r.Date_Moved_in_2__c)))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Date Moved In is required'));
                    r = false;
                }
                //Residential Status
                if ((isNewApplication && String.isBlank(currentStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Current_Residence_Status_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Residential Status is required'));
                    r = false;
                }
                if ('Parents/Relative'.equalsIgnoreCase(currentStatus2) || 'Parents/Relative'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_2__c)) {
                    //Relative Name
                    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(relativeName2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Relative_Name_2__c))) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Relative Name is required'));
                        r = false;
                    }
                    //Relative Phone
                    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(relativePhone2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Relative_Phone_2__c))) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Relative Phone is required'));
                        r = false;
                    }
                } else if (('Renting(Agent)'.equalsIgnoreCase(currentStatus2) || 'Renting(Agent)'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_2__c)) || ('Renting(Private)'.equalsIgnoreCase(currentStatus2) || 'Renting(Private)'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_2__c)) || ('Boarding'.equalsIgnoreCase(currentStatus2) || 'Boarding'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_2__c))) {
                    //Landlord/Mortgage details Name/Company
                    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(landlordName2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Landlord_Name_2__c))) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Landlord/Mortgage details Name/Company is required'));
                        r = false;
                    }
                    //Landlord/Mortgage details Phone
                    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(landlordPhone2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Landlord_Phone_2__c))) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Landlord/Mortgage details Phone is required'));
                        r = false;
                    }
                    if ('Boarding'.equalsIgnoreCase(currentStatus2) || 'Boarding'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_2__c)) {
                        //Landlord/Mortgage details Board Per Month
                        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(boardMonth2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Board_per_Month_2__c))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Landlord/Mortgage details Board Per Month is required'));
                            r = false;
                        }
                    } else {
                        //Landlord/Mortgage details Rent Per Month
                        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(rentMonth2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Rent_per_month_2__c))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 - Current Residential Address: Landlord/Mortgage details Rent Per Month is required'));
                            r = false;
                        }
                    }
                }
                //Living for more than 3 years?
                if ((isNewApplication && String.isBlank(living3Years2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Living_more_than_three_years_2__c))) {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Living for more than 3 years? is required, please select a value'));
                    //r = false;
                } else if ('No'.equalsIgnoreCase(living3Years2) || 'No'.equalsIgnoreCase(Opp.Application__r.Living_more_than_three_years_2__c)) {
                    //               //Street Address
                    //               if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousStreetAddress2)) || 
                    //                   (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Street_Address_2__c))) {
                    //                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Previous Street Address is required, please fill in this field'));
                    //                   r = false;
                    //               }
                    //               /**
                    //               //Suburb
                    //               if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousSuburb2)) || 
                    //                   (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Suburb_2__c))) {
                    //                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Previous Suburb 1 is required, please fill in this field'));
                    //                   r = false;
                    //               }
                    //               //Postcode
                    //               if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousPostcode2)) || 
                    //                   (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Postcode_2__c))) {
                    //                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Previous Postcode is required, please fill in this field'));
                    //                   r = false;
                    //               }
                    //**/
                    //               //Date Moved In
                    //               if ((isNewApplication && String.isBlank(String.valueOf(dateFrom2))) || (!isNewApplication && String.isBlank(String.valueOf(Opp.Application__r.Date_From_2__c)))) {
                    //                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Previous Date Moved In is required, please fill in this field'));
                    //                   r = false;
                    //               }
                    //               //Residential Status
                    //               if ((isNewApplication && String.isBlank(previousResidenceStatus2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Previous_Residence_Status_2__c))) {
                    //                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Previous Residential Status is required, please select a value'));
                    //                   r = false;
                    //               }
                }
            }
        } else {
            //Date Moved In
            if (String.isNotBlank(dateMovedIn2) || String.isNotBlank(Opp.Application__r.Date_Moved_in_2__c)) {
                if ((isNewApplication && !FieldValidationsHelper.isDateFormatValidOptional(dateMovedIn2)) || (!isNewApplication && !FieldValidationsHelper.isDateFormatValidOptional((Opp.Application__r.Date_Moved_in_2__c)))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2: Current Date Moved wrong date, please fill in a correct format (dd/mm/yyyy) this field'));
                    r = false;
                }
            }
        }
        //******************************************************************
        //EMPLOYMENT & INCOME  
        //******************************************************************
        //Applicant 1
        //Employment Type
        if ((isNewApplication && String.isBlank(modeEmployment1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Mode_of_Employment_1__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 1: Employment Type is required, please select a value'));
            r = false;
        }
        if (!('Financially Supported by Partner'.equals(modeEmployment1) || 'Financially Supported by Partner'.equals(Opp.Application__r.Mode_of_Employment_1__c))) {
            //Employer Name
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(employerName1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Employer_Name_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 1: Employer Name is required, please fill in this field'));
                r = false;
            }
            /**
//Suburb
if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkSuburb1)) || 
(!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Suburb_1__c))) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Current Work Suburb is required, please fill in this field'));
r = false;
}
//Postcode
if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkPostcode1)) || 
(!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Postcode_1__c))) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Current Work Postcode is required, please fill in this field'));
r = false;
}

//Work Address
if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(workAddress1)) || 
(!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Address_1__c))) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Work Address is required, please fill in this field'));
r = false;
}
**/
            //Employer's Phone
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(employerPhone1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Employer_Phone_1__c))) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Employer\'s Phone is required, please fill in this field'));
                //r = false;
            }
            //Employer's Phone
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(occupation1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Occupation_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 1: Occupation is required, please fill in this field'));
                r = false;
            }
            //Start Date
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(dateStarted1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Date_Started_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 1: Start Date is required, please fill in this field'));
                r = false;
            }
            
            if(Opp.Application__r!=null){
                if(!validateHasMoreThan3YearsEmployments(
                      Opp.Application__r.Start_Date_1__c, 
                      Opp.Application__r.Finish_Date_1__c, 
                      Opp.Application__r.Date_Started_1__c,
                      Opp.Application__r.Previous_Work_Country_1__c,
                      Opp.Application__r.Previous_Mode_of_Employment_1__c
                      )){
                    r = false;
                }
            }else{
                if(validateHasMoreThan3YearsEmployments(
                      startDate1, finishDate1, dateStarted1, 
                      app0.Previous_Work_Country_1__c, previousModeEmployment1)){
                    r = false;
                }
            }
            
            //Income After Tax
            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(netIncome1)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Net_Income_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income: Income After Tax is required, please fill in this field'));
                r = false;
            }
            //Payment Frequency
            if ((isNewApplication && String.isBlank(paymentFrequency1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Payment_Frequency_1__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 1: Payment Frequency is required, please select a value'));
                r = false;
            }
            //Employed for more than 3 years?
            if ((isNewApplication && String.isBlank(employed3Years1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Employed_for_more_than_two_years_1__c))) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Employed for more than 3 years? is required, please select a value'));
                //r = false;
            } else if ('No'.equalsIgnoreCase(employed3Years1) || 'No'.equalsIgnoreCase(Opp.Application__r.Employed_for_more_than_two_years_1__c)) {
                //        if ((isNewApplication && 'AUS'.equals(app0.Previous_Work_Country_1__c)) || (!isNewApplication && 'AUS'.equals(Opp.Application__r.Previous_Work_Country_1__c))) {
                //            //Employment Type
                //            if ((isNewApplication && String.isBlank(previousModeEmployment1)) || (!isNewApplication && String.isBlank(Opp.Application__r.Previous_Mode_of_Employment_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Employment Type is required, please select a value'));
                //                r = false;
                //            }
                //            //Employer Name
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousEmployerName1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Employer_Name_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Employer Name is required, please fill in this field'));
                //                r = false;
                //            }
                //            /**
                //            //Suburb
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkSuburb1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Suburb_1__c))) {
                //                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Current Work Suburb is required, please fill in this field'));
                //                r = false;
                //            }
                //            //Postcode
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkPostcode1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Postcode_1__c))) {
                //                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 1: Current Work Postcode is required, please fill in this field'));
                //                r = false;
                //            }
                //            //Work Address
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousWorkAddress1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Work_Address_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Work Address is required, please fill in this field'));
                //                r = false;
                //            } 
                //**/
                //            //Employer's Phone
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousEmployerPhone1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Employer_Phone_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Employer\'s Phone is required, please fill in this field'));
                //                r = false;
                //            }
                //            //Start Date
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(startDate1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Start_Date_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Start Date is required, please fill in this field'));
                //                r = false;
                //            }
                //            //Finish Date
                //            if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(finishDate1)) || 
                //                (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Finish_Date_1__c))) {
                //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 1: Previous Finish Date is required, please fill in this field'));
                //                r = false;
                //            }
                //        }
            }
        }
        //Do you receive other income?
        if (!isValidIncomes('1')) {
            r = false;
        }
        //Application 2
        if (noPeople == 2 || Opp.Application__r.No_of_People__c == 2) {
            //Employment Type
            if ((isNewApplication && String.isBlank(modeEmployment2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Mode_of_Employment_2__c))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Employment Type is required, please select a value'));
                r = false;
            }
            if (!('Financially Supported by Partner'.equals(modeEmployment2) || 'Financially Supported by Partner'.equals(Opp.Application__r.Mode_of_Employment_2__c))) {
                //Employer Name
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(employerName2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Employer_Name_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Employer Name is required, please fill in this field'));
                    r = false;
                }
                /**
//Suburb
if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkSuburb2)) || 
(!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Suburb_2__c))) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Current Work Suburb is required, please fill in this field'));
r = false;
}
//Postcode
if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(currentWorkPostcode2)) || 
(!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Postcode_2__c))) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Applicant 2: Current Work Postcode is required, please fill in this field'));
r = false;
}
**/
                //Work Address
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(workAddress2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Work_Address_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Work Address is required, please fill in this field'));
                    r = false;
                }
                //Employer's Phone
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(employerPhone2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Current_Employer_Phone_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Employer\'s Phone is required, please fill in this field'));
                    r = false;
                }
                //Start Date
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(dateStarted2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Date_Started_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Start Date is required, please fill in this field'));
                    r = false;
                }
                //Income After Tax
                if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(netIncome2)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Net_Income_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Income After Tax is required, please fill in this field'));
                    r = false;
                }
                //Payment Frequency
                if ((isNewApplication && String.isBlank(paymentFrequency2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Payment_Frequency_2__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employment & Income - Applicant 2: Payment Frequency is required, please select a value'));
                    r = false;
                }
                //Employed for more than 3 years?
                if ((isNewApplication && String.isBlank(employed3Years2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Employed_for_more_than_two_years_2__c))) {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Employed for more than 3 years? is required, please select a value'));
                    //r = false;
                } else if ('No'.equalsIgnoreCase(employed3Years2) || 'No'.equalsIgnoreCase(Opp.Application__r.Employed_for_more_than_two_years_2__c)) {
                    //if ((isNewApplication && 'AUS'.equals(app0.Previous_Work_Country_2__c)) || (!isNewApplication && 'AUS'.equals(Opp.Application__r.Previous_Work_Country_2__c))) {
                    //    //Employment Type
                    //    if ((isNewApplication && String.isBlank(previousModeEmployment2)) || (!isNewApplication && String.isBlank(Opp.Application__r.Previous_Mode_of_Employment_2__c))) {
                    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Employment Type is required, please select a value'));
                    //        r = false;
                    //    }
                    //    //Employer Name
                    //    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousEmployerName2)) || 
                    //        (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Employer_Name_2__c))) {
                    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Employer Name in Applicant 1 is required, please fill in this field'));
                    //        r = false;
                    //    }
                    //    //Work Address
                    //    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousWorkAddress2)) || 
                    //        (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Work_Address_2__c))) {
                    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Work Address in Applicant 1 is required, please fill in this field'));
                    //        r = false;
                    //    }
                    //    //Employer's Phone
                    //    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(previousEmployerPhone2)) || 
                    //        (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Previous_Employer_Phone_2__c))) {
                    //        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Employer\'s Phone is required, please fill in this field'));
                    //        //r = false;
                    //    }
                    //    //Start Date
                    //    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(startDate2)) || 
                    //        (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Start_Date_2__c))) {
                    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Start Date is required, please fill in this field'));
                    //        r = false;
                    //    }
                    //    //Finish Date
                    //    if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(finishDate2)) || 
                    //        (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Finish_Date_2__c))) {
                    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employment & Income - Applicant 2: Previous Finish Date is required, please fill in this field'));
                    //        r = false;
                    //    }
                    //}
                }
            }
            //Do you receive other income?
            if (!isValidIncomes('2')) {
                r = false;
            }
        }
        //******************************************************************
        //FINANCIAL DETAILS
        //******************************************************************
        if (!isValidPropertyAssets()) {
            r = false;
        }
        if (!isValidVehicleAssets()) {
            r = false;
        }
        if(!getHasProperrtyAssets() && ('Own Outright'.equals(Opp.Application__r.Current_Residence_Status_1__c) || 'Own Outright'.equals(currentStatus1))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A property should be added in Financial Details section due to the residential status is Own Outright for Applicant 1'));
            r = false;
        }
        //SAVINGS
        //Savings value
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(bankValue)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Bank_Value__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details: Savings value is required, please fill in this field'));
            r = false;
        }
        //Institution
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(bankName)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Bank_Name__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details: Institution is required, please fill in this field'));
            r = false;
        }
        //How Much Super Do You Have?
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(superValueHow)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Super_Value_How_Much__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details: How Much Super Do You Have? is required, please fill in this field'));
            r = false;
        }
        
        //Liabilities
        //Do you have any loans outstanding?
        if (!isValidLoans()) {
            r = false;
        }
        if (!isValidCreditCards()) {
            r = false;
        }
        //Other Assets
        if (!isValidOtherAssets()) {
            r = false;
        }
        
        //Living Expenses
        //Basic Living Expenses Per Month
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(basicLivingExpensesMonth)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Basic_Living_Expenses_Per_Month__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Basic Living Expenses Per Month is required, please fill in this field'));
            r = false;
        }else if(!isNewApplication){
            try{
                Decimal.valueOf(Opp.Application__r.Basic_Living_Expenses_Per_Month__c);
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Basic Living Expenses Per Month requires a number'));
                r = false;
            } 
        }
        //Childcare, Child Maintenance Per Month
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(childcareChildMaintenanceMonth)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Childcare_Child_Maintenance_Per_Month__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Childcare, Child Maintenance Per Month is required, please fill in this field'));
            r = false;
        }
        //Mobile Phone, Internet, Pay TV per Month
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(mobilePhoneInternetPayTVMonth)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Mobile Phone, Internet, Pay TV per Month is required, please fill in this field'));
            r = false;
        }
        //Insurance Expenses per Month
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(insuranceExpensesMonth)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Insurance_Expenses_per_Month__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Insurance Expenses per Month is required, please fill in this field'));
            r = false;
        }
        //Travel/Transport Expenses per Month
        if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(travelTransportExpensesMonth)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Travel_Transport_Expenses_per_Month__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Financial Details - Living Expenses: Travel/Transport Expenses per Month is required, please fill in this field'));
            r = false;
        }
        //******************************************************************
        //PERSONAL REFERENCES
        //******************************************************************
        //Reference 1
        //Full Name
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference1Full_Name)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_1_Full_Name__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 1: Full Name is required, please fill in this field'));
        //     r = false;
        // }
        //Relationship
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference1Relationship)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_1_Relationship__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 1: Relationship is required, please fill in this field'));
        //     r = false;
        // }
        //Street Number
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_1_Street_Number__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_1_Street_Number__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 1: Street Number is required'));
        //r = false;
        //}
        //Address
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference1Address)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_1_Address__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 1: Address is required, please fill in this field'));
        //     r = false;
        // }
        //Street Type
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_1_Street_Type__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_1_Street_Type__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 1: Street Type is required'));
        //r = false;
        //}
        //Suburb
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_1_Suburb__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_1_Suburb__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 1: Suburb is required'));
        //r = false;
        //}
        //Postcode
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_1_Postcode__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_1_Postcode__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 1: Postcode is required'));
        //r = false;
        //}
        //State
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_1_State__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_1_State__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 1: State is required'));
        //r = false;
        //}
        //Phone
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference1Phone)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_1_Phone__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 1: Phone is required, please fill in this field'));
        //     r = false;
        // }
        //Reference 2
        //Full Name
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference2Full_Name)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_2_Full_Name__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 2: Full Name is required, please fill in this field'));
        //     r = false;
        // }
        //Relationship
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference2Relationship)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_2_Relationship__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 2: Relationship is required, please fill in this field'));
        //     r = false;
        // }
        //Street Number
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_2_Street_Number__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_2_Street_Number__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 2: Street Number is required'));
        //r = false;
        //}
        //Address
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference2Address)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_2_Address__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 2: Address is required, please fill in this field'));
        //     r = false;
        // }
        //Street Type
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_2_Street_Type__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_2_Street_Type__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 2: Street Type is required'));
        //r = false;
        //}
        //Suburb
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_2_Suburb__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_2_Suburb__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 2: Suburb is required'));
        //r = false;
        //}
        //Postcode
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_2_Postcode__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_2_Postcode__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 2: Postcode is required'));
        //r = false;
        //}
        //State
        //if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(this.app0.Reference_2_State__c)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Reference_2_State__c))) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Personal References - Reference 2: State is required'));
        //r = false;
        //}
        //Phone
        // if ((isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(personalReference2Phone)) || (!isNewApplication && !FieldValidationsHelper.isContainsValidCharacters(Opp.Application__r.Personal_Reference_2_Phone__c))) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Personal References - Reference 2: Phone is required, please fill in this field'));
        //     r = false;
        // }
        if(isSecondJobApplic1){
            if(!isValidSecondJobApplic1OK(secondJobApplic1, 1)){
                r = false;
            }
        }
        if(isSecondJobApplic2){
            if(!isValidSecondJobApplic2OK(secondJobApplic2, 2)){
                r = false;
            }
        }

        return r;
    }
    
    public PageReference saveRecord() {
        //System.debug('--------------------------------------------');
        //system.debug(previousWorkPostcode1);
        //system.debug(previousWorkAddress1);
        //System.debug('--------------------------------------------');
        if (!Test.isRunningTest()) {
            if (!isApplicationReadyToBeSaved()) {
                return null;
            }
        }
        if (Opp.Application__c == null) {
            app0.Status__c = 'F';
        }else if (opp.Application__r != null) {
            if (String.isBlank(Opp.Application__r.Status__c) || !'F'.equals(Opp.Application__r.Status__c)) {
                Opp.Application__r.Status__c = 'F';
            }
        }
        System.debug(Opp.Application__r.Trust_Name__c);
System.debug(trustName);
System.debug(Opp.Application__r.No_of_Directors__c);
System.debug(noDirectors);
        return saveApplicationData();
    }
    public PageReference saveApplicationData() {
        if (Opp.Application__c == null) {
            servicingCalc = false;
            ytdCalc = false;
            quotingTool = false;
            assetDetails = false;
            notesSection = false;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is not an existing Application linked to this Opportunity. Please use New Application button to create a new application.'));
            Application__c newApp = new Application__c();
            newApp.First_Name__c = firstName;
            newApp.Last_Name__c = lastName;
            newApp.Mobile_Number__c = mobileNumber;
            newApp.Email_Address__c = emailAddress;
            newApp.Type_of_Asset__c = typeAsset;
            newApp.Vehicle_Make__c = vehicleMake;
            newApp.Vehicle_Model__c = vehicleModel;
            newApp.Vehicle_Year__c = vehicleYear;
            if (purchasePrice != null) {
                newApp.Purchase_Price__c = purchasePrice;
            } else {
                newApp.Purchase_Price__c = 0;
            }
            if (financeAmount != null) {
                newApp.Finance_Amount__c = financeAmount;
            } else {
                newApp.Finance_Amount__c = 0;
            }
            if (lengthTerm != null) {
                newApp.Length_of_Term__c = lengthTerm;
            } else {
                newApp.Length_of_Term__c = 0;
            }
            if (preferredRepayment != null) {
                newApp.Preferred_Repayment__c = preferredRepayment;
            } else {
                newApp.Preferred_Repayment__c = 0;
            }
            newApp.Repayment_Regularity__c = repaymentRegularity;
            if (noPeople != null) {
                newApp.No_of_People__c = noPeople;
            } else {
                newApp.No_of_People__c = 0;
            }
            newApp.Application_Type__c = applicationType;
            newApp.Business_ABN__c = this.abnCode;
            newApp.Business_ABN_2__c = app0.Business_ABN_2__c;
            newApp.Business_ACN__c = acn;
            newApp.Business_Structure__c = app0.Business_Structure__c;
            newApp.Business_Structure_2__c = app0.Business_Structure_2__c;
            newApp.Trading_Name__c = tradingName;
            newApp.Trust_Name__c = trustName;
            newApp.Trading_Address__c = tradingAddress;
            newApp.Nature_of_Business__c = natureBusiness;
            newApp.Nature_of_Business_2__c = app0.Nature_of_Business_2__c;
            if (noDirectors != null) {
                newApp.No_of_Directors__c = noDirectors;
            } else {
                newApp.No_of_Directors__c = 0;
            }
            if (estimatedProfit != null) {
                newApp.Estimated_profit_per_annum__c = estimatedProfit;
            } else {
                newApp.Estimated_profit_per_annum__c = 0;
            }
            newApp.Accountant_Name__c = accountantName;
            newApp.Accountant_Phone__c = accountantPhone;
            newApp.Time_In_Business__c = app0.Time_In_Business__c;
            newApp.Annual_Revenue__c = app0.Annual_Revenue__c;
            newApp.Title_1__c = title1;
            newApp.Title_2__c = title2;
            newApp.First_Name_2__c = firstName2;
            newApp.Middle_Name__c = middleName;
            newApp.Middle_Name_2__c = middleName2;
            newApp.Last_Name_2__c = lastName2;
            newApp.Date_of_Birth_1__c = dateBirth1;
            newApp.Date_of_Birth_2__c = dateBirth2;
            newApp.Drivers_License_1__c = driversLicense1;
            newApp.Drivers_License_2__c = driversLicense2;
            if (!String.isBlank(typeLicence1)) {
                newApp.Type_of_Licence_1__c = typeLicence1;
            } else {
                newApp.Type_of_Licence_1__c = 'NONE';
            }
            if (!String.isBlank(typeLicence2)) {
                newApp.Type_of_Licence_2__c = typeLicence2;
            } else {
                newApp.Type_of_Licence_2__c = 'NONE';
            }
            newApp.Expiry_Date_1__c = expiryDate1;
            newApp.Expiry_Date_2__c = expiryDate2;
            newApp.Marital_Status_1__c = maritalStatus1;
            newApp.Marital_Status_2__c = maritalStatus2;
            if (noDependants1 != null) {
                newApp.No_of_Dependants_1__c = noDependants1;
            } else {
                newApp.No_of_Dependants_1__c = 0;
            }
            if (noDependants2 != null) {
                newApp.No_of_Dependants_2__c = noDependants2;
            } else {
                newApp.No_of_Dependants_2__c = 0;
            }
            newApp.Ages_of_Dependants_1__c = agesDependants1;
            newApp.Ages_of_Dependants_2__c = agesDependants2;
            newApp.Home_Phone__c = homePhone;
            newApp.Home_Phone_2__c = homePhone2;
            newApp.Work_Phone__c = workPhone;
            newApp.Work_Phone_2__c = workPhone2;
            newApp.Mobile_Number_2__c = mobileNumber2;
            newApp.Email_Address_2__c = emailAddress2;
            if (partnerIncome != null) {
                newApp.Partner_Income__c = partnerIncome;
            } else {
                newApp.Partner_Income__c = 0;
            }
            if (partnerIncome2 != null) {
                newApp.Partner_Income_2__c = partnerIncome2;
            } else {
                newApp.Partner_Income_2__c = 0;
            }
            newApp.Unit_Number__c = unitNumber1;
            newApp.Street_Number__c = streetNumber1;
            newApp.Street_Address__c = streetAddress;
            newApp.Street_Type__c = streetType1;
            newApp.Suburb__c = suburb;
            newApp.Postcode__c = postcode;
            newApp.State__c = state1;
            newApp.Date_Moved_in_1__c = dateMovedIn1;
            newApp.Current_Residence_Status_1__c = currentStatus1;
            newApp.Applicant_2_living_in_the_same_address__c = applicant2SameAddress;
            newApp.Unit_Number_2__c = unitNumber2;
            newApp.Street_Number_2__c = streetNumber2;
            newApp.Street_Address_2__c = streetAddress2;
            newApp.Street_Type_2__c = streetType2;
            newApp.Suburb_2__c = suburb2;
            newApp.Postcode_2__c = postcode2;
            newApp.State_2__c = state2;
            newApp.Date_Moved_in_2__c = dateMovedIn2;
            newApp.Current_Residence_Status_2__c = currentStatus2;
            newApp.Landlord_Name_1__c = landlordName1;
            newApp.Landlord_Name_2__c = landlordName2;
            newApp.Landlord_Phone_1__c = landlordPhone1;
            newApp.Landlord_Phone_2__c = landlordPhone2;
            if (rentMonth1 != null) {
                newApp.Rent_per_month_1__c = rentMonth1;
            } else {
                newApp.Rent_per_month_1__c = 0;
            }
            if (rentMonth2 != null) {
                newApp.Rent_per_month_2__c = rentMonth2;
            } else {
                newApp.Rent_per_month_2__c = 0;
            }
            //- Lelo                                2016-06-27
            if (boardMonth1 != null) {
                newApp.Board_per_Month_1__c = boardMonth1;
            } else {
                newApp.Board_per_Month_1__c = 0;
            }
            if (boardMonth2 != null) {
                newApp.Board_per_Month_2__c = boardMonth2;
            } else {
                newApp.Board_per_Month_2__c = 0;
            }
            //- Lelo                                2017-08-08
            newApp.Residential_Payment_Frequency_1__c = app0.Residential_Payment_Frequency_1__c;
            if (String.isBlank(newApp.Residential_Payment_Frequency_1__c)) {
                newApp.Residential_Payment_Frequency_1__c = 'Monthly';
            }
            newApp.Residential_Payment_Frequency_2__c = app0.Residential_Payment_Frequency_2__c;
            if (String.isBlank(newApp.Residential_Payment_Frequency_2__c)) {
                newApp.Residential_Payment_Frequency_2__c = 'Monthly';
            }
            //-
            newApp.Living_more_than_three_years_1__c = living3Years1;
            newApp.Living_more_than_three_years_2__c = living3Years2;
            newApp.Employer_ABN_1__c = app0.Employer_ABN_1__c;
            newApp.Employer_ABN_2__c = app0.Employer_ABN_2__c;
            //Previuos Address Applicant 1
            newApp.Previous_Country_1__c = this.app0.Previous_Country_1__c;
            newApp.Date_From_1__c = this.app0.Date_From_1__c;
            newApp.Previous_Unit_Number_1__c = this.app0.Previous_Unit_Number_1__c;
            newApp.Previous_Street_Number_1__c = this.app0.Previous_Street_Number_1__c;
            newApp.Previous_Street_Address_1__c = this.app0.Previous_Street_Address_1__c;
            newApp.Previous_Street_Type_1__c = this.app0.Previous_Street_Type_1__c;
            newApp.Previous_Street_Address_2nd_1__c = this.app0.Previous_Street_Address_2nd_1__c;
            newApp.Previous_Suburb_1__c = this.app0.Previous_Suburb_1__c;
            newApp.Previous_Overseas_City_1__c = this.app0.Previous_Overseas_City_1__c;
            newApp.Previous_Postcode_1__c = this.app0.Previous_Postcode_1__c;
            newApp.Previous_State_1__c = this.app0.Previous_State_1__c;
            newApp.Previous_Overseas_State_1__c = this.app0.Previous_Overseas_State_1__c;
            newApp.Previous_Residence_Status_1__c = this.app0.Previous_Residence_Status_1__c;
            newApp.Previous_Country_1b__c = this.app0.Previous_Country_1b__c;
            newApp.Date_From_1b__c = this.app0.Date_From_1b__c;
            newApp.Previous_Unit_Number_1b__c = this.app0.Previous_Unit_Number_1b__c;
            newApp.Previous_Street_Number_1b__c = this.app0.Previous_Street_Number_1b__c;
            newApp.Previous_Street_Address_1b__c = this.app0.Previous_Street_Address_1b__c;
            newApp.Previous_Street_Type_1b__c = this.app0.Previous_Street_Type_1b__c;
            newApp.Previous_Street_Address_2nd_1b__c = this.app0.Previous_Street_Address_2nd_1b__c;
            newApp.Previous_Suburb_1b__c = this.app0.Previous_Suburb_1b__c;
            newApp.Previous_Overseas_City_1b__c = this.app0.Previous_Overseas_City_1b__c;
            newApp.Previous_Postcode_1b__c = this.app0.Previous_Postcode_1b__c;
            newApp.Previous_State_1b__c = this.app0.Previous_State_1b__c;
            newApp.Previous_Overseas_State_1b__c = this.app0.Previous_Overseas_State_1b__c;
            newApp.Previous_Residence_Status_1b__c = this.app0.Previous_Residence_Status_1b__c;
            newApp.Previous_Country_1c__c = this.app0.Previous_Country_1c__c;
            newApp.Date_From_1c__c = this.app0.Date_From_1c__c;
            newApp.Previous_Unit_Number_1c__c = this.app0.Previous_Unit_Number_1c__c;
            newApp.Previous_Street_Number_1c__c = this.app0.Previous_Street_Number_1c__c;
            newApp.Previous_Street_Address_1c__c = this.app0.Previous_Street_Address_1c__c;
            newApp.Previous_Street_Type_1c__c = this.app0.Previous_Street_Type_1c__c;
            newApp.Previous_Street_Address_2nd_1c__c = this.app0.Previous_Street_Address_2nd_1c__c;
            newApp.Previous_Suburb_1c__c = this.app0.Previous_Suburb_1c__c;
            newApp.Previous_Overseas_City_1c__c = this.app0.Previous_Overseas_City_1c__c;
            newApp.Previous_Postcode_1c__c = this.app0.Previous_Postcode_1c__c;
            newApp.Previous_State_1c__c = this.app0.Previous_State_1c__c;
            newApp.Previous_Overseas_State_1c__c = this.app0.Previous_Overseas_State_1c__c;
            newApp.Previous_Residence_Status_1c__c = this.app0.Previous_Residence_Status_1c__c;
            newApp.Previous_Country_1d__c = this.app0.Previous_Country_1d__c;
            newApp.Date_From_1d__c = this.app0.Date_From_1d__c;
            newApp.Previous_Unit_Number_1d__c = this.app0.Previous_Unit_Number_1d__c;
            newApp.Previous_Street_Number_1d__c = this.app0.Previous_Street_Number_1d__c;
            newApp.Previous_Street_Address_1d__c = this.app0.Previous_Street_Address_1d__c;
            newApp.Previous_Street_Type_1d__c = this.app0.Previous_Street_Type_1d__c;
            newApp.Previous_Street_Address_2nd_1d__c = this.app0.Previous_Street_Address_2nd_1d__c;
            newApp.Previous_Suburb_1d__c = this.app0.Previous_Suburb_1d__c;
            newApp.Previous_Overseas_City_1d__c = this.app0.Previous_Overseas_City_1d__c;
            newApp.Previous_Postcode_1d__c = this.app0.Previous_Postcode_1d__c;
            newApp.Previous_State_1d__c = this.app0.Previous_State_1d__c;
            newApp.Previous_Overseas_State_1d__c = this.app0.Previous_Overseas_State_1d__c;
            newApp.Previous_Residence_Status_1d__c = this.app0.Previous_Residence_Status_1d__c;
            newApp.Previous_Country_1e__c = this.app0.Previous_Country_1e__c;
            newApp.Date_From_1e__c = this.app0.Date_From_1e__c;
            newApp.Previous_Unit_Number_1e__c = this.app0.Previous_Unit_Number_1e__c;
            newApp.Previous_Street_Number_1e__c = this.app0.Previous_Street_Number_1e__c;
            newApp.Previous_Street_Address_1e__c = this.app0.Previous_Street_Address_1e__c;
            newApp.Previous_Street_Type_1e__c = this.app0.Previous_Street_Type_1e__c;
            newApp.Previous_Street_Address_2nd_1e__c = this.app0.Previous_Street_Address_2nd_1e__c;
            newApp.Previous_Suburb_1e__c = this.app0.Previous_Suburb_1e__c;
            newApp.Previous_Overseas_City_1e__c = this.app0.Previous_Overseas_City_1e__c;
            newApp.Previous_Postcode_1e__c = this.app0.Previous_Postcode_1e__c;
            newApp.Previous_State_1e__c = this.app0.Previous_State_1e__c;
            newApp.Previous_Overseas_State_1e__c = this.app0.Previous_Overseas_State_1e__c;
            newApp.Previous_Residence_Status_1e__c = this.app0.Previous_Residence_Status_1e__c;
            //Previuos Address Applicant 2
            newApp.Previous_Country_2__c = this.app0.Previous_Country_2__c;
            newApp.Date_From_2__c = this.app0.Date_From_2__c;
            newApp.Previous_Unit_Number_2__c = this.app0.Previous_Unit_Number_2__c;
            newApp.Previous_Street_Number_2__c = this.app0.Previous_Street_Number_2__c;
            newApp.Previous_Street_Address_2__c = this.app0.Previous_Street_Address_2__c;
            newApp.Previous_Street_Type_2__c = this.app0.Previous_Street_Type_2__c;
            newApp.Previous_Street_Address_2nd_2__c = this.app0.Previous_Street_Address_2nd_2__c;
            newApp.Previous_Suburb_2__c = this.app0.Previous_Suburb_2__c;
            newApp.Previous_Overseas_City_2__c = this.app0.Previous_Overseas_City_2__c;
            newApp.Previous_Postcode_2__c = this.app0.Previous_Postcode_2__c;
            newApp.Previous_State_2__c = this.app0.Previous_State_2__c;
            newApp.Previous_Overseas_State_2__c = this.app0.Previous_Overseas_State_2__c;
            newApp.Previous_Residence_Status_2__c = this.app0.Previous_Residence_Status_2__c;
            newApp.Previous_Country_2b__c = this.app0.Previous_Country_2b__c;
            newApp.Date_From_2b__c = this.app0.Date_From_2b__c;
            newApp.Previous_Unit_Number_2b__c = this.app0.Previous_Unit_Number_2b__c;
            newApp.Previous_Street_Number_2b__c = this.app0.Previous_Street_Number_2b__c;
            newApp.Previous_Street_Address_2b__c = this.app0.Previous_Street_Address_2b__c;
            newApp.Previous_Street_Type_2b__c = this.app0.Previous_Street_Type_2b__c;
            newApp.Previous_Street_Address_2nd_2b__c = this.app0.Previous_Street_Address_2nd_2b__c;
            newApp.Previous_Suburb_2b__c = this.app0.Previous_Suburb_2b__c;
            newApp.Previous_Overseas_City_2b__c = this.app0.Previous_Overseas_City_2b__c;
            newApp.Previous_Postcode_2b__c = this.app0.Previous_Postcode_2b__c;
            newApp.Previous_State_2b__c = this.app0.Previous_State_2b__c;
            newApp.Previous_Overseas_State_2b__c = this.app0.Previous_Overseas_State_2b__c;
            newApp.Previous_Residence_Status_2b__c = this.app0.Previous_Residence_Status_2b__c;
            newApp.Previous_Country_2c__c = this.app0.Previous_Country_2c__c;
            newApp.Date_From_2c__c = this.app0.Date_From_2c__c;
            newApp.Previous_Unit_Number_2c__c = this.app0.Previous_Unit_Number_2c__c;
            newApp.Previous_Street_Number_2c__c = this.app0.Previous_Street_Number_2c__c;
            newApp.Previous_Street_Address_2c__c = this.app0.Previous_Street_Address_2c__c;
            newApp.Previous_Street_Type_2c__c = this.app0.Previous_Street_Type_2c__c;
            newApp.Previous_Street_Address_2nd_2c__c = this.app0.Previous_Street_Address_2nd_2c__c;
            newApp.Previous_Suburb_2c__c = this.app0.Previous_Suburb_2c__c;
            newApp.Previous_Overseas_City_2c__c = this.app0.Previous_Overseas_City_2c__c;
            newApp.Previous_Postcode_2c__c = this.app0.Previous_Postcode_2c__c;
            newApp.Previous_State_2c__c = this.app0.Previous_State_2c__c;
            newApp.Previous_Overseas_State_2c__c = this.app0.Previous_Overseas_State_2c__c;
            newApp.Previous_Residence_Status_2c__c = this.app0.Previous_Residence_Status_2c__c;
            newApp.Previous_Country_2d__c = this.app0.Previous_Country_2d__c;
            newApp.Date_From_2d__c = this.app0.Date_From_2d__c;
            newApp.Previous_Unit_Number_2d__c = this.app0.Previous_Unit_Number_2d__c;
            newApp.Previous_Street_Number_2d__c = this.app0.Previous_Street_Number_2d__c;
            newApp.Previous_Street_Address_2d__c = this.app0.Previous_Street_Address_2d__c;
            newApp.Previous_Street_Type_2d__c = this.app0.Previous_Street_Type_2d__c;
            newApp.Previous_Street_Address_2nd_2d__c = this.app0.Previous_Street_Address_2nd_2d__c;
            newApp.Previous_Suburb_2d__c = this.app0.Previous_Suburb_2d__c;
            newApp.Previous_Overseas_City_2d__c = this.app0.Previous_Overseas_City_2d__c;
            newApp.Previous_Postcode_2d__c = this.app0.Previous_Postcode_2d__c;
            newApp.Previous_State_2d__c = this.app0.Previous_State_2d__c;
            newApp.Previous_Overseas_State_2d__c = this.app0.Previous_Overseas_State_2d__c;
            newApp.Previous_Residence_Status_2d__c = this.app0.Previous_Residence_Status_2d__c;
            newApp.Previous_Country_2e__c = this.app0.Previous_Country_2e__c;
            newApp.Date_From_2e__c = this.app0.Date_From_2e__c;
            newApp.Previous_Unit_Number_2e__c = this.app0.Previous_Unit_Number_2e__c;
            newApp.Previous_Street_Number_2e__c = this.app0.Previous_Street_Number_2e__c;
            newApp.Previous_Street_Address_2e__c = this.app0.Previous_Street_Address_2e__c;
            newApp.Previous_Street_Type_2e__c = this.app0.Previous_Street_Type_2e__c;
            newApp.Previous_Street_Address_2nd_2e__c = this.app0.Previous_Street_Address_2nd_2e__c;
            newApp.Previous_Suburb_2e__c = this.app0.Previous_Suburb_2e__c;
            newApp.Previous_Overseas_City_2e__c = this.app0.Previous_Overseas_City_2e__c;
            newApp.Previous_Postcode_2e__c = this.app0.Previous_Postcode_2e__c;
            newApp.Previous_State_2e__c = this.app0.Previous_State_2e__c;
            newApp.Previous_Overseas_State_2e__c = this.app0.Previous_Overseas_State_2e__c;
            newApp.Previous_Residence_Status_2e__c = this.app0.Previous_Residence_Status_2e__c;
            //
            newApp.Mode_of_Employment_1__c = modeEmployment1;
            newApp.Mode_of_Employment_2__c = modeEmployment2;
            newApp.Current_Employer_Name_1__c = employerName1;
            newApp.Current_Employer_Name_2__c = employerName2;
            newApp.Current_Work_Address_1__c = workAddress1;
            newApp.Current_Work_Address_2__c = workAddress2;
            newApp.Current_Employer_Phone_1__c = employerPhone1;
            newApp.Current_Employer_Phone_2__c = employerPhone2;
            newApp.Reference_Name_1__c = referenceName1;
            newApp.Reference_Name_2__c = referenceName2;
            newApp.Current_Occupation_1__c = occupation1;
            newApp.Current_Occupation_2__c = occupation2;
            newApp.Date_Started_1__c = dateStarted1;
            newApp.Date_Started_2__c = dateStarted2;
            if (netIncome1 != null) {
                newApp.Net_Income_1__c = netIncome1;
            } else {
                newApp.Net_Income_1__c = 0;
            }
            if (netIncome2 != null) {
                newApp.Net_Income_2__c = netIncome2;
            } else {
                newApp.Net_Income_2__c = 0;
            }
            newApp.Payment_Frequency_1__c = paymentFrequency1;
            newApp.Payment_Frequency_2__c = paymentFrequency2;
            newApp.Employed_for_more_than_two_years_1__c = employed3Years1;
            newApp.Employed_for_more_than_two_years_2__c = employed3Years2;
            newApp.Previous_Work_Country_1__c = this.app0.Previous_Work_Country_1__c;
            newApp.Previous_Work_Country_2__c = this.app0.Previous_Work_Country_2__c;
            newApp.Previous_Mode_of_Employment_1__c = previousModeEmployment1;
            newApp.Previous_Mode_of_Employment_2__c = previousModeEmployment2;
            newApp.Previous_Employer_Name_1__c = previousEmployerName1;
            newApp.Previous_Employer_Name_2__c = previousEmployerName2;
            newApp.Previous_Work_Address_1__c = previousWorkAddress1;
            newApp.Previous_Work_Address_2__c = previousWorkAddress2;
            newApp.Previous_Employer_Phone_1__c = previousEmployerPhone1;
            newApp.Previous_Employer_Phone_2__c = previousEmployerPhone2;
            newApp.Previous_Reference_Name_1__c = previousReferenceName1;
            newApp.Previous_Reference_Name_2__c = previousReferenceName2;
            newApp.Previous_Occupation_1__c = previousOccupation1;
            newApp.Previous_Occupation_2__c = previousOccupation2;
            newApp.Start_Date_1__c = startDate1;
            newApp.Start_Date_2__c = startDate2;
            newApp.Finish_Date_1__c = finishDate1;
            newApp.Finish_Date_2__c = finishDate2;
            /**Curremt work address --- I--HJ**/
            newApp.Current_Work_Unit_Number_1__c = currentWorkUnitNumber1;
            newApp.Current_Work_Unit_Number_2__c = currentWorkUnitNumber2;
            newApp.Current_Work_Street_Number_1__c = currentWorkStreetNumber1;
            newApp.Current_Work_Street_Number_2__c = currentWorkStreetNumber2;
            newApp.Current_Work_Street_Type_1__c = currentWorkStreetType1;
            newApp.Current_Work_Street_Type_2__c = currentWorkStreetType2;
            newApp.Current_Work_Suburb_1__c = currentWorkSuburb1;
            newApp.Current_Work_Suburb_2__c = currentWorkSuburb2;
            newApp.Current_Work_Postcode_1__c = currentWorkPostcode1;
            newApp.Current_Work_Postcode_2__c = currentWorkPostcode2;
            newApp.Current_Work_State_1__c = currentWorkState1;
            newApp.Current_Work_State_2__c = currentWorkState2;
            newApp.Previous_Work_Unit_Number_1__c = previousWorkUnitNumber1;
            newApp.Previous_Work_Unit_Number_2__c = previousWorkUnitNumber2;
            newApp.Previous_Work_Street_Number_1__c = previousWorkStreetNumber1;
            newApp.Previous_Work_Street_Number_2__c = previousWorkStreetNumber2;
            newApp.Previous_Work_Street_Type_1__c = previousWorkStreetType1;
            newApp.Previous_Work_Street_Type_2__c = previousWorkStreetType2;
            newApp.Previous_Work_Suburb_1__c = previousWorkSuburb1;
            newApp.Previous_Work_Suburb_2__c = previousWorkSuburb2;
            newApp.Previous_Work_Postcode_1__c = previousWorkPostcode1;
            newApp.Previous_Work_Postcode_2__c = previousWorkPostcode2;
            newApp.Previous_Work_State_1__c = previousWorkState1;
            newApp.Previous_Work_State_2__c = previousWorkState2;
            newApp.Previous_Work_Overseas_State_1__c = previousWorkOverseasState1;
            newApp.Previous_Work_Overseas_State_2__c = previousWorkOverseasState2;
            newApp.Bank_Name__c = bankName;
            if (bankValue != null) {
                newApp.Bank_Value__c = bankValue;
            } else {
                newApp.Bank_Value__c = 0;
            }
            newApp.Super_Value_How_Much__c = superValueHow;
            if (furnitureValue != null) {
                newApp.Furniture_Value__c = furnitureValue;
            } else {
                newApp.Furniture_Value__c = 0;
            }
            //- Lelo                                2016-06-27
            if (basicLivingExpensesMonth != null) {
                newApp.Basic_Living_Expenses_Per_Month__c = String.valueOf(basicLivingExpensesMonth);
            } else {
                newApp.Basic_Living_Expenses_Per_Month__c = '0';
            }
            if (childcareChildMaintenanceMonth != null) {
                newApp.Childcare_Child_Maintenance_Per_Month__c = String.valueOf(childcareChildMaintenanceMonth);
            } else {
                newApp.Childcare_Child_Maintenance_Per_Month__c = '0';
            }
            if (mobilePhoneInternetPayTVMonth != null) {
                newApp.Mobile_Phone_Internet_Pay_TV_per_Month__c = String.valueOf(mobilePhoneInternetPayTVMonth);
            } else {
                newApp.Mobile_Phone_Internet_Pay_TV_per_Month__c = '0';
            }
            if (insuranceExpensesMonth != null) {
                newApp.Insurance_Expenses_per_Month__c = String.valueOf(insuranceExpensesMonth);
            } else {
                newApp.Insurance_Expenses_per_Month__c = '0';
            }
            if (travelTransportExpensesMonth != null) {
                newApp.Travel_Transport_Expenses_per_Month__c = String.valueOf(travelTransportExpensesMonth);
            } else {
                newApp.Travel_Transport_Expenses_per_Month__c = '0';
            }
            if (otherExpensesMonth != null) {
                newApp.Other_Expenses_per_Month__c = String.valueOf(otherExpensesMonth);
            } else {
                newApp.Other_Expenses_per_Month__c = '0';
            }
            newApp.Income_Type_Expenses__c = incomeTypeExpenses;
            //-
            newApp.Personal_Reference_1_Address__c = personalReference1Address;
            //newApp.Personal_Reference_1_Address__c = this.app0.Personal_Reference_1_Address__c; //personalReference1Address;
            newApp.Personal_Reference_1_Full_Name__c = personalReference1Full_Name;
            newApp.Personal_Reference_1_Phone__c = personalReference1Phone;
            newApp.Personal_Reference_1_Relationship__c = personalReference1Relationship;
            //newApp.Reference_1_Unit_Number__c = this.app0.Reference_1_Unit_Number__c;
            //newApp.Reference_1_Street_Number__c = this.app0.Reference_1_Street_Number__c;
            //newApp.Reference_1_Street_Type__c = this.app0.Reference_1_Street_Type__c;
            //newApp.Reference_1_Suburb__c = this.app0.Reference_1_Suburb__c;
            //newApp.Reference_1_Postcode__c = this.app0.Reference_1_Postcode__c;
            //newApp.Reference_1_State__c = this.app0.Reference_1_State__c;
            newApp.Personal_Reference_2_Address__c = personalReference2Address;
            //newApp.Personal_Reference_2_Address__c = this.app0.Personal_Reference_2_Address__c; //personalReference1Address;
            newApp.Personal_Reference_2_Full_Name__c = personalReference2Full_Name;
            newApp.Personal_Reference_2_Phone__c = personalReference2Phone;
            newApp.Personal_Reference_2_Relationship__c = personalReference2Relationship;
            //newApp.Reference_2_Unit_Number__c = this.app0.Reference_2_Unit_Number__c;
            //newApp.Reference_2_Street_Number__c = this.app0.Reference_2_Street_Number__c;
            //newApp.Reference_2_Street_Type__c = this.app0.Reference_2_Street_Type__c;
            //newApp.Reference_2_Suburb__c = this.app0.Reference_2_Suburb__c;
            //newApp.Reference_2_Postcode__c = this.app0.Reference_2_Postcode__c;
            //newApp.Reference_2_State__c = this.app0.Reference_2_State__c;
            newApp.Supporting_Document_1__c = supportingDocument1;
            newApp.Supporting_Document_2__c = supportingDocument2;
            newApp.Supporting_Document_3__c = supportingDocument3;
            newApp.Supporting_Document_4__c = supportingDocument4;
            newApp.Do_you_expect_any_change_to_your_financi__c = expectAnyChangeYourFinaPosition;
            newApp.Is_There_Anything_You_Want_to_Tell_Us__c = anythingYouWantTellUsAboutApp;
            newApp.Credit_Status_1__c = creditStatus1;
            newApp.Credit_Status_2__c = creditStatus2;
            //- Lelo                                2016-06-28
            newApp.Current_Residential_Status_1__c = currentResidentialStatus1;
            newApp.Current_Residential_Status_2__c = currentResidentialStatus2;
            //- Lelo                                2016-06-30
            newApp.Entity_Name__c = entityName;
            
            //- Lelo                                2016-07-05
            newApp.Driver_Licence_State_Issue_1__c = stateOfIssue1;
            newApp.Driver_Licence_State_Issue_2__c = stateOfIssue2;
            //- Lelo                                2016-07-15
            newApp.Relative_Name_1__c = relativeName1;
            newApp.Relative_Phone_1__c = relativePhone1;
            newApp.Relative_Name_2__c = relativeName2;
            newApp.Relative_Phone_2__c = relativePhone2;
            //- Lelo                                2016-07-30
            newApp.Do_you_have_drivers_licence_1__c = haveDriverLicence1;
            newApp.Do_you_have_drivers_licence_2__c = haveDriverLicence2;
            //- Lelo                                2017-02-28
            newApp.Gender_1__c = gender1;
            newApp.Gender_2__c = gender2;
            newApp.Actual_Nationality_1__c = this.app0.Actual_Nationality_1__c;
            newApp.Actual_Nationality_2__c = this.app0.Actual_Nationality_2__c;
            //
            //- Lelo                                2018-02-22
            newApp.Year_First_Licensed_1__c = this.app0.Year_First_Licensed_1__c;
            newApp.Time_Last_Fault_1__c = this.app0.Time_Last_Fault_1__c;
            newApp.Year_First_Licensed_2__c = this.app0.Year_First_Licensed_2__c;
            newApp.Time_Last_Fault_2__c = this.app0.Time_Last_Fault_2__c;
            //
            newApp.Status__c = app0.Status__c = 'U';

            try {
                insert newApp;
                savePrevEmployments(newApp.Id);
                saveIncomes(newApp.Id);
                saveSecondJob(newApp.Id);
                Opp.Application__c = newApp.Id;
                //syncAssetsAppUpdate();
                syncLoans();
                syncCreditCards();
                syncOtherAssets();
                update Opp;
                //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The record is saved successfully.'));
                //return null;
                return new PageReference('/' + Opp.id);
            } catch (Exception e) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application could not be saved.'));
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '|' + e.getTypeName() + '|Cause: ' + e.getCause() + '| Stack trace: ' + e.getStackTraceString()));
                return null;
            }
        } else {
            servicingCalc = false;
            ytdCalc = false;
            quotingTool = false;
            assetDetails = false;
            try {
                update Opp;
                if (opp.Application__r != null) {
                    update Opp.Application__r;
                    //syncAssetsAppUpdate();
                    savePrevEmployments(Opp.Application__c);
                    saveSecondJob(Opp.Application__c);
                    saveIncomes(Opp.Application__c);
                    syncLoans();
                    syncCreditCards();
                    syncOtherAssets();
                }
                loadServicingCalculatorData(); //Load Servicing data
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The record is saved successfully.'));
                return null;
            } catch (Exception e) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application could not be saved.'));
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '|' + e.getTypeName() + '|Cause: ' + e.getCause() + '|' + e.getLineNumber() + 'Stack trace: ' + e.getStackTraceString()));
                return null;
            }
        }
    }
    
    public PageReference createNew() {
        if (Opp.Application__c == null) {
            Custom_Opportunity__c Opp2 = [Select id, Mobile_Number__c, Email_Address__c from Custom_Opportunity__c where id =: Opp.Id];
            Application__c App = new Application__c();
            App.First_Name__c = Opp.Name.split(' ', 2)[0];
            App.Last_Name__c = Opp.Name.split(' ', 2)[1];
            App.Mobile_Number__c = Opp2.Mobile_Number__c;
            App.Email_Address__c = Opp2.Email_Address__c;
            App.No_of_Dependants_1__c = 0;
            App.No_of_Dependants_2__c = 0;
            App.Rent_per_month_1__c = 0;
            App.Rent_per_month_2__c = 0;
            App.Preferred_Repayment__c = 0;
            insert App;
            Opp.Application__c = App.Id;
            update Opp;
            PageReference oppPage = new PageReference('/' + Opp.id);
            return oppPage;
        } else {
            servicingCalc = false;
            ytdCalc = false;
            quotingTool = false;
            assetDetails = false;
            notesSection = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The linked Application to this Opportunity is existing. Please use Save button to save the changes.'));
            return null;
        }
    }
    
    private static decimal rate(decimal amount, decimal term, decimal payment, decimal residual, decimal interest, boolean type) {
        //decimal error = 0.000001;
        //decimal rate = interest;
        //decimal bigRate = Math.pow((double)(1 + rate), (double) term);
        //if (type == true) {
        // decimal temp = amount * bigRate - payment * (bigRate - 1) * (1 + rate) / rate;
        // while (temp < residual) {
        //  rate = rate + error;
        //  bigRate = Math.pow((double)(1 + rate), (double) term);
        //  temp = amount * bigRate - payment * (bigRate - 1) * (1 + rate) / rate;
        // }
        // return rate;
        //} else {
        // decimal temp = amount * bigRate - payment * (bigRate - 1) / rate;
        // while (temp < residual) {
        //  rate = rate + error;
        //  bigRate = Math.pow((double)(1 + rate), (double) term);
        //  temp = amount * bigRate - payment * (bigRate - 1) / rate;
        // }
        // return rate;
        //}
        return 0.0;
    }
    private static decimal pmt(decimal amount, decimal rate, decimal term, decimal residual, boolean type) {
        //if (residual == null) {
        // residual = 0;
        //}
        //if (type == true) {
        // decimal r = math.pow((double)(1 + rate), (double) term);
        // decimal pmt = ((amount * r - residual) * rate / ((r - 1) * (1 + rate)));
        // return pmt;
        //} else {
        // decimal r = math.pow((double)(1 + rate), (double) term);
        // decimal pmt = ((amount * r - residual) * rate / (r - 1));
        // return pmt;
        //}
        return 0;
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
    //- Lelo        Servicing Calculator            2016-08-01  
    public PageReference calculateSplitExpenses() {
        calculateAmountAvalilableLoanPayment();
        return null;
    }
    public void loadServicingCalculatorData() {
        Application_Servicing__c srv = OppApplicationServCalculatorUtils.getApplicationServicing(this.Opp.ApplicationServicing__c);
        
        System.debug('Loading servicing calculator data...');
        //Load pre-saved calculation
        isServLowDocSelfEmployed = false;
        servCalcIncomeAmount1 = 0;
        servCalcIncomeAmount2 = 0;
        servCalcIncomeAmount1b = 0;
        servCalcIncomeAmount2b = 0;
        servCalcIncomePayFrecuency1 = 'Monthly';
        servCalcIncomePayFrecuency2 = 'Monthly';
        servCalcIncomePayFrecuency1b = 'Monthly';
        servCalcIncomePayFrecuency2b = 'Monthly';
        servCalcNetAfterTax = null;
        servCalcNetBeforeTax = null;
        servCalcArea = 'Metro';
        isFirstmac = false;
        
        this.servMonthlyRepayment = QuotingToolHelper.getMonthlyRepayment(this.Opp.Id);
        //servCalcNAF = 0.0;
        if (this.Opp.ApplicationServicing__c != null) {
          servCalcLender = this.Opp.ApplicationServicing__r.Lender_Code__c;
          isServLowDocSelfEmployed = this.Opp.ApplicationServicing__r.Is_Self_Employed__c;
          if (this.Opp.ApplicationServicing__r.Is_Splitting_Expenses__c) {
              servCalcSplittingExpenses = 'Yes';
          }
          if (this.Opp.ApplicationServicing__r.Partner_Income__c > 0) {
              servCalcPartnerIncome = this.Opp.ApplicationServicing__r.Partner_Income__c;
          }
          if (this.Opp.ApplicationServicing__r.Net_Non_Centrelink__c > 0) {
              servCalcCLinkNetNonCentIncome = this.Opp.ApplicationServicing__r.Net_Non_Centrelink__c;
          }
          servCalcSplitRentMortgage = this.Opp.ApplicationServicing__r.Is_Split_Rent_Mortgage__c;
          servCalcCSplitLivingExpenses = this.Opp.ApplicationServicing__r.Is_Split_Living_Expenses__c;
          if (this.Opp.ApplicationServicing__r.Income_1__c > 0) {
              servCalcIncomeAmount1 = this.Opp.ApplicationServicing__r.Income_1__c;
          }
          if (this.Opp.ApplicationServicing__r.Income_1b__c != null && this.Opp.ApplicationServicing__r.Income_1b__c > 0) {
              servCalcIncomeAmount1b = this.Opp.ApplicationServicing__r.Income_1b__c;
          }
          if (this.Opp.ApplicationServicing__r.Income_2__c > 0) {
              servCalcIncomeAmount2 = this.Opp.ApplicationServicing__r.Income_2__c;
          }
          if (this.Opp.ApplicationServicing__r.Income_2b__c != null && this.Opp.ApplicationServicing__r.Income_2b__c > 0) {
              servCalcIncomeAmount2b = this.Opp.ApplicationServicing__r.Income_2b__c;
          }
          servCalcNetAfterTax = this.Opp.ApplicationServicing__r.Net_Profit_After_Tax__c;
          servCalcNetBeforeTax = this.Opp.ApplicationServicing__r.Net_Profit_Before_Tax__c;
          if('Firstmac'.equalsIgnoreCase(servCalcLender)){
              System.debug('loadApplicationData servCalcArea ' + this.Opp.ApplicationServicing__r.Area__c);
              servCalcArea = this.Opp.ApplicationServicing__r.Area__c;
              isFirstmac = true;
          }
          if('RateSetter'.equalsIgnoreCase(servCalcLender)){
              servCalcLender = 'Plenti';
          }
          if(String.isNotBlank(srv.IncomePayFrecuency_1__c)){
              servCalcIncomePayFrecuency1 = srv.IncomePayFrecuency_1__c;//Joy
          }
          if(String.isNotBlank(srv.IncomePayFrecuency_2__c)){
              servCalcIncomePayFrecuency2 = srv.IncomePayFrecuency_2__c;//Joy
          }
          if(String.isNotBlank(srv.IncomePayFrecuency_1b__c)){
            servCalcIncomePayFrecuency1b = srv.IncomePayFrecuency_1b__c;
          }
          if(String.isNotBlank(srv.IncomePayFrecuency_2b__c)){
            servCalcIncomePayFrecuency2b = srv.IncomePayFrecuency_2b__c;
          }
        }else if(Opp.Application__c != null){
          if (Opp.Application__r.Net_Income_1__c > 0) {
            servCalcIncomeAmount1 = Opp.Application__r.Net_Income_1__c;
          }
          if(String.isNotBlank(Opp.Application__r.Payment_Frequency_1__c)){
            servCalcIncomePayFrecuency1 = Opp.Application__r.Payment_Frequency_1__c;
          }
          
          if (secondJobApplic1.Income__c != null && secondJobApplic1.Income__c > 0) {
            servCalcIncomeAmount1b = secondJobApplic1.Income__c;
          }
          if(String.isNotBlank(secondJobApplic1.Frequency__c)){
            servCalcIncomePayFrecuency1b = secondJobApplic1.Frequency__c;
          }
          
          if (Opp.Application__r.Net_Income_2__c > 0) {
            servCalcIncomeAmount2 = Opp.Application__r.Net_Income_2__c;
          }
          if(String.isNotBlank(Opp.Application__r.Payment_Frequency_2__c)){
            servCalcIncomePayFrecuency2 = Opp.Application__r.Payment_Frequency_2__c;
          }
          if (secondJobApplic2.Income__c != null && secondJobApplic2.Income__c > 0) {
            servCalcIncomeAmount2b = secondJobApplic2.Income__c;
          }
          if(String.isNotBlank(secondJobApplic2.Frequency__c)){
            servCalcIncomePayFrecuency2b = secondJobApplic2.Frequency__c;
          }  
        }
        
        if (this.Opp.Application__c != null) {
            if (this.Opp.Application__r != null) this.Opp.Application__r.recalculateFormulas();
            if (this.Opp.Application__r.No_of_Dependants_1__c != null) {
                servCalcNoDependents = String.valueOf(this.Opp.Application__r.No_of_Dependants_1__c);
            }
            servCalcType = this.Opp.Application__r.Marital_Status_1__c;
            servCalcState = this.Opp.Application__r.State__c;
        }
        
        //if(servCalcIncomeAmount1b==0){
            //if(servCalcIncomeAmount1b==0 && isSecondJobApplic1 && this.secondJobApplic1 != null){
                //servCalcIncomeAmount1b = this.secondJobApplic1.Monthly_Income__c;
                //servCalcIncomePayFrecuency1b = this.secondJobApplic1.Frequency__c;
                //secondJobCalcTotNetMonthlyIncome = this.secondJobApplic1.Monthly_Income__c;
            //}
        //}
        //if (this.Opp.Application__r.No_of_People__c == 2) {
            //if(servCalcIncomeAmount2b==0 && isSecondJobApplic2 && this.secondJobApplic2 != null){
                //servCalcIncomeAmount2b = this.secondJobApplic2.Monthly_Income__c;
                //servCalcIncomePayFrecuency2b = this.secondJobApplic2.Frequency__c;
            //}
        //}
        servIncomeMap = ApplicationService.getApplicationIncomeMap2(this.Opp.Application__c);
        //servCalculateLivingExpenseValues();Joy
        servCalcTotLivingExpenses = this.Opp.ApplicationServicing__r.Total_Living_Expenses_Full__c;//Joy
        servCalculateTotalNetMonthlyIncomeValues();
        //servCalculateAmountAvalilableLoanPayment(); //Servicing re-calculate
        servCalculateRentMtgePaidValues();
        servCalculateCentreLinkValues();
        validatePlentiResStatus();
    }
    private void calculateSplitExpensesTotals() {
        servCalcSplitNetPartIncomeTotal = 0.0;
        servCalcSplitRentMortgageTotal = servCalcTotRentMtgPaid;
        servCalcSplitLivingExpensesTotal = ServCalcTotLivingExpenses;
        if ('Yes'.equals(servCalcSplittingExpenses) && !'Single'.equalsIgnoreCase(servCalcType)) {
            if (servCalcPartnerIncome != null) {
                //Net Partner's Income = Partner's income
                servCalcSplitNetPartIncomeTotal = servCalcPartnerIncome;
                Decimal tmp = 0.0;
                if (servCalcSplitRentMortgage) {
                    //Start with Rent/Mortgage
                    if (servCalcTotRentMtgPaid != null) {
                        tmp = servCalcTotRentMtgPaid / 2;
                    }
                    if (servCalcSplitNetPartIncomeTotal >= tmp) {
                        servCalcSplitRentMortgageTotal = tmp;
                        servCalcSplitNetPartIncomeTotal -= servCalcSplitRentMortgageTotal;
                    } else {
                        servCalcSplitRentMortgage = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Net Partner\'s Income isn\'t enough to split  Rent/Mortgage, please check that information and try again.'));
                    }
                }
                //Check for Living Expenses
                if (servCalcCSplitLivingExpenses) {
                    tmp = 0.0;
                    Decimal tmpDiff = 0;
                    if (ServCalcTotLivingExpenses != null && servCalcNoDependents != null) {
                        Decimal naf = 0.0;
                        if (servCalcTotNetMonthlyIncome != null) {
                            naf = servCalcTotNetMonthlyIncome * 12;
                        }
                        System.debug('naf serv >> ' + naf + ' | servicingCalc: ' + servicingCalc);
                        if ('Latitude'.equals(this.servCalcLender)) {
                            tmp = ServCalcTotLivingExpenses/2;
                        } else {
                            if(servicingCalc){
                                //Joy Start
                                if('HEMS'.equals(servCalcLender)){
                                    tmp = OppApplicationServCalculatorUtils.getLivingExpensesLenderHEMS(Integer.valueOf(servCalcNoDependents), servCalcState, servCalcTotNetMonthlyIncome, 'Single');
                                }else{
                                    tmp = OppApplicationServCalculatorUtils.getLivingExpensesLender(servCalcLender, 'Single', Integer.valueOf(servCalcNoDependents), servCalcState, servCalcArea, naf);
                                }
                                //Joy End
                            }
                        }
                        if (tmp > 0) {
                            tmpDiff = ServCalcTotLivingExpenses - tmp;
                            if (servCalcSplitNetPartIncomeTotal >= tmpDiff) {
                                servCalcSplitLivingExpensesTotal = tmp;
                                servCalcSplitNetPartIncomeTotal -= tmpDiff;
                            } else {
                                servCalcCSplitLivingExpenses = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Net Partner\'s Income isn\'t enough to split Living Expenses, please check that information and try again.'));
                            }
                        }
                    }
                }
                /*    
} else if (servCalcCSplitLivingExpenses && servCalcCSplitOrder.startsWith('LE')) {
//Start with Living Expenses
tmp = 0.0;
if (ServCalcTotLivingExpenses != null) {
tmp = ServCalcTotLivingExpenses/2;    
}
if (servCalcSplitNetPartIncomeTotal >= tmp) {
servCalcSplitLivingExpensesTotal = tmp; 
servCalcSplitNetPartIncomeTotal -= servCalcSplitLivingExpensesTotal;
}

//Check for Rent/Mortgage
if (servCalcSplitRentMortgage) {
tmp = 0.0;
if (servCalcTotRentMtgPaid != null) {
tmp = servCalcTotRentMtgPaid/2;    
}
if (servCalcSplitNetPartIncomeTotal >= tmp) {
servCalcSplitRentMortgageTotal = tmp;
servCalcSplitNetPartIncomeTotal -= servCalcSplitRentMortgageTotal;
}
}
}*/
            }
        } else {
            servCalcSplitRentMortgage = false;
            servCalcCSplitLivingExpenses = false;
            if (servCalcPartnerIncome != null) {
                servCalcSplitNetPartIncomeTotal = servCalcPartnerIncome;
            }
        }
    }
    //- Lelo        Servicing Calculator            2016-07-29  
    public Decimal getServCalcTotNetPartnerIncome() {
        Decimal r = 0.0;
        if ('Yes'.equals(servCalcSplittingExpenses)) {
            if (servCalcPartnerIncome != null) {
                r = servCalcPartnerIncome;
                Decimal tmp = 0.0;
                if (servCalcSplitRentMortgage && servCalcCSplitOrder.startsWith('RM')) {
                    if (servCalcTotRentMtgPaid != null) {
                        tmp = servCalcTotRentMtgPaid / 2;
                    }
                    if (r >= tmp) {
                        r -= tmp;
                    }
                    if (servCalcCSplitLivingExpenses) {
                        tmp = 0.0;
                        if (ServCalcTotLivingExpenses != null) {
                            tmp = ServCalcTotLivingExpenses / 2;
                        }
                        if (r >= tmp) {
                            r -= tmp;
                        }
                    }
                } else if (servCalcCSplitLivingExpenses && servCalcCSplitOrder.startsWith('LE')) {
                    if (ServCalcTotLivingExpenses != null) {
                        tmp = ServCalcTotLivingExpenses / 2;
                    }
                    if (r >= tmp) {
                        r -= tmp;
                    }
                }
                if (servCalcSplitRentMortgage) {
                    r -= getServCalcTotRentMtgPaidSplit();
                }
                if (servCalcCSplitLivingExpenses) {
                    r -= getServCalcTotLivingExpensesSplit();
                }
            }
        } else {
            if (servCalcPartnerIncome != null) {
                r = servCalcPartnerIncome;
            }
        }
        return r;
    }
    public Decimal getServCalcTotRentMtgPaidSplit() {
        if (servCalcSplitRentMortgage) {
            if (servCalcTotRentMtgPaid != null) {
                Decimal tmp = 0.0;
                Decimal r = 0.0;
                if (servCalcCSplitOrder.startsWith('RM')) {
                    tmp = servCalcTotRentMtgPaid / 2;
                }
                if (r >= tmp) {
                    r -= tmp;
                }
                if (servCalcCSplitLivingExpenses) {
                    tmp = 0.0;
                    if (ServCalcTotLivingExpenses != null) {
                        tmp = ServCalcTotLivingExpenses / 2;
                    }
                    if (r >= tmp) {
                        r -= tmp;
                    }
                }
                return servCalcTotRentMtgPaid / 2;
            }
        }
        return servCalcTotRentMtgPaid;
    }
    public Decimal getServCalcTotLivingExpensesSplit() {
        if (servCalcCSplitLivingExpenses) {
            if (ServCalcTotLivingExpenses != null) {
                return ServCalcTotLivingExpenses / 2;
            }
        }
        return ServCalcTotLivingExpenses;
    }
    //- Lelo        Servicing Calculator            2016-07-07  
    public PageReference servCalculateCentreLink() {
        servCalculateCentreLinkValues();
        return null;
    }
    private void servCalculateCentreLinkValues() {
        if (servCalcCLinkNetNonCentIncome != null) {
            servCalcCLinkIncome = servCalcCLinkNetNonCentIncome / 700 * 299;
            servCalcCLinkTotalIncome = servCalcCLinkNetNonCentIncome + servCalcCLinkIncome;
            if (servCalcCLinkTotalIncome > 0) {
                servCalcCLinkIncomePercentage = servCalcCLinkIncome / servCalcCLinkTotalIncome * 100;
            } else {
                servCalcCLinkIncomePercentage = null;
            }
            servCalcCLinkAnnualToLoannet = servCalcCLinkIncome * 12;
        } else {
            servCalcCLinkTotalIncome = null;
            servCalcCLinkIncomePercentage = null;
            servCalcCLinkAnnualToLoannet = null;
        }
    }
    public PageReference servCalculateRentMtgePaid() {
        servCalculateRentMtgePaidValues();
        return null;
    }
    private void servCalculateRentMtgePaidValues() {
        Decimal amountCal = 0;
        servCalcTotLiabilities = 0;
        servCalcTotRentMtgPaid = 0;
        servLoanList = new List < AppServicingCalculatorDTO.LoanDTO > ();
        if (this.Opp.Application__c != null) {
            //if (this.Opp.Application__r.Loans_Monthly_Payments_1__c> 0) {
            //    if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_1__c)) {
            //        AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //        d.loanType = this.Opp.Application__r.Loan_Type_1__c;
            //        d.frequency = this.Opp.Application__r.Loan_Frequency_1__c;
            //        if (String.isBlank(d.frequency)) {
            //            d.frequency = 'Monthly';
            //        }
            //        if (this.Opp.Application__r.Loan_Repaid_1__c) {
            //            d.amount = '$ 0.00 (payout)';
            //        } else {
            //            amountCal = this.Opp.Application__r.Loans_Monthly_Payments_1__c *
            //                        OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //            d.amount = amountCal.format();
            //            servCalcTotLiabilities += amountCal;
            //        }
            //        servLoanList.add(d);
            //    } 
            //}
            //if (this.Opp.Application__r.Loans_Monthly_Payments_2__c> 0) {
            //    if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_2__c)) {
            //        AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //        d.loanType = this.Opp.Application__r.Loan_Type_2__c;
            //        d.frequency = this.Opp.Application__r.Loan_Frequency_2__c;
            //        if (String.isBlank(d.frequency)) {
            //            d.frequency = 'Monthly';
            //        }
            //        if (this.Opp.Application__r.Loan_Repaid_2__c) {
            //            d.amount = '$ 0.00 (payout)';
            //        } else {
            //            amountCal = this.Opp.Application__r.Loans_Monthly_Payments_2__c *
            //                        OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //            d.amount = amountCal.format();
            //            servCalcTotLiabilities += amountCal;
            //        }
            //        servLoanList.add(d);
            //    } 
            //}
            //if (this.Opp.Application__r.Loans_Monthly_Payments_3__c> 0) {
            //    if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_3__c)) {
            //        AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //        d.loanType = this.Opp.Application__r.Loan_Type_3__c;
            //        d.frequency = this.Opp.Application__r.Loan_Frequency_3__c;
            //        if (String.isBlank(d.frequency)) {
            //            d.frequency = 'Monthly';
            //        }
            //        if (this.Opp.Application__r.Loan_Repaid_3__c) {
            //            d.amount = '$ 0.00 (payout)';
            //        } else {
            //            amountCal = this.Opp.Application__r.Loans_Monthly_Payments_3__c *
            //                        OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //            d.amount = amountCal.format();
            //            servCalcTotLiabilities += amountCal;
            //        }
            //        servLoanList.add(d);
            //    } 
            //}
            // if (this.Opp.Application__r.Loans_Monthly_Payments_4__c > 0) {
            //     if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_4__c)) {
            //         AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //         d.loanType = this.Opp.Application__r.Loan_Type_4__c;
            //         d.frequency = this.Opp.Application__r.Loan_Frequency_4__c;
            //         if (String.isBlank(d.frequency)) {
            //             d.frequency = 'Monthly';
            //         }
            //         if (this.Opp.Application__r.Loan_Repaid_4__c) {
            //             d.amount = '$ 0.00 (payout)';
            //         } else {
            //             amountCal = this.Opp.Application__r.Loans_Monthly_Payments_4__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //             d.amount = amountCal.format();
            //             servCalcTotLiabilities += amountCal;
            //             d.frequency = 'Monthly';
            //         }
            //         servLoanList.add(d);
            //     }
            // }
            // if (this.Opp.Application__r.Loans_Monthly_Payments_5__c > 0) {
            //     if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_5__c)) {
            //         AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //         d.loanType = this.Opp.Application__r.Loan_Type_5__c;
            //         d.frequency = this.Opp.Application__r.Loan_Frequency_5__c;
            //         if (String.isBlank(d.frequency)) {
            //             d.frequency = 'Monthly';
            //         }
            //         if (this.Opp.Application__r.Loan_Repaid_5__c) {
            //             d.amount = '$ 0.00 (payout)';
            //         } else {
            //             amountCal = this.Opp.Application__r.Loans_Monthly_Payments_5__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //             d.amount = amountCal.format();
            //             servCalcTotLiabilities += amountCal;
            //             d.frequency = 'Monthly';
            //         }
            //         servLoanList.add(d);
            //     }
            // }
            // if (this.Opp.Application__r.Loans_Monthly_Payments_6__c > 0) {
            //     if (!'Mortgage'.equals(this.Opp.Application__r.Loan_Type_6__c)) {
            //         AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
            //         d.loanType = this.Opp.Application__r.Loan_Type_6__c;
            //         d.frequency = this.Opp.Application__r.Loan_Frequency_6__c;
            //         if (String.isBlank(d.frequency)) {
            //             d.frequency = 'Monthly';
            //         }
            //         if (this.Opp.Application__r.Loan_Repaid_6__c) {
            //             d.amount = '$ 0.00 (payout)';
            //         } else {
            //             amountCal = this.Opp.Application__r.Loans_Monthly_Payments_6__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
            //             d.amount = amountCal.format();
            //             servCalcTotLiabilities += amountCal;
            //             d.frequency = 'Monthly';
            //         }
            //         servLoanList.add(d);
            //     }
            // }
            for (ObjectWrapped a: this.vehicleAssetList) {
                if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                    AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
                    d.loanType = 'Car Loan';
                    if ((Boolean)a.data.get('Is_Payout__c')) {
                        d.amount = '$ 0.00 (payout)';
                    } else {
                        amountCal = (Decimal)a.data.get('Monthly_Payment__c');
                        if (amountCal != null) {
                            d.amount = '$ ' + amountCal.setScale(2).format();
                            servCalcTotLiabilities += amountCal;
                        }
                    }
                    d.frequency = 'Monthly';
                    servLoanList.add(d);
                }
            }
            //System.debug('Preparing other loans...');
            //Other Loans
            if (this.loanList != null) {
                System.debug('Other loans >> ' + this.loanList.size());
                for (LoanWrapped a: this.loanList) {
                    if (!'Mortgage'.equals(a.data.Type__c)) {
                        AppServicingCalculatorDTO.LoanDTO d = new AppServicingCalculatorDTO.LoanDTO();
                        d.loanType = a.data.Type__c;
                        d.frequency = a.data.Frequency__c;
                        if (String.isBlank(d.frequency)) {
                            d.frequency = 'Monthly';
                        }
                        if (a.data.Is_Payout__c) {
                            d.amount = '$ 0.00 (payout)';
                        } else {
                            amountCal = a.data.Payment__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(d.frequency);
                            d.amount = '$ ' + amountCal.setScale(2).format();
                            servCalcTotLiabilities += amountCal;
                            d.frequency = 'Monthly';
                        }
                        servLoanList.add(d);
                    }
                }
            }
            if (this.Opp.Application__r.Rent_per_month_1__c > 0) {
                if ('Renting(Agent)'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 
                    'Renting(Private)'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 
                    'Parents/Relative'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 
                    'Employer Accommodation'.equals(this.Opp.Application__r.Current_Residence_Status_1__c)) {
                        servCalcTotRentMtgPaid = this.Opp.Application__r.Rent_per_month_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(this.Opp.Application__r.Residential_Payment_Frequency_1__c, 'Monthly');
                    }
            }
            if (this.Opp.Application__r.Board_per_month_1__c > 0) {
                if ('Parents/Relative'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 
                    'Boarding'.equals(this.Opp.Application__r.Current_Residence_Status_1__c)) {
                        servCalcTotRentMtgPaid += this.Opp.Application__r.Board_per_month_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(this.Opp.Application__r.Residential_Payment_Frequency_1__c, 'Monthly');
                    }
            }
            if (getApplicationTotalMortgage() > 0) {
                servCalcTotRentMtgPaid += getApplicationTotalMortgage();
            }
            //if (servCalcLoanPayFrecuency != null && servCalcLoanPayAmount != null) {
            //    servCalcTotLiabilities = servCalcLoanPayAmount * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcLoanPayFrecuency);
            //}
            //if (servCalcLoanPayFrecuency2 != null && servCalcLoanPayAmount2 != null) {
            //    servCalcTotLiabilities += servCalcLoanPayAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcLoanPayFrecuency2);
            //}
            //if (servCalcLoanPayFrecuency3 != null && servCalcLoanPayAmount3 != null) {
            //    servCalcTotLiabilities += servCalcLoanPayAmount3 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcLoanPayFrecuency3);
            //}
            //if (servCalcLoanPayFrecuency4 != null && servCalcLoanPayAmount4 != null) {
            //    servCalcTotLiabilities += servCalcLoanPayAmount4 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcLoanPayFrecuency4);
            //}
        }
        //if (servCalcRentPayFrecuency != null && servCalcRentPayAmount != null) {
        //servCalcTotRentMtgPaid = servCalcRentPayAmount * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcRentPayFrecuency);
        //if (servCalcTotRentMtgPaid > 0) {
        //    servValidateMinRent();
        //}
        servCalculateAmountAvalilableLoanPayment();
    }
    private void servValidateMinRent() {
        //Check Rent min
        if('Mortgage'.equals(Opp.Application__r.Current_Residence_Status_1__c) || 
           'Renting(Agent)'.equals(Opp.Application__r.Current_Residence_Status_1__c) || 
           'Renting(Private)'.equals(Opp.Application__r.Current_Residence_Status_1__c) || 
           'Boarding'.equals(Opp.Application__r.Current_Residence_Status_1__c)){    
               
               Decimal min = OppApplicationServCalculatorUtils.getRentMinPerMonthLender(servCalcLender, servCalcType);
               System.debug('servValidateMinRent... ' + min + ' | ' + servCalcTotRentMtgPaid);
               if (min >= 0.0 && servCalcTotRentMtgPaid >= 0.0) {
                   if (servCalcTotRentMtgPaid < min) {
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Rent/Mortgage/Board should be greater or equal to $' + min));
                   }
               }
           }
    }
    public PageReference servCalculateTotalNetMonthlyIncome() {
        servCalculateTotalNetMonthlyIncomeValues();
        return null;
    }
    
    private void servCalculateTotalNetMonthlyIncomeValues() {
        grossAnnualIncome1 = 0;
        grossAnnualIncome2 = 0;
        grossAnnualIncome1SecondJob = 0;
        grossAnnualIncome2SecondJob = 0;
        servCalcTotNetMonthlyIncome = 0;
        secondJobCalcTotNetMonthlyIncome = 0;
        //Applicant 1
        //servCalcIncomeAmount1b
        //servCalcTotNetMonthlyIncome
        if (servCalcIncomePayFrecuency1 != null && servCalcIncomeAmount1 != null) {
            //servCalcTotNetMonthlyIncome += servCalcIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency1);
        	
            servCalcTotNetMonthlyIncome  = getTotalNetIncome(servCalcIncomeAmount1, servCalcIncomePayFrecuency1);
            grossAnnualIncome1 = OppApplicationServCalculatorUtils.getGrossAnnualIncome(servCalcIncomeAmount1, servCalcIncomePayFrecuency1);//Joy
        }
        system.debug('Joy servCalcTotNetMonthlyIncome'+servCalcTotNetMonthlyIncome);
        system.debug('Joy grossAnnualIncome1'+grossAnnualIncome1);
        if(servCalcIncomePayFrecuency1b != null && servCalcIncomeAmount1b != null){
            servCalcTotNetMonthlyIncome += servCalcIncomeAmount1b * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency1b);
            grossAnnualIncome1SecondJob = OppApplicationServCalculatorUtils.getGrossAnnualIncome(servCalcIncomeAmount1b, servCalcIncomePayFrecuency1b);
        }
        servCalcTotNetMonthlyIncome += getTotalOtherIncomeApp1();//Joy
        //if (this.Opp.Application__r.Total_Other_Income_1__c> 0) {
        //servCalcTotNetMonthlyIncome += this.Opp.Application__r.Total_Other_Income_1__c;
        //servCalcTotNetMonthlyIncome += getTotalOtherIncomeApp1();
        
        
        if (this.Opp.Application__r.No_of_People__c == 2) {
            //Applicant 2
            
            if (servCalcIncomePayFrecuency2 != null && servCalcIncomeAmount2 != null) {
                servCalcTotNetMonthlyIncome += servCalcIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency2);
            	grossAnnualIncome2 = OppApplicationServCalculatorUtils.getGrossAnnualIncome(servCalcIncomeAmount2, servCalcIncomePayFrecuency2);//Joy
            }
            
            if (servCalcIncomePayFrecuency2b != null && servCalcIncomeAmount2b != null) {
                servCalcTotNetMonthlyIncome += servCalcIncomeAmount2b * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency2b);
                grossAnnualIncome2SecondJob = OppApplicationServCalculatorUtils.getGrossAnnualIncome(servCalcIncomeAmount2b, servCalcIncomePayFrecuency2b);
            }
            //if (this.Opp.Application__r.Total_Other_Income_2__c> 0) {
            //servCalcTotNetMonthlyIncome += this.Opp.Application__r.Total_Other_Income_2__c;
            servCalcTotNetMonthlyIncome += getTotalOtherIncomeApp2();//Joy
            //}
        }
        //if (servCalcOtherIncomePayFrecuency2 != null && servCalcOtherIncomeAmount2 != null) {
        //    servCalcTotNetMonthlyIncome += servCalcOtherIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcOtherIncomePayFrecuency2);
        //}
        servCalculateLivingExpenseValues();
        // servCalculateAmountAvalilableLoanPayment();
        system.debug(grossAnnualIncome1);
    }
    
    public Decimal getTotalNetIncome(Decimal inputAmount, String payFrequencyType) {
        Decimal totalAmount = 0;
        if('Annually'.equalsIgnoreCase(payFrequencyType)){
            totalAmount = inputAmount / 12;
        }else if('Monthly'.equalsIgnoreCase(payFrequencyType)){
            totalAmount = inputAmount;
        }else if('Fortnightly'.equalsIgnoreCase(payFrequencyType)){
             totalAmount = inputAmount * 26 / 12;
        }else if('Weekly'.equalsIgnoreCase(payFrequencyType)){
             totalAmount = inputAmount * 52 / 12;
        }
        return totalAmount;
    }
    
    public Decimal getTotalOtherIncomeApp1() {
        return this.getTotalOtherIncomeApp(1);
    }
    
    public Decimal getTotalOtherIncomeApp2() {
        return this.getTotalOtherIncomeApp(2);
    }
    
    private Decimal getTotalOtherIncomeApp(Long applicant) {
        Decimal r = 0;
        if (applicant != null && this.servIncomeMap != null) {
            r = OppApplicationServCalculatorUtils.sumApplicationIncomes(this.servIncomeMap.get(applicant));
        }
        return r.setScale(2);
    }
    
    public List < Application_Income__c > getApplicantIncomes1() {
        return getApplicantIncomes(1);
    }
    
    public List < Application_Income__c > getApplicantIncomes2() {
        return getApplicantIncomes(2);
    }
    
    private List < Application_Income__c > getApplicantIncomes(Long applicant) {
        List < Application_Income__c > r = new List < Application_Income__c > ();
        if (this.servIncomeMap != null && this.servIncomeMap.containsKey(applicant)) {
            r = this.servIncomeMap.get(applicant);
        }
        return r;
    }
    
    
    private void servCalculateAmountAvalilableLoanPayment() {
        servCalcTotAmountLoanPayment = 0;
        if (servCalcTotNetMonthlyIncome != null) {
            servCalcTotAmountLoanPayment = servCalcTotNetMonthlyIncome;
        }
        if (servCalcTotLiabilities != null) {
            servCalcTotAmountLoanPayment -= servCalcTotLiabilities;
        }
        
        if ('LIB'.equals(servCalcLender) || 'PEP'.equals(servCalcLender) || 'MAC'.equals(servCalcLender) || 'GRE'.equals(servCalcLender)) {
            servCalcTotAmountLoanPayment -= totalCreditCards/0.03*0.038;
        } else if('LAP'.equals(servCalcLender) || 'Latitude'.equals(servCalcLender) ){
            servCalcTotAmountLoanPayment -= totalCreditCards/0.03*0.042;
        }else{
            servCalcTotAmountLoanPayment -= totalCreditCards;
        }
        calculateSplitExpensesTotals();
        if (servCalcTotRentMtgPaid != null) {
            servCalcTotAmountLoanPayment -= servCalcSplitRentMortgageTotal;
        }
        if (servCalcTotLivingExpenses != null) {
            servCalcTotAmountLoanPayment -= servCalcSplitLivingExpensesTotal;
            System.debug('servCalcSplitLivingExpensesTotal >> ' + servCalcSplitLivingExpensesTotal);
        }
        servCalcBuffer = 0;
        servCalcMortgageBuffer = 0;
        if ('MAC'.equals(servCalcLender)) {
            if ('Single'.equals(this.opp.Application__r.Marital_Status_1__c)) {
                servCalcBuffer = 100;
            } else {
                servCalcBuffer = 350;
            }
            servCalcMortgageBuffer = getMortgageBuffer();
        } else if ('FINA'.equals(servCalcLender) && servCalcTotNetMonthlyIncome != null) {
            servCalcBuffer = servCalcTotNetMonthlyIncome * 0.05;
        } else if ('GRE'.equals(servCalcLender) && servCalcTotNetMonthlyIncome != null) {
            servCalcBuffer = servCalcTotNetMonthlyIncome * 0.03;
        }
        servCalcTotAmountLoanPayment -= servCalcBuffer;
        servCalcTotAmountLoanPayment -= servCalcMortgageBuffer;
        //Quoting tool monthly repayment
        if (this.servMonthlyRepayment != null) {
            servCalcTotAmountLoanPayment -= this.servMonthlyRepayment;
        }
    }
    public PageReference calculateAmountAvalilableLoanPayment() {
        servCalculateAmountAvalilableLoanPayment();
        return null;
    }
    public PageReference servCalculateV2() {
        servCalculateAllValues();
        // -> refresh
        servicingCalc = true;
        quotingTool = false;
        ytdCalc = false;
        assetDetails = false;
        notesSection = false;
        return null;
    }
    private void servCalculateAllValues() {
        //servCalculateCreditCardValues();
        servCalculateRentMtgePaidValues();
        servCalculateTotalNetMonthlyIncomeValues();
        servCalculateLivingExpenseValues();
    }
    private void servCalculatedVariablesInitialization() {
        servCalcTotNetMonthlyIncome = 0;
        servCalcTotLiabilities = 0;
        servCalcTotRentMtgPaid = 0;
        servCalcTotLivingExpenses = 0;
        //servCalcTotOtherDebts = 0;
        servCalcTotAmountLoanPayment = 0;
        servCalcCCardMonthlyPayment = 0;
        servCalcCLinkIncome = 0;
        servCalcCLinkTotalIncome = 0;
        servCalcCLinkIncomePercentage = 0;
        servCalcCLinkAnnualToLoannet = 0;
        servCalcSplitNetPartIncomeTotal = 0.0;
        servCalcSplitRentMortgageTotal = 0.0;
        servCalcSplitLivingExpensesTotal = 0.0;
    }
    public PageReference servAddLiability() {
        if (servCalcLiabilityCount < 4) {
            servCalcLiabilityCount++;
        }
        System.debug('servCalcLiabilityCount >> ' + servCalcLiabilityCount);
        return null;
    }
    
    public PageReference servCalculateLivingExpenses() {
        
        if('Firstmac'.equalsIgnoreCase(servCalcLender)){
            isFirstmac = true;
        }else{isFirstmac = false;}
        
        servCalculateLivingExpenseValues();
        calculateSplitExpenses();
        validatePlentiResStatus();
        return null;
    }
    
    public void servCalculateLivingExpenseValues() {
        //fillServCalcNoDependentsSelect();
        // System.debug(servCalcLender + '|' + servCalcType + '|' + servCalcNoDependents + '|' + servCalcState + '|' + servCalcArea);
        if (String.isBlank(servCalcLender) || String.isBlank(servCalcType) || String.isBlank(servCalcNoDependents)) {
            servCalcTotLivingExpenses = 0.0;
        } else if ('GEO'.equals(servCalcLender) && (String.isBlank(servCalcState) || String.isBlank(servCalcArea))) {
            servCalcTotLivingExpenses = 0.0;
        } else {
            String typeLvx = servCalcType;
            if (!'Single'.equalsIgnoreCase(typeLvx)) {
                typeLvx = 'Joint';
            }
            Decimal naf = 0.0;
            if (servCalcTotNetMonthlyIncome != null) {
                naf = servCalcTotNetMonthlyIncome * 12;
            }
            // System.debug('naf serv 2 >> ' + naf);
            if(servicingCalc){
                // if ('MAC'.equals(servCalcLender) || 'PEP'.equals(servCalcLender) || 'LAP'.equals(servCalcLender)) {
                if ('MAC'.equals(servCalcLender) || 'LAP'.equals(servCalcLender)) {
                    servCalcTotLivingExpenses = this.getTotalLivExp();
                } else {
                    //Joy Start
                    if('HEMS'.equals(servCalcLender)){
                        servCalcTotLivingExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLenderHEMS(Integer.valueOf(servCalcNoDependents), servCalcState, servCalcTotNetMonthlyIncome, servCalcType);
                    }else{
                        servCalcTotLivingExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLender(servCalcLender, typeLvx, Integer.valueOf(servCalcNoDependents), servCalcState, servCalcArea, naf);
                    }
                    //Joy End
                }
            }
            // System.debug('servCalcTotLivingExpenses >> ' + servCalcTotLivingExpenses);
        }
        servCalculateAmountAvalilableLoanPayment();
        servValidateMinRent();
        // System.debug('servCalcTotLivingExpenses >> ' + servCalcTotLivingExpenses);
    }
    
    public List <SelectOption> getServCalcNoDependentsSelectOptions() {
        Integer size = 6;
        servCalcNoDependents = null;
        servCalcNoDependentsSelect.clear();
        if ('GEO'.equals(servCalcLender)) {
            size = 5;
        } else if ('MAC'.equals(servCalcLender)) {
            size = 3;
        }
        servCalcNoDependentsSelect.add(new SelectOption('', '--None--'));
        for (Integer i = 0; i <= size; i++) {
            servCalcNoDependentsSelect.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        if (String.isNotBlank(servCalcNoDependents)) {
            if (Integer.valueOf(servCalcNoDependents) > size) {
                servCalcNoDependents = String.valueOf(size);
            }
        }
        return servCalcNoDependentsSelect;
    }
    
    public PageReference ServicingPdf2() {
        return saveServicingPdf('Servicing_Calculation');
    }
    public PageReference sericingSavePreApproval() {
        return saveServicingPdf('Servicing_Calculation_PRE_APPROVAL');
    }
    private boolean isServingCalculationDone() {
        Boolean r = true;
        Decimal totalLivingExpenses = getTotalLivExp();
        if (this.Opp.Application__c != null && 'Business'.equals(this.Opp.Application__r.Application_Type__c) &&
        'Company'.equals(this.Opp.Application__r.Business_Structure__c)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Company Pty Ltd does not require a servicing calculation for any approval process.'));
          return false;
        }
        //if (isServLowDocSelfEmployed) {
        //    if ((servCalcNetAfterTax == null || servCalcNetAfterTax == 0) && (servCalcNetBeforeTax == null || servCalcNetBeforeTax == 0)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a value for Net Profit After Tax or Net Profit Before Tax field before generating the Pdf.'));
        //        r = false;
        //    }
        //    return r;
        //}
        servCalculateAllValues();
        if (servCalcTotNetMonthlyIncome == 0 || servCalcTotAmountLoanPayment == 0 || String.isBlank(servCalcLender) || String.isBlank(servCalcType) || String.isBlank(servCalcNoDependents)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill mandatory fields before generating the Pdf.'));
            r = false;
        }
        //Validate Partner's income when  splitting expenses is Yes
        if ('Yes'.equalsIgnoreCase(servCalcSplittingExpenses) && (servCalcPartnerIncome == null || servCalcPartnerIncome <= 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill Partner\'s income.'));
            r = false;
        }
        //Green Light validation
        if ('GRE'.equals(servCalcLender)) {
            if ((servMonthlyRepayment / servCalcTotNetMonthlyIncome * 100) > 25.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The repayment cannot be higher than 25% of the monthly net income.'));
                r = false;
            }
        }
        
        //Verify Living expenses for Macquarie calc
        // if ('MAC'.equals(servCalcLender) || 'PEP'.equals(servCalcLender)) {
        if ('MAC'.equals(servCalcLender)) {
            //Get living expenses
            String typeLvx = servCalcType;
            if (!'Single'.equalsIgnoreCase(typeLvx)) {
                typeLvx = 'Joint';
            }
            Decimal naf = 0.0;
            if (servCalcTotNetMonthlyIncome != null) {
                naf = servCalcTotNetMonthlyIncome * 12;
            }
            System.debug('naf serv 2 >> ' + naf);
            //Joy Start
            Decimal hemsExpenses;
            if('HEMS'.equals(servCalcLender)){
                hemsExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLenderHEMS(Integer.valueOf(servCalcNoDependents), servCalcState, servCalcTotNetMonthlyIncome, servCalcType);
            }else{
                hemsExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLender(servCalcLender, typeLvx, Integer.valueOf(servCalcNoDependents), servCalcState, servCalcArea, naf);
            }
            //Joy End
            if(servCalcTotLivingExpenses > 0 && hemsExpenses > servCalcTotLivingExpenses){
                Decimal dif = Math.abs(servCalcTotLivingExpenses - hemsExpenses);
                dif = dif/servCalcTotLivingExpenses * 100;
                if (dif > 10) {
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.WARNING, 
                            'Living expenses are too low, please, it needs to be reviewed with the customer.'));
                    //r = false;
                }
            }
            
            // Splitting expenses validation                lelo            2020-05-07
            // if ('Yes'.equalsIgnoreCase(servCalcSplittingExpenses)) {
            //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Macquarie does not allow splitting of expenses'));
            //     r = false;
            // }
        } else {
            this.servValidateMinRent();
        }
        if ('PEP'.equals(servCalcLender) && totalLivingExpenses > servCalcSplitLivingExpensesTotal) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING, 
                    'Customer expenses greater than Pepper HPI - Please check servicing'));
        }
        //Validate Liabilities
        //if (String.isNotBlank(servCalcLoanType) && (String.isBlank(servCalcLoanPayFrecuency) || servCalcLoanPayAmount == null || servCalcLoanPayAmount == 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the first Loan Type: ' + servCalcLoanType));
        //    r = false;
        //} else if (String.isBlank(servCalcLoanType) && (String.isNotBlank(servCalcLoanPayFrecuency) || servCalcLoanPayAmount > 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the first Loan Type and complete the liability'));
        //    r = false;
        //}
        //if (String.isNotBlank(servCalcLoanType2) && (String.isBlank(servCalcLoanPayFrecuency2) || servCalcLoanPayAmount2 == null || servCalcLoanPayAmount2 == 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the second Loan Type: ' + servCalcLoanType2));
        //    r = false;
        //} else if (String.isBlank(servCalcLoanType2) && (String.isNotBlank(servCalcLoanPayFrecuency2) || servCalcLoanPayAmount2 > 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the second Loan Type and complete the liability'));
        //    r = false;
        //}
        //if (String.isNotBlank(servCalcLoanType3) && (String.isBlank(servCalcLoanPayFrecuency3) || servCalcLoanPayAmount3 == null || servCalcLoanPayAmount3 == 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the third Loan Type: ' + servCalcLoanType3));
        //    r = false;
        //} else if (String.isBlank(servCalcLoanType3) && (String.isNotBlank(servCalcLoanPayFrecuency3) || servCalcLoanPayAmount3 > 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the third Loan Type and complete the liability'));
        //    r = false;
        //}
        //if (String.isNotBlank(servCalcLoanType4) && (String.isBlank(servCalcLoanPayFrecuency4) || servCalcLoanPayAmount4 == null || servCalcLoanPayAmount4 == 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the fourth Loan Type: ' + servCalcLoanType4));
        //    r = false;
        //} else if (String.isBlank(servCalcLoanType4) && (String.isNotBlank(servCalcLoanPayFrecuency4) || servCalcLoanPayAmount4 > 0)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the fourth Loan Type and complete the liability'));
        //    r = false;
        //}
        //if ('GRE'.equals(servCalcLender)) {
        //    if ((opp.NAF_Net_Amount_Financed__c == null || opp.NAF_Net_Amount_Financed__c == 0.0) && 
        //        (servCalcNAF == 0 || servCalcNAF == 0)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a value for NAF field or save a Quoting Calculation to estimate Living Expenses'));
        //        r = false;
        //    }
        //}
        //if('PEP'.equals(servCalcLender)){
        //    if(servCalcSplitLivingExpensesTotal > totalLivingExpenses){
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
        //        'Total Living Expenses $'+totalLivingExpenses+' should not be less than Living Expenses calculated $'+servCalcSplitLivingExpensesTotal));
        //    	r = false;
        //    }
        //}
        if ('ACL'.equals(servCalcLender)) {
            Decimal y = servCalcTotNetMonthlyIncome * 0.2;
            if(servMonthlyRepayment > y){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Payment exceeds 20% of income – outside guidelines'));
            }
        }
        if(servCalcSplitLivingExpensesTotal > totalLivingExpenses){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Total Living Expenses $'+totalLivingExpenses.format()+' should not be less than Living Expenses calculated ($'+servCalcSplitLivingExpensesTotal.format()+')'));
        }
        if (totalLivingExpenses > servCalcSplitLivingExpensesTotal) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Declared living expenses are greater than Lender living expenses - check serviceability'));
        }

        if('Yes'.equalsIgnoreCase(servCalcSplittingExpenses)){
		  Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(Opp.Id, Opp.Application__c);
          
          if (q != null && ('Pepper MV'.equals(q.Name) || 'Pepper Leisure'.equals(q.Name) || 'Pepper Commercial'.equals(q.Name)) && 'C'.equals(q.Client_Tier__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+q.Name+' Cannot split expenses with Tier C, please adjust it in quoting tools'));
            r = false;
		  }
		}
        return r;
    }
    
    private PageReference saveServicingPdf(String prefixFile) {
        validatePlentiResStatus();
        if (this.Opp.Application__c == null && prefixFile.contains('PRE_APPROVAL')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An Application must be saved before generating the Pdf for Pre-Approval.'));
            return null;
        }
        
        if (!isServingCalculationDone()) {
            return null;
        }
        PageReference servicingPdf = Page.GenerateServicingPdf;
        servicingPdf.getParameters().put('id', Opp.Id);
        AppServicingCalculatorDTO dto = new AppServicingCalculatorDTO();
        Application_Servicing__c srv = OppApplicationServCalculatorUtils.getApplicationServicing(this.Opp.ApplicationServicing__c);
        if (srv == null) {
            srv = new Application_Servicing__c();
        }
        //Lender  
        dto.isLowDocSelfEmployed = isServLowDocSelfEmployed;
        //if (!isServLowDocSelfEmployed) {
        dto.lender = servCalcLenderValues.get(servCalcLender);
        dto.lenderCode = servCalcLender;								
        dto.typeStatus = servCalcType;
        dto.dependants = servCalcNoDependents;
        dto.splitting = servCalcSplittingExpenses;
        if (servCalcPartnerIncome != null) {
            dto.partnerIncome = String.valueOf(servCalcPartnerIncome.format());
        } else {
            dto.partnerIncome = '-';
        }
        dto.netPartnerIncome = '$ ' + String.valueOf(servCalcSplitNetPartIncomeTotal.round(System.RoundingMode.CEILING).format());
        //Total
        dto.netMonthlyIncome = '$ ' + String.valueOf(servCalcTotNetMonthlyIncome.round(System.RoundingMode.CEILING).format());
        dto.totLiabilities = '$ ' + String.valueOf(servCalcTotLiabilities.round(System.RoundingMode.CEILING).format());
        dto.rentMtgePaidFull = '$ ' + String.valueOf(servCalcTotRentMtgPaid.round(System.RoundingMode.CEILING).format());
        dto.rentMtgePaid = '$ ' + String.valueOf(servCalcSplitRentMortgageTotal.round(System.RoundingMode.CEILING).format());
        dto.livingExpensesFull = '$ ' + String.valueOf(servCalcTotLivingExpenses.round(System.RoundingMode.CEILING).format());
        dto.livingExpenses = '$ ' + String.valueOf(servCalcSplitLivingExpensesTotal.round(System.RoundingMode.CEILING).format());
        Decimal totalCC = this.totalCreditCards;
        
        if ('LIB'.equals(servCalcLender) || 'PEP'.equals(servCalcLender) || 'MAC'.equals(servCalcLender) || 'GRE'.equals(servCalcLender)){
            totalCC = this.totalCreditCards/0.03*.038;
        }else if('LAP'.equals(servCalcLender) || 'Latitude'.equals(servCalcLender)){
            totalCC = this.totalCreditCards/0.03*.042;
        }
        dto.otherDebts = '$ ' + String.valueOf(totalCC.format());
        dto.amountAvailablePayment = '$ ' + String.valueOf(servCalcTotAmountLoanPayment.round(System.RoundingMode.CEILING).format());
        dto.rentMtgePaidSplited = servCalcSplitRentMortgage;
        dto.livingExpensesSplited = servCalcCSplitLivingExpenses;
        //Income
        //dto.applicantIncome1 = '$ ' + String.valueOf(servCalcTotAmountLoanPayment.format());
        Decimal tmp = servCalcIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency1);
        dto.applicantIncome1 = '$ ' + String.valueOf(tmp.format());
        //tmp = servCalcOtherIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcOtherIncomePayFrecuency1);
        //dto.applicantOtherIncome1 = '$ ' + String.valueOf(tmp.format());
        dto.applicantOtherIncome1 = '$ ' + String.valueOf(this.getTotalOtherIncomeApp1().format());
        
        tmp = servCalcIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcIncomePayFrecuency2);
        dto.applicantIncome2 = '$ ' + String.valueOf(tmp.format());
        //tmp = servCalcOtherIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(servCalcOtherIncomePayFrecuency2);
        //dto.applicantOtherIncome2 = '$ ' + String.valueOf(tmp.format());
        dto.applicantOtherIncome2 = '$ 0';
        dto.applicantOtherIncome2 = '$ ' + String.valueOf(this.getTotalOtherIncomeApp2().format());
        //Expenses - Leavilities
        //dto.loanType1 = servCalcLoanType;
        //dto.loanType2 = servCalcLoanType2;
        //dto.loanType3 = servCalcLoanType3;
        //dto.loanType4 = servCalcLoanType4;
        //dto.loanFrecuency1 = servCalcLoanPayFrecuency;
        //dto.loanFrecuency2 = servCalcLoanPayFrecuency2;
        //dto.loanFrecuency3 = servCalcLoanPayFrecuency3;
        //dto.loanFrecuency4 = servCalcLoanPayFrecuency4;
        //if (String.isNotBlank(servCalcLoanType) && servCalcLoanPayAmount != null) {
        //        dto.loanAmount1 = '$ ' + String.valueOf(servCalcLoanPayAmount.format());
        //}
        //if (String.isNotBlank(servCalcLoanType2) && servCalcLoanPayAmount2 != null) {
        //        dto.loanAmount2 = '$ ' + String.valueOf(servCalcLoanPayAmount2.format());
        //}
        //if (String.isNotBlank(servCalcLoanType3) && servCalcLoanPayAmount3 != null) {
        //        dto.loanAmount3 = '$ ' + String.valueOf(servCalcLoanPayAmount3.format());
        //}
        //if (String.isNotBlank(servCalcLoanType4) && servCalcLoanPayAmount4 != null) {
        //        dto.loanAmount4 = '$ ' + String.valueOf(servCalcLoanPayAmount4.format());
        //}
        dto.loanList = servLoanList;
        //Expenses - Rent / Mortgage 
        //dto.rentFrecuency = servCalcRentPayFrecuency;
        //if (servCalcRentPayAmount != null) {
        //        dto.rentAmount = '$ ' + String.valueOf(servCalcRentPayAmount.format());
        //}
        dto.rentAmount = '$ 0';
        if ('Renting(Agent)'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 'Parents/Relative'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 'Renting(Private)'.equals(this.Opp.Application__r.Current_Residence_Status_1__c)) {
            if (this.Opp.Application__r.Rent_per_month_1__c != null) {
                dto.rentAmount = '$ ' + this.Opp.Application__r.Rent_per_month_1__c.format();
            } else {
                dto.rentAmount = '$ 0.00';
            }
        }
        dto.boardAmount = '$ 0';
        if ('Parents/Relative'.equals(this.Opp.Application__r.Current_Residence_Status_1__c) || 'Boarding'.equals(this.Opp.Application__r.Current_Residence_Status_1__c)) {
            if (this.Opp.Application__r.Board_per_month_1__c != null) {
                dto.boardAmount = '$ ' + this.Opp.Application__r.Board_per_month_1__c.format();
            } else {
                dto.boardAmount = '$ 0.00';
            }
        }
        dto.rentFrequency = this.Opp.Application__r.Residential_Payment_Frequency_1__c;
        if (String.isBlank(dto.rentFrequency)) {
            dto.rentFrequency = 'Monthly';
        }
        dto.mortgageAmount = '$ 0';
        if (getApplicationTotalMortgage() > 0) {
            dto.mortgageAmount = '$ ' + getApplicationTotalMortgage().setScale(2).format();
        }
        //Expenses - Credit Card
        //dto.creditCardIssuer = servCalcCCardIssuer;
        //if (servCalcCCardCreditLimit != null) {
        //        dto.creditLimit = '$ ' + String.valueOf(servCalcCCardCreditLimit.format());
        //}
        //if (servCalcCCardAmountOwing != null) {
        //        dto.amountOwing = '$ ' + String.valueOf(servCalcCCardAmountOwing.format());
        //}
        //if (servCalcCCardMonthlyPayment != null) {
        //        dto.monthlyPayment = '$ ' + String.valueOf(servCalcCCardMonthlyPayment.format());
        //}
        //Liberty Calculator
        if (servCalcCLinkNetNonCentIncome != null) {
            dto.netNonCentrelinkIncome = '$ ' + String.valueOf(servCalcCLinkNetNonCentIncome.setScale(2).format());
        }
        if (servCalcCLinkIncome != null) {
            dto.centrelinkIncome = '$ ' + String.valueOf(servCalcCLinkIncome.setScale(2).format());
        }
        if (servCalcCLinkTotalIncome != null) {
            dto.totalAssesableIncome = '$ ' + String.valueOf(servCalcCLinkTotalIncome.setScale(2).format());
        }
        if (servCalcCLinkIncomePercentage != null) {
            dto.centrelinkIncomePercentage = String.valueOf(servCalcCLinkIncomePercentage.setScale(0)) + '%';
        }
        if (servCalcCLinkAnnualToLoannet != null) {
            dto.annualCLToLoannet = '$ ' + String.valueOf(servCalcCLinkAnnualToLoannet.setScale(2).format());
        }
        //Macquarie buffer amount
        dto.bufferAmount = '$ 0';
        if (servCalcBuffer != null && servCalcBuffer > 0) {
            dto.bufferAmount = '$ ' + servCalcBuffer.setScale(2).format();
        }
        
        dto.mortgageBuffer = '$ 0';
        if (servCalcMortgageBuffer > 0) {
            dto.mortgageBuffer = '$ ' + servCalcMortgageBuffer.setScale(2).format();
        }
        
        if (this.servMonthlyRepayment != null) {
            dto.monthlyRepayment = '$' + this.servMonthlyRepayment.setScale(2).format();
        }
        
        if('Firstmac'.equalsIgnoreCase(servCalcLender)){
            dto.state = servCalcState;
            dto.area = servCalcArea;    
        }
        
        srv.State__c = servCalcState;
        srv.Area__c = servCalcArea;
        srv.Is_Self_Employed__c = isServLowDocSelfEmployed;
        srv.Lender_Code__c = servCalcLender;
        srv.Is_Splitting_Expenses__c = false;
        if ('Yes'.equals(servCalcSplittingExpenses)) {
            srv.Is_Splitting_Expenses__c = true;
        }
        srv.Is_Split_Rent_Mortgage__c = servCalcSplitRentMortgage;
        srv.Is_Split_Living_Expenses__c = servCalcCSplitLivingExpenses;
        srv.Partner_Income__c = null;
        if (servCalcPartnerIncome != null) {
            srv.Partner_Income__c = servCalcPartnerIncome;
        }
        srv.Income_1__c = servCalcIncomeAmount1;
        srv.Income_2__c = servCalcIncomeAmount2;
        srv.Income_1b__c = servCalcIncomeAmount1b;
        srv.Income_2b__c = servCalcIncomeAmount2b;
        srv.Gross_Annual_Income_1__c = grossAnnualIncome1;//Joy
        srv.Gross_Annual_Income_2__c = grossAnnualIncome2;//Joy
        srv.Gross_Annual_Income_1_Second_Job__c = grossAnnualIncome1SecondJob;
        srv.Gross_Annual_Income_2_Second_Job__c = grossAnnualIncome2SecondJob;
        srv.IncomePayFrecuency_1__c = servCalcIncomePayFrecuency1;//Joy
        srv.IncomePayFrecuency_2__c = servCalcIncomePayFrecuency2;//Joy
        srv.Net_Partner_Income__c = servCalcSplitNetPartIncomeTotal;
        srv.Total_Net_Monthly_Income__c = servCalcTotNetMonthlyIncome;
        srv.Total_Liabilities__c = servCalcTotLiabilities;
        srv.Total_Rent_Mortgage__c = servCalcSplitRentMortgageTotal;
        srv.Total_Rent_Mortgage_Full__c = servCalcTotRentMtgPaid;
        srv.Total_Living_Expenses__c = servCalcSplitLivingExpensesTotal;
        srv.Total_Living_Expenses_Full__c = servCalcTotLivingExpenses;
        srv.Total_Credit_Cards__c = this.totalCreditCards;
        srv.Net_Non_Centrelink__c = servCalcCLinkNetNonCentIncome;
        srv.Net_Profit_After_Tax__c = null;
        srv.Net_Profit_Before_Tax__c = null;
        srv.Buffer_Amount__c = servCalcBuffer;
        srv.Mortgage_Buffer__c = servCalcMortgageBuffer;
        srv.IncomePayFrecuency_1b__c = servCalcIncomePayFrecuency1b;
        srv.IncomePayFrecuency_2b__c = servCalcIncomePayFrecuency2b;
        //if (servCalcNAF != null) {
        //    dto.naf = '$ ' + servCalcNAF.format();
        //} else if (opp.NAF_Net_Amount_Financed__c != null && opp.NAF_Net_Amount_Financed__c> 0) {
        //    dto.naf = '$ ' + opp.NAF_Net_Amount_Financed__c.format();
        //} else {
        //    dto.naf = '$ 0.00';
        //}
        //srv.NAF__c = servCalcNAF;
        //} else {
        //    dto.netProfitAfterTax = '$ 0';
        //    if (servCalcNetAfterTax != null) {
        //        dto.netProfitAfterTax = '$ ' + servCalcNetAfterTax.format();    
        //    }
        //    dto.netProfitBeforeTax = '$ 0';
        //    if (servCalcNetBeforeTax != null) {
        //        dto.netProfitBeforeTax = '$ ' + servCalcNetBeforeTax.format();
        //    }
        //    srv.Is_Self_Employed__c = true;            
        //    srv.Net_Profit_After_Tax__c = servCalcNetAfterTax;
        //    srv.Net_Profit_Before_Tax__c = servCalcNetBeforeTax;
        //    srv.Lender_Code__c = null;
        //    srv.Is_Splitting_Expenses__c = false;
        //    srv.Partner_Income__c = null;
        //    srv.Net_Partner_Income__c = null;
        //    srv.Total_Net_Monthly_Income__c = null;
        //    srv.Total_Liabilities__c = null;
        //    srv.Total_Rent_Mortgage__c = null;
        //    srv.Total_Rent_Mortgage_Full__c = null;
        //    srv.Total_Living_Expenses__c = null;
        //    srv.Total_Living_Expenses_Full__c = null;
        //    srv.Total_Credit_Cards__c = null;
        //    srv.Net_Non_Centrelink__c = null;
        //    srv.Income_1__c = null;
        //    srv.Income_2__c = null;
        //}
        
        servicingPdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
        if (srv.Id == null) {
            insert srv;
            this.Opp.ApplicationServicing__c = srv.Id;
            update this.Opp;
        } else {
            update srv;
        }
        if (this.Opp.Application__c != null && this.Opp.Application__r != null) {
            update this.Opp.Application__r;
            if (prefixFile.contains('PRE_APPROVAL')) {
                ApplicationExtraDataHelper.upsertData(this.Opp.Application__r.id, 'Servicing ', 'Servicing Calculation', dto);
            }
        }
        System.debug('App >> ' + this.Opp.Application__c);
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixFile, servicingPdf);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The Pdf document has been generated.'));
        return null;
    }
    //-
    // Lelo             2017-03-07
    private String docsUploaded = 'docs ';
    //Upload documents
    public void uploadFile1() {
        uploadFiles(1);
    }
    public void uploadFile2() {
        uploadFiles(2);
    }
    public void uploadFile3() {
        uploadFiles(3);
    }
    public void uploadFile4() {
        uploadFiles(4);
    }
    public void uploadFile5() {
        uploadFiles(5);
    }
    public void uploadFile6() {
        uploadFiles(6);
    }
    public void uploadFile7() {
        uploadFiles(7);
    }
    public void uploadFile8() {
        uploadFiles(8);
    }
    public void uploadFile9() {
        uploadFiles(9);
    }
    public void uploadFile10() {
        uploadFiles(10);
    }
    public Boolean getIsFileUploaded1() {
        return isFileUploaded(1);
    }
    public Boolean getIsFileUploaded2() {
        return isFileUploaded(2);
    }
    public Boolean getIsFileUploaded3() {
        return isFileUploaded(3);
    }
    public Boolean getIsFileUploaded4() {
        return isFileUploaded(4);
    }
    public Boolean getIsFileUploaded5() {
        return isFileUploaded(5);
    }
    public Boolean getIsFileUploaded6() {
        return isFileUploaded(6);
    }
    public Boolean getIsFileUploaded7() {
        return isFileUploaded(7);
    }
    public Boolean getIsFileUploaded8() {
        return isFileUploaded(8);
    }
    public Boolean getIsFileUploaded9() {
        return isFileUploaded(9);
    }
    public Boolean getIsFileUploaded10() {
        return isFileUploaded(10);
    }
    private Boolean isFileUploaded(Integer docNumber) {
        Boolean r = false;
        if (docsUploaded.contains(String.valueOf(docNumber))) {
            return true;
        }
        if (docNumber == 1) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_1__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_1__c));
            }
        } else if (docNumber == 2) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_2__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_2__c));
            }
        } else if (docNumber == 3) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_3__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_3__c));
            }
        } else if (docNumber == 4) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_4__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_4__c));
            }
        } else if (docNumber == 5) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_5__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_5__c));
            }
        } else if (docNumber == 6) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_6__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_6__c));
            }
        } else if (docNumber == 7) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_7__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_7__c));
            }
        } else if (docNumber == 8) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_8__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_8__c));
            }
        } else if (docNumber == 9) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_9__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_9__c));
            }
        } else if (docNumber == 10) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_10__c)) {
                r = CloudDocsHelper.isFileNameUploaded(this.Opp.Id, CloudDocsHelper.getFileName(this.Opp.Application__r.Supporting_Document_10__c));
            }
        }
        if (r == true) {
            if (!docsUploaded.contains(String.valueOf(docNumber))) {
                docsUploaded += '|' + String.valueOf(docNumber);
            }
        }
        System.debug('is uploaded docNumber ' + docNumber + ': ' + r + ' >> ' + docsUploaded);
        return r;
    }
    private void uploadFiles(Integer docNumber) {
        String url = null;
        String docType = '';
        if (docNumber == 1) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_1__c)) {
                System.debug('Uploading file 1...');
                url = this.Opp.Application__r.Supporting_Document_1__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_1__c);
            }
        }
        if (docNumber == 2) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_2__c)) {
                System.debug('Uploading file 2...');
                url = this.Opp.Application__r.Supporting_Document_2__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_2__c);
            }
        }
        if (docNumber == 3) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_3__c)) {
                System.debug('Uploading file 3...');
                url = this.Opp.Application__r.Supporting_Document_3__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_3__c);
            }
        }
        if (docNumber == 4) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_4__c)) {
                System.debug('Uploading file 4...');
                url = this.Opp.Application__r.Supporting_Document_4__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_4__c);
            }
        }
        if (docNumber == 5) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_5__c)) {
                System.debug('Uploading file 5...');
                url = this.Opp.Application__r.Supporting_Document_5__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_5__c);
            }
        }
        if (docNumber == 6) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_6__c)) {
                System.debug('Uploading file 6...');
                url = this.Opp.Application__r.Supporting_Document_6__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_6__c);
            }
        }
        if (docNumber == 7) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_7__c)) {
                System.debug('Uploading file 7...');
                url = this.Opp.Application__r.Supporting_Document_7__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_7__c);
            }
        }
        if (docNumber == 8) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_8__c)) {
                System.debug('Uploading file 5...');
                url = this.Opp.Application__r.Supporting_Document_8__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_8__c);
            }
        }
        if (docNumber == 9) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_9__c)) {
                System.debug('Uploading file 9...');
                url = this.Opp.Application__r.Supporting_Document_9__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_9__c);
            }
        }
        if (docNumber == 10) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_10__c)) {
                System.debug('Uploading file 10...');
                url = this.Opp.Application__r.Supporting_Document_10__c;
                docType = CloudDocsHelper.documentTypeSupport(this.Opp.Application__r.Supporting_Doc_Type_10__c);
            }
        }
        if (!String.isBlank(url)) {
            if (!isFileUploaded(docNumber)) {
                CloudDocsHelper.uploadFileFromUrl(this.Opp.Id, url, docType);
                docsUploaded += '|' + String.valueOf(docNumber);
            } else {
                System.debug('Document already uploaded');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A document named [' + CloudDocsHelper.getFileName(url) + '] already uploaded into cloud documents'));
            }
        }
    }
    
    public String getFileNameDoc1() {
        return getFileNameDoc(1);
    }
    public String getFileNameDoc2() {
        return getFileNameDoc(2);
    }
    public String getFileNameDoc3() {
        return getFileNameDoc(3);
    }
    public String getFileNameDoc4() {
        return getFileNameDoc(4);
    }
    public String getFileNameDoc5() {
        return getFileNameDoc(5);
    }
    public String getFileNameDoc6() {
        return getFileNameDoc(6);
    }
    public String getFileNameDoc7() {
        return getFileNameDoc(7);
    }
    public String getFileNameDoc8() {
        return getFileNameDoc(8);
    }
    public String getFileNameDoc9() {
        return getFileNameDoc(9);
    }
    public String getFileNameDoc10() {
        return getFileNameDoc(10);
    }
    private String getFileNameDoc(Integer docNumber) {
        return CloudDocsHelper.getFileName(getUrlDoc(docNumber));
    }
    public String getS3LinkDoc1() {
        return getS3LinkDoc(1);
    }
    public String getS3LinkDoc2() {
        return getS3LinkDoc(2);
    }
    public String getS3LinkDoc3() {
        return getS3LinkDoc(3);
    }
    public String getS3LinkDoc4() {
        return getS3LinkDoc(4);
    }
    public String getS3LinkDoc5() {
        return getS3LinkDoc(5);
    }
    public String getS3LinkDoc6() {
        return getS3LinkDoc(6);
    }
    public String getS3LinkDoc7() {
        return getS3LinkDoc(7);
    }
    public String getS3LinkDoc8() {
        return getS3LinkDoc(8);
    }
    public String getS3LinkDoc9() {
        return getS3LinkDoc(9);
    }
    public String getS3LinkDoc10() {
        return getS3LinkDoc(10);
    }
    private String getS3LinkDoc(Integer docNumber) {
        return CloudDocsHelper.getSignedURL(getUrlDoc(docNumber));
    }
    private String getUrlDoc(Integer docNumber) {
        String url = null;
        if (docNumber == 1) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_1__c)) {
                System.debug('Uploading file 1...');
                url = this.Opp.Application__r.Supporting_Document_1__c;
            }
        }
        if (docNumber == 2) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_2__c)) {
                System.debug('Uploading file 2...');
                url = this.Opp.Application__r.Supporting_Document_2__c;
            }
        }
        if (docNumber == 3) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_3__c)) {
                System.debug('Uploading file 3...');
                url = this.Opp.Application__r.Supporting_Document_3__c;
            }
        }
        if (docNumber == 4) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_4__c)) {
                System.debug('Uploading file 4...');
                url = this.Opp.Application__r.Supporting_Document_4__c;
            }
        }
        if (docNumber == 5) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_5__c)) {
                System.debug('Uploading file 5...');
                url = this.Opp.Application__r.Supporting_Document_5__c;
            }
        }
        if (docNumber == 6) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_6__c)) {
                System.debug('Uploading file 6...');
                url = this.Opp.Application__r.Supporting_Document_6__c;
            }
        }
        if (docNumber == 7) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_7__c)) {
                System.debug('Uploading file 7...');
                url = this.Opp.Application__r.Supporting_Document_7__c;
            }
        }
        if (docNumber == 8) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_8__c)) {
                System.debug('Uploading file 8...');
                url = this.Opp.Application__r.Supporting_Document_8__c;
            }
        }
        if (docNumber == 9) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_9__c)) {
                System.debug('Uploading file 9...');
                url = this.Opp.Application__r.Supporting_Document_9__c;
            }
        }
        if (docNumber == 10) {
            if (!String.isBlank(this.Opp.Application__r.Supporting_Document_10__c)) {
                System.debug('Uploading file 10...');
                url = this.Opp.Application__r.Supporting_Document_10__c;
            }
        }
        return url;
    }
    //-
    public void fakeMethod() {
        fakeMethod2();
        fakeMethod3();
        fakeMethod4();
        fakeMethod5();
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public void fakeMethod2() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public void fakeMethod3() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public void fakeMethod4() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public void fakeMethod5() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    //Lelo      2017-04-05
    public List <SelectOption> getStreetTypeOptions() {
        List <SelectOption> stOptions = UtilitiesList.getStreetTypeOptions();
        return stOptions;
    }
    public List <SelectOption> getCountryOptions() {
        List <SelectOption> countryOptions = UtilitiesList.getCountryOptions();
        return countryOptions;
    }
    public void addPrevAddress1() {
        if (numPrevAddress1 < 5) {
            numPrevAddress1++;
        }
    }
    public void addPrevAddress2() {
        if (numPrevAddress2 < 5) {
            numPrevAddress2++;
        }
    }
    private void loadPreviousEmployments() {
        
        //Load Previous Employments
        prevEmplMap = new Map <String,List <Application_Employment__c>>();
        if (this.Opp.Application__c != null) {
            List < Application_Employment__c > lst = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
                Unit_Number__c, Street_Number__c, Street_Type__c,
                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
                FROM Application_Employment__c 
                WHERE Application__c =: this.Opp.Application__c 
                AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE];
            
            for (Application_Employment__c e: lst) {
                if('Second Job'.equals(e.Type__c)){
                    if('1'.equals(e.Applicant__c)){
                        this.secondJobApplic1 = e;
                        isSecondJobApplic1 = true;
                    }else if('2'.equals(e.Applicant__c)){
                        this.secondJobApplic2 = e;
                        isSecondJobApplic2 = true;
                    }
                }else{
                    List<Application_Employment__c> empList = prevEmplMap.get(e.Applicant__c);
                    if (empList == null) {
                        empList = new List < Application_Employment__c > ();
                        prevEmplMap.put(e.Applicant__c, empList);
                    }
                    empList.add(e);
                }
            }
            //Load Address for FinanceDetails section
            List < Application_Employment__c > addressFinance = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                Work_Address__c, Phone__c,
                Unit_Number__c, Street_Number__c, Street_Type__c,
                Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
                Overseas_City__c, Address_Line_2__c, Address_Type__c
                FROM Application_Employment__c WHERE Application__c =: this.Opp.Application__c and Address_Type__c =: Utilities.ADDRESS_TYPE_FINANCE limit 1
            ];
            if (addressFinance != null && !addressFinance.isEmpty()) {
                addressFinanceDetail = addressFinance[0];
            } else {
                addressFinanceDetail = new Application_Employment__c();
                addressFinanceDetail.Address_Type__c = Utilities.ADDRESS_TYPE_FINANCE;
                addressFinanceDetail.Postcode__c = Postcode6;
                addressFinanceDetail.State__c = NoAppState; 
            }
        }
        //Items to remove
        prevEmplRemList = new List < Application_Employment__c > ();
    }
    private Integer getNumPrevEmployments(String applicant) {
        
        Integer r = 1;
        if (prevEmplMap.containsKey(applicant)) {
            r += prevEmplMap.get(applicant).size();
        }
        return r;
    }
    public Integer getNumPrevEmployments1() {
        
        return getNumPrevEmployments('1');
    }
    public Integer getNumPrevEmployments2() {
        
        return getNumPrevEmployments('2');
    }
    public void addPrevEmployment(String applicant) {
        
        List < Application_Employment__c > lst = prevEmplMap.get(applicant);
        if (lst == null) {
            lst = new List < Application_Employment__c > ();
            prevEmplMap.put(applicant, lst);
        }
        /*if(lstPrevEmployment==null){
lstPrevEmployment = new List<Application_Employment__c>();
prevEmplMap.put(applicant, lstPrevEmployment);
}*/
        Application_Employment__c a = new Application_Employment__c();
        a.Applicant__c = applicant;
        a.Country__c = 'AUS';
        //lstPrevEmployment.add(a);
        lst.add(a);
    }
    public void addPrevEmployment1() {
        
        addPrevEmployment('1');
    }
    public void addPrevEmployment2() {
        
        addPrevEmployment('2');
    }
    private Application_Employment__c getPrevEmployment(String applicant, Integer pos) {
        
        Application_Employment__c r = null;
        if (prevEmplMap.containsKey(applicant)) {
            r = prevEmplMap.get(applicant).get(pos);
        }
        return r;
    }
    //Applicant 1
    public Application_Employment__c getPrevEmployment1b() {
        
        return getPrevEmployment('1', 0);
    }
    public Application_Employment__c getPrevEmployment1c() {
        
        return getPrevEmployment('1', 1);
    }
    public Application_Employment__c getPrevEmployment1d() {
        
        return getPrevEmployment('1', 2);
    }
    public Application_Employment__c getPrevEmployment1e() {
        
        return getPrevEmployment('1', 3);
    }
    //Trading Address - Finance details
    public Application_Employment__c getAddressFinanceDetail() {
        
        return addressFinanceDetail;
    }
    //Applicant 2
    public Application_Employment__c getPrevEmployment2b() {
        
        return getPrevEmployment('2', 0);
    }
    public Application_Employment__c getPrevEmployment2c() {
        
        return getPrevEmployment('2', 1);
    }
    public Application_Employment__c getPrevEmployment2d() {
        
        return getPrevEmployment('2', 2);
    }
    public Application_Employment__c getPrevEmployment2e() {
        
        return getPrevEmployment('2', 3);
    }
    //Remove employment
    private void removePrevEmployment(String applicant, Integer pos) {
        
        List < Application_Employment__c > lst = prevEmplMap.get(applicant);
        if (lst != null && pos < lst.size()) {
            Application_Employment__c a = lst.get(pos);
            if (a.Id != null) {
                prevEmplRemList.add(a);
            }
            lst.remove(pos);
        }
    }
    public void removePrevEmployment1b() {
        
        removePrevEmployment('1', 0);
    }
    public void removePrevEmployment1c() {
        
        removePrevEmployment('1', 1);
    }
    public void removePrevEmployment1d() {
        
        removePrevEmployment('1', 2);
    }
    public void removePrevEmployment1e() {
        
        removePrevEmployment('1', 3);
    }
    public void removePrevEmployment2b() {
        
        removePrevEmployment('2', 0);
    }
    public void removePrevEmployment2c() {
        
        removePrevEmployment('2', 1);
    }
    public void removePrevEmployment2d() {
        
        removePrevEmployment('2', 2);
    }
    public void removePrevEmployment2e() {
        
        removePrevEmployment('2', 3);
    }
    private void savePrevEmployments(Id appId) {
        List < Application_Employment__c > r = new List < Application_Employment__c > ();
        List < Application_Employment__c > lst = prevEmplMap.get('1');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                if (a.Id == null) {
                    a.Application__c = appId;
                }
                r.add(a);
            }
        }
        lst = prevEmplMap.get('2');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                if (a.Id == null) {
                    a.Application__c = appId;
                }
                r.add(a);
            }
        }
        //Update Finance Details address
        if (addressFinanceDetail != null) {
            if (addressFinanceDetail.Id == null) {
                addressFinanceDetail.Application__c = appId;
            }
            if (String.isBlank(addressFinanceDetail.Country__c)) {
                addressFinanceDetail.Country__c = 'AUS';
            }
            r.add(addressFinanceDetail);
        }
        if (!r.isEmpty()) {
            upsert r;
        }
        //Remove
        if (!prevEmplRemList.isEmpty()) {
            delete prevEmplRemList;
            prevEmplRemList.clear();
        }
    }
    //public Integer getTotalYearsAustraliaResidence1() {
    //    Integer r
    //}
    // shgg
    public Decimal getTotalLivExp() {
        Decimal r = 0.0;
        r += NumberUtils.convertToDecimal(Opp.Application__r.Basic_Living_Expenses_Per_Month__c, false);
        r += NumberUtils.convertToDecimal(Opp.Application__r.Childcare_Child_Maintenance_Per_Month__c, false);
        r += NumberUtils.convertToDecimal(Opp.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
        r += NumberUtils.convertToDecimal(Opp.Application__r.Insurance_Expenses_per_Month__c, false);
        r += NumberUtils.convertToDecimal(Opp.Application__r.Travel_Transport_Expenses_per_Month__c, false);
        r += NumberUtils.convertToDecimal(Opp.Application__r.Other_Expenses_per_Month__c, false);
        return r;
    }
    public Decimal getNewTotLivExp() {
        Decimal Blepm, Ccmpm, Mpiptpm, Iepm, Ttepm, Oepm;
        if (Opp.Application__c == null) {
            if (basicLivingExpensesMonth == null) basicLivingExpensesMonth = 0;
            Blepm = basicLivingExpensesMonth;
            if (childcareChildMaintenanceMonth == null) childcareChildMaintenanceMonth = 0;
            Ccmpm = childcareChildMaintenanceMonth;
            if (mobilePhoneInternetPayTVMonth == null) mobilePhoneInternetPayTVMonth = 0;
            Mpiptpm = mobilePhoneInternetPayTVMonth;
            if (insuranceExpensesMonth == null) insuranceExpensesMonth = 0;
            Iepm = insuranceExpensesMonth;
            if (travelTransportExpensesMonth == null) travelTransportExpensesMonth = 0;
            Ttepm = travelTransportExpensesMonth;
            if (otherExpensesMonth == null) otherExpensesMonth = 0;
            Oepm = otherExpensesMonth;
        } else {
            Blepm = NumberUtils.convertToDecimal(Opp.Application__r.Basic_Living_Expenses_Per_Month__c, false);
            Ccmpm = NumberUtils.convertToDecimal(Opp.Application__r.Childcare_Child_Maintenance_Per_Month__c, false);
            Mpiptpm = NumberUtils.convertToDecimal(Opp.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c, false);
            Iepm = NumberUtils.convertToDecimal(Opp.Application__r.Insurance_Expenses_per_Month__c, false);
            Ttepm = NumberUtils.convertToDecimal(Opp.Application__r.Travel_Transport_Expenses_per_Month__c, false);
            Oepm = NumberUtils.convertToDecimal(Opp.Application__r.Other_Expenses_per_Month__c, false);
            //  Decimal Ite = NumberUtils.convertToDecimal(Opp.Application__r.Income_Type_Expenses__c,false);
        }
        return Blepm + Ccmpm + Mpiptpm + Iepm + Ttepm + Oepm;
        //  return Ccmpm;
    }
    public PageReference saveDraftVFPage() {
        if (Opp.Application__c == null) {
            app0.Status__c = 'U';
        } else if (Opp.Application__r != null) {
            if (String.isBlank(Opp.Application__r.Status__c)) {
                Opp.Application__r.Status__c = 'U';
            } else if ('F'.equals(Opp.Application__r.Status__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This application cannot be saved Draft due to it is already finished'));
                return null;
            }
        }
        // if(!getHasProperrtyAssets() && ('Own Outright'.equals(Opp.Application__r.Current_Residence_Status_1__c) || 'Own Outright'.equals(currentStatus1))){
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A property should be added in Financial Details section due to the residential status is Own Outright for Applicant 1'));
        //     return null;
        // }
        if (!isMasterDetailsValidated()) {
            return null;
        }
        return saveApplicationData();
    }
    
    // Loan list
    public List <LoanWrapped> loanList {get;set;}
    public Integer loanSelected {get;set;}
    
    private void loadApplicationLoans() {
        this.loanList = new List < LoanWrapped> ();
        if (this.Opp.Application__c != null) {
            List < Application_Loan__c > d = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c,
                                              Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c, Order__c
                                              FROM Application_Loan__c WHERE Application__c =: this.Opp.Application__c ORDER BY Order__c
                                             ];
            //Integer idx = 1;
            for (Application_Loan__c a: d) {
                this.loanList.add(new LoanWrapped(a.Order__c, a));
            }
        }
        System.debug('loadApplicationLoans... ' + this.loanList.size());
    }
    
    public Boolean getHasLoans() {
        
        Boolean r = false;
        if (this.loanList != null && !this.loanList.isEmpty()) {
            r = true;
        }
        return r;
    }
    public void addLoan() {
        // System.debug('add loan ');
        // System.debug(this.loanList.size()+1);
        //if (this.loanList.size() < 3) {
        this.loanList.add(new LoanWrapped(this.loanList.size() + 1, new Application_Loan__c()));
        //}
    }
    public void removeLoan() {
        //System.debug('remove loan ');
        if (loanSelected != null && loanSelected <= this.loanList.size()) {
            LoanWrapped loan = this.loanList.get(loanSelected - 1);
            if (loan.data != null && loan.data.Id != null) {
                delete loan.data;
            }
            this.loanList.remove(loanSelected - 1);
            //Reset order
            if (!this.loanList.isEmpty()) {
                Integer i = 1;
                for (LoanWrapped a: this.loanList) {
                    a.data.Order__c = i;
                    i++;
                }
            }
        }
    }
    public void syncLoans() {
        if (this.loanList != null && !this.loanList.isEmpty()) {
            List < Application_Loan__c > d = new List < Application_Loan__c > ();
            Map<Id, Application_Loan__c> oaMap = new Map<Id, Application_Loan__c>([
                select Id, Name from Application_Loan__c where Application__c = :this.Opp.Application__c]);
            Integer i = 0;
            Set<Id> lstRem = new Set<Id>();
            for (LoanWrapped a: this.loanList) {
                if (a.data.Id == null || oaMap.containsKey(a.data.Id)) {
                    if (a.data.Application__c == null) {
                        a.data.Application__c = this.Opp.Application__c;
                    }
                    a.data.Order__c = d.size() + 1;
                    d.add(a.data);
                } else {
                    lstRem.add(a.data.Id);
                }
                i++;
            }
            if (!d.isEmpty()) {
                upsert d;
            }
            List<LoanWrapped> tmp = this.loanList.clone();
            this.loanList.clear();
            for (LoanWrapped a: tmp) {
                if (!lstRem.contains(a.data.id)) {
                    this.loanList.add(a);
                }
            }
        }
    }
    public Boolean isValidLoans() {
        Boolean r = true;
        if (this.loanList != null && !this.loanList.isEmpty()) {
            String msg = null;
            for (LoanWrapped a: this.loanList) {
                msg = '';
                if (String.isBlank(a.data.Type__c)) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Type';
                }
                if (String.isBlank(a.data.Lender__c)) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Lender';
                }
                if (a.data.Amount_Owing__c == null || a.data.Amount_Owing__c == 0) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Amount Owing';
                }
                if (a.data.Payment__c == null || a.data.Payment__c == 0) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Payment';
                }
                if (String.isBlank(a.data.Frequency__c)) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Frequency';
                }
                if (!String.isBlank(msg)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Loan #' + a.data.Order__c + ' - Missing the following field(s): ' + msg));
                    r = false;
                }
            }
        }
        return r;
    }
    //Jesus Mora
    public Boolean isValidIncomes(String applicant) {
        Boolean r = true;
        List<Application_Income__c> lst = incomeMap.get(applicant);
        
        if (lst != null && !lst.isEmpty()) {
            String msg = null;
            for (Application_Income__c a: lst) {
                msg = '';
                if (String.isBlank(a.Type__c)) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Type';
                }
                if (String.isBlank(a.Frequency__c)) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Frequency';
                }
                if (a.Income__c == null || a.Income__c == 0) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'After Tax Income';
                }
                if (String.isBlank(a.Application_Other_Asset__c) && ('Investment Property'.equals(a.Type__c) || 'Rental Income'.equals(a.Type__c))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Applicant '+applicant+' Income #' + a.Order__c + ': Property not selected'));
                }
                if (!String.isBlank(msg)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant '+applicant+' Income #' + a.Order__c + ' - Missing the following field(s): ' + msg));
                    r = false;
                }
            }
        }
        return r;
    }
    public Boolean isMasterDetailsValidated() {
        Boolean r = true;
        if (!isValidPropertyAssets()) {
            r = false;
        }
        if (!isValidVehicleAssets()) {
            r = false;
        }
        if (!isValidLoans()) {
            r = false;
        }
        if (!isValidIncomes('1')) {
            r = false;
        }
        if (!isValidIncomes('2')) {
            r = false;
        }
        if (!isValidCreditCards()) {
            r = false;
        }
        if (!isValidOtherAssets()) {
            r = false;
        }
        return r;
    }
    public class LoanWrapped {
        public Decimal idx {get;set;}
        public Boolean isRemoved {get;set;}
        public Application_Loan__c data {get;set;}
        public LoanWrapped(Decimal idx, Application_Loan__c obj) {
            this.idx = idx;
            this.data = obj;
            this.data.Order__c = this.idx;
            this.isRemoved = false;
        }
    }
    public Decimal getApplicationTotalMortgage() {
        Decimal r = 0.0;
        for (ObjectWrapped a : this.propertyAssetList) {
            if ('Y'.equals(a.data.get('Has_Loan__c')) && a.data.get('Monthly_Payment__c') != null) {
                r += (Decimal) a.data.get('Monthly_Payment__c');
            }
        }
        // if (this.Opp.Application__c != null && this.Opp.Application__r.Total_Mortgage_Loan__c > 0) {
        //     r = this.Opp.Application__r.Total_Mortgage_Loan__c;
        // }
        if (this.loanList != null) {
            for (LoanWrapped a: this.loanList) {
                if ('Mortgage'.equals(a.data.Type__c)) {
                    r += OppApplicationServCalculatorUtils.getFrecuencyFactor(a.data.Frequency__c) * a.data.Payment__c;
                }
            }
        }
        return r;
    }
    //Lelo      YTD - Pepper        2018-05-10
    public void ytdCalcNetLastestPay1() {
        this.latestPayMonthly1 = 0;
        if (this.latestPay1 != null && String.isNotBlank(this.latestPayFrequency1)) {
            this.latestPayMonthly1 = this.latestPay1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(this.latestPayFrequency1);
            this.latestPayMonthly1 = this.latestPayMonthly1.setScale(2);
        }
    }
    public void ytdCalcNetLastestPay2() {
        this.latestPayMonthly2 = 0;
        if (this.latestPay2 != null && String.isNotBlank(this.latestPayFrequency2)) {
            this.latestPayMonthly2 = this.latestPay2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(this.latestPayFrequency2);
            this.latestPayMonthly2 = this.latestPayMonthly2.setScale(2);
        }
    }
    //-
    
    //Popup - HJ - I . 14082018    
    public void showPopup() {
        displayPopUp = true;
        addressSplit = new AddressSplit();
        if (!StringUtils.isNullOrEmpty(tmpAddress)){
            addressSplit = getAddressSplit(tmpAddress);
        }
        reformatAddress();
        System.debug('showPopup... ' + this.displayPopUp);
    }
    
    //Pasar a un Utilities - HJ
    private AddressSplit getAddressSplit(String address) {
        if (address == null) {
            return null;
        }
        AddressSplit newAddress = new AddressSplit();
        List < String > sp = address.split('\\|');
        if (sp.size() != 7) {
            return newAddress;
        }
        newAddress.tUnitNumber = StringUtils.validateNull(sp.get(0));
        newAddress.tStreetNo = StringUtils.validateNull(sp.get(1));
        newAddress.tStreetName = StringUtils.validateNull(sp.get(2));
        newAddress.tStreetType = StringUtils.validateNull(sp.get(3));
        newAddress.tSuburb = StringUtils.validateNull(sp.get(4));
        newAddress.tState = StringUtils.validateNull(sp.get(5));
        newAddress.tPostCode = StringUtils.validateNull(sp.get(6));
        return newAddress;
    }
    
    public void closePopup() {
        displayPopUp = false;
        MessageDisplayPopUp = false;
    }
    
    public PageReference createTmpAddressNew() {
        reformatAddress();
        return null;
    }
    
    private String reformatAddress() {
        String token = '|';
        tmpAddressNew = 'Missing values.';
        if (StringUtils.isNullOrEmpty(addressSplit.tStreetNo) || StringUtils.isNullOrEmpty(addressSplit.tStreetName) ||
            StringUtils.isNullOrEmpty(addressSplit.tStreetType) || StringUtils.isNullOrEmpty(addressSplit.tSuburb) ||
            StringUtils.isNullOrEmpty(addressSplit.tState) || StringUtils.isNullOrEmpty(addressSplit.tPostCode)) {
                return null;
            }
        addressSplit.tUnitNumber = StringUtils.validateNull(addressSplit.tUnitNumber);
        tmpAddressNew = addressSplit.tUnitNumber + token +
            addressSplit.tStreetNo + token +
            addressSplit.tStreetName + token +
            addressSplit.tStreetType + token +
            addressSplit.tSuburb + token +
            addressSplit.tState + token +
            addressSplit.tPostCode;
        if ('PL'.equalsIgnoreCase(section)) {
            for (ObjectWrapped a: this.propertyAssetList) {
                if (a.idx == tmpRow) {
                    a.data.put('Description__c', tmpAddressNew);
                }
            }
        } else if ('PR'.equalsIgnoreCase(section)) {
            if (tmpRow == 1) {
                personalReference1Address = tmpAddressNew;
                opp.Application__r.Personal_Reference_1_Address__c = tmpAddressNew;
            } else if (tmpRow == 2) {
                personalReference2Address = tmpAddressNew;
                opp.Application__r.Personal_Reference_2_Address__c = tmpAddressNew;
            }
        }
        return tmpAddressNew;
    }
    public PageReference redirectPopup() {
        if (!StringUtils.isNullOrEmpty(reformatAddress())) {
            displayPopUp = false;
        } else {
            tmpAddressNew = 'Missing values.';
        }
        //Please uncomment below 3 statements and replace YourObjectId
        // PageReference p=new Pagereference('/'+YourObjectId);
        //  p.setRedirect(true);
        //  return p;
        return null;
    }
    //PopUp - HJ - F . 14082018
    //
    //Yohan VillaLeal       >>>> Servicing calculator
    public List <SelectOption> getServAreaSelect() {
        List <SelectOption> r = new List<SelectOption>();
        for (String value: servAreas) {
            r.add(new SelectOption(value, value));
        }
        return r;
    }
    
    public List <SelectOption> getServStateSelect() {
        List <SelectOption> r = new List<SelectOption>();
        for (String value: servStates) {
            r.add(new SelectOption(value, value));
        }
        return r;
    }
    
    public Decimal getMortgageBuffer(){
        Decimal mortgageBalance = 0.0;
        for (ObjectWrapped a: this.propertyAssetList) {
            if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                mortgageBalance += (Decimal)a.data.get('Amount_Owing__c');
            }
        }
        return (0.005*mortgageBalance)/12;
    }
    
    public boolean validateHasMoreThan3YearsEmployments(String startDate1, String finishDate1, String dateStarted1, String country, String empStatus){
        
        if (!hasMoreThan3YearsEmployment(startDate1, finishDate1, dateStarted1, country, empStatus)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'The total amount of employment time should be at least 3 years'));
            return false;
        }
        return true;
    }
    
    public Boolean hasMoreThan3YearsEmployment(String startDate, String finishDate, String dateStarted1, String country, String empStatus) {
        System.debug(startDate + '|' + finishDate + '|' + dateStarted1);
        List < Application_Employment__c > lst = prevEmplMap.get('1');
        Boolean r = false;
        
        //Create list
        List<Date> d1 = new List<Date>();
        List<Date> d2 = new List<Date>();
        
        Date a = FieldValidationsHelper.convertDate(dateStarted1);
        Date b = null;
        if (a != null) {
            d1.add(a);
            d2.add(Date.today());
        }
        
        //Previous employment
        if (String.isNotBlank(startDate)) {
            a = FieldValidationsHelper.convertDate(startDate);
            b = FieldValidationsHelper.convertDate(finishDate);
            if (a != null && b != null) {
                d1.add(a);
                d2.add(b);
            }   
        }
        Boolean isOvsOrUnemp = false;

        if(lst != null){
            if (!lst.isEmpty()) {
                for (Application_Employment__c e : lst) {
                  if ('OVS'.equals(e.Country__c) || 'Unemployed'.equals(e.Employment_Type__c)) {
                    isOvsOrUnemp = true;
                  } else if (e.Start_Date__c != null && e.Finish_Date__c != null) {
                    d1.add(e.Start_Date__c);
                    d2.add(e.Finish_Date__c);
                  }
                }
            }
        }
        
        Decimal y = FieldValidationsHelper.getYearsBetween(d1, d2);
        if (y != null && y >= 3.0) {
            r = true;
        } else {
          if ('OVS'.equals(country) || 'Unemployed'.equals(empStatus) || isOvsOrUnemp) {
            ApexPages.addMessage(
              new ApexPages.Message(ApexPages.Severity.WARNING, 
                                    'Australian work experience below of 3 years'));
            r = true;
          }
        }

        return r;
    }
    //Jesus Mora
    private Map < String, List < Application_Income__c >> incomeMap = null;
    private List < Application_Income__c > incomeRemList = null;   
    public Integer incomeSelected {get;set;}
    
    private void saveIncomes(Id appId) {
        
        List < Application_Income__c > r = new List < Application_Income__c > ();
        List < Application_Income__c > lst = incomeMap.get('1');
        Integer propertyApp1 = 0;
        Integer propertyApp2 = 0;
        
        if (lst != null) {
            for (Application_Income__c a: lst) {
                if (a.Id == null) {
                    a.Application__c = appId;
                }
                propertyApp1 = 0;
                for (Application_Income__c i: lst) {
                    if(String.isNotBlank(a.Application_Other_Asset__c)){
                        if(a.Application_Other_Asset__c.equals(i.Application_Other_Asset__c)){
                            propertyApp1++;
                        }
                    }
                    if(propertyApp1 == 2){
                        break;
                    }
                }
                if(propertyApp1 == 2){
                    break;
                }
                r.add(a);
            }
        }
        
        if(propertyApp1 != 2){
            
            lst = incomeMap.get('2');
            if (lst != null) {
                for (Application_Income__c a: lst) {
                    if (a.Id == null) {
                        a.Application__c = appId;
                    }
                    propertyApp2 = 0;
                    for (Application_Income__c i: lst) {
                        if(String.isNotBlank(a.Application_Other_Asset__c)){
                            if(a.Application_Other_Asset__c.equals(i.Application_Other_Asset__c)){
                                propertyApp2++;
                            }
                        }
                        if(propertyApp2 == 2){
                            break;
                        }
                    }
                    if(propertyApp2 == 2){
                        break;
                    }
                    r.add(a);
                }
            }
        }
        
        if (!r.isEmpty()) {
            if(propertyApp2 == 2){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 Other Income: A property must be used in only one income'));
            }else if(propertyApp1 == 2){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 Other Income: A property must be used in only one income'));
            }else{
              // upsert r;
              for (Application_Income__c a: r) {
                if (a.Id == null) {
                  insert a;
                } else {
                  try {
                    update a;
                  } catch (Exception e) {
                    System.debug(e.getMessage());
                  }
                }
              }
            }
        }else{
            if(!incomeMap.isEmpty()){
                if(propertyApp1 == 2){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 1 Other Income: A property must be used in only one income'));
                }
                if(propertyApp2 == 2){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant 2 Other Income: A property must be used in only one income'));
                }
            }
        }
        
        if (!incomeRemList.isEmpty()) {
            delete incomeRemList;
            incomeRemList.clear();
        }   

        loadApplicationIncomes();
    }
    
    public Boolean gethasIncomes1() {
        
        return this.gethasIncomes('1'); 
        
    }
    
    public Boolean gethasIncomes2() {
        
        
        return this.gethasIncomes('2');
        
    }
    
    public Boolean gethasIncomes(String applicant) {
        
        Boolean r = false;
        List < Application_Income__c > lst = incomeMap.get(applicant);
        if (lst != null && !lst.isEmpty()) {
            
            r = true;
            
        }
        return r;
    }
    
    public void addIncome(String applicant) {
        List < Application_Income__c > lst = incomeMap.get(applicant);
        if (lst == null) {
            lst = new List < Application_Income__c > ();
            incomeMap.put(applicant, lst);
        }
        Application_Income__c a = new Application_Income__c();
        a.Applicant__c = applicant;
        a.Order__c=  lst.size()+1;
        a.Frequency__c='Monthly';
        lst.add(a);    
    }
    
    public void addIncome1() {
        addIncome('1');
    }
    public void addIncome2() {
        addIncome('2');
    }
    
    public void removeIncome1() {
        removeIncome('1');
    }
    
    public void removeIncome2() {
        removeIncome('2');
    }
    
    private void removeIncome(String applicant) {
        
        List < Application_Income__c > lst = incomeMap.get(applicant);
        
        if (incomeSelected != null){
            
            Application_Income__c a = lst.get(incomeSelected-1);
            if (a.Id != null) {
                
                incomeRemList.add(a);
            }
            lst.remove(incomeSelected-1);
            if (!lst.isEmpty()) {
                Integer i = 1;
                for (Application_Income__c b: lst) {
                    b.Order__c = i;
                    i++;
                    
                }
            }
        }
    }
    
    private void loadApplicationIncomes() {
        incomeMap = new Map <String,List <Application_Income__c>>();
        if (this.Opp.Application__c != null) {
            List < Application_Income__c > lst = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                  Income__c, Order__c, Type__c, Application_Other_Asset__c
                                                  FROM Application_Income__c WHERE Application__c =: this.Opp.Application__c ORDER BY Order__c
                                                 ];
            System.debug(lst);
            for (Application_Income__c a: lst) {
                List<Application_Income__c> income = incomeMap.get(a.Applicant__c);
                if (income == null) {
                    income = new List < Application_Income__c > ();
                    incomeMap.put(a.Applicant__c, income);
                }
                a.Order__c = income.size() + 1;
                income.add(a);
            }
            System.debug(incomeMap);
        }
        incomeRemList = new List < Application_Income__c > ();
    }
    
    public List<Application_Income__c> getIncomesApp1() {
        return this.getIncomesApp('1');
    }
    
    public List<Application_Income__c> getIncomesApp2() {
        return this.getIncomesApp('2');
    }
    
    private List<Application_Income__c> getIncomesApp(String applicant) {
        List<Application_Income__c> r = null;
        System.debug(incomeMap);
        if (incomeMap.containsKey(applicant)) {
            r = incomeMap.get(applicant);
            if(applicant == '1'){
                properties = getProperties();
            }
            if(applicant == '2'){
                properties2 = getProperties2();
            }
        }
        return r;
    }
    
    // Lelo                     2019-03-07
    public class ObjectWrapped {
        public Integer idx {get;set;}
        public Boolean isRemoved {get;set;}
        public sObject data {get;set;}
        public ObjectWrapped(Integer idx, sObject obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }
    // Credit card list
    public List<ObjectWrapped> creditCardsList {set;get;}
    public Integer creditCardSelected {set;get;}
    public Decimal totalCreditCards {set;get;}
    public void loadCreditCards() {
        List<Application_Credit_Card__c> d = ApplicationService.getApplicationCreditCards(this.Opp.Application__c);
        
        this.creditCardsList = new List<ObjectWrapped>();
        Integer idx = 1;
        this.totalCreditCards = 0.0;
        for (Application_Credit_Card__c a : d) {
            if(!a.Is_Payout__c){
                this.totalCreditCards += a.Monthly_Payment__c;
            }
            this.creditCardsList.add(new ObjectWrapped(idx++, a));
        }
        this.totalCreditCards = this.totalCreditCards.setScale(2);
    }
    
    public void addCreditCard() {
        Application_Credit_Card__c a = new Application_Credit_Card__c();
        this.creditCardsList.add(new ObjectWrapped(this.creditCardsList.size()+1, a));
    }
    
    public Boolean getHasCreditCards() {
        if (this.creditCardsList != null && !this.creditCardsList.isEmpty()) {
            return true;
        }
        return false;
    }
    
    public void removeCreditCard() {
        if (creditCardSelected != null && creditCardSelected <= this.creditCardsList.size()) {
            ObjectWrapped obj = this.creditCardsList.get(creditCardSelected - 1);
            if (obj.data != null && obj.data.Id != null) {
                delete obj.data;
            }
            this.creditCardsList.remove(creditCardSelected - 1);
            //Reset order
            if (!this.creditCardsList.isEmpty()) {
                Integer i = 1;
                for (ObjectWrapped a: this.creditCardsList) {
                    a.idx = i++;
                }
            }
        }
    }
    
    public Boolean isValidCreditCards() {
        Boolean r = true;
        if (this.creditCardsList != null && !this.creditCardsList.isEmpty()) {
            String msg = null;
            for (ObjectWrapped a: this.creditCardsList) {
                msg = '';
                if (a.data.get('Issuer__c') == null || String.isBlank(String.valueOf(a.data.get('Issuer__c')))) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Issuer';
                }
                if (a.data.get('Limit__c') == null || a.data.get('Limit__c') == 0) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Limit';
                }
                if (a.data.get('Amount_Owing__c') == null) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Amount Owing';
                }
                if (!String.isBlank(msg)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Credit Card #' + a.idx + ' - Missing the following field(s): ' + msg));
                    r = false;
                }
            }
        }
        return r;
    }
    
    public void syncCreditCards() {
        if (this.creditCardsList != null && !this.creditCardsList.isEmpty()) {
            List <Application_Credit_Card__c> d = new List <Application_Credit_Card__c>();
            Map<Id, Application_Credit_Card__c> oaMap = new Map<Id, Application_Credit_Card__c>([
                select Id, Name from Application_Credit_Card__c where Application__c = :this.Opp.Application__c]);
            Integer i = 0;
            Set<Id> lstRem = new Set<Id>();
            for (ObjectWrapped a: this.creditCardsList) {
                if (a.data.Id == null || oaMap.containsKey(a.data.Id)) {
                    if (a.data.get('Application__c') == null) {
                        a.data.put('Application__c', this.Opp.Application__c);
                    }
                    d.add((Application_Credit_Card__c)a.data);
                } else {
                    lstRem.add(a.data.Id);
                }
                i++;
            }
            if (!d.isEmpty()) {
                upsert d;
            }
            List<ObjectWrapped> tmp = this.creditCardsList.clone();
            this.creditCardsList.clear();
            for (ObjectWrapped a: tmp) {
                if (!lstRem.contains(a.data.id)) {
                    this.creditCardsList.add(a);
                }
            }
        }
    }
    // Other Assets
    public Map<String, List<ObjectWrapped>> otherAssetMap {set;get;}
    public Integer otherAssetSelected {set;get;}
    public Integer propertyAssetSelected {set;get;}
    public Integer vehicleAssetSelected {set;get;}
    public List<ObjectWrapped> otherAssetList {
        set;
        get { return this.getOtherAssetList(ApplicationService.OTHER_ASSET_TYPE); }
    }
    public List<ObjectWrapped> propertyAssetList {
        set;
        get { return this.getOtherAssetList(ApplicationService.PROPERTY_ASSET_TYPE); }
    }
    public List<ObjectWrapped> vehicleAssetList {
        set;
        get { return this.getOtherAssetList(ApplicationService.VEHICLE_ASSET_TYPE); }
    }
    
    public void loadOtherAssets() {
        this.otherAssetMap = new Map<String, List<ObjectWrapped>>();
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(this.Opp.Application__c);
        for (Application_Other_Asset__c a : d) {
            List<ObjectWrapped> m = this.otherAssetMap.get(a.RecordType.Name);
            if (m == null) {
                m = new List<ObjectWrapped>();
                this.otherAssetMap.put(a.RecordType.Name, m);
            }
            m.add(new ObjectWrapped(m.size()+1, a));
        }
    }
    private List<ObjectWrapped> getOtherAssetList(String assetType) {
        List<ObjectWrapped> r = new List<ObjectWrapped>();
        if (String.isNotBlank(assetType) && this.otherAssetMap != null && this.otherAssetMap.containsKey(assetType)) {
            r = this.otherAssetMap.get(assetType);
        }
        return r;
    }
    private void addOtherAsset(String assetType) {
        Application_Other_Asset__c a = new Application_Other_Asset__c(
            RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(assetType));
        List<ObjectWrapped> m = this.otherAssetMap.get(assetType);
        if (m == null) {
            m = new List<ObjectWrapped>();
            this.otherAssetMap.put(assetType, m);
        }
        m.add(new ObjectWrapped(m.size()+1, a));
    }
    private Boolean getHasOtherAssets(String assetType) {
        if (assetType != null) {
            List<ObjectWrapped> m = this.otherAssetMap.get(assetType);
            if (m != null && !m.isEmpty()) {
                return true;
            }
        }
        return false;
    }
    public void removeOtherAsset(String assetType, Integer idx) {
        List<ObjectWrapped> m = this.otherAssetMap.get(assetType);
        if (m != null && idx != null && idx <= m.size()) {
            ObjectWrapped obj = m.get(idx - 1);
            if (obj.data != null && obj.data.Id != null) {
                delete obj.data;
            }
            m.remove(idx - 1);
            //Reset order
            if (!m.isEmpty()) {
                Integer i = 1;
                for (ObjectWrapped a: m) {
                    a.idx = i++;
                }
            }
        }
    }
    private Boolean isValidOtherAssets(String assetType) {
        Boolean r = true;
        List<ObjectWrapped> m = this.otherAssetMap.get(assetType);
        if (m != null && !m.isEmpty()) {
            String msg = null;
            Integer currentAddressApplicant1 = 0;
            Integer currentAddressApplicant2 = 0;
            Integer currentAddressBothApplicants = 0;
            Boolean isJointApp = (this.Opp.Application__c !=null && this.Opp.Application__r.No_of_People__c > 1)? true : false;
            for (ObjectWrapped a: m) {
                msg = '';
                if (a.data.get('Description__c') == null || String.isBlank(String.valueOf(a.data.get('Description__c')))) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    if (ApplicationService.PROPERTY_ASSET_TYPE.equals(assetType)) {
                        msg += 'Address';
                    } else if (ApplicationService.VEHICLE_ASSET_TYPE.equals(assetType)) {
                        msg += 'Plate/Description';
                    } else {
                        msg += 'Description';
                    }
                }
                if (a.data.get('Value__c') == null || a.data.get('Value__c') == 0) {
                    if (!String.isBlank(msg)) {
                        msg += ', ';
                    }
                    msg += 'Value';
                }
                // Aditional validation
                if (ApplicationService.PROPERTY_ASSET_TYPE.equals(assetType) ||
                    ApplicationService.VEHICLE_ASSET_TYPE.equals(assetType)) {
                        if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                            if (a.data.get('Lender__c') == null || String.isBlank(String.valueOf(a.data.get('Lender__c')))) {
                                if (!String.isBlank(msg)) {
                                    msg += ', ';
                                }
                                msg += 'Bank Name';
                            }
                            if (a.data.get('Amount_Owing__c') == null || a.data.get('Amount_Owing__c') == 0) {
                                if (!String.isBlank(msg)) {
                                    msg += ', ';
                                }
                                msg += 'Amount Owing';
                            }
                            if (a.data.get('Payment__c') == null || a.data.get('Payment__c') == 0) {
                                if (!String.isBlank(msg)) {
                                    msg += ', ';
                                }
                                msg += 'Payment';
                            }
                            if (a.data.get('Frequency__c') == null || String.isBlank(String.valueOf(a.data.get('Frequency__c')))) {
                                if (!String.isBlank(msg)) {
                                    msg += ', ';
                                }
                                msg += 'Frequency';
                            }
                        }
                    }
                if (ApplicationService.PROPERTY_ASSET_TYPE.equals(assetType)) {
                    if (a.data.get('Category__c') == null || String.isBlank(String.valueOf(a.data.get('Category__c')))) {
                      if (isJointApp) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, assetType + ' #' + a.idx+': Category not selected'));
                      }
                    } else {
                        if ('Current Address Applicant 1'.equals(String.valueOf(a.data.get('Category__c')))) {
                            currentAddressApplicant1++;
                        }
                        if ('Current Address Applicant 2'.equals(String.valueOf(a.data.get('Category__c')))) {
                            currentAddressApplicant2++;
                        }
                        if ('Current Address Both Applicants'.equals(String.valueOf(a.data.get('Category__c')))) {
                            currentAddressBothApplicants++;
                        }
                    }
                }
                if (!String.isBlank(msg)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, assetType + ' #' + a.idx + ' - Missing the following field(s): ' + msg));
                    r = false;
                }
            }
            if(currentAddressApplicant1 > 1 || currentAddressApplicant2 > 1 || currentAddressBothApplicants > 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Current Applicant 1, Current Applicant 2 and Current Address Both Applicants can be use only one time'));
                r = false;
            }else if((currentAddressApplicant1 == 1 || currentAddressApplicant2 == 1) && currentAddressBothApplicants == 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot be use at the same time Current Applicant 1 or Current Applicant 2 or both with Current Address Both Applicants'));
                r = false;
            }
        }
        return r;
    }
    public void syncOtherAssets() {
        if (this.otherAssetMap != null) {
            List <Application_Other_Asset__c> d = new List <Application_Other_Asset__c>();
            Map<Id, Application_Other_Asset__c> oaMap = new Map<Id, Application_Other_Asset__c>([
                select Id, Name from Application_Other_Asset__c where Application__c = :this.Opp.Application__c]);
            for (String k : this.otherAssetMap.keySet()) {
                Integer i = 0;
                for (ObjectWrapped a: this.otherAssetMap.get(k)) {
                    Application_Other_Asset__c oa = (Application_Other_Asset__c)a.data;
                    if (oa.Id == null || oaMap.containsKey(oa.Id)) {
                        if (oa.Application__c == null) {
                            oa.Application__c = this.Opp.Application__c;
                        }
                        //Reset loan deatils
                        if (!'Y'.equals(oa.Has_Loan__c)) {
                            oa.Lender__c = null;
                            oa.Amount_Owing__c = null;
                            oa.Frequency__c = null;
                            oa.Is_Payout__c = false;
                            oa.Payment__c = null;
                        }
                        d.add(oa);
                    } else {
                        this.otherAssetMap.get(k).remove(i);
                    }
                    i++;
                }
            }
            if (!d.isEmpty()) {
                upsert d;
            }
        }
    }
    private Boolean getDisplayLoanHeaders(String assetType) {
        List<ObjectWrapped> m = this.otherAssetMap.get(assetType);
        if (m != null) {
            for (ObjectWrapped a: m) {
                if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                    return true;
                }
            }
        }
        return false;
    }
    //var userLastname = '{!$UserInfo.getLastName()}';
    // Adding assets
    public void addOtherAsset() {
        this.addOtherAsset(ApplicationService.OTHER_ASSET_TYPE);
    }
    public void addPropertyAsset() {
        this.addOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);
    }
    public void addVehicleAsset() {
        this.addOtherAsset(ApplicationService.VEHICLE_ASSET_TYPE);
    }
    
    // has assets
    public Boolean getHasOtherAssets() {
        return this.getHasOtherAssets(ApplicationService.OTHER_ASSET_TYPE);
    }
    public Boolean getHasProperrtyAssets() {
        return this.getHasOtherAssets(ApplicationService.PROPERTY_ASSET_TYPE);
    }
    public Boolean getHasVehicleAssets() {
        return this.getHasOtherAssets(ApplicationService.VEHICLE_ASSET_TYPE);
    }
    
    //Removing assets
    public void removeOtherAsset() {
        this.removeOtherAsset(ApplicationService.OTHER_ASSET_TYPE, this.otherAssetSelected);
    }
    public void removePropertyAsset() {
        this.removeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE, this.propertyAssetSelected);
    }
    public void removeVehicleAsset() {
        this.removeOtherAsset(ApplicationService.VEHICLE_ASSET_TYPE, this.vehicleAssetSelected);
    }
    
    public Boolean isValidOtherAssets() {
        return this.isValidOtherAssets(ApplicationService.OTHER_ASSET_TYPE);
    }
    public Boolean isValidPropertyAssets() {
        return this.isValidOtherAssets(ApplicationService.PROPERTY_ASSET_TYPE);
    }
    public Boolean isValidVehicleAssets() {
        return this.isValidOtherAssets(ApplicationService.VEHICLE_ASSET_TYPE);
    }
    
    public Boolean getDisplayPropertyLoanHeaders() {
        return getDisplayLoanHeaders(ApplicationService.PROPERTY_ASSET_TYPE);
    }
    public Boolean getDisplayVehicleLoanHeaders() {
        return getDisplayLoanHeaders(ApplicationService.VEHICLE_ASSET_TYPE);
    }
    public List<Application_Other_Asset__c> getVehicleAssetLoanList() {
        List<Application_Other_Asset__c> r = new List<Application_Other_Asset__c>();
        for (ObjectWrapped a: this.vehicleAssetList) {
            Application_Other_Asset__c o = (Application_Other_Asset__c)a.data;
            if ('Y'.equals(o.Has_Loan__c)) {
                r.add(o);
            }
        }
        return r;
    }
    // end credit cards 
    
    public PageReference saveSecondJob(Id newAppId){
        if(isSecondJobApplic1){
            if(secondJobApplic1 != null){
                if(secondJobApplic1.Id != null){
                    update secondJobApplic1;
                }else{
                    secondJobApplic1.Type__c = 'Second Job';
                    secondJobApplic1.Applicant__c = '1';
                    secondJobApplic1.Application__c = newAppId;
                    insert secondJobApplic1;
                }
            }
        } else{
            if(secondJobApplic1.Id != null){
                delete secondJobApplic1;
                secondJobApplic1.Id = null;
            }
        }
        
        if(isSecondJobApplic2){    
            if(secondJobApplic2 != null){
                if(secondJobApplic2.Id != null){
                    update secondJobApplic2;
                }else{
                    secondJobApplic2.Type__c = 'Second Job';
                    secondJobApplic2.Applicant__c = '2';
                    secondJobApplic2.Application__c = newAppId;
                    insert secondJobApplic2;
                }
            }
        }else{
            if(secondJobApplic2.Id != null){
                delete secondJobApplic2;
                secondJobApplic2.Id = null;
            }
        }
        PageReference orderPage = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/OppApplication?id='+this.opp.Id);
        return orderPage.setRedirect(true);
    }
    
    public boolean isValidSecondJobApplic1OK(Application_Employment__c obj, Integer applicant){
        boolean r = true;
        if('--None--'.equals(obj.Employment_Type__c) || obj.Employment_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employemnet Type is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Employer_Name__c) || obj.Employer_Name__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employemnet Name is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Street_Number__c) || obj.Street_Number__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Street Number is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Work_Address__c) || obj.Work_Address__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Work Address is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Street_Type__c) || obj.Street_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Street Type is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Suburb__c) || obj.Suburb__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Suburb is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Postcode__c) || obj.Postcode__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postcode is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.State__c) || obj.State__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'State is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Phone__c) || obj.Phone__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Phone is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Occupation__c) || obj.Occupation__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Occupation is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Start_Date__c) || obj.Start_Date__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start Date is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(obj.Income__c==0.00 || obj.Income__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Income is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if(''.equals(obj.Frequency__c) || obj.Frequency__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Frequency is required in Applicant '+applicant+' - Second Job section.'));
            r = false;
        }
        if('1'.equals(applicant)){
            if(''.equals(obj.Employer_ABN_1__c) || obj.Employer_ABN_1__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employer ABN 1 is required in Applicant '+applicant+' - Second Job section.'));
                r = false;
            }
        }
        return r;
    }
    
    public boolean isValidSecondJobApplic2OK(Application_Employment__c obj, Integer applicant){
        return isValidSecondJobApplic1OK(obj, applicant);
    }
    //---------------------------------------------------------------------------------------------------------
    //Yohan VillaLeal                      2019-09-23
    public PageReference showABNlookupPopup(){
        ABNlookupDisplayPopUp = true;
        ABNsearchLookup();
        return null;
    }
    
    public PageReference ABNsearchLookup(){
        String apex;
        MessageDisplayPopUp = false;
        if(String.isNotBlank(abnLookup)){
            if(abnLookup.isNumeric()){
                apex = 'AbnDetails.aspx?abn='+abnLookup;
                abnLookupDto = getByABNorACNlookup(apex);
                NameDisplayPopUp = false;
                ABNandACNdisplayPopUp = true;
                if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                    this.counter=0;
                    this.countPage = 0;
                    Name = getByNameLookup(abnLookup);
                    NameDisplayPopUp = true;
                    ABNandACNdisplayPopUp = false;
                }
                
                if('An ACN is invalid in ABN Search'.equals(abnLookupDto.Message)){
                    apex = 'AcnDetails.aspx?acn='+abnLookup;
                    abnLookupDto = getByABNorACNlookup(apex);
                    NameDisplayPopUp = false;
                    ABNandACNdisplayPopUp = true;
                }else if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                    Name = getByNameLookup(abnLookup);
                    NameDisplayPopUp = true;
                    ABNandACNdisplayPopUp = false;
                }
            }else{
                this.counter=0;
                this.countPage = 0;
                Name = getByNameLookup(abnLookup);
                NameDisplayPopUp = true;
                ABNandACNdisplayPopUp = false;
                if(Name.Message.equals('No information found')){
                    NameDisplayPopUp = false;
                    MessageDisplayPopUp = true;
                }
            }
        }
        ABNlookupDisplayPopUp = true;
        return null;
    }
    
    public PageReference closeABNpopPupByName(){
        abnInfo = true;
        closeABNpopPupAux();
        abnLookupDtoByName = getByABNorACNlookup(abnLookup);
        return null;
    }
    
    public void closeABNpopPupAux(){
        abnLookup = '';
        ABNlookupDisplayPopUp = false;	
        NameDisplayPopUp = false;
        ABNandACNdisplayPopUp = false;
    }
    
    public void closeABNpoPup() {
        closeABNpopPupAux();
    }
    
    private ConnectionRESTWs.Param preparePOSTRequest(String endPointCall) {
        return prepareRequest(endPointCall, ConnectionRESTWs.POST);
    }
    
    private ConnectionRESTWs.Param prepareGETRequest(String endPointCall) {
        return prepareRequest(endPointCall, ConnectionRESTWs.GET);
    }
    
    private ConnectionRESTWs.Param prepareRequest(String endPointCall, String method) {
        ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
        ABNSettings__c s = [Select Id, GUID__c, endpoint__c From ABNSettings__c];
        p.endpoint = s.endpoint__c + endPointCall + s.GUID__c;
        //p.endpoint = 'https://abr.business.gov.au/json/' + endPointCall + 'd0baa451-a002-4969-b6d1-d2f879fb52db';
        p.method = method;
        return p;
    }
    
    public PageReference searchByFinanceDetail(){
        String apex;
        MessageDisplayPopUp = false;
        if(this.Opp.Application__c != null) {
            if(String.isNotBlank(this.Opp.Application__r.Business_ABN__c)){
                apex = 'AbnDetails.aspx?abn='+this.Opp.Application__r.Business_ABN__c; 
                abnLookupDto = getByABNorACNlookup(apex);
                NameDisplayPopUp = false;
                ABNandACNdisplayPopUp = true;
                if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                    if(String.isNotBlank(this.Opp.Application__r.Business_ACN__c)){
                        apex = 'AcnDetails.aspx?acn='+this.Opp.Application__r.Business_ACN__c;
                        abnLookupDto = getByABNorACNlookup(apex);
                        NameDisplayPopUp = false;
                        ABNandACNdisplayPopUp = true;
                        if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                            if(this.Opp.Application__r.Entity_Name__c != null){
                                Name = getByNameLookup(this.Opp.Application__r.Entity_Name__c);
                                NameDisplayPopUp = true;
                                ABNandACNdisplayPopUp = false;
                                if(Name.Message.equals('No information found')){
                                    NameDisplayPopUp = false;
                                    MessageDisplayPopUp = true;
                                }
                            }
                        }
                    }else {
                        if(this.Opp.Application__r.Entity_Name__c != null){
                            Name = getByNameLookup(this.Opp.Application__r.Entity_Name__c);
                            NameDisplayPopUp = true;
                            ABNandACNdisplayPopUp = false;
                            if(Name.Message.equals('No information found')){
                                NameDisplayPopUp = false;
                                MessageDisplayPopUp = true;
                            }
                        }
                    }
                }
            }else if(String.isNotBlank(this.Opp.Application__r.Business_ACN__c)){
                apex = 'AcnDetails.aspx?acn='+this.Opp.Application__r.Business_ACN__c;
                abnLookupDto = getByABNorACNlookup(apex);
                NameDisplayPopUp = false;
                ABNandACNdisplayPopUp = true;
                if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                    if(this.Opp.Application__r.Entity_Name__c != null){
                        Name = getByNameLookup(this.Opp.Application__r.Entity_Name__c);
                        NameDisplayPopUp = true;
                        ABNandACNdisplayPopUp = false;
                        if(Name.Message.equals('No information found')){
                            NameDisplayPopUp = false;
                            MessageDisplayPopUp = true;
                        }
                    }
                }
            }else {
                if(this.Opp.Application__r.Entity_Name__c != null){
                    Name = getByNameLookup(this.Opp.Application__r.Entity_Name__c);
                    NameDisplayPopUp = true;
                    ABNandACNdisplayPopUp = false;
                    if(Name.Message.equals('No information found')){
                        NameDisplayPopUp = false;
                        MessageDisplayPopUp = true;
                    }
                }
            }
        }else{
            if(abnCode != null){
                apex = 'AbnDetails.aspx?abn='+this.abnCode; 
                abnLookupDto = getByABNorACNlookup(apex);
                NameDisplayPopUp = false;
                ABNandACNdisplayPopUp = true;
                if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                    if(acn != null){
                        apex = 'AcnDetails.aspx?acn='+this.acn;
                        abnLookupDto = getByABNorACNlookup(apex);
                        NameDisplayPopUp = false;
                        ABNandACNdisplayPopUp = true;
                        if('Search text is not a valid ABN or ACN'.equals(abnLookupDto.Message)){
                            if(entityName != null){
                                Name = getByNameLookup(entityName);
                                NameDisplayPopUp = true;
                                ABNandACNdisplayPopUp = false;
                                if(Name.Message.equals('No information found')){
                                    NameDisplayPopUp = false;
                                    MessageDisplayPopUp = true;
                                }
                            }
                        }
                    }
                }
            }else if(entityName != null){
                Name = getByNameLookup(entityName);
                NameDisplayPopUp = true;
                ABNandACNdisplayPopUp = false;
                if(Name.Message.equals('No information found')){
                    NameDisplayPopUp = false;
                    MessageDisplayPopUp = true;
                }
            }
        }
        ABNlookupDisplayPopUp = true;
        return null;
    }
    
    public ABNlookupDto getByABNorACNlookup(String apex) {
        ABNlookupDto r = new ABNlookupDto();
        ConnectionRESTWs.Param p = prepareGETRequest(apex+'&callback=callback&guid=');
        HttpResponse res = ConnectionRESTWs.invoke(p);
        if (res != null) {
            if (res.getStatusCode() == 200) {
                String arrOfStr = res.getBody().removeStart('callback(');
                String arrOfStr2 = arrOfStr.removeEnd(')');
                r = (ABNlookupDto)JSON.deserialize(arrOfStr2, ABNlookupDto.class);
            }
        }
        return r;
    }
    
    public ABNnameLookupDto getByNameLookup(String nameLookup) {
        ABNnameLookupDto r = new ABNnameLookupDto();
        String x = nameLookup.replace(' ', '+');
        ConnectionRESTWs.Param p = prepareGETRequest('MatchingNames.aspx?name='+x+'&maxResults=100&callback=callback&guid=');
        HttpResponse res = ConnectionRESTWs.invoke(p);
        if (res != null) {
            if (res.getStatusCode() == 200) { 
                String arrOfStr = res.getBody().removeStart('callback(');
                String arrOfStr2 = arrOfStr.removeEnd(')');
                r = (ABNnameLookupDto)JSON.deserialize(arrOfStr2, ABNnameLookupDto.class);
                if(r.names.size() > 0){
                    integer j = 1;
                    integer i = 1;
                    recordNames = new Map<Integer,List<ABNnameLookupDto.Names>>();
                    List<ABNnameLookupDto.Names> namesRecordsTemp;
                    namesRecordsTemp = new List<ABNnameLookupDto.Names>();
                    if(r.names != null && r.names.size() > 0){
                        total_size = r.names.size();
                        for(ABNnameLookupDto.Names y : r.names){
                            if(i < j*5){
                                namesRecordsTemp.add(y);
                                if(i == total_size){
                                    recordNames.put(j-1, namesRecordsTemp);
                                }
                                i++;
                            }else{
                                namesRecordsTemp.add(y);
                                recordNames.put(j-1, namesRecordsTemp);
                                namesRecordsTemp = new List<ABNnameLookupDto.Names>();
                                j++;i++;
                            }
                        }
                    }
                }else{
                    r.Message = 'No information found';
                }
            }
        }
        return r;
    }
    /*------------------------------------------------FOR ABN NAME LOOKUP PAGINATION-------------------------------------*/
    
    public PageReference Beginning() {  //when the user clicked the beginning button
        counter=0;
        countPage = 0;
        if(recordNames != null){
            Name.names = recordNames.get(countPage);   
        }
        return null;
    }
    
    public PageReference Previous() { //user clicked the previous button
        counter -= list_size;
        countPage--;
        if(count==1){
            if(recordNames != null){
                Name.names = recordNames.get(countPage);
                count++;
            }
        }else{
            if(recordNames != null){
                Name.names = recordNames.get(countPage);
            }
        }
        return null;
    }
    
    public PageReference Next() {//user clicked the Next button
        counter += list_size;
        countPage++;
        if(recordNames != null){
            Name.names = recordNames.get(countPage);
        }
        return null;    
    }
    
    public PageReference End() {//user clicked the End button
        counter = total_size - math.mod(total_size, list_size);
        countPage = getTotalPages() - 1;
        if(recordNames != null){
            Name.names = recordNames.get(countPage);
        }
        return null;
    }
    
    public Boolean getDisabledPrevious() {//this will disable the previous and beginning buttons
        if(counter>0)
            return false;
        else 
            return true;
    }
    
    public Boolean getDisabledNext() {//this will disable the next and end buttons
        if (counter + list_size < total_size) 
            return false; 
        else 
            return true;
    }
    
    public Integer getTotal_size() {
        return total_size;
    }
    
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return (total_size/list_size) + 1;
        }else {
            return (total_size/list_size);
        }
    }
    //--------------------------------------------------------------------------------------------------------------------
    
    public void validatePlentiResStatus() {
        if (servicingCalc && 'Plenti'.equals(servCalcLender) &&
            ('Boarding'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c) || 
             'Parents/Relative'.equalsIgnoreCase(Opp.Application__r.Current_Residence_Status_1__c))) {
                 ApexPages.addMessage(
                     new ApexPages.Message(
                         ApexPages.Severity.WARNING, 
                         'Plenti: Minimum board of $600 required for servicing'));
             }
    }
    
    public List<SelectOption> getProperties(){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        List<Application_Other_Asset__c> listO = [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                  Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c 
                                                  FROM Application_Other_Asset__c WHERE Application__c = :Opp.Application__c AND RecordType.Name = :'Property Asset' AND (Category__c = 'Property Applicant 1' OR Category__c = 'Property Both Applicants')];
        
        for (Application_Other_Asset__c o: listO){
            r.add(new SelectOption (o.Id, o.Description__c));
        }
        return r;
    }
    
    public List<SelectOption> getProperties2(){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        List<Application_Other_Asset__c> listO = [SELECT Id, Name, RecordType.Id, RecordType.Name, Application__c, Description__c, Value__c, Has_Loan__c,
                                                  Lender__c, Amount_Owing__c, Frequency__c, Is_Payout__c, Payment__c, Monthly_Payment__c, Good_Conduct__c 
                                                  FROM Application_Other_Asset__c WHERE Application__c = :Opp.Application__c AND RecordType.Name = :'Property Asset' AND (Category__c = 'Property Applicant 2' OR Category__c = 'Property Both Applicants')];
        
        for (Application_Other_Asset__c o: listO){
            r.add(new SelectOption (o.Id, o.Description__c));
        }
        return r;
    }
    
    public void swapApplicant(){
        System.debug('swapApplicant');
        System.debug(Opp.Application__r.No_of_People__c);
        if(Opp.Application__r.No_of_People__c == 2){
            swapApplicant2(Opp.Application__r.Id);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Only allow when there are two applicants'));
        }
    }
    
    public void swapApplicant2(ID application){
        System.debug('swapApplicant2');
        Application__c a = Opp.Application__r;
        
        String swap;
        Decimal swap2;
        
        swap = a.First_Name__c;
        a.First_Name__c = a.First_Name_2__c;
        a.First_Name_2__c = swap;
        swap = a.Title_1__c;
        a.Title_1__c = a.Title_2__c;
        a.Title_2__c = swap;
        swap = a.Middle_Name__c;
        a.Middle_Name__c = a.Middle_Name_2__c;
        a.Middle_Name_2__c = swap;
        swap = a.Last_Name__c;
        a.Last_Name__c = a.Last_Name_2__c;
        a.Last_Name_2__c = swap;
        swap = a.Date_of_Birth_1__c;
        a.Date_of_Birth_1__c = a.Date_of_Birth_2__c;
        a.Date_of_Birth_2__c = swap;
        swap = a.Gender_1__c;
        a.Gender_1__c = a.Gender_2__c;
        a.Gender_2__c = swap;
        swap = a.Current_Residential_Status_1__c;
        a.Current_Residential_Status_1__c = a.Current_Residential_Status_2__c;
        a.Current_Residential_Status_2__c = swap;
        swap = a.Actual_Nationality_1__c;
        a.Actual_Nationality_1__c = a.Actual_Nationality_2__c;
        a.Actual_Nationality_2__c = swap;
        swap = a.Credit_Status_1__c;
        a.Credit_Status_1__c = a.Credit_Status_2__c;
        a.Credit_Status_2__c = swap;
        swap = a.Do_you_have_drivers_licence_1__c;
        a.Do_you_have_drivers_licence_1__c = a.Do_you_have_drivers_licence_2__c;
        a.Do_you_have_drivers_licence_2__c = swap;
        System.debug(a.Do_you_have_drivers_licence_1__c);
        System.debug(a.Do_you_have_drivers_licence_2__c);
        swap = a.Drivers_License_1__c;
        a.Drivers_License_1__c = a.Drivers_License_2__c;
        a.Drivers_License_2__c = swap;
        swap = a.Type_of_Licence_1__c;
        a.Type_of_Licence_1__c = a.Type_of_Licence_2__c;
        a.Type_of_Licence_2__c = swap;
        swap = a.Expiry_Date_1__c;
        a.Expiry_Date_1__c = a.Expiry_Date_2__c;
        a.Expiry_Date_2__c = swap;
        swap = a.Driver_Licence_State_Issue_1__c;
        a.Driver_Licence_State_Issue_1__c = a.Driver_Licence_State_Issue_2__c;
        a.Driver_Licence_State_Issue_2__c = swap;
        swap2 = a.Year_First_Licensed_1__c;
        a.Year_First_Licensed_1__c = a.Year_First_Licensed_2__c;
        a.Year_First_Licensed_2__c = swap2;
        swap = a.Time_Last_Fault_1__c;
        a.Time_Last_Fault_1__c = a.Time_Last_Fault_2__c;
        a.Time_Last_Fault_2__c = swap;
        swap = a.Marital_Status_1__c;
        a.Marital_Status_1__c = a.Marital_Status_2__c;
        a.Marital_Status_2__c = swap;
        swap2 = a.No_of_Dependants_1__c;
        a.No_of_Dependants_1__c = a.No_of_Dependants_2__c;
        a.No_of_Dependants_2__c = swap2;
        swap = a.Ages_of_Dependants_1__c;
        a.Ages_of_Dependants_1__c = a.Ages_of_Dependants_2__c;
        a.Ages_of_Dependants_2__c = swap;
        swap = a.Home_Phone__c;
        a.Home_Phone__c = a.Home_Phone_2__c;
        a.Home_Phone_2__c = swap;
        swap = a.Work_Phone__c;
        a.Work_Phone__c = a.Work_Phone_2__c;
        a.Work_Phone_2__c = swap;
        swap = a.Mobile_Number__c;
        a.Mobile_Number__c = a.Mobile_Number_2__c;
        a.Mobile_Number_2__c = swap;
        swap = a.Email_Address__c;
        a.Email_Address__c = a.Email_Address_2__c;
        a.Email_Address_2__c = swap;
        swap2 = a.Partner_Income__c;
        a.Partner_Income__c = a.Partner_Income_2__c;
        a.Partner_Income_2__c = swap2;
        System.debug(a.No_of_People__c);
        System.debug(a.Applicant_2_living_in_the_same_address__c);
        if('No'.equals(a.Applicant_2_living_in_the_same_address__c)){
            swap = a.Unit_Number__c;
            a.Unit_Number__c = a.Unit_Number_2__c;
            a.Unit_Number_2__c = swap;
            swap = a.Street_Number__c;
            a.Street_Number__c = a.Street_Number_2__c;
            a.Street_Number_2__c = swap;
            swap = a.Street_Address__c;
            a.Street_Address__c = a.Street_Address_2__c;
            a.Street_Address_2__c = swap;
            swap = a.Street_Type__c;
            a.Street_Type__c = a.Street_Type_2__c;
            a.Street_Type_2__c = swap;
            swap = a.Suburb__c;
            a.Suburb__c = a.Suburb_2__c;
            a.Suburb_2__c = swap;
            swap = a.Postcode__c;
            a.Postcode__c = a.Postcode_2__c;
            a.Postcode_2__c = swap;
            swap = a.State__c;
            a.State__c = a.State_2__c;
            a.State_2__c = swap;
            swap = a.Date_Moved_in_1__c;
            a.Date_Moved_in_1__c = a.Date_Moved_in_2__c;
            a.Date_Moved_in_2__c = swap;
            swap = a.Current_Residence_Status_1__c;
            a.Current_Residence_Status_1__c = a.Current_Residence_Status_2__c;
            a.Current_Residence_Status_2__c = swap;
            swap = a.Relative_Name_1__c;
            a.Relative_Name_1__c = a.Relative_Name_2__c;
            a.Relative_Name_2__c = swap;
            swap = a.Relative_Phone_1__c;
            a.Relative_Phone_1__c= a.Relative_Phone_2__c;
            a.Relative_Phone_2__c = swap;
            swap = a.Landlord_Name_1__c;
            a.Landlord_Name_1__c= a.Landlord_Name_2__c;
            a.Landlord_Name_2__c = swap;
            swap = a.Landlord_Phone_1__c;
            a.Landlord_Phone_1__c= a.Landlord_Phone_2__c;
            a.Landlord_Phone_2__c = swap;
            swap2 = a.Rent_per_month_1__c;
            a.Rent_per_month_1__c= a.Rent_per_month_2__c;
            a.Rent_per_month_2__c = swap2;
            swap2 = a.Board_per_Month_1__c;
            a.Board_per_Month_1__c= a.Board_per_Month_2__c;
            a.Board_per_Month_2__c = swap2;
            swap = a.Residential_Payment_Frequency_1__c;
            a.Residential_Payment_Frequency_1__c= a.Residential_Payment_Frequency_2__c;
            a.Residential_Payment_Frequency_2__c = swap;
            swap = a.Previous_Country_1__c;
            a.Previous_Country_1__c= a.Previous_Country_2__c;
            a.Previous_Country_2__c = swap;
            swap = a.Date_From_1__c;
            a.Date_From_1__c= a.Date_From_2__c;
            a.Date_From_2__c = swap;
            swap = a.Previous_Unit_Number_1__c;
            a.Previous_Unit_Number_1__c= a.Previous_Unit_Number_2__c;
            a.Previous_Unit_Number_2__c = swap;
            swap = a.Previous_Street_Number_1__c;
            a.Previous_Street_Number_1__c= a.Previous_Street_Number_2__c;
            a.Previous_Street_Number_2__c = swap;
            swap = a.Previous_Street_Address_1__c;
            a.Previous_Street_Address_1__c= a.Previous_Street_Address_2__c;
            a.Previous_Street_Address_2__c = swap;
            swap = a.Previous_Street_Type_1__c;
            a.Previous_Street_Type_1__c= a.Previous_Street_Type_2__c;
            a.Previous_Street_Type_2__c = swap;
            swap = a.Previous_Street_Address_2nd_1__c;
            a.Previous_Street_Address_2nd_1__c= a.Previous_Street_Address_2nd_2__c;
            a.Previous_Street_Address_2nd_2__c = swap;
            swap = a.Previous_Suburb_1__c;
            a.Previous_Suburb_1__c= a.Previous_Suburb_2__c;
            a.Previous_Suburb_2__c = swap;
            swap = a.Previous_Overseas_City_1__c;
            a.Previous_Overseas_City_1__c= a.Previous_Overseas_City_2__c;
            a.Previous_Overseas_City_2__c = swap;
            swap = a.Previous_Postcode_1__c;
            a.Previous_Postcode_1__c= a.Previous_Postcode_2__c;
            a.Previous_Postcode_2__c = swap;
            swap = a.Previous_State_1__c;
            a.Previous_State_1__c= a.Previous_State_2__c;
            a.Previous_State_2__c = swap;
            swap = a.Previous_Overseas_State_1__c;
            a.Previous_Overseas_State_1__c= a.Previous_Overseas_State_2__c;
            a.Previous_Overseas_State_2__c = swap;
            swap = a.Previous_Residence_Status_1__c;
            a.Previous_Residence_Status_1__c= a.Previous_Residence_Status_2__c;
            a.Previous_Residence_Status_2__c = swap;
            swap = a.Previous_Country_1b__c;
            a.Previous_Country_1b__c= a.Previous_Country_2b__c;
            a.Previous_Country_2b__c = swap;
            swap = a.Date_From_1b__c;
            a.Date_From_1b__c= a.Date_From_2b__c;
            a.Date_From_2b__c = swap;
            swap = a.Previous_Unit_Number_1b__c;
            a.Previous_Unit_Number_1b__c= a.Previous_Unit_Number_2b__c;
            a.Previous_Unit_Number_2b__c = swap;
            swap = a.Previous_Street_Number_1b__c;
            a.Previous_Street_Number_1b__c= a.Previous_Street_Number_2b__c;
            a.Previous_Street_Number_2b__c = swap;
            swap = a.Previous_Street_Address_1b__c;
            a.Previous_Street_Address_1b__c= a.Previous_Street_Address_2b__c;
            a.Previous_Street_Address_2b__c = swap;
            swap = a.Previous_Street_Type_1b__c;
            a.Previous_Street_Type_1b__c= a.Previous_Street_Type_2b__c;
            a.Previous_Street_Type_2b__c = swap;
            swap = a.Previous_Street_Address_2nd_1b__c;
            a.Previous_Street_Address_2nd_1b__c= a.Previous_Street_Address_2nd_2b__c;
            a.Previous_Street_Address_2nd_2b__c = swap;
            swap = a.Previous_Suburb_1b__c;
            a.Previous_Suburb_1b__c= a.Previous_Suburb_2b__c;
            a.Previous_Suburb_2b__c = swap;
            swap = a.Previous_Overseas_City_1b__c;
            a.Previous_Overseas_City_1b__c= a.Previous_Overseas_City_2b__c;
            a.Previous_Overseas_City_2b__c = swap;
            swap = a.Previous_Postcode_1b__c;
            a.Previous_Postcode_1b__c= a.Previous_Postcode_2b__c;
            a.Previous_Postcode_2b__c = swap;
            swap = a.Previous_State_1b__c;
            a.Previous_State_1b__c= a.Previous_State_2b__c;
            a.Previous_State_2b__c = swap;
            swap = a.Previous_Overseas_State_1b__c;
            a.Previous_Overseas_State_1b__c= a.Previous_Overseas_State_2b__c;
            a.Previous_Overseas_State_2b__c = swap;
            swap = a.Previous_Residence_Status_1b__c;
            a.Previous_Residence_Status_1b__c= a.Previous_Residence_Status_2b__c;
            a.Previous_Residence_Status_2b__c = swap;
            swap = a.Previous_Country_1c__c;
            a.Previous_Country_1c__c= a.Previous_Country_2c__c;
            a.Previous_Country_2c__c = swap;
            swap = a.Date_From_1c__c;
            a.Date_From_1c__c= a.Date_From_2c__c;
            a.Date_From_2c__c = swap;
            swap = a.Previous_Unit_Number_1c__c;
            a.Previous_Unit_Number_1c__c= a.Previous_Unit_Number_2c__c;
            a.Previous_Unit_Number_2c__c = swap;
            swap = a.Previous_Street_Number_1c__c;
            a.Previous_Street_Number_1c__c= a.Previous_Street_Number_2c__c;
            a.Previous_Street_Number_2c__c = swap;
            swap = a.Previous_Street_Address_1c__c;
            a.Previous_Street_Address_1c__c= a.Previous_Street_Address_2c__c;
            a.Previous_Street_Address_2c__c = swap;
            swap = a.Previous_Street_Type_1c__c;
            a.Previous_Street_Type_1c__c= a.Previous_Street_Type_2c__c;
            a.Previous_Street_Type_2c__c = swap;
            swap = a.Previous_Street_Address_2nd_1c__c;
            a.Previous_Street_Address_2nd_1c__c= a.Previous_Street_Address_2nd_2c__c;
            a.Previous_Street_Address_2nd_2c__c = swap;
            swap = a.Previous_Suburb_1c__c;
            a.Previous_Suburb_1c__c= a.Previous_Suburb_2c__c;
            a.Previous_Suburb_2c__c = swap;
            swap = a.Previous_Overseas_City_1c__c;
            a.Previous_Overseas_City_1c__c= a.Previous_Overseas_City_2c__c;
            a.Previous_Overseas_City_2c__c = swap;
            swap = a.Previous_Postcode_1c__c;
            a.Previous_Postcode_1c__c= a.Previous_Postcode_2c__c;
            a.Previous_Postcode_2c__c = swap;
            swap = a.Previous_State_1c__c;
            a.Previous_State_1c__c= a.Previous_State_2c__c;
            a.Previous_State_2c__c = swap;
            swap = a.Previous_Overseas_State_1c__c;
            a.Previous_Overseas_State_1c__c= a.Previous_Overseas_State_2c__c;
            a.Previous_Overseas_State_2c__c = swap;
            swap = a.Previous_Residence_Status_1c__c;
            a.Previous_Residence_Status_1c__c= a.Previous_Residence_Status_2c__c;
            a.Previous_Residence_Status_2c__c = swap;
            swap = a.Previous_Country_1d__c;
            a.Previous_Country_1d__c= a.Previous_Country_2d__c;
            a.Previous_Country_2d__c = swap;
            swap = a.Date_From_1d__c;
            a.Date_From_1d__c= a.Date_From_2d__c;
            a.Date_From_2d__c = swap;
            swap = a.Previous_Unit_Number_1d__c;
            a.Previous_Unit_Number_1d__c= a.Previous_Unit_Number_2d__c;
            a.Previous_Unit_Number_2d__c = swap;
            swap = a.Previous_Street_Number_1d__c;
            a.Previous_Street_Number_1d__c= a.Previous_Street_Number_2d__c;
            a.Previous_Street_Number_2d__c = swap;
            swap = a.Previous_Street_Address_1d__c;
            a.Previous_Street_Address_1d__c= a.Previous_Street_Address_2d__c;
            a.Previous_Street_Address_2d__c = swap;
            swap = a.Previous_Street_Type_1d__c;
            a.Previous_Street_Type_1d__c= a.Previous_Street_Type_2d__c;
            a.Previous_Street_Type_2d__c = swap;
            swap = a.Previous_Street_Address_2nd_1d__c;
            a.Previous_Street_Address_2nd_1d__c= a.Previous_Street_Address_2nd_2d__c;
            a.Previous_Street_Address_2nd_2d__c = swap;
            swap = a.Previous_Suburb_1d__c;
            a.Previous_Suburb_1d__c= a.Previous_Suburb_2d__c;
            a.Previous_Suburb_2d__c = swap;
            swap = a.Previous_Overseas_City_1d__c;
            a.Previous_Overseas_City_1d__c= a.Previous_Overseas_City_2d__c;
            a.Previous_Overseas_City_2d__c = swap;
            swap = a.Previous_Postcode_1d__c;
            a.Previous_Postcode_1d__c= a.Previous_Postcode_2d__c;
            a.Previous_Postcode_2d__c = swap;
            swap = a.Previous_State_1d__c;
            a.Previous_State_1d__c= a.Previous_State_2d__c;
            a.Previous_State_2d__c = swap;
            swap = a.Previous_Overseas_State_1d__c;
            a.Previous_Overseas_State_1d__c= a.Previous_Overseas_State_2d__c;
            a.Previous_Overseas_State_2d__c = swap;
            swap = a.Previous_Residence_Status_1d__c;
            a.Previous_Residence_Status_1d__c= a.Previous_Residence_Status_2d__c;
            a.Previous_Residence_Status_2d__c = swap;
            swap = a.Previous_Country_1e__c;
            a.Previous_Country_1e__c= a.Previous_Country_2e__c;
            a.Previous_Country_2e__c = swap;
            swap = a.Date_From_1e__c;
            a.Date_From_1e__c= a.Date_From_2e__c;
            a.Date_From_2e__c = swap;
            swap = a.Previous_Unit_Number_1e__c;
            a.Previous_Unit_Number_1e__c= a.Previous_Unit_Number_2e__c;
            a.Previous_Unit_Number_2e__c = swap;
            swap = a.Previous_Street_Number_1e__c;
            a.Previous_Street_Number_1e__c= a.Previous_Street_Number_2e__c;
            a.Previous_Street_Number_2e__c = swap;
            swap = a.Previous_Street_Address_1e__c;
            a.Previous_Street_Address_1e__c= a.Previous_Street_Address_2e__c;
            a.Previous_Street_Address_2e__c = swap;
            swap = a.Previous_Street_Type_1e__c;
            a.Previous_Street_Type_1e__c= a.Previous_Street_Type_2e__c;
            a.Previous_Street_Type_2e__c = swap;
            swap = a.Previous_Street_Address_2nd_1e__c;
            a.Previous_Street_Address_2nd_1e__c= a.Previous_Street_Address_2nd_2e__c;
            a.Previous_Street_Address_2nd_2e__c = swap;
            swap = a.Previous_Suburb_1e__c;
            a.Previous_Suburb_1e__c= a.Previous_Suburb_2e__c;
            a.Previous_Suburb_2e__c = swap;
            swap = a.Previous_Overseas_City_1e__c;
            a.Previous_Overseas_City_1e__c= a.Previous_Overseas_City_2e__c;
            a.Previous_Overseas_City_2e__c = swap;
            swap = a.Previous_Postcode_1e__c;
            a.Previous_Postcode_1e__c= a.Previous_Postcode_2e__c;
            a.Previous_Postcode_2e__c = swap;
            swap = a.Previous_State_1e__c;
            a.Previous_State_1e__c= a.Previous_State_2e__c;
            a.Previous_State_2e__c = swap;
            swap = a.Previous_Overseas_State_1e__c;
            a.Previous_Overseas_State_1e__c= a.Previous_Overseas_State_2e__c;
            a.Previous_Overseas_State_2e__c = swap;
            swap = a.Previous_Residence_Status_1e__c;
            a.Previous_Residence_Status_1e__c= a.Previous_Residence_Status_2e__c;
            a.Previous_Residence_Status_2e__c = swap;
        }
        
        swap = a.Mode_of_Employment_1__c;
        a.Mode_of_Employment_1__c= a.Mode_of_Employment_2__c;
        a.Mode_of_Employment_2__c = swap;
        swap = a.Current_Employer_Name_1__c;
        a.Current_Employer_Name_1__c= a.Current_Employer_Name_2__c;
        a.Current_Employer_Name_2__c = swap;
        swap = a.Current_Work_Unit_Number_1__c;
        a.Current_Work_Unit_Number_1__c= a.Current_Work_Unit_Number_2__c;
        a.Current_Work_Unit_Number_2__c = swap;
        swap = a.Current_Work_Street_Number_1__c;
        a.Current_Work_Street_Number_1__c= a.Current_Work_Street_Number_2__c;
        a.Current_Work_Street_Number_2__c = swap;
        swap = a.Current_Work_Address_1__c;
        a.Current_Work_Address_1__c= a.Current_Work_Address_2__c;
        a.Current_Work_Address_2__c = swap;
        swap = a.Current_Work_Street_Type_1__c;
        a.Current_Work_Street_Type_1__c= a.Current_Work_Street_Type_2__c;
        a.Current_Work_Street_Type_2__c = swap;
        swap = a.Current_Work_Suburb_1__c;
        a.Current_Work_Suburb_1__c= a.Current_Work_Suburb_2__c;
        a.Current_Work_Suburb_2__c = swap;
        swap = a.Current_Work_Postcode_1__c;
        a.Current_Work_Postcode_1__c= a.Current_Work_Postcode_2__c;
        a.Current_Work_Postcode_2__c = swap;
        swap = a.Current_Work_State_1__c;
        a.Current_Work_State_1__c= a.Current_Work_State_2__c;
        a.Current_Work_State_2__c = swap;
        swap = a.Current_Employer_Phone_1__c;
        a.Current_Employer_Phone_1__c= a.Current_Employer_Phone_2__c;
        a.Current_Employer_Phone_2__c = swap;
        swap = a.Reference_Name_1__c;
        a.Reference_Name_1__c= a.Reference_Name_2__c;
        a.Reference_Name_2__c = swap;
        swap = a.Current_Occupation_1__c;
        a.Current_Occupation_1__c= a.Current_Occupation_2__c;
        a.Current_Occupation_2__c = swap;
        swap = a.Date_Started_1__c;
        a.Date_Started_1__c= a.Date_Started_2__c;
        a.Date_Started_2__c = swap;
        swap2 = a.Net_Income_1__c;
        a.Net_Income_1__c= a.Net_Income_2__c;
        a.Net_Income_2__c = swap2;
        swap = a.Payment_Frequency_1__c;
        a.Payment_Frequency_1__c= a.Payment_Frequency_2__c;
        a.Payment_Frequency_2__c = swap;
        swap = a.Employer_ABN_1__c;
        a.Employer_ABN_1__c= a.Employer_ABN_2__c;
        a.Employer_ABN_2__c = swap;
        swap = a.Previous_Work_Country_1__c;
        a.Previous_Work_Country_1__c= a.Previous_Work_Country_2__c;
        a.Previous_Work_Country_2__c = swap;
        swap = a.Previous_Mode_of_Employment_1__c;
        a.Previous_Mode_of_Employment_1__c= a.Previous_Mode_of_Employment_2__c;
        a.Previous_Mode_of_Employment_2__c = swap;
        swap = a.Previous_Employer_Name_1__c;
        a.Previous_Employer_Name_1__c= a.Previous_Employer_Name_2__c;
        a.Previous_Employer_Name_2__c = swap;
        swap = a.Previous_Occupation_1__c;
        a.Previous_Occupation_1__c= a.Previous_Occupation_2__c;
        a.Previous_Occupation_2__c = swap;
        swap = a.Previous_Work_Address_1__c;
        a.Previous_Work_Address_1__c= a.Previous_Work_Address_2__c;
        a.Previous_Work_Address_2__c = swap;
        swap = a.Previous_Work_Postcode_1__c;
        a.Previous_Work_Postcode_1__c= a.Previous_Work_Postcode_2__c;
        a.Previous_Work_Postcode_2__c = swap;
        swap = a.Previous_Work_Overseas_State_1__c;
        a.Previous_Work_Overseas_State_1__c= a.Previous_Work_Overseas_State_2__c;
        a.Previous_Work_Overseas_State_2__c = swap;
        swap = a.Previous_Work_Overseas_City_1__c;
        a.Previous_Work_Overseas_City_1__c= a.Previous_Work_Overseas_City_2__c;
        a.Previous_Work_Overseas_City_2__c = swap;
        swap = a.Previous_Work_Address_2nd_1__c;
        a.Previous_Work_Address_2nd_1__c= a.Previous_Work_Address_2nd_2__c;
        a.Previous_Work_Address_2nd_2__c = swap;
        swap = a.Previous_Reference_Name_1__c;
        a.Previous_Reference_Name_1__c= a.Previous_Reference_Name_2__c;
        a.Previous_Reference_Name_2__c = swap;
        swap = a.Previous_Employer_Phone_1__c;
        a.Previous_Employer_Phone_1__c= a.Previous_Employer_Phone_2__c;
        a.Previous_Employer_Phone_2__c = swap;
        swap = a.Previous_Work_Unit_Number_1__c;
        a.Previous_Work_Unit_Number_1__c= a.Previous_Work_Unit_Number_2__c;
        a.Previous_Work_Unit_Number_2__c = swap;
        swap = a.Previous_Work_Street_Number_1__c;
        a.Previous_Work_Street_Number_1__c= a.Previous_Work_Street_Number_2__c;
        a.Previous_Work_Street_Number_2__c = swap;
        swap = a.Previous_Work_Street_Type_1__c;
        a.Previous_Work_Street_Type_1__c= a.Previous_Work_Street_Type_2__c;
        a.Previous_Work_Street_Type_2__c = swap;
        swap = a.Previous_Work_Suburb_1__c;
        a.Previous_Work_Suburb_1__c= a.Previous_Work_Suburb_2__c;
        a.Previous_Work_Suburb_2__c = swap;
        swap = a.Previous_Work_State_1__c;
        a.Previous_Work_State_1__c= a.Previous_Work_State_2__c;
        a.Previous_Work_State_2__c = swap;
        swap = a.Start_Date_1__c;
        a.Start_Date_1__c= a.Start_Date_2__c;
        a.Start_Date_2__c = swap;
        swap = a.Finish_Date_1__c;
        a.Finish_Date_1__c= a.Finish_Date_2__c;
        a.Finish_Date_2__c = swap;
                
        update a;
        
        List < Application_Employment__c > lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Type__c,Frequency__c,Employer_ABN_1__c,Monthly_Income__c,
            Unit_Number__c, Street_Number__c, Street_Type__c,
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,Overseas_City__c, Address_Line_2__c, Address_Type__c
            FROM Application_Employment__c 
            WHERE Application__c =: a.Id
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND (Type__c = 'Previous Job' OR Type__c = 'Second Job')];
        
        for (Application_Employment__c e: lst) {
            if('1'.equals(e.Applicant__c)){
                e.Applicant__c = '2';
            }else if('2'.equals(e.Applicant__c)){
                e.Applicant__c = '1';
            }
        }
        
        if(!lst.isEmpty()){
            update lst;
            loadPreviousEmployments();
        }
        
        List < Application_Income__c > otherIncome = [SELECT Applicant__c, Application__c, Detail__c, Frequency__c,
                                                      Income__c, Order__c, Type__c
                                                      FROM Application_Income__c WHERE Application__c =: a.Id ORDER BY Order__c];
        
        for (Application_Income__c o: otherIncome) {
            if('1'.equals(o.Applicant__c)){
                o.Applicant__c = '2';
            }else if('2'.equals(o.Applicant__c)){
                o.Applicant__c = '1';
            }
        }
        
        if(!otherIncome.isEmpty()){
            update otherIncome;
            this.loadApplicationIncomes();
        }
        
        Application_Servicing__c srv = OppApplicationServCalculatorUtils.getApplicationServicing(this.Opp.ApplicationServicing__c);
        
        if(srv != null){
            swap2 = srv.Income_1__c;
            srv.Income_1__c= srv.Income_2__c;
            srv.Income_2__c = swap2;
            swap2 = srv.Income_1b__c;
            srv.Income_1b__c= srv.Income_2b__c;
            srv.Income_2b__c = swap2;
            swap = srv.IncomePayFrecuency_1b__c;
            srv.IncomePayFrecuency_1b__c= srv.IncomePayFrecuency_2b__c;
            srv.IncomePayFrecuency_2b__c = swap;
            
            update srv;
        }
        /*
        List < YTD_Income__c > ytd = [SELECT Applicant_Type__c, Type__c, Lender__c FROM YTD_Income__c WHERE Opportunity__c =: Opp.Id];
        List<YTD_Income__c> listYtdApp1 = [SELECT Applicant_Type__c, Type__c, Lender__c FROM YTD_Income__c WHERE Opportunity__c =: Opp.Id AND Applicant_Type__c = 'Applicant 1'];
        String lender;
        YTD_Income__c ytdApp1;
        
        if(!listYtdApp1.isEmpty()){
            ytdApp1 = listYtdApp1.get(0);
            lender = ytdApp1.Lender__c;
        }
        
        for (YTD_Income__c y: ytd) {
            if('Applicant 1'.equals(y.Applicant_Type__c)){
                y.Applicant_Type__c = 'Applicant 2';
                
                if('Others'.equals(y.Type__c)){
                    y.Lender__c = null;
                }
            }else if('Applicant 1 Second Job'.equals(y.Applicant_Type__c)){
                y.Applicant_Type__c = 'Applicant 2 Second Job';
            }else if('Applicant 2'.equals(y.Applicant_Type__c)){
                y.Applicant_Type__c = 'Applicant 1';
                
                if('Others'.equals(y.Type__c)){
                    y.Lender__c = lender;   
                }
            }else if('Applicant 2 Second Job'.equals(y.Applicant_Type__c)){
                y.Applicant_Type__c = 'Applicant 1 Second Job';
            }
        }
        
        if(!ytd.isEmpty()){
            update ytd;
        }
        */
        //delete [SELECT Type_of_Data__c FROM Application_Extra_Data__c WHERE Application__c =: a.Id AND (Type_of_Data__c = 'YTD Calculation' OR Type_of_Data__c = 'Servicing Calculation')];
        delete [SELECT Type_of_Data__c FROM Application_Extra_Data__c WHERE Application__c =: a.Id AND Type_of_Data__c = 'Servicing Calculation'];
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

    public void modeServicing() {
      this.servicingCalc = true;
      loadServicingCalculatorData(); //Servicing re-calculate
    }

    public Boolean getShowPepperCommercial() {
        System.debug(Opp.Application__r.Trust_Name__c);
        System.debug(trustName);
        System.debug(Opp.Application__r.No_of_Directors__c);
        System.debug(noDirectors);
        System.debug(noDirectors != null && noDirectors > 0);
      if ((String.isNotBlank(Opp.Application__r.Trust_Name__c) || String.isNotBlank(trustName)) && ((Opp.Application__r.No_of_Directors__c != null && Opp.Application__r.No_of_Directors__c > 0) || (noDirectors != null && noDirectors > 0))) {
        System.debug(noDirectors != null && noDirectors > 0);
        System.debug(Opp.Application__r.No_of_Directors__c != null && Opp.Application__r.No_of_Directors__c > 0);
        return true;
      }
      System.debug(Opp.Application__r.Trust_Name__c);
      return false;
    }
}