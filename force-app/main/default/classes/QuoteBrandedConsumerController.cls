public with sharing class QuoteBrandedConsumerController {

    @AuraEnabled
  public static QuoteController.AppQuotingWraper getQuotingData(
    QuoteController.QuotingDataParam param
  ) {
    QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
    // Lender settings
    // Rate Settings
    String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
      ? param.rateSettings.get(0) : 'Branded_Consumer_Rates__c';
    
    Map<String, List<Branded_Consumer_Rates__c>> rates = new Map<String, List<Branded_Consumer_Rates__c>>();
    rates.put(rateObjName, getRates());
    r.rateSettings = rates;
    System.debug('rrr   >>>> '+ JSON.serialize(r));
    return r;
    }

    public static List<Branded_Consumer_Rates__c> getRates() {
        return [
          SELECT 
            Id, Condition__c, Credit_Score__c, Rate__c, 
            Profile__c
          FROM Branded_Consumer_Rates__c
        ];
      }

    @AuraEnabled
    public static Decimal getCreditScore(Id oppId){
        try {
            System.debug('opp >> '+ oppId);
            Custom_Opportunity__c opp = QuoteController.getOpportunityById(oppId);
            if(opp != null && opp.Credit_Score__c != null){
                return opp.Credit_Score__c;
            }
            return null;
        } catch (Exception e) {
            throw new GenericException(e);
        }
    }

    // Lee - 08/09/2022
  @AuraEnabled
  public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
     try {
          System.debug('type.....  '+approvalType);
         if( param.additionalProcess == null) {
          param.additionalProcess = new List<String>();
         }
          param.additionalProcess.add(approvalType);
          System.debug('param.additionalProcess >> ' + param.additionalProcess);
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

  // Lee - 08/09/2022
  public static PageReference pdfHandler(Application_Quoting__c quote){

    // pass parameters to the PDF page
    PageReference pdf = QuoteController.createPdf(quote);
    
    // pass universal variables
    pdf.getParameters().put('id',quote.Opportunity__c);
    pdf.getParameters().put('lender', 'BRANDED COMMERCIAL CALCULATION');

     //Financial Details
     pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
     pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
     pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
     pdf.getParameters().put('productGoodsType', quote.Goods_type__c + '');

    return pdf;

  }

  // Lee - 08/09/2022
  public static Product__c productHandler(Application_Quoting__c quote) {
    Product__c p = QuoteController.getProduct(quote.Opportunity__c);

    p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use': 'Business Use';
    p.Lender__c = 'Pepper';
    p.Quoting_Source__c = quote.Name;
    p.Repayment_Regularity__c = 'Monthly';
    p.Loan_Type__c = quote.Loan_Type__c;
    p.Loan_Product__c = quote.Loan_Product__c;
    p.Loan_Type_Detail__c = 'Client Tier ' + quote.Client_Tier__c;
    p.Loan_Term__c = quote.Term__c;
    p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
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