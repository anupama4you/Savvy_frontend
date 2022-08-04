public class QuoteManager {
    @AuraEnabled(cacheable=true)
    public static List<QuoteWrapper.Table> getQuotingTable(String LENDER_QUOTING) {
        if(LENDER_QUOTING == 'Plenti'){
           return getPlentiRate(); 
        }else if(LENDER_QUOTING == 'Plenti Commercial'){
           return getPlentiCommercialRate(); 
        }else if(LENDER_QUOTING == 'Plenti PL'){
           return getPlentiPLRate(); 
        }
        else{
           return null;
        }
        
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
            table.Overs = rec.Overs__c;
            table.Rate0 = rec.Rate0__c;
            table.Rate1 = rec.Rate1__c;
            table.Rate2 = rec.Rate2__c;
            table.Rate3 = rec.Rate3__c;
            table.Rate4 = rec.Rate4__c;
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
            table.Rate1 = rec.Rate1__c;
            table.Rate2 = rec.Rate2__c;
            table.Rate3 = rec.Rate3__c;
            table.Rate4 = rec.Rate4__c;
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
            table.Rate = rec.Rate__c;
            table.Type = rec.Type__c;
            
            tableList.add(table);
        }
        return tableList;
    }    
    
    
}