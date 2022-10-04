import { LightningElement, track, api, wire } from 'lwc';
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteCapitalFinanceCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/CapitalFinanceLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteCapitalFinanceCalc extends LightningElement {
    @track tableRatesCols = CalHelper.tableRateDataColumns;
    @track table = CalHelper.tables;
    @track tableData = {};
    @track isBusy;
    @track isBaseRateBusy;
    @track isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    @track resDisable;
    // Rate Settings
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
                this.tableData.data1 = CalHelper.tableDatas.tableRatesData1();
                this.tableData.data2 = CalHelper.tableDatas.tableRatesData2();
                this.tableData.data3 = CalHelper.tableDatas.tableRatesData3();
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
    }

    // get clientRate() {
    //     return CalHelper.clientRate(this.quoteForm);
    // }

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

        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
        this.residualCalc();
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
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
                    "quotePepperMVCalc.js: get errors -- ",
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

    resPerDisable() {
        // console.log(`come here ${CalHelper.options.typeValues[0]}`);
        let tmp;
        this.quoteForm.typeValue === CalHelper.options.typeValues[0].value ? tmp = true : tmp = false;
        this.resDisable.per = !tmp;
        this.resDisable.val = tmp;
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

    get abnLengthOptions() {
        return CalHelper.options.abnLengths;
    }

    get gstLengthOptions() {
        return CalHelper.options.gstLengths;
    }

    get assetAgeOptions() {
        return CalHelper.options.assetAges;
    }

    get propOwnOptions() {
        return CalHelper.options.propOwns;
    }

    get privateSaleOptions() {
        return CalHelper.options.privateSales;
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

    get typeValueOptions() {
        return CalHelper.options.typeValues;
    }

}