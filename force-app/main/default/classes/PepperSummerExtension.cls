public with sharing class PepperSummerExtension {
    public Custom_Opportunity__c Opp;
    
    //Lelo					2016-09-02
    private String fileGlobalPrefix = 'PepperSummer';
    //-
    
    public PepperCalculatorDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}
        
    private Map<String, List<AfsRate>> rates = null;
    public List<Pepper_Summer_Rates__c> fullRates {get;set;}
    
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Pepper Summer';
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-
    
    //Lelo                  Insurance                       2017-12-04
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public String quoteIdSelected {get;set;}
    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    //-
    //Pepper API - HJ - I
    public PepperApplicationService ppAppService;
    public PepperAPIManager ppAPIManager {set; get;}
    public String pepperAPI_AppNumber {set; get;}
    public String pepperAPI_ResponseContent {set; get;}
    public String pepperAPI_lastResponseApp {set; get;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public String apiUser {get;set;}
    public Boolean paramActive {set; get;}
    //Pepper API - HJ - F
    
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
    
    //NWC Calculator - HJ - 04-08-2018 - F
   
    public PepperSummerExtension(ApexPages.StandardController controller) {
        //Pepper API - HJ - I
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);
        //Pepper API - HJ - F
    	
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
        
        //Pepper API - HJ - I
        ppAppService = new PepperApplicationService();
        ppAPIManager= new PepperAPIManager();
        usersAPIOptions = PepperAPIManager.getUserOptionsConnect();
        //Pepper API - HJ - F
        
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
                if (lender != null && lender.info != null && 'PESU'.equals(lender.info.Code__c)) {
                    dto.carPrice = lender.carPrice;
                    dto.deposit = lender.deposit;
                    dto.term = lender.term;
                    if (String.isNotBlank(lender.productLoanType)) {
                        if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            dto.productLoanType = 'Chattel Mortgage-Full-Doc';
                        } else if (lender.productLoanType.containsIgnoreCase('Chattel') && lender.productLoanType.containsIgnoreCase('full')) {
                            dto.productLoanType = 'Chattel Mortgage-Low-Doc';
                        }
                    }
                    dto.productGoodsType = lender.productGoodsType;
                    //Lelo                          2017-11-16
                    dto.clientRate = lender.clientRate;
                    dto.dof = lender.dofBase;
                    //
                }
            } catch (Exception e) {
                System.debug('PreLoadQuotingValues error >> ' + e.getMessage());
            }
        } else {
            loadQuotingParametersSaved();
        }

    }

    public void warrantyCalc() {
        warrantyPriceCalc();
        warrantyIncomeCalc();
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

        return r;
    }
    
    public Boolean isValidationOk() {
        Boolean r = true;
        ericLPICalculate();
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
        } else if (dto.dof > 990) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'DOF cannot be more than $990.'));
            r = false;
        }
        //if (dto.ppsr == null || dto.ppsr == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
        //    r = false;
        //}
        //if (dto.baseRate == null || dto.baseRate == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
        //    r = false;
        //}
        if (dto.clientRate == null || dto.clientRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client Rate cannot be Zero.'));
            r = false;
        } else {
            Decimal minRate = 0.0;
            Decimal maxRate = 0.0;

            List<AfsRate> rts = rates.get(dto.clientTier);

            minRate = rts.get(0).rate;
            maxRate = rts.get(rts.size()-1).rate;

            if (dto.clientRate < minRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The minimun Client Rate for ' + dto.clientTier + ' is ' + minRate + '%, please check your value and try again.'));
            	r = false;
            }
            if (dto.clientRate > maxRate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The maximun Client Rate for ' + dto.clientTier + ' is ' + maxRate + '%, please check your value and try again.'));
                r = false;
            }


        }
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (dto.term < 12 || dto.term > 84) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term between 12 and 84 months.'));
            r = false;
        }
        
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2017-09-19
        if (dto.residualValue > 0 && dto.term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
        
        //NWC Calculator - HJ - 06-08-2018 - I
        if (!isNWCValidationOk){
            r = false;
        }
        //NWC Calculator - HJ - 06-08-2018 - F
        return r;
    }
    
    public PageReference calculate () {
        if (!isValidationOk()) {
            return null;
        }		
        this.calculateRepayments();
		if (dto.estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
        return null;
    }
    
    public PageReference reset () {
        dto = new PepperCalculatorDTO();
        dto.init();
        
        //Initial values
        dto.loanType = 'Purchase';
        dto.productLoanType = 'Consumer Loan';
        dto.productGoodsType = 'Marine';
        dto.clientTier = 'A';
        dto.docFees = 0.0;
        dto.monthlyFee = 8.90;
        dto.ppsr = 8.00;       //Lelo              2016-09-20      //Original value: 6.80 --> 8.9 (2017-12-29) + 3.4
        dto.applicationFee = 449.0;
        dto.dof = 990.0;
        dto.baseRate = 0.0;
        dto.clientRate = 0.0;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        dto.vehicleGroup = '1';
        dto.awd = 'N';
        dto.turbo = 'N';
        dto.diesel = 'N';
        dto.registrationFee = 0.0;
        
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
        //-
        
        //NWC Calculator - HJ - I - 12-07-2018
        nwcParam.awd4wd = null;
        nwcParam.luxuryCar = null;
        nwcParam.type_p = null;
        nwcParam.isManuallyNWCPrice = false;
		//NWC Calculator - HJ - F - 12-07-2018
		
        fullRates = Pepper_Summer_Rates__c.getAll().values();
        fullRates.sort();
        rates = new Map<String, List<AfsRate>>();

        List<AfsRate> r1 = new List<AfsRate>();
        List<AfsRate> r2 = new List<AfsRate>();
        
        for (Pepper_Summer_Rates__c a : fullRates) {
    		r1.add(new AfsRate(a.Rate__c, a.Tier_A_Comm__c));     //Tier A
            r2.add(new AfsRate(a.Tier_B__c, a.Tier_A_Comm__c));   //Tier B
        }

        rates.put('A', r1);
        rates.put('B', r2);

        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    }
    
    private Decimal getCommissionRate() {
        Decimal r = 0.0;
        Decimal br = 0.0;   //Base Rate
        if (dto.clientRate != 0) {
        	List<AfsRate> rts = rates.get(dto.clientTier);
        	for (AfsRate a : rts) {
                if (br == 0) {
                    br = a.rate;
                }
        		if (dto.clientRate >= a.rate) {
        			r = a.comm;
        		}
        	}
        }
        //if (r > 0) {
        //    if (br == dto.clientRate) {
        //        r = 0.0;
        //    }
        //}
        return r;
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
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'PEPPER SUMMER CALCULATION';
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
        qDto.dofResult = String.valueOf(dto.getDofResult().setScale(2));
        qDto.totalCommission = String.valueOf(dto.getTotalCommission().setScale(2));
        qDto.totalCommissionGst = String.valueOf(dto.getTotalCommissionGst().setScale(2));
        qDto.naf = String.valueOf(dto.nafCalculated);
        qDto.rental = String.valueOf(dto.rental);
        qDto.monthlyFee = String.valueOf(dto.monthlyFee);
        qDto.monthlyPayment = String.valueOf(dto.getMonthlyPayment());
        qDto.fortnightlyPayment = String.valueOf(dto.getFortnightlyPayment());
        qDto.weeklyPayment = String.valueOf(dto.getWeeklyPayment());
        //Pepper Summer
        qDto.clientTier = dto.clientTier;
        qDto.registrationFee = String.valueOf(dto.registrationFee);
        qDto.productGoodsType = dto.productGoodsType;
        
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
        calcPdf.getParameters().put('deposit', qDto.deposit);
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
        calcPdf.getParameters().put('clientTier', qDto.clientTier);
        calcPdf.getParameters().put('registrationFee', qDto.registrationFee);
        calcPdf.getParameters().put('productGoodsType', qDto.productGoodsType);
        
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
        updateProduct.Lender__c = 'Pepper';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = dto.loanType;
        updateProduct.Loan_Product__c = dto.productLoanType;
        updateProduct.Loan_Type_Detail__c = 'Client Tier ' + dto.clientTier;


        //updateProduct.Loan_Type__c = dto.productLoanType;
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

            if (LENDER_QUOTING.equals(d.Name) || 
                PepperCalculatorMVExtension.LENDER_QUOTING.equals(d.Name) ||
                PepperCalculatorLeisureExtension.LENDER_QUOTING.equals(d.Name)) {
                //Specific values
                dto.productGoodsType = d.Goods_type__c;
                                
                if (d.Client_Rate__c != null) {
                    dto.clientRate = d.Client_Rate__c.setScale(2);
                }
                //Loan Details
                dto.paymentType = d.Payment__c;
                
            }
            if (sameQuoting) {
                dto.clientTier = d.Client_Tier__c;
                dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.ppsr = d.PPSR__c;    
                dto.monthlyFee = d.Monthly_Fee__c;
                
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
            //realtimeNafCalc();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
            //Pepper API - HJ - I
            pepperAPI_AppNumber = d.PepperAPI_Application_Id__c ;
            pepperAPI_ResponseContent = d.PepperAPI_Response_Message__c ;
            pepperAPI_lastResponseApp = d.PepperAPI_Last_Response_App__c ;
            //Pepper API - HJ - F
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
        d.Goods_type__c = dto.productGoodsType;
        d.Vehicle_Price__c = dto.carPrice;
        d.Deposit__c = dto.deposit;
        d.Trade_In__c = dto.tradeIn;
        d.Payout_On__c = dto.payoutOn;
        
        d.Application_Fee__c = dto.applicationFee;
        d.DOF__c = dto.dof;
        d.PPSR__c = dto.ppsr;
        d.Residual_Value__c = dto.residualValue;
        
        d.Client_Rate__c = dto.clientRate;
        d.Monthly_Fee__c = dto.monthlyFee;

        //Loan Details
        if (dto.term != null) {
            d.Term__c = Decimal.valueOf(dto.term);
        }
        d.Client_Tier__c = dto.clientTier;
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
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
        this.ericLPICalculate();
    }

    public void declineQuoteNWC() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.nwcAcceptance)) {
            dto.nwcAcceptance = 'U';    
        } else {
            dto.nwcAcceptance = 'D';    
        }
        this.ericLPICalculate();
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
        if (!InsuranceQuoteUtils.isQuotePresenting(this.quote)) {
            saveQuotingParameters();
            PageReference n = Page.InsuranceQuoteStep1;
            n.getParameters().put('id', this.Opp.Id);
            return n;
        }
        return null;
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
            ((dto.warranty != null && dto.warranty > 0) || (dto.nwc != null && dto.nwc > 0))) {
            r = true;
        }
        return r;
    }
        
    private Boolean isStandardInsProductReady()  {
        Boolean r = false;
        if (((dto.gap != null && dto.gap > 0) || (dto.tai != null && dto.tai > 0)) &&
            ((dto.warranty != null && dto.warranty > 0) || (dto.nwc != null && dto.nwc > 0))) {
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
                if (q != null) {
                    EmailSender.QuotingEmailParam param = new EmailSender.QuotingEmailParam(this.Opp, q);
                    EmailSender.sendQuotingEmailToCustomer(param);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your email has been sent it.'));
                }
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
        dto.baseRate = dto.clientRate;
        //FULL CALCULATION
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
        String quotingType = QuotingCalculation.CALC_QUOTING;
        param.totalAmount = dto.getTotalAmount(quotingType);
        param.totalInsurance = dto.getTotalInsuranceType(quotingType);
        param.totalInsuranceIncome = dto.getTotalInsuranceIncomeType(quotingType);
        param.clientRate = dto.clientRate;
        //param.baseRate = baseRate;
        param.paymentType = dto.paymentType;
        param.term = dto.term;
        param.dof = dto.dof;
        param.monthlyFee = dto.monthlyFee;
        //param.docFees = docFees;
        param.residualValue = dto.residualValue;

        param.commRate = this.getCommissionRate();

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
                param.totalAmount = dto.getTotalAmount(quotingType);
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

        //Protected
        quotingType = QuotingCalculation.CALC_PROTECTED;
        param.totalAmount = dto.getTotalAmount(quotingType);
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
        this.ericLPICalculate();
    }
    public void declineQuoteCCI() {
        if (!QuotingToolHelper.allowInsuranceActions(true)) return;
        if ('D'.equals(dto.cciAcceptance)) {
            dto.cciAcceptance = 'U';    
        } else {
            dto.cciAcceptance = 'D';    
        }
        this.ericLPICalculate();
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
    
    //Pepper API - HJ - I
    public PageReference pepperApplicationTest (){
        System.debug('>>>>> Response APPLICATION Pepper (Test)  -I  <<<<<< - ');
        try{
            ppAppService.requestApplicationTest(ppAPIManager, Opp, apiUser, PepperAPIManager.Pepper_Summer);
        }catch(GenericException ex){
            ppAPIManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        System.debug('>>>>> Response APPLICATION Pepper  (test)-F  <<<<<< - ');
        return null;
    }
    
    public PageReference pepperApplication (){
        System.debug('>>>>> Response APPLICATION Pepper  -I  <<<<<< - ');
        try{
            ppAppService.requestApplication(ppAPIManager, Opp, apiUser, PepperAPIManager.Pepper_Summer);
        }catch(GenericException ex){
            ppAPIManager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        
        if (ppAPIManager.isError && 201 != ppAPIManager.responseStatus){
            showErrorsPepperAPI();
        }else{
            pepperAPI_AppNumber = ppAPIManager.pepperAppResponseDTO.application.applicationNo;
            pepperAPI_ResponseContent = ppAPIManager.pepperAppResponseDTO.requestId;
            pepperAPI_lastResponseApp = ppAPIManager.pepperAppResponseDTO.lastResponseApplication;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Application number:   ' + pepperAPI_AppNumber));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Request Id:   ' + pepperAPI_ResponseContent));
            saveAPIInformation();
        }
        System.debug('>>>>> Response APPLICATION Pepper  -F  <<<<<< - ');
        return null;
    }
    
    private void showErrorsPepperAPI(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Savvy message: ' + ppAPIManager.message + '. Please check all the data.'));
        String sError = '';
        System.debug(sError);
        String responseMessage = StringUtils.validateNull(ppAPIManager.responseMessage);
        String[] errors = responseMessage.split('-');
        if (ppAPIManager.isError == null){
            sError = 'Status: [' + ppAPIManager.responseStatus + ']- Message: [' + StringUtils.validateNull(ppAPIManager.message) + ']- Response Message: [' + responseMessage + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }else{
            sError = 'Status: [' + ppAPIManager.responseStatus + ']- Message: [' + StringUtils.validateNull(ppAPIManager.message) + ']- Response Message: [' + responseMessage + ']';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, sError));
        }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '**Errors list**'));
        for (String e : errors){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e));
        }
    }
    
    private void saveAPIInformation(){
        this.quoting.PepperAPI_Application_Id__c  = pepperAPI_AppNumber;
        this.quoting.PepperAPI_Response_Message__c	 = pepperAPI_ResponseContent;
        this.quoting.PepperAPI_Last_Response_App__c  = pepperAPI_lastResponseApp;
        update this.quoting;
    }
    //Pepper API - HJ - F
    //
        
    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 10/07/2018*/
    public List <SelectOption> getCciLevelSelect(){
        List<SelectOption> r = new List <SelectOption>();
        for (String value : dto.cciLevels) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        if (!'A'.equals(dto.cciAcceptance))  {
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
        //String asset = dto.productGoodsType;
        nwcParam.assetType = getAssetTypeOpp();
        nwcParam.state = getStateOpp();
        isCategoryType = false;
        if ('Car'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetCar = true;
        }
        if ('Boat'.equalsIgnoreCase(nwcParam.assetType)){
            isAssetBoat = true;
            isCategoryType = true;
        }
        if ('Truck'.equalsIgnoreCase(nwcParam.assetType)){
            isCategoryType = true;
        }
        nwcParam.plan = dto.nwcPlan;
        NWCPlanOptions = NWCCalc.NWCPlanOptions(nwcParam.assetType);
        NWCTermOptions = NWCCalc.NWCTermOptions(nwcParam.assetType);
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType, nwcParam.plan);
        loadCategory();
        isNWCValidationOk = true;
        //calculateNWC();
    }
    
    private void loadCategory(){
        if (NWCTypePOptions.size() <= 2){
            nwcParam.type_p = 'NWC';
            isCategoryType = false;
        }
    }
    
    public void checkManuallyNWCPrice(){
        if (priceCustomer != null){
            nwcParam.nwcPriceToCustomer = priceCustomer;
        }
        if (nwcParam.isManuallyNWCPrice){
            Decimal priceCustomer = nwcParam.nwcPriceToCustomer;
            Long iPart = (Long) priceCustomer;
            Decimal fPart = priceCustomer - iPart;
            if (fPart > 0){
                nwcParam.nwcPriceToCustomer = NumberUtils.convertDecimalToScale(priceCustomer - 0.01, 2) ;
            }
        }
        calculateNWC();
    }
    
    public void calculateNWC(){
        NWCMessage = '';
        dto.nwcIncome = 0;
        dto.nwc = 0;
        isNWCValidationOk = true;
        NWCMessage = '';
        nwcParam.plan = dto.nwcPlan;
        nwcParam.term = dto.nwcTerm;
        nwcParam.state = getStateOpp();
        NWCTypePOptions = NWCCalc.NWCTypeOptions (nwcParam.assetType, nwcParam.plan);
        if (NWCTypePOptions.size() == 2){
            nwcParam.type_p = 'NWC';
            isCategoryType = false;
        }else{
            isCategoryType = true;
        }
        if (!StringUtils.isNullOrEmpty(nwcParam.assetType) && !StringUtils.isNullOrEmpty(nwcParam.plan) && !StringUtils.isNullOrEmpty(nwcParam.term) &&
            !StringUtils.isNullOrEmpty(nwcParam.type_p)){
                if (isAssetCar && (StringUtils.isNullOrEmpty(nwcParam.awd4wd) || StringUtils.isNullOrEmpty(nwcParam.luxuryCar))){
                        //NWCMessage = 'Missing values';
                        System.debug('Missing values: AWD4WD / LuxuryCar]');
                }else if (isAssetBoat && '----'.equalsIgnoreCase(nwcParam.type_p)){
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
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NWC Warranty: [' + NWCMessage + ']'));
                        System.debug('NWC Warranty: [' + NWCMessage + ']');
                        isNWCValidationOk = false;
                    }
                }
            }else{
                //NWCMessage = 'Missing values';
                System.debug('NWC Calculator: Missing values');
            }
        loadCategory();
    }
    
    /* New code */
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
    
    //NWC Calculator - HJ - 12-07-2018 - F
       
}