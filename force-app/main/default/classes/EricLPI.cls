public class EricLPI {
	
    public static List<EricLPIRate__c> lpiRates = null;

    public static Result CalculateEricLPI(Parameter parameters){
        Result results = null;
        if(parameters == null || parameters.term == null || parameters.initialAmount == null || parameters.initialAmount < 0){
            return results;
        }
        
        List<EricLPIRate__c> rates = getLpiSettingRates();
        Integer term = parameters.term;
        if (parameters.term < 3) {
            term = 3;
        }
        for(EricLPIRate__c r : rates){
            
            Double rate = r.Rate__c/100.0;
            if(rate >= 0){
                if(r.Cover_Option__c.equals(parameters.coverOption) && term == r.Term__c){
                    results = new Result();
                    //results.premium = Math.round(parameters.initialAmount*rate*(1-Math.pow(rate,20))/(1-rate));
                    results.premium = parameters.initialAmount*rate*(1-Math.pow(rate,20))/(1-rate);
                    results.premium = results.premium.setScale(2);
                    results.commission = results.premium * 0.2;
                    break;
                }
            }
        }
        return results;
    }
    
    private static List<EricLPIRate__c> getLpiSettingRates() {
        if (lpiRates == null) {
            lpiRates = EricLPIRate__c.getAll().values();
        }
        return lpiRates;
    }

    public class Parameter {
        public String coverOption {set; get;}
        public Integer term {set; get;}
        public Decimal initialAmount {set; get;}
    }  
    
    public class Result {
        public Decimal commission;
        public Decimal premium;
    }
}