public with sharing class QuoteInsuranceController {
    private static Map<String, Map<String, Liberty_VEI_Setting__c>> libVeiSettings = null; 
    private static Application__c application = null;
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

    @AuraEnabled
    public static Map<String, Decimal> calculateLPI(Id oppId, Decimal term, String cciLevel, Application_Quoting__c data){
        try {
            Map<String, Decimal> lpi = new Map<String, Decimal>();
            QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Liberty');
            Custom_Opportunity__c opp = getOpp(oppId);
            application = getApplication(opp.Application__c);
            param.totalAmount = getLPITotalAmount(QuotingCalculation.CALC_QUOTING, data);
            param.lpiLevel = cciLevel;
            param.state = application.State__c;
            param.term = term;
            param.dateOfBirth = application.Date_of_Birth_1__c;
            param.maritalStatus = application.Marital_Status_1__c;
            param.noOfDependants = application.No_of_Dependants_1__c;
            param.noOfPeople = application.No_of_People__c;
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

    private static Decimal getLPITotalAmount(String calcType, Application_Quoting__c data) {
        Decimal r = 0.0;
        // r = getTotalAmount(calcType);
        // if ('A'.equals(this.warrantyAcceptance) && 'Financed'.equals(this.warrantyPayType))  {
        //   //Eric Insurance
        //   r += this.warranty > 0? this.warranty : 0.00;
        // } else if ('A'.equals(this.nwcAcceptance)) {
        //   //Manual Insurances
        //   r += this.nwc > 0? this.nwc : 0.00;
        // }
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
        return r;
      }

    private static Application__c getApplication(Id appId){
        try {
            List<Application__c> app = [SELECT State__c, Date_of_Birth_1__c, Marital_Status_1__c, 
            No_of_Dependants_1__c, No_of_People__c
            FROM Application__c WHERE Id = :appId];
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