public class UMELoansExtension extends QuotingExtension {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'UME_Loans';
    //-
    
    public QuotingToolHelper qh {set;get;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'UME Loans';
    //-

    public UMELoansExtension(ApexPages.StandardController controller) {
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
            // System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'UMEL'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    //Lelo                          2017-11-16
                        this.clientRate = lender.clientRate;
                        this.baseRate = lender.clientRate;
                        this.dof = lender.dofBase;
                    //
                    this.quotingFeesCalc(true);
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
        this.quotingFeesCalc(true);
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: DOF is the slower of 11% of car price or $1795'));
        }

        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else if (clientRate > lenderSettings.Default_Base_Rate__c) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be greater than '+lenderSettings.Default_Base_Rate__c+'%'));
          r = false;
        }
        if (monthlyFee < 10 || monthlyFee > 28) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Monthly Fee should be between 10 $ and 28 $'));
          r = false;
        }
        if (ppsr > lenderSettings.PPSR__c) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be greater than '+lenderSettings.PPSR__c));
          r = false;
        }
        if (this.getRealtimeNafVal() > 30000) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Max NAF $30,000 please refer to lender'));
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
        quotingFeesCalc(false);
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.clientRate = lenderSettings.Default_Base_Rate__c;
        this.term = 60;
        this.paymentType = 'Arrears';
        this.loanPurpose = '';
        this.resetInsuranceProducts(false);
        this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        // pass universal variables
        calcPdf.getParameters().put('lender', 'UME LOANS CALCULATION');
        
        // Lender parameters// Lender parameters
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
        updateProduct.Lender__c = 'UME Loans';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
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
                loanPurpose = d.Loan_Purpose__c;
            }
            
        }
        //this.profileOnChangeAction(true);
        this.quotingFeesCalc(true);
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
      d.Monthly_Fee__c = this.monthlyFee;

      //Loan Details
      d.Payment__c = this.paymentType;
      d.Loan_Purpose__c = loanPurpose;
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
    
    //param.amountBaseComm = this.getLoanAmount();
    // System.debug(param);
    // System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

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

    public void quotingFeesCalc() {
      quotingFeesCalc(false);
    }
// TODO: pregunta pendiente
    public void quotingFeesCalc(Boolean maxOnly) {
      this.maxDof = getLoanAmount() * 0.11;
          
      if (this.maxDof > lenderSettings.Max_DOF__c) {
        this.maxDof = lenderSettings.Max_DOF__c;
      }

      if (!maxOnly) {
        this.dof = this.maxDof;
      }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    
  public Decimal getLoanAmount() {
    Decimal r = 0.0;
    r += (this.carPrice != null)? this.carPrice : 0;

    r -= getNetDepositVal();

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