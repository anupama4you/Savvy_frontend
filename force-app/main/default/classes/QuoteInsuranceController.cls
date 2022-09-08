public with sharing class QuoteInsuranceController {
    private static Map<String, Map<String, Liberty_VEI_Setting__c>> libVeiSettings = null; 
    private static Application__c application = null;
    private static Custom_Opportunity__c opp = null;

    @AuraEnabled
    public static Map<String, String> loadData(Id oppId){
        try {
            Map<String, String> result = new Map<String, String>();
            opp = getOpp(oppId);
            application = getApplication(opp.Application__c);
            
            if(application != null) {
                result.put('typeOfAsset', application.Type_of_Asset__c);
                // result.put('presentationStatus', presentationStatus);
            }
            return result;
        } catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getPresentationStatus(Id appQuoteId){
        try {
            Application_Quoting__c appQuote = null;
            String presentationStatus = null;
            Application_InsuranceQuote__c appInsuranceQuote = null;
            if(appQuoteId != null){
             appQuote = [SELECT Presentation_Email_Date__c, App_Insurance_Quote__c FROM Application_Quoting__c WHERE Id = :appQuoteId][0];
             System.debug('appquote >> '+ appQuote);
             if(appQuote.App_Insurance_Quote__c != null) {
                 appInsuranceQuote = [SELECT Customer_Choice_Status__c FROM Application_InsuranceQuote__c WHERE Id = :appQuote.App_Insurance_Quote__c][0];
                 System.debug('appInsuranceQuote >> '+ appInsuranceQuote.Customer_Choice_Status__c);
             }
             if(appInsuranceQuote != null){
                 presentationStatus = appInsuranceQuote.Customer_Choice_Status__c;
             } else {
                presentationStatus = 'NONE';
             }
            }
            return presentationStatus;
        } catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Decimal> calculateGAP(Id oppId, String option) {
        Map<String, Decimal> gap = new Map<String, Decimal>();
        Custom_Opportunity__c opp = getOpp(oppId);
        application = getApplication(opp.Application__c);
        String state = opp.State__c != null? opp.State__c: application.State__c;
        System.debug('Application  >> '+application);
        Liberty_VEI_Setting__c a = getLibertyVEISetting(state, option);
        if (a != null) {
            gap.put('gap', a.Retail__c); // retail price
            gap.put('gapIncome', a.Commission__c); // commission
        } else {
            gap.put('gap', 0.00);
            gap.put('gapIncome', 0.00);
        }
        return gap;
    }

    // Calculate Retail price and commission for Integrity
    @AuraEnabled
    public static Map<String, Decimal> calculateNWC(String category, String term, String type, Application_Quoting__c data){
        Map<String, Decimal> result = new Map<String, Decimal>();
        NWCCalc.Parameter nwcParam = new NWCCalc.Parameter();
        try {
            Custom_Opportunity__c opp = getOpp(data.Opportunity__c);
            application = getApplication(opp.Application__c);
            nwcParam.plan = category;
            nwcParam.term = term;
            nwcParam.type_p = type;
            nwcParam.state = application.State__c;
            nwcParam.assetType = 'Car'; // hard code here
            NWCCalc.Result r = NWCCalc.CalculateNWC(nwcParam);
            if(r != null){
                result.put('retailPrice', r.retailPrice);
                result.put('commission', r.commission);
            }else {
                result.put('retailPrice', 0.0);
                result.put('commission', 0.0);
            }
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Decimal> calculateLPI(Id oppId, Decimal term, String cciLevel, Application_Quoting__c data, Boolean iswarrantyAccept, Decimal warrantyRetailPrice){
        try {
            System.debug('data >> '+JSON.serialize(data));
            Map<String, Decimal> lpi = new Map<String, Decimal>();
            QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Liberty');
            Custom_Opportunity__c opp = getOpp(oppId);
            application = getApplication(opp.Application__c);
            param.totalAmount = getLPITotalAmount(QuotingCalculation.CALC_QUOTING, data,  iswarrantyAccept, warrantyRetailPrice);
            param.lpiLevel = cciLevel;
            param.state = application.State__c;
            param.term = term;
            param.dateOfBirth = application.Date_of_Birth_1__c;
            param.maritalStatus = application.Marital_Status_1__c;
            param.noOfDependants = application.No_of_Dependants_1__c;
            param.noOfPeople = application.No_of_People__c;
            System.debug('param in calculateLPI >> '+param);
            QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(param);
            if(p != null) {
                lpi.put('cci', p.premium);
                lpi.put('cciIncome', p.income);
            } else {
                lpi.put('cci', 0.0);
                lpi.put('cciIncome', 0.0);
            }
            return lpi;
        } catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void previewCustomerPresentation(){
        try {
            //storeQuotingData
            
        } catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void sendCustomerPresentation(Application_InsuranceQuote__c insurance, Application_Quoting__c quote){
        try {
            //storeQuotingData
            InsuranceQuoteUtils.resetProductAcceptance(quote, insurance);
            // this.resetInsuranceAcceptance();
            quote.Presentation_Email_Date__c = Datetime.now();
            System.debug('sending .... Cutsomoer');
            Custom_Opportunity__c opp = QuoteController.getOpportunityById(quote.Opportunity__c);
            Application__c application = getApplication(opp.Application__c);
            if(insurance.Id == null){
                insurance = InsuranceQuoteUtils.createDefaultInsuranceQuote(opp, quote);
                insurance.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
                insert insurance;
                InsuranceQuoteUtils.createDefaultMainDriver(opp, insurance);
              } else {
                insurance.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
                insurance.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
                update insurance;
            }
            insurance.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
            upsert insurance;
            quote.App_Insurance_Quote__c = insurance.Id;

              // Send the email
            EmailSender.sendCustomerInsurancePresentation(
                opp,
                InsuranceQuoteUtils.getPresentationUrlCode(opp.Application__c),
                InsuranceQuoteUtils.getPDSDocumentTypes(
                    quote,
                    insurance,
                    application.Type_of_Asset__c
             )
            );

        } catch (Exception e) {
            throw new GenericException(e.getMessage());
        }
    }

    private static Decimal getLPITotalAmount(String calcType, Application_Quoting__c data, Boolean iswarrantyAccept, Decimal warrantyRetailPrice) {
        Decimal r = 0.0;
        if(QuotingCalculation.CALC_PROTECTED.equals(calcType)){
            if (data.Vehicle_Price__c != null){
                r += data.Vehicle_Price__c + (data.Vehicle_Price__c * QuotingCalculation.getProtectedPercentaje(data.Vehicle_Price__c));
            }
        }else {
            r += (data.Vehicle_Price__c != null)? data.Vehicle_Price__c : 0;
        }
        r += (data.Application_Fee__c != null)? data.Application_Fee__c : 0;
        r += (data.DOF__c != null)? data.DOF__c : 0;
        r += (data.PPSR__c != null)? data.PPSR__c : 0;
        r -= data.Net_Deposit__c;

       // adding warranty part
       if(iswarrantyAccept) {
        r += warrantyRetailPrice > 0? warrantyRetailPrice : 0.00;
       } 
        
        return r;
      }

    private static Application__c getApplication(Id appId){
        try {
            List<Application__c> app = [SELECT Type_of_Asset__c, State__c, Date_of_Birth_1__c, Marital_Status_1__c, 
            No_of_Dependants_1__c, No_of_People__c
            FROM Application__c WHERE Id = :appId];
            System.debug('app[0] >>' + app[0]);
           return app[0];
        }
        catch (Exception ex) {
            throw new GenericException(ex.getMessage());
        }
    }

    private static Custom_Opportunity__c getOpp(Id oppId){
        try {
            Custom_Opportunity__c opp = QuoteController.getOpportunityById(oppId);
            return opp;
        }
        catch (Exception ex) {
            throw new GenericException(ex.getMessage());
        }
    }

    private static Liberty_VEI_Setting__c getLibertyVEISetting(String state, String option) {
        if (String.isBlank(state) || String.isBlank(option)) {
            return null;
        }
        String opt = 'Option 3';
        if (option.startsWith('Option 1')) {
          opt = 'Option 1';
        } else if (option.startsWith('Option 2')) {
          opt = 'Option 2';
        }
        if (libVeiSettings == null || libVeiSettings.isEmpty()) {
            //Load settings
            libVeiSettings = new Map<String, Map<String, Liberty_VEI_Setting__c>>();
            for (Liberty_VEI_Setting__c a : Liberty_VEI_Setting__c.getAll().values()) {
                Map<String, Liberty_VEI_Setting__c> x = libVeiSettings.get(a.State__c);
                if (x == null) {
                    x = new Map<String, Liberty_VEI_Setting__c>();
                    libVeiSettings.put(a.State__c, x);
                }
                x.put(a.Cover_Option__c, a);
            }
        }
        Liberty_VEI_Setting__c r = null;
        Map<String, Liberty_VEI_Setting__c> d = libVeiSettings.get(state);
        if (d != null && !d.isEmpty()) {
            r = d.get(opt);
        }
        return r;
    }

}