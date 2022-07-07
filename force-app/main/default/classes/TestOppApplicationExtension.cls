@isTest(SeeAllData=true)
public class TestOppApplicationExtension {

    public static testMethod void myUnitTest(){
        //setupTestData();
		//getStaticResourceMock();
        
        Test_DataGeneratorHelper.createOpportunity();
        
        //Test_DataGeneratorHelper.createProduct();
        
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        myPageConta.AppPdf();
        
        ApexPages.StandardController ap = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageCont = new OppApplicationExtension(ap);
        myPageCont.applicationType = 'Business';
        myPageCont.app0.Business_Structure__c = 'Company';
        myPageCont.acn = 'my';
        myPageCont.AppPdf();
        
        ApexPages.StandardController apex = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageContac = new OppApplicationExtension(apex);
        myPageContac.applicationType = 'Business';
        myPageContac.app0.Business_Structure__c = 'Company';
        myPageContac.AppPdf();

        Application__c appl = new Application__c();
        appl.Business_Structure__c = 'Company';
        appl.Email_Address__c = 'AAA@gma.com';
        appl.First_Name__c = 'BBB';
        appl.Last_Name__c = 'CCC';
        appl.Mobile_Number__c = 'DDD';
        insert appl;        
        Test_DataGeneratorHelper.tstApp = appl;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = appl.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.StandardController apexC = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageContact = new OppApplicationExtension(apexC);
        myPageContact.applicationType = 'Business';
        myPageContact.currentResidentialStatus1 = 'PR VISA';
        myPageContact.haveDriverLicence1 = 'Yes';
        myPageContact.AppPdf();
       
        //------------ This code is to test the block section from 3058 to 3066 
        //But it doesnt work because the rule (!isNewApplication...)
        Application__c appli = new Application__c();
        appli.Business_Structure__c = 'Company';
        appli.Email_Address__c = 'AAA@gma.com';
        appli.First_Name__c = 'BBB';
        appli.Last_Name__c = 'CCC';
        appli.Mobile_Number__c = 'DDD';
        insert appli;        
        Test_DataGeneratorHelper.tstApp = appli;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = appli.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        ApexPages.StandardController apexCo = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageContactC = new OppApplicationExtension(apexCo);
        myPageContactC.applicationType = 'Business';
        myPageContactC.app0.Business_Structure__c = 'Partnership';
        myPageContactC.AppPdf();
        
        //-------------------------------------------------------------------
        
        //ApexPages.StandardController apexCon = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        //OppApplicationExtension myPageContactCo = new OppApplicationExtension(apexCon);
        //myPageContactCo.applicationType = 'Car';
        //myPageContactCo.app0.Business_Structure__c = 'Company';
        //myPageContactCo.AppPdf();
        
        Application__c app = new Application__c();
        app.Accountant_Name__c = 'a';
        app.Accountant_Phone__c = 'a';
        app.Business_Structure__c = 'Company';
        app.Ages_of_Dependants_1__c = 'a';
        app.Ages_of_Dependants_2__c = 'a';
        app.Applicant_2_living_in_the_same_address__c = 'a';
        app.Application_Type__c ='a';
        app.Bank_Name__c = 'a';
        app.Bank_Value__c = 0;
        app.Business_ABN__c = 'a';
        app.Business_ACN__c = 'a';
        app.Current_Employer_Name_1__c = 'a';
        app.Current_Employer_Name_2__c = 'a';
        app.Current_Employer_Phone_1__c = 'a';
        app.Current_Employer_Phone_2__c = 'a';
        app.Current_Occupation_2__c = 'a';
        app.Current_Residence_Status_1__c ='a';
        app.Current_Residence_Status_2__c ='a';
        app.Current_Work_Address_1__c = 'a';
        app.Current_Work_Address_2__c = 'a';
        app.Date_From_1__c = 'a';
        app.Date_From_2__c = 'a';
        app.Date_Moved_in_1__c = 'a';
        app.Date_Moved_in_2__c = 'a';
        app.Date_of_Birth_1__c = 'a';
        app.Date_of_Birth_2__c = 'a';
        app.Date_Started_1__c = 'a';
        app.Date_Started_2__c = 'a';
        app.Do_you_have_any_credit_cards__c = 'a';
        app.Do_you_have_any_loans_outstanding__c = 'a';
        app.Do_you_have_drivers_licence_1__c = 'a';
        app.Do_you_have_drivers_licence_2__c = 'a';
        app.Do_you_own_a_motor_vehicle__c = 'a';
        app.Do_you_receive_other_income_1__c = 'a';
        app.Drivers_License_1__c = 'a';
        app.Drivers_License_2__c = 'a';
        app.Email_Address_2__c = 'a@test.com';
        app.Employed_for_more_than_two_years_1__c = 'a';
        app.Employed_for_more_than_two_years_2__c = 'a';
        app.Entity_Name__c = 'a';
        app.Estimated_profit_per_annum__c = 0;
        app.Expiry_Date_1__c = 'a';
        app.Expiry_Date_2__c = 'a';
        app.Finance_Amount__c = 0;
        app.Finish_Date_1__c = 'a';
        app.Finish_Date_2__c = 'a';
        app.First_Name_2__c = 'a';
        app.Furniture_Value__c = 0;
        app.Home_Phone__c = 'a';
        app.Home_Phone_2__c = 'a';
        app.Landlord_Name_1__c = 'a';
        app.Landlord_Name_2__c = 'a';
        app.Landlord_Phone_1__c = 'a';
        app.Landlord_Phone_2__c = 'a';
        app.Last_Name_2__c = 'a';
        app.Length_of_Term__c = 0;
        app.Living_more_than_three_years_1__c = 'a';
        app.Living_more_than_three_years_2__c = 'a';
        app.Marital_Status_1__c = 'a';
        app.Marital_Status_2__c = 'a';
        app.Mobile_Number_2__c = 'a';
        app.Mode_of_Employment_2__c = 'a';
        app.Nature_of_Business__c = 'a';
        app.Net_Income_2__c = 0;
        app.No_of_Directors__c = 0;
        app.No_of_People__c = 1;
        
        app.Postcode__c = 'a';
        app.Postcode_2__c = 'a';
        app.Previous_Employer_Name_1__c = 'a';
        app.Previous_Employer_Name_2__c = 'a';
        app.Previous_Employer_Phone_1__c = 'a';
        app.Previous_Employer_Phone_2__c = 'a';
        app.Previous_Mode_of_Employment_1__c = 'a';
        app.Previous_Mode_of_Employment_2__c = 'a';
        app.Previous_Occupation_1__c = 'a';
        app.Previous_Occupation_2__c = 'a';
        app.Previous_Postcode_1__c = 'a';
        app.Previous_Postcode_2__c = 'a';
        app.Previous_Reference_Name_1__c = 'a';
        app.Previous_Reference_Name_2__c = 'a';
        app.Previous_Residence_Status_1__c = 'a';
        app.Previous_Residence_Status_2__c = 'a';
        app.Previous_Street_Address_1__c = 'a';
        app.Previous_Street_Address_2__c = 'a';
        app.Previous_Suburb_1__c = 'a';
        app.Previous_Suburb_2__c = 'a';
        app.Previous_Work_Address_1__c = 'a';
        app.Previous_Work_Address_2__c = 'a';
        app.Purchase_Price__c = 0;
        app.Reference_Name_1__c = 'a';
        app.Reference_Name_2__c = 'a';
        app.Start_Date_1__c = 'a';
        app.Start_Date_2__c = 'a';
        app.Street_Address__c = 'a';
        app.Street_Address_2__c = 'a';
        app.Suburb__c = 'a';
        app.Suburb_2__c = 'a';
        app.Super_Value__c = 'a';
        app.Title_1__c = 'a';
        app.Title_2__c = 'a';
        app.Trading_Address__c = 'a';
        app.Trading_Name__c = 'a';
        app.Trust_Name__c = 'a';
        app.Type_of_Asset__c = 'a';
        app.Vehicle_Make__c = 'a';
        app.Vehicle_Model__c = 'a';
        app.Vehicle_Year__c = 'a';
        app.Work_Phone__c = 'a';
        app.Work_Phone_2__c = 'a';
        
        app.First_Name__c = 'Michelle';
        app.Last_Name__c = 'Odine';
        app.Mobile_Number__c = '0439904537';
        app.Email_Address__c = 'bulk21@g.com';
        app.No_of_Dependants_1__c = 2;
        app.Do_you_own_a_property__c = 'Yes';
        app.Mode_of_Employment_1__c = 'Full Time';
        app.No_of_Dependants_2__c = 0;
        app.Current_Occupation_1__c = 'Developer';
        app.Net_Income_1__c = 5000;
        app.Partner_Income__c = 4000;
        app.Rent_per_month_1__c = 2000;
        app.Rent_per_month_2__c = 0;
        app.Repayment_Regularity__c = 'Month';
        app.Preferred_Repayment__c = 3200;
        app.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        
        //Lelo                          2016-07-04
        app.Board_per_Month_1__c = 77777;
        app.Board_per_Month_2__c = 88888;
        app.Basic_Living_Expenses_Per_Month__c = '99999';
        app.Childcare_Child_Maintenance_Per_Month__c = '11111';
        app.Mobile_Phone_Internet_Pay_TV_per_Month__c = '22222';
        app.Insurance_Expenses_per_Month__c = '33333';
        app.Travel_Transport_Expenses_per_Month__c = '44444';
        app.Other_Expenses_per_Month__c = '55555';
        app.Income_Type_Expenses__c = 'incomeTypeExpenses';
        app.Personal_Reference_1_Address__c = 'personal Reference1 Address';
        app.Personal_Reference_1_Full_Name__c = 'personalReference1 Full Name';
        app.Personal_Reference_1_Phone__c = 'a';
        app.Personal_Reference_1_Relationship__c = 'Relationship';
        app.Personal_Reference_2_Address__c = 'personalReference2Address';
        app.Personal_Reference_2_Full_Name__c = 'personal Reference2 Full_Name';
        app.Personal_Reference_2_Phone__c = '4';
        app.Personal_Reference_2_Relationship__c = 'Relationship';
        
        app.Supporting_Document_1__c = 'supportingDocument1';
        app.Supporting_Document_2__c = 'supportingDocument2';
        app.Supporting_Document_3__c = 'supportingDocument3';
        app.Supporting_Document_4__c = 'supportingDocument4';
        app.Supporting_Document_5__c = 'supportingDocument5';
        app.Supporting_Document_6__c = 'supportingDocument6';
        app.Supporting_Document_7__c = 'supportingDocument7';
        app.Supporting_Document_8__c = 'supportingDocument8';
        app.Supporting_Document_9__c = 'supportingDocument9';
        app.Supporting_Document_10__c = 'supportingDocument10';
        
        app.Do_you_expect_any_change_to_your_financi__c = 'yes';
        app.Is_There_Anything_You_Want_to_Tell_Us__c = 'anythingYouWantTellUsAboutApp';
        
        app.Credit_Status_1__c = 'creditStatus1';
        app.Credit_Status_2__c = 'creditStatus2';
        app.Current_Residential_Status_1__c = 'currentResidentialStatus1';
        app.Current_Residential_Status_2__c = 'currentResidentialStatus2';            
        app.Entity_Name__c = 'entityName';
        //Lelo                          2016-07-05
        app.Driver_Licence_State_Issue_1__c = 'SA';
        app.Driver_Licence_State_Issue_2__c = 'VIC';
        app.No_of_People__c = 2;
        app.Previous_Country_1b__c = 'AUS';
        app.Previous_Street_Address_1b__c = 'BBB';
        app.Previous_Country_1c__c = 'AUS';
        app.Previous_Street_Address_1c__c = 'BBB';
        app.Previous_Country_1d__c = 'AUS';
        app.Previous_Street_Address_1d__c = 'BBB';
        app.Previous_Country_1e__c = 'AUS';
        app.Previous_Street_Address_1e__c = 'BBB';
        app.Previous_Country_2b__c = 'AUS';
        app.Previous_Street_Address_2b__c = 'BBB';
        app.Previous_Country_2c__c = 'AUS';
        app.Previous_Street_Address_2c__c = 'BBB';
        app.Previous_Country_2d__c = 'AUS';
        app.Previous_Street_Address_2d__c = 'BBB';
        app.Previous_Country_2e__c = 'AUS';
        app.Previous_Street_Address_2e__c = 'BBB';
        app.Previous_Residence_Status_1b__c = 'CCC';
        app.Previous_Residence_Status_1c__c = 'CCC';
        app.Previous_Residence_Status_1d__c = 'CCC';
        app.Previous_Residence_Status_1e__c = 'CCC';
        app.Previous_Residence_Status_2b__c = 'CCC';
        app.Previous_Residence_Status_2c__c = 'CCC';
        app.Previous_Residence_Status_2d__c = 'CCC';
        app.Previous_Residence_Status_2e__c = 'CCC';
        //-
        app.Business_ABN__c = '74172177893';
        insert app;        
        Test_DataGeneratorHelper.tstApp = app;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = app.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.reloadOpportunity();
        
        PageReference pageRef = Page.OppApplication;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('LENDER_QUOTING','YTD');
		    ApexPages.currentPage().getParameters().put('sec','YTD');

        //Original 
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageCon = new OppApplicationExtension(sc);
        
        app.Repayment_Regularity__c = 'Week';
        //myPageCon.createNew();
      
        myPageCon.AppPdf ();
        myPageCon.gap = 0;
        myPageCon.warranty = 0;
        myPageCon.lpi = 0;
        myPageCon.other = 0;
        myPageCon.brokerageRate = 0;
        myPageCon.interestRate = 0;
        myPageCon.equipmentCost = 0;
        myPageCon.rental = 0;
        myPageCon.monthlyPayment = 0;
        myPageCon.fortnightPayment = 0;
        myPageCon.weeklyPayment = 0;
        myPageCon.residualValue = 0;
        myPageCon.clientRate = 0;
        myPageCon.brokerage = 0;
        
        myPageCon.emIncome1 = 0;
        myPageCon.emIncome2 = 0;
        myPageCon.othIncome1 = 0;
        myPageCon.othIncome2 = 0;
        myPageCon.rentMon = 0;
        myPageCon.othDebts = 0;
        myPageCon.livExpense = 0;
        myPageCon.reqSurplus = 0;
        myPageCon.monIncome = 3000;
        myPageCon.subTotal = 0;
        myPageCon.amtForLoan = 0;
        
        myPageCon.endDate = Date.newInstance(2016, 7, 1);
        myPageCon.ytdWeeks = 10;
        myPageCon.ytdIncome = 0;
        myPageCon.baseIncome = 2000;
        myPageCon.annualIncome = 0;
        myPageCon.ytdTax = 0;
        myPageCon.ytdMedi = 0;
        myPageCon.ytdMonIncome = 0;
        myPageCon.baseTax = 0;
        myPageCon.baseMedi = 0;
        myPageCon.netMonIncome = 0;
        myPageCon.monDifference = 0;
        myPageCon.discDiff = 0;
        myPageCon.outAmount = 0;
        
        myPageCon.firstName = 'a';
        myPageCon.lastName = 'a';
        myPageCon.emailAddress = 'a';
        myPageCon.mobileNumber = 'a';
        
        myPageCon.typeAsset = 'a';
        myPageCon.vehicleMake = 'a';
        myPageCon.vehicleModel = 'a';
        myPageCon.vehicleYear = 'a';
        myPageCon.purchasePrice = 0;
        myPageCon.financeAmount = 0;
        myPageCon.lengthTerm = 0;
        myPageCon.preferredRepayment = 0;
        myPageCon.repaymentRegularity = 'a';
        myPageCon.noPeople = 0;
        myPageCon.applicationType = 'a';
        
        myPageCon.abnCode = 'a';
        myPageCon.acn = 'a';
        myPageCon.tradingName = 'a';
        myPageCon.trustName = 'a';
        myPageCon.tradingAddress = 'a';
        myPageCon.natureBusiness = 'a';
        myPageCon.noDirectors = 0;
        myPageCon.estimatedProfit = 0;
        myPageCon.accountantName = 'a';
        myPageCon.accountantPhone = 'a';
        
        myPageCon.title1 = 'a';
        myPageCon.title2 = 'a';
        myPageCon.firstName2 = 'a';
        myPageCon.middleName = 'a';
        myPageCon.middleName2 = 'a';
        myPageCon.lastName2 = 'a';
        myPageCon.dateBirth1 = 'a';
        myPageCon.dateBirth2 = 'a';
        myPageCon.driversLicense1 = 'a';
        myPageCon.driversLicense2 = 'a';
        myPageCon.expiryDate1 = 'a';
        myPageCon.expiryDate2 = 'a';
        myPageCon.maritalStatus1 = 'a';
        myPageCon.maritalStatus2 = 'a';
        myPageCon.noDependants1 = 0;
        myPageCon.noDependants2 = 0;
        myPageCon.agesDependants1 = 'a';
        myPageCon.agesDependants2 = 'a';
        myPageCon.homePhone = 'a';
        myPageCon.homePhone2 = 'a';
        myPageCon.workPhone = 'a';
        myPageCon.workPhone2 = 'a';
        myPageCon.mobileNumber2 = 'a';
        myPageCon.emailAddress2 = 'a';
        myPageCon.partnerIncome = 0;
        
        myPageCon.applicant2SameAddress = 'a';
        myPageCon.streetAddress = 'a';
        myPageCon.streetAddress2 = 'a';
        myPageCon.suburb = 'a';
        myPageCon.suburb2 = 'a';
        myPageCon.postcode = 'a';
        myPageCon.postcode2 = 'a';
        myPageCon.dateMovedIn1 = 'a';
        myPageCon.dateMovedIn2 = 'a';
        myPageCon.currentStatus1 = 'a';
        myPageCon.currentStatus2 = 'a';
        myPageCon.landlordName1 = 'a';
        myPageCon.landlordName2 = 'a';
        myPageCon.landlordPhone1 = 'a';
        myPageCon.landlordPhone2 = 'a';
        myPageCon.rentMonth1 = 0;
        myPageCon.rentMonth2 = 0;
        myPageCon.living3Years1 = 'a';
        myPageCon.living3Years2 = 'a';
        
        myPageCon.previousStreetAddress1 = 'a';
        myPageCon.previousStreetAddress2 = 'a';
        myPageCon.previousSuburb1 = 'a';
        myPageCon.previousSuburb2 = 'a';
        myPageCon.previousPostcode1 = 'a';
        myPageCon.previousPostcode2 = 'a';
        myPageCon.dateFrom1 = 'a';
        myPageCon.dateFrom2 = 'a';
        myPageCon.previousResidenceStatus1 = 'a';
        myPageCon.previousResidenceStatus2 = 'a';
        
        myPageCon.modeEmployment1 = 'a';
        myPageCon.modeEmployment2 = 'a';
        myPageCon.employerName1 = 'a';
        myPageCon.employerName2 = 'a';
        myPageCon.workAddress1 = 'a';
        myPageCon.workAddress2 = 'a';
        myPageCon.employerPhone1 = 'a';
        myPageCon.employerPhone2 = 'a';
        myPageCon.referenceName1 = 'a';
        myPageCon.referenceName2 = 'a';
        myPageCon.occupation1 = 'a';
        myPageCon.occupation2 = 'a';
        myPageCon.dateStarted1 = '28/10/2016';
        myPageCon.dateStarted2 = 'a';
        myPageCon.netIncome1 = 0;
        myPageCon.netIncome2 = 0;
        myPageCon.paymentFrequency1 = 'a';
        myPageCon.paymentFrequency2 = 'a';
        myPageCon.employed3Years1 = 'a';
        myPageCon.employed3Years2 = 'a';
        
        myPageCon.previousModeEmployment1 = 'a';
        myPageCon.previousModeEmployment2 = 'a';
        myPageCon.previousEmployerName1 = 'a';
        myPageCon.previousEmployerName2 = 'a';
        myPageCon.previousWorkAddress1 = 'a';
        myPageCon.previousWorkAddress2 = 'a';
        myPageCon.previousEmployerPhone1 = 'a';
        myPageCon.previousEmployerPhone2 = 'a';
        myPageCon.previousReferenceName1 = 'a';
        myPageCon.previousReferenceName2 = 'a';
        myPageCon.previousOccupation1 = 'a';
        myPageCon.previousOccupation2 = 'a';
        myPageCon.startDate1 = 'a';
        myPageCon.startDate2 = 'a';
        myPageCon.finishDate1 = 'a';
        myPageCon.finishDate2 = 'a';
        
        myPageCon.bankName = 'a';
        myPageCon.bankValue = 0;
        myPageCon.superValue = '0';
        myPageCon.furnitureValue = 0;
        
        //Lelo                          2016-07-04
        myPageCon.boardMonth1 = 0;
        myPageCon.boardMonth2 = 0;
        myPageCon.basicLivingExpensesMonth = 0;
        myPageCon.childcareChildMaintenanceMonth = 0;
        myPageCon.mobilePhoneInternetPayTVMonth = 0;
        myPageCon.insuranceExpensesMonth = 0;
        myPageCon.travelTransportExpensesMonth = 0;
        myPageCon.otherExpensesMonth = 0;
        myPageCon.incomeTypeExpenses = 'a';
        myPageCon.personalReference1Address = 'a';
        myPageCon.personalReference1Full_Name = 'a';
        myPageCon.personalReference1Phone = 'a';
        myPageCon.personalReference1Relationship = 'a';
        myPageCon.personalReference2Address = 'a';
        myPageCon.personalReference2Full_Name = 'a';
        myPageCon.personalReference2Phone = 'a';
        myPageCon.personalReference2Relationship = 'a';
        myPageCon.supportingDocument1 = 'a';
        myPageCon.supportingDocument2 = 'a';
        myPageCon.supportingDocument3 = 'a';
        myPageCon.supportingDocument4 = 'a';
        myPageCon.expectAnyChangeYourFinaPosition = 'a';
        myPageCon.anythingYouWantTellUsAboutApp = 'a';
        myPageCon.creditStatus1 = 'a';
        myPageCon.creditStatus2 = 'a';
        myPageCon.currentResidentialStatus1 = 'a';
        myPageCon.currentResidentialStatus2 = 'a';
        myPageCon.entityName = 'a';
        //------------------------------------------------------------------------
        myPageCon.isSecondJobApplic1 = true;
        myPageCon.isSecondJobApplic2 = true;
        myPageCon.saveRecord();
        Test_DataGeneratorHelper.createApplicationEmployment('1');
        myPageCon.secondJobApplic1.Id = Test_DataGeneratorHelper.tstApplicationEmployment.Id;
        Test_DataGeneratorHelper.createApplicationEmployment('2');
        myPageCon.secondJobApplic2.Id = Test_DataGeneratorHelper.tstApplicationEmployment.Id;
        myPageCon.saveRecord();
        myPageCon.isSecondJobApplic1 = false;
        myPageCon.isSecondJobApplic2 = false;
        myPageCon.saveRecord();
        //------------------------------------------------------------------------
        
        //---------------------Test For ABN Lookup
		//myPageCon.showABNlookupPopup();
        //--------------------------------------------------

        sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        myPageCon = new OppApplicationExtension(sc);

        //Lelo                          2016-07-05
        myPageCon.stateOfIssue1 = 'a';
        myPageCon.stateOfIssue2 = 'a';
        //Lelo                          2016-07-11
        myPageCon.servCalcLender = 'GEO';
        myPageCon.servCalcState = 'SA';
        myPageCon.servCalcArea = 'Metro';
        myPageCon.servCalcType = 'Single';
        myPageCon.servCalcNoDependents = '2';
        myPageCon.servCalcSplittingExpenses = 'Yes';
        myPageCon.servCalcPartnerIncome = 3000.0;
        myPageCon.servCalcLender = 'GEO';
    
        myPageCon.servCalcTotNetMonthlyIncome = 0.0;    
        myPageCon.servCalcTotRentMtgPaid = 0.0;    
        myPageCon.servCalcTotLivingExpenses = 0.0;    
        //myPageCon.servCalcTotOtherDebts = 0.0;    
        myPageCon.servCalcTotAmountLoanPayment = 0.0;    
        
        myPageCon.servCalcIncomePayFrecuency1 = 'Weekly';    
        myPageCon.servCalcIncomeAmount1 = 2500.0;    
        myPageCon.servCalcOtherIncomePayFrecuency1 = 'Weekly';    
        myPageCon.servCalcOtherIncomeType1 = 'Rent';
        myPageCon.servCalcOtherIncomeAmount1 = 500.0;
    
        myPageCon.servCalcIncomePayFrecuency2 = 'Weekly';    
        myPageCon.servCalcIncomeAmount2 = 2500.0;    
        myPageCon.servCalcOtherIncomePayFrecuency2 = 'Weekly';    
        myPageCon.servCalcOtherIncomeType2 = 'Rent';
        myPageCon.servCalcOtherIncomeAmount2 = 500.0;
    
        myPageCon.servCalcLoanType = 'Car loan';
        myPageCon.servCalcLoanPayFrecuency = 'Weekly';
        myPageCon.servCalcLoanPayAmount = 200.0;

        myPageCon.servCalcLoanType2 = 'Car loan';
        myPageCon.servCalcLoanPayFrecuency2 = 'Weekly';
        myPageCon.servCalcLoanPayAmount2 = 200.0;

        myPageCon.servCalcLoanType3 = 'Car loan';
        myPageCon.servCalcLoanPayFrecuency3 = 'Weekly';
        myPageCon.servCalcLoanPayAmount3 = 200.0;

        myPageCon.servCalcLoanType4 = 'Car loan';
        myPageCon.servCalcLoanPayFrecuency4 = 'Weekly';
        myPageCon.servCalcLoanPayAmount4 = 200.0;
        
        myPageCon.servCalcRentPayFrecuency = 'Weekly';
        myPageCon.servCalcRentPayAmount = 500.0;
        
        myPageCon.servCalcCCardIssuer = 'ANZ';
        myPageCon.servCalcCCardCreditLimit = 10000.0;
        myPageCon.servCalcCCardAmountOwing = 3000.0;
        myPageCon.servCalcCCardMonthlyPayment = 300.0;
        
        myPageCon.servCalcCLinkNetNonCentIncome = 200.0;
        myPageCon.servCalcCLinkIncome = 10.0;
        myPageCon.servCalcCLinkTotalIncome = 90.0;
        myPageCon.servCalcCLinkIncomePercentage = 80.0;
        myPageCon.servCalcCLinkAnnualToLoannet = 70.0;

        myPageCon.servCalculateV2();
        myPageCon.ServicingPdf2();
        //-
        myPageCon.ytdCalculate();
        myPageCon.ytdIncomeOth = 2000;
        myPageCon.ytdWeeksOth = 0;
        myPageCon.startDateOth = Date.valueOf('2011-06-23');
        myPageCon.endDateOth = System.today();
        myPageCon.ytdCalculate();
        myPageCon.startDateOth = Date.valueOf('2013-06-23');
        myPageCon.endDateOth = Date.valueOf('2011-06-23');
        myPageCon.ytdCalculate ();
        
        myPageCon.AppPdf ();
        //myPageCon.ServicingPdf ();
        myPageCon.ytdPdf ();
        myPageCon.saveQuote ();
        myPageCon.emailQuote ();
        myPageCon.fakeMethod();
        
        QuotePdfExtension myQuoteCon = new QuotePdfExtension(sc);
        
        //Lelo						2016-08-17
        myPageCon.noteText = 'my note';
        myPageCon.saveNotePreApproval();
        myPageCon.saveNoteAmendment();
        List<Application_Extra_Data__c> noteList = myPageCon.getNotesForPreappoval();
        myPageCon.cancelNote();
        if (noteList != null && !noteList.isEmpty()) {
            myPageCon.noteId = noteList.get(0).Id;
        	myPageCon.prepareEditNote();		
        }
        
        //YTD
        myPageCon.ytdCalcLender = 'Esanda';
        myPageCon.ytdMonIncome = 50000;
        myPageCon.netMonIncome = 50000;
        myPageCon.monDifference = 50000;
        myPageCon.baseTax = 50000;
        myPageCon.baseMedi = 50000;
        myPageCon.startDate = Date.valueOf('2011-06-23');
        myPageCon.endDate = System.today();
        myPageCon.ytdCalcWeeksBeteenDates();
        myPageCon.startDate = Date.valueOf('2013-06-23');
        myPageCon.endDate = Date.valueOf('2011-06-23');
        myPageCon.ytdCalcWeeksBeteenDates();
        
        myPageCon.startDateA2 = Date.valueOf('2011-06-23');
        myPageCon.endDateA2 = System.today();
        myPageCon.ytdCalcWeeksBeteenDatesA2();
        myPageCon.startDateA2 = Date.valueOf('2013-06-23');
        myPageCon.endDateA2 = Date.valueOf('2011-06-23');
        myPageCon.ytdCalcWeeksBeteenDatesA2();
        
        myPageCon.ytdCalcYtdNetMonthly();
        myPageCon.ytdIncome = 500;
        myPageCon.ytdWeeks = 4;
        myPageCon.netMonIncome = 2000;
        myPageCon.ytdCalcYtdNetMonthly();
        
        myPageCon.ytdIncomeA2 = 0;
        myPageCon.ytdWeeksA2 = 0;
        myPageCon.netMonIncomeA2 = 0;
        myPageCon.ytdCalcYtdNetMonthlyA2();
        myPageCon.ytdIncomeA2 = 500;
        myPageCon.ytdWeeksA2 = 4;
        myPageCon.netMonIncomeA2 = 2000;
        myPageCon.ytdCalcYtdNetMonthlyA2();
        
        myPageCon.baseIncome = 2000;
        myPageCon.ytdCalcLender = 'Esanda';
        myPageCon.ytdCalcBaseIncome();
        myPageCon.ytdCalcLender = 'Pepper';
        myPageCon.ytdCalcBaseIncome();
        
        myPageCon.baseIncomeA2 = 2000;
        myPageCon.ytdCalcLender = 'Esanda';
        myPageCon.ytdCalcBaseIncomeA2();
        myPageCon.ytdCalcLender = 'Pepper';
        myPageCon.ytdCalcBaseIncomeA2();
        
        myPageCon.ytdMacPayPeriodNetSalary = 2000;
        myPageCon.ytdMacPayPeriodDays = 48;
        myPageCon.ytdMacStartDate = Date.valueOf('2011-06-23');
        myPageCon.ytdMacEndDate = System.today();
        myPageCon.ytdMacDayssBeteenDates();
        myPageCon.ytdMacStartDate = Date.valueOf('2013-06-23');
        myPageCon.ytdMacEndDate = Date.valueOf('2011-06-23');
        myPageCon.ytdMacDayssBeteenDates();
        
        myPageCon.ytdMacPayPeriodNetSalaryA2 = 2000;
        myPageCon.ytdMacPayPeriodDaysA2 = 48;
        myPageCon.ytdMacStartDateA2 = Date.valueOf('2011-06-23');
        myPageCon.ytdMacEndDateA2 = System.today();
        myPageCon.ytdMacDayssBeteenDatesA2();
        myPageCon.ytdMacStartDateA2 = Date.valueOf('2013-06-23');
        myPageCon.ytdMacEndDateA2 = Date.valueOf('2011-06-23');
        myPageCon.ytdMacDayssBeteenDatesA2();
        
        myPageCon.ytdMacNetYTDSalary();
        myPageCon.ytdMacCalcPayPeriodSalary();
        myPageCon.ytdSavePdf();
        try { myPageCon.ytdSavePreApprovalPdf(); } catch(DmlException e) {}
        myPageCon.ytdCalcLender = 'Pepper';
        myPageCon.ytdSavePdf();
        try { myPageCon.ytdSavePreApprovalPdf(); } catch(DmlException e) {}
        myPageCon.ytdCalcLender = 'Macquarie';
        myPageCon.ytdSavePdf();
        try { myPageCon.ytdSavePreApprovalPdf(); } catch(DmlException e) {}
        myPageCon.ytdCalcLender = 'Others';
        myPageCon.ytdSavePdf();
        try { myPageCon.ytdSavePreApprovalPdf(); } catch(DmlException e) {}
        myPageCon.ytdCalcLender = 'LowDocumentation';
        myPageCon.ytdSavePdf();
        try { myPageCon.ytdSavePreApprovalPdf(); } catch(DmlException e) {}
        
        myPageCon.ytdMonIncome = 45854;
        myPageCon.ytdMonIncome = 45854;
		  myPageCon.sgtPaylipsFrecuency = 'Weekly';
        myPageCon.sgtPaylipsFrecuency1 = 'Weekly';
        myPageCon.sgtPaylipsFrecuency2 = 'Weekly';
        myPageCon.sgtPaylipsFrecuency3 = 'Weekly';
        myPageCon.sgtPaylipsFrecuencyA2 = 'Weekly';
        myPageCon.sgtPaylipsFrecuency1A2 = 'Weekly';
        myPageCon.sgtPaylipsFrecuency2A2 = 'Weekly';
        myPageCon.sgtPaylipsFrecuency3A2 = 'Weekly';
        myPageCon.sgtPaylipsAmount = 2;
        myPageCon.sgtPaylipsAmount1 = 2;
        myPageCon.sgtPaylipsAmount2 = 2;
        myPageCon.sgtPaylipsAmount3 = 2;
        myPageCon.sgtPaylipsAmountA2 = 2;
        myPageCon.sgtPaylipsAmount1A2 = 2;
        myPageCon.sgtPaylipsAmount2A2 = 2;
        myPageCon.sgtPaylipsAmount3A2 = 2;
        myPageCon.fdNetProfit2 = 2;
        
        YtdPdfExtension myYtdCon = new YtdPdfExtension(sc);
        
        myPageCon.getPermanentMonthlyTotal();
        myPageCon.getCasualMonthlyTotal1();
        myPageCon.getCasualMonthlyTotal2();
        myPageCon.getCasualMonthlyTotal3();
        myPageCon.getCasualTotalAverage();
        myPageCon.getPermanentMonthlyTotalA2();
        myPageCon.getCasualMonthlyTotal1A2();
        myPageCon.getCasualMonthlyTotal2A2();
        myPageCon.getCasualMonthlyTotal3A2();
        myPageCon.getFullDocumentationTotal();
        myPageCon.getFullDocumentationMonthlyTotal();
        myPageCon.getCasualTotalAverageA2();
        myPageCon.getFullDocumentationTotal2();
        myPageCon.getFullDocumentationMonthlyTotal2();
        myPageCon.saveNoteFormalApproval();
        
        myPageCon.ytdMacNetYTDSalaryA2();
        myPageCon.ytdMacCalcPayPeriodSalaryA2();
        
        myPageCon.ytdCalculateA2();
        myPageCon.ytdIncomeOthA2 = 2000;
        myPageCon.ytdWeeksOthA2 = 0;
        myPageCon.startDateOthA2 = Date.valueOf('2011-06-23');
        myPageCon.endDateOthA2 = System.today();
        myPageCon.ytdCalculateA2();
        myPageCon.startDateOthA2 = Date.valueOf('2013-06-23');
        myPageCon.endDateOthA2 = Date.valueOf('2011-06-23');
        myPageCon.ytdCalculateA2();
        
        myPageCon.validateAppForm();
        myPageCon.calculateSplitExpenses();
        myPageCon.getServCalcTotNetPartnerIncome();
        myPageCon.getServCalcTotRentMtgPaidSplit();
        myPageCon.servCalculateCentreLink();
        myPageCon.servCalculateTotalNetMonthlyIncome();
        myPageCon.calculateAmountAvalilableLoanPayment();
        myPageCon.servCalculateLivingExpenses();
        myPageCon.getServCalcNoDependentsSelectOptions();
        myPageCon.uploadFile1();
        myPageCon.uploadFile2();
        myPageCon.uploadFile3();
        myPageCon.uploadFile4();
        myPageCon.uploadFile5();
        myPageCon.uploadFile6();
        myPageCon.uploadFile7();
        myPageCon.uploadFile8();
        myPageCon.uploadFile9();
        myPageCon.uploadFile10();
        myPageCon.getIsFileUploaded1();
        myPageCon.getIsFileUploaded2();
        myPageCon.getIsFileUploaded3();
        myPageCon.getIsFileUploaded4();
        myPageCon.getIsFileUploaded5();
        myPageCon.getIsFileUploaded6();
        myPageCon.getIsFileUploaded7();
        myPageCon.getIsFileUploaded8();
        myPageCon.getIsFileUploaded9();
        myPageCon.getIsFileUploaded10();
		
        //App form
        myPageCon.AppPdfPreApproval();
        myPageCon.ytdMacCalcPayPeriodSalary();
       
        app.Net_Income_2__c = 1;
        app.Payment_Frequency_1__c = 'Monthly';
        app.Payment_Frequency_2__c = 'Monthly';
        update app;
        Test_DataGeneratorHelper.tstOpportunity.ApplicationServicing__c = null;
        update Test_DataGeneratorHelper.tstOpportunity;
        Test_DataGeneratorHelper.reloadOpportunity();
        sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        myPageCon = new OppApplicationExtension(sc);
        
        Test_DataGeneratorHelper.createApplicationEmployment('1');
        Test_DataGeneratorHelper.tstApplicationEmployment.Income__c = 1;
        Test_DataGeneratorHelper.tstApplicationEmployment.Frequency__c = 'Monthly';
        myPageCon.secondJobApplic1 = Test_DataGeneratorHelper.tstApplicationEmployment;
        Test_DataGeneratorHelper.createApplicationEmployment('2');
        Test_DataGeneratorHelper.tstApplicationEmployment.Income__c = 1;
        Test_DataGeneratorHelper.tstApplicationEmployment.Frequency__c = 'Monthly';
        myPageCon.secondJobApplic2 = Test_DataGeneratorHelper.tstApplicationEmployment;
        
        myPageCon.loadServicingCalculatorData();

        Application_Servicing__c s = new Application_Servicing__c();
        s.IncomePayFrecuency_1b__c = 'Monthly';
		s.IncomePayFrecuency_2b__c = 'Monthly';
        insert s;
        
        Test_DataGeneratorHelper.tstOpportunity.ApplicationServicing__c = s.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        Test_DataGeneratorHelper.reloadOpportunity();
		
		myPageCon.loadServicingCalculatorData();
        myPageCon.clearYTDCalcSectionFields();
}
/*
public static testMethod void myUnitTest1b(){
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        List<Application_Other_Asset__c> otherList = new List<Application_Other_Asset__c>();
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Both Applicants';
        otherList.add(o);
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        otherList.add(o);

        insert otherList;
                
        myPageConta.getProperties();
        myPageConta.getProperties2();
        myPageConta.loadOtherAssets();
        myPageConta.isValidPropertyAssets();
}

    public static testMethod void myUnitTest2(){
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
                
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
                
        insert i;
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
                
        myPageConta.otherAssetMap = new Map<String, List<OppApplicationExtension.ObjectWrapped>>();
        List<OppApplicationExtension.ObjectWrapped> m = new List<OppApplicationExtension.ObjectWrapped>();
        
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        m.add(new OppApplicationExtension.ObjectWrapped(1, o));
        myPageConta.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, m);
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        m.add(new OppApplicationExtension.ObjectWrapped(2, o));
        myPageConta.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, m);
        
        myPageConta.isValidPropertyAssets();
        
        myPageConta.otherAssetMap = new Map<String, List<OppApplicationExtension.ObjectWrapped>>();
        m = new List<OppApplicationExtension.ObjectWrapped>();
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Applicant 1';
        
        m.add(new OppApplicationExtension.ObjectWrapped(1, o));
        myPageConta.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, m);
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        m.add(new OppApplicationExtension.ObjectWrapped(2, o));
        myPageConta.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, m);
        
        myPageConta.isValidPropertyAssets();
        
        myPageConta.otherAssetMap = new Map<String, List<OppApplicationExtension.ObjectWrapped>>();
        m = new List<OppApplicationExtension.ObjectWrapped>();
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Applicant 2';
        
        m.add(new OppApplicationExtension.ObjectWrapped(1, o));
        myPageConta.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, m);
                
        myPageConta.isValidPropertyAssets();
                 
        myPageConta.getIncomesApp1();
        myPageConta.getIncomesApp2();
        myPageConta.saveApplicationData();
        myPageConta.isValidIncomes('1');
                
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.tstApp.Applicant_2_living_in_the_same_address__c = 'No';
        update Test_DataGeneratorHelper.tstApp;
        Application_Employment__c e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '1';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        e.Frequency__c = 'Monthly';
        e.Income__c = 1;
        e.Unit_Number__c = '1';		
        e.Street_Number__c = '1';
        e.Work_Address__c = 'a';
        e.Street_Type__c = 'ST';
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '2';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        e.Frequency__c = 'Monthly';
        e.Income__c = 1;
        e.Unit_Number__c = '1';		
        e.Street_Number__c = '1';
        e.Work_Address__c = 'a';
        e.Street_Type__c = 'ST';
        
        insert e;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
                
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
                
        insert i;
        Application_Servicing__c s = new Application_Servicing__c();
        s.State__c = 's';
        insert s;
        
        Test_DataGeneratorHelper.tstOpportunity.ApplicationServicing__c = s.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        Test_DataGeneratorHelper.reloadOpportunity();
        YTD_Income__c ytd = new YTD_Income__c();
        ytd.Applicant_Type__c = 'Applicant 1';
        ytd.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        ytd.Type__c = 'Others';
        
        insert ytd;
        
        ytd = new YTD_Income__c();
        ytd.Applicant_Type__c = 'Applicant 1 Second Job';
        ytd.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert ytd;
        
        ytd = new YTD_Income__c();
        ytd.Applicant_Type__c = 'Applicant 2';
        ytd.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        ytd.Type__c = 'Others';
        
        insert ytd;
        
        ytd = new YTD_Income__c();
        ytd.Applicant_Type__c = 'Applicant 2 Second Job';
        ytd.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert ytd;
        ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		myPageConta = new OppApplicationExtension(ape);
        myPageConta.swapApplicant();
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.tstApp.Applicant_2_living_in_the_same_address__c = 'Yes';
        update Test_DataGeneratorHelper.tstApp;
        Test_DataGeneratorHelper.reloadOpportunity();
        ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		myPageConta = new OppApplicationExtension(ape);
        myPageConta.AppPdf();
                
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.tstApp.Applicant_2_living_in_the_same_address__c = 'Yes';
        Test_DataGeneratorHelper.tstApp.No_of_People__c = 1;
        update Test_DataGeneratorHelper.tstApp;
        Test_DataGeneratorHelper.reloadOpportunity();
        ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		myPageConta = new OppApplicationExtension(ape);
        myPageConta.swapApplicant();        
    }
    
    public static testMethod void myUnitTest3(){
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 2';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        myPageConta.saveApplicationData();
    }
    
    public static testMethod void myUnitTest4(){
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        myPageConta.saveApplicationData();
    }
    
    public static testMethod void myUnitTest5(){
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 2';
        
        insert o;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        myPageConta.saveApplicationData();
    }
    
    public static testMethod void myUnitTest6(){
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();    
        ApexPages.StandardController ape = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = Test_DataGeneratorHelper.tstApp.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        OppApplicationExtension myPageConta = new OppApplicationExtension(ape);
        myPageConta.saveApplicationData();
    }
    
    public static testMethod void myUnitExtraTest1(){
        Test_DataGeneratorHelper.createOpportunity();
        
        PageReference pageRefe = Page.OppApplication;
        pageRefe.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRefe);
        ApexPages.currentPage().getParameters().put('LENDER_QUOTING','YTD');
        ApexPages.currentPage().getParameters().put('sec','SRV');
        
        Test_DataGeneratorHelper.createAssets();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension myPageCon = new OppApplicationExtension(sc);
                
        PageReference pageRefer = Page.OppApplication;
        pageRefer.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRefer);
        ApexPages.currentPage().getParameters().put('LENDER_QUOTING','YTD');
        ApexPages.currentPage().getParameters().put('sec','NTS');
        
        sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        myPageCon = new OppApplicationExtension(sc);
    }

 	public static testMethod void myUnitExtraTest2(){   
   		FieldValidationsHelper.isContainsValidCharacters('');
        FieldValidationsHelper.isContainsValidCharacters('32342f f sdsdfs');
        FieldValidationsHelper.isContainsValidCharacters('         ');
        FieldValidationsHelper.isDateFormatValidOptional('34534534534');
        
        FieldValidationsHelper.isContainsValidCharacters(67.6);
        FieldValidationsHelper.isDateFormatValid(null);
        FieldValidationsHelper.isDateFormatValid('15/08/1958');
        FieldValidationsHelper.isDateFormatValidOptional(null);

        FieldValidationsHelper.isValueGreaterThanZero(null);
        FieldValidationsHelper.isValueGreaterThanZero('eeeee');
        FieldValidationsHelper.isValueGreaterThanZero('6');
        FieldValidationsHelper.isValueGreaterThanZero('0');

        FieldValidationsHelper.isDecimalGreaterThanZero(null);
        FieldValidationsHelper.isDecimalGreaterThanZero(0.0);
        FieldValidationsHelper.isDecimalGreaterThanZero(-2);
        FieldValidationsHelper.isDecimalGreaterThanZero(250);

        NumberUtils.convertToDecimal(null, true);
        NumberUtils.convertToDecimal(null, false);
        NumberUtils.convertToDecimal('', true);
        NumberUtils.convertToDecimal('', false);
        NumberUtils.convertToDecimal('125.25', true);
        NumberUtils.convertToDecimal('125.36', false);
        NumberUtils.convertToDecimal('jajajajaa', true);
        NumberUtils.convertToDecimal('lalalala', false);

        PersonalAssetDTO pa = new PersonalAssetDTO();
        pa.assetType = 'P';
        pa.detail = 'Mortgage';
        pa.value = 15000;
        pa.hasLoan = 'Y';
        pa.loanType = 'Mortgage';
        pa.lender = 'My Lender';
        pa.amountOwing = 15000;
        pa.payment = 250;
        pa.frequency = 'Monthly';
        pa.isPayout = false;
        pa.order = 1;

        pa = new PersonalAssetDTO(pa.assetType);

        ApplicationService.Asset a = new ApplicationService.Asset(pa.assetType);
        a.assetType = 'P';
        a.detail = 'Mortgage';
        a.value = 15000;
        a.hasLoan = 'Y';
        a.loanType = 'Mortgage';
        a.lender = 'My Lender';
        a.amountOwing = 15000;
        a.payment = 250;
        a.frequency = 'Monthly';
        a.isPayout = false;
        a.order = 1;

        pa = new PersonalAssetDTO(a);
    }
    
    public static testMethod void MoreThan3YearsTest(){ 
        
        Test_DataGeneratorHelper.createOpportunity();
        
        //this.Opp = (Custom_Opportunity__c)stdController.getRecord ();
        
        Custom_Opportunity__c oppTestRec1 = new Custom_Opportunity__c();
        insert oppTestRec1;
        
        Test_DataGeneratorHelper.createPreviousEmployment();
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(oppTestRec1);
        //ApexPages.StandardController stdCon = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        OppApplicationExtension oppAppPageCon = new OppApplicationExtension(stdCon);
        
        oppAppPageCon.gender1 = 'Male';
        oppAppPageCon.dateBirth1 = '1/1/1980';
        
        oppAppPageCon.typeAsset = 'test';
        oppAppPageCon.vehicleMake = 'test';
        oppAppPageCon.vehicleModel = 'test';
        oppAppPageCon.vehicleYear = '2017';
        oppAppPageCon.purchasePrice = 123.00;
        
        oppAppPageCon.firstName = 'test';
        oppAppPageCon.middleName = 'test';
        oppAppPageCon.lastName = 'test';
        
        oppAppPageCon.driversLicense1 = 'test';
        oppAppPageCon.stateOfIssue1 = 'test';
        oppAppPageCon.homePhone = 'test';
        oppAppPageCon.workPhone = 'test';
        oppAppPageCon.mobileNumber = '123';
        oppAppPageCon.emailAddress = 'test@test.com';
        
        oppAppPageCon.streetAddress = 'test';
        oppAppPageCon.suburb = 'test';
        oppAppPageCon.postcode = 'test';
        oppAppPageCon.currentStatus1 = 'test';
        oppAppPageCon.relativeName1 = 'test';
        oppAppPageCon.relativePhone1 = 'test';
        
        oppAppPageCon.financeAmount = 1000.00;
        oppAppPageCon.lengthTerm = 10;
        
        oppAppPageCon.saveDraftVFPage();
        
        //Male applicant
        oppAppPageCon.gender1 = 'M';
        oppAppPageCon.saveDraftVFPage();
                
        //Female applicant
        oppAppPageCon.gender1 = 'F';
        oppAppPageCon.saveDraftVFPage();
                
        //Gender of applicant is null
        Application__c appForOppTestRec0 = new Application__c();
    
        appForOppTestRec0.Accountant_Name__c = 'a';
        appForOppTestRec0.Accountant_Phone__c = 'a';
        appForOppTestRec0.Ages_of_Dependants_1__c = 'a';
        appForOppTestRec0.Ages_of_Dependants_2__c = 'a';
        appForOppTestRec0.Applicant_2_living_in_the_same_address__c = 'a';
        appForOppTestRec0.Application_Type__c ='a';
        appForOppTestRec0.Bank_Name__c = 'a';
        appForOppTestRec0.Bank_Value__c = 0;
        appForOppTestRec0.Business_ABN__c = 'a';
        appForOppTestRec0.Business_ACN__c = 'a';
        appForOppTestRec0.Current_Employer_Name_1__c = 'a';
        appForOppTestRec0.Current_Employer_Name_2__c = 'a';
        appForOppTestRec0.Current_Employer_Phone_1__c = 'a';
        appForOppTestRec0.Current_Employer_Phone_2__c = 'a';
        appForOppTestRec0.Current_Occupation_2__c = 'a';
        appForOppTestRec0.Current_Residence_Status_1__c ='a';
        appForOppTestRec0.Current_Residence_Status_2__c ='a';
        appForOppTestRec0.Current_Work_Address_1__c = 'a';
        appForOppTestRec0.Current_Work_Address_2__c = 'a';
        appForOppTestRec0.Date_From_1__c = 'a';
        appForOppTestRec0.Date_From_2__c = 'a';
        appForOppTestRec0.Date_Moved_in_1__c = 'a';
        appForOppTestRec0.Date_Moved_in_2__c = 'a';
        appForOppTestRec0.Date_of_Birth_1__c = 'a';
        appForOppTestRec0.Date_of_Birth_2__c = 'a';
        appForOppTestRec0.Date_Started_1__c = 'a';
        appForOppTestRec0.Date_Started_2__c = 'a';
        appForOppTestRec0.Do_you_have_any_credit_cards__c = 'a';
        appForOppTestRec0.Do_you_have_any_loans_outstanding__c = 'a';
        appForOppTestRec0.Do_you_have_drivers_licence_1__c = 'a';
        appForOppTestRec0.Do_you_have_drivers_licence_2__c = 'a';
        appForOppTestRec0.Do_you_own_a_motor_vehicle__c = 'a';
        appForOppTestRec0.Do_you_receive_other_income_1__c = 'a';
        appForOppTestRec0.Drivers_License_1__c = 'a';
        appForOppTestRec0.Drivers_License_2__c = 'a';
        appForOppTestRec0.Email_Address_2__c = 'a@test.com';
        appForOppTestRec0.Employed_for_more_than_two_years_1__c = 'a';
        appForOppTestRec0.Employed_for_more_than_two_years_2__c = 'a';
        appForOppTestRec0.Entity_Name__c = 'a';
        appForOppTestRec0.Estimated_profit_per_annum__c = 0;
        appForOppTestRec0.Expiry_Date_1__c = 'a';
        appForOppTestRec0.Expiry_Date_2__c = 'a';
        appForOppTestRec0.Finance_Amount__c = 0;
        appForOppTestRec0.Finish_Date_1__c = 'a';
        appForOppTestRec0.Finish_Date_2__c = 'a';
        appForOppTestRec0.First_Name_2__c = 'a';
        appForOppTestRec0.Furniture_Value__c = 0;
        appForOppTestRec0.Home_Phone__c = 'a';
        appForOppTestRec0.Home_Phone_2__c = 'a';
        appForOppTestRec0.Landlord_Name_1__c = 'a';
        appForOppTestRec0.Landlord_Name_2__c = 'a';
        appForOppTestRec0.Landlord_Phone_1__c = 'a';
        appForOppTestRec0.Landlord_Phone_2__c = 'a';
        appForOppTestRec0.Last_Name_2__c = 'a';
        appForOppTestRec0.Length_of_Term__c = 0;
        appForOppTestRec0.Living_more_than_three_years_1__c = 'a';
        appForOppTestRec0.Living_more_than_three_years_2__c = 'a';
        appForOppTestRec0.Marital_Status_1__c = 'a';
        appForOppTestRec0.Marital_Status_2__c = 'a';
        appForOppTestRec0.Mobile_Number_2__c = 'a';
        appForOppTestRec0.Mode_of_Employment_2__c = 'a';
        appForOppTestRec0.Nature_of_Business__c = 'a';
        appForOppTestRec0.Net_Income_2__c = 0;
        appForOppTestRec0.No_of_Directors__c = 0;
        appForOppTestRec0.No_of_People__c = 1;
        
        appForOppTestRec0.Postcode__c = 'a';
        appForOppTestRec0.Postcode_2__c = 'a';
        appForOppTestRec0.Previous_Employer_Name_1__c = 'a';
        appForOppTestRec0.Previous_Employer_Name_2__c = 'a';
        appForOppTestRec0.Previous_Employer_Phone_1__c = 'a';
        appForOppTestRec0.Previous_Employer_Phone_2__c = 'a';
        appForOppTestRec0.Previous_Mode_of_Employment_1__c = 'a';
        appForOppTestRec0.Previous_Mode_of_Employment_2__c = 'a';
        appForOppTestRec0.Previous_Occupation_1__c = 'a';
        appForOppTestRec0.Previous_Occupation_2__c = 'a';
        appForOppTestRec0.Previous_Postcode_1__c = 'a';
        appForOppTestRec0.Previous_Postcode_2__c = 'a';
        appForOppTestRec0.Previous_Reference_Name_1__c = 'a';
        appForOppTestRec0.Previous_Reference_Name_2__c = 'a';
        appForOppTestRec0.Previous_Residence_Status_1__c = 'a';
        appForOppTestRec0.Previous_Residence_Status_2__c = 'a';
        appForOppTestRec0.Previous_Street_Address_1__c = 'a';
        appForOppTestRec0.Previous_Street_Address_2__c = 'a';
        appForOppTestRec0.Previous_Suburb_1__c = 'a';
        appForOppTestRec0.Previous_Suburb_2__c = 'a';
        appForOppTestRec0.Previous_Work_Address_1__c = 'a';
        appForOppTestRec0.Previous_Work_Address_2__c = 'a';
        appForOppTestRec0.Purchase_Price__c = 0;
        appForOppTestRec0.Reference_Name_1__c = 'a';
        appForOppTestRec0.Reference_Name_2__c = 'a';
        appForOppTestRec0.Start_Date_1__c = 'a';
        appForOppTestRec0.Start_Date_2__c = 'a';
        appForOppTestRec0.Street_Address__c = 'a';
        appForOppTestRec0.Street_Address_2__c = 'a';
        appForOppTestRec0.Suburb__c = 'a';
        appForOppTestRec0.Suburb_2__c = 'a';
        appForOppTestRec0.Super_Value__c = 'a';
        appForOppTestRec0.Title_1__c = 'a';
        appForOppTestRec0.Title_2__c = 'a';
        appForOppTestRec0.Trading_Address__c = 'a';
        appForOppTestRec0.Trading_Name__c = 'a';
        appForOppTestRec0.Trust_Name__c = 'a';
        appForOppTestRec0.Type_of_Asset__c = 'a';
        appForOppTestRec0.Vehicle_Make__c = 'a';
        appForOppTestRec0.Vehicle_Model__c = 'a';
        appForOppTestRec0.Vehicle_Year__c = 'a';
        appForOppTestRec0.Work_Phone__c = 'a';
        appForOppTestRec0.Work_Phone_2__c = 'a';
        
        appForOppTestRec0.First_Name__c = 'Michelle';
        appForOppTestRec0.Last_Name__c = 'Odine';
        appForOppTestRec0.Mobile_Number__c = '0439904537';
        appForOppTestRec0.Email_Address__c = 'bulk21@g.com';
        appForOppTestRec0.No_of_Dependants_1__c = 2;
        appForOppTestRec0.Do_you_own_a_property__c = 'Yes';
        appForOppTestRec0.Mode_of_Employment_1__c = 'Full Time';
        appForOppTestRec0.No_of_Dependants_2__c = 0;
        appForOppTestRec0.Current_Occupation_1__c = 'Developer';
        appForOppTestRec0.Net_Income_1__c = 5000;
        appForOppTestRec0.Partner_Income__c = 4000;
        //appForOppTestRec0.Loan_Type_1__c = 'Mortgage';
        //appForOppTestRec0.Loans_Monthly_Payments_1__c = 3000;
        //appForOppTestRec0.Loan_Type_2__c = 'Car Loan';
        //appForOppTestRec0.Loans_Monthly_Payments_2__c = 1500;
        //appForOppTestRec0.Loan_Type_3__c = 'a';
        //appForOppTestRec0.Loans_Monthly_Payments_3__c = 0;
        appForOppTestRec0.Rent_per_month_1__c = 2000;
        appForOppTestRec0.Rent_per_month_2__c = 0;
        appForOppTestRec0.Repayment_Regularity__c = 'Month';
        appForOppTestRec0.Preferred_Repayment__c = 3200;
        appForOppTestRec0.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        
        //Lelo                          2016-07-04
        appForOppTestRec0.Board_per_Month_1__c = 77777;
        appForOppTestRec0.Board_per_Month_2__c = 88888;
        appForOppTestRec0.Basic_Living_Expenses_Per_Month__c = '99999';
        appForOppTestRec0.Childcare_Child_Maintenance_Per_Month__c = '11111';
        appForOppTestRec0.Mobile_Phone_Internet_Pay_TV_per_Month__c = '22222';
        appForOppTestRec0.Insurance_Expenses_per_Month__c = '33333';
        appForOppTestRec0.Travel_Transport_Expenses_per_Month__c = '44444';
        appForOppTestRec0.Other_Expenses_per_Month__c = '55555';
        appForOppTestRec0.Income_Type_Expenses__c = 'incomeTypeExpenses';
        appForOppTestRec0.Personal_Reference_1_Address__c = 'personal Reference1 Address';
        appForOppTestRec0.Personal_Reference_1_Full_Name__c = 'personalReference1 Full Name';
        appForOppTestRec0.Personal_Reference_1_Phone__c = 'a';
        appForOppTestRec0.Personal_Reference_1_Relationship__c = 'Relationship';
        appForOppTestRec0.Personal_Reference_2_Address__c = 'personalReference2Address';
        appForOppTestRec0.Personal_Reference_2_Full_Name__c = 'personal Reference2 Full_Name';
        appForOppTestRec0.Personal_Reference_2_Phone__c = '4';
        appForOppTestRec0.Personal_Reference_2_Relationship__c = 'Relationship';
        
        appForOppTestRec0.Supporting_Document_1__c = 'supportingDocument1';
        appForOppTestRec0.Supporting_Document_2__c = 'supportingDocument2';
        appForOppTestRec0.Supporting_Document_3__c = 'supportingDocument3';
        appForOppTestRec0.Supporting_Document_4__c = 'supportingDocument4';
        
        appForOppTestRec0.Do_you_expect_any_change_to_your_financi__c = 'yes';
        appForOppTestRec0.Is_There_Anything_You_Want_to_Tell_Us__c = 'anythingYouWantTellUsAboutApp';
        
        appForOppTestRec0.Credit_Status_1__c = 'creditStatus1';
        appForOppTestRec0.Credit_Status_2__c = 'creditStatus2';
        appForOppTestRec0.Current_Residential_Status_1__c = 'currentResidentialStatus1';
        appForOppTestRec0.Current_Residential_Status_2__c = 'currentResidentialStatus2';            
        appForOppTestRec0.Entity_Name__c = 'entityName';
        //Lelo                          2016-07-05
        appForOppTestRec0.Driver_Licence_State_Issue_1__c = 'SA';
        appForOppTestRec0.Driver_Licence_State_Issue_2__c = 'VIC';
        //-
        
        //Test set gender to null 
        appForOppTestRec0.Gender_1__c = '';

        insert appForOppTestRec0;
        
        oppTestRec1.Application__c = appForOppTestRec0.Id;
        
        
        update oppTestRec1;
        
        system.debug('value of oppTestRec1 application gender '+ oppTestRec1.Application__r.Gender_1__c);
        
        oppAppPageCon.gender1 = '';
        //oppAppPageCon.gender1 = '';
        oppAppPageCon.saveDraftVFPage();
               
        //Date of birth is null
        oppAppPageCon.dateBirth1 = '';
        oppAppPageCon.saveDraftVFPage();
        
        Application__c appForOppTestRec1 = new Application__c();
    
        appForOppTestRec1.Accountant_Name__c = 'a';
        appForOppTestRec1.Accountant_Phone__c = 'a';
        appForOppTestRec1.Ages_of_Dependants_1__c = 'a';
        appForOppTestRec1.Ages_of_Dependants_2__c = 'a';
        appForOppTestRec1.Applicant_2_living_in_the_same_address__c = 'a';
        appForOppTestRec1.Application_Type__c ='a';
        appForOppTestRec1.Bank_Name__c = 'a';
        appForOppTestRec1.Bank_Value__c = 0;
        appForOppTestRec1.Business_ABN__c = 'a';
        appForOppTestRec1.Business_ACN__c = 'a';
        appForOppTestRec1.Current_Employer_Name_1__c = 'a';
        appForOppTestRec1.Current_Employer_Name_2__c = 'a';
        appForOppTestRec1.Current_Employer_Phone_1__c = 'a';
        appForOppTestRec1.Current_Employer_Phone_2__c = 'a';
        appForOppTestRec1.Current_Occupation_2__c = 'a';
        appForOppTestRec1.Current_Residence_Status_1__c ='a';
        appForOppTestRec1.Current_Residence_Status_2__c ='a';
        appForOppTestRec1.Current_Work_Address_1__c = 'a';
        appForOppTestRec1.Current_Work_Address_2__c = 'a';
        appForOppTestRec1.Date_From_1__c = 'a';
        appForOppTestRec1.Date_From_2__c = 'a';
        appForOppTestRec1.Date_Moved_in_1__c = 'a';
        appForOppTestRec1.Date_Moved_in_2__c = 'a';
        appForOppTestRec1.Date_of_Birth_1__c = 'a';
        appForOppTestRec1.Date_of_Birth_2__c = 'a';
        appForOppTestRec1.Date_Started_1__c = 'a';
        appForOppTestRec1.Date_Started_2__c = 'a';
        appForOppTestRec1.Do_you_have_any_credit_cards__c = 'a';
        appForOppTestRec1.Do_you_have_any_loans_outstanding__c = 'a';
        appForOppTestRec1.Do_you_have_drivers_licence_1__c = 'a';
        appForOppTestRec1.Do_you_have_drivers_licence_2__c = 'a';
        appForOppTestRec1.Do_you_own_a_motor_vehicle__c = 'a';
        appForOppTestRec1.Do_you_receive_other_income_1__c = 'a';
        appForOppTestRec1.Drivers_License_1__c = 'a';
        appForOppTestRec1.Drivers_License_2__c = 'a';
        appForOppTestRec1.Email_Address_2__c = 'a@test.com';
        appForOppTestRec1.Employed_for_more_than_two_years_1__c = 'a';
        appForOppTestRec1.Employed_for_more_than_two_years_2__c = 'a';
        appForOppTestRec1.Entity_Name__c = 'a';
        appForOppTestRec1.Estimated_profit_per_annum__c = 0;
        appForOppTestRec1.Expiry_Date_1__c = 'a';
        appForOppTestRec1.Expiry_Date_2__c = 'a';
        appForOppTestRec1.Finance_Amount__c = 0;
        appForOppTestRec1.Finish_Date_1__c = 'a';
        appForOppTestRec1.Finish_Date_2__c = 'a';
        appForOppTestRec1.First_Name_2__c = 'a';
        appForOppTestRec1.Furniture_Value__c = 0;
        appForOppTestRec1.Home_Phone__c = 'a';
        appForOppTestRec1.Home_Phone_2__c = 'a';
        appForOppTestRec1.Landlord_Name_1__c = 'a';
        appForOppTestRec1.Landlord_Name_2__c = 'a';
        appForOppTestRec1.Landlord_Phone_1__c = 'a';
        appForOppTestRec1.Landlord_Phone_2__c = 'a';
        appForOppTestRec1.Last_Name_2__c = 'a';
        appForOppTestRec1.Length_of_Term__c = 0;
        appForOppTestRec1.Living_more_than_three_years_1__c = 'a';
        appForOppTestRec1.Living_more_than_three_years_2__c = 'a';
        appForOppTestRec1.Marital_Status_1__c = 'a';
        appForOppTestRec1.Marital_Status_2__c = 'a';
        appForOppTestRec1.Mobile_Number_2__c = 'a';
        appForOppTestRec1.Mode_of_Employment_2__c = 'a';
        appForOppTestRec1.Nature_of_Business__c = 'a';
        appForOppTestRec1.Net_Income_2__c = 0;
        appForOppTestRec1.No_of_Directors__c = 0;
        appForOppTestRec1.No_of_People__c = 1;
        appForOppTestRec1.Postcode__c = 'a';
        appForOppTestRec1.Postcode_2__c = 'a';
        appForOppTestRec1.Previous_Employer_Name_1__c = 'a';
        appForOppTestRec1.Previous_Employer_Name_2__c = 'a';
        appForOppTestRec1.Previous_Employer_Phone_1__c = 'a';
        appForOppTestRec1.Previous_Employer_Phone_2__c = 'a';
        appForOppTestRec1.Previous_Mode_of_Employment_1__c = 'a';
        appForOppTestRec1.Previous_Mode_of_Employment_2__c = 'a';
        appForOppTestRec1.Previous_Occupation_1__c = 'a';
        appForOppTestRec1.Previous_Occupation_2__c = 'a';
        appForOppTestRec1.Previous_Postcode_1__c = 'a';
        appForOppTestRec1.Previous_Postcode_2__c = 'a';
        appForOppTestRec1.Previous_Reference_Name_1__c = 'a';
        appForOppTestRec1.Previous_Reference_Name_2__c = 'a';
        appForOppTestRec1.Previous_Residence_Status_1__c = 'a';
        appForOppTestRec1.Previous_Residence_Status_2__c = 'a';
        appForOppTestRec1.Previous_Street_Address_1__c = 'a';
        appForOppTestRec1.Previous_Street_Address_2__c = 'a';
        appForOppTestRec1.Previous_Suburb_1__c = 'a';
        appForOppTestRec1.Previous_Suburb_2__c = 'a';
        appForOppTestRec1.Previous_Work_Address_1__c = 'a';
        appForOppTestRec1.Previous_Work_Address_2__c = 'a';
        appForOppTestRec1.Purchase_Price__c = 0;
        appForOppTestRec1.Reference_Name_1__c = 'a';
        appForOppTestRec1.Reference_Name_2__c = 'a';
        appForOppTestRec1.Start_Date_1__c = 'a';
        appForOppTestRec1.Start_Date_2__c = 'a';
        appForOppTestRec1.Street_Address__c = 'a';
        appForOppTestRec1.Street_Address_2__c = 'a';
        appForOppTestRec1.Suburb__c = 'a';
        appForOppTestRec1.Suburb_2__c = 'a';
        appForOppTestRec1.Super_Value__c = 'a';
        appForOppTestRec1.Title_1__c = 'a';
        appForOppTestRec1.Title_2__c = 'a';
        appForOppTestRec1.Trading_Address__c = 'a';
        appForOppTestRec1.Trading_Name__c = 'a';
        appForOppTestRec1.Trust_Name__c = 'a';
        appForOppTestRec1.Type_of_Asset__c = 'a';
        appForOppTestRec1.Vehicle_Make__c = 'a';
        appForOppTestRec1.Vehicle_Model__c = 'a';
        appForOppTestRec1.Vehicle_Year__c = 'a';
        appForOppTestRec1.Work_Phone__c = 'a';
        appForOppTestRec1.Work_Phone_2__c = 'a';
        
        appForOppTestRec1.First_Name__c = 'Michelle';
        appForOppTestRec1.Last_Name__c = 'Odine';
        appForOppTestRec1.Mobile_Number__c = '0439904537';
        appForOppTestRec1.Email_Address__c = 'bulk21@g.com';
        appForOppTestRec1.No_of_Dependants_1__c = 2;
        appForOppTestRec1.Do_you_own_a_property__c = 'Yes';
        appForOppTestRec1.Mode_of_Employment_1__c = 'Full Time';
        appForOppTestRec1.No_of_Dependants_2__c = 0;
        appForOppTestRec1.Current_Occupation_1__c = 'Developer';
        appForOppTestRec1.Net_Income_1__c = 5000;
        appForOppTestRec1.Partner_Income__c = 4000;
        appForOppTestRec1.Rent_per_month_1__c = 2000;
        appForOppTestRec1.Rent_per_month_2__c = 0;
        appForOppTestRec1.Repayment_Regularity__c = 'Month';
        appForOppTestRec1.Preferred_Repayment__c = 3200;
        appForOppTestRec1.Account__c = Test_DataGeneratorHelper.tstAccount.Id;
        
        //Lelo                          2016-07-04
        appForOppTestRec1.Board_per_Month_1__c = 77777;
        appForOppTestRec1.Board_per_Month_2__c = 88888;
        appForOppTestRec1.Basic_Living_Expenses_Per_Month__c = '99999';
        appForOppTestRec1.Childcare_Child_Maintenance_Per_Month__c = '11111';
        appForOppTestRec1.Mobile_Phone_Internet_Pay_TV_per_Month__c = '22222';
        appForOppTestRec1.Insurance_Expenses_per_Month__c = '33333';
        appForOppTestRec1.Travel_Transport_Expenses_per_Month__c = '44444';
        appForOppTestRec1.Other_Expenses_per_Month__c = '55555';
        appForOppTestRec1.Income_Type_Expenses__c = 'incomeTypeExpenses';
        appForOppTestRec1.Personal_Reference_1_Address__c = 'personal Reference1 Address';
        appForOppTestRec1.Personal_Reference_1_Full_Name__c = 'personalReference1 Full Name';
        appForOppTestRec1.Personal_Reference_1_Phone__c = 'a';
        appForOppTestRec1.Personal_Reference_1_Relationship__c = 'Relationship';
        appForOppTestRec1.Personal_Reference_2_Address__c = 'personalReference2Address';
        appForOppTestRec1.Personal_Reference_2_Full_Name__c = 'personal Reference2 Full_Name';
        appForOppTestRec1.Personal_Reference_2_Phone__c = '4';
        appForOppTestRec1.Personal_Reference_2_Relationship__c = 'Relationship';
        
        appForOppTestRec1.Supporting_Document_1__c = 'supportingDocument1';
        appForOppTestRec1.Supporting_Document_2__c = 'supportingDocument2';
        appForOppTestRec1.Supporting_Document_3__c = 'supportingDocument3';
        appForOppTestRec1.Supporting_Document_4__c = 'supportingDocument4';
        
        appForOppTestRec1.Do_you_expect_any_change_to_your_financi__c = 'yes';
        appForOppTestRec1.Is_There_Anything_You_Want_to_Tell_Us__c = 'anythingYouWantTellUsAboutApp';
        
        appForOppTestRec1.Credit_Status_1__c = 'creditStatus1';
        appForOppTestRec1.Credit_Status_2__c = 'creditStatus2';
        appForOppTestRec1.Current_Residential_Status_1__c = 'currentResidentialStatus1';
        appForOppTestRec1.Current_Residential_Status_2__c = 'currentResidentialStatus2';            
        appForOppTestRec1.Entity_Name__c = 'entityName';
        //Lelo                          2016-07-05
        appForOppTestRec1.Driver_Licence_State_Issue_1__c = 'SA';
        appForOppTestRec1.Driver_Licence_State_Issue_2__c = 'VIC';
        //-
        
        //Test set gender to null 
        //appForOppTestRec1.Gender_1__c = '';

        insert appForOppTestRec1;
        
        system.debug('value of oppTestRec1 before field value assign'+oppTestRec1);
        
        Custom_Opportunity__c oppTestRec2 = new Custom_Opportunity__c();
        
        oppTestRec2.Application__c = appForOppTestRec1.Id;
        
        insert oppTestRec2;
        
        system.debug('value of oppTestRec1.Application__c'+oppTestRec1.Application__c);
        
        //oppTestRec1.Application__r.Type_of_Asset__c = 'test';
        
        //update oppTestRec1;
        
        //system.debug('value of oppWithAppTestRec.Application__r.Type_of_Asset__c'+oppWithAppTestRec.Application__r.Type_of_Asset__c);
        
        system.debug('value of oppTestRec2'+oppTestRec2);
        
        //ApexPages.StandardController stdCon1 = new ApexPages.StandardController(oppWithAppTestRec);
        
        ApexPages.StandardController stdCon1 = new ApexPages.StandardController(oppTestRec2);
        
        system.debug('value of stdCon1'+stdCon1);
        
        OppApplicationExtension oppAppPageCon1 = new OppApplicationExtension(stdCon1);
        
        oppAppPageCon1.typeAsset = null;
        
        oppAppPageCon1.saveDraftVFPage();
                
        oppAppPageCon.saveRecord();

        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
        
        system.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'No odometer reading value entered!');
        
    }

	public static void setupTestData () {
        ABNSettings__c abn = [Select Id, GUID__c, endpoint__c From ABNSettings__c];
        abn.endpoint__c = 'http://example.com/example/test';
        abn.GUID__c = 'd0baa451-a002-4969-b6d1-d2f879fb52db';
        update abn;
    }

    private static void getStaticResourceMock(){
		
        //MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        //    multimock.setStaticResource('https://abr.business-test.gov.au/json/', 'ABNlookupMock');
        //    multimock.setStatusCode(200);
        //    multimock.setHeader('Content-Type', 'application/json');
        //    Test.setMock(HttpCalloutMock.class, multimock);  
		
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockABNlookupResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
    }
    */
}