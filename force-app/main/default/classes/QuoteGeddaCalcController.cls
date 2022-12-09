public with sharing class QuoteGeddaCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
      // Lender settings
      // Rate Settings -- hard code
      return r;
    }
  
    // Lee - 26/08/2022
    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType) {
      try {
        if ( param.additionalProcess == null ) {
          param.additionalProcess = new List<String>();
        }
        param.additionalProcess.add(approvalType);
        System.debug('param.additionalProcess >> ' + param.additionalProcess);
  
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
        if ( !'NONE'.equals(approvalType) && !'SEND'.equals(approvalType) && !'PREVIEW'.equals(approvalType) ) {
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
  
    // Lee - 26/08/2022
    public static PageReference pdfHandler(Application_Quoting__c quote) {
      // pass parameters to the PDF page
      PageReference pdf = QuoteController.createPdf(quote);
  
      // Lender parameters
      pdf.getParameters().put('customerProfile', quote.Customer_Profile__c);
      pdf.getParameters().put('rateType', quote.Category_Type__c);
      if ( quote.Risk_Fee__c != null ) {
        pdf.getParameters().put('riskFee', NumberUtils.format(quote.Risk_Fee__c));
      }
      // pass universal variables
      pdf.getParameters().put('lender', 'GEDDA CALCULATION');
  
      //Financial Details
      pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
      pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
      pdf.getParameters().put('productGoodsType', quote.Goods_type__c + '');
      // ---- end commissions -----
      return pdf;
    }
  
    public static Product__c productHandler(Application_Quoting__c quote) {
      Product__c p = QuoteController.getProduct(quote.Opportunity__c);
  
      p.Loan_Purpose__c = 'Personal Use';
      p.Lender__c = 'Gedda';
      p.Quoting_Source__c = quote.Name;
      p.Repayment_Regularity__c = 'Monthly';
      p.Loan_Type__c = quote.Loan_Type__c;
      p.Loan_Product__c = quote.Loan_Product__c;
      p.Loan_Type_Detail__c = quote.Category_Type__c;
      p.Loan_Term__c = quote.Term__c;
      p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
      p.Client_Rate__c = quote.Client_Rate__c > 0 ? quote.Client_Rate__c : 0.00;
      p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
      p.Cost_of_Goods__c = quote.Vehicle_Price__c > 0 ? quote.Vehicle_Price__c : 0.00;
      p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c;
      p.DOF__c = quote.DOF__c;
      p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
      p.Lender_App_Fee__c = quote.Application_Fee__c;
      p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0 ? quote.PPSR__c : 0.00;
      p.Equalisation_Fee_PPSR__c += quote.Risk_Fee__c > 0 ? quote.Risk_Fee__c : 0.00;
  
      return p;
    }
}