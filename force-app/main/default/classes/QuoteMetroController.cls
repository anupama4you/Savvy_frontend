public without sharing class QuoteMetroController {

    static List<MetroCalculatorRates__c> rates = MetroCalculatorRates__c.getAll().values();
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
      QuoteController.QuotingDataParam param
    ) {
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
  
      // Lender settings
      // Rate Settings
      String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
        ? param.rateSettings.get(0) : 'MetroPlanOption__c';
      
      Map<String, List<SObject>> rates = new Map<String, List<SObject>>();
      rates.put(rateObjName, getLenderFeesTable());
      rates.put('PassengerAndCommercialRates',getPassengerAndCommercialRates());
      rates.put('HeavyCommercialRates',getHeavyCommercialRates());
      rates.put('WhelledPlantEquipmentRates',getWhelledPlantEquipmentRates());
      r.rateSettings = rates;
      return r;
    }

    private static List<MetroPlanOption__c> getLenderFeesTable() {
        List<MetroPlanOption__c> r = new List<MetroPlanOption__c>();
        Map<String, MetroPlanOption__c> d = QuotingCalculation.getMetroPlanOptions();
        for (String k : d.keySet()) {
            r.add(d.get(k));
        }
        return r;
    }

    public static List<MetroCalculatorRates__c> getPassengerAndCommercialRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[0]);
        r.add(rates[1]);
        r.add(rates[2]);
        return r;
    }
    public static List<MetroCalculatorRates__c> getHeavyCommercialRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[3]);
        r.add(rates[4]);
        return r;
    }
    public static List<MetroCalculatorRates__c> getWhelledPlantEquipmentRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[5]);
        r.add(rates[6]);
        r.add(rates[7]);
        return r;
    }
 
    private static MetroPlanOption__c resetLenderFees(String tier) {
        MetroPlanOption__c plan = getMetroPlanOptions().get(tier);
        return plan;
    }

    private static Map<String, MetroPlanOption__c> getMetroPlanOptions() {
        Map<String, MetroPlanOption__c> metroPlanOptions = new Map<String, MetroPlanOption__c>();
        List<MetroPlanOption__c> d = MetroPlanOption__c.getAll().values();
        d.sort();
        for (MetroPlanOption__c m : d) {
        metroPlanOptions.put(m.Name, m);
        }
        
        return metroPlanOptions;
      }

     // Lee - 18/07/2022
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
   
     // Lee - 18/07/2022
     public static PageReference pdfHandler(Application_Quoting__c quote){
   
      // pass parameters to the PDF page
      PageReference pdf = QuoteController.createPdf(quote);
       
       //Financial Details
       pdf.getParameters().put('lender', quote.Name);
       pdf.getParameters().put('clientTier', quote.Client_Tier__c+'');
       pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
       pdf.getParameters().put('loanTypeDetail', quote.Loan_Facility_Type__c+'');
       pdf.getParameters().put('greenCar', quote.Green_Car__c == null?'':quote.Green_Car__c);
       pdf.getParameters().put('privateSales', quote.Private_Sales__c+'');
       pdf.getParameters().put('saleBacksPurchased', quote.Sale_Backs_Purchased__c+'');
       pdf.getParameters().put('vehicleCondition', quote.Condition__c+'');
       pdf.getParameters().put('carAge', quote.Vehicle_Age__c+'');
       pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
   
       return pdf;
   
     }
   
     // Lee - 18/07/2022
     public static Product__c productHandler(Application_Quoting__c quote) {
       Product__c p = QuoteController.getProduct(quote.Opportunity__c);
   
       p.Loan_Purpose__c = 'Personal Use';
       p.Lender__c = quote.Name;
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
       p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
       p.DOF__c = quote.DOF__c > 0? quote.DOF__c : 0.00;
       p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
       p.Lender_App_Fee__c = quote.Application_Fee__c;
       p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
   
       return p;
     }
}