public class Money3CalculatorDTO {
	
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
    
    public String loanTypeDetail {set;get;}
    
    //Lelo                                      2016-12-20
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
    public String cciLevel {get;set;}
    
   	public List<String> cciLevels = new List<String> {
      'Disability', 'Disability/Unemployment'
    };
    public String profile {set;get;}
    // Lelo             2019-08-01
    public String grading {set;get;}
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}
    public String loanPurpose {set;get;}
    public Money3CalculatorDTO() {}
    
    public void init() {
        //loanTypeDetail = 'New';
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
        if (!'Micro'.equals(this.profile) && dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        r -= getNetDeposit();
        if (riskFee != null) {
            if (riskFee != null) r += riskFee;
        }
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
            //Jesus Mora 2020-08-21 start
            r += getLtiCci();
            /*
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
            */
            //Jesus Mora 2020-08-21 end
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
                //Jesus Mora 2020-08-21 start
                r += cci;
                /*
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r = results.premium;
                }
                */
                //Jesus Mora 2020-08-21 end
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
            //Jesus Mora 2020-08-21 start
            r += getLtiCciIncome();
            //Lelo                  Insurance           2018-07-03
            /*
            if (getHasLti()) {
                r += getLtiCciIncome();
            } else {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r += results.commission;
                } 
            }
            */
            //Jesus Mora 2020-08-21 end
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
                //Jesus Mora 2020-08-21 start
                r += cciIncome;
                /*
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType) + getGapTai() + getWarrNwc();
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r = results.commission;
                }
                */
                //Jesus Mora 2020-08-21 end
            }
        }
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
        return getTotalCommission() * 1.1;
    }
    
    public Decimal getInsuranceIncome() {
        Decimal r = this.getTotalInsuranceIncomeType(QuotingCalculation.CALC_QUOTING);
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
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('New', 'New'));
        // r.add(new SelectOption ('2009 and younger', '2009 and younger'));
        // r.add(new SelectOption ('2008 and older', '2008 and older'));
        r.add(new SelectOption ('1', '1'));
        r.add(new SelectOption ('2', '2'));
        r.add(new SelectOption ('3', '3'));
        r.add(new SelectOption ('4', '4'));
        r.add(new SelectOption ('5', '5'));
        r.add(new SelectOption ('6', '6'));
        r.add(new SelectOption ('7', '7'));
        r.add(new SelectOption ('8+', '8+'));
        return r;
    }

    public Decimal getNetDeposit() {
        Decimal netDeposit = 0;
        if (deposit != null) netDeposit += deposit;
        if (tradeIn != null) netDeposit += tradeIn;
        if (payoutOn != null) netDeposit -= payoutOn;
        return netDeposit;
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
    //-
    // Money3 Place
    public Decimal getBaseCommission(String calcType) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        r -= getNetDeposit();
        return r;
    }

    public Decimal getRiskFeeBase() {
        return getLoanAmount();
    }

    public Decimal getLoanAmount() {
        Decimal r = 0.0;
        if (this.carPrice != null) { 
            r += this.carPrice;
        }
        if (!'Personal Finance'.equals(this.profile)) {
            r -= getNetDeposit();
        }
        return r;
    }
}