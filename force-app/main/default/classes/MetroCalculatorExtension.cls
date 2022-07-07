public class MetroCalculatorExtension extends QuotingExtension {
	  
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'Metro';
    //-
    public QuotingToolHelper qh {set;get;}
    public List <MetroCalculatorRates__c> rates {get;set;}
    public static final String LENDER_QUOTING = 'Metro';
    
    // Lender variables
    public String loanTypeDetail {set;get;}
    public String tier {get;set;}
    public String condition {set;get;}
    public String greenCar {set;get;}
    public String saleBacksPurchased {get;set;}
    public Decimal brokeragePercentage {get;set;}
    public Integer carAge {get;set;}
    public MetroPlanOption__c plan {set;get;}

    public MetroCalculatorExtension(ApexPages.StandardController controller) {
      super(controller);
      
      qh = new QuotingToolHelper();
      
      this.quotingName = LENDER_QUOTING;
      this.reset();

      preLoadQuotingValues();
      
      //NWC Calculator - HJ - 12-07-2018 - I
      loadNWCParameters();
      //NWC Calculator - HJ - 12-07-2018 - F
    }
	
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'METR'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.loanTypeDetail = lender.loanType;
                    this.carAge = lender.carAge;
                    this.privateSales = lender.privateSales;
                    //Lelo                          2017-11-16
                    this.brokeragePercentage = lender.brokerageBase;
                    this.dof = lender.dofBase;
                    //
                    baseRateCalc();
                    
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }

    public PageReference baseRateCalc() {
      this.realtimeNafCalc();
        this.baseRate = 0.0;
        this.clientRate = 0.0;
        
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.loanTypeDetail = this.loanTypeDetail;
        param.totalAmount = this.realtimeNaf;
        param.term = this.term;
        param.carAge = this.carAge;
        param.brokeragePer = this.brokeragePercentage;
        param.privateSales = this.privateSales;
        param.saleBacksPurchased = this.saleBacksPurchased;
        param.clientTier = this.tier;
        param.condition = this.condition;
        param.greenCar = this.greenCar;
        this.baseRate = QuotingCalculation.getBaseRate(param);

        System.debug('Base Rate 1 >> ' + this.baseRate);

        this.clientRate = this.getClientRateCalc(null);
        
        return null;
    }
    
    //Lelo                  2017-07-27
    private Decimal getClientRateCalc(String calcType) {
        Decimal r = 0.0;
        //Client Rate
        Decimal fv = 0.0;
        if (this.residualValue != null) {
            fv = this.residualValue;
        }
        Decimal amuntPmt = this.getBaseAmountPmtInclBrokerageCalc(calcType);
        //system.debug('amuntPmt >> ' + amuntPmt);
        //system.debug('ratePmt  >> ' + (this.baseRate/100/12));
        //system.debug('term     >> ' + this.term);
        //system.debug('fv-resid >> ' + fv);
        //Decimal pmt = FinancialUtilities.pmt((amuntPmt * -1), (baseRate/100/12), Decimal.valueOf(term), fv, false);
        
        if (this.term > 0 && this.baseRate > 0 && amuntPmt > 0) {
            Integer type = 0;
            if ('Advance'.equals(this.paymentType))
                type = 1;
            Decimal pmt = FinancialUtilities.pmt2((this.baseRate/100/12), this.term, (amuntPmt * -1), fv, type);
            //system.debug('pmt      >> ' + pmt);
            //system.debug('totalAmount >> ' + totalAmount);
            r = FinancialUtilities.rate2(this.term, (pmt * -1.0), this.realtimeNaf, (fv * -1), type) * 12 * 100;
            //system.debug('clientRate      >> ' + r);
        }
        return r;
    }
    
    public Boolean isValidationOk() {
      this.realtimeNafCalc();
        Boolean r = true;
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        } else if (this.plan != null) {
            if (this.applicationFee > this.plan.Application_Fee__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee should not exceed $' + this.plan.Application_Fee__c.format()));
                r = false;
            }
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.plan != null) {
            if (this.dof > this.plan.DOF__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF should not exceed $' + this.plan.DOF__c.format()));
                r = false;
            }
        }
        // Commented due to new plan option implementation          2018-09-3
        //if (this.applicationFee > 0 && this.dof > 0.0) {
        //	if ((this.applicationFee + this.dof) > 1000.0) {
        //    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee and DOF that their sum can only reach $1,000.'));
        //    	r = false;
        //    }
        //}
        if (this.ppsr == null || this.ppsr == 0.0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
            //r = false;
        }
        if (this.brokeragePercentage == null || this.brokeragePercentage == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Brokerage (%) is Zero.'));
            //r = false;
        } else if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate cannot be Zero.'));
            r = false;
        }
        if (this.brokeragePercentage > 8) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than 8%'));
            r = false;
        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term (60 max).'));
            r = false;
        }
        if ('Passenger and Commercial Vehicles'.equals(this.loanTypeDetail) || 'Wheeled Plant & Equipment'.equals(this.loanTypeDetail)) {
            if (this.realtimeNaf < 5000) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NAF must be over $5,000, please check your information.'));
                r = false;
            }
        } else if ('Heavy Commercial Vehicles'.equals(this.loanTypeDetail)) {
            if (this.realtimeNaf < 10000) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NAF must be over $10,000, please check your information.'));
                r = false;
            }
        }
        
        if ('Used'.equals(this.condition) && 'Y'.equals(this.greenCar)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Used condition and green car should not be selected at the same time.'));
            r = false;
        }
        
        // Warnings
        if ('Used'.equals(this.condition) && this.carAge == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You are quoting a Used vehicle - pls check car age'));
        }
        if ('New/Demo'.equals(this.condition) && this.carAge > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You are quoting New/Demo - pls check car age'));
        }
        
        
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2017-09-19
        if (this.residualValue > 0 && this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }
    
    public void calculate () {
      baseRateCalc();
      if (isValidationOk()) {
        this.calculateRepayments();
      }
    }
    
    public void reset () {
      this.resetQuote();
      this.resetInsuranceProducts(false);
      
      //Initial values
      this.loanType = 'Purchase';
      this.productLoanType = 'Consumer Loan';
      this.loanTypeDetail = 'Passenger and Commercial Vehicles';
      this.tier = 'Option 1';

      // this.monthlyFee = 5.0;
      // this.ppsr = 6.80;
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = lenderSettings.PPSR__c;
      //this.applicationFee = 250.0;
      //this.dof = 500.0;
      this.term = 60;
      this.paymentType = 'Arrears';
      this.privateSales = 'N';
      this.saleBacksPurchased = 'N';
      this.condition = '';
      this.greenCar = '';
      this.carAge = 0;
      this.brokeragePercentage = null;
      this.resetLenderFees();
      
      //Rates
      rates = MetroCalculatorRates__c.getAll().values();
      rates.sort();
      
      this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    public List<MetroCalculatorRates__c> getPassengerAndCommercialRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[0]);
        r.add(rates[1]);
        r.add(rates[2]);
        return r;
    }
    public List<MetroCalculatorRates__c> getHeavyCommercialRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[3]);
        r.add(rates[4]);
        return r;
    }
    public List<MetroCalculatorRates__c> getWhelledPlantEquipmentRates() {
        List <MetroCalculatorRates__c> r = new List<MetroCalculatorRates__c>();
        r.add(rates[5]);
        r.add(rates[6]);
        r.add(rates[7]);
        return r;
    }
    
    private PageReference savePdf (String prefixName) {
      // pass parameters to the PDF page
      PageReference calcPdf = this.createPdf();
        
      // Lender parameter
      calcPdf.getParameters().put('brokeragePercentage', String.valueOf(this.brokeragePercentage));
      calcPdf.getParameters().put('privateSales', this.privateSales);
      calcPdf.getParameters().put('saleBacksPurchased', this.saleBacksPurchased);
      calcPdf.getParameters().put('carAge', String.valueOf(this.carAge));
      calcPdf.getParameters().put('vehicleCondition', this.condition);
      calcPdf.getParameters().put('greenCar', this.greenCar);
      calcPdf.getParameters().put('loanTypeDetail', this.loanTypeDetail);
      calcPdf.getParameters().put('clientTier', this.tier);

      savePdfInCloud(calcPdf, prefixName);
      return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        // validate calculation
        if (this.rental == null || this.rental == 0) {
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
        } else {
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
        updateProduct.Lender__c = 'Metro';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = this.loanTypeDetail;
        updateProduct.Loan_Term__c = this.term > 0? this.term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = this.dof > 0? this.dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        updateProduct.Lender_App_Fee__c = this.applicationFee > 0? this.applicationFee : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        
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
        System.debug(fileGlobalPrefix);
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        System.debug(fileGlobalPrefix);
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
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
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = (d != null)? d : new Application_Quoting__c();
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }

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
                this.brokeragePercentage = d.Brokerage__c;
                
                //Loan Details
                this.privateSales = d.Private_Sales__c;
                if (String.isNotBlank(d.Condition__c)) {
                    this.condition = d.Condition__c;
                }
                if (String.isNotBlank(d.Green_Car__c)) {
                    this.greenCar = d.Green_Car__c;
                }
                if (d.Vehicle_Age__c != null && d.Vehicle_Age__c.isNumeric()) {
                     this.carAge = Integer.valueOf(d.Vehicle_Age__c);
                } else {
                    d.Vehicle_Age__c = null;            
                }
                if (String.isNotBlank(d.Client_Tier__c)) {
                    this.tier = d.Client_Tier__c;
                }
                this.saleBacksPurchased = d.Sale_Backs_Purchased__c;
                this.loanTypeDetail = d.Loan_Facility_Type__c;
                
                this.resetLenderFees();
                baseRateCalc();
            }
        }
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
        
        System.debug('Saving Quoting...' + LENDER_QUOTING);

        //NWC Warning - I
        if (nwcParam != null && nwcParam.vehicleAgeYears != null && nwcParam.vehicleAgeYears > 20){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No car more than 20 years old can be covered. VechileYear: ' + nwcParam.vehicleAgeYears));
            return;
        }
        //NWC Warning - F

        Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
          this.updateQuotingData();
          d = this.quoting; 
        }
        
        //Finance Details
        d.Loan_Facility_Type__c = this.loanTypeDetail;
        d.Brokerage__c = this.brokeragePercentage;
        d.Client_Tier__c = this.tier;
        //Loan Details
        d.Private_Sales__c = this.privateSales;
        d.Condition__c = this.condition;
        d.Green_Car__c = this.greenCar;
        d.Vehicle_Age__c = (this.carAge != null) ? String.valueOf(this.carAge) : null;
        d.Sale_Backs_Purchased__c = this.saleBacksPurchased;
        
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
    }
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }

    //Lelo                      2017-07-21
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
        System.debug('sendCustomerEmail1...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            try {
                Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
                EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
    }
    //-
    
    //Lelo                      2017-07-24   
    private void calculateRepayments() {

        //Reset results
        this.resetCalculationResult();
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
        param.brokeragePer = this.brokeragePercentage;

        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
          this.estimatedCommission = r.Estimated_Commission__c;
          this.dofResult = r.DOF__c;
          this.insuranceIncome = r.Insurance_Income__c;
          this.totalCommission = r.Total_Commission__c;
          this.totalCommissionGst = r.Total_Commission_Gst__c;

          this.naf = r.NAF__c;
          this.rental = r.Rental__c;
          this.monthlyPayment = r.Monthly_Payment__c;
          this.fortnightlyPayment = r.Fortnightly_Payment__c;
          this.weeklyPayment = r.Weekly_Payment__c;
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
        //if (includeInsurance) {
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

    public List<MetroPlanOption__c> getLenderFeesTable() {
        List<MetroPlanOption__c> r = new List<MetroPlanOption__c>();
        Map<String, MetroPlanOption__c> d = QuotingCalculation.getMetroPlanOptions();
        for (String k : d.keySet()) {
            r.add(d.get(k));
        }
        return r;
    }

    public void changePlanOption() {
        this.resetLenderFees();
        this.baseRateCalc();
    }
    
  public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
    Decimal r = this.realtimeNaf;
    if (brokeragePercentage != null && brokeragePercentage != 0) {
      r += ((r * brokeragePercentage/100) * 1.025);
    }
    return r;
  }

  public void resetLenderFees() {
    this.plan = QuotingCalculation.getMetroPlanOptions().get(this.tier);
    if (this.plan != null) {
      this.applicationFee = this.plan.Application_Fee__c;
      this.dof = this.plan.DOF__c;
    }
  }

  public List <SelectOption> getSelectLoanTypeOptions() {
    List <SelectOption> r = new List <SelectOption> ();
    r.add(new SelectOption ('Passenger and Commercial Vehicles', 'Passenger and Commercial Vehicles'));
    r.add(new SelectOption ('Heavy Commercial Vehicles', 'Heavy Commercial Vehicles'));
    r.add(new SelectOption ('Wheeled Plant & Equipment', 'Wheeled Plant & Equipment'));
    return r;
  }

  public List<SelectOption> getSelectPlanOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','-- None --'));
        Map<String, MetroPlanOption__c> d = QuotingCalculation.getMetroPlanOptions();
        for (String k : d.keySet()){
            MetroPlanOption__c a = d.get(k);
            if (k.equals(this.tier) && this.plan == null) {
                this.plan = a;
            }
            r.add(new SelectOption(k,k));
        }
        return r;
    }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
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