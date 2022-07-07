public with sharing class FinanceOnePLExtension {
    public Custom_Opportunity__c Opp;
    
    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'Finance_OnePL';
    //-    
    
    // finance calculator input
    public Decimal carPrice {get;set;}
    public Decimal applicationFee {get;set;}
    public Decimal dof {get;set;}
    public Decimal maxDof {get;set;}
    public Decimal ppsr {get;set;}
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}
    public Decimal residualValue {get;set;}
    public Decimal baseRate {get;set;}
    public Decimal maxRate {get;set;}
    public Decimal clientRate {get;set;}
    
    public Integer term {get;set;}
    public String loanTypeDetail {get;set;}
    public String paymentType {get;set;}
    
    public List <SelectOption> yesNoOptions {get;set;}
    public List <SelectOption> paymentTypes {get;set;}
    
    // finance calculator output
    public Decimal estimatedCommission {get;set;}
    public Decimal insuranceIncome {get;set;}
    public Decimal dofResult {get;set;}
    public Decimal totalCommission {get;set;}
    public Decimal totalCommissionGst {get;set;}
    
    public Decimal naf {get;set;}
    public Decimal rental {get;set;}
    public Decimal monthlyFee {get;set;}
    public Decimal monthlyPayment {get;set;}
    public Decimal fortnightlyPayment {get;set;}
    public Decimal weeklyPayment {get;set;}
    
    // insurance info
    public Decimal cci {get;set;}
    public Decimal cciIncome {get;set;}
    public String cciLevel {get;set;}
    private List<String> cciLevels = new List<String> {
      'Disability', 'Disability/Unemployment'
    };

    // rates references
    public List <FinanceOneRates__c> financeOneRates {get;set;}
    Map <String,FinanceOneRates__c> financeOneRatesMap {get;set;}
    
    // addtional loan information
    public String productLoanType {get;set;}
    public List <SelectOption> productLoanTypes {get;set;}
    
    // the real time NAF
    public Decimal realtimeNaf {get;set;}
    
    // Other things
    Map<String,id> RecordTypes {get;set;}
        
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Finance One PL';
    public String loanType {get;set;}                       
    public List <SelectOption> loanTypeOptions {get;set;}         
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;   
    //-
        
    //Lelo                  Insurance                       2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String quoteIdSelected {get;set;}

    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    public String cciAcceptance {get;set;}
    public String category {get;set;} // secured or unsecured
    //-

    private Lenders__c lenderSettings {set;get;}

    public FinanceOnePLExtension (ApexPages.StandardController controller) {        
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);
        this.reset();

        financeOneRatesMap = FinanceOneRates__c.getAll();
        financeOneRates = financeOneRatesMap.values();
        financeOneRates.sort();
        
        yesNoOptions = new List <SelectOption> ();
        yesNoOptions.add(new SelectOption ('', '--None--'));
        yesNoOptions.add(new SelectOption ('Y', 'Yes'));
        yesNoOptions.add(new SelectOption ('N', 'No'));
        
        paymentTypes = new List <SelectOption> ();
        paymentTypes.add(new SelectOption ('', '--None--'));
        paymentTypes.add(new SelectOption ('Arrears', 'Arrears'));
        paymentTypes.add(new SelectOption ('Advance', 'Advance'));
        
        //Lelo              2016-12-22
        //loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        loanTypeOptions = new List<SelectOption>{
            new SelectOption('Purchase','Purchase'),
            new SelectOption('Refinance','Refinance')
        };
        loanType = loanTypeOptions.get(0).getValue();
        // productLoanTypes = QuotingToolHelper.getLoanProductOptions();
        productLoanTypes = new List<SelectOption>{
            new SelectOption('Consumer Loan','Consumer Loan')
        };
        productLoanType = productLoanTypes.get(0).getValue();
        //-
        
        preLoadQuotingValues();
        
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
                if (lender != null && lender.info != null && 'FION'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    // this.deposit = lender.deposit;
                    this.term = lender.term;
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
            this.ericLPICalculate();
        } else {
            loadQuotingParametersSaved();
        }
        baseRateCalc();
    }

    public void calculateValidation () {
        this.isValidationOk();
    }

    public void applicationFeeCalc() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.productLoanType = this.productLoanType;
        param.loanTypeDetail = this.loanTypeDetail;
        param.totalAmount = 0;
        if (this.carPrice != null) param.totalAmount += this.carPrice;
        applicationFee = QuotingCalculation.getFinanceOneApplicationFee(param);
    } // end of function
    
    public void dofCalc () {
        dofCalc(QuotingCalculation.CALC_QUOTING);
    } // end of function
    private void dofCalc (String calcType) {
        this.dofCalc(calcType, true);
    }

    private void dofCalc (String calcType, Boolean fullCalc) {
        decimal totalInsurance = this.getTotalInsuranceType(calcType);
        decimal totalAmount = 0;
        if (this.carPrice != null) totalAmount += this.carPrice;
        totalAmount = totalAmount + totalInsurance;
        Decimal r = 0.0;
        // if (totalAmount >= 5000 && totalAmount <= 8000) {
        if (totalAmount <= 8000) {
            r = 550.00;
        } else {
            Decimal base = totalAmount;
            if (applicationFee != null) base += applicationFee;
            if (ppsr != null) base += ppsr;
            r = base * 0.10;
            if (r > lenderSettings.DOF__c) {
                r = lenderSettings.DOF__c;
            }
        }
        if (fullCalc) this.dof = r.setScale(2);
        this.maxDof = r;
    } // end of function

    public void baseRateCalc () {
        this.baseRate = 0.00;
        this.maxRate = 0.00;
        this.clientRate = 0.00;
        if (String.isNotBlank(this.category)) {
            QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
            param.productLoanType = this.productLoanType;
            param.loanTypeDetail = this.loanTypeDetail;
            param.customerProfile = this.category;
            this.baseRate = QuotingCalculation.getBaseRate(param);
            this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
            this.clientRate = this.baseRate;
        }
    }
    
    public void riskFeeCalc () {
        riskFeeTotal = this.getRiskFeeCalc(QuotingCalculation.CALC_QUOTING);
        realtimeNaf = getRealTimeNAFCalc(QuotingCalculation.CALC_QUOTING);
        this.ericLPICalculate();
    } //end of funcion
    
    //Lelo          2017-07-27
    public Decimal getRiskFeeCalc(String calcType) {
        return getRiskFeeCalc(calcType, null);
    }
    
    public Decimal getRiskFeeCalc(String calcType, Decimal totalInsurance) {
        Decimal r = 0.0;
        // Decimal nc = this.getNafCommission(calcType, totalInsurance);
        Decimal nc = this.getRealTimeNAFCalc(calcType);
        if ((nc + 995.0) >= 5000 && (nc + 995.0) <= 12000) {
            r = 995.0;
        } else if ((nc + 1495.00) > 12000 && (nc + 1495.00) <= 20000) {
            r = 1495.00;
        } else if ((nc + 1495.00) > 20000 && nc <= 75000) {
            r = 1995.00;
        } else {
            r = 0;
        }
        return r.setScale(2);
    }

    //Lelo          2017-07-27
    public Decimal getRealTimeNAFCalc(String calcType) {
        Decimal r = this.getNafCommission(calcType);
        // r += this.getRiskFeeCalc(calcType);
        if (this.riskFee != null) {
            r += this.riskFee;
        }
        if (applicationFee != null) r+= applicationFee;
        if (dof != null) r+= dof;
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
        System.debug('2) ' + r);
        if (baseRate == null || baseRate == 0.0 || baseRate < 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        System.debug('3) ' + r);
        if (String.isBlank(category)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Secured or Unsecured.'));
            r = false;
        } else {
            System.debug('4) ' + r + ' >> ' + category);
            QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
            param.productLoanType = this.productLoanType;
            param.loanTypeDetail = this.loanTypeDetail;
            param.customerProfile = category;
            FinanceOneRates__c rate = QuotingCalculation.getFinanceOneRates(param);
            System.debug('rate: ' + rate);
            if (rate != null) {
                String a = '(' + this.category + ') ' + rate.Category__c + ' - ' + rate.Product__c;
                if (this.carPrice < rate.Minimum_Amount__c || this.carPrice > rate.Maximun_Amount__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': Vehicle price should be between $' + rate.Minimum_Amount__c.format() + ' and $' + rate.Maximun_Amount__c.format() + '.'));
                    r = false;
                }
                //Term
                if (this.term == null || this.term < 36 || this.term > rate.Max_Term__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': term should be between 36 months to ' + rate.Max_Term__c + ' months.'));
                    r = false;
                }
            }
        }
        System.debug('6) ' + r);
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        System.debug('8) ' + r);
        if(riskFee > 1995){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Greater than $1995 - Max risk fee exceeded Refer to Finance one'));
        }else if(riskFee > 0 && riskFee < 995){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Less than $995 - Below minimum risk fee - refer to Finance one'));
        }else if(riskFee < riskFeeTotal && riskFee != 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk fee changed - refer to Finance one'));
        }
        
        if(riskFee > riskFeeTotal){
     		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk fee is greater than Risk fee calculated'));       
        }

        return r;
    }

    public void calculate () {
        riskFeeCalc();
        baseRateCalc();

        if (!isValidationOk()) {
            return;
        }

        this.calculateRepayments();

        if (estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
    } // end of function
    
    public void reset () {
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        this.loanTypeDetail = 'Gold';
        this.category = null;
        this.carPrice = null;
        this.applicationFee = lenderSettings.Application_Fee__c;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.riskFee = null;
        this.riskFeeTotal = null;
        this.residualValue = null;
        this.clientRate = null;
        this.term = 36;
        this.paymentType = 'Arrears';
        this.estimatedCommission = 0.00;
        this.insuranceIncome = 0.00;
        this.dofResult = 0.00;
        this.totalCommission = 0.00;
        this.totalCommissionGst = 0.00;
        this.naf = 0.00;
        this.rental = 0.00;
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        this.monthlyPayment = 0.00;
        this.fortnightlyPayment = 0.00;
        this.weeklyPayment = 0.00;

        //Lelo                  Insurance           2018-02-26
        this.cci = 0.00;
        this.cciIncome = 0.00;
        this.cciAcceptance = 'U';

        this.quoteIdSelected = null;
        this.quote = new Application_InsuranceQuote__c();
        //- 
        
        //this.productLoanType = '';
        //this.productGoodsType = 'Car';
        this.dofCalc();
        this.riskFeeCalc();
        //this.realtimeNaf = applicationFee + dof;

        this.resetCalculationResult(); //Lelo       2017-07-25
        baseRateCalc();
    } // end of function
    
    private void savePdf (String prefixName) {
        // validate the calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return;
        }
        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id',Opp.Id);
        calcPdf.getParameters().put('lender', LENDER_QUOTING.toUpperCase() + ' CALCULATION');
        
        //Manual Insurances
        // Lelo         Insurance       2018-02-26
        if ('A'.equals(cciAcceptance)) {
            calcPdf.getParameters().put('cciLevel', cciLevel);
            calcPdf.getParameters().put('cci', String.valueOf(cci));
            calcPdf.getParameters().put('cciIncome', String.valueOf(cciIncome));
        } else {
            calcPdf.getParameters().put('cciLevel', null);
            calcPdf.getParameters().put('cci', String.valueOf(0.00));
            calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        }
        //-

        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));
        
        calcPdf.getParameters().put('applicationFee', String.valueOf(applicationFee));
        calcPdf.getParameters().put('dof', String.valueOf(dof));
        calcPdf.getParameters().put('ppsr', String.valueOf(ppsr));
        calcPdf.getParameters().put('residualValue', String.valueOf(residualValue));
        calcPdf.getParameters().put('baseRate', String.valueOf(baseRate));
        calcPdf.getParameters().put('clientRate', String.valueOf(clientRate));
        calcPdf.getParameters().put('term', String.valueOf(term));
        calcPdf.getParameters().put('paymentType', paymentType);
        calcPdf.getParameters().put('estimatedCommission', String.valueOf(estimatedCommission));
        calcPdf.getParameters().put('insuranceIncome', String.valueOf(insuranceIncome));
        calcPdf.getParameters().put('dofResult', String.valueOf(dofResult));
        calcPdf.getParameters().put('totalCommission', String.valueOf(totalCommission));
        calcPdf.getParameters().put('totalCommissionGst', String.valueOf(totalCommissionGst));
        calcPdf.getParameters().put('naf', String.valueOf(naf));
        calcPdf.getParameters().put('rental', String.valueOf(rental));
        calcPdf.getParameters().put('monthlyFee', String.valueOf(monthlyFee));
        calcPdf.getParameters().put('monthlyPayment', String.valueOf(monthlyPayment));
        calcPdf.getParameters().put('fortnightlyPayment', String.valueOf(fortnightlyPayment));
        calcPdf.getParameters().put('weeklyPayment', String.valueOf(weeklyPayment));
        // pass varaibles for ANZ Consumer
        calcPdf.getParameters().put('loanTypeDetail', loanTypeDetail);
        calcPdf.getParameters().put('riskFee', String.valueOf(riskFee));
        // pass variables about the product info
        calcPdf.getParameters().put('loanType', loanType);
        calcPdf.getParameters().put('productLoanType', productLoanType);
        calcPdf.getParameters().put('customerProfile', category);
        
        Boolean isSaveInCloud = false;
        if (prefixName.contains('APPROVAL')) {
            isSaveInCloud = true;
            String typeData = 'Quoting Calculation';
            if (prefixName.contains('AMENDMENT')) {
               typeData = 'Quoting Calculation (Amendment)';
            } else if (prefixName.contains('FORMAL_APPROVAL')) {
               typeData = 'Quoting Calculation (Formal Approval)';
            }
            ApplicationExtraDataHelper.upsertData(
                    Opp.Application__c, typeData, typeData, 
                    QuotingToolHelper.getApplicationQuoting(Opp.Application__c));
        }
        QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, calcPdf, isSaveInCloud);
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation saved successfully.'));
    } // end of function
    
    private void saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk()) {
            return;
        }
        calculate();
        
        // validate calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return;
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
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
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
        
        updateProduct.Lender__c = 'Finance One';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = loanTypeDetail;

        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Term is not updated as the calculator does not contain relevant info.'));
            updateProduct.Loan_Term__c = 0;
        } else {
            updateProduct.Loan_Term__c = term;
        }
        if (residualValue == null || residualValue == 0) {
            updateProduct.Balloon_Residual_Requested__c = 0;
        } else {
            updateProduct.Balloon_Residual_Requested__c = residualValue;
        }
        if (clientRate == null || clientRate == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client Rate is not updated as the calculator does not contain relevant info.'));
            updateProduct.Client_Rate__c = 0;
        } else {
            updateProduct.Client_Rate__c = clientRate;
        }
        if (monthlyPayment == null || monthlyPayment == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Payment is not updated as the calculator does not contain relevant info.'));
            updateProduct.Payments__c = 0;
        } else {
            updateProduct.Payments__c = monthlyPayment;
        }
        if (carPrice == null || carPrice == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Cost of Goods is not updated as the calculator does not contain relevant info.'));
            updateProduct.Cost_of_Goods__c = 0;
        } else {
            updateProduct.Cost_of_Goods__c = carPrice;
        }
        updateProduct.Deposit__c = 0;
        if (dof == null || dof == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'DOF is not updated as the calculator does not contain relevant info.'));
            updateProduct.DOF__c = 0;
        } else {
            updateProduct.DOF__c = dof;
        }
        if (estimatedCommission == null || estimatedCommission == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission is not updated as the calculator does not contain relevant info.'));
            updateProduct.Brokerage__c = 0.00;
        } else {
            updateProduct.Brokerage__c = estimatedCommission;
        }
        if (applicationFee == null || applicationFee == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee is not updated as the calculator does not contain relevant info.'));
            updateProduct.Lender_App_Fee__c = 0;
        } else {
            updateProduct.Lender_App_Fee__c = applicationFee;
        }
        updateProduct.Equalisation_Fee_PPSR__c = 0;
        if (ppsr != null && ppsr > 0) {
            updateProduct.Equalisation_Fee_PPSR__c += ppsr;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
        }
        if (riskFee != null && riskFee > 0) {
            updateProduct.Equalisation_Fee_PPSR__c += riskFee;
        }
        
        //Lelo                      2016-07-26
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }

        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        //-
        
        // then create the insurance products
        //Lelo      Insurnce        2018-02-26
        // CCI Insurance
        if ('A'.equals(cciAcceptance)) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'CCI';
            newInsurance.Insurance_Policy_Amount__c = cci;
            if (cciIncome == null || cciIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'CCI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = cciIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        
        //Lelo                              2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));        
    } // end of function
    
    //Lelo                                  2016-07-26
    public void saveQuoting() {
        //Recalculate
        if (hasCalculationDone() && 
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            this.saveQuotingParameters();
            this.savePdf(fileGlobalPrefix);
        }
    }
    
    public void savePreApproval() {
        saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public void saveAmendment() {
        saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public void saveFormalApproval() {
        this.quoting.Force_Calculation__c = false;
        saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
    }
    //-
    
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        // Lelo             Insurance           2017-12-04
        this.quoting = d;
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

            //--
            if (sameQuoting) {
                this.quoteIdSelected = d.App_Insurance_Quote__c;
                this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoteIdSelected);
                //Lelo              Insurance           2017-12-04
                if (this.quote != null) {
                    if (!LENDER_QUOTING.equals(this.quote.Financier_Name__c)) {
                        this.quoteIdSelected = null;
                        d.App_Insurance_Quote__c = null;
                        this.quote = null;
                    }
                }

                // Lelo             Insurance           2018-02-26
                cciLevel = d.Insurance_AIC_Type__c;
                cci = d.Insurance_AIC_Retail_Price__c;
                cciIncome = d.Insurance_AIC_Income__c;
                cciAcceptance = d.Insurance_AIC_Acceptance__c;
                if (String.isBlank(cciAcceptance)) {
                    cciAcceptance = 'U';
                }
                //-

                // if (this.quote != null) {
                //     this.quote.MV_Acceptance__c = mvAcceptance;
                //     this.quote.GAP_Acceptance__c = gapAcceptance;
                //     this.quote.TAS_Acceptance__c = taiAcceptance;
                //     this.quote.LTI_Acceptance__c = ltiAcceptance;
                //     this.quote.WRR_Acceptance__c = warrantyAcceptance;
                // }
            }

            //Finance Details
            //Commons values
            loanType = d.Loan_Type__c;
            productLoanType = d.Loan_Product__c;
            carPrice = d.Vehicle_Price__c;
            residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                //Specific values
                if (d.Client_Rate__c != null) {
                    clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                paymentType = d.Payment__c;
                
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;    
                monthlyFee = d.Monthly_Fee__c;
                loanTypeDetail = d.Loan_Facility_Type__c;
                category = d.Category_Type__c;

                //Load Calculations
                estimatedCommission = d.Commission_Estimation__c;
                insuranceIncome = d.Commission_Insurance_Income__c;
                dofResult = d.Commission_DOF__c;
                totalCommission = d.Commission_Total_GST_Exc__c;
                totalCommissionGst = d.Commission_Total_GST_Inc__c;

                rental = d.Rental__c;
                naf = d.NAF__c;
                monthlyPayment = d.Repayment_Monthly__c;
                fortnightlyPayment = d.Repayment_Fortnightly__c;
                weeklyPayment = d.Repayment_Weekly__c;
				riskFee = d.Risk_Fee__c;
                //Load calculations
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);
            }
        }
        this.dofCalc(QuotingCalculation.CALC_QUOTING, false);
        riskFeeCalc();
        baseRateCalc();
        if (!'A'.equals(cciAcceptance)) {
            this.ericLPICalculate();
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
        //Lelo              Insurance           2017-12-04
        if (this.quote == null) {
            this.quote = new Application_InsuranceQuote__c();
        } 
        //-
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);
        Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
            d = this.quoting; 
        }
        //Associate Application / Opportunity
        d.Application__c = this.Opp.Application__c;
        d.Opportunity__c = this.Opp.Id;
        //Lender
        d.Name = LENDER_QUOTING;
        
        //Lelo              Insurance           2017-12-04
        //Insurance product
        d.Insurance_MV_Type__c = null;
        d.Insurance_MV_Retail_Price__c = null;
        d.Insurance_MV_Income__c = null;
        d.Insurance_MV_Acceptance__c = 'U';

        d.Insurance_GAP_Type__c = null;
        d.Insurance_GAP_Retail_Price__c = null;
        d.Insurance_GAP_Income__c = null;
        d.Insurance_GAP_Acceptance__c = 'U';
        
        d.Insurance_TAI_Type__c = null;
        d.Insurance_TAI_Retail_Price__c = null;
        d.Insurance_TAI_Income__c = null;
        d.Insurance_TAI_Acceptance__c = 'U';

        d.Insurance_LTI_Type__c = null;
        d.Insurance_LTI_Retail_Price__c = null;
        d.Insurance_LTI_Income__c = null;
        d.Insurance_LTI_Acceptance__c = 'U';
        
        d.Insurance_Warranty_Type__c = null;
        d.Insurance_Warranty_Retail_Price__c = null;
        d.Insurance_Warranty_Income__c = null;
        d.Insurance_Warranty_Acceptance__c = 'U';

        d.Insurance_NWC_Retail_Price__c = null;
        d.Insurance_NWC_Income__c = null;
        d.Insurance_NWC_Plan__c = null;
        d.Insurance_NWC_Term__c = null;
        d.Insurance_NWC_Cost__c = null;
        d.Insurance_NWC_Acceptance__c = 'U';
        
        //NWC Calculator - HJ - 12-07-2018 - I
        d.Insurance_NWC_AWD4WD__c = null;
        d.Insurance_NWC_LuxuryCar__c = null;
        d.Insurance_NWC_TypeP__c = null;
        d.Insurance_NWC_Is_Manually_Value__c = false;
        //NWC Calculator - HJ - 12-07-2018 - F
        
        // Lelo             Insurance           2018-02-26
        d.Insurance_AIC_Type__c = cciLevel;
        d.Insurance_AIC_Retail_Price__c = cci;
        d.Insurance_AIC_Income__c = cciIncome;
        d.Insurance_AIC_Acceptance__c = cciAcceptance;
        //-
        
        //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Vehicle_Price__c = carPrice;
        
        d.Application_Fee__c = applicationFee;
        d.DOF__c = dof;
        d.PPSR__c = ppsr;
        d.Residual_Value__c = residualValue;
        
        d.Base_Rate__c = baseRate;
        d.Client_Rate__c = clientRate;
        d.Monthly_Fee__c = monthlyFee;

        //Loan Details
        if (term != null) {
            d.Term__c = Decimal.valueOf(term);
        }
        d.Loan_Facility_Type__c = loanTypeDetail;
        d.Payment__c = paymentType;
        d.Risk_Fee__c = riskFee;
        d.Category_Type__c = category;

        //Data calculated - Commission
        d.Commission_Estimation__c = estimatedCommission;
        d.Commission_Insurance_Income__c = insuranceIncome;
        d.Commission_DOF__c = dofResult;
        d.Commission_Total_GST_Exc__c = totalCommission;
        //Data calculated - Repayment
        d.Rental__c = rental;
        d.Repayment_Monthly__c = monthlyPayment;
        d.Repayment_Fortnightly__c = fortnightlyPayment;
        d.Repayment_Weekly__c = weeklyPayment;
        d.NAF__c = naf;

        //Save the record
        QuotingToolHelper.saveApplicationQuoting(d);

        //Save calculations
        QuotingCalculation.saveQuotingResults(d.Id, calResults.values());

        //Lelo                  Insurance               2017-12-04
        if (this.quoting == null) {
            this.quoting = d;
        }
        //--

        //save Insurance quote
        if (this.quote != null && this.quote.Id != null) {
            update this.quote;
        }

    }
    //-
    
    public Boolean hasQuotingInsProducts() {
        Boolean r = false;
        if (cci != null && cci > 0) {
            r = true;
        }
        return r;
    }

    public void sendPresentationStep1() {
        System.debug('sendPresentationStep1...');
        resetUserMessages();

        if (String.isBlank(this.opp.Application__c)) {
            putUserMessage(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.');
        } else {
            if (isValidPresentation()) {
                //Validate results
                if (this.hasQuotingInsProducts()) {
                    this.saveQuotingParameters();
                    this.autoCreateInsuranceQuote();
                    //Save calculations
                    QuotingCalculation.saveQuotingResults(this.quoting.Id, calResults.values());
                } else {
                    putUserMessage(ApexPages.Severity.ERROR, 'This Quote does not contain any insurance product.');
                }
            }
        }
    }

    public void sendPresentationStep2() {
        System.debug('sendPresentationStep2...');
        if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            try {

                EmailSender.sendCustomerInsurancePresentation(this.opp, 
                    InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c),
                    InsuranceQuoteUtils.getPDSDocumentTypes(this.quoting, this.quote, null));
                putUserMessage(ApexPages.Severity.CONFIRM, 'Customer Insurance Presentation has been sent it.');
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
            }
        }
    }

    public PageReference sendPresentationStep3() {
        System.debug('sendPresentationStep3...');
        if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            //Update presentation email date    
            this.quoting.Presentation_Email_Date__c = Datetime.now();
            update this.quoting;
            this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SENT;
            update this.quote;
        }
        showUserMessages();
        return null;
    }

    public void previewPresentation() {
        System.debug('previewPresentation...');
        resetUserMessages();
        if (String.isBlank(this.opp.Application__c)) {
            putUserMessage(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.');
        } else {
            //Validations
            if (isValidPresentation()) {
                //Recalculate
                calculate();
                
                //Lelo                      2016-12-22
                //Save calculation
                if (!InsuranceQuoteUtils.isQuotePresenting(this.quote, false)) {
                    saveQuotingParameters();
                    this.autoCreateInsuranceQuote();
                }
                //-

                //Validate results
                if (this.hasQuotingInsProducts()) {

                    //Save calculations
                    QuotingCalculation.saveQuotingResults(this.quoting.Id, calResults.values());
                } else {
                    putUserMessage(ApexPages.Severity.ERROR, 'This Quote does not contain any insurance product.');
                }
            }
        }
        showUserMessages();
    }

    public Boolean isValidPresentation() {
        Boolean r = true; 
        if (!hasCalculationDone()) {
            putUserMessage(ApexPages.Severity.ERROR, 'Please calculate and save a Quoting before sending a presentation.');
            r = false;
        } else if (this.cci == null || this.cci <= 0.0) {
            putUserMessage(ApexPages.Severity.ERROR, 'An LPI product should be completed and calculated to continue with this functionality');
            r = false;
        }
        return r;
    }

    public String getPresentationUrlCode() {
        return InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c);
    }

    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }

    public Application_Quoting_Result__c getSimpleResult() {
        return getCalcResult(QuotingCalculation.CALC_SIMPLE);
    }
    
    private void resetUserMessages() {
        userMgs = new Map<ApexPages.severity, List<String>>();
    }

    private void putUserMessage(ApexPages.severity msgType, String message) {
        List<String> lst = userMgs.get(msgType);
        if (lst == null) {
            lst = new List<String>();
            userMgs.put(msgType, lst);
        }
        lst.add(message);
    }

    private void showUserMessages() {
        System.debug('Showing messages...');
        if (userMgs != null) {
            System.debug('Total messages >> ' + userMgs.size());
            for (ApexPages.severity k : userMgs.keySet()) {
                for (String m : userMgs.get(k)) {
                    System.debug(k  + '|' + m);
                    ApexPages.addMessage(new ApexPages.Message(k, m));
                }
            }
        }
    }

    public Boolean getHasUserMessages() {
        Boolean r = false;
        if (userMgs != null && !userMgs.isEmpty()) {
            r  = true;
        }
        return r;
    }
    //-  Insurance    
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
    }
    public Decimal getNafCommission(String calcType, Decimal totalInsurance) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (totalInsurance != null) {
            r += totalInsurance;
        } else {
            r += this.getTotalInsuranceType(calcType);
        }
        return r;
    }

    //Lelo                      2017-07-24   
    private Decimal getTotalAmount(String calcType) {
        Decimal r = 0.0;

        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (applicationFee != null) r += applicationFee;
        // if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        r += this.getRiskFeeCalc(calcType);

        return r;
    }

    private Decimal getTotalInsuranceType(String calcType) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            //Quote Insurances
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance)) {
                if (cci != null) r += cci;    
            }
            //-
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
            if (cci != null) {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getEricLPITotalAmount(calcType, r);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r += results.premium;
                }
            }
        }
        return r;
    }

    private Decimal getTotalInsuranceIncomeType(String calcType) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance)) {
                if (cciIncome != null) r += cciIncome;    
            }
        } else if (InsuranceQuoteUtils.INS_PROD_CCI.equals(calcType)) {
            if (cciIncome != null) {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getEricLPITotalAmount(calcType, 0.0);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if(results != null){
                    r += results.commission;
                }
            }
        }
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
        param.baseRate = baseRate;
        param.paymentType = paymentType;
        param.term = term;
        param.dof = dof;
        param.monthlyFee = monthlyFee;
        param.residualValue = residualValue;
        param.nafCommission = this.getNafCommission(quotingType);

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

        //Protected
        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
        param.nafCommission = this.getNafCommission(quotingType);
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

    }

    //Lelo                              2017-07-25
    private void resetCalculationResult() {

        estimatedCommission = 0.0;
        dofResult = 0.0;
        insuranceIncome = 0.0;
        totalCommission = 0.0;
        totalCommissionGst = 0.0;

        naf = 0.0;
        rental = 0.0;
        monthlyPayment = 0.0;
        fortnightlyPayment = 0.0;
        weeklyPayment = 0.0;

        calResults = new Map<String, Application_Quoting_Result__c>();
    }

    private Application_Quoting_Result__c getCalcResult(String calcType) {
        Application_Quoting_Result__c r = null;
        if (this.calResults != null) {
            r = this.calResults.get(calcType);
        }
        return r;
    }

    public Application_Quoting_Result__c getProtectecResult() {
        return getCalcResult(QuotingCalculation.CALC_PROTECTED);
    }
    //-   

    public void acceptQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (cci == null || cci == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The CCI - AIC/Eric Retail Price cannot be zero, please check the Retail Price.'));       
        } else if (String.isBlank(cciLevel)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The CCI - AIC/Eric Cover option should be selected.')); 
        }else {
            if ('A'.equals(cciAcceptance)) {
                cciAcceptance = 'U';    
            } else {
                cciAcceptance = 'A';    
            }
        }
        this.riskFeeCalc();
    }
    
    public void declineQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(cciAcceptance)) {
            cciAcceptance = 'U';    
        } else {
            cciAcceptance = 'D';    
        }
        this.riskFeeCalc();
    }

    //-
    public Boolean getHasCustomerEmailSent() {
        Boolean r = false;
        if (this.quoting != null && this.quoting.Presentation_Email_Date__c != null) {
            r = true;
        }
        return r;
    }

    public String getCustomerPresentationStatusStyle() {
        String r = 'presentationSent';
        if (this.quoting != null && this.quoting.Presentation_Email_Date__c != null && this.quote != null) {
            if (InsuranceQuoteUtils.CUSCHOICE_DECIDING.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_DECLARING.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE.equals(this.quote.Customer_Choice_Status__c) ||
                InsuranceQuoteUtils.CUSCHOICE_FILLINFO.equals(this.quote.Customer_Choice_Status__c)) {
                r = 'presentationProcess';
            } else if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
                r = 'presentationFinished';
            }
        }
        return r;
    }

    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 01/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        for (String value : cciLevels) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        System.debug('ericLPICalculate...');
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = cciLevel;
        parameters.term = MATH.round(this.term/12);
        parameters.initialAmount = getRealTimeNAFCalc(QuotingCalculation.CALC_QUOTING);
        if ('A'.equals(cciAcceptance) && cci != null)  {
            parameters.initialAmount -= cci;
        }
        System.debug('LPI param: ' + JSON.serializePretty(parameters));
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        System.debug('LPI results: ' + JSON.serializePretty(results));
        if(results != null){
            this.cci = results.premium;
            this.cciIncome = results.commission;
        }else{
            this.cci = 0.00;
            this.cciIncome = 0.00;
        } 
    }

    private Decimal getEricLPITotalAmount(String calcType, Decimal totalInsurance) {
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (applicationFee != null) r += applicationFee;
        // if (dof != null) r += dof;
        if (ppsr != null) r += ppsr;
        System.debug('getEricLPITotalAmount 1|' + r + '|' + totalInsurance);
        // r += this.getRiskFeeCalc(calcType, totalInsurance);
        r += this.riskFee;
        System.debug('getEricLPITotalAmount 2|' + r + '|' + totalInsurance);
        r += totalInsurance;
        return r;
    }

    public List <SelectOption> getLoanTypes() {
        System.debug('getLoanTypes..... ' + this.productLoanType);
        return new List <SelectOption>{
            new SelectOption('Gold','Gold')
        };
    }

    public Decimal getTermYears() {
        if (term == null) return 0;
        return term/12;
    }

    public Boolean insuranceProductSelected() {
        Boolean r = true;
        // Lelo                 2018-08-16 
        if (!'Consumer Loan'.equals(this.productLoanType) && this.quoting.App_Insurance_Quote__c == null) {
            return r;
        }
        // Lelo                 2018-08-16 
        // Accepted or declined validation
        if (this.cci > 0 && (String.isBlank(this.cciAcceptance) || 'U'.equals(this.cciAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Repayment cover (Loan Protection) should be Accepted or Declined.'));
            r = false;
        }
        return r;
    }

    public void autoCreateInsuranceQuote() {
        if(this.quote.Id == null){
            this.quote = InsuranceQuoteUtils.createDefaultInsuranceQuote(this.Opp, this.quoting);
            insert this.quote;
            this.quoting.App_Insurance_Quote__c = this.quote.Id;
            update this.quoting;
            InsuranceQuoteUtils.createDefaultMainDriver(this.Opp, this.quote);
        }
    }

    public List <FinanceOneRates__c> getFinanceOneConsumerRates() {
        List <FinanceOneRates__c> r = new List <FinanceOneRates__c>();
        for (FinanceOneRates__c a: this.financeOneRates) {
            if ('Personal Loan'.equals(a.Category__c)) {
                r.add(a);
            }
        }
        return r;
    }

    public List<Insurance_Failure_Reason__c> getInsuranceFailureReasons() {
        List<Insurance_Failure_Reason__c> r = new List<Insurance_Failure_Reason__c>();
        if (this.quote != null && this.quote.Id != null) {
            return InsuranceQuoteUtils.getInsuranceFailureReasons(this.quote.Id);
        }
        return r;
    }
    
}