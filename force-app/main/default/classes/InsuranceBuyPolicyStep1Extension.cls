public with sharing class InsuranceBuyPolicyStep1Extension {

    private final Custom_Opportunity__c o;
    public Application_Quoting__c quoting {set;get;}
    public Application_InsuranceQuote__c quote {set;get;}

    private Integer stepProcess = 0;
    public Application_Additional_Driver__c mainDriver {set;get;}
    public List<InsuranceQuoteUtils.AddtionalDriver> additionalDrivers {set;get;}

    public List<InsuranceQuoteUtils.QuoteAnnotationDTO> motoringOffences {set;get;}
    public List<InsuranceQuoteUtils.QuoteAnnotationDTO> licenceSantioned {set;get;}
    public List<InsuranceQuoteUtils.QuoteAnnotationDTO> accidentHistory {set;get;}
    public Map<String, Id> recordTypes;
    public Integer quoteAnnotationSelected {set;get;}
    private List<Insurance_Quote_Annotation__c> quoteAnnotaRemoved;

    public List<InsuranceQuoteUtils.PaymentMethodDTO> paymentMethods {set;get;}
    public Integer paymentSelected {set;get;}

    private List<Insurance_Quote_Policy__c> policyList = null;
    public Map<ApexPages.severity, List<String>> userMgs {set; get;}

    public Boolean displayDownloadPolicyButton {set;get;}

    public InsuranceBuyPolicyStep1Extension(ApexPages.StandardController ctrl) {
        this.o = (Custom_Opportunity__c)ctrl.getRecord();
        loadData();
        String paramTmp = System.currentPageReference().getParameters().get('STEP');
        if (!String.isBlank(paramTmp) && paramTmp.isNumeric()) {
            this.stepProcess = Integer.valueOf(paramTmp);
            if (this.stepProcess <= 0 || this.stepProcess >= 7) {
                this.stepProcess = 1;    
            }
        } else {
            this.stepProcess = 1;
        }
        this.quoteAnnotaRemoved = new List<Insurance_Quote_Annotation__c>();
        //Download buuton
        paramTmp = System.currentPageReference().getParameters().get('DPB');
        if ('1'.equals(paramTmp)) {
            this.displayDownloadPolicyButton = true;
        }
        //Jesus Mora 2020-06-01 start
        if (String.isNotBlank(this.quote.Gap__c) && 'A'.equals(this.quote.GAP_Acceptance__c)) {
            quote.GAP_Payment_Method__c = 'FINANCECOMPANY';
        }
        if (String.isNotBlank(this.quote.LTI_BRI__c) && 'A'.equals(this.quote.LTI_Acceptance__c)) {
            quote.LTI_Payment_Method__c = 'FINANCECOMPANY';
        }
        if (String.isNotBlank(this.quote.Total_assist_RTI__c) && 'A'.equals(this.quote.TAS_Acceptance__c)) {
            quote.TAS_Payment_Method__c = 'FINANCECOMPANY';
        }
        if (String.isNotBlank(this.quote.Warranty_Insurance__c) && 'A'.equals(this.quote.WRR_Acceptance__c)) {
            quote.WRR_Payment_Method__c = 'FINANCECOMPANY';
        }
        if (String.isNotBlank(this.quote.LPI__c) && 'A'.equals(this.quote.LPI_Acceptance__c)) {
            quote.LPI_Payment_Method__c = 'FINANCECOMPANY';
        }
        //Jesus Mora 2020-06-01 end
    }

    private void loadData() {
        recordTypes = InsuranceQuoteUtils.getRecordTypes();
        quoting = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
        this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoting.App_Insurance_Quote__c);
        if (this.quote == null) {
            //Raise an error
            //No quote for buying
        } else {
            mainDriver = InsuranceQuoteUtils.getMainDriver(this.quote.Id);
            if (mainDriver != null) {
                if (String.isBlank(mainDriver.First_Name__c)) {
                    this.mainDriver.First_Name__c = this.o.Application__r.First_Name__c;
                    if (!String.isBlank(this.o.Application__r.Middle_Name__c)) {
                        this.mainDriver.First_Name__c = this.mainDriver.First_Name__c + ' ' + this.o.Application__r.Middle_Name__c;
                    }
                }
                if (String.isBlank(this.mainDriver.Last_Name__c)) {
                    this.mainDriver.Last_Name__c = this.o.Application__r.Last_Name__c;
                }
                if (String.isBlank(this.mainDriver.Title__c)) {
                    this.mainDriver.Title__c = this.o.Application__r.Title_1__c;
                }
                if (!String.isBlank(this.o.Application__r.Current_Occupation_1__c)) {
                    this.mainDriver.Occupation__c = this.o.Application__r.Current_Occupation_1__c;
                }   
                if (!String.isBlank(this.o.Application__r.Business_ABN__c)) {
                    this.mainDriver.ABN__c = this.o.Application__r.Business_ABN__c;
                    this.mainDriver.Registered_for_GST__c = true;
                } else {
                    this.mainDriver.ABN__c = null;
                    this.mainDriver.Registered_for_GST__c = false;
                }
                this.mainDriver.Email__c = this.o.Application__r.Email_Address__c;
                if (String.isBlank(this.o.Application__r.Mobile_Number__c)) {
                    this.mainDriver.Hasnt_Mobile_Number__c = true;
                }
                this.mainDriver.Mobile__c = this.o.Application__r.Mobile_Number__c;
                this.mainDriver.Home_Phone__c = this.o.Application__r.Home_Phone__c;
                this.mainDriver.Work_Phone__c = this.o.Application__r.Work_Phone__c;
                this.mainDriver.Driver_Licence__c = this.o.Application__r.Drivers_License_1__c;
            }
            if (this.quote.Has_Additional_Driver__c) {
                additionalDrivers = InsuranceQuoteUtils.getAdditionalDriversObj(this.quote.Id);    
            } else {
                additionalDrivers = new List<InsuranceQuoteUtils.AddtionalDriver>();
            }
            if (String.isBlank(this.quote.Comprehensive_Insurer_Name__c)) {
                this.quote.Comprehensive_Insurer_Name__c = 'TBA';
            }
            if (this.o.Application_AssetDetail__c != null) {
                this.quote.Odometer__c = this.o.Application_AssetDetail__r.Actual_KM__c;
            }
            //Jesus Mora 2020-07-24 start
            this.quote.Amount_Financed__c = this.quoting.NAF__c;
            //Jesus Mora 2020-07-24 end
            this.loadQuoteAnnotations();
            this.loadPaymentMethods();
            this.loadPolicies();
            this.resetUserMessages();
        }
    }

    public void loadQuoteAnnotations() {
        motoringOffences = new List<InsuranceQuoteUtils.QuoteAnnotationDTO>();
        licenceSantioned = new List<InsuranceQuoteUtils.QuoteAnnotationDTO>();
        accidentHistory = new List<InsuranceQuoteUtils.QuoteAnnotationDTO>();

        List<Insurance_Quote_Annotation__c> d = InsuranceQuoteUtils.getInsuranceQuoteAnnotations(this.quote.Id);
        for (Insurance_Quote_Annotation__c a : d) {
            if (InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE.equals(a.RecordType.Name)) {
                motoringOffences.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(motoringOffences.size()+1, a));
            } else if (InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE.equals(a.RecordType.Name)) {
                licenceSantioned.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(licenceSantioned.size()+1, a));
            } else if (InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE.equals(a.RecordType.Name)) {
                accidentHistory.add(new InsuranceQuoteUtils.QuoteAnnotationDTO(accidentHistory.size()+1, a));
            }
        }
    }

    private void loadPaymentMethods() {
        paymentMethods = new List<InsuranceQuoteUtils.PaymentMethodDTO>();
        List<Application_Payment_Method__c> d = InsuranceQuoteUtils.getPaymentMethods(this.o.Application__c);
        for (Application_Payment_Method__c a : d) {
            paymentMethods.add(new InsuranceQuoteUtils.PaymentMethodDTO(paymentMethods.size()+1, a));
        }
    }

    private void loadPolicies() {
        this.policyList = [SELECT Id, Name, Application_Insurance_Quote__c, Cover_Type__c, Document_Description__c, 
                                  Document_Url__c, Policy_Number__c, Product_Code__c, CreatedDate
                           FROM Insurance_Quote_Policy__c 
                           WHERE Application_Insurance_Quote__c = :this.quote.Id];
    }

    private Boolean isValidForm() {
        Boolean r = true;
        if ('P'.equals(this.quote.Status__c)) return r;
        Date today = Date.today();
        if (this.stepProcess == 1) {
            if (this.quote.Cover_Start_Date__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Cover Start Date is required.'));
                r = false;
            } else {
                if (this.quote.Cover_Start_Date__c < today) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Cover Start Date cannot be less than today.'));
                    r = false;
                }
            }
            if ('A'.equals(this.quote.WRR_Acceptance__c)) {
                if (this.quote.Vehicle_Under_Warranty__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Is The Vehicle Under Manufacturer Or Seller Statutory Warranty?'));
                    r = false;
                } else if ('Y'.equals(this.quote.Vehicle_Under_Warranty__c)) {
                    if (this.quote.Vehicle_Warranty_End_Date__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Manufacturer/Statutory Warranty End Date is required'));
                        r = false;
                    } else if (this.quote.Vehicle_Warranty_End_Date__c < today) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Manufacturer/Statutory Warranty End Date cannot be less than today.'));
                        r = false;
                    }
                }
            }
        } else if (this.stepProcess == 2) {
            if (String.isBlank(this.mainDriver.First_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Given Names not supplied.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Last_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Last Name not supplied.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Occupation__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Occupation not supplied.'));
                r = false;
            }
            if (mainDriver.Registered_for_GST__c && String.isBlank(mainDriver.ABN__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, ABN not supplied.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Address_Line_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Address Line 1 field is required.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Suburb__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Suburb field is required.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.State__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the State field is required.'));
                r = false;
            }
            if (String.isBlank(this.mainDriver.Postcode__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Postcode field is required.'));
                r = false;
            }
            if (mainDriver.Hasnt_Mobile_Number__c) {
                if (String.isBlank(this.mainDriver.Home_Phone__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide a Home phone number.'));
                    r = false;
                }
            } else if (String.isBlank(this.mainDriver.Mobile__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the Mobile Phone is required.'));
                r = false;
            }
            //Jesus Mora 2020-06-01 start
            if ('A'.equals(this.quote.LTI_Acceptance__c) || 'A'.equals(this.quote.LPI_Acceptance__c)) {
            //Jesus Mora 2020-06-01 end    
                if (String.isBlank(this.mainDriver.Health_Info_Question_1__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Health Information question is required.'));
                    r = false;
                }
                //if (String.isBlank(this.mainDriver.Health_Info_Question_2__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, the second Health Information question is required.'));
                //    r = false;
                //}
                //if (('Y'.equals(this.mainDriver.Health_Info_Question_1__c) || 'Y'.equals(this.mainDriver.Health_Info_Question_2__c)) &&
                //     (String.isBlank(this.mainDriver.Health_Full_Details__c))) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please give full details to Health Information questions.'));
                //    r = false;
                //}
            }
        } else if (this.stepProcess == 3) {
            r = isValidDriverDetails(true);
        } else if (this.stepProcess == 4) {
            System.debug('5 >> ' + this.quote.Has_Existing_Damage__c + '|' + this.quote.Existing_Damage_Details__c);
            if (this.quote.Has_Existing_Damage__c && String.isBlank(this.quote.Existing_Damage_Details__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please specify the existing damage.'));
                r = false;
            }
        } else if (this.stepProcess == 5) {
            //Motor Vehicle
            if ('A'.equals(this.quote.MV_Acceptance__c)) {
                if (String.isBlank(this.quote.MV_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for Motor Vehicle.'));
                    r = false;
                } else {
                    if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.MV_Payment_Method__c)) &&
                         String.isBlank(this.quote.MV_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for Motor Vehicle.'));
                        r = false;
                    }
                }
            }
            //GAP
            if ('A'.equals(this.quote.GAP_Acceptance__c)) {
                if (String.isBlank(this.quote.GAP_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for GAP.'));
                    r = false;
                } else {
                    if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.GAP_Payment_Method__c)) &&
                         String.isBlank(this.quote.GAP_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for GAP.'));
                        r = false;
                    }
                }
            }
            //RTI
            if ('A'.equals(this.quote.TAS_Acceptance__c)) {
                if (String.isBlank(this.quote.TAS_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for RTI.'));
                    r = false;
                } else {
                    if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.TAS_Payment_Method__c)) &&
                         String.isBlank(this.quote.TAS_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for RTI.'));
                        r = false;
                    }
                }
            }
            //LTI
            if ('A'.equals(this.quote.LTI_Acceptance__c)) {
                if (String.isBlank(this.quote.LTI_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for LTI.'));
                    r = false;
                } else {
                    if (!'CREDITCARD'.equals(this.quote.LTI_Payment_Method__c) && 
                        !'DEALERCHEQUE'.equals(this.quote.LTI_Payment_Method__c) && 
                        !'FINANCECOMPANY'.equals(this.quote.LTI_Payment_Method__c))  {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select any Full Paymenth Method due to Monthly options is not allowed for LTI'));
                        r = false;
                    } else if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.LTI_Payment_Method__c)) &&
                         String.isBlank(this.quote.LTI_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for LTI.'));
                        r = false;
                    }
                }
            }
            //Jesus Mora 2020-06-01 start
            //LPI
            if ('A'.equals(this.quote.LPI_Acceptance__c)) {
                if (String.isBlank(this.quote.LPI_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for LPI.'));
                    r = false;
                } else {
                    if (!'CREDITCARD'.equals(this.quote.LPI_Payment_Method__c) && 
                        !'DEALERCHEQUE'.equals(this.quote.LPI_Payment_Method__c) && 
                        !'FINANCECOMPANY'.equals(this.quote.LPI_Payment_Method__c))  {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select any Full Paymenth Method due to Monthly options is not allowed for LPI'));
                        r = false;
                    } else if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.LPI_Payment_Method__c)) &&
                         String.isBlank(this.quote.LPI_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for LPI.'));
                        r = false;
                    }
                }
            }
            //Jesus Mora 2020-06-01 end
            //Warranty
            if ('A'.equals(this.quote.WRR_Acceptance__c)) {
                if (String.isBlank(this.quote.WRR_Payment_Method__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied for Warranty.'));
                    r = false;
                } else {
                    if (!String.isBlank(InsuranceQuoteUtils.getPaymentDetailType(this.quote.WRR_Payment_Method__c)) &&
                         String.isBlank(this.quote.WRR_Payment_Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a specific Payment Method for Warranty.'));
                        r = false;
                    }
                }
            }
        }
        return r;
    }

    private Boolean isValidDriverDetails(Boolean full) {
        Boolean r = true;
        Integer idx = 1;
        //Main Driver
        if (String.isBlank(this.mainDriver.Driver_Licence__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Driver Licence not supplied for Main Driver.'));
            r = false;
        }
        //Additional drivers
        if (this.quote.Has_Additional_Driver__c && !this.additionalDrivers.isEmpty()) {
            idx = 1;
            for (InsuranceQuoteUtils.AddtionalDriver a : this.additionalDrivers) {
                if (String.isBlank(a.data.First_Name__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, First Name not supplied for ' + idx + ') Additional Driver.'));
                    r = false;
                }
                if (String.isBlank(a.data.Last_Name__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Last Name not supplied for ' + idx + ') Additional Driver'));
                    r = false;
                }
                if (String.isBlank(a.data.Driver_Licence__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Driver Licence not supplied for ' + idx + ') Additional Driver'));
                    r = false;
                }
                idx++;
            }
        }
        //Motoring Offence
        if (this.quote.Has_Motoring_Offences__c) {
            if (motoringOffences.isEmpty()) {
                if (full) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, A Motoring Offence not supplied'));
                    r = false;
                }
            } else {
                idx = 1;
                for (InsuranceQuoteUtils.QuoteAnnotationDTO a : motoringOffences) {
                    if (a.data.Driver__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Driver not supplied for ' + idx + ') Monitoring Offence'));
                        r = false;
                    }
                    if (a.data.Date__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Date not supplied for ' + idx + ') Monitoring Offence'));
                        r = false;
                    }
                    if (String.isBlank(a.data.Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Detail Of Offence not supplied for ' + idx + ') Monitoring Offence'));
                        r = false;
                    }
                    if (a.data.Number__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Number Of Demerit Points not supplied for ' + idx + ') Monitoring Offence'));
                        r = false;
                    } else if (a.data.Number__c <= 0) { 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Number Of Demerit Points should be greater than 0 for ' + idx + ') Monitoring Offence'));
                        r = false;
                    }
                    idx++;
                }
            }
        }
        //Licence Sanctioned
        if (this.quote.Has_Licence_Santioned__c) {
            if (licenceSantioned.isEmpty()) {
                if (full) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, A Licence Endorsement not supplied'));
                    r = false;
                }
            } else {
                idx = 1;
                for (InsuranceQuoteUtils.QuoteAnnotationDTO a : licenceSantioned) {
                    if (a.data.Driver__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Driver not supplied for ' + idx + ') Licence Endorsement'));
                        r = false;
                    }
                    if (a.data.Date__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Date not supplied for ' + idx + ') Licence Endorsement'));
                        r = false;
                    }
                    if (a.data.Number__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Period Of Suspension not supplied for ' + idx + ') Licence Endorsement'));
                        r = false;
                    }
                    if (String.isBlank(a.data.Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Details Of Licence Refusal not supplied for ' + idx + ') Licence Endorsement'));
                        r = false;
                    }
                    idx++;
                }
            }
        }
        //Accident History
        if (this.quote.Has_Accident_History__c) {
            if (accidentHistory.isEmpty()) {
                if (full) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, An Accident not supplied'));
                    r = false;
                }
            } else {
                idx = 1;
                for (InsuranceQuoteUtils.QuoteAnnotationDTO a : accidentHistory) {
                    if (a.data.Driver__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Driver not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    if (a.data.Date__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Date not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    if (String.isBlank(a.data.Detail__c)) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Detail Of Accident not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    if (a.data.Amount__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Amount Of Loss $ not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    if (a.data.Is_Driver_Fault__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Was This Driver At Fault not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    if (a.data.Was_Vehicle_Affected__c == null) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, Was The Vehicle Stolen, ' +
                                                                                            'Damaged (Inc Hail) Or Destroyed ' +
                                                                                            'By Fire not supplied for ' + idx + ') Accident'));
                        r = false;
                    }
                    idx++;
                }
            }
        }
        //Other Information
        if (this.quote.Other_Info_Question_1__c) {
            if (String.isBlank(this.quote.Other_Info_Details_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, You must provide details for driver convicted of criminal offence in Other Information section.'));
                        r = false;
            }
        }
        if (this.quote.Other_Info_Question_2__c) {
            if (String.isBlank(this.quote.Other_Info_Details_2__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, You must provide details for driver insurance refused in Other Information section.'));
                r = false;
            }
        }
        return r;
    }

    private void saveData() {
        if (!'P'.equals(this.quote.Status__c)) {
            if (this.stepProcess == 1) {
                if (this.quote.Cover_Start_Date__c != null) {
                    //Jesus Mora 2020-06-01 start
                    if ('A'.equals(this.quote.GAP_Acceptance__c) || 'A'.equals(this.quote.LTI_Acceptance__c) || 'A'.equals(this.quote.LPI_Acceptance__c)) {
                    //Jesus Mora 2020-06-01 end    
                        this.quote.Comprehensive_Insurance_Expiry_Date__c = this.quote.Cover_Start_Date__c.addYears(1);
                    } else if ('A'.equals(this.quote.TAS_Acceptance__c)) {
                        this.quote.Comprehensive_Insurance_Expiry_Date__c = 
                                this.quote.Cover_Start_Date__c.addMonths(
                                    Integer.valueOf(this.quote.Assist_Cover_Term__c));
                    }
                }
                //System.debug('Calculating Insurance Expiry Date ... ' + this.quote.Cover_Start_Date__c + ' | ' + this.quote.Comprehensive_Insurance_Expiry_Date__c);
            }
            update this.quote;
            update this.mainDriver;
            if (this.stepProcess == 3) {
                if (this.quote.Has_Additional_Driver__c && !this.additionalDrivers.isEmpty()) {
                    List<Application_Additional_Driver__c> d = new List<Application_Additional_Driver__c>();
                    for (InsuranceQuoteUtils.AddtionalDriver a : this.additionalDrivers) {
                        d.add(a.data);
                    }
                    update d;
                }
                List<String> annotationTypesRemove = new List<String>();
                List<Insurance_Quote_Annotation__c> annotationList = new List<Insurance_Quote_Annotation__c>();

                //Motoring Offences
                if (this.quote.Has_Motoring_Offences__c) {
                    annotationList.addAll(this.getQuoteAnnotationData(motoringOffences));
                } else {
                    annotationTypesRemove.add(InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
                    this.motoringOffences.clear();
                }

                //Licence Sanctioned
                if (this.quote.Has_Licence_Santioned__c) {
                    annotationList.addAll(this.getQuoteAnnotationData(licenceSantioned));
                } else {
                    annotationTypesRemove.add(InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
                    licenceSantioned.clear();
                }

                //Accident History
                if (this.quote.Has_Accident_History__c) {
                    annotationList.addAll(this.getQuoteAnnotationData(accidentHistory));
                } else {
                    annotationTypesRemove.add(InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
                    this.accidentHistory.clear();
                }

                //Store data
                if (!annotationList.isEmpty()) { 
                    upsert annotationList;
                }

                //Remove Annotations records
                if (!annotationTypesRemove.isEmpty()) {
                    delete [SELECT Id FROM Insurance_Quote_Annotation__c 
                            WHERE Insurance_Quote__c = :this.quote.Id
                            AND RecordType.Name IN :annotationTypesRemove];
                }
            } else if (this.stepProcess == 4) {
                update this.o.Application_AssetDetail__r;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Data is not saved because this quote is already processed'));
        }
    }

    private List<Insurance_Quote_Annotation__c> getQuoteAnnotationData(List<InsuranceQuoteUtils.QuoteAnnotationDTO> lst) {
        List<Insurance_Quote_Annotation__c> r = new List<Insurance_Quote_Annotation__c>();
        for (InsuranceQuoteUtils.QuoteAnnotationDTO a : lst) {
            if (a.data.Insurance_Quote__c == null) {
                a.data.Insurance_Quote__c = this.quote.Id;
            }
            r.add(a.data);
        }
        return r;
    }

    public PageReference nextAction() {
        //Validate form
        if (!isValidForm()) return null;

        //Save data
        this.saveData();

        if (stepProcess < 6) {
            this.stepProcess++;
        }

        ////Redirect
        //System.debug('nextAction...');
        //PageReference n = Page.InsuranceQuoteStep2;
        //n.getParameters().put('id', this.o.Id);
        //return n;
        return null;
    }

    public PageReference saveAction() {
        //TODO - Validate
        if (!isValidForm()) return null;

        //Save data
        this.saveData();

        return null;
    }

    public PageReference previousAction() {
        //Save data
        this.saveData();
        //Reload
        //this.loadData();
        if (stepProcess > 1) {
            this.stepProcess--;
        }
        
        return null;
    }
    
    public Integer getStepNumber() {
        return this.stepProcess;
    }

    public void setStepNumber(Integer step) {
        this.stepProcess = step;
    }

    public String getSectionName() {
        String r = '';
        if (this.stepProcess == 1) {
            r = 'Policy Details';
        } else if (this.stepProcess == 2) {
            r = 'Insured Details';
        } else if (this.stepProcess == 3) {
            r = 'Driver Details';
        } else if (this.stepProcess == 4) {
            r = 'Vehicle Details';
        } else if (this.stepProcess == 5) {
            r = 'Review';
        } else if (this.stepProcess == 6) {
            r = 'Payment Results';
        }
        return r;
    }

    public PageReference goToQuotingTool() {
        this.saveData();
        return InsuranceQuoteUtils.goToQuotingTool(this.o.Id,this.quote.Financier_Name__c);
    }

    private void resetCorrespondenceAddress() {
        this.mainDriver.Address_Line_1__c = null;
        this.mainDriver.Address_Line_2__c = null;
        this.mainDriver.Suburb__c = null;
        this.mainDriver.State__c = null;
        this.mainDriver.Postcode__c = null;
    }

    public PageReference copyResidentialAddress() {
        this.resetCorrespondenceAddress();
        this.mainDriver.Address_Line_1__c = '';
        if (!String.isBlank(this.o.Application__r.Unit_Number__c)) {
            this.mainDriver.Address_Line_1__c = this.o.Application__r.Unit_Number__c + ' / ';
        }
        this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + this.o.Application__r.Street_Number__c;
        this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Street_Address__c;
        if (!String.isBlank(this.o.Application__r.Street_Type__c)) {
            this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Street_Type__c;
        }
        if (!String.isBlank(this.o.Application__r.Suburb__c)) {
            this.mainDriver.Suburb__c = this.o.Application__r.Suburb__c;
        }
        if (!String.isBlank(this.o.Application__r.State__c)) {
            this.mainDriver.State__c = this.o.Application__r.State__c;
        }
        if (!String.isBlank(this.o.Application__r.Postcode__c)) {
            this.mainDriver.Postcode__c = this.o.Application__r.Postcode__c;
        }
        return null;
    }

    public PageReference copyWorkingAddress() {
        this.resetCorrespondenceAddress();
        this.mainDriver.Address_Line_1__c = '';
        if (!String.isBlank(this.o.Application__r.Current_Work_Unit_Number_1__c)) {
            this.mainDriver.Address_Line_1__c = this.o.Application__r.Current_Work_Unit_Number_1__c + ' / ';
        }
        this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + this.o.Application__r.Current_Work_Street_Number_1__c;
        this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Current_Work_Address_1__c;
        if (!String.isBlank(this.o.Application__r.Current_Work_Street_Type_1__c)) {
            this.mainDriver.Address_Line_1__c = this.mainDriver.Address_Line_1__c + ' ' + this.o.Application__r.Current_Work_Street_Type_1__c;
        }
        if (!String.isBlank(this.o.Application__r.Current_Work_Suburb_1__c)) {
            this.mainDriver.Suburb__c = this.o.Application__r.Current_Work_Suburb_1__c;
        }
        if (!String.isBlank(this.o.Application__r.Current_Work_State_1__c)) {
            this.mainDriver.State__c = this.o.Application__r.Current_Work_State_1__c;
        }
        if (!String.isBlank(this.o.Application__r.Current_Work_Postcode_1__c)) {
            this.mainDriver.Postcode__c = this.o.Application__r.Current_Work_Postcode_1__c;
        }
        return null;

    }

    private void activateQuotingAnnotation(List<InsuranceQuoteUtils.QuoteAnnotationDTO> lst, String typeName) {
        if (lst.isEmpty()) {
            this.addQuoteAnnotation(lst, typeName);
        }
    }
    public void activateMotoringOffence() {
        if (this.quote.Has_Motoring_Offences__c) {
            this.activateQuotingAnnotation(motoringOffences, InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
        }
    }

    public void activateLicenceSanctioned() {
        if (this.quote.Has_Licence_Santioned__c) {
            this.activateQuotingAnnotation(licenceSantioned, InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
        }
    }

    public void activateAccidentHistory() {
        if (this.quote.Has_Accident_History__c) {
            this.activateQuotingAnnotation(accidentHistory, InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
        }
    }

    private void addQuoteAnnotation(List<InsuranceQuoteUtils.QuoteAnnotationDTO> lst, String typeName) {
        if (isValidDriverDetails(false)) {
            InsuranceQuoteUtils.QuoteAnnotationDTO a = new InsuranceQuoteUtils.QuoteAnnotationDTO(
                                    lst.size()+1, recordTypes.get(typeName));
            lst.add(a);
        }
    }

    public void addMotoringOffence() {
        if (this.quote.Has_Motoring_Offences__c) {
            this.addQuoteAnnotation(motoringOffences, InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE);
        }
    }

    public void addLicenceSanctioned() {
        if (this.quote.Has_Motoring_Offences__c) {
            this.addQuoteAnnotation(licenceSantioned, InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE);
        }
    }

    public void addAccidentHistory() {
        if (this.quote.Has_Accident_History__c) {
            this.addQuoteAnnotation(accidentHistory, InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE);
        }
    }

    public void removeQuoteAnnotation(List<InsuranceQuoteUtils.QuoteAnnotationDTO> lst) {
        if (this.quoteAnnotationSelected != null && this.quoteAnnotationSelected <= lst.size()) {
            InsuranceQuoteUtils.QuoteAnnotationDTO o = lst.get(this.quoteAnnotationSelected-1);
            if (o != null) {
                if (o.data.Id != null) {
                    delete o.data;
                    //this.quoteAnnotaRemoved.add(o.data);
                }
                lst.remove(this.quoteAnnotationSelected-1);
            }
            resetQuoteAnnotationIndexes(lst);
        }
    }

    private void resetQuoteAnnotationIndexes(List<InsuranceQuoteUtils.QuoteAnnotationDTO> lst) {
        Integer idx = 1;
        for (InsuranceQuoteUtils.QuoteAnnotationDTO a : lst) {
            a.idx = idx;
            idx++;
        }
    }

    public void removeMotoringOffence() {
        this.removeQuoteAnnotation(motoringOffences);
    }

    public void removeLicenceSanctioned() {
        this.removeQuoteAnnotation(licenceSantioned);
    }

    public void removeAccidentHistory() {
        this.removeQuoteAnnotation(accidentHistory);
    }

    public List<SelectOption> getDriverOptions() {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption(this.mainDriver.Id, this.mainDriver.First_Name__c + ' ' + this.mainDriver.Last_Name__c));
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

    public void removePaymentMethod() {
        if (this.paymentSelected != null) {
            InsuranceQuoteUtils.PaymentMethodDTO o = paymentMethods.get(this.paymentSelected-1);
            if (o != null) {
                paymentMethods.remove(this.paymentSelected-1);
                if (o.data.Id != null) {
                    delete o.data;
                }
                
            }
            resetPaymentMethodIndexes();
        }
    }

    //private void resetQuotePaymentMethodDetails(Id paymentMethodId) {
    //    if (paymentMethodId != null) {
    //        if (paymentMethodId.equals(this.quote.MV_Payment_Detail__c)) {
    //            this.quote.MV_Payment_Method__c = null;
    //            System.debug('MV detail reseted');
    //        }
    //        if (paymentMethodId.equals(this.quote.GAP_Payment_Detail__c)) {
    //            this.quote.GAP_Payment_Method__c = null;
    //            System.debug('GAP detail reseted');
    //        }
    //        if (paymentMethodId.equals(this.quote.TAS_Payment_Detail__c)) {
    //            this.quote.TAS_Payment_Method__c = null;
    //            System.debug('TAS detail reseted');
    //        }
    //        if (paymentMethodId.equals(this.quote.LTI_Payment_Detail__c)) {
    //            this.quote.LTI_Payment_Method__c = null;
    //            System.debug('LTI detail reseted');
    //        }
    //        if (paymentMethodId.equals(this.quote.WRR_Payment_Detail__c)) {
    //            this.quote.WRR_Payment_Method__c = null;
    //            System.debug('WRR detail reseted');
    //        }
    //    }
    //}

    private void resetPaymentMethodIndexes() {
        Integer idx = 1;
        for (InsuranceQuoteUtils.PaymentMethodDTO a : paymentMethods) {
            a.idx = idx;
            idx++;
        }
    }

    public void addPaymentMethod() {
        InsuranceQuoteUtils.PaymentMethodDTO a = new InsuranceQuoteUtils.PaymentMethodDTO(
                                paymentMethods.size()+1);
        paymentMethods.add(a);
    }

    public void savePaymentMethod() {
        System.debug('savePaymentMethod... ' + this.paymentSelected);
        if (this.paymentSelected != null) {
            InsuranceQuoteUtils.PaymentMethodDTO a = paymentMethods.get(this.paymentSelected-1);
            if (a != null && this.isPaymentMethodValid(a)) {
                if (a.data.Application__c == null) {
                    a.data.Application__c = this.o.Application__c;
                }
                upsert a.data;
                System.debug('Id >> ' + a.data.Id + ' | ' + a.data.Holder_Name__c);
            }
        }
    }

    private List<SelectOption> getPaymentMethodOptions(String typeMethod) {
        List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        if (!String.isBlank(typeMethod)) {
            String method = InsuranceQuoteUtils.getPaymentDetailType(typeMethod);
            if (!String.isBlank(method)) {
                for(InsuranceQuoteUtils.PaymentMethodDTO a : paymentMethods) {
                    if (method.equals(a.data.Method__c) && !String.isBlank(a.data.Id)) {
                        r.add(new SelectOption( a.data.Id, a.idx + ') Payment Method'));
                    }
                }
            }
        }
        return r;
    }

    public List<SelectOption> getMVPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.MV_Payment_Method__c);
    }

    public List<SelectOption> getGapPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.GAP_Payment_Method__c);
    }

    public List<SelectOption> getTasPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.TAS_Payment_Method__c);
    }

    public List<SelectOption> getLtiPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.LTI_Payment_Method__c);
    }
    //Jesus Mora 2020-06-01 start
    public List<SelectOption> getLpiPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.LPI_Payment_Method__c);
    }
    //Jesus Mora 2020-06-01 end
    public List<SelectOption> getWrrPaymentMethodOptions() {
        return getPaymentMethodOptions(this.quote.WRR_Payment_Method__c);           
    }

    public Boolean isPaymentMethodValid(InsuranceQuoteUtils.PaymentMethodDTO a) {
        Boolean r = true;
        if (a == null || a.data == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Payment Method not supplied'));
            r = false;
        } else {
            String m1 = ' not supplied';
            String m2 = ' for ' + a.idx + ') Payment Method.';
            if (String.isBlank(a.data.Method__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Method' + m1 + m2));
                r = false;
            } else if (InsuranceQuoteUtils.CREDIT_CARD_METHOD.equals(a.data.Method__c)) {
                if (String.isBlank(a.data.Credit_Card_Number__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Credit Card Number' + m1 + m2));
                    r = false;
                }   
                if (String.isBlank(a.data.Verification_Code__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Verification Code' + m1 + m2));
                    r = false;
                }
                if (String.isBlank(a.data.Expiry_Month__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, an Expiry Month Number' + m1 + m2));
                    r = false;
                }
                //if (String.isBlank(a.data.Expiry_Year__c)) {
                //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Credit Card Number' + m1 + m2));
                //    r = false;
                //}
            } else if (InsuranceQuoteUtils.BANK_ACCOUNT_METHOD.equals(a.data.Method__c)) {
                if (String.isBlank(a.data.BSB_Number__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a BSB Number' + m1 + m2));
                    r = false;
                }   
                if (String.isBlank(a.data.Account_Number__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, an Account Number' + m1 + m2));
                    r = false;
                }
            }
            if (String.isBlank(a.data.Holder_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please, a Holder Name' + m1 + m2));
                r = false;
            }   
        }
        return r;
    }



    private Boolean isRequirePaymentDetail(String typeMethod) {
        String method = InsuranceQuoteUtils.getPaymentDetailType(typeMethod);
        return String.isNotBlank(method);
    }

    public Boolean getRequireMVPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.MV_Payment_Method__c);
    }

    public Boolean getRequireGAPPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.GAP_Payment_Method__c);
    }
    public Boolean getRequireTASPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.TAS_Payment_Method__c);
    }
    public Boolean getRequireLTIPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.LTI_Payment_Method__c);
    }
    //Jesus Mora 2020-06-01 start
    public Boolean getRequireLPIPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.LPI_Payment_Method__c);
    }
    //Jesus Mora 2020-06-01 end
    public Boolean getRequireWRRPaymentDetail() {
        return this.isRequirePaymentDetail(this.quote.WRR_Payment_Method__c);   
    }

    public List<SelectOption> getCredidCardYearOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer currentYear = Date.today().year();
        //Load current credit card years
        Integer ccYear = currentYear;
        for(InsuranceQuoteUtils.PaymentMethodDTO a : paymentMethods) {
            if (InsuranceQuoteUtils.CREDIT_CARD_METHOD.equals(a.data.Method__c) && !String.isBlank(a.data.Expiry_Year__c)) {
                if (Integer.valueOf(a.data.Expiry_Year__c) < ccYear) {
                    ccYear = Integer.valueOf(a.data.Expiry_Year__c);
                }
            }
        }
        for (;ccYear <= (currentYear+10);ccYear++) {
            r.add(new SelectOption( String.valueOf(ccYear), String.valueOf(ccYear)));
        }
        return r;
    }

    public PageReference performFullAssessment() {

        //Save data
        this.saveData();

        return null;
    }    

    public PageReference invokeWS() {
        //Validate
        if (!isValidForm()) return null;
        try {
                System.debug('Invoking WS...');
                InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote;
                param.quoting = this.quoting;
                if (!'P'.equals(this.quote.Status__c)) {
                    if (!Test.isRunningTest()) {
                        InsuranceQuoteWS.getFinalQuote(param);
                    }
                    if ('Fail'.equals(this.quote.Status__c)) {
                        this.displayFailureReasons();
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Full Assessment done!'));
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Data is not saved because this quote is already processed'));
                }
                if (stepProcess < 6 && !'Fail'.equals(this.quote.Status__c)) {
                    this.stepProcess++;
                }
        } catch (Exception e) {
            if(e.getMessage().contains('Unable to locate a vehicle')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        System.debug('InvokeWS ...');
        return null;
    }

    public PageReference invokeRestWS() {
        //Validate
        if (!isValidForm()) return null;
        //try {
                System.debug('Invoking WS...');
                InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote;
                param.quoting = this.quoting;
                param.processType = InsuranceQuoteUtils.PROCESS_FINALQUOTE;
                if (!'P'.equals(this.quote.Status__c)) {
                    Map<String, List<String>> msgList = null;
                    if (!Test.isRunningTest()) {
                        msgList = InsuranceQuoteRestWS.getQuote(param);
                    }
                    if (msgList != null && msgList.containsKey('Error')) {
                        for (String msg : msgList.get('Error')) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                        }
                    } else {
                        if ('Fail'.equals(this.quote.Status__c)) {
                            this.displayFailureReasons();
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Full Assessment done!'));
                        }
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Data is not saved because this quote is already processed'));
                }
                if (stepProcess < 6 && !'Fail'.equals(this.quote.Status__c)) {
                    this.stepProcess++;
                }
        //} catch (Exception e) {
        //    if(e.getMessage().contains('Unable to locate a vehicle')) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //            'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
        //    } else {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        //    }
        //}
        System.debug('InvokeWS ...');
        return null;
    }

    public PageReference buyPolicy() {
        
        //Save data
        this.saveData();

        return null;
    } 

    public PageReference invokePaymentWS() {
        //TODO - Validate
        if (!isValidForm()) return null;
        this.resetUserMessages();
        try {
            System.debug('Invoking Payment WS...');
            InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
            param.opp = this.o;
            param.quote = this.quote;
            param.quoting = this.quoting;
            param.paymentMethods = this.paymentMethods;
            if (!Test.isRunningTest()) {
                this.policyList = InsuranceQuoteWS.buyPolicy(param);
                //this.policyList = [SELECT Id, Cover_Type__c, Document_Description__c, Document_Url__c, Policy_Number__c, Product_Code__c
                //                   FROM Insurance_Quote_Policy__c WHERE Application_Insurance_Quote__c = :this.quote.Id];
            }
            putUserMessage(ApexPages.Severity.Confirm, 'Payment successfully submitted!');
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Payment successfully submitted!'));
            
            if (stepProcess < 6) {
                this.stepProcess++;
            }

        } catch (Exception e) {
            if(e.getMessage().contains('Unable to locate a vehicle')) {
                putUserMessage(ApexPages.Severity.ERROR, 'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.');
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                //    'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
            } else {
                putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        System.debug('InvokeWS ...');
        return null;
    }

    public PageReference invokePaymentRestWS() {
        //TODO - Validate
        if (!isValidForm()) return null;
        this.resetUserMessages();
        //try {
            System.debug('Invoking Payment RestWS...');
            InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
            param.opp = this.o;
            param.quote = this.quote;
            param.quoting = this.quoting;
            param.processType = InsuranceQuoteUtils.PROCESS_BUYPOLICY;
            param.paymentMethods = this.paymentMethods;
            Map<String, List<String>> msgList = null;
            if (!Test.isRunningTest()) {
                msgList = InsuranceQuoteRestWS.preLodgeQuote(param);
            }
            if (msgList != null && msgList.containsKey('Error')) {
                for (String msg : msgList.get('Error')) {
                    putUserMessage(ApexPages.Severity.ERROR, msg);
                }
            } else {
                if (quote.Is_PreLodged__c) {
                    putUserMessage(ApexPages.Severity.Confirm, 'Payment successfully Pre-Lodged!');
                }
                if (quote.Is_Lodged__c) {
                    putUserMessage(ApexPages.Severity.Confirm, 'Payment successfully Lodged!');   
                } else {
                    // putUserMessage(ApexPages.Severity.ERROR, 'Payment could not be Lodged.');
                }
            }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Payment successfully submitted!'));
            if (stepProcess < 6 && !userMgs.containsKey(ApexPages.Severity.ERROR)) {
                this.stepProcess++;
                this.policyList = null;
            }

        //} catch (Exception e) {
        //    if(e.getMessage().contains('Unable to locate a vehicle')) {
        //        putUserMessage(ApexPages.Severity.ERROR, 'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.');
        //        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
        //        //    'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
        //    } else {
        //        putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
        //        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        //    }
        //}
        System.debug('InvokeWS ...');
        return null;
    }

    public PageReference downloadMvPolicyDocument() {
        this.downloadPolicyDocument(this.getMvPolicy());
        return null;
    }

    public PageReference downloadGapPolicyDocument() {
        this.downloadPolicyDocument(this.getGapPolicy());
        return null;
    }

    public PageReference downloadLtiPolicyDocument() {
        this.downloadPolicyDocument(this.getLtiPolicy());
        return null;
    }
    //Jesus Mora 2020-06-01 start
    public PageReference downloadLpiPolicyDocument() {
        this.downloadPolicyDocument(this.getLpiPolicy());
        return null;
    }
    //Jesus Mora 2020-06-01 end
    public PageReference downloadWarrantyPolicyDocument() {
        this.downloadPolicyDocument(this.getWarrPolicy());
        return null;
    }

    public PageReference downloadRtiPolicyDocument() {
        this.downloadPolicyDocument(this.getRtiPolicy());
        showUserMessages();
        return null;
    }

    public void downloadPolicyDocument(Insurance_Quote_Policy__c p) {
        if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            System.debug('Downloading Policy Documents ...');
            if (p != null && p.Id != null) {
                Http http = new Http();
                System.debug('Processing Policy >> ' + p.Product_Code__c + ' [' + p.Policy_Number__c + '] ' + p.Document_Description__c);
                //Check if documento is already uploaded to Cloud Documents (S3)
                if (!CloudDocsHelper.isFileNameUploaded(this.o.Id, p.Policy_Number__c + '.pdf')) {

                    //Download document from Eric
                    CloudRequiredDocument doc = null;
                    if (String.isNotBlank(p.Document_Url__c)) {
                        doc = InsuranceQuoteUtils.downloadPolicyDocument(this.o.Id, p, http);
                    } else {
                        HTTPResponse response = InsuranceQuoteRestWS.getPolicyDocument(p.Policy_Number__c);
                        doc = InsuranceQuoteUtils.downloadPolicyDocument(this.o.Id, p, response);
                    }

                    if (doc != null) {
                        //Upload document to Amazon S3
                        CloudDocsHelper.saveToCloud(doc);
                    }
                }
            }
        }
    }



    public Insurance_Quote_Policy__c getGapPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_GAP);
    }
    public Insurance_Quote_Policy__c getLtiPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_LTI);
    }
    //Jesus Mora 2020-06-01 start
    public Insurance_Quote_Policy__c getLpiPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_LPI);
    }
    //Jesus Mora 2020-06-01 end
    public Insurance_Quote_Policy__c getRtiPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_RTI);
    }
    public Insurance_Quote_Policy__c getMvPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_MV);
    }
    public Insurance_Quote_Policy__c getWarrPolicy() {
        return getInsurancePolicy(InsuranceQuoteUtils.POLICY_CODE_WAR);
    }


    private Insurance_Quote_Policy__c getInsurancePolicy(String productCode) {
        Insurance_Quote_Policy__c r = new Insurance_Quote_Policy__c();
        if (this.policyList == null) {
            this.policyList = InsuranceQuoteUtils.getPolicies(this.quote.Id);
        }
        if (this.policyList != null && !this.policyList.isEmpty()) {
            for (Insurance_Quote_Policy__c a : this.policyList) {
                if (productCode.equals(a.Product_Code__c)) {
                    r = a;
                    break;
                }
            }
        }
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
                    System.debug(k  + '|' + m);
                    ApexPages.addMessage(new ApexPages.Message(k, m));
                }
            }
        }
    }

    public String getQuoteStatus() {
        if (this.quote != null) {
            return InsuranceQuoteUtils.getLabelQuoteStatus(this.quote.Status__c);
        }
        return null;
    }

    public void displayFailureReasons() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The quotation has failed!'));
        for (Insurance_Failure_Reason__c a : [SELECT Reason__c FROM Insurance_Failure_Reason__c WHERE Insurance_Quote__c = :this.quote.Id]) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, a.Reason__c));
        }
    }
}