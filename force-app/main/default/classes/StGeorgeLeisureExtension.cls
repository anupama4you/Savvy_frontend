public class StGeorgeLeisureExtension {
    public Custom_Opportunity__c Opp;
	
	//Lelo					2016-07-26
    private String fileGlobalPrefix = 'St_George_Leisure';
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
    
    public String loanType {get;set;}
    public Integer term {get;set;}
    public String paymentFrequency {get;set;}
    public String carType {get;set;}
    public String paymentType {get;set;}
    
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> loanTypes {get;set;}
    public List <SelectOption> paymentFrequencies {get;set;}
    public List <SelectOption> carTypes {get;set;}
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
    
    // extra info for St George
    public Boolean monthlyRender {get;set;}
    public Boolean fortnightlyRender {get;set;}
    public Boolean weeklyRender {get;set;}
    
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
    
    public StGeorgeLeisureExtension (ApexPages.StandardController controller) {
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%St_George_Leisure%'];
        this.monthlyFee = 5.95;
        this.ppsr = -40.93;
        this.applicationFee = 399.00;
        this.dof = 700.00;
        this.term = 60;
        this.loanType = 'Consumer';
        this.paymentFrequency = 'Monthly';
        this.paymentType = 'Arrears';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.monthlyRender = true;
        this.fortnightlyRender = false;
        this.weeklyRender = false;
        this.baseRate = 0.00;
        this.realtimeNaf = applicationFee + dof + ppsr;
        
        estimatedCommission = 0.00;
        dofResult = 0.00;
        totalCommission = 0.00;
        insuranceIncome = 0.00;
        totalCommissionGst = 0.00;
        naf = 0.00;
        rental = 0.00;
        monthlyPayment = 0.00;
        fortnightlyPayment = 0.00;
        weeklyPayment = 0.00;
        
        yesNoOptions = new List <SelectOption> ();
        yesNoOptions.add(new SelectOption ('', '--None--'));
        yesNoOptions.add(new SelectOption ('Y', 'Yes'));
        yesNoOptions.add(new SelectOption ('N', 'No'));
        loanTypes = new List <SelectOption> ();
        loanTypes.add(new SelectOption ('', '--None--'));
        loanTypes.add(new SelectOption ('Consumer', 'Consumer'));
        loanTypes.add(new SelectOption ('Commercial', 'Commercial'));
        paymentFrequencies = new List <SelectOption> ();
        paymentFrequencies.add(new SelectOption ('', '--None--'));
        paymentFrequencies.add(new SelectOption ('Weekly', 'Weekly'));
        paymentFrequencies.add(new SelectOption ('Fortnightly', 'Fortnightly'));
        paymentFrequencies.add(new SelectOption ('Monthly', 'Monthly'));
        carTypes = new List <SelectOption> ();
        carTypes.add(new SelectOption ('', '--None--'));
        carTypes.add(new SelectOption ('New Leisure', 'New Leisure'));
        carTypes.add(new SelectOption ('Used Leisure to 3 years', 'Used Leisure to 3 years'));
        carTypes.add(new SelectOption ('Used Leisure 4-5 years', 'Used Leisure 4-5 years'));
        carTypes.add(new SelectOption ('Used Leisure 6+ years', 'Used Leisure 6+ years'));
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
        
        productLoanTypes = new List <SelectOption> ();
        productLoanTypes.add(new SelectOption ('', '--None--'));
        productLoanTypes.add(new SelectOption ('Consumer Loan', 'Consumer Loan'));
        productLoanTypes.add(new SelectOption ('Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Full-Doc'));
        productLoanTypes.add(new SelectOption ('Car Lease-Full-Doc', 'Car Lease-Full-Doc'));
        productLoanTypes.add(new SelectOption ('Chattel Mortgage-Low-Doc', 'Chattel Mortgage-Low-Doc'));
        productLoanTypes.add(new SelectOption ('Car Lease-Low-Doc', 'Car Lease-Low-Doc'));
        productLoanTypes.add(new SelectOption ('Re-Finance', 'Re-Finance'));
        productLoanTypes.add(new SelectOption ('Sale & Lease Back', 'Sale & Lease Back'));
        productGoodsTypes = new List <SelectOption> ();
        productGoodsTypes.add(new SelectOption ('', '--None--'));
        productGoodsTypes.add(new SelectOption ('Car', 'Car'));
        productGoodsTypes.add(new SelectOption ('Motorbike', 'Motorbike'));
        productGoodsTypes.add(new SelectOption ('Boat', 'Boat'));
        productGoodsTypes.add(new SelectOption ('Caravan', 'Caravan'));
        productGoodsTypes.add(new SelectOption ('Truck', 'Truck'));
        productGoodsTypes.add(new SelectOption ('Equipment', 'Equipment'));

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
                if (lender != null && lender.info != null && 'SGLE'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productGoodsType = lender.productGoodsType;
                    this.productLoanType = lender.productLoanType;
                    this.loanType = lender.loanType;
                    this.carType = lender.carType;

                    baseRateCalc();
                    
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        }

    }

    public void baseRateCalc () {
        Decimal originalRate = 0;
        if (carType == 'New Leisure') {
            originalRate = 7.68;
        } else if (carType == 'Used Leisure to 3 years') {
            originalRate = 8.18;
        } else if (carType == 'Used Leisure 4-5 years') {
            originalRate = 9.38;
        } else if (carType == 'Used Leisure 6+ years') {
            originalRate = 11.18;
        } else {
            originalRate = 0.00;
        } // end if for carType ==
        if (loanType == 'Consumer') {
            if (term > 60 && term <= 84) {
                baseRate = originalRate + 1.00;
            } else if (term <= 60) {
                baseRate = originalRate;
            } else {
                baseRate = 0.00;
            } // end if for term
        } else if (loanType == 'Commercial') {
            baseRate = originalRate;
        } else {
            baseRate = 0.00;
        } // end if for loanType ==
        
    } //end of funcion
    
    public void monthlyFeeCalc () {
        if (paymentFrequency == 'Monthly') {
            monthlyFee = 5.95;
        } else if (paymentFrequency == 'Fortnightly') {
            monthlyFee = 3.00;
        } else if (paymentFrequency == 'Weekly') {
            monthlyFee = 1.50;
        }
    } //end of funcion
    
    public void realtimeNafCalc () {
        realtimeNaf = carPrice + applicationFee + dof + ppsr - deposit + nwc + gap + warranty + lti + truckGap + tai + mv + cci;
    } //end of funcion
    
    public void validation () {
        if (loanType == 'Commercial' && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Commercial loan cannot be longer than 5 years.'));
        }
    } //end of funcion
    
    public void frequencyShow () {
        if (paymentFrequency == 'Monthly') {
            monthlyRender = true;
            fortnightlyRender = false;
            weeklyRender = false;
        } else if (paymentFrequency == 'Fortnightly') {
            monthlyRender = false;
            fortnightlyRender = true;
            weeklyRender = false;
        } else if (paymentFrequency == 'Weekly') {
            monthlyRender = false;
            fortnightlyRender = false;
            weeklyRender = true;
        }
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }

        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        return r;
    }

    public PageReference calculate () {
        
        if (!isValidationOk()) {
            return null;
        }
        
        // determine the loan type - consumer or commercial
        Boolean type = false;
        if (paymentType == 'Advance') {
            type = true;
        }
        
        // calculate the total Amount for the finance
        decimal totalAmount = carPrice + applicationFee + dof + ppsr - deposit;
        decimal totalInsurance = nwc + gap + warranty + lti + truckGap + tai + mv + cci;
        naf = totalAmount + totalInsurance;
        naf = naf.setScale(2);
        
        // calculate the payment rate based on client rate, which is determined by consultants
        // The preparation
        Decimal realTerm = 0;
        if (paymentFrequency == 'Weekly') {
            realTerm = (term/12) * (365.0/7.0);
        } else if (paymentFrequency == 'Fortnightly') {
            realTerm = (term/12) * (365.0/14.0);
        } else if (paymentFrequency == 'Monthly') {
            realTerm = term;
        }
        //realTerm = realTerm.setScale(0);
        System.debug('The calculated realTerm is: ' + realTerm);
        
        //Lelo												2016-07-29
        Decimal realTermToCalcCommision = realTerm;
        if (term > 60) {
                realTermToCalcCommision = 60;
        }
        System.debug('The calculated realTermToCalcCommision is: ' + realTermToCalcCommision);
        //-
        
        Integer compoundPeriod = 0;
        if (paymentFrequency == 'Weekly') {
            compoundPeriod = 52;
        } else if (paymentFrequency == 'Fortnightly') {
            compoundPeriod = 26;
        } else if (paymentFrequency == 'Monthly') {
            compoundPeriod = 12;
        }
        System.debug('The calculated compoundPeriod is: ' + compoundPeriod);
        
        decimal realRate = clientRate/100;
        decimal futureValue = FinancialUtilities.fv(realRate/12,12,1000);
        decimal rate = FinancialUtilities.rate(1000, compoundPeriod, 0, futureValue, realRate/compoundPeriod, false);
        System.debug('The calculated rate is: ' + rate);
        
        // calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
        decimal realBaseRate = baseRate/100;
        decimal baseFutureValue = FinancialUtilities.fv(realBaseRate/12,12,1000);
        decimal baseRateValue = FinancialUtilities.rate(1000, compoundPeriod, 0, baseFutureValue, realBaseRate/compoundPeriod, false);
        System.debug('The calculated base rate is: ' + baseRateValue);
        
        // calculate the base payment without brokerage
        decimal basePayment = FinancialUtilities.pmt(naf, baseRateValue, realTerm, residualValue, type);
        System.debug('basePayment >> ' + basePayment + '|' + naf + '|' + realTerm + '|' + residualValue + '|' + type);
        System.debug('The calculated base payment is: ' + basePayment);
        
        // calculate the monthly payment based on client rate
        rental = FinancialUtilities.pmt(naf, rate, realTerm, residualValue, type);
        //Lelo							2016-08-25
        Decimal rentalCommission = FinancialUtilities.pmt(naf, rate, realTermToCalcCommision, residualValue, type);
        Decimal basePaymentCommission = FinancialUtilities.pmt(naf, baseRateValue, realTermToCalcCommision, residualValue, type);
        System.debug('basePaymentCommission >> ' + basePaymentCommission + '|' + naf + '|' + realTermToCalcCommision + '|' + residualValue + '|' + type);
        //--
        System.debug('The calculated rental is: ' + rental + '|' + rentalCommission);
        
        // calculate the estimated commission
        // The preparation
        Decimal commissionRate = 0;
        Decimal realCommission = 0;
        if (carType == 'Used Leisure 6+ years') {
            commissionRate = 0.6;
        } else {
            commissionRate = 0.7;
        }
        
        //Lelo						2016-07-29/2016-08-25
        //realCommission = commissionRate * ((rental * realTerm) - (basePayment * realTerm));
        realCommission = commissionRate * ((rentalCommission * realTermToCalcCommision) - (basePaymentCommission * realTermToCalcCommision));
        System.debug(commissionRate + '|' + rentalCommission + '|' + realTermToCalcCommision + '|' + basePaymentCommission + '|' + realTermToCalcCommision);
        //-
        
        if (realCommission <= 150) {
            estimatedCommission = 150.00;
        } else {
            estimatedCommission = realCommission;
        }
        estimatedCommission = estimatedCommission.setScale(2);
        
        //calculate the insurance income
        insuranceIncome = nwcIncome + gapIncome + warrantyIncome + ltiIncome + truckGapIncome + taiIncome +mvIncome + cciIncome;
        insuranceIncome = insuranceIncome / 1.1;
        
        // calculate the dof without GST
        dofResult = dof / 1.1;
        dofResult = dofResult.setScale(2);
        
        // calculate the total commission
        totalCommission = estimatedCommission + insuranceIncome + dofResult;
        
        // calculate the total commission with GST
        totalCommissionGst = totalCommission * 1.1;
        
        // calculate the payment
        frequencyShow();
        
        if (paymentFrequency == 'Monthly') {
            monthlyPayment = rental + monthlyFee;
            fortnightlyPayment = monthlyPayment * 12 / 26;
            weeklyPayment = monthlyPayment / 4.33;
        } else if (paymentFrequency == 'Fortnightly') {
            fortnightlyPayment = rental + monthlyFee * 12 / 26;
            monthlyPayment = fortnightlyPayment * 26 / 12;
            weeklyPayment = fortnightlyPayment / 2;
        } else if (paymentFrequency == 'Weekly') {
            weeklyPayment = rental + monthlyFee / 4.33;
            monthlyPayment = weeklyPayment * 52 / 12;
            fortnightlyPayment = weeklyPayment * 2;
        }
        
        rental = rental.setScale(2);
        insuranceIncome = insuranceIncome.setScale(2);
        totalCommission = totalCommission.setScale(2);
        totalCommissionGst = totalCommissionGst.setScale(2);
        monthlyPayment = monthlyPayment.setScale(2);
        fortnightlyPayment = fortnightlyPayment.setScale(2);
        weeklyPayment = weeklyPayment.setScale(2);
        
        //if (estimatedCommission <= 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        //}
        
        return null;
    } // end of function
    
    public PageReference reset () {
        this.carPrice = 0.00;
        this.applicationFee = 399.00;
        this.dof = 700.00;
        this.ppsr = -40.93;
        this.residualValue = 0.00;
        this.clientRate = 0.00;
        this.deposit = 0.00;
        this.term = 60;
        this.loanType = 'Consumer';
        this.paymentFrequency = 'Monthly';
        this.carType = '';
        this.paymentType = 'Arrears';
        this.baseRate = 0.00;
        this.estimatedCommission = 0.00;
        this.insuranceIncome = 0.00;
        this.dofResult = 0.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        this.monthlyFee = 5.95;
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
        this.monthlyRender = true;
        this.fortnightlyRender = false;
        this.weeklyRender = false;
        this.productLoanType = '';
        this.productGoodsType = '';
        this.realtimeNaf = applicationFee + dof + ppsr;
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
        calcPdf.getParameters().put('lender', 'ST GEORGE LEISURE CALCULATION');
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
        calcPdf.getParameters().put('deposit', String.valueOf(deposit));
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
        // pass varaibles for St George Leisure
        calcPdf.getParameters().put('loanType', loanType);
        calcPdf.getParameters().put('paymentFrequency', paymentFrequency);
        calcPdf.getParameters().put('carType', carType);
        // pass variables about the product info
        calcPdf.getParameters().put('productLoanType', productLoanType);
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        
        Boolean isSaveInCloud = false;
        if (prefixName.contains('APPROVAL')) {
            isSaveInCloud = true;
            String typeData = 'Quoting Calculation';
            if (!prefixName.contains('PRE_APPROVAL')) {
               typeData += 'Quoting Calculation (Formal Approval)';
            }
            //ApplicationExtraDataHelper.upsertData(Opp.Application__c, 'Quoting ' + fileGlobalPrefix, 'Quoting Calculation', dto);
        }
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, calcPdf, isSaveInCloud);
        //QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, calcPdf);
        
        /*
        // insert PDF file into the Opp
        Attachment attachCalc = new Attachment();
        
        Blob body;
        try {
            body = calcPdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error occurred in generating the PDF file.');
        }
        
        //Make unique name with accumulated number for Calculation name
        
        
        attachCalc.Body = body;
        String fileName = 'St_George_Leisure_' + Opp.Id + '_' + (existingAttach.size()+1) + '.pdf';
        attachCalc.Name = fileName;
        attachCalc.IsPrivate = false;
        attachCalc.ParentId = Opp.Id;
        insert attachCalc;
        */
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation PDF saved successfully.'));
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
        //Lelo 									2016-07-26
		savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                           Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c from Product__c where id =: Opp.Loan_Product__c];
        }
        //- 
            
        if (productLoanType == 'Consumer Loan') {
            updateProduct.Loan_Purpose__c = 'Personal Use';
        } else {
            updateProduct.Loan_Purpose__c = 'Business Use';
        }
        
        updateProduct.Lender__c = 'St George';
        if (paymentFrequency == 'Monthly') {
            updateProduct.Repayment_Regularity__c = 'Monthly';
        } else if (paymentFrequency == 'Fortnightly') {
            updateProduct.Repayment_Regularity__c = 'Fortnightly';
        } else if (paymentFrequency == 'Weekly') {
            updateProduct.Repayment_Regularity__c = 'Weekly';
        }
        
        if (productLoanType == null || productLoanType == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan Type is not updated as the calculator does not contain relevant info.'));
        } else {
            updateProduct.Loan_Type__c = productLoanType;
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Term is not updated as the calculator does not contain relevant info.'));
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
        } else {
            updateProduct.Client_Rate__c = clientRate;
        }
        if (monthlyPayment == null || monthlyPayment == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Payment is not updated as the calculator does not contain relevant info.'));
        } else {
            //Lelo									2016-0822
            if (paymentFrequency == 'Monthly') {
                updateProduct.Payments__c = monthlyPayment;
            } else if (paymentFrequency == 'Fortnightly') {
                updateProduct.Payments__c = fortnightlyPayment;
            } else if (paymentFrequency == 'Weekly') {
                updateProduct.Payments__c = weeklyPayment;
            }
            //updateProduct.Payments__c = monthlyPayment;    //original line
            //-
        }
        if (carPrice == null || carPrice == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Cost of Goods is not updated as the calculator does not contain relevant info.'));
        } else {
            updateProduct.Cost_of_Goods__c = carPrice;
        }
        if (deposit == null || deposit == 0) {
            updateProduct.Deposit__c = 0;
        } else {
            updateProduct.Deposit__c = deposit;
        }
        if (dof == null || dof == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF is not updated as the calculator does not contain relevant info.'));
        } else {
            updateProduct.DOF__c = dof;
        }
        if (estimatedCommission == null || estimatedCommission == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission is not updated as the calculator does not contain relevant info.'));
        } else {
            updateProduct.Brokerage__c = estimatedCommission;
        }
        if (applicationFee == null || applicationFee == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee is not updated as the calculator does not contain relevant info.'));
        } else {
            updateProduct.Lender_App_Fee__c = applicationFee;
        }
        if (ppsr == null || ppsr == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
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

}