/**
 * See https://github.com/financialforcedev/fflib-apex-common for more info
 *
 * Install library via
 *   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
 */

/**
 * Encapsulates all service layer logic for a given function or module in the application
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
 *
 **/
public class InsuranceQuoteRestWS {
	
    public static final String CODE_ACKNEXCLUSION = 'IDE18';
    
	public class QuoteParam {
        public Custom_Opportunity__c opp {set;get;}
        public Application_InsuranceQuote__c quote {set;get;}
        public Application_Quoting__c quoting {set;get;}
        public Boolean preserveAcceptance {set;get;}
        public List<InsuranceQuoteUtils.PaymentMethodDTO> paymentMethods;
        public List<Insurance_History_Request__c> requestList {set;get;}
        public String processType {set;get;}

        public QuoteParam () {
            this.preserveAcceptance = false;
            this.processType = InsuranceQuoteUtils.PROCESS_INITQUOTE;
        }

        public void addRequest(Insurance_History_Request__c a) {
            if (a == null) return;
            if (this.requestList == null) {
                this.requestList = new List<Insurance_History_Request__c>();   
            }
            this.requestList.add(a);
        }

        public Boolean isFinalQuote() {
            if (InsuranceQuoteUtils.PROCESS_FINALQUOTE.equals(this.processType)) {
                return true;
            }
            return false;
        }

        public Boolean isPresenting() {
            if (InsuranceQuoteUtils.PROCESS_PRESENTATION.equals(this.processType)) {
                return true;
            }
            return false;
        }

        public Boolean isMVPresenting() {
            if (InsuranceQuoteUtils.PROCESS_MVPRESENTATION.equals(this.processType)) {
                return true;
            }
            return false;
        }

        public Boolean isInitinalQuote() {
            if (InsuranceQuoteUtils.PROCESS_INITQUOTE.equals(this.processType)) {
                return true;
            }
            return false;
        }
    }

	public static Map<String, List<String>> getQuote(QuoteParam param) {
        Map<String, List<String>> r = new Map<String, List<String>>();
        //try {
    		validParameters(param);
            EricDTOs.QuoteDetails q = buildQuoteDetails(param);
        
    		//System.debug(JSON.serializePretty(q,true));
    		String jsonStringParse = JSON.serialize(q);
        
            param.addRequest(
                InsuranceQuoteUtils.trackWS(param.opp, param.quote, 
                    param.processType, 
                    InsuranceQuoteUtils.TYPE_REQ, jsonStringParse)
                );
            EricDTOs.ResponseDTO qres = EricServices.getQuote(param.quote.Quote_Id__c, q);
        
            if (qres != null) {
                jsonStringParse = JSON.serialize(qres);
                param.addRequest(
                    InsuranceQuoteUtils.trackWS(param.opp, param.quote, 
                        param.processType, 
                        InsuranceQuoteUtils.TYPE_RES, jsonStringParse)
                    );
                Map<String,List<EricDTOs.Message>> allmsgs = qres.getAllMessages();
                for (String k: allmsgs.keySet()) {
                    List<String> msgs = r.get(k);
                    if (msgs == null) {
                        msgs = new List<String>();
                        r.put(k, msgs);
                    }
                    for (EricDTOs.Message m: allmsgs.get(k)) {
                        msgs.add(m.toString());
                    }
                }
                // Update details
                saveWebServiceResponse(param, qres);
            }
            if (param.requestList != null && !param.requestList.isEmpty()) {
                insert param.requestList;
            }
        //} catch (BaseException e) {
        //    r.put('Error', new List<String> {e.getMessage()});
        //} catch (Exception e) {
        //    r.put('Error', new List<String> {
        //        e.getTypeName() + '|' + e.getCause() + '|' + e.getMessage() + '|' + e.getLineNumber()
        //    });
        //}
        
        return r;
	}

    public static Map<String, List<String>> preLodgeQuote(QuoteParam param) {
        Map<String, List<String>> r = new Map<String, List<String>>();
        //try {
            validParameters(param);
            EricDTOs.ResponseDTO qres = new EricDTOs.ResponseDTO();
            String jsonStringParse = null;
            if (!param.quote.Is_PreLodged__c) {
                EricDTOs.PreLodgement plodge = buildPreLodgement(param);
                //System.debug(JSON.serializePretty(plodge,true));
                jsonStringParse = JSON.serialize(plodge);
                param.addRequest(
                    InsuranceQuoteUtils.trackWS(param.opp, param.quote, 
                        param.processType, 
                        InsuranceQuoteUtils.TYPE_REQ, jsonStringParse)
                    );
                qres = EricServices.preLodgeQuote(plodge);
            }
            if (qres != null) {

                if (!qres.hasErrors() && !param.quote.Is_Lodged__c) {
                    // Create object details
                    EricDTOs.Lodgement lodge = buildLodgement(param);
                    // Record in history
                    jsonStringParse = JSON.serialize(lodge);
                    param.addRequest(
                        InsuranceQuoteUtils.trackWS(param.opp, param.quote, 
                            InsuranceQuoteUtils.PROCESS_LODGE, 
                            InsuranceQuoteUtils.TYPE_REQ, jsonStringParse)
                        );
                    // Invoke the service
                    EricDTOs.ResponseDTO qres2 = EricServices.lodgeQuote(lodge);
                    if (qres2 != null) {
                        qres.lodgementResponse = qres2.lodgementResponse;
                    }
                }
                
                jsonStringParse = JSON.serialize(qres);
                param.addRequest(
                    InsuranceQuoteUtils.trackWS(param.opp, param.quote, 
                        param.processType, 
                        InsuranceQuoteUtils.TYPE_RES, jsonStringParse)
                    );
                Map<String,List<EricDTOs.Message>> allmsgs = qres.getAllMessages();
                for (String k: allmsgs.keySet()) {
                    List<String> msgs = r.get(k);
                    if (msgs == null) {
                        msgs = new List<String>();
                        r.put(k, msgs);
                    }
                    for (EricDTOs.Message m: allmsgs.get(k)) {
                        msgs.add(m.toString());
                    }
                }
                // Update details
                saveWebServicePaymentResponse(param, qres);
            }
            if (param.requestList != null && !param.requestList.isEmpty()) {
                insert param.requestList;
            }
        //} catch (BaseException e) {
        //    r.put('Error', new List<String> {e.getMessage()});
        //} catch (Exception e) {
        //    r.put('Error', new List<String> {
        //        e.getTypeName() + '|' + e.getCause() + '|' + e.getMessage() + '|' + e.getLineNumber()
        //    });
        //}
        return r;
    }

	private static void validParameters(QuoteParam param) {
		Set<String> msgs = new Set<String>();
		if (param == null) {
			msgs.add('Null parameter to get a quote');
		} else {
			if (param.opp == null) {
				msgs.add('There is not any Opportunity to get an insurance quote');
			} 
			if (param.quoting == null) {
				msgs.add('There is not any Quoting tool to get an insurance quote');
			}
		}
		if (!msgs.isEmpty()) {
			throw new InsuranceServiceException(msgs);
		}
	}

	private static EricDTOs.QuoteDetails buildQuoteDetails(QuoteParam param){
        EricDTOs.QuoteDetails r = new EricDTOs.QuoteDetails();
		r.GeneralDetails = buildGeneralDetails(param);
        //if (String.isNotBlank(param.quote.Gap__c) || String.isNotBlank(param.quote.LTI_BRI__c)) {
			r.FinancialDetails = buildFinancialDetails(param);
        //}
		r.InsuredDetails = buildInsuredDetails(param);
        r.VehicleDetails = buildVehicleDetails(param);
        r.ItemDetails = buildItemDetails(param, r.InsuredDetails);
        
		return r;
	}

	private static EricDTOs.GeneralDetails buildGeneralDetails(QuoteParam param) {
		EricDTOs.GeneralDetails r = new EricDTOs.GeneralDetails();
        if (param.quote.Cover_Start_Date__c != null) {
            if (param.isPresenting() && param.quote.Cover_Start_Date__c < Date.today()) {
                r.CoverStartDate = DateUtils.formatDate(Date.today(), DateUtils.YYYY_MM_DD);
            } else {
			    r.CoverStartDate = DateUtils.formatDate(param.quote.Cover_Start_Date__c, DateUtils.YYYY_MM_DD);
            }
		} else {
			r.CoverStartDate = DateUtils.formatDate(Datetime.now(), DateUtils.YYYY_MM_DD);
		}
        if (param.quote.Vehicle_Purchase_Price__c != null) {
			r.PurchasePrice = String.valueOf(param.quote.Vehicle_Purchase_Price__c.setScale(0));
		}
		//PurchaseDate
        //if ('A'.equals(param.quote.GAP_Acceptance__c) || 
        //	'A'.equals(param.quote.LTI_Acceptance__c) || 
        //	'A'.equals(param.quote.TAS_Acceptance__c)) {
        //    r.PurchaseDate = DateUtils.formatDate(param.quote.Vehicle_Purchase_Date__c, DateUtils.YYYY_MM_DD);
        //}
        //if (!param.isFinalQuote()) {
            if (!param.isFinalQuote()) {
                if (param.quote.Vehicle_Purchase_Date__c == null || param.quote.Vehicle_Purchase_Date__c < Date.today()) {
                    r.PurchaseDate = DateUtils.formatDate(Date.today(), DateUtils.YYYY_MM_DD);
                } else {
                    r.PurchaseDate = DateUtils.formatDate(param.quote.Vehicle_Purchase_Date__c, DateUtils.YYYY_MM_DD);    
                }
            } 
            //if (String.isNotBlank(param.quote.LTI_BRI__c)) {
            if (param.quote.Vehicle_Purchase_Date__c != null) {
                r.PurchaseDate = DateUtils.formatDate(param.quote.Vehicle_Purchase_Date__c, DateUtils.YYYY_MM_DD);
            } else if (!param.isFinalQuote()) {
                r.PurchaseDate = DateUtils.formatDate(Date.today(), DateUtils.YYYY_MM_DD);
            }
            //}
            
        //}
        r.StampDutyState = param.quote.Vehicle_Location_State__c;
        //Jesus Mora 2020-06-04 start
        if (String.isNotBlank(param.quote.LPI__c)) {
            r.EmploymentQuestions = new EricDTOs.EmploymentQuestions();
            r.EmploymentQuestions.ContinuouslyEmployed = true;
            r.EmploymentQuestions.CurrentlyEmployed = InsuranceQuoteUtils.isCurrentlyEmployed(param.opp.Application__r.Mode_of_Employment_1__c);
            r.EmploymentQuestions.SelfEmployed = InsuranceQuoteUtils.isSelfEmployed(param.opp.Application__r.Mode_of_Employment_1__c);
        }
        //Jesus Mora 2020-06-04 end
        return r;
	}

	private static EricDTOs.FinancialDetails buildFinancialDetails(QuoteParam param) {
		EricDTOs.FinancialDetails r = new EricDTOs.FinancialDetails();
		if (param.quote.Amount_Financed__c != null) {
            //Jesus Mora 2020-06-04 start
            Decimal naf = param.quote.Amount_Financed__c;
            if ('A'.equals(param.quote.LPI_Acceptance__c)){
                naf = naf - param.quoting.Insurance_AIC_Retail_Price__c;  
            }
			//r.AmountFinanced = naf.intValue();
			r.AmountFinanced = naf;
            //Jesus Mora 2020-06-04 end
		}
		if (param.quoting.Residual_Value__c != null && param.quoting.Residual_Value__c > 0) {
            r.BalloonAmount = String.valueOf(param.quoting.Residual_Value__c);
        } else {
            r.BalloonAmount = '0';
        }
        r.FinanceTerm = String.valueOf(param.quote.Finance_Term__c);
        r.FinancierId = param.quote.Financier_Id__c;
        r.FinanceType = InsuranceQuoteUtils.getFinancierType(
        	param.opp.Application__r.Application_Type__c);
        return r;
	}

	private static EricDTOs.InsuredDetails buildInsuredDetails(QuoteParam param) {
        
		EricDTOs.InsuredDetails r = new EricDTOs.InsuredDetails();
		Application_Additional_Driver__c mainDriver = InsuranceQuoteUtils.getMainDriver(param.quote.Id);
        
		if (mainDriver == null) {
			throw new InsuranceServiceException('There is not a main driver');
		}
		// MAIN INSURED
		r.MainInsured = new EricDTOs.Insured();
		// Person Details
		r.MainInsured.Title = mainDriver.Title__c;
		r.MainInsured.FirstName = mainDriver.First_Name__c;
		r.MainInsured.Surname = mainDriver.Last_Name__c;
		r.MainInsured.FullName = r.MainInsured.FirstName + ' ' + r.MainInsured.Surname;
		if (String.isNotBlank(mainDriver.Gender__c)) {
			r.MainInsured.Gender = new EricDTOs.Gender(mainDriver.Gender__c);
		}
		r.MainInsured.DateOfBirth = mainDriver.Date_of_Birth__c;
		// Ohter details
		// Abn
        r.MainInsured.Abn = mainDriver.ABN__c;
        // IsBusinessUse
        if ('Business'.equalsIgnoreCase(param.quote.Vehicle_Usage__c)) {
            r.MainInsured.IsBusinessUse = 'true';
            if (String.isNotBlank(param.opp.Application__r.Entity_Name__c)) {
                r.MainInsured.BusinessName = param.opp.Application__r.Entity_Name__c + ' (' + mainDriver.First_Name__c + ' ' + mainDriver.Last_Name__c + ')';
            } else {
                r.MainInsured.BusinessName = r.MainInsured.FullName;
            }
        } else {
            r.MainInsured.IsBusinessUse = 'false';
        }
        // Email
        r.MainInsured.Email = mainDriver.Email__c;
        // InputTaxCredit
        if (mainDriver.Input_Tax_Credit__c != null) {
        	r.MainInsured.InputTaxCredit = mainDriver.Input_Tax_Credit__c.format();
        }
        // Mobile
        r.MainInsured.Mobile = mainDriver.Mobile__c;
        // Occupation
        r.MainInsured.Occupation = mainDriver.Occupation__c;
        // Phone1
        if (!String.isBlank(mainDriver.Home_Phone__c)) {
            r.MainInsured.Phone1 = mainDriver.Home_Phone__c;
        } else {
            r.MainInsured.Phone1 = r.MainInsured.Mobile;
        }
        // PostalAddress1
        r.MainInsured.PostalAddress1 = mainDriver.Address_Line_1__c;
        if (String.isNotBlank(mainDriver.Address_Line_2__c)) {
            r.MainInsured.PostalAddress1 += ', ' + mainDriver.Address_Line_2__c;
        }
        // Postcode
        r.MainInsured.Postcode = String.valueOf(param.quote.Vehicle_Location_Postcode__c);
        // RegisteredForGst
        r.MainInsured.RegisteredForGst = String.valueOf(mainDriver.Registered_for_GST__c);
        // State
        r.MainInsured.State = param.quote.Vehicle_Location_State__c;
        // Suburb
        r.MainInsured.Suburb = param.quote.Vehicle_Location_Suburb__c;
        // WorkPhone
        if (!String.isBlank(mainDriver.Work_Phone__c)) {
            r.MainInsured.WorkPhone = mainDriver.Work_Phone__c;
        }
		// Dirver details
		// IsHoldingInternationalLicence
        r.MainInsured.IsHoldingInternationalLicence = mainDriver.Has_International_Licence__c;
        // LicenseNumber
        r.MainInsured.LicenseNumber = mainDriver.Driver_Licence__c;
        
        // YearFirstLicensed
        if (mainDriver.Year_First_Licence__c != null) {
        	r.MainInsured.YearFirstLicensed = String.valueOf(mainDriver.Year_First_Licence__c.intValue());
        }
        r.MainInsured.YearSinceLastAccident = 'NeverHadAnAccident';
        if ((param.quote.Motor_Vehicle__c != null && !param.isFinalQuote()) ||
            ('A'.equals(param.quote.MV_Acceptance__c) && param.isFinalQuote())) {
            // YearSinceLastAccident
            r.MainInsured.YearSinceLastAccident = mainDriver.Time_Last_Fault_Accident__c;
        }

        // Details for MV
     //   if ((param.quote.Motor_Vehicle__c != null && !param.isFinalQuote()) ||
     //       ('A'.equals(param.quoting.MV_Acceptance__c) && param.isFinalQuote()) {
     //   	//AdditionalDriver
     //       if (param.quote.Has_Additional_Driver__c) {
     //           List <Application_Additional_Driver__c> d = InsuranceQuoteUtils.getAllAdditionalDrivers(param.quote.Id);
     //           if (!d.isEmpty()) {
     //               r.AdditionalDrivers = new List<EricDTOs.Driver>();
     //               for (Application_Additional_Driver__c a: d) {
     //                   EricDTOs.Driver driver = new EricDTOs.Driver();
     //                   //DateOfBirth
     //                   driver.DateOfBirth = a.Date_of_Birth__c;
     //                   //FirstName
     //                   if (String.isNotBlank(a.First_Name__c)) {
     //                       driver.FirstName = a.First_Name__c;
     //                   }
     //                   //Surname
     //                   if (String.isNotBlank(a.Last_Name__c)) {
     //                       driver.Surname = a.Last_Name__c;
     //                   }
     //                   //Gender
     //                   if (String.isNotBlank(a.Gender__c)) {
					//		driver.Gender = new EricDTOs.Gender(a.Gender__c);
					//	}
     //                   //LicenseNumber
     //                   driver.LicenseNumber = a.Driver_Licence__c; //TO CHECK
     //                   //Title
     //                   //YearFirstLicensed
     //                   if (mainDriver.Year_First_Licence__c != null) {
				 //       	driver.YearFirstLicensed = String.valueOf(a.Year_First_Licence__c.intValue());
				 //       }
     //                   //RelationshipToInsured
     //                   //Accidents
     //                   //MotoringOffences
     //                   //LicenseEndorsements
     //                   //IsHoldingInternationalLicence
     //                   driver.IsHoldingInternationalLicence = false;
     //                   //YearSinceLastAccident
     //                   driver.YearSinceLastAccident = a.Time_Last_Fault_Accident__c;

     //                   r.AdditionalDrivers.add(driver);
     //               }
     //           }
     //       }

	    //    //Load annotation
	    //    Map <String, List <Insurance_Quote_Annotation__c>> annotationMap = 
	    //    	InsuranceQuoteUtils.getInsuranceQuoteAnnotationsMap(param.quote.Id);
	    //    // Accident / Claim History
	    //    if (param.quote.Has_Accident_History__c) {
	    //    	r.MainInsured.Accidents = new List<EricDTOs.Accident>();
	    //    	List <Insurance_Quote_Annotation__c> dt = annotationMap.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
	    //    	if (dt != null) {
	    //    		EricDTOs.Accident obj = null;
	    //    		for (Insurance_Quote_Annotation__c qa: dt) {
	    //                if (qa.Driver__c == mainDriver.Id) {
	    //                    //Create 
	    //                    obj = new EricDTOs.Accident();
	    //                    obj.IncidentDate = DateUtils.convertToString(qa.Date__c, DateUtils.YYYY_MM_DD);
	    //                    obj.IncidentDetails = qa.Detail__c;
	    //                    obj.AtFault = false;
	    //                    if ('Y'.equals(qa.Is_Driver_Fault__c)) {
	    //                        obj.AtFault = true;
	    //                    }
	    //                    obj.InsurerName = qa.Name_Insurer__c;
	    //                    obj.LossAmount = qa.Amount__c;
	    //                    obj.TheftOrMaliciousDamage = false;
	    //                    if ('Y'.equals(qa.Was_Vehicle_Affected__c)) {
	    //                        obj.TheftOrMaliciousDamage = true;
	    //                    }
	    //                    r.MainInsured.Accidents.add(obj);
	    //                }
	    //            }
	    //    	}
	    //    }
	    //    // Licence Refused / Suspended / Cancelled / Endorsed
	    //    if (param.quote.Has_Licence_Santioned__c) {
	    //    	r.MainInsured.LicenseEndorsements = new List<EricDTOs.LicenseEndorsement>();
	    //    	List <Insurance_Quote_Annotation__c> dt = annotationMap.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
	    //    	if (dt != null) {
	    //    		EricDTOs.LicenseEndorsement obj = null;
	    //    		for (Insurance_Quote_Annotation__c qa: dt) {
	    //                if (qa.Driver__c == mainDriver.Id) {
	    //                    //Create 
	    //                    obj = new EricDTOs.LicenseEndorsement();
	    //                    obj.IncidentDate = DateUtils.convertToString(qa.Date__c, DateUtils.YYYY_MM_DD);
	    //                    obj.IncidentDetails = qa.Detail__c;
	    //                    obj.SuspensionPeriodInMonths = Integer.valueOf(qa.Number__c);
	    //                    r.MainInsured.LicenseEndorsements.add(obj);
	    //                }
	    //            }
	    //    	}
	    //    }
	    //    // Motoring offences
	    //    if (param.quote.Has_Motoring_Offences__c) {
	    //    	r.MainInsured.MotoringOffences = new List<EricDTOs.MotoringOffence>();
	    //    	List <Insurance_Quote_Annotation__c> dt = annotationMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
	    //    	if (dt != null) {
	    //    		EricDTOs.MotoringOffence obj = null;
	    //    		for (Insurance_Quote_Annotation__c qa: dt) {
	    //                if (qa.Driver__c == mainDriver.Id) {
	    //                    //Create 
	    //                    obj = new EricDTOs.MotoringOffence();
	    //                    obj.IncidentDate = DateUtils.convertToString(qa.Date__c, DateUtils.YYYY_MM_DD);
	    //                    obj.IncidentDetails = qa.Detail__c;
	    //                    obj.DemeritPoints = Integer.valueOf(qa.Number__c);
	    //                    r.MainInsured.MotoringOffences.add(obj);
	    //                }
	    //            }
	    //    	}
	    //    }
	    //}

        if (param.isFinalQuote() || param.isPresenting()) {
            //r.MainInsured.InsuredMedicalHistory = new EricDTOs.InsuredMedicalHistory();
            //r.MainInsured.InsuredMedicalHistory.HasBeenHospitalised = false;
            //r.MainInsured.InsuredMedicalHistory.HasLongTermMedicalCondition = false;
            //r.MainInsured.InsuredMedicalHistory.IsTakingRegularMedication = false;
            //r.MainInsured.InsuredMedicalHistory.IsUnderCurrentMedicalTreatment = false
            //if ('Y'.equals(mainDriver.Health_Info_Question_1__c)) {
            //    r.MainInsured.InsuredMedicalHistory.HasBeenHospitalised = true;
            //}
            //if ('Y'.equals(mainDriver.Health_Info_Question_2__c)) {
            //    r.MainInsured.InsuredMedicalHistory.HasLongTermMedicalCondition = true;
            //}
            //if ('Y'.equals(mainDriver.Health_Info_Question_3__c)) {
            //    r.MainInsured.InsuredMedicalHistory.IsTakingRegularMedication = true;
            //}
            //if ('Y'.equals(mainDriver.Health_Info_Question_4__c)) {
            //    r.MainInsured.InsuredMedicalHistory.IsUnderCurrentMedicalTreatment = true;
            //}
            if ('A'.equals(param.quote.LTI_Acceptance__c) || 'A'.equals(param.quote.LPI_Acceptance__c)) {
                r.MainInsured.InsuredMedicalHistory = new EricDTOs.InsuredMedicalHistory();
                r.MainInsured.InsuredMedicalHistory.AcknowledgmentOfExclusion = false;
                if ('Y'.equals(mainDriver.Health_Info_Question_1__c)) {
                    r.MainInsured.InsuredMedicalHistory.AcknowledgmentOfExclusion = true;
                }
            }
        }

        // Getting Quote Annotations
        Map<String, List <Insurance_Quote_Annotation__c>> annotationMap = 
                        InsuranceQuoteUtils.getInsuranceQuoteAnnotationsMap(param.quote.Id);
        // Motoring Offences
        Map<Id, List<EricDTOs.MotoringOffence>> offenceList = buildMotoringOffences(
            annotationMap.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE));
        // License Endorsements
        Map<Id, List<EricDTOs.LicenseEndorsement>> licenseList = buildLicenseEndorsements(
            annotationMap.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE));
        // Accidents
        Map<Id, List<EricDTOs.Accident>> accidentList = buildAccidents(
            annotationMap.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE));

        // Main Insured
        r.MainInsured.Accidents = accidentList.get(mainDriver.Id);
        r.MainInsured.LicenseEndorsements = licenseList.get(mainDriver.Id);
        r.MainInsured.MotoringOffences = offenceList.get(mainDriver.Id);

        // Check if it is a business applciation
        if ('true'.equals(r.MainInsured.IsBusinessUse) && param.quote.Motor_Vehicle__c != null) {
            r.SecondInsured = r.MainInsured;
            r.MainInsured = r.SecondInsured.extracBusinessDetails();
            r.SecondInsured.resetBusinessDetails();
        }

        // Aditional Drivers
        if ((param.quote.Motor_Vehicle__c != null && !param.isFinalQuote()) ||
            ('A'.equals(param.quote.MV_Acceptance__c) && param.isFinalQuote())) {
            List <Application_Additional_Driver__c> drivers = InsuranceQuoteUtils.getAllAdditionalDrivers(param.quote.Id);
            r.AdditionalDrivers = null;
            if (param.quote.Has_Additional_Driver__c && !drivers.isEmpty()) {
                r.AdditionalDrivers = new List<EricDTOs.Driver>();
                for (Application_Additional_Driver__c adr: drivers) {
                    EricDTOs.Driver driver = new EricDTOs.Driver();
                    // Basic details
                    driver.Title = adr.Title__c;
                    driver.FirstName = adr.First_Name__c;
                    driver.Surname = adr.Last_Name__c;
                    driver.FullName = driver.FirstName + ' ' + driver.Surname;
                    if (String.isNotBlank(adr.Gender__c)) {
                        driver.Gender = new EricDTOs.Gender(adr.Gender__c);
                    }
                    driver.DateOfBirth = adr.Date_of_Birth__c;
                    // Specific Details
                    driver.IsHoldingInternationalLicence = adr.Has_International_Licence__c;
                    driver.LicenseNumber = adr.Driver_Licence__c;
                    
                    //RelationshipToInsured
                    driver.YearFirstLicensed = String.valueOf(adr.Year_First_Licence__c.intValue());
                    driver.YearSinceLastAccident = adr.Time_Last_Fault_Accident__c;
                    driver.Accidents = accidentList.get(adr.Id);
                    driver.LicenseEndorsements = licenseList.get(adr.Id);
                    driver.MotoringOffences = offenceList.get(adr.Id);
                    r.AdditionalDrivers.add(driver);
                }
            }
        }
        
		return r;
	}

    private static Map<Id, List<EricDTOs.MotoringOffence>> buildMotoringOffences(List <Insurance_Quote_Annotation__c> annotations) {
        Map<Id, List<EricDTOs.MotoringOffence>> r = new Map<Id, List<EricDTOs.MotoringOffence>>();
        if (annotations != null) {
            for (Insurance_Quote_Annotation__c a: annotations) {
                List<EricDTOs.MotoringOffence> d = r.get(a.Driver__c);
                if (d == null) {
                    d = new List<EricDTOs.MotoringOffence>();
                    r.put(a.Driver__c, d);
                }
                EricDTOs.MotoringOffence x = new EricDTOs.MotoringOffence();
                x.IncidentDate = DateUtils.formatDate(a.Date__c, DateUtils.YYYY_MM_DD);
                x.IncidentDetails = a.Detail__c;
                x.DemeritPoints = Integer.valueOf(a.Number__c);
                d.add(x);
            }
        }
        return r;
    }

    private static Map<Id, List<EricDTOs.LicenseEndorsement>> buildLicenseEndorsements(List <Insurance_Quote_Annotation__c> annotations) {
        Map<Id, List<EricDTOs.LicenseEndorsement>> r = new Map<Id, List<EricDTOs.LicenseEndorsement>>();
        if (annotations != null) {
            for (Insurance_Quote_Annotation__c a: annotations) {
                List<EricDTOs.LicenseEndorsement> d = r.get(a.Driver__c);
                if (d == null) {
                    d = new List<EricDTOs.LicenseEndorsement>();
                    r.put(a.Driver__c, d);
                }
                EricDTOs.LicenseEndorsement x = new EricDTOs.LicenseEndorsement();
                x.IncidentDate = DateUtils.formatDate(a.Date__c, DateUtils.YYYY_MM_DD);
                x.IncidentDetails = a.Detail__c;
                x.SuspensionPeriodInMonths = Integer.valueOf(a.Number__c);
                d.add(x);
            }
        }
        return r;
    }

    private static Map<Id, List<EricDTOs.Accident>> buildAccidents(List <Insurance_Quote_Annotation__c> annotations) {
        Map<Id, List<EricDTOs.Accident>> r = new Map<Id, List<EricDTOs.Accident>>();
        if (annotations != null) {
            for (Insurance_Quote_Annotation__c a: annotations) {
                List<EricDTOs.Accident> d = r.get(a.Driver__c);
                if (d == null) {
                    d = new List<EricDTOs.Accident>();
                    r.put(a.Driver__c, d);
                }
                EricDTOs.Accident x = new EricDTOs.Accident();
                x.IncidentDate = DateUtils.formatDate(a.Date__c, DateUtils.YYYY_MM_DD);
                x.IncidentDetails = a.Detail__c;
                x.AtFault = false;
                if ('Y'.equals(a.Is_Driver_Fault__c)) {
                    x.AtFault = true;
                }
                x.InsurerName = a.Name_Insurer__c;
                x.LossAmount = a.Amount__c;
                x.TheftOrMaliciousDamage = false;
                if ('Y'.equals(a.Was_Vehicle_Affected__c)) {
                    x.TheftOrMaliciousDamage = true;
                }
                d.add(x);
            }
        }
        return r;
    }

	private static EricDTOs.VehicleDetails buildVehicleDetails(QuoteParam param) {
		EricDTOs.VehicleDetails r = new EricDTOs.VehicleDetails();
		if (String.isNotBlank(param.quote.Motor_Vehicle__c) || String.isNotBlank(param.quote.Warranty_Insurance__c)) {
			r.RedbookCode = param.quote.Redbook_Key__c;
		}
        r.VehicleType = param.quote.Vehicle_Type__c;
        r.VehicleMake = param.quote.Vehicle_Make__c;
        r.VehicleModel = param.quote.Vehicle_Model__c;
        if (String.isNotBlank(param.quote.Warranty_Insurance__c) || String.isNotBlank(param.quote.Motor_Vehicle__c)) {
            r.EngineNumber = 'BLANK';
            r.Vin = '11111111111111111';
            if (param.opp.Application_AssetDetail__r.Engine_No__c != null) {
                r.EngineNumber = param.opp.Application_AssetDetail__r.Engine_No__c;
            }

        }
		if (String.isNotBlank(param.quote.Warranty_Insurance__c)) {
			//Odometer
            if (param.quote.Odometer__c != null) {
                r.Odometer = Integer.valueOf(param.quote.Odometer__c);
            }
		}
		
		if (param.quote.Vehicle_Been_Registered__c) {
            //RegistrationNumber
            r.RegistrationMark = param.opp.Application_AssetDetail__r.Rego__c;
            //RegistrationState
            r.RegistrationState = param.opp.Application_AssetDetail__r.Rego_State__c;
            //VinNumber
            r.Vin = param.opp.Application_AssetDetail__r.VIN__c;
        } else {
            r.RegistrationMark = 'BLANK';
            r.RegistrationState = param.quote.Vehicle_Location_State__c;
        }
        if (param.isFinalQuote()) {
            if (param.opp.Application_AssetDetail__c != null && param.opp.Application_AssetDetail__r.Rego__c != null) {
                r.RegistrationMark = param.opp.Application_AssetDetail__r.Rego__c;
            } else {
                r.RegistrationMark = 'BLANK';
            }
            if (param.opp.Application_AssetDetail__c != null && param.opp.Application_AssetDetail__r.Rego_State__c != null) {
                r.RegistrationState = param.opp.Application_AssetDetail__r.Rego_State__c;
            } else {
                r.RegistrationState = param.quote.Vehicle_Location_State__c;
            }
            if ('A'.equals(param.quote.MV_Acceptance__c) || 'A'.equals(param.quote.WRR_Acceptance__c)) {
                if (String.isNotBlank(param.opp.Application_AssetDetail__r.VIN__c)) {
                    r.Vin = param.opp.Application_AssetDetail__r.VIN__c;
                }
            }
        }
        r.VehicleCondition =  param.quote.Vehicle_Condition__c;
        // r.VehicleUsage = '1';
        r.VehicleUsage = param.quote.Vehicle_Usage__c;
        
		return r;
	}

	private static EricDTOs.ItemDetails buildItemDetails(QuoteParam param, EricDTOs.InsuredDetails insuredDetail) {
		EricDTOs.ItemDetails r = new EricDTOs.ItemDetails();

		//MotorVehicleQuotation
        if ((!param.isFinalQuote() && String.isNotBlank(param.quote.Motor_Vehicle__c)) ||
        	(param.isFinalQuote() && 'A'.equals(param.quote.MV_Acceptance__c))) {
        	r.MotorItemDetails = new List<EricDTOs.MotorItemDetail>();
        	EricDTOs.MotorItemDetail d = new EricDTOs.MotorItemDetail();
        	d.CoverType = param.quote.Motor_Vehicle__c;
        	if ('3'.equals(param.quote.Motor_Cover_Term__c) || '6'.equals(param.quote.Motor_Cover_Term__c)) {
                d.CoverType = d.CoverType + param.quote.Motor_Cover_Term__c;
            }
            //VehicleLocationPostcode
            d.VehicleLocationPostcode = String.valueOf(param.quote.Vehicle_Location_Postcode__c);
            if (d.VehicleLocationPostcode.length() == 3) {
                d.VehicleLocationPostcode = '0' + d.VehicleLocationPostcode;
            }
            //VehicleLocationSuburb
            d.VehicleLocationSuburb = param.quote.Vehicle_Location_Suburb__c;
            //VehicleLocationState
            d.VehicleLocationState = param.quote.Vehicle_Location_State__c;
            
            //Other information
            if (param.quote.Other_Info_Question_1__c) {
                d.HasCriminalConviction = 'true';
                d.CriminalConvictionDetails = param.quote.Other_Info_Details_1__c;
            } else if (param.isFinalQuote() || param.isPresenting()) {
                d.HasCriminalConviction = 'false';
            }
            if (param.quote.Other_Info_Question_2__c) {
                d.HadInsuranceRefused = 'true';
                d.InsuranceRefusedDetails = param.quote.Other_Info_Details_2__c;
            } else if (param.isFinalQuote() || param.isPresenting()) {
                d.HadInsuranceRefused = 'false';
            }

            //RatingProtectionRequired
            if (param.quote.NCB_Protection__c) {
            	d.RatingProtectionRequired = 'true';
            }
            //WindscreenProtectionRequired
            if (param.quote.Windscreen_Protection__c) {
            	d.WindscreenProtectionRequired = 'true';
            }

            if (param.quote.MV_Standard_Excess__c != null && param.quote.MV_Standard_Excess__c > 0) {
                d.NominatedBasicExcess = String.valueOf(param.quote.MV_Standard_Excess__c);
            }
                
            if (param.quote.MV_Amount_Covered__c != null && param.quote.MV_Amount_Covered__c > 0) {
                d.NominatedAmountCovered = String.valueOf(param.quote.MV_Amount_Covered__c);
            }

            // Checking for Motoring offences
            //if (insuredDetail != null && 'false'.equals(d.HasCriminalConviction)) {
            //    if (insuredDetail.MainInsured != null && 
            //        insuredDetail.MainInsured.MotoringOffences != null && 
            //        !insuredDetail.MainInsured.MotoringOffences.isEmpty()) {
            //        d.HasCriminalConviction = 'true';
            //    }
            //    if (insuredDetail.SecondInsured != null && 
            //        insuredDetail.SecondInsured.MotoringOffences != null && 
            //        !insuredDetail.SecondInsured.MotoringOffences.isEmpty()) {
            //        d.HasCriminalConviction = 'true';
            //    }
            //    if (insuredDetail.AdditionalDrivers != null) {
            //        for (EricDTOs.Driver driver : insuredDetail.AdditionalDrivers) {
            //            if (driver.MotoringOffences != null && !driver.MotoringOffences.isEmpty()) {
            //                d.HasCriminalConviction = 'true';
            //            }
            //        }
            //    }
            //}

        	r.MotorItemDetails.add(d);
        }
		//GapQuotationItem
        if ((!param.isFinalQuote() && String.isNotBlank(param.quote.Gap__c)) ||
        	(param.isFinalQuote() && 'A'.equals(param.quote.GAP_Acceptance__c))) {
        	r.GapItemDetails = new List<EricDTOs.GapItemDetail>();
        	EricDTOs.GapItemDetail d = new EricDTOs.GapItemDetail();
        	d.CoverType = param.quote.GAP__c;
            if (String.isNotBlank(param.quote.Comprehensive_Insurer_Name__c)) {
                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
            } else {
                d.Insurer = 'TBA';
            }
            d.InsuranceExpiry = DateUtils.formatDate(
                        Date.today().addYears(1), DateUtils.YYYY_MM_DD);
            if ('A'.equals(param.quote.GAP_Acceptance__c)) {
	        	if (param.isPresenting() && param.quote.Comprehensive_Insurance_Expiry_Date__c == null) {
	                d.InsuranceExpiry = DateUtils.formatDate(
		                	Date.today().addYears(1), DateUtils.YYYY_MM_DD);
	            } else {
	                d.InsuranceExpiry = DateUtils.formatDate(
		                	param.quote.Comprehensive_Insurance_Expiry_Date__c, DateUtils.YYYY_MM_DD);
	            }
	            //Insurer
	            //if (param.isPresenting() && param.quote.Comprehensive_Insurer_Name__c == null) {
	            //    d.Insurer = 'TBA';
	            //} else {
	            //    d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
	            //}
	            d.IncludePremiumInFinance = 'false';
	        }
        	r.GapItemDetails.add(d);
        }
		//TotalAssistQuotationItem
        if ((!param.isFinalQuote() && String.isNotBlank(param.quote.Total_assist_RTI__c)) ||
        	(param.isFinalQuote() && 'A'.equals(param.quote.TAS_Acceptance__c))) {
        	r.TaiItemDetails = new List<EricDTOs.TaiItemDetail>();
        	EricDTOs.TaiItemDetail d = new EricDTOs.TaiItemDetail();
        	d.CoverType = param.quote.Total_assist_RTI__c;
            if (String.isNotBlank(param.quote.Comprehensive_Insurer_Name__c)) {
                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
            } else {
                d.Insurer = 'TBA';
            }
            d.InsuranceExpiry = DateUtils.formatDate(
                        Date.today().addYears(1), DateUtils.YYYY_MM_DD);
        	if ('A'.equals(param.quote.TAS_Acceptance__c)) {
	        	if (param.isPresenting() && param.quote.Comprehensive_Insurance_Expiry_Date__c == null) {
	                d.InsuranceExpiry = DateUtils.formatDate(
		                	Date.today().addYears(1), DateUtils.YYYY_MM_DD);
	            } else {
	                d.InsuranceExpiry = DateUtils.formatDate(
		                	param.quote.Comprehensive_Insurance_Expiry_Date__c, DateUtils.YYYY_MM_DD);
	            }
	            //Insurer
	            if (param.isPresenting() && param.quote.Comprehensive_Insurer_Name__c == null) {
	                d.Insurer = 'TBA';
	            } else {
	                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
	            }
	            d.IncludePremiumInFinance = 'false';
	        }
        	r.TaiItemDetails.add(d);
        }
        //LtiQuotationItem
        if ((!param.isFinalQuote() && String.isNotBlank(param.quote.LTI_BRI__c)) ||
        	(param.isFinalQuote() && 'A'.equals(param.quote.LTI_Acceptance__c))) {
        	r.LtiItemDetails = new List<EricDTOs.LtiItemDetail>();
        	EricDTOs.LtiItemDetail d = new EricDTOs.LtiItemDetail();
        	d.CoverType = param.quote.LTI_BRI__c;
            if (String.isNotBlank(param.quote.Comprehensive_Insurer_Name__c)) {
                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
            } else {
                d.Insurer = 'TBA';
            }
            d.InsuranceExpiry = DateUtils.formatDate(
                        Date.today().addYears(1), DateUtils.YYYY_MM_DD);
        	if ('A'.equals(param.quote.LTI_Acceptance__c)) {
        		//InsuranceExpiry
	            if (param.isPresenting() && param.quote.Comprehensive_Insurance_Expiry_Date__c == null) {
	                d.InsuranceExpiry = DateUtils.formatDate(
	                	Date.today().addYears(1), DateUtils.YYYY_MM_DD);
	            } else {
	                d.InsuranceExpiry = DateUtils.formatDate(
	                	param.quote.Comprehensive_Insurance_Expiry_Date__c, DateUtils.YYYY_MM_DD);
	            }
	            //Insurer
	            if (param.isPresenting() && param.quote.Comprehensive_Insurer_Name__c == null) {
	                d.Insurer = 'TBA';
	            } else {
	                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
	            }
	            d.IncludePremiumInFinance = 'false';
        	}
        	r.LtiItemDetails.add(d);
        }
        //Jesus Mora 2020-03-26 start
        //LpiQuotationItem
        if (String.isNotBlank(param.quote.LPI__c) &&
            (!param.isFinalQuote() ||
            (param.isFinalQuote() && 'A'.equals(param.quote.LPI_Acceptance__c)))) {
                r.CciItemDetails = new List<EricDTOs.CciItemDetail>();
                EricDTOs.CciItemDetail d = new EricDTOs.CciItemDetail();
                d.CoverType = param.quote.LPI__c;
                if (String.isNotBlank(param.quote.Comprehensive_Insurer_Name__c)) {
                    d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
                } else {
                    d.Insurer = 'TBA';
                }
                d.InsuranceExpiry = DateUtils.formatDate(
                        Date.today().addYears(1), DateUtils.YYYY_MM_DD);
                if ('A'.equals(param.quote.LPI_Acceptance__c)) {
        		//InsuranceExpiry
	            if (param.isPresenting() && param.quote.Comprehensive_Insurance_Expiry_Date__c == null) {
	                d.InsuranceExpiry = DateUtils.formatDate(
	                	Date.today().addYears(1), DateUtils.YYYY_MM_DD);
	            } else {
	                d.InsuranceExpiry = DateUtils.formatDate(
	                	param.quote.Comprehensive_Insurance_Expiry_Date__c, DateUtils.YYYY_MM_DD);
	            }
	            //Insurer
	            if (param.isPresenting() && param.quote.Comprehensive_Insurer_Name__c == null) {
	                d.Insurer = 'TBA';
	            } else {
	                d.Insurer = param.quote.Comprehensive_Insurer_Name__c;
	            }
	        }
                d.BalloonCoverRequired = 'false';
                d.SecondInsuredRequired = 'false';// TODO - look for more information later
                d.IncludePremiumInFinance = 'true';
                if(param.quoting.Residual_Value__c > 0){
                    d.BalloonCoverRequired = 'true';
                    d.BalloonAmount = String.valueOf(param.quoting.Residual_Value__c);
                }
                d.RegularMonthlyPayment = String.valueOf(param.quoting.Repayment_Monthly__c);
                r.CciItemDetails.add(d);
            }
        //Jesus Mora 2020-03-26 end
		//WarrantyQuotationItem
        if ((!param.isFinalQuote() && String.isNotBlank(param.quote.Warranty_Insurance__c)) ||
        	(param.isFinalQuote() && 'A'.equals(param.quote.WRR_Acceptance__c))) {
        	r.WarItemDetails = new List<EricDTOs.WarItemDetail>();
        	EricDTOs.WarItemDetail d = new EricDTOs.WarItemDetail();
            d.CoverType = param.quote.Warranty_Insurance__c;
            d.DateFirstRegistered = param.quote.Vehicle_Date_First_Registered__c;
            if ('A'.equals(param.quote.WRR_Acceptance__c)) {
                if ('Y'.equals(param.quote.Vehicle_Under_Warranty__c)) {
                    d.IsVehicleUnderStatutoryWarranty = 'true';
                    d.StatutoryWarrantyEndDate = param.quote.Vehicle_Warranty_End_Date__c;
                } else {
                    d.IsVehicleUnderStatutoryWarranty = 'false';
                    //d.StatutoryWarrantyEndDate = DateUtils.formatDate(Datetime.now().addDays(-1), DateUtils.YYYY_MM_DD);
                }
                d.IncludePremiumInFinance = false;
            }
        	r.WarItemDetails.add(d);
        }
		return r;
	}

    private static void saveWebServiceResponse(QuoteParam param, EricDTOs.ResponseDTO response) {
        
        Boolean updateQuote = false;
        // Get Quoteid 
        if (response.getQuoteId() != null && !response.getQuoteId().startsWith('00000000')) {
            if (param.quote.Quote_Id__c == null || param.quote.Quote_Id__c.equals(response.getQuoteId())) {
                param.quote.Quote_Id__c = response.getQuoteId();
                updateQuote = true;
            }
        }
        if (!response.hasErrors()) {
            updateQuote = true;
            List <Insurance_Payment_Method__c> paymentList = new List <Insurance_Payment_Method__c>();
            Custom_Opportunity__c opp = param.opp;
            Application_InsuranceQuote__c quote = param.quote;
            EricDTOs.QuotedGroup qg = null;
            if(response.quoteResponse.QuotedGroups != null && !response.quoteResponse.QuotedGroups.isEmpty()) {
                qg = response.quoteResponse.QuotedGroups.get(0);
            }

            quote.Quotation_Date__c = Datetime.now();
            quote.Quotation_Creator__c = UserInfo.getUserId();

            if (response.quoteResponse.VehicleDetails != null) {
                quote.Response_Vehicle_Description__c = response.quoteResponse.VehicleDetails.toString();
            }

            if (qg != null) {
                // Update SF quote
                resetProductValues(param);
                quote.Quotation_Number__c = qg.QuotationReferenceNumber;
                quote.Name = opp.Name + ' [' + quote.Quotation_Number__c + ']';
                if (param.isFinalQuote()) {
                    quote.Status__c = 'FA';
                    param.preserveAcceptance = true;
                } else if (param.isInitinalQuote()) {
                    quote.Status__c = 'Q';
                }
                if (!param.preserveAcceptance) {
                    //Reset Acceptance
                    quote.MV_Acceptance__c = 'U';
                    quote.GAP_Acceptance__c = 'U';
                    quote.LTI_Acceptance__c = 'U';
                    quote.TAS_Acceptance__c = 'U';
                    quote.WRR_Acceptance__c = 'U';
                    //Jesus Mora 2020-03-26 start
                    quote.LPI_Acceptance__c = 'U';
                    //Jesus Mora 2020-03-26 end
                }
                if (qg.Items != null) {
                    for (EricDTOs.QuoteItem i : qg.Items) {
                        
                        if (i.CoverType.equals(quote.Motor_Vehicle__c)) {
                            //Motor Vehicle
                            quote.MV_Establishment_Fee__c = i.EstablishmentFee;
                            quote.MV_GST__c = i.Gst;
                            quote.MV_Premium__c = i.Premium;
                            quote.MV_Stamp_Duty__c = i.StampDuty;
                            //Standard Excess
                            quote.MV_Standard_Excess__c = i.BasicExcess;
                            //ImposedExcess
                            quote.MV_Imposed_Excess__c = i.ImposedExcess;
                            //SystemImposedExcess
                            quote.MV_System_Imposed_Excess__c = i.SystemImposedExcess;
                            if (i.BasicExcessOptions != null && !i.BasicExcessOptions.isEmpty()) {
                                quote.MV_Basic_Excess_Options__c = JSON.serialize(i.BasicExcessOptions);
                            }
                            //Amount Coverd
                            quote.MV_Amount_Covered__c = i.AmountCovered;
                            quote.MV_Amount_Covered_Min__c = i.AmountCoveredMinimum;
                            quote.MV_Amount_Covered_Max__c = i.AmountCoveredMaximum;
                            quote.MV_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Motor_Vehicle__c);
                            //Payments 
                            List <Insurance_Payment_Method__c> t = makePaymentMethods(quote.Id, 'MV', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        } else if (i.CoverType.equals(quote.Gap__c)) {
                            //GAP
                            quote.GAP_Establishment_Fee__c = i.EstablishmentFee;
                            quote.GAP_GST__c = i.Gst;
                            quote.GAP_Premium__c = i.Premium;
                            quote.GAP_Stamp_Duty__c = i.StampDuty;
                            quote.GAP_Cost_ExGst__c = i.CostExGst;
                            quote.GAP_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Gap__c);
                            //Payments 
                            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'GAP', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        } else if (i.CoverType.equals(quote.LTI_BRI__c)) {
                            //LTI
                            quote.LTI_Establishment_Fee__c = i.EstablishmentFee;
                            quote.LTI_GST__c = i.Gst;
                            quote.LTI_Premium__c = i.Premium;
                            quote.LTI_Stamp_Duty__c = i.StampDuty;
                            quote.LTI_Cost_ExGst__c = i.CostExGst;
                            quote.LTI_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.LTI_BRI__c);
                            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'LTI', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        //Jesus Mora 2020-03-26 start
                        } else if (i.CoverType.equals(quote.LPI__c)) {
                            //LPI
                            quote.LPI_Establishment_Fee__c = i.EstablishmentFee;
                            quote.LPI_GST__c = i.Gst;
                            quote.LPI_Premium__c = i.Premium;
                            quote.LPI_Stamp_Duty__c = i.StampDuty;
                            quote.LPI_Cost_ExGst__c = i.CostExGst;
                            quote.LPI_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.LPI__c);
                            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'LPI', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        //Jesus Mora 2020-03-26 end
                        } else if (i.CoverType.equals(quote.Total_assist_RTI__c)) {
                            //TAI/RTI
                            quote.TAS_Establishment_Fee__c = i.EstablishmentFee;
                            quote.TAS_GST__c = i.Gst;
                            quote.TAS_Premium__c = i.Premium;
                            quote.TAS_Stamp_Duty__c = i.StampDuty;
                            quote.TAS_Cost_ExGst__c = i.CostExGst;
                            quote.TAS_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Total_assist_RTI__c);
                            //Payments 
                            List < Insurance_Payment_Method__c > t = makePaymentMethods(quote.Id, 'RTI', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        } else if (i.CoverType.equals(quote.Warranty_Insurance__c)) {
                            //Warranty
                            quote.WRR_Establishment_Fee__c = i.EstablishmentFee;
                            quote.WRR_GST__c = i.Gst;
                            quote.WRR_Premium__c = i.Premium;
                            quote.WRR_Stamp_Duty__c = i.StampDuty;
                            quote.WRR_Cost_ExGst__c = i.CostExGst;
                            quote.WRR_Commission_Percentage__c = InsuranceQuoteUtils.getCommissionPercentage(quote.Warranty_Insurance__c);
                            //Payments 
                            List <Insurance_Payment_Method__c> t = makePaymentMethods(quote.Id, 'Warranty', i.PaymentOptions);
                            if (!t.isEmpty()) {
                                paymentList.addAll(t);
                            }
                        }
                    }
                }
            }
            //Manage payments
            delete[SELECT Id FROM Insurance_Payment_Method__c WHERE Insurance_Quote__c = :quote.Id];
            if (!paymentList.isEmpty()) {
                insert paymentList;
            }

        } else {
            Boolean declineEricProducts = false;
            if (param.isFinalQuote() || param.isPresenting()) {
                List<String> errsLst = new List<String>();
                List<EricDTOs.Message> errmsgs = response.getAllMessages().get('Error');
                if (errmsgs != null) {
                    for (EricDTOs.Message m: errmsgs) {
                        errsLst.add(m.toString());
                        if (CODE_ACKNEXCLUSION.equals(m.code)) {
                            declineEricProducts = true;
                        }
                    }
                }
                InsuranceQuoteUtils.saveFailureReasons(param.quote.Id, errsLst);
                param.quote.Status__c = 'Fail';
                if (declineEricProducts) {
                    InsuranceQuoteUtils.declineHealthProducts(param.quoting, param.quote);
                }
            }
        }
        
        if (updateQuote) {
            update param.quote;
        }
    }

    private static void saveWebServicePaymentResponse(QuoteParam param, EricDTOs.ResponseDTO response) {
        if (param == null || response == null || response.lodgementResponse == null) return;
        if (!response.hasErrors()) {
            EricDTOs.LodgementResponse res = null;
            if (response.preLodgementResponse != null) {
                param.quote.Is_PreLodged__c = true;
                res = response.preLodgementResponse;
            }
            if (response.lodgementResponse != null) {
                param.quote.Is_Lodged__c = true;
                res = response.lodgementResponse;
            }
            if (res != null && res.Details != null) {
                InsuranceQuoteUtils.deleteQuotePolicies(param.quote.Id);
                List<Insurance_Quote_Policy__c> d = new List<Insurance_Quote_Policy__c>();
                for (EricDTOs.LodgementDetailResponse a: res.Details) {
                    Insurance_Quote_Policy__c p = new Insurance_Quote_Policy__c();
                    p.Application_Insurance_Quote__c = param.quote.Id;
                    p.Policy_Number__c = a.PolicyNumber;
                    p.Cover_Type__c = a.CoverType;
                    p.Product_Code__c = a.ProductCode;
                    d.add(p);
                }
                if (!d.isEmpty()) {
                    insert d;
                }
            }
            param.quote.Status__c = 'P';
            update param.quote;
        }
    }

    private static void resetProductValues(QuoteParam param) {
        Application_InsuranceQuote__c quote = param.quote;
        //Motor Vehicle
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
        
        //GAP
        quote.GAP_Establishment_Fee__c = null;
        quote.GAP_GST__c = null;
        quote.GAP_Premium__c = null;
        quote.GAP_Stamp_Duty__c = null;
        quote.GAP_Cost_ExGst__c = null;
        quote.GAP_Commission_Percentage__c = null;

        //LTI
        quote.LTI_Establishment_Fee__c = null;
        quote.LTI_GST__c = null;
        quote.LTI_Premium__c = null;
        quote.LTI_Stamp_Duty__c = null;
        quote.LTI_Cost_ExGst__c = null;
        quote.LTI_Commission_Percentage__c = null;
        //Jesus Mora 2020-03-26 start
        //LPI
        quote.LPI_Establishment_Fee__c = null;
        quote.LPI_GST__c = null;
        quote.LPI_Premium__c = null;
        quote.LPI_Stamp_Duty__c = null;
        quote.LPI_Cost_ExGst__c = null;
        quote.LPI_Commission_Percentage__c = null;
        //Jesus Mora 2020-03-26 end
        //Total Assist /TAI/RTI
        quote.TAS_Establishment_Fee__c = null;
        quote.TAS_GST__c = null;
        quote.TAS_Premium__c = null;
        quote.TAS_Stamp_Duty__c = null;
        quote.TAS_Cost_ExGst__c = null;
        quote.TAS_Commission_Percentage__c = null;

        //Warranty
        quote.WRR_Establishment_Fee__c = null;
        quote.WRR_GST__c = null;
        quote.WRR_Premium__c = null;
        quote.WRR_Stamp_Duty__c = null;
        quote.WRR_Cost_ExGst__c = null;
        quote.WRR_Commission_Percentage__c = null;
    }

    public static List <Insurance_Payment_Method__c> makePaymentMethods(Id quoteId, String product, List<EricDTOs.QuotePaymentOption> paymentOptions) {
        List <Insurance_Payment_Method__c> r = new List <Insurance_Payment_Method__c> ();
        if (paymentOptions != null) {
            for (EricDTOs.QuotePaymentOption p: paymentOptions) {
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

    private static EricDTOs.PreLodgement buildPreLodgement(QuoteParam param){
        EricDTOs.PreLodgement r = new EricDTOs.PreLodgement();
        r.QuoteIdentifier = param.quote.Quote_Id__c;
        r.PreLodgeAll = false;
        Map <Id, InsuranceQuoteUtils.PaymentMethodDTO> paymentMap = new Map <Id, InsuranceQuoteUtils.PaymentMethodDTO>();
        if (param.paymentMethods != null) {
            for (InsuranceQuoteUtils.PaymentMethodDTO a: param.paymentMethods) {
                if (!a.isRemoved) {
                    paymentMap.put(a.data.Id, a);
                }
            }
        }
        r.PreLodgementItems = new List<EricDTOs.PreLodgementItem>();
        //MV
        if ('A'.equalS(param.quote.MV_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.Motor_Vehicle__c, 
                                  param.quote.MV_Payment_Method__c, 
                                  paymentMap.get(param.quote.MV_Payment_Detail__c))
                );
        }
        //Gap
        if ('A'.equalS(param.quote.GAP_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.GAP__c, 
                                  param.quote.GAP_Payment_Method__c, 
                                  paymentMap.get(param.quote.GAP_Payment_Detail__c))
                );
        }
        //LTI
        if ('A'.equalS(param.quote.LTI_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.LTI_BRI__c, 
                                  param.quote.LTI_Payment_Method__c, 
                                  paymentMap.get(param.quote.LTI_Payment_Detail__c))
                );
        }
        //Jesus Mora 2020-03-26 start
        //LPI
        if ('A'.equalS(param.quote.LPI_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.LPI__c, 
                                  param.quote.LPI_Payment_Method__c, 
                                  paymentMap.get(param.quote.LPI_Payment_Detail__c))
                );
        }
        //Jesus Mora 2020-03-26 end
        //RTI (TAS)
        if ('A'.equalS(param.quote.TAS_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.Total_assist_RTI__c, 
                                  param.quote.TAS_Payment_Method__c, 
                                  paymentMap.get(param.quote.TAS_Payment_Detail__c))
                );
        }
        //Warranty
        if ('A'.equalS(param.quote.WRR_Acceptance__c)) {
            r.PreLodgementItems.add(
                makePaymentDetail(param.quote.Warranty_Insurance__c, 
                                  param.quote.WRR_Payment_Method__c, 
                                  paymentMap.get(param.quote.WRR_Payment_Detail__c))
                );   
        }
        return r;
    }

    private static EricDTOs.PreLodgementItem makePaymentDetail(String coverType, String methodCode, InsuranceQuoteUtils.PaymentMethodDTO payment) {
        EricDTOs.PreLodgementItem r = new EricDTOs.PreLodgementItem();
        r.CoverType = coverType;
        r.PaymentDetails = new EricDTOs.PaymentDetail();
        r.PaymentDetails.PaymentMethod = methodCode;
        if ('CREDITCARD'.equals(methodCode) || 'PREMFUND12CC'.equals(methodCode)) {
            r.PaymentDetails.CardDetails = new EricDTOs.CardDetail();
            r.PaymentDetails.CardDetails.CardholderName = payment.data.Holder_Name__c;
            r.PaymentDetails.CardDetails.CardNumber = payment.data.Credit_Card_Number__c;
            r.PaymentDetails.CardDetails.VerificationCode = payment.data.Verification_Code__c;
            r.PaymentDetails.CardDetails.Expiry = new EricDTOs.CardExpiry();
            r.PaymentDetails.CardDetails.Expiry.Month = Integer.valueOf(payment.data.Expiry_Month__c);
            r.PaymentDetails.CardDetails.Expiry.Year = Integer.valueOf(payment.data.Expiry_Year__c);
        } else if ('PREMFUND12BA'.equals(methodCode)) {
            r.PaymentDetails.BankAccountDetails = new EricDTOs.BankAccountDetail();
            r.PaymentDetails.BankAccountDetails.AccountHolderName = payment.data.Holder_Name__c;
            r.PaymentDetails.BankAccountDetails.AccountNumber = payment.data.Account_Number__c;
            r.PaymentDetails.BankAccountDetails.Bsb = payment.data.BSB_Number__c;
        }
        return r;
    }

    private static EricDTOs.Lodgement buildLodgement(QuoteParam param){
        EricDTOs.Lodgement r = new EricDTOs.Lodgement();
        r.QuoteIdentifier = param.quote.Quote_Id__c;
        r.LodgeAll = false;
        r.LodgeProposalList = new List<String>();
        //MV
        if ('A'.equalS(param.quote.MV_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.Motor_Vehicle__c);
        }
        //Gap
        if ('A'.equalS(param.quote.GAP_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.GAP__c);
        }
        //LTI
        if ('A'.equalS(param.quote.LTI_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.LTI_BRI__c);
        }
        //Jesus Mora 2020-03-26 start
        //LPI
        if ('A'.equalS(param.quote.LPI_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.LPI__c);
        }
        //Jesus Mora 2020-03-26 end
        //RTI (TAS)
        if ('A'.equalS(param.quote.TAS_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.Total_assist_RTI__c);
        }
        //Warranty
        if ('A'.equalS(param.quote.WRR_Acceptance__c)) {
            r.LodgeProposalList.add(param.quote.Warranty_Insurance__c);   
        }
        return r;
    }

    public static HTTPResponse getPolicyDocument(String policyNumber){
        return EricServices.getPolicyDocument(policyNumber);
    }

}