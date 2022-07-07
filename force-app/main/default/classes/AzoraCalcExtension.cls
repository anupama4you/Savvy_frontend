public class AzoraCalcExtension extends QuotingExtension {
    
    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'AzoraCon';
    //-    
    
    // finance calculator input
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}
    public String loanTypeDetail {get;set;}
    public String repaymentType {get;set;}
    public String propertyOwner {get;set;}
    
    public List <SelectOption> RepaymentTypes {get;set;}
    public List <SelectOption> Terms {get;set;}
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> loanTypeOptionsCus {get;set;}
    public Azora_Rates__c rateSel {set;get;}

    // rates references
    public List <Azora_Rates__c> azoraRates {get;set;}
    Map <String,Azora_Rates__c> azoraRatesMap {get;set;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Azora Consumer';
    
    public AzoraCalcExtension (ApexPages.StandardController controller) {
      super(controller);
      
      azoraRatesMap = Azora_Rates__c.getAll();
      azoraRates = azoraRatesMap.values();
      
      RepaymentTypes = new List <SelectOption> ();
      RepaymentTypes.add(new SelectOption ('', '--None--'));
      RepaymentTypes.add(new SelectOption ('Monthly', 'Monthly'));
      RepaymentTypes.add(new SelectOption ('Weekly', 'Weekly'));
      RepaymentTypes.add(new SelectOption ('Fortnightly', 'Fortnightly'));
      Terms = new List <SelectOption> ();
      Terms.add(new SelectOption ('', '--None--'));
      Terms.add(new SelectOption ('36', '36'));
      Terms.add(new SelectOption ('48', '48'));
      Terms.add(new SelectOption ('60', '60'));
      Terms.add(new SelectOption ('72', '72'));
      Terms.add(new SelectOption ('84', '84'));
      //-
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
                if (lender != null && lender.info != null && LENDER_QUOTING.equals(lender.info.Lender__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    //this.productGoodsType = lender.productGoodsType;
                    this.productLoanType = lender.productLoanType;
                    this.loanTypeDetail = lender.loanType;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
                    //
                    //baseRateCalc();
                    
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }
        baseRateCalc();
    }

    public void calculateValidation () {
        this.isValidationOk();
        
        System.debug('loanTypeDetail: ' + loanTypeDetail + '|clientRate: ' + clientRate + '|term: ' + term);
    }
            
    public void baseRateCalc () {
        Decimal originalRate = 0;
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.productLoanType = this.productLoanType;
        param.loanTypeDetail = this.loanTypeDetail;
        //this.baseRate = QuotingCalculation.getBaseRate(param);
        //this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
        rateSel = QuotingCalculation.getAzora(param);
        System.debug(rateSel);
        if(rateSel != null){
            clientRate = rateSel.Rate__c;
            System.debug(clientRate);
            //riskFee = rateSel.Risk_Fee__c;
            riskFeeTotal = rateSel.Risk_Fee__c;
        }
    } //end of funcion

    public void riskFeeCalc () {
      netDepositCalc();
      //riskFeeTotal = this.getRiskFeeCalc(QuotingCalculation.CALC_QUOTING);
      realtimeNaf = getRealTimeNAFCalc(QuotingCalculation.CALC_QUOTING);
    } //end of funcion

    //Lelo          2017-07-27
    public Decimal getRealTimeNAFCalc(String calcType) {
        Decimal r = this.getNafCommission(calcType);
        // r += this.getRiskFeeCalc(calcType);
        if (this.riskFee != null) {
            r += this.riskFee;
        }
        if (applicationFee != null) r+= applicationFee;
        // if (!'Economy'.equals(this.loanTypeDetail)) {
            if (dof != null) r+= dof;
        // }
        if (ppsr != null) r+= ppsr;
        return  r;
    }

    private Boolean isValidationOk() {
        Boolean r = true;
        ApexPages.getMessages().clear();
        baseRateCalc ();
        riskFeeCalc ();
        System.debug('1) ' + r);
        // validation before calculation
        if (clientRate == null || clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }

        if (String.isBlank(loanTypeDetail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Credit Score.'));
            r = false;
        }else{
          if (String.isBlank(repaymentType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Repayment.'));
            r = false;
          }  
          if (applicationFee > 995) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee should not be greater than $995.'));
          }
          if (monthlyFee != 15) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Monthly Fee should be $15.'));
          }
          if (dof > maxDof) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF hould not be greater than $'+maxDof+'.'));
          }
          
          if('832 - 1200'.equals(loanTypeDetail) && '725 - 832'.equals(loanTypeDetail) && '621 - 725'.equals(loanTypeDetail) && '509 - 621'.equals(loanTypeDetail) && riskFee != riskFeeTotal){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should be Zero'));
          }else if(riskFee > riskFeeTotal){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should not be greater than $'+riskFeeTotal+'.'));
          }
          if (applicationFee < 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee should not be below Zero.'));
            r = false;
          }
          if (dof < 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF should not be below Zero.'));
            r = false;
          }
          if (monthlyFee < 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Monthly Fee should not be below Zero.'));
            r = false;
          }
          if (riskFee < 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Risk Fee should not be below Zero.'));
            r = false;
          }

          Decimal minLoan = carPrice - netDeposit;
          
          if (minLoan < 7500 || realtimeNaf > rateSel.Max_Loan__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan amount should be between $7500 and $'+rateSel.Max_Loan__c));
          }
        }
        System.debug('2) ' + r);
        
        System.debug('3) ' + r);
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        System.debug('4) ' + r);
        
        System.debug('5) ' + r);
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        System.debug('6) ' + r);
        
        return r;
    }

    public void calculate () {
      //applicationFeeCalc();
      riskFeeCalc();
      baseRateCalc();
      if (isValidationOk()) {
        this.calculateRepayments();
        if (estimatedCommission <= 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
      }
    } // end of function
    
    public void reset() {
      this.resetQuote();
      this.loanTypeOptionsCus = new List <SelectOption> ();
      this.loanTypeOptionsCus.add(new SelectOption ('Purchase', 'Purchase'));
      this.loanTypeOptionsCus.add(new SelectOption ('Refinance', 'Refinance'));
      this.productLoanTypes = QuotingToolHelper.getLoanProductOptionsConsumer();

      this.loanType = loanTypeOptions.get(0).getValue();
      this.productLoanType = productLoanTypes.get(0).getValue();

      this.loanType = 'Purchase';
      this.productLoanType = 'Consumer Loan';
      this.loanTypeDetail = '';
      this.applicationFee = lenderSettings.Application_Fee__c;
      this.dof = lenderSettings.DOF__c;
      this.maxDof = lenderSettings.DOF__c;
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = 0.00;
      this.riskFee = 0.00;
      this.riskFeeTotal = 0.00;
      this.term = 60;
      
      this.resetInsuranceProducts(false);

      this.netDepositCalc();
      this.riskFeeCalc();
      
      this.resetCalculationResult(); //Lelo       2017-07-25
      baseRateCalc();
    } // end of function
    
    private PageReference savePdf (String prefixName) {
      PageReference calcPdf = this.createPdf();
      calcPdf.getParameters().put('lender', 'AZORA CONSUMER CALCULATION');
        
      // Lender parameters
      calcPdf.getParameters().put('loanTypeDetail', this.loanTypeDetail);
      calcPdf.getParameters().put('riskFee', String.valueOf(this.riskFee));
      calcPdf.getParameters().put('repaymentType',this.repaymentType);
      
      savePdfInCloud(calcPdf, prefixName);
      return null;
    } // end of function
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }

        if ('AzoraCon_PRE_APPROVAL'.equals(prefixName)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Do not send the loan to Azora unless the licence address is correct'));
        }
        
        calculate();
        
        // validate calculation
        if (rental == null || rental == 0) {
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

        //Lelo                                  2016-07-26
        savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(
              RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
              Opportunity_Name__c = this.Opp.Id);
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Quoting_Source__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,
                             Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
            
        if (productLoanType == 'Consumer Loan') {
            updateProduct.Loan_Purpose__c = 'Personal Use';
        } else {
            updateProduct.Loan_Purpose__c = 'Business Use';
        }
        
        updateProduct.Lender__c = 'Azora';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = loanTypeDetail;

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
    
    //Lelo                                  2016-07-26
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
        if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
            if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
            }
        }
        return null;
    }
    //-
    
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
        this.resetInsuranceProducts(true);

        //Finance Details
        //Commons values
        loanType = d.Loan_Type__c;
        productLoanType = d.Loan_Product__c;
        carPrice = d.Vehicle_Price__c;
        deposit = d.Deposit__c;
        tradeIn = d.Trade_In__c;
        payoutOn = d.Payout_On__c;
        netDepositCalc();
        
        if (d.Term__c != null) {
          term = Integer.valueOf(d.Term__c);
        }

        if (sameQuoting) {
          this.loadQuotingInsuranceData();
          this.loadQuotingData();
          //Specific values

          //Loan Details
          repaymentType = d.Payment__c;
          loanTypeDetail = d.Loan_Facility_Type__c;
          riskFee = d.Risk_Fee__c;
        }
      }
      riskFeeCalc();
      baseRateCalc();
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
      d.Loan_Facility_Type__c = loanTypeDetail;
      d.Payment__c = repaymentType;
      d.Risk_Fee__c = riskFee;
      
      //Save the record
      QuotingToolHelper.saveApplicationQuoting(d);

      //Save calculations
      QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

    }
    //-
    
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
            if (rental != null && rental > 0) {
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
    public Decimal getNafCommission(String calcType) {
        return getNafCommission(calcType, null);
        //netDepositCalc();
        //Decimal r = 0.0;

        //if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        //    if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        //} else {
        //    if (carPrice != null) r += carPrice;
        //}
        //if (netDeposit != null) r -= netDeposit;
        //r += this.getTotalInsuranceType(calcType);
        //return r;
    }
    public Decimal getNafCommission(String calcType, Decimal totalInsurance) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (netDeposit != null) r -= netDeposit;
        if (totalInsurance != null) {
            r += totalInsurance;
        } else {
            r += this.getTotalInsuranceType(calcType);
        }
        //System.debug('getNafCommission|' + calcType + '|' + totalInsurance + '|' + r);
        return r;
    }


    //Lelo                      2017-07-24   
    public override Decimal getTotalAmount(String calcType) {
      netDepositCalc();
      Decimal r = 0.0;

      if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
          if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
      } else {
          if (carPrice != null) r += carPrice;
      }
      if (applicationFee != null) r += applicationFee;
      // if (!'Economy'.equals(this.loanTypeDetail)) {
          if (dof != null) r+= dof;
      // }
      if (ppsr != null) r += ppsr;
      if (netDeposit != null) r -= netDeposit;
      //r += this.getRiskFeeCalc(calcType);
      if (riskFee != null) r += riskFee;
      return r;
    }

    private void calculateRepayments() {

      //Reset results
      this.resetCalculationResult();
      //FULL CALCULATION
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      String quotingType = QuotingCalculation.CALC_QUOTING;
      param.productLoanType = this.productLoanType;
      param.loanTypeDetail = this.loanTypeDetail;
      param.totalAmount = getTotalAmount(quotingType);
      param.totalInsurance = getTotalInsuranceType(quotingType);
      param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
      param.clientRate = clientRate;
      param.repaymentType = repaymentType;
      param.term = term;
      param.dof = dof;
      param.monthlyFee = monthlyFee;
      param.nafCommission = this.getNafCommission(quotingType);

      System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.nafCommission + '|' + param.getNAF());
      Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
      System.debug(r);
      if (r != null) {
        estimatedCommission = r.Estimated_Commission__c;
        dofResult = r.DOF__c;
        insuranceIncome = r.Insurance_Income__c;
        totalCommission = r.Total_Commission__c;
        totalCommissionGst = r.Total_Commission_Gst__c;

        naf = r.NAF__c;
        rental = r.Rental__c;
        monthlyPayment= r.Monthly_Payment__c;
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
      //MV
      if (mv != null && mv > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
      }
      //GAP
      if (gap != null && gap > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
      }
      //WARR
      if (warranty != null && warranty > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
      }
      //NWC
      if (nwc != null && nwc > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
      }
      //CCI
      //Lelo          Insurance           2018-02-26
      if (cci != null && cci > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
      }
      //-
      
      for (String key: calcTypes) {
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = this.getTotalInsuranceType(key);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
        param.nafCommission = this.getNafCommission(quotingType);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = key;   
        }
        calResults.put(key, r);                
      }

    }
    
    public List<SelectOption> getCreditScore() {
      List<SelectOption> r = new List<SelectOption> ();
      r.add(new SelectOption('','--None--'));
      
      List<Azora_Rates__c> d = Azora_Rates__c.getAll().values();
      d.sort(); 
      if (!d.isEmpty()) {
        for (Azora_Rates__c a: d) {
          r.add(new SelectOption (a.Credit_Score__c, a.Credit_Score__c));
        }
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