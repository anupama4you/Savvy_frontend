public without sharing class QuoteAffordableCLCalcController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(
        QuoteController.QuotingDataParam param
    ) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        String rateObjName1 = param.rateSettings.get(0);
        String rateObjName2 = param.rateSettings.get(1);
        Map<String, List<sObject>> rates = new Map<String, List<sObject>>();
        rates.put(rateObjName1, getListInterestRate(param.calcName));
        rates.put(rateObjName2, getACLUpfrontLoanFees());
        r.rateSettings = rates;
        return r;
    }

    public static List<BasicLenderRates__c>  getListInterestRate(String LENDER_QUOTING){
        return QuotingCalculation.listBasicRates(LENDER_QUOTING);
    }

    public static List<ACLUpfrontLoanFees__c> getACLUpfrontLoanFees() {
        List<ACLUpfrontLoanFees__c> d = ACLUpfrontLoanFees__c.getall().values();
        d.sort();
        return d;
    }

    // @AuraEnabled
    // public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
    //     Decimal br = 0.00;
    //     Decimal max = 0.00;
    //     // try {
    //     br = QuotingCalculation.getBaseRate(param);
    //     if (param.hasMaxRate != null && param.hasMaxRate) {
    //         max = QuotingCalculation.getMaximunBaseRate(param);
    //     }
    //     // } catch (Exception e) {
    //     //   throw new GenericException(e.getMessage());
    //     // }

    //     return new Map<String, Decimal>{'baseRate' => br, 'maxRate' => max};

    // }
    
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
        
        // pass universal variables
        pdf.getParameters().put('id',quote.Opportunity__c);
        pdf.getParameters().put('lender', 'AFFORDABLE CAR LOAN CALCULATION');

        //Financial Details
        pdf.getParameters().put('aclCreditScore', String.valueOf(quote.Credit_Score__c)+'');
        pdf.getParameters().put('vehicleYear', quote.Vehicle_Age__c+'');
        pdf.getParameters().put('repayment', quote.Loan_Frequency__c);
        pdf.getParameters().put('riskFee', NumberUtils.format(quote.Risk_Fee__c));
        pdf.getParameters().put('commissionType', quote.Commission_Type__c);
        pdf.getParameters().put('calcBonus', NumberUtils.format(0));

        return pdf;
    }

    @AuraEnabled
    // Lee - 18/07/2022
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = quote.Loan_Type__c == 'Comsumer Loan' ? 'Personal Use': 'Business Use';
        p.Lender__c = ACLCalculatorExtension.LENDER_QUOTING;
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