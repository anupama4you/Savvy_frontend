public class GeneralCalculatorDTO {
// finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
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
    
    
    public Decimal brokeragePercentage {get;set;}
    
    public String extraLabel1 {get;set;}
    public String extraLabel2 {get;set;}
    public String extraLabel3 {get;set;}
    public String extraLabel4 {get;set;}
    
    public Decimal extraValue1 {get;set;}
    public Decimal extraValue2 {get;set;}
    public Decimal extraValue3 {get;set;}
    public Decimal extraValue4 {get;set;}
    
    //Lelo                                      2017-01-09
    public String loanTypeDetail {set;get;}
    public String loanType {get;set;}
    public Decimal tradeIn {get;set;}
    public Decimal payoutOn {get;set;}
    //-
    
    public GeneralCalculatorDTO() {}
    
    public void init() {
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

        if (extraValue1 != null)
            r += extraValue1;
        if (extraValue2 != null)
            r += extraValue2;
        if (extraValue3 != null)
            r += extraValue3;
        if (extraValue4 != null)
            r += extraValue4;

        r -= getNetDeposit();
        return r;
    }

    public Decimal getTotalInsuranceType(String calcType) {
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

    public Decimal getTotalInsuranceIncomeType(String calcType) {
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

    public Decimal getRealtimeNafCalc(String calcType) {
        Decimal r = this.getTotalAmount(calcType);
        r += this.getTotalInsuranceType(calcType);
        return r;
    }

    public Decimal getRealtimeNaf() {
        //Decimal r = 0;
        //if (carPrice != null)
        //    r += carPrice;
        //if (applicationFee != null)
        //    r += applicationFee;
        //if (dof != null)
        //    r += dof;
        //if (ppsr != null)
        //    r += ppsr;
        
        //r -= getNetDeposit();
        
        //if (nwc != null)
        //    r += nwc;
        //if (gap != null)
        //    r += gap;
        //if (warranty != null)
        //    r += warranty;
        //if (lti != null)
        //    r += lti;
        //if (truckGap != null)
        //    r += truckGap;
        //if (tai != null)
        //    r += tai;
        //if (mv != null)
        //    r += mv;
        //if (cci != null)
        //    r += cci;
        //if (extraValue1 != null)
        //    r += extraValue1;
        //if (extraValue2 != null)
        //    r += extraValue2;
        //if (extraValue3 != null)
        //    r += extraValue3;
        //if (extraValue4 != null)
        //    r += extraValue4;
        return getRealtimeNafCalc(null);
    }
 	
    public Decimal getDofResult() {
        Decimal r = 0.0;
        if (dof != null) {
            r = dof/1.1;
        }
        return r;
    }
 	
    public Decimal getTotalCommission() {
        Decimal r = 0.0;
        if (estimatedCommission != null)
            r += estimatedCommission;
        if (docFees != null)
            r += docFees;
        r += getInsuranceIncome();
        r += getDofResult();
        return r;
    }
    
    public Decimal getTotalCommissionGst() {
        return getTotalCommission() * 1.1;
    }
    
    public Decimal getInsuranceIncome() {
        Decimal r = this.getTotalInsuranceIncomeType(null);
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
        Decimal r = getMonthlyPayment() / 4.33;
        return r.setScale(2);
    }
    
    public Decimal getBaseAmountPmtCalc(String calcType) {
        return getRealtimeNafCalc(calcType);
        //Decimal r = 0;
        //if (carPrice != null)
        //    r += carPrice;
        
        //r -= getNetDeposit();
        
        //if (applicationFee != null)
        //    r += applicationFee;
        //if (dof != null)
        //    r += dof;
        //if (ppsr != null)
        //    r += ppsr;

        //if (nwc != null)
        //    r += nwc;
        //if (gap != null)
        //    r += gap;
        //if (warranty != null)
        //    r += warranty;
        //if (lti != null)
        //    r += lti;
        //if (truckGap != null)
        //    r += truckGap;
        //if (tai != null)
        //    r += tai;
        //if (mv != null)
        //    r += mv;
        //if (cci != null)
        //    r += cci;

        //if (extraValue1 != null)
        //    r += extraValue1;
        //if (extraValue2 != null)
        //    r += extraValue2;
        //if (extraValue3 != null)
        //    r += extraValue3;
        //if (extraValue4 != null)
        //    r += extraValue4;
        //return r;
    }
    
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        Decimal r = getRealtimeNafCalc(calcType);
        if (brokeragePercentage != null && brokeragePercentage != 0) {
        	   r += (getBaseAmountPmtCalc(calcType) * brokeragePercentage/100);
        }
        return r;
    }
    
    public Decimal getNetDeposit() {
        Decimal netDeposit = 0;
        if (deposit != null) netDeposit += deposit;
        if (tradeIn != null) netDeposit += tradeIn;
        if (payoutOn != null) netDeposit -= payoutOn;
        return netDeposit;
    }

}