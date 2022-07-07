public abstract class APIServiceManager {
  public static final String API_LENDER_PEPPER = 'Pepper';
  public static final String API_LENDER_FINANCEONE = 'FinanceOne';
  public static final String API_LENDER_MONEY3 = 'Money3';
  public static final String API_LENDER_LATITUDE = 'Latitude';
  public static final String API_LENDER_PLENTI = 'Plenti';
  public static final String API_INSURER_ERIC = 'Eric';
  public static final String API_PROVIDER_EQUIFAX = 'Equifax';

  public Boolean isError { get; set; }
  public String message { get; set; }
  public Integer responseStatus { get; set; }
  public String responseMessage { get; set; }
  public String reqBody { get; set; }

  private Map<String, Map<String, List<Application_Employment__c>>> employmentList;
  private static Map<String, Partner_API_Setting__c> apiSetting = null;

  public Map<ApexPages.Severity, Set<String>> messages { get; set; }

  public APIServiceManager() {
    System.debug('APIServiceManager...');
    this.clean();
  }

  public void clean() {
    this.isError = false;
    this.message = '';
    this.messages = new Map<ApexPages.Severity, Set<String>>();
  }

  public static Partner_API_Setting__c getPartnerAPISetting(String name) {
    loadAPISettings();
    Partner_API_Setting__c r = null;
    String lender = null;
    if (String.isNotBlank(name)) {
      if (name.startsWith(API_LENDER_PEPPER)) {
        lender = API_LENDER_PEPPER;
      } else if (name.startsWith(API_LENDER_MONEY3)) {
        lender = API_LENDER_MONEY3;
      } else if (name.startsWith(API_LENDER_PLENTI)) {
        lender = API_LENDER_PLENTI;
      } else if (name.startsWith(API_INSURER_ERIC)) {
        lender = API_INSURER_ERIC;
      } else if (name.startsWith(API_LENDER_FINANCEONE)) {
        lender = API_LENDER_FINANCEONE;
      } else if (name.startsWith(API_PROVIDER_EQUIFAX)) {
        lender = API_PROVIDER_EQUIFAX;
      } else if (name.startsWith(API_LENDER_LATITUDE)) {
        lender = API_LENDER_LATITUDE;
      }
      if (String.isBlank(lender)) {
        throw new GenericException(
          'Settings not found for [' +
          name +
          '], please set them in API Settings page'
        );
      }
      r = apiSetting.get(lender);
    }
    if (r == null) {
      throw new GenericException(
        'Settings not found for [' +
        lender +
        ' API integration], please set them in API Settings page'
      );
    }
    return r;
  }

  public static String getParameterService(String name) {
    String p = null;
    if (
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      !SOQLSingletonQueries.recs().isFranchised
    ) {
      Partner_API_Setting__c s = getPartnerAPISetting(name);
      if (s != null) {
        String v = null;
        if (name.contains('Client_ID')) {
          v = s.Client_ID__c;
        } else if (name.contains('Client_Secret')) {
          v = s.Client_Secret__c;
        } else if (name.contains('Token')) {
          v = s.Token__c;
        } else if (
          name.contains('PartnerId') ||
          name.contains('Merchant_ID') ||
          name.contains('Broker_ID')
        ) {
          v = s.Partner_ID__c;
        } else if (name.contains('Default_Limit')) {
          v = String.valueOf(s.Limit__c.intValue());
        } else if (name.contains('Username')) {
          v = s.Username__c;
        } else if (name.contains('Password')) {
          v = s.Password__c;
        } else {
          v = Parameters_Service__c.getValues(name).value__c;
        }
        p = v;
      }
    } else {
      p = Parameters_Service__c.getValues(name).value__c;
    }
    return p;
  }

  private static void loadAPISettings() {
    if (apiSetting == null) {
      apiSetting = new Map<String, Partner_API_Setting__c>();
      Contact c = SOQLSingletonQueries.recs().myContact;
      if (c != null) {
        // System.debug('contact => ' + JSON.serializePretty(c));
        List<Partner_API_Setting__c> d = [
          SELECT
            Client_ID__c,
            Client_Secret__c,
            Provider__c,
            Token__c,
            Partner_ID__c,
            Username__c,
            Password__c,
            Partner_Name__c,
            User_ID__c,
            Limit__c
          FROM Partner_API_Setting__c
          WHERE Account__c = :c.AccountId
          ORDER BY LastModifiedDate DESC
        ];
        for (Partner_API_Setting__c a : d) {
          if (!apiSetting.containsKey(a.Provider__c)) {
            apiSetting.put(a.Provider__c, a);
          }
        }
      }
    }
  }

  public static String getLenderComments(Id appId) {
    List<Application_Extra_Data__c> r = null;
    if (appId != null) {
      r = [
        SELECT Data__c, LastModifiedDate
        FROM Application_Extra_Data__c
        WHERE
          Application__c = :appId
          AND Type_of_Data__c = 'Notes'
          AND Category__c = 'Lender'
        ORDER BY LastModifiedDate DESC
      ];
    }
    if (r != null && !r.isEmpty()) {
      return r.get(0).Data__c;
    } else {
      return null;
    }
  }

  public static Custom_Opportunity__c getCustomOpportunityForApplication(
    Custom_Opportunity__c opp
  ) {
    List<Custom_Opportunity__c> r = null;
    if (opp != null) {
      r = [
        SELECT
          o.Application__c,
          o.Application__r.Accountant_Name__c,
          o.Application__r.Accountant_Phone__c,
          o.Application__r.Actual_Nationality_1__c,
          o.Application__r.Ages_of_Dependants_1__c,
          o.Application__r.Applicant_2_living_in_the_same_address__c,
          o.Application__r.Application_Type__c,
          o.Application__r.Ages_of_Dependants_2__c,
          o.Application__r.Actual_Nationality_2__c,
          o.Application__r.Bank_Name__c,
          o.Application__r.Bank_Value__c,
          o.Application__r.Basic_Living_Expenses_Per_Month__c,
          o.Application__r.Board_per_Month_1__c,
          o.Application__r.Business_ABN__c,
          o.Application__r.Business_ACN__c,
          o.Application__r.Business_Structure__c,
          o.Application__r.Childcare_Child_Maintenance_Per_Month__c,
          o.Application__r.Current_Employer_Name_1__c,
          o.Application__r.Current_Employer_Name_2__c,
          o.Application__r.Current_Employer_Phone_1__c,
          o.Application__r.Current_Employer_Phone_2__c,
          o.Application__r.Current_Occupation_1__c,
          o.Application__r.Current_Occupation_2__c,
          o.Application__r.Current_Residence_Status_1__c,
          o.Application__r.Current_Residence_Status_2__c,
          o.Application__r.Current_Residential_Status_1__c,
          o.Application__r.Current_Residential_Status_2__c,
          o.Application__r.Current_Work_Address_1__c,
          o.Application__r.Current_Work_Address_2__c,
          o.Application__r.Current_Work_Postcode_1__c,
          o.Application__r.Current_Work_Postcode_2__c,
          o.Application__r.Current_Work_State_1__c,
          o.Application__r.Current_Work_State_2__c,
          o.Application__r.Current_Work_Street_Number_1__c,
          o.Application__r.Current_Work_Street_Number_2__c,
          o.Application__r.Current_Work_Street_Type_1__c,
          o.Application__r.Current_Work_Street_Type_2__c,
          o.Application__r.Current_Work_Suburb_1__c,
          o.Application__r.Current_Work_Suburb_2__c,
          o.Application__r.Current_Work_Unit_Number_1__c,
          o.Application__r.Current_Work_Unit_Number_2__c,
          o.Application__r.Date_From_1__c,
          o.Application__r.Date_From_1b__c,
          o.Application__r.Date_From_1c__c,
          o.Application__r.Date_From_1d__c,
          o.Application__r.Date_From_1e__c,
          o.Application__r.Date_From_2__c,
          o.Application__r.Date_From_2b__c,
          o.Application__r.Date_From_2c__c,
          o.Application__r.Date_From_2d__c,
          o.Application__r.Date_From_2e__c,
          o.Application__r.Date_Moved_in_1__c,
          o.Application__r.Date_Moved_in_2__c,
          o.Application__r.Date_of_Birth_1__c,
          o.Application__r.Date_of_Birth_2__c,
          o.Application__r.Date_Started_1__c,
          o.Application__r.Date_Started_2__c,
          o.Application__r.Driver_Licence_State_Issue_1__c,
          o.Application__r.Driver_Licence_State_Issue_2__c,
          o.Application__r.Drivers_License_1__c,
          o.Application__r.Drivers_License_2__c,
          o.Application__r.Email_Address__c,
          o.Application__r.Email_Address_2__c,
          o.Application__r.Employer_ABN_1__c,
          o.Application__r.Entity_Name__c,
          o.Application__r.Expiry_Date_1__c,
          o.Application__r.Expiry_Date_2__c,
          o.Application__r.Finish_Date_1__c,
          o.Application__r.Finish_Date_2__c,
          o.Application__r.First_Name__c,
          o.Application__r.First_Name_2__c,
          o.Application__r.Furniture_Value__c,
          o.Application__r.Gender_1__c,
          o.Application__r.Gender_2__c,
          o.Application__r.Home_Phone__c,
          o.Application__r.Home_Phone_2__c,
          o.Application__r.Insurance_Expenses_per_Month__c,
          o.Application__r.Landlord_Name_1__c,
          o.Application__r.Landlord_Name_2__c,
          o.Application__r.Landlord_Phone_1__c,
          o.Application__r.Landlord_Phone_2__c,
          o.Application__r.Last_Name__c,
          o.Application__r.Last_Name_2__c,
          o.Application__r.Marital_Status_1__c,
          o.Application__r.Marital_Status_2__c,
          o.Application__r.Middle_Name__c,
          o.Application__r.Middle_Name_2__c,
          o.Application__r.Mobile_Number__c,
          o.Application__r.Mobile_Number_2__c,
          o.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c,
          o.Application__r.Mode_of_Employment_1__c,
          o.Application__r.Mode_of_Employment_2__c,
          o.Application__r.Nature_of_Business__c,
          o.Application__r.No_of_Dependants_1__c,
          o.Application__r.No_of_Dependants_2__c,
          o.Application__r.No_of_People__c,
          o.Application__r.Other_Expenses_per_Month__c,
          o.Application__r.Payment_Frequency_1__c,
          o.Application__r.Payment_Frequency_2__c,
          o.Application__r.Net_Income_1__c,
          o.Application__r.Net_Income_2__c,
          o.Application__r.Personal_Reference_1_Address__c,
          o.Application__r.Personal_Reference_1_Full_Name__c,
          o.Application__r.Personal_Reference_1_Phone__c,
          o.Application__r.Personal_Reference_1_Relationship__c,
          o.Application__r.Personal_Reference_2_Address__c,
          o.Application__r.Personal_Reference_2_Full_Name__c,
          o.Application__r.Personal_Reference_2_Phone__c,
          o.Application__r.Personal_Reference_2_Relationship__c,
          o.Application__r.Postcode__c,
          o.Application__r.Postcode_2__c,
          o.Application__r.Previous_Country_1__c,
          o.Application__r.Previous_Country_1b__c,
          o.Application__r.Previous_Country_1c__c,
          o.Application__r.Previous_Country_1d__c,
          o.Application__r.Previous_Country_1e__c,
          o.Application__r.Previous_Country_2__c,
          o.Application__r.Previous_Country_2b__c,
          o.Application__r.Previous_Country_2c__c,
          o.Application__r.Previous_Country_2d__c,
          o.Application__r.Previous_Country_2e__c,
          o.Application__r.Previous_Employer_Name_1__c,
          o.Application__r.Previous_Employer_Name_2__c,
          o.Application__r.Previous_Employer_Phone_1__c,
          o.Application__r.Previous_Employer_Phone_2__c,
          o.Application__r.Previous_Mode_of_Employment_1__c,
          o.Application__r.Previous_Mode_of_Employment_2__c,
          o.Application__r.Previous_Occupation_1__c,
          o.Application__r.Previous_Occupation_2__c,
          o.Application__r.Previous_Postcode_1__c,
          o.Application__r.Previous_Postcode_1b__c,
          o.Application__r.Previous_Postcode_1c__c,
          o.Application__r.Previous_Postcode_1d__c,
          o.Application__r.Previous_Postcode_1e__c,
          o.Application__r.Previous_Postcode_2__c,
          o.Application__r.Previous_Postcode_2b__c,
          o.Application__r.Previous_Postcode_2c__c,
          o.Application__r.Previous_Postcode_2d__c,
          o.Application__r.Previous_Postcode_2e__c,
          o.Application__r.Previous_Reference_Name_1__c,
          o.Application__r.Previous_Reference_Name_2__c,
          o.Application__r.Previous_Residence_Status_1__c,
          o.Application__r.Previous_Residence_Status_1b__c,
          o.Application__r.Previous_Residence_Status_1c__c,
          o.Application__r.Previous_Residence_Status_1d__c,
          o.Application__r.Previous_Residence_Status_1e__c,
          o.Application__r.Previous_Residence_Status_2__c,
          o.Application__r.Previous_Residence_Status_2b__c,
          o.Application__r.Previous_Residence_Status_2c__c,
          o.Application__r.Previous_Residence_Status_2d__c,
          o.Application__r.Previous_Residence_Status_2e__c,
          o.Application__r.Previous_State_1__c,
          o.Application__r.Previous_State_1b__c,
          o.Application__r.Previous_State_1c__c,
          o.Application__r.Previous_State_1d__c,
          o.Application__r.Previous_State_1e__c,
          o.Application__r.Previous_State_2__c,
          o.Application__r.Previous_State_2b__c,
          o.Application__r.Previous_State_2c__c,
          o.Application__r.Previous_State_2d__c,
          o.Application__r.Previous_State_2e__c,
          o.Application__r.Previous_Street_Address_1__c,
          o.Application__r.Previous_Street_Address_1b__c,
          o.Application__r.Previous_Street_Address_1c__c,
          o.Application__r.Previous_Street_Address_1d__c,
          o.Application__r.Previous_Street_Address_1e__c,
          o.Application__r.Previous_Street_Address_2__c,
          o.Application__r.Previous_Street_Address_2b__c,
          o.Application__r.Previous_Street_Address_2c__c,
          o.Application__r.Previous_Street_Address_2d__c,
          o.Application__r.Previous_Street_Address_2e__c,
          o.Application__r.Previous_Street_Number_1__c,
          o.Application__r.Previous_Street_Number_1b__c,
          o.Application__r.Previous_Street_Number_1c__c,
          o.Application__r.Previous_Street_Number_1d__c,
          o.Application__r.Previous_Street_Number_1e__c,
          o.Application__r.Previous_Street_Number_2__c,
          o.Application__r.Previous_Street_Number_2b__c,
          o.Application__r.Previous_Street_Number_2c__c,
          o.Application__r.Previous_Street_Number_2d__c,
          o.Application__r.Previous_Street_Number_2e__c,
          o.Application__r.Previous_Street_Type_1__c,
          o.Application__r.Previous_Street_Type_1b__c,
          o.Application__r.Previous_Street_Type_1c__c,
          o.Application__r.Previous_Street_Type_1d__c,
          o.Application__r.Previous_Street_Type_1e__c,
          o.Application__r.Previous_Street_Type_2__c,
          o.Application__r.Previous_Street_Type_2b__c,
          o.Application__r.Previous_Street_Type_2c__c,
          o.Application__r.Previous_Street_Type_2d__c,
          o.Application__r.Previous_Street_Type_2e__c,
          o.Application__r.Previous_Suburb_1__c,
          o.Application__r.Previous_Suburb_1b__c,
          o.Application__r.Previous_Suburb_1c__c,
          o.Application__r.Previous_Suburb_1d__c,
          o.Application__r.Previous_Suburb_1e__c,
          o.Application__r.Previous_Suburb_2__c,
          o.Application__r.Previous_Suburb_2b__c,
          o.Application__r.Previous_Suburb_2c__c,
          o.Application__r.Previous_Suburb_2d__c,
          o.Application__r.Previous_Suburb_2e__c,
          o.Application__r.Previous_Unit_Number_1__c,
          o.Application__r.Previous_Unit_Number_1b__c,
          o.Application__r.Previous_Unit_Number_1c__c,
          o.Application__r.Previous_Unit_Number_1d__c,
          o.Application__r.Previous_Unit_Number_1e__c,
          o.Application__r.Previous_Unit_Number_2__c,
          o.Application__r.Previous_Unit_Number_2b__c,
          o.Application__r.Previous_Unit_Number_2c__c,
          o.Application__r.Previous_Unit_Number_2d__c,
          o.Application__r.Previous_Unit_Number_2e__c,
          o.Application__r.Previous_Work_Address_1__c,
          o.Application__r.Previous_Work_Address_2__c,
          o.Application__r.Previous_Work_Postcode_1__c,
          o.Application__r.Previous_Work_Postcode_2__c,
          o.Application__r.Previous_Work_State_1__c,
          o.Application__r.Previous_Work_State_2__c,
          o.Application__r.Previous_Work_Street_Number_1__c,
          o.Application__r.Previous_Work_Street_Number_2__c,
          o.Application__r.Previous_Work_Street_Type_1__c,
          o.Application__r.Previous_Work_Street_Type_2__c,
          o.Application__r.Previous_Work_Suburb_1__c,
          o.Application__r.Previous_Work_Suburb_2__c,
          o.Application__r.Previous_Work_Unit_Number_1__c,
          o.Application__r.Previous_Work_Unit_Number_2__c,
          o.Application__r.Previous_Work_Country_1__c,
          o.Application__r.Previous_Work_Country_2__c,
          o.Application__r.Reference_Name_1__c,
          o.Application__r.Reference_Name_2__c,
          o.Application__r.Rent_per_month_1__c,
          o.Application__r.Residential_Payment_Frequency_1__c,
          o.Application__r.Start_Date_1__c,
          o.Application__r.Start_Date_2__c,
          o.Application__r.State__c,
          o.Application__r.State_2__c,
          o.Application__r.Street_Address__c,
          o.Application__r.Street_Address_2__c,
          o.Application__r.Street_Number__c,
          o.Application__r.Street_Number_2__c,
          o.Application__r.Street_Type__c,
          o.Application__r.Street_Type_2__c,
          o.Application__r.Suburb__c,
          o.Application__r.Suburb_2__c,
          o.Application__r.Super_Value_How_Much__c,
          o.Application__r.Title_1__c,
          o.Application__r.Title_2__c, //o.Application__r.Total_Credit_Monthly_Payment__c, o.Application__r.Total_Other_Income_1__c,o.Application__r.Total_Other_Income_2__c,
          o.Application__r.Trading_Address__c,
          o.Application__r.Trading_Name__c,
          o.Application__r.Travel_Transport_Expenses_per_Month__c,
          o.Application__r.Type_of_Asset__c,
          o.Application__r.Type_of_Licence_1__c,
          o.Application__r.Type_of_Licence_2__c,
          o.Application__r.Income_Type_Expenses__c,
          o.Application__r.Unit_Number__c,
          o.Application__r.Unit_Number_2__c,
          o.Application__r.Work_Phone__c,
          o.Application__r.Work_Phone_2__c,
          o.Application_AssetDetail__r.Rego_State__c,
          o.Application_AssetDetail__r.Actual_KM__c,
          o.Application_AssetDetail__r.Colour__c,
          o.Application_AssetDetail__r.Engine_No__c,
          o.Application_AssetDetail__r.Make__c,
          o.Application_AssetDetail__r.Model__c,
          o.Application_AssetDetail__r.Rego__c,
          o.Application_AssetDetail__r.RRP__c,
          o.Application_AssetDetail__r.Type__c,
          o.Application_AssetDetail__r.Lender__c,
          o.Application_AssetDetail__r.Condition__c,
          o.Application_AssetDetail__r.Redbook_key__c,
          o.Application_AssetDetail__r.Factory_Options__c,
          o.Application_AssetDetail__r.Variant__c,
          o.Application_AssetDetail__r.VIN__c,
          o.Application_AssetDetail__r.Year__c,
          o.ApplicationServicing__r.Income_1__c,
          o.ApplicationServicing__r.Income_2__c,
          o.ApplicationServicing__r.Is_Splitting_Expenses__c,
          o.ApplicationServicing__r.Net_Partner_Income__c,
          o.ApplicationServicing__r.Total_Liabilities__c,
          o.ApplicationServicing__r.Total_Living_Expenses_Full__c,
          o.ApplicationServicing__r.Total_Net_Monthly_Income__c,
          o.ApplicationServicing__r.Total_Rent_Mortgage_Full__c,
          o.ApplicationYTD__r.Income_1_2__c,
          o.ApplicationYTD__r.Income_2_2__c,
          o.ApplicationYTD__r.Income_Monthly_1_1__c,
          o.ApplicationYTD__r.Income_Monthly_1_2__c,
          o.ApplicationYTD__r.Income_Monthly_2_1__c,
          o.ApplicationYTD__r.Income_Monthly_2_2__c,
          o.ApplicationYTD__r.Monthly_Amount_Servicing_1__c,
          o.Contract_Number__c,
          o.Dealer_Address__c,
          o.Dealer_Contact_Name__c,
          o.Dealer_Name__c,
          o.Dealer_Phone_Number__c,
          o.Dealer_Postcode__c,
          o.Dealer_State__c,
          o.Dealer_Street_Number__c,
          o.Dealer_Street_Type__c,
          o.Dealer_Suburb__c,
          o.Dealer_Unit_Number__c,
          o.New_Used__c,
          o.Purchase_Type__c,
          o.Owner_Email__c,
          o.Application__r.Previous_Street_Address_2nd_1__c,
          o.Application__r.Previous_Overseas_City_1__c,
          o.Application__r.Previous_Overseas_State_1__c,
          o.Application__r.Previous_Street_Address_2nd_1b__c,
          o.Application__r.Previous_Overseas_City_1b__c,
          o.Application__r.Previous_Overseas_State_1b__c,
          o.Application__r.Previous_Street_Address_2nd_1c__c,
          o.Application__r.Previous_Overseas_City_1c__c,
          o.Application__r.Previous_Overseas_State_1c__c,
          o.Application__r.Previous_Street_Address_2nd_1d__c,
          o.Application__r.Previous_Overseas_City_1d__c,
          o.Application__r.Previous_Overseas_State_1d__c,
          o.Application__r.Previous_Street_Address_2nd_1e__c,
          o.Application__r.Previous_Overseas_City_1e__c,
          o.Application__r.Previous_Overseas_State_1e__c,
          o.Application__r.Previous_Street_Address_2nd_2__c,
          o.Application__r.Previous_Overseas_City_2__c,
          o.Application__r.Previous_Overseas_State_2__c,
          o.Application__r.Previous_Street_Address_2nd_2b__c,
          o.Application__r.Previous_Overseas_City_2b__c,
          o.Application__r.Previous_Overseas_State_2b__c,
          o.Application__r.Previous_Street_Address_2nd_2c__c,
          o.Application__r.Previous_Overseas_City_2c__c,
          o.Application__r.Previous_Overseas_State_2c__c,
          o.Application__r.Previous_Street_Address_2nd_2d__c,
          o.Application__r.Previous_Overseas_City_2d__c,
          o.Application__r.Previous_Overseas_State_2d__c,
          o.Application__r.Previous_Street_Address_2nd_2e__c,
          o.Application__r.Previous_Overseas_City_2e__c,
          o.Application__r.Previous_Overseas_State_2e__c,
          o.Application__r.Do_you_have_drivers_licence_1__c,
          o.Application__r.Do_you_have_drivers_licence_2__c,
          o.ApplicationServicing__r.Is_Split_Living_Expenses__c,
          o.ApplicationServicing__r.Is_Split_Rent_Mortgage__c,
          o.Application__r.Residential_Payment_Frequency_2__c,
          o.Application__r.Rent_per_month_2__c,
          o.Application__r.Previous_Work_Overseas_State_1__c,
          o.Application__r.Previous_Work_Address_2nd_1__c,
          o.Application__r.Previous_Work_Overseas_City_1__c,
          o.Application__r.Previous_Work_Overseas_State_2__c,
          o.Application__r.Previous_Work_Address_2nd_2__c,
          o.Application__r.Previous_Work_Overseas_City_2__c,
          o.ApplicationServicing__r.Gross_Annual_Income_1__c,
          o.ApplicationServicing__r.Gross_Annual_Income_1_Second_Job__c,
          o.ApplicationServicing__r.Gross_Annual_Income_2__c,
          o.ApplicationServicing__r.Gross_Annual_Income_2_Second_Job__c,
          o.Application__r.Trust_Name__c,
          o.Application__r.No_of_Directors__c,
          o.Application__r.Nature_of_Business_2__c,
          o.Application__r.Business_ABN_2__c,
          o.Application__r.Business_Structure_2__c
        FROM Custom_Opportunity__c o
        WHERE id = :opp.Id
      ];
    }
    if (r != null && !r.isEmpty()) {
      return r.get(0);
    } else {
      return null;
    }
  }

  public static Map<String, List<Application_Employment__c>> loadPreviousEmployments(
    Custom_Opportunity__c opp
  ) {
    //Load Previous Employments
    Map<String, List<Application_Employment__c>> prevEmplMap = new Map<String, List<Application_Employment__c>>();
    if (opp.Application__c != null) {
      List<Application_Employment__c> lst = [
        SELECT
          Name,
          Applicant__c,
          Application__c,
          Contact_Name__c,
          Country__c,
          Employer_Name__c,
          Employment_Type__c,
          Finish_Date__c,
          Occupation__c,
          Start_Date__c,
          Work_Address__c,
          Phone__c,
          Income__c,
          Frequency__c,
          Unit_Number__c,
          Street_Number__c,
          Street_Type__c,
          Suburb__c,
          Postcode__c,
          State__c,
          Address_Line_1__c,
          Overseas_State__c,
          Overseas_City__c,
          Address_Line_2__c,
          Address_Type__c,
          Type__c
        FROM Application_Employment__c
        WHERE
          Application__c = :opp.Application__c
          AND Address_Type__c < :Utilities.ADDRESS_TYPE_FINANCE
      ];
      for (Application_Employment__c e : lst) {
        List<Application_Employment__c> empList = prevEmplMap.get(
          e.Applicant__c
        );
        if (empList == null) {
          empList = new List<Application_Employment__c>();
          prevEmplMap.put(e.Applicant__c, empList);
        }
        empList.add(e);
      }
    }
    return prevEmplMap;
  }

  public static Application_Employment__c loadAddressFinanceDetails(
    Custom_Opportunity__c opp
  ) {
    Application_Employment__c addressFinanceDetail = null;
    if (opp.Application__c != null) {
      //Load Address for FinanceDetails section
      List<Application_Employment__c> addressFinance = [
        SELECT
          Name,
          Applicant__c,
          Application__c,
          Contact_Name__c,
          Country__c,
          Employer_Name__c,
          Employment_Type__c,
          Finish_Date__c,
          Occupation__c,
          Start_Date__c,
          Work_Address__c,
          Phone__c,
          Unit_Number__c,
          Street_Number__c,
          Street_Type__c,
          Suburb__c,
          Postcode__c,
          State__c,
          Address_Line_1__c,
          Overseas_State__c,
          Overseas_City__c,
          Address_Line_2__c,
          Address_Type__c
        FROM Application_Employment__c
        WHERE
          Application__c = :opp.Application__c
          AND Address_Type__c = :Utilities.ADDRESS_TYPE_FINANCE
        LIMIT 1
      ];
      if (addressFinance != null && !addressFinance.isEmpty()) {
        addressFinanceDetail = addressFinance[0];
      } else {
        addressFinanceDetail = new Application_Employment__c();
        addressFinanceDetail.Address_Type__c = Utilities.ADDRESS_TYPE_FINANCE;
      }
    }
    return addressFinanceDetail;
  }

  private void loadApplicationEmployments(Id appId) {
    // if (this.employmentList == null && appId != null) {
    this.employmentList = new Map<String, Map<String, List<Application_Employment__c>>>();
    List<Application_Employment__c> lst = [
      SELECT
        Name,
        Applicant__c,
        Application__c,
        Contact_Name__c,
        Country__c,
        Employer_Name__c,
        Employment_Type__c,
        Finish_Date__c,
        Occupation__c,
        Start_Date__c,
        Work_Address__c,
        Phone__c,
        Unit_Number__c,
        Street_Number__c,
        Street_Type__c,
        Suburb__c,
        Postcode__c,
        State__c,
        Address_Line_1__c,
        Overseas_State__c,
        Overseas_City__c,
        Address_Line_2__c,
        Address_Type__c,
        Employer_ABN_1__c,
        Employment_Months__c,
        Employment_Years__c,
        Frequency__c,
        Income__c,
        Monthly_Income__c,
        Type__c
      FROM Application_Employment__c
      WHERE Application__c = :appId
    ];
    for (Application_Employment__c e : lst) {
      String empType = e.Type__c;
      if (String.isBlank(empType)) {
        empType = 'Previous Job';
      }
      Map<String, List<Application_Employment__c>> typeList = this.employmentList.get(
        empType
      );
      if (typeList == null) {
        typeList = new Map<String, List<Application_Employment__c>>();
        this.employmentList.put(empType, typeList);
      }
      List<Application_Employment__c> empList = typeList.get(e.Applicant__c);
      if (empList == null) {
        empList = new List<Application_Employment__c>();
        typeList.put(e.Applicant__c, empList);
      }
      empList.add(e);
    }
    // }
    System.debug(this.employmentList.keySet());
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description get a list of employments for an applicant
   * @param appId application identifier
   * @param applicant number 1 or 2
   * @return list of employment, never return null
   */
  public List<Application_Employment__c> getApplicantEmployments(
    Id appId,
    String applicant
  ) {
    loadApplicationEmployments(appId);
    List<Application_Employment__c> r = new List<Application_Employment__c>();
    if (this.employmentList != null) {
      Map<String, List<Application_Employment__c>> tmp = this.employmentList.get(
        'Previous Job'
      );
      if (tmp != null && tmp.containsKey(applicant)) {
        r = tmp.get(applicant);
      }
    }
    return r;
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description get the second job for an applicant if there is one, otherwise null will be returned
   * @param appId application identifier
   * @param applicant number 1 or 2
   * @return Second job objet if there is one, or null
   */
  public Application_Employment__c getApplicantSecondJob(
    Id appId,
    String applicant
  ) {
    loadApplicationEmployments(appId);
    Application_Employment__c r = null;
    if (this.employmentList != null) {
      Map<String, List<Application_Employment__c>> tmp = this.employmentList.get(
        'Second Job'
      );
      if (tmp != null && tmp.containsKey(applicant)) {
        List<Application_Employment__c> empList = tmp.get(applicant);
        if (!empList.isEmpty()) {
          r = empList.get(0);
        }
      }
    }
    return r;
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description get a list of incomes organized by applicant
   * @param appId application identifier
   * @return list of incomes
   */
  public Map<String, List<Application_Income__c>> getAppIncomes(Id appId) {
    return ApplicationService.getApplicationIncomeMap(appId);
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description list the application loans
   * @param appId application identifier
   * @return list of loans
   */
  public List<Application_Loan__c> getAppLoans(Id appId) {
    return ApplicationService.getApplicationLoans(appId);
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description list the application loans
   * @param appId application identifier
   * @return list of loans
   */
  public List<Application_Credit_Card__c> getAppCreditCards(Id appId) {
    return ApplicationService.getApplicationCreditCards(appId);
  }

  /*******************************************************************************************************
   * @author Lelo
   * @description check if there is at least one accepted insurance product into Quoting tools.
   * @param quoting object with all data related with the quote
   * @return true is an insurace is accepted
   */
  public Boolean hasAcceptedInsurances(Application_Quoting__c quoting) {
    Boolean r = false;
    if (quoting != null) {
      if (
        'A'.equals(quoting.Insurance_GAP_Acceptance__c) ||
        'A'.equals(quoting.Insurance_TAI_Acceptance__c) ||
        'A'.equals(quoting.Insurance_LTI_Acceptance__c) ||
        'A'.equals(quoting.Insurance_LPI_Acceptance__c) ||
        'A'.equals(quoting.Insurance_Warranty_Acceptance__c) ||
        'A'.equals(quoting.Insurance_NWC_Acceptance__c)
      ) {
        r = true;
      }
    }
    return r;
  }

  public static List<Lender_Login__c> listLenderLogins(String lender) {
    List<Lender_Login__c> r = new List<Lender_Login__c>();
    if (SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      Id accId = SOQLSingletonQueries.recs().myContact.AccountId;
      System.debug('accId => ' + accId);
      List<Contact> cs = [SELECT Id FROM Contact WHERE AccountId = :accId];
      Set<Id> cIds = new Set<Id>();
      for (Contact c : cs) {
        cIds.add(c.Id);
      }
      r = [
        SELECT Id, User_Name__c, Owner.Name, Consumer_Key__c, Owner.Email
        FROM Lender_Login__c
        WHERE
          Lender__c = :lender
          AND Owner.isActive = TRUE
          AND OwnerId IN (SELECT Id FROM User WHERE ContactId IN :cIds)
        ORDER BY Owner.Name
      ];
    } else {
      List<User> franchiseds = SOQLSingletonQueries.recs().franchisedCounsultantList;
      List<Id> uIds = new List<Id>();
      if (franchiseds != null && !franchiseds.isEmpty()) {
        for (User u: franchiseds) {
          uIds.add(u.Id);
        }
      }
      List<User> activeUsers = [SELECT Id FROM User WHERE isActive = TRUE AND UserType = 'Standard'];
      for (User u: activeUsers) {
        uIds.add(u.Id);
      }
      String sql = 'SELECT Id, User_Name__c, Owner.Name, Consumer_Key__c, Owner.Email ';
      sql += 'FROM Lender_Login__c WHERE Lender__c = :lender AND ';
      if (!uIds.isEmpty()) {
        sql += 'OwnerId in :uIds ';
      }
      sql += 'ORDER BY Owner.Name';
      r = Database.query(sql);
    }
    return r;
  }

  public static User getUserById(Id userId) {
    List<User> d = [
      SELECT ID, Phone, Email, MobilePhone, Name, profileid
      FROM User
      WHERE id = :userId
    ];
    return d.isEmpty() ? null : d.get(0);
  }

  // API return wrapper
  public class APIResponse {
    public LenderAPIResponse__c lenderResponse { get; set; }
    public Map<ApexPages.Severity, Set<String>> messages { get; set; }
    public APIResponse() {
      this.messages = new Map<ApexPages.Severity, Set<String>>();
    }
    public void addMessage(ApexPages.Severity severity, String message) {
      Set<String> mgs = this.messages.get(severity);
      if (mgs == null) {
        mgs = new Set<String>();
      }
      mgs.add(message);
    }
  }

  // Application messages
  public void addMessage(ApexPages.Severity severity, String message) {
    if (Apexpages.currentPage() != null) {
      ApexPages.addMessage(new ApexPages.Message(severity, message));
    } else {
      Set<String> msgs = this.messages.get(severity);
      if (msgs == null) {
        msgs = new Set<String>();
        this.messages.put(severity, msgs);
      }
      msgs.add(message);
    }
  }

  public void addErrorMessage(String message) {
    this.addMessage(ApexPages.Severity.ERROR, message);
  }

  public void addInfoMessage(String message) {
    this.addMessage(ApexPages.Severity.INFO, message);
  }

  public void addWarningMessage(String message) {
    this.addMessage(ApexPages.Severity.WARNING, message);
  }

  public void addConfirmMessage(String message) {
    this.addMessage(ApexPages.Severity.CONFIRM, message);
  }

  public void addFatalMessage(String message) {
    this.addMessage(ApexPages.Severity.FATAL, message);
  }

  public Boolean hasErrorMessages() {
    return this.messages.containsKey(ApexPages.Severity.ERROR);
  }

  public Set<String> getErrorMessages() {
    return this.messages.get(ApexPages.Severity.ERROR);
  }

  public Boolean hasWarningsMessages() {
    return this.messages.containsKey(ApexPages.Severity.WARNING);
  }

  public Set<String> getWarningMessages() {
    return this.messages.get(ApexPages.Severity.WARNING);
  }
}