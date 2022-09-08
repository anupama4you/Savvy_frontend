import { LightningElement, track, api, wire } from 'lwc';
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGrowBusinessCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/GrowLogo";

import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteGrowBusinessCalc extends LightningElement {

    // @track tableRatesCols = CalHelper.tableRateDataColumns;
    @track isBusy;
    @track isBaseRateBusy;
    @track isCalculated = false;
    @api recordId;      // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    // @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded!** ${JSON.stringify(data, null, 2)}`);
                this.quoteForm = data;
                // this.tableRates = CalHelper.getTableRatesData();
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

    findCreditObj(tb, cs) {
        return tb.find(({ Credit_Score__c }) => Credit_Score__c === cs);
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get abnLengthOptions() {
        return CalHelper.options.abnLengths;
    }

    get gstLengthOptions() {
        return CalHelper.options.gstLengths;
    }

    get propOwnOptions() {
        return CalHelper.options.propOwns;
    }

    get termOptions() {
        return CalHelper.options.terms;
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
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
        if (fldName === "baseRate" || fldName === "brokeragePercentage") {
            this.quoteForm.clientRate = CalHelper.getClientRateCalc(this.quoteForm);
        }
        if (fldName === "price") {
            // this.quoteForm.projPer = CalHelper.getProjctetedPer(this.quoteForm.price);
            CalHelper.getProjctetedPer(this.quoteForm.price)
                .then(data => {
                    this.quoteForm.projPer = data;
                    console.log('AFTER PRICE ', JSON.stringify(this.quoteForm, null, 2));
                });
        }

        fldName === "equifaxScore" && (this.quoteForm.equifaxScore = v.toString());
    }

    // Calculations
    get netDeposit() {
        const netDep = CalHelper.getNetDeposit(this.quoteForm);
        this.quoteForm.netDeposit = netDep;
        return netDep;
    }

    get netRealtimeNaf() {
        return CalHelper.getNetRealtimeNaf(this.quoteForm);
    }

    get disableAction() {
        return !this.isCalculated;
    }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset();
        console.log(
            "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        console.log('IN BASE: this.quoteForm: ', this.quoteForm);
        CalHelper.baseRates(this.quoteForm)
            .then((data) => {
                console.log(`Data loaded!`);
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
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
        // console.log('isBusy: ', JSON.stringify(this.quoteForm, null, 2));
        console.log('isBusy');
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
            // this.quoteResult = results[0];
        }
        // this.baseRateCalc();
    }


    // Reset
    handleReset(event) {
        this.reset();
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "🚀 ~ file: QuotePepperLeisureCalc.js ~  QuotePepperLeisureCalc ~ reset ~ this.quoteForm",
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

    get testVal() {
        console.log(`run to testVAL`);
        // this.quoteForm && CalHelper.getClientRateCalc(this.quoteForm);
        return (this.quoteForm.baseRate + 0.73 * this.quoteForm.brokeragePercentage);
    }

    get testMax() {
        return 1.2;
    }

}