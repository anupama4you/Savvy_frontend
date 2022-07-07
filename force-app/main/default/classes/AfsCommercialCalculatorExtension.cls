public class AfsCommercialCalculatorExtension extends QuotingExtension  {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'AFSCommercial';
    
    public QuotingToolHelper qh {set;get;}
    private Map<String, List<AfsRate>> rates = null;
    public List<AFS_Commercial_Rates__c> fullRates {get;set;}
    
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'AFS Commercial';
    
    // Lender variables
    public Decimal registrationFee {get;set;}
    public String carAge {set;get;}
    public String residency {get;set;}
    
    public AfsCommercialCalculatorExtension(ApexPages.StandardController controller) {
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
                if (lender != null && lender.info != null && 'AFSM'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.carAge = lender.clientTier;
                    this.clientRate = lender.clientRate;
                    this.residency = lender.residentialStatus;
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }
    
    public Boolean isValidationOk() {
        Boolean r = true;
        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        if (this.applicationFee == null || this.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > 990) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be more than $990.'));
            r = false;
        }
        //if (this.ppsr == null || this.ppsr == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
        //    r = false;
        //}
        //if (this.baseRate == null || this.baseRate == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
        //    r = false;
        //}
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else {
            Decimal minRate = 0.0;
            Decimal maxRate = 0.0;

            List<AfsRate> rts = rates.get(this.carAge);
            
            if ('Not Registered'.equals(quoting.GST__c)) {
              rts = rates.get('Used 7 years+');
              minRate = rts.get(3).rate;
              maxRate = rts.get(rts.size()-1).rate;
            } else if ('Home Buyer'.equals(residency) || ('Non-Home Buyer'.equals(residency) && 'Used 7 years+'.equals(this.carAge))) {
              minRate = rts.get(0).rate;
              maxRate = rts.get(rts.size()-1).rate;
            } else {
              minRate = rts.get(6).rate;
              maxRate = rts.get(rts.size()-1).rate;
            }

            if (this.clientRate < minRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The minimun Client Rate for ' + this.carAge + ' is ' + minRate + '%, please check your value and try again.'));
            	r = false;
            }
            if (this.clientRate > maxRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximun Client Rate for ' + this.carAge + ' is ' + maxRate + '%, please check your value and try again.'));
                r = false;
            }


        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        
        if (''.equals(this.residency) || this.residency == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Residency is required.'));
            r = false;
        }
        
        if ('Renting'.equals(this.residency)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'20% deposit required.'));
        }
        if ('Boarding/Other'.equals(this.residency)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Must be renting/property owner to qualify.'));
            r = false;
        }

        // if (this.getRealtimeNafVal() < 15000.0) {
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Min NAF applies. ($15.000)'));
        //     r = false;   
        // }

        if (!isInsuranceValidationOK()) {
            r = false;   
        }

        //Lelo              2017-09-19
        if (this.residualValue > 0 && this.carPrice != null) {
            Decimal cp = this.carPrice - this.getNetDepositVal();
            if (cp != 0) {
                Decimal pb = (this.residualValue / cp) * 100;
                if (this.term == 12 && pb > 60.0) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Balloon should not exceed 60% of vehicle price for 12 months term. Current value [' + pb.setScale(2) + '%]'));
                    r = false;           
                } else if (this.term == 24 && pb > 55.0) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Balloon should not exceed 55% of vehicle price for 24 months term. Current value [' + pb.setScale(2) + '%]'));
                    r = false;           
                } else if (this.term == 36 && pb > 50.0) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Balloon should not exceed 50% of vehicle price for 36 months term. Current value [' + pb.setScale(2) + '%]'));
                    r = false;           
                } else if (this.term == 48 && pb > 40.0) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Balloon should not exceed 40% of vehicle price for 48 months term. Current value [' + pb.setScale(2) + '%]'));
                    r = false;           
                } else if (this.term == 60 && pb > 30.0) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Balloon should not exceed 30% of vehicle price for 60 months term. Current value [' + pb.setScale(2) + '%]'));
                    r = false;           
                }
            }
        }

        if (''.equals(quoting.GST__c) || quoting.GST__c == null) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'GST is required.'));
          r = false;
        }
        
        if ('Home Buyer'.equals(residency) &&  getRealtimeNafVal() > 75000) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Max NAF of $75,000'));
        }
          
        if ('Non-Home Buyer'.equals(residency) &&  getRealtimeNafVal() > 50000) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Max NAF of $50,000'));
        }
        
        if ('Not Registered'.equals(quoting.GST__c) &&  getRealtimeNafVal() > 35000) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: max NAF $35K for non GST registered'));
        }

        return r;
    }
    
    public void calculate () {
      if (isValidationOk()) {
        this.calculateRepayments();
        if (this.estimatedCommission <= 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
      }
    }
    
    public void reset () {
      this.resetQuote();
      
      //Initial values
      this.carAge = 'New - 6 years old';
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = lenderSettings.PPSR__c;
      this.applicationFee = lenderSettings.Application_Fee__c;
      this.dof = lenderSettings.DOF__c;
      this.registrationFee = lenderSettings.Registration_Fee__c;
      this.baseRate = 0.0;
      this.clientRate = 0.0;
      this.term = 60;
      this.paymentType = 'Arrears';
      this.resetInsuranceProducts(false);
      this.skipIntegrityPayType = true;
      fullRates = AFS_Commercial_Rates__c.getAll().values();
      fullRates.sort();
      rates = new Map<String, List<AfsRate>>();

      List<AfsRate> r1 = new List<AfsRate>();
      List<AfsRate> r2 = new List<AfsRate>();
      
      for (AFS_Commercial_Rates__c a : fullRates) {
          r1.add(new AfsRate(a.Rate__c, a.Comm_07_Years__c));
          r2.add(new AfsRate(a.Rate_2__c, a.Comm_8_Years__c));
      }

      rates.put('New - 6 years old', r1);
      rates.put('Used 7 years+', r2);

      this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    private Decimal getCommissionRate() {
        Decimal r = 0.0;
        if (this.clientRate != 0) {
        	List<AfsRate> rts = rates.get(this.carAge);
        	for (AfsRate a : rts) {
        		if (this.clientRate >= a.rate) {
        			r = a.comm;
        		}
        	}
        }
        // System.debug(this.carAge + ' comms >> ' + r);
        return r;
    }
    
    class AfsRate {
    	Decimal rate {set;get;}
    	Decimal comm {set;get;}

    	public AfsRate(Decimal rate, Decimal comm) {
    		this.rate = rate;
    		this.comm = comm;
    	}
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'AFS COMMERCIAL CALCULATION');

        //pass variables about the product info
        calcPdf.getParameters().put('carAge', this.carAge);
        calcPdf.getParameters().put('residency', this.residency);
        calcPdf.getParameters().put('registrationFee', String.valueOf(this.registrationFee));
        calcPdf.getParameters().put('productLoanType', this.productLoanType);
        calcPdf.getParameters().put('GST', quoting.GST__c);        
        
        savePdfInCloud(calcPdf, prefixName);
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }

        if (prefixName.contains('FORMAL')) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Before submitting for formal approval you must have two references not living with the applicant Documents cannot be produced without this'));
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
        updateProduct.Lender__c = 'AFS';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = 'Car Age ' + this.carAge;
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
        updateProduct.Equalisation_Fee_PPSR__c += this.registrationFee > 0? this.registrationFee : 0.00;
        
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
                if (d.Client_Rate__c != null) {
                    this.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                this.paymentType = d.Payment__c;
                this.carAge = d.Vehicle_Age__c;
                this.residency = d.Residency__c;
                this.registrationFee = d.Registration_Fee__c;
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
        
        //-
        //Finance Details
        d.Registration_Fee__c = this.registrationFee;
        d.Residency__c = this.residency;
        d.Vehicle_Age__c = this.carAge;
        d.Payment__c = this.paymentType;
        
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
    //Quote
    this.baseRate = this.clientRate;
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
    param.commRate = this.getCommissionRate();
    
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
      param.totalAmount = this.getTotalAmount(key);
      param.totalInsurance = this.getTotalInsuranceType(key);
      param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
      r = QuotingCalculation.calculate(param);
      if (r != null) {
          r.Result_Type__c = key;   
      }
      calResults.put(key, r);                
    }
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

  public override Decimal getTotalAmount(String calcType) {
    Decimal r = super.getTotalAmount(calcType);
    r += (this.registrationFee != null)? this.registrationFee : 0;
    return r;
  }

  public List <SelectOption> getSelectCarAgeOptions() {
    List <SelectOption> r = new List <SelectOption> ();
    r.add(new SelectOption ('New - 6 years old', 'New - 6 years old'));
    r.add(new SelectOption ('Used 7 years+', 'Used 7 years+'));
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