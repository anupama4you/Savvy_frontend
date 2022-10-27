public without sharing class QuoteLatitudeCalcController {
 
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 

      // Lender settings
      // Rate Settings
      String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
      ? param.rateSettings.get(0) : 'LatitudeRatesv3__c';
        
      Map<String, List<LatitudeRatesv3__c>> rates = new Map<String, List<LatitudeRatesv3__c>>();
      rates.put(rateObjName, getRates());
      r.rateSettings = rates;

      //API Responses
      r.apiResponses = QuoteController.getMostRecentApiResponses(param.oppId, 'Latitude', param.calcName);

      return r;
    }

    private static List<LatitudeRatesv3__c> getRates() {
        List<LatitudeRatesv3__c> d = LatitudeRatesv3__c.getAll().values();
        d.sort();
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
      } catch (Exception ex) {
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
        pdf.getParameters().put('registrationFee', NumberUtils.format(quote.Registration_Fee__c));
        pdf.getParameters().put('loanTypeDetail', quote.Loan_Facility_Type__c);
        pdf.getParameters().put('vehicleAge', String.valueOf(quote.Vehicle_Age__c));
        pdf.getParameters().put('vehCon', quote.Vehicle_Condition__c);
        pdf.getParameters().put('privateSales', quote.Vehicle_Condition__c);
        pdf.getParameters().put('goodsType', quote.Goods_type__c);
        pdf.getParameters().put('vehiclesProfile', quote.Category_Type__c);
        pdf.getParameters().put('rateOption', String.valueOf(quote.Rate_Options__c));
        // pdf.getParameters().put('riskFee', NumberUtils.format(quote.Risk_Fee__c));
        return pdf;

    }

    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Personal Use';
        p.Lender__c = quote.Name;
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
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0.0? quote.PPSR__c : 0.00;
        p.Equalisation_Fee_PPSR__c += quote.Registration_Fee__c > 0.0? quote.Registration_Fee__c : 0.00;

        return p;
    }
}