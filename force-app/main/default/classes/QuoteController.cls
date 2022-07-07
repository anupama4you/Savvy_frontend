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
      throw new GenericException('Invalid parameters');
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

}