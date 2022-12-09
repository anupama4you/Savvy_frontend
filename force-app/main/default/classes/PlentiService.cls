public class PlentiService {
    public static void getPentiRateEstimate(){
        
        Parameter par = get_fake_Body();
        String body = getPletiRateBody(par);
       system.debug('::: body :::'+body);
            
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.plenti.com.au/lenderApplication');
        request.setMethod('POST');
        request.setHeader('partnerId', '5ccca043-d1a8-4210-9218-95706e883089');
        request.setHeader('experience', 'PersonalLoanBroker');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setBody(body);
        request.setTimeout(60 * 1000);
		HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            system.debug('::: response :::'+response.getBody());
            Map<String, Object> paraser = (Map<String, Object>) JSON.deserialize(response.getBody(), Map<String, Object>.CLASS);
            
            for(String quot : paraser.keySet()){
                system.debug(':: quot :::'+quot);
                system.debug('::: value :::'+json.serialize(paraser.get(quot) ));
                system.debug('-------------------------------------------------------'); 
            }
        }

    }
    
    public static String getPletiRateBody(Parameter param)
    {
        
        
        JSONGenerator gen = JSON.createGenerator(true);
       
        gen.writeStartObject();

          gen.writeNumberField('Type', param.Type_info);
          gen.writeStringField('DefinitionName', param.DefinitionName);
          gen.writeStringField('Action', param.Action);
          gen.writeFieldName('Application');
              gen.writeStartObject();
                  gen.writeFieldName('applicant');
                      gen.writeStartObject();
                          gen.writeStringField('firstName', param.applicant_firstName);
                          gen.writeStringField('middleName', param.applicant_middleName);
                          gen.writeStringField('lastName', param.applicant_lastName);
                      
                      	  gen.writeFieldName('dateOfBirth');
                              gen.writeStartObject();
                                  gen.writeStringField('isoString', param.applicant_dateOfBirth_isoString);
                              gen.writeEndObject(); 
                          gen.writeStringField('maritalStatus', param.maritalStatus);
                          gen.writeStringField('residency', param.residency);
        			 gen.writeEndObject();
        
                    gen.writeFieldName('contact');
                      gen.writeStartObject();
                          gen.writeStringField('mobileNumber', param.contact_mobileNumber);
                          gen.writeStringField('email', param.contact_email);
                      gen.writeEndObject();

                    gen.writeFieldName('finances');
                      gen.writeStartObject();
                          gen.writeStringField('employment', param.finances_employment);
                          gen.writeStringField('income', param.finances_income);
                          gen.writeStringField('numberOfDependants', param.finances_numberOfDependants);
                      gen.writeEndObject();
        
                    gen.writeFieldName('address');
                      gen.writeStartObject();
                          gen.writeFieldName('residentialAddress');
                              gen.writeStartObject();
                                  gen.writeStringField('unitNumber', param.address_residentialAddress_unitNumber);
                                  gen.writeStringField('streetNumber', param.address_residentialAddress_streetNumber);
                                  gen.writeStringField('street', param.address_residentialAddress_street);
                                  gen.writeStringField('suburb', param.address_residentialAddress_suburb);
                                  gen.writeStringField('postCode', param.address_residentialAddress_postCode);
                                  gen.writeStringField('state', param.address_residentialAddress_state);
                                  gen.writeStringField('yearsAtAddress', param.address_residentialAddress_yearsAtAddress);
                              gen.writeEndObject();
                          gen.writeFieldName('previousAddress');
                              gen.writeStartObject();
                                  gen.writeStringField('unitNumber', param.address_previousAddress_unitNumber);
                                  gen.writeStringField('streetNumber', param.address_previousAddress_streetNumber);
                                  gen.writeStringField('street', param.address_previousAddress_street);
                                  gen.writeStringField('suburb', param.address_previousAddress_suburb);
                                  gen.writeStringField('postCode', param.address_previousAddress_postCode);
                                  gen.writeStringField('state', param.address_previousAddress_state);
                                  gen.writeStringField('yearsAtAddress', param.address_previousAddress_yearsAtAddress);
                              gen.writeEndObject();   
                      gen.writeEndObject();

                    gen.writeFieldName('expenses');
                        gen.writeStartObject();

                            gen.writeFieldName('foodAndGroceries');
                                gen.writeStartObject();
                                    gen.writeStringField('amount', param.expenses_foodAndGroceries_amount);
                                    gen.writeStringField('frequency', param.expenses_foodAndGroceries_frequency);
                                gen.writeEndObject();

                            gen.writeFieldName('utilities');
                                gen.writeStartObject();
                                    gen.writeStringField('amount', param.expenses_utilities_amount);
                                    gen.writeStringField('frequency', param.expenses_utilities_frequency);
                                gen.writeEndObject();

                            gen.writeFieldName('phoneAndInternet');
                                gen.writeStartObject();
                                    gen.writeStringField('amount', param.expenses_phoneAndInternet_amount);
                                    gen.writeStringField('frequency', param.expenses_phoneAndInternet_frequency);
                                gen.writeEndObject();

                            gen.writeFieldName('transport');
                                gen.writeStartObject();
                                    gen.writeStringField('amount', param.expenses_transport_amount);
                                    gen.writeStringField('frequency', param.expenses_transport_frequency);
                                gen.writeEndObject();

                            gen.writeFieldName('others');
                                gen.writeStartObject();
                                    gen.writeStringField('amount', param.expenses_others_amount);
                                    gen.writeStringField('frequency', param.expenses_others_frequency);
                                gen.writeEndObject();
                        gen.writeEndObject();

                        gen.writeFieldName('housing');
                            gen.writeStartObject();
                                gen.writeStringField('ownershipStatus', param.housing_ownershipStatus);
                                gen.writeStringField('propertyValue', param.housing_propertyValue);
                                gen.writeStringField('monthlyMortgage', param.housing_monthlyMortgage);
                                gen.writeStringField('mortgageBalance', param.housing_mortgageBalance);
                            gen.writeEndObject();

                        gen.writeFieldName('income');
                            gen.writeStartObject();
                                gen.writeStringField('netIncome', param.income_netIncome);
                                gen.writeStringField('netIncomeFrequency', param.income_netIncomeFrequency);
                                gen.writeStringField('spouseNetIncome', param.income_spouseNetIncome);
                                gen.writeStringField('spouseNetIncomeFrequency', param.income_spouseNetIncomeFrequency);
                                gen.writeBooleanField('hasOtherIncome', param.income_hasOtherIncome);

                                gen.writeFieldName('other');
                                    gen.writeStartArray();
                                        for(Other oth : param.otherList){
                                            gen.writeStartObject();
                                                gen.writeStringField('netIncome', oth.type_info);
                                                gen.writeStringField('netIncomeFrequency', oth.amount);
                                                gen.writeStringField('spouseNetIncome', oth.frequency);
                                            gen.writeEndObject();
                                        }
                                    gen.writeEndArray();
                            gen.writeEndObject();
                            gen.writeFieldName('employment');
                                gen.writeStartArray();
                                    for(employment oth : param.employmentList){
                                        gen.writeStartObject();
                                            gen.writeStringField('employer', oth.employer);
                                            gen.writeStringField('type', oth.type_info);
                                            gen.writeStringField('industry', oth.industry);
                                        	gen.writeStringField('years', oth.occupation);
                                            gen.writeStringField('years', oth.years);
                                            gen.writeStringField('months', oth.months);
                                        gen.writeEndObject();
                                    }
                                gen.writeEndArray();

                           gen.writeFieldName('bank'); 
                              gen.writeStartObject();
                                  gen.writeStringField('accountNumber', param.bank_accountNumber);
                                      gen.writeFieldName('bsb'); 
                                          gen.writeStartObject();
                                              gen.writeStringField('inputString', param.bank_bsb_inputString);
                                          gen.writeEndObject();
                              gen.writeEndObject();

                            gen.writeFieldName('debts'); 
                              gen.writeStartArray();
                                  for(debts oth : param.debtsList){
                                        gen.writeStartObject();
                                            gen.writeStringField('type', oth.type_info);
                                            gen.writeStringField('balance', oth.balance);
                                            gen.writeStringField('limit', oth.limit_info);
                                            gen.writeNumberField('interestRate', oth.interestRate);
                                            gen.writeBooleanField('isConsolidated', oth.isConsolidated);
                                            gen.writeBooleanField('isClosed', oth.isClosed);
                                            gen.writeStringField('provider', oth.provider);
                                        gen.writeEndObject();
                                  }
                              gen.writeEndArray();

                            gen.writeFieldName('loan'); 
                                gen.writeStartObject();
                                    gen.writeNumberField('amount', param.loan_amount);
                                    gen.writeStringField('purpose', param.loan_purpose);
                                    gen.writeStringField('term', param.loan_term);
                                gen.writeEndObject();
                            gen.writeFieldName('termsAndConditions'); 
                                gen.writeStartObject();
                                    gen.writeBooleanField('privacyAgreement', param.termsAndConditions_privacyAgreement);
                                    gen.writeBooleanField('creditReportingAgreement', param.termsAndConditions_creditReportingAgreement);
                                    gen.writeBooleanField('creditGuideConfirmation', param.termsAndConditions_creditGuideConfirmation);
                                    gen.writeStringField('additionalComments', param.termsAndConditions_additionalComments);
                                gen.writeEndObject();
                            gen.writeFieldName('broker'); 
                                gen.writeStartObject();
                                    gen.writeStringField('brokerEmail', param.brokerEmail);
                                    gen.writeStringField('brokerageAmount', param.brokerageAmount);
                                gen.writeEndObject();
                            gen.writeFieldName('borrowerMetaInfo');  
                                gen.writeStartObject();
                                    gen.writeBooleanField('sourceFromApi', param.borrowerMetaInfo_sourceFromApi);
                                gen.writeEndObject();


              gen.writeEndObject();
        gen.writeEndObject();
                 
        String jsonPreety = gen.getAsString();
        return jsonPreety;
    }
    
  public class Parameter{
      public integer Type_info;
      public string DefinitionName;
      public string Action;
      public string applicant_firstName;
      public string applicant_middleName;
      public string applicant_lastName;
      public string applicant_dateOfBirth_isoString;
      public string maritalStatus;
      public string residency;
      public string contact_mobileNumber;
      public string contact_email;
      public string finances_employment;
      public string finances_income;
      public string finances_numberOfDependants;
      public string address_residentialAddress_unitNumber;
      public string address_residentialAddress_streetNumber;
      public string address_residentialAddress_street;
      public string address_residentialAddress_suburb;
      public string address_residentialAddress_postCode;
      public string address_residentialAddress_state;
      public string address_residentialAddress_yearsAtAddress;
      public string address_previousAddress_unitNumber;
      public string address_previousAddress_streetNumber;
      public string address_previousAddress_street;
      public string address_previousAddress_suburb;
      public string address_previousAddress_postCode;
      public string address_previousAddress_state;
      public string address_previousAddress_yearsAtAddress;
      public string expenses_foodAndGroceries_amount;
      public string expenses_foodAndGroceries_frequency;
      public string expenses_utilities_amount;
      public string expenses_utilities_frequency;
      public string expenses_phoneAndInternet_amount;
      public string expenses_phoneAndInternet_frequency;
      public string expenses_transport_amount;
      public string expenses_transport_frequency;
      public string expenses_others_amount;
      public string expenses_others_frequency;
      public string housing_ownershipStatus;
      public string housing_propertyValue;
      public string housing_monthlyMortgage;
      public string housing_mortgageBalance;
      public string income_netIncome;
      public string income_netIncomeFrequency;
      public string income_spouseNetIncome;
      public string income_spouseNetIncomeFrequency;
      public Boolean income_hasOtherIncome;
      public List<other> otherList;
      public List<employment> employmentList;
      public String bank_accountNumber;
      public String bank_bsb_inputString;
      public List<debts> debtsList;
      public integer loan_amount;
      public String loan_purpose;
      public String loan_term;
      public Boolean termsAndConditions_privacyAgreement;
      public Boolean termsAndConditions_creditReportingAgreement;
      public Boolean termsAndConditions_creditGuideConfirmation;
      public String termsAndConditions_additionalComments;
      public String brokerEmail;
      public String brokerageAmount;
      public boolean borrowerMetaInfo_sourceFromApi;
}

  public class other{
    public string type_info;
    public string amount;
    public string frequency;
  }
  
  public class employment{
    public string employer;
    public string type_info;
    public string industry;
    public string occupation;
    public string years;
    public string months;
  }

  public class debts{
    public string type_info;
    public string balance;
    public string limit_info;
    public integer interestRate;
    public boolean isConsolidated;
    public boolean isClosed;
    public string provider;
	public string claimedMonthlyRepayment;
  } 
    
    public static Parameter get_fake_Body(){
          Parameter par = new Parameter();
          par.Type_info = 2;
          par.DefinitionName = 'personalLoanBrokerApplication';
          par.Action = 'RateEstimateCompleted';
          par.applicant_firstName = 'AA';
          par.applicant_middleName = 'CC';
          par.applicant_lastName = 'BB';
          par.applicant_dateOfBirth_isoString = '1990-02-01T00:00:00';
          par.maritalStatus = 'Single';
          par.residency	= 'auNzCitizen';
          par.contact_mobileNumber = '0400000000';
          par.contact_email = 'api+test@example.com';
          par.finances_employment = 'FullTime';
          par.finances_income = '100000';
          par.finances_numberOfDependants = '0';
          par.address_residentialAddress_unitNumber = '9';
          par.address_residentialAddress_streetNumber = '106';
          par.address_residentialAddress_street = 'Liverpool Road';
          par.address_residentialAddress_suburb = 'Ashfield';
          par.address_residentialAddress_postCode =  '2131';
          par.address_residentialAddress_state =  'NSW';
          par.address_residentialAddress_yearsAtAddress = '2';
          par.address_previousAddress_unitNumber = '1';
          par.address_previousAddress_streetNumber = '7';
          par.address_previousAddress_street = 'Angas Street';
          par.address_previousAddress_suburb = 'Meadowbank';
          par.address_previousAddress_postCode = '2114';
          par.address_previousAddress_state = 'NSW';
          par.address_previousAddress_yearsAtAddress = '4';
          par.expenses_foodAndGroceries_amount = '200';
          par.expenses_foodAndGroceries_frequency = 'Weekly';
          par.expenses_utilities_amount = '100';
          par.expenses_utilities_frequency = 'Weekly';
          par.expenses_phoneAndInternet_amount = '50';
          par.expenses_phoneAndInternet_frequency = 'Weekly';
          par.expenses_transport_amount = '400';
          par.expenses_transport_frequency = 'Weekly';
          par.expenses_others_amount = '100';
          par.expenses_others_frequency = 'Weekly';
          par.housing_ownershipStatus = 'OwnAHomeWithMortgage';
          par.housing_propertyValue = '500000';
          par.housing_monthlyMortgage = '1000';
          par.housing_mortgageBalance = '300000';
          par.income_netIncome = '100000';
          par.income_netIncomeFrequency = 'Annually';
          par.income_spouseNetIncome = '100000';
          par.income_spouseNetIncomeFrequency = 'Annually';
          par.income_hasOtherIncome = true;
    
          par.otherList = new List<other>();
        
          other ot1 = new other();
          ot1.type_info = 'Rent';
          ot1.amount = '100';
          ot1.frequency = 'Weekly';
          par.otherList.add(ot1);
        
          other ot2 = new other();
          ot2.type_info = 'AdditionalJob';
          ot2.amount = '100';
          ot2.frequency = 'Weekly';
          par.otherList.add(ot2);  
    
          par.employmentList = new List<employment>();
          employment emp = new employment();
          emp.employer = 'Plenti';
          emp.type_info = 'FullTime';
          emp.industry = 'FinancialServices';
          emp.occupation = 'Engineer';
          emp.years= '1';
          emp.months = '10';
          par.employmentList.add(emp);
        
          employment emp2 = new employment();
          emp2.employer = 'IR';
          emp2.type_info = 'PartTime';
          emp2.industry = 'FinancialServices';
          emp2.occupation = 'Manager';
          emp2.years= '1';
          emp2.months = '10';
          par.employmentList.add(emp2);
       
          par.bank_accountNumber = '12121212';
          par.bank_bsb_inputString = '062303';
    
          par.debtsList = new List<debts>();
         
          debts debtsObj = new debts();
          debtsObj.type_info = 'CreditCard';
          debtsObj.balance = '500';
          debtsObj.limit_info = '1000'; 
          debtsObj.interestRate = 11;
          debtsObj.isConsolidated = true;
          debtsObj.isClosed =  true;
          debtsObj.provider = 'Westpac';
		  par.debtsList.add(debtsObj);   
        
          debts debtsObj2 = new debts();
          debtsObj2.type_info = 'CreditCard';
          debtsObj2.balance = '500';
          debtsObj2.limit_info = '1000'; 
          debtsObj2.interestRate = 11;
          debtsObj2.isConsolidated = true;
          debtsObj2.isClosed =  true;
          debtsObj2.provider = 'Westpac';
		  par.debtsList.add(debtsObj2);  
        
          par.loan_amount = 10000;
          par.loan_purpose = 'HomeImprovement';
          par.loan_term = '36';
    
          par.termsAndConditions_privacyAgreement = true;
          par.termsAndConditions_creditReportingAgreement = true;
          par.termsAndConditions_creditGuideConfirmation = true;
          par.termsAndConditions_additionalComments = 'Comments';
          par.brokerEmail = 'broker@example.com';
          par.brokerageAmount = '500';
          par.borrowerMetaInfo_sourceFromApi = true;
        
		return par;
    }
}