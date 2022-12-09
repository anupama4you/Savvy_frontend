public class GreenLightCalculatorExtension extends QuotingExtension {
    
    //Lelo                  2016-09-02
    private String fileGlobalPrefix = 'GreenLight';
    public QuotingToolHelper qh {set;get;}
    // other things
    public Map<String, GreenLightRates__c> rates {get;set;}
    
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'Green Light';
    
    // Lender variables
    public Decimal brokeragePercentage {get;set;}
    public String clientTier {get;set;}
    public String clientTierAux {get;set;}
    public String assetType {set;get;}
    public Decimal vehicleYear {set;get;}
    public Decimal maxAppFee {get;set;}
    public Decimal maxDof {get;set;}
    public String lvrSel {set;get;}    
    
    public GreenLightCalculatorExtension(ApexPages.StandardController controller) {
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
                if (lender != null && lender.info != null && 'GRLI'.equals(lender.info.Code__c)) {
                    this.baseRate = lender.baseRate;
                    this.clientRate = lender.clientRate;
                    this.loanType = lender.loanType;
                    if(lender.carAge != null){
                    	this.vehicleYear = Decimal.valueOf(lender.carAge);    
                    }
                    this.brokeragePercentage = lender.brokerageBase;
                    //lender.privateSales;
                    //lender.productGoodsType;
                    //lender.additionalInfo;
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.clientTier = lender.clientTier;
                    this.productLoanType = lender.productLoanType;
                    baseRateCalc();
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }
    }
    
    public GreenLightRates__c getRate() {
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      param.assetType = this.assetType;
      param.clientTier = this.clientTier;
      param.ltv = this.lvrSel;
      if (this.vehicleYear != null) {
        param.vehicleYear = String.valueOf(this.vehicleYear.intValue());
      }
      System.debug('getRate... ' + param.assetType + '|' + param.clientTier + '|' + param.ltv + '|' + param.vehicleYear + '|');
      GreenLightRates__c r = QuotingCalculation.getRateGreenLight(param);
      if (r != null) {
        System.debug('Yes, I got the rate!');
      }
      return r;
    }
    
    public void baseRateCalc() {
      baseRateCalc(false);
    }

    public void clientTier() {
      baseRateCalc(true);
    }

    public void baseRateCalc(Boolean resetBrokerage) {
      GreenLightRates__c g = this.getRate();
      this.baseRate = 0.00;
      this.maxRate = 0.00;
      if (g != null) {
        this.baseRate = g.Base_Rate__c;
        this.maxRate = g.Max_Rate__c;
        if (this.baseRate == this.maxRate) {
          this.clientRate = this.baseRate;
        } else if (this.clientRate > this.maxRate) {
          this.clientRate = this.maxRate;
        }
        if (
          this.brokeragePercentage == null || 
          this.brokeragePercentage > g.Brokerage_Max__c ||
          resetBrokerage
        ) {
          this.brokeragePercentage = g.Brokerage_Max__c;
        }
      }
      calcFees(true);
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
        // System.debug('amuntPmt          : ' + amuntPmt);
        // System.debug('fv                : ' + fv);
        if (this.term > 0 && this.baseRate > 0 && amuntPmt > 0) {
            Integer type = 0;
            if ('Advance'.equals(this.paymentType))
                type = 1;
            Decimal pmt = FinancialUtilities.pmt2((this.baseRate/100/12), this.term, (amuntPmt * -1), fv, type);
            // System.debug('pmt                : ' + pmt);
            // System.debug('this.baseRate       : ' + this.baseRate);
            // System.debug('this.term           : ' + this.term);
            // System.debug('type               : ' + type);
            r = FinancialUtilities.rate2(this.term, pmt, (this.getRealtimeNafVal() * -1.0) , (fv * -1), type) * 12 * 100;
            // System.debug('this.getRealtimeNafCalc(calcType): ' + this.getRealtimeNafCalc(calcType));
            // System.debug('clientRate        : ' + r);  
            // System.debug('this.dof           : ' + this.dof);
            // System.debug('this.applicationFee           : ' + this.applicationFee);
            // System.debug('this.ppsr           : ' + this.ppsr);
            // System.debug('this.monthlyFee           : ' + this.monthlyFee);
        }
        return r;
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
        } else if (this.applicationFee > this.maxAppFee) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max Application Fee exceed.'));
        }
        if (this.dof == null || this.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        } else if (this.dof > this.maxDof) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max. DOF exceed.'));
            // r = false;
        }
        if (this.ppsr == null || this.ppsr == 0.0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
            //r = false;
        }
        //if('Budget Vehicle'.equals(this.clientTier)){
        //    if (this.brokeragePercentage == null || this.brokeragePercentage != 0.0) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Brokerage (%) is different of zero.'));
        //    }
        //}
        if (this.brokeragePercentage == null || this.brokeragePercentage == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Brokerage (%) is zero.'));
            //r = false;
        }
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate cannot be Zero.'));
            r = false;
        } else if (this.clientRate < this.baseRate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client rate should not be below Base Rate.'));
        }  else if (this.clientRate > this.maxRate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client rate should not be over Max Rate.'));
        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term (60 max).'));
            r = false;
        }
        if (this.term > 48 && 'Motorcycle'.equals(this.assetType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max term is 4 years for Motorcycle loans'));
            r = false;
        }

        if ('Car'.equals(this.assetType) && String.isBlank(this.lvrSel)) { 
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a LVR option.'));
          r = false;
        }

        GreenLightRates__c g = getRate();
        if (g != null) {
            /*
            if (this.brokeragePercentage > g.Brokerage_Max__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Brokerage is greater than ' + g.Brokerage_Max__c + '% for ' + g.Tier__c + ' tier'));
                //r = false;
            }
            */
            if (!this.getIsBadgedVehicle() && this.dof > g.DOF_Max__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF should not be greater than $' + g.DOF_Max__c.format() + ' for ' + g.Tier__c + ' tier'));
                //r = false;
            }
            if (g.Minimum_Deposit__c > 0 && this.getNetDepositVal() < g.Minimum_Deposit__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The minimum deposit is $' + g.Minimum_Deposit__c.format() + ' for ' + g.Tier__c + ' tier'));
            }
            Decimal currentNaf = this.getNafValidation(QuotingCalculation.CALC_QUOTING, false);
            if ('Budget Loan'.equals(g.Tier__c) && term >= 48 && currentNaf > g.Min_Loan_Value__c) {
              if (currentNaf < 10000) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, g.Tier__c + ', 4 year only available for loan value > $10K'));
              }
            } else {
              if (currentNaf < g.Min_Loan_Value__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The minimum NAF (excluding fees & charges) is $' + g.Min_Loan_Value__c.format() + ' for ' + g.Tier__c + ' tier'));   
              }
            }
            if (this.getTermYears() > g.Max_Loan_Term__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The maximum Loan Term is ' + g.Max_Loan_Term__c.format() + ' years for ' + g.Tier__c + ' tier'));
            }
            if(this.getIsBadgedVehicle()){
                if (this.baseRate == null || this.baseRate != g.Base_Rate__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Base Rate must be equal than the recommended rate for ' + g.Tier__c + ' tier'));
                }
            }else{
                if (this.baseRate == null || this.baseRate < g.Base_Rate__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate is lower than the recommended rate: ' + g.Base_Rate__c.format() + '% for ' + g.Tier__c + ' tier'));
                    r = false;   
                }
            }           
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        
        //Lelo              2017-09-19
        if (this.residualValue > 0 && this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        
        // Age of the vehicle
        Decimal age = Decimal.valueOf(Date.today().year());
        age -= this.vehicleYear;
        if (this.term != null) {
            age += (this.term/12);
        }
        if ('Car'.equals(this.assetType) && age > 20) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Car age maximum 20 years end of term - at Greenlight\'s discretion, current age: ' + age + ' years'));
            //r = false;   
        } else if ('Motorcycle'.equals(this.assetType) && age > 12) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Motorcycle age maximum 12 years end of term, current age: ' + age + ' years'));
            // r = false;
        }
        // if ('Car'.equals(this.assetType)) {
        //     if (age >= 0 && age <= 10 && this.term > 60) {
        //         ApexPages.addMessage(new ApexPages.Message(
        //             ApexPages.Severity.ERROR,'Max term of 5 years for vehicle age greater than 10 years.'));
        //         r = false;
        //     } else if (age == 11 && this.term > 48) {
        //         ApexPages.addMessage(new ApexPages.Message(
        //             ApexPages.Severity.ERROR,'Max term of 4 years for vehicle age greater than 11 years.'));
        //         r = false;
        //     } else if (age >= 12 && this.term > 36) {
        //         ApexPages.addMessage(new ApexPages.Message(
        //             ApexPages.Severity.ERROR,'Max term of 3 years for vehicle age greater than 12 years.'));
        //         r = false;
        //     }
        //     if (this.term != null) {
        //         age += (this.term/12);
        //     }
        //     if (age > 15 && this.carPrice != null && (this.carPrice - this.getNetDepositVal()) > 15000.0) {
        //         ApexPages.addMessage(new ApexPages.Message(
        //             ApexPages.Severity.ERROR,'Max car price $15,000 for vehicle age greater than 15 years at term end'));
        //         r = false;
        //     }
        // }
        return r;
    }
    
    public void calculate() {
      this.loadGreenLightRates();
      baseRateCalc();
      if (isValidationOk()) {
        this.calculateRepayments();
      }
    }
    
    public void reset() {
        this.resetQuote();

        this.assetType = 'Car';
        
        //Check Vehicle details
        this.vehicleYear = Date.today().year();
        if (this.Opp.Application_AssetDetail__c != null) {
            if ('Motorcycle'.equals(this.Opp.Application_AssetDetail__r.Type__c)) {
                this.assetType = this.Opp.Application_AssetDetail__r.Type__c;
            }
            if (this.Opp.Application_AssetDetail__r.Year__c != null) {
                this.vehicleYear = this.Opp.Application_AssetDetail__r.Year__c;
            }
        } else if (this.Opp.Application__c != null && this.Opp.Application__r.Vehicle_Year__c != null && this.Opp.Application__r.Vehicle_Year__c.isNumeric()) {
            this.vehicleYear = Decimal.valueOf(this.Opp.Application__r.Vehicle_Year__c);
        }        
        
        this.clientTier = 'Platinum';
        // Load Rates
        this.loadGreenLightRates();
        GreenLightRates__c r = rates.get(this.clientTier);
        //Initial values
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.applicationFee = lenderSettings.Application_Fee__c;
        
        this.term = 60;
        this.paymentType = 'Arrears';
        this.lvrSel = null;
        if (r != null) {
          // this.dof = r.DOF_Max__c;
          this.brokeragePercentage = r.Brokerage_Max__c;
        }
        
        this.resetInsuranceProducts(false);
        this.calcFees();
        baseRateCalc();
        
        this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    public List <SelectOption> getSelectTierOptions() {
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        if (String.isNotBlank(this.assetType)) {
          QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
          param.assetType = this.assetType;
          Set<String> prods = QuotingCalculation.getGreenLightProducts(param);
          for (String o : rates.keySet()) {
              r.add(new SelectOption (o, o));
          }
        }
        return r;
    }
    
    private PageReference savePdf (String prefixName) {
        // pass parameters to the PDF page
        PageReference calcPdf = this.createPdf();
        
        // Lender parameter
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(this.brokeragePercentage));
        calcPdf.getParameters().put('paymentType', this.paymentType);
        
        calcPdf.getParameters().put('clientTier', this.clientTier);
        calcPdf.getParameters().put('ltv', String.isNotBlank(this.lvrSel)? this.lvrSel : '[--none--]');
        
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
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,
                             Loan_Type__c,Loan_Term__c,Balloon_Residual_Requested__c,
                             Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,
                             Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
        
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = LENDER_QUOTING;
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = 'Client Tier ' + this.clientTier;
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
    
    public List<GreenLightRates__c> getCalculatorRates() {
      List<GreenLightRates__c> r = new List<GreenLightRates__c>();
      List<GreenLightRates__c> rates = GreenLightRates__c.getAll().values();
      r.sort();
      for (GreenLightRates__c g: rates) {
        if (String.isBlank(g.LVR__C)) {
          r.add(g);
        }
      }
      return r;
    }
    
    //Lelo                                  2016-07-26
    public PageReference saveQuoting() {
        //Recalculate
        if (hasCalculationDone() && !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
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
            System.debug('d != null >>>>>>>>>>>>>>>>>>>>>>>>>>>> ' + d);
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
              if (d.Base_Rate__c != null) {
                  this.baseRate = d.Base_Rate__c.setScale(2);
              }
              //Loan Details
              this.paymentType = d.Payment__c;                
              this.clientRate = d.Client_Rate__c;                
              if (this.clientRate != null) {
                  this.clientRate = this.clientRate.setScale(2);
              }
              this.clientTier = d.Client_Tier__c;
              this.lvrSel = d.LTV__c;
              
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
      //Application_Quoting__c s = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
      if (this.quoting != null) {
        this.updateQuotingData();
        d = this.quoting; 
      }
      
      //-
      //Loan Details
      d.Brokerage__c = this.brokeragePercentage;
      d.Client_Tier__c = this.clientTier;
      d.LTV__c = this.lvrSel;
      d.Payment__c = this.paymentType;
      
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
        param.baseRate = this.baseRate;
        param.maxRate = this.maxRate;
        param.clientRate = this.clientRate;
        param.clientTier = this.clientTier;
        param.paymentType = this.paymentType;
        param.term = this.term;
        param.dof = this.dof;
        param.monthlyFee = this.monthlyFee;
        param.residualValue = this.residualValue;
        param.brokeragePer = this.brokeragePercentage;
        param.amountBaseComm = this.getNafValidation(quotingType, true);
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
        param.amountBaseComm = this.getNafValidation(quotingType, true);
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
          param.amountBaseComm = this.getNafValidation(quotingType, true);
          r = QuotingCalculation.calculate(param);
          if (r != null) {
              r.Result_Type__c = key;   
          }
          calResults.put(key, r);                
        }
    }
    
    public void loadGreenLightRates() {
        List<GreenLightRates__c> data = GreenLightRates__c.getAll().values();
        rates = new Map<String, GreenLightRates__c>();
        if (data != null) {
            data.sort();
            for (GreenLightRates__c g : data) {
                if (g.Asset_Type__c.equals(this.assetType)) {
                    rates.put(g.Tier__c, g);
                }
            }
        }
        if (!rates.containsKey(this.clientTier) && !rates.isEmpty()) {
            this.clientTier = rates.values().get(0).Tier__c;
        }
    }
    
    public List<SelectOption> getYears() {
        List<SelectOption> r = new List<SelectOption>();
        Integer ytop = Date.today().year();
        for (Integer i = 0; i < 20; i++) {
            r.add(new SelectOption(String.valueOf(ytop-i), String.valueOf(ytop-i)));
        }
        return r;
    }
  
  public void calcFees() {
    calcFees(false);
  }

  public void calcFees(Boolean onlyMax) {
    // this.maxAppFee = 0.00;
    // this.maxDof = 0.00;
    Decimal b = this.getNafValidation(QuotingCalculation.CALC_QUOTING, false);
    this.maxAppFee = b * 0.1;
    this.maxDof = b * .08;
    if (this.maxAppFee == 0 || this.maxAppFee > lenderSettings.Application_Fee__c) {
      this.maxAppfee = lenderSettings.Application_Fee__c;
    }
    if (this.maxDof == 0 || this.maxDof > lenderSettings.DOF__c) {
      this.maxDof = lenderSettings.DOF__c;
    }
    if (!onlyMax) { 
      this.applicationFee = this.maxAppFee;
      this.dof = this.maxDof;
    }
  }

  public Decimal getMaxAppFeeVal() {
    calcFees(true);
    return this.maxAppFee;
  }

  public List <SelectOption> getLVROptions() {
    List <SelectOption> r = new List <SelectOption> ();
    r.add(new SelectOption ('', '--None--'));
    r.add(new SelectOption ('<=90%', '<=90%'));
    r.add(new SelectOption ('>90-100%', '>90-100%'));
    r.add(new SelectOption ('>100-130%', '>100-130%'));
    return r;
  }

  public boolean getIsBadgedVehicle(){
    return 'Budget Vehicle'.equals(clientTier);
  }

  public void calculateBadgedVehicleLendersFees(){
    if((carPrice!=null)){
      Decimal baseNAFBadged = carPrice + this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING) + this.getNetDepositVal();
      dof = MATH.round(baseNAFBadged*0.08);
      applicationFee = MATH.round(baseNAFBadged*0.08);
    }
  }

  public override Decimal getTotalAmount(String calcType) {
    if(getIsBadgedVehicle()){
        calculateBadgedVehicleLendersFees();
    }
    return super.getTotalAmount(calcType);
  }

  public Decimal getNafValidation(String calcType, Boolean excludeInsurances) {
    Decimal r = 0;
    if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
        if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
    } else {
        if (carPrice != null) r += carPrice;
    }
    r -= getNetDepositVal();
    if (excludeInsurances) {
      r += this.getTotalInsuranceType(calcType);
    }
    return r;
  }
  
  public Decimal getTermYears() {
    return (term == null)? 0.00 : this.term / 12.00;
  }

  public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
    Decimal r = getRealtimeNafVal();
    if (brokeragePercentage != null && brokeragePercentage != 0) {
            r += ((getBaseAmountPmtCalc(calcType) * brokeragePercentage/100));
    }
    return r;
  }

  public Decimal getBaseAmountPmtCalc(String calcType) {
    Decimal r = super.getTotalAmount(calcType);
    r += this.getTotalInsuranceType(calcType);
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