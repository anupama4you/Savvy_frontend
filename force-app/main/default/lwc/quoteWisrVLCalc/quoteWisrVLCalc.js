import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteWisrVLCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/WisrLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteWisrVLCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    tableFeesCols = CalHelper.tableFeeDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    isDofInputed = false;
    isApplicationFeeInputed = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;
    // -

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
        .then((data) => {
            console.log(`CalHelper: Data loaded!`, data);
            this.quoteForm = data;
            this.tableRates = CalHelper.getTableRatesData();
            console.log('@@tableRates', JSON.stringify(this.tableRates));
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Loading...", error, "error");
        })
        .finally(() => {
            this.isBusy = false;
            console.log('is busy', this.isBusy);
            this.baseRateCalc();
            this.maxFeeDofCalc();
        });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
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

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }
    
    get termOptions() {
        return CalHelper.options.terms;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get profileOptions() {
        return CalHelper.options.profiles;
    }

    get vehicleYearOptions() {
        return CalHelper.options.vehicleYears;
    }

    get clientRateOptions() {
        return CalHelper.createClientRateOptions(this.quoteForm);
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
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        // --------------
        // Trigger events
        // --------------
        // casting the string to number
        if (fldName === "term") {
            this.quoteForm[fldName] = parseInt(v);
        } else if (fldName === "clientRate") {
            this.quoteForm[fldName] = parseFloat(v);
        } else {
            this.quoteForm[fldName] = v;
        }
        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
        if (fldName === "dof") {
            if(v !== "" || v !== 0) {
                this.isDofInputed = true;
            } else {
                this.isDofInputed = false;
            }
        }
        if (fldName === "applicationFee") {
            if(v !== "" || v !== 0) {
                this.isApplicationFeeInputed = true;
            } else {
                this.isApplicationFeeInputed = false;
            }
        }
        if(CalHelper.APPLICATION_FEE_DOF_FIELDS.includes(fldName)) {
            this.maxFeeDofCalc();
        }

        // --------------
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

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
        console.log(
        "🚀 ~ file: QuoteWisrVLCalc.js ~ line 130 ~ QuoteWisrVLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
        .then((data) => {
            console.log(`baseRateCalc Data loaded!`);
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

    // Max Application Fee and DOF 
    maxFeeDofCalc() {
        console.log(`maxFeeDofCalc...`);
        let maxValues = CalHelper.maxFees(this.quoteForm);
        this.quoteForm.maxDof = maxValues.maxDof;
        this.quoteForm.maxApplicationFee = maxValues.maxApplicationFee;
        if(this.quoteForm.dof === "" || this.quoteForm.dof === null || !this.isDofInputed || this.quoteForm.dof === 0) {
            this.quoteForm.dof = this.quoteForm.maxDof;
        }
        if(this.quoteForm.applicationFee === "" || this.quoteForm.applicationFee === null || this.quoteForm.applicationFee === 0 || !this.isApplicationFeeInputed) {
            this.quoteForm.applicationFee = this.quoteForm.maxApplicationFee;
        }
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
            this.messageObj = error.messages;
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            console.error(
            "QuoteWisrVLCalc.js: get errors -- ",
            JSON.stringify(error.messages.errors, null, 2)
            );
        })
        .finally(() => {
            this.isBusy = false;
        });
    }

    // Reset
    handleReset(event) {
        this.reset();
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
        "🚀 ~ file: QuoteWisrVLCalc.js ~ line 172 ~ QuoteWisrVLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
    }

    // all Save Buttons actions
    handleSave(event) {
        console.log(`event detail : ${event.target.value.toUpperCase()}`);
        const isNONE = event.target.value.toUpperCase() === "NONE";
        this.isBusy = true;
        const loanType = event.target.value.toUpperCase();
        if (!this.messageObj.errors.length > 0) {
            this.messageObj = QuoteCommons.resetMessage();
            let creditScore = this.quoteForm.creditScore;
            this.quoteForm.creditScore = creditScore.toString();
            let lvr = this.quoteForm.lvr;
            this.quoteForm.lvr = lvr.toString();
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