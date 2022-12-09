public with sharing class QuoteC1FinanceCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        return r;
    }

     @AuraEnabled
     public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
        try {
            if( param.additionalProcess == null) {
                param.additionalProcess = new List<String>();
            }
            param.additionalProcess.add(approvalType);
            QuoteController.saveQuoting(param);
            Product__c p = null;
            if (!'NONE'.equals(approvalType) && !'SEND'.equals(approvalType) && !'PREVIEW'.equals(approvalType)) {
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
         pdf.getParameters().put('lender', 'C1 FINANCE CALCULATION');
 
         //Financial Details
         pdf.getParameters().put('assetType', quote.Goods_type__c+'');
         pdf.getParameters().put('assetAge', quote.Vehicle_Age__c+'');
         pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
         pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
         pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
         pdf.getParameters().put('residualValuePercentage', NumberUtils.format(quote.Residual_Value_Percentage__c));
         pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
         pdf.getParameters().put('customerProfile', quote.Customer_Profile__c+'');
         pdf.getParameters().put('riskFee', String.valueOf(quote.Risk_Fee__c));
         pdf.getParameters().put('productGoodsType', String.valueOf(quote.Goods_type__c));
         pdf.getParameters().put('loanTypeDetail', String.valueOf(quote.Loan_Facility_Type__c));
         pdf.getParameters().put('isFinanceOne', 'true');
 
         return pdf;
 
     }
 
     public static Product__c productHandler(Application_Quoting__c quote) {
         Product__c p = QuoteController.getProduct(quote.Opportunity__c);
         p.Loan_Purpose__c = 'Business Use';
         p.Lender__c = 'C1 Finance';
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
         p.DOF__c = quote.DOF__c > 0? quote.DOF__c : 0.00;
         p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
         p.Lender_App_Fee__c = quote.Application_Fee__c > 0 ? quote.Application_Fee__c : 0.0;
         p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0.0? quote.PPSR__c : 0.0;
         p.Equalisation_Fee_PPSR__c += quote.Risk_Fee__c > 0.0? quote.Risk_Fee__c : 0.0;
         p.Residual_Percentage__c = quote.Residual_Value_Percentage__c > 0? quote.Residual_Value_Percentage__c : 0.0;
         return p;
     }
}