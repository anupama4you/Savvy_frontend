public with sharing class QuoteShiftAssetCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        String rateObjName1 = param.rateSettings.get(0);
        String rateObjName2 = param.rateSettings.get(1);
        String rateObjName3 = param.rateSettings.get(2);
        String rateObjName4 = param.rateSettings.get(3);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName1, getAFRate1());
        rates.put(rateObjName2, getAFRate2());
        rates.put(rateObjName3, getAFRate3());
        rates.put(rateObjName4, getAFRate4());
        r.rateSettings = rates;
        r.settings = QuotingCalculation.getLenderSettings(ShiftAssetExtension.LENDER_QUOTING);
        return r;
    }

    private static List <Get_Capital_Rates__c> getAFRate1() {
        List <Get_Capital_Rates__c> AFRate1 = 
        [Select Name, Age_of_Asset__c , Non_Property_Backed__c , Property_Backed__c , Type_of_Asset__c from Get_Capital_Rates__c where Princing_fees_and_commission__c = 'Up to $250,000' order by Name asc];
        return AFRate1;
    }

    private static List <Get_Capital_Rates__c> getAFRate2() {
        List <Get_Capital_Rates__c> AFRate1 = 
        [Select Name, Age_of_Asset__c , Non_Property_Backed__c , Property_Backed__c , Type_of_Asset__c from Get_Capital_Rates__c where Princing_fees_and_commission__c = 'Over $250,000' order by Name asc];
        return AFRate1;
    }

    private static List <Get_Capital_Rates__c> getAFRate3() {
        List <Get_Capital_Rates__c> AFRate1 = 
        [Select Name, Add_ons__c, Description__c from Get_Capital_Rates__c where Add_ons__c != null AND Description__c != null order by Name asc];
        return AFRate1;
    }

    private static List <Get_Capital_Rates__c> getAFRate4() {
        List <Get_Capital_Rates__c> AFRate1 = 
        [Select Name, Loan_Amount__c, Maximum_commission_Inc_GST__c from Get_Capital_Rates__c where Maximum_commission_Inc_GST__c != null order by Name asc];
        return AFRate1;
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
        pdf.getParameters().put('lender', 'ANGLE FINANCE CALCULATION');

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
        pdf.getParameters().put('productGoodsType', quote.Goods_type__c+'');
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));                                                                                                                                                                                                    
        pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
        
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