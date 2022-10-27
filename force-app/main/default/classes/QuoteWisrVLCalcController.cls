public with sharing class QuoteWisrVLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        String rateObjName = param.rateSettings.get(0);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    public static List<WisrVL_Rates__c> getRates() {
        List<WisrVL_Rates__c> r = [
            SELECT
                Id,
                Profile__c,
                Credit_Score_Start__c,
                Credit_Score_End__c,
                Rate_1__c,
                Rate_2__c,
                Rate_3__c,
                Rate_4__c,
                Comparison_Rate__c
            FROM WisrVL_Rates__c
            ORDER BY Profile__c DESC, Credit_Score_Start__c DESC
        ];
        return r;
    }
    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
        try {
            System.debug('type.....  '+approvalType);
            if( param.additionalProcess == null) {
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
        
        // pass universal variables
        pdf.getParameters().put('id',quote.Opportunity__c);
        pdf.getParameters().put('lender', 'WISR CAR LOAN CALCULATION');

        //Financial Details
        pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c)+'');
        pdf.getParameters().put('profile', quote.Customer_Profile__c+'');
        pdf.getParameters().put('vehicleYear', quote.Vehicle_Age__c+'');
        pdf.getParameters().put('lvr', String.valueOf(quote.LTV__c)+'');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c+'');
        
        return pdf;
    }

    @AuraEnabled
    // Lee - 18/07/2022
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use': 'Business Use';
        p.Lender__c = 'Wisr VL';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Term__c = quote.Term__c;
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