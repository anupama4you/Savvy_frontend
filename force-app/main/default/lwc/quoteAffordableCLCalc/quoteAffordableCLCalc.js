import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAffordableCLCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/ACLLogo";
import AFFORDABLE_TABLE from "@salesforce/resourceUrl/Affordable";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteAffordableCLCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @track aclUpfrontLoanFees;
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
            this.aclUpfrontLoanFees = CalHelper.getAclUpfrontLoanFees();
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
        });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

    get logoUrl() {
        return LENDER_LOGO;
    }

    get tableUrl() {
        return AFFORDABLE_TABLE;
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

    get repaymentOptions() {
        return CalHelper.options.repaymentTypes;
    }

    get commissionTypeOptions() {
        return CalHelper.options.commissionTypes;
    }

    get vehicleYearOptions() {
        return CalHelper.options.vehicleYears;
    }

    get creditScoreOptions() {
        return CalHelper.options.creditScores;
    }

    get isCommissionManual() {
        return this.quoteForm.commissionType === "Manual";
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
        if (fldName === "term" && v !== "") {
            this.quoteForm[fldName] = parseInt(v);
        } else if (fldName === "clientRate") {
            this.quoteForm[fldName] = parseFloat(v);
        } else {
            this.quoteForm[fldName] = v;
        }
        // Base Rate Calculation
        if (CalHelper.RATES_AND_FEES_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
        // --------------
    }

    // Calculations
    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
    }

    get netRealtimeNaf() {
        return CalHelper.getTotalAmount(this.quoteForm);
    }

    get disableAction() {
        return !this.isCalculated;
    }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
        console.log(
        "🚀 ~ file: QuoteACLCalc.js ~ line 130 ~ QuoteACLCalc ~ reset ~ this.quoteForm",
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
            this.quoteForm.maxApplicationFee = data.maxApplicationFee,
            this.quoteForm.applicationFee = data.applicationFee,
            this.quoteForm.riskFeeTotal = data.riskFeeTotal
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Rates and Fees...", error, "error");
        })
        .finally(() => {
            this.isBaseRateBusy = false;
        });
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
            "QuoteACLCalc.js: get errors -- ",
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
        "🚀 ~ file: QuoteACLCalc.js ~ line 172 ~ QuoteACLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
    }

    // all Save Buttons actions
    handleSave(event) {
        console.log(`event detail : ${event.target.value.toUpperCase()}`, this.messageObj.errors.length);
        const isNONE = event.target.value.toUpperCase() === "NONE";
        this.isBusy = true;
        const loanType = event.target.value.toUpperCase();
        if (!this.messageObj.errors.length > 0) {
            this.messageObj = QuoteCommons.resetMessage();
            let creditScore = this.quoteForm.creditScore;
            this.quoteForm.creditScore = creditScore.toString();
            
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