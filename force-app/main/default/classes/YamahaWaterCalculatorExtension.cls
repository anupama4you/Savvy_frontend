public class YamahaWaterCalculatorExtension {
    
    public Custom_Opportunity__c Opp;
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'YamahaWater';
    //-
    
    public YamahaCalculatorDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}
    public Map<String, YamahaRates__c> rates {get;set;}                     //Lelo              2017-09-05
    
    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'Yamaha Water';
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-
    
    //Lelo                  Insurance                       2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String quoteIdSelected {get;set;}
    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    //-
    
    //NWC Calculator - HJ - 04-08-2018 - I
    public List <SelectOption> NWCPlanOptions {get;set;}
    public List <SelectOption> NWCTermOptions {get;set;}
    public List <SelectOption> NWCTypePOptions {get;set;}
    public String NWCMessage {set; get;}
    //public String assetType = null;
    public Boolean isAssetCar {set; get;}
    public Boolean isAssetBoat {set; get;}
    public Boolean isCategoryType {set; get;}
    public Boolean isNWCValidationOk {set; get;}
    public NWCCalc.Parameter nwcParam {set; get;}
    public Decimal priceCustomer= null;

    //NWC Warnings - I
    public Application_Asset_Detail__c aad = null;
    public Integer vehicleAgeYear = null;
    public String messageNWCWarning {set; get;}
    //NWC Warnings - F
    
    //NWC Calculator - HJ - 04-08-2018 - F
    
    public YamahaWaterCalculatorExtension(ApexPages.StandardController controller) {
        
        //NWC Calculator - HJ - 12-07-2018 - I
        nwcParam = new NWCCalc.Parameter();
        //NWC Calculator - HJ - 12-07-2018 - F
        
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        
        RecordTypes = new Map<String, Id>();
        List <RecordType> productTypes = [SELECT Id, Name FROM RecordType];
        for (RecordType rt : productTypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        
        qh = new QuotingToolHelper();
        
        reset();

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
                if (lender != null && lender.info != null && 'YWAT'.equals(lender.info.Code__c)) {
                    dto.carPrice = lender.carPrice;
                    dto.deposit = lender.deposit;
                    dto.term = lender.term;
                    dto.loanTypeDetail = lender.productGoodsSubType;
                    dto.customerProfile = lender.customerProfile;
                    if (String.isNotBlank(lender.productLoanType)) {
                        if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            dto.productLoanType = 'Chattel Mortgage-Full-Doc';
                        } else if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            dto.productLoanType = 'Chattel Mortgage-Low-Doc';
                        }
                    }
                    
                    calculateDOf();
                    baseRateCalc();

                    //Lelo                          2017-11-16
                    dto.clientRate = lender.clientRate;
                    //
                    
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }
    
    public PageReference baseRateCalc() {
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        param.loanTypeDetail = dto.loanTypeDetail;
        param.privateSales = dto.privateSales;
        param.customerProfile = dto.customerProfile;
        param.totalAmount = dto.getRealtimeNaf();
        dto.baseRate = QuotingCalculation.getBaseRate(param);
        dto.maxBaseRate = QuotingCalculation.getMaximunBaseRate(param);
        //YamahaRates__c y = rates.get(dto.loanTypeDetail);
        //if (y != null) {
        //    dto.baseRate = y.Base_Rate__c;
        //}
        //if ('New Prime Plus'.equalsIgnoreCase(dto.loanTypeDetail)) {
        //	dto.baseRate = 7.50;
        //} else if ('New Prime'.equalsIgnoreCase(dto.loanTypeDetail)) {
        //    dto.baseRate = 7.99;
        //} else if ('New Standard'.equalsIgnoreCase(dto.loanTypeDetail)) {
        //    dto.baseRate = 8.99;
        //}
        //if ('Used'.equalsIgnoreCase(dto.customerProfile)) {
        //    dto.baseRate += 1;
        //}
        return null;
    }
    
    public void warrantyCalc() {
        warrantyPriceCalc();
        warrantyIncomeCalc();
        calculateDOf();
    }
    
    private void warrantyPriceCalc () {
        Decimal warrantyPrice = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();
        
        if (dto.vehicleGroup == null || dto.vehicleGroup == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a vehicle group value for accurate warranty price.'));
        } else {
            if (integer.valueOf(dto.vehicleGroup) == 4) {
                warrantyPrice = 0;
            } else {
                if (dto.warrantyLevel == null || dto.warrantyLevel == '') {
            
                } else {
                    warrantyPrice = allWarrantyLevels.get(dto.warrantyLevel).Amount__c + 44;
                    if (integer.valueOf(dto.vehicleGroup) == 2) {
                        warrantyPrice = warrantyPrice + 110;
                    } else if (integer.valueOf(dto.vehicleGroup) == 3) {
                        warrantyPrice = warrantyPrice + 220;
                    }
                
                    if (dto.awd == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (dto.turbo == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                    if (dto.diesel == 'Y') {
                        warrantyPrice = warrantyPrice + 110;
                    }
                } // end of if else warrantyLevel                
            } // end of if else vehicleGroup == 4
        } // end of if else vehicleGroup == null
        
        dto.warranty = warrantyPrice.setScale(2);
        
        if (dto.state == null || dto.state == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a State value for accurate Stamp Duty and Insurance Income.'));
        }
    } //end of funcion
    
    private void warrantyIncomeCalc () {
        Decimal warrantyPrice = 0;
        Decimal stampDuty = 0;
        Decimal gst = 0;
        Decimal govCharge = 0;
        Decimal netPremium = 0;
        Decimal warrantyCommission = 0;
        Map<String, Warranty_Prices__c> allWarrantyLevels = Warranty_Prices__c.getAll();
        
        if (dto.vehicleGroup == null || dto.vehicleGroup == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a vehicle group value for accurate warranty price.'));
        } else {
            if (integer.valueOf(dto.vehicleGroup) == 4) {
                warrantyCommission = 0;
            } else {
                if (dto.warrantyLevel == null || dto.warrantyLevel == '') {
            
                } else {
                    warrantyPrice = allWarrantyLevels.get(dto.warrantyLevel).Amount__c;
                    
                    if (dto.state == null || dto.state == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please choose a State value for accurate Stamp Duty and Insurance Income.'));
                        warrantyPrice = 0;
                    } else {
                        if (dto.state == 'ACT') {
                            stampDuty = warrantyPrice * 0.02 / (1 + 0.02);
                        } else if (dto.state == 'NSW') {
                            stampDuty = warrantyPrice * 0.05 / (1 + 0.05);
                        } else if (dto.state == 'NT') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (dto.state == 'QLD') {
                            stampDuty = warrantyPrice * 0.09 / (1 + 0.09);
                        } else if (dto.state == 'SA') {
                            stampDuty = warrantyPrice * 0.11 / (1 + 0.11);
                        } else if (dto.state == 'TAS') {
                            stampDuty = warrantyPrice * 0.08 / (1 + 0.08);
                        } else if (dto.state == 'VIC') {
                            stampDuty = warrantyPrice * 0.10 / (1 + 0.10);
                        } else if (dto.state == 'WA') {
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
        dto.warrantyIncome = warrantyCommission.setScale(2);
    } //end of function
    
    public void calculateDOf() {
        dto.dof = getDOfCalculation(QuotingCalculation.CALC_QUOTING);
        //if (dto.getDOFBaseCalculation() > 1500) {
        //    dto.dof = 165;
        //}
        //if (dto.getDOFBaseCalculation() > 3000) {
        //    dto.dof = 275;
        //}
        //if (dto.getDOFBaseCalculation() > 5000) {
        //    dto.dof = 490;
        //}
        //if (dto.getDOFBaseCalculation() > 10000) {
        //    dto.dof = 600;
        //}
        //if (dto.getDOFBaseCalculation() > 20000) {
        //    dto.dof = 720;
        //}
    }
    
    public Decimal getDOfCalculation(String quotingType) {
        Decimal r = 0.0;
        Decimal base = dto.getDOFBaseCalculation(quotingType);
        if (base > 1500) {
            r = 165;
        }
        if (base > 3000) {
            r = 275;
        }
        if (base > 5000) {
            r = 490;
        }
        if (base > 10000) {
            r = 600;
        }
        if (base > 20000 || (dto.carPrice == null || dto.carPrice == 0)) {
            r = 720;
        }   
        return r;
    }

    private Boolean isValidInsuranceInfo(Decimal price, Decimal commission) {
        return isValidInsuranceInfo('IGNORE', price, commission);
    }

    private Boolean isValidInsuranceInfo(String level, Decimal price, Decimal commission) {
        return isValidInsuranceInfo(level, price, commission, false);   
    }

    private Boolean isValidInsuranceInfo(String level, Decimal price, Decimal commission, boolean ignorePrice) {
        Boolean r = true;
        if ('IGNORE'.equals(level)) {
            if (commission > 0 && (price == 0 || price == null)) {
                r = false;
            }
        } else {
            if (!String.isBlank(level)) { 
                if((price == 0 || price == null) && (commission == 0 || commission == null)) {
                    r = false;
                } else if(price == 0 || price == null) {
                    if(!ignorePrice) r = false;
                }
            }
            if (price > 0 && String.isBlank(level)) {
                r = false;   
            }
            if (commission > 0 && String.isBlank(level)) {
                r = false;   
            }
        }
        return r;
    }

    private Boolean isInsuranceValidationOK() {
        Boolean r = true;

        // Gap Insurance
        if (!isValidInsuranceInfo(dto.gapLevel, dto.gap, dto.gapIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Gap insurance product.'));
            r = false;
        }
        // Warranty Insurance
        if (!isValidInsuranceInfo(dto.warrantyLevel, dto.warranty, dto.warrantyIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Warranty insurance product.'));
            r = false;
        }
        // LTI Insurance
        if (!isValidInsuranceInfo(dto.ltiLevel, dto.lti, dto.ltiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for LTI insurance product.'));
            r = false;
        }
        // Truck Gap Insurance
        if (!isValidInsuranceInfo(dto.truckGapLevel, dto.truckGap, dto.truckGapIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for Truck Gap insurance product.'));
            r = false;
        }
        // TAI/RTI Insurance
        if (!isValidInsuranceInfo(dto.taiLevel, dto.tai, dto.taiIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for TAI/RTI insurance product.'));
            r = false;
        }
        // MV Insurance
        if (!isValidInsuranceInfo(dto.mvLevel, dto.mv, dto.mvIncome, true)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for MV insurance product.'));
            r = false;
        }
        // CCI Insurance
        if (!isValidInsuranceInfo(dto.cci, dto.cciIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for CCI insurance product.'));
            r = false;
        }
        // NWC Warranty Insurance
        if (!isValidInsuranceInfo(dto.nwc, dto.nwcIncome)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the fields for NWC Warranty insurance product.'));
            r = false;
        }
        //NWC Calculator - HJ - 06-08-2018 - I
        if (!isNWCValidationOk){
            r = false;
        }
        //NWC Calculator - HJ - 06-08-2018 - F

        return r;
    }

    public Boolean isValidationOk() {
        Boolean r = true;
		this.ericLPICalculate();
        // validation before calculation
        if (dto.carPrice == null || dto.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        if (dto.applicationFee == null || dto.applicationFee == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee cannot be Zero.'));
            r = false;
        }
        if (dto.dof == null || dto.dof == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be Zero.'));
            r = false;
        }
        if (dto.ppsr == null || dto.ppsr == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
            r = false;
        }
        if (dto.baseRate == null || dto.baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        if (dto.clientRate == null || dto.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else if (dto.maxBaseRate > 0 && (dto.clientRate > dto.maxBaseRate)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Client Rate exceeds the max base rate (' + dto.maxBaseRate + '%).'));
        }
        if (dto.baseRate > 0 && dto.clientRate > 0 && dto.clientRate < dto.baseRate) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be below the base rate (' + dto.baseRate + '%).'));   
            r = false;
        }
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else {
            Integer maxTerm = 60;
            if (dto.getRealtimeNaf() >= 35000) {
                maxTerm = 72;
            }
            if (dto.term > maxTerm) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximun term is ' + maxTerm + ' months'));
                r = false;
            }
        }
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2018-06-13 
        if ('Used'.equals(dto.customerProfile) && 'Standard'.equals(dto.loanTypeDetail)) {
            if (dto.carPrice > 0) {
                Decimal p = dto.getNetDeposit() / dto.carPrice * 100;
                if (p < 10.0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'10% minimum deposit should be required. Current percentage: ' + p.setScale(2) + '%' ));
                }
            }
        }
        //
        //Lelo              2017-09-19
        if (dto.residualValue > 0 && dto.term > 60 && dto.getRealtimeNaf() < 35000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        return r;
    }
    
    public PageReference calculate () {
        baseRateCalc();
        calculateDOf();
        if (!isValidationOk()) {
            return null;
        }
		
        this.calculateRepayments();

        return null;
    }
    
    public PageReference reset () {
        dto = new YamahaCalculatorDTO();
        dto.calculatorType = 'WATER';
        dto.init();
        
        //Initial values
        dto.docFees = 0.0;
        dto.monthlyFee = 5.0;
        dto.ppsr = 6.00;
        dto.applicationFee = 395.0;
        dto.dof = 0.0;
        dto.baseRate = 0.0;
        dto.clientRate = 0.0;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        dto.vehicleGroup = '1';
        dto.awd = 'N';
        dto.turbo = 'N';
        dto.diesel = 'N';
        dto.baseRate = 0.00;
        dto.loanTypeDetail = 'Prime Plus';
        dto.customerProfile = 'New';
        dto.privateSales = 'N';
        //Insurance Products
        //Lelo          Insurance           2017-12-04
        dto.insuranceInputMode = 'A';
        
        dto.mvAcceptance = 'U';
        dto.gapAcceptance = 'U';
        dto.taiAcceptance = 'U';
        dto.ltiAcceptance = 'U';
        dto.warrantyAcceptance = 'U';
        dto.nwcAcceptance = 'U';
        dto.cciAcceptance = 'U';
        
        //NWC Calculator - HJ - I - 12-07-2018
        nwcParam.awd4wd = null;
        nwcParam.luxuryCar = null;
        nwcParam.type_p = null;
        nwcParam.isManuallyNWCPrice = false;
		//NWC Calculator - HJ - F - 12-07-2018
		
        //-
        dto.maxBaseRate = 0.0;
        
        rates = new Map<String, YamahaRates__c>();
        for (YamahaRates__c y : dto.getYamahaRates()) {
            rates.put(y.Program__c, y);
        }

        baseRateCalc();
        
        this.resetCalculationResult(); //Lelo       2017-07-25
        calculateDOf();
        return null;
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
		if (dto.estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
            //return null;
        }		
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'YAMAHA WATER VEHICLES CALCULATION';
        qDto.state = dto.state;
        qDto.vehicleGroup = dto.vehicleGroup;
        qDto.awd = dto.awd;
        qDto.turbo = dto.turbo;
        qDto.diesel = dto.diesel;

        //qDto.gapLevel = dto.gapLevel;
        //qDto.gap = String.valueOf(dto.gap);
        //qDto.gapIncome = String.valueOf(dto.gapIncome);
        //qDto.nwc = String.valueOf(dto.nwc);
        //qDto.nwcIncome = String.valueOf(dto.nwcIncome);
        //qDto.warrantyLevel = dto.warrantyLevel;
        //qDto.warranty = String.valueOf(dto.warranty);
        //qDto.warrantyIncome = String.valueOf(dto.warrantyIncome);
        //qDto.ltiLevel = dto.ltiLevel;
        //qDto.lti = String.valueOf(dto.lti);
        //qDto.ltiIncome = String.valueOf(dto.ltiIncome);
        //qDto.truckGapLevel = dto.truckGapLevel;
        //qDto.truckGap = String.valueOf(dto.truckGap);
        //qDto.truckGapIncome = String.valueOf(dto.truckGapIncome);
        //qDto.taiLevel = dto.taiLevel;
        //qDto.tai = String.valueOf(dto.tai);
        //qDto.taiIncome = String.valueOf(dto.taiIncome);
        //qDto.mvLevel = dto.mvLevel;
        //qDto.mv = String.valueOf(dto.mv);
        //qDto.mvIncome = String.valueOf(dto.mvIncome);
        ////dto.cciLevel = String.valueOf(cciLevel);
        //qDto.cci = String.valueOf(dto.cci);
        //qDto.cciIncome = String.valueOf(dto.cciIncome);
        
        qDto.carPrice = String.valueOf(dto.carPrice);
        
        qDto.applicationFee = String.valueOf(dto.applicationFee);
        qDto.dof = String.valueOf(dto.dof);
        qDto.ppsr = String.valueOf(dto.ppsr);
        qDto.residualValue = String.valueOf(dto.residualValue);
        qDto.baseRate = String.valueOf(dto.baseRate);
        qDto.clientRate = String.valueOf(dto.clientRate);
        qDto.term = String.valueOf(dto.term);
        qDto.paymentType = dto.paymentType;
        qDto.estimatedCommission = String.valueOf(dto.estimatedCommission);
        qDto.insuranceIncome = String.valueOf(dto.getInsuranceIncome());
        qDto.dofResult = String.valueOf(dto.getDofResult());
        qDto.totalCommission = String.valueOf(dto.getTotalCommission());
        qDto.totalCommissionGst = String.valueOf(dto.getTotalCommissionGst());
        qDto.naf = String.valueOf(dto.nafCalculated);
        qDto.rental = String.valueOf(dto.rental);
        qDto.monthlyFee = String.valueOf(dto.monthlyFee);
        qDto.monthlyPayment = String.valueOf(dto.getMonthlyPayment());
        qDto.fortnightlyPayment = String.valueOf(dto.getFortnightlyPayment());
        qDto.weeklyPayment = String.valueOf(dto.getWeeklyPayment());
        //Yamaha Motorcycles Consumer
        
        qDto.customerProfile = dto.customerProfile;
        
        qDto.loanTypeDetail = dto.loanTypeDetail;
        qDto.loanType = dto.loanType;
        qDto.productLoanType = dto.productLoanType;
        
        if (dto.deposit != null) {
            qDto.deposit = String.valueOf(dto.deposit);
        }
        if (dto.tradeIn != null) {
            qDto.tradeIn = String.valueOf(dto.tradeIn);
        }
        if (dto.payoutOn != null) {
            qDto.payoutOn = String.valueOf(dto.payoutOn);
        }
        qDto.netDeposit = String.valueOf(dto.getNetDeposit());
        
        // pass parameters to the PDF page
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        // pass universal variables
        calcPdf.getParameters().put('id',Opp.Id);
        calcPdf.getParameters().put('lender', qDto.lender);
        calcPdf.getParameters().put('state', qDto.state);
        calcPdf.getParameters().put('vehicleGroup', qDto.vehicleGroup);
        calcPdf.getParameters().put('awd', qDto.awd);
        calcPdf.getParameters().put('turbo', qDto.turbo);
        calcPdf.getParameters().put('diesel', qDto.diesel);

        //Lelo          Insurance               2017-12-02
        if ('A'.equals(dto.mvAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('mvLevel', dto.mvLevel);
            calcPdf.getParameters().put('mv', String.valueOf(dto.mv));
            calcPdf.getParameters().put('mvIncome', String.valueOf(dto.mvIncome));
        } else {
            calcPdf.getParameters().put('mvLevel', null);
            calcPdf.getParameters().put('mv', String.valueOf(0.00));
            calcPdf.getParameters().put('mvIncome', String.valueOf(0.00));
        }
        if ('A'.equals(dto.gapAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('gapLevel', dto.gapLevel);
            calcPdf.getParameters().put('gap', String.valueOf(dto.gap));
            calcPdf.getParameters().put('gapIncome', String.valueOf(dto.gapIncome));
        } else {
            calcPdf.getParameters().put('gapLevel', null);
            calcPdf.getParameters().put('gap', String.valueOf(0.00));
            calcPdf.getParameters().put('gapIncome', String.valueOf(0.00));
        }
        if ('A'.equals(dto.taiAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('taiLevel', dto.taiLevel);
            calcPdf.getParameters().put('tai', String.valueOf(dto.tai));
            calcPdf.getParameters().put('taiIncome', String.valueOf(dto.taiIncome));
        } else {
            calcPdf.getParameters().put('taiLevel', null);
            calcPdf.getParameters().put('tai', String.valueOf(0.00));
            calcPdf.getParameters().put('taiIncome', String.valueOf(0.00));
        }
        if ('A'.equals(dto.ltiAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('ltiLevel', dto.ltiLevel);
            calcPdf.getParameters().put('lti', String.valueOf(dto.lti));
            calcPdf.getParameters().put('ltiIncome', String.valueOf(dto.ltiIncome));
        } else {
            calcPdf.getParameters().put('ltiLevel', null);
            calcPdf.getParameters().put('lti', String.valueOf(0.00));
            calcPdf.getParameters().put('ltiIncome', String.valueOf(0.00));
        }
        if ('A'.equals(dto.warrantyAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('warrantyLevel', dto.warrantyLevel);
            calcPdf.getParameters().put('warranty', String.valueOf(dto.warranty));
            calcPdf.getParameters().put('warrantyIncome', String.valueOf(dto.warrantyIncome));
        } else {
            calcPdf.getParameters().put('warrantyLevel', null);
            calcPdf.getParameters().put('warranty', String.valueOf(0.00));
            calcPdf.getParameters().put('warrantyIncome', String.valueOf(0.00));
        }
        //Manual Insurances
        if ('A'.equals(dto.nwcAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('nwc', String.valueOf(dto.nwc));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(dto.nwcIncome));
            
            //NWC Calculator - HJ - 31-08-2018 - I
            String nwcAwd4wd = '';
            String nwcLuxuryCar = '';
            if (isAssetCar){
                nwcAwd4wd = nwcParam.awd4wd;
                nwcLuxuryCar = nwcParam.luxuryCar;
            }
            String nwcEngine = '';
            String nwcType_p = nwcParam.type_p;
            if ('NWC'.equalsIgnoreCase(nwcType_p)){
                nwcType_p = '';
            }
            if (isAssetBoat){
                nwcEngine = nwcParam.type_p;
                nwcType_p = '';
            } 
            String nwcIsManuallyNWCPrice = 'N';
            if (nwcParam.isManuallyNWCPrice){
                nwcIsManuallyNWCPrice = 'Y';
            }
            calcPdf.getParameters().put('nwcAwd4wd', nwcAwd4wd);
            calcPdf.getParameters().put('nwcLuxuryCar', nwcLuxuryCar);
            calcPdf.getParameters().put('nwcType_p', nwcType_p);
            calcPdf.getParameters().put('nwcEngine', nwcEngine);
            calcPdf.getParameters().put('nwcIsManuallyNWCPrice', nwcIsManuallyNWCPrice);
            calcPdf.getParameters().put('nwcTerm', dto.nwcTerm);
            calcPdf.getParameters().put('nwcAssetType', nwcParam.assetType);
            calcPdf.getParameters().put('nwcState', nwcParam.state);
            calcPdf.getParameters().put('nwcPlan', dto.nwcPlan);
            
            
            //NWC Calculator - HJ - 31-08-2018 - F
            
        } else {
            calcPdf.getParameters().put('nwc', String.valueOf(0.00));
            calcPdf.getParameters().put('nwcIncome', String.valueOf(0.00));
        }
        // Lelo         Insurance       2018-02-26
        if ('A'.equals(dto.cciAcceptance) || 'M'.equals(dto.insuranceInputMode)) {
            calcPdf.getParameters().put('cciLevel', dto.cciLevel);
            calcPdf.getParameters().put('cci', String.valueOf(dto.cci));
            calcPdf.getParameters().put('cciIncome', String.valueOf(dto.cciIncome));
        } else {
            calcPdf.getParameters().put('cciLevel', null);
            calcPdf.getParameters().put('cci', String.valueOf(0.00));
            calcPdf.getParameters().put('cciIncome', String.valueOf(0.00));
        }
        //-
        
        calcPdf.getParameters().put('carPrice', qDto.carPrice);
        
        calcPdf.getParameters().put('applicationFee', qDto.applicationFee);
        calcPdf.getParameters().put('dof', qDto.dof);
        calcPdf.getParameters().put('ppsr', qDto.ppsr);
        calcPdf.getParameters().put('residualValue', qDto.residualValue);
        calcPdf.getParameters().put('baseRate', qDto.baseRate);
        calcPdf.getParameters().put('clientRate', qDto.clientRate);
        calcPdf.getParameters().put('term', qDto.term);
        calcPdf.getParameters().put('paymentType', qDto.paymentType);
        calcPdf.getParameters().put('estimatedCommission', qDto.estimatedCommission);
        calcPdf.getParameters().put('insuranceIncome', qDto.insuranceIncome);
        calcPdf.getParameters().put('dofResult', qDto.dofResult);
        calcPdf.getParameters().put('totalCommission', qDto.totalCommission);
        calcPdf.getParameters().put('totalCommissionGst', qDto.totalCommissionGst);
        calcPdf.getParameters().put('naf', qDto.naf);
        calcPdf.getParameters().put('rental', qDto.rental);
        calcPdf.getParameters().put('monthlyFee', qDto.monthlyFee);
        calcPdf.getParameters().put('monthlyPayment', qDto.monthlyPayment);
        calcPdf.getParameters().put('fortnightlyPayment', qDto.fortnightlyPayment);
        calcPdf.getParameters().put('weeklyPayment', qDto.weeklyPayment);
        //pass variables about the product info
        
        calcPdf.getParameters().put('customerProfile', qDto.customerProfile);
        
        calcPdf.getParameters().put('loanTypeDetail', qDto.loanTypeDetail);
        calcPdf.getParameters().put('loanType', qDto.loanType);
        calcPdf.getParameters().put('productLoanType', qDto.productLoanType);
        
        calcPdf.getParameters().put('deposit', qDto.deposit);
        calcPdf.getParameters().put('tradeIn', qDto.tradeIn);
        calcPdf.getParameters().put('payoutOn', qDto.payoutOn);
        calcPdf.getParameters().put('netDeposit', qDto.netDeposit);

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
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        } else if (InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            return null;
        }
        if (dto.estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
            //return null;
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
            updateProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
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
        updateProduct.Lender__c = 'Yamaha';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = dto.loanType;
        updateProduct.Loan_Product__c = dto.productLoanType;
        updateProduct.Loan_Type_Detail__c = dto.loanTypeDetail;

        //updateProduct.Loan_Type__c = dto.loanTypeDetail;
        updateProduct.Loan_Term__c = dto.term;
        if (dto.residualValue == null || dto.residualValue == 0) {
            updateProduct.Balloon_Residual_Requested__c = 0;
        } else {
            updateProduct.Balloon_Residual_Requested__c = dto.residualValue;
        }
        updateProduct.Client_Rate__c = dto.clientRate;
        updateProduct.Payments__c = dto.getMonthlyPayment();
        updateProduct.Cost_of_Goods__c = dto.carPrice;
        if (dto.getNetDeposit() == null) {
            updateProduct.Deposit__c = 0;
        } else {
            updateProduct.Deposit__c = dto.getNetDeposit();
        }
        updateProduct.DOF__c = dto.dof;
        
        if (dto.estimatedCommission == null) {
            updateProduct.Brokerage__c = 0;
        } else {
            updateProduct.Brokerage__c = dto.estimatedCommission;
        }
        updateProduct.Lender_App_Fee__c = dto.applicationFee;
        updateProduct.Equalisation_Fee_PPSR__c = dto.ppsr;
        
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
        // Gap Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.gapAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && String.isNotBlank(dto.gapLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Gap Insurance';
            if (dto.gap == null || dto.gap == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.gap;
            }
            if (dto.gapIncome == null || dto.gapIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.gapIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // Warranty Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.warrantyAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && String.isNotBlank(dto.warrantyLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Warranty';
            if (dto.warranty == null || dto.warranty == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.warranty;
            }
            if (dto.warrantyIncome == null || dto.warrantyIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.warrantyIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // LTI Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.ltiAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && String.isNotBlank(dto.ltiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'LTI';
            if (dto.lti == null || dto.lti == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.lti;
            }
            if (dto.ltiIncome == null || dto.ltiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.ltiIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // TAI/RTI Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.taiAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && String.isNotBlank(dto.taiLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Type and Rim Insurance';
            if (dto.tai == null || dto.tai == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.tai;
            }
            if (dto.taiIncome == null || dto.taiIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.taiIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // MV Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.mvAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && String.isNotBlank(dto.mvLevel))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Full Comprehensive';
            if (dto.mv == null || dto.mv == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV Price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.mv;
            }
            if (dto.mvIncome == null || dto.mvIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.mvIncome;
            }
            newInsurance.Insurer__c = dto.mvLevel;
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        //Lelo      Insurnce        2018-02-26
        // CCI Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.cciAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && (dto.cci != null && dto.cci > 0))) {    
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'CCI';
            newInsurance.Insurance_Policy_Amount__c = dto.cci;
            if (dto.cciIncome == null || dto.cciIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'CCI Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.cciIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // NWC Insurance
        if (('A'.equals(dto.insuranceInputMode) && 'A'.equals(dto.nwcAcceptance)) || 
            ('M'.equals(dto.insuranceInputMode) && (dto.nwc != null && dto.nwc > 0))) {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Warranty';
            newInsurance.Insurance_Policy_Amount__c = dto.nwc;
            if (dto.nwcIncome == null || dto.nwcIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'NWC Warranty Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.nwcIncome;
            }
            newInsurance.Insurer__c = 'NWC';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        
        //Lelo								2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
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

            if (String.isBlank(d.Insurance_Input_Mode__c)) {
                dto.insuranceInputMode = 'M';
            } else {
                dto.insuranceInputMode = d.Insurance_Input_Mode__c;
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

                //Vehicle Details
                dto.state = d.Vehicle_Detail_State__c;
                dto.vehicleGroup = d.Vehicle_Detail_Group__c;
                dto.awd = d.Vehicle_Detail_AWD__c;
                dto.turbo = d.Vehicle_Detail_Turbo__c;
                dto.diesel = d.Vehicle_Detail_Diesel__c;
                //Insurance Product
                dto.mvLevel = d.Insurance_MV_Type__c;
                dto.mv = d.Insurance_MV_Retail_Price__c;
                dto.mvIncome = d.Insurance_MV_Income__c;
                dto.mvAcceptance = d.Insurance_MV_Acceptance__c;
                if (String.isBlank(dto.mvAcceptance)) {
                    dto.mvAcceptance = 'U';
                }

                dto.gapLevel = d.Insurance_GAP_Type__c;
                dto.gap = d.Insurance_GAP_Retail_Price__c;
                dto.gapIncome = d.Insurance_GAP_Income__c;
                dto.gapAcceptance = d.Insurance_GAP_Acceptance__c;
                if (String.isBlank(dto.gapAcceptance)) {
                    dto.gapAcceptance = 'U';
                }

                dto.taiLevel = d.Insurance_TAI_Type__c;
                dto.tai = d.Insurance_TAI_Retail_Price__c;
                dto.taiIncome = d.Insurance_TAI_Income__c;
                dto.taiAcceptance = d.Insurance_TAI_Acceptance__c;
                if (String.isBlank(dto.taiAcceptance)) {
                    dto.taiAcceptance = 'U';
                }
                
                dto.ltiLevel = d.Insurance_LTI_Type__c;
                dto.lti = d.Insurance_LTI_Retail_Price__c;
                dto.ltiIncome = d.Insurance_LTI_Income__c;
                dto.ltiAcceptance = d.Insurance_LTI_Acceptance__c;
                if (String.isBlank(dto.ltiAcceptance)) {
                    dto.ltiAcceptance = 'U';
                }

                dto.warrantyLevel  = d.Insurance_Warranty_Type__c;
                dto.warranty = d.Insurance_Warranty_Retail_Price__c;
                dto.warrantyIncome = d.Insurance_Warranty_Income__c;
                dto.warrantyAcceptance = d.Insurance_Warranty_Acceptance__c;
                if (String.isBlank(dto.warrantyAcceptance)) {
                    dto.warrantyAcceptance = 'U';
                }

                dto.nwc = d.Insurance_NWC_Retail_Price__c;
                dto.nwcIncome = d.Insurance_NWC_Income__c;
                dto.nwcPlan = d.Insurance_NWC_Plan__c;
                dto.nwcTerm = d.Insurance_NWC_Term__c;
                dto.nwcCost = d.Insurance_NWC_Cost__c;
                dto.nwcAcceptance = d.Insurance_NWC_Acceptance__c;
                
                //NWC Calculator - HJ - 12-07-2018 - I
                nwcParam.awd4wd = d.Insurance_NWC_AWD4WD__c;
        		nwcParam.luxuryCar = d.Insurance_NWC_LuxuryCar__c;
        		nwcParam.type_p = d.Insurance_NWC_TypeP__c;
                nwcParam.isManuallyNWCPrice = d.Insurance_NWC_Is_Manually_Value__c;
                nwcParam.nwcPriceToCustomer = dto.nwc;
                //NWC Calculator - HJ - 12-07-2018 - F
                
                if (String.isBlank(dto.nwcAcceptance)) {
                    dto.nwcAcceptance = 'U';
                }
                // Lelo             Insurance           2018-02-26
				dto.cciLevel = d.Insurance_AIC_Type__c;
                dto.cci = d.Insurance_AIC_Retail_Price__c;
                dto.cciIncome = d.Insurance_AIC_Income__c;
                dto.cciAcceptance = d.Insurance_AIC_Acceptance__c;
                if (String.isBlank(dto.cciAcceptance)) {
                    dto.cciAcceptance = 'U';
                }                
                //-

                if (this.quote != null) {
                    this.quote.MV_Acceptance__c = dto.mvAcceptance;
                    this.quote.GAP_Acceptance__c = dto.gapAcceptance;
                    this.quote.TAS_Acceptance__c = dto.taiAcceptance;
                    this.quote.LTI_Acceptance__c = dto.ltiAcceptance;
                    this.quote.WRR_Acceptance__c = dto.warrantyAcceptance;
                }
            }

            //Finance Details
            //Commons values
            dto.loanType = d.Loan_Type__c;
            dto.productLoanType = d.Loan_Product__c;
            dto.carPrice = d.Vehicle_Price__c;
            dto.deposit = d.Deposit__c;
            dto.tradeIn = d.Trade_In__c;
            dto.payoutOn = d.Payout_On__c;
            dto.residualValue = d.Residual_Value__c;
            if (d.Term__c != null) {
                dto.term = Integer.valueOf(d.Term__c);
            }

            if (sameQuoting) {
                //Specific values
                                
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.loanTypeDetail = d.Loan_Facility_Type__c;
                dto.customerProfile = d.Customer_Profile__c;

                dto.applicationFee = d.Application_Fee__c;
                dto.ppsr = d.PPSR__c;    
                
                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;
                
                //Load calculations
				this.ericLPICalculate();
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

                //Lelo              Insurance               2017-12-04
                //Insurance Quote Product loading
                if ('M'.equals(dto.insuranceInputMode) && d.App_Insurance_Quote__c != null) {
                    //this.adjustInsuranceProduct();
                    dto.insuranceInputMode = 'A';
                    System.debug('cleaning 1...');
                }
                //-

            }
            baseRateCalc();
            calculateDOf();
            
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

        //NWC Warning - I
        if (nwcParam != null && nwcParam.vehicleAgeYears != null && nwcParam.vehicleAgeYears > 20){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No car more than 20 years old can be covered. VechileYear: ' + nwcParam.vehicleAgeYears));
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
        //Vehicle Details
        d.Vehicle_Detail_State__c = dto.state;
        d.Vehicle_Detail_Group__c = dto.vehicleGroup;
        d.Vehicle_Detail_AWD__c = dto.awd;
        d.Vehicle_Detail_Turbo__c = dto.turbo;
        d.Vehicle_Detail_Diesel__c = dto.diesel;
        
        //Lelo              Insurance           2017-12-04
        //Insurance product
        d.Insurance_MV_Type__c = dto.mvLevel;
        d.Insurance_MV_Retail_Price__c = dto.mv;
        d.Insurance_MV_Income__c = dto.mvIncome;
        d.Insurance_MV_Acceptance__c = dto.mvAcceptance;

        d.Insurance_GAP_Type__c = dto.gapLevel;
        d.Insurance_GAP_Retail_Price__c = dto.gap;
        d.Insurance_GAP_Income__c = dto.gapIncome;
        d.Insurance_GAP_Acceptance__c = dto.gapAcceptance;
        
        d.Insurance_TAI_Type__c = dto.taiLevel;
        d.Insurance_TAI_Retail_Price__c = dto.tai;
        d.Insurance_TAI_Income__c = dto.taiIncome;
        d.Insurance_TAI_Acceptance__c = dto.taiAcceptance;

        d.Insurance_LTI_Type__c = dto.ltiLevel;
        d.Insurance_LTI_Retail_Price__c = dto.lti;
        d.Insurance_LTI_Income__c = dto.ltiIncome;
        d.Insurance_LTI_Acceptance__c = dto.ltiAcceptance;
        
        d.Insurance_Warranty_Type__c = dto.warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = dto.warranty;
        d.Insurance_Warranty_Income__c = dto.warrantyIncome;
        d.Insurance_Warranty_Acceptance__c = dto.warrantyAcceptance;

        d.Insurance_NWC_Retail_Price__c = dto.nwc;
        d.Insurance_NWC_Income__c = dto.nwcIncome;
        d.Insurance_NWC_Plan__c = dto.nwcPlan;
        d.Insurance_NWC_Term__c = dto.nwcTerm;
        d.Insurance_NWC_Cost__c = dto.nwcCost;
        d.Insurance_NWC_Acceptance__c = dto.nwcAcceptance;
        
        //NWC Calculator - HJ - 12-07-2018 - I
        d.Insurance_NWC_AWD4WD__c = nwcParam.awd4wd;
        d.Insurance_NWC_LuxuryCar__c = nwcParam.luxuryCar;
        d.Insurance_NWC_TypeP__c = nwcParam.type_p;
        d.Insurance_NWC_Is_Manually_Value__c = nwcParam.isManuallyNWCPrice;
        //NWC Calculator - HJ - 12-07-2018 - F
        
        // Lelo             Insurance           2018-02-26
		d.Insurance_AIC_Type__c = dto.cciLevel;
        d.Insurance_AIC_Retail_Price__c = dto.cci;
        d.Insurance_AIC_Income__c = dto.cciIncome;
        d.Insurance_AIC_Acceptance__c = dto.cciAcceptance;
        //-
         
         //Finance Details
        d.Loan_Type__c = dto.loanType;
        d.Loan_Product__c = dto.productLoanType;
        d.Loan_Facility_Type__c = dto.loanTypeDetail;

        d.Vehicle_Price__c = dto.carPrice;
        d.Deposit__c = dto.deposit;
        d.Trade_In__c = dto.tradeIn;
        d.Payout_On__c = dto.payoutOn;
        
        d.Application_Fee__c = dto.applicationFee;
        d.DOF__c = dto.dof;
        d.PPSR__c = dto.ppsr;
        d.Residual_Value__c = dto.residualValue;
        
        d.Base_Rate__c = dto.baseRate;
        d.Client_Rate__c = dto.clientRate;
        
        //Loan Details
        if (dto.term != null) {
            d.Term__c = Decimal.valueOf(dto.term);
        }
        d.Customer_Profile__c = dto.customerProfile;
        d.Payment__c = dto.paymentType;

        //Data calculated - Commission
        d.Commission_Estimation__c = dto.estimatedCommission;
        d.Commission_Insurance_Income__c = dto.getInsuranceIncome();
        d.Commission_DOF__c = dto.getDofResult();
        d.Commission_Total_GST_Exc__c = dto.getTotalCommission();
        //Data calculated - Repayment
        d.Rental__c = dto.rental;
        d.Repayment_Monthly__c = dto.getMonthlyPayment();
        d.Repayment_Fortnightly__c = dto.getFortnightlyPayment();
        d.Repayment_Weekly__c = dto.getWeeklyPayment();
        d.NAF__c = dto.nafCalculated;

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
    
    //Lelo                      Insurance                   2017-12-04
    //Save quote
    private void updateQuoteRecord() {
        if (this.quote.Id != null) {
            this.quote.Amount_Financed__c = dto.getRealtimeNaf();            //Update Amount financied
            update this.quote;
        }
    }

    //Accept
    public void acceptQuoteMV() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(dto.mvAcceptance)) {
            dto.mvAcceptance = 'U';
        } else {
            dto.mvAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.MV_Acceptance__c = dto.mvAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
    }

    public void acceptQuoteGAP() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(dto.gapAcceptance)) {
            dto.gapAcceptance = 'U';
        } else {
            dto.gapAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.GAP_Acceptance__c = dto.gapAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void acceptQuoteTAS() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(dto.taiAcceptance)) {
            dto.taiAcceptance = 'U';
        } else {
            dto.taiAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.TAS_Acceptance__c = dto.taiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void acceptQuoteLTI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(dto.ltiAcceptance)) {
            dto.ltiAcceptance = 'U';
        } else {
            dto.ltiAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.LTI_Acceptance__c = dto.ltiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void acceptQuoteWRR() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('A'.equals(dto.warrantyAcceptance)) {
            dto.warrantyAcceptance = 'U';
        } else {
            dto.warrantyAcceptance = 'A';
        }
        if (this.quote.Id != null) {
            this.quote.WRR_Acceptance__c = dto.warrantyAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void acceptQuoteNWC() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (dto.nwc == null || dto.nwc == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty Retail Price cannot be zero, please check the Retail Price.'));       
        } else if (String.isBlank(dto.nwcPlan) || String.isBlank(dto.nwcTerm)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty Plan and Term should be selected.'));       
        } else if (dto.nwcIncome == null || dto.nwcIncome <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The National Warranty commission is below zero, please check the Retail Price.'));       
        } else {
            if ('A'.equals(dto.nwcAcceptance)) {
                dto.nwcAcceptance = 'U';    
            } else {
                dto.nwcAcceptance = 'A';    
            }
        }
        ericLPICalculate();
    }

    //Decline
    public void declineQuoteMV() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.mvAcceptance)) {
            dto.mvAcceptance = 'U';
        } else {
            dto.mvAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.MV_Acceptance__c = dto.mvAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
		ericLPICalculate();
    }

    public void declineQuoteGAP() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.gapAcceptance)) {
            dto.gapAcceptance = 'U';
        } else {
            dto.gapAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.GAP_Acceptance__c = dto.gapAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void declineQuoteTAS() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.taiAcceptance)) {
            dto.taiAcceptance = 'U';
        } else {
            dto.taiAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.TAS_Acceptance__c = dto.taiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void declineQuoteLTI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.ltiAcceptance)) {
            dto.ltiAcceptance = 'U';
        } else {
            dto.ltiAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.LTI_Acceptance__c = dto.ltiAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void declineQuoteWRR() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.warrantyAcceptance)) {
            dto.warrantyAcceptance = 'U';
        } else {
            dto.warrantyAcceptance = 'D';
        }
        if (this.quote.Id != null) {
            this.quote.WRR_Acceptance__c = dto.warrantyAcceptance;
            //PENDING TO IDENTIFY WHO DOES THIS
        }
        ericLPICalculate();
    }

    public void declineQuoteNWC() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.nwcAcceptance)) {
            dto.nwcAcceptance = 'U';    
        } else {
            dto.nwcAcceptance = 'D';    
        }
        ericLPICalculate();
    }

    public Boolean hasQuotingInsProducts() {
        Boolean r = false;
        if ((dto.mv != null && dto.mv > 0) ||
            (dto.gap != null && dto.gap > 0) ||
            (dto.tai != null && dto.tai > 0) ||
            (dto.lti != null && dto.lti > 0) ||
            (dto.warranty != null && dto.warranty > 0) ||
            (dto.nwc != null && dto.nwc > 0) ||
            (dto.cci != null && dto.cci > 0)) {
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
                    InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c));
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
                }
                //-

                //Validate results
                if (this.hasQuotingInsProducts()) {

                    //Save calculations
                    //QuotingCalculation.saveQuotingResults(this.opp.Application__r.Application_Quoting__c, calResults.values());
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
        } else if (!isFullyInsProductReady()) {
            putUserMessage(ApexPages.Severity.ERROR, 'GAP (RTI), LTI (LPI) and any warranty product should be completed and calculated to continue with this functionality');
            r = false;
        }
        return r;
    }

    public String getPresentationUrlCode() {
        return InsuranceQuoteUtils.getPresentationUrlCode(this.opp.Application__c);
    }

    public PageReference createQuote() {

        //if (String.isBlank(this.opp.Application__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
        //    return null;
        //}

        if (!hasQuoteValidationOK()) {
            return null;
        }

        //Validations
        if (!isValidationOk()) {
            return null;
        }
        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        //if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
            PageReference n = Page.InsuranceQuoteStep1;
            n.getParameters().put('id', this.Opp.Id);
            return n;
        //}
        //return null;
    }

    public PageReference buyPolicy() {
        if (String.isBlank(this.opp.Application__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application before creating a Quote.'));
            return null;
        }

        //Validations
        if (!isValidationOk() || !isAnInsuranceProductAccepted()) {
            return null;
        }

        //Recalculate
        calculate();
        
        //Lelo                      2016-12-22
        //Save calculation
        if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
            PageReference n = Page.InsuranceBuyPolicyStep1;
            n.getParameters().put('id', this.Opp.Id);
            return n;
        }
        return null;
    }

    public Boolean isAnInsuranceProductAccepted() {
        Boolean r = false;
        if ('A'.equals(this.quote.MV_Acceptance__c)) {
            r = true;
        } else if ('A'.equals(this.quote.GAP_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.TAS_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.LTI_Acceptance__c)) {
            r = true;
        }  else if ('A'.equals(this.quote.WRR_Acceptance__c)) {
            r = true;
        }
        if (!r) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Any Insurance Product has been accepted.'));
        }

        return r;
    }

    public void nationalWarrantyCalc() {
        dto.nwcCost = QuotingToolHelper.getNationalWarrantyCost(dto.nwcPlan, dto.nwcTerm);
    }

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

    // Lelo             Insurance               2018-02-26
    private Boolean isFullyInsProductReady()  {
        Boolean r = false;
        if (((dto.gap != null && dto.gap > 0) || (dto.tai != null && dto.tai > 0)) &&
            ((dto.lti != null && dto.lti > 0) || (dto.cci != null && dto.cci > 0)) &&
            ((dto.warranty != null && dto.warranty > 0) || 
                //HJ - NWC exclude others - 21-11-2018
                (dto.nwc != null && ((dto.nwc > 0 && 'Car'.equalsIgnoreCase(getAssetTypeOpp())) || !'Car'.equalsIgnoreCase(getAssetTypeOpp()))))) {
            r = true;
        }
        return r;
    }
        
    private Boolean isStandardInsProductReady()  {
        Boolean r = false;
        if (((dto.gap != null && dto.gap > 0) || (dto.tai != null && dto.tai > 0)) &&
            ((dto.warranty != null && dto.warranty > 0) || 
                //HJ - NWC exclude others - 21-11-2018
                (dto.nwc != null && ((dto.nwc > 0 && 'Car'.equalsIgnoreCase(getAssetTypeOpp())) || !'Car'.equalsIgnoreCase(getAssetTypeOpp()))))) {
            r = true;
        }
        return r;
    }

    private Boolean isBasicInsProductReady()  {
        Boolean r = false;
        if ((dto.gap != null && dto.gap > 0) || (dto.tai != null && dto.tai > 0))  {
            r = true;
        }
        return r;
    }
    //- 
    

    public List<SelectOption> getQuoteNumberOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        List<Application_InsuranceQuote__c> d = InsuranceQuoteUtils.getApplicationInsuranceQuotesByAppId(this.opp.Application__c, LENDER_QUOTING);
        if (d != null) {
            String label = '';
            for (Application_InsuranceQuote__c q : d) {
                //label = q.Quotation_Number__c + ' [' + q.Quotation_Date__c.format(DateUtils.FORMAT_LOCAL_FULL + ' a') + ']';
                label = q.Quotation_Number__c + ' [' + q.Quotation_Date__c.format() + ']';
                r.add(new SelectOption(q.Id, label));
            }
        }
        return r;
    }

    public PageReference importQuote() {
        if (this.quoteIdSelected == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a quote.'));
        } else if (this.quote != null && this.quoteIdSelected == this.quote.Id) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Quote already imported.'));
        } else if (this.quoting == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save a quote calculation before importing.'));
        } else {
            InsuranceQuoteUtils.importQuoteInQuotingTool(this.quoteIdSelected, this.opp.Id, LENDER_QUOTING);
            this.loadQuotingParametersSaved();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote has been imported successfully.'));
        }
        return null;
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

    public Boolean getDisplayNwcInsurance() {
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(dto.warrantyLevel)) {
                r  = true;
            }
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
            if (dto.rental != null && dto.rental > 0) {
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
        param.totalAmount = dto.getTotalAmount(quotingType);
        param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        param.clientRate = dto.clientRate;
        param.baseRate = dto.baseRate;
        param.paymentType = dto.paymentType;
        param.term = dto.term;
        param.dof = dto.dof;
        param.monthlyFee = dto.monthlyFee;
        param.residualValue = dto.residualValue;
        param.docFees = dto.docFees;
        param.commRate = rates.get(dto.loanTypeDetail).Commission__c;
        
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
            dto.estimatedCommission = r.Estimated_Commission__c;
            dto.nafCalculated = r.NAF__c;
            dto.rental = r.Rental__c;
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
            if (isFullyInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_FULLY);
            }
            if (isStandardInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_STANDARD);
            }
            if (isBasicInsProductReady()) {
                calcTypes.add(QuotingCalculation.PRO_BASIC);    
            }
            //Insurance one by one
            //MV
            if (dto.mv != null && dto.mv > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_MV);
            }
            //GAP
            if (dto.gap != null && dto.gap > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_GAP);
            }
            //TAI
            if (dto.tai != null && dto.tai > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_TAI);
            }
            //LTI
            if (dto.lti != null && dto.lti > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_LTI);
            }
            //WARR
            if (dto.warranty != null && dto.warranty > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_WARR);
            }
            //NWC
            if (dto.nwc != null && dto.nwc > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_NWC);
            }
            //CCI
            //Lelo          Insurance           2018-02-26
            if (dto.cci != null && dto.cci > 0) {
                calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
            }
            //-
            
            for (String key: calcTypes) {
                param.dof = this.getDOfCalculation(key);
                param.totalAmount = dto.getTotalAmount(key) - dto.dof + param.dof;
                param.totalInsurance = dto.getTotalInsuranceType(key);
                param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(key);
                r = QuotingCalculation.calculate(param);
                if (r != null) {
                    r.Result_Type__c = key;   
                }
                calResults.put(key, r);                
            }

        //}
        //-

        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.dof = this.getDOfCalculation(quotingType);
        param.totalAmount = dto.getTotalAmount(quotingType) - dto.dof + param.dof;
        param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);
        r = QuotingCalculation.calculate(param);
        if (r != null) {
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

    }

    //Lelo                              2017-07-25
    private void resetCalculationResult() {

        dto.init();

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
    private Boolean hasQuoteValidationOK() {
        Boolean r = true;
        //check for an application
        if (this.opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please link/create an application before quoting.'));
            r = false;
        } else {
            if (!'F'.equals(this.opp.Application__r.Status__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please the linked application should be finished.'));
                r = false;
            }
        }
        if (this.opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please save a Asset Detail - LTV before quoting.'));
            r = false;
        }
        return r;
    }

    //Lelo          Insurance           2018-02-26
    public Boolean getDisplayCCIInsurance() {
        Boolean r = false;
        if (this.quote != null && this.quote.Id != null) {
            if (String.isBlank(dto.ltiLevel)) {
                r  = true;
            }
        }
        return r;
    }
    public void acceptQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if (dto.cci == null || dto.cci == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The CCI - AIC/Eric Retail Price cannot be zero, please check the Retail Price.'));       
        } else {
            if ('A'.equals(dto.cciAcceptance)) {
                dto.cciAcceptance = 'U';    
            } else {
                dto.cciAcceptance = 'A';    
            }
        }
        ericLPICalculate();
    }
	
    public void declineQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.cciAcceptance)) {
            dto.cciAcceptance = 'U';    
        } else {
            dto.cciAcceptance = 'D';    
        }
        ericLPICalculate();
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
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 12/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        for (String value : dto.cciLevels) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = dto.cciLevel;
        parameters.term = MATH.round(dto.getTermYears());
        parameters.initialAmount = dto.getRealtimeNaf();
        if ('A'.equals(dto.cciAcceptance))  {
            parameters.initialAmount -= dto.cci;
        }
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        
        if(results != null){
            dto.cci = results.premium;
	        dto.cciIncome = results.commission;
        }else{
            dto.cci = 0.00;
	        dto.cciIncome = 0.00;
        }
    }

    public Boolean insuranceProductSelected() {
        Boolean r = true;
        // Lelo                 2018-08-16 
        // Accepted or declined validation
        // GAP / RTI
        if (String.isNotBlank(dto.gapLevel)) {
            if (String.isBlank(dto.gapAcceptance) || 'U'.equals(dto.gapAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'GAP should be Accepted or Declined.'));
                r = false;
            }
        } else if (String.isNotBlank(dto.taiLevel) && (String.isBlank(dto.taiAcceptance) || 'U'.equals(dto.taiAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'RTI should be Accepted or Declined.'));
            r = false;
        }
        // LTI / Repayment cover (Loan Protection)
        if (String.isNotBlank(dto.ltiLevel)) {
            if (String.isBlank(dto.ltiAcceptance) || 'U'.equals(dto.ltiAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LTI should be Accepted or Declined.'));
                r = false;
            }
        } else if (dto.cci > 0 && (String.isBlank(dto.cciAcceptance) || 'U'.equals(dto.cciAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Repayment cover (Loan Protection) should be Accepted or Declined.'));
            r = false;
        }
        // Warranty / NWC
        if (String.isNotBlank(dto.warrantyLevel)){
            if (String.isBlank(dto.warrantyAcceptance) || 'U'.equals(dto.warrantyAcceptance)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Warranty - Insurance should be Accepted or Declined.'));
                r = false;
            }
        } else if (dto.nwc > 0 && (String.isBlank(dto.nwcAcceptance) || 'U'.equals(dto.nwcAcceptance))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NWC Warranty should be Accepted or Declined.'));
            r = false;
        }
        return r;
    }
    
    //NWC Calculator - HJ - 12-07-2018 - I
    public void loadNWCParameters(){
        NWCMessage = '';
        isAssetCar = false;
        isAssetBoat = false;
        //Warranty update - HJ - 03-12-2018 - I
        nwcParam.isIntegrity = false;
        //Warranty update - HJ - 03-12-2018 - F
        //String asset = dto.productGoodsType;
        nwcParam.assetType = getAssetTypeOpp();
        nwcParam.state = getStateOpp();
        isCategoryType = false;
        if ('Car'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetCar = true;
            isCategoryType = true;
        }
        if ('Boat'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetBoat = true;
            isCategoryType = true;
        }
        if ('Truck'.equalsIgnoreCase(nwcParam.assetType)){
            isCategoryType = true;
        }
        //Warranty update - HJ - 03-12-2018 - I
        if ('Integrity'.equalsIgnoreCase(nwcParam.type_p)){
            nwcParam.isIntegrity = true;
        }
        //Warranty update - HJ - 03-12-2018 - F
        nwcParam.plan = dto.nwcPlan;
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType);
        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType, nwcParam.type_p);
        NWCTermOptions = NWCCalc.NWCTermOptions (nwcParam.assetType, nwcParam.type_p);
        loadCategory();
        isNWCValidationOk = true;

        //NWC Warnings - I
        this.aad = ApplicationService.getAssetDetail(this.Opp.Id);
        this.vehicleAgeYear = Utilities.getVehicleAgeYears(this.aad, this.Opp);
        nwcParam.vehicleAgeYears = vehicleAgeYear;
        if (this.aad != null && this.aad.Actual_KM__c != null){
            nwcParam.actualKm = this.aad.Actual_KM__c;
        }
        
        //NWC Warnings - F

        calculateNWC();
    }
    
    private void loadCategory(){
        //if (NWCTypePOptions.size() <= 2 && !'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    nwcParam.type_p = 'NWC';
        //    isCategoryType = false;
        //}else if (NWCTypePOptions.size() <= 2 && 'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    isCategoryType = true;
        //}
    }
    
    public void checkManuallyNWCPrice(){
        if (priceCustomer != null){
            nwcParam.nwcPriceToCustomer = priceCustomer;
        }
        if (nwcParam.isManuallyNWCPrice){
            Decimal priceCustomer = nwcParam.nwcPriceToCustomer;
            //Warranty update - HJ - 03-12-2018 - I
            if (priceCustomer == null){
                nwcParam.isManuallyNWCPrice = false;
                return;
            }
            //Warranty update - HJ - 03-12-2018 - F
            Long iPart = (Long) priceCustomer;
            Decimal fPart = priceCustomer - iPart;
            if (fPart > 0){
                nwcParam.nwcPriceToCustomer = NumberUtils.convertDecimalToScale(priceCustomer - 0.01, 2) ;
            }
        }
        calculateNWC();
    }
    
    public void calculateNWC(){
        
        isNWCValidationOk = true;
        NWCMessage = '';
        nwcParam.plan = dto.nwcPlan;
        nwcParam.term = dto.nwcTerm;
        nwcParam.state = getStateOpp();

        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType, nwcParam.type_p);

        //NWC Warnings - I
        checkNWCMessages(nwcParam);
        //NWC Warnings - F
        
        //if (NWCTypePOptions.size() == 2 && !'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    nwcParam.type_p = 'NWC';
        //    isCategoryType = false;
        //}else if (NWCTypePOptions.size() == 2 && 'Car'.equalsIgnoreCase(nwcParam.assetType)){
        //    isCategoryType = true;
        //}else{
        //    isCategoryType = true;
        //}

        NWCTermOptions = NWCCalc.NWCTermOptions (nwcParam.assetType, nwcParam.type_p, nwcParam.plan);

        //Warranty update - HJ - 03-12-2018 - I
        nwcParam.isIntegrity = false;
        if ('Integrity'.equalsIgnoreCase(nwcParam.type_p)){
            nwcParam.isIntegrity = false;
            if (!StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.Term)){
                nwcParam.isIntegrity = true;
            }
            return;
        }
        //Warranty update - HJ - 03-12-2018 - F
        dto.nwcIncome = 0;
        dto.nwc = 0;

        if (!StringUtils.isNullOrEmpty(nwcParam.assetType) && !StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.term) &&
            !StringUtils.isNullOrEmpty(nwcParam.type_p)){
                /**
                if (isAssetCar && (StringUtils.isNullOrEmpty(nwcParam.awd4wd) || StringUtils.isNullOrEmpty(nwcParam.luxuryCar))){
                    //NWCMessage = 'Missing values';
                    //System.debug('Missing values: AWD4WD / LuxuryCar]');
                }else **/
                if (isAssetBoat && '----'.equalsIgnoreCase(nwcParam.type_p)){
                    //NWCMessage = 'Missing values';
                    System.debug('Missing values: Engine]');
                }else if ('----'.equalsIgnoreCase(nwcParam.type_p)){
                    //NWCMessage = 'Missing values';
                    System.debug('Missing values: Category]');
                }else{
                    try{
                        NWCCalc.Result r = NWCCalc.CalculateNWC(nwcParam);
                        dto.nwc = r.retailPrice;
                        dto.nwcIncome = r.commission;
                        priceCustomer = dto.nwc;
                        //NWCMessage = 'OK-' + nwcParam.nwcPriceToCustomer;
                    }catch (Exception ex){
                        NWCMessage = ex.getMessage();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Warranty: [' + NWCMessage + ']'));
                        System.debug('NWC Warranty: [' + NWCMessage + ']');
                        isNWCValidationOk = false;
                    }
                }
            }else{
                //NWCMessage = 'Missing values';
                System.debug('Warranty Calculator: Missing values');
            }
        loadCategory();
    }
    
    private String getStateOpp(){
        String r = '';
        if (this.Opp != null && this.Opp.Application__c != null && String.isNotBlank(this.Opp.Application__r.State__c)) {
            r = this.Opp.Application__r.State__c;
        }
        return r;
    }
    
    private String getAssetTypeOpp(){
        String r = '';
        if (this.Opp != null && this.Opp.Application__c != null && String.isNotBlank(this.Opp.Application__r.Type_of_Asset__c)) {
            r = this.Opp.Application__r.Type_of_Asset__c;
        }
        return r;
    }

    //NWC Warnings - I
    private void checkNWCMessages(NWCCalc.Parameter nwcParam){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'VechileYear: ' + nwcParam.vehicleAgeYears + ' ActualKm: ' + nwcParam.actualKm));
        this.messageNWCWarning = null;
        if (nwcParam == null || nwcParam.plan == null || nwcParam.vehicleAgeYears == null || nwcParam.actualKm == null){
            return;
        }
        if ('Bronze'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 20 && nwcParam.actualKm > 300000){
            this.messageNWCWarning = 'Vehicles is up to 20 years and 300,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Silver'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 20 && nwcParam.actualKm > 250000){
            this.messageNWCWarning = 'Vehicles is up to 20 years and 250,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Gold'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 15 && nwcParam.actualKm > 200000){
            this.messageNWCWarning = 'Vehicles is up to 15 years and 200,000kms for this Category [' + nwcParam.plan + ']';
        }else if ('Platinum'.equalsIgnoreCase(nwcParam.plan) && nwcParam.vehicleAgeYears > 10 && nwcParam.actualKm > 150000){
            this.messageNWCWarning = 'Vehicles is up to 10 years and 150,000kms for this Category [' + nwcParam.plan + ']';
        }
    }
    //NWC Warnings - F
    
    //NWC Calculator - HJ - 12-07-2018 - F
}