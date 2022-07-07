public class LibertyOptionsExtension {
    public Custom_Opportunity__c Opp;
	
	//Lelo					2016-07-26
    private String fileGlobalPrefix = 'Liberty_Options';
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
    
    public Integer term {get;set;}
    public String rateOption {get;set;}
    public String paymentType {get;set;}
    public String loanTypeDetail {get;set;}
    public Integer vehicleAge {get;set;}
    
    //public List <SelectOption> termTypes {get;set;}
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> paymentTypes {get;set;}
    public List <SelectOption> loanTypes {get;set;}
    public List <SelectOption> vehicleAges {get;set;}
    public List <SelectOption> rateOptions {get;set;}
    
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
    public Decimal nwc {get;set;}
    public Decimal nwcIncome {get;set;}
    public Decimal warranty {get;set;}
    public Decimal warrantyIncome {get;set;}
    public String warrantyLevel {get;set;}
    public Decimal isp {get;set;}
    public Decimal ispIncome {get;set;}
    public Decimal fpa {get;set;}
    public Decimal fpaIncome {get;set;}
    public Decimal vei {get;set;}
    public Decimal veiIncome {get;set;}
    public String veiLevel {get;set;}
    public Decimal lpi {get;set;}
    public Decimal lpiIncome {get;set;}
    public String lpiLevel {get;set;}
    public Decimal mv {get;set;}
    public Decimal mvIncome {get;set;}
    public String mvLevel {get;set;}
    
    public List <SelectOption> warrantyLevels {get;set;}
    public List <SelectOption> veiLevels {get;set;}
    public List <SelectOption> lpiLevels {get;set;}
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
    Public List <LibertyOptions__c> libertyRates {get;set;}
    Map <String,LibertyOptions__c> LibertyOptionsRates {get;set;}
    
    //LibertyOptions Extra
    Public Decimal riskFee {get;set;}
    
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
    public static final String LENDER_QUOTING = 'Liberty Options';
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    public Decimal netDeposit {get;set;}
    public String loanType {get;set;}                       
    public List <SelectOption> loanTypeOptions {get;set;}      
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;        
    //Lelo                                      2017-07-24
    public Boolean monthlyFeeChanged {get;set;}                       
    //-
    
    //Lelo                  Insurance                       2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String insuranceInputMode {set;get;}

    public String nwcPlan {get;set;}
    public String nwcTerm {get;set;}
    public Decimal nwcCost {get;set;}
    public String nwcAcceptance {get;set;}
    public String mvAcceptance {get;set;}
    public String warrantyAcceptance {get;set;}
    public String quoteIdSelected {get;set;}

    public Map<ApexPages.severity, List<String>> userMgs {set; get;}

    public String veiAcceptance {get;set;}
    public String lpiAcceptance {get;set;}
    //-
    //HJ - Liberty API - I
    public Boolean isCalculateUpdate {set; get;}
    public LibertyApplicationService libertyService;
    public String libertyAPI_Status {set; get;}
    public String libertyAPI_AppNumber {set; get;}
    public String libertyAPI_ResponseContent {set; get;}
    public String libertyAPI_lastResponseApp {set; get;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public String apiUser {get;set;}
    public Boolean paramActive {set; get;}
    //HJ - Liberty API -F
    
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
    
    //NWC Calculator - HJ - 12-07-2018 - F
    
    private Lenders__c lenderSettings {set;get;}

    public LibertyOptionsExtension (ApexPages.StandardController controller) {
        //HJ - Liberty API -I
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);
        //HJ - Liberty API - F
        
        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam = new NWCCalc.Parameter();
        //NWC Calculator - HJ - 12-07-2018 - F
        
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);

        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        //Lelo          Insurance           2017-12-04
        insuranceInputMode = 'A';
        //-
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%Liberty_Options%'];
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.monthlyFeeChanged = false;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
        this.calcDOF();
        //this.dof = 1000;
        this.riskFee = 0.00;
        this.baseRate = 0.00;
        this.term = 60;
        this.paymentType = 'Arrears';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.isp = 0.00;
        this.ispIncome = 0.00;
        this.fpa = 0.00;
        this.fpaIncome = 0.00;
        //this.realtimeNaf = applicationFee + dof + ppsr + isp + fpa;
        this.realtimeNafCalc();
        
        this.resetCalculationResult(); //Lelo       2017-07-25

        //estimatedCommission = 0.00;
        //dofResult = 0.00;
        //totalCommission = 0.00;
        //insuranceIncome = 0.00;
        //totalCommissionGst = 0.00;
        //naf = 0.00;
        //rental = 0.00;
        //monthlyPayment = 0.00;
        //fortnightlyPayment = 0.00;
        //weeklyPayment = 0.00;
        
        LibertyOptionsRates = LibertyOptions__c.getAll();
        System.debug('The map value: ' + LibertyOptionsRates);
        libertyRates = LibertyOptionsRates.values();
        libertyRates.sort();
        
        yesNoOptions = new List <SelectOption> ();
        yesNoOptions.add(new SelectOption ('', '--None--'));
        yesNoOptions.add(new SelectOption ('Y', 'Yes'));
        yesNoOptions.add(new SelectOption ('N', 'No'));
        loanTypes = new List <SelectOption> ();
        loanTypes.add(new SelectOption ('', '--None--'));
        loanTypes.add(new SelectOption ('Consumer', 'Consumer'));
        loanTypes.add(new SelectOption ('Commercial Star', 'Commercial Star'));
        loanTypes.add(new SelectOption ('Commercial Nova', 'Commercial Nova'));
        rateOptions = new List <SelectOption> ();
        rateOptions.add(new SelectOption ('', '--None--'));
        rateOptions.add(new SelectOption ('AA', 'AA'));
        rateOptions.add(new SelectOption ('A', 'A'));
        rateOptions.add(new SelectOption ('B', 'B'));
        rateOptions.add(new SelectOption ('C', 'C'));
        vehicleAges = new List <SelectOption> ();
        vehicleAges.add(new SelectOption ('', '--None--'));
        vehicleAges.add(new SelectOption ('0', '0'));
        vehicleAges.add(new SelectOption ('1', '1'));
        vehicleAges.add(new SelectOption ('2', '2'));
        vehicleAges.add(new SelectOption ('3', '3'));
        vehicleAges.add(new SelectOption ('4', '4'));
        vehicleAges.add(new SelectOption ('5', '5'));
        vehicleAges.add(new SelectOption ('6', '6'));
        vehicleAges.add(new SelectOption ('7', '7'));
        paymentTypes = new List <SelectOption> ();
        paymentTypes.add(new SelectOption ('', '--None--'));
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
        veiLevels = new List <SelectOption> ();
        veiLevels.add(new SelectOption ('', '--None--'));
        veiLevels.add(new SelectOption ('Option 1', 'Option 1'));
        veiLevels.add(new SelectOption ('Option 2', 'Option 2'));
        veiLevels.add(new SelectOption ('Option 3', 'Option 3'));
        veiLevels.add(new SelectOption ('Option 4', 'Option 4'));
        lpiLevels = new List <SelectOption> ();
        lpiLevels.add(new SelectOption ('', '--None--'));
        lpiLevels.add(new SelectOption ('Life Only', 'Life Only'));
        lpiLevels.add(new SelectOption ('Disability Only', 'Disability Only'));
        lpiLevels.add(new SelectOption ('Life & Disability', 'Life & Disability'));
        lpiLevels.add(new SelectOption ('Disability & Unemployment', 'Disability & Unemployment'));
        lpiLevels.add(new SelectOption ('Life, Disability & Unemployment', 'Life, Disability & Unemployment'));
        mvLevels = new List <SelectOption> ();
        mvLevels.add(new SelectOption ('', '--None--'));
        mvLevels.add(new SelectOption ('Swan', 'Swan'));
        mvLevels.add(new SelectOption ('Club Marine', 'Club Marine'));
        mvLevels.add(new SelectOption ('AIC/Eric', 'AIC/Eric'));
        
        productGoodsTypes = new List <SelectOption> ();
        //productGoodsTypes.add(new SelectOption ('', '--None--'));
        productGoodsTypes.add(new SelectOption ('Car', 'Car'));
        productGoodsTypes.add(new SelectOption ('Motorcycle', 'Motorcycle'));
        productGoodsTypes.add(new SelectOption ('Boat', 'Boat'));
        productGoodsTypes.add(new SelectOption ('Caravan', 'Caravan'));
        productGoodsTypes.add(new SelectOption ('Truck', 'Truck'));
        productGoodsTypes.add(new SelectOption ('Equipment', 'Equipment'));

        //Lelo              2016-12-22
        productGoodsType = productGoodsTypes.get(0).getValue();
        loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        loanType = loanTypeOptions.get(0).getValue();
        productLoanTypes = QuotingToolHelper.getLoanProductOptions();
        productLoanType = productLoanTypes.get(0).getValue();
        //-

        preLoadQuotingValues();
        
        //HJ - Liberty API
        libertyService = new LibertyApplicationService();
        isCalculateUpdate = false;
        usersAPIOptions = LibertyServiceManager.getUserOptionsConnect();
        
        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
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
                if (lender != null && lender.info != null && 'LIOP'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productGoodsType = lender.productGoodsType;
                    this.productLoanType = lender.productLoanType;
                    this.loanTypeDetail = lender.loanType;
                    this.rateOption = lender.rateOption;
                    this.vehicleAge = lender.carAge;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
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
        Decimal originalRate = 0;
        if (loanTypeDetail == 'Consumer') {
            if (rateOption == 'AA') {
                if (vehicleAge < 5) {
                    originalRate = 17.99;
                } else if (vehicleAge >= 5) {
                    originalRate = 17.99 + 1.50;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'A') {
                if (vehicleAge < 5) {
                    originalRate = 21.99;
                } else if (vehicleAge >= 5) {
                    originalRate = 21.99 + 2.00;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'B') {
                if (vehicleAge < 5) {
                    originalRate = 25.99;
                } else if (vehicleAge >= 5) {
                    originalRate = 25.99 + 3.00;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'C') {
                if (vehicleAge < 5) {
                    originalRate = 29.90;
                } else if (vehicleAge >= 5) {
                    originalRate = 29.90 + 4.00;
                } //else {
                //    originalRate = 0;
                //}
            } else {
                originalRate = 0;
            }
        } else if (loanTypeDetail == 'Commercial Star') {
            if (rateOption == 'AA') {
                if (vehicleAge < 5) {
                    //originalRate = 16.99;
                    originalRate = 15.99;
                } else if (vehicleAge >= 5) {
                    //originalRate = 16.99 + 1.50;
                    originalRate = 15.99 + 1.50;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'A') {
                if (vehicleAge < 5) {
                    originalRate = 24.74;
                } else if (vehicleAge >= 5) {
                    originalRate = 24.74 + 2.00;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'B') {
                if (vehicleAge < 5) {
                    originalRate = 29.24;
                } else if (vehicleAge >= 5) {
                    originalRate = 29.24 + 3.00;
                } //else {
                //    originalRate = 0;
                //}
            } else if (rateOption == 'C') {
                if (vehicleAge < 5) {
                    originalRate = 29.90;
                } else if (vehicleAge >= 5) {
                    originalRate = 29.90 + 4.00;
                } //else {
                //    originalRate = 0;
                //}
            } else {
                originalRate = 0;
            }
        } else if (loanTypeDetail == 'Commercial Nova') {
            if (rateOption == 'AA') {
                if (vehicleAge < 5) {
                    //originalRate = 17.24;
                    originalRate = 16.24;
                } else if (vehicleAge >= 5) {
                    //originalRate = 17.24 + 1.50;
                    originalRate = 16.24 + 1.50;
                } //else {
                //    originalRate = 0;
                //}
            } else {
                originalRate = 0;
            }
        } else {
            originalRate = 0;
        }
        baseRate = originalRate - 10;
        if (baseRate <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please adjust the loan type, loan options and vehicle age to make a meaningful base rate.'));
        } else {
            if (residualValue != null && residualValue > 0) {
                baseRate += 0.1;
            }
        }
    } //end of funcion
        
    public void realtimeNafCalc () {
        netDepositCalc();
        this.calcDOF();
        riskFeeCalc();
        realtimeNaf = 0;
        //if (carPrice != null) realtimeNaf += carPrice;
        //if (applicationFee != null) realtimeNaf += applicationFee;
        //if (dof != null) realtimeNaf += dof;
        //if (ppsr != null) realtimeNaf += ppsr;
        //if (riskFee != null) realtimeNaf += riskFee;
        //if (netDeposit != null) realtimeNaf -= netDeposit;
        realtimeNaf += getTotalAmount(QuotingCalculation.CALC_QUOTING);
        realtimeNaf += getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        System.debug('monthlyFeeChanged >> ' + this.monthlyFeeChanged);
        if (!this.monthlyFeeChanged) {
            if (realtimeNaf < 10000) {
                this.monthlyFee = 15;
            } else {
                this.monthlyFee = 10;
            }
        }
        this.calculateLPI();
    } //end of funcion
    
    public void changeMonthlyFeeManually() {
        this.monthlyFeeChanged = true;
    }

    public void validation () {
        if (clientRate > 29.90) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be higher than the highest Base Rate plus 10%.'));
        }
    } //end of funcion
    
    private Decimal riskFeeBase() {
        return getRiskFeeBase(QuotingCalculation.CALC_QUOTING);
    }
    
    private Decimal getRiskFeeBase(String calcType) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (netDeposit != null) r -= netDeposit;
        //r += getTotalInsuranceType(null);
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            if ('A'.equals(nwcAcceptance) && nwc != null) r += nwc;
            if ('A'.equals(warrantyAcceptance) && warranty != null) r += warranty;
            if ('A'.equals(mvAcceptance) && mv != null) r += mv;
        }
        return r;
    }

    public void riskFeeCalc () {
        riskFee = getRiskFeeCalc(QuotingCalculation.CALC_QUOTING);
    }

    public Decimal getRiskFeeCalc(String calcType) {
        Decimal r = 0.0;
        Decimal base = getRiskFeeBase(calcType);
        if (rateOption == 'AA') {
            r = 0;
        } else if (rateOption == 'A') {
            r = 0.075 * base;
        } else if (rateOption == 'B') {
            r = 0.09 * base;
        } else if (rateOption == 'C') {
            r = 0.10 * base;
        } else {
            r = 0;
        }
        r = r.setScale(2);
        return r;
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
        //if (!isValidInsuranceInfo(gapLevel, gap, gapIncome)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Gap insurance product.'));
        //    r = false;
        //}
        // Warranty Insurance
        if (!isValidInsuranceInfo(warrantyLevel, warranty, warrantyIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Warranty insurance product.'));
            r = false;
        }
        // ISP Insurance
        if (!isValidInsuranceInfo(isp, ispIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for ISP insurance product.'));
            r = false;
        }
        // FPA Insurance
        if (!isValidInsuranceInfo(fpa, fpaIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for FPA insurance product.'));
            r = false;
        }
        // VEI Insurance
        if (!isValidInsuranceInfo(veiLevel, vei, veiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for VEI insurance product.'));
            r = false;
        }
        // LPI Insurance
        if (!isValidInsuranceInfo(lpiLevel, lpi, lpiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for LPI insurance product.'));
            r = false;
        }
        // MV Insurance
        if (!isValidInsuranceInfo(mvLevel, mv, mvIncome, true)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for MV insurance product.'));
            r = false;
        }
        // CCI Insurance
        //if (!isValidInsuranceInfo(cci, cciIncome)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for CCI insurance product.'));
        //    r = false;
        //}
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

    private Boolean isValidationOk() {
        Boolean r = true;
        // validation before calculation
        if (clientRate == null || clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }
        if (baseRate == null || baseRate == 0.0 || baseRate < 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please adjust the loan type, loan options and vehicle age to make a meaningful base rate..'));
            r = false;
        }
        Double maxAppFee = this.lenderSettings.Application_Fee__c + this.lenderSettings.DOF__c;
        if (this.applicationFee == null || this.applicationFee < this.lenderSettings.Application_Fee__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application fee cannot fall below $' + this.lenderSettings.Application_Fee__c.format()));
            r = false;
        } else if (this.applicationFee > maxAppFee) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The application fee cannot exceed $' + maxAppFee.format()));
            r = false;
        }
        if (this.dof == null || this.dof < this.lenderSettings.DOF__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF is less than maximum $' + this.lenderSettings.DOF__c.format()));
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else {
            if ('A'.equals(rateOption) || 'B'.equals(rateOption) || 'C'.equals(rateOption)) {
                if (term > 60) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term. Term cannot exceed 5 years on A, B and C risk grades.'));
                    r = false;
                }
            }
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }

    public PageReference calculate () {      
        riskFeeCalc();
        calculateLPI();
        realtimeNafCalc();
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
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.carPrice = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
        this.calcDOF();
        //this.dof = 1000;
        this.riskFee = 0.00;
        this.residualValue = 0.00;
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.term = 60;
        this.loanTypeDetail = '';
        this.rateOption = '';
        this.paymentType = 'Arrears';
        this.vehicleAge = null;
        this.estimatedCommission = 0.00;
        this.insuranceIncome = 0.00;
        this.dofResult = 0.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        //this.monthlyFee = 10.00;
        this.monthlyPayment = 0.00;
        this.fortnightlyPayment = 0.00;
        this.weeklyPayment = 0.00;
        //Insurance Products
        this.mvLevel = null;
        this.mv = 0.00;
        this.mvIncome = 0.00;
        this.mvAcceptance = 'U';

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
        this.isp = 0.00;
        this.ispIncome = 0.00;
        this.fpa = 0.00;
        this.fpaIncome = 0.00;

        this.veiLevel = '';
        this.vei = 0.00;
        this.veiIncome = 0.00;
        this.veiAcceptance = 'U';

        this.lpiLevel = '';
        this.lpi = 0.00;
        this.lpiIncome = 0.00;
        this.lpiAcceptance = 'U';
        
        this.quoteIdSelected = null;
        this.quote = new Application_InsuranceQuote__c();

        //- 
        
        this.state = '';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.productGoodsType = '';
        //this.realtimeNaf = applicationFee + dof + ppsr + isp + fpa;
        this.realtimeNafCalc();

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
        dto.lender = 'LIBERTY OPTIONS CALCULATION';
        dto.state = state;
        dto.vehicleGroup = vehicleGroup;
        dto.awd = awd;
        dto.turbo = turbo;
        dto.diesel = diesel;
        //dto.nwc = String.valueOf(nwc);
        //dto.nwcIncome = String.valueOf(nwcIncome);
        //dto.warrantyLevel = warrantyLevel;
        //dto.warranty = String.valueOf(warranty);
        //dto.warrantyIncome = String.valueOf(warrantyIncome);
        //dto.isp = String.valueOf(isp);
        //dto.ispIncome = String.valueOf(ispIncome);
        //dto.fpa = String.valueOf(fpa);
        //dto.fpaIncome = String.valueOf(fpaIncome);
        //dto.veiLevel = veiLevel;
        //dto.vei = String.valueOf(vei);
        //dto.veiIncome = String.valueOf(veiIncome);
        //dto.lpiLevel = lpiLevel;
        //dto.lpi = String.valueOf(lpi);
        //dto.lpiIncome = String.valueOf(lpiIncome);
        //dto.mvLevel = mvLevel;
        //dto.mv = String.valueOf(mv);
        //dto.mvIncome = String.valueOf(mvIncome);
        dto.isp = String.valueOf(isp);
        dto.ispIncome = String.valueOf(ispIncome);
        dto.fpa = String.valueOf(fpa);
        dto.fpaIncome = String.valueOf(fpaIncome);
        //
        dto.carPrice = String.valueOf(carPrice);
        
        dto.applicationFee = String.valueOf(this.lenderSettings.Application_Fee__c);
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
        // pass variables for Liberty Options
        dto.riskFee = String.valueOf(riskFee);
        dto.loanTypeDetail = loanTypeDetail;
        dto.rateOption = rateOption;
        dto.vehicleAge = String.valueOf(vehicleAge);
        dto.isLiberty = true;
        // pass variables about the product info
        
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
        calcPdf.getParameters().put('lender', 'LIBERTY OPTIONS CALCULATION');
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
        if ('A'.equals(veiAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('veiLevel', veiLevel);
            calcPdf.getParameters().put('vei', String.valueOf(vei));
            calcPdf.getParameters().put('veiIncome', String.valueOf(veiIncome));
        } else {
            calcPdf.getParameters().put('veiLevel', null);
            calcPdf.getParameters().put('vei', String.valueOf(0.00));
            calcPdf.getParameters().put('veiIncome', String.valueOf(0.00));
        }
        if ('A'.equals(lpiAcceptance) || 'M'.equals(insuranceInputMode)) {
            calcPdf.getParameters().put('lpiLevel', lpiLevel);
            calcPdf.getParameters().put('lpi', String.valueOf(lpi));
            calcPdf.getParameters().put('lpiIncome', String.valueOf(lpiIncome));
        } else {
            calcPdf.getParameters().put('lpiLevel', null);
            calcPdf.getParameters().put('lpi', String.valueOf(0.00));
            calcPdf.getParameters().put('lpiIncome', String.valueOf(0.00));
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
        //-
        calcPdf.getParameters().put('isp', String.valueOf(isp));
        calcPdf.getParameters().put('ispIncome', String.valueOf(ispIncome));
        calcPdf.getParameters().put('fpa', String.valueOf(fpa));
        calcPdf.getParameters().put('fpaIncome', String.valueOf(fpaIncome));
        //-
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        calcPdf.getParameters().put('applicationFee', String.valueOf(this.lenderSettings.Application_Fee__c));
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
        // pass variables for Liberty Options
        calcPdf.getParameters().put('riskFee', String.valueOf(riskFee));
        calcPdf.getParameters().put('loanTypeDetail', loanTypeDetail);
        calcPdf.getParameters().put('rateOption', rateOption);
        calcPdf.getParameters().put('vehicleAge', String.valueOf(vehicleAge));
        // pass variable for Liberty
        calcPdf.getParameters().put('isLiberty', 'true');
        // pass variables about the product info
        
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        
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
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        //Storing quoting data
        saveQuotingParameters();

        //Lelo 									2016-07-26
		savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Quoting_Source__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,
                             Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        
        if (productLoanType == 'Consumer Loan') {
            updateProduct.Loan_Purpose__c = 'Personal Use';
        } else {
            updateProduct.Loan_Purpose__c = 'Business Use';
        }
        
        updateProduct.Lender__c = 'Liberty';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = loanTypeDetail;
        
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
            updateProduct.Lender_App_Fee__c = this.lenderSettings.Application_Fee__c;
        }
        if (ppsr == null || ppsr == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
            if (riskFee == null || riskFee == 0) {
                updateProduct.Equalisation_Fee_PPSR__c = 0;
            } else {
                updateProduct.Equalisation_Fee_PPSR__c = riskFee;
            }
        } else {
            updateProduct.Equalisation_Fee_PPSR__c = ppsr + riskFee;
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
        // ISP Insurance
        if (isp == null || isp == 0) {
            
        } else {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'ISP';
            newInsurance.Insurance_Policy_Amount__c = isp;
            if (ispIncome == null || ispIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'ISP Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = ispIncome;
            }
            newInsurance.Insurer__c = 'Liberty Financial';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // FPA Insurance
        if (fpa == null || fpa == 0) {
            
        } else {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'FPA';
            newInsurance.Insurance_Policy_Amount__c = fpa;
            if (fpaIncome == null || fpaIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'FPA Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = fpaIncome;
            }
            newInsurance.Insurer__c = 'Liberty Financial';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // VEI Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(veiAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(veiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'VEI';
            if (vei == null || vei == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'VEI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = vei;
            }
            if (veiIncome == null || veiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'VEI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = veiIncome;
            }
            newInsurance.Insurer__c = 'Liberty Financial';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // LPI Insurance
        if (('A'.equals(insuranceInputMode) && 'A'.equals(lpiAcceptance)) || 
            ('M'.equals(insuranceInputMode) && String.isNotBlank(lpiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Loan Protection';
            if (lpi == null || lpi == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = lpi;
            }
            if (lpiIncome == null || lpiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = lpiIncome;
            }
            newInsurance.Insurer__c = 'Liberty Financial';
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
        
        //Lelo								2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    //Lelo									2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
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
        if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
            }
        }
        return null;
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
            System.debug('A quoting has been found >> ' + d.Name);
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

            mvAcceptance = 'U';
            veiAcceptance = 'U';
            lpiAcceptance = 'U';
            warrantyAcceptance = 'U';
            nwcAcceptance = 'U';

            //clear unused insurances
            d.Insurance_GAP_Type__c = null;
            d.Insurance_GAP_Retail_Price__c = null;
            d.Insurance_GAP_Income__c = null;
            d.Insurance_GAP_Acceptance__c = 'U';

            d.Insurance_LTI_Type__c = null;
            d.Insurance_LTI_Retail_Price__c = null;
            d.Insurance_LTI_Income__c = null;
            d.Insurance_LTI_Acceptance__c = 'U';

            d.Insurance_TAI_Type__c = null;
            d.Insurance_TAI_Retail_Price__c = null;
            d.Insurance_TAI_Income__c = null;
            d.Insurance_TAI_Acceptance__c = 'U';

            d.Insurance_AIC_Retail_Price__c = null;
            d.Insurance_AIC_Income__c = null;
            d.Insurance_AIC_Acceptance__c = 'U';

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

                veiLevel = d.Insurance_VEI_Type__c;
                vei = d.Insurance_VEI_Retail_Price__c;
                veiIncome = d.Insurance_VEI_Income__c;
                veiAcceptance = d.Insurance_VEI_Acceptance__c;
                if (String.isBlank(veiAcceptance)) {
                    veiAcceptance = 'U';
                }
                
                lpiLevel = d.Insurance_LPI_Type__c;
                lpi = d.Insurance_LPI_Retail_Price__c;
                lpiIncome = d.Insurance_LPI_Income__c;
                lpiAcceptance = d.Insurance_LPI_Acceptance__c;
                if (String.isBlank(lpiAcceptance)) {
                    lpiAcceptance = 'U';
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
                //-

                if (this.quote != null) {
                    this.quote.MV_Acceptance__c = mvAcceptance;
                    //this.quote.GAP_Acceptance__c = gapAcceptance;
                    //this.quote.TAS_Acceptance__c = taiAcceptance;
                    //this.quote.LTI_Acceptance__c = ltiAcceptance;
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
            netDepositCalc();
            residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            if (LENDER_QUOTING.equals(d.Name) ||
                LibertyDriveExtension.LENDER_QUOTING.equals(d.Name)) {
                
                //Insurance products
                isp = d.Insurance_ISP_Retail_Price__c;
                ispIncome = d.Insurance_ISP_Income__c;
                fpa = d.Insurance_FPA_Retail_Price__c;
                fpaIncome = d.Insurance_FPA_Income__c;
                //veiLevel = d.Insurance_VEI_Type__c;
                //vei = d.Insurance_VEI_Retail_Price__c;
                //veiIncome = d.Insurance_VEI_Income__c;
                //lpiLevel = d.Insurance_LPI_Type__c;
                //lpi = d.Insurance_LPI_Retail_Price__c;
                //lpiIncome = d.Insurance_LPI_Income__c;

                //Specific values
                productGoodsType = d.Goods_type__c;
                loanTypeDetail = d.Loan_Facility_Type__c;
                
                if (d.Client_Rate__c != null) {
                    clientRate = d.Client_Rate__c.setScale(2);
                }
                if (!String.isBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()) {
                    vehicleAge = Integer.valueOf(d.Vehicle_Age__c);
                }
                //Loan Details
                paymentType = d.Payment__c;
                
            }
            if (sameQuoting) {
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;    
                monthlyFee = d.Monthly_Fee__c;
                
                riskFee = d.Risk_Fee__c;
                rateOption = d.Rate_Options__c;

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
                riskFeeCalc();
                baseRateCalc();

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
            realtimeNafCalc();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
            
            //LibertyAPI -I - HJ
            libertyAPI_AppNumber = d.LibertyServ_AppNumber__c;
            libertyAPI_ResponseContent = d.LibertyServ_ResponseContent__c;
            libertyAPI_Status = d.LibertyServ_Status__c;
            libertyAPI_lastResponseApp = d.LibertyServ_Last_Response_Application__c ;
            //LibertyAPI -F - HJ
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
        //Liberty Insurance product
        d.Insurance_ISP_Retail_Price__c = isp;
        d.Insurance_ISP_Income__c = ispIncome;
        d.Insurance_FPA_Retail_Price__c = fpa;
        d.Insurance_FPA_Income__c = fpaIncome;
        //Insurance product
        d.Insurance_MV_Type__c = mvLevel;
        d.Insurance_MV_Retail_Price__c = mv;
        d.Insurance_MV_Income__c = mvIncome;
        d.Insurance_MV_Acceptance__c = mvAcceptance;

        d.Insurance_VEI_Type__c = veiLevel;
        d.Insurance_VEI_Retail_Price__c = vei;
        d.Insurance_VEI_Income__c = veiIncome;
        d.Insurance_VEI_Acceptance__c = veiAcceptance;
        
        d.Insurance_LPI_Type__c = lpiLevel;
        d.Insurance_LPI_Retail_Price__c = lpi;
        d.Insurance_LPI_Income__c = lpiIncome;
        d.Insurance_LPI_Acceptance__c = lpiAcceptance;
        
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
        
        //clear unused insurances
        d.Insurance_GAP_Type__c = null;
        d.Insurance_GAP_Retail_Price__c = null;
        d.Insurance_GAP_Income__c = null;
        d.Insurance_GAP_Acceptance__c = 'U';

        d.Insurance_LTI_Type__c = null;
        d.Insurance_LTI_Retail_Price__c = null;
        d.Insurance_LTI_Income__c = null;
        d.Insurance_LTI_Acceptance__c = 'U';

        d.Insurance_TAI_Type__c = null;
        d.Insurance_TAI_Retail_Price__c = null;
        d.Insurance_TAI_Income__c = null;
        d.Insurance_TAI_Acceptance__c = 'U';

        d.Insurance_AIC_Retail_Price__c = null;
        d.Insurance_AIC_Income__c = null;
        d.Insurance_AIC_Acceptance__c = 'U';
        //-
         //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Goods_type__c = productGoodsType;
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
        
        d.Payment__c = paymentType;
        if (vehicleAge != null) {
            d.Vehicle_Age__c = String.valueOf(vehicleAge);
        } else {
            d.Vehicle_Age__c = null;
        }
        d.Loan_Facility_Type__c = loanTypeDetail;
        d.Risk_Fee__c = riskFee;
        d.Rate_Options__c = rateOption;

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

    public void acceptQuoteVEI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(veiAcceptance)) {
            veiAcceptance = 'U';
        } else {
            veiAcceptance = 'A';
        }
        this.realtimeNafCalc();
    }

    public void acceptQuoteLPI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(lpiAcceptance)) {
            lpiAcceptance = 'U';
        } else {
            lpiAcceptance = 'A';
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

    public void declineQuoteVEI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(veiAcceptance)) {
            veiAcceptance = 'U';
        } else {
            veiAcceptance = 'D';
        }
        this.realtimeNafCalc();
    }

    public void declineQuoteLPI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(lpiAcceptance)) {
            lpiAcceptance = 'U';
        } else {
            lpiAcceptance = 'D';
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
            (vei != null && vei > 0) ||
            (lpi != null && lpi > 0) ||
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
        } else if (!isFullyInsProductReady()) {
            putUserMessage(ApexPages.Severity.ERROR, 'VEI, LPI and any warranty product should be completed and calculated to continue with this functionality');
            r = false;
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
        if (!isValidationOk()) {
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
        if (!isValidationOk() || !isAnInsuranceProductAccepted()) {
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
        } else if ('A'.equals(this.quote.WRR_Acceptance__c)) {
            r = true;
        }
        if (!r) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Any Eric Insurance Product has been accepted.'));
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
        if ((vei != null && vei > 0) &&
            (lpi != null && lpi > 0) &&
            ((warranty != null && warranty > 0) || (nwc != null && nwc > 0))) {
            r = true;
        }
        return r;
    }
        
    private Boolean isStandardInsProductReady()  {
        Boolean r = false;
        if ((vei != null && vei > 0) &&
            ((warranty != null && warranty > 0) || (nwc != null && nwc > 0))) {
            r = true;
        }
        return r;
    }

    private Boolean isBasicInsProductReady()  {
        Boolean r = false;
        if (vei != null && vei > 0)  {
            r = true;
        }
        return r;
    }
    //- 
    
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
        //Decimal pDep = 0;
        //if (carPrice != null && carPrice > 0) {
        //    pDep = netDeposit / carPrice * 100;
        //}
        //if (pDep >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
        //    r = true;
        //}
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
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(warrantyLevel)) {
                r  = true;
            }
        }
        return r;
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
        //if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        if (riskFee != null) r += getRiskFeeCalc(calcType);
        if (netDeposit != null) r -= netDeposit;
        
        return r;
    }

    private Decimal getTotalInsuranceType(String calcType) {
        Decimal r = 0.0;
        //if (nwc != null) r += nwc;
        //if (isp != null) r += isp;
        //if (warranty != null) r += warranty;
        //if (fpa != null) r += fpa;
        //if (vei != null) r += vei;
        //if (mv != null) r += mv;
        //if (lpi != null) r += lpi;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            //Quote Insurances
            //if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
            //    if (mv != null) r += mv;
            //}
            if ('A'.equals(veiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (vei != null) r += vei;
            }
            if ('A'.equals(lpiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (lpi != null) r += lpi;
            }
            if ('A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (warranty != null) r += warranty;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwc != null) r += nwc;    
            }
        } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            r = vei;
            //Lelo                  Insurance           2018-02-26
            Decimal warr = getWarrNwc();
            if (!'A'.equals(warrantyAcceptance)) {
                QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
                param.totalAmount = this.getLPITotalAmount();
                param.totalAmount += warr;
                param.lpiLevel = lpiLevel;
                param.state = this.Opp.Application__r.State__c;
                param.term = term;
                QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
                r += p.premium;
            } else {
                r += lpi;
            }
            r += warr;
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r = vei;
            //Lelo                  Insurance           2018-02-26
            r += getWarrNwc();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r = vei;
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            //if (mv != null) r += mv;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (vei != null) r += vei;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (lpi != null) r += lpi;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warranty != null) r += warranty;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (nwc != null) r += nwc;
        } else if (InsuranceQuoteUtils.INS_PROD_LPI_2.equals(calcType)) {
            Decimal warr = getWarrNwc();
            if (!'A'.equals(warrantyAcceptance)) {
                QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
                param.totalAmount = this.getLPITotalAmount();
                param.totalAmount += warr;
                param.lpiLevel = lpiLevel;
                param.state = this.Opp.Application__r.State__c;
                param.term = term;
                QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
                r += p.premium;
            } else {
                r += lpi;
            }
        }
        return r;
    }

    private Decimal getTotalInsuranceIncomeType(String calcType) {
        Decimal r = 0.0;
        //if (nwcIncome != null) r += nwcIncome;
        //if (warrantyIncome != null) r += warrantyIncome;
        //if (mvIncome != null) r += mvIncome;

        //if (ispIncome != null) r += ispIncome;
        //if (fpaIncome != null) r += fpaIncome;
        //if (veiIncome != null) r += veiIncome;
        //if (lpiIncome != null) r += lpiIncome;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (mvIncome != null) r += mvIncome;
            }
            if ('A'.equals(veiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (veiIncome != null) r += veiIncome;
            }
            if ('A'.equals(lpiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (lpiIncome != null) r += lpiIncome;
            }
            if ('A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (warrantyIncome != null) r += warrantyIncome;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwcIncome != null) r += nwcIncome;    
            }
        }else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            r += veiIncome;
            //Lelo          Insurance               2018-02-26
            Decimal warr = getWarrNwcIncome();
            if (!'A'.equals(warrantyAcceptance)) {
                QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
                param.totalAmount = this.getLPITotalAmount();
                param.totalAmount += warr;
                param.lpiLevel = lpiLevel;
                param.state = this.Opp.Application__r.State__c;
                param.term = term;
                QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
                r += p.income;
            } else {
                r += lpiIncome;
            }
            r += warr;
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r += veiIncome;
            //Lelo          Insurance               2018-02-26
            r += getWarrNwcIncome();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r += veiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            if (mvIncome != null) r += mvIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (veiIncome != null) r += veiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (lpiIncome != null) r += lpiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warrantyIncome != null) r += warrantyIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (nwcIncome != null) r += nwcIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_LPI_2.equals(calcType)) {
            Decimal warr = getWarrNwcIncome();
            if (!'A'.equals(warrantyAcceptance)) {
                QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
                param.totalAmount = this.getLPITotalAmount();
                param.totalAmount += warr;
                param.lpiLevel = lpiLevel;
                param.state = this.Opp.Application__r.State__c;
                param.term = term;
                QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
                r += p.income;
            } else {
                r += lpiIncome;
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
        param.clientRate = clientRate;
        param.baseRate = baseRate;
        param.paymentType = paymentType;
        param.term = term;
        param.dof = dof;
        param.monthlyFee = monthlyFee;
        param.residualValue = residualValue;

        param.commRate = 1;
        if (rateOption == 'AA') {
            param.commRate = 1.35;
        }

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
            if (vei != null && vei > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
            }
            //LTI
            if (lpi != null && lpi > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_LTI);
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_LPI_2);
            }
            //WARR
            if (warranty != null && warranty > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
            }
            //NWC
            if (nwc != null && nwc > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
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
    public Boolean getHasLti() {
        Boolean r = false;
        if ('A'.equals(insuranceInputMode)) {
            if (this.quoting != null && String.isNotBlank(lpiLevel)) {
                r = true;
            }
        }
        return r;
    }
    //-
    
    public void calculateVEI() {
        Liberty_VEI_Setting__c a = QuotingToolHelper.getLibertyVEISetting(this.Opp.Application__r.State__c, veiLevel);
        //System.debug(this.Opp.Application__r.State__c + '|' + veiLevel + '|' + a);
        vei = 0.00;
        veiIncome = 0.00;
        if (a != null) {
            vei = a.Retail__c;
            veiIncome = a.Commission__c;
        }
    }

    public Decimal getLPITotalAmount() {
        Decimal r = this.getTotalAmount(QuotingCalculation.CALC_QUOTING);
        if ('A'.equals(warrantyAcceptance)) {
            //Eric Insurance
            if (warranty != null) r += warranty;
        } else if ('A'.equals(nwcAcceptance)) {
            //Manual Insurances
            if (nwc != null) r += nwc;    
        }
        return r;
    }

    public void calculateLPI() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.totalAmount = this.getLPITotalAmount();
        param.lpiLevel = lpiLevel;
        param.state = this.Opp.Application__r.State__c;
        param.term = term;
        QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
        lpi = p.premium;
        lpiIncome = p.income;
    }

    public List<SelectOption> getLPIOptions() {
        return QuotingToolHelper.getLibertyLPIOptions('ALL');
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
    
    //Liberty API - I - HJ
    public PageReference libertyApplicationTest(){
        System.debug('>>>>> Response APPLICATION LIBERTY (Test) -I  <<<<<< - ');
        try{
        	LibertyServiceManager lbService = new LibertyServiceManager();
        	lbService.requestApplicationTest(opp, true, apiUser);
        	System.debug('>>>>> Response APPLICATION LIBERTY (Test) -F  <<<<<< - ');
        	return null;
        }catch(GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
    }
    
    
    public PageReference libertyApplication(){
        System.debug('>>>>> Response APPLICATION LIBERTY  -I  <<<<<< - ');
        try{
            LibertyServiceManager lbService = new LibertyServiceManager();
            LibertyApplicationResponse libertyResponse = lbService.requestApplication(opp, true, apiUser);
            if (libertyResponse != null){
                libertyAPI_Status = libertyResponse.apiResponse.status.value;
                libertyAPI_AppNumber = libertyResponse.apiResponse.applicationNumber.value;
                libertyAPI_ResponseContent = libertyResponse.apiResponse.responseContent.value;
                libertyAPI_lastResponseApp  = libertyResponse.apiResponse.lastResponseApp;
                saveAPIInformation();
            }
            System.debug('>>>>> Response APPLICATION LIBERTY  -F  <<<<<< - ');
            return null;
        }catch(GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
    }
    
    private void saveAPIInformation(){
        this.quoting.LibertyServ_AppNumber__c = libertyAPI_AppNumber;
        this.quoting.LibertyServ_ResponseContent__c = libertyAPI_ResponseContent;
        this.quoting.LibertyServ_Status__c = libertyAPI_Status;
        this.quoting.LibertyServ_Last_Response_Application__c = libertyAPI_lastResponseApp;
        update this.quoting;
    }
    //Liberty API - F - HJ

    public Boolean insuranceProductSelected() {
        Boolean r = true;
        // Lelo                 2018-08-16 
        // Accepted or declined validation
        // Motor Vehicle
        if (String.isNotBlank(this.mvLevel) && (String.isBlank(this.mvAcceptance) || 'U'.equals(this.mvAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motor Vehicle should be Accepted or Declined.'));
            r = false;
        }
        // VEI
        if (String.isNotBlank(this.veiLevel)) {
            if (String.isBlank(this.veiAcceptance) || 'U'.equals(this.veiAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'VEI should be Accepted or Declined.'));
                r = false;
            }
        }
        // LPI
        if (String.isNotBlank(this.lpiLevel)) {
            if (String.isBlank(this.lpiAcceptance) || 'U'.equals(this.lpiAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LTI should be Accepted or Declined.'));
                r = false;
            }
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
        //String asset = dto.productGoodsType;
        nwcParam.assetType = getAssetTypeOpp();
        nwcParam.state = getStateOpp();
        isCategoryType = false;
        if ('Car'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetCar = true;
        }
        if ('Boat'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetBoat = true;
            isCategoryType = true;
        }
        if ('Truck'.equalsIgnoreCase(nwcParam.assetType)){
            isCategoryType = true;
        }
        nwcParam.plan = nwcPlan;
        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType);
        NWCTermOptions = NWCCalc.NWCTermOptions(nwcParam.assetType);
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType, nwcParam.plan);
        loadCategory();
        isNWCValidationOk = true;
        //calculateNWC();
    }
    
    private void loadCategory(){
        if (NWCTypePOptions.size() <= 2){
            nwcParam.type_p = 'NWC';
            isCategoryType = false;
        }
    }
    
    public void checkManuallyNWCPrice(){
        if (priceCustomer != null){
            nwcParam.nwcPriceToCustomer = priceCustomer;
        }
        if (nwcParam.isManuallyNWCPrice){
            Decimal priceCustomer = nwcParam.nwcPriceToCustomer;
            Long iPart = (Long) priceCustomer;
            Decimal fPart = priceCustomer - iPart;
            if (fPart > 0){
                nwcParam.nwcPriceToCustomer = NumberUtils.convertDecimalToScale(priceCustomer - 0.01, 2) ;
            }
        }
        calculateNWC();
    }
    
    public void calculateNWC(){
        NWCMessage = '';
        nwcIncome = 0;
        nwc = 0;
        isNWCValidationOk = true;
        NWCMessage = '';
        nwcParam.plan = nwcPlan;
        nwcParam.term = nwcTerm;
        nwcParam.state = getStateOpp();
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType, nwcParam.plan);
        if (NWCTypePOptions.size() == 2){
            nwcParam.type_p = 'NWC';
            isCategoryType = false;
        }else{
            isCategoryType = true;
        }
        if (!StringUtils.isNullOrEmpty(nwcParam.assetType) && !StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.term) &&
            !StringUtils.isNullOrEmpty(nwcParam.type_p)){
                if (isAssetCar && (StringUtils.isNullOrEmpty(nwcParam.awd4wd) || StringUtils.isNullOrEmpty(nwcParam.luxuryCar))){
                        //NWCMessage = 'Missing values';
                        System.debug('Missing values: AWD4WD / LuxuryCar]');
                }else if (isAssetBoat && '----'.equalsIgnoreCase(nwcParam.type_p)){
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
    
    /* New code */
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
    
    //NWC Calculator - HJ - 12-07-2018 - F
    public void calcDOF() {
        if (this.applicationFee != null) {
            this.dof = this.applicationFee - lenderSettings.Application_Fee__c;
            if (this.dof < 0) this.dof = 0.00;
        } else {
            this.dof = 0.00;
        }
    }

}