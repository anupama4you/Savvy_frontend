public with sharing class InsuranceQuoteStep2Extension {

	private final Custom_Opportunity__c o;
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}
    public List<AddtionalDriver> additionalDrivers {set;get;}
    public Integer driverSelected {set;get;}
    private List<Application_Additional_Driver__c> driverRemovedList = new List<Application_Additional_Driver__c>();
    public Application_Additional_Driver__c mainDriver {set;get;}
    public Map<String, Id> recordTypes;
    public Boolean displayRedbookLookup {set;get;}
    public String redbookFamilyCode {set;get;}
    public String redbookBadge {set;get;}
    private List<Redbook_Family__c> redBookFamilyList = null;
    private List<String> redBookBadgedList = null;
    public List<Redbook_Vehicle__c> redBookVehicleList {set;get;}
    public Glass_Variant__c glassVariant {set;get;}
    
    public InsuranceQuoteStep2Extension(ApexPages.StandardController ctrl) {
        this.o = (Custom_Opportunity__c)ctrl.getRecord();
        loadData();
    }

    public void loadData() {
        this.quoting = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
        this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuotePrepared(this.o.Application__c);
        this.loadVehicleVariant();
        this.additionalDrivers = new List<AddtionalDriver>();
        this.mainDriver = null;
        this.recordTypes = InsuranceQuoteUtils.getRecordTypes();
        this.displayRedbookLookup = false;
        if (this.quote != null) {
            //Load Additonal drivers
            //if (this.quote.Has_Additional_Driver__c) {
                List<Application_Additional_Driver__c> lst = InsuranceQuoteUtils.getQuoteAddtionalDrivers(this.quote.Id);
                System.debug('Quote Drivers >> ' + lst.size());
                for (Application_Additional_Driver__c a: lst) {
                    if (a.RecordTypeId == recordTypes.get(InsuranceQuoteUtils.MAIN_DRIVER_TYPE)) {
                        this.mainDriver = a;
                    } else {
                        AddtionalDriver obj = new AddtionalDriver(additionalDrivers.size()+1, a);
                        additionalDrivers.add(obj);    
                    }
                }
            //} 
            if (String.isBlank(this.quote.Vehicle_Usage__c)) {
                this.quote.Vehicle_Usage__c = this.getVehicleUsage();
            }
            if (String.isNotBlank(this.quote.Warranty_Insurance__c)) {
                this.quote.Warranty_Insurance_Contract__c = this.quote.Warranty_Insurance__c.right(2);
                //if (this.quote.Warranty_Insurance__c.contains('36')) {
                //    this.quote.Warranty_Insurance_Contract__c = '36';
                //} else if (this.quote.Warranty_Insurance__c.contains('60')) {
                //    this.quote.Warranty_Insurance_Contract__c = '60';
                //}
            }
            if (String.isNotBlank(this.quote.Motor_Vehicle__c)) {
                this.quote.Motor_Cover_Term__c = '12';
            }
            if (String.isNotBlank(this.quote.Total_assist_RTI__c)) {
                this.quote.Assist_Cover_Term__c = '36';
            }
            //Checking main driver
            if (this.mainDriver == null) {
                this.mainDriver = new Application_Additional_Driver__c(RecordTypeId = recordTypes.get(InsuranceQuoteUtils.MAIN_DRIVER_TYPE));
                this.mainDriver.Application__c = this.o.Application__c;
            }

            this.mainDriver.Date_of_Birth__c = InsuranceQuoteUtils.convertToDate(this.o.Application__r.Date_of_Birth_1__c);
            this.mainDriver.Gender__c = InsuranceQuoteUtils.getGender(this.o.Application__r.Gender_1__c);
            this.mainDriver.Input_Tax_Credit__c = 0.0;
            this.mainDriver.Title__c = this.o.Application__r.Title_1__c;
            this.mainDriver.First_Name__c = this.o.Application__r.First_Name__c;
            this.mainDriver.Last_Name__c = this.o.Application__r.Last_Name__c;
            this.mainDriver.State__c = this.o.Application__r.State__c;

            this.mainDriver.Email__c = this.o.Application__r.Email_Address__c;
            this.mainDriver.Driver_Licence__c = this.o.Application__r.Drivers_License_1__c;
            if (String.isBlank(this.o.Application__r.Mobile_Number__c)) {
                this.mainDriver.Hasnt_Mobile_Number__c = true;
            }
            this.mainDriver.Mobile__c = this.o.Application__r.Mobile_Number__c;
            this.mainDriver.Home_Phone__c = this.o.Application__r.Home_Phone__c;
            this.mainDriver.Work_Phone__c = this.o.Application__r.Work_Phone__c;

            // Address
            this.mainDriver.Address_Line_1__c = '';
            if (!String.isBlank(this.o.Application__r.Unit_Number__c)) {
                this.mainDriver.Address_Line_1__c = this.o.Application__r.Unit_Number__c + ' / ';
            }
            this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + this.o.Application__r.Street_Number__c;
            this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Street_Address__c;
            if (!String.isBlank(this.o.Application__r.Street_Type__c)) {
                this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Street_Type__c;
            }

            if (!String.isBlank(this.o.Application__r.Business_ABN__c)) {
                this.mainDriver.ABN__c = this.o.Application__r.Business_ABN__c;
                this.mainDriver.Registered_for_GST__c = true;
            } else {
                this.mainDriver.ABN__c = null;
                this.mainDriver.Registered_for_GST__c = false;
            }
            if (this.o.Application__r.Year_First_Licensed_1__c != null) {
                this.mainDriver.Year_First_Licence__c = this.o.Application__r.Year_First_Licensed_1__c;
            }
            if (this.o.Application__r.Time_Last_Fault_1__c != null) {
                this.mainDriver.Time_Last_Fault_Accident__c = this.o.Application__r.Time_Last_Fault_1__c;
            }
            // Date first registrated
            if (this.o.Application_AssetDetail__r.Date_First_Registered__c == null && this.o.Application_AssetDetail__r.Year__c != null) {
                this.o.Application_AssetDetail__r.Date_First_Registered__c = DateUtils.convertToDate(Integer.valueOf(this.o.Application_AssetDetail__r.Year__c), 6, 1);
            }

            if (String.isNotBlank(this.quote.Motor_Vehicle__c) || String.isNotBlank(this.quote.Warranty_Insurance__c)) {
                this.loadRedBookFamilies();
            }
        }
    }

    public void nextAction() {
        System.debug('Saving quote...');
        //Assign values
        this.quote.Vehicle_Condition__c = InsuranceQuoteUtils.getVehicleCondition(this.o.Application_AssetDetail__r.Condition__c);
        this.quote.Odometer__c = this.o.Application_AssetDetail__r.Actual_KM__c;
        this.quote.Vehicle_Date_First_Registered__c = this.o.Application_AssetDetail__r.Date_First_Registered__c;
        this.quote.Vehicle_Type__c = InsuranceQuoteUtils.getVehicleType(this.o.Application_AssetDetail__r.Type__c);
        if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
            this.quote.Vehicle_Make__c = this.getVehicleMake().Name;
            if (this.glassVariant != null) {
                this.quote.Vehicle_Model__c = this.glassVariant.Family__c;
            }
        } else {
            this.quote.Vehicle_Make__c = this.o.Application_AssetDetail__r.Make__c;
            this.quote.Vehicle_Model__c  = this.o.Application_AssetDetail__r.Model__c;
        }

        if (String.isNotBlank(this.o.Application_AssetDetail__r.Redbook_Key__c)) {
            this.quote.Redbook_Key__c = this.o.Application_AssetDetail__r.Redbook_Key__c;    
        } else {
            if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
                if (this.glassVariant != null) {
                    this.quote.Redbook_Key__c = this.glassVariant.NVIC__c;
                }
            }
        }
        if (this.o.Application__r.Postcode__c != null && this.o.Application__r.Postcode__c.isNumeric()) {
            this.quote.Vehicle_Location_Postcode__c = Integer.valueOf(this.o.Application__r.Postcode__c);
        }
        this.quote.Vehicle_Location_Suburb__c = this.o.Application__r.Suburb__c;
        this.quote.Vehicle_Location_State__c = this.o.Application__r.State__c;
        this.quote.Vehicle_Usage__c = this.getVehicleUsage();
        this.quote.Amount_Financed__c = this.quoting.NAF__c;
        //Jesus Mora 2020-06-04 start
        System.debug(quote.Amount_Financed__c);
        
        if ('A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_AIC_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_GAP_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_GAP_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_TAI_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_TAI_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_Warranty_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_Warranty_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_NWC_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_NWC_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_LTI_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_LTI_Retail_Price__c;
        }
        if ('A'.equals(this.quoting.Insurance_VEI_Acceptance__c)) {
            this.quote.Amount_Financed__c = this.quote.Amount_Financed__c - this.quoting.Insurance_VEI_Retail_Price__c;
        }
        
        System.debug(quote.Amount_Financed__c);
        //Jesus Mora 2020-06-04 end
        this.quote.Finance_Term__c = this.quoting.Term__c;
        this.quote.Financier_Id__c = InsuranceQuoteUtils.getFinancierId(this.quoting.Name);
        this.quote.Financier_Name__c = this.quoting.Name;
        Double vp = 0.0;
        Double netDeposit = 0.0;
        if (this.quoting.Vehicle_Price__c != null) {
            vp = this.quoting.Vehicle_Price__c;
        }
        // if (this.quoting.Net_Deposit__c != null) {
        //     netDeposit = this.quoting.Net_Deposit__c;
        // }
        // this.quote.Vehicle_Purchase_Price__c = vp - netDeposit;
        this.quote.Vehicle_Purchase_Price__c = vp;

        //Status
        this.quote.Status__c = 'S2';
        //Save Quote
        update this.quote;
        //Save Application
        System.debug('Saving application...');
        update this.o.Application__r;
        //Save Asset Details
        System.debug('Saving Asset Details...');
        update this.o.Application_AssetDetail__r;
        //Additional drivers
        System.debug('Managing Additional Drivers... add >> ' + additionalDrivers.size() + ' | rem >> ' + driverRemovedList.size());
        //Remove
        Set<Id> idsList = new Set<Id>();
        for (Application_Additional_Driver__c a : driverRemovedList) {
            if (a.Id != null) {
                idsList.add(a.Id);
            }
        }
        if (!idsList.isEmpty()) {
            System.debug('Deleting current Additional Drivers... ' + idsList.size());
            delete [
                SELECT Id FROM Quote_Additional_Driver__c 
                WHERE Application_Insurance_Quote__c = :this.quote.Id 
                AND Application_Additional_Driver__c IN :idsList
            ];
            delete [
                SELECT Id FROM Application_Additional_Driver__c 
                WHERE Id IN :idsList
            ];
        }
        
        //Creating additional drivers
        //if(!additionalDrivers.isEmpty()) {
            System.debug('Creating/Updating Additional drivers... ' + additionalDrivers.size());
            List<Application_Additional_Driver__c> d = new List<Application_Additional_Driver__c>();
            for (AddtionalDriver a: additionalDrivers) {
                if (a.data.Application__c == null) {
                    a.data.Application__c = this.o.Application__c;
                }
                d.add(a.data);
            }
            //Main driver
            System.debug('Gender >> ' + this.mainDriver.Gender__c);
            d.add(this.mainDriver);
            upsert d;
            System.debug('Removing association in Quote Additional Drivers... ');
            delete [
                SELECT Id FROM Quote_Additional_Driver__c 
                WHERE Application_Insurance_Quote__c = :this.quote.Id
            ];
            System.debug('Associating Quote Additional Drivers... ' + + d.size());
            List<Quote_Additional_Driver__c> qad = new List<Quote_Additional_Driver__c>();
            for (Application_Additional_Driver__c a: d) {
                Quote_Additional_Driver__c q = new Quote_Additional_Driver__c();
                q.Application_Insurance_Quote__c = this.quote.Id;
                q.Application_Additional_Driver__c = a.Id;
                qad.add(q);
            }
            insert qad;
        //}
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Data saved.'));
    }

    public PageReference invokeWS() {
        if (isValidForSubmission()) {
            try {
                System.debug('Invoking WS...');
                InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote;
                param.quoting = this.quoting;
                if (!Test.isRunningTest()) {
                    InsuranceQuoteWS.getQuote(param);
                }
                PageReference n = Page.InsuranceQuoteStep3;
                n.getParameters().put('id', this.o.Id);
                n.getParameters().put('C', 'N');
                return n;
            } catch (Exception e) {
                if(e.getMessage().contains('Unable to locate a vehicle')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }
        }
        return null;
    }

    private Boolean isValidForSubmission() {
        Boolean r = true;
        insuranceProductsMessage();
        if (insuranceProducts()) {
          r = false;
        }
        if (!String.isBlank(this.quote.Motor_Vehicle__c)) {
            //Main Driver
            if (this.mainDriver.Date_of_Birth__c == null) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Motor Vehicle: Main Driver Date of Birth field is required.'));
                r = false;
            }
            if (this.mainDriver.Gender__c == null) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Motor Vehicle: Main Driver Gender field is required.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Title__c)) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Motor Vehicle: Main Driver Title field is required.'));
                r = false;
            }
            if (this.mainDriver.Year_First_Licence__c == null) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Motor Vehicle: Main Driver Year First Licence field is required.'));
                r = false;
            }
        }
        //LTI
        System.debug(this.quote.LTI_BRI__c + '|' + this.getIsApplicantEmployed() + '|' + this.getIsApplicantFullTimeOrPartTime() + '|' + this.getIsEmployed6Months());
        if (!String.isBlank(this.quote.LTI_BRI__c) && InsuranceQuoteUtils.validateLendersNotLPIorLTI(this.quoting.Name)) {
            if (!this.getIsApplicantEmployed() || !this.getIsApplicantFullTimeOrPartTime() || !this.getIsEmployed6Months()) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'LTI/BRI: Unfortunately we are unable to cover you based on your eligibility.'));
                r = false;
            }
        }
        if (String.isNotBlank(this.quote.LPI__c)) {
            if(!getIsEmployed6Months()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'For CCI cover type: CRDU one or more incorrect answers have been provided.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Applicant is not continuously employed'));   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please remove LPI'));
                r = false;
            }
        }
        //Warranrty
        if (!String.isBlank(this.quote.Warranty_Insurance__c)) {
            if (this.quote.Is_Vehicle_Commercial_Usage__c) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Warranty: Unfortunately this vehicle is excluded from our acceptable vehicles and we are unable to complete this warranty sale.'));
                r = false;
            }
            if (this.o.Application_AssetDetail__r.Actual_KM__c == null) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Warranty: Please enter a value for odometer reading.'));
                r = false;   
            }
        }
        //Validate additional drivers
        if (this.quote.Has_Additional_Driver__c) {
            if (this.additionalDrivers ==  null || this.additionalDrivers.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(
                                ApexPages.Severity.ERROR, 
                                'Additional Driver: Please enter at least one additional driver.'));
                r = false;   
            } else {
                Integer i = 1;
                for (AddtionalDriver a: this.additionalDrivers) {
                    if (String.isBlank(a.data.First_Name__c)) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': First Name field is required.'));
                        r = false;
                    }
                    if (String.isBlank(a.data.Last_Name__c)) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Last Name field is required.'));
                        r = false;
                    }if (String.isBlank(a.data.Title__c)) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Title field is required.'));
                        r = false;
                    }
                    if (a.data.Date_of_Birth__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Date of Birth field is required.'));
                        r = false;
                    }
                    if (a.data.Gender__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Gender field is required.'));
                        r = false;
                    }
                    if (a.data.Year_First_Licence__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Year First Licence field is required.'));
                        r = false;
                    }
                    if (a.data.Driver_Licence__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(
                                        ApexPages.Severity.ERROR, 
                                        'Additional Driver #' + i + ': Driver Licence field is required.'));
                        r = false;
                    }
                    i++;
                }
            }
        }
        return r;
    }

    public PageReference previousAction() {
        PageReference n = Page.InsuranceQuoteStep1;
        n.getParameters().put('id', this.o.Id);
        return n;
    }

    public Glass_Make__c getVehicleMake() {
        Glass_Make__c r = null;
        if (this.o.Application_AssetDetail__c != null) {
            r = GlassServicesHelper.getMakeByCode(this.o.Application_AssetDetail__r.Make__c);
        }
        return r;
    }

    public String getVehicleUsage() {
        return InsuranceQuoteUtils.getUsage(this.o.Application__r.Application_Type__c);
    }

    public Boolean getIsApplicantEmployed() {
        return InsuranceQuoteUtils.isCurrentlyEmployed(this.o.Application__r.Mode_of_Employment_1__c);
    }
    //Jesus Mora 2020-03-19 start
    public Boolean getIsSelfEmployed() {
        return InsuranceQuoteUtils.isSelfEmployed(this.o.Application__r.Mode_of_Employment_1__c);
    }
    //Jesus Mora 2020-03-19 end
    public Boolean getIsApplicantFullTimeOrPartTime() {
        return InsuranceQuoteUtils.isFullTimeOrPartTime(this.o.Application__r.Mode_of_Employment_1__c, this.o.Application__r.Date_Started_1__c);
    }

    public Boolean getIsEmployed6Months() {
        Boolean r = false;
        if (getIsApplicantEmployed()) {
          if (getIsApplicantFullTimeOrPartTime()) {
            r = true;
          } else {
            r = InsuranceQuoteUtils.isEmployed6Months(this.o.Application__r.Date_Started_1__c);
            if (!r) {
                //Full check employment
                if (String.isNotBlank(this.o.Application__r.Start_Date_1__c) && String.isNotBlank(this.o.Application__r.Finish_Date_1__c)) {
                    Date a = FieldValidationsHelper.convertDate(this.o.Application__r.Start_Date_1__c);
                    Date b = FieldValidationsHelper.convertDate(this.o.Application__r.Finish_Date_1__c);
                    Date c = FieldValidationsHelper.convertDate(this.o.Application__r.Date_Started_1__c);

                    Decimal x = FieldValidationsHelper.getMonthsBetween(c, b);
                    //System.debug('1) Dates >> ' + this.o.Application__r.Date_Started_1__c + '|' + this.o.Application__r.Finish_Date_1__c + '| Months >> ' + x);
                    if(x != null){
                        if (x.setScale(1) <= 1.1) {
                            x = FieldValidationsHelper.getMonthsBetween(c, Date.today());
                            //System.debug('2) Dates >> ' + this.o.Application__r.Date_Started_1__c + '|' + Date.today() + '| Months >> ' + x);
                            x += FieldValidationsHelper.getMonthsBetween(a, b);
                            //System.debug('3) Dates >> ' + this.o.Application__r.Start_Date_1__c + '|' + this.o.Application__r.Finish_Date_1__c + '| Months >> ' + x);
                            if (x >= 6) {
                                r = true;
                            }
                        }
                    }
                    
                }
                //TODO - Include the oter previous employments
            }
          }
        }
        return r;
    }

    public void activateAddDriver() {
        if (this.quote.Has_Additional_Driver__c) {
            if (this.additionalDrivers.isEmpty()) {
                addDriver();
            }
        }
    }

    public void addDriver() {
        if (this.quote.Has_Additional_Driver__c) {
            AddtionalDriver a = new AddtionalDriver(
                    additionalDrivers.size()+1, recordTypes.get(InsuranceQuoteUtils.ADDITIONAL_DRIVER_TYPE));
            this.additionalDrivers.add(a);
        }
    }

    public void removeDriver() {
        if (this.driverSelected != null) {
            System.debug('Driver >> ' + this.driverSelected);
            AddtionalDriver a = this.additionalDrivers.get(this.driverSelected-1);
            if (a != null) {
                this.driverRemovedList.add(a.data);
                this.additionalDrivers.remove(this.driverSelected-1);
                resetExtraDriverIndexes();
            }
        } else {
            System.debug('not driver selected');
        }
    }

    private void resetExtraDriverIndexes() {
        Integer idx = 1;
        for (AddtionalDriver a : this.additionalDrivers) {
            a.idx = idx;
            idx++;
        }
    }

    public PageReference goToQuotingTool() {
        if(insuranceProducts()){
            
            Application_InsuranceQuote__c quote = InsuranceQuoteUtils.createDefaultInsuranceQuote(o, quoting);
            this.quote.Name = quote.Name;
            this.quote.Quotation_Number__c = quote.Quotation_Number__c;
            this.quote.Quotation_Date__c = quote.Quotation_Date__c;
            this.quote.Financier_Name__c = quote.Financier_Name__c;
            this.quote.Quotation_Creator__c = quote.Quotation_Creator__c;
            this.quote.MV_Acceptance__c = quote.MV_Acceptance__c;
            this.quote.GAP_Acceptance__c = quote.GAP_Acceptance__c;
            this.quote.TAS_Acceptance__c = quote.TAS_Acceptance__c;
            this.quote.LTI_Acceptance__c = quote.LTI_Acceptance__c;
            this.quote.LPI_Acceptance__c = quote.LPI_Acceptance__c;
            this.quote.WRR_Acceptance__c = quote.WRR_Acceptance__c;
            this.quote.Status__c = quote.Status__c;
            
            update this.quote;
            
            InsuranceQuoteUtils.importQuoteInQuotingTool(this.quote.Id, this.o.Id, '', quoting);
        }
        return InsuranceQuoteUtils.goToQuotingTool(this.o.Id,this.quoting.Name);
    }

    public class AddtionalDriver {
        public Integer idx {set;get;}
        public Boolean isRemoved {set;get;}
        public Application_Additional_Driver__c data {set;get;}

        public AddtionalDriver(Id driverTypeId) {
            this.idx = 0;
            this.data = new Application_Additional_Driver__c(
                            RecordTypeId = driverTypeId);
        }

        public AddtionalDriver(Integer idx, Id driverTypeId) {
            this(driverTypeId);
            this.idx = idx;
            //this.data = new Application_Additional_Driver__c();
        }

        public AddtionalDriver(Integer idx, Application_Additional_Driver__c obj) {
            this.idx = idx;
            this.data = obj;
        }
    }

    //RedBook 
    private void loadRedBookFamilies() {
        this.redBookFamilyList = new List<Redbook_Family__c>();
        this.redBookBadgedList = new List<String>();
        if (this.o.Application_AssetDetail__c != null) {
            Redbook_Make__c rbm = RedbookUtils.getMake(this.o.Application_AssetDetail__r.Make__c);
            if (rbm != null) {
                this.redBookFamilyList = RedbookUtils.getMakeFamilies(rbm.Code__c, this.o.Application_AssetDetail__r.Year__c);
                if (this.glassVariant != null && String.isBlank(this.redbookFamilyCode)) {
                    for (Redbook_Family__c f : this.redBookFamilyList) {
                        if (f.Description__c.equalsIgnoreCase(this.glassVariant.Family__c)) {
                            this.redbookFamilyCode = f.Name;
                            loadRedbookVehicles();
                            break;
                        }
                    }
                }
            }

        }
    }

    public List<SelectOption> getRedbookFamilyOptions() {
        return  RedbookUtils.getFamilyOptions(this.redBookFamilyList);
    }

    public void loadRedbookVehicles() {
        System.debug('Loading vehicles...');
        loadRedbookBadges();
        this.redBookVehicleList = RedbookUtils.getVehicles(this.redbookFamilyCode, this.redbookBadge, this.o.Application_AssetDetail__r.Year__c);
        System.debug('Vehicles loaded. ' + redBookVehicleList.size());
    }

    public void loadRedbookBadges() {
        System.debug('Loading badges...');
        this.redBookBadgedList = RedbookUtils.getFamilyBadges(this.redbookFamilyCode, this.o.Application_AssetDetail__r.Year__c);
        if (String.isBlank(this.redbookBadge) && this.glassVariant != null) {
            for (String a: this.redBookBadgedList) {
                if (a != null && a.equalsIgnoreCase(this.glassVariant.Description__c)) {
                    this.redbookBadge = a;
                }
            }
        }
        System.debug('badges loaded. ' + redBookBadgedList.size());
    }

    public List<SelectOption> getRedbookBadgeOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        for (String a : this.redBookBadgedList) {
            r.add(new SelectOption( a, a));
        }
        return r;
    }

    // Lelo                 2019-02-21
    public PageReference invokeRestWS() {
        if (isValidForSubmission()) {
            try {
                System.debug('Invoking RestWS...');
                InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote;
                param.quoting = this.quoting;
                Map<String, List<String>> msgList = null;
                if (!Test.isRunningTest()) {
                    msgList = InsuranceQuoteRestWS.getQuote(param);
                }
                if (msgList != null && msgList.containsKey('Error')) {
                    for (String msg : msgList.get('Error')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                    }
                } else {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote processed!'));
                    PageReference n = Page.InsuranceQuoteStep3;
                    n.getParameters().put('id', this.o.Id);
                    n.getParameters().put('C', 'N');
                    return n;
                }
            } catch (BaseException e) {
                if (e.hasMultipleMessages()) {
                    for (String m: e.messages) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, m));
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                System.debug(e.getStackTraceString());
            }
        }
        return null;
    }
    // 

    public void removeMV() {
        this.quote.Quote_Id__c = null;
        this.quote.Motor_Vehicle__c = null;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Motor Vehicle (MV) removed.'));
        insuranceProductsMessage();
    }
    
    public void removeRTI() {
        this.quote.Quote_Id__c = null;
        this.quote.Total_assist_RTI__c = null;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'RTI removed.'));
    }
    //Jesus Mora 2020-03-19 start
    public void removeLPI() {
        this.quote.Quote_Id__c = null;
        this.quote.LPI__c = null;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'LPI removed.'));
        insuranceProductsMessage();
    }
    //Jesus Mora 2020-03-19 end
    public void loadVehicleVariant() {
        this.glassVariant = null;
        if (this.o.Application_AssetDetail__c != null) {
            this.glassVariant = GlassServicesHelper.getVariantByCode(this.o.Application_AssetDetail__r.Variant__c);
        }
    }
    
    public Boolean getDisplayLTIProduct(){
        return InsuranceQuoteUtils.validateLendersNotLPIorLTI(this.quoting.Name);
        /*
        if(InsuranceQuoteUtils.validateLendersNotLPIorLTI(this.quoting.Name)){
            return false;
        }
        return true;
        */
    }
    //Jesus Mora 2020-03-19 start
    public Boolean getDisplayLPIProduct(){
        return InsuranceQuoteUtils.validateLendersNotLPIorLTI(this.quoting.Name);
    }
    //Jesus Mora 2020-03-19 end
    
    public Boolean insuranceProducts(){
        if(String.isBlank(quote.Motor_Vehicle__c) && String.isBlank(quote.Warranty_Insurance__c) && String.isBlank(quote.LTI_BRI__c) && String.isBlank(quote.LPI__c) && String.isBlank(quote.GAP__c)){
            return true;
        }
        return false;
    }
    
    public void insuranceProductsMessage(){
        if(insuranceProducts()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Not available insurance products, please click on "Return to quoting Tool" button.'));
        }
    }
}