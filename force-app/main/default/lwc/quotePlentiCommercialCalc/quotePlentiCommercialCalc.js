import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePlentiCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/PlentiLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getRateSetterRate from "@salesforce/apex/QuoteManager.getRateSetterRate";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
//const oppID = 'a01Bm00000192uuIAA'; 
export default class QuotePlentiCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                this.quoteForm = data;
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
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

    //Images
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

    get assetTypeOptions() {
        return CalHelper.options.assetTypes;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get customerProfileOptions() {
        return CalHelper.options.customerProfiles;
    }

    get clientTierOptions() {
        return CalHelper.options.clientTiers;
    }

    get vehicleConditionOptions() {
        return CalHelper.options.vehicleConditions;
    }

    get greenCarOptions() {
        return CalHelper.options.greenCars;
    }

    get vehicleYearOptions() {
        return CalHelper.options.vehicleYears;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get plentiAPIUserOptions() {
        return CalHelper.options.plentiAPIUsers;
    }

    get abnLengthOptions() {
        return CalHelper.options.abnLengths;
    }

    // Events
    handleFieldChange(event) {
        console.log(`Changing value for: ${event.target.name}...`);
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        console.log(`new value: ${event.target.value}...`);
        if (fld && fld.type === "number") {
            v = Number(v);
        }
        this.quoteForm[fldName] = v;
        this.quoteForm["netDeposit"] = this.netDeposit;
        fldName === "term"
            ? (this.quoteForm[fldName] = parseInt(v))
            : (this.quoteForm[fldName] = v);
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            console.log('==> SHOOT HERE Base Rate Calculation handlefieldchange');
            this.baseRateCalc();
        }

        // Fees Calculation
        if (CalHelper.CALC_FEES_FIELDS.includes(fldName)) {
            console.log('==> SHOOT HERE CALC_FEES_FIELDS Calculation handlefieldchange');
            this.calculateFees();
        }

        //CommRate
        getRateSetterRate({
            param: this.quoteForm
        })
            .then((param) => {
                console.log('getRateSetterRate==>' + param.commRate.toString());
                this.quoteForm.commRate = param.commRate;
            })
            .catch((error) => reject(error));
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
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
            .then((data) => {
                this.quoteForm.baseRate = data.baseRate;
                this.quoteForm.clientRate = data.clientRate;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
            })
            .finally(() => {
                this.isBaseRateBusy = false;
            });
    }

    // Fees Calculations
    calculateFees() {
        this.quoteForm.maxApplicationFee = CalHelper.calcFees(this.quoteForm);
    }

    // -------------
    // Button events
    // -------------

    // Calculate
    handleCalculate(event) {
        try {
            this.isBusy = true;
            this.messageObj = QuoteCommons.resetMessage();
            CalHelper.calculate(this.quoteForm)
                .then((data) => {
                    console.log("@@data:", JSON.stringify(data, null, 2));
                    this.quoteForm.commissions = data.commissions;
                    this.messageObj = data.messages;
                    QuoteCommons.handleHasErrorClassClear(this);
                    if (this.quoteForm.commissions) this.isCalculated = true;
                })
                .catch((error) => {
                    console.error(`error from QuotePlentiCalc ${error}`);
                    this.messageObj = error.messages;
                    QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                    console.error(
                        "quotePlentiCalc.js: get errors -- ",
                        JSON.stringify(error.messages.errors, null, 2)
                    );
                })
                .finally(() => {
                    this.isBusy = false;
                });
        } catch (error) {
            console.error(error);
        }
    }

    // Reset
    handleReset(event) {
        const appQuoteId = this.quoteForm["Id"];
        this.reset();
        this.quoteForm["Id"] = appQuoteId;
        this.isCalculated = false;
        this.messageObj = QuoteCommons.resetMessage();
        QuoteCommons.handleHasErrorClassClear(this);
        this.baseRateCalc();
    }

    // all Save Buttons actions - CURRENTLY DISABLE DUE UNFINISHED COMMON COMPS
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

    // Send Email - CURRENTLY DISABLE DUE UNFINISHED COMMON COMPS
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