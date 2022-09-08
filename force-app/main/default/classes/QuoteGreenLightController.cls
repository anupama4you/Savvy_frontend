public without sharing class QuoteGreenLightController {
  
  public class lenderSettingsWrapper {
    @AuraEnabled 
    public Decimal applicationFee {set;get;} 
    @AuraEnabled
    public Decimal dof {set;get;}
    
  }
  
  //This method will use to load data in green light form  
  @AuraEnabled
    public static QuoteController.AppQuotingWraper getQuotingData(QuoteController.QuotingDataParam param) {
       
      QuoteController.AppQuotingWraper r = QuoteController.getQuotingData(param); 
        
        // Lender settings
        // Rate Settings
        String rateObjName = param.rateSettings != null && !param.rateSettings.isEmpty() 
            ? param.rateSettings.get(0) : 'GreenLightRates__c';

        Map<String, List<GreenLightRates__c>> rates = new Map<String, List<GreenLightRates__c>>();
        rates.put(rateObjName, getRates());
        r.rateSettings = rates;
        return r;
  }

  //This method will use to return data record to green light table rates
  public static List<GreenLightRates__c> getRates() {
      List<GreenLightRates__c> r = new List<GreenLightRates__c>();
      List<GreenLightRates__c> rates = GreenLightRates__c.getAll().values();
      r.sort();
      for (GreenLightRates__c g: rates) {
        if (String.isBlank(g.LVR__C)) {
          r.add(g);
        }
      }
      return r;
  }

  //this method will calculate fees (application fee, max app fee, dof, max dof)
  @AuraEnabled
  public static Map<String, Decimal> getFees(QuotingCalculation.CalcParam param, lenderSettingsWrapper lenderSettings, Boolean onlyMax) {
      Decimal resAF = 0.00;
      Decimal resMAF = 0.00;
      Decimal resDOF = 0.00;
      Decimal resMDOF = 0.00;
      Decimal b = getNafValidation(QuotingCalculation.CALC_QUOTING, param, false);
      resMAF = b * 0.1;
      resMDOF = b * .08;
      if (resMAF == 0 || resMAF > lenderSettings.applicationFee) {
        resMAF = lenderSettings.applicationFee;
      }
      if ( resMDOF == 0 ||  resMDOF > lenderSettings.dof) {
        resMDOF = lenderSettings.dof;
      }
      if (!onlyMax) { 
        resAF = resMAF;
        resDOF = resMDOF;
      }

      return new Map<String, Decimal>{'applicationFee' => resAF,
                                      'maxApplicationFee' => resMAF,
                                      'dof' => resDOF,
                                      'maxDof' => resMDOF
                                    };
  }

  public static Decimal getNafValidation(String calcType, QuotingCalculation.CalcParam param, Boolean excludeInsurances) {
    Decimal r = 0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        if (param.vehiclePrice != null) r += param.vehiclePrice + (param.vehiclePrice * QuotingCalculation.getProtectedPercentaje(param.vehiclePrice));
    } else {
        if (param.vehiclePrice != null) r += param.vehiclePrice;
        System.debug('==> inside else before '+ r);
    }
    System.debug('==> r before minus '+ r);
    r-= param.netDeposit;
    System.debug('==> r before exclude'+ r);
    if (excludeInsurances) {
      r += param.totalInsurance;
      System.debug('==> r inside exclude '+ r);
    }
    return r;
  }

  @AuraEnabled
  public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param, Boolean resetBrokerage) {
    Decimal br = 0.00;
    Decimal max = 0.00;
    Decimal bp = param.brokeragePer;
    Decimal cr = param.clientRate;
      //get base rate
      br = QuotingCalculation.getBaseRate(param);
      if (param.hasMaxRate != null && param.hasMaxRate) {
        //get max rate
        max = QuotingCalculation.getMaximunBaseRate(param);
      }
      
      //get client rate
      if (br == max) {
        cr = br;
      } else if (cr > max) {
        cr = max;
      }
    
      //get brokerage percentage
      GreenLightRates__c g = QuotingCalculation.getRateGreenLight(param);
      if(g != null){
        if (
          param.brokeragePer == null || 
          param.brokeragePer > g.Brokerage_Max__c ||
          resetBrokerage
        ) {
          bp = g.Brokerage_Max__c;
        }
      }
 
    return new Map<String, Decimal>{'baseRate' => br, 
                                    'maxRate' => max,
                                    'brokeragePer' => bp,
                                    'clientRate' => cr
                                  };

  }

  @AuraEnabled
  public static List<GreenLightRates__c> getGreenlight(QuotingCalculation.CalcParam param) {
    List<GreenLightRates__c> results = new List<GreenLightRates__c>();
    GreenLightRates__c gl = QuotingCalculation.getRateGreenLight(param);
    if(gl != null){
      results.Add(gl);
    }
    return results;
  }

  @AuraEnabled
  public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
    param.amountBaseComm = getNafValidation(QuotingCalculation.CALC_QUOTING, param, true);
    System.debug('==> calculateRepayments param '+ param);
    return QuoteController.calculateRepayments(param);
  }

  @AuraEnabled
    public static Application_Quoting__c save(QuoteController.AppQuotingWraper param, String approvalType){
       try {
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

    public static PageReference pdfHandler(Application_Quoting__c quote){
      // pass parameters to the PDF page
      PageReference pdf = Page.UniversalCalculatorPdf;

      pdf.getParameters().put('ltv', String.isNotBlank(quote.LTV__c)? quote.LTV__c : '[--none--]');
      pdf.getParameters().put('brokeragePercentage', String.valueOf(quote.Brokerage__c));
      pdf.getParameters().put('paymentType', quote.Payment__c);
      // pass universal variables
      pdf.getParameters().put('id',quote.Opportunity__c+'');
      pdf.getParameters().put('lender', 'GreenLight');

      //Financial Details
      pdf.getParameters().put('loanType',  quote.Loan_Type__c+'');
      pdf.getParameters().put('productLoanType', quote.Loan_Product__c+'');
      pdf.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
      pdf.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
      pdf.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
      pdf.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
      pdf.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
      pdf.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
      pdf.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
      pdf.getParameters().put('ppsr',  NumberUtils.format(quote.PPSR__c));
      pdf.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
      pdf.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
      pdf.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
      pdf.getParameters().put('clientRate', NumberUtils.format(quote.Client_Rate__c));
      pdf.getParameters().put('term', quote.Term__c+'');
      pdf.getParameters().put('paymentType', quote.Payment__c+'');
      pdf.getParameters().put('clientTier', quote.Client_Tier__c+'');
      pdf.getParameters().put('vehicleAge', quote.Vehicle_Age__c+'');
      pdf.getParameters().put('privateSales', quote.Private_Sales__c+'');
      pdf.getParameters().put('productGoodsType', quote.Goods_type__c+'');
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
      return pdf;

  }

  //Lee - 31/08/2022
  public static Product__c productHandler(Application_Quoting__c quote) {
    Product__c p = QuoteController.getProduct(quote.Opportunity__c);

    p.Loan_Purpose__c = 'Personal Use';
    p.Lender__c = 'Green Light';
    p.Quoting_Source__c = 'Green Light';
    p.Repayment_Regularity__c = 'Monthly';
    p.Loan_Type__c = quote.Loan_Type__c;
    p.Loan_Product__c = quote.Loan_Product__c;
    p.Loan_Type_Detail__c = 'Client Tier ' + quote.Client_Tier__c;
    p.Loan_Term__c = quote.Term__c;
    p.Balloon_Residual_Requested__c = quote.Residual_Value__c == null || quote.Residual_Value__c == 0 ? 0:quote.Residual_Value__c;
    p.Client_Rate__c = quote.Client_Rate__c > 0 ? quote.Client_Rate__c: 0.00;
    p.Payments__c = quote.Repayment_Monthly__c > 0 ? quote.Repayment_Monthly__c : 0.00; 
    p.Cost_of_Goods__c = quote.Vehicle_Price__c > 0 ? quote.Vehicle_Price__c : 0.00;
    p.Deposit__c = quote.Net_Deposit__c == null? 0 : quote.Net_Deposit__c;
    p.DOF__c = quote.DOF__c;
    p.Brokerage__c = quote.Commission_Estimation__c == null? 0 : quote.Commission_Estimation__c;
    p.Lender_App_Fee__c = quote.Application_Fee__c;
    p.Equalisation_Fee_PPSR__c = quote.PPSR__c > 0? quote.PPSR__c : 0.00;
    p.Equalisation_Fee_PPSR__c += quote.Risk_Fee__c > 0 ? quote.Risk_Fee__c : 0.00;

    return p;
  }
  
}