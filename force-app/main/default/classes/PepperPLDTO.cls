public class PepperPLDTO {

    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal maxDof {get;set;}
    public Decimal residualValue {get;set;}
    public Decimal baseRate {get;set;}
    public Decimal clientRate {get;set;}
    public Decimal monthlyFee {get;set;}
    public String loanType {get;set;}
    public String productLoanType {get;set;}
    public Integer term {get;set;}
    public String loanPurpose {set;get;}
    public String paymentType {get;set;}
    
    public Decimal rental {get;set;}
    public Decimal estimatedCommission {get;set;}
    public Decimal nafCalculated {get;set;}

    public PepperPLDTO() {}

    public void init() {
        //loanTypeDetail = 'New';
        estimatedCommission = 0.0;
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
        return r;
    }

    public Decimal getTotalInsuranceType(String calcType) {
        return 0.0;
    }

    public Decimal getTotalInsuranceIncomeType(String calcType) {
        return 0.0;
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
        // if (docFees != null)
        //     r += docFees;
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
        return r;
    }
}