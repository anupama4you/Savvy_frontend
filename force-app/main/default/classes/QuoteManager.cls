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
    public static Map<String, Decimal> getBaseRatesManual(QuotingCalculation.CalcParam param, Decimal baseRateManual) {
      Decimal orig_br = 0.00;
      Decimal br = 0.00;
      Decimal max = 0.00;
      Decimal bp = param.brokeragePer;
      Decimal cr = param.clientRate;
      
      if (param.lender == 'Plenti Commercial') {
        orig_br = QuotingCalculation.getBaseRate(param);
        br = baseRateManual > 0 ? baseRateManual : orig_br;
        param.baseRate = br;
        cr = QuotingCalculation.getClientRateCalculation(param);
      }
      
      return new Map<String, Decimal>{
        'baseRate' => orig_br, 
        'maxRate' => max,
        'brokeragePer' => bp,
        'clientRate' => cr
      };
    }

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

        if (
          'RateSetter'.equals(param.calcName) ||
          'Plenti Commercial'.equals(param.calcName)          
        ) {
          // Opportunity
          result.opp = QuoteController.getOpportunity(
            param.oppId,
            new List<String>{
              'Application__c',
              'Application__r.No_of_People__c'
            }
          );
        }

        return result;
    }
    
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
    
    @AuraEnabled
     public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType, String lender){
        try {
            if( param.additionalProcess == null) {
                param.additionalProcess = new List<String>();
            }
            param.additionalProcess.add(approvalType);
            QuoteController.saveQuoting(param);
            Product__c p = null;
             if (!'NONE'.equals(approvalType) && !'SEND'.equals(approvalType) && !'PREVIEW'.equals(approvalType)) {
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
        PageReference pdf = QuoteController.createPdf(quote);
         
         // pass universal variables
         pdf.getParameters().put('id',quote.Opportunity__c);

         if (lender.equals('Macquarie Consumer')) {
            pdf.getParameters().put('lender', 'MACQUARIE CONSUMER CALCULATION');
         } else {
            pdf.getParameters().put('lender', 'MACQUARIE COMMERCIAL CALCULATION');
         }

         //Financial Details
         pdf.getParameters().put('assetType', quote.Goods_type__c+'');

         pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
         pdf.getParameters().put('residualValuePercentage', NumberUtils.format(quote.Residual_Value_Percentage__c));
         pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
         pdf.getParameters().put('customerProfile', quote.Customer_Profile__c+'');
         pdf.getParameters().put('privateSales', quote.Private_Sales__c);
         pdf.getParameters().put('loanTypeDetail', String.valueOf(quote.Loan_Facility_Type__c));
         pdf.getParameters().put('riskFee', String.valueOf(quote.Risk_Fee__c));
         pdf.getParameters().put('productGoodsType', String.valueOf(quote.Goods_type__c));
         pdf.getParameters().put('isFinanceOne', 'true');
         pdf.getParameters().put('ltv', String.valueOf(quote.LTV__c));
         pdf.getParameters().put('carAge', String.valueOf(quote.Vehicle_Age__c));
         pdf.getParameters().put('productGoodsSubType', String.valueOf(quote.Goods_sub_type__c));
         pdf.getParameters().put('loanFrequency', String.valueOf(quote.Loan_Frequency__c));
 
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