public class EsandaCalculatorExtension {
    
    public Custom_Opportunity__c Opp;
    
    //Lelo                                      2016-07-26
    private String fileGlobalPrefix = 'ANZ_Consumer';
    //-
    
    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal ppsr {get;set;}
    public Decimal residualValue {get;set;}
    public Decimal baseRate {get;set;}
    public Decimal clientRate {get;set;}
    public String vehicleAge {get;set;}             //Lelo          2016-11-22
    public String vehicleCondition {get;set;}             //Lelo          2016-11-22
    //public String[] vehicleAgeValues = new String[]{'New to <= 3 year','> 3 year to <= 7 year'};
    public String[] vehicleAgeValues = new String[]{'0','1','2','3','4','5','6','7'};
    public List <SelectOption> vehicleAgeOptions {get;set;}

    public Integer term {get;set;}
    public String adverseCredit {get;set;}
    public String customerProfile {get;set;}
    public String ltv {get;set;}
    public String ltvTmp = null;
    public String paymentType {get;set;}
    
    
    //public List <SelectOption> termTypes {get;set;}
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> profileTypes {get;set;}
    public List <SelectOption> paymentTypes {get;set;}
    
    // finance calculator output
    public Decimal estimatedCommission {get;set;}
    public Decimal insuranceIncome {get;set;}
    public Decimal dofResult {get;set;}
    public Decimal docFees {get;set;}
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
    public List <Esanda_Consumer_Rates__c> esandaRates {get;set;}
    //Map <String,Esanda_Consumer_Rates__c> esandaConsumerRates {get;set;}
    
    // addtional loan information
    
    public String productLoanType {get;set;}
    public String productGoodsType {get;set;}
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    
    // the real time NAF
    public Decimal realtimeNaf {get;set;}
    
    // other things
    Map<String,id> RecordTypes {get;set;}
    //list <attachment> existingAttach {get;set;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'ANZ Consumer';
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    public Decimal netDeposit {get;set;}
    public String loanType {get;set;}                       
    public List <SelectOption> loanTypeOptions {get;set;}         
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;   
    //-
    
    private Lenders__c lenderSettings = null;

    //Lelo                  Insurance                       2017-12-04
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

    //LPI Rates - Freddy Villamizar | 01/07/2018
    public String coverOption {get;set;}
    public Double premium {get;set;}
    
	private List<String> coverOptions = new List<String> {
      'Disability', 'Disability/Unemployment'
    };
        
    public EsandaCalculatorExtension (ApexPages.StandardController controller) {
        try {
                controller.addFields(new List<String>{'Application__c'});
                
        } catch (SObjectException e) { System.debug('EsandaCalculatorExtension >> ' + e.getMessage()); }
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
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%ANZ_Consumer%'];
        if (lenderSettings != null) {
            this.docFees = lenderSettings.DOC_Fees__c;
            this.monthlyFee = lenderSettings.Monthly_Fee__c;
            this.ppsr = lenderSettings.PPSR__c;
            this.applicationFee = lenderSettings.Application_Fee__c;
            this.dof = lenderSettings.DOF__c;
        }
        this.baseRate = 0.00;
        this.term = 60;
        this.adverseCredit = 'N';
        this.paymentType = 'Arrears';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.realtimeNaf = applicationFee + dof + ppsr;
        this.netDeposit = 0.0;

        this.resetCalculationResult(); //Lelo       2017-07-25
        
        //esandaConsumerRates = Esanda_Consumer_Rates__c.getAll();
        //System.debug('The map value: ' + esandaConsumerRates);
        esandaRates = Esanda_Consumer_Rates__c.getAll().values();
        esandaRates.sort();
        
        vehicleAgeOptions = new List <SelectOption> ();
        for (Integer i = 0;i < vehicleAgeValues.size();i++) {
            vehicleAgeOptions.add(new SelectOption (String.valueOf(i), vehicleAgeValues[i]));
        }
        
        yesNoOptions = new List <SelectOption> ();
        yesNoOptions.add(new SelectOption ('', '--None--'));
        yesNoOptions.add(new SelectOption ('Y', 'Yes'));
        yesNoOptions.add(new SelectOption ('N', 'No'));
        profileTypes = new List <SelectOption> ();
        //profileTypes.add(new SelectOption ('', '--None--'));
        profileTypes.add(new SelectOption ('Property Owner - New Car', 'Property Owner_17-18 Car'));
        profileTypes.add(new SelectOption ('Property Owner - Old Car', 'Property Owner_16-Older Car'));
        profileTypes.add(new SelectOption ('Non Property Owner - New Car', 'Non Property Owner_17-18 Car'));
        profileTypes.add(new SelectOption ('Non Property Owner - Old Car', 'Non Property Owner_16-Older Car'));
        
        paymentTypes = new List <SelectOption> ();
        //paymentTypes.add(new SelectOption ('', '--None--'));
        paymentTypes.add(new SelectOption ('Arrears', 'Arrears'));
        paymentTypes.add(new SelectOption ('Advance', 'Advance'));
        stateOptions = new List <SelectOption> ();
        stateOptions.add(new SelectOption ('', '--None--'));
        stateOptions.add(new SelectOption ('ACT', 'ACT'));
        stateOptions.add(new SelectOption ('NSW', 'NSW'));
        stateOptions.add(new SelectOption ('NT', 'NT'));
        stateOptions.add(new SelectOption ('QLD', 'QLD'));
        stateOptions.add(new SelectOption ('SA', 'SA'));
        stateOptions.add(new SelectOption ('TAS', 'TAS'));
        stateOptions.add(new SelectOption ('VIC', 'VIC'));
        stateOptions.add(new SelectOption ('WA', 'WA'));
        vehicleGroupTypes = new List <SelectOption> ();
        vehicleGroupTypes.add(new SelectOption ('', '--None--'));
        vehicleGroupTypes.add(new SelectOption ('1', 'Group 1 Vehicles'));
        vehicleGroupTypes.add(new SelectOption ('2', 'Group 2 Vehicles'));
        vehicleGroupTypes.add(new SelectOption ('3', 'Group 3 Vehicles'));
        vehicleGroupTypes.add(new SelectOption ('4', 'Unacceptable Vehicles'));
        gapLevels = new List <SelectOption> ();
        gapLevels.add(new SelectOption ('', '--None--'));
        gapLevels.add(new SelectOption ('Premier Cover 1', 'Premier Cover 1'));
        gapLevels.add(new SelectOption ('Premier Cover 2', 'Premier Cover 2'));
        gapLevels.add(new SelectOption ('Premier Cover 3', 'Premier Cover 3'));
        gapLevels.add(new SelectOption ('Classic Cover 1', 'Classic Cover 1'));
        gapLevels.add(new SelectOption ('Classic Cover 2', 'Classic Cover 2'));
        gapLevels.add(new SelectOption ('Classic Cover 3', 'Classic Cover 3'));
        gapLevels.add(new SelectOption ('Classic Cover 4', 'Classic Cover 4'));
        warrantyLevels = new List <SelectOption> ();
        warrantyLevels.add(new SelectOption ('', '--None--'));
        warrantyLevels.add(new SelectOption ('Platinum - 12 months', 'Platinum - 12 months'));
        warrantyLevels.add(new SelectOption ('Platinum - 24 months', 'Platinum - 24 months'));
        warrantyLevels.add(new SelectOption ('Platinum - 36 months', 'Platinum - 36 months'));
        warrantyLevels.add(new SelectOption ('Extra Time', 'Extra Time'));
        warrantyLevels.add(new SelectOption ('Diamond - 12 months', 'Diamond - 12 months'));
        warrantyLevels.add(new SelectOption ('Diamond - 24 months', 'Diamond - 24 months'));
        warrantyLevels.add(new SelectOption ('Diamond - 36 months', 'Diamond - 36 months'));
        warrantyLevels.add(new SelectOption ('Gold - 12 months', 'Gold - 12 months'));
        warrantyLevels.add(new SelectOption ('Gold - 24 months', 'Gold - 24 months'));
        warrantyLevels.add(new SelectOption ('Gold - 36 months', 'Gold - 36 months'));
        warrantyLevels.add(new SelectOption ('Tyre and Wheel - 12 months', 'Tyre and Wheel - 12 months'));
        warrantyLevels.add(new SelectOption ('Tyre and Wheel - 24 months', 'Tyre and Wheel - 24 months'));
        warrantyLevels.add(new SelectOption ('Tyre and Wheel - 36 months', 'Tyre and Wheel - 36 months'));
        ltiLevels = new List <SelectOption> ();
        ltiLevels.add(new SelectOption ('', '--None--'));
        ltiLevels.add(new SelectOption ('Platinum Cover 1', 'Platinum Cover 1'));
        ltiLevels.add(new SelectOption ('Platinum Cover 2', 'Platinum Cover 2'));
        ltiLevels.add(new SelectOption ('Platinum Cover 3', 'Platinum Cover 3'));
        ltiLevels.add(new SelectOption ('Gold Cover 1', 'Gold Cover 1'));
        ltiLevels.add(new SelectOption ('Gold Cover 2', 'Gold Cover 2'));
        ltiLevels.add(new SelectOption ('Silver Cover 1', 'Silver Cover 1'));
        ltiLevels.add(new SelectOption ('Silver Cover 2', 'Silver Cover 2'));
        ltiLevels.add(new SelectOption ('Silver Cover 3 on-cost', 'Silver Cover 3 on-cost'));
        truckGapLevels = new List <SelectOption> ();
        truckGapLevels.add(new SelectOption ('', '--None--'));
        truckGapLevels.add(new SelectOption ('Cover 1', 'Cover 1'));
        truckGapLevels.add(new SelectOption ('Cover 2', 'Cover 2'));
        taiLevels = new List <SelectOption> ();
        taiLevels.add(new SelectOption ('', '--None--'));
        taiLevels.add(new SelectOption ('TAI Cover 1 ($5,000)', 'TAI Cover 1 ($5,000)'));
        taiLevels.add(new SelectOption ('TAI Cover 2 ($4,000)', 'TAI Cover 2 ($4,000)'));
        taiLevels.add(new SelectOption ('TAI Cover 3 ($3,000)', 'TAI Cover 3 ($3,000)'));
        taiLevels.add(new SelectOption ('RTI ($7,000)', 'RTI ($7,000)'));
        taiLevels.add(new SelectOption ('RTI ($10,000)', 'RTI ($10,000)'));
        taiLevels.add(new SelectOption ('RTI ($15,000)', 'RTI ($15,000)'));
        taiLevels.add(new SelectOption ('RTI ($20,000)', 'RTI ($20,000)'));
        taiLevels.add(new SelectOption ('RTI ($25,000)', 'RTI ($25,000)'));
        taiLevels.add(new SelectOption ('RTI ($30,000)', 'RTI ($30,000)'));
        mvLevels = new List <SelectOption> ();
        mvLevels.add(new SelectOption ('', '--None--'));
        mvLevels.add(new SelectOption ('Swan', 'Swan'));
        mvLevels.add(new SelectOption ('Club Marine', 'Club Marine'));
        mvLevels.add(new SelectOption ('AIC/Eric', 'AIC/Eric'));

        productGoodsTypes = new List <SelectOption> ();
        productGoodsTypes.add(new SelectOption ('Car', 'Car'));
        productGoodsTypes.add(new SelectOption ('Motorbike', 'Motorbike'));
        productGoodsTypes.add(new SelectOption ('Boat', 'Boat'));
        productGoodsTypes.add(new SelectOption ('Jet Ski', 'Jet Ski'));
        productGoodsTypes.add(new SelectOption ('Caravan', 'Caravan'));
        productGoodsTypes.add(new SelectOption ('Truck', 'Truck'));
        productGoodsTypes.add(new SelectOption ('Equipment', 'Equipment'));
        
        

        //Lelo              2016-12-22
        productGoodsType = productGoodsTypes.get(0).getValue();
        customerProfile = profileTypes.get(0).getValue();
        loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        loanType = loanTypeOptions.get(0).getValue();
        productLoanTypes = QuotingToolHelper.getLoanProductOptions();
        productLoanType = productLoanTypes.get(0).getValue();
        //-

        

        preLoadQuotingValues();
		
        this.premium = 0.00;
    }
    
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'ACON'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.customerProfile = lender.customerProfile;
                    this.adverseCredit = lender.adverseCredit;
                    this.ltv = lender.ltv;
                    this.productGoodsType = lender.productGoodsType;
                    this.productLoanType = lender.productLoanType;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
                    //Lelo                          2017-12-12
                    this.vehicleCondition = lender.condition;
                    if (lender.carAge != null) {
                        this.vehicleAge = String.valueOf(lender.carAge);
                    }
                    //
                    baseRateCalc();
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }

    public void baseRateCalc () {
        realtimeNafCalc();
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.ltv = ltv;
        param.customerProfile = customerProfile;
        param.term = term;
        param.adverseCredit = adverseCredit;
        param.condition = vehicleCondition;
        baseRate = QuotingCalculation.getBaseRate(param);        
    } //end of funcion

    public void realtimeNafCalc () {
        netDepositCalc();
        realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
    } //end of funcion
    
    public void validation () {
        if (paymentType == 'Advance') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You have chosen advance payment method for a consumer loan.'));
        }
    } //end of funcion
    
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

        return r;
    }
    
    private Boolean isValidationOk() {
        Boolean r = true;
        
        // validation before calculation
        if (clientRate == null || clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }
        if (baseRate == null || baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please adjust term, customer profile, ltv, and adverse credit file to choose proper Base Rate.'));
            r = false;
        } else if (clientRate > 0) {
            if (clientRate < baseRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be below that the Base Rate'));
                r = false;
            } else if (Math.abs(clientRate - baseRate) > 2) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximum rate load on an ANZ deal is 4% (Client Rate - Base Rate), current value: ' + (clientRate - baseRate) + '%'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot exceed 2% the Base Rate, current value: ' + Math.abs(baseRate - clientRate) + '%'));
                r = false;
            }
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else {
            if (term > 60 && 'Consumer Loan'.equals(productLoanType) && !'Caravan'.equals(productGoodsType)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Maximum term is 5 years (60 months) for Consumer Loans.'));
                r = false;
            }
        }
        if (ltv != null) {
            Decimal v = NumberUtils.convertToDecimal(ltv, false);
            if (v > 140) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTV > 140%.'));
            }
        }
        if (!isResidualValueOK()) {
            r = false;
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        if ('Non Property Owner - Old Car'.equals(customerProfile)) {
            if (ltv.isNumeric()) {
                Decimal ltvValue = decimal.valueOf(ltv);
                if (ltvValue > 125) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please adjust LTV value, Max. 125% for the current Customer Profile.'));
                    r = false;
                }
            }
        }
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }

    private Boolean isResidualValueOK() {
        Boolean r = true;
        Decimal v = 0;
        if (carPrice != null) v += carPrice;
        if (netDeposit != null) v -= netDeposit;
        if (term > 0 && term <= 60 && v > 0 && residualValue > 0) {
            Decimal p = null;
            if ('0'.equals(vehicleAge) || '1'.equals(vehicleAge) || '2'.equals(vehicleAge) || '3'.equals(vehicleAge)) {
                if (term > 0 && term <= 12) {
                    p = 60;
                } else if (term > 12 && term <= 24) {
                    p = 55;
                } else if (term > 24 && term <= 36) {
                    p = 50;
                } else if (term > 36 && term <= 48) {
                    p = 40;
                } else if (term > 48 && term <= 60) {
                    p = 30;
                }
            //} else if ('1'.equals(vehicleAge)) {
            } else {
                if (term > 0 && term <= 12) {
                    p = 50;
                } else if (term > 12 && term <= 24) {
                    p = 40;
                } else if (term > 24 && term <= 36) {
                    p = 30;
                } else if (term > 36 && term <= 48) {
                    p = 15;
                } else if (term > 48 && term <= 60) {
                    p = 0;
                }
            }
            if (p != null) {
                Decimal tmp = v * p / 100;
                if (residualValue > tmp) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Residual Value must be adjusted, the maximum balloon has been exceeded. ' + tmp.format() + ' (' + p + '%)'));
                    //r = false;
                }
            }

        }
        return r;
    }

    public PageReference calculate () {
        baseRateCalc();
        if (!isValidationOk()) {
            return null;
        }
        this.calculateRepayments();
        if (estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
        return null;
    } // end of function
    
    public PageReference reset () {
        if (lenderSettings != null) {
            this.docFees = lenderSettings.DOC_Fees__c;
            this.monthlyFee = lenderSettings.Monthly_Fee__c;
            this.ppsr = lenderSettings.PPSR__c;
            this.applicationFee = lenderSettings.Application_Fee__c;
            this.dof = lenderSettings.DOF__c;
        }
        this.carPrice = 0.00;
        //this.applicationFee = 350.00;
        //this.dof = 990.00;
        //this.ppsr = 6.80;
        this.residualValue = 0.00;
        this.clientRate = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        this.term = 60;
        this.adverseCredit = 'N';
        this.customerProfile = '';
        this.ltv = '0';
        this.ltvTmp = null;
        this.paymentType = 'Arrears';
        this.baseRate = 0.00;
        this.estimatedCommission = 0.00;
        this.insuranceIncome = 0.00;
        this.dofResult = 0.00;
        //this.docFees = 250.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        //this.monthlyFee = 5.00;
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
        //this.productLoanType = '';
        //this.productGoodsType = '';
        this.realtimeNaf = applicationFee + dof + ppsr;

        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    } // end of function
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO dto = new QuotingCalculatorDTO();
        dto.lender = 'ANZ CALCULATION';
        dto.state = state;
        dto.vehicleGroup = vehicleGroup;
        dto.awd = awd;
        dto.turbo = turbo;
        dto.diesel = diesel;

        //dto.gapLevel = gapLevel;
        //dto.gap = String.valueOf(gap);
        //dto.gapIncome = String.valueOf(gapIncome);
        //dto.nwc = String.valueOf(nwc);
        //dto.nwcIncome = String.valueOf(nwcIncome);
        //dto.warrantyLevel = warrantyLevel;
        //dto.warranty = String.valueOf(warranty);
        //dto.warrantyIncome = String.valueOf(warrantyIncome);
        //dto.ltiLevel = ltiLevel;
        //dto.lti = String.valueOf(lti);
        //dto.ltiIncome = String.valueOf(ltiIncome);
        //dto.truckGapLevel = truckGapLevel;
        //dto.truckGap = String.valueOf(truckGap);
        //dto.truckGapIncome = String.valueOf(truckGapIncome);
        //dto.taiLevel = taiLevel;
        //dto.tai = String.valueOf(tai);
        //dto.taiIncome = String.valueOf(taiIncome);
        //dto.mvLevel = mvLevel;
        //dto.mv = String.valueOf(mv);
        //dto.mvIncome = String.valueOf(mvIncome);
        ////dto.cciLevel = String.valueOf(cciLevel);
        //dto.cci = String.valueOf(cci);
        //dto.cciIncome = String.valueOf(cciIncome);

        dto.carPrice = String.valueOf(carPrice);
        
        dto.applicationFee = String.valueOf(applicationFee);
        dto.dof = String.valueOf(dof);
        dto.ppsr = String.valueOf(ppsr);
        dto.residualValue = String.valueOf(residualValue);
        dto.baseRate = String.valueOf(baseRate);
        dto.clientRate = String.valueOf(clientRate);
        dto.term = String.valueOf(term);
        dto.paymentType = paymentType;
        dto.estimatedCommission = String.valueOf(estimatedCommission);
        dto.insuranceIncome = String.valueOf(insuranceIncome);
        dto.dofResult = String.valueOf(dofResult);
        dto.totalCommission = String.valueOf(totalCommission);
        dto.totalCommissionGst = String.valueOf(totalCommissionGst);
        dto.naf = String.valueOf(naf);
        dto.rental = String.valueOf(rental);
        dto.monthlyFee = String.valueOf(monthlyFee);
        dto.monthlyPayment = String.valueOf(monthlyPayment);
        dto.fortnightlyPayment = String.valueOf(fortnightlyPayment);
        dto.weeklyPayment = String.valueOf(weeklyPayment);
        // pass variables for ANZ Consumer
        dto.adverseCredit = adverseCredit;
        dto.customerProfile = customerProfile;
        dto.ltv = String.valueOf(ltv);
        
        dto.productGoodsType = productGoodsType;
        

        dto.loanType = loanType;
        dto.productLoanType = productLoanType;
        
        if (deposit != null) {
            dto.deposit = String.valueOf(deposit);
        }
        if (tradeIn != null) {
            dto.tradeIn = String.valueOf(tradeIn);
        }
        if (payoutOn != null) {
            dto.payoutOn = String.valueOf(payoutOn);
        }
        dto.netDeposit = String.valueOf(netDeposit);

        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id',Opp.Id);
        calcPdf.getParameters().put('lender', 'ANZ CALCULATION');
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
        } else {
            calcPdf.getParameters().put('nwc', String.valueOf(0.00));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(0.00));
        }
        // Lelo         Insurance       2018-02-26
        if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('cci', String.valueOf(cci));
            calcPdf.getParameters().put('cciIncome', String.valueOf(cciIncome));
        } else {
            calcPdf.getParameters().put('cci', String.valueOf(0.00));
            calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        }
        //-

        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        calcPdf.getParameters().put('applicationFee', String.valueOf(applicationFee));
        calcPdf.getParameters().put('dof', String.valueOf(dof));
        calcPdf.getParameters().put('ppsr', String.valueOf(ppsr));
        calcPdf.getParameters().put('residualValue', String.valueOf(residualValue));
        calcPdf.getParameters().put('baseRate', String.valueOf(baseRate));
        calcPdf.getParameters().put('clientRate', String.valueOf(clientRate));
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
        // pass variables for ANZ Consumer
        calcPdf.getParameters().put('adverseCredit', adverseCredit);
        calcPdf.getParameters().put('customerProfile', customerProfile);
        calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        // pass variables about the product info
        
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('vehicleAge', vehicleAgeValues[Integer.valueOf(vehicleAge)]);
        calcPdf.getParameters().put('vehicleCondition', vehicleCondition);
        
        calcPdf.getParameters().put('loanType', dto.loanType);
        calcPdf.getParameters().put('productLoanType', dto.productLoanType);
        
        calcPdf.getParameters().put('deposit', dto.deposit);
        calcPdf.getParameters().put('tradeIn', dto.tradeIn);
        calcPdf.getParameters().put('payoutOn', dto.payoutOn);
        calcPdf.getParameters().put('netDeposit', dto.netDeposit);


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
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Storing quoting data
        saveQuotingParameters();

        //Lelo                                                                  2016-07-26
        savePdf (prefixName);

        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = 'ANZ';
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
            term = 0;
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
        
        //Lelo                      2016-07-26
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
        
        //Lelo                                                          2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    //Lelo                                                                      2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
        if (!hasCalculationDone()) {
            return null;
        }
        saveQuotingParameters();
        return savePdf(fileGlobalPrefix);
    }
    
    public PageReference savePreApproval() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
    }
    
    public PageReference updateLTVForOtherGoods() {
        if ('Truck'.equals(productGoodsType) ||
            'Boat'.equals(productGoodsType) ||
            'Caravan'.equals(productGoodsType)) {
            ltvTmp = null;
            if (ltv != null && ltv.isNumeric()) {
                ltvTmp = ltv;
            }
            ltv = 'OG1';
        } else if ('Motorbike'.equals(productGoodsType) ||
            'Jet Ski'.equals(productGoodsType)) {
            ltvTmp = null;
            if (ltv != null && ltv.isNumeric()) {
                ltvTmp = ltv;
            }
            ltv = 'OG2';
        } else {
            ltv = ltvTmp;
        }
        baseRateCalc();
        return null;
    }

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
            //Fill all form fields
            //********************************************
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
            
            d.Insurance_GAP_Type__c = null;
            d.Insurance_GAP_Retail_Price__c = null;
            d.Insurance_GAP_Income__c = null;
            d.Insurance_GAP_Acceptance__c = 'U';

            d.Insurance_TAI_Type__c = null;
            d.Insurance_TAI_Retail_Price__c = null;
            d.Insurance_TAI_Income__c = null;
            d.Insurance_TAI_Acceptance__c = 'U';

            d.Insurance_Warranty_Type__c = null;
            d.Insurance_Warranty_Retail_Price__c = null;
            d.Insurance_Warranty_Income__c = null;
            d.Insurance_Warranty_Acceptance__c = 'U';

            d.Insurance_NWC_Retail_Price__c = null;
            d.Insurance_NWC_Income__c = null;
            d.Insurance_NWC_Plan__c = null;
            d.Insurance_NWC_Term__c = null;
            d.Insurance_NWC_Cost__c = null;
            d.Insurance_NWC_Acceptance__c = 'U';

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
                if (String.isBlank(ltiAcceptance)) {
                    ltiAcceptance = 'U';
                }

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
                if (String.isBlank(nwcAcceptance)) {
                    nwcAcceptance = 'U';
                }
                // Lelo             Insurance           2018-02-26
                cci = d.Insurance_AIC_Retail_Price__c;
                cciIncome = d.Insurance_AIC_Income__c;
                cciAcceptance = d.Insurance_AIC_Acceptance__c;
                if (String.isBlank(cciAcceptance)) {
                    cciAcceptance = 'U';
                }                
                //-

                if (this.quote != null) {
                    this.quote.MV_Acceptance__c = mvAcceptance;
                    this.quote.GAP_Acceptance__c = gapAcceptance;
                    this.quote.TAS_Acceptance__c = taiAcceptance;
                    this.quote.LTI_Acceptance__c = ltiAcceptance;
                    this.quote.WRR_Acceptance__c = warrantyAcceptance;
                }
            }
            //Finance Details
            //Commons values
            loanType = d.Loan_Type__c;
            productLoanType = d.Loan_Product__c;
            carPrice = d.Vehicle_Price__c;
            
            deposit = d.Deposit__c;
            tradeIn = d.Trade_In__c;
            payoutOn = d.Payout_On__c;
            residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            if (LENDER_QUOTING.equals(d.Name) || 
                EsandaCommercialExtension.LENDER_QUOTING.equals(d.Name) ||
                EsandaOthersExtension.LENDER_QUOTING.equals(d.Name)) {
                //Specific values
                productGoodsType = d.Goods_type__c;
                
                
                if (d.Client_Rate__c != null) {
                    clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                if (!EsandaOthersExtension.LENDER_QUOTING.equals(d.Name)) {
                    vehicleAge = d.Vehicle_Age__c;
                    vehicleCondition = d.Vehicle_Condition__c;
                    adverseCredit = d.Adverse_Credit_File__c;
                    customerProfile = d.Customer_Profile__c;
                    ltv = d.LTV__c;
                }
                paymentType = d.Payment__c;
                

            }
            if (sameQuoting) {
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;    
                monthlyFee = d.Monthly_Fee__c;
                
                //Calculations
                netDepositCalc();
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
        Application_Quoting__c d = new Application_Quoting__c();
        Application_Quoting__c s = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (s != null) {
            System.debug('Setting the Quoting Id... for app >> ' + this.Opp.Application__c);
            d.Id = s.Id; 
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
        // Lelo             Insurance           2018-02-26
        d.Insurance_AIC_Retail_Price__c = cci;
        d.Insurance_AIC_Income__c = cciIncome;
        d.Insurance_AIC_Acceptance__c = cciAcceptance;
        //-
         //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Goods_type__c = productGoodsType;
        d.Vehicle_Age__c = vehicleAge;
        d.Vehicle_Condition__c = vehicleCondition;
        d.Vehicle_Price__c = carPrice;
        d.Deposit__c = deposit;
        d.Trade_In__c = tradeIn;
        d.Payout_On__c = payoutOn;
        
        d.Application_Fee__c = applicationFee;
        d.DOF__c = dof;
        d.PPSR__c = ppsr;
        d.Residual_Value__c = residualValue;
        d.Base_Rate__c = baseRate;
        d.Client_Rate__c = clientRate;

        d.Monthly_Fee__c = monthlyFee;

        //Loan Details
        if (term != null) {
            d.Term__c = Decimal.valueOf(term);
        }
        d.Adverse_Credit_File__c = adverseCredit;
        d.Customer_Profile__c = customerProfile;
        d.LTV__c = ltv;
        d.Payment__c = paymentType;

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

        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
        //Lelo                  Insurance               2017-12-04
        this.quoting = d;
        //--

        //save Insurance quote
        if (this.quote != null && this.quote.Id != null) {
            update this.quote;
        }
    }
    //-
    
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
            (nwc != null && nwc > 0) ||
            (cci != null && cci > 0)) {
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
                //Validations
                if (!isValidationOk()) {
                    putUserMessage(ApexPages.Severity.ERROR, 'Please save a Quoting before sending a presentation.');
                    return;
                }
                //Recalculate
                calculate();
                
                //Lelo                      2016-12-22
                //Save calculation
                saveQuotingParameters();
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
                saveQuotingParameters();
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
        Boolean r  = true; 
        if (!isValidationOk()) {
            putUserMessage(ApexPages.Severity.ERROR, 'Please save a Quoting before sending a presentation.');
            r  =false;
        }
        //if (!isFullyInsProductReady()) {
        //    putUserMessage(ApexPages.Severity.ERROR, 'GAP (RTI), LTI (LPI) and any warranty product should be completed and calculated to continue with this functionality');
        //    //putUserMessage(ApexPages.Severity.ERROR, 'VEI, LPI and any warranty product should be completed and calculated to continue with this functionality');
        //    r = false;
        //}
        //Check for Warranty insurance product
        //if (this.quoting != null && !this.quoting.Has_Warranty__c) {
        //if (this.quoting != null && String.isBlank(this.quoting.Insurance_Warranty_Type__c) && 
        //   (this.quoting.Insurance_Warranty_Retail_Price__c == null || this.quoting.Insurance_Warranty_Retail_Price__c == 0.0)) {
        //    if (nwcCost == null || nwcCost == 0.0) {
        //        putUserMessage(ApexPages.Severity.ERROR, 'Please select a NWC Warranty product due to a Warranty product has not been quoted.');
        //        r  = false;
        //    } else {
        //        if (this.nwcIncome < 0) {
        //            putUserMessage(ApexPages.Severity.ERROR,'The National Warranty commission is below zero, please check the Retail Price.');
        //            return false;
        //        }
        //    }
        //}
        //// Lelo             Insurance               2018-02-06
        if (this.quoting != null && String.isBlank(this.quoting.Insurance_LTI_Type__c) && 
           (this.quoting.Insurance_LTI_Retail_Price__c == null || this.quoting.Insurance_LTI_Retail_Price__c == 0.0)) {
            if (cci == null || cci == 0.0) {
                putUserMessage(ApexPages.Severity.ERROR, 'Please fill a retail price for CCI -  AIC/Eric product due to a LTI product has not been quoted.');
                r  = false;
            }
        }
        //-
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
        if (!isValidationOk()) {
            return null;
        }
        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        saveQuotingParameters();
        //-

        //
        PageReference n = Page.InsuranceQuoteStep1;
        n.getParameters().put('id', this.Opp.Id);
        return n;
    }

    public PageReference buyPolicy() {
        if (String.isBlank(this.opp.Application__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
            return null;
        }

        //Validations
        if (!isValidationOk() || !isAnInsuranceProductAccepted()) {
            return null;
        }

        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        saveQuotingParameters();
        //-
        
        PageReference n = Page.InsuranceBuyPolicyStep1;
        n.getParameters().put('id', this.opp.Id);
        return n;
        //return null;
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is not any Eric product accepted to proceed with.'));
        }

        return r;
    }

    public void nationalWarrantyCalc() {
        this.nwcCost = QuotingToolHelper.getNationalWarrantyCost(this.nwcPlan, this.nwcTerm);
        //this.nwcIncome = 0.0;
        if (this.nwc != null && this.nwcCost > 0 && (this.nwcIncome == null || this.nwcIncome==0)) {
            this.nwcIncome = this.nwc - this.nwcCost;
            if (this.nwcIncome < 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty commission is below zero, please check the Retail Price.'));       
            }
        }
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
            ((warranty != null && warranty > 0) || (nwc != null && nwc > 0))) {
            r = true;
        }
        return r;
    }
        
    private Boolean isStandardInsProductReady()  {
        Boolean r = false;
        if (((gap != null && gap > 0) || (tai != null && tai > 0)) &&
            ((warranty != null && warranty > 0) || (nwc != null && nwc > 0))) {
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
        //System.debug('INSURANCE >> ' + insuranceInputMode + ' | ' + this.quoting.Has_Warranty__c);
        if ('A'.equals(insuranceInputMode)) {
            if (this.quoting != null && String.isNotBlank(warrantyLevel)) {
                //r = this.quoting.Has_Warranty__c;
                r = true;
            }
        }
        return r;
    }

    public Boolean getDisplayNwcInsurance() {
        //Boolean r = false;
        //if (this.quote != null && this.quote.Id != null) {
        //    if (String.isBlank(warrantyLevel)) {
        //        r  = true;
        //    }
        //}
        //return r;
        return false;
    }
    //-  Insurance              
    
    //Lelo                      2017-07-21
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidationOk();
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
        if (hasCalculationDone()) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone()) {
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
        }
        if (applicationFee != null) r += applicationFee;
        if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        if (netDeposit != null) r -= netDeposit;
        r += this.getTotalInsuranceType(calcType);

        return r;
    }

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
            r = getGapTai();
            //Lelo                  Insurance           2018-02-26
            r += getLtiCci();
            //-
            r += getWarrNwc();
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
            if (nwc != null) r += nwc;
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
            if (cci != null) r += cci;
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
            r += getGapTaiIncome();
            //Lelo          Insurance               2018-02-26
            r += getLtiCciIncome();
            //-
            r += getWarrNwcIncome();
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
            if (nwcIncome != null) r += nwcIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
            if (cciIncome != null) r += cciIncome;
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
        param.clientRate = clientRate;
        param.baseRate = baseRate;
        param.paymentType = paymentType;
        param.term = term;
        param.dof = dof;
        param.monthlyFee = monthlyFee;
        param.docFees = docFees;
        param.residualValue = residualValue;
        param.customerProfile = customerProfile;
        param.condition = vehicleCondition;
        param.goodsType = productGoodsType;
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

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
                param.totalAmount = getTotalAmount(quotingType);
                param.totalInsurance = this.getTotalInsuranceType(key);
                param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
                r = QuotingCalculation.calculate(param);
                if (r != null) {
                    r.Result_Type__c = key;   
                }
                calResults.put(key, r);                
            }
        //}
        //-
        
        //Protected
        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);
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
            if (String.isBlank(ltiLevel)) {
                r  = true;
            }
        }
        return r;
    }
    public void acceptQuoteCCI() {
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
    public List<Insurance_Failure_Reason__c> getInsuranceFailureReasons() {
        List<Insurance_Failure_Reason__c> r = new List<Insurance_Failure_Reason__c>();
        if (this.quote != null && this.quote.Id != null) {
            return InsuranceQuoteUtils.getInsuranceFailureReasons(this.quote.Id);
        }
        return r;
    }
    
    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 01/07/2018*/
    public List <SelectOption> getCoverOptionSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption('','--None--'));
        for (String value : coverOptions) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
        
    public void ericLPICalculate(){
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = coverOption;
        parameters.term = MATH.round(this.term/12);
        parameters.initialAmount = this.realtimeNaf;
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        
        this.premium = results.premium;
    }
}