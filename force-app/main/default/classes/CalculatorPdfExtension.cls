public class CalculatorPdfExtension {
    // univeral variables
    public String lender {get;set;}
    // vehicles details
    public String state {get;set;}
    public String vehicleGroup {get;set;}
    public String awd {get;set;}
    public String turbo {get;set;}
    public String diesel {get;set;}
    // insurance details
    public String gapLevel {get;set;}
    public String gap {get;set;}
    public String gapIncome {get;set;}
    public String gapPayType {get;set;}
    public String nwcLevel {get;set;}
    public String nwc {get;set;}
    public String nwcIncome {get;set;}
    public String nwcPayType {get;set;}
    //HJ - NWCCalculator - 31-08-2018 -I
    //public String nwcAwd4wd {set; get;}
    //public String nwcLuxuryCar {set; get;}
    public String nwcType_p {set; get;}
    public String nwcEngine {set; get;}
    public String nwcIsManuallyNWCPrice {set; get;}
    public String nwcTerm {set; get;}
    public String nwcPlan {set; get;}
    public String nwcAssetType {set; get;}
    public String nwcState {set; get;}
    //HJ - NWCCalculator - 31-08-2018 -F
    public String warrantyLevel {get;set;}
    public String warranty {get;set;}
    public String warrantyIncome {get;set;}
    public String warrantyPayType {get;set;}
    public String ltiLevel {get;set;}
    public String lti {get;set;}
    public String ltiIncome {get;set;}
    public String truckGapLevel {get;set;}
    public String truckGap {get;set;}
    public String truckGapIncome {get;set;}
    public String taiLevel {get;set;}
    public String tai {get;set;}
    public String taiIncome {get;set;}
    public String mvLevel {get;set;}
    public String mv {get;set;}
    public String mvIncome {get;set;}
    public String mvPayType {get;set;}
    public String cciLevel {get;set;}
    public String cci {get;set;}
    public String cciIncome {get;set;}
    public String cciPayType {get;set;}
    // finance and loan details
    public String carPrice {get;set;}
    public String deposit {get;set;}
    public String applicationFee {get;set;}
    public String dof {get;set;}
    public String ppsr {get;set;}
    public String residualValue {get;set;}
    public Boolean highlightResidualValue {get;set;}
    public String brokeragePercentage {get;set;}
        // Pepper calculators do not have base Rate
    public String baseRate {get;set;}
    public String maxRate {get;set;}
    public String clientRate {get;set;}
    public String term {get;set;}
    public String paymentType {get;set;}
    public String repaymentType {get;set;}
    // Commission and Repayment
    public String estimatedCommission {get;set;}
    public String insuranceIncome {get;set;}
    public String dofResult {get;set;}
    public String totalCommission {get;set;}
    public String totalCommissionGst {get;set;}
    public String naf {get;set;}
    public String rental {get;set;}
    public String monthlyFee {get;set;}
    public String monthlyPayment {get;set;}
    public String fortnightlyPayment {get;set;}
    public String weeklyPayment {get;set;}
    // specific variables
    // specific for ANZ consumer and commercial
    public String adverseCredit {get;set;}
    public String customerProfile {get;set;}
    public String ltv {get;set;}
    // specific for ANZ others
    public String recommendedRate {get;set;}
    public String goodsType {get;set;}
    public String vehiclesProfile {get;set;}
    public String loanFacilityType {get;set;}
    // specific for Macquarie Consumer
    public String brokerage {get;set;}
    public String carAge {get;set;}
    public String vehCon {get;set;}
    public String motorCycles {get;set;}
    public String caravanCampervans {get;set;}
    public String privateSales {get;set;}
    // specific for Pepper MV, Pepper Leisure, and Pepper 5 Oh!
    public String registrationFee {get;set;}
    public String clientTier {get;set;}
    // specific for St George MV and Leisure
    public String loanType {get;set;}
    public String paymentFrequency {get;set;}
    public String carType {get;set;}
    // specific for Liberty Drive and Options
    public String lvr {get;set;}
        // St George calculators have loanType as well
    public String vehicleAge {get;set;}
    public String vehicleCondition {get;set;}
        // specific for Liberty Options only
    public String riskFee {get;set;}
    public String commission {get;set;}
    public String rateOption {get;set;}
        // insurance details only for Liberty
    public String isp {get;set;}
    public String ispIncome {get;set;}
    public String fpa {get;set;}
    public String fpaIncome {get;set;}
    public String veiLevel {get;set;}
    public String vei {get;set;}
    public String veiIncome {get;set;}
    public String lpiLevel {get;set;}
    public String lpi {get;set;}
    public String lpiIncome {get;set;}
    // specific for Finance One
      // will use loanType in St George and riskFee in Liberty
    // control the PDF content for Liberty Insurance Product
    public String libertyBoolean {get;set;}
    public Boolean isLiberty {get;set;}
    // the variables for saving the product
    public String productLoanType {get;set;}
    public String productGoodsType {get;set;}
    public String productGoodsSubType {get;set;}
    //Metro / Latitude
    public String saleBacksPurchased {get;set;}
	
    public String extraLabel1 {get;set;}
    public String extraLabel2 {get;set;}
    public String extraLabel3 {get;set;}
    public String extraLabel4 {get;set;}
    
    public String extraValue1 {get;set;}
    public String extraValue2 {get;set;}
    public String extraValue3 {get;set;}
    public String extraValue4 {get;set;}

    public String loanTypeDetail {get;set;}
    public String tradeIn {get;set;}
    public String payoutOn {get;set;}
    public String netDeposit {get;set;}
    
    public String insuranceInputMode {get;set;}
    
    //HJ - Add loanFrequency 24-08-2018
    public String loanFrequency {set; get;}
    // Lelo                 2018-11-01
    public String creditScore {set; get;}
    public String enquiries {set; get;}
    public String riskGrade {set; get;}
    public String bankrupt {set; get;}
    public String residency {set; get;}
    public String rateType {set; get;}
    public String greenCar {set; get;}
    public String defaults {set; get;}
    public String payDayEnquiries {get;set;}
    public String hasImports {get;set;}
    public String calcBonus {set; get;}
    public String repayment {set; get;}
    public String aclCreditScore {set; get;}
    public String vehicleYear {set; get;}
    
    
    public String loanPurpose {set; get;}
    public String purposeType {set; get;}
    // Lelo                                   2020-08-11
    public String commissionType {set; get;}
    //-

    public String leaseAgreement {set; get;}
    public String GST {set; get;}
    public String abn {set; get;}
    public String interestType {set; get;}
    public String propertyOwner {set; get;}
    public String assetType {set; get;}
    public String companyScore {set; get;}
    public String directorSoleTraderScore {set; get;}
    public String paidDefault {set; get;}
    public String condition {set; get;}
    public String abnLength {set; get;}
    public String gstLength {set; get;}
    public String assetAge {set; get;}
    public String equifaxScore {set; get;}
    
    public Custom_Opportunity__c opp;

    public CalculatorPdfExtension (ApexPages.StandardController controller) {
        Set<String> fields = new Set<String>{
          'OwnerId'
        };
        if (!Test.isRunningTest()) controller.addFields(new List<String>(fields));
        this.opp = (Custom_Opportunity__c)controller.getRecord ();

        isLiberty = false;
        lender = System.currentPageReference().getParameters().get('lender');
        // vehicles details
        state = System.currentPageReference().getParameters().get('state');
        vehicleGroup = System.currentPageReference().getParameters().get('vehicleGroup');
        awd = System.currentPageReference().getParameters().get('awd');
        turbo = System.currentPageReference().getParameters().get('turbo');
        diesel = System.currentPageReference().getParameters().get('diesel');
        vehicleYear = System.currentPageReference().getParameters().get('vehicleYear');
        // insurance details
        gapLevel = System.currentPageReference().getParameters().get('gapLevel');
        
        gap = System.currentPageReference().getParameters().get('gap');
        if (String.isNotBlank(gap)) {
            gap = '$' + gap;
        } else {
            gap = '$0.00';
        }
        
        gapIncome = System.currentPageReference().getParameters().get('gapIncome');
        if (String.isNotBlank(gapIncome)) {
            gapIncome = '$' + gapIncome;
        } else {
            gapIncome = '$0.00';
        }
        
        nwc = System.currentPageReference().getParameters().get('nwc');
        if (String.isNotBlank(nwc)) {
            nwc = '$' + nwc;
        } else {
            nwc = '$0.00';
        }
        nwcLevel = System.currentPageReference().getParameters().get('nwcLevel');
        nwcIncome = System.currentPageReference().getParameters().get('nwcIncome');
        if (String.isNotBlank(nwcIncome)) {
            nwcIncome = '$' + nwcIncome;
        } else {
            nwcIncome = '$0.00';
        }
        
        //HJ - NWCCalculator - 31-08-2018 - I
        /**
        nwcAwd4wd = System.currentPageReference().getParameters().get('nwcAwd4wd');
        if (nwcAwd4wd == null){
            nwcAwd4wd = '';
        }
        nwcLuxuryCar = System.currentPageReference().getParameters().get('nwcLuxuryCar');
        if (nwcLuxuryCar == null){
            nwcLuxuryCar = '';
        }
        **/
        nwcType_p = System.currentPageReference().getParameters().get('nwcType_p');
        if (nwcType_p == null){
            nwcType_p = '';
        }
        nwcEngine = System.currentPageReference().getParameters().get('nwcEngine');
        if (nwcEngine == null){
            nwcEngine = '';
        }
        nwcIsManuallyNWCPrice = System.currentPageReference().getParameters().get('nwcIsManuallyNWCPrice');
        if (nwcIsManuallyNWCPrice == null){
            nwcIsManuallyNWCPrice = '';
        }
        nwcTerm = System.currentPageReference().getParameters().get('nwcTerm');
        if (nwcTerm == null){
            nwcTerm = '';
        }
        nwcPlan = System.currentPageReference().getParameters().get('nwcPlan');
        if (nwcPlan == null){
            nwcPlan = '';
        }
        
        nwcAssetType = System.currentPageReference().getParameters().get('nwcAssetType');
        nwcState = System.currentPageReference().getParameters().get('nwcState');
        //HJ - NWCCalculator - 31-08-2018 - F
        
        warrantyLevel = System.currentPageReference().getParameters().get('warrantyLevel');
        
        warranty = System.currentPageReference().getParameters().get('warranty');
        if (String.isNotBlank(warranty)) {
            warranty = '$' + warranty;
        } else {
            warranty = '$0.00';
        }

        warrantyIncome = System.currentPageReference().getParameters().get('warrantyIncome');
        if (String.isNotBlank(warrantyIncome)) {
            warrantyIncome = '$' + warrantyIncome;
        } else {
            warrantyIncome = '$0.00';
        }

        ltiLevel = System.currentPageReference().getParameters().get('ltiLevel');
        
        lti = System.currentPageReference().getParameters().get('lti');
        if (String.isNotBlank(lti)) {
            lti = '$' + lti;
        } else {
            lti = '$0.00';
        }

        ltiIncome = System.currentPageReference().getParameters().get('ltiIncome');
        if (String.isNotBlank(ltiIncome)) {
            ltiIncome = '$' + ltiIncome;
        } else {
            ltiIncome = '$0.00';
        }

        truckGapLevel = System.currentPageReference().getParameters().get('truckGapLevel');
        
        truckGap = System.currentPageReference().getParameters().get('truckGap');
        if (String.isNotBlank(truckGap)) {
            truckGap = '$' + truckGap;
        } else {
            truckGap = '$0.00';
        }

        truckGapIncome = System.currentPageReference().getParameters().get('truckGapIncome');
        if (String.isNotBlank(truckGapIncome)) {
            truckGapIncome = '$' + truckGapIncome;
        } else {
            truckGapIncome = '$0.00';
        }

        taiLevel = System.currentPageReference().getParameters().get('taiLevel');
        
        tai = System.currentPageReference().getParameters().get('tai');
        if (String.isNotBlank(tai)) {
            tai = '$' + tai;
        } else {
            tai = '$0.00';
        }

        taiIncome = System.currentPageReference().getParameters().get('taiIncome');
        if (String.isNotBlank(taiIncome)) {
            taiIncome = '$' + taiIncome;
        } else {
            taiIncome = '$0.00';
        }

        mvLevel = System.currentPageReference().getParameters().get('mvLevel');
        
        mv = System.currentPageReference().getParameters().get('mv');
        if (String.isNotBlank(mv)) {
            mv = '$' + mv;
        } else {
            mv = '$0.00';
        }

        mvIncome = System.currentPageReference().getParameters().get('mvIncome');
        if (String.isNotBlank(mvIncome)) {
            mvIncome = '$' + mvIncome;
        } else {
            mvIncome = '$0.00';
        }

        cciLevel = System.currentPageReference().getParameters().get('cciLevel');
        cci = System.currentPageReference().getParameters().get('cci');
        if (String.isNotBlank(cci)) {
            cci = '$' + cci;
        } else {
            cci = '$0.00';
        }

        cciIncome = System.currentPageReference().getParameters().get('cciIncome');
        if (String.isNotBlank(cciIncome)) {
            cciIncome = '$' + cciIncome;
        } else {
            cciIncome = '$0.00';
        }

        // finance and loan details
        carPrice = System.currentPageReference().getParameters().get('carPrice');
        carPrice = '$' + carPrice;
        
        applicationFee = System.currentPageReference().getParameters().get('applicationFee');
        applicationFee = '$' + applicationFee;
        dof = System.currentPageReference().getParameters().get('dof');
        dof = '$' + dof;
        ppsr = System.currentPageReference().getParameters().get('ppsr');
        ppsr = '$' + ppsr;
        residualValue = System.currentPageReference().getParameters().get('residualValue');
        highlightResidualValue = false;
        System.debug('residualValue >> ' + residualValue + ' | highlightResidualValue >> ' + highlightResidualValue);
        if (String.isNotBlank(residualValue)) {
            try {
                Decimal v = Decimal.valueOf(residualValue);
                if (v > 0.0) {
                    highlightResidualValue = true;
                }
            } catch (Exception e) {}
        }
        if(String.isNotBlank(residualValue)){
          residualValue = '$' + residualValue;
        }
        System.debug('residualValue >> ' + residualValue + ' | highlightResidualValue >> ' + highlightResidualValue);
        //Macquorie
        brokeragePercentage = System.currentPageReference().getParameters().get('brokeragePercentage');
        if (String.isNotBlank(brokeragePercentage) && !'N/A'.equals(maxRate)) {
          brokeragePercentage = brokeragePercentage + '%';
        }
        // Pepper calculators do not have base Rate
        baseRate = System.currentPageReference().getParameters().get('baseRate');
        if(String.isNotBlank(baseRate)){
          baseRate = baseRate + '%';
        }
        clientRate = System.currentPageReference().getParameters().get('clientRate');
        clientRate = clientRate + '%';
        maxRate = System.currentPageReference().getParameters().get('maxRate');
        if (String.isNotBlank(maxRate) && !'N/A'.equals(maxRate)) {
            maxRate = maxRate + '%';
        }
        term = System.currentPageReference().getParameters().get('term');
        paymentType = System.currentPageReference().getParameters().get('paymentType');
        repaymentType = System.currentPageReference().getParameters().get('repaymentType');
        // Commission and Repayment
        estimatedCommission = System.currentPageReference().getParameters().get('estimatedCommission');
        estimatedCommission = '$' + estimatedCommission;
        insuranceIncome = System.currentPageReference().getParameters().get('insuranceIncome');
        insuranceIncome = '$' + insuranceIncome;
        dofResult = System.currentPageReference().getParameters().get('dofResult');
        dofResult = '$' + dofResult;
        totalCommission = System.currentPageReference().getParameters().get('totalCommission');
        totalCommission = '$' + totalCommission;
        totalCommissionGst = System.currentPageReference().getParameters().get('totalCommissionGst');
        totalCommissionGst = '$' + totalCommissionGst;
        naf = System.currentPageReference().getParameters().get('naf');
        naf = '$' + naf;
        rental = System.currentPageReference().getParameters().get('rental');
        rental = '$' + rental;
        monthlyFee = System.currentPageReference().getParameters().get('monthlyFee');
        monthlyFee = '$' + monthlyFee;
        monthlyPayment = System.currentPageReference().getParameters().get('monthlyPayment');
        monthlyPayment =  '$' + monthlyPayment;
        fortnightlyPayment = System.currentPageReference().getParameters().get('fortnightlyPayment');
        fortnightlyPayment = '$' + fortnightlyPayment;
        weeklyPayment = System.currentPageReference().getParameters().get('weeklyPayment');
        weeklyPayment = '$' + weeklyPayment;
        // specific variables
        // specific for ANZ consumer and commercial
        adverseCredit = System.currentPageReference().getParameters().get('adverseCredit');
        customerProfile = System.currentPageReference().getParameters().get('customerProfile');
        ltv = System.currentPageReference().getParameters().get('ltv');
        if (String.isNotBlank(ltv)) {
          ltv += ltv.isNumeric()? '%' : '';
        }
        // specific for ANZ others
        recommendedRate = System.currentPageReference().getParameters().get('recommendedRate');
        recommendedRate = recommendedRate + '%';
        goodsType = System.currentPageReference().getParameters().get('goodsType');
        vehiclesProfile = System.currentPageReference().getParameters().get('vehiclesProfile');
        loanFacilityType = System.currentPageReference().getParameters().get('loanFacilityType');
        // specific for Macquarie Consumer
        brokerage = System.currentPageReference().getParameters().get('brokerage');
        brokerage = brokerage + '%';
        carAge = System.currentPageReference().getParameters().get('carAge');
        vehCon = System.currentPageReference().getParameters().get('vehCon');
        motorCycles = System.currentPageReference().getParameters().get('motorCycles');
        caravanCampervans = System.currentPageReference().getParameters().get('caravanCampervans');
        privateSales = System.currentPageReference().getParameters().get('privateSales');
        // specific for Pepper MV, Pepper Leisure, and Pepper 5 Oh!
        registrationFee = System.currentPageReference().getParameters().get('registrationFee');
        registrationFee = '$' + registrationFee;
        clientTier = System.currentPageReference().getParameters().get('clientTier');
        // specific for St George MV and Leisure
        loanType = System.currentPageReference().getParameters().get('loanType');
        paymentFrequency = System.currentPageReference().getParameters().get('paymentFrequency');
        carType = System.currentPageReference().getParameters().get('carType');
        // specific for Liberty Drive and Options
        lvr = System.currentPageReference().getParameters().get('lvr');
        lvr = lvr + '%';
            // St George calculators have loanType as well
        vehicleAge = System.currentPageReference().getParameters().get('vehicleAge');
        vehicleCondition = System.currentPageReference().getParameters().get('vehicleCondition');
        greenCar = System.currentPageReference().getParameters().get('greenCar');
        if (String.isNotBlank(greenCar)) {
            if ('Y'.equals(greenCar)) {
                greenCar = 'Yes';
            } else if ('N'.equals(greenCar)) {
                greenCar = 'No';
            }
        }
        
        repayment = System.currentPageReference().getParameters().get('repayment');
        aclCreditScore = System.currentPageReference().getParameters().get('aclCreditScore');
        calcBonus = '$' + System.currentPageReference().getParameters().get('calcBonus');
        // specific for Liberty Options only
        riskFee = System.currentPageReference().getParameters().get('riskFee');
        riskFee = '$' + riskFee;
        commission = System.currentPageReference().getParameters().get('commission');
        commission = '$' + commission;
        rateOption = System.currentPageReference().getParameters().get('rateOption');
            // insurance details only for Liberty
        isp = System.currentPageReference().getParameters().get('isp');
        isp = '$' + isp;
        ispIncome = System.currentPageReference().getParameters().get('ispIncome');
        ispIncome = '$' + ispIncome;
        fpa = System.currentPageReference().getParameters().get('fpa');
        fpa = '$' + fpa;
        fpaIncome = System.currentPageReference().getParameters().get('fpaIncome');
        fpaIncome = '$' + fpaIncome;
        veiLevel = System.currentPageReference().getParameters().get('veiLevel');
        vei = System.currentPageReference().getParameters().get('vei');
        vei = '$' + vei;
        veiIncome = System.currentPageReference().getParameters().get('veiIncome');
        veiIncome = '$' + veiIncome;
        lpiLevel = System.currentPageReference().getParameters().get('lpiLevel');
        lpi = System.currentPageReference().getParameters().get('lpi');
        lpi = '$' + lpi;
        lpiIncome = System.currentPageReference().getParameters().get('lpiIncome');
        lpiIncome = '$' + lpiIncome;
        // specific for Finance One
            // will use loanType in St George and riskFee in Liberty
        // the boolean to control PDF content
        libertyBoolean = System.currentPageReference().getParameters().get('isLiberty');
        if (libertyBoolean == 'true') {
            isLiberty = true;
        }

        // Insurance Payment type
        mvPayType = System.currentPageReference().getParameters().get('mvPayType');
        mvPayType = String.isNotBlank(mvPayType)? mvPayType : '';
        gapPayType = System.currentPageReference().getParameters().get('gapPayType');
        gapPayType = String.isNotBlank(gapPayType)? gapPayType : '';
        cciPayType = System.currentPageReference().getParameters().get('cciPayType');
        cciPayType = String.isNotBlank(cciPayType)? cciPayType : '';
        warrantyPayType = System.currentPageReference().getParameters().get('warrantyPayType');
        warrantyPayType = String.isNotBlank(warrantyPayType)? warrantyPayType : '';
        nwcPayType = System.currentPageReference().getParameters().get('nwcPayType');
        nwcPayType = String.isNotBlank(nwcPayType)? nwcPayType : '';
        

        // the variables for saving the product
        productLoanType = System.currentPageReference().getParameters().get('productLoanType');
        productGoodsType = System.currentPageReference().getParameters().get('productGoodsType');
        productGoodsSubType = System.currentPageReference().getParameters().get('productGoodsSubType');
        
        //HJ - Add loanFrequency - 24-08-2018
        loanFrequency = System.currentPageReference().getParameters().get('loanFrequency');
        
        //Metro
        saleBacksPurchased = System.currentPageReference().getParameters().get('saleBacksPurchased');
        //Geberal
        extraLabel1 = System.currentPageReference().getParameters().get('extraLabel1');
        extraValue1 = '$' + System.currentPageReference().getParameters().get('extraValue1');
        extraLabel2 = System.currentPageReference().getParameters().get('extraLabel2');
        extraValue2 = '$' + System.currentPageReference().getParameters().get('extraValue2');
        extraLabel3 = System.currentPageReference().getParameters().get('extraLabel3');
        extraValue3 = '$' + System.currentPageReference().getParameters().get('extraValue3');
        extraLabel4 = System.currentPageReference().getParameters().get('extraLabel4');
        extraValue4 = '$' + System.currentPageReference().getParameters().get('extraValue4');
        
        loanTypeDetail = System.currentPageReference().getParameters().get('loanTypeDetail');
        deposit = System.currentPageReference().getParameters().get('deposit');
        if (!String.isBlank(deposit)) {
            deposit = '$' + deposit;
        } else {
            deposit = '$';
        }
        tradeIn = System.currentPageReference().getParameters().get('tradeIn');
        if (!String.isBlank(tradeIn)) {
            tradeIn = '$' + tradeIn;
        } else {
            tradeIn = '$';
        }
        payoutOn = System.currentPageReference().getParameters().get('payoutOn');
        if (!String.isBlank(payoutOn)) {
            payoutOn = '$' + payoutOn;
        } else {
            payoutOn = '$';
        }
        netDeposit = System.currentPageReference().getParameters().get('netDeposit');
        if (!String.isBlank(netDeposit)) {
            netDeposit = '$' + netDeposit;
        } else {
            netDeposit = '$';
        }
        insuranceInputMode = System.currentPageReference().getParameters().get('insuranceInputMode');
        if (String.isBlank(insuranceInputMode)) {
            insuranceInputMode = 'M';
        }

        this.creditScore = System.currentPageReference().getParameters().get('creditScore');
        this.enquiries = System.currentPageReference().getParameters().get('enquiries');
        this.riskGrade = System.currentPageReference().getParameters().get('riskGrade');
        this.bankrupt = System.currentPageReference().getParameters().get('bankrupt');
        this.residency = System.currentPageReference().getParameters().get('residency');
        this.rateType = System.currentPageReference().getParameters().get('rateType');
        this.defaults = System.currentPageReference().getParameters().get('defaults');
        this.loanPurpose = System.currentPageReference().getParameters().get('loanPurpose');
        this.purposeType = System.currentPageReference().getParameters().get('purposeType');
        this.payDayEnquiries = System.currentPageReference().getParameters().get('payDayEnquiries');
        this.hasImports = System.currentPageReference().getParameters().get('hasImports');
        this.leaseAgreement = System.currentPageReference().getParameters().get('leaseAgreement');
        this.commissionType = System.currentPageReference().getParameters().get('commissionType');
        if(String.isBlank(this.loanPurpose)){
            this.loanPurpose = ' ';
        }
        GST = System.currentPageReference().getParameters().get('GST');
        abn = System.currentPageReference().getParameters().get('abn');
        interestType = System.currentPageReference().getParameters().get('interestType');
        propertyOwner = System.currentPageReference().getParameters().get('propertyOwner');
        assetType = System.currentPageReference().getParameters().get('assetType');
        companyScore = System.currentPageReference().getParameters().get('companyScore');
        directorSoleTraderScore = System.currentPageReference().getParameters().get('directorSoleTraderScore');
        paidDefault = System.currentPageReference().getParameters().get('paidDefault');
        condition = System.currentPageReference().getParameters().get('condition');
        abnLength = System.currentPageReference().getParameters().get('abnLength');
        gstLength = System.currentPageReference().getParameters().get('gstLength');
        assetAge = System.currentPageReference().getParameters().get('assetAge');
        equifaxScore = System.currentPageReference().getParameters().get('equifaxScore');
    } // finish the constructor
    
    
    public Boolean getIsMacquorie() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('MACQUARIE')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsMacquorieConsumer() {
        Boolean r = false;
        if (getIsMacquorie() && lender.containsIgnoreCase('CONSUMER')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsMacquorieCommercial() {
        Boolean r = false;
        if (getIsMacquorie() && lender.containsIgnoreCase('COMMERCIAL')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsWestpac() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('WESTPAC')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsMoney3() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('MONEY3')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsAPF() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('APF')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsUMELoans() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('UME')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsSocietyOne() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('SOCIETY')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsYamahaMoto() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('YAMAHA')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsYamahaMarine() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('YAMAHA MARINE')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsMetro() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('METRO')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsLatitude() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('LATITUDE') && !getIsLatitudePersonal()) {
            r = true;
        }
        return r;
    }

    public Boolean getIsLatitudePersonal() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('LATITUDE PERSONAL')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsGeneral() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('GENERAL')) {
            r = true;
        }
        return r;
    }
 	
    public Boolean getIsANZOthers() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('ANZ OTHERS CALCULATION')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsAfsConsumer() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('AFS CONSUMER')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsAfsCommercial() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('AFS COMMERCIAL')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsPepperSummer() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('PEPPER SUMMER')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsPepperComm() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('Pepper Commercial')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsPepper() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('PEPPER') && !getIsPepperComm()) {
            r = true;
        }
        return r;
    }

    public Boolean getIsGreenLight() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('GREEN')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsWisr() {
        Boolean r = false;
        if (!String.isBlank(lender) && 
            !getIsWisrVL() &&
            lender.containsIgnoreCase('WISR')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsWisrVL() {
      Boolean r = false;
      if (String.isNotBlank(lender) && lender.containsIgnoreCase('WISR CAR LOAN')) {
          r = true;
      }
      return r;
  }
    
    public Boolean getIsMoneyPlace() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('MONEY PLACE')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsFirstmac() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('FIRSTMAC')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsNowFinance() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('NOW FINANCE')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsCarStartFinance() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('CAR START FINANCE CALCULATION')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsAzora() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('AZORA CONSUMER CALCULATION')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsRateSetterPL() {
        Boolean r = false;
        if (!String.isBlank(lender) && 
           (lender.containsIgnoreCase('RATESETTER PERSONAL') || 
            lender.containsIgnoreCase('PLENTI PERSONAL'))) {
            r = true;
        }
        return r;
    }

    public Boolean getIsRateSetter() {
        Boolean r = false;
        if (!String.isBlank(lender) && 
           (lender.containsIgnoreCase('RATESETTER') || 
            lender.containsIgnoreCase('PLENTI CALCULATION')) && 
            !getIsRateSetterPL()) {
            r = true;
        }
        return r;
    }
	
    public Boolean getIsBankOfQueensland() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('BANK OF QUEENSLAND CALCULATION')) {
            r = true;
        }
        return r;
    }

    public Boolean getIsBOQCommercial() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('BANK OF QUEENSLAND COMMERCIAL')) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsAffordableCarLoan() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('AFFORDABLE')) {
            r = true;
        }
        return r;
    }

    public String getAdditionalDetails() {
        String r = '';
        if (!String.isBlank(extraLabel1)) {
            r += extraLabel1 + '(' + extraValue1 + ')';
        }
        if (!String.isBlank(extraLabel2)) {
            if (!String.isBlank(r))
                r += ', ';
            r += extraLabel2 + '(' + extraValue2 + ')';
        }
        if (!String.isBlank(extraLabel3)) {
            if (!String.isBlank(r))
                r += ', ';
            r += extraLabel3 + '(' + extraValue3 + ')';
        }
        if (!String.isBlank(extraLabel4)) {
            if (!String.isBlank(r))
                r += ', ';
            r += extraLabel4 + '(' + extraValue4 + ')';
        }
        if (String.isBlank(r)) {
            r = 'none.';
        }
        return r;
    }
    
    public Boolean getIsFinanceOne() {
        if (!String.isBlank(lender) && lender.equalsIgnoreCase('FINANCE ONE CALCULATION')) {
            return true;
        }
        return false;
    }

    public Boolean getIsFinanceOneCommercial() {
        if (!String.isBlank(lender) && lender.equalsIgnoreCase('FINANCE ONE COMMERCIAL CALCULATION')) {
            return true;
        }
        return false;
    }

    public Boolean getIsFinanceOnePL() {
        if (!String.isBlank(lender) && lender.equalsIgnoreCase('FINANCE ONE PL CALCULATION')) {
            return true;
        }
        return false;
    }

    public Boolean getIsFinanceOneBusiness() {
        if (!String.isBlank(lender) && lender.equalsIgnoreCase('FINANCE ONE BUSINESS CALCULATION')) {
            return true;
        }
        return false;
    }

    public Boolean getIsIntegrityProd() {
      return String.isNotBlank(this.nwcLevel);
    }

    public Boolean getIsPlentiCommercial() {
        if (!String.isBlank(lender) && lender.equalsIgnoreCase('PLENTI COMMERCIAL CALCULATION')) {
            return true;
        }
        return false;
    }

    public Boolean getIsLibertyCommercial() {
      if (!String.isBlank(lender) && lender.equalsIgnoreCase('LIBERTY COMMERCIAL CALCULATION')) {
        return true;
      }
      return false;
    }

    public Boolean getIsGrowAssetCar() {
        Boolean r = false;
        if (!String.isBlank(lender) && lender.containsIgnoreCase('GROW') && !lender.equalsIgnoreCase('Grow Business Loan CALCULATION')) {
            r = true;
        }
        return r;
    }
    
  public Account getAccountVar() {
    return SOQLSingletonQueries.getPartnerAccount(this.opp.OwnerId);
  } 

  public Boolean getIsGrowBusiLoan() {
    Boolean r = false;
    if (!String.isBlank(lender) && lender.containsIgnoreCase('Grow Business Loan CALCULATION')) {
        r = true;
    }
    return r;
  }

}