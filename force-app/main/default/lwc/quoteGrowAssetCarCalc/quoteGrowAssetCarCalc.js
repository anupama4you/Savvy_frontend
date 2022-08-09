import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGrowAssetCarCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/GrowLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteGrowAssetCarCalc extends LightningElement {
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    @track applicationFee;
    // Rate Settings
    @track tableRates1;
    @track tableRates2;
    @track tableRates3;
    @track tableRates4;
    @track tableRatesCols1 = CalHelper.tableRateDataColumns1;
    @track tableRatesCols2 = CalHelper.tableRateDataColumns2;
    @track typeValue = "Value";
    @track disableResidualPercentage = true;
    @track disableResidualValue = false;
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
            this.quoteForm.term = this.quoteForm.term.toString();
            this.applicationFee = this.quoteForm.applicationFee;
            this.tableRates1 = CalHelper.getTableRatesData1();
            this.tableRates2 = CalHelper.getTableRatesData2();
            this.tableRates3 = CalHelper.getTableRatesData3();
            this.tableRates4 = CalHelper.getTableRatesData4();
            console.log('@@tableRates', JSON.stringify(this.tableRates4));
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Loading...", error, "error");
        })
        .finally(() => {
            this.isBusy = false;
            console.log('is busy line 56', this.isBusy, this.tableRates4);
            this.quoteForm.assetAge = this.quoteForm.assetAge? this.quoteForm.assetAge : 1;
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

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
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

    get typeValueOptions() {
        return CalHelper.options.typeValues;
    }

    get assetAgeOptions() {
        return CalHelper.options.assetAges;
    }

    get abnOptions() {
        return CalHelper.options.abnTypes;
    }

    get propertyOwnerOptions() {
        return CalHelper.options.propertyOwnerTypes;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get creditScoreOptions() {
        return CalHelper.options.creditScores;
    }

    get directorSoleTraderScoreOptions() {
        return CalHelper.options.directorSoleTraderScores;
    }

    get paidDefaultOptions() {
        return CalHelper.options.paidDefaults;
    }

    get conditionOptions() {
        return CalHelper.options.conditions;
    }

    get adverseCreditOptions() {
        return CalHelper.options.adverseCredits;
    }

    get gstLengthOptions() {
        return CalHelper.options.gstLengths;
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
        if (fldName !== "typeValue") {
            this.quoteForm[fldName] = v;
        } else {
            this.typeValue = v;
        }
        if(fldName === "privateSales") {
            if("Y" === v) {
                this.quoteForm.applicationFee = this.quoteForm.applicationFeePrivate;
            } else {
                this.quoteForm.applicationFee = this.applicationFee;
            }
        }
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
    
        // Residual Value Calculation
        
        if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
            this.residualCalc();
        }
        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
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
        "🚀 ~ file: QuoteACLCalc.js ~ line 130 ~ QuoteACLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        console.log('line 208', this.quoteForm.assetAge, this.quoteForm.term);
        CalHelper.baseRates(this.quoteForm)
        .then((data) => {
            console.log(`baseRateCalc Data loaded!`);
            this.quoteForm.baseRate = data.baseRate;
            this.quoteForm.clientRate = data.clientRate;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Base Rate Calculate...", error, "error");
        })
        .finally(() => {
            this.isBaseRateBusy = false;
        });
    }

    residualCalc() {
        console.log('residualCalc', this.typeValue);
        if(this.typeValue === "Value") {
            this.disableResidualValue = false;
            this.disableResidualPercentage = true;
            if(this.quoteForm.residualValue>0) {
                this.quoteForm.residualValuePercentage = CalHelper.getResidualPercentage(this.quoteForm);
            }
        } else {
            this.disableResidualValue = true;
            this.disableResidualPercentage = false;
            if(this.quoteForm.residualValuePercentage>0) {
                this.quoteForm.residualValue = CalHelper.getResidualValue(this.quoteForm);
            }
            
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
            this.quoteForm.naf = CalHelper.getNetRealtimeNaf(this.quoteForm);
            
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