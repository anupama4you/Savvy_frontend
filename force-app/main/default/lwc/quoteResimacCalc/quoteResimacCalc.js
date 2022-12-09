import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteResimacCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/Resimac";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";
import RESIDUAL_GUIDE_LINES from "@salesforce/resourceUrl/ResimacRateAddOns";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteResimacCalc extends LightningElement {
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    @track applicationFee;
    // Rate Settings
    @track tableRates1;
    @track tableRatesCols1 = CalHelper.tableRateDataColumns1;
    @track typeValue = "Value";
    @track disableResidualPercentage = true;
    @track disableResidualValue = false;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`CalHelper: Data loaded!`, JSON.stringify(data, null, 2));
                this.quoteForm = data;
                this.quoteForm.term = this.quoteForm.term ? this.quoteForm.term.toString() : "0";
                this.quoteForm.assetAge = this.quoteForm.assetAge ? this.quoteForm.assetAge.toString() : "1";
                this.applicationFee = this.quoteForm.applicationFee;
                this.tableRates1 = CalHelper.getTableRatesData1();
                this.quoteForm.maxApplicationFee = data.privateSales == 'Y' ? this.quoteForm.applicationFeePrivate : this.quoteForm.applicationFeeMax;
                // this.quoteForm.dof = data.privateSales == 'Y' ? this.quoteForm.dofPrivate : this.quoteForm.dofMAx;
                const naf = this.netRealtimeNaf;
                console.log('naf: ', naf);
                this.quoteForm.maxBrokeragePercentage = naf < 50000 ? this.quoteForm.maxBrokerage : 8.8;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.quoteForm.assetAge = this.quoteForm.assetAge ? this.quoteForm.assetAge : 1;
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

    get assetCateOptions() {
        return CalHelper.options.assetCategories;
    }
    get assetAgeOptions() {
        return CalHelper.options.assetAges;
    }

    get propertyOwnerOptions() {
        return CalHelper.options.propertyOwnerTypes;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get abnOptions() {
        return CalHelper.options.abnGsts;
    }

    // get gstOptions() {
    //     return CalHelper.options.gsts;
    // }

    get residualGuideLines() {
        return RESIDUAL_GUIDE_LINES;
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
        if (fldName === "privateSales") {
            // this.quoteForm.dof = data.privateSales == 'Y' ? this.quoteForm.dofPrivate : this.quoteForm.dofMAx;
            if ("Y" === v) {
                this.quoteForm.applicationFee = this.quoteForm.applicationFeePrivate;
                this.quoteForm.maxApplicationFee = this.quoteForm.applicationFeePrivate;
                // this.quoteForm.dof = this.quoteForm.dofPrivate;
            } else {
                this.quoteForm.applicationFee = this.quoteForm.applicationFeeMax;
                this.quoteForm.maxApplicationFee = this.quoteForm.applicationFeeMax;
                // this.quoteForm.dof = this.quoteForm.dofMAx;
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

        this.quoteForm.netDeposit = this.netDeposit;
        this.quoteForm.maxBrokeragePercentage = this.netRealtimeNaf < 50000 ? this.quoteForm.maxBrokerage : 8.8;
    }

    // Calculations
    get netDeposit() {
        this.quoteForm.netDeposit = CalHelper.getNetDeposit(this.quoteForm);
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
        this.quoteForm.applicationFee = this.quoteForm.applicationFeeMax;
        this.quoteForm.maxApplicationFee = this.quoteForm.applicationFeeMax;
        this.quoteForm.maxBrokeragePercentage = this.netRealtimeNaf < 50000 ? this.quoteForm.maxBrokerage : 8.8;
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
                this.quoteForm.recomBaseRate = data.recomBaseRate;
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
        if (this.typeValue === "Value") {
            this.disableResidualValue = false;
            this.disableResidualPercentage = true;
            if (this.quoteForm.residualValue > 0) {
                this.quoteForm.residualValuePercentage = CalHelper.getResidualPercentage(this.quoteForm);
            }
        } else {
            this.disableResidualValue = true;
            this.disableResidualPercentage = false;
            if (this.quoteForm.residualValuePercentage > 0) {
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