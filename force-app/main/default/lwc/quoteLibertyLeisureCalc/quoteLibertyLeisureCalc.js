import { api, LightningElement, track, wire } from 'lwc';
import LENDER_LOGO from "@salesforce/resourceUrl/LibertyLogo";
import BOTTOM_IMAGE from "@salesforce/resourceUrl/LibertyConsumerRates";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLibertyLeisureCalcHelper";
import { getRecord } from 'lightning/uiRecordApi';
import { displayToast } from "c/partnerJsUtils";

export default class QuoteLibertyLeisureCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
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
                console.log(`Data loaded!`, JSON.stringify(this.quoteForm));
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
        return this.quoteForm.realtimeNaf;
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
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Reset
    handleReset(event) {
        const appQuoteId = this.quoteForm["Id"];
        this.reset();
        this.quoteForm["Id"] = appQuoteId;
        this.isCalculated = false;
        this.messageObj = QuoteCommons.resetMessage();
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
        // --- insurance ---
        this.template.querySelector("c-quote-insurance-form").resetPressed();
        // --- insurance: end ---
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

        // Insurances
        QuoteCommons.calculateInsurances(this, fldName);
        // --------------
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