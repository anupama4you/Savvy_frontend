public without sharing class QuoteFinanceOneController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'FinanceOneRates__c';

        Map<String, List<FinanceOneRates__c>> rates = new Map<String, List<FinanceOneRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    public static List<FinanceOneRates__c> getRates() {
        List<FinanceOneRates__c> res = new List<FinanceOneRates__c>();
        List<FinanceOneRates__c> rates = FinanceOneRates__c.getAll().values();
        if(rates != NULL && !rates.isEmpty()){
            rates.sort();
            for (FinanceOneRates__c fors: rates) {
                if(!'Commercial'.equalsIgnoreCase(fors.Category__c)){
                    res.add(fors);
                }
            }
        }
        return res;
    }

    ////Return Calc Risk Fee Calculations
    @AuraEnabled
    public static Decimal getRiskFeeCalc(QuotingCalculation.CalcParam param) {
        Decimal r = 0.0;
        Decimal nc = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        nc += param.totalInsurance;
        if (param.dof != null){
            nc+= param.dof;
        }

        if (String.isBlank(param.loanTypeDetail) || param.loanTypeDetail == 'Economy') {
            r = 0;
        } else if ('Consumer Loan'.equals(param.productLoanType) && 
                   ('Gold'.equals(param.loanTypeDetail) || 'Platinum'.equals(param.loanTypeDetail))) {
          r = 995.0;
        } else {
            if ((nc + 995.0) >= 5000 && (nc + 995.0) <= 12000) {
                r = 995.0;
            } else if ((nc + 1495.00) > 12000 && (nc + 1495.00) <= 20000) {
                r = 1495.00;
            } else if ((nc + 1495.00) > 20000) {
                r = 1995.00;
            } else {
                r = 0;
            }
        }
        return r.setScale(2);
    }

    //Return DOF and Max DOF Calculations
    @AuraEnabled
    public static Map<String, Decimal> getDofCalcu (QuotingCalculation.CalcParam param, Boolean fullCalc) {
        Decimal totalInsurance = param.totalInsurance;
        Decimal totalAmount = 0;
        Decimal dof = 0.0;
        Decimal maxDof = 0.0;
        if (param.vehiclePrice != null) totalAmount += param.vehiclePrice;
        totalAmount = totalAmount - param.netDeposit + totalInsurance;
        Decimal r = 0.0;
        
            if (param.loanTypeDetail == 'Economy') {
                r = 550.0;
                if (totalAmount >= 6000 && totalAmount < 7000) {
                    r = 660.0;
                } else if (totalAmount >= 7000 && totalAmount < 8000) {
                    r = 770.0;
                } else if (totalAmount >= 8000) {
                    r = 880.0;
                }
            } else {
                if (totalAmount >= 5000 && totalAmount <= 14000) {
                    r = 990.00;
                } else if (totalAmount > 14000) {
                    r = 1100.00;
                }
            }
        if (fullCalc){
            dof = r;
        } 
        maxDof = r;
        //System.debug(this.loanTypeDetail + '|' + totalAmount.format() + '|' + r.format() + '|max:' + this.maxDof + '|dof:' + this.dof);
        return new Map<String, Decimal>{'dof' => dof, 
                                        'maxDof' => maxDof
                                    };
    } 

     //Finance One Calculate Button Logic
     @AuraEnabled
     public static Application_Quoting_Result__c calculateRepayments (QuotingCalculation.CalcParam param){
         param.nafCommission = QuoteFinanceOneCommController.getNafCommission(param, QuotingCalculation.CALC_QUOTING);
         return QuoteController.calculateRepayments(param);
     }

     @AuraEnabled
     public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
        try {
             QuoteController.saveQuoting(param);
             Product__c p = null;
             if (!'NONE'.equals(approvalType)) {
                 // save pdf
                 PageReference pdf = Page.UniversalCalculatorPdf;
                 pdf = pdfHandler(param.data);
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
 
     public static PageReference pdfHandler(Application_Quoting__c quote){
 
         // pass parameters to the PDF page
         PageReference pdf = Page.UniversalCalculatorPdf;
         
         // pass universal variables
         pdf.getParameters().put('id',quote.Opportunity__c);
         pdf.getParameters().put('lender', 'FINANCE ONE CALCULATION');
 
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
         pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
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