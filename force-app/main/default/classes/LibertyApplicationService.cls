public class LibertyApplicationService{
    
    public static final String SAVVY_NAME = 'Savvy';
    public static final String SCHEMA_NAME = 'Savvy_MotorApplicationBatchRequest';
    public String USERID = userinfo.getName();
    public String IDENTIFIER_TYPE = 'LenderAssigned'; //The Liberty (LenderAssigned) unique Identifier for the Broker or Broker Group
    public String IdSavvyApplication = '';
    public String TYPE_IDENTIFIER = 'BrokerAssigned';
    public String key = '$savvy';
    
    public static final String INCOME = 'Income';
    public static final String ASSET = 'Asset';
    public static final String EXPENSE = 'Expense';
    public static final String LIABILITY= 'Liability';
    public static final String EXISTING = 'EXISTING_';
    
    public static final String APPLICANTADDRESS1 = 'ApplicantAddress1';
    public static final String APPLICANTADDRESS2 = 'ApplicantAddress2';
    public static final String MAILING = '_MAILING';
    
    public static final String WEEKLY = 'Weekly';
    public static final String FORTNIGHTLY = 'Fortnightly';
    public static final String MONTHLY = 'Monthly';
    public static final String YEARLY = 'Yearly';
    public static final String ONEOFF = 'OneOff';
    
    public static final String FUTURE_CAR_ID = 'FutureCAR';

  Integer scaleDecimal = 2;
    
    public String IDENTIFIER_APPLICANT = '';
    
    public Map < String, List < Application_Employment__c >> prevEmplMap;
    
    public String requestApplication(Custom_Opportunity__c opp, Boolean isConsumerLoan, String user){
        if (StringUtils.isNullOrEmpty(user)){
            throw new GenericException ('Missing Liberty user. Please select one.');
        }
        IDENTIFIER_APPLICANT = 'ID_' + opp.id + '.' + System.currentTimeMillis();
        String body = getApplicationBatch(opp, isConsumerLoan, user);
        return body;
    }
    
    private String getApplicationBatch(Custom_Opportunity__c opp, Boolean isConsumerLoan, String user){
        opp = LibertyServiceManager.getCustomOpportunityForApplication(opp);
        Application__c add = opp.Application__r;
        Application_Quoting__c appQuoting;
        appQuoting = QuotingToolHelper.getApplicationQuoting(opp.Id, opp.Application__c);
        if (appQuoting == null){
            throw new LibertyServiceException('Dont exist any Application yet. Please fill all the fields before to send any App');
        }
        prevEmplMap = LibertyServiceManager.loadPreviousEmployments(opp);
        LibertyServiceManager.loadAddressFinanceDetails(opp);
        
        
        String xmlString = '';
        LibertyApplicationDTO.ApplicationBatch appBatch = new LibertyApplicationDTO.ApplicationBatch();
        //DocumentHeader -I
        appBatch.documentHeader = new LibertyApplicationDTO.DocumentHeader();
        LibertyApplicationDTO.SchemaName schemaName = new LibertyApplicationDTO.SchemaName();
        schemaName.parent = appBatch.parent;
        //schemaName.attb_type = 'xsd:string';
        schemaName.value = SCHEMA_NAME;
        appBatch.documentHeader.schemaName = schemaName;
        
        LibertyApplicationDTO.SchemaVersion schemaVersion = new LibertyApplicationDTO.SchemaVersion();
        schemaVersion.parent = appBatch.parent;
        //schemaVersion.attb_type = 'xsd:string';
        schemaVersion.value = 'v1_0';
        appBatch.documentHeader.schemaVersion = schemaVersion;        
        //DocumentHeader -F
        //
        
        //
        //Submission -I
        appBatch.submission = getSubmission();    
        
        //Submission -F
        //Identifier -I
        String identifierBacth = Utilities.getEncrypt(StringUtils.convertToString(opp.Id), '$idBacth');
        appBatch.identifier = getIdentifier(TYPE_IDENTIFIER, identifierBacth);
        //Identifier -F
        //Application -I
        appBatch.application = new LibertyApplicationDTO.Application();
        String loanProduct = appQuoting.Loan_Product__c;
        String loanType = appQuoting.Loan_Facility_Type__c;
        
        String appDocType = 'FullDoc'; //One of FullDoc LoDoc StartUp or ReplacementVehicle
        if('Chattel Mortgage-Full-Doc'.equalsIgnoreCase(loanProduct) && 'Commercial Star'.equalsIgnoreCase(loanType)){
            appDocType = 'FullDoc';
        }else if('Chattel Mortgage-Low-Doc'.equalsIgnoreCase(loanProduct) && 'Commercial Star'.equalsIgnoreCase(loanType)){
            appDocType = 'LoDoc';
        }else if ('Commercial Nova'.equalsIgnoreCase(loanType)){
            appDocType = 'StartUp';
        }
        
        String appType = 'CarLoan'; //Must be set to CarLoan
        appBatch.application.attb_docType = appDocType;
        appBatch.application.attb_type = appType;
        
        String identifierApp = Utilities.getEncrypt(StringUtils.convertToString(opp.Id), '$idApp');
        identifierApp = IDENTIFIER_APPLICANT;
        //Application-identifier -I 
        appBatch.application.identifier = getIdentifier(TYPE_IDENTIFIER, identifierApp);
        //Application-identifier -F
        //Application-Submission -I
        appBatch.application.submission = getSubmission();
        //Application-Submission -F
        //Application-Country - I
        appBatch.application.country = getCountry();
        //Application-Country _ F
        //Application-SalesChannel - I
        String identifierSalesChannelBrokerGroup = Utilities.getEncrypt(SAVVY_NAME, '');
        appBatch.application.salesChannelBrokerGroup = getSalesChannelBrokerGroup (identifierSalesChannelBrokerGroup);
        String identifierSalesChannel = Utilities.getEncrypt(opp.Dealer_Name__c, '$idSalesChannelBroker');
        appBatch.application.salesChannelBroker = getSalesChannelBroker(opp, identifierSalesChannel, user);
        //Application-SalesChannel - F
        //Application-SummaryData -I
        appBatch.application.summaryData = getSummaryData(add.No_of_People__c);
        //Application-SummaryData -F
        //Application-Comment - I
        appBatch.application.comment = getComment(add);
        //Application-Comment - F
        
        //Application-RelatedPartySegment    -I
        
        appBatch.application.relatedPartySegment = getRelatedPartySegment(opp, add, identifierApp, 'EmployerAddress_1');
        //Application-RelatedPartySegment   -F
        
        //Application-PartySegment - I
        //String identifierParty = Utilities.getEncrypt(add.id, '$idParty');
        
        LibertyApplicationDTO.FinancialSegment financialSegment = getFinancialSegment (appBatch.application, opp, add, appQuoting, identifierApp);
        
        List<String> incomeIds = new List<String>();
        /**
        for (LibertyApplicationDTO.ValueItem valueItem : financialSegment.valueItems ){
            if (valueItem != null && valueItem.identifier.attb_uniqueID.contains(INCOME)){
                incomeIds.add(valueItem.identifier.attb_uniqueID);
            }
        }
    **/
        incomeIds.add(INCOME + '007');
        appBatch.application.partySegment = getPartySegment(appBatch.application,add, identifierApp, incomeIds);
        //Application-PartySegment - F
        //
        
        //Application-AddressSegment -I
        appBatch.application.addressSegment = getAddressSegment (opp, add, identifierApp);
        //Application-AddressSegment -F
        
        
        
        //Application-DeclarationSegment  - I
        appBatch.application.declarationSegment = getDeclarationSegment(add, identifierApp);
        //Application DeclarationSegment  -F
        //Application-FinancialSegment  -I
        appBatch.application.financialSegment = financialSegment;
        //Application-FinancialSegment -F
        //Application-LoanDetailSegment   -I
        appBatch.application.loanDetailSegment = getLoanDetailSegment(opp, add, appQuoting, identifierApp);
        //Application-LoanDetailSegment  -F
        
        
        
        //Application -F
        
        xmlString = appBatch.getXmlApplicationBacth();
        /**
        String namespace = null;
        String prefix = null; //Always null for this process
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode rootNode = doc.createRootElement('ApplicationBatch', namespace, prefix);
        rootNode.setAttribute('xmlns:xsd', 'htt://www.w3.org/2001/XMLSchema');
        rootNode.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        //DocumentHeader
        Dom.Xmlnode documentHeader = rootNode.addChildElement('DocumentHeader', null, null);
        addNodeDocumentHeader(documentHeader);
        //Submission - I
        addNodeSubmission (rootNode);
        //Submission - F
        
        Application__c add = opp.Application__r;
        idSavvyApplication = CryptoUtils.encrypt(opp.Id + key);
        
        //Identifier - I
        String type_a = 'BrokerAssigned';
        String uniqueID_a = opp.Id;
        addNodeIdentifier(rootNode, type_a, uniqueID_a);
        //Identifier - F
        
        
        
        //Application - I
        //addNodeApplication (rootNode, opp, add); 
        getNodeApplication (rootNode, opp, add, isConsumerLoan);       
        //Application - F
        xmlString = doc.toXmlString();  
**/
        return xmlString;
    }
    
    private LibertyApplicationDTO.RelatedPartySegment getRelatedPartySegment(Custom_Opportunity__c opp, Application__c add, String identifier, String idAddress){
        LibertyApplicationDTO.RelatedPartySegment relatedPartySegment = new LibertyApplicationDTO.RelatedPartySegment();
        List<LibertyApplicationDTO.RelatedParty>  relatedParties = new List<LibertyApplicationDTO.RelatedParty>();
        relatedParties.add(getRelatedPartyEmployer(add, identifier, idAddress));
        if (!StringUtils.isNullOrEmpty(add.Start_Date_1__c) && !StringUtils.isNullOrEmpty(add.Previous_Employer_Name_1__c)){
            //relatedParties.add(getRelatedPartyRemainingEmployer ('ID_PREVIOUS_EMPLOYER_1', add.Previous_Employer_Name_1__c,add.Previous_Reference_Name_1__c, add.Previous_Employer_Phone_1__c, 
            //                                                                    null, 'PreviousEmployerAddress_1'));
            relatedParties.add(getRelatedPartyRemainingEmployer ('ID_PREVIOUS_EMPLOYER_1', add.Previous_Employer_Name_1__c,'Payroll', add.Previous_Employer_Phone_1__c, 
                                                                                 null, 'PreviousEmployerAddress_1'));
        }
        
        //Previous Employer Address
        //Previoues Employer Address Applicant 1
        Integer prevEmp = 2;
        List < Application_Employment__c > lst = prevEmplMap.get('1');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                relatedParties.add(getRelatedPartyRemainingEmployer ('ID_PREVIOUS_EMPLOYER_1_' + prevEmp, a.Employer_Name__c,'Payroll', a.Phone__c, 
                                                                                 null, 'PreviousEmployerAddress_1_' + prevEmp));
                prevEmp = prevEmp + 1;
            }
        }
        
        
        
        //relatedParties.add(getRelatedPartyVendor(opp, identifier));
        if (add.No_of_People__c == 2){
            //relatedParties.add(getRelatedPartyApplicant2 (add, identifier));
            relatedParties.add(getRelatedPartyEmployer_Applicant2(add, identifier, idAddress));

            prevEmp = 2;
            lst = prevEmplMap.get('2');
            if (lst != null) {
                for (Application_Employment__c a: lst) {
                    relatedParties.add(getRelatedPartyRemainingEmployer ('ID_PREVIOUS_EMPLOYER_2_' + prevEmp, a.Employer_Name__c,'Payroll', a.Phone__c, 
                                                                                     null, 'PreviousEmployerAddress_2_' + prevEmp));
                    prevEmp = prevEmp + 1;
                }
            }

        }
        relatedPartySegment.relatedParties = relatedParties;
        return relatedPartySegment;
    }
    
    private LibertyApplicationDTO.RelatedParty getRelatedPartyEmployer (Application__c add, String identifier, String idEmployerAddress){
        LibertyApplicationDTO.RelatedParty relatedParty = new LibertyApplicationDTO.RelatedParty();
        relatedParty.attb_RelPartyType = 'Employer';
        Boolean isPerson = false;
        if ('Personal'.equalsIgnoreCase(add.Application_Type__c)){
            isPerson = true;
        }
        if (!isPerson){
            relatedParty.company = getCompany (add, identifier);
        }
        //else{
            relatedParty.personName = getPersonName('', add.Current_Employer_Name_1__c, '', '');
        //}
        relatedParty.companyName = getCompanyName(add.Current_Employer_Name_1__c);
        relatedParty.relatedEntityRef = getRelatedEntityRef(idEmployerAddress);
        relatedParty.workPhone = getWorkPhone (add.Current_Employer_Phone_1__c);
        relatedParty.homePhone = getHomePhone (add.Current_Employer_Phone_1__c);
        relatedParty.identifier = getIdentifier ('BrokerAssigned','ID_EMPLOYER_1');
        LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
        email.value = add.Email_Address__c;
        relatedParty.email = email;
        return relatedParty;
    }

    private LibertyApplicationDTO.RelatedParty getRelatedPartyEmployer_Applicant2 (Application__c add, String identifier, String idEmployerAddress){
        LibertyApplicationDTO.RelatedParty relatedParty = new LibertyApplicationDTO.RelatedParty();
        relatedParty.attb_RelPartyType = 'Employer';
        Boolean isPerson = false;
        if ('Personal'.equalsIgnoreCase(add.Application_Type__c)){
            isPerson = true;
        }
        if (!isPerson){
            relatedParty.company = getCompany (add, identifier);
        }
        //else{
            relatedParty.personName = getPersonName('', add.Current_Employer_Name_2__c, '', '');
        //}
        relatedParty.companyName = getCompanyName(add.Current_Employer_Name_2__c);
        relatedParty.relatedEntityRef = getRelatedEntityRef(idEmployerAddress);
        relatedParty.workPhone = getWorkPhone (add.Current_Employer_Phone_2__c);
        relatedParty.homePhone = getHomePhone (add.Current_Employer_Phone_2__c);
        relatedParty.identifier = getIdentifier ('BrokerAssigned','ID_EMPLOYER_2');
        LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
        email.value = add.Email_Address_2__c;
        relatedParty.email = email;
        return relatedParty;
    }
    
    private LibertyApplicationDTO.RelatedParty getRelatedPartyRemainingEmployer (String identifier, String employerName, String contactName, String employerPhone, 
                                                                                 String employerEmail, String idEmployerAddress){
        LibertyApplicationDTO.RelatedParty relatedParty = new LibertyApplicationDTO.RelatedParty();
        relatedParty.attb_RelPartyType = 'Employer';
        relatedParty.personName = getPersonName('', contactName, '', '');
        relatedParty.companyName = getCompanyName(employerName);
        relatedParty.relatedEntityRef = getRelatedEntityRef(idEmployerAddress);
        relatedParty.workPhone = getWorkPhone (employerPhone);
        relatedParty.homePhone = getHomePhone (employerPhone);
        relatedParty.identifier = getIdentifier ('BrokerAssigned',identifier);
        if (!StringUtils.isNullOrEmpty(employerEmail)){
            LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
            email.value = employerEmail;
            relatedParty.email = email;
        }
        return relatedParty;
    }

    
    private LibertyApplicationDTO.RelatedParty getRelatedPartyVendor (Custom_Opportunity__c opp, String identifier){
        LibertyApplicationDTO.RelatedParty relatedParty = new LibertyApplicationDTO.RelatedParty();
        relatedParty.attb_RelPartyType = 'Vendor';
        relatedParty.personName = getPersonName('', opp.Dealer_Name__c, '', '');
        relatedParty.relatedEntityRef = getRelatedEntityRef('VendorAddress_1');
        relatedParty.identifier = getIdentifier ('BrokerAssigned','ID_VENDOR_1');
        return relatedParty;
    }
    
    private void getRelatedPartyReferee (List<LibertyApplicationDTO.RelatedParty>  relatedParties, String relPartyType, String fullName, String identifier, 
                                                                String relatedEntityRef, String phone){
        LibertyApplicationDTO.RelatedParty relatedParty = null;
        if (!StringUtils.isNullOrEmpty(relatedEntityRef) && !StringUtils.isNullOrEmpty(fullName)){
            relatedParty = new LibertyApplicationDTO.RelatedParty();
          relatedParty.attb_RelPartyType = relPartyType;
            relatedParty.identifier = getIdentifier ('BrokerAssigned',identifier);
          relatedParty.personName = getPersonName(null, fullName, '-', '-');
            relatedParty.relatedEntityRef = getRelatedEntityRef(relatedEntityRef);
            relatedParty.homePhone = getHomePhone (phone);
            relatedParties.add(relatedParty); 
        }
    }
    
    private LibertyApplicationDTO.RelatedParty getRelatedParty (String relPartyType, String businessName, String identifier, 
                                                                String relatedEntityRef, String isMortgLoan){
        LibertyApplicationDTO.RelatedParty relatedParty = null;
        
    if ('Y'.equals(isMortgLoan)) {
            relatedParty = new LibertyApplicationDTO.RelatedParty();
            relatedParty.attb_RelPartyType = relPartyType;
            relatedParty.companyName = getCompanyName(businessName);
            relatedParty.relatedEntityRef = getRelatedEntityRef(relatedEntityRef);
            relatedParty.identifier = getIdentifier ('BrokerAssigned',identifier);
            return relatedParty;
        }
        return null;
    }
    
    private LibertyApplicationDTO.CompanyName getCompanyName(String businessName){
        if (!(businessName != null && !businessName.equalsIgnoreCase(''))){
            return null;
        }
        LibertyApplicationDTO.CompanyName companyName = new LibertyApplicationDTO.CompanyName();
        companyName.attb_BusinessName = businessName;
        return companyName;
    }
    
    private LibertyApplicationDTO.RelatedParty getRelatedPartyApplicant2 (Application__c add, String identifier){
        LibertyApplicationDTO.RelatedParty relatedParty = new LibertyApplicationDTO.RelatedParty();
        relatedParty.attb_RelPartyType = 'Other';
        relatedParty.personName = getPersonName(add.Title_2__c, add.First_Name_2__c, add.Middle_Name_2__c, add.Last_Name_2__c);
        
        if ('Yes'.equalsIgnoreCase(add.Applicant_2_living_in_the_same_address__c)){
            relatedParty.relatedEntityRef = getRelatedEntityRef(APPLICANTADDRESS1);
        }else{
            relatedParty.relatedEntityRef = getRelatedEntityRef(APPLICANTADDRESS2);
        }
        relatedParty.identifier = getIdentifier ('BrokerAssigned','ID_APPLICANT_2');
        return relatedParty;
    }
    
    private LibertyApplicationDTO.AddressSegment getAddressSegment (Custom_Opportunity__c opp, Application__c add, String identifierApp){
        LibertyApplicationDTO.AddressSegment addressSegment = new LibertyApplicationDTO.AddressSegment ();
        List<LibertyApplicationDTO.AddressWrapper> addressWrappers = new List<LibertyApplicationDTO.AddressWrapper>();
        
        getAddressWrappers_Applicant_1 (addressWrappers, opp, add);
        if (!'Yes'.equalsIgnoreCase(Opp.Application__r.Applicant_2_living_in_the_same_address__c)){
            getAddressWrappers_Applicant_2 (addressWrappers, opp, add);
        }
        
        if (!StringUtils.isNullOrEmpty(add.Current_Work_Street_Number_1__c )){
          addressWrappers.add(getAddressWrapper('EmployerAddress_1', add.Current_Work_Unit_Number_1__c, add.Current_Work_Street_Number_1__c, 
                                              add.Current_Work_Address_1__c, add.Current_Work_Suburb_1__c, 
                                             'AU', add.Current_Work_Postcode_1__c, add.Current_Work_State_1__c, add.Current_Work_Street_Type_1__c, true, null));
        }   
        if (!StringUtils.isNullOrEmpty(add.Previous_Work_Street_Number_1__c )){
          addressWrappers.add(getAddressWrapper('PreviousEmployerAddress_1', add.Previous_Work_Unit_Number_1__c, add.Previous_Work_Street_Number_1__c, 
                                              add.Previous_Work_Address_1__c, add.Previous_Work_Suburb_1__c, 
                                             'AU', add.Previous_Work_Postcode_1__c, add.Previous_Work_State_1__c, add.Previous_Work_Street_Type_1__c, true, null));
        }
        
        //Previoues Employer Address Applicant 1
        Integer prevEmp = 2;
        List < Application_Employment__c > lst = prevEmplMap.get('1');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                addressWrappers.add(getAddressWrapper('PreviousEmployerAddress_1_' + prevEmp, a.Unit_Number__c, a.Street_Number__c, 
                                              a.Work_Address__c, a.Suburb__c, 
                                             'AU', a.Postcode__c, a.State__c, a.Street_Type__c, true, null));
                prevEmp = prevEmp + 1;
            }
        }
        
        
        
        if (!StringUtils.isNullOrEmpty(opp.Dealer_Street_Number__c )){
            addressWrappers.add(getAddressWrapper('VendorAddress_1', opp.Dealer_Unit_Number__c, opp.Dealer_Street_Number__c, 
                                              opp.Dealer_Address__c, opp.Dealer_Suburb__c, 
                                             'AU', opp.Dealer_Postcode__c, opp.Dealer_State__c, opp.Dealer_Street_Type__c, true, null));
        }
        
        if (!StringUtils.isNullOrEmpty(add.Street_Number_2__c )){
            addressWrappers.add(getAddressWrapper('ApplicantAddress_2', add.Unit_Number_2__c, add.Street_Number_2__c, add.Street_Address_2__c, 
                                              add.Suburb_2__c, 'AU', add.Postcode_2__c, 
                                              add.Driver_Licence_State_Issue_2__c,add.Street_Type_2__c, true, null));
        }
        
        if (!StringUtils.isNullOrEmpty(add.Previous_Work_Street_Number_2__c )){
          addressWrappers.add(getAddressWrapper('PreviousEmployerAddress_2', add.Previous_Work_Unit_Number_2__c, add.Previous_Work_Street_Number_2__c, 
                                              add.Previous_Work_Address_2__c, add.Previous_Work_Suburb_2__c, 
                                             'AU', add.Previous_Work_Postcode_2__c, add.Previous_Work_State_2__c, add.Previous_Work_Street_Type_2__c, true, null));
        }
        
        //Previoues Employer Address Applicant 2
        prevEmp = 2;
        lst = prevEmplMap.get('2');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                addressWrappers.add(getAddressWrapper('PreviousEmployerAddress_2_' + prevEmp, a.Unit_Number__c, a.Street_Number__c, 
                                              a.Work_Address__c, a.Suburb__c, 
                                             'AU', a.Postcode__c, a.State__c, a.Street_Type__c, true, null));
                prevEmp = prevEmp + 1;
            }
        }
        
        /** Personal Reference is not requiered in LoanNet.
        if (!StringUtils.isNullOrEmpty(add.Personal_Reference_1_Address__c) && !StringUtils.isNullOrEmpty(add.Personal_Reference_1_Full_Name__c )){
            AddressSplit adSplit = getAddressSplit (add.Personal_Reference_1_Address__c);
            addressWrappers.add(getAddressWrapper('RefereeAddress_1', adSplit.tUnitNumber, adSplit.tStreetNo, adSplit.tStreetName,  
                                              adSplit.tSuburb, 'AU', adSplit.tPostCode, 
                                              adSplit.tState, adSplit.tStreetType, true, null));
        }
        if (!StringUtils.isNullOrEmpty(add.Personal_Reference_2_Address__c) && !StringUtils.isNullOrEmpty(add.Personal_Reference_2_Full_Name__c )){
            AddressSplit adSplit = getAddressSplit (add.Personal_Reference_2_Address__c);
            addressWrappers.add(getAddressWrapper('RefereeAddress_2', adSplit.tUnitNumber, adSplit.tStreetNo, adSplit.tStreetName,  
                                              adSplit.tSuburb, 'AU', adSplit.tPostCode, 
                                              adSplit.tState, adSplit.tStreetType, true, null));
        }
    **/
        //PropertyAddress section -HHJJ
        // Lelo                     2019-03-22
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(opp.Application__c, ApplicationService.PROPERTY_ASSET_TYPE);
        Integer count = 1;
        for (Application_Other_Asset__c a: d) {
            AddressSplit adSplit = getAddressSplit (a.Description__c);
            addressWrappers.add(getAddressWrapper('AssetPropertyAddress_' + count, adSplit.tUnitNumber, adSplit.tStreetNo, adSplit.tStreetName,  
                                              adSplit.tSuburb, 'AU', adSplit.tPostCode, 
                                              adSplit.tState, adSplit.tStreetType, true, null));
            count++;
        }        
        //
        
        addressSegment.addressWrappers = addressWrappers;
        
        return addressSegment;
    }
    
    private AddressSplit getAddressSplit (String address){
        if (address == null){
            return null;
        }
        List<String> sp = address.split('\\|');
        if (sp.size() != 7){
            throw new GenericException ('Address data is not complete on sections: Liabilities - Address: ' + address);
        }
        AddressSplit newAddress = new AddressSplit();
        newAddress.tUnitNumber = StringUtils.validateNull(sp.get(0));
        newAddress.tStreetNo = StringUtils.validateNull(sp.get(1));
        newAddress.tStreetName = StringUtils.validateNull(sp.get(2));
        newAddress.tStreetType = StringUtils.validateNull(sp.get(3));
        newAddress.tSuburb = StringUtils.validateNull(sp.get(4));
        newAddress.tState = StringUtils.validateNull(sp.get(5));
        newAddress.tPostCode = StringUtils.validateNull(sp.get(6));
        
        //::Validate before send through Liberty API::
        if (StringUtils.isNullOrEmpty(newAddress.tStreetNo)){
            throw new GenericException ('Street Number field is required for all address before send through Liberty API (Liability).');
        }
        return newAddress;
    }
    
    private List<LibertyApplicationDTO.AddressWrapper> getAddressWrappers_Applicant_1 (List<LibertyApplicationDTO.AddressWrapper> addressWrappers, Custom_Opportunity__c opp, Application__c add){
        addressWrappers.add(getAddressWrapper(APPLICANTADDRESS1, add.Unit_Number__c, add.Street_Number__c, add.Street_Address__c, 
                                              add.Suburb__c, 'AU', add.Postcode__c, 
                                              add.Driver_Licence_State_Issue_1__c, add.Street_Type__c, true, null));
        //if (!'Personal'.equalsIgnoreCase(add.Application_Type__c)){
            addressWrappers.add(getAddressWrapper(APPLICANTADDRESS1 +  MAILING, add.Unit_Number__c, add.Street_Number__c, add.Street_Address__c, 
                                              add.Suburb__c, 'AU', add.Postcode__c, 
                                              add.Driver_Licence_State_Issue_1__c, add.Street_Type__c, true, null));
        //}
        /**
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        Integer months = null;
        if (movedIn != null){
            Integer movedInYears = DateUtils.getHowManyYears(movedIn, System.today());
            Integer movedInMonths = DateUtils.getHowManyMonths(movedIn, System.today());
            months = (movedInYears * 12) + movedInMonths;
        }
        if (months != null && months < 24 &&
           !StringUtils.isNullOrEmpty(add.Previous_State_1__c) && !StringUtils.isNullOrEmpty(add.Previous_Street_Address_1__c)){
  **/
               if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_1', add.Previous_Unit_Number_1__c, add.Previous_Street_Number_1__c, 
                                                      add.Previous_Street_Address_1__c, add.Previous_Suburb_1__c, add.Previous_Country_1__c, 
                                                      add.Previous_Postcode_1__c, add.Previous_State_1__c, add.Previous_Street_Type_1__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1b__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_1b', add.Previous_Unit_Number_1b__c, add.Previous_Street_Number_1b__c, 
                                                      add.Previous_Street_Address_1b__c, add.Previous_Suburb_1b__c, add.Previous_Country_1b__c, 
                                                      add.Previous_Postcode_1b__c, add.Previous_State_1b__c, add.Previous_Street_Type_1b__c ,true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1c__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_1c', add.Previous_Unit_Number_1c__c, add.Previous_Street_Number_1c__c, 
                                                      add.Previous_Street_Address_1c__c, add.Previous_Suburb_1c__c, add.Previous_Country_1c__c, 
                                                      add.Previous_Postcode_1c__c, add.Previous_State_1c__c, add.Previous_Street_Type_1c__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1d__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_1d', add.Previous_Unit_Number_1d__c, add.Previous_Street_Number_1d__c, 
                                                      add.Previous_Street_Address_1d__c, add.Previous_Suburb_1d__c, add.Previous_Country_1d__c, 
                                                      add.Previous_Postcode_1d__c, add.Previous_State_1d__c, add.Previous_Street_Type_1d__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1e__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_1e', add.Previous_Unit_Number_1e__c, add.Previous_Street_Number_1e__c, 
                                                      add.Previous_Street_Address_1e__c, add.Previous_Suburb_1e__c, add.Previous_Country_1e__c, 
                                                      add.Previous_Postcode_1e__c, add.Previous_State_1e__c, add.Previous_Street_Type_1e__c, true, null));
                }
        //}
        return addressWrappers;
    }

    private List<LibertyApplicationDTO.AddressWrapper> getAddressWrappers_Applicant_2 (List<LibertyApplicationDTO.AddressWrapper> addressWrappers, Custom_Opportunity__c opp, Application__c add){
        if (add.No_of_People__c == 2){
        addressWrappers.add(getAddressWrapper(APPLICANTADDRESS2, add.Unit_Number_2__c, add.Street_Number_2__c, add.Street_Address_2__c, 
                                                      add.Suburb_2__c, 'AU', add.Postcode_2__c, 
                                                      add.Driver_Licence_State_Issue_2__c, add.Street_Type_2__c, true, null));
            addressWrappers.add(getAddressWrapper(APPLICANTADDRESS2 + MAILING, add.Unit_Number_2__c, add.Street_Number_2__c, add.Street_Address_2__c, 
                                                      add.Previous_Suburb_2__c, 'AU', add.Postcode_2__c, 
                                                      add.Driver_Licence_State_Issue_2__c, add.Previous_Street_Type_2__c, true, null));
        }
        //}
        /**
        Date movedIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        Integer months = null;
        if (movedIn != null){
            Integer movedInYears = DateUtils.getHowManyYears(movedIn, System.today());
            Integer movedInMonths = DateUtils.getHowManyMonths(movedIn, System.today());
            months = (movedInYears * 12) + movedInMonths;
        }
        if (months != null && months < 24 &&
           !StringUtils.isNullOrEmpty(add.Previous_State_1__c) && !StringUtils.isNullOrEmpty(add.Previous_Street_Address_1__c)){
  **/
               if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2', add.Previous_Unit_Number_2__c, add.Previous_Street_Number_2__c, 
                                                      add.Previous_Street_Address_2__c, add.Previous_Suburb_2__c, add.Previous_Country_2__c, 
                                                      add.Previous_Postcode_2__c, add.Previous_State_2__c, add.Previous_Street_Type_2__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2b__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2b', add.Previous_Unit_Number_2b__c, add.Previous_Street_Number_2b__c, 
                                                      add.Previous_Street_Address_2b__c, add.Previous_Suburb_2b__c, add.Previous_Country_2b__c, 
                                                      add.Previous_Postcode_2b__c, add.Previous_State_2b__c, add.Previous_Street_Type_2b__c ,true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2c__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2c', add.Previous_Unit_Number_2c__c, add.Previous_Street_Number_2c__c, 
                                                      add.Previous_Street_Address_2c__c, add.Previous_Suburb_2c__c, add.Previous_Country_2c__c, 
                                                      add.Previous_Postcode_2c__c, add.Previous_State_2c__c, add.Previous_Street_Type_2c__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2d__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2d', add.Previous_Unit_Number_2d__c, add.Previous_Street_Number_2d__c, 
                                                      add.Previous_Street_Address_2d__c, add.Previous_Suburb_2d__c, add.Previous_Country_2d__c, 
                                                      add.Previous_Postcode_2d__c, add.Previous_State_2d__c, add.Previous_Street_Type_2d__c, true, null));
                }
                if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2e__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2e', add.Previous_Unit_Number_2e__c, add.Previous_Street_Number_2e__c, 
                                                      add.Previous_Street_Address_2e__c, add.Previous_Suburb_2e__c, add.Previous_Country_2e__c, 
                                                      add.Previous_Postcode_2e__c, add.Previous_State_2e__c, add.Previous_Street_Type_2e__c, true, null));
                }
        //}
        return addressWrappers;
    }
    
    /**
    private List<LibertyApplicationDTO.AddressWrapper> getAddressWrappers_Applicant_2 (List<LibertyApplicationDTO.AddressWrapper> addressWrappers, Custom_Opportunity__c opp, Application__c add){
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2__c )){
            addressWrappers.add(getAddressWrapper(APPLICANTADDRESS2, add.Unit_Number_2__c, add.Street_Number_2__c, add.Street_Address_2__c, 
                                                      add.Suburb_2__c, 'AU', add.Postcode_2__c, 
                                                      add.Driver_Licence_State_Issue_2__c, add.Street_Type_2__c, true, null));
            addressWrappers.add(getAddressWrapper(APPLICANTADDRESS2 + MAILING, add.Unit_Number_2__c, add.Street_Number_2__c, add.Street_Address_2__c, 
                                                      add.Previous_Suburb_2__c, 'AU', add.Postcode_2__c, 
                                                      add.Driver_Licence_State_Issue_2__c, add.Previous_Street_Type_2__c, true, null));
        }
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2b__c )){
            addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2b', add.Previous_Unit_Number_2b__c, add.Previous_Street_Number_2b__c, 
                                                      add.Previous_Street_Address_2b__c, add.Previous_Suburb_2b__c, add.Previous_Country_2b__c, 
                                                      add.Previous_Postcode_2b__c, add.Previous_State_2b__c, add.Previous_Street_Type_2b__c,  true, null));
        }
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2c__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2c', add.Previous_Unit_Number_2c__c, add.Previous_Street_Number_2c__c, 
                                                      add.Previous_Street_Address_2c__c, add.Previous_Suburb_2c__c, add.Previous_Country_2c__c, 
                                                      add.Previous_Postcode_2c__c, add.Previous_State_2c__c, add.Previous_Street_Type_2c__c, true, null));
        }
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2d__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2d', add.Previous_Unit_Number_2d__c, add.Previous_Street_Number_2d__c, 
                                                      add.Previous_Street_Address_2d__c, add.Previous_Suburb_2d__c, add.Previous_Country_2d__c, 
                                                      add.Previous_Postcode_2d__c, add.Previous_State_2d__c, add.Previous_Street_Type_2d__c, true, null));
        }
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2e__c )){
                    addressWrappers.add(getAddressWrapper('ApplicantPreviousAddress_2e', add.Previous_Unit_Number_2e__c, add.Previous_Street_Number_2e__c, 
                                                      add.Previous_Street_Address_2e__c, add.Previous_Suburb_2e__c, add.Previous_Country_2e__c, 
                                                      add.Previous_Postcode_2e__c, add.Previous_State_2e__c, add.Previous_Street_Type_2e__c, true, null));
        }
        return addressWrappers;
    }**/
    
    private LibertyApplicationDTO.AddressWrapper getAddressWrapper (String idAddress, String sUnitNo, String sStreetNo, String sStreet, String sCity, 
                                                      String sCountry, String sPostcode, String sState, String sType, Boolean isStandard, String sNonStandard){
        LibertyApplicationDTO.AddressWrapper addressWrapper = new LibertyApplicationDTO.AddressWrapper ();
        addressWrapper.identifier = getIdentifier ('BrokerAssigned', idAddress);
        addressWrapper.address = getAddress (sUnitNo, sStreetNo, sStreet, sCity, sCountry, sPostcode, sState, sType, isStandard, sNonStandard);
        return addressWrapper;
    }
    
    private LibertyApplicationDTO.Identifier getIdentifier(String attb_type, String attb_uniqueID){
        LibertyApplicationDTO.Identifier identifier = new LibertyApplicationDTO.Identifier();
        identifier.attb_type = attb_type;
        identifier.attb_uniqueID = attb_uniqueID;
        return identifier;
    }
    
    private LibertyApplicationDTO.Submission getSubmission (){
        LibertyApplicationDTO.Submission submission = new LibertyApplicationDTO.Submission();
        DateTime dDate = System.now();
        String date_e = DateUtils.convertToString(dDate, DateUtils.YYYY_MM_DD);
        String time_e = DateUtils.convertToString(dDate, DateUtils.hhmmss);
        LibertyApplicationDTO.EDate  eDate = new LibertyApplicationDTO.EDate();
        eDate.value = date_e;
        LibertyApplicationDTO.ETime eTime = new LibertyApplicationDTO.ETime();
        eTime.value = time_e;
        submission.eDate = eDate;
        submission.eTime = eTime;
        return submission;
    }
    
    private LibertyApplicationDTO.SummaryData getSummaryData(Decimal numberOfApplicants){
        LibertyApplicationDTO.SummaryData summaryData = new LibertyApplicationDTO.SummaryData();
        summaryData.attb_numberOfApplicants = numberOfApplicants;
        summaryData.attb_numberOfLoans = '1';
        summaryData.attb_numberOfSecurities = '1';
        return summaryData;
    }
    
    private LibertyApplicationDTO.Comment getComment(Application__c add){
        LibertyApplicationDTO.Comment comment = new LibertyApplicationDTO.Comment();
        comment.value = LibertyServiceManager.getLenderComments(add.Id);
        return comment;
    }
    
    /**
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
    **/
    
    private LibertyApplicationDTO.Country getCountry(){
        LibertyApplicationDTO.Country country = new LibertyApplicationDTO.Country();
        country.attb_ISO3166 = 'AU';
        return country;
    }
    
    private LibertyApplicationDTO.SalesChannel getSalesChannelBrokerGroup (String identifierSalesChannel){
        LibertyApplicationDTO.SalesChannel salesChannel = new LibertyApplicationDTO.SalesChannel();
        salesChannel.attb_salesChannelDescription  = 'BrokerGroup';
        salesChannel.identifier = getIdentifier ('LenderAssigned', 'Savvy');
        return salesChannel;
    }
    
    private LibertyApplicationDTO.SalesChannel getSalesChannelBroker (Custom_Opportunity__c opp, String identifierSalesChannel, String user){
        LibertyApplicationDTO.SalesChannel salesChannel = new LibertyApplicationDTO.SalesChannel();
        salesChannel.attb_salesChannelType  = 'Broker';
        //salesChannel.identifier = getIdentifier ('LenderAssigned', 'NFCH0162' );
        salesChannel.identifier = getIdentifier ('LenderAssigned', user );
        return salesChannel;
    }
    
    private LibertyApplicationDTO.PartySegment getPartySegment (LibertyApplicationDTO.Application app, Application__c add, String identifierParty, List<String> incomeIds){
        LibertyApplicationDTO.PartySegment partySegment = new LibertyApplicationDTO.PartySegment();
        String typeParty = 'Applicant';
        Boolean isPerson = false;
        if ('Personal'.equalsIgnoreCase(add.Application_Type__c)){
            isPerson = true;
        }
        LibertyApplicationDTO.Party partyPerson = new LibertyApplicationDTO.Party();
        partyPerson.attb_type = typeParty;
        partyPerson.identifier = getIdentifier ('BrokerAssigned', identifierParty);
        partyPerson.person = getPerson(app, add, identifierParty, incomeIds);
        partySegment.parties = new List<LibertyApplicationDTO.Party>();
        partySegment.parties.add(partyPerson);
        if(!isPerson){
            typeParty = 'Guarantor';
            LibertyApplicationDTO.Party partyCompany = new LibertyApplicationDTO.Party();
            partyCompany.attb_type = typeParty;
            partyCompany.identifier = getIdentifier ('BrokerAssigned', identifierParty);
            partyCompany.company = getCompany ( add, identifierParty);
            partySegment.parties.add(partyCompany);
        }

        //Second Applicant
        if (add.No_of_People__c == 2){
            LibertyApplicationDTO.Party partySecondPerson = new LibertyApplicationDTO.Party();
            partySecondPerson.attb_type = typeParty;
            String identifierParty_2 = identifierParty + '_2';
            partySecondPerson.identifier = getIdentifier ('BrokerAssigned', identifierParty_2);
            List<String> incomeIds2 = new List<String>();
            partySecondPerson.person = getPerson2(app, add, identifierParty_2, incomeIds2);
            partySegment.parties.add(partySecondPerson);
        }
        return partySegment;
    }

    private LibertyApplicationDTO.Person getPerson (LibertyApplicationDTO.Application app, Application__c add, String identifierParty, List<String> incomeIds){
        String identifierPerson = Utilities.getEncrypt(StringUtils.convertToString(add.id), '$idPerson');
        LibertyApplicationDTO.Person person = new LibertyApplicationDTO.Person();
        String gender = 'Male';
        if ('F'.equalsIgnoreCase (add.Gender_1__c)){
            gender = 'Female';
        }
        person.attb_sex = gender;
        String housingStatus= add.Current_Residence_Status_1__c;
        person.contactDetails = getContactDetails (add, housingStatus);
        
        LibertyApplicationDTO.DateOfBirth dateOfBirth = new LibertyApplicationDTO.DateOfBirth();
        LibertyApplicationDTO.DateE dateBirth = new LibertyApplicationDTO.DateE(DateUtils.formatDate(add.Date_of_Birth_1__c, DateUtils.YYYY_MM_DD));
        dateOfBirth.dateE = dateBirth;
        person.dateOfBirth = dateOfBirth;
        
        if (add.Ages_of_Dependants_1__c != null){
            person.dependents = getDependents (add.Ages_of_Dependants_1__c);
        }
       
        person.driversLicence = getDriversLicence(add.Drivers_License_1__c, add.Expiry_Date_1__c, add.Type_of_Licence_1__c, add.Driver_Licence_State_Issue_1__c);
        
        person.employments = new List<LibertyApplicationDTO.Employment>();

        validateExceptionNull (add.Mode_of_Employment_1__c, 'Employment Type');
        String employmentType = Utilities.salesforceValueToMessageCode_Description(add.Mode_of_Employment_1__c, Utilities.LiB_EMPLOYMENT_TYPES); 
        person.employments.add(getEmployment('ID_EMPLOYER_1', employmentType, add.Date_Started_1__c , null ,add.Current_Occupation_1__c, incomeIds));
        
        //if(add.Previous_Mode_of_Employment_1__c != null && !''.equalsIgnoreCase(add.Previous_Mode_of_Employment_1__c)){
        if (!StringUtils.isNullOrEmpty(add.Start_Date_1__c) && !StringUtils.isNullOrEmpty(add.Previous_Employer_Name_1__c)){
            validateExceptionNull (add.Previous_Mode_of_Employment_1__c, 'Employment Type');
            String previousEmploymentType = Utilities.salesforceValueToMessageCode_Description(add.Previous_Mode_of_Employment_1__c, Utilities.LiB_EMPLOYMENT_TYPES); 
            List<String> incomeIds2 = new List<String>(); 
            person.employments.add(getEmployment('ID_PREVIOUS_EMPLOYER_1', previousEmploymentType, add.Start_Date_1__c, add.Finish_Date_1__c ,add.Previous_Occupation_1__c, incomeIds2));
        }
        
        //Previous Employer Address
        //Previoues Employer Address Applicant 1
        Integer prevEmp = 2;
        List < Application_Employment__c > lst = prevEmplMap.get('1');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                validateExceptionNull (a.Employment_Type__c, 'Employment Type');
                String previousEmploymentType = Utilities.salesforceValueToMessageCode_Description(a.Employment_Type__c, Utilities.LiB_EMPLOYMENT_TYPES); 
                List<String> incomeIds2 = new List<String>(); 
                System.debug ('ID_PREVIOUS_EMPLOYER_1_' + prevEmp + '-' + previousEmploymentType + '-' + a.Start_Date__c + '-' + a.Finish_Date__c + '-' + a.Occupation__c);
              person.employments.add(getEmployment('ID_PREVIOUS_EMPLOYER_1_' + prevEmp, previousEmploymentType, DateUtils.convertToString(a.Start_Date__c, DateUtils.ddMMyyyy), DateUtils.convertToString(a.Finish_Date__c,DateUtils.ddMMyyyy) ,a.Occupation__c, incomeIds2));
                prevEmp = prevEmp + 1;
            }
        }
        
        person.maritalStatus = getMaritalStatus(identifierPerson, add.Marital_Status_1__c);
        
        
        List<LibertyApplicationDTO.PersonalReference> personalReferences = new List<LibertyApplicationDTO.PersonalReference>();
        
        String referenceType1 = 'Personal';
        
        /** Personal reference is not required in LoanNet
        getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_1', referenceType1, add.Personal_Reference_1_Relationship__c, add.Personal_Reference_1_Full_Name__c, 'RefereeAddress_1', add.Personal_Reference_1_Phone__c);
        getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_2', 'Relative', add.Personal_Reference_2_Relationship__c, add.Personal_Reference_2_Full_Name__c, 'RefereeAddress_2', add.Personal_Reference_2_Phone__c);
    **/        

        //if (housingStatus != null && !housingStatus.equalsIgnoreCase('Mortgage')){
            referenceType1 = 'Agent';
            getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_AGENT_1', referenceType1, 'Real Estate', add.Landlord_Name_1__c, 'ApplicantAddress1', add.Landlord_Phone_1__c);
        //}
        
        person.personalReferences = personalReferences;
    
        
        person.personName = getPersonName(add.Title_1__c, add.First_Name__c, add.Middle_Name__c, add.Last_Name__c);
        
        person.residency = getResidency (add.Actual_Nationality_1__c, add.Current_Residential_Status_1__c);
        return person;
    }
    
    private List<LibertyApplicationDTO.Dependent> getDependents (String ages){
        List<LibertyApplicationDTO.Dependent> dependents = null;
        if (ages != null){
            List<String> ag = ages.trim().split('\\D{1,}');
            if (ag != null && ag.size() > 0){
                dependents = new List<LibertyApplicationDTO.Dependent>();
                for (String a : ag){
                    LibertyApplicationDTO.Dependent dependent = new LibertyApplicationDTO.Dependent();
                    dependent.attb_Age = StringUtils.convertToString(Math.roundToLong(Integer.valueOf(a)));
                    dependents.add(dependent);
                }
            }
        }
        return dependents;
    }
    
    /**
    private LibertyApplicationDTO.Person getPerson2 (Application__c add, String identifierParty){
        String identifierPerson = Utilities.getEncrypt(StringUtils.convertToString(add.id), '$idPerson');
        LibertyApplicationDTO.Person person = new LibertyApplicationDTO.Person();
        String gender = 'Male';
        if ('F'.equalsIgnoreCase (add.Gender_2__c)){
            gender = 'Female';
        }
        person.attb_sex = gender;
        person.contactDetails = getContactDetails2 (add);
        
        LibertyApplicationDTO.DateOfBirth dateOfBirth = new LibertyApplicationDTO.DateOfBirth();
        LibertyApplicationDTO.DateE dateBirth = new LibertyApplicationDTO.DateE(DateUtils.formatDate(add.Date_of_Birth_2__c, DateUtils.YYYY_MM_DD));
        dateOfBirth.dateE = dateBirth;
        person.dateOfBirth = dateOfBirth;
        
        if (add.Ages_of_Dependants_2__c != null){
            person.dependents = getDependents (add.Ages_of_Dependants_2__c);
        }
        
        person.driversLicence = getDriversLicence(add.Drivers_License_2__c, add.Expiry_Date_2__c, add.Type_of_Licence_2__c, add.Driver_Licence_State_Issue_2__c);
        
        person.employments = new List<LibertyApplicationDTO.Employment>();
        person.employments.add(getEmployment(identifierPerson, add.Mode_of_Employment_2__c, add.Date_Started_2__c, null ,add.Current_Occupation_2__c, null));
        
        person.maritalStatus = getMaritalStatus(identifierPerson, add.Marital_Status_2__c);
        
        
        //List<LibertyApplicationDTO.PersonalReference> personalReferences = new List<LibertyApplicationDTO.PersonalReference>();
        //getPersonalReference (personalReferences, 'ID_APPLICANT_2', 'Agent', 'Personal');
        //getPersonalReference (personalReferences, 'ID_APPLICANT_2', 'Agent', 'Relative');
        //person.personalReferences = personalReferences;
        
        
        person.personName = getPersonName(add.Title_2__c, add.First_Name_2__c, add.Middle_Name_2__c, add.Last_Name_2__c);
        
        person.residency = getResidency (add.Actual_Nationality_2__c, add.Current_Residential_Status_2__c);
        return person;
    }**/


    private LibertyApplicationDTO.Person getPerson2 (LibertyApplicationDTO.Application app, Application__c add, String identifierParty, List<String> incomeIds){
        String identifierPerson = Utilities.getEncrypt(StringUtils.convertToString(add.id), '$idPerson');
        LibertyApplicationDTO.Person person = new LibertyApplicationDTO.Person();
        String gender = 'Male';
        if ('F'.equalsIgnoreCase (add.Gender_2__c)){
            gender = 'Female';
        }
        person.attb_sex = gender;
        String housingStatus= add.Current_Residence_Status_2__c;
        person.contactDetails = getContactDetails2 (add, housingStatus);
        
        LibertyApplicationDTO.DateOfBirth dateOfBirth = new LibertyApplicationDTO.DateOfBirth();
        LibertyApplicationDTO.DateE dateBirth = new LibertyApplicationDTO.DateE(DateUtils.formatDate(add.Date_of_Birth_2__c, DateUtils.YYYY_MM_DD));
        dateOfBirth.dateE = dateBirth;
        person.dateOfBirth = dateOfBirth;

        if (add.Ages_of_Dependants_2__c != null){
            person.dependents = getDependents (add.Ages_of_Dependants_2__c);
        }
       
        person.driversLicence = getDriversLicence(add.Drivers_License_2__c, add.Expiry_Date_2__c, add.Type_of_Licence_2__c, add.Driver_Licence_State_Issue_2__c);
        
        person.employments = new List<LibertyApplicationDTO.Employment>();
        validateExceptionNull (add.Mode_of_Employment_2__c, 'Employment Type');
        String employmentType = Utilities.salesforceValueToMessageCode_Description(add.Mode_of_Employment_2__c, Utilities.LiB_EMPLOYMENT_TYPES); 
        person.employments.add(getEmployment('ID_EMPLOYER_2', employmentType, add.Date_Started_2__c , null ,add.Current_Occupation_2__c, incomeIds));
        
        //if(add.Previous_Mode_of_Employment_1__c != null && !''.equalsIgnoreCase(add.Previous_Mode_of_Employment_1__c)){
        if (!StringUtils.isNullOrEmpty(add.Start_Date_2__c) && !StringUtils.isNullOrEmpty(add.Previous_Employer_Name_2__c)){
            validateExceptionNull (add.Previous_Mode_of_Employment_2__c, 'Employment Type');
            String previousEmploymentType = Utilities.salesforceValueToMessageCode_Description(add.Previous_Mode_of_Employment_2__c, Utilities.LiB_EMPLOYMENT_TYPES); 
            List<String> incomeIds2 = new List<String>(); 
            person.employments.add(getEmployment('ID_PREVIOUS_EMPLOYER_2', previousEmploymentType, add.Start_Date_2__c, add.Finish_Date_2__c ,add.Previous_Occupation_2__c, incomeIds2));
        }
        
        //Previous Employer Address
        //Previoues Employer Address Applicant 2
        Integer prevEmp = 2;
        List < Application_Employment__c > lst = prevEmplMap.get('2');
        if (lst != null) {
            for (Application_Employment__c a: lst) {
                validateExceptionNull (a.Employment_Type__c, 'Employment Type');
                String previousEmploymentType = Utilities.salesforceValueToMessageCode_Description(a.Employment_Type__c, Utilities.LiB_EMPLOYMENT_TYPES); 
                List<String> incomeIds2 = new List<String>(); 
                System.debug ('ID_PREVIOUS_EMPLOYER_2_' + prevEmp + '-' + previousEmploymentType + '-' + a.Start_Date__c + '-' + a.Finish_Date__c + '-' + a.Occupation__c);
                person.employments.add(getEmployment('ID_PREVIOUS_EMPLOYER_2_' + prevEmp, previousEmploymentType, DateUtils.convertToString(a.Start_Date__c, DateUtils.ddMMyyyy), DateUtils.convertToString(a.Finish_Date__c,DateUtils.ddMMyyyy) ,a.Occupation__c, incomeIds2));
                prevEmp = prevEmp + 1;
            }
        }
        
        person.maritalStatus = getMaritalStatus(identifierPerson, add.Marital_Status_2__c);
        
        
        List<LibertyApplicationDTO.PersonalReference> personalReferences = new List<LibertyApplicationDTO.PersonalReference>();
        
        String referenceType1 = 'Personal';
        
        /** Personal reference is not required in LoanNet
        getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_1', referenceType1, add.Personal_Reference_1_Relationship__c, add.Personal_Reference_1_Full_Name__c, 'RefereeAddress_1', add.Personal_Reference_1_Phone__c);
        getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_2', 'Relative', add.Personal_Reference_2_Relationship__c, add.Personal_Reference_2_Full_Name__c, 'RefereeAddress_2', add.Personal_Reference_2_Phone__c);
        **/        

        //if (housingStatus != null && !housingStatus.equalsIgnoreCase('Mortgage')){
            //Just for Applicant 1
            //referenceType1 = 'Agent';
            //getPersonalReference (app, personalReferences, 'ID_APPLICANT_REF_AGENT_1', referenceType1, 'Real Estate', add.Landlord_Name_1__c, 'ApplicantAddress1', add.Landlord_Phone_1__c);
        //}
        
        person.personalReferences = personalReferences;
        
        
        person.personName = getPersonName(add.Title_2__c, add.First_Name_2__c, add.Middle_Name_2__c, add.Last_Name_2__c);
        
        person.residency = getResidency (add.Actual_Nationality_2__c, add.Current_Residential_Status_2__c);
        return person;
    }


    private LibertyApplicationDTO.ContactDetails getContactDetails (Application__c add, String housingStatus){
        LibertyApplicationDTO.ContactDetails contactDetails = new LibertyApplicationDTO.ContactDetails ();
        contactDetails.addressDetails = new List<LibertyApplicationDTO.AddressDetails>();
        contactDetails.addressDetails.clear();
        Boolean isStandard = true;
        Boolean isMailing = true;
        //String housingStatus= add.Current_Residence_Status_1__c;
        
        /**
        if (StringUtils.isNullOrEmpty(add.Landlord_Name_1__c) && 
            housingStatus != null && housingStatus.equalsIgnoreCase('Mortgage')){
            housingStatus = 'Non-Resident'; //This is for HousingStatus field with 'Other' for CurrentAddress
        }
        **/
        Date moveIn = DateUtils.convertToDate(add.Date_Moved_in_1__c);
        contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS1, isStandard, !isMailing, moveIn, null, housingStatus, false));
        //if (!'Personal'.equalsIgnoreCase(add.Application_Type__c)){
            contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS1 + MAILING, !isStandard, isMailing, moveIn, null, housingStatus, false));
        //}
        String previousAddressMove = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1__c)){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_1__c)){
                isStandard = false;
            }
            String housingStatusPrevious = add.Previous_Residence_Status_1__c;
            previousAddressMove = add.Date_From_1__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_1', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove), moveIn, housingStatusPrevious, true));
        }
        String previousAddressMove2 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1b__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_1b__c)){
                isStandard = false;
            }
            previousAddressMove2 = add.Date_From_1b__c;
            String housingStatusPreviousB = add.Previous_Residence_Status_1b__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_1b', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove2), DateUtils.convertToDate(previousAddressMove), housingStatusPreviousB,true));
        }
        
        String previousAddressMove3 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1c__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_1c__c)){
                isStandard = false;
            }
            previousAddressMove3 = add.Date_From_1c__c;
            String housingStatusPreviousC = add.Previous_Residence_Status_1c__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_1c', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove3), DateUtils.convertToDate(previousAddressMove2), housingStatusPreviousC, true));
        }
        String previousAddressMove4 = null;                                                                                     
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1d__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_1d__c)){
                isStandard = false;
            }
            previousAddressMove4 = add.Date_From_1d__c;
            String housingStatusPreviousD = add.Previous_Residence_Status_1d__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_1d', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove4), DateUtils.convertToDate(previousAddressMove3), housingStatusPreviousD, true));
        }
        String previousAddressMove5 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_1e__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_1e__c)){
                isStandard = false;
            }
            previousAddressMove5 = add.Date_From_1e__c;
            String housingStatusPreviousE = add.Previous_Residence_Status_1e__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_1e', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove5), DateUtils.convertToDate(previousAddressMove4), housingStatusPreviousE, true));
        }
        
        String sPhone = null;
        String homePhone = add.Home_Phone__c;
        String mobilePhone = add.Mobile_Number__c;
        String workPhone = add.Work_Phone__c;
        
        if (!StringUtils.isNullOrEmpty(mobilePhone)){
            sPhone = mobilePhone;
        }else if (!StringUtils.isNullOrEmpty(homePhone)){
            sPhone = homePhone;
        }
        if (!StringUtils.isNullOrEmpty(sPhone)){
            contactDetails.homePhone = getHomePhone(sPhone);
        }
        
        String sWorkPhone = null;
        if (!StringUtils.isNullOrEmpty(workPhone)){
            sWorkPhone = workPhone;
        }else if (!StringUtils.isNullOrEmpty(homePhone) && !sPhone.equalsIgnoreCase(homePhone)){
            sWorkPhone = homePhone;
        }
        if (!StringUtils.isNullOrEmpty(sWorkPhone)){
            contactDetails.workPhone = getWorkPhone(sWorkPhone);
        }
        
        //::Validate before send through Liberty API::
        if (StringUtils.isNullOrEmpty(sWorkPhone) || StringUtils.isNullOrEmpty(sPhone)){
            throw new GenericException ('At least two phone numbers are required before send through Liberty API. Applicant 1');
        }
        
        LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
        email.value = add.Email_Address__c;
        contactDetails.email = email;
        
        return contactDetails;
    }

    private LibertyApplicationDTO.ContactDetails getContactDetails2 (Application__c add, String housingStatus){
        LibertyApplicationDTO.ContactDetails contactDetails = new LibertyApplicationDTO.ContactDetails ();
        contactDetails.addressDetails = new List<LibertyApplicationDTO.AddressDetails>();
        contactDetails.addressDetails.clear();
        Boolean isStandard = true;
        Boolean isMailing = true;

        Date moveIn = DateUtils.convertToDate(add.Date_Moved_in_2__c);
        contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS2, isStandard, !isMailing, moveIn, null, housingStatus, false));
        //if (!'Personal'.equalsIgnoreCase(add.Application_Type__c)){
            contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS2 + MAILING, !isStandard, isMailing, moveIn, null, housingStatus, false));
        //}
        String previousAddressMove = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2__c)){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2__c)){
                isStandard = false;
            }
            String housingStatusPrevious = add.Previous_Residence_Status_2__c;
            previousAddressMove = add.Date_From_2__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove), moveIn, housingStatusPrevious, true));
        }
        String previousAddressMove2 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2b__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2b__c)){
                isStandard = false;
            }
            previousAddressMove2 = add.Date_From_2b__c;
            String housingStatusPreviousB = add.Previous_Residence_Status_2b__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2b', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove2), DateUtils.convertToDate(previousAddressMove), housingStatusPreviousB,true));
        }
        
        String previousAddressMove3 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2c__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2c__c)){
                isStandard = false;
            }
            previousAddressMove3 = add.Date_From_2c__c;
            String housingStatusPreviousC = add.Previous_Residence_Status_2c__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2c', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove3), DateUtils.convertToDate(previousAddressMove2), housingStatusPreviousC, true));
        }
        String previousAddressMove4 = null;                                                                                     
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2d__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2d__c)){
                isStandard = false;
            }
            previousAddressMove4 = add.Date_From_2d__c;
            String housingStatusPreviousD = add.Previous_Residence_Status_2d__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2d', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove4), DateUtils.convertToDate(previousAddressMove3), housingStatusPreviousD, true));
        }
        String previousAddressMove5 = null;
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2e__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2e__c)){
                isStandard = false;
            }
            previousAddressMove5 = add.Date_From_2e__c;
            String housingStatusPreviousE = add.Previous_Residence_Status_2e__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2e', isStandard, !isMailing, DateUtils.convertToDate(previousAddressMove5), DateUtils.convertToDate(previousAddressMove4), housingStatusPreviousE, true));
        }
        
        String sPhone = null;
        String homePhone = add.Home_Phone_2__c;
        String mobilePhone = add.Mobile_Number_2__c;
        String workPhone = add.Work_Phone_2__c;
        
        if (!StringUtils.isNullOrEmpty(mobilePhone)){
            sPhone = mobilePhone;
        }else if (!StringUtils.isNullOrEmpty(homePhone)){
            sPhone = homePhone;
        }
        if (!StringUtils.isNullOrEmpty(sPhone)){
            contactDetails.homePhone = getHomePhone(sPhone);
        }
        
        String sWorkPhone = null;
        if (!StringUtils.isNullOrEmpty(workPhone)){
            sWorkPhone = workPhone;
        }else if (!StringUtils.isNullOrEmpty(homePhone) && !sPhone.equalsIgnoreCase(homePhone)){
            sWorkPhone = homePhone;
        }
        if (!StringUtils.isNullOrEmpty(sWorkPhone)){
            contactDetails.workPhone = getWorkPhone(sWorkPhone);
        }
        
        //::Validate before send through Liberty API::
        if (StringUtils.isNullOrEmpty(sWorkPhone) || StringUtils.isNullOrEmpty(sPhone)){
            throw new GenericException ('At least two phone numbers are required before send through Liberty API.  Applicant 2');
        }
        
        LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
        email.value = add.Email_Address_2__c;
        contactDetails.email = email;
        
        return contactDetails;
    }
    
    private LibertyApplicationDTO.HomePhone getHomePhone (String sMobilePhone){
        LibertyApplicationDTO.HomePhone homePhone = new LibertyApplicationDTO.HomePhone();
        LibertyApplicationDTO.Phone phone = new LibertyApplicationDTO.Phone ();
        phone.mobile = StringUtils.removeAllCharacters(sMobilePhone);
        phone.value = StringUtils.removeAllCharacters(sMobilePhone);
        homePhone.attb_PreferredContactMethod = 'Yes';
        homePhone.phone = phone;
        return homePhone;
    }
    
    private LibertyApplicationDTO.WorkPhone getWorkPhone (String sWorkPhone){
        LibertyApplicationDTO.WorkPhone workPhone = new LibertyApplicationDTO.WorkPhone();
        LibertyApplicationDTO.Phone phone = new LibertyApplicationDTO.Phone ();
        phone.fixedPhone = StringUtils.removeAllCharacters(sWorkPhone);
        phone.value = StringUtils.removeAllCharacters(sWorkPhone);
        workPhone.phone = phone;
        return workPhone;
    }
    
    /**
    private LibertyApplicationDTO.ContactDetails getContactDetails2 (Application__c add){
        LibertyApplicationDTO.ContactDetails contactDetails = new LibertyApplicationDTO.ContactDetails ();
        contactDetails.addressDetails = new List<LibertyApplicationDTO.AddressDetails>();
        Boolean isStandard = true;
        Boolean isMailing = true;
        String housingStatus= add.Current_Residence_Status_2__c;
        Date moveIn2 = DateUtils.convertToDate(add.Date_Moved_in_2__c);
        contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS2, isStandard, !isMailing, moveIn2, null, housingStatus));
        //contactDetails.addressDetails.add(getAddressDetails (APPLICANTADDRESS2 + MAILING, !isStandard, isMailing, moveIn2, null, housingStatus)); 
        
        if ( !StringUtils.isNullOrEmpty(add.Previous_Street_Number_1__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2__c)){
                isStandard = false;
            }
            String housingStatusPrevious = add.Previous_Residence_Status_2__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2', !isStandard, isMailing, DateUtils.convertToDate(add.Date_From_2__c), moveIn2, housingStatusPrevious));
        }
        
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2b__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2b__c)){
                isStandard = false;
            }
            String housingStatusPreviousB = add.Previous_Residence_Status_2b__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2b', !isStandard, isMailing, DateUtils.convertToDate(add.Date_From_2b__c), System.today(), housingStatusPreviousB));
        }
        
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2c__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2c__c)){
                isStandard = false;
            }
            String housingStatusPreviousC = add.Previous_Residence_Status_2c__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2c', !isStandard, isMailing, DateUtils.convertToDate(add.Date_From_2c__c), System.today(), housingStatusPreviousC));
        }
                                                                                             
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2d__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2d__c)){
                isStandard = false;
            }
            String housingStatusPreviousD = add.Previous_Residence_Status_2d__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2d', !isStandard, isMailing, DateUtils.convertToDate(add.Date_From_2d__c), System.today(), housingStatusPreviousD));
        }
        
        if (!StringUtils.isNullOrEmpty(add.Previous_Street_Number_2e__c )){
            if (!'AUS'.equalsIgnoreCase(add.Previous_Country_2e__c)){
                isStandard = false;
            }
            String housingStatusPreviousE = add.Previous_Residence_Status_2e__c;
            contactDetails.addressDetails.add(getAddressDetails ('ApplicantPreviousAddress_2e', !isStandard, isMailing, DateUtils.convertToDate(add.Date_From_2e__c), System.today(), housingStatusPreviousE));
        }
        
        LibertyApplicationDTO.Phone phone = new LibertyApplicationDTO.Phone ();
        if (!StringUtils.isNullOrEmpty(add.Mobile_Number_2__c)){
            phone.mobile = StringUtils.removeAllCharacters(add.Mobile_Number_2__c);
            LibertyApplicationDTO.HomePhone homePhone = new LibertyApplicationDTO.HomePhone();
            homePhone.attb_PreferredContactMethod = 'Yes';
            homePhone.phone = phone;
            contactDetails.homePhone = homePhone;
        }
        
        if (!StringUtils.isNullOrEmpty(add.Work_Phone_2__c)){
            phone = new LibertyApplicationDTO.Phone ();
            phone.fixedPhone = StringUtils.removeAllCharacters(add.Work_Phone_2__c);
            LibertyApplicationDTO.WorkPhone workPhone = new LibertyApplicationDTO.WorkPhone();
            workPhone.phone = phone;
            contactDetails.workPhone = workPhone;
        }
        
        if (!StringUtils.isNullOrEmpty(add.Email_Address_2__c)){
            LibertyApplicationDTO.Email email = new LibertyApplicationDTO.Email();
          email.value = add.Email_Address_2__c;
            contactDetails.email = email;
        }
        return contactDetails;
    }
    **/
    
    private LibertyApplicationDTO.AddressDetails getAddressDetails (Boolean isResidential, String sUnitNo, String sStreetNo, String sStreet, 
                                                                    String sCity, String sCountry, String sPostcode, String sState, String sType,
                                                                    Boolean isStandard, String sNonStandard, Date dStart, Date dEnd, 
                                                                    Boolean isMailing, String housingStatus){
        LibertyApplicationDTO.AddressDetails addressDetails = new LibertyApplicationDTO.AddressDetails();
        addressDetails.attb_Mailing = 'No'; //Yes Indicates the address as being used for postage purposes. Either Yes or No
        if (!StringUtils.isNullOrEmpty(housingStatus)){
            addressDetails.attb_HousingStatus = Utilities.salesforceValueToMessageCode_Description(housingStatus , Utilities.LiB_ADDRESS_HOUSING_STATUS);
        }
        if (isResidential){
            addressDetails.attb_Residential = 'Yes'; //Yes  Indicates the address as being residential in nature. Either Yes or No
            addressDetails.attb_PriorAddress = 'No';
            if (dStart != null){
                Integer year = DateUtils.getHowManyYears(dStart, System.today());
                Integer month = DateUtils.getHowManyMonths(dStart, System.today());
                String value = '';
                String units = '';
                if (year != null && year > 0){
                    value = StringUtils.convertToString(year);
                    units = 'Years';
                }else{
                    value = StringUtils.convertToString(month);
                    units = 'Months';
                }
                LibertyApplicationDTO.Duration duration = new LibertyApplicationDTO.Duration();
                duration.attb_Length = value;
                duration.attb_Units = units;
                addressDetails.duration = duration;
            }
        }else if (isMailing){
            addressDetails.attb_Mailing = 'Yes';
            addressDetails.attb_PriorAddress = 'No';
            addressDetails.attb_Residential = 'No';
        }else{
            addressDetails.attb_PriorAddress = 'Yes';
            addressDetails.attb_Residential = 'Yes';
                       
            addressDetails.startAndEndDates = getStartAndEndDates(dStart, dEnd);
        }
        addressDetails.address = getAddress (sUnitNo, sStreetNo, sStreet, sCity, sCountry, sPostcode, sState, sType, isStandard, sNonStandard);
        //addressDetails.attb_RegisteredOffice = 'Yes'; //No  Used to flag a business entities address. Either Yes or No
        //addressDetails.attb_PostSettlement = 'No'; //No  Used to flag an address to be used post settlement. Either Yes or No
        //addressDetails.attb_HousingStatus = '';//No  The residential address status. Either Boarding RentingRealEstateAgent RentingOther OwnHome OwnHomeMortgage WithParents FreeAccommodation or Other
        return addressDetails;
    }
    
    private LibertyApplicationDTO.AddressDetails getAddressDetails (String relatedID, Boolean isResidential, Boolean isMailing, Date dStart, 
                                                                    Date dEnd, String housingStatus, Boolean isPreviousAddr){
        LibertyApplicationDTO.AddressDetails addressDetails = new LibertyApplicationDTO.AddressDetails();
        addressDetails.attb_Mailing = 'No'; //Yes Indicates the address as being used for postage purposes. Either Yes or No
        if (!StringUtils.isNullOrEmpty(housingStatus) && !isPreviousAddr){
            addressDetails.attb_HousingStatus = Utilities.salesforceValueToMessageCode_Description(housingStatus , Utilities.LiB_ADDRESS_HOUSING_STATUS);
        }
    addressDetails.attb_PriorAddress = 'No';
        if (isPreviousAddr){
            addressDetails.attb_PriorAddress = 'Yes';                                                                
        }
        if (isResidential){
            addressDetails.attb_Residential = 'Yes'; //Yes  Indicates the address as being residential in nature. Either Yes or No
            //addressDetails.attb_PriorAddress = 'No';
        }else if (isMailing){
            addressDetails.attb_Mailing = 'Yes';
            //addressDetails.attb_PriorAddress = 'No';
            addressDetails.attb_Residential = 'No';
        }else{
            //addressDetails.attb_PriorAddress = 'Yes';
            addressDetails.attb_Residential = 'Yes';
                       
            addressDetails.startAndEndDates = getStartAndEndDates(dStart, dEnd);
        }
        addressDetails.relatedEntityRef = getRelatedEntityRef(relatedID);
        
        if (isPreviousAddr){
      addressDetails.startAndEndDates = getStartAndEndDates(dStart, dEnd);
        }else{
            if (dStart != null){
                if (dEnd == null){
                    dEnd = SYstem.today();
                }
                Integer year = DateUtils.getHowManyYears(dStart, dEnd);
                Integer month = DateUtils.getHowManyMonths(dStart, dEnd);
                String value = '';
                String units = '';
                if (year != null && year > 0){
                    value = StringUtils.convertToString(year);
                    units = 'Years';
                }else{
                    value = StringUtils.convertToString(month);
                    units = 'Months';
                }
                LibertyApplicationDTO.Duration duration = new LibertyApplicationDTO.Duration();
                duration.attb_Length = value;
                duration.attb_Units = units;
                addressDetails.duration = duration;
            }
        }
        //addressDetails.attb_RegisteredOffice = 'Yes'; //No  Used to flag a business entities address. Either Yes or No
        //addressDetails.attb_PostSettlement = 'No'; //No  Used to flag an address to be used post settlement. Either Yes or No
        //addressDetails.attb_HousingStatus = '';//No  The residential address status. Either Boarding RentingRealEstateAgent RentingOther OwnHome OwnHomeMortgage WithParents FreeAccommodation or Other
        return addressDetails;
    }
    
    private LibertyApplicationDTO.StartAndEndDates getStartAndEndDates (Date dStart, Date dEnd){
        LibertyApplicationDTO.DateE dateStart = new LibertyApplicationDTO.DateE(DateUtils.convertToString(dStart, DateUtils.YYYY_MM_DD));
        LibertyApplicationDTO.DateE dateEnd = new LibertyApplicationDTO.DateE(StringUtils.convertToString(DateUtils.convertToString(dEnd, DateUtils.YYYY_MM_DD)));
        
        LibertyApplicationDTO.StartDate startDate = new LibertyApplicationDTO.StartDate(dateStart);
        LibertyApplicationDTO.StartAndEndDates startAndEndDates = new LibertyApplicationDTO.StartAndEndDates();
        startAndEndDates.startDate = startDate;
        if (dEnd != null){
            LibertyApplicationDTO.EndDate endDate = new LibertyApplicationDTO.EndDate(dateEnd);
            startAndEndDates.endDate = endDate;
        }else{
            startAndEndDates.endDate = null;
        }
        
        return startAndEndDates;
    }
    
    private LibertyApplicationDTO.Address getAddress (String sUnitNo, String sStreetNo, String sStreet, String sCity, 
                                                      String sCountry, String sPostcode, String sState, String sType, Boolean isStandard, String sNonStandard) {
        LibertyApplicationDTO.Address address = new LibertyApplicationDTO.Address ();
    
        if (!StringUtils.isNullOrEmpty(sCity)){
            LibertyApplicationDTO.City city = new LibertyApplicationDTO.City ();
            city.value = sCity;
            address.city = city;
        }

        address.country = getCountry('AU');
                                                          
        if (!StringUtils.isNullOrEmpty(sPostcode)){
            LibertyApplicationDTO.PostCode postcode = new LibertyApplicationDTO.PostCode();
            postcode.value = sPostcode;
            address.postcode = postcode;
        }
        if (!StringUtils.isNullOrEmpty(sState)){
            address.state = getState(sState);
        }
        
        if (isStandard){
            //::Validate before send through Liberty API::
            System.debug('Validate address -> Postcode: ' + sPostcode + ' -UnitNo: ' + sUnitNo + ' -StreetNumber: ' + sStreetNo + ' -Street: ' + sStreet);
            if (StringUtils.isNullOrEmpty(sStreetNo) || StringUtils.isNullOrEmpty(sStreet)){
                throw new GenericException ('Street Number / Work Address fields are required for all address before send through Liberty API.' );//+ sUnitNo + '-' + sStreet + '-' + sStreetNo + '.' + sPostcode);
            }
            
          LibertyApplicationDTO.UnitNo unitNo = new LIbertyApplicationDTO.UnitNo ();
            unitNo.value = sUnitNo;
            address.unitNo = unitNo;
            LibertyApplicationDTO.StreetNo streetNo = new LibertyApplicationDTO.StreetNo ();
            streetNo.value = sStreetNo;
            address.streetNo = streetNo;
            LibertyApplicationDTO.Street street = new LibertyApplicationDTO.Street();
            //street.attb_Type = 'ST';
            if (StringUtils.isNullOrEmpty(sType)){
                sType = 'ST';
            }
            street.attb_Type = sType;
            street.value = sStreet;
            address.street = street;
        }else{
            LibertyApplicationDTO.NonStdAddress nonStdAddress = new LibertyApplicationDTO.NonStdAddress ();
            nonStdAddress.value = sNonStandard;
            address.nonStdAddress = nonStdAddress;
        }
    return address;
    }
    
    private LibertyApplicationDTO.RelatedEntityRef getRelatedEntityRef (String relatedID){
        LibertyApplicationDTO.RelatedEntityRef relatedEntityRef = new LibertyApplicationDTO.RelatedEntityRef();
        relatedEntityRef.attb_RelatedID = relatedID;
        return relatedEntityRef;
    }
    
    private LibertyApplicationDTO.DriversLicence getDriversLicence (String driversLicenceNumber, String expiryDate, String typeOfLicence, String sState){
        LibertyApplicationDTO.DriversLicence driversLicence = new LibertyApplicationDTO.DriversLicence ();
        driversLicence.attb_DriversLicenceNumber = driversLicenceNumber;
        driversLicence.attb_ExpiryDate = DateUtils.formatDate(expiryDate, DateUtils.YYYY_MM_DD);
        String licenceType = Utilities.salesforceValueToMessageCode_Description(typeOfLicence, Utilities.LiB_LICENCE_TYPES); 
        driversLicence.attb_LicenceType = licenceType;
        driversLicence.state = getState(sState);
        return driversLicence;
    }
    
    private LibertyApplicationDTO.State getState (String sState){
        LibertyApplicationDTO.State state = new LibertyApplicationDTO.State();
        state.attb_Name = sState;
        return state;
    }
    
    private LibertyApplicationDTO.Employment getEmployment(String entityRefEmployment, String typeEmployment, String dateStarted, String dateEnd, String occupation, List<String> incomeIds){
        LibertyApplicationDTO.Employment employment = new LibertyApplicationDTO.Employment();
        for (String income : incomeIds){
            employment.relatedEntityRef = getRelatedEntityRef(income);
        }
        
        LibertyApplicationDTO.PAYE paye = new LIbertyApplicationDTO.PAYE();
        paye.relatedEntityRef = getRelatedEntityRef (entityRefEmployment);
        paye.attb_Type = typeEmployment;
        employment.paye = paye;
        employment.startAndEndDates = getStartAndEndDates(DateUtils.convertToDate(dateStarted), DateUtils.convertToDate(dateEnd));
        employment.attb_RoleFreeText = occupation;
        return employment;
    }
    
    private LibertyApplicationDTO.MaritalStatus getMaritalStatus (String identifier, String status){
        LibertyApplicationDTO.MaritalStatus maritalStatus = new LibertyApplicationDTO.MaritalStatus();
        if ('Defacto'.equalsIgnoreCase(status)){
            status = 'DeFacto';
        }
        maritalStatus.attb_Status = status;
        return maritalStatus;
    }
    
    private void getPersonalReference (LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.PersonalReference> personalReferences, 
                                                                          String identifier, String ReferenceType, String relationship, String fullName, String identifierAddress, String phone){
        if (!StringUtils.isNullOrEmpty(identifierAddress) && !StringUtils.isNullOrEmpty(fullName)){
            LibertyApplicationDTO.PersonalReference personalReference = new LibertyApplicationDTO.PersonalReference();
            personalReference.attb_ReferenceType = referenceType;
            personalReference.attb_Relationship = relationship;
            personalReference.relatedEntityRef = getRelatedEntityRef(identifier);
    
            getRelatedPartyReferee(app.relatedPartySegment.relatedParties, 'Referee', fullName, identifier, identifierAddress, phone);
                
                
            personalReferences.add(personalReference);
        }
    }
    
    private LibertyApplicationDTO.PersonName getPersonName (String nameTitle, String firstName, String otherName, String surname){
        LibertyApplicationDTO.PersonName personName = new LibertyApplicationDTO.PersonName();
        personName.nameTitle = new LibertyApplicationDTO.NameTitle();
        String attbValue = 'Mr';
        if (nameTitle != null && !nameTitle.equalsIgnoreCase('')){
             attbValue = nameTitle;
        }
        personName.nameTitle.attb_Value = attbValue;
        personName.firstName = new LibertyApplicationDTO.FirstName (firstName);
        personName.otherName = new LibertyApplicationDTO.OtherName (otherName);
        personName.surname = new LibertyApplicationDTO.Surname (surname);
        return personName;
    }
    
    private LibertyApplicationDTO.Country getCountry(String sCountry){
        LibertyApplicationDTO.Country country = new LibertyApplicationDTO.Country();
        if (sCountry!= null && sCountry.equalsIgnoreCase('AUS')){
            country.attb_ISO3166 = 'AU';
        }else if (sCountry!= null && sCountry.equals('NZL')){
            country.attb_ISO3166 = 'NZ';
        }else if (sCountry!= null && !sCountry.equals('')){
            //country.attb_ISO3166 = sCountry;
            country.attb_ISO3166 = 'AU';
        }else{
            country.attb_ISO3166 = 'AU';
        }
        return country;
    }
    
    private LibertyApplicationDTO.Residency getResidency (String country, String statusResidency){
        LibertyApplicationDTO.Residency residency = new LibertyApplicationDTO.Residency();
        String status = '';
        if ('Australian Citizen'.equalsIgnoreCase(statusResidency)){
            status = 'Citizen';
        }else if ('PR VISA'.equalsIgnoreCase(statusResidency)){
            status = 'PermanentResident';
        }else{
            status = 'NonResident';
        }
        residency.attb_Status = status;
        residency.country = getCountry(country);
        return residency;
    }
    
    private LibertyApplicationDTO.Company getCompany (Application__c add, String identifierParty){
        LibertyApplicationDTO.Company company = new LibertyApplicationDTO.Company();
        
        LibertyApplicationDTO.CompanyName companyName = new LibertyApplicationDTO.CompanyName();
        companyName.attb_BusinessName = add.Entity_Name__c;
        company.companyName = companyName;
        String housingStatus= add.Current_Residence_Status_1__c;
        company.contactDetails = getContactDetails (add, housingStatus);
        
        if (add.Business_Structure__c != null){
            LibertyApplicationDTO.CompanyType companyType = new LibertyApplicationDTO.CompanyType();
            String description = Utilities.salesforceValueToMessageCode_Description(add.Business_Structure__c, Utilities.LiB_COMPANY_TYPE);
            companyType.attb_Description = description;
            company.companyType = companyType;
        }else{
            //Aaaaaaaa
        }
        
        LibertyApplicationDTO.CompanyNumber companyNumber = new LibertyApplicationDTO.CompanyNumber();
        companyNumber.attb_ACN = add.Business_ACN__c;
        companyNumber.attb_ABN = add.Business_ABN__c;
        company.companyNumber = companyNumber;
        
        company.registeredIn = getRegisteredIn(add);
        company.creditHistory = getCreditHistory(identifierParty);
        
        company.business = getBusiness ();
        company.director = getDirector('ID_EMPLOYER_1');
        company.shareholder = getShareholder('ID_EMPLOYER_1');
        
        return company;
    }
    
    private LibertyApplicationDTO.Director getDirector(String relatedId){
        LibertyApplicationDTO.Director director = new LibertyApplicationDTO.Director();
        director.relatedEntityRef = getRelatedEntityRef(relatedId);
        return director;
    }
    
    private LibertyApplicationDTO.Shareholder getShareholder(String relatedId){
        LibertyApplicationDTO.Shareholder shareholder = new LibertyApplicationDTO.Shareholder();
        shareholder.attb_OwnershipPercentage  = '100';
        shareholder.relatedEntityRef = getRelatedEntityRef(relatedId);
        return shareholder;
    }
    
    private LibertyApplicationDTO.Business getBusiness(){
        LibertyApplicationDTO.Business business = new LibertyApplicationDTO.Business();
        return business;
    }
    
    private LibertyApplicationDTO.CreditHistory getCreditHistory (String relatedId){
        LibertyApplicationDTO.CreditHistory creditHistory = new LibertyApplicationDTO.CreditHistory();
        creditHistory.attb_CreditStatus = 'Clean';
        LibertyApplicationDTO.BorrowerProvHistory borrowerProvHistory = new LibertyApplicationDTO.BorrowerProvHistory();
        borrowerProvHistory.relatedEntityRef = getRelatedEntityRef(relatedId);
        creditHistory.borrowerProvHistory = borrowerProvHistory;
        return creditHistory;
    }
    
    private LibertyApplicationDTO.RegisteredIn getRegisteredIn (Application__c add){
        LibertyApplicationDTO.RegisteredIn registeredIn = new LibertyApplicationDTO.RegisteredIn();
        LibertyApplicationDTO.DateE dateE = new LibertyApplicationDTO.DateE(DateUtils.formatDate(add.Date_of_Birth_1__c, DateUtils.YYYY_MM_DD));
        registeredIn.dateE = dateE;
        registeredIn.country = getCountry(add.Actual_Nationality_1__c);
        registeredIn.state = getState (add.Driver_Licence_State_Issue_1__c);
        return registeredIn;
    }
    
    private LibertyApplicationDTO.DeclarationSegment getDeclarationSegment (Application__c add, String identifier){
        LibertyApplicationDTO.DeclarationSegment declarationSegment = new LibertyApplicationDTO.DeclarationSegment();   
        List<LibertyApplicationDTO.DeclarationAnswer> declarationAnswers = new List<LibertyApplicationDTO.DeclarationAnswer>();
        String lenderComments = LibertyServiceManager.getLenderComments(add.Id);
        declarationAnswers.add(getDeclarationAnswer('MOTOR_PAYMENT', 'No', StringUtils.validateNull(lenderComments) + ' ', identifier));
        declarationAnswers.add(getDeclarationAnswer('MOTOR_BANKRUPTCY', 'No', StringUtils.validateNull(lenderComments) + ' ', identifier));
        declarationAnswers.add(getDeclarationAnswer('MOTOR_CHANGES', 'No', StringUtils.validateNull(lenderComments) + ' ', identifier));
        declarationSegment.declarationAnswers = declarationAnswers;
        return declarationSegment;
    }
    
    private LibertyApplicationDTO.DeclarationAnswer getDeclarationAnswer (String questionIdentifier, String answer, String freeText, String identifier){
        LibertyApplicationDTO.DeclarationAnswer declarationAnswer = new LibertyApplicationDTO.DeclarationAnswer();
        declarationAnswer.attb_QuestionIdentifier = questionIdentifier;
        declarationAnswer.answer = getAnswer(answer);
        declarationAnswer.freeText = getFreeText(freeText);
        declarationAnswer.relatedEntityRef = getRelatedEntityRef(identifier);
        return declarationAnswer;
    }
    
    private LibertyApplicationDTO.FreeText getFreeText(String sFreeText){
        String value = StringUtils.convertToString(sFreeText);
        LibertyApplicationDTO.FreeText freeText = null;
        if (value != null){
            freeText = new LibertyApplicationDTO.FreeText();
            freeText.value = StringUtils.convertToString(sFreeText);
        }
        return freeText;
    }
    
     private LibertyApplicationDTO.Answer getAnswer(String sAnswer){
        String value = StringUtils.convertToString(sAnswer);
        LibertyApplicationDTO.Answer answer = null;
        if (value != null){
            answer = new LibertyApplicationDTO.Answer();
          answer.value = sAnswer;
        }
        return answer;
    }
    
    private LibertyApplicationDTO.FinancialSegment getFinancialSegment (LibertyApplicationDTO.Application app, Custom_Opportunity__c opp, Application__c add,Application_Quoting__c appQuoting, String identifier){
        LibertyApplicationDTO.FinancialSegment financialSegment = new LibertyApplicationDTO.FinancialSegment();
        financialSegment.valueItems = new List<LibertyApplicationDTO.ValueItem>();

        //New INCOME process from OppOpportunitty
        Map <Long, List < Application_Income__c >> servIncomeMap = ApplicationService.getApplicationIncomeMap2(opp.Application__c);
        // Lelo                     2019-03-19
        List<Application_Credit_Card__c> creditCardList =  ApplicationService.getApplicationCreditCards(opp.Application__c);
        //-
        if (servIncomeMap != null){
            List < Application_Income__c > appIncomes = servIncomeMap.get(1);
            Integer count = 1;
            if (appIncomes != null){
                for (Application_Income__c c : appIncomes){
                    getValueItemIncome(app, financialSegment.valueItems, INCOME, '00' + count, identifier, c.Type__c, c.Income__c, c.Frequency__c);
                    count++;
                }
            }

            if (add.No_of_People__c == 2){
                appIncomes = servIncomeMap.get(2);
                count = 1;
                if (appIncomes != null){
                    for (Application_Income__c c : appIncomes){
                        getValueItemIncome(app, financialSegment.valueItems, INCOME + '_2', '00' + count, identifier, c.Type__c, c.Income__c, c.Frequency__c);
                        count++;
                    }
                }
            }
        }
        
        getValueItemIncome(app, financialSegment.valueItems, INCOME, '007', identifier, 'FromPayslipAnnually', opp.ApplicationYTD__r.Income_1_2__c, MONTHLY);
        //getValueItemIncome(app, financialSegment.valueItems, INCOME, '008', identifier, 'FromPayslipAnnually', opp.ApplicationServicing__r.Income_1__c, add.Payment_Frequency_1__c);
        
        String sTypeHousing = 'Rent';
        Decimal housingValue = NumberUtils.convertDecimalToScale(add.Rent_per_month_1__c, scaleDecimal);
        if (!(housingValue != null && housingValue != 0)){
            housingValue = NumberUtils.convertDecimalToScale(add.Board_per_Month_1__c, scaleDecimal);
            sTypeHousing = 'LoanPayments';
        }
        
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '001', identifier, sTypeHousing, StringUtils.convertToString(housingValue), add.Residential_Payment_Frequency_1__c);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '002', identifier, 'Food', add.Basic_Living_Expenses_Per_Month__c, MONTHLY);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '003', identifier, 'Petrol', add.Travel_Transport_Expenses_per_Month__c, MONTHLY);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '004', identifier, 'ChildMaintenance', add.Childcare_Child_Maintenance_Per_Month__c, MONTHLY);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '005', identifier, 'Other', add.Other_Expenses_per_Month__c, MONTHLY);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '006', identifier, 'Telephone', add.Mobile_Phone_Internet_Pay_TV_per_Month__c, MONTHLY);
        getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '007', identifier, 'Insurance', add.Insurance_Expenses_per_Month__c, MONTHLY);
        
        //getValueItemExpense(app, financialSegment.valueItems, EXPENSE, '008', identifier, 'LoanPayments', StringUtils.convertToString(appQuoting.Vehicle_Price__c), YEARLY);
        String monthLeft = StringUtils.convertToString(appQuoting.Term__c);
        String acctNbr = add.Business_ACN__c;
        /**
        financialSegment.valueItems.add(getValueItemLiability(LIABILITY, '001', identifier, add.Loan_Type_1__c, add.Loans_Monthly_Payments_1__c, appQuoting, monthLeft, acctNbr));
        financialSegment.valueItems.add(getValueItemLiability(LIABILITY, '002', identifier, add.Loan_Type_2__c, add.Loans_Monthly_Payments_2__c, appQuoting, monthLeft, acctNbr));
        financialSegment.valueItems.add(getValueItemLiability(LIABILITY, '003', identifier, add.Loan_Type_3__c, add.Loans_Monthly_Payments_3__c, appQuoting, monthLeft, acctNbr));
        **/
        //Update process -I
        List<Application_Loan__c> d = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c,
                                            Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c,
                                            Order__c
                                            FROM Application_Loan__c WHERE Application__c = :opp.Application__c ORDER BY Order__c];
        Integer i = 1;
        for (Application_Loan__c a: d) {
            getValueItemLiability(app, financialSegment.valueItems, LIABILITY, '10' + i, identifier, a.Type__c, a.Payment__c, 
                                  appQuoting, monthLeft, acctNbr, a.Frequency__c, 'Other', 'Y', a.Amount_Owing__c);
            i++;
        }
        
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'V004', identifier, add.Loan_Type_4__c, add.Loans_Monthly_Payments_4__c, 
        //                      appQuoting, monthLeft, acctNbr, add.Loan_Frequency_4__c, add.Other_Loans_Lender_4__c, add.Vehicle_Has_Loan_1__c, add.Loans_Amount_Owing_4__c);
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'V005', identifier, add.Loan_Type_5__c, add.Loans_Monthly_Payments_5__c, 
        //                      appQuoting, monthLeft, acctNbr, add.Loan_Frequency_5__c, add.Other_Loans_Lender_5__c, add.Vehicle_Has_Loan_2__c, add.Loans_Amount_Owing_5__c);
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'V006', identifier, add.Loan_Type_6__c, add.Loans_Monthly_Payments_6__c, 
        //                      appQuoting, monthLeft, acctNbr, add.Loan_Frequency_6__c, add.Other_Loans_Lender_6__c, add.Vehicle_Has_Loan_3__c, add.Loans_Amount_Owing_6__c);
        
        //if ('Y'.equals(add.Property_Has_Loan_1__c)) {
        //    getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'P201', identifier, 'Mortgage', add.Loans_Monthly_Payments_1__c, 
        //                          appQuoting, monthLeft, acctNbr, add.Loan_Frequency_1__c, add.Other_Loans_Lender_1__c, add.Property_Has_Loan_1__c, add.Loans_Amount_Owing_1__c);//add.Other_Loans_Lender_1__c
        //}
        //if ('Y'.equals(add.Property_Has_Loan_2__c)) {
        //    getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'P202', identifier, 'Mortgage', add.Loans_Monthly_Payments_2__c, 
        //                          appQuoting, monthLeft, acctNbr, add.Loan_Frequency_2__c, add.Other_Loans_Lender_2__c, add.Property_Has_Loan_2__c, add.Loans_Amount_Owing_2__c);//add.Other_Loans_Lender_2__c
        //}
        //if ('Y'.equals(add.Property_Has_Loan_3__c)) {
        //    getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'P203', identifier, 'Mortgage', add.Loans_Monthly_Payments_3__c, 
        //                          appQuoting, monthLeft, acctNbr, add.Loan_Frequency_3__c, add.Other_Loans_Lender_3__c, add.Property_Has_Loan_3__c, add.Loans_Amount_Owing_3__c);//add.Other_Loans_Lender_3__c
        //}
        
        //Credit Card.
        //Lelo                  2019-03-19
        Integer count = 1;
        for (Application_Credit_Card__c a : creditCardList) {
            String cod = 'CC';
            if (count < 10) {
                cod += '0';
            }
            cod += String.valueOf(count++);
            getValueItemLiability(app, financialSegment.valueItems, LIABILITY, cod, identifier, 'CreditCard', a.Limit__c, 
                              appQuoting, monthLeft, acctNbr, MONTHLY, a.Issuer__c, 'Y', a.Amount_Owing__c);    
        }
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'CC01', identifier, 'CreditCard', add.Credit_Limit_1__c, 
        //                      appQuoting, monthLeft, acctNbr, MONTHLY, add.Credit_Cards_1__c, 'Y', add.Credit_Amount_Owing_1__c);
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'CC02', identifier, 'CreditCard', add.Credit_Limit_2__c, 
        //                      appQuoting, monthLeft, acctNbr, MONTHLY, add.Credit_Cards_2__c, 'Y', add.Credit_Amount_Owing_2__c);
        //getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'CC03', identifier, 'CreditCard', add.Credit_Limit_3__c, 
        //                      appQuoting, monthLeft, acctNbr, MONTHLY, add.Credit_Cards_3__c, 'Y', add.Credit_Amount_Owing_3__c);
        //-
        
        //getValueItemLiabilityLoanTerms(app, financialSegment.valueItems,appQuoting, LIABILITY, '900', identifier, 'Personal Loan', appQuoting.Vehicle_Price__c, acctNbr, MONTHLY,  'Other', 'Y');
        Map<String, List<Application_Other_Asset__c>> otherAssetsMap = ApplicationService.getApplicationOtherAssetsMap(opp.Application__c);

        Integer assetCount = 1;
        Integer loanCount = 1;
        if (otherAssetsMap.containsKey(ApplicationService.PROPERTY_ASSET_TYPE)) {
            for (Application_Other_Asset__c a : otherAssetsMap.get(ApplicationService.PROPERTY_ASSET_TYPE)) {
                getValueItemAsset(app, financialSegment.valueItems, ASSET, formatCounter(assetCount,3), identifier, 'CurrentAsset', 
                    a.Description__c, a.Value__c, true, null, null, a.Has_Loan__c, LIABILITY + 'P2' + formatCounter(loanCount,2), 'AssetPropertyAddress_'+loanCount);
                if ('Y'.equals(a.Has_Loan__c)) {
                    getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'P2' + formatCounter(loanCount,2), identifier, 'Mortgage', 
                        a.Payment__c, appQuoting, monthLeft, acctNbr, a.Frequency__c, a.Lender__c, a.Has_Loan__c, a.Amount_Owing__c);
                }
                assetCount++;
                loanCount++;
            }
        }
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '001', identifier, 'CurrentAsset', add.Property_Address_1__c, add.Property_Value_1__c, true, null, null, add.Property_Has_Loan_1__c, LIABILITY + 'P201', 'AssetPropertyAddress_1');
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '002', identifier, 'CurrentAsset', add.Property_Address_2__c, add.Property_Value_2__c, true, null, null, add.Property_Has_Loan_2__c, LIABILITY + 'P202', 'AssetPropertyAddress_2');
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '003', identifier, 'CurrentAsset', add.Property_Address_3__c, add.Property_Value_3__c, true, null, null, add.Property_Has_Loan_1__c, LIABILITY + 'P203', 'AssetPropertyAddress_3');
        
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '004', identifier, 'CurrentAsset', 'SavingsAccount', add.Bank_Value__c, false, null, getDepositAccount('SavingsAccount', null), null, null, null);
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '005', identifier, 'CurrentAsset', 'Superannuation', add.Super_Value_How_Much__c, false, getOtherAsset('Superannuation',null), null, null, null, null);
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '006', identifier, 'CurrentAsset', 'HomeContents', add.Furniture_Value__c, false, getOtherAsset('HomeContents',null), null, null, null, null);

        getValueItemAsset(app, financialSegment.valueItems, ASSET, formatCounter(assetCount++,3), identifier, 'CurrentAsset', 'SavingsAccount', add.Bank_Value__c, false, null, getDepositAccount('SavingsAccount', null), null, null, null);
        getValueItemAsset(app, financialSegment.valueItems, ASSET, formatCounter(assetCount++,3), identifier, 'CurrentAsset', 'Superannuation', add.Super_Value_How_Much__c, false, getOtherAsset('Superannuation',null), null, null, null, null);
        getValueItemAsset(app, financialSegment.valueItems, ASSET, formatCounter(assetCount++,3), identifier, 'CurrentAsset', 'HomeContents', add.Furniture_Value__c, false, getOtherAsset('HomeContents',null), null, null, null, null);
        
        if (otherAssetsMap.containsKey(ApplicationService.VEHICLE_ASSET_TYPE)) {
            for (Application_Other_Asset__c a : otherAssetsMap.get(ApplicationService.VEHICLE_ASSET_TYPE)) {
                getValueItemAsset(app, financialSegment.valueItems, ASSET, formatCounter(assetCount,3), identifier, 'CurrentAsset', 
                    a.Description__c, a.Value__c, false, getOtherAsset('MotorVehicle',null), null, a.Has_Loan__c, LIABILITY +'V' + formatCounter(loanCount,3), null);
                getValueItemLiability(app, financialSegment.valueItems, LIABILITY, 'V' + formatCounter(loanCount,3), identifier, 
                    'Car Loan', a.Payment__c, appQuoting, monthLeft, acctNbr, a.Frequency__c, a.Lender__c, a.Has_Loan__c, a.Amount_Owing__c);
                assetCount++;
                loanCount++;
            }
        }

        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '007', identifier, 'CurrentAsset', add.Motor_Vehicle_1__c, add.Motor_Vehicle_Value_1__c, false, getOtherAsset('HomeContents',null), null, add.Vehicle_Has_Loan_1__c, LIABILITY +'V004', null);        
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '008', identifier, 'CurrentAsset', add.Motor_Vehicle_2__c, add.Motor_Vehicle_Value_2__c, false, getOtherAsset('HomeContents',null), null, add.Vehicle_Has_Loan_2__c, LIABILITY +'V005', null);        
        //getValueItemAsset(app, financialSegment.valueItems, ASSET, '009', identifier, 'CurrentAsset', add.Motor_Vehicle_3__c, add.Motor_Vehicle_Value_3__c, false, getOtherAsset('HomeContents',null), null, add.Vehicle_Has_Loan_3__c, LIABILITY +'V006', null);        
        
        getValueItemAsset(app, financialSegment.valueItems, ASSET, FUTURE_CAR_ID, identifier, 'FutureSecurity', 'MotorVehicle', appQuoting.Vehicle_Price__c, false, getOtherAsset('MotorVehicle',getMotorVehicle(opp, add)), null, null, null, null);
        return financialSegment;
    }
    
    private String formatCounter(Integer c, Integer length) {
        if (String.valueOf(c).length() < length) {
            return '0' + formatCounter(c, length-1);
        }
        return String.valueOf(c);
    }

    private LibertyApplicationDTO.OtherAsset getOtherAsset(String assetType, LibertyApplicationDTO.MotorVehicle motorVehicle ){
        LibertyApplicationDTO.OtherAsset otherAsset = new LIbertyApplicationDTO.OtherAsset();
        otherAsset.attb_OtherAssetType = assetType;
        if (motorVehicle != null){
            otherAsset.motorVehicle = motorVehicle;
        }
        return otherAsset;
    }
    
    private LibertyApplicationDTO.MotorVehicle getMotorVehicle(Custom_Opportunity__c opp,Application__c add){
        String variant = opp.Application_AssetDetail__r.Variant__c;
        Glass_Variant__c r = GlassServicesHelper.getVariantByCode(variant); 
        Glass_Make__c gm = GlassServicesHelper.getMakeByCode(opp.Application_AssetDetail__r.Make__c);
        String make;
        String series;
        if (gm != null){
            make = gm.Name;
        }
        String model = opp.Application_AssetDetail__r.Model__c;
        if (r != null){
            series = r.Series__c;
        }
        
        
        LibertyApplicationDTO.MotorVehicle motorVehicle = new LibertyApplicationDTO.MotorVehicle();
        
        String bodyType = opp.Application__r.Type_of_Asset__c;
        if (bodyType != null){
            if (bodyType.containsIgnoreCase('BIKE')){
                motorVehicle.attb_BodyType = 'MOTORCYCLE';
            } else if (bodyType.containsIgnoreCase('CARAVAN')){
                motorVehicle.attb_BodyType = 'CARAVAN';
            } else{
                motorVehicle.attb_BodyType = bodyType;
            }
        }
        motorVehicle.attb_EngineNumber = opp.Application_AssetDetail__r.Engine_No__c;
        motorVehicle.attb_Make = make;
        motorVehicle.attb_Model = model;
        if (r != null){
            motorVehicle.attb_NVIC = r.NVIC__c;
        }
        
        
        if (!'New'.equalsIgnoreCase(opp.New_Used__c)){
            Decimal odometer = opp.Application_AssetDetail__r.Actual_KM__c;
            String odometer_reading = '';
            if (odometer != null && odometer != 0){
                odometer_reading = StringUtils.convertToString(odometer);
            }else{
                odometer = r.Average_Kms__c * 1000;
                odometer_reading = StringUtils.convertToString(odometer);
            }
            motorVehicle.attb_Odometer = odometer_reading;
        }
        motorVehicle.attb_RegistrationNumber = opp.Application_AssetDetail__r.Engine_No__c;
        
        String transmission = r != null? r.Transmission__c : null;
        if (transmission != null){
            String transmissionType = 'Automatic';
            if (transmission.substring(1,2).equalsIgnoreCase('M')){
                transmissionType = 'Manual';
            }
            motorVehicle.attb_TransmissionType = transmissionType;
        }
        String used = StringUtils.validateNull(opp.New_Used__c);
        if (used.equalsIgnoreCase('Used')){
            motorVehicle.attb_Used = 'Yes';
        }else{
            motorVehicle.attb_Used = 'No';
        }
        motorVehicle.attb_VIN = opp.Application_AssetDetail__r.VIN__c;
        motorVehicle.attb_Year = StringUtils.convertToString(opp.Application_AssetDetail__r.Year__c);
        return motorVehicle;
    }
    
    private LibertyApplicationDTO.DepositAccount getDepositAccount(String depositAccountType, String description ){
        LibertyApplicationDTO.DepositAccount depositAccount = new LibertyApplicationDTO.DepositAccount();
        depositAccount.attb_DepositAccountType = depositAccountType;
        depositAccount.attb_Description = description;
        return depositAccount;
    }
    
    private void getValueItemAsset(LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.ValueItem> valueItems,
                                                              String idType, String idNumber, String identifier,String sClass, String sType, 
                                                              Decimal value, Boolean isRealEstate, LibertyApplicationDTO.OtherAsset otherAsset,
                                                             LibertyApplicationDTO.DepositAccount depositAccount, String isMortgLoan, 
                                                 String identifierLiability, String identifierAddress){
        if (sType != null && value != null && value != 0){
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            valueItem.attb_Value = StringUtils.convertToString(value);
            
            valueItem.percentOwned = getPercentOwned (IDENTIFIER_APPLICANT, 100);
            
            valueItem.asset = getAsset(sClass, isRealEstate, value, otherAsset, depositAccount, identifierValueItem, isMortgLoan, identifierLiability, identifierAddress);
            valueItems.add(valueItem);
        }
    }
    
    private LibertyApplicationDTO.Asset getAsset(String sClass, Boolean isRealEstate, Decimal value, LibertyApplicationDTO.OtherAsset otherAsset,
                                                LibertyApplicationDTO.DepositAccount depositAccount, String identifierValueItem, 
                                                 String isMortgLoan, String identifierLiability, String identifierAddress){
        LibertyApplicationDTO.Asset asset = new LibertyApplicationDTO.Asset();
        asset.attb_Class = sClass;
        LibertyApplicationDTO.ExistMortgage existMortgage = null;
        if ('Y'.equals(isMortgLoan)) {
            existMortgage = new LibertyApplicationDTO.ExistMortgage();
            existMortgage.relatedEntityRef = getRelatedEntityRef (identifierLiability);
        }
        if (isRealEstate){
            LibertyApplicationDTO.RealEstate realEstate = new LibertyApplicationDTO.RealEstate();
            LibertyApplicationDTO.EstimatedValue estimatedValue = new LibertyApplicationDTO.EstimatedValue();
            estimatedValue.value = StringUtils.convertToString(value);
            realEstate.estimatedValue = estimatedValue;
            if (!StringUtils.isNullOrEmpty(identifierAddress)){
                realEstate.location = getLocation (identifierAddress);
            }else{
                realEstate.rentalIncome =  getRentalIncome(MONTHLY, StringUtils.convertToString(value));
            }
            realEstate.existMortgage = existMortgage;
            asset.realEstate = realEstate;
        }else{
            LibertyApplicationDTO.NonRealEstate nonRealEstate = new LibertyApplicationDTO.NonRealEstate();
            nonRealEstate.otherAsset = otherAsset;
            nonRealEstate.depositAccount = depositAccount;
            asset.nonRealEstate = nonRealEstate;
            nonRealEstate.existMortgage = existMortgage;
        }
        return asset;
    }
    
    private LibertyApplicationDTO.Location getLocation (String relatedEntityRef){
        if (StringUtils.isNullOrEmpty(relatedEntityRef)){
            return null;
        }
        LibertyApplicationDTO.Location location = new LibertyApplicationDTO.Location();
        location.relatedEntityRef = getRelatedEntityRef (relatedEntityRef);
        return location;
    }
    
    private LibertyApplicationDTO.RentalIncome getRentalIncome (String sUnit, String rentalAmount){
        LibertyApplicationDTO.RentalIncome rentalIncome = new LibertyApplicationDTO.RentalIncome();
        rentalIncome.period = getPeriod(sUnit, 'No', '12');
        rentalIncome.attb_RentalAmount = rentalAmount;
        return rentalIncome;
    }
    
    private void getValueItemLiability(LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.ValueItem> valueItems, 
                                       String idType, String idNumber, String identifier,String sType, 
                                       Decimal value, Application_Quoting__c appQuoting, String monthsLeft, 
                                       String AcctNbr, String frequency, String otherLoansLender, String hasLoan, Decimal unpaidBalance){
        if (sType != null && value != null && value != 0){
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            valueItem.attb_Value = StringUtils.convertToString(value);
            valueItem.percentOwned = getPercentOwned (identifier, 100);
            
            Decimal monthlyValue = value;
            if (monthlyValue == null){
                monthlyValue = 0;
            }
            monthlyValue = Utilities.getMonthlyValue (frequency , monthlyValue, scaleDecimal);
            
            getValueItemExpense(app, valueItems, EXPENSE, idNumber , identifier, 'LoanPayments', StringUtils.convertToString(monthlyValue), MONTHLY);
            
            valueItem.liability = getLiability(identifierValueItem, sType, appQuoting, monthsLeft, AcctNbr, identifierValueItem, monthlyValue, EXPENSE + idNumber, unpaidBalance );
            //valueItem.liability = getLiability(identifierValueItem, sType, appQuoting, monthsLeft, AcctNbr);
            valueItems.add(valueItem);
            app.relatedPartySegment.relatedParties.add(getRelatedParty('Lender', otherLoansLender, identifierValueItem + '_LENDER', identifierValueItem, hasLoan));
        }
    }
    
    /**
    private LibertyApplicationDTO.ValueItem getValueItemLiability(String idType, String idNumber, String identifier,String sType, 
                                                                  Decimal value, Application_Quoting__c appQuoting, String monthsLeft, 
                                                                  String AcctNbr, String frequency){
        if (sType != null && value != null && value != 0){
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            valueItem.attb_Value = StringUtils.convertToString(value);
            valueItem.percentOwned = getPercentOwned (identifier, 100);
            
            Decimal monthlyValue = value;
            if (monthlyValue == null){
                monthlyValue = 0;
            }
            if('Weekly'.equalsIgnoreCase(frequency)){
                monthlyValue = (monthlyValue * 52) / 12;
            }else if ('Fortnightly'.equalsIgnoreCase(frequency)){
                monthlyValue = (monthlyValue * 26) / 12;            
            }else if ('Yearly'.equalsIgnoreCase(frequency)){
                monthlyValue = monthlyValue / 12;
            }
            
            valueItem.liability = getLiability(identifierValueItem, sType, appQuoting, monthsLeft, AcctNbr, identifierValueItem, monthlyValue);
            //valueItem.liability = getLiability(identifierValueItem, sType, appQuoting, monthsLeft, AcctNbr);
            return valueItem;
            
        }
        return null;
    }
    **/
    
    private void getValueItemLiabilityLoanTerms(LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.ValueItem> valueItems,
                                                                           Application_Quoting__c appQuoting, String idType, String idNumber, 
                                                                           String identifier,String sType, Decimal value, String acctNbr, 
                                                               String frequency, String otherLoansLender, String hasLoan){
        if (sType != null && value != null && value != 0){
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            //String identifierValueItem = 'Liability007';
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            valueItem.attb_Value = StringUtils.convertToString(value);
            
            Decimal monthlyValue = value;
            if (monthlyValue == null){
                monthlyValue = 0;
            }
            monthlyValue = Utilities.getMonthlyValue (frequency , monthlyValue, scaleDecimal);
            
            getValueItemExpense(app, valueItems, EXPENSE, idNumber , identifier, 'LoanPayments', StringUtils.convertToString(monthlyValue), MONTHLY);
            valueItem.percentOwned = getPercentOwned (identifier, 100);
            valueItem.liability = getLiabilityLoanTerms(appQuoting, StringUtils.convertToString(appQuoting.Term__c), identifierValueItem, sType, acctNbr, EXPENSE + idNumber);
            
            app.relatedPartySegment.relatedParties.add(getRelatedParty('Lender', otherLoansLender, identifierValueItem + '_LENDER', identifierValueItem, hasLoan));
            valueItems.add(valueItem);
            
        }
    }
    
    
    private LibertyApplicationDTO.Liability getLiability (String identifierValueItem, String liabilityType, Application_Quoting__c appQuoting, 
                                                          String monthsLeft, String AcctNbr, 
                                                          String identifyLoan, Decimal valueTerm, String identifierExpense, Decimal unpaidBalance){
        LibertyApplicationDTO.Liability liability = new LibertyApplicationDTO.Liability();
        liability.attb_Type = Utilities.salesforceValueToMessageCode_Description(liabilityType, Utilities.LiB_LIABILITY_TYPES);
        liability.attb_UnpaidBalance = String.valueOf(Integer.valueOf(unpaidBalance));
    //liability.attb_UnpaidBalance = String.valueOf(NumberUtils.convertDecimalToScale(valueTerm, scaleDecimal));
        
        List<LibertyApplicationDTO.LoanTerm> loanTerms = new List<LibertyApplicationDTO.LoanTerm>();
        loanTerms.add(getLoanTerm ('Months', 60, 'TotalTerm', null));
        loanTerms.add(getLoanTerm (null, valueTerm, 'FixedRate', null));
        liability.existingLoan = getExistingLoan(identifierExpense, monthsLeft, loanTerms);
                                                              
        if ('PersonalLoan'.equalsIgnoreCase(liability.attb_Type)){
            liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem + '_LENDER');
            liability.accountNumber = new LibertyApplicationDTO.AccountNumber();
            liability.accountNumber.attb_AcctNbr = AcctNbr;
        }else{
          liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem + '_LENDER');
        }
        
        return liability;
    }
    
    /**
    private LibertyApplicationDTO.Liability getLiability (String identifierValueItem, String liabilityType, Application_Quoting__c appQuoting, 
                                                          String monthsLeft, String AcctNbr){
        LibertyApplicationDTO.Liability liability = new LibertyApplicationDTO.Liability();
        liability.attb_Type = Utilities.salesforceValueToMessageCode_Description(liabilityType, Utilities.LiB_LIABILITY_TYPES);
        liability.attb_UnpaidBalance = '999';
                                                              
        if ('PersonalLoan'.equalsIgnoreCase(liability.attb_Type)){
            liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem + '_LENDER');
            //liability.existingLoan = getExistingLoan('EXISTING_CAR_LOAN_EXPENSE', monthsLeft, loanTerms);
            List<LibertyApplicationDTO.LoanTerm> loanTerms = new List<LibertyApplicationDTO.LoanTerm>();
            loanTerms.add(getLoanTerm ('Months', appQuoting.Term__c, 'TotalTerm', null));
            loanTerms.add(getLoanTerm (null, appQuoting.Base_Rate__c, 'FixedRate', null));
            liability.existingLoan = getExistingLoan(EXPENSE + '007', monthsLeft, loanTerms);
            
            liability.accountNumber = new LibertyApplicationDTO.AccountNumber();
            liability.accountNumber.attb_AcctNbr = AcctNbr;
        }else{
          liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem + '_LENDER');
        }
        
        return liability;
    }
    **/
    private LibertyApplicationDTO.Liability getLiabilityLoanTerms (Application_Quoting__c appQuoting,String monthsLeft,  String identifierValueItem, 
                                                                   String liabilityType, String AcctNbr, String identifierExpense){
        LibertyApplicationDTO.Liability liability = new LibertyApplicationDTO.Liability();
        liability.attb_Type = Utilities.salesforceValueToMessageCode_Description(liabilityType, Utilities.LiB_LIABILITY_TYPES);
        liability.attb_UnpaidBalance = '' +appQuoting.Term__c;
        //liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem);
        List<LibertyApplicationDTO.LoanTerm> loanTerms = new List<LibertyApplicationDTO.LoanTerm>();
        loanTerms.add(getLoanTerm ('Months', appQuoting.Term__c, 'TotalTerm', null));
        loanTerms.add(getLoanTerm (null, appQuoting.Base_Rate__c, 'FixedRate', null));
        //liability.existingLoan = getExistingLoan('EXISTING_CAR_LOAN_EXPENSE', monthsLeft, loanTerms);
        liability.existingLoan = getExistingLoan(identifierExpense, monthsLeft, loanTerms);
        liability.relatedEntityRef = getRelatedEntityRef (identifierValueItem + '_LENDER');
                                                                       
        liability.accountNumber = new LibertyApplicationDTO.AccountNumber();
        liability.accountNumber.attb_AcctNbr = AcctNbr;
        return liability;
    }
    
    private LibertyApplicationDTO.ExistingLoan getExistingLoan(String relatedID,String monthsLeft, List<LibertyApplicationDTO.LoanTerm> loanTerms){
        LibertyApplicationDTO.ExistingLoan existingLoan = new LibertyApplicationDTO.ExistingLoan();
        existingLoan.attb_MonthsLeft = monthsLeft;
        existingLoan.relatedEntityRef = getRelatedEntityRef (relatedID);
        if (loanTerms != null && loanTerms.size() > 0){
            existingLoan.loanTerms = loanTerms;
        }
        return existingLoan;
    }
    
    private void getValueItemExpense(LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.ValueItem> valueItems, 
                                                                String idType, String idNumber, String identifier,String sType, String value, String sUnit){
        if (sType != null && value != null && !value.equalsIgnoreCase('') ){
            Decimal v = NumberUtils.convertStringToDecimal(value, scaleDecimal);
            if ( v == 0){
                return;
            }
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            valueItem.attb_Value = StringUtils.convertToString(Utilities.getMonthlyValue (sUnit , v, scaleDecimal));
            sUnit = Monthly; //After calculate
            valueItem.percentOwned = getPercentOwned (identifier, 100);
            
            valueItem.expense = getExpense(sUnit, sType);
            valueItems.add(valueItem);
        }
    }
    
    private LibertyApplicationDTO.Expense getExpense(String sUnit, String expenseType){
        LibertyApplicationDTO.Expense expense = new LibertyApplicationDTO.Expense();
        expense.attb_Type = expenseType;
        expense.period = getPeriod(sUnit, 'No', '12');
        return expense;
    }
    
    private void getValueItemIncome(LibertyApplicationDTO.Application app, List<LibertyApplicationDTO.ValueItem> valueItems,
                                                               String idType, String idNumber, String identifier,String sType, Decimal value, String sUnit){
        if (sType != null && value != null && value != 0){
            LibertyApplicationDTO.ValueItem valueItem = new LibertyApplicationDTO.ValueItem();
            //String identifierValueItem = Utilities.getEncrypt(StringUtils.convertToString(idType + idNumber), '$idValue');
            String identifierValueItem = idType + idNumber;
            valueItem.identifier = getIdentifier(TYPE_IDENTIFIER, identifierValueItem);
            
            Decimal monthlyValue = NumberUtils.convertDecimalToScale(value, scaleDecimal); 
            if (monthlyValue == null){
                monthlyValue = 0;
            }
            if ('007'.equalsIgnoreCase(idNumber)){
                sUnit = YEARLY;
            }else{
                sUnit = Utilities.validateFrequency(sUnit);
                monthlyValue = Utilities.getMonthlyValue (sUnit, monthlyValue, scaleDecimal);
            }
            
            //valueItem.attb_Value = StringUtils.convertToString(monthlyValue);
            valueItem.attb_Value = StringUtils.convertToString(monthlyValue);
            valueItem.percentOwned = getPercentOwned (identifier, 100);
            
            valueItem.income = getIncome(sType, 'GovernmentBenefits', sUnit);
            valueItems.add(valueItem);
        }
    }
    
    private LibertyApplicationDTO.Income getIncome(String incomeType, String governmentBenefitsType, String sUnit){
        LibertyApplicationDTO.Income income = new LibertyApplicationDTO.Income();
        //income.period = getPeriod('Monthly', 'No', '12');
        income.period = getPeriod(sUnit, 'No', null);
        //income.attb_AddbackType = '';
        //income.attb_Description = Utilities.salesforceValueToMessageCode_Code(incomeType, Utilities.LiB_INCOME_TYPES);
        String sType = Utilities.salesforceValueToMessageCode_Description(incomeType, Utilities.LiB_INCOME_TYPES);
        String subType = Utilities.salesforceValueToMessageCode_Description(sType, Utilities.LiB_LICENCE_TYPES_SUB);
        if (subType.startsWithIgnoreCase(Utilities.NO_VALUE_AVAILABLE)){
            income.attb_IncomeType = sType;
        }else{
            income.attb_GovernmentBenefitsType = sType;
            income.attb_IncomeType = subType;
        }
        return income;
    }
    
    private LibertyApplicationDTO.Period getPeriod (String sUnit, String sPreviousFinancialYear, String sMonthInYear){
        LibertyApplicationDTO.Period period = new LibertyApplicationDTO.Period();
        period.attb_Unit = sUnit;
        period.attb_PreviousFinancialYear = sPreviousFinancialYear;
        period.attb_MonthsInYear = sMonthInYear;
        return period;
    }
    
    private LibertyApplicationDTO.PercentOwned getPercentOwned (String identifier, Decimal value){
        LibertyApplicationDTO.PercentOwned percentOwned = new LibertyApplicationDTO.PercentOwned();
        percentOwned.relatedEntityRef = getRelatedEntityRef(identifier);
        percentOwned.attb_Percent = StringUtils.convertToString(value);
        return percentOwned;
    }
        
    private LibertyApplicationDTO.LoanDetailSegment getLoanDetailSegment(Custom_Opportunity__c opp, Application__c add, Application_Quoting__c appQuoting, String identifierApp){
        LibertyApplicationDTO.LoanDetailSegment loanDetailSegment = new LibertyApplicationDTO.LoanDetailSegment();
        String identifierLoan = Utilities.getEncrypt(StringUtils.convertToString(add.id), '$idLoan');
        loanDetailSegment.loanDetails = getLoanDetails(opp, add, appQuoting, 'ID_APPLICANT_LOAN_1', ASSET + FUTURE_CAR_ID);
        return loanDetailSegment;
    }
    
    private LibertyApplicationDTO.LoanDetails getLoanDetails (Custom_Opportunity__c opp, Application__c add, Application_Quoting__c appQuoting, String identifierApp, String identifierLoan){
        LibertyApplicationDTO.LoanDetails loanDetails = new LibertyApplicationDTO.LoanDetails();
        loanDetails.identifier = getIdentifier ('BrokerAssigned', identifierApp);
        loanDetails.security = getSecurity (identifierLoan);
        loanDetails.loanPurpose = getLoanPurpose (add, appQuoting);
        loanDetails.loanSplit = getLoanSplit (opp, add, appQuoting);
        return loanDetails;
    }
    
    private LibertyApplicationDTO.Security getSecurity (String identifierLoan){
        LibertyApplicationDTO.Security security = new LibertyApplicationDTO.Security();
        security.relatedEntityRef = getRelatedEntityRef (identifierLoan);
        return security;
    }
    
    private LibertyApplicationDTO.LoanPurpose getLoanPurpose (Application__c add, Application_Quoting__c appQuoting) {
        LibertyApplicationDTO.LoanPurpose loanPurpose = new LibertyApplicationDTO.LoanPurpose();
        loanPurpose.lendingPurposeCode = getLendingPurposeCode(add, appQuoting);
        return loanPurpose;
    }
    
    private LibertyApplicationDTO.LendingPurposeCode getLendingPurposeCode (Application__c add, Application_Quoting__c appQuoting){
        LibertyApplicationDTO.LendingPurposeCode lendingPurposeCode = new LibertyApplicationDTO.LendingPurposeCode();
        lendingPurposeCode.attb_LoanPortion = '0';
        lendingPurposeCode.attb_PurposeAmount = StringUtils.convertToString(appQuoting.Vehicle_Price__c);
        lendingPurposeCode.attb_Description = null; 
        lendingPurposeCode.vehiclePurpose = getVehiclePurpose(appQuoting.Trade_In__c, appQuoting.Deposit__c, appQuoting.Application_Fee__c, appQuoting.DOF__c,
                                                             null, 'Yes', 0, 'Private', appQuoting.Residual_Value__c);
        return lendingPurposeCode;
    }
    
    private LibertyApplicationDTO.VehiclePurpose  getVehiclePurpose(Decimal tradeInAmount, Decimal cashDeposit, Decimal lenderFee, Decimal applicationFee,
                                                                  Decimal gstAmount, String personalUse, Decimal lodgementFee, String vendorType, Decimal balloonResidual){
        LibertyApplicationDTO.VehiclePurpose vehiclePurpose = new LibertyApplicationDTO.VehiclePurpose();
        //LibertyApplicationDTO.VehicleTradeIn vehicleTradeIn = new LibertyApplicationDTO.VehicleTradeIn ();
        //vehicleTradeIn.attb_TradeInAmount = StringUtils.convertToString(tradeInAmount);
                                                                      
        //LibertyApplicationDTO.Vehicle vehicle = new LibertyApplicationDTO.Vehicle();
    //vehicle.relatedEntityRef = getRelatedEntityRef(ASSET + 'CAR');  
    //vehicle.relatedEntityRef = getRelatedEntityRef(EXISTING + 'CAR'); 
        //vehicleTradeIn.vehicle = vehicle;
        //vehiclePurpose.vehicleTradeIn = vehicleTradeIn;
        
        vehiclePurpose.attb_CashDeposit = StringUtils.convertToString(cashDeposit);
        vehiclePurpose.attb_LenderFee = StringUtils.convertToString(lenderFee);
        vehiclePurpose.attb_ApplicationFee = StringUtils.convertToString(applicationFee) ;
        vehiclePurpose.attb_ComprehensiveInsurance = null;
        vehiclePurpose.attb_ExtendedWarranty = null;
        vehiclePurpose.attb_FPAAmount = null; 
        vehiclePurpose.attb_ISPAmount = null;
        vehiclePurpose.attb_OtherCost = null;
        vehiclePurpose.attb_RateReduction = null;
        vehiclePurpose.attb_BalloonResidual = StringUtils.convertToString(balloonResidual);
        vehiclePurpose.attb_GSTAmount = StringUtils.convertToString(gstAmount);
        vehiclePurpose.attb_PersonalUse = personalUse;
        vehiclePurpose.attb_RepaymentInArrears = null;
        vehiclePurpose.attb_LodgementFee = StringUtils.convertToString(lodgementFee);
        vehiclePurpose.attb_VendorType = vendorType;
        return vehiclePurpose;
    }
    
    private LibertyApplicationDTO.LoanSplit getLoanSplit (Custom_Opportunity__c opp, Application__c add, Application_Quoting__c appQuoting){
        LibertyApplicationDTO.LoanSplit loanSplit = new LibertyApplicationDTO.LoanSplit();
        loanSplit.amountRequested = getAmountRequested (appQuoting.Vehicle_Price__c);
        
        
        List<LibertyApplicationDTO.LoanTerm> loanTerms = new List<LibertyApplicationDTO.LoanTerm>();
        loanTerms.add(getLoanTerm ('Months', appQuoting.Term__c, 'TotalTerm', null));
    loanTerms.add(getLoanTerm (null, null, 'FixedRate', null)); 
        loanTerms.add(getLoanTerm (null, null, null, 'PrincipleAndInterest')); 
        loanSplit.loanTerms =loanTerms ;        
        
        if ('Consumer Loan'.equalsIgnoreCase(appQuoting.Loan_Product__c)){
            loanSPlit.attb_ProductCode = '5100';
           loanSplit.attb_ProductName = 'LibertyConsumer';
        }else{
            loanSPlit.attb_ProductCode = '11000';
           loanSplit.attb_ProductName = 'LibertyCommercialChattelMortgage';
        }
        
        return loanSplit;
    }
    
    private LibertyApplicationDTO.AmountRequested getAmountRequested (Decimal amount){
        LibertyApplicationDTo.AmountRequested amountRequested = new LibertyApplicationDTO.AmountRequested ();
        amountRequested.attb_Amount = StringUtils.convertToString(amount);
        return amountRequested;
    }
    
    private LibertyApplicationDTO.LoanTerm getLoanTerm (String units, Decimal value, String loanType, String paymentType ){
        LibertyApplicationDTO.LoanTerm loanTerm = new LibertyApplicationDTO.LoanTerm();
        loanTerm.attb_Type = loanType;
        loanTerm.attb_PaymentType = paymentType;
        loanTerm.attb_Units = units;
        loanTerm.value = StringUtils.convertToString(value);
        return loanTerm;
    } 

    private void validateExceptionNull(Object obj, String field){
        if (obj == null){
            throw new GenericException (field + ' is required.' );
        }
    }
    
}