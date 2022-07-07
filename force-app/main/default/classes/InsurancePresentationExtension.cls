public class InsurancePresentationExtension {
    
    private Custom_Opportunity__c o;
    
    public Application_InsuranceQuote__c quote;
    
    public String appId {set;get;}
    public String errorMessage {set;get;}
    
    public Application_Quoting__c quoting {set;get;}
    private Map<String, Application_Quoting_Result__c> resultList = new Map<String, Application_Quoting_Result__c>();
    
    private Map<String, Boolean> singleMap = new Map<String, Boolean>();
    
    public Boolean hasGapRtiProductDeclined {set;get;}
    public Boolean hasLpiProductDeclined {set;get;}
    public Boolean hasWarrantyProductDeclined {set;get;}
    
    public Application_Additional_Driver__c mainDriver {set;get;}
    public String ltiQuestionDetails {set;get;}
    
    public List<InsuranceQuoteUtils.QuoteAnnotation> offenceList {set;get;}
    public List<InsuranceQuoteUtils.QuoteAnnotation> licencetList {set;get;}
    public List<InsuranceQuoteUtils.QuoteAnnotation> accidentList {set;get;}
    
    public String offenceAnswer {set;get;}
    public String licenceAnswer {set;get;}
    public String accidentAnswer {set;get;}
    
    public String otherInfoAnswer1 {set;get;}
    public String otherInfoAnswer2 {set;get;}
    
    public String otherInfoDetail1 {set;get;}
    public String otherInfoDetail2 {set;get;}
    
    public Integer remAnnotation {set;get;}
    
    public List<InsuranceQuoteUtils.AddtionalDriver> additionalDrivers {set;get;}
    public Map<String, Id> recordTypes;
    
    private String userProfile = null;
    
    public Boolean mvNCBProtection {set;get;}
    public Boolean mvWindscreenProtection {set;get;}
    private Map<Integer, Decimal> mvExcessOptions;
    public Integer standardExcessSelected {set;get;}
    public Decimal mvAmountCovered {set;get;}
    
    private Boolean reprocessQuoteAnswer = false;
    public Map<ApexPages.Severity, List<String>> appMessages = new Map<ApexPages.Severity, List<String>>();
    
    public Decimal currentWeeklyMV {set;get;}
    public Decimal newWeeklyMV {set;get;}
    
    // Liberty VEI cover amount
    public String libertyPayoutTotal {set;get;}
    public String libertyPocketExpenses {set;get;}
    
    public Boolean fullCompYes {set;get;}
    
    // LTI - health information
    public String acknowledgmentOfExclusion {set;get;}
    private Lenders__c lenderSettings {set;get;}
    
    public String gapPayType {set;get;}
    public String lpiPayType {set;get;}
    public String warrantyPayType {set;get;}
    public String nwcPayType {set;get;}
    
    public Map<String, Document> insdocsMap = null;
    public String gapDoc {set;get;}
    public String lpiDoc {set;get;}
    public String warrDoc {set;get;}

    // Integrity Qualifying Questions
    public String integrityQ1Sel {set;get;}
    public String integrityQ2Sel {set;get;}
    public String integrityQ3Sel {set;get;}
    public String integrityQ4Sel {set;get;}
    public String integrityQ5Sel {set;get;}

    public Account ownerAccount {set;get;}

    public InsurancePresentationExtension() {
      String paramTmp = System.currentPageReference().getParameters().get('P');
      this.resetDiaplayingOptions();
      if (!String.isBlank(paramTmp)) {
        try {
          this.appId = CryptoUtils.decrypt(paramTmp);
          loadData();
        } catch (SecurityException e) {
          System.debug(e.getMessage());
          errorMessage = '(MSG-105) This URL is not valid, please contact with your Sales Representative.';
        } catch (Exception e) {
          System.debug(e.getMessage());
          errorMessage = '(MSG-205) This URL is not valid, please contact with yor Sales Representative.';
        }
      } else {
        this.o = null;
        errorMessage = '(MSG-104) This URL is not valid, please contact with yor Sales Representative.';
      }
      Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
      userProfile = p.name;
      System.debug('userProfile >> ' + userProfile);
    }
    
    private void resetDiaplayingOptions() {
        //this.insProductsConfirmed = false;
        //this.insDisplayDeclaration = false;
        //this.displayFullComprehensive = false;
        //this.displayInsuranceQuestions = false;
        
        this.hasGapRtiProductDeclined = false;
        this.hasLpiProductDeclined = false;
        this.hasWarrantyProductDeclined = false;
    }
    
    private void loadData() {
        System.debug('loading data...');
        this.recordTypes = InsuranceQuoteUtils.getRecordTypes();
        this.resetDiaplayingOptions();
        resetSingleMap();
        resultList = new Map<String, Application_Quoting_Result__c>();
        
        //hasBeenHospitalised = null;
        //hasLongTermMedicalCondition = null;
        //isTakingRegularMedication = null;
        //isUnderMedicalTreatment = null;
        this.acknowledgmentOfExclusion = null;

        this.integrityQ1Sel = null;
        this.integrityQ2Sel = null;
        this.integrityQ3Sel = null;
        this.integrityQ4Sel = null;
        this.integrityQ5Sel = null;
        
        //Load quoting
        this.quoting = QuotingToolHelper.getApplicationQuoting(this.appId);
        if (this.quoting != null) {
          // Load Lender Settings
          lenderSettings = QuotingCalculation.getLenderSettings(this.quoting.Name);
          
          // load Payment Types
          if (InsuranceQuoteUtils.displayGAPProduct(this.quoting)) {
            this.gapPayType = this.quoting.Insurance_GAP_PayType__c;
          }
          if (InsuranceQuoteUtils.displayLPIProduct(this.quoting)) {
            this.lpiPayType = this.quoting.Insurance_AIC_PayType__c;
          }
          if (InsuranceQuoteUtils.displayEricWARRProduct(this.quoting)) {
            this.warrantyPayType = this.quoting.Insurance_Warranty_PayType__c;
          }
          if (InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting)) {
            this.nwcPayType = this.quoting.Insurance_NWC_PayType__c;
          }
          System.debug('gapPayType >> ' + gapPayType);
          System.debug('lpiPayType >> ' + lpiPayType);
          System.debug('warrantyPayType >> ' + warrantyPayType);
          System.debug('nwcPayType >> ' + nwcPayType);

          //Load quote
          this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoting.App_Insurance_Quote__c);
          //Load Quoting Results
          List<Application_Quoting_Result__c> d = QuotingCalculation.getQuotingResultsByQuoId(this.quoting.Id);
          for (Application_Quoting_Result__c a : d) {
              resultList.put(a.Result_Type__c, a);
          }
          //Load single package
          if (QuotingCalculation.PRO_CUSTOM.equals(this.quoting.Insurance_Customer_Choice__c)) {
              if ('A'.equals(this.quoting.Insurance_GAP_Acceptance__c)) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_GAP, true);
              }
              if ('A'.equals(this.quoting.Insurance_LTI_Acceptance__c)) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_LTI, true);
              }
              if ('A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, true);
              }
              if ('A'.equals(this.quoting.Insurance_Warranty_Acceptance__c)) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_WARR, true);
              }
              if ('A'.equals(this.quoting.Insurance_TAI_Acceptance__c )) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_TAI, true);
              }
              if ('A'.equals(this.quoting.Insurance_MV_Acceptance__c )) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_MV, true);
              }
              if ('A'.equals(this.quoting.Insurance_NWC_Acceptance__c )) {
                  singleMap.put(InsuranceQuoteUtils.INS_PROD_NWC, true);
              }
          }

          // Check if the from should go directly to Full Comprehensive
          if (
            InsuranceQuoteUtils.CUSCHOICE_SENT.equals(this.quote.Customer_Choice_Status__c) &&
            this.getHasMvInsProduct() &&
            !this.getHasGapInsProduct() &&
            !this.getHasLpiInsProduct() &&
            !this.getHasWarrantyInsProduct() &&
            !this.getHasNwcInsProduct()
          ) {
            this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE;
          }
          if (
            String.isBlank(this.quote.Customer_Choice_Status__c) || 
            InsuranceQuoteUtils.CUSCHOICE_SENT.equals(this.quote.Customer_Choice_Status__c)
          ) {
            this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_DECIDING;
          }
          if (InsuranceQuoteUtils.CUSCHOICE_FILLINFO.equals(this.quote.Customer_Choice_Status__c)) {
            this.mainDriver = InsuranceQuoteUtils.getMainDriver(this.quote.Id);
            if (this.mainDriver != null) {
                this.mainDriver.Health_Info_Question_1__c = null;
                this.mainDriver.Health_Info_Question_2__c = null;
                this.ltiQuestionDetails = null;
            }
            this.additionalDrivers = InsuranceQuoteUtils.getAdditionalDriversObj(this.quote.Id);
            this.loadMVAnnotations();
          }
          
          this.libertyPayoutTotal = '';
          this.libertyPocketExpenses = '';
          if (InsuranceQuoteUtils.CUSCHOICE_DECIDING.equals(this.quote.Customer_Choice_Status__c) && getIsGAPLiberty()) {
            if (this.quoting.Insurance_VEI_Type__c.contains('Option 1')) {
              this.libertyPayoutTotal = '$20,000';
              this.libertyPocketExpenses = '$5.000';
            } else if (this.quoting.Insurance_VEI_Type__c.contains('Option 2')) {
              this.libertyPayoutTotal = '$15,000';
              this.libertyPocketExpenses = '$4.000';
            } else if (this.quoting.Insurance_VEI_Type__c.contains('Option 3')) {
              this.libertyPayoutTotal = '$7,500';
              this.libertyPocketExpenses = '$3.000';
            }
          }
          this.loadMVData();
          this.loadPDSDocuments();
          System.debug('Customer_Choice_Status__c >>> ' + this.quote.Customer_Choice_Status__c);

          this.ownerAccount = this.getAccountVar();
        } else {
            errorMessage = '(MSG-115) The quote can not be found it, please contact with yor Sales Representative.';
        }
        //System.debug(this.quoting.Insurance_Customer_Choice__c + '|' + insProductsConfirmed);
    }
    
    public Boolean getDisplayPackageOptions() {
        //Boolean r = true;
        //if (this.insProductsConfirmed || this.insDisplayDeclaration || this.displayFullComprehensive || this.displayInsuranceQuestions) {
        //    r = false;
        //}
        //return r;
        return getDisplaySection(InsuranceQuoteUtils.CUSCHOICE_DECIDING);
    }
    
    public Boolean getDisplayDeclaration() {
        return getDisplaySection(InsuranceQuoteUtils.CUSCHOICE_DECLARING);
    }
    
    public Boolean getDisplayFullComprehensive() {
        return getDisplaySection(InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE);
    }
    
    public Boolean getDisplayHealthInfo() {
        return getDisplaySection(InsuranceQuoteUtils.CUSCHOICE_FILLINFO);
    }
    
    public Boolean getDisplayProductsConfirmation() {
        return getDisplaySection(InsuranceQuoteUtils.CUSCHOICE_FINISHED);
    }
    
    private Boolean getDisplaySection(String choiceStatus) {
        Boolean r = false;
        if (choiceStatus != null && this.quote.Customer_Choice_Status__c != null) {
            r = choiceStatus.equals(this.quote.Customer_Choice_Status__c);
        }
        return r;
    }
    
    private void resetSingleMap() {
        singleMap = new Map<String, Boolean>();
        singleMap.put(InsuranceQuoteUtils.INS_PROD_GAP, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_LTI, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_WARR, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_TAI, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_MV, false);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_NWC, false);
    }
    
    public Application_Quoting_Result__c getFullyResult() {
        return resultList.get(QuotingCalculation.PRO_FULLY);
    }    
    
    public Application_Quoting_Result__c getStandardResult() {
        return resultList.get(QuotingCalculation.PRO_STANDARD);
    }
    
    public Application_Quoting_Result__c getBasicResult() {
        return resultList.get(QuotingCalculation.PRO_BASIC);
    }
    
    public Boolean getHasFullyResult() {
        return resultList.containsKey(QuotingCalculation.PRO_FULLY);
    }    
    
    public Boolean getHasStandardResult() {
        return resultList.containsKey(QuotingCalculation.PRO_STANDARD);
    }
    
    public Boolean getHasBasicResult() {
        return resultList.containsKey(QuotingCalculation.PRO_BASIC);
    }
    
    public Boolean getHasMvInsProduct() {
      return (
        InsuranceQuoteUtils.displayMVProduct(this.quoting) && 
        this.quoting.Insurance_MV_Retail_Price__c > 0
      );
    }
    
    public Boolean getHasGapInsProduct() {
      return (
        InsuranceQuoteUtils.displayGAPProduct(this.quoting) && 
        this.quoting.Insurance_GAP_Retail_Price__c > 0
      );
    }

    public Boolean getHasLibertyGapInsProduct() {
      return (
        getHasGapInsProduct() &&
        InsuranceQuoteUtils.displayLibertyGAPProduct(this.quoting)
      );
    }
    
    public Boolean getHasTaiInsProduct() {
      return false;
    }
    
    public Boolean getHasLtiInsProduct() {
      return false;
    }
    
    public Boolean getHasLpiInsProduct() {
      return (
        InsuranceQuoteUtils.displayLPIProduct(this.quoting) && 
        this.quoting.Insurance_AIC_Retail_Price__c > 0
      );
    }
    
    public Boolean getHasLibertyLpiInsProduct() {
      return (
        getHasLpiInsProduct() &&
        InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting)
      );
    }

    public Boolean getHasWarrantyInsProduct() {
      return (
        InsuranceQuoteUtils.displayEricWARRProduct(this.quoting) &&
        this.quoting.Insurance_Warranty_Retail_Price__c > 0
      );
    }
    
    public Boolean getHasNwcInsProduct() {
      return (
        InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting) &&
        this.quoting.Insurance_NWC_Retail_Price__c > 0
      );
    }
    
    public Boolean getIsPageLoaded() {
        if (this.quoting != null) return true;
        return false;
    }
    
    // private void processChoice(String action, String choice) {
        
    //     processChoice(action, choice, null);
    // }
    
    private void processChoice(String action, String choice, List<String> customProducts) {
      if (getIsPublicMode()) {
        InsuranceQuoteUtils.updateInsProductAcceptance(this.quoting, action, choice, customProducts);
        loadData();
        System.debug('processChoice... ' + this.quote.Customer_Choice_Status__c);
      } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
      }
    }
    
    public void confirmSingleInsProductChoice() {
      System.debug('confirmSingleInsProductChoice...');
      this.appMessages.clear();
      //Validate
      List<String> customProducts = new List<String>();
      Boolean isUnprotected = false;
      for (String k : singleMap.keySet()) {
        if (singleMap.get(k)) {
          if (InsuranceQuoteUtils.INS_PROD_UNPROTECTED.equals(k)) {
            isUnprotected = true;
            break;
          } else {
            customProducts.add(k);
          }
        }
      }

      // Validate payment type
      if (
        customProducts.contains(InsuranceQuoteUtils.INS_PROD_GAP) && 
        String.isBlank(this.gapPayType)
      ) {
        this.addMessages(
          ApexPages.Severity.WARNING, 
          'Please choose a payment type option for Shortfall product'
        );
      }
      if (
        customProducts.contains(InsuranceQuoteUtils.INS_PROD_WARR) && 
        String.isBlank(this.warrantyPayType)
      ) {
        this.addMessages(
          ApexPages.Severity.WARNING, 
          'Please choose a payment type option for Warranty product'
        );
      }
      if (
        customProducts.contains(InsuranceQuoteUtils.INS_PROD_NWC) && 
        String.isBlank(this.nwcPayType)
      ) {
        this.addMessages(
          ApexPages.Severity.WARNING, 
          'Please choose a payment type option for Warranty product'
        );
      }
      if (
        customProducts.contains(InsuranceQuoteUtils.INS_PROD_CCI) && 
        String.isBlank(this.lpiPayType)
      ) {
        this.addMessages(
          ApexPages.Severity.WARNING, 
          'Please choose a payment type option for Repayment Cover product'
        );
      }

      if (!isUnprotected && customProducts.isEmpty()) {
        this.addMessages(
          ApexPages.Severity.WARNING, 
          'Please choose which option(s) you would like to include'
        );
      }
      System.debug('total appMessages => ' + this.appMessages.size());
      if (this.appMessages.isEmpty()) {
        // Reset Financed and PBM
        // if (this.getHasGapInsProduct()) {
        //   this.quoting.Insurance_GAP_InFinance__c = false;
        //   this.quoting.Insurance_GAP_PayByMonth__c = false;
        // }
        // if (this.getHasWarrantyInsProduct()) {
        //   this.quoting.Insurance_Warranty_InFinance__c = false;
        //   this.quoting.Insurance_Warranty_PayByMonth__c = false;
        // }
        // if (this.getHasNwcInsProduct()) {
        //   this.quoting.Insurance_NWC_InFinance__c = false;
        //   this.quoting.Insurance_NWC_PayByMonth__c = false;
        // }
        // if (this.getHasLpiInsProduct()) {
        //   this.quoting.Insurance_AIC_InFinance__c = false;
        //   this.quoting.Insurance_AIC_PayByMonth__c = false;
        // }
        
        if (isUnprotected) {
            processChoice('A', QuotingCalculation.PRO_UNPROTECTED, customProducts);
        } else if (!customProducts.isEmpty()) {
          processChoice('A', QuotingCalculation.PRO_CUSTOM, customProducts);
        }
      }
    }
    
    //CONFIRM PRODUCT
    public void confirmMVInsProductChoice() {
      singleMap.put(InsuranceQuoteUtils.INS_PROD_MV, true);
      singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
    }

    public void confirmGAPInsProductChoice() {
      singleMap.put(InsuranceQuoteUtils.INS_PROD_GAP, true);
      singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
    }

    public void confirmWARRInsProductChoice() {
      singleMap.put(InsuranceQuoteUtils.INS_PROD_WARR, true);
      singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
    }

    public void confirmNWCInsProductChoice() {
      singleMap.put(InsuranceQuoteUtils.INS_PROD_NWC, true);
      singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
    }
    
    public void confirmCCIInsProductChoice() {
        // if (isLiberty()) {
        //     singleMap.put(InsuranceQuoteUtils.INS_PROD_LTI, true);
        // } else {
        //     singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, true);
        // }
        singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, true);
        singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
        //
    }
    
    public void confirmUnprotectedProductChoice() {
        singleMap.clear();
        singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, true);
    }
    
    //CANCEL PRODUCT
    public void cancelMVInsProductChoice() {
        singleMap.put(InsuranceQuoteUtils.INS_PROD_MV, false);
    }    
    
    public void cancelGAPInsProductChoice() {
        singleMap.put(InsuranceQuoteUtils.INS_PROD_GAP, false);
    }
    
    public void cancelWARRInsProductChoice() {
        singleMap.put(InsuranceQuoteUtils.INS_PROD_WARR, false);
    }
    
    public void cancelNWCInsProductChoice() {
        singleMap.put(InsuranceQuoteUtils.INS_PROD_NWC, false);
    }
    
    public void cancelCCIInsProductChoice() {
        // if (isLiberty()) {
        //     singleMap.put(InsuranceQuoteUtils.INS_PROD_LTI, false);
        // } else {
        //     singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, false);
        // }
      singleMap.put(InsuranceQuoteUtils.INS_PROD_CCI, false);
    }
    
    public void cancelUnprotectedProductChoice() {
        singleMap.put(InsuranceQuoteUtils.INS_PROD_UNPROTECTED, false);
    }
    
    public Boolean getHasProductSelected(String choice) {
        Boolean r = false;
        if (this.quoting != null && String.isNotBlank(choice)) {
            if (choice.equals(this.quoting.Insurance_Customer_Choice__c)) {
                r = true;
            } else {
                if (QuotingCalculation.PRO_CUSTOM.equals(this.quoting.Insurance_Customer_Choice__c)) {
                    if (choice.equals(InsuranceQuoteUtils.INS_PROD_MV) && 'A'.equals(this.quoting.Insurance_MV_Acceptance__c)) {
                        r = true;
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_GAP) && 'A'.equals(this.quoting.Insurance_GAP_Acceptance__c)) {
                        r = true;
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_TAI) && 'A'.equals(this.quoting.Insurance_TAI_Acceptance__c)) {
                        r = true;
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_LTI) && 'A'.equals(this.quoting.Insurance_LTI_Acceptance__c)) {
                        r = true;
                    //Jesus Mora 2020-06-23 start    
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_CCI) && 'A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
                        r = true;
                    //Jesus Mora 2020-06-23 end    
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_WARR) && 'A'.equals(this.quoting.Insurance_Warranty_Acceptance__c)) {
                        r = true;
                    } else if (choice.equals(InsuranceQuoteUtils.INS_PROD_NWC) && 'A'.equals(this.quoting.Insurance_NWC_Acceptance__c)) {
                        r = true;
                    }
                }
            }
        }
        return r;
    }
    
    public Boolean getHasFullyProtectedSelected() {
        return getHasProductSelected(QuotingCalculation.PRO_FULLY);
    }
    
    public Boolean getHasStandardSelected() {
        return getHasProductSelected(QuotingCalculation.PRO_STANDARD);
    }
    
    public Boolean getHasBasicSelected() {
        return getHasProductSelected(QuotingCalculation.PRO_BASIC);
    }
    
    public Boolean getHasCustomSelected() {
        return getHasProductSelected(QuotingCalculation.PRO_CUSTOM);
    }
    
    //CHECK FOR INSURANCE PRODUCTS
    private Boolean getHasSingleProdSelected(String product) {
        Boolean r = false;
        if (singleMap.containsKey(product) && singleMap.get(product)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getHasMVSelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_MV);
    }
    public Boolean getHasGAPSelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_GAP);
    }
    public Boolean getHasTAISelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_TAI);
    }
    public Boolean getHasLTISelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_LTI);
    }
    public Boolean getHasWARRSelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_WARR);
    }
    public Boolean getHasNWCSelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_NWC);
    }
    public Boolean getHasCCISelected() {
      return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_CCI);
        // if (isLiberty()) {
        //     return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_LTI);
        // } else {
        //     return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_CCI);
        // }
    }
    public Boolean getHasUnprotectedCSelected() {
        return getHasSingleProdSelected(InsuranceQuoteUtils.INS_PROD_UNPROTECTED);
    }
    
    public Decimal getCustomResultWeeklyPayment() {
      System.debug('CustomResultWeeklyPayment...');
      Decimal r = 0.0;
      r += this.getCustomLoanPaymentWeeklyPayment();
      r += this.getCustomInsurancesWeeklyPayment();
      return r.round(System.RoundingMode.CEILING);
    }

    public Decimal getCustomLoanPaymentWeeklyPayment() {
      System.debug('CustomResultWeeklyPayment...');
      Decimal r = 0.0;
      Application_Quoting_Result__c s = resultList.get(QuotingCalculation.CALC_SIMPLE);
      if (s != null) {
        r = s.Weekly_Payment__c;
        Integer numProd = 0;
        for (String k : singleMap.keySet()) {
          if (!InsuranceQuoteUtils.INS_PROD_UNPROTECTED.equals(k) && singleMap.get(k)) {
            if (
              (InsuranceQuoteUtils.INS_PROD_GAP.equals(k) && 'Financed'.equals(this.gapPayType)) ||
              (InsuranceQuoteUtils.INS_PROD_WARR.equals(k) && 'Financed'.equals(this.warrantyPayType)) ||
              (InsuranceQuoteUtils.INS_PROD_NWC.equals(k) && 'Financed'.equals(this.nwcPayType)) ||
              (InsuranceQuoteUtils.INS_PROD_CCI.equals(k) && 'Financed'.equals(this.lpiPayType))
            ) {
              numProd++;
              System.debug('Adding... ' + k);
              r += getWeeklyPayment(k, 2) - s.Weekly_Payment__c;    
            }
          }
        }
        if (
          singleMap.containsKey(InsuranceQuoteUtils.INS_PROD_CCI) && 
          'Financed'.equals(this.lpiPayType) && 
          (
            (singleMap.containsKey(InsuranceQuoteUtils.INS_PROD_WARR) && 'Financed'.equals(this.warrantyPayType)) ||
            (singleMap.containsKey(InsuranceQuoteUtils.INS_PROD_NWC) && 'Financed'.equals(this.nwcPayType))
          ) &&
          InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting)
        ) {
          r += 1;
        }
      }
      return r.round(System.RoundingMode.CEILING);
    }

    public Decimal getCustomInsurancesWeeklyPayment() {
      // System.debug('getCustomInsurancesWeeklyPayment...');
      Decimal r = 0.0;
      if (
        this.getHasGAPSelected() && 
        'PBM'.equals(this.gapPayType)
      ) {
        r += this.getInsurancePayment(
          this.quoting.Insurance_GAP_Retail_Price__c, 
          this.quoting.Insurance_GAP_Term__c
        );
      }
      if (
        this.getHasWARRSelected() && 
        'PBM'.equals(this.warrantyPayType)
      ) {
        r += this.getInsurancePayment(
          this.quoting.Insurance_Warranty_Retail_Price__c, 
          this.quoting.Insurance_Warranty_Term__c
        );
      }
      if (
        this.getHasNWCSelected() && 
        'PBM'.equals(this.nwcPayType)
      ) {
        r += this.getInsurancePayment(
          this.quoting.Insurance_NWC_Retail_Price__c, 
          this.quoting.Insurance_NWC_Term__c
        );
      }
      if (
        this.getHasCCISelected() && 
        'PBM'.equals(this.lpiPayType)
      ) {
        r += this.getInsurancePayment(
          this.quoting.Insurance_AIC_Retail_Price__c, 
          this.quoting.Insurance_AIC_Term__c
        );
      }
      // System.debug('CCI => ' + this.getHasCCISelected() + '|' + this.quoting.Insurance_AIC_Retail_Price__c + '|' + this.quoting.Insurance_AIC_Term__c);
      return r.round(System.RoundingMode.CEILING);
    }
    
  private Decimal getInsurancePayment(Decimal premium, String term) {
    Decimal r = 0.00;
    if (premium != null && String.isNotBlank(term) && term.isNumeric()) {
      r = premium / Decimal.valueOf(term) * 12 / 52;
    }
    System.debug('premium: ' + premium + ' term: ' + term + ' ==> ' + r);
    return r;
  }

    private Decimal getWeeklyPayment(String insProduct) {
        return getWeeklyPayment(insProduct, 0);
    }
    
    private Decimal getWeeklyPayment(String insProduct, Integer scale) {
        Decimal r = 0.00;
        Application_Quoting_Result__c tmp = resultList.get(insProduct);
        if (tmp != null) {
            r = tmp.Weekly_Payment__c;
        }
        return r.setScale(scale);
    }
    
    
    public Decimal getFullyWeeklyPayment() {
        return getWeeklyPayment(QuotingCalculation.PRO_FULLY);
    }
    
    public Decimal getStandardWeeklyPayment() {
        return getWeeklyPayment(QuotingCalculation.PRO_STANDARD);
    }
    
    public Decimal getBasicWeeklyPayment() {
        return getWeeklyPayment(QuotingCalculation.PRO_BASIC);
    }
    
    public Boolean getIsWarrantyDiamond() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Diamond')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsWarrantyPlatinum() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Platinum')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsGAPClassic1() {
        Boolean r = false;
        if (getHasGAPInsProduct()) {
            if (this.quoting.Insurance_Gap_Type__c.contains('Cover 1')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsGAPClassic2() {
        Boolean r = false;
        if (getHasGAPInsProduct()) {
            if (this.quoting.Insurance_Gap_Type__c.contains('Cover 2')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsGAPClassic3() {
        Boolean r = false;
        if (getHasGAPInsProduct()) {
            if (this.quoting.Insurance_Gap_Type__c.contains('Cover 3')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsGAPClassic4() {
        Boolean r = false;
        if (getHasGAPInsProduct()) {
            if (this.quoting.Insurance_Gap_Type__c.contains('Cover 4')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsGAPLiberty() {
        //VEI
        Boolean r = false;
        if (isLiberty()) {
            if (String.isNotBlank(this.quoting.Insurance_VEI_Type__c) && 
                this.quoting.Insurance_VEI_Retail_Price__c != null &&
                this.quoting.Insurance_VEI_Retail_Price__c > 0) {
                    r = true;
                }
        }
        return r;
    }
    
    public Boolean getIsLTIPlatinum1() {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Platinum Cover 1')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsLTIPlatinum2() {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Platinum Cover 2')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsLTIPlatinum3() {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Platinum Cover 3')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsLTIGold2() {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Gold Cover 2')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsLTISilver1() {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Silver Cover 1')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsLTICover1() {
        return getIsLTICover('1');
    }
    
    public Boolean getIsLTICover2() {
        return getIsLTICover('2');
    }
    
    public Boolean getIsLTICover3() {
        return getIsLTICover('3');
    }
    
    private Boolean getIsLTICover(String cover) {
        Boolean r = false;
        if (getHasLTIInsProduct()) {
            if (this.quoting.Insurance_LTI_Type__c.contains('Cover ' + cover)) {
                r = true;
            }
        }
        return r;
    }
    
    
    public Boolean getIsWARRDiamond36() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Diamond - 36')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsWARRDiamond60() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Diamond - 60')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsWARRPlatinum36() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Platinum - 36')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsWARRPlatinum60() {
        Boolean r = false;
        if (getHasWarrantyInsProduct()) {
            if (this.quoting.Insurance_Warranty_Type__c.contains('Platinum - 60')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsTaiRequired() {
        Boolean r = false;        
        if (this.quoting != null && this.quoting.Net_Deposit_Percentage__c >= InsuranceQuoteUtils.RTI_NET_DEPOSIT_PERC 
            && !this.getIsGAPLiberty() && String.isBlank(this.quote.Gap__c) 
            && this.getHasTaiInsProduct()) {
                r = true;
            }
        return r;
    }   
    
    public Boolean getIsTaiCover1() {
        Boolean r = false;
        if (getHasTaiInsProduct()) {
            if (this.quoting.Insurance_TAI_Type__c.contains('Cover 1')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsTaiCover2() {
        Boolean r = false;
        if (getHasTaiInsProduct()) {
            if (this.quoting.Insurance_TAI_Type__c.contains('Cover 2')) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getIsTaiCover3() {
        Boolean r = false;
        if (getHasTaiInsProduct()) {
            if (this.quoting.Insurance_TAI_Type__c.contains('Cover 3')) {
                r = true;
            }
        }
        return r;
    }
    
    
    public Boolean getIsPublicMode() {
        Boolean r = false;
        System.debug('getIsPublicMode >> ' + UserInfo.getUserName() + '|' + InsuranceQuoteUtils.PUB_SITE_NAME);
        if (UserInfo.getUserName().containsIgnoreCase(InsuranceQuoteUtils.PUB_SITE_NAME)) {
            r = true;
        } else {
            //Check for Admin user
            if ('System Admin'.equals(userProfile)) {
                r = true;
            }
        }
        return r;
        //return true;
    }
    
    public Boolean getIsNWCRequired() {
        Boolean r = false;        
        if (this.quoting != null && !this.quoting.Has_Warranty__c) {
            if (this.quoting.Insurance_NWC_Retail_Price__c > 0) {
                r = true;
            }
        }
        return r;               
    }
    
    public Boolean getIsCCIRequired() {
      Boolean r = false;        
      if (this.quoting != null && String.isBlank(this.quoting.Insurance_LTI_Type__c)) {
        if (!this.quoting.Name.startsWith('AFS ') && !this.quoting.Name.startsWith('Yamaha')) {
          return getHasLpiInsProduct();
        }
      }
      return r;               
    }
    
    public void goProductOptions() {
        if (getIsPublicMode()) {
            System.debug('Returning to Product Options...');
            //Reset
            InsuranceQuoteUtils.resetProductAcceptance(this.quoting.Id);
            loadData();
            this.hasGapRtiProductDeclined = false;
            this.hasLpiProductDeclined = false;
            this.hasWarrantyProductDeclined = false;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public Boolean getDisplayGAPRTIDeclaration() {
      return (
        this.getHasGapInsProduct() && 
        !'A'.equals(this.quoting.Insurance_GAP_Acceptance__c)
      );
    }

    public Boolean getDisplayLPIDeclaration() {
      return (
        this.getHasLpiInsProduct() && 
        !'A'.equals(this.quoting.Insurance_AIC_Acceptance__c)
      );
    }
    
    public Boolean getDisplayLTIDeclaration() {
        Boolean r = false;
        if (QuotingCalculation.PRO_UNPROTECTED.equals(this.quoting.Insurance_Customer_Choice__c)) {
            r = true;
        } else if (QuotingCalculation.PRO_CUSTOM.equals(this.quoting.Insurance_Customer_Choice__c)) {
            if (!'A'.equals(this.quoting.Insurance_LTI_Acceptance__c) && !'A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
                if (isLiberty()) {
                        if (!'A'.equals(quoting.Insurance_LPI_Acceptance__c)) {
                            r = true;
                        }
                    } else {
                        r = true;
                    }
            }
        } else if (!QuotingCalculation.PRO_FULLY.equals(this.quoting.Insurance_Customer_Choice__c)) {
            r = true;
        }
        if (YamahaMarineCalculatorExtension.LENDER_QUOTING.equals(quoting.name)) {
            r = false;
        }
        //if (r && getExcludeLTILPI()) {
            if (!getHasLtiInsProduct() && !getHasLpiInsProduct()) {
                r = false;
            }
        //}
        return r;
    }
    
    public Boolean getDisplayWarrantyDeclaration() {
      System.debug(
        'DisplayWarrantyDeclaration => ' + this.getHasWarrantyInsProduct() + '|' + this.quoting.Insurance_Warranty_Acceptance__c + '] [' + 
        this.getHasNwcInsProduct() + '|' + this.quoting.Insurance_NWC_Acceptance__c + ']');
      return (
        (
          this.getHasWarrantyInsProduct() && 
          !'A'.equals(this.quoting.Insurance_Warranty_Acceptance__c)
        ) ||
        (
          this.getHasNwcInsProduct() && 
          !'A'.equals(this.quoting.Insurance_NWC_Acceptance__c)
        )
      );
    }
    
    public void declineGapPurchase() {
        if (getIsPublicMode()) {
            this.hasGapRtiProductDeclined = true;
            declinePurchase();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void declineLPIPurchase() {
        if (getIsPublicMode()) {
            this.hasLpiProductDeclined = true;
            declinePurchase();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void declineWarrantyPurchase() {
        if (getIsPublicMode()) {
            this.hasWarrantyProductDeclined = true;
            declinePurchase();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void declinePurchase() {
      Boolean endProcess = true;
      System.debug('declinePurchase...');
      if (getDisplayGAPRTIDeclaration() &&  !hasGapRtiProductDeclined) {
          endProcess = false;
      }
      if (getDisplayLPIDeclaration() &&  !hasLpiProductDeclined) {
          endProcess = false;
      }
      if (getDisplayWarrantyDeclaration() &&  !hasWarrantyProductDeclined) {
          endProcess = false;
      }
      System.debug('endProcess >> ' + endProcess);
      if (endProcess) {
        Boolean reloadData = false;
        System.debug('has MV? >> ' + this.getHasMvInsProduct());
        if (this.getHasMvInsProduct()) {
          this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE;
        } else {
          if ('A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
              this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
              reloadData = true;
          } else {
              this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
          }
        }
        System.debug('Customer_Choice_Status__c >> ' + this.quote.Customer_Choice_Status__c);
        if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
            processFullComprehensive(false);
        } else {
            update this.quote;
        }
        if (reloadData) {
            this.loadData();
        }
      }
    }
    
    public void acceptFullComprehensive(){
        //processFullComprehensive(true);
        this.quote.Is_Vehicle_MV_Commercial__c = null;
        this.quote.Is_Vehicle_Modified__c = null;
        this.quote.MV_Declining_Notes__c = null;
        this.fullCompYes = true;
    }
    
    public void acceptMVVehicleUsage(){
        if (getIsPublicMode()) {
            
            this.quote.Is_Vehicle_MV_Commercial__c = 'Y';
            this.processExtraFullCompquestions();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void declineMVVehicleUsage(){
        if (getIsPublicMode()) {
            
            this.quote.Is_Vehicle_MV_Commercial__c = 'N';
            this.processExtraFullCompquestions();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void acceptMVVehicleModified(){
        if (getIsPublicMode()) {
            this.quote.Is_Vehicle_Modified__c = 'Y';
            this.processExtraFullCompquestions();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public void declineMVVehicleModified(){
        if (getIsPublicMode()) {
            this.quote.Is_Vehicle_Modified__c = 'N';
            this.processExtraFullCompquestions();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    public Boolean getMVVehicleUsageBtnYes() {
        Boolean r = null;
        if ('Y'.equals(this.quote.Is_Vehicle_MV_Commercial__c)) {
            r = true;
        } else if ('N'.equals(this.quote.Is_Vehicle_MV_Commercial__c)) {
            r = false;
        }
        return r;
    }
    
    public Boolean getMVVehicleUsageBtnNo() {
        Boolean r = null;
        if ('Y'.equals(this.quote.Is_Vehicle_MV_Commercial__c)) {
            r = false;
        } else if ('N'.equals(this.quote.Is_Vehicle_MV_Commercial__c)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getMVVehicleModifiedBtnYes() {
        Boolean r = false;
        if ('Y'.equals(this.quote.Is_Vehicle_Modified__c)) {
            r = true;
        } else if ('N'.equals(this.quote.Is_Vehicle_Modified__c)) {
            r = false;
        }
        return r;
    }
    
    public Boolean getMVVehicleModifiedBtnNo() {
        Boolean r = null;
        if ('Y'.equals(this.quote.Is_Vehicle_Modified__c)) {
            r = false;
        } else if ('N'.equals(this.quote.Is_Vehicle_Modified__c)) {
            r = true;
        }
        return r;
    }
    
    private void processExtraFullCompquestions() {
        System.debug('Is_Vehicle_MV_Commercial__c >> ' + this.quote.Is_Vehicle_MV_Commercial__c);
        System.debug('Is_Vehicle_Modified__c >> ' + this.quote.Is_Vehicle_Modified__c);
        if (
          'N'.equals(this.quote.Is_Vehicle_MV_Commercial__c) &&
          'N'.equals(this.quote.Is_Vehicle_Modified__c)
        ) {
          //processFullComprehensive(true);
          InsuranceQuoteUtils.finishCustomerQuote(this.quoting, this.quote, true);
          InsuranceQuoteUtils.deleteFailureReasons(this.quote.Id);
          this.quote.MV_Declining_Notes__c = null;
          update quoting;
          update quote;
          loadData();
        } else if (
          String.isNotBlank(this.quote.Is_Vehicle_MV_Commercial__c) &&
          String.isNotBlank(this.quote.Is_Vehicle_Modified__c)
        ) {
          this.quote.MV_Declining_Notes__c = 
            'Vehicle excluded from our acceptable vehicles and we are unable to complete a Full-Comprehensive insurance. ' +
            '1. vehicle be used for any of the following activities? [' + this.quote.Is_Vehicle_MV_Commercial__c +  '], ' + 
            '2. vehicle fitted with any Modifications or Accessories? [' + this.quote.Is_Vehicle_Modified__c +  ']' ;
          InsuranceQuoteUtils.finishCustomerQuote(this.quoting, this.quote, false);
          InsuranceQuoteUtils.deleteFailureReasons(this.quote.Id);
          update quoting;
          update quote;
          if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.quote.MV_Declining_Notes__c));
          }
          loadData();
        }
        if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
            InsuranceQuoteUtils.createAcknowledgementForm(this.quote, this.quoting);
        }
    }
    
    public void declineFullComprehensive(){
        if (getIsPublicMode()) {
            processFullComprehensive(false);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    private void processFullComprehensive(Boolean accepted) {
        if (InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE.equals(this.quote.Customer_Choice_Status__c)) {
            InsuranceQuoteUtils.deleteFailureReasons(this.quote.Id);
            if (accepted) {
                this.quote.MV_Declining_Notes__c = null;
            } else {
              this.quote.Is_Vehicle_MV_Commercial__c = null;
              this.quote.Is_Vehicle_Modified__c = null;
            }
            InsuranceQuoteUtils.finishCustomerQuote(this.quoting, this.quote, accepted);
            if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c) &&
                ('A'.equals(this.quoting.Insurance_LTI_Acceptance__c) || 'A'.equals(this.quoting.Insurance_AIC_Acceptance__c))) {
                    this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
                }
            update quoting;
            update quote;
        } else if (InsuranceQuoteUtils.CUSCHOICE_FILLINFO.equals(this.quote.Customer_Choice_Status__c)) {
            InsuranceQuoteUtils.refreshQuotingProductPremiums(InsuranceQuoteUtils.INS_PROD_MV, this.quote, this.quoting);
            InsuranceQuoteUtils.finishCustomerQuote(this.quoting, this.quote, accepted);
            this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
            update this.quote;
            update this.quoting;
        } else if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
            InsuranceQuoteUtils.finishCustomerQuote(this.quoting.Id, accepted);
        }
        loadData();
        if (InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(this.quote.Customer_Choice_Status__c)) {
            InsuranceQuoteUtils.createAcknowledgementForm(this.quote, this.quoting);
        }
    }
    
    public Decimal getMnWeeklyAmount() {
        Decimal r = 0.0;
        if (this.quoting != null && this.quoting.Insurance_MV_Retail_Price__c != null) {
            r = (this.quoting.Insurance_MV_Retail_Price__c * 1.12) / 52;
        }
        return r.round(System.RoundingMode.CEILING);
    }
    
    public void confirmAdditionalInformation(){
        
        if (!getIsPublicMode()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
            return;
        }
        System.debug('confirmAdditionalInformation...');
        //Validate form
        if (this.isValidAddInfo()) {
          if (this.getHasAcceptedHealthProd()) {
            this.mainDriver.Health_Info_Question_1__c = this.acknowledgmentOfExclusion;
            if ('N'.equals(this.mainDriver.Health_Info_Question_1__c)) {
                this.mainDriver.Health_Full_Details__c = this.ltiQuestionDetails;
            } else {
                this.mainDriver.Health_Full_Details__c = null;
            }
            update this.mainDriver;
          }
          
          // Integrity
          if (this.getHasAcceptedNwcProd()) {
            this.quoting.Insurance_NWC_Qualifying__c = this.integrityQ1Sel + '|' + this.integrityQ2Sel + '|' + this.integrityQ3Sel + '|' + this.integrityQ4Sel + '|' + this.integrityQ5Sel;
            this.quoting.Insurance_NWC_Acceptance__c = this.quoting.Insurance_NWC_Qualifying__c.contains('N')? 'D' : 'A';
            update this.quoting;
          }

          if (this.getMVAccepted()) {
              List<Insurance_Quote_Annotation__c> d = new List<Insurance_Quote_Annotation__c>();
              // Motoring Offence
              this.quote.Has_Motoring_Offences__c = false;
              if ('Y'.equals(this.offenceAnswer)) {
                  this.quote.Has_Motoring_Offences__c = true;
                  for (InsuranceQuoteUtils.QuoteAnnotation a : this.offenceList) {
                      Insurance_Quote_Annotation__c q = a.getAnnotationObj();
                      q.Insurance_Quote__c = this.quote.Id;
                      q.RecordTypeId = this.recordTypes.get(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
                      d.add(q);
                  }
              }
              // Licence Refusal
              this.quote.Has_Licence_Santioned__c = false;
              if ('Y'.equals(this.licenceAnswer)) {
                  this.quote.Has_Licence_Santioned__c = true;
                  for (InsuranceQuoteUtils.QuoteAnnotation a : this.licencetList) {
                      Insurance_Quote_Annotation__c q = a.getAnnotationObj();
                      q.Insurance_Quote__c = this.quote.Id;
                      q.RecordTypeId = this.recordTypes.get(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
                      d.add(q);
                  }
              }
              // Accidents
              this.quote.Has_Accident_History__c = false;
              if ('Y'.equals(this.accidentAnswer)) {
                  this.quote.Has_Accident_History__c = true;
                  for (InsuranceQuoteUtils.QuoteAnnotation a : this.accidentList) {
                      Insurance_Quote_Annotation__c q = a.getAnnotationObj();
                      q.Insurance_Quote__c = this.quote.Id;
                      q.RecordTypeId = this.recordTypes.get(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
                      d.add(q);
                  }
              }
              
              // Other Information
              this.quote.Other_Info_Question_1__c = false;
              if ('Y'.equals(this.otherInfoAnswer1)) {
                  this.quote.Other_Info_Question_1__c = true;
                  this.quote.Other_Info_Details_1__c = this.otherInfoDetail1;
              } else {
                  this.quote.Other_Info_Details_1__c = null;
              }
              
              this.quote.Other_Info_Question_2__c = false;
              if ('Y'.equals(this.otherInfoAnswer2)) {
                  this.quote.Other_Info_Question_2__c = true;
                  this.quote.Other_Info_Details_2__c = this.otherInfoDetail1;
              } else {
                  this.quote.Other_Info_Details_2__c = null;
              }
                            
              if (!d.isEmpty()) {
                  for (Insurance_Quote_Annotation__c a : d) {
                      a.Insurance_Quote__c = this.quote.Id;
                  }
                  upsert d;
              }
          }
          
          //Jesus Mora 2020-06-05 end
          update this.quote;
          //Save
          this.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
          update this.quote;
          loadMVAnnotations();
        }
    }
    
    private Boolean isValidAddInfo() {
        boolean r = true;
        // if (this.getLTIAccepted()) {
        if (this.getHasAcceptedHealthProd()) {
          if (this.acknowledgmentOfExclusion == null) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Health Information question.'));
              r = false;
          }
          if (
            'N'.equals(this.acknowledgmentOfExclusion) && 
            String.isBlank(this.ltiQuestionDetails)
          ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please give full details.'));   
            r = false;
          }
        }

        // Integrity
        if (this.getHasAcceptedNwcProd()) {
          if (String.isBlank(this.integrityQ1Sel) || String.isBlank(this.integrityQ2Sel) || String.isBlank(this.integrityQ3Sel) || String.isBlank(this.integrityQ4Sel) || String.isBlank(this.integrityQ5Sel)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for all Integrity Qualiying Questions.'));
            r = false;
          }
        }

        //MV
        if (getMVAccepted()) {
            // Motoring Offence
            if (String.isBlank(this.offenceAnswer)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Motoring Offences - Full Comprehensive.'));
                r = false;
            } else if ('Y'.equals(this.offenceAnswer)) {
                if (this.offenceList.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add and fill a Motoring Offence - Full Comprehensive.'));
                    r = false;
                } else {
                    for (InsuranceQuoteUtils.QuoteAnnotation a : this.offenceList) {
                        //check date
                        Date d = DateUtils.convertToDate(a.year, a.month, a.day);
                        if (d == null) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motoring Offence #' + a.order + ': Date is invalid.'));
                            r = false;    
                        }
                        //demerit poins
                        if (a.points <= 0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motoring Offence #' + a.order + ': Demerit Points should be greater than 0.'));
                            r = false;       
                        }
                        //Details
                        if (String.isBlank(a.details)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Motoring Offence #' + a.order + ': Details Of Offence cannot be empty.'));
                            r = false;          
                        }
                    }
                }
            }
            
            // Licence Refused / Suspended / Cancelled / Endorsed
            if (String.isBlank(this.licenceAnswer)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Licence Refused / Suspended / Cancelled / Endorsed - Full Comprehensive.'));
                r = false;
            } else if ('Y'.equals(this.licenceAnswer)) {
                if (this.licencetList.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add and fill a Licence Refusal - Full Comprehensive.'));
                    r = false;
                } else {
                    for (InsuranceQuoteUtils.QuoteAnnotation a : this.licencetList) {
                        //check date
                        Date d = DateUtils.convertToDate(a.year, a.month, a.day);
                        if (d == null) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Licence Refusal #' + a.order + ': Date is invalid.'));
                            r = false;    
                        }
                        //demerit poins
                        if (a.points < 0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Licence Refusal #' + a.order + ': Period Of Suspension is invalid.'));
                            r = false;       
                        }
                        //Details
                        if (String.isBlank(a.details)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Licence Refusal #' + a.order + ': Details Of Licence Refusal cannot be empty.'));
                            r = false;          
                        }
                    }
                }
            }
            
            // Accident / Claim History
            if (String.isBlank(this.accidentAnswer)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Accident / Claim History - Full Comprehensive.'));
                r = false;
            } else if ('Y'.equals(this.accidentAnswer)) {
                if (this.accidentList.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add and fill an Accident History - Full Comprehensive.'));
                    r = false;
                } else {
                    for (InsuranceQuoteUtils.QuoteAnnotation a : this.accidentList) {
                        //check date
                        Date d = DateUtils.convertToDate(a.year, a.month, a.day);
                        if (d == null) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accident #' + a.order + ': Date is invalid.'));
                            r = false;    
                        }
                        //demerit poins
                        if (a.amount < 0) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accident #' + a.order + ': Amount Of Loss is invalid.'));
                            r = false;       
                        }
                        //Details
                        if (String.isBlank(a.details)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accident #' + a.order + ': Details Of Accident cannot be empty.'));
                            r = false;          
                        }
                        //Insurer
                        if (String.isBlank(a.insurer)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Accident #' + a.order + ': Name Of Insurer cannot be empty.'));
                            r = false;          
                        }
                    }
                }
            }
            
            // Other Information 1
            if (String.isEmpty(this.otherInfoAnswer1)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Other Information - Criminal Offences - Full Comprehensive.'));
                r = false;
            } else if ('Y'.equals(this.otherInfoAnswer1)) {
                if (String.isBlank(this.otherInfoDetail1)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Information: Details on criminal offence cannot be empty.'));
                    r = false;          
                }
            }
            // Other Information 2
            if (String.isEmpty(this.otherInfoAnswer2)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select your answer for Other Information - Insurance Policy Refusal - Full Comprehensive.'));
                r = false;
            } else if ('Y'.equals(this.otherInfoAnswer2)) {
                if (String.isBlank(this.otherInfoDetail2)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Information: Details on insurance policy refused cannot be empty.'));
                    r = false;          
                }
            }
        }
        return r;
    }
    
    public Boolean getLTIAccepted() {
        Boolean r = false;
        if (this.quoting != null && 'A'.equals(quoting.Insurance_LTI_Acceptance__c)) {
            r = true;
        }
        return r;
    }
    
    public Boolean getMVAccepted() {
        Boolean r = false;
        if (this.quoting != null && 'A'.equals(quoting.Insurance_MV_Acceptance__c)) {
            r = true;
        }
        return r;
    }
    
    //LTI - Health Information
    //Question 1
    public Boolean getQuestion1YesSelected() {
        Boolean r = false;
        if (this.mainDriver != null && 'Y'.equals(this.mainDriver.Health_Info_Question_1__c)) {
            r = true;
        }
        return r;
    }
    public Boolean getQuestion1NoSelected() {
        Boolean r = false;
        if (this.mainDriver != null && 'N'.equals(this.mainDriver.Health_Info_Question_1__c)) {
            r = true;
        }
        return r;
    }
    public void selectQuestion1Yes() {
        if (getIsPublicMode()) {
            if (this.mainDriver != null) {
                this.mainDriver.Health_Info_Question_1__c = 'Y';
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectQuestion1No() {
        if (getIsPublicMode()) {
            if (this.mainDriver != null) {
                this.mainDriver.Health_Info_Question_1__c = 'N';
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
        
    }
    //Question 2
    public Boolean getQuestion2YesSelected() {
        Boolean r = false;
        if (this.mainDriver != null && 'Y'.equals(this.mainDriver.Health_Info_Question_2__c)) {
            r = true;
        }
        return r;
    }
    public Boolean getQuestion2NoSelected() {
        Boolean r = false;
        if (this.mainDriver != null && 'N'.equals(this.mainDriver.Health_Info_Question_2__c)) {
            r = true;
        }
        return r;
    }
    public void selectQuestion2Yes() {
        if (getIsPublicMode()) {
            if (this.mainDriver != null) {
                this.mainDriver.Health_Info_Question_2__c = 'Y';
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectQuestion2No() {
        if (getIsPublicMode()) {
            if (this.mainDriver != null) {
                this.mainDriver.Health_Info_Question_2__c = 'N';
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    //MV
    public void selectMVOffenceYes() {
        if (getIsPublicMode()) {
            this.offenceAnswer = 'Y';
            if (this.offenceList.isEmpty()) {
                addMVAnnotation(this.offenceList);
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVOffenceNo() {
        if (getIsPublicMode()) {
            this.offenceAnswer = 'N';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVLicenceYes() {
        if (getIsPublicMode()) {
            this.licenceAnswer = 'Y';
            if (this.licencetList.isEmpty()) {
                addMVAnnotation(this.licencetList);
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVLicenceNo() {
        if (getIsPublicMode()) {
            this.licenceAnswer = 'N';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVAccidentYes() {
        if (getIsPublicMode()) {
            this.accidentAnswer = 'Y';
            if (this.accidentList.isEmpty()) {
                addMVAnnotation(this.accidentList);
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVAccidentNo() {
        if (getIsPublicMode()) {
            this.accidentAnswer = 'N';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVOther1Yes() {
        if (getIsPublicMode()) {
            this.otherInfoAnswer1 = 'Y';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
        
    }
    public void selectMVOther1No() {
        if (getIsPublicMode()) {
            this.otherInfoAnswer1 = 'N';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVOther2Yes() {
        if (getIsPublicMode()) {
            this.otherInfoAnswer2 = 'Y';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    public void selectMVOther2No() {
        if (getIsPublicMode()) {
            this.otherInfoAnswer2 = 'N';
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        }
    }
    
    private InsuranceQuoteUtils.QuoteAnnotation createDefaultQuoteAnnotation() {
        InsuranceQuoteUtils.QuoteAnnotation r = new InsuranceQuoteUtils.QuoteAnnotation();
        r.day = Date.today().day();
        r.month = Date.today().month();
        r.year = Date.today().year();
        return r;
    }
    
    private void loadMVAnnotations() {
        this.offenceList = new List<InsuranceQuoteUtils.QuoteAnnotation>();
        this.licencetList = new List<InsuranceQuoteUtils.QuoteAnnotation>();
        this.accidentList = new List<InsuranceQuoteUtils.QuoteAnnotation>();
        
        List<Insurance_Quote_Annotation__c> d = InsuranceQuoteUtils.getInsuranceQuoteAnnotations(this.quote.Id);
        InsuranceQuoteUtils.QuoteAnnotation tmp = null;
        for (Insurance_Quote_Annotation__c a : d) {
            if (InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE.equals(a.RecordType.Name)) {
                tmp = InsuranceQuoteUtils.makeQuoteAnnotation(a);
                tmp.order = offenceList.size() + 1;
                offenceList.add(tmp);
            } else if (InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE.equals(a.RecordType.Name)) {
                tmp = InsuranceQuoteUtils.makeQuoteAnnotation(a);
                tmp.order = licencetList.size() + 1;
                licencetList.add(tmp);
            } else if (InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE.equals(a.RecordType.Name)) {
                tmp = InsuranceQuoteUtils.makeQuoteAnnotation(a);
                tmp.order = accidentList.size() + 1;
                accidentList.add(tmp);
            }
        }
        
        if (this.quote.Has_Motoring_Offences__c) {
            this.offenceAnswer = 'Y';
        }
        
        if (this.quote.Has_Licence_Santioned__c) {
            this.licenceAnswer = 'Y';
        }
        
        if (this.quote.Has_Accident_History__c) {
            this.accidentAnswer = 'Y';
        }
    }
    
    public List<SelectOption> getDriverOptions() {
        List<SelectOption> r = new List<SelectOption>();
        if (this.mainDriver != null) {
            r.add(new SelectOption(this.mainDriver.Id, this.mainDriver.First_Name__c + ' ' + this.mainDriver.Last_Name__c));
        }
        Integer idx = 1;
        for (InsuranceQuoteUtils.AddtionalDriver a : additionalDrivers) {
            if (String.isBlank(a.data.First_Name__c) || String.isBlank(a.data.Last_Name__c)) {
                r.add(new SelectOption(a.data.Id, 'Additional Driver ' + idx));    
            } else {
                r.add(new SelectOption(a.data.Id, a.data.First_Name__c + ' ' + a.data.Last_Name__c));
            }
            idx++;
        }
        return r;
    }
    
    public List<SelectOption> getDayOptions() {
        List<SelectOption> r = new List<SelectOption>();
        for (Integer i = 1; i <= 31;i++) {
            r.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return r;
    }
    
    public List<SelectOption> getYearOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer y = Date.today().year();
        for (Integer i = y; i > y - 5;i--) {
            r.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return r;
    }    
    
    public void addMVOffence() {
        //Validate
        
        addMVAnnotation(this.offenceList);
    }
    
    public void addMVLicence() {
        //Validate
        
        addMVAnnotation(this.licencetList);
    }
    
    public void addMVAccident() {
        //Validate
        
        addMVAnnotation(this.accidentList);
    }
    
    private void addMVAnnotation(List<InsuranceQuoteUtils.QuoteAnnotation> annList) {
        //Validate
        
        InsuranceQuoteUtils.QuoteAnnotation a = this.createDefaultQuoteAnnotation();
        a.order = annList.size() + 1;
        annList.add(a);       
        
    }
    
    public void remMVOffence() {
        remMVAnnotation(this.offenceList);
    }
    
    public void remMVLicence() {
        remMVAnnotation(this.licencetList);
    }
    
    public void remMVAccident() {
        remMVAnnotation(this.accidentList);
    }
    
  private void remMVAnnotation(List<InsuranceQuoteUtils.QuoteAnnotation> annList) {
      if (this.remAnnotation > 0) {
          InsuranceQuoteUtils.QuoteAnnotation a = annList.get(this.remAnnotation - 1);
          if (a.recId != null) {
              delete [SELECT Id FROM Insurance_Quote_Annotation__c WHERE Id = :a.recId];
          }
          annList.remove(this.remAnnotation-1);
          Integer i = 1;
          for (InsuranceQuoteUtils.QuoteAnnotation q : annList) {
              q.order = i;
              i++;
          }
      }
  }

  public boolean getDisplayGAPCustom() {
    return getHasGapInsProduct() || getIsGAPLiberty();
  }
    
  public void applyMV() {
      if (getIsPublicMode()) {
          System.debug('mvNCBProtection >> ' + mvNCBProtection);
          System.debug('mvWindscreenProtection >> ' + mvWindscreenProtection);
          System.debug('standardExcessSelected >> ' + mvExcessOptions.get(this.standardExcessSelected));
          System.debug('mvAmountCovered >> ' + mvAmountCovered);
          if (isValidForSubmission()) {
              //try {
              System.debug('Invoking WS...');
              //Setting values
              this.quote.MV_Standard_Excess__c = mvExcessOptions.get(this.standardExcessSelected);
              this.quote.NCB_Protection__c = mvNCBProtection;
              this.quote.Windscreen_Protection__c = mvWindscreenProtection;
              this.quote.MV_Amount_Covered__c = mvAmountCovered;
              
              if (String.isNotBlank(this.quote.Quote_Id__c)) {
                  InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
                  param.opp = InsuranceQuoteUtils.getOpportunityForInsuranceQuote(this.quoting.Opportunity__c);
                  param.quote = this.quote;
                  param.quoting = this.quoting;
                  param.processType = InsuranceQuoteUtils.PROCESS_MVPRESENTATION;
                  Map<String, List<String>> msgList = null;
                  if (!Test.isRunningTest()) {
                      msgList = InsuranceQuoteRestWS.getQuote(param);
                  }
                  if (msgList != null && msgList.containsKey('Error')) {
                      for (String msg : msgList.get('Error')) {
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                      }
                  } else {
                      this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quote.Id);
                      InsuranceQuoteUtils.refreshQuotingProductPremiums(this.quote, this.quoting);
                      update quoting;
                      this.loadMVData();
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote updated successfully.'));
                  }
              } else {
                  // Old Code - 2019-05-20
                  //InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
                  //param.opp = InsuranceQuoteUtils.getOpportunityForInsuranceQuote(this.quoting.Opportunity__c);
                  //param.quote = this.quote;
                  //param.quoting = this.quoting;
                  //param.preserveAcceptance = true;
                  //if (!Test.isRunningTest()) {
                  //    InsuranceQuoteWS.getQuote(param);
                  //    //Load quote
                  //    this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quote.Id);
                  //}
                  //InsuranceQuoteUtils.refreshQuotingProductPremiums(this.quote, this.quoting);
                  //update quoting;
                  //this.loadMVData();
                  //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote updated successfully.'));
              }
              //} catch (Exception e) {
              //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
              //}
          }
      } else {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
      }
  }
  
  private void loadMVData() {
      standardExcessSelected = 0;
      mvExcessOptions = new Map<Integer, Decimal>();
      mvAmountCovered = 0;
      if (this.quote != null) {
          mvNCBProtection = this.quote.NCB_Protection__c;
          mvWindscreenProtection = this.quote.Windscreen_Protection__c;
          if (this.quote.MV_Amount_Covered__c != null) {
              mvAmountCovered = this.quote.MV_Amount_Covered__c.setScale(0);
          }
          
          //Motor Vehicle options
          if (String.isNotBlank(this.quote.Motor_Vehicle__c)) {
              //Load exces options
              String opts = this.quote.MV_Basic_Excess_Options__c;
              if (String.isNotBlank(opts)) {
                  opts = opts.remove('[').remove(']');
                  String[] excess = opts.split(',');
                  Integer i = 0;
                  for (String e : excess) {
                      Decimal v = NumberUtils.convertToDecimal(e, false);
                      if (v == this.quote.MV_Standard_Excess__c) {
                          standardExcessSelected = i;
                      }
                      mvExcessOptions.put(i, v);
                      i++;
                  }
              }
          }
      }
  }
  
  public List<SelectOption> getExcessOptions() {
      List<SelectOption> r = new List<SelectOption>();
      for (Integer i : mvExcessOptions.keySet()) {
          r.add(new SelectOption(String.valueOf(i), '$' + mvExcessOptions.get(i).setScale(0).format()));
      }
      return r;
  }
  
  public String getMinAmountCovered() {
      if (this.quote != null && this.quote.MV_Amount_Covered_Min__c != null) {
          return this.quote.MV_Amount_Covered_Min__c.format();
      }
      return '$0';
  }
  
  public String getMaxAmountCovered() {
      if (this.quote != null && this.quote.MV_Amount_Covered_Max__c != null) {
          return this.quote.MV_Amount_Covered_Max__c.format();
      }
      return '$0';
  }
  
  private Boolean isValidForSubmission() {
      Boolean r = true;
      if (mvAmountCovered == null) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                      'Please fill Your Amount Covered.'));
          r = false;
      } else if (mvAmountCovered < this.quote.MV_Amount_Covered_Min__c || 
                  mvAmountCovered > this.quote.MV_Amount_Covered_Max__c) {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                                'Your Amount Covered must be between $' + getMinAmountCovered() + ' and $' + getMaxAmountCovered()));
                      r = false;
                  }
      return r;
  }
  public void reProcessQuoteRestService(){
    //Invoke WS
    List<String> errmsgs = new List<String>();
    try {
      InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
      this.o = InsuranceQuoteUtils.getOpportunityForInsuranceQuote(this.quoting.Opportunity__c);
      param.opp = this.o;
      param.quote = this.quote;
      param.quoting = this.quoting;
      param.processType = InsuranceQuoteUtils.PROCESS_PRESENTATION;
      param.preserveAcceptance = true;
      Map<String, List<String>> msgList = null;
      if (!Test.isRunningTest()) {
        msgList = InsuranceQuoteRestWS.getQuote(param);
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
      errmsgs.add(e.getMessage());
    }
    
    if (errmsgs != null && !errmsgs.isEmpty()) {
      this.quote.Status__c = 'Fail';
      InsuranceQuoteUtils.saveFailureReasons(this.quote.Id, errmsgs);
    }
  }
    
    public void reProcessQuote(){
      if (!getIsPublicMode()) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This is just a presentation preview.'));
        return;
      }
      System.debug('reProcessQuote...');
      this.currentWeeklyMV = 0.0;
      this.newWeeklyMV = 0.0;
      if (!isValidAddInfo()){ 
        return;
      }
      System.debug('reProcessQuote... Validation OK');
      if (getHasMvInsProduct() && String.isNotBlank(this.quote.MV_Declining_Notes__c)) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.quote.MV_Declining_Notes__c));
      }
      InsuranceQuoteUtils.createAcknowledgementForm(this.quote, this.quoting);
    }
    
    public void reProcessQuote2(){
      System.debug('reProcessQuote2...');
      InsuranceQuoteUtils.createAcknowledgementForm(this.quote, this.quoting);
      this.showMessages();
    }
    
    public Boolean getFailedQuotation() {
        Boolean r = false;
        if (this.quote != null) {
            if ('Fail'.equals(this.quote.Status__c)) {
                r = true;
            }
            if (String.isNotBlank(this.quote.MV_Declining_Notes__c)) {
                r = true;
            }
        }
        return r;
    }
    
    public Boolean getHasFullCompConfirmVariation() {
        Boolean r = false;
        if (this.newWeeklyMV != this.currentWeeklyMV) {
            r = true;
        }
        return r;
    }
    
    public String getMVDecliningNotes() {
        if (this.quote != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.quote.MV_Declining_Notes__c));
            return this.quote.MV_Declining_Notes__c;
        }
        return null;
    }
    
    // Warranty - Safeguard
    public Boolean getIsWarrantySafeguard() {
        if (getIsNWCRequired()) {
            if (String.isNotBlank(this.quoting.Insurance_NWC_TypeP__c) &&
                this.quoting.Insurance_NWC_TypeP__c.contains('Safeguard')) {
                    return true;
                }
        }
        return false;
    }
    // Warranty - Integrity
    public Boolean getIsWarrantyIntegrity() {
      if (getIsNWCRequired()) {
        if (String.isNotBlank(this.quoting.Insurance_NWC_TypeP__c) &&
          this.quoting.Insurance_NWC_TypeP__c.contains('Integrity')) {
          return true;
        }
      }
      return false;
    }
    // 
    public Boolean getHasAcceptedHealthProd() {
      return 'A'.equals(this.quoting.Insurance_AIC_Acceptance__c);
    }

    public Boolean getHasAcceptedNwcProd() {
      return 'A'.equals(this.quoting.Insurance_NWC_Acceptance__c);
    }
    
    public Boolean getIsMVSuncorp(){
        if('Suncorp'.equals(this.quoting.Insurance_MV_Type__c)){
            return true;
        }
        return false;
    }
    
    public Boolean getExcludeLTILPI() {
      if (this.lenderSettings != null) {
        return this.lenderSettings.Exclude_LTI_LPI__c;
      }	
      return false;
    }
    //Jesus Mora 2020-05-06 start
    public Boolean getLPIAccepted() {
        Boolean r = false;
        
        if (String.isNotBlank(this.quote.LPI__c)) {
            if (this.quoting != null && 'A'.equals(quoting.Insurance_AIC_Acceptance__c)) {
                r = true;
            }
        }
        return r;
    }
    //Jesus Mora 2020-05-06 end

    public Boolean isLiberty() {
      return InsuranceQuoteUtils.isLiberty(this.quoting);
    }
  
  public void addMessages(ApexPages.Severity severity, String message) {
    List<String> msgs = this.appMessages.get(severity);
    if (msgs == null) {
      msgs = new List<String>();
      this.appMessages.put(severity, msgs);
    }
    msgs.add(message);
  }

  public void showMessages() {
    if (this.appMessages !=null && !this.appMessages.isEmpty()) {
      for (ApexPages.Severity k: this.appMessages.keySet()) {
        List<String> msgs = this.appMessages.get(k);
        if (msgs != null && !msgs.isEmpty()) {
          for (String m: msgs) {
            ApexPages.addMessage(new ApexPages.Message(k, m));
          }
        }
      }
    }
  }

  public void loadPDSDocuments() {
    if (this.insdocsMap == null) {
      this.insdocsMap = new Map<String, Document>();
      // Identify documents
      Set<String> docs = new Set<String>();
      // GAP
      if (InsuranceQuoteUtils.displayLibertyGAPProduct(this.quoting)) {
        this.gapDoc = InsuranceQuoteUtils.PDS_Liberty_VEI_QF;
        docs.add(this.gapDoc);
      }
      // LPI
      if (InsuranceQuoteUtils.displayLibertyLPIProduct(this.quoting)) {
        this.lpiDoc = InsuranceQuoteUtils.PDS_Liberty_LPI_QF;
        docs.add(this.lpiDoc);
      }
      // WARR
      if (InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting)) {
        this.o = InsuranceQuoteUtils.getOpportunityForInsuranceQuote(this.quoting.Opportunity__c);
        String assetType = this.o.Application__r.Type_of_Asset__c;
        Set<String> fulldocs = InsuranceQuoteUtils.getPDSDocumentTypes(this.quoting, this.quote, assetType);
        for (String k: fulldocs) {
          if (k.containsIgnoreCase('Integrity')) {
            this.warrDoc = k;
            docs.add(this.warrDoc);
          }
        }        
      }
      // 
      if (!docs.isEmpty()) {
        List<Document> d = [
          SELECT Name, Type, Url, DeveloperName, Description, Body, BodyLength, ContentType 
          FROM Document WHERE DeveloperName IN :docs
        ];
        for (Document a : d) {
          this.insdocsMap.put(a.DeveloperName, a);
          System.debug(a.DeveloperName + ' => ' + a.Url);
        }
      }
      System.debug('gapDoc => ' + this.gapDoc);
      System.debug('lpiDoc => ' + this.lpiDoc);
      System.debug('warrDoc => ' + this.warrDoc);
    }
  }

  public Id getInsurancePDS(String doc) {
    Document d = null;
    if (String.isNotBlank(doc)) {
      d = this.insdocsMap.get(doc);
    }
    return d != null? d.Id : null;
  }

  public Id getGapDocumentId() {
    return this.getInsurancePDS(this.gapDoc);
  }

  public Id getLpiDocumentId() {
    return this.getInsurancePDS(this.lpiDoc);
  }

  public Id getWarrDocumentId() {
    return this.getInsurancePDS(this.warrDoc);
  }

  public Id getOrgId() {
    return UserInfo.getOrganizationId();
  }

  public String getIntegrityQ1() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_1');
  }

  public String getIntegrityQ2() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_2');
  }

  public String getIntegrityQ3() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_3');
  }

  public String getIntegrityQ4() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_4');
  }

  public String getIntegrityQ5() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_5');
  }

  public Boolean getIsPartnerUser() {
    return this.ownerAccount != null && !this.ownerAccount.Franchised__c;
  }

  public String getBusinessLogo() {
    return this.ownerAccount != null
      ? this.ownerAccount.Business_Logo__c : null;
  }

  public String getBusinessABN() {
    return this.ownerAccount != null
      ? this.ownerAccount.ABN__c : null;
  }

  public String getBusinessACL() {
    return this.ownerAccount != null
      ? this.ownerAccount.ACL__c : null;
  }

  public String getBusinessACN() {
    return this.ownerAccount != null
      ? this.ownerAccount.ACN__c : null;
  }

  public String getBusinessName() {
    return this.ownerAccount != null
      ? this.ownerAccount.Business_Name__c : null;
  }

  public Account getAccountVar() {
    if (this.o == null) {
      this.o = InsuranceQuoteUtils.getOpportunityForInsuranceQuote(this.quoting.Opportunity__c);
    }
    Id userId = this.quoting != null 
      ? this.o.OwnerId : UserInfo.getUserId();
    System.debug('@@userId: ' + userId);
    List<Contact> contactList = [
      SELECT FirstName, LastName, Email, AccountId 
      FROM Contact WHERE Id IN (
        SELECT ContactId FROM User WHERE Id = :userId
      )
    ];
    System.debug('@@contactList:' + JSON.serializePretty(contactList));
    if(!contactList.isEmpty() && contactList[0].AccountId != null){
      List<Account> accountList;
      accountList = [
        SELECT 
          Id, Name, Fax, Phone, BillingStreet, 
          BillingCity, BillingCountry, BillingState, 
          BillingPostalCode, Website, PersonMobilePhone, 
          Business_Name__c, Business_Logo__c, Franchised__c,
          ABN__c, ACL__c, ACN__c
        FROM Account WHERE Id =: contactList[0].AccountId limit 1
      ];
      System.debug('@@accountList[0]:' + JSON.serializePretty(accountList[0]));
      return accountList[0];
    }
    return null;
  }
}