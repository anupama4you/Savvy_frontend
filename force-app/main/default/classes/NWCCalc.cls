public class NWCCalc {

    
    public class Parameter {
        public String state {set; get;}
        public String assetType {set; get;}
        public String plan {set; get;}
        public String term {set; get;}
        public String type_p {set; get;}
        public String awd4wd {set; get;}
        public String luxuryCar {set; get;}
        //public String engine {set; get;}
        public Boolean isManuallyNWCPrice {set; get;}
        public Decimal nwcPriceToCustomer {set; get;}
        public Integer vehicleAgeYears {set; get;}
        public Decimal actualKm {set; get;}
        public Boolean isIntegrity { 
          get {
            return (
              'Integrity'.equalsIgnoreCase(this.type_p) &&
              !String.isBlank(this.plan) &&
              !String.isBlank(this.term)
            );
          }
          set;
        }
        
        public Parameter(){
            isManuallyNWCPrice = false;
        }
        
    }  
    
    public class Result {
        public Decimal commission;
        public Decimal retailPrice;
        public String messageWarning;
    }
    
    public static Result CalculateNWC(Parameter parameters){
        Result results = new Result();
        Decimal stampDutyRate = 0;
        Decimal retailPrice = 0;

        results.messageWarning = null;

        //NWC exclude other assets
        if (!'Car'.equalsIgnoreCase(parameters.assetType)){
            System.debug('[Confg] - NWC is not available for Asset: ' + parameters.assetType + ' -Plan: ' + parameters.plan +  ' -Type: ' + parameters.type_p);
            results.commission = 0;
            results.retailPrice = 0;
            return results;
        }

        System.debug(':::::::::::::::::::::::::-1');
        if(parameters == null || StringUtils.isNullOrEmpty(parameters.plan) || StringUtils.isNullOrEmpty(parameters.term)){
            throw new GenericException ('[Parameters] - Please check parameter Object.');
        }
        //Stamp Duti Value
        List<StateStampDuties__c> r = null;
        System.debug(':::::::::::::::::::::::::-2');
        if (!StringUtils.isNullOrEmpty(parameters.state)) {
            r = [select id, name, NWC__c from StateStampDuties__c where name =:parameters.state];
        }else{
           throw new GenericException ('[Parameters] - Missing value State. Please check the data.'); 
        }
        if (!(r != null && !r.isEmpty())) {
           throw new GenericException ('[Confg] - State Stamp Duty not found . Please check the confg.'); 
        } 
        System.debug(':::::::::::::::::::::::::-3');
        StateStampDuties__c stateDuty =  r.get(0);
        stampDutyRate = stateDuty.NWC__c / 100;
        
        //NWC Price
        List<NWCPriceList__c> nwcPriceList = null;
        SYstem.debug('-------__> ' + parameters.type_p);
        if (!StringUtils.isNullOrEmpty(parameters.plan) || !StringUtils.isNullOrEmpty(parameters.term) || !StringUtils.isNullOrEmpty(parameters.type_p)) {
            nwcPriceList = [select id, name, Price__c, Warranty__c from NWCPriceList__C 
                 	where Asset__c = :parameters.assetType and Plan__c =:parameters.plan and Term__c = :parameters.term and Type__c = :parameters.type_p];
        }else{
           throw new GenericException ('[Parameters] - Missing value Plan-Term-Type. Please check the data.'); 
        }
        
        NWCPriceList__c n = null;
        if (nwcPriceList != null && !nwcPriceList.isEmpty()) {
           n = nwcPriceList.get(0);
        } 
        if (n == null){
            //throw new GenericException ('[Confg] - NWC price list not found . Please check the confg.Asset: ' + parameters.assetType + ' -Plan: ' + parameters.plan +  ' -Type: ' + parameters.type_p);
       		System.debug('[Confg] - NWC price list not found . Please check the confg. Asset: ' + parameters.assetType + ' -Plan: ' + parameters.plan +  ' -Type: ' + parameters.type_p);
            results.commission = 0;
            results.retailPrice = 0;
            return results;
            //throw new GenericException ('[Confg] - NWC price list not found . Please check the confg. Asset: ' + parameters.assetType + ' -Plan: ' + parameters.plan +  ' -Type: ' + parameters.type_p); 
        }
        System.debug(':::::::::::::::::::::::::-4');
        //Sentinel plan wholesale priceSentinel plan wholesale price -  n.Price__c
        Decimal constant = 10;
        Decimal loading = 0;
        /**
        if ('Car'.equalsIgnoreCase(parameters.assetType) && 'Yes'.equalsIgnoreCase(parameters.awd4wd)){
            loading = 55;
        }
        if ('Car'.equalsIgnoreCase(parameters.assetType) && 'Yes'.equalsIgnoreCase(parameters.luxuryCar) && !'D'.equalsIgnoreCase(parameters.plan)){
            loading = loading + 55;
        }
        **/
        Decimal maxRetailPrice;
        Decimal minRetailPrice;
        if ('Car'.equalsIgnoreCase(parameters.assetType)){
            //get max retail price for Integrity Absolute and Integrity Endurance types
            if('Integrity Endurance'.equalsIgnoreCase(parameters.type_p) || 'Integrity Absolute'.equalsIgnoreCase(parameters.type_p)){
                maxRetailPrice = n.Price__c;
                minRetailPrice = n.Price__c;
            } else {
                constant = 0.29;
            
                maxRetailPrice = (n.Price__c + loading) * (1 + constant.divide(0.71, 15))*(1 + stampDutyRate);
                minRetailPrice = (n.Price__c + loading) * (1 + stampDutyRate);
            }
        }else{
            maxRetailPrice = ((n.Price__c + loading) * constant.divide(6, 15))*(1 + stampDutyRate);
            minRetailPrice = (n.Price__c + loading) * (1 + stampDutyRate);
        }
        
        //throw new GenericException ('[NWCCalc] - [Min: '+ minRetailPrice + ' / Max: ' + maxRetailPrice + ' / n.Price__c: ' + n.Price__c + ' / StampDutyRate: ' + stampDutyRate +']'); 
        
        
        System.debug(':::::::::::::::::::::::::-5');
        
        if (!parameters.isManuallyNWCPrice || parameters.nwcPriceToCustomer == null){
            parameters.nwcPriceToCustomer = maxRetailPrice;
        }
        
        //throw new GenericException ('[Calc] - Retail: '+ parameters.nwcPriceToCustomer + '[NWCCalc] - [Min: '+ minRetailPrice + ' / Max: ' + maxRetailPrice + ' / n.Price__c: ' + n.Price__c + ' / StampDutyRate: ' + stampDutyRate +']'); 
        System.debug(':::::::::::::::::::::::::-6');
        // Lelo - Validation commented
        // if (parameters.nwcPriceToCustomer < minRetailPrice ||  parameters.nwcPriceToCustomer > maxRetailPrice){
        //     throw new GenericException ('[Calc] - Price to customer value is not allowed. [Min: '+ 
        //                                 NumberUtils.convertToDecimal(minRetailPrice,2).format() + ' / Max: ' + NumberUtils.convertToDecimal(maxRetailPrice,2).format() +
        //                                 ' - Current value: '+ NumberUtils.convertToDecimal(parameters.nwcPriceToCustomer, 2) + ']'); 
        // }
        System.debug(':::::::::::::::::::::::::-7  ' + parameters.nwcPriceToCustomer + ' - ' + stampDutyRate + ' - ' );
        Decimal lessStampDuty = (parameters.nwcPriceToCustomer / (1 + stampDutyRate)) * stampDutyRate;
        Decimal subTotal = parameters.nwcPriceToCustomer - lessStampDuty;

        Decimal warrantyCost;
        if ('Car'.equalsIgnoreCase(parameters.assetType)){
            //get warranty cost from NWC Price List custom settings for Integrity Endurance and Integrity Absolute
            if('Integrity Endurance'.equalsIgnoreCase(parameters.type_p) || 'Integrity Absolute'.equalsIgnoreCase(parameters.type_p)){
                warrantyCost = n.Warranty__c;
            } else {
                warrantyCost = n.Price__c * (1 + stampDutyRate);
            }
        }else{
            warrantyCost = n.Price__c + lessStampDuty + loading;
        }
        System.debug(':::::::::::::::::::::::::-8 ' + warrantyCost);
        
        if (parameters.nwcPriceToCustomer >= warrantyCost){
            results.commission = NumberUtils.convertDecimalToScale(parameters.nwcPriceToCustomer - warrantyCost,2);
        }else{
            // throw new GenericException ('[NWCCalc] - Error.'); 
        }
        System.debug(':::::::::::::::::::::::::-9');
        //results.retailPrice = NumberUtils.convertDecimalToScale(maxRetailPrice, 2) ;
        results.retailPrice = NumberUtils.convertDecimalToScale(parameters.nwcPriceToCustomer, 2) ;
        //parameters.nwcPriceToCustomer = Math.floor(results.retailPrice);
        System.debug(':::::::::::::::::::::::::-10');
        return results;
    }
    
    public static List<SelectOption> NWCPlanOptions(String asset){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '----'));
        //List<AggregateResult> result = [SELECT Plan__c FROM NWCPriceList__c WHERE Asset__C = :asset group by Plan__c order by Plan__c asc];
        List<AggregateResult> result = [SELECT Plan__c, name FROM NWCPriceList__c WHERE Asset__C = :asset group by Plan__c, name order by name desc];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Plan__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }

    //New
    public static List<SelectOption> NWCPlanOptions(String asset, String typeNWC){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '----'));
        //List<AggregateResult> result = [SELECT Plan__c FROM NWCPriceList__c WHERE Asset__C = :asset group by Plan__c order by Plan__c asc];
        List<AggregateResult> result = [SELECT Plan__c, name FROM NWCPriceList__c WHERE Asset__C = :asset and Type__c = :typeNWC group by Plan__c, name order by name desc];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Plan__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }
    
    private static Boolean isTextOnList(List<String> lList, String look){
        for (String p : lList){
            if (p.equalsIgnoreCase(look)){
                return true;
            }
        }
        return false;
    }

    public static List<SelectOption> NWCTermOptions(String asset){
        return NWCTermOptions(asset, '');
    }

    public static List<SelectOption> NWCTermOptions(String asset, String typeNWC){
        return NWCTermOptions(asset, '', '');
    }
    
    public static List<SelectOption> NWCTermOptions(String asset, String typeNWC, String plan){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '----'));
        
        //List<AggregateResult> result = [SELECT Term__c FROM NWCPriceList__c WHERE Asset__C = :asset group by Term__c order by Term__c asc];
        List<AggregateResult> result = [SELECT Term__c, name FROM NWCPriceList__c WHERE Asset__C = :asset and Type__c = :typeNWC and Plan__c = :plan group by Term__c, name order by name];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Term__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }
    
    public static List<SelectOption> NWCTypeOptions(String asset, String plan){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '----'));
        List<AggregateResult> result = [SELECT Type__c, name FROM NWCPriceList__c WHERE Asset__C = :asset and Plan__c = :plan group by Type__c, name order by name desc];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Type__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }

    //New
    public static List<SelectOption> NWCTypeOptions(String asset){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '--None--'));
        
        List<AggregateResult> result = [SELECT Type__c, name FROM NWCPriceList__c WHERE Asset__C = :asset group by Type__c, name order by name];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Type__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }

    public static List<SelectOption> NWCTypeOptionsFiltered(String asset, List<String> typeList){
        List <SelectOption> options = new List <SelectOption> ();
        options.add(new SelectOption ('', '----'));
        
        List<AggregateResult> result = [SELECT Type__c, name FROM NWCPriceList__c WHERE Asset__C = :asset AND Type__c IN :typeList group by Type__c, name order by name];
        List<String> lList = new List<String>();
        for (AggregateResult d : result) {
            String r = (String) d.get('Type__c');
            if (!isTextOnList(lList, r)){
                options.add(new SelectOption (r, r));
                lList.add(r);
            }
        }
        return options;
    }
}