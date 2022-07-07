public class EsandaCommercialExtension {
    public Custom_Opportunity__c Opp;
    
    //Lelo					2016-07-26
    private String fileGlobalPrefix = 'ANZ_Commercial';
    //-
    
    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal ppsr {get;set;}
    public Decimal residualValue {get;set;}
    public Decimal clientRate {get;set;}
    public Decimal deposit {get;set;}
    public String vehicleAge {get;set;}             //Lelo          2016-11-22
    public String[] vehicleAgeValues = new String[]{'New to <= 3 year','> 3 year to <= 7 year'};
    public List <SelectOption> vehicleAgeOptions {get;set;}

    public Integer term {get;set;}
    public String adverseCredit {get;set;}
    public String customerProfile {get;set;}
    public String ltv {get;set;}
    public String ltvTmp = null;
    public String paymentType {get;set;}
    public Decimal baseRate {get;set;}
    
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
    public List <Esanda_Commercial_Rates__c> esandaRates {get;set;}
    Map <String,Esanda_Commercial_Rates__c> esandaCommercialRates {get;set;}
    
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
    public static final String LENDER_QUOTING = 'ANZ Commercial';
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    public Decimal netDeposit {get;set;}
    public String loanType {get;set;}   
    public List <SelectOption> loanTypeOptions {get;set;}
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;   
    //-
    //Yohan VillaLeal							2019-08-11
    public Decimal recommendedRate {get;set;}
    //-
    private Lenders__c lenderSettings {set;get;}

    public EsandaCommercialExtension (ApexPages.StandardController controller) {
                
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%ANZ_Commercial%'];
        this.docFees = 250.00;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.dof = lenderSettings.DOF__c;
        this.recommendedRate = 0.00;
        this.baseRate = 0.00;
        this.term = 60;
        this.adverseCredit = 'N';
        this.paymentType = 'Advance';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.realtimeNaf = applicationFee + dof + ppsr;        
        
        this.resetCalculationResult(); //Lelo       2017-07-25
        
        esandaCommercialRates = Esanda_Commercial_Rates__c.getAll();
        System.debug('The map value: ' + esandaCommercialRates);
        esandaRates = esandaCommercialRates.values();
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
        profileTypes.add(new SelectOption ('Property Owner - New Car', 'Property Owner_21-22 Car'));
        profileTypes.add(new SelectOption ('Property Owner - Old Car', 'Property Owner_20-Older Car'));
        profileTypes.add(new SelectOption ('Non Property Owner - New Car', 'Non Property Owner_21-22 Car'));
        profileTypes.add(new SelectOption ('Non Property Owner - Old Car', 'Non Property Owner_20-Older Car'));
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
                if (lender != null && lender.info != null && 'ACOM'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.customerProfile = lender.customerProfile;
                    this.adverseCredit = lender.adverseCredit;
                    this.ltv = lender.ltv;
                    this.productGoodsType = lender.productGoodsType;
                    this.paymentType = 'Arrears';
                    //this.productLoanType = lender.productLoanType;
                    if (String.isNotBlank(lender.productLoanType)) {
                        if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            this.productLoanType = 'Chattel Mortgage-Full-Doc';
                        } else if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            this.productLoanType = 'Chattel Mortgage-Low-Doc';
                        }
                    }
                    //Yohan VillaLeal                 2019-08-11
                    //baseRateCalc();
                    recommendedRateCalc();
                    this.baseRate = lender.baseRate;
                    //-
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
                    //
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }

    private Decimal getTotalInsurante() {
        Decimal r = 0.0;
        if (nwc != null) r += nwc;
        if (gap != null) r += gap;
        if (warranty != null) r += warranty;
        if (lti != null) r += lti;
        if (truckGap != null) r += truckGap;
        if (tai != null) r += tai;
        if (mv != null) r += mv;
        if (cci != null) r += cci;
        return r;
    }

    public void recommendedRateCalc () {
        realtimeNafCalc();

        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.ltv = ltv;
        param.customerProfile = customerProfile;
        param.term = term;
        param.adverseCredit = adverseCredit;
        recommendedRate = QuotingCalculation.getBaseRate(param);
        if(this.baseRate != null && this.baseRate == 0.00){
            this.baseRate = recommendedRate;
        }
        
        //if (ltv == null) {
        //    return;
        //}
        //Decimal originalRate = 0;
        //if (ltv == 'OG' || ltv == 'Other Goods') {
        //    if (customerProfile == 'Property Owner - New Car') {
        //        originalRate = esandaRates[0].Other_Goods__c;
        //    } else if (customerProfile == 'Property Owner - Old Car') {
        //        originalRate = esandaRates[1].Other_Goods__c;
        //    } else if (customerProfile == 'Non Property Owner - New Car') {
        //        originalRate = esandaRates[2].Other_Goods__c;
        //    } else if (customerProfile == 'Non Property Owner - Old Car') {
        //        originalRate = esandaRates[3].Other_Goods__c;
        //    } else {
        //        originalRate = 0;
        //    }
        //} else {
        //    if (ltv.isNumeric()) {
        //        decimal ltvValue = decimal.valueOf(ltv);
        //        if (ltvValue <= 140) {
        //            if (customerProfile == 'Property Owner - New Car') {
        //                originalRate = esandaRates[0].LTV_140__c;
        //            } else if (customerProfile == 'Property Owner - Old Car') {
        //                originalRate = esandaRates[1].LTV_140__c;
        //            } else if (customerProfile == 'Non Property Owner - New Car') {
        //                originalRate = esandaRates[2].LTV_140__c;
        //            } else if (customerProfile == 'Non Property Owner - Old Car') {
        //                originalRate = esandaRates[3].LTV_140__c;
        //            } else {
        //                originalRate = 0;
        //            }
        //        } else if (ltvValue > 140) {
        //            if (customerProfile == 'Property Owner - New Car') {
        //                originalRate = esandaRates[0].LTV_140__c + 1.50;
        //            } else if (customerProfile == 'Property Owner - Old Car') {
        //                originalRate = esandaRates[1].LTV_140__c + 1.50;
        //            } else if (customerProfile == 'Non Property Owner - New Car') {
        //                originalRate = esandaRates[2].LTV_140__c + 1.50;
        //            } else if (customerProfile == 'Non Property Owner - Old Car') {
        //                originalRate = esandaRates[3].LTV_140__c + 1.50;
        //            } else {
        //                originalRate = 0;
        //            }
        //        } //else {
        //          //  originalRate = 0;
        //        //}
        //    } else {
        //        originalRate = 0;
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill LTV field with an Integer value (decimal values aren\'t valid).'));
        //    } //end if numeric
        //} //end if 'OG'
        
        //if (originalRate > 0) {
        //    if (term > 60) {
        //        if (adverseCredit == 'Y') {
        //            baseRate = originalRate + 0.4 + 0.4;
        //        } else {
        //            baseRate = originalRate + 0.4;
        //        }
        //    } else {
        //        if (adverseCredit == 'Y') {
        //            baseRate = originalRate + 0.4;
        //        } else {
        //            baseRate = originalRate;
        //        }
        //    }
        //}
        
    } //end of funcion
    
    public void realtimeNafCalc () {
        netDepositCalc();
        realtimeNaf = this.getRealtimeNaf(null);
        //if (carPrice != null) realtimeNaf += carPrice;
        //if (applicationFee != null) realtimeNaf += applicationFee;
        //if (dof != null) realtimeNaf += dof;
        //if (ppsr != null) realtimeNaf += ppsr;
        //if (netDeposit != null) realtimeNaf -= netDeposit;
        //realtimeNaf += getTotalInsurante();
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
            if ((clientRate - baseRate) > 4) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximum rate load on an ANZ deal is 4% (Client Rate - Base Rate), current value: ' + (clientRate - baseRate) + '%'));
                r = false;
            }
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        if (!isResidualValueOK()) {
            r = false;
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
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
            if ('0'.equals(vehicleAge)) {
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
            } else if ('1'.equals(vehicleAge)) {
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
        recommendedRateCalc();
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
        this.carPrice = 0.00;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.dof = lenderSettings.DOF__c;
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
        this.docFees = 250.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        this.monthlyPayment = 0.00;
        this.fortnightlyPayment = 0.00;
        this.weeklyPayment = 0.00;
        this.gap = 0.00;
        this.gapIncome = 0.00;
        this.warranty = 0.00;
        this.warrantyIncome = 0.00;
        this.lti = 0.00;
        this.ltiIncome = 0.00;
        this.truckGap = 0.00;
        this.truckGapIncome = 0.00;
        this.tai = 0.00;
        this.taiIncome = 0.00;
        this.mv = 0.00;
        this.mvIncome = 0.00;
        this.cci = 0.00;
        this.cciIncome = 0.00;
        this.gapLevel = '';
        this.warrantyLevel = '';
        this.ltiLevel = '';
        this.truckGapLevel = '';
        this.taiLevel = '';
        this.mvLevel = '';
        //this.cciLevel = '';
        this.nwc = 0.00;
        this.nwcIncome = 0.00;
        this.state = '';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.productLoanType = '';
        this.productGoodsType = '';
        this.realtimeNaf = applicationFee + dof + ppsr;
		this.recommendedRate = 0.00;
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
        dto.lender = 'ANZ COMMERCIAL CALCULATION';
        dto.state = state;
        dto.vehicleGroup = vehicleGroup;
        dto.awd = awd;
        dto.turbo = turbo;
        dto.diesel = diesel;
        dto.gapLevel = gapLevel;
        dto.gap = String.valueOf(gap);
        dto.gapIncome = String.valueOf(gapIncome);
        dto.nwc = String.valueOf(nwc);
        dto.nwcIncome = String.valueOf(nwcIncome);
        dto.warrantyLevel = warrantyLevel;
        dto.warranty = String.valueOf(warranty);
        dto.warrantyIncome = String.valueOf(warrantyIncome);
        dto.ltiLevel = ltiLevel;
        dto.lti = String.valueOf(lti);
        dto.ltiIncome = String.valueOf(ltiIncome);
        dto.truckGapLevel = truckGapLevel;
        dto.truckGap = String.valueOf(truckGap);
        dto.truckGapIncome = String.valueOf(truckGapIncome);
        dto.taiLevel = taiLevel;
        dto.tai = String.valueOf(tai);
        dto.taiIncome = String.valueOf(taiIncome);
        dto.mvLevel = mvLevel;
        dto.mv = String.valueOf(mv);
        dto.cci = String.valueOf(cci);
        dto.cciIncome = String.valueOf(cciIncome);
        dto.carPrice = String.valueOf(carPrice);
        
        dto.applicationFee = String.valueOf(applicationFee);
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
        // pass varaibles for ANZ Commercial
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
        calcPdf.getParameters().put('lender', 'ANZ COMMERCIAL CALCULATION');
        calcPdf.getParameters().put('state', state);
        calcPdf.getParameters().put('vehicleGroup', vehicleGroup);
        calcPdf.getParameters().put('awd', awd);
        calcPdf.getParameters().put('turbo', turbo);
        calcPdf.getParameters().put('diesel', diesel);
        calcPdf.getParameters().put('gapLevel', gapLevel);
        calcPdf.getParameters().put('gap', String.valueOf(gap));
        calcPdf.getParameters().put('gapIncome', String.valueOf(gapIncome));
        calcPdf.getParameters().put('nwc', String.valueOf(nwc));
        calcPdf.getParameters().put('nwcIncome', String.valueOf(nwcIncome));
        calcPdf.getParameters().put('warrantyLevel', warrantyLevel);
        calcPdf.getParameters().put('warranty', String.valueOf(warranty));
        calcPdf.getParameters().put('warrantyIncome', String.valueOf(warrantyIncome));
        calcPdf.getParameters().put('ltiLevel', ltiLevel);
        calcPdf.getParameters().put('lti', String.valueOf(lti));
        calcPdf.getParameters().put('ltiIncome', String.valueOf(ltiIncome));
        calcPdf.getParameters().put('truckGapLevel', truckGapLevel);
        calcPdf.getParameters().put('truckGap', String.valueOf(truckGap));
        calcPdf.getParameters().put('truckGapIncome', String.valueOf(truckGapIncome));
        calcPdf.getParameters().put('taiLevel', taiLevel);
        calcPdf.getParameters().put('tai', String.valueOf(tai));
        calcPdf.getParameters().put('taiIncome', String.valueOf(taiIncome));
        calcPdf.getParameters().put('mvLevel', mvLevel);
        calcPdf.getParameters().put('mv', String.valueOf(mv));
        calcPdf.getParameters().put('mvIncome', String.valueOf(mvIncome));
        //calcPdf.getParameters().put('cciLevel', cciLevel);
        calcPdf.getParameters().put('cci', String.valueOf(cci));
        calcPdf.getParameters().put('cciIncome', String.valueOf(cciIncome));
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
        // pass varaibles for ANZ Commercial
        calcPdf.getParameters().put('adverseCredit', adverseCredit);
        calcPdf.getParameters().put('customerProfile', customerProfile);
        calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        // pass variables about the product info
        
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('vehicleAge', vehicleAgeValues[Integer.valueOf(vehicleAge)]);
        

        calcPdf.getParameters().put('loanType', dto.loanType);
        calcPdf.getParameters().put('productLoanType', dto.productLoanType);
        
        calcPdf.getParameters().put('deposit', dto.deposit);
        calcPdf.getParameters().put('tradeIn', dto.tradeIn);
        calcPdf.getParameters().put('payoutOn', dto.payoutOn);
        calcPdf.getParameters().put('netDeposit', dto.netDeposit);
        if(recommendedRate != null){
            calcPdf.getParameters().put('recommendedRate', String.valueOf(recommendedRate));
        }

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

		//Lelo 									2016-07-26
		savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,
                             Loan_Term__c,Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,
                             Cost_of_Goods__c,Deposit__c,Brokerage__c,Lender_App_Fee__c,
                             Equalisation_Fee_PPSR__c,DOF__c, Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c  
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-            
            
        updateProduct.Loan_Purpose__c = 'Business Use';
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
            updateProduct.Deposit__c = netDeposit;      //Lelo  2016-12-23
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
        
        //Lelo						2016-07-26
        upsert updateProduct;
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        //-
        
        // then create the insurance products
        // Gap Insurance
        if (gapLevel == null || gapLevel == '') {
            if (gap == null || gap == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap price has been filled without Gap level chosen.'));
            }
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // Warranty Insurance
        if (warrantyLevel == null || warrantyLevel == '') {
            if (warranty == null || warranty == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty price has been filled without Gap level chosen.'));
            }
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // LTI Insurance
        if (ltiLevel == null || ltiLevel == '') {
            if (lti == null || lti == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI price has been filled without Gap level chosen.'));
            }
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // Truck Gap Insurance
        if (truckGapLevel == null || truckGapLevel == '') {
            if (truckGap == null || truckGap == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap price has been filled without Gap level chosen.'));
            }
        } else {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Truck Gap Insurance';
            if (truckGap == null || truckGap == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = truckGap;
            }
            if (truckGapIncome == null || truckGapIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = truckGapIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // TAI/RTI Insurance
        if (taiLevel == null || taiLevel == '') {
            if (tai == null || tai == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI price has been filled without Gap level chosen.'));
            }
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // MV Insurance
        if (mvLevel == null || mvLevel == '') {
            if (mv == null || mv == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV price has been filled without Gap level chosen.'));
            }
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // CCI Insurance
        if (cci == null || cci == 0) {
            
        } else {
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
            //Lelo									2016-07-27
			//insert newInsurance;
            productList.add(newInsurance);
			//-
        }
        // NWC Insurance
        if (nwc == null || nwc == 0) {
            
        } else {
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
            //Lelo									2016-07-27
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
    //-
    
    public PageReference updateLTVForOtherGoods() {
        if ('Motorbike'.equals(productGoodsType) ||
            'Boat'.equals(productGoodsType) ||
            'Caravan'.equals(productGoodsType)) {
            ltvTmp = null;
            if (ltv != null && ltv.isNumeric()) {
                ltvTmp = ltv;
            }
            ltv = 'OG';
        } else {
            ltv = ltvTmp;
        }
        recommendedRateCalc();
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
        if (d != null) {
            System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Vehicle Details
            //state = d.Vehicle_Detail_State__c;
            //vehicleGroup = d.Vehicle_Detail_Group__c;
            //awd = d.Vehicle_Detail_AWD__c;
            //turbo = d.Vehicle_Detail_Turbo__c;
            //diesel = d.Vehicle_Detail_Diesel__c;
            //Insurance Product
            //gapLevel = d.Insurance_GAP_Type__c;
            //gap = d.Insurance_GAP_Retail_Price__c;
            //gapIncome = d.Insurance_GAP_Income__c;
            //warrantyLevel  = d.Insurance_Warranty_Type__c;
            //warranty = d.Insurance_Warranty_Retail_Price__c;
            //warrantyIncome = d.Insurance_Warranty_Income__c;
            //ltiLevel = d.Insurance_LTI_Type__c;
            //lti = d.Insurance_LTI_Retail_Price__c;
            //ltiIncome = d.Insurance_LTI_Income__c;
            //truckGapLevel = d.Insurance_Truck_GAP_Type__c;
            //truckGap = d.Insurance_Truck_GAP_Retail_Price__c;
            //truckGapIncome = d.Insurance_Truck_GAP_Income__c;
            //taiLevel = d.Insurance_TAI_Type__c;
            //tai = d.Insurance_TAI_Retail_Price__c;
            //taiIncome = d.Insurance_TAI_Income__c;
            //mvLevel = d.Insurance_MV_Type__c;
            //mv = d.Insurance_MV_Retail_Price__c;
            //mvIncome = d.Insurance_MV_Income__c;
            //cci = d.Insurance_AIC_Retail_Price__c;
            //cciIncome = d.Insurance_AIC_Income__c;
            //nwc = d.Insurance_NWC_Retail_Price__c;
            //nwcIncome = d.Insurance_NWC_Income__c;

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
                EsandaCalculatorExtension.LENDER_QUOTING.equals(d.Name) ||
                EsandaOthersExtension.LENDER_QUOTING.equals(d.Name)) {
                //Specific values
                productGoodsType = d.Goods_type__c;
                               
                if (d.Client_Rate__c != null) {
                    clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                if (!EsandaOthersExtension.LENDER_QUOTING.equals(d.Name)) {
                    adverseCredit = d.Adverse_Credit_File__c;
                    vehicleAge = d.Vehicle_Age__c;
                    customerProfile = d.Customer_Profile__c;
                    ltv = d.LTV__c;
                }
                paymentType = d.Payment__c;
                
            }
            if (LENDER_QUOTING.equals(d.Name)) {
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;    
                monthlyFee = d.Monthly_Fee__c;
                
                //Calculations
                netDepositCalc();
                recommendedRateCalc();
                if(d.Base_Rate__c != null){
                	baseRate = d.Base_Rate__c.setScale(2);
                }
				
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

            }
            this.realtimeNafCalc();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        }
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
        //Insurance product
        d.Insurance_GAP_Type__c = gapLevel;
        d.Insurance_GAP_Retail_Price__c = gap;
        d.Insurance_GAP_Income__c = gapIncome;
        d.Insurance_Warranty_Type__c = warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = warranty;
        d.Insurance_Warranty_Income__c = warrantyIncome;
        d.Insurance_LTI_Type__c = ltiLevel;
        d.Insurance_LTI_Retail_Price__c = lti;
        d.Insurance_LTI_Income__c = ltiIncome;
        d.Insurance_Truck_GAP_Type__c = truckGapLevel;
        d.Insurance_Truck_GAP_Retail_Price__c = truckGap;
        d.Insurance_Truck_GAP_Income__c = truckGapIncome;
        d.Insurance_TAI_Type__c = taiLevel;
        d.Insurance_TAI_Retail_Price__c = tai;
        d.Insurance_TAI_Income__c = taiIncome;
        d.Insurance_MV_Type__c = mvLevel;
        d.Insurance_MV_Retail_Price__c = mv;
        d.Insurance_MV_Income__c = mvIncome;
        d.Insurance_AIC_Retail_Price__c = cci;
        d.Insurance_AIC_Income__c = cciIncome;
        d.Insurance_NWC_Retail_Price__c = nwc;
        d.Insurance_NWC_Income__c = nwcIncome;
         //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Goods_type__c = productGoodsType;
        d.Vehicle_Age__c = vehicleAge;
        d.Vehicle_Price__c = carPrice;
        d.Deposit__c = deposit;
        d.Trade_In__c = tradeIn;
        d.Payout_On__c = payoutOn;
        
        d.Application_Fee__c = applicationFee;
        d.DOF__c = dof;
        d.PPSR__c = ppsr;
        d.Residual_Value__c = residualValue;
        d.Base_Rate__c = baseRate;
        if(recommendedRate != null){
            d.Recommended_Rate__c = String.valueOf(recommendedRate);
        }
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
    }
    //-
    
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
        r += this.getTotalInsuranceType(null);

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
        if (nwc != null) r += nwc;
        if (gap != null) r += gap;
        if (warranty != null) r += warranty;
        if (lti != null) r += lti;
        if (truckGap != null) r += truckGap;
        if (tai != null) r += tai;
        if (mv != null) r += mv;
        if (cci != null) r += cci;
        
        return r;
    }

    private Decimal getTotalInsuranceIncomeType(String calcType) {
        Decimal r = 0.0;
        if (nwcIncome != null) r += nwcIncome;
        if (gapIncome != null) r += gapIncome;
        if (warrantyIncome != null) r += warrantyIncome;
        if (ltiIncome != null) r += ltiIncome;
        if (truckGapIncome != null) r += truckGapIncome;
        if (taiIncome != null) r += taiIncome;
        if (mvIncome != null) r += mvIncome;
        if (cciIncome != null) r += cciIncome;
        
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

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}