@isTest(SeeAllData=true)
public class TestFinanceOneRestWS {
    public static testMethod void FinanceOneRestWS(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
        FinanceOneEmployment.street2(null, 's', 'a', 'st');
        FinanceOneEmployment.street2(null, null, 'a', 'st');
        FinanceOneEmployment.street2(null, 's', 'a', null);
        FinanceOneResidential.street2(null, 's', 'a', 'st');
        FinanceOneResidential.street2(null, null, 'a', 'st');
        FinanceOneResidential.street2(null, 's', 'a', null);
        FinanceOneResidential.street2(null, null, 'a', null);
        FinanceOneUtils.loanPurposes('Truck');
    }
    
    public static void FinanceOneRestWSTestService(String endpoint, Integer json){
        String endpoint1 = APIServiceManager.getParameterService(FinanceOneServices.PARAM_ENDPOINT1);
        String endpoint2 = APIServiceManager.getParameterService(FinanceOneServices.PARAM_ENDPOINT2);
        String token = APIServiceManager.getParameterService(FinanceOneServices.PARAM_TOKEN);

        SingleRequestMock fileResp = new SingleRequestMock(200,
                                                           'Complete',
                                                           '{"message": "The request was successful","data":{"uuid": "679d9ebf-1ab2-4e61-847e-0a80484225cc"}}',
                                                           null);
        String body;
        Integer code;
        if(json == 1){
            body = '{"message": "The request was successful","data": {"accountId": "000001"}}'; 
            code = 200;  
        }
        
        if(json == 2){
            body = '{"message": "Invalid request","errors": {"simple": [{"path": "directors[0].personal.firstName","errorType": "Simple","errorMessage": "firstName is required and cannot have a length of zero","errorCode": "S005"}]}}';  
            code = 400;
        }
        
        if(json == 3){
            body = '{"message": "Complex validation of submitted application failed.","errors": {"application": [],"applicants": [{"errors": []},{"errors": [{"errorType": "Complex","errorMessage": "Applicant/Guarantor has not provided at least 3 years of residential history","errorCode": "C015"}]}]}}';  
            code = 400;
        }
        
        if(json == 4){
            body = '{"message":"Complex validation of submitted application failed.","errors":{"application":[{"errorType":"Complex","errorMessage":"The selected product type: CON.S.BRO, is not available for the selected product class: Company","errorCode":"P002"}],"applicants":[{"errors":[]},{"errors":[]},{"errors":[]}]}}';  
            code = 400;
        }
        SingleRequestMock applicationResp = new SingleRequestMock(200,
                                                                  'Complete',
                                                                  body,
                                                                  null);
        
        SingleRequestMock applicationResp2 = new SingleRequestMock(400,
                                                                   'Complete',
                                                                   '{"message": "Invalid request","errors": {"simple": [{"path": "directors[0].personal.firstName","errorType": "Simple","errorMessage": "firstName is required and cannot have a length of zero","errorCode": "S005"}]}}',
                                                                   null);
        
        Map<String, HttpCalloutMock> endpoint2TestResp =
            new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endpoint1+'/documents',fileResp);
        endpoint2TestResp.put(endpoint1+endpoint+endpoint2.replace('SFBRID', 'BA-LLOS'),applicationResp);
        //endpoint2TestResp.put('https://opp-requireddocs.s3.amazonaws.com/a0e-custom_opportunity__c/a0EN000000IuVUb-a0EN000000IuVUbMAN/null?prefix=a0e-custom_opportunity__c%2Fa0EN000000IuVUb-a0EN000000IuVUbMAN%2Fnull%2F&amp;delimiter=%2F',applicationResp2);
        
        HttpCalloutMock multiCalloutMock =
            new MultiRequestMock(endpoint2TestResp);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);	
    }
    
    public static void FinanceOneRestWSTestApp(Application__c a, String licence){
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
    
    public static void FinanceOneRestWSTestEntity(Application__c a){
        a.Business_Structure__c = 'Company';
        
        Application_Employment__c e = new Application_Employment__c();
        
        e.Unit_Number__c = '1';		
        e.Street_Number__c = '1';
        e.Work_Address__c = 'a';
        e.Street_Type__c = 'ST';
        e.State__c = 'ACT';
        e.Application__c = a.Id;
        e.Address_Type__c = 'FinanceDetails';
        
        insert e;
    }
    
    public static void FinanceOneRestWSTestEmployment(Application__c a, String applicant, String employmentType, String employmentTypeSecondJob,String countryEmployment, Boolean secondJob, Boolean previousEmployment1, Boolean previousEmployment2){
        
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
    
    public static void FinanceOneRestWSTestResidential(Id oppId, Application__c a, String countryResidential, String currentResidenceStatus, Boolean[] previousAddress, String asset){
        a.Unit_Number__c = '1';
        a.Street_Number__c = '1';
        a.Street_Address__c = 'a';
        a.Street_Type__c = 'ST';
        a.State__c = 'ACT';
        a.Date_Moved_in_1__c = '01/01/2021';
        a.Current_Residence_Status_1__c = currentResidenceStatus;
        
        if(previousAddress[0]){
            a.Previous_Unit_Number_1__c = '1';
            a.Previous_Street_Number_1__c = '1';
            a.Previous_Street_Address_1__c = 'a';
            a.Previous_Street_Type_1__c = 'ST';
            a.Previous_State_1__c = 'ACT';
            a.Date_From_1__c = '01/01/2020';
            a.Previous_Residence_Status_1__c = 'Renting(Agent)';
            a.Previous_Country_1__c = countryResidential;
        }
        
        if(previousAddress[1]){
            a.Previous_Unit_Number_1b__c = '1';
            a.Previous_Street_Number_1b__c = '1';
            a.Previous_Street_Address_1b__c = 'a';
            a.Previous_Street_Type_1b__c = 'ST';
            a.Previous_State_1b__c = 'ACT';
            a.Date_From_1b__c = '01/01/2019';
            a.Previous_Residence_Status_1b__c = 'Renting(Agent)';
            a.Previous_Country_1b__c = countryResidential;
        }
        
        if(previousAddress[2]){
            a.Previous_Unit_Number_1c__c = '1';
            a.Previous_Street_Number_1c__c = '1';
            a.Previous_Street_Address_1c__c = 'a';
            a.Previous_Street_Type_1c__c = 'ST';
            a.Previous_State_1c__c = 'ACT';
            a.Date_From_1c__c = '01/05/2018';
            a.Previous_Residence_Status_1c__c = 'Renting(Agent)';
            a.Previous_Country_1c__c = countryResidential;
        }
        
        if(previousAddress[3]){
            a.Previous_Unit_Number_1d__c = '1';
            a.Previous_Street_Number_1d__c = '1';
            a.Previous_Street_Address_1d__c = 'a';
            a.Previous_Street_Type_1d__c = 'ST';
            a.Previous_State_1d__c = 'ACT';
            a.Date_From_1d__c = '01/04/2018';
            a.Previous_Residence_Status_1d__c = 'Renting(Agent)';
            a.Previous_Country_1d__c = countryResidential;
        }
        
        if(previousAddress[4]){
            a.Previous_Unit_Number_1e__c = '1';
            a.Previous_Street_Number_1e__c = '1';
            a.Previous_Street_Address_1e__c = 'a';
            a.Previous_Street_Type_1e__c = 'ST';
            a.Previous_State_1e__c = 'ACT';
            a.Date_From_1e__c = '01/03/2018';
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
        
        if(previousAddress[5]){
            a.Previous_Unit_Number_2__c = '1';
            a.Previous_Street_Number_2__c = '1';
            a.Previous_Street_Address_2__c = 'a';
            a.Previous_Street_Type_2__c = 'ST';
            a.Previous_State_2__c = 'ACT';
            a.Date_From_2__c = '01/01/2020';
            a.Previous_Residence_Status_2__c = 'Renting(Agent)';
            a.Previous_Country_2__c = countryResidential;
        }
        
        if(previousAddress[6]){
            a.Previous_Unit_Number_2b__c = '1';
            a.Previous_Street_Number_2b__c = '1';
            a.Previous_Street_Address_2b__c = 'a';
            a.Previous_Street_Type_2b__c = 'ST';
            a.Previous_State_2b__c = 'ACT';
            a.Date_From_2b__c = '01/01/2019';
            a.Previous_Residence_Status_2b__c = 'Renting(Agent)';
            a.Previous_Country_2b__c = countryResidential;
        }
        
        if(previousAddress[7]){
            a.Previous_Unit_Number_2c__c = '1';
            a.Previous_Street_Number_2c__c = '1';
            a.Previous_Street_Address_2c__c = 'a';
            a.Previous_Street_Type_2c__c = 'ST';
            a.Previous_State_2c__c = 'ACT';
            a.Date_From_2c__c = '01/05/2018';
            a.Previous_Residence_Status_2c__c = 'Renting(Agent)';
            a.Previous_Country_2c__c = countryResidential;
        }
        
        if(previousAddress[8]){
            a.Previous_Unit_Number_2d__c = '1';
            a.Previous_Street_Number_2d__c = '1';
            a.Previous_Street_Address_2d__c = 'a';
            a.Previous_Street_Type_2d__c = 'ST';
            a.Previous_State_2d__c = 'ACT';
            a.Date_From_2d__c = '01/04/2018';
            a.Previous_Residence_Status_2d__c = 'Renting(Agent)';
            a.Previous_Country_2d__c = countryResidential;
        }
        
        if(previousAddress[9]){
            a.Previous_Unit_Number_2e__c = '1';
            a.Previous_Street_Number_2e__c = '1';
            a.Previous_Street_Address_2e__c = 'a';
            a.Previous_Street_Type_2e__c = 'ST';
            a.Previous_State_2e__c = 'ACT';
            a.Date_From_2e__c = '01/03/2018';
            a.Previous_Residence_Status_2e__c = 'Renting(Agent)';
            a.Previous_Country_2e__c = countryResidential;
        }
        
        update a;
        
        Cloud_Documents__c d = new Cloud_Documents__c();
        d.Document_Type__c='Drivers License (Front & Back)';
        d.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        d.Send_To_Lender__c=true;
        insert d;
        d = new Cloud_Documents__c();
        d.Document_Type__c='Payslip/s';
        d.Custom_Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        d.Send_To_Lender__c=true;
        insert d;
        
        Application_Quoting__c q = new Application_Quoting__c();
        q.Application__c = a.Id;
        q.Loan_Product__c = 'Consumer Loan';
        q.Loan_Facility_Type__c = 'Bronze';
        q.Goods_type__c = asset;
        q.Term__c = 36;
        q.Repayment_Monthly__c = 1;
        q.DOF__c = 1;
        q.Payout_On__c = 1;
        q.Deposit__c = 1;
        q.Trade_In__c =  1;
        q.Goods_sub_type__c = 'hatch';
        q.Vehicle_Price__c = 1;
        q.Opportunity__c = oppId;
        insert q;
        
        Application_Extra_Data__c extra = new Application_Extra_Data__c();
        extra.Category__c = 'Lender';
        extra.Data__c = 'n';
        extra.Application__c = a.Id;
        insert extra;
        
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
    
    public static testMethod void FinanceOneRestWS2(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Full Time', 'OVS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Full Time', 'OVS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS3(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, true, false, false, false, false, true, false, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Unemployed', 'AUS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Unemployed', 'AUS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, true, false, false, false, false, true, false, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS4(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, true, false, false, false, false, true, false, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Unemployed', 'OVS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Unemployed', 'OVS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, true, false, false, false, false, true, false, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS5(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, true, false, false, false, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, true, false, false, false, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS6(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, true, false, false, false, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, true, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, true, true);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, true, false, false, false, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS7(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/company?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, false, true, false, false, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Full Time', 'AUS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Full Time', 'AUS', true, false, true);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 2, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, false, true, false, false, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS8(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/soleTrader?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, false, true, false, false, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Full Time', 'OVS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Full Time', 'OVS', true, false, true);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 3, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, false, true, false, false, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS9(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/partnership?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, false, false, true, false, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Unemployed', 'AUS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Unemployed', 'AUS', true, false, true);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 4, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, false, false, true, false, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS10(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individualTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, false, false, true, false, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Unemployed', 'OVS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Unemployed', 'OVS', true, false, true);
        //TestFinanceOneRestWS.asset('Equipment', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 5, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{false, false, false, false, true, false, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS11(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, false, true, false, false, true, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        //TestFinanceOneRestWS.asset('Boat', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, true, false, false, true, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS12(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, false, true, false, false, true, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, false, true);
        //TestFinanceOneRestWS.asset('Boat', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
    }
    
    public static testMethod void FinanceOneRestWS13(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 2);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, false, true, false, false, true, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Caravan');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Centrelink - Family Tax Benefits/Other', 'OVS', true, false, false);
        TestFinanceOneRestWS.asset('Caravan', Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, true, false, false, true, false, true, false, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Caravan');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS14(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 3);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, false, false, true, false, true, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Motorbike');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', false, false, false);
        TestFinanceOneRestWS.asset('Motorbike', Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, false, true, false, true, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Motorbike');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS15(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individual?', 4);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        a.Payment_Frequency_1__c = 'Yearly';
        a.Payment_Frequency_2__c = 'Yearly';
        
        Boolean[] previousAddress = new Boolean[]{true, false, false, true, false, true, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Full Time', 'Full Time', 'AUS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Full Time', 'Full Time', 'AUS', false, false, false);
        TestFinanceOneRestWS.asset('Car', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Application_Income__c i = new Application_Income__c();
        i.Type__c = 'Other';
        i.Income__c = 1;
        i.Frequency__c = 'Monthly';
        i.Application__c = a.Id;
        i.Applicant__c = '1';
        
        insert i;
        
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
        
        insert o;
        
        o = new Application_Other_Asset__c();
        
        o.RecordTypeId = RecordTypes.get('Vehicle Asset');
        o.Amount_Owing__c = 1;
        o.Lender__c = 'l';
        o.Has_Loan__c = 'Y';
        o.Application__c = a.Id;
        o.Description__c = 'd';
        o.Value__c = 1;
        
        insert o;
        
        Application_Loan__c l = new Application_Loan__c();
        l.Type__c = 'Payday Loan';
        l.Amount_Owing__c = 1;
        l.Lender__c = 'l';
        l.Payment__c = 1;
        l.Application__c = a.Id;
        
        insert l;
        
        Application_Credit_Card__c c = new Application_Credit_Card__c();
        
        c.Amount_Owing__c = 1;
        c.Issuer__c = 'i';
        c.Limit__c = 1;
        c.Application__c = a.Id;
        
        insert c;
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 1, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, false, true, false, true, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Renting(Agent)'
            , previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static void asset(String asset, Custom_Opportunity__c o){
        Application_Asset_Detail__c a = new Application_Asset_Detail__c();
        
        a.Year__c = 2021;
        a.Type__c = 'Car';
        a.Condition__c = 'new';
        a.Variant__c = '1';
        
        insert a;
        
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
            g.Code__c = a.Variant__c;
            g.Model__c = m.Id;
            
            insert g;
        }
        
        o.Application_AssetDetail__c = a.Id;
        update o;
    }
    
    public static void insurance(Custom_Opportunity__c o){
        Map<String,id> RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        Product__c p = new Product__c();			
        
        p.RecordTypeId = RecordTypes.get('Insurance');
        p.Insurance_Type__c = 'Gap Insurance';
        p.Insurance_Policy_Amount__c = 1;
        p.Insurer__c = 'AIC/Eric';
        p.Opportunity_Name__c = o.Id;
        
        insert p;
    }
    
    public static testMethod void FinanceOneRestWS16(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/company?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, false, false, false, true, true, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Unemployed', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Unemployed', 'OVS', false, false, false);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 2, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, false, false, true, true, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS17(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/soleTrader?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, false, false, false, true, true, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Unemployed', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Unemployed', 'OVS', false, false, false);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 3, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, false, false, false, true, true, false, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS18(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/partnership?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, false, true, false, true, true, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 4, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, false, true, false, true, true, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS19(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/individualTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, false, true, false, true, true, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        //TestFinanceOneRestWS.asset('Equipment', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 5, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, false, true, false, true, true, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS20(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, false, false, true, true, true, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        //TestFinanceOneRestWS.asset('Boat', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, false, false, true, true, true, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS21(){
        
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
        
        insert a;
        
        Application_Employment__c e = new Application_Employment__c();
        
        e.Application__c = a.Id;
        e.Address_Type__c = 'FinanceDetails';
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Previous Job';
        e.Applicant__c = '1';
        e.Country__c = 'AUS';
        e.Application__c = a.Id;
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Previous Job';
        e.Applicant__c = '2';
        e.Country__c = 'AUS';
        e.Application__c = a.Id;
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '1';
        e.Employment_Type__c = 'Self Employed';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = a.Id;
        e.Frequency__c = 'Monthly';
        e.Income__c = 1;
        e.Street_Number__c = '1';
        e.Work_Address__c = 'a';
        e.Street_Type__c = 'ST';
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '2';
        e.Employment_Type__c = 'Self Employed';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = a.Id;
        e.Frequency__c = 'Monthly';
        e.Income__c = 1;
        e.Street_Number__c = '1';
        e.Work_Address__c = 'a';
        e.Street_Type__c = 'ST';
        
        insert e;
        
        //FinanceOneRestWSTestEntity(a);
        
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        
        update Test_DataGeneratorHelper.tstOpportunity;
        
        FinanceOneRestWS f = new FinanceOneRestWS();
        f.submitRequest(a, Test_DataGeneratorHelper.tstOpportunity.Id);
    }
    
    public static testMethod void FinanceOneRestWS27(){
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = new Application__c();
        
        a.Current_Residence_Status_1__c = 'Renting(Agent)';
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        a.Email_Address__c = 'e@gmail.com';
        a.First_Name__c = 'f';
        a.Last_Name__c = 'l';
        a.Mobile_Number__c = 'm';
        a.Do_you_have_drivers_licence_1__c = 'No';
        a.Mode_of_Employment_1__c = 'Self Employed';
        a.Application_Type__c = 'Business';
        a.No_of_People__c = 2;
        a.Do_you_have_drivers_licence_2__c = 'No';
        a.Mode_of_Employment_2__c = 'Self Employed';
        a.Previous_Country_1__c = 'AUS';
        a.Previous_Street_Address_1__c = 'a';
        a.Previous_Country_1b__c = 'AUS';
        a.Previous_Street_Address_1b__c = 'a';
        a.Previous_Country_1c__c = 'AUS';
        a.Previous_Street_Address_1c__c = 'a';
        a.Previous_Country_1d__c = 'AUS';
        a.Previous_Street_Address_1d__c = 'a';
        a.Previous_Country_1e__c = 'AUS';
        a.Previous_Street_Address_1e__c = 'a';
        a.Previous_Country_2__c = 'AUS';
        a.Previous_Street_Address_2__c = 'a';
        a.Previous_Country_2b__c = 'AUS';
        a.Previous_Street_Address_2b__c = 'a';
        a.Previous_Country_2c__c = 'AUS';
        a.Previous_Street_Address_2c__c = 'a';
        a.Previous_Country_2d__c = 'AUS';
        a.Previous_Street_Address_2d__c = 'a';
        a.Previous_Country_2e__c = 'AUS';
        a.Previous_Street_Address_2e__c = 'a';
        
        insert a;
        
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        
        update Test_DataGeneratorHelper.tstOpportunity;
        FinanceOneRestWS f = new FinanceOneRestWS();
        
        f.submitRequest(a, Test_DataGeneratorHelper.tstOpportunity.Id);
    }
    
    public static testMethod void FinanceOneRestWS28(){
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = new Application__c();
        
        a.Current_Residence_Status_1__c = 'Renting(Agent)';
        a.Current_Residence_Status_2__c = 'Renting(Agent)';
        a.Email_Address__c = 'e@gmail.com';
        a.First_Name__c = 'f';
        a.Last_Name__c = 'l';
        a.Mobile_Number__c = 'm';
        a.Do_you_have_drivers_licence_1__c = 'No';
        a.Mode_of_Employment_1__c = 'Self Employed';
        a.Application_Type__c = 'Business';
        a.No_of_People__c = 2;
        a.Do_you_have_drivers_licence_2__c = 'No';
        a.Mode_of_Employment_2__c = 'Self Employed';
        insert a;
        
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        
        update Test_DataGeneratorHelper.tstOpportunity;
        FinanceOneRestWS f = new FinanceOneRestWS();
                
        f.submitRequest(a, Test_DataGeneratorHelper.tstOpportunity.Id);
    }
    
    public static testMethod void FinanceOneRestWS22(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, false, false, true, true, true, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        //TestFinanceOneRestWS.asset('Boat', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, false, false, true, true, true, false, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Car');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS23(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Equipment');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.asset('Equipment', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Boarding', 
            previousAddress, 'Truck');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
    }
    
    public static testMethod void FinanceOneRestWS24(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/companyTrust?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'No');
        Boolean[] previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Boat');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'OVS', false, false, false);
        TestFinanceOneRestWS.asset('Boat', Test_DataGeneratorHelper.tstOpportunity);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 6, 'BA-LLOS');
        Test.stopTest();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        previousAddress = new Boolean[]{true, true, true, false, true, true, true, true, false, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AFG', 'Boarding', 
            previousAddress, 'Boat');
        FinanceOneResidential.residentialApp2(a, Test_DataGeneratorHelper.tstOpportunity);
        FinanceOneUtils.sex('Others');
        FinanceOneUtils.residencyStatus('Working VISA');
        FinanceOneUtils.residencyStatus('PR VISA');
        FinanceOneUtils.residencyStatus('Other');
        FinanceOneUtils.maritalStatus('Defacto');
        FinanceOneUtils.residential('Own Outright');
        FinanceOneUtils.residential('Mortgage');
        FinanceOneUtils.residential('Parents/Relative');
        FinanceOneUtils.residential('Employer Accommodation');
        FinanceOneUtils.employment('Part Time');
        FinanceOneUtils.employment('Casual');
        FinanceOneUtils.employment('Unemployed');
        FinanceOneUtils.income('Rental Income');
        FinanceOneUtils.income('Maintenance');
        FinanceOneUtils.income('Carers Payment');
        FinanceOneUtils.income('Self Employed');
        FinanceOneUtils.income('Investment Income');
        FinanceOneUtils.liabilities('Personal Loan');
        FinanceOneUtils.liabilities('Other');
        FinanceOneUtils.productTypeId('Consumer Loan', 'Platinum');
        FinanceOneUtils.productTypeId('Consumer Loan', 'Gold');
        FinanceOneUtils.productTypeId('Consumer Loan', 'Silver');
        FinanceOneUtils.productTypeId('Consumer Loan', 'Economy');
        FinanceOneUtils.productTypeId('l', 'Gold');
        FinanceOneUtils.productTypeId('l', 'Silver');
        FinanceOneUtils.productTypeId('l', 'Bronze');
        FinanceOneUtils.productTypeId('l', 'Platinum');
        FinanceOneUtils.entityType('Individual or Sole Trader');
        FinanceOneUtils.entityType('Partnership');
        FinanceOneUtils.entityType('Trust');
        FinanceOneUtils.insuranceType('Warranty');
        FinanceOneUtils.insuranceType('LTI');
        FinanceOneUtils.insuranceType('Full Comprehensive');
        FinanceOneUtils.getContentType('f.pdf');
        FinanceOneUtils.getContentType('f.doc');
        FinanceOneUtils.getContentType('f.docx');
        FinanceOneUtils.getContentType('f.png');
        FinanceOneUtils.getContentType('f.gif');
        FinanceOneUtils.getContentType('f.jpeg');
        FinanceOneUtils.getContentType('f.pjpeg');
        
        FinanceOneDTOs.MotorVehicle motorVehicle = new FinanceOneDTOs.MotorVehicle();
        motorVehicle.odometer = 1;
        FinanceOneDTOs.RecreationalAsset r = new FinanceOneDTOs.RecreationalAsset();
        r.odometer = 1;
        FinanceOneDTOs.Motorbike motorbike = new FinanceOneDTOs.Motorbike();
        motorbike.odometer = 1;
        FinanceOneDTOs.HouseholdExpenses h = new FinanceOneDTOs.HouseholdExpenses();
        h.minorExpenses = 1;
        h.adultExpenses = 1;
        h.livingExpensePercentage = 1;
        FinanceOneDTOs.Personal p = new FinanceOneDTOs.Personal();
        p.middleNames = 'm';
        p.visaType = 'v';
        FinanceOneDTOs.Licence l = new FinanceOneDTOs.Licence();
        l.specialRestrictionsDetails = 's';
        FinanceOneDTOs.CurrentResidential c = new FinanceOneDTOs.CurrentResidential();
        c.numberOfIndividualsOnLease = 1;
        FinanceOneDTOs.PointOfContact point = new FinanceOneDTOs.PointOfContact();
        point.email = 'e';
        FinanceOneDTOs.PostalResidential postal = new FinanceOneDTOs.PostalResidential();
        postal.address = new FinanceOneDTOs.Address();
        FinanceOneDTOs.Entity e = new FinanceOneDTOs.Entity();
        e.accountant = new FinanceOneDTOs.PointOfContact();
        FinanceOneDTOs.Standard s = new FinanceOneDTOs.Standard();
        s.current = 'c';
        s.previous = 's';
        FinanceOneDTOs.Income i = new FinanceOneDTOs.Income();
        i.comment = 'c';
        FinanceOneDTOs.AdditionalInformationSection additional = new FinanceOneDTOs.AdditionalInformationSection();
        additional.additionalInformation = 'a';
        FinanceOneDTOs.AllPAAP allPAAP = new FinanceOneDTOs.AllPAAP();
        allPAAP.abn = 'a';
        allPAAP.acn = 'a';       
        allPAAP.exceptions = true;
        FinanceOneDTOs.MarineLicence m = new FinanceOneDTOs.MarineLicence();
        m.licenceNumber = 'l'; 
        m.state = 's';
        m.expirationDate = 'e';
        m.licenceClass = 'l';
        
        FinanceOneEmployment.endDate('01-01-2021');
        FinanceOneEmployment.endDate2(date.parse('10/01/2021'));
        FinanceOneEmployment.endDate2(date.parse('10/10/2021'));
        FinanceOneEmployment.street('a', 'a');
    }
    
    public static testMethod void FinanceOneRestWS25(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/company?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{false, false, false, true, false, false, false, false, true, false};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Centrelink - Family Tax Benefits/Other', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 2, 'BA-LLOS');
        Test.stopTest();
    }
    
    public static testMethod void FinanceOneRestWS26(){
        
        TestFinanceOneRestWS.FinanceOneRestWSTestService('/applications/company?', 1);
        
        Test_DataGeneratorHelper.createOpportunity();
        
        Application__c a = TestFinanceOneRestWS.createApplication();
        a.Applicant_2_living_in_the_same_address__c = 'No';
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application__c = a.Id;
        FinanceOneRestWSTestEntity(a);
        update Test_DataGeneratorHelper.tstOpportunity;
        TestFinanceOneRestWS.FinanceOneRestWSTestApp(a, 'Yes');
        Boolean[] previousAddress = new Boolean[]{true, true, true, true, true, true, true, true, true, true};
        TestFinanceOneRestWS.FinanceOneRestWSTestResidential(
          Test_DataGeneratorHelper.tstOpportunity.Id, a, 'AUS', 'Renting(Agent)'
            , previousAddress, 'Car');
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '1', 'Unemployed', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        TestFinanceOneRestWS.FinanceOneRestWSTestEmployment(a, '2', 'Unemployed', 'Centrelink - Family Tax Benefits/Other', 'AUS', true, false, true);
        TestFinanceOneRestWS.insurance(Test_DataGeneratorHelper.tstOpportunity);
        Test.startTest();
        FinanceOneRestWS.application(Test_DataGeneratorHelper.tstOpportunity.Id, 2, 'BA-LLOS');
        Test.stopTest();
        
    }
    
    public static testMethod void FinanceOneRestWS29(){
        Application__c a = TestFinanceOneRestWS.createApplication();
        insert a;
        FinanceOneRestWSTestEntity(a);
        a.Mode_of_Employment_1__c = 'Centrelink - Family Tax Benefits/Other';
        a.Date_Started_1__c = '01/01/2021';
        a.Current_Work_State_1__c = 'ACT';
        
        a.Mode_of_Employment_2__c = 'Centrelink - Family Tax Benefits/Other';
        a.Date_Started_2__c = '01/01/2021';
        a.Current_Work_State_2__c = 'ACT';
        
        update a;
        
        Application_Employment__c e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '1';
        e.Employment_Type__c = 'Full Time';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = a.Id;
        
        insert e;
        
        e = new Application_Employment__c();
        
        e.Type__c = 'Second Job';
        e.Applicant__c = '2';
        e.Employment_Type__c = 'Full Time';
        e.Start_Date__c = Date.parse('01/01/2021');
        e.State__c = 'ACT';
        e.Application__c = a.Id;
        
        insert e;
        
        FinanceOneEmployment.employmentApp1(1, a);
        FinanceOneEmployment.employmentApp1(2, a);
        
        List < Application_Employment__c > lst = [
            SELECT Employment_Type__c FROM Application_Employment__c WHERE Application__c =: a.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c = '1'];
        
        Application_Employment__c s = lst.get(0);
        
        s.Employment_Type__c = 'Unemployed';
        
        update s;			
        
        lst = [
            SELECT Employment_Type__c FROM Application_Employment__c WHERE Application__c =: a.Id 
            AND Address_Type__c <: Utilities.ADDRESS_TYPE_FINANCE AND Type__c = 'Second Job' AND Applicant__c = '2'];
        
        Application_Employment__c s2 = lst.get(0);
        
        s2.Employment_Type__c = 'Unemployed';
        
        update s2;
        
        FinanceOneEmployment.employmentApp1(1, a);
        FinanceOneEmployment.employmentApp1(2, a);
        FinanceOneRestWS.getFinanceOneType(a);
		a.Application_Type__c = 'Business';
		FinanceOneRestWS.getFinanceOneType(a);
		a.Business_Structure__c = 'Individual or Sole Trader';
		FinanceOneRestWS.getFinanceOneType(a);
		a.Business_Structure__c = 'Partnership';
		FinanceOneRestWS.getFinanceOneType(a);
		a.Trust_Name__c = 't';
		FinanceOneRestWS.getFinanceOneType(a);
    }
}