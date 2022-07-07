@isTest
public class Test_DataGeneratorHelper {

	public static Account tstAccount {get;set;}
    public static Application_Loan__c tstAppLoan {get; set;}
	public static Account tstLeadConsultantDealer {get;set;}
	public static Contact tstLeadConsultant {get;set;}
	public static Lead__c tstLead {get;set;}
	public static Custom_Opportunity__c tstOpportunity {get;set;}
    public static Application_Employment__c tstApplicationEmployment {set; get;}
	public static Product__c tstFinanceProduct {get;set;}
    public static Product__c tstProduct {get;set;}
    public static Invoice__c tstInvoice {get;set;}
    public static XeroOnlineInvoices tstXeroOnlineInvoices {get; set;}
	public static Map < String,	id > RecordTypes;	//Lelo							2016-08-16
	public static Application__c tstApp {get;set;}
	public static Application_Asset_Detail__c asset {get;set;}
	public static Application_Quoting__c quoting {set;get;}
	public static Application_InsuranceQuote__c quote {get;set;}
	public static Application_Additional_Driver__c mainDriver {get;set;}
	public static Application_Additional_Driver__c otherDriver {get;set;}
	public static Map < String,	Id > recordTypeMap {get;set;}
	public static Required_Document__c tstRequiredDocument {get;set;}
	public static Glass_Make__c tstGlassMake {get;set;}
    public static Glass_Variant__c tstGlassVariant {get;set;}
    public static Glass_Model__c tstGlassModel {get;set;}
    public static Application_YTD__c tstAppYTD {get;set;}
    
	public static void recordTypes() {

		RecordTypes = new Map < String,
		Id > ();
		for (RecordType rt: [SELECT Id, Name
		FROM RecordType]) {
			RecordTypes.put(rt.Name, rt.Id);
		}
	}
    
    public static void createAccount() {
		recordTypes();
		tstAccount = new Account(RecordTypeId = recordTypes.get('Person Account'), FirstName = 'Testsdf', LastName = 'Teshhtwf', 
                                 PersonOtherStreet = 'Test', PersonOtherCity = 'Test', PersonOtherState = 'Test', PersonOtherPostalCode = 'Test', 
                                 PersonEmail = 'QADepartment@Test.com', Portal_UID__c = '3245657sadsfdgfh',
                                 Phone = '000000');
		insert tstAccount;
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
    
	public static void createHomeLead() {
		createAccount();
		createContact();
		tstLead = new Lead__c(
			Account__c = tstAccount.Id, First_Name__c = 'Testdsf', Last_Name__c = 'Testsdf', Finance_Amount__c = 123, Email_Address__c = 'test2@test.com', 
			Lead_Consultant__c = tstLeadConsultant.Id, OwnerId = UserInfo.getUserId(), Status__c = 'Attempted Contact 1', Loan_Type__c = 'Home Loan');
		insert tstLead;
	}
    
	public static void createOpportunity() {
		if (tstOpportunity == null) {
			createAccount();
			createLead();
			tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id, OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Dealer - Vehicles Direct', 
                                                       Status__c = 'Become Opportunity', New_Used__c='new', VD_Owner__c = UserInfo.getUserId(), 
                                                       First_Name__c = 'AAAAAAAAAA', Last_Name__c = 'BBBBBBBB', Mobile_Number__c = '000000', 
                                                       Email_Address__c = 'QADepartment@test.com.au', Dealer_Contact_Name__c = 'Britney Spear', Dealer_Type__c = 'Franshised Dealer - Cars',
                                                       Dealer_Email__c = 'yohan.v+testQA@savvy.com.au', Dealer_Name__c = 'Britney Music Inc', Dealer_Phone_Number__c = '04128745623', 
                                                       Dealer_Mobile__c = '04126745321', Dealer_Suburb__c = 'Montreal', Dealer_Postcode__c = '325671', Dealer_State__c = 'SA'
													   );
			insert tstOpportunity;
		}
	}
    
    public static void createOpportunity2() {
        if (tstOpportunity == null) {
            createAccount();
            createLead();
            tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id
                , OwnerId = UserInfo.getUserId(), Purchase_Type__c = null
                , Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId()
                , First_Name__c = 'AAAAAAAAAA', Last_Name__c = 'BBBBBBBB', Mobile_Number__c = '000000'
                , Email_Address__c = 'QADepartment@test.com.au'
                //Just for NPS Report
                //, Status__c = 'Settled'
                //,Date_closed_or_settled__c = Date.today()
                //,NPS__c = 9
                );
            insert tstOpportunity;
        }
    }
    
    public static void createOpportunity3() {
        if (tstOpportunity == null) {
            createAccount();
            createLead();
            tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id
                , OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Refinance_Macq'
                , Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId()
                , First_Name__c = 'AAAAAAAAAA', Last_Name__c = 'BBBBBBBB', Mobile_Number__c = '000000'
                , Email_Address__c = 'QADepartment@test.com.au', Contract_Number__c = null
                //Just for NPS Report
                //, Status__c = 'Settled'
                //,Date_closed_or_settled__c = Date.today()
                //,NPS__c = 9
                );
            insert tstOpportunity;
        }
    }
    
    public static void createOpportunity4() {
        if (tstOpportunity == null) {
            createAccount();
            createLead();
            tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id
                , OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Private'
                , Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId()
                , First_Name__c = 'AAAAAAAAAA', Last_Name__c = 'BBBBBBBB', Mobile_Number__c = '000000'
                , Email_Address__c = 'QADepartment@test.com.au', Contract_Number__c = null, Dealer_Name__c='n'
                ,Dealer_Email__c='d@example.com', Dealer_Address__c='a', Dealer_Phone_Number__c='1'
                , Dealer_Suburb__c='s', Dealer_Postcode__c='1', Dealer_Contact_Name__c='n', Dealer_State__c='ACT'                            
                //Just for NPS Report
                //, Status__c = 'Settled'
                //,Date_closed_or_settled__c = Date.today()
                //,NPS__c = 9
                );
            insert tstOpportunity;
        }
    }
	//Yohan VillaLeal                     2019-08-11
	//This method is for Prospa Test
    public static void createOpportunityAccount() {
		if (tstOpportunity == null) {
			createAccount();
			createLead();
			tstOpportunity = new Custom_Opportunity__c(Account__c = tstAccount.Id, Lead__c = tstLead.Id, OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Dealer - Vehicles Direct'
				, Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId(), Email_Address__c = 'QADepartment@test.com.au'
				//Just for NPS Report
				//, Status__c = 'Settled'
				//,Date_closed_or_settled__c = Date.today()
				//,NPS__c = 9
			);
			insert tstOpportunity;
		}
	}
    
    public static void createOpportunityLead() {
		if (tstOpportunity == null) {
			createLead();
			tstOpportunity = new Custom_Opportunity__c(Lead__c = tstLead.Id, OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Dealer - Vehicles Direct'
				, Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId(), Email_Address__c = 'QADepartment@test.com.au'
				//Just for NPS Report
				//, Status__c = 'Settled'
				//,Date_closed_or_settled__c = Date.today()
				//,NPS__c = 9
			);
			insert tstOpportunity;
		}
	}
    
    public static void createOpportunityWithoutLeadAndAccount() {
		if (tstOpportunity == null) {
			tstOpportunity = new Custom_Opportunity__c(OwnerId = UserInfo.getUserId(), Purchase_Type__c = 'Dealer - Vehicles Direct'
				, Status__c = 'Quote Sent', New_Used__c='new', VD_Owner__c = UserInfo.getUserId(), Email_Address__c = 'QADepartment@test.com.au'
				//Just for NPS Report
				//, Status__c = 'Settled'
				//,Date_closed_or_settled__c = Date.today()
				//,NPS__c = 9
			);
			insert tstOpportunity;
		}
	}
    //
	public static void createProduct() {
		createOpportunity();
		recordTypes();
		tstFinanceProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'), Opportunity_Name__c = tstOpportunity.Id, End_of_Loan_Date__c = Date.today().addDays(60), DOF__c = 1, Brokerage__c = 1);
		insert tstFinanceProduct;

		tstOpportunity.Loan_Product__c = tstFinanceProduct.Id;
		update tstOpportunity;
	}

    //-----------------------------------------------------------------------------------------
    //Yohan VillaLeal                     2019-10-01
    public static void createApplicationEmployment(String applic) {
		tstApplicationEmployment = new Application_Employment__c(Type__c = 'Second Job', Applicant__c = applic, Application__c = tstOpportunity.Application__r.Id);
		insert tstApplicationEmployment;
	}
    //
    //VillaLeal                 2018-10-02
    public static void instanceProduct(String recorType, Integer dofAmount, Integer brokAmount){
        createOpportunity();
		recordTypes();
		tstProduct = new Product__c(RecordTypeId = RecordTypes.get(recorType), Opportunity_Name__c = tstOpportunity.Id, End_of_Loan_Date__c = Date.today().addDays(60), DOF__c = dofAmount, Brokerage__c = brokAmount);
        insert tstProduct;
        
        tstOpportunity.Loan_Product__c = tstProduct.Id;
		update tstOpportunity;
    }
    
    //VillaLeal                 2018-10-02
    public static void createInvoice(String recordType, String recorType, Integer dofAmount, Integer brokAmount){
   		instanceProduct(recorType, dofAmount, brokAmount);
        
        tstInvoice = new Invoice__c(Opportunity__c = tstOpportunity.Id, Product__c = tstProduct.Id, Date_of_Invoice__c = Date.today(), RecordTypeId = RecordTypes.get(recordType));
    	insert tstInvoice;
    }
    
	//Lelo							2016-08-16
	public static void createApplication() {

		createOpportunity();
        
		tstApp = new Application__c();
		tstApp.Title_1__c = 'Mr';
		tstApp.Name = 'd';
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
        tstApp.Type_of_Asset__c = 'Car';
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

        //Money3 Start
        tstApp.Current_Residence_Status_1__c = 'Mortgage';
        tstApp.Current_Residence_Status_2__c = 'Renting(Private)';
        tstApp.Gender_2__c = 'F';
        tstApp.Email_Address_2__c = 'testQADepartment1@savvy.com.au';
        tstApp.Has_Been_Bankrupt__c = 'N';
        tstApp.Marital_Status_1__c = 'Married';
        tstApp.Marital_Status_2__c = 'Married';
        tstApp.Ages_of_Dependants_2__c = '1,10';
        tstApp.Drivers_License_1__c = '123456';
        tstApp.Drivers_License_2__c = '654321';
        tstApp.Driver_Licence_State_Issue_1__c = 'WA';
        tstApp.Driver_Licence_State_Issue_2__c = 'NT';
        tstApp.Expiry_Date_1__c = '01/01/2030';
        tstApp.Expiry_Date_2__c = '01/01/2030';
        tstApp.Street_Type__c = 'ST';
        tstApp.Street_Type_2__c = 'ST';
        tstApp.Date_Moved_in_2__c = '11/05/2017';
        tstApp.Current_Work_Street_Type_1__c = 'ST';
        tstApp.Current_Work_Street_Type_2__c = 'ST';
        tstApp.Date_Started_2__c = '01/01/2010';
        tstApp.Previous_Mode_of_Employment_1__c = 'Self Employed';
		tstApp.Previous_Mode_of_Employment_2__c = 'Contract';
        tstApp.Previous_Work_Street_Type_1__c = 'ST';
        tstApp.Previous_Work_Street_Type_2__c = 'ST';
        tstApp.Start_Date_1__c = '11/05/2017';
        tstApp.Finish_Date_1__c = '11/05/2018';
        tstApp.Start_Date_2__c = '11/05/2017';
        tstApp.Finish_Date_2__c = '11/05/2019';
        tstApp.Bank_Value__c = 50000;
        tstApp.Super_Value_How_Much__c = 50000;
        tstApp.Furniture_Value__c = 10000;
        tstApp.Basic_Living_Expenses_Per_Month__c = '500';
        //Money3 end

		insert tstApp;
		tstOpportunity.Application__c = tstApp.Id;
		update tstOpportunity;
	}
    
    public static void createApplication2() {
        
        createOpportunity2();
        
        tstApp = new Application__c();
        tstApp.Title_1__c = 'Mr';
        tstApp.Name = 'd';
        tstApp.Email_Address__c = 'l@l.l';
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
        tstApp.Type_of_Asset__c = 'Car';
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
    
    public static void createApplication3() {
        
        createOpportunity3();
        
        tstApp = new Application__c();
        tstApp.Title_1__c = 'Mr';
        tstApp.Name = 'd';
        tstApp.Email_Address__c = 'l@l.l';
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
        tstApp.Type_of_Asset__c = 'Car';
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
    
    public static void createApplication4() {
        
        createOpportunity4();
        
        tstApp = new Application__c();
        tstApp.Title_1__c = 'Mr';
        tstApp.Name = 'd';
        tstApp.Email_Address__c = 'l@l.l';
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
        tstApp.Type_of_Asset__c = 'Car';
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
    
	public static void createRequiredDocument() {
		createOpportunity();

		tstRequiredDocument = new Required_Document__c(Type__c = 'Preliminary Assessment', Opportunity__c = tstOpportunity.Id, Name = 'testName.txt');
		insert tstRequiredDocument;
		Attachment att = new Attachment(Name = 'testName.txt', Body = Blob.valueOf('Unit Test Attachment Body'), ParentId = tstRequiredDocument.Id);

		insert att;
		tstRequiredDocument.Attachment_Id__c = att.Id;
		update tstRequiredDocument;
	}

	public static void createAssetDetailLTV() {
        Decimal y = Decimal.valueOf(Date.today().year());
		createOpportunity();
		asset = new Application_Asset_Detail__c(
			Type__c = 'Car', Condition__c = 'new', Lender__c = 'ANZ', Type_Loan__c = 'Consumer', Make__c = 'AUD', 
			Variant__c = 'AUDA1-SI1610TV32016A', Model__c = 'AUD001', Rego__c = 'xxxx1025', Rego_State__c = 'SA', 
			VIN__c = 'WDD2050422F071012', Actual_KM__c = 45000, Year__c = y, Fees__c = 1, Series__c='s',
            Redbook_Key__c='r'
		);
		insert asset;

		tstOpportunity.Application_AssetDetail__c = asset.Id;
		update tstOpportunity;

		////Asset Details - Reltated Objectes
		////Make
		Glass_Make__c m = null;
		List<Glass_Make__c> mList = [SELECT Id FROM Glass_Make__c WHERE Code__c = :asset.Make__c LIMIT 1];
		if (mList.isEmpty()) {
			m = new Glass_Make__c();
			m.Code__c = asset.Make__c;
			m.Name = 'AUDI';
			insert m;
		} else {
			m = mList.get(0);
		}


		//Model
		Glass_Model__c n = new Glass_Model__c();
		n.Code__c = asset.Model__c;
		n.Name = 'A4 QUATTRO';
		n.Make__c = m.Id;
		n.Type_Source__c = 'PVG';
		insert n;

		//Variant
		//Glass_Variant__c v = new Glass_Variant__c();
		//v.Code__c = asset.Variant__c;
		//v.Name = 'AUDI XXXXXX';
		//v.Model__c = n.Id;
		//v.NVIC__c = 'DRSF4';
		//insert v;
	}

	public static void createVDWorksheet() {
		createOpportunity();
		VD_Worksheet__c ws = new VD_Worksheet__c();
		ws.Name = 'WS-' + tstOpportunity.Name;
		ws.Type_of_Process__c = 'Fleet Referral';
		ws.Accessory_Label_1__c = 'Window Tint';
		ws.Accessory_Label_2__c = 'Paint Protection';
		ws.Accessory_Label_3__c = 'Reverse Camera';
		ws.Accessory_Invoice_Label_1__c = 'Window Tint';
		ws.Accessory_Invoice_Label_2__c = 'Paint Protection';
		ws.Accessory_Invoice_Label_3__c = 'Transportation';
		ws.VD_Approver__c = null;
		insert ws;
		tstOpportunity.VD_Worksheet__c = ws.Id;
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
               Application__r.Name, Application__r.Credit_Status_1__c, Application__r.Credit_Status_2__c, Application__r.Previous_Work_Country_1__c, Application__r.Previous_Mode_of_Employment_1__c, ApplicationServicing__r.Lender_Code__c,
               ApplicationServicing__r.Is_Splitting_Expenses__c, ApplicationServicing__r.Partner_Income__c, ApplicationServicing__r.Net_Non_Centrelink__c, ApplicationServicing__r.Is_Split_Rent_Mortgage__c, ApplicationServicing__r.Is_Split_Living_Expenses__c,
               ApplicationServicing__r.Income_1__c, ApplicationServicing__r.Income_1b__c, ApplicationServicing__r.Income_2__c, ApplicationServicing__r.Income_2b__c, ApplicationServicing__r.Net_Profit_After_Tax__c, ApplicationServicing__r.Net_Profit_Before_Tax__c,
               ApplicationServicing__r.Area__c, Application__r.Street_Address_2__c, Application__r.Suburb_2__c, Application__r.Date_Moved_in_2__c, Owner.Name, ApplicationServicing__r.Total_Living_Expenses_Full__c
    FROM Custom_Opportunity__c WHERE Id = :tstOpportunity.Id];
	}

	public static void sleep(Long milliSeconds) {
		Long timeDiff = 0;
		DateTime firstTime = System.now();
		do {
			timeDiff = System.now().getTime() - firstTime.getTime();
		}
		while ( timeDiff <= milliSeconds );
	}

	//-
	public static void applicationQuoting(Boolean isConsumer) {
		quoting = new Application_Quoting__c();
		createApplication();
		createAssetDetailLTV();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
		quoting.Opportunity__c = tstOpportunity.Id;
		//Lender

		//Vehicle Details
		quoting.Vehicle_Detail_State__c = 'NSW';
		if (isConsumer) {
			quoting.Name = MacquarieConsumerExtension.LENDER_QUOTING;
			quoting.Loan_Product__c = 'Consumer Loan';
			quoting.Goods_type__c = 'MOTOV';
			quoting.Goods_sub_type__c = 'MOTOV_CARS_-_OTHER_CARS_AU';
		} else {
			quoting.Name = MacquarieCommercialExtension.LENDER_QUOTING;
			quoting.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
			quoting.Goods_type__c = 'LIFES';
			quoting.Goods_sub_type__c = 'LIFES_MOTORCYCLES_&_SCOOTERS_AU';
		}

		quoting.Loan_Type__c = 'Refinance';
		quoting.Loan_Frequency__c = 'MONTHLY';
		quoting.Vehicle_Price__c = 2500;
		quoting.Deposit__c = 1000;
		quoting.Trade_In__c = 2;
		quoting.Payout_On__c = 50;
		quoting.Residual_Value_Percentage__c = 20;
		quoting.Residual_Value_Percentage__c = 20;

		quoting.Insurance_GAP_Retail_Price__c = 100;
		quoting.Insurance_Warranty_Retail_Price__c = 100;
		quoting.Insurance_LTI_Retail_Price__c = 100;
		quoting.Insurance_TAI_Retail_Price__c = 100;
		quoting.Insurance_MV_Retail_Price__c = 100;
		quoting.Term__c = 36;
        quoting.Residual_Value__c = 2000;
		quoting.Application_Fee__c = 50;
		//Save the record
		QuotingToolHelper.saveApplicationQuoting(quoting);

	}	
    public static void applicationQuotingBOQ(Boolean isConsumer) {
		quoting = new Application_Quoting__c();
		createApplication();
		createAssetDetailLTV();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
		quoting.Opportunity__c = tstOpportunity.Id;
		//Lender

		//Vehicle Details
		quoting.Vehicle_Detail_State__c = 'NSW';
		if (isConsumer) {
			quoting.Name = 'BOQConsumerExtension.LENDER_QUOTING';
			quoting.Loan_Product__c = 'Consumer Loan';
			quoting.Goods_type__c = 'MOTOV';
			quoting.Goods_sub_type__c = 'MOTOV_CARS_-_OTHER_CARS_AU';
		} else {
			// quoting.Name = BOQCommercialExtension.LENDER_QUOTING;
      quoting.Name = 'BOQCommercial';
			quoting.Loan_Product__c = 'Chattel Mortgage-Full-Doc';
			quoting.Goods_type__c = 'Earthmoving';
			quoting.Goods_sub_type__c = 'LIFES_MOTORCYCLES_&_SCOOTERS_AU';
		}

		quoting.Loan_Type__c = 'Refinance';
		quoting.Loan_Frequency__c = 'MONTHLY';
		quoting.Vehicle_Price__c = 2500;
		quoting.Deposit__c = 1000;
		quoting.Trade_In__c = 2;
		quoting.Payout_On__c = 50;
		quoting.Residual_Value_Percentage__c = 20;
		quoting.Residual_Value_Percentage__c = 20;

		quoting.Insurance_GAP_Retail_Price__c = 100;
		quoting.Insurance_Warranty_Retail_Price__c = 100;
		quoting.Insurance_LTI_Retail_Price__c = 100;
		quoting.Insurance_TAI_Retail_Price__c = 100;
		quoting.Insurance_MV_Retail_Price__c = 100;
		quoting.Term__c = 36;
        quoting.Residual_Value__c = 2000;
		quoting.Application_Fee__c = 50;
		//Save the record
		QuotingToolHelper.saveApplicationQuoting(quoting);

	}

	//Lelo            2017/06/14
	public static void createQuote() {
		if (tstApp == null || tstApp.Id == null) {
			createApplication();
		}
		quote = new Application_InsuranceQuote__c();
		quote.Application__c = tstApp.Id;
		quote.Name = tstOpportunity.Name;
		insert quote;
	}
	//-
	//Lelo            2017/06/14
	public static void createQuoting() {
		if (tstApp == null || tstApp.Id == null) {
			createApplication();
		}
		quoting = new Application_Quoting__c();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
		quoting.Opportunity__c = tstOpportunity.Id;
		quoting.Name = 'Pepper MV';
		insert quoting;
	}

	//Lelo            2017/06/19
	public static void createQuoteMainDriver() {
		if (tstApp == null || tstApp.Id == null) {
			createApplication();
		}
		if (quote == null) {
			createQuote();
		}

		mainDriver = new Application_Additional_Driver__c();
		mainDriver.Application__c = tstApp.Id;
		mainDriver.Year_First_Licence__c = 2010;
		mainDriver.RecordTypeId = getRecordTypes('Main Driver');
		mainDriver.Gender__c = 'Male';
		mainDriver.Status__c = 'Active';
		mainDriver.Date_of_Birth__c = Date.today();
		mainDriver.Occupation__c = 'XXXXXX';
		mainDriver.Address_Line_1__c = 'WERWERWERWE';
		mainDriver.Address_Line_2__c = 'WEWEWEWEWW';
		mainDriver.Mobile__c = '45464';
		mainDriver.Home_Phone__c = '34232';
		mainDriver.Work_Phone__c = '2342342';
		mainDriver.ABN__c = '432423';

		// 2019-05-17
		mainDriver.Title__c = 'Mr';
		mainDriver.First_Name__c = 'John';
		mainDriver.Last_Name__c = 'Doe';
		mainDriver.Email__c = 'john.d@savvy.com.au';
		mainDriver.Driver_Licence__c = '123456789';
		mainDriver.Time_Last_Fault_Accident__c = 'NeverHadAnAccident';



		insert mainDriver;

		Quote_Additional_Driver__c q = new Quote_Additional_Driver__c();
		q.Application_Additional_Driver__c = mainDriver.Id;
		q.Application_Insurance_Quote__c = quote.Id;

		insert q;

	}

	public static void createQuoteAdditionalDriver() {
		if (tstApp == null || tstApp.Id == null) {
			createApplication();
		}
		if (quote == null) {
			createQuote();
		}

		otherDriver = new Application_Additional_Driver__c();
		otherDriver.Application__c = tstApp.Id;
		otherDriver.Year_First_Licence__c = 2010;
		otherDriver.RecordTypeId = getRecordTypes('Additional Driver');
		otherDriver.Gender__c = 'Male';
		otherDriver.Status__c = 'Active';
		otherDriver.Date_of_Birth__c = Date.today();
		otherDriver.Occupation__c = 'XXXXXX';
		otherDriver.Address_Line_1__c = 'WERWERWERWE';
		otherDriver.Address_Line_2__c = 'WEWEWEWEWW';
		otherDriver.Mobile__c = '45464';
		otherDriver.Home_Phone__c = '34232';
		otherDriver.Work_Phone__c = '2342342';
		otherDriver.ABN__c = '432423';
		otherDriver.First_Name__c = 'Fercho';
		otherDriver.Last_Name__c = 'Rosas';
		otherDriver.Title__c = 'Mr';

		insert otherDriver;

		Quote_Additional_Driver__c q = new Quote_Additional_Driver__c();
		q.Application_Additional_Driver__c = otherDriver.Id;
		q.Application_Insurance_Quote__c = quote.Id;

		insert q;

	}
	//-

	public static Id getRecordTypes(String code) {
		loadRecordTypes();
		return recordTypeMap.get(code);
	}

	public static void loadRecordTypes() {
		if (recordTypeMap == null) {
			recordTypeMap = new Map < String,
			Id > ();
			List < RecordType > productTypes = [SELECT Id, Name FROM RecordType];
			for (RecordType rt: productTypes) {
				recordTypeMap.put(rt.Name, rt.Id);
			}
		}
	}

	public static void createAssets() {
		createAssetPropertie();
		createAssetVehicle();
		createOtherAsset();
	}

	public static void createAssetPropertie() {
		if (tstApp != null) {
			Application_Other_Asset__c a = new Application_Other_Asset__c(
				RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(
					ApplicationService.PROPERTY_ASSET_TYPE));
			a.Description__c = '1 | 6 | Kopoola | Crescent | Gilles Plains |NSW| 5086';
			a.Value__c = 1200000;
			a.Has_Loan__c = 'Y';
			a.Lender__c = 'My lender';
			a.Amount_Owing__c = 1000000;
			a.Payment__c = 500;
			a.Frequency__c = 'Weekly';
			a.Application__c = tstApp.Id;
			insert a;
		}
	}

	public static void createAssetVehicle() {
		if (tstApp != null) {
			Application_Other_Asset__c a = new Application_Other_Asset__c(
				RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(
					ApplicationService.VEHICLE_ASSET_TYPE));
			a.Description__c = 'XXX000';
			a.Value__c = 12000;
			a.Has_Loan__c = 'Y';
			a.Lender__c = 'My lender';
			a.Amount_Owing__c = 10500;
			a.Payment__c = 250;
			a.Frequency__c = 'Weekly';
			a.Application__c = tstApp.Id;
			insert a;
		}
	}

	public static void createOtherAsset() {
		if (tstApp != null) {
			Application_Other_Asset__c a = new Application_Other_Asset__c(
				RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(
					ApplicationService.OTHER_ASSET_TYPE));
			a.Description__c = 'Other Asset 1';
			a.Value__c = 12000;
			a.Application__c = tstApp.Id;
			insert a;
		}
	}

	public static void createPreviousEmployment() {
		if (tstApp != null) {
			Application_Employment__c a = new Application_Employment__c();
			a.Application__c = tstApp.Id;
			a.Applicant__c = '1';
			a.Country__c = 'AUS';
            a.Street_Number__c = '12';
            a.Work_Address__c = 'PreviousADD_12';
            a.Employment_Type__c = 'Contract';
            a.Start_Date__c = DateUtils.convertToDate('01/10/2017');
            a.Finish_Date__c = DateUtils.convertToDate('27/03/2018');
            
            a.Applicant__c = '2';
			a.Country__c = 'AUS';
            a.Street_Number__c = '12';
            a.Work_Address__c = 'PreviousADD_12';
            a.Employment_Type__c = 'Contract';
            a.Start_Date__c = DateUtils.convertToDate('01/10/2017');
            a.Finish_Date__c = DateUtils.convertToDate('27/03/2018');
			insert a;
		}
	}

	public static void createQuoteAnnotations() {
		if (quote == null) {
			createQuote();
		}		
		if (mainDriver == null) {
			createQuoteMainDriver();
		}
		if (RecordTypes == null) {
			recordTypes();
		}
		// Motoring Offences
		List<Insurance_Quote_Annotation__c> annList = new List<Insurance_Quote_Annotation__c>();

		Insurance_Quote_Annotation__c a = new Insurance_Quote_Annotation__c(RecordTypeId = recordTypes.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE));
		a.Insurance_Quote__c = quote.Id;
		a.Driver__c = mainDriver.Id;
		a.Date__c = Date.today();
		a.Detail__c = 'details';
		a.Number__c = 1;
		annList.add(a);

		a = new Insurance_Quote_Annotation__c(RecordTypeId = recordTypes.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE));
		a.Insurance_Quote__c = quote.Id;
		a.Driver__c = mainDriver.Id;
		a.Date__c = Date.today();
		a.Detail__c = 'details';
		a.Number__c = 1;
		annList.add(a);

		a = new Insurance_Quote_Annotation__c(RecordTypeId = recordTypes.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE));
		a.Insurance_Quote__c = quote.Id;
		a.Driver__c = mainDriver.Id;

		a.Date__c = Date.today();
		a.Detail__c = 'details';
		a.Amount__c = 1500;
		a.Is_Driver_Fault__c = 'Y';
		a.Was_Vehicle_Affected__c = 'N';
		a.Name_Insurer__c = 'Insurer';
		annList.add(a);

		insert annList;
	}
    
    public static void createInvoice(){
        if (RecordTypes == null) {
            recordTypes();
        }
    }
    
    public static void createXeroOnlineInvoices() {
		tstXeroOnlineInvoices = new XeroOnlineInvoices('https://api.xero-test.com/');
	}
	
    public static void createGlassMake(){
        tstGlassMake = new Glass_Make__c(Code__c = 'AUD', New_Years__c = '23/06/2018', Used_Years__c = '23/06/2018');
        insert tstGlassMake;
    }

    public static void createGlassModel(){
        createGlassMake();
        tstGlassModel = new Glass_Model__c(Code__c = '0000', Make__c = tstGlassMake.Id, New_Years__c = '23/06/2018');
        insert tstGlassModel;
    }
    
    public static void createGlassVariant(){
        createGlassModel();
        tstGlassVariant = new Glass_Variant__c(Code__c = '0000', Make__C = tstGlassMake.Code__c, Model__c = tstGlassModel.Id, Family__c = 'Series');
        insert tstGlassVariant;
    }
    
    public static void reloadAssetDetailLTV(){
        	asset = [Select Id, Type__c, Condition__c, Lender__c, Type_Loan__c, Make__c, 
                     Variant__c, Model__c, Rego__c, Rego_State__c, 
                     VIN__c, Actual_KM__c, Year__c, Fees__c, Series__c, Redbook_key__c 
                     From Application_Asset_Detail__c 
                     Where Id =:asset.Id
                    ];
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
   
   	public static void applicationQuotingAndProduct() {
		quoting = new Application_Quoting__c();
		createApplication();
		createAssetDetailLTV();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
		quoting.Opportunity__c = tstOpportunity.Id;
		//Lender

		//Vehicle Details
        quoting.Vehicle_Detail_State__c = 'NSW';
        quoting.Name = 'Prospa';
        quoting.Loan_Product__c = 'Consumer Loan';
        quoting.Goods_type__c = 'MOTOV';
        quoting.Goods_sub_type__c = 'MOTOV_CARS_-_OTHER_CARS_AU';
        QuotingToolHelper.saveApplicationQuoting(quoting);
		
        recordTypes();
        tstFinanceProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'), Opportunity_Name__c = tstOpportunity.Id, End_of_Loan_Date__c = Date.today().addDays(60), DOF__c = 1, Brokerage__c = 1);
        insert tstFinanceProduct;
        
        tstOpportunity.Loan_Product__c = tstFinanceProduct.Id;
        update tstOpportunity;
	}
    
    public static void createApplicationLoan(){
        createApplication();
        tstAppLoan = new Application_Loan__c();
        tstAppLoan.Amount_Owing__c = 2.00;
        tstAppLoan.Frequency__c = 'Fortnightly';
        tstAppLoan.Good_Conduct__c = 'Y';
        tstAppLoan.Is_Payout__c = true;
        tstAppLoan.Lender__c = 'Money3';
        tstAppLoan.Paid_On_Time__c = 'Y';
        tstAppLoan.Payment__c = 20000;
        tstAppLoan.Type__c = 'Payday Loan';
        tstAppLoan.Application__c = tstApp.Id;
        tstAppLoan.Order__c = 2;
        insert tstAppLoan;
    }
    
    public static void createApplicationYTD() {
        tstAppYTD = new Application_YTD__c();
        tstAppYTD.Type__c = 'Pepper';
        tstAppYTD.Start_Date_1__c = Date.valueOf('2019-12-30');
        tstAppYTD.End_Date_1__c = Date.valueOf('2019-12-31');
        tstAppYTD.Weeks_1__c = 1;
        tstAppYTD.Income_1_1__c = 10000.00;
        tstAppYTD.Income_1_2__c = 10000.00;
        tstAppYTD.Difference_1__c = 10000.00;
        tstAppYTD.Discounted_1__c = 10000.00;
        tstAppYTD.Monthly_Amount_Servicing_1__c = 10000.00;
        tstAppYTD.Income_Monthly_1_1__c = 10000.00;
        tstAppYTD.Income_Monthly_1_2__c = 10000.00;
        tstAppYTD.Comment_1__c = 'c';
        tstAppYTD.Latest_Payment_1__c = 10000.00;
        tstAppYTD.Latest_Payment_Frequency_1__c = 'Weekly';
        tstAppYTD.Start_Date_2__c = Date.valueOf('2019-12-30');
        tstAppYTD.End_Date_2__c = Date.valueOf('2019-12-31');
        tstAppYTD.Weeks_2__c = 1;
        tstAppYTD.Income_2_1__c = 10000.00;
        tstAppYTD.Income_2_2__c = 10000.00;
        tstAppYTD.Difference_2__c = 10000.00;
        tstAppYTD.Discounted_2__c = 10000.00;
        tstAppYTD.Monthly_Amount_Servicing_2__c = 10000.00;
        tstAppYTD.Income_Monthly_2_1__c = 10000.00;
        tstAppYTD.Income_Monthly_2_2__c = 10000.00;
        tstAppYTD.Comment_2__c = 'c';
        tstAppYTD.Latest_Payment_2__c = 10000.00;
        tstAppYTD.Latest_Payment_Frequency_2__c = 'Weekly';
        insert tstAppYTD;
        tstOpportunity.ApplicationYTD__c = tstAppYTD.Id;
        update tstOpportunity;
    }
    
    public static void createQuoting(String name) {
		if (tstApp == null || tstApp.Id == null) {
			createApplication();
            tstApp.Status__c = 'F';
            update tstApp;
		}
		quoting = new Application_Quoting__c();
		//Associate Application / Opportunity
		quoting.Application__c = tstOpportunity.Application__c;
		quoting.Opportunity__c = tstOpportunity.Id;
		quoting.Name = name;
		insert quoting;
	}

  public static User buildPartnerUser() {
    Id recType = SOQLSingletonQueries.recs()
      .recordTypes.get('Broker Partner');
    Account a = new Account(
      Name = 'Test Business Account',
      S3_Folder__c = 'testfolder',
      RecordTypeId = recType
    );
    insert a;
    Contact c = new Contact(LastName = 'Montoya');
    c.AccountId = a.Id;
    insert c;
    String username = 'newone-123456789@noemail.com';
    System.runAs(new User(Id = UserInfo.getUserId())) {
      // UserRole r = [select id from UserRole where name = 'CEO'];
      // UserLicense licence = [SELECT Id FROM UserLicense where name ='Partner Community'];

      Profile p = [SELECT Id FROM Profile WHERE Name = 'Broker Community User'];
      User comUser = new User(
        alias = 'test123',
        email = 'test123@noemail.com',
        emailencodingkey = 'UTF-8',
        lastname = 'Testing',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US',
        profileid = p.Id,
        country = 'United States',
        IsActive = true,
        contactId = c.Id,
        timezonesidkey = 'America/Los_Angeles',
        username = username
      );
      insert comuser;
    }
    User u = [SELECT id FROM user WHERE username = :username LIMIT 1];
    return u;
  }

  // Lelo
  public static Account buildAcc() {
		recordTypes();
		tstAccount = new Account(
      RecordTypeId = recordTypes.get('Person Account'), 
      FirstName = 'Tony', 
      LastName = 'Stark', 
      PersonOtherState = 'SA', 
      PersonEmail = 'qa-tony.s@savvy.com', 
      PersonMobilePhone = '0474654321'
    );
		insert tstAccount;
    return tstAccount;
	}

  public static Custom_Opportunity__c buildOpp(Boolean freshCopy) {
		if (tstOpportunity == null || freshCopy) {
			buildAcc();
			// createLead();
			tstOpportunity = new Custom_Opportunity__c(
        Account__c = tstAccount.Id, 
        OwnerId = UserInfo.getUserId(), 
        Status__c = 'Become Opportunity', 
        First_Name__c = tstAccount.Firstname, 
        Last_Name__c = tstAccount.LastName, 
        Mobile_Number__c = tstAccount.PersonMobilePhone, 
        Email_Address__c = tstAccount.PersonEmail
			);
			insert tstOpportunity;
		}
    return tstOpportunity;
	}

  public static Application__c buildCarApp(Boolean freshCopy) {
    return buildApp('Personal', 'Car', 1, freshCopy);
  }

  /*******************************************************************************************************
    * @author Lelo
    * @description Crteate an application object
    * @param appType Application Type: Personal / Business
    * @param assetType Application Type: Car / Personal / Truck / Caravan / Boat / Motorbike
    * @param noApplicants number of people into the application: 1 / 2
    * @param freshCopy create a new object
    * @return an application object
    */
  public static Application__c buildApp(String appType, String assetType, Integer noApplicants,  Boolean freshCopy) {
    recordTypes();
    Custom_Opportunity__c o = buildOpp(freshCopy);
    if (tstApp == null || freshCopy) {
      Application__c a = new Application__c();
      List<Application_Employment__c> employs = new List<Application_Employment__c>();
      a.Account__c = o.Account__c;
      a.Status__c = 'F';
      a.Repayment_Regularity__c = 'Month';
      a.No_of_People__c = noApplicants;
      a.Application_Type__c = appType;
      a.Type_of_Asset__c = assetType;
      a.Finance_Amount__c = 27000;
      a.Length_of_Term__c = 5;

      if ('Car'.equals(assetType)) {
        // VehicleDetails
        a.Vehicle_Make__c = 'MAZDA';
        a.Vehicle_Model__c = '3';
        a.Vehicle_Year__c = String.valueOf(Date.today().year() - 1);
        // Loan Details
        a.Purchase_Price__c = 35000;
        a.Preferred_Repayment__c = 350;
      } else if ('Personal'.equals(assetType)) {
        a.Loan_For__c = 'Education';
      } else {
        a.Application_Type__c = 'Business';
      }

      if ('Business'.equals(a.Application_Type__c)) {
        a.Entity_Name__c = 'QA Company Pty';
        a.Business_ABN__c = '52 653 456 311';
        a.Business_ACN__c = '731 866 381';
        a.Business_Structure__c = 'Company';
        a.Trading_Name__c = 'QA Company Pty';
        a.Trust_Name__c = 'QA Company Pty';
        a.Trading_Address__c = '3 South Tce, Adelaide, SA 5000';

        a.Nature_of_Business__c = 'Financial Serivces';
        a.No_of_Directors__c = 1;
        a.Accountant_Name__c = 'Marcelo Gallo';
        a.Accountant_Phone__c = '0450 125 458';
        a.Estimated_profit_per_annum__c = 5850000.00;
        a.Time_In_Business__c = '3+';
        a.Annual_Revenue__c = '$1,000,000 - $2,000,000';
      }

      // Applicant 1 - Details
      a.Name = o.First_Name__c + ' ' + o.Last_Name__c;
      a.Title_1__c = 'Mr';
      a.First_Name__c = o.First_Name__c;
      a.Middle_Name__c = null;
      a.Last_Name__c = o.Last_Name__c;
      a.Date_of_Birth_1__c = '17/07/1987';
      a.Gender_1__c = 'M';
      a.Current_Residential_Status_1__c = 'Australian Citizen';

      a.Credit_Status_1__c = 'Excellent';
      a.Do_you_have_drivers_licence_1__c = 'Yes';
      a.Drivers_License_1__c = 'XXX45874';
      a.Type_of_Licence_1__c = 'FULL';
      a.Expiry_Date_1__c = '10/04/' + (Date.today().year() + 7);
      a.Driver_Licence_State_Issue_1__c = 'SA';
      a.Year_First_Licensed_1__c = 2007;
      a.Time_Last_Fault_1__c = 'NeverHadAnAccident';
      a.Marital_Status_1__c = 'Single';
      a.No_of_Dependants_1__c = 0;
      a.Ages_of_Dependants_1__c = null;
      a.Home_Phone__c = '8 8524 5658';
      a.Work_Phone__c = '132 524';
      a.Mobile_Number__c = o.Mobile_Number__c;
      a.Email_Address__c = o.Email_Address__c;
      
      // Current Address
      a.Unit_Number__c = '5';
      a.Street_Number__c = '45';
      a.Street_Address__c = 'Hutt';
      a.Street_Type__c = 'ST';
      a.Postcode__c = '5000';
      a.Suburb__c = 'Adelaide';
      a.State__c = 'SA';
      a.Date_Moved_in_1__c = '21/03/' + (Date.today().year() - 2);
      a.Current_Residence_Status_1__c = 'Renting(Agent)';

      a.Rent_per_month_1__c = 450.00;
      a.Residential_Payment_Frequency_1__c = 'Weekly';
      a.Landlord_Name_1__c = 'Real Estate';
      a.Landlord_Phone_1__c = '8 1541 8522';

      // Previous Address
      a.Previous_Country_1__c = 'AUS';
      a.Previous_Unit_Number_1__c = '4';
      a.Previous_Street_Number_1__c = '415';
      a.Previous_Street_Address_1__c = 'Hammer';
      a.Previous_Street_Type_1__c = 'ST';
      a.Previous_Suburb_1__c = 'Enfield';
      a.Previous_State_1__c = 'SA';
      a.Previous_Postcode_1__c = '5085';
      a.Date_From_1__c = '08/012/' + (Date.today().year() - 6);

      // Current Employment
      a.Mode_of_Employment_1__c = 'Full Time';
      a.Current_Employer_Name_1__c = 'QA Current Employer';
      a.Current_Employer_Phone_1__c = '132 458';
      a.Current_Occupation_1__c = 'Coder';
      a.Reference_Name_1__c = 'The Boss';
      a.Date_Started_1__c = '05/11/' + (Date.today().year() - 2);
      a.Net_Income_1__c = 7800.00;
      a.Payment_Frequency_1__c = 'Monthly';

      // Address
      a.Current_Work_Unit_Number_1__c = '1';
      a.Current_Work_Street_Number_1__c = '145';
      a.Current_Work_Address_1__c = 'Angas';
      a.Current_Work_Street_Type_1__c = 'ST';
      a.Current_Work_Suburb_1__c = 'Norwood';
      a.Current_Work_Postcode_1__c = '5067';
      a.Current_Work_State_1__c = 'SA';
      // Previous Employment
      a.Previous_Work_Country_1__c = 'AUS';
      a.Previous_Mode_of_Employment_1__c = 'Part Time';
      a.Previous_Employer_Name_1__c = 'QA Other Employer';
      a.Previous_Employer_Phone_1__c = '132 458';
      a.Previous_Occupation_1__c = 'Developer';
      a.Previous_Reference_Name_1__c = 'Other Boss';
      a.Start_Date_1__c = '01/09/' + (Date.today().year() - 5);
      a.Finish_Date_1__c = '04/11/' + (Date.today().year() - 2);

      // Savings
      a.Bank_Value__c = 45000;
      a.Bank_Name__c = '3W BANK';
      a.Super_Value_How_Much__c = 450000;
      a.Furniture_Value__c = 120000;

      // Living Expenses
      a.Basic_Living_Expenses_Per_Month__c = '1000';
      a.Childcare_Child_Maintenance_Per_Month__c = '700';
      a.Mobile_Phone_Internet_Pay_TV_per_Month__c = '600';
      a.Insurance_Expenses_per_Month__c = '500';
      a.Travel_Transport_Expenses_per_Month__c = '400';
      a.Other_Expenses_per_Month__c = '300';
      a.Income_Type_Expenses__c = 'more expeses';
      // Personal Referemnces
      a.Personal_Reference_1_Full_Name__c = 'Black Bear';
      a.Personal_Reference_1_Relationship__c = 'Friend';
      a.Personal_Reference_1_Address__c = '3 Gills St, Adelaide, SA 5000';
      a.Personal_Reference_1_Phone__c = '0452 125 478';

      a.Personal_Reference_2_Full_Name__c = 'White Fox';
      a.Personal_Reference_2_Relationship__c = 'Friend';
      a.Personal_Reference_2_Address__c = '56 King St, Adelaide, SA 5000';
      a.Personal_Reference_2_Phone__c = '0444 789 871';

      // Declaration
      a.Do_you_expect_any_change_to_your_financi__c = 'No';
      a.Is_There_Anything_You_Want_to_Tell_Us__c = null;

      insert a;
      // Application details
      // Employment
      Application_Employment__c e = new Application_Employment__c();
      e.Application__c = a.Id;
      e.Applicant__c = '1';
      e.Country__c = 'AUS';
      e.Employment_Type__c = 'Self Employed';
      e.Employer_Name__c = 'QA More Employer';
      e.Phone__c = '8 4525 8547';
      e.Occupation__c = 'Programmer';
      e.Contact_Name__c = 'Boris Pacheco';
      e.Start_Date__c = Date.today() - (365 * 7) ;
      e.Finish_Date__c = Date.today() - (365 * 6) ;
      // Address
      e.Postcode__c = '5025';
      e.Unit_Number__c = '6';
      e.Street_Number__c = '123';
      e.Work_Address__c = 'The';
      e.Street_Type__c = 'PDE';
      e.Suburb__c = 'Norwood';
      e.State__c = 'SA';
      employs.add(e);
      //

      // Other incomes
      List<Application_Income__c> incomes = new List <Application_Income__c>();
      Set<String> tmp = new Set<String>{
        'Rental Income', 'Investment Income', 'Maintenance', 'Second Job'
      };
      for (String t: tmp) {
        Application_Income__c oi = new Application_Income__c();
        oi.Application__c = a.Id;
        oi.Applicant__c = '1';
        oi.Type__c = t;
        oi.Income__c = 100 + (incomes.size() * 10);
        oi.Frequency__c = Math.mod(incomes.size(),2) == 0? 'Monthly' : 'Weekly';
        oi.Order__c = incomes.size() + 1;
        incomes.add(oi);
      }
      // Other Assets
      List<Application_Other_Asset__c> assets = new List<Application_Other_Asset__c>();
      // Other properties
      Application_Other_Asset__c oa = new Application_Other_Asset__c();
      oa.Application__c = a.Id;
      oa.RecordTypeId = recordTypes.get('Property Asset');
      oa.Description__c = '3 Black ST, Adelaide, SA 5000';
      oa.Value__c = 1500000;
      oa.Has_Loan__c = 'Y';
      oa.Lender__c = 'Lender A';
      oa.Amount_Owing__c = (oa.Value__c * 0.70).SetScale(2);
      oa.Payment__c = (oa.Amount_Owing__c * 0.005).SetScale(2);
      oa.Frequency__c = 'Monthly';
      assets.add(oa);
      // Other Vehicles
      oa = new Application_Other_Asset__c();
      oa.Application__c = a.Id;
      oa.RecordTypeId = recordTypes.get('Vehicle Asset');
      oa.Description__c = 'XXX 999';
      oa.Value__c = 17500;
      oa.Has_Loan__c = 'Y';
      oa.Lender__c = 'Lender B';
      oa.Amount_Owing__c = (oa.Value__c * 0.70).SetScale(2);
      oa.Payment__c = (oa.Amount_Owing__c * 0.005).SetScale(2);
      oa.Frequency__c = 'Weekly';
      assets.add(oa);
      // Other Assets
      oa = new Application_Other_Asset__c();
      oa.Application__c = a.Id;
      oa.RecordTypeId = recordTypes.get('Other Asset');
      oa.Description__c = 'Boat Yamaha';
      oa.Value__c = 145000;
      assets.add(oa);

      // Loans
      List<Application_Loan__c> loans = new List<Application_Loan__c>();
      tmp = new Set<String>{
        'Debt/Default Arrangements', 'Personal Loan', 'Payday Loan', 
        'Line of Credit', 'Other'
      };
      for (String t: tmp) {
        Application_Loan__c lo = new Application_Loan__c();
        lo.Type__c = t;
        lo.Application__c = a.Id;
        lo.Lender__c = 'Lender ' + loans.size();
        lo.Amount_Owing__c = 10000 + (loans.size() * 1000);
        lo.Payment__c = 200 + (loans.size() * 30);
        lo.Frequency__c = Math.mod(loans.size(),2) == 0? 'Fortnightly' : 'Weekly';
        lo.Order__c = loans.size() + 1;
        loans.add(lo);
      }
      // Credit cards
      List<Application_Credit_Card__c> ccs = new List<Application_Credit_Card__c>();
      tmp = new Set<String>{
        'Lender A1', 'Lender B2', 'Lender C3'
      };
      for (String t: tmp) {
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        c.Issuer__c = t;
        c.Application__c = a.Id;
        c.Limit__c = 10000 + (loans.size() * 10000);
        c.Amount_Owing__c = (c.Limit__c * 0.70).SetScale(2);
        ccs.add(c);
      }

      // Storing details
      insert employs;
      insert incomes;
      insert loans;
      insert assets;
      insert ccs;

      tstApp = a;

    }
    o.Application__c = tstApp.Id;
    update o;    
    return tstApp;
  }
  
  public static Application_Employment__c createSecondJob(Id appId, String applicant) {
		Application_Employment__c r = new Application_Employment__c(
      Type__c = 'Second Job', 
      Applicant__c = applicant, 
      Application__c = appId);
		insert r;
    return r;
	}

  public static List<Cloud_Documents__c> buildCloudDocuments(Id oppId, List<String> docTypes) {
    List<Cloud_Documents__c> docs = new List<Cloud_Documents__c>();
    for (String doc: docTypes) {
      Cloud_Documents__c c = new Cloud_Documents__c();
      c.Name = 'Doc name';
      c.Bucket_Name__c = 'bucket';
      c.Custom_Opportunity__c = oppId;
      c.Access_Level__c = 'private';
      c.File_Name__c = 'fileName';
      c.Folder_Id__c = 's3FileObject';
      c.Document_Type__c = doc;
      docs.add(c);
    }
    insert docs;
    return docs;
  }

  public static Partner_API_Setting__c createPartnerAPISetting(
    String recType, 
    String provider, 
    Id accountId
  ) {
    recordTypes();
    Id recTypeId = recordTypes.get(recType);
    Partner_API_Setting__c rec = new Partner_API_Setting__c();
    rec.RecordTypeId = recTypeId;
    rec.Provider__c = provider;
    rec.Account__c = accountId;
    insert rec;
    return rec;
  }

  public static Lender_Login__c createLenderLogin(String lender, String userLogin, Id ownerId) {
    Lender_Login__c rec = new Lender_Login__c();
    rec.Lender__c = lender;
    rec.User_Name__c = userLogin;
    rec.Password__c = '****';
    rec.OwnerId = ownerId;
    insert rec;
    return rec;
  }

  public static void createPartnerAPISettings() {
    List<Partner_API_Setting__c> apiList = new List<Partner_API_Setting__c>();
    Partner_API_Setting__c a = null;
    // Pepper
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('OAuth');
    a.Provider__c = APIServiceManager.API_LENDER_PEPPER;
    a.Client_ID__c = 'ABC***********';
    a.Client_Secret__c = 'XYZ**********';
    a.Partner_ID__c = 'MYPARTNERID';
    apiList.add(a);
    // Latitude
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('OAuth');
    a.Provider__c = APIServiceManager.API_LENDER_LATITUDE;
    a.Client_ID__c = 'ABC***********';
    a.Client_Secret__c = 'XYZ**********';
    a.Partner_ID__c = 'MYPARTNERID';
    apiList.add(a);
    // Finance One
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Token');
    a.Provider__c = APIServiceManager.API_LENDER_FINANCEONE;
    a.Token__c = 'ABCDEFGXXXXXXXXXXXXXXXXXXXXXX';
    apiList.add(a);
    // Money3
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Token + Partner ID');
    a.Provider__c = APIServiceManager.API_LENDER_MONEY3;
    a.Token__c = '123456789XXXXXXXXXXXXXXXXXXXXX';
    apiList.add(a);
    // Eric
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Password Ext.');
    a.Provider__c = APIServiceManager.API_INSURER_ERIC;
    a.Username__c = 'ABC***********';
    a.Password__c = 'XYZ**********';
    a.User_ID__c = 'MYPARTNERID';
    a.Partner_ID__c = 'MYPARTNERID';
    a.Partner_Name__c = 'SF PARTNER';
    apiList.add(a);
    // Equifax
    a = new Partner_API_Setting__c();
    a.RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Password Ext. II');
    a.Provider__c = APIServiceManager.API_PROVIDER_EQUIFAX;
    a.Username__c = 'ABC***********';
    a.Password__c = 'XYZ**********';
    a.Limit__c = 10;
    apiList.add(a);

    insert apiList;
  }

}