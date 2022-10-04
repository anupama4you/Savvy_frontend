public without sharing class QuoteController {
  
  public class AppQuotingWraper {
    @AuraEnabled 
    public Application_Quoting__c data {set;get;}
    @AuraEnabled 
    public Map<String, Application_Quoting_Result__c> results {set;get;}
    @AuraEnabled 
    public Application_InsuranceQuote__c insurance {set;get;}
    @AuraEnabled 
    public Lenders__c settings {set;get;}
    @AuraEnabled 
    public Map<String, List<sObject>> rateSettings {set;get;}
    @AuraEnabled
    public List<String> additionalProcess {set;get;}
    @AuraEnabled
    public List<Application_Quoting_Result__c> calcResults {set;get;}
  }

  public class QuotingDataParam {
    @AuraEnabled 
    public Id oppId {set;get;} 
    @AuraEnabled
    public String calcName {set;get;}
    @AuraEnabled
    public List<String> fields {set;get;}
    @AuraEnabled
    public List<String> rateSettings {set;get;}
  }

  public class QuotingResultWraper {
    @AuraEnabled 
    public Application_Quoting_Result__c commissions {set;get;} 
    @AuraEnabled
    public List<Application_Quoting_Result__c> calResults {set;get;}
  }

  private static List<String> QUOTING_FIELDS = new List<String>{
    'id', 'name'
  };
  // private static List<String> INSURANCE_FIELDS = new List<String>{
  //   'insurance_aic_type__c', '', ' '
  // };

  @AuraEnabled
  public static AppQuotingWraper getQuotingData(QuotingDataParam param) {
    if (param == null || String.isBlank(param.oppId) || param.fields == null || param.fields.isEmpty()) {
      throw new GenericException('Invalid parameters' + '  --- ' + param);
    }

    // Prepare parameters
    List<String> allFields = new List<String>(QUOTING_FIELDS);
    // allFields.addAll(INSURANCE_FIELDS);
    allFields.addAll(param.fields);
    Set<String> uniqFields = new Set<String>(allFields);
    String sqlFields = StringUtils.convertToString(new List<String>(uniqFields));
    
    // Dynamic query
    Id oppIdVal = param.oppId;
    System.debug('param.oppid >> '+ param.oppId);
    String sql = 'SELECT ' + sqlFields + ' FROM Application_Quoting__c ';
    sql += 'WHERE  Opportunity__c = :oppIdVal ORDER BY LastModifiedDate DESC LIMIT 1';
    System.debug('@@sql: ' + sql);

    // 
    AppQuotingWraper r = new AppQuotingWraper();
    List<Application_Quoting__c> d = null;
    try {
      // Query
      d = Database.query(sql);
      System.debug('d >>'+JSON.serialize(d));
      r.data = !d.isEmpty()? d.get(0) : null;
      if (r.data != null) {
        // Results
        r.results = QuotingCalculation.getMapQuotingResultsByQuoId(r.data.Id);
      }
    } catch (Exception e) {
      throw new GenericException(e.getMessage());
    }
    // Settings
    system.debug('param.calcName->'+param.calcName);
    r.settings = QuotingCalculation.getLenderSettings(param.calcName);
      system.debug('r.settings->'+r.settings);
    return r;

  }

  @AuraEnabled
  public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
    Decimal br = 0.00;
    Decimal max = 0.00;
    // try {
    System.debug('param.lender' + param.lender);
      br = QuotingCalculation.getBaseRate(param);
      if (param.hasMaxRate != null && param.hasMaxRate) {
        max = QuotingCalculation.getMaximunBaseRate(param);
      }
    // } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    // }

    return new Map<String, Decimal>{'baseRate' => br, 'maxRate' => max};

  }

  @AuraEnabled
  public static Application_Quoting_Result__c calculateRepayments(QuotingCalculation.CalcParam param) {
    System.debug('param new >>> ' + JSON.serialize(param));
    QuotingResultWraper r = calculateAllRepayments(param, null);

    return r.commissions;
  }

  
  public static Map<String, List<sObject>> loadRateSettings(List<String> settings) {
    Map<String, List<sObject>> r = new Map<String, List<sObject>>();
    if (settings != null) {
      for (String objName: settings) {
        Set<String> fields = Utilities.getCustomFields(objName);
        String sqlFields = StringUtils.convertToString(new List<String>(fields));
        if (!fields.isEmpty()) {
          String sql = 'SELECT ' + sqlFields + ' FROM ' + objName;
          sql += ' ORDER BY Name';
          System.debug('@@lenderSettings sql: ' + sql);
          try {
            // Query
            List<sObject> d = Database.query(sql);
            r.put(objName, d);
          } catch (Exception e) {
            throw new GenericException(e.getMessage());
          }
        }
      }
    }
    return r;
  }

  //  Application_Quoting__c
   @AuraEnabled 
   public static AppQuotingWraper saveQuoting(AppQuotingWraper param){
    //  try {
       // - MARK: SAVING Quote to server  
       System.debug('param in saveQuoting ... >> '+ JSON.serialize(param));
       QuotingToolHelper.saveApplicationQuoting(param.data);
       if(param.additionalProcess != null && param.additionalProcess.size() > 0 && param.additionalProcess[0] == 'SEND'){
        System.debug('Send presentation Email to Customer ... ' + JSON.serialize(param));
        QuoteInsuranceController.sendCustomerPresentation(param.insurance, param.data);
       }
       // Save calculations 
      //  Map<String,Application_Quoting_Result__c> resultList = new Map<String,Application_Quoting_Result__c>();
      //  resultList.put('Quoting', param.results.get('commissions'));
      //  QuotingCalculation.saveQuotingResults(param.data.Opportunity__c, resultList.values());

       if (param.calcResults != null) {
        QuotingCalculation.saveQuotingResults(param.data.Id, param.calcResults);
       }

       return param;
      //  Save the record 
    //  } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    //  }
   }

  public static Custom_Opportunity__c getOpportunityById(Id oppId){
    try {
      List<Custom_Opportunity__c> opp = [
        SELECT Application__c, State__c, Application__r.State__c, Loan_Product__c, Account__c, Owner_Name__c, Email_Address__c, Lead__c,
        Owner_Phone__c, Owner_Mobile__c, Owner_Email__c, Account__r.FirstName, Account__r.RecordTypeId, Account__r.IsPersonAccount, First_Name__c, 
        Last_Name__c, Name, OwnerId, Application_AssetDetail__r.Type__c, Application__r.Type_of_Asset__c, Application__r.Application_Type__c, 
        Application_AssetDetail__r.Rego__c, Application_AssetDetail__r.Rego_State__c, Application_AssetDetail__r.Engine_No__c, 
        Application_AssetDetail__r.VIN__c, Application__r.Mode_of_Employment_1__c,  Application__r.Title_1__c, Credit_Score__c,
        Application__r.No_of_Dependants_1__c,Application__r.No_of_People__c, Application__r.Status__c, Application__r.Marital_Status_1__c,
        Application__r.Date_of_Birth_1__c, Application__r.First_Name__c, Application__r.Last_Name__c,  Application__r.Entity_Name__c
        FROM Custom_Opportunity__c WHERE Id = :oppId
      ];
      return !opp.isEmpty()? opp[0] : null;
    } catch (Exception e) {
      throw new GenericException(e.getMessage());
    }
  }
   
   public static void savePdf(String approvalType, PageReference calcPdf, AppQuotingWraper param){
    // try {
      Id applicationId = getOpportunityById(param.data.Opportunity__c).Application__c;
      // saving pdf in cloud?
      Boolean isSaveInCloud = false;
      if(approvalType.contains('APPROVAL')){
          isSaveInCloud = true;
          String typeData = 'Quoting Calculation';
          if(approvalType.contains('AMENDMENT')){
              typeData = 'Quoting Calculation (Amendment)';
          }
          if(approvalType.contains('FORMAL')){
              typeData = 'Quoting Calculation (Formal Approval)';
          }
          ApplicationExtraDataHelper.upsertData(applicationId, typeData, 
          typeData, QuotingToolHelper.getApplicationQuoting(applicationId));
      }
      String fileName = param.data.Name + '_' + approvalType;
      QuotingToolHelper.attachPdfFile(param.data.Opportunity__c, 
      fileName, calcPdf, isSaveInCloud);
    // } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    // }
   }

   public static Product__c getProduct(Id oppId){
     Custom_Opportunity__c opp = getOpportunityById(oppId);
     Product__c p = null;
     try {
       // get Custom_Opportunity__c
       // create product
       if(opp.Loan_Product__c == null){
         Id recId = SOQLSingletonQueries.recs().recordTypes.get('Finance');
           p = new Product__c(RecordTypeId = recId,
           Opportunity_Name__c = opp.Id);
       } else {
           p = [Select id, Loan_Purpose__c, Lender__c, Repayment_Regularity__c,
                        Loan_Type__c, Loan_Term__c, Balloon_Residual_Requested__c,
                        Client_Rate__c, Payments__c, Cost_of_Goods__c, Deposit__c,
                        Brokerage__c, Lender_App_Fee__c, Equalisation_Fee_PPSR__c, DOF__c,
                        Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                        from Product__c where id =: opp.Loan_Product__c];
       }
     }
     catch (Exception ex) {
      throw new GenericException(ex.getMessage());
     }
      return p;
   }

    // send email to customer
    @AuraEnabled
    public static AppQuotingWraper sendQuote(AppQuotingWraper param){
      try {
        saveQuoting(param);
        Custom_Opportunity__c opp = getOpportunityById(param.data.Opportunity__c);
        EmailSender.QuotingEmailParam emailParam = new EmailSender.QuotingEmailParam(opp, param.data);
        EmailSender.sendQuotingEmailToCustomer(emailParam);
        return param;
      }
      catch (Exception ex) {
        throw new GenericException(ex.getMessage());
      }  
    }

    // general function calling from each calculatror
    public static void saveProduct(AppQuotingWraper param, Product__c p){
      try {
        Custom_Opportunity__c opp = getOpportunityById(param.data.Opportunity__c);
        if (p.Id == null) {
          insert p;
          opp.Loan_Product__c = p.Id;
          update opp;
        } else {
            update p;
        }
        // Insurances
        QuotingToolHelper.removePreviousInsurances(param.data.Opportunity__c);
        // Add products
        List<Product__c> productList = new List<Product__c>();
        Application_Quoting__c quote = param.data;
        // Gap Insurance
        if ('A'.equals(quote.Insurance_GAP_Acceptance__c)) {
          System.debug('Creasting GAP product...');
          String insurer = 'AIC/Eric';
          String insType = 'Gap Insurance';
          if (InsuranceQuoteUtils.isLibertyInsProduct(quote.Insurance_Shortfall_Options__c)) {
            insurer = 'Liberty Financial';
            insType = 'VEI';
          }      
          Product__c ins = QuotingToolHelper.buildInsProduct(
            quote.Opportunity__c, insurer, insType, 
            quote.Insurance_GAP_Retail_Price__c, 
            quote.Insurance_GAP_Income__c, 
            quote.Insurance_GAP_PayType__c
          );
          productList.add(ins);
        }

        // LPI Insurance (CCI)
        if ('A'.equals(quote.Insurance_AIC_Acceptance__c)) {
          System.debug('Creasting LPI product...');
          String insurer = 'AIC/Eric';
          String insType = 'CCI';
          if (InsuranceQuoteUtils.isLibertyInsProduct(quote.Insurance_LPI_Options__c)) {
            insurer = 'Liberty Financial';
            insType = 'Loan Protection';
          }      
          Product__c ins = QuotingToolHelper.buildInsProduct(
            quote.Opportunity__c, insurer, insType, 
            quote.Insurance_AIC_Retail_Price__c, 
            quote.Insurance_AIC_Income__c, 
            quote.Insurance_AIC_PayType__c
          );
          productList.add(ins);
        }

        // MV Insurance
        if ('A'.equals(quote.Insurance_MV_Acceptance__c)) {
          String insurer = InsuranceQuoteUtils.INS_PROD_MV_SUNCORP.equals(
            quote.Insurance_MV_Options__c
          ) ? InsuranceQuoteUtils.INS_PROD_MV_SUNCORP : 'Comprehensive';
          Product__c ins = QuotingToolHelper.buildInsProduct(
            quote.Opportunity__c, insurer, 'Full Comprehensive', 
            quote.Insurance_MV_Retail_Price__c, 
            quote.Insurance_MV_Income__c, 
            'PBM'
          );
          productList.add(ins);
        }

        // Warranty Insurance
        if ('A'.equals(quote.Insurance_Warranty_Acceptance__c)) {
          System.debug('Creasting Warranty product...');
          Product__c ins = QuotingToolHelper.buildInsProduct(
            quote.Opportunity__c, 'AIC/Eric', 'Warranty', 
            quote.Insurance_Warranty_Retail_Price__c, 
            quote.Insurance_Warranty_Income__c, 
            quote.Insurance_Warranty_PayType__c
          );
          productList.add(ins);
        }

        // NWC Insurance
        if ('A'.equals(quote.Insurance_NWC_Acceptance__c)) {
          System.debug('Creasting NWC product...');
          Product__c ins = QuotingToolHelper.buildInsProduct(
            quote.Opportunity__c, 'Integrity', 'Warranty', 
            quote.Insurance_NWC_Retail_Price__c, 
            quote.Insurance_NWC_Income__c, 
            quote.Insurance_NWC_PayType__c
          );
          productList.add(ins);
        }
        System.debug('Adding ' + productList.size() + ' insurance product(s)');
        if (productList.size() > 0) {
          insert productList;
        }

      }
      catch (Exception ex) {
        throw new GenericException(ex.getMessage());
      }
     
    }

  @AuraEnabled
  public static QuotingResultWraper calculateAllRepayments(
    QuotingCalculation.CalcParam param, InsuranceParam insuranceParam
  ) {
    QuotingResultWraper r = new QuotingResultWraper();
    System.debug('param new >>> ' + JSON.serialize(param));

    // Update Insurances
    param.totalInsurance = (insuranceParam != null) 
      ? insuranceParam.getTotalInsuranceType(
          QuotingCalculation.CALC_QUOTING
        )
      : 0.00;
    
    param.totalInsuranceIncome = (insuranceParam != null) 
      ? insuranceParam.getTotalInsuranceIncomeType(
          QuotingCalculation.CALC_QUOTING
        )
      : 0.00;

    r.calResults = new List<Application_Quoting_Result__c>();
    Application_Quoting_Result__c qr = QuotingCalculation.calculate(param);
    if (qr != null) {
      qr.Result_Type__c = QuotingCalculation.CALC_QUOTING;
      r.commissions = qr;
      r.calResults.add(qr);
    }
    
    // Simple
    param.totalInsurance = 0;
    param.totalInsuranceIncome = 0;
    qr = QuotingCalculation.calculate(param);
    if (qr != null) {
      qr.Result_Type__c = QuotingCalculation.CALC_SIMPLE;
      r.calResults.add(qr);
    }

    if (insuranceParam != null) {
      Set<String> calcTypes = new Set<String>();
      // GAP
      if (insuranceParam.shortfallRetailPrice > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
      }
      // WARR
      if (insuranceParam.warrantyRetailPrice > 0) {
        calcTypes.add(
          'Integrity'.equals(insuranceParam.warrantyType)
          ? InsuranceQuoteUtils.INS_PROD_NWC
          : InsuranceQuoteUtils.INS_PROD_WARR
        );
      }
      // LPI
      if (insuranceParam.lpiRetailPrice > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
      }
      for (String key : calcTypes) {
        param.totalInsurance = insuranceParam.getTotalInsuranceType(key);
        param.totalInsuranceIncome = insuranceParam.getTotalInsuranceIncomeType(key);
        qr = QuotingCalculation.calculate(param);
        if (qr != null) {
          qr.Result_Type__c = key;
          r.calResults.add(qr);
        }
      }
    }
    return r;
  }

  public class InsuranceParam {
    // MV
    @AuraEnabled 
    public String mvType {set;get;} 
    @AuraEnabled 
    public String mvProduct {set;get;} 
    @AuraEnabled 
    public Decimal mvRetailPrice {set;get;} 
    @AuraEnabled 
    public Decimal mvCommission {set;get;} 
    @AuraEnabled 
    public String mvPayment {set;get;} 
    @AuraEnabled 
    public String mvTerm {set;get;} 
    @AuraEnabled 
    public String mvPBM {set;get;} 
    @AuraEnabled 
    public String mvAcceptance {set;get;} 

    // GAP -> Shortfall
    @AuraEnabled 
    public String shortfallType {set;get;} 
    @AuraEnabled 
    public String shortfallProduct {set;get;} 
    @AuraEnabled 
    public Decimal shortfallRetailPrice {set;get;} 
    @AuraEnabled 
    public Decimal shortfallCommission {set;get;} 
    @AuraEnabled 
    public String shortfallPayment {set;get;} 
    @AuraEnabled 
    public String shortfallTerm {set;get;} 
    @AuraEnabled 
    public String shortfallPBM {set;get;} 
    @AuraEnabled 
    public String shortfallAcceptance {set;get;} 

    // LPI
    @AuraEnabled 
    public String LPIType {set;get;} 
    @AuraEnabled 
    public String LPIProduct {set;get;} 
    @AuraEnabled 
    public Decimal LPIRetailPrice {set;get;} 
    @AuraEnabled 
    public Decimal LPICommission {set;get;} 
    @AuraEnabled 
    public String LPIPayment {set;get;} 
    @AuraEnabled 
    public String LPITerm {set;get;} 
    @AuraEnabled 
    public String LPIPBM {set;get;} 
    @AuraEnabled 
    public String LPIAcceptance {set;get;} 

    // Warranty
    @AuraEnabled 
    public String warrantyType {set;get;} 
    @AuraEnabled 
    public String warrantyProduct {set;get;} 
    @AuraEnabled 
    public Decimal warrantyRetailPrice {set;get;} 
    @AuraEnabled 
    public Decimal warrantyCommission {set;get;} 
    @AuraEnabled 
    public String warrantyPayment {set;get;} 
    @AuraEnabled 
    public String warrantyTerm {set;get;} 
    @AuraEnabled 
    public String warrantyPBM {set;get;} 
    @AuraEnabled 
    public String warrantyAcceptance {set;get;} 
    @AuraEnabled 
    public IntegrityParam integrity {set;get;}

    //Acceptance
    @AuraEnabled 
    public Boolean ismvAccept {set;get;}
    @AuraEnabled 
    public Boolean isshortfallAccept {set;get;}
    @AuraEnabled 
    public Boolean iswarrantyAccept {set;get;}
    @AuraEnabled 
    public Boolean isLPIAccept {set;get;}

    public InsuranceParam() {
      this.ismvAccept = false;
      this.isshortfallAccept = false;
      this.iswarrantyAccept = false;
      this.isLPIAccept = false;
    }

    public Decimal getTotalInsuranceType(String calcType) {
      Decimal r = 0.0;
      if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
        // Shortfall / GAP
        if (this.isshortfallAccept && 'Financed'.equals(this.shortfallPBM)) {
          r += (this.shortfallRetailPrice > 0)? this.shortfallRetailPrice : 0.0;
        }
        // Warranty
        if (this.iswarrantyAccept && 'Financed'.equals(this.warrantyPBM)) {
          r += (this.warrantyRetailPrice > 0)? this.warrantyRetailPrice : 0.0;
        }
        // LPI
        if (this.isLPIAccept && 'Financed'.equals(this.LPIPBM)) {
          r += (this.LPIRetailPrice > 0)? this.LPIRetailPrice : 0.0;
        }
        //-
      } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
        // Shortfall / GAP
        r += (this.shortfallRetailPrice > 0)? this.shortfallRetailPrice : 0.0;
      } else if (
        InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType) ||
        InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)
      ) {
        // Warranty
        r += (this.warrantyRetailPrice > 0)? this.warrantyRetailPrice : 0.0;
      } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
        r += (this.LPIRetailPrice > 0)? this.LPIRetailPrice : 0.0;
      }
      return r;
    }

    public Decimal getTotalInsuranceIncomeType(String calcType) {
      Decimal r = 0.0;
      if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
        // Shortfall / GAP
        if (this.isshortfallAccept) {
          r += (this.shortfallCommission > 0)? this.shortfallCommission : 0.0;
        }
        // Warranty
        if (this.iswarrantyAccept) {
          r += (this.warrantyCommission > 0)? this.warrantyCommission : 0.0;
        }
        // LPI
        if (this.isLPIAccept) {
          r += (this.LPICommission > 0)? this.LPICommission : 0.0;
        }
        //-
      } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
        // Shortfall / GAP
        r += (this.shortfallCommission > 0)? this.shortfallCommission : 0.0;
      } else if (
        InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType) ||
        InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)
      ) {
        // Warranty
        r += (this.warrantyCommission > 0)? this.warrantyCommission : 0.0;
      } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
        r += (this.LPICommission > 0)? this.LPICommission : 0.0;
      }
      return r;
    }
  }

  public class IntegrityParam {
    // Integrity
    @AuraEnabled 
    public String type {set;get;} 
    @AuraEnabled 
    public String term {set;get;} 
    @AuraEnabled 
    public String category {set;get;} 
  }

  public static PageReference createPdf(Application_Quoting__c quote) {
    PageReference rpt = Page.UniversalCalculatorPdf;
    if (quote != null) {
      // ID
      rpt.getParameters().put('id',quote.Opportunity__c);

      // MV
      rpt.getParameters().put('mvLevel', null);
      rpt.getParameters().put('mv', String.valueOf(0.00));
      rpt.getParameters().put('mvIncome', String.valueOf(0.00));
      rpt.getParameters().put('mvPayType', null);
      if ('A'.equals(quote.Insurance_MV_Acceptance__c)) {
        String level = quote.Insurance_MV_Type__c + ' [ ' + quote.Insurance_MV_Options__c + ' ] ';
        rpt.getParameters().put('mvLevel', quote.Insurance_MV_Type__c);
        rpt.getParameters().put('mv', String.valueOf(quote.Insurance_MV_Retail_Price__c));
        rpt.getParameters().put('mvIncome', String.valueOf(quote.Insurance_MV_Income__c));
        rpt.getParameters().put('mvPayType', 'PBM');
      }

      // GAP - SHORTFALL
      rpt.getParameters().put('gapLevel', null);
      rpt.getParameters().put('gap', String.valueOf(0.00));
      rpt.getParameters().put('gapIncome', String.valueOf(0.00));
      if ('A'.equals(quote.Insurance_GAP_Acceptance__c)) {
        String a = quote.Insurance_Shortfall_Options__c;
        a += String.isNotBlank(quote.Insurance_GAP_Type__c)? ' [' + quote.Insurance_GAP_Type__c + ']': '';
        rpt.getParameters().put('gapLevel', a);
        rpt.getParameters().put('gap', String.valueOf(quote.Insurance_GAP_Retail_Price__c));
        rpt.getParameters().put('gapIncome', String.valueOf(quote.Insurance_GAP_Income__c));
        rpt.getParameters().put('gapPayType', quote.Insurance_GAP_PayType__c);
      }

      // LPI
      rpt.getParameters().put('cciLevel', null);
      rpt.getParameters().put('cci', String.valueOf(0.00));
      rpt.getParameters().put('cciIncome', String.valueOf(0.00));
      if ('A'.equals(quote.Insurance_AIC_Acceptance__c)) {
        rpt.getParameters().put('cciLevel', quote.Insurance_LPI_Options__c + ' [' + quote.Insurance_AIC_Type__c + ']');
        rpt.getParameters().put('cci', String.valueOf(quote.Insurance_AIC_Retail_Price__c));
        rpt.getParameters().put('cciIncome', String.valueOf(quote.Insurance_AIC_Income__c));
        rpt.getParameters().put('cciPayType', quote.Insurance_AIC_PayType__c);
      }

      // Warranty
      rpt.getParameters().put('warrantyLevel', null);
      rpt.getParameters().put('warranty', String.valueOf(0.00));
      rpt.getParameters().put('warrantyIncome', String.valueOf(0.00));
      if ('A'.equals(quote.Insurance_Warranty_Acceptance__c)) {
        rpt.getParameters().put('warrantyLevel', quote.Insurance_Warranty_Type__c);
        rpt.getParameters().put('warranty', String.valueOf(quote.Insurance_Warranty_Retail_Price__c));
        rpt.getParameters()
          .put('warrantyIncome', String.valueOf(quote.Insurance_Warranty_Income__c));
        rpt.getParameters().put('warrantyPayType', quote.Insurance_Warranty_PayType__c);
      }

      // NWC - Integrity
      rpt.getParameters().put('nwcLevel', null);
      rpt.getParameters().put('nwc', String.valueOf(0.00));
      rpt.getParameters().put('nwcIncome', String.valueOf(0.00));
      if ('A'.equals(quote.Insurance_NWC_Acceptance__c)) {
        rpt.getParameters().put('nwc', String.valueOf(quote.Insurance_NWC_Retail_Price__c));
        rpt.getParameters().put('nwcIncome', String.valueOf(quote.Insurance_NWC_Income__c));
        rpt.getParameters().put('nwcPayType', quote.Insurance_NWC_PayType__c);
        String nwcLevel = String.isNotBlank(quote.Insurance_NWC_TypeP__c)? quote.Insurance_NWC_TypeP__c : 'Integrity';
        rpt.getParameters().put('nwcLevel', nwcLevel);
        //NWC Calculator - HJ - 31-08-2018 - I
        // String nwcAwd4wd = '';
        // String nwcLuxuryCar = '';
        // if (isAssetCar) {
        //   nwcAwd4wd = nwcParam.awd4wd;
        //   nwcLuxuryCar = nwcParam.luxuryCar;
        // }
        String nwcEngine = '';
        String nwcType_p = quote.Insurance_NWC_TypeP__c;
        // if (isAssetBoat) {
        //   nwcEngine = quote.Insurance_NWC_TypeP__c;
        //   nwcType_p = '';
        // }
        String nwcIsManuallyNWCPrice = (quote.Insurance_NWC_Is_Manually_Value__c)? 'Y' : 'N';
        
        // rpt.getParameters().put('nwcAwd4wd', nwcAwd4wd);
        // rpt.getParameters().put('nwcLuxuryCar', nwcLuxuryCar);
        rpt.getParameters().put('nwcType_p', nwcType_p);
        rpt.getParameters().put('nwcEngine', nwcEngine);
        rpt.getParameters()
          .put('nwcIsManuallyNWCPrice', nwcIsManuallyNWCPrice);
        rpt.getParameters().put('nwcTerm', quote.Insurance_NWC_Term__c);
        // rpt.getParameters().put('nwcAssetType', nwcParam.assetType);
        // rpt.getParameters().put('nwcState', nwcParam.state);
        rpt.getParameters().put('nwcPlan', quote.Insurance_NWC_Plan__c);
      }
      
      // Details
      rpt.getParameters().put('loanType',  quote.Loan_Type__c+'');
      rpt.getParameters().put('productLoanType', quote.Loan_Product__c+'');

      rpt.getParameters().put('carPrice', NumberUtils.format(quote.Vehicle_Price__c));
      rpt.getParameters().put('deposit', NumberUtils.format(quote.Deposit__c));
      rpt.getParameters().put('tradeIn', NumberUtils.format(quote.Trade_In__c));
      rpt.getParameters().put('payoutOn', NumberUtils.format(quote.Payout_On__c));
      rpt.getParameters().put('netDeposit', NumberUtils.format(quote.Net_Deposit__c));
      rpt.getParameters().put('applicationFee', NumberUtils.format(quote.Application_Fee__c));
      rpt.getParameters().put('dof', NumberUtils.format(quote.DOF__c));
      rpt.getParameters().put('ppsr',  NumberUtils.format(quote.PPSR__c));
      rpt.getParameters().put('residualValue', NumberUtils.format(quote.Residual_Value__c));
      rpt.getParameters().put('baseRate', NumberUtils.format(quote.Base_Rate__c));
      rpt.getParameters().put('maxRate', NumberUtils.format(quote.Manual_Max_Rate__c));
      Decimal cr = quote.Client_Rate__c != null? quote.Client_Rate__c.setScale(2) : 0.00;
      rpt.getParameters().put('clientRate', NumberUtils.format(cr));
      rpt.getParameters().put('term', quote.Term__c+'');
      rpt.getParameters().put('paymentType', quote.Payment__c+'');
      rpt.getParameters().put('monthlyFee', NumberUtils.format(quote.Monthly_Fee__c));


      // ---- commissions -----
      rpt.getParameters().put('estimatedCommission', NumberUtils.format(quote.Commission_Estimation__c));
      rpt.getParameters().put('insuranceIncome', NumberUtils.format(quote.Commission_Insurance_Income__c));
      rpt.getParameters().put('dofResult', NumberUtils.format(quote.Commission_DOF__c));
      rpt.getParameters().put('totalCommission', NumberUtils.format(quote.Commission_Total_GST_Exc__c));
      rpt.getParameters().put('totalCommissionGst', NumberUtils.format(quote.Commission_Total_GST_Inc__c));
      rpt.getParameters().put('naf', NumberUtils.format(quote.NAF__c));
      rpt.getParameters().put('rental', NumberUtils.format(quote.Rental__c));
      rpt.getParameters().put('monthlyPayment', NumberUtils.format(quote.Repayment_Monthly__c));
      rpt.getParameters().put('fortnightlyPayment', NumberUtils.format(quote.Repayment_Fortnightly__c));
      rpt.getParameters().put('weeklyPayment', NumberUtils.format(quote.Repayment_Weekly__c));
      // ---- end commissions -----

    }
    return rpt;
  }



}