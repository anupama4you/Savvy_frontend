public without sharing class QuoteCapitalFinanceController {
    private static final String ASSET_MV = 'MV < 4.5T';
    private static final String ASSET_TRUCKS = 'Trucks/Agri/Yellow goods';
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
        // Lender settings
        Set<String> assetTypes = new Set<String>{ ASSET_MV, ASSET_TRUCKS };
        List<String> names = new List<String>{ 'Motor Vehicles', 'Primary Assets', 'Small Ticket' };
        r.rateSettings = getCapFinRates(assetTypes, names);
        return r;
    }

    private static Map<String, List<Capital_Finance_Rates__c>> getCapFinRates(Set<String> assetTypes, List<String> names) {
        Map<String, List<Capital_Finance_Rates__c>> resultMap = new Map<String, List<Capital_Finance_Rates__c>>();
        List<Capital_Finance_Rates__c> cfLists = getRates(assetTypes);
        for ( String name : names ) {
            resultMap.put(name, new List<Capital_Finance_Rates__c>());
        }
        for ( Capital_Finance_Rates__c cf : cfLists ) {
            if ( cf.Asset_Type__c == ASSET_MV ) {
                resultMap.get('Motor Vehicles').add(cf);
            }
            if ( cf.Asset_Type__c == ASSET_TRUCKS ) {
                if ( cf.Loan_Type__c == null ) {
                    resultMap.get('Primary Assets').add(cf);
                } else {
                    resultMap.get('Small Ticket').add(cf);
                }
            }
        }
        return resultMap;
    }

    private static List<Capital_Finance_Rates__c> getRates(Set<String> assetTypes) {
        return [select id, Name, Amount_Inc_GST__c, Amount_Max__c, 
                       Amount_Min__c, Asset_Type__c, Loan_Type__c, Term_24_60_months__c, 
                       New_Primary__c, Used_Primary_4_years_old__c, Used_Primary_6_years_old__c, New_Secondary__c, 
                       New_Tertiary__c
                from Capital_Finance_Rates__c
                where Asset_Type__c = :assetTypes
                order by name asc];
    }

    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType, String clientRate) {
        try {
            QuoteController.saveQuoting(param);
            Product__c p = null;
            if ( !'NONE'.equals(approvalType) ) {
                // save pdf
                PageReference pdf = Page.UniversalCalculatorPdf;
                pdf = pdfHandler(param.data, clientRate);
                QuoteController.savePdf(approvalType, pdf, param);
                // save product
                p = productHandler(param.data, clientRate);
                QuoteController.saveProduct(param, p);
            }
        } catch ( Exception ex ) {
            throw new GenericException(ex.getMessage());
        }
        return param.data;
    }

    private static PageReference pdfHandler(Application_Quoting__c quote, String clientRate) {
        // pass parameters to the PDF page
        PageReference pdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        pdf.getParameters().put('id', quote.Opportunity__c);
        pdf.getParameters().put('lender', 'CAPITAL FINANCE CALCULATION');
        //Financial Details
        pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
        pdf.getParameters().put('productLoanType', 'Chattel Mortgage-Full-Doc');
        pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
        pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
        pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
        pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
        pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
        pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
        pdf.getParameters().put('dof', '0.00');
        pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));
        pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
        pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
        pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
        pdf.getParameters().put('clientRate', clientRate);
        pdf.getParameters().put('term', quote.Term__c + '');
        pdf.getParameters().put('paymentType', quote.Payment__c + '');
        pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
        // ---- commissions -----
        pdf.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
        pdf.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));
        pdf.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
        pdf.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
        pdf.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
        pdf.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
        pdf.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
        pdf.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
        pdf.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
        pdf.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
        // ---- end commissions -----
        pdf.getParameters().put('purposeType', quote.Purpose_Type__c);
        pdf.getParameters().put('loanTypeDetail', quote.Loan_Facility_Type__c);
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        return pdf;
    }

    private static Product__c productHandler(Application_Quoting__c quote, String clientRate) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Business Use';
        p.Lender__c = quote.Name;
        p.Quoting_Source__c = quote.Name;
        p.Repayment_Regularity__c = 'Monthly';
        p.Loan_Type__c = quote.Loan_Type__c;
        p.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
        p.Loan_Type_Detail__c = quote.Loan_Facility_Type__c;
        p.Loan_Term__c = quote.Term__c;
        p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
        p.Client_Rate__c = Decimal.valueOf(clientRate);
        p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00;
        p.Cost_of_Goods__c = quote.Vehicle_Price__c;
        p.DOF__c = quote.Commission_DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;
        p.Deposit__c = quote.Net_Deposit__c;
        return p;
    }

}