public class GeneralCalculatorExtension {    
    public Custom_Opportunity__c Opp;
    
    //Lelo                  2016-09-02
    private String fileGlobalPrefix = 'General';
    //-
    
    public GeneralCalculatorDTO dto {set;get;}
    public QuotingToolHelper qh {set;get;}
    // other things
    Map<String,id> RecordTypes {get;set;}

    //Lelo                                      2017-01-09
    public static final String LENDER_QUOTING = 'General';
    //Lelo                                      2017-07-24
    private Map<String, Application_Quoting_Result__c> calResults;
    //-
        
    //LPI Rates - Freddy Villamizar | 01/07/2018
    public String coverOption {get;set;}
    public Double premium {get;set;}
    
	private List<String> coverOptions = new List<String> {
      'Disability', 'Disability/Unemployment'
    };
        
    public GeneralCalculatorExtension(ApexPages.StandardController controller) {
        
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
        
        loadQuotingParametersSaved();
        this.premium = 0.00;
    }
    
    public PageReference baseRateCalc() {
        
        dto.clientRate = 0.0;
        
        //if (dto.brokeragePercentage == null || dto.brokeragePercentage == 0) {
        //    return null;
        //}
        if (dto.baseRate == null || dto.baseRate == 0) {
            return null;
        }
        
        //decimal totalInsurance = nwc + gap + warranty + lti + truckGap + tai + mv + cci;
        //Lelo                              2016-08-25
        //Decimal financeAmount = dto.getRealtimeNaf();
        //-
        
        //System.debug(dto.term + '|' + financeAmount);
        
        ////Client Rate
        //Decimal fv = 0.0;
        //if (dto.residualValue != null) {
        //    fv = dto.residualValue;
        //}
        //Decimal amuntPmt = dto.getBaseAmountPmtInclBrokerageCalc();
        //system.debug('amuntPmt >> ' + amuntPmt);
        //system.debug('ratePmt  >> ' + (dto.baseRate/100/12));
        //system.debug('term     >> ' + dto.term);
        //system.debug('fv-resid >> ' + fv);
        ////Decimal pmt = FinancialUtilities.pmt((amuntPmt * -1), (baseRate/100/12), Decimal.valueOf(term), fv, false);
        //if (dto.term > 0 && dto.baseRate > 0 && amuntPmt > 0) {
        //    try {
        //        Integer type = 0;
        //        if ('Advance'.equals(dto.paymentType)) 
        //            type = 1;
        //        Decimal pmt = FinancialUtilities.pmt2((dto.baseRate/100/12), dto.term, (amuntPmt * -1), fv, type);
        //        system.debug('pmt      >> ' + pmt);
        //        dto.clientRate = FinancialUtilities.rate2(dto.term, (pmt * -1.0), financeAmount, (fv * -1), type) * 12 * 100;
        //        system.debug(dto.term + '|' + (pmt * -1.0) + '|'  + financeAmount + '|' + (fv * -1) + '|0|* 12 * 100');
        //        system.debug('clientRate      >> ' + dto.clientRate);
        //        //Alternative
        //        //System.debug('ClientRate 2    >> ' + FinancialUtilities.rate(amuntPmt, Decimal.valueOf(dto.term), 0.0, fv, dto.baseRate/100/12, false));
        //    } catch (Exception e) {
        //        dto.clientRate = 0.0;
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An error has been generated during Client Rate calculation, Please adjust/check your Brokerage (%) or Base Rate.'));
        //        System.debug(e.getMessage());
        //        System.debug(e.getStackTraceString());
        //    }
            
        //}
        ////-
        dto.clientRate = getClientRateCalc(null);
        return null;
    }
    
    //Lelo                  2017-07-27
    private Decimal getClientRateCalc(String calcType) {
        Decimal r = 0.0;
        //Client Rate
        Decimal financeAmount = dto.getRealtimeNaf();
        Decimal fv = 0.0;
        if (dto.residualValue != null) {
            fv = dto.residualValue;
        }
        Decimal amuntPmt = dto.getBaseAmountPmtInclBrokerageCalc(calcType);
        system.debug('amuntPmt >> ' + amuntPmt);
        system.debug('ratePmt  >> ' + (dto.baseRate/100/12));
        system.debug('term     >> ' + dto.term);
        system.debug('fv-resid >> ' + fv);
        //Decimal pmt = FinancialUtilities.pmt((amuntPmt * -1), (baseRate/100/12), Decimal.valueOf(term), fv, false);
        if (dto.term > 0 && dto.baseRate > 0 && amuntPmt > 0) {
            try {
                Integer type = 0;
                if ('Advance'.equals(dto.paymentType)) 
                    type = 1;
                Decimal pmt = FinancialUtilities.pmt2((dto.baseRate/100/12), dto.term, (amuntPmt * -1), fv, type);
                system.debug('pmt      >> ' + pmt);
                r = FinancialUtilities.rate2(dto.term, (pmt * -1.0), financeAmount, (fv * -1), type) * 12 * 100;
                system.debug(dto.term + '|' + (pmt * -1.0) + '|'  + financeAmount + '|' + (fv * -1) + '|0|* 12 * 100');
                system.debug('clientRate      >> ' + dto.clientRate);
                //Alternative
                //System.debug('ClientRate 2    >> ' + FinancialUtilities.rate(amuntPmt, Decimal.valueOf(dto.term), 0.0, fv, dto.baseRate/100/12, false));
            } catch (Exception e) {
                r = 0.0;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An error has been generated during Client Rate calculation, Please adjust/check your Brokerage (%) or Base Rate.'));
                System.debug(e.getMessage());
                System.debug(e.getStackTraceString());
            }
            
        }
        if (r == 0.0) {
            r = dto.baseRate;
        }
        return r;
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
        // validation before calculation
        if (dto.carPrice == null || dto.carPrice == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Car Price cannot be Zero.'));
            r = false;
        }
        //if (dto.applicationFee > 0 && dto.dof > 0.0) {
        //  if ((dto.applicationFee + dto.dof) > 1000.0) {
        //      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Application Fee and DOF that their sum can only reach $1,000.'));
        //      r = false;
        //    }
        //}
        //if (dto.ppsr == null || dto.ppsr == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PPSR cannot be Zero.'));
        //    r = false;
        //}
        //if (dto.brokeragePercentage == null || dto.brokeragePercentage == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage (%) cannot be Zero.'));
        //    r = false;
        //} else if (dto.clientRate == null || dto.clientRate == 0.0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Client rate cannot be Zero.'));
        //    r = false;
        //}
        if (dto.baseRate == null || dto.baseRate == 0.0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base Rate cannot be Zero.'));
            r = false;
        }
        if (dto.brokeragePercentage > 8) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Brokerage cannot be greater than 8%'));
            r = false;
        }
        if (dto.term == null || dto.term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (dto.term > 60) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term (60 max).'));
            //r = false;
        }
        //Extra deatails
        if (String.isBlank(dto.extraLabel1) && dto.extraValue1 > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a description for the first additional detail which its value is ' + dto.extraValue1));
            r = false;
        }
        if (String.isBlank(dto.extraLabel2) && dto.extraValue2 > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a description for the second additional detail which its value is ' + dto.extraValue2));
            r = false;
        }
        if (String.isBlank(dto.extraLabel3) && dto.extraValue3 > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a description for the third detail which its value is ' + dto.extraValue3));
            r = false;
        }
        if (String.isBlank(dto.extraLabel4) && dto.extraValue4 > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a description for the fourth detail which its value is ' + dto.extraValue4));
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
        return r;
    }
    
    public PageReference calculate () {
        
        baseRateCalc();
        
        if (!isValidationOk()) {
            return null;
        }
        
        this.calculateRepayments();

        //// determine the loan type - consumer or commercial
        //Boolean type = false;
        //if (dto.paymentType == 'Advance') {
        //    type = true;
        //}
        
        //// calculate the total Amount for the finance
        //dto.nafCalculated = dto.getRealtimeNaf();
        
        
        ////Lelo                                              2016-07-29
        //Decimal realTermToCalcCommision = dto.term;
        //if (dto.term > 60) {
        //    realTermToCalcCommision = 60;
        //}
        //System.debug('The calculated realTermToCalcCommision is: ' + realTermToCalcCommision + '|' + dto.term);
        ////-
        
        //// calculate the payment rate based on client rate, which is determined by consultants
        //decimal realRate = dto.clientRate/100;
        //decimal futureValue = FinancialUtilities.fv(realRate/12,12,1000);
        //decimal rate = FinancialUtilities.rate(1000, 12, 0, futureValue, realRate/12, type);
        //System.debug('The calculated rate is: ' + rate);
        
        //// calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
        //decimal realBaseRate = dto.baseRate/100;
        //decimal baseFutureValue = FinancialUtilities.fv(realBaseRate/12,12,1000);
        //decimal baseRateValue = FinancialUtilities.rate(1000, 12, 0, baseFutureValue, realBaseRate/12, type);
        //System.debug('The calculated base rate is: ' + baseRateValue);
        
        //// calculate the monthly payment based on client rate
        //dto.rental = FinancialUtilities.pmt(dto.nafCalculated, rate, dto.term, dto.residualValue, type);
        //dto.rental = dto.rental.setScale(2);
        //System.debug('rental' + dto.rental + '|' + dto.nafCalculated + '|' + rate + '|' + dto.term + '|' + dto.residualValue + '|' + type);
        
        //// calculate the estimated commission
        ////estimatedCommission = ((rental * term) - (basePayment * term)) * 0.7 + docFees;       //Lelo          2016-09-01
        //dto.estimatedCommission = dto.brokeragePercentage / 100 * dto.getRealtimeNaf();
        //dto.estimatedCommission = dto.estimatedCommission.setScale(2);
        
        saveQuotingParameters();

        return null;
    }
    
    public PageReference reset () {
        dto = new GeneralCalculatorDTO();
        
        dto.init();
        
        //Initial values
        dto.productLoanType = 'Loan';
        dto.docFees = 0.0;
        dto.monthlyFee = 0.0;
        dto.ppsr = 0.0;
        dto.applicationFee = 0.0;
        dto.dof = 0.0;
        dto.baseRate = 5.05;
        dto.clientRate = 5.05;
        dto.term = 60;
        dto.paymentType = 'Arrears';
        dto.vehicleGroup = '1';
        dto.awd = 'N';
        dto.turbo = 'N';
        dto.diesel = 'N';
        
        dto.extraLabel1 = null;
        dto.extraValue1 = null;
        dto.extraLabel2 = null;
        dto.extraValue2 = null;
        dto.extraLabel3 = null;
        dto.extraValue3 = null;
        dto.extraLabel4 = null;
        dto.extraValue4 = null;
        
        this.resetCalculationResult(); //Lelo       2017-07-25

        return null;
    }
    
    private PageReference savePdf (String prefixName) {
        // validate the calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before generating the Pdf.'));
            return null;
        }
        
        QuotingCalculatorDTO qDto = new QuotingCalculatorDTO();
        qDto.lender = 'GENERAL CALCULATION';
        qDto.state = dto.state;
        qDto.vehicleGroup = dto.vehicleGroup;
        qDto.awd = dto.awd;
        qDto.turbo = dto.turbo;
        qDto.diesel = dto.diesel;
        qDto.gapLevel = dto.gapLevel;
        qDto.gap = String.valueOf(dto.gap);
        qDto.gapIncome = String.valueOf(dto.gapIncome);
        qDto.nwc = String.valueOf(dto.nwc);
        qDto.nwcIncome = String.valueOf(dto.nwcIncome);
        qDto.warrantyLevel = dto.warrantyLevel;
        qDto.warranty = String.valueOf(dto.warranty);
        qDto.warrantyIncome = String.valueOf(dto.warrantyIncome);
        qDto.ltiLevel = dto.ltiLevel;
        qDto.lti = String.valueOf(dto.lti);
        qDto.ltiIncome = String.valueOf(dto.ltiIncome);
        qDto.truckGapLevel = dto.truckGapLevel;
        qDto.truckGap = String.valueOf(dto.truckGap);
        qDto.truckGapIncome = String.valueOf(dto.truckGapIncome);
        qDto.taiLevel = dto.taiLevel;
        qDto.tai = String.valueOf(dto.tai);
        qDto.taiIncome = String.valueOf(dto.taiIncome);
        qDto.mvLevel = dto.mvLevel;
        qDto.mv = String.valueOf(dto.mv);
        qDto.mvIncome = String.valueOf(dto.mvIncome);
        //dto.cciLevel = String.valueOf(cciLevel);
        qDto.cci = String.valueOf(dto.cci);
        qDto.cciIncome = String.valueOf(dto.cciIncome);
        qDto.carPrice = String.valueOf(dto.carPrice);
        
        qDto.applicationFee = String.valueOf(dto.applicationFee);
        qDto.dof = String.valueOf(dto.dof.setScale(2));
        qDto.ppsr = String.valueOf(dto.ppsr);
        qDto.residualValue = String.valueOf(dto.residualValue);
        qDto.baseRate = String.valueOf(dto.baseRate);
        qDto.clientRate = String.valueOf(dto.clientRate.setScale(2));
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
        //General
        qDto.brokeragePercentage = dto.brokeragePercentage;
        qDto.paymentType = dto.paymentType;
        
        qDto.extraLabel1 = dto.extraLabel1;
        qDto.extraValue1 = dto.extraValue1;
        qDto.extraLabel2 = dto.extraLabel2;
        qDto.extraValue2 = dto.extraValue2;
        qDto.extraLabel3 = dto.extraLabel3;
        qDto.extraValue3 = dto.extraValue3;
        qDto.extraLabel4 = dto.extraLabel4;
        qDto.extraValue4 = dto.extraValue4;
        
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
        calcPdf.getParameters().put('gapLevel', qDto.gapLevel);
        calcPdf.getParameters().put('gap', qDto.gap);
        calcPdf.getParameters().put('gapIncome', qDto.gapIncome);
        calcPdf.getParameters().put('nwc', qDto.nwc);
        calcPdf.getParameters().put('nwcIncome', qDto.nwcIncome);
        calcPdf.getParameters().put('warrantyLevel', qDto.warrantyLevel);
        calcPdf.getParameters().put('warranty', qDto.warranty);
        calcPdf.getParameters().put('warrantyIncome', qDto.warrantyIncome);
        calcPdf.getParameters().put('ltiLevel', qDto.ltiLevel);
        calcPdf.getParameters().put('lti', qDto.lti);
        calcPdf.getParameters().put('ltiIncome', qDto.ltiIncome);
        calcPdf.getParameters().put('truckGapLevel', qDto.truckGapLevel);
        calcPdf.getParameters().put('truckGap', qDto.truckGap);
        calcPdf.getParameters().put('truckGapIncome', qDto.truckGapIncome);
        calcPdf.getParameters().put('taiLevel', qDto.taiLevel);
        calcPdf.getParameters().put('tai', qDto.tai);
        calcPdf.getParameters().put('taiIncome', qDto.taiIncome);
        calcPdf.getParameters().put('mvLevel', qDto.mvLevel);
        calcPdf.getParameters().put('mv', qDto.mv);
        calcPdf.getParameters().put('mvIncome', qDto.mvIncome);
        //calcPdf.getParameters().put('cciLevel', cciLevel);
        calcPdf.getParameters().put('cci', qDto.cci);
        calcPdf.getParameters().put('cciIncome', qDto.cciIncome);
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
        
        calcPdf.getParameters().put('brokeragePercentage', String.valueOf(qDto.brokeragePercentage));
        calcPdf.getParameters().put('privateSales', qDto.privateSales);
        calcPdf.getParameters().put('saleBacksPurchased', qDto.saleBacksPurchased);
        calcPdf.getParameters().put('carAge', qDto.carAge);
        calcPdf.getParameters().put('paymentType', qDto.paymentType);
        
        calcPdf.getParameters().put('extraLabel1', qDto.extraLabel1);
        if (qDto.extraValue1 != null)
            calcPdf.getParameters().put('extraValue1', String.valueOf(qDto.extraValue1.format()));
        calcPdf.getParameters().put('extraLabel2', qDto.extraLabel2);
        if (qDto.extraValue2 != null)
            calcPdf.getParameters().put('extraValue2', String.valueOf(qDto.extraValue2.format()));
        calcPdf.getParameters().put('extraLabel3', qDto.extraLabel3);
        if (qDto.extraValue3 != null)
            calcPdf.getParameters().put('extraValue3', String.valueOf(qDto.extraValue3.format()));
        calcPdf.getParameters().put('extraLabel4', qDto.extraLabel4);
        if (qDto.extraValue4 != null)
            calcPdf.getParameters().put('extraValue4', String.valueOf(qDto.extraValue4.format()));
        
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
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calculation PDF saved successfully.'));
        
        return null;
    } // end of function
    
    
    private PageReference saveProduct (String prefixName) {
        baseRateCalc();
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }
        calculate();
        
        // validate calculation
        if (dto.rental == null || dto.rental == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please calculate before sending to approval.'));
            return null;
        }
        
        // this function will update the product no matter what the existing data stored in Product
        // If there isn't product existing, it will create a new product
        // The current mechanism is that opportunity cannot be created without product
        // so far only override the product, later we may not require product and use this function to create the product
        
        //Lelo                                  2016-07-26
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
        updateProduct.Lender__c = 'General';
        updateProduct.Quoting_Source__c = 'General';
        updateProduct.Repayment_Regularity__c = 'Monthly';
        
        updateProduct.Loan_Type__c = dto.loanType;
        updateProduct.Loan_Product__c = dto.productLoanType;
        //updateProduct.Loan_Type_Detail__c = dto.loanTypeDetail;

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
        
        updateProduct.Deposit__c = dto.getNetDeposit();
        updateProduct.DOF__c = dto.dof;
        
        if (dto.estimatedCommission == null) {
            updateProduct.Brokerage__c = 0;
        } else {
            updateProduct.Brokerage__c = dto.estimatedCommission;
        }
        updateProduct.Lender_App_Fee__c = dto.applicationFee;
        updateProduct.Equalisation_Fee_PPSR__c = dto.ppsr;
        
        //Lelo                      2016-07-26
        upsert updateProduct;
        QuotingToolHelper.removePreviousInsurances(this.Opp.Id);
        List<Product__c> productList = new List<Product__c>();
        //-
        
        // then create the insurance products
        // Gap Insurance
        if (dto.gapLevel == null || dto.gapLevel == '') {
            if (dto.gap == null || dto.gap == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gap price has been filled without Gap level chosen.'));
            }
        } else {
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
        if (dto.warrantyLevel == null || dto.warrantyLevel == '') {
            if (dto.warranty == null || dto.warranty == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warranty price has been filled without Gap level chosen.'));
            }
        } else {
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
        if (dto.ltiLevel == null || dto.ltiLevel == '') {
            if (dto.lti == null || dto.lti == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'LTI price has been filled without Gap level chosen.'));
            }
        } else {
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
        // Truck Gap Insurance
        if (dto.truckGapLevel == null || dto.truckGapLevel == '') {
            if (dto.truckGap == null || dto.truckGap == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap price has been filled without Gap level chosen.'));
            }
        } else {
            Product__c newInsurance = new Product__c ();
            newInsurance.Opportunity_Name__c = Opp.Id;
            newInsurance.RecordTypeId = RecordTypes.get('Insurance');
            newInsurance.Insurance_Type__c = 'Truck Gap Insurance';
            if (dto.truckGap == null || dto.truckGap == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap price is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Policy_Amount__c = dto.truckGap;
            }
            if (dto.truckGapIncome == null || dto.truckGapIncome == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Truck Gap Commission is not updated as the calculator does not contain relevant info.'));
            } else {
                newInsurance.Insurance_Commission__c = dto.truckGapIncome;
            }
            newInsurance.Insurer__c = 'AIC/Eric';
            //Lelo                                  2016-07-27
            //insert newInsurance;
            productList.add(newInsurance);
            //-
        }
        // TAI/RTI Insurance
        if (dto.taiLevel == null || dto.taiLevel == '') {
            if (dto.tai == null || dto.tai == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'TAI/RTI price has been filled without Gap level chosen.'));
            }
        } else {
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
        if (dto.mvLevel == null || dto.mvLevel == '') {
            if (dto.mv == null || dto.mv == 0) {
                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'MV price has been filled without Gap level chosen.'));
            }
        } else {
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
        // CCI Insurance
        if (dto.cci == null || dto.cci == 0) {
            
        } else {
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
        if (dto.nwc == null || dto.nwc == 0) {
            
        } else {
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
        
        //Lelo                              2016-07-27
        if (productList.size() > 0) {
            insert productList;
        }
        //-
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully.'));
        return null; 
        
    } // end of function
    
    
    //Lelo                                  2016-07-26
    public PageReference saveQuoting() {
        return savePdf(fileGlobalPrefix);
    }
    
    public PageReference savePreApproval() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL');
    }
    
    public PageReference saveAmendment() {
        
        return saveProduct(fileGlobalPrefix + '_PRE_APPROVAL_AMENDMENT');
    }
    
    public PageReference saveFormalApproval() {
        return saveProduct(fileGlobalPrefix + '_FORMAL_APPROVAL');
    }
    //-
    
    //Lelo                                  2016-12-22
    private void loadQuotingParametersSaved() {
        System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (d != null) {
            System.debug('A quoting has been loading...');
            //Fill all form fields
            //********************************************
            //Vehicle Details
            dto.state = d.Vehicle_Detail_State__c;
            dto.vehicleGroup = d.Vehicle_Detail_Group__c;
            dto.awd = d.Vehicle_Detail_AWD__c;
            dto.turbo = d.Vehicle_Detail_Turbo__c;
            dto.diesel = d.Vehicle_Detail_Diesel__c;
            //Insurance Product
            dto.gapLevel = d.Insurance_GAP_Type__c;
            dto.gap = d.Insurance_GAP_Retail_Price__c;
            dto.gapIncome = d.Insurance_GAP_Income__c;
            dto.warrantyLevel  = d.Insurance_Warranty_Type__c;
            dto.warranty = d.Insurance_Warranty_Retail_Price__c;
            dto.warrantyIncome = d.Insurance_Warranty_Income__c;
            dto.ltiLevel = d.Insurance_LTI_Type__c;
            dto.lti = d.Insurance_LTI_Retail_Price__c;
            dto.ltiIncome = d.Insurance_LTI_Income__c;
            dto.truckGapLevel = d.Insurance_Truck_GAP_Type__c;
            dto.truckGap = d.Insurance_Truck_GAP_Retail_Price__c;
            dto.truckGapIncome = d.Insurance_Truck_GAP_Income__c;
            dto.taiLevel = d.Insurance_TAI_Type__c;
            dto.tai = d.Insurance_TAI_Retail_Price__c;
            dto.taiIncome = d.Insurance_TAI_Income__c;
            dto.mvLevel = d.Insurance_MV_Type__c;
            dto.mv = d.Insurance_MV_Retail_Price__c;
            dto.mvIncome = d.Insurance_MV_Income__c;
            dto.cci = d.Insurance_AIC_Retail_Price__c;
            dto.cciIncome = d.Insurance_AIC_Income__c;
            dto.nwc = d.Insurance_NWC_Retail_Price__c;
            dto.nwcIncome = d.Insurance_NWC_Income__c;
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

            if (LENDER_QUOTING.equals(d.Name)) {
                //Specific values                
                dto.brokeragePercentage = d.Brokerage__c;
                dto.baseRate = d.Base_Rate__c > 0.00 ? d.Base_Rate__c.setScale(2) : dto.baseRate;
                
                
                //Loan Details
                dto.paymentType = d.Payment__c;
                dto.monthlyFee = d.Monthly_Fee__c;

                dto.extraLabel1 = d.Extra_Label_1__c;
                dto.extraLabel2 = d.Extra_Label_2__c;
                dto.extraLabel3 = d.Extra_Label_3__c;
                dto.extraLabel4 = d.Extra_Label_4__c;

                dto.extraValue1 = d.Extra_Value_1__c;
                dto.extraValue2 = d.Extra_Value_2__c;
                dto.extraValue3 = d.Extra_Value_3__c;
                dto.extraValue4 = d.Extra_Value_4__c;
                
                dto.applicationFee = d.Application_Fee__c;
                dto.dof = d.DOF__c;
                dto.ppsr = d.PPSR__c;    
                                
                //Load Calculations
                dto.estimatedCommission = d.Commission_Estimation__c;
                dto.rental = d.Rental__c;
                dto.nafCalculated = d.NAF__c;
                
                baseRateCalc();

                //Load calculations
                this.calResults = QuotingCalculation.getMapQuotingResultsByQuoId(d.Id);

            }
        }
    }

    private void saveQuotingParameters() {
        System.debug('Saving Quoting...' + LENDER_QUOTING);
        Application_Quoting__c d = new Application_Quoting__c();
        Application_Quoting__c s = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (s != null) {
            System.debug('Setting the Quoting Id... for app >> ' + this.Opp.Application__c);
            d.Id = s.Id; 
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
        //Insurance product
        d.Insurance_GAP_Type__c = dto.gapLevel;
        d.Insurance_GAP_Retail_Price__c = dto.gap;
        d.Insurance_GAP_Income__c = dto.gapIncome;
        d.Insurance_Warranty_Type__c = dto.warrantyLevel;
        d.Insurance_Warranty_Retail_Price__c = dto.warranty;
        d.Insurance_Warranty_Income__c = dto.warrantyIncome;
        d.Insurance_LTI_Type__c = dto.ltiLevel;
        d.Insurance_LTI_Retail_Price__c = dto.lti;
        d.Insurance_LTI_Income__c = dto.ltiIncome;
        d.Insurance_Truck_GAP_Type__c = dto.truckGapLevel;
        d.Insurance_Truck_GAP_Retail_Price__c = dto.truckGap;
        d.Insurance_Truck_GAP_Income__c = dto.truckGapIncome;
        d.Insurance_TAI_Type__c = dto.taiLevel;
        d.Insurance_TAI_Retail_Price__c = dto.tai;
        d.Insurance_TAI_Income__c = dto.taiIncome;
        d.Insurance_MV_Type__c = dto.mvLevel;
        d.Insurance_MV_Retail_Price__c = dto.mv;
        d.Insurance_MV_Income__c = dto.mvIncome;
        d.Insurance_AIC_Retail_Price__c = dto.cci;
        d.Insurance_AIC_Income__c = dto.cciIncome;
        d.Insurance_NWC_Retail_Price__c = dto.nwc;
        d.Insurance_NWC_Income__c = dto.nwcIncome;
         //Finance Details
        d.Loan_Type__c = dto.loanType;
        d.Loan_Product__c = dto.productLoanType;
        
        d.Vehicle_Price__c = dto.carPrice;
        d.Deposit__c = dto.deposit;
        d.Trade_In__c = dto.tradeIn;
        d.Payout_On__c = dto.payoutOn;
        
        d.Application_Fee__c = dto.applicationFee;
        d.DOF__c = dto.dof;
        d.PPSR__c = dto.ppsr;
        d.Residual_Value__c = dto.residualValue;
        
        d.Client_Rate__c = dto.clientRate;
        d.Base_Rate__c = dto.baseRate;
        d.Brokerage__c = dto.brokeragePercentage;
        
        //Loan Details
        if (dto.term != null) {
            d.Term__c = Decimal.valueOf(dto.term);
        }

        d.Monthly_Fee__c = dto.monthlyFee;
        d.Payment__c = dto.paymentType;

        d.Extra_Label_1__c = dto.extraLabel1;
        d.Extra_Label_2__c = dto.extraLabel2;
        d.Extra_Label_3__c = dto.extraLabel3;
        d.Extra_Label_4__c = dto.extraLabel4;

        d.Extra_Value_1__c = dto.extraValue1;
        d.Extra_Value_2__c = dto.extraValue2;
        d.Extra_Value_3__c = dto.extraValue3;
        d.Extra_Value_4__c = dto.extraValue4;

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

    }
    //-      
    
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
        if (hasCalculationDone()) {
            saveQuotingParameters();
        }
    }

    public void sendCustomerEmail2() {
        System.debug('sendCustomerEmail2...');
        if (hasCalculationDone()) {
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
        param.paymentType = dto.paymentType;
        param.term = dto.term;
        param.dof = dto.dof;
        param.monthlyFee = dto.monthlyFee;
        param.residualValue = dto.residualValue;
        param.brokeragePer = dto.brokeragePercentage;

        System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

        Application_Quoting_Result__c r = QuotingCalculation.calculate(param);
        if (r != null) {
            dto.estimatedCommission = r.Estimated_Commission__c;
            dto.nafCalculated = r.NAF__c;
            dto.rental = r.Rental__c;
            r.Result_Type__c = quotingType;
        }
        calResults.put(quotingType, r);

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

    //--ERIC LPI Rate amount
    /*This method lets painting, initially, all cover Option for LPI Rate  - Freddy Villamizar | 01/07/2018*/
    public List <SelectOption> getCoverOptionSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption('','--None--'));
        for (String value : coverOptions) {
            r.add(new SelectOption (value, value));
        }
        return r;
    }
    
    public void ericLPICalculate(){
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = coverOption;
        parameters.term = MATH.round(dto.term/12);
        parameters.initialAmount = 30000;
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        
        this.premium = results != null? results.premium : null;
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}