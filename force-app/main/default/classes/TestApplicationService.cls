@isTest
public class TestApplicationService {
    
    @isTest static void testChangeFieldValues() {
        // Application__c a = makeBasicApplication();
        Application__c a = Test_DataGeneratorHelper.buildCarApp(true);
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        Test.startTest();
        ApplicationService.changeFieldValues(lst);
        Test.stopTest();
    }

    @isTest static void testUpdateRelatedAccount() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        Test.startTest();
        ApplicationService.updateRelatedAccount(lst);
        Test.stopTest();
    }


    /*@isTest static void testShouldUpdateOppApp() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        Test.startTest();
        ApplicationService.shouldUpdateOppApp(a.Status__c, a.Status__c);
        Test.stopTest();
    }*/


    @isTest static void testLinkApplicationWithAccount() {
        List<Application__c> lst = new List<Application__c>();
        Application__c a = makeBasicApplication();
        a.Date_of_Birth_1__c = '05/09/1990';
        Account acc = makeAccount();
        acc.PersonEmail = a.Email_Address__c;
        acc.PersonMobilePhone = a.Mobile_Number__c;
        insert acc;
        
        a.Account__c = acc.Id;
        
        lst.add(a);
        Test.startTest();
        ApplicationService.linkApplication(lst);
        Test.stopTest();
    }

    @isTest static void testLinkApplicationNewLead() {
        Application__c a = makeBasicApplication();
        a.Date_of_Birth_1__c = '05/09/1990';
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        Test.startTest();
        ApplicationService.linkApplication(lst);
        Test.stopTest();
    }

    
    @isTest static void testOpportunityUpdate() {
        Application__c a = makeBasicApplication();
        a.Do_you_own_a_property__c = 'yes';
        
        
        a.Net_Income_1__c = 5000;
        a.Rent_per_month_1__c = 500;
        Custom_Opportunity__c o = makeBasicOpportunity(a);

        Test.startTest();
        for (Integer dep = 0;dep <= 6;dep++) {
            a.No_of_Dependants_1__c = dep;
            ApplicationService.updateOpportunityDataFromApp(o, a);
        }
                
        // Second applicant
        a.No_of_People__c = 2;
        a.First_Name_2__c = 'X';
        a.Last_Name_2__c = 'X';
        a.Email_Address_2__c = 'x@savvy.com';
        a.Rent_per_month_2__c = 250;
        for (Integer dep = 0;dep <= 6;dep++) {
            a.No_of_Dependants_2__c = dep;
            ApplicationService.updateOpportunityDataFromApp(o, a);
        }
        
        // Employment Status
        List<String> empList = new List<String>();
        empList.add('Full Time');
        empList.add('Part Time');
        empList.add('Casual');
        empList.add('Self Employed');
        empList.add('Contract');
        empList.add('Other');
        for (String e: empList) {
            a.Mode_of_Employment_1__c = e;
            ApplicationService.updateOpportunityDataFromApp(o, a);
        }
        
        // Payment frequency 
        a.No_of_People__c = 2;
        a.Net_Income_2__c = 2500;
        List<String> freList = new List<String>();
        freList.add('Weekly');
        freList.add('Fortnightly');
        freList.add('Monthly');
        for (String f: freList) {
            a.Payment_Frequency_1__c = f;
            a.Payment_Frequency_2__c = f;
            ApplicationService.updateOpportunityDataFromApp(o, a);
        }
        
        // Credict cards repayments
        a.Preferred_Repayment__c = 100.0;
        freList = new List<String>();
        freList.add('Week');
        freList.add('Fortnight');
        freList.add('Month');
        for (String f: freList) {
            a.Repayment_Regularity__c = f;
            ApplicationService.updateOpportunityDataFromApp(o, a);
        }

        Test.stopTest();
    }
    

    @isTest static void testGetApplicationAssetType() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Test.startTest();
        ApplicationService.getApplicationAssetType(null);
        ApplicationService.getApplicationAssetType(a.Id);

        ApplicationService.Asset x = new ApplicationService.Asset('Property');
        x.assetType = null;
        x.detail = null;
        x.value = null;
        x.hasLoan = null;
        x.loanType = null;
        x.lender = null;
        x.amountOwing = null;
        x.payment = null;
        x.frequency = null;
        x.isPayout = null;
        x.order = null;

        Test.stopTest();
    }

    @isTest static void testGetApplicationLoans() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Test.startTest();
        ApplicationService.getApplicationLoans(a.Id);
        Test.stopTest();
    }

    /*@isTest static void testUpdateOpportunityDataFromApp() {
        Application__c a = makeBasicApplication();
        Custom_Opportunity__c o = makeBasicOpportunity(a);
        Test.startTest();
        ApplicationService.updateOpportunityDataFromApp(o, a);
        Test.stopTest();
    }*/
    
    @isTest static void testPrepareServicingInfo() {
        List<Application__c> lst = new List<Application__c>();
        // Application
        Application__c a = makeBasicApplication();
        a.Rent_per_month_1__c = 1200.0;
        a.Current_Residence_Status_1__c = 'Renting(Agent)';
        a.No_of_People__c = 2;
        a.Net_Income_2__c = 2000;
        a.Payment_Frequency_2__c = 'Monthly';
        lst.add(a);

        Application__c a2 = makeBasicApplication();
        a2.Board_per_month_1__c = 1200.0;
        a2.Current_Residence_Status_1__c = 'Boarding';
        lst.add(a2);

        insert lst;
        // Income
        List<Application_Income__c> incomelst = new List<Application_Income__c>();
        Application_Income__c income = makeOtherIncome('1');
        income.Application__c = a.Id;
        incomelst.add(income);
        income = makeOtherIncome('2');
        income.Application__c = a.Id;
        incomelst.add(income);
        insert incomelst;
        // Other Assets Loans
        Application_Other_Asset__c asset = makeOtherAsset(ApplicationService.VEHICLE_ASSET_TYPE);
        asset.Has_Loan__c = 'Y';
        asset.Payment__c = 500;
        asset.Frequency__c = 'Monthly';
        asset.Application__c = a.Id;
        insert asset;
        // Application Loans
        List<Application_Loan__c> loanList = new List<Application_Loan__c>();
        Application_Loan__c loan = makeLoan('Mortgage');
        loan.Application__c = a.Id;
        loanList.add(loan);
        loan = makeLoan('Personal Loan');
        loan.Application__c = a.Id;
        loanList.add(loan);
        insert loanList;

        Test.startTest();
        ApplicationService.prepareServicingInfo(a.Id);
        ApplicationService.prepareServicingInfo(a2.Id);
        Test.stopTest();
    }

    @isTest static void testGetAssetDetail() {
        Application__c a = makeBasicApplication();
        insert a;
        Application_Asset_Detail__c asset = makeAssetDetail();
        insert asset;
        Custom_Opportunity__c o = makeBasicOpportunity(a);
        o.Application_AssetDetail__c = asset.Id;
        insert o;        
        Test.startTest();
        System.assert(ApplicationService.getAssetDetail(o.Id) != null);
        Test.stopTest();
    }

    @isTest static void testGetAssetDetailYear() {
        Application__c a = makeBasicApplication();
        insert a;
        Application_Asset_Detail__c asset = makeAssetDetail();
        insert asset;
        Custom_Opportunity__c o = makeBasicOpportunity(a);
        o.Application_AssetDetail__c = asset.Id;
        insert o;        
        Test.startTest();
        System.assert(ApplicationService.getAssetDetailYear(o.Id) > 0);
        Test.stopTest();
    }

    @isTest static void testGetApplicationIncomeMap() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Income__c income = makeOtherIncome('1');
        income.Application__c = a.Id;
        insert income;
        Test.startTest();
        ApplicationService.getApplicationIncomeMap(a.Id);
        Test.stopTest();
    }

    @isTest static void testGetApplicationIncomeMap2() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Income__c income = makeOtherIncome('1');
        income.Application__c = a.Id;
        insert income;
        Test.startTest();
        ApplicationService.getApplicationIncomeMap2(a.Id);
        Test.stopTest();
    }

    @isTest static void testGetApplicationCreditCards() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Test.startTest();
        ApplicationService.getApplicationCreditCards(a.Id);
        Test.stopTest();
    }

    @isTest static void testGetApplicationTotalCreditCards() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Credit_Card__c cc = makeCreditCard(20000);
        cc.Application__c = a.Id;
        insert cc;
        Test.startTest();
        ApplicationService.getApplicationTotalCreditCards(a.Id);
        Test.stopTest();
    }

    @isTest static void testGetApplicationOtherAssets() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Test.startTest();
        ApplicationService.getApplicationOtherAssets(a.Id);
        ApplicationService.getApplicationOtherAssets(a.Id, 'Car');
        Test.stopTest();
    }

    @isTest static void testGetApplicationTotalMortgage() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Other_Asset__c asset = makeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);
        asset.Application__c = a.Id;
        asset.Has_Loan__c = 'Y';
        asset.Payment__c = 1500.0;
        asset.Frequency__c = 'Monthly';
        insert asset;
        Test.startTest();
        ApplicationService.getApplicationTotalMortgage(a.Id);
        Test.stopTest();
    }

    @isTest static void testGetApplicationOtherAssetsMap() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Other_Asset__c asset = makeOtherAsset(ApplicationService.PROPERTY_ASSET_TYPE);
        asset.Application__c = a.Id;
        insert asset;
        Test.startTest();
        ApplicationService.getApplicationOtherAssetsMap(a.Id);
        Test.stopTest();
    }

    @isTest static void testHasVerifiableCredit() {
        Application__c a = makeBasicApplication();
        List<Application__c> lst = new List<Application__c>();
        lst.add(a);
        insert lst;
        Application_Other_Asset__c asset = makeOtherAsset('Property Asset');
        asset.Application__c = a.Id;
        insert asset;
        Test.startTest();
        ApplicationService.hasVerifiableCredit(a.Id);
        Test.stopTest();
    }

    @isTest static void testTriggerHandler() {
        Test.startTest();
        Application__c a = makeBasicApplication();
        insert a;
        a = [Select Id, No_of_People__c, Gender_1__c, Postcode__c From Application__c Where Id = :a.Id];
        a.No_of_People__c = 2;
        a.Gender_1__c = 'M';
        a.Postcode__c = '5000';
        update a;
        List<Application__c> apps = [
          Select 
            First_Name__c, 
            Last_Name__c,
            Mobile_Number__c,
            Email_Address__c,
            External_Lead__c,
            Gender_1__c, 
            Postcode__c 
          From Application__c Where Id = :a.Id
        ];

        ApplicationTriggerHandler trg = new ApplicationTriggerHandler();
        trg.onBeforeUpdate(null, apps, null, null);

        a = apps.get(0);
        delete a;        
        Test.stopTest();
    }

    private static Application__c makeBasicApplication() {
        String sufix = String.valueOf(Datetime.now().millisecond());
        Application__c a = new Application__c();
        a.First_Name__c = 'Tony';
        a.Last_Name__c = 'Stark';
        a.Finance_Amount__c = 25000.0;
        a.Mobile_Number__c = '0477000' + sufix;
        a.Email_Address__c = sufix + 'v15@test-stark.com';
        a.Status__c = 'F';
        a.Type_of_Asset__c = 'Car';
        a.Credit_Status_1__c = 'Excellent';
        a.No_of_People__c = 0;
        a.Application_Type__c = 'Personal';
        a.Marital_Status_1__c = 'Single';
        a.No_of_Dependants_1__c = 0;
        a.Net_Income_1__c = 5000;

        return a;
    }

    private static Custom_Opportunity__c makeBasicOpportunity(Application__c a) {
        // String sufix = String.valueOf(Datetime.now().millisecond());
        // Application__c a = new Application__c();
        // a.First_Name__c = 'Tony';
        // a.Last_Name__c = 'Stark';
        // a.Finance_Amount__c = 25000.0;
        // a.Mobile_Number__c = '0477000' + sufix;
        // a.Email_Address__c = sufix + 'v15@test-stark.com';
        // a.Status__c = 'Finished';
        // a.Type_of_Asset__c = 'Car';
        // a.Credit_Status_1__c = 'Excellent';
        // a.No_of_People__c = 0;
        // a.Application_Type__c = 'Personal';
        return new Custom_Opportunity__c();
    }

    private static Application_Other_Asset__c makeOtherAsset(String recordType) {
        Id recordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(recordType);
        Application_Other_Asset__c r = new Application_Other_Asset__c();
        r.RecordTypeId = recordTypeId;
        r.Has_Loan__c = 'N';
        r.Description__c = 'X';
        r.Value__c = 10000;
        return r;
    }

    private static Application_Credit_Card__c makeCreditCard(Decimal limitAmount) {
        Application_Credit_Card__c r = new Application_Credit_Card__c();
        r.Amount_Owing__c = 1000;
        r.Issuer__c = 'X';
        r.Limit__c = limitAmount;
        return r;
    }

    private static Application_Income__c makeOtherIncome(String applicant) {
        Application_Income__c r = new Application_Income__c();
        r.Applicant__c = applicant;
        r.Detail__c = 'X';
        r.Frequency__c = 'Monthly';
        r.Income__c = 5000;
        r.Order__c = 0;
        r.Type__c = 'Other';
        return r;
    }

    
    private static Application_Asset_Detail__c makeAssetDetail() {
        Application_Asset_Detail__c r = new Application_Asset_Detail__c();
        r.Type__c = 'Car';
        r.Type_Loan__c = 'Consumer';
        r.Year__c = Date.today().year();
        r.Make__c = 'AUDI';
        r.Model__c = 'A5';
        r.Lender__c = 'Pepper';
        r.Condition__c = 'new';
        return r;
    }

    private static Application_Loan__c makeLoan(String loanType) {
        Application_Loan__c r = new Application_Loan__c();
        r.Type__c = loanType;
        r.Lender__c = 'X';
        r.Amount_Owing__c = 10000;
        r.Payment__c = 100;
        r.Frequency__c = 'Weekly';
        r.Order__c = 0;
        return r;
    }

    private static Account makeAccount() {
        Account r = new Account(
            RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Person Account'), 
            FirstName = 'Tony', 
            LastName = 'Stark', 
            PersonOtherStreet = 'Test', 
            PersonOtherCity = 'Test', 
            PersonOtherState = 'Test', 
            PersonOtherPostalCode = 'Test', 
            PersonEmail = 'QADepartment@Test.com', 
            Portal_UID__c = '3245657sadsfdgfh',
            Phone = '000000');
        return r;
    }

}