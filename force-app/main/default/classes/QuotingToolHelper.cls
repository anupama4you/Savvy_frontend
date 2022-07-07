public class QuotingToolHelper {
    
    private static final String PARAM_PARTNER_PORTAL_URL_BASE = 'Partner_Portal_URL_BASE';

    private static Map<String, Map<String, Liberty_VEI_Setting__c>> libVeiSettings = null;
    private static Map<String, Map<String, FinanceOneRates__c>> finance1Rates = null;
    
    private static final String APP_QUOTING_SOQL = '' + 
        'SELECT Id, Name, Adverse_Credit_File__c, Application__c, Application_Fee__c, Loan_Facility_Type__c, ' +
        '       Base_Rate__c, Client_Rate__c, Commission_DOF__c, Commission_Estimation__c, Category_Type__c, ' +
        '       Commission_Insurance_Income__c, Commission_Total_GST_Exc__c, Commission_Total_GST_Inc__c, ' +
        '       Customer_Profile__c, DOF__c, Deposit__c, Goods_type__c, Goods_sub_type__c, Loan_Frequency__c, Residual_Value_Percentage__c, ' +
        '       Mcq_Gross_Payment__c, Mcq_Customer_Rate__c, Mcq_Payment_Frequency__c, Mcq_Message_Quote__c, Mcq_Last_Response_Quote__c, ' +
        '       Mcq_Application_Id__c, Mcq_Message_Application_Id__c, Mcq_Last_Response_Application__c, ' +
        '       Insurance_AIC_Income__c, Insurance_AIC_Retail_Price__c, Insurance_GAP_Income__c, Insurance_GAP_Retail_Price__c, ' +
        '       Insurance_GAP_Type__c, Insurance_LTI_Income__c, Insurance_LTI_Retail_Price__c, ' +
        '       Insurance_LTI_Type__c, Insurance_MV_Income__c, Insurance_MV_Retail_Price__c, Brokerage__c, ' +
        '       Insurance_MV_Type__c, Insurance_NWC_Income__c, Insurance_NWC_Retail_Price__c, ' +
        '       Insurance_TAI_Income__c, Insurance_TAI_Retail_Price__c, Insurance_TAI_Type__c, Loan_Product__c, ' +
        '       Insurance_Truck_GAP_Income__c, Insurance_Truck_GAP_Retail_Price__c, Insurance_Truck_GAP_Type__c, ' + 
        '       Insurance_Warranty_Income__c, Insurance_Warranty_Retail_Price__c, Insurance_Warranty_Type__c, ' +
        '       Loan_Type__c, LTV__c, Monthly_Fee__c, NAF__c, Payment__c, Payout_On__c, PPSR__c, Rental__c, ' + 
        '       Repayment_Fortnightly__c, Repayment_Monthly__c, Repayment_Weekly__c, Residual_Value__c, ' + 
        '       Term__c, Trade_In__c, Vehicle_Age__c, Vehicle_Detail_AWD__c, Vehicle_Detail_Diesel__c, ' + 
        '       Vehicle_Detail_Group__c, Vehicle_Detail_State__c, Vehicle_Detail_Turbo__c, Vehicle_Price__c, ' +
        '       Recommended_Rate__c, Vehicles_Profile__c, Is_MotorCycles__c, Is_Caravans__c, Private_Sales__c, ' +
        '       Client_Tier__c, Insurance_ISP_Income__c, Insurance_ISP_Retail_Price__c, Insurance_FPA_Income__c, ' + 
        '       Insurance_FPA_Retail_Price__c, Insurance_VEI_Income__c, Insurance_VEI_Retail_Price__c, ' +
        '       Insurance_VEI_Type__c, Insurance_LPI_Income__c, Insurance_LPI_Retail_Price__c, Insurance_LPI_Type__c, ' +
        '       Risk_Fee__c, Rate_Options__c, Registration_Fee__c, Sale_Backs_Purchased__c, Extra_Label_1__c, ' +
        '       Extra_Label_2__c, Extra_Label_3__c, Extra_Label_4__c, Extra_Value_1__c, Extra_Value_2__c, ' +
        '       Extra_Value_3__c, Extra_Value_4__c, Opportunity__c, Net_Deposit__c, App_Insurance_Quote__c, ' +
        '       Insurance_Input_Mode__c, Insurance_NWC_Acceptance__c, Insurance_NWC_Cost__c, Insurance_NWC_Plan__c, Insurance_NWC_Term__c, ' +
        '       Insurance_MV_Acceptance__c, Insurance_GAP_Acceptance__c, Insurance_TAI_Acceptance__c, Insurance_LTI_Acceptance__c, ' +
        '       Insurance_Warranty_Acceptance__c, Insurance_Choice_Date__c, Insurance_Customer_Choice__c, ' +
        '       Net_Deposit_Percentage__c, Presentation_Email_Date__c, Has_Warranty__c, Vehicle_Condition__c , ' +
        '       LibertyServ_AppNumber__c, LibertyServ_ResponseContent__c, LibertyServ_Status__c, LibertyServ_Last_Response_Application__c,  ' +
        '       PepperAPI_Application_Id__c , PepperAPI_Last_Response_App__c , PepperAPI_Response_Message__c ,  ' +
        '       Insurance_AIC_Acceptance__c, Insurance_VEI_Acceptance__c, Insurance_LPI_Acceptance__c, Vedascore__c, ' +
        '       Insurance_AIC_Type__c, Force_Calculation__c, Enquiries__c, Bankrupt__c, Residency__c, Risk_Grade__c, ' +
        '       Insurance_NWC_AWD4WD__c, Insurance_NWC_LuxuryCar__c, Insurance_NWC_TypeP__c, Insurance_NWC_Is_Manually_Value__c, ' +
        '       Rate_Type__c, Manual_Max_Rate__c, Condition__c, Green_Car__c, HasDefaults__c, Loan_Purpose__c, ' +
        '       Pay_Day_Enquiries__c, Has_Imports__c, Credit_Score__c, Bonus_Commission__c, Commission_Type__c, ' + 
        '       App_Fee_Manual_Input__c, DOF_Manual_Input__c, Money3_Broker_Reference_Id__c, Money3_Loan_Id__c, ' +
        '       Money3_Last_Response_App__c, LenderAPIResponse__c, Purpose_Type__c, Lease_Agreement__c, Insurance_NWC_Qualifying__c, ' +
        '       Insurance_MV_Options__c, Insurance_Shortfall_Options__c, Insurance_LPI_Options__c, Insurance_Warranty_Options__c, ' +
        '       Insurance_Tyre_Whell_Options__c, Insurance_AIC_PayType__c, Insurance_AIC_Term__c, Insurance_GAP_PayType__c, ' + 
        '       Insurance_GAP_Term__c, Insurance_NWC_PayType__c, Insurance_Warranty_PayType__c, Insurance_Warranty_Term__c, GST__c, ABN__c ' +
        'FROM Application_Quoting__c ';
    
    public static void attachPdfFile(String oppId, String prefixName, PageReference pdf) {
        attachPdfFile(oppId, prefixName, pdf, false);
    }
    
    public static void attachPdfFile(String oppId, String prefixName, PageReference pdf, boolean saveInCloud) {
        Blob body;
        try {
            body = Test.isRunningTest()? Blob.valueOf('a') : pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error occurred in generating the PDF file.');
        }   
        attachPdfFile(oppId, prefixName, body, saveInCloud);
    }
    
    public static void attachPdfFile(String oppId, String prefixName, Blob body, boolean saveInCloud) {
        String fileName = null;
        if (saveInCloud) {
            fileName = prefixName + '_' + oppId + '_' + getDateTimeExtensionFileName() + '.pdf';
            String docType = getDocumentTypeFromPrefixName(prefixName);
            CloudRequiredDocument d = new CloudRequiredDocument(docType);
            d.blobFile = body;
            d.contentType = 'application/pdf';
            d.docName = fileName;
            d.fileName = fileName;
            d.oppId = oppId;
            CloudDocsHelper.saveToS3(d);
        } /* else {
            fileName = prefixName + '_' + oppId + '_' + (getTotalAttachments(oppId, prefixName)+1) + '.pdf';
            Attachment attachCalc = new Attachment();
            attachCalc.Body = body;
            attachCalc.Name = fileName;
            attachCalc.IsPrivate = false;
            attachCalc.ParentId = oppId;
            insert attachCalc;
        } */
    }
    
    public static String getDocumentTypeFromPrefixName(String prefixName) {
        String r = 'Quoting Calculation';
        if (prefixName != null) {
            if (prefixName.startsWith('Servicing_Cal')) {
                r = 'Servicing Calculation';
            } else if (prefixName.startsWith('YTD_')) {
                r = 'YTD Calculation';
            } else if (prefixName.startsWith('AssetDetails_')) {
                r = 'Asset Detail - LTV';
            }
            
            if (prefixName.contains('PRE_APPROVAL')) {
                if (prefixName.contains('_AMENDMENT')) {
                    r += ' (Amendment)';
                } else {
                    r += ' (Pre-approval)';
                }
            } else if (prefixName.contains('FORMAL_APPROVAL')) {
                r += ' (Formal Approval)';
            } else if (prefixName.contains('_AMENDMENT')) {
                r += ' (Amendment)';
            }
            
            if (prefixName.startsWith('App_PRE_APPROVAL')) {
                r = 'Application Form (Pre-approval)';
            }
            
            if (prefixName.startsWith('PreliminaryAssessment')) {
                r = 'Preliminary Assessment';
            }
            
        }
        return r;
    }
    
    public static Integer getTotalAttachments(String oppId, String prefixName) {
        String filter = '%' + prefixName + '%';
        List<attachment> existingAttach = 
            [Select id,name,description from attachment 
             where parentID = :oppId and Name like :filter];
        if (existingAttach != null) {
            return existingAttach.size();
        }
        return 0;
    }
    
    public static void removePreviousInsurances(String oppid) {
        try {
            delete [Select ID From Product__c 
                    where Opportunity_Name__r.id = :oppid 
                    and RecordType.name = 'Insurance'];
        } catch (Exception ignore) {}
    }
    
    private static String getDateTimeExtensionFileName() {
        return Datetime.now().format('yyyyMMddHHmmss');
    }
    
    public static String attachFile(String oppId, String prefixName, Blob body, String contentType, boolean saveInCloud) {
        // insert PDF file into the Opp
        String r = null;
        String fileName = null;
        if (saveInCloud) {
            fileName = prefixName + '_' + oppId + '_' + getDateTimeExtensionFileName() + '.pdf';
            String docType = getDocumentTypeFromPrefixName(prefixName);
            CloudRequiredDocument d = new CloudRequiredDocument(docType);
            d.blobFile = body;
            d.contentType = contentType;
            d.docName = fileName;
            d.fileName = fileName;
            d.oppId = oppId;
            CloudDocsHelper.saveToS3(d);
        } else {
            if (prefixName.startsWith('App_') ||
                prefixName.startsWith('LeadServicingCal_')) {
                    fileName = prefixName + '_' + oppId + '_' + (getTotalAttachments(oppId, prefixName)+1) + '.pdf';
                    Attachment attachCalc = new Attachment();
                    attachCalc.Body = body;
                    attachCalc.Name = fileName;
                    attachCalc.IsPrivate = false;
                    attachCalc.ParentId = oppId;
                    insert attachCalc;
                    r = String.valueOf(attachCalc.Id);
                }
        }
        return r;
    }
    
    //Calculator Selectors
    
    public static List<SelectOption> getSelectStateOptionsOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('ACT', 'ACT'));
        r.add(new SelectOption ('NSW', 'NSW'));
        r.add(new SelectOption ('NT', 'NT'));
        r.add(new SelectOption ('QLD', 'QLD'));
        r.add(new SelectOption ('SA', 'SA'));
        r.add(new SelectOption ('TAS', 'TAS'));
        r.add(new SelectOption ('VIC', 'VIC'));
        r.add(new SelectOption ('WA', 'WA'));
        return r;
    }
    
    public static List<SelectOption> getSelectYesNoOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Y', 'Yes'));
        r.add(new SelectOption ('N', 'No'));
        return r;
    }
    
    public static List<SelectOption> getSelectVehicleGroupTypeOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('1', 'Group 1 Vehicles'));
        r.add(new SelectOption ('2', 'Group 2 Vehicles'));
        r.add(new SelectOption ('3', 'Group 3 Vehicles'));
        r.add(new SelectOption ('4', 'Unacceptable Vehicles'));
        return r;
    }
    
    public static List<SelectOption> getSelectGabLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Premier Cover 1', 'Premier Cover 1'));
        r.add(new SelectOption ('Premier Cover 2', 'Premier Cover 2'));
        r.add(new SelectOption ('Premier Cover 3', 'Premier Cover 3'));
        r.add(new SelectOption ('Classic Cover 1', 'Classic Cover 1'));
        r.add(new SelectOption ('Classic Cover 2', 'Classic Cover 2'));
        r.add(new SelectOption ('Classic Cover 3', 'Classic Cover 3'));
        r.add(new SelectOption ('Classic Cover 4', 'Classic Cover 4'));
        return r;
    }
    
    public static List<SelectOption> getSelectWarrantyLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Platinum - 12 months', 'Platinum - 12 months'));
        r.add(new SelectOption ('Platinum - 24 months', 'Platinum - 24 months'));
        r.add(new SelectOption ('Platinum - 36 months', 'Platinum - 36 months'));
        r.add(new SelectOption ('Extra Time', 'Extra Time'));
        r.add(new SelectOption ('Diamond - 12 months', 'Diamond - 12 months'));
        r.add(new SelectOption ('Diamond - 24 months', 'Diamond - 24 months'));
        r.add(new SelectOption ('Diamond - 36 months', 'Diamond - 36 months'));
        r.add(new SelectOption ('Gold - 12 months', 'Gold - 12 months'));
        r.add(new SelectOption ('Gold - 24 months', 'Gold - 24 months'));
        r.add(new SelectOption ('Gold - 36 months', 'Gold - 36 months'));
        r.add(new SelectOption ('Tyre and Wheel - 12 months', 'Tyre and Wheel - 12 months'));
        r.add(new SelectOption ('Tyre and Wheel - 24 months', 'Tyre and Wheel - 24 months'));
        r.add(new SelectOption ('Tyre and Wheel - 36 months', 'Tyre and Wheel - 36 months'));
        return r;
    }
    
    public static List<SelectOption> getSelectLtiLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Platinum Cover 1', 'Platinum Cover 1'));
        r.add(new SelectOption ('Platinum Cover 2', 'Platinum Cover 2'));
        r.add(new SelectOption ('Platinum Cover 3', 'Platinum Cover 3'));
        r.add(new SelectOption ('Gold Cover 1', 'Gold Cover 1'));
        r.add(new SelectOption ('Gold Cover 2', 'Gold Cover 2'));
        r.add(new SelectOption ('Silver Cover 1', 'Silver Cover 1'));
        r.add(new SelectOption ('Silver Cover 2', 'Silver Cover 2'));
        r.add(new SelectOption ('Silver Cover 3 on-cost', 'Silver Cover 3 on-cost'));
        return r;
    }
    
    public static List<SelectOption> getSelectTruckGapLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Cover 1', 'Cover 1'));
        r.add(new SelectOption ('Cover 2', 'Cover 2'));
        return r;
    }
    
    public static List<SelectOption> getSelectTaiLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('TAI Cover 1 ($5,000)', 'TAI Cover 1 ($5,000)'));
        r.add(new SelectOption ('TAI Cover 2 ($4,000)', 'TAI Cover 2 ($4,000)'));
        r.add(new SelectOption ('TAI Cover 3 ($3,000)', 'TAI Cover 3 ($3,000)'));
        r.add(new SelectOption ('RTI ($7,000)', 'RTI ($7,000)'));
        r.add(new SelectOption ('RTI ($10,000)', 'RTI ($10,000)'));
        r.add(new SelectOption ('RTI ($15,000)', 'RTI ($15,000)'));
        r.add(new SelectOption ('RTI ($20,000)', 'RTI ($20,000)'));
        r.add(new SelectOption ('RTI ($25,000)', 'RTI ($25,000)'));
        r.add(new SelectOption ('RTI ($30,000)', 'RTI ($30,000)'));
        return r;
    }
    
    public static List<SelectOption> getSelectMvLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Swan', 'Swan'));
        r.add(new SelectOption ('Club Marine', 'Club Marine'));
        r.add(new SelectOption ('AIC/Eric', 'AIC/Eric'));
        return r;
    }
    
    public static List<SelectOption> getSelectProductLoanLevelOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Consumer Loan', 'Consumer Loan'));
        r.add(new SelectOption ('Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Full-Doc'));
        r.add(new SelectOption ('Car Lease-Full-Doc', 'Car Lease-Full-Doc'));
        r.add(new SelectOption ('Chattel Mortgage-Low-Doc', 'Chattel Mortgage-Low-Doc'));
        r.add(new SelectOption ('Car Lease-Low-Doc', 'Car Lease-Low-Doc'));
        r.add(new SelectOption ('Re-Finance', 'Re-Finance'));
        r.add(new SelectOption ('Sale & Lease Back', 'Sale & Lease Back'));
        return r;
    }
    
    public static List<SelectOption> getSelectPaymentTypeOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('Arrears', 'Arrears'));
        r.add(new SelectOption ('Advance', 'Advance'));
        return r;
    }
    
    public static List<SelectOption> getLoanTypeOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('Purchase', 'Purchase'));
        r.add(new SelectOption ('Refinance', 'Refinance'));
        r.add(new SelectOption ('Sale & Lease Back', 'Sale & Lease Back'));
        return r;
    }

    public static List<SelectOption> getLoanTypeOptionsNoLease() {
      List<SelectOption> r = new List<SelectOption> ();
      r.add(new SelectOption ('Purchase', 'Purchase'));
      r.add(new SelectOption ('Refinance', 'Refinance'));
      return r;
    }
    
    public static List<SelectOption> getLoanProductOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('Consumer Loan', 'Consumer Loan'));
        r.add(new SelectOption ('Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Full-Doc'));
        r.add(new SelectOption ('Chattel Mortgage-Low-Doc', 'Chattel Mortgage-Low-Doc'));
        r.add(new SelectOption ('Car Lease-Full-Doc', 'Car Lease-Full-Doc'));
        r.add(new SelectOption ('Car Lease-Low-Doc', 'Car Lease-Low-Doc'));
        return r;
    }
    
    public static List<SelectOption> getLoanProductOptionsConsumer() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('Consumer Loan', 'Consumer Loan'));
        return r;
    }
    
    public static List<SelectOption> getLoanProductOptionsCommercial() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Full-Doc'));
        r.add(new SelectOption ('Chattel Mortgage-Low-Doc', 'Chattel Mortgage-Low-Doc'));
        r.add(new SelectOption ('Car Lease-Full-Doc', 'Car Lease-Full-Doc'));
        r.add(new SelectOption ('Car Lease-Low-Doc', 'Car Lease-Low-Doc'));
        return r;
    }
    
    public static List<SelectOption> getProductGoodsTypeOptions(String loanProduct){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        try{
            List<Message_Codes__c> codes = Utilities.getListMessageCodes(MacquarieConstants.DOMAIN_ASSET_TYPE);
            for (Message_Codes__c mc: codes){
                if (loanProduct.startsWith('Consumer') && !mc.code__c.contains('MOTOV') && !mc.code__c.contains('LIFES')){
                    continue;
                }
                r.add(new SelectOption (mc.code__c, mc.description__c));
            }
        }catch (Exception ex){
            ex.getStackTraceString();
            System.debug('Product goods Type error:  ' + ex.getMessage());
        }
        return r;
    }
    
    public static List<SelectOption> getProductGoodsSubTypeOptions(String loanType, String goodsType){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        try{
            Message_Codes__c product = Utilities.getMessageCode_Description(loanType);
            String domain = 'CM'+ '-' + goodsType;
            if (product != null){
                domain = product.code__c + '-' + goodsType;
            }
            List<Message_Codes__c> codes =  Utilities.getListMessageCodes(domain);
            for (Message_Codes__c mc: codes){
                r.add(new SelectOption (mc.code__c, mc.description__c));
            }
        }catch (Exception ex){
            ex.getStackTraceString();
            System.debug('Product goods SubType error:  ' + ex.getMessage());
        }
        return r;
    }
    
    public static List<SelectOption> getLoanFrequenciesOptions(String loanProduct){
        List<SelectOption> r = new List<SelectOption>();
        List<Message_Codes__c> codes = Utilities.getListMessageCodes(MacquarieConstants.LOAN_FREQUENCY);
        r.add(new SelectOption ('', '--None--'));
        if (String.isNotBlank(loanProduct)) {
            for (Message_Codes__c mc: codes){
                if (loanProduct.startsWith('Chattel') && !mc.code__c.contains('MONT')){
                    continue;
                }
                r.add(new SelectOption (mc.code__c, mc.description__c));
            }
        }
        return r;
    }
    
    public static Application_Quoting__c getApplicationQuoting(Id objId) {
        return getApplicationQuoting(null, objId);
    }
    
    public static Application_Quoting__c getApplicationQuoting(Id oppId, Id appId) {
        List<Application_Quoting__c> r = null;
        String wh = null;
        if (appId != null && oppId == null) {
            wh = 'WHERE Application__c = :appId ';
        } else if (oppId != null) {
            wh = 'WHERE Opportunity__c = :oppId ';
        }
        
        if (String.isNotBlank(wh)) {
            r = Database.query(APP_QUOTING_SOQL + wh + 'ORDER BY LastModifiedDate DESC');
        }
        
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    public static Application_Quoting__c getApplicationQuotingIdByAppId(Id appId) {
        Application_Quoting__c r = null;
        List<Application_Quoting__c> d = [SELECT Id, Opportunity__c FROM Application_Quoting__c 
                                          WHERE Application__c = :appId 
                                          ORDER BY LastModifiedDate DESC];
        if (!d.isEmpty()) {
            r = d.get(0);
        }
        return r;
    }
    
    public static Application_Quoting__c getApplicationQuotingById(Id quotingId) {
        List<Application_Quoting__c> r = null;
        String wh = 'WHERE Id = :quotingId ';
        if (String.isNotBlank(wh)) {
            r = Database.query(APP_QUOTING_SOQL + wh);
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    public static void saveApplicationQuoting(Application_Quoting__c obj) {
        Boolean isUpdateApp = false;
        if (obj.Id == null) {
          isUpdateApp = true;
        }
        try {
          upsert obj;
        } catch (Exception e) {
          String errMsg = e.getMessage();
          if (errMsg.contains('UNABLE_TO_LOCK_ROW')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quoting tools error. Some data could not be saved properly. Please reload this page and try to save your data again.'));
          }
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        // if (isUpdateApp && obj.Application__c != null) {
        //     try {
        //         Application__c app = [SELECT Id, Application_Quoting__c FROM Application__c WHERE Id = :obj.Application__c];
        //         app.Application_Quoting__c = obj.Id;
        //         update app;
        //     } catch (Exception e) {
        //         System.debug('Application Form cannot be found it');
        //     }
        // }
    }
    
    public static Decimal getNationalWarrantyCost(String plan, String term) {
        Decimal r = 0.0;
        if (String.isNotBlank(plan) && String.isNotBlank(term)) {
            List<NationalWarrantyPriceList__c> d = [
                SELECT Cost__c FROM NationalWarrantyPriceList__c 
                WHERE Plan__c = :plan AND Term__c = :term
            ];
            if (!d.isEmpty()) {
                r = d.get(0).Cost__c;
            }
        }
        return r;
    }
    
    public static Liberty_VEI_Setting__c getLibertyVEISetting(String state, String option) {
        if (String.isBlank(state) || String.isBlank(option)) {
            return null;
        }
        String opt = 'Option 3';
        if (option.startsWith('Option 1')) {
          opt = 'Option 1';
        } else if (option.startsWith('Option 2')) {
          opt = 'Option 2';
        }
        if (libVeiSettings == null || libVeiSettings.isEmpty()) {
            //Load settings
            libVeiSettings = new Map<String, Map<String, Liberty_VEI_Setting__c>>();
            for (Liberty_VEI_Setting__c a : Liberty_VEI_Setting__c.getAll().values()) {
                Map<String, Liberty_VEI_Setting__c> x = libVeiSettings.get(a.State__c);
                if (x == null) {
                    x = new Map<String, Liberty_VEI_Setting__c>();
                    libVeiSettings.put(a.State__c, x);
                }
                x.put(a.Cover_Option__c, a);
            }
        }
        Liberty_VEI_Setting__c r = null;
        Map<String, Liberty_VEI_Setting__c> d = libVeiSettings.get(state);
        if (d != null && !d.isEmpty()) {
            r = d.get(opt);
        }
        return r;
    }
    
    public static StateStampDuties__c getStateStampDuty(String name) {
        StateStampDuties__c r = null;
        for (StateStampDuties__c a : StateStampDuties__c.getAll().values()) {
            if (a.Name.equals(name)) {
                r = a;
            }
        }
        return r;
    }
    
    public static Liberty_LPI_Setting__c getLibertyLPISetting(String state, String cover) {
        Liberty_LPI_Setting__c r = null;
        for (Liberty_LPI_Setting__c a : Liberty_LPI_Setting__c.getAll().values()) {
            if (a.State__c.equals(state) && a.Cover_Option__c.equals(cover)) {
                r = a;
            }
        }
        return r;
    }
    
    public static Map<String, Liberty_LPI_Setting__c> getLibertyLPIMap(String state) {
        Map<String, Liberty_LPI_Setting__c> r = new Map<String, Liberty_LPI_Setting__c>();
        for (Liberty_LPI_Setting__c a : Liberty_LPI_Setting__c.getAll().values()) {
            if (a.State__c.equals(state)) {
                r.put(a.Cover_Option__c, a);
            }
        }
        return r;
    }
    
    public static List<SelectOption> getLibertyLPIOptions(String state) {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        List<Liberty_LPI_Setting__c> d = Liberty_LPI_Setting__c.getAll().values();
        d.sort(); 
        for (Liberty_LPI_Setting__c a : d) {
            if (a.State__c.equals(state)) {
                r.add(new SelectOption(a.Cover_Option__c,a.Cover_Option__c));
            }
        }
        return r;
    }
    
    
    public static Boolean validateInsuranceProduct(String lender) {
        Boolean r = false;
        if (!String.isBlank(lender)) {
            List<Lenders__c> d = [SELECT Validate_Formal_Approval__c FROM Lenders__c 
                                  WHERE lender__c = :lender AND 
                                  Validate_Formal_Approval__c = true];
            if (!d.isEmpty()) {
                r = true;
            }
        }
        return r;
    }
    
    public static Decimal getNowFinanceMaxDOF(Decimal naf) {
        Decimal r = 0.0;
        List<NowFinanceDOF__mdt> m = [SELECT NAF_Start__c, NAF_End__c, DOF__c 
                                      FROM NowFinanceDOF__mdt 
                                      WHERE NAF_Start__c <= :naf AND NAF_End__c >= :naf
                                      ORDER BY NamespacePrefix];
        System.debug('NAF: ' + naf + '|' + m.size());
        if (!m.isEmpty()) {
            r = m.get(0).DOF__c;
        }
        return r;
    }
    
    public static Decimal getRateSetterPLAppfee(Decimal amount, Integer term) {
        Decimal r = 0.0;
        List<RateSetterPLAppfee__c> m = [SELECT X6__c, X9__c, X12__c, X18__c, X24__c, X36__c, X48__c, X60__c 
                                         FROM RateSetterPLAppfee__c 
                                         WHERE Min__c <= :amount AND Max__c >= :amount];
        if (!m.isEmpty()) {
            if (term == 6) {
                r = m.get(0).X6__c;    
            } else if (term == 9) {
                r = m.get(0).X9__c;    
            } else if (term == 12) {
                r = m.get(0).X12__c;    
            } else if (term == 18) {
                r = m.get(0).X18__c;    
            } else if (term == 24) {
                r = m.get(0).X24__c;    
            } else if (term == 36) {
                r = m.get(0).X36__c;    
            } else if (term == 48) {
                r = m.get(0).X48__c;    
            } else if (term == 60) {
                r = m.get(0).X60__c;    
            }            
        }
        return r;
    }
    
    public static Decimal getRateSetterPLDOF(Decimal amount, Integer term) {
        Decimal r = 0.0;
        List<RateSetterPLDOF__c> d = [SELECT Min__c, Max__c, X6__c, X9__c, X12__c, X18__c, X24__c, X36__c, X48__c, X60__c 
                                      FROM RateSetterPLDOF__c];
        d.sort();
        System.debug('Amount: ' + amount + '| term: ' + term);
        for (Integer i = 0;i < d.size();i++) {
            RateSetterPLDOF__c m = d[i];
            Integer nextIdx = i+1;
            if (nextIdx >= d.size()) {
                nextIdx = i;
            }
            Decimal nextDof = 0.0;
            if (amount >= m.Min__c && amount <= m.Max__c) {
                if (term == 6) {
                    r = m.X6__c;
                    nextDof = d[nextIdx].X6__c;
                } else if (term == 9) {
                    r = m.X9__c;    
                    nextDof = d[nextIdx].X9__c;
                } else if (term == 12) {
                    r = m.X12__c;    
                    nextDof = d[nextIdx].X12__c;
                } else if (term == 18) {
                    r = m.X18__c;
                    nextDof = d[nextIdx].X18__c;
                } else if (term == 24) {
                    r = m.X24__c;    
                    nextDof = d[nextIdx].X24__c;
                } else if (term == 36) {
                    r = m.X36__c;    
                    nextDof = d[nextIdx].X36__c;
                } else if (term == 48) {
                    r = m.X48__c;    
                    nextDof = d[nextIdx].X48__c;
                } else if (term == 60) {
                    r = m.X60__c;    
                    nextDof = d[nextIdx].X60__c;
                }
                if ((amount+nextDof) > m.Max__c) {
                    r = nextDof;
                }
            }
        }
        return r;
    }
    
    public static Decimal getRateSetterPLMonthlyfee(Decimal amount, Integer term) {
        Decimal r = 0.0;
        List<RateSetterPLMonthlyFee__c> m = [SELECT X6__c, X9__c, X12__c, X18__c, X24__c, X36__c, X48__c, X60__c 
                                             FROM RateSetterPLMonthlyFee__c 
                                             WHERE Min__c <= :amount AND Max__c >= :amount];
        if (!m.isEmpty()) {
            if (term == 6) {
                r = m.get(0).X6__c;    
            } else if (term == 9) {
                r = m.get(0).X9__c;    
            } else if (term == 12) {
                r = m.get(0).X12__c;    
            } else if (term == 18) {
                r = m.get(0).X18__c;    
            } else if (term == 24) {
                r = m.get(0).X24__c;    
            } else if (term == 36) {
                r = m.get(0).X36__c;    
            } else if (term == 48) {
                r = m.get(0).X48__c;    
            } else if (term == 60) {
                r = m.get(0).X60__c;    
            }            
        }
        return r;
    }
    
    public static Decimal getMonthlyRepayment(Id oppId) {
        Decimal r = 0.00;
        List<Application_Quoting__c> d = [SELECT Id, Repayment_Monthly__c FROM Application_Quoting__c 
                                          WHERE Opportunity__c = :oppId 
                                          ORDER BY LastModifiedDate DESC];
        if (!d.isEmpty()) {
            r = d.get(0).Repayment_Monthly__c;
        }
        return r;
    }
    
    public static void updateLTV(Id oppId, String ltv) {
        if (String.isNotBlank(ltv)) {
            List<Application_Quoting__c> d = [SELECT Id, LTV__c FROM Application_Quoting__c 
                                              WHERE Opportunity__c = :oppId 
                                              ORDER BY LastModifiedDate DESC];
            if (!d.isEmpty()) {
                d.get(0).LTV__c = ltv;
                update d;
            }
        }
    }
    
    public static Boolean allowInsuranceActions(Boolean includeErrorMsg) {
      // Boolean r = false;
      // String profileName = SOQLSingletonQueries.getCurrentUserProfileName();
      // if ('System Admin'.equals(profileName) || SOQLSingletonQueries.recs().isBrokerPartnerUser) {
      //     r = true;
      // } else if (includeErrorMsg) {
      //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Action not allowed, customer decision should not be changed'));
      // }
      // return r;
      return true;
    }
    
    public static List<SelectOption> getFinanceOneConsumerOptions() {
        return getFinanceOneOptions('Consumer');
    }
    
    public static List<SelectOption> getFinanceOneCommercialOptions() {
        // List<SelectOption> r = getFinanceOneConsumerOptions();
        // if (!r.isEmpty() && r.size() > 1) {
        //     r.remove(r.size()-1);
        // }
        // return r;
        return getFinanceOneOptions('Commercial');       // Lelo     2020-05-08
    }
    
    private static List<SelectOption> getFinanceOneOptions(String optionType) {
        initFinanceOneOptions();
        List<SelectOption> r = new List<SelectOption>();
        Map<String, FinanceOneRates__c> d = finance1Rates.get(optionType);
        if (d != null) {
            for (String k : d.keySet()) {
                r.add(new SelectOption(k, k));
            }
        }
        return r;
    }
    
    private static void initFinanceOneOptions() {
        if (finance1Rates == null) {
            finance1Rates = new Map<String, Map<String, FinanceOneRates__c>>();
            List<FinanceOneRates__c> d = FinanceOneRates__c.getAll().values();
            d.sort();
            for (FinanceOneRates__c a : d) {
                Map<String, FinanceOneRates__c> r = finance1Rates.get(a.Category__c);
                if (r == null) {
                    r = new Map<String, FinanceOneRates__c>();
                    finance1Rates.put(a.Category__c, r);
                }
                r.put(a.Product__c, a);
            }
        }
    }
    
    public static Boolean isForcedCalculation(Id oppId) {
        if (oppid == null) return false;
        List<Application_Quoting__c> d = [SELECT Force_Calculation__c FROM Application_Quoting__c WHERE Opportunity__c = :oppId ORDER BY LastModifiedDate DESC];
        if (!d.isEmpty()) {
            return d.get(0).Force_Calculation__c;
        }
        return false;
    }
    
    //Yohan Villamizar 2019-07-29
    public static Product__c updateProduct(Custom_Opportunity__c Opp){
        Product__c updateProduct = null;
        if(Opp.Loan_Product__c != null){
            updateProduct = [Select id,Loan_Purpose__c,Quoting_Source__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,
                             Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c
                            ];
        }
        return updateProduct;
    }

  // Lelo             2020-08-13
  public static List<SelectOption> getVehicleYears(Integer count) {
    return getVehicleYears(count, false);
  }

  public static List<SelectOption> getVehicleYears(Integer count, Boolean isMandatory) {
    List<SelectOption> r = new List<SelectOption>();
    if (!isMandatory) {
      r.add(new SelectOption('', '--None--'));
    }
    if (count != null && count > 0) {
      Integer cy = Date.today().year();
      for (Integer i = 0; i <= count; i++) {
        Integer v = cy - i;
        r.add(new SelectOption(String.valueOf(v), String.valueOf(v)));
      }
    }
    return r;
  }

  // Partner Portal 
  public static String getPartnerUrlCalc(Id oppId, String oppName, String calc) {
    String url = Parameters_Service__c.getInstance(PARAM_PARTNER_PORTAL_URL_BASE).value__c;
    String name = EncodingUtil.urlEncode((String.isNotBlank(oppName)? oppName: ''), 'UTF-8');
    url += '/sales-tools/quoting-tools/' + calc + '?';
    if (oppId != null) {
      url += 'recordId=' + oppId + '&';
    }
    url += 'oppName=' + name;
    return url;
  }

  public static LenderAPIResponse__c getLenderAPIResponse(Id respId) {
    if (respId != null) {
      List<LenderAPIResponse__c> d = [
        SELECT Application_ID__c, Name, Status__c, CreatedDate
        FROM LenderAPIResponse__c
        WHERE Id = :respId
      ];
      return d.isEmpty()? null : d.get(0);
    }
    return null;
  }

}