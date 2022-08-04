public without sharing class QuoteController {
  
  public class AppQuotingWraper {
    @AuraEnabled 
    public Application_Quoting__c data {set;get;}
    @AuraEnabled 
    public Map<String, Application_Quoting_Result__c> results {set;get;}
    @AuraEnabled 
    public Lenders__c settings {set;get;}
    @AuraEnabled 
    public Map<String, List<sObject>> rateSettings {set;get;}
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

  private static List<String> QUOTING_FIELDS = new List<String>{
    'id', 'name'
  };
  private static List<String> INSURANCE_FIELDS = new List<String>{
    'insurance_aic_type__c', '', ' '
  };

  @AuraEnabled
  public static AppQuotingWraper getQuotingData(QuotingDataParam param) {
    if (param == null || String.isBlank(param.oppId) || param.fields == null || param.fields.isEmpty()) {
      throw new GenericException('Invalid parameters' + '  --- ' + param);
    }

    // Prepare parameters
    List<String> allFields = new List<String>(QUOTING_FIELDS);
    allFields.addAll(INSURANCE_FIELDS);
    allFields.addAll(param.fields);
    Set<String> uniqFields = new Set<String>(allFields);
    String sqlFields = StringUtils.convertToString(new List<String>(uniqFields));
    
    // Dynamic query
    Id oppIdVal = param.oppId;
    String sql = 'SELECT ' + sqlFields + ' FROM Application_Quoting__c ';
    sql += 'WHERE  Opportunity__c = :oppIdVal ORDER BY LastModifiedDate DESC LIMIT 1';
    System.debug('@@sql: ' + sql);

    // 
    AppQuotingWraper r = new AppQuotingWraper();
    List<Application_Quoting__c> d = null;
    try {
      // Query
      d = Database.query(sql);
      r.data = !d.isEmpty()? d.get(0) : null;
      if (r.data != null) {
        // Results
        r.results = QuotingCalculation.getMapQuotingResultsByQuoId(r.data.Id);
      }
    } catch (Exception e) {
      throw new GenericException(e.getMessage());
    }
    // Settings
    r.settings = QuotingCalculation.getLenderSettings(param.calcName);
    return r;

  }

  @AuraEnabled
  public static Map<String, Decimal> getBaseRates(QuotingCalculation.CalcParam param) {
    Decimal br = 0.00;
    Decimal max = 0.00;
    // try {
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
    return QuotingCalculation.calculate(param);
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
       QuotingToolHelper.saveApplicationQuoting(param.data);
       // Save calculations 
       List<Application_Quoting_Result__c> resultList = new List<Application_Quoting_Result__c>();
       resultList.add(param.results.get('commissions'));
       QuotingCalculation.saveQuotingResults(param.data.Opportunity__c, resultList);
       return param;
      //  Save the record 
    //  } catch (Exception e) {
    //   throw new GenericException(e.getMessage());
    //  }
   }

  public static Custom_Opportunity__c getOpportunityById(Id oppId){
    try {
      List<Custom_Opportunity__c> opp = [
        SELECT Application__c, State__c, Application__r.State__c, Loan_Product__c, Account__c, Owner_Name__c, Email_Address__c,
        Owner_Phone__c, Owner_Mobile__c, Owner_Email__c, Account__r.FirstName
        FROM Custom_Opportunity__c WHERE Id = :oppId
      ];
      return opp[0];
    }
    catch (Exception e) {
      throw new GenericException(e.getMessage());
    }
  }
   
   public static void savePdf(String approvalType, PageReference calcPdf, AppQuotingWraper param){
    try {
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
    }
    catch (Exception e) {
      throw new GenericException(e.getMessage());
    }
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
        QuotingToolHelper.removePreviousInsurances(param.data.Opportunity__c);
      }
      catch (Exception ex) {
        throw new GenericException(ex.getMessage());
      }
     
    }

}