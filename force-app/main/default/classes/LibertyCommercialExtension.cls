public class LibertyCommercialExtension extends QuotingExtension {

    //Lelo					2016-07-26
    private String fileGlobalPrefix = 'Liberty_Commercial';
    //Lelo                                      2016-12-20
    public static final String LENDER_QUOTING = 'Liberty Commercial';
    //-
    // finance calculator input
    public Integer ltv {get;set;}
    //public String loanTypeDetail {get;set;}
    public String vehicleAge {get;set;}
    public List <SelectOption> vehicleAges {get;set;}
    
    // rates references
    public List <LibertyDrive__c> libertyRates {get;set;}
    Map <String,LibertyDrive__c> LibertyDriveRates {get;set;}
    
    // addtional loan information
    public List <SelectOption> productLoanTypes {get;set;}
    public List <SelectOption> productGoodsTypes {get;set;}
    //-
    
    //HJ - Liberty API - I
    public LibertyApplicationService libertyService;
    public String libertyAPI_Status {set; get;}
    public String libertyAPI_AppNumber {set; get;}
    public String libertyAPI_ResponseContent {set; get;}
    public String libertyAPI_lastResponseApp {set; get;}
    public List <SelectOption> usersAPIOptions {get;set;}
    public String apiUser {get;set;}
    public Boolean paramActive {set; get;}
    //HJ - Liberty API -F
    
    public Decimal eqfee {set;get;}
    public String creditScore {set;get;}
    //public String enquiries {set;get;}
    
    //Liberty Rate - HJ - 07-11-2018 - I
    //public Boolean disabledRateType {set; get;}
    //public String rateType {set; get;}
    public Decimal maxRate {set; get;}
    public String propertyOwner {set; get;}
    //Liberty Rate - HJ - 07-11-2018 - F
    public String abnLength {set; get;}
    public String gstLength {set; get;}
    public Decimal applicationFeeMax {get;set;}
    public String vehicleYear {set; get;}

    public LibertyCommercialExtension (ApexPages.StandardController controller) {
        super(controller);
        
        //HJ - Liberty API -I
        String active = System.currentPageReference().getParameters().get('active');
        paramActive = !StringUtils.isNullOrEmpty(active);
        //HJ - Liberty API - F
        
        this.productGoodsTypes = new List <SelectOption> ();
        this.productGoodsTypes.add(new SelectOption ('Car/Light commercial', 'Car/Light commercial'));
        this.productLoanTypes = QuotingToolHelper.getLoanProductOptionsCommercial();

        this.quotingName = LENDER_QUOTING;
        this.reset();

        LibertyDriveRates = LibertyDrive__c.getAll();
        System.debug('The map value: ' + LibertyDriveRates);
        libertyRates = LibertyDriveRates.values();
        libertyRates.sort();
                
        preLoadQuotingValues();
        
        //HJ - Liberty API
        libertyService = new LibertyApplicationService();
        usersAPIOptions = LibertyServiceManager.getUserOptionsConnect();
        
        //NWC Calculator - HJ - 12-07-2018 - I
        loadNWCParameters();
        //NWC Calculator - HJ - 12-07-2018 - F
        this.loadVehicleAges();
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
                if (lender != null && lender.info != null && 'LICO'.equals(lender.info.Code__c)) {
                    this.carPrice = lender.carPrice;
                    this.deposit = lender.deposit;
                    this.term = lender.term;
                    this.productGoodsType = lender.productGoodsType;
                    this.productLoanType = lender.productLoanType;
                    this.vehicleAge = lender.vehicleYear;
                    this.clientTier = lender.clientTier;
                    if ('AAA'.equals(this.clientTier)) {
                        this.propertyOwner = 'Y';
                    }
                    this.creditScore = '0';
                    this.residualValue = lender.residual;
                    this.ltv = 0;
                    if (lender.carAge != null) {
                        this.vehicleAge = String.valueOf(lender.carAge);
                    }
                    //Lelo                          2017-11-16
                    this.clientRate = lender.clientRate;
                    this.dof = lender.dofBase;                    
                    //
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
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      param.productLoanType = this.productLoanType;
      clientTier = getRiskGrade();
      param.clientTier = this.clientTier;
      param.vehicleYear = this.vehicleAge;
      //param.loanTypeDetail = this.rateType;
      param.residualValue = this.residualValue;
      // System.debug(Json.serializePretty(param));
      this.baseRate = QuotingCalculation.getBaseRate(param);
      this.maxRate = QuotingCalculation.getMaximunBaseRate(param);
      System.debug('baseRate: ' + baseRate + '|this.maxRate: ' + this.maxRate);
    } //end of funcion
    
    public override void realtimeNafCalc () {
        netDepositCalc();
        this.calcDOF();
        realtimeNaf = 0;
        realtimeNaf += getTotalAmount(QuotingCalculation.CALC_QUOTING);
        realtimeNaf += getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        Decimal baseEqFee = this.getTotalAmountExcFees(QuotingCalculation.CALC_QUOTING);
        baseEqFee += getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
        this.eqfee = this.calculateEQFee(QuotingCalculation.CALC_QUOTING);
        this.realtimeNaf += this.eqfee;
        this.calculateLPI();
    } //end of funcion
    
    private Boolean isValidationOk() {
        Boolean r = true;
        // validation before calculation
        if (baseRate == null || baseRate == 0.0 || baseRate < 0) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Base Rate cannot be Zero.'
              )
            );
            r = false;
        }
        if (String.isBlank(creditScore)) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,
              'Credit Score is required'
            )
          );
          r = false;
        }
        if (String.isBlank(abnLength)) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,
              'ABN Length is required'
            )
          );
          r = false;
        }
        if (String.isBlank(gstLength)) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.ERROR,
              'GST Length is required'
            )
          );
          r = false;
        }
        if (clientRate == null || clientRate == 0.0) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Client Rate cannot be Zero.'
              )
            );
            r = false;
        } else if (baseRate != null && clientRate != null) {
            if (this.clientRate < this.baseRate) {
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Client rate can not be below of the base rate.'
                  )
                );
                r = false;
            } else {
                //Decimal difRate = Math.abs(clientRate-baseRate);
                //if (difRate > 2.00) {
                if (this.clientRate > this.maxRate) {
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Client rate can not be greater of '+ this.maxRate +'%.'
                      )
                    );
                    r = false;
                }
            }
        }
        Double maxAppFee = this.lenderSettings.Application_Fee__c + this.lenderSettings.DOF__c;
        /*
        Decimal lenderAppFee = ('Consumer Loan'.equals(productLoanType)) 
          ? this.lenderSettings.Application_Fee__c 
          : this.lenderSettings.Application_Fee_Private__c;
        Decimal maxAppFee = lenderAppFee + this.lenderSettings.DOF__c;
        */
        //if (this.applicationFee == null || this.applicationFee < lenderAppFee) {
        if (this.applicationFee == null || this.applicationFee < lenderSettings.Application_Fee__c ) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Application fee cannot fall below $' + lenderSettings.Application_Fee__c.format()
              )
            );
            r = false;
        } else if (this.applicationFee > maxAppFee) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The application fee cannot exceed $' + maxAppFee.format()));
            r = false;
        }
        if ((this.dof == null || this.dof < this.lenderSettings.DOF__c) 
        && String.isNotBlank(clientTier)) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'DOF is less than maximum $' + this.lenderSettings.DOF__c.format()
              )
            );
        }
/*
        if (term == null || term == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an appropriate term.'));
            r = false;
        } else if (term > 84 && ('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier))) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'Maximum term is 84 months (7 years) for ' + this.clientTier + ' tier - refer to Liberty'
              )
            );
            //r = false;
        }else if (term > 60 && !('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum term is 60 months (5 years) for ' + this.clientTier + ' tier - refer to Liberty'));
            //r = false;
        }
*/
        if (term > 60 && ('B'.equals(this.clientTier) || 'C'.equals(this.clientTier))) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum term is 60 months (5 years) for ' + this.clientTier + ' risk grade - refer to Liberty'));
        }

        if (term == 84 && ('B'.equals(this.clientTier) || 'C'.equals(this.clientTier))) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Warning: 7 year term not available on B & C risk grades'));
        }
        /*
        if (productLoanType == 'Consumer Loan' && 'AAA'.equals(this.clientTier)) {
            if (String.isBlank(this.creditScore)) {
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Credit Score value is required.'
                  )
                );
                r = false;
            } else if (!this.creditScore.isNumeric()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Credit Score should be an integer number.'));
                r = false;
            }
            if (String.isBlank(this.enquiries)) {
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    '# of enquiries is required.'
                  )
                );
                r = false;
            } else if (!this.enquiries.isNumeric()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'# of enquiries should be an integer number.'));
                r = false;
            }
        }
        */
        if (String.isBlank(this.vehicleAge)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age selection is required.'));
            r = false;
        }
        if (this.ltv == null) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'LTV value is required.'
              )
            );
            r = false;   
        } else {
            /*
            Integer ltvLimit = 150;
            if (this.realtimeNaf < 10000 && !'AAA'.equals(this.clientTier)) {
                ltvLimit = 120;
            }
            */
            Integer ltvLimit;
            String creditHistory;
            Integer maximumLoan = 50000;
            if ('AAA'.equals(this.clientTier)) {
              ltvLimit = 120;
              maximumLoan = 100000;
              creditHistory = 'Warning: No adverse allowed';
            } else if ('AA'.equals(this.clientTier)) {
              ltvLimit = 150;
              maximumLoan = 100000;
              creditHistory = 'Warning: No adverse allowed';
            } else if ('A'.equals(this.clientTier) 
            && 'N'.equals(propertyOwner)) {
              ltvLimit = 100;
              creditHistory = 'Warning: No adverse and confirmable credit required.';
              maximumLoan = 80000;
            } else if ('A'.equals(this.clientTier) 
            && 'Y'.equals(propertyOwner)) {
              ltvLimit = 150;
              creditHistory = 'Warning: Non financial defaults> 12 mths and < $1000';
              maximumLoan = 80000;
            } else if ('B'.equals(this.clientTier) 
            && 'Y'.equals(propertyOwner)) {
              ltvLimit = 120;
            } else if ('B'.equals(this.clientTier) 
            && 'N'.equals(propertyOwner)) {
              ltvLimit = 90;
            } else if ('C'.equals(this.clientTier) 
            && 'Y'.equals(propertyOwner)) {
              ltvLimit = 100;
            } else if ('C'.equals(this.clientTier) 
            && 'N'.equals(propertyOwner)) {
              ltvLimit = 80;
              maximumLoan = 35000;
            }

            if ('No GST'.equals(gstLength)) {
              maximumLoan = 35000;
            }

            if (this.ltv > ltvLimit) {
                ApexPages.addMessage(new ApexPages.Message(
                  ApexPages.Severity.WARNING,
                  'Maximum value for LTV is '+ltvLimit+'%.'));
                //r = false;       
            }
            if (String.isNotBlank(creditHistory)) {
              ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.WARNING,creditHistory));
            }
            if (realtimeNaf > maximumLoan && String.isNotBlank(clientTier)) {
              ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'The maximum loan amount is $'+maximumLoan));
              //r = false;
            }
        }

        if (this.realtimeNaf < 5000) {
            ApexPages.addMessage(new ApexPages.Message(
              ApexPages.Severity.ERROR,'The minimum Loan Amount is $5,000'));
            r = false;
        }

        //Integer vehicleAgeYear = 0;
        //Decimal percentageResidual = 0.0;
        if (this.opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please save a Asset Detail - LTV before quoting.'));
            //r = false;
        }

        // if(!validateVehicleAgeWithYear(aad)){
        //     //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age does not match with the Vehicle Year in Asset Details / Application form page.'));
        //     //r = false;
        // }else {
            
        // }
        /*
        if ('Consumer Loan'.equals(productLoanType)) {
            Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Id);
            vehicleAgeYear = getVehicleAgeToYear(aad);
            if (vehicleAgeYear != null) {
                vehicleAgeYear = Date.Today().year() - vehicleAgeYear;
            }
        } else {
            if ('New'.equals(this.vehicleAge)) {
                vehicleAgeYear = 0;
            } else if (String.isNotBlank(this.vehicleAge) && this.vehicleAge.isNumeric()) {
                vehicleAgeYear = Integer.valueOf(this.vehicleAge);
            }
        }
*/
        if (String.isNotBlank(clientTier) && !('AAA'.equals(this.clientTier) 
        || 'AA'.equals(this.clientTier)) && this.residualValue != null 
        && this.residualValue > 0){
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING,
              'Residuals are not available for risk grades A,B,C. Refer to your bdm'
            )
          );
        }
/*
        if (!('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier)) && this.residualValue != null && this.residualValue > 0){
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'Residuals are not available for risk grades A,B,C. Refer to your bdm'
              )
            );
            // r = false;
        }else if (this.residualValue != null){
            Decimal vp = this.carPrice - this.netDeposit;
            if (vp > 0) {
                percentageResidual = (this.residualValue / (this.carPrice - this.netDeposit)) * 100.0;
                percentageResidual = percentageResidual.setScale(2);
            }
        }
        */
        /*
        if (vehicleAgeYear != null ){
            Integer totalAge = (term / 12) + vehicleAgeYear;
            if (totalAge > 8 && this.residualValue != null && this.residualValue > 0){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum vehicle age at end adding Term and Vehicle Age should be 8 years'
                  )
                );
                //r = false;
            }else if (totalAge > (20*12)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum vehicle age at end adding Term and Vehicle Age should be 20 years'));
                //r = false;
            }
        }
        */
        /*
        if (vehicleAgeYear != null && 'Consumer Loan'.equals(productLoanType) && percentageResidual != null){
            if ((term == (3*12) || term == (4*12) || term == (5*12)) && 'AAA'.equals(this.clientTier) 
                && vehicleAgeYear <= 5 && percentageResidual > 30){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 30%'
                  )
                );
                //r = false;
            } else if (term == (3*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 2 && percentageResidual > 50){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 50%'
                  )
                );
                //r = false;
            } else if (term == (3*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 5 && percentageResidual > 30){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 30%'
                  )
                );
                //r = false;
            } else if (term == (4*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 2 && percentageResidual > 40){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,'Maximum value for Residual Value and ' + this.clientTier + ' tier is 40%'
                  )
                );
                //r = false;
            }else if (term == (4*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 5 && percentageResidual > 20){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 20%'
                  )
                );
                //r = false;
            }else if (term == (5*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 2 && percentageResidual > 30){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 30%'
                  )
                );
                //r = false;
            }else if (term == (5*12) && 'AA'.equals(this.clientTier) && vehicleAgeYear <= 5 && percentageResidual > 0){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum value for Residual Value and ' + this.clientTier + ' tier is 0%'
                  )
                );
                //r = false;
            }
        } else if (vehicleAgeYear != null && !'Consumer Loan'.equals(productLoanType) && percentageResidual != null && percentageResidual > 0.0){
            if ('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier)) {
                if (term == (3*12) && vehicleAgeYear <= 2 && percentageResidual > 50){
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.WARNING,
                        '50% Maximum Balloon for Vehicle Age <= 2 years. Currently ' + percentageResidual + '%'
                      )
                    );
                    //r = false;
                } else if (term == (3*12) && vehicleAgeYear > 2 && vehicleAgeYear <= 5 && percentageResidual > 30) {
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.WARNING,
                        '30% Maximum Balloon for Vehicle Age <= 5 years. Currently ' + percentageResidual + '%'
                      )
                    );
                    //r = false;
                } else if (term == (4*12) && vehicleAgeYear <= 2 && percentageResidual > 40) {
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.WARNING,
                        '40% Maximum Balloon for Vehicle Age <= 2 years. Currently ' + percentageResidual + '%'
                      )
                    );
                    //r = false;
                } else if (term == (4*12) && vehicleAgeYear > 2 && vehicleAgeYear <= 5 && percentageResidual > 20){
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.WARNING,
                        '20% Maximum Balloon for Vehicle Age <= 5 years. Currently ' + percentageResidual + '%'
                      )
                    );
                    //r = false;
                } else if (term == (5*12) && vehicleAgeYear <= 2 && percentageResidual > 30){
                    ApexPages.addMessage(
                      new ApexPages.Message(
                        ApexPages.Severity.WARNING,
                        '30% Maximum Balloon for Vehicle Age <= 2 years. Currently ' + percentageResidual + '%'
                      )
                    );
                    //r = false;
                } else if ((term == (5*12) && vehicleAgeYear > 2)) {
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.WARNING,
                            'Ballon not allowed for ' + this.clientTier + ' tier and ' + term + ' months term.'));
                    //r = false;
                } else if ((term == (4*12) && vehicleAgeYear > 5) ||
                           (term == (3*12) && vehicleAgeYear > 5)) {
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.WARNING,
                            'Ballon not allowed for ' + this.clientTier + ' tier, ' + term + ' months term and ' + vehicleAgeYear + ' years old.'));
                    //r = false;
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Ballon not allowed for ' + this.clientTier + ' tier'));
            }
        }
*/
        //Liberty Rate - HJ - 07-11-2018 - I
/*
        if (productLoanType != 'Consumer Loan' && 'Star'.equals(this.rateType) && this.realtimeNaf > 100000 
            && ('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier) || 'A'.equals(this.clientTier))) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,'Maximum value for '+ this.clientTier + ' tier is $100,000.'
              )
            );
            //r = false;
        }else if (productLoanType != 'Consumer Loan' && 'Star'.equals(this.rateType) && this.realtimeNaf > 50000 
            && ('B'.equals(this.clientTier) || 'C'.equals(this.clientTier))) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'Maximum value for '+ this.clientTier + ' tier is $50,000.'
              )
            );
            //r = false;
        }else if (productLoanType != 'Consumer Loan' && 'Nova'.equals(this.rateType) && this.realtimeNaf > 80000 
            && ('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier))) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.WARNING,
                'Maximum value for '+ this.clientTier + ' tier is $80,000.'
              )
            );
            //r = false;
        }
*/
        if ('N'.equals(this.propertyOwner) && 'AAA'.equals(this.clientTier)) {
            ApexPages.addMessage(
              new ApexPages.Message(
                ApexPages.Severity.ERROR,
                //this.clientTier + ' tier unavalible for Non-home owner'
                this.clientTier + ' risk grade unavailable for Non-home owner'
              )
            );
            r = false;
        }
        //Liberty Rate - HJ - 07-11-2018 - F
/*
        if (String.isNotBlank(this.productLoanType) && !'Consumer Loan'.equals(this.productLoanType)) {
            if ('Star'.equals(this.rateType) && !this.productLoanType.contains('Full-Doc')) {
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    '"Star" is Liberty Full Doc, so please change Loan product'
                  )
                );
                r = false;
            }
            if ('Nova'.equals(this.rateType) && !this.productLoanType.contains('Low-Doc')) {
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    '"Nova" is Liberty Low Doc, so please change Loan product'
                  )
                );
                r = false;
            }
        }
*/
/*
        if ('Caravan'.equals(productGoodsType) && !'Y'.equals(this.propertyOwner) && carPrice > 0 && (netdeposit/carPrice) < 0.25) {
          ApexPages.addMessage(
            new ApexPages.Message(
              ApexPages.Severity.WARNING,
              'Non property owners may require a 25% deposit. Check with your lender'
            )
          );
        }
*/
        if (!isInsuranceValidationOK()) {
            r = false;   
        }
        //Lelo              2017-09-19
        /**
        if (residualValue > 0 && term > 60) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot have a balloon or residual payment when the loan term is > 5 years.'));
            r = false;
        }
		**/
      if (String.isBlank(vehicleYear)) {
        ApexPages.addMessage(new ApexPages.Message(
          ApexPages.Severity.ERROR,'Vehicle Year is required.'));
        r = false;
      } else if ('New'.equals(vehicleAge) && Date.today().year() - 
      Integer.valueOf(vehicleYear) > 1) {
        ApexPages.addMessage(new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Vehicle Year should be '+Date.today().year()));
        r = false;
      } else if ('0-4 years'.equals(vehicleAge) && Date.today().year() - 
      Integer.valueOf(vehicleYear) > 4) {
        ApexPages.addMessage(new ApexPages.Message(
          ApexPages.Severity.ERROR,'Vehicle Year should be less than 4 years'));
        r = false;
      } else if ('5-9 years'.equals(vehicleAge) && (Date.today().year() - 
      Integer.valueOf(vehicleYear) < 5 || Date.today().year() - 
      Integer.valueOf(vehicleYear) > 9)) {
        ApexPages.addMessage(new ApexPages.Message(
          ApexPages.Severity.ERROR,'Vehicle Year should be between '
          +(Date.today().year()-9)+' and '+(Date.today().year()-5)));
        r = false;
      } else if ('10+ years'.equals(vehicleAge) && Date.today().year() - 
      Integer.valueOf(vehicleYear) < 10) {
        ApexPages.addMessage(new ApexPages.Message(
          ApexPages.Severity.ERROR,'Vehicle Year shouldn\'t be less than 10 years'));
        r = false;
      } else {
        if (residualValue > 0) {
          if('AAA'.equals(this.clientTier) || 'AA'.equals(this.clientTier)){
            Decimal resPer = this.residualValue / 
            (this.carPrice - this.netDeposit) * 100.0;
            Decimal comp = 0.0;
            Integer vehicleAge = Date.today().year() - 
            Integer.valueOf(vehicleYear);
            if (vehicleAge == 3) {
              comp = 50;
            } else if (vehicleAge == 4) {
              comp = 40;
            } else if (vehicleAge == 5) {
              comp = 35;
            }
            if (resPer > comp && comp > 0) {
              comp = this.carPrice * comp / 100.0;
              comp = comp.setScale(2);
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Maximum balloon or residual value should be $' + 
                    comp.format()
                  )
                );
                r = false;
            }
          }
          Integer totalAge = (term / 12) + Date.Today().year() - 
          Integer.valueOf(vehicleYear);
            if (totalAge > 8 && this.residualValue != null && 
            this.residualValue > 0 && String.isNotBlank(clientTier)){
                ApexPages.addMessage(
                  new ApexPages.Message(
                    ApexPages.Severity.WARNING,
                    'Maximum vehicle age at end adding Term and Vehicle Age should be 8 years'
                  )
                );
                //r = false;
            }
        }
      }

        return r;
    }

    public void calculate() {
        baseRateCalc();
        calculateLPI();
        realtimeNafCalc();
        if (!isValidationOk()) {
            return;
        }        
        this.calculateRepayments();
        if (estimatedCommission <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The commission is below zero. Please make adjustment to make sure commission is above zero.'));
        }
    } // end of function
    
    public void reset() {
      this.resetQuote();
      
      this.loanType = loanTypeOptions.get(0).getValue();
      this.productLoanType = productLoanTypes.get(0).getValue();
      this.productGoodsType = productGoodsTypes.get(0).getValue();
      this.monthlyFee = lenderSettings.Monthly_Fee__c;
      this.ppsr = lenderSettings.PPSR__c;
      this.applicationFee = lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
      applicationFeeMax = applicationFee;
      this.netDepositCalc();
      this.calcDOF();      
      this.dof = 1000;
      this.term = 60;

      //this.loanTypeDetail = '';
      this.ltv = null;
      this.paymentType = 'Arrears';
      //this.clientTier = 'AAA';
      this.vehicleAge = 'New';
      this.creditScore = null;
      //this.enquiries = null;
      
      //Liberty Rate - HJ - 07-11-2018 - I
      //this.disabledRateType = true;
      //this.rateType = '';
      this.propertyOwner = '';
      //Liberty Rate - HJ - 07-11-2018 - F
      abnLength = '';
      gstLength = '';
      if (Opp.Application_AssetDetail__c != null) {
			  vehicleYear = String.valueOf(Opp.Application_AssetDetail__r.Year__c);
			} else if (Opp.Application__c != null) {
        vehicleYear = Opp.Application__r.Vehicle_Year__c;
      }

      this.resetInsuranceProducts(false);

      this.realtimeNafCalc();
      this.resetCalculationResult(); //Lelo       2017-07-25
      this.baseRateCalc();
    } // end of function
    
  private PageReference savePdf (String prefixName) {
    // pass parameters to the PDF page
    PageReference calcPdf = this.createPdf();
    // pass universal variables
    calcPdf.getParameters().put('lender', 'LIBERTY COMMERCIAL CALCULATION');        

    // Lender parameters
    //calcPdf.getParameters().put('loanTypeDetail', loanTypeDetail);
    calcPdf.getParameters().put('lvr', String.valueOf(ltv));
    calcPdf.getParameters().put('clientTier', this.clientTier);
    //calcPdf.getParameters().put('rateType', this.rateType);
    calcPdf.getParameters().put('vehicleAge', vehicleAge);
    calcPdf.getParameters().put('creditScore', this.creditScore);
    //calcPdf.getParameters().put('enquiries', this.enquiries);
    if (this.baseRate != null && this.baseRate > 0) {
        calcPdf.getParameters().put('maxRate', String.valueOf(this.baseRate+2));
    }
    calcPdf.getParameters().put('registrationFee', String.valueOf(this.eqfee));
    //calcPdf.getParameters().put('isLiberty', 'true');
    calcPdf.getParameters().put('productGoodsType', productGoodsType);
    calcPdf.getParameters().put('propertyOwner', 'Y'.equals(propertyOwner)?'Yes':'No');
    calcPdf.getParameters().put('abn', abnLength);
    calcPdf.getParameters().put('GST', gstLength);    

    savePdfInCloud(calcPdf, prefixName);
    return null;
  } // end of function
    
    private PageReference saveProduct (String prefixName) {
        System.debug('Saving product...');
        //Recalculate
        if (!isValidationOk()) {
            return null;
        }
        System.debug('Calculating...');
        calculate();
        System.debug('Validating calculated rental: ' + rental);
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
        System.debug('Storing quoting parameters...');
        saveQuotingParameters();

        System.debug('Loading asset details...');
        Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Id);
        if(!validateVehicleAgeWithYear(aad)){
            System.debug('Asset validation failed.');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Age does not match with the Vehicle Year in Asset Details / Application form page.'));
            return null;
        }
        System.debug('Saving pdf report...');
        //Lelo 									2016-07-26
		savePdf (prefixName);
        Product__c updateProduct = null;
        if (Opp.Loan_Product__c == null) {
          // first create a finance product
          updateProduct = new Product__c(
            RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Finance'),
            Opportunity_Name__c = this.Opp.Id
          );
        } else {
            // first update the finance product
            updateProduct = [Select id,Loan_Purpose__c,Quoting_Source__c,Lender__c,Repayment_Regularity__c,Loan_Type__c,Loan_Term__c,
                             Balloon_Residual_Requested__c,Client_Rate__c,Payments__c,Cost_of_Goods__c,Deposit__c,Brokerage__c,
                             Lender_App_Fee__c,Equalisation_Fee_PPSR__c,DOF__c, Loan_Type_Detail__c, Loan_Product__c 
                             from Product__c where id =: Opp.Loan_Product__c];
        }
        //-
            
        updateProduct.Loan_Purpose__c = 'Business Use';
        updateProduct.Lender__c = 'Liberty';
        updateProduct.Quoting_Source__c = LENDER_QUOTING;
        updateProduct.Repayment_Regularity__c = 'Monthly';

        updateProduct.Loan_Type__c = loanType;
        updateProduct.Loan_Product__c = productLoanType;
        updateProduct.Loan_Type_Detail__c = this.clientTier;
        updateProduct.Loan_Term__c = term > 0? term : 0;
        updateProduct.Balloon_Residual_Requested__c = this.residualValue > 0? this.residualValue : 0.00;
        updateProduct.Client_Rate__c = this.clientRate > 0? this.clientRate : 0.00;
        updateProduct.Payments__c = this.monthlyPayment > 0? this.monthlyPayment : 0.00;
        updateProduct.Cost_of_Goods__c = this.carPrice > 0? this.carPrice: 0.00;
        updateProduct.Deposit__c = this.netDeposit;
        updateProduct.DOF__c = dof > 0? dof : 0.00;
        updateProduct.Brokerage__c = this.estimatedCommission > 0? this.estimatedCommission : 0.00;
        if (this.applicationFee > 0) {
          /*
          updateProduct.Lender_App_Fee__c = ('Consumer Loan'.equals(productLoanType)) 
            ? this.lenderSettings.Application_Fee__c 
            : this.lenderSettings.Application_Fee_Private__c;
            */
          updateProduct.Lender_App_Fee__c = lenderSettings.Application_Fee__c;
        }
        updateProduct.Equalisation_Fee_PPSR__c = this.ppsr > 0? this.ppsr : 0.00;
        updateProduct.Equalisation_Fee_PPSR__c += (this.eqfee > 0)? this.eqfee : 0;

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
        //-

        // Save accepted insurances
        this.saveInsuranceProducts();
        
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
    
    private void loadQuotingParametersSaved() {
      System.debug('Loading Application_Quoting ... ' + LENDER_QUOTING);
      Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(
        this.Opp.Id, 
        this.Opp.Application__c
      );
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

          productGoodsType = d.Goods_type__c;
          //loanTypeDetail = d.Loan_Facility_Type__c;
          if (d.Client_Rate__c != null) {
              clientRate = d.Client_Rate__c.setScale(2);
          }                
          
          vehicleYear = d.Vehicles_Profile__c;
          //Loan Details
          paymentType = d.Payment__c;
          //Calculations
          if (!String.isBlank(d.LTV__c) && d.LTV__c.isNumeric()) {
              ltv = Integer.valueOf(d.LTV__c);
          }
          if (String.isNotBlank(d.Client_Tier__c)) {
              this.clientTier = d.Client_Tier__c;
          }
          //Liberty Rate - HJ - 07-11-2018 - I
          /*
          this.rateType = '';
          if (String.isNotBlank(d.Rate_Type__c)) {
              this.rateType = d.Rate_Type__c;
          }
          */
          /*
          this.disabledRateType = true;
          if (!'Consumer Loan'.equals(this.productLoanType)) {
              this.disabledRateType = false;
          }
          */
          this.propertyOwner = 'N';
          if (String.isNotBlank(d.Customer_Profile__c)) {
              this.propertyOwner = d.Customer_Profile__c;
          }
          //Liberty Rate - HJ - 07-11-2018 - F
          if (String.isNotBlank(d.Vehicle_Age__c)) {
              this.vehicleAge = d.Vehicle_Age__c;
          }
          
          this.creditScore = d.Credit_Score__c;
          
          /*
          this.enquiries = null;
          if (d.Enquiries__c != null) {
              this.enquiries = String.valueOf(d.Enquiries__c);
          }
          */
          abnLength = d.ABN__c;
          gstLength = d.GST__c;
        }
        this.realtimeNafCalc();
        this.baseRateCalc();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Previous calculation loaded successfully.'));
        
        //LibertyAPI -I - HJ
        libertyAPI_AppNumber = d.LibertyServ_AppNumber__c;
        libertyAPI_ResponseContent = d.LibertyServ_ResponseContent__c;
        libertyAPI_Status = d.LibertyServ_Status__c;
        libertyAPI_lastResponseApp = d.LibertyServ_Last_Response_Application__c ;
        //LibertyAPI -F - HJ
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
        d.Goods_type__c = productGoodsType;
        if (ltv != null) {
          d.LTV__c = String.valueOf(ltv);
        }
        d.Payment__c = paymentType;
        //d.Loan_Facility_Type__c = loanTypeDetail;
        d.Client_Tier__c = this.clientTier;
        //Liberty Rate - HJ - 07-11-2018 - I
        //d.Rate_Type__c = this.rateType;
        d.Customer_Profile__c = this.propertyOwner;
        //Liberty Rate - HJ - 07-11-2018 - F
        d.Vehicle_Age__c = this.vehicleAge;
        
        d.Credit_Score__c = creditScore;
        
        /*
        d.Enquiries__c = null;
        if (String.isNotBlank(this.enquiries) && this.enquiries.isNumeric()) {
          d.Enquiries__c = Integer.valueOf(this.enquiries);
        }
        */
        d.Risk_Fee__c = this.eqfee;
        d.Vehicles_Profile__c = vehicleYear;
        d.ABN__c = abnLength;
        d.GST__c = gstLength;
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
    public override Decimal getTotalAmount(String calcType) {
      netDepositCalc();
      Decimal r = 0.0;
      if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
          r += this.carPrice +
          (this.carPrice * QuotingCalculation.getProtectedPercentaje(this.carPrice));
      } else {
          r += (this.carPrice != null)? this.carPrice : 0;
      }
      r += (this.applicationFee != null)? this.applicationFee : 0;
      // NO DOF added
      r += (this.ppsr != null)? this.ppsr : 0;
      //if (registrationFee != null) r += registrationFee;
      r -= this.netDeposit;
      return r;
    }


    private void calculateRepayments() {
         
      //Reset results
      this.resetCalculationResult();
      //FULL CALCULATION
      QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam(LENDER_QUOTING);
      String quotingType = QuotingCalculation.CALC_QUOTING;
      param.totalAmount = getTotalAmount(quotingType) + this.calculateEQFee(quotingType);
      param.totalInsurance = getTotalInsuranceType(quotingType);
      param.totalInsuranceIncome = getTotalInsuranceIncomeType(quotingType);
      param.clientRate = clientRate;
      param.baseRate = baseRate;
      param.paymentType = paymentType;
      param.term = term;
      param.dof = dof;
      param.monthlyFee = monthlyFee;
      param.residualValue = residualValue;
      param.clientTier = this.clientTier;
      param.productLoanType = this.productLoanType;
      param.vehicleYear = vehicleAge;

      System.debug(quotingType + '|' + param.totalAmount + '|' + param.totalInsurance + '|' + param.totalInsuranceIncome);

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
      param.totalAmount = getTotalAmount(quotingType) + this.calculateEQFee(quotingType, false);
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
      if (cci != null && cci > 0) {
        calcTypes.add(InsuranceQuoteUtils.INS_PROD_CCI);
      }
      //-
      
      for (String key: calcTypes) {
          param.totalAmount = getTotalAmount(quotingType) + this.calculateEQFee(quotingType);
          param.totalInsurance = this.getTotalInsuranceType(key);
          param.totalInsuranceIncome = this.getTotalInsuranceIncomeType(key);
          r = QuotingCalculation.calculate(param);
          if (r != null) {
              r.Result_Type__c = key;   
          }
          //System.debug(key + ' >> ' + r);
          calResults.put(key, r);                
      }

    }
    
    //Liberty API - I - HJ
    public PageReference libertyApplicationTest(){
        System.debug('>>>>> Response APPLICATION LIBERTY (Test) -I  <<<<<< - ');
        LibertyServiceManager lbService = new LibertyServiceManager();
        try{
        	lbService.requestApplicationTest(opp, true, apiUser);
        }catch(GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
        System.debug('>>>>> Response APPLICATION LIBERTY (Test) -F  <<<<<< - ');
        return null;
    }
    
    
    public PageReference libertyApplication(){
        System.debug('>>>>> Response APPLICATION LIBERTY  -I  <<<<<< - ');
        LibertyServiceManager lbService = new LibertyServiceManager();
        try{
            LibertyApplicationResponse libertyResponse = lbService.requestApplication(opp, true, apiUser);
            if (libertyResponse != null){
                libertyAPI_Status = libertyResponse.apiResponse.status.value;
                libertyAPI_AppNumber = libertyResponse.apiResponse.applicationNumber.value;
                libertyAPI_ResponseContent = libertyResponse.apiResponse.responseContent.value;
                libertyAPI_lastResponseApp  = libertyResponse.apiResponse.lastResponseApp;
                saveAPIInformation();
            }
            System.debug('>>>>> Response APPLICATION LIBERTY  -F  <<<<<< - ');
            return null;
        }catch(GenericException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return null;
        }
    }
    
    private void saveAPIInformation(){
        this.quoting.LibertyServ_AppNumber__c = libertyAPI_AppNumber;
        this.quoting.LibertyServ_ResponseContent__c = libertyAPI_ResponseContent;
        this.quoting.LibertyServ_Status__c = libertyAPI_Status;
        this.quoting.LibertyServ_Last_Response_Application__c = libertyAPI_lastResponseApp;
        update this.quoting;
    }
    //Liberty API - F - HJ
    
    public void calcDOF() {
        if (this.applicationFee != null) {
          /*
          Decimal lenderAppFee = ('Consumer Loan'.equals(productLoanType)) 
            ? this.lenderSettings.Application_Fee__c 
            : this.lenderSettings.Application_Fee_Private__c;
            */
            //this.dof = this.applicationFee - lenderAppFee;
            this.dof = this.applicationFee - lenderSettings.Application_Fee__c;
            if (this.dof < 0) this.dof = 0.00;
        } else {
            this.dof = 0.00;
        }
    }
/*
    private String checkVehicleAge(String v) {
        String r = v;
        if (String.isNotBlank(v) && v.isNumeric() && 'Consumer Loan'.equals(this.productLoanType)) {
            Integer a = Integer.valueOf(v);
            if (a <= 4) {
                r = '0-4 years';
            } else if (a <= 9) {
                r = '5-9 years';
            } else {
                r = '10+ years';
            }
            if (this.opp.Application_AssetDetail__c != null && 
                ('new'.equals(this.opp.Application_AssetDetail__r.Condition__c) ||
                 'demo'.equals(this.opp.Application_AssetDetail__r.Condition__c))) {
                r = 'New';
            }
        }
        return r;
    }
    */
    public void checkRateTypeAndClientTier(){
        /*
        if ('Consumer Loan'.equals(this.productLoanType)) {
            this.rateType = '';
            this.applicationFee = lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
        } else {
            if (String.isBlank(this.rateType)) {
                this.rateType = 'Star';
            }
            // resetGapDetails();
            this.applicationFee = lenderSettings.Application_Fee_Private__c + lenderSettings.DOF__c;
        }
        */
        this.applicationFee = lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
        checkClientTier();
        this.vehicleAge = null;
        this.loadVehicleAges();
    }
    
    // public void resetGapDetails(){
    //     if (!'Consumer Loan'.equals(this.productLoanType)) {
    //         this.veiLevel = '';
    //         this.vei = null;
    //         this.veiIncome = null;
    //         this.veiAcceptance = 'U'; 
    //     }
    // }
        
    public void checkClientTier(){
        //Liberty Rate - HJ - 07-11-2018 - I
        /*
        this.disabledRateType = true;
        //Liberty Rate - HJ - 07-11-2018 - F
        if (!'Consumer Loan'.equals(this.productLoanType)) {
            if (String.isNotBlank(this.clientTier)) {
                this.clientTier = this.clientTier.remove('-');
            }
            if ('Nova'.equals(this.rateType)) {
                if (String.isNotBlank(this.clientTier) && !this.clientTier.contains('AA')) {
                    this.clientTier = 'AAA';
                }
            }
            //Liberty Rate - HJ - 07-11-2018 - I
            this.disabledRateType = false;
            //Liberty Rate - HJ - 07-11-2018 - F
        }
        */
        //this.adjustMonthlyFee();
        this.baseRateCalc();
    }
/*
    public void adjustMonthlyFee(){
        this.monthlyFee = this.lenderSettings.Monthly_Fee__c;
        if (!'AAA'.equals(this.clientTier)) {
            if (this.realtimeNaf < 10000.0) {
                this.monthlyFee = 15.0;
            } else {
                this.monthlyFee = 10.0;
            }
        }
    }
*/
    private Decimal getTotalAmountExcFees(String calcType) {
        netDepositCalc();
        Decimal r = 0.0;

        if (QuotingCalculation.CALC_PROTECTED.equals(calcType)) {
            if (carPrice != null) r += carPrice + (carPrice * QuotingCalculation.getProtectedPercentaje(carPrice));
        } else {
            if (carPrice != null) r += carPrice;
        }
        if (netDeposit != null) r -= netDeposit;
        return r;
    }

    public Decimal calculateEQFee(String calcType)  {
        return this.calculateEQFee(calcType, false);
    }

    public Decimal calculateEQFee(String calcType, Boolean excInsurances)  {
        Decimal r = 0.0;
        Decimal baseEqFee = this.getTotalAmountExcFees(QuotingCalculation.CALC_QUOTING);
        if (!excInsurances) {
            if ('A'.equals(warrantyAcceptance)) {
                if (warranty != null) baseEqFee += warranty;
            } else if ('A'.equals(nwcAcceptance)) {
                if (nwc != null) baseEqFee += nwc;    
            }
        }
        if ('A'.equals(this.clientTier)) {
            r = baseEqFee * 0.01;
        } else if ('B'.equals(this.clientTier)) {
            r = baseEqFee * 0.03;
        } else if ('C'.equals(this.clientTier)) {
            r = baseEqFee * 0.08;
        }
        return r;
    }

    private boolean validateVehicleAgeWithYear(Application_Asset_Detail__c aad){
        
        //System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Year__c ' + aad.Year__c);
        //System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Condition__c ' + aad.Condition__c);
        if (aad == null){
            return false;
        }
        Integer differenceYear = getVehicleAgeToYear(aad);
        if(differenceYear == null){
            return false;
        }
        differenceYear = Date.Today().year() - differenceYear;
        System.debug(':::::::: DifferenceYear: ' + differenceYear );
        if ('used'.equalsIgnoreCase(aad.Condition__c)) {
            //if ('Consumer Loan'.equals(productLoanType)) {
                if('0-4 years'.equals(vehicleAge) && differenceYear >= 0 && differenceYear<= 4){
                    return true;
                }else if('5-9 years'.equals(vehicleAge) && differenceYear >= 5 && differenceYear<= 9){
                    return true;
                }else if('10+ years'.equals(vehicleAge) && differenceYear >= 10){
                    return true;
                }
                /*
            } else {
                if (vehicleAge.isNumeric()) {
                    Integer va = Integer.valueOf(vehicleAge);
                    if (va == differenceYear) {
                        return true;
                    }
                }
            }
            */
        } else if('new'.equalsIgnoreCase(aad.Condition__c)){
            if('New'.equals(vehicleAge) && differenceYear >= 0 && differenceYear<= 2){
                return true;
            }
        } else if('demo'.equalsIgnoreCase(aad.Condition__c)){
            if(('New'.equals(vehicleAge) || '0-4 years'.equals(vehicleAge)) && differenceYear >= 0 && differenceYear<= 4){
                return true;
            }
        }
    
        return false;
    }

    private Integer getVehicleAgeToYear(Application_Asset_Detail__c aad){
        Integer differenceYear = null;
        //Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(this.Opp.Application_AssetDetail__c);
        Application__c app  = this.Opp.Application__r;
        String year;
        if(aad != null && aad.Year__c != null){
            year = String.valueOf(aad.Year__c);
        }else if(app != null && !StringUtils.isNullOrEmpty(app.Vehicle_Year__c)){
            year = app.Vehicle_Year__c;
        }

        if (year != null){
            differenceYear = Integer.valueOf(year);
        }
        System.debug('::::::: Year: ' + year);
        return differenceYear;
    }

    // Lelo             2019-01-09
    public Map<String, Map<String, Map<String, LibertyRates__c>>> getRates() {
        Map<String, Map<String, Map<String, LibertyRates__c>>> r = new Map<String, Map<String, Map<String, LibertyRates__c>>>();
        List<LibertyRates__c> d = [
          SELECT Name, Tier__c, Type__c, Vehicle_Age__c, Rate__c, VOrder__c 
          FROM LibertyRates__c WHERE Type__c = 'Commercial' ORDER BY Type__c DESC, VOrder__c, Name
        ];
        
        //LibertyRates__c.getAll().values();
        //d.sort();
        for (LibertyRates__c a:d) {
            Map<String, Map<String, LibertyRates__c>> x = r.get(a.Type__c);
            if (x == null) {
                x = new Map<String, Map<String, LibertyRates__c>>();
                r.put(a.Type__c, x);
            }
            String k = a.VOrder__c;
            //String k = a.Vehicle_Age__c;
            // if (('Commercial'.equals(a.Type__c) && a.Vehicle_Age__c.startsWith('S')) ||
            //     ('Consumer'.equals(a.Type__c) && a.Vehicle_Age__c.startsWith('N'))) {
            //     k = ' ' + k;
            // }
            Map<String, LibertyRates__c> y = x.get(k);
            if (y == null) {
                y = new Map<String, LibertyRates__c>();
                x.put(k, y);
            }
            y.put(a.Name, a);
        }
        return r;
    }

    public void loadVehicleAges() {
        this.vehicleAges = new List <SelectOption> ();
        this.vehicleAges.add(new SelectOption ('', '--None--'));
        this.vehicleAges.add(new SelectOption ('New', 'New'));
        //if ('Consumer Loan'.equals(this.productLoanType)) {
            this.vehicleAges.add(new SelectOption ('0-4 years', '0-4 years'));
            this.vehicleAges.add(new SelectOption ('5-9 years', '5-9 years'));
            this.vehicleAges.add(new SelectOption ('10+ years', '10+ years'));
            /*
        } else {
            for (Integer i = 1; i <= 20; i++) {
                this.vehicleAges.add(new SelectOption (String.valueOf(i), String.valueOf(i)));
            }
        }
        */
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
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

  public String getRiskGrade() {
    String riskGrade;
    Integer abn, gst, cS;

    if('>36 mths'.equals(abnLength)){
      abn = 36;
    } else if ('>24 mths'.equals(abnLength)) {
      abn = 24;
    } else if ('>12 mths'.equals(abnLength)) {
      abn = 12;
    }

    if('>36 mths'.equals(gstLength)){
      gst = 36;
    } else if ('>24 mths'.equals(gstLength)) {
      gst = 24;
    } else if('>12 mths'.equals(gstLength)){
      gst = 12;
    } else if('No GST'.equals(gstLength)){
      gst = 0;
    }

    if('750+'.equals(creditScore)){
      cS = 750;
    } else if ('600+'.equals(creditScore)) {
      cS = 600;
    } else if('500+'.equals(creditScore)){
      cS = 500;
    } else if ('400+'.equals(creditScore)) {
      cS = 400;
    }

    if (gst != null) {
      if ('Y'.equals(propertyOwner)) {
        if(abn == 36 && gst == 36 && cS == 750){
          riskGrade = 'AAA';
        } else if (abn >= 12 && gst >= 12 && cS >= 600) {
          riskGrade = 'AA';
        } else if(abn >= 12 && cS >= 500){
          riskGrade = 'A';
        } else if (abn >= 24 && cS >= 400) {
          riskGrade = 'B';
        } else if (abn >= 12 && cS >= 400) {
          riskGrade = 'C';
        }
      } else {
        if(abn >= 24 && gst >= 24 && cS >= 600){
          riskGrade = 'A';
        } else if (abn >= 24 && cS >= 500) {
          riskGrade = 'B';
        } else if(abn >= 12 && cS >= 400){
          riskGrade = 'C';
        }
      }
    }
    return riskGrade;
  }

  public List<SelectOption> getVehicleYearOptions() {
    return QuotingToolHelper.getVehicleYears(20, false);
  }
}