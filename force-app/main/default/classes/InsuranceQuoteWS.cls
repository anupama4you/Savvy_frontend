public with sharing class InsuranceQuoteWS {

    private static String WS_API_KEY = InsuranceQuoteUtils.getAPIKey();

    public static void getQuote(QuoteParam param) {
        //Stub creator
        servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp quotationWService = new servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp();

        servicesFastrComAuQuotationData.QuotationRequest rqst = makeEricQuotationRequestDTO(param);

        String jsonStringParse = '[' + JSON.serialize(rqst) + ']';

        System.debug('WS_API_KEY >> ' + WS_API_KEY);
        System.debug('REQUEST DATA >> ');
        System.debug(jsonStringParse);

        param.requestList = null;
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_INITQUOTE, InsuranceQuoteUtils.TYPE_REQ, jsonStringParse));

        quotationWService.timeout_x = 19000;
        servicesFastrComAuQuotationData.QuotationResponse rpns = quotationWService.RequestInitialQuotation(rqst, WS_API_KEY);

        jsonStringParse = '[' + JSON.serialize(rpns) + ']';

        System.debug('RESPONSE DATA >> ');
        System.debug(jsonStringParse);

        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_INITQUOTE, InsuranceQuoteUtils.TYPE_RES, jsonStringParse));

        if (rpns != null) {
            System.debug('Saving response...');

            //Status
            param.quote.Status__c = 'Q';
            if (!param.preserveAcceptance) {
                //Reset Acceptance
                param.quote.MV_Acceptance__c = 'U';
                param.quote.GAP_Acceptance__c = 'U';
                param.quote.LTI_Acceptance__c = 'U';
                param.quote.TAS_Acceptance__c = 'U';
                param.quote.WRR_Acceptance__c = 'U';
            }
            
            saveWebServiceResponse(param, rpns);

        }

        // save history request
        if (param.requestList != null && !param.requestList.isEmpty()) {
            insert param.requestList;
        }

    }

    private static void saveWebServiceResponse(InsuranceQuoteWS.QuoteParam param, servicesFastrComAuQuotationData.QuotationResponse rpns) {

        Custom_Opportunity__c opp = param.opp;
        Application_InsuranceQuote__c quote = param.quote;

        List < Insurance_Payment_Method__c > paymentList = new List < Insurance_Payment_Method__c > ();
        //Obsolete previous quotes
        //InsuranceQuoteUtils.setObsoletePreviousQuotes(quote.Application__c);        //Removed is not necessary

        //Save response
        quote.Quotation_Date__c = Datetime.now();
        quote.Quotation_Number__c = rpns.QuotationNumber;
        quote.Quotation_Creator__c = UserInfo.getUserId();
        quote.Response_Vehicle_Description__c = rpns.VehicleDescription;

        // Failure Reason
        List<Insurance_Failure_Reason__c> fr = new List<Insurance_Failure_Reason__c>();
        if (rpns.FailureReasons != null && rpns.FailureReasons.string_x != null) {
            for (String a : rpns.FailureReasons.string_x) {
                Insurance_Failure_Reason__c re = new Insurance_Failure_Reason__c();
                re.Insurance_Quote__c = quote.Id;
                re.Reason__c = a.mid(0,255);
                fr.add(re);
            }
            quote.Status__c = 'Fail';
        }

        //Motor Vehicle
        if (rpns.MotorPremium != null) {
            //Premiums 
            quote.MV_Establishment_Fee__c = rpns.MotorPremium.EstablishmentFee;
            quote.MV_GST__c = rpns.MotorPremium.Gst;
            quote.MV_Premium__c = rpns.MotorPremium.Premium;
            quote.MV_Stamp_Duty__c = rpns.MotorPremium.StampDuty;
            //Standard Excess
            quote.MV_Standard_Excess__c = rpns.MotorPremium.BasicExcess;
            //ImposedExcess
            quote.MV_Imposed_Excess__c = rpns.MotorPremium.ImposedExcess;
            //SystemImposedExcess
            quote.MV_System_Imposed_Excess__c = rpns.MotorPremium.SystemImposedExcess;
            if (rpns.MotorPremium.BasicExcessOptions != null && rpns.MotorPremium.BasicExcessOptions.decimal_x != null && !rpns.MotorPremium.BasicExcessOptions.decimal_x.isEmpty()) {
                quote.MV_Basic_Excess_Options__c = JSON.serialize(rpns.MotorPremium.BasicExcessOptions.decimal_x);
            }
            //Amount Coverd
            quote.MV_Amount_Covered__c = rpns.MotorPremium.AmountCovered;
            quote.MV_Amount_Covered_Min__c = rpns.MotorPremium.AmountCoveredMinimum;
            quote.MV_Amount_Covered_Max__c = rpns.MotorPremium.AmountCoveredMaximum;
            quote.MV_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Motor_Vehicle__c);
            //Payments 
            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'MV', rpns.MotorPremium.AvailablePaymentMethods);
            if (!t.isEmpty()) {
                paymentList.addAll(t);
            }
        } else if (fr.isEmpty()) {
            //Premiums 
            quote.MV_Establishment_Fee__c = null;
            quote.MV_GST__c = null;
            quote.MV_Premium__c = null;
            quote.MV_Stamp_Duty__c = null;
            //Standard Excess
            quote.MV_Standard_Excess__c = null;
            //Amount Coverd
            quote.MV_Amount_Covered__c = null;
            quote.MV_Amount_Covered_Min__c = null;
            quote.MV_Amount_Covered_Max__c = null;
            quote.MV_Commission_Percentage__c = null;
        }
        //GAP
        if (rpns.GapPremium != null) {
            quote.GAP_Establishment_Fee__c = rpns.GapPremium.EstablishmentFee;
            quote.GAP_GST__c = rpns.GapPremium.Gst;
            quote.GAP_Premium__c = rpns.GapPremium.Premium;
            quote.GAP_Stamp_Duty__c = rpns.GapPremium.StampDuty;
            quote.GAP_Cost_ExGst__c = rpns.GapPremium.CostExGst;
            quote.GAP_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Gap__c);
            //Payments 
            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'GAP', rpns.GapPremium.AvailablePaymentMethods);
            if (!t.isEmpty()) {
                paymentList.addAll(t);
            }
        } else if (fr.isEmpty()) {
            quote.GAP_Establishment_Fee__c = null;
            quote.GAP_GST__c = null;
            quote.GAP_Premium__c = null;
            quote.GAP_Stamp_Duty__c = null;
            quote.GAP_Cost_ExGst__c = null;
            quote.GAP_Commission_Percentage__c = null;
        }
        //LTI
        if (rpns.LtiPremium != null) {
            quote.LTI_Establishment_Fee__c = rpns.LtiPremium.EstablishmentFee;
            quote.LTI_GST__c = rpns.LtiPremium.Gst;
            quote.LTI_Premium__c = rpns.LtiPremium.Premium;
            quote.LTI_Stamp_Duty__c = rpns.LtiPremium.StampDuty;
            quote.LTI_Cost_ExGst__c = rpns.LtiPremium.CostExGst;
            quote.LTI_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.LTI_BRI__c);
            //Payments 
            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'LTI', rpns.LtiPremium.AvailablePaymentMethods);
            if (!t.isEmpty()) {
                paymentList.addAll(t);
            }
        } else if (fr.isEmpty()) {
            quote.LTI_Establishment_Fee__c = null;
            quote.LTI_GST__c = null;
            quote.LTI_Premium__c = null;
            quote.LTI_Stamp_Duty__c = null;
            quote.LTI_Cost_ExGst__c = null;
            quote.LTI_Commission_Percentage__c = null;
        }
        //Total Assist
        if (rpns.TotalAssistPremium != null) {
            quote.TAS_Establishment_Fee__c = rpns.TotalAssistPremium.EstablishmentFee;
            quote.TAS_GST__c = rpns.TotalAssistPremium.Gst;
            quote.TAS_Premium__c = rpns.TotalAssistPremium.Premium;
            quote.TAS_Stamp_Duty__c = rpns.TotalAssistPremium.StampDuty;
            quote.TAS_Cost_ExGst__c = rpns.TotalAssistPremium.CostExGst;
            quote.TAS_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Total_assist_RTI__c);
            //Payments 
            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'RTI', rpns.TotalAssistPremium.AvailablePaymentMethods);
            if (!t.isEmpty()) {
                paymentList.addAll(t);
            }
        } else if (fr.isEmpty()) {
            quote.TAS_Establishment_Fee__c = null;
            quote.TAS_GST__c = null;
            quote.TAS_Premium__c = null;
            quote.TAS_Stamp_Duty__c = null;
            quote.TAS_Cost_ExGst__c = null;
            quote.TAS_Commission_Percentage__c = null;
        }
        //Warranty
        if (rpns.WarrantyPremium != null) {
            quote.WRR_Establishment_Fee__c = rpns.WarrantyPremium.EstablishmentFee;
            quote.WRR_GST__c = rpns.WarrantyPremium.Gst;
            quote.WRR_Premium__c = rpns.WarrantyPremium.Premium;
            quote.WRR_Stamp_Duty__c = rpns.WarrantyPremium.StampDuty;
            quote.WRR_Cost_ExGst__c = rpns.WarrantyPremium.CostExGst;
            quote.WRR_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Warranty_Insurance__c);
            //Payments 
            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'Warranty', rpns.WarrantyPremium.AvailablePaymentMethods);
            if (!t.isEmpty()) {
                paymentList.addAll(t);
            }
        } else if (fr.isEmpty()) {
            quote.WRR_Establishment_Fee__c = null;
            quote.WRR_GST__c = null;
            quote.WRR_Premium__c = null;
            quote.WRR_Stamp_Duty__c = null;
            quote.WRR_Cost_ExGst__c = null;
            quote.WRR_Commission_Percentage__c = null;
        }

        //Name
        quote.Name = opp.Name + ' [' + quote.Quotation_Number__c + ']';

        update quote;
        //Manage payments
        delete[SELECT Id FROM Insurance_Payment_Method__c WHERE Insurance_Quote__c = :quote.Id];
        if (!paymentList.isEmpty()) {
            insert paymentList;
        }
        delete[SELECT Id FROM Insurance_Failure_Reason__c WHERE Insurance_Quote__c = :quote.Id];
        if (!fr.isEmpty()) {
            insert fr;
        }
    }

    public static void getPresentingQuote(InsuranceQuoteWS.QuoteParam param) {
        System.debug('getPresentingQuote...');
        //Load objects
        //WS_API_KEY = InsuranceQuoteUtils.getAPIKey();
        //Stub creator
        servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp quotationWService = new servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp();

        // Policy details
        // Cover Details
        if (param.quote.Cover_Start_Date__c == null || param.quote.Cover_Start_Date__c < Date.today()) {
            param.quote.Cover_Start_Date__c = Date.today();
        }
        // Warranty
        if ('A'.equals(param.quote.WRR_Acceptance__c) &&
            String.isBlank(param.quote.Vehicle_Under_Warranty__c)) {
            param.quote.Vehicle_Under_Warranty__c = 'N';
        }
        // Financial Details
        if (param.quote.Vehicle_Purchase_Date__c == null || param.quote.Vehicle_Purchase_Date__c < Date.today()) {
            param.quote.Vehicle_Purchase_Date__c = Date.today();
        }

        servicesFastrComAuQuotationData.QuotationRequest rqst = makeEricFinalQuotationRequestDTO(param);

        String jsonStringParse = '[' + JSON.serialize(rqst) + ']';

        System.debug('WS_API_KEY >> ' + WS_API_KEY);
        System.debug('PRESENTING - FINAL REQUEST DATA >> ');
        System.debug(jsonStringParse);
        param.requestList = null;
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_PRESENTATION, InsuranceQuoteUtils.TYPE_REQ, jsonStringParse));

        quotationWService.timeout_x = 19000;
        //servicesFastrComAuQuotationData.QuotationResponse rpns = 
        //        quotationWService.RequestFinalQuotation(rqst, WS_API_KEY);
        servicesFastrComAuQuotationData.QuotationResponse rpns = quotationWService.RequestFinalQuotation(rqst, WS_API_KEY);

        //servicesFastrComAuQuotationData.QuotationResponse rpns = 
        //        quotationWService.RequestQuotationValidation(rqst, WS_API_KEY);        

        jsonStringParse = '[' + JSON.serialize(rpns) + ']';

        System.debug('RESPONSE DATA >> ');
        System.debug(jsonStringParse);
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_PRESENTATION, InsuranceQuoteUtils.TYPE_RES, jsonStringParse));

        if (rpns != null) {
            System.debug('Saving response...');

            //Status
            //param.quote.Status__c = 'FA';

            saveWebServiceResponse(param, rpns);

        }

        // save history request
        if (param.requestList != null && !param.requestList.isEmpty()) {
            insert param.requestList;
        }

    }

    public static void getFinalQuote(InsuranceQuoteWS.QuoteParam param) {
        System.debug('getFinalQuote...');
        //Load objects
        //WS_API_KEY = InsuranceQuoteUtils.getAPIKey();
        //Stub creator
        servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp quotationWService = new servicesFastrComAuQuotation.QuotationServiceEndpoint_wsHttp();

        servicesFastrComAuQuotationData.QuotationRequest rqst = makeEricFinalQuotationRequestDTO(param);

        String jsonStringParse = '[' + JSON.serialize(rqst) + ']';

        System.debug('WS_API_KEY >> ' + WS_API_KEY);
        System.debug('FINAL REQUEST DATA >> ');
        System.debug(jsonStringParse);
        param.requestList = null;
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_FINALQUOTE, InsuranceQuoteUtils.TYPE_REQ, jsonStringParse));

        quotationWService.timeout_x = 19000;
        //servicesFastrComAuQuotationData.QuotationResponse rpns = 
        //        quotationWService.RequestFinalQuotation(rqst, WS_API_KEY);
        servicesFastrComAuQuotationData.QuotationResponse rpns = quotationWService.RequestFinalQuotation(rqst, WS_API_KEY);

        //servicesFastrComAuQuotationData.QuotationResponse rpns = 
        //        quotationWService.RequestQuotationValidation(rqst, WS_API_KEY);        

        jsonStringParse = '[' + JSON.serialize(rpns) + ']';

        System.debug('RESPONSE DATA >> ');
        System.debug(jsonStringParse);
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_FINALQUOTE, InsuranceQuoteUtils.TYPE_RES, jsonStringParse));

        if (rpns != null) {
            System.debug('Saving response...');

            //Status
            param.quote.Status__c = 'FA';

            saveWebServiceResponse(param, rpns);

        }
        // save history request
        if (param.requestList != null && !param.requestList.isEmpty()) {
            insert param.requestList;
        }
    }

    private static servicesFastrComAuQuotationData.QuotationRequest makeEricQuotationRequestDTO(InsuranceQuoteWS.QuoteParam param) {
        Custom_Opportunity__c opp = param.opp;
        Application_InsuranceQuote__c quote = param.quote;
        Application_Quoting__c quoting = param.quoting;

        Application_Additional_Driver__c mainDriver = InsuranceQuoteUtils.getMainDriver(quote.Id);

        servicesFastrComAuQuotationData.QuotationRequest r = new servicesFastrComAuQuotationData.QuotationRequest();
        //EricQuotationRequestDTO r = new EricQuotationRequestDTO();
        //CoverStartDate
        //FSG
        //MainInsured
        r.MainInsured = new servicesFastrComAuQuotationData.MainInsured();
        //DateOfBirth
        r.MainInsured.DateOfBirth = InsuranceQuoteUtils.convertToDateX(mainDriver.Date_of_Birth__c); //OK
        //Title
        //r.MainInsured.Title = app.Title_1__c;
        //FirstName
        r.MainInsured.FirstName = mainDriver.First_Name__c;
        //Surname
        r.MainInsured.Surname = mainDriver.Last_Name__c;
        //Gender
        r.MainInsured.Gender = mainDriver.Gender__c; //OK
        //LicenseNumber
        r.MainInsured.LicenseNumber = mainDriver.Driver_Licence__c; //OK
        //YearFirstLicensed
        r.MainInsured.YearFirstLicensed = Integer.valueOf(mainDriver.Year_First_Licence__c); //OK
        //Postcode
        r.MainInsured.Postcode = String.valueOf(quote.Vehicle_Location_Postcode__c);
        if (r.MainInsured.Postcode.length() == 3) {
            r.MainInsured.Postcode = '0' + r.MainInsured.Postcode;
        }
        //State
        r.MainInsured.State = quote.Vehicle_Location_State__c; //OK
        //Suburb
        r.MainInsured.Suburb = quote.Vehicle_Location_Suburb__c;
        //YearSinceLastAccident
        r.MainInsured.YearSinceLastAccident = mainDriver.Time_Last_Fault_Accident__c; //OK
        //IsHoldingInternationalLicence
        r.MainInsured.IsHoldingInternationalLicence = mainDriver.Has_International_Licence__c; //OK
        //InputTaxCredit
        r.MainInsured.InputTaxCredit = mainDriver.Input_Tax_Credit__c; //OK
        //IsBusinessUse
        if ('Business'.equalsIgnoreCase(quote.Vehicle_Usage__c)) {
            r.MainInsured.IsBusinessUse = true; //OK
            if (String.isNotBlank(opp.Application__r.Entity_Name__c)) {
                r.MainInsured.BusinessName = opp.Application__r.Entity_Name__c + ' (' + mainDriver.First_Name__c + ' ' + mainDriver.Last_Name__c + ')';
            } else {
                r.MainInsured.BusinessName = mainDriver.First_Name__c + ' ' + mainDriver.Last_Name__c;
            }
            r.MainInsured.FirstName = r.MainInsured.BusinessName;
            r.MainInsured.Surname = '';
        } else {
            r.MainInsured.IsBusinessUse = false;
        }
        //Abn
        r.MainInsured.Abn = mainDriver.ABN__c;
        //IsRegisteredOwner
        r.MainInsured.IsRegisteredOwner = false; //OK
        //RegisteredForGst
        r.MainInsured.RegisteredForGst = mainDriver.Registered_for_GST__c; //OK
        //Email
        r.MainInsured.Email = mainDriver.Email__c;
        //Mobile
        
        r.MainInsured.Mobile = mainDriver.Mobile__c;
        //Occupation
        r.MainInsured.Occupation = mainDriver.Occupation__c;
        //Phone1
        if (!String.isBlank(mainDriver.Home_Phone__c)) {
            r.MainInsured.Phone1 = mainDriver.Home_Phone__c;
        } else {
            r.MainInsured.Phone1 = r.MainInsured.Mobile;
        }
        //WorkPhone
        if (!String.isBlank(mainDriver.Work_Phone__c)) {
            r.MainInsured.WorkPhone = mainDriver.Work_Phone__c;
        }

        //MotorVehicleQuotation
        if (quote.Motor_Vehicle__c != null) {
            r.MotorVehicleQuotation = new servicesFastrComAuQuotationData.MotorVehicleQuotationItem();
            //CoverEndDate --> Calculated on server side
            //CoverTypeCode
            r.MotorVehicleQuotation.CoverTypeCode = quote.Motor_Vehicle__c; //OK
            if ('3'.equals(quote.Motor_Cover_Term__c) || '6'.equals(quote.Motor_Cover_Term__c)) {
                r.MotorVehicleQuotation.CoverTypeCode = r.MotorVehicleQuotation.CoverTypeCode + quote.Motor_Cover_Term__c;
            }
            //Vehicle
            r.MotorVehicleQuotation.Vehicle = new servicesFastrComAuMotorData.Vehicle();
            //Vehicle - HasExistingDamage
            r.MotorVehicleQuotation.Vehicle.HasExistingDamage = false; // ?                        //OK
            //Vehicle - DetailsOfExistingDamage
            //Vehicle - EngineNumber            --> Required?
            //Vehicle - AccessoriesModificationsValues
            r.MotorVehicleQuotation.Vehicle.AccessoriesModificationsValues = 0; //OK
            //Vehicle - VehicleCondition
            r.MotorVehicleQuotation.Vehicle.VehicleCondition = quote.Vehicle_Condition__c; //OK
            //r.MotorVehicleQuotation.Vehicle.VehicleCondition = 'Unspecified';                //OK

            //VehicleLocationPostcode
            //r.MotorVehicleQuotation.VehicleLocationPostcode = Integer.valueOf(quote.Vehicle_Location_Postcode__c);    //OK
            r.MotorVehicleQuotation.VehicleLocationPostcode = String.valueOf(quote.Vehicle_Location_Postcode__c); //OK
            if (r.MotorVehicleQuotation.VehicleLocationPostcode.length() == 3) {
                r.MotorVehicleQuotation.VehicleLocationPostcode = '0' + r.MotorVehicleQuotation.VehicleLocationPostcode;
            }
            //VehicleLocationSuburb
            r.MotorVehicleQuotation.VehicleLocationSuburb = quote.Vehicle_Location_Suburb__c; //OK
            //VehicleLocationState
            r.MotorVehicleQuotation.VehicleLocationState = quote.Vehicle_Location_State__c; //OK
            //RatingProtectionRequired
            r.MotorVehicleQuotation.RatingProtectionRequired = quote.NCB_Protection__c; //OK
            //WindscreenProtectionRequired
            r.MotorVehicleQuotation.WindscreenProtectionRequired = quote.Windscreen_Protection__c; //OK
            //AdditionalDriver
            if (quote.Has_Additional_Driver__c) {
                List < Application_Additional_Driver__c > d = InsuranceQuoteUtils.getAllAdditionalDrivers(quote.Id);
                //System.debug('Total additional drivers >> ' + d.size());
                //System.debug('Additional drivers >> ' + JSON.serialize(d));
                if (!d.isEmpty()) {
                    r.MotorVehicleQuotation.AdditionalDrivers = new servicesFastrComAuMotorData.ArrayOfDriver();
                    r.MotorVehicleQuotation.AdditionalDrivers.Driver = new servicesFastrComAuMotorData.Driver[] {};
                    for (Application_Additional_Driver__c a: d) {
                        servicesFastrComAuMotorData.Driver driver = new servicesFastrComAuMotorData.Driver();
                        //DateOfBirth
                        driver.DateOfBirth = InsuranceQuoteUtils.convertToDateX(a.Date_of_Birth__c);
                        //FirstName
                        if (String.isNotBlank(a.First_Name__c)) {
                            driver.FirstName = a.First_Name__c;
                        }
                        //Surname
                        if (String.isNotBlank(a.Last_Name__c)) {
                            driver.Surname = a.Last_Name__c;
                        }
                        //Gender
                        driver.Gender = a.Gender__c;
                        //LicenseNumber
                        driver.LicenseNumber = a.Driver_Licence__c; //TO CHECK
                        //Title
                        //YearFirstLicensed
                        driver.YearFirstLicensed = Integer.valueOf(a.Year_First_Licence__c);
                        //RelationshipToInsured
                        //Accidents
                        //MotoringOffences
                        //LicenseEndorsements
                        //IsHoldingInternationalLicence
                        driver.IsHoldingInternationalLicence = false;
                        //YearSinceLastAccident
                        driver.YearSinceLastAccident = a.Time_Last_Fault_Accident__c;

                        r.MotorVehicleQuotation.AdditionalDrivers.Driver.add(driver);
                    }
                }
            } else {
                r.MotorVehicleQuotation.AdditionalDrivers = null;
            }
            if (quote.MV_Standard_Excess__c != null && quote.MV_Standard_Excess__c > 0) {
                r.MotorVehicleQuotation.NominatedBasicExcess = quote.MV_Standard_Excess__c;
            }
            if (quote.MV_Amount_Covered__c != null && quote.MV_Amount_Covered__c > 0) {
                r.MotorVehicleQuotation.NominatedAmountCovered = quote.MV_Amount_Covered__c;
            }

            //Load motoring offences
            Map < String,
            List < Insurance_Quote_Annotation__c >> annotationMap = InsuranceQuoteUtils.getInsuranceQuoteAnnotationsMap(quote.Id);

            //Main driver Motoring offences
            //Motoring offences
            if (quote.Has_Motoring_Offences__c) {
                servicesFastrComAuMotorData.MotoringOffence[] objList = new servicesFastrComAuMotorData.MotoringOffence[] {};
                servicesFastrComAuMotorData.MotoringOffence obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.MotoringOffence();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.DemeritPoints = Integer.valueOf(qa.Number__c);
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.MotoringOffences = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
                        r.MainInsured.MotoringOffences.MotoringOffence = objList;
                    }
                }
            }

            //Licence Refused / Suspended / Cancelled / Endorsed
            if (quote.Has_Licence_Santioned__c) {
                servicesFastrComAuMotorData.LicenseEndorsement[] objList = new servicesFastrComAuMotorData.LicenseEndorsement[] {};
                servicesFastrComAuMotorData.LicenseEndorsement obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.LicenseEndorsement();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.SuspensionPeriodInMonths = Integer.valueOf(qa.Number__c);
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.LicenseEndorsements = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
                        r.MainInsured.LicenseEndorsements.LicenseEndorsement = objList;
                    }
                }
            }

            //Accident / Claim History
            if (quote.Has_Accident_History__c) {
                servicesFastrComAuMotorData.Accident[] objList = new servicesFastrComAuMotorData.Accident[] {};
                servicesFastrComAuMotorData.Accident obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.Accident();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.AtFault = false;
                            if ('Y'.equals(qa.Is_Driver_Fault__c)) {
                                obj.AtFault = true;
                            }
                            obj.InsurerName = qa.Name_Insurer__c;
                            obj.LossAmount = qa.Amount__c;
                            obj.TheftOrMaliciousDamage = false;
                            if ('Y'.equals(qa.Was_Vehicle_Affected__c)) {
                                obj.TheftOrMaliciousDamage = true;
                            }
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.Accidents = new servicesFastrComAuMotorData.ArrayOfAccident();
                        r.MainInsured.Accidents.Accident = objList;
                    }
                }
            }

            //Other information
            if (quote.Other_Info_Question_1__c || quote.Other_Info_Question_2__c) {
                r.MotorVehicleQuotation.OtherInformation = new servicesFastrComAuMotorData.OtherInformation();
                r.MotorVehicleQuotation.OtherInformation.HasCriminalConviction = quote.Other_Info_Question_1__c;
                if (quote.Other_Info_Question_1__c) {
                    r.MotorVehicleQuotation.OtherInformation.HasCriminalConviction = true;
                    r.MotorVehicleQuotation.OtherInformation.CriminalConvictionDetails = quote.Other_Info_Details_1__c;
                }
                r.MotorVehicleQuotation.OtherInformation.HadInsuranceRefused = quote.Other_Info_Question_2__c;
                if (quote.Other_Info_Question_2__c) {
                    r.MotorVehicleQuotation.OtherInformation.HadInsuranceRefused = true;
                    r.MotorVehicleQuotation.OtherInformation.InsuranceRefusedDetails = quote.Other_Info_Details_2__c;
                }
            }



            //DealerPolicyReference
            //RedbookKey
            r.RedbookKey = quote.Redbook_Key__c; //OK
            //r.RedbookKey = 'AUVFORD2015AEDA'; //CODE PROVIDED AS A SAMPLE BY ERIC
        }

        //Customer Number

        //FmoCustomerNumber

        //CciQuotationItem

        //ServiceContractQuotationItem

        //WarrantyQuotationItem
        if (!String.isBlank(quote.Warranty_Insurance__c)) {
            r.WarrantyQuotationItem = new servicesFastrComAuQuotationData.WarrantyQuotationItem();
            //CoverTypeCode
            r.WarrantyQuotationItem.CoverTypeCode = quote.Warranty_Insurance__c;
            //Odometer
            if (quote.Odometer__c != null) {
                r.WarrantyQuotationItem.Odometer = Integer.valueOf(quote.Odometer__c);
            }
            //VehicleType
            r.WarrantyQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //DateFirstRegistered
            r.WarrantyQuotationItem.DateFirstRegistered = InsuranceQuoteUtils.convertToDateX(quote.Vehicle_Date_First_Registered__c);
            //StatutoryWarrantyEndDate|DealerPolicyReference|IsVehicleUnderStatutoryWarranty
            //r.WarrantyQuotationItem.VehicleLocationPostcode = Integer.valueOf(quote.Vehicle_Location_Postcode__c);
            //r.WarrantyQuotationItem.VehicleLocationSuburb = quote.Vehicle_Location_Suburb__c;            //OK
            //r.WarrantyQuotationItem.VehicleLocationState = quote.Vehicle_Location_State__c;                //OK
            r.WarrantyQuotationItem.IsVehicleUnderStatutoryWarranty = false;
            //RedbookKey
            r.RedbookKey = quote.Redbook_Key__c; //OK
            //r.RedbookKey = 'AUVFORD2015AEDA'; //CODE PROVIDED AS A SAMPLE BY ERIC
        }
        //TotalAssistQuotationItem
        if (!String.isBlank(quote.Total_assist_RTI__c)) {
            r.TotalAssistQuotationItem = new servicesFastrComAuQuotationData.TotalAssistQuotationItem();
            //CoverTypeCode
            r.TotalAssistQuotationItem.CoverTypeCode = quote.Total_assist_RTI__c;
            //VehicleMake
            //r.TotalAssistQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            //r.TotalAssistQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //VehicleType
            //r.TotalAssistQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //Insurer|InsuranceExpiry|CoverEndDate|DealerPolicyReference
        }
        //GapQuotationItem
        if (!String.isBlank(quote.Gap__c)) {
            r.GapQuotationItem = new servicesFastrComAuQuotationData.GapQuotationItem();
            //CoverTypeCode
            r.GapQuotationItem.CoverTypeCode = quote.Gap__c;
            //VehicleType
            r.GapQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //VehicleMake
            r.GapQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            r.GapQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //DetailedVehicleType
            r.GapQuotationItem.DetailedVehicleType = InsuranceQuoteUtils.getDetailedVehicleType(opp.Application_AssetDetail__r.Type__c, opp.Application__r.Type_of_Asset__c);
            //Insurer|InsuranceExpiry|DealerPolicyReference|IsNewForOldRequired|NewForOldTerm|TopUpBenefitAmount|DetailedVehicleType|IsNovatedLease
        }
        //LtiQuotationItem
        if (!String.isBlank(quote.LTI_BRI__c)) {
            r.LtiQuotationItem = new servicesFastrComAuQuotationData.LtiQuotationItem();
            //CoverTypeCode
            r.LtiQuotationItem.CoverTypeCode = quote.LTI_BRI__c;
            //VehicleMake
            r.LtiQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            r.LtiQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //VehicleType
            r.LtiQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //CoverEndDate|Insurer|InsuranceExpiry|DealerPolicyReference
            //VehicleUsage
            r.LtiQuotationItem.VehicleUsage = quote.Vehicle_Usage__c;
            //DetailedVehicleType
            r.LtiQuotationItem.DetailedVehicleType = InsuranceQuoteUtils.getDetailedVehicleType(opp.Application_AssetDetail__r.Type__c, opp.Application__r.Type_of_Asset__c);
            //TopUpBenefitAmount|DetailedVehicleType|IsNovatedLease|IsJointLivesInsured

        }
        //LgiQuotationItem

        //TruckGapQuotationItem
        if (String.isNotBlank(quote.Gap__c) || String.isNotBlank(quote.LTI_BRI__c)) {
            //FinanceDetails
            r.FinanceDetails = new servicesFastrComAuData.FinanceDetails();
            r.FinanceDetails.AmountFinanced = quote.Amount_Financed__c;
            if (quoting.Residual_Value__c != null && quoting.Residual_Value__c > 0) {
                r.FinanceDetails.BallonAmount = quoting.Residual_Value__c; //From quoting    
            } else {
                r.FinanceDetails.BallonAmount = 0;
            }
            if (quoting.Client_Rate__c != null && quoting.Client_Rate__c > 0) {
                r.FinanceDetails.FinanceInterestRate = quoting.Client_Rate__c; //From quoting    
            } else {
                r.FinanceDetails.FinanceInterestRate = 0;
            }
            r.FinanceDetails.FinanceTerm = Integer.valueOf(quote.Finance_Term__c);
            r.FinanceDetails.FinancierId = quote.Financier_Id__c;
            r.FinanceDetails.FinanceType = InsuranceQuoteUtils.getFinancierType(opp.Application__r.Application_Type__c);
        }

        //VehiclePurchasePrice
        r.VehiclePurchasePrice = quote.Vehicle_Purchase_Price__c; //OK
        //VehiclePurchaseDate

        //StampDutyState
        r.StampDutyState = quote.Vehicle_Location_State__c; //OK

        if (quote.Vehicle_Been_Registered__c) {
            //RegistrationNumber
            r.RegistrationNumber = opp.Application_AssetDetail__r.Rego__c;
            //RegistrationState
            r.RegistrationState = opp.Application_AssetDetail__r.Rego_State__c;
            //VinNumber
            r.VinNumber = opp.Application_AssetDetail__r.VIN__c;
        }

        //QuotationNumber
        if (!String.isBlank(quote.Quotation_Number__c)) {
            r.QuotationNumber = quote.Quotation_Number__c;
        }
        //VehicleUsage
        //r.VehicleUsage = InsuranceQuoteUtils.getUsageInteger(quote.Vehicle_Usage__c);
        r.VehicleUsage = 1; //OK
        //FinancierContractReference

        return r;

    }

    public static servicesFastrComAuData3.Date_x getDate(Integer day, Integer month, Integer year) {
        servicesFastrComAuData3.Date_x r = new servicesFastrComAuData3.Date_x();
        r.Day = day;
        r.Month = month;
        r.Year = year;
        return r;
    }

    /* FINAL REQUEST */
    private static servicesFastrComAuQuotationData.QuotationRequest makeEricFinalQuotationRequestDTO(InsuranceQuoteWS.QuoteParam param) {
        Custom_Opportunity__c opp = param.opp;
        Application_InsuranceQuote__c quote = param.quote;
        Application_Quoting__c quoting = param.quoting;

        Application_Additional_Driver__c mainDriver = InsuranceQuoteUtils.getMainDriver(quote.Id);

        servicesFastrComAuQuotationData.QuotationRequest r = new servicesFastrComAuQuotationData.QuotationRequest();
        //EricQuotationRequestDTO r = new EricQuotationRequestDTO();
        //CoverStartDate
        r.CoverStartDate = InsuranceQuoteUtils.convertToDateX(quote.Cover_Start_Date__c);
        //FSG
        //MainInsured
        r.MainInsured = new servicesFastrComAuQuotationData.MainInsured();

        //DateOfBirth
        r.MainInsured.DateOfBirth = InsuranceQuoteUtils.convertToDateX(mainDriver.Date_of_Birth__c); //OK
        //FirstName
        r.MainInsured.FirstName = mainDriver.First_Name__c;
        //Gender
        r.MainInsured.Gender = mainDriver.Gender__c; //OK
        //IsHoldingInternationalLicence
        r.MainInsured.IsHoldingInternationalLicence = mainDriver.Has_International_Licence__c; //OK
        //***********************************************************************************************************************************
        //LicenseEndorsements - TODO
        //***********************************************************************************************************************************
        //LicenseNumber
        r.MainInsured.LicenseNumber = mainDriver.Driver_Licence__c; //OK
        //***********************************************************************************************************************************
        //MotoringOffences - TODO
        //***********************************************************************************************************************************
        //Surname
        r.MainInsured.Surname = mainDriver.Last_Name__c;
        //Title
        //r.MainInsured.Title = app.Title_1__c;
        //YearFirstLicensed
        r.MainInsured.YearFirstLicensed = Integer.valueOf(mainDriver.Year_First_Licence__c); //OK
        //YearSinceLastAccident
        r.MainInsured.YearSinceLastAccident = mainDriver.Time_Last_Fault_Accident__c; //OK
        //***********************************************************************************************************************************
        // Business details - TODO
        //Abn
        r.MainInsured.Abn = mainDriver.ABN__c;
        //BusinessName
        //r.MainInsured.BusinessName = BusinessName;
        //***********************************************************************************************************************************
        //Email
        r.MainInsured.Email = mainDriver.Email__c;
        //InputTaxCredit
        r.MainInsured.InputTaxCredit = mainDriver.Input_Tax_Credit__c; //OK
        //IsBusinessUse
        if ('Business'.equalsIgnoreCase(quote.Vehicle_Usage__c)) {
            r.MainInsured.IsBusinessUse = true; //OK
            if (String.isNotBlank(opp.Application__r.Entity_Name__c)) {
                r.MainInsured.BusinessName = opp.Application__r.Entity_Name__c + ' (' + mainDriver.First_Name__c + ' ' + mainDriver.Last_Name__c + ')';
            } else {
                r.MainInsured.BusinessName = mainDriver.First_Name__c + ' ' + mainDriver.Last_Name__c;
            }
            r.MainInsured.FirstName = r.MainInsured.BusinessName;
            r.MainInsured.Surname = '';
        } else {
            r.MainInsured.IsBusinessUse = false;
        }
        //IsRegisteredOwner
        r.MainInsured.IsRegisteredOwner = false; //OK
        //Mobile
        if (!mainDriver.Hasnt_Mobile_Number__c) {
            r.MainInsured.Mobile = mainDriver.Mobile__c;
        }
        //Occupation
        r.MainInsured.Occupation = mainDriver.Occupation__c;
        //Phone1
        if (!String.isBlank(mainDriver.Home_Phone__c)) {
            r.MainInsured.Phone1 = mainDriver.Home_Phone__c;
        } else {
            r.MainInsured.Phone1 = r.MainInsured.Mobile;
        }
        //Postcode
        r.MainInsured.Postcode = String.valueOf(quote.Vehicle_Location_Postcode__c);
        if (r.MainInsured.Postcode.length() == 3) {
            r.MainInsured.Postcode = '0' + r.MainInsured.Postcode;
        }
        //PostalAddress1
        r.MainInsured.PostalAddress1 = mainDriver.Address_Line_1__c;
        if (String.isNotBlank(mainDriver.Address_Line_2__c)) {
            r.MainInsured.PostalAddress1 += ', ' + mainDriver.Address_Line_2__c;
        }
        //RegisteredForGst
        r.MainInsured.RegisteredForGst = mainDriver.Registered_for_GST__c;
        //State
        r.MainInsured.State = quote.Vehicle_Location_State__c; //OK
        //Suburb
        r.MainInsured.Suburb = quote.Vehicle_Location_Suburb__c;
        //WorkPhone
        if (!String.isBlank(mainDriver.Work_Phone__c)) {
            r.MainInsured.WorkPhone = mainDriver.Work_Phone__c;
        }

        //MotorVehicleQuotation
        if ('A'.equals(quote.MV_Acceptance__c)) {
            r.MotorVehicleQuotation = new servicesFastrComAuQuotationData.MotorVehicleQuotationItem();
            //CoverEndDate --> Calculated on server side
            //CoverTypeCode
            r.MotorVehicleQuotation.CoverTypeCode = quote.Motor_Vehicle__c; //OK
            if ('3'.equals(quote.Motor_Cover_Term__c) || '6'.equals(quote.Motor_Cover_Term__c)) {
                r.MotorVehicleQuotation.CoverTypeCode = r.MotorVehicleQuotation.CoverTypeCode + quote.Motor_Cover_Term__c;
            }
            //Vehicle
            r.MotorVehicleQuotation.Vehicle = new servicesFastrComAuMotorData.Vehicle();
            //Vehicle - HasExistingDamage
            r.MotorVehicleQuotation.Vehicle.HasExistingDamage = quote.Has_Existing_Damage__c; //               //OK
            if (r.MotorVehicleQuotation.Vehicle.HasExistingDamage) {
                r.MotorVehicleQuotation.Vehicle.DetailsOfExistingDamage = quote.Existing_Damage_Details__c;
            }
            //Vehicle - DetailsOfExistingDamage
            //Vehicle -             --> Required?
            r.MotorVehicleQuotation.Vehicle.EngineNumber = opp.Application_AssetDetail__r.Engine_No__c;
            //Vehicle - AccessoriesModificationsValues
            r.MotorVehicleQuotation.Vehicle.AccessoriesModificationsValues = 0; //OK
            //Vehicle - VehicleCondition
            r.MotorVehicleQuotation.Vehicle.VehicleCondition = quote.Vehicle_Condition__c; //OK
            //r.MotorVehicleQuotation.Vehicle.VehicleCondition = 'Unspecified';                //OK

            //VehicleLocationPostcode
            r.MotorVehicleQuotation.VehicleLocationPostcode = String.valueOf(quote.Vehicle_Location_Postcode__c); //OK
            if (r.MotorVehicleQuotation.VehicleLocationPostcode.length() == 3) {
                r.MotorVehicleQuotation.VehicleLocationPostcode = '0' + r.MotorVehicleQuotation.VehicleLocationPostcode;
            }
            //VehicleLocationSuburb
            r.MotorVehicleQuotation.VehicleLocationSuburb = quote.Vehicle_Location_Suburb__c; //OK
            //VehicleLocationState
            r.MotorVehicleQuotation.VehicleLocationState = quote.Vehicle_Location_State__c; //OK
            //RatingProtectionRequired
            r.MotorVehicleQuotation.RatingProtectionRequired = quote.NCB_Protection__c; //OK
            //WindscreenProtectionRequired
            r.MotorVehicleQuotation.WindscreenProtectionRequired = quote.Windscreen_Protection__c; //OK
            if (quote.MV_Standard_Excess__c != null && quote.MV_Standard_Excess__c > 0) {
                r.MotorVehicleQuotation.NominatedBasicExcess = quote.MV_Standard_Excess__c;
            }
            if (quote.MV_Amount_Covered__c != null && quote.MV_Amount_Covered__c > 0) {
                r.MotorVehicleQuotation.NominatedAmountCovered = quote.MV_Amount_Covered__c;
            }
            //Load motoring offences
            Map < String,
            List < Insurance_Quote_Annotation__c >> annotationMap = InsuranceQuoteUtils.getInsuranceQuoteAnnotationsMap(quote.Id);

            //AdditionalDrivers
            List < Application_Additional_Driver__c > d = InsuranceQuoteUtils.getAllAdditionalDrivers(quote.Id);
            if (quote.Has_Additional_Driver__c && !d.isEmpty()) {
                r.MotorVehicleQuotation.AdditionalDrivers = new servicesFastrComAuMotorData.ArrayOfDriver();
                r.MotorVehicleQuotation.AdditionalDrivers.Driver = new servicesFastrComAuMotorData.Driver[] {};
                for (Application_Additional_Driver__c a: d) {
                    servicesFastrComAuMotorData.Driver driver = new servicesFastrComAuMotorData.Driver();
                    //DateOfBirth
                    driver.DateOfBirth = InsuranceQuoteUtils.convertToDateX(a.Date_of_Birth__c);
                    //FirstName
                    driver.FirstName = a.First_Name__c;
                    //Surname
                    driver.Surname = a.Last_Name__c;
                    //Gender
                    driver.Gender = InsuranceQuoteUtils.getGender(a.Gender__c);
                    //LicenseNumber
                    driver.LicenseNumber = a.Driver_Licence__c;
                    //Title
                    //YearFirstLicensed
                    driver.YearFirstLicensed = Integer.valueOf(a.Year_First_Licence__c);
                    //RelationshipToInsured
                    //Accidents
                    //MotoringOffences
                    //LicenseEndorsements
                    //IsHoldingInternationalLicence
                    driver.IsHoldingInternationalLicence = a.Has_International_Licence__c;
                    //YearSinceLastAccident
                    driver.YearSinceLastAccident = a.Time_Last_Fault_Accident__c;

                    //Motoring offences
                    if (quote.Has_Motoring_Offences__c) {
                        servicesFastrComAuMotorData.MotoringOffence[] objList = new servicesFastrComAuMotorData.MotoringOffence[] {};
                        servicesFastrComAuMotorData.MotoringOffence obj = null;
                        List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
                        if (dt != null) {
                            for (Insurance_Quote_Annotation__c qa: dt) {
                                if (qa.Driver__c == a.Id) {
                                    //Create 
                                    obj = new servicesFastrComAuMotorData.MotoringOffence();
                                    obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                                    obj.IncidentDetails = qa.Detail__c;
                                    obj.DemeritPoints = Integer.valueOf(qa.Number__c);
                                    objList.add(obj);
                                }
                            }
                            if (!objList.isEmpty()) {
                                driver.MotoringOffences = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
                                driver.MotoringOffences.MotoringOffence = objList;
                            }
                        }
                    }

                    //Licence Refused / Suspended / Cancelled / Endorsed
                    if (quote.Has_Licence_Santioned__c) {
                        servicesFastrComAuMotorData.LicenseEndorsement[] objList = new servicesFastrComAuMotorData.LicenseEndorsement[] {};
                        servicesFastrComAuMotorData.LicenseEndorsement obj = null;
                        List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
                        if (dt != null) {
                            for (Insurance_Quote_Annotation__c qa: dt) {
                                if (qa.Driver__c == a.Id) {
                                    //Create 
                                    obj = new servicesFastrComAuMotorData.LicenseEndorsement();
                                    obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                                    obj.IncidentDetails = qa.Detail__c;
                                    obj.SuspensionPeriodInMonths = Integer.valueOf(qa.Number__c);
                                    objList.add(obj);
                                }
                            }
                            if (!objList.isEmpty()) {
                                driver.LicenseEndorsements = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
                                driver.LicenseEndorsements.LicenseEndorsement = objList;
                            }
                        }
                    }

                    //Accident / Claim History
                    if (quote.Has_Accident_History__c) {
                        servicesFastrComAuMotorData.Accident[] objList = new servicesFastrComAuMotorData.Accident[] {};
                        servicesFastrComAuMotorData.Accident obj = null;
                        List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
                        if (dt != null) {
                            for (Insurance_Quote_Annotation__c qa: dt) {
                                if (qa.Driver__c == a.Id) {
                                    //Create 
                                    obj = new servicesFastrComAuMotorData.Accident();
                                    obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                                    obj.IncidentDetails = qa.Detail__c;
                                    obj.AtFault = false;
                                    if ('Y'.equals(qa.Is_Driver_Fault__c)) {
                                        obj.AtFault = true;
                                    }
                                    obj.InsurerName = qa.Name_Insurer__c;
                                    obj.LossAmount = qa.Amount__c;
                                    obj.TheftOrMaliciousDamage = false;
                                    if ('Y'.equals(qa.Was_Vehicle_Affected__c)) {
                                        obj.TheftOrMaliciousDamage = true;
                                    }
                                    objList.add(obj);
                                }
                            }
                            if (!objList.isEmpty()) {
                                driver.Accidents = new servicesFastrComAuMotorData.ArrayOfAccident();
                                driver.Accidents.Accident = objList;
                            }
                        }
                    }

                    r.MotorVehicleQuotation.AdditionalDrivers.Driver.add(driver);
                }
            } else {
                r.MotorVehicleQuotation.AdditionalDrivers = null;
            }
            //DealerPolicyReference|NominatedBasicExcess|NominatedAmountCovered
            //RedbookKey
            //r.RedbookKey = quote.Redbook_Key__c;                                    //OK
            //r.RedbookKey = 'AUVFORD2015AEDA'; //CODE PROVIDED AS A SAMPLE BY ERIC

            //Main driver Motoring offences
            //Motoring offences
            if (quote.Has_Motoring_Offences__c) {
                servicesFastrComAuMotorData.MotoringOffence[] objList = new servicesFastrComAuMotorData.MotoringOffence[] {};
                servicesFastrComAuMotorData.MotoringOffence obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.MotoringOffence();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.DemeritPoints = Integer.valueOf(qa.Number__c);
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.MotoringOffences = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
                        r.MainInsured.MotoringOffences.MotoringOffence = objList;
                    }
                }
            }

            //Licence Refused / Suspended / Cancelled / Endorsed
            if (quote.Has_Licence_Santioned__c) {
                servicesFastrComAuMotorData.LicenseEndorsement[] objList = new servicesFastrComAuMotorData.LicenseEndorsement[] {};
                servicesFastrComAuMotorData.LicenseEndorsement obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.LicenseEndorsement();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.SuspensionPeriodInMonths = Integer.valueOf(qa.Number__c);
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.LicenseEndorsements = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
                        r.MainInsured.LicenseEndorsements.LicenseEndorsement = objList;
                    }
                }
            }

            //Accident / Claim History
            if (quote.Has_Accident_History__c) {
                servicesFastrComAuMotorData.Accident[] objList = new servicesFastrComAuMotorData.Accident[] {};
                servicesFastrComAuMotorData.Accident obj = null;
                List < Insurance_Quote_Annotation__c > dt = annotationMap.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
                if (dt != null) {
                    for (Insurance_Quote_Annotation__c qa: dt) {
                        if (qa.Driver__c == mainDriver.Id) {
                            //Create 
                            obj = new servicesFastrComAuMotorData.Accident();
                            obj.IncidentDate = InsuranceQuoteUtils.convertToDateX(qa.Date__c);
                            obj.IncidentDetails = qa.Detail__c;
                            obj.AtFault = false;
                            if ('Y'.equals(qa.Is_Driver_Fault__c)) {
                                obj.AtFault = true;
                            }
                            obj.InsurerName = qa.Name_Insurer__c;
                            obj.LossAmount = qa.Amount__c;
                            obj.TheftOrMaliciousDamage = false;
                            if ('Y'.equals(qa.Was_Vehicle_Affected__c)) {
                                obj.TheftOrMaliciousDamage = true;
                            }
                            objList.add(obj);
                        }
                    }
                    if (!objList.isEmpty()) {
                        r.MainInsured.Accidents = new servicesFastrComAuMotorData.ArrayOfAccident();
                        r.MainInsured.Accidents.Accident = objList;
                    }
                }
            }

            //Other information
            if (quote.Other_Info_Question_1__c || quote.Other_Info_Question_2__c) {
                r.MotorVehicleQuotation.OtherInformation = new servicesFastrComAuMotorData.OtherInformation();
                r.MotorVehicleQuotation.OtherInformation.HasCriminalConviction = quote.Other_Info_Question_1__c;
                if (quote.Other_Info_Question_1__c) {
                    r.MotorVehicleQuotation.OtherInformation.HasCriminalConviction = true;
                    r.MotorVehicleQuotation.OtherInformation.CriminalConvictionDetails = quote.Other_Info_Details_1__c;
                }
                r.MotorVehicleQuotation.OtherInformation.HadInsuranceRefused = quote.Other_Info_Question_2__c;
                if (quote.Other_Info_Question_2__c) {
                    r.MotorVehicleQuotation.OtherInformation.HadInsuranceRefused = true;
                    r.MotorVehicleQuotation.OtherInformation.InsuranceRefusedDetails = quote.Other_Info_Details_2__c;
                }
            }

        }

        //Customer Number

        //FmoCustomerNumber

        //CciQuotationItem

        //ServiceContractQuotationItem

        //WarrantyQuotationItem
        if ('A'.equals(quote.WRR_Acceptance__c)) {
            r.WarrantyQuotationItem = new servicesFastrComAuQuotationData.WarrantyQuotationItem();
            //CoverTypeCode
            r.WarrantyQuotationItem.CoverTypeCode = quote.Warranty_Insurance__c;
            //Odometer
            r.WarrantyQuotationItem.Odometer = Integer.valueOf(quote.Odometer__c);
            //VehicleType
            r.WarrantyQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //DateFirstRegistered
            r.WarrantyQuotationItem.DateFirstRegistered = InsuranceQuoteUtils.convertToDateX(quote.Vehicle_Date_First_Registered__c);
            //|DealerPolicyReference|
            if ('Y'.equals(quote.Vehicle_Under_Warranty__c)) {
                r.WarrantyQuotationItem.IsVehicleUnderStatutoryWarranty = true;
                r.WarrantyQuotationItem.StatutoryWarrantyEndDate = InsuranceQuoteUtils.convertToDateX(quote.Vehicle_Warranty_End_Date__c);
            } else {
                r.WarrantyQuotationItem.IsVehicleUnderStatutoryWarranty = false;
                r.WarrantyQuotationItem.StatutoryWarrantyEndDate = InsuranceQuoteUtils.convertToDateX(Date.today().addDays( - 1));
            }
            if (param.isPresenting && opp.Application_AssetDetail__r.Engine_No__c == null) {
                r.WarrantyQuotationItem.EngineNumber = 'X0000';
            } else {
                r.WarrantyQuotationItem.EngineNumber = opp.Application_AssetDetail__r.Engine_No__c;
            }
        }

        //TotalAssistQuotationItem - RTI
        if ('A'.equals(quote.TAS_Acceptance__c)) {
            r.TotalAssistQuotationItem = new servicesFastrComAuQuotationData.TotalAssistQuotationItem();
            //CoverTypeCode
            r.TotalAssistQuotationItem.CoverTypeCode = quote.Total_assist_RTI__c;
            //VehicleMake
            r.TotalAssistQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            r.TotalAssistQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //VehicleType
            r.TotalAssistQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //Insurer
            if (param.isPresenting && quote.Comprehensive_Insurer_Name__c == null) {
                r.TotalAssistQuotationItem.Insurer = 'TBA';
            } else {
                r.TotalAssistQuotationItem.Insurer = quote.Comprehensive_Insurer_Name__c;
            }
            //InsuranceExpiry
            if (param.isPresenting && quote.Comprehensive_Insurance_Expiry_Date__c == null) {
                r.TotalAssistQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(Date.today().addYears(1));
            } else {
                r.TotalAssistQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(quote.Comprehensive_Insurance_Expiry_Date__c);
            }
            //CoverEndDate|DealerPolicyReference
        }

        //GapQuotationItem
        if ('A'.equals(quote.GAP_Acceptance__c) && String.isNotBlank(quote.Gap__c)) {
            r.GapQuotationItem = new servicesFastrComAuQuotationData.GapQuotationItem();
            //CoverTypeCode
            r.GapQuotationItem.CoverTypeCode = quote.Gap__c;
            //InsuranceExpiry
            if (param.isPresenting && quote.Comprehensive_Insurance_Expiry_Date__c == null) {
                r.GapQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(Date.today().addYears(1));
            } else {
                r.GapQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(quote.Comprehensive_Insurance_Expiry_Date__c);
            }
            //Insurer
            if (param.isPresenting && quote.Comprehensive_Insurer_Name__c == null) {
                r.GapQuotationItem.Insurer = 'TBA';
            } else {
                r.GapQuotationItem.Insurer = quote.Comprehensive_Insurer_Name__c;
            }
            //IsNewForOldRequired
            r.GapQuotationItem.IsNewForOldRequired = false;
            //IsNovatedLease
            r.GapQuotationItem.IsNovatedLease = false;
            //VehicleMake
            r.GapQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            r.GapQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //VehicleType
            r.GapQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //DetailedVehicleType
            r.GapQuotationItem.DetailedVehicleType = InsuranceQuoteUtils.getDetailedVehicleType(opp.Application_AssetDetail__r.Type__c, opp.Application__r.Type_of_Asset__c);
            //|DealerPolicyReference|NewForOldTerm|TopUpBenefitAmount
        }

        //LtiQuotationItem
        if ('A'.equals(quote.LTI_Acceptance__c)) {
            r.LtiQuotationItem = new servicesFastrComAuQuotationData.LtiQuotationItem();
            //CoverTypeCode
            r.LtiQuotationItem.CoverTypeCode = quote.LTI_BRI__c;
            //VehicleMake
            r.LtiQuotationItem.VehicleMake = quote.Vehicle_Make__c;
            //VehicleModel
            r.LtiQuotationItem.VehicleModel = quote.Vehicle_Model__c;
            //VehicleType
            r.LtiQuotationItem.VehicleType = quote.Vehicle_Type__c;
            //CoverEndDate|DealerPolicyReference
            //VehicleUsage
            r.LtiQuotationItem.VehicleUsage = quote.Vehicle_Usage__c;
            //TopUpBenefitAmount|DetailedVehicleType|IsNovatedLease|IsJointLivesInsured
            //InsuranceExpiry
            if (param.isPresenting && quote.Comprehensive_Insurance_Expiry_Date__c == null) {
                r.LtiQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(Date.today().addYears(1));
            } else {
                r.LtiQuotationItem.InsuranceExpiry = InsuranceQuoteUtils.convertToDateX(quote.Comprehensive_Insurance_Expiry_Date__c);
            }
            //Insurer
            if (param.isPresenting && quote.Comprehensive_Insurer_Name__c == null) {
                r.LtiQuotationItem.Insurer = 'TBA';
            } else {
                r.LtiQuotationItem.Insurer = quote.Comprehensive_Insurer_Name__c;
            }
            //DetailedVehicleType
            r.LtiQuotationItem.DetailedVehicleType = InsuranceQuoteUtils.getDetailedVehicleType(opp.Application_AssetDetail__r.Type__c, opp.Application__r.Type_of_Asset__c);
        }

        //LgiQuotationItem

        // Financial Details
        if (String.isNotBlank(quote.Gap__c) || String.isNotBlank(quote.LTI_BRI__c) || String.isNotBlank(quote.Warranty_Insurance__c)) {
            //FinanceDetails
            r.FinanceDetails = new servicesFastrComAuData.FinanceDetails();
            r.FinanceDetails.AmountFinanced = quote.Amount_Financed__c;
            if (quoting.Residual_Value__c != null && quoting.Residual_Value__c > 0) {
                r.FinanceDetails.BallonAmount = quoting.Residual_Value__c; //From quoting    
            } else {
                r.FinanceDetails.BallonAmount = 0;
            }
            if (quoting.Client_Rate__c != null && quoting.Client_Rate__c > 0) {
                r.FinanceDetails.FinanceInterestRate = quoting.Client_Rate__c; //From quoting    
            } else {
                r.FinanceDetails.FinanceInterestRate = 0;
            }
            r.FinanceDetails.FinanceTerm = Integer.valueOf(quote.Finance_Term__c);
            r.FinanceDetails.FinancierId = quote.Financier_Id__c;
            r.FinanceDetails.FinanceType = InsuranceQuoteUtils.getFinancierType(opp.Application__r.Application_Type__c);
            //FinanceType|FinancierName
        }

        //QuotationNumber
        r.QuotationNumber = quote.Quotation_Number__c;

        //RedbookKey
        if (!String.isBlank(quote.Redbook_Key__c)) {
            r.RedbookKey = quote.Redbook_Key__c;
        }

        //RegistrationNumber
        r.RegistrationNumber = opp.Application_AssetDetail__r.Rego__c;
        if (param.isPresenting && r.RegistrationNumber == null) {
            r.RegistrationNumber = 'X0000';
        }
        //RegistrationState
        r.RegistrationState = opp.Application_AssetDetail__r.Rego_State__c;
        if (param.isPresenting && r.RegistrationState == null) {
            r.RegistrationState = quote.Vehicle_Location_State__c;
        }
        //StampDutyState
        r.StampDutyState = quote.Vehicle_Location_State__c;
        //VinNumber                          //OK
        if (!String.isBlank(opp.Application_AssetDetail__r.VIN__c)) {
            r.VinNumber = opp.Application_AssetDetail__r.VIN__c;
        }
        if (param.isPresenting && r.VinNumber == null) {
            r.VinNumber = 'VIN12345678901234';
        }
        //VehiclePurchaseDate
        if ('A'.equals(quote.GAP_Acceptance__c) || 'A'.equals(quote.LTI_Acceptance__c) || 'A'.equals(quote.TAS_Acceptance__c)) {
            r.VehiclePurchaseDate = InsuranceQuoteUtils.convertToDateX(quote.Vehicle_Purchase_Date__c);
        }
        //VehiclePurchasePrice
        r.VehiclePurchasePrice = quote.Vehicle_Purchase_Price__c; //OK

        //VehicleUsage
        //r.VehicleUsage = InsuranceQuoteUtils.getUsageInteger(quote.Vehicle_Usage__c);
        r.VehicleUsage = 1; //OK

        return r;
    }

    public class QuoteParam {
        public Custom_Opportunity__c opp {set;get;}
        public Application_InsuranceQuote__c quote {set;get;}
        public Application_Quoting__c quoting {set;get;}
        public Boolean preserveAcceptance {set;get;}
        public List < InsuranceQuoteUtils.PaymentMethodDTO > paymentMethods;
        public Boolean isPresenting {set;get;}
        public List<Insurance_History_Request__c> requestList {set;get;}
        public QuoteParam () {
            this.preserveAcceptance = false;
            this.isPresenting = false;
        }
        public void addRequest(Insurance_History_Request__c a) {
            if (a == null) return;
            if (this.requestList == null) {
                this.requestList = new List<Insurance_History_Request__c>();   
            }
            this.requestList.add(a);
        }
    }

    public static List < Insurance_Payment_Method__c > makePaymentMethods(Id quoteId, String product, servicesFastrComAuQuotationData.ArrayOfPaymentMethod methodList) {
        List < Insurance_Payment_Method__c > r = new List < Insurance_Payment_Method__c > ();
        if (methodList != null && methodList.PaymentMethod != null) {
            for (servicesFastrComAuQuotationData.PaymentMethod p: methodList.PaymentMethod) {
                Insurance_Payment_Method__c a = new Insurance_Payment_Method__c();
                a.Insurance_Quote__c = quoteId;
                a.Product__c = product;
                a.Payment_Method__c = p.Code;
                a.Instalment_Amount__c = p.InstalmentAmount;
                a.Number_Instalments__c = p.NumberOfInstalments;
                a.Payable__c = p.Payable;
                r.add(a);
            }
        }
        return r;
    }

    //Payment Request
    public static List < Insurance_Quote_Policy__c > buyPolicy(InsuranceQuoteWS.QuoteParam param) {
        List < Insurance_Quote_Policy__c > policyList = new List < Insurance_Quote_Policy__c > ();
        //Stub creator
        servicesFastrComAuPayment.PaymentServiceEndpoint_wsHttp ws = new servicesFastrComAuPayment.PaymentServiceEndpoint_wsHttp();

        servicesFastrComAuPaymentData.PaymentRequest rqst = makePaymentRequest(param);

        String jsonStringParse = '[' + JSON.serialize (rqst) + ']';
        System.debug('PAYMENT DATA >> ');
        System.debug(jsonStringParse);
        System.debug(JSON.serializePretty(rqst));
        param.requestList = null;
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_BUYPOLICY, InsuranceQuoteUtils.TYPE_REQ, jsonStringParse));

        //ws.timeout_x = 19000;
        ws.timeout_x = 60000;
        servicesFastrComAuPaymentData.DetailedPaymentResponse rpns = ws.ProcessDetailed(rqst, WS_API_KEY);

        jsonStringParse = '[' + JSON.serialize(rpns) + ']';

        System.debug('RESPONSE DATA >> ');
        System.debug(jsonStringParse);
        param.addRequest(InsuranceQuoteUtils.trackWS(param.opp, param.quote, InsuranceQuoteUtils.PROCESS_BUYPOLICY, InsuranceQuoteUtils.TYPE_RES, jsonStringParse));

        if (rpns != null) {
            System.debug('Saving response...');

            //Status
            param.quote.Status__c = 'P'; //Processed

            //Store WS response
            param.quote.Payment_Failure_Reason__c = rpns.FailureReason;
            if (rpns.Policies != null && rpns.Policies.DetailedPolicy != null) {
                for (servicesFastrComAuPaymentData.DetailedPolicy a: rpns.Policies.DetailedPolicy) {
                    Insurance_Quote_Policy__c p = new Insurance_Quote_Policy__c();
                    p.Application_Insurance_Quote__c = param.quote.Id;
                    p.Policy_Number__c = a.PolicyNumber;
                    p.Cover_Type__c = a.CoverType;
                    p.Product_Code__c = a.ProductCode;
                    if (a.PolicySchedule != null) {
                        p.Document_Description__c = a.PolicySchedule.DocumentDescription;
                        p.Document_Url__c = a.PolicySchedule.DocumentUrl;
                    }
                    policyList.add(p);
                }
                if (!policyList.isEmpty()) {
                    insert policyList;
                }
            }
            update param.quote;
        }
        // save history request
        if (param.requestList != null && !param.requestList.isEmpty()) {
            insert param.requestList;
        }
        return policyList;
    }

    private static servicesFastrComAuPaymentData.PaymentRequest makePaymentRequest(InsuranceQuoteWS.QuoteParam param) {
        servicesFastrComAuPaymentData.PaymentRequest r = new servicesFastrComAuPaymentData.PaymentRequest();
        Map < Id, InsuranceQuoteUtils.PaymentMethodDTO > paymentMap = new Map < Id, InsuranceQuoteUtils.PaymentMethodDTO > ();
        for (InsuranceQuoteUtils.PaymentMethodDTO a: param.paymentMethods) {
            if (!a.isRemoved) {
                paymentMap.put(a.data.Id, a);
            }
        }
        System.debug('Total method payments >> ' + paymentMap.size());
        r.QuotationNumber = param.quote.Quotation_Number__c;
        //Gap
        if ('A'.equalS(param.quote.GAP_Acceptance__c)) {
            r.GapQuotationItemPaymentDetail = makeItemPaymentDetail(param.quote.GAP_Payment_Method__c, paymentMap.get(param.quote.GAP_Payment_Detail__c));
        }
        //LTI
        if ('A'.equalS(param.quote.LTI_Acceptance__c)) {
            r.LtiQuotationItemPaymentDetail = makeItemPaymentDetail(param.quote.LTI_Payment_Method__c, paymentMap.get(param.quote.LTI_Payment_Detail__c));
        }
        //RTI (TAS)
        if ('A'.equalS(param.quote.TAS_Acceptance__c)) {
            r.TotalAssistQuotationItemPaymentDetail = makeItemPaymentDetail(param.quote.TAS_Payment_Method__c, paymentMap.get(param.quote.TAS_Payment_Detail__c));
        }
        //MV
        if ('A'.equalS(param.quote.MV_Acceptance__c)) {
            r.MotorQuotationItemPaymentDetail = makeItemPaymentDetail(param.quote.MV_Payment_Method__c, paymentMap.get(param.quote.MV_Payment_Detail__c));
        }
        //Warranty
        if ('A'.equalS(param.quote.WRR_Acceptance__c)) {
            r.WarrantyQuotationItemPaymentDetail = makeItemPaymentDetail(param.quote.WRR_Payment_Method__c, paymentMap.get(param.quote.WRR_Payment_Detail__c));
        }
        return r;
    }

    private static servicesFastrComAuPaymentData.QuotationItemPaymentDetail makeItemPaymentDetail(String methodCode, InsuranceQuoteUtils.PaymentMethodDTO paymentMethod) {
        servicesFastrComAuPaymentData.QuotationItemPaymentDetail r = new servicesFastrComAuPaymentData.QuotationItemPaymentDetail();
        r.PaymentMethodCode = methodCode;
        if ('CREDITCARD'.equals(methodCode) || 'PREMFUND12CC'.equals(methodCode)) {
            r.CreditCard = new servicesFastrComAuPaymentData.CreditCardDetails();
            r.CreditCard.CardholderName = paymentMethod.data.Holder_Name__c;
            r.CreditCard.CardNumber = paymentMethod.data.Credit_Card_Number__c;
            r.CreditCard.VerificationCode = paymentMethod.data.Verification_Code__c;
            r.CreditCard.Expiry = new servicesFastrComAuPaymentData.CreditCardExpiry();
            r.CreditCard.Expiry.Month = paymentMethod.data.Expiry_Month__c;
            r.CreditCard.Expiry.Year = paymentMethod.data.Expiry_Year__c.substring(2);
        } else if ('PREMFUND12BA'.equals(methodCode)) {
            r.BankAccount = new servicesFastrComAuPaymentData.BankAccountDetails();
            r.BankAccount.AccountHolderName = paymentMethod.data.Holder_Name__c;
            r.BankAccount.AccountNumber = paymentMethod.data.Account_Number__c;
            r.BankAccount.Bsb = paymentMethod.data.BSB_Number__c;
        }
        return r;
    }

}