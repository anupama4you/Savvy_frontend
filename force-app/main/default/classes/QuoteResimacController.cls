public without sharing class QuoteResimacController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        Map<String, List<Resimac_Rates__c>> rates = new Map<String, List<Resimac_Rates__c>>();
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() ? param.rateSettings.get(0) : 'Resimac_Rates__c';
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    private static List<Resimac_Rates__c> getRates() {
        return [SELECT Id, Asset_Type__c, Rate__c
                FROM Resimac_Rates__c
                ORDER BY Rate__c ASC, Name];
    }

    @AuraEnabled
    public static Map<String, Decimal> getAllRates(QuotingCalculation.CalcParam param) {
        Decimal recomBaseRate = 0.00;
        Decimal baseRate = 0.00;
        Decimal clientRate = 0.00;
        // Decimal clientRate = 3.03;

        List<Resimac_Rates__c> recomRates = getRates();
        for ( Resimac_Rates__c rate : recomRates ) {
            if ( rate.Asset_Type__c.equals(param.assetType) ) {
                recomBaseRate = rate.Rate__c;
            }
        }

        baseRate = QuotingCalculation.getBaseRate(param);
        param.baseRate = baseRate;
        clientRate = QuotingCalculation.getClientRateCalculation(param);

        return new Map<String, Decimal>{ 'recomBaseRate' => recomBaseRate, 'baseRate' => baseRate, 'clientRate' => clientRate };
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
        // PageReference pdf = Page.UniversalCalculatorPdf;
        PageReference pdf = QuoteController.createPdf(quote);

        // pass universal variables
        pdf.getParameters().put('id', quote.Opportunity__c);
        // pdf.getParameters().put('lender', 'GROW ASSET CAR CALCULATION');
        pdf.getParameters().put('lender', 'RESIMAC CALCULATION');

        //Financial Details
        pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
        pdf.getParameters().put('productLoanType', '');

        pdf.getParameters().put('price', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
        pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));

        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));

        pdf.getParameters().put('term', NumberUtils.format(quote.Term__c));
        pdf.getParameters().put('paymentType', quote.Payment__c + '');
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
        pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c) + '');

        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));

        // specific data
        pdf.getParameters().put('assetAge', quote.Vehicle_Age__c);
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('assetType', quote.Goods_type__c + '');
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('abn', quote.Extra_Label_1__c);
        // pdf.getParameters().put('GST', quote.Extra_Label_2__c);

        pdf.getParameters().put('customerProfile', quote.Customer_Profile__c);
        pdf.getParameters().put('rateOption', quote.Rate_Options__c);
        pdf.getParameters().put('assetCategory', quote.Extra_Label_2__c);

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

    private static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use' : 'Business Use';
        p.Lender__c = 'Resimac';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Type_Detail__c = quote.Goods_type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Term__c = quote.Term__c;
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

    // private static Decimal baseRateMock(QuotingCalculation.CalcParam param) {
    //     Decimal r = 0.0;
    //     String assetType = param.assetType;
    //     List<Resimac_Rates__c> rates;
    //     rates = [SELECT Asset_Type__c, Rate__c
    //              FROM Resimac_Rates__c];
    //     for ( Resimac_Rates__c rate : rates ) {
    //         if ( rate.Asset_Type__c.equals(assetType) ) {
    //             r += rate.Rate__c;
    //         }
    //     }
    //     // addOnRate: a new parameter in CalcParam
    //     // if ( param.addOnRate != null ) {
    //     //     r += param.addOnRate;
    //     // }
    //     Decimal loadingRates = 0;
    //     if ( param.term <= 24 ) {
    //         loadingRates += 0.5;
    //     }
    //     if ( param.privateSales.equals('Y') || param.getNaf() <= 20000 ) {
    //         loadingRates += 1;
    //     }
    //     if ( param.propertyOwner.equals('N') || Integer.valueOf(param.assetAge) >= 16 ) {
    //         loadingRates += 1.5;
    //     }
    //     // TODO 2.0% part
    //     if ( loadingRates >= 4 ) {
    //         loadingRates = 4;
    //     }
    //     r += loadingRates;
    //     if ( param.brokeragePer > 5 ) {
    //         r += ( param.brokeragePer - 5 );
    //     }
    //     return r;
    // }
}