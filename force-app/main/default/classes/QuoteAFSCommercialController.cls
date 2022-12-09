public without sharing class QuoteAFSCommercialController {
    public class AfsRate {
        @AuraEnabled
        public Decimal rate { set; get; }

        @AuraEnabled
        public Decimal comm { set; get; }

        public AfsRate(Decimal rate, Decimal comm) {
            this.rate = rate;
            this.comm = comm;
        }

    }

    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        return QuoteController.getQuotingData(param);
    }

    public static Map<String, List<AfsRate>> getRates() {
        Map<String, List<AfsRate>> rates = new Map<String, List<AfsRate>>();
        List<AFS_Commercial_Rates__c> fullRates = AFS_Commercial_Rates__c.getAll().values();
        if ( !fullRates.isEmpty() ) {
            fullRates.sort (  );
            List<AfsRate> r1 = new List<AfsRate>();
            List<AfsRate> r2 = new List<AfsRate>();

            for ( AFS_Commercial_Rates__c a : fullRates ) {
                r1.add(new AfsRate(a.Rate__c, a.Comm_07_Years__c));
                r2.add(new AfsRate(a.Rate_2__c, a.Comm_8_Years__c));
            }
            rates.put('New - 6 years old', r1);
            rates.put('Used 7 years+', r2);
        }
        return rates;
    }

    @AuraEnabled
    public static QuoteController.QuotingResultWraper calculateRepayments(QuotingCalculation.CalcParam param, QuoteController.InsuranceParam insuranceParam) {
        param.commRate = getCommissionRate(param);
        System.debug('==> calculateRepayments param ' + param);
        return QuoteController.calculateAllRepayments(param, insuranceParam);
    }

    // @AuraEnabled
    // public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
    //     param.commRate = getCommissionRate(param);
    //     System.debug('==> calculateRepayments param ' + param);
    //     return QuoteController.calculateRepayments(param);
    // }
    public static Decimal getCommissionRate(QuotingCalculation.CalcParam param) {
        Map<String, List<AfsRate>> rateList = getRates();
        Decimal r = 0.0;
        if ( param.clientRate != 0 && !rateList.isEmpty() ) {
            List<AfsRate> rts = rateList.get(param.assetAge);
            for ( AfsRate a : rts ) {
                if ( param.clientRate >= a.rate ) {
                    r = a.comm;
                }
            }
        }
        return r;
    }

    @AuraEnabled
    public static List<AfsRate> getAFSRates(QuotingCalculation.CalcParam param) {
        List<AfsRate> res = new List<AfsRate>();
        Map<String, List<AfsRate>> rate = getRates();
        system.debug('==> getAFSRates rate ' + rate);
        if ( !rate.isEmpty() ) {
            system.debug('==> getAFSRates SHOOT NOT EMPTY ');
            if ( 'Not Registered'.equalsIgnoreCase(param.gst) ) {
                res = rate.get('Used 7 years+');
            } else {
                res = rate.get(param.assetAge);
            }
        }
        system.debug('==> res ' + res);
        return res;
    }

    // Lee - 01/09/2022
    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType) {
        try {
            System.debug('type.....  ' + approvalType);
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

    // // Lee - 01/09/2022
    // public static PageReference pdfHandler(Application_Quoting__c quote) {
    //     // pass parameters to the PDF page
    //     PageReference pdf = Page.UniversalCalculatorPdf;
    //     // pass universal variables
    //     pdf.getParameters().put('id', quote.Opportunity__c);
    //     pdf.getParameters().put('lender', 'AFS COMMERCIAL CALCULATION');
    //     pdf.getParameters().put('registrationFee', String.valueof(quote.Registration_Fee__c));
    //     pdf.getParameters().put('residency', quote.Residency__c);
    //     pdf.getParameters().put('carAge', quote.Vehicle_Age__c);
    //     pdf.getParameters().put('gst', quote.GST__c);
    //     //Financial Details
    //     pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
    //     pdf.getParameters().put('productLoanType', quote.Loan_Product__c + '');
    //     pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
    //     pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
    //     pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
    //     pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
    //     pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
    //     pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
    //     pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
    //     pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));
    //     pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
    //     pdf.getParameters().put('baseRate', NumberUtils.format(quote.Client_Rate__c));
    //     pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
    //     pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
    //     pdf.getParameters().put('term', quote.Term__c + '');
    //     pdf.getParameters().put('paymentType', quote.Payment__c + '');
    //     pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
    //     pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
    //     pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
    //     // pdf.getParameters().put('productGoodsType', quote.Goods_type__c+'');
    //     pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
    //     // ---- commissions -----
    //     pdf.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
    //     pdf.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));
    //     pdf.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
    //     pdf.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
    //     pdf.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
    //     pdf.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
    //     pdf.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
    //     pdf.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
    //     pdf.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
    //     pdf.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
    //     // ---- end commissions -----
    //     return pdf;
    // }
    // Lee - 01/09/2022
    public static PageReference pdfHandler(Application_Quoting__c quote) {

        // pass parameters to the PDF page
        PageReference pdf = QuoteController.createPdf(quote);

        pdf.getParameters().put('lender', 'AFS COMMERCIAL CALCULATION');
        pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('carAge', quote.Vehicle_Age__c);
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Client_Rate__c));
        pdf.getParameters().put('registrationFee', String.valueof(quote.Registration_Fee__c));
        pdf.getParameters().put('residency', quote.Residency__c);
        pdf.getParameters().put('gst', quote.GST__c);

        return pdf;
    }

    // Lee - 01/09/2022
    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);

        p.Loan_Purpose__c = 'Personal Use';
        p.Lender__c = 'AFS';
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = quote.Loan_Product__c;
        p.Loan_Type_Detail__c = 'Car Age ' + quote.Vehicle_Age__c;
        p.Loan_Term__c = quote.Term__c;
        p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
        p.Client_Rate__c = quote.Client_Rate__c;
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c > 0 ? quote.Application_Fee__c : 0.00;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0 ? quote.PPSR__c : 0.00;
        p.Equalisation_Fee_PPSR__c += quote.Registration_Fee__c > 0 ? quote.Registration_Fee__c : 0.00;

        return p;
    }

}