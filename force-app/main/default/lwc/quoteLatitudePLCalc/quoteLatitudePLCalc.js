import { api, LightningElement, track, wire } from 'lwc';
import LENDER_LOGO from "@salesforce/resourceUrl/LatitudeLogo3";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLatitudePLCalcHelper";
import { getRecord } from 'lightning/uiRecordApi';
import { displayToast } from "c/partnerJsUtils";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteLatitudePLCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;

    @api recordId;
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;

    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded!`);
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

        console.log('recordID::', this.recordId)
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
                this.calcFees();
            });
    }

    // Calculate Quote Fees
    calcFees() {
        CalHelper.getQuoteFees(this.quoteForm)
            .then((data) => {
                console.log(`Data loaded!`);
                this.quoteForm.ppsr = data.ppsr;
                this.quoteForm.registrationFee = data.registrationFee;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
            })
            .finally(() => {
                this.isBaseRateBusy = false;
            });
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

    get assetAgeOptions() {
        return CalHelper.options.vehicleAges;
    }

    get clientTierOptions() {
        return CalHelper.options.clientTiers;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get riskGradeOptions() {
        return CalHelper.options.riskGrades;
    }

    get securedUnsecuredOptions() {
        return CalHelper.options.securedUnsecured;
    }

    get logoUrl() {
        return LENDER_LOGO;
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

    // -------------
    // Button events
    // -------------

    // Calculate
    handleCalculate(event) {
        // this.isBusy = true;
        // CalHelper.calculate(this.quoteForm)
        // .then((data) => {
        //     console.log("@@data:", JSON.stringify(data, null, 2));
        //     this.quoteForm.commissions = data.commissions;
        //     // displayToast(this, "Calculate", "Done!", "info");
        //     this.messageObj = data.messages;
        //     QuoteCommons.handleHasErrorClassClear(this);
        //     if (this.quoteForm.commissions) this.isCalculated = true;
        // })
        // .catch((error) => {
        //     this.messageObj = error.messages;
        //     QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
        //     console.error(
        //     "quotePepperMVCalc.js: get errors -- ",
        //     JSON.stringify(error.messages.errors, null, 2)
        //     );
        // })
        // .finally(() => {
        //     this.isBusy = false;
        // });

        // if (results && Array.isArray(results) && results.length > 0) {
        // // this.quoteResult = results[0];
        // }
        // this.baseRateCalc();
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
        // this.reset();
        // this.messageObj = QuoteCommons.resetMessage();
        // this.isCalculated = false;
        // QuoteCommons.handleHasErrorClassClear(this);
        // console.log(
        // "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
        // JSON.stringify(this.quoteForm, null, 2)
        // );
        // this.baseRateCalc();
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
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }

        // --------------
    }


}