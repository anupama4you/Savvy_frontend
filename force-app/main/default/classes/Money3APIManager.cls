/**
 * Description : Money3 API Manager class configuration
*/
public class Money3APIManager extends APIServiceManager {

    public static final String MONEY3_SERVICE_TOKEN = 'Money3_Service_Token';
    public static final String MONEY3_SERVICE_ENDPOINT= 'Money3_Service_Endpoint';
    public static final String LENDER_MONEY3 = 'Money3';
    public static final String MONEY3_SERVICE_DOCUMENT_ENDPOINT = 'Money3_Service_Document_Endpoint';
    public static final String MONEY3_SERVICE_BROKER_ID = 'Money3_Service_Broker_ID';

    public Money3APIResponseDTO responseDto {get; set;}


    public Money3APIManager() {
        clean();
    }

    public Money3APIResponseDTO parseCreateApplicationResponse(String jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            responseDto = (Money3APIResponseDTO) parser.readValueAs(Money3APIResponseDTO.class);
            responseDto.lastResponseApplication = DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
        	return responseDto;
        }catch (Exception ex){
            String msg = '@Error parse object *createApplicationResponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new GenericException(msg, ex);
        }  
    }

    public static List<SelectOption> getUserOptionsConnect(){
        List <SelectOption> usersOptions = new List <SelectOption> ();
        usersOptions.add(new SelectOption ('', 'None'));
        
        // List<Lender_Login__c> lendersLogin = [SELECT Id, Name, User_Name__c, Owner.Name, Consumer_Key__c 
        //                                         	FROM Lender_Login__c where Lender__c = :LENDER_MONEY3 
        //                                       	and User_Name__c <> '' ORDER BY Owner.Name];
        
        List<Lender_Login__c> lendersLogin = APIServiceManager.listLenderLogins(LENDER_MONEY3);

        for (Lender_Login__c u : lendersLogin){
            usersOptions.add(new SelectOption(u.User_Name__c,u.User_Name__c + '-' + u.Owner.Name));
        }

        return usersOptions;
    }
    
    public static String getApiUser(Custom_Opportunity__c o){
        String apiUser;
        
        if(o != null){
            List<Lender_Login__c> lendersLogin = APIServiceManager.listLenderLogins(LENDER_MONEY3);
            
            for (Lender_Login__c u : lendersLogin){
                if(u.Owner.Name.equals(o.Owner_Name__c)){
                    apiUser = u.User_Name__c;
                }
            }
        }
        
        return apiUser;
    }

    public static Lender_Login__c getLenderLoginUser(String userName){
        List<Lender_Login__c> lendersLogin = [SELECT Id, Name, User_Name__c, Owner.Name, Consumer_Key__c 
                                                	FROM Lender_Login__c where Lender__c = :LENDER_MONEY3 
                                              	and User_Name__c = :userName];
        if (lendersLogin != null && !lendersLogin.isEmpty()) {
            return lendersLogin.get(0);
        } else {
            return null;
        }
    }

    public static Glass_Variant__c getCarDetails(String variant) {
        List<Glass_Variant__c> variants = [SELECT Id, Name, Average_Kms__c, Engine__c, KM_Category__c, CC__c, Code__c, Model__r.Type_Source__c,
                                    New_Price__c, NVIC__c, Release_Date__c, Retail_Price__c, Style__c, Trade_Low_Price__c,
                                    Trade_Price__c, Transmission__c, Year__c, Make__c, Family__c, Description__c, Series__c,
                                    Cylinders__c, Size__c, Type_Source__c FROM Glass_Variant__c t 
                                    WHERE t.Code__c = :variant
                                   ];
        if (variants != null && !variants.isEmpty()){
            return variants.get(0);
        } else {
            return null;
        }
    }

    public static Boolean isTwoApplicants(Id oppId){
        Custom_Opportunity__c c = [SELECT Id, Application__c, Application__r.No_of_People__c from Custom_Opportunity__c where Id=: oppId];
        if(c!= null && c.Application__c != null && c.Application__r.No_of_People__c == 2){
            return true;
        } else {
            return false;
        }
    }

    public static Custom_Opportunity__c getCustomOpportunityForMoney3Application(Id oppId){
        List<Custom_Opportunity__c> r = null;
        if (oppId != null) {
            r = [Select o.Application__c,o.Application__r.Accountant_Name__c,o.Application__r.Accountant_Phone__c,o.Application__r.Actual_Nationality_1__c,
                        o.Application__r.Ages_of_Dependants_1__c,o.Application__r.Applicant_2_living_in_the_same_address__c,o.Application__r.Application_Type__c,
                        o.Application__r.Ages_of_Dependants_2__c,o.Application__r.Actual_Nationality_2__c,
                        o.Application__r.Bank_Name__c,o.Application__r.Bank_Value__c,o.Application__r.Basic_Living_Expenses_Per_Month__c,o.Application__r.Board_per_Month_1__c,
                        o.Application__r.Business_ABN__c,o.Application__r.Business_ACN__c,o.Application__r.Business_Structure__c,o.Application__r.Childcare_Child_Maintenance_Per_Month__c,
                        o.Application__r.Current_Employer_Name_1__c,o.Application__r.Current_Employer_Name_2__c,
                        o.Application__r.Current_Employer_Phone_1__c,o.Application__r.Current_Employer_Phone_2__c,
                        o.Application__r.Current_Occupation_1__c,o.Application__r.Current_Occupation_2__c,
                        o.Application__r.Current_Residence_Status_1__c,o.Application__r.Current_Residence_Status_2__c,
                        o.Application__r.Current_Residential_Status_1__c,o.Application__r.Current_Residential_Status_2__c,
                        o.Application__r.Current_Work_Address_1__c,o.Application__r.Current_Work_Address_2__c,
                        o.Application__r.Current_Work_Postcode_1__c,o.Application__r.Current_Work_Postcode_2__c,
                        o.Application__r.Current_Work_State_1__c,o.Application__r.Current_Work_State_2__c,
                        o.Application__r.Current_Work_Street_Number_1__c,o.Application__r.Current_Work_Street_Number_2__c,
                        o.Application__r.Current_Work_Street_Type_1__c,o.Application__r.Current_Work_Street_Type_2__c,
                        o.Application__r.Current_Work_Suburb_1__c,o.Application__r.Current_Work_Suburb_2__c,
                        o.Application__r.Current_Work_Unit_Number_1__c,o.Application__r.Current_Work_Unit_Number_2__c,
                        o.Application__r.Date_From_1__c,o.Application__r.Date_From_1b__c,o.Application__r.Date_From_1c__c,o.Application__r.Date_From_1d__c,o.Application__r.Date_From_1e__c,
                        o.Application__r.Date_From_2__c,o.Application__r.Date_From_2b__c,o.Application__r.Date_From_2c__c,o.Application__r.Date_From_2d__c,o.Application__r.Date_From_2e__c,
                        o.Application__r.Date_Moved_in_1__c,o.Application__r.Date_Moved_in_2__c,
                        o.Application__r.Date_of_Birth_1__c,o.Application__r.Date_of_Birth_2__c,
                        o.Application__r.Date_Started_1__c,o.Application__r.Date_Started_2__c,
                        o.Application__r.Driver_Licence_State_Issue_1__c,o.Application__r.Driver_Licence_State_Issue_2__c,
                        o.Application__r.Drivers_License_1__c,o.Application__r.Drivers_License_2__c,
                        o.Application__r.Email_Address__c,o.Application__r.Email_Address_2__c,
                        o.Application__r.Employer_ABN_1__c,o.Application__r.Entity_Name__c,
                        o.Application__r.Expiry_Date_1__c,o.Application__r.Expiry_Date_2__c,
                        o.Application__r.Finish_Date_1__c,o.Application__r.Finish_Date_2__c,
                        o.Application__r.First_Name__c,o.Application__r.First_Name_2__c,o.Application__r.Furniture_Value__c,
                        o.Application__r.Gender_1__c,o.Application__r.Gender_2__c,
                        o.Application__r.Home_Phone__c,o.Application__r.Home_Phone_2__c,
                        o.Application__r.Insurance_Expenses_per_Month__c,o.Application__r.Landlord_Name_1__c,o.Application__r.Landlord_Name_2__c,
                        o.Application__r.Landlord_Phone_1__c,o.Application__r.Landlord_Phone_2__c,o.Application__r.Last_Name__c,o.Application__r.Last_Name_2__c,
                        o.Application__r.Marital_Status_1__c,o.Application__r.Marital_Status_2__c,
                        o.Application__r.Middle_Name__c,o.Application__r.Middle_Name_2__c,
                        o.Application__r.Mobile_Number__c,o.Application__r.Mobile_Number_2__c,
                        o.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c,
                        o.Application__r.Mode_of_Employment_1__c,o.Application__r.Mode_of_Employment_2__c,
                        o.Application__r.Nature_of_Business__c,o.Application__r.No_of_Dependants_1__c,o.Application__r.No_of_Dependants_2__c,o.Application__r.No_of_People__c,
                        o.Application__r.Other_Expenses_per_Month__c,
                        o.Application__r.Payment_Frequency_1__c,
                        o.Application__r.Personal_Reference_1_Address__c,o.Application__r.Personal_Reference_1_Full_Name__c,o.Application__r.Personal_Reference_1_Phone__c,o.Application__r.Personal_Reference_1_Relationship__c,
                        o.Application__r.Personal_Reference_2_Address__c,o.Application__r.Personal_Reference_2_Full_Name__c,o.Application__r.Personal_Reference_2_Phone__c,o.Application__r.Personal_Reference_2_Relationship__c,
                        o.Application__r.Postcode__c,o.Application__r.Postcode_2__c,
                        o.Application__r.Previous_Country_1__c,o.Application__r.Previous_Country_1b__c,o.Application__r.Previous_Country_1c__c,o.Application__r.Previous_Country_1d__c,o.Application__r.Previous_Country_1e__c,
                        o.Application__r.Previous_Country_2__c,o.Application__r.Previous_Country_2b__c,o.Application__r.Previous_Country_2c__c,o.Application__r.Previous_Country_2d__c,o.Application__r.Previous_Country_2e__c,
                        o.Application__r.Previous_Employer_Name_1__c,o.Application__r.Previous_Employer_Name_2__c,
                        o.Application__r.Previous_Employer_Phone_1__c,o.Application__r.Previous_Employer_Phone_2__c,
                        o.Application__r.Previous_Mode_of_Employment_1__c,o.Application__r.Previous_Mode_of_Employment_2__c,
                        o.Application__r.Previous_Occupation_1__c,o.Application__r.Previous_Occupation_2__c,
                        o.Application__r.Previous_Postcode_1__c,o.Application__r.Previous_Postcode_1b__c,o.Application__r.Previous_Postcode_1c__c,o.Application__r.Previous_Postcode_1d__c,o.Application__r.Previous_Postcode_1e__c,
                        o.Application__r.Previous_Postcode_2__c,o.Application__r.Previous_Postcode_2b__c,o.Application__r.Previous_Postcode_2c__c,o.Application__r.Previous_Postcode_2d__c,o.Application__r.Previous_Postcode_2e__c,
                        o.Application__r.Previous_Reference_Name_1__c,o.Application__r.Previous_Reference_Name_2__c,
                        o.Application__r.Previous_Residence_Status_1__c,o.Application__r.Previous_Residence_Status_1b__c,o.Application__r.Previous_Residence_Status_1c__c,o.Application__r.Previous_Residence_Status_1d__c,o.Application__r.Previous_Residence_Status_1e__c,
                        o.Application__r.Previous_Residence_Status_2__c,o.Application__r.Previous_Residence_Status_2b__c,o.Application__r.Previous_Residence_Status_2c__c,o.Application__r.Previous_Residence_Status_2d__c,o.Application__r.Previous_Residence_Status_2e__c,
                        o.Application__r.Previous_State_1__c,o.Application__r.Previous_State_1b__c,o.Application__r.Previous_State_1c__c,o.Application__r.Previous_State_1d__c,o.Application__r.Previous_State_1e__c,
                        o.Application__r.Previous_State_2__c,o.Application__r.Previous_State_2b__c,o.Application__r.Previous_State_2c__c,o.Application__r.Previous_State_2d__c,o.Application__r.Previous_State_2e__c,
                        o.Application__r.Previous_Street_Address_1__c,o.Application__r.Previous_Street_Address_1b__c,o.Application__r.Previous_Street_Address_1c__c,o.Application__r.Previous_Street_Address_1d__c,o.Application__r.Previous_Street_Address_1e__c,
                        o.Application__r.Previous_Street_Address_2__c,o.Application__r.Previous_Street_Address_2b__c,o.Application__r.Previous_Street_Address_2c__c,o.Application__r.Previous_Street_Address_2d__c,o.Application__r.Previous_Street_Address_2e__c,
                        o.Application__r.Previous_Street_Number_1__c,o.Application__r.Previous_Street_Number_1b__c,o.Application__r.Previous_Street_Number_1c__c,o.Application__r.Previous_Street_Number_1d__c,o.Application__r.Previous_Street_Number_1e__c,
                        o.Application__r.Previous_Street_Number_2__c,o.Application__r.Previous_Street_Number_2b__c,o.Application__r.Previous_Street_Number_2c__c,o.Application__r.Previous_Street_Number_2d__c,o.Application__r.Previous_Street_Number_2e__c,
                        o.Application__r.Previous_Street_Type_1__c,o.Application__r.Previous_Street_Type_1b__c,o.Application__r.Previous_Street_Type_1c__c,o.Application__r.Previous_Street_Type_1d__c,o.Application__r.Previous_Street_Type_1e__c,
                        o.Application__r.Previous_Street_Type_2__c,o.Application__r.Previous_Street_Type_2b__c,o.Application__r.Previous_Street_Type_2c__c,o.Application__r.Previous_Street_Type_2d__c,o.Application__r.Previous_Street_Type_2e__c,
                        o.Application__r.Previous_Suburb_1__c,o.Application__r.Previous_Suburb_1b__c,o.Application__r.Previous_Suburb_1c__c,o.Application__r.Previous_Suburb_1d__c,o.Application__r.Previous_Suburb_1e__c,
                        o.Application__r.Previous_Suburb_2__c,o.Application__r.Previous_Suburb_2b__c,o.Application__r.Previous_Suburb_2c__c,o.Application__r.Previous_Suburb_2d__c,o.Application__r.Previous_Suburb_2e__c,
                        o.Application__r.Previous_Unit_Number_1__c,o.Application__r.Previous_Unit_Number_1b__c,o.Application__r.Previous_Unit_Number_1c__c,o.Application__r.Previous_Unit_Number_1d__c,o.Application__r.Previous_Unit_Number_1e__c,
                        o.Application__r.Previous_Unit_Number_2__c,o.Application__r.Previous_Unit_Number_2b__c,o.Application__r.Previous_Unit_Number_2c__c,o.Application__r.Previous_Unit_Number_2d__c,o.Application__r.Previous_Unit_Number_2e__c,
                        o.Application__r.Previous_Work_Address_1__c,o.Application__r.Previous_Work_Address_2__c,
                        o.Application__r.Previous_Work_Postcode_1__c,o.Application__r.Previous_Work_Postcode_2__c,
                        o.Application__r.Previous_Work_State_1__c,o.Application__r.Previous_Work_State_2__c,
                        o.Application__r.Previous_Work_Street_Number_1__c,o.Application__r.Previous_Work_Street_Number_2__c,
                        toLabel(o.Application__r.Previous_Work_Street_Type_1__c),toLabel(o.Application__r.Previous_Work_Street_Type_2__c),
                        o.Application__r.Previous_Work_Suburb_1__c,o.Application__r.Previous_Work_Suburb_2__c,
                        o.Application__r.Previous_Work_Unit_Number_1__c,o.Application__r.Previous_Work_Unit_Number_2__c,
                        o.Application__r.Reference_Name_1__c,o.Application__r.Reference_Name_2__c,
                        o.Application__r.Rent_per_month_1__c,o.Application__r.Residential_Payment_Frequency_1__c,
                        o.Application__r.Rent_per_month_2__c,o.Application__r.Board_per_Month_2__c,o.Application__r.Payment_Frequency_2__c,
                        o.Application__r.Start_Date_1__c,o.Application__r.Start_Date_2__c,
                        o.Application__r.State__c,o.Application__r.State_2__c,
                        o.Application__r.Street_Address__c,o.Application__r.Street_Address_2__c,
                        o.Application__r.Street_Number__c,o.Application__r.Street_Number_2__c,
                        toLabel(o.Application__r.Street_Type__c),toLabel(o.Application__r.Street_Type_2__c),
                        o.Application__r.Suburb__c,o.Application__r.Suburb_2__c,o.Application__r.Super_Value_How_Much__c,
                        o.Application__r.Title_1__c,o.Application__r.Title_2__c, //o.Application__r.Total_Credit_Monthly_Payment__c, o.Application__r.Total_Other_Income_1__c,o.Application__r.Total_Other_Income_2__c,
                        o.Application__r.Trading_Address__c,o.Application__r.Trading_Name__c,o.Application__r.Travel_Transport_Expenses_per_Month__c,o.Application__r.Type_of_Asset__c,
                        o.Application__r.Type_of_Licence_1__c,o.Application__r.Type_of_Licence_2__c,
                        o.Application__r.Unit_Number__c,o.Application__r.Unit_Number_2__c,
                        o.Application__r.Work_Phone__c,o.Application__r.Work_Phone_2__c,o.Application__r.Has_Been_Bankrupt__c,o.Application__r.Net_Income_1__c,o.Application__r.Net_Income_2__c,
                        o.Application__r.Account__r.Id,o.Application_AssetDetail__c,o.Application_AssetDetail__r.Price__c,o.Application_AssetDetail__r.Deposit__c,o.Application_AssetDetail__r.PPSR_Proxy_Id__c,o.Application_AssetDetail__r.Search_Certificate_Number__c,
                        o.Application_AssetDetail__r.Actual_KM__c,o.Application_AssetDetail__r.Colour__c,o.Application_AssetDetail__r.Engine_No__c,o.Application_AssetDetail__r.Make__c,
                        o.Application_AssetDetail__r.Model__c,o.Application_AssetDetail__r.Rego__c,o.Application_AssetDetail__r.RRP__c,o.Application_AssetDetail__r.Type__c, o.Application_AssetDetail__r.Lender__c,
                        o.Application_AssetDetail__r.Condition__c, o.Application_AssetDetail__r.Redbook_key__c, o.Application_AssetDetail__r.Factory_Options__c,
                        o.Application_AssetDetail__r.Variant__c,o.Application_AssetDetail__r.VIN__c,o.Application_AssetDetail__r.Year__c,o.ApplicationServicing__r.Income_1__c,o.ApplicationServicing__r.Is_Splitting_Expenses__c,
                        o.ApplicationServicing__r.Net_Partner_Income__c,o.ApplicationServicing__r.Total_Liabilities__c,o.ApplicationServicing__r.Total_Living_Expenses_Full__c,o.ApplicationServicing__r.Total_Net_Monthly_Income__c,o.ApplicationServicing__r.Total_Rent_Mortgage_Full__c,
                        o.ApplicationYTD__r.Income_1_2__c,o.ApplicationYTD__r.Income_2_2__c,
                        o.ApplicationYTD__r.Income_Monthly_1_1__c,o.ApplicationYTD__r.Income_Monthly_1_2__c,
                        o.ApplicationYTD__r.Income_Monthly_2_1__c,o.ApplicationYTD__r.Income_Monthly_2_2__c,o.ApplicationYTD__r.Monthly_Amount_Servicing_1__c,
                        o.Contract_Number__c,o.Dealer_Address__c,o.Dealer_Contact_Name__c,o.Dealer_Name__c,o.Dealer_Phone_Number__c,o.Dealer_Postcode__c,o.Dealer_State__c,o.Dealer_Street_Number__c,o.Dealer_Street_Type__c,o.Dealer_Suburb__c,o.Dealer_Unit_Number__c,
                        o.New_Used__c,o.Purchase_Type__c, o.Owner_Email__c, o.Application__r.Status__c, o.Owner_Name__c,
                        o.Partner_Owner__c, o.Franchise_Owner__c, o.Partner_Owner__r.Name 
                        from Custom_Opportunity__c  as o where id =: oppId];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }

    // Response DTOs
    public class LoanResponseDTO {
      public Integer loanId {get; set;}
      public String brokerReferenceLoanId {get; set;}
      public String branch {get; set;}
      public String broker {get; set;}
      public String submissionStatus {get; set;}
      public String note {get; set;}
      public String createdAt {get; set;}
      public List<LoanResponseDetailsDTO> additionalDetails {get; set;}

      public Boolean getHasMoreDetails() {
        return this.additionalDetails != null && !this.additionalDetails.isEmpty();
      }
    }

    public class LoanResponseDetailsDTO {
      public String field {get; set;}
      public String message {get; set;}
    }

    public static LenderAPIResponse__c saveLenderAPIResponse(Id oppId, Money3APIManager mgr, String quotingName, String apiUser) {
      LenderAPIResponse__c lar = null;
      if (mgr != null && String.isNotBlank(mgr.responseMessage)) {
        lar = new LenderAPIResponse__c();
        lar.Name = quotingName;
        lar.Opportunity__c = oppId;
        lar.Request__c = mgr.reqBody;
        lar.Response__c = mgr.responseMessage;
        lar.Status__c = mgr.responseStatus;
        lar.Provider__c = 'Money3';
        lar.Service__c = 'loans';   
        if (mgr.responseDto != null && mgr.responseDto.loanId > 0) {
          lar.Application_ID__c = String.valueOf(mgr.responseDto.loanId);
          lar.Name += ' [' + lar.Application_ID__c + ']';
          lar.Lender_Login__c = apiUser;
          // this.loadLenderAppResponse(lar.Response__c);
        } else {
          lar.Name += ' [FAIL-' + DateUtils.getTimeForFileName() + ']';
        }

        insert lar;

        saveLenderAPIResponseFiles(lar.Id, mgr);
      }
      return lar;
    }

    public static void saveLenderAPIResponseFiles(Id lenderRes, Money3APIManager mgr) {
      if(
        mgr.responseDto != null &&   
        mgr.responseDto.loanId > 0 &&   
        mgr.responseDto.docs != null && 
        !mgr.responseDto.docs.isEmpty() &&
        lenderRes != null
      ){
        for (LenderAPIResponse__c l : mgr.responseDto.docs) {
          l.LenderAPIResponse__c = lenderRes;
          l.Provider__c = 'Money3';
          l.Service__c = 'documents'; 
        }
        insert mgr.responseDto.docs;
      }
    }

}