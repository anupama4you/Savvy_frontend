public with sharing class LenderComparisonFilterExtension {

    private final Custom_Opportunity__c opp;
	private Comparison_Feedback__c cfc;
    public FilterParams param {set;get;}
    //public List<Lenders__c> lenderList {set;get;}
    public List<Lender_Comparative_Data__c> dataList {set;get;}
    //public Lender_Comparative_Data__c ruleSelected {set;get;}
    public Id ruleSelectedId {set;get;}
    public Boolean isActiveComparison {set;get;}
    public Lender_Comparative_Data__c lenderSelected {set;get;}

    //Comparison
    public List<LenderQuotingWrapperDTO> lendersList {set;get;}
    public Integer offset = 0;

    public Integer isOpinion {set;get;}
    public Boolean isLeadFlow {set;get;}
    public Integer infoExtra {set;get;}
    public Boolean hasObjectingOpened {set;get;}
    public Boolean hasNotCustomerProvidedInfo {set;get;}
    public String lenderCodeSelected {set;get;}
    public String opinionText {set;get;}
    public String opinionMessage {set;get;}
    public List <SelectOption> tierOptions {get;set;}
    private List<String> tierValues = new List<String> {
        'Tier 1', 'Tier 2', 'Tier 3'
    };
    public String lenderParam {set;get;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public LenderComparisonFilterExtension(ApexPages.StandardController stdController) {
        this.opp = (Custom_Opportunity__c)stdController.getRecord();
        String paramTmp = System.currentPageReference().getParameters().get('P');
        isLeadFlow = false;
        infoExtra = 0;
        isOpinion = 0;
        opinionText = '';
        if (String.isNotBlank(paramTmp)) {
            if ('LEADFLOW'.equals(paramTmp)) {
                isLeadFlow = true;
            }
        }
/*
        String paramTmp = System.currentPageReference().getParameters().get('ruleId');
        System.debug('paramTmp >> ' + paramTmp);
        if (!String.isBlank(paramTmp)) {
            isActiveComparison = true;
            ruleSelectedId = paramTmp;
            init();
        } else {
*/
            param = this.preLoadFilterParams();
            dataList = new List<Lender_Comparative_Data__c>();
            isActiveComparison = false;
            //Lelo                  2017-09-19
            if (isLeadFlow) {
                this.search();
            }
            //-
        //}
        // System.debug('Request parameters...');
        // for (String p : System.currentPageReference().getParameters().keySet()) {
        //     System.debug(p + ' | ' + System.currentPageReference().getParameters().get(p));
        // }
        // System.debug('--------------------------');

        paramTmp = System.currentPageReference().getParameters().get('Lenders');
        if (String.isNotBlank(paramTmp)) {
          lenderParam = paramTmp;
        }
        System.debug('lenderParam 1: ' + lenderParam);
    }

    //Lelo              2017-09-19
    private FilterParams preLoadFilterParams() {
        FilterParams r = new FilterParams();

        if (this.opp.Application__c != null) {
            //Applicant age
            r.applicantAge = DateUtils.getHowManyYears(this.opp.Application__r.Date_of_Birth_1__c);
            r.jobsLast3Years = this.calculateJobsLatestYears();
            r.annualIncome = this.calculateAnnualIncome();
            //Aset Details
            if (String.isNotBlank(this.opp.Application__r.Type_of_Asset__c)) {
                if ('Car'.equals(this.opp.Application__r.Type_of_Asset__c)) {
                    r.assetDetail = 'Car';
                } else if ('Bike'.equals(this.opp.Application__r.Type_of_Asset__c)) {
                    r.assetDetail = 'Motorbike';
                } else if ('Caravan'.equals(this.opp.Application__r.Type_of_Asset__c)) {
                    r.assetDetail = 'Caravan';
                } else if ('Truck'.equals(this.opp.Application__r.Type_of_Asset__c)) {
                    r.assetDetail = 'Truck';
                } else if ('Boat'.equals(this.opp.Application__r.Type_of_Asset__c) ||
                           'JetSki'.equals(this.opp.Application__r.Type_of_Asset__c)) {
                    r.assetDetail = 'Boat';
                } else {
                    r.assetDetail = this.opp.Application__r.Type_of_Asset__c;    
                }
            }
            
            //Employment Type
            if (String.isNotBlank(this.opp.Application__r.Application_Type__c)) {
                if ('Personal'.equals(this.opp.Application__r.Application_Type__c)) {
                    if ('Full Time'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                        r.employmentType = 'Full-Time';    
                    } else if ('Part Time'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                        r.employmentType = 'Permanent Part-Time';
                    } else if ('Casual'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                        Integer m = FieldValidationsHelper.getMonthsBetween(this.opp.Application__r.Date_Started_1__c);
                        if (m != null) {
                            if (m < 12) {
                                r.employmentType = 'Casual < 12 months';        
                            } else {
                                r.employmentType = 'Casual > 12 months';        
                            }
                        }
                    } else if ('Self Employed'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                        r.employmentType = 'Self employed (Full-Doc)';
                    }
                } else {
                    if (this.opp.Lead__c != null) {
                        if ('Y'.equals(this.opp.Lead__r.Has_Tax_Returns__c)) {
                            r.employmentType = 'Self employed (Full-Doc)';        
                        } else {
                            r.employmentType = 'Self employed (Low-Doc)';
                        }
                    }
                }
            }
                        
            //Age Vehicle
            if (String.isNotBlank(this.opp.Application__r.Vehicle_Year__c) && this.opp.Application__r.Vehicle_Year__c.isNumeric()) {
                Integer currYear = Date.today().year();
                Integer vYear = Integer.valueOf(this.opp.Application__r.Vehicle_Year__c);
                r.ageCar = String.valueOf(currYear - vYear);
            }

            //Loan Term
            if (this.opp.Application__r.Length_of_Term__c != null) {
                r.loanTerm = Integer.valueOf(this.opp.Application__r.Length_of_Term__c) * 12;
            }

            //Residential Status
            // System.debug('Current_Residence_Status_1__c: ' + this.opp.Application__r.Current_Residence_Status_1__c);
            Decimal mortgageTotal = ApplicationService.getApplicationTotalMortgage(this.opp.Application__c);
            if ('Own Outright'.equals(this.opp.Application__r.Current_Residence_Status_1__c) || 
                'Mortgage'.equals(this.opp.Application__r.Current_Residence_Status_1__c) ||
                mortgageTotal > 0) {
                r.residentialStatus = 'Property Owner';
            } else if ('Renting(Agent)'.equals(this.opp.Application__r.Current_Residence_Status_1__c)) {
                r.residentialStatus = 'Renting Real Estate';
            } else if ('Renting(Private)'.equals(this.opp.Application__r.Current_Residence_Status_1__c)) {
                r.residentialStatus = 'Renting Other';
            } else {
                r.residentialStatus = 'Boarding';
            }

            //Vehicle Price
            if (this.opp.Application__r.Purchase_Price__c != null) {
                r.price = this.opp.Application__r.Purchase_Price__c;
            }

            //Have you got any current verifiable credit?
            if (ApplicationService.hasVerifiableCredit(this.opp.Application__c)) {
                r.hasVerifiableCredit = 'Y';
            }

            //Current payday loan in the last 6 months?
            List<Application_Loan__c> loans = ApplicationService.getApplicationLoans(this.opp.Application__c);
            if (loans != null && !loans.isEmpty()) {
                for (Application_Loan__c a : loans) {
                    if ('Payday Loan'.equals(a.Type__c)) {
                        r.hasPayday = 'Y';
                        break;
                    }
                }
            }
            //Verifiable Savings?
            if (this.opp.Application__r.Bank_Value__c != null && this.opp.Application__r.Bank_Value__c > 0) {
                if (this.opp.Application__r.Bank_Value__c < 50000) {
                    r.verifiableSavings = '<50k';
                } else if (this.opp.Application__r.Bank_Value__c < 100000) {
                    r.verifiableSavings = '50k-100K';
                } else if (this.opp.Application__r.Bank_Value__c >= 100000) {
                    r.verifiableSavings = '100K+';
                }
            }
        }
        if (this.opp.Lead__c != null) {
            //Loan Type
            if (String.isNotBlank(this.opp.Lead__r.Application_Type__c)) {
                if ('Personal'.equals(this.opp.Lead__r.Application_Type__c)) {
                    r.loanType = 'Consumer Loan';    
                } else if ('Business'.equals(this.opp.Lead__r.Application_Type__c)) {
                    if ('Y'.equals(this.opp.Lead__r.Has_Tax_Returns__c)) {
                        r.loanType = 'Full-Doc Chattel Mortgage';    
                    } else {
                        r.loanType = 'Low-Doc Chattel Mortgage';    
                    }
                } else if ('Bad Credit'.equals(this.opp.Lead__r.Application_Type__c)) {
                    r.creditHistory = 'Defaults & or Previous Bankrupt';
                }
            }

            //Credit History
            if (String.isNotBlank(this.opp.Lead__r.Has_Clean_Credit_History__c)) {
                if ('Y'.equals(this.opp.Lead__r.Has_Clean_Credit_History__c) ||
                    'Excellent'.equals(this.opp.Lead__r.Credit_History__c)) {
                    r.creditHistory = 'Clean History';    
                } else {
                    r.creditHistory = 'Defaults & or Previous Bankrupt';
                }
            }

            //Purchase Type
            if (String.isNotBlank(this.opp.Lead__r.Purchase_Type__c)) {
                r.purchaseType = this.opp.Lead__r.Purchase_Type__c;
            }

            //Deposit
            if (this.opp.Lead__r.Deposit__c != null) {
                r.deposit = this.opp.Lead__r.Deposit__c;
            } else {
                r.deposit = 0.0;
            }

            //Have you had more than 3 credit enquiries in 6 months?
            if (String.isNotBlank(this.opp.Lead__r.Has_Credit_Enquiries__c)) {
                r.hasEnquiries = this.opp.Lead__r.Has_Credit_Enquiries__c;
            }
        }

        Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(this.opp.Id, this.opp.Application__c);
        if (quoting != null) {
            if (quoting.Vehicle_Price__c != null) {
                r.price = quoting.Vehicle_Price__c;
            }
            if (quoting.Term__c != null) {
                r.loanTerm = quoting.Term__c.intValue();
            }
            if (quoting.Net_Deposit__c != null) {
                r.deposit = quoting.Net_Deposit__c;
            }
            if (quoting.Residual_Value__c != null) {
                r.residual = quoting.Residual_Value__c;
            }
            quoting = null;
        }
        //Parameters read
        // System.debug('Asset Detail      : ' + r.assetDetail);
        // System.debug('Employment Type   : ' + r.employmentType);
        // System.debug('Loan Type         : ' + r.loanType);
        // System.debug('Purchase Type     : ' + r.purchaseType);
        // System.debug('Credit History    : ' + r.creditHistory);
        // System.debug('Age Vehicle       : ' + r.ageCar);
        // System.debug('Loan Term (months): ' + r.loanTerm);
        // System.debug('Residential Status: ' + r.residentialStatus);
        // System.debug('Vehicle Price     : ' + r.price);
        // System.debug('Deposit           : ' + r.deposit);
        // System.debug('Residual          : ' + r.residual);
        // System.debug('Applicant Age     : ' + r.applicantAge);
        // System.debug('Has Payday        : ' + r.hasPayday);
        // System.debug('Has verifiable credit : ' + r.hasVerifiableCredit);
        // System.debug('Jobs last 3 years : ' + r.jobsLast3Years);
        // System.debug('Annual income     : ' + r.annualIncome);
        
        tierOptions = new List<SelectOption>();
        tierOptions.add(new SelectOption ('', '--None--'));
        for(String value : tierValues) {
            tierOptions.add(new SelectOption (value, value));
        }
        
        return r;
    }

    private Boolean isValidForSearch() {
        Boolean r = true;
        if (String.isBlank(param.assetDetail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Asset Detail.'));
            r = false;
        }
        if (String.isBlank(param.employmentType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Employment Type.'));
            r = false;
        }
        if (String.isBlank(param.loanType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Loan Type.'));
            r = false;
        }
        if (String.isBlank(param.purchaseType) && !'Personal Loan'.equals(param.loanType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Purchase Type.'));
            r = false;
        }
        //if (String.isBlank(param.termEnd)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Term End.'));
        //    r = false;
        //}
        if (String.isBlank(param.creditHistory)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Credit History.'));
            r = false;
        }

        if (param.loanTerm == null || param.loanTerm <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill a value for Loan Term.'));
            r = false;
        }        
        if (String.isBlank(param.residentialStatus)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select a value for Residential Status.'));
            r = false;
        }        
        if (param.price == null || param.price <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill a value for Vehicle Price.'));
            r = false;
        }        
        if (param.deposit == null && !'Personal Loan'.equals(param.loanType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill a value for Deposit.'));
            r = false;
        }
        return r;
    }

    //Filter
    public PageReference search() {

        //Validate params
        if (!isValidForSearch()) {
            return null;
        }
        param.reset();
        lenderSelected = null;

        //Estimate Term End
        Integer carAge = Integer.valueOf(param.ageCar);
        param.termEnd = '12 Years';
        Decimal termEnd = (param.loanTerm / 12) + carAge;
        if (termEnd > 12 && termEnd <= 15) {
            param.termEnd = '15 Years';
        } else if (termEnd > 15) {
            param.termEnd = '20 Years';
        }

        //lenderList = new List<Lenders__c>();
        dataList = new List<Lender_Comparative_Data__c>();
        String query = 'SELECT Result_Type__c, Options__c, Notes__c, Asset_Detail__c, ' +
                       'Credit_History__c, Employment_Type__c, Loan_Type__c, Purchase_Type__c, ' +
                       'Term_End__c, Rule__c, Id FROM Lender_Comparative_Data__c '; 
        String wh = '';
        if (!String.isBlank(param.assetDetail)) {
            wh = 'Asset_Detail__c = \'' + param.assetDetail + '\'';
        }
        if (!String.isBlank(param.employmentType)) {
            if (!String.isBlank(wh)) wh += ' AND ';
            wh += 'Employment_Type__c = \'' + param.employmentType + '\'';
        }
        if (!String.isBlank(param.loanType)) {
            if (!String.isBlank(wh)) wh += ' AND ';
            wh += 'Loan_Type__c = \'' + param.loanType + '\'';
        }
        if (!String.isBlank(param.purchaseType)) {
            if (!String.isBlank(wh)) wh += ' AND ';
            wh += 'Purchase_Type__c = \'' + param.purchaseType + '\'';
        }
        if (!String.isBlank(param.termEnd)) {
            if (!String.isBlank(wh)) wh += ' AND ';
            wh += 'Term_End__c = \'' + param.termEnd  + '\'';
        }
        if (!String.isBlank(param.creditHistory)) {
            if (!String.isBlank(wh)) wh += ' AND ';
            wh += 'Credit_History__c = \'' + param.creditHistory + '\'';
        }
        // System.debug('params >> ' + param.assetDetail + '|' + param.employmentType + '|' + param.loanType + '|' + param.purchaseType + '|' + param.termEnd + '|' + param.creditHistory);
        // System.debug('where >> ' + wh);
        
        query += ' WHERE ' + wh;
        // System.debug('query >> ' + query);
        dataList = Database.query(query);
        if (!dataList.isEmpty()) {
            lenderSelected = dataList[0];
            if (String.isNotBlank(lenderSelected.Options__c)) {
                String[] ldrs = lenderSelected.Options__c.split(',');
                for (Integer i = 0;i < ldrs.size();i++) {
                    ldrs[i] = ldrs[i].trim();
                    Boolean skipLender = false;
                    if ('Metro'.equals(ldrs[i]) ||
                        'Macquarie Commercial'.equals(ldrs[i])) {
                        if (param.loanTerm > 60) {
                            skipLender = true;
                        }
                    } else if ('ANZ Others'.equals(ldrs[i])) {
                        if ('Consumer Loan'.equals(param.loanType)) {
                            skipLender = true;
                        }
                    } else if ('ANZ Consumer'.equals(ldrs[i])) {
                        if ('Consumer Loan'.equals(param.loanType)) {
                            skipLender = true;
                        }
                    } else if ('Money3'.equals(ldrs[i])) {
                        param = LenderComparisonHelper.getMoney3RiskGrade(param);
                        if (!LenderComparisonHelper.includeMoney3(param)) {
                            skipLender = true;
                        }
                    }
                    if (!skipLender) {
                        param.lenderList.add(ldrs[i].replaceAll('Yamaha Water Vehicles','Yamaha Water'));
                    } else {
                        System.debug(ldrs[i] + ' >> has been excluded from array');
                    }
                }
            }
        }

        //Validation for Pepper Summer
            //if (LenderComparisonHelper.includePepperSummer(param)) {
                //    System.debug('Pepper Summer added...');
                //    param.lenderList.add('Pepper Summer');
            //}
        
        if (LenderComparisonHelper.includePepperLeisure(param)) {
            System.debug('Pepper Leisure added...');
            param.lenderList.add('Pepper Leisure');
        }
        //if (LenderComparisonHelper.includePepper5Oh(param)) {
        //    System.debug('Pepper Seasonal added...');
        //    param.lenderList.add('Pepper 5Oh');
        //}
        if (LenderComparisonHelper.includePepperMV(param)) {
            System.debug('Pepper MV added...');
            param.lenderList.add('Pepper MV');
        }
        if (LenderComparisonHelper.includeRateSetter(param)) {
            System.debug('RateSetter added...');
            param.lenderList.add('RateSetter');   
        }
        if (LenderComparisonHelper.includeFirstmac(param)) {
            System.debug('Firstmac added...');
            param.lenderList.add('Firstmac');   
        }
        if (LenderComparisonHelper.includeAFSConsumer(param)) {
            System.debug('AFS Consumer added...');
            param.lenderList.add('AFS Consumer');   
        }
        if (LenderComparisonHelper.includeAFSCommercial(param)) {
            System.debug('AFS Commercial added...');
            param.lenderList.add('AFS Commercial');   
        }
        if (LenderComparisonHelper.includeLatitude(param)) {
            System.debug('Latitude added...');
            param.lenderList.add('Latitude');   
        }
        if(LenderComparisonHelper.includeLibertyDrive(param)) {
            System.debug('Liberty Drive added...');
            param.lenderList.add('Liberty Drive');   
        }
        if(LenderComparisonHelper.includeYamaha(param)){
            System.debug('Yamaha added...');
            param.lenderList.add(YamahaMarineCalculatorExtension.LENDER_QUOTING);
        }
        if(LenderComparisonHelper.includeMacquarie(param)){
            System.debug('Macquarie added...');
            param.lenderList.add(MacquarieConsumerExtension.LENDER_QUOTING);
        }
        System.debug('Lenders by parameters >> ' + param.lenderList);
		
        Set<String> addLenrers = null;
        // Trucks
        addLenrers = LenderComparisonHelper.includeTruckLenders(param);
        if (!addLenrers.isEmpty()) {
            param.lenderList.clear();
            param.lenderList.addAll(addLenrers);
        }

        //Personal Loans        
        addLenrers = LenderComparisonHelper.includePersonalLoans(param);
        if (!addLenrers.isEmpty()) {
            param.lenderList.clear();
            param.lenderList.addAll(addLenrers);
            param.deposit = 0;
            param.residual = 0;
        }

        // Payday loan last 6 months
        addLenrers = LenderComparisonHelper.includePaydayLoanLenders(param);
        if (!addLenrers.isEmpty()) {
            param.lenderList.clear();
            param.lenderList.addAll(addLenrers);
        }
        System.debug('Lenders by special conditions >> ' + param.lenderList);
        //Exclusions
        // Liberty Drive
        if (param.lenderList.contains(LibertyDriveExtension.LENDER_QUOTING) 
            && LenderComparisonHelper.excludeLibertyDrive(param)) {
            	param.lenderList.remove(LibertyDriveExtension.LENDER_QUOTING);
        }
        // Pepper
        if (LenderComparisonHelper.excludeAnyPepper(param)) {
            if (param.lenderList.contains(PepperCalculatorMVExtension.LENDER_QUOTING)) {
                param.lenderList.remove(PepperCalculatorMVExtension.LENDER_QUOTING);
            }
            //if (param.lenderList.contains(PepperCalculatorSeasonalExtension.LENDER_QUOTING)) {
            //    param.lenderList.remove(PepperCalculatorSeasonalExtension.LENDER_QUOTING);
            //}
            if (param.lenderList.contains(PepperCalculatorLeisureExtension.LENDER_QUOTING)) {
                param.lenderList.remove(PepperCalculatorLeisureExtension.LENDER_QUOTING);
            }
            //if (param.lenderList.contains(PepperSummerExtension.LENDER_QUOTING)) {
            //    param.lenderList.remove(PepperSummerExtension.LENDER_QUOTING);
            //}
        }
        // Current payday loan in the last 6 months?
        if (LenderComparisonHelper.excludeAnyMacquarie(param)) {
            if (param.lenderList.contains(MacquarieConsumerExtension.LENDER_QUOTING)) {
                param.lenderList.remove(MacquarieConsumerExtension.LENDER_QUOTING);
            }
            if (param.lenderList.contains(MacquarieCommercialExtension.LENDER_QUOTING)) {
                param.lenderList.remove(MacquarieCommercialExtension.LENDER_QUOTING);
            }
        }
		
        if(LenderComparisonHelper.excludeYamaha(param)){
            if (param.lenderList.contains(YamahaMarineCalculatorExtension.LENDER_QUOTING)) {
                param.lenderList.remove(YamahaMarineCalculatorExtension.LENDER_QUOTING);
            }
        }
        System.debug('Lenders after exclusions >> ' + param.lenderList);
        //Lelo Temporary manual list
        //dataList.clear();
        //param.lenderList.clear();
        //param.lenderList.add('ANZ Consumer');
        System.debug('lenderParam 2: ' + lenderParam);
        if (String.isNotBlank(lenderParam)) {
          param.lenderList.clear();
          if ('all'.equalsIgnoreCase(lenderParam)) {
            List<Lenders__c> d = [
              Select Id, Name, Label__c, lender__c, Active__c, Comparison_Active__c 
              From Lenders__c Where Comparison_Active__c = true Order By Label__c
            ];
            for (Lenders__c a: d) {
              param.lenderList.add(a.lender__c);
            }
          } else {
            param.lenderList.addAll(lenderParam.split(','));
          }            
        }
        
        //Validation for Pepper Seasonal
        if (param.lenderList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No result. Please choose any other values or refer to your team leader.'));
            if (this.lendersList != null) {
                this.lendersList.clear();
            }
        } else {
            isActiveComparison = true;
            LenderComparisonHelper.calculatePricingStrategy(param);
            init();
        }
        
        return null;
    }

    //Comparison
    private void init() {
        //Load Lender Comparison Detail
        loadLendersToCompare();
    }

    public PageReference restart() {
        //param = new FilterParams();
        //param.assetDetail = lenderSelected.Asset_Detail__c;
        //param.employmentType = lenderSelected.Employment_Type__c;
        //param.loanType = lenderSelected.Loan_Type__c;
        //param.purchaseType = lenderSelected.Purchase_Type__c;
        //param.termEnd = lenderSelected.Term_End__c;
        //param.creditHistory = lenderSelected.Credit_History__c;
        //System.debug('Rule Id >> ' + lenderSelected.Rule__c);
        param.reset();
        dataList = new List<Lender_Comparative_Data__c>();
        isActiveComparison = false;
        lendersList = new List<LenderQuotingWrapperDTO>();
        return null;
    }

    private void loadLendersToCompare() {
        lendersList = new List<LenderQuotingWrapperDTO>();
        offset = 0;
        
        System.debug('Lenders >> ' + param.lenderList);
        if (!param.lenderList.isEmpty()) {
            Map<String, LenderQuotingWrapperDTO> resultMap = new Map<String, LenderQuotingWrapperDTO>();
            //Get Lenders
            List<Lenders__c> ldrsList = [
                SELECT lender__c, Static_Logo_Resource__c, Credit_Guidelines_1__c, 
                        Credit_Guidelines_2__c, Credit_Guidelines_3__c, Label__c,
                        Quoting_Calculation_Page__c, Code__c, Application_Fee__c,
                        DOF__c, PPSR__c, Application_Fee_Private__c, Default_Base_Rate__c,
                        Monthly_Fee__c, DOC_Fees__c, Client_Rate_Factor__c, Brokerage_Base__c,
                        Commission_Rate__c, Client_Rate_Type__c, Max_Brokerage__c, Max_DOF__c 
                  FROM Lenders__c WHERE lender__c IN :param.lenderList AND Comparison_Active__c = true
                ];
            for (Lenders__c l : ldrsList) {
                LenderQuotingWrapperDTO dto = new LenderQuotingWrapperDTO(l);
                // System.debug('Lender: ' + dto.info.Lender__c);
                // System.debug('JSON: ' +JSON.serialize(dto.info));
                LenderComparisonFilterExtension.calculateBaseRate(dto, param, lenderSelected);
                resultMap.put(l.lender__c, dto);
                lendersList.add(dto);
            }
            if(LenderComparisonHelper.TIER_2.equals(param.tier)){
                adjustClientRate(2.0);
            }else if(LenderComparisonHelper.TIER_3.equals(param.tier)){
                adjustClientRate(100.0);
            }
            
            //Order result
            lendersList.sort();

            // Calculate Servicing
            this.calculateServicing();
        }
    }

    public Boolean getIsLendersEnabledOnTheLeft() {
        Boolean r = false;
        if (lendersList != null && offset > 0) r = true;
        return r;
    }

    public Boolean getIsLendersEnabledOnTheRight() {
        Boolean r = false;
        if (lendersList != null && ((offset + 5) < lendersList.size())) r = true;
        return r;
    }

    public PageReference openQuotingTool() {
        System.debug('lenderCodeSelected: ' + this.lenderCodeSelected);
        return this.goToQuotingTool(this.lenderCodeSelected);
    }
    
    private PageReference goToQuotingTool(String lenderCode) {
        LenderQuotingWrapperDTO lender = null;
        for (LenderQuotingWrapperDTO a: lendersList) {
            if (a.info.Code__c.equals(lenderCode)) {
                System.debug('lender found it: ' + a.info.Lender__c);
                lender = a;
            }
        }
        return goToQuotingTool(lender);
    }

    private PageReference goToQuotingTool(LenderQuotingWrapperDTO lender) {
        PageReference r = null;
        if (lender != null) {
            //Update Opportunity
            this.opp.Pre_Quoting_Object__c = JSON.serialize(lender);
            update this.opp;
            //r = new PageReference('/apex/' + lender.info.Quoting_Calculation_Page__c);
            r = Page.OppApplication;
            if (lender != null && lender.info != null) {
                if ('ACON'.equals(lender.info.Code__c)) {
                    r = Page.EsandaCalculator;
                } else if ('ACOM'.equals(lender.info.Code__c)) {
                    r = Page.EsandaCommercial;
                } else if ('AOTH'.equals(lender.info.Code__c)) {
                    r = Page.EsandaOthers;
                } else if ('MCON'.equals(lender.info.Code__c)) {
                    r = Page.MacquarieConsumer;
                } else if ('MCOM'.equals(lender.info.Code__c)) {
                    r = Page.MacquarieCommercial;
                } else if ('PEMV'.equals(lender.info.Code__c)) {
                    r = Page.PepperCalculatorMV;
                } else if ('PELE'.equals(lender.info.Code__c)) {
                    r = Page.PepperCalculatorLeisure;
                } else if ('PESE'.equals(lender.info.Code__c)) {
                    r = Page.PepperCalculatorSeasonal;
                } else if ('PESU'.equals(lender.info.Code__c)) {
                    r = Page.PepperSummer;
                } else if ('LIDR'.equals(lender.info.Code__c)) {
                    r = Page.LibertyDrive;
                } else if ('LIOP'.equals(lender.info.Code__c)) {
                    r = Page.LibertyOptions;
                } else if ('FION'.equals(lender.info.Code__c)) {
                    r = Page.FinanceOne;
                } else if ('MON3'.equals(lender.info.Code__c)) {
                    r = Page.Money3Calculator;
                } else if ('YMAR'.equals(lender.info.Code__c)) {
                    r = Page.YamahaMarineCalculator;
                } else if ('YMOT'.equals(lender.info.Code__c)) {
                    r = Page.YamahaMarineCalculator;
                } else if ('YWAT'.equals(lender.info.Code__c)) {
                    r = Page.YamahaMarineCalculator;
                } else if ('METR'.equals(lender.info.Code__c)) {
                    r = Page.MetroCalculator;
                } else if ('LATI'.equals(lender.info.Code__c)) {
                    r = Page.LatitudeCalculator;
                } else if ('AFSC'.equals(lender.info.Code__c)) {
                    r = Page.AfsCalculator;
                } else if ('AFSM'.equals(lender.info.Code__c)) {
                    r = Page.AfsCommercialCalculator;
                } else if ('GNL'.equals(lender.info.Code__c)) {
                    r = Page.GeneralCalculator;
                } else if ('FMAC'.equals(lender.info.Code__c)) {
                    r = Page.FirstmacCalculator;
                } else if ('RSET'.equals(lender.info.Code__c)) {
                    r = Page.RateSetterCalculator;
                }else if ('GRLI'.equals(lender.info.Code__c)){
                     r = Page.GreenLightCalculator;
                }
            }
            r.getParameters().put('id', this.opp.Id);
            r.getParameters().put('preloadQuting', '1');
            r.getParameters().put('LENDER_QUOTING', lender.info.lender__c);
        }
        return r;    
    }

    //Inner classes
    public class FilterParams {
        public String assetDetail {set;get;}
        public String employmentType {set;get;}
        public String loanType {set;get;}
        public String purchaseType {set;get;}
        public String termEnd {set;get;}
        public String creditHistory {set;get;}

        public String ageCar {set;get;} 
        public Integer loanTerm {set;get;} 
        public String residentialStatus {set;get;} 
        public Decimal price {set;get;}
        public Decimal deposit {set;get;}

        public Set<String> lenderList {set;get;}

        public String sortBy {set;get;}
        public Boolean recalculating {set;get;}
        public Decimal targetCommission {set;get;}
        public Decimal estimateCommission {set;get;}
        public Decimal dofValue {set;get;}
        //Brokerage %
        public Decimal rateValue {set;get;}
        // Lelo                 2018-05-29
        public String hasPayday {set;get;}
        public String hasVerifiableCredit {set;get;}
        public Integer jobsLast3Years {set;get;}
        public String hasEnquiries {set;get;}
        public String creditScore {set;get;}
        public String verifiableSavings {set;get;}
        public Decimal residual {set;get;}
        public String ltv {set;get;}
        // Lelo                 2018-05-29
        public Integer applicantAge {set;get;}
        public Decimal annualIncome {set;get;}
        public String tier {set;get;}
        public String riskGrade {set; get;}
        public String customerProfile {set; get;}
        
        public FilterParams() {
            //Temp
            this.assetDetail = 'Car';
            this.employmentType = 'Full-Time';
            this.loanType = 'Consumer Loan';
            this.purchaseType = 'Dealer';
            this.creditHistory = 'Clean History';
            this.residentialStatus = 'Property Owner';
            //this.price = 35000.0;
            //
            this.ageCar  = '0';
            this.loanTerm = 60;
            this.deposit = 0;
            this.residual = 0;
            this.lenderList = new Set<String>();
            this.sortBy = LenderQuotingWrapperDTO.ORD_BASE_RATE;
            this.recalculating = false;
            //this.targetCommission = 0;
            this.rateValue = 0.0;

            this.ltv = '90-99';
            this.creditScore = '750+';
            this.jobsLast3Years = 0;
        }

        public String getPrivateSales() {
            String r = 'N';
            if ('Private'.equals(purchaseType)) {
                r = 'Y';
            }
            return r;
        }

        public void reset() {
            lenderList = new Set<String>();
            recalculating = false;
        }

        public String getLtvVal() {
            String r = '90';
            if ('<90'.equals(this.ltv)) {
                r = '89';
            } else if ('90-99'.equals(this.ltv)) {
                r = '90';
            } else if ('100–109'.equals(this.ltv)) {
                r = '100';
            } else if ('110–119'.equals(this.ltv)) {
                r = '110';
            } else if ('120–129'.equals(this.ltv)) {
                r = '120';
            } else if ('130'.equals(this.ltv)) {
                r = this.ltv;
            } else if ('131+'.equals(this.ltv)) {
                r = '131';
            }
            return r;
        }

        public Decimal getNetVehiclePrice() {
            Decimal r = 0.0;
            if (this.price != null) {
                r = this.price;
            }
            if (this.deposit != null) {
                r -= this.deposit;
            }
            return r;
        }
    }

    public static void calculateBaseRate(LenderQuotingWrapperDTO lender, FilterParams param, Lender_Comparative_Data__c filter) {
        if (lender == null || param == null) {
            return;
        }
        //Geric values
        lender.carPrice = param.price;
        lender.deposit = param.deposit;

        //System.debug('Calculating base rate for ' + lender.info.lender__c);
        if ('ACON'.equals(lender.info.Code__c)) {
            //ANZ Consumer
            calculateBaseRateEsandaConsumer(lender, param);
        } else if ('ACOM'.equals(lender.info.Code__c)) {
            //ANZ Commercial
            calculateBaseRateEsandaCommercial(lender, param);
        } else if ('AOTH'.equals(lender.info.Code__c)) {
            //ANZ Others
            calculateBaseRateEsandaOthers(lender, param);
        } else if ('MCON'.equals(lender.info.Code__c)) {
            //Macquarie Consumer
            calculateBaseRateMacuaqurieConsumer(lender, param);
        } else if ('MCOM'.equals(lender.info.Code__c)) {
            //Macquarie Commercial
            calculateBaseRateMacuaqurieCommercial(lender, param);
        } else if ('PEMV'.equals(lender.info.Code__c)) {
            //Pepper MV
            calculateBaseRatePepperMV(lender, param);
        } else if ('PELE'.equals(lender.info.Code__c)) {
            //Pepper Leisure
            calculateBaseRatePepperLeisure(lender, param);
        } else if ('PESE'.equals(lender.info.Code__c)) {
            //Pepper Seasonal
            calculateBaseRatePepperSeasonal(lender, param);
        } else if ('PESU'.equals(lender.info.Code__c)) {
            //Pepper Summer
            calculateBaseRatePepperSummer(lender, param);
        } else if ('SGMV'.equals(lender.info.Code__c)) {
            //St George MV
            calculateBaseRateStGeorgeMV(lender, param, filter);
        } else if ('SGLE'.equals(lender.info.Code__c)) {
            //St George Leisure
            calculateBaseRateStGeorgeLeisure(lender, param, filter);
        } else if ('LIDR'.equals(lender.info.Code__c)) {
            //Liberty Drive
            calculateBaseRateLibertyDrive(lender, param);
        } else if ('LIOP'.equals(lender.info.Code__c)) {
            //Liberty Options
            calculateBaseRateLibertyOptions(lender, param);
        } else if ('FION'.equals(lender.info.Code__c)) {
            //Finance One
            calculateBaseRateFinanceOne(lender, param);
        } else if ('METR'.equals(lender.info.Code__c)) {
            //Metro
            calculateBaseRateMetro(lender, param);
        } else if ('YMAR'.equals(lender.info.Code__c)) {
            //Yamaha Marine
            calculateBaseRateYamahaMarine(lender, param);
        } else if ('YMOT'.equals(lender.info.Code__c)) {
            //Yamaha Motorcycle
            //calculateBaseRateYamahaMotorcycle(lender, param, filter);
            calculateBaseRateYamahaMarine(lender, param);
        } else if ('YWAT'.equals(lender.info.Code__c)) {
            //Yamaha Water
            //calculateBaseRateYamahaWater(lender, param);
            calculateBaseRateYamahaMarine(lender, param);
        } else if ('LATI'.equals(lender.info.Code__c)) {
            //Latitude
            calculateBaseRateLatitude(lender, param);
        } else if ('MON3'.equals(lender.info.Code__c)) {
            //Money3
            calculateMoney3BaseRate(lender, param);
        } else if ('RSET'.equals(lender.info.Code__c)) {
            //RateSetter
            calculateRateSetterBaseRate(lender, param);
        } else if ('FMAC'.equals(lender.info.Code__c)) {
            //Firstmac
            calculateFirstmacBaseRate(lender, param);
        } else if ('AFSC'.equals(lender.info.Code__c)) {
            //AFS Consumer
            calculateAFSConsumerBaseRate(lender, param);
        } else if ('AFSM'.equals(lender.info.Code__c)) {
            //AFS Commercial
            calculateAFSCommercialBaseRate(lender, param);
        } else if (GreenLightCalculatorExtension.LENDER_QUOTING.equals(lender.info.Lender__c)) {
            //Green Light
            calculateBaseRateGreenLight(lender, param);
        } else if (LatitudePersonalCalculatorExtension.LENDER_QUOTING.equals(lender.info.Lender__c)) {
            //Latitude Personal Loan
            calculateBaseRateLatitudePL(lender, param);
        } else if (WisrCalculatorExtension.LENDER_QUOTING.equals(lender.info.Lender__c)) {
            //wISR
            calculateBaseRateWisr(lender, param);
        } else if (RatesetterPLExtension.LENDER_QUOTING.equals(lender.info.Lender__c)) {
            //RateSetter PL
            calculateRateSetterPLBaseRate(lender, param);
        } else if (NowFinanceCalculatorExtension.LENDER_QUOTING.equals(lender.info.Lender__c)) {
            //Now Finance
            calculateBaseRateNowFinance(lender, param);
        }   
    }

    private static void calculateBaseRateEsandaConsumer(LenderQuotingWrapperDTO lender, FilterParams param) {

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        
        cp.ltv = param.getLtvVal();
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.customerProfile = 'Property Owner - New Car';
        cp.adverseCredit = 'N';

        Integer age = Integer.valueOf(param.ageCar);
        if (age == 0 || age == 1) {
            if ('Property Owner'.equals(param.residentialStatus)) {
                cp.customerProfile = 'Property Owner - New Car';
            } else {
                cp.customerProfile = 'Non Property Owner - New Car';
            }
            cp.condition = 'New';
        } else {
            if ('Property Owner'.equals(param.residentialStatus)) {
                cp.customerProfile = 'Property Owner - Old Car';
            } else {
                cp.customerProfile = 'Non Property Owner - Old Car';
            }
            cp.condition = 'Used';
        }

        if (!'Clean History'.equals(param.creditHistory)) {
            cp.adverseCredit = 'Y';
        }

        if ('Truck'.equals(param.assetDetail) ||
            'Boat'.equals(param.assetDetail) ||
            'Caravan'.equals(param.assetDetail)) {
            cp.ltv = 'OG1';
        } else if('Motorbike'.equals(param.assetDetail) ||
            'Jet Ski'.equals(param.assetDetail)) {
            cp.ltv = 'OG2';
        }

        //General details
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.totalInsurance = 0;
        cp.totalInsuranceIncome = 0;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        // System.debug('cp.baseRate >> ' + cp.baseRate);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arrears';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.docFees = lender.info.DOC_Fees__c;
        cp.residualValue = param.residual;
        

        cp.goodsType = param.assetDetail;

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = Integer.valueOf(cp.term);
        lender.customerProfile = cp.customerProfile;
        lender.adverseCredit = cp.adverseCredit;
        lender.ltv = cp.ltv;
        lender.productGoodsType = param.assetDetail;
        lender.carAge = age;
        lender.condition = cp.condition;

        
        //System.debug(lender.info.Lender__c + ' Weekly Payment >> ' + r.Weekly_Payment__c);
        //System.debug(lender.info.Lender__c + ' Total Commission >> ' + r.Total_Commission__c);
        //System.debug(lender.info.Lender__c + ' Base Rate >> ' + cp.baseRate);
        //System.debug(lender.info.Lender__c + ' Client Rate >> ' + cp.clientRate);

        //lender.productLoanType = filter.Loan_Type__c;

    }

    private static void calculateBaseRateEsandaCommercial(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);

        cp.ltv = param.getLtvVal();
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.customerProfile = 'Property Owner - New Car';
        cp.adverseCredit = 'N';

        Integer age = Integer.valueOf(param.ageCar);
        if (age == 0 || age == 1) {
            if ('Property Owner'.equals(param.residentialStatus)) {
                cp.customerProfile = 'Property Owner - New Car';
            } else {
                cp.customerProfile = 'Non Property Owner - New Car';
            }
        } else {
            if ('Property Owner'.equals(param.residentialStatus)) {
                cp.customerProfile = 'Property Owner - Old Car';
            } else {
                cp.customerProfile = 'Non Property Owner - Old Car';
            }
        }

        if (!'Clean History'.equals(param.creditHistory)) {
            cp.adverseCredit = 'Y';
        }

        if ('Motorbike'.equals(param.assetDetail) ||
            'Boat'.equals(param.assetDetail) ||
            'Caravan'.equals(param.assetDetail)) {
            cp.ltv = 'OG';
        }

        //General details
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.totalInsurance = 0;
        cp.totalInsuranceIncome = 0;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.docFees = lender.info.DOC_Fees__c;
        cp.residualValue = param.residual;

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = Integer.valueOf(cp.term);
        lender.customerProfile = cp.customerProfile;
        lender.adverseCredit = cp.adverseCredit;
        lender.ltv = cp.ltv;
        lender.productGoodsType = param.assetDetail;
        
        //System.debug(lender.info.Lender__c + ' Weekly Payment >> ' + r.Weekly_Payment__c);
        //System.debug(lender.info.Lender__c + ' Total Commission >> ' + r.Total_Commission__c);
        //System.debug(lender.info.Lender__c + ' Base Rate >> ' + cp.baseRate);
        //System.debug(lender.info.Lender__c + ' Client Rate >> ' + cp.clientRate);


    }

    private static void calculateBaseRateEsandaOthers(LenderQuotingWrapperDTO lender, FilterParams param) {

        Integer age = Integer.valueOf(param.ageCar);
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);

        Decimal appFeeVal = lender.info.Application_Fee__c;
        //Loan Facility Type
        if ('Consumer Loan'.equals(param.loanType)) {
            lender.customerProfile = 'UCCC Loan';
            cp.monthlyFee = lender.info.Monthly_Fee__c;
        } else {
            lender.customerProfile = 'Commercial';
            cp.monthlyFee = 0;
        }

        if ('Truck'.equals(param.assetDetail)) {
            cp.goodsType = 'chattel';      
            appFeeVal = lender.info.Application_Fee_Private__c;
            if (age >= 0 && age <= 3) {
                cp.vehiclesProfile = 'New_3_years_old__c';            
            } else if (age >= 4 && age <= 8) {
                cp.vehiclesProfile = 'X4_8_years_old__c';            
            } else {
                cp.vehiclesProfile = 'Over_8_years_old__c';            
            }
        } else if (('Boat'.equals(param.assetDetail)) ||
                   ('Caravan'.equals(param.assetDetail)) ||
                   ('Motorbike'.equals(param.assetDetail))) {
            cp.goodsType = 'leisure';
            if (age >= 0 && age <= 1) {
                cp.vehiclesProfile = 'New_1_year_old__c';            
            } else if (age >= 2 && age <= 5) {
                cp.vehiclesProfile = 'X2_5_years_old__c';            
            } else {
                cp.vehiclesProfile = 'Over_5_years_old__c';            
            }
        } else {
            cp.goodsType = 'chattel';
            cp.vehiclesProfile = 'Over_8_years_old__c';
        }


        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.totalInsurance = 0;
        cp.totalInsuranceIncome = 0;
        
        if (!param.recalculating) {
            lender.brokerageBase = lender.info.Brokerage_Base__c;
        }
        cp.brokeragePer = lender.brokerageBase;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        
        cp.amountBaseComm = cp.getNaf(); 
        cp.amountBasePmt = cp.getNaf() + (cp.getNaf() * cp.brokeragePer / 100 * 0.9319);
        cp.paymentType = 'Arreas';
        cp.residualValue = param.residual;
        cp.clientRate = QuotingCalculation.getClientRateCalculation(cp);
        cp.docFees = lender.info.DOC_Fees__c;
        
        // System.debug('cp.baseRate >> ' + cp.baseRate + ' | cp.clientRate >> ' + cp.clientRate);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = Integer.valueOf(cp.term);
        lender.vehiclesProfile = cp.vehiclesProfile;
        lender.productGoodsSubType = cp.goodsType;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.loanType;
               
        // System.debug('ANZ Others Base Rate >> ' + cp.baseRate + '|' + cp.clientRate);

        

    }

    private static void calculateBaseRateMacuaqurieConsumer(LenderQuotingWrapperDTO lender, FilterParams param) {
	
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        
        cp.privateSales = param.getPrivateSales();
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.customerProfile = 'N';
        if ('Property Owner'.equals(param.residentialStatus)) {
            cp.customerProfile = 'Y';
        }

        cp.goodsType = 'MOTOV';
        cp.goodsSubType = 'MOTOV_CARS_-_OTHER_CARS_AU';
        if ('Motorbike'.equals(param.assetDetail)) {
            cp.goodsType = 'LIFES';
            cp.goodsSubType = 'LIFES_MOTORCYCLES_&_SCOOTERS_AU';
        } else if ('Caravan'.equals(param.assetDetail)) {
            cp.goodsType = 'LIFES';
            cp.goodsSubType = 'LIFES_CARAVANS_&_CAMPERVANS_AU';
        }
	
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        //cp.carAge = Integer.valueOf(param.ageCar);
        cp.vehicleYear = String.valueOf(Date.today().year() - Integer.valueOf(param.ageCar));
        cp.assetType = param.assetDetail;
        cp.ltv = param.getLtvVal(); 
        if (!param.recalculating) {
            lender.brokerageBase = lender.info.Brokerage_Base__c;
        }
        cp.brokeragePer = lender.brokerageBase;

        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.amountBaseComm = cp.getNaf(); 
        cp.amountBasePmt = cp.getNaf() + ((param.price - param.deposit) * cp.brokeragePer / 100);
        cp.paymentType = 'Arreas';
        cp.residualValue = param.residual;
        cp.clientRate = QuotingCalculation.getClientRateCalculation(cp);
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.term = Integer.valueOf(cp.term);
        lender.productGoodsType = cp.goodsType;
        lender.productGoodsSubType = cp.goodsSubType;
        lender.productLoanType = param.loanType;
        lender.vehicleYear = cp.vehicleYear;
        lender.privateSales = cp.privateSales;
        lender.customerProfile = cp.customerProfile;
        lender.ltv = cp.ltv;
        
        //System.debug('Sending Quoting tool >> ' + JSON.serialize(lender));
    }

    private static void calculateBaseRateMacuaqurieCommercial(LenderQuotingWrapperDTO lender, FilterParams param) {

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        
        cp.privateSales = param.getPrivateSales();
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.carAge = Integer.valueOf(param.ageCar);
        if (!param.recalculating) {
            lender.brokerageBase = lender.info.Brokerage_Base__c;
        }
        cp.brokeragePer = lender.brokerageBase;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.amountBaseComm = cp.getNaf(); 
        cp.amountBasePmt = cp.getNaf() + ((param.price - param.deposit) * cp.brokeragePer / 100);
        cp.paymentType = 'Arrears';
        cp.residualValue = param.residual;
        cp.clientRate = QuotingCalculation.getClientRateCalculation(cp);
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
            
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.term = Integer.valueOf(cp.term);
        lender.carAge = cp.carAge;
        lender.privateSales = cp.privateSales;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        
    }    

    private static void calculateBaseRatePepperMV(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.privateSales = param.getPrivateSales();
        cp.clientTier = 'A';
        cp.customerProfile = 'MV';
        cp.productLoanType = 'Consumer Loan';
        
        if ('Full-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Full-Doc';
        } else if ('Low-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Low-Doc';
        }
        cp.carAge = Integer.valueOf(param.ageCar);
        if ('Car'.equals(param.assetDetail)) {
            if ('Property Owner'.equals(param.residentialStatus) || 
                '50k-100K'.equals(param.verifiableSavings) ||
                '100K+'.equals(param.verifiableSavings)) {
                cp.clientTier = 'A';
            } else {
                cp.clientTier = 'B';
            }
            if (param.employmentType.contains('Casual') ||
                param.creditHistory.contains('Default')) {
                cp.clientTier = 'C';
            }
        }else if('Caravan'.equals(param.assetDetail)){
        	cp.customerProfile = 'CARAVAN';
        }
        if (cp.carAge == 0) {
            cp.vehicleYear = 'New';
        } else if (cp.carAge <= 5) {
            cp.vehicleYear = 'Used 0-5 years';
        } else if (cp.carAge <= 9) {
            cp.vehicleYear = 'Used 6-9 years';
        } else {
            cp.vehicleYear = 'Used 10+ years';
        }
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        //if (cp.baseRate > 0) cp.baseRate -= 2;
        //lender.maxClientRate = QuotingCalculation.getMaximunBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        cp.commRate = QuotingCalculation.getPepperMVCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;        
        lender.term = Integer.valueOf(cp.term);
        lender.privateSales = cp.privateSales;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = cp.productLoanType;
        lender.purchaseType = param.purchaseType;
        lender.vehicleYear = cp.vehicleYear;
        lender.appFeeVal = appFeeVal;
    } 

    private static void calculateBaseRatePepperLeisure(LenderQuotingWrapperDTO lender, FilterParams param) {

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);        
        cp.privateSales = param.getPrivateSales();
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.customerProfile = 'LEISURE';
        cp.productLoanType = 'Consumer Loan';
        if ('Full-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Full-Doc';
        } else if ('Low-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Low-Doc';
        }
        cp.clientTier = 'A';
        if ('Property Owner'.equals(param.residentialStatus) ||
            '50k-100K'.equals(param.verifiableSavings) ||
            '100K+'.equals(param.verifiableSavings)) {
            cp.clientTier = 'A';
        } else {
            cp.clientTier = 'B';
        }
        
        if (param.employmentType.contains('Casual') ||
            param.employmentType.contains('Default')  ||
            '20 Years'.equals(param.termEnd)) {
            cp.clientTier = 'C';
        }
        if (cp.carAge == 0) {
            cp.vehicleYear = 'New';
        } else if (cp.carAge <= 5) {
            cp.vehicleYear = 'Used 0-5 years';
        } else if (cp.carAge <= 9) {
            cp.vehicleYear = 'Used 6-9 years';
        } else {
            cp.vehicleYear = 'Used 10+ years';
        }
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        //if (cp.baseRate > 0) cp.baseRate -= 2;
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        cp.commRate = QuotingCalculation.getPepperLeisureCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.privateSales = cp.privateSales;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.loanType;
        lender.vehicleYear = cp.vehicleYear;
    } 

    // Pepper 5Oh
    private static void calculateBaseRatePepperSeasonal(LenderQuotingWrapperDTO lender, FilterParams param) {

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        
        cp.privateSales = param.getPrivateSales();
        cp.carAge = Integer.valueOf(param.ageCar);

        if ('Car'.equals(param.assetDetail) && cp.carAge <= 5) {
            if ('Property Owner'.equals(param.residentialStatus) ||
                '50k-100K'.equals(param.verifiableSavings) ||
                '100K+'.equals(param.verifiableSavings)) {
                cp.clientTier = 'A';
            } else {
                cp.clientTier = 'B';
            }
        }
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }

        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        // System.debug(cp.dof + '|' + lender.dofBase + '|' + lender.info.DOF__c + '|' + param.recalculating);
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        
        
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        cp.commRate = QuotingCalculation.getPepper50hCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.privateSales = cp.privateSales;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        

    } 

    private static void calculateBaseRatePepperSummer(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        String productGoodsType = 'Marine';
        if ('Caravan'.equals(param.assetDetail)) {
            productGoodsType = param.assetDetail;
        }

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.clientTier = 'A';
        cp.privateSales = param.getPrivateSales();
        cp.carAge = Integer.valueOf(param.ageCar);

        if ('Car'.equals(param.assetDetail) && cp.carAge <= 5) {
            if ('Property Owner'.equals(param.residentialStatus)) {
                cp.clientTier = 'A';
            } else {
                cp.clientTier = 'B';
            }
        }
        Decimal appFeeVal = lender.info.Application_Fee__c;
        if ('Y'.equals(cp.privateSales)) {
            appFeeVal = lender.info.Application_Fee_Private__c;
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + appFeeVal + cp.dof + lender.info.PPSR__c;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        cp.commRate = QuotingCalculation.getPepperSummerCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.term = param.loanTerm;
        lender.privateSales = cp.privateSales;
        lender.productGoodsType = productGoodsType;
        lender.productLoanType = param.loanType;
        
    }

    private static void calculateBaseRateStGeorgeMV(LenderQuotingWrapperDTO lender, FilterParams param, Lender_Comparative_Data__c filter) {
        
        /*String loanType = 'Consumer';
        String carType = 'New Cars';
        Integer carAge = Integer.valueOf(param.ageCar);
        Integer term = param.loanTerm;
        Decimal originalRate = 0;
        Decimal baseRate = 0;

        if (carAge > 0 && carAge <= 3) {
            carType = 'Used Cars to 3 years';
        } else if (carAge > 3 && carAge <= 5) {
            carType = 'Used Cars 4-5 years';
        } else if (carAge > 5) {
            carType = 'Used Cars 6+ years';
        }


        if (carType == 'New Cars') {
            originalRate = 6.18;
        } else if (carType == 'Used Cars to 3 years') {
            originalRate = 6.68;
        } else if (carType == 'Used Cars 4-5 years') {
            originalRate = 7.73;
        } else if (carType == 'Used Cars 6+ years') {
            originalRate = 8.18;
        } else {
            originalRate = 0.00;
        } // end if for carType ==
        if (loanType == 'Consumer') {
            if (term > 60 && term <= 84) {
                baseRate = originalRate + 1.00;
            } else if (term <= 60) {
                baseRate = originalRate;
            } else {
                baseRate = 0.00;
            } // end if for term
        } else if (loanType == 'Commercial') {
            baseRate = originalRate;
        } else {
            baseRate = 0.00;
        } // end if for loanType ==

        //Result
        lender.baseRate = baseRate;
        lender.term = term;
        lender.loanType = loanType;
        lender.carType = carType;
        lender.productGoodsType = filter.Asset_Detail__c;
        lender.productLoanType = filter.Loan_Type__c;*/
    } 

    private static void calculateBaseRateStGeorgeLeisure(LenderQuotingWrapperDTO lender, FilterParams param, Lender_Comparative_Data__c filter) {
        /*String loanType = 'Consumer';
        String carType = 'New Leisure';
        Integer carAge = Integer.valueOf(param.ageCar);
        Integer term = param.loanTerm;
        Decimal originalRate = 0;
        Decimal baseRate = 0;

        if (carAge > 0 && carAge <= 3) {
            carType = 'Used Leisure to 3 years';
        } else if (carAge > 3 && carAge <= 5) {
            carType = 'Used Leisure 4-5 years';
        } else if (carAge > 5) {
            carType = 'Used Leisure 6+ years';
        }

        if (carType == 'New Leisure') {
            originalRate = 7.68;
        } else if (carType == 'Used Leisure to 3 years') {
            originalRate = 8.18;
        } else if (carType == 'Used Leisure 4-5 years') {
            originalRate = 9.38;
        } else if (carType == 'Used Leisure 6+ years') {
            originalRate = 11.18;
        } else {
            originalRate = 0.00;
        } // end if for carType ==
        if (loanType == 'Consumer') {
            if (term > 60 && term <= 84) {
                baseRate = originalRate + 1.00;
            } else if (term <= 60) {
                baseRate = originalRate;
            } else {
                baseRate = 0.00;
            } // end if for term
        } else if (loanType == 'Commercial') {
            baseRate = originalRate;
        } else {
            baseRate = 0.00;
        } // end if for loanType ==

        //Result
        lender.baseRate = baseRate;
        lender.term = term;
        lender.loanType = loanType;
        lender.carType = carType;
        lender.productGoodsType = filter.Asset_Detail__c;
        lender.productLoanType = filter.Loan_Type__c;*/
    } 

    private static void calculateBaseRateLibertyDrive(LenderQuotingWrapperDTO lender, FilterParams param) {

        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.ltv = param.getLtvVal();
        cp.loanTypeDetail = 'Consumer';

        if (param.loanType.contains('Chattel Mortgage')) {
            cp.loanTypeDetail = 'Commercial Star';
            
        }
        // Loan Product
        cp.productLoanType = 'Consumer Loan';
        cp.loanTypeDetail = null;
        if ('Full-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Full-Doc';
            cp.loanTypeDetail = 'Star';
        } else if ('Low-Doc Chattel Mortgage'.equals(param.loanType)) {
            cp.productLoanType = 'Chattel Mortgage-Low-Doc';
            cp.loanTypeDetail = 'Star';
        }
        // Risk Grade
        if ('Property Owner'.equals(param.residentialStatus)) {
        	cp.clientTier = 'AAA';
        } else if('Renting Real Estate'.equals(param.residentialStatus)){
            cp.clientTier = 'AA'; 
        } else if('Renting Other'.equals(param.residentialStatus)){
            cp.clientTier = 'A';
        }else{
            cp.clientTier = 'C';
        }

        if (!'Clean History'.equals(param.creditHistory)) {
            cp.clientTier = 'C';
        }
        // Vehicle Age
        if(cp.carAge == 0){
            cp.vehicleYear = 'New';
        }else if (cp.carAge > 0 && cp.carAge <= 4) {
            cp.vehicleYear = '0-4 years';
        } else if (cp.carAge > 4 && cp.carAge <= 9) {
            cp.vehicleYear = '5-9 years';
        } else {
            cp.vehicleYear = '10+ years';
        }

        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.residualValue = param.residual;

        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        // System.debug('L baseRate: ' + cp.baseRate);
        // System.debug('L recalculating: ' + param.recalculating);
        // System.debug('L lender clientRate: ' + lender.clientRate);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            // System.debug('L maxBaseRate: ' + maxBaseRate);
            // System.debug('L.clientRate: ' + cp.clientRate);    
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        // System.debug('L clientRate: ' + cp.clientRate);
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.commRate = lender.info.Commission_Rate__c;
        
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.vehicleYear = cp.vehicleYear;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = cp.productLoanType;
        lender.additionalInfo = cp.clientTier;
        lender.residual = cp.residualValue;
        if (String.isNotBlank(cp.loanTypeDetail)) {
            lender.additionalInfo += ' (' + cp.loanTypeDetail + ')';
        }
    } 

    private static void calculateBaseRateLibertyOptions(LenderQuotingWrapperDTO lender, FilterParams param) {

        //String additionalInfo = '(Options A, B & C)';
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.loanTypeDetail = 'Consumer';
        if (param.loanType.contains('Chattel Mortgage')) {
            cp.loanTypeDetail = 'Commercial Star';
        }
        cp.commRate = lender.info.Commission_Rate__c;
        if ('Property Owner'.equals(param.residentialStatus) || 'Renting Real Estate'.equals(param.residentialStatus) ||
            'Y'.equals(param.hasVerifiableCredit)) {
            cp.clientTier = 'AA';
            //additionalInfo = '(Option AA)';
            cp.commRate += 0.35;
        } else {
            cp.clientTier = 'A';
        }
        if (!'Clean History'.equals(param.creditHistory)) {
            cp.clientTier = 'C';
        }
        cp.carAge = Integer.valueOf(param.ageCar);
        
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        //Calc Risk fee
        cp.riskFeeBase = cp.totalAmount;
        cp.totalAmount = cp.totalAmount + QuotingCalculation.getLibertyOptionRiskFee(cp);
        //*****************************************************************
        cp.residualValue = param.residual;

        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            // system.debug('Lib Opt: ' + maxBaseRate + '|' + JSON.serialize(cp));
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.carAge = cp.carAge;
        lender.rateOption = cp.clientTier;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.loanTypeDetail + ' ' + cp.clientTier;

    } 

    private static void calculateBaseRateFinanceOne(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.loanTypeDetail = 'Gold';
        cp.productLoanType = 'Consumer Loan';
        if (param.employmentType.contains('Self employed') && param.loanType.contains('Chattel Mortgage')) {
            cp.productLoanType = param.loanType;
            cp.loanTypeDetail = 'Business Xpress';
        }
        cp.totalAmount = param.price - param.deposit;
        cp.dof = QuotingCalculation.getFinanceOneDofCalc(cp);
        if (param.recalculating) {
            if (lender.dofBase > cp.dof) {
                lender.dofBase = cp.dof;    
            } else {
                cp.dof = lender.dofBase;
            }
        } else {
            lender.dofBase = cp.dof;
        }
        //cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        // cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + lender.info.PPSR__c; // DOF removed
        cp.nafCommission = param.price - param.deposit;
        cp.totalAmount += QuotingCalculation.getFinanceOneRiskFeeCalc(cp);
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = param.residual;
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.loanTypeDetail;

    }


    private static void calculateBaseRateMetro(LenderQuotingWrapperDTO lender, FilterParams param) {
        //System.debug('-----------------------------------------------------');
        //System.debug(lender.info.Lender__c + ' calculating...');
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        Application_Quoting_Result__c r = null;

        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.loanTypeDetail = 'Passenger and Commercial Vehicles';
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.paymentType = 'Arreas';
        cp.privateSales = param.getPrivateSales();
        cp.saleBacksPurchased = 'N';
        if (!param.recalculating) {
            lender.brokerageBase = lender.info.Brokerage_Base__c;
        }
        cp.brokeragePer = lender.brokerageBase;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);

        cp.amountBaseComm = cp.getNaf(); 
        cp.amountBasePmt = cp.getNaf() + (cp.getNaf() * cp.brokeragePer / 100 * 1.025);
        cp.residualValue = param.residual;
        // System.debug(cp.getNaf() + '|' + cp.amountBasePmt + '|' + cp.brokeragePer + '|' + cp.baseRate + '|' + cp.term);
        try {
            cp.clientRate = QuotingCalculation.getClientRateCalculation(cp);
            
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.carAge = cp.carAge;
        lender.privateSales = cp.privateSales;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.loanTypeDetail;
    }

    private static void calculateBaseRateYamahaMarine(LenderQuotingWrapperDTO lender, FilterParams param) {
        // System.debug('-----------------------------------------------------');
        System.debug(lender.info.Lender__c + ' calculating...');
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + lender.info.PPSR__c;
        String loanType = 'Comercial';
        if('Consumer Loan'.equals(param.loanType)){
            loanType = 'Consumer';
        }
        cp.dof = QuotingCalculation.getYamahaDOfCalculation(cp.totalAmount, loanType);

        if (param.recalculating) {
            if (lender.dofBase > cp.dof) {
                lender.dofBase = cp.dof;    
            } else {
                cp.dof = lender.dofBase;
            }
        } else {
            lender.dofBase = cp.dof;
        }
        cp.totalAmount += cp.dof;
        cp.loanTypeDetail = 'Prime Plus';
        cp.customerProfile = 'New';
        if (!'0'.equals(param.ageCar)) {
            cp.customerProfile = 'Used';
        }
        lender.additionalInfo = cp.loanTypeDetail;
        //if (lender.info.Lender__c.contains('Marine') && cp.getNaf() > 35000) {
        //    lender.additionalInfo += ' BMT';
        //}
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.maxRate = QuotingCalculation.getMaximunBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = cp.maxRate;
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.paymentType = 'Arreas';
        cp.residualValue = param.residual;
        cp.loanTypeDetail = loanType;
        cp.commRate = QuotingCalculation.getYamahaCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }
			
        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.customerProfile = cp.customerProfile;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.loanType;
        lender.productGoodsSubType = cp.loanTypeDetail;
    }

    private static void calculateBaseRateLatitude(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.loanTypeDetail = 'Sapphire';
        //String additionalInfo = '(Sapphire, Ruby, Emerald)';
        if ('Property Owner'.equals(param.residentialStatus) && 'Clean History'.equals(param.creditHistory)) {
            cp.loanTypeDetail = 'Diamond Plus';
        }
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + lender.info.PPSR__c;
        cp.dof = cp.getNaf() * 0.15;
        if (cp.dof > lender.info.DOF__c) {
            cp.dof = lender.info.DOF__c;
        }

        if (param.recalculating) {
            if (lender.dofBase > cp.dof) {
                lender.dofBase = cp.dof;    
            } else {
                cp.dof = lender.dofBase;
            }
        } else {
            lender.dofBase = cp.dof;
        }
        // System.debug('totalAmount: ' + cp.totalAmount + '|' + cp.dof + '|recalculating: ' + param.recalculating + '|dofBase: ' + lender.dofBase);
        cp.totalAmount += cp.dof;

        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        cp.commRate = QuotingCalculation.getLatitudeRateCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = param.loanTerm;
        lender.productLoanType = cp.loanTypeDetail;
        lender.additionalInfo = cp.loanTypeDetail;
        
    }

    private static void calculateMoney3BaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        String additionalInfo = '';
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        param = LenderComparisonHelper.getMoney3RiskGrade(param);
        cp.riskGrade = param.riskGrade;
        cp.customerProfile = param.customerProfile;
        additionalInfo = cp.riskGrade;
        
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.totalAmount = LenderComparisonHelper.getMoney3LoanAmount(param);
        if(lender.dofBase != null || lender.dofBase > 0){
            cp.dof = lender.dofBase;
        }else{
        	cp.dof = QuotingCalculation.getMoney3maxDof(cp);   
        }
        cp.riskFeeBase = LenderComparisonHelper.getMoney3LoanAmount(param);
        cp.totalAmount = cp.totalAmount + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c + QuotingCalculation.getMoney3RiskFee(cp);
        cp.baseRate = QuotingCalculation.getMoney3BaseRate(cp);
        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
        } else {
            // System.Debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> lender.clientRateFactor ' + lender.clientRateFactor);
            // System.Debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cp.baseRate ' + cp.baseRate);
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = param.residual;
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.amountBaseComm = LenderComparisonHelper.getMoney3LoanAmount(param);
        cp.riskFeeBase = LenderComparisonHelper.getMoney3LoanAmount(param);
        
        Application_Quoting_Result__c r = null;
        
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }
        //Result
        lender.quotingResult = r;
        lender.dofBase = cp.dof;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.additionalInfo = additionalInfo;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.carAge = cp.carAge;
        lender.customerProfile = cp.customerProfile;
        lender.riskGrade = cp.riskGrade;
        lender.riskFeeBase = lender.info.Application_Fee__c;
        lender.riskFeeBase = QuotingCalculation.getMoney3RiskFee(cp);
    }

    //Lelo                  2017-09-27
    public void sortResult() {
        System.debug('Sorting by ' + param.sortBy);
        if (lendersList != null && !lendersList.isEmpty()) {
            for (LenderQuotingWrapperDTO a : lendersList) {
                a.sortBy = param.sortBy;
            }
            lendersList.sort();
        }
    }

    public void recalculate() {
        recalculateResults(false);
        //if (lendersList != null && !lendersList.isEmpty()) {
        //    param.recalculating = true;
        //    for (LenderQuotingWrapperDTO a : lendersList) {
        //        if (a.hasClientRate && (a.clientRate == null || a.clientRate < a.baseRate)) {
        //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
        //                a.info.lender__c + ': Client Rate [' + a.clientRate + '%] should be equal or greates that Base Rate [' + a.baseRate + '%]'));
        //            a.clientRate = a.baseRate;
        //        }
        //        LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
        //    }
        //    lendersList.sort();
        //}
    }

    private void recalculateResults(Boolean resetart) {
        if (lendersList != null && !lendersList.isEmpty()) {
            param.recalculating = !resetart;
            for (LenderQuotingWrapperDTO a : lendersList) {
                if (!resetart && (a.hasClientRate && (a.clientRate == null || a.clientRate < a.baseRate))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                        a.info.lender__c + ': Client Rate [' + a.clientRate + '%] should be equal or greates that Base Rate [' + a.baseRate + '%]'));
                    a.clientRate = a.baseRate;
                }
                if (a.hasBrokerage && a.brokerageBase > a.info.Max_Brokerage__c) {
                    a.brokerageBase = a.info.Max_Brokerage__c;
                }
                LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
            }
            lendersList.sort();
        }   
    }

    private void calculateUsingCommissions(Decimal targetcommission, String commissionType ) {
        if (lendersList != null && !lendersList.isEmpty()) {
            //recalculateResults(true);
            adjustClientRate(0.0);
            param.recalculating = true;
            //Decimal clientRateIncrement = 0.1;
            //Decimal brokerageIncrement = 0.1;
            Integer limitStop = 150;
            Decimal tcomm = 0.0;
            if (targetcommission != null) {
                tcomm = targetcommission;
            }
            
            for (LenderQuotingWrapperDTO a : lendersList) {
                Integer i = 1;
                System.debug(a.info.lender__c + ' Target commission... Client rate: ' + a.clientRate + '|' + a.brokerageBase);
                if (a.quotingResult != null && !'Money3'.equals(a.info.lender__c)) {
                    Decimal currentComms = 0;
                    if ('ESTCOMM'.equals(commissionType)) {
                        currentComms = a.quotingResult.Estimated_Commission__c;
                    } else if ('TOTALCOMM'.equals(commissionType)) {
                        currentComms = a.quotingResult.Total_Commission__c;
                    } else {
                        currentComms = tcomm;
                    }
                    if (currentComms < tcomm) {
                        // System.debug('hasClient>>' + a.hasClientRate + '|hasBrokerage>>' + a.hasBrokerage + '|' + a.info.Client_Rate_Type__c);
                        Decimal ir = 1; //Incremental Rate
                        Integer irTimes = 1;
                        Boolean keepProcessing = true;
                        do {
                            if (a.hasClientRate) {
                                a.clientRate += ir;
                                if ('ANZ Consumer'.equals(a.info.lender__c) && Math.abs(a.clientRate - a.baseRate) > 2) {
                                    a.clientRate = a.baseRate + 2;
                                    keepProcessing = false;
                                }
                            } else if (a.hasBrokerage) {
                                a.brokerageBase += ir;
                                if (a.brokerageBase > a.info.Max_Brokerage__c) {
                                    a.brokerageBase = a.info.Max_Brokerage__c;
                                    keepProcessing = false;
                                }
                            } else {
                               keepProcessing = false;
                            }
                            LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
                            if ('ESTCOMM'.equals(commissionType)) {
                                currentComms = a.quotingResult.Estimated_Commission__c;
                            } else if ('TOTALCOMM'.equals(commissionType)) {
                                currentComms = a.quotingResult.Total_Commission__c;
                            } else {
                                currentComms = tcomm;
                            }
                            if (currentComms > tcomm) {
                                if (irTimes < 3) {
                                    if (a.hasClientRate) {
                                        a.clientRate -= ir;
                                    } else if (a.hasBrokerage) {
                                        a.brokerageBase -= ir;
                                    }
                                    irTimes++;
                                    ir = ir / 10.0;
                                } else {
                                    keepProcessing = false;        
                                }
                            }
                            i++;
                        } while (i <= limitStop && keepProcessing);
                        // System.debug('Attempts: ' + i + '|' + keepProcessing + '| Client rate: ' + a.clientRate + '|' + a.brokerageBase);
                    }
                }
            }
            param.sortBy = LenderQuotingWrapperDTO.ORD_CLIENT_RATE;
            sortResult();
        }
    }

    public void calculateCommissions() {
        calculateUsingCommissions(param.estimateCommission, 'ESTCOMM');
    }

    public void calculateTotalCommissions() {
        calculateUsingCommissions(param.targetCommission, 'TOTALCOMM');
    }

    public void adjustClientRate() {
        //if (param.rateValue == null) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage(%) is required.'));
        //} else if (param.rateValue > 4){
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max Brokerage is 4%.'));
        //} else {
            
        //}
        adjustClientRate(param.rateValue, false);
    }
    private void adjustClientRate(Decimal rateValue) {
        adjustClientRate(rateValue, false);
    }

    private void adjustClientRate(Decimal rateValue, Boolean isTargetRate) {

        System.debug('adjustClientRate: ' + param.rateValue + ' | ' + isTargetRate);
        if (lendersList != null && !lendersList.isEmpty()) {
            param.recalculating = true;
            for (LenderQuotingWrapperDTO a : lendersList) {
                if (a.quotingResult != null) {
                    if (a.hasClientRate) {
                        if (isTargetRate) {
                            a.clientRate = rateValue;
                            if (a.clientRate < a.baseRate) {
                                a.clientRate = a.baseRate;
                            }
                        } else {
                            a.clientRate = a.baseRate + rateValue;
                        }
                        //if (('ANZ Consumer'.equals(a.info.lender__c) || 
                        //     'Pepper MV'.equals(a.info.lender__c) || 
                        //     'Pepper Leisure'.equals(a.info.lender__c)) && 
                        //     Math.abs(a.clientRate - a.baseRate) > 2) {
                        //    a.clientRate = a.baseRate + 2;
                        //}
                        if ('ANZ Consumer'.equals(a.info.lender__c) && 
                             Math.abs(a.clientRate - a.baseRate) > 2) {
                            a.clientRate = a.baseRate + 2;
                        }
                        if (a.maxClientRate != null && a.maxClientRate > 0) {
                            if (a.clientRate > a.maxClientRate) {
                                a.clientRate = a.maxClientRate;
                            }
                        }
                        LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
                    } else if (a.hasBrokerage) {
                        Decimal targetRate = 0;
                        if (isTargetRate) {
                            targetRate = rateValue;
                            if (targetRate < a.baseRate) {
                                targetRate = a.baseRate;
                            }
                        } else {
                            targetRate = a.baseRate + rateValue;
                        }
                        Integer irTimes = 0;
                        Boolean keepProcessing = true;
                        Decimal ir = 1; //Incremental Rate
                        Integer limitStop = 150;
                        Integer i = 1;
                        Boolean isAdding = true;
                        //a.brokerageBase += param.rateValue;
                        Decimal prevBrokerage = 0; //Incremental Rate
                        Decimal tmpBrokerage = 0; //Incremental Rate
                        //System.debug('Initial Target rate >> ' + targetRate);
                        
                        //tmpBrokerage = (param.rateValue * 2.55);
                        tmpBrokerage = (rateValue * 0);

                        do {
                            prevBrokerage = a.brokerageBase;
                            if (tmpBrokerage < 0) {
                                tmpBrokerage = 0;
                            }
                            a.brokerageBase = tmpBrokerage.setScale(2);
                            LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
                            targetRate = a.baseRate + rateValue;
                            //System.debug('Target rate >> ' + targetRate + ' | brokerageBase >> ' + a.brokerageBase + ' | ' + irTimes + ' | ' + isAdding + ' | ' + a.clientRate);
                            if (targetRate == a.clientRate) {
                                //System.debug('Target rate reached >> ' + a.brokerageBase);
                                keepProcessing = false;
                            } else if (i > limitStop) {
                                //System.debug('Limit stop reached >> ' + a.brokerageBase);
                                keepProcessing = false;
                            } else if (a.brokerageBase >= a.info.Max_Brokerage__c) {
                                a.brokerageBase = a.info.Max_Brokerage__c;
                                keepProcessing = false;
                            } else {
                                if (a.clientRate < targetRate) {
                                    //if (i == 1 || (i > 1 && !isAdding)) {
                                    if (i > 1 && !isAdding) {
                                        irTimes++;
                                        ir = ir /10;
                                    }
                                    isAdding = true;
                                    tmpBrokerage += ir;
                                } else {
                                    //if (i == 1 || (i > 1 && isAdding)) {
                                    if (i > 1 && isAdding) {
                                        irTimes++;
                                        ir = ir /10;
                                    }
                                    isAdding = false;
                                    tmpBrokerage -= ir;
                                }
                            }
                            i++;
                        } while (keepProcessing && irTimes < 3);
                        //System.debug(a.info.Lender__c + ' >> ' + i + ' attempts | ' + irTimes);
                    }
                }
            }
        }
    }

    public void adjustDOFValue() {
        adjustDOFValue(param.dofValue);
    }

    public void resetDOFValue() {
        adjustDOFValue(20000.0);
        param.dofValue = null;
    }

    private void adjustDOFValue(Decimal dofValue) {
        //System.debug(param.rateValue);
        if (dofValue != null && lendersList != null && !lendersList.isEmpty()) {
            param.recalculating = true;
            for (LenderQuotingWrapperDTO a : lendersList) {
                if (a.quotingResult != null && !a.info.Lender__c.containsIgnoreCase('Yamaha')) {
                    a.dofBase = dofValue;
                    LenderComparisonFilterExtension.calculateBaseRate(a, param, lenderSelected);
                }
            }
        }
    }

    public void goClosingNoProceed() {
        this.infoExtra = 2;
    }

    public void goClosingNoProceed2() {
        this.infoExtra = 3;
    }

    public PageReference goSalesTool() {
        //SAVE TEXT DATA
        PageReference r = Page.OppApplication;
        r.getParameters().put('id', this.opp.Id);
        return r;
    }

    public PageReference goSendEmail() {
        //SAVE TEXT DATA
        PageReference r = Page.OppEmailTemplateSelector;
        r.getParameters().put('id', this.opp.Id);
        return r;
    }

    public void saveFlowComments() {
        System.debug('saving comments...');
        //System.debug('comment 1 >> ' + this.opp.Lead__r.Closing_Comment_1__c);
        //System.debug('comment 2 >> ' + this.opp.Lead__r.Closing_Comment_2__c);
        if (!Test.isRunningTest()) {
            update this.opp.Lead__r;
            if (this.infoExtra == 2) {
                this.infoExtra = 3;
            }
        }
    }

    public void customerNotInformation() {
        hasNotCustomerProvidedInfo = true;
        saveFlowComments();
        this.infoExtra = 4;
    }
    //- 
    
    // RateSetter
    private static void calculateRateSetterBaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.clientTier = param.tier;
        cp.customerProfile = 'Non Property Owner';
        if ('Full-Time'.equals(param.employmentType) && '750+'.equals(param.creditScore) && 'Clean History'.equals(param.creditHistory)) {
            if ('Property Owner'.equals(param.residentialStatus)){
                cp.clientTier = 'Tier 1';
                cp.customerProfile = 'Property Owner';
            } else if (param.residentialStatus.contains('Renting') && param.price != null && param.price > 0 && param.deposit != null) {
                Decimal a = param.deposit / param.price * 100;
                if (a >= 10.0) {
                    cp.clientTier = 'Tier 1';
                }
            }
        }
        
        Integer age = Date.today().year() - Integer.valueOf(param.ageCar);
        cp.vehicleYear = String.valueOf(age);
        cp.term = param.loanTerm;
        // System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' + cp.vehicleYear);
        // System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' + cp.customerProfile);
        // System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' + cp.clientTier);
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            if (lender.dofBase > lender.info.Max_DOF__c) {
                lender.dofBase = lender.info.Max_DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        //cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.totalAmount += QuotingCalculation.getFinanceOneRiskFeeCalc(cp);
        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = param.residual;
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        // System.debug('Base: ' + cp.baseRate + '|Client:' + cp.clientRate);
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.vehicleYear = cp.vehicleYear;
        lender.loanType = cp.loanTypeDetail;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.purchaseType = param.purchaseType;
        if('Dealer'.equals(param.purchaseType) || 'Private'.equals(param.purchaseType)){
            lender.purchaseType = 'Purchase';
        }
        lender.additionalInfo = cp.clientTier;

    }
    // Firstmac
    private static void calculateFirstmacBaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        Application_Quoting_Result__c r = null;

        System.debug('calculateFirstmacBaseRate...');

        cp.loanTypeDetail = '';
        cp.greenCar = 'N';
        cp.loanType = param.purchaseType;
        cp.carAge = Integer.valueOf(param.ageCar);

        if(cp.carAge >= 0 && cp.carAge <= 1){
            cp.loanTypeDetail = 'New/Demo (<2yrs)';
        }else if (cp.carAge >= 2 && cp.carAge <= 4) {
            cp.loanTypeDetail = 'Used - Dealer (2 - 4 yrs)';
        }else if(cp.carAge >= 5 && cp.carAge <= 7) {
            cp.loanTypeDetail = 'Used - Dealer (5 - 7yrs)';
        }
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.maxRate = QuotingCalculation.getMaximunBaseRate(cp);
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        if (param.recalculating) {
          cp.clientRate = lender.clientRate;
          Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
          cp.maxRate = maxBaseRate;
          if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
              cp.clientRate = maxBaseRate;
          }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        // cp.brokeragePer = lender.brokerageBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.paymentType = 'Arreas';
        cp.privateSales = param.getPrivateSales();
        cp.residualValue = param.residual;
        // cp.amountBaseComm = param.price - param.deposit;
        // cp.amountBasePmt = cp.getNaf() + (cp.amountBaseComm * cp.brokeragePer / 100);
        
        // System.debug(cp.getNaf() + '|' + cp.amountBasePmt + '|' + cp.brokeragePer + '|' + cp.baseRate + '|' + cp.term + '|monthlyFee: ' + cp.monthlyFee);
        // System.debug(JSON.serializePretty(cp));
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.loanType = cp.loanType;
        lender.loanTypeDetail = cp.loanTypeDetail;
        lender.carAge = cp.carAge;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.loanTypeDetail;
        lender.clientTier = cp.clientTier;
        lender.privateSales = cp.privateSales;
    }
    
    // AFS Consumer
    private static void calculateAFSConsumerBaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        
        cp.productLoanType = param.loanType;

        cp.bankrupt = 'N';
        cp.hasDefault = 'N';
        if ('Property Owner'.equals(param.residentialStatus)) {
          cp.residency = 'Property Owner';
        } else if ('Renting Real Estate'.equals(param.residentialStatus) || 'Renting Other'.equals(param.residentialStatus)) {
          cp.residency = 'Renting';
        } else {
          cp.residency = 'Boarding/Other';
        }
        
        cp.vehiclePrice = param.price;
        
        if('Car'.equals(param.assetDetail)){
        	cp.assetType = 'Car';    
        } else if('Motorbike'.equals(param.assetDetail)){
        	cp.assetType = 'Bikes / Scooters';    
        } else if('Boat'.equals(param.assetDetail)){
        	cp.assetType = 'Boats / Personal Watercraft';    
        } else if('Caravan'.equals(param.assetDetail)){
        	cp.assetType = 'Caravans / Motorhomes';    
        }
        
        Integer age = Integer.valueOf(param.ageCar);
        if (age == 0) {
            cp.vehicleYear = 'N/A';
            cp.condition = 'New/Demo';
        } else {
          cp.condition = 'Used';
          if (age <= 3) {
            cp.vehicleYear = '0-3 years';
          } else if (age >= 11 && age <= 20) {
            cp.vehicleYear = '11-20 yearsyears';
          } else if (age >= 21 && age <= 30) {
            cp.vehicleYear = '21-30 years';
          } else if (age > 30) {
            cp.vehicleYear = '30+ years';
          } else if (cp.assetType == 'Car') {
            if ('Property Owner'.equals(cp.residency)) {
              cp.vehicleYear = '4-10 years';
            } else if ('Renting'.equals(cp.residency)) {
              if (age <= 5) {
                cp.vehicleYear = '4-5 years';
              } else {
                cp.vehicleYear = '6-10 years';
              }
            } else {
              if (age <= 7) {
                cp.vehicleYear = '4-7 years';
              } else {
                cp.vehicleYear = '8-10 years';
              }
            }
          } else {
            if ('Property Owner'.equals(cp.residency) || 'Renting'.equals(cp.residency)) {
              if (age <= 5) {
                cp.vehicleYear = '4-5 years';
              } else {
                cp.vehicleYear = '6-10 years';
              }
            } else {
              if (age <= 7) {
                cp.vehicleYear = '4-7 years';
              } else {
                cp.vehicleYear = '8-10 years';
              }
            }
          }
        }
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        //cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = param.residual;
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.commRate = QuotingCalculation.getAfsConsumerCommission(cp);
        // System.debug('baseRate: ' + cp.baseRate + '|clientRate: ' + cp.clientRate + '|commRate: ' + cp.commRate);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        if(!param.assetDetail.equals('Car')){
        	lender.productGoodsType = 'Leisure';    
        }
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.condition + ' (' + cp.vehicleYear + ')';
        lender.riskGrade = cp.riskGrade;
        lender.condition = cp.condition;
        lender.carAge = Integer.valueOf(param.ageCar);
        if(lender.carAge > 8){
            lender.carAge = 8;
        }
        lender.vehicleYear = cp.vehicleYear;
        lender.bankrupt = cp.bankrupt;
        lender.hasDefault = cp.hasDefault;
        lender.residentialStatus = cp.residency;
        
        if('Renting Other'.equals(param.residentialStatus) || 'Renting Real Estate'.equals(param.residentialStatus)){
            lender.residentialStatus = 'Renting';
        }else if('Boarding'.equals(param.residentialStatus)){
            lender.residentialStatus = 'Boarding/Other';
        }
    }

    // AFS Commercial
    private static void calculateAFSCommercialBaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.clientTier = 'New - 6 years old';
        Integer age = Integer.valueOf(param.ageCar);
        if (age > 6) {
            cp.clientTier = 'Used 7 years+';
        }
        cp.baseRate = QuotingCalculation.getAfsCommercialMinBaseRate(cp);
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;
        //cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = param.residual;
        cp.paymentType = 'Arreas';
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.commRate = QuotingCalculation.getAfsCommercialCommission(cp);
        // System.debug('baseRate: ' + cp.baseRate + '|clientRate: ' + cp.clientRate + '|commRate: ' + cp.commRate);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.clientTier;
        //lender.info.Label__c = cp.clientTier;
    }

    private Integer calculateJobsLatestYears() {
        Integer r = 0;
        System.debug('calculateJobsLatestYears...');
        Date refDate = Date.today().addYears(-3);
        Date curDate = null;
        // System.debug('refDate: ' + refDate + '|' + r);
        // Current Employment
        if (String.isNotBlank(this.opp.Application__r.Mode_of_Employment_1__c) && 
            String.isNotBlank(this.opp.Application__r.Date_Started_1__c)) {
            curDate = DateUtils.convertToDate(this.opp.Application__r.Date_Started_1__c);
            r++;
            if (curDate != null && curDate < refDate) {
                return r;
            }
        }
        // System.debug('Cur Emp: ' + r + '|' + this.opp.Application__r.Mode_of_Employment_1__c + '|' + this.opp.Application__r.Date_Started_1__c);
        // Previous Employment
        if (String.isNotBlank(this.opp.Application__r.Previous_Mode_of_Employment_1__c) && 
            String.isNotBlank(this.opp.Application__r.Start_Date_1__c)) {
            curDate = DateUtils.convertToDate(this.opp.Application__r.Start_Date_1__c);
            r++;
            if (curDate != null && curDate < refDate) {
                return r;
            }
        }
        // System.debug('Pre Emp: ' + r + '|' + this.opp.Application__r.Previous_Mode_of_Employment_1__c + '|' + this.opp.Application__r.Start_Date_1__c);
        // Other Previous employments
        List<Application_Employment__c> lst = [
                SELECT Start_Date__c, Employment_Type__c FROM Application_Employment__c 
                WHERE Application__c = :this.opp.Application__c and Address_Type__c <> :Utilities.ADDRESS_TYPE_FINANCE
            ];
        for (Application_Employment__c e: lst) {
            if (String.isNotBlank(e.Employment_Type__c)) {
                r++;
                // System.debug('Pre Emp M: ' + r + '|' + e.Employment_Type__c + '|' + e.Start_Date__c);
                if (e.Start_Date__c < refDate) {
                    break;
                }
            }
        }

        return r;
    }

    private Decimal calculateAnnualIncome() {
        Decimal r = 0.0;
        if (this.opp.Application__c != null && this.opp.Application__r.Net_Income_1__c != null) {
            r = this.opp.Application__r.Net_Income_1__c * 12 *
                OppApplicationServCalculatorUtils.getFrecuencyFactor(this.opp.Application__r.Payment_Frequency_1__c, 'Monthly');
        }
        return r;       
    }

    private static void calculateBaseRateGreenLight(LenderQuotingWrapperDTO lender, FilterParams param) {
        //System.debug('-----------------------------------------------------');
        //System.debug(lender.info.Lender__c + ' calculating...');
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        Application_Quoting_Result__c r = null;
        cp.assetType = param.assetDetail;
        if ('Motorbike'.equals(param.assetDetail)) {
            cp.assetType = 'Motorcycle';
        }
        cp.clientTier = 'Platinum';
        if (LenderComparisonHelper.TIER_2.equals(param.tier)) {
            cp.clientTier = 'Gold';
        } else if (LenderComparisonHelper.TIER_3.equals(param.tier)) {
            if ('Car'.equals(param.assetDetail)) {
                cp.clientTier = 'Bronze Plus';
            } else {
                cp.clientTier = 'Silver';
            }
        }
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        
        cp.dof = lender.dofBase;
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + cp.dof + lender.info.PPSR__c;
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.paymentType = 'Arreas';
        cp.privateSales = param.getPrivateSales();
        if (!param.recalculating) {
            lender.brokerageBase = lender.info.Brokerage_Base__c;
        }
        cp.brokeragePer = lender.brokerageBase;
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
		
        cp.amountBaseComm = param.price - param.deposit;
        cp.residualValue = param.residual;
        try {
            //cp.clientRate = QuotingCalculation.getClientRateCalculation(cp);
            // System.debug(cp.getNaf() + '|' + cp.amountBasePmt + '|' + cp.brokeragePer + '|' + cp.baseRate + '|' + cp.clientRate + '|' + cp.term);
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.loanType = cp.loanTypeDetail;
        lender.carAge = Date.today().year() - cp.carAge;
        lender.privateSales = cp.privateSales;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
        lender.additionalInfo = cp.clientTier;
    }

    private static void calculateBaseRateLatitudePL(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.loanTypeDetail = 'AAA';
        cp.customerProfile = 'Secured';
        //String additionalInfo = '(Sapphire, Ruby, Emerald)';
        if (LenderComparisonHelper.TIER_2.equals(param.tier)) {
            cp.loanTypeDetail = 'B';
        } else if (LenderComparisonHelper.TIER_3.equals(param.tier)) {
            cp.loanTypeDetail = 'E';
            cp.customerProfile = 'Unsecured';
        }

        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.totalAmount = param.price - param.deposit + lender.info.Application_Fee__c + lender.info.PPSR__c;
        if (param.recalculating) {
            if (lender.dofBase > lender.info.DOF__c) {
                lender.dofBase = lender.info.DOF__c;        
            }
        } else {
            lender.dofBase = lender.info.DOF__c;
        }
        cp.dof = lender.dofBase;

        cp.totalAmount += cp.dof;

        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = QuotingCalculation.getMaximunBaseRate(cp);
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = 0.0;
        cp.commRate = lender.info.Commission_Rate__c;

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = param.loanTerm;
        lender.productLoanType = cp.loanTypeDetail;
        lender.additionalInfo = cp.loanTypeDetail;
        
    }

    private static void calculateBaseRateWisr(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.carAge = Integer.valueOf(param.ageCar);
        cp.vedascore = 750;
        if ('<400'.equals(param.creditScore)) {
            cp.vedascore = 400;
        } else if ('400 - 524'.equals(param.creditScore)) {
            cp.vedascore = 401;
        } else if ('525 - 599'.equals(param.creditScore)) {
            cp.vedascore = 525;
        } else if ('600 - 749'.equals(param.creditScore)) {
            cp.vedascore = 600;
        } else if ('750+'.equals(param.creditScore)) {
            cp.vedascore = 750;
        }
        cp.ltv = '>= 90';
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.baseRate = QuotingCalculation.getBaseRate(cp);

        cp.totalAmount = param.price - param.deposit;
        cp.amountBaseComm = cp.totalAmount;
        Decimal appFee = QuotingCalculation.wisrApplicationFee(cp.amountBaseComm);
        //Decimal appFee = lender.info.Application_Fee__c;        
        //if (cp.totalAmount > 20000) {
        //    appFee = lender.info.Application_Fee_Private__c;
        //}
        cp.totalAmount += appFee + lender.info.PPSR__c;
        Decimal maxDof = QuotingCalculation.wisrMaxDOF(cp.totalAmount);
        if (!param.recalculating) {
            lender.dofBase = lender.info.DOF__c;
        }
        if (lender.dofBase > maxDof) {
            lender.dofBase = maxDof;
        }
        cp.dof = lender.dofBase;

        cp.totalAmount += cp.dof;

        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = cp.baseRate;
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        
        cp.residualValue = 0.0;
        cp.commRate = QuotingCalculation.getWisrCommission(cp);

        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = param.loanTerm;
        lender.productLoanType = cp.loanTypeDetail;
        lender.additionalInfo = cp.loanTypeDetail;
        
    }

    //RateSetter PL
    private static void calculateRateSetterPLBaseRate(LenderQuotingWrapperDTO lender, FilterParams param) {
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.clientTier = 'Tier 1';
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.totalAmount = param.price - param.deposit;
        Decimal appFee = QuotingToolHelper.getRateSetterPLAppfee(cp.totalAmount, cp.term.intValue());
        lender.additionalInfo = 'Unsecured';
        if (param.loanType.contains('Chattel Mortgage')) {
            appFee += 250;
            lender.additionalInfo += ' | Business Purpose';
        } else if (param.employmentType.contains('Self employed')) {
            appFee += 150;
            lender.additionalInfo += ' | Self Employed';
        }
        cp.monthlyFee = QuotingToolHelper.getRateSetterPLMonthlyfee(cp.totalAmount, cp.term.intValue());
        cp.totalAmount += appFee;
        cp.dof = QuotingToolHelper.getRateSetterPLDOF(cp.totalAmount, cp.term.intValue());
        lender.dofBase = cp.dof;
        cp.totalAmount += cp.dof;
        
        cp.baseRate = lender.info.Default_Base_Rate__c;
        
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = cp.baseRate + 10;
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.residualValue = 0.0;
        cp.paymentType = 'Arreas';
        
        // System.debug('Base: ' + cp.baseRate + '|Client:' + cp.clientRate);
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }
        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.clientTier = cp.clientTier;
        lender.vehicleYear = cp.vehicleYear;
        lender.loanType = cp.loanTypeDetail;
        lender.term = param.loanTerm;
        lender.productGoodsType = param.assetDetail;
        lender.productLoanType = param.purchaseType;
    }

    private static void calculateBaseRateNowFinance(LenderQuotingWrapperDTO lender, FilterParams param) {
        
        QuotingCalculation.CalcParam cp = new QuotingCalculation.CalcParam(lender.info.Lender__c);
        cp.loanTypeDetail = 'Secured';
        if (LenderComparisonHelper.TIER_3.equals(param.tier)) {
            cp.loanTypeDetail = 'Unsecured';
        }
        cp.baseRate = QuotingCalculation.getBaseRate(cp);
        cp.totalAmount = param.price - param.deposit;
        // System.debug('totalAmount: ' + cp.totalAmount);
        Decimal appFee = cp.totalAmount * 0.04;
        if (appFee > lender.info.Application_Fee__c) {
            appFee = lender.info.Application_Fee__c;
        }
        Decimal maxDof = QuotingToolHelper.getNowFinanceMaxDOF(cp.totalAmount + appFee);
        if (param.recalculating) {
            if (lender.dofBase > maxDof) {
                lender.dofBase = maxDof;
            }
        } else {
            lender.dofBase = maxDof;
        }
        cp.dof = lender.dofBase;
        cp.totalAmount += (cp.dof + appFee + lender.info.PPSR__c);
        // System.debug('appFee: ' + appFee);
        // System.debug('dof: ' + cp.dof);
        // System.debug('PPSR: ' + lender.info.PPSR__c);
        // System.debug('totalAmount: ' + cp.totalAmount);
        if (param.recalculating) {
            cp.clientRate = lender.clientRate;
            Decimal maxBaseRate = 16.95;
            if (maxBaseRate > 0 && cp.clientRate > maxBaseRate) {
                cp.clientRate = maxBaseRate;
            }
        } else {
            cp.clientRate = cp.baseRate + lender.clientRateFactor;
        }
        cp.paymentType = 'Arreas';
        
        cp.monthlyFee = lender.info.Monthly_Fee__c;
        cp.term = Decimal.valueOf(param.loanTerm);
        cp.residualValue = param.residual;
        // System.debug('totalAmount: ' + cp.totalAmount + '|baseRate: ' + cp.baseRate + '|clientRate: ' + cp.clientRate + '|monthlyFee: ' + cp.monthlyFee);
        Application_Quoting_Result__c r = null;
        try {
            r = QuotingCalculation.calculate(cp);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            r = new Application_Quoting_Result__c();
        }

        //Result
        lender.quotingResult = r;
        lender.baseRate = cp.baseRate;
        lender.clientRate = cp.clientRate;
        lender.term = param.loanTerm;
        lender.productLoanType = cp.loanTypeDetail;
        lender.additionalInfo = cp.loanTypeDetail;
        
    }

    private void calculateServicing() {
        if (this.opp.Application__c != null) {
            ServicingCalcHelper.Parameter p = ApplicationService.prepareServicingInfo(this.opp.Application__c);
            if (p != null) {
                for (LenderQuotingWrapperDTO a : this.lendersList) {
                    p.lender = a.info.Lender__c;
                    // System.debug('Global parameters: ' + p);
                    if (a.quotingResult != null) {
                        if (a.quotingResult.Monthly_Payment__c != null) {
                            p.repayment = a.quotingResult.Monthly_Payment__c;
                        }
                        if (a.quotingResult.NAF__c != null) {
                            p.naf = a.quotingResult.NAF__c;
                        }
                    }
                    a.servicing = ServicingCalcHelper.calculate(p);
                    // System.debug('parame: ' + p);
                    // System.debug('result: ' + a.servicing);
                }
            }
        }
    }
    
    public PageReference saveOpinion(){
        if(''.equals(opinionText)){
            opinionMessage = 'Please enter an opinion before saving, thank you.';
        }else{
            opinionMessage = 'Thank you for your feedback.';
            saveInCustomObject();
        	opinionText = '';
        }
        return null;
    }
    
    public void saveInCustomObject(){
        cfc = new Comparison_Feedback__c();
        cfc.Custom_Opportunity__c = opp.Id;
        cfc.Name = opp.Name;
        cfc.Tier__c = param.tier;
        // System.debug('Payday loan last 6 months: '+ param.hasPayday + ' Credit enquiries in 6 months '+ param.hasEnquiries);
        
        if(param.assetDetail == null){ param.assetDetail = 'None';}
        if(param.employmentType == null){ param.employmentType = 'None';}
        if(param.loanType == null){ param.loanType = 'None';}
        if(param.purchaseType == null){ param.purchaseType = 'None';}
        if(param.creditHistory == null){ param.creditHistory = 'None';}
        if(param.hasVerifiableCredit == null){ param.hasVerifiableCredit = 'None';}
        if(param.ageCar == null){ param.ageCar = 'None';}
        if(param.loanTerm == null){ param.loanTerm = 0;}
        if(param.residentialStatus == null){ param.residentialStatus = 'None';}
        if(param.price == null){ param.price = 0.00;}
        if(param.deposit == null){ param.deposit = 0.00;}
        if(param.residual == null){ param.residual = 0.00;}
        if(param.hasVerifiableCredit == null){ param.hasVerifiableCredit = 'None';}
        if(param.jobsLast3Years == null){ param.jobsLast3Years = 0;}
        if(param.creditScore == null){ param.creditScore = 'None';}
        if(param.verifiableSavings == null){ param.verifiableSavings = 'None';}
        if(param.ltv == null){ param.ltv = 'None';}
        if(param.hasPayday == null){ param.hasPayday = 'None';}
        if(param.hasEnquiries == null){ param.hasEnquiries = 'None';}
        
        String d = 'Lender | Detail | Base Rate | Client Rate | Commission | DOF | w/repayment\n';
        for(LenderQuotingWrapperDTO a : lendersList){
            d+=a.info.lender__c+' | '+ a.getExtraInfo()+ ' | '+ a.baseRate+' | '+a.clientRate+' | '+a.quotingResult.Total_Commission__c+' | '+a.dofBase+' | '+a.quotingResult.Weekly_Payment__c+'\n';
        }
        
        opinionText += '\n\n\n'
            		+ 'Results: \n\n'
            		+ d + '\n\n'
                    + 'Summary: \n\n'
            		+ 'Asset Detail: '+param.assetDetail+'\n' 
                    + 'Employment Type: '+param.employmentType+ '\n'
                    + 'Loan Type: '+param.loanType+'\n'
                    + 'Purchase Type: '+param.purchaseType+'\n'
                    + 'Credit History: '+param.creditHistory+'\n'
                    + 'Age Vehicle: '+param.ageCar+'\n'
            		+ 'Loan Term (months): '+param.loanTerm+'\n'
            		+ 'Residential Status: '+param.residentialStatus+'\n'
            		+ 'Vehicle Price: '+param.price+'\n'
            		+ 'Deposit: '+param.deposit+'\n'
            		+ 'Residual: '+param.residual+'\n'
            		+ 'Payday loan last 6 months?: '+param.hasPayday+'\n'
            		+ 'Verifiable credit?: '+param.hasVerifiableCredit+'\n'
            		+ 'Jobs in the last 3 years?: '+param.jobsLast3Years+'\n'
					+ 'Credit enquiries in 6 months?: '+param.hasEnquiries+'\n'
            		+ 'Credit score?: '+param.creditScore+'\n'
            		+ 'Verifiable Savings?: '+param.verifiableSavings+'\n'
            		+ 'What is your LTV?: '+param.ltv+'\n';
        cfc.Comment__c = opinionText;
        insert cfc;
    }
    
	// Yohan Villamizar                                 2019-07-03
    public void adjustBaseRate(){
        if (LenderComparisonHelper.TIER_1.equals(param.tier)){
            adjustClientRate(0.0);
        }else if (LenderComparisonHelper.TIER_2.equals(param.tier)) {
            adjustClientRate(2.0);
        } else if (LenderComparisonHelper.TIER_3.equals(param.tier)) {
            adjustClientRate(100.0);
        }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}