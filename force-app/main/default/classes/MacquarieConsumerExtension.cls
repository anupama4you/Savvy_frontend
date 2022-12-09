public class MacquarieConsumerExtension extends QuotingExtension {

    private static final Integer VH_YEARS = 4;
	
    //Lelo					2016-07-26
    private String fileGlobalPrefix = 'Macquarie_Consumer';
    //-
    public static final String LENDER_QUOTING = 'Macquarie Consumer';
	    
    // Lender variables
    public Integer ltv {get;set;}
    public String motorCycles {get;set;}
    public String caravanCampervans {get;set;}
    public Decimal totalInsurance {set; get;}
    public String productGoodsType {get;set;}
    public String productGoodsSubType {get;set;}
    public String loanFrequency {set; get;}
    public String selectedTypeValue {set; get;}
    public Decimal residualValuePercentage {set; get;}
    public Boolean isResidualValuePercentage {set; get;}
    public Decimal brokeragePercentage {get;set;}
    public Boolean paramActive {set; get;}
    public String propertyOwner {get;set;}
    public String manufactureYear {get;set;}
    public List <SelectOption> manufactureYearOptions {get;set;}    
    public String rateType {set;get;}

    // rates references
    public List <MacquarieConsumerRates__c> macquarieRates {get;set;}
    Map <String,MacquarieConsumerRates__c> macquarieConsumerRates {get;set;}
    
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    public List <SelectOption> productGoodsSubTypes {get;set;}
    public List <Selectoption> loanFrequencies {set; get;}
    
    //Maclease Quote - API
    public MacquarieManager mcManager {set; get;}
    public MacLeasePartnerService mcService;
    public Boolean isCalculateUpdate {set; get;}
    public Decimal mcqGrossPayment {set; get;}
    public Decimal mcqCustomerRate {set; get;}
    public String mcqPaymentFrequency {set; get;}
    public String mcqMessageQuote {set; get;}
    public String mcqLastResponseQuote {set; get;}
    public String mcqApplicationId {set; get;}
    public String mcqMessageAppId {set; get;}
    public String mcqLastResponseApplication {set; get;}
    public String mcqUser {get;set;}
    public List <SelectOption> mcqUserOptions {get;set;}

    public MacquarieConsumerExtension (ApexPages.StandardController controller) {
      super(controller);
      String active = System.currentPageReference().getParameters().get('active');
      paramActive = !StringUtils.isNullOrEmpty(active);
      
      macquarieConsumerRates = MacquarieConsumerRates__c.getAll();
      System.debug('The map value: ' + macquarieConsumerRates);
      macquarieRates = macquarieConsumerRates.values();
      macquarieRates.sort();
      
      this.productLoanTypes = QuotingToolHelper.getLoanProductOptionsConsumer();
      
      this.quotingName = LENDER_QUOTING;
      this.reset();

      //-

      preLoadQuotingValues();
      
      //Macquarie - HJ -I
      mcqUserOptions = MacquarieManager.getUserOptionsConnect();
      //Macquarie - HJ -F
      //NWC Calculator - HJ - 12-07-2018 - I
      loadNWCParameters();
      //NWC Calculator - HJ - 12-07-2018 - F
    } // end of constructor
    
    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference().getParameters().get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [SELECT Pre_Quoting_Object__c FROM Custom_Opportunity__c WHERE ID = :this.Opp.Id];
            System.debug('Preloading values from comparison engine >> ' + oppList[0].Pre_Quoting_Object__c);
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO)JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c, LenderQuotingWrapperDTO.class);
                if (lender != null && lender.info != null && 'MCON'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productLoanType = lender.productLoanType;
                    this.productGoodsType = lender.productGoodsType;
                    changeGoodsType();
                    this.productGoodsSubType = lender.productGoodsSubType;
                    this.loanFrequency = lender.loanFrequency;
                    // this.assetYearOption();
                    this.manufactureYear = lender.vehicleYear;
                    //this.motorCycles = lender.motorCycles;
                    //this.caravanCampervans = lender.caravanCampervans;
                    this.privateSales = lender.privateSales;
                    this.propertyOwner = lender.customerProfile;
                    if (String.isNotBlank(lender.ltv) && lender.ltv.isNumeric()) {
                        this.ltv = Integer.valueOf(lender.ltv);
                    }

                    //Lelo                          2017-11-16
                    this.brokeragePercentage = lender.brokerageBase;
                    this.dof = lender.dofBase;
                    //
                    applicationFeefCalc();
                    baseRateCalc();
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }
    }

    public void baseRateCalc () {
        realtimeNafCalc();
        Decimal financeAmount = realtimeNaf;
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.ltv = String.valueOf(ltv);
        param.customerProfile = propertyOwner;
        param.term = term;
        param.privateSales = privateSales;
        param.totalAmount = financeAmount;
        param.goodsType = productGoodsType;
        // param.goodsSubType = productGoodsSubType;
        param.vehicleYear = manufactureYear;
        param.brokeragePer = brokeragePercentage;
        param.productLoanType = productLoanType;
        
        System.debug('ltv >> ' + param.ltv);
        System.debug('term >> ' + param.term);
        System.debug('privateSales >> ' + param.privateSales);
        System.debug('totalAmount >> ' + param.totalAmount);
        System.debug('goodsType >> ' + param.goodsType);
        System.debug('customerProfile >> ' + param.customerProfile);
        System.debug('vehicleYear >> ' + param.vehicleYear);
        System.debug('brokeragePer >> ' + param.brokeragePer);
        System.debug('productLoanType >> ' + param.productLoanType);
        baseRate = QuotingCalculation.getBaseRate(param);
        System.debug('BaseRateCalc >> ' + baseRate);
        
        param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.term = term;
        param.baseRate = baseRate;
        param.totalAmount = financeAmount;
        if (brokeragePercentage != null) {
            param.amountBasePmt = getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_QUOTING);
        }
        param.paymentType = paymentType;
        param.residualValue = this.residualValue;
        clientRate = QuotingCalculation.getClientRateCalculation(param);
        system.debug('clientRate (2)  >> ' + clientRate);
        
        this.totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
    } //end of funcion
    
    private Decimal calcBrokerage(Decimal targetRate, Decimal bkg, Decimal factor, Boolean stop) {
        Decimal b = bkg + factor;
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.term = this.term;
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(QuotingCalculation.CALC_QUOTING, b);
        param.baseRate = this.baseRate;
        param.paymentType = this.paymentType;
        param.residualValue = this.residualValue;
        param.totalAmount = this.realtimeNaf;
        Decimal cr = QuotingCalculation.getClientRateCalculation(param, 4);
        System.debug('calcBrokerage: ' + targetRate + ' | ' + bkg + ' | ' + factor + ' | ' + stop + ' | ' + b + ' | ' + cr);
        if (cr == 0.00) {
            return 0.00;
        } else if (cr == targetRate || stop) {
            return b;
        } else if (cr < targetRate) {
            return calcBrokerage(targetRate, b, factor, stop);
        } else if ((factor/10.0) < 0.01) {
            return calcBrokerage(targetRate, bkg-factor, factor, true);
        } else {
            return calcBrokerage(targetRate, bkg, factor/10.0, stop);
        }
    }

    public void estimateBrokerage() {
        if (this.baseRate != null) {
            this.brokeragePercentage = this.calcBrokerage(this.baseRate+2, 1, 1, false);
            System.debug('brokeragePercentage: ' + this.brokeragePercentage);
        }
        this.baseRateCalc();
    }

    public Decimal getBaseAmountPmtCalc(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        r += this.getTotalInsuranceType(calcType);
        if (netDeposit != null) r -= netDeposit;
        return r;
    }
    
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        //Decimal r = getRealtimeNaf(calcType);
        //if (brokeragePercentage != null && brokeragePercentage != 0) {
        //	   r += (getBaseAmountPmtCalc(calcType) * brokeragePercentage/100);
        //}
        return getBaseAmountPmtInclBrokerageCalc(calcType, this.brokeragePercentage);
    }

    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType, Decimal brkrage) {
        Decimal r = getRealtimeNaf(calcType);
        if (brkrage != null && brkrage != 0) {
               r += (getBaseAmountPmtCalc(calcType) * brkrage/100);
        }
        system.debug('getBaseAmountPmtInclBrokerageCalc***');
        system.debug(getRealtimeNaf(calcType));
        system.debug(brkrage);
        system.debug(getBaseAmountPmtCalc(calcType));
        system.debug(r);
        return r;
    }
    
    public override void realtimeNafCalc() {
      realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
      totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
      this.maxDof = ((this.dof != null)? (realtimeNaf - dof) : realtimeNaf) * 0.08;
    } //end of funcion
    
    //Lelo              2017-07-26
    public Decimal getRealtimeNaf(String calcType) {
      Decimal r = 0.0;
      netDepositCalc();
      if (carPrice != null) {
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            r += carPrice;
        }
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
            residualValue = ((carPrice - netDeposit) * residualValuePercentage) / 100;
        }
      }
      r += (this.applicationFee != null)? this.applicationFee : 0;
      r += (this.dof != null)? this.dof : 0;
      r += (this.ppsr != null)? this.ppsr : 0;
      r -= this.netDeposit;
      r += this.getTotalInsuranceType(calcType);
      return r;
    }


    public void applicationFeefCalc () {
      applicationFee = lenderSettings.Application_Fee__c;
      realtimeNafCalc();
    } 

    public void validation () {
        if (paymentType == 'Advance') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You have chosen advance payment method for a consumer loan.'));
        }
    } //end of funcion
    
    public void clientRateValidate () {
        isValidCalculate();
    } //end of function
    
    public Boolean isValidCalculate () {
        Boolean r = true;
        if (String.isBlank(this.manufactureYear)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an Asset Year.'));
            r = false;
        }
        if (baseRate == null || baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate should not be Zero.'));
            r = false;
        }
        if (dof > maxDof.setScale(2)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Max DOF is 8% of NAF.'));            
        }

        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        
        if (brokeragePercentage > 8) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Maximum Brokerage is 8.00%'));
            r = false;
        }
        if ('MOTOV'.equals(this.productGoodsType) && 'MOTOV_CARS_-_OTHER_CARS_AU'.equals(productGoodsSubType)) {
            if (this.opp.Application_AssetDetail__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please save a Asset Detail - LTV before quoting.'));
                //r = false;
            }
        }

        //Ltv
        if (this.ltv != null && this.ltv > 130) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LTV should be max. 130%'));
            r = false;
        }

        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //System.debug('Validating residual >> ' + productLoanType + '|' + residualValue);
        //Lelo              2017-04-04
        if ('Consumer Loan'.equals(productLoanType) && residualValue != null && residualValue > 0) {
            Integer assetAge = 0;
            if (String.isNotBlank(manufactureYear) && manufactureYear.isNumeric()) {
                assetAge = Date.today().year() - Integer.valueOf(manufactureYear);
            }
            Decimal a = (term / 12) + assetAge;
            //System.debug('Residual validation >> ' + a);
            if (a > 8) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Balloons at the discretion of Macquarie.'));
                // r = false;
            }
        }
        //-
        //Lelo              2018-06-13
        if ('LIFES'.equals(productGoodsType) && 'Y'.equals(privateSales) && 'LIFES_MOTORCYCLES_&_SCOOTERS_AU'.equals(productGoodsSubType)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No private sales on Motorcycles & Scooters.'));
            r = false;
        }
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Balloons at the discretion of Macquarie.'));
            // r = false;
        }

        return r;
    } //end of function
    
    public void calculate () {
      System.debug('Calculating...');
      baseRateCalc();
      System.debug('Validating...');
      if (isValidCalculate()) {
        System.debug('Calculating Repayments...');
        this.calculateRepayments(); 
        
        isCalculateUpdate = true;
      }
    } // end of function
    
    public void reset() {
      this.resetQuote();
        this.loanType = this.loanTypeOptions.get(0).getValue();
        this.productLoanType = this.productLoanTypes.get(0).getValue();
        this.productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
        this.productGoodsType = 'MOTOV';
        this.carPrice = null;
        this.deposit = null;
        this.tradeIn = null;
        this.payoutOn = null;
        netDepositCalc();
        //this.applicationFee = 395.00;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.residualValue = null;
        this.residualValuePercentage = 0;
        this.selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.maxDof = 0.0;
        this.ltv = null;
        this.term = 60;
        this.brokeragePercentage = 0;
        // this.manufactureYear = String.valueOf(Date.today().year());
        this.assetYearOption();
        this.motorCycles = 'N';
        this.caravanCampervans = 'N';
        this.paymentType = 'Arrears';
        this.productGoodsSubType = '';
        this.loanFrequency = '';
        resetResidualValues();
        loadLoanFrequency();
        selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        mcService = new MacLeasePartnerService();
        mcManager = new MacquarieManager();


        this.resetInsuranceProducts(false);

        this.changeGoodsType();
        this.applicationFeefCalc();
        this.realtimeNafCalc();
        isCalculateUpdate = false;

        this.resetCalculationResult(); //Lelo       2017-07-25

    } // end of function
    
    private PageReference savePdf (String prefixName) {
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'MACQUARIE CONSUMER CALCULATION');

        // Lender parameters
        calcPdf.getParameters().put('selectedTypeValue', selectedTypeValue);
        calcPdf.getParameters().put('residualValuePercentage', String.valueOf(residualValuePercentage));
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(brokeragePercentage));
        calcPdf.getParameters().put('privateSales', privateSales);
        calcPdf.getParameters().put('ltv', '0');
        if (ltv != null) {
            calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        }
        calcPdf.getParameters().put('customerProfile', propertyOwner);
        calcPdf.getParameters().put('carAge', manufactureYear);
        // pass variables about the product info
        
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('productGoodsSubType', productGoodsSubType);
        calcPdf.getParameters().put('loanFrequency', loanFrequency);
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        savePdfInCloud(calcPdf, prefixName);
        return null;
    } // end of function
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidCalculate()) {
            return null;
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
        
        //Lelo          Insurance           2018-02-20
        //Storing quoting data
        saveQuotingParameters();
        //-
        if(!isValidAssetDetails() && !Test.isRunningTest()) {
            return null;
        }
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
            updateProduct = [Select id,Loan_Purpose__c,Quoting_Source__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,
                             Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //- 
            
        updateProduct.Loan_Purpose__c = 'Personal Use';
        updateProduct.Lender__c = 'Macquarie Leasing';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        
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
        
        //Lelo                      2018-02-20
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
        // if (InsuranceQuoteUtils.isFormalApprovalValidated(this.quoting, this.quote)) {
        //     if (insuranceProductSelected()) {
                this.quoting.Force_Calculation__c = false;
                return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');    
        //     }
        // }
        // return null;
    }
    
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
            loanType = d.Loan_Type__c;
            productLoanType = d.Loan_Product__c;
            carPrice = d.Vehicle_Price__c;
            deposit = d.Deposit__c;
            tradeIn = d.Trade_In__c;
            payoutOn = d.Payout_On__c;
            netDepositCalc();
            residualValue = d.Residual_Value__c;
            term = (d.Term__c != null)? Integer.valueOf(d.Term__c) : term;
            
            if (sameQuoting) {
              this.loadQuotingInsuranceData();
              this.loadQuotingData();
              productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
              productGoodsType = d.Goods_type__c;
              productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(productLoanType, productGoodsType);
              productGoodsSubType = d.Goods_sub_type__c;  
              residualValuePercentage = d.Residual_Value_Percentage__c;
              if (d.Residual_Value_Percentage__c != null && d.Residual_Value_Percentage__c != 0){
                selectedTypeValue = MacquarieConstants.TYPE_PERCENTAGE;
              }else{
                selectedTypeValue = MacquarieConstants.TYPE_VALUE;
              }
              if (String.isNotBlank(productLoanType)) {
                  loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
              }
              loanFrequency = d.Loan_Frequency__c;
              
              brokeragePercentage = d.Brokerage__c;
              privateSales = d.Private_Sales__c;
              paymentType = d.Payment__c;

              if (String.isNotBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()) {
                  manufactureYear = d.Vehicle_Age__c;
              }
              propertyOwner = d.Customer_Profile__c;
              rateType = d.Rate_Type__c;
              if (String.isNotBlank(d.LTV__c)) {
                  ltv = Integer.valueOf(d.LTV__c);
              }

              //Calculations
              applicationFeefCalc();
              baseRateCalc();
                //-
            }
            realtimeNafCalc();
            mcqGrossPayment = d.Mcq_Gross_Payment__c;
            mcqCustomerRate = d.Mcq_Customer_Rate__c;
            mcqPaymentFrequency = d.Mcq_Payment_Frequency__c;
            mcqMessageQuote = d.Mcq_Message_Quote__c;
            mcqLastResponseQuote = d.Mcq_Last_Response_Quote__c;
            mcqApplicationId = d.Mcq_Application_Id__c;
            mcqMessageAppId = d.Mcq_Message_Application_Id__c;
            mcqLastResponseApplication = d.Mcq_Last_Response_Application__c;

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
        
        d.Rate_Type__c = rateType;
        d.Goods_type__c = productGoodsType;
        d.Goods_sub_type__c = productGoodsSubType;
        d.Loan_Frequency__c = loanFrequency;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
            d.Residual_Value_Percentage__c = residualValuePercentage;
        }else{
            d.Residual_Value_Percentage__c = null;
        }        
        d.Brokerage__c = brokeragePercentage;
        d.Payment__c = paymentType;
        d.LTV__c = null;
        if (ltv != null) {
            d.LTV__c = String.valueOf(ltv);
        }
        d.Vehicle_Age__c = manufactureYear;
        d.Customer_Profile__c = propertyOwner;
        d.Private_Sales__c = privateSales;
                
        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());
    }

    //-    
    public void changeLoanProduct(){
        productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
        productGoodsType = productGoodsTypes.get(0).getValue();
        changeGoodsType();
        loadLoanFrequency();
    }
    
    public void changeGoodsType(){
        productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(productLoanType, productGoodsType);
        productGoodsSubType = productGoodsSubTypes.get(0).getValue();
        productGoodsSubType = null;
        baseRate = 0;
        clientRate = 0;
        // assetYearOption();
    }
    
    public void loadLoanFrequency(){
        loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
        loanFrequency = loanFrequencies.get(0).getValue();
    }
    
    public void resetResidualValues(){
      residualValue = 0.0;
      residualValuePercentage = 0.0;
      isResidualValuePercentage = false;
      if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
        isResidualValuePercentage = true;
      }
    }
    
    public List <SelectOption> getOptions(){
        List <SelectOption> r = new List <SelectOption> ();
		r.add(new SelectOption (MacquarieConstants.TYPE_PERCENTAGE, MacquarieConstants.TYPE_PERCENTAGE));
		r.add(new SelectOption (MacquarieConstants.TYPE_VALUE, MacquarieConstants.TYPE_VALUE));
        return r;
    }
    
    private void saveMacquarieAPIInformation(){
        this.quoting.Mcq_Gross_Payment__c = mcqGrossPayment;
        this.quoting.Mcq_Customer_Rate__c = mcqCustomerRate;
        this.quoting.Mcq_Payment_Frequency__c = mcqPaymentFrequency;
        this.quoting.Mcq_Message_Quote__c = mcqMessageQuote; 
        this.quoting.Mcq_Last_Response_Quote__c = mcqLastResponseQuote;
        this.quoting.Mcq_Application_Id__c = mcqApplicationId;
        this.quoting.Mcq_Message_Application_Id__c = mcqMessageAppId;
        this.quoting.Mcq_Last_Response_Application__c = mcqLastResponseApplication;
        update this.quoting;
    }

    public PageReference macquarieQuote(){
        System.debug('>>>>> Response QUOTES Macquarie  -I  <<<<<< - ');
        if (!isCalculateUpdate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please make sure calculate before send to Macquarie.'));
            return null;
        }
        if (mcqGrossPayment != null && !mcqMessageQuote.equalsIgnoreCase('')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Quote: Succeeded'));
            return null;
        }
        try{
            mcService.requestQuote(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        
        if (mcManager.isError && 200 != mcManager.responseStatus){
            showErrorsMacquarie();
        }else{
            mcqGrossPayment = mcManager.mcqQuoteResponse.gross_payment;
            mcqCustomerRate = mcManager.mcqQuoteResponse.customer_rate;
            mcqPaymentFrequency = mcManager.mcqQuoteResponse.payment_frequency;
            mcqMessageQuote = mcManager.mcqQuoteResponse.message;
            mcqLastResponseQuote = mcManager.mcqQuoteResponse.lastResponseQuote;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Gross payment:   ' + mcqGrossPayment));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Customer rate:   ' + mcqCustomerRate));
            saveMacquarieAPIInformation();
        }
        System.debug('>>>>> Response QUOTES Macquarie  -F  <<<<<<');
        return null;
    }  
    
    public PageReference macquarieQuoteTest(){
        System.debug('>>>>> Response QUOTES Macquarie (Test)  -I  <<<<<< - ');
        try{
            mcService.requestQuoteTest(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        System.debug('>>>>> Response QUOTES Macquarie (Test) -F  <<<<<<');
        return null;
    } 
    
    public PageReference macquarieApplicationTest(){
        System.debug('>>>>> Response APPLICATION Macquarie  (Test)-I  <<<<<< - ');
        try{
            mcService.requestCreateApplicationTest(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            String er = '/' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'[Error createApplication: [' + er + ']'));
            return null;
        }
        System.debug('>>>>> Response APPLICATION Macquarie  (Test)-F  <<<<<< - ');
        return null;
    }
    
    public PageReference macquarieQuoteRestart(){
        System.debug('>>>>> Response QUOTES Macquarie (Restart)  -I  <<<<<< - ');
        mcqGrossPayment = null;
        System.debug('>>>>> Response QUOTES Macquarie (Restart) -F  <<<<<<');
        return null;
    }
    
    public PageReference macquarieApplication(){
        System.debug('>>>>> Response APPLICATION Macquarie  -I  <<<<<< - ');
        /**
        try{
            String sUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            mcService.requestDocumentUpload(mcManager, opp, sUrl, true);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        **/
        if (!isCalculateUpdate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please make sure calculate before send to Macquarie.'));
            return null;
        }

        if (mcqApplicationId !=null && !mcqApplicationId.equalsIgnoreCase('') && mcqMessageAppId !=null && !mcqMessageAppId.equalsIgnoreCase('')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application: Succeeded'));
            return null;
        }

        try{
            mcService.requestCreateApplication(mcManager, opp, totalInsurance, true, mcqUser);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            String er = '/' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'[Error createApplication: [' + er + ']'));
            return null;
        }

        
        if (mcManager.isError && 200 != mcManager.responseStatus){
            showErrorsMacquarie();
        }else{
            if (mcManager.mcqCreditAppResponse != null){
                mcqApplicationId = mcManager.mcqCreditAppResponse.application_id;
                mcqMessageAppId = mcManager.mcqCreditAppResponse.message;
                mcqLastResponseApplication = mcManager.mcqCreditAppResponse.lastResponseApplication;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Application Id:   ' + mcqApplicationId));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Message:   ' + mcqMessageAppId));
            saveMacquarieAPIInformation();
        }

        System.debug('>>>>> Response APPLICATION Macquarie  -F  <<<<<< - ');
        return null;
    }
    
    private void showErrorsMacquarie(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Savvy message: ' + mcManager.message + '. Please check all the data.'));
        String sError = '';
        System.debug(sError);
        if (mcManager.mcqError == null){
            sError = 'Status: [' + mcManager.responseStatus + ']- Message: [' + StringUtils.validateNull(mcManager.message) + ']- Response Message: [' + StringUtils.validateNull(mcManager.responseMessage) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else if (mcManager.mcqError.errors != null){
            for (McqErrorResponse.ErrorsValidationData error : mcManager.mcqError.errors){
                String messageError = '{' + error.label + '} - ' + error.message + ' - [' + error.getDescription() + ']' + ' [' + Utilities.salesforceValueToMessageCode_Description(error.label, Utilities.McQ_ERRORS_DATA) + ']';
                System.debug('>>@Error Macquarie: ' + messageError);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,messageError));
            }
		}else if (mcManager.mcqError.code != null){
            sError = 'Code: [' + StringUtils.validateNull(mcManager.mcqError.code) + '] - Error: [' + StringUtils.validateNull(mcManager.mcqError.error) + ']- Message: [' + StringUtils.validateNull(mcManager.mcqError.message) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else{
            sError = 'Status: [' + mcManager.responseStatus + ']- Message: [' + StringUtils.validateNull(mcManager.message) + ']- Response Message: [' + StringUtils.validateNull(mcManager.responseMessage) + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }
    }
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }
    
    //Lelo                      2017-07-21
    public Boolean hasCalculationDone() {
        Boolean r = false;
        //Recalculate
        r = isValidCalculate();
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
    
    private void calculateRepayments() {
      //Reset results
      this.resetCalculationResult();
      //FULL CALCULATION
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      String quotingType = QuotingCalculation.CALC_QUOTING;
      param.totalAmount = getTotalAmount(quotingType);
      param.totalInsurance = getTotalInsuranceType(quotingType);
      param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
      //param.clientRate = clientRate;
      param.baseRate = baseRate;
      param.paymentType = paymentType;
      param.term = term;
      param.dof = dof;
      param.monthlyFee = monthlyFee;
      //param.docFees = docFees;
      param.residualValue = residualValue;

      param.brokeragePer = 0.0;
      param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(quotingType);
      param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);

      System.debug(quotingType + '|' + param.amountBasePmt + '|' + param.amountBaseComm + '|' + param.getNaf());

      Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
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
      //Insurance one by one
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
        param.totalAmount = getTotalAmount(key);
        param.totalInsurance = this.getTotalInsuranceType(key);
        param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(key);
        param.amountBaseComm = this.getBaseAmountPmtCalc(key);
        System.debug(key + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.amountBasePmt + '|' + param.amountBaseComm);
        //System.debug('INSURA >> ' + key + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.amountBasePmt + '|' + param.amountBaseComm);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = key;   
        }
        calResults.put(key, r);
      }
    }
	  
    //Yohan VillaLeal    08/11/2018
    public void assetYearOption(){
        manufactureYearOptions = new List <SelectOption> ();
        manufactureYearOptions.add(new SelectOption ('', '--None--'));    
        Integer y = Date.today().year();
        //manufactureYearOptions.add(new SelectOption ('', '--None--'));
        
        // if('MOTOV'.equals(productGoodsType)){
            for(Integer i = y;i >= y - VH_YEARS;i--) {
                manufactureYearOptions.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
            }
            SelectOption myOp = manufactureYearOptions.get(manufactureYearOptions.size()-1);
            myOp.setLabel(myOp.getValue() + ' or older');
        // }else{ 
        //     for(Integer i = y;i >= y - 3;i--) {
        //         manufactureYearOptions.add(new SelectOption (String.valueOf(i), String.valueOf(i)));    
        //     }
        // }
        this.manufactureYear = manufactureYearOptions.get(0).getValue();
    }
    //NWC Calculator - HJ - 12-07-2018 - F

    public boolean isValidAssetDetails(){
        Boolean r = true;
        Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Id);
        if(aad != null){
            // Year
            if(aad.Year__c!=null && String.isNotBlank(manufactureYear) && manufactureYear.isNumeric()) {
                Integer aadYear = aad.Year__c.intValue();
                Integer y = Integer.valueOf(manufactureYear);
                String miny = manufactureYearOptions.get(manufactureYearOptions.size()-1).getValue();
                if (aadYear != y && (this.manufactureYear.equals(miny) && y > Integer.valueOf(miny))) {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR,'Vehicle Age does not match with the Vehicle Year in Asset Details / Application form page.'));
                    r = false;
                }
            }
            // LTV
            if ('MOTOV'.equals(this.productGoodsType) && 'MOTOV_CARS_-_OTHER_CARS_AU'.equals(productGoodsSubType)) {
                if (aad.LVR__c != null) {
                    if (ltv != aad.LVR__c.intValue()) {
                        ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR,'LTV does not match with Asset Details (' + aad.LVR__c + '%)'));
                        r = false;
                    }
                }
            }
        }
        return r;
    }

  public List<MacquarieConsumerRatesv2__c> getRateList() {
    List <MacquarieConsumerRatesv2__c> d = QuotingCalculation.getMacquarieRates('Consumer');
    List <MacquarieConsumerRatesv2__c> r = new List <MacquarieConsumerRatesv2__c>();
    for (MacquarieConsumerRatesv2__c a: d) {
      r.add(a);
    }
    return r;
  }
  
  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
  
  // Abstract methods implementation
  public override Boolean hasValidQuotation() {
    System.debug(this.quotingName + ' overriding hasValidQuotation...');
    return this.isValidCalculate();
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