public with sharing class QuoteScotpacAssetCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        return r;
    }

    // @AuraEnabled
    // public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
    //     Decimal baseRate = 0.00;
    //     Decimal clientRate = 0.00;
    //     baseRate = QuotingCalculation.getBaseRate(param);
    //     param.baseRate = baseRate;
    //     clientRate = QuotingCalculation.getClientRateCalculation(param);
        
    //     return new Map<String, Decimal>{'baseRate' => baseRate, 'clientRate' => clientRate};
    // }

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
        PageReference pdf = QuoteController.createPdf(quote);
        
        // pass universal variables
        pdf.getParameters().put('id',quote.Opportunity__c);
        pdf.getParameters().put('lender', 'SCOTPAC ASSET CALCULATION');

        //Financial Details
        pdf.getParameters().put('productLoanType', quote.Loan_Type__c+'');
        pdf.getParameters().put('assetType', quote.Goods_type__c+'');
        pdf.getParameters().put('assetAge', quote.Vehicle_Age__c+'');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('companyScore', String.valueOf(quote.Credit_Score__c)+'');
        pdf.getParameters().put('residualValuePercentage', NumberUtils.format(quote.Residual_Value_Percentage__c));
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('customerProfile', quote.Customer_Profile__c+'');
        pdf.getParameters().put('riskFee', String.valueOf(quote.Risk_Fee__c));
        pdf.getParameters().put('productGoodsType', String.valueOf(quote.Goods_type__c));
        pdf.getParameters().put('loanTypeDetail', String.valueOf(quote.Loan_Facility_Type__c));
        pdf.getParameters().put('directorSoleTraderScore', String.valueOf(quote.Extra_Label_3__c));
        pdf.getParameters().put('rateOption', String.valueOf(quote.Rate_Options__c));
        pdf.getParameters().put('condition', String.valueOf(quote.Condition__c));
        pdf.getParameters().put('abnLength', String.valueOf(quote.Extra_Label_1__c));
        pdf.getParameters().put('gstLength', String.valueOf(quote.Extra_Label_2__c));
        pdf.getParameters().put('isFinanceOne', 'true');

        return pdf;
    }

    @AuraEnabled
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = 'Business Use';
        p.Lender__c = 'ScotPac';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Term__c = quote.Term__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00; 
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c > 0? quote.DOF__c : 0.0;
        p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c > 0? quote.Application_Fee__c : 0.0;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0? quote.PPSR__c : 0.0;

        return p;
    }
}