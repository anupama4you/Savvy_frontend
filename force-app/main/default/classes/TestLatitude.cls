@isTest(SeeAllData=true)
public class TestLatitude {

    public static testMethod void Latitude(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        a.Applicant_2_living_in_the_same_address__c = 'Yes';
        a.Marital_Status_1__c = 'Married';
		a.Marital_Status_2__c = 'Married';
        a.Do_you_have_drivers_licence_1__c = 'No';
        a.Do_you_have_drivers_licence_2__c = 'No';
        a.Work_Phone__c = null;
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AUS', 'Own Outright', previousAddress);
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', false, true, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', false, true, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, true);
        Test_DataGeneratorHelper.reloadOpportunity();
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        
        c.Amount_Owing__c = 1;
        c.Issuer__c = 'i';
        c.Limit__c = 1;
        c.Application__c = a.Id;
        
        insert c;
        
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        o.RecordTypeId = RecordTypes.get('Vehicle Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        
        insert o;
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        insert o;
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Both Applicants';
        
        insert o;
                
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        Application_Loan__c loan = new Application_Loan__c();
        loan.Type__c = 'Payday Loan';
        loan.Amount_Owing__c = 1;
        loan.Lender__c = 'l';
        loan.Payment__c = 1;
        loan.Application__c = a.Id;
        
        insert loan;

        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');

        LatitudeAPIService.getName('oppName', 'applicationId', 201);
        LatitudeAPIService.getName('oppName', 'applicationId', 401);
    }

    public static testMethod void Latitude2(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        Application_Servicing__c s = new Application_Servicing__c();
        s.Gross_Annual_Income_1__c = 1;
        s.Gross_Annual_Income_1_Second_Job__c = 1;
        s.Gross_Annual_Income_2__c = 1;
        s.Gross_Annual_Income_2_Second_Job__c = 1;
        insert s;
        Application__c a = TestLatitude.createApplication();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        Test_DataGeneratorHelper.tstOpportunity.ApplicationServicing__c = s.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AFG', 'Own Outright', previousAddress);
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'OVS', true, true, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'OVS', true, true, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        
        c.Amount_Owing__c = 1;
        c.Issuer__c = 'i';
        c.Limit__c = 1;
        c.Application__c = a.Id;
        
        insert c;
        
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        o.RecordTypeId = RecordTypes.get('Vehicle Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        
        insert o;
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        insert o;
        
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Both Applicants';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        Application_Loan__c loan = new Application_Loan__c();
        loan.Type__c = 'Payday Loan';
        loan.Amount_Owing__c = 1;
        loan.Lender__c = 'l';
        loan.Payment__c = 1;
        loan.Application__c = a.Id;
        
        insert loan;

        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
    
    public static testMethod void Latitude3(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AUS', 'Own Outright', previousAddress);
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'OVS', true, false, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'OVS', true, false, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        
        c.Amount_Owing__c = 1;
        c.Issuer__c = 'i';
        c.Limit__c = 1;
        c.Application__c = a.Id;
        
        insert c;
        
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        o.RecordTypeId = RecordTypes.get('Vehicle Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        
        insert o;
        o = new Application_Other_Asset__c();
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        insert o;
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Both Applicants';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        Application_Loan__c loan = new Application_Loan__c();
        loan.Type__c = 'Payday Loan';
        loan.Amount_Owing__c = 1;
        loan.Lender__c = 'l';
        loan.Payment__c = 1;
        loan.Application__c = a.Id;
        
        insert loan;
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
      
    public static testMethod void Latitude4(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AFG', 'Own Outright', previousAddress);
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', true, false, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', true, false, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        
        c.Amount_Owing__c = 1;
        c.Issuer__c = 'i';
        c.Limit__c = 1;
        c.Application__c = a.Id;
        
        insert c;
        
        Application_Other_Asset__c o = new Application_Other_Asset__c();
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        o.RecordTypeId = RecordTypes.get('Vehicle Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '2';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        Application_Loan__c loan = new Application_Loan__c();
        loan.Type__c = 'Payday Loan';
        loan.Amount_Owing__c = 1;
        loan.Lender__c = 'l';
        loan.Payment__c = 1;
        loan.Application__c = a.Id;
        
        insert loan;
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
    
    public static void LatitudeTestService(Integer json){
        String endpoint1 = APIServiceManager.getParameterService(LatitudeAPIService.PARAM_ENDPOINT1);
        String endpoint2 = APIServiceManager.getParameterService(LatitudeAPIService.PARAM_ENDPOINT2);
        String body;
        Integer code;
        if(json == 1){
            body = '{"applicationId": "12345"}'; 
            code = 201;  
        }
        
        if(json == 3){
            body = '{"message": "string"}';  
            code = 400;
        }
        
        if(json == 3){
            body = '{"errors": [{"field": "string","reason": "string"}],"message": "string"}';  
            code = 422;
        }
        
        SingleRequestMock applicationResp = new SingleRequestMock(200,
                                                                  'Complete',
                                                                  '{"access_token":"eyJraWQiOiJqRlwvYjhtYkxWeitFcU1sWGFJZUc1UkhZUExYcDNFaFJhN2hiYXU4V3VtVT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0YmtrNWM5MmRyMGhybGRoaGJmOWU3amFsayIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoib3JpZ2luYXRpb25cL21vdG9yX2xvYW46bm90aWZpY2F0aW9uX3N1YnNjcmliZSBvcmlnaW5hdGlvblwvbW90b3JfbG9hbjphcHBsaWNhdGlvbl9zdWJtaXQgb3JpZ2luYXRpb25cL21vdG9yX2xvYW46YXBwbGljYXRpb25fY3JlYXRlIiwiYXV0aF90aW1lIjoxNjE4MzgzOTc4LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtc291dGhlYXN0LTIuYW1hem9uYXdzLmNvbVwvYXAtc291dGhlYXN0LTJfSGZEb0VrZVNoIiwiZXhwIjoxNjE4Mzg3NTc4LCJpYXQiOjE2MTgzODM5NzgsInZlcnNpb24iOjIsImp0aSI6ImYyMjAwNDQ5LWQ0OGEtNGFkYi1iMDk3LTEwNmZmM2I1NmZmOSIsImNsaWVudF9pZCI6IjRia2s1YzkyZHIwaHJsZGhoYmY5ZTdqYWxrIn0.l5txcdvvO7Ts2wTfdVDHkbBaUvbMR-tabAZr52j0dLcl5faHJFi0ffY-Y9L0sT5koEYlqfKFkAiAQtd_zNmVvd3a60LO0DR-WWEEx7ZXFwor1k5CV_667AKSRoofzukiciusSlZYo0jU0SNm3U7oNMlrOz0lErBotwhYbYSunRtVnplIxKOemcEL2kwCWBrHYPajagkW7KdkEzbaPLOzLHmYOqfUPc0o3BttkJ6ppIVlnepyLb7w2cAKfSvZwaOipIcjmQIE80Izwlgpl4Hy_9skQ5Hw9vttmdWiCyV-oqMbredcnCkITnizJmJm5n-iWd60pdTarNoSfeew_I6HRQ","expires_in":3600,"token_type":"Bearer"}',
                                                                  null);
        
        SingleRequestMock applicationResp2 = new SingleRequestMock(code,
                                                                   'Complete',
                                                                   body,
                                                                   null);
        
        Map<String, HttpCalloutMock> endpoint2TestResp =
            new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endpoint1+'/oauth2/token', applicationResp);
        endpoint2TestResp.put(endpoint2+'/broker/application', applicationResp2);
        
        HttpCalloutMock multiCalloutMock =
            new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);	
    }
    
    public static void LatitudeTestApp(Application__c a, String licence){
        a.Do_you_have_drivers_licence_1__c = licence;
        a.Type_of_Licence_1__c = 'Provisional';
        a.Expiry_Date_1__c = '01/01/2022';
        a.Do_you_expect_any_change_to_your_financi__c = 'Yes';
        a.No_of_Dependants_1__c = 1;
        a.Current_Residential_Status_1__c = 'Australian Citizen';
        a.Marital_Status_1__c = 'Single';
        a.Payment_Frequency_1__c = 'Monthly';
        
        a.Do_you_have_drivers_licence_2__c = licence;
        a.Type_of_Licence_2__c = 'Provisional';
        a.Expiry_Date_2__c = '01/01/2022';
        a.Gender_2__c = 'F';
        a.No_of_Dependants_2__c = 2;
        a.Current_Residential_Status_2__c = 'Australian Citizen';
        a.Marital_Status_2__c = 'Single';
        a.Title_2__c = 'Mr';
        a.Date_of_Birth_2__c = '01/01/2022';
        a.Payment_Frequency_2__c = 'Monthly';
        a.Net_Income_1__c = 1;
        a.Net_Income_2__c = 1; 
    }
    
    public static Application__c createApplication() {
        
        Application__c a = new Application__c();
        a.Title_1__c = 'Mr';
        a.Name = 'd';
        a.Email_Address__c = 'testQADepartment@savvy.com.au';
        a.First_Name__c = 'Lelo';
        a.Middle_Name__c = 'Joseph';
        a.Last_Name__c = 'Lelos';
        a.Mobile_Number__c = '042588';
        a.Home_Phone__c = '34232';
        a.Work_Phone__c = '2342342';
        a.Business_Structure__c = 'Company';
        a.Application_Type__c = 'Business';
        a.No_of_People__c = 2;
        a.Driver_Licence_State_Issue_1__c = 'NSW';
        
        a.Suburb__c = 'NSW';
        
        a.First_Name_2__c = 'HJ';
        a.Last_Name_2__c = 'HJ';
        a.Mobile_Number_2__c = '042588';
        a.Mobile_Number_2__c = '45464';
        a.Home_Phone_2__c = '34232';
        a.Work_Phone_2__c = '2342342';
        
        a.Driver_Licence_State_Issue_2__c = 'NSW';
        
        a.Date_of_Birth_1__c = '16/06/1996';
        a.Gender_1__c = 'M';
        a.Postcode__c = '5001';
        a.Suburb__c = 'Adelaide';
        
        //Update NWC Data HJ 04-09-2018 - I
        a.Type_of_Asset__c = 'Car';
        //Update NWC Data HJ 04-09-2018 - F
        
        //Update HJ 20-06-2018 -I
        a.Ages_of_Dependants_1__c = '1,10';
        
        a.Personal_Reference_1_Relationship__c = 'Friend';
        a.Personal_Reference_1_Full_Name__c = 'Reference 1';
        a.Personal_Reference_1_Phone__c = '098345';
        a.Personal_Reference_1_Address__c = '12|6 | Kopoola | Crescent | Gilles Plains |NSW| 5086';
        
        a.Personal_Reference_2_Relationship__c = 'Friend2';
        a.Personal_Reference_2_Full_Name__c = 'Reference 2';
        a.Personal_Reference_2_Phone__c = '098332';
        a.Personal_Reference_2_Address__c = '1 |61 | Kopoola | Crescent | Gilles Plains |NSW| 5026';
        
        //Applicant_2
        a.Driver_Licence_State_Issue_2__c = 'NSW';
        
        //Full PepperAPI LibertyAPI No Company
        a.Application_Type__c = 'Personal';
        //Update HJ 20-06-2018 -F
        
        return a;
    }
    
    public static void LatitudeTestEmployment(Application__c a, String applicant, String employmentType, String employmentTypeSecondJob,String countryEmployment, Boolean secondJob, Boolean previousEmployment1, Boolean previousEmployment2){
        
        if('1'.equals(applicant)){
            a.Mode_of_Employment_1__c = employmentType;
            a.Date_Started_1__c = '01/01/2021';
            a.Current_Work_State_1__c = 'ACT';
            a.Current_Work_Unit_Number_1__c = '1';		
            a.Current_Work_Street_Number_1__c = '1';
            a.Current_Work_Address_1__c = 'a';
            a.Current_Work_Street_Type_1__c = 'ST';
        }
        
        if('2'.equals(applicant)){
            a.Mode_of_Employment_2__c = employmentType;
            a.Date_Started_2__c = '01/01/2021';
            a.Current_Work_State_2__c = 'ACT';
            a.Current_Work_Unit_Number_2__c = '1';		
            a.Current_Work_Street_Number_2__c = '1';
            a.Current_Work_Address_2__c = 'a';
            a.Current_Work_Street_Type_2__c = 'ST';
        }
        
        Application_Employment__c e;
        
        if(secondJob){
            e = new Application_Employment__c();
            
            e.Type__c = 'Second Job';
            e.Applicant__c = applicant;
            e.Employment_Type__c = employmentTypeSecondJob;
            e.Start_Date__c = Date.parse('01/01/2021');
            e.State__c = 'ACT';
            e.Application__c = a.Id;
            e.Frequency__c = 'Monthly';
            e.Income__c = 1;
            e.Unit_Number__c = '1';		
            e.Street_Number__c = '1';
            e.Work_Address__c = 'a';
            e.Street_Type__c = 'ST';
            
            insert e;
        }
        
        if(previousEmployment1){
            if('1'.equals(applicant)){
                a.Start_Date_1__c = '01/01/2019';
                a.Finish_Date_1__c = '01/01/2020';
                a.Previous_Mode_of_Employment_1__c = employmentType;
                a.Previous_Work_Country_1__c = countryEmployment;
                a.Previous_Work_State_1__c = 'ACT';
                a.Previous_Work_Unit_Number_1__c = '1';
                a.Previous_Work_Street_Number_1__c = '1';
                a.Previous_Work_Address_1__c = 'a';
                a.Previous_Work_Street_Type_1__c = 'ST';
            }
            
            if('2'.equals(applicant)){
                a.Start_Date_2__c = '01/01/2019';
                a.Finish_Date_2__c = '01/01/2020';
                a.Previous_Mode_of_Employment_2__c = employmentType;
                a.Previous_Work_Country_2__c = countryEmployment;
                a.Previous_Work_State_2__c = 'ACT';
                a.Previous_Work_Unit_Number_2__c = '1';
                a.Previous_Work_Street_Number_2__c = '1';
                a.Previous_Work_Address_2__c = 'a';
                a.Previous_Work_Street_Type_2__c = 'ST';
            }
        }
        
        if(previousEmployment2){
            
            e = new Application_Employment__c();
            
            e.Type__c = 'Previous Job';
            e.Applicant__c = applicant;
            e.Employment_Type__c = employmentType;
            e.Start_Date__c = Date.parse('01/10/2018');
            e.Finish_Date__c = Date.parse('01/12/2018');
            e.State__c = 'ACT';
            e.Country__c = countryEmployment;
            e.Application__c = a.Id;
            e.Unit_Number__c = '1';		
            e.Street_Number__c = '1';
            e.Work_Address__c = 'a';
            e.Street_Type__c = 'ST';
            
            insert e;
            
            e = new Application_Employment__c();
            
            e.Type__c = 'Previous Job';
            e.Applicant__c = applicant;
            e.Employment_Type__c = employmentType;
            e.Start_Date__c = Date.parse('01/01/2018');
            e.Finish_Date__c = Date.parse('01/09/2018');
            e.State__c = 'ACT';
            e.Country__c = countryEmployment;
            e.Application__c = a.Id;
            e.Unit_Number__c = '1';		
            e.Street_Number__c = '1';
            e.Work_Address__c = 'a';
            e.Street_Type__c = 'ST';
            
            insert e;
            
            e = new Application_Employment__c();
            
            e.Type__c = 'Previous Job';
            e.Applicant__c = applicant;
            e.Employment_Type__c = employmentType;
            e.Start_Date__c = Date.parse('01/11/2017');
            e.Finish_Date__c = Date.parse('01/12/2017');
            e.State__c = 'ACT';
            e.Country__c = countryEmployment;
            e.Application__c = a.Id;
            e.Unit_Number__c = '1';		
            e.Street_Number__c = '1';
            e.Work_Address__c = 'a';
            e.Street_Type__c = 'ST';
            
            insert e;
            
            e = new Application_Employment__c();
            
            e.Type__c = 'Previous Job';
            e.Applicant__c = applicant;
            e.Employment_Type__c = employmentType;
            e.Start_Date__c = Date.parse('01/09/2017');
            e.Finish_Date__c = Date.parse('01/10/2017');
            e.State__c = 'ACT';
            e.Country__c = countryEmployment;
            e.Application__c = a.Id;
            e.Unit_Number__c = '1';		
            e.Street_Number__c = '1';
            e.Work_Address__c = 'a';
            e.Street_Type__c = 'ST';
            
            insert e; 
        }
        
        update a;
    }

    public static void LatitudeTestResidential(Custom_Opportunity__c o, Application__c a, String countryResidential, String currentResidenceStatus, Boolean[] previousAddress){
        a.Unit_Number__c = '1';
        a.Street_Number__c = '1';
        a.Street_Address__c = 'a';
        a.Street_Type__c = 'ST';
        a.State__c = 'ACT';
        a.Date_Moved_in_1__c = '01/01/2021';
        a.Current_Residence_Status_1__c = currentResidenceStatus;
        a.Residential_Payment_Frequency_1__c = 'Monthly';
        a.Rent_per_month_1__c = 1;
        
        if(previousAddress[0]){
            a.Previous_Unit_Number_1__c = '1';
            a.Previous_Street_Number_1__c = '1';
            a.Previous_Street_Address_1__c = 'a';
            a.Previous_Street_Type_1__c = 'ST';
            a.Previous_State_1__c = 'ACT';
            a.Date_From_1__c = '01/12/2020';
            a.Previous_Residence_Status_1__c = 'Renting(Agent)';
            a.Previous_Country_1__c = countryResidential;
        }
        
        if(previousAddress[1]){
            a.Previous_Unit_Number_1b__c = '1';
            a.Previous_Street_Number_1b__c = '1';
            a.Previous_Street_Address_1b__c = 'a';
            a.Previous_Street_Type_1b__c = 'ST';
            a.Previous_State_1b__c = 'ACT';
            a.Date_From_1b__c = '01/09/2020';
            a.Previous_Residence_Status_1b__c = 'Renting(Agent)';
            a.Previous_Country_1b__c = countryResidential;
        }
        
        if(previousAddress[2]){
            a.Previous_Unit_Number_1c__c = '1';
            a.Previous_Street_Number_1c__c = '1';
            a.Previous_Street_Address_1c__c = 'a';
            a.Previous_Street_Type_1c__c = 'ST';
            a.Previous_State_1c__c = 'ACT';
            a.Date_From_1c__c = '01/06/2020';
            a.Previous_Residence_Status_1c__c = 'Renting(Agent)';
            a.Previous_Country_1c__c = countryResidential;
        }
        
        if(previousAddress[3]){
            a.Previous_Unit_Number_1d__c = '1';
            a.Previous_Street_Number_1d__c = '1';
            a.Previous_Street_Address_1d__c = 'a';
            a.Previous_Street_Type_1d__c = 'ST';
            a.Previous_State_1d__c = 'ACT';
            a.Date_From_1d__c = '01/03/2020';
            a.Previous_Residence_Status_1d__c = 'Renting(Agent)';
            a.Previous_Country_1d__c = countryResidential;
        }
        
        if(previousAddress[4]){
            a.Previous_Unit_Number_1e__c = '1';
            a.Previous_Street_Number_1e__c = '1';
            a.Previous_Street_Address_1e__c = 'a';
            a.Previous_Street_Type_1e__c = 'ST';
            a.Previous_State_1e__c = 'ACT';
            a.Date_From_1e__c = '01/01/2020';
            a.Previous_Residence_Status_1e__c = 'Renting(Agent)';
            a.Previous_Country_1e__c = countryResidential;
        }
        
        a.Unit_Number_2__c = '1';
        a.Street_Number_2__c = '1';
        a.Street_Address_2__c = 'a';
        a.Street_Type_2__c = 'ST';
        a.State_2__c = 'ACT';
        a.Date_Moved_in_2__c = '01/01/2021';
        a.Current_Residence_Status_2__c = currentResidenceStatus;
        a.Residential_Payment_Frequency_2__c = 'Monthly';
        a.Rent_per_month_2__c = 1;
        
        if(previousAddress[5]){
            a.Previous_Unit_Number_2__c = '1';
            a.Previous_Street_Number_2__c = '1';
            a.Previous_Street_Address_2__c = 'a';
            a.Previous_Street_Type_2__c = 'ST';
            a.Previous_State_2__c = 'ACT';
            a.Date_From_2__c = '01/12/2020';
            a.Previous_Residence_Status_2__c = 'Renting(Agent)';
            a.Previous_Country_2__c = countryResidential;
        }
        
        if(previousAddress[6]){
            a.Previous_Unit_Number_2b__c = '1';
            a.Previous_Street_Number_2b__c = '1';
            a.Previous_Street_Address_2b__c = 'a';
            a.Previous_Street_Type_2b__c = 'ST';
            a.Previous_State_2b__c = 'ACT';
            a.Date_From_2b__c = '01/09/2020';
            a.Previous_Residence_Status_2b__c = 'Renting(Agent)';
            a.Previous_Country_2b__c = countryResidential;
        }
        
        if(previousAddress[7]){
            a.Previous_Unit_Number_2c__c = '1';
            a.Previous_Street_Number_2c__c = '1';
            a.Previous_Street_Address_2c__c = 'a';
            a.Previous_Street_Type_2c__c = 'ST';
            a.Previous_State_2c__c = 'ACT';
            a.Date_From_2c__c = '01/06/2020';
            a.Previous_Residence_Status_2c__c = 'Renting(Agent)';
            a.Previous_Country_2c__c = countryResidential;
        }
        
        if(previousAddress[8]){
            a.Previous_Unit_Number_2d__c = '1';
            a.Previous_Street_Number_2d__c = '1';
            a.Previous_Street_Address_2d__c = 'a';
            a.Previous_Street_Type_2d__c = 'ST';
            a.Previous_State_2d__c = 'ACT';
            a.Date_From_2d__c = '01/03/2020';
            a.Previous_Residence_Status_2d__c = 'Renting(Agent)';
            a.Previous_Country_2d__c = countryResidential;
        }
        
        if(previousAddress[9]){
            a.Previous_Unit_Number_2e__c = '1';
            a.Previous_Street_Number_2e__c = '1';
            a.Previous_Street_Address_2e__c = 'a';
            a.Previous_Street_Type_2e__c = 'ST';
            a.Previous_State_2e__c = 'ACT';
            a.Date_From_2e__c = '01/01/2018';
            a.Previous_Residence_Status_2e__c = 'Renting(Agent)';
            a.Previous_Country_2e__c = countryResidential;
        }
        
        update a;
        
        Application_Quoting__c q = new Application_Quoting__c();
        q.Application__c = a.Id;
        q.Opportunity__c = o.Id;
        q.Term__c = 36;
        q.Repayment_Monthly__c = 1;
        q.DOF__c = 1;
        q.Payout_On__c = 1;
        q.Deposit__c = 1;
        q.Trade_In__c =  1;
        q.Vehicle_Price__c = 1;
        q.Residual_Value__c = 1;
        q.Payment__c = 'Arrears';
        q.Goods_type__c = 'CAR';
        q.NAF__c = 1;
        insert q;
        
        Application_Extra_Data__c extra = new Application_Extra_Data__c();
        extra.Category__c = 'Lender';
        extra.Data__c = 'n';
        extra.Application__c = a.Id;
        insert extra;
        
    }
    
    public static void asset(String asset, Custom_Opportunity__c o, Boolean testAsset){
        Application_Asset_Detail__c aD = new Application_Asset_Detail__c();
        
        aD.Year__c = 2021;
        aD.Type__c = 'Car';
        aD.Condition__c = 'used';
        aD.Variant__c = '1';
        if(testAsset){
            aD.Actual_KM__c = 1;
        }else{
            aD.Actual_KM__c = 0;
            aD.Rego_State__c = 'SA';    
        }
        
        insert aD;
        
        if('Car'.equals(asset) || 'Motorbike'.equals(asset) || 'Caravan'.equals(asset)){
            Glass_Make__c make = new Glass_Make__c();
            make.Code__c = 'c';
            insert make;
            
            Glass_Model__c m = new Glass_Model__c();
            m.Make__c = make.id;
            m.Code__c = 'c';
            insert m;
            
            Glass_Variant__c g = new Glass_Variant__c();
            g.NVIC__c = '1';
            g.Code__c = aD.Variant__c;
            g.Model__c = m.Id;
            
            insert g;
        }
        
        o.Application_AssetDetail__c = aD.Id;
        update o;
    }

    public static testMethod void Latitude5(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        insert a;
        a.Application_Type__c = 'Business';
        update a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        Application_Servicing__c s = new Application_Servicing__c();
        s.Gross_Annual_Income_1__c = 1;
        s.Gross_Annual_Income_2__c = 1;
        insert s;
		
		Test_DataGeneratorHelper.tstOpportunity.ApplicationServicing__c = s.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        a.Applicant_2_living_in_the_same_address__c = 'Yes';
        a.Marital_Status_1__c = 'Married';
		a.Marital_Status_2__c = 'Married';
		a.No_of_Dependants_1__c = 1;
		a.No_of_Dependants_2__c = 1;
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AUS', 'Mortgage', previousAddress);
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        
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
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Both Applicants';
        
        insert o;
        
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
 
    public static testMethod void Latitude6(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        insert a;
        a.Application_Type__c = 'Business';
        update a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AUS', 'Mortgage', previousAddress);
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        
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
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Applicant 1';
        
        insert o;
        
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
    
    public static testMethod void Latitude7(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        insert a;
        a.Application_Type__c = 'Business';
        a.Current_Residence_Status_1__c = 'Renting(Agent)';
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        a.Do_you_have_drivers_licence_1__c = 'Yes';
        a.Do_you_have_drivers_licence_2__c = 'Yes';
        update a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Application_Quoting__c q = new Application_Quoting__c();
        q.Application__c = a.Id;
        q.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        q.Term__c = 36;
        q.Repayment_Monthly__c = 1;
        q.DOF__c = 1;
        q.Payout_On__c = 1;
        q.Deposit__c = 1;
        q.Trade_In__c =  1;
        q.Vehicle_Price__c = 1;
        q.Residual_Value__c = 1;
        q.Payment__c = 'Arrears';
        
        insert q;
        
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, false);
        
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
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Current Address Applicant 1';
        
        insert o;
        
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Property Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        o.Category__c = 'Property Applicant 1';
        
        insert o;
        
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Investment Property';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        i.Application_Other_Asset__c = o.Id;
        
        insert i;
        
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }

    public static testMethod void Latitude8(){
        LatitudeUtils.getResidential('Parents/Relative');
        LatitudeUtils.getResidential('Boarding');
        LatitudeUtils.getResidential('Own Outright');
        LatitudeUtils.getActivity('Casual');
        LatitudeUtils.getActivity('Financially Supported by Partner');
        LatitudeUtils.getActivity('Part Time');
        LatitudeUtils.getActivity('Unemployed');
        LatitudeUtils.getActivity('Self Employed');
        LatitudeUtils.getActivity('Contract');
        
        LatitudeAPIResponseDTO dto = new LatitudeAPIResponseDTO();
        dto.applicationId = '1';
        dto.message = 'm';
        dto.errors = new List<LatitudeAPIResponseDTO.Error>();
        LatitudeAPIResponseDTO.Error error = new LatitudeAPIResponseDTO.Error();
        error.field = 'f';
        error.reason = 'r';
        
        LatitudeAPIRequestDTO.Application a = new LatitudeAPIRequestDTO.Application();
        a.salesSource = 's';
        
        LatitudeAPIRequestDTO.MailingAddress m = new LatitudeAPIRequestDTO.MailingAddress();		
        m.postalAddress = new LatitudeAPIRequestDTO.PostalAddress();
        m.postalAddress.country = 'c';
        m.postalAddress.r_number = 'r';
        m.postalAddress.postcode = 'p';
        m.postalAddress.state = 's';
        m.postalAddress.suburb = 's';
        m.postalAddress.r_type = 'r';
        
        LatitudeAPIRequestDTO.Phone p = new LatitudeAPIRequestDTO.Phone();
        p.fax = 'f';
        
        LatitudeAPIRequestDTO.AddressDetails address = new LatitudeAPIRequestDTO.AddressDetails();
        address.propertyName = 'p';
        
        LatitudeAPIRequestDTO.Expenses e = new LatitudeAPIRequestDTO.Expenses();
        e.otherMonthly = 1;
                
        LatitudeAPIRequestDTO.LoanDetails l = new LatitudeAPIRequestDTO.LoanDetails();
        l.purpose = 'p';
        
        LatitudeAPIRequestDTO.DriverLicenceDetails d = new LatitudeAPIRequestDTO.DriverLicenceDetails();
        d.reasonUnlicensed = 'r';
        
        LatitudeAPIRequestDTO.Income i = new LatitudeAPIRequestDTO.Income();
        i.grossYearly = 1;
        i.partTimeNetMonthly = 1;
        
        LatitudeAPIRequestDTO.PersonName person = new LatitudeAPIRequestDTO.PersonName();
        person.maidenName = 'm';
        
        LatitudeAPIRequestDTO.Fees f = new LatitudeAPIRequestDTO.Fees();
        f.registration = 1; 
        
        LatitudeAPIRequestDTO.TradeIn t = new LatitudeAPIRequestDTO.TradeIn();
        t.model = 'm';
    }
    
    public static testMethod void Latitude9(){
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = new Application__c();
        a.Email_Address__c = 'e@gmail.com';
        a.First_Name__c = 'f';
        a.Last_Name__c = 'l';
        a.Mobile_Number__c = 'm';
        a.Current_Residence_Status_1__c = 'Renting(Agent)';
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        a.Do_you_have_drivers_licence_1__c = 'Yes';
        a.Expiry_Date_1__c = '2';
        a.Mode_of_Employment_1__c = 'Full Time';
        a.Application_Type__c = 'Business';
        a.Previous_Country_1__c = 'AUS';
        a.Date_From_1__c = '2';
        a.Previous_Country_1b__c = 'AUS';
        a.Date_From_1b__c = '2';
        a.Previous_Country_1c__c = 'AUS';
        a.Date_From_1c__c = '2';
        a.Previous_Country_1d__c = 'AUS';
        a.Date_From_1d__c = '2';
        a.Previous_Country_1e__c = 'AUS';
        a.Date_From_1e__c = '2';
        a.Previous_Country_2__c = 'AUS';
        a.Date_From_2__c = '2';
        a.Previous_Country_2b__c = 'AUS';
        a.Date_From_2b__c = '2';
        a.Previous_Country_2c__c = 'AUS';
        a.Date_From_2c__c = '2';
        a.Previous_Country_2d__c = 'AUS';
        a.Date_From_2d__c = '2';
        a.Previous_Country_2e__c = 'AUS';
        a.Date_From_2e__c = '2';
        a.Previous_Work_Country_1__c = 'AUS';
        a.Start_Date_1__c = '2';
        a.Previous_Work_Country_2__c = 'AUS';
        a.Start_Date_2__c = '2';
        a.No_of_People__c = 2;
        a.Do_you_have_drivers_licence_2__c = 'Yes';
        a.Mode_of_Employment_2__c = 'Full Time';
        a.Business_Structure__c = 'Company';
        a.No_of_People__c = 2;
        a.No_of_Directors__c = 1;
        
        Application_Quoting__c q = new Application_Quoting__c();
              
        LatitudeAPIService l = new LatitudeAPIService();
        l.submitRequest(a, Test_DataGeneratorHelper.tstOpportunity, q);
    }
 
    public static testMethod void Latitude10(){
        
        TestLatitude.LatitudeTestService(1);
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestLatitude.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        TestLatitude.LatitudeTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
            TestLatitude.LatitudeTestResidential(Test_DataGeneratorHelper.tstOpportunity, a, 'AUS', 'Renting(Agent)', previousAddress);
        TestLatitude.LatitudeTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.LatitudeTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestLatitude.asset('Car', Test_DataGeneratorHelper.tstOpportunity, true);
                    
        LatitudeAPIService l = new LatitudeAPIService(); 
        l.requestApplication(Test_DataGeneratorHelper.tstOpportunity, 'AU900266');
    }
}