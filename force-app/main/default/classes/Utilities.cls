public class Utilities {
    
    public static final String STATES = 'STATES';
    public static final String McQ_RESIDENCY_STATUS = 'McQ_RESIDENCY_STATUS';
    public static final String McQ_RESIDENTIAL_STATUS = 'McQ_RESIDENTIAL_STATUS';
    public static final String McQ_EMPLOYMENT_TYPE = 'McQ_EMPLOYMENT_TYPE';
    public static final String McQ_DOCUMENTS_TYPE = 'McQ_DOCUMENTS_TYPE';
    public static final String McQ_ERRORS_DATA = 'McQ_ERRORS_DATA';
    public static final String McQ_BASIS = 'McQ_BASIS';
    public static final String McQ_CONSUMER_KEY = 'McQ_CONSUMER_KEY';
    
    public static final String LiB_INCOME_TYPES = 'LiB_INCOME_TYPES';
    public static final String LiB_LIABILITY_TYPES = 'LiB_LIABILITY_TYPES';
    public static final String LiB_LICENCE_TYPES = 'LiB_LICENCE_TYPES';
    public static final String LiB_LICENCE_TYPES_SUB = 'LiB_INCOME_TYPES_SUB';
    public static final String LiB_EMPLOYMENT_TYPES = 'LiB_EMPLOYMENT_TYPES';
    public static final String LiB_COMPANY_TYPE = 'LiB_COMPANY_TYPE';
    public static final String LiB_ADDRESS_HOUSING_STATUS = 'LiB_ADDRESS_HOUSING_STATUS';
    
    public static final String NO_VALUE_AVAILABLE = 'NO_VALUE_AVAILABLE';
    
    public static final String ADDRESS_TYPE_FINANCE = 'FinanceDetails'; //OppApplicationExtension

    public static final String Pepper_RESIDENTIAL_STATUS = 'Pepper_RESIDENTIAL_STATUS';
    public static final String Pepper_INCOME_TYPES = 'Pepper_INCOME_TYPES';
    public static final String Pepper_EMPLOYMENT_TYPE = 'Pepper_EMPLOYMENT_TYPE';
    public static final String Pepper_LIABILITIES_TYPES = 'Pepper_LIABILITIES_TYPES';
    public static final String Pepper_RESIDENCY_STATUS = 'Pepper_RESIDENCY_STATUS';
    

    // Lelo           2021-03-10
    private static Map<String, List<Message_Codes__c>> messagesCodeList = null;

    public static List<Message_Codes__c> getStates (){
        List<Message_Codes__c> messageCodes = getListMessageCodes(STATES);
        return messageCodes;
    }
    
    public static Message_Codes__c getMessageCode(String domain){
        List<Message_Codes__c> messageCodes = getListMessageCodes(domain);
        Message_Codes__c messageCode = (messageCodes != null && messageCodes.size() > 0) ? messageCodes[0] : null;
        return messageCode;
    }
    
    public static List<Message_Codes__c> getListMessageCodes (String domain) {
      loadMessageCodes();
      List<Message_Codes__c> r = messagesCodeList.get(domain);
      if (r == null || r.isEmpty()) {
        System.debug(domain + ': no data found! please check out your settings');
      }
      return r;
        // List<Message_Codes__c> messageCodes = [select name, code__c, description__c, domain__c from message_codes__c where domain__c = :domain];
        // return messageCodes;
    }
    
    public static Message_Codes__c getMessageCode_Description(String description){
        List<Message_Codes__c> messageCodes = getListMessageCodes_Description (description);
        Message_Codes__c messageCode = (messageCodes != null && messageCodes.size() > 0) ? messageCodes[0] : null;
        return messageCode;
    }
    
    public static List<Message_Codes__c> getListMessageCodes_Description (String description) {
        List<Message_Codes__c> messageCodes = [select name, code__c, description__c, domain__c from message_codes__c where description__c = :description];
        return messageCodes;
    }
    
    public static String salesforceValueToMessageCode_Code (String vSalesforce, String messageCodes){
        for (Message_Codes__c mCode : getListMessageCodes(messageCodes)){
            // System.debug('comparing ['+ mCode.description__c +'] vs [' + vSalesforce + ']');
            if (mCode.description__c.equals(vSalesforce)){
                return mCode.code__c;
            }
        }
        System.debug('@@@@@@@ >>>>_cod Value Salesforce ' + vSalesforce + '  >>>Code: ' + messageCodes);
        return NO_VALUE_AVAILABLE +' ['+ messageCodes + ':' + vSalesforce +']';
    }
    
    public static String salesforceValueToMessageCode_Description (String vSalesforce, String messageCodes){
        for (Message_Codes__c mCode : getListMessageCodes(messageCodes)){
            if (mCode.code__c.equals(vSalesforce)){
                return mCode.description__c;
            }
        }
        System.debug('@@@@@@@_descp >>>> Value Salesforce ' + vSalesforce + '  >>>Code: ' + messageCodes);
        return NO_VALUE_AVAILABLE + ' ['+ messageCodes + ':' + vSalesforce +']';
    }
    
    public static String getEncrypt (String value, String prefix){
        return CryptoUtils.encrypt(value + prefix);
    }
    
    public static List<SelectOption> getUsersConsultantsActiveOptions(){
        //List<User> users = [select id, name from User where isactive = true and profile.name like '%Sales Consultant%'];
        List<User> users = [select id, name from User];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        for (User u : users){
            options.add(new SelectOption(u.id, u.name));
        }
        return options;
    }
    
    public static Decimal getMonthlyValue (String frequency, Decimal value, Integer scaleDecimal ){
        if (value == null){
            value = 0;
        }
        Decimal monthlyValue = value;
        if('Weekly'.equalsIgnoreCase(frequency)){
            monthlyValue = (monthlyValue * 52) / 12;
        }else if ('Fortnightly'.equalsIgnoreCase(frequency)){
			monthlyValue = (monthlyValue * 26) / 12;            
        }else if ('Yearly'.equalsIgnoreCase(frequency)){
            monthlyValue = monthlyValue / 12;
        }
        return NumberUtils.convertDecimalToScale(monthlyValue, scaleDecimal);
    }
    
    public static String validateFrequency (String frequency){
        String f = StringUtils.validateNull(frequency);
        if('Weekly'.equalsIgnoreCase(f)){
            return f;
        }else if ('Fortnightly'.equalsIgnoreCase(f)){
			return f;          
        }else if ('Yearly'.equalsIgnoreCase(f)){
            return f;
        }else if ('Monthly'.equalsIgnoreCase(f)){
            return f;
        }
        return 'Monthly';
    }

    public static Integer getVehicleAgeYears(Application_Asset_Detail__c aad, Custom_Opportunity__c opp){
        Integer differenceYear = getVehicleYear(aad, opp);
        if(differenceYear == null){
            return null;
        }
        differenceYear = Date.Today().year() - differenceYear;
        return differenceYear;
    }

    public static Integer getVehicleYear(Application_Asset_Detail__c aad, Custom_Opportunity__c opp){
        Integer differenceYear = null;
        //Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Application_AssetDetail__c);
        if (opp != null) {
          Application__c app  = opp.Application__r;
          String year;
          if(aad != null && aad.Year__c != null){
              year = String.valueOf(aad.Year__c);
          //}else if(app != null && !StringUtils.isNullOrEmpty(app.Vehicle_Year__c)){
          //    year = app.Vehicle_Year__c;
          }

          if (year != null){
              differenceYear = Integer.valueOf(year);
          }
        }
        // System.debug('::::::: Year: ' + year);
        return differenceYear;
    }

    public static String getGUID() {
		Blob blobData = Crypto.GenerateAESKey(128);
        String hexStr = EncodingUtil.ConvertTohex(blobData);
        String retStr = hexStr.SubString(0,8)+ '-' + hexStr.SubString(8,12) + '-' + hexStr.SubString(12,16) + '-' + hexStr.SubString(16,20) + '-' + hexStr.substring(20);
        System.debug('retStr: ' + retStr);
        return retStr;
    }

  /*******************************************************************************************************
  * @author Lelo
  * @description cache for Message codes
  */
  public static void loadMessageCodes() {
    // System.debug('loadMessageCodes...');
    if (messagesCodeList == null) {
      messagesCodeList = new Map<String, List<Message_Codes__c>>();
      List<Message_Codes__c> d = [
        select name, code__c, description__c, domain__c 
        from message_codes__c 
      ];
      for (message_codes__c m : d) {
        List<Message_Codes__c> domains = messagesCodeList.get(m.Domain__c);
        if (domains == null) {
            // System.debug('loading setting ' + m.Domain__c + '...');
          domains = new List<Message_Codes__c>();
          messagesCodeList.put(m.Domain__c, domains);
        }
        domains.add(m);
      }
    }
  }
  
  /*******************************************************************************************************
  * @author Lelo
  * @description extract all fields from an sobject
  */
  public static Set<String> getCustomFields(String apiName) {
    SObjectType objType = ((SObject) (Type.forName('Schema.' + apiName).newInstance())).getSObjectType();
    Map<String, SObjectField> fieldsByName = objType.getDescribe().fields.getMap();
    Set<String> r = new Set<String>();

    for (SObjectField field : fieldsByName.values()) {
        if (field.getDescribe().isCustom()) {
            r.add(field.getDescribe().getName());
        }
    }

    System.debug('customFields => ' + r);

    return r;
  }

}