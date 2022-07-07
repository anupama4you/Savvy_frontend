public class FinanceOneCommExtension extends QuotingExtension {
    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'Finance_One_Comm';
    // finance calculator input
    public Decimal riskFee {get;set;}
    public Decimal riskFeeTotal {get;set;}
    public String loanTypeDetail {get;set;}
    public String propertyOwner {get;set;}

    // rates references
    public List <FinanceOneRates__c> financeOneRates {get;set;}
    public List <FinanceOneRates__c> financeOneRatesCommercial {get;set;}
    Map <String,FinanceOneRates__c> financeOneRatesMap {get;set;}
    
    // addtional loan information
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Finance One Commercial';
    //-

    // Lelo                 2020-06-29
    public FinanceOneDTOs.IndividualApplication dto {get;set;}  
    public Boolean submitRequest {set; get;}
    public String accountIDFinanceOne {set; get;}
    public String dateFinanceOne {set; get;}
    public String apiUser {get;set;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public Decimal brokeragePercentage {get;set;}

    private static Set<String> extraFields = new Set<String>(
      new List<String>{
        'Application_AssetDetail__c',
        'Application_AssetDetail__r.Year__c'
      }
    );

    public FinanceOneCommExtension (ApexPages.StandardController controller) {
        super(controller, extraFields);
        usersAPIOptions = getusersAPIOptions();
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%Finance_One%'];
        application();
        
        financeOneRatesMap = FinanceOneRates__c.getAll();
        System.debug('The map value: ' + financeOneRatesMap);
        financeOneRates = financeOneRatesMap.values();

        financeOneRatesCommercial = new List <FinanceOneRates__c>();
        for(FinanceOneRates__c f: financeOneRates){
          if('Commercial'.equals(f.Category__c)){
            financeOneRatesCommercial.add(f);
          }
        }
        productLoanTypes = QuotingToolHelper.getLoanProductOptionsCommercial();
        
        productGoodsTypes = new List <SelectOption> ();
        //productGoodsTypes.add(new SelectOption ('', '--None--'));
        productGoodsTypes.add(new SelectOption ('Car', 'Car'));
        productGoodsTypes.add(new SelectOption ('Motorbike', 'Motorbike'));
        productGoodsTypes.add(new SelectOption ('Boat', 'Boat'));
        productGoodsTypes.add(new SelectOption ('Caravan', 'Caravan'));
        productGoodsTypes.add(new SelectOption ('Truck', 'Truck'));
        productGoodsTypes.add(new SelectOption ('Equipment', 'Equipment'));
        
        this.quotingName = LENDER_QUOTING;
        brokeragePercentage = 8;
        
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
                    this.productGoodsType = lender.productGoodsType;
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
    
    public void updateApplicationFeeCalc () {
        /*
        if ('Economy'.equals(this.loanTypeDetail)) {
            applicationFeeCalc();       
        }
        */
    }
    
    public void applicationFeeCalc() {
        
        netDepositCalc();
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        System.debug(param);
        param.productLoanType = this.productLoanType;
        param.loanTypeDetail = this.loanTypeDetail;
        param.totalAmount = 0;
        if (this.carPrice != null) param.totalAmount += this.carPrice;
        param.totalAmount -= this.netDeposit;
        // if (this.applicationFee != null) {
        //     param.totalAmount -= this.applicationFee;
        // }
        applicationFee = QuotingCalculation.getFinanceOneApplicationFee(param);
        //if (loanTypeDetail == 'E-Motors') {
        //    applicationFee = netDeposit * 0.2;
        //    applicationFee = applicationFee.setScale(2);
        //} else if ('Business Xpress'.equals(loanTypeDetail)) {
        //    applicationFee = 695.00;
        //} else {
        //    applicationFee = 595.00;
        //}
    } // end of function
    
    public void dofCalc () {
        
        dofCalc(QuotingCalculation.CALC_QUOTING);
        //netDepositCalc();
        //decimal totalInsurance = getTotalInsurante();
        //decimal totalAmount = carPrice - netDeposit + totalInsurance;
        //if (loanTypeDetail == 'E-Motors') {
        //    dof = 330.00;
        //} else {
        //    if (totalAmount >= 5000 && totalAmount <= 14000) {
        //        dof = 990.00;
        //    } else if (totalAmount > 14000) {
        //        dof = 1100.00;
        //    }
        //}
    } // end of function
    private void dofCalc (String calcType) {
        this.dofCalc(calcType, true);
    }

    private void dofCalc (String calcType, Boolean fullCalc) {
        netDepositCalc();
        decimal totalInsurance = this.getTotalInsuranceType(calcType);
        decimal totalAmount = 0;
        if (this.carPrice != null) totalAmount += this.carPrice;
        totalAmount = totalAmount - this.netDeposit + totalInsurance;
        Decimal r = 0.0;
        /*
        if (this.loanTypeDetail == 'Economy') {
            r = 550.0;
            if (totalAmount >= 6000 && totalAmount < 7000) {
                r = 660.0;
            } else if (totalAmount >= 7000 && totalAmount < 8000) {
                r = 770.0;
            } else if (totalAmount >= 8000) {
                r = 880.0;
            }
        } else {
            */
            if (totalAmount >= 8000 && totalAmount <= 14000) {
              r = (totalAmount * 0.10).setScale(2);
                
              if(r > 990){
                r = 990.00;
              }
            } else if (totalAmount > 14000) {
                r = 1100.00;
            }
        //}
        if (fullCalc) this.dof = r;
        this.maxDof = r;
        System.debug(this.loanTypeDetail + '|' + totalAmount.format() + '|' + r.format() + '|max:' + this.maxDof + '|dof:' + this.dof);
    } // end of function

    public void baseRateCalc () {
        
        Decimal originalRate = 0;
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        System.debug(param);
        param.productLoanType = this.productLoanType;
        param.loanTypeDetail = this.loanTypeDetail;
        this.baseRate = QuotingCalculation.getBaseRate(param);
        this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
        
        //clientRate = this.baseRate + lenderSettings.Max_Brokerage__c - brokeragePercentage;
        clientRate = this.baseRate;
        if(brokeragePercentage > 4){
          clientRate = this.baseRate + brokeragePercentage - 4;
        }
        System.debug('baseRateCalc: base rate: ' + this.baseRate + '|Max Rate: ' + this.maxRate + '|' + this.productLoanType + '|' + this.loanTypeDetail);
    } //end of funcion
    
    public void riskFeeCalc () {
      netDepositCalc();
      riskFeeTotal = this.getRiskFeeCalc(QuotingCalculation.CALC_QUOTING);
    } //end of funcion    
    
    public Decimal getRiskFeeCalc(String calcType) {
        return getRiskFeeCalc(calcType, null);
    }
    
    public Decimal getRiskFeeCalc(String calcType, Decimal totalInsurance) {
        Decimal r = 0.0;
        Decimal nc = this.getNafCommission(calcType, totalInsurance);
        nc += this.getCommission();
        if ('Silver'.equals(loanTypeDetail)) {
          if ((nc + 995.0) <= 12000) {
            r = 995.0;
          } else if ((nc + 1495.00) > 12000 && (nc + 1495.00) <= 20000) {
            r = 1495.00;
          } else if ((nc + 1495.00) > 20000) {
            r = 1995.00;
          }
        }
        return r.setScale(2);
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

        if (brokeragePercentage == null || brokeragePercentage == 0.0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be Zero.'));
          r = false;
        }

        if (brokeragePercentage < 0.0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage should not be below Zero.'));
          r = false;
        }

        if (brokeragePercentage > lenderSettings.Max_Brokerage__c) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Brokerage should not be greater than $'+lenderSettings.Max_Brokerage__c+'.'));
          r = false;
        }

        System.debug('2) ' + r);
        if (baseRate == null || baseRate == 0.0 || baseRate < 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        System.debug('3) ' + r);
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        }
        System.debug('4) ' + r);
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        System.debug(param);
        param.productLoanType = this.productLoanType;
        param.loanTypeDetail = this.loanTypeDetail;
        System.debug(this.productLoanType);
        System.debug(this.loanTypeDetail);
        FinanceOneRates__c rate = QuotingCalculation.getFinanceOneRates(param);
        System.debug('rate: ' + rate);
        if (rate != null) {
            String a = rate.Category__c + ' - ' + rate.Product__c;
            System.debug('realtimeNaf: ' + this.realtimeNaf);
            Decimal maxAmount = rate.Maximun_Amount__c;
            if (!'Consumer Loan'.equals(this.productLoanType) &&
             ('Gold'.equals(rate.Product__c) || 
             'Platinum'.equals(rate.Product__c)) 
             && !'Y'.equals(propertyOwner)) {
              maxAmount = 75000.0;
              if (realtimeNaf > maxAmount) {
                ApexPages.addMessage(new ApexPages.Message(
                  ApexPages.Severity.WARNING,
                  'Warning: Only property owners can borrow $75k-$150K'
                ));
              }
            }
            //NAF
            /*
            if ('Economy'.equals(rate.Product__c)) {
                Decimal price = this.carPrice > 0? this.carprice : 0.00;
                price -= this.netDeposit;
                if (price < rate.Minimum_Amount__c || price > rate.Maximun_Amount__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': Vehicle price should be between $' + rate.Minimum_Amount__c.format() + ' and $' + rate.Maximun_Amount__c.format() + '.'));
                    r = false;
                } 
            } else if (this.realtimeNaf < rate.Minimum_Amount__c || this.realtimeNaf > maxAmount) {
                */
            if (this.realtimeNaf < rate.Minimum_Amount__c || this.realtimeNaf > maxAmount) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,a + ': NAF should be between $' + rate.Minimum_Amount__c.format() + ' and $' + maxAmount.format() + '.'));
                // r = false;
            }
            System.debug('clientRate: ' + this.clientRate);
            //client rate
            /*
            if (this.clientRate > 0) {
                System.debug(this.clientRate);
                System.debug(rate.Base_Rate__c);
                if (this.clientRate < rate.Base_Rate__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': Client rate is below the base rate.'));
                    r = false;
                } else if (this.clientRate > rate.Max_Rate__c) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': client rate larger than ' + rate.Max_Rate__c + '%.'));
                    r = false;
                }
            }
            */
            System.debug('term: ' + this.term);
            //Term
            if (this.term < 36 || this.term > rate.Max_Term__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,a + ': term should be between 36 months to ' + rate.Max_Term__c + ' months.'));
                r = false;
            } else if (term > 60) {
              if (Opp.Application_AssetDetail__c == null) {
                ApexPages.addMessage(
                  new ApexPages.Message(ApexPages.Severity.WARNING,
                  'Please save asset details and reload this page'
                ));
              } else {
                Decimal endOfTerm = Date.today().year() - 
                  Opp.Application_AssetDetail__r.Year__c + 
                  (term > 0? term/12 : 0);
                if (endOfTerm > 15) {
                  ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Warning: 7 year term - cars cannot be older than 15yrs at EOT'
                  ));
                }  
              }
            }
        }
        System.debug('5) ' + r);
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        System.debug('6) ' + r);
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        // if ('Consumer Loan'.equals(productLoanType)) {

        if('Silver'.equals(loanTypeDetail)){    
          if(riskFee > riskFeeTotal){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Greater than $1995 - Max risk fee exceeded Refer to Finance one'));
          }else if(riskFee > 0 && riskFee < 995){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Less than $995 - Below minimum risk fee - refer to Finance one'));
          }else if(riskFee < riskFeeTotal && riskFee != 0){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk fee change - refer to Finance one'));
          }
        }

        if('Gold'.equals(loanTypeDetail) || 'Platinum'.equals(loanTypeDetail)){
          if (riskFee != 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Risk Fee should be $0.'));
          }
        }

        if (riskFee < 0.0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Risk Fee should not be below Zero.'));
          r = false;
        }
          
          /*
          if(rate != null && !'Economy'.equals(rate.Product__c) && (riskFee == 0 || riskFee == null)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The risk fee must be greater than zero'));
            r = false;
          }
          */
        // }
        
        if(String.isBlank(productGoodsSubType) && 
          getProductGoodsSubTypes().size() > 1){
            ApexPages.addMessage(new ApexPages.Message(
              ApexPages.Severity.ERROR, 'Please select Goods SubType'));
          r = false;
        }
        
        return r;
    }

  public void calculate () {
    //applicationFeeCalc();
    this.dofCalc(QuotingCalculation.CALC_QUOTING, false);
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
      this.resetQuote();

      this.loanType = loanTypeOptions.get(0).getValue();
      this.productLoanType = productLoanTypes.get(0).getValue();
      this.productGoodsType = productGoodsTypes.get(0).getValue();
      
      this.applicationFee = lenderSettings.Application_Fee__c;
      this.dof = lenderSettings.DOF__c;
      this.ppsr = lenderSettings.PPSR__c;
      this.monthlyFee = lenderSettings.Monthly_Fee__c;

      this.riskFee = null;
      this.riskFeeTotal = 0.00;
      netDepositCalc();

      this.term = 60;
      this.paymentType = 'Arrears';   
      
      this.loanTypeDetail = 'Gold';
      this.propertyOwner = null;

      this.resetInsuranceProducts(false);

      this.dofCalc();
      this.riskFeeCalc();
      this.resetCalculationResult(); //Lelo       2017-07-25
      this.baseRateCalc();
    } // end of function
    
    private PageReference savePdf (String prefixName) {
        PageReference calcPdf = this.createPdf();
        // pass universal variables
        calcPdf.getParameters().put('lender', 'FINANCE ONE COMMERCIAL CALCULATION');
        
        // Lender parameters
        calcPdf.getParameters().put('loanTypeDetail', loanTypeDetail);
        calcPdf.getParameters().put('riskFee', String.valueOf(riskFee));
        calcPdf.getParameters().put('isFinanceOne', 'true');
        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(brokeragePercentage));
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
         /*   
        if (productLoanType == 'Consumer Loan') {
            updateProduct.Loan_Purpose__c = 'Personal Use';
        } else {
            */
            updateProduct.Loan_Purpose__c = 'Business Use';
        //}
        
        updateProduct.Lender__c = 'Finance One';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = loanTypeDetail;

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
        updateProduct.Equalisation_Fee_PPSR__c += this.riskFee > 0? this.riskFee : 0.00;
        
        if (monthlyPayment == null || monthlyPayment == 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Payment is not updated as the calculator does not contain relevant info.'));
        }
        if (estimatedCommission == null || estimatedCommission == 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Estimated Commission is not updated as the calculator does not contain relevant info.'));
        }
        
        if (applicationFee == null || applicationFee == 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Application Fee is not updated as the calculator does not contain relevant info.'));
        }
        
        if (ppsr == null || ppsr == 0) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'PPSR is not updated as the calculator does not contain relevant info.'));
        }

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
            residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
              this.loadQuotingInsuranceData();
              this.loadQuotingData();
                //Specific values
                if(d.Brokerage__c != null){
                  brokeragePercentage = d.Brokerage__c;
                }
                productGoodsType = d.Goods_type__c;
                productGoodsSubType = d.Goods_sub_type__c;                
                if (d.Client_Rate__c != null) {
                    clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                paymentType = d.Payment__c;
                
                loanTypeDetail = d.Loan_Facility_Type__c;
                if (String.isNotBlank(d.Customer_Profile__c)) {
                    propertyOwner = d.Customer_Profile__c;
                }
                
                riskFee = d.Risk_Fee__c;
                riskFeeCalc();
                baseRateCalc();

            }
        }
        this.dofCalc(QuotingCalculation.CALC_QUOTING, false);
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
      d.Goods_type__c = productGoodsType;
      d.Goods_sub_type__c = productGoodsSubType;
      d.Brokerage__c = brokeragePercentage;
      //Loan Details
      d.Loan_Facility_Type__c = loanTypeDetail;
      d.Payment__c = paymentType;
      d.Risk_Fee__c = riskFee;
      d.Customer_Profile__c = propertyOwner;

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
        /* if (totalInsurance != null) {
            r += totalInsurance;
        } else {
            r += this.getTotalInsuranceType(calcType);
        } */
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
        r += getCommission();
        return r;
    }

    private void calculateRepayments() {

        //Reset results
        this.resetCalculationResult();
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        System.debug(param);
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
        param.brokeragePer = brokeragePercentage;
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome + '|' + param.nafCommission + '|' + param.getNAF());
System.debug(param.dof);
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
        //if (includeInsurance) {
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

        //}
        //-
    }
    
    public void onChangeLoanTypeDetail() {
        
        if('Silver'.equals(loanTypeDetail)){
          riskFee = 1995;
        }else{
          riskFee = 0;
        }
        /*
        if ('Economy'.equals(this.loanTypeDetail)) {
            QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
            param.productLoanType = this.productLoanType;
            param.loanTypeDetail = this.loanTypeDetail;
            FinanceOneRates__c rate = QuotingCalculation.getFinanceOneRates(param);
            if (rate != null && rate.Max_Term__c != null) this.term = rate.Max_Term__c.intValue();
            this.riskFee = 0.0;
        }
        */
        this.calculateValidation();
    }
    
    public void service(){
      //FinanceOneServices.postService();
      if (submitRequest) {
        try {
          FinanceOneRestWS.application(Opp.Id, apiUser);
        } catch (GenericException e) {
          System.debug(LoggingLevel.ERROR, e.getMessage());
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
      } else {
        /*
        if(!String.isNotBlank(productGoodsSubType)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Goods SubType')); 
        }
        */
        isValidationOk();
        if (rental == null || rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
        }
        if (!String.isNotBlank(apiUser)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Finance One API user'));
        }
      }
    }
    
    public void save(){
        submitRequest = false;
        //if(String.isNotBlank(productGoodsSubType) && isValidationOk() && String.isNotBlank(apiUser)){
        if(isValidationOk() && String.isNotBlank(apiUser)){
                        //Jesus Mora 2020-10-01 start
            
            calculate();
            
            // validate calculation
            if (rental > 0) {
                //saveQuotingParameters();
                saveProduct(fileGlobalPrefix);
                submitRequest = true;
            }
        }
    }
    
    public List<SelectOption> getProductGoodsSubTypes(){
        
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        List<Product_Goods_Subtypes__c> subtypes;
        
        if('Car'.equals(productGoodsType)){
            subtypes = goodsSubtypes('Motor Vehicle');
        }
        
        if('Motorbike'.equals(productGoodsType)){
            subtypes = goodsSubtypes('Motorbike');
        }
        
        if('Boat'.equals(productGoodsType)){
            subtypes = goodsSubtypes('Watercraft');
            
        }
        
        if('Caravan'.equals(productGoodsType)){
            subtypes = goodsSubtypes('Recreational Asset');
        }
        
        if(subtypes != null){
            for (Product_Goods_Subtypes__c g: subtypes){
                r.add(new SelectOption (g.Value__c, g.Description__c));
            }
        }
        
        return r;
    }
    
    public List<Product_Goods_Subtypes__c> goodsSubtypes(String type){
        List<Product_Goods_Subtypes__c> goodsSubtypes = [select Description__c, Type__c, Value__c from Product_Goods_Subtypes__c where Type__c =: type];
        return goodsSubtypes;
    }
    
    public void application(){
        FinanceOneApp__c f;
        LenderAPIResponse__c l;
        
        List<FinanceOneApp__c> r = [SELECT Account_ID__c, CreatedDate FROM 
          FinanceOneApp__c WHERE Opportunity__c =: Opp.Id AND Account_ID__c != 
            null ORDER BY CreatedDate DESC];
        List<LenderAPIResponse__c> r2 = [SELECT Application_ID__c, CreatedDate 
          FROM LenderAPIResponse__c WHERE Opportunity__c =: Opp.Id AND 
            Application_ID__c != null AND Quoting_Source__c =: 
              LENDER_QUOTING ORDER BY CreatedDate DESC];
        
		if(!r.isEmpty() && r2.isEmpty()){
          f = r.get(0);
          accountIDFinanceOne = f.Account_ID__c;
          dateFinanceOne = f.CreatedDate.format('dd/MM/yyyy HH:mm:ss a');
        }else if(!r2.isEmpty()){
		  l = r2.get(0);
          accountIDFinanceOne = l.Application_ID__c;
          dateFinanceOne = l.CreatedDate.format('dd/MM/yyyy HH:mm:ss a');
        }
    }
    
    public List<SelectOption> getusersAPIOptions(){
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('', '--None--'));
        // List<Lender_Login__c> listL = [select Owner.Name, User_Name__c From Lender_Login__c where Lender__c = 'Finance 1' And Owner.isActive = true order by Owner.Name];
        List<Lender_Login__c> listL = APIServiceManager.listLenderLogins('Finance 1');
        
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

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }

    public List <SelectOption> getLoanTypes() {
      System.debug('getLoanTypes..... ' + this.productLoanType);
      if (String.isBlank(productLoanType)) {
        return null;
      //} else if ('Consumer Loan'.equals(productLoanType)) {
        //return QuotingToolHelper.getFinanceOneConsumerOptions();
      } else {
        return QuotingToolHelper.getFinanceOneCommercialOptions();
      }
    }

  public Decimal getCommission() {
    return brokeragePercentage / 100 * getNafCommission(
      QuotingCalculation.CALC_QUOTING) * 1.1;
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