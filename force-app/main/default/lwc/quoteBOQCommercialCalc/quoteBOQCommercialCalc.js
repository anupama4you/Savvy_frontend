import { LightningElement, track, api, wire } from 'lwc';
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteBOQCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/BOQLogo";

import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteBOQCommercialCalc extends LightningElement {
    @track isBusy;
    @track isBaseRateBusy;
    @track isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    @track resDisable;
    @track typeValue;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.resDisable = { per: true, val: false };
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded! ${JSON.stringify(data, null, 2)}`);
                this.quoteForm = data;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.baseRateCalc();
            });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
        this.quoteForm.clientRate = CalHelper.getClientRateCalc(this.quoteForm);
    }

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

    get riskGradeOptions() {
        return CalHelper.options.riskGrades;
    }

    get assetTypeOptions() {
        return CalHelper.options.assetTypes;
    }

    get loanFrequencyOptions() {
        return CalHelper.options.loanFrequencies;
    }


    get termOptions() {
        return CalHelper.options.terms;
    }

    get propOwnerOptions() {
        return CalHelper.options.propOwners;
    }

    get assetAgeOptions() {
        return CalHelper.options.vehicleAges;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get typeValueOptions() {
        return CalHelper.options.typeValues;
    }

    // Events
    handleFieldChange(event) {
        console.log(`Changing value for: ${event.target.name}...`);
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        if (fld && fld.type === "number") {
            v = Number(v);
            console.log('CHANGE TYPE');
        }
        this.quoteForm[fldName] = v;
        fldName === "term"
            ? (this.quoteForm[fldName] = parseInt(v))
            : (this.quoteForm[fldName] = v);

        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }

        if (fldName === "baseRate" || fldName === "brokeragePercentage") {
            this.quoteForm.clientRate = CalHelper.getClientRateCalc(this.quoteForm);
        }

        if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
            this.residualCalc();
        }

        // fldName === "baseRate" && (this.quoteForm.baseRate = parseFloat(v));
        // fldName === "riskGrade" && (this.quoteForm.baseRate = null);
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
    }

    residualCalc() {
        if (this.quoteForm.typeValue === 'Value' && this.quoteForm.residualValue > 0) {
            this.quoteForm.residualPer = CalHelper.getResiPer(this.quoteForm);
        }
        else if (this.quoteForm.typeValue === 'Percentage' && this.quoteForm.residualPer > 0) {
            this.quoteForm.residualValue = CalHelper.getResiVal(this.quoteForm);
        }
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
        let tmp;
        this.quoteForm.typeValue === CalHelper.options.typeValues[0].value ? tmp = true : tmp = false;
        this.resDisable.per = !tmp;
        this.resDisable.val = tmp;
    }

    // get clientRate() {
    //     this.quoteForm.assetCondition === CalHelper.options.assetConditions[0].value ?
    //         this.quoteForm.clientRate = this.quoteForm.baseRate : this.quoteForm.clientRate = this.quoteForm.baseRate + 1;
    //     return this.quoteForm.clientRate || null;
    // }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset();
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // -------------
    // Button events
    // -------------
    // Calculate
    handleCalculate(event) {
        this.isBusy = true;
        CalHelper.calculate(this.quoteForm)
            .then((data) => {
                console.log("@@data:", JSON.stringify(data, null, 2));
                this.quoteForm.commissions = data.commissions;
                this.messageObj = data.messages;
                QuoteCommons.handleHasErrorClassClear(this);
                if (this.quoteForm.commissions) this.isCalculated = true;
            })
            .catch((error) => {
                this.messageObj = error.messages;
                QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                console.error(
                    "quotePepperMVCalc.js: get errors -- ",
                    JSON.stringify(error.messages.errors, null, 2)
                );
            })
            .finally(() => {
                this.isBusy = false;
            });

        if (results && Array.isArray(results) && results.length > 0) {
        }
    }

    // Reset
    handleReset(event) {
        this.reset();
        this.quoteForm.typeValue = "Value";
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "🚀 ~ file: QuotePepperLeisureCalc.js ~  QuotePepperLeisureCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
            .then((data) => {
                console.log(`Data loaded!`);
                this.quoteForm.baseRate = data.baseRate;
                this.quoteForm.maxRate = data.maxRate;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
            })
            .finally(() => {
                this.isBaseRateBusy = false;
            });
    }

    // all Save Buttons actions
    handleSave(event) {
        console.log(`event detail : ${event.target.value.toUpperCase()}`);
        const isNONE = event.target.value.toUpperCase() === "NONE";
        this.isBusy = true;
        const loanType = event.target.value.toUpperCase();
        if (!this.messageObj.errors.length > 0) {
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
                });
        } else {
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            this.isCalculated = true;
        }
    }

    // Send Email
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
}