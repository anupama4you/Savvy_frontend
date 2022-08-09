public class QuoteManager {
    @AuraEnabled(cacheable=true)
    public static List<QuoteWrapper.Table> getQuotingTable(String LENDER_QUOTING) {
        if(LENDER_QUOTING == 'Plenti'){
           return getPlentiRate(); 
        }else if(LENDER_QUOTING == 'Plenti Commercial'){
           return getPlentiCommercialRate(); 
        }else if(LENDER_QUOTING == 'Plenti PL'){
           return getPlentiPLRate(); 
        }else if(LENDER_QUOTING == 'Plenti PL Fee'){
           return getPlentiPLFee(); 
        }else if(LENDER_QUOTING == 'Macquarie Consumer'){
           return getMacquarieConsumerRate(); 
        }else if(LENDER_QUOTING == 'Macquarie Commercial'){
           return getMacquarieCommercialRate(); 
        }else if(LENDER_QUOTING == 'Money 3'){
           return getMoney3Rate(); 
        }
        else{
           return null;
        }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteWrapper.Picklist> getPickListValue(String LENDER_QUOTING, String picklistName) {
        List<QuoteWrapper.Picklist> options = new List<QuoteWrapper.Picklist>();
        if(LENDER_QUOTING == 'Macquarie Commercial' && picklistName== 'Goods Type'){
            try{
                List<Message_Codes__c> codes = Utilities.getListMessageCodes(MacquarieConstants.DOMAIN_ASSET_TYPE);
                for (Message_Codes__c mc: codes){
                    /*if (loanProduct.startsWith('Consumer') && !mc.code__c.contains('MOTOV') && !mc.code__c.contains('LIFES')){
                        continue;
                    }*/
                    QuoteWrapper.Picklist pickVal = new QuoteWrapper.Picklist();
                    pickVal.label = mc.description__c;
                    pickVal.value = mc.code__c;
                    options.add(pickVal);
                }
            }catch (Exception ex){
                ex.getStackTraceString();
                System.debug('Product goods Type error:  ' + ex.getMessage());
            }
        }else if((LENDER_QUOTING == 'Macquarie Commercial' || LENDER_QUOTING == 'Macquarie Consumer') && picklistName== 'Asset Year'){
            QuoteWrapper.Picklist pickVal0 = new QuoteWrapper.Picklist();
            pickVal0.label = 'None';
            pickVal0.value = '';
            options.add(pickVal0);
            Integer y = Date.today().year();
            for(Integer i = y;i >= y - 4;i--) {
                QuoteWrapper.Picklist pickVal = new QuoteWrapper.Picklist();
                pickVal.label = (i == y - 4) ? String.valueOf(i) + ' or older' : String.valueOf(i);
                pickVal.value = String.valueOf(i);
                options.add(pickVal);
            }
            /*SelectOption myOp = manufactureYearOptions.get(manufactureYearOptions.size()-1);
            myOp.setLabel(myOp.getValue() + ' or older');*/
            
        }
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteWrapper.Picklist> getDependentPickListValue(String LENDER_QUOTING, String picklistName, String pickVal1, String pickVal2) {
        List<QuoteWrapper.Picklist> options = new List<QuoteWrapper.Picklist>();
        QuoteWrapper.Picklist pickVal0 = new QuoteWrapper.Picklist();
        pickVal0.label = 'None';
        pickVal0.value = '';
        options.add(pickVal0);
        if((LENDER_QUOTING == 'Macquarie Commercial' || LENDER_QUOTING == 'Macquarie Consumer') && picklistName== 'Goods SubType'){
            try{
                Message_Codes__c product = Utilities.getMessageCode_Description(pickVal1);
                String domain = 'CM'+ '-' + pickVal2;
                if (product != null){
                    domain = product.code__c + '-' + pickVal2;
                }
                List<Message_Codes__c> codes =  Utilities.getListMessageCodes(domain);
                for (Message_Codes__c mc: codes){
                    QuoteWrapper.Picklist pickVal = new QuoteWrapper.Picklist();
                    pickVal.label = mc.description__c;
                    pickVal.value = mc.code__c;
                    options.add(pickVal);
                }
            }catch (Exception ex){
                ex.getStackTraceString();
                System.debug('Product goods SubType error:  ' + ex.getMessage());
            }
        }else if((LENDER_QUOTING == 'Macquarie Commercial' || LENDER_QUOTING == 'Macquarie Consumer') && picklistName== 'Loan Frequency'){
            List<Message_Codes__c> codes = Utilities.getListMessageCodes(MacquarieConstants.LOAN_FREQUENCY);
            if (String.isNotBlank(pickVal1)) {
                for (Message_Codes__c mc: codes){
                    if (pickVal1.startsWith('Chattel') && !mc.code__c.contains('MONT')){
                        continue;
                    }
                    QuoteWrapper.Picklist pickVal = new QuoteWrapper.Picklist();
                    pickVal.label = mc.description__c;
                    pickVal.value = mc.code__c;
                    options.add(pickVal);
                }
            }
        }else if(LENDER_QUOTING == 'Macquarie Consumer' && picklistName== 'Goods Type'){
            try{
                List<Message_Codes__c> codes = Utilities.getListMessageCodes(MacquarieConstants.DOMAIN_ASSET_TYPE);
                for (Message_Codes__c mc: codes){
                    if (pickVal1.startsWith('Consumer') && !mc.code__c.contains('MOTOV') && !mc.code__c.contains('LIFES')){
                        continue;
                    }
                    QuoteWrapper.Picklist pickVal = new QuoteWrapper.Picklist();
                    pickVal.label = mc.description__c;
                    pickVal.value = mc.code__c;
                    options.add(pickVal);
                }
            }catch (Exception ex){
                ex.getStackTraceString();
                System.debug('Product goods Type error:  ' + ex.getMessage());
            }
        } 
        return options;
    }
    
    public static List<QuoteWrapper.Table> getPlentiRate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        for(RateSetterRate__c rec : [SELECT Profile__c, Tier__c, Overs__c, Min_Equifax_Score__c, 
                                     Rate0__c, Rate1__c, Rate2__c, Rate3__c, Rate4__c
                                     FROM RateSetterRate__c Where Overs__c != null ORDER BY Name ])
        {
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Profile = rec.Profile__c;
            table.Tier = rec.Tier__c;
            table.Min_Equifax_Score = rec.Min_Equifax_Score__c;
            table.Overs = rec.Overs__c+'%';
            table.Rate0 = rec.Rate0__c+'%';
            table.Rate1 = rec.Rate1__c+'%';
            table.Rate2 = rec.Rate2__c+'%';
            table.Rate3 = rec.Rate3__c+'%';
            table.Rate4 = rec.Rate4__c+'%';
            tableList.add(table);
        }
        return tableList;
    }
    
    public static List<QuoteWrapper.Table> getPlentiCommercialRate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        for(RateSetterRate__c rec : [SELECT Profile__c, Tier__c, Rate1__c, Rate2__c, Rate3__c, Rate4__c
              FROM RateSetterRate__c WHERE Profile__c != null AND Loan_Product__c = 'Commercial' ORDER BY Name])
        {
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Profile = rec.Profile__c;
            table.Tier = rec.Tier__c;
            table.Rate1 = rec.Rate1__c+'%';
            table.Rate2 = rec.Rate2__c+'%';
            table.Rate3 = rec.Rate3__c+'%';
            table.Rate4 = rec.Rate4__c+'%';
            tableList.add(table);
        }
        return tableList;
    }

    public static List<QuoteWrapper.Table> getPlentiPLRate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        List<RateSetterPLRates__c> r = RateSetterPLRates__c.getAll().values();
    	r.sort();
        
        for(RateSetterPLRates__c rec : r)
        {
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Name = rec.Name;
            table.Rate = rec.Rate__c+'%';
            table.Type = rec.Type__c;
            
            tableList.add(table);
        }
        return tableList;
    }
    public static List<QuoteWrapper.Table> getPlentiPLFee() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        List<RateSetterPLAppfee__c> r = RateSetterPLAppfee__c.getAll().values();
        r.sort();
        
        for(RateSetterPLAppfee__c rec : r)
        {
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Min = rec.Min__c;
            table.Max = rec.Max__c;
            table.X6 = rec.X6__c;
            table.X9 = rec.X9__c;
            table.X12 = rec.X12__c;
            table.X18 = rec.X18__c;
            table.X24 = rec.X24__c;
            table.X36 = rec.X36__c;
            table.X48 = rec.X48__c;
            table.X60 = rec.X60__c;
            
            tableList.add(table);
        }
        return tableList;
    }  
    
    public static List<QuoteWrapper.Table> getMacquarieConsumerRate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        String loanProduct = 'Consumer';
        Map<String, List<MacquarieConsumerRatesv2__c>> macquarieRatesMap;
        if (String.isNotBlank(loanProduct)) {
            if (macquarieRatesMap == null) {
                List<MacquarieConsumerRatesv2__c> d = MacquarieConsumerRatesv2__c.getAll()
                    .values();
                d.sort();
                macquarieRatesMap = new Map<String, List<MacquarieConsumerRatesv2__c>>();
                for (MacquarieConsumerRatesv2__c a : d) {
                    List<MacquarieConsumerRatesv2__c> m = macquarieRatesMap.get(
                        a.Loan_Product__c
                    );
                    if (m == null) {
                        m = new List<MacquarieConsumerRatesv2__c>();
                        macquarieRatesMap.put(a.Loan_Product__c, m);
                    }
                    m.add(a);
                }
            }
        }
        for(MacquarieConsumerRatesv2__c rec : macquarieRatesMap.get(loanProduct)){
            system.debug(rec);
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Product = rec.Product__c;
            table.Profile = rec.Profile__c;
            table.Year = rec.Year__c;
            table.R1 = rec.R1__c == null ? '' : rec.R1__c+'%';
            table.R2 = rec.R2__c == null ? '' : rec.R2__c+'%';
            table.R3 = rec.R3__c == null ? '' : rec.R3__c+'%';
            tableList.add(table);
        }
        
        return tableList;
    }  
    
    public static List<QuoteWrapper.Table> getMacquarieCommercialRate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        String loanProduct = 'Commercial';
        Map<String, List<MacquarieConsumerRatesv2__c>> macquarieRatesMap;
        if (String.isNotBlank(loanProduct)) {
            if (macquarieRatesMap == null) {
                List<MacquarieConsumerRatesv2__c> d = MacquarieConsumerRatesv2__c.getAll()
                    .values();
                d.sort();
                macquarieRatesMap = new Map<String, List<MacquarieConsumerRatesv2__c>>();
                for (MacquarieConsumerRatesv2__c a : d) {
                    List<MacquarieConsumerRatesv2__c> m = macquarieRatesMap.get(
                        a.Loan_Product__c
                    );
                    if (m == null) {
                        m = new List<MacquarieConsumerRatesv2__c>();
                        macquarieRatesMap.put(a.Loan_Product__c, m);
                    }
                    m.add(a);
                }
            }
        }
        for(MacquarieConsumerRatesv2__c rec : macquarieRatesMap.get(loanProduct)){
            system.debug(rec);
            QuoteWrapper.Table table = new QuoteWrapper.Table();
            table.Product = rec.Product__c;
            table.Profile = rec.Profile__c;
            table.Year = rec.Year__c;
            table.R1 = rec.R1__c == null ? '' : rec.R1__c+'%';
            table.R2 = rec.R2__c == null ? '' : rec.R2__c+'%';
            table.R3 = rec.R3__c == null ? '' : rec.R3__c+'%';
            tableList.add(table);
        }
        return tableList;
    } 
    
    public static List<QuoteWrapper.Table> getMoney3Rate() {
        List<QuoteWrapper.Table> tableList = new List<QuoteWrapper.Table>();
        
        return tableList;
    } 
}