public with sharing class QuoteLibertyLeisureCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
        ? param.rateSettings.get(0) : 'LibertyRates__c';
          
        Map<String, List<LibertyRates__c>> rates = new Map<String, List<LibertyRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;

        return r;
    }

    private static List<LibertyRates__c> getRates() {
        List<LibertyRates__c> d = [
            SELECT Name, Tier__c, Type__c, Vehicle_Age__c, Rate__c, VOrder__c 
            FROM LibertyRates__c WHERE Type__c = 'Consumer [Caravan]'
            ORDER BY Type__c DESC, VOrder__c, Name
          ];
        return d;
    }

    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
       try {
          if( param.additionalProcess == null) {
              param.additionalProcess = new List<String>();
          }
          param.additionalProcess.add(approvalType);

          // ------------------------------------------------------------
          // Skip save option for Previewing if a quotation is presenting
          Boolean notSave = false;
          if ('PREVIEW'.equals(approvalType) && param.data != null) {        
            notSave = QuoteController.isQuotePresenting(param.data.Id);
          }
          if (!notSave) {
            QuoteController.saveQuoting(param);
          }
          // ------------------------------------------------------------
          
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
        pdf.getParameters().put('lender', quote.Name.touppercase() + ' CALCULATION');

        //pass variables about the product info
        pdf.getParameters().put('lvr', quote.LTV__c);
        pdf.getParameters().put('clientTier', quote.Client_Tier__c);
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c);
        pdf.getParameters().put('creditScore', NumberUtils.format( quote.Vedascore__c));
        pdf.getParameters().put('enquiries',NumberUtils.format( quote.Enquiries__c));
        pdf.getParameters().put('productGoodsType', quote.Goods_type__c);
        pdf.getParameters().put('registrationFee', NumberUtils.format(quote.Risk_Fee__c));
        pdf.getParameters().put('eqfee', NumberUtils.format(quote.Risk_Fee__c));
        pdf.getParameters().put('isLiberty', 'true');
        if (quote.Base_Rate__c != null && quote.Base_Rate__c > 0) {
            pdf.getParameters().put('maxRate', String.valueOf(quote.Base_Rate__c + 2));
        }
        
        return pdf;

    }

    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Personal Use';
        p.Lender__c = quote.Name;
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Type_Detail__c = quote.Client_Tier__c;
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
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0.0? quote.PPSR__c : 0.0;
        p.Equalisation_Fee_PPSR__c += quote.Risk_Fee__c > 0.0? quote.Risk_Fee__c : 0.0;

        return p;
    }
}