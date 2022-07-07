public class AfsCalculatorExtension extends QuotingExtension {
    
    //Lelo                  2016-09-02
    private String fileGlobalPrefix = 'AFSConsumer';
    //-
    public QuotingToolHelper qh {set;get;}
    private Map<String, List<AfsRate>> rates = null;
    public List<ASFRates__c> fullRates {get;set;}
    public List<AFSRateV2__c> fullRatesV2 {get;set;}
    
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'AFS Consumer';
    
    // Lender variables
    public Decimal registrationFee {get;set;}
    public String carAge {set;get;}
    public String bankrupt {get;set;}
    public String residency {get;set;}
    public String hasDefaults {get;set;}
    public String assetType {get;set;}
    public String assetCondition {get;set;}
    public Integer lvr {get;set;}
    public String payDayEnquiries {get;set;}
    public String hasImports {get;set;}
    public String odometer {get;set;}
    public String privateSales {get;set;}
    public String casual {get;set;}

    public AfsCalculatorExtension(ApexPages.StandardController controller) {
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
          if (lender != null && lender.info != null && 'AFSC'.equals(lender.info.Code__c)) {
            this.carPrice = lender.carPrice;
            this.deposit = lender.deposit;
            this.term = lender.term;
            this.baseRate = lender.baseRate;
            // this.clientTier = lender.clientTier/*+ ' ('+lender.riskGrade+')'*/;
            this.clientRate = lender.clientRate;
            // this.riskGrade = lender.riskGrade;
            this.bankrupt = lender.bankrupt;
            this.hasDefaults = lender.hasDefault;
            this.residency = lender.residentialStatus;
            this.assetType = lender.productGoodsType;
            this.assetCondition = lender.condition;
            this.carAge = lender.vehicleYear;
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
        this.baseRateCalc();
        
        // if(''.equals(this.clientTier) || this.clientTier == null){
        //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Tier is required.'));
        //     r = false;
        // }  
        
        if (String.isBlank(this.assetCondition)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Asset Condition is required.'));
            r = false;
        }
        
        if (''.equals(this.residency) || this.residency == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Residency is required.'));
            r = false;
        }
        
        if (String.isBlank(this.productLoanType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Loan Product is required.'));
            r = false;
        }
        
        if (String.isNotBlank(this.productLoanType) && String.isNotBlank(this.residency) ) {
            if('Gold Club - Non-Property'.equals(this.productLoanType)){
                if ('Property Owner'.equals(this.residency)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This product is for non-property owners only'));
                    r = false;   
                }
                
                if (this.opp.Application__c != null) {
                    if (!'Full Time'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This product is not suitable for casual employees'));
                        r = false;
                    }
                }
                
                if (this.opp.Application__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application is required.'));
                    r = false;
                }
                
                if ('Car'.equals(this.assetType) && 'Used'.equals(this.assetCondition) && !'0-3 years'.equals(this.carAge) && String.isNotBlank(this.carAge)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Only cars 0-3 years old qualify for this product'));
                    r = false;
                }				
            }
        }

        if(''.equals(this.carAge) || this.carAge == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age is required.'));
            r = false;
        }
        
        if (String.isBlank(this.casual)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Casual <12 months or Contract is required.'));
            r = false;
        }

        if (''.equals(this.bankrupt) || this.bankrupt == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Credit Impaired is required.'));
            r = false;
        } 

        if (String.isBlank(this.hasImports)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Imports is required.'));
            r = false;
        } 

        if (String.isBlank(this.odometer)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Odometer Reading is required.'));
            r = false;
        } 

        if (String.isBlank(this.privateSales)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Private Sales is required.'));
            r = false;
        }

        // validation before calculation
        if (this.carPrice == null || this.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Price cannot be Zero.'));
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
        
        if ('Within last six months'.equals(this.payDayEnquiries)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Pay Day Enquiries Within last six months is outside guidelines.'));
            r = false;
        } else {
            if (this.clientRate == null || this.clientRate == 0.0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
                r = false;
            } else {
                Decimal minRate = this.baseRate;
                Decimal maxRate = this.baseRate+2;
                
                if (this.clientRate < minRate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The minimun Client Rate should be ' + minRate + '%, please check your value and try again.'));
                    r = false;
                }
                if (this.clientRate > maxRate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximun Client Rate should be ' + maxRate + '%, please check your value and try again.'));
                    r = false;
                }
            }
        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        
        if (!isInsuranceValidationOK()) {
            r = false;   
        }

        //Lelo              2017-09-19
        if (this.residualValue > 0 && this.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }

        //Lelo              2019-07-10
        if (String.isBlank(this.assetType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an Asset Type.'));
            r = false;
        // } else if ('Leisure'.equals(this.assetType) && this.term > 60) {
        } else if (this.term > 60) {
            if ('Leisure'.equals(this.assetType)) {
                if (!'Property Owner'.equals(this.residency)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Only Property Owners are allowed for more than 5 years terms'));
                    r = false;
                }
            } 
        }
        
        if ('Bikes / Scooters'.equals(assetType) && term > 60) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: Max term on bikes is 5 years'));
        }

        return r;
    }
    
    public void calculate () {
      if (isValidationOk()) {
        this.calculateRepayments();        
      }
      if (this.estimatedCommission <= 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
      }
    }
    
    public void reset() {
      this.resetQuote();
        
      this.loanType = 'Purchase';
      this.productLoanType = '';
      this.assetType = this.getAssetTypeFromApplication();
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = lenderSettings.PPSR__c;
      this.applicationFee = lenderSettings.Application_Fee__c;
      this.dof = lenderSettings.DOF__c;
      this.registrationFee = lenderSettings.Registration_Fee__c;
      this.baseRate = 0.0;        
      this.term = 60;
      this.paymentType = 'Arrears';
      this.privateSales = 'N';       
      this.odometer = null;
      this.casual = null;
      this.resetInsuranceProducts(false);
      this.skipIntegrityPayType = true;
      fullRates = ASFRates__c.getAll().values();
      fullRates.sort();
      rates = new Map<String, List<AfsRate>>();
  
      fullRatesV2 = AFSRateV2__c.getAll().values();
      fullRatesV2.sort();
      
      List<AfsRate> r1 = new List<AfsRate>();
      List<AfsRate> r2 = new List<AfsRate>();
      List<AfsRate> r3 = new List<AfsRate>();
      List<AfsRate> r4 = new List<AfsRate>();
      List<AfsRate> r5 = new List<AfsRate>();
      List<AfsRate> r6 = new List<AfsRate>();

      for (ASFRates__c a : fullRates) {
        if (a.Gold_Club_Rate__c != null && a.Gold_Club_Comm__c != null) {
          r1.add(new AfsRate(a.Gold_Club_Rate__c, a.Gold_Club_Comm__c));
        }
        if (a.Drive_More_Plus_Rate__c != null && a.Drive_More_Plus_Comm__c != null) {
          r2.add(new AfsRate(a.Drive_More_Plus_Rate__c, a.Drive_More_Plus_Comm__c));
        }
        if (a.Drive_More_Rate__c != null && a.Drive_More_Comm__c != null) {
          r3.add(new AfsRate(a.Drive_More_Rate__c, a.Drive_More_Comm__c));
        }
        if (a.Autoline_Plus_Rate__c != null && a.Autoline_Plus_Comm__c != null) {
          r4.add(new AfsRate(a.Autoline_Plus_Rate__c, a.Autoline_Plus_Comm__c));
        }
        if (a.Autoline_Rate__c != null && a.Autoline_Comm__c != null) {
          r5.add(new AfsRate(a.Autoline_Rate__c, a.Autoline_Comm__c));
        }
        if (a.Autoline_Credit_Impaired_Rate__c != null && a.Autoline_Credit_Impaired_Comm__c != null) {
          r6.add(new AfsRate(a.Autoline_Credit_Impaired_Rate__c, a.Autoline_Credit_Impaired_Comm__c));
        }
      }

      rates.put('Gold Club', r1);
      rates.put('Drive More Plus', r2);
      rates.put('Drive More', r3);
      rates.put('Autoline Plus', r4);
      rates.put('Autoline', r5);
      rates.put('Autoline (Credit Impaired)', r6);

      this.resetCalculationResult(); //Lelo       2017-07-25
      this.loadOdometerValue();
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
        calcPdf.getParameters().put('lender', 'AFS CONSUMER CALCULATION');
        
        //pass variables about the product info
        calcPdf.getParameters().put('registrationFee', String.valueof(this.registrationFee));
        calcPdf.getParameters().put('bankrupt', this.bankrupt);
        calcPdf.getParameters().put('residency', this.residency);
        calcPdf.getParameters().put('carAge', this.carAge);
        calcPdf.getParameters().put('defaults', this.hasDefaults);
        calcPdf.getParameters().put('goodsType', this.assetType);
        if (this.lvr != null) {
            calcPdf.getParameters().put('lvr', String.valueOf(this.lvr));
        }
        calcPdf.getParameters().put('payDayEnquiries', this.payDayEnquiries);
        calcPdf.getParameters().put('hasImports', this.hasImports);
        calcPdf.getParameters().put('vehicleCondition', this.assetCondition);
        calcPdf.getParameters().put('vehiclesProfile', this.odometer);
        calcPdf.getParameters().put('privateSales', this.privateSales);
        calcPdf.getParameters().put('customerProfile', this.casual);
        
        savePdfInCloud(calcPdf, prefixName);
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk() || !isValidAssetDetails()) {
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
        updateProduct.Lender__c = 'AFS';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = this.loanType;
        updateProduct.Loan_Product__c = this.productLoanType;
        updateProduct.Loan_Type_Detail__c = this.assetType + ' [' + this.assetCondition + ' / ' + this.carAge + ']';
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
                // this.clientTier = d.Client_Tier__c;
                // this.riskGrade = d.Risk_Grade__c;
                this.bankrupt = d.Bankrupt__c;
                this.carAge = d.Vehicle_Age__c;
                this.residency = d.Residency__c;
                this.hasDefaults = d.HasDefaults__c;
                this.monthlyFee = d.Monthly_Fee__c;
                this.assetCondition = d.Vehicle_Condition__c;
                this.payDayEnquiries = d.Pay_Day_Enquiries__c;
                this.hasImports = d.Has_Imports__c;
                if (String.isNotBlank(d.LTV__c)) {
                    this.lvr = Integer.valueOf(d.LTV__c);
                }
                this.odometer = d.Vehicles_Profile__c;
                this.registrationFee = d.Registration_Fee__c;
                                
                
                if (String.isNotBlank(d.Goods_type__c)) {
                    this.assetType = d.Goods_type__c;
                }

                if (String.isNotBlank(d.Private_Sales__c)) {
                  this.privateSales = d.Private_Sales__c;
                }
            }
        }
        this.baseRateCalc();
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

      Application_Quoting__c d = new Application_Quoting__c();
      if (this.quoting != null) {
        this.updateQuotingData();
        d = this.quoting; 
      }
      
      //Loan Details
      d.Registration_Fee__c = this.registrationFee;
      d.Bankrupt__c = this.bankrupt;
      d.HasDefaults__c = this.hasDefaults;
      d.Vehicle_Age__c = this.carAge;
      d.Residency__c = this.residency;
      d.Payment__c = this.paymentType;
      d.Goods_type__c = this.assetType;
      d.Vehicle_Condition__c = this.assetCondition;
      d.Pay_Day_Enquiries__c = this.payDayEnquiries;
      d.Has_Imports__c = this.hasImports;
      d.LTV__c = '';
      if (this.lvr != null) {
          d.LTV__c = String.valueOf(this.lvr);
      }
      d.Vehicles_Profile__c = this.odometer;
      d.Private_Sales__c = this.privateSales;
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
        //Quote
        //this.baseRate = this.clientRate;
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        String quotingType = QuotingCalculation.CALC_QUOTING;
        param.totalAmount = this.getTotalAmount(quotingType);
        param.totalInsurance = this.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(quotingType);
        param.baseRate = this.baseRate;
        param.clientRate = this.clientRate;
        param.paymentType = this.paymentType;
        param.term = this.term;
        param.dof = this.dof;
        param.monthlyFee = this.monthlyFee;
        param.residualValue = this.residualValue;
        
        param.residency = this.residency;
        param.condition = this.assetCondition;
        param.vehicleYear = this.carAge;
        param.vehiclePrice = this.getVehiclePrice();
        param.assetType = this.assetType;
        param.productLoanType = this.productLoanType;

        param.commRate = QuotingCalculation.getAFSRateCommission(param);
        // AFSRateV2__c rate = QuotingCalculation.getAFSConsumerRate(param);
        // if (rate != null) {
        //     param.commRate = rate.Comm__c;
        // } else if('Gold Club - Non-Property'.equals(this.productLoanType)){
        //     param.commRate = 5.00;
        // } else {
        //     param.commRate = 0.00;
        // }
        
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
        //-

    }

    public void baseRateCalc() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.assetType = this.assetType;
        param.residency = this.residency;
        param.condition = this.assetCondition;
        param.vehicleYear = this.carAge;
        if (this.lvr != null) {
            param.ltv = String.valueOf(this.lvr);
        }
        param.bankrupt = this.bankrupt;
        param.riskGrade = this.payDayEnquiries;
        param.hasImports = this.hasImports;
        param.vehiclePrice = this.getVehiclePrice();
        param.vehiclesProfile = this.odometer;
        param.term = this.term;
        param.privateSales = this.privateSales;
        param.customerProfile = this.casual;
        param.assetType = this.assetType;
        param.productLoanType = this.productLoanType;
        this.baseRate = QuotingCalculation.getBaseRate(param);
        if('Gold Club - Non-Property'.equals(this.productLoanType)){
            this.clientRate = this.baseRate;
        }
    }
    
    public String getAssetTypeFromApplication() {
        if (this.Opp.Application__r.Type_of_Asset__c != null) {
            if ('Car'.equals(this.Opp.Application__r.Type_of_Asset__c)) {
                return 'Car';
            } else if ('Bike'.equals(this.Opp.Application__r.Type_of_Asset__c) ||
                       'Caravan'.equals(this.Opp.Application__r.Type_of_Asset__c) ||
                       'JetSki'.equals(this.Opp.Application__r.Type_of_Asset__c) ||
                       'Boat'.equals(this.Opp.Application__r.Type_of_Asset__c)) {
                return 'Leisure';
            }
        }
        return null;
    }

    public void resetCarAge() {
        this.carAge = '';
        if ('New/Demo'.equals(this.assetCondition)) {
            this.carAge = 'N/A';
        }
        this.baseRateCalc();
    }

    public void loadOdometerValue() {
        if (String.isBlank(this.odometer)) {
            if (this.opp.Application_AssetDetail__c != null && this.opp.Application_AssetDetail__r.Actual_KM__c != null) {
                this.odometer = '<200,000';
                if (this.opp.Application_AssetDetail__r.Actual_KM__c > 200000.0) {
                    this.odometer = '>200,000';
                }
            }
        }
        if (String.isBlank(this.casual)) {
            if (this.opp.Application__c != null && String.isNotBlank(this.opp.Application__r.Mode_of_Employment_1__c)) {
                if ('Contract'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                    this.casual = 'Y';
                } else if ('Full Time'.equals(this.opp.Application__r.Mode_of_Employment_1__c) || 'Part Time'.equals(this.opp.Application__r.Mode_of_Employment_1__c)  || 'Self Employed'.equals(this.opp.Application__r.Mode_of_Employment_1__c)) {
                    this.casual = 'N';
                }
            }
        }
    }

    public List<SelectOption> getOdometerOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        r.add(new SelectOption('<200,000','<200,000'));
        r.add(new SelectOption('>200,000','>200,000'));
        return r;
    }

    public List<SelectOption> getAssetAgeOptions() {
        List<SelectOption> r = new List<SelectOption>();
        List<String> opts = new List<String>() ;
        r.add(new SelectOption('','--None--'));
        if ('New/Demo'.equals(this.assetCondition)) {
            opts.add('N/A');
        } else {
          if ('Property Owner'.equals(this.residency)) {
            opts.add('0-3 years');
            opts.add('4-5 years');
            opts.add('6-10 years');
            opts.add('11+ years');
            if ('Car'.equals(this.assetType)) {
              opts.add('Classic');
            }
          } else if ('Renting'.equals(this.residency)) {
            opts.add('0-5 years');
            opts.add('6-10 years');
            opts.add('11-20 years');
            opts.add('21+ years');
          } else {
            opts.add('0-3 years');
            opts.add('4-7 years');
            opts.add('8-10 years');
            opts.add('11-20 years');
            opts.add('21+ years');
          }
        }
        for (String opt: opts) {
            r.add(new SelectOption(opt, opt));
        }
        return r;
    }

    public List<SelectOption> getLoanProductOptions() {
        List<SelectOption> r = new List<SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('Consumer Loan', 'Consumer Loan'));
        r.add(new SelectOption ('Gold Club - Non-Property', 'Gold Club - Non-Property'));
        r.add(new SelectOption ('Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Full-Doc'));
        r.add(new SelectOption ('Chattel Mortgage-Low-Doc', 'Chattel Mortgage-Low-Doc'));
        return r;
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

    public boolean isValidAssetDetails(){
        Boolean r = true;
        // LTV
        if ('Car'.equals(this.assetType)) {
          System.debug('Validating LVR...');
          Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Id);
          if(aad != null && aad.LVR__c != null) {
            System.debug('checking lvr in Asset Details ... ' + aad.LVR__c + '|' + this.lvr);
            if (this.lvr != aad.LVR__c.intValue()) {
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.WARNING,'LVR does not match with Asset Details (' + aad.LVR__c.intValue() + '%)'));
                //r = false;
            }
          }
        }
        return r;
    }
  
  public List<AFSRateV2__c>  getFullRatesPropertyOwners(){
    return getFullRates('Property Owner');
  }

  public List<AFSRateV2__c>  getFullRatesRenting(){
    return getFullRates('Non-Property Owner - Renter');
  }

  public List<AFSRateV2__c>  getFullRatesOthers(){
    return getFullRates('Non-Property Owner - Other');
  }

  private List<AFSRateV2__c> getFullRates(String plan) {
    List<AFSRateV2__c> r = new List<AFSRateV2__c>();
    if (String.isNotBlank(this.assetType)) {
      r = [select t.Name,Asset_Type__c,t.Comm__c,t.Plan__c,t.Base_Rate__c, t.Rate__c,t.Risk_Grade__c,Condition__c
          from AFSRateV2__c t Where t.Plan__c = :plan And Asset_Type__c= :this.assetType order by Asset_Type__c, t.Name];
    }
    return r;
  }

  public Decimal getVehiclePrice() {
    Decimal r = 0.0;
    r += (this.carPrice != null)? this.carPrice : 0;
    r -= getNetDepositVal();
    return r;
  }

  public override Decimal getTotalAmount(String calcType) {
    Decimal r = super.getTotalAmount(calcType);
    r += (this.registrationFee != null)? this.registrationFee : 0;
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