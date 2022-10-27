public without sharing class QuoteMoney3Controller {
  @AuraEnabled
  public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
    QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param);
    // Lender settings
    // Rate Settings -- hard code
    return r;
  }

  @AuraEnabled
  public static Map<String, Object> profileOnChangeAction(QuoteController.AppQuotingWraper quote, Decimal riskFeeBase) {
    try {
      // Retrieve TERM, APPLICATION FEE, DOF, STANDARD RATE, CLIENT RATE
      Map<String, Object> result = new Map<String, Object>();
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Money3');
      param.customerProfile = quote.data.Customer_Profile__c;
      param.riskGrade = quote.data.Category_Type__c;
      param.totalAmount = riskFeeBase;
      Decimal maxDof = QuotingCalculation.getMoney3maxDof(param);
      param.totalAmount = quote.data.NAF__c;
      // param.totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
      param.riskFeeBase = riskFeeBase;
      //
      Decimal baseRate = QuotingCalculation.getBaseRate(param);
      System.debug('baseRate >> ' + baseRate + '  param >> ' + JSON.serialize(param));
      if ( baseRate != null ) {
        result.put('baseRate', baseRate);
        result.put('maxDof', maxDof);
      }
      return result;
    } catch ( Exception e ) {
      throw new GenericException(e.getMessage());
    }
  }

  //
  // Lee - 26/08/2022
  @AuraEnabled
  public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType) {
    try {
      if ( param.additionalProcess == null ) {
        param.additionalProcess = new List<String>();
      }
      param.additionalProcess.add(approvalType);
      System.debug('param.additionalProcess >> ' + param.additionalProcess);
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
    if ( !'Personal Finance'.equals(quote.Customer_Profile__c) ) {
      pdf.getParameters().put('loanPurpose', '');
    } else {
      pdf.getParameters().put('loanPurpose', quote.Loan_Purpose__c != null ? quote.Loan_Purpose__c : '');
    }
    // pass universal variables
    pdf.getParameters().put('lender', 'MONEY3 CALCULATION');

    //Financial Details

    pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
    pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
    pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
    pdf.getParameters().put('productGoodsType', quote.Goods_type__c + '');
    // ---- end commissions -----
    return pdf;
  }

  // // Lee - 26/08/2022
  // public static PageReference pdfHandler(Application_Quoting__c quote) {
  //   // pass parameters to the PDF page
  //   PageReference pdf = Page.UniversalCalculatorPdf;
  //   // Lender parameters
  //   pdf.getParameters().put('customerProfile', quote.Customer_Profile__c);
  //   pdf.getParameters().put('rateType', quote.Category_Type__c);
  //   if ( quote.Risk_Fee__c != null ) {
  //     pdf.getParameters().put('riskFee', NumberUtils.format(quote.Risk_Fee__c));
  //   }
  //   if ( !'Personal Finance'.equals(quote.Customer_Profile__c) ) {
  //     pdf.getParameters().put('loanPurpose', '');
  //   } else {
  //     pdf.getParameters().put('loanPurpose', quote.Loan_Purpose__c != null ? quote.Loan_Purpose__c : '');
  //   }
  //   // pass universal variables
  //   pdf.getParameters().put('id', quote.Opportunity__c + '');
  //   pdf.getParameters().put('lender', 'MONEY3 CALCULATION');
  //   //Financial Details
  //   pdf.getParameters().put('loanType', quote.Loan_Type__c + '');
  //   pdf.getParameters().put('productLoanType', quote.Loan_Product__c + '');
  //   pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
  //   pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
  //   pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
  //   pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
  //   pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
  //   pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
  //   pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
  //   pdf.getParameters().put('ppsr', NumberUtils.format(quote.PPSR__c));
  //   pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
  //   pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
  //   pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
  //   pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
  //   pdf.getParameters().put('term', quote.Term__c + '');
  //   pdf.getParameters().put('paymentType', quote.Payment__c + '');
  //   pdf.getParameters().put('clientTier', quote.Client_Tier__c + '');
  //   pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c + '');
  //   pdf.getParameters().put('privateSales', quote.Private_Sales__c + '');
  //   pdf.getParameters().put('productGoodsType', quote.Goods_type__c + '');
  //   pdf.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));
  //   // ---- commissions -----
  //   pdf.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
  //   pdf.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));
  //   pdf.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
  //   pdf.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
  //   pdf.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
  //   pdf.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
  //   pdf.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
  //   pdf.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
  //   pdf.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
  //   pdf.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
  //   // ---- end commissions -----
  //   return pdf;
  // }
  //Lee - 26/08/2022
  public static Product__c productHandler(Application_Quoting__c quote) {
    Product__c p = QuoteController.getProduct(quote.Opportunity__c);

    p.Loan_Purpose__c = 'Personal Use';
    p.Lender__c = 'Money3';
    p.Quoting_Source__c = quote.Name;
    p.Repayment_Regularity__c = 'Monthly';
    p.Loan_Type__c = quote.Loan_Type__c;
    p.Loan_Product__c = quote.Loan_Product__c;
    p.Loan_Type_Detail__c = 'Client Tier ' + quote.Client_Tier__c;
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