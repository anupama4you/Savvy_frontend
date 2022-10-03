import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMacquarieCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/MacquarieLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getRateSetterRate from "@salesforce/apex/QuoteManager.getRateSetterRate";
import getPickListValue from '@salesforce/apex/QuoteManager.getPickListValue';
import getDependentPickListValue from '@salesforce/apex/QuoteManager.getDependentPickListValue';

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
//const oppID = 'a01Bm00000192uuIAA'; 
export default class QuoteMacquarieCommercialCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;
    @track typeValue = "Value";
    @track resDisable = { per: true, val: false };
    //@track goodsTypeOptions;
    @track goodsSubTypeOptions;
    @track loanFrequencyOptions;
    @track assetYearOptions;

    LENDER_QUOTING = "Macquarie Commercial";

    connectedCallback() {
        //console.log(`connectedCallback...`); 
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            //CalHelper.load(oppID) 
            .then((data) => {
                //console.log(`Data loaded!`);
                //console.log(`JS DATA `, JSON.stringify(data));
                this.quoteForm = data;

                //Goods SubType
                getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods SubType', pickVal1: this.quoteForm.loanProduct, pickVal2: this.quoteForm.goodsType })
                    .then(result => {
                        let options = [];
                        for (var key in result) {
                            options.push({ label: result[key].label, value: result[key].value });
                        }
                        this.goodsSubTypeOptions = options;
                        // this.quoteForm.goodsSubType= "";
                    })
                    .catch(error => {
                        console.log(error);
                        this.error = error;
                    });

                this.tableRates = CalHelper.getTableRatesData();
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.baseRateCalc();
            });

        //apex picklistValues
        this.goodsTypeOptions();//replace with dynamic picklist


        //Static picklist values
        //Asset Year
        getPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Asset Year' })
            .then(result => {
                let options = [];
                for (var key in result) {
                    options.push({ label: result[key].label, value: result[key].value });
                }
                this.assetYearOptions = options;
            })
            .catch(error => {
                console.log(error);
                this.error = error;
            });

        //Dynamic picklist values
        if (this.quoteForm != null && this.quoteForm != undefined) {
            getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods SubType', pickVal1: this.quoteForm.loanProduct, pickVal2: this.quoteForm.goodsType })
                .then(result => {
                    let options = [];
                    for (var key in result) {
                        options.push({ label: result[key].label, value: result[key].value });
                    }
                    this.quoteForm.goodsSubType = "";
                    this.goodsSubTypeOptions = options;
                })
                .catch(error => {
                    console.log(error);
                    this.error = error;
                });

            getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Loan Frequency', pickVal1: this.quoteForm.loanProduct, pickVal2: '' })
                .then(result => {
                    let options = [];
                    for (var key in result) {
                        options.push({ label: result[key].label, value: result[key].value });
                    }
                    this.quoteForm.loanFrequency = "";
                    this.loanFrequencyOptions = options;
                })
                .catch(error => {
                    console.log(error);
                    this.error = error;
                });
        }
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

    //Images
    get logoUrl() {
        return LENDER_LOGO;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get assetTypeOptions() {
        return CalHelper.options.assetTypes;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get customerProfileOptions() {
        return CalHelper.options.customerProfiles;
    }

    get clientTierOptions() {
        return CalHelper.options.clientTiers;
    }

    get vehicleConditionOptions() {
        return CalHelper.options.vehicleConditions;
    }

    get greenCarOptions() {
        return CalHelper.options.greenCars;
    }

    get vehicleYearOptions() {
        return CalHelper.options.vehicleYears;
    }

    get leaseAgreementOptions() {
        return CalHelper.options.leaseAgreements;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get typeValueOptions() {
        return CalHelper.options.typeValues;
    }

    get propertyOwnerOptions() {
        return CalHelper.options.propertyOwners;
    }

    goodsTypeOptions() {
        getPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods Type' })
            .then(result => {
                let options = [];
                for (var key in result) {
                    options.push({ label: result[key].label, value: result[key].value });
                }
                this.goodsTypeOptions = options;
            })
            .catch(error => {
                console.log(error);
                this.error = error;
            });
    }


    // Events
    handleFieldChange(event) {
        console.log(`Changing value for: ${event.target.name}...`);
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        console.log(`new value: ${event.target.value}...`);
        if (fld && fld.type === "number") {
            v = Number(v);
        }

        this.quoteForm["netDeposit"] = this.netDeposit;
        fldName === "term"
            ? (this.quoteForm[fldName] = parseInt(v))
            : (this.quoteForm[fldName] = v);
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            console.log('==> SHOOT HERE Base Rate Calculation handlefieldchange');
            this.baseRateCalc();
        }

        // Fees Calculation
        if (CalHelper.CALC_FEES_FIELDS.includes(fldName)) {
            console.log('==> SHOOT HERE CALC_FEES_FIELDS Calculation handlefieldchange');
            this.calculateFees();
        }

        // Client Rate Calculation
        if (CalHelper.CLIENT_RATE_FIELDS.includes(fldName)) {
            this.clientRateCalc();
        }

        // Type value
        if (fldName === "typeValue") {
            this.typeValue = v;
        }

        // Residual Value Calculation
        if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
            this.residualCalc();
        }

        //Dynamic picklist values
        if (this.quoteForm != null && this.quoteForm != undefined) {
            //Goods SubType
            if (event.target.name == 'goodsType' || event.target.name == 'loanProduct') {
                getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods SubType', pickVal1: this.quoteForm.loanProduct, pickVal2: this.quoteForm.goodsType })
                    .then(result => {
                        let options = [];
                        for (var key in result) {
                            options.push({ label: result[key].label, value: result[key].value });
                        }
                        this.quoteForm.goodsSubType = "";
                        this.goodsSubTypeOptions = options;
                    })
                    .catch(error => {
                        console.log(error);
                        this.error = error;
                    });
            }
            //Loan Frequency
            if (event.target.name == 'loanProduct') {
                getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Loan Frequency', pickVal1: this.quoteForm.loanProduct, pickVal2: '' })
                    .then(result => {
                        let options = [];
                        for (var key in result) {
                            options.push({ label: result[key].label, value: result[key].value });
                        }
                        this.quoteForm.loanFrequency = "";
                        this.loanFrequencyOptions = options;
                    })
                    .catch(error => {
                        console.log(error);
                        this.error = error;
                    });
            }
        }


        //CommRate
        getRateSetterRate({
            param: this.quoteForm
        })
            .then((param) => {
                // console.log('getRateSetterRate==>'+param.commRate.toString());
                this.quoteForm.commRate = param.commRate;
            })
            .catch((error) => reject(error));

        console.log('quoteform::', JSON.stringify(this.quoteForm, null, 2));

        // --------------
    }

    handleTypeChange(event) {
        this.quoteForm.typeValue = event.target.value;
        console.log('this.quoteForm.typeValue: ', this.quoteForm.typeValue);
        this.resPerDisable();
    }

    // Calculations
    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
    }

    get netRealtimeNaf() {
        return CalHelper.getNetRealtimeNaf(this.quoteForm);
    }

    get disableAction() {
        return !this.isCalculated;
    }

    resPerDisable() {
        // console.log(`come here ${CalHelper.options.typeValues[0]}`);
        let tmp;
        this.quoteForm.typeValue === CalHelper.options.typeValues[0].value ? tmp = true : tmp = false;
        this.resDisable.per = !tmp;
        this.resDisable.val = tmp;
    }

    // Reset
    reset() {

        this.quoteForm = CalHelper.reset(this.recordId);
        //this.quoteForm = CalHelper.reset(oppID);
        /*console.log(
        "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );*/
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
            .then((data) => {
                //console.log(`Data loaded!`);
                this.quoteForm.baseRate = data.baseRate;
                //this.quoteForm.maxRate = data.maxRate;
                // this.quoteForm.clientRate = data.clientRate;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
            })
            .finally(() => {
                this.clientRateCalc();
                this.isBaseRateBusy = false;
            });
    }

    // Client Rate() 
    clientRateCalc() {
        console.log('clientRate::', JSON.stringify(CalHelper.getClientRateCalc(this.quoteForm), null, 2));
        this.quoteForm.clientRate = CalHelper.getClientRateCalc(this.quoteForm);
    }

    // Fees Calculations
    calculateFees() {
        const NAF = CalHelper.getNetRealtimeNaf(this.quoteForm);
        this.quoteForm.maxDof = ((this.quoteForm.dof != null) ? (NAF - this.quoteForm.dof) : NAF) * 0.08;
        console.log("NAF ==>" + NAF);
        console.log("maxDof ==>" + this.quoteForm.maxDof);
        /*CalHelper.calcFees(this.quoteForm) 
        .then((data) => {
            console.log('==> calcFees data ', JSON.stringify(data));
            this.quoteForm.applicationFee = data.applicationFee;
            this.quoteForm.maxApplicationFee = data.maxApplicationFee;
            this.quoteForm.dof = data.dof;
            rhis.quoteForm.maxDof = data.maxDof;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            //displayToast(this, "Calc Fees...", error, "error");
        })
        .finally(() => {
            //this.isBaseRateBusy = false;
        });*/
    }

    // -------------
    // Button events
    // -------------

    // Calculate
    handleCalculate(type) {
        this.isBusy = true;
        this.messageObj = QuoteCommons.resetMessage();
        CalHelper.calculate(this.quoteForm)
            .then((data) => {
                console.log("@@data:", JSON.stringify(data, null, 2));
                this.quoteForm.commissions = data.commissions;
                this.messageObj = data.messages;
                QuoteCommons.handleHasErrorClassClear(this);
                // --- insurance ---
                if (this.quoteForm.commissions && type != "load") {
                    this.isCalculated = true;
                    this.template.querySelector(
                        "c-quote-insurance-form"
                    ).isQuoteCalculated = true;
                }
                // --- insurance: end ---
            })
            .catch((error) => {
                if (type !== "load") {
                    this.messageObj = error.messages;
                    QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                    console.error(
                        "quotePepperMVCalc.js: get errors -- ",
                        JSON.stringify(error.messages.errors, null, 2)
                    );
                }
            })
            .finally(() => {
                this.isBusy = false;
            });
    }

    // Reset
    handleReset(event) {

        const appQuoteId = this.quoteForm["Id"];
        this.reset();
        this.quoteForm["Id"] = appQuoteId;
        this.isCalculated = false;
        this.messageObj = QuoteCommons.resetMessage();
        QuoteCommons.handleHasErrorClassClear(this);
        /*console.log(
        "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );*/
        this.baseRateCalc();
        // --- insurance ---
        this.template.querySelector("c-quote-insurance-form").resetPressed();
        // --- insurance: end ---
    }

    // all Save Buttons actions
    handleSave(event, saveType) {
        let isNONE;
        let loanType;
        if (event) {
            console.log(`event detail : ${event.target.value.toUpperCase()}`);
            isNONE = event.target.value.toUpperCase() === "NONE";
            loanType = event.target.value.toUpperCase();
        } else {
            // --- insurance ---
            loanType = saveType.toUpperCase();
            // --- insurance: end ---
        }
        console.log("save type => ", loanType);
        this.isBusy = true;
        if (!this.messageObj.errors.length > 0 || this.isErrorInsuranceOnly()) {
            this.messageObj = QuoteCommons.resetMessage();
            CalHelper.saveQuote(loanType, this.quoteForm, this.recordId)
                .then((data) => {
                    console.log("@@data in handleSave:", JSON.stringify(data, null, 2));
                    !isNONE
                        ? this.messageObj.confirms.push(
                            {
                                field: "confirms",
                                message: "Calculation saved successfully."
                            },
                            {
                                fields: "confirms",
                                message: "Product updated successfully."
                            }
                        )
                        : this.messageObj.confirms.push({
                            field: "confirms",
                            message: "Calculation saved successfully."
                        });
                    // passing data to update quoteform
                    this.quoteForm["Id"] = data["Id"];
                })
                .catch((error) => {
                    console.error("handleSave : ", error);
                })
                .finally(() => {
                    this.isBusy = false;
                    // --- insurance ---
                    this.quoteForm.commissions.insurance =
                        loanType === "Send" ? 0.0 : this.quoteForm.commissions.insurance;
                    // --- insurance: end ---
                });
        } else {
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            this.isCalculated = true;
        }
    }


    // Send Email - CURRENTLY DISABLE DUE UNFINISHED COMMON COMPS
    handleSendQuote() {

        this.isBusy = true;
        if (!this.messageObj.errors.length > 0) {
            this.messageObj = QuoteCommons.resetMessage();
            CalHelper.sendEmail(this.quoteForm, this.recordId)
                .then((data) => {
                    console.log(
                        "@@data in handle send quote :",
                        JSON.stringify(data, null, 2)
                    );
                    this.messageObj.infos.push({
                        field: "infos",
                        message: "Email has been sent to customer."
                    });
                })
                .catch((error) => {
                    console.error("handleSendQuote: ", error);
                })
                .finally(() => {
                    this.isBusy = false;
                });
        } else {
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            this.isCalculated = true;
        }
    }

    residualCalc() {
        if (this.quoteForm.typeValue === 'Value' && this.quoteForm.residualValue > 0) {
            this.quoteForm.residualPer = CalHelper.getResiPer(this.quoteForm);
        }
        else if (this.quoteForm.typeValue === 'Percentage' && this.quoteForm.residualPer > 0) {
            this.quoteForm.residualValue = CalHelper.getResiVal(this.quoteForm);
        }
    }

    // --- insurance ---
    handleInsuranceMessage(event) {
        try {
            this.messageObj = QuoteCommons.resetMessage();
            this.messageObj.errors = [
                ...this.messageObj.errors,
                ...event.detail.errors
            ];
            console.log(
                "event.detail >> " + JSON.stringify(this.messageObj.errors, null, 2)
            );
        } catch (error) {
            console.error(error);
        }
    }

    isErrorInsuranceOnly() {
        let result = true;
        try {
            if (this.messageObj.errors && this.messageObj.errors.length > 0) {
                for (const error of this.messageObj.errors) {
                    if (error.field !== "insurance") {
                        return false;
                    }
                }
            }
            return result;
        } catch (error) {
            console.error(error);
        }
    }

    handleInsuranceChange(event) {
        this.quoteForm.insurance = event.detail;
        this.isCalculated = this.template.querySelector(
            "c-quote-insurance-form"
        ).isQuoteCalculated = false;

        // comprehensive
        const cms = QuoteCommons.handleComprehensive(this.quoteForm);
        this.quoteForm.commissions = { ...cms };
        // end - comprehensive
        console.log(
            "handle insurance change >>  " + JSON.stringify(this.quoteForm, null, 2)
        );
    }

    handleInsurancePresentation(event) {
        console.log(event.detail);
        this.handleSave(null, event.detail);
    }

    handleInsuanceLoad(event) {
        this.handleInsuranceChange(event);
        // check if there is no acceptance
        if (
            this.quoteForm.insurance.ismvAccept ||
            this.quoteForm.insurance.isshortfallAccept ||
            this.quoteForm.insurance.iswarrantyAccept ||
            this.quoteForm.insurance.isLPIAccept ||
            this.quoteForm.insurance.isIntegrityAccept
        ) {
            this.handleCalculate("load");
        } else {
            this.quoteForm.commissions = {
                ...this.quoteForm.commissions,
                insurances: null
            };
        }
        this.console.log(
            "handleInsuanceLoad>>",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    handleDisableButton(event) {
        this.isCalculated = event.detail;
    }
    // --- insurance: end ---
}