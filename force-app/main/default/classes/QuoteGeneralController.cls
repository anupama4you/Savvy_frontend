public without sharing class QuoteGeneralController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        return r;
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
        pdf.getParameters().put('lender', 'GENERAL CALCULATION');
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
        pdf.getParameters().put('purposeType', quote.Purpose_Type__c);
        pdf.getParameters().put('loanTypeDetail', quote.Loan_Facility_Type__c);
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('extraLabel1', quote.Extra_Label_1__c);
        pdf.getParameters().put('extraLabel2', quote.Extra_Label_2__c);
        pdf.getParameters().put('extraLabel3', quote.Extra_Label_3__c);
        pdf.getParameters().put('extraLabel4', quote.Extra_Label_4__c);
        pdf.getParameters().put('extraValue1', NumberUtils.format(quote.Extra_Value_1__c));
        pdf.getParameters().put('extraValue2', NumberUtils.format(quote.Extra_Value_2__c));
        pdf.getParameters().put('extraValue3', NumberUtils.format(quote.Extra_Value_3__c));
        pdf.getParameters().put('extraValue4', NumberUtils.format(quote.Extra_Value_4__c));
        return pdf;
    }

    private static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Personal Use';
        p.Lender__c = 'General';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Type_Detail__c = quote.Loan_Facility_Type__c;
        p.Loan_Term__c = quote.Term__c;
        p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
        p.Deposit__c = quote.Net_Deposit__c;
        return p;
    }

}