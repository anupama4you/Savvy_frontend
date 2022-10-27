@isTest(SeeAllData=true)
public class TestApplicationQuotingTriggerService {
    public static Application_Quoting__c quoting {set;get;}
    public static Application_InsuranceQuote__c quote {get;set;}
    public static Map < String,	id > RecordTypes;
    public static Application__c tstApp {get;set;}
    public static Custom_Opportunity__c tstOpportunity {set; get;}
    public static Account tstLeadConsultantDealer {get;set;}
    public static Contact tstLeadConsultant {get;set;}
    public static Lead__c tstLead {get;set;}
    public static Account tstAccount {set; get;}
    
    @isTest static void testAfterUpdateName() {
    	List<Application_Quoting__c> newList = new List<Application_Quoting__c>();
        Map<Id, Application_Quoting__c> oldMap = new Map<Id, Application_Quoting__c>();
        Application_Quoting__c quotingAux = new Application_Quoting__c();
        
        Test.startTest();
        createQuote('Personal');
        createQuoting('Personal');
        reloadOpportunity();
        reloadApplication();
        reloadAccount();    
		
		    newList.add(quoting);
        quotingAux.Id = quoting.Id;
        quotingAux.Name = 'Pepper MV';
        oldMap.put(quotingAux.Id, quotingAux);
        ApplicationQuotingService.authorizationChecker(newList, oldMap);

        createQuoting('Personal');
        ApplicationQuotingService.removeOlderQuotings(newList);
        
        ApplicationQuotingTriggerHandler handler = new ApplicationQuotingTriggerHandler();
        handler.onBeforeInsert(null);
        handler.onAfterInsert(null, null);
        handler.onAfterDelete(null, null);
        handler.onAfterUpdate(null, null, null, null);
        Test.stopTest();
    }
    
    public static void createQuote(String aseetType) {
		if (tstApp == null || tstApp.Id == null) {
			createApplication(aseetType);
		}
		quote = new Application_InsuranceQuote__c();
		quote.Application__c = tstApp.Id;
        quote.Customer_Choice_Status__c = 'DECI';
		quote.Name = tstOpportunity.Name;
		insert quote;
	}
    
    public static void createQuoting(String aseetType) {
		if (tstApp == null || tstApp.Id == null) {
			createApplication(aseetType);
		}
		quoting = new Application_Quoting__c();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
        quoting.Presentation_Email_Date__c = Date.today();
		quoting.Opportunity__c = tstOpportunity.Id;
		quoting.Name = 'Affordable';
		insert quoting;
	}

    public static void recordTypes() {
		RecordTypes = new Map < String,
		Id > ();
		for (RecordType rt: [SELECT Id, Name
		FROM RecordType]) {
			RecordTypes.put(rt.Name, rt.Id);
		}
	}
    
    public static void createAccountDealer() {
		tstLeadConsultantDealer = new Account(RecordTypeId = recordTypes.get('Savvy Dealer'), Name = 'Testsdgf', BillingStreet = 'Testewr', BillingCity = 'Test', BillingState = 'Test', BillingPostalCode = 'Test', ShippingStreet = 'Test', ShippingCity = 'Test', ShippingState = 'Test', ShippingPostalCode = 'Test', Commission_Amount__c = 123);
		insert tstLeadConsultantDealer;
	}
    
    public static void createContact() {
		createAccountDealer();
		tstLeadConsultant = new Contact(AccountId = tstLeadConsultantDealer.Id, FirstName = 'Testewf', LastName = 'Test');
		insert tstLeadConsultant;
	}
    
    public static void createLead() {
		createAccount();
		createContact();
		tstLead = new Lead__c(Account__c = tstAccount.Id, First_Name__c = 'Testdsf', Last_Name__c = 'Testsdf', Finance_Amount__c = 123, Email_Address__c = 'test2@test.com', Lead_Consultant__c = tstLeadConsultant.Id, OwnerId = UserInfo.getUserId(), Status__c = 'Attempted Contact 1', Mobile_Number__c = '000000', Has_Tax_Returns__c = 'Y', Has_Clean_Credit_History__c = 'Y', Purchase_Type__c = 'Dealer', Deposit__c = 0.00);
		insert tstLead;
	}
    
    public static void createAccount() {
		recordTypes();
		tstAccount = new Account(RecordTypeId = recordTypes.get('Person Account'), FirstName = 'Testsdf', LastName = 'Teshhtwf', 
                                 PersonOtherStreet = 'Test', PersonOtherCity = 'Test', PersonOtherState = 'Test', PersonOtherPostalCode = 'Test', 
                                 PersonEmail = 'QADepartment@Test.com', Portal_UID__c = '3245657sadsfdgfh',
                                 Phone = '000000');
		insert tstAccount;
	}
    
    public static void createOpportunity() {
		if (tstOpportunity == null) {
			createLead();
			tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id, OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Dealer - Vehicles Direct', 
                                                       Status__c = 'Become Opportunity', New_Used__c='new', VD_Owner__c = UserInfo.getUserId(), 
                                                       First_Name__c = 'AAAAAAAAAA', Last_Name__c = 'BBBBBBBB', Mobile_Number__c = '000000', 
                                                       Email_Address__c = 'QADepartment@test.com.au', Dealer_Contact_Name__c = 'Britney Spear', Dealer_Type__c = 'Franshised Dealer - Cars',
                                                       Dealer_Email__c = 'yohan.v+testQA@savvy.com.au', Dealer_Name__c = 'Britney Music Inc', Dealer_Phone_Number__c = '04128745623', 
                                                       Dealer_Mobile__c = '04126745321', Dealer_Suburb__c = 'Montreal', Dealer_Postcode__c = '325671', Dealer_State__c = 'SA', 
                                                       Preapproval_Auth_Date__c = Date.today()
													   );
			insert tstOpportunity;
		}
	}
    
	public static void createApplication(String aseetType) {
		createOpportunity();
        
		tstApp = new Application__c();
		tstApp.Title_1__c = 'Mr';
		tstApp.Name = 'Affordable';
		tstApp.Email_Address__c = 'testQADepartment@savvy.com.au';
		tstApp.First_Name__c = 'Lelo';
		tstApp.Middle_Name__c = 'Joseph';
		tstApp.Last_Name__c = 'Lelos';
		tstApp.Mobile_Number__c = '042588';
        tstApp.Home_Phone__c = '34232';
		tstApp.Work_Phone__c = '2342342';
		tstApp.Business_Structure__c = 'Company';
		tstApp.Application_Type__c = 'Business';
		tstApp.No_of_People__c = 2;
		tstApp.Driver_Licence_State_Issue_1__c = 'NSW';
		tstApp.Start_Date_1__c = '11/05/2018';
        
        tstApp.Street_Number__c = 'AA';
        tstApp.Current_Work_Address_1__c = 'WorkAddress';
		tstApp.Suburb__c = 'NSW';
		tstapp.Date_Moved_in_1__c = '11/05/2017';

		tstApp.First_Name_2__c = 'HJ';
		tstApp.Last_Name_2__c = 'HJ';
		tstApp.Mobile_Number_2__c = '042588';
		tstApp.Mobile_Number_2__c = '45464';
		tstApp.Home_Phone_2__c = '34232';
		tstApp.Work_Phone_2__c = '2342342';

		tstApp.Driver_Licence_State_Issue_2__c = 'NSW';

		tstApp.Date_of_Birth_1__c = '16/06/1996';
		tstApp.Gender_1__c = 'M';
		tstApp.Postcode__c = '5001';
		tstApp.Suburb__c = 'Adelaide';
        tstApp.Current_Work_Street_Number_1__c = 'DD';
        tstApp.Current_Work_Address_1__c = 'Current_Work_Address_1__c';
        tstApp.Street_Address__c = 'ValueAddress';
		tstApp.State__c = 'SA';
		
        //Update NWC Data HJ 04-09-2018 - I
        tstApp.Type_of_Asset__c = 'Personal';
        //Update NWC Data HJ 04-09-2018 - F
        
		tstApp.Mode_of_Employment_1__c = 'Casual';
		tstApp.Mode_of_Employment_2__c = 'Full Time';
		tstApp.Date_Started_1__c = '16/06/2016';
        
        //Update HJ 20-06-2018 -I
        tstApp.Ages_of_Dependants_1__c = '1,10';
        
        tstApp.Personal_Reference_1_Relationship__c = 'Friend';
        tstApp.Personal_Reference_1_Full_Name__c = 'Reference 1';
        tstApp.Personal_Reference_1_Phone__c = '098345';
        tstApp.Personal_Reference_1_Address__c = '12|6 | Kopoola | Crescent | Gilles Plains |NSW| 5086';
        
        tstApp.Personal_Reference_2_Relationship__c = 'Friend2';
        tstApp.Personal_Reference_2_Full_Name__c = 'Reference 2';
        tstApp.Personal_Reference_2_Phone__c = '098332';
        tstApp.Personal_Reference_2_Address__c = '1 |61 | Kopoola | Crescent | Gilles Plains |NSW| 5026';
        
        tstApp.Date_From_1__c = '16/06/2018';
        tstApp.Previous_Unit_Number_1__c = '41';
        tstApp.Previous_Street_Number_1__c = '251';
        tstApp.Previous_Street_Address_1__c = 'PreviousStreeAddress1';
        tstApp.Previous_Suburb_1__c = 'Suburb1';
        tstApp.Previous_Country_1__c = 'AUS';
        tstApp.Previous_Postcode_1__c = '2141';
        tstApp.Previous_State_1__c = 'NSW';
        
        tstApp.Date_From_1b__c = '16/06/2017';
        tstApp.Previous_Unit_Number_1b__c = '41';
        tstApp.Previous_Street_Number_1b__c = '251';
        tstApp.Previous_Street_Address_1b__c = 'PreviousStreeAddress1b';
        tstApp.Previous_Suburb_1b__c = 'Suburb1';
        tstApp.Previous_Country_1b__c = 'AUS';
        tstApp.Previous_Postcode_1b__c = '2141';
        tstApp.Previous_State_1b__c = 'NSW';
        
        tstApp.Date_From_1c__c = '16/06/2016';
        tstApp.Previous_Unit_Number_1c__c = '41';
        tstApp.Previous_Street_Number_1c__c = '251';
        tstApp.Previous_Street_Address_1c__c = 'PreviousStreeAddress1c';
        tstApp.Previous_Suburb_1c__c = 'Suburb1';
        tstApp.Previous_Country_1c__c = 'AUS';
        tstApp.Previous_Postcode_1c__c = '2141';
        tstApp.Previous_State_1c__c = 'NSW';
        
        tstApp.Date_From_1d__c = '16/06/2015';
        tstApp.Previous_Unit_Number_1d__c = '41';
        tstApp.Previous_Street_Number_1d__c = '251';
        tstApp.Previous_Street_Address_1d__c = 'PreviousStreeAddress1d';
        tstApp.Previous_Suburb_1d__c = 'Suburb1';
        tstApp.Previous_Country_1d__c = 'AUS';
        tstApp.Previous_Postcode_1d__c = '2141';
        tstApp.Previous_State_1d__c = 'NSW';
        
        tstApp.Date_From_1e__c = '16/06/2014';
        tstApp.Previous_Unit_Number_1e__c = '41';
        tstApp.Previous_Street_Number_1e__c = '251';
        tstApp.Previous_Street_Address_1e__c = 'PreviousStreeAddress1';
        tstApp.Previous_Suburb_1e__c = 'Suburb1';
        tstApp.Previous_Country_1e__c = 'AUS';
        tstApp.Previous_Postcode_1e__c = '2141';
        tstApp.Previous_State_1e__c = 'NSW';
        
        //Applicant_2
        tstApp.Date_From_2__c = '16/06/2016';
        tstApp.Unit_Number_2__c = '4111';
        tstApp.Street_Number_2__c = '234';
        tstApp.Street_Address_2__c = 'PreviousStreeAddress2c';
        tstApp.Suburb_2__c = 'Suburb1';
        tstApp.Postcode_2__c = '2141';
        tstApp.Driver_Licence_State_Issue_2__c = 'NSW';
        
        //Full PepperAPI LibertyAPI No Company
        tstApp.Application_Type__c = 'Personal';
        //Update HJ 20-06-2018 -F
		insert tstApp;
		tstOpportunity.Application__c = tstApp.Id;
		update tstOpportunity;
	}

   	public static void reloadOpportunity() {
		tstOpportunity = [
		SELECT VD_Worksheet__c, VD_Date_Sent__c, Owner_Name__c, VD_Owner__c, VD_Status_Process__c, First_Name__c, Last_Name__c, Address__c, 
		       Mobile_Number__c, Home_Phone__c, Work_Phone__c, Email_Address__c, New_Used__c, Vehicle_Details__c, Lender_Approved__c, 
		       Pre_Approved_Amount__c, Pre_Approved_Vehicle_Age__c, Required_Client_Deposit__c, Client_Budget__c, Payout_Details__c, 
		       Trade_in_Details__c, Dealer_Contacted__c, Special_Conditions__c, VD_Notes__c, VD_Is_Old_Process__c, VD_Status__c, Contract_Number__c,
               Dealer_Name__c, Dealer_Email__c, Dealer_Address__c, Dealer_Contact_Name__c, Dealer_Phone_Number__c, Dealer_Suburb__c, Dealer_Postcode__c,Dealer_State__c,
		       VD_Worksheet__r.VD_Approver__c, VD_Worksheet__r.Type_of_Process__c, Application_AssetDetail__c, Application_AssetDetail__r.Type__c, 
		       Application_AssetDetail__r.Condition__c, Application_AssetDetail__r.Lender__c, Application_AssetDetail__r.Type_Loan__c, 
		       Application_AssetDetail__r.Make__c, Application__c, Name, Application__r.Date_of_Birth_1__c, Application__r.Gender_1__c, 
		       Application__r.Postcode__c, Application__r.Suburb__c, Application__r.State__c, Application__r.Application_Type__c, 
		       Application__r.Mode_of_Employment_1__c, Application__r.Date_Started_1__c, Application_AssetDetail__r.Actual_KM__c, 
		       Application_AssetDetail__r.Date_First_Registered__c, Application_AssetDetail__r.Redbook_Key__c, Application_AssetDetail__r.Model__c, 
		       Application_AssetDetail__r.Variant__c, Application_AssetDetail__r.Series__c, Application__r.First_Name__c, Application__r.Middle_Name__c, Application__r.Last_Name__c, 
		       Application__r.Title_1__c, Application__r.Current_Occupation_1__c, Application__r.Business_ABN__c, Application__r.Email_Address__c, 
		       Application__r.Mobile_Number__c, Application__r.Home_Phone__c, Application__r.Work_Phone__c, Application__r.Unit_Number__c, 
		       Application__r.Street_Number__c, Application__r.Street_Address__c, Application__r.Street_Type__c, Application__r.Current_Work_Unit_Number_1__c, 
		       Application__r.Current_Work_Street_Number_1__c, Application__r.Current_Work_Address_1__c, Application__r.Current_Work_Street_Type_1__c, 
		       Application__r.Current_Work_Suburb_1__c, Application__r.Current_Work_State_1__c, Application__r.Current_Work_Postcode_1__c, Application__r.Date_of_Birth_2__c, 
		       Application_AssetDetail__r.Rego__c, Application_AssetDetail__r.Rego_State__c, Application_AssetDetail__r.VIN__c, Application__r.First_Name_2__c, 
		       Application_AssetDetail__r.Engine_No__c, Application_AssetDetail__r.Factory_Options__c, Application_AssetDetail__r.Price__c, Application__r.Last_Name_2__c, 
		       Application_AssetDetail__r.Deposit__c, Application_AssetDetail__r.Warranty__c, Application_AssetDetail__r.GAP__c, Application__r.Living_more_than_three_years_1__c, 
		       Application_AssetDetail__r.LPI__c, Application_AssetDetail__r.LTI__c, Application_AssetDetail__r.Fees__c, Application_AssetDetail__r.Variant_Desc__c, Lead__r.First_Name__c, Lead__r.Last_Name__c, Lead__r.Mobile_Number__c, 
		       Lead__r.Email_Address__c, Lead__r.Application_Type__c, Application__r.Net_Income_1__c, Lead__r.Has_Tax_Returns__c, Lead__r.Has_Clean_Credit_History__c, 
               ApplicationYTD__r.Type__c, ApplicationYTD__r.Monthly_Amount_Servicing_1__c, ApplicationYTD__r.Income_Monthly_1_1__c, Application__r.Current_Residential_Status_1__c, 
               ApplicationYTD__r.Start_Date_1__c, ApplicationYTD__r.End_Date_1__c, ApplicationYTD__r.Weeks_1__c, ApplicationYTD__r.Income_1_1__c, ApplicationYTD__r.Income_1_2__c,
               ApplicationYTD__r.Start_Date_2__c, ApplicationYTD__r.End_Date_2__c, ApplicationYTD__r.Weeks_2__c, ApplicationYTD__r.Income_2_1__c, ApplicationYTD__r.Income_2_2__c,
               ApplicationYTD__r.Difference_2__c, ApplicationYTD__r.Discounted_2__c, ApplicationYTD__r.Monthly_Amount_Servicing_2__c, ApplicationYTD__r.Income_Monthly_2_1__c,
               ApplicationYTD__r.Income_Monthly_2_2__c, ApplicationYTD__r.Comment_2__c, ApplicationYTD__r.Latest_Payment_2__c, ApplicationYTD__r.Latest_Payment_Frequency_2__c, ApplicationYTD__r.Latest_Payment_Frequency_1__c,
               ApplicationYTD__r.Difference_1__c, ApplicationYTD__r.Discounted_1__c, ApplicationYTD__r.Comment_1__c, ApplicationYTD__r.Latest_Payment_1__c,
               ApplicationYTD__r.Start_Date_A_1__c, ApplicationYTD__r.Annually_1_1__c, ApplicationYTD__r.Annually_1_2__c, ApplicationYTD__r.Start_Date_A_2__c, ApplicationYTD__r.Annually_2_1__c,
               ApplicationYTD__r.Annually_2_2__c, ApplicationYTD__r.GrossAnnualIncomeApplic1__c, ApplicationYTD__r.GrossAnnualIncomeApplic2__c,
               ApplicationYTD__r.Lender__c, ApplicationYTD__r.Sales__c, ApplicationYTD__r.Self_Employed_Class__c, ApplicationYTD__r.Trustess_Number__c, ApplicationYTD__r.Net_Profit_2__c,
               ApplicationYTD__r.Sales_2__c, ApplicationYTD__r.Self_Employed_Class_2__c, ApplicationYTD__r.Self_Employed_Type_2__c, ApplicationYTD__r.Trustess_Number_2__c, ApplicationYTD__r.Net_Profit_2_2__c, ApplicationYTD__r.Self_Employed_Type__c,
               ApplicationYTD__c, ApplicationServicing__c, Application__r.No_of_Dependants_1__c, Application__r.Marital_Status_1__c,  Application__r.Date_Moved_in_1__c, 
		       Application_AssetDetail__r.Colour__c, Purchase_Type__c, Application__r.No_of_People__c, Application__r.Length_of_Term__c, Application__r.Purchase_Price__c, 
               Application__r.Bank_Value__c, Lead__r.Purchase_Type__c, Lead__r.Deposit__c, Lead__r.Has_Credit_Enquiries__c, Application__r.Previous_Country_1b__c, Application__r.Previous_Country_1c__c, 
               Application__r.Previous_Country_1d__c, Application__r.Previous_Country_1e__c, Application__r.Previous_Country_2b__c, Application__r.Previous_Country_2c__c, 
               Application__r.Previous_Country_2d__c, Application__r.Previous_Country_2e__c, ApplicationYTD__r.Income_Monthly_1_2__c, Application__r.Do_you_have_drivers_licence_1__c, 
		       ApplicationYTD__r.Latest_Payment_Monthly_1__c, Application__r.Rent_per_month_1__c, Application__r.Board_per_month_1__c, Application__r.Title_2__c, Application__r.Do_you_have_drivers_licence_2__c, 
		       Owner_Phone__c, Owner_Mobile__c, Owner_Email__c, Application__r.Status__c, Application__r.Current_Residence_Status_1__c, Application__r.Finance_Amount__c, Application__r.Repayment_Regularity__c, 
		       Application__r.Residential_Payment_Frequency_1__c, Application__r.Date_From_1b__c, Application__r.Date_From_1c__c, Application__r.Date_From_1d__c, Application__r.Date_From_1e__c, 
               Application__r.Date_From_2b__c, Application__r.Date_From_2c__c, Application__r.Date_From_2d__c, Application__r.Date_From_2e__c, Application__r.Current_Residential_Status_2__c, 
		       Application__r.Previous_Street_Address_1b__c, Application__r.Previous_Street_Address_1c__c, Application__r.Previous_Street_Address_1d__c, Application__r.Previous_Street_Address_1e__c, 
               Application__r.Previous_Street_Address_2b__c, Application__r.Previous_Street_Address_2c__c, Application__r.Previous_Street_Address_2d__c, Application__r.Previous_Street_Address_2e__c, 
               Application__r.Previous_Residence_Status_1b__c, Application__r.Previous_Residence_Status_1c__c, Application__r.Previous_Residence_Status_1d__c, Application__r.Previous_Residence_Status_1e__c, 
               Application__r.Previous_Residence_Status_2b__c, Application__r.Previous_Residence_Status_2c__c, Application__r.Previous_Residence_Status_2d__c, Application__r.Previous_Residence_Status_2e__c, 
               Application__r.Drivers_License_1__c, Application_AssetDetail__r.Year__c, Application__r.Year_First_Licensed_1__c, Application__r.Marital_Status_2__c, Application__r.No_of_Dependants_2__c, 
		       Application__r.Time_Last_Fault_1__c, Application__r.Type_of_Asset__c, Loan_Product__c, Application__r.Vehicle_Year__c, Account__r.FirstName, Account__r.LastName, Account__r.Phone, 
               Loan_Product__r.Brokerage_GST_Inc__c, Loan_Product__r.Loan_Purpose__c, Loan_Product__r.Loan_Type__c,  Application__r.Mobile_Number_2__c, Application__r.Email_Address_2__c, Application__r.Current_Employer_Name_1__c, 
               Loan_Product__r.Loan_Product__c, Loan_Product__r.Loan_Type_Detail__c, Loan_Product__r.Loan_Term__c, Loan_Product__r.Balloon_Residual_Requested__c, Application__r.Applicant_2_living_in_the_same_address__c, 
               Loan_Product__r.Client_Rate__c, Loan_Product__r.Repayment_Regularity__c, Loan_Product__r.Lender__c, Loan_Product__r.Loan_Number__c, Application__r.Current_Employer_Phone_1__c, Application__r.Bank_Name__c, 
               Loan_Product__r.Cost_of_Goods__c, Loan_Product__r.DOF__c, Loan_Product__r.Lender_App_Fee__c, Loan_Product__r.Deposit__c, Loan_Product__r.Brokerage__c, Application__r.Date_Started_2__c, 
               Application__r.Finish_Date_1__c, Application__r.Payment_Frequency_1__c, Application__r.Employed_for_more_than_two_years_1__c, Application__r.Payment_Frequency_2__c, Application__r.Employed_for_more_than_two_years_2__c, 
               Application__r.Mode_of_Employment_2__c, Application__r.Current_Employer_Name_2__c, Application__r.Current_Work_Address_2__c, Application__r.Current_Employer_Phone_2__c, Application__r.Net_Income_2__c, 
               Loan_Product__r.Equalisation_Fee_PPSR__c, Application__r.Start_Date_1__c, Application__r.Super_Value_How_Much__c, Application__r.Basic_Living_Expenses_Per_Month__c, Application__r.Childcare_Child_Maintenance_Per_Month__c,
               Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c, Application__r.Insurance_Expenses_per_Month__c, Application__r.Travel_Transport_Expenses_per_Month__c, Application__r.Personal_Reference_1_Full_Name__c, 
               Application__r.Personal_Reference_1_Relationship__c, Application__r.Personal_Reference_1_Address__c, Application__r.Personal_Reference_1_Phone__c, Application__r.Personal_Reference_2_Full_Name__c, 
               Application__r.Personal_Reference_2_Relationship__c, Application__r.Personal_Reference_2_Address__c, Application__r.Personal_Reference_2_Phone__c, Dealer_Mobile__c, Dealer_Type__c, OwnerType__c, OwnerId,
               Application__r.Name
		FROM Custom_Opportunity__c WHERE Id = :tstOpportunity.Id];
	}

    public static void reloadApplication(){
        tstApp = [Select Id, Title_1__c, Name, Email_Address__c, First_Name__c, Middle_Name__c, Last_Name__c, Mobile_Number__c, 
                  Home_Phone__c, Work_Phone__c, Business_Structure__c, Application_Type__c, No_of_People__c, 
                  Driver_Licence_State_Issue_1__c, Start_Date_1__c, Street_Number__c, Suburb__c, Date_Moved_in_1__c, First_Name_2__c, Last_Name_2__c,
				  Mobile_Number_2__c, Home_Phone_2__c, Work_Phone_2__c, Driver_Licence_State_Issue_2__c, Date_of_Birth_1__c,
                  Gender_1__c, Postcode__c, Current_Work_Street_Number_1__c, Current_Work_Address_1__c, Street_Address__c, State__c,
                  Type_of_Asset__c, Mode_of_Employment_1__c, Mode_of_Employment_2__c, Date_Started_1__c, Ages_of_Dependants_1__c, Personal_Reference_1_Relationship__c, 
                  Personal_Reference_1_Full_Name__c, Personal_Reference_1_Phone__c, Personal_Reference_1_Address__c, Personal_Reference_2_Relationship__c, Personal_Reference_2_Full_Name__c, 
                  Personal_Reference_2_Phone__c, Personal_Reference_2_Address__c, Date_From_1__c, Previous_Unit_Number_1__c, Previous_Street_Number_1__c, Previous_Street_Address_1__c,
                  Previous_Suburb_1__c, Previous_Country_1__c, Previous_Postcode_1__c, Previous_State_1__c, Date_From_1b__c, Previous_Unit_Number_1b__c, Previous_Street_Number_1b__c, Previous_Street_Address_1b__c,
                  Previous_Suburb_1b__c, Previous_Country_1b__c, Previous_Postcode_1b__c, Previous_State_1b__c, Date_From_1c__c, Previous_Unit_Number_1c__c, Previous_Street_Number_1c__c, Previous_Street_Address_1c__c,
        		  Previous_Suburb_1c__c, Previous_Country_1c__c, Previous_Postcode_1c__c, Previous_State_1c__c, Date_From_1d__c, Previous_Unit_Number_1d__c, Previous_Street_Number_1d__c, Previous_Street_Address_1d__c, 
                  Previous_Suburb_1d__c, Previous_Country_1d__c, Previous_Postcode_1d__c, Previous_State_1d__c, Date_From_1e__c, Previous_Unit_Number_1e__c, Previous_Street_Number_1e__c, Previous_Street_Address_1e__c, 
                  Previous_Suburb_1e__c, Previous_Country_1e__c, Previous_Postcode_1e__c, Previous_State_1e__c, Date_From_2__c, Unit_Number_2__c, Street_Number_2__c, 
        		  Street_Address_2__c, Suburb_2__c, Postcode_2__c
                  From Application__c 
                  Where Id =:tstApp.Id];
    }
    
    public static void reloadAccount(){
        tstAccount = [Select Id, RecordTypeId, FirstName, LastName, PersonOtherStreet, PersonOtherCity, PersonOtherState, 
                      PersonOtherPostalCode, PersonEmail, Portal_UID__c  
                      From Account 
                      Where Id =:tstAccount.Id
                     ];
    }
}