public class QuoteManager {
    public class lenderSettingsWrapper {
        @AuraEnabled 
        public Decimal applicationFee {set;get;} 
        @AuraEnabled
        public Decimal dof {set;get;}
        
    }
    
    @AuraEnabled
    public static QuotingCalculation.CalcParam getRateSetterRate(QuotingCalculation.CalcParam param) {
        system.debug('QuoteManager param*** ==>'+param);
        RateSetterRate__c rate = QuotingCalculation.getRateSetterRate(param);
        if (rate != null) {
            param.commRate = rate.Overs__c;
        }
        return param;
    }
    
    @AuraEnabled
    public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
        Decimal br = 0.00;
        Decimal max = 0.00;
        Decimal bp = param.brokeragePer;
        Decimal cr = param.clientRate;
        
        if(param.lender == 'RateSetter'){
            br = QuotingCalculation.getBaseRate(param);
            max = br > 0? br + 2: 0.00;
        }else if(param.lender == 'Money3'){
            br = QuotingCalculation.getBaseRate(param);
        }else if(param.lender == 'Macquarie Consumer'){
            br = QuotingCalculation.getBaseRate(param);
            bp = 0.0;
        }else if(param.lender == 'Macquarie Commercial'){
            br = QuotingCalculation.getBaseRate(param);
            cr = QuotingCalculation.getClientRateCalculation(param);
        }
        
        return new Map<String, Decimal>{'baseRate' => br, 
            'maxRate' => max,
            'brokeragePer' => bp,
            'clientRate' => cr
            };
                }
    
    @AuraEnabled
    public static Map<String, Decimal> getBaseRatesManual(QuotingCalculation.CalcParam param, Integer baseRateManual) {
        Decimal orig_br = 0.00;
        Decimal br = 0.00;
        Decimal max = 0.00;
        Decimal bp = param.brokeragePer;
        Decimal cr = param.clientRate;
        
        if(param.lender == 'Plenti Commercial'){
            orig_br = QuotingCalculation.getBaseRate(param);
            br = baseRateManual > 0 ? baseRateManual : orig_br;
            param.baseRate = br;
            cr = QuotingCalculation.getClientRateCalculation(param);
        }
        
        
        return new Map<String, Decimal>{'baseRate' => orig_br, 
            'maxRate' => max,
            'brokeragePer' => bp,
            'clientRate' => cr
            };
                }
                
    /*public static Decimal getNafValidation(String calcType, QuotingCalculation.CalcParam param) {
        Decimal r = 0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (param.vehiclePrice != null) r += param.vehiclePrice + (param.vehiclePrice * QuotingCalculation.getProtectedPercentaje(param.vehiclePrice));
        } else {
            if (param.vehiclePrice != null) r += param.vehiclePrice;
        }
        r -= param.totalAmount;
        return r;
    }*/
    
    @AuraEnabled
    public static Map<String, Decimal> getFees(QuotingCalculation.CalcParam param, lenderSettingsWrapper lenderSettings, Boolean onlyMax) {
        Decimal resAF = 0.00;
        Decimal resMAF = 0.00;
        Decimal resDOF = 0.00;
        Decimal resMDOF = 0.00;
        Decimal riskFee = 0.00;
        Decimal riskFeeTotal = 0.00;
        
        if(param.lender == 'RateSetter PL'){
            Decimal r = 0;
            if (param.vehiclePrice != null)
                r += param.vehiclePrice;            
            r = r * 0.1;
            
            if (r > 2500) {
                r = 2500.00;
            }
            resMDOF = r.setScale(2);
        }else if(param.lender == 'Money3'){
            Decimal r = 0.0;
            if (
                param != null &&
                param.riskFeeBase != null &&
                param.riskFeeBase > 12000
            ) {
                r = param.riskFeeBase * 5 / 100.0;
                if (r > 995.0) {
                    r = 995.0;
                }
            }
            riskFee = r.setScale(2);
            riskFeeTotal = r.setScale(2);
            resDOF = QuotingCalculation.getMoney3maxDof(param);
            resMDOF = QuotingCalculation.getMoney3maxDof(param);
        }
        
        return new Map<String, Decimal>{'applicationFee' => resAF,
            'maxApplicationFee' => resMAF,
            'dof' => resDOF,
            'maxDof' => resMDOF,
            'riskFee' => riskFee,
            'riskFeeTotal' => riskFeeTotal
            };
                }
    
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper result = QuoteController.getQuotingData(param);
        Map<String, List<Sobject>> ratesMap = new Map<String, List<Sobject>>();
        if(param.calcName == 'RateSetter'){
            List<RateSetterRate__c> r = new List<RateSetterRate__c>();
            List<RateSetterRate__c> rates = RateSetterRate__c.getAll().values();
            r.sort();
            for (RateSetterRate__c g: rates) {
                r.add(g);
            }
            ratesMap.put(param.rateSettings.get(0), r);
        }else if(param.calcName == 'Plenti Commercial'){
        	List<RateSetterRate__c> r = [SELECT Profile__c, Tier__c, Rate1__c, Rate2__c, Rate3__c, Rate4__c
              FROM RateSetterRate__c WHERE Profile__c != null AND Loan_Product__c = 'Commercial' ORDER BY Name];
            ratesMap.put(param.rateSettings.get(0), r);        
        }else if(param.calcName == 'RateSetter PL'){
            List<RateSetterPLRates__c> r = RateSetterPLRates__c.getAll().values();
            r.sort();
            ratesMap.put(param.rateSettings.get(0), r);
            
            List<RateSetterPLAppfee__c> r2 = RateSetterPLAppfee__c.getAll().values();
            r2.sort();
            ratesMap.put(param.rateSettings.get(1), r2);
            
        }else if(param.calcName == 'Macquarie Consumer'){
            List <MacquarieConsumerRatesv2__c> d = QuotingCalculation.getMacquarieRates('Consumer');
            List <MacquarieConsumerRatesv2__c> r = new List <MacquarieConsumerRatesv2__c>();
            for (MacquarieConsumerRatesv2__c a: d) {
                r.add(a);
            }
            ratesMap.put(param.rateSettings.get(0), r);
        }else if(param.calcName == 'Macquarie Commercial'){
            List <MacquarieConsumerRatesv2__c> d = QuotingCalculation.getMacquarieRates('Commercial');
            List <MacquarieConsumerRatesv2__c> r = new List <MacquarieConsumerRatesv2__c>();
            for (MacquarieConsumerRatesv2__c a: d) {
                r.add(a);
            }
            ratesMap.put(param.rateSettings.get(0), r);
        }
        result.rateSettings = ratesMap;
        return result;
    }
    /*
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingDataRateSetter(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'RateSetterRate__c';

        Map<String, List<RateSetterRate__c>> rates = new Map<String, List<RateSetterRate__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }
    
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingDataPlentiPL(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'RateSetterPLRates__c';

        Map<String, List<RateSetterRate__c>> rates = new Map<String, List<RateSetterRate__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }
    
    
    
    //This method will use to return data record to ratesetter table rates
    public static List<RateSetterRate__c> getRates() {
        List<RateSetterRate__c> r = new List<RateSetterRate__c>();
        List<RateSetterRate__c> rates = RateSetterRate__c.getAll().values();
        r.sort();
        for (RateSetterRate__c g: rates) {
          //if (String.isBlank(g.LVR__C)) {
            r.add(g);
          //}
        }
        return r;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteWrapper.Table> getQuotingTable(String LENDER_QUOTING) {
        if(LENDER_QUOTING == 'RateSetter'){
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
        
    }*/
    
    @AuraEnabled(cacheable=true)
    public static Lenders__c getLenderSetting(String LENDER_QUOTING) {
        Map<String, Lenders__c> lenderSettingsMap;
        Lenders__c r = null;
        if (lenderSettingsMap == null) {
            lenderSettingsMap = new Map<String, Lenders__c>();
            for (Lenders__c a : Lenders__c.getAll().values()) {
                lenderSettingsMap.put(a.lender__c, a);
            }
        }
        return lenderSettingsMap.get(LENDER_QUOTING);
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
    
    /*public static List<QuoteWrapper.Table> getPlentiRate() {
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
    } */

    @AuraEnabled
     public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType, String lender){
        try {
             QuoteController.saveQuoting(param);
             Product__c p = null;
             if (!'NONE'.equals(approvalType)) {
                 // save pdf
                 PageReference pdf = Page.UniversalCalculatorPdf;
                 pdf = pdfHandler(param.data, lender);
                 QuoteController.savePdf(approvalType, pdf, param);
                 // save product
                 p = productHandler(param.data);
                 QuoteController.saveProduct(param, p);
             }
        }
        catch (Exception ex) {
         throw new GenericException(ex.getMessage());
        }
         return param.data;
     }
 
     public static PageReference pdfHandler(Application_Quoting__c quote, String lender){
 
         // pass parameters to the PDF page
         PageReference pdf = Page.UniversalCalculatorPdf;
         
         // pass universal variables
         pdf.getParameters().put('id',quote.Opportunity__c);

         if (lender.equals('Macquarie Consumer')) {
            pdf.getParameters().put('lender', 'MACQUARIE CONSUMER CALCULATION');
         } else {
            pdf.getParameters().put('lender', 'MACQUARIE COMMERCIAL CALCULATION');
         }

         //Financial Details
         pdf.getParameters().put('loanType',  quote.Loan_Type__c+'');
         pdf.getParameters().put('productLoanType',  quote.Loan_Product__c+'');
         pdf.getParameters().put('assetType', quote.Goods_type__c+'');
         pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
         pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
         pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
         pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
         pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
         pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
         pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));
         pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
         pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
         pdf.getParameters().put('term', NumberUtils.format(quote.Term__c));
         pdf.getParameters().put('paymentType', quote.Payment__c+'');
         pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
         pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
         pdf.getParameters().put('residualValuePercentage', NumberUtils.format(quote.Residual_Value_Percentage__c));
         pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
         pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
         pdf.getParameters().put('customerProfile', quote.Customer_Profile__c+'');
         pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
         pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));                                                                                                                                                                                                    
         pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
         pdf.getParameters().put('loanTypeDetail', String.valueOf(quote.Loan_Facility_Type__c));
         pdf.getParameters().put('riskFee', String.valueOf(quote.Risk_Fee__c));
         pdf.getParameters().put('productGoodsType', String.valueOf(quote.Goods_type__c));
         pdf.getParameters().put('isFinanceOne', 'true');
         pdf.getParameters().put('ltv', String.valueOf(quote.LTV__c));
         pdf.getParameters().put('carAge', String.valueOf(2022));
         pdf.getParameters().put('productGoodsSubType', String.valueOf(quote.Goods_sub_type__c));
         pdf.getParameters().put('loanFrequency', String.valueOf(quote.Loan_Frequency__c));

         // ---- commissions -----
         pdf.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
         pdf.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));                                                                           
         pdf.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
         pdf.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
         pdf.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
         pdf.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
         pdf.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
         pdf.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
         pdf.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
         pdf.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
         // ---- end commissions -----
 
         return pdf;
 
     }
 
     public static Product__c productHandler(Application_Quoting__c quote) {
         Product__c p = QuoteController.getProduct(quote.Opportunity__c);
         p.Loan_Purpose__c = 'Business Use';
         p.Lender__c = 'Shift';
         p.Quoting_Source__c = quote.Name;
         p.Repayment_Regularity__c = 'Monthly';
         p.Loan_Type__c = quote.Loan_Type__c;
         p.Loan_Type_Detail__c = quote.Loan_Facility_Type__c;
         p.Loan_Product__c = quote.Loan_Product__c;
         p.Loan_Term__c = quote.Term__c;
         p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
         p.Client_Rate__c = quote.Client_Rate__c;
         p.Payments__c = quote.Repayment_Weekly__c;
         p.Cost_of_Goods__c = quote.Vehicle_Price__c;
         p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
         p.DOF__c = quote.DOF__c;
         p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
         p.Lender_App_Fee__c = quote.Application_Fee__c;
         p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
 
         return p;
     }
}