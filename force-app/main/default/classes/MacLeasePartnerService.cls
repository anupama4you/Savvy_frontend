public class MacLeasePartnerService {
             
    //String access_token, scope, grant_type, consumer_key;
    String scope, grant_type, consumer_key;
    String endPointAuthentication, endPointQuote, endPointApplication, endPointDocumentUpload;
    String SOLVE_CUSTOMER_RATE = 'SOLVE_CUSTOMER_RATE';
    String SOLVE_WITH_BASE_RATE = 'SOLVE_WITH_BASE_RATE';
    String SOLVE_BROKERAGE_AMOUNT = 'SOLVE_BROKERAGE_AMOUNT';
    String INSURER = 'Eric Insurance';
    
    String CONSUMER_LOAN = 'CONSUMER_LOAN';
    String CHATTEL_MORTGAGE = 'CHATTEL_MORTGAGE';
  
    String RESIDENTIAL_STATUS_OWN_MORTGAGED = 'OWN_MORTGAGED';
    String RESIDENTIAL_STATUS_RENTING = 'RENTING';
    String MONTHLY = 'Monthly';
   
    Integer scaleDecimal = 2;
    
    public MacLeasePartnerService(){
        loadSettings();
    }
    
    private void loadSettings(){
        List<Maclease_Partner_Service_Settings__c> mcqSettings;
        mcqSettings = Maclease_Partner_Service_Settings__c.getAll().values();
        //access_token = Maclease_Partner_Service_Settings__c.getValues('Partner_Access_Token').Value__c;
        scope = Maclease_Partner_Service_Settings__c.getValues('Authentication_Scope').Value__c;
        grant_type = Maclease_Partner_Service_Settings__c.getValues('Authentication_Grant_Type').Value__c;
        consumer_key = Maclease_Partner_Service_Settings__c.getValues('Consumer_Key').Value__c;
        
        endPointAuthentication = Maclease_Partner_Service_Settings__c.getValues('Authentication_Service').EndPoint__c;
        endPointQuote = Maclease_Partner_Service_Settings__c.getValues('Quote_Service').EndPoint__c;
        endPointApplication = Maclease_Partner_Service_Settings__c.getValues('Application_submission_service').EndPoint__c;
        endPointDocumentUpload = Maclease_Partner_Service_Settings__c.getValues('DocUpload_Service').EndPoint__c;
    }
    
    private void validateResponse (HttpResponse resp, MacquarieManager mcqManager){
        mcqManager.isError = false;
		mcqManager.message = '@!Ok';
        if (resp != null){
            mcqManager.responseStatus = resp.getStatusCode();
            mcqManager.responseMessage = resp.getBody();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'from Macquarie: [' + resp.getBody() + ']'));
            if (mcqManager.responseStatus != MacquarieConstants.STATUS_OK){
                mcqManager.isError = true;
                mcqManager.parseErrorResponse(mcqManager.responseMessage);
                mcqManager.message = '[' + mcqManager.responseStatus + ']';
            }
        }else{
            mcqManager.isError = true;
            mcqManager.message = '@Please, check response service';
        }
        System.debug('@validateResponse: -[' + mcqManager.message + ']');
    }
    
    public MacquarieManager authentication(MacquarieManager mcqManager, String consumerKey){
        System.debug('+++User Authentication: ' + consumerKey);
        if (consumerKey == null){
            throw new MacLeasePartnerException ('[Authentication] - Please check Macquarie User before submit. User not authorized: {' + consumerKey + '}');
        }
        ConnectionRESTWs conn;
        String authorizationHeader = 'Basic ' + consumerKey;
        String body = '';
        conn = new ConnectionRESTWs(endPointAuthentication, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
        Map<String, String> requestQuery = new Map<String, String>();
        requestQuery.put('scope', scope);
        requestQuery.put('grant_type', grant_type);
        
        Map<String, String> requestHeader = new Map<String, String>();
        requestHeader.put(MacquarieConstants.AUTHORIZATION, authorizationHeader);
        HttpResponse resp;
        try{
            resp = conn.connectionServiceHttpResponse(requestHeader, requestQuery, body);
        }catch (GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
        }
        
        validateResponse (resp, mcqManager);
        if (!mcqManager.isError){
            try{
                mcqManager.parseAuthentication(mcqManager.responseMessage);
            }catch (Exception ex){
                mcqManager.isError = true;
                mcqManager.message = ex.getMessage();
                throw new MacLeasePartnerException ('[Authentication]' + mcqManager.message, ex);
            }
        }else{
            throw new MacLeasePartnerException (mcqManager.message);
        }
        return mcqManager;
       
    }
    
    private Lender_Login__c getMacquarieSender(String mcqUserId){
        List<Lender_Login__c> lendersLogin = [SELECT Id, User_Name__c, Access_Token__c , Consumer_Key__c 
						FROM Lender_Login__c where id = :mcqUserId];
        if (lendersLogin != null && lendersLogin.size() > 0){
            return lendersLogin.get(0);
        }
        throw new MacLeasePartnerException ('Missing Macquarie user. Please select one.');
    }
    
    public void requestQuoteTest(MacquarieManager mcqManager, Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan, String mcqUserId ){     
        String body = getQuote(opp, totalInsurance, isConsumerLoan, null).serialize(true); 
        System.debug('Debug Quote (Test):::********************************************************** - I');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'to Macquarie (Test): [' + body + ']'));
    }
    
    public MacquarieManager requestQuote(MacquarieManager mcqManager, Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan, String mcqUserId ){     
        ConnectionRESTWs conn;
        Lender_Login__c lenderLogin = getMacquarieSender(mcqUserId);
        String body = getQuote(opp, totalInsurance, isConsumerLoan, null).serialize(true); 
        System.debug('Debug Quote:::********************************************************** - I');
        /*Test line -I
        mcqManager.mcqAuthentication = new McqAuthenticationDTO();
        mcqManager.mcqAuthentication.access_token = 'kEPkwlxBQu4qD8KfH8vfTkwAd6WJ';
        //TEst Line - F*/
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'to Macquarie: [' + body + ']'));
        if (mcqManager.mcqAuthentication == null){
            try{
                authentication(mcqManager, consumer_key);
            }catch (MacLeasePartnerException ex){
                throw new MacLeasePartnerException (mcqManager.message + '[' + ex.getMessage() + ']', ex);
            }
        }
        conn = new ConnectionRESTWs(endPointQuote, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
        HttpResponse resp;
        try{
            resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token, lenderLogin.Access_Token__c), body);
        }catch (GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
        }
        validateResponse (resp, mcqManager);
        if (mcqManager.isError){
            if (mcqManager.responseStatus == MacquarieConstants.STATUS_NOT_AUTHORIZED){
                try{
                    authentication(mcqManager, consumer_key);
                    resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token, lenderLogin.Access_Token__c), body);
            		validateResponse (resp, mcqManager);
                }catch (Exception ex){
                    throw new MacLeasePartnerException (mcqManager.message + '[' + ex.getMessage() + ']', ex);
                }
            }else{
                return mcqManager;
            }
        }else{
            try{
                resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token, lenderLogin.Access_Token__c), body);
            }catch (GenericException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
            }
            validateResponse (resp, mcqManager);
        }
        
        try{
            System.debug('@ *QuoteResponse*. -[' + mcqManager.responseMessage + ']');
            mcqManager.parseQuoteResponse(mcqManager.responseMessage);
        }catch (MacLeasePartnerException ex){
            mcqManager.isError = true;
            mcqManager.message = ex.getMessage();
            throw new MacLeasePartnerException ('[Quote]' + mcqManager.message, ex);
        }
        System.debug('Debug Quote:::********************************************************** - F');        
        return mcqManager;
    }
    
    private Map<String, String> getHeadersServiceWithAuthorized(String authHeader, String access_token){
        String authorizationHeader = MacquarieConstants.BEARER + authHeader;
        Map<String, String> requestHeader = new Map<String, String>();
        requestHeader.put(MacquarieConstants.ACCESS_TOKEN , access_token);
        requestHeader.put(MacquarieConstants.AUTHORIZATION , authorizationHeader);
        return requestHeader;
    }
    
    public void requestCreateApplicationTest(MacquarieManager mcqManager, Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan, String mcqUserId ){   
        String body = '';
        try{
            body = getMcqCreditApplicationRequestDTO(opp, totalInsurance, isConsumerLoan).serialize(true); 
        }catch (Exception ex){
            throw new MacLeasePartnerException ('(Test) Error getMessageMcqCredit: ' + mcqManager.message + ' - ' + ex.getCause(), ex);
        }
         
        String newBody = body.replaceAll('type_m', 'type');
        System.debug(newBody);
        System.debug('(Test) Debug create Application:::********************************************************** - I');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'to Macquarie (Test): [' + newBody + ']'));
    }
    
    public MacquarieManager requestCreateApplication(MacquarieManager mcqManager, Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan, String mcqUserId ){   
        ConnectionRESTWs conn;
        Lender_Login__c lenderLogin = getMacquarieSender(mcqUserId);
        String body = '';
        try{
            body = getMcqCreditApplicationRequestDTO(opp, totalInsurance, isConsumerLoan).serialize(true); 
        }catch (Exception ex){
            throw new MacLeasePartnerException ('Error getMessageMcqCredit: ' + mcqManager.message + ' - ' + ex.getCause(), ex);
        }
         
        String newBody = body.replaceAll('type_m', 'type');
        System.debug(newBody);
        System.debug('Debug create Application:::********************************************************** - I');
        //Test line
        //mcqManager.mcqAuthentication = new McqAuthenticationDTO('kEPkwlxBQu4qD8KfH8vfTkwAd6WJ','',1, '','');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'to Macquarie: [' + newBody + ']'));
        if (mcqManager.mcqAuthentication == null){
            try{
                authentication(mcqManager, consumer_key);
            }catch (MacLeasePartnerException ex){
                throw new MacLeasePartnerException (mcqManager.message + '[' + ex.getMessage() + ']', ex);
            }
        }
        
        conn = new ConnectionRESTWs(endPointApplication, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
        HttpResponse resp;
        try{
            resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token, lenderLogin.Access_Token__c), body.replaceAll('type_m', 'type'));
        }catch (GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
        }
        
        validateResponse (resp, mcqManager);
        if (mcqManager.isError){
            if (mcqManager.responseStatus == MacquarieConstants.STATUS_NOT_AUTHORIZED){
                try{
                    authentication(mcqManager, consumer_key);
                }catch (MacLeasePartnerException ex){
                    throw new MacLeasePartnerException (mcqManager.message + '[' + ex.getMessage() + ']', ex);
                }
                resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token, lenderLogin.Access_Token__c), body);
                validateResponse (resp, mcqManager);
                
            }else{
                return mcqManager;
            }
        }
        try{
			System.debug(LoggingLevel.INFO,'@ *CreateApplicationResponse*. -[' + mcqManager.responseMessage + ']');
            mcqManager.parseCreateApplicationResponse(mcqManager.responseMessage);
        }catch (MacLeasePartnerException ex){
        	mcqManager.isError = true;
            mcqManager.message = ex.getMessage();
            throw new MacLeasePartnerException ('[Application]' + mcqManager.message, ex);
		}
        System.debug('Debug create Application:::********************************************************** - F');
        return mcqManager;
    }
    
    private String purchaseTypeToSaleType(String purchaseType){
        String saleType = 'NO_SALE_TYPE';
        if ('Dealer - Vehicles Direct'.equalsIgnoreCase(purchaseType)){
            saleType = 'DEALER_WITH_ABN';
        }else if ('Dealer'.equalsIgnoreCase(purchaseType)){
            saleType = 'DEALER_WITH_ABN';
        }else if ('Private'.equalsIgnoreCase(purchaseType)){
            saleType = 'PRIVATE_NO_ABN';
        }else if ('Private with ABN'.equalsIgnoreCase(purchaseType)){
            saleType = 'PRIVATE_WITH_ABN';
        }else if ('Refinance'.equalsIgnoreCase(purchaseType)){
            saleType = 'REFINANCE_OTHER';
        }else if ('Sale and Leaseback'.equalsIgnoreCase(purchaseType)){
            saleType = 'SALE_AND_BUYBACK';
        }else if ('Refinance_Macq'.equalsIgnoreCase(purchaseType)){
            saleType = 'REFINANCE_MACQ';
        }
        return saleType.toUpperCase();
    }
  
     private McqQuoteRequestDTO getQuote(Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan, Application_Quoting__c aq){
         McqQuoteRequestDTO quote = new McqQuoteRequestDTO();
         Application_Quoting__c appQuoting;
         if (aq != null){
             appQuoting = aq;
         }else{
             appQuoting = QuotingToolHelper.getApplicationQuoting(opp.Id, opp.Application__c);
         }
         if (appQuoting == null){
             throw new MacLeasePartnerException('Dont exist any Application yet. Please fill all the fields for Quote');
         }
         opp = getCustomOpportunityForQuote(opp);
         quote.asset_cost = NumberUtils.convertDecimalToScale(appQuoting.Vehicle_Price__c, scaleDecimal);
         quote.asset_cost_gst =  NumberUtils.convertDecimalToScale(null, scaleDecimal);
         quote.asset_subtype =  appQuoting.Goods_sub_type__c;
         quote.basis = Utilities.salesforceValueToMessageCode_Description(appQuoting.Payment__c, Utilities.McQ_BASIS);
         quote.origination_fee =  NumberUtils.convertDecimalToScale(appQuoting.DOF__c, scaleDecimal);
         quote.cash_deposit =  NumberUtils.convertDecimalToScale(appQuoting.Deposit__c, scaleDecimal);
         quote.direct_debit =  'YES';
         quote.deferred_months =  null;
         quote.solve_for =  SOLVE_BROKERAGE_AMOUNT;
         
         if (SOLVE_BROKERAGE_AMOUNT.equalsIgnoreCase(quote.solve_for)){
            quote.effective_rate =  NumberUtils.convertDecimalToScale(appQuoting.Client_Rate__c, scaleDecimal);
         }else{
             quote.brokerage_value =  NumberUtils.convertDecimalToScale(appQuoting.Brokerage__c,scaleDecimal);
        	 quote.brokerage_type =  'RATE';
         }
		
         quote.application_fee =  NumberUtils.convertDecimalToScale(appQuoting.Application_Fee__c, scaleDecimal);
         String loanProduct = CONSUMER_LOAN;
         if (!isConsumerLoan){
             loanProduct = CHATTEL_MORTGAGE;
         }
         quote.finance_type =  loanProduct;
         quote.fin_lodge_fee =  'YES';
         //quote.gst_on_insurance =  NumberUtils.convertDecimalToScale(null, scaleDecimal);
         quote.insurance =  NumberUtils.convertDecimalToScale(totalInsurance, scaleDecimal);
         quote.condition =  StringUtils.validateNull(opp.New_Used__c).toUpperCase();
         quote.num_of_assets =  1;
         //quote.own_rate =  NumberUtils.convertDecimalToScale(null, scaleDecimal);
         quote.own_rate =  NumberUtils.convertDecimalToScale(appQuoting.Base_Rate__c, scaleDecimal);
         quote.payment_frequency =  appQuoting.Loan_Frequency__c;
         quote.payout_amount =  NumberUtils.convertDecimalToScale(appQuoting.Payout_On__c, scaleDecimal);
         
         String selectedTypeValue = 'AMOUNT';
         Decimal residualValue = NumberUtils.convertDecimalToScale(appQuoting.Residual_Value__c, scaleDecimal);
         if (appQuoting.Residual_Value_Percentage__c != null && appQuoting.Residual_Value_Percentage__c != 0){
             selectedTypeValue = 'RATE';
             residualValue = appQuoting.Residual_Value_Percentage__c;
         }
         if (residualValue != 0){
             quote.residual_type =  selectedTypeValue;
        	 quote.residual_value = residualValue;
         }
        quote.residual_mode =  null;
        quote.sale_type =  purchaseTypeToSaleType(opp.Purchase_Type__c);
        quote.contract_number =  opp.Contract_Number__c;
        Application__c add = opp.Application__r;
        if (add != null){
             quote.state =  Utilities.salesforceValueToMessageCode_Code(add.Driver_Licence_State_Issue_1__c, Utilities.STATES);
        }
        quote.term =  appQuoting.Term__c;
        quote.trade_in =  NumberUtils.convertDecimalToScale(appQuoting.Trade_In__c , scaleDecimal);
        quote.campaign_code =  null;
        quote.rate_exception =  'NONE';
        quote.base_rate =  NumberUtils.convertDecimalToScale(appQuoting.Base_Rate__c, scaleDecimal); 
        return quote;
    }
       
    private McqCreditApplicationRequestDTO getMcqCreditApplicationRequestDTO(Custom_Opportunity__c opp, Decimal totalInsurance, Boolean isConsumerLoan){
        
        Application_Quoting__c appQuoting = QuotingToolHelper.getApplicationQuoting(opp.Id, opp.Application__c);
        opp = getCustomOpportunityForApplication(opp);
        Application__c add = opp.Application__r;
        String employerABN1 = add.Employer_ABN_1__c;
        if (employerABN1 != null){
            if (!Pattern.matches('\\d{11}', employerABN1)){
                throw new MacLeasePartnerException ('Application form - Employer ABN must have 11 digits and no character');
            }
        }else{
            throw new MacLeasePartnerException ('Application form - Employer ABN in mandatory and must have 11 digits and no character');
        }
        
        McqCreditApplicationRequestDTO mcqCreditApp = new McqCreditApplicationRequestDTO();
        mcqCreditApp.privacy_disclosure = 'YES';
        mcqCreditApp.foreseeable_changes = 'NO';
        
        mcqCreditApp.campaign_code = null;
               
        /**Quotation ---I*/
        mcqCreditApp.quotation = new McqCreditApplicationRequestDTO.Quotation();
        McqQuoteRequestDTO appQuote = null;
        try{
            appQuote = getQuote(opp, totalInsurance, isConsumerLoan, appQuoting);
        }catch (MacLeasePartnerException ex){
            throw new MacLeasePartnerException ('Error finding Quote' + ex.getMessage(), ex);
        }
        mcqCreditApp.quotation.asset_cost = appQuote.asset_cost;
        mcqCreditApp.quotation.asset_cost_gst = appQuote.asset_cost_gst;
        mcqCreditApp.quotation.asset_subtype = appQuote.asset_subtype;
        mcqCreditApp.quotation.basis = appQuote.basis;
        mcqCreditApp.quotation.origination_fee = appQuote.origination_fee;
        mcqCreditApp.quotation.brokerage_value = appQuote.brokerage_value;
        mcqCreditApp.quotation.brokerage_type = appQuote.brokerage_type;
        mcqCreditApp.quotation.cash_deposit = appQuote.cash_deposit;
        mcqCreditApp.quotation.direct_debit = appQuote.direct_debit;
        mcqCreditApp.quotation.deferred_months = appQuote.deferred_months;
        if (SOLVE_BROKERAGE_AMOUNT.equalsIgnoreCase(appQuote.solve_for)){
            mcqCreditApp.quotation.effective_rate = NumberUtils.convertDecimalToScale(appQuote.effective_rate, scaleDecimal);
        }
        if (SOLVE_WITH_BASE_RATE.equalsIgnoreCase(appQuote.solve_for)){
            mcqCreditApp.quotation.base_rate = appQuote.base_rate;
        }
        mcqCreditApp.quotation.application_fee = appQuote.application_fee;
        mcqCreditApp.quotation.finance_type = appQuote.finance_type;
        mcqCreditApp.quotation.fin_lodge_fee = appQuote.fin_lodge_fee;
        mcqCreditApp.quotation.gst_on_insurance = appQuote.gst_on_insurance;
        mcqCreditApp.quotation.insurance = appQuote.insurance;
        mcqCreditApp.quotation.condition = appQuote.condition;
        mcqCreditApp.quotation.num_of_assets = appQuote.num_of_assets;
        //mcqCreditApp.quotation.solve_for = appQuote.solve_for;
        mcqCreditApp.quotation.solve_for = SOLVE_BROKERAGE_AMOUNT;
        
        mcqCreditApp.quotation.own_rate = appQuote.own_rate;
        mcqCreditApp.quotation.payment_frequency = appQuote.payment_frequency;
        mcqCreditApp.quotation.payout_amount = appQuote.payout_amount;
        if (appQuote.residual_value != null && appQuote.residual_value != 0){
           	mcqCreditApp.quotation.residual_type = appQuote.residual_type;
        	mcqCreditApp.quotation.residual_value = appQuote.residual_value; 
        }
        mcqCreditApp.quotation.residual_mode = appQuote.residual_mode;
        mcqCreditApp.quotation.sale_type = appQuote.sale_type;
        mcqCreditApp.quotation.contract_number = appQuote.contract_number;
        mcqCreditApp.quotation.state = appQuote.state;
        mcqCreditApp.quotation.term = StringUtils.convertToString(appQuote.term);
        mcqCreditApp.quotation.trade_in = appQuote.trade_in;
        mcqCreditApp.quotation.campaign_code = appQuote.campaign_code;
        mcqCreditApp.quotation.rate_exception = appQuote.rate_exception;
        mcqCreditApp.quotation.gross_payment = NumberUtils.convertDecimalToScale( appQuoting.Mcq_Gross_Payment__c, scaleDecimal);
        //mcqCreditApp.quotation.gross_payment = NumberUtils.convertDecimalToScale( appQuoting.Client_Rate__c, scaleDecimal);
        /**Quotation ---F*/
        /***/
        
        mcqCreditApp.finance_type = appQuote.finance_type;
        mcqCreditApp.asset_subtype = appQuote.asset_subtype;
        
        
        mcqCreditApp.applicants = new List<McqCreditApplicationRequestDTO.Applicants>();
        McqCreditApplicationRequestDTO.Applicants applicants = new McqCreditApplicationRequestDTO.Applicants();
        
        if ('Personal'.equalsIgnoreCase(add.Application_Type__c)){
            applicants.individual_applicant = getApplicant_1(opp, add, isConsumerLoan);
            mcqCreditApp.applicants.add(applicants);
            applicants = new McqCreditApplicationRequestDTO.Applicants();
            
            if (add.No_of_People__c == 2){
                applicants.individual_applicant = getApplicant_2(opp, add, isConsumerLoan);
                mcqCreditApp.applicants.add(applicants);
            }
        }else{
            if ('Company'.equalsIgnoreCase(add.Business_Structure__c)){
                applicants.company_applicant = getCompanyApplicant_1(opp, add, isConsumerLoan);
            	mcqCreditApp.applicants.add(applicants);
            }else if ('Partnership'.equalsIgnoreCase(add.Business_Structure__c)){
                applicants.partnership_applicant = getPartnerShipApplicant_1(opp, add, isConsumerLoan);
            	mcqCreditApp.applicants.add(applicants);
            }else if ('Trust'.equalsIgnoreCase(add.Business_Structure__c)){
                /**
                applicants.trust_applicant = getTrustApplicant_1(opp, add);
            	mcqCreditApp.applicants.add(applicants);
				**/
                throw new MacLeasePartnerException ('[ No define applicants \'Trust\' for Macquarie Application -' + add.Business_Structure__c +'-]');
            }else if ('Individual or Sole Trader'.equalsIgnoreCase(add.Business_Structure__c) || 'Individual/Sole Trader'.equalsIgnoreCase(add.Business_Structure__c)){
                applicants.individual_applicant = getApplicant_1(opp, add, isConsumerLoan);
                mcqCreditApp.applicants.add(applicants);
                applicants = new McqCreditApplicationRequestDTO.Applicants();
                
                if (add.No_of_People__c == 2){
                    applicants.individual_applicant = getApplicant_2(opp, add, isConsumerLoan);
                    mcqCreditApp.applicants.add(applicants);
                }
            }else{
                throw new MacLeasePartnerException ('[ Dont find any applicants / Business for Macquarie Application ]');
            }
        }
         /**Suppliers --- I**/
        if (opp.Dealer_Name__c != null && opp.Dealer_State__c != null &&  opp.Dealer_Phone_Number__c != null){
            mcqCreditApp.suppliers = new List<McqCreditApplicationRequestDTO.Suppliers>();
            McqCreditApplicationRequestDTO.Suppliers suppliers = new McqCreditApplicationRequestDTO.Suppliers();
            suppliers.supplier_name = opp.Dealer_Name__c;
            suppliers.supplier_contact_name = opp.Dealer_Contact_Name__c;
            suppliers.supplier_ABN = employerABN1;
            suppliers.supplier_business_num = null;
            
            McqCreditApplicationRequestDTO.Supplier_Address address= new McqCreditApplicationRequestDTO.Supplier_Address();
            address.address_1 = formatStringAddress(opp.Dealer_Unit_Number__c, opp.Dealer_Street_Number__c ,opp.Dealer_Address__c);
            address.address_2 = formatStringAddress(opp.Dealer_Address__c, opp.Dealer_Street_Type__c, '');
            address.address_3 = opp.Dealer_Suburb__c;
            address.postcode = opp.Dealer_Postcode__c;
            address.state = Utilities.salesforceValueToMessageCode_Code(opp.Dealer_State__c, Utilities.STATES);
            suppliers.supplier_address = address;
            
            suppliers.supplier_fax = null;
            suppliers.supplier_telephone = convertToPhoneMacquarie(opp.Dealer_Phone_Number__c);
            mcqCreditApp.suppliers.add(suppliers);
        }
        /**Suppliers --- F**/
        
        /**Manual_Insurers --- I**/
        if (isConsumerLoan){
            mcqCreditApp.manual_insurers = new List<McqCreditApplicationRequestDTO.Manual_Insurers>();
            Integer months = appQuoting.Term__c != null ? Integer.valueOf(appQuoting.Term__c) : 0;
            Date fromDate = null;
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_GAP_Retail_Price__c, 'Guaranteed Asset Protection (GAP)', fromDate, months);
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_Warranty_Retail_Price__c, 'Warranty Insurance', fromDate, months);
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_LTI_Retail_Price__c, 'Loan Termination Insurance (LTI)',fromDate, months);
            //getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_Truck_GAP_Retail_Price__c, 'Truck GAP', fromDate, months);
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_TAI_Retail_Price__c, 'Guaranteed Asset Protection (GAP) ', fromDate, months);
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_MV_Retail_Price__c, 'Car Insurance', fromDate, months);
            getManualInsurers(mcqCreditApp.manual_insurers, appQuoting.Insurance_AIC_Retail_Price__c, 'Consumer Credit Insurance', fromDate, months);
        }
        /**Manual_Insurers --- F**/
        
        /**Guarantors --- I**/
        mcqCreditApp.guarantors = new List<McqCreditApplicationRequestDTO.Guarantors>();
        McqCreditApplicationRequestDTO.Guarantors guarantors = new McqCreditApplicationRequestDTO.Guarantors();
        
        if ('Personal'.equalsIgnoreCase(add.Application_Type__c)){
            guarantors.individual_guarantor = getApplicant_1(opp, add,isConsumerLoan);
            mcqCreditApp.guarantors.add(guarantors);
            if (add.No_of_People__c == 2){
                guarantors = new McqCreditApplicationRequestDTO.Guarantors();
                guarantors.individual_guarantor = getApplicant_2(opp, add, isConsumerLoan);
                mcqCreditApp.guarantors.add(guarantors);
            }
        }else{
            if ('Company'.equalsIgnoreCase(add.Business_Structure__c)){
                guarantors = new McqCreditApplicationRequestDTO.Guarantors();
                guarantors.company_guarantor = getCompanyApplicant_1(opp, add, isConsumerLoan);
                //guarantors.company_guarantor = getApplicant_1(opp, add,isConsumerLoan);
                mcqCreditApp.guarantors.add(guarantors);
            }else if ('Partnership'.equalsIgnoreCase(add.Business_Structure__c)){
                guarantors.partnership_guarantor = getPartnerShipApplicant_1(opp, add, isConsumerLoan);
            	mcqCreditApp.guarantors.add(guarantors);
            }else if ('Individual or Sole Trader'.equalsIgnoreCase(add.Business_Structure__c)){
                guarantors.individual_guarantor = getApplicant_1(opp, add,isConsumerLoan);
                mcqCreditApp.guarantors.add(guarantors);
                if (add.No_of_People__c == 2){
                    guarantors = new McqCreditApplicationRequestDTO.Guarantors();
                    guarantors.individual_guarantor = getApplicant_2(opp, add, isConsumerLoan);
                    mcqCreditApp.guarantors.add(guarantors);
                }
            }else{
                throw new MacLeasePartnerException ('[ Dont find any applicants / Business for Macquarie Application ]');
            }
        }
        /**Guarantors --- F**/
        /**Assets --- I**/
        mcqCreditApp.assets =  new List<McqCreditApplicationRequestDTO.Assets>();
        mcqCreditApp.assets.add(getAssets(opp, appQuoting));
            
        /**Assets --- F**/
        
        /**Income_Capacity --- I**/
        //mcqCreditApp.income_capacity = getIncomeCapacity(opp, add); v2.0
        /**Income_Capacity --- F**/
        
        //Comment_texts --- I/
        String cmmt = getLenderComments(add.Id);
        if (cmmt != null){
            if (cmmt.length() >= 255){
                cmmt = cmmt.left(254);
            }
            mcqCreditApp.comment_texts = new List<McqCreditApplicationRequestDTO.Comment_Texts>();
            McqCreditApplicationRequestDTO.Comment_Texts comment = new McqCreditApplicationRequestDTO.Comment_Texts();
            comment.comment_text_comment = cmmt;
            if (comment.comment_text_comment == null){
                comment.comment_text_comment = '-';
            }
            mcqCreditApp.comment_texts.add(comment);
        }
        
        //Comment_texts --- F/
        
        if (CHATTEL_MORTGAGE.equalsIgnoreCase(appQuote.finance_type)){
            mcqCreditApp.financial_statement_application = null;
        }else{
            McqCreditApplicationRequestDTO.Financial_Statement_Application fsa = new McqCreditApplicationRequestDTO.Financial_Statement_Application();
            String applicationType = 'SOLE_APPL';
            if (add.No_of_People__c == 1){
                if (opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                    applicationType = 'SOLE_APPL_SPOUSE';
                }
            }else if (add.No_of_People__c == 2){
                applicationType = 'CO_BORROWER_SPOUSE';
            }
            fsa.application_type = applicationType;
            fsa.marital_status = StringUtils.validateNull(add.Marital_Status_1__c).toUpperCase();
            fsa.num_dependents = add.No_of_Dependants_1__c;
            fsa.co_borrower_rel = null;
            
            mcqCreditApp.financial_statement_application = fsa;
        }
        return mcqCreditApp;
     }
    
    private McqCreditApplicationRequestDTO.Manual_Insurers getManualInsurers(List<McqCreditApplicationRequestDTO.Manual_Insurers> listManualInsurers,Decimal dAmount, String sType, Date fromDate, Integer months){
        if (!(dAmount != null && dAmount != 0)){
            return null;
        }
        McqCreditApplicationRequestDTO.Manual_Insurers manual_Insurers = new McqCreditApplicationRequestDTO.Manual_Insurers();
        manual_Insurers.amount = dAmount;
        if (fromDate != null && months != null){
            manual_Insurers.from_date = DateUtils.formatDate(fromDate, DateUtils.ddMMyyyy);
            manual_Insurers.to_date = DateUtils.formatDate(fromDate.addMonths(months), DateUtils.ddMMyyyy);
        }else{
            manual_Insurers.from_date = DateUtils.formatDate(Date.today(), DateUtils.ddMMyyyy);
            manual_Insurers.to_date = DateUtils.formatDate(Date.today(), DateUtils.ddMMyyyy);
        }
        manual_Insurers.insurer = INSURER;
        manual_Insurers.type = sType;
        listManualInsurers.add(manual_Insurers);
        return manual_Insurers;
    }
    
    private McqCreditApplicationRequestDTO.Individual_Applicant getApplicant_1(Custom_Opportunity__c opp, Application__c add,  Boolean isConsumerLoan){
         /**Individual_Applicant --- I**/
        McqCreditApplicationRequestDTO.Individual_Applicant individualApp = new McqCreditApplicationRequestDTO.Individual_Applicant();
        individualApp.individual_applicant_type= 'INDIVIDUAL';
        individualApp.accountant_contact_name= add.Accountant_Name__c;
        individualApp.accountant_contact_phone= convertToPhoneMacquarie(add.Accountant_Phone__c);
        individualApp.accountant_firm_name= add.Accountant_Name__c;
        individualApp.bo_flag= null;
        individualApp.title = StringUtils.validateNull(add.Title_1__c).toUpperCase();
        individualApp.first_name= add.First_Name__c;
        individualApp.middle_name= add.Middle_Name__c;
        individualApp.surname= add.Last_Name__c;
        individualApp.other_name= null;
        individualApp.date_of_birth= DateUtils.formatDate(add.Date_of_Birth_1__c, DateUtils.ddMMyyyy);
        individualApp.email= add.Email_Address__c;
        individualApp.fax= null;
        individualApp.licence_number= add.Drivers_License_1__c;
        individualApp.licence_type= add.Type_of_Licence_1__c;
        individualApp.licence_state= Utilities.salesforceValueToMessageCode_Code(add.Driver_Licence_State_Issue_1__c, Utilities.STATES);
        individualApp.mobile= add.Mobile_Number__c;
        individualApp.telephone= convertToPhoneMacquarie(add.Home_Phone__c);
        individualApp.work_phone= convertToPhoneMacquarie(add.Work_Phone__c);
        individualApp.residential_status= Utilities.salesforceValueToMessageCode_Code(add.Current_Residence_Status_1__c, Utilities.McQ_RESIDENTIAL_STATUS);
        
        String landlord_name = add.Landlord_Name_1__c;
        String landlord_phone = add.Landlord_Phone_1__c;
        if (individualApp.residential_status != null && individualApp.residential_status.equalsIgnoreCase ('RENTING')){
            if (StringUtils.isNullOrEmpty(landlord_name)){
                throw new MacLeasePartnerException ('Landkord name is mandatory');
            }
            if (StringUtils.isNullOrEmpty(landlord_phone)){
                throw new MacLeasePartnerException ('Landkord phone is mandatory');
            }
        }
        individualApp.landlord_name= landlord_name;
        individualApp.landlord_phone= convertToPhoneMacquarie(landlord_phone);
        individualApp.au_residency_status= Utilities.salesforceValueToMessageCode_Code(add.Current_Residential_Status_1__c, Utilities.McQ_RESIDENCY_STATUS);
        individualApp.customer_number= null;
        if (!isConsumerLoan){
            individualApp.sole_trader= 'YES';
        }
        individualApp.guarantor_flag= 'NO'; //TEMP
        individualApp.same_applicant_addr= 'YES';
        individualApp.marketing_excl_flag= null;
        individualApp.email_unavailable_flag = 'YES';
        individualApp.employment = getEmployment_Applicant_1(add);
        /**Employment --- F**/
                
         /**Address --- I**/
        McqCreditApplicationRequestDTO.Address address= new McqCreditApplicationRequestDTO.Address();
        address.address_1 = formatStringAddress(add.Unit_Number__c, add.Street_Number__c ,'');
        address.address_2 = formatStringAddress(add.Street_Address__c, add.Street_Type__c, '');
        address.address_3 = add.Suburb__c;
        address.postcode = add.Postcode__c;
        address.state = Utilities.salesforceValueToMessageCode_Code(add.State__c, Utilities.STATES);
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        Integer months = null;
        if (movedIn != null){
            Integer movedInYears = getHowManyYears(movedIn, System.today());
            Integer movedInMonths = getHowManyMonths(movedIn, System.today());
            address.years_at_address = StringUtils.convertToString(movedInYears);
        	address.months_at_address = StringUtils.convertToString(movedInMonths);
            months = (movedInYears * 12) + movedInMonths;
        }
        individualApp.address = address;
        
        if (months != null && months < 24 &&
           !StringUtils.isNullOrEmpty(add.Previous_State_1__c) && !StringUtils.isNullOrEmpty(add.Previous_Street_Address_1__c)){
            McqCreditApplicationRequestDTO.Previous_Address previousAddress = new McqCreditApplicationRequestDTO.Previous_Address();
            previousAddress.address_1 = formatStringAddress(add.Previous_Unit_Number_1__c, add.Previous_Street_Number_1__c ,'');
            previousAddress.address_2 = formatStringAddress(add.Previous_Street_Address_1__c, add.Previous_Street_Type_1__c, '');
            previousAddress.address_3 = add.Previous_Suburb_1__c;
            previousAddress.postcode = add.Previous_Postcode_1__c;
            previousAddress.state = Utilities.salesforceValueToMessageCode_Code(add.Previous_State_1__c, Utilities.STATES);
            Date previousMovedIn = DateUtils.convertToDate(add.Date_From_1__c);
            if (previousMovedIn != null){
                previousAddress.years_at_address = StringUtils.convertToString(getHowManyYears(previousMovedIn, movedIn));
                previousAddress.months_at_address = StringUtils.convertToString(getHowManyMonths(previousMovedIn, movedIn));
            }
            individualApp.previous_address = previousAddress;
        }
        
         /**Address --- F**/
        
        /**Asset_Statement --- I**/
        //individualApp.asset_statement = getAssetStatement(add); //remove by v2.0
        
        /**Asset_Statement --- F**/
        /**Liabilities_Statement --- I**/
        
        //individualApp.liabilities_statement = getLiabilitiesStatement(add); //remove by v2.0
        /**Liabilities_Statement --- F**/
        
        /**Mailing_Address --- I**/
        /**
        McqCreditApplicationRequestDTO.Mailing_Address mailing_address= new McqCreditApplicationRequestDTO.Mailing_Address();
        mailing_address.address_1 = add.Street_Address__c;
        mailing_address.address_2 = add.Street_Type__c;
        mailing_address.address_3 = add.Suburb__c;
        mailing_address.postcode = add.Postcode__c;
        mailing_address.state = Utilities.salesforceValueToMessageCode_Code(add.State__c, Utilities.STATES);
        individualApp.mailing_address = mailing_address;
        /**Mailing_Address --- F**/
        
        /**Income_Detail --- I
        McqCreditApplicationRequestDTO.Income_Detail income_detail= new McqCreditApplicationRequestDTO.Income_Detail();
        income_detail.credit_card_expense= NumberUtils.convertDecimalToScale(add.Total_Credit_Monthly_Payment__c, scaleDecimal);
        income_detail.household_expense= 0;
        
        if (RESIDENTIAL_STATUS_OWN_MORTGAGED.equalsIgnoreCase(individualApp.residential_status) || RESIDENTIAL_STATUS_RENTING.equalsIgnoreCase(individualApp.residential_status)){
            income_detail.mortgage_rent= NumberUtils.convertDecimalToScale(opp.ApplicationServicing__r.Total_Rent_Mortgage_Full__c , scaleDecimal);
        }
        income_detail.gross_income= NumberUtils.convertDecimalToScale(opp.ApplicationYTD__r.Income_Monthly_1_1__c, scaleDecimal);
        income_detail.net_income= NumberUtils.convertDecimalToScale(opp.ApplicationYTD__r.Income_Monthly_1_2__c , scaleDecimal);
        income_detail.other_expense= NumberUtils.convertDecimalToScale(opp.ApplicationServicing__r.Total_Liabilities__c, scaleDecimal);
        income_detail.spouse_gross_income= NumberUtils.convertDecimalToScale(opp.ApplicationYTD__r.Income_Monthly_2_1__c , scaleDecimal);
        income_detail.spouse_net_income= NumberUtils.convertDecimalToScale(opp.ApplicationYTD__r.Income_Monthly_2_2__c, scaleDecimal);
        individualApp.income_detail = income_detail;
        /**Income_Detail --- F**/
        
        /**Financial_Statement --I**/
        individualApp.financial_statement = getFinancial_Statement (opp, add, false, isConsumerLoan);
        /**Financial_Statement --F**/
        
        /**Individual_Applicant --- F**/
        return individualApp;
    }

    private String getStatementType(Decimal dNoOfPeople){
        if (dNoOfPeople == 1){
            return 'SINGLE_APPLICANT';
        }else if (dNoOfPeople == 2){
            return 'JOINT_APPLICANTS_WITH_COMBINED_ASSETS_LIABILITIES';
        }
        return 'NO_STATEMENT_AVAILABLE_TO_MACQUARIE';
    }
    
    private void setLoansAmount(McqCreditApplicationRequestDTO.Liabilities_Statement liabilities_statement, String sLoan, String descp, Decimal amount){
        if (!FieldValidationsHelper.isContainsValidCharacters(sLoan)) {
            return;
        }
        Boolean setLoan = false;
        if (sLoan == null){
            return;
        }
        if(sLoan.containsIgnoreCase('Mortgage')){
            if (liabilities_statement.liabilities_mortgage_1_amt == null){
                liabilities_statement.liabilities_mortgage_1_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_1_desc = descp;
                setLoan = true;
            }else if (liabilities_statement.liabilities_mortgage_2_amt == null){
                liabilities_statement.liabilities_mortgage_2_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_2_desc = descp;
                setLoan = true;
            }else if (liabilities_statement.liabilities_mortgage_3_amt == null){
                liabilities_statement.liabilities_mortgage_3_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_3_desc = descp;
                setLoan = true;
            }
        }else if(sLoan.containsIgnoreCase('Loan')){
            if(liabilities_statement.liabilities_loan_1_amt != null){
                liabilities_statement.liabilities_loan_1_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_1_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_loan_2_amt != null){
                liabilities_statement.liabilities_loan_2_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_2_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_loan_3_amt != null){
                liabilities_statement.liabilities_loan_3_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_3_desc = descp;
                setLoan = true;
            }
        }else{
            liabilities_statement.liabilities_overdraft_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
            liabilities_statement.liabilities_overdraft_desc = descp;
            setLoan = true;
        }
        if (!setLoan){
            if (liabilities_statement.liabilities_mortgage_1_amt == null){
                liabilities_statement.liabilities_mortgage_1_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_1_desc = descp;
                setLoan = true;
            }else if (liabilities_statement.liabilities_mortgage_2_amt == null){
                liabilities_statement.liabilities_mortgage_2_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_2_desc = descp;
                setLoan = true;
            }else if (liabilities_statement.liabilities_mortgage_3_amt == null){
                liabilities_statement.liabilities_mortgage_3_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
                liabilities_statement.liabilities_mortgage_3_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_loan_1_amt != null){
                liabilities_statement.liabilities_loan_1_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_1_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_loan_2_amt != null){
                liabilities_statement.liabilities_loan_2_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_2_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_loan_3_amt != null){
                liabilities_statement.liabilities_loan_3_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
        		liabilities_statement.liabilities_loan_3_desc = descp;
                setLoan = true;
            }else if(liabilities_statement.liabilities_overdraft_amt != null){
                liabilities_statement.liabilities_overdraft_amt = NumberUtils.convertDecimalToScale(amount, scaleDecimal);
            	liabilities_statement.liabilities_overdraft_desc = descp;
            }
        }
    }
    
    private McqCreditApplicationRequestDTO.Individual_Applicant getApplicant_2(Custom_Opportunity__c opp, Application__c add, Boolean isConsumerLoan){
         /**Individual_Applicant --- I**/
        McqCreditApplicationRequestDTO.Individual_Applicant individualApp = new McqCreditApplicationRequestDTO.Individual_Applicant();
        individualApp.individual_applicant_type= 'INDIVIDUAL';
        individualApp.accountant_contact_name= null;
        individualApp.accountant_contact_phone= null;
        individualApp.accountant_firm_name= null;
        individualApp.bo_flag= null;
        individualApp.title = StringUtils.validateNull(add.Title_2__c).toUpperCase();
        individualApp.first_name= add.First_Name_2__c;
        individualApp.middle_name= add.Middle_Name_2__c;
        individualApp.surname= add.Last_Name_2__c;
        individualApp.other_name= null;
        individualApp.date_of_birth= DateUtils.formatDate(add.Date_of_Birth_2__c, DateUtils.DDMMYYYY);
        individualApp.email= add.Email_Address_2__c;
        individualApp.fax= null;
        individualApp.licence_number= add.Drivers_License_2__c;
        individualApp.licence_type= add.Type_of_Licence_2__c;
        individualApp.licence_state= Utilities.salesforceValueToMessageCode_Code(add.Driver_Licence_State_Issue_2__c, Utilities.STATES);
        individualApp.mobile= convertToPhoneMacquarie(add.Mobile_Number_2__c);
        individualApp.telephone= convertToPhoneMacquarie(add.Home_Phone_2__c);
        individualApp.work_phone= convertToPhoneMacquarie(add.Work_Phone_2__c);
        individualApp.residential_status= individualApp.residential_status= Utilities.salesforceValueToMessageCode_Code(add.Current_Residence_Status_2__c, Utilities.McQ_RESIDENTIAL_STATUS);
        individualApp.landlord_name= add.Landlord_Name_2__c;
        individualApp.landlord_phone= convertToPhoneMacquarie(add.Landlord_Phone_2__c);
        individualApp.au_residency_status= Utilities.salesforceValueToMessageCode_Code(add.Current_Residential_Status_2__c , Utilities.McQ_RESIDENCY_STATUS);
        individualApp.customer_number= null;
        if (!isConsumerLoan){
            individualApp.sole_trader= 'YES';
        }
        //individualApp.sole_trader= add.Business_Structure__c;
        individualApp.guarantor_flag= null;
        individualApp.same_applicant_addr= 'YES';
        individualApp.marketing_excl_flag= null;
        
        /**Employment --- I**/
        individualApp.employment = getEmployment_Applicant_2(add);
        /**Employment --- F**/
                
         /**Address --- I**/
        McqCreditApplicationRequestDTO.Address address= new McqCreditApplicationRequestDTO.Address();
        address.address_1 = formatStringAddress(add.Unit_Number_2__c, add.Street_Number_2__c ,'');
        address.address_2 = formatStringAddress(add.Street_Address_2__c, add.Street_Type_2__c ,'');
        address.address_3 = add.Suburb_2__c;
        address.postcode = add.Postcode_2__c;
        address.state = Utilities.salesforceValueToMessageCode_Code(add.State_2__c, Utilities.STATES);
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_2__c);
        if (movedIn != null){
            address.years_at_address = StringUtils.convertToString(getHowManyYears(movedIn, System.today()));
        	address.months_at_address = StringUtils.convertToString(getHowManyMonths(movedIn, System.today()));
        }
        individualApp.address = address;
        
        if (!StringUtils.isNullOrEmpty(add.Previous_State_2__c) && !StringUtils.isNullOrEmpty(add.Previous_Street_Address_2__c)){
            McqCreditApplicationRequestDTO.Previous_Address previousAddress = new McqCreditApplicationRequestDTO.Previous_Address();
            previousAddress.address_1 = add.Previous_Street_Address_2__c;
            previousAddress.address_2 = add.Previous_Street_Type_2__c;
            previousAddress.address_3 = add.Previous_Suburb_2__c;
            previousAddress.postcode = add.Previous_Postcode_2__c;
            previousAddress.state = Utilities.salesforceValueToMessageCode_Code(add.Previous_State_2__c, Utilities.STATES);
            Date previousMovedIn = DateUtils.convertToDate(add.Date_From_2__c);
            if (previousMovedIn != null){
                previousAddress.years_at_address = StringUtils.convertToString(getHowManyYears(previousMovedIn, System.today()));
                previousAddress.months_at_address = StringUtils.convertToString(getHowManyMonths(previousMovedIn, System.today()));
            }
            individualApp.previous_address = previousAddress;
        }
         /**Address --- F**/
        
        /**Mailing_Address --- I**/
        McqCreditApplicationRequestDTO.Mailing_Address mailing_address= new McqCreditApplicationRequestDTO.Mailing_Address();
        mailing_address.address_1 = formatStringAddress(add.Unit_Number_2__c, add.Street_Number_2__c ,'');
        mailing_address.address_2 = formatStringAddress(add.Street_Address_2__c, add.Street_Type_2__c,'');
        mailing_address.address_3 = add.Suburb_2__c;
        mailing_address.postcode = add.Postcode_2__c;
        mailing_address.state = Utilities.salesforceValueToMessageCode_Code(add.State_2__c, Utilities.STATES);
        individualApp.mailing_address = mailing_address;
        /**Mailing_Address --- F**/
        
        /**Asset_Statement --- I**/
        //individualApp.asset_statement = getAssetStatement(add); //remove by v2.0
        
        /**Asset_Statement --- F**/
        /**Liabilities_Statement --- I**/
        
        //individualApp.liabilities_statement = getLiabilitiesStatement(add); //remove by v2.0
        /**Liabilities_Statement --- F**/
        
        /**Financial_Statement --F**/
        individualApp.financial_statement = getFinancial_Statement (opp, add, true, isConsumerLoan);
        /**Individual_Applicant --- F**/
        
        /**Individual_Applicant --- F**/
        return individualApp;
    }
    
    private McqCreditApplicationRequestDTO.Employment getEmployment_Applicant_1(Application__c add){
        /**Employment --- I**/
        McqCreditApplicationRequestDTO.Employment employment= new McqCreditApplicationRequestDTO.Employment();
        String employerABN1 = add.Employer_ABN_1__c;
        if (employerABN1 != null){
            if (!Pattern.matches('\\d{11}', employerABN1)){
                throw new MacLeasePartnerException ('Application form - Employer ABN must have 11 digits and no character');
            }
        }else{
            throw new MacLeasePartnerException ('Application form - Employer ABN in mandatory and must have 11 digits and no character');
        }
        employment.abn= employerABN1;
        //employment.business_num= add.Business_ABN__c;
        employment.employer_contact_name= add.Reference_Name_1__c;
        employment.employer_contact_phone= convertToPhoneMacquarie(add.Current_Employer_Phone_1__c);
        employment.employer_name= add.Current_Employer_Name_1__c;
        employment.business_activity= add.Nature_of_Business__c;
        employment.employment_type= Utilities.salesforceValueToMessageCode_Code(add.Mode_of_Employment_1__c, Utilities.McQ_EMPLOYMENT_TYPE);
        
        if ('Company'.equalsIgnoreCase(add.Business_Structure__c)){
            employment.is_employer_proprietary= 'YES';
        }else{
            employment.is_employer_proprietary= 'NO';
        }
        
        employment.occupation= add.Current_Occupation_1__c;
        if(add.Previous_Mode_of_Employment_1__c != null && !''.equalsIgnoreCase(add.Previous_Mode_of_Employment_1__c)){
            employment.previous_employer_name= add.Previous_Employer_Name_1__c;
            employment.previous_employer_phone= convertToPhoneMacquarie(add.Previous_Employer_Phone_1__c) ;
            Date previousEmployedStart = DateUtils.convertToDate(add.Start_Date_1__c);
            Date previousEmployedFinish = DateUtils.convertToDate(add.Finish_Date_1__c);
            if (previousEmployedStart != null && previousEmployedFinish != null){
                employment.previous_years_employed= StringUtils.convertToString(getHowManyYears(previousEmployedStart, previousEmployedFinish));
                employment.previous_months_employed= StringUtils.convertToString(getHowManyMonths(previousEmployedStart, previousEmployedFinish));
            }
        }
        
        Date currentEmployed = DateUtils.convertToDate(add.Date_Started_1__c);
        if (currentEmployed != null){
            employment.years_employed= StringUtils.convertToString(getHowManyYears(currentEmployed, System.today()));
        	employment.months_employed= StringUtils.convertToString(getHowManyMonths(currentEmployed, System.today()));
        }
        /**Employer_Address --- I**/
        McqCreditApplicationRequestDTO.Employer_Address employer_address = new McqCreditApplicationRequestDTO.Employer_Address();
        employer_address.address_1 = formatStringAddress (add.Current_Work_Unit_Number_1__c, add.Current_Work_Street_Number_1__c ,'');
        employer_address.address_2 = formatStringAddress (add.Current_Work_Address_1__c, add.Current_Work_Street_Type_1__c ,'');
        employer_address.address_3 = add.Current_Work_Suburb_1__c;
        employer_address.postcode = add.Current_Work_Postcode_1__c;
        employer_address.state = Utilities.salesforceValueToMessageCode_Code(add.Current_Work_State_1__c, Utilities.STATES);
        employment.employer_address = employer_address;
        /**Employer_Address --- F**/
        return employment;
    }
    
    private McqCreditApplicationRequestDTO.Employment getEmployment_Applicant_2(Application__c add){
        /**Employment --- I**/
        McqCreditApplicationRequestDTO.Employment employment= new McqCreditApplicationRequestDTO.Employment();
        employment.abn= add.Trading_Name__c;
        //employment.business_num= add.Business_ABN__c;
        employment.employer_contact_name= add.Reference_Name_2__c;
        employment.employer_contact_phone= convertToPhoneMacquarie(add.Current_Employer_Phone_2__c);
        employment.employer_name= add.Current_Employer_Name_2__c;
        employment.business_activity= add.Nature_of_Business__c;
        employment.employment_type= Utilities.salesforceValueToMessageCode_Code(add.Mode_of_Employment_2__c, Utilities.McQ_EMPLOYMENT_TYPE);
        if ('Company'.equalsIgnoreCase(add.Business_Structure__c)){
            employment.is_employer_proprietary= 'YES';
        }else{
            employment.is_employer_proprietary= 'NO';
        }
        
        
        employment.occupation= add.Current_Occupation_2__c;
        if(add.Previous_Mode_of_Employment_2__c != null && !''.equalsIgnoreCase(add.Previous_Mode_of_Employment_2__c)){
            employment.previous_employer_name= add.Previous_Employer_Name_2__c;
            employment.previous_employer_phone= convertToPhoneMacquarie(add.Previous_Employer_Phone_2__c);
            Date previousEmployedStart = DateUtils.convertToDate(add.Start_Date_2__c);
            Date previousEmployedFinish = DateUtils.convertToDate(add.Finish_Date_2__c);
            if (previousEmployedStart != null && previousEmployedFinish != null){
                employment.previous_years_employed= StringUtils.convertToString(getHowManyYears (previousEmployedStart, previousEmployedFinish));
                employment.previous_months_employed= StringUtils.convertToString(getHowManyMonths (previousEmployedStart, previousEmployedFinish));
            }
        }
        
        Date currentEmployed = DateUtils.convertToDate(add.Date_Started_2__c);
        if (currentEmployed != null){
            employment.years_employed= StringUtils.convertToString(getHowManyYears(currentEmployed, System.today()));
        	employment.months_employed= StringUtils.convertToString(getHowManyMonths(currentEmployed, System.today()) );
        }
        /**Employer_Address --- I**/
        McqCreditApplicationRequestDTO.Employer_Address employer_address = new McqCreditApplicationRequestDTO.Employer_Address();
        employer_address.address_1 = formatStringAddress(add.Current_Work_Unit_Number_2__c, add.Current_Work_Street_Number_2__c ,'');
        employer_address.address_2 = formatStringAddress(add.Current_Work_Address_2__c, add.Current_Work_Street_Type_2__c ,'');
        employer_address.address_3 = add.Current_Work_Suburb_2__c;
        employer_address.postcode = add.Current_Work_Postcode_2__c;
        employer_address.state = Utilities.salesforceValueToMessageCode_Code(add.Current_Work_State_2__c, Utilities.STATES);
        employment.employer_address = employer_address;
        /**Employer_Address --- F**/
        return employment;
    }
    
    private Integer getHowManyYears (Date dStart, Date dEnd){
        Integer monthStart = dStart.month();
        Integer monthEnd = dEnd.month();
        if (monthStart > monthEnd){
            return dEnd.year() - dStart.year() -1;
        }
        return dEnd.year() - dStart.year();
    }
    
    private Integer getHowManyMonths (Date dStart, Date dEnd){
        Integer monthStart = dStart.month();
        Integer monthEnd = dEnd.month();
        if (monthStart > monthEnd){
            return 12 - (monthStart - monthEnd);
        }
        return monthEnd - monthStart;
    }
    
    private McqCreditApplicationRequestDTO.Company_Applicant getCompanyApplicant_1(Custom_Opportunity__c opp, Application__c add, Boolean isConsumerLoan){
         /**Company_Applicant --- I**/
        McqCreditApplicationRequestDTO.Company_Applicant companyApp = new McqCreditApplicationRequestDTO.Company_Applicant();
        companyApp.accountant_contact_name= add.Accountant_Name__c;
        companyApp.accountant_contact_phone= convertToPhoneMacquarie(add.Accountant_Phone__c);
        companyApp.accountant_firm_name= add.Accountant_Name__c;
        companyApp.abn = add.Business_ABN__c;
        companyApp.business_num = add.Business_ACN__c;
        companyApp.exchange_name = null;
        companyApp.fax = null;
        companyApp.industry = add.Nature_of_Business__c;
        companyApp.is_postal_rba = 'YES' ;
        companyApp.is_ppb_rba = 'YES' ;
        companyApp.is_proprietary_company = 'YES' ;
        companyApp.marketing_excl_flag = 'YES' ;
        companyApp.name = StringUtils.validateNull(add.Entity_Name__c).toUpperCase() ;
        companyApp.full_name = add.Entity_Name__c ;
        companyApp.parent_name = null ;
        companyApp.telephone = add.Current_Employer_Phone_1__c ;
        companyApp.customer_number = null ;
        
         /**Address --- I**/
        List<Application_Employment__c> addressFinance = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                       Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                       Work_Address__c, Phone__c, 
                        Unit_Number__c, Street_Number__c, Street_Type__c, 
                        Suburb__c, Postcode__c, State__c,Address_Line_1__c, Overseas_State__c,
                        Overseas_City__c, Address_Line_2__c , Address_Type__c
                FROM Application_Employment__c WHERE Application__c = :opp.Application__c and Address_Type__c = :Utilities.ADDRESS_TYPE_FINANCE limit 1
            ];
        Application_Employment__c addressFinanceDetail = null;
        if (addressFinance != null && !addressFinance.isEmpty()){
            addressFinanceDetail = addressFinance[0];
        }
        if (addressFinanceDetail != null){
            McqCreditApplicationRequestDTO.Address address= new McqCreditApplicationRequestDTO.Address();
            address.address_1 = formatStringAddress(addressFinanceDetail.Unit_Number__c, addressFinanceDetail.Street_Number__c ,'');
            address.address_2 = formatStringAddress(add.Trading_Address__c, addressFinanceDetail.Street_Type__c ,'');
            address.address_3 = addressFinanceDetail.Suburb__c;
            address.postcode = addressFinanceDetail.Postcode__c;
            address.state = Utilities.salesforceValueToMessageCode_Code(addressFinanceDetail.State__c, Utilities.STATES);
            companyApp.address = address;
        }
         /**Address --- F**/
        /**
        companyApp.postal_address = new List<McqCreditApplicationRequestDTO.Postal_Address> ();
        companyApp.postal_address = null;
		**/
        companyApp.years_established = null ;
        
       
        /**ppb_address --- I**/
        McqCreditApplicationRequestDTO.Ppb_Address ppb_address = new McqCreditApplicationRequestDTO.Ppb_Address();
        ppb_address.address_1 = formatStringAddress(add.Current_Work_Unit_Number_1__c, add.Current_Work_Street_Number_1__c ,'');
        ppb_address.address_2 = formatStringAddress(add.Current_Work_Address_1__c, add.Current_Work_Street_Type_1__c , '');
        ppb_address.address_3 = add.Current_Work_Suburb_1__c;
        ppb_address.postcode = add.Current_Work_Postcode_1__c;
        ppb_address.state = Utilities.salesforceValueToMessageCode_Code(add.Current_Work_State_1__c, Utilities.STATES);
        companyApp.ppb_address = ppb_address;
        /**ppb_address --- F**/
        
        /**postal_address --- I**/
        McqCreditApplicationRequestDTO.Postal_Address postal_address = new McqCreditApplicationRequestDTO.Postal_Address();
        postal_address.address_1 = formatStringAddress(add.Current_Work_Unit_Number_1__c, add.Current_Work_Street_Number_1__c ,'');
        postal_address.address_2 = formatStringAddress(add.Current_Work_Address_1__c, add.Current_Work_Street_Type_1__c , '');
        postal_address.address_3 = add.Current_Work_Suburb_1__c;
        postal_address.postcode = add.Current_Work_Postcode_1__c;
        postal_address.state = Utilities.salesforceValueToMessageCode_Code(add.Current_Work_State_1__c, Utilities.STATES);
        companyApp.postal_address = postal_address;
        /**postal_address --- F**/
        
        
        
        /**
        companyApp.business_persons = new List<McqCreditApplicationRequestDTO.Business_Persons>();
        McqCreditApplicationRequestDTO.Business_Persons business_persons = new McqCreditApplicationRequestDTO.Business_Persons();
        business_persons.business_person = getApplicant_1(opp, add);
        companyApp.business_persons.add(business_persons);
        **/
        companyApp.business_person = new List<McqCreditApplicationRequestDTO.McQ_Individual_Applicant>();
        McqCreditApplicationRequestDTO.Individual_Applicant applicantCompany = getApplicant_1(opp, add, isConsumerLoan);
        applicantCompany.bo_flag = 'YES';
        companyApp.business_person.add(applicantCompany);
        
        
        companyApp.beneficial_owners = new List<McqCreditApplicationRequestDTO.Beneficial_Owners>();
        McqCreditApplicationRequestDTO.Beneficial_Owners beneficial_Owners = new McqCreditApplicationRequestDTO.Beneficial_Owners();
        beneficial_Owners.individual_beneficial_owner = getIndividualBeneficialOwner(opp, add);
        companyApp.beneficial_owners.add(beneficial_Owners);
        
        
        /**Company_Applicant --- F**/
        return companyApp;
    }
    
    private McqCreditApplicationRequestDTO.Individual_Beneficial_Owner getIndividualBeneficialOwner(Custom_Opportunity__c opp, Application__c add){
        McqCreditApplicationRequestDTO.Individual_Beneficial_Owner beneficialOwners = new McqCreditApplicationRequestDTO.Individual_Beneficial_Owner();
        beneficialOwners.date_of_birth = DateUtils.formatDate(add.Date_of_Birth_1__c, DateUtils.ddMMyyyy);
        beneficialOwners.fax = null;
        beneficialOwners.title = StringUtils.validateNull(add.Title_1__c).toUpperCase();
        beneficialOwners.first_name = add.First_Name__c;
        beneficialOwners.middle_name = add.Middle_Name__c;
        beneficialOwners.surname = add.Last_Name__c;
        beneficialOwners.mobile = add.Mobile_Number__c;
        beneficialOwners.telephone = convertToPhoneMacquarie(add.Home_Phone__c);
        beneficialOwners.email = add.Email_Address__c;
        /**Address --- I**/
        McqCreditApplicationRequestDTO.Address address= new McqCreditApplicationRequestDTO.Address();
        address.address_1 = formatStringAddress(opp.Dealer_Unit_Number__c, opp.Dealer_Street_Number__c ,opp.Dealer_Address__c);
        address.address_2 = formatStringAddress(opp.Dealer_Address__c, opp.Dealer_Street_Type__c, '');
        address.address_3 = opp.Dealer_Suburb__c;
        address.postcode = opp.Dealer_Postcode__c;
        address.state = Utilities.salesforceValueToMessageCode_Code(opp.Dealer_State__c, Utilities.STATES);
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        if (movedIn != null){
            address.years_at_address = StringUtils.convertToString(getHowManyYears(movedIn, System.today()));
        	address.months_at_address = StringUtils.convertToString(getHowManyMonths(movedIn, System.today()));
        }
        beneficialOwners.address = address;
         /**Address --- F**/
        return beneficialOwners;
    }
    
    private McqCreditApplicationRequestDTO.Assets getAssets(Custom_Opportunity__c opp, Application_Quoting__c appQuoting){
        McqCreditApplicationRequestDTO.Assets assets = new McqCreditApplicationRequestDTO.Assets();
        assets.asset_cost = appQuoting.Vehicle_Price__c;
        assets.inventory_flag = 'NO';
        assets.replacement_status = 'ADDITIONAL';
        assets.year_of_manufacture = opp.Application_AssetDetail__r.Year__c;        
        String variant = opp.Application_AssetDetail__r.Variant__c;
        Glass_Variant__c r = GlassServicesHelper.getVariantByCode(variant);
        String make;
        make = opp.Application_AssetDetail__r.Make__c;
        Glass_Make__c gm = GlassServicesHelper.getMakeByCode(make);
        String series;
        if (gm != null){
            make = gm.Name;
        }
        String model = opp.Application_AssetDetail__r.Model__c;
        if (r != null){
            series = r.Series__c;
        }
        
        String assetType = opp.Application_AssetDetail__r.Type__c;
        if ('Equipment'.equalsIgnoreCase(assetType)){
             assets.plant_and_equipment = new McqCreditApplicationRequestDTO.Plant_And_Equipment();
            assets.plant_and_equipment.model_num = null;
            assets.plant_and_equipment.description = make + model + variant + series;
            assets.plant_and_equipment.valuation = null;
            assets.plant_and_equipment.serial_num = null;
        //}else if ('Car'.equalsIgnoreCase(assetType)){
        } else {    
            boolean glassFlag = false;
            assets.motor_vehicle =  new McqCreditApplicationRequestDTO.Motor_Vehicle();
            assets.motor_vehicle.accessories = null;
            assets.motor_vehicle.body_type = null;
            //if (appQuoting.Goods_sub_type__c.containsIgnoreCase('MOTORCYCLE') || appQuoting.Goods_sub_type__c.containsIgnoreCase('CARAVANS')){
            String bodyType = opp.Application__r.Type_of_Asset__c;
            if (bodyType != null){
                if (bodyType.containsIgnoreCase('BIKE')){
                    assets.motor_vehicle.body_type = 'MOTORCYCLE';
                } else if (bodyType.containsIgnoreCase('CARAVAN')){
                    assets.motor_vehicle.body_type = 'CARAVAN';
                }
            }
            assets.motor_vehicle.engine_num = opp.Application_AssetDetail__r.Engine_No__c;
            assets.motor_vehicle.make = make;
            assets.motor_vehicle.model = model;
            assets.motor_vehicle.registration_num = opp.Application_AssetDetail__r.Rego__c;
            if (r != null){
            	assets.motor_vehicle.retail_value = r.Retail_Price__c;
                if ('Car'.equalsIgnoreCase(assetType)){
                    assets.motor_vehicle.nvic = r.NVIC__c;
                    glassFlag = true;
                }
            }
            assets.motor_vehicle.vin_chasis_num = opp.Application_AssetDetail__r.VIN__c;
            assets.motor_vehicle.wholesale_value = opp.Application_AssetDetail__r.RRP__c;
            assets.motor_vehicle.use_glasses_flag = glassFlag;
            if (!'New'.equalsIgnoreCase(opp.New_Used__c)){
                Decimal odometer = opp.Application_AssetDetail__r.Actual_KM__c;
                String odometer_reading = '';
                if (odometer != null && odometer != 0){
                    odometer_reading = StringUtils.convertToString(odometer);
                }else{
                    if (r != null){
                    	odometer = r.Average_Kms__c * 1000;
                    }
                    odometer_reading = StringUtils.convertToString(odometer);
                }
                assets.motor_vehicle.odometer_reading = odometer_reading;
                
            }
        }
        
        
       
        return assets;
    }
    
    private McqCreditApplicationRequestDTO.Partnership_Applicant getPartnerShipApplicant_1(Custom_Opportunity__c opp, Application__c add, Boolean isConsumerLoan){
         /**Company_Applicant --- I**/
        McqCreditApplicationRequestDTO.Partnership_Applicant partnerShipApp = new McqCreditApplicationRequestDTO.Partnership_Applicant();
        String employerABN1 = add.Employer_ABN_1__c;
        if (employerABN1 != null){
            if (!Pattern.matches('\\d{11}', employerABN1)){
                throw new MacLeasePartnerException ('Application form - Employer ABN must have 11 digits and no character');
            }
        }else{
            throw new MacLeasePartnerException ('Application form - Employer ABN in mandatory and must have 11 digits and no character');
        }
        partnerShipApp.abn = employerABN1;
        partnerShipApp.business_num = add.Business_ABN__c;
        partnerShipApp.fax = null;
        partnerShipApp.full_name = StringUtils.validateNull(add.First_Name__c) + ' ' + StringUtils.validateNull(add.Last_Name__c);
        partnerShipApp.membership_details = null;
        partnerShipApp.industry = add.Nature_of_Business__c;
        partnerShipApp.name = add.Accountant_Name__c;
        
         /**Address --- I**/
        McqCreditApplicationRequestDTO.Address address= new McqCreditApplicationRequestDTO.Address();
        address.address_1 = formatStringAddress(add.Unit_Number__c, add.Street_Number__c ,'');
        address.address_2 = formatStringAddress(add.Street_Address__c, add.Street_Type__c ,'');
        address.address_3 = add.Suburb__c;
        address.postcode = add.Postcode__c;
        address.state = Utilities.salesforceValueToMessageCode_Code(add.State__c, Utilities.STATES);
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        if (movedIn != null){
            address.years_at_address = StringUtils.convertToString(getHowManyYears(movedIn, System.today()));
        	address.months_at_address = StringUtils.convertToString(getHowManyMonths(movedIn, System.today()));
        }
        partnerShipApp.address = address;
         /**Address --- F**/
        
        partnerShipApp.professional_asso_name = null;
        partnerShipApp.telephone = add.Current_Employer_Phone_1__c ;
        partnerShipApp.years_established = null;
        partnerShipApp.individual_partner = new List<McqCreditApplicationRequestDTO.Mcq_Individual_Applicant>();
        partnerShipApp.individual_partner.add(getApplicant_1(opp, add, isConsumerLoan));
        partnerShipApp.company_partner = new List<McqCreditApplicationRequestDTO.McQ_Company_Applicant>();
        partnerShipApp.company_partner.add(getCompanyApplicant_1(opp, add, isConsumerLoan));
        return partnerShipApp;
    }
        
    private String formatStringAddress(String unitNumber, String streetNumber, String streetAddress){
        String addrr = UtilitiesList.getNameStreetType(streetNumber);
        String fullAddress = StringUtils.validateNull(unitNumber) + ' ' + StringUtils.validateNull(addrr) + ' ' + StringUtils.validateNull(streetAddress);
        if (fullAddress.length() > 35){
            fullAddress = fullAddress.substring(0, 35);
        }
        return fullAddress.trim();
    }
    
    private Custom_Opportunity__c getCustomOpportunityForQuote (Custom_Opportunity__c opp){
        List<Custom_Opportunity__c> r = null;
        if (opp != null) {
            r = [Select o.New_Used__c, o.Purchase_Type__c, o.Contract_Number__c, o.Application__r.Application_Type__c, o.Application__r.Business_Structure__c, o.Application__r.Accountant_Name__c, o.Application__r.Accountant_Phone__c, 
                        o.Application__r.Title_1__c, o.Application__r.First_Name__c, o.Application__r.Middle_Name__c, o.Application__r.Last_Name__c, o.Application__r.Date_of_Birth_1__c, o.Application__r.Email_Address__c, 
                        o.Application__r.Drivers_License_1__c, o.Application__r.Type_of_Licence_1__c, o.Application__r.Driver_Licence_State_Issue_1__c, o.Application__r.Mobile_Number__c, o.Application__r.Home_Phone__c,
                        o.Application__r.Employer_ABN_1__c , o.Application__c
                        from Custom_Opportunity__c  as o where id =: opp.Id];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    private Custom_Opportunity__c getCustomOpportunityForApplication (Custom_Opportunity__c opp){
        List<Custom_Opportunity__c> r = null;
        if (opp != null) {
            r = [Select o.New_Used__c, o.Purchase_Type__c, o.Contract_Number__c, o.Application__r.Application_Type__c, o.Application__r.Business_Structure__c, o.Application__r.Accountant_Name__c, o.Application__r.Accountant_Phone__c, 
                        o.Application__r.Title_1__c, o.Application__r.First_Name__c, o.Application__r.Middle_Name__c, o.Application__r.Last_Name__c, o.Application__r.Date_of_Birth_1__c, o.Application__r.Email_Address__c, 
                        o.Application__r.Drivers_License_1__c, o.Application__r.Type_of_Licence_1__c, o.Application__r.Driver_Licence_State_Issue_1__c, o.Application__r.Mobile_Number__c, o.Application__r.Home_Phone__c,
                        o.Application__r.Work_Phone__c, o.Application__r.Landlord_Name_1__c, o.Application__r.Landlord_Phone_1__c, o.Application__r.Title_2__c, o.Application__r.First_Name_2__c, o.Application__r.Middle_Name_2__c,
                        o.Application__r.Last_Name_2__c, o.Application__r.Date_of_Birth_2__c, o.Application__r.Email_Address_2__c, o.Application__r.Drivers_License_2__c, o.Application__r.Type_of_Licence_2__c, o.Application__r.Driver_Licence_State_Issue_2__c,
                        o.Application__r.Mobile_Number_2__c, o.Application__r.Home_Phone_2__c, o.Application__r.Work_Phone_2__c, o.Application__r.Landlord_Name_2__c, o.Application__r.Landlord_Phone_2__c, o.Application__r.Current_Residential_Status_1__c,
                        o.Application__r.Current_Residence_Status_1__c, o.Application__r.Reference_Name_1__c, o.Application__r.Current_Employer_Phone_1__c, o.Application__r.Current_Employer_Name_1__c, o.Application__r.Mode_of_Employment_1__c,
                        o.Application__r.Current_Occupation_1__c, o.Application__r.Previous_Employer_Name_1__c, o.Application__r.Previous_Employer_Phone_1__c, o.Application__r.Start_Date_1__c, o.Application__r.Finish_Date_1__c,
                 		o.Application__r.Previous_Mode_of_Employment_1__c, o.Application__r.Previous_Mode_of_Employment_2__c,
                        o.Application__r.Date_Started_1__c, o.Application__r.Current_Work_Address_1__c, o.Application__r.Street_Address__c, o.Application__r.Street_Type__c, o.Application__r.Suburb__c, o.Application__r.Postcode__c, o.Application__r.State__c,
                        o.Application__r.Date_Moved_in_1__c, o.Application__r.Previous_Street_Address_1__c, o.Application__r.Previous_Street_Type_1__c, o.Application__r.Previous_Suburb_1__c, o.Application__r.Previous_Postcode_1__c,
                 		o.Application__r.Previous_Unit_Number_1__c, o.Application__r.Previous_Street_Number_1__c, o.Application__r.Type_of_Asset__c,
                        o.Application__r.Previous_State_1__c, o.Application__r.Date_From_1__c, o.Application__r.Bank_Value__c,  o.Application__r.Furniture_Value__c, o.Application__r.Super_Value_How_Much__c,  o.Application__r.No_of_People__c, //o.Application__r.Total_Credit_Monthly_Payment__c, 
                        o.Dealer_Name__c, o.Dealer_Contact_Name__c,
                        o.Dealer_Address__c, o.Dealer_Phone_Number__c, o.ApplicationServicing__r.Total_Rent_Mortgage_Full__c, o.ApplicationServicing__r.Total_Living_Expenses_Full__c, o.ApplicationServicing__r.Total_Liabilities__c, o.ApplicationServicing__r.Is_Splitting_Expenses__c,
                 		o.ApplicationServicing__r.Income_1__c , o.ApplicationServicing__r.Total_Net_Monthly_Income__c,o.ApplicationYTD__r.Monthly_Amount_Servicing_1__c,
                        o.ApplicationYTD__r.Income_Monthly_1_1__c, o.ApplicationYTD__r.Income_Monthly_1_2__c, o.ApplicationYTD__r.Income_Monthly_2_1__c, o.ApplicationYTD__r.Income_Monthly_2_2__c, o.Application_AssetDetail__r.Variant__c,
                        o.Application_AssetDetail__r.Make__c, o.Application_AssetDetail__r.Model__c, o.Application_AssetDetail__r.Type__c, o.Application_AssetDetail__r.Engine_No__c, o.Application_AssetDetail__r.Rego__c, o.Application_AssetDetail__r.VIN__c,
                        o.Application_AssetDetail__r.Year__c, o.Application_AssetDetail__r.RRP__c, o.Application__r.Reference_Name_2__c, o.Application__r.Current_Employer_Phone_2__c, o.Application__r.Current_Employer_Name_2__c, o.Application__r.Mode_of_Employment_2__c,
                 		o.Application_AssetDetail__r.Actual_KM__c ,      
                 		o.Application__r.Current_Occupation_2__c, o.Application__r.Previous_Employer_Name_2__c, o.Application__r.Previous_Employer_Phone_2__c, o.Application__r.Start_Date_2__c, o.Application__r.Finish_Date_2__c, o.Application__r.Date_Started_2__c,
                        o.Application__r.Current_Work_Address_2__c, o.Application__r.No_of_Dependants_1__c, 
                        o.Application__r.Business_ABN__c, o.Application__r.Trading_Name__c, o.Application__r.Nature_of_Business__c,
                        o.Application__r.Marital_Status_1__c, o.Application__r.Current_Residence_Status_2__c, o.Application__r.Current_Residential_Status_2__c, o.Application__r.Street_Address_2__c, o.Application__r.Street_Type_2__c, o.Application__r.Suburb_2__c,
                        o.Application__r.State_2__c, o.Application__r.Date_Moved_in_2__c, o.Application__r.Previous_Street_Address_2__c, o.Application__r.Previous_Street_Type_2__c, o.Application__r.Previous_Suburb_2__c, o.Application__r.Previous_Postcode_2__c,
                        o.Application__r.Previous_State_2__c, o.Application__r.Date_From_2b__c, //o.Application__r.Total_Other_Income_2__c, 
                        o.Application__r.Postcode_2__c, o.Application__r.Business_ACN__c, o.Application__r.Entity_Name__c,
                 		o.Dealer_Unit_Number__c ,o.Dealer_Street_Number__c, o.Dealer_Street_Type__c, o.Dealer_Suburb__c, o.Dealer_Postcode__c, o.Dealer_State__c, 
                        o.Application__r.Current_Work_Unit_Number_1__c, o.Application__r.Current_Work_Unit_Number_2__c, o.Application__r.Current_Work_Street_Number_1__c, o.Application__r.Trading_Address__c,
                        o.Application__r.Current_Work_Street_Number_2__c, o.Application__r.Current_Work_Street_Type_1__c, o.Application__r.Current_Work_Street_Type_2__c,
                        o.Application__r.Current_Work_Suburb_1__c, o.Application__r.Current_Work_Suburb_2__c, o.Application__r.Current_Work_Postcode_1__c, o.Application__r.Current_Work_Postcode_2__c, o.Application__r.Current_Work_State_1__c, o.Application__r.Current_Work_State_2__c,
                        o.Application__r.Unit_Number_2__c, o.Application__r.Street_Number_2__c, o.Application__r.Date_From_2__c, o.Application__r.Unit_Number__c, o.Application__r.Street_Number__c, o.Application__c,
                 		o.Application__r.Rent_per_month_1__c, o.Application__r.Basic_Living_Expenses_Per_Month__c, o.Application__r.Travel_Transport_Expenses_per_Month__c, 
                 		o.Application__r.Mobile_Phone_Internet_Pay_TV_per_Month__c, o.Application__r.Residential_Payment_Frequency_1__c,o.Application__r.Board_per_Month_1__c,
                 		o.Application__r.Childcare_Child_Maintenance_Per_Month__c, o.Application__r.Other_Expenses_per_Month__c, 
                 		o.Application__r.Insurance_Expenses_per_Month__c,
                  		o.ApplicationServicing__r.Net_Partner_Income__c, o.Application__r.Employer_ABN_1__c 
                        from Custom_Opportunity__c  as o where id =: opp.Id];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    private String getLenderComments(Id appId){
        List<Application_Extra_Data__c> r = null;
        if (appId != null) {
            r = [select  id, Application__c, Category__c, Type_of_Data__c,Data__c, LastModifiedDate
                    from Application_Extra_Data__c where Application__c = :appId and Type_of_Data__c = 'Notes' and  Category__c  = 'Lender'
                    order by LastModifiedDate desc];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0).Data__c;
        } else {
            return null;
        }
    }
    
    private McqCreditApplicationRequestDTO.Financial_Statement getFinancial_Statement (Custom_Opportunity__c opp, Application__c add, boolean isSecondApplicant,
                                                                                      Boolean isConsumerLoan){
        McqCreditApplicationRequestDTO.Financial_Statement financial_statement = new McqCreditApplicationRequestDTO.Financial_Statement();
        
        financial_statement.financial_income = getFinancial_Income(opp, add, isSecondApplicant);
        financial_statement.financial_expense = getFinancial_Expense (opp, add, isConsumerLoan);
        financial_statement.financial_assets = getFinancial_Assets (opp, add, financial_statement.financial_liabilities);
        financial_statement.financial_liabilities = getFinancial_Liabilities (opp, add, financial_statement.financial_assets);
        checkOwnedRightFlag (financial_statement.financial_liabilities, financial_statement.financial_assets);
        return financial_statement;
    }
    
    private void checkOwnedRightFlag (List<McqCreditApplicationRequestDTO.Financial_Liabilities> financialLiabilities, List<McqCreditApplicationRequestDTO.Financial_Assets> fAssets){
        boolean ownedOutright = true;
        if (financialLiabilities != null && fAssets != null){
            /**
            Integer mortgage = 0;
            for (McqCreditApplicationRequestDTO.Financial_Liabilities fl : financialLiabilities){
                if ('HOME_PROPERTY_LOAN'.equalsIgnoreCase(fl.type_m)){ //HOME_PROPERTY_LOAN because is match with Motgage (Check liability)
                    mortgage++;
                }
            }
            Integer index = 0;
            for (index = 0; index < fAssets.size(); index++){
                McqCreditApplicationRequestDTO.Financial_Assets a = fAssets.get(index);
                if (a.owned_outright_flag != null && a.owned_outright_flag && (index + 1) <= mortgage){
                    a.owned_outright_flag = false;
                    financialLiabilities.get(index).asset_sequence_link = StringUtils.convertToString(index+1);
                }else{
                    a.owned_outright_flag = null;
                }
            }
			**/
            Integer index = 0; 
            Integer aSize = fAssets.size();
            Integer lSize = financialLiabilities.size();
            for (index = 0; index < fAssets.size(); index++){
                McqCreditApplicationRequestDTO.Financial_Assets a;
                McqCreditApplicationRequestDTO.Financial_Liabilities fl;
                if (index < aSize){
                    a = fAssets.get(index);
                }
                if (index < lSize){
                    fl = financialLiabilities.get(index);
                }
                if (a != null && a.owned_outright_flag != null){
                    if (fl != null && 'HOME_PROPERTY_LOAN'.equalsIgnoreCase(fl.type_m)){ //HOME_PROPERTY_LOAN because is match with Motgage (Check liability)
                        if (a.owned_outright_flag){
                            a.owned_outright_flag = false;
                            financialLiabilities.get(index).asset_sequence_link = StringUtils.convertToString(index+1);
                            a.owned_outright = 'FALSE';
                        }
                    }else{
                        a.owned_outright_flag = true;
                        a.owned_outright = 'TRUE';
                    }
                }
                
            }
        }
    }
    
    private McqCreditApplicationRequestDTO.Financial_Income getFinancial_Income (Custom_Opportunity__c opp, Application__c add, boolean isSecondApplicant){
        McqCreditApplicationRequestDTO.Financial_Income financial_income = new McqCreditApplicationRequestDTO.Financial_Income();
        financial_income.net_income_verification = 'OTHERS';
        String modeEmployment = add.Mode_of_Employment_1__c;
        if (modeEmployment != null && ('Full Time'.equalsIgnoreCase(modeEmployment) || 'Part Time'.equalsIgnoreCase(modeEmployment) || 'Casual'.equalsIgnoreCase(modeEmployment))){
            financial_income.net_income_verification = 'PAYG';
        }
        Decimal netYearToDateSalary = opp.ApplicationYTD__r.Income_Monthly_1_1__c;
        Decimal payPeriod = opp.ApplicationYTD__r.Income_Monthly_1_2__c;
        Decimal monthly_net_income = 0;
        if (netYearToDateSalary != null && payPeriod == null ){
            monthly_net_income = netYearToDateSalary;
        }else if (netYearToDateSalary == null && payPeriod != null ){
            monthly_net_income = payPeriod;
        }else if (netYearToDateSalary != null && payPeriod != null ){
            if (netYearToDateSalary <= payPeriod){
                monthly_net_income = netYearToDateSalary;
            }else{
                monthly_net_income = payPeriod;
            }
        }
        //financial_income.monthly_net_income = NumberUtils.convertDecimalToScale(opp.ApplicationServicing__r.Income_1__c, scaleDecimal);
        financial_income.monthly_net_income = NumberUtils.convertDecimalToScale(monthly_net_income, scaleDecimal);
        financial_income.gross_annual_income = 0.00; 
        financial_income.government_benefits = 0.00;
        financial_income.superannuation = 0.00;
        financial_income.investment_property = 0.00;
        financial_income.investment_income = 0.00;
        //financial_income.other_income = NumberUtils.convertDecimalToScale(add.Total_Other_Income_1__c, scaleDecimal);
        //financial_income.other_income = NumberUtils.convertDecimalToScale(opp.ApplicationServicing__r.Total_Net_Monthly_Income__c, scaleDecimal);
        financial_income.other_income = 0;
        financial_income.spouse_gross_income = 0.00;
        financial_income.spouse_net_income = NumberUtils.convertDecimalToScale(opp.ApplicationServicing__r.Net_Partner_Income__c, scaleDecimal);
        
        //New INCOME process from OppOpportunitty
        Map <Long, List < Application_Income__c >> servIncomeMap = ApplicationService.getApplicationIncomeMap2(opp.Application__c);

        if (isSecondApplicant){
            if (servIncomeMap != null){
                List < Application_Income__c > appIncomes = servIncomeMap.get(2);
                if (appIncomes != null){
                    for (Application_Income__c c : appIncomes){
                        calculateFinancialIncomeType(financial_income, c.Type__c, c.Income__c);
                    }
                }
            }

        }else{
            if (servIncomeMap != null){
                List < Application_Income__c > appIncomes = servIncomeMap.get(1);
                if (appIncomes != null){
                    for (Application_Income__c c : appIncomes){
                        calculateFinancialIncomeType(financial_income, c.Type__c, c.Income__c);
                    }
                }
            }

            Application_YTD__c ytd = opp.ApplicationYTD__r;
        }
        return financial_income;
    }
    
    private McqCreditApplicationRequestDTO.Financial_Income calculateFinancialIncomeType(McqCreditApplicationRequestDTO.Financial_Income financial_Income ,String incomeType, Decimal value){
        if (value == null){
            return financial_Income;
        }
        if ('Rental Income'.equalsIgnoreCase(incomeType)){
            financial_Income.investment_property += value;
        }else if ('Child Support'.equalsIgnoreCase(incomeType)){
            financial_Income.other_income += value;
        }else if ('Family Part A & B'.equalsIgnoreCase(incomeType)){
            financial_Income.government_benefits += value;
        }else if ('Investment Income'.equalsIgnoreCase(incomeType)){
            financial_Income.investment_income += value;
        }else if ('Rent Assistance'.equalsIgnoreCase(incomeType)){
            financial_Income.government_benefits += value;
        }else if ('Parenting Payment Single'.equalsIgnoreCase(incomeType)){
            financial_Income.government_benefits += value;
        }else if ('Parenting Payment Partnered'.equalsIgnoreCase(incomeType)){
            financial_Income.government_benefits += value;
        }else if ('Newstart'.equalsIgnoreCase(incomeType)){
            financial_Income.government_benefits += value;
        }else if ('Trust Income'.equalsIgnoreCase(incomeType)){
            //financial_Income.monthly_net_income += value;
        }else if ('Other'.equalsIgnoreCase(incomeType)){
            financial_Income.other_income += value;
        }else if ('Superannuation'.equalsIgnoreCase(incomeType)){
            financial_Income.superannuation += value;
        }else if ('Investment Property'.equalsIgnoreCase(incomeType)){
            financial_Income.investment_property += value;
        }
        return financial_Income;
    }
    
    private McqCreditApplicationRequestDTO.Financial_Expense getFinancial_Expense (Custom_Opportunity__c opp, Application__c add, Boolean isConsumerLoan){
        McqCreditApplicationRequestDTO.Financial_Expense financial_expense = new McqCreditApplicationRequestDTO.Financial_Expense();
        Decimal monthlyRentBoard = NumberUtils.convertDecimalToScale(add.Rent_per_month_1__c, scaleDecimal);
        if (monthlyRentBoard == null){
            monthlyRentBoard = 0;
        }
        monthlyRentBoard = Utilities.getMonthlyValue (add.Residential_Payment_Frequency_1__c , monthlyRentBoard, scaleDecimal);
        /**
        if('Weekly'.equalsIgnoreCase(add.Residential_Payment_Frequency_1__c)){
            monthlyRentBoard = (monthlyRentBoard * 52) / 12;
        }else if ('Fortnightly'.equalsIgnoreCase(add.Residential_Payment_Frequency_1__c)){
			monthlyRentBoard = (monthlyRentBoard * 26) / 12;            
        }else if ('Yearly'.equalsIgnoreCase(add.Residential_Payment_Frequency_1__c)){
            monthlyRentBoard = monthlyRentBoard / 12;
        }
		**/
        financial_expense.monthly_rent_board = monthlyRentBoard;
        /**
        Decimal monthly_rent_board = NumberUtils.convertDecimalToScale(add.Rent_per_month_1__c, scaleDecimal); 
        if (monthly_rent_board != null){
            if (monthly_rent_board == 0 ){
                monthly_rent_board = NumberUtils.convertDecimalToScale(add.Board_per_Month_1__c, scaleDecimal);
            }
            financial_expense.monthly_rent_board = monthly_rent_board;
        }**/
        Decimal livingExpensesPerMonth = NumberUtils.convertStringToDecimal(add.Basic_Living_Expenses_Per_Month__c, scaleDecimal);
        Decimal mobilePhoneInternet = NumberUtils.convertStringToDecimal(add.Mobile_Phone_Internet_Pay_TV_per_Month__c, scaleDecimal);
        Decimal insuranceExpenses =  NumberUtils.convertStringToDecimal(add.Insurance_Expenses_per_Month__c,  scaleDecimal);
        Decimal otherExpensesPerMonth = NumberUtils.convertStringToDecimal(add.Other_Expenses_per_Month__c,  scaleDecimal);
        Decimal general_living = 0;
        if (livingExpensesPerMonth != null){
            general_living += livingExpensesPerMonth;
        }
        if (mobilePhoneInternet != null){
            general_living += mobilePhoneInternet;
        }
        if (insuranceExpenses != null){
            general_living += insuranceExpenses;
        }
        if (otherExpensesPerMonth != null){
            general_living += otherExpensesPerMonth;
        }
        financial_expense.general_living = general_living;
        financial_expense.household_reason = 'LIVING_WITH_FAMILY';
        financial_expense.all_household_expenses_declared = TRUE;
        financial_expense.vehicle_running_cost = NumberUtils.convertStringToDecimal(add.Travel_Transport_Expenses_per_Month__c, scaleDecimal);
        financial_expense.all_vehicle_cost_declared = TRUE;
        financial_expense.private_education_childcare = NumberUtils.convertStringToDecimal(add.Childcare_Child_Maintenance_Per_Month__c, scaleDecimal);
        //financial_expense.other_expenses = NumberUtils.convertStringToDecimal(add.Other_Expenses_per_Month__c, scaleDecimal);
        financial_expense.other_expenses = 0;
        financial_expense.spouse_no_additional_expense_flag = null; //TRUE
        financial_expense.all_liabilities_disclosed = TRUE;
        
        
        if (isConsumerLoan){
            if (add.No_of_People__c == 1){
                if (opp.ApplicationServicing__r.Is_Splitting_Expenses__c){
                    financial_expense.spouse_no_additional_expense_flag = true;
                }
            }
        }
        return financial_expense;
    }
    
    private List<McqCreditApplicationRequestDTO.Financial_Assets> getFinancial_Assets (Custom_Opportunity__c opp, Application__c add, List<McqCreditApplicationRequestDTO.Financial_Liabilities> financialLiabilities){
        List<McqCreditApplicationRequestDTO.Financial_Assets> fAssets = new List<McqCreditApplicationRequestDTO.Financial_Assets>();
        // Lelo                 2019-03-22
        Map<String, List<Application_Other_Asset__c>> otherAssetsMap = ApplicationService.getApplicationOtherAssetsMap(opp.Application__c);

        //Integer seq = fAssets.size();
        String residenceStatus = add.Current_Residence_Status_1__c;

        if (otherAssetsMap.containsKey(ApplicationService.PROPERTY_ASSET_TYPE)) {
            Integer count = 1;
            for (Application_Other_Asset__c a : otherAssetsMap.get(ApplicationService.PROPERTY_ASSET_TYPE)) {
                String type_m = 'INVESTMENT_PROPERTY';
                if (count == 1) {
                    type_m = 'HOME_PROPERTY';
                }
                getFinancialAsset(fAssets, type_m, NumberUtils.convertDecimalToScale(a.Value__c, scaleDecimal), a.Has_Loan__c, true, financialLiabilities);
            }
        }
        
        //getFinancialAsset(fAssets, 'HOME_PROPERTY', NumberUtils.convertDecimalToScale(add.Property_Value_1__c, scaleDecimal), add.Property_Has_Loan_1__c, true, financialLiabilities);
        //getFinancialAsset(fAssets, 'INVESTMENT_PROPERTY', NumberUtils.convertDecimalToScale(add.Property_Value_2__c, scaleDecimal), add.Property_Has_Loan_2__c, true, financialLiabilities);
        //getFinancialAsset(fAssets, 'INVESTMENT_PROPERTY', NumberUtils.convertDecimalToScale(add.Property_Value_3__c, scaleDecimal), add.Property_Has_Loan_3__c, true, financialLiabilities);
        
        if (otherAssetsMap.containsKey(ApplicationService.VEHICLE_ASSET_TYPE)) {
            Integer count = 1;
            for (Application_Other_Asset__c a : otherAssetsMap.get(ApplicationService.VEHICLE_ASSET_TYPE)) {
                getFinancialAsset(fAssets, 'MOTOR_VEHICLE', NumberUtils.convertDecimalToScale(a.Value__c, scaleDecimal), a.Has_Loan__c, true, financialLiabilities);
            }
        }

        //getFinancialAsset(fAssets, 'MOTOR_VEHICLE', NumberUtils.convertDecimalToScale(add.Motor_Vehicle_Value_1__c, scaleDecimal), add.Vehicle_Has_Loan_1__c, true, financialLiabilities);
        //getFinancialAsset(fAssets, 'MOTOR_VEHICLE', NumberUtils.convertDecimalToScale(add.Motor_Vehicle_Value_2__c, scaleDecimal), add.Vehicle_Has_Loan_2__c, true, financialLiabilities);
        //getFinancialAsset(fAssets, 'MOTOR_VEHICLE', NumberUtils.convertDecimalToScale(add.Motor_Vehicle_Value_3__c, scaleDecimal), add.Vehicle_Has_Loan_3__c, true, financialLiabilities);

        getFinancialAsset(fAssets, 'CASH', NumberUtils.convertDecimalToScale(add.Bank_Value__c, scaleDecimal), residenceStatus, null, null);
        getFinancialAsset(fAssets, 'SUPERANNUATION', NumberUtils.convertDecimalToScale(add.Super_Value_How_Much__c, scaleDecimal), residenceStatus, null, null);
        getFinancialAsset(fAssets, 'HOME_CONTENTS', NumberUtils.convertDecimalToScale(add.Furniture_Value__c, scaleDecimal), residenceStatus, null, null);
                
        if (fAssets.size() == 0 || fAssets.get(0) == null){
            fAssets = null;
        }
        return fAssets;
    }
    
    private McqCreditApplicationRequestDTO.Financial_Assets getFinancialAsset (List<McqCreditApplicationRequestDTO.Financial_Assets> fAssets, String type_m, 
                                                                               Decimal amount, String residenceStatus, Boolean owned_outright_flag, List<McqCreditApplicationRequestDTO.Financial_Liabilities> financialLiabilities){
        if (!(amount != null && amount > 0) ){
            return null;
        }
        Integer seq = fAssets.size() + 1;
        McqCreditApplicationRequestDTO.Financial_Assets financial_assets = new McqCreditApplicationRequestDTO.Financial_Assets();
        financial_assets.sequence = seq;
        financial_assets.type_m = type_m;
        financial_assets.amount = amount;
        financial_assets.owned_outright = 'TRUE';
        //if (residenceStatus.containsIgnoreCase ('Mortgage')){
        //    financial_assets.owned_outright = 'FALSE';
        //}else if (residenceStatus.containsIgnoreCase ('Own Outright')){
        //    financial_assets.owned_outright = 'TRUE';
        //}
        if (residenceStatus.containsIgnoreCase ('Y')){
            financial_assets.owned_outright = 'FALSE';
        }else {
            financial_assets.owned_outright = 'TRUE';
        }
        financial_assets.owned_outright_flag = owned_outright_flag;
		/**
        if (owned_outright_flag != null){
            financial_assets.owned_outright_flag = owned_outright_flag;
        }
**/
        fAssets.add(financial_assets);
        return financial_assets;
    }
    
    private List<String> getAssetLink(Integer seq, List<McqCreditApplicationRequestDTO.Financial_Assets> fAssets){
        if (fAssets == null || seq == null){
            return null;
        }
        Integer index = 0;
        for (index = 0; index < fAssets.size() ; index++){
            McqCreditApplicationRequestDTO.Financial_Assets a = fAssets.get(index);
            if (a.owned_outright != null && a.owned_outright.equalsIgnoreCase('FALSE') && (index) == seq){
                return new List<String>{StringUtils.convertToString(a.sequence), a.type_m};
            }
        }
        return null;
    }
    
    private List<McqCreditApplicationRequestDTO.Financial_Liabilities> getFinancial_Liabilities (Custom_Opportunity__c opp, Application__c add, List<McqCreditApplicationRequestDTO.Financial_Assets> fAssets){
        List<McqCreditApplicationRequestDTO.Financial_Liabilities> fLiabilities = new List<McqCreditApplicationRequestDTO.Financial_Liabilities>();
        Integer seq = 0;
        String residenceStatus = add.Current_Residence_Status_1__c;
        /**
        getFinancialLiabilitie(fLiabilities, add.Loan_Type_1__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_1__c, scaleDecimal), 
												getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_1__c , scaleDecimal), 0,
												add.Other_Loans_Lender_1__c , residenceStatus);

        getFinancialLiabilitie(fLiabilities, add.Loan_Type_2__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_2__c, scaleDecimal), 
												getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_2__c , scaleDecimal), 0,
												add.Other_Loans_Lender_2__c , residenceStatus);

        getFinancialLiabilitie(fLiabilities, add.Loan_Type_3__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_3__c, scaleDecimal), 
												getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_3__c , scaleDecimal), 0,
												add.Other_Loans_Lender_3__c , residenceStatus);
        **/        
        //Update process -I
        List<Application_Loan__c> d = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c,
                                            Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c,
                                            Order__c
                                            FROM Application_Loan__c WHERE Application__c = :opp.Application__c ORDER BY Order__c];
        for (Application_Loan__c a: d) {
            getFinancialLiabilitie(fLiabilities, a.Type__c, NumberUtils.convertDecimalToScale(a.Amount_Owing__c, scaleDecimal), 
												getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(a.Payment__c , scaleDecimal), 0,
												a.Lender__c , residenceStatus, a.Frequency__c);
        }
        
        //Update process -F
        List<Application_Other_Asset__c> v = ApplicationService.getApplicationOtherAssets(opp.Application__c, ApplicationService.VEHICLE_ASSET_TYPE);
        for (Application_Other_Asset__c a: v) {
            getFinancialLiabilitie(fLiabilities, 'Car Loan', NumberUtils.convertDecimalToScale(a.Amount_Owing__c, scaleDecimal),
                                                getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(a.Payment__c , scaleDecimal), 0,
                                                a.Lender__c , residenceStatus, a.Frequency__c);    
        }
        //getFinancialLiabilitie(fLiabilities, add.Loan_Type_4__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_4__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_4__c , scaleDecimal), 0,
								//				add.Other_Loans_Lender_4__c , residenceStatus, add.Loan_Frequency_4__c);
        //getFinancialLiabilitie(fLiabilities, add.Loan_Type_5__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_5__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_5__c , scaleDecimal), 0,
								//				add.Other_Loans_Lender_5__c , residenceStatus, add.Loan_Frequency_5__c);
        //getFinancialLiabilitie(fLiabilities, add.Loan_Type_6__c, NumberUtils.convertDecimalToScale(add.Loans_Amount_Owing_6__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Loans_Monthly_Payments_6__c , scaleDecimal),0, 
								//				add.Other_Loans_Lender_6__c , residenceStatus,add.Loan_Frequency_6__c);
        
        //Credit cards
        // Lelo                     2019-03-19
        List<Application_Credit_Card__c> creditCardList =  ApplicationService.getApplicationCreditCards(opp.Application__c);
        for (Application_Credit_Card__c a : creditCardList) {
            getFinancialLiabilitie(fLiabilities, 'CREDIT_CARD', NumberUtils.convertDecimalToScale(a.Amount_Owing__c, scaleDecimal), 
                                                getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(a.Monthly_Payment__c , scaleDecimal), 
                                                NumberUtils.convertDecimalToScale(a.Limit__c , scaleDecimal),
                                                a.Issuer__c , residenceStatus, MONTHLY);
        }
        //getFinancialLiabilitie(fLiabilities, 'CREDIT_CARD', NumberUtils.convertDecimalToScale(add.Credit_Amount_Owing_1__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Credit_Monthly_Payments_1__c , scaleDecimal), 
        //                       					NumberUtils.convertDecimalToScale(add.Credit_Limit_1__c , scaleDecimal),
								//				add.Credit_Cards_1__c , residenceStatus, MONTHLY);
        //getFinancialLiabilitie(fLiabilities, 'CREDIT_CARD', NumberUtils.convertDecimalToScale(add.Credit_Amount_Owing_2__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Credit_Monthly_Payments_2__c , scaleDecimal), 
        //                       					NumberUtils.convertDecimalToScale(add.Credit_Limit_2__c , scaleDecimal),
								//				add.Credit_Cards_2__c , residenceStatus, MONTHLY);
        //getFinancialLiabilitie(fLiabilities, 'CREDIT_CARD', NumberUtils.convertDecimalToScale(add.Credit_Amount_Owing_3__c, scaleDecimal), 
								//				getAssetLink(seq++, fAssets), NumberUtils.convertDecimalToScale(add.Credit_Monthly_Payments_3__c , scaleDecimal), 
        //                       					NumberUtils.convertDecimalToScale(add.Credit_Limit_3__c , scaleDecimal),
								//				add.Credit_Cards_3__c , residenceStatus, MONTHLY);
        if (fLiabilities != null && fLiabilities.size() > 0 && fLiabilities.get(0) == null){
            fLiabilities = null;
        }
        return fLiabilities;
    }
    
    private McqCreditApplicationRequestDTO.Financial_Liabilities getFinancialLiabilitie (List<McqCreditApplicationRequestDTO.Financial_Liabilities> fLiabilities, String type_m, Decimal balance, 
                                                                                         //String asset_sequence_link, Decimal monthly_payment, Decimal creditLimit,
                                                                                         List<String> assetFound, Decimal monthly_payment, Decimal creditLimit,
                                                                                         String financier, String residenceStatus, String frequency){
        //if (type_m == null || financier == null || !(balance != 0 && monthly_payment != 0)){
        if (StringUtils.isNullOrEmpty(type_m) || StringUtils.isNullOrEmpty(financier)){
            return null;
        }
		String typeAsset = null;
        String asset_sequence_link = null;
        if (assetFound != null){
            typeAsset = assetFound.get(1);
            asset_sequence_link = assetFound.get(0);
        }
        Integer seq = fLiabilities.size() + 1;
        McqCreditApplicationRequestDTO.Financial_Liabilities financial_liabilities = new McqCreditApplicationRequestDTO.Financial_Liabilities();
        financial_liabilities.sequence = seq;
        financial_liabilities.type_m = findLiabilitieType (type_m, typeAsset);
        financial_liabilities.balance = balance;
        /**
        if (residenceStatus.containsIgnoreCase ('Own Outright')){
            financial_liabilities.asset_sequence_link = String.valueOf(seq);
        }**/
        financial_liabilities.asset_sequence_link = asset_sequence_link;
        financial_liabilities.monthly_payment = Utilities.getMonthlyValue(frequency, monthly_payment, scaleDecimal);
        String f = financier;
        if (f != null && f.length() > 10){
            f = financier.left(10);
        }
        financial_liabilities.financier = f;
		financial_liabilities.payout_flag = null;
        if (financial_liabilities.type_m.equalsIgnoreCase('MOTOR_VEHICLE_LOAN') && !existMorethanOneMotorVehicleLoan(fLiabilities)){
        	financial_liabilities.payout_flag = TRUE;
		}
        financial_liabilities.end_date = null;
        financial_liabilities.limit_amount = StringUtils.convertToString(creditLimit);
        fLiabilities.add(financial_liabilities);
        return financial_liabilities;
    }
    
    private Boolean existMorethanOneMotorVehicleLoan(List<McqCreditApplicationRequestDTO.Financial_Liabilities> fLiabilities){
        for (McqCreditApplicationRequestDTO.Financial_Liabilities f : fLiabilities){
            if (f.payout_flag){
                return true;
            }
        }
        return false;
    }
    
    private String findLiabilitieType (String type_m, String typeAsset){
        String t = 'INVESTMENT_PROPERTY_LOAN';
        if (type_m.equalsIgnoreCase('Mortgage')){
            if ('INVESTMENT_PROPERTY'.equalsIgnoreCase(typeAsset)){
                t = 'INVESTMENT_PROPERTY_LOAN';
            }else if ('RECREATIONAL_ASSET'.equalsIgnoreCase(typeAsset)){
                t = 'RECREATIONAL_ASSET_LOAN';
            }else if ('PLANT_AND_EQUIPMENT'.equalsIgnoreCase(typeAsset)){
                t = 'PLANT_AND_EQUIPMENT_LOAN';
            }else if ('SHARES_TRUSTS_FUNDS'.equalsIgnoreCase(typeAsset)){
                t = 'INVESTMENT_LOAN';
            }else{
                t = 'HOME_PROPERTY_LOAN';
            }
        }else if (type_m.equalsIgnoreCase('Car Loan')){
            t = 'MOTOR_VEHICLE_LOAN';
        }else if (type_m.equalsIgnoreCase('Personal Loan')){
            t = 'PERSONAL_LOAN';
        }else if (type_m.equalsIgnoreCase('Line of Credit')){
            t = 'OVERDRAFT';
        } else if (type_m.equalsIgnoreCase('CREDIT_CARD')){
            t = 'CREDIT_CARD';
        }
        return t;
    }
    
    public String convertToPhoneMacquarie(String value) {
        String n = '0000000000';
        if (value != null && String.isNotBlank(value)) {
            n = value.remove('$').remove(',').remove(' ').remove('.').remove('(').remove(')');
            n.leftPad(10, '0');
        } 
        return n;
    }
    
    /**
     private List<McqDocumentUploadRequestDTO> getAllDocumentUpload(Custom_Opportunity__c opp, String domainUrl, Boolean isConsumerLoan){
        Boolean typeUpload = false;
        List<McqDocumentUploadRequestDTO> documents = new List<McqDocumentUploadRequestDTO>();
        List<DragDropToCloud__Cloud_Documents__c> requiredDocList = new List<DragDropToCloud__Cloud_Documents__c>();
        if (typeUpload) {
			requiredDocList = [Select DragDropToCloud__Hidden_File_Name__c, DragDropToCloud__Hidden_File_Version_No__c, Document_Type__c, 
									  DragDropToCloud__Preview_Link__c, VD_Opportunity_Document__c, Is_VD_Type__c
							   from DragDropToCloud__Cloud_Documents__c where VD_Opportunity_Document__c = :opp.Id];
		} else {
			requiredDocList = [Select DragDropToCloud__Hidden_File_Name__c, DragDropToCloud__Hidden_File_Version_No__c, Document_Type__c, 
									  DragDropToCloud__Preview_Link__c, Custom_Opportunity__c, Is_VD_Type__c
							   from DragDropToCloud__Cloud_Documents__c where Custom_Opportunity__c = :opp.Id];
		}
        
        
        McqDocumentUploadRequestDTO mcqDocUploadRequest = null;
        for(DragDropToCloud__Cloud_Documents__c file : requiredDocList){
			mcqDocUploadRequest = new McqDocumentUploadRequestDTO();
            mcqDocUploadRequest.application_id = opp.Id;
            mcqDocUploadRequest.filename = file.DragDropToCloud__Hidden_File_Name__c;
            mcqDocUploadRequest.document_class = file.Document_Type__c;
            mcqDocUploadRequest.document_class = 'CREDIT_CHECK';
            String link = file.DragDropToCloud__Preview_Link__c;
            System.debug('Document link >>  ' + link + ' <<');
            String p = 'href="([^"]+).+?>(.+?)</a>';
            Matcher matcher = Pattern.compile(p).matcher(link);
            if (matcher.find()) {
                String sUrl = domainUrl + matcher.group(1);
                System.debug('<<Domain>>'+ sUrl + '- <<UrlDocuments>> ' + matcher.group()) ;
                mcqDocUploadRequest.file_content = CloudDocsHelper.fileDownLoad(opp.Id, mcqDocUploadRequest.filename);
            }
            mcqDocUploadRequest.author = 'MLPN_SCAN';
            mcqDocUploadRequest.description = null;
            mcqDocUploadRequest.comments = null;
            documents.add(mcqDocUploadRequest);
			//-
		}
        return documents;
    }
    
    private McqDocumentUploadRequestDTO getDocumentUpload(Custom_Opportunity__c opp, DragDropToCloud__Cloud_Documents__c file, String domainUrl, String mcqApplicantId){
        Boolean typeUpload = false;
        
        McqDocumentUploadRequestDTO mcqDocUploadRequest = null;
        mcqDocUploadRequest = new McqDocumentUploadRequestDTO();
        mcqDocUploadRequest.application_id = mcqApplicantId;
        mcqDocUploadRequest.filename = file.DragDropToCloud__Hidden_File_Name__c;
        //mcqDocUploadRequest.document_class = file.Document_Type__c;
        if (file.Document_Type__c != null){
             mcqDocUploadRequest.document_class =  Utilities.salesforceValueToMessageCode_Description(file.Document_Type__c, Utilities.McQ_DOCUMENTS_TYPE);
        }
        /**
        String link = file.DragDropToCloud__Preview_Link__c;
        System.debug('Document link >>  ' + link + ' <<');
        mcqDocUploadRequest.file_content = CloudDocsHelper.fileDownLoad(opp.Id, mcqDocUploadRequest.filename);
        /**
        String p = 'href="([^"]+).+?>(.+?)</a>';
        Matcher matcher = Pattern.compile(p).matcher(link);
        if (matcher.find()) {
            String sUrl = domainUrl + matcher.group(1);
            System.debug('<<Domain>>'+ sUrl + '- <<UrlDocuments>> ' + matcher.group()) ;
            
        }

        mcqDocUploadRequest.author = 'MLPN_SCAN';
        mcqDocUploadRequest.description = null;
        mcqDocUploadRequest.comments = null;
           
        return mcqDocUploadRequest;
    }
 

    
    public MacquarieManager requestDocumentUpload(MacquarieManager mcqManager, Custom_Opportunity__c opp, String domainURL, Boolean isConsumerLoan ){   
        
        System.debug('Debug DocumentUpload:::********************************************************** - I');
        List<McqDocumentUploadRequestDTO> documents = getAllDocumentUpload(opp, domainURL, isConsumerLoan);
        for (McqDocumentUploadRequestDTO doc : documents){
            executeDocumentUpload(mcqManager, doc.serialize(true));
        }
        System.debug('Debug DocumentUpload:::********************************************************** - F');        
        return mcqManager;
    }
    
    //Asyncrhon
    
    public void requestSelectDocumentUpload(Custom_Opportunity__c opp, List<DragDropToCloud__Cloud_Documents__c> requiredDocList, String domainURL, String mcqApplicationId){
        System.debug('Debug DocumentUpload:::********************************************************** - I');
        Map<String, String> sendDocs = new Map<String, String>();
        for (DragDropToCloud__Cloud_Documents__c doc : requiredDocList){
            if (doc.isChecked__c){
				sendDocs.put(doc.id, getDocumentUpload(opp, doc, domainURL, mcqApplicationId).serialize(true));
        	}
        }
        executeDocumentUpload(sendDocs);
        System.debug('Debug DocumentUpload:::********************************************************** - F'); 
    }
    private  void executeDocumentUpload(Map<String, String> requestDocumentSerialize){
        ConnectionRESTWs conn;
        MacquarieManager mcqManager = new MacquarieManager();
        List<DragDropToCloud__Cloud_Documents__c> listSave = new List<DragDropToCloud__Cloud_Documents__c>();
        for (String key : requestDocumentSerialize.keySet()){
            String body = requestDocumentSerialize.get(key);
            String message = '';
            Boolean isError = false;
            if (mcqManager.mcqAuthentication == null){
                try{
                    authentication(mcqManager);
                }catch (MacLeasePartnerException ex){
                    message = '> Error Macquarie Authentication Conexion.[' + ex.getMessage() +']<';
                    isError = true;
                }
            }
            if (!isError){                
                conn = new ConnectionRESTWs(endPointDocumentUpload, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
                HttpResponse resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
                validateResponse (resp, mcqManager);
                if (mcqManager.isError){
                    if (mcqManager.responseStatus == MacquarieConstants.STATUS_NOT_AUTHORIZED){
                        try{
                            authentication(mcqManager);
                            resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
                            validateResponse (resp, mcqManager);
                        }catch (Exception ex){
                            message = '> Error Macquarie Authentication Conexion.[' + ex.getMessage() +']<';
                            isError = true;
                        }
                    }else{
                        message = '>' + mcqManager.message +'<';
                        isError = true;
                    }
                }else{
                    resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
                    validateResponse (resp, mcqManager);
                    
                }
            }
            if (!isError){
                try{
                    System.debug('@ *DocumentUploadResponse*. -[' + mcqManager.responseMessage + ']');
                    mcqManager.parseCreateApplicationResponse(mcqManager.responseMessage);
                    message = mcqManager.mcqCreditAppResponse.message;
                }catch (MacLeasePartnerException ex){
                    mcqManager.isError = true;
                    mcqManager.message = ex.getMessage();
                    message = ex.getMessage();
                    throw new MacLeasePartnerException (mcqManager.message, ex);
                }
            }
            
            
            if (mcqManager.mcqError.errors != null){
                for (McqErrorResponse.ErrorsValidationData error : mcqManager.mcqError.errors){
                     message = '[' + error.getDescription() + ']';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,message));
                }
            }else if (mcqManager.mcqError.code != null){
                message = 'Code: [' + StringUtils.validateNull(mcqManager.mcqError.code) + '] - Error: [' + StringUtils.validateNull(mcqManager.mcqError.error) + ']- Message: [' + StringUtils.validateNull(mcqManager.mcqError.message) + ']';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message));
            }else{
                message = 'Status: [' + mcqManager.responseStatus + ']- Message: [' + StringUtils.validateNull(mcqManager.message) + ']- Response Message: [' + StringUtils.validateNull(mcqManager.responseMessage) + ']';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message));
            }
            
            System.debug('>>DragDropToCloud__Cloud_Documents__c : ' +  key + ' >>@Error Macquarie: ' + message);
            DragDropToCloud__Cloud_Documents__c cloud = new DragDropToCloud__Cloud_Documents__c();
            cloud.id = key;
            cloud.comments__c = message;
            listSave.add(cloud);
            
        }
        update listSave;
        
    }
    
    private MacquarieManager executeDocumentUpload(MacquarieManager mcqManager, String body){
        ConnectionRESTWs conn;
        if (mcqManager.mcqAuthentication == null){
            try{
                authentication(mcqManager);
            }catch (MacLeasePartnerException ex){
                throw new MacLeasePartnerException (mcqManager.message, ex);
            }
        }
        conn = new ConnectionRESTWs(endPointDocumentUpload, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
		HttpResponse resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
        validateResponse (resp, mcqManager);
        if (mcqManager.isError){
            if (mcqManager.responseStatus == MacquarieConstants.STATUS_NOT_AUTHORIZED){
                try{
                    authentication(mcqManager);
                    resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
            		validateResponse (resp, mcqManager);
                }catch (Exception ex){
                    throw new MacLeasePartnerException (mcqManager.message, ex);
                }
            }else{
                return mcqManager;
            }
        }else{
            resp = conn.connectionServiceHttpResponse(getHeadersServiceWithAuthorized(mcqManager.mcqAuthentication.access_token), body);
            validateResponse (resp, mcqManager);
            
        }
        
        try{
            System.debug('@ *DocumentUploadResponse*. -[' + mcqManager.responseMessage + ']');
            mcqManager.parseCreateApplicationResponse(mcqManager.responseMessage);
        }catch (MacLeasePartnerException ex){
            mcqManager.isError = true;
            mcqManager.message = ex.getMessage();
            throw new MacLeasePartnerException (mcqManager.message, ex);
        }
        return mcqManager;
    }
**/    
    
    
}