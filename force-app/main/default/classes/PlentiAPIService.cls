/**
*@Description : Used for PlentiApi Integration
 */
public class PlentiAPIService {

    String endPointApplication;
    String partnerId;
    String plPartnerId;

    public PlentiAPIService() {
        loadSettings();
    }

    private void loadSettings() {
      endPointApplication = PlentiAPIManager.getParameterService(PlentiAPIManager.PLENTI_SERVICE_ENDPOINT);
      partnerId = PlentiAPIManager.getParameterService(PlentiAPIManager.PLENTI_SERVICE_PARTNER_ID);
      plPartnerId = PlentiAPIManager.getParameterService(PlentiAPIManager.PLENTI_SERVICE_PARTNER_ID_PL);
    }

    public void requestApplicationTest(Id oppId, String user) {        
      String body = getPlentiApplication(oppId, user).serialize(true);
      body = body.replaceAll('limit_m', 'limit');        
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, body));
    }

    public PlentiAPIManager requestApplication(Id oppId, String user) {
      return requestApplication(oppId, user, false);
    }
    public PlentiAPIManager requestApplication(Id oppId, String user, Boolean isPLoan) {
      PlentiAPIManager apiManager = new PlentiAPIManager();
      apiManager.isPLoan = isPLoan;
      ConnectionRESTWs conn;
      apiManager.oppId = oppId;
      apiManager.reqBody = getPlentiApplication(oppId, user).serialize(true);
      apiManager.reqBody = apiManager.reqBody.replaceAll('limit_m', 'limit');
      
      String service = isPLoan? PlentiAPIManager.ENDPOINT_PL : PlentiAPIManager.ENDPOINT_AUTO;
      String endpoint = endPointApplication + service;

      conn = new ConnectionRESTWs(endpoint, ConnectionRESTWs.POST, ConnectionRESTWs.CONTENT_TYPE_JSON);
      
      String pid = isPLoan? plPartnerId : partnerId;

      Map<String, String> requestHeader = new Map<String, String>();
      // requestHeader.put(PlentiConstants.AUTHORIZATION, 'authorizationHeader');
      requestHeader.put(PlentiConstants.PARTNER_ID, pid);
      requestHeader.put(PlentiConstants.ACCEPT, ConnectionRESTWs.CONTENT_TYPE_JSON);
      HttpResponse resp;
      try{
        resp = conn.connectionServiceHttpResponse(requestHeader, apiManager.reqBody);
      } catch (GenericException ex) {
        apiManager.addErrorMessage(ex.getMessage());
      }
      try {
        validateResponse(resp, apiManager);  
      } catch (GenericException ex) {
        apiManager.isError = true;
        apiManager.message = ex.getMessage();
        throw new GenericException ('[Plenti Application] ' + apiManager.message, ex);
      }
      return apiManager;
    }

    private void validateResponse(HttpResponse resp, PlentiAPIManager apiManager){
      apiManager.isError = false;
      apiManager.message = '@!Ok';
      if (resp != null) {
        apiManager.responseStatus = resp.getStatusCode();
        apiManager.responseMessage = resp.getBody();
        apiManager.parseCreateApplicationResponse(apiManager.responseMessage);
        apiManager.errorResponseHandler();
        saveLenderAPIResponse(apiManager);
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Response: ' + resp.getBody()));
        if (apiManager.responseStatus != PlentiConstants.STATUS_OK && apiManager.responseStatus != PlentiConstants.STATUS_201){
          apiManager.isError = true;
          apiManager.message = '[' + apiManager.responseStatus + ']';
          throw new GenericException ('process failed.');
        }
        System.debug('@@Plenti Application*. -[' + apiManager.responseMessage + ']');
      } else {
        apiManager.isError = true;
        apiManager.message = '@Please, check service response';
      }
      System.debug('@validateResponse: -[' + apiManager.message + ']');
    }

    public void saveLenderAPIResponse(PlentiAPIManager apiManager) {
      if (apiManager != null) {
        LenderAPIResponse__c apiRes = new LenderAPIResponse__c();
        apiRes.Name = 'Plenti';
        apiRes.Opportunity__c = apiManager.oppId;
        apiRes.Provider__c = 'Plenti';
        apiRes.Status__c = apiManager.responseStatus;
        apiRes.Service__c = apiManager.isPLoan? PlentiAPIManager.ENDPOINT_PL : PlentiAPIManager.ENDPOINT_AUTO;
        apiRes.Request__c = apiManager.reqBody;
        apiRes.Response__c = apiManager.responseMessage;
        if (apiManager.apiResponse != null) {
          if (apiManager.apiResponse.hasError()) {
            apiRes.Name += ' [FAIL]';
          } else {
            apiRes.Name += ' [' + apiManager.apiResponse.Id + ']';
            apiRes.Application_ID__c = apiManager.apiResponse.Id;
          }
        }
        insert apiRes;
        apiManager.lenderAPIResp = apiRes;
      }
    }

    public PlentiAPIRequestWrapper getPlentiApplication(Id oppId, String user) {
        if (StringUtils.isNullOrEmpty(user) && !SOQLSingletonQueries.recs().isBrokerPartnerUser){
            throw new GenericException ('Missing Plenti user. Please select one.');
        }
        PlentiAPIRequestWrapper request = new PlentiAPIRequestWrapper();
        
        PlentiAPIRequestWrapper.Application application = new PlentiAPIRequestWrapper.Application();
        //get custom opportunity
        Custom_Opportunity__c opp = PlentiAPIManager.getCustomOpportunityForPlentiApplication(oppId);
        //get application quoting
        Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(oppId, opp.Application__c);
        if (quoting == null){
          throw new GenericException ('Please make sure calculate before send to Plenti API.');
        }
        Boolean isPLoan = 'RateSetter PL'.equals(quoting.Name);
        request.DefinitionName = !isPLoan? 'wholesaleApplication' : 'personalLoanBrokerApplication';
        request.Type = 2;
        request.Action = 'RateEstimateCompleted';
        
        Application__c app = opp.Application__r;
        //get applicant details
        application.applicant = getApplicant(app);
        //get contact details
        application.contact = getContact(app);
        //get finances details
        application.finances = getFinances(app);
        //get address
        application.address = getAddress(app);
        //get expenses
        application.expenses = getExpenses(app, isPLoan);
        //get applicant assets
        Map<String, List<Application_Other_Asset__c>> otherAssetMap = ApplicationService.getApplicationOtherAssetsMap(app.Id);
        //get housing
        application.housing = getHousing(app, otherAssetMap);
        //get income
        application.income = getIncome(opp, app, isPLoan);
        application.finances.income = application.income.netIncome;
        //get employment
        application.employment = getEmployment(app);
        //get broker
        String userId = String.isNotBlank(user)? user : opp.OwnerId;
        application.broker = getBroker(userId, quoting, isPLoan);
        //get debts
        application.debts = getDebts(app, otherAssetMap);
        //get loan
        application.loan = getLoan(quoting, opp, isPLoan);
        //terms and conditions
        PlentiAPIRequestWrapper.TermsAndConditions termsAndCond = new PlentiAPIRequestWrapper.TermsAndConditions();
        termsAndCond.privacyAgreement = true;
        termsAndCond.creditGuideConfirmation = true;
        termsAndCond.creditReportingAgreement = true;
        if(!isPLoan && quoting.Residual_Value__c != null && quoting.Residual_Value__c > 0){
            termsAndCond.balloonPaymentConsentConfirmation = true;
        }

        application.termsAndConditions = termsAndCond;
        //borrower meta info
        PlentiAPIRequestWrapper.BorrowerMetaInfo metaInfo = new PlentiAPIRequestWrapper.BorrowerMetaInfo();
        metaInfo.sourceFromApi = true;
        application.borrowerMetaInfo = metaInfo;
        //balloon payment
        if(!isPLoan && quoting.Residual_Value__c != null && quoting.Residual_Value__c > 0){
            application.balloonPayment = getBalloonPayment(quoting);
        }
        request.application = application;
        return request;
    }

    private PlentiAPIRequestWrapper.Applicant getApplicant(Application__c app) {
        PlentiAPIRequestWrapper.Applicant applicant = new PlentiAPIRequestWrapper.Applicant();
        applicant.firstName = app.First_Name__c;
        applicant.middleName = StringUtils.validateNull(app.Middle_Name__c);
        applicant.lastName = app.Last_Name__c;
        //DOB
        PlentiAPIRequestWrapper.DateOfBirth dob = new PlentiAPIRequestWrapper.DateOfBirth();
        dob.isoString = DateUtils.convertToString(DateUtils.convertToDate(app.Date_of_Birth_1__c), PlentiConstants.ISO_FORMAT);
        applicant.dateOfBirth = dob;
        applicant.maritalStatus = String.isNotBlank(app.Marital_Status_1__c) ? app.Marital_Status_1__c : 'Other';
        applicant.residency = getResidency(app.Current_Residential_Status_1__c);
        return applicant;
    }

    public String getResidency(String residency){
        String status;
        if(String.isNotBlank(residency) && PlentiConstants.CITIZEN_STATUS.contains(residency)){
            status = 'auNzCitizen';
        } else if (String.isNotBlank(residency) && PlentiConstants.RESIDENT_STATUS.contains(residency)){
            status = 'auPermanentResident';
        } else {
            status = 'onVisa';
        }
        return status;
    }

    private PlentiAPIRequestWrapper.Contact getContact(Application__c app) {
        PlentiAPIRequestWrapper.Contact contact = new PlentiAPIRequestWrapper.Contact();
        contact.email = StringUtils.validateNull(app.Email_Address__c);
        contact.mobileNumber = StringUtils.removeAllCharacters(app.Mobile_Number__c);
        return contact;
    }

    private PlentiAPIRequestWrapper.Finances getFinances(Application__c app) {
        PlentiAPIRequestWrapper.Finances finances = new PlentiAPIRequestWrapper.Finances();
        finances.employment = getEmploymentStatus(app.Mode_of_Employment_1__c);
        finances.income = app.Net_Income_1__c != null ? NumberUtils.intToString(app.Net_Income_1__c) : '0';
        finances.numberOfDependants = app.No_of_Dependants_1__c != null ? String.valueOf(app.No_of_Dependants_1__c) : '0';
        return finances;
    }

    public String getEmploymentStatus(String modeEmployment){
      String status;
      if('Full Time'.equalsIgnoreCase(modeEmployment) || 'Full-Time'.equalsIgnoreCase(modeEmployment)){
          status = 'FullTime';
      } else if('Part Time'.equalsIgnoreCase(modeEmployment) || 'Part-Time'.equalsIgnoreCase(modeEmployment)){
          status = 'PartTime';
      } else if('Self Employed'.equalsIgnoreCase(modeEmployment)){
          status = 'SelfEmployed';
      } else if('Casual'.equalsIgnoreCase(modeEmployment)){
          status = 'Casual';
      } else if('Contract'.equalsIgnoreCase(modeEmployment)){
          status = 'Contract';
      } else {
          status = 'FullTime';
      }
      return status;
    }

    private PlentiAPIRequestWrapper.Address getAddress(Application__c app) {
        PlentiAPIRequestWrapper.Address address = new PlentiAPIRequestWrapper.Address();
        //residential address
        PlentiAPIRequestWrapper.AddressWrapper residentialAddress = new PlentiAPIRequestWrapper.AddressWrapper();
        residentialAddress.unitNumber = app.Unit_Number__c;
        residentialAddress.streetNumber = app.Street_Number__c;
        residentialAddress.street = app.Street_Address__c;
        residentialAddress.suburb = app.Suburb__c;
        residentialAddress.postCode = app.Postcode__c;
        residentialAddress.state = app.State__c;
        Date startDate = DateUtils.convertToDate(app.Date_Moved_in_1__c);
        if(startDate != null){
          residentialAddress.yearsAtAddress = getYearsAtAddress(startDate);
        }
        address.residentialAddress = residentialAddress;
        //previous address
        if(app.Previous_Street_Address_1__c != null || app.Previous_Suburb_1__c != null || app.Previous_State_1__c != null){
            PlentiAPIRequestWrapper.AddressWrapper previousAddress = new PlentiAPIRequestWrapper.AddressWrapper();
            previousAddress.unitNumber = app.Previous_Unit_Number_1__c;
            previousAddress.streetNumber = app.Previous_Street_Number_1__c;
            previousAddress.street = app.Previous_Street_Address_1__c;
            previousAddress.suburb = app.Previous_Suburb_1__c;
            previousAddress.postCode = app.Previous_Postcode_1__c;
            previousAddress.state = app.Previous_State_1__c;
            Date prevStartDate = DateUtils.convertToDate(app.Date_From_1__c);
            if(prevStartDate != null){
              previousAddress.yearsAtAddress = getYearsAtAddress(prevStartDate);
            }
            address.previousAddress = previousAddress;
        }
        return address;
    }

    private PlentiAPIRequestWrapper.Expenses getExpenses(Application__c app, Boolean isPLoan) {
        PlentiAPIRequestWrapper.Expenses expenses = new PlentiAPIRequestWrapper.Expenses();
        if (!isPLoan) {
          //expenses.netLivingExpenses = StringUtils.validateNull(app.Basic_Living_Expenses_Per_Month__c);
          expenses.netLivingExpenses = StringUtils.convertToInt(app.Basic_Living_Expenses_Per_Month__c);
          expenses.netLivingExpensesFrequency = 'Monthly';
          expenses.forseeRepaymentAbilityChange = false;
        }
        //food and groceries
        PlentiAPIRequestWrapper.ExpenseWrapper foodAndGroceries = new PlentiAPIRequestWrapper.ExpenseWrapper();
        //foodAndGroceries.amount = StringUtils.validateNull(app.Basic_Living_Expenses_Per_Month__c);
        foodAndGroceries.amount = StringUtils.convertToInt(app.Basic_Living_Expenses_Per_Month__c);
        foodAndGroceries.frequency = 'Monthly';
        expenses.foodAndGroceries = foodAndGroceries;
        //utilities
        if(app.Insurance_Expenses_per_Month__c != null){
            PlentiAPIRequestWrapper.ExpenseWrapper utilities = new PlentiAPIRequestWrapper.ExpenseWrapper();
            //utilities.amount = StringUtils.validateNull(app.Insurance_Expenses_per_Month__c);
            utilities.amount = StringUtils.convertToInt(app.Insurance_Expenses_per_Month__c); 
            utilities.frequency = 'Monthly';
            expenses.utilities = utilities;
        }
        //phone and internet
        if(app.Mobile_Phone_Internet_Pay_TV_per_Month__c != null){
            PlentiAPIRequestWrapper.ExpenseWrapper phoneAndInternet = new PlentiAPIRequestWrapper.ExpenseWrapper();
            //phoneAndInternet.amount = StringUtils.validateNull(app.Mobile_Phone_Internet_Pay_TV_per_Month__c);
            phoneAndInternet.amount = StringUtils.convertToInt(app.Mobile_Phone_Internet_Pay_TV_per_Month__c); 
            phoneAndInternet.frequency = 'Monthly';
            expenses.phoneAndInternet = phoneAndInternet;
        }
        //transport
        if(app.Travel_Transport_Expenses_per_Month__c != null){
            PlentiAPIRequestWrapper.ExpenseWrapper transport = new PlentiAPIRequestWrapper.ExpenseWrapper();
            //transport.amount = StringUtils.validateNull(app.Travel_Transport_Expenses_per_Month__c);
            transport.amount = StringUtils.convertToInt(app.Travel_Transport_Expenses_per_Month__c); 
            transport.frequency = 'Monthly';
            expenses.transport = transport;
        }
        //other
        if(app.Other_Expenses_per_Month__c != null){
            PlentiAPIRequestWrapper.ExpenseWrapper others = new PlentiAPIRequestWrapper.ExpenseWrapper();
            //others.amount = StringUtils.validateNull(app.Other_Expenses_per_Month__c);
            others.amount = StringUtils.convertToInt(app.Other_Expenses_per_Month__c); 
            others.frequency = 'Monthly';
            expenses.others = others;
        }
        return expenses;
    }

    private PlentiAPIRequestWrapper.Housing getHousing(Application__c app, Map<String, List<Application_Other_Asset__c>> otherAssetMap) {
        PlentiAPIRequestWrapper.Housing housing = new PlentiAPIRequestWrapper.Housing();
        housing.ownershipStatus = getResidentialStatus(app.Current_Residence_Status_1__c);

        if(otherAssetMap.containsKey(ApplicationService.PROPERTY_ASSET_TYPE)){
            //get the first asset and send to plenti
            Application_Other_Asset__c property = otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE)[0];
            housing.propertyValue = NumberUtils.intToString(property.Value__c);
            housing.monthlyMortgage = NumberUtils.intToString(property.Monthly_Payment__c);
            housing.mortgageBalance = NumberUtils.intToString(property.Amount_Owing__c);
        }

        if(housing.ownershipStatus == 'TenantWithMortgage' || housing.ownershipStatus == 'TenantWithoutMortgage'){
            housing.monthlyRent = NumberUtils.intToString(app.Rent_per_month_1__c);
        }

        return housing;
    }

    public String getResidentialStatus(String residentialStatus){
        String status;
        if(String.isNotBlank(residentialStatus)){
            if(residentialStatus.equalsIgnoreCase('Boarding'))
                status = 'Boarder';
            else if(residentialStatus.equalsIgnoreCase('Own Outright'))
                status = 'OwnAHomeWithoutMortgage';
            else if(residentialStatus.equalsIgnoreCase('Renting(Private)') || residentialStatus.equalsIgnoreCase('Renting(Agent)'))
                status = 'TenantWithoutMortgage';
            else if(residentialStatus.equalsIgnoreCase('Mortgage'))
                status = 'OwnAHomeWithMortgage';
            else if(residentialStatus.equalsIgnoreCase('Parents/Relative'))
                status = 'LivingWithParents';
            else 
                status = 'TenantWithMortgage';
        }
        return status;
    }

    private PlentiAPIRequestWrapper.Income getIncome(Custom_Opportunity__c opp, Application__c app, Boolean isPLoan) {
        PlentiAPIRequestWrapper.Income income = new PlentiAPIRequestWrapper.Income();
        if (!isPLoan) {
          income.hasYTDDetail = false;
        }
        income.employmentStartDate = DateUtils.convertToString(DateUtils.convertToDate(app.Date_Started_1__c), PlentiConstants.ISO_FORMAT);
        income.netIncome = null;
        Decimal tmpinc = 0.00;
        if (opp.ApplicationServicing__c != null && opp.ApplicationServicing__r.Income_1__c > 0) {
          tmpinc = opp.ApplicationServicing__r.Income_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(opp.ApplicationServicing__r.IncomePayFrecuency_1__c);
        } else {
          tmpinc = app.Net_Income_1__c * OppApplicationServCalculatorUtils.getFrecuencyFactor(app.Payment_Frequency_1__c);
        }
        income.netIncome = NumberUtils.intToString(tmpinc);
        income.netIncomeFrequency = 'Monthly';
        income.spouseNetIncome = app.Partner_Income__c != null ? NumberUtils.intToString(app.Partner_Income__c) : '0';
        income.spouseNetIncomeFrequency = app.Partner_Income__c != null ? 'Monthly' : 'Annually';
        income.hasOtherIncome = false;
        // if(String.isNotBlank(app.Do_you_receive_other_income_1__c)){
        //     if(app.Do_you_receive_other_income_1__c == 'Yes'){
        //         income.hasOtherIncome = true;
        //     }
        //     else {
        //         income.hasOtherIncome = false;
        //     }
        // }
        //other income
        List<PlentiAPIRequestWrapper.OtherIncome> otherIncomes = new List<PlentiAPIRequestWrapper.OtherIncome>();
        Map <String, List <Application_Income__c>> otherIncomeMap = ApplicationService.getApplicationIncomeMap(app.Id);
        if(!otherIncomeMap.isEmpty()) {
          List<Application_Income__c> incomes = null;
          if (otherIncomeMap.containsKey('1')) {
            incomes = otherIncomeMap.get('1');
            income.hasOtherIncome = true;
          }
          for(Application_Income__c inc : incomes){
            PlentiAPIRequestWrapper.OtherIncome other = new PlentiAPIRequestWrapper.OtherIncome();
            other.type = getIncomeType(inc.Type__c);
            other.frequency = getIncomeFrequency(inc.Frequency__c);
            other.amount = NumberUtils.intToString(inc.Income__c);
            otherIncomes.add(other);
          }
        }
        income.other = otherIncomes;
        return income;
    }

    private List<PlentiAPIRequestWrapper.Employment> getEmployment(Application__c app) {
        List<PlentiAPIRequestWrapper.Employment> employments = new List<PlentiAPIRequestWrapper.Employment>();
        //current employment
        PlentiAPIRequestWrapper.Employment currentEmployment = new PlentiAPIRequestWrapper.Employment();
        currentEmployment.type = getEmploymentStatus(app.Mode_of_Employment_1__c);
        currentEmployment.employer = StringUtils.validateNull(app.Current_Employer_Name_1__c);
        currentEmployment.industry = 'Other';
        currentEmployment.occupation = 'Other';
        Date startDate = DateUtils.convertToDate(app.Date_Started_1__c);
        if(startDate != null){
            currentEmployment.years = String.valueOf(DateUtils.getHowManyYears(startDate, System.today()));
            currentEmployment.months = String.valueOf(DateUtils.getHowManyMonths(startDate, System.today()));
        }
        currentEmployment.isCurrent = true;
        employments.add(currentEmployment);
        //previous employment
        if(String.isNotBlank(app.Previous_Mode_of_Employment_1__c)){
            PlentiAPIRequestWrapper.Employment previousEmployment = new PlentiAPIRequestWrapper.Employment();
            previousEmployment.type = getEmploymentStatus(app.Previous_Mode_of_Employment_1__c);
            previousEmployment.employer = StringUtils.validateNull(app.Previous_Employer_Name_1__c);
            previousEmployment.industry = 'Other';
            previousEmployment.occupation = 'Other';
            Date previousStartDate = DateUtils.convertToDate(app.Start_Date_1__c);
            Date previousEndDate = DateUtils.convertToDate(app.Finish_Date_1__c);
            if(previousStartDate != null && previousEndDate != null){
                previousEmployment.years = String.valueOf(DateUtils.getHowManyYears(previousStartDate, previousEndDate));
                previousEmployment.months = String.valueOf(DateUtils.getHowManyMonths(previousStartDate, previousEndDate));
            }
            previousEmployment.isCurrent = false;
            employments.add(previousEmployment);
        }
        return employments;
    }

    private PlentiAPIRequestWrapper.Broker getBroker(String userName, Application_Quoting__c quoting, Boolean isPLoan) {
        PlentiAPIRequestWrapper.Broker broker = new PlentiAPIRequestWrapper.Broker();
        User bu = APIServiceManager.getUserById(userName);
        if (bu != null) {
          broker.brokerEmail = bu.Email;
          if (!isPLoan) {
            broker.brokerMobile = StringUtils.removeSpaces(bu.MobilePhone);
            broker.brokerMobile = broker.brokerMobile.removeStart('+61');
          }
        } else {
          throw new GenericException('Borker\'s user not found');
        }
        broker.brokerageAmount = quoting.DOF__c != null ? NumberUtils.intToString(quoting.DOF__c) : '0';
        return broker;
    }

    private List<PlentiAPIRequestWrapper.Debt> getDebts(Application__c app, Map<String, List<Application_Other_Asset__c>> otherAssetMap) {
        List<PlentiAPIRequestWrapper.Debt> debts = new List<PlentiAPIRequestWrapper.Debt>();
        //get application loans
        List<Application_Loan__c> appLoans = ApplicationService.getApplicationLoans(app.Id);
        for(Application_Loan__c loan : appLoans){
          //personal loans and overdraft
          // if(loan.Type__c.equalsIgnoreCase('Personal Loan') || loan.Type__c.equalsIgnoreCase('Line of Credit')) {
          PlentiAPIRequestWrapper.Debt personalLoan = new PlentiAPIRequestWrapper.Debt();
          personalLoan.type = 'Debt/Default Arrangements'.equalsIgnoreCase(loan.Type__c) ? 'Overdraft' : 'PersonalLoan';
          personalLoan.balance = NumberUtils.intToString(loan.Amount_Owing__c);
          personalLoan.claimedMonthlyRepayment = loan.Payment__c != null ? NumberUtils.intToString(loan.Payment__c) : '0';
          personalLoan.payoffFullEveryMonth = false;
          personalLoan.limit_m = '0';
          personalLoan.claimedLoanAmount = NumberUtils.intToString(loan.Amount_Owing__c);
          debts.add(personalLoan);
          // }
        }
        //Motor Vehicle loan
        if (otherAssetMap.containsKey(ApplicationService.VEHICLE_ASSET_TYPE)) {
            for(Application_Other_Asset__c asset : otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE)){
                if('Y'.equalsIgnoreCase(asset.Has_Loan__c)){
                    PlentiAPIRequestWrapper.Debt carLoan = new PlentiAPIRequestWrapper.Debt();
                    carLoan.type = 'Car';
                    carLoan.balance = NumberUtils.intToString(asset.Amount_Owing__c);
                    carLoan.claimedMonthlyRepayment = asset.Monthly_Payment__c != null ? NumberUtils.intToString(asset.Monthly_Payment__c) : '0';
                    carLoan.payoffFullEveryMonth = false;
                    carLoan.limit_m = '0';
                    carLoan.claimedLoanAmount = asset.Amount_Owing__c != null ? NumberUtils.intToString(asset.Amount_Owing__c) : '0';
                    debts.add(carLoan);
                }
            }
        }
        //Credit cards
        List<Application_Credit_Card__c> creditCards =  ApplicationService.getApplicationCreditCards(app.Id);
        for (Application_Credit_Card__c card : creditCards) {
            PlentiAPIRequestWrapper.Debt cc = new PlentiAPIRequestWrapper.Debt();
            cc.type = 'CreditCard';
            cc.balance = NumberUtils.intToString(card.Amount_Owing__c);
            cc.claimedMonthlyRepayment = card.Monthly_Payment__c != null ? NumberUtils.intToString(card.Monthly_Payment__c) : '0';
            cc.payoffFullEveryMonth = false;
            cc.limit_m = card.Limit__c != null ? NumberUtils.intToString(card.Limit__c) : '0';
            cc.claimedLoanAmount = card.Amount_Owing__c != null ? NumberUtils.intToString(card.Amount_Owing__c) : '0';
            debts.add(cc);
        }
        return debts;
    }

    private PlentiAPIRequestWrapper.Loan getLoan(Application_Quoting__c quoting, Custom_Opportunity__c opp, Boolean isPLoan) {
        PlentiAPIRequestWrapper.Loan loan = new PlentiAPIRequestWrapper.Loan();
        loan.term = NumberUtils.intToString(quoting.Term__c);
        if (isPLoan) {
          loan.amount = quoting.Vehicle_Price__c.intValue();
          loan.purpose = quoting.Purpose_Type__c;
          if ('Other'.equals(loan.purpose)) {
            loan.purposeReason = StringUtils.maxLength(quoting.Loan_Purpose__c, 40);
          }
        } else {
          loan.financeType = quoting.Loan_Type__c;
          loan.saleType = 'Y'.equals(quoting.Private_Sales__c) ? 'Private' : 'Dealer'; 
          loan.deposit = NumberUtils.intToString(quoting.Net_Deposit__c);
          loan.addon = '0';
          // loan.purchasedPrice = NumberUtils.intToString(quoting.Vehicle_Price__c - quoting.Net_Deposit__c);
          loan.purchasedPrice = NumberUtils.intToString(quoting.Vehicle_Price__c);
          loan.vehicleCondition = opp.Application_AssetDetail__r.Condition__c == 'new' ? 'New' : 'Used';
          loan.modelYear = opp.Application_AssetDetail__r.Year__c != null ? opp.Application_AssetDetail__r.Year__c.intValue() : 0;
        }
        return loan;
    }

    private PlentiAPIRequestWrapper.BalloonPayment getBalloonPayment(Application_Quoting__c quoting) {
        Decimal cp = quoting.Vehicle_Price__c - quoting.Net_Deposit__c;
        Decimal pb = (quoting.Residual_Value__c / cp) * 100;
        PlentiAPIRequestWrapper.BalloonPayment balloonPayment = new PlentiAPIRequestWrapper.BalloonPayment();
        balloonPayment.enableBalloonPayment = true;
        balloonPayment.balloonPaymentAmount = String.valueOf(quoting.Residual_Value__c.intValue());
        balloonPayment.balloonPaymentPercentage = Integer.valueOf(pb);
        balloonPayment.customerReason = 'LowerMonthlyPayment';
        balloonPayment.customerPaidMethodWhenLoanDue = 'TradeIn';
        return balloonPayment;
    }

    public String getIncomeType(String incType){
        String r = 'Other';
        if('Rental Income'.equals(incType)){
          r = 'Rent';
        } else if('Second Job'.equals(incType)){
          r = 'AdditionalJob';
        } else if('Investment Income'.equals(incType)){
          r = 'Benefits';
        }
        return r;
    }

    public String getIncomeFrequency(String freq){
        String r = freq;
        if('Yearly'.equals(freq)){
          r = 'Annually';
        }
        return r;
    }

    public static String getPurpose(String loanFor){
        String r = null;
        if('Loan/Debt Consolidation'.equals(loanFor)){
          r = 'DebtConsolidation';
        } else if(
          'Car'.equals(loanFor) || 'Motorbike'.equals(loanFor) || 
          'Boat'.equals(loanFor) || 'Other'.equals(loanFor) || 
          'Holiday'.equals(loanFor) || 'Wedding'.equals(loanFor)){
          r = loanFor;
        } else if('Dental/Medical Expenses'.equals(loanFor)){
          r = 'MedicalDental';
        }
        return r;
    }

    public string getYearsAtAddress(Date startDate) {
      Integer yrs = DateUtils.getHowManyYears(startDate, System.today());
      if (yrs >= 10) {
        yrs = 10;
      } else if (yrs > 5) {
        yrs = 5;
      }
      return String.valueOf(yrs);
    }
}