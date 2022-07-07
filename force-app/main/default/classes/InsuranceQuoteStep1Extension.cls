public with sharing class InsuranceQuoteStep1Extension {

    private final Custom_Opportunity__c o;
    public Application_Quoting__c quoting {set;get;}
    public Application_Quoting__c quotingSel {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}

    private Id previousQuoteId = null;
    public Boolean displayMVProduct {set;get;}
    public Boolean displayWarrProduct {set;get;}
    public Boolean displayGAPProduct {set;get;}
    public Boolean displayLTIProduct {set;get;}
    public Boolean displayRTIProduct {set;get;}
    //Jesus Mora 2020-03-26 start
    public Boolean displayLPIProduct {set;get;}
    //Jesus Mora 2020-03-26 end
    public InsuranceQuoteStep1Extension(ApexPages.StandardController ctrl) {
        this.o = (Custom_Opportunity__c)ctrl.getRecord();
        this.quoting = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
        this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuotePrepared(this.o.Application__c);
        this.displayMVProduct = true;
        this.displayWarrProduct = true;
        this.displayGAPProduct = true;
        this.displayLTIProduct = false;
        this.displayLPIProduct = false;
        if(InsuranceQuoteUtils.validateLendersNotLPIorLTI(this.quoting.Name)){
            this.displayLTIProduct = true;
            //Jesus Mora 2020-03-26 start
            this.displayLPIProduct = true;
            //Jesus Mora 2020-03-26 end
        }
        this.displayRTIProduct = false;
        System.debug('Current quoting Quote Id >> ' + this.quoting.App_Insurance_Quote__c);
        //if (this.quote == null) {
        //    System.debug('Searching a quote...');
        //    if (this.quoting.App_Insurance_Quote__c != null) {
        //        this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoting.App_Insurance_Quote__c);
        //    } else {
        //        //this.quote = InsuranceQuoteUtils.getMostRecentApplicationInsuranceQuote(this.o.Application__c);
        //    }
        //}
        if (this.quote == null) {
            System.debug('Creating a new quote object...');
            this.quote = new Application_InsuranceQuote__c();
            this.quote.Application__c = this.o.Application__c;
            this.quote.Name = this.o.Name;
        } else {
            this.quote.Quote_Id__c = null;
            //if ('Q'.equals(this.quote.Status__c) || 'FA'.equals(this.quote.Status__c) || 'P'.equals(this.quote.Status__c) || 'Fail'.equals(this.quote.Status__c)) {
            //    System.debug('Reseting the current quote object...');
            //    this.previousQuoteId = this.quote.Id;
            //    this.quote.Id = null;
            //    this.quote.Name = this.o.Name;
            //    this.quote.Quotation_Number__c = null;
            //    this.resetBuyPolicyFields();
            //}
        }
        //Pre-fill fields
        this.quote.Financier_Name__c = this.quoting.Name;
        //Acceptance
        this.resetProducts();
        //Status
        this.quote.Status__c = 'S1';

        if ('Pepper Leisure'.equals(this.quoting.Name) || 
            'Pepper Summer'.equals(this.quoting.Name) || 
            this.quoting.Name.containsIgnoreCase('Yamaha') ) {
            this.displayMVProduct = false;
            this.displayWarrProduct = false;
            this.quote.Motor_Vehicle__c = null;
            this.quote.Warranty_Insurance__c = null;
        } else if (InsuranceQuoteUtils.isLiberty(this.quoting)) {
            this.displayGAPProduct = false;
            this.displayLTIProduct = false;
            this.quote.LTI_BRI__c = null;
            //Jesus Mora 2020-03-26 start
            this.displayLPIProduct = false;
            this.quote.LPI__c = null;
            //Jesus Mora 2020-03-26 end
            this.displayRTIProduct = false;
            this.quote.GAP__c = null;
            this.quote.Total_assist_RTI__c = null;
        } else if (EsandaCalculatorExtension.LENDER_QUOTING.equals(this.quoting.Name)) {
            this.displayGAPProduct = false;
            this.displayRTIProduct = false;
            this.displayWarrProduct = false;
            this.quote.GAP__c = null;
            this.quote.Total_assist_RTI__c = null;
            this.quote.Warranty_Insurance__c = null;
        } else if (this.quoting.Name != NULL && this.quoting.Name.startsWith('AFS ')) {
            this.displayGAPProduct = false;
            this.displayRTIProduct = false;
            this.displayLTIProduct = false;
            this.quote.LTI_BRI__c = null;
            //Jesus Mora 2020-03-26 start
            this.displayLPIProduct = false;
            this.quote.LPI__c = null;
            //Jesus Mora 2020-03-26 end
            this.displayWarrProduct = false;
            this.quote.GAP__c = null;
            this.quote.Total_assist_RTI__c = null;
            this.quote.Warranty_Insurance__c = null;
        } else if('BOQ'.equals(this.quoting.Name)){
            this.displayLTIProduct = false;
            //Jesus Mora 2020-03-26 start
            this.displayLPIProduct = false;
            //Jesus Mora 2020-03-26 end
            this.displayMVProduct = false;
            this.displayWarrProduct = false;
            this.quote.Motor_Vehicle__c = null;
            this.quote.Is_Vehicle_MV_Commercial__c = null;
            this.quote.Is_Vehicle_Modified__c = null;
            this.quote.Warranty_Insurance__c = null;
        } else if('Wisr VL'.equals(this.quoting.Name)){
          this.displayGAPProduct = false;
          this.displayRTIProduct = false;
          this.displayLTIProduct = false;
          this.quote.LTI_BRI__c = null;
          this.displayLPIProduct = false;
          this.quote.LPI__c = null;
          this.quote.GAP__c = null;
          this.quote.Total_assist_RTI__c = null;
        } else if('CarStart'.equals(this.quoting.Name)){
          this.displayGAPProduct = false;
          this.displayRTIProduct = false;
          this.displayLTIProduct = false;
          this.quote.LTI_BRI__c = null;
          this.displayLPIProduct = false;
          this.quote.LPI__c = null;
          this.quote.GAP__c = null;
          this.quote.Total_assist_RTI__c = null;    
        }
        if (!'Car'.equals(o.Application_AssetDetail__r.Type__c)) {
          this.displayMVProduct = false;
        }
        if (!getIsGAPRequired()) {
          this.displayGAPProduct = false;
        }
      this.preloadProductSelection();
    }

    private Boolean isValidationOK() {
        Boolean r = true;
        r = hasInitialValidationOK();
        if (r) {
          System.debug(displayMVProduct +'|'+ displayGAPProduct +'|'+ displayLTIProduct +'|'+ displayLPIProduct +'|'+ displayWarrProduct);
          Boolean  checkForSelection = (displayMVProduct || displayGAPProduct || displayLTIProduct || displayLPIProduct);
          if (checkForSelection && 
              String.isBlank(this.quote.Gap__c) &&
              String.isBlank(this.quote.LTI_BRI__c) &&
              //Jesus Mora 2020-03-26 start
              String.isBlank(this.quote.LPI__c) &&
              //Jesus Mora 2020-03-26 end
              String.isBlank(this.quote.Motor_Vehicle__c)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one insurance product.'));
              r = false;
          } else {
              //Jesus Mora 2020-03-26 start
              if(!getDisabledLPI()){
                  if(displayLTIProduct){
                      if (!String.isBlank(this.quote.LTI_BRI__c) && !String.isBlank(this.quote.LPI__c)) {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select only a LTI/BRI or LPI product.'));
                          r = false;  
                      }
                      if (String.isBlank(this.quote.LTI_BRI__c) && String.isBlank(this.quote.LPI__c)) {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a LTI/BRI or LPI product.'));
                          r = false;  
                      }
                  }
              }
              //Jesus Mora 2020-03-26 end
              if (getIsRTIRequired()) {
                  if (String.isBlank(this.quote.Total_assist_RTI__c)) {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a RTI insurance product.'));
                      r = false;
                  }
              } else if (getIsGAPRequired() && displayGAPProduct)  {
                  if (String.isBlank(this.quote.Gap__c)) {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a GAP insurance product.'));
                      r = false;
                  }
              }
              //Check for Comprehensive product
              if (this.displayMVProduct) {
                  //check if asset type is a car
                  if ('Car'.equals(o.Application_AssetDetail__r.Type__c) && String.isBlank(this.quote.Motor_Vehicle__c)) {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Motor Vehicle insurance product.'));
                      r = false;
                  }
              }

              //if (String.isBlank(this.quote.LTI_BRI__c)) {
              //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a LTI insurance product.'));
              //    r = false;
              //}
              //if (String.isBlank(this.quote.Warranty_Insurance__c)) {
              //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Warranty insurance product.'));
              //    r = false;
              //}   
          }
          if (this.quote.Vehicle_Been_Registered__c) {
              if (String.isBlank(this.o.Application_AssetDetail__r.VIN__c) &&
                  String.isBlank(this.o.Application_AssetDetail__r.Rego__c)) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill a VIN or Registration Number.'));
                  r = false;       
              } else if (String.isNotBlank(this.o.Application_AssetDetail__r.Rego__c) && 
                          String.isBlank(this.o.Application_AssetDetail__r.Rego_State__c)) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a State for Registration Number.'));
                  r = false;       
              }
          }
        }
        return r;
    }

    public PageReference nextAction() {
        System.debug('Quote Id >> ' + this.quote.Id);
        if (!isValidationOK()) {
            return null;
        }
        //Save data
        update this.o;
        update this.o.Application_AssetDetail__r;
        System.debug('Motor_Cover_Term__c >> ' + this.quote.Motor_Cover_Term__c);
        upsert this.quote;
        System.debug('Current Id >> ' + this.quote.Id + ' Previous Id >> ' + this.previousQuoteId);
        //Associate Main Driver
        if (String.isNotBlank(this.previousQuoteId)) {
            InsuranceQuoteUtils.associateMainDriverToQuote(this.previousQuoteId, this.quote.Id);
            System.debug('Main driver associated');
        }

        //Redirect
        System.debug('nextAction...');
        PageReference n = Page.InsuranceQuoteStep2;
        n.getParameters().put('id', this.o.Id);
        return n;
    }
    
    //private void resetBuyPolicyFields() {
    //    this.quote.Motor_Cover_Term__c = null;

    //    this.quote.Cover_Start_Date__c = null;
    //    this.quote.Vehicle_Under_Warranty__c = null;
    //    this.quote.Vehicle_Warranty_End_Date__c = null;
    //    this.quote.Vehicle_Purchase_Date__c = null;
    //    this.quote.Customer_Choice__c = null;
    //    this.quote.Customer_Choice_Date__c = null;
    //    this.quote.Customer_Choice_Details__c = null;
    //    this.quote.Customer_Choice_Status__c = null;

    //}

    private void resetProducts() {
        this.quote.MV_Acceptance__c = 'U';
        this.quote.GAP_Acceptance__c = 'U';
        if('Macquarie Consumer'.equals(this.quoting.Name) || 'Macquarie Commercial'.equals(this.quoting.Name)){
            this.quote.LTI_Acceptance__c = 'U';
            this.quote.LTI_Payment_Method__c = null;
            this.quote.LTI_Payment_Detail__c = null;
            //Jesus Mora 2020-03-26 start
            this.quote.LPI_Acceptance__c = 'U';
            this.quote.LPI_Payment_Method__c = null;
            this.quote.LPI_Payment_Detail__c = null;
            //Jesus Mora 2020-03-26 end
        }
        this.quote.TAS_Acceptance__c = 'U';
        this.quote.WRR_Acceptance__c = 'U';

        this.quote.MV_Payment_Method__c = null;
        this.quote.GAP_Payment_Method__c = null;
        this.quote.TAS_Payment_Method__c = null;
        this.quote.WRR_Payment_Method__c = null;

        this.quote.MV_Payment_Detail__c = null;
        this.quote.GAP_Payment_Detail__c = null;
        this.quote.TAS_Payment_Detail__c = null;
        this.quote.WRR_Payment_Detail__c = null;

        if (getIsRTIRequired()) {
            this.quote.Gap__c = null;
        } else {
            this.quote.Total_assist_RTI__c = null;
        }
        //Jesus Mora 2020-03-26 start
        if(getDisabledLPI()){
            this.quote.LPI_Acceptance__c = 'U';
            this.quote.LPI_Payment_Method__c = null;
            this.quote.LPI_Payment_Detail__c = null;
            this.quote.LPI__c = null;
        }
        //Jesus Mora 2020-03-26 end 
    }

    public PageReference goToQuotingTool() {
        return InsuranceQuoteUtils.goToQuotingTool(this.o.Id,this.quoting.Name);
    }

    public Boolean getIsRTIRequired() {
        Boolean r = false;
        if (this.quoting != null && this.displayRTIProduct &&
            this.quoting.Net_Deposit_Percentage__c >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
            r = true;
        }
        return r;
    }
    
    public Boolean getIsGAPRequired() {
        Boolean r = false;
        if (this.quoting != null &&
            this.quoting.Net_Deposit_Percentage__c < InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC) {
            r = true;
        }
        return r;
    }

    public void initialValidation() {
        hasInitialValidationOK();
    }
    private Boolean hasInitialValidationOK() {
        Boolean r = true;
        //check for an application
        if (this.o.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please link/create an application before quoting.'));
            r = false;
        } else {
            if (!'F'.equals(this.o.Application__r.Status__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please the linked application should be finished.'));
                r = false;
            }
        }
        if (this.o.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save a Asset Detail - LTV before quoting.'));
            r = false;
        }
        return r;
    }
    
    public Boolean getDisabledLPI() {
        Set<String> lender = new Set<String>();
        lender.add(MetroCalculatorExtension.LENDER_QUOTING);
        lender.add(LatitudeCalculatorExtension.LENDER_QUOTING);
        lender.add(Money3CalculatorExtension.LENDER_QUOTING);
        lender.add(FirstmacCalculatorExtension.LENDER_QUOTING);
        lender.add(GreenLightCalculatorExtension.LENDER_QUOTING);
        lender.add(FinanceOneExtension.LENDER_QUOTING);
        lender.add(ACLCalculatorExtension.LENDER_QUOTING);
        lender.add(PepperCalculatorMVExtension.LENDER_QUOTING);
        lender.add(PepperCalculatorLeisureExtension.LENDER_QUOTING);
        lender.add(PepperCommExtension.LENDER_QUOTING);
        lender.add(MacquarieConsumerExtension.LENDER_QUOTING);
        lender.add(MacquarieCommercialExtension.LENDER_QUOTING);
        lender.add(RateSetterCalculatorExtension.LENDER_QUOTING);
        lender.add(RatesetterPLExtension.LENDER_QUOTING);
        
        return !lender.contains(this.quoting.Name);
    }
    
    public void preloadProductSelection() {
      this.quotingSel = new Application_Quoting__c();
      if (this.quoting != null) {
        this.quotingSel.Insurance_MV_Options__c = this.quoting.Insurance_MV_Options__c;
        this.quotingSel.Insurance_Shortfall_Options__c = this.quoting.Insurance_Shortfall_Options__c;
        this.quotingSel.Insurance_LPI_Options__c = this.quoting.Insurance_LPI_Options__c;
        this.quotingSel.Insurance_Warranty_Options__c = this.quoting.Insurance_Warranty_Options__c;
        this.quotingSel.Insurance_Tyre_Whell_Options__c = this.quoting.Insurance_Tyre_Whell_Options__c;
      }
    }

    public PageReference saveAndNextAction() {
      // TODO - Display warning message informing that all values are going to be reset
      // TODO - implement validation, is mandatory at least select one product? ask to Phil.
      if (this.quoting.Insurance_MV_Options__c != null && !this.quoting.Insurance_MV_Options__c.equals(this.quotingSel.Insurance_MV_Options__c)) {
        // Reset MV
        this.quoting.Insurance_MV_Type__c = null;
        this.quoting.Insurance_MV_Retail_Price__c = null;
        this.quoting.Insurance_MV_Income__c = null;
        this.quoting.Insurance_MV_Acceptance__c = 'U';
      }
      if (this.quoting.Insurance_Shortfall_Options__c != null && !this.quoting.Insurance_Shortfall_Options__c.equals(this.quotingSel.Insurance_Shortfall_Options__c)) {
        // Reset Shortfall
        this.quoting.Insurance_GAP_Type__c = null;
        this.quoting.Insurance_GAP_Retail_Price__c = null;
        this.quoting.Insurance_GAP_Income__c = null;
        this.quoting.Insurance_GAP_Acceptance__c = 'U';

        this.quoting.Insurance_VEI_Type__c = null;
        this.quoting.Insurance_VEI_Retail_Price__c = null;
        this.quoting.Insurance_VEI_Income__c = null;
        this.quoting.Insurance_VEI_Acceptance__c = 'U';
      }
      if (this.quoting.Insurance_LPI_Options__c != null && !this.quoting.Insurance_LPI_Options__c.equals(this.quotingSel.Insurance_LPI_Options__c)) {
        // Reset Loan Protection
        this.quoting.Insurance_AIC_Type__c = null;
        this.quoting.Insurance_AIC_Retail_Price__c = null;
        this.quoting.Insurance_AIC_Income__c = null;
        this.quoting.Insurance_AIC_Acceptance__c = 'U';

        this.quoting.Insurance_LPI_Type__c = null;
        this.quoting.Insurance_LPI_Retail_Price__c = null;
        this.quoting.Insurance_LPI_Income__c = null;
        this.quoting.Insurance_LPI_Acceptance__c = 'U';
      }
      if (this.quoting.Insurance_Warranty_Options__c != null && !this.quoting.Insurance_Warranty_Options__c.equals(this.quotingSel.Insurance_Warranty_Options__c)) {
        // Reset Warranty
        this.quoting.Insurance_Warranty_Type__c = null;
        this.quoting.Insurance_Warranty_Retail_Price__c = null;
        this.quoting.Insurance_Warranty_Income__c = null;
        this.quoting.Insurance_Warranty_Acceptance__c = 'U';

        this.quoting.Insurance_NWC_TypeP__c = null;
        this.quoting.Insurance_NWC_Retail_Price__c = null;
        this.quoting.Insurance_NWC_Income__c = null;
        this.quoting.Insurance_NWC_Acceptance__c = 'U';
        this.quoting.Insurance_NWC_Plan__c = null;
        this.quoting.Insurance_NWC_Term__c = null;
        this.quoting.Insurance_NWC_LuxuryCar__c = null;
        this.quoting.Insurance_NWC_Engine__c = null;
        this.quoting.Insurance_NWC_Cost__c = null;
        this.quoting.Insurance_NWC_AWD4WD__c = null;
      }
      if (this.quoting.Insurance_Tyre_Whell_Options__c != null && !this.quoting.Insurance_Tyre_Whell_Options__c.equals(this.quotingSel.Insurance_Tyre_Whell_Options__c)) {
        // TODO - Reset Tyre & Whells fiedls in Application_Quoting object
        // this.quoting.Insurance_MV_Type__c = null;
        // this.quoting.Insurance_MV_Retail_Price__c = null;
        // this.quoting.Insurance_MV_Income__c = null;
        // this.quoting.Insurance_MV_Acceptance__c = 'U';
      }
      this.quoting.Insurance_MV_Options__c = this.quotingSel.Insurance_MV_Options__c;
      this.quoting.Insurance_Shortfall_Options__c = this.quotingSel.Insurance_Shortfall_Options__c;
      this.quoting.Insurance_LPI_Options__c = this.quotingSel.Insurance_LPI_Options__c;
      this.quoting.Insurance_Warranty_Options__c = this.quotingSel.Insurance_Warranty_Options__c;
      this.quoting.Insurance_Tyre_Whell_Options__c = this.quotingSel.Insurance_Tyre_Whell_Options__c;
      update this.quoting;
      return goToQuotingTool();
    }
}