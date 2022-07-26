import { api, LightningElement, track, wire } from 'lwc';
import LENDER_LOGO from "@salesforce/resourceUrl/LibertyLogo";
import BOTTOM_IMAGE from "@salesforce/resourceUrl/LibertyConsumerRates";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLibertyCalcHelper";
import { getRecord } from 'lightning/uiRecordApi';
import { displayToast } from "c/partnerJsUtils";

export default class QuoteLibertyCalc extends LightningElement {
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    category;
    @api recordId;
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;

    // table data
    @track tableRates;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded!`);
                this.quoteForm = data;
                console.log(`DOF>>>`, this.quoteForm.dof, `--`, this.quoteForm.maxDof);
                // this.quoteForm.dof = data.maxDof;
                console.log(`Data loaded!`, JSON.stringify(this.quoteForm));
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.baseRateCalc();

            });

        console.log('recordID::', this.recordId)
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        console.log('quote form::', JSON.stringify(this.quoteForm, null, 2));
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

    // DOF calculation
    dofCalc() {
        this.quoteForm.dof = CalHelper.getDOF(this.quoteForm);
        this.quoteForm.maxDof = this.quoteForm.dof;
    }

    // Quote Fee calculation
    calcFees() {
        const quote = CalHelper.getQuoteFees(this.quoteForm);
        this.quoteForm.ppsr = quote.ppsr;
        this.quoteForm.registrationFee = quote.registrationFee;
        this.isBaseRateBusy = false;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get securedUnsecuredOptions() {
        return CalHelper.options.securedUnsecured;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get classOptions() {
        return CalHelper.options.classes;
    }

    get vehicleTypes() {
        return CalHelper.options.vehicleTypes;
    }

    get propertyOwners() {
        return CalHelper.options.propertyOwners;
    }

    get vehicleConditionOptions() {
        return CalHelper.options.vehicleConditions;
    }

    get vehicleAges() {
        return CalHelper.options.vehicleAges;
    }

    get riskGrades() {
        return CalHelper.options.riskGrades;
    }

    get logoUrl() {
        return LENDER_LOGO;
    }

    get bottomImageURL() {
        return BOTTOM_IMAGE;
    }

    // Common calculations
    get netDeposit() {
        this.quoteForm.netDeposit = CalHelper.getNetDeposit(this.quoteForm);
        return this.quoteForm.netDeposit;
    }

    get netRealtimeNaf() {
        this.quoteForm.realtimeNaf = CalHelper.getNetRealtimeNaf(this.quoteForm);
        return CalHelper.getNetRealtimeNaf(this.quoteForm);
    }

    get realtimeEqFee() {
        this.quoteForm.eqfee = CalHelper.getRealtimeEqFee(this.quoteForm);
        return this.quoteForm.eqfee;
    }

    get disableAction() {
        return !this.isCalculated;
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
                // displayToast(this, "Calculate", "Done!", "info");
                this.messageObj = data.messages;
                QuoteCommons.handleHasErrorClassClear(this);
                if (this.quoteForm.commissions) this.isCalculated = true;
            })
            .catch((error) => {
                console.error(
                    "quoteLatitudePLCalc.js: get errors -- ",
                    JSON.stringify(error.messages.errors, null, 2)
                );
                this.messageObj = error.messages;
                QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                console.error(
                    "quoteLatitudePLCalc.js: get errors -- ",
                    JSON.stringify(error.messages.errors, null, 2)
                );
            })
            .finally(() => {
                this.isBusy = false;
            });

        if (results && Array.isArray(results) && results.length > 0) {
            // this.quoteResult = results[0];
        }
        this.baseRateCalc();
    }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Reset
    handleReset(event) {
        this.reset();
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
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
        fldName === "ltv"
            ? (this.quoteForm[fldName] = v.toString())
            : (this.quoteForm[fldName] = v);
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }

        // DOF calculation
        if (fldName === "applicationFee") this.dofCalc();

        // --------------
    }

    // all Save Buttons actions
    handleSave(event) {
        console.log(`event detail : ${event.target.value.toUpperCase()}`);
        const isNONE = event.target.value.toUpperCase() === "NONE";
        this.isBusy = true;
        const loanType = event.target.value.toUpperCase();
        try {
            if (!this.messageObj.errors.length > 0) {
                this.messageObj = QuoteCommons.resetMessage();
                console.log(
                    "@@QuoteForm before saving :",
                    JSON.stringify(this.quoteForm, null, 2)
                );
                CalHelper.saveQuote(loanType, this.quoteForm, this.recordId)
                    .then((data) => {
                        console.log(
                            "@@data in handle save quote:",
                            JSON.stringify(data, null, 2)
                        );
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
                        console.error("handlePreApproval : ", error);
                    })
                    .finally(() => {
                        this.isBusy = false;
                    });
            } else {
                QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                this.isCalculated = true;
            }
        } catch (error) {
            console.error(error);
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