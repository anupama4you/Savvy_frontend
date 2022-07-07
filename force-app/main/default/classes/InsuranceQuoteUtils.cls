public without sharing class InsuranceQuoteUtils {

	private static final Integer TIMEOUT_REQUEST = 120000;

	public static final String PUB_SITE_NAME = 'Savvy_Client_Services';

	public static final String MAIN_DRIVER_TYPE = 'Main Driver';
	public static final String ADDITIONAL_DRIVER_TYPE = 'Additional Driver';

	public static final String ACCIDENT_HISTORY_TYPE = 'Accident History';
	public static final String LICENCE_SANCTIONED_TYPE = 'Licence Sanctioned';
	public static final String MOTORING_OFFENCE_TYPE = 'Motoring Offence';

	public static final String CREDIT_CARD_METHOD = 'CC';
	public static final String BANK_ACCOUNT_METHOD = 'BA';
	
	public static final String INS_PROD_MV = 'MV';
	public static final String INS_PROD_GAP = 'GAP';
	public static final String INS_PROD_TAI = 'TAI';
	public static final String INS_PROD_LTI = 'LTI';
	public static final String INS_PROD_WARR = 'WRR';
	public static final String INS_PROD_NWC = 'NWC';
	public static final String INS_PROD_CCI = 'CCI';
	public static final String INS_PROD_UNPROTECTED = 'UNPRO';
	public static final String INS_PROD_LPI_2 = 'LPI(2)';

  public static final String INS_PROD_MV_ERIC = 'Eric MV';
  public static final String INS_PROD_GAP_ERIC = 'Eric EPI';
  public static final String INS_PROD_GAP_LIBE = 'Liberty VEI';
  public static final String INS_PROD_LPI_ERIC = 'Eric FPI';
  public static final String INS_PROD_LPI_LIBE = 'Liberty LFI';
  public static final String INS_PROD_WARR_ERIC = 'Eric Warranty';
  public static final String INS_PROD_WARR_INTE = 'Integrity';

  public static final String INS_ONLYPAYBYTHEMONTH = 'OnlyPayByTheMonth';

	public static final Decimal RTI_NET_DEPOSIT_PERC = 40.0; 

	public static final String PARAM_APIKEY = 'API_KEY';	
	public static final String PARAM_ENDPOINT = 'END_POINT';
	public static final String POLICY_DOWNLOAD_URL = 'POLICY_DOWNLOAD_URL';

	public static final String POLICY_CODE_MV = 'MOT';
	public static final String POLICY_CODE_GAP = 'GAP';
	public static final String POLICY_CODE_RTI = 'TAI';
	public static final String POLICY_CODE_LTI = 'LTI';
	public static final String POLICY_CODE_WAR = 'WAR';
    //Jesus Mora 2020-06-04 start
    public static final String POLICY_CODE_LPI = 'CRE';
    //Jesus Mora 2020-06-04 end
	
	public static final String CUSCHOICE_SENT = 'SENT';
	public static final String CUSCHOICE_DECIDING = 'DECI';
	public static final String CUSCHOICE_DECLARING = 'DECL';
	public static final String CUSCHOICE_SELCOMPRE = 'SECO';
	public static final String CUSCHOICE_FILLINFO = 'FIIN';
	public static final String CUSCHOICE_FINISHED = 'FINI';

	public static final String TYPE_REQ = 'Request';
	public static final String TYPE_RES = 'Response';

	public static final String PROCESS_INITQUOTE = 'Initial Quotation';
	public static final String PROCESS_FINALQUOTE = 'Final Quotation';
	public static final String PROCESS_MVPRESENTATION = 'MVPresentation';
	public static final String PROCESS_PRESENTATION = 'Presentation';
	public static final String PROCESS_BUYPOLICY = 'Buy Policy';
	public static final String PROCESS_LODGE = 'Lodge';

	// Lelo 				2019-12-17
	// Eric
	// old docs
	public static final String PDS_Eric_GAP = 'QCPPDS_Eric_GAP';
	public static final String PDS_Eric_RTI = 'QCPPDS_Eric_RTI';                  // TODO - remove it?
	public static final String PDS_Eric_LTI = 'QCPPDS_Eric_LTI';                  // TODO - remove it?
  public static final String PDS_Eric_LPI = 'QCPPDS_Eric_LPI';
	public static final String PDS_Eric_LPI_GUIDE = 'QCPPDS_Eric_LPI_Guide';
  public static final String PDS_Eric_BIKES = 'QCPPDS_Eric_PDS_Motorcycles';    // TODO - remove it?
  // new docs
  public static final String PDS_Eric_MVI = 'QCPPDS_Eric_MVI';
  public static final String PDS_Eric_EPI = 'QCPPDS_Eric_EPI';                        // GAP
  public static final String PDS_Eric_FPI = 'QCPPDS_Eric_FPI';                        // LPI
	public static final String PDS_Eric_WAR5 = 'QCPPDS_Eric_WAR5';
	public static final String PDS_Eric_WAR4 = 'QCPPDS_Eric_WAR4';
  public static final String PDS_Eric_WAR3 = 'QCPPDS_Eric_WAR3';	

	// Suncorp
	public static final String PDS_Suncorp_Car = 'QCPPDS_Suncorp_Car';
	public static final String PDS_Suncorp_DD = 'QCPPDS_Suncorp_DD';
	// Integrity
  public static final String PDS_Integrity_Car = 'QCPPDS_Integrity_Car';            // TODO - Verify this document
  public static final String PDS_Integrity_Truck = 'QCPPDS_Integrity_Truck';        // TODO - Verify Trucks

	public static final String PDS_Integrity_Absolute = 'QCPPDS_Integrity_Absolute';
  public static final String PDS_Integrity_Endurance = 'QCPPDS_Integrity_Endurance';
  public static final String PDS_Integrity_Caravan = 'QCPPDS_Integrity_Caravan';
	public static final String PDS_Integrity_Marine = 'QCPPDS_Integrity_Marine';
	public static final String PDS_Integrity_Motorbike = 'QCPPDS_Integrity_Motorbike';
  public static final String PDS_Integrity_Jetsky = 'QCPPDS_Integrity_Jetsky';
  public static final String PDS_Integrity_Motorhome = 'QCPPDS_Integrity_Motorhome';
	// Liberty
	public static final String PDS_Liberty_VEI = 'QCPPDS_Liberty_VEI';
  public static final String PDS_Liberty_VEI_QF = 'QCPPDS_Liberty_VEI_QF';
	public static final String PDS_Liberty_LPI = 'QCPPDS_Liberty_LPI';
  public static final String PDS_Liberty_LPI_QF = 'QCPPDS_Liberty_LPI_QF';
	// -

	private static Map<String, Eric_Setting__c> ericSettings;
	private static Map<String, String> ericProdLabels;

	public static final String APP_INSQUOTE_SOQL = '' +
        'SELECT Id, Name, Application__c, Code__c, ' +
        '       Assist_Cover_Term__c, MV_Amount_Covered__c, MV_Amount_Covered_Max__c, MV_Amount_Covered_Min__c, ' + 
        '       Amount_Financed__c, MV_Establishment_Fee__c, Gap__c, MV_GST__c, Is_Vehicle_Commercial_Usage__c, Has_Additional_Driver__c, ' +
        '       LTI_BRI__c, Motor_Cover_Term__c, Motor_Vehicle__c, Odometer__c, MV_Acceptance__c, MV_Premium__c, Quotation_Number__c, Redbook_Key__c, MV_Stamp_Duty__c, ' + 
        '       MV_Standard_Excess__c, Total_assist_RTI__c, MV_Total_Payable__c, Truck_GAP__c, Total_Payable_Accepted__c, ' +
        '       Vehicle_Been_Registered__c, Vehicle_Date_First_Registered__c, Vehicle_Location_Postcode__c, Vehicle_Location_State__c, ' +
        '       Vehicle_Location_Suburb__c, Vehicle_Make__c, Vehicle_Model__c, Vehicle_Type__c, Vehicle_Usage__c, Vehicle_Usage_For__c, ' +
        '       Warranty_Insurance_Contract__c, Warranty_Insurance__c, Response_Vehicle_Description__c, Vehicle_Condition__c, ' +
        '       GAP_Acceptance__c, GAP_Cost_ExGst__c, GAP_Establishment_Fee__c, GAP_GST__c, GAP_Premium__c, GAP_Stamp_Duty__c, GAP_Total_Payable__c, ' +
        '       LTI_Acceptance__c, LTI_Cost_ExGst__c, LTI_Establishment_Fee__c, LTI_GST__c, LTI_Premium__c, LTI_Stamp_Duty__c, LTI_Total_Payable__c, ' +
        '       TAS_Acceptance__c, TAS_Cost_ExGst__c, TAS_Establishment_Fee__c, TAS_GST__c, TAS_Premium__c, TAS_Stamp_Duty__c, TAS_Total_Payable__c, ' +
        '       WRR_Acceptance__c, WRR_Cost_ExGst__c, WRR_Establishment_Fee__c, WRR_GST__c, WRR_Premium__c, WRR_Stamp_Duty__c, WRR_Total_Payable__c, ' + 
        '       Quotation_Date__c, Quotation_Creator__c, Financier_Name__c, Vehicle_Purchase_Price__c, MV_Commission__c, MV_Commission_Percentage__c, ' +
        '       GAP_Commission__c, GAP_Commission_Percentage__c, LTI_Commission__c, LTI_Commission_Percentage__c, TAS_Commission__c, ' +
        '       TAS_Commission_Percentage__c, WRR_Commission__c, WRR_Commission_Percentage__c, Status__c, Finance_Term__c, ' +
        '       Cover_Start_Date__c, Vehicle_Under_Warranty__c, Vehicle_Warranty_End_Date__c, Vehicle_Purchase_Date__c, ' +
        '       Has_Motoring_Offences__c, Has_Accident_History__c, Has_Licence_Santioned__c, Has_Existing_Damage__c, Existing_Damage_Details__c, ' +
        '       Other_Info_Question_1__c, Other_Info_Question_2__c, Other_Info_Details_1__c, Other_Info_Details_2__c, ' +
        '       MV_Payment_Method__c, GAP_Payment_Method__c, TAS_Payment_Method__c, LTI_Payment_Method__c, WRR_Payment_Method__c, ' +
        '       MV_Payment_Detail__c, GAP_Payment_Detail__c, TAS_Payment_Detail__c, LTI_Payment_Detail__c, WRR_Payment_Detail__c, ' +
        '       Comprehensive_Insurer_Name__c, Comprehensive_Insurance_Expiry_Date__c, Financier_Id__c, Payment_Failure_Reason__c, ' +
        '       Customer_Choice__c, Customer_Choice_Date__c, Customer_Choice_Details__c, Customer_Choice_Status__c, ' +
        '       MV_Basic_Excess_Options__c, NCB_Protection__c, Windscreen_Protection__c, MV_Imposed_Excess__c, MV_System_Imposed_Excess__c, ' +
        '       MV_Declining_Notes__c, Is_Vehicle_MV_Commercial__c, Is_Vehicle_Modified__c, Quote_Id__c, Is_PreLodged__c, Is_Lodged__c, ' +
        //Jesus Mora 2020-06-04 start
        '       LPI__c, LPI_Acceptance__c, LPI_Commission__c, LPI_Commission_Percentage__c, LPI_Cost_ExGst__c, LPI_Establishment_Fee__c, ' +
        '       LPI_GST__c, LPI_Payment_Detail__c, LPI_Payment_Method__c, LPI_Premium__c, LPI_Stamp_Duty__c, LPI_Total_Payable__c ' +
        //Jesus Mora 2020-06-04 end
        'FROM Application_InsuranceQuote__c	';

	// Lelo 			2019-02-19
	public static final String REST_DEALER_ID = 'REST_DEALER_ID';
	public static final String REST_DEALER_NAME = 'REST_DEALER_NAME';
	public static final String REST_END_POINT = 'REST_END_POINT';
	public static final String REST_PWD = 'REST_PWD';
	public static final String REST_USER_ID = 'REST_USER_ID';
	public static final String REST_USERNAME = 'REST_USERNAME';
	// 
	public static List<Application_InsuranceQuote__c> getLatestApplicationInsuranceQuotes(Id appId, Integer countLimit) {
		return Database.query(APP_INSQUOTE_SOQL + 'WHERE Application__c = :appId ORDER BY LastModifiedDate DESC LIMIT :countLimit');
	}

	public static Application_InsuranceQuote__c getMostRecentApplicationInsuranceQuote(Id appId) {
		Application_InsuranceQuote__c r = null;
		if (appId != null)  {
			List<Application_InsuranceQuote__c> d = getLatestApplicationInsuranceQuotes(appId, 1);
			if (!d.isEmpty()) {
				r = d.get(0);
			}
		}
		return r;
	}

	public static Application_InsuranceQuote__c getApplicationInsuranceQuoteById(Id quoteId) {
		Application_InsuranceQuote__c r = null;
		List<Application_InsuranceQuote__c> d = Database.query(APP_INSQUOTE_SOQL + 'WHERE Id = :quoteId');
		if (!d.isEmpty()) {
			r = d.get(0);
		}
		return r;
	}

	public static Application_InsuranceQuote__c getApplicationInsuranceQuoteReceived(Id appId) {
		Application_InsuranceQuote__c r = null;
		List<Application_InsuranceQuote__c> d = getLatestApplicationInsuranceQuotes(appId, 10);
		if (!d.isEmpty()) {
			for (Application_InsuranceQuote__c a : d) {
				System.debug('Quote >> ' + a.Name + '|' + a.Status__c);
				if ('Q'.equals(a.Status__c)) {
					r = a;
					break;
				}
			}
		}
		return r;
	}

	public static List<Application_InsuranceQuote__c> getApplicationInsuranceQuotesByAppId(Id appId) {
		return getApplicationInsuranceQuotesByAppId(appId, null);
	}

	public static List<Application_InsuranceQuote__c> getApplicationInsuranceQuotesByAppId(Id appId, String lenderName) {
		List<String> paramStatus = new List<String>(new String[] {'Q','FA','P','Fail'});
		String wh = '';
		if (String.isNotBlank(lenderName)) {
			wh = 'WHERE Application__c = :appId AND Financier_Name__c = :lenderName AND Status__c IN :paramStatus ORDER BY Quotation_Date__c';
		} else {
			wh = 'WHERE Application__c = :appId AND Status__c IN :paramStatus ORDER BY Quotation_Date__c';
		}
		return Database.query(APP_INSQUOTE_SOQL + wh);
	}

	public static Application_InsuranceQuote__c getApplicationInsuranceQuotePrepared(Id appId) {
		Application_InsuranceQuote__c r = null;
		List<Application_InsuranceQuote__c> d = getLatestApplicationInsuranceQuotes(appId, 10);
		if (!d.isEmpty()) {
			for (Application_InsuranceQuote__c a : d) {
				if ('S1'.equals(a.Status__c) || 'S2'.equals(a.Status__c)) {
					r = a;
				}
			}
		}
		return r;
	}

	public static void setObsoletePreviousQuotes(Id appId) {
		List<Application_InsuranceQuote__c> d = getLatestApplicationInsuranceQuotes(appId, 10);
		if (!d.isEmpty()) {
			List<Application_InsuranceQuote__c> u = new List<Application_InsuranceQuote__c>();
			for (Application_InsuranceQuote__c a : d) {
				if ('Q'.equals(a.Status__c)) {
					a.Status__c = 'OB';
					u.add(a);
				}
			}
			if (!u.isEmpty()) {
				update u;
			}
		}
	}

	public static List<Application_Additional_Driver__c> getQuoteAddtionalDrivers(Id quoteId) {
		List<Application_Additional_Driver__c> r = [
			SELECT Application__c, Date_of_Birth__c, First_Name__c, Gender__c, Last_Name__c, 
			       Time_Last_Fault_Accident__c, Year_First_Licence__c, Has_International_Licence__c,
			       Relationship_To_Insured__c, Input_Tax_Credit__c, ABN__c, Driver_Licence__c,
			       Occupation__c, Registered_for_GST__c, Title__c,
			       Address_Line_1__c, Address_Line_2__c, State__c,
				   Postcode__c, Suburb__c, Health_Info_Question_1__c, Health_Info_Question_2__c,
				   Health_Full_Details__c, Email__c, Hasnt_Mobile_Number__c, Mobile__c, Home_Phone__c,
				   Work_Phone__c, RecordTypeId
			FROM Application_Additional_Driver__c
			WHERE Id in (
				SELECT Application_Additional_Driver__c FROM Quote_Additional_Driver__c 
				WHERE Application_Insurance_Quote__c = :quoteId
			)
		];
		return r;
	}

	public static List<Application_Additional_Driver__c> getApplicationAddtionalDrivers(Id appId) {
		List<Application_Additional_Driver__c> r = [
			SELECT Application__c, Date_of_Birth__c, First_Name__c, Gender__c, Last_Name__c, 
			       Time_Last_Fault_Accident__c, Year_First_Licence__c, Has_International_Licence__c,
			       Relationship_To_Insured__c, Input_Tax_Credit__c, ABN__c, Driver_Licence__c,
			       Occupation__c, Registered_for_GST__c, Title__c,
			       Address_Line_1__c, Address_Line_2__c, State__c,
				   Postcode__c, Suburb__c, Health_Info_Question_1__c, Health_Info_Question_2__c,
				   Health_Full_Details__c, Email__c, Hasnt_Mobile_Number__c, Mobile__c, Home_Phone__c,
				   Work_Phone__c, RecordTypeId
			FROM Application_Additional_Driver__c
			WHERE Application__c = :appId
		];
		return r;
	}	

	//***************************************************************
	//  Rules - VEHICLE USAGE
	//***************************************************************
	public static String getUsage(String value) {
		String r = null;
		if ('Personal'.equals(value)) {
			r = 'Private';
		} else {
			r = value;
		}
		return r;
	}
	//***************************************************************
	//  Rules - VEHICLE USAGE INTEGER
	//***************************************************************
	public static Integer getUsageInteger(String value) {
		Integer r = 0;
		if ('Personal'.equals(value)) {
			r = 1; //'Private';
		} else {
			r = 2;
		}
		return r;
	}
	//***************************************************************
	//  Rules - EMPLOYMENT INFORMATION
	//***************************************************************
	//Are you currently employed? 
	public static Boolean isCurrentlyEmployed(String value) {
		Boolean r = false;
		if (!'Unemployed'.equals(value) && !'Financially Supported by Partner'.equals(value)) {
			r = true;
		}
		return r;
	}
    //Jesus Mora 2020-03-19 start
    public static Boolean isSelfEmployed(String value) {
        Boolean r = false;
        if ('Self Employed'.equals(value)) {
            r = true;
        }
        return r;
    }
    //Jesus Mora 2020-03-19 end
	//Is Your employment Permanent full-time or Permanent Part-time for at least twenty (20) hours per week, that is not Seasonal or Intermittent?
	public static Boolean isFullTimeOrPartTime(String value) {
		return isFullTimeOrPartTime(value, null);
	}

	public static Boolean isFullTimeOrPartTime(String value, String empDate) {
		Boolean r = false;
		if ('Full Time'.equals(value) || 'Part Time'.equals(value) || 'Self Employed'.equals(value)) {
			r = true;
		} else {
			if (String.isNotBlank(empDate) && isCasualMoreThan6Months(value, empDate)) {
				r = true;
			}
		}
		return r;
	}

	public static Boolean isCasualMoreThan6Months(String empTtype, String empDate) {
		Boolean r = false;
		if ('Casual'.equals(empTtype) && isEmployed6Months(empDate)) {
			r = true;
		}
		return r;
	}

	//Have You been continuously employed for the last six (6) months? 
	public static Boolean isEmployed6Months(String value) {
		Boolean r = false;
		Date d = convertToDate(value);
		if (d != null) {
			Integer months = d.monthsBetween(Date.today());
			if (months >= 6) {
				r = true;
			} else {
				//Check previous employment
				//Gap les than one month
				//pEnd = convertToDate()
			}
		}
		return r;
	}
	//***************************************************************

	public static Date convertToDate(String value) {
		Date r = null;
		if (value != null) {
			List<String> p = value.split('/');
			if (p.size() == 3) {
				try {
					r = Date.newInstance(Integer.valueOf(p[2]), Integer.valueOf(p[1]), Integer.valueOf(p[0]));
				} catch (Exception e) {
					System.debug(e.getMessage() + '|' + value);
					r = null;
				}
			}
		}
		System.debug(value + ' >> ' + r);
		return r;
	}

	//***************************************************************
	//  Values - Vehicle Condition
	//***************************************************************
	public static String getVehicleCondition(String value) {
		String r = 'Unspecified';
		if ('new'.equalsIgnoreCase(value) || 'demo'.equalsIgnoreCase(value)) {
			r = 'New';
		} else if ('used'.equalsIgnoreCase(value)) {
			r = 'Used';
		}
		return r;
	}
	//***************************************************************
	//  Values - Gender
	//***************************************************************
	public static String getGender(String value) {
		String r = 'Unspecified';
		if ('M'.equalsIgnoreCase(value)) {
			r = 'Male';
		} else if ('F'.equalsIgnoreCase(value)) {
			r = 'Female';
		}
		return r;
	}
	//***************************************************************
	//  Values - Vehicle Type
	//***************************************************************
	public static String getVehicleType(String value) {
		String r = 'Unspecified';
		if ('car'.equalsIgnoreCase(value) || 'truck'.equalsIgnoreCase(value)) {
			r = 'MotorVehicle';
		} else if ('motorcycle'.equalsIgnoreCase(value)) {
			r = 'MotorCycle';
		} else if ('caravan'.equalsIgnoreCase(value)) {
			r = 'Caravan';
		} else if ('marine'.equalsIgnoreCase(value)) {
			r = 'TraileredPleasureCraft';
		}
		return r;
	}
	//***************************************************************
	//  Values - Detailed Vehicle Type
	//***************************************************************
	public static String getDetailedVehicleType(String value) {
		return getDetailedVehicleType(value, null);
	}
	public static String getDetailedVehicleType(String value, String assetType) {
		String r = 'Unspecified';
		if ('car'.equalsIgnoreCase(value) || 'truck'.equalsIgnoreCase(value)) {
			r = 'Car';
		} else if ('motorcycle'.equalsIgnoreCase(value)) {
			r = 'MotorcycleOrJetSki';
		} else if ('caravan'.equalsIgnoreCase(value)) {
			r = 'MinibusOrCampervan';
		} else if ('marine'.equalsIgnoreCase(value)) {
			r = 'WatercraftExcludingJetSkis';
			if ('JetSki'.equals(assetType)) {
				r = 'MotorcycleOrJetSki';
			}
			
		}
		return r;
	}
	//***************************************************************
	//  Values - Financier Id
	//***************************************************************
	public static String getFinancierId(String value) {
		String r = null;
		if (!String.isBlank(value)) {
			String p = value;
			if ('Yamaha Water'.equals(p)) {
				p = 'Yamaha Water Vehicles';
			}
			List<Lenders__c> lst = [SELECT Eric_Financier_Id__c FROM Lenders__c WHERE lender__c = :p];
			if (!lst.isEmpty()) {
				r = lst.get(0).Eric_Financier_Id__c;
			}
		}
		return r;
	}
	//***************************************************************
	//  Values - Date X
	//***************************************************************
	public static servicesFastrComAuData.Date_x convertToDateX(Date d) {
		servicesFastrComAuData.Date_x r = new servicesFastrComAuData.Date_x();
		if (d != null) {
			r = new servicesFastrComAuData.Date_x();
			r.Day = d.day();
			r.Month = d.month();
			r.Year = d.year();
		}
		return r;
	}
	public static servicesFastrComAuData.Date_x convertToDateX(String d) {
		if(String.isBlank(d)) {
			return null;
		}
		return convertToDateX(convertToDate(d));
	}
	//***************************************************************
	//  Values - Financier Type
	//***************************************************************
	public static String getFinancierType(String value) {
		String r = 'None';
		if (!String.isBlank(value)) {
			if ('Personal'.equals(value)) {
				r = 'Consumer';
			} else if ('Business'.equals(value)) {
				r = 'Business';
			}
		}
		return r;
	}
	
	// Commission Rates
	public static Decimal getCommissionPercentage(String productCode) {
		Decimal r = 0.0;
		if (!String.isBlank(productCode)) {
			List<Insurance_Commission__c> d = [
					SELECT Commission__c FROM Insurance_Commission__c WHERE Product_Code__c = :productCode
				];
			if (!d.isEmpty()) {
				r = d.get(0).Commission__c;
			}
		}
		return r;
	}

	//Product Name
	public static String getProductName(String productCode) {
		String r = null;
		if (!String.isBlank(productCode)) {
			if (ericProdLabels == null) {
				ericProdLabels = new Map<String, String>();
				List<Insurance_Commission__c> d = [
					SELECT Product_Code__c, Product__c FROM Insurance_Commission__c
				];
				for (Insurance_Commission__c a: d) {
					ericProdLabels.put(a.Product_Code__c, a.Product__c);
				}
			}
			r = ericProdLabels.get(productCode);
		}
		return r;
	}

	// Product Name
	public static Insurance_Commission__c getInsuranceCommission(String productCode) {
		Insurance_Commission__c r = null;
		if (!String.isBlank(productCode)) {
			List<Insurance_Commission__c> d = [
					SELECT Commission__c, Insurance__c, Product__c, Product_Code__c 
					FROM Insurance_Commission__c WHERE Product_Code__c = :productCode
				];
			if (!d.isEmpty()) {
				r = d.get(0);
			}
		}
		return r;
	}

	//
	
    public static PageReference goToQuotingTool(Id oppId, String lender) {
		PageReference n = Page.BlankCalculator;
        n.getParameters().put('id', oppId);
        n.getParameters().put('quoting', lender);
        return n;
	}

	public static Map<String, Id> getRecordTypes() {
		Map<String, Id> r = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            r.put(rt.Name, rt.Id);
        }
	    return r;
	}

	public static void associateMainDriverToQuote(Id oldQuoteId, Id newQuoteId) {
		if (String.isNotBlank(oldQuoteId) && String.isNotBlank(newQuoteId)) {
			Application_Additional_Driver__c d = getMainDriver(oldQuoteId);
			if (d != null) {
				Quote_Additional_Driver__c q = new Quote_Additional_Driver__c();
                q.Application_Insurance_Quote__c = newQuoteId;
                q.Application_Additional_Driver__c = d.Id;
                insert q;
			}
		}
	}

	public static Application_Additional_Driver__c getMainDriver(Id quoteId) {
		Application_Additional_Driver__c r = null;
		List<Application_Additional_Driver__c> d = [
			SELECT Application__c, Date_of_Birth__c, First_Name__c, Gender__c, Last_Name__c, 
			       Time_Last_Fault_Accident__c, Year_First_Licence__c, Has_International_Licence__c,
			       Relationship_To_Insured__c, Input_Tax_Credit__c, ABN__c, Driver_Licence__c,
			       Occupation__c, Registered_for_GST__c, Title__c,
			       Address_Line_1__c, Address_Line_2__c, State__c,
				   Postcode__c, Suburb__c, Health_Info_Question_1__c, Health_Info_Question_2__c,
				   Health_Full_Details__c, Email__c, Hasnt_Mobile_Number__c, Mobile__c, Home_Phone__c,
				   Work_Phone__c 
			FROM Application_Additional_Driver__c
			WHERE Id in (
				SELECT Application_Additional_Driver__c FROM Quote_Additional_Driver__c 
				WHERE Application_Insurance_Quote__c = :quoteId
			) AND RecordType.Name = :MAIN_DRIVER_TYPE
		];
		if (!d.isEmpty()) {
			r = d.get(0);
		}
		return r;
	}

	public static List<Application_Additional_Driver__c> getAllAdditionalDrivers(Id quoteId) {
		List<Application_Additional_Driver__c> r = [
			SELECT Application__c, Date_of_Birth__c, First_Name__c, Gender__c, Last_Name__c, 
			       Time_Last_Fault_Accident__c, Year_First_Licence__c, Has_International_Licence__c,
			       Relationship_To_Insured__c, Input_Tax_Credit__c, ABN__c, Driver_Licence__c,
			       Occupation__c, Registered_for_GST__c, Title__c,
			       Address_Line_1__c, Address_Line_2__c, State__c,
				   Postcode__c, Suburb__c, Health_Info_Question_1__c, Health_Info_Question_2__c,
				   Health_Full_Details__c, Email__c, Hasnt_Mobile_Number__c, Mobile__c, Home_Phone__c,
				   Work_Phone__c 
			FROM Application_Additional_Driver__c
			WHERE Id in (
				SELECT Application_Additional_Driver__c FROM Quote_Additional_Driver__c 
				WHERE Application_Insurance_Quote__c = :quoteId
			) AND RecordType.Name = :ADDITIONAL_DRIVER_TYPE
		];
		return r;
	}

	public static List<AddtionalDriver> getAdditionalDriversObj(Id quoteId) {
		List<AddtionalDriver> r = new List<AddtionalDriver>();
		List<Application_Additional_Driver__c> d = getAllAdditionalDrivers(quoteId);
		for (Application_Additional_Driver__c a : d) {
			AddtionalDriver obj = new AddtionalDriver(r.size()+1, a);
            r.add(obj);    
		}
		return r;
	}

	public static List<Insurance_Quote_Annotation__c> getInsuranceQuoteAnnotations(Id quoteId) {
		return [
			SELECT Amount__c, Date__c, Detail__c, Driver__c, Number__c, Is_Driver_Fault__c, 
			       Was_Vehicle_Affected__c, Name_Insurer__c, Insurance_Quote__c, RecordType.Name,
			       Driver__r.First_Name__c, Driver__r.Last_Name__c
			FROM Insurance_Quote_Annotation__c WHERE Insurance_Quote__c = :quoteId
		];
	}

	public static Map<String, List<Insurance_Quote_Annotation__c>> getInsuranceQuoteAnnotationsMap(Id quoteId) {
		Map<String, List<Insurance_Quote_Annotation__c>> r = new Map<String, List<Insurance_Quote_Annotation__c>>();
		List<Insurance_Quote_Annotation__c> d = getInsuranceQuoteAnnotations(quoteId);
		String key = null;
		for (Insurance_Quote_Annotation__c a : d) {
			key = a.RecordType.Name;
			List<Insurance_Quote_Annotation__c> t = r.get(key);
			if (t == null) {
				t = new List<Insurance_Quote_Annotation__c>();
				r.put(key, t);
			}
			t.add(a);
		}
		return r;
	}

	public static List<Application_Payment_Method__c> getPaymentMethods(Id appId) {
		return [
			SELECT Id, Holder_Name__c, Method__c, Account_Number__c, BSB_Number__c, Credit_Card_Number__c,
			       Expiry_Month__c, Expiry_Year__c, Verification_Code__c
			FROM Application_Payment_Method__c WHERE Application__c = :appId
			ORDER BY Method__c
		];
	}


	public static String getPaymentDetailType(String quoteMethod) {
		String r = null;
		if (!String.isBlank(quoteMethod)) {
			if ('CREDITCARD'.equals(quoteMethod) || 'PREMFUND12CC'.equals(quoteMethod)) {
				r = CREDIT_CARD_METHOD;
			} else if ('PREMFUND12BA'.equals(quoteMethod)) {
				r = BANK_ACCOUNT_METHOD;
			}
		}
		return r;
	}

	public static void importQuoteInQuotingTool(Id quoteId, Id oppId) {
		importQuoteInQuotingTool(quoteId, oppId, null);
	}

    public static void importQuoteInQuotingTool(Id quoteId, Id oppId, String quotingName) {
        importQuoteInQuotingTool(quoteId, oppId, quotingName, null);
    }
    
	public static void importQuoteInQuotingTool(Id quoteId, Id oppId, String quotingName, Application_Quoting__c q2) {
		System.debug('Importing quote in Quoting Tools...');
		if (quoteId == null || oppId == null) {
			System.debug('Null parameters. quoteId[' + quoteId + '] oppId[' + oppId + ']');
			return;
		}
		Application_InsuranceQuote__c quote = getApplicationInsuranceQuoteById(quoteId);
		Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(oppId, null);
		if (quote == null || quoting == null) {
			System.debug('Object not found it. quote[' + quote + '] quoting[' + quoting + ']');
			return;
		}
		if (String.isNotBlank(quotingName) && quotingName.length() <= 80) {
			quoting.Name = quotingName;
			delete [SELECT Id FROM Application_Quoting_Result__c WHERE Application_Quoting__c = :quoting.Id];
		}
		//Associate Quote
		quoting.App_Insurance_Quote__c = quote.Id;
		
        refreshQuotingProductPremiums(quote, quoting); 

        if(q2 != null && String.isNotBlank(quote.Motor_Vehicle__c) && quote.MV_Total_Payable__c == 0){
            if(q2.Insurance_MV_Retail_Price__c>0){
                quoting.Insurance_MV_Type__c = 'Suncorp';
                quoting.Insurance_MV_Retail_Price__c = q2.Insurance_MV_Retail_Price__c;
                quoting.Insurance_MV_Income__c = q2.Insurance_MV_Income__c;
                quoting.Insurance_MV_Acceptance__c = 'U';
            }
        }
        
        //Reset current insurance product data
		//GAP
		//quoting.Insurance_GAP_Acceptance__c = null;
        quoting.Insurance_GAP_Acceptance__c = 'U';
		//RTI
		//quoting.Insurance_TAI_Acceptance__c = null;
        quoting.Insurance_TAI_Acceptance__c = 'U';
		//LTI
		//quoting.Insurance_LTI_Acceptance__c = null;
        quoting.Insurance_LTI_Acceptance__c = 'U';
		//Warranty
		//quoting.Insurance_Warranty_Acceptance__c = null;
        quoting.Insurance_Warranty_Acceptance__c = 'U';
		//NWC
		//quoting.Insurance_NWC_Acceptance__c = null;
        quoting.Insurance_NWC_Acceptance__c = 'U';
		//CCI 
		//quoting.Insurance_AIC_Acceptance__c = null;
        quoting.Insurance_AIC_Acceptance__c = 'U';
		//Liberty - products
		quoting.Insurance_VEI_Acceptance__c = null; 
		quoting.Insurance_LPI_Acceptance__c = null; 
		// Reset sending presentation
		quoting.Presentation_Email_Date__c = null;
		quoting.Insurance_Customer_Choice__c = null;
		quoting.Insurance_Choice_Date__c = null;
		quoting.Force_Calculation__c = false;
		quote.Customer_Choice__c = null;
		//quote.Customer_Choice_Date__c = null;
		quote.Customer_Choice_Status__c = null;
		quote.Customer_Choice_Details__c = null;
        if(String.isNotBlank(quote.Motor_Vehicle__c)){
            quote.MV_Acceptance__c = quoting.Insurance_MV_Acceptance__c;
        }
		update quoting;
        update quote;
	}

	public static void refreshQuotingProductPremiums(Application_InsuranceQuote__c quote, Application_Quoting__c quoting) {
		if (quote == null || quoting == null) return;
		
        //MV
        quoting.Insurance_MV_Type__c = null;
        quoting.Insurance_MV_Retail_Price__c = null;
        quoting.Insurance_MV_Income__c = null;
        //
        //GAP
		quoting.Insurance_GAP_Type__c = null;
		quoting.Insurance_GAP_Retail_Price__c = null;
		quoting.Insurance_GAP_Income__c = null;
		//RTI
		quoting.Insurance_TAI_Type__c = null;
		quoting.Insurance_TAI_Retail_Price__c = null;
		quoting.Insurance_TAI_Income__c = null;
		//LTI
		quoting.Insurance_LTI_Type__c = null;
		quoting.Insurance_LTI_Retail_Price__c = null;
		quoting.Insurance_LTI_Income__c = null;
        //Jesus Mora 2020-06-04 start    
        //LPI
		quoting.Insurance_AIC_Type__c = null;
		quoting.Insurance_AIC_Retail_Price__c = null;
		quoting.Insurance_AIC_Income__c = null;
        //Jesus Mora 2020-06-04 end
		//Warranty
		quoting.Insurance_Warranty_Type__c = null;
		quoting.Insurance_Warranty_Retail_Price__c = null;
		quoting.Insurance_Warranty_Income__c = null;
		
		//Assign insurance data
		//MV
		if (String.isNotBlank(quote.Motor_Vehicle__c) && quote.MV_Total_Payable__c > 0) {
			quoting.Insurance_MV_Type__c = InsuranceQuoteUtils.getProductName(quote.Motor_Vehicle__c);
			quoting.Insurance_MV_Retail_Price__c = quote.MV_Total_Payable__c;
            quoting.Insurance_MV_Income__c = quote.MV_Commission__c;
			//quoting.Insurance_MV_Acceptance__c = quote.MV_Acceptance__c;
        }
        
		//GAP
		if (String.isNotBlank(quote.Gap__c)) {
			quoting.Insurance_GAP_Type__c = InsuranceQuoteUtils.getProductName(quote.Gap__c);
			quoting.Insurance_GAP_Retail_Price__c = quote.GAP_Total_Payable__c;
			quoting.Insurance_GAP_Income__c = quote.GAP_Commission__c;
			//quoting.Insurance_GAP_Acceptance__c = quote.GAP_Acceptance__c;
		}
		//RTI
		if (String.isNotBlank(quote.Total_assist_RTI__c)) {
			quoting.Insurance_TAI_Type__c = InsuranceQuoteUtils.getProductName(quote.Total_assist_RTI__c);
			quoting.Insurance_TAI_Retail_Price__c = quote.TAS_Total_Payable__c;
			quoting.Insurance_TAI_Income__c = quote.TAS_Commission__c;
			//quoting.Insurance_TAI_Acceptance__c = quote.TAS_Acceptance__c;
		}
		//LTI
		if (String.isNotBlank(quote.LTI_BRI__c)) {
            quoting.Insurance_LTI_Type__c = InsuranceQuoteUtils.getProductName(quote.LTI_BRI__c);
            quoting.Insurance_LTI_Retail_Price__c = quote.LTI_Total_Payable__c;
            quoting.Insurance_LTI_Income__c = quote.LTI_Commission__c;
            //quoting.Insurance_LTI_Acceptance__c = quote.LTI_Acceptance__c;
            
            quoting.Insurance_AIC_Type__c = null;
            quoting.Insurance_AIC_Retail_Price__c = null;
            quoting.Insurance_AIC_Income__c = null;
            quoting.Insurance_AIC_Acceptance__c = null;
        }
        //Jesus Mora 2020-03-26 start
        if (String.isNotBlank(quote.LPI__c)) {
            quoting.Insurance_AIC_Type__c = InsuranceQuoteUtils.getProductName(quote.LPI__c);
            System.debug(quoting.Insurance_AIC_Type__c);
            quoting.Insurance_AIC_Retail_Price__c = quote.LPI_Total_Payable__c;
            quoting.Insurance_AIC_Income__c = quote.LPI_Commission__c;
            //quoting.Insurance_AIC_Acceptance__c = null;  
        }
        //Jesus Mora 2020-03-26 end
		//Warranty
		System.debug(quote.Warranty_Insurance__c + '|' + quote.WRR_Total_Payable__c);
		if (String.isNotBlank(quote.Warranty_Insurance__c) && quote.WRR_Total_Payable__c > 0) {
			quoting.Insurance_Warranty_Type__c = InsuranceQuoteUtils.getProductName(quote.Warranty_Insurance__c);
			quoting.Insurance_Warranty_Retail_Price__c = quote.WRR_Total_Payable__c;
			quoting.Insurance_Warranty_Income__c = quote.WRR_Commission__c;
			//quoting.Insurance_Warranty_Acceptance__c = quote.WRR_Acceptance__c;

			quoting.Insurance_NWC_Retail_Price__c = null;
	        quoting.Insurance_NWC_Income__c = null;
	        quoting.Insurance_NWC_Plan__c = null;
	        quoting.Insurance_NWC_TypeP__c = null;
	        quoting.Insurance_NWC_Term__c = null;
	        quoting.Insurance_NWC_Cost__c = null;
	        quoting.Insurance_NWC_Acceptance__c = null;
		}
	}

	public static void refreshQuotingProductPremiums(String product, Application_InsuranceQuote__c quote, Application_Quoting__c quoting) {
		if (String.isBlank(product) || quote == null || quoting == null) return;

		if (INS_PROD_MV.equals(product)) {
			//MV
			if (String.isNotBlank(quote.Motor_Vehicle__c)) {
				quoting.Insurance_MV_Type__c = InsuranceQuoteUtils.getProductName(quote.Motor_Vehicle__c);
				quoting.Insurance_MV_Retail_Price__c = quote.MV_Total_Payable__c;
				quoting.Insurance_MV_Income__c = quote.MV_Commission__c;
			}
		} else if (INS_PROD_LTI.equals(product)) {
			//LTI
			if (String.isNotBlank(quote.LTI_BRI__c)) {
				quoting.Insurance_LTI_Type__c = InsuranceQuoteUtils.getProductName(quote.LTI_BRI__c);
				quoting.Insurance_LTI_Retail_Price__c = quote.LTI_Total_Payable__c;
				quoting.Insurance_LTI_Income__c = quote.LTI_Commission__c;
				quoting.Insurance_LTI_Acceptance__c = quote.LTI_Acceptance__c;
			}
        //Jesus Mora 2020-05-06 start    
		} else if (INS_PROD_CCI.equals(product)) {
			//LPI
			if (String.isNotBlank(quote.LPI__c)) {
				quoting.Insurance_AIC_Type__c = InsuranceQuoteUtils.getProductName(quote.LPI__c);
                System.debug(quoting.Insurance_AIC_Type__c);
				quoting.Insurance_AIC_Retail_Price__c = quote.LPI_Total_Payable__c;
				quoting.Insurance_AIC_Income__c = quote.LPI_Commission__c;
				quoting.Insurance_AIC_Acceptance__c = quote.LPI_Acceptance__c;
			}
		}
        //Jesus Mora 2020-05-06 end
	}

	public static void resetProductAcceptance(Id quotingId) {
		System.debug('Reseting Product Acceptance...');
		if (quotingId == null) return;
		System.debug('Quoting ID >> ' + quotingId);
		Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
		if (quoting == null) {
			System.debug('Object not found it. quoting[' + quotingId + ']');
			return;
		}
		
		quoting.Insurance_MV_Acceptance__c = 'U';	
		quoting.Insurance_GAP_Acceptance__c = 'U';
		quoting.Insurance_TAI_Acceptance__c = 'U';
		quoting.Insurance_LTI_Acceptance__c = 'U';	
		quoting.Insurance_Warranty_Acceptance__c = 'U';
		quoting.Insurance_NWC_Acceptance__c = 'U';	
		quoting.Insurance_AIC_Acceptance__c = 'U';

		quoting.Insurance_Customer_Choice__c = null;
		quoting.Insurance_Choice_Date__c = null;

		update quoting;
		//-
		
		Application_InsuranceQuote__c quote = getApplicationInsuranceQuoteById(quoting.App_Insurance_Quote__c);
		if (quote != null) {
			//QuotE
			quote.MV_Acceptance__c = 'U';
			quote.GAP_Acceptance__c = 'U';
			quote.TAS_Acceptance__c = 'U';
			quote.LTI_Acceptance__c = 'U';
      quote.LPI_Acceptance__c = 'U';
			quote.WRR_Acceptance__c = 'U';
			//
			quote.Customer_Choice_Status__c = CUSCHOICE_DECIDING;
			update quote;
		}
	}

	public static void finishCustomerQuote(Id quotingId, Boolean mvAcceptance) {
		System.debug('Updating Ins Products Acceptance...');
		if (quotingId == null) {
			System.debug('Null parameters. quotingId[' + quotingId + '] mvAcceptance[' + mvAcceptance + ']');
			return;
		}
		
		Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
		if (quoting == null) {
			System.debug('Object not found it. quoting[' + quotingId + ']');
			return;
		}

		Application_InsuranceQuote__c quote = getApplicationInsuranceQuoteById(quoting.App_Insurance_Quote__c);

		finishCustomerQuote(quoting, quote, mvAcceptance);

		update quoting;
		update quote;
		
	}

	public static void finishCustomerQuote(Application_Quoting__c quoting, Application_InsuranceQuote__c quote, Boolean mvAcceptance) {
		if (quoting == null || quote == null) {
			System.debug('Object not found it. quoting[' + quoting + '] quote[' + quote + ']');
			return;
		}
		String choiceStatus = null;
		//Update Quoting tools
		if (mvAcceptance) {
			quoting.Insurance_MV_Acceptance__c = 'A';
			choiceStatus = CUSCHOICE_FILLINFO;
		} else {
			quoting.Insurance_MV_Acceptance__c = 'D';
			if (
        'A'.equals(quoting.Insurance_AIC_Acceptance__c) ||
        'A'.equals(quoting.Insurance_NWC_Acceptance__c)
      ) {
				choiceStatus = CUSCHOICE_FILLINFO;
			} else {
				choiceStatus = CUSCHOICE_FINISHED;
				quoting.Force_Calculation__c = true;
			}
		}

    // if (!displayMVProduct(quoting)) {
    //   quoting.Insurance_MV_Acceptance__c = 'D';
    // }
    // if (!displayGAPProduct(quoting)) {
    //   quoting.Insurance_GAP_Acceptance__c = 'D';
    // }
    // if (!displayLPIProduct(quoting)) {
    //   quoting.Insurance_AIC_Acceptance__c = 'D';
    // }
    // if (!displayEricWARRProduct(quoting)) {
    //   quoting.Insurance_Warranty_Acceptance__c = 'D';
    // }
    // if (!displayIntegrityWARRProduct(quoting)) {
    //   quoting.Insurance_NWC_Acceptance__c = 'D';
    // }

		String choiceDetails = 
      'FullComp:' + quoting.Insurance_MV_Acceptance__c + '|' +
      'GAP:' + quoting.Insurance_GAP_Acceptance__c + '|' +
      'Warr:' + quoting.Insurance_Warranty_Acceptance__c + '|' +
      'NWC:' + quoting.Insurance_NWC_Acceptance__c + '|' + 
      'CCI:' + quoting.Insurance_AIC_Acceptance__c;
    System.debug('finishCustomerQuote... ' + choiceDetails);
		quote.Customer_Choice__c = quoting.Insurance_Customer_Choice__c;
		quote.Customer_Choice_Date__c = Datetime.now();
		quote.Customer_Choice_Details__c = choiceDetails;
		quote.Customer_Choice_Status__c = choiceStatus;
	}

	// public static void updateInsProductAcceptance_old(Id quotingId, String action, String choice, List<String> customProducts) {
	// 	System.debug('Updating Ins Products Acceptance...');
	// 	if (quotingId == null || String.isBlank(action) || String.isBlank(choice)) {
	// 		System.debug('Null parameters. quotingId[' + quotingId + '] action[' + action + '] choice[' + choice + ']');
	// 		return;
	// 	}
	// 	String choiceStatus = CUSCHOICE_DECIDING;
	// 	Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
	// 	if (quoting == null) {
	// 		System.debug('Object not found it. quoting[' + quotingId + ']');
	// 		return;
	// 	}
	// 	Application_InsuranceQuote__c quote = getApplicationInsuranceQuoteById(quoting.App_Insurance_Quote__c);
	// 	Boolean hasLTIProduct = false;
  //   Boolean hasLPIProduct = false;
  //   Boolean hasWarrantyProduct = false;
	// 	if (quote != null && String.isNotBlank(quote.LTI_BRI__c)) {
	// 		hasLTIProduct = true;
	// 	}
  //       if (quote != null && String.isNotBlank(quote.Warranty_Insurance__c)) {
	// 		hasWarrantyProduct = true;
	// 	}
  //   if (String.isNotBlank(quoting.Insurance_AIC_Type__c) && 
  //     quoting.Insurance_AIC_Retail_Price__c != null &&
  //     quoting.Insurance_AIC_Retail_Price__c > 0) {
  //     hasLPIProduct = true;
  //   }
        
	// 	Lenders__c lenderSettings = QuotingCalculation.getLenderSettings(quoting.Name);
	// 	Set<String> insProds = new Set<String>();
  //   Boolean resetInsProds = true;
  //   String customerChoice = choice;
  //   if (QuotingCalculation.PRO_FULLY.equals(choice)) {
  //     if (quoting.Net_Deposit_Percentage__c >= RTI_NET_DEPOSIT_PERC) {
  //       if (isLiberty(quoting)) {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);	
  //         } else {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_TAI);
  //         }
  //     } else {
  //       insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);
  //     }
  //     if (hasLTIProduct) {
  //         insProds.add(InsuranceQuoteUtils.INS_PROD_LTI);
  //       } else if(hasLPIProduct || isLiberty(quoting)){
  //         insProds.add(InsuranceQuoteUtils.INS_PROD_CCI);
  //       }
  //       if (quoting.Has_Warranty__c) {
  //         insProds.add(InsuranceQuoteUtils.INS_PROD_WARR);
  //       } else {
  //         if (quoting.Insurance_NWC_Retail_Price__c > 0) {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_NWC);
  //         }
  //       }
  //       choiceStatus = CUSCHOICE_SELCOMPRE;
  //   } else if (QuotingCalculation.PRO_STANDARD.equals(choice)) {
  //       if (quoting.Net_Deposit_Percentage__c >= RTI_NET_DEPOSIT_PERC) {
  //         if (isLiberty(quoting)) {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);	
  //         } else {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_TAI);
  //         }
  //     } else {
  //       insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);
  //     }
  //       //insProds.add(InsuranceQuoteUtils.INS_PROD_LTI);
  //       if (quoting.Has_Warranty__c) {
  //         insProds.add(InsuranceQuoteUtils.INS_PROD_WARR);
  //       } else {
  //         if (quoting.Insurance_NWC_Retail_Price__c > 0) {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_NWC);
  //         }
  //       }
  //       choiceStatus = CUSCHOICE_DECLARING;
  //       if ((lenderSettings != null && lenderSettings.Exclude_LTI_LPI__c) || 
  //           (!hasLTIProduct && !hasLPIProduct &&
  //           !isLiberty(quoting))) {
  //         choiceStatus = CUSCHOICE_SELCOMPRE;
  //       }
  //   } else if (QuotingCalculation.PRO_BASIC.equals(choice)) {
  //       if (quoting.Net_Deposit_Percentage__c >= RTI_NET_DEPOSIT_PERC) {
  //         if (isLiberty(quoting)) {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);	
  //         } else {
  //           insProds.add(InsuranceQuoteUtils.INS_PROD_TAI);
  //         }
  //     } else {
  //       insProds.add(InsuranceQuoteUtils.INS_PROD_GAP);
  //     }
  //     choiceStatus = CUSCHOICE_DECLARING;
  //       if('Affordable'.equals(quoting.name) && !hasLTIProduct && !hasLPIProduct && !hasWarrantyProduct){
  //           choiceStatus = CUSCHOICE_SELCOMPRE;  
  //       }
  //   } else if (QuotingCalculation.PRO_CUSTOM.equals(choice)) {
  //       insProds.addAll(customProducts);
        
  //       if (customProducts == null || customProducts.size() < 3) {
  //         if (EsandaCalculatorExtension.LENDER_QUOTING.equals(quoting.name)  || 
  //           YamahaMarineCalculatorExtension.LENDER_QUOTING.equals(quoting.name)) {
  //           choiceStatus = CUSCHOICE_SELCOMPRE;
  //         } else if (FinanceOnePLExtension.LENDER_QUOTING.equals(quoting.name)) {
  //           choiceStatus = CUSCHOICE_FILLINFO;
  //         } else if (('Wisr VL'.equals(quoting.name) || 'CarStart'.equals(quoting.name))&& customProducts.size() == 1) {
  //           choiceStatus = CUSCHOICE_SELCOMPRE;
  //         } else if('Affordable'.equals(quoting.name) && customProducts.size()==2 && !hasWarrantyProduct){
  //           choiceStatus = CUSCHOICE_SELCOMPRE;
  //         } else if('Affordable'.equals(quoting.name) && customProducts.size()==1 && !hasLTIProduct && !hasLPIProduct && !hasWarrantyProduct){
  //           choiceStatus = CUSCHOICE_SELCOMPRE;      
  //         } else if(customProducts.size()==2 && !hasLTIProduct && !hasLPIProduct){
  //           choiceStatus = CUSCHOICE_SELCOMPRE;
  //         } else if(quoting.Net_Deposit_Percentage__c >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC && customProducts.size()<=2){
  //           choiceStatus = CUSCHOICE_SELCOMPRE;    
  //         } else{
  //           choiceStatus = CUSCHOICE_DECLARING;
  //         }
  //       } else {
  //         choiceStatus = CUSCHOICE_SELCOMPRE;
  //       }
  //   } else if (QuotingCalculation.PRO_UNPROTECTED.equals(choice)) {
  //       if(quoting.Net_Deposit_Percentage__c >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC &&
  //           !hasLTIProduct && !hasLPIProduct && !hasWarrantyProduct && 'Affordable'.equals(quoting.name)){  
  //           choiceStatus = CUSCHOICE_SELCOMPRE;
  //       }else{
  //           choiceStatus = CUSCHOICE_DECLARING;    
  //       }
  //   }
    
	// 	if (resetInsProds) {
	// 		//QuotingTool
	// 		quoting.Insurance_MV_Acceptance__c = 'D';	
	// 		quoting.Insurance_GAP_Acceptance__c = 'D';
	// 		quoting.Insurance_TAI_Acceptance__c = 'D';
	// 		quoting.Insurance_LTI_Acceptance__c = 'D';	
	// 		quoting.Insurance_Warranty_Acceptance__c = 'D';
	// 		quoting.Insurance_NWC_Acceptance__c = 'D';			
	// 		quoting.Insurance_AIC_Acceptance__c = 'D';
	// 		quoting.Insurance_LPI_Acceptance__c = 'D';
	// 		quoting.Insurance_VEI_Acceptance__c = 'D';
	// 	}

	// 	if (insProds.contains(INS_PROD_MV)) {
	// 		quoting.Insurance_MV_Acceptance__c = action;
	// 	}
	// 	if (insProds.contains(INS_PROD_GAP)) {
	// 		if (isLiberty(quoting)) {
	// 			quoting.Insurance_VEI_Acceptance__c = action;
	// 		} else {
	// 			quoting.Insurance_GAP_Acceptance__c = action;
	// 		}
	// 	}
	// 	if (insProds.contains(INS_PROD_TAI)) {
	// 		quoting.Insurance_TAI_Acceptance__c = action;
	// 	}
	// 	if (insProds.contains(INS_PROD_LTI)) {
	// 		if (QuotingCalculation.PRO_CUSTOM.equals(choice) &&
	// 			isLiberty(quoting)) {
	// 			quoting.Insurance_LPI_Acceptance__c = action;
	// 		} else {
	// 			quoting.Insurance_LTI_Acceptance__c = action;
	// 		}
	// 	}
	// 	if (insProds.contains(INS_PROD_WARR)) {
	// 		quoting.Insurance_Warranty_Acceptance__c = action;
	// 	}
	// 	if (insProds.contains(INS_PROD_NWC)) {
	// 		quoting.Insurance_NWC_Acceptance__c = action;
	// 	}
	// 	if (insProds.contains(INS_PROD_CCI)) {
	// 		if (isLiberty(quoting)) {
	// 			quoting.Insurance_LPI_Acceptance__c = action;
	// 		} else {
	// 			quoting.Insurance_AIC_Acceptance__c = action;
	// 		}
	// 	}
  //   if ('BOQ'.equals(quoting.name) && 'A'.equals(quoting.Insurance_GAP_Acceptance__c)) {
  //     choiceStatus = CUSCHOICE_SELCOMPRE;
  //   }
	// 	quoting.Insurance_Customer_Choice__c = customerChoice;
	// 	quoting.Insurance_Choice_Date__c = Datetime.now();

	// 	// Checking for Comprehensive product
  //       if (CUSCHOICE_SELCOMPRE.equals(choiceStatus)) {
	// 		if (String.isBlank(quoting.Insurance_MV_Type__c)) {
	// 			finishCustomerQuote(quoting, quote, false);
	// 			if ('A'.equals(quoting.Insurance_LTI_Acceptance__c) ||
	// 				'A'.equals(quoting.Insurance_LPI_Acceptance__c) || 
  //                   (String.isNotBlank(quote.LPI__c) && 'A'.equals(quoting.Insurance_AIC_Acceptance__c))) {
  //           		choiceStatus = CUSCHOICE_FILLINFO;   
  //           	} else {
  //           		choiceStatus = CUSCHOICE_FINISHED;
  //           		quoting.Force_Calculation__c = true;
  //           	}
  //           }
	// 	}

	// 	update quoting;
	// 	//-
		
	// 	if (quote != null) {
	// 		if (resetInsProds) {
	// 			//QuotE
	// 			quote.MV_Acceptance__c = 'D';
	// 			quote.GAP_Acceptance__c = 'D';
	// 			quote.TAS_Acceptance__c = 'D';
	// 			quote.LTI_Acceptance__c = 'D';
	// 			quote.WRR_Acceptance__c = 'D';
  //       //Jesus Mora 2020-05-08 start
  //       quote.LPI_Acceptance__c = 'D';
  //       //Jesus Mora 2020-05-08 end
	// 			//
	// 		}
	// 		if (insProds.contains(INS_PROD_MV)) {
	// 			quote.MV_Acceptance__c = action;
	// 		}
	// 		if (insProds.contains(INS_PROD_GAP)) {
	// 			if (!isLiberty(quoting)) {
	// 				quote.GAP_Acceptance__c = action;
	// 			}
	// 		}
	// 		if (insProds.contains(INS_PROD_TAI)) {
	// 			quote.TAS_Acceptance__c = action;
	// 		}
	// 		if (insProds.contains(INS_PROD_LTI)) {
	// 			if (!isLiberty(quoting)) {
	// 				quote.LTI_Acceptance__c = action;
	// 			}
	// 		}
  //           //Jesus Mora 2020-05-08 start
  //           if (insProds.contains(INS_PROD_CCI) && String.isNotBlank(quote.LPI__c)) {
	// 			if (!isLiberty(quoting)) {
	// 				quote.LPI_Acceptance__c = action;
	// 			}
	// 		}
  //           //Jesus Mora 2020-05-08 end
	// 		if (insProds.contains(INS_PROD_WARR)) {
	// 			quote.WRR_Acceptance__c = action;
	// 		}
	// 		quote.Customer_Choice_Status__c = choiceStatus;
	// 		update quote;
	// 	}

	// }

	public static String getPresentationUrlCode(Id appId) {
		String r = null;
		if (appId != null) {
			r = EncodingUtil.urlEncode(CryptoUtils.encrypt(appId),'UTF-8');
		}
		return r;
	}


	private static void loadEricSettings() {
		ericSettings = new Map<String, Eric_Setting__c>();
		List<Eric_Setting__c> d = Eric_Setting__c.getAll().values();
		for (Eric_Setting__c e : d) {
			ericSettings.put(e.Param__c, e);
		}
	}

	private static String getParamEricSettings(String param) {
		String r = null;
		if (ericSettings == null) {
			loadEricSettings();
		}
		Eric_Setting__c e = ericSettings.get(param);
		if (e != null) {
			r = e.Value__c;
		}
		return r;
	}

	public static String getAPIKey() {
		return getParamEricSettings(PARAM_APIKEY);
	}

	public static String getEndPoint() {
		return getParamEricSettings(PARAM_ENDPOINT);
	}

	public static String getPolicyDownloadURL() {
		return getParamEricSettings(POLICY_DOWNLOAD_URL);
	}

	//*******************************************************************************************************
	//Public inner classes
	public class AddtionalDriver {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Additional_Driver__c data {set;get;}

        public AddtionalDriver(Id driverTypeId) {
            this.idx = 0;
            this.isRemoved = false;
            this.data = new Application_Additional_Driver__c(
                            RecordTypeId = driverTypeId);
        }

        public AddtionalDriver(Integer idx, Id driverTypeId) {
            this(driverTypeId);
            this.idx = idx;
        }

        public AddtionalDriver(Integer idx, Application_Additional_Driver__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }

    public class QuoteAnnotationDTO {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Insurance_Quote_Annotation__c data {set;get;}

        public QuoteAnnotationDTO(Id typeId) {
            this.idx = 0;
            this.isRemoved = false;
            this.data = new Insurance_Quote_Annotation__c(
                            RecordTypeId = typeId);
        }

        public QuoteAnnotationDTO(Integer idx, Id typeId) {
            this(typeId);
            this.idx = idx;
        }

        public QuoteAnnotationDTO(Integer idx, Insurance_Quote_Annotation__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }

    public class PaymentMethodDTO {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Payment_Method__c data {set;get;}

        public PaymentMethodDTO(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = new Application_Payment_Method__c();
        }

        public PaymentMethodDTO(Integer idx, Application_Payment_Method__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }

    public class ProductDTO {
        public Integer idx {set;get;}
        public String insurance {set;get;}
        public String name {set;get;}
        public Decimal value {set;get;}
        public String term {set;get;}
        public String acceptance {set;get;}


        public ProductDTO(Integer idx, String insurance) {
            this.idx = idx;
            this.insurance = insurance;
            this.acceptance = 'U';
            this.name = null;
			this.value = null;
			this.term = null;
        }
    }

    public static CloudRequiredDocument downloadPolicyDocument(Id oppId, Insurance_Quote_Policy__c policy, Http http) {
    	return downloadPolicyDocument(oppId, policy, http, null);
    }

    public static CloudRequiredDocument downloadPolicyDocument(Id oppId, Insurance_Quote_Policy__c policy, HTTPResponse response) {
    	return downloadPolicyDocument(oppId, policy, null, response);
    }

 	//Download Policy Document
 	public static CloudRequiredDocument downloadPolicyDocument(Id oppId, Insurance_Quote_Policy__c policy, Http http, HTTPResponse response) {
 		CloudRequiredDocument r = null;
 		HTTPResponse res = null;
 		if (oppId != null && policy != null) {
	 		if (String.isNotBlank(policy.Document_Url__c)) {
	 			if (http == null) {
	 				System.debug('Creating a http object...');
	 				http = new Http();
	 			}
	 			String baseUrl = getPolicyDownloadURL();
	 			String url = policy.Document_Url__c;
	 			HttpRequest req = new HttpRequest();
				req.setEndpoint(url);
				req.setMethod('GET');
				req.setTimeout(TIMEOUT_REQUEST);

	 			res = http.send(req);
				while (res.getStatusCode() >=300 && res.getStatusCode() <= 307 && res.getStatusCode() != 306) {
				    //System.debug('Header Parameters >> ');
				    //for (String k : res.getHeaderKeys()){
				    //    System.debug(k + ': ' + res.getHeader(k));
				    //}
					url = baseUrl + res.getHeader('Location');
					System.debug('URL 2 >> ' + url);
				    req = new HttpRequest();
				    req.setEndpoint(url);
				    req.setMethod('GET');
				    req.setHeader('Cookie', res.getHeader('Set-Cookie')); 
				    req.setTimeout(TIMEOUT_REQUEST);
				    res = http.send(req);
				}
			} else {
				res = response;
			}
		}
		if (res != null) {
			System.debug('Status 2 >> ' + res.getStatusCode() + ' | ' + res.getStatus());
			//System.debug('Header Parameters >> ');
			//for (String k : res.getHeaderKeys()){
			//    System.debug(k + ': ' + res.getHeader(k));
			//}
			String docType = null;
			if (POLICY_CODE_GAP.equals(policy.Product_Code__c)) {
				docType = 'GAP Policy Document';
			} else if (POLICY_CODE_LTI.equals(policy.Product_Code__c)) {
				docType = 'LTI Policy Document';
            //Jesus Mora 2020-06-04 start    
            } else if (POLICY_CODE_LPI.equals(policy.Product_Code__c)) {
				docType = 'LPI Policy Document';
            //Jesus Mora 2020-06-04 end    
			} else if (POLICY_CODE_MV.equals(policy.Product_Code__c)) {
				docType = 'Motor Vehicle Policy Document';
			} else if (POLICY_CODE_WAR.equals(policy.Product_Code__c)) {
				docType = 'Warranty Policy Document';
			} else if (POLICY_CODE_RTI.equals(policy.Product_Code__c)) {
				docType = 'RTI Policy Document';
			} else {
				if (policy.Document_Description__c != null) {
					docType = policy.Document_Description__c.capitalize() + ' Document';
				} else {
					docType = 'Insurance Policy Document';
				}
			}
			//Extract information
			r = new CloudRequiredDocument(docType);
			r.fileName = policy.Policy_Number__c + '.pdf';
			r.docName = r.fileName;
			r.blobFile = res.getBodyAsBlob();
			r.contentType = res.getHeader('Content-Type');
			r.oppId = oppId;
			//System.debug(res.getBody());
			System.debug('End.');
 		}
 		return r;
 	}
 	
 	public static String getLabelQuoteStatus(String value) {
 		String r = getLabelPicklistField(Application_InsuranceQuote__c.Status__c.getDescribe(),
 			value);
 		if (r == null) {
 			r = '';
 		}
 		return r;
 	}

 	public static String getLabelCustomerChoiceStatus(String value) {
 		String r = getLabelPicklistField(Application_InsuranceQuote__c.Customer_Choice_Status__c.getDescribe(),
 			value);
 		if (r == null) {
 			r = '';
 		}
 		return r;
 	}

	public static String getLabelPicklistField(Schema.DescribeFieldResult fieldResult, String value) {
 		String r = null;
 		if (fieldResult != null && value != null) {
	        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	        for( Schema.PicklistEntry f : ple) {
	        	if (f.getValue().equals(value)) {
	        		r = f.getLabel();
	        		break;
	        	}
	        }
 		}
 		return r;
 	}

 	public static Custom_Opportunity__c getOpportunityForInsuranceQuote(Id oppId) {
 		List<Custom_Opportunity__c> r = [
 			SELECT Name, Application__r.Entity_Name__c, Application_AssetDetail__r.Type__c, Application__r.Type_of_Asset__c, 
 			       Application__r.Application_Type__c, Application_AssetDetail__r.Rego__c, Application_AssetDetail__r.Rego_State__c,
 			       Application_AssetDetail__r.Engine_No__c, Application_AssetDetail__r.VIN__c, Application__r.Mode_of_Employment_1__c,
             OwnerId
 			FROM Custom_Opportunity__c WHERE Id = :oppId
 		];
 		if (!r.isEmpty()) {
 			return r.get(0);
 		}
 		return null;
 	}

 	public static Application_InsuranceQuote__c getCurrentQuoteFigures(Application_InsuranceQuote__c quote) {
 		Application_InsuranceQuote__c r = new Application_InsuranceQuote__c();
 		if (quote != null) {
 			// MV
 			r.MV_Establishment_Fee__c = quote.MV_Establishment_Fee__c;
 			r.MV_GST__c = quote.MV_GST__c;
 			r.MV_Premium__c = quote.MV_Premium__c;
 			r.MV_Stamp_Duty__c = quote.MV_Stamp_Duty__c;
 			r.MV_Standard_Excess__c = quote.MV_Standard_Excess__c;
 			r.MV_Imposed_Excess__c = quote.MV_Imposed_Excess__c;
 			r.MV_System_Imposed_Excess__c = quote.MV_System_Imposed_Excess__c;
 			r.MV_Amount_Covered__c = quote.MV_Amount_Covered__c;
 			r.MV_Amount_Covered_Min__c = quote.MV_Amount_Covered_Min__c;
 			r.MV_Amount_Covered_Max__c = quote.MV_Amount_Covered_Max__c;
 			r.MV_Commission_Percentage__c = quote.MV_Commission_Percentage__c;
 			//LTI
 			r.LTI_Establishment_Fee__c = quote.LTI_Establishment_Fee__c;
 			r.LTI_GST__c = quote.LTI_GST__c;
 			r.LTI_Premium__c = quote.LTI_Premium__c;
 			r.LTI_Stamp_Duty__c = quote.LTI_Stamp_Duty__c;
 			r.LTI_Cost_ExGst__c = quote.LTI_Cost_ExGst__c;
 			r.LTI_Commission_Percentage__c = quote.LTI_Commission_Percentage__c;
 			r.LTI_Premium__c = quote.LTI_Premium__c;
            //LPI
 			r.LPI_Establishment_Fee__c = quote.LPI_Establishment_Fee__c;
 			r.LPI_GST__c = quote.LPI_GST__c;
 			r.LPI_Premium__c = quote.LPI_Premium__c;
 			r.LPI_Stamp_Duty__c = quote.LPI_Stamp_Duty__c;
 			r.LPI_Cost_ExGst__c = quote.LPI_Cost_ExGst__c;
 			r.LPI_Commission_Percentage__c = quote.LPI_Commission_Percentage__c;
 			r.LPI_Premium__c = quote.LPI_Premium__c;
 		}
 		return r;
 	}

    public class QuoteAnnotation {
        public Id recId {set;get;}
        public Id driverId {set;get;}
        public String details {set;get;}
        public Integer day {set;get;}
        public Integer month {set;get;}
        public Integer year {set;get;}
        public Integer points {set;get;}

        public String insurer {set;get;}
        public Decimal amount {set;get;}
        public String driverFault {set;get;}
        public String vehicleAffected {set;get;}
		public Integer order {set;get;}

        public Insurance_Quote_Annotation__c getAnnotationObj() {
        	Insurance_Quote_Annotation__c a = new Insurance_Quote_Annotation__c();
        	a.Id = this.recId;
        	a.Driver__c = this.driverId;
    		a.Detail__c = this.details;
    		a.Date__c = DateUtils.convertToDate(this.year, this.month, this.day);
    		if (this.points != null) {
    			a.Number__c = this.points;
    		}
    		a.Name_Insurer__c = this.insurer;
    		a.Amount__c = this.amount;
    		a.Is_Driver_Fault__c = this.driverFault;
    		a.Was_Vehicle_Affected__c = this.vehicleAffected;
    		return a;
        }

    }

    public static QuoteAnnotation makeQuoteAnnotation(Insurance_Quote_Annotation__c a) {
    	QuoteAnnotation r = null;
    	if (a != null)  {
    		r = new QuoteAnnotation();
    		r.recId = a.Id;
    		r.driverId = a.Driver__c;
    		r.details = a.Detail__c;
    		if (a.Date__c != null) {
    			r.day = a.Date__c.day();
    			r.month = a.Date__c.month();
    			r.year = a.Date__c.year();
    		}
    		if (a.Number__c != null) {
    			r.points = Integer.valueOf(a.Number__c);
    		}

    		r.insurer = a.Name_Insurer__c;
    		r.amount = a.Amount__c;
    		r.driverFault = a.Is_Driver_Fault__c;
    		r.vehicleAffected = a.Was_Vehicle_Affected__c;
    	}
    	return r;
    }

    public static List<Insurance_Failure_Reason__c> getInsuranceFailureReasons(Id quoteId) {
    	return [SELECT Reason__c FROM Insurance_Failure_Reason__c WHERE Insurance_Quote__c = : quoteId];
    }

    public static void createAcknowledgementForm(Application_InsuranceQuote__c quote, Application_Quoting__c quoting) {
		if (quote == null || quoting == null) return;
		System.debug('createAcknowledgementForm...');
		if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(quote.Customer_Choice_Status__c)) {
			System.debug('Getting Quoting...');
			System.debug('Quoting >> ' + quoting.Id);
			System.debug('Preparing pdf...');
			// Create document
			PageReference doc = Page.InsuranceAcknowledgementForm;
			doc.getParameters().put('id', quoting.Opportunity__c);
			Blob body;
			try {
				if(Test.isRunningTest()){
					body = Blob.valueOf('Unit.Test');
				} else {	        
	            	body = doc.getContent();
	            }
	            System.debug('pdf size: ' + body.size());
	        } catch (VisualforceException e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
	            body = Blob.valueOf('Error occurred generating the PDF file.');
	        }
	        System.debug('Preparing s3 data...');
			String fileName = 'insurance_acknoledgement_' + quote.Quotation_Number__c + '_' + DateUtils.getTimeForFileName() + '.pdf';
			CloudRequiredDocument d = new CloudRequiredDocument('Insurance Acknowledgement Form');
            d.blobFile = body;
            d.contentType = 'application/pdf';
            d.docName = fileName;
            d.fileName = fileName;
            d.oppId = quoting.Opportunity__c;
        	CloudDocsHelper.saveToS3(d);
		}
		System.debug('end.');
	}

	public static boolean isFormalApprovalValidated(Application_Quoting__c quoting, Application_InsuranceQuote__c quote) {
		Boolean r = true;
		if (quoting == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Calculate and save a quote before saving for Formal Approval'));
			r = false;
		} else {
			// String assetType = ApplicationService.getApplicationAssetType(quoting.Application__c);
			// if ('Car'.equalsIgnoreCase(assetType) ||
			// 	'Bike'.equalsIgnoreCase(assetType) ||
			// 	'Boat'.equalsIgnoreCase(assetType) ||
			// 	'Caravan'.equalsIgnoreCase(assetType) ||
			// 	'JetSki'.equalsIgnoreCase(assetType)) {
			// 	System.debug('Lender >> ' + quoting.Name + '|' + quoting.Presentation_Email_Date__c);
			// 	Boolean checkQuote = true;
			// 	Boolean checkPres = true;
			// 	Boolean checkCusChoice = true;
			// 	if (quoting.Name.startsWith('AFS ') && quote != null) {
			// 		checkCusChoice = false;
			// 		if (!'Car'.equalsIgnoreCase(assetType)) {
			// 			checkQuote = false;
			// 			checkPres = false;
			// 		} else if (String.isNotBlank(quote.Motor_Vehicle__c) && quote.MV_Total_Payable__c == 0) {
			// 			checkPres = false;
			// 		}
			// 	} else if ('Finance One'.equals(quoting.Name) && !'Consumer Loan'.equals(quoting.Loan_Product__c) && quoting.App_Insurance_Quote__c == null) {
			// 		checkQuote = false;
			// 		checkPres = false;
			// 	}
			// 	System.debug('Skipping Insurance Validations for ' + quoting.Name + ': ' + checkQuote + '|' + checkPres);
			// 	//Quote created
	    //         if (checkQuote && quote == null) {
	    //             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Insurance Quote is required.'));
	    //             r = false;
	    //         } else {
		  //           if (SOQLSingletonQueries.recs().isSavvyAdmin() || true) { 
		  //           	// Set other fields
		  //           	if (String.isBlank(quoting.Insurance_Customer_Choice__c)) {
		  //           		if (String.isNotBlank(quote.Customer_Choice__c)) {
		  //           			quoting.Insurance_Customer_Choice__c = quote.Customer_Choice__c;
		  //           		} else {
		  //           			quote.Customer_Choice__c = QuotingCalculation.PRO_CUSTOM;
		  //           			quoting.Insurance_Customer_Choice__c = 'AS';
		  //           		}
		  //           	}
		  //           	if (quoting.Presentation_Email_Date__c == null) {
		  //           		if (quote.Customer_Choice_Date__c != null) {
		  //           			quoting.Presentation_Email_Date__c = quote.Customer_Choice_Date__c;
		  //           		} else {
		  //           			quoting.Presentation_Email_Date__c = Datetime.now();
		  //           		}
		  //           	}
		  //           	if (quoting.Insurance_Choice_Date__c == null) {
		  //           		if (quote.Customer_Choice_Date__c == null) {
		  //           			quote.Customer_Choice_Date__c = Datetime.now();
		  //           		}
		  //           		quoting.Insurance_Choice_Date__c = quote.Customer_Choice_Date__c;
		  //           	}
		  //           	if (!CUSCHOICE_FINISHED.equals(quote.Customer_Choice_Status__c)) {
		  //           		quote.Customer_Choice_Status__c = CUSCHOICE_FINISHED;
		  //           	}
		  //           	return true; 
		  //           }
		  //           //Presentation sent it
		  //           if (checkPres && quoting.Presentation_Email_Date__c == null) {
		  //               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer presentation has not been sent yet.'));
		  //               r = false;
		  //           } else if (checkCusChoice && checkPres && quoting.Insurance_Customer_Choice__c == null) {
		  //               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer has not responded to the insurance presentation yet.'));
		  //               r = false;
		  //           } else {
		  //               if (checkPres && quote != null) {
		  //                   if (!CUSCHOICE_FINISHED.equals(quote.Customer_Choice_Status__c)) {
		  //                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer has not finished their insurance presentation yet.'));
		  //                       r = false;
		  //                   }
		  //               }
		  //           }
		  //       }
	    //     }
    }
		return r;
	}

	public static void deleteFailureReasons(Id quoteId) {
		if (quoteId != null) {
			delete[SELECT Id FROM Insurance_Failure_Reason__c WHERE Insurance_Quote__c = :quoteId];
		}
	}

	public static Insurance_History_Request__c trackWS(Custom_Opportunity__c opp, Application_InsuranceQuote__c quote, String process, String inputType, String content) {
		Insurance_History_Request__c a = null;
		if (opp == null || quote == null || String.isBlank(content)) {
			return a;
		}
		a = new Insurance_History_Request__c();
		a.Custom_Opportunity__c = opp.Id;
		a.Application_Insurance_Quote__c = quote.Id;
		a.Process__c = process;
		a.Type__c = inputType;
		a.Content__c = content;
        
		return a;
	}

	public static Boolean isQuotePresenting(Application_InsuranceQuote__c quote) {
		return isQuotePresenting(quote, true);
	}

	public static Boolean isQuotePresenting(Application_InsuranceQuote__c quote, Boolean includeMsg) {
		Boolean r = false;
    if (
      quote != null && String.isNotBlank(quote.Customer_Choice_Status__c) && 
			!CUSCHOICE_FINISHED.equals(quote.Customer_Choice_Status__c)
    ) {
			if (includeMsg) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your customer should finalize their presentation to proceed with.'));
			}
			r = true;
		}
		if (r) {
      User sa = SOQLSingletonQueries.recs().sysAdminUser;
      if (sa != null && sa.Id == UserInfo.getUserId()) {
        r = false;
      }
    }
		return r;
    // TODO - remove below line and uncomment above one
    // return false;
	}

	// Lelo 		2019-02-19
	public static String getRestDeailerId() {
		return getParamEricSettings(REST_DEALER_ID);
	}
	public static String getRestDeailerName() {
		return getParamEricSettings(REST_DEALER_NAME);
	}
	public static String getRestEndPoint() {
		return getParamEricSettings(REST_END_POINT);
	}
	public static String getRestPwd() {
		return getParamEricSettings(REST_PWD);
	}
	public static String getRestUserId() {
		return getParamEricSettings(REST_USER_ID);
	}
	public static String getRestUsername() {
		return getParamEricSettings(REST_USERNAME);
	}
	//
	
	public static List<Insurance_Quote_Policy__c> getPolicies(Id quoteId) {
		List<Insurance_Quote_Policy__c> r = new List<Insurance_Quote_Policy__c>();
		if (quoteId != null) {
			r = [SELECT Id, Name, Application_Insurance_Quote__c, Cover_Type__c, Document_Description__c,
		                Document_Url__c, Policy_Number__c, Product_Code__c
				 FROM Insurance_Quote_Policy__c WHERE Application_Insurance_Quote__c = :quoteId];
		}
		return r;
	}

	public static void saveFailureReasons(Id quoteId, List<String> messages) {
		if (messages != null) {
			List<Insurance_Failure_Reason__c> freasons = new List<Insurance_Failure_Reason__c>();
			for (String s: messages) {
				Insurance_Failure_Reason__c re = new Insurance_Failure_Reason__c();
	            re.Insurance_Quote__c = quoteId;
	            re.Reason__c = s.mid(0,255);
	         	freasons.add(re);
			}
			if (!freasons.isEmpty()) {
				insert freasons;
			}
		}
	}

    public static void declineHealthProducts(Application_Quoting__c quoting, Application_InsuranceQuote__c quote) {
		if (quote == null || quoting == null) return;
        if (String.isNotBlank(quote.LTI_BRI__c)) {
            quote.LTI_Acceptance__c = 'D';
            quoting.Insurance_LTI_Acceptance__c = 'D';
        } else if(String.isNotBlank(quote.LPI__c)){
            quote.LPI_Acceptance__c = 'D';
            quoting.Insurance_AIC_Acceptance__c = 'D';    
        } else {
            quoting.Insurance_LPI_Acceptance__c = 'D';
        }
    }

	public static void deleteQuotePolicies(Id quoteId) {
		if (quoteId != null) {
			delete[SELECT Id FROM Insurance_Quote_Policy__c WHERE Application_Insurance_Quote__c = :quoteId];
		}
	}
    
    public static Application_InsuranceQuote__c createDefaultInsuranceQuote(Custom_Opportunity__c opp, Application_Quoting__c quoting){
      if (opp != null) {
        String name = '';
        if (String.isNotBlank(opp.First_Name__c)) {
          name = opp.First_Name__c;
        }
        if (String.isNotBlank(opp.Last_Name__c)) {
          if (String.isNotBlank(name)) name += ' ';
          name = opp.Last_Name__c;
        }
        if (String.isBlank(name) && String.isNotBlank(opp.Name)) {
          name = opp.Name;
        }
        if (name.length() > 63) {
          name = name.substring(0,63);
        }
        String qnumb = 'S' + DateUtils.formatDate(DateTime.now(), 'yyyyMMdd-HHmm');
        name += ' [' + qnumb + ']';
        return new Application_InsuranceQuote__c(
          Customer_Choice_Status__c = 'SENT', 
          Name = name,
          Quotation_Number__c = qnumb,
          Quotation_Date__c = Date.today(),
          Financier_Name__c = quoting.Name,
          Quotation_Creator__c = userInfo.getUserId(),
          MV_Acceptance__c = 'U',
          GAP_Acceptance__c = 'U',
          TAS_Acceptance__c = 'U',
          LTI_Acceptance__c = 'U',
          LPI_Acceptance__c = 'U',
          WRR_Acceptance__c = 'U',
          Status__c = 'Q', 
          Application__c = opp.Application__c
        ); 
      }
      return null;
    }
	
	public static void createDefaultMainDriver(Custom_Opportunity__c opp, Application_InsuranceQuote__c quote){
		if (opp != null) {
			Application_Additional_Driver__c ad = new Application_Additional_Driver__c(
        RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get(InsuranceQuoteUtils.MAIN_DRIVER_TYPE)
      );
			ad.Application__c = opp.Application__c;
			ad.First_Name__c = opp.Application__r.First_Name__c;
			ad.Last_Name__c = opp.Application__r.Last_Name__c;
			ad.Status__c = 'Active';
			insert ad;
			Quote_Additional_Driver__c qd = new Quote_Additional_Driver__c();
			qd.Application_Additional_Driver__c = ad.Id;
			qd.Application_Insurance_Quote__c = quote.Id;
			insert qd;
		}
	}

    public static Application_InsuranceQuote__c assigMVAcceptanceToDecline(String mvLevel, String mvAcceptance, Application_InsuranceQuote__c quote){
        if (quote.Id != null) {
            quote.MV_Acceptance__c = mvAcceptance;
            if('Suncorp'.equals(mvLevel)){
                quote.MV_Acceptance__c = 'D';
            }
        }
        return quote;
    }

	public static Set<String> getPDSDocumentTypes(Application_Quoting__c quoting, Application_InsuranceQuote__c quote, String assetType) {
		Set<String> r = new Set<String>();
		// MV
		if (displayMVProduct(quoting)) {
			r.add(PDS_Eric_MVI);
		}
		// if ('Bike'.equals(assetType)) {
		// 	r.add(PDS_Eric_BIKES);
		// }
		// GAP
		if (displayEricGAPProduct(quoting)) {
			r.add(PDS_Eric_EPI);
		} else if (displayLibertyGAPProduct(quoting)) {
			// r.add(PDS_Liberty_VEI_QF);
      r.add(PDS_Liberty_VEI);
		}
		
    System.debug('quoting.Insurance_LPI_Options__c => ' + quoting.Insurance_LPI_Options__c + '|' + displayLibertyLPIProduct(quoting));
    // LPI
    if (displayEricLPIProduct(quoting)) {
      r.add(PDS_Eric_FPI);
    } else if (displayLibertyLPIProduct(quoting)) {
      System.debug('adding Liberty LPI document...');
      // r.add(PDS_Liberty_LPI_QF);
      r.add(PDS_Liberty_LPI);
    }
		
		// Warranty
		if (
      displayEricWARRProduct(quoting) && 
      String.isNotBlank(quoting.Insurance_Warranty_Type__c)
    ) {
			if (quoting.Insurance_Warranty_Type__c.startsWith('4 Star')) {
				r.add(PDS_Eric_WAR4);
			} else if (quoting.Insurance_Warranty_Type__c.startsWith('5 Star')) {
				r.add(PDS_Eric_WAR5);
			} else if (quoting.Insurance_Warranty_Type__c.startsWith('3 Star')) {
				r.add(PDS_Eric_WAR3);
			}
		} else if (displayIntegrityWARRProduct(quoting)) {
			// Integrity
			if ('Car'.equalsIgnoreCase(assetType)) {
        String prodType = quoting.Insurance_NWC_TypeP__c;
        if (String.isNotBlank(prodType) && prodType.containsIgnoreCase('Endurance')) {
          r.add(PDS_Integrity_Endurance);
        } else if (String.isNotBlank(prodType) && prodType.containsIgnoreCase('Absolute')) {
          r.add(PDS_Integrity_Absolute);
        } else {
				  r.add(PDS_Integrity_Car);
        }
			} else if ('Caravan'.equalsIgnoreCase(assetType)) {
				r.add(PDS_Integrity_Caravan);
			} else if ('Bike'.equalsIgnoreCase(assetType)) {
				r.add(PDS_Integrity_Motorbike);
			} else if ('Boat'.equalsIgnoreCase(assetType)) {
				r.add(PDS_Integrity_Marine);
			} else if ('JetSki'.equalsIgnoreCase(assetType)) {
				r.add(PDS_Integrity_Jetsky);
			} else if ('Truck'.equalsIgnoreCase(assetType)) {
				r.add(PDS_Integrity_Truck);
			} else if (String.isNotBlank(assetType)) {
        if (assetType.contains('Motorhome')) {
          r.add(PDS_Integrity_Motorhome);
        } 
      }
		}
    System.debug('getPDSDocumentTypes => ' + r);
		return r;
	}

  // public static Set<String> getPDSDocumentTypes_old(Application_Quoting__c quoting, Application_InsuranceQuote__c quote, String assetType) {
	// 	Set<String> r = new Set<String>();
	// 	// MV
	// 	if (String.isNotBlank(quote.Motor_Vehicle__c)) {
	// 		if('Suncorp'.equals(quoting.Insurance_MV_Type__c)) {
	// 			r.add(PDS_Suncorp_Car);
	// 			r.add(PDS_Suncorp_DD);
	// 		} else {
	// 			r.add(PDS_Eric_MVI);
	// 		}
	// 	}
	// 	if ('Bike'.equals(assetType)) {
	// 		r.add(PDS_Eric_BIKES);
	// 	}
	// 	// GAP
	// 	if (String.isNotBlank(quote.Gap__c)) {
	// 		r.add(PDS_Eric_GAP);
	// 	}
	// 	// RTI
	// 	if (String.isNotBlank(quote.Total_assist_RTI__c)) {
	// 		r.add(PDS_Eric_RTI);
	// 	}
	// 	// LTI
	// 	if (String.isNotBlank(quote.LTI_BRI__c)) {
	// 		r.add(PDS_Eric_LTI);
	// 	} else {
	// 		// LPI
	// 		if (!quoting.Name.startsWith('AFS ') && !quoting.Name.startsWith('Yamaha') && quoting.Insurance_AIC_Retail_Price__c > 0) {
	// 			r.add(PDS_Eric_LPI);
	// 			r.add(PDS_Eric_LPI_GUIDE);
	// 		}
	// 	}
	// 	// Warranty
	// 	if (String.isNotBlank(quote.Warranty_Insurance__c)) {
	// 		if (quote.Warranty_Insurance__c.startsWith('MVW5')) {
	// 			r.add(PDS_Eric_WAR5);
	// 		} else if (quote.Warranty_Insurance__c.startsWith('MVW4')) {
	// 			r.add(PDS_Eric_WAR4);
	// 		}
	// 	} else if (quoting.Insurance_NWC_Retail_Price__c > 0 && String.isNotBlank(quoting.Insurance_NWC_TypeP__c)) {
	// 		// Integrity
	// 		if ('Car'.equalsIgnoreCase(assetType)) {
	// 			r.add(PDS_Integrity_Car);
	// 		} else if ('Bike'.equalsIgnoreCase(assetType)) {
	// 			r.add(PDS_Integrity_Motorbike);
	// 		} else if ('Boat'.equalsIgnoreCase(assetType) || 
	// 		           'JetSki'.equalsIgnoreCase(assetType)) {
	// 			r.add(PDS_Integrity_Marine);
	// 		} else if ('Truck'.equalsIgnoreCase(assetType)) {
	// 			r.add(PDS_Integrity_Truck);
	// 		} 
	// 		//TODO - pending a documento for Caravans
	// 	}
	// 	// Liberty
	// 	if (isLiberty(quoting)) {
	// 		if (String.isNotBlank(quoting.Insurance_VEI_Type__c) && quoting.Insurance_VEI_Retail_Price__c > 0) {
	// 			r.add(PDS_Liberty_VEI);
	// 		}
	// 		if (String.isNotBlank(quoting.Insurance_LPI_Type__c) && quoting.Insurance_LPI_Retail_Price__c > 0) {
	// 			r.add(PDS_Liberty_LPI);
	// 		}
	// 	}
	// 	return r;
	// }
    
    //Yohan VillaLeal                    03-01-2020
    public static Boolean validateLendersNotLPIorLTI(String Lender){
        if('Macquarie Consumer'.equals(Lender) || 
           'Macquarie Commercial'.equals(Lender) ||
           'RateSetter'.equals(Lender) ||
           'RateSetter PL'.equals(Lender)
          ){
              return false; 
          }
        return true;
    }
    //Jesus Mora 2020-06-04 start
    public static void recalculateQuoteAcceptance(Application_InsuranceQuote__c quote, Application_Quoting__c quoting, Boolean isSaveQuote) {
        if (String.isNotBlank(quote.Gap__c) && String.isNotBlank(quoting.Insurance_GAP_Acceptance__c)) {
            quote.GAP_Acceptance__c = quoting.Insurance_GAP_Acceptance__c;
        }
        
        if (String.isNotBlank(quote.Motor_Vehicle__c) && String.isNotBlank(quoting.Insurance_MV_Acceptance__c)) {
            quote.MV_Acceptance__c = quoting.Insurance_MV_Acceptance__c;
        }
        
        if (String.isNotBlank(quote.Warranty_Insurance__c) && String.isNotBlank(quoting.Insurance_Warranty_Acceptance__c)) {
            quote.WRR_Acceptance__c = quoting.Insurance_Warranty_Acceptance__c;
        }
        
        if (String.isNotBlank(quote.LPI__c) && String.isNotBlank(quoting.Insurance_AIC_Acceptance__c)) {
            quote.LPI_Acceptance__c = quoting.Insurance_AIC_Acceptance__c;
        }
        
        if (String.isNotBlank(quote.LTI_BRI__c) && String.isNotBlank(quoting.Insurance_LTI_Acceptance__c)) {
            quote.LTI_Acceptance__c = quoting.Insurance_LTI_Acceptance__c;
        }
        
        if (String.isNotBlank(quote.Total_assist_RTI__c) && String.isNotBlank(quoting.Insurance_TAI_Acceptance__c)) {
            quote.TAS_Acceptance__c = quoting.Insurance_TAI_Acceptance__c;
        }
        
        if (isSaveQuote) {
            update quote;  
        }
    }
    
  public static void resetProductAcceptance(Application_Quoting__c quoting, Application_InsuranceQuote__c quote) {
    if (quoting != null) {
        quoting.Insurance_MV_Acceptance__c = 'U';	
        quoting.Insurance_GAP_Acceptance__c = 'U';
        quoting.Insurance_TAI_Acceptance__c = 'U';
        quoting.Insurance_LTI_Acceptance__c = 'U';	
        quoting.Insurance_Warranty_Acceptance__c = 'U';
        quoting.Insurance_NWC_Acceptance__c = 'U';	
        quoting.Insurance_AIC_Acceptance__c = 'U';
    }
		if (quote != null) {
			//QuotE
			quote.MV_Acceptance__c = 'U';
			quote.GAP_Acceptance__c = 'U';
			quote.TAS_Acceptance__c = 'U';
			quote.LTI_Acceptance__c = 'U';
			quote.WRR_Acceptance__c = 'U';
            quote.LPI_Acceptance__c = 'U';
		}
	}
    //Jesus Mora 2020-06-04 end
  public static Boolean isLiberty(Application_Quoting__c q) {
    return q != null && ('Liberty Drive'.equals(q.name) || 'Liberty Leisure'.equals(q.name));
  }

  // Lelo       2021-09-20
  public static Boolean displayMVProduct(Application_Quoting__c q) {
    return q != null && String.isNotBlank(q.Insurance_MV_Options__c);
  }
  // GAP
  public static Boolean displayGAPProduct(Application_Quoting__c q) {
    return q != null && String.isNotBlank(q.Insurance_Shortfall_Options__c);
  }
  public static Boolean displayEricGAPProduct(Application_Quoting__c q) {
    return displayGAPProduct(q) && INS_PROD_GAP_ERIC.equals(q.Insurance_Shortfall_Options__c);
  }
  public static Boolean displayLibertyGAPProduct(Application_Quoting__c q) {
    return displayGAPProduct(q) && INS_PROD_GAP_LIBE.equals(q.Insurance_Shortfall_Options__c);
  }
  // LPI
  public static Boolean displayLPIProduct(Application_Quoting__c q) {
    return q != null && String.isNotBlank(q.Insurance_LPI_Options__c);
  }
  public static Boolean displayEricLPIProduct(Application_Quoting__c q) {
    return displayLPIProduct(q) && INS_PROD_LPI_ERIC.equals(q.Insurance_LPI_Options__c);
  }
  public static Boolean displayLibertyLPIProduct(Application_Quoting__c q) {
    return displayLPIProduct(q) && INS_PROD_LPI_LIBE.equals(q.Insurance_LPI_Options__c);
  }
  // Warranty
  public static Boolean displayWARRProduct(Application_Quoting__c q) {
    return q != null && String.isNotBlank(q.Insurance_Warranty_Options__c);
  }
  public static Boolean displayEricWARRProduct(Application_Quoting__c q) {
    return displayWARRProduct(q) && INS_PROD_WARR_ERIC.equals(q.Insurance_Warranty_Options__c);
  }
  public static Boolean displayIntegrityWARRProduct(Application_Quoting__c q) {
    return displayWARRProduct(q) && INS_PROD_WARR_INTE.equals(q.Insurance_Warranty_Options__c);
  }
  // Tyre & Wheels
  public static Boolean displayTyWhProduct(Application_Quoting__c q) {
    return q != null && String.isNotBlank(q.Insurance_Tyre_Whell_Options__c);
  }
  // ---------------------------------------------------------
  public static Boolean isProductCalculated(String prodType) {
    return String.isNotBlank(prodType) && prodType.contains('Liberty');
  }

  public static List<SelectOption> buildProductOptions(String prodType) {
    List<String> levels = new List<String>();
    String options = null;
    if (INS_PROD_GAP_LIBE.equals(prodType)) {
      options = System.Label.LibertyShortfallOptions;
    } else if (INS_PROD_LPI_LIBE.equals(prodType)) {
      options = System.Label.LibertyLPIOptions;
    } else if (INS_PROD_LPI_ERIC.equals(prodType)) {
      options = System.Label.EricLPIOptions;
    } else if (INS_PROD_WARR_ERIC.equals(prodType)) {
      options = System.Label.EricWarrantyOptions;
    } else if (INS_PROD_MV_ERIC.equals(prodType)) {
      options = System.Label.EricMVOptions;
    }
    if (String.isNotBlank(options)) {
      levels = new List<String>(options.split('\\|'));
    }
    List<SelectOption> r = new List<SelectOption>();
    if (String.isNotBlank(prodType) && levels.isEmpty()) {
      r.add(new SelectOption('','(not applicable)'));
    } else {
      r.add(new SelectOption('','--None--'));
      for (String lv: levels) {
        r.add(new SelectOption(lv,lv));
      }
    }
    return r;
  }

  public static List<SelectOption> buildTermOptions() {
    List<String> levels = new List<String>();
    List<SelectOption> r = new List<SelectOption>();
    r.add(new SelectOption('','--None--'));
    r.add(new SelectOption('12','12'));
    r.add(new SelectOption('24','24'));
    r.add(new SelectOption('36','36'));
    r.add(new SelectOption('48','48'));
    r.add(new SelectOption('60','60'));
    r.add(new SelectOption('72','72'));
    r.add(new SelectOption('84','84'));
    return r;
  }

  public static Boolean isEricInsProduct(String prodType) {
    return String.isNotBlank(prodType) && prodType.containsIgnoreCase('Eric');
  }

  public static Boolean isLibertyInsProduct(String prodType) {
    return String.isNotBlank(prodType) && prodType.containsIgnoreCase('Liberty');
  }

  public static void updateInsProductAcceptance(Id quotingId, String action, String choice, List<String> customProducts) {
    Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
    updateInsProductAcceptance(quoting, action, choice, customProducts);
  }

  public static void updateInsProductAcceptance(Application_Quoting__c quoting, String action, String choice, List<String> customProducts) {
		System.debug('Updating Ins Products Acceptance...');
		if (quoting == null || String.isBlank(action) || String.isBlank(choice)) {
			System.debug('Null parameters. action[' + action + '] choice[' + choice + ']');
			return;
		}
		// Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuotingById(quotingId);
		// if (quoting == null) {
		// 	System.debug('Object not found it. quoting [' + quotingId + ']');
		// 	return;
		// }
		Application_InsuranceQuote__c quote = getApplicationInsuranceQuoteById(quoting.App_Insurance_Quote__c);

    String choiceStatus = CUSCHOICE_SELCOMPRE;
    String customerChoice = choice;

		Boolean hasMVProduct = displayMVProduct(quoting);
    Boolean hasGAPProduct = displayGAPProduct(quoting);
    Boolean hasLPIProduct = displayLPIProduct(quoting);
    Boolean hasWarrantyProduct = displayEricWARRProduct(quoting);
    Boolean hasNWCProduct = displayIntegrityWARRProduct(quoting);
    
		Lenders__c lenderSettings = QuotingCalculation.getLenderSettings(quoting.Name);
		Set<String> insProds = new Set<String>();
    Boolean resetInsProds = true;
    
    if (QuotingCalculation.PRO_CUSTOM.equals(choice)) {
      insProds.addAll(customProducts);
      if (
        (hasGAPProduct && !customProducts.contains(INS_PROD_GAP)) ||
        (hasLPIProduct && !customProducts.contains(INS_PROD_CCI)) ||
        (hasWarrantyProduct && !customProducts.contains(INS_PROD_WARR)) ||
        (hasNWCProduct && !customProducts.contains(INS_PROD_NWC))
      ) {
        choiceStatus = CUSCHOICE_DECLARING;
      }
    } else if (QuotingCalculation.PRO_UNPROTECTED.equals(choice)) {
      if(hasGAPProduct || hasLPIProduct || hasWarrantyProduct || hasNWCProduct) {  
        choiceStatus = CUSCHOICE_DECLARING;
      }
    }

    if (hasGAPProduct) {
      quoting.Insurance_GAP_Acceptance__c = insProds.contains(INS_PROD_GAP)? 'A' : 'D';
    }
    if (hasLPIProduct) {
      quoting.Insurance_AIC_Acceptance__c = insProds.contains(INS_PROD_CCI)? 'A' : 'D';
    }
    if (hasWarrantyProduct) {
      quoting.Insurance_Warranty_Acceptance__c = insProds.contains(INS_PROD_WARR)? 'A' : 'D';
    }
    if (hasNwcProduct) {
      quoting.Insurance_NWC_Acceptance__c = insProds.contains(INS_PROD_NWC)? 'A' : 'D';
    }

    System.debug('hasWarrantyProduct = > ' + hasWarrantyProduct + ' | ' + quoting.Insurance_Warranty_Acceptance__c + ' | ' + quoting.Insurance_NWC_Acceptance__c);
    System.debug('displayEricWARRProduct = > ' + displayEricWARRProduct(quoting));
    System.debug('displayIntegrityWARRProduct = > ' + displayIntegrityWARRProduct(quoting));
    System.debug('customProducts = > ' + customProducts);
    System.debug('insProds = > ' + insProds);

    
		quoting.Insurance_Customer_Choice__c = customerChoice;
		quoting.Insurance_Choice_Date__c = Datetime.now();

		// Checking for Comprehensive product
    if (CUSCHOICE_SELCOMPRE.equals(choiceStatus)) {
			if (!hasMVProduct) {
				finishCustomerQuote(quoting, quote, false);
				if (
          'A'.equals(quoting.Insurance_AIC_Acceptance__c) ||
          'A'.equals(quoting.Insurance_NWC_Acceptance__c)
        ) {
          choiceStatus = CUSCHOICE_FILLINFO;
        } else {
          choiceStatus = CUSCHOICE_FINISHED;
          quoting.Force_Calculation__c = true;
        }
      }
		}

		update quoting;
		//-
		
		if (quote != null) {
			quote.Customer_Choice_Status__c = choiceStatus;
			update quote;
		}

	}
}