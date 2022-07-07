public class YamahaCalculatorDTO {
	
    public String calculatorType {get;set;}
    
    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal maxDof {get;set;}
    public Decimal ppsr {get;set;}
    public Decimal residualValue {get;set;}
    public Decimal baseRate {get;set;}
    public Decimal clientRate {get;set;}
    public Decimal monthlyFee {get;set;}
        
    //Loan Details
    public String productLoanType {get;set;}
    public Integer term {get;set;}
    public String paymentType {get;set;}
    public String assetType {get;set;}
    
    // Vehicle Details
    public String state {get;set;}
    public String vehicleGroup {get;set;}
    public String awd {get;set;}
    public String turbo {get;set;}
    public String diesel {get;set;}
    
    // Insurance Product
    public String gapLevel {get;set;}
    public Decimal gap {get;set;}
    public Decimal gapIncome {get;set;}
    public String warrantyLevel {get;set;}
    public Decimal warranty {get;set;}
    public Decimal warrantyIncome {get;set;}
    public String ltiLevel {get;set;}
    public Decimal lti {get;set;}
    public Decimal ltiIncome {get;set;}
    public String truckGapLevel {get;set;}
    public Decimal truckGap {get;set;}
    public Decimal truckGapIncome {get;set;}
    public String taiLevel {get;set;}
    public Decimal tai {get;set;}
    public Decimal taiIncome {get;set;}
    public String mvLevel {get;set;}
    public Decimal mv {get;set;}
    public Decimal mvIncome {get;set;}
    public Decimal cci {get;set;}
    public Decimal cciIncome {get;set;}
    public Decimal nwc {get;set;}
    public Decimal nwcIncome {get;set;}
        
    // finance calculator output
    public Decimal estimatedCommission {get;set;}
    public Decimal docFees {get;set;}
    
    public Decimal nafCalculated {get;set;}
    public Decimal rental {get;set;}
    
    //Motorcycle
    public String customerProfile {get;set;}
    
    //Lelo                                      2017-01-09
    public String loanTypeDetail {set;get;}
    public String loanType {get;set;}
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    //-

    //Lelo                  Insurance                       2018-03-02
    public String nwcPlan {get;set;}
    public String nwcTerm {get;set;}
    public Decimal nwcCost {get;set;}
    public String nwcAcceptance {get;set;}

    public String mvAcceptance {get;set;}
    public String gapAcceptance {get;set;}
    public String taiAcceptance {get;set;}
    public String ltiAcceptance {get;set;}
    public String warrantyAcceptance {get;set;}
    public String cciAcceptance {get;set;}

    public String insuranceInputMode {set;get;}
    //-
    //Lelo              2018-07-09
    public String privateSales {get;set;}
    public Decimal maxBaseRate {get;set;}
    //-

	//Yohan VillaLeal                      Insurance   12-07-2018
    public String cciLevel {get;set;}
    
   	public List<String> cciLevels = new List<String> {
      'Disability', 'Disability/Unemployment'
    };
	
    public YamahaCalculatorDTO() {

    }
    
    public void init() {
        //productLoanType = 'New';
        estimatedCommission = 0.0;
        docFees = 0.0;
        nafCalculated = 0.0;
        rental = 0.0;        
    }
    
    public Decimal getTotalAmount(String calcType) {
        Decimal r = 0.0;

        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (applicationFee != null) r += applicationFee;
        if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        
        r -= getNetDeposit();
        
        return r;
    }

    public Decimal getTotalInsuranceType(String calcType) {
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
            if (nwc != null) r += nwc;
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
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

    public Decimal getTotalInsuranceIncomeType(String calcType) {
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
            if (nwcIncome != null) r += nwcIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
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

    public Decimal getRealtimeNaf() {
        Decimal r = this.getTotalAmount(QuotingCalculation.CALC_QUOTING);
        r += this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        return r;
    }
 	
    public Decimal getDOFBaseCalculation() {
        return getDOFBaseCalculation(QuotingCalculation.CALC_QUOTING);
    }    

    public Decimal getDOFBaseCalculation(String calcType) {
        Decimal r = 0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (applicationFee != null)
            r += applicationFee;
        if (ppsr != null)
            r += ppsr;
        
        r -= getNetDeposit();
        r += this.getTotalInsuranceType(calcType);
        
        return r;
    }
    
    public Decimal getDofResult() {
        Decimal r = 0.0;
        if (dof != null) {
            r = dof/1.1;
        }
        return r.setScale(2);
    }
 	
    public Decimal getTotalCommission() {
        Decimal r = 0.0;
        if (estimatedCommission != null)
            r += estimatedCommission;
        if (docFees != null)
            r += docFees;
        r += getInsuranceIncome();
        r += getDofResult();
        return r.setScale(2);
    }
    
    public Decimal getTotalCommissionGst() {
        Decimal r = getTotalCommission() * 1.1;
        return r.setScale(2);
    }
    
    public Decimal getInsuranceIncome() {
        Decimal r = this.getTotalInsuranceIncomeType(QuotingCalculation.CALC_QUOTING);
        //Decimal r = 0.0;
        //if (nwcIncome != null)
        //	r += nwcIncome; 
        //if (gapIncome != null)
        //    r += gapIncome; 
        //if (warrantyIncome != null)
        //    r += warrantyIncome;
        //if(ltiIncome != null)
        //    r += ltiIncome;
        //if (truckGapIncome != null)
        //    r += truckGapIncome;
        //if (taiIncome != null)
        //    r += taiIncome;
        //if (mvIncome != null)
        //    r += mvIncome; 
        //if (cciIncome != null)
        //    r += cciIncome;
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
    
    public static List <SelectOption> getSelectLoanTypeOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        //r.add(new SelectOption ('New Prime Plus', 'New Prime Plus'));
        //r.add(new SelectOption ('New Prime', 'New Prime'));
        //r.add(new SelectOption ('Standard Buyer', 'Standard Buyer'));
        r.add(new SelectOption ('Prime Plus', 'Prime Plus'));
        r.add(new SelectOption ('Prime', 'Prime'));
        r.add(new SelectOption ('Standard', 'Standard'));
        return r;
    }
    
    public static List <SelectOption> getSelectLoanTypeWaterOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        //r.add(new SelectOption ('New Prime Plus', 'New Prime Plus'));
        //r.add(new SelectOption ('New Prime', 'New Prime'));
        //r.add(new SelectOption ('New Standard', 'New Standard'));
        r.add(new SelectOption ('Prime Plus', 'Prime Plus'));
        r.add(new SelectOption ('Prime', 'Prime'));
        r.add(new SelectOption ('Standard', 'Standard'));
        return r;
    }
    
    public List <SelectOption> getSelectLoanTypeMarineOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        //r.add(new SelectOption ('Prime Plus Buyer', 'Prime Plus Buyer'));
        if (String.isBlank(this.productLoanType) || 'Consumer Loan'.equals(this.productLoanType)) {
            r.add(new SelectOption ('Prime Plus', 'Prime Plus'));
            r.add(new SelectOption ('Prime', 'Prime'));
            r.add(new SelectOption ('Standard', 'Standard'));
            r.add(new SelectOption ('Limited', 'Limited'));
            if ('Commercial'.equals(this.loanTypeDetail)) {
                this.loanTypeDetail = 'Prime Plus';
            }
        } else if (String.isNotBlank(this.productLoanType)) {
            r.add(new SelectOption ('Commercial', 'Commercial'));
            this.loanTypeDetail = 'Commercial';
        }
        System.debug('SelectLoanTypeMarineOptions: ' + this.productLoanType + '|' + this.loanTypeDetail);
        return r;
    }
    
    public static List <SelectOption> getSelectCustomerProfileOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('New', 'New'));
        r.add(new SelectOption ('Used', 'Used'));
        return r;
    }

    public Decimal getNetDeposit() {
        Decimal netDeposit = 0;
        if (deposit != null) netDeposit += deposit;
        if (tradeIn != null) netDeposit += tradeIn;
        if (payoutOn != null) netDeposit -= payoutOn;
        return netDeposit;
    }
    
    public List<YamahaRates__c> getYamahaRates() {
        List<YamahaRates__c> r = YamahaRates__c.getAll().values();
        r.sort();
        return r;
    }

    public List<YamahaRatesV2__c> getYamahaRatesV2() {
        List<YamahaRatesV2__c> r = YamahaRatesV2__c.getAll().values();
        r.sort();
        return r;
    }


    // Lelo             Insurance           2018-03-02
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

    public Boolean getHasWarranty() {
        Boolean r = false;
        if ('A'.equals(insuranceInputMode)) {
            if (String.isNotBlank(warrantyLevel)) {
                r = true;
            }
        }
        return r;
    }

    public Boolean getIsRTIRequired() {
        Boolean r = false;
        Decimal pDep = 0;
        if (carPrice != null && carPrice > 0) {
            pDep = getNetDeposit() / carPrice * 100;
        }
        if (pDep >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
            r = true;
        }
        return r;               
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
            if (String.isNotBlank(ltiLevel)) {
                r = true;
            }
        }
        return r;
    }
      
    public Decimal getTermYears() {
        if (term == null) return 0;
        return term/12;
    }

    public static List <SelectOption> getAssetTypeOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Motorcycle', 'Motorcycle'));
        r.add(new SelectOption ('Boat', 'Boat'));
        r.add(new SelectOption ('JetSki', 'JetSki'));
        return r;
    }
}