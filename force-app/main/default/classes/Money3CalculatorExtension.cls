public class Money3CalculatorExtension extends QuotingExtension {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'Money3';
    //-
    
    public QuotingToolHelper qh {set;get;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Money3';
    //-
    
    //Money3 API
    public Money3APIManager money3APIMgr {get; set;}
    public String money3API_BrokerReferenceId {get; set;}
    public String money3API_LoanId {get; set;}
    public String money3API_lastResponseApp {get; set;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public String apiUser {get;set;}
    public Boolean paramActive {set; get;}
    public Money3APIManager.LoanResponseDTO lenderApp {get;set;}
    //Money3 API

    public Boolean submitRequest {set; get;}

    // Lender variables
    public String loanTypeDetail {set;get;}
    public String profile {set;get;}
    public String grading {set;get;}
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}

    public Money3CalculatorExtension(ApexPages.StandardController controller) {
      super(controller);
      
      qh = new QuotingToolHelper();
      
      this.quotingName = LENDER_QUOTING;
      this.reset();

      preLoadQuotingValues();

      //Money3 API
      usersAPIOptions = Money3APIManager.getUserOptionsConnect();
      apiUser = Money3APIManager.getApiUser(Opp);
      //NWC Calculator - HJ - 12-07-2018 - I
      loadNWCParameters();
      //NWC Calculator - HJ - 12-07-2018 - F

    }
	
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            // System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'MON3'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.riskFee = lender.riskFeeBase;
                    this.loanTypeDetail = String.valueOf(lender.carAge);
                    //Lelo                          2017-11-16
                        this.clientRate = lender.clientRate;
                        this.baseRate = lender.clientRate;
                        this.dof = lender.dofBase;
                        this.profile = lender.customerProfile;
                        this.grading = lender.riskGrade;
                    //
                    this.applicationFeeCalc(true);
                }
            } catch (Exception e) {
                // System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }
    
    public Boolean isValidationOk() {
        return isValidationOk(false);
    }
    public Boolean isValidationOk(Boolean isApproval) {
        Boolean r = true;
        this.applicationFeeCalc(true);
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        if (this.profile == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Profile should be selected.'));
            r = false;
        }
        if (this.grading == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer Grading should be selected.'));
            r = false;
        }
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        } else if (this.applicationFee > lenderSettings.Application_Fee__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max Application Fee exceed.'));
            r = false;
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > this.maxDof) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max. DOF exceed.'));
            r = false;
        }
        if (this.riskFee == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Risk Fee value required.'));
            r = false;
        } else if (this.riskFee > this.riskFeeTotal) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Calculated Risk Fee exceed.'));
        }
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else {
            if (this.clientRate != this.baseRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Money 3 standard rate for ' + this.profile + '/' + this.grading + ' is ' + this.baseRate + '%.'));
            }
        }

        // Defining limits
        Integer termA = 0;
        Integer termB = 0;
        Decimal loanAmountA = 0.0;
        Decimal loanAmountB = 0.0;
        if ('Asset Finance'.equals(this.profile)) {
            if ('Micro Motor'.equals(this.grading)) {
                termA = 24;
                termB = 36;
                loanAmountA = 2000.0;
                loanAmountB = 10000.0;
            } else {
                termA = 36;
                termB = 60;
                loanAmountA = 8001.0;
                loanAmountB = 50000.0;
            }
        } else if ('Personal Finance'.equals(this.profile)) {
            if ('Mini PL'.equals(this.grading)) {
                termA = 12;
                termB = 24;
                loanAmountA = 2000.0;
                loanAmountB = 5000.0;
            } else {
                termA = 24;
                termB = 36;
                loanAmountA = 5001.0;
                loanAmountB = 12000.0;
            }
        }

        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (termA > 0 && (this.term < termA || this.term > termB)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Term should be ' + termA + ' to ' + termB + ' months for ' + this.profile + ' / ' + this.grading));
            r = false;
        } else if ('Asset Finance'.equals(this.profile) && !'Micro Motor'.equals(this.grading) && this.carPrice != null) {
            Decimal purchasePrice = this.carPrice - this.netDeposit;
            if (purchasePrice >= 8000 && purchasePrice < 12000) {
              ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.WARNING,'3 year max term for this purchase price. $' + purchasePrice.format()));
            } else if (purchasePrice >= 12000 && purchasePrice < 16000) {
              ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.WARNING,'4 year max term for this purchase price. $' + purchasePrice.format()));
            }
        }
        
        if (loanAmountA > 0 && (this.getLoanAmount() < loanAmountA || this.getLoanAmount() > loanAmountB)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Car Price/Loan Amount should be $' + loanAmountA.format() + ' to $' + loanAmountB.format() + ' for ' + this.profile + ' / ' + this.grading));
            // r = false;
        }

        
        
        // Lelo             2020-06-17
        loanAmountA = 0.0;
        loanAmountB = 0.0;
        if (this.term == 24) {
            loanAmountA = 2001.0;
            loanAmountB = 6000.0;
        } else if (this.term == 36) {
            loanAmountA = 6000.0;
            loanAmountB = 12000.0;
        } else if (this.term == 48) {
            loanAmountA = 12000.0;
            loanAmountB = 16000.0;
        } else if (this.term >= 60) {
            loanAmountA = 16000.0;
            loanAmountb = null;
        }
        if (loanAmountA > 0 && (this.realtimeNaf <= loanAmountA || (loanAmountB != null && this.realtimeNaf >= loanAmountB))) {
            if (loanAmountB != null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                        'NAF should be between $' + loanAmountA.setScale(0).format() + ' and $' + 
                        (loanAmountB-1).setScale(0).format() + ' for a ' + this.term + ' months term'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                        'NAF should be more than $' + loanAmountA.setScale(0).format() + ' for a ' + this.term + ' months term'));
            }
        }
        //-

        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2017-09-19
        if (this.residualValue > 0 && this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        // Loan Purpose validation
        if('Personal Finance'.equals(this.profile) && String.isBlank(this.loanPurpose)){
            ApexPages.Severity sev = isApproval ? ApexPages.Severity.ERROR : ApexPages.Severity.WARNING;
            r = isApproval ? false : r;
            String msg = isApproval 
              ? 'The Loan Purpose needs to be inserted into the quoting tool' 
              : 'The Loan Purpose is neccessary for any approval';
            ApexPages.addMessage(new ApexPages.Message(sev, msg));        
          }
        //-
        
        if('Personal Finance'.equals(this.profile) && this.getLoanAmount() <= 8000.0 && this.term > 24){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Loan amount of $8,000 or less maximum term 24 month'));
            r = false;  
        }
        return r;
    }
    
    public void calculate () {
      if (!isValidationOk()) {
          return;
      }
      this.calculateRepayments();
      // System.debug('calculate... ' + this.applicationFee + ' | ' + this.maxDof);
    }
    
    public void reset () {
        this.resetQuote();

        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.profile = null;
        this.grading = null;
        this.loanTypeDetail = 'New';
        this.profileOnChangeAction();
        //Initial values
        this.riskFee = null;
        // this.riskFeeCalc();
        //this.monthlyFee = 5.0;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        // this.applicationFeeCalc();
        this.dof = 770.0;
        //this.baseRate = 0.0;
        //this.clientRate = 28.0;
        //this.term = 48;
        this.term = 60;
        this.paymentType = 'Arrears';
        
        if('Personal Finance'.equals(this.profile)){
        	this.loanPurpose = '';
        }
        //-
        
        this.resetInsuranceProducts(false);

        this.resetCalculationResult(); //Lelo       2017-07-25

        lenderApp = null;
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        // pass universal variables
        calcPdf.getParameters().put('lender', 'MONEY3 CALCULATION');
        
        // Lender parameters// Lender parameters
        calcPdf.getParameters().put('customerProfile', this.profile);
        calcPdf.getParameters().put('rateType', this.grading);
        if (this.riskFee != null) {
            calcPdf.getParameters().put('riskFee', this.riskFee.format());
        }
        if(!'Personal Finance'.equals(this.profile)){
            this.loanPurpose = '';
        }
        calcPdf.getParameters().put('loanPurpose', this.loanPurpose);        
        
        savePdfInCloud(calcPdf, prefixName);

        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk(true)) {
            return null;
        }
        
        calculate();
        
        // validate calculation
        if (this.rental == null || this.rental <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Storing quoting data
        saveQuotingParameters();

        //Lelo 									2016-07-26
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
              Opportunity_Name__c = this.Opp.Id);
        }else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = 'Money3';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = this.loanTypeDetail;

        updateProduct.Loan_Term__c = term > 0? term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = dof > 0? dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        updateProduct.Lender_App_Fee__c = this.applicationFee > 0? this.applicationFee : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c += this.riskFee > 0? this.riskFee : 0.00;
        
        //Lelo                      2016-07-26
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }
        
        // Save accepted insurances
        this.saveInsuranceProducts();
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    
    //Lelo									2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            this.saveQuotingParameters();
            this.savePdf(fileGlobalPrefix);
        }
        return null;
    }
 	
    public PageReference savePreApproval() {
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        // System.debug('Asstet TYpe: ' + this.Opp.Application__r.Type_of_Asset__c);
        if ('Personal'.equals(this.Opp.Application__r.Type_of_Asset__c)) {
            this.quoting.Force_Calculation__c = false;
            return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
        } else if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
            }
        }
        return null;
    }
    //-
    
    //Lelo                                  2016-12-22
    private void loadQuotingParametersSaved() {
        // System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = (d != null)? d : new Application_Quoting__c();
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            // System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }
            this.resetInsuranceProducts(true);

            //Finance Details
            //Commons values
            this.loanType = d.Loan_Type__c;
            this.productLoanType = d.Loan_Product__c;
            this.carPrice = d.Vehicle_Price__c;
            this.deposit = d.Deposit__c;
            this.tradeIn = d.Trade_In__c;
            this.payoutOn = d.Payout_On__c;
            this.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                this.term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                this.loadQuotingInsuranceData();
                this.loadQuotingData();
                //Specific values
                //Loan Details
                this.paymentType = d.Payment__c;
                this.loanTypeDetail = d.Loan_Facility_Type__c;
                if (String.isNotBlank(d.Customer_Profile__c)) {
                    this.profile = d.Customer_Profile__c;
                }
                if (String.isNotBlank(d.Category_Type__c)) {
                    this.grading = d.Category_Type__c;
                }
                this.riskFee = d.Risk_Fee__c;
                if (d.Client_Rate__c != null) {
                    this.clientRate = d.Client_Rate__c.setScale(2);
                }
                
                if('Personal Finance'.equals(this.profile)){
                    this.loanPurpose = d.Loan_Purpose__c;
                }
                
                // API values
                money3API_BrokerReferenceId = d.Money3_Broker_Reference_Id__c;
                if (d.Money3_Loan_Id__c != null) {
                  money3API_LoanId = String.valueOf(d.Money3_Loan_Id__c);
                  loadLenderAppResponse(null);
                }
                money3API_lastResponseApp = d.Money3_Last_Response_App__c;
                
            }
            
        }
        this.profileOnChangeAction(true);
        // this.applicationFeeCalc(true);
        if (sameQuoting) {
            try {
                this.calculateRepayments();
            } catch (Exception e) {
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error re-calculating repayments.');
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error reported: ' + e.getMessage());
                new ApexPages.Message(ApexPages.Severity.ERROR,'Error cause: ' + e.getCause());
            }
        }
    }

    private void saveQuotingParameters() {
      // System.debug('Saving Quoting...' + LENDER_QUOTING);

      //NWC Warning - I
      if ((this.nwc != null && this.nwc > 0) &&
          (nwcParam != null && nwcParam.vehicleAgeYears != null && nwcParam.vehicleAgeYears > 20)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No car more than 20 years old can be covered. VechileYear: ' + nwcParam.vehicleAgeYears));
          // return;
      }
      //NWC Warning - F

      Application_Quoting__c d = new Application_Quoting__c();
      if (this.quoting != null) {
        this.updateQuotingData();
          d = this.quoting; 
      }
      
      //-
        //Finance Details
      d.Customer_Profile__c = this.profile;
      d.Category_Type__c = this.grading;

      d.Risk_Fee__c = this.riskFee;
      d.Monthly_Fee__c = this.monthlyFee;

      //Loan Details
      d.Loan_Facility_Type__c = this.loanTypeDetail;
      d.Payment__c = this.paymentType;
      d.Loan_Purpose__c = null;
      if ('Personal Finance'.equals(this.profile)){
        d.Loan_Purpose__c = this.loanPurpose;
      }

      //Save the record
      QuotingToolHelper.saveApplicationQuoting(d);

      //Save calculations
      QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

    }
    //-   

    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }
    
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidationOk();
        if (r) {
            calculate();
            if (this.rental != null && this.rental > 0) {
                r = true;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before proceeding with your request.'));
                r = false;
            }
        }
        return r;
    }

    public void sendCustomerEmail1() {
        // System.debug('sendCustomerEmail1...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        // System.debug('sendCustomerEmail2...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            try {
                Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
                EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
            } catch (EmailException e) {
                // System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
    }
    
  //Lelo                      2017-07-24   
  private void calculateRepayments() {
    //Reset results
    this.resetCalculationResult();
    //Quote
    //this.baseRate = this.clientRate;
    //FULL CALCULATION
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
    String quotingType = QuotingCalculation.CALC_QUOTING;
    param.totalAmount = this.getTotalAmount(quotingType);
    param.totalInsurance = this.getTotalInsuranceType(quotingType);
    param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(quotingType);
    param.clientRate = this.clientRate;
    param.paymentType = this.paymentType;
    param.term = this.term;
    param.dof = this.dof;
    param.monthlyFee = this.monthlyFee;
    param.residualValue = this.residualValue;
    param.customerProfile = this.profile;
    param.riskGrade = this.grading;
    param.amountBaseComm = this.getLoanAmount();
    // System.debug(param);
    // System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);
    System.debug('param >>>  ' + JSON.serialize(param));
    Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
    if (r != null) {
      estimatedCommission = r.Estimated_Commission__c;
      dofResult = r.DOF__c;
      insuranceIncome = r.Insurance_Income__c;
      totalCommission = r.Total_Commission__c;
      totalCommissionGst = r.Total_Commission_Gst__c;

      naf = r.NAF__c;
      rental = r.Rental__c;
      monthlyPayment = r.Monthly_Payment__c;
      fortnightlyPayment = r.Fortnightly_Payment__c;
      weeklyPayment = r.Weekly_Payment__c;
      r.Result_Type__c = quotingType;
    }
    calResults.put(quotingType, r);

    //Lelo          Insurenace          2017-12-04
    //Simple
    param.lender = LENDER_QUOTING;
    param.totalInsurance = 0;
    param.totalInsuranceIncome = 0;
    
    r = QuotingCalculation.calculate(param);
    if (r != null) {
      r.Result_Type__c = QuotingCalculation.CALC_SIMPLE;   
    }
    calResults.put(QuotingCalculation.CALC_SIMPLE, r);

    //Insurance
    List<String> calcTypes = new List<String>();
    //Insurance one by one
    //MV
    if (this.mv != null && this.mv > 0) {
      calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
    }
    //GAP
    if (this.gap != null && this.gap > 0) {
      calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
    }
    //WARR
    if (this.warranty != null && this.warranty > 0) {
      calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
    }
    //NWC
    if (this.nwc != null && this.nwc > 0) {
      calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
    }
    //CCI
    //Lelo          Insurance           2018-02-26
    if (this.cci != null && this.cci > 0) {
      calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
    }
    //-
    
    for (String key: calcTypes) {
      param.totalAmount = this.getTotalAmount(quotingType);
      param.totalInsurance = this.getTotalInsuranceType(key);
      param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
      r = QuotingCalculation.calculate(param);
      if (r != null) {
          r.Result_Type__c = key;   
      }
      calResults.put(key, r);                
    }
  }

    public void applicationFeeCalc() {
        applicationFeeCalc(false);
    }

    public void applicationFeeCalc(Boolean maxOnly) {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.customerProfile = this.profile;
        param.riskGrade = this.grading;
        param.totalAmount = this.getLoanAmount();
        //param.totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        this.maxDof = QuotingCalculation.getMoney3maxDof(param);
        param.totalAmount = this.getTotalAmount(QuotingCalculation.CALC_QUOTING);
        param.totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        param.riskFeeBase = this.getLoanAmount();
        this.riskFeeTotal = QuotingCalculation.getMoney3RiskFee(param);

        if (!maxOnly) {
            // this.applicationFee = this.getAppFeeCalculated(va);
            this.dof = this.maxDof;
            this.riskFee = this.riskFeeTotal;
        }
        // System.debug('applicationFeeCalc... ' + this.applicationFee + ' | ' + this.maxDof + ' | ' + this.riskFeeTotal);
    }

    public void profileOnChangeAction() {
        this.profileOnChangeAction(false);
    }

    public void profileOnChangeAction(Boolean skipClienRate) {
        // Clear Grading
        if (String.isBlank(this.profile) ||
            ('Asset Finance'.equals(this.profile) && 'Mini PL'.equals(this.grading)) ||
            ('Personal Finance'.equals(this.profile) && 'Micro Motor'.equals(this.grading))) {
            this.grading = null;
        }

        this.applicationFeeCalc(skipClienRate);

        // Base Rate Calculation
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        // param.customerProfile = this.profile;
        param.riskGrade = this.grading;
        this.baseRate = QuotingCalculation.getBaseRate(param);
        // System.debug('param.riskGrade: ' + param.riskGrade + ' | ' + this.baseRate.format() + '%');

        if (!skipClienRate) {
            this.clientRate = this.baseRate;
        }
    }

    // Money3 API call out
    public void money3Application (){
        // System.debug('>>>>> Response APPLICATION Money3  -I  <<<<<< - ');
        try{
          Money3APIService money3APIService = new Money3APIService();
          this.money3APIMgr = new Money3APIManager();
          money3APIService.requestApplication(this.money3APIMgr, Opp.Id , apiUser, false);
        } catch(GenericException ex) {
            this.money3APIMgr.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        
        if (this.money3APIMgr.isError && 200 != this.money3APIMgr.responseStatus){
            showErrorsMoney3API();
        } else {
          if (this.money3APIMgr.responseDto != null) {
            money3API_BrokerReferenceId = this.money3APIMgr.responseDto.brokerReferenceLoanId;
            money3API_LoanId = String.valueOf(this.money3APIMgr.responseDto.loanId);
            money3API_lastResponseApp = this.money3APIMgr.responseDto.lastResponseApplication;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Application received ' + money3API_LoanId));
            saveAPIInformation();
          }
        }
        LenderAPIResponse__c lar = Money3APIManager.saveLenderAPIResponse(Opp.Id, this.money3APIMgr, LENDER_QUOTING, apiUser);
        if (lar != null) {
          this.loadLenderAppResponse(lar.Response__c);
        }
        // saveLenderAPIResponse();
        // System.debug('>>>>> Response APPLICATION Money3  -F  <<<<<< - ');
    }

    // public void saveLenderAPIResponse() {
    //   if (this.money3APIMgr != null && String.isNotBlank(this.money3APIMgr.responseMessage)) {
    //     LenderAPIResponse__c lar = new LenderAPIResponse__c();
    //     lar.Name = LENDER_QUOTING;
    //     lar.Opportunity__c = this.Opp.Id;
    //     lar.Request__c = this.money3APIMgr.reqBody;
    //     lar.Response__c = this.money3APIMgr.responseMessage;
    //     lar.Status__c = this.money3APIMgr.responseStatus;
    //     lar.Provider__c = 'Money3';
    //     lar.Service__c = 'loans';   
    //     if (this.money3APIMgr.responseDto != null && this.money3APIMgr.responseDto.loanId > 0) {
    //       lar.Application_ID__c = String.valueOf(this.money3APIMgr.responseDto.loanId);
    //       lar.Name += ' [' + lar.Application_ID__c + ']';
    //       this.loadLenderAppResponse(lar.Response__c);
    //     } else {
    //       lar.Name += ' [FAIL-' + DateUtils.getTimeForFileName() + ']';
    //     }
          
    //     insert lar;
          
    //       if (this.money3APIMgr.responseDto != null && this.money3APIMgr.responseDto.loanId > 0) {
    //           saveLenderAPIResponseFile();   
    //       }  
    //   }
    // }

    public void loadLenderAppResponse(String res) {
      String rsp = res;
      if (String.isBlank(res) && String.isNotBlank(this.money3API_LoanId)) {
        List<LenderAPIResponse__c> d = [
          Select Response__c From LenderAPIResponse__c 
          Where Opportunity__c = :Opp.Id
          And Application_ID__c = :this.money3API_LoanId
        ];
        rsp = d.isEmpty()? null : d.get(0).Response__c;
      }
      // System.debug(rsp);
      if (String.isNotBlank(rsp)) {
        try {
          this.lenderApp = (Money3APIManager.LoanResponseDTO)JSON.deserialize(rsp, Money3APIManager.LoanResponseDTO.class);
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Response could not be mapped propperly. Message: ' + e.getMessage() + '.'));
        }
      }
    }

    public Boolean getHasLenderApp() {
      return this.lenderApp != null;
    }

    private void saveAPIInformation(){
        this.quoting.Money3_Broker_Reference_Id__c = money3API_BrokerReferenceId;
        this.quoting.Money3_Loan_Id__c = Integer.valueOf(money3API_LoanId);
        this.quoting.Money3_Last_Response_App__c = money3API_lastResponseApp;
        update this.quoting;
    }

    private void showErrorsMoney3API(){
      if (String.isNotBlank(money3APIMgr.message)) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Savvy message: ' + money3APIMgr.message + '. Please check all the data.'));
        String sError = '';
        // System.debug(sError);
        String responseMessage = StringUtils.validateNull(money3APIMgr.responseMessage);
        String[] errors = responseMessage.split('-');
        if (money3APIMgr.isError == null){
            sError = 'Status: [' + money3APIMgr.responseStatus + ']- Message: [' + StringUtils.validateNull(money3APIMgr.message) + ']- Response Message: [' + responseMessage + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else{
            sError = 'Status: [' + money3APIMgr.responseStatus + ']- Message: [' + StringUtils.validateNull(money3APIMgr.message) + ']- Response Message: [' + responseMessage + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '**Errors list**'));
        for (String e : errors){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e));
        }
      }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    
    public void sendFiles() {
        if(String.isNotBlank(money3API_BrokerReferenceId)){
            Money3APIService money3APIService = new Money3APIService();
            this.money3APIMgr = new Money3APIManager();
            this.money3APIMgr.responseDto = new Money3APIResponseDTO();
            money3APIService.uploadDocumentsToMoney3(this.money3APIMgr, Opp.Id , Integer.valueOf(this.quoting.Money3_Loan_Id__c), true);
            
            saveLenderAPIResponseFile();
        }
    }
    
    public void saveLenderAPIResponseFile(){
        
        String loanId;
        
        if(String.isNotBlank(money3API_BrokerReferenceId)){
            loanId = String.valueOf(this.quoting.Money3_Loan_Id__c);
        }else{
            loanId = String.valueOf(money3APIMgr.responseDto.loanId);
        }
        // System.debug(loanId);
        List<LenderAPIResponse__c> lenderList = [
            SELECT Id, Application_ID__c from LenderAPIResponse__c where 
            Application_ID__c=:loanId];
        
        LenderAPIResponse__c lender;
        
        if(!lenderList.isEmpty()){
            lender =  lenderList.get(0);
            Money3APIManager.saveLenderAPIResponseFiles(lender.Id, money3APIMgr);
        }
        
        // if(money3APIMgr.responseDto.docs != null && lender != null){
        //     for (LenderAPIResponse__c l : money3APIMgr.responseDto.docs) {
        //         l.LenderAPIResponse__c = lender.Id;
        //         l.Provider__c = 'Money3';
        //         l.Service__c = 'documents'; 
        //     }
            
        //     if(!money3APIMgr.responseDto.docs.isEmpty()){
        //         insert money3APIMgr.responseDto.docs;
        //     }
        // }
    }
    
    public void sendApplication(){
        
        if(submitRequest){
            try {
                money3Application();
            } catch (GenericException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
        }else{
            isValidationOk();
            if (this.rental == null || this.rental == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            }
        }		
    }
    
    public void save(){
        
        submitRequest = false;
        if(isValidationOk()){
            
            calculate();
            
            // validate calculation
            if (this.rental > 0) {
                //saveQuotingParameters();
                saveProduct(fileGlobalPrefix);
                submitRequest = true;
            }
        }
    }

  public override Decimal getTotalAmount(String calcType) {
    Decimal r = 0.0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
      r += this.carPrice +
          (this.carPrice * QuotingCalculation.getProtectedPercentaje(this.carPrice));
    } else {
      r += (this.carPrice != null)? this.carPrice : 0;
    }
    r += (this.applicationFee != null)? this.applicationFee : 0;
    if (!'Micro'.equals(this.profile) && dof != null) r += dof;
    r += (this.ppsr != null)? this.ppsr : 0;
    r -= getNetDepositVal();
    r += (this.riskFee != null)? this.riskFee : 0;
    return r;
  }

  public Decimal getLoanAmount() {
    Decimal r = 0.0;
    r += (this.carPrice != null)? this.carPrice : 0;
    if (!'Personal Finance'.equals(this.profile)) {
        r -= getNetDepositVal();
    }
    return r;
  }

  // Abstract methods implementation
  public override Boolean hasValidQuotation() {
    System.debug(this.quotingName + ' overriding hasValidQuotation...');
    return this.isValidationOk();
  }

  public override void calculateQuote() {
    System.debug(this.quotingName + ' overriding calculateQuote...');
    this.calculate();
  }

  public override void storeQuotingData() {
    System.debug(this.quotingName + ' overriding storeQuotingData...');
    this.saveQuotingParameters();
  }
  
}