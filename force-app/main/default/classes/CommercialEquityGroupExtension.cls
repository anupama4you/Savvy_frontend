public class CommercialEquityGroupExtension {
    
    public List <SelectOption> assetTypeOptions {get;set;}
    public List <SelectOption> termOptions {get;set;}
    public List <SelectOption> abnLengthOptions {get;set;}
    public List <SelectOption> gstLengthOptions {get;set;}
    public List <SelectOption> assetAgeOptions {get;set;}
    
    public String assetType {get;set;} 
    public Decimal equifaxScore {get;set;}
    public String abnLength {get;set;}
    public String gstLength {get;set;}
    public String assetAge {get;set;}   
    public Decimal payment {get;set;}
    //------------
    
    public Custom_Opportunity__c Opp;
    
    private String fileGlobalPrefix = 'Commercial_Equity_Group';
    
    public static Decimal MAX_BROKERAGE = 4.0;
  
    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal ppsr {get;set;}
    public Decimal residualValue {get;set;}
    //public Decimal brokerage {get;set;}
    public Decimal baseRate {get;set;}
    public Decimal clientRate {get;set;}
    
    public Integer term {get;set;}
    public Integer carAge {get;set;}
    public String paymentType {get;set;}
    //Lelo              2016-08-29
    public String privateSales {get;set;}
    //-
    //Lelo              2020-03-18
    public String propertyOwner {get;set;}
    public String manufactureYear {get;set;}
    public List <SelectOption> manufactureYearOptions {get;set;}    
    public Integer ltv {get;set;}
    //-
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> paymentTypes {get;set;}
    
    // finance calculator output
    public Decimal estimatedCommission {get;set;}
    public Decimal insuranceIncome {get;set;}
    public Decimal dofResult {get;set;}
    public Decimal totalCommission {get;set;}
    public Decimal totalCommissionGst {get;set;}
    
    public Decimal naf {get;set;}
    public Decimal rental {get;set;}
    public Decimal monthlyFee {get;set;}
    public Decimal monthlyPayment {get;set;}
    public Decimal fortnightlyPayment {get;set;}
    public Decimal weeklyPayment {get;set;}
    
    // insurance info
    public Decimal gap {get;set;}
    public Decimal gapIncome {get;set;}
    public Decimal warranty {get;set;}
    public Decimal warrantyIncome {get;set;}
    public Decimal lti {get;set;}
    public Decimal ltiIncome {get;set;}
    public Decimal truckGap {get;set;}
    public Decimal truckGapIncome {get;set;}
    public Decimal tai {get;set;}
    public Decimal taiIncome {get;set;}
    public Decimal mv {get;set;}
    public Decimal mvIncome {get;set;}
    public Decimal cci {get;set;}
    public Decimal cciIncome {get;set;}
    public String gapLevel {get;set;}
    public String warrantyLevel {get;set;}
    public String ltiLevel {get;set;}
    public String truckGapLevel {get;set;}
    public String taiLevel {get;set;}
    public String mvLevel {get;set;}
    //public String cciLevel {get;set;}
    public Decimal nwc {get;set;}
    public Decimal nwcIncome {get;set;}
    public Decimal totalInsurance {set; get;}
    
    public List <SelectOption> gapLevels {get;set;}
    public List <SelectOption> warrantyLevels {get;set;}
    public List <SelectOption> ltiLevels {get;set;}
    public List <SelectOption> truckGapLevels {get;set;}
    public List <SelectOption> taiLevels {get;set;}
    public List <SelectOption> mvLevels {get;set;}
    
    // Vehicle Details
    public String state {get;set;}
    public String vehicleGroup {get;set;}
    public String awd {get;set;}
    public String turbo {get;set;}
    public String diesel {get;set;}
    
    public List <SelectOption> stateOptions {get;set;}
    public List <SelectOption> vehicleGroupTypes {get;set;}
    
    // rates references
    Public List <MacquarieCommercialRates__c> macquarieRates {get;set;}
    Map <String,MacquarieCommercialRates__c> macquarieCommercialRates {get;set;}
    
    // addtional loan information
    public String productLoanType {get;set;}
    public String productGoodsType {get;set;}
    public String productGoodsSubType {get;set;}
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    public List <SelectOption> productGoodsSubTypes {get;set;}
    public List <Selectoption> loanFrequencies {set; get;}
    public String loanFrequency {set; get;}
    public String selectedTypeValue {set; get;}
    public Decimal residualValuePercentage {set; get;}
    public Boolean isResidualValuePercentage {set; get;}
    // the real time NAF
    public Decimal realtimeNaf {get;set;}
    
    // other things
    Map<String,id> RecordTypes {get;set;}
    //list <attachment> existingAttach {get;set;}
    
    
    public Decimal brokeragePercentage {get;set;}
    
    public static final String LENDER_QUOTING = 'Commercial Equity Group';
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    public Decimal netDeposit {get;set;}
    public String loanType {get;set;}                       
    public List <SelectOption> loanTypeOptions {get;set;}         
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;            
    //-
        
    //Maclease Quote
    public MacquarieManager mcManager {set; get;}
    public MacLeasePartnerService mcService;
    public Boolean isCalculateUpdate {set; get;}
    public Decimal mcqGrossPayment {set; get;}
    public Decimal mcqCustomerRate {set; get;}
    public String mcqPaymentFrequency {set; get;}
    public String mcqMessageQuote {set; get;}
    public String mcqLastResponseQuote {set; get;}
    public String mcqApplicationId {set; get;}
    public String mcqMessageAppId {set; get;}
    public String mcqLastResponseApplication {set; get;}
    
    public String mcqUser {get;set;}
    public List <SelectOption> mcqUserOptions {get;set;}
    public Boolean paramActive {set; get;}

    //Lelo                  Insurance                       2018-02-20
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String insuranceInputMode {set;get;}

    public String nwcPlan {get;set;}
    public String nwcTerm {get;set;}
    public Decimal nwcCost {get;set;}
    public String nwcAcceptance {get;set;}

    public String mvAcceptance {get;set;}
    public String gapAcceptance {get;set;}
    public String taiAcceptance {get;set;}
    public String ltiAcceptance {get;set;}
    public String warrantyAcceptance {get;set;}
    public String quoteIdSelected {get;set;}

    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    public String cciAcceptance {get;set;}
    //-
    //Yohan VillaLeal                      Insurance   12-07-2018
    public String cciLevel {get;set;}
    
    //NWC Calculator - HJ - 12-07-2018 - I
    public List <SelectOption> NWCPlanOptions {get;set;}
    public List <SelectOption> NWCTermOptions {get;set;}
    public List <SelectOption> NWCTypePOptions {get;set;}
    public String NWCMessage {set; get;}
    //public String assetType = null;
    public Boolean isAssetCar {set; get;}
    public Boolean isAssetBoat {set; get;}
    public Boolean isCategoryType {set; get;}
    public Boolean isNWCValidationOk {set; get;}
    public NWCCalc.Parameter nwcParam {set; get;}
    public Decimal priceCustomer= null;

    //NWC Warnings - I
    public Application_Asset_Detail__c aad = null;
    public Integer vehicleAgeYear = null;
    public String messageNWCWarning {set; get;}
    //NWC Warnings - F
    
    //NWC Calculator - HJ - 12-07-2018 - F
    
   	public List<String> cciLevels = new List<String> {
      'Disability', 'Disability/Unemployment'
    };

    private Lenders__c lenderSettings {set;get;}

    public CommercialEquityGroupExtension (ApexPages.StandardController controller) {
        //getRateTable();  
        
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);    
        
        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam = new NWCCalc.Parameter();
        //NWC Calculator - HJ - 12-07-2018 - F
        
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }

        //Lelo          Insurance           2017-12-04
        insuranceInputMode = 'A';
        //-
        
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);

        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        
       
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        
        this.dof = lenderSettings.DOF__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.term = 0;
        this.ltv = null;
        this.paymentType = 'Advance';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNaf = applicationFee + dof + ppsr;
        this.brokeragePercentage = 4;
        
        this.resetCalculationResult(); //Lelo       2017-07-25
        
        macquarieCommercialRates = MacquarieCommercialRates__c.getAll();
        System.debug('The map value: ' + macquarieCommercialRates);
        macquarieRates = macquarieCommercialRates.values();
        macquarieRates.sort();
        
        yesNoOptions = new List <SelectOption> ();
        yesNoOptions.add(new SelectOption ('', '--None--'));
        yesNoOptions.add(new SelectOption ('Y', 'Yes'));
        yesNoOptions.add(new SelectOption ('N', 'No'));
        
        stateOptions = new List <SelectOption> ();
        stateOptions.add(new SelectOption ('', '--None--'));
        vehicleGroupTypes = new List <SelectOption> ();
        vehicleGroupTypes.add(new SelectOption ('', '--None--'));
        gapLevels = new List <SelectOption> ();
        gapLevels.add(new SelectOption ('', '--None--'));
        warrantyLevels = new List <SelectOption> ();
        warrantyLevels.add(new SelectOption ('', '--None--'));
        ltiLevels = new List <SelectOption> ();
        ltiLevels.add(new SelectOption ('', '--None--'));
        truckGapLevels = new List <SelectOption> ();
        truckGapLevels.add(new SelectOption ('', '--None--'));
        taiLevels = new List <SelectOption> ();
        taiLevels.add(new SelectOption ('', '--None--'));
        mvLevels = new List <SelectOption> ();
        mvLevels.add(new SelectOption ('', '--None--'));
                
        //Lelo              2016-12-22
        loanTypeOptions = QuotingToolAssistant.getLoanTypeOptions(LENDER_QUOTING);
        //assetTypeOptions = QuotingToolAssistant.getassetTypeOptions(LENDER_QUOTING);
        termOptions = QuotingToolAssistant.gettermOptions(LENDER_QUOTING);
        //abnLengthOptions = QuotingToolAssistant.getabnLengthOptions(LENDER_QUOTING);
        //gstLengthOptions = QuotingToolAssistant.getgstLengthOptions(LENDER_QUOTING);
        //assetAgeOptions = QuotingToolAssistant.getassetAgeOptions(LENDER_QUOTING);
        /*propertyOwnerOptions = QuotingToolAssistant.getpropertyOwnerOptions(LENDER_QUOTING);
        privateSalesOptions = QuotingToolAssistant.getprivateSalesOptions(LENDER_QUOTING);*/
        paymentTypes = QuotingToolAssistant.getpaymentTypeOptions(LENDER_QUOTING);
        loanType = loanTypeOptions.get(0).getValue();
        productLoanTypes = QuotingToolAssistant.getloanProductOptions(LENDER_QUOTING);//QuotingToolHelper.getLoanProductOptionsCommercial();
        productLoanType = productLoanTypes.get(0).getValue();
        productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
        productGoodsType = productGoodsTypes.get(0).getValue();
        loadLoanFrequency();
        selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        resetResidualValues();
        mcService = new MacLeasePartnerService();
        mcManager = new MacquarieManager();
        //-

        preLoadQuotingValues();
        isCalculateUpdate = false;
        
        //Macquarie - HJ -I
        mcqUserOptions = MacquarieManager.getUserOptionsConnect();
        //Macquarie - HJ -F
        
        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
        
    } // end of constructor
    
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                //if (lender != null && lender.info != null && 'MCOM'.equals(lender.info.Code__c)) {
                if (lender != null && lender.info != null && 'CEG'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productLoanType = lender.productLoanType;
                    this.productGoodsType = lender.productGoodsType;
                    this.productGoodsSubType = lender.productGoodsSubType;
                    this.loanFrequency = lender.loanFrequency;
                    this.carAge = lender.carAge;
                    this.privateSales = lender.privateSales;
                    
                    this.brokeragePercentage = lender.brokerageBase;
                    this.dof = lender.dofBase;
                    //this.paymentType = 'Arrears';
                    
                    this.assetType = lender.assetType;
                    this.equifaxScore = lender.equifaxScore;
                    this.abnLength = lender.abnLength;
                    this.gstLength = lender.gstLength;
                    this.assetAge = lender.assetAge;
                    
                    applicationFeefCalc();
                    baseRateCalc();
                    
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }

    public void baseRateCalc() {

        Decimal originalRate = 0.00;
        //Lelo                              2016-08-25
        realtimeNafCalc();
        Decimal financeAmount = realtimeNaf;
        //-
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.ltv = String.valueOf(ltv);
        param.customerProfile = propertyOwner;
        param.term = term;
        param.privateSales = privateSales;
        param.totalAmount = financeAmount;
        param.goodsType = productGoodsType;
        param.vehicleYear = manufactureYear;
        param.brokeragePer = brokeragePercentage;
        param.productLoanType = productLoanType;
        param.loanType = loanType;
        param.assetType = assetType;
        param.equifaxScore = equifaxScore;
        param.abnLength = abnLength; 
        param.gstLength = gstLength;
        param.assetAge = assetAge;
        //this.baseRate = QuotingCalculation.getBaseRate(param);
       

        /*if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than ' + MAX_BROKERAGE.format() + '%'));
        }*/

        //Client Rate
        /*
        Decimal fv = 0.0;
        if (residualValue != null) {
            fv = residualValue;
        }
        Decimal amuntPmt = getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_QUOTING);
        system.debug('amuntPmt >> ' + amuntPmt);
        system.debug('ratePmt  >> ' + (baseRate/100/12));
        system.debug('term     >> ' + term);
        system.debug('fv-resid >> ' + fv);
        //Decimal pmt = FinancialUtilities.pmt((amuntPmt * -1), (baseRate/100/12), Decimal.valueOf(term), fv, false);
        if (term > 0 && baseRate > 0 && amuntPmt > 0) {
            Integer type = 0;
            if ('Advance'.equals(paymentType)) 
                type = 1;
            Decimal pmt = FinancialUtilities.pmt2((baseRate/100/12), term, (amuntPmt * -1), fv, type);
            system.debug('pmt      >> ' + pmt);
            clientRate = FinancialUtilities.rate2(term, (pmt * -1.0), financeAmount, (fv * -1), type) * 12 * 100;
            system.debug('pmt      >> ' + (pmt * -1.0));
            system.debug('clientRate      >> ' + clientRate);
        }
        //-
        System.debug('base rate >> ' + baseRate);
        */
        totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);

        param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
    	param.term = term;
    	param.baseRate = baseRate;
    	param.totalAmount = financeAmount;
        if (brokeragePercentage != null) {
            param.amountBasePmt = getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_QUOTING);
        }
        param.paymentType = paymentType;
        param.residualValue = this.residualValue;
        clientRate = QuotingCalculation.getClientRateCalculation(param);
        // system.debug('clientRate (2)  >> ' + clientRate);

    } //end of funcion

    //public Decimal getBaseAmountPmtCalc() {
    //    netDepositCalc();
    //    Decimal r = 0.0;
    //    if (carPrice != null) r += carPrice;
    //    if (applicationFee != null) r += this.getTotalInsuranceType(null);
    //    if (netDeposit != null) r -= netDeposit;
    //    return r;
    //}
    
    //public Decimal getBaseAmountPmtInclBrokerageCalc() {
    //    Decimal r = realtimeNaf;
    //    if (brokeragePercentage != null && brokeragePercentage != 0) {
    //         r += (getBaseAmountPmtCalc() * brokeragePercentage/100);
    //    }
    //    return r;
    //}
    
    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtCalc(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        r += this.getTotalInsuranceType(calcType);
        if (netDeposit != null) r -= netDeposit;
        return r;
    }
    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        Decimal r = getRealtimeNaf(calcType);
        if (brokeragePercentage != null && brokeragePercentage != 0) {
          // r += (getBaseAmountPmtCalc(calcType) * brokeragePercentage/100);
          r += (r * brokeragePercentage/100);
        }
        return r;
    }
    //-
    //private Decimal getTotalInsurante() {
    //    Decimal r = 0.0;
    //    if (nwc != null) r += nwc;
    //    if (gap != null) r += gap;
    //    if (warranty != null) r += warranty;
    //    if (lti != null) r += lti;
    //    if (truckGap != null) r += truckGap;
    //    if (tai != null) r += tai;
    //    if (mv != null) r += mv;
    //    if (cci != null) r += cci;
    //    return r;
    //}

    public void realtimeNafCalc () {
        netDepositCalc();
        realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
        totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        //realtimeNaf = 0.0;
        //totalInsurance = 0.0;
        //if (carPrice != null) {
        //    realtimeNaf += carPrice;
        //    if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
        //        residualValue = (carPrice * residualValuePercentage) / 100;
        //    }
        //}
        //if (applicationFee != null) realtimeNaf += applicationFee;
        //if (dof != null) realtimeNaf += dof;
        //if (ppsr != null) realtimeNaf += ppsr;
        //if (netDeposit != null) realtimeNaf -= netDeposit;
        //realtimeNaf += this.getTotalInsuranceType(null);
        //totalInsurance = this.getTotalInsuranceType(null);
        //System.debug('realtimeNaf|carPrice|applicationFee|dof|ppsr|netDeposit|nwc|gap|warranty|lti|truckGap|tai|mv|cci');
        //System.debug(realtimeNaf + '|' + carPrice + '|' + applicationFee + '|' + dof + '|' + ppsr + '|' + netDeposit + '|' + nwc + '|' + gap + '|' + warranty + '|' + lti + '|' + truckGap + '|' + tai + '|' + mv + '|' + cci);
		this.ericLPICalculate();
	} //end of funcion
    
    //Lelo              2017-07-26
    public Decimal getRealtimeNaf(String calcType) {
        Decimal r = 0.0;
        netDepositCalc();
        if (carPrice != null) {
          if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
              r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
          } else {
              r += carPrice;
          }
          if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE) {
            residualValue = ((carPrice - netDeposit) * residualValuePercentage) / 100;
          }
        }
        if (applicationFee != null) r += applicationFee;
        if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        if (netDeposit != null) r -= netDeposit;
        r += this.getTotalInsuranceType(calcType);

        return r;
    }

    public void applicationFeefCalc () {//NOT APPLICABLE
        /*if ('Y'.equals(privateSales) || 'Sale & Lease Back'.equals(loanType)) {
            applicationFee = lenderSettings.Application_Fee_Private__c;
        } else {
            applicationFee = lenderSettings.Application_Fee__c;
        }
        realtimeNafCalc();*/
    } 
    
    public void warrantyPriceCalc () {
        Decimal warrantyPrice = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();
        
        if (vehicleGroup == null || vehicleGroup == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a vehicle group value for accurate warranty price.'));
        } else {
            if (integer.valueOf(vehicleGroup) == 4) {
                warrantyPrice = 0;
            } else {
                if (warrantyLevel == null || warrantyLevel == '') {
            
                } else {
                    warrantyPrice = allWarrantyLevels.get(warrantyLevel).Amount__c + 44;
                    if (integer.valueOf(vehicleGroup) == 2) {
                        warrantyPrice = warrantyPrice + 110;
                    } else if (integer.valueOf(vehicleGroup) == 3) {
                        warrantyPrice = warrantyPrice + 220;
                    }
                
                    if (awd == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (turbo == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (diesel == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                } // end of if else warrantyLevel                
            } // end of if else vehicleGroup == 4
        } // end of if else vehicleGroup == null
        
        warranty = warrantyPrice.setScale(2);
        
        if (state == null || state == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a State value for accurate Stamp Duty and Insurance Income.'));
        }
    } //end of funcion
    
    public void warrantyIncomeCalc () {
        Decimal warrantyPrice = 0;
        Decimal stampDuty = 0;
        Decimal gst = 0;
        Decimal govCharge = 0;
        Decimal netPremium = 0;
        Decimal warrantyCommission = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();
        
        if (vehicleGroup == null || vehicleGroup == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a vehicle group value for accurate warranty price.'));
        } else {
            if (integer.valueOf(vehicleGroup) == 4) {
                warrantyCommission = 0;
            } else {
                if (warrantyLevel == null || warrantyLevel == '') {
            
                } else {
                    warrantyPrice = allWarrantyLevels.get(warrantyLevel).Amount__c;
                    
                    if (state == null || state == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a State value for accurate Stamp Duty and Insurance Income.'));
                        warrantyPrice = 0;
                    } else {
                        if (state == 'ACT') {
                            stampDuty = warrantyPrice * 0.02 / (1 + 0.02);
                        } else if (state == 'NSW') {
                            stampDuty = warrantyPrice * 0.05 / (1 + 0.05);
                        } else if (state == 'NT') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (state == 'QLD') {
                            stampDuty = warrantyPrice * 0.09 / (1 + 0.09);
                        } else if (state == 'SA') {
                            stampDuty = warrantyPrice * 0.11 / (1 + 0.11);
                        } else if (state == 'TAS') {
                            stampDuty = warrantyPrice * 0.08 / (1 + 0.08);
                        } else if (state == 'VIC') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (state == 'WA') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        }
                    } // end if else state == null
                } // end if else warrantyLevel == null
                
                System.debug('Stamp Duty: ' + stampDuty);
                
                gst = ((warrantyPrice - stampDuty) * 0.10) / (1 + 0.10);
                System.debug('GST: ' + gst);
                govCharge = stampDuty + gst;
                System.debug('Government Charge: ' + govCharge);
                netPremium = warrantyPrice - govCharge;
                System.debug('Net Premium: ' + netPremium);
                
                warrantyCommission = netPremium * 0.5293;
                System.debug('The Commission: ' + warrantyCommission);
            } // end if else vehicleGroup == 4
        } // end of if else vehicleGroup == null
        
        warrantyCommission = warrantyCommission * 1.1;
        warrantyIncome = warrantyCommission.setScale(2);
    } //end of function
    
    public void validate () {
        isValidCalculate();
    } //end of function
    
    private Boolean isValidInsuranceInfo(Decimal price, Decimal commission) {
        return isValidInsuranceInfo('IGNORE', price, commission);
    }

    private Boolean isValidInsuranceInfo(String level, Decimal price, Decimal commission) {
        return isValidInsuranceInfo(level, price, commission, false);   
    }

    private Boolean isValidInsuranceInfo(String level, Decimal price, Decimal commission, boolean ignorePrice) {
        Boolean r = true;
        if ('IGNORE'.equals(level)) {
            if (commission > 0 && (price == 0 || price == null)) {
                r = false;
            }
        } else {
            if (!String.isBlank(level)) { 
                if((price == 0 || price == null) && (commission == 0 || commission == null)) {
                    r = false;
                } else if(price == 0 || price == null) {
                    if(!ignorePrice) r = false;
                }
            }
            if (price > 0 && String.isBlank(level)) {
                r = false;   
            }
            if (commission > 0 && String.isBlank(level)) {
                r = false;   
            }
        }
        return r;
    }

    private Boolean isInsuranceValidationOK() {
        Boolean r = true;

        // Gap Insurance
        if (!isValidInsuranceInfo(gapLevel, gap, gapIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Gap insurance product.'));
            r = false;
        }
        // Warranty Insurance
        if (!isValidInsuranceInfo(warrantyLevel, warranty, warrantyIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Warranty insurance product.'));
            r = false;
        }
        // LTI Insurance
        if (!isValidInsuranceInfo(ltiLevel, lti, ltiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for LTI insurance product.'));
            r = false;
        }
        // Truck Gap Insurance
        if (!isValidInsuranceInfo(truckGapLevel, truckGap, truckGapIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Truck Gap insurance product.'));
            r = false;
        }
        // TAI/RTI Insurance
        if (!isValidInsuranceInfo(taiLevel, tai, taiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for TAI/RTI insurance product.'));
            r = false;
        }
        // MV Insurance
        if (!isValidInsuranceInfo(mvLevel, mv, mvIncome, true)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for MV insurance product.'));
            r = false;
        }
        // CCI Insurance
        if (!isValidInsuranceInfo(cci, cciIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for CCI insurance product.'));
            r = false;
        }
        // NWC Warranty Insurance
        if (!isValidInsuranceInfo(nwc, nwcIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for NWC Warranty insurance product.'));
            r = false;
        }
        //NWC Calculator - HJ - 06-08-2018 - I
        if (!isNWCValidationOk){
            r = false;
        }
        //NWC Calculator - HJ - 06-08-2018 - F

        return r;
    }

    public Boolean isValidCalculate () {
        Boolean r = true;
		this.ericLPICalculate();
        if(productLoanType == 'Low Doc' && realtimeNaf > 100000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max $100K NAF for low doc.'));
        }
        Decimal deposit20Per = carPrice * 0.20;
        if(propertyOwner == 'N' && deposit20Per > deposit){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Non property may require 20% deposit'));
        }
        if(realtimeNaf < 20000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Min NAF $20K.'));
        }
        /*if (clientRate > 14.75) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be larger than 14.75%.'));
            r = false;
        }
        if (term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term cannot be longer than five years.'));
            r = false;
        }
        if (realtimeNaf < 10000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Financed Amount cannot be less than $10,000.'));
            r = false;
        }*/
        // validation before calculation
        /*if (clientRate == null || clientRate <= 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }*/
        if (baseRate == null || baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        /*if (String.isBlank(manufactureYear)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an Asset Year option.'));
            r = false;
        }
        if (String.isBlank(privateSales)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a Private Sale option.'));
            r = false;
        }*/
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        /*if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than ' + MAX_BROKERAGE.format() + '%'));
            r = false;
        }
        if(equifaxScore == null || equifaxScore < 600){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Minimum 600 guarantor credit score - check with lender'));
            r = false;
        }
        if(abnLength == '< 2 years'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ABN must be registered for 2 years'));
            r = false;
        }       
        if(gstLength != '< 2 years' && gstLength != '> 2 years'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Must be GST registered'));
            r = false;
        }
        if(brokeragePercentage > 8 && realtimeNaf <= 25000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot exceed 8% '));
            r = false;
        }else if(brokeragePercentage > 7 && realtimeNaf <= 75000 && realtimeNaf >= 25000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot exceed 7% '));
            r = false;
        }else if(brokeragePercentage > 6 && realtimeNaf <= 150000 && realtimeNaf >= 75000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot exceed 6% '));
            r = false;
        }else if(brokeragePercentage > 5 && realtimeNaf <= 250000 && realtimeNaf >= 150000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot exceed 5% '));
            r = false;
        }else if(brokeragePercentage > 4 && (realtimeNaf >= 250000)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot exceed 4% '));
            r = false;
        }*/
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }
    
    public PageReference calculate () {
        baseRateCalc();     
        system.debug('baseRate value: '+baseRate);
        if (!isValidCalculate()) {
            return null;
        }
        this.calculateRepayments(); 
        if (estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
        
        isCalculateUpdate = true;
        return null;
    } // end of function
    
    public PageReference reset () {
        this.privateSales = '';
        this.brokeragePercentage = 4;
        //this.assetType = assetTypeOptions.get(0).getValue();
        this.equifaxScore = 0;
        //this.abnLength = abnLengthOptions.get(0).getValue();
        //this.gstLength = gstLengthOptions.get(0).getValue();
        //this.assetAge = assetAgeOptions.get(0).getValue();
        this.loanType = 'Purchase';
        this.productLoanType = 'Low Doc';
        this.carPrice = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        //this.applicationFee = 350.00;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.residualValue = 0.00;
        this.residualValuePercentage = 0.00;
        this.selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.term = 0;
        this.propertyOwner = 'N';
        this.ltv = null;
        //this.brokeragePercentage = 6;
        // this.carAge = 0;
        //this.motorCycles = 'N';
        //this.caravanCampervans = 'N';
        this.paymentType = 'Advance';
        this.estimatedCommission = 0.00;
        this.insuranceIncome = 0.00;
        this.dofResult = 0.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.monthlyPayment = 0.00;
        this.fortnightlyPayment = 0.00;
        this.weeklyPayment = 0.00;
        
        //Insurance Products
        this.mvLevel = null;
        this.mv = 0.00;
        this.mvIncome = 0.00;
        this.mvAcceptance = 'U';

        this.gapLevel = null;
        this.gap = 0.00;
        this.gapIncome = 0.00;
        this.gapAcceptance = 'U';

        this.taiLevel = null;
        this.tai = 0.00;
        this.taiIncome = 0.00;
        this.taiAcceptance = 'U';

        this.ltiLevel = null;
        this.lti = 0.00;
        this.ltiIncome = 0.00;
        this.ltiAcceptance = 'U';

        this.warrantyLevel = null;
        this.warranty = 0.00;
        this.warrantyIncome = 0.00;
        this.warrantyAcceptance = 'U';

        this.nwc = 0.00;
        this.nwcIncome = 0.00;
        this.nwcAcceptance = 'U';
        this.nwcPlan = null;
        this.nwcTerm = null;
        this.nwcCost = null;
        
        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam.awd4wd = null;
        nwcParam.luxuryCar = null;
        nwcParam.type_p = null;
        nwcParam.isManuallyNWCPrice = false;
		//NWC Calculator - HJ - 12-07-2018 - F

        //Lelo                  Insurance           2018-02-26
        this.cci = 0.00;
        this.cciIncome = 0.00;
        this.cciAcceptance = 'U';

        this.quoteIdSelected = null;
        this.quote = new Application_InsuranceQuote__c();
        //- 

        this.state = '';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.productGoodsType = '';
        this.productGoodsSubType = '';
        this.loanFrequency = '';

        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNaf = applicationFee + dof + ppsr;
        isCalculateUpdate = false;

        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    } // end of function
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id',Opp.Id);
        calcPdf.getParameters().put('lender', 'COMMERCIAL EQUITY GROUP CALCULATION');
        calcPdf.getParameters().put('state', state);
        calcPdf.getParameters().put('vehicleGroup', vehicleGroup);
        calcPdf.getParameters().put('awd', awd);
        calcPdf.getParameters().put('turbo', turbo);
        calcPdf.getParameters().put('diesel', diesel);

        //Lelo          Insurance               2017-12-02
        if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('mvLevel', mvLevel);
            calcPdf.getParameters().put('mv', String.valueOf(mv));
            calcPdf.getParameters().put('mvIncome', String.valueOf(mvIncome));
        } else {
            calcPdf.getParameters().put('mvLevel', null);
            calcPdf.getParameters().put('mv', String.valueOf(0.00));
            calcPdf.getParameters().put('mvIncome', String.valueOf(0.00));
        }
        if ('A'.equals(gapAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('gapLevel', gapLevel);
            calcPdf.getParameters().put('gap', String.valueOf(gap));
            calcPdf.getParameters().put('gapIncome', String.valueOf(gapIncome));
        } else {
            calcPdf.getParameters().put('gapLevel', null);
            calcPdf.getParameters().put('gap', String.valueOf(0.00));
            calcPdf.getParameters().put('gapIncome', String.valueOf(0.00));
        }
        if ('A'.equals(taiAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('taiLevel', taiLevel);
            calcPdf.getParameters().put('tai', String.valueOf(tai));
            calcPdf.getParameters().put('taiIncome', String.valueOf(taiIncome));
        } else {
            calcPdf.getParameters().put('taiLevel', null);
            calcPdf.getParameters().put('tai', String.valueOf(0.00));
            calcPdf.getParameters().put('taiIncome', String.valueOf(0.00));
        }
        if ('A'.equals(ltiAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('ltiLevel', ltiLevel);
            calcPdf.getParameters().put('lti', String.valueOf(lti));
            calcPdf.getParameters().put('ltiIncome', String.valueOf(ltiIncome));
        } else {
            calcPdf.getParameters().put('ltiLevel', null);
            calcPdf.getParameters().put('lti', String.valueOf(0.00));
            calcPdf.getParameters().put('ltiIncome', String.valueOf(0.00));
        }
        if ('A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('warrantyLevel', warrantyLevel);
            calcPdf.getParameters().put('warranty', String.valueOf(warranty));
            calcPdf.getParameters().put('warrantyIncome', String.valueOf(warrantyIncome));
        } else {
            calcPdf.getParameters().put('warrantyLevel', null);
            calcPdf.getParameters().put('warranty', String.valueOf(0.00));
            calcPdf.getParameters().put('warrantyIncome', String.valueOf(0.00));
        }
        //Manual Insurances
        if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('nwc', String.valueOf(nwc));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(nwcIncome));
            
            //NWC Calculator - HJ - 31-08-2018 - I
            String nwcAwd4wd = '';
            String nwcLuxuryCar = '';
            if (isAssetCar){
                nwcAwd4wd = nwcParam.awd4wd;
                nwcLuxuryCar = nwcParam.luxuryCar;
            }
            String nwcEngine = '';
            String nwcType_p = nwcParam.type_p;
            if ('NWC'.equalsIgnoreCase(nwcType_p)){
                nwcType_p = '';
            }
            if (isAssetBoat){
                nwcEngine = nwcParam.type_p;
                nwcType_p = '';
            } 
            String nwcIsManuallyNWCPrice = 'N';
            if (nwcParam.isManuallyNWCPrice){
                nwcIsManuallyNWCPrice = 'Y';
            }
            calcPdf.getParameters().put('nwcAwd4wd', nwcAwd4wd);
            calcPdf.getParameters().put('nwcLuxuryCar', nwcLuxuryCar);
            calcPdf.getParameters().put('nwcType_p', nwcType_p);
            calcPdf.getParameters().put('nwcEngine', nwcEngine);
            calcPdf.getParameters().put('nwcIsManuallyNWCPrice', nwcIsManuallyNWCPrice);
            calcPdf.getParameters().put('nwcTerm', nwcTerm);
            calcPdf.getParameters().put('nwcAssetType', nwcParam.assetType);
            calcPdf.getParameters().put('nwcState', nwcParam.state);
            calcPdf.getParameters().put('nwcPlan', nwcPlan);
            //NWC Calculator - HJ - 31-08-2018 - F
            
        } else {
            calcPdf.getParameters().put('nwc', String.valueOf(0.00));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(0.00));
        }
        // Lelo         Insurance       2018-02-26
        if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('cciLevel', cciLevel);
            calcPdf.getParameters().put('cci', String.valueOf(cci));
            calcPdf.getParameters().put('cciIncome', String.valueOf(cciIncome));
        } else {
            calcPdf.getParameters().put('cciLevel', null);
            calcPdf.getParameters().put('cci', String.valueOf(0.00));
            calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        }
        //-
        
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        calcPdf.getParameters().put('applicationFee', String.valueOf(applicationFee));
        calcPdf.getParameters().put('dof', String.valueOf(dof));
        calcPdf.getParameters().put('ppsr', String.valueOf(ppsr));
        calcPdf.getParameters().put('selectedTypeValue', selectedTypeValue);
        calcPdf.getParameters().put('residualValuePercentage', String.valueOf(residualValuePercentage));
        calcPdf.getParameters().put('residualValue', String.valueOf(residualValue));
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(brokeragePercentage));
        calcPdf.getParameters().put('baseRate', String.valueOf(baseRate));
        calcPdf.getParameters().put('clientRate', String.valueOf(clientRate.setScale(2)));
        calcPdf.getParameters().put('term', String.valueOf(term));
        calcPdf.getParameters().put('paymentType', paymentType);
        calcPdf.getParameters().put('estimatedCommission', String.valueOf(estimatedCommission));
        calcPdf.getParameters().put('insuranceIncome', String.valueOf(insuranceIncome));
        calcPdf.getParameters().put('dofResult', String.valueOf(dofResult));
        calcPdf.getParameters().put('totalCommission', String.valueOf(totalCommission));
        calcPdf.getParameters().put('totalCommissionGst', String.valueOf(totalCommissionGst));
        calcPdf.getParameters().put('naf', String.valueOf(naf));
        calcPdf.getParameters().put('rental', String.valueOf(rental));
        calcPdf.getParameters().put('monthlyFee', String.valueOf(monthlyFee));
        calcPdf.getParameters().put('monthlyPayment', String.valueOf(monthlyPayment));
        calcPdf.getParameters().put('fortnightlyPayment', String.valueOf(fortnightlyPayment));
        calcPdf.getParameters().put('weeklyPayment', String.valueOf(weeklyPayment));
        // pass varaibles for Macquarie Commercial
        // calcPdf.getParameters().put('carAge', String.valueOf(carAge));
        calcPdf.getParameters().put('privateSales', privateSales);
        //calcPdf.getParameters().put('motorCycles', motorCycles);
        //calcPdf.getParameters().put('caravanCampervans', caravanCampervans);
        // pass variables about the product info
        if (ltv != null) {
            calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        }
        calcPdf.getParameters().put('customerProfile', propertyOwner);
        calcPdf.getParameters().put('carAge', manufactureYear);

        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('productGoodsSubType', productGoodsSubType);
        calcPdf.getParameters().put('loanFrequency', loanFrequency);
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        calcPdf.getParameters().put('loanType', loanType);
        calcPdf.getParameters().put('productLoanType', productLoanType);
        
        if (deposit != null) {
            calcPdf.getParameters().put('deposit', String.valueOf(deposit));
        }
        if (tradeIn != null) {
            calcPdf.getParameters().put('tradeIn', String.valueOf(tradeIn));
        }
        if (payoutOn != null) {
            calcPdf.getParameters().put('payoutOn', String.valueOf(payoutOn));
        }
        calcPdf.getParameters().put('netDeposit', String.valueOf(netDeposit));


        Boolean isSaveInCloud = false;
        if (prefixName.contains('APPROVAL')) {
            isSaveInCloud = true;
            String typeData = 'Quoting Calculation';
            if (prefixName.contains('AMENDMENT')) {
               typeData = 'Quoting Calculation (Amendment)';
            } else if (prefixName.contains('FORMAL_APPROVAL')) {
               typeData = 'Quoting Calculation (Formal Approval)';
            }
            ApplicationExtraDataHelper.upsertData(
                    Opp.Application__c, typeData, typeData, 
                    QuotingToolHelper.getApplicationQuoting(Opp.Application__c));
        }
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, calcPdf, isSaveInCloud);
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation saved successfully.'));
        return null;
    } // end of function
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidCalculate()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending for approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        if (this.Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create or assoiciate an Application Forma before saving for any approval process.'));
            return null;   
        }

        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Lelo          Insurance           2018-02-20
        //Storing quoting data
        saveQuotingParameters();
        //-
        
        //Lelo                                  2016-07-26
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
            
        updateProduct.Loan_Purpose__c = 'Business Use';
        updateProduct.Lender__c = LENDER_QUOTING;
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        //updateProduct.Loan_Type_Detail__c = loanTypeDetail;


        //if (productLoanType == null || productLoanType == '') {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan Type is not updated as the calculator does not contain relevant info.'));
        //} else {
        //    updateProduct.Loan_Type__c = productLoanType;
        //}
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Term is not updated as the calculator does not contain relevant info.'));
            updateProduct.Loan_Term__c = 0;
        } else {
            updateProduct.Loan_Term__c = term;
        }
        if (residualValue == null || residualValue == 0) {
            updateProduct.Balloon_Residual_Requested__c = 0;
        } else {
            updateProduct.Balloon_Residual_Requested__c = residualValue;
        }
        if (clientRate == null || clientRate == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client Rate is not updated as the calculator does not contain relevant info.'));
            updateProduct.Client_Rate__c = 0;
        } else {
            updateProduct.Client_Rate__c = clientRate;
        }
        if (monthlyPayment == null || monthlyPayment == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Payment is not updated as the calculator does not contain relevant info.'));
            updateProduct.Payments__c = 0;
        } else {
            updateProduct.Payments__c = monthlyPayment;
        }
        if (carPrice == null || carPrice == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Cost of Goods is not updated as the calculator does not contain relevant info.'));
            updateProduct.Cost_of_Goods__c = 0;
        } else {
            updateProduct.Cost_of_Goods__c = carPrice;
        }
        if (netDeposit == null) {
            updateProduct.Deposit__c = 0;
        } else {
            updateProduct.Deposit__c = netDeposit;
        }
        if (dof == null || dof == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF is not updated as the calculator does not contain relevant info.'));
            updateProduct.DOF__c = 0;
        } else {
            updateProduct.DOF__c = dof;
        }
        if (estimatedCommission == null || estimatedCommission == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission is not updated as the calculator does not contain relevant info.'));
            updateProduct.Brokerage__c = 0.00;
        } else {
            updateProduct.Brokerage__c = estimatedCommission;
        }
        if (applicationFee == null || applicationFee == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee is not updated as the calculator does not contain relevant info.'));
            updateProduct.Lender_App_Fee__c = 0;
        } else {
            updateProduct.Lender_App_Fee__c = applicationFee;
        }
        if (ppsr == null || ppsr == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
            updateProduct.Equalisation_Fee_PPSR__c = 0;
        } else {
            updateProduct.Equalisation_Fee_PPSR__c = ppsr;
        }
        
        //Lelo                      2018-02-20
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        //-
        
        // then create the insurance products
        // Gap Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(gapAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(gapLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Gap Insurance';
            if (gap == null || gap == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = gap;
            }
            if (gapIncome == null || gapIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = gapIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // Warranty Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(warrantyAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(warrantyLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Warranty';
            if (warranty == null || warranty == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = warranty;
            }
            if (warrantyIncome == null || warrantyIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = warrantyIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // LTI Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(ltiAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(ltiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'LTI';
            if (lti == null || lti == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = lti;
            }
            if (ltiIncome == null || ltiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = ltiIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // TAI/RTI Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(taiAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(taiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Type and Rim Insurance';
            if (tai == null || tai == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = tai;
            }
            if (taiIncome == null || taiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = taiIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // MV Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(mvAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(mvLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Full Comprehensive';
            if (mv == null || mv == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV Price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = mv;
            }
            if (mvIncome == null || mvIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = mvIncome;
            }
            newInsurance.Insurer__c = mvLevel;
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        //Lelo      Insurnce        2018-02-26
        // CCI Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(cciAcceptance)) || 
            ('M'.equals(insuranceInputMode) && (cci != null && cci > 0))) {    
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'CCI';
            newInsurance.Insurance_Policy_Amount__c = cci;
            if (cciIncome == null || cciIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'CCI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = cciIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // NWC Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(nwcAcceptance)) || 
            ('M'.equals(insuranceInputMode) && (nwc != null && nwc > 0))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Warranty';
            newInsurance.Insurance_Policy_Amount__c = nwc;
            if (nwcIncome == null || nwcIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'NWC Warranty Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = nwcIncome;
            }
            newInsurance.Insurer__c = 'NWC';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        
        //Lelo                              2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    //Lelo                                  2016-07-26
    public PageReference saveQuoting() {
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            this.saveQuotingParameters();
            this.savePdf(fileGlobalPrefix);
        }
        return null;
    }
    
    public PageReference savePreApproval() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        // if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
        //     if (insuranceProductSelected()) {
                // this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
        //     }
        // }
        // return null;
    }
    //-
    
    //Lelo                                  2016-12-22
    public void netDepositCalc() {
        netDeposit = 0;
        if (deposit != null) netDeposit += deposit;
        if (tradeIn != null) netDeposit += tradeIn;
        if (payoutOn != null) netDeposit -= payoutOn;
    }

    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = d;
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');
            
            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }

            if (String.isBlank(d.Insurance_Input_Mode__c)) {
                insuranceInputMode = 'M';
            } else {
                insuranceInputMode = d.Insurance_Input_Mode__c;
            }
            //--
            if (sameQuoting) {
                this.quoteIdSelected = d.App_Insurance_Quote__c;
                this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoteIdSelected);
                //Lelo              Insurance           2017-12-04
                if (this.quote != null) {
                    if (!LENDER_QUOTING.equals(this.quote.Financier_Name__c)) {
                        this.quoteIdSelected = null;
                        d.App_Insurance_Quote__c = null;
                        this.quote = null;
                    }
                }
                //Vehicle Details
                state = d.Vehicle_Detail_State__c;
                vehicleGroup = d.Vehicle_Detail_Group__c;
                awd = d.Vehicle_Detail_AWD__c;
                turbo = d.Vehicle_Detail_Turbo__c;
                diesel = d.Vehicle_Detail_Diesel__c;
                
                //Lelo          Insurance               2017-12-04
                //Insurance Product
                mvLevel = d.Insurance_MV_Type__c;
                mv = d.Insurance_MV_Retail_Price__c;
                mvIncome = d.Insurance_MV_Income__c;
                mvAcceptance = d.Insurance_MV_Acceptance__c;
                if (String.isBlank(mvAcceptance)) {
                    mvAcceptance = 'U';
                }

                gapLevel = d.Insurance_GAP_Type__c;
                gap = d.Insurance_GAP_Retail_Price__c;
                gapIncome = d.Insurance_GAP_Income__c;
                gapAcceptance = d.Insurance_GAP_Acceptance__c;
                if (String.isBlank(gapAcceptance)) {
                    gapAcceptance = 'U';
                }

                taiLevel = d.Insurance_TAI_Type__c;
                tai = d.Insurance_TAI_Retail_Price__c;
                taiIncome = d.Insurance_TAI_Income__c;
                taiAcceptance = d.Insurance_TAI_Acceptance__c;
                if (String.isBlank(taiAcceptance)) {
                    taiAcceptance = 'U';
                }
                
                ltiLevel = d.Insurance_LTI_Type__c;
                lti = d.Insurance_LTI_Retail_Price__c;
                ltiIncome = d.Insurance_LTI_Income__c;
                ltiAcceptance = d.Insurance_LTI_Acceptance__c;
                /*if (String.isBlank(ltiAcceptance)) {
                    ltiAcceptance = 'U';
                }*/

                warrantyLevel  = d.Insurance_Warranty_Type__c;
                warranty = d.Insurance_Warranty_Retail_Price__c;
                warrantyIncome = d.Insurance_Warranty_Income__c;
                warrantyAcceptance = d.Insurance_Warranty_Acceptance__c;
                if (String.isBlank(warrantyAcceptance)) {
                    warrantyAcceptance = 'U';
                }

                nwc = d.Insurance_NWC_Retail_Price__c;
                nwcIncome = d.Insurance_NWC_Income__c;
                nwcPlan = d.Insurance_NWC_Plan__c;
                nwcTerm = d.Insurance_NWC_Term__c;
                nwcCost = d.Insurance_NWC_Cost__c;
                nwcAcceptance = d.Insurance_NWC_Acceptance__c;
                
                //NWC Calculator - HJ - 12-07-2018 - I
                nwcParam.awd4wd = d.Insurance_NWC_AWD4WD__c;
        		nwcParam.luxuryCar = d.Insurance_NWC_LuxuryCar__c;
        		nwcParam.type_p = d.Insurance_NWC_TypeP__c;
                nwcParam.isManuallyNWCPrice = d.Insurance_NWC_Is_Manually_Value__c;
                nwcParam.nwcPriceToCustomer = nwc;
                //NWC Calculator - HJ - 12-07-2018 - F
                
                if (String.isBlank(nwcAcceptance)) {
                    nwcAcceptance = 'U';
                }

                // Lelo             Insurance           2018-02-26
                cciLevel = d.Insurance_AIC_Type__c;
				cci = d.Insurance_AIC_Retail_Price__c;
                cciIncome = d.Insurance_AIC_Income__c;
                cciAcceptance = d.Insurance_AIC_Acceptance__c;
                /*if (String.isBlank(cciAcceptance)) {
                    cciAcceptance = 'U';
                }*/                
                //-
                
                
                //-
            }

            cci = d.Insurance_AIC_Retail_Price__c;
            cciIncome = d.Insurance_AIC_Income__c;
            
            //Finance Details
            //Commons values
            loanType = d.Loan_Type__c;
            productLoanType = d.Loan_Product__c;
            carPrice = d.Vehicle_Price__c;
            deposit = d.Deposit__c;
            tradeIn = d.Trade_In__c;
            payoutOn = d.Payout_On__c;
            netDepositCalc();
            residualValue = d.Residual_Value__c;
            residualValuePercentage = d.Residual_Value_Percentage__c;
            
            if (d.Residual_Value_Percentage__c != null && d.Residual_Value_Percentage__c != 0){
                selectedTypeValue = MacquarieConstants.TYPE_PERCENTAGE;
            }else{
                selectedTypeValue = MacquarieConstants.TYPE_VALUE;
            }
            
            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            /*NOT APPLICABLE if (LENDER_QUOTING.equals(d.Name) || 
                MacquarieConsumerExtension.LENDER_QUOTING.equals(d.Name)) {
                productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
                productGoodsType = d.Goods_type__c;
                productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(productLoanType, productGoodsType);
                productGoodsSubType = d.Goods_sub_type__c;  
                
                if (String.isNotBlank(productLoanType)) {
                    loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
                }
                loanFrequency = d.Loan_Frequency__c;
                brokeragePercentage = d.Brokerage__c;
                privateSales = d.Private_Sales__c;
                paymentType = d.Payment__c;
                
            }*/
            if (sameQuoting) {
                                
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;    
                monthlyFee = d.Monthly_Fee__c;
                payment = d.Extra_Value_1__c;
                brokeragePercentage = d.Brokerage__c;
                baseRate = d.Base_Rate__c > 0 ? d.Base_Rate__c.setScale(2) : d.Base_Rate__c;
                // this.assetYearOption();
                
                propertyOwner = d.Customer_Profile__c;

                //Calculations
                applicationFeefCalc();
                baseRateCalc();

                //Load Calculations
                estimatedCommission = d.Commission_Estimation__c;
                insuranceIncome = d.Commission_Insurance_Income__c;
                dofResult = d.Commission_DOF__c;
                totalCommission = d.Commission_Total_GST_Exc__c;
                totalCommissionGst = d.Commission_Total_GST_Inc__c;

                rental = d.Rental__c;
                naf = d.NAF__c;
                monthlyPayment = d.Repayment_Monthly__c;
                fortnightlyPayment = d.Repayment_Fortnightly__c;
                weeklyPayment = d.Repayment_Weekly__c;

                //Load calculations
                this.ericLPICalculate();
				this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

                //Lelo              Insurance               2017-12-04
                //Insurance Quote Product loading
                if ('M'.equals(insuranceInputMode) && d.App_Insurance_Quote__c != null) {
                    //this.adjustInsuranceProduct();
                    insuranceInputMode = 'A';
                    System.debug('cleaning 1...');
                }
                //-
            }
            realtimeNafCalc();
            mcqGrossPayment = d.Mcq_Gross_Payment__c;
            mcqCustomerRate = d.Mcq_Customer_Rate__c;
            mcqPaymentFrequency = d.Mcq_Payment_Frequency__c;
            mcqMessageQuote = d.Mcq_Message_Quote__c;
            mcqLastResponseQuote = d.Mcq_Last_Response_Quote__c;
            mcqApplicationId = d.Mcq_Application_Id__c;
            mcqMessageAppId = d.Mcq_Message_Application_Id__c;
            mcqLastResponseApplication = d.Mcq_Last_Response_Application__c;
                       
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        }
        //Lelo              Insurance           2017-12-04
        if (this.quote == null) {
            this.quote = new Application_InsuranceQuote__c();
        }
        //-
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);

        //NWC Warning - I
        if (nwcParam != null && nwcParam.vehicleAgeYears != null && nwcParam.vehicleAgeYears > 20){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No car more than 20 years old can be covered. VechileYear: ' + nwcParam.vehicleAgeYears));
            return;
        }
        //NWC Warning - F

        Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
            d = this.quoting; 
        }
        //Associate Application / Opportunity
        d.Application__c = this.Opp.Application__c;
        d.Opportunity__c = this.Opp.Id;
        //Lender
        d.Name = LENDER_QUOTING;
        //Vehicle Details
        d.Vehicle_Detail_State__c = state;
        d.Vehicle_Detail_Group__c = vehicleGroup;
        d.Vehicle_Detail_AWD__c = awd;
        d.Vehicle_Detail_Turbo__c = turbo;
        d.Vehicle_Detail_Diesel__c = diesel;
        //Lelo              Insurance           2017-12-04
        //Insurance product
        d.Insurance_MV_Type__c = mvLevel;
        d.Insurance_MV_Retail_Price__c = mv;
        d.Insurance_MV_Income__c = mvIncome;
        d.Insurance_MV_Acceptance__c = mvAcceptance;

        d.Insurance_GAP_Type__c = gapLevel;
        d.Insurance_GAP_Retail_Price__c = gap;
        d.Insurance_GAP_Income__c = gapIncome;
        d.Insurance_GAP_Acceptance__c = gapAcceptance;
        
        d.Insurance_TAI_Type__c = taiLevel;
        d.Insurance_TAI_Retail_Price__c = tai;
        d.Insurance_TAI_Income__c = taiIncome;
        d.Insurance_TAI_Acceptance__c = taiAcceptance;

        d.Insurance_LTI_Type__c = ltiLevel;
        d.Insurance_LTI_Retail_Price__c = lti;
        d.Insurance_LTI_Income__c = ltiIncome;
        d.Insurance_LTI_Acceptance__c = ltiAcceptance;
        
        d.Insurance_Warranty_Type__c = warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = warranty;
        d.Insurance_Warranty_Income__c = warrantyIncome;
        d.Insurance_Warranty_Acceptance__c = warrantyAcceptance;

        d.Insurance_NWC_Retail_Price__c = nwc;
        d.Insurance_NWC_Income__c = nwcIncome;
        d.Insurance_NWC_Plan__c = nwcPlan;
        d.Insurance_NWC_Term__c = nwcTerm;
        d.Insurance_NWC_Cost__c = nwcCost;
        d.Insurance_NWC_Acceptance__c = nwcAcceptance;
        
        //NWC Calculator - HJ - 12-07-2018 - I
        d.Insurance_NWC_AWD4WD__c = nwcParam.awd4wd;
        d.Insurance_NWC_LuxuryCar__c = nwcParam.luxuryCar;
        d.Insurance_NWC_TypeP__c = nwcParam.type_p;
        d.Insurance_NWC_Is_Manually_Value__c = nwcParam.isManuallyNWCPrice;
        //NWC Calculator - HJ - 12-07-2018 - F
        
        //-
        d.Insurance_Truck_GAP_Type__c = truckGapLevel;
        d.Insurance_Truck_GAP_Retail_Price__c = truckGap;
        d.Insurance_Truck_GAP_Income__c = truckGapIncome;

        // Lelo             Insurance           2018-02-26
        d.Insurance_AIC_Type__c = cciLevel;
		d.Insurance_AIC_Retail_Price__c = cci;
        d.Insurance_AIC_Income__c = cciIncome;
        d.Insurance_AIC_Acceptance__c = cciAcceptance;
        //-
        
        //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Goods_type__c = productGoodsType;
        d.Goods_sub_type__c = productGoodsSubType;
        d.Loan_Frequency__c = loanFrequency;
        d.Vehicle_Price__c = carPrice;
        d.Deposit__c = deposit;
        d.Trade_In__c = tradeIn;
        d.Payout_On__c = payoutOn;
        
        d.Application_Fee__c = applicationFee;
        d.DOF__c = dof;
        d.PPSR__c = ppsr;
        d.Residual_Value__c = residualValue;
        d.Residual_Value_Percentage__c = null;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
            d.Residual_Value_Percentage__c = residualValuePercentage;
        }
        
        d.Brokerage__c = brokeragePercentage;
        d.Base_Rate__c = baseRate;
        d.Client_Rate__c = clientRate;

        d.Monthly_Fee__c = monthlyFee;

        //Loan Details
        if (term != null) {
            d.Term__c = Decimal.valueOf(term);
        }
        d.Payment__c = paymentType;
        d.Private_Sales__c = privateSales;
        
        d.Customer_Profile__c = propertyOwner;

        
        //Data calculated - Commission
        d.Commission_Estimation__c = estimatedCommission;
        d.Commission_Insurance_Income__c = insuranceIncome;
        d.Commission_DOF__c = dofResult;
        d.Commission_Total_GST_Exc__c = totalCommission;
        //Data calculated - Repayment
        d.Rental__c = rental;
        d.Repayment_Monthly__c = monthlyPayment;
        d.Repayment_Fortnightly__c = fortnightlyPayment;
        d.Repayment_Weekly__c = weeklyPayment;
        d.NAF__c = naf;
        d.Extra_Value_1__c = payment;
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

        //Lelo                  Insurance               2017-12-04
        if (this.quoting == null) {
            this.quoting = d;
        }
        //--

        //save Insurance quote
        if (this.quote != null && this.quote.Id != null) {
            update this.quote;
        }
    }
    //-      
    
    public void changeLoanProduct(){
        productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
        productGoodsType = productGoodsTypes.get(0).getValue();
        changeGoodsType();
        loadLoanFrequency();
    }
    
    public void changeGoodsType(){
        productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(productLoanType, productGoodsType);
        productGoodsSubType = productGoodsTypes.get(0).getValue();
        // this.assetYearOption();
        this.baseRateCalc();
    }
    
    public void loadLoanFrequency(){
        loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
        loanFrequency = loanFrequencies.get(0).getValue();
    }
    
    public void resetResidualValues(){
        residualValue = 0.0;
        residualValuePercentage = 0.0;
        isResidualValuePercentage = false;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
            isResidualValuePercentage = true;
        }
    }
    
    public List <SelectOption> getOptions(){
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption (MacquarieConstants.TYPE_PERCENTAGE, MacquarieConstants.TYPE_PERCENTAGE));
        r.add(new SelectOption (MacquarieConstants.TYPE_VALUE, MacquarieConstants.TYPE_VALUE));
        return r;
    }
    
    /*private void saveMacquarieAPIInformation() {
        this.quoting.Mcq_Gross_Payment__c = mcqGrossPayment;
        this.quoting.Mcq_Customer_Rate__c = mcqCustomerRate;
        this.quoting.Mcq_Payment_Frequency__c = mcqPaymentFrequency;
        this.quoting.Mcq_Message_Quote__c = mcqMessageQuote; 
        this.quoting.Mcq_Last_Response_Quote__c = mcqLastResponseQuote;
        this.quoting.Mcq_Application_Id__c = mcqApplicationId;
        this.quoting.Mcq_Message_Application_Id__c = mcqMessageAppId;
        this.quoting.Mcq_Last_Response_Application__c = mcqLastResponseApplication;
        update this.quoting;
    }*/

    /*NOT APPLICABLE
     * public PageReference macquarieQuoteTest(){
        System.debug('>>>>> Response QUOTES Macquarie (Test)  -I  <<<<<< - ');
        try{
            mcService.requestQuoteTest(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        System.debug('>>>>> Response QUOTES Macquarie (Test) -F  <<<<<<');
        return null;
    }*/
    
    public PageReference macquarieQuoteRestart(){
        System.debug('>>>>> Response QUOTES Macquarie (Restart)  -I  <<<<<< - ');
        mcqGrossPayment = null;
        System.debug('>>>>> Response QUOTES Macquarie (Restart) -F  <<<<<<');
        return null;
    }
    
    /*NOT APPLICABLE
     * public PageReference macquarieApplicationTest(){
        System.debug('>>>>> Response APPLICATION Macquarie  (Test)-I  <<<<<< - ');
        try{
            mcService.requestCreateApplicationTest(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            String er = '/' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'[Error createApplication: [' + er + ']'));
            return null;
        }
        System.debug('>>>>> Response APPLICATION Macquarie  (Test)-F  <<<<<< - ');
        return null;
    }*/
    
    /*public PageReference macquarieQuote(){
        System.debug('>>>>> Response QUOTES Macquarie  -I  <<<<<< - ');
        if (!isCalculateUpdate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please make sure calculate before send to Macquarie.'));
            return null;
        }
        if (mcqGrossPayment != null && !mcqMessageQuote.equalsIgnoreCase('')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Quote: Succeeded'));
            return null;
        }
        try{
            mcService.requestQuote(mcManager, opp, totalInsurance, false, mcqUser);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        
        if (mcManager.isError && 200 != mcManager.responseStatus){
            showErrorsMacquarie();
        }else{
            mcqGrossPayment = mcManager.mcqQuoteResponse.gross_payment;
            mcqCustomerRate = mcManager.mcqQuoteResponse.customer_rate;
            mcqPaymentFrequency = mcManager.mcqQuoteResponse.payment_frequency;
            mcqMessageQuote = mcManager.mcqQuoteResponse.message;
            mcqLastResponseQuote = mcManager.mcqQuoteResponse.lastResponseQuote;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Gross payment:   ' + mcqGrossPayment));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Customer rate:   ' + mcqCustomerRate));
            saveMacquarieAPIInformation();
        }
        System.debug('>>>>> Response QUOTES Macquarie  -F  <<<<<<');
        return null;
    }*/
    
    /* NOT APPLICABLE
     * public PageReference macquarieApplication(){
        System.debug('>>>>> Response APPLICATION Macquarie  -I  <<<<<< - ');
        /**
        try{
            String sUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            mcService.requestDocumentUpload(mcManager, opp, sUrl, false);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        **//*
        if (!isCalculateUpdate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please make sure calculate before send to Macquarie.'));
            return null;
        }
        try{
            mcService.requestCreateApplication(mcManager, opp, totalInsurance, false, mcqUser);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            String er = '/' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'[Error createApplication: [' + er + ']'));
            return null;
        }

        
        if (mcManager.isError && 200 != mcManager.responseStatus){
            showErrorsMacquarie();
        }else{
            mcqApplicationId = mcManager.mcqCreditAppResponse.application_id;
            mcqMessageAppId = mcManager.mcqCreditAppResponse.message;
            mcqLastResponseApplication = mcManager.mcqCreditAppResponse.lastResponseApplication;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Application Id:   ' + mcqApplicationId));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Message:   ' + mcqMessageAppId));
            saveMacquarieAPIInformation();
        }

        System.debug('>>>>> Response APPLICATION Macquarie  -F  <<<<<< - ');
        return null;
    }*/
    
    /*private void showErrorsMacquarie(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Savvy message: ' + mcManager.message + '. Please check all the data.'));
        String sError = '';
        System.debug(sError);
        if (mcManager.mcqError == null){
            sError = 'Status: [' + mcManager.responseStatus + ']- Message: [' + StringUtils.validateNull(mcManager.message) + ']- Response Message: [' + StringUtils.validateNull(mcManager.responseMessage) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else if (mcManager.mcqError.errors != null){
            for (McqErrorResponse.ErrorsValidationData error : mcManager.mcqError.errors){
                String messageError = '{' + error.label + '} - ' + error.message + ' - [' + error.getDescription() + ']' + ' [' + Utilities.salesforceValueToMessageCode_Description(error.label, Utilities.McQ_ERRORS_DATA) + ']';
                System.debug('>>@Error Macquarie: ' + messageError);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,messageError));
            }
        }else if (mcManager.mcqError.code != null){
            sError = 'Code: [' + StringUtils.validateNull(mcManager.mcqError.code) + '] - Error: [' + StringUtils.validateNull(mcManager.mcqError.error) + ']- Message: [' + StringUtils.validateNull(mcManager.mcqError.message) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else{
            sError = 'Status: [' + mcManager.responseStatus + ']- Message: [' + StringUtils.validateNull(mcManager.message) + ']- Response Message: [' + StringUtils.validateNull(mcManager.responseMessage) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }
    }*/
   
    //Lelo                      Insurance                   2017-12-04
    //Save quote
    private void updateQuoteRecord() {
        if (this.quote.Id != null) {
            this.quote.Amount_Financed__c = naf;            //Update Amount financied
            update this.quote;
        }
    }

    //Accept
    public void acceptQuoteMV() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(mvAcceptance)) {
            mvAcceptance = 'U';
        } else {
            mvAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.MV_Acceptance__c = mvAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
    }

    public void acceptQuoteGAP() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(gapAcceptance)) {
            gapAcceptance = 'U';
        } else {
            gapAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.GAP_Acceptance__c = gapAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void acceptQuoteTAS() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(taiAcceptance)) {
            taiAcceptance = 'U';
        } else {
            taiAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.TAS_Acceptance__c = taiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void acceptQuoteLTI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(ltiAcceptance)) {
            ltiAcceptance = 'U';
        } else {
            ltiAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.LTI_Acceptance__c = ltiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void acceptQuoteWRR() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(warrantyAcceptance)) {
            warrantyAcceptance = 'U';
        } else {
            warrantyAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.WRR_Acceptance__c = warrantyAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void acceptQuoteNWC() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (nwc == null || nwc == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty Retail Price cannot be zero, please check the Retail Price.'));       
        } else if (String.isBlank(nwcPlan) || String.isBlank(nwcTerm)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty Plan and Term should be selected.'));       
        } else if (nwcIncome == null || nwcIncome <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty commission is below zero, please check the Retail Price.'));       
        } else {
            if ('A'.equals(nwcAcceptance)) {
                nwcAcceptance = 'U';    
            } else {
                nwcAcceptance = 'A';    
            }
        }
        this.realtimeNafCalc();
    }

    //Decline
    public void declineQuoteMV() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(mvAcceptance)) {
            mvAcceptance = 'U';
        } else {
            mvAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.MV_Acceptance__c = mvAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
    }

    public void declineQuoteGAP() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(gapAcceptance)) {
            gapAcceptance = 'U';
        } else {
            gapAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.GAP_Acceptance__c = gapAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void declineQuoteTAS() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(taiAcceptance)) {
            taiAcceptance = 'U';
        } else {
            taiAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.TAS_Acceptance__c = taiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void declineQuoteLTI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(ltiAcceptance)) {
            ltiAcceptance = 'U';
        } else {
            ltiAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.LTI_Acceptance__c = ltiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void declineQuoteWRR() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(warrantyAcceptance)) {
            warrantyAcceptance = 'U';
        } else {
            warrantyAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.WRR_Acceptance__c = warrantyAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        this.realtimeNafCalc();
    }

    public void declineQuoteNWC() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(nwcAcceptance)) {
            nwcAcceptance = 'U';    
        } else {
            nwcAcceptance = 'D';    
        }
        this.realtimeNafCalc();
    }

    public Boolean hasQuotingInsProducts() {
        Boolean r = false;
        if ((mv != null && mv > 0) ||
            (gap != null && gap > 0) ||
            (tai != null && tai > 0) ||
            (lti != null && lti > 0) ||
            (warranty != null && warranty > 0) ||
            (nwc != null && nwc > 0)) {
            r = true;
        }
        return r;
    }

    public void sendPresentationStep1() {
        System.debug('sendPresentationStep1...');
        resetUserMessages();

        if (String.isBlank(this.opp.Application__c)) {
            putUserMessage(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.');
        } else {
            if (isValidPresentation()) {
                //Recalculate
                calculate();
                
                //Lelo                      2016-12-22
                //Save calculation
                if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
                    saveQuotingParameters();
                }
                //-

                //Validate results
                if (this.hasQuotingInsProducts()) {

                    //Save calculations
                    QuotingCalculation.saveQuotingResults(this.quoting.Id, calResults.values());
                } else {
                    putUserMessage(ApexPages.Severity.ERROR, 'This Quote does not contain any insurance product.');
                }
            }
        }
    }

    public void sendPresentationStep2() {
        System.debug('sendPresentationStep2...');
        if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            try {
                EmailSender.sendCustomerInsurancePresentation(this.opp, 
                    InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c));
                putUserMessage(ApexPages.Severity.CONFIRM, 'Customer Insurance Presentation has been sent it.');
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
            }
        }
    }

    public PageReference sendPresentationStep3() {
        System.debug('sendPresentationStep3...');
        if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            //Update presentation email date   
            this.quoting.Presentation_Email_Date__c = Datetime.now();
            update this.quoting;
            this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
            update this.quote;
        }
        showUserMessages();
        return null;
    }

    public void previewPresentation() {
        System.debug('previewPresentation...');
        resetUserMessages();
        if (String.isBlank(this.opp.Application__c)) {
            putUserMessage(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.');
        } else {
            //Validations
            if (isValidPresentation()) {
                //Recalculate
                calculate();
                
                //Lelo                      2016-12-22
                //Save calculation
                if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
                    saveQuotingParameters();
                }
                //-

                //Validate results
                if (this.hasQuotingInsProducts()) {

                    //Save calculations
                    QuotingCalculation.saveQuotingResults(this.quoting.Id, calResults.values());
                } else {
                    putUserMessage(ApexPages.Severity.ERROR, 'This Quote does not contain any insurance product.');
                }
            }
        }
        showUserMessages();
    }

    public Boolean isValidPresentation() {
        Boolean r = true; 
        if (!hasCalculationDone()) {
            putUserMessage(ApexPages.Severity.ERROR, 'Please calculate and save a Quoting before sending a presentation.');
            r = false;
        } else {
            if (!((warranty != null && warranty > 0) || (nwc != null && nwc > 0))) {
                putUserMessage(ApexPages.Severity.ERROR, 'GAP (RTI)* and any warranty product should be completed and calculated to continue with this functionality');
                r = false;
            }
        }
        return r;
    }

    public String getPresentationUrlCode() {
        return InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c);
    }

    public PageReference createQuote() {

        //if (String.isBlank(this.opp.Application__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
        //    return null;
        //}

        if (!hasQuoteValidationOK()) {
            return null;
        }

        //Validations
        //if (!isValidationOk()) {
        if (!hasCalculationDone()) {
            return null;
        }
        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
            PageReference n = Page.InsuranceQuoteStep1;
            n.getParameters().put('id', this.Opp.Id);
            return n;
        }
        return null;
    }

    public PageReference buyPolicy() {
        if (String.isBlank(this.opp.Application__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
            return null;
        }

        //Validations
        //if (!isValidationOk() || !isAnInsuranceProductAccepted()) {
        if (!hasCalculationDone() || !isAnInsuranceProductAccepted()) {
            return null;
        }

        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
            PageReference n = Page.InsuranceBuyPolicyStep1;
            n.getParameters().put('id', this.Opp.Id);
            return n;
        }
        return null;
    }

    public Boolean isAnInsuranceProductAccepted() {
        Boolean r = false;
        if ('A'.equals(this.quote.MV_Acceptance__c)) {
            r = true;
        } else if ('A'.equals(this.quote.GAP_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.TAS_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.LTI_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.WRR_Acceptance__c)) {
            r = true;
        }
        if (!r) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Any Insurance Product has been accepted.'));
        }

        return r;
    }

    public void nationalWarrantyCalc() {
        this.nwcCost = QuotingToolHelper.getNationalWarrantyCost(this.nwcPlan, this.nwcTerm);
    }

    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }

    public Application_Quoting_Result__c getSimpleResult() {
        return getCalcResult(QuotingCalculation.CALC_SIMPLE);
    }

    public Application_Quoting_Result__c getProFullyResult() {
        return getCalcResult(QuotingCalculation.PRO_FULLY);
    }

    public Application_Quoting_Result__c getProStandardResult() {
        return getCalcResult(QuotingCalculation.PRO_STANDARD);
    }

    public Application_Quoting_Result__c getProBasicResult() {
        return getCalcResult(QuotingCalculation.PRO_BASIC);
    }

    // Lelo             Insurance               2018-02-26
    private Boolean isFullyInsProductReady()  {
        Boolean r = false;
        if (((gap != null && gap > 0) || (tai != null && tai > 0)) &&
            ((lti != null && lti > 0) || (cci != null && cci > 0)) &&
            ((warranty != null && warranty > 0) || 
                //HJ - NWC exclude others - 21-11-2018
                (nwc != null && ((nwc > 0 && 'Car'.equalsIgnoreCase(getAssetTypeOpp())) || !'Car'.equalsIgnoreCase(getAssetTypeOpp()))))) {
            r = true;
        }
        return r;
    }
        
    private Boolean isStandardInsProductReady()  {
        Boolean r = false;
        if (((gap != null && gap > 0) || (tai != null && tai > 0)) &&
            ((warranty != null && warranty > 0) || 
                //HJ - NWC exclude others - 21-11-2018
                (nwc != null && ((nwc > 0 && 'Car'.equalsIgnoreCase(getAssetTypeOpp())) || !'Car'.equalsIgnoreCase(getAssetTypeOpp()))))) {
            r = true;
        }
        return r;
    }

    private Boolean isBasicInsProductReady()  {
        Boolean r = false;
        if ((gap != null && gap > 0) || (tai != null && tai > 0))  {
            r = true;
        }
        return r;
    }
    //- 

    private Decimal getGapTai() {
        Decimal r = 0.0;
        if (getIsRTIRequired()) {
            if (tai != null) {
                r += tai;
            }
        } else {
            if (gap != null) {
                r += gap;
            }
        }
        return r;
    }

    private Decimal getWarrNwc() {
        Decimal r = 0.0;
        if (getHasWarranty()) {
            if (warranty != null) {
                r += warranty;
            }
        } else {
            if (nwc != null) {
                r += nwc;
            }
        }
        return r;
    }

    private Decimal getGapTaiIncome() {
        Decimal r = 0.0;
        if (getIsRTIRequired()) {
            if (taiIncome != null) {
                r += taiIncome;
            }
        } else {
            if (gapIncome != null) {
                r += gapIncome;
            }
        }
        return r;
    }

    private Decimal getWarrNwcIncome() {
        Decimal r = 0.0;
        if (getHasWarranty()) {
            if (warrantyIncome != null) {
                r += warrantyIncome;
            }
        } else {
            if (nwcIncome != null) {
                r += nwcIncome;
            }
        }
        return r;
    }

    public List<SelectOption> getQuoteNumberOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        List<Application_InsuranceQuote__c> d = InsuranceQuoteUtils.getApplicationInsuranceQuotesByAppId(this.opp.Application__c, LENDER_QUOTING);
        if (d != null) {
            String label = '';
            for (Application_InsuranceQuote__c q : d) {
                //label = q.Quotation_Number__c + ' [' + q.Quotation_Date__c.format(DateUtils.FORMAT_LOCAL_FULL + ' a') + ']';
                label = q.Quotation_Number__c + ' [' + q.Quotation_Date__c.format() + ']';
                r.add(new SelectOption(q.Id, label));
            }
        }
        return r;
    }

    public PageReference importQuote() {
        if (this.quoteIdSelected == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a quote.'));
        } else if (this.quote != null && this.quoteIdSelected == this.quote.Id) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Quote already imported.'));
        } else if (this.quoting == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save a quote calculation before importing.'));
        } else {
            InsuranceQuoteUtils.importQuoteInQuotingTool(this.quoteIdSelected, this.opp.Id, LENDER_QUOTING);
            this.loadQuotingParametersSaved();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote has been imported successfully.'));
        }
        return null;
    }

    public Boolean getIsRTIRequired() {
        Boolean r = false;
        Decimal pDep = 0;
        if (carPrice != null && carPrice > 0) {
            pDep = netDeposit / carPrice * 100;
        }
        if (pDep >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
            r = true;
        }
        return r;               
    }

    private void resetUserMessages() {
        userMgs = new Map<ApexPages.severity, List<String>>();
    }

    private void putUserMessage(ApexPages.severity msgType, String message) {
        List<String> lst = userMgs.get(msgType);
        if (lst == null) {
            lst = new List<String>();
            userMgs.put(msgType, lst);
        }
        lst.add(message);
    }

    private void showUserMessages() {
        System.debug('Showing messages...');
        if (userMgs != null) {
            System.debug('Total messages >> ' + userMgs.size());
            for (ApexPages.severity k : userMgs.keySet()) {
                for (String m : userMgs.get(k)) {
                    System.debug(k  + '|' + m);
                    ApexPages.addMessage(new ApexPages.Message(k, m));
                }
            }
        }
    }

    public Boolean getHasUserMessages() {
        Boolean r = false;
        if (userMgs != null && !userMgs.isEmpty()) {
            r  = true;
        }
        return r;
    }

    public Boolean getHasWarranty() {
        Boolean r = false;
        if ('A'.equals(insuranceInputMode)) {
            if (this.quoting != null && String.isNotBlank(warrantyLevel)) {
                //r = this.quoting.Has_Warranty__c;
                r = true;
            }
        }
        return r;
    }

    public Boolean getDisplayNwcInsurance() {
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(warrantyLevel)) {
                r  = true;
            }
        }
        return r;
    }

        
    //Lelo                      2017-07-21
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidCalculate();
        if (r) {
            calculate();
            if (rental != null && rental > 0) {
                r = true;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before proceeding with your request.'));
                r = false;
            }
        }
        return r;
    }

    public void sendCustomerEmail1() {
        System.debug('sendCustomerEmail1...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            try {
                Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
                EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
    }
    //-
       
    //Lelo                      2017-07-24   
    private Decimal getTotalAmount(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (applicationFee != null) r += applicationFee;
        if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        //if (registrationFee != null) r += registrationFee;
        if (netDeposit != null) r -= netDeposit;
        
        return r;
    }

    private Decimal getTotalInsuranceType(String calcType) {
        Decimal r = 0.0;
        //if (nwc != null) r += nwc;
        //if (gap != null) r += gap;
        //if (warranty != null) r += warranty;
        //if (lti != null) r += lti;
        //if (truckGap != null) r += truckGap;
        //if (tai != null) r += tai;
        //if (mv != null) r += mv;
        //if (cci != null) r += cci;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            //Quote Insurances
            //if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
            //    if (mv != null) r += mv;
            //}
            if ('A'.equals(gapAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (gap != null) r += gap;
            }
            if ('A'.equals(taiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (tai != null) r += tai;
            }
            if ('A'.equals(ltiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (lti != null) r += lti;
            }
            if ('A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (warranty != null) r += warranty;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwc != null) r += nwc;    
            }
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (cci != null) r += cci;    
            }
            //-
        } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            //Yohan VillaLeal 
            r = getGapTai();
            r += getWarrNwc();

            if (getHasLti()) {
                r += getLtiCci();
            } else {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType) + r;
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r += results.premium;
                } 
            }
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r = getGapTai();
            //Lelo                  Insurance           2018-02-26
            r += getWarrNwc();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r = getGapTai();
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            //if (mv != null) r += mv;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (gap != null) r += gap;
        } else if (InsuranceQuoteUtils.INS_PROD_TAI.equals(calcType)) {
            if (tai != null) r += tai;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (lti != null) r += lti;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warranty != null) r += warranty;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (cci != null){
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r = results.premium;
                }
            }
        }
        return r;
    }

    private Decimal getTotalInsuranceIncomeType(String calcType) {
        Decimal r = 0.0;
        //if (nwcIncome != null) r += nwcIncome;
        //if (gapIncome != null) r += gapIncome;
        //if (warrantyIncome != null) r += warrantyIncome;
        //if (ltiIncome != null) r += ltiIncome;
        //if (truckGapIncome != null) r += truckGapIncome;
        //if (taiIncome != null) r += taiIncome;
        //if (mvIncome != null) r += mvIncome;
        //if (cciIncome != null) r += cciIncome;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (mvIncome != null) r += mvIncome;
            }
            if ('A'.equals(gapAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (gapIncome != null) r += gapIncome;
            }
            if ('A'.equals(taiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (taiIncome != null) r += taiIncome;
            }
            if ('A'.equals(ltiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (ltiIncome != null) r += ltiIncome;
            }
            if ('A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (warrantyIncome != null) r += warrantyIncome;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwcIncome != null) r += nwcIncome;    
            }
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (cciIncome != null) r += cciIncome;    
            }
        }else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            //Yohan VillaLeal          Insurance       2018-07-11  
            r += getGapTaiIncome();
            r += getWarrNwcIncome();
            //Lelo                  Insurance           2018-07-03
            if (getHasLti()) {
                r += getLtiCciIncome();
            } else {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType) + getGapTai() + getWarrNwc();
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r += results.commission;
                } 
            }
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r += getGapTaiIncome();
            //Lelo          Insurance               2018-02-26
            r += getWarrNwcIncome();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r += getGapTaiIncome();
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            if (mvIncome != null) r += mvIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (gapIncome != null) r += gapIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_TAI.equals(calcType)) {
            if (taiIncome != null) r += taiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (ltiIncome != null) r += ltiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warrantyIncome != null) r += warrantyIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (cciIncome != null){
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r = results.commission;
                } 
            }
        }
        return r;
    }

    private void calculateRepayments() {

        //Reset results
        this.resetCalculationResult();
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        String quotingType = QuotingCalculation.CALC_QUOTING;
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
        //param.clientRate = clientRate;
        param.baseRate = baseRate;
        param.paymentType = paymentType;
        param.term = term;
        param.dof = dof;
        param.monthlyFee = monthlyFee;
        //param.docFees = docFees;
        param.residualValue = residualValue;

        param.brokeragePer = brokeragePercentage;
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(quotingType);
        param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);


        System.debug(quotingType + '|' + param.amountBasePmt + '|' + param.amountBaseComm + '|' + param.getNaf());

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
            estimatedCommission = r.Estimated_Commission__c;
            dofResult = r.DOF__c;
            insuranceIncome = r.Insurance_Income__c;
            totalCommission = r.Total_Commission__c;
            totalCommissionGst = r.Total_Commission_Gst__c;

            naf = r.NAF__c;
            rental = r.Rental__c;
            monthlyPayment= r.Monthly_Payment__c;
            fortnightlyPayment = r.Fortnightly_Payment__c;
            weeklyPayment = r.Weekly_Payment__c;
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

        //Lelo          Insurenace          2017-12-04
        //Simple
        param.lender = LENDER_QUOTING;
        param.totalInsurance = 0;
        param.totalInsuranceIncome = 0;
        
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = QuotingCalculation.CALC_SIMPLE;   
        }
        calResults.put(QuotingCalculation.CALC_SIMPLE, r);

        //Insurance
        //if (includeInsurance) {
            List<String> calcTypes = new List<String>();
            if (isFullyInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_FULLY);
            }
            if (isStandardInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_STANDARD);
            }
            if (isBasicInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_BASIC);    
            }
            //Insurance one by one
            //MV
            if (mv != null && mv > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
            }
            //GAP
            if (gap != null && gap > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
            }
            //TAI
            if (tai != null && tai > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_TAI);
            }
            //LTI
            if (lti != null && lti > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_LTI);
            }
            //WARR
            if (warranty != null && warranty > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
            }
            //NWC
            if (nwc != null && nwc > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
            }
            //CCI
            //Lelo          Insurance           2018-02-26
            if (cci != null && cci > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
            }
            //-
            
            for (String key: calcTypes) {
                param.totalAmount = getTotalAmount(key);
                param.totalInsurance = this.getTotalInsuranceType(key);
                param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
                param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(key);
                param.amountBaseComm = this.getBaseAmountPmtCalc(key);
                System.debug('INSURA >> ' + key + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.amountBasePmt + '|' + param.amountBaseComm);
                r = QuotingCalculation.calculate(param);
                if (r != null) {
                    r.Result_Type__c = key;   
                }
                calResults.put(key, r);                
            }

        //}
        //-


        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(quotingType);
        param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);
        System.debug(quotingType + '|' + param.amountBasePmt + '|' + param.amountBaseComm + '|' + param.getNaf());
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

    }

    //Lelo                              2017-07-25
    private void resetCalculationResult() {

        estimatedCommission = 0.0;
        dofResult = 0.0;
        insuranceIncome = 0.0;
        totalCommission = 0.0;
        totalCommissionGst = 0.0;

        naf = 0.0;
        rental = 0.0;
        monthlyPayment = 0.0;
        fortnightlyPayment = 0.0;
        weeklyPayment = 0.0;

        calResults = new Map<String, Application_Quoting_Result__c>();
    }

    private Application_Quoting_Result__c getCalcResult(String calcType) {
        Application_Quoting_Result__c r = null;
        if (this.calResults != null) {
            r = this.calResults.get(calcType);
        }
        return r;
    }

    public Application_Quoting_Result__c getProtectecResult() {
        return getCalcResult(QuotingCalculation.CALC_PROTECTED);
    }
    //-

    public List<MacquarieConsumerRatesv2__c> getRateList() {
        // List <MacquarieConsumerRatesv2__c> r = MacquarieConsumerRatesv2__c.getAll().values();
        // r.sort();
        return QuotingCalculation.getMacquarieRates('Commercial');
    }

    private Boolean hasQuoteValidationOK() {
        Boolean r = true;
        //check for an application
        if (this.opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please link/create an application before quoting.'));
            r = false;
        } else {
            if (!'F'.equals(this.opp.Application__r.Status__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please the linked application should be finished.'));
                r = false;
            }
        }
        if (this.opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save a Asset Detail - LTV before quoting.'));
            r = false;
        }
        return r;
    }

    //Lelo          Insurance           2018-02-26
    public Boolean getDisplayCCIInsurance() {
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(ltiLevel) && cciAcceptance != null && String.isNotBlank(cciLevel)) {
                r  = true;
            }
        }
        return r;
    }
    public void acceptQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (cci == null || cci == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The CCI - AIC/Eric Retail Price cannot be zero, please check the Retail Price.'));       
        } else {
            if ('A'.equals(cciAcceptance)) {
                cciAcceptance = 'U';    
            } else {
                cciAcceptance = 'A';    
            }
        }
        this.realtimeNafCalc();
    }
    public void declineQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(cciAcceptance)) {
            cciAcceptance = 'U';    
        } else {
            cciAcceptance = 'D';    
        }
        this.realtimeNafCalc();
    }

    private Decimal getLtiCci() {
        Decimal r = 0.0;
        if (getHasLti()) {
            if (lti != null) {
                r += lti;
            }
        } else {
            if (cci != null) {
                r += cci;
            }
        }
        return r;
    }

    private Decimal getLtiCciIncome() {
        Decimal r = 0.0;
        if (getHasLti()) {
            if (ltiIncome != null) {
                r += ltiIncome;
            }
        } else {
            if (cciIncome != null) {
                r += cciIncome;
            }
        }
        return r;
    }

    public Boolean getHasLti() {
        Boolean r = false;
        if ('A'.equals(insuranceInputMode)) {
            if (this.quoting != null && String.isNotBlank(ltiLevel)) {
                r = true;
            }
        }
        return r;
    }
    //-
    public Boolean getHasCustomerEmailSent() {
        Boolean r = false;
        if (this.quoting != null && this.quoting.Presentation_Email_Date__c != null) {
            r = true;
        }
        return r;
    }

    public String getCustomerPresentationStatusStyle() {
        String r = 'presentationSent';
        if (this.quoting != null && this.quoting.Presentation_Email_Date__c != null && this.quote != null) {
            if (InsuranceQuoteUtils.CUSCHOICE_DECIDING.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_DECLARING.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_FILLINFO.equals(this.quote.Customer_Choice_Status__c)) {
                r = 'presentationProcess';
            } else if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
                r = 'presentationFinished';
            }
        }
        return r;
    }

    public List<Insurance_Failure_Reason__c> getInsuranceFailureReasons() {
        List<Insurance_Failure_Reason__c> r = new List<Insurance_Failure_Reason__c>();
        if (this.quote != null && this.quote.Id != null) {
            return InsuranceQuoteUtils.getInsuranceFailureReasons(this.quote.Id);
        }
        return r;
    }
		
	public Decimal getTermYears() {
        if (term == null) return 0;
        return term/12;
    }
	
	//--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 12/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption('','--None--'));
        for (String value : cciLevels) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = cciLevel;
        parameters.term = MATH.round(getTermYears());
        parameters.initialAmount = this.realtimeNaf;
        if ('A'.equals(cciAcceptance))  {
            parameters.initialAmount -= cci;
        }
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        
        if(results != null){
            cci = results.premium;
	        cciIncome = results.commission;
        }else{
            cci = 0.00;
	        cciIncome = 0.00;
        }
    }

    public Boolean insuranceProductSelected() {
        Boolean r = true;
        // Lelo                 2018-08-16 
        // Accepted or declined validation
        // Motor Vehicle
        if (String.isNotBlank(this.mvLevel) && (String.isBlank(this.mvAcceptance) || 'U'.equals(this.mvAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motor Vehicle should be Accepted or Declined.'));
            r = false;
        }
        // GAP / RTI
        if (String.isNotBlank(this.gapLevel)) {
            if (String.isBlank(this.gapAcceptance) || 'U'.equals(this.gapAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'GAP should be Accepted or Declined.'));
                r = false;
            }
        } else if (String.isNotBlank(this.taiLevel) && (String.isBlank(this.taiAcceptance) || 'U'.equals(this.taiAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'RTI should be Accepted or Declined.'));
            r = false;
        }
        // LTI / Repayment cover (Loan Protection)
        if (String.isNotBlank(this.ltiLevel)) {
            if (String.isBlank(this.ltiAcceptance) || 'U'.equals(this.ltiAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LTI should be Accepted or Declined.'));
                r = false;
            }
        } else if (this.cci > 0 && (String.isBlank(this.cciAcceptance) || 'U'.equals(this.cciAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Repayment cover (Loan Protection) should be Accepted or Declined.'));
            r = false;
        }
        // Warranty / NWC
        if (String.isNotBlank(this.warrantyLevel)){
            if (String.isBlank(this.warrantyAcceptance) || 'U'.equals(this.warrantyAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Warranty - Insurance should be Accepted or Declined.'));
                r = false;
            }
        } else if (this.nwc > 0 && (String.isBlank(this.nwcAcceptance) || 'U'.equals(this.nwcAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NWC Warranty should be Accepted or Declined.'));
            r = false;
        }
        return r;
    }
    
    //NWC Calculator - HJ - 12-07-2018 - I
    public void loadNWCParameters(){
        NWCMessage = '';
        isAssetCar = false;
        isAssetBoat = false;
        //Warranty update - HJ - 03-12-2018 - I
        nwcParam.isIntegrity = false;
        //Warranty update - HJ - 03-12-2018 - F
        //String asset = dto.productGoodsType;
        nwcParam.assetType = getAssetTypeOpp();
        nwcParam.state = getStateOpp();
        isCategoryType = false;
        if ('Car'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetCar = true;
            isCategoryType = true;
        }
        if ('Boat'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetBoat = true;
            isCategoryType = true;
        }
        if ('Truck'.equalsIgnoreCase(nwcParam.assetType)){
            isCategoryType = true;
        }
        //Warranty update - HJ - 03-12-2018 - I
        if ('Integrity'.equalsIgnoreCase(nwcParam.type_p)){
            nwcParam.isIntegrity = true;
        }
        //Warranty update - HJ - 03-12-2018 - F
        nwcParam.plan = nwcPlan;
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType);
        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType, nwcParam.type_p);
        NWCTermOptions = NWCCalc.NWCTermOptions (nwcParam.assetType, nwcParam.type_p);
        loadCategory();
        isNWCValidationOk = true;

        //NWC Warnings - I
        this.aad = ApplicationService.getAssetDetail(this.Opp.Id);
        this.vehicleAgeYear = Utilities.getVehicleAgeYears(this.aad, this.Opp);
        nwcParam.vehicleAgeYears = vehicleAgeYear;
        if (this.aad != null && this.aad.Actual_KM__c != null){
            nwcParam.actualKm = this.aad.Actual_KM__c;
        }
        
        //NWC Warnings - F

        calculateNWC();
    }
    
    private void loadCategory(){
        //if (NWCTypePOptions.size() <= 2 && !'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    nwcParam.type_p = 'NWC';
        //    isCategoryType = false;
        //}else if (NWCTypePOptions.size() <= 2 && 'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    isCategoryType = true;
        //}
    }
    
    public void checkManuallyNWCPrice(){
        if (priceCustomer != null){
            nwcParam.nwcPriceToCustomer = priceCustomer;
        }
        if (nwcParam.isManuallyNWCPrice){
            Decimal priceCustomer = nwcParam.nwcPriceToCustomer;
            //Warranty update - HJ - 03-12-2018 - I
            if (priceCustomer == null){
                nwcParam.isManuallyNWCPrice = false;
                return;
            }
            //Warranty update - HJ - 03-12-2018 - F
            Long iPart = (Long) priceCustomer;
            Decimal fPart = priceCustomer - iPart;
            if (fPart > 0){
                nwcParam.nwcPriceToCustomer = NumberUtils.convertDecimalToScale(priceCustomer - 0.01, 2) ;
            }
        }
        calculateNWC();
    }
    
    public void calculateNWC(){
        
        isNWCValidationOk = true;
        NWCMessage = '';
        nwcParam.plan = nwcPlan;
        nwcParam.term = nwcTerm;
        nwcParam.state = getStateOpp();

        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType, nwcParam.type_p);

        //NWC Warnings - I
        checkNWCMessages(nwcParam);
        //NWC Warnings - F
        
        //if (NWCTypePOptions.size() == 2 && !'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    nwcParam.type_p = 'NWC';
        //    isCategoryType = false;
        //}else if (NWCTypePOptions.size() == 2 && 'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    isCategoryType = true;
        //}else{
        //    isCategoryType = true;
        //}

        NWCTermOptions = NWCCalc.NWCTermOptions (nwcParam.assetType, nwcParam.type_p, nwcParam.plan);

        //Warranty update - HJ - 03-12-2018 - I
        nwcParam.isIntegrity = false;
        if ('Integrity'.equalsIgnoreCase(nwcParam.type_p)){
            nwcParam.isIntegrity = false;
            if (!StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.Term)){
                nwcParam.isIntegrity = true;
            }
            return;
        }
        //Warranty update - HJ - 03-12-2018 - F
        nwcIncome = 0;
        nwc = 0;

        if (!StringUtils.isNullOrEmpty(nwcParam.assetType) && !StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.term) &&
            !StringUtils.isNullOrEmpty(nwcParam.type_p)){
                /**
                if (isAssetCar && (StringUtils.isNullOrEmpty(nwcParam.awd4wd) || StringUtils.isNullOrEmpty(nwcParam.luxuryCar))){
                    //NWCMessage = 'Missing values';
                    //System.debug('Missing values: AWD4WD / LuxuryCar]');
                }else **/
                if (isAssetBoat && '----'.equalsIgnoreCase(nwcParam.type_p)){
                    //NWCMessage = 'Missing values';
                    System.debug('Missing values: Engine]');
                }else if ('----'.equalsIgnoreCase(nwcParam.type_p)){
                    //NWCMessage = 'Missing values';
                    System.debug('Missing values: Category]');
                }else{
                    try{
                        NWCCalc.Result r = NWCCalc.CalculateNWC(nwcParam);
                        nwc = r.retailPrice;
                        nwcIncome = r.commission;
                        priceCustomer = nwc;
                        //NWCMessage = 'OK-' + nwcParam.nwcPriceToCustomer;
                    }catch (Exception ex){
                        NWCMessage = ex.getMessage();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NWC Warranty: [' + NWCMessage + ']'));
                        System.debug('NWC Warranty: [' + NWCMessage + ']');
                        isNWCValidationOk = false;
                    }
                }
            }else{
                //NWCMessage = 'Missing values';
                System.debug('NWC Calculator: Missing values');
            }
        loadCategory();
    }

    private String getStateOpp(){
        String r = '';
        if (this.Opp != null && this.Opp.Application__c != null && String.isNotBlank(this.Opp.Application__r.State__c)) {
            r = this.Opp.Application__r.State__c;
        }
        return r;
    }
    
    private String getAssetTypeOpp(){
        String r = '';
        if (this.Opp != null && this.Opp.Application__c != null && String.isNotBlank(this.Opp.Application__r.Type_of_Asset__c)) {
            r = this.Opp.Application__r.Type_of_Asset__c;
        }
        return r;
    }

    //NWC Warnings - I
    private void checkNWCMessages(NWCCalc.Parameter nwcParam){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'VechileYear: ' + nwcParam.vehicleAgeYears + ' ActualKm: ' + nwcParam.actualKm));
        this.messageNWCWarning = null;
        if (nwcParam == null || nwcParam.plan == null || nwcParam.vehicleAgeYears == null || nwcParam.actualKm == null){
            return;
        }
        if ('Bronze'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 20 && nwcParam.actualKm > 300000){
            this.messageNWCWarning = 'Vehicles is up to 20 years and 300,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Silver'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 20 && nwcParam.actualKm > 250000){
            this.messageNWCWarning = 'Vehicles is up to 20 years and 250,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Gold'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 15 && nwcParam.actualKm > 200000){
            this.messageNWCWarning = 'Vehicles is up to 15 years and 200,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Platinum'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 10 && nwcParam.actualKm > 150000){
            this.messageNWCWarning = 'Vehicles is up to 10 years and 150,000kms for this Category [' + nwcParam.plan + ']';
        }
    }
    //NWC Warnings - F
    
    //NWC Calculator - HJ - 12-07-2018 - F

    //Yohan VillaLeal    08/11/2018
    public void assetYearOption(){
        manufactureYearOptions = new List <SelectOption> ();
        manufactureYearOptions.add(new SelectOption ('', '--None--'));    
        Integer y = Date.today().year();
        //manufactureYearOptions.add(new SelectOption ('', '--None--'));
        
        // if('MOTOV'.equals(productGoodsType)){
            for(Integer i = y;i >= y - 4;i--) {
                manufactureYearOptions.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
            }
            SelectOption myOp = manufactureYearOptions.get(manufactureYearOptions.size()-1);
            myOp.setLabel(myOp.getValue() + ' or older');
        // }else{ 
        //     for(Integer i = y;i >= y - 3;i--) {
        //         manufactureYearOptions.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
        //     }
        // }
        this.manufactureYear = manufactureYearOptions.get(0).getValue();
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    
}