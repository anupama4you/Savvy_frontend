public without sharing class QuoteInsuranceController {
  private static Map<String, Map<String, Liberty_VEI_Setting__c>> libVeiSettings = null;
  private static Application__c application = null;
  private static Custom_Opportunity__c opp = null;

  @AuraEnabled
  public static Map<String, String> loadData(Id oppId) {
    Map<String, String> result = new Map<String, String>();
    opp = getOpp(oppId);
    if (opp != null && opp.Application__c != null) {
      result.put('typeOfAsset', opp.Application__r.Type_of_Asset__c);
    }
    return result;
  }

  @AuraEnabled
  public static String getPresentationStatus(Id appQuoteId) {
    Application_Quoting__c appQuote = null;
    String r = null;
    Application_InsuranceQuote__c appInsuranceQuote = null;
    if (appQuoteId != null) {
      appQuote = [
        SELECT
          Presentation_Email_Date__c,
          App_Insurance_Quote__c,
          App_Insurance_Quote__r.Customer_Choice_Status__c
        FROM Application_Quoting__c
        WHERE Id = :appQuoteId
      ][0];
      r = appQuote.App_Insurance_Quote__c != null &&
        String.isNotBlank(
          appQuote.App_Insurance_Quote__r.Customer_Choice_Status__c
        )
        ? appQuote.App_Insurance_Quote__r.Customer_Choice_Status__c
        : 'NONE';
    }
    return r;
  }

  @AuraEnabled
  public static Map<String, Decimal> calculateGAP(Id oppId, String option) {
    Map<String, Decimal> gap = new Map<String, Decimal>();
    Custom_Opportunity__c opp = getOpp(oppId);
    if (opp != null) {
      String state = opp.State__c != null ? opp.State__c : null;
      state = String.isBlank(state) && String.isNotBlank(opp.Application__c) 
        ? opp.Application__r.State__c : state;
      Liberty_VEI_Setting__c a = getLibertyVEISetting(state, option);
      if (a != null) {
        gap.put('gap', a.Retail__c); // retail price
        gap.put('gapIncome', a.Commission__c); // commission
      } else {
        gap.put('gap', 0.00);
        gap.put('gapIncome', 0.00);
      }
    }
    return gap;
  }

  // Calculate Retail price and commission for Integrity
  @AuraEnabled
  public static Map<String, Decimal> calculateNWC(
    String category,
    String term,
    String type,
    Application_Quoting__c data
  ) {
    Map<String, Decimal> result = new Map<String, Decimal>();
    NWCCalc.Parameter nwcParam = new NWCCalc.Parameter();
    try {
      Custom_Opportunity__c opp = getOpp(data.Opportunity__c);

      String state = opp.State__c != null ? opp.State__c : null;
      state = String.isBlank(state) && String.isNotBlank(opp.Application__c) 
        ? opp.Application__r.State__c : state;      

      String assetType = String.isNotBlank(opp.Application__c) 
        ? opp.Application__r.Type_of_Asset__c : null;      

      nwcParam.plan = category;
      nwcParam.term = term;
      nwcParam.type_p = type;
      nwcParam.state = state;
      nwcParam.assetType = assetType; // hard code here
      NWCCalc.Result r = NWCCalc.CalculateNWC(nwcParam);
      result.put('retailPrice', (r != null) ? r.retailPrice : 0.0);
      result.put('commission', (r != null) ? r.commission : 0.0);
      return result;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static Map<String, Decimal> calculateLPI(
    Id oppId,
    Decimal term,
    String cciLevel,
    Application_Quoting__c data,
    Boolean iswarrantyAccept,
    Decimal warrantyRetailPrice
  ) {
    // try {
      System.debug('data >> ' + JSON.serialize(data));
      Map<String, Decimal> lpi = new Map<String, Decimal>();
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
        'Liberty'
      );
      Custom_Opportunity__c opp = getOpp(oppId);
      if (opp != null) {
        param.totalAmount = getLPITotalAmount(
          QuotingCalculation.CALC_QUOTING,
          data,
          iswarrantyAccept,
          warrantyRetailPrice
        );
        param.lpiLevel = cciLevel;
        param.term = term;
        param.state = String.isNotBlank(opp.State__c)? opp.State__c : null;
        if (String.isNotBlank(opp.Application__c)) {
          Application__c app = opp.Application__r;
          param.state = String.isNotBlank(app.State__c)? app.State__c : param.state;
          param.dateOfBirth = app.Date_of_Birth_1__c;
          param.maritalStatus = app.Marital_Status_1__c;
          param.noOfDependants = app.No_of_Dependants_1__c;
          param.noOfPeople = app.No_of_People__c;
        }
      }
      System.debug('param in calculateLPI >> ' + param);
      QuotingCalculation.LibertyLPI p = QuotingCalculation.calculateLibertyLPI(
        param
      );
      lpi.put('cci', p != null? p.premium.setScale(2) : 0.00);
      lpi.put('cciIncome', p != null? p.income.setScale(2) : 0.00);
      return lpi;
    // } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    // }
  }

  private static Decimal getLPITotalAmount(
    String calcType,
    Application_Quoting__c data,
    Boolean iswarrantyAccept,
    Decimal warrantyRetailPrice
  ) {
    Decimal r = 0.0;
    if (data != null) {
      r += (data.Vehicle_Price__c != null) ? data.Vehicle_Price__c : 0.00;
      r += (data.Application_Fee__c != null) ? data.Application_Fee__c : 0.00;
      r += (data.DOF__c != null) ? data.DOF__c : 0.00;
      r += (data.PPSR__c != null) ? data.PPSR__c : 0.00;
      r -= (data.Net_Deposit__c != null) ? data.Net_Deposit__c : 0.00;
    }
    // adding warranty part
    if (iswarrantyAccept == true) {
      r += warrantyRetailPrice > 0 ? warrantyRetailPrice : 0.00;
    }
    return r;
  }

  private static Custom_Opportunity__c getOpp(Id oppId) {
    return QuoteController.getOpportunityById(oppId);
  }

  private static Liberty_VEI_Setting__c getLibertyVEISetting(
    String state,
    String option
  ) {
    if (String.isBlank(state) || String.isBlank(option)) {
      return null;
    }
    String opt = 'Option 3';
    if (option.startsWith('Option 1')) {
      opt = 'Option 1';
    } else if (option.startsWith('Option 2')) {
      opt = 'Option 2';
    }
    if (libVeiSettings == null || libVeiSettings.isEmpty()) {
      //Load settings
      libVeiSettings = new Map<String, Map<String, Liberty_VEI_Setting__c>>();
      for (
        Liberty_VEI_Setting__c a : Liberty_VEI_Setting__c.getAll().values()
      ) {
        Map<String, Liberty_VEI_Setting__c> x = libVeiSettings.get(a.State__c);
        if (x == null) {
          x = new Map<String, Liberty_VEI_Setting__c>();
          libVeiSettings.put(a.State__c, x);
        }
        x.put(a.Cover_Option__c, a);
      }
    }
    Liberty_VEI_Setting__c r = null;
    Map<String, Liberty_VEI_Setting__c> d = libVeiSettings.get(state);
    if (d != null && !d.isEmpty()) {
      r = d.get(opt);
    }
    return r;
  }
}