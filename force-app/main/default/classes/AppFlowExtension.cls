public class AppFlowExtension {

    public static final String STP_INIT = '0';
    public static final String STP_QUES = 'QQ';
    public static final String STP_OWNE = 'OWNE';
    public static final String STP_INAC = 'INAC';

    //Prime - Personal
    public static final String STP_PRIM = 'PRI';
    public static final String STP_PROI = 'PROI';       //remove
    public static final String STP_PRRS = 'PRRS';
    public static final String STP_PRPR = 'PRPR';
    public static final String STP_PRMR = 'PRMR';
    public static final String STP_PRLO = 'PRLO';


    //Prime - Personal Self-employed
    public static final String STP_PRSE = 'PRSE';

    //Commercial - Business
    public static final String STP_COMM = 'COM';
    public static final String STP_COIN = 'COIN';
    //public static final String STP_CORE = 'CORE';
    public static final String STP_COOA = 'COOA';   //Other Assets
    
    //Badcredit
    public static final String STP_BCRE = 'BCR';
    public static final String STP_BCR2 = 'BCR2';

    //Closing
    public static final String STP_PRES = 'PRES';       //Presenting And Closing

    //Opportunity Status
    public static final String OPPSTATUS_BEOPPORTUNITY = 'Become Opportunity';
    public static final String OPPSTATUS_APPFORMSENT = 'Application Form Sent';
    public static final String OPPSTATUS_QUOSENT = 'Quote Sent';
    public static final String OPPSTATUS_APPFORMRECEIVED = 'Application Forms Received';

    public static final String LEADSTATUS_SFBEOPPORTUNITY = 'Sales Flow/Become Opportunity';
    
    public String step {set;get;}
    private Map<String, String> titleMap;

    private Lead__c lead;
    public Application__c app {set;get;}
    public Custom_Opportunity__c opp {set;get;}

    public List<LoanWrapped> loans {set;get;}
    public Integer loanSelected {set;get;}
    //public LoanWrapped mortgageLoan {set;get;}

    public List<CreditCardWrapped> creditCards {set;get;}
    public Integer cardSelected {set;get;}

    public List<IncomeWrapped> incomes {set;get;}
    public Integer incomeSelected {set;get;}
    //public IncomeWrapped centrelinkIncome {set;get;}
    public List<IncomeWrapped> centrelinkIncomes {set;get;}
    public Integer centrelinkSelected {set;get;}

    public List<DefaultWrapped> defaultList {set;get;}
    public Integer defaultSelected {set;get;}

    public List<EmploymentWrapped> emptList {set;get;}
    public Integer employSelected {set;get;}

    private String oppId;

    //Other asset index
    public Integer otherAssetIndex {set;get;}

    public Account leadAccount {set;get;}
    public Boolean displayClosingLead {set;get;}
    public Boolean displayClosingOpp {set;get;}

    public List<Custom_Opportunity__c> relatedOppsList {set;get;}

    public User leadOwner {set;get;}

    public Integer previousAddresses {set;get;}
    public String haveCreditCards {set;get;}
    // Lelo                 2019-03-19
    public Map<String, List<ObjectWrapped>> otherAssetMap {set;get;}
    public List<ObjectWrapped> otherAssetList {
        set;
        get { return this.getOtherAssetList(ApplicationService.OTHER_ASSET_TYPE); }
    }
    public List<ObjectWrapped> vehicleAssetList {
        set;
        get { return this.getOtherAssetList(ApplicationService.VEHICLE_ASSET_TYPE); }
    }
    public Application_Other_Asset__c mortgageProp {set;get;}
    // -

    public AppFlowExtension(ApexPages.StandardController ctrl) {
        System.debug('Constructor created.');
        this.lead = (Lead__c)ctrl.getRecord();
        init();
    }

    private void init() {
        System.debug('Executing init()...');
        String paramTmp = System.currentPageReference().getParameters().get('STEP');

        this.displayClosingLead = false;
        this.displayClosingOpp = false;
        this.step = STP_INIT;
        //Titles
        titleMap = new Map<String, String>();
        titleMap.put(STP_INIT, 'Opening/Power Statement');
        titleMap.put(STP_QUES, 'Questioning & Qualifying');
        titleMap.put(STP_OWNE, 'Account Ownership');
        //Prime
        titleMap.put(STP_PRIM, 'Details');
        titleMap.put(STP_PROI, 'Other Incomes');
        titleMap.put(STP_PRRS, 'Residential Status');
        titleMap.put(STP_PRPR, 'Previous Residential Status');
        titleMap.put(STP_PRMR, 'Marital Status');
        titleMap.put(STP_PRLO, 'Loan/Credit Commitments');

        //Presonal Self-employed
        titleMap.put(STP_PRSE, 'Details');

        //Commercial
        titleMap.put(STP_COMM, 'Details');
        titleMap.put(STP_COIN, 'Chattel Mortgage Info');
        //titleMap.put(STP_CORE, 'Residual');
        titleMap.put(STP_COOA, 'Other Assets');
        
        //Bad Credit
        titleMap.put(STP_BCRE, 'Details');
        titleMap.put(STP_BCR2, 'Other Details');

        titleMap.put(STP_PRES, 'Presenting');

        if (String.isNotBlank(paramTmp) && titleMap.containsKey(paramTmp)) {
            this.step = paramTmp;
        }


        loadApplication();

        if (this.lead.Residual__c == null) {
            this.lead.Residual__c = 0.0;
        }
        if (this.lead.Account__c != null) {
            List<Account> accs = [SELECT Id, Name, OwnerId, PersonEmail, PersonMobilePhone FROM Account WHERE Id = :this.lead.Account__c];
            if (!accs.isEmpty()) {
                leadAccount = accs.get(0);
            }
        }
        //Check for rtelated Opps
        this.relatedOppsList = this.listRelatedOpportunities();
        this.initResidentialStatus();
    }

    private void loadApplication() {

        if (this.lead.Application__c != null) {
            this.app = this.lead.Application__r;
            if (this.app.OwnerId == SOQLSingletonQueries.recs().sysGenUser.Id) {
                this.app.OwnerId = UserInfo.getUserId();
            }
        } else {
            this.app = new Application__c();
            this.app.Account__c = this.lead.Account__c;
            this.app.First_Name__c = this.lead.First_Name__c;
            this.app.Last_Name__c = this.lead.Last_Name__c;
            this.app.Mobile_Number__c = this.lead.Mobile_Number__c;
            this.app.Email_Address__c = this.lead.Email_Address__c;
            this.app.Status__c = ApplicationService.APP_STATUS_FLOWFILLED;
            this.app.No_of_Dependants_1__c = 0;
            this.app.Credit_Status_1__c = this.lead.Credit_History__c;
            this.app.OwnerId = UserInfo.getUserId();
            //State
            String stt = PostcodeHelper.getState(this.lead.Postcode__c);
            if (String.isNotBlank(stt)) {
                this.app.Current_Work_State_1__c = stt;
                this.app.Driver_Licence_State_Issue_1__c = stt;
                this.app.State__c = stt;
            }
            this.app.Current_Work_Postcode_1__c = this.lead.Postcode__c;
            this.app.Postcode__c = this.lead.Postcode__c;
        }
        if (this.app.Length_of_Term__c == null) {
            this.app.Length_of_Term__c = 5;
        }

        loadOtherAssets(); // Must be executed gefore load application loans 
        //loans = getApplicationLoans();
        this.creditCards = getApplicationCreditCards();
        this.haveCreditCards = null;
        if (!this.creditCards.isEmpty()) {
            haveCreditCards = 'Yes';
        }
        this.incomes = getApplicationIncomes();
        if (this.incomes.isEmpty()) {
            addIncome();
        } else {
            recalculateIncomesIdx(this.incomes);    
        }
        if (this.centrelinkIncomes.isEmpty()) {
            addCentrelink();
        } else {
            recalculateIncomesIdx(this.centrelinkIncomes);    
        }

        defaultList = getApplicationDefaults();
        emptList = getApplicationEmployments();
        this.opp = this.getCustomOpportunity();
        this.initResidentialStatus();
    }

    public void initResidentialStatus() {
        this.previousAddresses = 0;
        if (String.isNotBlank(this.app.Previous_Residence_Status_1__c) || 
            String.isNotBlank(this.app.Previous_Residence_Years__c)) {
            this.previousAddresses = 1;
        }
        if (String.isNotBlank(this.app.Previous_Residence_Status_1b__c) || 
            String.isNotBlank(this.app.Previous_Residence_Yearsb__c)) {
            this.previousAddresses = 2;
        }
        if (String.isNotBlank(this.app.Previous_Residence_Status_1c__c) || 
            String.isNotBlank(this.app.Previous_Residence_Yearsc__c)) {
            this.previousAddresses = 3;
        }
        if (String.isNotBlank(this.app.Previous_Residence_Status_1d__c) || 
            String.isNotBlank(this.app.Previous_Residence_Yearsd__c)) {
            this.previousAddresses = 4;
        }
        if (String.isNotBlank(this.app.Previous_Residence_Status_1e__c) || 
            String.isNotBlank(this.app.Previous_Residence_Yearse__c)) {
            this.previousAddresses = 5;
        }
        System.debug('initResidentialStatus... ' + this.previousAddresses);
    }

    private List<DefaultWrapped> getApplicationDefaults() {
        List<DefaultWrapped> r = new List<DefaultWrapped>();
        if (this.app.Id != null) {
            List<Application_Default__c> d = [SELECT Application__c, Is_Paid__c, Lender__c, Listed_Date__c, Total_Amount__c
                                             FROM Application_Default__c WHERE Application__c = :this.app.Id ORDER BY Name];
            Integer i = 1;
            for (Application_Default__c a : d) {
                r.add(new DefaultWrapped(i++, a));
            }
        }
        return r;
    }

    public String getTitleSection() {
        String r = titleMap.get(this.step);
        if (!STP_INIT.equals(this.step) && !STP_QUES.equals(this.step)) {
            r = this.lead.Application_Type__c + ' | ' + r;
        }
        return r;
    }

    public Boolean getHasBackRendered() {
        if (STP_INIT.equals(this.step) ||
            STP_OWNE.equals(this.step)) {
            return false;
        }
        return true;
    }

    public Boolean getHasSaveRendered() {
        if (STP_INIT.equals(this.step) ||
            STP_PRES.equals(this.step) ||
            STP_OWNE.equals(this.step)) {
            return false;
        }
        return true;
    }

    public Boolean getHasSaveNextRendered() {
        if (STP_PRES.equals(this.step) ||
            STP_INIT.equals(this.step)) {
            return false;    
        }
        return true;
    }

    public Boolean getHasFinishRendered() {
        if (STP_PRES.equals(this.step)) {
            //return true;    
        }
        return false;
    }

    public void back() {
        if (!STP_INIT.equals(step)) {
            if (this.getHasOpportunity()) {
                saveData(false);
            }
            if (STP_QUES.equals(step)) {
                step = STP_INIT;
            } else if (STP_PRIM.equals(step)) {
                step = STP_QUES;
            } else if (STP_COMM.equals(step)) {
                step = STP_QUES;
            } else if (STP_BCRE.equals(step)) {
                step = STP_QUES;
            } else if (STP_PRRS.equals(step)) {
                if ('Personal'.equals(this.lead.Application_Type__c)) {
                    //if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c)) {
                    //    step = STP_PROI;        
                    //} else {
                    //    step = STP_PRIM;    
                    //}
                    step = STP_PRIM;
                } else if ('Personal Self-employed'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRSE;
                } else if ('Bad Credit'.equals(this.lead.Application_Type__c)) {
                    step = STP_BCRE;
                } else if ('Business'.equals(this.lead.Application_Type__c) || 
                           'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    step = STP_COMM;
                }
            } else if (STP_PRSE.equals(step)) {
                step = STP_QUES;
            } else if (STP_PRPR.equals(step)) {
                step = STP_PRRS;
                this.initResidentialStatus();
            } else if (STP_PROI.equals(step)) {
                step = STP_PRIM;
            } else if (STP_PRMR.equals(step)) {
                step = STP_PRRS;
                this.initResidentialStatus();
                //if (this.hasLessThan3YearsResidence()) {
                //    step = STP_PRPR;
                //} else {
                //    step = STP_PRRS;    
                //}
            } else if (STP_PRLO.equals(step)) {
                if ('Personal'.equals(this.lead.Application_Type__c) || 'Personal Self-employed'.equals(this.lead.Application_Type__c)) {
                    //step = STP_PRMR;
                    step = STP_PRRS;
                    this.initResidentialStatus();
                } else if ('Business'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    step = STP_COOA;
                    //if (this.hasLessThan3YearsResidence()) {
                    //    step = STP_PRPR;
                    //} else {
                    //    step = STP_PRRS;    
                    //}
                } else if ('Bad Credit'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    //step = STP_PRMR;
                    step = STP_PRRS;
                    this.initResidentialStatus();
                } 
            } else if (STP_PRES.equals(step)) {
                if ('Personal'.equals(this.lead.Application_Type__c) ||
                    'Personal Self-employed'.equals(this.lead.Application_Type__c) ||
                    'Bad Credit'.equals(this.lead.Application_Type__c) ||
                    'Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRLO;
                    //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                    //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                    //    step = STP_PRLO;
                    //} else {
                    //    if ('Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    //        step = STP_COOA;        
                    //    } else {
                    //        step = STP_PRMR;    
                    //    }
                    //}
                //} else if ('Business'.equals(this.lead.Application_Type__c) ||
                //           'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                } else if ('Business'.equals(this.lead.Application_Type__c) ||
                    'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    step = STP_COIN;
                } 
                //else if ('Bad Credit'.equals(this.lead.Application_Type__c)) {
                //    if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                //        step = STP_PRLO;
                //    } else {
                //        step = STP_BCRE;    
                //    }
                //}
            } else if (STP_COIN.equals(step)) {
                if ('Business'.equals(this.lead.Application_Type__c) ||
                    'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                    //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                    //    step = STP_PRLO;
                    //} else {
                    //    step = STP_COOA;  
                    //}
                    step = STP_PRLO;
                }
            } else if (STP_COOA.equals(step)) {
                // step = STP_COMM;
                step = STP_PRRS;
                this.initResidentialStatus();
                //if (this.hasLessThan3YearsResidence()) {
                //    step = STP_PRPR;
                //} else {
                //    step = STP_PRRS;    
                //}
            } else if (STP_BCR2.equals(step)) {
                if ('Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRSE;        
                } else {
                    step = STP_BCRE;    
                }
            }
        }
        System.debug('back... to ' + step);
    }

    public void saveData() {
        saveData(true);
    }

    private void saveData(Boolean hasValidation) {
        System.debug('saveData... [' + step + ']');
        if (STP_QUES.equals(step)) {
            if ((this.getIsPersonalLoan() && String.isBlank(this.lead.Vehicle_Usage__c)) ||
                'N'.equals(this.lead.Is_SelfEmpl_Business__c)) {
                this.lead.Vehicle_Usage__c = 'Personal';
            }
            if ('Personal'.equals(this.lead.Vehicle_Usage__c)) {
                this.app.Application_Type__c = 'Personal';
                if ('Y'.equals(this.lead.Has_Clean_Credit_History__c)) {
                    if ('Y'.equals(this.lead.Is_SelfEmpl_Business__c)) {
                        this.lead.Application_Type__c = 'Personal Self-employed';
                        this.app.Mode_of_Employment_1__c = 'Self Employed';
                    } else {
                        this.lead.Application_Type__c = 'Personal';
                    }
                } else {
                    if ('Y'.equals(this.lead.Is_SelfEmpl_Business__c)) {
                        this.lead.Application_Type__c = 'Bad Credit Self-employed';
                    } else {
                        this.lead.Application_Type__c = 'Bad Credit';
                    }
                }
            } else if ('Business'.equals(this.lead.Vehicle_Usage__c)) {
                this.app.Application_Type__c = 'Business';
                if ('Y'.equals(this.lead.Is_SelfEmpl_Business__c)) {
                    if ('Y'.equals(this.lead.Has_Clean_Credit_History__c)) {
                        this.lead.Application_Type__c = 'Business';
                    } else {
                        this.lead.Application_Type__c = 'Bad Credit Business';
                    }
                } else {
                    //this.lead.Application_Type__c = 'Personal';
                    if ('Y'.equals(this.lead.Has_Clean_Credit_History__c)) {
                        this.lead.Application_Type__c = 'Personal';
                        this.app.Application_Type__c = 'Personal';
                    } else {
                        this.lead.Application_Type__c = 'Bad Credit';
                    }
                }
            }
            //if (!'Y'.equals(this.lead.Has_Vehicle_Located__c)) {
            //    this.lead.Deposit__c = 0;
            //}
            if (!'Y'.equals(this.lead.Has_Trade_In__c)) {
                this.lead.Trade_In__c = null;
                this.lead.Payout_On__c = null;
            }
            if (!'N'.equals(this.lead.Has_Clean_Credit_History__c)) {
                this.lead.Has_Any_Application_Received__c = null;
                this.lead.App_Received_Type__c = null;
                this.lead.App_Outcome__c = null;
                this.lead.Quote_What__c = null;
                this.lead.Quote_Loan_Amount__c = null;
                this.lead.Quote_Rate__c = null;
                this.lead.Quote_Term__c = null;
                this.lead.Quote_Repayment__c = null;
                this.lead.Quote_Frequency__c = null;
                this.lead.Quote_Balloon__c = null;
                this.lead.Quote_Fees__c = null;
            } else {
                if (!'Y'.equals(this.lead.Has_Any_Application_Received__c) ||
                    ('Y'.equals(this.lead.Has_Any_Application_Received__c) && 
                     String.isBlank(this.lead.App_Received_Type__c ))) {
                    this.lead.App_Received_Type__c = null;
                    this.lead.App_Outcome__c = null;
                    this.lead.Quote_What__c = null;
                    this.lead.Quote_Loan_Amount__c = null;
                    this.lead.Quote_Rate__c = null;
                    this.lead.Quote_Term__c = null;
                    this.lead.Quote_Repayment__c = null;
                    this.lead.Quote_Frequency__c = null;
                    this.lead.Quote_Balloon__c = null;
                    this.lead.Quote_Fees__c = null;
                } else {
                    if ('Application'.equals(this.lead.App_Received_Type__c)) {
                        this.lead.Quote_What__c = null;
                        this.lead.Quote_Loan_Amount__c = null;
                        this.lead.Quote_Rate__c = null;
                        this.lead.Quote_Term__c = null;
                        this.lead.Quote_Repayment__c = null;
                        this.lead.Quote_Frequency__c = null;
                        this.lead.Quote_Balloon__c = null;
                        this.lead.Quote_Fees__c = null;
                    } else if ('Quote'.equals(this.lead.App_Received_Type__c)) {
                        this.lead.App_Outcome__c = null;
                    }
                }
            }
        } else if (STP_PRRS.equals(step) || STP_COMM.equals(step)) {
            this.savePRRS(hasValidation);
        } else if (STP_PRMR.equals(step)) {
            if ('No'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                syncApplicationLoans(null);
            }
            if ('No'.equals(this.haveCreditCards)) {
                syncCreditCards(null);
            }
            if (!'Yes'.equals(this.lead.Able_Provide_Guarantor__c)) {
                this.lead.Guarantor_Property_Owner__c = null;
                this.lead.Guarantor_Fulltime_Employed__c = null;
            }
        } else if (STP_PRLO.equals(step) && hasValidation) {
            if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                if (this.hasLoansValidated()) {
                    syncApplicationLoans(this.loans);
                }
            } else {
                syncApplicationLoans(null);
            }
            
            List<Application_Credit_Card__c> cards = new List<Application_Credit_Card__c>();
            if ('Yes'.equals(this.haveCreditCards)) {
                if (this.hasCreditCardValidated()) {
                    for (CreditCardWrapped a : this.creditCards) {
                        if (a.data.Id == null) {
                            a.data.Application__c = this.app.Id;
                        }
                        cards.add(a.data);
                    }
                    //if (!cards.isEmpty()) {
                    //    upsert cards;
                    //}
                }
            }
            syncCreditCards(cards);
        } else if (STP_BCRE.equals(step) && hasValidation) {
            if ('Y'.equals(this.lead.Has_Defaults_File__c)) {
                if (this.hasDefaultValidated()) {
                    List<Application_Default__c> d = new List<Application_Default__c>();
                    for (DefaultWrapped a : this.defaultList) {
                        if (a.data.Id == null) {
                            a.data.Application__c = this.app.Id;
                        }
                        d.add(a.data);
                    }
                    if (!d.isEmpty()) {
                        upsert d;
                    }
                }
            }
            this.haveCreditCards = 'No';
            // if (this.hasIncomeValidated()) {
            //     syncCentrelinkBenefits();
            // }
            this.calculateEmploymentDates();
        } else if (STP_PROI.equals(step)) {
            //List<Application_Income__c> d = new List<Application_Income__c>();
            //if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c)) {
            //    if (this.hasIncomeValidated()) {
            //        for (IncomeWrapped a : this.incomes) {
            //            if (a.data.Id == null) {
            //                a.data.Application__c = this.app.Id;
            //            }
            //            d.add(a.data);
            //        }
            //        //if (!d.isEmpty()) {
            //        //    upsert d;
            //        //}
            //    }
            //}
            //syncApplicationIncomes(d);
        } 

        if (STP_PRIM.equals(step) || STP_BCRE.equals(step)) {
            if ('No'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                syncApplicationLoans(null);
            }
            if ('No'.equals(this.haveCreditCards)) {
                syncCreditCards(null);
            }
            if (!'Yes'.equals(this.lead.Able_Provide_Guarantor__c)) {
                this.lead.Guarantor_Property_Owner__c = null;
                this.lead.Guarantor_Fulltime_Employed__c = null;
            }
            
            //if (hasValidation && this.hasIncomeValidated() && this.hasCentrelinkValidated()) {
            if (hasValidation && this.hasCentrelinkValidated()) {
                syncCentrelinkBenefits();
            }
            if (hasValidation && this.hasPreviousEmploymentValidated()) {
                this.calculateEmploymentDates();
                syncPreviousEmployment();
            }
            //syncApplicationIncomes
        } else if (STP_PRSE.equals(step)) {
            if (hasValidation) { 
                //if (this.hasIncomeValidated() && this.hasCentrelinkValidated()) {
                if (this.hasCentrelinkValidated()) {
                    syncCentrelinkBenefits();
                }
            }
            //syncApplicationIncomes
        } else if (STP_COOA.equals(step)) {
            if (hasValidation) { 
                syncOtherAsset();
            }
        }

        if (this.app.Net_Income_1__c == null) {
            this.app.Net_Income_1__c = 0;
        }

        //if (!'Closed Lead'.equals(this.lead.Status__c)) {
            System.debug('Saving data... step: ' + this.step);
            //if (!STP_INIT.equals(this.step)) {
                System.debug('Checking Account...');
                if (this.lead.Account__c == null) {
                    //Check account
                    this.checkAccountCreation();
                }
                //Take ownership
                System.debug('Taking Lead ownership...');
                if (this.lead.OwnerId != UserInfo.getUserId()) {
                    this.lead.OwnerId = UserInfo.getUserId();
                }

                System.debug('Checking Lead Status...');
                if ('New Lead'.equals(this.lead.Status__c)) {
                    System.debug('Changing Lead Status...');
                    this.lead.Status__c = LEADSTATUS_SFBEOPPORTUNITY;
                }

                // Notify Call Center
                if (this.lead.CC_Lead_ID__c > 0 && this.lead.CC_Completed_Date__c == null) {
                    if (ipSCAPEService.completeCCLead(String.valueOf(this.lead.CC_Lead_ID__c)) ){
                        this.lead.CC_Completed_Date__c = Datetime.now();
                    }
                }

                //Check Application
                if (app.Id == null) {
                    System.debug('Creating and linking Application...');
                    this.app.Name = this.lead.Name;
                    insert this.app;
                    this.lead.Application__c = this.app.Id;
                } else {
                    System.debug('Updating application...');
                    update this.app;
                }
                
                System.debug('Updating lead...');
                update this.lead;

                //Check Opportunity
                if (this.getHasOpportunity()) {
                    System.debug('Updating opportunity...');
                    update this.opp;
                } else {
                    System.debug('Creating opportunity...');
                    this.manageCustomOpportunity(OPPSTATUS_BEOPPORTUNITY);
                }
            //}
        //}
    }

    public void next() {
        System.debug('next... ' + step + '|' + this.lead.Application_Type__c);
        if (!STP_OWNE.equals(step)) {
            saveData(true);
        }
        //
        System.debug('2) next... ' + step + '|' + this.lead.Application_Type__c);
        if (hasFormValidated()) {
            if (STP_OWNE.equals(step)) {
                step = STP_INIT;
            } else if (STP_INIT.equals(step)) {
                step = STP_QUES;
            } else if (STP_QUES.equals(step)) {
                System.debug('checking... ' + STP_QUES + '|' + step + '|' + this.lead.Application_Type__c);
                if ('Personal'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRIM;    
                } else if ('Personal Self-employed'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRSE;
                } else if ('Business'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    step = STP_COMM;    
                } else if ('Bad Credit'.equals(this.lead.Application_Type__c)) {
                    step = STP_BCRE;    
                } else {
                    System.debug('Any vaule has been found.');
                }
            } else if (STP_PRIM.equals(step)) {
                //if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c)) {
                //    step = STP_PROI;
                //    if (this.incomes.isEmpty()) {
                //        addIncome();
                //    }
                //} else {
                //    step = STP_PRRS;    
                //}
                step = STP_PRRS;
                this.initResidentialStatus();
            }  else if (STP_PROI.equals(step)) {
                step = STP_PRRS;
                this.initResidentialStatus();
            }  else if (STP_PRRS.equals(step)) {
                //if (this.hasLessThan3YearsResidence()) {
                //    step = STP_PRPR;
                //} else {
                    if ('Business'.equals(this.lead.Application_Type__c) ||
                        'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                        step = STP_COOA;
                        //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                        //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                        //    step = STP_PRLO;
                        //} else {
                        //    step = STP_COIN;    
                        //}
                    } else {
                        //step = STP_PRMR;
                        step = STP_PRLO;
                    }
                //}
            } else if (STP_PRPR.equals(step)) {
                //if ('Business'.equals(this.lead.Application_Type__c) ||
                //    'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                //    step = STP_COOA;
                    //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                    //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                    //    step = STP_PRLO;
                    //} else {
                    //    step = STP_COIN;    
                    //}
                //} else {
                //    step = STP_PRMR;    
                //}   
            } else if (STP_COOA.equals(step)) {
                //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                //    step = STP_PRLO;
                //} else {
                //    if ('Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                //        step = STP_PRES;        
                //    } else {
                //        step = STP_COIN;    
                //    }
                //}
                step = STP_PRLO;
            } else if (STP_PRMR.equals(step)) {
                //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c) ||
                //    'Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
                //    step = STP_PRLO;
                //} else {
                //    step = STP_PRES;    
                //}
                step = STP_PRLO;
            } else if (STP_PRLO.equals(step)) {
                if ('Personal'.equals(this.lead.Application_Type__c) ||
                    'Personal Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRES; 
                } else if ('Business'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                    step = STP_COIN;   
                } else if ('Bad Credit'.equals(this.lead.Application_Type__c) ||
                           'Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                    step = STP_PRES;    
                }
            } else if (STP_PRSE.equals(step)) {
                step = STP_PRRS;
                this.initResidentialStatus();
                //if ('Bad Credit Self-employed'.equals(this.lead.Application_Type__c)) {
                //    step = STP_BCR2;    
                //} else {
                //    step = STP_PRRS;
                //}
            } else if (STP_COMM.equals(step)) {
                // step = STP_COOA;
                step = STP_PRRS;
                this.initResidentialStatus();
            } else if (STP_COIN.equals(step)) {
                step = STP_PRES;    
            } else if (STP_BCRE.equals(step)) {
                    //step = STP_BCR2;    
                    step = STP_PRRS;
                    this.initResidentialStatus();
            } else if (STP_BCR2.equals(step)) {
                step = STP_PRRS;
                this.initResidentialStatus();
                //if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                //    step = STP_PRLO;
                //} else {
                //    step = STP_PRES;    
                //}
            }

            //
            //if (STP_PRLO.equals(step)) {
            //    if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c)) {
            //        //Chek for loans
            //        if (this.loans.isEmpty()) {
            //            this.loans.add(
            //                new LoanWrapped(1, new Application_Loan__c()));
            //        }
            //    }
            //    if ('Yes'.equals(app.Do_you_have_any_credit_cards__c)) {
            //        //Chek for loans
            //        if (this.creditCards.isEmpty()) {
            //            this.creditCards.add(
            //                new CreditCardWrapped(1, new Application_Credit_Card__c()));
            //        }
            //    }
            //}

        }
        System.debug('step >> ' + step);
    }    

    public void finish() {
        System.debug('finish...');
        //TODO - add Validations here first
        //saveData();

    }

    //Validations
    private Boolean hasFormValidated() {
        Boolean r = true;
        if ('Closed Lead'.equals(this.lead.Status__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'This is a Closed Lead. Flow cannot proceed.'));
                r = false;
        }
        if (STP_QUES.equals(step)) {
            if (!this.getIsPersonalLoan()) {
                //Vehicle make
                if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Vehicle_Make__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Vehicle Make: Value required'));
                    r = false;
                }
                //Vehicle Model
                if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Vehicle_Model__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Vehicle Model: Value required'));
                    r = false;
                }
                //Private or dialer
                //if (String.isBlank(this.lead.Purchase_Type__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //            'Private or Dealer: Selection required'));
                //    r = false;
                //}
                //Vehicle Located
                //if (String.isBlank(this.lead.Has_Vehicle_Located__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //            'Vehicle Located: Selection required'));
                //    r = false;
                //} else if ('Y'.equals(this.lead.Has_Vehicle_Located__c) &&
                //           lead.Deposit__c == null){
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //            'Deposit: Numeric value required'));
                //    r = false;
                //}
                //Trade In
                if (String.isBlank(this.lead.Has_Trade_In__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Trade In: Selection required'));
                    r = false;
                } else if ('Y'.equals(this.lead.Has_Trade_In__c)) {
                    if ((this.lead.Trade_In__c == null || this.lead.Trade_In__c == 0.0) &&
                        (this.lead.Payout_On__c == null || this.lead.Payout_On__c == 0.0)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Trade In or Payout On required'));
                        r = false;
                    }
                }
            } else {
                if ('Y'.equals(lead.Is_SelfEmpl_Business__c) && 'N'.equals(lead.Has_Tax_Returns__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'We are not going to be able to assist this client.'));
                    r = false;
                }
            }
            //Loan amount
            //if (this.app.Finance_Amount__c == null || this.app.Finance_Amount__c <= 0) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Loan Amount: a positive numeric value required'));
            //    r = false;
            //}
            if (String.isBlank(this.lead.Vehicle_Usage__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Personal or Business use: Selection required'));
                    r = false;
            } else if ('Business'.equals(this.lead.Vehicle_Usage__c) ||
                       'Bad Credit Business'.equals(this.lead.Application_Type__c)) {
                if (String.isBlank(this.lead.Is_SelfEmpl_Business__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Employee or Self-Employed: Selection required'));
                    r = false;
                }
            }

            if (String.isBlank(this.lead.Has_Clean_Credit_History__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Clean Credit History: Selection required'));
                    r = false;
            }
        } else if (STP_PRIM.equals(step)) {

            if (!hasFullEmploymentValidated()) {
                r = false;
            }

            //Centrellink
            if (String.isBlank(lead.Has_Centrelink_Benefits__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Centrelink Benefits: Selection required'));
                r = false;
            } else if ('Y'.equals(lead.Has_Centrelink_Benefits__c) && !hasCentrelinkValidated()) {
                r = false;
            }

            //Other Income
            // if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c) && !hasIncomeValidated()) {
            //     r  =false;
            // }
            
        //} else if (STP_PRMR.equals(step)) {
            if (this.app.No_of_People__c == 2 || 'Married'.equals(this.app.Marital_Status_1__c) || 'Defacto'.equals(this.app.Marital_Status_1__c)) {
                if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Net_Income_2__c) && !'Unemployed'.equals(this.app.Mode_of_Employment_2__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'How much they earn: Numeric value required'));
                    r = false;    
                }
            }
            if (this.getIsPersonalLoan()) {
                if (String.isBlank(this.lead.Able_Provide_Guarantor__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                        '...are you able provide us with a Guarantor...: value required'));
                        r = false;
                } else if ('Yes'.equals(this.lead.Able_Provide_Guarantor__c)) {
                    if (String.isBlank(this.lead.Guarantor_Property_Owner__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                            'Does the guarantor own their own house?: value required'));
                            r = false;
                    }   
                    if (String.isBlank(this.lead.Guarantor_Fulltime_Employed__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                            'Is the guarantor full-time employed?: value required'));
                            r = false;
                    }  
                }
            }
        } else if (STP_PRRS.equals(step)) {
            if (String.isBlank(this.app.Current_Residence_Status_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Residential Status: Selection required'));
                    r = false;
            } else {
                if ('Mortgage'.equals(this.app.Current_Residence_Status_1__c)) {
                    if (!this.hasMortgageValidated()) {
                        r = false;
                    }
                } else if ('Renting(Private)'.equals(this.app.Current_Residence_Status_1__c) ||
                           'Renting(Agent)'.equals(this.app.Current_Residence_Status_1__c)) {
                    if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Rent_per_month_1__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Rent Per Month: Numeric value required'));
                        r = false;    
                    }
                    // if (String.isBlank(this.lead.Is_On_Lease__c)) {
                    //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //         'On the Lead: Selection required'));
                    //     r = false;
                    // }
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_Moved_in_1__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //                'Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Current_Residence_Years__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Current Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Current_Residence_Months__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Current Residence Months: Value required'));
                        r = false;
                    }
                } else if ('Own Outright'.equals(this.app.Current_Residence_Status_1__c)) {
                    if (this.mortgageProp.Value__c == null || this.mortgageProp.Value__c == 0) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'House value: is required'));
                        r = false;
                    }
                }
            }
            if (this.hasLessThan3YearsResidence()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Please complete at least 3 years of residence'));
                r = false;
            } else {
                this.initResidentialStatus();
                System.debug('hasFormValidated -> previousAddresses: ' + this.previousAddresses);
                if (this.previousAddresses >= 1) {
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_From_1__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //            '1) Previous Address Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Previous_Residence_Years__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '1) Previous Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Months__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '1) Previous Residence Months: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Status_1__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                '1) Previous Address Residential Status: Selection required'));
                        r = false;
                    }
                }
                if (this.previousAddresses >= 2) {
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_From_1b__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //            '2) Previous Address Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Previous_Residence_Yearsb__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '2) Previous Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Monthsb__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '2) Previous Residence Months: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Status_1b__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                '2) Previous Address Residential Status: Selection required'));
                        r = false;
                    }        
                }
                if (this.previousAddresses >= 3) {
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_From_1c__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //            '3) Previous Address Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Previous_Residence_Yearsc__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '3) Previous Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Monthsc__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '3) Previous Residence Months: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Status_1c__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                '3) Previous Address Residential Status: Selection required'));
                        r = false;
                    }        
                }
                if (this.previousAddresses >= 4) {
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_From_1d__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //            '4) Previous Address Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Previous_Residence_Yearsd__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '4) Previous Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Monthsd__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '4) Previous Residence Months: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Status_1d__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                '4) Previous Address Residential Status: Selection required'));
                        r = false;
                    }        
                }
                if (this.previousAddresses >= 5) {
                    //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_From_1e__c)) {
                    //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    //            '5) Previous Address Date Move In: Value required or wrong format (dd/mm/yyyy)'));
                    //    r = false;    
                    //}
                    if (String.isBlank(this.app.Previous_Residence_Years__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '5) Previous Residence Years: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Months__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    '5) Previous Residence Months: Value required'));
                        r = false;
                    }
                    if (String.isBlank(this.app.Previous_Residence_Status_1e__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                '5) Previous Address Residential Status: Selection required'));
                        r = false;
                    }        
                }
            }
        } else if (STP_PRPR.equals(step)) {
            
        } else if (STP_PRLO.equals(step)) {
            if ('Yes'.equals(app.Do_you_have_any_loans_outstanding__c)) {
                if (this.Loans.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'At least a loan should be added.'));
                    r = false;
                } else if(!this.hasLoansValidated()) {
                    r = false;
                }
            }
            if ('Yes'.equals(this.haveCreditCards)) {
                if (this.creditCards.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'At least a credit card should be added.'));
                    r = false;
                } else if(!this.hasCreditCardValidated()) {
                    r = false;
                }
            }
            //Expense Questions
            /*
            if (String.isBlank(this.app.Basic_Living_Expenses_Per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Basic living expenses per month: required'));
                    r = false;
            } else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Basic_Living_Expenses_Per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Basic living expenses per month: Numeric value required'));
                    r = false;
            }
            if (String.isBlank(this.app.Mobile_Phone_Internet_Pay_TV_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Mobile Phone, Internet, Pay TV expenses per month: required'));
                    r = false;
            } else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Mobile_Phone_Internet_Pay_TV_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Mobile Phone, Internet, Pay TV expenses per month: Numeric value required'));
                    r = false;
            }
            if (String.isBlank(this.app.Travel_Transport_Expenses_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Fuel, Travel, Transport expenses per month: required'));
                    r = false;
            } else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Travel_Transport_Expenses_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Fuel, Travel, Transport expenses per month: Numeric value required'));
                    r = false;
            }
            if (String.isBlank(this.app.Childcare_Child_Maintenance_Per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Childcare expenses per month: required'));
                    r = false;
            } else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Childcare_Child_Maintenance_Per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Childcare expenses per month: Numeric value required'));
                    r = false;
            }
            if (String.isBlank(this.app.Insurance_Expenses_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Insurance expenses per month: required'));
                    r = false;
            } else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Insurance_Expenses_per_Month__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Insurance expenses per month: Numeric value required'));
                    r = false;
            }
            */
            //if (String.isBlank(this.app.Other_Expenses_per_Month__c)) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Other expenses per month: required'));
            //        r = false;
            //} else if (!FieldValidationsHelper.isDecimalFormatValid(this.app.Other_Expenses_per_Month__c)) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Other expenses per month: Numeric value required'));
            //        r = false;
            //} else if (NumberUtils.convertToDecimal(this.app.Other_Expenses_per_Month__c, false) > 0 &&
            //    String.isBlank(this.app.Income_Type_Expenses__c)) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Other expenses Type: required'));
            //        r = false;
            //}
        } else if (STP_COIN.equals(step)) {
            if (!this.getHasBadCredit()) {
                if (this.lead.Residual__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Residual: Numeric value required'));
                    r = false;    
                } else if (this.lead.Residual__c < 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Residual: negative values are not allowed'));
                    r = false;    
                }
                if (this.lead.Has_Residual_Questions__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Please select a value for Do you have any questions regarding any features and benefits that we just went through?'));
                    r = false;    
                }
            }
        } else if (STP_BCRE.equals(step)) {
            if (!hasFullEmploymentValidated()) {
                r = false;
            }
            //Centrellink
            if (String.isBlank(lead.Has_Centrelink_Benefits__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Centrelink Benefits: Selection required'));
                r = false;
            } else if ('Y'.equals(lead.Has_Centrelink_Benefits__c) && !hasCentrelinkValidated()) {
                r = false;
            }
            //Other Income
            // if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c) && !hasIncomeValidated()) {
            //     r  =false;
            // }
            // MARITAL STATUS
            if (this.app.No_of_People__c == 2 || 'Married'.equals(this.app.Marital_Status_1__c) || 'Defacto'.equals(this.app.Marital_Status_1__c)) {
                if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Net_Income_2__c) && !'Unemployed'.equals(this.app.Mode_of_Employment_2__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'How much they earn: Numeric value required'));
                    r = false;    
                }
            }
            if (this.getIsPersonalLoan()) {
                if (String.isBlank(this.lead.Able_Provide_Guarantor__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                        '...are you able provide us with a Guarantor...: value required'));
                        r = false;
                } else if ('Yes'.equals(this.lead.Able_Provide_Guarantor__c)) {
                    if (String.isBlank(this.lead.Guarantor_Property_Owner__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                            'Does the guarantor own their own house?: value required'));
                            r = false;
                    }   
                    if (String.isBlank(this.lead.Guarantor_Fulltime_Employed__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                            'Is the guarantor full-time employed?: value required'));
                            r = false;
                    }  
                }
            }
        } else if (STP_PRSE.equals(step)) {
            if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Nature_of_Business__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Nature of your business: Value required'));
                r = false;    
            }
            if (String.isBlank(this.lead.Is_Registered_For_GST__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Registered for GST: Value required'));
                r = false;    
            }
            if (String.isBlank(this.lead.Time_In_Business__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Time in business: Value required'));
                r = false;    
            }
            if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Estimated_profit_per_annum__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Estimated annual net profit for the business: Numeric value required'));
                r = false;    
            }
            if (String.isBlank(this.lead.Has_Tax_Returns__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Have Tax returns: Value required'));
                r = false;    
            } 
            //else {
            //    if ('Y'.equals(this.lead.Has_Tax_Returns__c) &&
            //        !FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Net_Income_1__c)) {
            //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //                    'How much profit: Numeric value required'));
            //        r = false;    
            //    }
            //}
            if (String.isBlank(this.lead.Has_Payed_Wage__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Pay yourself a wage: Value required'));
                r = false;    
            } else {
                if ('Y'.equals(this.lead.Has_Payed_Wage__c) &&
                    !FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Net_Income_1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'How much wage: Numeric value required'));
                    r = false;    
                }
            }
            //Centrellink
            if (String.isBlank(lead.Has_Centrelink_Benefits__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Centrelink Benefits: Selection required'));
                r = false;
            } else if ('Y'.equals(lead.Has_Centrelink_Benefits__c) && !hasCentrelinkValidated()) {
                r = false;
            }
            
            if (!this.hasPreviousEmploymentSE()) {
                r = false;
            }
            //Other Income
            // if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c) && !hasIncomeValidated()) {
            //     r  =false;
            // }
        } else if (STP_COOA.equals(step)) {
            //Validate Other Assets
            if ('Y'.equals(lead.Has_Any_Asset__c)) {
                if (this.otherAssetList.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Please add at least one Other Detail'));
                    r = false; 
                } else {
                    for (ObjectWrapped a: this.otherAssetList) {
                        if (a.data.get('Description__c') == null || String.isBlank(String.valueOf(a.data.get('Description__c')))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Other Asset Detail #' + a.idx + ': value required'));
                            r = false;
                        }
                        if (a.data.get('Value__c') == null || a.data.get('Value__c') == 0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                        'Other Asset Value #' + a.idx + ': numeric value required'));
                            r = false;
                        }
                    }
                }
            }
        }
        System.debug('hasFormValidated... ' + r);
        return r;
    }

    private Boolean hasLoansValidated() {
        Boolean r = true;
        for (LoanWrapped a: this.loans) {
            if (String.isBlank(a.data.Type__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Loan ' + a.idx + ' -  Type: Selection required'));
                r = false;
            }
            if (String.isBlank(a.data.Lender__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Loan ' + a.idx + ' - Lender: Value required'));
                r = false;
            }
            //if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Amount_Owing__c)) {
            // if (a.data.Amount_Owing__c == null) {
            //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //             'Loan ' + a.idx + ' - Amount Owing: Numeric value required'));
            //     r = false;
            // }
            if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Payment__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Loan ' + a.idx + ' - Payment: Numeric value required'));
                r = false;
            }
            if (String.isBlank(a.data.Frequency__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Loan ' + a.idx + ' - Frequency: Selection required'));
                r = false;
            }
            //if (!'Car Loan'.equals(a.data.Type__c)) {
            //    if (String.isBlank(a.data.Paid_On_Time__c)) {
            //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //                 'Loan ' + a.idx + ' - Paid On Time: Selection required'));
            //        r = false;
            //    }
                
            //}
            if (String.isBlank(a.data.Good_Conduct__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Loan ' + a.idx + ' - Good Conduct: Selection required'));
                r = false;
            }
        }
        return r;
    }

    private Boolean hasCreditCardValidated() {
        Boolean r = true;
        for (CreditCardWrapped a: this.creditCards) {
            if (String.isBlank(a.data.Issuer__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Credit Card #' + a.idx + ' -  Issuer: Value required'));
                r = false;
            }
            if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Limit__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Credit Card #' + a.idx + ' - Limit: Numeric value required'));
                r = false;
            }
            if (a.data.Amount_Owing__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Credit Card #' + a.idx + ' - Amount Owing: Numeric value required'));
                r = false;
            }
        }
        return r;
    }

    private Boolean hasIncomeValidated() {
        Boolean r = true;
        if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c)) {
            if (this.incomes.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Other Income: please add an Income.'));
                r = false;
            } else {
                if ((this.incomes.size() + this.centrelinkIncomes.size()) >= 5) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Other Incomes and Centrelink benefits cannot exceed 5 entries together.'));
                    r = false;
                } else {
                    for (IncomeWrapped a: this.incomes) {
                        if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Income__c)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Income #' + a.idx + ' - Income: Numeric value required'));
                            r = false;
                        }
                        if (String.isBlank(a.data.Frequency__c)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Income #' + a.idx + ' - Frequency required'));
                            r = false;
                        }
                    }
                }
            }
        }

        return r;
    }

    private Boolean hasCentrelinkValidated() {
        Boolean r = true;
        if ('Y'.equals(this.lead.Has_Centrelink_Benefits__c)) {
            if (this.centrelinkIncomes.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Centrelink benefit: please add a benefit.'));
            } else {
                //if ((this.incomes.size() + this.centrelinkIncomes.size()) >= 5) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //                    'Centrelink benefits and Other Incomes cannot exceed 5 entries together.'));
                //    r = false;
                //} else {
                    for (IncomeWrapped a: this.centrelinkIncomes) {
                        if (String.isBlank(a.data.Type__c)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Centrelink benefit #' + a.idx + ' - Type: please select a type of benefit'));
                            r = false;
                        }
                        if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Income__c)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Centrelink benefit #' + a.idx + ' - Income: Numeric value required'));
                            r = false;
                        }
                        if (String.isBlank(a.data.Frequency__c)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                    'Centrelink benefit #' + a.idx + ' - Frequency required'));
                            r = false;
                        }
                    }
                //}
            }
        }

        return r;
    }

    private Boolean hasDefaultValidated() {
        Boolean r = true;
        for (DefaultWrapped a: this.defaultList) {
            if (String.isBlank(a.data.Lender__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Default #' + a.idx + ' -  Lender: Value required'));
                r = false;
            }
            if (!FieldValidationsHelper.isDecimalGreaterThanZero(a.data.Total_Amount__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Default #' + a.idx + ' - Total Amount: Numeric value required'));
                r = false;
            }
            if (a.data.Listed_Date__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Default #' + a.idx + ' - Listed Date: Value required'));
                r = false;
            }
        }
        return r;
    }


    private Boolean hasFullEmploymentValidated() {
        Boolean r = true;
        //if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Current_Employer_Name_1__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //                'Employer name: Value required'));
        //    r = false;    
        //}
        if (!'Unemployed'.equals(this.app.Mode_of_Employment_1__c)) {
            // if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Current_Employer_Name_1__c)) {
            //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //                 'Employer name: Value required'));
            //     r = false;    
            // }
            if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.app.Net_Income_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Income After Tax: Numeric value required'));
                r = false;    
            }
        }
        //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_Started_1__c)) {
        if (this.app.Current_Employment_Years__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Current Employment Years: Value required'));
            r = false;
        }
        if (this.app.Current_Employment_Months__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Current Employment Months: Value required'));
            r = false;   
        }
        if (r) {
            //Validate Previous employment
            
            //Validate onther previous emplyment
            if (!hasPreviousEmploymentValidated()) {
                r = false;
            }

            if (r && !getHasCurrentEmploymentMoreThan3Years()) {
                Boolean preEmpOk = true;
                // if (!FieldValidationsHelper.isContainsValidCharacters(this.app.Previous_Employer_Name_1__c) &&
                //     !'Unemployed'.equals(this.app.Previous_Mode_of_Employment_1__c)) {
                //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //                 'Previous Employer name: Value required'));
                //     preEmpOk = false;    
                // }
                //if (!FieldValidationsHelper.isDateFormatValid(this.app.Start_Date_1__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //                'Previous Start time: Value required or wrong format (dd/mm/yyyy)'));
                //    preEmpOk = false;    
                //}
                //if (!FieldValidationsHelper.isDateFormatValid(this.app.Finish_Date_1__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //                'Previous finish time: Value required or wrong format (dd/mm/yyyy)'));
                //    preEmpOk = false;    
                //}
                if (this.app.Previous_Employment_Years__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Prev. Employment - Years: value required'));
                    preEmpOk = false;   
                }
                if (this.app.Previous_Employment_Months__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Prev. Employment - Months: value required'));
                    preEmpOk = false;   
                }
                //if (preEmpOk) {
                //    Date d1 = FieldValidationsHelper.convertDate(this.app.Start_Date_1__c);
                //    Date d2 = FieldValidationsHelper.convertDate(this.app.Finish_Date_1__c);
                //    if (d1 > d2) {
                //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //                'Previous finish time should be greater than start time'));
                //        preEmpOk = false;           
                //    }
                //}

                if (preEmpOk) {
                    
                    if (!hasMoreThan3YearsEmployment()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'The total amount of employment time should be at least 3 years'));
                        r  = false;
                    }

                } else {
                    r  =false;
                }
            }
        }
        return r;
    }

    public Boolean hasLessThan3YearsResidence() {
        //Boolean r = false;
        //Date d = FieldValidationsHelper.convertDate(this.app.Date_Moved_in_1__c);
        //if (this.previousAddresses > 0) {
        //    if (this.app.Date_From_1__c != null) {
        //        d = FieldValidationsHelper.convertDate(this.app.Date_From_1__c);
        //    }
        //    if (this.app.Date_From_1b__c != null) {
        //        d = FieldValidationsHelper.convertDate(this.app.Date_From_1b__c);
        //    }
        //    if (this.app.Date_From_1c__c != null) {
        //        d = FieldValidationsHelper.convertDate(this.app.Date_From_1c__c);
        //    }
        //    if (this.app.Date_From_1d__c != null) {
        //        d = FieldValidationsHelper.convertDate(this.app.Date_From_1d__c);
        //    }
        //    if (this.app.Date_From_1e__c != null) {
        //        d = FieldValidationsHelper.convertDate(this.app.Date_From_1e__c);
        //    }
        //}
        //Integer y = FieldValidationsHelper.getYearsBetween(d);
        //if (y != null && y < 3) {
        //    r = true;
        //}

        Decimal y = 0;
        Decimal m = 0;

        if (String.isNotBlank(this.app.Current_Residence_Years__c)) {
            y += Decimal.valueOf(this.app.Current_Residence_Years__c);
        }
        if (String.isNotBlank(this.app.Current_Residence_Months__c)) {
            m += Decimal.valueOf(this.app.Current_Residence_Months__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Years__c)) {
            y += Decimal.valueOf(this.app.Previous_Residence_Years__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Months__c)) {
            m += Decimal.valueOf(this.app.Previous_Residence_Months__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Yearsb__c)) {
            y += Decimal.valueOf(this.app.Previous_Residence_Yearsb__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Monthsb__c)) {
            m += Decimal.valueOf(this.app.Previous_Residence_Monthsb__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Yearsc__c)) {
            y += Decimal.valueOf(this.app.Previous_Residence_Yearsc__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Monthsc__c)) {
            m += Decimal.valueOf(this.app.Previous_Residence_Monthsc__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Yearsd__c)) {
            y += Decimal.valueOf(this.app.Previous_Residence_Yearsd__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Monthsd__c)) {
            m += Decimal.valueOf(this.app.Previous_Residence_Monthsd__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Yearse__c)) {
            y += Decimal.valueOf(this.app.Previous_Residence_Yearse__c);
        }
        if (String.isNotBlank(this.app.Previous_Residence_Monthse__c)) {
            m += Decimal.valueOf(this.app.Previous_Residence_Monthse__c);
        }
        if (m > 0) {
            y += (m/12.0);
        }
        System.debug('Total residence time: ' + y);
        if (y <= 3.0) {
            return true;
        }
        return false;
    }

    //Select options
    //Questioning & Qualifying
    public List<SelectOption> getAssetTypeOptions() {
        return BusinessParamHelper.getParameterOptions('APP_ASSET_TYPE');
    }

    public List<SelectOption> getVehicleYearOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer cy  = Date.today().year();
        for (Integer i = cy; i >= (cy-15);i--) {
            r.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return r;
    }

    public List<SelectOption> getLongTermOptions() {
        List<SelectOption> r = new List<SelectOption>();
        for (Integer i = 7; i > 0;i--) {
            r.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return r;
    }

    //PRIME
    public Boolean getHasCurrentEmploymentMoreThan3Years() {
        Boolean r = false;
        //Integer y = FieldValidationsHelper.getYearsBetween(this.app.Date_Started_1__c);
        Integer y = 0;
        //if (!'Unemployed'.equals(this.app.Mode_of_Employment_1__c)) {
            if (String.isNotBlank(this.app.Current_Employment_Years__c)) {
                y = Integer.valueOf(this.app.Current_Employment_Years__c);
            }
        //}
        if (y >= 3) {
            r = true;
        }
        return r;
    }

    public List<SelectOption> getEmploymentTypeOptions() {
        return BusinessParamHelper.getParameterOptions('EMPLOYMENT_TYPE');
    }

    public List<SelectOption> getPartnerEmploymentTypeOptions() {
        List<SelectOption> r = this.getEmploymentTypeOptions();
        //r.add(new SelectOption('Unemployed','Unemployed'));
        return r;
    }

    public List<SelectOption> getPaymentFrequencyOptions() {
        return BusinessParamHelper.getParameterOptions('PAYMENT_FREQUENCY');
    }

    public List<SelectOption> getOtherIncomeTypeOptions() {
        return BusinessParamHelper.getParameterOptions('OTHER_INCOMETYPE');
    }

    public List<SelectOption> getCentrelinkBenefitOptions() {
        return BusinessParamHelper.getParameterOptions('CENTLINK_BENEFITS', true);
    }

    //PRIME - Residential Status
    public List<SelectOption> getResidentialStatusOptions() {
        return BusinessParamHelper.getParameterOptions('RESIDENTIAL_STATUS', true);
    }

    //PRIME - Marital Status
    public List<SelectOption> getMaritalStatusOptions() {
        return BusinessParamHelper.getParameterOptions('MARITAL_STATUS');
    }


    //Loans
    public void addLoan() {
        //Validate current loans
        if (hasLoansValidated()) {
            if (this.loans.size() < 6) {
                //Add new one
                this.loans.add(new LoanWrapped(this.loans.size()+1, new Application_Loan__c()));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 6 Loans are allowed.'));
                System.debug('To many Loans...');
            }
        }
    }

    public void removeLoan() {
        System.debug('loanSelected >> ' + loanSelected);
        //Check for residential status
        if (loanSelected == 0) {
            if ('Personal'.equals(this.app.Application_Type__c) && 
                'Mortgage'.equals(this.app.Current_Residence_Status_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Loan can not be removed due to Residential Status is Mortgage.'));
            }
        } else {
            LoanWrapped o = this.loans.get(loanSelected-1);
            if (o != null) {
                //Remove loan
                if ('Car Loan'.equals(o.data.Type__c) && o.idAux != null) {
                    delete [SELECT Id FROM Application_Other_Asset__c WHERE Id = :o.idAux];
                } else if (o.data.Id != null) {
                    delete o.data;
                }
                //remove fron list
                this.loans.remove(loanSelected-1);
                this.recalculateLoanIdx();
            }
        }
    }
    private void recalculateLoanIdx() {
        Integer i = 1;
        for (LoanWrapped a : this.loans) {
            a.setIndex(i++);
        }
    }

    public class LoanWrapped {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Loan__c data {set;get;}
        public Id idAux {set;get;}

        public LoanWrapped(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = new Application_Loan__c();
            this.data.Order__c = Decimal.valueOf(this.idx);
        }

        public LoanWrapped(Integer idx, Application_Loan__c obj) {
            this.idx = idx;
            this.data = obj;
            this.data.Order__c = Decimal.valueOf(this.idx);
            this.isRemoved = false;
        }

        public void setIndex(Integer idx) {
            this.idx = idx;
            this.data.Order__c = Decimal.valueOf(this.idx);
        }
    }

    //Credit Cards
    public void addCreditCard() {
        //Validate current loans
        if (hasCreditCardValidated()) {
            //Add new one
            this.creditCards.add(new CreditCardWrapped(this.creditCards.size()+1, new Application_Credit_Card__c()));
        }
    }

    public void removeCreditCard() {
        CreditCardWrapped o = this.creditCards.get(cardSelected-1);
        if (o != null) {
            //Remove loan
            if (o.data.Id != null) {
                delete o.data;
            }
            //remove fron list
            this.creditCards.remove(cardSelected-1);
            this.recalculateCreditCardsIdx();
        }

    }

    private void recalculateCreditCardsIdx() {
        Integer i = 1;
        for (CreditCardWrapped a : this.creditCards) {
            a.idx = i++;
        }
    }

    public class CreditCardWrapped {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Credit_Card__c data {set;get;}

        public CreditCardWrapped(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = null;
        }

        public CreditCardWrapped(Integer idx, Application_Credit_Card__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }

    //Other Income
    public void addIncome() {
        //Validate current loans
        if (this.incomes.isEmpty() || hasIncomeValidated()) {
            Application_Income__c inc = new Application_Income__c();
            inc.Type__c = 'Rental Income';
            inc.Frequency__c = 'Monthly';
            inc.Applicant__c = '1';
            //Add new one
            this.incomes.add(new IncomeWrapped(this.incomes.size()+1, inc));
        }
    }

    public void removeIncome() {
        IncomeWrapped o = this.incomes.get(incomeSelected-1);
        if (o != null) {
            //Remove loan
            if (o.data.Id != null) {
                delete o.data;
            }
            //remove fron list
            this.incomes.remove(incomeSelected-1);
            this.recalculateIncomesIdx(this.incomes);
        }

    }

    private void recalculateIncomesIdx(List<IncomeWrapped> d) {
        Integer i = 1;
        for (IncomeWrapped a : d) {
            a.setIndex(i++);
        }
    }

    //Centrelink Benefits
    public void addCentrelink() {
        //Validate current loans
        if (this.centrelinkIncomes.isEmpty() || hasCentrelinkValidated()) {
            Application_Income__c inc = new Application_Income__c();
            inc.Frequency__c = 'Fortnightly';
            inc.Applicant__c = '1';
            //Add new one
            this.centrelinkIncomes.add(new IncomeWrapped(this.centrelinkIncomes.size()+1, inc));
        }
    }

    public void removeCentrelink() {
        IncomeWrapped o = this.centrelinkIncomes.get(centrelinkSelected-1);
        if (o != null) {
            //Remove loan
            if (o.data.Id != null) {
                delete o.data;
            }
            //remove fron list
            this.centrelinkIncomes.remove(centrelinkSelected-1);
            this.recalculateIncomesIdx(this.centrelinkIncomes);
        }

    }

    public class IncomeWrapped {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Income__c data {set;get;}

        public IncomeWrapped(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = new Application_Income__c();
            this.data.Order__c = Decimal.valueOf(this.idx);
        }

        public IncomeWrapped(Integer idx, Application_Income__c obj) {
            this.idx = idx;
            this.data = obj;
            this.data.Order__c = Decimal.valueOf(this.idx);
            this.isRemoved = false;
        }

         public void setIndex(Integer idx) {
            this.idx = idx;
            this.data.Order__c = Decimal.valueOf(this.idx);
        }
    }

    //Commercial
    public Boolean getHasBusinessMoreThan2Years() {
        Boolean r = false;
        if (String.isNotBlank(lead.Time_In_Business__c) && lead.Time_In_Business__c.isNumeric()) {
            Integer a = Integer.valueOf(lead.Time_In_Business__c);
            if (a >= 2) {
                r = true;
            }
        }
        return r;
    }

    public Boolean getIsLowDoc() {
        Boolean r = false;
        if (('Business'.equals(this.lead.Application_Type__c) || 'Bad Credit Business'.equals(this.lead.Application_Type__c)) 
            && 'N'.equals(this.lead.Has_Tax_Returns__c)) {
            r = true;
        }
        return r;
    }

    //Option values
    public List<SelectOption> getBusinessStOptions() {
        return BusinessParamHelper.getParameterOptions('BUSINESS_STRUCTURE');
    }

    //Bad Credit
    public void addDefault() {
        //Validate current loans
        if (hasDefaultValidated()) {
            //Add new one
            this.defaultList.add(new DefaultWrapped(this.defaultList.size()+1, new Application_Default__c()));
        }
    }

    public void removeDefault() {
        DefaultWrapped o = this.defaultList.get(defaultSelected-1);
        if (o != null) {
            //Remove loan
            if (o.data.Id != null) {
                delete o.data;
            }
            //remove fron list
            this.defaultList.remove(defaultSelected-1);
            this.recalculateDefaultsIdx();
        }

    }

    private void recalculateDefaultsIdx() {
        Integer i = 1;
        for (DefaultWrapped a : this.defaultList) {
            a.idx = i++;
        }
    }

    public class DefaultWrapped {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Default__c data {set;get;}

        public DefaultWrapped(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = null;
        }

        public DefaultWrapped(Integer idx, Application_Default__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }
    }

    //Presenting and closing
    public PageReference goComparisonEngine() {
         manageCustomOpportunity(OPPSTATUS_QUOSENT);
        if (String.isBlank(this.oppId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Not found an Opportunity for this deal'));
            return null;
        }

        PageReference r = Page.LenderComparisonFilter;
        r.getParameters().put('id', this.oppId);
        r.getParameters().put('P', 'LEADFLOW');
        return r;
    }

    public PageReference goSalesTool() {
        this.saveData(false);
        //this.manageAccount();
        this.manageCustomOpportunity(OPPSTATUS_APPFORMRECEIVED);
        if (String.isBlank(this.oppId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Not found an Opportunity for this deal'));
            return null;
        }
        PageReference r = Page.OppApplication;
        r.getParameters().put('id', this.oppId);
        return r;
    }
    
    public PageReference goSendEmail() {
        manageCustomOpportunity(OPPSTATUS_APPFORMSENT);
        if (String.isBlank(this.oppId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Not found an Opportunity for this deal'));
            return null;
        }
        PageReference r = Page.OppEmailTemplateSelector;
        r.getParameters().put('id', this.oppId);
        return r;
    }

    public PageReference goOpportunity() {
        this.manageAccount();
        manageCustomOpportunity(OPPSTATUS_BEOPPORTUNITY);
        saveData(false);
        if (String.isBlank(this.oppId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Not found an Opportunity for this deal'));
            return null;
        }

        PageReference r = new PageReference('/' + this.oppId);
        r.getParameters().put('id', this.oppId);
        return r;
    }

    private Custom_Opportunity__c getCustomOpportunity() {
        Custom_Opportunity__c r = null;
        List<Custom_Opportunity__c> opps = [SELECT Id, Application__c, Notes__c, Status__c, Reason_for_Closure__c, Date_Closed_or_Settled__c, State__c
                                            FROM Custom_Opportunity__c 
                                            WHERE Lead__c = :this.lead.Id 
                                            AND Status__c NOT IN ('Closed Opportunity','Settled')];
        if (!opps.isEmpty()) {
            r  = opps.get(0);
        }
        return r;
    }

    private void manageCustomOpportunity(String status) {
        this.opp = getCustomOpportunity();
        if (this.opp == null) {
            this.opp = new Custom_Opportunity__c();
            this.opp.Lead__c = this.lead.Id;
            this.opp.Application__c = this.lead.Application__c;
            this.opp.Name = this.lead.Name;
            this.opp.First_Name__c = this.Lead.First_Name__c;
            this.opp.Last_Name__c = this.Lead.Last_Name__c;
            this.opp.Account__c = this.lead.Account__c;
            this.opp.Home_Phone__c = this.lead.Home_Phone__c;
            this.opp.Work_Phone__c = this.lead.Work_Phone__c;
            this.opp.Mobile_Number__c = this.lead.Mobile_Number__c;
            this.opp.Email_Address__c = this.lead.Email_Address__c;
            this.opp.Notes__c = this.lead.Notes__c;
            this.opp.Status__c = status;
            this.opp.State__c = this.lead.State__c;
            if (String.isBlank(this.opp.State__c)) {
                this.opp.State__c = PostcodeHelper.getState(this.lead.Postcode__c);
            }
            //o.OwnerId = UserInfo.getUserId();
            this.opp.OwnerId = UserInfo.getUserId();
            insert this.opp;
            System.debug('Opportunity created!');
        } else {
            if (this.opp.Application__c == null || this.lead.Application__c != this.opp.Application__c) {
                this.opp.Application__c = this.lead.Application__c;
                this.opp.State__c = this.lead.State__c;
                if (String.isBlank(this.opp.State__c)) {
                    this.opp.State__c = PostcodeHelper.getState(this.lead.Postcode__c);
                }
                this.opp.First_Name__c = this.Lead.First_Name__c;
                this.opp.Last_Name__c = this.Lead.Last_Name__c;
                update this.opp;
            }
        }
        this.oppId = this.opp.Id;
    }

    private void manageAccount() {
        System.debug('Managing account...');
        if (this.lead.Account__c == null) {
            Set<String> d = new Set<String>();
            d.add(this.lead.Mobile_Number__c);
            //Find an account
            List<Account> accountList = SOQLSingletonQueries.searchAccounts(this.lead);
            Account a = null;
            User curUser = null;
            User sysGen = SOQLSingletonQueries.recs().sysGenUser;
            if (accountList != null && !accountList.isEmpty()) {
                System.debug('Account found it');
                a = accountList.get(0);
                
                if (a.OwnerId != sysGen.Id) {
                    a.OwnerId = UserInfo.getUserId();
                    update a;
                } else {
                    //Find current user
                    curUser = [SELECT Id, Name, isActive FROM User WHERE Id = :a.OwnerId AND isActive = true];
                    if (curUser == null) {
                        //
                        a.OwnerId = UserInfo.getUserId();
                        update a;
                    }
                }
            } else {
                System.debug('Creating a new account...');
                //Not found it, create one
                Id persAccRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                a = new Account(RecordTypeId = persAccRecTypeId);
                a.FirstName = this.lead.First_Name__c;
                a.LastName = this.lead.Last_Name__c;
                a.PersonMobilePhone = this.lead.Mobile_Number__c;
                a.PersonEmail = this.lead.Email_Address__c;
                a.OwnerId = UserInfo.getUserId();
                insert a;
                System.debug('Account created.');
            }
            if (this.lead.OwnerId == sysGen.Id && curUser == null) {
                //Account already has an active owner (check if it is a sales consultant)
                System.debug('Assigning an owner to the Lead...');
                this.lead.OwnerId = UserInfo.getUserId();
            }
            this.lead.Account__c = a.Id;
            System.debug('Saving account...');
            update this.lead;
        }
    }

    //Loans
    private void syncApplicationLoans(List<LoanWrapped> loanList) {

        //reset current values
        // Loans 1, 2 and 3 only reserved for Mortgages
        ////Loan #1
        //this.app.Loan_Type_1__c = null;
        //this.app.Other_Loans_Lender_1__c = null;
        //this.app.Loans_Amount_Owing_1__c = null;
        //this.app.Loans_Monthly_Payments_1__c = null;
        //this.app.Loan_Frequency_1__c = null;
        //this.app.Loan_Repaid_1__c = false;
        ////Loan #2
        //this.app.Loan_Type_2__c = null;
        //this.app.Other_Loans_Lender_2__c = null;
        //this.app.Loans_Amount_Owing_2__c = null;
        //this.app.Loans_Monthly_Payments_2__c = null;
        //this.app.Loan_Frequency_2__c = null;
        //this.app.Loan_Repaid_2__c = false;
        ////Loan #3
        //this.app.Loan_Type_3__c = null;
        //this.app.Other_Loans_Lender_3__c = null;
        //this.app.Loans_Amount_Owing_3__c = null;
        //this.app.Loans_Monthly_Payments_3__c = null;
        //this.app.Loan_Frequency_3__c = null;
        //this.app.Loan_Repaid_3__c = false;
        //Loan #4
        //this.app.Loan_Type_4__c = null;
        //this.app.Other_Loans_Lender_4__c = null;
        //this.app.Loans_Amount_Owing_4__c = null;
        //this.app.Loans_Monthly_Payments_4__c = null;
        //this.app.Loan_Frequency_4__c = null;
        //this.app.Loan_Repaid_4__c = false;
        ////Loan #5
        //this.app.Loan_Type_5__c = null;
        //this.app.Other_Loans_Lender_5__c = null;
        //this.app.Loans_Amount_Owing_5__c = null;
        //this.app.Loans_Monthly_Payments_5__c = null;
        //this.app.Loan_Frequency_5__c = null;
        //this.app.Loan_Repaid_5__c = false;
        ////Loan #6
        //this.app.Loan_Type_6__c = null;
        //this.app.Other_Loans_Lender_6__c = null;
        //this.app.Loans_Amount_Owing_6__c = null;
        //this.app.Loans_Monthly_Payments_6__c = null;
        //this.app.Loan_Frequency_6__c = null;
        //this.app.Loan_Repaid_6__c = false;

        if (loanList != null && !loanList.isEmpty()) {
            Integer i = 4;
            List<Application_Loan__c> otherLoans = new List<Application_Loan__c>();
            List<Application_Other_Asset__c> carLoans = new List<Application_Other_Asset__c>();
            for (LoanWrapped a : loanList) {
                if ('Car Loan'.equals(a.data.Type__c)) {
                    Application_Other_Asset__c c = new Application_Other_Asset__c(
                        RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(
                            ApplicationService.VEHICLE_ASSET_TYPE));
                    if (a.idAux != null) {
                        c.Id = a.idAux;
                    } else {
                        c.Description__c = '.';
                    }
                    c.Application__c = this.app.Id;
                    c.Value__c = 0.00;
                    c.Has_Loan__c = 'Y';
                    c.Lender__c = a.data.Lender__c;
                    c.Amount_Owing__c = a.data.Amount_Owing__c;
                    c.Payment__c = a.data.Payment__c;
                    c.Frequency__c = a.data.Frequency__c;
                    c.Is_Payout__c = a.data.Is_Payout__c;
                    c.Good_Conduct__c = a.data.Good_Conduct__c;
                    carLoans.add(c);
                } else {
                    if (a.data.Application__c == null) {
                        a.data.Application__c = this.app.Id;
                    }
                    a.data.Order__c = otherLoans.size() + 1;
                    otherLoans.add(a.data);
                }
            }
            if (!otherLoans.isEmpty()) {
                upsert otherLoans;
            }
            if (!carLoans.isEmpty()) {
                upsert carLoans;
            }
        }
        
    }

    private List<LoanWrapped> getApplicationLoans() {
        List<LoanWrapped> r = new List<LoanWrapped>();
        System.debug('getApplicationLoans...');
        
        ////Mortgage - residential status 
        //if ('Mortgage'.equals(app.Current_Residence_Status_1__c)) {
        //    this.app.Property_Has_Loan_1__c = 'Y';
        //    this.app.Loan_Type_1__c = 'Mortgage';
        //    if (String.isNotBlank(this.app.Property_Address_1__c)) {
        //        this.app.Property_Address_1__c = '.';
        //    }
        //}

        if (this.app.Id != null) {
            LoanWrapped lw = null;
            // Loan 1, 2, and 3 Only reerved for Mortgages
            ////Loan #1
            //if (String.isNotBlank(this.app.Loan_Type_1__c) || this.app.Loans_Monthly_Payments_1__c > 0) {
            //    lw = loansMap.get(1);
            //    if (lw == null) {
            //        lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    }
            //    lw.data.Type__c = this.app.Loan_Type_1__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_1__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_1__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_1__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_1__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_1__c;
            //    r.add(lw);
            //}
            ////Loan #2
            //if (String.isNotBlank(this.app.Loan_Type_2__c) || this.app.Loans_Monthly_Payments_2__c > 0) {
            //    lw = loansMap.get(2);
            //    if (lw == null) {
            //        lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    }
            //    lw.data.Type__c = this.app.Loan_Type_2__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_2__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_2__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_2__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_2__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_2__c;
            //    r.add(lw);
            //}
            ////Loan #3
            //if (String.isNotBlank(this.app.Loan_Type_3__c) || this.app.Loans_Monthly_Payments_3__c > 0) {
            //    lw = loansMap.get(3);
            //    if (lw == null) {
            //        lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    }
            //    lw.data.Type__c = this.app.Loan_Type_3__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_3__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_3__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_3__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_3__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_3__c;
            //    r.add(lw);
            //}
            ////Loan #4
            //if (String.isNotBlank(this.app.Loan_Type_4__c) || this.app.Loans_Monthly_Payments_4__c > 0) {
            //    lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    lw.data.Type__c = this.app.Loan_Type_4__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_4__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_4__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_4__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_4__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_4__c;
            //    r.add(lw);
            //}
            ////Loan #5
            //if (String.isNotBlank(this.app.Loan_Type_5__c) || this.app.Loans_Monthly_Payments_5__c > 0) {
            //    lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    lw.data.Type__c = this.app.Loan_Type_5__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_5__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_5__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_5__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_5__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_5__c;
            //    r.add(lw);
            //}
            ////Loan #6
            //if (String.isNotBlank(this.app.Loan_Type_6__c) || this.app.Loans_Monthly_Payments_6__c > 0) {
            //    lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
            //    lw.data.Type__c = this.app.Loan_Type_6__c;
            //    lw.data.Lender__c = this.app.Other_Loans_Lender_6__c;
            //    lw.data.Amount_Owing__c = this.app.Loans_Amount_Owing_6__c;
            //    lw.data.Payment__c = this.app.Loans_Monthly_Payments_6__c;
            //    lw.data.Frequency__c = this.app.Loan_Frequency_6__c;
            //    lw.data.Is_Payout__c = this.app.Loan_Repaid_6__c;
            //    r.add(lw);
            //}

            for (ObjectWrapped a :this.vehicleAssetList) {
                lw = new LoanWrapped(r.size()+1, new Application_Loan__c());
                lw.idAux = a.data.Id;
                lw.data.Type__c = 'Car Loan';
                lw.data.Lender__c = (String)a.data.get('Lender__c');
                lw.data.Amount_Owing__c = (Decimal)a.data.get('Amount_Owing__c');
                lw.data.Payment__c = (Decimal)a.data.get('Payment__c');
                lw.data.Frequency__c = (String)a.data.get('Frequency__c');
                lw.data.Is_Payout__c = (Boolean)a.data.get('Is_Payout__c');
                lw.data.Good_Conduct__c = (String)a.data.get('Good_Conduct__c');
                r.add(lw);   
            }

            List<Application_Loan__c> d = [SELECT Amount_Owing__c, Frequency__c, Good_Conduct__c, Is_Payout__c, 
                                                  Lender__c, Paid_On_Time__c, Payment__c, Type__c, Application__c,
                                                  Order__c 
                                           FROM Application_Loan__c WHERE Application__c = :this.app.Id ORDER BY Order__c];
            //Map<Integer, LoanWrapped> loansMap = new Map<Integer, LoanWrapped>();
            if (!d.isEmpty()) {
                for (Application_Loan__c a : d) {
                    //Integer idx = Integer.valueOf(a.Order__c);
                    r.add(new LoanWrapped(r.size()+1, a));
                    //loansMap.put(idx, lw);
                }
            }
        }

        return r;
    }


    //Credict Cards
    private void syncCreditCards(List<Application_Credit_Card__c> cards) {
        if (cards == null || cards.isEmpty()) {
            delete [SELECT Id FROM Application_Credit_Card__c WHERE Application__c = :this.app.Id];
            //for (CreditCardWrapped a : this.creditCards) {
            //    a.data.Id = null;
            //    cards.add(a.data);
            //}
        } else {
            upsert cards;
        }
    }

    private List<CreditCardWrapped> getApplicationCreditCards() {
        System.debug(' getApplicationCreditCards...');
        List<CreditCardWrapped> r = new List<CreditCardWrapped>();
        if (this.app.Id != null) {
            //List<Application_Credit_Card__c> d = [SELECT Amount_Owing__c, Issuer__c, Limit__c, Monthly_Payment__c, Application__c 
            //                                 FROM Application_Credit_Card__c WHERE Application__c = :this.app.Id ORDER BY Name];
            //Integer i = 1;
            //for (Application_Credit_Card__c a : d) {
            //    r.add(new CreditCardWrapped(i++, a));
            //}
            List<Application_Credit_Card__c> d = ApplicationService.getApplicationCreditCards(this.app.Id);
            CreditCardWrapped c = null;
            for (Application_Credit_Card__c a: d) {
                c = new CreditCardWrapped(r.size()+1, a);
                r.add(c);
            }
        }
        return r;
    }

    private void syncResidentialStatus(Boolean hasValidation) {
        System.debug('Saving Residential Status... ' + this.step);
        this.calculateResidentialDates();
        // Save mortgage
        if ('Mortgage'.equals(this.app.Current_Residence_Status_1__c)) {
            System.debug('processing as a mortgage property...');
            if (hasValidation && this.hasMortgageValidated()) {
                this.mortgageProp.Has_Loan__c = 'Y';
                if (String.isBlank(this.mortgageProp.Description__c)) {
                    this.mortgageProp.Description__c = '.';
                }
                if (this.mortgageProp.Application__c == null) {
                    this.mortgageProp.Application__c = this.app.Id;
                }
                upsert this.mortgageProp;
            }
        } else if('Own Outright'.equals(this.app.Current_Residence_Status_1__c) && this.mortgageProp.Value__c != null && this.mortgageProp.Value__c > 0.0) {
            System.debug('processing as an Own Outright property...');
            if (String.isBlank(this.mortgageProp.Description__c)) {
                this.mortgageProp.Description__c = '.';
            }
            if (this.mortgageProp.Application__c == null) {
                this.mortgageProp.Application__c = this.app.Id;
            }
            this.mortgageProp.Has_Loan__c = 'N';
            this.mortgageProp.Payment__c = null;
            this.mortgageProp.Frequency__c = null;
            this.mortgageProp.Lender__c = null;
            this.mortgageProp.Amount_Owing__c = null;
            upsert this.mortgageProp;
        } else {
            System.debug('reseting property...');
            if (this.mortgageProp.Id != null) {
                delete this.mortgageProp;
            }
            this.mortgageProp = new Application_Other_Asset__c(
                            RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get(
                                ApplicationService.PROPERTY_ASSET_TYPE));
        }
    }

    private List<Application_Loan__c> getLoansList() {
        List<Application_Loan__c> r = new List<Application_Loan__c>();
        if (this.loans != null) {
            for (LoanWrapped lw: this.loans) {
                r.add(lw.data);
            }
        }
        return r;
    }

    //Incomes
    private List<IncomeWrapped> getApplicationIncomes() {
        List<IncomeWrapped> rslt = new List<IncomeWrapped>();
        //Centrelink Benefits
        this.centrelinkIncomes = new List<IncomeWrapped>();
        if (this.app.Id != null) {
            List<Application_Income__c> d = [SELECT Application__c, Type__c, Income__c, Order__c, Frequency__c
                                             FROM Application_Income__c WHERE Application__c = :this.app.Id 
                                             AND Applicant__c = '1' ORDER BY Name];
            Map<Integer, IncomeWrapped> incomesMap = new Map<Integer, IncomeWrapped>();
            IncomeWrapped lw = null;
            System.debug('total income loaded: ' + d.size());
            if (!d.isEmpty()) {
                for (Application_Income__c a : d) {

                    if ('Child Support'.equals(a.Type__c) ||
                        'Family Part A & B'.equals(a.Type__c) ||
                        'Rent Assistance'.equals(a.Type__c) ||
                        'Parenting Payment Single'.equals(a.Type__c) ||
                        'Parenting Payment Partnered'.equals(a.Type__c) ||
                        'Newstart'.equals(a.Type__c)) {

                        this.centrelinkIncomes.add(new IncomeWrapped(this.centrelinkIncomes.size(), a));
                    } else {
                        rslt.add(new IncomeWrapped(rslt.size(), a));
                    }
                }
            }
        }
        this.recalculateIncomesIdx(this.centrelinkIncomes);
        System.debug('Total centrelinkIncomes list: ' + this.centrelinkIncomes.size());
        return rslt;
    }

    private void syncApplicationIncomes(List<Application_Income__c> incomes) {
        if (incomes != null && !incomes.isEmpty()) {
            Integer i = 1;
            for (Application_Income__c a : incomes) {
                if (a.Id == null) {
                    a.Application__c = this.app.Id;
                }
                a.Order__c = i++;
            }
            upsert incomes;
        }
    }

    private void syncCentrelinkBenefits() {
        List<Application_Income__c> incLst = new List<Application_Income__c>();
        List<Application_Income__c> incomeList = getIncomeList(this.centrelinkIncomes);
        if ('Y'.equals(this.lead.Has_Centrelink_Benefits__c)) {
            incLst.addAll(incomeList);
        } else {
            // Delete all
            System.debug('Deleting centrelink incomes...' + incomeList.size());
            if (!incomeList.isEmpty()) {
                List<Application_Income__c> delIncomeList = new List<Application_Income__c>();
                for (Application_Income__c a : incomeList) {
                    if (a.Id != null) {
                        delIncomeList.add(a);
                    }
                }
                if (!delIncomeList.isEmpty()) {
                    delete delIncomeList;
                }
                incLst = new List<Application_Income__c>();
            }
        }
        incomeList = getIncomeList(this.incomes);
         if ('Yes'.equals(this.app.Do_you_receive_other_income_1__c) && !incomeList.isEmpty()) {
            incLst.addAll(incomeList);
         }
        syncApplicationIncomes(incLst);
    }

    private List<Application_Income__c> getIncomeList(List<IncomeWrapped> d) {
        List<Application_Income__c> r = new List<Application_Income__c>();
        if (d != null) {
            for (IncomeWrapped lw: d) {
                r.add(lw.data);
            }
        } 
        return r;
    }

    public Boolean getHasBadCredit() {
        Boolean r = false;
        if (String.isNotBlank(this.lead.Application_Type__c) && 
            this.lead.Application_Type__c.contains('Bad Credit')) {
            r  = true;
        }
        return r;
    }

    //Previous employment
    public class EmploymentWrapped {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Employment__c data {set;get;}

        public EmploymentWrapped(Integer idx) {
            this.idx = idx;
            this.isRemoved = false;
            this.data = new Application_Employment__c();
        }

        public EmploymentWrapped(Integer idx, Application_Employment__c obj) {
            this.idx = idx;
            this.data = obj;
            this.isRemoved = false;
        }

         public void setIndex(Integer idx) {
            this.idx = idx;
        }

        public Integer getViewIndex() {
            return this.idx + 1;   
        }
    }

    private List<EmploymentWrapped> getApplicationEmployments() {
        List<EmploymentWrapped> r = new List<EmploymentWrapped>();
        if (this.app.Id != null) {
            List<Application_Employment__c> d = [
                SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
                       Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
                       Work_Address__c, Phone__c, Employment_Months__c, Employment_Years__c,
                       Unit_Number__c, Street_Number__c, Street_Type__c, 
                       Suburb__c, Postcode__c, State__c,Address_Line_1__c, Overseas_State__c,
                       Overseas_City__c, Address_Line_2__c 
                FROM Application_Employment__c WHERE Application__c = :this.app.Id
                ORDER BY Start_Date__c DESC
            ];

            Integer i = 1;
            for (Application_Employment__c a : d) {
                r.add(new EmploymentWrapped(i++, a));
            }
        }
        return r;
    }

     public void addEmployment() {
        //Validate current loans
        if (hasPreviousEmploymentValidated()) {
            if (this.emptList.size() < 4) {
                //Add new one
                this.emptList.add(new EmploymentWrapped(this.emptList.size()+1, new Application_Employment__c()));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 5 Employments are allowed.'));
                System.debug('To many Employments...');
            }
        }
    }

    public void removeEmployment() {
        EmploymentWrapped o = this.emptList.get(employSelected-1);
        if (o != null) {
            //Remove loan
            if (o.data.Id != null) {
                delete o.data;
            }
            //remove fron list
            this.emptList.remove(employSelected-1);
            this.recalculateEmploymentIdx();
        }
    }

    private void recalculateEmploymentIdx() {
        Integer i = 1;
        for (EmploymentWrapped a : this.emptList) {
            a.setIndex(i++);
        }
    }

    public Boolean hasMoreThan3YearsEmployment() {
        Boolean r = false;
        //Create list
        //List<Date> d1 = new List<Date>();
        //List<Date> d2 = new List<Date>();

        ////Add current employment
        //Date a = FieldValidationsHelper.convertDate(this.app.Date_Started_1__c);
        //Date b = null;
        //if (a != null) {
        //    d1.add(a);
        //    d2.add(Date.today());
        //}
        ////Previous employment
        //if (String.isNotBlank(this.app.Start_Date_1__c)) {
        //    a = FieldValidationsHelper.convertDate(this.app.Start_Date_1__c);
        //    b = FieldValidationsHelper.convertDate(this.app.Finish_Date_1__c);
        //    if (a != null && b != null) {
        //        d1.add(a);
        //        d2.add(b);
        //    }   
        //}

        //if (!this.emptList.isEmpty()) {
        //    for (EmploymentWrapped e : this.emptList) {
        //        if (e.data.Start_Date__c != null && e.data.Finish_Date__c != null) {
        //            d1.add(e.data.Start_Date__c);
        //            d2.add(e.data.Finish_Date__c);
        //        }
        //    }
        //}

        //Decimal y = FieldValidationsHelper.getYearsBetween(d1, d2);
        //if (y != null && y >= 3.0) {
        //    r = true;
        //}

        Decimal y = 0.0;
        Decimal m = 0.0;
        // Current Employment
        //if (!'Unemployed'.equals(this.app.Mode_of_Employment_1__c)) {
            if (String.isNotBlank(this.app.Current_Employment_Years__c)) {
                y += Decimal.valueOf(this.app.Current_Employment_Years__c);
            }
            if (String.isNotBlank(this.app.Current_Employment_Months__c)) {
                m += Decimal.valueOf(this.app.Current_Employment_Months__c);
            }
        //}
        // Previous Employment
        //if (!'Unemployed'.equals(this.app.Previous_Mode_of_Employment_1__c)) {
            if (String.isNotBlank(this.app.Previous_Employment_Years__c)) {
                y += Decimal.valueOf(this.app.Previous_Employment_Years__c);
            }
            if (String.isNotBlank(this.app.Previous_Employment_Months__c)) {
                m += Decimal.valueOf(this.app.Previous_Employment_Months__c);
            }
        //}
        if (!this.emptList.isEmpty()) {
            for (EmploymentWrapped e : this.emptList) {
                //if (!'Unemployed'.equals(e.data.Employment_Type__c)) {
                    if (String.isNotBlank(e.data.Employment_Years__c)) {
                        y += Decimal.valueOf(e.data.Employment_Years__c);
                    }
                    if (String.isNotBlank(e.data.Employment_Months__c)) {
                        m += Decimal.valueOf(e.data.Employment_Months__c);
                    }
                //}
            }
        }
        if (m > 0) {
            y += m/12.0;
        }
        if (y >= 3.0) {
            r = true;
        }
        return r;
    }

    private void calculateEmploymentDates() {
        // reference day
        Date t = Date.today();
        if (String.isNotBlank(this.app.Current_Employment_Years__c)) {
            // Calc Start Date current employment
            t = t.addYears(Integer.valueOf(this.app.Current_Employment_Years__c)*(-1));
            if (String.isNotBlank(this.app.Current_Employment_Months__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Current_Employment_Months__c)*(-1));
            }
            this.app.Date_Started_1__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            //System.debug('Date_Started_1__c: ' + this.app.Start_Date_1__c + '|' + t);
        } else {
            this.app.Date_Started_1__c = null;
        }
        if (String.isNotBlank(this.app.Previous_Employment_Years__c)) {
            t = t.addDays(Integer.valueOf(-1));
            this.app.Finish_Date_1__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            // Calc Start Date Previous employment
            t = t.addYears(Integer.valueOf(this.app.Previous_Employment_Years__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Employment_Months__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Employment_Months__c)*(-1));
            }
            this.app.Start_Date_1__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            //System.debug('Start_Date_1__c: ' + this.app.Start_Date_1__c + '|' + t);
        } else {
            this.app.Start_Date_1__c = null;
            this.app.Finish_Date_1__c = null;
        }
        if (!this.emptList.isEmpty()) {
            for (EmploymentWrapped e : this.emptList) {

                if (String.isNotBlank(e.data.Employment_Years__c)) {
                    t = t.addDays(Integer.valueOf(-1));
                    e.data.Finish_Date__c = t;
                    t = t.addYears(Integer.valueOf(e.data.Employment_Years__c)*(-1));
                    if (String.isNotBlank(e.data.Employment_Months__c)) {
                        t = t.addMonths(Integer.valueOf(e.data.Employment_Months__c)*(-1));
                    }
                    e.data.Start_Date__c = t;
                } else {
                    e.data.Start_Date__c = null;
                    e.data.Finish_Date__c = null;
                }
            }
        }
    }

    private void syncPreviousEmployment() {
        List<Application_Employment__c> r = new List<Application_Employment__c>();
        for (EmploymentWrapped a : this.emptList) {
            if (a.data.Id == null) {
                a.data.Application__c = this.app.Id;
                a.data.Applicant__c = '1';
            }
            r.add(a.data);
        }
        if (!r.isEmpty()) {
            upsert r;
        }
    }

    private Boolean hasPreviousEmploymentValidated() {
        Boolean r = true;

        //Previous Employment
        //if (String.isNotBlank(this.app.Start_Date_1__c)) {
        //    if (!FieldValidationsHelper.isDateFormatValid(this.app.Start_Date_1__c)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //                    'Previous Employment - Start time: Value required or wrong format (dd/mm/yyyy)'));
        //        r = false;    
        //    }
        //}
        //if (String.isNotBlank(this.app.Finish_Date_1__c)) {
        //    if (!FieldValidationsHelper.isDateFormatValid(this.app.Finish_Date_1__c)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //                    'Previous Employment - Finish time: Value required or wrong format (dd/mm/yyyy)'));
        //        r = false;    
        //    }
        //}
        //if (r && String.isNotBlank(this.app.Start_Date_1__c) && String.isNotBlank(this.app.Finish_Date_1__c)) {
        //    Date d1 = FieldValidationsHelper.convertDate(this.app.Start_Date_1__c);
        //    Date d2 = FieldValidationsHelper.convertDate(this.app.Finish_Date_1__c);
        //    if (d1 > d2) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //                'Previous Employment - Finish time should be greater than Start time'));
        //        r = false;           
        //    }
        //}
        if (String.isNotBlank(this.app.Current_Employment_Years__c) && this.app.Current_Employment_Years__c.isNumeric() && Integer.valueOf(this.app.Current_Employment_Years__c) < 3) {
            if (this.app.Previous_Employment_Years__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'Previous Employment Years: Value required'));
                r = false;
            }
            if (this.app.Previous_Employment_Months__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Previous Employment Months: Value required'));
                r = false;   
            }
        }

        //Previuos employment list
        for (EmploymentWrapped a : this.emptList) {
            // if (!FieldValidationsHelper.isContainsValidCharacters(a.data.Employer_Name__c)) {
            //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //             'Prev. Employment #' + a.getViewIndex() + ' -  Employer Name: value required'));
            //     r = false;
            // }
            if (String.isBlank(a.data.Employment_Type__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Prev. Employment #' + a.getViewIndex() + ' -  Employment Type: selection required'));
                r = false;   
            }
            //if (a.data.Start_Date__c == null) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Prev. Employment #' + a.getViewIndex() + ' -  Start Date: value required'));
            //    r = false;   
            //}
            //if (a.data.Finish_Date__c == null) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Prev. Employment #' + a.getViewIndex() + ' -  Finish Date: value required'));
            //    r = false;   
            //}
            if (a.data.Employment_Years__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Prev. Employment #' + a.getViewIndex() + ' -  Employment Years: value required'));
                r = false;   
            }
            if (a.data.Employment_Months__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Prev. Employment #' + a.getViewIndex() + ' -  Employment Months: value required'));
                r = false;   
            }
            //if (a.data.Start_Date__c != null && a.data.Finish_Date__c != null &&
            //    a.data.Start_Date__c > a.data.Finish_Date__c ) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
            //            'Prev. Employment #' + a.getViewIndex() + ' -  Finish time should be greater than Start time'));
            //    r = false;   
            //}
        }
        return r;
    }

    private Boolean hasPreviousEmploymentSE() {
        Boolean r = true;
        if (!this.getHasBusinessMoreThan2Years()) {
            if (String.isBlank(this.lead.Time_In_Prev_Position__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'How long were you working in your previous position?: Value required'));
                    r = false;
            }
            if (String.isBlank(this.app.Previous_Occupation_1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'What was your occupation?: Value required'));
                    r = false;
            }
        }
        return r;
    }

    public String getHeaderStyle() {
        String r = '';
        if (STP_INIT.equals(step)) {
            r = 'rowHeaderOpening';
        } else if (STP_PRES.equals(step)) {
            r = 'rowHeaderPresenting';
        } else {
            r = 'rowHeaderQuestioning';
        }
        return r;
    }


    //Other asset
    public void addOtherAsset() {
        Application_Other_Asset__c a = new Application_Other_Asset__c(
            RecordTypeId =  SOQLSingletonQueries.recs().recordTypes.get(ApplicationService.OTHER_ASSET_TYPE));
        List<ObjectWrapped> m = this.otherAssetMap.get(ApplicationService.OTHER_ASSET_TYPE);
        if (m == null) {
            m = new List<ObjectWrapped>();
            this.otherAssetMap.put(ApplicationService.OTHER_ASSET_TYPE, m);
        }
        m.add(new ObjectWrapped(m.size()+1, a));
    }
    public void removeOtherAsset() {
        List<ObjectWrapped> m = this.otherAssetMap.get(ApplicationService.OTHER_ASSET_TYPE);
        Integer idx = this.otherAssetIndex;
        if (m != null && idx != null && idx <= m.size()) {
            ObjectWrapped obj = m.get(idx - 1);
            if (obj.data != null && obj.data.Id != null) {
                delete obj.data;
            }
            m.remove(idx - 1);
            //Reset order
            if (!m.isEmpty()) {
                Integer i = 1;
                for (ObjectWrapped a: m) {
                    a.idx = i++;
                }
            }
        }
    }

    public void onchangeOtherAsset() {
        if ('Y'.equals(this.lead.Has_Any_Asset__c)) {
            if (this.otherAssetList.isEmpty()) {
                this.addOtherAsset();
            }
        }
    }

    private void loadOtherAssets() {
        this.otherAssetIndex = 0;
        this.otherAssetMap = new Map<String, List<ObjectWrapped>>();
        this.mortgageProp = null;
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(this.app.Id);
        for (Application_Other_Asset__c a : d) {
            List<ObjectWrapped> m = this.otherAssetMap.get(a.RecordType.Name);
            if (m == null) {
                m = new List<ObjectWrapped>();
                this.otherAssetMap.put(a.RecordType.Name, m);
            }
            m.add(new ObjectWrapped(m.size()+1, a));
            if (this.mortgageProp == null && ApplicationService.PROPERTY_ASSET_TYPE.equals(a.RecordType.Name)) {
                this.mortgageProp = a;
            }
        }
        if (this.mortgageProp == null) {
            this.mortgageProp = new Application_Other_Asset__c(
                RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get(ApplicationService.PROPERTY_ASSET_TYPE));
        }
        if (this.otherAssetList.size() > 0) {
            this.lead.Has_Any_Asset__c = 'Y';
        }

        //Load Loans
        this.loans = getApplicationLoans();
        if (!this.loans.isEmpty()) {
            this.app.Do_you_have_any_loans_outstanding__c = 'Yes';
        }
    }

    private void syncOtherAsset() {
        if ('Y'.equals(this.lead.Has_Any_Asset__c)) {
            if (this.otherAssetList.isEmpty()) {
                List <Application_Other_Asset__c> d = new List <Application_Other_Asset__c>();
                for (ObjectWrapped a: this.otherAssetList) {
                    Application_Other_Asset__c oa = (Application_Other_Asset__c)a.data;
                    if (oa.Application__c == null) {
                        oa.Application__c = this.app.Id;
                    }
                    oa.Has_Loan__c = null;
                    oa.Lender__c = null;
                    oa.Amount_Owing__c = null;
                    oa.Frequency__c = null;
                    oa.Is_Payout__c = false;
                    oa.Payment__c = null;
                    d.add(oa);
                }
                
                if (!d.isEmpty()) {
                    upsert d;
                }
            }
        } else {
            delete [SELECT Id FROM Application_Other_Asset__c WHERE Application__c = :this.app.Id];
            for (ObjectWrapped a: this.otherAssetList) {
                a.data.Id = null;
            }
        }
    }

    public void initFlowProcess() {
        System.debug('initFlowProcess...');
        String nextStep = null;
        //Check Lead ownership
        Id ownerId = null;
        User sysGen = SOQLSingletonQueries.recs().sysGenUser;

        //if (Lead.OwnerId == sysGen.Id) {
        //    ownerId = Lead.OwnerId;
        //    nextStep = STP_INIT;   
        //} else {

        //}
        if (Lead.OwnerId != sysGen.Id && SOQLSingletonQueries.isActiveConsultantUser(Lead.OwnerId)) {
            nextStep = STP_INIT;
            if (Lead.OwnerId == UserInfo.getUserId()) {
                return;    
            } else {
                ownerId = Lead.OwnerId;
            }
        }

        if (ownerId == null) {
            Set<Id> accIds = new Set<Id>();
            if (this.lead.Account__c != null) {
                accIds.add(this.lead.Account__c);
            }
            List<Account> accList = SOQLSingletonQueries.searchAccounts(this.lead);
            if (!accList.isEmpty()) {
                for (Account a : accList) {
                    accIds.add(a.Id);
                }
            }
            if (!accIds.isEmpty()) {
                // Search Account's opps
                List<Custom_Opportunity__c> opps = [
                    SELECT OwnerId FROM Custom_Opportunity__c
                    WHERE Account__c in :accIds
                    AND OwnerType__c != 'Queue' 
                    AND OwnerId != :sysGen.Id
                    AND OwnerId != :UserInfo.getUserId()
                    ORDER BY LastModifiedDate DESC LIMIT 10
                ];
                if (!opps.isEmpty()) {
                    for (Custom_Opportunity__c a : opps) {
                        if (ownerId == null && SOQLSingletonQueries.isActiveConsultantUser(a.OwnerId)) {
                            ownerId = a.OwnerId;
                            nextStep = STP_INIT;
                        }
                    }
                }
                // Search Account's leads 
                // COMMENTED DUE TO IT SHOULD ONLY CHECK FOR OPPS
                List<Lead__c> leads = [
                    SELECT OwnerId FROM Lead__c
                    WHERE Account__c in :accIds
                    AND OwnerId != :sysGen.Id
                    AND OwnerId != :UserInfo.getUserId()
                    AND CreatedDate = LAST_N_DAYS:7
                    ORDER BY LastModifiedDate DESC LIMIT 10
                ];
                if (!leads.isEmpty()) {
                    for (Lead__c a : leads) {
                        if (ownerId == null && SOQLSingletonQueries.isActiveConsultantUser(a.OwnerId)) {
                            ownerId = a.OwnerId;
                            nextStep = STP_INIT;
                        }
                    }
                }
            }
        }
        if (ownerId != null) {
            this.leadOwner = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id = :ownerId];
            if (String.isNotBlank(nextStep)) {
                this.step = nextStep;
            }
        }

        //if (String.isNotBlank(nextStep)) {
        //    this.step = nextStep;
        //} else {
        //    //this.manageAccount();
        //    this.manageCustomOpportunity(OPPSTATUS_BEOPPORTUNITY);       
        //    //this.lead.OwnerId = UserInfo.getUserId();
        //    //update this.lead; 
        //}
    }


    public PageReference closeLead() {
        if (String.isBlank(this.lead.Reason_for_closure__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Reason for closure: selection required'));
            return null;
        }
        if (this.lead.OwnerId != UserInfo.getUserId()) {
            System.debug('Changing ownership...');
            this.lead.OwnerId = UserInfo.getUserId();
        }
        this.lead.Status__c = 'Closed Lead';
        update this.lead;

        return new PageReference('/');
    }

    private List<Custom_Opportunity__c> listRelatedOpportunities() {
        List<Custom_Opportunity__c> r = new List<Custom_Opportunity__c>();
        Id leadId = null;
        Id accountId = null;
        Set<String> mobileList = new Set<String>();
        Set<String> emailList = new Set<String>();
        List<String> statusList = new List<String>(new String[]{'Closed Opportunity','Settled','Unresolved Opportunity'});
        String sql = 'SELECT Id, Name, Status__c, Date_Closed_or_Settled__c,  Reason_for_Closure__c, Application__r.Status__c ' +
                     'FROM Custom_Opportunity__c WHERE (Status__c IN :statusList) AND ';
        String wh = '';
        if (this.lead != null) {
            leadId = this.lead.Id;
            if (this.leadAccount != null) {
                accountId = this.leadAccount.Id;
                if (String.isNotBlank(this.leadAccount.PersonEmail)) {
                    emailList.add(this.leadAccount.PersonEmail);
                }
                if (String.isNotBlank(this.leadAccount.PersonMobilePhone)) {
                    mobileList.add(this.leadAccount.PersonMobilePhone);
                }
            } else {
                accountId = this.lead.Account__c;
            }
            if (String.isNotBlank(this.lead.Email_Address__c)) {
                emailList.add(this.lead.Email_Address__c);
            }
            if (String.isNotBlank(this.lead.Mobile_Number__c)) {
                mobileList.add(this.lead.Mobile_Number__c);
            }

            //Make where 
            if (leadId != null) {
                wh = '(Lead__c = :leadId)';
            }
            if (accountId != null) {
                if (String.isNotBlank(wh)) {
                    wh += ' OR ';
                }
                wh += '(Account__c = :accountId)';
            }
            if (!emailList.isEmpty()) {
                if (String.isNotBlank(wh)) {
                    wh += ' OR ';
                }
                wh += '(Email_Address__c IN :emailList)';
            }
            if (!mobileList.isEmpty()) {
                if (String.isNotBlank(wh)) {
                    wh += ' OR ';
                }
                wh += '(Mobile_Number__c IN :mobileList)';
            }
            sql += ' (' + wh + ') ORDER BY LastModifiedDate DESC';
            System.debug('Sql >> ' + sql);
            System.debug('leadId >> ' + leadId);
            System.debug('accountId >> ' + accountId);
            System.debug('mobileList >> ' + mobileList);
            System.debug('emailList >> ' + emailList);
            System.debug('statusList >> ' + statusList);
            r = Database.query(sql);
        }
        return r;
    }

    public Boolean getHasRelatedOpportunities() {
        if (this.relatedOppsList != null && !this.relatedOppsList.isEmpty()) {
            return true;
        }
        return false;
    }

    public List<SelectOption> getLoanTypeOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        r.add(new SelectOption('Car Loan','Car Loan'));
        Schema.DescribeFieldResult fieldResult = Application_Loan__c.Type__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
            r.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return r;
    }

    public Boolean getHasDiffrentOwner() {
        Boolean r = false;
        if (this.leadOwner != null && this.leadOwner.Id != UserInfo.getUserId()) {
            r = true;
        }
        return r;
    }

    public void notifyOwnership() {
        System.debug('Notifying current owner...');
        if (this.lead.OwnerId == UserInfo.getUserId()) {
            update this.lead;
        }
        //Update owner ship
        if (this.lead.OwnerId != this.leadOwner.Id) {
            try {
                this.lead.OwnerId = this.leadOwner.Id;
                update this.lead;    
            } catch (Exception e) {
                if (!e.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        e.getMessage()));   
                }
            }
        }
        //Send email
        EmailSender.leadFlowNotification(this.lead, this.leadOwner);
    }

    public Boolean getHasOpportunity() {
        if (this.opp != null) {
            return true;
        }
        return false;
    }

    public void closeFlow() {
        if (this.lead.OwnerId == UserInfo.getUserId()) {
            update this.lead;
        }
    }

    public void addPreviousAddress() {
        if (this.previousAddresses != null) {
            if (this.previousAddresses < 5) {
                Boolean increase = true;
                if (this.previousAddresses >= 1) {
                    if (String.isBlank(this.app.Date_From_1__c) == null || 
                        String.isBlank(this.app.Previous_Residence_Status_1__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        '1) Previous address: fill date move in and residential status'));       
                        increase = false;
                    }
                }
                if (this.previousAddresses >= 2) {
                    if (String.isBlank(this.app.Date_From_1b__c) == null || 
                        String.isBlank(this.app.Previous_Residence_Status_1b__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        '2) Previous address: fill date move in and residential status'));       
                        increase = false;
                    }
                }
                if (this.previousAddresses >= 3) {
                    if (String.isBlank(this.app.Date_From_1c__c) == null || 
                        String.isBlank(this.app.Previous_Residence_Status_1c__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        '3) Previous address: fill date move in and residential status'));       
                        increase = false;
                    }
                }
                if (this.previousAddresses >= 4) {
                    if (String.isBlank(this.app.Date_From_1d__c) == null || 
                        String.isBlank(this.app.Previous_Residence_Status_1d__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        '4) Previous address: fill date move in and residential status'));       
                        increase = false;
                    }
                }
                if (increase) {
                    this.previousAddresses++;
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Only 5 previous addresses can be added'));
            }
        }
    }

    public void removePreviousAddress() {
        if (this.previousAddresses != null && this.previousAddresses > 0) {
            if (this.previousAddresses == 1) {
                this.app.Date_From_1__c = null;
                this.app.Previous_Residence_Status_1__c = null;
            } else if (this.previousAddresses == 2) {
                this.app.Date_From_1b__c = null;
                this.app.Previous_Residence_Status_1b__c = null;
            } else if (this.previousAddresses == 3) {
                this.app.Date_From_1c__c = null;
                this.app.Previous_Residence_Status_1c__c = null;
            } else if (this.previousAddresses == 4) {
                this.app.Date_From_1d__c = null;
                this.app.Previous_Residence_Status_1d__c = null;
            } else if (this.previousAddresses == 5) {
                this.app.Date_From_1e__c = null;
                this.app.Previous_Residence_Status_1e__c = null;
            }
            this.previousAddresses--;
        }
    }

    public void checkAccountCreation() {
        System.debug('checkAccountCreation...');
        if (this.lead != null) {
            User sysGen = SOQLSingletonQueries.recs().sysGenUser;
            User savvyAdmin = SOQLSingletonQueries.recs().sysAdminUser;
            Id ownerId = UserInfo.getUserId();
            System.debug('1> ownId: ' + ownerId + ' | Sadmin: ' + savvyAdmin.Id + ' | leown: ' + this.lead.OwnerId + ' | sysgen:' + sysGen.Id);
            if (this.lead.Account__c == null) {
                //Check for an account
                System.debug('Checking for an account... ' + this.lead.First_Name__c);
                List<Account> accList = SOQLSingletonQueries.searchAccounts(this.lead);
                Account acc = null;
                if (accList.isEmpty()) {
                    System.debug('Creating an account... ' + this.lead.First_Name__c);
                    acc = new Account();
                    acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Person Account'].Id;
                    acc.FirstName = this.lead.First_Name__c;
                    acc.LastName = this.lead.Last_Name__c;

                    acc.Street_Address__c = this.lead.Street_Address__c;
                    acc.Suburb__c = this.lead.Suburb__c;
                    acc.State__c = this.lead.State__c;
                    acc.Postcode__c = this.lead.Postcode__c;
                    acc.PersonHomePhone = this.lead.Home_Phone__c;
                    acc.PersonOtherPhone = this.lead.Work_Phone__c;
                    acc.PersonMobilePhone = this.lead.Mobile_Number__c;
                    acc.PersonEmail = this.lead.Email_Address__c;
                    acc.OwnerId = ownerId;
                    insert acc;
                } else {
                    //System.debug('Account found it... ');
                    acc = accList.get(0);
                    //check if the account ownership corresponds to another active consultant
                    if (acc.OwnerId != ownerId) {
                        if (SOQLSingletonQueries.isActiveConsultantUser(acc.OwnerId)) {
                            this.lead.Account__c = acc.Id;
                        } else {
                            //AppPreFlowController.changeAccountOwnership(acc.Id, ownerId);
                            //acc.OwnerId = ownerId;
                            //update acc;
                        }
                    }
                }
                this.lead.Account__c = acc.Id;
                System.debug('2> ownId: ' + ownerId + ' | Sadmin: ' + savvyAdmin.Id + ' | leown: ' + this.lead.OwnerId + ' | sysgen:' + sysGen.Id);
            }
        }
    }

    public PageReference closeOpportunity() {
        if (String.isBlank(this.opp.Reason_for_closure__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Reason for closure: selection required'));
            return null;
        }
        this.opp.Status__c = 'Closed Opportunity';
        this.opp.Date_Closed_or_Settled__c = Datetime.now();
        update this.opp;

        return new PageReference('/');
    }

    public void openClosedLead() {
        if (String.isBlank(this.lead.Reason_for_closure__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Reason for closure: selection required'));
        }
        if (this.lead.OwnerId != UserInfo.getUserId()) {
            System.debug('Changing ownership...');
            this.lead.OwnerId = UserInfo.getUserId();
        }
        this.lead.Status__c = LEADSTATUS_SFBEOPPORTUNITY;
        this.lead.Reason_for_closure__c = null;
        update this.lead;

        this.next();
    }

    public Boolean getDisplayOpenColsedLead() {
        Boolean r = false;
        if ('Closed Lead'.equals(this.lead.Status__c)) {
            r  = true;
        }
        return r;
    }

    public Boolean getIsPersonalLoan() {
        if (this.lead != null && 'Personal Loan'.equals(this.lead.Loan_Type__c)) {
            return true;
        }
        return false;
    }

    public Boolean getHasApplicationCompleted() {
        if (this.app != null && ApplicationService.APP_STATUS_FINISHED.equals(this.app.Status__c)) {
            return true;
        }
        return false;
    }

    private void calculateResidentialDates() {
        Date t = Date.today();
        // Calc move in Date current residential address
        if (String.isNotBlank(this.app.Current_Residence_Years__c)) {
            t = t.addYears(Integer.valueOf(this.app.Current_Residence_Years__c)*(-1));
            if (String.isNotBlank(this.app.Current_Residence_Months__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Current_Residence_Months__c)*(-1));
            }
            this.app.Date_Moved_in_1__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
        } else {
            this.app.Date_Moved_in_1__c = null;
        }
        // Previous 1
        if (String.isNotBlank(this.app.Previous_Residence_Years__c)) {
            t = t.addYears(Integer.valueOf(this.app.Previous_Residence_Years__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Residence_Months__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Residence_Months__c)*(-1));
            }
            this.app.Date_From_1__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            this.app.Previous_Country_1__c = 'AUS';
        } else {
            this.app.Date_From_1__c = null;
            this.app.Previous_Country_1__c = null;
        }
        // Previous 2
        if (String.isNotBlank(this.app.Previous_Residence_Yearsb__c)) {
            t = t.addYears(Integer.valueOf(this.app.Previous_Residence_Yearsb__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Residence_Monthsb__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Residence_Monthsb__c)*(-1));
            }
            this.app.Date_From_1b__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            this.app.Previous_Country_1b__c = 'AUS';
        } else {
            this.app.Date_From_1b__c = null;
            this.app.Previous_Country_1b__c = null;
        }
        // Previous 3
        if (String.isNotBlank(this.app.Previous_Residence_Yearsc__c)) {
            t = t.addYears(Integer.valueOf(this.app.Previous_Residence_Yearsc__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Residence_Monthsc__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Residence_Monthsc__c)*(-1));
            }
            this.app.Date_From_1c__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            this.app.Previous_Country_1c__c = 'AUS';
        } else {
            this.app.Date_From_1c__c = null;
            this.app.Previous_Country_1c__c = null;
        }
        // Previous 4
        if (String.isNotBlank(this.app.Previous_Residence_Yearsd__c)) {
            t = t.addYears(Integer.valueOf(this.app.Previous_Residence_Yearsd__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Residence_Monthsd__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Residence_Monthsd__c)*(-1));
            }
            this.app.Date_From_1d__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            this.app.Previous_Country_1d__c = 'AUS';
        } else {
            this.app.Date_From_1d__c = null;
            this.app.Previous_Country_1d__c = null;
        }
        // Previous 5
        if (String.isNotBlank(this.app.Previous_Residence_Yearse__c)) {
            t = t.addYears(Integer.valueOf(this.app.Previous_Residence_Yearse__c)*(-1));
            if (String.isNotBlank(this.app.Previous_Residence_Monthse__c)) {
                t = t.addMonths(Integer.valueOf(this.app.Previous_Residence_Monthse__c)*(-1));
            }
            this.app.Date_From_1e__c = DateUtils.convertToString(t, DateUtils.ddMMyyyy);
            this.app.Previous_Country_1e__c = 'AUS';
        } else {
            this.app.Date_From_1e__c = null;
            this.app.Previous_Country_1e__c = null;
        }        
    }

    public void checkLoanCommitments() {
        if (this.loans.isEmpty()) {
            this.addLoan();
        }
    }

    public void checkCreditCards() {
        if (this.creditCards.isEmpty()) {
            this.addCreditCard();
        }
    }

    // Lelo                     2019-03-07
    public class ObjectWrapped {
        public Integer idx {get;set;}
        public sObject data {get;set;}
        public ObjectWrapped(Integer idx, sObject obj) {
            this.idx = idx;
            this.data = obj;
        }
    }

    private List<ObjectWrapped> getOtherAssetList(String assetType) {
        List<ObjectWrapped> r = new List<ObjectWrapped>();
        if (String.isNotBlank(assetType) && this.otherAssetMap != null && this.otherAssetMap.containsKey(assetType)) {
            r = this.otherAssetMap.get(assetType);
        }
        return r;
    }

    private Boolean hasMortgageValidated() {
        Boolean r = true;
        if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.mortgageProp.Payment__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Repayment: Numeric value required'));
            r = false;    
        }
        if (String.isBlank(this.mortgageProp.Frequency__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Repayment Frequency: value required'));
            r = false;
        }
        if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.mortgageProp.Amount_Owing__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Outstanding Loan Amount: Numeric value required'));
            r = false;    
        }
        if (!FieldValidationsHelper.isContainsValidCharacters(this.mortgageProp.Lender__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Lender: Value required'));
            r = false;    
        }
        if (!FieldValidationsHelper.isDecimalGreaterThanZero(this.mortgageProp.Value__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'House value: Numeric value required'));
            r = false;    
        }
        //if (!FieldValidationsHelper.isDateFormatValid(this.app.Date_Moved_in_1__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //                'Date Move In: Value required or wrong format (dd/mm/yyyy)'));
        //    r = false;    
        //}
        if (String.isBlank(this.app.Current_Residence_Years__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Current Residence Years: Value required'));
            r = false;
        }
        if (String.isBlank(this.app.Current_Residence_Months__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Current Residence Months: Value required'));
            r = false;
        }
        return r;
    }

    public void savePRRS(Boolean hasValidation) {
        //Clear values 
        //Current Residential
        
        //this.app.Loan_Frequency_1__c = 'Monthly';
        //this.app.Residential_Payment_Frequency_1__c = 'Monthly';
        // System.debug('Residential Status: ' + this.app.Current_Residence_Status_1__c);
        // System.debug(JSON.serializePretty(this.mortgageProp));
        if ('Mortgage'.equals(this.app.Current_Residence_Status_1__c)) {
            this.app.Rent_per_month_1__c = 0;
            this.app.Board_per_Month_1__c = 0;
            this.lead.Is_On_Lease__c = null;
        } else if ('Renting(Private)'.equals(this.app.Current_Residence_Status_1__c) ||
                    'Renting(Agent)'.equals(this.app.Current_Residence_Status_1__c)) {
            //this.app.Property_Value_1__c = null;
            this.app.Board_per_Month_1__c = 0;
            //this.app.Property_Has_Loan_1__c = null;
            //this.app.Loan_Type_1__c = null;
            //this.app.Loan_Frequency_1__c = null;
            //this.app.Property_Address_1__c = null;
        } else if ('Boarding'.equals(this.app.Current_Residence_Status_1__c)) {
            this.app.Rent_per_month_1__c = 0;
            //this.app.Property_Value_1__c = null;
            this.lead.Is_On_Lease__c = null;
            //this.app.Property_Has_Loan_1__c = null;
            //this.app.Loan_Type_1__c = null;
            //this.app.Loan_Frequency_1__c = null;
            //this.app.Property_Address_1__c = null;
        } else if ('Own Outright'.equals(this.app.Current_Residence_Status_1__c)) {
            this.app.Board_per_Month_1__c = 0;
            this.app.Rent_per_month_1__c = 0;
            this.lead.Is_On_Lease__c = null;
            //this.app.Property_Has_Loan_1__c = null;
            //this.app.Loan_Type_1__c = null;
            //this.app.Loan_Frequency_1__c = null;
            //this.app.Property_Address_1__c = null;
            //this.app.Residential_Payment_Frequency_1__c = null;
        } else if ('Parents/Relative'.equals(this.app.Current_Residence_Status_1__c)) {
            //this.app.Property_Value_1__c = null;
            this.app.Board_per_Month_1__c = 0;
            this.lead.Is_On_Lease__c = null;
            //this.app.Property_Has_Loan_1__c = null;
            //this.app.Loan_Type_1__c = null;
            //this.app.Loan_Frequency_1__c = null;
            //this.app.Property_Address_1__c = null;
        }
        syncResidentialStatus(hasValidation);
    }

}