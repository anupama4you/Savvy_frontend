public without sharing class QuoteAzoraCommController {
    @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {

        QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);

        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() ? param.rateSettings.get(0) : 'Azora_Commercial_Rates__c';

        Map<String, List<Azora_Commercial_Rates__c>> rates = new Map<String, List<Azora_Commercial_Rates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
    }

    private static List<Azora_Commercial_Rates__c> getRates() {
        return [SELECT Id, Loan_Type__c, Rate__c
                FROM Azora_Commercial_Rates__c
                ORDER BY Name];
    }

    @AuraEnabled
    public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
        Decimal br = 0.00;
        Decimal max = 0.00;
        Decimal cr = 0.00;
        //Decimal bp = param.brokeragePer;
        //Decimal cr = param.clientRate;
        //get base rate
        br = QuotingCalculation.getBaseRate(param);
        if ( param.hasMaxRate != null && param.hasMaxRate ) {
            //get max rate
            max = QuotingCalculation.getMaximunBaseRate(param);
        }

        cr = br;
        if ( param.brokeragePer > 4 ) {
            cr = br + param.brokeragePer - 4;
        }
        return new Map<String, Decimal>{ 'baseRate' => br, 'maxRate' => max, 'clientRate' => cr };
    }

    public static Decimal getNafCommission(QuotingCalculation.CalcParam param, String calcType) {
        Decimal r = 0.0;
        if ( QuotingCalculation.CALC_PROTECTED.equals(calcType) ) {
            if ( param.vehiclePrice != null )
                r += param.vehiclePrice + ( param.vehiclePrice * QuotingCalculation.getProtectedPercentaje(param.vehiclePrice) );
        } else {
            if ( param.vehiclePrice != null )
                r += param.vehiclePrice;
        }
        if ( param.netDeposit != null )
            r -= param.netDeposit;
        return r;
    }

    @AuraEnabled
    public static Decimal getCommission(QuotingCalculation.CalcParam param) {
        return param.brokeragePer / 100 * getNafCommission(param, QuotingCalculation.CALC_QUOTING) * 1.1;
    }

    //Return DOF and Max DOF Calculations
    @AuraEnabled
    public static Map<String, Decimal> getDofCalcu(QuotingCalculation.CalcParam param, Boolean fullCalc) {
        Decimal totalInsurance = param.totalInsurance;
        Decimal totalAmount = 0;
        Decimal dof = 0.0;
        Decimal maxDof = 0.0;
        if ( param.vehiclePrice != null )
            totalAmount += param.vehiclePrice;
        totalAmount = totalAmount - param.netDeposit + totalInsurance;
        Decimal r = 0.0;

        if ( totalAmount >= 8000 && totalAmount <= 14000 ) {
            r = ( totalAmount * 0.10 ).setScale(2);

            if ( r > 990 ) {
                r = 990.00;
            }
        } else if ( totalAmount > 14000 ) {
            r = 1100.00;
        }
        if ( fullCalc ) {
            dof = r;
        }
        maxDof = r;
        //System.debug(this.loanTypeDetail + '|' + totalAmount.format() + '|' + r.format() + '|max:' + this.maxDof + '|dof:' + this.dof);
        return new Map<String, Decimal>{ 'dof' => dof, 'maxDof' => maxDof };
    }

    //Return Finance One Rate
    @AuraEnabled
    public static List<FinanceOneRates__c> getFinanceOneRate(QuotingCalculation.CalcParam param) {
        return new List<FinanceOneRates__c>{ QuotingCalculation.getFinanceOneRates(param) };
    }

    //Finance One Commercial Calculate Button Logic
    @AuraEnabled
    public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
        param.nafCommission = getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        return QuoteController.calculateRepayments(param);
    }

    //return aaplication fee calculation
    @AuraEnabled
    public static Decimal getApplicationFeeCalc(QuotingCalculation.CalcParam param) {
        param.totalAmount = getNafCommission(param, QuotingCalculation.CALC_QUOTING);
        return QuotingCalculation.getFinanceOneApplicationFee(param);
    }

    @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType) {
        try {
            if ( param.additionalProcess == null ) {
                param.additionalProcess = new List<String>();
            }
            param.additionalProcess.add(approvalType);
            QuoteController.saveQuoting(param);
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

    public static PageReference pdfHandler(Application_Quoting__c quote) {

        // pass parameters to the PDF page
        PageReference pdf = QuoteController.createPdf(quote);

        // pass universal variables
        pdf.getParameters().put('id', quote.Opportunity__c);
        pdf.getParameters().put('lender', 'AZORA COMMERCIAL CALCULATION');

        //Financial Details
        pdf.getParameters().put('abn', quote.Extra_Label_1__c);
        pdf.getParameters().put('GST', quote.GST__c);

        pdf.getParameters().put('assetType', quote.Goods_type__c + '');
        pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
        pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
        pdf.getParameters().put('creditScore', String.valueOf(quote.Credit_Score__c) + '');
        pdf.getParameters().put('residualValuePercentage', NumberUtils.format(quote.Residual_Value_Percentage__c));
        pdf.getParameters().put('brokeragePercentage', NumberUtils.format(quote.Brokerage__c));
        pdf.getParameters().put('customerProfile', quote.Customer_Profile__c + '');
        pdf.getParameters().put('riskFee', '0');
        pdf.getParameters().put('dof', '0');
        pdf.getParameters().put('productGoodsType', String.valueOf(quote.Goods_type__c));
        pdf.getParameters().put('loanTypeDetail', String.valueOf(quote.Loan_Facility_Type__c));
        pdf.getParameters().put('rateOption', String.valueOf(quote.Rate_Options__c + '%'));
        pdf.getParameters().put('isFinanceOne', 'true');
        return pdf;
    }

    public static Product__c productHandler(Application_Quoting__c quote) {
        Product__c p = QuoteController.getProduct(quote.Opportunity__c);
        p.Loan_Purpose__c = 'Business Use';
        p.Lender__c = 'Azora';
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
        p.Deposit__c = quote.Net_Deposit__c == null ? 0 : quote.Net_Deposit__c;
        p.DOF__c = quote.DOF__c;
        p.Brokerage__c = quote.Commission_Estimation__c == null ? 0 : quote.Commission_Estimation__c;
        p.Lender_App_Fee__c = quote.Application_Fee__c;
        p.Equalisation_Fee_PPSR__c = quote.PPSR__c;

        return p;
    }

}