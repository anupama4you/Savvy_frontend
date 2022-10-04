import { LightningElement, track, api, wire } from 'lwc';
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteUMELoansCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/UMELoansLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteUMELoansCalc extends LightningElement {
    @track isBusy;
    @track isBaseRateBusy;
    @track isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
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
            });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
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
        }
        this.quoteForm[fldName] = v;
        fldName === "term"
            ? (this.quoteForm[fldName] = parseInt(v))
            : (this.quoteForm[fldName] = v);
        // this.quoteForm.dof = 
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        if (CalHelper.DOF_SETTING_NAMES.includes(fldName)) {
            console.log(`into DOF part`);
            this.quoteForm.dof = this.maxDOF;
            this.quoteForm.maxDof = this.maxDOF;

        }
    }

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
        this.reset();
        this.quoteForm.typeValue = "Value";
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "🚀 ~ file: QuotePepperLeisureCalc.js ~  QuotePepperLeisureCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
        // --- insurance ---
        this.template.querySelector("c-quote-insurance-form").resetPressed();
        // --- insurance: end ---
    }

    // all Save Buttons actions
    handleSave(event, saveType) {
        // console.log(`event detail : ${event.target.value.toUpperCase()}`);
        // const isNONE = event.target.value.toUpperCase() === "NONE";
        // this.isBusy = true;
        // const loanType = event.target.value.toUpperCase();
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

    get maxDOF() {
        const maxDof = this.calculateMaxDof(this.quoteForm, 0.11);
        return maxDof > this.quoteForm.maxDof ? this.quoteForm.maxDof : maxDof;
    }

    calculateMaxDof(quoteForm, rate) {
        let r = 0;
        quoteForm.price && (r += quoteForm.price);
        r -= this.netDeposit;
        return r * rate;
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

    get termOptions() {
        return CalHelper.options.terms;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get netRealtimeNaf() {
        return CalHelper.getNetRealtimeNaf(this.quoteForm);
    }

    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
    }

    get disableAction() {
        return !this.isCalculated;
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