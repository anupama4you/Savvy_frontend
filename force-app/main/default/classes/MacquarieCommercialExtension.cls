public class MacquarieCommercialExtension extends QuotingExtension {
    
    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'Macquarie_Commercial';
    public static final String LENDER_QUOTING = 'Macquarie Commercial';
    public static Decimal MAX_BROKERAGE = 4.0;
    //-

    // Lender variables
    public Integer carAge {get;set;}
    public String propertyOwner {get;set;}
    public String manufactureYear {get;set;}
    public List <SelectOption> manufactureYearOptions {get;set;}    
    public Integer ltv {get;set;}
    public Decimal brokeragePercentage {get;set;}
    public Decimal totalInsurance {set; get;}
    public String loanFrequency {set; get;}
    public String selectedTypeValue {set; get;}
    public Decimal residualValuePercentage {set; get;}
    public Boolean isResidualValuePercentage {set; get;}
    public String productGoodsType {get;set;}
    public String productGoodsSubType {get;set;}
    
    // rates references
    public List <MacquarieCommercialRates__c> macquarieRates {get;set;}
    Map <String,MacquarieCommercialRates__c> macquarieCommercialRates {get;set;}
    
    // addtional loan information
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    public List <SelectOption> productGoodsSubTypes {get;set;}
    public List <Selectoption> loanFrequencies {set; get;}
    
    //Maclease Quote
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
    public Boolean paramActive {set; get;}

    public MacquarieCommercialExtension (ApexPages.StandardController controller) {
        super(controller);
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);    
        
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%Macquarie_Consumer%'];
        
        //Lelo              2016-12-22
        loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        productLoanTypes = QuotingToolHelper.getLoanProductOptionsCommercial();
        
        loadLoanFrequency();
        selectedTypeValue = MacquarieConstants.TYPE_VALUE;

        this.quotingName = LENDER_QUOTING;
        this.reset();

        // this.carAge = 4;
        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNaf = applicationFee + dof + ppsr;
        this.brokeragePercentage = MAX_BROKERAGE;
        
        this.resetCalculationResult(); //Lelo       2017-07-25
        
        macquarieCommercialRates = MacquarieCommercialRates__c.getAll();
        System.debug('The map value: ' + macquarieCommercialRates);
        macquarieRates = macquarieCommercialRates.values();
        macquarieRates.sort();
        
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
                if (lender != null && lender.info != null && 'MCOM'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productLoanType = lender.productLoanType;
                    this.productGoodsType = lender.productGoodsType;
                    this.productGoodsSubType = lender.productGoodsSubType;
                    this.loanFrequency = lender.loanFrequency;
                    this.carAge = lender.carAge;
                    this.privateSales = lender.privateSales;
                    //Lelo                          2017-11-16
                    this.brokeragePercentage = lender.brokerageBase;
                    this.dof = lender.dofBase;
                    this.paymentType = 'Arrears';
                    //
                    // this.assetYearOption();
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

    public void baseRateCalc() {

        Decimal originalRate = 0.00;
        //Lelo                              2016-08-25
        realtimeNafCalc();
        Decimal financeAmount = realtimeNaf;
        //-
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
        this.baseRate = QuotingCalculation.getBaseRate(param);

        if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than ' + MAX_BROKERAGE.format() + '%'));
        }

        totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);

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

    } //end of funcion
    
    //Lelo          2017-07-26
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
    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        Decimal r = getRealtimeNaf(calcType);
        if (brokeragePercentage != null && brokeragePercentage != 0) {
          // r += (getBaseAmountPmtCalc(calcType) * brokeragePercentage/100);
          r += (r * brokeragePercentage/100);
        }
        return r;
    }
    
    public override void realtimeNafCalc() {
        netDepositCalc();
        realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
        totalInsurance = this.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
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
          if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE) {
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
        if ('Y'.equals(privateSales) || 'Sale & Lease Back'.equals(loanType)) {
            applicationFee = lenderSettings.Application_Fee_Private__c;
        } else {
            applicationFee = lenderSettings.Application_Fee__c;
        }
        realtimeNafCalc();
    } 
    
    public Boolean isValidCalculate () {
        Boolean r = true;
        if (clientRate > 14.75) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be larger than 14.75%.'));
            r = false;
        }
        if (term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Term cannot be longer than five years.'));
            r = false;
        }
        if (realtimeNaf < 10000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Financed Amount cannot be less than $10,000.'));
            r = false;
        }
        // validation before calculation
        if (clientRate == null || clientRate <= 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        }
        if (baseRate == null || baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        if (String.isBlank(manufactureYear)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an Asset Year option.'));
            r = false;
        }
        if (String.isBlank(privateSales)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a Private Sale option.'));
            r = false;
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than ' + MAX_BROKERAGE.format() + '%'));
            r = false;
        }
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }
    
    public void calculate () {
        baseRateCalc();        
        if (isValidCalculate()) {
          this.calculateRepayments(); 
          if (estimatedCommission <= 0) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
          }
          
          isCalculateUpdate = true;
        }
    } // end of function
    
    public void reset () {
      this.resetQuote();
        this.loanType = this.loanTypeOptions.get(0).getValue();
        this.productLoanType = this.productLoanTypes.get(0).getValue();
        this.productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(productLoanType);
        this.loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
        this.productGoodsType = productGoodsTypes.get(0).getValue();
        this.carPrice = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        //this.applicationFee = 350.00;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;        
        this.residualValuePercentage = 0.00;
        this.selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.term = 60;
        this.propertyOwner = 'N';
        this.ltv = null;
        this.brokeragePercentage = MAX_BROKERAGE;
        this.paymentType = 'Advance';
        this.productGoodsType = '';
        this.productGoodsSubType = '';
        this.loanFrequency = '';
        resetResidualValues();
        mcService = new MacLeasePartnerService();
        mcManager = new MacquarieManager();

        this.resetInsuranceProducts(false);

        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNafCalc();
        isCalculateUpdate = false;
        this.resetCalculationResult(); //Lelo       2017-07-25
    } // end of function
    
    private PageReference savePdf (String prefixName) {
        PageReference calcPdf = this.createPdf();
        calcPdf.getParameters().put('lender', 'MACQUARIE COMMERCIAL CALCULATION');
        
        // Lender parameters
        calcPdf.getParameters().put('selectedTypeValue', selectedTypeValue);
        calcPdf.getParameters().put('residualValuePercentage', String.valueOf(residualValuePercentage));
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(brokeragePercentage));
        calcPdf.getParameters().put('privateSales', privateSales);
        if (ltv != null) {
            calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        }
        calcPdf.getParameters().put('customerProfile', propertyOwner);
        calcPdf.getParameters().put('carAge', manufactureYear);
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('productGoodsSubType', productGoodsSubType);
        calcPdf.getParameters().put('loanFrequency', loanFrequency);
        
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending for approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        
        if (this.Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create or assoiciate an Application Forma before saving for any approval process.'));
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
            updateProduct = [Select id,Loan_Purpose__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,
                             Brokerage__c,Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c,Quoting_Source__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
            
        updateProduct.Loan_Purpose__c = 'Business Use';
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
    
    //Lelo                                  2016-07-26
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
                // this.quoting.Force_Calculation__c = false;
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
            
            if (sameQuoting) {
              this.loadQuotingInsuranceData();
              this.loadQuotingData();

              residualValuePercentage = d.Residual_Value_Percentage__c;
              if (d.Residual_Value_Percentage__c != null && d.Residual_Value_Percentage__c != 0){
                  selectedTypeValue = MacquarieConstants.TYPE_PERCENTAGE;
              } else {
                  selectedTypeValue = MacquarieConstants.TYPE_VALUE;
              }
                productGoodsType = d.Goods_type__c;
                productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(productLoanType, productGoodsType);
                productGoodsSubType = d.Goods_sub_type__c;  
                
                if (String.isNotBlank(productLoanType)) {
                    loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(productLoanType);
                }
                loanFrequency = d.Loan_Frequency__c;
                brokeragePercentage = d.Brokerage__c;
                privateSales = d.Private_Sales__c;
                paymentType = d.Payment__c;
                
                // this.assetYearOption();
                if (String.isNotBlank(d.Vehicle_Age__c) && d.Vehicle_Age__c.isNumeric()) {
                    manufactureYear = d.Vehicle_Age__c;
                }
                propertyOwner = d.Customer_Profile__c;

                if (String.isNotBlank(d.LTV__c)) {
                    ltv = Integer.valueOf(d.LTV__c);
                }

                //Calculations
                applicationFeefCalc();
                baseRateCalc();

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
                       
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
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
        d.Goods_type__c = productGoodsType;
        d.Goods_sub_type__c = productGoodsSubType;
        d.Loan_Frequency__c = loanFrequency;
        d.Residual_Value_Percentage__c = null;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE){
            d.Residual_Value_Percentage__c = residualValuePercentage;
        }
        d.Brokerage__c = brokeragePercentage;

        //Loan Details
        d.Payment__c = paymentType;
        d.Private_Sales__c = privateSales;
        d.LTV__c = null;
        if (ltv != null) {
            d.LTV__c = String.valueOf(ltv);
        }
        d.Vehicle_Age__c = manufactureYear;
        d.Customer_Profile__c = propertyOwner;
        
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
        productGoodsSubType = productGoodsTypes.get(0).getValue();
        // this.assetYearOption();
        this.baseRateCalc();
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
    
    private void saveMacquarieAPIInformation() {
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
    
    public PageReference macquarieQuoteRestart(){
        System.debug('>>>>> Response QUOTES Macquarie (Restart)  -I  <<<<<< - ');
        mcqGrossPayment = null;
        System.debug('>>>>> Response QUOTES Macquarie (Restart) -F  <<<<<<');
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
            mcService.requestQuote(mcManager, opp, totalInsurance, false, mcqUser);
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
    
    public PageReference macquarieApplication(){
        System.debug('>>>>> Response APPLICATION Macquarie  -I  <<<<<< - ');
        /**
        try{
            String sUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            mcService.requestDocumentUpload(mcManager, opp, sUrl, false);
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
        try{
            mcService.requestCreateApplication(mcManager, opp, totalInsurance, false, mcqUser);
        }catch(MacLeasePartnerException ex){
            mcManager.isError = true;
            String er = '/' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'[Error createApplication: [' + er + ']'));
            return null;
        }

        
        if (mcManager.isError && 200 != mcManager.responseStatus){
            showErrorsMacquarie();
        }else{
            mcqApplicationId = mcManager.mcqCreditAppResponse.application_id;
            mcqMessageAppId = mcManager.mcqCreditAppResponse.message;
            mcqLastResponseApplication = mcManager.mcqCreditAppResponse.lastResponseApplication;
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
    //-
    
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

      param.brokeragePer = brokeragePercentage;
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
        System.debug('INSURA >> ' + key + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.amountBasePmt + '|' + param.amountBaseComm);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = key;   
        }
        calResults.put(key, r);                
      }

    }

    public List<MacquarieConsumerRatesv2__c> getRateList() {
        // List <MacquarieConsumerRatesv2__c> r = MacquarieConsumerRatesv2__c.getAll().values();
        // r.sort();
        return QuotingCalculation.getMacquarieRates('Commercial');
    }
	
    //Yohan VillaLeal    08/11/2018
    public void assetYearOption(){
        manufactureYearOptions = new List <SelectOption> ();
        manufactureYearOptions.add(new SelectOption ('', '--None--'));    
        Integer y = Date.today().year();
        //manufactureYearOptions.add(new SelectOption ('', '--None--'));
        
        // if('MOTOV'.equals(productGoodsType)){
            for(Integer i = y;i >= y - 4;i--) {
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