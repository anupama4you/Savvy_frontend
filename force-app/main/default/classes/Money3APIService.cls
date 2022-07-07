/**
 * Description : Apex callout to Money3 API service
 */
public class Money3APIService {

    String endPointApplication;
    String consumerKey;
    String documentEndpoint;
    String brokerID;
    Integer scaleDecimal = 2;

    public Money3APIService() {
        loadSettings();
    }

    private void loadSettings() {
        endPointApplication = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_ENDPOINT);
        documentEndpoint = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_DOCUMENT_ENDPOINT);
        consumerKey = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_TOKEN);
        brokerID = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_BROKER_ID);
    }

    public Money3APIManager requestApplication(Money3APIManager money3APIManager, Id oppId, String user, Boolean files) {
        if(submitRequest(money3APIManager, oppId, null, files)){
            ConnectionRESTWs conn;
            String body = getMoney3Application(oppId, user).serialize(true);
            String newBody = body.replaceAll('limit_m', 'limit');
            money3APIManager.reqBody = newBody;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Body: [' + newBody + ']'));
            conn = new ConnectionRESTWs(endPointApplication, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
            System.debug(endPointApplication);
            System.debug(conn);
            String authorizationHeader = 'Bearer ' + consumerKey;
            System.debug(consumerKey);
            Map<String, String> requestHeader = new Map<String, String>();
            requestHeader.put(Money3Constants.AUTHORIZATION, authorizationHeader);
            requestHeader.put(Money3Constants.ACCEPT, ConnectionRESTWs.CONTENT_TYPE_JSON);
            System.debug(requestHeader);
            System.debug('@@Money3 body:');
            System.debug(newBody);
            HttpResponse resp;
            //try{
                resp = conn.connectionServiceHttpResponse(requestHeader, newBody);
                System.debug(resp);
            //}catch (GenericException ex){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
            //}
            validateResponse(resp, money3APIManager);
            
            try{
                System.debug('@@Money3 Application*. -[' + money3APIManager.responseMessage + ']');
                money3APIManager.parseCreateApplicationResponse(money3APIManager.responseMessage);
            }catch (GenericException ex){
                money3APIManager.isError = true;
                money3APIManager.message = resp != null && resp.getStatusCode() == 403 
                ? 'The server understood the request, but is refusing to authorize it.'
                : ex.getMessage();
                
                throw new GenericException ('[Money3 Application] ' + money3APIManager.message, ex);
            }
            
            //upload documents
            if(money3APIManager.responseStatus == Money3Constants.STATUS_OK && money3APIManager.responseDto.loanId != null){
                uploadDocumentsToMoney3(money3APIManager, oppId, money3APIManager.responseDto.loanId, false);
            }
        }
        return money3APIManager;
    }

    private void validateResponse(HttpResponse resp, Money3APIManager money3APIManager){
        money3APIManager.isError = false;
		    money3APIManager.message = '@!Ok';
        if (resp != null){
            money3APIManager.responseStatus = resp.getStatusCode();
            money3APIManager.responseMessage = resp.getBody();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'from Money3: [' + resp.getBody() + ']'));
            if (money3APIManager.responseStatus != Money3Constants.STATUS_OK){
                money3APIManager.isError = true;
                money3APIManager.message = '[' + money3APIManager.responseStatus + ']';
            }
            // Record transaction
        }else{
            money3APIManager.isError = true;
            money3APIManager.message = '@Please, check service response';
        }
        System.debug('@validateResponse: -[' + money3APIManager.message + ']');
    }

    public Money3APIRequestDTO getMoney3Application(Id oppId, String user) {
        if (StringUtils.isNullOrEmpty(user)){
            throw new GenericException ('Missing Money3 user. Please select one.');
        }
        Money3APIRequestDTO request = new Money3APIRequestDTO();
        //get custom opportunity
        Custom_Opportunity__c opp = Money3APIManager.getCustomOpportunityForMoney3Application(oppId);
        //get application quoting
        Application_Quoting__c appQuoting = QuotingToolHelper.getApplicationQuoting(oppId, opp.Application__c);
        if (appQuoting == null){
            throw new GenericException ('Please make sure calculate before send to Money3 API.');
        }
        
        Application__c app = opp.Application__r;
        System.debug(app.Status__c);
        if (app == null) {
          throw new GenericException ('Application not found, please fill one in Application Form.');
        } else if (!'F'.equals(app.Status__c)) {
          throw new GenericException ('Application should be Finished, please fill completely the Application Form.');
        }
        //get loan details
        request.brokerLoanReferenceId = Utilities.getGUID();
        request.loanType = getMoney3LoanType(appQuoting.Loan_Type__c);
        request.loanAmount = appQuoting.Vehicle_Price__c;
        request.loanDuration = appQuoting.Term__c != null ? appQuoting.Term__c.intValue() : 0;
        request.purpose = appQuoting.Loan_Purpose__c != null ? appQuoting.Loan_Purpose__c : '';
        //get broker details
        request.broker = getBrokerDetails(user);
        // Partner name
        if (opp.Partner_Owner__c != null && !opp.Franchise_Owner__c) {
          request.broker.company = String.isNotBlank(opp.Partner_Owner__r.Name) ? opp.Partner_Owner__r.Name : opp.Owner_Name__c;
        }
        //get applicants details
        request.applicants = getApplicants(app);
        //get owners
        List<String> ownerIds = new List<String>();
        for(Money3APIRequestDTO.Applicant applicant : request.applicants){
            ownerIds.add(applicant.id);
        }
        //get applicant assets
        Map<String, List<Application_Other_Asset__c>> otherAssetMap = ApplicationService.getApplicationOtherAssetsMap(app.Id);
        //get redidential asset details
        request.residentialAssets = getResidentialAssets(app, otherAssetMap, ownerIds);
        //get asset details
        request.assets = getAssets(app, otherAssetMap, ownerIds);
        //get expense details
        request.expenses = getExpenses(app, ownerIds);
        //get liability details
        request.liabilities = getLiabilities(app, otherAssetMap, request, ownerIds);
        //get income details
        request.incomes = getIncomes(app, request);
        //get security details
        request.security = getSecurity(opp);
        //get insurance details
        request.insurances = getInsurances(appQuoting);
        //get notes details
        request.notes = getNotes(app);
        return request;
    }

    private String getMoney3LoanType(String loanType) {
        String money3LoanType = '';
        if(!StringUtils.isNullOrEmpty(loanType)){
            if(loanType.equalsIgnoreCase('Purchase'))
                money3LoanType = 'Car purchase';
            else if(loanType.equalsIgnoreCase('Refinance'))
                money3LoanType = 'Refinance';
        }
        return money3LoanType;
    }

    private Money3APIRequestDTO.Broker getBrokerDetails(String userName) {
        Money3APIRequestDTO.Broker broker = new Money3APIRequestDTO.Broker();
        System.debug(userName);
        Lender_Login__c user = Money3APIManager.getLenderLoginUser(userName);
        if(user != null){
          if (String.isBlank(user.User_Name__c) || !user.User_Name__c.isNumeric()) {
            throw new GenericException('Broker Id must be a number, please check it out in your Money3 Lender Login details. Current value [' + user.User_Name__c + ']');
          }
          broker.id = Integer.valueOf(user.User_Name__c);
          broker.firstName = StringUtils.validateNull(user.Name);
          broker.lastName = StringUtils.validateNull(user.Name);
          broker.company = 'SAVVY FINANCE AND INSURANCE';
          broker.companyId = Integer.valueOf(brokerID);
        } else {
            throw new GenericException ('Missing API user in the request.');
        }
        return broker;
    }

    private List<Money3APIRequestDTO.Applicant> getApplicants(Application__c app) {
        List<Money3APIRequestDTO.Applicant> applicants = new List<Money3APIRequestDTO.Applicant>();
        //get primary applicant
        Money3APIRequestDTO.Applicant primaryApplicant = getPrimaryApplicant(app);
        applicants.add(primaryApplicant);
        //get co-applicant 
        if(isAdditionalApplicant(app)){
            Money3APIRequestDTO.Applicant coApplicant = getCoApplicant(app);
            applicants.add(coApplicant);
        }
        return applicants;
    }

    private Money3APIRequestDTO.Applicant getPrimaryApplicant(Application__c app) {
        Money3APIRequestDTO.Applicant applicant = new Money3APIRequestDTO.Applicant();
        applicant.id = Utilities.getGUID();
        applicant.title = StringUtils.validateNull(app.Title_1__c);
        applicant.firstName = app.First_Name__c;
        applicant.middleName = StringUtils.validateNull(app.Middle_Name__c);
        applicant.lastName = app.Last_Name__c;
        if(app.Gender_1__c != null){
            String gender = getGender(app.Gender_1__c);
            if(gender != null){
                applicant.gender = gender;
            }
        }
        applicant.dateOfBirth = DateUtils.convertToDate(app.Date_of_Birth_1__c);
        applicant.isAustralianPermanentResident = (app.Current_Residential_Status_1__c != null && Money3Constants.RESIDENCY_STATUS.contains(app.Current_Residential_Status_1__c)); 
        if(String.isNotBlank(app.Marital_Status_1__c)){
            applicant.maritalStatus = getMaritalStatus(app.Marital_Status_1__c);
        }
        applicant.dependants = app.No_of_Dependants_1__c != null ? app.No_of_Dependants_1__c.intValue() : 0;
        if(String.isNotBlank(app.Ages_of_Dependants_1__c)){
            applicant.dependantsAge = app.Ages_of_Dependants_1__c.replace(' ', '');
        }
        if(!StringUtils.isNullOrEmpty(app.Home_Phone__c)){
            applicant.homePhone = StringUtils.removeAllCharacters(app.Home_Phone__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Work_Phone__c)){
            applicant.workPhone = StringUtils.removeAllCharacters(app.Work_Phone__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Mobile_Number__c)){
            applicant.mobile = StringUtils.removeAllCharacters(app.Mobile_Number__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Email_Address__c)){
            applicant.email = app.Email_Address__c;
        }
        applicant.preferredContactMethod = 'Email';
        applicant.bestTimeToCall = 'Morning';
        if(!StringUtils.isNullOrEmpty(app.Has_Been_Bankrupt__c)){
            applicant.bankruptcyStatus = getBankruptStatus(app.Has_Been_Bankrupt__c);
        }
        //get spouse details
        if(!StringUtils.isNullOrEmpty(app.First_Name_2__c) && !StringUtils.isNullOrEmpty(app.Last_Name_2__c)){
            Money3APIRequestDTO.Spouse spouse = new Money3APIRequestDTO.Spouse();
            spouse.name = app.First_Name_2__c + app.Last_Name_2__c;
            spouse.employerName = StringUtils.validateNull(app.Current_Employer_Name_2__c);
            spouse.netIncomeAmount = app.Net_Income_2__c != null ? app.Net_Income_2__c : 0;
        }
        //get identification documents
        applicant.identifications = getIdentifications(app, true);
        //get addressess
        applicant.addresses = getAddresses(app, true);
        //get employments
        applicant.employments = getEmployments(app, true);
        //get references
        applicant.references = getReferences(app, true);
        return applicant;
    }

    private String getGender(String gender){
        String gdr;
        if (gender.equalsIgnoreCase('F') || gender.equalsIgnoreCase('Female')){
            gdr = 'Female';
        }else if (gender.equalsIgnoreCase('M') || gender.equalsIgnoreCase('Male')){
            gdr = 'Male';
        }
        return gdr;
    }

    private Money3APIRequestDTO.Applicant getCoApplicant(Application__c app) {
        Money3APIRequestDTO.Applicant applicant = new Money3APIRequestDTO.Applicant();
        applicant.id = Utilities.getGUID();
        applicant.title = StringUtils.validateNull(app.Title_2__c);
        applicant.firstName = app.First_Name_2__c;
        applicant.middleName = StringUtils.validateNull(app.Middle_Name_2__c);
        applicant.lastName = app.Last_Name_2__c;
        if(app.Gender_2__c != null){
            String gender = getGender(app.Gender_2__c);
            if(gender != null){
                applicant.gender = gender;
            }
        }
        applicant.dateOfBirth = DateUtils.convertToDate(app.Date_of_Birth_2__c);
        applicant.isAustralianPermanentResident = (app.Current_Residential_Status_2__c != null && Money3Constants.RESIDENCY_STATUS.contains(app.Current_Residential_Status_2__c)); 
        if(String.isNotBlank(app.Marital_Status_2__c)){
            applicant.maritalStatus = getMaritalStatus(app.Marital_Status_2__c);
        }
        applicant.dependants = app.No_of_Dependants_2__c != null ? app.No_of_Dependants_2__c.intValue() : 0;
        if(String.isNotBlank(app.Ages_of_Dependants_2__c)){
            applicant.dependantsAge = app.Ages_of_Dependants_2__c.replace(' ', '');
        }
        if(!StringUtils.isNullOrEmpty(app.Home_Phone_2__c)){
            applicant.homePhone = StringUtils.removeAllCharacters(app.Home_Phone_2__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Work_Phone_2__c)){
            applicant.workPhone = StringUtils.removeAllCharacters(app.Work_Phone_2__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Mobile_Number_2__c)){
            applicant.mobile = StringUtils.removeAllCharacters(app.Mobile_Number_2__c);
        }
        if(!StringUtils.isNullOrEmpty(app.Email_Address_2__c)){
            applicant.email = app.Email_Address_2__c;
        }
        applicant.preferredContactMethod = 'Email';
        applicant.bestTimeToCall = 'Morning';
        if(!StringUtils.isNullOrEmpty(app.Has_Been_Bankrupt__c)){
            applicant.bankruptcyStatus = getBankruptStatus(app.Has_Been_Bankrupt__c);
        }
        //get spouse details
        if(!StringUtils.isNullOrEmpty(app.First_Name__c) && !StringUtils.isNullOrEmpty(app.Last_Name__c)){
            Money3APIRequestDTO.Spouse spouse = new Money3APIRequestDTO.Spouse();
            spouse.name = app.First_Name__c + app.Last_Name__c;
            spouse.employerName = StringUtils.validateNull(app.Current_Employer_Name_1__c);
            spouse.netIncomeAmount = app.Net_Income_1__c != null ? app.Net_Income_1__c : 0;
        }
        //get identification documents
        applicant.identifications = getIdentifications(app, false);
        //get addressess
        applicant.addresses = getAddresses(app, false);
        //get employments
        applicant.employments = getEmployments(app, false);
        //get references
        applicant.references = getReferences(app, false);
        return applicant;
    }

    private String getMaritalStatus(String maritalStatus){
        String status;
        switch on maritalStatus {
            when 'Defacto' {
                status = 'De Facto';
            }
            when else {
                status = maritalStatus;
            }
        }
        return status;
    }

    private String getBankruptStatus(String bankruptStatus){
        String status;
        switch on bankruptStatus {
            when 'Y' {
                status = 'Yes';
            }
            when else {
                status = 'No';
            }
        }
        return status;
    }

    private Boolean isAdditionalApplicant(Application__c app){
        return app != null && app.No_of_People__c == 2;
    }

    private List<Money3APIRequestDTO.Identification> getIdentifications(Application__c app, Boolean isPrimary) {
        List<Money3APIRequestDTO.Identification> identifications = new List<Money3APIRequestDTO.Identification>();
        Money3APIRequestDTO.Identification identification = new Money3APIRequestDTO.Identification();
        identification.identificationType = 'Drivers Licence';
        identification.countryOfIssue = 'Australia';
        identification.isVerified = true;
        if(isPrimary && !StringUtils.isNullOrEmpty(app.Drivers_License_1__c)){
            identification.identificationNumber = app.Drivers_License_1__c;
            identification.stateOfIssue = getState(app.Driver_Licence_State_Issue_1__c);
            identification.expiryDate = DateUtils.convertToDate(app.Expiry_Date_1__c);
            identifications.add(identification);
        } else if(!isPrimary && !StringUtils.isNullOrEmpty(app.Drivers_License_2__c)){
            identification.identificationNumber = app.Drivers_License_2__c;
            identification.stateOfIssue = getState(app.Driver_Licence_State_Issue_2__c);
            identification.expiryDate = DateUtils.convertToDate(app.Expiry_Date_2__c);
            identifications.add(identification);
        }
        return identifications;
    }

    private String getState(String issueState){
        String state;
        switch on issueState {
            when 'WA' {
                state = 'W.A';
            }
            when 'SA' {
                state = 'S.A';
            }
            when 'NT' {
                state = 'N.T';
            }
            when else {
                state = issueState;
            }
        }
        return state;
    }

    private List<Money3APIRequestDTO.Address> getAddresses(Application__c app, Boolean isPrimary) {
        List<Money3APIRequestDTO.Address> addresses = new List<Money3APIRequestDTO.Address>();
        Money3APIRequestDTO.Address address = new Money3APIRequestDTO.Address();
        address.isDefaultResidentialAddress = true;
        address.isDefaultMailingAddress = true;
        address.addressType = 'Residential';

        if(isPrimary){
            if(app.Street_Type__c != null && Money3Constants.STREET_TYPE.contains(app.Street_Type__c)){
                address.streetType = app.Street_Type__c;
            }
            address.unit = app.Unit_Number__c;
            address.streetNumber = app.Street_Number__c;
            address.streetName = app.Street_Address__c;
            address.suburb = app.Suburb__c;
            address.postcode = app.Postcode__c;
            address.state = getState(app.State__c);
            //property
            Money3APIRequestDTO.Property property = new Money3APIRequestDTO.Property();
            property.residentialStatus = getResidentialStatus(app.Current_Residence_Status_1__c);
            Date startDate = DateUtils.convertToDate(app.Date_Moved_in_1__c);
            if(startDate != null){
                property.addressStartDate = startDate;
                property.periodYear = DateUtils.getHowManyYears(startDate, System.today());
                property.periodMonth = DateUtils.getHowManyMonths(startDate, System.today());
            }
            address.property = property;
            //boarding or with parents contact
            if(property.residentialStatus == 'Boarding' || property.residentialStatus == 'Living with parents'){
                Money3APIRequestDTO.BoardingOrWithParentsContact boardingContact = new Money3APIRequestDTO.BoardingOrWithParentsContact();
                boardingContact.contactName = app.Landlord_Name_1__c;
                boardingContact.phone = StringUtils.removeAllCharacters(app.Landlord_Phone_1__c);
                address.boardingOrWithParentsContact = boardingContact;
            }
            //renting contact
            if(property.residentialStatus == 'Renting'){
                Money3APIRequestDTO.RentingContact rentingContact = new Money3APIRequestDTO.RentingContact();
                rentingContact.contactName = app.Landlord_Name_1__c;
                rentingContact.phone = StringUtils.removeAllCharacters(app.Landlord_Phone_1__c);
                address.rentingContact = rentingContact;
            }
            //mortgage contact
            if(property.residentialStatus == 'Mortgage'){
                Money3APIRequestDTO.MortgageContact mortgageContact = new Money3APIRequestDTO.MortgageContact();
                mortgageContact.financier = app.Landlord_Name_1__c;
                address.mortgageContact = mortgageContact;
            }
            addresses.add(address);
        } else {
            if(app.Street_Type_2__c != null && Money3Constants.STREET_TYPE.contains(app.Street_Type_2__c)){
                address.streetType = app.Street_Type_2__c;
            }
            address.unit = app.Unit_Number_2__c;
            address.streetNumber = app.Street_Number_2__c;
            address.streetName = app.Street_Address_2__c;
            address.suburb = app.Suburb_2__c;
            address.postcode = app.Postcode_2__c;
            address.state = getState(app.State_2__c);
            //property
            Money3APIRequestDTO.Property property = new Money3APIRequestDTO.Property();
            property.residentialStatus = getResidentialStatus(app.Current_Residence_Status_2__c);
            Date startDate = DateUtils.convertToDate(app.Date_Moved_in_2__c);
            if(startDate != null){
                property.addressStartDate = startDate;
                property.periodYear = DateUtils.getHowManyYears(startDate, System.today());
                property.periodMonth = DateUtils.getHowManyMonths(startDate, System.today());
            }
            address.property = property;
            //boarding or with parents contact
            if(property.residentialStatus == 'Boarding' || property.residentialStatus == 'Living with parents'){
                Money3APIRequestDTO.BoardingOrWithParentsContact boardingContact = new Money3APIRequestDTO.BoardingOrWithParentsContact();
                boardingContact.contactName = app.Landlord_Name_2__c;
                boardingContact.phone = StringUtils.removeAllCharacters(app.Landlord_Phone_2__c);
                address.boardingOrWithParentsContact = boardingContact;
            }
            //renting contact
            if(property.residentialStatus == 'Renting'){
                Money3APIRequestDTO.RentingContact rentingContact = new Money3APIRequestDTO.RentingContact();
                rentingContact.contactName = app.Landlord_Name_2__c;
                rentingContact.phone = StringUtils.removeAllCharacters(app.Landlord_Phone_2__c);
                address.rentingContact = rentingContact;
            }
            //mortgage contact
            if(property.residentialStatus == 'Mortgage'){
                Money3APIRequestDTO.MortgageContact mortgageContact = new Money3APIRequestDTO.MortgageContact();
                mortgageContact.financier = app.Landlord_Name_2__c;
                address.mortgageContact = mortgageContact;
            }
            addresses.add(address);
        }
        return addresses;
    }

    private String getResidentialStatus(String residentialStatus){
        String status;
        if(String.isNotBlank(residentialStatus)){
            if(residentialStatus.equalsIgnoreCase('Boarding'))
                status = 'Boarding';
            else if(residentialStatus.equalsIgnoreCase('Own Outright'))
                status = 'Home Owner';
            else if(residentialStatus.equalsIgnoreCase('Renting(Private)') || residentialStatus.equalsIgnoreCase('Renting(Agent)'))
                status = 'Renting';
            else if(residentialStatus.equalsIgnoreCase('Mortgage'))
                status = 'Mortgage';
            else if(residentialStatus.equalsIgnoreCase('Parents/Relative'))
                status = 'Living with parents';
            else 
                status = 'Other';
        }
        return status;
    }

    private List<Money3APIRequestDTO.Employment> getEmployments(Application__c app, Boolean isPrimary) {
        List<Money3APIRequestDTO.Employment> employments = new List<Money3APIRequestDTO.Employment>();
        //get current employment
        Money3APIRequestDTO.Employment currentEmployment = new Money3APIRequestDTO.Employment();
        if(isPrimary){
            currentEmployment.id = Utilities.getGUID();
            currentEmployment.employerName = StringUtils.validateNull(app.Current_Employer_Name_1__c);
            currentEmployment.contactPhone = StringUtils.removeAllCharacters(app.Current_Employer_Phone_1__c);
            currentEmployment.contactPerson = app.Reference_Name_1__c;
            if(String.isNotBlank(app.Current_Occupation_1__c) && Money3Constants.OCCUPATION_LIST.contains(app.Current_Occupation_1__c)){
                currentEmployment.occupation = app.Current_Occupation_1__c;
            }
            else{
                currentEmployment.occupation = 'Other';
                currentEmployment.jobTitle = app.Current_Occupation_1__c != null ? app.Current_Occupation_1__c : '';
            }
            currentEmployment.startDate = DateUtils.convertToDate(app.Date_Started_1__c);
            if(currentEmployment.startDate != null){
                currentEmployment.serviceYear = DateUtils.getHowManyYears(currentEmployment.startDate, System.today());
                currentEmployment.serviceMonth = DateUtils.getHowManyYears(currentEmployment.startDate, System.today());
            }
            currentEmployment.employmentStatus = getEmploymentStatus(app.Mode_of_Employment_1__c);
            currentEmployment.isCurrentEmployment = true;
            currentEmployment.isPrimaryEmployment = true;
            currentEmployment.isOnProbation = false;
            currentEmployment.employerAbn = app.Employer_ABN_1__c;
            currentEmployment.addressUnit = app.Current_Work_Unit_Number_1__c;
            currentEmployment.addressStreetNumber = app.Current_Work_Street_Number_1__c;
            currentEmployment.addressStreetName = app.Current_Work_Address_1__c;
            if(app.Current_Work_Street_Type_1__c != null && Money3Constants.STREET_TYPE.contains(app.Current_Work_Street_Type_1__c)){
                currentEmployment.addressStreetType = app.Current_Work_Street_Type_1__c;
            }
            currentEmployment.addressSuburb = app.Current_Work_Suburb_1__c;
            currentEmployment.addressState = getState(app.Current_Work_State_1__c);
            currentEmployment.addressPostcode = app.Current_Work_Postcode_1__c;
            employments.add(currentEmployment);
        } else {
            currentEmployment.id = Utilities.getGUID();
            currentEmployment.employerName = StringUtils.validateNull(app.Current_Employer_Name_2__c);
            currentEmployment.contactPhone = StringUtils.removeAllCharacters(app.Current_Employer_Phone_2__c);
            currentEmployment.contactPerson = app.Reference_Name_2__c;
            if(String.isNotBlank(app.Current_Occupation_2__c) && Money3Constants.OCCUPATION_LIST.contains(app.Current_Occupation_2__c)){
                currentEmployment.occupation = app.Current_Occupation_2__c;
            }
            else{
                currentEmployment.occupation = 'Other';
                currentEmployment.jobTitle = app.Current_Occupation_2__c != null ? app.Current_Occupation_2__c : '';
            }
            currentEmployment.startDate = DateUtils.convertToDate(app.Date_Started_2__c);
            if(currentEmployment.startDate != null){
                currentEmployment.serviceYear = DateUtils.getHowManyYears(currentEmployment.startDate, System.today());
                currentEmployment.serviceMonth = DateUtils.getHowManyYears(currentEmployment.startDate, System.today());
            }
            currentEmployment.employmentStatus = getEmploymentStatus(app.Mode_of_Employment_2__c);
            currentEmployment.isCurrentEmployment = true;
            currentEmployment.isPrimaryEmployment = true;
            currentEmployment.isOnProbation = false;
            currentEmployment.employerAbn = null;
            currentEmployment.addressUnit = app.Current_Work_Unit_Number_2__c;
            currentEmployment.addressStreetNumber = app.Current_Work_Street_Number_2__c;
            currentEmployment.addressStreetName = app.Current_Work_Address_2__c;
            if(app.Current_Work_Street_Type_2__c != null && Money3Constants.STREET_TYPE.contains(app.Current_Work_Street_Type_2__c)){
                currentEmployment.addressStreetType = app.Current_Work_Street_Type_2__c;
            }
            currentEmployment.addressSuburb = app.Current_Work_Suburb_2__c;
            currentEmployment.addressState = getState(app.Current_Work_State_2__c);
            currentEmployment.addressPostcode = app.Current_Work_Postcode_2__c;
            employments.add(currentEmployment);
        }
        //get previous employment
        Money3APIRequestDTO.Employment previousEmployment = new Money3APIRequestDTO.Employment();
        if(isPrimary && String.isNotBlank(app.Previous_Mode_of_Employment_1__c)){
            previousEmployment.id = Utilities.getGUID();
            previousEmployment.employerName = StringUtils.validateNull(app.Previous_Employer_Name_1__c);
            previousEmployment.contactPhone = StringUtils.removeAllCharacters(app.Previous_Employer_Phone_1__c);
            previousEmployment.contactPerson = app.Previous_Reference_Name_1__c;
            if(String.isNotBlank(app.Previous_Occupation_1__c) && Money3Constants.OCCUPATION_LIST.contains(app.Previous_Occupation_1__c)){
                previousEmployment.occupation = app.Previous_Occupation_1__c;
            }
            else{
                previousEmployment.occupation = 'Other';
                previousEmployment.jobTitle = app.Previous_Occupation_1__c != null ? app.Previous_Occupation_1__c : '';
            }
            previousEmployment.startDate = DateUtils.convertToDate(app.Start_Date_1__c);
            previousEmployment.endDate = DateUtils.convertToDate(app.Finish_Date_1__c);
            if(previousEmployment.startDate != null && previousEmployment.endDate != null){
                previousEmployment.serviceYear = DateUtils.getHowManyYears(previousEmployment.startDate, previousEmployment.endDate);
                previousEmployment.serviceMonth = DateUtils.getHowManyYears(previousEmployment.startDate, previousEmployment.endDate);
            }
            previousEmployment.employmentStatus = getEmploymentStatus(app.Previous_Mode_of_Employment_1__c);
            previousEmployment.isCurrentEmployment = false;
            previousEmployment.isPrimaryEmployment = false;
            previousEmployment.isOnProbation = false;
            previousEmployment.employerAbn = null;
            previousEmployment.addressUnit = app.Previous_Work_Unit_Number_1__c;
            previousEmployment.addressStreetNumber = app.Previous_Work_Street_Number_1__c;
            previousEmployment.addressStreetName = app.Previous_Work_Address_1__c;
            if(app.Previous_Work_Street_Type_1__c != null && Money3Constants.STREET_TYPE.contains(app.Previous_Work_Street_Type_1__c)){
                previousEmployment.addressStreetType = app.Previous_Work_Street_Type_1__c;
            }
            previousEmployment.addressSuburb = app.Previous_Work_Suburb_1__c;
            previousEmployment.addressState = getState(app.Previous_Work_State_1__c);
            previousEmployment.addressPostcode = app.Previous_Work_Postcode_1__c;
            employments.add(previousEmployment);
        } else if(!isPrimary && String.isNotBlank(app.Previous_Mode_of_Employment_2__c)){
            previousEmployment.id = Utilities.getGUID();
            previousEmployment.employerName = StringUtils.validateNull(app.Previous_Employer_Name_2__c);
            previousEmployment.contactPhone = StringUtils.removeAllCharacters(app.Previous_Employer_Phone_2__c);
            previousEmployment.contactPerson = app.Previous_Reference_Name_2__c;
            if(String.isNotBlank(app.Previous_Occupation_2__c) && Money3Constants.OCCUPATION_LIST.contains(app.Previous_Occupation_2__c)){
                previousEmployment.occupation = app.Previous_Occupation_2__c;
            }
            else{
                previousEmployment.occupation = 'Other';
                previousEmployment.jobTitle = app.Previous_Occupation_2__c != null ? app.Previous_Occupation_2__c : '';
            }
            previousEmployment.startDate = DateUtils.convertToDate(app.Start_Date_2__c);
            previousEmployment.endDate = DateUtils.convertToDate(app.Finish_Date_2__c);
            if(previousEmployment.startDate != null && previousEmployment.endDate != null){
                previousEmployment.serviceYear = DateUtils.getHowManyYears(previousEmployment.startDate, previousEmployment.endDate);
                previousEmployment.serviceMonth = DateUtils.getHowManyYears(previousEmployment.startDate, previousEmployment.endDate);
            }
            previousEmployment.employmentStatus = getEmploymentStatus(app.Previous_Mode_of_Employment_2__c);
            previousEmployment.isCurrentEmployment = false;
            previousEmployment.isPrimaryEmployment = false;
            previousEmployment.isOnProbation = false;
            previousEmployment.employerAbn = null;
            previousEmployment.addressUnit = app.Previous_Work_Unit_Number_2__c;
            previousEmployment.addressStreetNumber = app.Previous_Work_Street_Number_2__c;
            previousEmployment.addressStreetName = app.Previous_Work_Address_2__c;
            if(app.Previous_Work_Street_Type_2__c != null && Money3Constants.STREET_TYPE.contains(app.Previous_Work_Street_Type_2__c)){
                previousEmployment.addressStreetType = app.Previous_Work_Street_Type_2__c;
            }
            previousEmployment.addressSuburb = app.Previous_Work_Suburb_2__c;
            previousEmployment.addressState = getState(app.Previous_Work_State_2__c);
            previousEmployment.addressPostcode = app.Previous_Work_Postcode_2__c;
            employments.add(previousEmployment);
        }
        return employments;
    }

    private String getEmploymentStatus(String modeEmployment){
        String status;
        if(modeEmployment.equalsIgnoreCase('Full Time') || modeEmployment.equalsIgnoreCase('Full-Time')){
            status = 'Full Time';
        } else if(modeEmployment.equalsIgnoreCase('Part Time') || modeEmployment.equalsIgnoreCase('Part-Time')){
            status = 'Part Time';
        } else if(modeEmployment.equalsIgnoreCase('Self Employed')){
            status = 'Self-Employed';
        } else if(modeEmployment.equalsIgnoreCase('Casual')){
            status = 'Casual More Than 20hrs';
        } else if(modeEmployment.equalsIgnoreCase('Contract')){
            status = 'Contractor';
        } else {
            status = 'Benefits';
        }
        return status;
    }

    private List<Money3APIRequestDTO.Reference> getReferences(Application__c app, Boolean isPrimary) {
        List<Money3APIRequestDTO.Reference> references = new List<Money3APIRequestDTO.Reference>();
        Money3APIRequestDTO.Reference reference = new Money3APIRequestDTO.Reference();
        if(isPrimary){
            reference.relationship = app.Personal_Reference_1_Relationship__c;
            reference.name = app.Personal_Reference_1_Full_Name__c;
            reference.homePhone = StringUtils.removeAllCharacters(app.Personal_Reference_1_Phone__c);
            reference.workPhone = StringUtils.removeAllCharacters(app.Personal_Reference_1_Phone__c);
            reference.mobile = StringUtils.removeAllCharacters(app.Personal_Reference_1_Phone__c);
            references.add(reference);
        } else {
            reference.relationship = app.Personal_Reference_2_Relationship__c;
            reference.name = app.Personal_Reference_2_Full_Name__c;
            reference.homePhone = StringUtils.removeAllCharacters(app.Personal_Reference_2_Phone__c);
            reference.workPhone = StringUtils.removeAllCharacters(app.Personal_Reference_2_Phone__c);
            reference.mobile = StringUtils.removeAllCharacters(app.Personal_Reference_2_Phone__c);
            references.add(reference);
        }
        return references;
    }

    private List<Money3APIRequestDTO.ResidentialAsset> getResidentialAssets(Application__c app, Map<String, List<Application_Other_Asset__c>> otherAssetMap, List<String> ownerIds){
        List<Money3APIRequestDTO.ResidentialAsset> resAssets = new List<Money3APIRequestDTO.ResidentialAsset>();
        //Property assets
        if(otherAssetMap.containsKey(ApplicationService.PROPERTY_ASSET_TYPE)){
            //get the first asset and send to money3 as we don't have mandatory fields required for money3 at our end.
            Application_Other_Asset__c property = otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE)[0];
            Money3APIRequestDTO.ResidentialAsset resAsset = new Money3APIRequestDTO.ResidentialAsset();
            resAsset.owners = ownerIds;
            resAsset.estimatedAmount = property.Value__c;
            resAsset.purchasedDate = DateUtils.convertToDate('01/01/2001'); //set the static date as we don't have data
            resAsset.addressStreetNumber = app.Street_Number__c;
            resAsset.addressStreetName = app.Street_Address__c;
            resAsset.addressSuburb = app.Suburb__c;
            resAsset.addressState = getState(app.State__c);
            resAsset.addressPostcode = app.Postcode__c;
            resAssets.add(resAsset);
        }
        return resAssets;
    }

    private List<Money3APIRequestDTO.Asset> getAssets(Application__c app, Map<String, List<Application_Other_Asset__c>> otherAssetMap, List<String> ownerIds){
        List<Money3APIRequestDTO.Asset> assets = new List<Money3APIRequestDTO.Asset>();
        //Vehicle assets
        if (otherAssetMap.containsKey(ApplicationService.VEHICLE_ASSET_TYPE)) {
            for(Application_Other_Asset__c vehicleAsset : otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE)){
                setMoney3Asset(assets, ownerIds, 'Motor Vehicle', vehicleAsset.Value__c);
            }
        }
        //Savings
        if(app.Bank_Value__c != null){
            setMoney3Asset(assets, ownerIds, 'Cheque/Saving Account', app.Bank_Value__c);
        }
        //Super
        if(app.Super_Value_How_Much__c != null){
            setMoney3Asset(assets, ownerIds, 'Superannuation', app.Super_Value_How_Much__c);
        }
        //Contents
        if(app.Furniture_Value__c != null){
            setMoney3Asset(assets, ownerIds, 'Household goods', app.Furniture_Value__c);
        }
        //Other assets
        if (otherAssetMap.containsKey(ApplicationService.OTHER_ASSET_TYPE)) {
            for(Application_Other_Asset__c otherAsset : otherAssetMap.get(ApplicationService.OTHER_ASSET_TYPE)){
                setMoney3Asset(assets, ownerIds, 'Other', otherAsset.Value__c);
            }
        }
        return assets;
    }

    private void setMoney3Asset(List<Money3APIRequestDTO.Asset> assets, List<String> ownerIds, String assetType, Decimal amount){
        if(ownerIds == null || assetType == null){
            return;
        }
        Money3APIRequestDTO.Asset asset = new Money3APIRequestDTO.Asset();
        asset.owners = ownerIds;
        asset.amount = amount != null ? amount : 0;
        asset.assetType = assetType;
        asset.isCurrent = true;
        assets.add(asset);
    }

    private List<Money3APIRequestDTO.Liability> getLiabilities(Application__c app, Map<String, List<Application_Other_Asset__c>> otherAssetMap, Money3APIRequestDTO request, List<String> ownerIds){
        List<Money3APIRequestDTO.Liability> liabilities = new List<Money3APIRequestDTO.Liability>();
        Map<String, String> expenseMap = new Map<String, String>();
        List<Money3APIRequestDTO.Expense> expenses = request.expenses;
        if(expenses != null){
            for(Money3APIRequestDTO.Expense exp : expenses){
                expenseMap.put(exp.expenseType, exp.id);
            }
        }
        
        //get application loans
        List<Application_Loan__c> appLoans = ApplicationService.getApplicationLoans(app.Id);
        for(Application_Loan__c loan : appLoans){
            Money3APIRequestDTO.Liability liability = new Money3APIRequestDTO.Liability();
            liability.owners = ownerIds;
            if(Money3Constants.liabilityExpenseMap.containsKey(loan.Type__c) && expenseMap.size() > 0 && expenseMap.containsKey(Money3Constants.liabilityExpenseMap.get(loan.Type__c))){
                liability.expenseId = expenseMap.get(Money3Constants.liabilityExpenseMap.get(loan.Type__c));
            }
            liability.liabilityType = getLiabilityType(loan.Type__c);
            liability.balanceAmount = loan.Amount_Owing__c;
            liability.monthlyPayment = loan.Payment__c;
            liability.creditProvider = loan.Lender__c;
            liability.isCurrent = true;
            liabilities.add(liability);
        }
        //Mortgage
        if (otherAssetMap.containsKey(ApplicationService.PROPERTY_ASSET_TYPE)) {
            for(Application_Other_Asset__c asset : otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE)){
                if('Y'.equalsIgnoreCase(asset.Has_Loan__c)){
                    Money3APIRequestDTO.Liability liability = new Money3APIRequestDTO.Liability();
                    liability.owners = ownerIds;
                    if(expenseMap.size() > 0 && expenseMap.containsKey(Money3Constants.liabilityExpenseMap.get('Housing Loan'))){
                        liability.expenseId = expenseMap.get(Money3Constants.liabilityExpenseMap.get('Housing Loan'));
                    }
                    liability.liabilityType = 'Housing Loan';
                    liability.balanceAmount = asset.Amount_Owing__c;
                    liability.monthlyPayment = asset.Monthly_Payment__c;
                    liability.creditProvider = asset.Lender__c;
                    liability.isCurrent = true;
                    liabilities.add(liability);
                }
            }
        }
        //Motor Vehicle loan
        if (otherAssetMap.containsKey(ApplicationService.VEHICLE_ASSET_TYPE)) {
            for(Application_Other_Asset__c asset : otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE)){
                if('Y'.equalsIgnoreCase(asset.Has_Loan__c)){
                    Money3APIRequestDTO.Liability liability = new Money3APIRequestDTO.Liability();
                    liability.owners = ownerIds;
                    liability.liabilityType = 'Motor Vehicle Loan';
                    liability.balanceAmount = asset.Amount_Owing__c;
                    liability.monthlyPayment = asset.Monthly_Payment__c;
                    liability.creditProvider = asset.Lender__c;
                    liability.isCurrent = true;
                    liabilities.add(liability);
                }
            }
        }
        //Credit cards
        List<Application_Credit_Card__c> creditCards =  ApplicationService.getApplicationCreditCards(app.Id);
        for (Application_Credit_Card__c card : creditCards) {
            Money3APIRequestDTO.Liability liability = new Money3APIRequestDTO.Liability();
            liability.owners = ownerIds;
            if(expenseMap.size() > 0 && expenseMap.containsKey(Money3Constants.liabilityExpenseMap.get('Credit Card'))){
                liability.expenseId = expenseMap.get(Money3Constants.liabilityExpenseMap.get('Credit Card'));
            }
            liability.liabilityType = 'Credit Card';
            liability.balanceAmount = card.Amount_Owing__c;
            liability.limit_m = card.Limit__c;
            liability.monthlyPayment = card.Monthly_Payment__c;
            liability.creditProvider = card.Issuer__c;
            liability.isCurrent = true;
            liability.monthlyRepaymentMinimum = true;
            liabilities.add(liability);
        }
        return liabilities;
    }

    private String getLiabilityType(String loanType){
        String liabilityType;
        if(loanType.equalsIgnoreCase('Debt/Default Arrangements') || loanType.equalsIgnoreCase('Other'))
            liabilityType = 'Other';
        else if(loanType.equalsIgnoreCase('Line of Credit'))
            liabilityType = 'Overdraft';
        else if(loanType.equalsIgnoreCase('Payday Loan'))
            liabilityType = 'Payday Lender';
        else if(loanType.equalsIgnoreCase('Personal Loan'))
            liabilityType = 'Personal Loan';
        else 
            liabilityType = 'Other';
        return liabilityType;
    }

    private List<Money3APIRequestDTO.Income> getIncomes(Application__c app, Money3APIRequestDTO request) {
        List<Money3APIRequestDTO.Income> incomes = new List<Money3APIRequestDTO.Income>();

        //primary applicant income
        List<Money3APIRequestDTO.Applicant> applicants = request.applicants;
        if(applicants != null && applicants[0].employments != null){
            Money3APIRequestDTO.Income income = new Money3APIRequestDTO.Income();
            income.owners = new List<String>{applicants[0].id};
            income.amount = app.Net_Income_1__c;
            income.employmentId = applicants[0].employments[0].id;
            income.frequency = app.Payment_Frequency_1__c;
            income.incomeType = getIncomeType(app.Mode_of_Employment_1__c);
            income.netOrGross = 'Net';
            income.isCurrent = true;
            incomes.add(income);
        }
        
        //co-applicant income
        if(applicants != null && applicants.size() > 1 && applicants[1].employments != null){
            Money3APIRequestDTO.Income income = new Money3APIRequestDTO.Income();
            income.owners = new List<String>{applicants[1].id};
            income.amount = app.Net_Income_2__c;
            income.employmentId = applicants[1].employments[0].id;
            income.frequency = app.Payment_Frequency_2__c;
            income.incomeType = getIncomeType(app.Mode_of_Employment_2__c);
            income.netOrGross = 'Net';
            income.isCurrent = true;
            incomes.add(income);
        }
        return incomes;
    }

    private String getIncomeType(String appIncomeType){
        String incomeType;
        if(appIncomeType.equalsIgnoreCase('Full Time'))
            incomeType = 'Salary';
        else if(appIncomeType.equalsIgnoreCase('Part Time'))
            incomeType = 'Part Time';
        else if(appIncomeType.equalsIgnoreCase('Casual') || appIncomeType.equalsIgnoreCase('Contract') || appIncomeType.equalsIgnoreCase('Financially Supported by Partner'))
            incomeType = 'Other Income';
        else if(appIncomeType.equalsIgnoreCase('Self Employed'))
            incomeType = 'Self Employed';
        else if(appIncomeType.equalsIgnoreCase('Centrelink - Family Tax Benefits/Other'))
            incomeType = 'Centrelink\\Age Benefit';
        else if(appIncomeType.equalsIgnoreCase('Centrelink - Newstart only'))
            incomeType = 'Centrelink\\New Start';
        else 
            incomeType = 'Other Income';
        return incomeType;
    }

    private List<Money3APIRequestDTO.Expense> getExpenses(Application__c app, List<String> ownerIds) {
        List<Money3APIRequestDTO.Expense> expenses = new List<Money3APIRequestDTO.Expense>();
        setMoney3Expense(expenses, ownerIds, 'Home and Utility', NumberUtils.convertStringToDecimal(app.Basic_Living_Expenses_Per_Month__c, scaleDecimal));
        setMoney3Expense(expenses, ownerIds, 'Travel Expenses', NumberUtils.convertStringToDecimal(app.Travel_Transport_Expenses_per_Month__c, scaleDecimal));
        setMoney3Expense(expenses, ownerIds, 'Food and Entertainment', NumberUtils.convertStringToDecimal(app.Mobile_Phone_Internet_Pay_TV_per_Month__c, scaleDecimal));
        setMoney3Expense(expenses, ownerIds, 'Insurance', NumberUtils.convertStringToDecimal(app.Insurance_Expenses_per_Month__c, scaleDecimal));

        Decimal totalHousingValue;
        //primary applicant
        Decimal housingValue1 = NumberUtils.convertDecimalToScale(app.Rent_per_month_1__c, scaleDecimal);
        if(housingValue1 == null){
            housingValue1 = NumberUtils.convertDecimalToScale(app.Board_per_Month_1__c, scaleDecimal);
        }
        totalHousingValue = housingValue1;
        //co-applicant
        if(isAdditionalApplicant(app)){
            Decimal housingValue2 = NumberUtils.convertDecimalToScale(app.Rent_per_month_2__c, scaleDecimal);
            if(housingValue2 == null){
                housingValue2 = NumberUtils.convertDecimalToScale(app.Board_per_Month_2__c, scaleDecimal);
            }
            totalHousingValue = housingValue2 != null ? totalHousingValue + housingValue2 : totalHousingValue;
        }
        setMoney3Expense(expenses, ownerIds, 'Mortgage/Rent', totalHousingValue);
        setMoney3Expense(expenses, ownerIds, 'Child Care', NumberUtils.convertStringToDecimal(app.Childcare_Child_Maintenance_Per_Month__c, scaleDecimal));
        setMoney3Expense(expenses, ownerIds, 'Other Expenses', NumberUtils.convertStringToDecimal(app.Other_Expenses_per_Month__c, scaleDecimal));

        //personal and other loans
        Decimal personalLoan = 0;
        Decimal otherLoan = 0;
        List<Application_Loan__c> loans = ApplicationService.getApplicationLoans(app.Id);
        for (Application_Loan__c loan: loans) {
            Decimal value = Utilities.getMonthlyValue(loan.Frequency__c, loan.Payment__c, scaleDecimal);
            if ('Debt/Default Arrangements'.equalsIgnoreCase(loan.Type__c) || 'Line of Credit'.equalsIgnoreCase(loan.Type__c) ||
               		'Other'.equalsIgnoreCase(loan.Type__c)){
                otherLoan = otherLoan + value;
            }else{
                personalLoan = personalLoan + value;        
            }           
        }
        setMoney3Expense(expenses, ownerIds, 'Personal Loan', NumberUtils.convertDecimalToScale(personalLoan, scaleDecimal));
        setMoney3Expense(expenses, ownerIds, 'Other Loans', NumberUtils.convertDecimalToScale(otherLoan, scaleDecimal));

        //credit cards
        List<Application_Credit_Card__c> creditCardList =  ApplicationService.getApplicationCreditCards(app.Id);
        Decimal cardAmount = 0;
        for(Application_Credit_Card__c card : creditCardList){
            cardAmount += NumberUtils.convertDecimalToScale(card.Monthly_Payment__c, scaleDecimal);
        }
        setMoney3Expense(expenses, ownerIds, 'Credit Cards', cardAmount);
        return expenses;
    }

    private void setMoney3Expense(List<Money3APIRequestDTO.Expense> expenses, List<String> ownerIds, String expenseType, Decimal amount){
        if(ownerIds == null || amount == null || amount == 0){
            return;
        }
        Money3APIRequestDTO.Expense expense = new Money3APIRequestDTO.Expense();
        expense.id = Utilities.getGUID();
        expense.owners = ownerIds;
        expense.amount = amount;
        expense.expenseType = expenseType;
        expense.frequency = 'Monthly';
        expense.isCurrent = true;
        expenses.add(expense);
    }

    private Money3APIRequestDTO.Security getSecurity(Custom_Opportunity__c opp){
        Money3APIRequestDTO.Security security;
        if(opp.Application_AssetDetail__c != null){
            security = new Money3APIRequestDTO.Security();
            security.typeOfSecurity = opp.Application_AssetDetail__r.Type__c;
            security.registrationNumber = opp.Application_AssetDetail__r.Rego__c;
            security.make = opp.Application_AssetDetail__r.Make__c;
            security.model = opp.Application_AssetDetail__r.Model__c;
            if(String.isNotBlank(opp.Application_AssetDetail__r.Variant__c)){
                Glass_Variant__c glassVariant = Money3APIManager.getCarDetails(opp.Application_AssetDetail__r.Variant__c);
                if(glassVariant != null){
                    security.transmission = glassVariant.Transmission__c;
                    security.glassValue = glassVariant.New_Price__c;
                    security.bodyType = glassVariant.Style__c;
                    security.engineSize = NumberUtils.convertStringToDecimal(glassVariant.Size__c, scaleDecimal);
                    security.engineCylinders = NumberUtils.convertStringToDecimal(glassVariant.Cylinders__c, scaleDecimal);
                }
            }
            security.year = opp.Application_AssetDetail__r.Year__c != null ? opp.Application_AssetDetail__r.Year__c.intValue() : 0;
            security.color = StringUtils.validateNull(opp.Application_AssetDetail__r.Colour__c);
            security.currentKms = opp.Application_AssetDetail__r.Actual_KM__c;
            security.purchaseAmount = opp.Application_AssetDetail__r.Price__c;
            security.depositTradeAmount = opp.Application_AssetDetail__r.Deposit__c;
            security.vinNumber = opp.Application_AssetDetail__r.VIN__c;
            security.engineNumber = opp.Application_AssetDetail__r.Engine_No__c;
            security.isNewVehicle = opp.Application_AssetDetail__r.Condition__c == 'new';
            security.ppsrNumber = opp.Application_AssetDetail__r.PPSR_Proxy_Id__c;
            security.ppsrRegnumber = opp.Application_AssetDetail__r.Search_Certificate_Number__c;
            security.chasisNumber = opp.Application_AssetDetail__r.VIN__c;
        }
        return security;
    }

    private List<Money3APIRequestDTO.Insurance> getInsurances(Application_Quoting__c appQuoting){
        List<Money3APIRequestDTO.Insurance> insurances = new List<Money3APIRequestDTO.Insurance>();
        setMoney3Insurance(insurances, appQuoting.Insurance_GAP_Retail_Price__c, 'GAP/Equity Insurance');
        setMoney3Insurance(insurances, appQuoting.Insurance_Warranty_Retail_Price__c, 'Extended Warranty');
        setMoney3Insurance(insurances, appQuoting.Insurance_LTI_Retail_Price__c, 'Loan Termination Insurance');
        setMoney3Insurance(insurances, appQuoting.Insurance_TAI_Retail_Price__c, 'Total Assist');
        setMoney3Insurance(insurances, appQuoting.Insurance_MV_Retail_Price__c, 'Complete Car Care Cover');
        setMoney3Insurance(insurances, appQuoting.Insurance_AIC_Retail_Price__c, 'Consumer Credit Insurance');
        return insurances;
    }

    private void setMoney3Insurance(List<Money3APIRequestDTO.Insurance> insurances, Decimal amount, String insuranceType){
        if(amount == null || amount == 0){
            return;
        }
        Money3APIRequestDTO.Insurance insurance = new Money3APIRequestDTO.Insurance();
        insurance.insuranceType = insuranceType;
        insurance.amount = amount;
        insurances.add(insurance);
    }

    private List<Money3APIRequestDTO.Note> getNotes(Application__c app){
        List<Money3APIRequestDTO.Note> notes = new List<Money3APIRequestDTO.Note>();
        List<Application_Extra_Data__c> notesData = ApplicationExtraDataHelper.getApplicationExtraDataList(app.Id, Money3Constants.NOTES_TYPE);
        if(notesData != null){
            for(Application_Extra_Data__c data : notesData){
              if (String.isNotBlank(data.Data__c)) {
                Money3APIRequestDTO.Note note = new Money3APIRequestDTO.Note();
                note.noteSubject = data.Type_of_Data__c;
                note.noteBody = data.Data__c;
                notes.add(note);
              }
            }
        }
        return notes;
    }

    @TestVisible
    public Money3APIManager uploadDocumentsToMoney3(Money3APIManager money3Manager, Id oppId, Integer loanId, Boolean files){
        // List<Cloud_Documents__c> documents = [SELECT Document_Type__c, File_Name__c from Cloud_Documents__c where 
        //                                                        Custom_Opportunity__c=:oppId and (Document_Type__c='Driver\'s License' or Document_Type__c='Payslip/s' or 
        //                                                        Document_Type__c='Applicant 1 Second Job Payslip')];
        
        List<Cloud_Documents__c> documents = [
            SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
            Custom_Opportunity__c=:oppId and Send_To_Lender__c = true];
        // applicant 2 docs
        List<String> dcs = new List<String>{
          'Applicant 2 - Drivers License - Front',
          'Applicant 2 - Drivers License - Back',
          'Applicant 2 - Payslip 1',
          'Applicant 2 - Payslip 2',
          'Applicant 2 Second Job Payslip',
          'Applicant 2 Payslips',
          'Applicant 2 Drivers License',
          'Applicant 2 Payslip 1'
        };
        if(Money3APIManager.isTwoApplicants(oppId)){
            List<Cloud_Documents__c> documentsApp2 = [SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
                                                      Custom_Opportunity__c=:oppId and Document_Type__c in :dcs and Send_To_Lender__c = true];
            if(documentsApp2 != null && documentsApp2.size() > 0){
                documents.addAll(documentsApp2);
            }
        }
        
        if(submitRequest(money3Manager, oppId, loanId, files)){
            if(files && !documents.isEmpty()){
                documents = files(oppId, loanId, documents);   
            }
            
            List<LenderAPIResponse__c> docs = new List<LenderAPIResponse__c>();
            for (Cloud_Documents__c d : documents) {
                Blob file;
                FinanceOneFile.WriteFileResult result;
                FinanceOneFile.WriteFileResult result2;
                
                String form64 = '';
                String form;
                form64 += FinanceOneFile.WriteBoundary();
                form64 += FinanceOneFile.WriteBodyParameter('loanId', String.valueOf(loanId));
                form64 += FinanceOneFile.WriteBoundary();
                form64 += FinanceOneFile.WriteBodyParameter('documentType', d.Document_Type__c);
                form64 += FinanceOneFile.WriteBoundary();
                form = form64;
                
                if (!Test.isRunningTest()) {
                    file = CloudDocsHelper.fileDownLoad(d);
                }else{
                    file = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgMDAwMDAwMDAwP/2wBDAQEBAQEBAQIBAQICAgECAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwP/wAARCAAKAAoDAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAP/xAAmEAAAAwMNAAAAAAAAAAAAAAAAFhfI6PAYKCk2R2ZnaoaJmKn4/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AJ1euwWNClEi8WE6TqSxg6S0dsdR2joB5Hcmdd6ywCJo7EzLu2WARGQDAf/Z');
                }
                try{
                    result = FinanceOneFile.WriteFile('file', d.File_Name__c, FinanceOneUtils.getContentType(d.File_Name__c), file);
                    result2 = FinanceOneFile.WriteFile2('file', d.File_Name__c, FinanceOneUtils.getContentType(d.File_Name__c), file);
                    form64 += result.Content;
                    form += result2.Content;
                    form64 += FinanceOneFile.WriteBoundary(result.EndingType);
                    form += FinanceOneFile.WriteBoundary(result2.EndingType);
                    blob formBlob = EncodingUtil.base64Decode(form);
                    HttpRequest httpRequest = new HttpRequest();
                    httpRequest.setBodyAsBlob(formBlob);
                    
                    String body = httpRequest.getBody();
                    
                    formBlob = EncodingUtil.base64Decode(form64);
                    httpRequest.setBodyAsBlob(formBlob);
                    string contentLength = string.valueOf(formBlob.size());
                    string contentType = FinanceOneFile.GetContentType();
                    
                    String authorizationHeader = 'Bearer ' + consumerKey;
                    
                    httpRequest.setEndpoint(documentEndpoint);
                    httpRequest.setHeader('Connection', 'keep-alive');
                    httpRequest.setHeader('Content-Length', contentLength);
                    httpRequest.setHeader('Content-Type', contentType);
                    httpRequest.setMethod('POST');
                    httpRequest.setTimeout(120000);
                    httpRequest.setHeader(Money3Constants.AUTHORIZATION, authorizationHeader);
                    httpRequest.setHeader(Money3Constants.ACCEPT, ConnectionRESTWs.CONTENT_TYPE_JSON);
                    
                    Http http = new Http();
                    HttpResponse response;
                    
                    response = http.send(httpRequest);
                    LenderAPIResponse__c l = new LenderAPIResponse__c();
                    l.Cloud_Document__c = d.Id;
                    l.Opportunity__c = oppId;
                    System.debug(response.getStatusCode());                    
                    if(response.getStatusCode() == 201){
                        Money3APIResponseDTO.DocumentResponse dto = (Money3APIResponseDTO.DocumentResponse)JSON.deserialize(response.getBody(), Money3APIResponseDTO.DocumentResponse.class);                                                
                        l.DocumentUUID__c = dto.id;
                        l.Request__c = body;
                        l.Response__c = response.getBody();
                        l.Status__c = response.getStatusCode();
                        l.Message__c = dto.note;
                        l.Name = 'Money3 ['+loanId+'-DOC]';
                        docs.add(l);
                        money3Manager.addConfirmMessage(d.File_Name__c+' has been sent');
                    } else {
                        System.debug(response.getBody());
                        Money3APIResponseDTO dto = (Money3APIResponseDTO)JSON.deserialize(response.getBody(), Money3APIResponseDTO.class);
                        l.Request__c = body;
                        l.Response__c = response.getBody();
                        l.Status__c = response.getStatusCode();
                        Money3APIResponseDTO.Error m = dto.errors.get(0);
                        if(m.field != null){
                            l.Message__c = '['+m.field+']: '+m.message;
                        }else{
                            l.Message__c = m.message;    
                        }
                        l.Name = 'Money3 [FAIL-'+loanId+'-DOC]';
                        docs.add(l);
                        for (Money3APIResponseDTO.Error e : dto.errors) {
                          String errMsg = e.field != null
                            ? '['+d.File_Name__c+'] '+e.field+': '+e.message 
                            : '['+d.File_Name__c+']: '+e.message;
                          money3Manager.addErrorMessage(errMsg);
                        }
                    }
                }catch (GenericException ex){
                  money3Manager.addWarningMessage(ex.getMessage());
                }
            }
            money3Manager.responseDto.docs = docs;
        }
        return money3Manager;
    }
    
    public List<Cloud_Documents__c> files(Id oppId, Integer loanId, List<Cloud_Documents__c> documents){
        List<Cloud_Documents__c> docs = new List<Cloud_Documents__c>();
        List<LenderAPIResponse__c> lenderList = [
            SELECT Id, Application_ID__c from LenderAPIResponse__c where 
            Application_ID__c=:String.valueOf(loanId)];
        
        LenderAPIResponse__c lender;
        
        List<LenderAPIResponse__c> files = new List<LenderAPIResponse__c>();
        
        if(!lenderList.isEmpty()){
            lender =  lenderList.get(0);
        }
        
        List<LenderAPIResponse__c> filesSended;
        
        if(lender != null){
            filesSended = [
                SELECT Cloud_Document__c from LenderAPIResponse__c where 
                LenderAPIResponse__c=:lender.Id and	Status__c=201];
        }
        
        Set<Id> docIds = new Set<Id>();
         
        if(filesSended != null){
            for (LenderAPIResponse__c l : filesSended) {
                docIds.add(l.Cloud_Document__c);
            }
        }
        
        for (Cloud_Documents__c d : documents) {
            if(!docIds.contains(d.Id)){
                docs.add(d);  
            }			
        }
                
        return docs;
    }
    
    public Boolean submitRequest(Money3APIManager mgr, Id oppId, Integer loanId, Boolean files){
        Boolean sr = true;
        List<Cloud_Documents__c> documents = [
            SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
            Custom_Opportunity__c=:oppId and Send_To_Lender__c = true and (Document_Type__c=null or Document_Type__c='')];
        if(Money3APIManager.isTwoApplicants(oppId)){
            List<Cloud_Documents__c> documentsApp2 = [SELECT Document_Type__c, File_Name__c, Bucket_Name__c, Folder_Id__c from Cloud_Documents__c where 
                                                      Custom_Opportunity__c=:oppId and Send_To_Lender__c = true and (Document_Type__c=null or Document_Type__c='')];
            if(documentsApp2 != null && documentsApp2.size() > 0){
                documents.addAll(documentsApp2);
            }
        }
        
        if(files && !documents.isEmpty()){
            documents = files(oppId, loanId, documents);
        }
        
        for (Cloud_Documents__c d : documents) {
          mgr.addErrorMessage('Document type of the file '+d.File_Name__c+' is not selected');
          sr = false;
        }
        return sr;
    }
}