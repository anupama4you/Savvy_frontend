public class LatitudeCalculatorExtension extends QuotingExtension {
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'Latitude';
    public QuotingToolHelper qh {set;get;}
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'Latitude';
    public Boolean submitRequest {set; get;}
    public String applicationIDLatitude {set; get;}
    public String dateLatitude {set; get;}
    public String apiUser {get;set;}
    public List <SelectOption> usersAPIOptions {get;set;}
    
    // Lender variables
    public String loanTypeDetail {set;get;}     //Risk Grade for Personal Loan
    public Integer carAge {get;set;}
    public String category {get;set;}
    public String vehicleType {get;set;}
    public String vehCon {get;set;}
    public Decimal registrationFee {get;set;}
    
    public LatitudeCalculatorExtension(ApexPages.StandardController controller) {
     super(controller);
      
      usersAPIOptions = getusersAPIOptions();
      application();        
      qh = new QuotingToolHelper();
      
      this.quotingName = LENDER_QUOTING;
      this.reset();
      
      preLoadQuotingValues();	  
      
      //NWC Calculator - HJ - 12-07-2018 - I
      loadNWCParameters();
      //NWC Calculator - HJ - 12-07-2018 - F
      //LatitudeAPIService l = new LatitudeAPIService();
      //LatitudeAPIRequestDTO.Preapproval app = l.getLatitudePreApproval(Opp, 'AU900266');
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
                if (lender != null && lender.info != null && 'LATI'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.loanTypeDetail = lender.productLoanType;
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;
                    //
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
        if (String.isBlank(this.vehCon)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Vehicle Condition.'));
            r = false;
        }
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
        } else if (this.dof > this.maxDof) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max DOF exceeded'));
        }
        if (this.ppsr == null || this.ppsr == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
            r = false;
        }
        //if (this.baseRate == null || this.baseRate == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
        //    r = false;
        //}
        if (this.clientRate == null || this.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else if (this.clientRate < this.baseRate || this.clientRate > this.maxRate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate should be between ' + this.baseRate + '% and ' + this.maxRate + '%'));
            r = false;
        }
        if (this.term == null || this.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else {
          Decimal ageTerm = this.term / 12 + this.carAge;
          if ('Y'.equals(this.privateSales)) {
            if (ageTerm > 20) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The max age of vehicle at term end is 20 years. Current value: ' + ageTerm.setScale(0)));
              r = false;
            }
          }
          if ('MOTORBIKE'.equals(this.vehicleType)) {
            if (this.term > 60) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motorbikes max. term is 5 years.'));
              r = false;
            }
            if (ageTerm > 12) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motorbikes no older than 12 years at term end. Current value: ' + ageTerm.setScale(0)));
              r = false;
            }
          }
        }
        if ('Y'.equals(this.privateSales)) {
          if ('MOTORBIKE'.equals(this.vehicleType) ||
             (this.Opp.Application_AssetDetail__c != null && 'Motorcycle'.equals(this.Opp.Application_AssetDetail__r.Type__c)) ||
             (this.Opp.Application__c != null && 'Bike'.equals(this.Opp.Application__r.Type_of_Asset__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Latitude do not do private sale motorbikes.')) ;
            r = false;
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
        
        if (String.isBlank(this.vehicleType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Vehicle Type.'));
            r = false;
        }
        
        return r;
    }
    
    public void calculate () {
      this.baseRateCacl();
      if (isValidationOk()) {
        this.calculateRepayments();
      }
    }
    
    public void dofCalculate() {
      this.maxDof = this.getDofCalculated(null);
      this.dof = this.maxDof;
    }
    
    public void reset() {
      this.resetQuote();  
      this.loadRates();
      
      this.productLoanType = 'Consumer Loan';
      //Initial values
      this.loanTypeDetail = 'Diamond Plus';
      this.category = null;
      this.vehicleType = null;
      this.carAge = 0;
      this.vehCon = '';
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = lenderSettings.PPSR__c;
      this.applicationFee = lenderSettings.Application_Fee__c;
      this.registrationFee = lenderSettings.Registration_Fee__c;
      this.baseRate = 0.0;
      this.maxRate = 0.0;
      this.clientRate = 0.0;
      this.term = 60;
      this.paymentType = 'Arrears';
      this.privateSales = 'N';
      this.resetInsuranceProducts(false);
      //latitude accept integrity
      //https://savvy-league.monday.com/boards/164662384/pulses/2320065637
      this.skipIntegrityPayType = true;
      //-
      this.baseRateCacl();
      this.resetCalculationResult(); //Lelo       2017-07-25
    }
    
    private PageReference savePdf (String prefixName) {
      // pass parameters to the PDF page
      PageReference calcPdf = this.createPdf();
      
      // Lender parameter
      calcPdf.getParameters().put('registrationFee', String.valueOf(this.registrationFee));
      calcPdf.getParameters().put('loanTypeDetail', this.loanTypeDetail);
      if (this.carAge != null) {
          calcPdf.getParameters().put('carAge', String.valueOf(this.carAge));
      }
      calcPdf.getParameters().put('vehCon', this.vehCon);
      calcPdf.getParameters().put('privateSales', String.valueOf(this.privateSales));
      calcPdf.getParameters().put('goodsType', this.vehicleType);
      calcPdf.getParameters().put('vehiclesProfile', this.category);

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
      updateProduct.Lender__c = 'Latitude';
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
              if (String.isNotBlank(d.Goods_type__c)) {
                  this.vehicleType = d.Goods_type__c;
              }
              if (d.Base_Rate__c != null) {
                  this.baseRate = d.Base_Rate__c;
              }
              
              //Loan Details
              this.paymentType = d.Payment__c;
              this.loanTypeDetail = d.Loan_Facility_Type__c;
              if (String.isNotBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()) {
                  this.carAge = Integer.valueOf(d.Vehicle_Age__c);
              }
              this.vehCon = d.Vehicle_Condition__c;
              this.registrationFee = d.Registration_Fee__c;
              
              if (String.isNotBlank(d.Private_Sales__c)) {
                  this.privateSales = d.Private_Sales__c;
              }
            }
        }
        if (sameQuoting) {
            try {
                this.baseRateCacl();
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
      d.Loan_Facility_Type__c = this.loanTypeDetail;
      d.Registration_Fee__c = this.registrationFee;
      d.Goods_type__c = this.vehicleType;
      //Loan Details
      if (this.carAge != null) {
          d.Vehicle_Age__c = String.valueOf(this.carAge);
      } else {
          d.Vehicle_Age__c = null;
      }
      d.Vehicle_Condition__c = this.vehCon;
      d.Private_Sales__c = this.privateSales;
      d.Payment__c = this.paymentType;
      
      //Save the record
      QuotingToolHelper.saveApplicationQuoting(d);
      
      //Save calculations
      QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
        
    }
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }
    
    //-  Insurance  
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
        param.carAge = this.carAge;
        param.loanTypeDetail = this.loanTypeDetail;
        param.goodsType = this.category;
        param.commRate = QuotingCalculation.getLatitudeRateCommission(param);
        
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.commRate);
        
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
        param.dof = this.getDofCalculated(quotingType);
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
        
        //}
        //-
    }
    
    private Map<String, Map<String, Map<String, List<LatitudeRatesv3__c>>>> rates3List = null;
    
    private void loadRates() {
        this.rates3List = new Map<String, Map<String, Map<String, List<LatitudeRatesv3__c>>>>();
        // List<LatitudeRatesv3__c> d = [
        //     SELECT Category__c, Class__c, Asset_Age__c, Rate__c, Comm__c 
        //     FROM LatitudeRatesv3__c ORDER BY Name
        // ];
        List<LatitudeRatesv3__c> d = LatitudeRatesv3__c.getAll().values();
        d.sort();
        for (LatitudeRatesv3__c a : d) {
            Map<String, Map<String, List<LatitudeRatesv3__c>>> cat = this.rates3List.get(a.Category__c);
            if (cat == null) {
                cat = new Map<String, Map<String, List<LatitudeRatesv3__c>>>();
                this.rates3List.put(a.Category__c, cat);
            }
            Map<String, List<LatitudeRatesv3__c>> p = cat.get(a.Class__c);
            if (p == null) {
                p = new Map<String, List<LatitudeRatesv3__c>>();
                cat.put(a.Class__c, p);
            }
            List<LatitudeRatesv3__c> lst = p.get(a.Asset_Age__c);
            if (lst == null) {
                lst = new List<LatitudeRatesv3__c>();
                p.put(a.Asset_Age__c, lst);
            }
            lst.add(a);            
        }
    }
    
    public class TRow {
        public Decimal rate1 {set;get;}
        public Decimal comm1 {set;get;}
        public Decimal rate2 {set;get;}
        public Decimal comm2 {set;get;}
        public Decimal rate3 {set;get;}
        public Decimal comm3 {set;get;}
        public Decimal rate4 {set;get;}
        public Decimal comm4 {set;get;}
    }
    
    public List<TRow> getDiamondPlusRates() {
        return getReportRates(this.category, 'Diamond Plus');
    }
    
    public List<TRow> getDiamondRates() {
        return getReportRates(this.category, 'Diamond');
    }
    
    public List<TRow> getSapphireRates() {
        return getReportRates(this.category, 'Sapphire');
    }
    
    public List<TRow> getRubyRates() {
        return getReportRates(this.category, 'Ruby');
    }
    
    public List<TRow> getEmeraldRates() {
        return getReportRates(this.category, 'Emerald');
    }
    
    private List<TRow> getReportRates(String category, String prodName) {
        List<TRow> r = new List<TRow>();
        Map<String, Map<String, List<LatitudeRatesv3__c>>> cat = this.rates3List.get(category);
        if (cat != null) {
            Map<String, List<LatitudeRatesv3__c>> p = cat.get(prodName);
            if (p != null) {
                List<String> keys = new List<String>(p.keySet());
                Integer max = p.get(keys.get(0)).size();
                Integer k = 0;
                for (Integer i = 0;i<max;i++) {
                    TRow x = new TRow();
                    x.rate1 = p.get(keys.get(0)).get(i).Rate__c;
                    x.rate2 = p.get(keys.get(1)).get(i).Rate__c;
                    x.rate3 = p.get(keys.get(2)).get(i).Rate__c;
                    
                    x.comm1 = p.get(keys.get(0)).get(i).Comm__c;
                    x.comm2 = p.get(keys.get(1)).get(i).Comm__c;
                    x.comm3 = p.get(keys.get(2)).get(i).Comm__c;
                    if (keys.size() == 4) {
                        x.rate4 = p.get(keys.get(3)).get(i).Rate__c;
                        x.comm4 = p.get(keys.get(3)).get(i).Comm__c;
                        
                    }
                    r.add(x);
                }
            }
        }
        return r;
    }
    //-
    
    public void baseRateCacl() {
        if(String.isNotBlank(this.vehicleType)){
            this.category = 'Car/Motorbike';
            if('BOAT'.equals(this.vehicleType) || 'CARAVAN'.equals(this.vehicleType) || 'MOTORHOME'.equals(this.vehicleType) || 'TRAILER'.equals(this.vehicleType)){
                this.category = 'Boats, Personal Watercraft, Caravans, Camper Trailers, Motorhomes';
            }
        }
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.goodsType = this.category;
        param.loanTypeDetail = this.loanTypeDetail;
        param.carAge = this.carAge;
        this.baseRate = QuotingCalculation.getBaseRate(param);
        this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
    }
    
    public void sendApplication(){
        
        if(submitRequest){
            LatitudeAPIService l = new LatitudeAPIService();
            try {
              l.requestApplication(Opp, apiUser);
              application();
            } catch (GenericException e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
        }else{
            isValidationOk();
            if (this.rental == null || this.rental == 0) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            }
            if (!String.isNotBlank(apiUser)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Latitude API user'));
            }
        }		
    }
    
    public List<SelectOption> getVehicleTypes(){
        
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        r.add(new SelectOption ('CAR', 'Car'));
        r.add(new SelectOption ('VAN_LIGHT_COMMERCIAL', 'Car (Van Light Commercial)'));
        r.add(new SelectOption ('MINIBUS', 'Car (Minibus)'));
        r.add(new SelectOption ('UTILITY', 'Car (Utility)'));
        r.add(new SelectOption ('STATION_WAGON_OR_4WD', 'Car (Station Wagon or 4WD)'));
        r.add(new SelectOption ('MOTORBIKE', 'Motorbike'));
        r.add(new SelectOption ('BOAT', 'Boats (or Personal Watercraft)'));
        r.add(new SelectOption ('CARAVAN', 'Caravan'));
        r.add(new SelectOption ('MOTORHOME', 'Motorhome'));
        r.add(new SelectOption ('TRAILER', 'Camper Trailer'));
        
        return r;
    }
    
    public void save(){
        
        submitRequest = false;
        if(isValidationOk()){
            calculate();
            // validate calculation
            if (this.rental > 0) {
                // saveQuotingParameters();
                saveProduct(fileGlobalPrefix);
                submitRequest = true;
            }
        }
    }
    
    public void application(){
        LenderAPIResponse__c l;
        
        List<LenderAPIResponse__c> r = [SELECT Application_ID__c, CreatedDate FROM LenderAPIResponse__c WHERE Opportunity__c =: Opp.Id AND Application_ID__c != null AND Provider__c = 'Latitude' ORDER BY CreatedDate DESC];
        
        if(!r.isEmpty()){
            l = r.get(0);
            applicationIDLatitude = l.Application_ID__c;
            dateLatitude = l.CreatedDate.format('dd/MM/yyyy HH:mm:ss a');
        }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    
    public List<SelectOption> getusersAPIOptions(){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        
        List<Lender_Login__c> listL = APIServiceManager.listLenderLogins('Latitude (E Motor)');
        
        List<Custom_Opportunity__c> listO = [select Owner.Name From Custom_Opportunity__c where Id =: Opp.Id];
        
        Custom_Opportunity__c o;
        
        for (Custom_Opportunity__c opportunity: listO){
            o = opportunity;
        }
        
        for (Lender_Login__c l: listL){
            
            if(l.Owner.Name.equals(o.Owner.Name)){
                apiUser = l.User_Name__c;
            }
            
            r.add(new SelectOption (l.User_Name__c, l.Owner.Name));
        }
        return r;
    }
  
  public Decimal getDofCalculated(String calcType) {
    Decimal r = 0;
    if (carPrice != null)
        r += carPrice;
    if (applicationFee != null)
        r += applicationFee;
    
    if (ppsr != null)
        r += ppsr;
    
    r -= getNetDepositVal();
    
    r += this.getTotalInsuranceType(calcType);
    
    if (registrationFee != null)
        r += registrationFee;
    
    if (r > 20000) {
      r = 1650.00;
    } else if (r > 0) {
      r = r * 0.15;
      if (r >= 990) {
          r = 990.0;
      }
    } else {
      r = 0;
    }
    return r.setScale(2);
  }

  public static List <SelectOption> getSelectLoanTypeOptions() {
      List <SelectOption> r = new List <SelectOption> ();
      r.add(new SelectOption ('Diamond Plus', 'Diamond Plus'));
      r.add(new SelectOption ('Diamond', 'Diamond'));
      r.add(new SelectOption ('Sapphire', 'Sapphire'));
      r.add(new SelectOption ('Ruby', 'Ruby'));
      r.add(new SelectOption ('Emerald', 'Emerald'));
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