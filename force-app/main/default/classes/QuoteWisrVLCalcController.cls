public with sharing class QuoteWisrVLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        String rateObjName = param.rateSettings.get(0);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    public static List<WisrVL_Rates__c> getRates() {
        List<WisrVL_Rates__c> r = [
            SELECT
                Id,
                Profile__c,
                Credit_Score_Start__c,
                Credit_Score_End__c,
                Rate_1__c,
                Rate_2__c,
                Rate_3__c,
                Rate_4__c,
                Comparison_Rate__c
            FROM WisrVL_Rates__c
            ORDER BY Profile__c DESC, Credit_Score_Start__c DESC
        ];
        return r;
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

    // Lee - 18/07/2022
    public static PageReference pdfHandler(Application_Quoting__c quote){

        // pass parameters to the PDF page
        PageReference pdf = Page.UniversalCalculatorPdf;
        
        // pass universal variables
        pdf.getParameters().put('id',quote.Opportunity__c);
        pdf.getParameters().put('lender', 'WISR CAR LOAN CALCULATION');

        //Financial Details
        pdf.getParameters().put('loanType',  quote.Loan_Type__c+'');
        pdf.getParameters().put('loanProduct', quote.Loan_Product__c+'');
        pdf.getParameters().put('price', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
        pdf.getParameters().put('ppsr',  NumberUtils.format(quote.PPSR__c));
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
        pdf.getParameters().put('term', NumberUtils.format(quote.Term__c));
        pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
        pdf.getParameters().put('profile', quote.Customer_Profile__c+'');
        pdf.getParameters().put('vehicleYear', quote.Vehicle_Age__c+'');
        pdf.getParameters().put('lvr', String.valueOf(quote.LTV__c)+'');
        pdf.getParameters().put('paymentType', quote.Payment__c+'');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c+'');
        pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
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

    @AuraEnabled
    // Lee - 18/07/2022
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use': 'Business Use';
        p.Lender__c = 'Wisr VL';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Term__c = quote.Term__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00; 
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;

        return p;
    }
}