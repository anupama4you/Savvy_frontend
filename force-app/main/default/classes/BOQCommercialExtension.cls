/**
 * @description       :
 * @author            : Girish P
 * @group             :
 **/
public class BOQCommercialExtension {
    BOQCalculatorCommercialHelper helper = new BOQCalculatorCommercialHelper();
    public Custom_Opportunity__c Opp;

    //Lelo                  2016-07-26
    private String fileGlobalPrefix = 'BOQ_Commercial';
    //-
    //Leandro                       2016-08-25
    public static Decimal MAX_BROKERAGE = 4.0;
    //-

    // finance calculator input
    public Decimal carPrice { get; set; }
    public Decimal deposit { get; set; }
    public Decimal applicationFee { get; set; }
    public Decimal dof { get; set; }
    public Decimal ppsr { get; set; }
    public Decimal residualValue { get; set; }
    //public Decimal brokerage {get;set;}
    public Decimal baseRate { get; set; }
    public Decimal clientRate { get; set; }

    public Integer term { get; set; }
    public Integer carAge { get; set; }
    public String paymentType { get; set; }
    //Lelo              2016-08-29
    public String privateSales { get; set; }
    //-
    //Lelo              2020-03-18
    public String propertyOwner { get; set; }
    public String manufactureYear { get; set; }
    public List<SelectOption> manufactureYearOptions { get; set; }
    // public Integer ltv { get; set; }
    //-
    public List<SelectOption> yesNoOptions { get; set; }
    public List<SelectOption> paymentTypes { get; set; }

    // finance calculator output
    public Decimal estimatedCommission { get; set; }
    public Decimal insuranceIncome { get; set; }
    public Decimal dofResult { get; set; }
    public Decimal totalCommission { get; set; }
    public Decimal totalCommissionGst { get; set; }

    public Decimal naf { get; set; }
    public Decimal rental { get; set; }
    public Decimal monthlyFee { get; set; }
    public Decimal monthlyPayment { get; set; }
    public Decimal fortnightlyPayment { get; set; }
    public Decimal weeklyPayment { get; set; }

    // insurance info
    public Decimal gap { get; set; }
    public Decimal gapIncome { get; set; }
    public Decimal warranty { get; set; }
    public Decimal warrantyIncome { get; set; }
    public Decimal lti { get; set; }
    public Decimal ltiIncome { get; set; }
    public Decimal truckGap { get; set; }
    public Decimal truckGapIncome { get; set; }
    public Decimal tai { get; set; }
    public Decimal taiIncome { get; set; }
    public Decimal mv { get; set; }
    public Decimal mvIncome { get; set; }
    public Decimal cci { get; set; }
    public Decimal cciIncome { get; set; }
    public String gapLevel { get; set; }
    public String warrantyLevel { get; set; }
    public String ltiLevel { get; set; }
    public String truckGapLevel { get; set; }
    public String taiLevel { get; set; }
    public String mvLevel { get; set; }
    //public String cciLevel {get;set;}
    public Decimal nwc { get; set; }
    public Decimal nwcIncome { get; set; }
    public Decimal totalInsurance { get; set; }

    public List<SelectOption> gapLevels { get; set; }
    public List<SelectOption> warrantyLevels { get; set; }
    public List<SelectOption> ltiLevels { get; set; }
    public List<SelectOption> truckGapLevels { get; set; }
    public List<SelectOption> taiLevels { get; set; }
    public List<SelectOption> mvLevels { get; set; }

    // Vehicle Details
    public String state { get; set; }
    public String vehicleGroup { get; set; }
    public String awd { get; set; }
    public String turbo { get; set; }
    public String diesel { get; set; }

    public List<SelectOption> stateOptions { get; set; }
    public List<SelectOption> vehicleGroupTypes { get; set; }

    // // rates references
    // public List<MacquarieCommercialRates__c> macquarieRates { get; set; }
    // Map<String, MacquarieCommercialRates__c> macquarieCommercialRates {
    //     get;
    //     set;
    // }

    // addtional loan information
    public String productLoanType { get; set; }
    public String productGoodsType { get; set; }
    // public String productGoodsSubType { get; set; }
    public List<SelectOption> productLoanTypes { get; set; }
    public List<SelectOption> productGoodsTypes { get; set; }
    // public List<SelectOption> productGoodsSubTypes { get; set; }
    public List<Selectoption> loanFrequencies { get; set; }
    public String loanFrequency { get; set; }
    public String selectedTypeValue { get; set; }
    public Decimal residualValuePercentage { get; set; }
    public Boolean isResidualValuePercentage { get; set; }
    // the real time NAF
    public Decimal realtimeNaf { get; set; }
    Map<String, id> RecordTypes { get; set; }
    public Decimal brokeragePercentage { get; set; }
    public static final String LENDER_QUOTING = 'BOQ Commercial';
    public Decimal tradeIn { get; set; }
    public Decimal payoutOn { get; set; }
    public Decimal netDeposit { get; set; }
    public String loanType { get; set; }
    public List<SelectOption> loanTypeOptions { get; set; }
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-

    public Boolean isCalculateUpdate { get; set; }
    // public Decimal mcqGrossPayment { get; set; }
    public Decimal mcqCustomerRate { get; set; }
    // public String mcqPaymentFrequency { get; set; }
    public String mcqMessageQuote { get; set; }
    public String mcqLastResponseQuote { get; set; }
    public String mcqApplicationId { get; set; }
    public String mcqMessageAppId { get; set; }
    public String mcqLastResponseApplication { get; set; }

    public String mcqUser { get; set; }
    public Boolean paramActive { get; set; }

    //Lelo                  Insurance                       2018-02-20
    public Application_Quoting__c quoting { get; set; }
    public Application_InsuranceQuote__c quote { get; set; }
    public String insuranceInputMode { get; set; }

    public String nwcPlan { get; set; }
    public String nwcTerm { get; set; }
    public Decimal nwcCost { get; set; }
    public String nwcAcceptance { get; set; }

    public String mvAcceptance { get; set; }
    public String gapAcceptance { get; set; }
    public String taiAcceptance { get; set; }
    public String ltiAcceptance { get; set; }
    public String warrantyAcceptance { get; set; }
    public String quoteIdSelected { get; set; }

    public Map<ApexPages.severity, List<String>> userMgs { get; set; }
    public String cciAcceptance { get; set; }
    //-
    //Yohan VillaLeal                      Insurance   12-07-2018
    public String cciLevel { get; set; }

    //NWC Calculator - HJ - 12-07-2018 - I
    public List<SelectOption> NWCPlanOptions { get; set; }
    public List<SelectOption> NWCTermOptions { get; set; }
    public List<SelectOption> NWCTypePOptions { get; set; }
    public String NWCMessage { get; set; }
    //public String assetType = null;
    public Boolean isAssetCar { get; set; }
    public Boolean isAssetBoat { get; set; }
    public Boolean isCategoryType { get; set; }
    public Boolean isNWCValidationOk { get; set; }
    public NWCCalc.Parameter nwcParam { get; set; }
    public Decimal priceCustomer = null;

    //NWC Warnings - I
    public Application_Asset_Detail__c aad = null;
    public Integer vehicleAgeYear = null;
    public String messageNWCWarning { get; set; }
    //NWC Warnings - F

    //NWC Calculator - HJ - 12-07-2018 - F

    public List<String> cciLevels = new List<String>{
        'Disability',
        'Disability/Unemployment'
    };

    private Lenders__c lenderSettings { get; set; }

    public BOQCommercialExtension(ApexPages.StandardController controller) {
        this.privateSales = 'N';
        String active = System.currentPageReference()
            .getParameters()
            .get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);

        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam = new NWCCalc.Parameter();
        //NWC Calculator - HJ - 12-07-2018 - F

        try {
            controller.addFields(new List<String>{ 'Application__c' });
        } catch (SObjectException e) {
        }

        RecordTypes = new Map<String, Id>();
        List<RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }

        //Lelo          Insurance           2017-12-04
        insuranceInputMode = 'A';
        //-

        lenderSettings = QuotingCalculation.getLenderSettings(LENDER_QUOTING);

        this.Opp = (Custom_Opportunity__c) controller.getRecord();
        //existingAttach = [Select id,name,description from attachment where parentID =: Opp.Id and Name like '%Macquarie_Consumer%'];

        //Lelo                              2016-08-20
        this.loanType = 'Purchase';
        this.productLoanType = 'Consumer Loan';
        //this.applicationFee = 395.00;
        //this.dof = 850.00;
        //this.applicationFee = 350.00;
        this.dof = lenderSettings.DOF__c;
        //-
        this.ppsr = lenderSettings.PPSR__c;
        this.term = 60;
        // this.ltv = null;
        //this.motorCycles = 'N';
        //this.caravanCampervans = 'N';
        this.paymentType = 'Advance';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.monthlyFee = lenderSettings.Monthly_Fee__c;
        // this.carAge = 4;
        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNaf = applicationFee + dof + ppsr;
        this.brokeragePercentage = MAX_BROKERAGE;

        this.resetCalculationResult();

        // macquarieCommercialRates = MacquarieCommercialRates__c.getAll();
        // System.debug('The map value: ' + macquarieCommercialRates);
        // macquarieRates = macquarieCommercialRates.values();
        // macquarieRates.sort();

        yesNoOptions = new List<SelectOption>();
        yesNoOptions.add(new SelectOption('', '--None--'));
        yesNoOptions.add(new SelectOption('Y', 'Yes'));
        yesNoOptions.add(new SelectOption('N', 'No'));
        paymentTypes = new List<SelectOption>();
        paymentTypes.add(new SelectOption('', '--None--'));
        paymentTypes.add(new SelectOption('Arrears', 'Arrears'));
        paymentTypes.add(new SelectOption('Advance', 'Advance'));
        stateOptions = new List<SelectOption>();
        stateOptions.add(new SelectOption('', '--None--'));
        vehicleGroupTypes = new List<SelectOption>();
        vehicleGroupTypes.add(new SelectOption('', '--None--'));
        gapLevels = new List<SelectOption>();
        gapLevels.add(new SelectOption('', '--None--'));
        warrantyLevels = new List<SelectOption>();
        warrantyLevels.add(new SelectOption('', '--None--'));
        ltiLevels = new List<SelectOption>();
        ltiLevels.add(new SelectOption('', '--None--'));
        truckGapLevels = new List<SelectOption>();
        truckGapLevels.add(new SelectOption('', '--None--'));
        taiLevels = new List<SelectOption>();
        taiLevels.add(new SelectOption('', '--None--'));
        mvLevels = new List<SelectOption>();
        mvLevels.add(new SelectOption('', '--None--'));
        loanTypeOptions = QuotingToolHelper.getLoanTypeOptions();
        loanType = loanTypeOptions.get(0).getValue();
        productLoanTypes = QuotingToolHelper.getLoanProductOptionsCommercial();
        productLoanType = productLoanTypes.get(0).getValue();
        productGoodsTypes = getBOQAssetType();
        productGoodsType = productGoodsTypes.get(0).getValue();
        loadLoanFrequency();
        selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        resetResidualValues();

        preLoadQuotingValues();
        isCalculateUpdate = false;

    } // end of constructor

    private void preLoadQuotingValues() {
        //Get parameters
        String paramTmp = System.currentPageReference()
            .getParameters()
            .get('preloadQuting');
        if ('1'.equals(paramTmp)) {
            List<Custom_Opportunity__c> oppList = [
                SELECT Pre_Quoting_Object__c
                FROM Custom_Opportunity__c
                WHERE ID = :this.Opp.Id
            ];
            System.debug(
                'Preloading values from comparison engine >> ' +
                oppList[0].Pre_Quoting_Object__c
            );
            try {
                LenderQuotingWrapperDTO lender = (LenderQuotingWrapperDTO) JSON.deserializeStrict(
                    oppList[0].Pre_Quoting_Object__c,
                    LenderQuotingWrapperDTO.class
                );
                if (
                    lender != null &&
                    lender.info != null &&
                    'MCOM'.equals(lender.info.Code__c)
                ) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productLoanType = lender.productLoanType;
                    this.productGoodsType = lender.productGoodsType;
                    // this.productGoodsSubType = lender.productGoodsSubType;
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
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
            LENDER_QUOTING
        );
        // param.ltv = String.valueOf(ltv);
        param.customerProfile = propertyOwner;
        param.term = term;
        param.privateSales = privateSales;
        param.totalAmount = financeAmount;
        param.goodsType = productGoodsType;
        // param.goodsSubType = productGoodsSubType;
        param.vehicleYear = manufactureYear;
        param.brokeragePer = brokeragePercentage;
        param.productLoanType = productLoanType;
        // this.baseRate = QuotingCalculation.getBaseRate(param);
        this.baseRate = getInterestRates();
        System.debug(baseRate + '***baseRate');
        if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Brokerage cannot be greater than ' +
                    MAX_BROKERAGE.format() +
                    '%'
                )
            );
        }

        totalInsurance = this.getTotalInsuranceType(
            QuotingCalculation.CALC_QUOTING
        );

        param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.term = term;
        param.baseRate = baseRate;
        param.totalAmount = financeAmount;
        if (brokeragePercentage != null) {
            param.amountBasePmt = getBaseAmountPmtInclBrokerageCalc(
                QuotingCalculation.CALC_QUOTING
            );
        }
        param.paymentType = paymentType;
        param.residualValue = this.residualValue;
        this.clientRate = QuotingCalculation.getClientRateCalculation(param);
        system.debug(param + 'param***');
        system.debug(this.clientRate + 'this.clientRate***');
        // system.debug('clientRate (2)  >> ' + clientRate);
    } //end of funcion

    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtCalc(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null)
                r +=
                    carPrice +
                    (carPrice *
                    QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null)
                r += carPrice;
        }
        r += this.getTotalInsuranceType(calcType);
        if (netDeposit != null)
            r -= netDeposit;
        return r;
    }
    //Lelo          2017-07-26
    public Decimal getBaseAmountPmtInclBrokerageCalc(String calcType) {
        Decimal r = getRealtimeNaf(calcType);
        if (brokeragePercentage != null && brokeragePercentage != 0) {
            // r += (getBaseAmountPmtCalc(calcType) * brokeragePercentage/100);
            r += (r * brokeragePercentage / 100);
        }
        return r;
    }

    public void realtimeNafCalc() {
        netDepositCalc();
        realtimeNaf = this.getRealtimeNaf(QuotingCalculation.CALC_QUOTING);
        totalInsurance = this.getTotalInsuranceType(
            QuotingCalculation.CALC_QUOTING
        );
        this.ericLPICalculate();
    } //end of funcion

    //Lelo              2017-07-26
    public Decimal getRealtimeNaf(String calcType) {
        Decimal r = 0.0;
        netDepositCalc();
        if (carPrice != null) {
            if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
                r +=
                    carPrice +
                    (carPrice *
                    QuotingCalculation.getProtectedPercentaje(carPrice));
            } else {
                r += carPrice;
            }
            if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE) {
                residualValue = (carPrice * residualValuePercentage) / 100;
            }
        }
        if (applicationFee != null)
            r += applicationFee;
        if (dof != null)
            r += dof;
        if (ppsr != null)
            r += ppsr;
        if (netDeposit != null)
            r -= netDeposit;
        r += this.getTotalInsuranceType(calcType);
        System.debug('****naf***' + r);
        return r;
    }

    public void applicationFeefCalc() {
        if ('Y'.equals(privateSales) || 'Sale & Lease Back'.equals(loanType)) {
            applicationFee = lenderSettings.Application_Fee_Private__c;
        } else {
            applicationFee = lenderSettings.Application_Fee__c;
        }
        realtimeNafCalc();
    }

    public void warrantyPriceCalc() {
        Decimal warrantyPrice = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();

        if (vehicleGroup == null || vehicleGroup == '') {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Please choose a vehicle group value for accurate warranty price.'
                )
            );
        } else {
            if (integer.valueOf(vehicleGroup) == 4) {
                warrantyPrice = 0;
            } else {
                if (warrantyLevel == null || warrantyLevel == '') {
                } else {
                    warrantyPrice =
                        allWarrantyLevels.get(warrantyLevel).Amount__c + 44;
                    if (integer.valueOf(vehicleGroup) == 2) {
                        warrantyPrice = warrantyPrice + 110;
                    } else if (integer.valueOf(vehicleGroup) == 3) {
                        warrantyPrice = warrantyPrice + 220;
                    }

                    if (awd == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (turbo == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (diesel == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                } // end of if else warrantyLevel
            } // end of if else vehicleGroup == 4
        } // end of if else vehicleGroup == null

        warranty = warrantyPrice.setScale(2);

        if (state == null || state == '') {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Please choose a State value for accurate Stamp Duty and Insurance Income.'
                )
            );
        }
    } //end of funcion

    public void warrantyIncomeCalc() {
        Decimal warrantyPrice = 0;
        Decimal stampDuty = 0;
        Decimal gst = 0;
        Decimal govCharge = 0;
        Decimal netPremium = 0;
        Decimal warrantyCommission = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();

        if (vehicleGroup == null || vehicleGroup == '') {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Please choose a vehicle group value for accurate warranty price.'
                )
            );
        } else {
            if (integer.valueOf(vehicleGroup) == 4) {
                warrantyCommission = 0;
            } else {
                if (warrantyLevel == null || warrantyLevel == '') {
                } else {
                    warrantyPrice = allWarrantyLevels.get(warrantyLevel)
                        .Amount__c;

                    if (state == null || state == '') {
                        ApexPages.addMessage(
                            new ApexPages.Message(
                                ApexPages.Severity.WARNING,
                                'Please choose a State value for accurate Stamp Duty and Insurance Income.'
                            )
                        );
                        warrantyPrice = 0;
                    } else {
                        if (state == 'ACT') {
                            stampDuty = warrantyPrice * 0.02 / (1 + 0.02);
                        } else if (state == 'NSW') {
                            stampDuty = warrantyPrice * 0.05 / (1 + 0.05);
                        } else if (state == 'NT') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (state == 'QLD') {
                            stampDuty = warrantyPrice * 0.09 / (1 + 0.09);
                        } else if (state == 'SA') {
                            stampDuty = warrantyPrice * 0.11 / (1 + 0.11);
                        } else if (state == 'TAS') {
                            stampDuty = warrantyPrice * 0.08 / (1 + 0.08);
                        } else if (state == 'VIC') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (state == 'WA') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        }
                    } // end if else state == null
                } // end if else warrantyLevel == null

                System.debug('Stamp Duty: ' + stampDuty);

                gst = ((warrantyPrice - stampDuty) * 0.10) / (1 + 0.10);
                System.debug('GST: ' + gst);
                govCharge = stampDuty + gst;
                System.debug('Government Charge: ' + govCharge);
                netPremium = warrantyPrice - govCharge;
                System.debug('Net Premium: ' + netPremium);

                warrantyCommission = netPremium * 0.5293;
                System.debug('The Commission: ' + warrantyCommission);
            } // end if else vehicleGroup == 4
        } // end of if else vehicleGroup == null

        warrantyCommission = warrantyCommission * 1.1;
        warrantyIncome = warrantyCommission.setScale(2);
    } //end of function

    public void validate() {
        isValidCalculate();
    } //end of function

    public Boolean isValidCalculate() {
        Boolean r = true;
        this.ericLPICalculate();
        if (clientRate > 14.75) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Client Rate cannot be larger than 14.75%.'
                )
            );
            r = false;
        }
        if (term > 60) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Term cannot be longer than five years.'
                )
            );
            r = false;
        }
        if (realtimeNaf < 10000) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Financed Amount cannot be less than $10,000.'
                )
            );
            r = false;
        }
        // validation before calculation
        if (clientRate == null || clientRate <= 0.0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Client Rate cannot be Zero.'
                )
            );
            r = false;
        }
        if (baseRate == null || baseRate == 0.0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Base Rate cannot be Zero.'
                )
            );
            r = false;
        }
        if (term == null || term == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please choose an appropriate term.'
                )
            );
            r = false;
        }
        if (String.isBlank(manufactureYear)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please choose an Asset Year option.'
                )
            );
            r = false;
        }
        if (String.isBlank(privateSales)) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please choose a Private Sale option.'
                )
            );
            r = false;
        }
        if (
            String.isNotBlank(privateSales) &&
            'Y'.equalsIgnoreCase(privateSales)
        ) {
            helper.addError(helper.ERROR_MESSAGE_PRIVATE_SALE);
            r = false;
        }
        
        if (
            String.isNotBlank(propertyOwner) &&
            'N'.equalsIgnoreCase(propertyOwner)
        ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, helper.ERROR_MESSAGE_NOT_OWNER));
            // r = false;
        }
        if (brokeragePercentage > MAX_BROKERAGE) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Brokerage cannot be greater than ' +
                    MAX_BROKERAGE.format() +
                    '%'
                )
            );
            r = false;
        }
        //Lelo              2017-09-19
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'You cannot have a balloon or residual payment when the loan term is > 5 years.'
                )
            );
            r = false;
        }
        return r;
    }

    public PageReference calculate() {
        baseRateCalc();
        system.debug('isValidCalculate****' + isValidCalculate());
        if (!isValidCalculate()) {
            system.debug('isValidCalculate****' + isValidCalculate());
            return null;
        }
        this.calculateRepayments();
        // if (estimatedCommission <= 0) {
        // 	helper.addError('The commission is below zero. Please make adjustment to make sure commission is above zero.');
        // }

        isCalculateUpdate = true;
        return null;
    } // end of function

    public PageReference reset() {
        this.loanType = 'Purchase';
        this.productLoanType = 'Chattel Mortgage-Full-Doc';
        this.carPrice = 0.00;
        this.deposit = 0.00;
        this.tradeIn = 0.00;
        this.payoutOn = 0.00;
        netDepositCalc();
        //this.applicationFee = 350.00;
        this.dof = lenderSettings.DOF__c;
        this.ppsr = lenderSettings.PPSR__c;
        this.residualValue = 0.00;
        this.residualValuePercentage = 0.00;
        this.selectedTypeValue = MacquarieConstants.TYPE_VALUE;
        this.baseRate = 0.00;
        this.clientRate = 0.00;
        this.term = 60;
        this.propertyOwner = 'N';
        // this.ltv = null;
        this.brokeragePercentage = MAX_BROKERAGE;
        // this.carAge = 0;
        //this.motorCycles = 'N';
        //this.caravanCampervans = 'N';
        this.paymentType = 'Advance';
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

        //Insurance Products
        this.mvLevel = null;
        this.mv = 0.00;
        this.mvIncome = 0.00;
        this.mvAcceptance = 'U';

        this.gapLevel = null;
        this.gap = 0.00;
        this.gapIncome = 0.00;
        this.gapAcceptance = 'U';

        this.taiLevel = null;
        this.tai = 0.00;
        this.taiIncome = 0.00;
        this.taiAcceptance = 'U';

        this.ltiLevel = null;
        this.lti = 0.00;
        this.ltiIncome = 0.00;
        this.ltiAcceptance = 'U';

        this.warrantyLevel = null;
        this.warranty = 0.00;
        this.warrantyIncome = 0.00;
        this.warrantyAcceptance = 'U';

        this.nwc = 0.00;
        this.nwcIncome = 0.00;
        this.nwcAcceptance = 'U';
        this.nwcPlan = null;
        this.nwcTerm = null;
        this.nwcCost = null;

        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam.awd4wd = null;
        nwcParam.luxuryCar = null;
        nwcParam.type_p = null;
        nwcParam.isManuallyNWCPrice = false;
        //NWC Calculator - HJ - 12-07-2018 - F

        //Lelo                  Insurance           2018-02-26
        this.cci = 0.00;
        this.cciIncome = 0.00;
        this.cciAcceptance = 'U';

        this.quoteIdSelected = null;
        this.quote = new Application_InsuranceQuote__c();
        //-

        this.state = '';
        this.vehicleGroup = '1';
        this.awd = 'N';
        this.turbo = 'N';
        this.diesel = 'N';
        this.productGoodsType = '';
        // this.productGoodsSubType = '';
        this.loanFrequency = '';

        this.assetYearOption();
        this.applicationFeefCalc();
        this.realtimeNaf = applicationFee + dof + ppsr;
        isCalculateUpdate = false;

        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    } // end of function

    private PageReference savePdf(String prefixName) {
        // validate the calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please calculate before generating the Pdf.'
                )
            );
            return null;
        }

        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id', Opp.Id);
        calcPdf.getParameters()
            .put('lender', 'BANK OF QUEENSLAND COMMERCIAL CALCULATION');
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));

        calcPdf.getParameters()
            .put('applicationFee', String.valueOf(applicationFee));
        calcPdf.getParameters().put('dof', String.valueOf(dof));
        calcPdf.getParameters().put('ppsr', String.valueOf(ppsr));
        calcPdf.getParameters().put('selectedTypeValue', selectedTypeValue);
        calcPdf.getParameters()
            .put(
                'residualValuePercentage',
                String.valueOf(residualValuePercentage)
            );
        calcPdf.getParameters()
            .put('residualValue', String.valueOf(residualValue));
        calcPdf.getParameters()
            .put('brokeragePercentage', String.valueOf(brokeragePercentage));
        calcPdf.getParameters().put('baseRate', String.valueOf(baseRate));
        calcPdf.getParameters()
            .put('clientRate', String.valueOf(clientRate.setScale(2)));
        calcPdf.getParameters().put('term', String.valueOf(term));
        calcPdf.getParameters().put('paymentType', paymentType);
        calcPdf.getParameters()
            .put('estimatedCommission', String.valueOf(estimatedCommission));
        calcPdf.getParameters()
            .put('insuranceIncome', String.valueOf(insuranceIncome));
        calcPdf.getParameters().put('dofResult', String.valueOf(dofResult));
        calcPdf.getParameters()
            .put('totalCommission', String.valueOf(totalCommission));
        calcPdf.getParameters()
            .put('totalCommissionGst', String.valueOf(totalCommissionGst));
        calcPdf.getParameters().put('naf', String.valueOf(naf));
        calcPdf.getParameters().put('rental', String.valueOf(rental));
        calcPdf.getParameters().put('monthlyFee', String.valueOf(monthlyFee));
        calcPdf.getParameters()
            .put('monthlyPayment', String.valueOf(monthlyPayment));
        calcPdf.getParameters()
            .put('fortnightlyPayment', String.valueOf(fortnightlyPayment));
        calcPdf.getParameters()
            .put('weeklyPayment', String.valueOf(weeklyPayment));
        // pass varaibles for Macquarie Commercial
        // calcPdf.getParameters().put('carAge', String.valueOf(carAge));
        calcPdf.getParameters().put('privateSales', privateSales);
        //calcPdf.getParameters().put('motorCycles', motorCycles);
        //calcPdf.getParameters().put('caravanCampervans', caravanCampervans);
        // pass variables about the product info
        // if (ltv != null) {
        //     calcPdf.getParameters().put('ltv', String.valueOf(ltv));
        // }
        calcPdf.getParameters().put('customerProfile', propertyOwner);
        calcPdf.getParameters().put('carAge', manufactureYear);

        calcPdf.getParameters().put('productGoodsType', productGoodsType);
        // calcPdf.getParameters().put('productGoodsSubType', productGoodsSubType);
        calcPdf.getParameters().put('loanFrequency', loanFrequency);
        calcPdf.getParameters().put('carPrice', String.valueOf(carPrice));

        calcPdf.getParameters().put('loanType', loanType);
        calcPdf.getParameters().put('productLoanType', productLoanType);

        if (deposit != null) {
            calcPdf.getParameters().put('deposit', String.valueOf(deposit));
        }
        if (tradeIn != null) {
            calcPdf.getParameters().put('tradeIn', String.valueOf(tradeIn));
        }
        if (payoutOn != null) {
            calcPdf.getParameters().put('payoutOn', String.valueOf(payoutOn));
        }
        calcPdf.getParameters().put('netDeposit', String.valueOf(netDeposit));

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
                Opp.Application__c,
                typeData,
                typeData,
                QuotingToolHelper.getApplicationQuoting(Opp.Application__c)
            );
        }
        QuotingToolHelper.attachPdfFile(
            Opp.Id,
            prefixName,
            calcPdf,
            isSaveInCloud
        );

        ApexPages.addMessage(
            new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Calculation saved successfully.'
            )
        );
        return null;
    } // end of function

    private PageReference saveProduct(String prefixName) {
        //Recalculate
        if (!isValidCalculate()) {
            return null;
        }
        calculate();

        // validate calculation
        if (rental == null || rental == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please calculate before sending for approval.'
                )
            );
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }

        if (this.Opp.Application__c == null) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Please create or assoiciate an Application Forma before saving for any approval process.'
                )
            );
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
        savePdf(prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
            // first create a finance product
            updateProduct = new Product__c(
                RecordTypeId = RecordTypes.get('Finance'),
                Opportunity_Name__c = this.Opp.Id
            );
        } else {
            // first update the finance product
            updateProduct = [
                SELECT
                    id,
                    Loan_Purpose__c,
                    Lender__c,
                    Repayment_Regularity__c,
                    Loan_Type__c,
                    Loan_Term__c,
                    Balloon_Residual_Requested__c,
                    Client_Rate__c,
                    Payments__c,
                    Cost_of_Goods__c,
                    Deposit__c,
                    Brokerage__c,
                    Lender_App_Fee__c,
                    Equalisation_Fee_PPSR__c,
                    DOF__c,
                    Quoting_Source__c,
                    Loan_Type_Detail__c,
                    Loan_Product__c
                FROM Product__c
                WHERE id = :Opp.Loan_Product__c
            ];
        }
        //-

        updateProduct.Loan_Purpose__c = 'Business Use';
        updateProduct.Lender__c = 'Bank Of Queensland';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        //updateProduct.Loan_Type_Detail__c = loanTypeDetail;

        //if (productLoanType == null || productLoanType == '') {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Loan Type is not updated as the calculator does not contain relevant info.'));
        //} else {
        //    updateProduct.Loan_Type__c = productLoanType;
        //}
        if (term == null || term == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Term is not updated as the calculator does not contain relevant info.'
                )
            );
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
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Client Rate is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Client_Rate__c = 0;
        } else {
            updateProduct.Client_Rate__c = clientRate;
        }
        if (monthlyPayment == null || monthlyPayment == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Payment is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Payments__c = 0;
        } else {
            updateProduct.Payments__c = monthlyPayment;
        }
        if (carPrice == null || carPrice == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Cost of Goods is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Cost_of_Goods__c = 0;
        } else {
            updateProduct.Cost_of_Goods__c = carPrice;
        }
        if (netDeposit == null) {
            updateProduct.Deposit__c = 0;
        } else {
            updateProduct.Deposit__c = netDeposit;
        }
        if (dof == null || dof == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'DOF is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.DOF__c = 0;
        } else {
            updateProduct.DOF__c = dof;
        }
        if (estimatedCommission == null || estimatedCommission == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Estimated Commission is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Brokerage__c = 0.00;
        } else {
            updateProduct.Brokerage__c = estimatedCommission;
        }
        if (applicationFee == null || applicationFee == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Application Fee is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Lender_App_Fee__c = 0;
        } else {
            updateProduct.Lender_App_Fee__c = applicationFee;
        }
        if (ppsr == null || ppsr == 0) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'PPSR is not updated as the calculator does not contain relevant info.'
                )
            );
            updateProduct.Equalisation_Fee_PPSR__c = 0;
        } else {
            updateProduct.Equalisation_Fee_PPSR__c = ppsr;
        }

        //Lelo                      2018-02-20
        if (updateProduct.Id == null) {
            insert updateProduct;
            Opp.Loan_Product__c = updateProduct.Id;
            update this.Opp;
        } else {
            update updateProduct;
        }
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        
        //Lelo                              2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-

        ApexPages.addMessage(
            new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Product updated successfully.'
            )
        );
        return null;
    } // end of function

    //Lelo                                  2016-07-26
    public PageReference saveQuoting() {
        if (
            hasCalculationDone() &&
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)
        ) {
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
    //-

    //Lelo                                  2016-12-22
    public void netDepositCalc() {
        netDeposit = 0;
        if (deposit != null)
            netDeposit += deposit;
        if (tradeIn != null)
            netDeposit += tradeIn;
        if (payoutOn != null)
            netDeposit -= payoutOn;
    }

    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(
            this.Opp.Id,
            this.Opp.Application__c
        );
        // Lelo             Insurance           2017-12-04
        this.quoting = d;
        Boolean sameQuoting = false;
        //--
        if (d != null) {
            System.debug('A quoting has been loading...');

            //Lelo          Insurance               2017-12-04
            if (LENDER_QUOTING.equals(d.Name)) {
                sameQuoting = true;
            }

            if (String.isBlank(d.Insurance_Input_Mode__c)) {
                insuranceInputMode = 'M';
            } else {
                insuranceInputMode = d.Insurance_Input_Mode__c;
            }
            //--
            if (sameQuoting) {
                this.quoteIdSelected = d.App_Insurance_Quote__c;
                this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(
                    this.quoteIdSelected
                );
                //Lelo              Insurance           2017-12-04
                if (this.quote != null) {
                    if (!LENDER_QUOTING.equals(this.quote.Financier_Name__c)) {
                        this.quoteIdSelected = null;
                        d.App_Insurance_Quote__c = null;
                        this.quote = null;
                    }
                }
                
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
            residualValuePercentage = d.Residual_Value_Percentage__c;

            if (
                d.Residual_Value_Percentage__c != null &&
                d.Residual_Value_Percentage__c != 0
            ) {
                selectedTypeValue = MacquarieConstants.TYPE_PERCENTAGE;
            } else {
                selectedTypeValue = MacquarieConstants.TYPE_VALUE;
            }

            if (d.Term__c != null) {
                term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                applicationFee = d.Application_Fee__c;
                dof = d.DOF__c;
                ppsr = d.PPSR__c;
                monthlyFee = d.Monthly_Fee__c;

                productGoodsType = d.Goods_type__c;
                if (String.isNotBlank(productLoanType)) {
                    loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(
                        productLoanType
                    );
                }
                loanFrequency = d.Loan_Frequency__c;
                brokeragePercentage = d.Brokerage__c;
                privateSales = d.Private_Sales__c;
                paymentType = d.Payment__c;
                
                manufactureYear = d.Vehicle_Age__c;
                
                propertyOwner = d.Customer_Profile__c;

                //Calculations
                applicationFeefCalc();
                baseRateCalc();

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

                //Load calculations
                this.ericLPICalculate();
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(
                    d.Id
                );

                //Lelo              Insurance               2017-12-04
                //Insurance Quote Product loading
                if (
                    'M'.equals(insuranceInputMode) &&
                    d.App_Insurance_Quote__c != null
                ) {
                    //this.adjustInsuranceProduct();
                    insuranceInputMode = 'A';
                    System.debug('cleaning 1...');
                }
                //-
            }
            realtimeNafCalc();
            // mcqGrossPayment = d.Mcq_Gross_Payment__c;
            mcqCustomerRate = d.Mcq_Customer_Rate__c;
            // mcqPaymentFrequency = d.Mcq_Payment_Frequency__c;
            mcqMessageQuote = d.Mcq_Message_Quote__c;
            mcqLastResponseQuote = d.Mcq_Last_Response_Quote__c;
            mcqApplicationId = d.Mcq_Application_Id__c;
            mcqMessageAppId = d.Mcq_Message_Application_Id__c;
            mcqLastResponseApplication = d.Mcq_Last_Response_Application__c;

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        }
        //Lelo              Insurance           2017-12-04
        if (this.quote == null) {
            this.quote = new Application_InsuranceQuote__c();
        }
        //-
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);

        //NWC Warning - I
        if (
            nwcParam != null &&
            nwcParam.vehicleAgeYears != null &&
            nwcParam.vehicleAgeYears > 20
        ) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'No car more than 20 years old can be covered. VechileYear: ' +
                    nwcParam.vehicleAgeYears
                )
            );
            return;
        }
        //NWC Warning - F

        Application_Quoting__c d = new Application_Quoting__c();
        if (this.quoting != null) {
            d = this.quoting;
        }
        //Associate Application / Opportunity
        d.Application__c = this.Opp.Application__c;
        d.Opportunity__c = this.Opp.Id;
        //Lender
        d.Name = LENDER_QUOTING;
        
        //Finance Details
        d.Loan_Type__c = loanType;
        d.Loan_Product__c = productLoanType;
        d.Goods_type__c = productGoodsType;
        // d.Goods_sub_type__c = productGoodsSubType;
        d.Loan_Frequency__c = loanFrequency;
        d.Vehicle_Price__c = carPrice;
        d.Deposit__c = deposit;
        d.Trade_In__c = tradeIn;
        d.Payout_On__c = payoutOn;

        d.Application_Fee__c = applicationFee;
        d.DOF__c = dof;
        d.PPSR__c = ppsr;
        d.Residual_Value__c = residualValue;
        d.Residual_Value_Percentage__c = null;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE) {
            d.Residual_Value_Percentage__c = residualValuePercentage;
        }

        d.Brokerage__c = brokeragePercentage;
        d.Base_Rate__c = baseRate;
        d.Client_Rate__c = clientRate;

        d.Monthly_Fee__c = monthlyFee;

        //Loan Details
        if (term != null) {
            d.Term__c = Decimal.valueOf(term);
        }
        d.Payment__c = paymentType;
        d.Private_Sales__c = privateSales;
        // d.LTV__c = null;
        // if (ltv != null) {
        //     d.LTV__c = String.valueOf(ltv);
        // }
        d.Vehicle_Age__c = manufactureYear;
        d.Customer_Profile__c = propertyOwner;

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

    // public void changeLoanProduct() {
    //     productGoodsTypes = QuotingToolHelper.getProductGoodsTypeOptions(
    //         productLoanType
    //     );
    //     productGoodsType = productGoodsTypes.get(0).getValue();
    //     // changeGoodsType();
    //     loadLoanFrequency();
    // }

    // public void changeGoodsType() {
    //     productGoodsSubTypes = QuotingToolHelper.getProductGoodsSubTypeOptions(
    //         productLoanType,
    //         productGoodsType
    //     );
    //     productGoodsSubType = productGoodsTypes.get(0).getValue();
    //     // this.assetYearOption();
    //     this.baseRateCalc();
    // }

    public void loadLoanFrequency() {
        loanFrequencies = QuotingToolHelper.getLoanFrequenciesOptions(
            productLoanType
        );
        loanFrequency = loanFrequencies.get(0).getValue();
    }

    public void resetResidualValues() {
        residualValue = 0.0;
        residualValuePercentage = 0.0;
        isResidualValuePercentage = false;
        if (selectedTypeValue == MacquarieConstants.TYPE_PERCENTAGE) {
            isResidualValuePercentage = true;
        }
    }

    //Lelo                      Insurance                   2017-12-04
    
    public String getLenderQuoting() {
        return LENDER_QUOTING;
    }

    public Application_Quoting_Result__c getSimpleResult() {
        return getCalcResult(QuotingCalculation.CALC_SIMPLE);
    }

    public Application_Quoting_Result__c getProFullyResult() {
        return getCalcResult(QuotingCalculation.PRO_FULLY);
    }

    public Application_Quoting_Result__c getProStandardResult() {
        return getCalcResult(QuotingCalculation.PRO_STANDARD);
    }

    public Application_Quoting_Result__c getProBasicResult() {
        return getCalcResult(QuotingCalculation.PRO_BASIC);
    }

    private Decimal getGapTai() {
        Decimal r = 0.0;
        return r;
    }

    private Decimal getWarrNwc() {
        Decimal r = 0.0;
        return r;
    }

    private Decimal getGapTaiIncome() {
        Decimal r = 0.0;
        return r;
    }

    private Decimal getWarrNwcIncome() {
        Decimal r = 0.0;
        return r;
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
                    System.debug(k + '|' + m);
                    ApexPages.addMessage(new ApexPages.Message(k, m));
                }
            }
        }
    }

    public Boolean getHasUserMessages() {
        Boolean r = false;
        if (userMgs != null && !userMgs.isEmpty()) {
            r = true;
        }
        return r;
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
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Please calculate before proceeding with your request.'
                    )
                );
                r = false;
            }
        }
        return r;
    }

    public void sendCustomerEmail1() {
        System.debug('sendCustomerEmail1...');
        if (
            hasCalculationDone() &&
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)
        ) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (
            hasCalculationDone() &&
            !InsuranceQuoteUtils.isQuotePresenting(this.quote)
        ) {
            try {
                Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(
                    this.Opp.Id,
                    this.Opp.Application__c
                );
                EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(
                    this.Opp,
                    q
                );
                EmailSender.sendQuotingEmailToCustomer(param);
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.INFO,
                        'Your email has been sent it.'
                    )
                );
            } catch (EmailException e) {
                System.debug('Error: ' + e.getMessage());
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        e.getMessage()
                    )
                );
            }
        }
    }
    //-

    //Lelo                      2017-07-24
    private Decimal getTotalAmount(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;
        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null)
                r +=
                    carPrice +
                    (carPrice *
                    QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null)
                r += carPrice;
        }
        if (applicationFee != null)
            r += applicationFee;
        if (dof != null)
            r += dof;
        if (ppsr != null)
            r += ppsr;
        //if (registrationFee != null) r += registrationFee;
        if (netDeposit != null)
            r -= netDeposit;

        return r;
    }

    private Decimal getTotalInsuranceType(String calcType) {
        Decimal r = 0.0;
        //if (nwc != null) r += nwc;
        //if (gap != null) r += gap;
        //if (warranty != null) r += warranty;
        //if (lti != null) r += lti;
        //if (truckGap != null) r += truckGap;
        //if (tai != null) r += tai;
        //if (mv != null) r += mv;
        //if (cci != null) r += cci;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            //Quote Insurances
            //if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
            //    if (mv != null) r += mv;
            //}
            if ('A'.equals(gapAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (gap != null)
                    r += gap;
            }
            if ('A'.equals(taiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (tai != null)
                    r += tai;
            }
            if ('A'.equals(ltiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (lti != null)
                    r += lti;
            }
            if (
                'A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)
            ) {
                if (warranty != null)
                    r += warranty;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwc != null)
                    r += nwc;
            }
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (cci != null)
                    r += cci;
            }
            //-
        } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            //Yohan VillaLeal
            r = getGapTai();
            r += getWarrNwc();

            if (getHasLti()) {
                r += getLtiCci();
            } else {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType) + r;
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if (results != null) {
                    r += results.premium;
                }
            }
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r = getGapTai();
            //Lelo                  Insurance           2018-02-26
            r += getWarrNwc();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r = getGapTai();
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            //if (mv != null) r += mv;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (gap != null)
                r += gap;
        } else if (InsuranceQuoteUtils.INS_PROD_TAI.equals(calcType)) {
            if (tai != null)
                r += tai;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (lti != null)
                r += lti;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warranty != null)
                r += warranty;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (cci != null) {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if (results != null) {
                    r = results.premium;
                }
            }
        }
        return r;
    }

    private Decimal getTotalInsuranceIncomeType(String calcType) {
        Decimal r = 0.0;
        //if (nwcIncome != null) r += nwcIncome;
        //if (gapIncome != null) r += gapIncome;
        //if (warrantyIncome != null) r += warrantyIncome;
        //if (ltiIncome != null) r += ltiIncome;
        //if (truckGapIncome != null) r += truckGapIncome;
        //if (taiIncome != null) r += taiIncome;
        //if (mvIncome != null) r += mvIncome;
        //if (cciIncome != null) r += cciIncome;
        if (QuotingCalculation.CALC_QUOTING.equals(calcType)) {
            if ('A'.equals(mvAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (mvIncome != null)
                    r += mvIncome;
            }
            if ('A'.equals(gapAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (gapIncome != null)
                    r += gapIncome;
            }
            if ('A'.equals(taiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (taiIncome != null)
                    r += taiIncome;
            }
            if ('A'.equals(ltiAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (ltiIncome != null)
                    r += ltiIncome;
            }
            if (
                'A'.equals(warrantyAcceptance) || 'M'.equals(insuranceInputMode)
            ) {
                if (warrantyIncome != null)
                    r += warrantyIncome;
            }
            //Manual Insurances
            if ('A'.equals(nwcAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (nwcIncome != null)
                    r += nwcIncome;
            }
            //Lelo          Insurance               2018-02-26
            if ('A'.equals(cciAcceptance) || 'M'.equals(insuranceInputMode)) {
                if (cciIncome != null)
                    r += cciIncome;
            }
        } else if (QuotingCalculation.PRO_FULLY.equals(calcType)) {
            //Yohan VillaLeal          Insurance       2018-07-11
            r += getGapTaiIncome();
            r += getWarrNwcIncome();
            //Lelo                  Insurance           2018-07-03
            if (getHasLti()) {
                r += getLtiCciIncome();
            } else {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount =
                    this.getTotalAmount(calcType) +
                    getGapTai() +
                    getWarrNwc();
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if (results != null) {
                    r += results.commission;
                }
            }
        } else if (QuotingCalculation.PRO_STANDARD.equals(calcType)) {
            r += getGapTaiIncome();
            //Lelo          Insurance               2018-02-26
            r += getWarrNwcIncome();
            //-
        } else if (QuotingCalculation.PRO_BASIC.equals(calcType)) {
            r += getGapTaiIncome();
        } else if (InsuranceQuoteUtils.INS_PROD_MV.equals(calcType)) {
            if (mvIncome != null)
                r += mvIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_GAP.equals(calcType)) {
            if (gapIncome != null)
                r += gapIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_TAI.equals(calcType)) {
            if (taiIncome != null)
                r += taiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_LTI.equals(calcType)) {
            if (ltiIncome != null)
                r += ltiIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_WARR.equals(calcType)) {
            if (warrantyIncome != null)
                r += warrantyIncome;
        } else if (InsuranceQuoteUtils.INS_PROD_NWC.equals(calcType)) {
            if (cciIncome != null) {
                EricLPI.Parameter parameters = new EricLPI.Parameter();
                parameters.coverOption = cciLevel;
                parameters.term = MATH.round(this.getTermYears());
                parameters.initialAmount = this.getTotalAmount(calcType);
                EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
                if (results != null) {
                    r = results.commission;
                }
            }
        }
        return r;
    }

    private void calculateRepayments() {
        //Reset results
        this.resetCalculationResult();
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(
            LENDER_QUOTING
        );
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
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(
            quotingType
        );
        param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);

        System.debug(
            quotingType +
            '|' +
            param.amountBasePmt +
            '|' +
            param.amountBaseComm +
            '|' +
            param.getNaf()
        );

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
        param.totalInsurance = 0;
        param.totalInsuranceIncome = 0;

        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = QuotingCalculation.CALC_SIMPLE;
        }
        calResults.put(QuotingCalculation.CALC_SIMPLE, r);

        //}
        //-

        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = getTotalAmount(quotingType);
        param.totalInsurance = getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
        param.amountBasePmt = this.getBaseAmountPmtInclBrokerageCalc(
            quotingType
        );
        param.amountBaseComm = this.getBaseAmountPmtCalc(quotingType);
        System.debug(
            quotingType +
            '|' +
            param.amountBasePmt +
            '|' +
            param.amountBaseComm +
            '|' +
            param.getNaf()
        );
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

    private Decimal getLtiCci() {
        Decimal r = 0.0;
        return r;
    }

    private Decimal getLtiCciIncome() {
        Decimal r = 0.0;
        return r;
    }

    public Boolean getHasLti() {
        Boolean r = false;
        return r;
    }
    
    public Decimal getTermYears() {
        if (term == null)
            return 0;
        return term / 12;
    }

    public void ericLPICalculate() {
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = cciLevel;
        parameters.term = MATH.round(getTermYears());
        parameters.initialAmount = this.realtimeNaf;
        if ('A'.equals(cciAcceptance)) {
            parameters.initialAmount -= cci;
        }
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);

        if (results != null) {
            cci = results.premium;
            cciIncome = results.commission;
        } else {
            cci = 0.00;
            cciIncome = 0.00;
        }
    }
    /**
     * @description retiurns the asset types
     * @author Girish P | 08-08-2021
     * @return List<SelectOption>
     **/
    public List<SelectOption> getBOQAssetType() {
        List<SelectOption> listAsset = new List<SelectOption>{
            new SelectOption('', '--None--')
        };
        for (String eachAsset : BOQCalculatorCommercialHelper.ASSET_TYPE) {
            listAsset.add(new SelectOption(eachAsset, eachAsset));
        }
        return listAsset;
    }

    public void assetYearOption() {
        manufactureYearOptions = new List<SelectOption>();
        manufactureYearOptions.add(new SelectOption('', '--None--'));
        manufactureYearOptions.add(new SelectOption('New', 'New/Demo'));
        manufactureYearOptions.add(new SelectOption('Used', '1-3 years'));
        this.manufactureYear = '--None--';
    }

    public Boolean getIsBrokerPartnerUser() {
        return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
    public Decimal getInterestRates() {
        this.clientRate = helper.getInterestRates(
            this.productGoodsType,
            this.manufactureYear
        );
        return this.clientRate;
    }
    public List<SelectOption> getOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(
            new SelectOption(
                MacquarieConstants.TYPE_PERCENTAGE,
                MacquarieConstants.TYPE_PERCENTAGE
            )
        );
        r.add(
            new SelectOption(
                MacquarieConstants.TYPE_VALUE,
                MacquarieConstants.TYPE_VALUE
            )
        );
        return r;
    }
}