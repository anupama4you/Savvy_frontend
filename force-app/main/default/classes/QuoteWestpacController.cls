public without sharing class QuoteWestpacController {
    private static final String COMMERCIAL = 'COMMERCIAL';
    private static final String PRIMARY = 'OTHER - Primary';
    private static final String OTHER = 'OTHER - 2nd & 3rd';
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        // Lender settings
        // Rate Settings
        Map<String, String> rateObjNames = getRateObjName(param.rateSettings);
        Map<String, List<PepperRate__c>> rates = new Map<String, List<PepperRate__c>>();
        Map<String, List<PepperRate__c>> myRatesMap = getPepperRates();
        for ( String name : rateObjNames.keySet() ) {
            rates.put(rateObjNames.get(name), myRatesMap.get(name));
        }
        r.rateSettings = rates;
        return r;
    }

    private static Map<String, String> getRateObjName(List<String> settings) {
        Map<String, String> rateObjNames = new Map<String, String>();
        List<String> names = new List<String>{ 'PepperRate__c', 'PepperRate__c_2', 'PepperRate__c_3' };
        List<String> comNames = new List<String>{ COMMERCIAL, PRIMARY, OTHER };
        for ( Integer i = 0; i < settings.size(); ++i ) {
            String name = settings != null && !settings.isEmpty() ? settings.get(i) : names[i];
            rateObjNames.put(comNames[i], name);
        }
        return rateObjNames;
    }

    // COMMERCIAL
    // OTHER - 2nd & 3rd
    // OTHER - Primary
    private static Map<String, List<PepperRate__c>> getPepperRates() {
        Map<String, List<PepperRate__c>> resultMap = new Map<String, List<PepperRate__c>>();
        Set<String> prods = new Set<String>{ COMMERCIAL, PRIMARY, OTHER };
        List<PepperRate__c> d = [SELECT Product__c, Tier__c, Rate0__c, Rate1__c, 
                                        Rate2__c, Rate3__c
                                 FROM PepperRate__c
                                 WHERE Product__c IN:prods
                                 ORDER BY Name];
        List<PepperRate__c> rateList = new List<PepperRate__c>();
        for ( String prod : prods ) {
            resultMap.put(prod, new List<PepperRate__c>());
        }
        for ( PepperRate__c rate : d ) {
            resultMap.get(rate.Product__c).add(rate);
        }
        return resultMap;
    }

    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType) {
        try {
            QuoteController.saveQuoting(param);
            Product__c p = null;
            if ( !'NONE'.equals(approvalType) ) {
                // save pdf
                PageReference pdf = Page.UniversalCalculatorPdf;
                pdf = pdfHandler(param.data);
                QuoteController.savePdf(approvalType, pdf, param);
                // save product
                p = productHandler(param.data);
                QuoteController.saveProduct(param, p);
            }
        } catch ( Exception ex ) {
            throw new GenericException(ex.getMessage());
        }
        return param.data;
    }

    private static PageReference pdfHandler(Application_Quoting__c quote) {
        // pass parameters to the PDF page
        PageReference pdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        pdf.getParameters().put('id', quote.Opportunity__c);
        pdf.getParameters().put('lender', 'WESTPAC CALCULATION');
        //Financial Details
        pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
        pdf.getParameters().put('productLoanType', quote.Loan_Product__c + '');
        pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
        pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));
        pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
        pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
        pdf.getParameters().put('term', quote.Term__c + '');
        pdf.getParameters().put('paymentType', quote.Payment__c + '');
        pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('productGoodsType', quote.Goods_type__c + '');
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
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
        pdf.getParameters().put('carAge', quote.Vehicle_Age__c);
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('customerProfile', quote.Customer_Profile__c);
        pdf.getParameters().put('loanFrequency', quote.Loan_Frequency__c);

        return pdf;
    }

    private static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use' : 'Business Use';
        p.Lender__c = 'Westpac';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        // p.Loan_Type_Detail__c = 'Client Tier ' + quote.Client_Tier__c;
        p.Loan_Term__c = quote.Term__c;
        p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
        return p;
    }

}