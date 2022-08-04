public with sharing class QuoteGrowBusiController {
    private static final String COMMERCIAL = 'COMMERCIAL';
    private static List<Protected_Payment_Settings__c> protectedRatesList;
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() ? param.rateSettings.get(0) : 'Azora_Rates__c';
        Map<String, List<Azora_Rates__c>> rates = new Map<String, List<Azora_Rates__c>>();
        List<Azora_Rates__c> d = getRates();
        rates.put(rateObjName, d);
        r.rateSettings = rates;
        return r;
    }

    private static List<Azora_Rates__c> getRates() {
        return [SELECT Credit_Score__c, Max_Loan__c, Rate__c, Risk_Fee__c// FROM Azora_Rates__c];
                FROM Azora_Rates__c
                ORDER BY Name];
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

    private static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Business Use';
        p.Lender__c = 'Grow';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;

        p.Loan_Type_Detail__c = quote.Loan_Facility_Type__c; //*

        p.Loan_Term__c = quote.Term__c;
        p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;

        p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c; // ?
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
        return p;
    }

    private static PageReference pdfHandler(Application_Quoting__c quote) {
        // pass parameters to the PDF page
        PageReference pdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        // calcPdf.getParameters().put('lender', 'AZORA CONSUMER CALCULATION');
        pdf.getParameters().put('id', quote.Opportunity__c);
        pdf.getParameters().put('lender', 'GROW BUSINESS LOAN CALCULATION');
        // pdf.getParameters().put('lender', 'Grow Business Loan CALCULATION');
        //Financial Details
        pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
        pdf.getParameters().put('productLoanType', quote.Loan_Product__c );
        pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
        pdf.getParameters().put('ppsr', '0.00');
        pdf.getParameters().put('residualValue', '0.00');
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
        pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
        pdf.getParameters().put('term', quote.Term__c + '');
        pdf.getParameters().put('paymentType', quote.Payment__c);
        pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
        pdf.getParameters().put('riskFee', NumberUtils.format(quote.Risk_Fee__c));
        pdf.getParameters().put('loanTypeDetail', quote.Loan_Facility_Type__c + '');
        pdf.getParameters().put('repaymentType', quote.Payment__c + '');
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
        // ---- Specific data ----
        pdf.getParameters().put('abnLength', quote.Extra_Label_1__c);
        pdf.getParameters().put('gstLength', quote.Extra_Label_2__c);
        pdf.getParameters().put('brokerage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('equifaxScore', quote.Credit_Score__c);
        pdf.getParameters().put('propertyOwner', quote.Customer_Profile__c);
        return pdf;
    }

    @AuraEnabled
    public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
        param.amountBaseComm = getBaseAmountPmtCalc(param.totalAmount, getProtectedPercentaje(param.totalAmount));
        return QuotingCalculation.calculate(param);
    }

    private static Decimal getBaseAmountPmtCalc(Decimal carPrice, Decimal protectedPercentaje) {
        Decimal r = 0.0;
        if ( carPrice != null )
            r += carPrice + ( carPrice * protectedPercentaje );
        return r;
    }

    @AuraEnabled
    public static Decimal getProtectedPercentaje(Decimal carPrice) {
        // private static Decimal getProtectedPercentaje(Decimal carPrice) {
        Decimal r = 0.0;
        System.debug('carPrice >>>>>> ' + carPrice);
        if ( protectedRatesList == null ) {
            protectedRatesList = Protected_Payment_Settings__c.getAll().values();
            protectedRatesList.sort (  );
        }
        for ( Protected_Payment_Settings__c s : protectedRatesList ) {
            if ( carPrice >= s.From__c ) {
                r = s.Percentaje__c / 100;
            } else {
                break;
            }
        }
        System.debug('rrr >>>>>> ' + r);
        return r;
        // return
    }

}